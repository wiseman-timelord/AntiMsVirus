# Script: main.ps1

# Initialization
. .\scripts\artwork.ps1
. .\scripts\utility.ps1

# Variables
$ErrorActionPreference = 'Stop'
$Global:ScanPassCounter = 0

# Initialization
Set-Location -Path $PSScriptRoot

# Got Admin
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Admin Required, Run As Admin!`n" -ForegroundColor Red
    exit
}

# Introduction
Clear-Host
Write-Host "`n`nAntiMsVirus Started....`n`n"

# Function to log errors
function Log-Error {
    param($ErrorMessage)
    $logFilePath = ".\Error-Crash.Log"
    try {
        $fileStream = [System.IO.File]::OpenWrite($logFilePath)
        $fileStream.Close()
        $ErrorMessage | Out-File -Append -FilePath $logFilePath
    }
    catch {
        Write-Host "Error-Crash.Log Protected!"
		Write-Host "Run As Admin/Close Notepad!"
    }
}

# Function to Show Menu and Handle User Input
function Show-Menu {
    while ($true) {
        Clear-Host
        Show-AsciiArt
        Write-Host "`n`n    1. Registry Edits (requires restart)`n"
        Write-Host "    2. Disable Tamper Protection`n"
        Write-Host "    3. Disable Defender Features`n"
        Write-Host "    4. Disable Services (requires restart)`n"
        Write-Host "    5. Run Process Scans & Terminate`n"
        Write-Host "    X. Exit Program`n`n"
        Write-Host -NoNewline "Select, MenuOptions=1-5, Exit Program=X: "
        $input = Read-Host

        switch ($input.ToUpper()) {
            '1' {
                Disable-DefenderViaRegistry
                Start-Sleep -Seconds 2
            }
            '2' {
                Run-DisableTamperProtection
                Start-Sleep -Seconds 2
            }
            '3' {
                Run-DisableDefenderFeatures
                Start-Sleep -Seconds 2
            }
            '4' {
                Disable-DefenderServicesAndDrivers
                Start-Sleep -Seconds 2
            }
            '5' {
                Run-3ScansAndTerminations
                Start-Sleep -Seconds 2
            }
            'X' {
                Write-Host "Exiting..."
                Start-Sleep -Seconds 1
                break
            }
            default {
                Write-Host "Invalid choice, please try again."
                Start-Sleep -Seconds 2
            }
        }
    }
}

# Entry Point
Show-Menu

# Exit
Write-Host "`n....AntiMsVirus Finished.`n"