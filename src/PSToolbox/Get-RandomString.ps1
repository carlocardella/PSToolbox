function Get-RandomString {
    <#
    .SYNOPSIS
    Returns a randomly generated string of the desired length and with the desired combination of characters (uppercase, lowercase, numbers, symbols)

    .PARAMETER Length
    Length of the string (number of characters) to return

    .PARAMETER Numbers
    The string must contain numbers

    .PARAMETER LowercaseLetters
    The string must contains lowercase letters

    .PARAMETER UppercaseLetters
    The string must contain uppercase letters

    .PARAMETER Symbols
    The string mut contain symbols and special characters

    .EXAMPLE
    Get-RandomString -Length 20 -UppercaseLetters -Numbers 1CVCB81ZZC05XYVEUN67
    #>

    [CmdletBinding()]
    param (
        [parameter(Position = 1)]
        [int]$Length = 15,

        [parameter()]
        [switch]$Numbers,

        [parameter()]
        [switch]$LowercaseLetters,

        [parameter()]
        [switch]$UppercaseLetters,

        [parameter()]
        [switch]$Symbols,

        [parameter()]
        [switch]$Space
    )

    if ($PSCmdlet.MyInvocation.BoundParameters.Count -le 1) {
        if (($PSCmdlet.MyInvocation.BoundParameters.Keys -eq 'Length') -or ($PSCmdlet.MyInvocation.BoundParameters.Count -eq 0)) {
            $Numbers = $true
            $LowercaseLetters = $true
            $UppercaseLetters = $true
            $Symbols = $true
        }
    }

    $characters = @()

    if ($Numbers) { $characters += @(48..57) }
    if ($Symbols) { $characters += @(33..47) + @(58..64) + @(91..96) + @(123..126) }
    if ($Space) { $characters += @(160) }
    if ($UppercaseLetters) { $characters += @(65..90) }
    if ($LowercaseLetters) { $characters += @(97..122) }

    -join ($characters * ($Length * 3) | Get-Random -Count $Length | ForEach-Object { [char]$_ })
}