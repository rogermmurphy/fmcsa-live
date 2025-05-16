# Create desktop shortcut for FMCSA Scraper Direct Implementation

# Get script directory
$currentDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$shortcutPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "FMCSA Scraper.lnk")
$targetPath = [System.IO.Path]::Combine($currentDir, "RunFMCSAScraperDirect.bat")
$iconPath = [System.IO.Path]::Combine($currentDir, "RunFMCSAScraperDirect.bat")

Write-Host "Creating desktop shortcut..."
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = $targetPath
$Shortcut.IconLocation = "$env:SystemRoot\System32\SHELL32.dll,27"
$Shortcut.Description = "FMCSA Carrier Data Scraper Direct Implementation"
$Shortcut.WorkingDirectory = $currentDir
$Shortcut.Save()

Write-Host "Desktop shortcut created successfully at: $shortcutPath" 