function Set-WindowTitle {
	<#
	.SYNOPSIS
	Sets a custom title Powershell console window

	.PARAMETER Title
	Title to set

	.EXAMPLE
	Set-WindowTitle -Title 'new title'
	#>
	param(
		[parameter(ValueFromPipeline, Position = 0)]
		[String]$Title = ''
	)

	$Host.UI.RawUI.WindowTitle = $Title
}
