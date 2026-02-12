function Clear-TeamsTempFolder {
    Remove-Item -Path "$env:USERPROFILE\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache" -Recurse -Force
}