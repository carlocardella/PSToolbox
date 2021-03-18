if (Get-Module 'PSToolbox') { Remove-Module 'PSToolbox' -Force }
Import-Module "$PSScriptRoot/../src/PSToolbox/"
$pesterPreference = [PesterConfiguration]::Default
$pesterPreference.Should.ErrorAction = 'Continue'
$pesterPreference.CodeCoverage.Enabled = $true


Describe -Name 'Test-IsAdmin' -Tag 'TestIsAdmin' {
    It 'Does not throw and returns a boolean' {
        { Test-IsAdmin } | Should -Not -Throw
        Test-IsAdmin | Should -BeOfType [bool]
    }

    It 'Can validate if the process is running elevated' {
        Start-Process "pwsh" -ArgumentList "-Command Import-Module `"$PSScriptRoot/../../src/PSToolbox/`"; Test-IdAmin" -Verb 'RunAs' | Should -BeTrue
    } -Skip
}
