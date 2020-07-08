<# 
 .Synopsis
  Updates the AD password of an account

 .Description
  Updates the AD password of an account. This script auto-checks if the required modules are present and tries to download or install them if needed. The download requires administrative permissions.

 .Parameter User
  The name of the account to change

 .Parameter OldPassword
  The old password

 .Parameter NewPassword
  The new password

  .Example
   # Update Password for elina from azerty123 to qwerty123
   Update-Password elina "azerty123" "qwerty123"
#>
function Update-Password {
param(
	[Parameter(Mandatory=$true)]
	[string]$User,
	[Parameter(Mandatory=$true)]
	[string]$OldPassword,
	[Parameter(Mandatory=$true)]
	[string]$NewPassword
)

	$loadedModule = Get-Module ActiveDirectory
	if ($null -eq $loadedModule) {
		$installedModule = Get-Module -ListAvailable ActiveDirectory
		if ($null -ne $installedModule) {
			Write-Host "Active directory module not loaded, importing the module."
			Import-Module ActiveDirectory
		} else {
			Write-Host "Checking for elevated permissions..."
			$principal = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
			if (-NOT $principal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
				Write-Host "Elevating permissions."
				Start-Process Powershell -ArgumentList $PSCommandPath -Verb RunAs
				break
			} else {
				$capability = Get-WindowsCapability -online -Name RSAT.ActiveDirectory*
				if ($null -eq $capability) {
					Write-Host "ActiveDirectory LDAP module could not be found to install. Aborting."
					break
				}
				if ($capability.State -ne "Installed") {
					Add-WindowsCapability -name $capability.Name -online
				} else {
					Write-Host "ActiveDirectory LDAP module found and installed but the module is not present. Aborting."
					break
				}
			}				
		}
	}
		
	$oldpwd = (ConvertTo-SecureString -AsPlainText $OldPassword -Force)
	$newpwd = (ConvertTo-SecureString -AsPlainText $NewPassword -Force)
	Set-ADAccountPassword -Identity $User -OldPassword $oldpwd -NewPassword $newpwd
}
