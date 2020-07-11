function Update-GitRepository {
    <#
    .SYNOPSIS
    Update all git repos found in a given root folder and, optionally, its subfolders.
    
    .DESCRIPTION
    Executes two commands on each repo:
    1. git fetch -p
    2. git pull
    
    .PARAMETER Folder
    Folder containing the git repo(s) to update
    
    .PARAMETER Recursive
    Scan all subfolders
    
    .PARAMETER Origin
    Fetch and Pull from origin (default)
    
    .PARAMETER Upstream
    Fetch and Pull from upstream
    
    .EXAMPLE
    Update-GitRepository C:\Repos\ -Recursive -Origin

    Already up to date.
    Already up to date.
    Already up to date.
    Already up to date.
    Already up to date.
    
    .EXAMPLE
    Update-GitRepository C:\Repos\ -Recursive -Verbose

    VERBOSE: C:\Repos\myrepo1
    VERBOSE: origin
    Updating 5073b662..b29e6f08
    Fast-forward
    build/build.ps1                      |  2 ++
    src/RegionBuildout/ServiceModel.json | 12 ++++++------
    2 files changed, 8 insertions(+), 6 deletions(-)
    VERBOSE: C:\Repos\Github\myrepo2
    VERBOSE: origin
    Already up to date.
    VERBOSE: C:\Repos\Github\myrepo3
    VERBOSE: origin
    Already up to date.
    VERBOSE: C:\Repos\Github\myrepo4
    VERBOSE: origin
    Already up to date.
    #>
    [CmdletBinding()]
    param (
        [parameter(ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateScript( { Test-Path -Path $_ -PathType 'Container' })]
        [Alias('Fullname')]
        [string[]]$Folder,

        [parameter()]
        [switch]$Recursive,

        [parameter()]
        [switch]$Origin,

        [parameter()]
        [switch]$Upstream
    )

    begin {
        if (! { git } ) {
            throw "Git not found"
        }

        if (!$Origin -and !$Upstream) { $Origin = $true }
    }

    process {
        Push-Location

        foreach ($f in $Folder) {
            Get-ChildItem -Path $f -Directory -Recurse:$Recursive | ForEach-Object {
                Set-Location $_.FullName
                if (Test-Path -Path './.git' -PathType 'Container' -ErrorAction 'SilentlyContinue') {
                    Write-Verbose $_.FullName
                
                    if ($Origin) {
                        Write-Verbose 'origin'
                        git fetch -p origin
                        git pull origin
                    }

                    if ($Upstream) {
                        Write-Verbose 'upstream'
                        git fetch -p upstream
                        git pull upstream
                    }
                }
            }
        }

        Pop-Location
    }
}