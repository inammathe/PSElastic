function Get-ParamSetVariables {
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
        if ($variable.Value) {
            $output | Add-Member -Name $variable.Name -Type NoteProperty -Value $variable.Value
        }
    }
    if ($output | Get-Member -MemberType NoteProperty) {
        Write-Output $output
    }
}