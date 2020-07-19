function Build-Module {
    <#
    .SYNOPSIS
    Runs ScriptAnalyzer and Pester tests on the given module

    .PARAMETER ModulePath
    Full path to the folder containing the module to build

    .PARAMETER TestsPath
    Full path to the folder containing the Tests.ps1 Pester files to execute

    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory, Position = 0)]
        [ValidateScript( { Test-Path -Path $_ })]
        [string]$ModulePath,

        [parameter(Mandatory, Position = 1)]
        [ValidateScript( { Test-Path -Path $_ })]
        [string]$TestsPath
    )

    $psDataFile = Get-ChildItem -Path $ModulePath -Filter '*.psd1'
    Write-Verbose "Powershell Data File: $($psDataFile.FullName)"

    $psModuleFile = Get-ChildItem -Path $ModulePath -Filter '*.psm1'
    Write-Verbose "Powershell Module File: $($psModuleFile.FullName)"

    $ps1 = Get-ChildItem -Path $ModulePath -Filter '*.ps1'
    Write-Verbose "Other ps1 files: $($ps1.FullName)"

    Write-Verbose "Invoke Script Analyzer"
    Invoke-ScriptAnalyzer -Path $ModulePath -Verbose:$false

    Write-Verbose "Run Peter tests"
    Invoke-Pester -Path $TestsPath -Output 'Detailed' -PassThru -Verbose:$false
}