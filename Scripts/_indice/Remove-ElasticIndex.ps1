<#
.SYNOPSIS
    This indice API allows you to remove one or more indices.
.DESCRIPTION
    This indice API allows you to remove one or more indices. All documents in Elasticsearch are stored inside of one index or another.
.EXAMPLE
    PS C:\> Remove-ElasticIndex -Name 'myindex'
    Removes the index 'myindex'
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-delete-index.html
#>
function Remove-ElasticIndex
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Name,

        [Parameter(Mandatory=$false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"
        [string]$Name = ('/' + (Join-Parts -Separator ',' -Parts $Name))
    }
    Process
    {
        foreach ($connection in $ElasticConnection) {
            Invoke-ElasticRequest -ElasticConnection $connection -Resource $Name -Method 'DELETE'
        }
    }
}