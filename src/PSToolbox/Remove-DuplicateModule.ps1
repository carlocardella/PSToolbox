function Remove-DuplicateModule {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [parameter(Position = 0)]
        [ValidateScript( { Test-Path $_ })]
        [string]$ModuleFolder
    )

    if (! [string]::IsNullOrWhiteSpace($ModuleFolder)) {
        $groups = Get-Module -ListAvailable | Where-Object Path -EQ $ModuleFolder | Group-Object 'Name' | Where-Object Count -gt 1
    }
    else {
        $groups = Get-Module -ListAvailable | Where-Object Path -Like "$env:USERPROFILE*" | Group-Object 'Name' | Where-Object Count -gt 1
    }
    
    foreach ($group in $groups) {
        $versions = $null
        $versions = $group.Group | Sort-Object 'Version' | Select-Object -SkipLast 1
        $versionToKeep = $null
        $versionToKeep = $group.Group | Sort-Object 'Version' | Select-Object -Last 1

        Write-Verbose "$($versionToKeep.Name), $($versionToKeep.Version)"
    
        foreach ($version in $versions) {
            Write-Verbose "$($version.Name), $($version.Version)"

            $moduleFolder = $null
            $moduleFolder = Split-Path $version.Path -Parent
            if ($Force -or ($PSCmdlet.ShouldProcess("$moduleFolder", "Remove module"))) {
                if ($Force -or ($PSCmdlet.ShouldContinue("Remove module?", "$moduleFolder"))) {
                    Remove-Item -Path $moduleFolder -Force -Recurse
                }
            }
        }
    }
}