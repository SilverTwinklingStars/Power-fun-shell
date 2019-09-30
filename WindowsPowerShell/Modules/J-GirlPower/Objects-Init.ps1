Set-Variable -scope Script SourcesBtbRoot "C:\Sources\BTB\"
Set-Variable -scope Script Solutions (New-Object System.Collections.ArrayList)
Export-ModuleMember -Variable Solutions
Export-ModuleMember -Variable SourcesBtbRoot

$cachefilename = Join-Path $PSScriptRoot "solutiondump.xml"
$cache = Get-Item $cachefilename -ErrorAction Ignore

if ($null -eq $cache) {
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
			$Solutions.Add($solObject)
		}
	}
	$Solutions | Export-Clixml $cachefilename
} else {
	$Solutions = Import-Clixml $cachefilename
}

Set-Variable -scope Script -Option ReadOnly SolutionNames ($Solutions |% { $_.Name })
Export-ModuleMember -Variable SolutionNames
