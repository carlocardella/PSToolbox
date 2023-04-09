<#
    .SYNOPSIS
    Converts the passed hashtable to an object

    .PARAMETER Hashtable
    The hashtable to convert to PSCustomObject

    .EXAMPLE
    ConvertFrom-HashtableToPsCustomObject -Hashtable MyHashtable
#>
function ConvertFrom-HashtableToPsCustomObject {
    [CmdletBinding()]
    [OutputType([PsCustomObject[]])]
    param(
        [parameter(mandatory = $true, position = 1)]
        [PsObject]$Hashtable
    )

    Write-Verbose -Message "[Looping through the Hashtable list]"
    $Hashtable | ForEach-Object -Process {
        [PsCustomObject]$_
    }
}
