param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string[]]$Path,
    [switch]$Recurse,
    [switch]$Fix
)

$ErrorActionPreference = "Stop"
$Utf8Strict = New-Object System.Text.UTF8Encoding -ArgumentList $false, $true
$Utf8NoBom = New-Object System.Text.UTF8Encoding -ArgumentList $false

function Get-TextFormat {
    param([byte[]]$Bytes)

    $offset = 0
    $encodingName = "UTF8NoBom"
    $encoding = $Utf8Strict

    if ($Bytes.Length -ge 4 -and $Bytes[0] -eq 0x00 -and $Bytes[1] -eq 0x00 -and $Bytes[2] -eq 0xFE -and $Bytes[3] -eq 0xFF) {
        $encodingName = "UTF32BE-BOM"
        $encoding = New-Object System.Text.UTF32Encoding -ArgumentList $true, $true, $true
        $offset = 4
    } elseif ($Bytes.Length -ge 4 -and $Bytes[0] -eq 0xFF -and $Bytes[1] -eq 0xFE -and $Bytes[2] -eq 0x00 -and $Bytes[3] -eq 0x00) {
        $encodingName = "UTF32LE-BOM"
        $encoding = New-Object System.Text.UTF32Encoding -ArgumentList $false, $true, $true
        $offset = 4
    } elseif ($Bytes.Length -ge 3 -and $Bytes[0] -eq 0xEF -and $Bytes[1] -eq 0xBB -and $Bytes[2] -eq 0xBF) {
        $encodingName = "UTF8-BOM"
        $encoding = New-Object System.Text.UTF8Encoding -ArgumentList $true, $true
        $offset = 3
    } elseif ($Bytes.Length -ge 2 -and $Bytes[0] -eq 0xFF -and $Bytes[1] -eq 0xFE) {
        $encodingName = "UTF16LE-BOM"
        $encoding = New-Object System.Text.UnicodeEncoding -ArgumentList $false, $true, $true
        $offset = 2
    } elseif ($Bytes.Length -ge 2 -and $Bytes[0] -eq 0xFE -and $Bytes[1] -eq 0xFF) {
        $encodingName = "UTF16BE-BOM"
        $encoding = New-Object System.Text.UnicodeEncoding -ArgumentList $true, $true, $true
        $offset = 2
    }

    try {
        $text = $encoding.GetString($Bytes, $offset, $Bytes.Length - $offset)
    } catch {
        return [pscustomobject]@{ IsText = $false; Encoding = "BinaryOrLegacy"; LineEnding = "None"; Text = $null }
    }

    if ($text.IndexOf([char]0) -ge 0) {
        return [pscustomobject]@{ IsText = $false; Encoding = "BinaryOrLegacy"; LineEnding = "None"; Text = $null }
    }

    $crlf = ([regex]::Matches($text, "`r`n")).Count
    $lf = ([regex]::Matches($text, "(?<!`r)`n")).Count
    $cr = ([regex]::Matches($text, "`r(?!`n)")).Count
    if ($crlf -gt 0 -and $lf -eq 0 -and $cr -eq 0) { $lineEnding = "CRLF" }
    elseif ($lf -gt 0 -and $crlf -eq 0 -and $cr -eq 0) { $lineEnding = "LF" }
    elseif ($cr -gt 0 -and $crlf -eq 0 -and $lf -eq 0) { $lineEnding = "CR" }
    elseif (($crlf + $lf + $cr) -eq 0) { $lineEnding = "None" }
    else { $lineEnding = "Mixed" }

    return [pscustomobject]@{ IsText = $true; Encoding = $encodingName; LineEnding = $lineEnding; Text = $text }
}

function Invoke-GitBytes {
    param([string]$WorkingDirectory, [string]$RelativePath, [string]$ObjectSpec)

    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "git.exe"
    $escapedDirectory = $WorkingDirectory.Replace('"', '\"')
    $escapedPath = $RelativePath.Replace('"', '\"')
    $escapedObject = $ObjectSpec.Replace('"', '\"')
    $startInfo.Arguments = "-C `"$escapedDirectory`" cat-file --filters --path=`"$escapedPath`" `"$escapedObject`""
    $startInfo.UseShellExecute = $false
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    [void]$process.Start()
    $memory = New-Object System.IO.MemoryStream
    $process.StandardOutput.BaseStream.CopyTo($memory)
    $errorText = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    if ($process.ExitCode -ne 0) {
        $process.Dispose()
        $memory.Dispose()
        return $null
    }
    $bytes = $memory.ToArray()
    $process.Dispose()
    $memory.Dispose()
    return $bytes
}

function Get-EncodingWriter {
    param([string]$EncodingName)

    switch ($EncodingName) {
        "UTF8NoBom" { return $Utf8NoBom }
        "UTF8-BOM" { return New-Object System.Text.UTF8Encoding -ArgumentList $true }
        "UTF16LE-BOM" { return New-Object System.Text.UnicodeEncoding -ArgumentList $false, $true }
        "UTF16BE-BOM" { return New-Object System.Text.UnicodeEncoding -ArgumentList $true, $true }
        "UTF32LE-BOM" { return New-Object System.Text.UTF32Encoding -ArgumentList $false, $true }
        "UTF32BE-BOM" { return New-Object System.Text.UTF32Encoding -ArgumentList $true, $true }
        default { throw "Unsupported encoding for safe rewrite: $EncodingName" }
    }
}

function Get-GitChangedLines {
    param([string]$RepoRoot, [string]$RelativePath)

    $lines = New-Object 'System.Collections.Generic.HashSet[int]'
    $diff = & git.exe -C $RepoRoot diff --unified=0 --no-ext-diff -- $RelativePath
    foreach ($diffLine in $diff) {
        if ($diffLine -match '^@@ -\d+(?:,\d+)? \+(\d+)(?:,(\d+))? @@') {
            $start = [int]$Matches[1]
            $count = if ($Matches[2]) { [int]$Matches[2] } else { 1 }
            for ($lineNumber = $start; $lineNumber -lt ($start + $count); $lineNumber++) {
                [void]$lines.Add($lineNumber)
            }
        }
    }
    return $lines
}

function Get-ChangedLineEndingState {
    param([string]$Text, [System.Collections.Generic.HashSet[int]]$ChangedLines, [string]$ExpectedLineEnding)

    $parts = [regex]::Split($Text, "(`r`n|`n|`r)")
    $mismatchLines = New-Object 'System.Collections.Generic.List[int]'
    $lineNumber = 1
    for ($index = 1; $index -lt $parts.Length; $index += 2) {
        if ($ChangedLines.Contains($lineNumber)) {
            $actual = switch ($parts[$index]) { "`r`n" { "CRLF" } "`n" { "LF" } "`r" { "CR" } }
            if ($actual -ne $ExpectedLineEnding) { $mismatchLines.Add($lineNumber) }
        }
        $lineNumber++
    }
    return $mismatchLines
}

function Set-ChangedLineEndings {
    param([string]$Text, [System.Collections.Generic.HashSet[int]]$ChangedLines, [string]$ExpectedLineEnding)

    $replacement = switch ($ExpectedLineEnding) { "CRLF" { "`r`n" } "LF" { "`n" } "CR" { "`r" } }
    $parts = [regex]::Split($Text, "(`r`n|`n|`r)")
    $lineNumber = 1
    for ($index = 1; $index -lt $parts.Length; $index += 2) {
        if ($ChangedLines.Contains($lineNumber)) { $parts[$index] = $replacement }
        $lineNumber++
    }
    return ($parts -join '')
}

$files = foreach ($item in $Path) {
    if (-not (Test-Path -LiteralPath $item)) { throw "Path not found: $item" }
    $resolved = Get-Item -LiteralPath $item
    if ($resolved.PSIsContainer) {
        Get-ChildItem -LiteralPath $resolved.FullName -File -Recurse:$Recurse
    } else {
        $resolved
    }
}

$failed = $false
foreach ($file in $files | Sort-Object FullName -Unique) {
    $currentBytes = [System.IO.File]::ReadAllBytes($file.FullName)
    $current = Get-TextFormat $currentBytes
    if (-not $current.IsText) { continue }

    $repoRoot = (& git.exe -C $file.DirectoryName rev-parse --show-toplevel 2>$null)
    $reference = $null
    $source = "NewFile"
    $changedLines = New-Object 'System.Collections.Generic.HashSet[int]'
    if ($LASTEXITCODE -eq 0 -and $repoRoot) {
        $repoRoot = [System.IO.Path]::GetFullPath($repoRoot.Trim())
        $relative = $file.FullName.Substring($repoRoot.Length).TrimStart('\', '/').Replace('\', '/')
        $referenceBytes = Invoke-GitBytes $repoRoot $relative ("HEAD:" + $relative)
        if ($null -ne $referenceBytes) {
            $reference = Get-TextFormat $referenceBytes
            $source = "GitHead"
            $changedLines = Get-GitChangedLines $repoRoot $relative
        }
    }

    if ($null -eq $reference) {
        $expectedEncoding = "UTF8NoBom"
        $expectedLineEnding = "CRLF"
        $lineCount = ([regex]::Matches($current.Text, "`r`n|`n|`r")).Count
        for ($lineNumber = 1; $lineNumber -le $lineCount; $lineNumber++) { [void]$changedLines.Add($lineNumber) }
    } elseif (-not $reference.IsText) {
        continue
    } else {
        $expectedEncoding = $reference.Encoding
        $expectedLineEnding = $reference.LineEnding
    }

    $encodingOk = $current.Encoding -eq $expectedEncoding
    $mixedReference = $expectedLineEnding -eq "Mixed"
    if ($mixedReference) {
        $mismatchLines = New-Object 'System.Collections.Generic.List[int]'
        $status = "NeedsReview"
    } else {
        $mismatchLines = Get-ChangedLineEndingState $current.Text $changedLines $expectedLineEnding
        $status = if ($encodingOk -and $mismatchLines.Count -eq 0) { "OK" } else { "Mismatch" }
    }

    if ($status -eq "Mismatch" -and $Fix) {
        $normalized = Set-ChangedLineEndings $current.Text $changedLines $expectedLineEnding
        [System.IO.File]::WriteAllText($file.FullName, $normalized, (Get-EncodingWriter $expectedEncoding))
        $status = "Fixed"
    }

    if ($status -eq "Mismatch" -or $status -eq "NeedsReview") { $failed = $true }
    [pscustomobject]@{
        Status = $status
        Source = $source
        Encoding = $current.Encoding
        ExpectedEncoding = $expectedEncoding
        LineEnding = $current.LineEnding
        ExpectedLineEnding = $expectedLineEnding
        ChangedLines = $changedLines.Count
        MismatchLines = ($mismatchLines -join ',')
        Path = $file.FullName
    }
}

if ($failed) { exit 1 }
