

<#
.Synopsis
   Creates an endpoint to connect to Elastic
.DESCRIPTION
   Creates an endpoint to connect to Elastic
.EXAMPLE
   $c = Get-ElasticConnection ; $c.repository.environments.findall()

   Get all the environments on the Elastic  instance using New-Elastic Connection and the Elastic .client
.EXAMPLE
   $c = Get-ElasticConnection ; invoke-webrequest -header $c.header -uri http://Elastic.company.com/api/environments/all -method Get

   Use the [Header] Member of the Object returned by New-Elastic Connection as a header to call the REST API using Invoke-WebRequest
.LINK
   Github project: https://github.com/Dalmirog/Octoposh
   Wiki: https://github.com/Dalmirog/OctoPosh/wiki
   QA and Cmdlet request: https://gitter.im/Dalmirog/OctoPosh#initial
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