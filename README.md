# AntiMsVirus-Ps

### STATUS: ALPHA
- This is probably going to involve a lot more work now/possibly a dead end, obviosly I made the main script to only run in admin. 
```
Found 2 processes
Attempting to stop process 8264 - MpCopyAccelerator
Cannot stop process 8264 - MpCopyAccelerator: Access Denied
Attempting to stop process 4872 - MsMpEng
Cannot stop process 4872 - MsMpEng: Access Denied
```
- GPT: you may need to look into more advanced techniques, which could involve system-level operations beyond the scope of a typical PowerShell script. 

### DESCRIPTION:
Microsoft Anti-Malware in Windows 10 onwards is turned off by manually going into Ms AV settings, but the user must do this EVERY TIME, and the service is not able to be disabled, hence, it will re-activate when the computer re-starts. AntiMsVirus-Ps is a tool to, shut down and close, the Microsoft Anti-Malware, in Windows 10, it is focused on locating and terminating processes that are related to Microsoft's anti-malware services or applications ("Mp*.*" and "MsMp*.*"). This tool is intended to be run at startup as a powershell command from the Task Scheduler, but will also be designed to be able to, as required then, be run by the user. 

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


Finding & Closing, Processes...
Starting Pass 1...
Pass 1 In 5 Seconds..
Sleeping for 5 seconds..
Found 0 processes
Starting Pass 2...
Pass 2 In 5 Seconds..
Sleeping for 5 seconds..
Found 0 processes
Starting Pass 3...
Pass 3 In 5 Seconds..
Sleeping for 5 seconds..
Found 0 processes
...3 Passes Complete.


....PowerShell Script Finished.

..Psc Script Exited.
...Launch Sequence Complete.


....Batch Launcher Finished.

Press any key to continue . . .

```
