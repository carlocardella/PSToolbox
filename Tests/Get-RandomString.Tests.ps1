if (Get-Module 'PSToolbox') { Remove-Module 'PSToolbox' -Force }
Import-Module "$PSScriptRoot/../src/PSToolbox/"
$pesterPreference = [PesterConfiguration]::Default
$pesterPreference.Should.ErrorAction = 'Continue'
$pesterPreference.CodeCoverage.Enabled = $true


Describe -Name 'Get-RandomString' -Tag 'GetRandomString' {
    It 'Can return a random string with the given parameters' {
        { Get-RandomString } | Should -Not -Throw

        (Get-RandomString).Length | Should -Be 15
        (Get-RandomString -Length 22 ).Length | Should -Be 22

        Get-RandomString -Numbers | Should -Match '^[0-9]*$'
        Get-RandomString -LowercaseLetters | Should -Match '^[a-z]*$'
        Get-RandomString -UppercaseLetters | Should -Match '^[A-Z]*$'
        Get-RandomString -Symbols | Should -Match '^(\W)*(_)*(\W)*$'
        Get-RandomString -Space | Should -Match '^\s*$'
    }
}
