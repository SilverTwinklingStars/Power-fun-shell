<# 
 .Synopsis
  Refreshes the sources in the git repository in the current git repository

 .Description
  Refreshes the sources in the current git repository. It saves your work - if any - in a local backup 
  branch to avoid accidental change loss.

 .Parameter RemoteBranch
  The branch name to refresh.

 .Parameter LocalBranch
  The local branch name to save the work to.

  .Parameter RebaseToLocal
  Rebase on the local branch.

  .Example
   # Refresh the sources.
   Start-GitSafePull master
#>
function Start-GitSafePull {
param(
	[Parameter(Mandatory=$true)]
	[string]$RemoteBranch,
	[string]$LocalBranch,
	[switch]$RebaseToLocal
)
	write-output "Starting Refresh of Git Repository"
	
	$status = git status
	$shouldCommit = (($status |? { $_ -match "nothing to commit" }).Count -eq 0)
	if ($shouldCommit) {
		if (![string]::IsNullOrWhitespace($status)) {
			write-output "Uncommited changes exist, please solve this first. Aborting ..."
		}
		return
		
	}

	write-output "Pulling the latest sources"
	if ((Get-CurrentBranch) -ne $RemoteBranch) {
		git checkout $RemoteBranch -q
		write-output ("Switched to branch '$RemoteBranch'")
	}
	write-output ((Get-CurrentBranch) + ": " + (git pull -p| Select-Object -First 1))

	if ([string]::IsNullOrWhitespace($LocalBranch)) {
		return
	}

	$branchExist = ((git branch |? { $_ -match $LocalBranch }).Count -eq 1)
	[switch]$rebaseUsefull = $true
	if ($branchExist) {
		if ((Get-CurrentBranch) -ne $LocalBranch) {
			git checkout -q
			write-output ("Switched to branch '$RemoteBranch'")
		}
	} else {
		write-output "Creating new branch '$LocalBranch'"
		git checkout -b $LocalBranch |% { "${LocalBranch}: $_" }
		$rebaseUsefull = $false
	}
	
	if ($rebaseUsefull -and $RebaseToLocal) {
		write-output "Rebasing '$RemoteBranch' into '$LocalBranch'"
		git rebase $RemoteBranch |% { "${RemoteBranch}: $_" }
	}
}

function Get-CurrentBranch {
	return (git branch |? {$_.Startswith('*')}).Substring(2).Trim()
}