function Deploy-LSEModule {
    <#
    .SYNOPSIS
    This function deployis the specificed module under the AllUsers or CurrentUser module folder.
    AllUsers requires the console to be run as Administrator (elevated)

    .PARAMETER ModulePath
    Path (Fullname) of the folder containing the Module to deploy

    .PARAMETER Scope
    Deploy the module for AllUsers or CurrentUser; AllUSers require to run the console as administrator (elevated)

    .PARAMETER Force
    Suppress the confirmation prompt to copy the module

    .EXAMPLE
    Deploy-LSEModule -ModulePath .\Git\LSEBuildModule\LSEBuildModule -Force

    ModuleType Version    Name                                ExportedCommands
    ---------- -------    ----                                ----------------
    Script     0.3.0      LSEBuildModule

    This command deploys the module to the CurrentUser module folder
    #>

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'profile')]
    [OutputType([System.Management.Automation.PSModuleInfo])]
    param (
        [parameter(Mandatory, Position = 0)]
        [ValidateScript( { Test-Path -Path $_ -PathType 'Container' })]
        [string]$ModulePath,

        [parameter(Position = 2, ParameterSetName = 'profile')]
        [ValidateSet('AllUsers', 'CurrentUser')]
        [string]$Scope = 'CurrentUser',

        [parameter(ParameterSetName = 'customfolder')]
        [ValidateScript( { Test-Path -Path $_ -PathType 'Container' })]
        [string]$TargetPath,

        [parameter()]
        [switch]$Force
    )

    if ($Scope -eq 'AllUsers') {
        if (! (Test-IsAdmin)) {
            Write-Error "To deploy the module for AllUsers please open Powershell as Administrator (elevated)"
            return
        }
    }

    Write-Verbose "Validate module data file"
    $psDataFile = Get-ChildItem -Path $ModulePath -Filter '*.psd1'
    Test-ModuleManifest -Path $psDataFile -ErrorAction 'Stop'
    $moduleName = Split-Path -Path $ModulePath -Leaf
    $moduleVersion = (Import-PowerShellDataFile -Path $psDataFile).ModuleVersion

    $moduleLocation = $null
    if ($PSCmdlet.ParameterSetName -eq 'profile') {
        switch ($Scope) {
            CurrentUser {
                $moduleLocation = Split-Path -Path $profile.CurrentUserAllHosts -Parent
                $moduleLocation = Join-Path -Path $moduleLocation -ChildPath 'Modules'

                if ($IsMacOS) {
                    $moduleLocation = Join-Path -Path (Resolve-Path ~) -ChildPath '.local/share/powershell/Modules'
                }

                if ($IsLinux) {
                    throw [System.Exception]::new("This function is not supported on Linux yet")
                }
            }

            AllUsers {
                $moduleLocation = Split-Path -Path $profile.AllUsersAllHosts -Parent
                $moduleLocation = Join-Path -Path $moduleLocation -ChildPath 'Modules'
            }
        }
    }
    else {
        $moduleLocation = $TargetPath
    }

    if (! (Test-Path -Path $moduleLocation)) {
        Write-Error -Exception [System.IO.DirectoryNotFoundException] -TargetObject $moduleLocation
    }

    $moduleFullname = Join-Path -Path $moduleLocation -ChildPath $moduleName

    if ($Force -or ($PSCmdlet.ShouldProcess("$ModulePath", "Deploy $ModulePath to $Scope"))) {
        if ($Force -or ($PSCmdlet.ShouldContinue("Deploy $ModulePath to $Scope?", "Deploy $ModulePath to $Scope"))) {
            if (! (Test-Path -Path $moduleFullname)) {
                New-Item -ItemType 'Directory' -Path $moduleFullname -Force -ErrorAction 'Stop' | Out-Null
            }

            if (Test-Path -Path $moduleFullname) {
                $newVersionFolder = New-Item -ItemType 'Directory' -Path $moduleFullname -Name $moduleVersion -Force -ErrorAction 'Stop'
                Copy-Item -Path "$ModulePath\*" -Recurse -Destination $newVersionFolder.FullName -Force -ErrorAction 'Stop'
            }
        }
    }
}