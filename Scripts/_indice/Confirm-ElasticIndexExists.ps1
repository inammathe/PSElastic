<#
.SYNOPSIS
    The get index API allows to retrieve information about one or more indexes.
.DESCRIPTION
    The get index API allows to retrieve information about one or more indexes. All documents in Elasticsearch are stored inside of one index or another.
.EXAMPLE
    PS C:\> Confirm-ElasticIndexExists
    Returns an index
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-state.html
#>
function Confirm-ElasticIndexExists
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