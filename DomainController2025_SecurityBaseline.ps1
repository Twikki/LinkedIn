<#
    .NOTES
    ===========================================================================
     Modified on:   12-04-2025
     Created on:   	12-04-2025
	 Created by:   	Daniel Jean Schmidt
	 Organization: 	
     Filename:     	DomainController2025_SecurityBaseline.ps1
	===========================================================================
    ===========================================================================
     Requirements: 
     - Can be run on Domain Controllers
    ===========================================================================
    .DESCRIPTION
    This scripts stops and disables all services not necessary on a Domain Controller, it's based on Windows 2025.
#>

# Disables IPv6
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" `
  -Name "DisabledComponents" -PropertyType DWord -Value 0xFF -Force




# Get the GUID of the High Performance power scheme
$highPerf = powercfg -l | Where-Object { $_ -match "High performance" } | ForEach-Object { ($_ -split '\s+')[3] }

# Set it as active
if ($highPerf) {
    powercfg -setactive $highPerf
    Write-Host "High Performance power plan activated." -ForegroundColor Green
} else {
    Write-Host "High Performance plan not found!" -ForegroundColor Red
}



# Requires Windows Terminal or PowerShell with VT100 (Windows 10/Server 2016+)

$servicesToCheck = @(
    "Spooler", "Fax", "WinRM", "RemoteRegistry", "DiagTrack", "WerSvc",
    "WMPNetworkSvc", "HomeGroupListener", "HomeGroupProvider", "ShellHWDetection",
    "TabletInputService", "TouchKeyboardAndHandwritingPanelService", "bthserv",
    "RetailDemo", "Themes", "SysMain", "wuauserv", "SSDPSRV", "upnphost",
    "XblAuthManager", "Xbgm", "XblGameSave", "PNRPsvc", "fdPHost", "FDResPub"
)

Write-Host "`n--- Service Status Check ---`n"

foreach ($svc in $servicesToCheck) {
    $service = Get-Service -Name $svc -ErrorAction SilentlyContinue

    if ($service) {
        if ($service.Status -eq 'Stopped' -and $service.StartType -eq 'Disabled') {
            Write-Host "$svc is disabled and stopped" -ForegroundColor Yellow
        } else {
            Write-Host "$svc is ENABLED or RUNNING (Status: $($service.Status), StartType: $($service.StartType))" -ForegroundColor Green
        }
    } else {
        Write-Host "$svc not found" -ForegroundColor DarkGray
    }
}






# === Domain Controller Service Hardening Script ===
# Disable and stop each unnecessary service based on best practice and CIS benchmark

# Print Spooler
Set-Service -Name "Spooler" -StartupType Disabled
Stop-Service -Name "Spooler" -Force

# Fax
Set-Service -Name "Fax" -StartupType Disabled
Stop-Service -Name "Fax" -Force

# Windows Remote Management
Set-Service -Name "WinRM" -StartupType Disabled
Stop-Service -Name "WinRM" -Force

# Remote Registry
Set-Service -Name "RemoteRegistry" -StartupType Disabled
Stop-Service -Name "RemoteRegistry" -Force

# Connected User Experiences and Telemetry
Set-Service -Name "DiagTrack" -StartupType Disabled
Stop-Service -Name "DiagTrack" -Force

# Windows Error Reporting Service
Set-Service -Name "WerSvc" -StartupType Disabled
Stop-Service -Name "WerSvc" -Force

# Windows Media Player Network Sharing Service
Set-Service -Name "WMPNetworkSvc" -StartupType Disabled
Stop-Service -Name "WMPNetworkSvc" -Force

# HomeGroup Listener
Set-Service -Name "HomeGroupListener" -StartupType Disabled
Stop-Service -Name "HomeGroupListener" -Force

# HomeGroup Provider
Set-Service -Name "HomeGroupProvider" -StartupType Disabled
Stop-Service -Name "HomeGroupProvider" -Force

# Shell Hardware Detection
Set-Service -Name "ShellHWDetection" -StartupType Disabled
Stop-Service -Name "ShellHWDetection" -Force

# Tablet PC Input Service
Set-Service -Name "TabletInputService" -StartupType Disabled
Stop-Service -Name "TabletInputService" -Force

# Touch Keyboard and Handwriting Panel Service
Set-Service -Name "TouchKeyboardAndHandwritingPanelService" -StartupType Disabled
Stop-Service -Name "TouchKeyboardAndHandwritingPanelService" -Force

# Bluetooth Support Service
Set-Service -Name "bthserv" -StartupType Disabled
Stop-Service -Name "bthserv" -Force

# Retail Demo Service
Set-Service -Name "RetailDemo" -StartupType Disabled
Stop-Service -Name "RetailDemo" -Force

# Themes
Set-Service -Name "Themes" -StartupType Disabled
Stop-Service -Name "Themes" -Force

# SysMain (Superfetch)
Set-Service -Name "SysMain" -StartupType Disabled
Stop-Service -Name "SysMain" -Force

# Windows Update Service (if you're using WSUS or other patching tool)
Set-Service -Name "wuauserv" -StartupType Disabled
Stop-Service -Name "wuauserv" -Force

# SSDP Discovery
Set-Service -Name "SSDPSRV" -StartupType Disabled
Stop-Service -Name "SSDPSRV" -Force

# UPnP Device Host
Set-Service -Name "upnphost" -StartupType Disabled
Stop-Service -Name "upnphost" -Force

# Xbox Live Auth Manager
Set-Service -Name "XblAuthManager" -StartupType Disabled
Stop-Service -Name "XblAuthManager" -Force

# Xbox Game Monitoring
Set-Service -Name "Xbgm" -StartupType Disabled
Stop-Service -Name "Xbgm" -Force

# Xbox Live Game Save
Set-Service -Name "XblGameSave" -StartupType Disabled
Stop-Service -Name "XblGameSave" -Force

# Peer Name Resolution Protocol
Set-Service -Name "PNRPsvc" -StartupType Disabled
Stop-Service -Name "PNRPsvc" -Force

# Function Discovery Provider Host
Set-Service -Name "fdPHost" -StartupType Disabled
Stop-Service -Name "fdPHost" -Force

# Function Discovery Resource Publication
Set-Service -Name "FDResPub" -StartupType Disabled
Stop-Service -Name "FDResPub" -Force
