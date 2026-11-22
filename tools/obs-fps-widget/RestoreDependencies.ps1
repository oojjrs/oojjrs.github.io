param([Parameter(Mandatory=$true)][string]$BuildFolder)
$ErrorActionPreference='Stop'
$out=[IO.Path]::GetFullPath($BuildFolder)
[IO.Directory]::CreateDirectory($out) | Out-Null
Add-Type -AssemblyName System.IO.Compression.FileSystem

function Get-VerifiedFile($path,$uri,$expected) {
    if(!(Test-Path -LiteralPath $path -PathType Leaf)){
        $partial=$path+'.'+[guid]::NewGuid().ToString()+'.tmp'
        try {
            Invoke-WebRequest -Uri $uri -OutFile $partial
            if((Get-FileHash -LiteralPath $partial).Hash -ne $expected){throw "Checksum mismatch for $uri"}
            [IO.File]::Move($partial,$path)
        } finally {
            if([IO.File]::Exists($partial)){[IO.File]::Delete($partial)}
        }
    } elseif((Get-FileHash -LiteralPath $path).Hash -ne $expected){throw "Checksum mismatch for $path"}
}

function Restore-Package($id,$version,$dir,$zip,$hash,$marker) {
    $archive=Join-Path $out $zip
    $target=Join-Path $out $dir
    Get-VerifiedFile $archive "https://api.nuget.org/v3-flatcontainer/$id/$version/$id.$version.nupkg" $hash
    if(!(Test-Path -LiteralPath (Join-Path $target $marker))){
        [IO.Compression.ZipFile]::ExtractToDirectory($archive,$target,$true)
    }
}

Restore-Package 'microsoft.windows.sdk.cpp' '10.0.26100.9457' 'microsoft.windows.sdk.cpp' 'microsoft.windows.sdk.cpp.zip' '1C8B332ABBA402808880DDBA4D70E663F834DED44CF4771A2C191E9485E7CDCD' 'c/UnionMetadata/10.0.26100.0/Windows.winmd'
Restore-Package 'microsoft.windows.sdk.cpp.x64' '10.0.26100.9457' 'microsoft.windows.sdk.cpp.x64' 'microsoft.windows.sdk.cpp.x64.zip' '52BD17C63D3B6D268F385C358F34D0EB595B9C1DEB3273855ABD2EC5C095D132' 'c/um/x64/WindowsApp.lib'
Restore-Package 'microsoft.windows.cppwinrt' '3.0.260818.1' 'microsoft.windows.cppwinrt' 'microsoft.windows.cppwinrt.zip' 'A8993608AE9263A8288E1A1D9EE2684A5632F4ACC59E1E89DDD86B3B889A7367' 'bin/cppwinrt.exe'
Restore-Package 'microsoft.gaming.xboxgamebar' '7.3.2607010' 'sdk' 'gamebarsdk.zip' '20230E0A1544EBB391764E13CDBAA1EDA86239968444B599FCC9FA1E3D748FF1' 'private/Microsoft.Gaming.XboxGameBar.Private.winmd'
$packer=Join-Path $env:USERPROFILE '.nuget/packages/microsoft.windows.sdk.buildtools/10.0.22621.756/bin/10.0.22621.0/x64/makeappx.exe'
if(!(Test-Path -LiteralPath $packer)){
    Restore-Package 'microsoft.windows.sdk.buildtools' '10.0.22621.756' 'buildtools' 'buildtools.zip' 'F3D491FAA6A237280130ECAF7E0394F0329EDF42F1014BA57F5A8AF7250DBE68' 'bin/10.0.22621.0/x64/makeappx.exe'
}
Get-VerifiedFile (Join-Path $out 'PresentMon-2.6.0-x64.exe') 'https://github.com/GameTechDev/PresentMon/releases/download/v2.6.0/PresentMon-2.6.0-x64.exe' 'B2A706BC6AD475749E3B7E3409263AA1E6906D45BDCF993F6DBC0F660188F1AF'
Get-VerifiedFile (Join-Path $out 'PresentMon-LICENSE.txt') 'https://raw.githubusercontent.com/GameTechDev/PresentMon/v2.6.0/LICENSE.txt' '4C949341B1893C8C6AD82F7FB4EEDF622CD1FD9C22A9AF8F19B2DAC19D1947B6'
Get-VerifiedFile (Join-Path $out 'PresentMon-THIRD_PARTY.txt') 'https://raw.githubusercontent.com/GameTechDev/PresentMon/v2.6.0/THIRD_PARTY.txt' 'E039937F1A2FC2EB8F24A25B4229551A5A8056026D2DA878507E20269EB56267'
