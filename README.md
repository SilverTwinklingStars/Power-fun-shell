# Power-fun-shell

Hi everyone!

This is just a small fun repo keeping track of my actively, daily used powershell commands.

It also makes it easy to create your own fun.
Fork the repo or just download the content of the `WindowsPowerShell` folder into your own `WindowsPowerShell` folder.

# How does it work?

The profile gets executing the `profile.ps1` (previously: `Microsoft.Powershell_profile.ps1`) [(powershell magic)](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-6).
This script currenly does 2 things. 
* It gives me an easy alias on my notepad++ 
* It imports my module **J-GirlPower** (spoiler: yes, I'm female).

The module **J-GirlPower** is defined in the folder with the same name using two files also bearing the same name: J-GirlPower.psd1 and J-GirlPower.psm1

# psdm1 file aka "the definition"

This file contains the definition of the module. Actually there are only a few interesting lines in this file:
* `RootModule = 'J-GirlPower.psm1'`
* Exports:
	* `FunctionsToExport = '*'`
	* `CmdletsToExport = '*'`
	* `VariablesToExport = '*'`
	* `AliasesToExport = '*'`
	
# psm1 file aka "the real stuff"

This file contains only one really necessary block:
```powershell
Get-ChildItem -Path $PSScriptRoot\Functions\*.ps1 |% { . $_.FullName }
Export-ModuleMember -Function * -Alias *
```

# Customization and adding your own fun

## Make the module your own!
Rename the **J-GirlPower** to your _own brand_! Just find the name and replace it everywhere you find it (hint: 5 times).

## Make new functions!
Easy! Copy one of the scripts in `Functions` folder, rename it to your liking and edit. 

Don't forget to keep the function in the file in sync with name of the file. Otherwise you will end up with a dirty goo that will let your nose cringe everytime you look at it.


# PowerShell profile

If you would like to know where you find your `WindowsPowershell` folder, it should be in `%userprofile%\Documents`. If it's not there, just make one! It's great to have that folder.

For more explanation on your [powershell profile](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-6), click the link.
