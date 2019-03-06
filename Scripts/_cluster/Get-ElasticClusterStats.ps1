<#
.SYNOPSIS
    The Cluster Stats API allows to retrieve statistics from a cluster wide perspective.
.DESCRIPTION
    The API returns basic index metrics (shard numbers, store size, memory usage) and information
    about the current nodes that form the cluster (number, roles, os, jvm versions, memory usage, cpu and installed plugins).
.EXAMPLE
    PS C:\> Get-ElasticClusterStats
    Retrieves statistics from a cluster wide perspective
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/6.6/cluster-stats.html
#>
function Get-ElasticClusterStats
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [string[]]
        $NodeFilter,

        [Parameter(Mandatory=$false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"
        if ($NodeFilter) {
            [string]$NodeFilter = Join-ElasticParts -Separator ',' -Parts $NodeFilter
            $resource = Join-ElasticParts -Separator '/' -Parts '_cluster', 'stats', 'nodes', $NodeFilter
        }
        else {
            $resource = Join-ElasticParts -Separator '/' -Parts '_cluster', 'stats'
        }
    }
    Process
    {
        foreach ($connection in $ElasticConnection) {
            Invoke-ElasticRequest -ElasticConnection $connection -Resource $resource
        }
    }
}
