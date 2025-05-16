# FMCSA Carrier Data Scraper - User Guide

## Overview

The FMCSA Carrier Data Scraper is a Windows application that automatically collects carrier data from the Federal Motor Carrier Safety Administration (FMCSA) website. It extracts structured information from HTML tables and saves it as CSV files, with options for scheduling and email notifications.

## Installation

### Prerequisites

- Windows 10 or newer
- .NET Framework 4.8
- Internet connection
- Administrative privileges (for Task Scheduler integration)

### Installation Steps

1. Extract the FMCSA Carrier Data Scraper package to your desired location
2. Run `install.bat` to install the application:
   - This will create the required directories (logs, output)
   - Build the application binaries
   - Optionally set up a scheduled task

## Configuration

The application is configured through `config.ini`. You can edit this file directly or use the Configuration UI.

### Configuration UI

To launch the Configuration UI:
1. Run `FMCSA.Scraper.ConfigUI.exe` from the release directory
2. Browse to your `config.ini` file if it's not loaded automatically
3. Modify the settings as needed
4. Click "Save" to persist your changes

### Configuration Settings

#### General Settings

- **StartingUSDOTNumber**: The USDOT number to start scraping from
- **LastProcessedUSDOTNumber**: The last USDOT number successfully processed (updated automatically)
- **MaxConsecutiveFailures**: Number of consecutive failures before stopping (default: 10)
- **LogFilePath**: Path to the log file
- **LogLevel**: Logging detail level (Debug, Info, Warning, Error, Fatal)
- **LogRetainDays**: Number of days to keep log files before deletion
- **OutputCSVPath**: Directory where CSV files will be saved
- **CSVFilenameTemplate**: Template for CSV filenames, supporting date formatting
- **RequestDelayMs**: Delay between requests in milliseconds (to avoid IP blocking)

#### Schedule Settings

- **Enabled**: Whether the scheduler is enabled
- **RunTimesUTC**: Times to run in UTC (comma-separated, HH:MM format)
- **RunDaysOfWeek**: Days of week to run (1=Monday through 7=Sunday, comma-separated)
- **RunOnStart**: Whether to run immediately when launched (regardless of schedule)

#### Email Settings

- **Enabled**: Whether email notifications are enabled
- **SMTPServer**: SMTP server address
- **SMTPPort**: SMTP server port
- **Username**: SMTP username
- **Password**: SMTP password
- **EnableSSL**: Whether to use SSL for SMTP connection
- **FromAddress**: Email sender address
- **ToAddresses**: Email recipient addresses (comma-separated)
- **SubjectTemplate**: Email subject template
- **SendOnError**: Whether to send email on errors
- **SendOnSuccess**: Whether to send email on successful completion
- **SendOnWebsiteDown**: Whether to send email when the website is unreachable

#### Web Settings

- **UseSelenium**: Whether to use Selenium WebDriver for JavaScript support
- **Browser**: Browser to use (Chrome, Firefox, Edge)
- **HeadlessBrowser**: Whether to run the browser in headless mode
- **PageLoadTimeoutSeconds**: Timeout for page loading
- **ScriptTimeoutSeconds**: Timeout for JavaScript execution

## Running the Application

### Manual Execution

To run the application manually:

1. Run `RunFMCSAScraper.bat` in the installation directory
2. The application will check if it should run based on the schedule
3. If scheduled or if RunOnStart is enabled, it will begin scraping data

To force the application to run immediately:

```
FMCSA.Scraper.Console.exe -r -c "path\to\config.ini"
```

### Command Line Options

- `-r` or `--run`: Run immediately, ignoring schedule
- `-c` or `--config`: Path to the configuration file
- `-s` or `--start`: Starting USDOT number to process
- `-n` or `--number`: Number of USDOT records to process
- `-v` or `--verbose`: Enable verbose output

### Task Scheduler Integration

The application is designed to run as a scheduled task in Windows Task Scheduler. For detailed setup instructions, refer to `TaskSchedulerSetup.md`. Here's a quick overview:

1. **Automated Setup**:
   - During installation, you can choose to create a Windows Task Scheduler entry automatically
   - The installer will configure the task with default settings

2. **Manual Setup**:
   - Open Task Scheduler (taskschd.msc)
   - Create a new task named "FMCSA Carrier Data Scraper"
   - Configure it to run with highest privileges and whether user is logged in or not
   - Add a trigger for daily execution (the application will follow the schedule in config.ini)
   - Add an action to run `RunFMCSAScraper.bat` from your installation directory
   - Configure appropriate failure handling and restart settings

3. **Understanding Scheduling**:
   - The Windows Task Scheduler task is responsible for launching the application
   - The detailed schedule (times and days) is controlled by the `config.ini` file
   - When the task launches the application, it checks the schedule in `config.ini` to determine whether to run

4. **Logging**:
   - The batch file creates detailed logs in the `logs` directory for each scheduled run
   - You can view these logs to troubleshoot any issues with scheduled execution
   - Task Scheduler also maintains a history of task executions (right-click task → View History)

## Output Files

The application will generate:

1. **CSV files** in the configured output directory, with names based on the template
2. **Log files** in the configured log directory
3. **Email notifications** if enabled in the configuration

## Troubleshooting

### Common Issues

1. **Application doesn't start**: 
   - Verify that .NET Framework 4.8 is installed
   - Check log files for errors

2. **No data is scraped**:
   - Ensure your internet connection is working
   - Check that the FMCSA website is accessible
   - Verify the `RequestDelayMs` setting is not too low

3. **No scheduled execution**:
   - Verify the schedule settings in config.ini
   - Check that the Windows Task Scheduler task is enabled
   - Ensure the RunTimesUTC is correctly formatted
   - Check the Task Scheduler History for any errors
   - Verify that the account running the task has proper permissions

4. **No emails are sent**:
   - Verify the SMTP settings
   - Check that the email addresses are correctly formatted
   - Ensure your SMTP server allows the connection

5. **Task Scheduler errors**:
   - Check Task Scheduler History for error codes
   - Ensure the user account has "Log on as batch job" rights
   - Verify the paths in the task action are correct
   - Check the logs created by the batch file

## Support

If you encounter issues not covered in this guide:
1. Check the detailed log files in the logs directory
2. Verify your configuration settings
3. Consult the integration testing documentation for potential solutions
4. Review the Task Scheduler setup guide for detailed troubleshooting steps 