param([Parameter(Mandatory=$true)][string]$BuildFolder)
$ErrorActionPreference='Stop'
$app=Get-AppxPackage -Name 'OOJJRS.ObsFps'
if(!$app){throw 'Install the OBS FPS widget first'}
if(Get-Process -Name obs64 -ErrorAction SilentlyContinue){throw 'Close OBS before changing the saved scene collection'}
$cfg=Join-Path $env:APPDATA 'obs-studio'
$dst=Join-Path $cfg 'plugin_config\obs-fps-widget'
$storage=Join-Path $env:LOCALAPPDATA ("Packages\"+$app.PackageFamilyName+"\LocalState")
$path=Join-Path $cfg 'basic\scenes\Gameplay.json'
$before=[IO.File]::ReadAllText($path)
$scene=$before | ConvertFrom-Json
if($scene.name -ne '게임 녹화'){throw 'Unexpected active collection'}
$scriptFile=(Join-Path $dst 'obs-fps.lua').Replace('\','/')
$newScript=[ordered]@{path=$scriptFile;settings=@{}}
$scripts=@($scene.modules.'scripts-tool')
if(!$scene.modules.PSObject.Properties['scripts-tool']){throw 'Cannot locate OBS scripts'}
[IO.Directory]::CreateDirectory($dst)|Out-Null
[IO.Directory]::CreateDirectory($storage)|Out-Null
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'obs-fps.lua') -Destination $dst -Force
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'capture-retry.lua') -Destination $dst -Force
Copy-Item -LiteralPath (Join-Path $BuildFolder 'FrameReader.exe') -Destination $dst -Force
Copy-Item -LiteralPath (Join-Path $BuildFolder 'PresentMon-2.6.0-x64.exe') -Destination (Join-Path $dst 'PresentMon.exe') -Force
[IO.File]::WriteAllText((Join-Path $dst 'state-folder.txt'),$storage.Replace('\','/'),[Text.UTF8Encoding]::new($false))
if($scripts.path -notcontains $scriptFile){
    $scripts+= $newScript
    $nl=if($before.Contains("`r`n")){"`r`n"}else{"`n"}
    $marker='"scripts-tool": ['
    $pos=$before.IndexOf($marker,[StringComparison]::Ordinal)
    if($pos -lt 0 -or $pos -ne $before.LastIndexOf($marker,[StringComparison]::Ordinal)){throw 'Ambiguous scripts list'}
    $pos+=$marker.Length
    $json=$newScript|ConvertTo-Json -Compress
    $separator=if($scripts.Count -gt 1){','}else{''}
    $updated=$before.Insert($pos,$nl+'            '+$json+$separator+$nl+'        ')
    $actual=($updated|ConvertFrom-Json).modules.'scripts-tool'
    if($actual.Count -ne $scripts.Count -or $actual[0].path -ne $scriptFile){throw 'Invalid scripts list'}
    $id=[guid]::NewGuid().ToString()
    [IO.File]::Copy($path,(Join-Path $BuildFolder ("Gameplay-before-FPS-"+$id+".json")))
    if((Get-Process -Name obs64 -ErrorAction SilentlyContinue) -or [IO.File]::ReadAllText($path) -cne $before){throw 'OBS collection changed during installation'}
    $tmp=$path+'.'+$id+'.tmp'
    [IO.File]::WriteAllText($tmp,$updated,[Text.UTF8Encoding]::new($false))
    [IO.File]::Move($tmp,$path,$true)
}
"Installed OBS FPS bridge at $dst"
