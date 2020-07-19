function Update-ModuleVersion {
    <#
    .SYNOPSIS
    This function updates the ModuleVersion property in the PSD1 file passed as input prameter

    .PARAMETER ModuleDataFilePath
    File path (Fullname) to the Powershell Data File (psd1) for the module to update

    .PARAMETER Major
    Increases the Major version by 1; this also resets Minor and Patch version to 0

    .PARAMETER Minor
    Increases the Minor version by 1; this also resets Patch version to 0

    .PARAMETER Patch
    Increases the Patch version by 1

    .PARAMETER ModuleVersion
    Updates the module to the specified version, regardless of the current value

    .PARAMETER Force
    Suppress update confirmation

    .EXAMPLE
    Update-ModuleVersion -ModuleDataFilePath ./LSEBuildModule.psd1 -Patch -Verbose -Force
    #>
    [CmdletBinding(DefaultParameterSetName = 'Patch', SupportsShouldProcess)]
    param (
        [parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 1)]
        [ValidateScript( { Test-ModuleManifest -Path $_ })]
        [Alias('Fullname', 'Path')]
        [string]$ModuleDataFilePath,

        [parameter(ParameterSetName = 'Major')]
        [Alias('IncreaseMajor')]
        [switch]$Major,
        
        [parameter(ParameterSetName = 'Minor')]
        [Alias('IncreaseMinor')]
        [switch]$Minor,
        
        [parameter(ParameterSetName = 'Patch')]
        [Alias('IncreasePatch')]
        [switch]$Patch,

        [parameter(ParameterSetName = 'moduleversion', Position = 2)]
        [ValidateScript( { $_.split('.').Length -eq 3 })]
        [string]$ModuleVersion,

        [parameter()]
        [switch]$Force
    )

    class ModuleVersion {
        [int]$Major
        [int]$Minor
        [int]$Patch

        ModuleVersion([string]$Version) {
            $versionArray = $Version.Split('.')
            $this.Major = [int]$versionArray[0]
            $this.Minor = [int]$versionArray[1]
            $this.Patch = [int]$versionArray[2]
        }

        ModuleVersion([int]$Major, [int]$Minor, [int]$Patch) {
            $this.Major = $Major
            $this.Minor = $Minor
            $this.Patch = $Patch
        }

        [string]ToString() {
            return "{0}.{1}.{2}" -f $this.Major, $this.Minor, $this.Patch
        }
    }

    if ($PSCmdlet.ParameterSetName -ne 'moduleversion') {
        Write-Verbose "Reading Data File $ModuleDataFilePath"
        $dataFile = Import-PowerShellDataFile -Path $ModuleDataFilePath -ErrorAction 'Stop'

        $ModuleVersion = $dataFile.ModuleVersion
        $version = [ModuleVersion]::new($ModuleVersion)
        Write-Verbose "Current module version: $($Version.ToString())"
    }

    switch ($PSCmdlet.ParameterSetName) {
        Major {
            $version.Major += 1
            $version.Minor = 0
            $version.Patch = 0
        }

        Minor {
            $version.Minor += 1
            $version.Patch = 0
        }

        Patch {
            $version.Patch += 1
        }

        moduleversion {
            $version = [ModuleVersion]::new($ModuleVersion)
        }
    }

    Write-Verbose "New module version: $($version.ToString())"

    $functionsToExport = Get-ChildItem -Path (Split-Path -Path $ModuleDataFilePath -Parent) -File "*.ps1" | Select-Object -ExpandProperty 'Name' | Split-Path -LeafBase

    if ($Force -or ($PScmdlet.ShouldProcess("$(Split-Path -Path $ModuleDataFilePath -Leaf)", 'Update module version'))) {
        if ($Force -or ($PSCmdlet.ShouldContinue('Update module version', 'Update module version?'))) {
            Update-ModuleManifest -Path $ModuleDataFilePath -ModuleVersion $version.ToString() -FunctionsToExport $functionsToExport
        }
    }
}