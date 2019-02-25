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

        [Parameter(Mandatory=$false)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"
        $resource = '_cluster/state'

        $metrics = Get-ParamSetVariables -Parameters $MyInvocation.MyCommand.Parameters -Set 'Metrics' | Select-Object -ExpandProperty Name
        if ($metrics) {
            $resource += ('/' + (Join-Parts -Separator ',' -Parts $metrics))
        }
        if ($Indice) {
            $resource += ('/' + (Join-Parts -Separator ',' -Parts $Indice))
        }
    }
    Process
    {
        Invoke-ElasticRequest -ElasticConnection $ElasticConnection -Resource $resource
    }
}
