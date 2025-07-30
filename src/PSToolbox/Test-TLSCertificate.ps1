<#
.SYNOPSIS
    Tests the TLS certificate of a specified hostname and port.

.DESCRIPTION
    Connects to the given hostname(s) on the specified port (default 443), retrieves the remote TLS certificate,
    and returns its subject name and expiration date.

.PARAMETER hostname
    One or more hostnames to test for TLS certificate validity.

.PARAMETER port
    The port to connect to. Defaults to 443.

.OUTPUTS
    PSCustomObject with Hostname, SubjectName, and ValidUntil properties.

.EXAMPLE
    Test-TLSCertificate -hostname "example.com"

.NOTES
    Errors are written to the host if connection or certificate retrieval fails.
#>
function Test-TLSCertificate {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$hostname,
        [int]$port = 443
    )

    process {
        foreach ($h in $hostname) {
            try {
                $tcpClient = New-Object System.Net.Sockets.TcpClient($h, $port)
                $sslStream = New-Object System.Net.Security.SslStream($tcpClient.GetStream(), $false, ({ $true }))
                $sslStream.AuthenticateAsClient($h)

                $cert = $sslStream.RemoteCertificate
                $cert2 = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $cert

                [pscustomobject]@{
                    Hostname    = $h
                    SubjectName = $cert2.Subject
                    ValidUntil  = $cert2.NotAfter
                }
            }
            catch {
                Write-Host "Error connecting to $h on port $port" -ForegroundColor Red
                Write-Host $_.Exception.Message -ForegroundColor Red
            }
            finally {
                if ($tcpClient) { $tcpClient.Close() }
            }
        }
    }
}