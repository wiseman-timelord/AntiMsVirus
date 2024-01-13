# AntiMsVirus-Ps

### STATUS: ALPHA
- This is probably going to involve a lot more work now/possibly a dead end, obviosly I made the main script to only run in admin. GPT: you may need to look into more advanced techniques, which could involve system-level operations beyond the scope of a typical PowerShell script. 
```
Found 2 processes
Attempting to stop process 8264 - MpCopyAccelerator
Cannot stop process 8264 - MpCopyAccelerator: Access Denied
Attempting to stop process 4872 - MsMpEng
Cannot stop process 4872 - MsMpEng: Access Denied
```

### DESCRIPTION:
Microsoft Anti-Malware in Windows 10 onwards is turned off by manually going into Ms AV settings, but the user must do this EVERY TIME, and the service is not able to be disabled, hence, it will re-activate when the computer re-starts. AntiMsVirus-Ps is a tool to, shut down and close, the Microsoft Anti-Malware, in Windows 10, it is focused on locating and terminating processes that are related to Microsoft's anti-malware services or applications ("Mp*.*" and "MsMp*.*"). This tool is intended to be run at startup as a powershell command from the Task Scheduler, but will also be designed to be able to, as required then, be run by the user. The project is an intellectual curiosity currently, but if it works, it would be nice.

### PHILOSOPHY
- Background tasks like virus checks can cause system lag, especially during gaming on a server. Reducing these background tasks can ensure smoother performance for resource-heavy applications.
- Preferring offline installers and personal monitoring over automatic virus scans, users who understand their system well might not need extra security software, especially as it is present on download servers.
- Non-required mandatory background processes, are similar to viruses, consume resources involuntarily, and in this case it involves i/o, the final frontier for multi-core systems.

### PREVIEW
```
               _    __  ____     __
              / \  |  \/  \ \   / /
       _____ / _ \_| |\/| |\ \_/ /____
      |_____/ ___ \| |__| |_\ V /_____|
           /_/   \_\_|  |_|  \_/
===============( AntiMsVirus )===============


AntiMsVirus Started....


Disabling Defender Features...
..Disabling Low-Threats..
..Disabling Moderate-Threats..
..Disabling High-Threats..
..Disabling Realtime-Monitoring..
...Defender Features Disabled.

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

### DISCLAIMER
This program is provided "as is" without warranties or support. Users are responsible for the content they, download and use, as well as, any resulting damage to, hardware or sanity.
