Function Lock-Computer {
    <#
    .SYNOPSIS
    Locks the current computer (Windows only)
    
    .EXAMPLE
    Lock-Computer
    #>
    if (! $IsWindows) { throw [System.Exception]::new("This function is supported only on Windows") }

    $signature = @"
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool LockWorkStation();
"@

    $LockWorkStation = Add-Type -memberDefinition $signature -name "Win32LockWorkStation" -namespace Win32Functions -passthru
    $LockWorkStation::LockWorkStation() | Out-Nul
}