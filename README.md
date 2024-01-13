# AntiMsVirus-Ps

### STATUS: ALPHA
- This is probably going to involve a lot more work now/possibly a dead end, obviosly I made the main script to only run if its in admin. GPT: you may need to look into more advanced techniques, which could involve system-level operations beyond the scope of a typical PowerShell script. 
```
Found 2 processes
Attempting to stop process 8264 - MpCopyAccelerator
Cannot stop process 8264 - MpCopyAccelerator: Access Denied
Attempting to stop process 4872 - MsMpEng
Cannot stop process 4872 - MsMpEng: Access Denied
```
- Next steps are...
1. Disabling Windows Defender Functionality: Use the Set-MpPreference cmdlet to modify the behavior of Windows Defender, including setting threat response actions to 'Allow' and disabling real-time monitoring.
2. Turning Off Tamper Protection: Before making changes to Windows Defender settings, it's necessary to disable Tamper Protection.
3. Configuring Registry Settings: Modify registry settings related to Windows Defender to disable its functionalities. 

### DESCRIPTION:
Microsoft Anti-Malware in Windows 10 onwards is turned off by manually going into Ms AV settings, but the user must do this EVERY TIME they boot up, and even then, there are relating processes still present, and the service is not able to be disabled in services. AntiMsVirus-Ps is a tool to, shut down and close, the Microsoft Anti-Malware, in Windows 10, it is focused on locating and terminating processes that are related to Microsoft's anti-malware services or applications ("Mp*.*" and "MsMp*.*"). This tool is intended to be run at startup as a powershell command from the Task Scheduler, but will also be designed to be able to, as required then, be run by the user. The reason you would want to do such things, is because some people believe its better to have passive protection ran once a month as a, scheduled or manual, task, when other maintenance is also done; in short, having something continually run to check for virus, defeats the point of an anti-virus in its classic sense. The project is an intellectual curiosity currently, but it would be nice if it works. 

### PREVIEW
```
               _    __  ____     __
              / \  |  \/  \ \   / /
       _____ / _ \_| |\/| |\ \_/ /____
      |_____/ ___ \| |__| |_\ V /_____|
           /_/   \_\_|  |_|  \_/
===============( AntiMsVirus )===============


AntiMsVirus Started....


Disabling Tamper Protection...
Error: Operation failed with the following error: 0x%1!x!
..Skipping State Check

Disabling Defender Features...
..Disabling Low-Threats..
..Disabling Moderate-Threats..
..Disabling High-Threats..
..Disabling Realtime-Monitoring..
...Defender Features Disabled.

Check Features States...
..Low Threats: Allow
..Moderate Threats: Allow
..High Threats: Allow
..Realtime Monitoring: True
...Features States Reported.

Finding & Closing, Processes...
Starting Pass 1...
Pass 1 In 5 Seconds..
Found 2 processes
Terminating 8264 MpCopyAccelerator
Error 8264 MpCopyAccelerator
Terminating 4872 MsMpEng
Error 4872 MsMpEng
Starting Pass 2...
Pass 2 In 5 Seconds..
Found 2 processes
Terminating 8264 MpCopyAccelerator
Error 8264 MpCopyAccelerator
Terminating 4872 MsMpEng
Error 4872 MsMpEng
...2 Passes Complete.


....AntiMsVirus Finished.

..Psc Script Exited.
...Launch Sequence Complete.


....Batch Launcher Finished.

Press any key to continue . . .

```

### REQUIREMENTS
- Windows 10/11 (unsure about 11, I will check later)
- Windows Powershell or Powershell Core.

### USAGE
1. You should not use this program, unless you are NEVER EVER intending to use Microsoft Anti-Virus/Anti-Malware.  
2. If you do decide to use this program dispite my advice, then you need to run the batch `AntiMsVirus.Bat` with Admin rights.
3. Utilize your own choice of Security software upon your own computer, I advise passive protection ran monthly.

### DISCLAIMER
This program is provided "as is" without warranties or support. Users are responsible for the content they, download and use, as well as, any resulting damage to, hardware or sanity.
