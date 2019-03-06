<#
.SYNOPSIS
    Used to check if a type/types exists in an index/indices.
.DESCRIPTION
    Used to check if a type/types exists in an index/indices.
.EXAMPLE
    PS C:\> Test-ElasticTypeExists -Type '_doc'
    Checks if the index mapping type '_doc' exists
.LINK
    https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-types-exists.html
#>
function Test-ElasticTypeExists
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory,Position=0)]
        [ValidateNotNullOrEmpty()]
        [Alias('Index', 'Indice')]
        [string[]]
        $Name,

        [Parameter(Mandatory)]
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
        $resource = Join-ElasticParts -Separator '/' -Parts $name, '_mapping', $Type
    }
    Process
    {
        foreach ($connection in $ElasticConnection) {
            try {
                Invoke-ElasticRequest -ElasticConnection $connection -Resource $resource -Method 'HEAD' -ErrorAction Stop | Out-Null
                $true
            }
            catch [System.Net.WebException] {
                if ([int]$_.Exception.Response.StatusCode -eq 404) {
                    $false
                } else {
                    throw $_
                }
            }
            catch
            {
                throw $_
            }
        }
    }
}