<#
.SYNOPSIS
    This indice API allows you to write a document to one ore more indices
.DESCRIPTION
    This indice API allows you to write a document to one ore more indices. All documents in Elasticsearch are stored inside of one index or another.
.EXAMPLE
    PS C:\> Write-ElasticDocument -Name 'myindex'
    writes the index 'myindex'
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-delete-index.html
#>
function Write-ElasticDocument
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Alias("Index")]
        [string[]]
        $Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            if(!(Test-ElasticJson $_))
            {
                Write-ElasticLog -Level 'Error' -Message "'$_' Must be valid JSON" -ErrorAction Stop
            }else {
                return $true
            }
        })]
        [object]
        $JSON,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Nullable``1[[System.Int32]]]
        $Id,

        [Parameter(Mandatory=$false, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"
        $resource = '_doc'
        if ($Id) {
            $method = 'PUT'
            $resource = Join-ElasticParts -Separator '/' -Parts $Name,$resource,$Id
        }
        else {
            $method = 'POST'
            $resource = Join-ElasticParts -Separator '/' -Parts $Name,$resource
        }
    }
    Process
    {
        foreach ($connection in $ElasticConnection) {
            Invoke-ElasticRequest -ElasticConnection $connection -Resource $resource -Method $method -Content $JSON
        }
    }
}

#$json = [PSCustomObject]@{
#    timestamp = (Get-Date (Get-Date).AddHours(-10) -f 'yyyyMMddHHmmss')
#    message = 'Auto Insert'
#} | ConvertTo-Json
##
#
#Write-ElasticDocument -Name 'practice' -JSON $json
#
#Remove-ElasticIndex -Name 'practice'
#New-ElasticIndex -Name 'practice' -number_of_shards 1 -number_of_replicas 0
