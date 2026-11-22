param([Parameter(Mandatory=$true)][string]$BuildFolder,[switch]$Store)
$ErrorActionPreference='Stop'
$out=[IO.Path]::GetFullPath($BuildFolder)
& "$PSScriptRoot\RestoreDependencies.ps1" $out
$kit=Join-Path $out 'microsoft.windows.sdk.cpp\c'
$sdkVersion='10.0.26100.0'
$inc=Join-Path $kit "Include\$sdkVersion"
$lib=Join-Path $out 'microsoft.windows.sdk.cpp.x64\c'
$vswhere=Join-Path (${env:ProgramFiles(x86)}) 'Microsoft Visual Studio\Installer\vswhere.exe'
$vs=& $vswhere -latest -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
$vc=(Get-ChildItem -LiteralPath (Join-Path $vs 'VC\Tools\MSVC') -Directory | Sort-Object Name -Descending | Select-Object -First 1).FullName
$tools=Join-Path $env:USERPROFILE '.nuget\packages\microsoft.windows.sdk.buildtools\10.0.22621.756\bin\10.0.22621.0\x64'
if(!(Test-Path -LiteralPath "$tools\makeappx.exe")){$tools=Join-Path $out 'buildtools\bin\10.0.22621.0\x64'}
$stage=Join-Path $out 'package'
if($Store){$stage=Join-Path $out 'store-package'}
$logos=Join-Path $stage 'Assets'
[IO.Directory]::CreateDirectory($logos) | Out-Null
$public=Join-Path $stage 'GameBar'
[IO.Directory]::CreateDirectory($public) | Out-Null
$env:INCLUDE=("$vc\include","$inc\ucrt","$inc\um","$inc\shared","$inc\winrt","$out\projected") -join ';'
$env:LIB=("$vc\lib\x64","$lib\um\x64","$lib\ucrt\x64") -join ';'
$bar=Join-Path $out 'sdk\lib\uap10.0\Microsoft.Gaming.XboxGameBar.winmd'
& "$out\microsoft.windows.cppwinrt\bin\cppwinrt.exe" -input "$kit\UnionMetadata\$sdkVersion\Windows.winmd" -input $bar -output "$out\projected"
if($LASTEXITCODE){throw 'WinRT projection failed'}
$flags=@()
if($Store){$flags+='/DSTORE_PACKAGE'}
& "$vc\bin\Hostx64\x64\cl.exe" /nologo /utf-8 /std:c++20 /EHsc /O2 /MT /DUNICODE /D_UNICODE @flags "/Fo$stage\..\Widget.obj" "/Fe$stage\Widget.exe" "$PSScriptRoot\Widget.cpp" /link /APPCONTAINER /SUBSYSTEM:WINDOWS WindowsApp.lib
if($LASTEXITCODE){throw 'Widget build failed'}
& "$env:WINDIR\Microsoft.NET\Framework64\v4.0.30319\csc.exe" /nologo /target:winexe /platform:x64 /optimize+ "/out:$out\FrameReader.exe" "$PSScriptRoot\FrameReader.cs" "$PSScriptRoot\GameWindow.cs"
if($LASTEXITCODE){throw 'Frame reader build failed'}
Copy-Item -LiteralPath $bar -Destination $stage
Copy-Item -LiteralPath "$out\sdk\private\Microsoft.Gaming.XboxGameBar.Private.winmd" -Destination $stage
Copy-Item -Path "$out\sdk\runtimes\win10-x64\native\*" -Destination $stage
$manifest=[IO.File]::ReadAllText("$PSScriptRoot\AppxManifest.xml")
$readme=[IO.File]::ReadAllText("$out\sdk\readme.txt")
$stub=[regex]::Match($readme,'(?s)<Extension Category="windows.activatableClass.proxyStub">.*?</Extension>').Value
if(!$stub){throw 'Game Bar SDK proxy declaration missing'}
$stub=$stub.Replace('IXboxGameBarWidgetNotificationHost" InterfaceId="3284F0E0-F506-481F-88D3-9DDF6C02B56B"', 'IXboxGameBarWidgetNotificationHost" InterfaceId="6F68D392-E4A9-46F7-A024-5275BC2FE7BA"')
$manifest=$manifest.Insert($manifest.LastIndexOf('</Extensions>'),$stub)
if($Store){
    [xml]$xml=$manifest
    $root=$xml.DocumentElement
    $desktop='http://schemas.microsoft.com/appx/manifest/desktop/windows10'
    $restricted='http://schemas.microsoft.com/appx/manifest/foundation/windows10/restrictedcapabilities'
    $root.SetAttribute('xmlns:desktop',$desktop)
    $root.SetAttribute('xmlns:rescap',$restricted)
    $root.SetAttribute('IgnorableNamespaces','uap uap3 desktop rescap')
    $root.Identity.SetAttribute('Name','oojjrs.RecordingFPSWidget')
    $root.Identity.SetAttribute('Publisher','CN=26B39E80-A65E-42E2-8E09-6C63CB3CBB13')
    $root.Identity.SetAttribute('Version','1.2.0.0')
    $root.Properties.DisplayName='Recording FPS Widget'
    $root.Properties.PublisherDisplayName='oojjrs'
    $app=$root.Applications.Application
    $app.VisualElements.SetAttribute('DisplayName','Recording FPS Widget')
    $app.VisualElements.SetAttribute('Description','게임 FPS와 OBS 녹화 상태')
    $app.Extensions.Extension.AppExtension.SetAttribute('DisplayName','Recording FPS Widget')
    $helper=$xml.CreateElement('desktop','Extension',$desktop)
    $helper.SetAttribute('Category','windows.fullTrustProcess')
    $helper.SetAttribute('Executable','FrameReader.exe')
    [void]$app.Extensions.AppendChild($helper)
    $caps=$xml.CreateElement('Capabilities',$root.NamespaceURI)
    $cap=$xml.CreateElement('rescap','Capability',$restricted)
    $cap.SetAttribute('Name','runFullTrust')
    [void]$caps.AppendChild($cap)
    [void]$root.AppendChild($caps)
    $manifest=$xml.OuterXml
    Copy-Item -LiteralPath "$out\FrameReader.exe","$PSScriptRoot\recording-status.lua","$out\PresentMon-LICENSE.txt","$out\PresentMon-THIRD_PARTY.txt" -Destination $stage
    Copy-Item -LiteralPath "$out\sdk\license.txt" -Destination "$stage\XboxGameBar-LICENSE.txt"
    Copy-Item -LiteralPath "$out\PresentMon-2.6.0-x64.exe" -Destination "$stage\PresentMon.exe"
}
[IO.File]::WriteAllText("$stage\AppxManifest.xml",$manifest)
Add-Type -AssemblyName System.Drawing
foreach($item in @(@('Store',50,50),@('Small',44,44),@('Tile',150,150),@('Splash',620,300))){
    $im=[Drawing.Bitmap]::new($item[1],$item[2])
    $g=[Drawing.Graphics]::FromImage($im)
    $font=[Drawing.Font]::new('Segoe UI',[single]($item[2]*0.52),[Drawing.FontStyle]::Bold,[Drawing.GraphicsUnit]::Pixel)
    $brush=[Drawing.SolidBrush]::new([Drawing.Color]::FromArgb(55,235,93))
    $format=[Drawing.StringFormat]::new()
    $format.Alignment='Center'
    $format.LineAlignment='Center'
    $g.TextRenderingHint='AntiAliasGridFit'
    $g.DrawString('60',$font,$brush,[Drawing.RectangleF]::new(0,0,$item[1],$item[2]),$format)
    $im.Save((Join-Path $logos ($item[0]+'.png')),[Drawing.Imaging.ImageFormat]::Png)
    $format.Dispose(); $brush.Dispose(); $font.Dispose(); $g.Dispose(); $im.Dispose()
}
Copy-Item -LiteralPath "$logos\Small.png" -Destination "$public\Fps.png"
$package=if($Store){'Recording-FPS-Widget_1.2.0.0_x64.msix'}else{'OBS-FPS.msix'}
& "$tools\makeappx.exe" pack /o /d $stage /p "$out\$package"
if($LASTEXITCODE){throw 'MSIX packaging failed'}
if($Store){
    Add-Type -AssemblyName System.IO.Compression
    $upload=Join-Path $out ([IO.Path]::ChangeExtension($package,'msixupload'))
    $stream=[IO.File]::Create($upload)
    try {
        $archive=[IO.Compression.ZipArchive]::new($stream,[IO.Compression.ZipArchiveMode]::Create)
        try {[void][IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive,(Join-Path $out $package),$package,[IO.Compression.CompressionLevel]::NoCompression)}
        finally {$archive.Dispose()}
    } finally {$stream.Dispose()}
    Write-Output $upload
}
