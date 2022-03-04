Remove-Module 'PSToolbox' -Force -ErrorAction 'SilentlyContinue'
Import-Module $PSScriptRoot/../src/PSToolbox -Force -ErrorAction 'Stop'
$PesterPreference = [PesterConfiguration]::Default
$PesterPreference.Should.ErrorAction = 'Continue'
$PesterPreference.CodeCoverage.Enabled = $true
$PesterPreference.Output.Verbosity = 'Detailed'


Describe 'CheckTests' {
	Context "Tests" -Tag 'CheckTests' {
		# this initialization must be at the Context level, otherwise $functionNames will be out of scope for -TestCases
		$functionsList = (Get-Command -Module 'PSToolbox' | Where-Object -FilterScript { $_.CommandType -eq 'Function' }).Name
		$functionNames = $functionsList | ForEach-Object {
			@{'functionName' = $_ }
		}

		It 'Checks if <functionName> has tests available' -TestCases $functionNames -Test {
			$testFiles = (Get-ChildItem -Path "$PSScriptRoot/../Tests" -Filter '*.Tests.ps1').Name -replace '.tests.ps1', ''

			$functionName -in $testFiles | Should -BeTrue
		}
	}
}