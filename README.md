# FMCSA Carrier Data Scraper

A utility for extracting carrier data from the Federal Motor Carrier Safety Administration (FMCSA) database and saving it to structured CSV files.

## Overview

The FMCSA Carrier Data Scraper is designed to sequentially process USDOT numbers, extract carrier information, and save it to CSV files. It's configured through an INI file and can be run manually or scheduled to run at specific times.

## Features

- **Sequential USDOT Processing**: Scrapes carrier data starting from a specified USDOT number
- **Configurable**: Uses an INI file for easy configuration
- **CSV Export**: Saves structured data to CSV files with customizable naming
- **Progress Tracking**: Updates the INI file with the last processed USDOT number
- **Logging**: Maintains detailed logs of operations
- **Easy Deployment**: Simple deployment process for use on any Windows machine

## Requirements

- Windows 10 or newer
- PowerShell 5.1 or newer
- Basic permissions to run PowerShell scripts

## Installation

1. Download the latest release ZIP file
2. Extract to your preferred location
3. Run `setup.bat` to create a desktop shortcut
4. Edit `config.ini` if needed to customize settings

## Usage

### Running the Scraper

You can run the scraper using any of these methods:
1. Use the desktop shortcut created during installation
2. Run the `RunFMCSAScraperDirect.bat` batch file
3. Run the `Run-FMCSA-Directly.ps1` PowerShell script directly

### Configuration Options

Edit `config.ini` to modify settings:

```ini
[General]
# Starting USDOT number to process
StartingUSDOTNumber=4303281
# Last successfully processed USDOT number (updated by application)
LastProcessedUSDOTNumber=4303344
# Number of consecutive failures before stopping
MaxConsecutiveFailures=5
# Output directory for CSV files
OutputCSVPath=output/
# CSV filename template (with date formatting)
CSVFilenameTemplate=FMCSA_Data_{0:yyyy-MM-dd}.csv
```

### Output Files

- **CSV files**: Saved to the configured output directory with carrier data
- **Log files**: Detailed execution logs saved to the logs directory

## Scheduling Automated Runs

To schedule the scraper to run automatically:

1. Open Windows Task Scheduler
2. Create a new task
3. Set the action to run `RunFMCSAScraperDirect.bat`
4. Configure the trigger schedule as needed

Detailed scheduling instructions are available in `TaskSchedulerSetup.md`

## Data Structure

The CSV output contains the following carrier data fields:

- USDOTNumber
- EntityType
- OperatingStatus
- LegalName
- DBAName
- PhysicalAddress
- Phone
- MailingAddress
- USDOTStatus
- CarrierOperation
- MCSNumber
- PowerUnits
- Drivers
- MCSStatus
- BIPDStatus
- CargoCarried
- DateAdded

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Federal Motor Carrier Safety Administration for providing carrier data
- Contributors who helped test and improve this tool 