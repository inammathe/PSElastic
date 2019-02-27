function Get-QueryString {
    param (
        [PSCustomObject]$QueryVariables
    )
    $variables = foreach ($variable in $QueryVariables.PSObject.Properties) {
        "$($variable.Name.ToLower())=$($variable.Value)"
    }
    if ($variables) {
        Write-Output ('?' + (Join-Parts -Separator '&' -Parts $variables))
    }
}