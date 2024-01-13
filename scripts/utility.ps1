# Script: scripts\utility.ps1

function Run-DisableTamperProtection {
    Write-Host "Disabling Tamper Protection..."
    try {
        Set-MpPreference -DisableTamperProtection $true -ErrorAction Stop
        Write-Host "..Tamper Protection Disabled"
        Start-Sleep -Seconds 2

        Write-Host "Checking Tamper Protection State..."
        $mpPrefs = Get-MpPreference
        $status = if ($mpPrefs.DisableTamperProtection) { "Disabled" } else { "Enabled" }
        Write-Host "..Tamper Protection Status: $status`n"
    }
    catch {
        $errorMessage = "Error: $($_.Exception.Message)"
        Log-Error $errorMessage
        Write-Host $errorMessage
        Write-Host "...Skipping State Check`n"
    }
    Start-Sleep -Seconds 1
}


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
        Write-Host "...Defender Features Disabled.`n"
        Start-Sleep -Seconds 2
        Write-Host "Check Features States..."
        $mpPrefs = Get-MpPreference
        Write-Host "..Low Threats: $(Translate-DefenderAction $mpPrefs.LowThreatDefaultAction)"
        Write-Host "..Moderate Threats: $(Translate-DefenderAction $mpPrefs.ModerateThreatDefaultAction)"
        Write-Host "..High Threats: $(Translate-DefenderAction $mpPrefs.HighThreatDefaultAction)"
        Write-Host "..Realtime Monitoring: $($mpPrefs.DisableRealtimeMonitoring)"
        Write-Host "...Features States Reported.`n"
        Start-Sleep -Seconds 1
    }
    catch {
        $errorMessage = "Error in Disable-Defender: $($_.Exception.Message)"
        Log-Error $errorMessage
        Write-Host $errorMessage
        Start-Sleep -Seconds 1
    }
}


function Translate-DefenderAction {
    param([int]$actionCode)
    switch ($actionCode) {
        0 { return "Clean" }
        1 { return "Quarantine" }
        2 { return "Remove" }
        6 { return "Allow" }
        8 { return "UserDefined" }
        9 { return "NoAction" }
        default { return "Unknown Action" }
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
		Start-Sleep -Seconds 1
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