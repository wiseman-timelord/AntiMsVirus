# Script: scripts\utility.ps1

function Run-DisableDefenderFeatures {
    Write-Host "Disabling Defender Features..."
    try {
        Write-Host "..Disabling Low-Threats.."
		Set-MpPreference -LowThreatDefaultAction Allow -ErrorAction SilentlyContinue
		Write-Host "..Disabling Moderate-Threats.."
        Set-MpPreference -ModerateThreatDefaultAction Allow -ErrorAction SilentlyContinue
		Write-Host "..Disabling High-Threats.."
        Set-MpPreference -HighThreatDefaultAction Allow -ErrorAction SilentlyContinue
		Write-Host "..Disabling Realtime-Monitoring.."
        Set-MpPreference -DisableRealtimeMonitoring $true
        Write-Host "...Defender Features Disabled.`n`n"
    }
    catch {
        $errorMessage = "Error In Disable-Defender: $($_.Exception.Message)"
        Log-Error $errorMessage
        Write-Host $errorMessage
	Start-Sleep -Seconds 1
    }
}

# Function: Run Go3MpScans
function Run-3ScansAndTerminations {
    Write-Host "Finding & Closing, Processes..."
    try {
        1..2 | ForEach-Object { ValidateAndExecute }
    }
    catch {
        Log-Error $_.Exception.Message
    }
    Write-Host "...2 Passes Complete."
	Start-Sleep -Seconds 1
}

# Terminate Processes
function Stop-TargetProcesses {
    try {
        $AAmmProcesses = Get-Process | Where-Object { $_.ProcessName -like "Mp*" -or $_.ProcessName -like "MsMp*" }
        Write-Host "Found $($AAmmProcesses.Count) processes"

        foreach ($AAmmProcess in $AAmmProcesses) {
            Write-Host "Terminating $($AAmmProcess.Id) $($AAmmProcess.ProcessName)"
            try {
                $AAmmProcess | Stop-Process -ErrorAction Stop
                Write-Host "Stopped $($AAmmProcess.Id) $($AAmmProcess.ProcessName)"
            }
            catch {
                Write-Host "Error $($AAmmProcess.Id) $($AAmmProcess.ProcessName)"
            }
        }
    }
    catch {
        Log-Error $_.Exception.Message
        Write-Host "Error occurred during process termination: $($_.Exception.Message)"
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
        Start-Sleep -Seconds 5
        Stop-TargetProcesses
    }
    catch {
        $errorMessage = "Error in SleepAndExecute: $($_.Exception.Message)"
        Log-Error $errorMessage
        Write-Host $errorMessage
    }
}