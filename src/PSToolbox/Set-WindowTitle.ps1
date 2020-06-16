function Set-WindowTitle {
    <#
	.SYNOPSIS
	Sets a custom title Powershell console window

	.PARAMETER Title
	Title to set

	.EXAMPLE
	Set-WindowTitle -Title
	#>
    param(
        [String]$title = ''
    )

    $Host.UI.RawUI.WindowTitle = $title
}
