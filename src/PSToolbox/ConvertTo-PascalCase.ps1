function ConvertTo-PascalCase {
    <#
    .SYNOPSIS
        Converts the given string to PascalCasing

        NOTE: Pascal Casing is applied only it works are separated by spaces, otherwise
            the function cannot determine where to apply uppercases if the passed string is
            a single word, even if composite

    .EXAMPLE
        ConvertTo-PascalCase -String "conTerT tHIS TO PAScal casING"

        Contert This To Pascal Casing

    .EXAMPLE
        ConvertTo-PascalCase 'conVerT tHIs to paSCAL CaSe'

        Convert This To Pascal Case

    #>
    param(
        [parameter(mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, position = 1)]
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

            $s | % {

                if ($_ -eq '') {
                    $output += ' '
                }
                else {
                    $output += $_[0].ToString().ToUpper() + $_.substring(1).ToString().ToLower() + ' '
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
