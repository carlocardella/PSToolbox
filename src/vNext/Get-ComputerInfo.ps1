function Get-ComputerInfo {
    $bios = Get-WmiObject -class Win32_BIOS
    $os = Gwmi win32_operatingsystem
    $mem = get-wmiobject Win32_ComputerSystem
    $disks = get-wmiobject Win32_LogicalDisk


    $computer = New-Object psobject
    Add-Member -InputObject $computer -MemberType NoteProperty -Name Computername -Value $bios.PSComputerName
    Add-Member -InputObject $computer -MemberType NoteProperty -Name BIOSName -Value $bios.Name
    Add-Member -InputObject $computer -MemberType NoteProperty -Name CurrentLanguage -Value $bios.CurrentLanguage
    Add-Member -InputObject $computer -MemberType NoteProperty -Name Manufacturer -Value $bios.Manufacturer
    Add-Member -InputObject $computer -MemberType NoteProperty -Name SerialNumber -Value $bios.SerialNumber

    Add-Member -InputObject $computer -MemberType NoteProperty -Name OSVersion -Value $os.Caption
    Add-Member -InputObject $computer -MemberType NoteProperty -Name BuildNumber -Value $os.BuildNumber
    Add-Member -InputObject $computer -MemberType NoteProperty -Name BuildType -Value $os.BuildType
    Add-Member -InputObject $computer -MemberType NoteProperty -Name CodeSet -Value $os.CodeSet
    Add-Member -InputObject $computer -MemberType NoteProperty -Name CountryCode -Value $os.CountryCode
    Add-Member -InputObject $computer -MemberType NoteProperty -Name CurrentTimeZone -Value (tzutil /g) #$os.CurrentTimeZone
    Add-Member -InputObject $computer -MemberType NoteProperty -Name EncryptionLevel -Value $os.EncryptionLevel
    Add-Member -InputObject $computer -MemberType NoteProperty -Name Locale -Value $os.Locale
    Add-Member -InputObject $computer -MemberType NoteProperty -Name LocalDateTime -Value $os.LocalDateTime
    Add-Member -InputObject $computer -MemberType NoteProperty -Name Organization -Value $os.Organization
    Add-Member -InputObject $computer -MemberType NoteProperty -Name OSArchitecture -Value $os.OSArchitecture
    Add-Member -InputObject $computer -MemberType NoteProperty -Name OSLanguage -Value $os.OSLanguage
    Add-Member -InputObject $computer -MemberType NoteProperty -Name OSProductSuite -Value $os.OSProductSuite
    Add-Member -InputObject $computer -MemberType NoteProperty -Name OSType -Value $os.OSType
    Add-Member -InputObject $computer -MemberType NoteProperty -Name RegisteredUser -Value $os.RegisteredUser
    Add-Member -InputObject $computer -MemberType NoteProperty -Name ServicePackMajorVersion -Value $os.ServicePackMajorVersion
    Add-Member -InputObject $computer -MemberType NoteProperty -Name ServicePackMinorVersion -Value $os.ServicePackMinorVersion
    Add-Member -InputObject $computer -MemberType NoteProperty -Name SystemDirectory -Value $os.SystemDirectory
    Add-Member -InputObject $computer -MemberType NoteProperty -Name Version -Value $os.Version

    Add-Member -InputObject $computer -MemberType NoteProperty -Name Domain -Value $mem.Domain
    Add-Member -InputObject $computer -MemberType NoteProperty -Name DomainRole -Value $mem.DomainRole
    Add-Member -InputObject $computer -MemberType NoteProperty -Name HardwareManufacturer -Value $mem.Manufacturer
    Add-Member -InputObject $computer -MemberType NoteProperty -Name Model -Value $mem.Model
    Add-Member -InputObject $computer -MemberType NoteProperty -Name NumberOfLogicalProcessors -Value $mem.NumberOfLogicalProcessors
    Add-Member -InputObject $computer -MemberType NoteProperty -Name NumberOfProcessors -Value $mem.NumberOfProcessors
    Add-Member -InputObject $computer -MemberType NoteProperty -Name PartOfDomain -Value $mem.PartOfDomain
    Add-Member -InputObject $computer -MemberType NoteProperty -Name TotalPhysicalMemoryMegabytes -Value ($mem.TotalPhysicalMemory / 1mb).ToString("n")

    foreach ($disk in $disks) {
        Add-Member -InputObject $computer -MemberType NoteProperty -Name Disk$($disk.DeviceID -replace ':','') -Value $disk.DeviceId
        Add-Member -InputObject $computer -MemberType NoteProperty -Name VolumeName$($disk.DeviceID -replace ':','') -Value $disk.VolumeName
        Add-Member -InputObject $computer -MemberType NoteProperty -Name DriveType$($disk.DeviceID -replace ':','') -Value $disk.DriveType
        Add-Member -InputObject $computer -MemberType NoteProperty -Name ProviderName$($disk.DeviceID -replace ':','') -Value $disk.ProviderName
        Add-Member -InputObject $computer -MemberType NoteProperty -Name SizeMegabytes$($disk.DeviceID -replace ':','') -Value ($disk.Size / 1mb).ToString("n")
        Add-Member -InputObject $computer -MemberType NoteProperty -Name FreeSpaceMegabytes$($disk.DeviceID -replace ':','') -Value ($disk.FreeSpace / 1mb).ToString("n")
    }


    $computer
}