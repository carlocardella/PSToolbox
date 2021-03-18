if (Get-Module 'PSToolbox') { Remove-Module 'PSToolbox' -Force }
Import-Module "$PSScriptRoot/../src/PSToolbox/"
$pesterPreference = [PesterConfiguration]::Default
$pesterPreference.Should.ErrorAction = 'Continue'
$pesterPreference.CodeCoverage.Enabled = $true


Describe -Name 'Set-WindowTitle' -Tag 'SetWindowTitle' {
    BeforeAll {
        $currentTitle = $Host.UI.RawUI.WindowTitle
        $newTitle = 'NewWindowTitle'
    }

    It 'Can update the Window title' {
        { Set-WindowTitle -Title $currentTitle } | Should -Not -Throw

        Set-WindowTitle -Title $newTitle
        $Host.UI.RawUI.WindowTitle | Should -BeExactly $newTitle
    }
}
