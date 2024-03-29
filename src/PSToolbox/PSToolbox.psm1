Get-ChildItem "$PSScriptRoot/*.ps1" | ForEach-Object { . $_.FullName }

if (! (Get-Alias -Name 'grep' -ErrorAction 'SilentlyContinue')) {
    if ($IsWindows) {
        New-Alias -Name 'grep' -Value 'Select-String'
    }
}