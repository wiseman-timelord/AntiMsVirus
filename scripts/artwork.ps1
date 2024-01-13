# Script: .\scripts\artwork.ps1

# Function Show Asciiart
function Show-AsciiArt {
    $asciiArt = @"
               _    __  ____     __    
              / \  |  \/  \ \   / /    
       _____ / _ \_| |\/| |\ \_/ /____ 
      |_____/ ___ \| |__| |_\ V /_____|
           /_/   \_\_|  |_|  \_/          
===============( AntiMsVirus )===============
"@
    Write-Host $asciiArt
}
