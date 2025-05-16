# FMCSA Carrier Data Scraper - Task Scheduler Setup Guide

This guide provides step-by-step instructions for setting up the FMCSA Carrier Data Scraper to run automatically using Windows Task Scheduler.

## Prerequisites

- FMCSA Carrier Data Scraper application installed
- Administrator access to the Windows computer where the application will run
- Configuration file (`config.ini`) properly set up

## Task Scheduler Setup Instructions

### 1. Verify the Batch File

The application should include a file named `RunFMCSAScraper.bat` in the installation directory. This batch file is used to launch the application from Task Scheduler.

### 2. Open Task Scheduler

1. Press **Windows Key + R** to open the Run dialog
2. Type `taskschd.msc` and press Enter
3. The Task Scheduler application will open

### 3. Create a New Task

1. In Task Scheduler, click on **Action** in the menu bar
2. Select **Create Task** (not "Create Basic Task")

### 4. General Tab Configuration

![Task Scheduler General Tab](images/task_scheduler_general.png)

1. Enter a **Name**: `FMCSA Carrier Data Scraper`
2. Enter a **Description**: `Retrieves carrier data from the FMCSA website based on schedule in config.ini`
3. Under **Security options**, select:
   - **Run whether user is logged on or not**
   - Check **Run with highest privileges**
4. Under **Configure for**, select your Windows version (e.g., Windows 10)

### 5. Triggers Tab Configuration

![Task Scheduler Triggers Tab](images/task_scheduler_triggers.png)

1. Click the **Triggers** tab
2. Click **New** to create a new trigger
3. Set the following options:
   - **Begin the task**: On a schedule
   - **Settings**: Daily
   - **Start**: Set to current date and time 00:01:00 AM
   - **Recur every**: 1 days
   - Check **Enabled**
4. Click **OK** to save the trigger

### 6. Actions Tab Configuration

![Task Scheduler Actions Tab](images/task_scheduler_actions.png)

1. Click the **Actions** tab
2. Click **New** to create a new action
3. Set the following options:
   - **Action**: Start a program
   - **Program/script**: Browse to and select `RunFMCSAScraper.bat` in your installation directory
   - **Add arguments (optional)**: `--config "config.ini"` (modify if your config is in a different location)
   - **Start in (optional)**: Enter the full path to your installation directory
4. Click **OK** to save the action

### 7. Conditions Tab Configuration

1. Click the **Conditions** tab
2. For power settings:
   - Uncheck **Start the task only if the computer is on AC power**
3. For network settings (if applicable):
   - Check **Start only if the following network connection is available**
   - Select **Any connection**

### 8. Settings Tab Configuration

![Task Scheduler Settings Tab](images/task_scheduler_settings.png)

1. Click the **Settings** tab
2. Configure the following options:
   - **Allow task to be run on demand**: Checked
   - **Run task as soon as possible after a scheduled start is missed**: Checked
   - **If the task fails, restart every**: 5 minutes
   - **Attempt to restart up to**: 3 times
   - **Stop the task if it runs longer than**: 4 hours
   - **If the running task does not end when requested, force it to stop**: Checked
   - **If the task is already running, then the following rule applies**: Do not start a new instance

### 9. Save and Enter Credentials

1. Click **OK** to save the task
2. Enter the username and password for the account that will run the task
   - This should be an account with administrator privileges
   - The account must have permission to access the installation directory and execute the application

## Testing the Task

After creating the scheduled task, you should test it to ensure it runs correctly:

1. In Task Scheduler, locate your task in the Task Scheduler Library
2. Right-click on the task and select **Run**
3. Check the following to verify it ran correctly:
   - Task history in Task Scheduler (right-click task → View History)
   - Log files in the `logs` directory
   - Output CSV files in the configured output directory

## Troubleshooting

### Task Shows "Last Run Result: 0x1" or Other Error Codes

- **Cause**: The batch file or application encountered an error
- **Solution**: Check the log files in the `logs` directory for details about the error

### Task Doesn't Run at Scheduled Time

- **Cause**: Computer might be powered off or Task Scheduler service not running
- **Solution**: Ensure the computer is powered on and the Task Scheduler service is set to Automatic startup

### Application Runs But No Data Is Collected

- **Cause**: Could be network connection issues or changes to the FMCSA website
- **Solution**: Check the application logs and verify internet connectivity

### "Access Denied" Errors

- **Cause**: The account running the task doesn't have sufficient permissions
- **Solution**: 
  1. Right-click on the task and select Properties
  2. Go to the General tab
  3. Click "Change User or Group" and enter an administrator account
  4. Enter the password when prompted

## Modifying the Schedule

The FMCSA Scraper is designed to use the schedule defined in the `config.ini` file, in the `[Schedule]` section. If you want to change when the application runs:

1. Open `config.ini` in a text editor
2. Navigate to the `[Schedule]` section
3. Modify the following settings:
   - `Enabled` - Set to `true` or `false`
   - `RunTimesUTC` - List of times in UTC format (e.g., `03:00,15:00`)
   - `RunDaysOfWeek` - List of days (1=Monday to 7=Sunday, e.g., `1,2,3,4,5`)
   - `RunOnStart` - Set to `true` to run immediately when launched

Remember that the Task Scheduler configuration serves primarily to launch the application, and the detailed run schedule is controlled by the application's configuration file. 