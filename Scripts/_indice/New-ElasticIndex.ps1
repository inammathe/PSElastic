<#
.SYNOPSIS
    The Create Index API is used to manually create an index in Elasticsearch.
.DESCRIPTION
    The Create Index API is used to manually create an index in Elasticsearch. All documents in Elasticsearch are stored inside of one index or another.
.EXAMPLE
    PS C:\> New-ElasticIndex
    Returns a comprehensive state information of the whole cluster
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-state.html
#>
function New-ElasticIndex
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [string[]]
        $Name,

        [Parameter(Mandatory=$false, ParameterSetName="Settings")]
        [switch]
        $version,

        [Parameter(Mandatory=$false)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"

        if(Get-ParamSetVariables -Parameters $MyInvocation.MyCommand.Parameters -Set 'Settings' -OutVariable settings)
        {
            $settings | ConvertTo-JSON -OutVariable settings
        }
    }
    Process
    {
        Invoke-ElasticRequest -ElasticConnection $ElasticConnection -Resource $Name -Method 'PUT' -Content $settings
    }
}