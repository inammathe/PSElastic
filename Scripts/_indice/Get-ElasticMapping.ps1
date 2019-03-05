<#
.SYNOPSIS
    The get mapping API allows to retrieve mapping definitions for an index or index/type.
.DESCRIPTION
    The get mapping API allows to retrieve mapping definitions for an index or index/type. The get mapping API can be used to get more than one index or type mapping with a single call.
.EXAMPLE
    PS C:\> Get-ElasticMapping
    Returns the mapping for an index
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-get-mapping.html
#>
function Get-ElasticMapping
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [Alias("Index")]
        [string[]]
        $Name = '_all',

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Type,

        [Parameter(Mandatory=$false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"
        [string]$Name = Join-ElasticParts -Separator ',' -Parts $Name
        [string]$Type = Join-ElasticParts -Separator ',' -Parts $Type
        $resource = Join-ElasticParts -Separator '/' -Parts $Name, '_mapping', $Type
    }
    Process
    {
        foreach ($connection in $ElasticConnection) {
            Invoke-ElasticRequest -ElasticConnection $connection -Resource $resource -Method 'GET'
        }
    }
}