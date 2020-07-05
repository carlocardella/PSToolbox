function Remove-DuplicateModule {
    <#
    .SYNOPSIS
    Removes outdated module versions and keeps the most recent one

    .DESCRIPTION
    Over time you may be in a situation where multiple, oudated versins of the same module are installed on the machine, for example:

        Get-Module az.* -ListAvailable

            Directory: C:\Users\carlo\Documents\PowerShell\Modules

        ModuleType Version    PreRelease Name                                PSEdition ExportedCommands
        ---------- -------    ---------- ----                                --------- ----------------
        Script     1.8.1                 Az.Accounts                         Core,Desk {Disable-AzDataCollection, Disable-AzContextAutosave, Enable-AzDataCollection, Enable-AzContextAutosa…
        Script     1.8.0                 Az.Accounts                         Core,Desk {Disable-AzDataCollection, Disable-AzContextAutosave, Enable-AzDataCollection, Enable-AzContextAutosa…
        Script     1.7.5                 Az.Accounts                         Core,Desk {Disable-AzDataCollection, Disable-AzContextAutosave, Enable-AzDataCollection, Enable-AzContextAutosa…
        Script     1.1.1                 Az.Advisor                          Core,Desk {Get-AzAdvisorRecommendation, Enable-AzAdvisorRecommendation, Disable-AzAdvisorRecommendation, Get-Az…
        Script     1.1.1                 Az.Aks                              Core,Desk {Get-AzAks, New-AzAks, Remove-AzAks, Import-AzAksCredential…}
        Script     1.0.3                 Az.Aks                              Core,Desk {Get-AzAks, New-AzAks, Remove-AzAks, Import-AzAksCredential…}
        Script     0.1.2                 Az.AlertsManagement                 Core,Desk {Get-AzAlert, Get-AzAlertObjectHistory, Update-AzAlertState, Measure-AzAlertStatistic…}
        Script     0.1.1                 Az.AlertsManagement                 Core,Desk {Get-AzAlert, Get-AzAlertObjectHistory, Update-AzAlertState, Measure-AzAlertStatistic…}
        Script     1.1.3                 Az.AnalysisServices                 Core,Desk {Resume-AzAnalysisServicesServer, Suspend-AzAnalysisServicesServer, Get-AzAnalysisServicesServer, Rem…
        Script     1.1.2                 Az.AnalysisServices                 Core,Desk {Resume-AzAnalysisServicesServer, Suspend-AzAnalysisServicesServer, Get-AzAnalysisServicesServer, Rem…
        Script     2.0.1                 Az.ApiManagement                    Core,Desk {Add-AzApiManagementApiToProduct, Add-AzApiManagementProductToGroup, Add-AzApiManagementRegion, Add-A…
        Script     2.0.0                 Az.ApiManagement                    Core,Desk {Add-AzApiManagementApiToProduct, Add-AzApiManagementProductToGroup, Add-AzApiManagementRegion, Add-A…
        Script     1.4.1                 Az.ApiManagement                    Core,Desk {Add-AzApiManagementApiToProduct, Add-AzApiManagementProductToGroup, Add-AzApiManagementRegion, Add-A…
        Script     0.1.4                 Az.AppConfiguration                 Core,Desk {Get-AzAppConfigurationStore, Get-AzAppConfigurationStoreKey, Get-AzAppConfigurationStoreKeyValue, Ne…
        Script     1.1.0                 Az.ApplicationInsights              Core,Desk {Get-AzApplicationInsights, New-AzApplicationInsights, Remove-AzApplicationInsights, Update-AzApplica…
        Script     1.0.3                 Az.ApplicationInsights              Core,Desk {Get-AzApplicationInsights, New-AzApplicationInsights, Remove-AzApplicationInsights, Set-AzApplicatio…
        Binary     1.0.1                 Az.ApplicationMonitor               Desk
        Script     0.1.7                 Az.Attestation                      Core,Desk {New-AzAttestation, Get-AzAttestation, Remove-AzAttestation, Get-AzAttestationPolicy…}
        Script     1.3.6                 Az.Automation                       Core,Desk {Get-AzAutomationHybridWorkerGroup, Remove-AzAutomationHybridWorkerGroup, Get-AzAutomationJobOutputRe…
        Script     3.0.0                 Az.Batch                            Core,Desk {Remove-AzBatchAccount, Get-AzBatchAccount, Get-AzBatchAccountKey, New-AzBatchAccount…}
        Script     2.0.2                 Az.Batch                            Core,Desk {Remove-AzBatchAccount, Get-AzBatchAccount, Get-AzBatchAccountKey, New-AzBatchAccount…}
        Script     1.0.3                 Az.Billing                          Core,Desk {Get-AzBillingInvoice, Get-AzBillingPeriod, Get-AzEnrollmentAccount, Get-AzConsumptionBudget…}
        Script     1.0.2                 Az.Billing                          Core,Desk {Get-AzBillingInvoice, Get-AzBillingPeriod, Get-AzEnrollmentAccount, Get-AzConsumptionBudget…}
        Script     0.2.13                Az.Blueprint                        Core,Desk {Get-AzBlueprint, Get-AzBlueprintAssignment, New-AzBlueprintAssignment, Remove-AzBlueprintAssignment…}
        Script     0.2.12                Az.Blueprint                        Core,Desk {Get-AzBlueprint, Get-AzBlueprintAssignment, New-AzBlueprintAssignment, Remove-AzBlueprintAssignment…}
        [...]

    Removing all those outdated modules can be tedious and time consuming, this function automates the task.
    By default the function uses 'Get-Module -ListAvailable' to retrieve the list of modules available in $env:PSModulePath, but you can specify a list of folders to scan instead of searching all available locations.

    .PARAMETER Folder
    Full path to the folder(s) you want to scan for duplicate modules

    .PARAMETER Force
    Suppresses the confirmation prompt when removing old module

    .EXAMPLE
    Remove-DuplicateModule -WhatIf

    What if: Performing the operation "Remove module" on target "C:\Users\myuser\Documents\PowerShell\Modules\Az.Accounts\1.7.5".
    What if: Performing the operation "Remove module" on target "C:\Users\myuser\Documents\PowerShell\Modules\Az.Accounts\1.8.0".
    What if: Performing the operation "Remove module" on target "C:\Users\myuser\Documents\PowerShell\Modules\Az.Aks\1.0.3".
    What if: Performing the operation "Remove module" on target "C:\Users\myuser\Documents\PowerShell\Modules\Az.AlertsManagement\0.1.1".
    What if: Performing the operation "Remove module" on target "C:\Users\myuser\Documents\PowerShell\Modules\Az.AnalysisServices\1.1.2".
    What if: Performing the operation "Remove module" on target "C:\Users\myuser\Documents\PowerShell\Modules\Az.ApiManagement\1.4.1".
    What if: Performing the operation "Remove module" on target "C:\Users\myuser\Documents\PowerShell\Modules\Az.ApiManagement\2.0.0".
    What if: Performing the operation "Remove module" on target "C:\Users\myuser\Documents\PowerShell\Modules\Az.ApplicationInsights\1.0.3".
    What if: Performing the operation "Remove module" on target "C:\Users\myuser\Documents\PowerShell\Modules\Az.Batch\2.0.2".
    What if: Performing the operation "Remove module" on target "C:\Users\myuser\Documents\PowerShell\Modules\Az.Billing\1.0.2".
    What if: Performing the operation "Remove module" on target "C:\Users\myuser\Documents\PowerShell\Modules\Az.Compute\3.7.0".
    What if: Performing the operation "Remove module" on target "C:\Users\myuser\Documents\PowerShell\Modules\Az.DataFactory\1.7.0".
    What if: Performing the operation "Remove module" on target "C:\Users\myuser\Documents\PowerShell\Modules\Az.DataFactory\1.8.0".
    What if: Performing the operation "Remove module" on target "C:\Users\myuser\Documents\PowerShell\Modules\Az.DataShare\0.1.2".

    .EXAMPLE
    Remove-DuplicateModule 'C:\Users\myuser\Documents\Powershell\Modules\Az.Blueprint','C:\Users\myuser\Documents\Powershell\Modules\Az.CognitiveServices' -WhatIf

    What if: Performing the operation "Remove module" on target "C:\Users\myuser\Documents\Powershell\Modules\Az.Blueprint\0.2.12".
    What if: Performing the operation "Remove module" on target "C:\Users\myuser\Documents\Powershell\Modules\Az.CognitiveServices\1.3.0".

    .EXAMPLE
    Remove-DuplicateModule 'C:\Users\myuser\Documents\Powershell\Modules\Az.Blueprint','C:\Users\myuser\Documents\Powershell\Modules\Az.CognitiveServices' -Verbose -Force

    VERBOSE: Az.Blueprint, 0.2.12
    VERBOSE: Az.CognitiveServices, 1.3.0
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [parameter(Position = 0)]
        [ValidateScript( { Test-Path $_ })]
        [string[]]$Folder,

        [parameter()]
        [switch]$Force
    )

    if (! [string]::IsNullOrWhiteSpace($Folder)) {
        $groups = Get-ChildItem -Path $Folder -Recurse -Filter '*.psd1' | ForEach-Object {
            Test-ModuleManifest -Path $_.FullName -ErrorAction 'SilentlyContinue' -Verbose:$false
        } | Group-Object 'Name' | Where-Object 'Count' -GT 1
    }
    else {
        $groups = Get-Module -ListAvailable -Verbose:$false | Where-Object Path -Like "$env:USERPROFILE*" | Group-Object 'Name' | Where-Object 'Count' -GT 1
    }

    foreach ($group in $groups) {
        $versions = $null
        $versions = $group.Group | Sort-Object 'Version' | Select-Object -SkipLast 1
        $versionToKeep = $null
        $versionToKeep = $group.Group | Sort-Object 'Version' | Select-Object -Last 1

        foreach ($version in $versions) {
            # this is needed because a module in a subfolder could have been already deleted after its parent
            if (Test-Path -Path $version.Path) {
                Write-Verbose "$($version.Name), $($version.Version)"

                $moduleFolder = $null
                $moduleFolder = Split-Path $version.Path -Parent
                if ($Force -or ($PSCmdlet.ShouldProcess("$moduleFolder", "Remove module"))) {
                    if ($Force -or ($PSCmdlet.ShouldContinue("Remove module?", "$moduleFolder"))) {
                        # todo: workaround for https://github.com/PowerShell/PowerShell/issues/9246 (https://github.com/PowerShell/PowerShell/issues/11721)
                        # todo: this does not address the problem if the path is a subfolder of a junction
                        Get-ChildItem -Path $moduleFolder -File -Recurse -Verbose:$false | ForEach-Object { Remove-Item $_ -Force -ErrorAction 'SilentlyContinue' -Verbose:$false }
                        # sleep 5
                        # note: for modules with subfolders I need to ignore the first error and run again the delete command, unless I want to have a recursive function
                        # Get-ChildItem -Path $moduleFolder -Recurse -Force -Verbose:$false | ForEach-Object { Remove-Item $_ -Force -ErrorAction 'SilentlyContinue' -Verbose:$false }
                        # Get-ChildItem -Path $moduleFolder -Recurse -Force | Remove-Item -Force
                        Remove-Item -Path $moduleFolder -Force
                    }
                }
            }
        }
    }
}