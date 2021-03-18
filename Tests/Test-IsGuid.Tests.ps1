if (Get-Module 'PSToolbox') { Remove-Module 'PSToolbox' -Force }
Import-Module "$PSScriptRoot/../src/PSToolbox/"
$pesterPreference = [PesterConfiguration]::Default
$pesterPreference.Should.ErrorAction = 'Continue'
$pesterPreference.CodeCoverage.Enabled = $true


Describe 'Test-IsGuid' {
    BeforeAll {
        $guid = 1..3 | ForEach-Object { [Guid]::NewGuid() }
        $notGuid = @('teststring', '234gd', 'asddfghhjk234567.')
    }

    It 'Can validate a GUID' {
        # parameter
        { Test-Guid -Guid $guid } | Should -Not -Throw
        { Test-Guid -Guid $notGuid } | Should -Not -Throw

        Test-Guid -Guid $guid | Should -BeTrue
        Test-Guid -Guid $notGuid | Should -BeFalse

        # pipeline
        { $guid | Test-Guid } | Should -Not -Throw
        { $notGuid | Test-Guid } | Should -Not -Throw

        $guid | Test-Guid | Should -BeTrue
        $notGuid | Test-Guid | Should -BeFalse
    }

}