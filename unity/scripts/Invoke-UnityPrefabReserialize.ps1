[CmdletBinding()]
param(
    [string[]]$ProjectPath,
    [string]$Root = 'H:\',
    [switch]$Execute,
    [ValidateRange(1, 3600)][int]$TimeoutSeconds = 300
)

$ErrorActionPreference = 'Stop'
if (-not $ProjectPath) {
    $ProjectPath = @(Get-ChildItem -LiteralPath $Root -Directory -Filter 'UnityO*' | Where-Object Name -ne 'UnityOh' | Select-Object -ExpandProperty FullName)
}
$plans = @(foreach ($project in $ProjectPath) {
    $resolved = (Resolve-Path -LiteralPath $project).Path
    if (-not (Test-Path -LiteralPath (Join-Path $resolved 'ProjectSettings\ProjectVersion.txt'))) {
        throw "Unity 프로젝트가 아닙니다: $resolved"
    }
    $assets = Join-Path $resolved 'Assets'
    $paths = @(Get-ChildItem -LiteralPath $assets -Recurse -File -Filter '*.prefab' | Sort-Object FullName | ForEach-Object { $_.FullName.Substring($resolved.Length + 1).Replace('\', '/') })
    [pscustomobject]@{ Project = $resolved; Prefabs = $paths; Count = $paths.Count }
})
$plans | ForEach-Object {
    Write-Host "$($_.Project): $($_.Count)개"
    $_.Prefabs | ForEach-Object { Write-Host "  $_" }
}
if (-not $Execute) {
    Write-Host '목록만 확인했습니다. Pipeline이 연결된 Editor에서 실행하려면 -Execute를 지정하세요.'
    return
}

$cli = (Get-Command unity -CommandType Application -ErrorAction Stop).Source
foreach ($plan in $plans) {
    if ($plan.Count -eq 0) { continue }
    # 기존 사용자 변경이 있는 프로젝트에서는 자동 재직렬화를 시작하지 않습니다.
    $dirty = @(& git -C $plan.Project status --porcelain)
    if ($LASTEXITCODE -ne 0) { throw "Git 상태 확인 실패: $($plan.Project)" }
    if ($dirty.Count -gt 0) { throw "작업 트리가 변경되어 있습니다: $($plan.Project)" }
    $manifest = Get-Content -LiteralPath (Join-Path $plan.Project 'Packages\manifest.json') -Raw | ConvertFrom-Json
    if (-not $manifest.dependencies.'com.unity.pipeline') {
        throw "Pipeline 설치가 필요합니다: unity pipeline install --project-path $($plan.Project)"
    }
    # 고정한 경로만 전달합니다. eval 안에서 새 대상을 검색하지 않습니다.
    $encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes(($plan.Prefabs -join "`n")))
    $code = @"
if (UnityEditor.EditorApplication.isPlayingOrWillChangePlaymode || UnityEditor.EditorApplication.isCompiling || UnityEditor.EditorApplication.isUpdating)
    throw new System.InvalidOperationException("Editor is busy.");
var paths = System.Text.Encoding.UTF8.GetString(System.Convert.FromBase64String("$encoded")).Split('\n');
foreach (var path in paths)
{
    if (System.IO.File.Exists(path) == false)
        throw new System.IO.FileNotFoundException(path);
}
UnityEditor.AssetDatabase.ForceReserializeAssets(paths, UnityEditor.ForceReserializeAssetsOptions.ReserializeAssets);
return paths.Length;
"@
    $output = @(& $cli command eval $code --project-path $plan.Project --timeout $TimeoutSeconds --format json --non-interactive)
    $exitCode = $LASTEXITCODE
    $reportDirectory = Join-Path $plan.Project '$Trash\PrefabReserialize'
    New-Item -ItemType Directory -Path $reportDirectory -Force | Out-Null
    $report = Join-Path $reportDirectory ((Get-Date -Format 'yyyyMMdd-HHmmss-fff') + '.json')
    [IO.File]::WriteAllText($report, ($output -join "`r`n"), [Text.UTF8Encoding]::new($false))
    if ($exitCode -ne 0) { throw "CLI 실행 실패(일부 변경 가능): $report" }
    $result = ($output -join "`n") | ConvertFrom-Json
    if ($result.success -ne $true) { throw "CLI 실패 응답(일부 변경 가능): $report" }
    Write-Host "재직렬화 응답: $report"
    & git -C $plan.Project diff --stat
    if ($LASTEXITCODE -ne 0) { throw "변경 확인 실패: $($plan.Project)" }
}
