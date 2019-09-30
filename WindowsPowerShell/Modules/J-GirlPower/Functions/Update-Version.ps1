<# 
 .Synopsis
  Updates the assembly info files in a project to the requested version.

 .Description
  Updates the assembly info files in a project to the requested version.

 .Parameter Version
  The version to use.

 .Parameter Path
  The path to search recursively for assembly info files.

 .Example
  # Update to version searching from the current folder.
  Update-Version "1.7.0.0"
#>
function Update-Version {
[CmdletBinding()]
param(
	[Parameter(Mandatory=$true)]
	[System.Version]$Version,
	[string]$Path = "."
)
	$longVersion = $Version.ToString(4)
	$shortVersion = $Version.ToString(3)
	$currentLocation = Get-Location
	Set-Location $Path
	$infoFiles = (get-childitem assemblyinfo.cs -recurse)
	foreach($infoFile in $infoFiles) {
		$newContent = get-content $infoFile |% { $_ -replace '(\[assembly:\s*AssemblyVersion\()("\d+[.\d+]{1,3}.*")(\)])', ('$1'+"""$shortVersion"""+'$3')}
		$newContent = $newContent |% { $_ -replace '(\[assembly:\s*AssemblyFileVersion\()(".*")(\)])', ('$1'+"""$longVersion"""+'$3')}
		$newContent = $newContent |% { $_ -replace '(\[assembly:\s*AssemblyInformationalVersion\()(".*")(\)])', ('$1'+"""$longVersion"""+'$3')}
		set-content -path ($infoFile.FullName) -Value $newContent
	}
	Set-Location $currentLocation
}