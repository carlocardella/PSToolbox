param (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
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

            $cert2
            # [pscustomobject]@{
            #     Hostname    = $h
            #     SubjectName = $cert2.Subject
            #     ValidUntil  = $cert2.NotAfter
            # }
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
