<#
.SYNOPSIS
    Invokes requests to elastic
.DESCRIPTION
    Used by most functions to talk to your configured elastic endpoint. Performs some basic string building and validation
.EXAMPLE
    PS C:\> Invoke-ElasticRequest -ElasticConnection (Get-ElasticConnection) -Resource '_cluster/health'
    Performs a get request to https://yourelasticendpoint.com/_cluster/health
#>
function Invoke-ElasticRequest {
    [cmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [object]$ElasticConnection,

        [Parameter(Mandatory)]
        [string]$Resource,

        [Parameter(Mandatory=$false)]
        [Object[]]$QueryVariables,

        [Parameter(Mandatory=$false)]
        [ValidateSet('GET','POST','PUT', 'DELETE', 'HEAD')]
        [string]$Method = 'GET',

        [Parameter(Mandatory=$false)]
        [ValidateScript({
            if(!(Test-ElasticJson $_))
            {
                Write-ElasticLog -Level 'Error' -Message "'$_' Must be valid JSON" -ErrorAction Stop
            }else {
                return $true
            }
        })]
        [string]$Content
    )
    If ($PSCmdlet.ShouldProcess("Message")) {
        $uri = (Join-ElasticParts -Separator '/' -Parts $ElasticConnection.BaseUrl,$Resource)
        if ($QueryVariables) {
            $uri += Get-ElasticQueryString -QueryVariables $QueryVariables
        }
        if (!$Content) {
            Write-ElasticLog "$Method $uri"
            Invoke-RestMethod -Method $Method -Uri $uri -Headers $ElasticConnection.header
        }
        else
        {
            Write-ElasticLog "$Method $uri `n$($Content | Format-List | Out-String)"
            Invoke-RestMethod -Method $Method -Uri $uri -Headers $ElasticConnection.header -Body $Content -ContentType 'application/json'
        }
    }
}