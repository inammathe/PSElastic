<#
.SYNOPSIS
    The get index API allows to retrieve information about one or more indexes.
.DESCRIPTION
    The get index API allows to retrieve information about one or more indexes. All documents in Elasticsearch are stored inside of one index or another.
.EXAMPLE
    PS C:\> Remove-ElasticIndex
    Returns an index
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-state.html
#>
function Remove-ElasticIndex
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Name,

        [Parameter(Mandatory=$false)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"
    }
    Process
    {
        foreach ($indexName in $Name) {
            Invoke-ElasticRequest -ElasticConnection $ElasticConnection -Resource $indexName -Method 'DELETE'
        }
    }
}