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

# Requires Windows Terminal or PowerShell with VT100 (Windows 10/Server 2016+)



# === Domain Controller Service Hardening Script ===
# Disable and stop each unnecessary service based on best practice and CIS benchmark

# Print Spooler
# Domain Controllers should not be a print server
Set-Service -Name "Spooler" -StartupType Disabled
Stop-Service -Name "Spooler" -Force

# Fax
# It's 2025. cmon
Set-Service -Name "Fax" -StartupType Disabled
Stop-Service -Name "Fax" -Force

# Windows Remote Management
# It's a remote entry point. Disable it unless you actively use WinRM
Set-Service -Name "WinRM" -StartupType Disabled
Stop-Service -Name "WinRM" -Force

# Remote Registry
# Only enable if explicitly required
Set-Service -Name "RemoteRegistry" -StartupType Disabled
Stop-Service -Name "RemoteRegistry" -Force

# Connected User Experiences and Telemetry
# Save bandwith :)
Set-Service -Name "DiagTrack" -StartupType Disabled
Stop-Service -Name "DiagTrack" -Force

# Windows Error Reporting Service
# We all google the error anyway
Set-Service -Name "WerSvc" -StartupType Disabled
Stop-Service -Name "WerSvc" -Force

# Windows Media Player Network Sharing Service
# Domain controllers should not be Media players
Set-Service -Name "WMPNetworkSvc" -StartupType Disabled
Stop-Service -Name "WMPNetworkSvc" -Force

# Shell Hardware Detection
# No autoplay on this DC!
Set-Service -Name "ShellHWDetection" -StartupType Disabled
Stop-Service -Name "ShellHWDetection" -Force

# Bluetooth Support Service
# No bluetooth here
Set-Service -Name "bthserv" -StartupType Disabled
Stop-Service -Name "bthserv" -Force

# Themes
# Disable visual styling for that extra performance.
Set-Service -Name "Themes" -StartupType Disabled
Stop-Service -Name "Themes" -Force

# SysMain (Superfetch)
# Speeds up applications by preloading used programs. No need on DCs.
Set-Service -Name "SysMain" -StartupType Disabled
Stop-Service -Name "SysMain" -Force

# SSDP Discovery
# What does a Domain controller need to discover devices over the network for? They contact us!
Set-Service -Name "SSDPSRV" -StartupType Disabled
Stop-Service -Name "SSDPSRV" -Force

# UPnP Device Host
# Yeah.. disable
Set-Service -Name "upnphost" -StartupType Disabled
Stop-Service -Name "upnphost" -Force

# Xbox Live Auth Manager
# Disable everything to do with Xbox on a enterprise environment.
Set-Service -Name "XblAuthManager" -StartupType Disabled
Stop-Service -Name "XblAuthManager" -Force

# Xbox Game Monitoring
# Disable everything to do with Xbox on a enterprise environment.
Set-Service -Name "Xbgm" -StartupType Disabled
Stop-Service -Name "Xbgm" -Force

# Xbox Live Game Save
# Disable everything to do with Xbox on a enterprise environment.
Set-Service -Name "XblGameSave" -StartupType Disabled
Stop-Service -Name "XblGameSave" -Force

# Function Discovery Provider Host
# Relevant to Plug-n-play devices
Set-Service -Name "fdPHost" -StartupType Disabled
Stop-Service -Name "fdPHost" -Force

# Function Discovery Resource Publication
# Relevant to Plug-n-play devices
Set-Service -Name "FDResPub" -StartupType Disabled
Stop-Service -Name "FDResPub" -Force







# You can check all of the services from above list here.

$servicesToCheck = @(
    "Spooler",                     # Print Spooler
    "Fax",                         # Fax
    "WinRM",                       # Windows Remote Management
    "RemoteRegistry",             # Remote Registry
    "DiagTrack",                  # Connected User Experiences and Telemetry
    "WerSvc",                     # Windows Error Reporting Service
    "WMPNetworkSvc",              # Media Player Network Sharing
    "ShellHWDetection",           # Shell Hardware Detection
    "bthserv",                    # Bluetooth Support Service
    "Themes",                     # Themes
    "SysMain",                    # SysMain / Superfetch
    "SSDPSRV",                    # SSDP Discovery
    "upnphost",                   # UPnP Device Host
    "XblAuthManager",             # Xbox Live Auth Manager
    "Xbgm",                       # Xbox Game Monitoring
    "XblGameSave",                # Xbox Live Game Save
    "fdPHost",                    # Function Discovery Provider Host
    "FDResPub"                    # Function Discovery Resource Publication
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