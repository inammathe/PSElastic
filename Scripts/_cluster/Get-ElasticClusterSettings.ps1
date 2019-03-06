<#
.SYNOPSIS
    The cluster get settings API allows to retrieve the cluster wide settings.
.DESCRIPTION
    The cluster get settings API allows to retrieve the cluster wide settings.
.EXAMPLE
    PS C:\> Get-ElasticClusterSettings
    Retrieves settings from a cluster
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/6.6/cluster-get-settings.html
#>
function Get-ElasticClusterSettings
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ParameterSetName="Query")]
        [switch]
        $include_defaults,

        [Parameter(Mandatory=$false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"
        $queryVariables = Get-ElasticParamSetVariables -Parameters $MyInvocation.MyCommand.Parameters
        $resource = Join-ElasticParts -Separator '/' -Parts '_cluster', 'settings'
    }
    Process
    {
        foreach ($connection in $ElasticConnection) {
            Invoke-ElasticRequest -ElasticConnection $connection -Resource $resource -QueryVariables $queryVariables
        }
    }
}
