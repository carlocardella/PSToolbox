function ConvertTo-CamelCase {
    <#
    .SYNOPSIS
    Converts the given string to camelCasing

    NOTE: camel casing is applied only if works are separated by spaces, otherwise the function cannot determine where to apply uppercases if the passed string is a single word, even if composite

    .EXAMPLE
    ConvertTo-CamelCase -String "conTerT tHIS TO CAMel casING"

    contert This To Camel Casing

    .EXAMPLE
    ConvertTo-CamelCase 'conVerT tHIs to caMEl CaSe'

    convert This To Camel Case
    #>
    param(
        [parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('Value', 'Input')]
        [string]$String,

        [parameter()]
        [switch]$RemoveWhiteSpaces
    )

    process {
        foreach ($s in $String) {
            $output = ''
            $s = $s -split ' '
            $indexZero = $true

            $s | ForEach-Object {

                if ($_ -eq '') {
                    $output += ' '
                }
                else {
                    if ($indexZero) {
                        $output += $_[0].ToString().ToLower() + $_.substring(1).ToString().ToLower() + ' '
                        $indexZero = $false
                    }
                    else {
                        $output += $_[0].ToString().ToUpper() + $_.substring(1).ToString().ToLower() + ' '
                    }
                }
            }

            if ($RemoveWhiteSpaces) {
                $output.Replace(' ', '').Trim()
            }
            else {
                $output.Trim()
            }
        }
    }
}
