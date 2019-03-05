<#
.SYNOPSIS
    The cluster state API allows to get a comprehensive state information of the whole cluster.
.DESCRIPTION
    The response provides the cluster name, the total compressed size of the cluster state (its size when serialized for transmission over the network),
    and the cluster state itself, which can be filtered to only retrieve the parts of interest
.EXAMPLE
    PS C:\> Get-ElasticClusterState
    Returns a comprehensive state information of the whole cluster
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-state.html
#>
function Get-ElasticClusterState
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [string[]]
        $Indice,

        [Parameter(Mandatory=$false, ParameterSetName="Metrics")]
        [switch]
        $version,

        [Parameter(Mandatory=$false, ParameterSetName="Metrics")]
        [switch]
        $master_node,

        [Parameter(Mandatory=$false, ParameterSetName="Metrics")]
        [switch]
        $nodes,

        [Parameter(Mandatory=$false, ParameterSetName="Metrics")]
        [switch]
        $routing_table,

        [Parameter(Mandatory=$false, ParameterSetName="Metrics")]
        [switch]
        $metadata,

        [Parameter(Mandatory=$false, ParameterSetName="Metrics")]
        [switch]
        $blocks,

        [Parameter(Mandatory=$false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"
        $resource = '_cluster/state'

        if (Get-ElasticParamSetVariables -Parameters $MyInvocation.MyCommand.Parameters -Set 'Metrics' -OutVariable metrics) {
            $resource += ('/' + (Join-ElasticParts -Separator ',' -Parts ($metrics  | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty 'Name')))
        }
        if ($Indice) {
            $resource += ('/' + (Join-ElasticParts -Separator ',' -Parts $Indice))
        }
    }
    Process
    {
        foreach ($connection in $ElasticConnection) {
            Invoke-ElasticRequest -ElasticConnection $connection -Resource $resource
        }
    }
}
