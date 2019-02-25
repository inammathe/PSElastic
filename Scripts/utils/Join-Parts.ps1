function Join-Parts
{
    param
    (
        $Parts,
        $Separator
    )

    ($Parts | Where-Object { $_ } | ForEach-Object {
         ([string]$_).trim($Separator)
    } | Where-Object { $_ }) -join $Separator
}