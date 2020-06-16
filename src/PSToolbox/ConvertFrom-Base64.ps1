function ConvertFrom-Base64 {
    <#
    .SYNOPSIS
    Converts a Base64 string to its original value
    
    .PARAMETER Value
    The Base64 string to convert
    
    .PARAMETER Encoding
    Optional Encoding to sue; default: Unicode
    
    .EXAMPLE
    ConvertFrom-Base64 -Value $myObject
    #>
    param(
        [parameter(mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Value,

        [parameter()]
        [System.Text.Encoding]$Encoding = [System.Text.Encoding]::Unicode
    )

    process {
        foreach ($item in $Value) {
            $bytes = [System.Convert]::FromBase64String($item)
            $Encoding.GetString($bytes)
        }
    }
}
