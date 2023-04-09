if (Get-Module 'PSToolbox') { Remove-Module 'PSToolbox' -Force }
Import-Module "$PSScriptRoot/../src/PSToolbox/"
$pesterPreference = [PesterConfiguration]::Default
$pesterPreference.Should.ErrorAction = 'Continue'
$pesterPreference.CodeCoverage.Enabled = $true


Describe -Name 'Unprotect-SecureString' -Tag 'UnprotectSecureString' {
    BeforeAll {
        $secureString = ConvertTo-SecureString -AsPlainText -Force 'this is a secure string'
        $plainTextString = 'this is a plain text string'
    }

    It 'Can return a SecreString as plain text' {
        { Unprotect-SecureString -SecureString $secureString } | Should -Not -Throw
        { Unprotect-SecureString -SecureString $plainTextString } | Should -Throw

        Unprotect-SecureString -SecureString $secureString | Should -BeExactly 'this is a secure string' -Because 'strings match'
        { Unprotect-SecureString -SecureString $plainTextString } | Should -Throw 'Cannot process argument transformation on parameter ''SecureString''. Cannot convert the "this is a plain text string" value of type "System.String" to type "System.Security.SecureString".'
    }
}
