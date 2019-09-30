<# 
 .Synopsis
  Creates a new feature branch on the current git repository and start working on it.

 .Description
  Creates a new feature branch based upon the current branch or the specified Source branch.
  Aborts if there are uncommitted changes to avoid accidental loss of changes.
  Automatically uses the latest version of the source branch.

 .Parameter FeatureName
  The branch name to create as feature branch.

 .Parameter Source
  The branch name to use as base for the feature branch. Can be another feature or a base branch.

  .Example
   # Start new feature
   New-Feature BW-123 development
#>
function New-Feature {
param(
	[Parameter(Mandatory=$true)]
	[string]$FeatureName,
	[string]$Source,
	[switch]$Force
)
	write-output "Starting new feature '$FeatureName'"
	
	$status = git status
	$shouldCommit = (($status |? { $_ -match "nothing to commit" }).Count -eq 0)
	if ($shouldCommit -and !($Force -and [string]::IsNullOrWhitespace($Source))) {
		if (![string]::IsNullOrWhitespace($status)) {
			write-output "Uncommited changes exist, please solve this first. Aborting ..."
		}
		return
	}
	
	if (![string]::IsNullOrWhitespace($Source)) {
		if ((Get-CurrentBranch) -ne $Source) {
			git checkout $Source -q
			write-output ("Switched to branch '$Source'")
		}
	}
	write-output ("[" + (Get-CurrentBranch) + "]: " + (git pull -p | Select-Object -First 1))

	git checkout -b $FeatureName -q
	write-output "Created branch '$FeatureName'"
	
	git push --set-upstream origin $FeatureName
	write-output "Created remote branch '$FeatureName'"	
}

# function Get-CurrentBranch {
#	return (git branch |? {$_.Startswith('*')}).Substring(2).Trim()
# }