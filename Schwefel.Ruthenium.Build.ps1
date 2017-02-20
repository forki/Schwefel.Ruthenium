[CmdletBinding()]
Param(
    $configuration="Debug"
    ,
    $revision=""
)

Write-Host "Start Build"
Set-Location $PSScriptRoot

function BuildProject($filter) {
    Write-Host "Start Building $filter projects"

    Get-ChildItem ".\" -File -Recurse -Filter $filter | 
    Foreach-Object {
        Write-Host ("Building " + $_.DirectoryName)
    
        $buildOutputCurrent = (Join-Path $buildOutput -ChildPath $_.Directory.Name)
    
        Write-Host "Build Output is set to: $buildOutputCurrent"

        dotnet build $_.FullName --configuration $configuration --version-suffix $buildVersionSuffix --output "$buildOutputCurrent" --no-incremental --framework "netstandard1.6"
    }
    Write-Host "Finished Building $filter Projects"
}

$buildOutput = ".\Build\$configuration"
$buildVersionSuffix = ""

if($configuration -ne "Release") {
    $buildVersionSuffix = "alpha$revision"
}
else {
    $buildVersionSuffix = "beta$revision"
}

Write-Host "Build Version suffix: $buildVersionSuffix"

# CleanUp Environment
if(Test-Path $buildOutput) {
    Remove-Item $buildOutput -Force -Recurse
}
New-Item -ItemType directory -Path $buildOutput

$buildOutput = Resolve-Path $buildOutput

# Restore Nuget Packages
& ".\Schwefel.Ruthenium.Restore.ps1"

# Build Solution
BuildProject "project.json"
BuildProject "*.csproj"

Write-Host "Finished Executing Build"