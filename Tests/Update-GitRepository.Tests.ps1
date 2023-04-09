if (Get-Module 'PSToolbox') { Remove-Module 'PSToolbox' -Force }
Import-Module "$PSScriptRoot/../src/PSToolbox/"
$pesterPreference = [PesterConfiguration]::Default
$pesterPreference.Should.ErrorAction = 'Continue'
$pesterPreference.CodeCoverage.Enabled = $true


Describe -Name 'Update-GitRepository' -Tag 'UpdateGitRepository' {
    BeforeAll {
        Push-Location
        Set-Location $TestDrive

        # create test repo 1
        (git clone https://github.com/carlocardella/PSToolbox.git)

        # create test repo 2
        (git clone https://github.com/carlocardella/AzToolbox.git)

        Pop-Location
    }

    It 'Can fetch and pull from git remote' {
        { Update-GitRepository -Folder $TestDrive } | Should -Not -Throw
    }
}
