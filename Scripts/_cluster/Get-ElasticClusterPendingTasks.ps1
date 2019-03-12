<#
.SYNOPSIS
    The pending cluster tasks API returns a list of any cluster-level changes
    (e.g. create index, update mapping, allocate or fail shard) which have not yet been executed.
.DESCRIPTION
    This API returns a list of any pending updates to the cluster state.
    These are distinct from the tasks reported by the Task Management API which include periodic
    tasks and tasks initiated by the user, such as node stats, search queries, or create index requests.
    However, if a user-initiated task such as a create index command causes a cluster state update,
    the activity of this task might be reported by both task api and pending cluster tasks API.
.EXAMPLE
    PS C:\> Get-ElasticClusterPendingTasks
    Returns a list of any cluster-level changes
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-pending.html
#>
function Get-ElasticClusterPendingTasks
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
        $resource = Join-ElasticParts -Separator '/' -Parts '_cluster', 'pending_tasks'
    }
    Process
    {
        foreach ($connection in $ElasticConnection) {
            Invoke-ElasticRequest -ElasticConnection $connection -Resource $resource
        }
    }
}
