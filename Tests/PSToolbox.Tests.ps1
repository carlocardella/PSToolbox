if (Get-Module 'PSToolbox') { Remove-Module 'PSToolbox' -Force }
Import-Module "$PSScriptRoot/../src/PSToolbox/"
$pesterPreference = [PesterConfiguration]::Default
$pesterPreference.Should.ErrorAction = 'Continue'
$pesterPreference.CodeCoverage.Enabled = $true


Describe 'PSToolbox' {
    Context -Name 'Test-IsGuid' -Tag 'TestIsGuid' {
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

    Context -Name 'Unprotect-SecureString' -Tag 'UnprotectSecureString' {
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

    Context -Name 'Test-IsHexadecimal' -Tag 'TestIsHexadecimal' {
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

    Context -Name 'Test-Json' -Tag 'TestJson' {
        BeforeAll {
            $json = @"
                {
                    "property1": "value1",
                    "property2": "value2",
                    "array": [{
                        "anotherproperty": "anothervalue",
                        "onemoreproperty": "onemorevalue"
                    }]
                }
"@
            $jsonWithComments = @"
                {
                    // this is a comment
                    "property1": "value1",
                    "property2": "value2",
                    "array": [{
                        // another comment
                        "anotherproperty": "anothervalue",
                        "onemoreproperty": "onemorevalue"
                    }]
                }
"@
            $badJson = '[{test:'
        }

        It 'Can validate a JSON string' {
            { Test-Json -Json $json } | Should -Not -Throw -ErrorAction Continue
            { Test-Json -Json $jsonWithComments } | Should -Not -Throw -ErrorAction Continue
            { Test-Json -Json $badJson } | Should -Not -Throw -ErrorAction Continue
            { Test-Json '' } | Should -Throw "Cannot validate argument on parameter 'Json'. The argument is null or empty. Provide an argument that is not null or empty, and then try the command again."
            { Test-Json $null } | Should -Throw "Cannot validate argument on parameter 'Json'. The argument is null or empty. Provide an argument that is not null or empty, and then try the command again."

            Test-Json -Json $json | Should -BeTrue -ErrorAction Continue
            Test-Json -Json $jsonWithComments | Should -BeTrue -ErrorAction Continue
            Test-Json -Json $badJson | Should -BeFalse -ErrorAction Continue

        }
    }

    Context -Name 'Set-WindowTitle' -Tag 'SetWindowTitle' {
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

    Context -Name 'Test-IsAdmin' -Tag 'TestIsAdmin' {
        It 'Can validate if the process is running elevated' {
            { Test-IsAdmin } | Should -Not -Throw
            Test-IsAdmin | Should -BeFalse
        } 
    }

    Context -Name 'Get-RandomString' -Tag 'GetRandomString' {
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

    Context -Name 'ConvertTo-CamelCase' -Tag 'ConvertToCamelCase' {
        BeforeAll {
            $string1 = 'conTerT tHIS TO CAMel casING'
            $string2 = 'CONTERT THIS TO CAMEL CASING'
            $string3 = 'contert this to camel casing'
        }
        
        It 'Converts the string to camelCase' {
            { ConvertTo-CamelCase -String $string1 } | Should -Not -Throw
            ConvertTo-CamelCase -String $string1 | Should -BeExactly 'contert This To Camel Casing'
            ConvertTo-CamelCase -String $string2 | Should -BeExactly 'contert This To Camel Casing'
            ConvertTo-CamelCase -String $string3 | Should -BeExactly 'contert This To Camel Casing'
        }
    }
}
    Context -Name 'ConvertTo-PascalCase' -Tag 'ConvertToPascalCase' {
        BeforeAll {
            $string1 = 'conTerT tHIS TO PAScal casING'
            $string2 = 'CONTERT THIS TO PASCAL CASING'
            $string3 = 'contert this to pascal casing'
        }

        It 'Converts the string to PascalCase' {
            { ConvertTo-PascalCase -String $string1 } | Should -Not -Throw
            ConvertTo-PascalCase -String $string1 | Should -BeExactly 'Contert This To Pascal Casing'
            ConvertTo-PascalCase -String $string2 | Should -BeExactly 'Contert This To Pascal Casing'
            ConvertTo-PascalCase -String $string3 | Should -BeExactly 'Contert This To Pascal Casing'
        }
    }
    
    Context -Name 'ConvertTo-SentenceCasing' -Tag 'ConvertToSentenceCasing' {
        BeforeAll {
            $string1 = 'conTerT tHIS TO Sentence casING'
            $string2 = 'CONTERT THIS TO SENTENCE CASING'
            $string3 = 'contert this to sentence casing'
        }

        It 'Converts the string to SentenceCase' {
            { ConvertTo-SentenceCasing -String $string1 } | Should -Not -Throw
            ConvertTo-SentenceCasing -String $string1 | Should -BeExactly 'Contert This To Sentence Casing'
            ConvertTo-SentenceCasing -String $string2 | Should -BeExactly 'Contert This To Sentence Casing'
            ConvertTo-SentenceCasing -String $string3 | Should -BeExactly 'Contert This To Sentence Casing'
        }
    }

    Context -Name 'Get-NumberFromString' -Tag 'GetNumberFromString' {
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

    Context -Name 'Remove-DuplicateModule' -Tag 'RemoveDuplicateModule' {
        BeforeAll {
            New-Item -Type 'Directory' -Path TestDrive:\Modules\TestModule\1.0.0 -Force
            New-ModuleManifest -Path TestDrive:\Modules\TestModule\1.0.0\TestModule.psd1 -Guid (New-Guid).Guid -ModuleVersion [ModuleVersion]::new

            New-Item -Type 'Directory' -Path TestDrive:\Modules\TestModule\1.5.0 -Force

            New-Item -Type 'Directory' -Path TestDrive:\Modules\TestModule\2.0.0 -Force
        }
    }
}