# Script: main.ps1

# Initialization
. .\scripts\artwork.ps1
. .\scripts\utility.ps1

# Variables
$ErrorActionPreference = 'Stop'
$Global:ScanPassCounter = 0

# Initialization
Set-Location -Path $PSScriptRoot

# Got Admin?
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Admin Required, Run As Admin!`n" -ForegroundColor Red
    exit
}

# Introduction
Clear-Host
Show-AsciiArt
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

# Function: Run Go3MpScans
function Run-Go3MpScans {
    Write-Host "Finding & Closing, Processes..."
    try {
        1..3 | ForEach-Object { ValidateAndExecute }
    }
    catch {
        Log-Error $_.Exception.Message
    }
    Write-Host "...3 Passes Complete."
}

# Entry Point
Run-Go3MpScans

# Exit
Write-Host "`n`n....PowerShell Script Finished.`n"
