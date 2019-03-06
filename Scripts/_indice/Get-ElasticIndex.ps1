<#
.SYNOPSIS
    The get index API allows to retrieve information about one or more indexes.
.DESCRIPTION
    The get index API allows to retrieve information about one or more indexes. All documents in Elasticsearch are stored inside of one index or another.
.EXAMPLE
    PS C:\> Get-ElasticIndex
    Returns an index
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-get-index.html
#>
function Get-ElasticIndex
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias('Index', 'Indice')]
        [string[]]
        $Name = '_all',

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
            Invoke-ElasticRequest -ElasticConnection $connection -Resource $Name -Method 'GET'
        }
    }
}