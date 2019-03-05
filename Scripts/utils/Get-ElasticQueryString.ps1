<#
.SYNOPSIS
    Builds a query string
.DESCRIPTION
    Builds a query string that is used as parameters to various elastic endpoints
.EXAMPLE
    PS C:\> Get-ElasticQueryString -QueryVariables (Get-ElasticParamSetVariables -Parameters $MyInvocation.MyCommand.Parameters)
    Processes your function's named parameter set variables (default is 'Query') and builds it into valid uri query string
#>
function Get-ElasticQueryString {
    param (
        [PSCustomObject]$QueryVariables
    )
    $variables = foreach ($variable in $QueryVariables | Get-Member -MemberType NoteProperty) {
        $name = $variable.Name.ToLower()
        $value = $QueryVariables."$($variable.Name)"
        "$name=$value"
    }
    if ($variables) {
        Write-Output ('?' + (Join-ElasticParts -Separator '&' -Parts $variables))
    }
}