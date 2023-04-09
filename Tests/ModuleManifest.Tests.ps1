Remove-Module 'PSToolbox' -Force -ErrorAction 'SilentlyContinue'
Import-Module "$PSScriptRoot/../src/PSToolbox" -Force -ErrorAction 'Stop'
$PesterPreference = [PesterConfiguration]::Default
# $PesterPreference.Run.SkipRun = $true # => https://github.com/TylerLeonhardt/vscode-pester-test-adapter/issues/46
$PesterPreference.Should.ErrorAction = 'Continue'
$PesterPreference.CodeCoverage.Enabled = $true
$PesterPreference.Output.Verbosity = 'Detailed'


# https://lazywinadmin.com/2016/05/using-pester-to-test-your-manifest-file.html
Describe "ModuleManifest" {
    Context "ModuleManifest" -Tag 'ModuleManifest' {
        Beforeall {
            $manifest = Test-ModuleManifest -Path "$PSScriptRoot/../src/PSToolbox/PSToolbox.psd1"
            $functionFiles = Get-ChildItem -Path "$PSScriptRoot/../src/PSToolbox" -Filter '*.ps1' | Select-Object -ExpandProperty 'BaseName'
        }
        It "Exports the right functions" {
            $manifest.ExportedFunctions.Values | Foreach-Object {
                $_.Name -in $functionFiles | Should -BeTrue
            }

            $functionFiles | ForEach-Object {
                $_ -in $manifest.ExportedFunctions.Values.Name | Should -BeTrue
            }

            $manifest.ExportedFunctions.Count | Should -Be $functionFiles.Length
        }

        It "Find missing functions" {
            if (-not ($manifest.ExportedFunctions.Count -eq $functionList.count)) {
                $Compare = Compare-Object -ReferenceObject $manifest.ExportedFunctions.Values.Name -DifferenceObject $functionFiles
                $Compare.inputobject -join ',' | Should -BeNullOrEmpty
            }
        }

        It "Has RootModule" {
            $manifest.RootModule | Should -Not -BeNullOrEmpty
        }
        It "Has Author" {
            $manifest.Author | Should -Not -BeNullOrEmpty
        }
        It "Has Company Name" {
            $manifest.CompanyName | Should -Not -BeNullOrEmpty
        }
        It "Has Description" {
            $manifest.Description | Should -Not -BeNullOrEmpty
        }
        It "Has Copyright" {
            $manifest.Copyright | Should -Not -BeNullOrEmpty
        }
        It "Has License" {
            $manifest.LicenseURI | Should -Not -BeNullOrEmpty
        }
        It "Has a Project Link" {
            $manifest.ProjectURI | Should -Not -BeNullOrEmpty
        }
        It "Has a Tags (For the PSGallery)" {
            $manifest.Tags.count | Should -Not -BeNullOrEmpty
        }

        It 'Has Powershell Version' {
            $manifest.Version | Should -Not -BeNullOrEmpty
        }

        It 'Has a valid GUID' {
            { [guid]::Parse($manifest.Guid) } | Should -Not -Throw
        }

        It 'Is compatible with Desktop and Core editions' {
            $manifest.CompatiblePSEditions.Count | Should -Be 2
            $manifest.CompatiblePSEditions -join ',' | Should -BeIn @('Core,Desktop', 'Desktop,Core')
        }

        It 'Has the proper powershell version' {
            $manifest.PowerShellVersion | Should -BeExactly '5.1'
        }

        It 'Exports custom formats' {
            if ([string]::IsNullOrWhiteSpace($manifest.ExportedFormatFiles)) {
                Test-Path -Path $manifest.ExportedFormatFiles | Should -BeTrue
            }
        }

        It 'Exports custom type' {
            if ([string]::IsNullOrWhiteSpace($manifest.ExportedTypeFiles)) {
                Test-Path -Path $manifest.ExportedTypeFiles | Should -BeTrue
            }
        }
    }
}