function Test-Json {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $JSON
    )
    try {
        ConvertFrom-Json $JSON -ErrorAction Stop | Out-Null
        Write-Output $true
    } catch {
        Write-Output $false
    }
}