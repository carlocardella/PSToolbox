function ConvertFrom-PsCustomObjectToHashtable {
    <#
    .SYNOPSIS
    Converts the passed object to an hashtable

    .PARAMETER PsObject
    The PsObject to convert to hashtable
    
    .EXAMPLE
    ConvertFrom-PsCustomObjectToHashtable -PsObject $mypsobject
    #>
    [CmdletBinding()]
    [OutputType([hashtable[]])]
    param(
        [parameter(mandatory = $true, position = 1, ValueFromPipeline = $true)]
        [PsObject]$PsObject
    )

    Write-Verbose -Message "[Extracting object properties]"
    $propertyNames = $PsObject | Select-Object -Property * -First 1 | Get-Member -MemberType Properties | Select-Object -ExpandProperty Name

    $outObj = @()

    Write-Verbose -Message "[Looping through all object entries]"
    foreach ($object in $PsObject) {
        $ht = @{ }

        foreach ($name in $propertyNames) {
            $ht.Add($name, $object.$name)
        }

        $outObj += $ht
    }

    $outObj
}
