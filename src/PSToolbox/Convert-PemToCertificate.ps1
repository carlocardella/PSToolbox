function Convert-PemToCertificate {
	# https://michlstechblog.info/blog/powershell-export-convert-a-x509-certificate-in-pem-format/
	[CmdletBinding()]
	param (
		[parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
		[psobject]$PEM,

		[parameter()]
		[string]$OutputFile,
		
		[parameter()]
		[securestring]$Password
	)

	$begin = $PEM.IndexOf("-----BEGIN CERTIFICATE-----") #+ 1
	if ($begin -eq -1) {
		Write-Error "Invalid PEM format, cannot find '-----BEGIN CERTIFICATE-----'"
	}
	else {
		$begin++
	}

	$end = $PEM.IndexOf("-----END CERTIFICATE-----") #- 1
	if ($end -eq -1) {
		Write-Error "Invalid PEM format, cannot find '-----END CERTIFICATE-----'"
	}
	else {
		$end--
	}
	
	if ($end -le $start) {
		Write-Error "Invalid PEM format, '-----END CERTIFICATE-----' cannot appear before '-----BEGIN CERTIFICATE-----'"
	}

	$base64 = $PEM[$begin..$end] -join ''

	$params = @{ 'CertBase64Data' = $base64 }
	if ($OutputFile -and $Password) {
		$params.OutputFile = $OutputFile
		$params.Password = $Password
	}

	Convert-CertBase64DataToFile @params
}