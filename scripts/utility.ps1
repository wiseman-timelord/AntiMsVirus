# Script: utility.ps1

# Function Disable Defenderregistry
function Disable-DefenderRegistry {
    Clear-Host
	Show-Header 
	Write-Host "Disabling Defender Registry..."
    Start-Sleep -Seconds 1
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -ErrorAction Stop
        Write-Host "..Registry Modified"
        Write-Host "Checking Values.."

# Variables
		$regValue = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware"
        if ($regValue.DisableAntiSpyware -eq 1) {
            Write-Host "..Defender Registry Disabled."
        } else {
            Write-Host "..Error Value Un-Changed!`n"
        }
		Write-Host "...Registry Edits Finished."
    }
    catch {
        $errorMessage = "Error registry: $($_.Exception.Message)"
        Log-Error $errorMessage
        Write-Host "..Error encountered: $errorMessage"
    }
}

# Function Run Disabletamperprotection
function Run-DisableTamperProtection {
    Clear-Host
	Show-Header 
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

# Function Run Disabledefenderfeatures
function Run-DisableDefenderFeatures {
    Clear-Host
	Show-Header 
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

# Function Translate Defenderaction
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

# Function Change-DefenderFolderOwnership
function Change-DefenderFolderOwnership {
    Clear-Host
    Show-Header 
    Write-Host "Changing Defender Folder Ownership..."

    $defenderPath = "C:\ProgramData\Microsoft\Windows Defender"
    
    try {
        # Change the ownership of the Windows Defender folder
        takeown /f "$defenderPath" /r /d y
        icacls "$defenderPath" /grant Administrators:F /t

        Write-Host "...Defender Folder Ownership Changed.`n"
    }
    catch {
        $errorMessage = "Error in Change-DefenderFolderOwnership: $($_.Exception.Message)"
        Log-Error $errorMessage
        Write-Host $errorMessage
    }
}

# Function Disable-DefenderScheduledTasks
function Disable-DefenderScheduledTasks {
    Clear-Host
    Show-Header 
    Write-Host "Disabling Defender Scheduled Tasks..."
    try {
        Get-ScheduledTask "Windows Defender Cache Maintenance" | Disable-ScheduledTask
        Get-ScheduledTask "Windows Defender Cleanup" | Disable-ScheduledTask
        Get-ScheduledTask "Windows Defender Scheduled Scan" | Disable-ScheduledTask
        Get-ScheduledTask "Windows Defender Verification" | Disable-ScheduledTask
        Write-Host "...Defender Scheduled Tasks Disabled.`n"
    }
    catch {
        $errorMessage = "Error in Disable-DefenderScheduledTasks: $($_.Exception.Message)"
        Log-Error $errorMessage
        Write-Host $errorMessage
    }
}


# Function Run 3scansandterminations
function Run-3ScansAndTerminations {
    Clear-Host
	Show-Header 
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

# Function Stop Targetprocesses
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

# Function Disable Defenderservicesanddrivers
function Disable-DefenderServicesAndDrivers {
    Clear-Host
	Show-Header 
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

# Function Validateandexecute
function ValidateAndExecute {
    $Global:ScanPassCounter++  
    Write-Host "Starting Pass $Global:ScanPassCounter..."
    Write-Host "Pass $Global:ScanPassCounter In 5 Seconds.."
    SleepAndExecute
}

# Function Sleepandexecute
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