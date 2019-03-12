<#
.SYNOPSIS
    The search API allows you to execute a search query and get back search hits that match the query.
.DESCRIPTION
    The search API allows you to execute a search query and get back search hits that match the query.
    The query can either be provided using a simple query string as a parameter, or using a request body.
.EXAMPLE
    PS C:\> Get-ElasticSearch -Query '?q=user:kimchy'
    Retrieves settings from a cluster
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html
#>
function Get-ElasticSearch
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Alias("Index")]
        [string]
        $Name,

        [Parameter(Mandatory)]
        [string]
        $Query,

        [Parameter(Mandatory=$false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"
        $resource = Join-ElasticParts -Separator '/' -Parts $Name, '_search', $Query
    }
    Process
    {
        foreach ($connection in $ElasticConnection) {
            Invoke-ElasticRequest -ElasticConnection $connection -Resource $resource
        }
    }
}