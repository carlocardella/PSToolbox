if (Get-Module 'PSToolbox') { Remove-Module 'PSToolbox' -Force }
Import-Module "$PSScriptRoot/../src/PSToolbox/"
$pesterPreference = [PesterConfiguration]::Default
$pesterPreference.Should.ErrorAction = 'Continue'
$pesterPreference.CodeCoverage.Enabled = $true


Describe -Name 'Test-Json' -Tag 'TestJson' {
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
