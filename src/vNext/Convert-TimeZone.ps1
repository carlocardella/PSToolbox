[CmdletBinding()]
param(
    [parameter(ValueFromPipelineByPropertyName)]
    [datetime]$DateTime,

    [parameter()]
    [string]$FromTimeZone,

    [parameter()]
    [string]$ToTimeZone
)

$timezones = [System.TimeZoneInfo]::GetSystemTimeZones()