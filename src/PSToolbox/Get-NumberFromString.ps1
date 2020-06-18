function Get-NumberFromString {
    <#
    .SYNOPSIS
    Return all numbers part of a string
    Return all numbers part of a string; the result is returned as string, not as int.
    If you pass/pipe multiple lines, each line will be treated and returned separately.

    .PARAMETER String
    String to extract numbers from

    .EXAMPLE
    Get-NumberFromString "this 1 string 5973 contains 335 numbers"

    15973335

    .EXAMPLE
    "you can pipe 547 commands 123 or text from 503 a file" | Get-NumberFromString

    547123503
    #>
    param (
        [parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$String
    )

    process {
        try {
            [String]::Join('', [System.Text.RegularExpressions.Regex]::Split($String, '[^\d]'))
        }
        catch { }
    }
}
