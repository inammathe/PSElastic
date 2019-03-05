<#
.SYNOPSIS
    Creates an object from a named parameter set
.DESCRIPTION
    Uses $MyInvocation.MyCommand.Parameters to create a custom object based on a function's named parameter set.
.EXAMPLE
    PS C:\> Get-ElasticParamSetVariables -Parameters $MyInvocation.MyCommand.Parameters -Set 'Test'
    Returns an ordered object containing the name and value of all variables from the named parameter set 'Test'
#>
function Get-ElasticParamSetVariables {
    [CmdletBinding()]
    param (
        $Parameters,
        $Set = 'Query'
    )
    $output = [PSCustomObject][ordered]@{}
    $Parameters.GetEnumerator() | Where-Object {
        $_.Value.ParameterSets.GetEnumerator() | Where-Object {$_.Key -eq $Set}
    } |
    ForEach-Object {
        $variable = Get-Variable ($_.Value).Name -ErrorAction SilentlyContinue
        if ($variable.Value -or $variable.Value -eq 0) {
            $output | Add-Member -Name $variable.Name -Type NoteProperty -Value $variable.Value
        }
    }
    if ($output | Get-Member -MemberType NoteProperty) {
        Write-Output $output
    }
}