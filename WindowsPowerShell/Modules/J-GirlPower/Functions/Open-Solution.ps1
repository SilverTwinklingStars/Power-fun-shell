<# 
 .Synopsis
  Goes to the source folder of the specified app. Optionally launches the solution.

 .Description
  Goes to the source folder of the specified app. Optionally launches the solution.

 .Parameter Application
  The application to go to.

 .Example
  # Goto to the application and start the Visual Studio.
  Open-Solution StaffApp

#>
function Open-Solution {
    [CmdletBinding()]
	param(
		[switch]$Navigate
	)
	DynamicParam {
		$attributes = new-object System.Management.Automation.ParameterAttribute
		$attributes.Mandatory = $true
		$attributes.Position = 1
	
		$ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($SolutionNames)
	
		$attributeCollection = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
		$attributeCollection.Add($attributes)
		$AttributeCollection.Add($ValidateSetAttribute)
	
		$dynApplicationParam = new-object -Type System.Management.Automation.RuntimeDefinedParameter("Application", [string], $attributeCollection)
			
		$paramDictionary = new-object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
		$paramDictionary.Add("Application", $dynApplicationParam)
		
		return $paramDictionary
	}
	
	begin {
		$Application=Write-Output $PSBoundParameters['Application']
	}
		
	process {
		$sol = $Solutions |? { $_.Name -like $Application} | Select-Object -First 1
		$initialLocation = Get-Location
		Set-Location $sol.FullPath
		Invoke-Expression (".\\" + $sol.Solution)
		if (!$Navigate) {
			Set-Location $initialLocation
		}
	}
}