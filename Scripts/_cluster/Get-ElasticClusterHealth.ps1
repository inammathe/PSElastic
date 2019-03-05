<#
.SYNOPSIS
    Gets the health status of the cluster
.DESCRIPTION
    The cluster health API allows to get a very simple status on the health of the cluster
.EXAMPLE
    PS C:\> Get-ElasticNodes
#>
function Get-ElasticClusterHealth
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [string[]]
        $Indice,

        [Parameter(Mandatory=$false, ParameterSetName="Query")]
        [ValidateSet('cluster','indices','shards')]
        [string]
        $Level,

        [Parameter(Mandatory=$false, ParameterSetName="Query")]
        [ValidateSet('green','yellow','red')]
        [string]
        $Wait_for_status,

        [Parameter(Mandatory=$false, ParameterSetName="Query")]
        [string]
        $Timeout,

        [Parameter(Mandatory=$false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"
        $queryVariables = Get-ElasticParamSetVariables -Parameters $MyInvocation.MyCommand.Parameters
        $resource = '_cluster/health'
        if ($Indice) {
            $resource += ('/' + (Join-ElasticParts -Separator ',' -Parts $Indice))
        }
    }
    Process
    {
        foreach ($connection in $ElasticConnection) {
            Invoke-ElasticRequest -ElasticConnection $connection -Resource $resource -QueryVariables $queryVariables
        }
    }
}