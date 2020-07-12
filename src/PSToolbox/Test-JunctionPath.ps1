function Test-JunctionPath {
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
        $pathTockens = $Path -split '\\' | Select-Object -Skip 1
        $pathToTest = Split-Path -Path $Path -Qualifier

        foreach ($token in $pathTockens) {
            $pathToTest = Join-Path -Path $pathToTest -ChildPath $token
            $item = Get-Item -Path $pathToTest
            if ($item.LinkType -eq 'Junction') {
                $true
                break
            }
        }
    }
}