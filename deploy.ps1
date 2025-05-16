# FMCSA Scraper Deployment Script
# This script creates a deployment package for the FMCSA Scraper

# Display banner
Write-Host "FMCSA Carrier Data Scraper - Deployment Package Creator" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan

# Create deployment directory
$deploymentDir = "FMCSA-Scraper-Deployment"
if (Test-Path $deploymentDir) {
    Remove-Item -Path $deploymentDir -Recurse -Force
}
New-Item -Path $deploymentDir -ItemType Directory | Out-Null
Write-Host "Created deployment directory: $deploymentDir" -ForegroundColor Green

# Copy required files
$filesToCopy = @(
    # Core scripts
    "Run-FMCSA-Directly.ps1",
    "RunFMCSAScraperDirect.bat",
    "Create-DirectShortcut.ps1",
    
    # Configuration
    "config.ini",
    
    # Documentation
    "README.md",
    "FMCSA_Scraper_User_Guide.md",
    "TaskSchedulerSetup.md"
)

foreach ($file in $filesToCopy) {
    Copy-Item -Path $file -Destination "$deploymentDir\" -Force
    Write-Host "Copied $file" -ForegroundColor Gray
}

# Create empty directories
$dirsToCreate = @(
    "logs",
    "output"
)

foreach ($dir in $dirsToCreate) {
    New-Item -Path "$deploymentDir\$dir" -ItemType Directory -Force | Out-Null
    Write-Host "Created directory: $dir" -ForegroundColor Gray
}

# Create README for deployment
$readmeContent = @"
# FMCSA Carrier Data Scraper - Deployment Package

This package contains the FMCSA Carrier Data Scraper direct implementation.

## Installation Instructions

1. Copy this entire folder to the destination computer
2. Run the Create-DirectShortcut.ps1 script to create a desktop shortcut:
   - Right-click on Create-DirectShortcut.ps1
   - Select "Run with PowerShell"

## Running the Scraper

You can run the scraper using any of these methods:
1. Use the desktop shortcut created during installation
2. Run the RunFMCSAScraperDirect.bat file
3. Run the Run-FMCSA-Directly.ps1 PowerShell script directly

## Configuration

Edit the config.ini file to modify settings like:
- Starting USDOT number
- Output file path
- Request delay

The scraper will automatically update the LastProcessedUSDOTNumber in config.ini after each run.

## Output Files

- CSV files will be saved to the output/ directory
- Log files will be saved to the logs/ directory

## Documentation

Refer to these files for more information:
- FMCSA_Scraper_User_Guide.md - Detailed user guide
- TaskSchedulerSetup.md - Instructions for setting up scheduled runs
"@

$readmeContent | Out-File -FilePath "$deploymentDir\DEPLOYMENT_README.md" -Encoding utf8
Write-Host "Created DEPLOYMENT_README.md" -ForegroundColor Green

# Create a simple setup.bat file
$setupBatContent = @"
@echo off
REM FMCSA Carrier Data Scraper Setup
REM This batch file sets up the FMCSA Scraper on a new computer

echo FMCSA Carrier Data Scraper - Setup
echo ================================
echo.

REM Create desktop shortcut
echo Creating desktop shortcut...
powershell -ExecutionPolicy Bypass -File "Create-DirectShortcut.ps1"

echo.
echo Setup complete! You can now run the FMCSA Scraper using:
echo   1. The desktop shortcut
echo   2. RunFMCSAScraperDirect.bat
echo   3. Run-FMCSA-Directly.ps1
echo.
echo Press any key to exit...
pause > nul
"@

$setupBatContent | Out-File -FilePath "$deploymentDir\setup.bat" -Encoding ASCII
Write-Host "Created setup.bat" -ForegroundColor Green

# Create ZIP archive
$zipFileName = "FMCSA-Scraper-Deployment.zip"
if (Test-Path $zipFileName) {
    Remove-Item -Path $zipFileName -Force
}

Write-Host "Creating deployment ZIP file: $zipFileName" -ForegroundColor Yellow
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($deploymentDir, $zipFileName)
Write-Host "Created deployment package: $zipFileName" -ForegroundColor Green

Write-Host 
Write-Host "Deployment package creation completed!" -ForegroundColor Cyan
Write-Host "You can now copy $zipFileName to the target computer and extract it." -ForegroundColor Cyan
Write-Host "Run setup.bat on the target computer to complete installation." -ForegroundColor Cyan 
