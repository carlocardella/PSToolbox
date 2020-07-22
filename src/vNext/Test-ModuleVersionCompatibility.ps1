function Test-ModuleVersionCompatibility {
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
        [parameter(ValueFromPipelineByPropertyName, Position = 0)]
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
                PSUseCompatibleSyntax    = @{
                    # This turns the rule on (setting it to false will turn it off)
                    Enable         = $true

                    # List the targeted versions of PowerShell here
                    TargetVersions = $TargetVersions
                }

                PSUseCompatibleCmdlets   = @{
                    'compatibility' = @(
                        'desktop-5.1.14393.206-windows',
                        'core-6.1.0-windows',
                        'core-6.1.0-linux',
                        'core-6.1.0-linux-arm',
                        'core-6.1.0-macos',
                        'core-7.0.2-windows',
                        'core-7.0.2-linux',
                        'core-7.0.2-macos'
                    )
                }

                PSUseCompatibleCommmands = @{
                    Enable         = $true
                    TargetProfiles = @(
                        'win-8_x64_10.0.14393.0_5.1.14393.2791_x64_4.0.30319.42000_framework',
                        'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework',
                        'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework',
                        'win-8_x64_10.0.14393.0_6.1.3_x64_4.0.30319.42000_core',
                        'win-8_x64_10.0.17763.0_6.1.3_x64_4.0.30319.42000_core',
                        'win-48_x64_10.0.17763.0_6.1.3_x64_4.0.30319.42000_core',
                        'ubuntu_x64_18.04_6.1.3_x64_4.0.30319.42000_core',
                        'debian_x64_9_6.1.3_x64_4.0.30319.42000_core',
                        'macos_x64_18.2.0.0_6.2.0_x64_4.0.30319.42000_core',
                        'rhel_x64_7.6_6.1.3_x64_4.0.30319.42000_core',
                        'win-8_x64_6.3.9600.0_6.1.3_x64_4.0.30319.42000_core'
                    )
                }

                PSUseCompatibleTypes     = @{
                    Enable         = $true
                    TargetProfiles = @(
                        'win-8_x64_10.0.14393.0_5.1.14393.2791_x64_4.0.30319.42000_framework',
                        'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework',
                        'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework',
                        'win-8_x64_10.0.14393.0_6.1.3_x64_4.0.30319.42000_core',
                        'win-8_x64_10.0.17763.0_6.1.3_x64_4.0.30319.42000_core',
                        'win-48_x64_10.0.17763.0_6.1.3_x64_4.0.30319.42000_core',
                        'ubuntu_x64_18.04_6.1.3_x64_4.0.30319.42000_core',
                        'debian_x64_9_6.1.3_x64_4.0.30319.42000_core',
                        'macos_x64_18.2.0.0_6.2.0_x64_4.0.30319.42000_core',
                        'rhel_x64_7.6_6.1.3_x64_4.0.30319.42000_core',
                        'win-8_x64_6.3.9600.0_6.1.3_x64_4.0.30319.42000_core'
                    )
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