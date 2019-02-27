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
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            if($_ -cnotmatch '^[^A-Z]*$'){
                Write-ElasticLog -Level 'Error' -Message "'$_' Must be Lowercase" -ErrorAction Stop
            }elseif($_ -match '[\/*?"<>| ,#:]+') {
                Write-ElasticLog -Level 'Error' -Message "'$_' Cannot include any of these characters \, /, *, ?, `", <, >, |, ` ` (space character), ,, #,:" -ErrorAction Stop
            }elseif($_ -match '^[-_+].*$'){
                Write-ElasticLog -Level 'Error' -Message "'$_' Cannot start with -, _, +" -ErrorAction Stop
            }elseif($_ -match '^\.$|^\.\.$'){
                Write-ElasticLog -Level 'Error' -Message "'$_' Cannot be . or .." -ErrorAction Stop
            }elseif([System.Text.Encoding]::ASCII.GetByteCount($_) -gt 255){
                Write-ElasticLog -Level 'Error' -Message "'$_' Cannot be longer than 255 bytes" -ErrorAction Stop
            }else {
                $true
            }
        })]
        [string[]]
        $Name,

        [Parameter(Mandatory=$false, ParameterSetName="Settings")]
        [int]
        $number_of_shards,

        [Parameter(Mandatory=$false, ParameterSetName="Settings")]
        [int]
        $number_of_replicas,

        [Parameter(Mandatory=$false)]
        $ElasticConnection = (Get-ElasticConnection)
    )
    Begin
    {
        Write-ElasticLog "$($MyInvocation.MyCommand)"

        $settings = Get-ParamSetVariables -Parameters $MyInvocation.MyCommand.Parameters -Set 'Settings'
        if ($settings | Get-Member -MemberType NoteProperty) {
            $settings = $settings | ConvertTo-JSON
        }
    }
    Process
    {
        foreach ($indexName in $Name) {
            Invoke-ElasticRequest -ElasticConnection $ElasticConnection -Resource $indexName -Method 'PUT' -Content $settings
        }
    }
}