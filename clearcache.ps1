# Ensure the script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to run this script as Administrator!"
    exit
}

# Function to clean temporary files
function Clear-TempFiles {
    Write-Host "Cleaning temporary files..."
    Remove-Item -Path "$env:Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "Temporary files cleaned."
}

# Function to clean Windows Update cache
function Clear-WindowsUpdateCache {
    Write-Host "Stopping Windows Update service..."
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    Stop-Service -Name bits -Force -ErrorAction SilentlyContinue

    Write-Host "Cleaning Windows Update cache..."
    Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Force -Recurse -ErrorAction SilentlyContinue

    Write-Host "Starting Windows Update service..."
    Start-Service -Name wuauserv -ErrorAction SilentlyContinue
    Start-Service -Name bits -ErrorAction SilentlyContinue

    Write-Host "Windows Update cache cleaned."
}

# Function to clean browser cache (Edge, Chrome, Firefox)
function Clear-BrowserCache {
    Write-Host "Cleaning browser cache..."

    # Edge Cache
    Remove-Item -Path "$env:LocalAppData\Microsoft\Edge\User Data\*\Cache\*" -Force -Recurse -ErrorAction SilentlyContinue

    # Chrome Cache
    Remove-Item -Path "$env:LocalAppData\Google\Chrome\User Data\*\Cache\*" -Force -Recurse -ErrorAction SilentlyContinue

    # Firefox Cache
    Remove-Item -Path "$env:LocalAppData\Mozilla\Firefox\Profiles\*\cache2\entries\*" -Force -Recurse -ErrorAction SilentlyContinue

    Write-Host "Browser cache cleaned."
}

# Function to clean the prefetch folder
function Clear-Prefetch {
    Write-Host "Cleaning prefetch files..."
    Remove-Item -Path "C:\Windows\Prefetch\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "Prefetch files cleaned."
}

# Function to clean system temporary files
function Clear-SystemTempFiles {
    Write-Host "Cleaning system temporary files..."
    Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "System temporary files cleaned."
}

# Function to clean the Recycle Bin
function Clear-RecycleBin {
    Write-Host "Cleaning Recycle Bin..."
    $shell = New-Object -ComObject Shell.Application
    $recycleBin = $shell.Namespace(10)
    $recycleBin.Items() | ForEach-Object { Remove-Item -Path $_.Path -Recurse -Force -ErrorAction SilentlyContinue }
    Write-Host "Recycle Bin cleaned."
}

# Function to clean Delivery Optimization Files
function Clear-DeliveryOptimizationCache {
    Write-Host "Cleaning Delivery Optimization files..."
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/SAGERUN:1" -NoNewWindow -Wait
    Write-Host "Delivery Optimization files cleaned."
}

# Function to clean System Logs
function Clear-SystemLogs {
    Write-Host "Cleaning system logs..."
    Remove-Item -Path "C:\Windows\System32\winevt\Logs\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "System logs cleaned."
}

# Function to clean Application Logs
function Clear-ApplicationLogs {
    Write-Host "Cleaning application logs..."
    Remove-Item -Path "$env:LocalAppData\CrashDumps\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "Application logs cleaned."
}

# User input for cleaning options
Write-Host "Choose an option for clearing cache and logs:"
Write-Host "1. Clear only basic cache (Temporary files, browser cache, Windows Update cache, etc.)"
Write-Host "2. Clear all cache, including application and system logs"

$choice = Read-Host "Enter your choice (1 or 2)"

switch ($choice) {
    "1" {
        Write-Host "You chose to clear only basic cache."
        Clear-TempFiles
        Clear-WindowsUpdateCache
        Clear-BrowserCache
        Clear-Prefetch
        Clear-SystemTempFiles
        Clear-RecycleBin
        Clear-DeliveryOptimizationCache
        Write-Host "Basic cache cleared successfully."
    }
    "2" {
        Write-Host "You chose to clear all cache, including application and system logs."
        Clear-TempFiles
        Clear-WindowsUpdateCache
        Clear-BrowserCache
        Clear-Prefetch
        Clear-SystemTempFiles
        Clear-RecycleBin
        Clear-DeliveryOptimizationCache
        Clear-SystemLogs
        Clear-ApplicationLogs
        Write-Host "All cache, application logs, and system logs cleared successfully."
    }
    default {
        Write-Host "Invalid choice. Please run the script again and choose a valid option."
    }
}
