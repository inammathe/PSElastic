<#
.SYNOPSIS
    This indice API allows you to Get one or more indices.
.DESCRIPTION
    This indice API allows you to Get one or more indices. All documents in Elasticsearch are stored inside of one index or another.
.EXAMPLE
    PS C:\> Get-ElasticDocument -Name 'myindex'
    Gets the index 'myindex'
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-delete-index.html
#>
function Get-ElasticDocument
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
        [ValidateNotNullOrEmpty()]
        [string]
        $Id,

        [Parameter(Mandatory=$false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"
        $resource = Join-ElasticParts -Separator '/' -Parts $Name,'_doc',$Id
    }
    Process
    {
        foreach ($connection in $ElasticConnection) {
            Invoke-ElasticRequest -ElasticConnection $connection -Resource ($resource) -Method 'GET'
        }
    }
}