# Script: main.ps1

# Initialization
. .\scripts\artwork.ps1
. .\scripts\terminator.ps1

# Variables
$ErrorActionPreference = 'Stop'

# Initialization
Set-Location -Path $PSScriptRoot

# Introduction
Clear-Host
Show-AsciiArt
Write-Host "`n`nAntiMsVirus Started....`n"

# Function to log errors
function Log-Error {
    param($ErrorMessage)
    $logFilePath = ".\Error-Crash.Log"

    # Check if the file is being used by another process
    try {
        # Try to open the file for reading and writing
        $fileStream = [System.IO.File]::OpenWrite($logFilePath)
        $fileStream.Close()

        # If successful, append the error message to the file
        $ErrorMessage | Out-File -Append -FilePath $logFilePath
    }
    catch {
        # If an error occurs, it's likely because the file is in use
        Write-Host "Error-Crash.Log Protected!"
		Write-Host "Run As Admin/Close Notepad!`n"
    }
}

try {
    # Pass Number 1
    Write-Host "Pass 1 In 5 Seconds...`n"
    SleepAndExecute -seconds 5

    # Pass Number 2
    Write-Host "Pass 2 In 10 Seconds...`n"
    SleepAndExecute -seconds 10
}
catch {
    Log-Error $_.Exception.Message
}

# Exit
Write-Host "...End Of Script.`n"
