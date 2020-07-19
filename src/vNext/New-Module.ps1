function New-Module {
    [CmdletBinding()]
    param (
        [parameter(Mandatory, Position = 1)]
        [string]$ModuleName,

        [parameter(Mandatory, Position = 2)]
        [ValidateScript( { Test-Path $_ })]
        [string]$Path,

        [parameter(Mandatory)]
        [string]$Author,

        [parameter()]
        [string]$CompanyName,

        [parameter()]
        [ValidateSet('Core', 'Desktop')]
        [string[]]$CompatiblePSEditions = 'Desktop',

        [parameter()]
        [string]$Description,

        [parameter()]
        [string]$ProjectUri,

        [parameter()]
        [string]$LicenseUri
    )

    $psm1 = "$ModuleName.psm1"
    $psd1 = "$ModuleName.psd1"
    Write-Verbose "Module Fullname: $moduleFullname"
    $moduleFullname = Join-Path -Path (Resolve-Path -Path $Path) -ChildPath $ModuleName

    Write-Verbose "Creating $moduleFullname"
    New-Item -ItemType 'Directory' -Path $moduleFullname | Out-Null

    Write-Verbose "Creating $psm1"
    Out-File -FilePath (Join-Path -Path $moduleFullname -ChildPath $psm1) -Encoding 'ascii' -Force -InputObject 'Get-ChildItem -Path "$PSScriptRoot\*.ps1" | ForEach-Object { . $_.FullName }'

    Write-Verbose "Creating $psd1"
    $params = @{
        'Path'                 = (Join-Path -Path $moduleFullname -ChildPath $psd1);
        'Author'               = $Author;
        'CompatiblePSEditions' = $CompatiblePSEditions;
        'Guid'                 = (New-Guid).Guid;
        'PowerShellVersion'    = '5.1';
        'FunctionsToExport'    = '*';
        'AliasesToExport'      = '*';
        'VariablesToExport'    = '*'
    }

    if ($CompanyName) { $params.CompanyName = $CompanyName }
    if ($Description) { $params.Description = $Description }
    if ($ProjectUri) { $params.ProjectUri = $ProjectUri }
    if ($LicenseUri) { $params.LicenseUri = $LicenseUri }

    New-ModuleManifest @params
}