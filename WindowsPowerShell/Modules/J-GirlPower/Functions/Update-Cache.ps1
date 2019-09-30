<# 
 .Synopsis
  Updates and reloads the solution cache

 .Description
  Update and reloads the solution cache


 .Example
  # Reload the solution cache.
  Update-Cache
#>
function Update-Cache {

Set-Variable Solutions (New-Object System.Collections.ArrayList)

$cachefilename = Join-Path $PSScriptRoot "..\\solutiondump.xml"
Remove-Item $cachefilename

foreach ( $folder in (Get-ChildItem $SourcesBtbRoot -Directory) ) {
	$file = Get-ChildItem $folder.FullName -File -Recurse -Filter *.sln | Select-Object -First 1
	if ($null -ne $file) {
		$solution = @{}
		$solution.Name = $folder.Name
		$solution.Solution = $file.Name
		$solution.RelativePath = $folder.Name
		$solution.FullPath = Join-Path $SourcesBtbRoot $folder.Name
		$solution.SolutionFullPath = $file.FullName
		$solObject = New-Object -TypeName PSObject -Prop $solution
		$devnull = $Solutions.Add($solObject)
	}
}
$Solutions | Export-Clixml $cachefilename

Set-Variable -Force SolutionNames ($Solutions |% { $_.Name })
}