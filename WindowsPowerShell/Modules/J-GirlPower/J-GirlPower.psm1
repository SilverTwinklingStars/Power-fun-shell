[string]$sourceBase = "C:\Sources\Personal\"

. $PSScriptRoot\Objects-Init.ps1

Get-ChildItem -Path $PSScriptRoot\Functions\*.ps1 |% { . $_.FullName }
Export-ModuleMember -Function * -Alias *
