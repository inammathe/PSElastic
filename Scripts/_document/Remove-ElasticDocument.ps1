<#
.SYNOPSIS
    The delete API allows to delete a typed JSON document from a specific index based on its id.
.DESCRIPTION
    The delete API allows to delete a typed JSON document from a specific index based on its id.
.EXAMPLE
    PS C:\> Remove-ElasticDocument -Name 'myindex'-Id 1
    writes a document to the index 'myindex'
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-delete.html
#>
function Remove-ElasticDocument
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

        [Parameter(Mandatory=$false, ParameterSetName="Query")]
        [string]
        $Routing,

        [Parameter(Mandatory=$false, ParameterSetName="Query")]
        [switch]
        $Refresh,

        [Parameter(Mandatory=$false, ParameterSetName="Query")]
        [int]
        $Wait_for_active_shards,

        [Parameter(Mandatory=$false, ParameterSetName="Query")]
        [string]
        $Timeout,

        [Parameter(Mandatory=$false)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"
        $queryVariables = Get-ElasticParamSetVariables -Parameters $MyInvocation.MyCommand.Parameters
    }
    Process
    {
        foreach ($document in $Id) {
            $resource = Join-ElasticParts -Separator '/' -Parts $Name, '_doc', $document
            Invoke-ElasticRequest -ElasticConnection $ElasticConnection -Resource $resource -Method 'DELETE' -QueryVariables $queryVariables
        }
    }
}