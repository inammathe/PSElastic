<#
.SYNOPSIS
    The get API allows to get a typed JSON document from the index based on its id
.DESCRIPTION
    The get API allows to get a typed JSON document from the index based on its id
.EXAMPLE
    PS C:\> Get-ElasticDocument -Name 'myindex' -Id 1
    Gets the document with the Id 1 from index myindex
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/6.6/docs-get.html
#>
function Get-ElasticDocument
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias("_index","Index")]
        [string]
        $Name,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias("_id")]
        [string[]]
        $Id,

        [Parameter(Mandatory=$false)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"
    }
    Process
    {
        foreach ($document in $Id) {
            $resource = Join-ElasticParts -Separator '/' -Parts $Name, '_doc', $document
            Invoke-ElasticRequest -ElasticConnection $ElasticConnection -Resource $resource -Method 'GET'
        }
    }
}