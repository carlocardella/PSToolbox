function Get-NumberFromString {
    <#
    .SYNOPSIS
        Return all numbers part of a string

    .DESCRIPTION
        Return all numbers part of a string; the result is returned as string, not as int.
        If you pass/pipe multiple lines, each line will be treated and returned separately.

    .EXAMPLE
        Get-NumberFromString "this 1 string 5973 contains 335 numbers"

        15973335

    .EXAMPLE
        "you can pipe 547 commands 123 or text from 503 a file" | Get-NumberFromString

        547123503
    #>
    param (
        [parameter(mandatory = $true, valuefrompipeline = $true, position = 1)]
        ## string to extract numbers from
        [string]$String
    )

    process {
        try {
            [String]::Join('', [System.Text.RegularExpressions.Regex]::Split($String, '[^\d]'))
        }
        catch { }
    }
}
