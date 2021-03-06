

<#
.Synopsis
    Creates an object containing properties used when making requests to the Elastic API
.DESCRIPTION
    Creates an object containing properties used when making requests to the Elastic API.
    This command deponds on both $env:ElasticBaseUrl and $env:ElasticAuth. If either is null or empty, this function will fail.
    Please use Set-ElasticConnection or assign directly prior to this set these variables
.EXAMPLE
    Set-ElasticConnection -BaseUrl "https://MyElastic.com:9200" -Username 'user' -Password 'pass'
    Get-ElasticConnection

    Returns the BaseUrl and Header properties required for Elastic API requests. These properties are set via the Set-ElasticConnection function.
#>
function Get-ElasticConnection
{
    [CmdletBinding()]
    param()
    Begin
    {
        If([string]::IsNullOrEmpty($env:ElasticBaseUrl) -or [string]::IsNullOrEmpty($env:ElasticAuth))
        {
            throw "At least one of the following variables does not have a value set: `$env:ElasticBaseUrl or `$env:ElasticAuth.`n`nUse Set-ElasticConnectionInfo to set these values"
        }
    }
    Process
    {
        [ordered]@{
            BaseUrl = $env:ElasticBaseUrl
            Header = @{'Authorization' = $env:ElasticAuth}
        }
    }
}