<#
.Synopsis
   Sets the current Elastic connection info (BaseUrl and API Authorization).

   Highly recommended to call this function from $profile to avoid having to re-configure this on every session.
.DESCRIPTION
   Sets the current Elastic connection info (BaseUrl and API Authorization). Stores information as $env variables

   It is highly recommended that you call this function from $profile to avoid having to re-configure this on every session.
.EXAMPLE
   Set-ElasticConnectionInfo -BaseUrl "http://MyElastic.AwesomeCompany.com" -Username 'user' -Password 'pass'

   Set connection info with a specific Auth string for an Elastic instance
#>
function Set-ElasticConnection
{
    [CmdletBinding()]
    Param
    (
        # Elastic BaseUrl
        [Parameter(Mandatory)]
        [string]$BaseUrl,

        # Elastic username
        [Parameter(Mandatory,ParameterSetName="Credentials")]
        [string]$Username,

        # Elastic password
        [Parameter(Mandatory,ParameterSetName="Credentials")]
        [string]$Password
    )
    $env:ElasticBaseUrl = $BaseUrl
    $env:ElasticAuth = ('Basic ' + [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Username + ":" + $Password)))
}