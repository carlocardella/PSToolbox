Get-ChildItem "$PSScriptRoot/*.ps1" | ForEach-Object { . $_.FullName }
New-Alias -Name 'grep' -Value 'Select-String'