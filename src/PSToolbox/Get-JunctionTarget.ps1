function Get-JunctionTarget {
    [CmdletBinding()]
    param (
        [parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateScript( { Test-Path -Path $_ })]
        [ValidateScript( { if (!(Split-Path -Path $_ -Qualifier)) { 
                    throw [System.ArgumentException]::new("Invalid path provided, must be a local drive")
                }
                $true
            }
        )]
        [Alias('FullName')]
        [string]$Path
    )

    process {
        # get the path tokens but skip the Qualifier (drive root)
        # $pathTokens = $Path -split '\\' | Select-Object -Skip 1
        $pathTokens = $Path -split '\\' #| Select-Object -Skip 1
        $pathToTest = Split-Path -Path $Path -Qualifier

        # foreach ($token in $pathTokens) {
        #     $pathToTest = Join-Path -Path $pathToTest -ChildPath $token
        #     $item = Get-Item -Path $pathToTest
        #     if ($item.LinkType -eq 'Junction') {
        #         $item
        #         break
        #     }
        # }
        for ($i = 1; $i -le $pathTokens.Length; $i++) {
            $pathToTest = Join-Path $pathToTest -ChildPath $pathTokens[$i]
            $item = Get-Item -Path $pathToTest
            if ($item.LinkType -eq 'Junction') {
                # $item
                $junctionTaget = Join-Path -Path $item.Target -ChildPath ($pathTokens[$i..100] -join '\')
                $junctionTaget
                break
            }
        }
    }
}