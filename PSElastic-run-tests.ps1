# This can be used to manually kick off the pester tests without having to go through the pipeline
param(
    [switch]$noInstall
)

try
{
    $currentLocation = Split-Path -parent $MyInvocation.MyCommand.Path
    if (!(Get-Module Pester)) {
        if (!$noInstall) {
            Install-Module -Name Pester -Force
        }
        Import-Module -Name Pester
    }

    Invoke-Pester "$currentLocation\Tests\" -OutputFile All.TestResults.xml -OutputFormat NUnitXml -ExcludeTag Smoke -CodeCoverage "$currentLocation\Scripts\*\*" -CodeCoverageOutputFile All.CoverageResults.xml
}
catch
{
    Write-Output "Error Occurred: $($_)"
    $_
    Exit 1
}