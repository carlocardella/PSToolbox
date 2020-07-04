function Remove-DuplicateModule {
    $groups = gmo -ListAvailable | ? Path -Like "$env:USERPROFILE*" | group Name | ? Count -gt 1

    foreach ($group in $groups) {
        $versions = $null
        $versions = $group.Group | sort 'Version' | select -SkipLast 1
        $versionToKeep = $null
        $versionToKeep = $group.Group | sort 'Version' | select -Last 1

        Write-Host -ForegroundColor Green "$($versionToKeep.Name), $($versionToKeep.Version)"
    
        foreach ($version in $versions) {
            Write-Host -ForegroundColor Yellow "$($version.Name), $($version.Version)"

            $moduleFolder = $null
            $moduleFolder = Split-Path $version.Path -Parent
            del $moduleFolder -Force -Recurse
        }
    }
}