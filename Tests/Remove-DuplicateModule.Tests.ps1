if (Get-Module 'PSToolbox') { Remove-Module 'PSToolbox' -Force }
Import-Module "$PSScriptRoot/../src/PSToolbox/"
$pesterPreference = [PesterConfiguration]::Default
$pesterPreference.Should.ErrorAction = 'Continue'
$pesterPreference.CodeCoverage.Enabled = $true


Describe -Name 'Remove-DuplicateModule' -Tag 'RemoveDuplicateModule' {
    BeforeAll {
        $guid = (New-Guid).Guid

        New-Item -Type 'Directory' -Path TestDrive:\Modules\TestModule\1.0.0 -Force
        New-ModuleManifest -Path TestDrive:\Modules\TestModule\1.0.0\TestModule.psd1 -Guid $guid -ModuleVersion "1.0.0"
            
        New-Item -Type 'Directory' -Path TestDrive:\Modules\TestModule\1.5.0 -Force
        New-ModuleManifest -Path TestDrive:\Modules\TestModule\1.5.0\TestModule.psd1 -Guid $guid -ModuleVersion "1.5.0"
            
        New-Item -Type 'Directory' -Path TestDrive:\Modules\TestModule\2.0.0 -Force
        New-ModuleManifest -Path TestDrive:\Modules\TestModule\2.0.0\TestModule.psd1 -Guid $guid -ModuleVersion "2.0.0"
    }

    It 'Removes old modules' {
        @(Get-ChildItem TestDrive:\Modules\TestModule -Directory).Count | Should -Be 3
        { Remove-DuplicateModule -Folder TestDrive:\Modules\TestModule -Force } | Should -Not -Throw
        @(Get-ChildItem TestDrive:\Modules\TestModule -Directory).Count | Should -Be 1
        (Get-Module -ListAvailable -Name 'TestModule').Version | Should -Be '2.0.0'
    }
}
