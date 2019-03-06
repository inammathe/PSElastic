<#
.SYNOPSIS
    Used to check if the index (indices) exists or not.
.DESCRIPTION
    Used to check if the index (indices) exists or not.
.EXAMPLE
    PS C:\> Test-ElasticIndexExists
    Returns an index
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-exists.html
#>
function Test-ElasticIndexExists
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Name,

        [Parameter(Mandatory=$false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"
        [string]$Name = Join-ElasticParts -Separator ',' -Parts $Name
    }
    Process
    {
        foreach ($connection in $ElasticConnection) {
            try {
                Invoke-ElasticRequest -ElasticConnection $connection -Resource $Name -Method 'HEAD' -ErrorAction Stop | Out-Null
                $true
            }
            catch [System.Net.WebException] {
                if ([int]$_.Exception.Response.StatusCode -eq 404) {
                    $false
                } else {
                    throw $_
                }
            }
            catch
            {
                throw $_
            }
        }
    }
}