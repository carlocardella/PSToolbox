function Set-OneDriveFileProperties {
    param (
        [parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateScript( { Test-Path $_ })]
        [Alias('FullName')]
        [string[]]$Path
    )

    process {
        foreach ($p in $Path) {
            Write-Verbose $p
            if ((Get-Item $p -Force).Attributes -match 'Hidden') {
                attrib.exe $p +P +H /D /S
            }
            else {
                attrib.exe $p +P /D /S
            }
        }
    }
}