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
        [ValidateSet('GET','POST','PUT', 'DELETE')]
        [string]$Method = 'GET',

        [Parameter(Mandatory=$false)]
        [string]$Content
    )
    If ($PSCmdlet.ShouldProcess("Message")) {
        $uri = (Join-Parts -Separator '/' -Parts $ElasticConnection.BaseUrl,$Resource)
        if ($QueryVariables) {
            $uri += Get-QueryString -QueryVariables $QueryVariables
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