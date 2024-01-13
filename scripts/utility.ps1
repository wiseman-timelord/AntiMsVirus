# Script: scripts\utility.ps1

function Disable-DefenderViaRegistry {
    Write-Host "`nDisabling Defender via Registry..."
    Start-Sleep -Seconds 1

    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -ErrorAction Stop
        Write-Host "..Registry Modified"

        # Confirming the change
        Write-Host "Checking Values..
		$regValue = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware"
        if ($regValue.DisableAntiSpyware -eq 1) {
            Write-Host "..Defender Registry Disabled."
        } else {
            Write-Host "..Error Value Un-Changed!`n"
        }
		Write-Host "`n...Registry Edits Finished."
    }
    catch {
        $errorMessage = "Error registry: $($_.Exception.Message)"
        Log-Error $errorMessage
        Write-Host "..Error encountered: $errorMessage"
    }
    Start-Sleep -Seconds 2
}


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

function Disable-DefenderServicesAndDrivers {
    Write-Host "Disabling Defender Services and Drivers..."
    $services = @("WdNisSvc", "WinDefend", "Sense")
    $drivers = @("WdnisDrv", "wdfilter", "wdboot")

    try {
        foreach ($svc in $services) {
            Write-Host "..Disabling Service: $svc"
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$svc" -Name Start -Value 4 -ErrorAction Stop
        }
        foreach ($drv in $drivers) {
            Write-Host "..Disabling Driver: $drv"
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$drv" -Name Start -Value 4 -ErrorAction Stop
        }
        Write-Host "...Defender Services and Drivers Disabled.`n"
    }
    catch {
        $errorMessage = "Error in Disable-DefenderServicesAndDrivers: $($_.Exception.Message)"
        Log-Error $errorMessage
        Write-Host $errorMessage
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