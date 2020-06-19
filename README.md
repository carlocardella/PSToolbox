# PSToolbox

![CI](https://github.com/carlocardella/PSToolbox/workflows/CI/badge.svg)

[CloudNotes.io](https://www.cloudnotes.io)

The module contains a collection of utility functions for every day operations

## Prequisites

Install the latest `Az` module:

- using PowershellGet:
  - `Install-Module -Name 'Az' -Scope 'CurrentUser' -Force`
- alternatively, install the individual modules:
  - `Find-Module -Name "Az.*" | Where-Object 'Author' -eq 'Microsoft Corporation' | Install-Module -Scope 'CurrentUser' -Force`

## Installation

### Windows

Download the zip file or cloune the repo locally: copy the PSToolbox folder under

- `$env:PSUserProfile\Documents\WindowsPowershell\Modules` folder (for Windows Powershell)
- `$env:PSUserProfile\Documents\Powershell\Modules` folder (for Powershell 7 / Powershell Core)

### macOS

Download the zip file or cloune the repo locally: copy the PSToolbox folder under `/Users/<user>/.local/share/powershell/Modules/` folder
