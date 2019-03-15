<#
.Synopsis
    Sets the current Elastic connection info (BaseUrl and API Authorization).
.DESCRIPTION
    Sets the current Elastic connection info (BaseUrl and API Authorization). Stores information as $env variables
.EXAMPLE
    Set-ElasticConnectionInfo -BaseUrl "http://MyElastic.AwesomeCompany.com" -Username 'user' -Password 'pass'

    Sets environment variables for use in this module to make requests to your Elastic cluster.
#>
function Set-ElasticConnection
{
    [CmdletBinding()]
    Param
    (
        # Elastic BaseUrl
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$BaseUrl,

        # Elastic username
        [Parameter(Mandatory, ParameterSetName='RawCredentials')]
        [ValidateNotNullOrEmpty()]
        [string]$Username,

        # Elastic password
        [Parameter(Mandatory, ParameterSetName='RawCredentials')]
        [string]$Password,

        # Credential object
        [Parameter(Mandatory, ParameterSetName='PSCredentials')]
        [ValidateNotNullOrEmpty()]
        [PSCredential]
        $Credentials
    )
    if ($Credentials) {
        $Username = $Credentials.UserName
        $Password = $Credentials.GetNetworkCredential().Password
    }

    $env:ElasticBaseUrl = $BaseUrl
    $env:ElasticAuth = ('Basic ' + [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Username + ":" + $Password)))

    Write-Output (Get-ElasticConnection)
}