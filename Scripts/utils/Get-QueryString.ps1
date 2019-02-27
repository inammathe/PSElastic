function Get-QueryString {
    param (
        [PSCustomObject]$QueryVariables
    )
    $variables = foreach ($variable in $QueryVariables | Get-Member -MemberType NoteProperty) {
        $name = $variable.Name.ToLower()
        $value = $QueryVariables."$($variable.Name)"
        "$name=$value"
    }
    if ($variables) {
        Write-Output ('?' + (Join-Parts -Separator '&' -Parts $variables))
    }
}