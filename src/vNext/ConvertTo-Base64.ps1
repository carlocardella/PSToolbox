function ConvertTo-Base64 {
    <#
    .SYNOPSIS
    Converts an object to its Base64 representation

    .PARAMETER Value
    The object to convert

    .PARAMETER Encoding
    Optional Encoding to use; default: Unicode

    .EXAMPLE
    An example
    #>
    param(
        [parameter(mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Value,

        [parameter()]
        [System.Text.Encoding]$Encoding = [System.Text.Encoding]::Unicode
    )

    process {
        foreach ($item in $Value) {
            $bytes = $Encoding.GetBytes($item)
            [Convert]::ToBase64String($bytes)
        }
    }
}
