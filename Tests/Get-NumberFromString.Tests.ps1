if (Get-Module 'PSToolbox') { Remove-Module 'PSToolbox' -Force }
Import-Module "$PSScriptRoot/../src/PSToolbox/"
$pesterPreference = [PesterConfiguration]::Default
$pesterPreference.Should.ErrorAction = 'Continue'
$pesterPreference.CodeCoverage.Enabled = $true


Describe -Name 'Get-NumberFromString' -Tag 'GetNumberFromString' {
    { Get-NumberFromString -String 'sd679jsds8' } | Should -Not -Throw
    { Get-NumberFromString -String 'hssdfsfs' } | Should -Not -Throw
    { Get-NumberFromString -String '23423423423' } | Should -Not -Throw
    { Get-NumberFromString -String '!#%gr.' } | Should -Not -Throw
    { Get-NumberFromString -String '' } | Should -Throw "Cannot bind argument to parameter 'String' because it is an empty string."

    Get-NumberFromString 'test123' | Should -BeExactly 123
    Get-NumberFromString 'test' | Should -BeNullOrEmpty
    Get-NumberFromString 'tesDt1.%^23' | Should -BeExactly 123
    Get-NumberFromString '123' | Should -BeExactly 123
}
