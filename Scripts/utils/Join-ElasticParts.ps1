<#
.SYNOPSIS
    Joins parts of of an object based on a seperator
.DESCRIPTION
    This utility function is used to join any number of objects seperated by a seperator
.EXAMPLE
    PS C:\> Join-ElasticParts -Parts ('https://test','url','endpoint') -Separator '/'
    Returns https://test/url/endpoint
#>
function Join-ElasticParts
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