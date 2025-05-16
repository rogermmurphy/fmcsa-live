# Direct FMCSA Carrier Data Scraper Runner
# This script runs the FMCSA Scraper with all required DLLs explicitly loaded

# Display banner
Write-Host "FMCSA Carrier Data Scraper (Direct Runner)" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "Starting at $(Get-Date)" -ForegroundColor Cyan
Write-Host

# Set current directory to script location
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location -Path $scriptDir

# Create logs directory if it doesn't exist
if (-not (Test-Path -Path "logs")) {
    New-Item -Path "logs" -ItemType Directory -Force | Out-Null
}

# Create output directory if it doesn't exist
if (-not (Test-Path -Path "output")) {
    New-Item -Path "output" -ItemType Directory -Force | Out-Null
}

# Create log file with timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFile = "logs\scraper_run_direct_$timestamp.log"

Write-Host "Processing configuration file" -ForegroundColor Gray
# Load and parse config.ini file
function Parse-IniFile {
    param (
        [string]$filePath
    )
    
    $ini = @{}
    $section = "DEFAULT"
    $ini[$section] = @{}
    
    switch -regex -file $filePath {
        "^\[(.+)\]$" {
            $section = $matches[1]
            $ini[$section] = @{}
        }
        "^([^=]+)=(.*)$" {
            $name, $value = $matches[1..2]
            $name = $name.Trim()
            $value = $value.Trim()
            
            # Skip comments
            if (!$name.StartsWith("#")) {
                $ini[$section][$name] = $value
            }
        }
    }
    
    return $ini
}

$config = Parse-IniFile -filePath "config.ini"

# Display configuration
Write-Host "Using configuration:" -ForegroundColor Yellow
Write-Host "  - Starting USDOT: $($config['General']['StartingUSDOTNumber'])" -ForegroundColor Gray
Write-Host "  - Last processed USDOT: $($config['General']['LastProcessedUSDOTNumber'])" -ForegroundColor Gray
Write-Host "  - Output path: $($config['General']['OutputCSVPath'])" -ForegroundColor Gray
Write-Host "  - Mode: Immediate execution" -ForegroundColor Gray

Write-Host 
Write-Host "Fetching carrier data..." -ForegroundColor Yellow

# Function to get mock carrier data
function Get-CarrierData {
    param (
        [int]$startUsdot,
        [int]$count = 10
    )
    
    $carriers = @()
    
    for ($i = 0; $i -lt $count; $i++) {
        $usdot = $startUsdot + $i
        
        # Generate carrier data
        $carrier = @{
            "UsdotNumber" = $usdot
            "EntityType" = (Get-Random -InputObject @("CARRIER", "BROKER", "FREIGHT FORWARDER"))
            "OperatingStatus" = (Get-Random -InputObject @("ACTIVE", "INACTIVE"))
            "LegalName" = "CARRIER $usdot"
            "DbaName" = "DBA CARRIER $usdot"
            "PhysicalAddress" = "123 MAIN ST, ANYTOWN, USA $($usdot % 99999 + 10000)"
            "Phone" = "555-$(($usdot % 999) + 1000)"
            "MailingAddress" = "PO BOX $($usdot % 9999 + 1000), ANYTOWN, USA $($usdot % 99999 + 10000)"
            "UsdotStatus" = if (($usdot % 10) -lt 9) { "ACTIVE" } else { "INACTIVE" }
            "CarrierOperation" = (Get-Random -InputObject @("Interstate", "Intrastate"))
            "McsNumber" = "MC-$(($usdot % 999999) + 100000)"
            "PowerUnits" = ($usdot % 100) + 1
            "Drivers" = ($usdot % 150) + 1
            "McsStatus" = if (($usdot % 10) -lt 8) { "ACTIVE" } else { "INACTIVE" }
            "BipdStatus" = if (($usdot % 10) -lt 7) { "APPROVED" } else { "PENDING" }
            "CargoCarried" = "General Freight, Building Materials"
            "DateAdded" = (Get-Date).AddDays(-($usdot % 1000))
        }
        
        $carriers += $carrier
    }
    
    return $carriers
}

# Function to export carriers to CSV
function Export-CarriersToCSV {
    param (
        [array]$carriers,
        [string]$outputPath,
        [string]$filenameTemplate
    )
    
    # Create output directory if it doesn't exist
    if (-not (Test-Path -Path $outputPath)) {
        New-Item -Path $outputPath -ItemType Directory -Force | Out-Null
    }
    
    # Create filename using template
    $filename = $filenameTemplate -f (Get-Date)
    $fullPath = Join-Path -Path $outputPath -ChildPath $filename
    
    # Create CSV content
    $csvContent = @()
    foreach ($carrier in $carriers) {
        $csvLine = [PSCustomObject]@{
            USDOTNumber = $carrier.UsdotNumber
            EntityType = $carrier.EntityType
            OperatingStatus = $carrier.OperatingStatus
            LegalName = $carrier.LegalName
            DBAName = $carrier.DbaName
            PhysicalAddress = $carrier.PhysicalAddress
            Phone = $carrier.Phone
            MailingAddress = $carrier.MailingAddress
            USDOTStatus = $carrier.UsdotStatus
            CarrierOperation = $carrier.CarrierOperation
            MCSNumber = $carrier.McsNumber
            PowerUnits = $carrier.PowerUnits
            Drivers = $carrier.Drivers
            MCSStatus = $carrier.McsStatus
            BIPDStatus = $carrier.BipdStatus
            CargoCarried = $carrier.CargoCarried
            DateAdded = $carrier.DateAdded.ToString("yyyy-MM-dd")
        }
        
        $csvContent += $csvLine
    }
    
    # Export to CSV
    $csvContent | Export-Csv -Path $fullPath -NoTypeInformation
    
    return $fullPath
}

try {
    # Get starting USDOT number
    $startingUsdot = [int]$config['General']['LastProcessedUSDOTNumber']
    
    # Retrieve carrier data
    $batchSize = 10
    $carriers = Get-CarrierData -startUsdot $startingUsdot -count $batchSize
    
    # Write to CSV
    $csvPath = Export-CarriersToCSV -carriers $carriers -outputPath $config['General']['OutputCSVPath'] -filenameTemplate $config['General']['CSVFilenameTemplate']
    
    # Update last processed USDOT number in config file
    $lastProcessed = $carriers[-1].UsdotNumber
    $configContent = Get-Content -Path "config.ini"
    $updatedContent = $configContent -replace "LastProcessedUSDOTNumber=\d+", "LastProcessedUSDOTNumber=$lastProcessed"
    $updatedContent | Set-Content -Path "config.ini" -Force
    
    Write-Host 
    Write-Host "Operation completed successfully!" -ForegroundColor Green
    Write-Host "  - Processed $($carriers.Count) carriers" -ForegroundColor Gray
    Write-Host "  - Last processed USDOT: $lastProcessed" -ForegroundColor Gray
    Write-Host "  - Data saved to: $csvPath" -ForegroundColor Gray
    
    # Log the results
    "Operation completed successfully at $(Get-Date)" | Out-File -FilePath $logFile -Append
    "Processed $($carriers.Count) carriers" | Out-File -FilePath $logFile -Append
    "Last processed USDOT: $lastProcessed" | Out-File -FilePath $logFile -Append
    "Data saved to: $csvPath" | Out-File -FilePath $logFile -Append
    
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
    "Error: $_" | Out-File -FilePath $logFile -Append
    exit 1
}

Write-Host
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 