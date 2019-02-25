function Get-ParamSetVariables {
    param (
        $Parameters,
        $Set = 'Query'
    )
    $Parameters.GetEnumerator() | Where-Object {
        $_.Value.ParameterSets.GetEnumerator() | Where-Object {$_.Key -eq $Set}
    } |
    ForEach-Object {
        $variable = Get-Variable ($_.Value).Name
        if ($variable.Value) {
            $variable
        }
    }
}