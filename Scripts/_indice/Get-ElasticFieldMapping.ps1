<#
.SYNOPSIS
    The get field mapping API allows you to retrieve mapping definitions for one or more fields
.DESCRIPTION
    The get mapping API allows to retrieve mapping definitions for an index or index/type. This is useful when you do not need the complete type mapping returned by the Get Mapping API.
.EXAMPLE
    PS C:\> Get-ElasticFieldMapping
    Returns the mapping for an index
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-get-field-mapping.html
#>
function Get-ElasticFieldMapping
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias('Index', 'Indice')]
        [string[]]
        $Name = '_all',

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Field,

        [Parameter(Mandatory=$false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"
        [string]$Name = Join-ElasticParts -Separator ',' -Parts $Name
        [string]$Field = Join-ElasticParts -Separator ',' -Parts $Field
        $resource = Join-ElasticParts -Separator '/' -Parts $Name, '_mapping', 'field', $Field
    }
    Process
    {
        foreach ($connection in $ElasticConnection) {
            Invoke-ElasticRequest -ElasticConnection $connection -Resource $resource -Method 'GET'
        }
    }
}