function Get-QueryString {
    param (
        $QueryVariables
    )
    $variables = foreach ($variable in $QueryVariables) {
        "$($variable.Name.ToLower())=$($variable.Value)"
    }
    if ($variables) {
        Write-Output ('?' + (Join-Parts -Separator '&' -Parts $variables))
    }
}