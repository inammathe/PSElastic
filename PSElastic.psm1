# Load Scripts
$scripts = Get-ChildItem $PSScriptRoot\Scripts -Filter "*.ps1" -Recurse
foreach ($script in $scripts){
    . $script.FullName
}
Export-ModuleMember $scripts.BaseName