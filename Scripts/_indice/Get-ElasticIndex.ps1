<#
.SYNOPSIS
    The get index API allows to retrieve information about one or more indexes.
.DESCRIPTION
    The get index API allows to retrieve information about one or more indexes. All documents in Elasticsearch are stored inside of one index or another.
.EXAMPLE
    PS C:\> Get-ElasticIndex
    Returns an index
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-state.html
#>
function Get-ElasticIndex
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Name = '_all',

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
            Invoke-ElasticRequest -ElasticConnection $ElasticConnection -Resource $indexName -Method 'GET'
        }
    }
}