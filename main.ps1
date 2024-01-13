# Script: main.ps1
. .\scripts\artwork.ps1
. .\scripts\utility.ps1

# Variables
$ErrorActionPreference = 'Stop'
$Global:ScanPassCounter = 0

# Initialization
Set-Location -Path $PSScriptRoot
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Admin Required, Run As Admin!`n" -ForegroundColor Red
    exit
}
Clear-Host
Write-Host "`n`nAntiMsVirus Started....`n`n"

# Function Log Error
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

# Function Show Menu
function Show-Menu {
    while ($true) {
        Clear-Host
        Show-AsciiArt
        Write-Host "`n    1. Disable Tamper Protection`n"
        Write-Host "    2. Registry Edits (requires restart)`n"
        Write-Host "    3. Disable Services (requires restart)`n"
        Write-Host "    4. Defender Folder Ownership`n"
        Write-Host "    5. Disable Defender Scheduled Tasks`n"
        Write-Host "    6. Run Process Scans & Terminate`n"
        Write-Host "    7. Disable Defender Features`n"
        Write-Host -NoNewline "Select, MenuOptions=1-7, Exit Program=X: "
        $input = Read-Host
        switch ($input.ToUpper()) {
            '1' {
                Run-DisableTamperProtection
                Start-Sleep -Seconds 5
            }
            '2' {
                Disable-DefenderRegistry
                Start-Sleep -Seconds 5
            }
            '3' {
                Disable-DefenderServicesAndDrivers
                Start-Sleep -Seconds 5
            }
            '4' {
                Change-DefenderFolderOwnership
                Start-Sleep -Seconds 5
            }
            '5' {
                Disable-DefenderScheduledTasks
                Start-Sleep -Seconds 5
            }
            '6' {
                Run-3ScansAndTerminations
                Start-Sleep -Seconds 5
            }
            '7' {
                Run-DisableDefenderFeatures
                Start-Sleep -Seconds 5
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
    return
}


# Entry Point
Show-Menu
Write-Host "`n....AntiMsVirus Finished.`n"