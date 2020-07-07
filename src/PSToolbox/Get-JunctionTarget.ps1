function Get-JunctionTarget {
    [CmdletBinding()]
    param (
        [parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateScript( { Test-Path -Path $_ })]
        [Alias('FullName')]
        [string]$Path
    )

    process {
        # get the path tokens but skip the Qualifier (drive root)
        $pathTockens = $Path -split '\\' #| Select-Object * -Skip 1
        $pathToTest = Split-Path -Path $Path -Qualifier

        foreach ($token in $pathTockens) {
            $pathToTest = Join-Path -Path $pathToTest -ChildPath $token
            $pathToTest
        }
    }
}