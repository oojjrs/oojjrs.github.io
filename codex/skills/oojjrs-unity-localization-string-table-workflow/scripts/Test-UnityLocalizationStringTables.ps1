<#
.SYNOPSIS
Validates Unity Localization StringTable assets without changing them.

.DESCRIPTION
Discovers StringTableCollection, SharedTableData, StringTable, and Locale assets
from their serialized fields. Exit codes: 0 = passed, 1 = validation findings,
2 = invalid input, I/O failure, or no discoverable string-table schema.
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string] $ProjectPath = (Get-Location).Path,

    [string[]] $ExpectedLocale,

    [switch] $SkipLocaleCoverage
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:Findings = New-Object 'System.Collections.Generic.List[object]'

function Add-Finding {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('ERROR', 'WARNING')]
        [string] $Severity,

        [Parameter(Mandatory = $true)]
        [string] $Message,

        [string] $AssetPath,

        [int] $Line = 0
    )

    [void] $script:Findings.Add([pscustomobject]@{
        Severity = $Severity
        Message = $Message
        Path = $AssetPath
        Line = $Line
    })
}

function Get-Indent {
    param([string] $Line)

    if ($Line -match '^( *)') {
        return $Matches[1].Length
    }

    return 0
}

function Find-FieldLine {
    param(
        [string[]] $Lines,
        [string] $FieldName,
        [int] $Start = 0,
        [int] $End = -1
    )

    if ($End -lt 0 -or $End -gt $Lines.Count) {
        $End = $Lines.Count
    }

    $pattern = '^\s*' + [regex]::Escape($FieldName) + '\s*:'
    for ($index = $Start; $index -lt $End; $index++) {
        if ($Lines[$index] -match $pattern) {
            return $index
        }
    }

    return -1
}

function Get-ScalarInfo {
    param(
        [string[]] $Lines,
        [int] $FieldIndex,
        [int] $End = -1
    )

    if ($End -lt 0 -or $End -gt $Lines.Count) {
        $End = $Lines.Count
    }

    $line = $Lines[$FieldIndex]
    if ($line -notmatch '^\s*[^:]+:\s?(.*)$') {
        return [pscustomobject]@{
            Raw = ''
            First = ''
            Line = $FieldIndex + 1
        }
    }

    $first = $Matches[1]
    $fieldIndent = Get-Indent $line
    $parts = New-Object 'System.Collections.Generic.List[string]'
    [void] $parts.Add($first)

    for ($index = $FieldIndex + 1; $index -lt $End; $index++) {
        $nextLine = $Lines[$index]
        if ([string]::IsNullOrWhiteSpace($nextLine)) {
            [void] $parts.Add('')
            continue
        }

        if ((Get-Indent $nextLine) -le $fieldIndent) {
            break
        }

        [void] $parts.Add($nextLine.Trim())
    }

    return [pscustomobject]@{
        Raw = [string]::Join("`n", $parts)
        First = $first
        Line = $FieldIndex + 1
    }
}

function ConvertFrom-UnityYamlScalar {
    param([string] $Raw)

    $value = $Raw.Trim()
    if ($value.Length -ge 2 -and $value[0] -eq "'" -and $value[$value.Length - 1] -eq "'") {
        return $value.Substring(1, $value.Length - 2).Replace("''", "'")
    }

    if ($value.Length -lt 2 -or $value[0] -ne '"' -or $value[$value.Length - 1] -ne '"') {
        return $value
    }

    $body = $value.Substring(1, $value.Length - 2)
    $builder = New-Object System.Text.StringBuilder
    for ($index = 0; $index -lt $body.Length; $index++) {
        $character = $body[$index]
        if ($character -ne '\' -or $index + 1 -ge $body.Length) {
            [void] $builder.Append($character)
            continue
        }

        $index++
        $escape = $body[$index]
        switch ($escape) {
            'n' { [void] $builder.Append("`n") }
            'r' { [void] $builder.Append("`r") }
            't' { [void] $builder.Append("`t") }
            'b' { [void] $builder.Append([char] 8) }
            'f' { [void] $builder.Append([char] 12) }
            '"' { [void] $builder.Append('"') }
            '\' { [void] $builder.Append('\') }
            'u' {
                if ($index + 4 -lt $body.Length) {
                    $hex = $body.Substring($index + 1, 4)
                    $code = 0
                    if ([int]::TryParse($hex, [Globalization.NumberStyles]::HexNumber, [Globalization.CultureInfo]::InvariantCulture, [ref] $code)) {
                        [void] $builder.Append([char] $code)
                        $index += 4
                    }
                    else {
                        [void] $builder.Append('\u')
                    }
                }
                else {
                    [void] $builder.Append('\u')
                }
            }
            default { [void] $builder.Append($escape) }
        }
    }

    return $builder.ToString()
}

function Test-RiskyYamlScalar {
    param(
        [pscustomobject] $Scalar,
        [string] $FieldName,
        [string] $AssetPath
    )

    $raw = $Scalar.Raw.Trim()
    if ($raw.Length -eq 0) {
        return
    }

    $firstCharacter = $raw[0]
    if ($firstCharacter -eq "'") {
        if ($raw[$raw.Length - 1] -ne "'") {
            Add-Finding -Severity ERROR -AssetPath $AssetPath -Line $Scalar.Line -Message "$FieldName has an unterminated single-quoted YAML scalar."
        }
        return
    }

    if ($firstCharacter -eq '"') {
        if ($raw[$raw.Length - 1] -ne '"') {
            Add-Finding -Severity ERROR -AssetPath $AssetPath -Line $Scalar.Line -Message "$FieldName has an unterminated double-quoted YAML scalar."
        }
        return
    }

    if ($firstCharacter -eq '|' -or $firstCharacter -eq '>') {
        return
    }

    $reasons = New-Object 'System.Collections.Generic.List[string]'
    if ($raw -match '^(?:-\s|\?\s|:\s|[!&*#%@`]|[\{\}\[\],])') {
        [void] $reasons.Add('a YAML indicator at the beginning')
    }
    if ($raw -match ':\s') {
        [void] $reasons.Add("': ' inside a plain scalar")
    }
    if ($raw -match '\s#') {
        [void] $reasons.Add("' #' inside a plain scalar")
    }
    if ($raw -match '^(?:---|\.\.\.)(?:\s|$)') {
        [void] $reasons.Add('a YAML document marker')
    }

    if ($reasons.Count -gt 0) {
        $reasonText = [string]::Join(', ', @($reasons | Select-Object -Unique))
        Add-Finding -Severity ERROR -AssetPath $AssetPath -Line $Scalar.Line -Message "$FieldName is an unsafe unquoted YAML scalar ($reasonText). Quote the complete scalar without changing its text."
    }
}

function Get-NestedScalar {
    param(
        [string[]] $Lines,
        [string] $ParentField,
        [string] $ChildField
    )

    $parentIndex = Find-FieldLine -Lines $Lines -FieldName $ParentField
    if ($parentIndex -lt 0) {
        return $null
    }

    $parentIndent = Get-Indent $Lines[$parentIndex]
    for ($index = $parentIndex + 1; $index -lt $Lines.Count; $index++) {
        $line = $Lines[$index]
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }
        if ((Get-Indent $line) -le $parentIndent) {
            break
        }
        if ($line -match ('^\s*' + [regex]::Escape($ChildField) + '\s*:\s*(.*?)\s*$')) {
            return ConvertFrom-UnityYamlScalar $Matches[1]
        }
    }

    return $null
}

function Get-GuidFromField {
    param(
        [string[]] $Lines,
        [string] $FieldName
    )

    $fieldIndex = Find-FieldLine -Lines $Lines -FieldName $FieldName
    if ($fieldIndex -lt 0) {
        return $null
    }

    if ($Lines[$fieldIndex] -match '\bguid:\s*([0-9a-fA-F]{32})\b') {
        return $Matches[1].ToLowerInvariant()
    }

    $fieldIndent = Get-Indent $Lines[$fieldIndex]
    for ($index = $fieldIndex + 1; $index -lt $Lines.Count; $index++) {
        $line = $Lines[$index]
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }
        if ((Get-Indent $line) -le $fieldIndent) {
            break
        }
        if ($line -match '(?:\bguid|\bm_Guid):\s*([0-9a-fA-F]{32})\b') {
            return $Matches[1].ToLowerInvariant()
        }
    }

    return $null
}

function Get-GuidSequence {
    param(
        [string[]] $Lines,
        [string] $FieldName
    )

    $fieldIndex = Find-FieldLine -Lines $Lines -FieldName $FieldName
    if ($fieldIndex -lt 0) {
        return @()
    }

    $fieldIndent = Get-Indent $Lines[$fieldIndex]
    $guids = New-Object 'System.Collections.Generic.List[string]'
    for ($index = $fieldIndex + 1; $index -lt $Lines.Count; $index++) {
        $line = $Lines[$index]
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }
        if ((Get-Indent $line) -le $fieldIndent -and $line -notmatch '^\s*-') {
            break
        }
        if ($line -match '\bguid:\s*([0-9a-fA-F]{32})\b') {
            [void] $guids.Add($Matches[1].ToLowerInvariant())
        }
    }

    return $guids.ToArray()
}

function Get-AddressableLocaleGuids {
    param([string[]] $Lines)

    $sectionIndex = Find-FieldLine -Lines $Lines -FieldName 'm_SerializeEntries'
    if ($sectionIndex -lt 0) {
        return @()
    }

    $sectionIndent = Get-Indent $Lines[$sectionIndex]
    $blockEnd = $Lines.Count
    $entries = New-Object 'System.Collections.Generic.List[object]'
    for ($index = $sectionIndex + 1; $index -lt $Lines.Count; $index++) {
        $line = $Lines[$index]
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }
        if ($line -match '^\s*-\s*m_GUID:\s*([0-9a-fA-F]{32})\s*$') {
            [void] $entries.Add([pscustomobject]@{
                Index = $index
                Guid = $Matches[1].ToLowerInvariant()
            })
            continue
        }
        if ((Get-Indent $line) -le $sectionIndent) {
            $blockEnd = $index
            break
        }
    }

    $guids = New-Object 'System.Collections.Generic.List[string]'
    for ($entryIndex = 0; $entryIndex -lt $entries.Count; $entryIndex++) {
        $entry = $entries[$entryIndex]
        $entryEnd = $blockEnd
        if ($entryIndex + 1 -lt $entries.Count) {
            $entryEnd = $entries[$entryIndex + 1].Index
        }

        $labelsIndex = Find-FieldLine -Lines $Lines -FieldName 'm_SerializedLabels' -Start ($entry.Index + 1) -End $entryEnd
        if ($labelsIndex -lt 0) {
            continue
        }
        $labelsIndent = Get-Indent $Lines[$labelsIndex]
        for ($index = $labelsIndex + 1; $index -lt $entryEnd; $index++) {
            $line = $Lines[$index]
            if ([string]::IsNullOrWhiteSpace($line)) {
                continue
            }
            if ((Get-Indent $line) -le $labelsIndent -and $line -notmatch '^\s*-') {
                break
            }
            if ($line -match '^\s*-\s*Locale\s*$') {
                [void] $guids.Add($entry.Guid)
                break
            }
        }
    }

    return $guids.ToArray()
}

function Get-MetaGuid {
    param([string] $AssetPath)

    $metaPath = $AssetPath + '.meta'
    if (-not (Test-Path -LiteralPath $metaPath -PathType Leaf)) {
        return $null
    }

    foreach ($line in [IO.File]::ReadAllLines($metaPath)) {
        if ($line -match '^guid:\s*([0-9a-fA-F]{32})\s*$') {
            return $Matches[1].ToLowerInvariant()
        }
    }

    return $null
}

function Get-SimpleFieldValue {
    param(
        [string[]] $Lines,
        [string] $FieldName
    )

    $fieldIndex = Find-FieldLine -Lines $Lines -FieldName $FieldName
    if ($fieldIndex -lt 0) {
        return $null
    }

    $scalar = Get-ScalarInfo -Lines $Lines -FieldIndex $fieldIndex
    return ConvertFrom-UnityYamlScalar $scalar.Raw
}

function Get-TableEntries {
    param(
        [string[]] $Lines,
        [string] $SectionName,
        [string] $ValueField,
        [string] $AssetPath,
        [switch] $Shared,
        [switch] $SkipScalarSafety
    )

    $sectionIndex = Find-FieldLine -Lines $Lines -FieldName $SectionName
    if ($sectionIndex -lt 0) {
        Add-Finding -Severity ERROR -AssetPath $AssetPath -Message "Missing $SectionName in a discovered localization asset."
        return @()
    }

    if ($Lines[$sectionIndex] -match ':\s*\[\s*\]\s*$') {
        return @()
    }

    $sectionIndent = Get-Indent $Lines[$sectionIndex]
    $blockEnd = $Lines.Count
    for ($index = $sectionIndex + 1; $index -lt $Lines.Count; $index++) {
        $line = $Lines[$index]
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }
        $indent = Get-Indent $line
        if ($indent -lt $sectionIndent -or ($indent -eq $sectionIndent -and $line -notmatch '^\s*-')) {
            $blockEnd = $index
            break
        }
    }

    $candidates = New-Object 'System.Collections.Generic.List[object]'
    for ($index = $sectionIndex + 1; $index -lt $blockEnd; $index++) {
        if ($Lines[$index] -match '^\s*-\s*m_Id:\s*(.*?)\s*$') {
            [void] $candidates.Add([pscustomobject]@{
                Index = $index
                Indent = Get-Indent $Lines[$index]
                RawId = $Matches[1]
            })
        }
    }

    if ($candidates.Count -eq 0) {
        return @()
    }

    $itemIndent = ($candidates | Measure-Object -Property Indent -Minimum).Minimum
    $items = @($candidates | Where-Object { $_.Indent -eq $itemIndent })
    $entries = New-Object 'System.Collections.Generic.List[object]'
    for ($itemIndex = 0; $itemIndex -lt $items.Count; $itemIndex++) {
        $item = $items[$itemIndex]
        $entryEnd = $blockEnd
        if ($itemIndex + 1 -lt $items.Count) {
            $entryEnd = $items[$itemIndex + 1].Index
        }

        $id = 0L
        if (-not [long]::TryParse($item.RawId, [Globalization.NumberStyles]::Integer, [Globalization.CultureInfo]::InvariantCulture, [ref] $id)) {
            Add-Finding -Severity ERROR -AssetPath $AssetPath -Line ($item.Index + 1) -Message "Entry ID '$($item.RawId)' is not a signed 64-bit integer."
            continue
        }

        $valueIndex = Find-FieldLine -Lines $Lines -FieldName $ValueField -Start ($item.Index + 1) -End $entryEnd
        if ($valueIndex -lt 0) {
            Add-Finding -Severity ERROR -AssetPath $AssetPath -Line ($item.Index + 1) -Message "Entry ID $id is missing $ValueField."
            continue
        }

        $scalar = Get-ScalarInfo -Lines $Lines -FieldIndex $valueIndex -End $entryEnd
        if (-not $SkipScalarSafety) {
            Test-RiskyYamlScalar -Scalar $scalar -FieldName $ValueField -AssetPath $AssetPath
        }
        $entry = [ordered]@{
            Id = $id.ToString([Globalization.CultureInfo]::InvariantCulture)
            Line = $item.Index + 1
            Scalar = $scalar
        }
        if ($Shared) {
            $entry.Key = ConvertFrom-UnityYamlScalar $scalar.Raw
        }
        else {
            $entry.Localized = ConvertFrom-UnityYamlScalar $scalar.Raw
        }
        [void] $entries.Add([pscustomobject] $entry)
    }

    return $entries.ToArray()
}

function Test-DuplicateEntries {
    param(
        [object[]] $Entries,
        [string] $AssetPath,
        [switch] $Shared
    )

    $ids = @{}
    foreach ($entry in $Entries) {
        if ($ids.ContainsKey($entry.Id)) {
            Add-Finding -Severity ERROR -AssetPath $AssetPath -Line $entry.Line -Message "Duplicate entry ID $($entry.Id)."
        }
        else {
            $ids[$entry.Id] = $entry.Line
        }
    }

    if (-not $Shared) {
        return
    }

    $keys = New-Object 'System.Collections.Generic.Dictionary[string,int]' ([StringComparer]::Ordinal)
    foreach ($entry in $Entries) {
        if ($keys.ContainsKey($entry.Key)) {
            Add-Finding -Severity ERROR -AssetPath $AssetPath -Line $entry.Line -Message "Duplicate shared entry key '$($entry.Key)'."
        }
        else {
            $keys.Add($entry.Key, $entry.Line)
        }
    }
}

function Get-PlaceholderSet {
    param([string] $Value)

    $tokens = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::Ordinal)
    for ($index = 0; $index -lt $Value.Length; $index++) {
        if ($Value[$index] -ne '{') {
            continue
        }
        if ($index + 1 -lt $Value.Length -and $Value[$index + 1] -eq '{') {
            $index++
            continue
        }

        $close = $Value.IndexOf('}', $index + 1)
        if ($close -lt 0) {
            continue
        }

        $content = $Value.Substring($index + 1, $close - $index - 1).Trim()
        if ($content.Length -gt 0) {
            $selector = ($content -split '[:,]', 2)[0].Trim()
            if ($selector.Length -gt 0) {
                [void] $tokens.Add($selector)
            }
        }
        $index = $close
    }

    return @($tokens | Sort-Object -CaseSensitive)
}

function Compare-EntrySequence {
    param(
        [pscustomobject] $SharedAsset,
        [pscustomobject] $TableAsset
    )

    $sharedIds = @($SharedAsset.Entries | ForEach-Object { $_.Id })
    $tableIds = @($TableAsset.Entries | ForEach-Object { $_.Id })
    $same = $sharedIds.Count -eq $tableIds.Count
    $firstMismatch = -1
    $limit = [Math]::Min($sharedIds.Count, $tableIds.Count)
    for ($index = 0; $index -lt $limit; $index++) {
        if ($sharedIds[$index] -cne $tableIds[$index]) {
            $same = $false
            $firstMismatch = $index
            break
        }
    }
    if ($same) {
        return
    }

    $sharedSet = @{}
    $tableSet = @{}
    foreach ($id in $sharedIds) { $sharedSet[$id] = $true }
    foreach ($id in $tableIds) { $tableSet[$id] = $true }
    $missing = @($sharedIds | Where-Object { -not $tableSet.ContainsKey($_) } | Select-Object -Unique)
    $extra = @($tableIds | Where-Object { -not $sharedSet.ContainsKey($_) } | Select-Object -Unique)
    $details = New-Object 'System.Collections.Generic.List[string]'
    if ($missing.Count -gt 0) { [void] $details.Add('missing=' + [string]::Join(',', $missing)) }
    if ($extra.Count -gt 0) { [void] $details.Add('extra=' + [string]::Join(',', $extra)) }
    if ($firstMismatch -ge 0) { [void] $details.Add("first-order-mismatch-index=$firstMismatch") }
    if ($details.Count -eq 0) { [void] $details.Add("shared-count=$($sharedIds.Count), table-count=$($tableIds.Count)") }

    Add-Finding -Severity ERROR -AssetPath $TableAsset.Path -Message "Locale '$($TableAsset.Locale)' entry IDs do not exactly match SharedTableData order ($([string]::Join('; ', $details)))."
}

try {
    $resolvedPath = (Resolve-Path -LiteralPath $ProjectPath).Path
    if (-not (Test-Path -LiteralPath $resolvedPath -PathType Container)) {
        throw "ProjectPath must be an existing directory: $ProjectPath"
    }

    $assetsPath = Join-Path $resolvedPath 'Assets'
    $scanRoot = if (Test-Path -LiteralPath $assetsPath -PathType Container) { $assetsPath } else { $resolvedPath }
    $assetFiles = @(
        Get-ChildItem -LiteralPath $scanRoot -Filter '*.asset' -File -Recurse |
            Where-Object { $_.FullName -notmatch '(?i)[\\/](?:Library|Temp|Obj|Logs|\.git|\$Trash)[\\/]' }
    )

    $sharedAssets = New-Object 'System.Collections.Generic.List[object]'
    $tableAssets = New-Object 'System.Collections.Generic.List[object]'
    $collectionAssets = New-Object 'System.Collections.Generic.List[object]'
    $localeAssets = New-Object 'System.Collections.Generic.List[object]'
    $availableLocaleGuids = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)

    foreach ($file in $assetFiles) {
        $lines = [IO.File]::ReadAllLines($file.FullName)
        $text = [string]::Join("`n", $lines)
        $isAddressableLocaleGroup = $text -match '(?m)^\s*m_SerializeEntries:\s*$' -and $text -match '(?m)^\s*-\s*Locale\s*$'
        if ($text -notmatch 'Unity\.Localization|m_TableCollectionNameGuidString:|m_LocaleName:' -and -not $isAddressableLocaleGroup) {
            continue
        }

        if ($lines | Where-Object { $_ -match '^\t+' } | Select-Object -First 1) {
            Add-Finding -Severity ERROR -AssetPath $file.FullName -Message 'Unity YAML contains tab indentation.'
        }

        if ($isAddressableLocaleGroup) {
            foreach ($guid in @(Get-AddressableLocaleGuids -Lines $lines)) {
                [void] $availableLocaleGuids.Add($guid)
            }
            continue
        }

        $isStringCollection = $text -match '(?m)^\s*m_EditorClassIdentifier:.*StringTableCollection\s*$'
        $isStringTable = -not $isStringCollection -and $text -match '(?m)^\s*m_EditorClassIdentifier:.*\.Tables\.StringTable\s*$'
        $isShared = $text -match '(?m)^\s*m_EditorClassIdentifier:.*SharedTableData\s*$'
        $isLocale = $text -match '(?m)^\s*m_LocaleName:' -and $text -match '(?m)^\s*m_Identifier:\s*$'

        if ($isStringCollection) {
            [void] $collectionAssets.Add([pscustomobject]@{
                Path = $file.FullName
                SharedGuid = Get-GuidFromField -Lines $lines -FieldName 'm_SharedTableData'
                TableGuids = @(Get-GuidSequence -Lines $lines -FieldName 'm_Tables')
            })
            continue
        }

        if ($isStringTable) {
            $entries = @(Get-TableEntries -Lines $lines -SectionName 'm_TableData' -ValueField 'm_Localized' -AssetPath $file.FullName)
            Test-DuplicateEntries -Entries $entries -AssetPath $file.FullName
            [void] $tableAssets.Add([pscustomobject]@{
                Path = $file.FullName
                MetaGuid = Get-MetaGuid $file.FullName
                Locale = Get-NestedScalar -Lines $lines -ParentField 'm_LocaleId' -ChildField 'm_Code'
                SharedGuid = Get-GuidFromField -Lines $lines -FieldName 'm_SharedData'
                TargetSharedGuid = $null
                Entries = $entries
            })
            continue
        }

        if ($isShared) {
            $entries = @(Get-TableEntries -Lines $lines -SectionName 'm_Entries' -ValueField 'm_Key' -AssetPath $file.FullName -Shared -SkipScalarSafety)
            $internalGuid = Get-SimpleFieldValue -Lines $lines -FieldName 'm_TableCollectionNameGuidString'
            if (-not [string]::IsNullOrWhiteSpace($internalGuid)) {
                $internalGuid = $internalGuid.ToLowerInvariant()
            }
            [void] $sharedAssets.Add([pscustomobject]@{
                Path = $file.FullName
                MetaGuid = Get-MetaGuid $file.FullName
                InternalGuid = $internalGuid
                Name = Get-SimpleFieldValue -Lines $lines -FieldName 'm_TableCollectionName'
                Entries = $entries
            })
            continue
        }

        if ($isLocale) {
            [void] $localeAssets.Add([pscustomobject]@{
                Path = $file.FullName
                MetaGuid = Get-MetaGuid $file.FullName
                Code = Get-NestedScalar -Lines $lines -ParentField 'm_Identifier' -ChildField 'm_Code'
                IsPseudo = $text -match '(?m)^\s*m_EditorClassIdentifier:.*PseudoLocale\s*$'
            })
        }
    }

    if ($sharedAssets.Count -eq 0 -and $tableAssets.Count -eq 0 -and $collectionAssets.Count -eq 0) {
        throw "No Unity Localization StringTable schema was discovered under '$scanRoot'."
    }

    $sharedByGuid = @{}
    $sharedGuidCounts = @{}
    foreach ($shared in $sharedAssets) {
        $guid = if (-not [string]::IsNullOrWhiteSpace($shared.MetaGuid)) { $shared.MetaGuid } else { $shared.InternalGuid }
        if (-not [string]::IsNullOrWhiteSpace($guid)) {
            if ($sharedGuidCounts.ContainsKey($guid)) {
                $sharedGuidCounts[$guid]++
            }
            else {
                $sharedGuidCounts[$guid] = 1
                $sharedByGuid[$guid] = $shared
            }
        }
    }

    $tableByMetaGuid = @{}
    foreach ($table in $tableAssets) {
        if ([string]::IsNullOrWhiteSpace($table.MetaGuid)) {
            Add-Finding -Severity ERROR -AssetPath $table.Path -Message 'StringTable has no readable .meta GUID.'
        }
        elseif ($tableByMetaGuid.ContainsKey($table.MetaGuid)) {
            Add-Finding -Severity ERROR -AssetPath $table.Path -Message "Duplicate StringTable .meta GUID '$($table.MetaGuid)'."
        }
        else {
            $tableByMetaGuid[$table.MetaGuid] = $table
        }
        if ([string]::IsNullOrWhiteSpace($table.Locale)) {
            Add-Finding -Severity ERROR -AssetPath $table.Path -Message 'StringTable has no m_LocaleId.m_Code.'
        }
        if ([string]::IsNullOrWhiteSpace($table.SharedGuid)) {
            Add-Finding -Severity ERROR -AssetPath $table.Path -Message 'StringTable has no m_SharedData GUID.'
        }
        $table.TargetSharedGuid = $table.SharedGuid
    }

    $targetGuids = @{}
    foreach ($collection in $collectionAssets) {
        if ([string]::IsNullOrWhiteSpace($collection.SharedGuid)) {
            Add-Finding -Severity ERROR -AssetPath $collection.Path -Message 'StringTableCollection has no m_SharedTableData GUID.'
            continue
        }
        $targetGuids[$collection.SharedGuid] = $true
        $collectionTableGuids = @{}
        foreach ($tableGuid in $collection.TableGuids) {
            if ($collectionTableGuids.ContainsKey($tableGuid)) {
                Add-Finding -Severity ERROR -AssetPath $collection.Path -Message "StringTableCollection contains duplicate table GUID '$tableGuid'."
                continue
            }
            $collectionTableGuids[$tableGuid] = $true
            if (-not $tableByMetaGuid.ContainsKey($tableGuid)) {
                Add-Finding -Severity ERROR -AssetPath $collection.Path -Message "StringTableCollection references table GUID '$tableGuid', but no matching StringTable asset was discovered."
                continue
            }
            $table = $tableByMetaGuid[$tableGuid]
            if (-not [string]::IsNullOrWhiteSpace($table.TargetSharedGuid) -and $table.TargetSharedGuid -cne $table.SharedGuid -and $table.TargetSharedGuid -cne $collection.SharedGuid) {
                Add-Finding -Severity ERROR -AssetPath $table.Path -Message 'StringTable is registered in collections with conflicting SharedTableData GUIDs.'
            }
            $table.TargetSharedGuid = $collection.SharedGuid
            if ($table.SharedGuid -cne $collection.SharedGuid) {
                Add-Finding -Severity ERROR -AssetPath $table.Path -Message "Locale '$($table.Locale)' references SharedTableData GUID '$($table.SharedGuid)', but its StringTableCollection requires '$($collection.SharedGuid)'."
            }
        }
        foreach ($table in @($tableAssets | Where-Object { $_.SharedGuid -ieq $collection.SharedGuid })) {
            if (-not [string]::IsNullOrWhiteSpace($table.MetaGuid) -and -not $collectionTableGuids.ContainsKey($table.MetaGuid)) {
                Add-Finding -Severity ERROR -AssetPath $table.Path -Message "Locale '$($table.Locale)' uses this SharedTableData but is not registered in its StringTableCollection."
            }
        }
    }
    foreach ($table in $tableAssets) {
        if (-not [string]::IsNullOrWhiteSpace($table.TargetSharedGuid)) {
            $targetGuids[$table.TargetSharedGuid] = $true
        }
    }

    foreach ($guid in @($targetGuids.Keys)) {
        if (-not $sharedByGuid.ContainsKey($guid)) {
            continue
        }

        $shared = $sharedByGuid[$guid]
        if ($sharedGuidCounts[$guid] -gt 1) {
            Add-Finding -Severity ERROR -AssetPath $shared.Path -Message "SharedTableData GUID '$guid' is duplicated across $($sharedGuidCounts[$guid]) assets."
        }
        if ([string]::IsNullOrWhiteSpace($shared.MetaGuid)) {
            Add-Finding -Severity ERROR -AssetPath $shared.Path -Message 'SharedTableData has no readable .meta GUID.'
        }
        if ([string]::IsNullOrWhiteSpace($shared.InternalGuid)) {
            Add-Finding -Severity ERROR -AssetPath $shared.Path -Message 'SharedTableData has no m_TableCollectionNameGuidString.'
        }
        if (-not [string]::IsNullOrWhiteSpace($shared.MetaGuid) -and -not [string]::IsNullOrWhiteSpace($shared.InternalGuid) -and $shared.MetaGuid -cne $shared.InternalGuid) {
            Add-Finding -Severity ERROR -AssetPath $shared.Path -Message "SharedTableData internal GUID '$($shared.InternalGuid)' differs from .meta GUID '$($shared.MetaGuid)'."
        }
        Test-DuplicateEntries -Entries $shared.Entries -AssetPath $shared.Path -Shared
        foreach ($entry in $shared.Entries) {
            Test-RiskyYamlScalar -Scalar $entry.Scalar -FieldName 'm_Key' -AssetPath $shared.Path
        }
    }

    foreach ($guid in @($targetGuids.Keys)) {
        if (-not $sharedByGuid.ContainsKey($guid)) {
            Add-Finding -Severity ERROR -Message "String-table assets reference SharedTableData GUID '$guid', but no matching SharedTableData asset was discovered."
        }
    }

    $supportedLocales = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    if ($null -ne $ExpectedLocale -and $ExpectedLocale.Count -gt 0) {
        foreach ($locale in $ExpectedLocale) {
            if ([string]::IsNullOrWhiteSpace($locale)) {
                throw 'ExpectedLocale cannot contain an empty locale code.'
            }
            [void] $supportedLocales.Add($locale.Trim())
        }
    }
    elseif ($availableLocaleGuids.Count -gt 0) {
        $localeByGuid = @{}
        foreach ($localeAsset in $localeAssets) {
            if (-not [string]::IsNullOrWhiteSpace($localeAsset.MetaGuid)) {
                $localeByGuid[$localeAsset.MetaGuid] = $localeAsset
            }
        }
        foreach ($localeGuid in $availableLocaleGuids) {
            if (-not $localeByGuid.ContainsKey($localeGuid)) {
                Add-Finding -Severity ERROR -Message "AvailableLocales registers Locale GUID '$localeGuid', but no matching Locale asset was discovered."
                continue
            }
            $localeAsset = $localeByGuid[$localeGuid]
            if ($localeAsset.IsPseudo) {
                continue
            }
            if ([string]::IsNullOrWhiteSpace($localeAsset.Code)) {
                Add-Finding -Severity ERROR -AssetPath $localeAsset.Path -Message 'Locale asset has no m_Identifier.m_Code.'
            }
            else {
                [void] $supportedLocales.Add($localeAsset.Code)
            }
        }
    }
    elseif ($localeAssets.Count -gt 0) {
        foreach ($localeAsset in $localeAssets) {
            if ($localeAsset.IsPseudo) {
                continue
            }
            if ([string]::IsNullOrWhiteSpace($localeAsset.Code)) {
                Add-Finding -Severity ERROR -AssetPath $localeAsset.Path -Message 'Locale asset has no m_Identifier.m_Code.'
            }
            else {
                [void] $supportedLocales.Add($localeAsset.Code)
            }
        }
    }
    else {
        foreach ($table in $tableAssets) {
            if (-not [string]::IsNullOrWhiteSpace($table.Locale)) {
                [void] $supportedLocales.Add($table.Locale)
            }
        }
    }

    foreach ($guid in @($targetGuids.Keys)) {
        $tables = @($tableAssets | Where-Object { $_.TargetSharedGuid -ieq $guid })
        $localeMap = @{}
        foreach ($table in $tables) {
            $localeKey = if ($null -eq $table.Locale) { '' } else { $table.Locale.ToLowerInvariant() }
            if ($localeMap.ContainsKey($localeKey)) {
                Add-Finding -Severity ERROR -AssetPath $table.Path -Message "Duplicate locale table '$($table.Locale)' for SharedTableData GUID '$guid'."
            }
            else {
                $localeMap[$localeKey] = $table
            }
        }

        if (-not $SkipLocaleCoverage) {
            foreach ($locale in $supportedLocales) {
                if (-not $localeMap.ContainsKey($locale.ToLowerInvariant())) {
                    Add-Finding -Severity ERROR -Message "SharedTableData GUID '$guid' has no StringTable for supported locale '$locale'."
                }
            }
        }

        if (-not $sharedByGuid.ContainsKey($guid)) {
            continue
        }
        $shared = $sharedByGuid[$guid]
        foreach ($table in $tables) {
            Compare-EntrySequence -SharedAsset $shared -TableAsset $table
        }

        foreach ($sharedEntry in $shared.Entries) {
            $signatures = @{}
            foreach ($table in $tables) {
                $localizedEntry = $table.Entries | Where-Object { $_.Id -ceq $sharedEntry.Id } | Select-Object -First 1
                if ($null -eq $localizedEntry) {
                    continue
                }
                $placeholders = @(Get-PlaceholderSet $localizedEntry.Localized)
                $signature = [string]::Join([char] 31, $placeholders)
                $label = if ($placeholders.Count -eq 0) { '<none>' } else { '{' + [string]::Join('}, {', $placeholders) + '}' }
                $localeLabel = if ([string]::IsNullOrWhiteSpace($table.Locale)) { '<missing-locale>' } else { $table.Locale }
                $signatures[$localeLabel] = [pscustomobject]@{
                    Signature = $signature
                    Label = $label
                }
            }

            $distinct = @($signatures.Values | Select-Object -ExpandProperty Signature -Unique)
            if ($distinct.Count -gt 1) {
                $parts = @($signatures.Keys | Sort-Object | ForEach-Object { "$_=$($signatures[$_].Label)" })
                Add-Finding -Severity ERROR -AssetPath $shared.Path -Line $sharedEntry.Line -Message "Placeholder sets differ for key '$($sharedEntry.Key)' (ID $($sharedEntry.Id)): $([string]::Join('; ', $parts))."
            }
        }
    }

    $localeSummary = @($supportedLocales | Sort-Object)
    Write-Output "Unity Localization StringTable validation"
    Write-Output "Scan root: $scanRoot"
    Write-Output "Collections: $($collectionAssets.Count); SharedTableData: $($targetGuids.Count); locale tables: $($tableAssets.Count); supported locales: $([string]::Join(', ', $localeSummary))"
    foreach ($finding in $script:Findings) {
        $location = ''
        if (-not [string]::IsNullOrWhiteSpace($finding.Path)) {
            $location = $finding.Path
            if ($finding.Line -gt 0) {
                $location += ':' + $finding.Line
            }
            $location += ' - '
        }
        Write-Output "[$($finding.Severity)] $location$($finding.Message)"
    }

    $errorCount = @($script:Findings | Where-Object { $_.Severity -eq 'ERROR' }).Count
    $warningCount = @($script:Findings | Where-Object { $_.Severity -eq 'WARNING' }).Count
    Write-Output "Result: $errorCount error(s), $warningCount warning(s)."
    if ($errorCount -gt 0) {
        exit 1
    }
    exit 0
}
catch {
    [Console]::Error.WriteLine("[FATAL] $($_.Exception.Message)")
    if (-not [string]::IsNullOrWhiteSpace($_.ScriptStackTrace)) {
        [Console]::Error.WriteLine($_.ScriptStackTrace)
    }
    exit 2
}
