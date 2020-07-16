function Set-EncryptedCredentialToFile {
    <#
    .SYNOPSIS
        Stores the content of a PSCredential object to a text file as encrypted string.
        The string can be decrypted and used only from the machine that originally encrypted it.
        The file is saved in xml format for easier manipulation

    .EXAMPLE
        Set-EncryptedCredentialToFile -Credential $cred -OutputFile C:\Temp\encrypted.txt

        This command encrypts a PSCredential object already stored in the Powershell session ($cred)
        and save it to C:\Temp\encrypted.txt

    .EXAMPLE
        Set-EncryptedCredentialToFile -Credential -OutputFile C:\Temp\encrypted.txt

        This command prompts the user to enter some credential and save the values to C:\Temp\encrypted.txt
    #>
    [Cmdletbinding()]
    param(
        [parameter(Mandatory, Position = 1)]
        ## PSCredential object to encrypt
        [PSCredential]$Credential,

        [parameter(Mandatory, Position = 2)]
        ## Full patn (with file name) where to store the encrypted credentials
        [string]$OutputFile
    )

    # create an object using the PSCredential username and password
    $output = New-Object Object
    Add-Member -InputObject $output -MemberType NoteProperty -Name Username -Value $Credential.UserName
    Add-Member -InputObject $output -MemberType NoteProperty -Name Password -Value (ConvertFrom-SecureString -SecureString $Credential.Password)

    # store the new object as an xml file
    $output | Export-Clixml -LiteralPath $OutputFile
    Write-Verbose -Message "Credential succesfully encrypted and stored to $OutputFile"
}
