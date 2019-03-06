<#
.SYNOPSIS
    The index API adds or updates a typed JSON document in a specific index, making it searchable.
.DESCRIPTION
    The index API adds or updates a typed JSON document in a specific index, making it searchable.
.EXAMPLE
    PS C:\> Write-ElasticDocument -Name 'myindex' -JSON (@{message = 'hello world'} | ConvertTo-JSON) -Id 1
    writes a document to the index 'myindex'
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/6.6/docs-index_.html
#>
function Write-ElasticDocument
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Alias("Index")]
        [string[]]
        $Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $JSON,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Nullable``1[[System.Int32]]]
        $Id,

        [Parameter(Mandatory=$false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"
        $resource = '_doc'
        if ($Id) {
            $method = 'PUT'
            $resource = Join-ElasticParts -Separator '/' -Parts $Name,$resource,$Id
        }
        else {
            $method = 'POST'
            $resource = Join-ElasticParts -Separator '/' -Parts $Name,$resource
        }
    }
    Process
    {
        foreach ($connection in $ElasticConnection) {
            Invoke-ElasticRequest -ElasticConnection $connection -Resource $resource -Method $method -Content $JSON
        }
    }
}