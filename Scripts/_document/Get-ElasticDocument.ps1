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