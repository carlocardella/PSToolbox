if (Get-Module 'PSToolbox') { Remove-Module 'PSToolbox' -Force }
Import-Module "$PSScriptRoot/../src/PSToolbox/"
$pesterPreference = [PesterConfiguration]::Default
$pesterPreference.Should.ErrorAction = 'Continue'
$pesterPreference.CodeCoverage.Enabled = $true


Describe -Name 'Test-IsHexadecimal' -Tag 'TestIsHexadecimal' {
    BeforeAll {
        $hexadecimal = @('10FA', 'ab45', 'cc45fd')
        $notHex = @('10ZZ', 'xf5', 'test')
    }

    It 'Validates an hexadecimal string' {
        # parameter
        { Test-IsHexadecimal -String $hexadecimal } | Should -Not -Throw
        { Test-IsHexadecimal -String $notHex } | Should -Not -Throw
        Test-IsHexadecimal -String $hexadecimal | Should -BeTrue
        Test-IsHexadecimal -String $notHex | Should -BeFalse

        # pipeline
        { $hexadecimal | Test-IsHexadecimal } | Should -Not -Throw
        { $notHex | Test-IsHexadecimal } | Should -Not -Throw
        $hexadecimal | Test-IsHexadecimal | Should -BeTrue
        $notHex | Test-IsHexadecimal | Should -BeFalse
    }
}
