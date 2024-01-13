# Script: scripts\utility.ps1

# Terminate Processes
function Stop-TargetProcesses {
    try {
        $AAmmProcesses = Get-Process | Where-Object { ($_.ProcessName -like "Mp*" -or $_.ProcessName -like "MsMp*") -and $_.Path }
        Write-Host "Found $($AAmmProcesses.Count) processes"

        foreach ($AAmmProcess in $AAmmProcesses) {
            $AAmmProcess | Stop-Process -ErrorAction Stop
            Write-Host "Stopped $($AAmmProcess.Id)"
        }
    }
    catch {
        Log-Error $_.Exception.Message
        Write-Host "Error occurred during process termination."
    }
}

# Validate and call SleepAndExecute
function ValidateAndExecute {
    $Global:ScanPassCounter++  # Increment the counter
    Write-Host "Starting Pass $Global:ScanPassCounter..."
    Write-Host "Pass $Global:ScanPassCounter In 5 Seconds.."
    SleepAndExecute
}

# Sleep & Execute
function SleepAndExecute {
    try {
        Write-Host "Sleeping for 5 seconds.."
        Start-Sleep -Seconds 5
        Stop-TargetProcesses
    }
    catch {
        $errorMessage = "Error in SleepAndExecute: $($_.Exception.Message)"
        Log-Error $errorMessage
        Write-Host $errorMessage
    }
}