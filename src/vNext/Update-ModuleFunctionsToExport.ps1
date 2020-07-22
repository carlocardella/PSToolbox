function Update-ModuleFunctionsToExport {
    <#
    .SYNOPSIS
    Updates FunctionsToExport in a module manifest by listing the ps1 files in the module, or using a list of functions passed as parameter
    
    .PARAMETER DataFilePath
    Path to the module manifest
    
    .PARAMETER Functions
    List of functions to add to the module manifest
    
    .PARAMETER Force
    Suppresses the confirmation prompt
    
    .EXAMPLE
    Update-ModuleFunctionsToExport -DataFilePath \MyModule\MyModule.psd1 -Force
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateScript( { Test-Path -Path $_ })]
        [ValidateScript( { Test-ModuleManifest $_ })]
        [Alias('Fullname')]
        [string]$DataFilePath,

        [parameter()]
        [string[]]$Functions,

        [parameter()]
        [switch]$Force
    )

    $moduleRootFolder = Split-Path -Path $DataFilePath -Parent

    if ($Functions.Count -eq 0) {
        $Functions = Get-ChildItem -Path $moduleRootFolder -Filter "*.ps1" | Select-Object -ExpandProperty 'Name' | Split-Path -LeafBase
    }
    
    if ($Force -or ($PScmdlet.ShouldProcess("$(Split-Path -Path $DataFilePath -Leaf)", 'Update data file'))) {
        if ($Force -or ($PSCmdlet.ShouldContinue('Update data file', 'Update data file?'))) {
            Update-ModuleManifest -Path $DataFilePath -FunctionsToExport $Functions
        }
    }
}