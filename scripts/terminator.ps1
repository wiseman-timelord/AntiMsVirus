# Script: scripts\terminator.ps1

# Terminate Processes
function Stop-TargetProcesses {
    Write-Host "Finding & Closing, Processes..."
	try {
        # Get processes matching the criteria
        $AAmmProcesses = Get-Process | Where-Object { ($_.ProcessName -like "Mp*.exe" -or $_.ProcessName -like "MsMp*.exe") -and $_.Path }

        # Log the number of matching processes
        Write-Host "Found $($AAmmProcesses.Count) processes"

        # Attempt to stop each process
        foreach ($AAmmProcess in $AAmmProcesses) {
            $AAmmProcess | Stop-Process -ErrorAction Stop
            Write-Host "Stopped $($AAmmProcess.Id)"
        }
    }
    catch {
        Log-Error $_.Exception.Message
        Write-Host "Error $($AAmmProcess.Id)"
    }
}

# Sleep & Execute
function SleepAndExecute($AAmmSeconds) {
    try {
        # Wait for specified seconds
        Start-Sleep -Seconds $AAmmSeconds

        # Execute process stopping function
        Stop-TargetProcesses
    }
    catch {
        Log-Error $_.Exception.Message
    }
}