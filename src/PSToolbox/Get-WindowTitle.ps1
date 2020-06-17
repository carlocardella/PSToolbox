function Get-WindowTitle {
	<#
	.SYNOPSIS
	Gets a custom title Powershell console window

	.EXAMPLE
	Get-WindowTitle
	
	C:\Program Files\PowerShell\7\pwsh.exe
	#>
	param()

	$Host.UI.RawUI.WindowTitle
}
