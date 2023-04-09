[CmdletBinding()]
param(
    [parameter()]
    [datetime]$DateTime = (Get-Date),

    [parameter()]
    [ArgumentCompleter({
    param ($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            [System.TimeZoneInfo]::GetSystemTimeZones() | Select-Object -ExpandProperty 'Id'
    })]
    [string]$TimeZone
)

[System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId