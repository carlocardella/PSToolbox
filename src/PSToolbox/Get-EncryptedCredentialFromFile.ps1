function Get-EncryptedCredentialFromFile {
    <#
    .SYNOPSIS
        Converts the content of a file encrypted with Set-EncryptedCredentialToFile into a new PSCredential object

    .DESCRIPTION
        The string can be decrypted and used only from the machine that originally encrypted it.
        The file is saved in xml format for easier manipulation

    .PARAMETER InputFile
        File that contains the encrypted PSCredential string exported with Set-EncryptionCredentialToFile
        
    .EXAMPLE
        Get-EncryptedCredentialFromFile -InputFile C:\Temp\encrypted.txt
        This command loads the content of C:\Temp\encrypted.txt, and returns a new PSCredential object containing
        the credential originally encrypted with Set-EncryptedCredentialToFile

    .EXAMPLE
        Get-EncryptedCredentialsToFile
        This command prompts the user to enter the path to the file containing the encrypted credentials
    #>
    [Cmdletbinding()]
    param(
        [parameter(Mandatory, Position = 1)]
        ## file that contains the encrypted PSCredential string exported with Set-EncryptionCredentialToFile
        [ValidateScript( { Test-Path -Path $_ })]
        [string]$InputFile
    )

    # import the xml content
    $cred = Import-Clixml -LiteralPath $InputFile

    # get the username and password values from the file
    $username = $cred.Username
    $password = ConvertTo-SecureString $cred.Password

    # create a PSCredential object with the username and password stored in $InputFile
    $output = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $password
    Write-Verbose "Succesfully recreated the PSCredential object"

    # return the PSCredential object
    $output
}
