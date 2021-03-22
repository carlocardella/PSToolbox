function Install-Chocolatey {
    <#
    .SYNOPSIS
    Install Chocolatey on Windows, running the official installation script: https://chocolatey.org/install.ps1
    
    .EXAMPLE
    Install-Chocolatey
    #>
    [CmdletBinding()]
    param()

    if ($IsWindows) {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
}