function Test-PSVersionCompatibility {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER Path
    Parameter description
    
    .PARAMETER TargetVersions
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    ## https://devblogs.microsoft.com/powershell/using-psscriptanalyzer-to-check-powershell-version-compatibility/
    #>
    
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName)]
        [Alias('Fullname')]
        [string[]]$Path,

        [parameter()]
        [ValidateSet('2.0', '3.0', '5.0', '5.1', '6.0', '6.1', '6.2', '7.0', '7.1')]
        [string[]]$TargetVersions = @('5.1', '6.0', '6.1', '6.2', '7.0')
    )

    begin {
        if (!(Get-Module -Name 'PSScriptAnalyzer')) {
            throw "PSScriptAnalyzer not found, please make sure the module is available in PSModulePath. You can install it from the Powershell Gallery"
        }
        
        $settings = @{
            Rules = @{
                PSUseCompatibleSyntax = @{
                    # This turns the rule on (setting it to false will turn it off)
                    Enable         = $true
 
                    # List the targeted versions of PowerShell here
                    TargetVersions = $TargetVersions
                }
            }
        }
    }

    process {
        foreach ($file in $Path) {
            Invoke-ScriptAnalyzer -Path $(Resolve-Path -Path $file) -Settings $settings
        }
    }
}