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
        It 'Does not throw and returns a boolean' {
            { Test-IsAdmin } | Should -Not -Throw
            Test-IsAdmin | Should -BeOfType [bool]
        }

        It 'Can validate if the process is running elevated' {
            Start-Process "pwsh" -ArgumentList "-Command Import-Module `"$PSScriptRoot/../../src/PSToolbox/`"; Test-IdAmin" -Verb 'RunAs' | Should -BeTrue
        } -Skip
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

    Context -Name 'Remove-OutdatedModule' -Tag 'RemoveOutdatedModule' {
        BeforeAll {
            $guid = (New-Guid).Guid

            New-Item -Type 'Directory' -Path TestDrive:\Modules\TestModule\1.0.0 -Force
            New-ModuleManifest -Path TestDrive:\Modules\TestModule\1.0.0\TestModule.psd1 -Guid $guid -ModuleVersion "1.0.0"

            New-Item -Type 'Directory' -Path TestDrive:\Modules\TestModule\1.5.0 -Force
            New-ModuleManifest -Path TestDrive:\Modules\TestModule\1.5.0\TestModule.psd1 -Guid $guid -ModuleVersion "1.5.0"

            New-Item -Type 'Directory' -Path TestDrive:\Modules\TestModule\2.0.0 -Force
            New-ModuleManifest -Path TestDrive:\Modules\TestModule\2.0.0\TestModule.psd1 -Guid $guid -ModuleVersion "2.0.0"

            $separator = $null
            if ($IsWindows) {
                $separator = ';'
            }
            if ($IsLinux -or $IsMacOS) {
                $separator = ':'
            }

            $env:PSModulePath += $separator + "$TestDrive\Modules"
        }

        It 'Updates PSModulePath' {
            if ($IsWindows) {
                $env:PSModulePath -split $separator | Should -Contain $(Resolve-Path -Path $TestDrive\Modules)
            }
        }

        It 'Removes old modules' {
            @(Get-ChildItem TestDrive:\Modules\TestModule -Directory).Count | Should -Be 3
            { Remove-OutdatedModule -Folder TestDrive:\Modules\TestModule -Force } | Should -Not -Throw
            @(Get-ChildItem TestDrive:\Modules\TestModule -Directory).Count | Should -Be 1
            (Get-Module -ListAvailable -Name 'TestModule').Version | Should -Be '2.0.0'
        }
    }

    Context -Name 'Update-GitRepository' -Tag 'UpdateGitRepository' {
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

    Context -Name 'grep' -Tag 'grep' {
        It 'Uses the "grep" alias property' {
            { 'asdfg' | grep 'a' } | Should -Not -Throw
            (Get-Command -Module 'PSToolbox' -CommandType 'Alias').ResolvedCommand | Should -BeExactly 'Select-String'
        }
    }

    Context -Name 'Update-ModuleVersion' -Tag 'UpdateModuleVersion', 'BuildModule' {
        BeforeAll {
            $psDataFile = "TestDrive:\testDataFile.psd1"
            New-ModuleManifest -Path $psDataFile -Author 'Carlo Cardella' -Guid (New-Guid) `
                -ModuleVersion '0.0.1' -CompanyName 'myCompany' -PowerShellVersion '5.1' -CompatiblePSEditions 'Core', 'Desktop'
        }

        Context 'Ensure test environment is ready' {
            It 'Is valid psDataFile' {
                (Test-ModuleManifest -Path $psDataFile).Version | Should -Be '0.0.1'
            }
        }

        Context 'Test function' {
            It 'Can increase Major version' {
                Update-ModuleVersion -ModuleDataFilePath $psDataFile -Major -Force
                (Test-ModuleManifest -Path $psDataFile).Version | Should -Be '1.0.0'
            }

            It 'Can increase Minor version' {
                Update-ModuleVersion -ModuleDataFilePath $psDataFile -Minor -Force
                (Test-ModuleManifest -Path $psDataFile).Version | Should -Be '1.1.0'
            }

            It 'Can increase Patch version' {
                Update-ModuleVersion -ModuleDataFilePath $psDataFile -Patch -Force
                (Test-ModuleManifest -Path $psDataFile).Version | Should -Be '1.1.1'
            }

            It 'Can use alias properties' {
                Update-ModuleVersion -ModuleDataFilePath $psDataFile -Major -Force
                (Test-ModuleManifest -Path $psDataFile).Version | Should -Be '2.0.0'
                Update-ModuleVersion -ModuleDataFilePath $psDataFile -Minor -Force
                (Test-ModuleManifest -Path $psDataFile).Version | Should -Be '2.1.0'
                Update-ModuleVersion -ModuleDataFilePath $psDataFile -Patch -Force
                (Test-ModuleManifest -Path $psDataFile).Version | Should -Be '2.1.1'
            }

            It 'Sets predefined module version' {
                Update-ModuleVersion -ModuleDataFilePath $psDataFile -ModuleVersion '2.0.0' -Force
                (Test-ModuleManifest -Path $psDataFile).Version | Should -Be '2.0.0'
            }

            It 'Should fail if passing an invalid ModuleVersion with 4 tokens' {
                { Update-ModuleVersion -ModuleDataFilePath $psDataFile -ModuleVersion '1.0.0.0' -Force } | Should -Throw
            }

            It 'Should fail if passing an invalid ModuleVersion with 2 tokens' {
                { Update-ModuleVersion -ModuleDataFilePath $psDataFile -ModuleVersion '1.0' -Force } | Should -Throw
            }

            It 'Updates FunctionsToExport' {
                Copy-Item -Path "$PSScriptRoot/../src/PSToolbox/" -Recurse -Destination "TestDrive:\" -Force
                Update-ModuleVersion -ModuleDataFilePath "TestDrive:\PSToolbox\PSToolbox.psd1" -Major -Force
                $ps1Files = Get-ChildItem "TestDrive:\PSToolbox" -Filter "*.ps1" | Select-Object -ExpandProperty 'Name' | Split-Path -LeafBase
                $functionsToExport = Import-PowerShellDataFile -Path "TestDrive:\PSToolbox\PSToolbox.psd1" -ErrorAction Stop
                
                $ps1Files | Should -BeExactly $functionsToExport.FunctionsToExport

                $ps1Files.Count | Should -Be $functionsToExport.FunctionsToExport.Count
            }
        }
    }

    Context -Name 'Update-Module' -Tag 'DeployModule', 'BuildModule' {
        $destModulePath = "$TestDrive\Powershell\Modules"
        New-Item -ItemType 'Directory' -Path $destModulePath -Force
        $profile.CurrentUserAllHosts = $destModulePath

        It 'Can deploy a brand new module' {
            Deploy-LSEModule -ModulePath "$PSScriptRoot/../src/PSToolbox" -Scope 'CurrentUser' -Force | Should -BeOfType [System.Management.Automation.PSModuleInfo]
        }
            
        It 'Can overwrite an existing module with the same version' {
            Deploy-LSEModule -ModulePath "$PSScriptRoot/../src/PSToolbox" -Scope 'CurrentUser' -Force | Should -BeOfType [System.Management.Automation.PSModuleInfo]
        }

        It 'Should fail parameter validation when ModulePath is not a folder' {
            { Deploy-LSEModule -ModulePath "$PSScriptRoot/../src/PSToolbox/PSToolbox.psd1" -Scope 'CurrentUser' -Force } | Should -Throw
        }
    }

    Context -Name 'New-Module' -Tag 'NewModule', 'BuildModule' {
        It 'Can create a new module' {
            { New-LSEModule -ModuleName 'TestModule' -Path $TestDrive -Author 'Me' -CompanyName 'Acme' -CompatiblePSEditions 'Core', 'Desktop' -Description 'some description' -ProjectUri 'https://project/' -LicenseUri 'https://license/' } | Should -Not -Throw
        }

        It 'Creates a valid Powershell Data File' {
            { Test-ModuleManifest -Path "$TestDrive\TestModule\TestModule.psd1" } | Should -Not -Throw
        }

        It 'Validates module Author property' {
            (Import-PowerShellDataFile -Path "$TestDrive\TestModule\TestModule.psd1").Author | Should -BeExactly 'Me'
        }

        It 'Validates module CompanyName property' {
            (Import-PowerShellDataFile -Path "$TestDrive\TestModule\TestModule.psd1").CompanyName | Should -BeExactly 'Acme'
        }

        It 'Validates module CompatiblePSEditions property' {
            (Import-PowerShellDataFile -Path "$TestDrive\TestModule\TestModule.psd1").CompatiblePSEditions | Should -Contain 'Core'
            (Import-PowerShellDataFile -Path "$TestDrive\TestModule\TestModule.psd1").CompatiblePSEditions | Should -Contain 'Desktop'
        }

        It 'Validates module Description property' {
            (Import-PowerShellDataFile -Path "$TestDrive\TestModule\TestModule.psd1").Description | Should -BeExactly 'some description'
        }

        It 'Validates module ProjectUri property' {
            (Import-PowerShellDataFile -Path "$TestDrive\TestModule\TestModule.psd1").PrivateData.PSData.ProjectUri | Should -BeExactly 'https://project/'
        }

        It 'Validates module LicenseUri property' {
            (Import-PowerShellDataFile -Path "$TestDrive\TestModule\TestModule.psd1").PrivateData.PSData.LicenseUri | Should -BeExactly 'https://license/'
        }

        It 'Exports the expected functions' {
            $functions = Get-Command -Module 'PSToolbox'
            $functions.Count | Should -BeGreaterThan 0
        }
    }
}