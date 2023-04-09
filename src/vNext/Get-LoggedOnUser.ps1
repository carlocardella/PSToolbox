function Get-LoggedOnUser {
    <#
    .SYNOPSIS
    Returns information about the user currently logget in and its session

    .PARAMETER ComputerName
    Computername to query

    .EXAMPLE
    Get-LoggedOnUser

    USERNAME     : carlo
    SESSIONNAME  : console
    ID           : 1
    STATE        : Active
    IDLE TIME    : none
    LOGON TIME   : 8/3/2019 4:08 PM
    ComputerName : CARLOCXPS
    #>

    param (
        [String[]]$ComputerName = $env:COMPUTERNAME
    )

    $ComputerName | ForEach-Object {
        (quser /SERVER:$_) -replace '\s{2,}', ',' |
        ConvertFrom-CSV |
        Add-Member -MemberType NoteProperty -Name ComputerName -Value $_ -PassThru
    }
}
