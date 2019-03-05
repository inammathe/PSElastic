<#
.SYNOPSIS
    Validates JSON
.DESCRIPTION
    This utility function is used to validate JSON payloads
.EXAMPLE
    PS C:\> Test-ElasticJson -JSON '{valid_json:{}}'
    Returns true

    PS C:\> Test-ElasticJson -JSON '{invalid_json:#}'
    Returns false
#>
function Test-ElasticJson {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $JSON
    )
    try {
        ConvertFrom-Json $JSON -ErrorAction Stop | Out-Null
        Write-Output $true
    } catch {
        Write-Output $false
    }
}