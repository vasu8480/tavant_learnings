# PowerShell
## Q1: Write a PowerShell script to display "Hello World" and the current date and time

🧠 **Overview**

* PowerShell is commonly used in **DevOps automation for Windows environments** (CI/CD tasks, server automation, Azure operations).
* A simple script can print messages and fetch system information like **current date and time**.
* In real workflows, similar scripts are used for **logging, pipeline steps, monitoring outputs, or scheduled tasks**.

---

⚙️ **Purpose / How it works**

* `Write-Output` → prints messages to the console or pipeline output.
* `Get-Date` → retrieves the **current system date and time**.
* PowerShell scripts are typically saved with `.ps1` extension and executed using `powershell` or `pwsh`.

Execution flow:

1. Print greeting message.
2. Fetch system date.
3. Display formatted output.

---

🧩 **PowerShell Script Example**

```powershell
# hello.ps1

# Print Hello World
Write-Output "Hello World"

# Get current date and time
$currentDateTime = Get-Date

# Display the date and time
Write-Output "Current Date and Time: $currentDateTime"
```

---

🧩 **Example Output**

```
Hello World
Current Date and Time: Wednesday, March 4, 2026 11:20:15 AM
```

---

🧩 **Run the Script**

```powershell
# Navigate to script location
cd C:\scripts

# Run the script
.\hello.ps1
```

If execution policy blocks scripts:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

🧩 **Formatted Output Example (Better for Logs)**

```powershell
Write-Output "Hello World"

$time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Output "Current Date and Time: $time"
```

Example output:

```
Hello World
Current Date and Time: 2026-03-04 11:21:30
```

---

📋 **Useful `Get-Date` Formats**

| Format                                   | Example Output        |
| ---------------------------------------- | --------------------- |
| `Get-Date`                               | Full system date/time |
| `Get-Date -Format "yyyy-MM-dd"`          | 2026-03-04            |
| `Get-Date -Format "HH:mm:ss"`            | 11:21:30              |
| `Get-Date -Format "yyyy-MM-dd HH:mm:ss"` | 2026-03-04 11:21:30   |

---

✅ **Best Practices**

* Use **formatted timestamps** for logs in automation scripts.
* Store timestamps in variables for reuse.
* Use PowerShell scripts in **CI/CD pipelines (Azure DevOps, GitHub Actions, Jenkins Windows agents)**.
* Prefer **ISO date format (`yyyy-MM-dd HH:mm:ss`)** for consistent logging.

---

💡 **In short**

* `Write-Output` prints messages in PowerShell.
* `Get-Date` retrieves the current system date and time.
* Combine them to display **Hello World with timestamp**, commonly used in **automation and pipeline logs**.

---
## Q2: Write a PowerShell script to create a new directory called "Logs" in `C:\Temp` and create 5 empty text files inside it named `log1.txt` to `log5.txt`

🧠 **Overview**

* PowerShell is widely used in **DevOps automation for Windows systems** to manage files, logs, and system resources.
* Creating directories and files programmatically is common in **log initialization, build artifact preparation, or automation scripts in CI/CD pipelines**.
* This script creates a directory and generates multiple empty log files automatically.

---

⚙️ **Purpose / How it works**

1. Define the target directory (`C:\Temp\Logs`).
2. Check if the directory exists; create it if not.
3. Use a **loop** to generate multiple files (`log1.txt` → `log5.txt`).
4. Use `New-Item` to create files.

---

🧩 **PowerShell Script**

```powershell
# Define directory path
$logDir = "C:\Temp\Logs"

# Create directory if it doesn't exist
if (!(Test-Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory
}

# Create 5 empty log files
for ($i = 1; $i -le 5; $i++) {
    $filePath = "$logDir\log$i.txt"
    New-Item -Path $filePath -ItemType File
}

Write-Output "Logs directory and files created successfully."
```

---

🧩 **Expected Directory Structure**

```
C:\Temp
 └── Logs
      ├── log1.txt
      ├── log2.txt
      ├── log3.txt
      ├── log4.txt
      └── log5.txt
```

---

🧩 **Run the Script**

```powershell
.\create-logs.ps1
```

---

🧩 **Improved Version (DevOps-Friendly Logging)**

```powershell
$logDir = "C:\Temp\Logs"

# Ensure directory exists
New-Item -Path $logDir -ItemType Directory -Force | Out-Null

# Create log files
1..5 | ForEach-Object {
    New-Item -Path "$logDir\log$_.txt" -ItemType File -Force | Out-Null
}

Write-Host "Log files created in $logDir"
```

---

📋 **Key PowerShell Commands**

| Command                     | Purpose                         |
| --------------------------- | ------------------------------- |
| `Test-Path`                 | Checks if directory/file exists |
| `New-Item`                  | Creates file or directory       |
| `for` loop                  | Iterates multiple times         |
| `ForEach-Object`            | Pipeline-based iteration        |
| `Write-Host / Write-Output` | Displays script output          |

---

✅ **Best Practices**

* Always **check if directories exist** before creating them.
* Use **`-Force`** to avoid errors when files already exist.
* Use loops or pipelines (`1..5`) to generate multiple files efficiently.
* Store paths in **variables** for maintainability.

---

💡 **In short**

* Use `New-Item` to create directories and files in PowerShell.
* A loop (`1..5`) automatically generates multiple files.
* Commonly used in **automation scripts, log initialization, and CI/CD tasks**.

----

## Q3: Write a PowerShell script to list all files in a directory and display their names, sizes, and last modified dates

🧠 **Overview**

* PowerShell is frequently used in **DevOps automation and system administration** to inspect files, logs, and artifacts.
* Listing files with metadata (name, size, modified date) is useful for **log monitoring, build artifact validation, backup scripts, and troubleshooting in CI/CD pipelines**.
* PowerShell provides built-in objects that allow easy access to file attributes.

---

⚙️ **Purpose / How it works**

1. Use `Get-ChildItem` to list files in a directory.
2. Filter only files (not directories).
3. Extract attributes like:

   * `Name`
   * `Length` (file size)
   * `LastWriteTime` (last modified date).
4. Format output using `Select-Object` or `Format-Table`.

---

🧩 **PowerShell Script**

```powershell
# Directory path
$directory = "C:\Temp"

# Get all files and display details
Get-ChildItem -Path $directory -File | 
Select-Object Name,
              @{Name="Size(KB)";Expression={[math]::Round($_.Length / 1KB,2)}},
              LastWriteTime
```

---

🧩 **Example Output**

```
Name        Size(KB)   LastWriteTime
----        --------   -------------
log1.txt       1.2     04-03-2026 11:30:10
log2.txt       0.8     04-03-2026 11:30:12
log3.txt       1.5     04-03-2026 11:30:14
```

---

🧩 **Alternative Script (Table Format for Readability)**

```powershell
$directory = "C:\Temp"

Get-ChildItem $directory -File |
Select-Object Name, Length, LastWriteTime |
Format-Table -AutoSize
```

---

🧩 **Recursive Search (Include Subdirectories)**

Useful in **log monitoring or artifact scanning pipelines**.

```powershell
$directory = "C:\Temp"

Get-ChildItem -Path $directory -File -Recurse |
Select-Object Name,
              @{Name="Size(KB)";Expression={[math]::Round($_.Length / 1KB,2)}},
              LastWriteTime
```

---

📋 **Key PowerShell Commands**

| Command         | Purpose                          |
| --------------- | -------------------------------- |
| `Get-ChildItem` | Lists files and directories      |
| `-File`         | Filters only files               |
| `Select-Object` | Selects specific file properties |
| `Length`        | File size in bytes               |
| `LastWriteTime` | Last modified timestamp          |
| `Format-Table`  | Displays output in table format  |

---

✅ **Best Practices**

* Use `-File` to avoid listing directories.
* Convert file sizes to **KB or MB for readability**.
* Use `-Recurse` when scanning logs or artifacts across subdirectories.
* Export results for automation pipelines:

```powershell
Get-ChildItem C:\Temp -File |
Select Name, Length, LastWriteTime |
Export-Csv files-report.csv -NoTypeInformation
```

---

💡 **In short**

* `Get-ChildItem` lists files in PowerShell.
* `Select-Object` extracts attributes like **name, size, and last modified date**.
* Commonly used for **log inspection, artifact validation, and automation scripts in DevOps pipelines**.

---
## Q4: Write a PowerShell script to copy all `.txt` files from `C:\Source` to `C:\Destination`

🧠 **Overview**

* In DevOps and system automation, scripts often move or copy files such as **logs, artifacts, configuration files, or reports**.
* PowerShell provides the `Copy-Item` cmdlet to copy files and directories.
* Filtering by file extension (`*.txt`) ensures that **only required files are transferred**, which is common in **log archival or artifact promotion workflows**.

---

⚙️ **Purpose / How it works**

1. Define **source** and **destination** directories.
2. Use `Get-ChildItem` with `*.txt` to find all text files.
3. Use `Copy-Item` to copy them to the destination.
4. Optionally create the destination folder if it does not exist.

---

🧩 **PowerShell Script**

```powershell
# Define paths
$source = "C:\Source"
$destination = "C:\Destination"

# Ensure destination directory exists
if (!(Test-Path $destination)) {
    New-Item -Path $destination -ItemType Directory
}

# Copy all .txt files
Get-ChildItem -Path $source -Filter "*.txt" -File |
Copy-Item -Destination $destination

Write-Output "All .txt files copied successfully."
```

---

🧩 **Simpler One-Line Command**

```powershell
Copy-Item "C:\Source\*.txt" -Destination "C:\Destination"
```

---

🧩 **Copy Including Subdirectories (Recursive)**

Useful in **log collection or CI/CD artifact copy operations**.

```powershell
Get-ChildItem "C:\Source" -Filter "*.txt" -Recurse -File |
Copy-Item -Destination "C:\Destination"
```

---

📋 **Key PowerShell Commands**

| Command           | Purpose                     |
| ----------------- | --------------------------- |
| `Get-ChildItem`   | Lists files in a directory  |
| `-Filter "*.txt"` | Selects only `.txt` files   |
| `Copy-Item`       | Copies files or directories |
| `Test-Path`       | Checks if path exists       |
| `New-Item`        | Creates directory           |

---

✅ **Best Practices**

* Always verify destination directory using `Test-Path`.
* Use `-Recurse` when copying files from nested directories.
* Use `-Force` to overwrite existing files when required:

```powershell
Copy-Item "C:\Source\*.txt" -Destination "C:\Destination" -Force
```

* Add logging when used in automation pipelines.

---

💡 **In short**

* `Copy-Item` copies files in PowerShell.
* `*.txt` filter ensures only text files are copied.
* Commonly used in **log transfer, artifact promotion, and automation workflows**.

---
## Q5: Write a PowerShell script to delete all files older than 30 days from a specified directory

🧠 **Overview**

* In DevOps environments, servers and build agents generate **large volumes of logs, temporary files, and artifacts**.
* Cleaning old files automatically prevents **disk space exhaustion**, which can break CI/CD pipelines or applications.
* PowerShell can filter files by **LastWriteTime** and remove those older than a defined number of days.

---

⚙️ **Purpose / How it works**

1. Define the **target directory**.
2. Calculate the **cutoff date** (current date – 30 days).
3. List files using `Get-ChildItem`.
4. Filter files older than the cutoff date.
5. Delete them using `Remove-Item`.

---

🧩 **PowerShell Script**

```powershell
# Directory to clean
$directory = "C:\Logs"

# Calculate date 30 days ago
$cutoffDate = (Get-Date).AddDays(-30)

# Find and delete files older than 30 days
Get-ChildItem -Path $directory -File |
Where-Object { $_.LastWriteTime -lt $cutoffDate } |
Remove-Item -Force

Write-Output "Old files older than 30 days deleted successfully."
```

---

🧩 **Recursive Version (Include Subdirectories)**

Useful for **log directories with nested folders**.

```powershell
$directory = "C:\Logs"
$cutoffDate = (Get-Date).AddDays(-30)

Get-ChildItem -Path $directory -File -Recurse |
Where-Object { $_.LastWriteTime -lt $cutoffDate } |
Remove-Item -Force
```

---

🧩 **Safe Mode (Preview Before Deleting)**

Recommended in production scripts.

```powershell
$directory = "C:\Logs"
$cutoffDate = (Get-Date).AddDays(-30)

Get-ChildItem -Path $directory -File |
Where-Object { $_.LastWriteTime -lt $cutoffDate }
```

---

📋 **Key PowerShell Commands**

| Command         | Purpose                          |
| --------------- | -------------------------------- |
| `Get-ChildItem` | Lists files in directory         |
| `Get-Date`      | Gets current system date         |
| `.AddDays(-30)` | Calculates date 30 days ago      |
| `Where-Object`  | Filters files based on condition |
| `Remove-Item`   | Deletes files                    |
| `-Recurse`      | Includes subdirectories          |

---

🧩 **DevOps Example (Log Cleanup Cron Task)**

Scheduled cleanup on Windows servers:

```powershell
$path = "C:\AppLogs"
$limit = (Get-Date).AddDays(-30)

Get-ChildItem $path -Recurse -File |
Where-Object { $_.LastWriteTime -lt $limit } |
Remove-Item -Force
```

Used in:

* **Jenkins Windows agents**
* **Application log rotation**
* **Disk cleanup automation**

---

✅ **Best Practices**

* Always **test the script without `Remove-Item` first**.
* Use `-Recurse` for deep log folders.
* Schedule via **Windows Task Scheduler** for periodic cleanup.
* Keep logs for **compliance (30–90 days depending on policy)**.

---

💡 **In short**

* Use `Get-Date().AddDays(-30)` to calculate old files.
* Filter using `Where-Object` with `LastWriteTime`.
* Delete using `Remove-Item` to automate **log cleanup and disk management**.

---
## Q6: Write a PowerShell script that takes a user's name as input and outputs `"Hello, [Name]!"`

🧠 **Overview**

* PowerShell scripts can **accept user input interactively** using `Read-Host`.
* This pattern is common in **automation scripts, deployment prompts, and administrative tools** where parameters or confirmations are required.
* The script reads the user's name and dynamically prints a greeting message.

---

⚙️ **Purpose / How it works**

1. Prompt the user for input using `Read-Host`.
2. Store the input in a variable.
3. Display the greeting message using `Write-Output`.

---

🧩 **PowerShell Script**

```powershell
# Prompt user for their name
$name = Read-Host "Enter your name"

# Display greeting
Write-Output "Hello, $name!"
```

---

🧩 **Example Execution**

```powershell
PS C:\Scripts> .\greet.ps1
Enter your name: Vasu
Hello, Vasu!
```

---

🧩 **Alternative Version (Formatted Output)**

```powershell
$name = Read-Host "Please enter your name"

Write-Host "Hello, $name!" -ForegroundColor Green
```

Example output:

```
Hello, Vasu!
```

---

🧩 **Parameter-Based Script (DevOps-Friendly)**
Better for **automation or CI/CD pipelines**.

```powershell
param(
    [string]$Name
)

Write-Output "Hello, $Name!"
```

Run the script:

```powershell
.\greet.ps1 -Name "Vasu"
```

---

📋 **Key PowerShell Commands**

| Command        | Purpose                         |
| -------------- | ------------------------------- |
| `Read-Host`    | Reads input from user           |
| `Write-Output` | Prints output to console        |
| `Write-Host`   | Displays colored console output |
| `param()`      | Accepts script parameters       |

---

✅ **Best Practices**

* Use **`param()`** instead of interactive prompts for **automation and pipelines**.
* Validate user input if required.
* Avoid `Write-Host` in scripts used in pipelines; prefer `Write-Output`.

---

💡 **In short**

* `Read-Host` captures user input.
* Store input in a variable and print it using `Write-Output`.
* Use `param()` for **automation-friendly scripts in CI/CD workflows**.

---
## Q7: Write a PowerShell script to check if a specific file exists, and if not, create it with some default content

🧠 **Overview**

* In DevOps automation, scripts often verify whether **configuration files, logs, or environment files exist** before an application starts.
* If the file is missing, the script can automatically **create it with default content** to ensure the system works correctly.
* PowerShell uses `Test-Path` to check existence and `New-Item` or `Set-Content` to create files.

---

⚙️ **Purpose / How it works**

1. Define the **file path**.
2. Use `Test-Path` to check if the file exists.
3. If it does not exist:

   * Create the file.
   * Write default content to it.
4. Print a message indicating the result.

---

🧩 **PowerShell Script**

```powershell
# Define file path
$filePath = "C:\Temp\config.txt"

# Check if file exists
if (!(Test-Path $filePath)) {

    # Create file with default content
    "default_configuration=true" | Set-Content $filePath

    Write-Output "File created with default content."
}
else {
    Write-Output "File already exists."
}
```

---

🧩 **Example Output**

```
File created with default content.
```

or

```
File already exists.
```

---

🧩 **Example Default File Content**

```text
default_configuration=true
environment=dev
log_level=info
```

---

🧩 **Improved DevOps Version**

```powershell
$filePath = "C:\Temp\app-config.txt"

if (!(Test-Path $filePath)) {

    $defaultContent = @"
environment=dev
log_level=info
service_enabled=true
"@

    $defaultContent | Out-File $filePath

    Write-Output "Configuration file created."
}
else {
    Write-Output "Configuration file already exists."
}
```

---

📋 **Key PowerShell Commands**

| Command        | Purpose                                |
| -------------- | -------------------------------------- |
| `Test-Path`    | Checks if file or directory exists     |
| `Set-Content`  | Writes content to a file               |
| `Out-File`     | Outputs text to a file                 |
| `New-Item`     | Creates files or directories           |
| `if` condition | Executes logic based on file existence |

---

✅ **Best Practices**

* Always **check file existence before creation** to avoid overwriting data.
* Store default configuration in **variables or templates** for maintainability.
* Use scripts like this in:

  * **application startup scripts**
  * **CI/CD pipeline initialization**
  * **configuration management automation**.

---

💡 **In short**

* `Test-Path` checks if the file exists.
* If not found, create it using `Set-Content` or `Out-File`.
* Commonly used for **auto-generating configuration or log files in automation workflows**.

----
## Q8: Write a PowerShell script to rename all `.log` files in a directory by appending the current date to their filenames

🧠 **Overview**

* In DevOps and system operations, log files are often **archived or rotated** by renaming them with timestamps.
* Appending the current date to filenames helps with **log tracking, retention policies, and troubleshooting historical events**.
* PowerShell can automate this using `Get-ChildItem` to locate files and `Rename-Item` to rename them.

---

⚙️ **Purpose / How it works**

1. Define the **target directory**.
2. Generate the **current date string** using `Get-Date`.
3. Use `Get-ChildItem` to find `.log` files.
4. Rename each file by appending the date to its filename.

Example rename:

```
app.log → app_2026-03-04.log
```

---

🧩 **PowerShell Script**

```powershell
# Directory containing log files
$directory = "C:\Logs"

# Current date format
$date = Get-Date -Format "yyyy-MM-dd"

# Rename all .log files
Get-ChildItem -Path $directory -Filter "*.log" -File | ForEach-Object {

    $newName = "$($_.BaseName)_$date$($_.Extension)"

    Rename-Item -Path $_.FullName -NewName $newName
}

Write-Output "Log files renamed successfully."
```

---

🧩 **Example Before and After**

| Before     | After                 |
| ---------- | --------------------- |
| app.log    | app_2026-03-04.log    |
| system.log | system_2026-03-04.log |
| error.log  | error_2026-03-04.log  |

---

🧩 **Recursive Version (Include Subdirectories)**

Useful for **large log directories in production systems**.

```powershell
$directory = "C:\Logs"
$date = Get-Date -Format "yyyy-MM-dd"

Get-ChildItem -Path $directory -Filter "*.log" -File -Recurse | ForEach-Object {
    Rename-Item $_.FullName "$($_.BaseName)_$date$($_.Extension)"
}
```

---

📋 **Key PowerShell Commands**

| Command           | Purpose                       |
| ----------------- | ----------------------------- |
| `Get-ChildItem`   | Lists files in directory      |
| `-Filter "*.log"` | Selects only `.log` files     |
| `Get-Date`        | Retrieves current system date |
| `Rename-Item`     | Renames files                 |
| `BaseName`        | Filename without extension    |
| `Extension`       | File extension                |

---

🧩 **DevOps Example (Log Rotation Script)**

```powershell
$logPath = "C:\AppLogs"
$date = Get-Date -Format "yyyyMMdd"

Get-ChildItem $logPath -Filter "*.log" |
Rename-Item -NewName { $_.BaseName + "_" + $date + $_.Extension }
```

Used in:

* **Windows servers**
* **Application log rotation**
* **Jenkins build log archiving**

---

✅ **Best Practices**

* Use **consistent date format** (`yyyyMMdd` or `yyyy-MM-dd`).
* Avoid renaming files that already contain timestamps.
* Combine with **log cleanup scripts** to remove old logs.
* Schedule using **Windows Task Scheduler** for automated rotation.

---

💡 **In short**

* `Get-ChildItem` finds `.log` files.
* `Get-Date` generates the timestamp.
* `Rename-Item` renames files by appending the date for **log rotation and archival automation**.

----
## Q9: Write a PowerShell script to count the number of files and subdirectories in a given path

🧠 **Overview**

* In DevOps and system administration, it is common to **analyze directories for file counts, artifact counts, or log storage usage**.
* PowerShell can easily count files and folders using `Get-ChildItem` and `Measure-Object`.
* This is useful in **CI/CD pipelines, backup validation, artifact repositories, and log monitoring scripts**.

---

⚙️ **Purpose / How it works**

1. Define the **target directory path**.
2. Use `Get-ChildItem` to list directory contents.
3. Filter:

   * `-File` → files only
   * `-Directory` → folders only
4. Count the results using `Measure-Object`.

---

🧩 **PowerShell Script**

```powershell
# Define directory path
$path = "C:\Temp"

# Count files
$fileCount = (Get-ChildItem -Path $path -File).Count

# Count directories
$dirCount = (Get-ChildItem -Path $path -Directory).Count

# Display results
Write-Output "Number of files: $fileCount"
Write-Output "Number of directories: $dirCount"
```

---

🧩 **Example Output**

```
Number of files: 15
Number of directories: 4
```

---

🧩 **Recursive Version (Include Subdirectories)**

Useful when scanning **large artifact directories or log storage locations**.

```powershell
$path = "C:\Temp"

$fileCount = (Get-ChildItem -Path $path -File -Recurse).Count
$dirCount = (Get-ChildItem -Path $path -Directory -Recurse).Count

Write-Output "Total files: $fileCount"
Write-Output "Total directories: $dirCount"
```

---

📋 **Key PowerShell Commands**

| Command         | Purpose                     |
| --------------- | --------------------------- |
| `Get-ChildItem` | Lists files and directories |
| `-File`         | Filters only files          |
| `-Directory`    | Filters only folders        |
| `-Recurse`      | Searches subdirectories     |
| `.Count`        | Counts objects returned     |

---

🧩 **DevOps Example (Artifact Validation Script)**

```powershell
$artifactPath = "C:\BuildArtifacts"

$files = (Get-ChildItem $artifactPath -File -Recurse).Count

Write-Output "Total build artifacts: $files"
```

Used in:

* **Jenkins or Azure DevOps pipelines**
* **Artifact repository validation**
* **Backup verification scripts**

---

✅ **Best Practices**

* Use `-Recurse` for **full directory scans**.
* Avoid recursive scans on **very large directories** unless necessary.
* Log results for monitoring or auditing purposes.

Example logging:

```powershell
"Files: $fileCount | Directories: $dirCount" | Out-File report.txt
```

---

💡 **In short**

* `Get-ChildItem` lists files and directories.
* `.Count` returns the number of objects.
* Useful for **artifact validation, log analysis, and automation scripts in DevOps pipelines**.

----
## Q10: Write a PowerShell script to read a text file line by line and display each line with a line number

🧠 **Overview**

* In DevOps workflows, reading files line-by-line is useful for **log analysis, configuration validation, and parsing pipeline outputs**.
* PowerShell provides `Get-Content` to read file content and loops to process each line.
* By adding a counter, we can print **line numbers alongside each line**, which helps in **debugging logs or identifying errors in large files**.

---

⚙️ **Purpose / How it works**

1. Define the **file path**.
2. Use `Get-Content` to read the file.
3. Maintain a **counter variable** for line numbers.
4. Loop through each line and print it with the line number.

---

🧩 **PowerShell Script**

```powershell
# File path
$filePath = "C:\Temp\sample.txt"

# Initialize line counter
$lineNumber = 1

# Read file line by line
Get-Content $filePath | ForEach-Object {

    Write-Output "$lineNumber : $_"

    $lineNumber++
}
```

---

🧩 **Example Input File (`sample.txt`)**

```
Server started
Database connected
Application running
Error detected
```

---

🧩 **Example Output**

```
1 : Server started
2 : Database connected
3 : Application running
4 : Error detected
```

---

🧩 **Alternative Method (Using Index Counter)**

```powershell
$filePath = "C:\Temp\sample.txt"

(Get-Content $filePath) | ForEach-Object -Begin {$i=1} -Process {
    "$i : $_"
    $i++
}
```

---

📋 **Key PowerShell Commands**

| Command          | Purpose                    |
| ---------------- | -------------------------- |
| `Get-Content`    | Reads file contents        |
| `ForEach-Object` | Iterates through each line |
| `$_`             | Represents current line    |
| `$i++`           | Increments line counter    |
| `Write-Output`   | Prints output              |

---

🧩 **DevOps Example (Log Analysis)**

```powershell
$logFile = "C:\AppLogs\app.log"

$i = 1
Get-Content $logFile | ForEach-Object {
    "$i : $_"
    $i++
}
```

Used for:

* **application log debugging**
* **CI/CD pipeline log inspection**
* **configuration validation scripts**

---

✅ **Best Practices**

* Use `Get-Content -ReadCount` for **large files** to improve performance.
* Validate file existence before reading:

```powershell
if (Test-Path $filePath) {
    Get-Content $filePath
}
```

* Export results if needed for debugging reports.

---

💡 **In short**

* `Get-Content` reads file lines in PowerShell.
* Use a counter variable to add **line numbers**.
* Helpful for **log analysis, debugging, and configuration parsing in DevOps automation**.

----
## Q11: Write a PowerShell script using a `for` loop to print numbers 1 to 10

🧠 **Overview**

* Loops are fundamental in **automation scripts** for repeating tasks such as processing files, deploying multiple resources, or iterating through servers.
* PowerShell supports several loop types (`for`, `foreach`, `while`).
* The `for` loop is commonly used when the **number of iterations is known**, such as printing numbers or processing a fixed range.

---

⚙️ **Purpose / How it works**

A `for` loop has three parts:

1. **Initialization** – starting value of the counter
2. **Condition** – loop runs while condition is true
3. **Increment** – increases the counter each iteration

Structure:

```powershell
for (initialization; condition; increment) {
    # code block
}
```

---

🧩 **PowerShell Script**

```powershell
# Print numbers from 1 to 10

for ($i = 1; $i -le 10; $i++) {
    Write-Output $i
}
```

---

🧩 **Example Output**

```
1
2
3
4
5
6
7
8
9
10
```

---

🧩 **Formatted Output Version**

```powershell
for ($i = 1; $i -le 10; $i++) {
    Write-Output "Number: $i"
}
```

Output:

```
Number: 1
Number: 2
...
Number: 10
```

---

📋 **Loop Components**

| Component      | Example           | Purpose                       |
| -------------- | ----------------- | ----------------------------- |
| Initialization | `$i = 1`          | Start counter                 |
| Condition      | `$i -le 10`       | Loop runs while true          |
| Increment      | `$i++`            | Increase value each iteration |
| Body           | `Write-Output $i` | Executes each cycle           |

---

🧩 **DevOps Example (Loop for Multiple Servers)**

```powershell
for ($i = 1; $i -le 5; $i++) {
    Write-Output "Deploying to server$i"
}
```

Example output:

```
Deploying to server1
Deploying to server2
Deploying to server3
Deploying to server4
Deploying to server5
```

Used in:

* **deployment automation**
* **batch server operations**
* **CI/CD pipeline scripting**

---

✅ **Best Practices**

* Use `for` loops when **iteration count is known**.
* Prefer `foreach` when iterating **through collections or files**.
* Avoid complex logic inside loops to keep scripts readable.

---

💡 **In short**

* `for` loop repeats a block of code for a fixed number of times.
* `$i = 1; $i -le 10; $i++` prints numbers from **1 to 10**.
* Commonly used for **automation tasks and iterative operations in scripts**.

---
## Q12: Write a PowerShell script using a `while` loop to display a countdown from 10 to 1

🧠 **Overview**

* A `while` loop repeatedly executes code **as long as a condition remains true**.
* In automation scripts, `while` loops are useful for **waiting for conditions, retrying operations, monitoring services, or performing countdown timers**.
* This script demonstrates a countdown from **10 to 1**, printing each number sequentially.

---

⚙️ **Purpose / How it works**

1. Initialize a variable with the starting value (`10`).
2. Use a `while` loop to check if the value is greater than or equal to `1`.
3. Print the value.
4. Decrement the value each iteration.

Loop stops when the condition becomes **false**.

---

🧩 **PowerShell Script**

```powershell
# Initialize counter
$count = 10

# Countdown loop
while ($count -ge 1) {

    Write-Output $count

    $count--
}
```

---

🧩 **Example Output**

```
10
9
8
7
6
5
4
3
2
1
```

---

🧩 **Countdown with Delay (Timer Example)**

Useful for **automation waits or deployment timers**.

```powershell
$count = 10

while ($count -ge 1) {

    Write-Output "Countdown: $count"

    Start-Sleep -Seconds 1

    $count--
}
```

Output:

```
Countdown: 10
Countdown: 9
...
Countdown: 1
```

---

📋 **Key PowerShell Commands**

| Command        | Purpose                               |
| -------------- | ------------------------------------- |
| `while`        | Executes loop while condition is true |
| `$count--`     | Decreases counter value               |
| `Write-Output` | Prints output                         |
| `Start-Sleep`  | Pauses script execution               |

---

🧩 **DevOps Example (Retry Mechanism)**

```powershell
$retry = 5

while ($retry -gt 0) {

    Write-Output "Retry attempt: $retry"

    Start-Sleep 5

    $retry--
}
```

Used for:

* **service readiness checks**
* **deployment retries**
* **pipeline waiting mechanisms**

---

✅ **Best Practices**

* Always ensure the loop **modifies the condition variable** to prevent infinite loops.
* Use `Start-Sleep` when implementing **polling or retry logic**.
* Log outputs for debugging automation scripts.

---

💡 **In short**

* `while` loop runs **until the condition becomes false**.
* Decrement a counter variable to create a **countdown from 10 to 1**.
* Useful for **retry logic, monitoring scripts, and automation timers**.

---
## Q13: Write a PowerShell script that uses `if-else` to check if a number is even or odd

🧠 **Overview**

* Conditional logic is essential in **automation scripts** to make decisions based on input values.
* PowerShell uses `if`, `elseif`, and `else` statements to control execution flow.
* Checking whether a number is **even or odd** is typically done using the **modulus operator (`%`)**, which returns the remainder after division.

---

⚙️ **Purpose / How it works**

1. Accept a number as input.
2. Use the modulus operator `%` to divide the number by `2`.
3. If the remainder is `0`, the number is **even**.
4. Otherwise, the number is **odd**.

Condition logic:

```
number % 2 == 0 → Even
number % 2 != 0 → Odd
```

---

🧩 **PowerShell Script**

```powershell
# Ask user for a number
$num = Read-Host "Enter a number"

# Convert input to integer
$num = [int]$num

# Check if number is even or odd
if ($num % 2 -eq 0) {

    Write-Output "$num is an Even number"

} else {

    Write-Output "$num is an Odd number"

}
```

---

🧩 **Example Execution**

```powershell
PS C:\Scripts> .\evenodd.ps1
Enter a number: 8
8 is an Even number
```

```powershell
PS C:\Scripts> .\evenodd.ps1
Enter a number: 7
7 is an Odd number
```

---

🧩 **Automation-Friendly Version (Using Parameters)**

Better for **CI/CD pipelines or automation scripts**.

```powershell
param(
    [int]$Number
)

if ($Number % 2 -eq 0) {
    Write-Output "$Number is Even"
}
else {
    Write-Output "$Number is Odd"
}
```

Run:

```powershell
.\evenodd.ps1 -Number 15
```

Output:

```
15 is Odd
```

---

📋 **Key PowerShell Operators**

| Operator | Meaning               | Example                          |
| -------- | --------------------- | -------------------------------- |
| `%`      | Modulus (remainder)   | `7 % 2 = 1`                      |
| `-eq`    | Equal comparison      | `$a -eq 5`                       |
| `-ne`    | Not equal             | `$a -ne 5`                       |
| `if`     | Conditional statement | `if(condition){}`                |
| `else`   | Alternative block     | Executes when condition is false |

---

🧩 **DevOps Example (Conditional Logic in Scripts)**

```powershell
$buildNumber = 10

if ($buildNumber % 2 -eq 0) {
    Write-Output "Even build number - Running extended tests"
}
else {
    Write-Output "Odd build number - Running quick tests"
}
```

Used in:

* **pipeline branching logic**
* **conditional deployments**
* **automation decision workflows**

---

✅ **Best Practices**

* Convert user input to **correct data types (`[int]`)**.
* Validate inputs before performing operations.
* Use **parameters instead of prompts** for automation scripts.

---

💡 **In short**

* Use `%` (modulus) to check remainder after division by `2`.
* If remainder is `0` → **Even**, otherwise **Odd**.
* Implement using `if-else` for **decision-making in automation scripts**.

----
## Q14: Write a PowerShell script that uses a `switch` statement to display the day of the week based on a number (1–7)

🧠 **Overview**

* The `switch` statement in PowerShell is used to **evaluate multiple conditions efficiently**, making it cleaner than multiple `if-elseif` blocks.
* It is commonly used in **automation scripts, menu-based tools, and pipeline logic** where different actions occur depending on input values.
* In this example, a number **(1–7)** maps to a **day of the week**.

---

⚙️ **Purpose / How it works**

1. Accept a number input from the user.
2. Use the `switch` statement to match the number.
3. Display the corresponding day.
4. Use `default` to handle invalid inputs.

Mapping example:

```text
1 → Monday
2 → Tuesday
...
7 → Sunday
```

---

🧩 **PowerShell Script**

```powershell
# Ask user for input
$dayNumber = Read-Host "Enter a number (1-7)"

switch ($dayNumber) {

    1 { Write-Output "Monday" }
    2 { Write-Output "Tuesday" }
    3 { Write-Output "Wednesday" }
    4 { Write-Output "Thursday" }
    5 { Write-Output "Friday" }
    6 { Write-Output "Saturday" }
    7 { Write-Output "Sunday" }

    default { Write-Output "Invalid number. Please enter a value between 1 and 7." }
}
```

---

🧩 **Example Execution**

```powershell
PS C:\Scripts> .\day.ps1
Enter a number (1-7): 3
Wednesday
```

```powershell
PS C:\Scripts> .\day.ps1
Enter a number (1-7): 8
Invalid number. Please enter a value between 1 and 7.
```

---

🧩 **Automation-Friendly Version (Using Parameters)**

```powershell
param(
    [int]$DayNumber
)

switch ($DayNumber) {

    1 { "Monday" }
    2 { "Tuesday" }
    3 { "Wednesday" }
    4 { "Thursday" }
    5 { "Friday" }
    6 { "Saturday" }
    7 { "Sunday" }

    default { "Invalid input" }
}
```

Run:

```powershell
.\day.ps1 -DayNumber 5
```

Output:

```
Friday
```

---

📋 **Switch vs If-Else**

| Feature     | switch                          | if-else                    |
| ----------- | ------------------------------- | -------------------------- |
| Readability | Cleaner for many conditions     | Can become complex         |
| Performance | Faster for multiple comparisons | Slower for long chains     |
| Syntax      | Compact                         | More verbose               |
| Use Case    | Menu options, mappings          | Complex logical conditions |

---

🧩 **DevOps Example (Environment Selection)**

```powershell
$env = "prod"

switch ($env) {

    "dev"  { Write-Output "Deploying to Development Environment" }
    "test" { Write-Output "Deploying to Testing Environment" }
    "prod" { Write-Output "Deploying to Production Environment" }

    default { Write-Output "Unknown environment" }
}
```

Used in:

* **deployment scripts**
* **pipeline environment selection**
* **automation workflows**

---

✅ **Best Practices**

* Use `switch` when checking **multiple discrete values**.
* Always include a `default` case for **invalid inputs**.
* Prefer **parameter-based scripts** for automation pipelines.

---

💡 **In short**

* `switch` evaluates multiple conditions efficiently.
* Map numbers **1–7** to **days of the week**.
* Cleaner and more readable than long `if-elseif` chains in automation scripts.

---
## Q15: Write a PowerShell script using a `foreach` loop to iterate through an array of server names and ping each one

🧠 **Overview**

* In DevOps and system administration, scripts often need to **check connectivity to multiple servers** before deployments, backups, or maintenance tasks.
* PowerShell’s `foreach` loop is ideal for **iterating through arrays or collections** such as server lists, IP addresses, or services.
* The `Test-Connection` cmdlet is commonly used to **ping servers and verify network reachability**.

---

⚙️ **Purpose / How it works**

1. Define an **array of server names or IP addresses**.
2. Use a `foreach` loop to iterate through each server.
3. Use `Test-Connection` to send ping requests.
4. Display the result for each server.

---

🧩 **PowerShell Script**

```powershell
# List of servers
$servers = @("server1", "server2", "server3")

# Iterate through each server and ping
foreach ($server in $servers) {

    Write-Output "Pinging $server..."

    Test-Connection -ComputerName $server -Count 2
}
```

---

🧩 **Example Output**

```
Pinging server1...
Reply from server1: bytes=32 time=5ms TTL=128

Pinging server2...
Reply from server2: bytes=32 time=3ms TTL=128
```

---

🧩 **Improved Version (Success / Failure Status)**

```powershell
$servers = @("server1", "server2", "server3")

foreach ($server in $servers) {

    if (Test-Connection -ComputerName $server -Count 1 -Quiet) {

        Write-Output "$server is reachable"

    } else {

        Write-Output "$server is NOT reachable"

    }
}
```

Example output:

```
server1 is reachable
server2 is reachable
server3 is NOT reachable
```

---

📋 **Key PowerShell Commands**

| Command           | Purpose                                       |
| ----------------- | --------------------------------------------- |
| `@()`             | Creates an array                              |
| `foreach`         | Iterates through collection                   |
| `Test-Connection` | Sends ping requests                           |
| `-Count`          | Number of ping attempts                       |
| `-Quiet`          | Returns True/False instead of detailed output |

---

🧩 **DevOps Example (Checking Servers Before Deployment)**

```powershell
$servers = @("app-server1","app-server2","db-server1")

foreach ($server in $servers) {

    if (Test-Connection $server -Count 1 -Quiet) {

        Write-Output "Deployment allowed on $server"

    } else {

        Write-Output "Skipping $server - unreachable"
    }
}
```

Used in:

* **pre-deployment health checks**
* **infrastructure monitoring**
* **CI/CD pipeline validation**

---

✅ **Best Practices**

* Use `-Quiet` when only **success/failure status** is needed.
* Store server lists in **configuration files or variables** for scalability.
* Add **logging or reporting** when used in automation pipelines.

---

💡 **In short**

* `foreach` iterates through arrays like server lists.
* `Test-Connection` pings each server.
* Useful for **connectivity checks, deployment validation, and infrastructure monitoring**.

---
## Q16: Write a PowerShell script to create a multiplication table for a given number using loops

🧠 **Overview**

* Loops in PowerShell are commonly used in automation scripts to **repeat tasks, generate outputs, or process batches of data**.
* A multiplication table example demonstrates how loops perform **iterative calculations**.
* Similar looping logic is used in **DevOps automation**, such as generating reports, iterating through resources, or processing multiple configurations.

---

⚙️ **Purpose / How it works**

1. Accept a number from the user.
2. Use a loop to iterate from **1 to 10**.
3. Multiply the input number by the loop counter.
4. Display the result as a multiplication table.

Formula:

```
Result = Number × Counter
```

---

🧩 **PowerShell Script (Using `for` Loop)**

```powershell
# Ask user for number
$num = Read-Host "Enter a number"

# Convert to integer
$num = [int]$num

# Generate multiplication table
for ($i = 1; $i -le 10; $i++) {

    $result = $num * $i

    Write-Output "$num x $i = $result"
}
```

---

🧩 **Example Execution**

```powershell
PS C:\Scripts> .\table.ps1
Enter a number: 5
5 x 1 = 5
5 x 2 = 10
5 x 3 = 15
5 x 4 = 20
5 x 5 = 25
5 x 6 = 30
5 x 7 = 35
5 x 8 = 40
5 x 9 = 45
5 x 10 = 50
```

---

🧩 **Alternative Version (Using `foreach` Loop)**

```powershell
$num = Read-Host "Enter a number"
$num = [int]$num

foreach ($i in 1..10) {

    $result = $num * $i

    Write-Output "$num x $i = $result"
}
```

---

📋 **Loop Comparison**

| Loop Type | Syntax                        | Best Use Case                 |
| --------- | ----------------------------- | ----------------------------- |
| `for`     | `for ($i=1; $i -le 10; $i++)` | Fixed number of iterations    |
| `foreach` | `foreach ($i in 1..10)`       | Iterating through collections |
| `while`   | `while ($condition)`          | Unknown number of iterations  |

---

🧩 **DevOps Example (Iterating Through Build Numbers)**

```powershell
for ($build = 1; $build -le 5; $build++) {

    Write-Output "Processing build number: $build"
}
```

Used in:

* **batch deployments**
* **CI/CD job iterations**
* **automation tasks processing multiple resources**

---

✅ **Best Practices**

* Convert input to the correct **data type (`[int]`)** before calculations.
* Use **`for` loops for numeric sequences**.
* Use `foreach` when iterating through **arrays or resource lists**.

---

💡 **In short**

* Use loops to repeat calculations.
* Multiply the input number by values **1–10** to generate a table.
* Loop constructs are widely used in **automation and DevOps scripting tasks**.

---
## Q17: Write a PowerShell script that accepts two numbers and performs addition, subtraction, multiplication, and division based on user choice

🧠 **Overview**

* PowerShell scripts can combine **user input, conditional logic, and arithmetic operations** to create simple interactive tools.
* Such scripts demonstrate how automation can **process inputs and execute different actions based on user selections**.
* Similar patterns are used in **administrative utilities, automation menus, and deployment scripts**.

---

⚙️ **Purpose / How it works**

1. Accept **two numbers** from the user.
2. Ask the user to choose an operation.
3. Use a `switch` statement to determine which calculation to perform.
4. Display the result.

Supported operations:

```text
1 → Addition
2 → Subtraction
3 → Multiplication
4 → Division
```

---

🧩 **PowerShell Script**

```powershell
# Take numbers from user
$num1 = [int](Read-Host "Enter first number")
$num2 = [int](Read-Host "Enter second number")

# Display menu
Write-Output "Choose operation:"
Write-Output "1 - Addition"
Write-Output "2 - Subtraction"
Write-Output "3 - Multiplication"
Write-Output "4 - Division"

$choice = Read-Host "Enter your choice (1-4)"

switch ($choice) {

    1 { Write-Output "Result: $($num1 + $num2)" }

    2 { Write-Output "Result: $($num1 - $num2)" }

    3 { Write-Output "Result: $($num1 * $num2)" }

    4 { 
        if ($num2 -eq 0) {
            Write-Output "Error: Division by zero is not allowed."
        } else {
            Write-Output "Result: $($num1 / $num2)"
        }
    }

    default { Write-Output "Invalid choice." }
}
```

---

🧩 **Example Execution**

```powershell
Enter first number: 10
Enter second number: 5

Choose operation:
1 - Addition
2 - Subtraction
3 - Multiplication
4 - Division

Enter your choice (1-4): 1
Result: 15
```

---

🧩 **Automation-Friendly Version (Using Parameters)**

```powershell
param(
    [int]$Num1,
    [int]$Num2,
    [string]$Operation
)

switch ($Operation) {

    "add" { $Num1 + $Num2 }

    "sub" { $Num1 - $Num2 }

    "mul" { $Num1 * $Num2 }

    "div" { 
        if ($Num2 -eq 0) { "Division by zero not allowed" }
        else { $Num1 / $Num2 }
    }

    default { "Invalid operation" }
}
```

Run:

```powershell
.\calc.ps1 -Num1 10 -Num2 5 -Operation add
```

Output:

```
15
```

---

📋 **Arithmetic Operators in PowerShell**

| Operator | Operation      | Example       |
| -------- | -------------- | ------------- |
| `+`      | Addition       | `10 + 5 = 15` |
| `-`      | Subtraction    | `10 - 5 = 5`  |
| `*`      | Multiplication | `10 * 5 = 50` |
| `/`      | Division       | `10 / 5 = 2`  |
| `%`      | Modulus        | `10 % 3 = 1`  |

---

🧩 **DevOps Example (Menu-Based Script)**

```powershell
Write-Output "1 - Start Service"
Write-Output "2 - Stop Service"

$choice = Read-Host "Enter option"

switch ($choice) {

    1 { Start-Service "nginx" }

    2 { Stop-Service "nginx" }

}
```

Used for:

* **administration tools**
* **interactive automation scripts**
* **deployment control menus**

---

✅ **Best Practices**

* Convert input to **numeric types** (`[int]`).
* Always handle **division by zero** errors.
* Prefer **parameter-based scripts** for CI/CD pipelines instead of interactive prompts.

---

💡 **In short**

* Accept two numbers and an operation choice.
* Use `switch` to select the arithmetic operation.
* Perform **addition, subtraction, multiplication, or division** and display the result.

---
## Q18: Write a PowerShell script using nested loops to create a 5x5 pattern of asterisks (`*`)

🧠 **Overview**

* Nested loops are used when **one loop runs inside another loop**, commonly for generating **matrix patterns, tables, or grid-based outputs**.
* In scripting and automation, nested loops help process **multi-dimensional data, configuration sets, or batch operations**.
* This example generates a **5×5 grid of asterisks (`*`)** using nested loops.

---

⚙️ **Purpose / How it works**

1. Use an **outer loop** to control rows.
2. Use an **inner loop** to print asterisks for each column.
3. After printing 5 asterisks, move to the next line.
4. Repeat until 5 rows are printed.

Loop structure:

```text
Outer loop → Rows
Inner loop → Columns
```

---

🧩 **PowerShell Script**

```powershell
# Print 5x5 star pattern using nested loops

for ($i = 1; $i -le 5; $i++) {

    $line = ""

    for ($j = 1; $j -le 5; $j++) {

        $line += "* "
    }

    Write-Output $line
}
```

---

🧩 **Example Output**

```
* * * * *
* * * * *
* * * * *
* * * * *
* * * * *
```

---

🧩 **Alternative Version (Direct Console Output)**

```powershell
for ($i = 1; $i -le 5; $i++) {

    for ($j = 1; $j -le 5; $j++) {

        Write-Host "*" -NoNewline
    }

    Write-Host ""
}
```

Output:

```
*****
*****
*****
*****
*****
```

---

📋 **Nested Loop Structure**

| Loop       | Purpose          | Example                      |
| ---------- | ---------------- | ---------------------------- |
| Outer Loop | Controls rows    | `for ($i=1; $i -le 5; $i++)` |
| Inner Loop | Controls columns | `for ($j=1; $j -le 5; $j++)` |
| Output     | Prints pattern   | `"*"`                        |

---

🧩 **DevOps Example (Processing Multiple Environments & Servers)**

```powershell
$envs = @("dev","test","prod")
$servers = @("app1","app2")

foreach ($env in $envs) {

    foreach ($server in $servers) {

        Write-Output "Deploying to $server in $env environment"
    }
}
```

Used in:

* **multi-environment deployments**
* **iterating infrastructure resources**
* **batch automation tasks**

---

✅ **Best Practices**

* Keep nested loops **simple to maintain readability**.
* Avoid deeply nested loops for large datasets (performance impact).
* Use meaningful variables (`$row`, `$column`) in production scripts.

---

💡 **In short**

* Nested loops run **a loop inside another loop**.
* Outer loop controls **rows**, inner loop controls **columns**.
* Used to generate **patterns, grids, and multi-resource automation tasks**.

---
## Q19: Write a PowerShell script to find the largest number in an array of integers

🧠 **Overview**

* Arrays are commonly used in scripts to store **multiple values such as server IDs, build numbers, ports, or metrics**.
* Finding the **maximum value** in a dataset is a common operation in automation, monitoring, and reporting scripts.
* PowerShell can determine the largest number using **loops or built-in cmdlets like `Measure-Object`**.

---

⚙️ **Purpose / How it works**

1. Define an **array of integers**.
2. Assume the first element is the **largest value** initially.
3. Iterate through the array using a loop.
4. Compare each value with the current largest value.
5. Update the largest value if a bigger number is found.

---

🧩 **PowerShell Script (Using `foreach` Loop)**

```powershell
# Define array of integers
$numbers = @(10, 45, 23, 67, 12, 89, 34)

# Assume first element is the largest
$largest = $numbers[0]

# Iterate through array
foreach ($num in $numbers) {

    if ($num -gt $largest) {
        $largest = $num
    }
}

Write-Output "Largest number in the array is: $largest"
```

---

🧩 **Example Output**

```
Largest number in the array is: 89
```

---

🧩 **Alternative Method (Using Built-in Cmdlet)**

PowerShell provides an easier method using `Measure-Object`.

```powershell
$numbers = @(10, 45, 23, 67, 12, 89, 34)

$largest = ($numbers | Measure-Object -Maximum).Maximum

Write-Output "Largest number: $largest"
```

---

📋 **Comparison of Methods**

| Method           | Approach                   | Use Case                            |
| ---------------- | -------------------------- | ----------------------------------- |
| `foreach` loop   | Manual comparison          | Learning logic / scripting practice |
| `Measure-Object` | Built-in cmdlet            | Production scripts                  |
| `Sort-Object`    | Sort values then pick last | Smaller datasets                    |

Example using sorting:

```powershell
$largest = ($numbers | Sort-Object)[-1]
```

---

🧩 **DevOps Example (Finding Highest CPU Usage)**

```powershell
$cpuUsage = @(30, 55, 78, 42, 90, 60)

$maxCPU = ($cpuUsage | Measure-Object -Maximum).Maximum

Write-Output "Highest CPU usage recorded: $maxCPU%"
```

Used in:

* **monitoring scripts**
* **performance analysis**
* **resource utilization reports**

---

✅ **Best Practices**

* Use **built-in cmdlets (`Measure-Object`)** for cleaner scripts.
* Validate arrays before processing to avoid empty values.
* Use descriptive variable names (`$maxValue`, `$largestNumber`).

---

💡 **In short**

* Store integers in an array.
* Compare values using a loop or use `Measure-Object -Maximum`.
* The highest value represents the **largest number in the array**.

---
## Q20: Write a PowerShell script that reads a CSV file and displays specific columns

🧠 **Overview**

* CSV files are widely used in DevOps and system administration for **reports, inventory data, user lists, and configuration exports**.
* PowerShell provides the `Import-Csv` cmdlet to read CSV files and convert them into **structured objects**.
* Specific columns can be extracted using `Select-Object`, making it easy to **filter and display relevant data**.

---

⚙️ **Purpose / How it works**

1. Provide the **CSV file path**.
2. Use `Import-Csv` to read the file.
3. Use `Select-Object` to extract only the required columns.
4. Display the filtered output.

---

🧩 **Example CSV File (`servers.csv`)**

```csv
ServerName,IP,Environment,Status
app01,10.0.1.10,dev,Running
app02,10.0.1.11,test,Stopped
app03,10.0.1.12,prod,Running
```

---

🧩 **PowerShell Script**

```powershell
# Path to CSV file
$csvPath = "C:\Temp\servers.csv"

# Read CSV and display specific columns
Import-Csv $csvPath |
Select-Object ServerName, Environment
```

---

🧩 **Example Output**

```
ServerName  Environment
----------  -----------
app01       dev
app02       test
app03       prod
```

---

🧩 **Formatted Table Output**

```powershell
Import-Csv "C:\Temp\servers.csv" |
Select-Object ServerName, IP |
Format-Table -AutoSize
```

Output:

```
ServerName  IP
----------  ---------
app01       10.0.1.10
app02       10.0.1.11
app03       10.0.1.12
```

---

🧩 **Filtering Example (DevOps Scenario)**

Display only **production servers**.

```powershell
Import-Csv "C:\Temp\servers.csv" |
Where-Object { $_.Environment -eq "prod" } |
Select-Object ServerName, IP
```

---

📋 **Key PowerShell Commands**

| Command         | Purpose                              |
| --------------- | ------------------------------------ |
| `Import-Csv`    | Reads CSV file as PowerShell objects |
| `Select-Object` | Selects specific columns             |
| `Where-Object`  | Filters data                         |
| `Format-Table`  | Displays formatted output            |

---

🧩 **DevOps Example (Server Inventory Report)**

```powershell
$servers = Import-Csv "C:\Inventory\servers.csv"

$servers |
Select-Object ServerName, Environment, Status
```

Used for:

* **infrastructure inventory reports**
* **deployment target lists**
* **server health dashboards**

---

✅ **Best Practices**

* Always ensure the CSV file has **proper headers**.
* Avoid `Format-Table` if output is being piped to another command.
* Use `Where-Object` to filter large datasets before displaying results.

---

💡 **In short**

* `Import-Csv` reads CSV files as structured objects.
* `Select-Object` extracts specific columns.
* Useful for **inventory reports, deployment data, and automation scripts**.

----
## Q21: Write a PowerShell function that takes a directory path as a parameter and returns the total size of all files in MB

🧠 **Overview**

* In DevOps and system administration, scripts often need to **analyze disk usage, log storage, artifact size, or backup directories**.
* PowerShell can calculate directory size by **summing file sizes (`Length`) returned by `Get-ChildItem`**.
* Wrapping this logic inside a **function with parameters** makes it reusable for automation scripts, monitoring tools, or CI/CD tasks.

---

⚙️ **Purpose / How it works**

1. Define a **function** with a parameter for directory path.
2. Use `Get-ChildItem` to retrieve all files in the directory.
3. Use `Measure-Object` to calculate the **total size in bytes**.
4. Convert bytes to **MB** using division by `1MB`.
5. Return the final value.

---

🧩 **PowerShell Function**

```powershell
function Get-DirectorySizeMB {

    param (
        [string]$Path
    )

    # Get total size in bytes
    $totalBytes = (Get-ChildItem -Path $Path -File -Recurse |
                   Measure-Object -Property Length -Sum).Sum

    # Convert to MB
    $sizeMB = [math]::Round($totalBytes / 1MB, 2)

    return $sizeMB
}

# Example usage
$dirSize = Get-DirectorySizeMB -Path "C:\Logs"

Write-Output "Total directory size: $dirSize MB"
```

---

🧩 **Example Output**

```
Total directory size: 125.47 MB
```

---

🧩 **Simplified One-Liner Version**

```powershell
function Get-DirectorySizeMB($path) {
    [math]::Round((Get-ChildItem $path -File -Recurse | Measure-Object Length -Sum).Sum / 1MB, 2)
}
```

Usage:

```powershell
Get-DirectorySizeMB "C:\Temp"
```

---

📋 **Key PowerShell Components**

| Command               | Purpose                           |
| --------------------- | --------------------------------- |
| `function`            | Creates reusable script block     |
| `param()`             | Accepts parameters                |
| `Get-ChildItem`       | Lists files                       |
| `Measure-Object -Sum` | Calculates total file size        |
| `[math]::Round()`     | Rounds numeric output             |
| `1MB`                 | Built-in PowerShell size constant |

---

🧩 **DevOps Example (Log Storage Monitoring)**

```powershell
$logSize = Get-DirectorySizeMB "C:\AppLogs"

if ($logSize -gt 500) {
    Write-Output "Warning: Log directory exceeds 500 MB"
}
```

Used for:

* **disk usage monitoring**
* **log storage validation**
* **artifact repository size checks**

---

✅ **Best Practices**

* Always validate the directory exists before processing.

```powershell
if (!(Test-Path $Path)) {
    Write-Error "Directory not found"
}
```

* Use `-Recurse` only when needed for **deep directory scans**.
* Implement this function in **monitoring or cleanup scripts**.

---

💡 **In short**

* Use `Get-ChildItem` to list files and `Measure-Object` to sum their sizes.
* Convert bytes to MB using `/ 1MB`.
* Wrap the logic in a **PowerShell function for reusable disk usage analysis**.

----
## Q22: Write a PowerShell function that accepts a string and returns it in reverse order

🧠 **Overview**

* String manipulation is common in scripting tasks such as **log processing, parsing identifiers, and formatting outputs**.
* Reversing a string demonstrates how PowerShell can **process character arrays and return transformed results**.
* This logic is often used in **data transformation scripts, validation utilities, and automation pipelines**.

---

⚙️ **Purpose / How it works**

1. Create a **PowerShell function** with a string parameter.
2. Convert the string into a **character array**.
3. Reverse the array using the `.Reverse()` method.
4. Join the characters back into a string and return it.

---

🧩 **PowerShell Function**

```powershell
function Reverse-String {

    param (
        [string]$InputString
    )

    # Convert string to character array
    $charArray = $InputString.ToCharArray()

    # Reverse the array
    [array]::Reverse($charArray)

    # Join characters back into a string
    $reversed = -join $charArray

    return $reversed
}

# Example usage
$result = Reverse-String -InputString "DevOps"

Write-Output "Reversed string: $result"
```

---

🧩 **Example Output**

```
Reversed string: spOveD
```

---

🧩 **Simplified Version**

```powershell
function Reverse-String($text) {

    $chars = $text.ToCharArray()
    [array]::Reverse($chars)

    return -join $chars
}
```

Usage:

```powershell
Reverse-String "Automation"
```

Output:

```
noitamotuA
```

---

📋 **Key PowerShell Components**

| Component            | Purpose                    |
| -------------------- | -------------------------- |
| `function`           | Defines reusable logic     |
| `param()`            | Accepts input parameters   |
| `.ToCharArray()`     | Converts string to array   |
| `[array]::Reverse()` | Reverses array elements    |
| `-join`              | Combines array into string |

---

🧩 **DevOps Example (Processing Identifiers)**

```powershell
$buildId = "build123"

$reverseId = Reverse-String $buildId

Write-Output "Reversed build ID: $reverseId"
```

Used in:

* **string transformations**
* **automation utilities**
* **data formatting scripts**

---

✅ **Best Practices**

* Always define **parameters explicitly** for reusable functions.
* Use built-in **.NET methods** (`[array]::Reverse`) for better performance.
* Validate input to handle **empty or null strings**.

Example validation:

```powershell
if ([string]::IsNullOrEmpty($InputString)) {
    return "Invalid input"
}
```

---

💡 **In short**

* Convert the string to a **character array**.
* Reverse the array using `[array]::Reverse()`.
* Join the characters back to return the **reversed string**.

----
## Q23: Write a PowerShell function with mandatory and optional parameters that calculates the area of a rectangle

🧠 **Overview**

* PowerShell functions support **mandatory and optional parameters**, allowing scripts to enforce required inputs while still providing flexibility.
* This pattern is widely used in **DevOps automation scripts, CLI tools, and deployment utilities** where certain parameters must be supplied and others can have defaults.
* In this example, the function calculates the **area of a rectangle (Length × Width)** using one mandatory parameter and one optional parameter.

---

⚙️ **Purpose / How it works**

1. Define a PowerShell function.
2. Use `param()` block to declare parameters.
3. Mark **Length** as mandatory.
4. Provide a **default value for Width** (optional parameter).
5. Calculate the rectangle area and return the result.

Formula:

```text
Area = Length × Width
```

---

🧩 **PowerShell Function**

```powershell
function Get-RectangleArea {

    param(
        [Parameter(Mandatory=$true)]
        [double]$Length,

        [double]$Width = 1
    )

    $area = $Length * $Width

    return $area
}

# Example usage
$result = Get-RectangleArea -Length 10 -Width 5

Write-Output "Area of rectangle: $result"
```

---

🧩 **Example Execution**

```powershell
PS C:\Scripts> Get-RectangleArea -Length 10 -Width 5
50
```

---

🧩 **Using Only Mandatory Parameter**

Since `Width` has a default value (`1`), it can be omitted.

```powershell
Get-RectangleArea -Length 10
```

Output:

```
10
```

---

📋 **Parameter Types**

| Parameter | Type      | Description                         |
| --------- | --------- | ----------------------------------- |
| `Length`  | Mandatory | Required input for rectangle length |
| `Width`   | Optional  | Defaults to `1` if not provided     |

---

🧩 **Improved Version with Output Message**

```powershell
function Get-RectangleArea {

    param(
        [Parameter(Mandatory)]
        [double]$Length,

        [double]$Width = 1
    )

    $area = $Length * $Width

    Write-Output "Rectangle Area: $area"
}
```

---

🧩 **DevOps Example (Parameterized Script)**

```powershell
function Start-Deployment {

    param(
        [Parameter(Mandatory)]
        [string]$Environment,

        [string]$Version = "latest"
    )

    Write-Output "Deploying version $Version to $Environment environment"
}
```

Used in:

* **deployment automation**
* **pipeline scripts**
* **infrastructure provisioning tools**

---

✅ **Best Practices**

* Use `[Parameter(Mandatory)]` for **required inputs**.
* Provide sensible **default values for optional parameters**.
* Always define parameter **data types (`[int]`, `[double]`, `[string]`)**.
* Add validation rules for production scripts.

Example:

```powershell
[ValidateRange(1,100)]
[int]$Length
```

---

💡 **In short**

* Mandatory parameters enforce required inputs.
* Optional parameters use **default values** if not supplied.
* Calculate rectangle area using `Length × Width` inside a reusable PowerShell function.

----
## Q24: Write a PowerShell function that validates if a given IP address is valid and returns `true` or `false`

🧠 **Overview**

* In DevOps and infrastructure automation, scripts often need to **validate IP addresses** before performing tasks like **server provisioning, firewall configuration, or network monitoring**.
* PowerShell can validate IP addresses using the .NET method **`[System.Net.IPAddress]::TryParse()`**, which safely checks whether a string is a valid IP.
* The function returns **`$true` for valid IPs** and **`$false` for invalid ones**, making it useful for validation in automation pipelines.

---

⚙️ **Purpose / How it works**

1. Accept an **IP address as a parameter**.
2. Use `.TryParse()` from the **System.Net.IPAddress class**.
3. If parsing succeeds → return `$true`.
4. Otherwise → return `$false`.

---

🧩 **PowerShell Function**

```powershell
function Test-ValidIPAddress {

    param(
        [Parameter(Mandatory)]
        [string]$IPAddress
    )

    $result = [System.Net.IPAddress]::TryParse($IPAddress, [ref]$null)

    return $result
}

# Example usage
Test-ValidIPAddress -IPAddress "192.168.1.10"
```

---

🧩 **Example Output**

```powershell
True
```

Invalid IP example:

```powershell
Test-ValidIPAddress -IPAddress "300.168.1.10"
```

Output:

```
False
```

---

🧩 **Version with Output Message**

```powershell
function Test-ValidIPAddress {

    param(
        [Parameter(Mandatory)]
        [string]$IPAddress
    )

    if ([System.Net.IPAddress]::TryParse($IPAddress, [ref]$null)) {
        Write-Output "Valid IP Address"
        return $true
    }
    else {
        Write-Output "Invalid IP Address"
        return $false
    }
}
```

---

📋 **Key PowerShell / .NET Components**

| Component                | Purpose                    |
| ------------------------ | -------------------------- |
| `function`               | Defines reusable logic     |
| `param()`                | Accepts parameters         |
| `[System.Net.IPAddress]` | .NET class for IP handling |
| `TryParse()`             | Validates IP safely        |
| `$true / $false`         | Boolean return values      |

---

🧩 **DevOps Example (Server Validation Script)**

```powershell
$serverIP = "10.0.1.15"

if (Test-ValidIPAddress $serverIP) {

    Write-Output "Connecting to server $serverIP..."

}
else {

    Write-Output "Invalid IP. Aborting deployment."
}
```

Used in:

* **infrastructure provisioning**
* **network automation scripts**
* **CI/CD deployment validation**

---

✅ **Best Practices**

* Always validate **IP format before network operations**.
* Use `.TryParse()` instead of regex for **more reliable validation**.
* Combine validation with **connectivity checks (`Test-Connection`)** in automation workflows.

Example:

```powershell
if (Test-ValidIPAddress $ip -and (Test-Connection $ip -Count 1 -Quiet)) {
    Write-Output "Server reachable"
}
```

---

💡 **In short**

* Use `.TryParse()` from `[System.Net.IPAddress]` to validate IP addresses.
* Return `$true` if valid, `$false` if invalid.
* Useful in **network automation, infrastructure scripts, and deployment validation**.

----
## Q25: Write a PowerShell function that accepts multiple server names as parameters and tests connectivity to each using `Test-Connection`

🧠 **Overview**

* In DevOps and infrastructure automation, verifying **server connectivity** is a common pre-check before deployments, configuration changes, or monitoring tasks.
* PowerShell’s `Test-Connection` cmdlet performs **ICMP ping tests** to determine whether a host is reachable.
* By accepting **multiple server names as parameters**, the function can validate connectivity for **multiple systems in a single execution**, which is useful in CI/CD pipelines and infrastructure health checks.

---

⚙️ **Purpose / How it works**

1. Define a PowerShell function with a **parameter that accepts multiple values (array)**.
2. Iterate through the server list using a `foreach` loop.
3. Use `Test-Connection` with the `-Quiet` parameter to return **True or False**.
4. Print the connectivity status for each server.

---

🧩 **PowerShell Function**

```powershell
function Test-ServerConnectivity {

    param(
        [Parameter(Mandatory)]
        [string[]]$Servers
    )

    foreach ($server in $Servers) {

        if (Test-Connection -ComputerName $server -Count 1 -Quiet) {

            Write-Output "$server is reachable"

        }
        else {

            Write-Output "$server is NOT reachable"
        }
    }
}

# Example usage
Test-ServerConnectivity -Servers "server1","server2","google.com"
```

---

🧩 **Example Output**

```
server1 is reachable
server2 is NOT reachable
google.com is reachable
```

---

🧩 **Alternative Version (Structured Output for Automation)**

Better for **CI/CD scripts or monitoring tools**.

```powershell
function Test-ServerConnectivity {

    param(
        [string[]]$Servers
    )

    foreach ($server in $Servers) {

        $status = Test-Connection -ComputerName $server -Count 1 -Quiet

        [PSCustomObject]@{
            Server = $server
            Reachable = $status
        }
    }
}
```

Usage:

```powershell
Test-ServerConnectivity -Servers "server1","server2"
```

Output:

```
Server   Reachable
------   ---------
server1  True
server2  False
```

---

📋 **Key PowerShell Components**

| Component         | Purpose                       |
| ----------------- | ----------------------------- |
| `[string[]]`      | Accepts multiple server names |
| `foreach`         | Iterates through server list  |
| `Test-Connection` | Performs network ping test    |
| `-Count`          | Number of ping attempts       |
| `-Quiet`          | Returns Boolean result        |

---

🧩 **DevOps Example (Pre-Deployment Server Check)**

```powershell
$servers = @("app01","app02","db01")

Test-ServerConnectivity -Servers $servers
```

Used for:

* **pre-deployment infrastructure validation**
* **server health checks**
* **network troubleshooting scripts**

---

✅ **Best Practices**

* Use `-Quiet` when only **success/failure status** is needed.
* Accept **arrays (`string[]`)** to process multiple servers efficiently.
* Return **structured objects** for integration with automation pipelines.

Example logging:

```powershell
Test-ServerConnectivity -Servers $servers | Export-Csv connectivity-report.csv -NoTypeInformation
```

---

💡 **In short**

* Accept multiple servers using `[string[]]` parameter.
* Use `Test-Connection` to ping each server.
* Loop through servers and return **connectivity status for automation and monitoring scripts**.

---
## Q26: Write a PowerShell script to list all running services on a Windows machine

🧠 **Overview**

* Windows services are background processes that run applications such as **databases, web servers, and monitoring agents**.
* In DevOps and system administration, listing running services helps with **system health checks, troubleshooting, and automation tasks**.
* PowerShell provides the `Get-Service` cmdlet to retrieve service information and filter services based on their **status**.

---

⚙️ **Purpose / How it works**

1. Use `Get-Service` to retrieve all services.
2. Filter services where the **Status is Running**.
3. Display the service details such as **Name, DisplayName, and Status**.

---

🧩 **PowerShell Script**

```powershell
# Get all running services
Get-Service |
Where-Object { $_.Status -eq "Running" } |
Select-Object Name, DisplayName, Status
```

---

🧩 **Example Output**

```
Name        DisplayName                     Status
----        -----------                     ------
Spooler     Print Spooler                   Running
W32Time     Windows Time                    Running
WinRM       Windows Remote Management       Running
```

---

🧩 **Formatted Table Version**

```powershell
Get-Service |
Where-Object { $_.Status -eq "Running" } |
Select-Object Name, DisplayName, Status |
Format-Table -AutoSize
```

---

🧩 **Simpler One-Line Command**

PowerShell also supports filtering directly.

```powershell
Get-Service | Where Status -eq "Running"
```

---

📋 **Key PowerShell Commands**

| Command         | Purpose                             |
| --------------- | ----------------------------------- |
| `Get-Service`   | Retrieves Windows services          |
| `Where-Object`  | Filters objects based on conditions |
| `Select-Object` | Displays specific properties        |
| `Format-Table`  | Formats output for readability      |

---

🧩 **DevOps Example (Monitoring Critical Services)**

```powershell
$services = Get-Service | Where-Object { $_.Status -eq "Running" }

foreach ($svc in $services) {
    Write-Output "Service running: $($svc.DisplayName)"
}
```

Used in:

* **server health monitoring**
* **automated system checks**
* **CI/CD environment validation**

---

🧩 **Export Running Services Report**

```powershell
Get-Service |
Where-Object { $_.Status -eq "Running" } |
Select Name, DisplayName, Status |
Export-Csv "C:\Temp\running-services.csv" -NoTypeInformation
```

---

✅ **Best Practices**

* Filter services early using `Where-Object` to improve performance.
* Export service reports for **audit or monitoring systems**.
* Monitor **critical services (IIS, SQL Server, WinRM, Docker)** in production environments.

---

💡 **In short**

* `Get-Service` lists Windows services.
* Filter with `Where-Object` for **Running** status.
* Useful for **server monitoring, troubleshooting, and automation scripts**.

----
## Q27: Write a PowerShell script to start a service if it is stopped, and log the action with a timestamp

🧠 **Overview**

* In production environments, critical services (web servers, databases, monitoring agents) must always be **running and healthy**.
* PowerShell can monitor service status using `Get-Service` and automatically **start the service if it is stopped**.
* Logging actions with timestamps helps with **auditing, troubleshooting, and operational monitoring**, which is common in **DevOps automation and health-check scripts**.

---

⚙️ **Purpose / How it works**

1. Define the **service name** and **log file path**.
2. Retrieve service details using `Get-Service`.
3. Check if the service status is **Stopped**.
4. If stopped → start the service using `Start-Service`.
5. Write a log entry with the **current timestamp**.

---

🧩 **PowerShell Script**

```powershell
# Service name
$serviceName = "Spooler"

# Log file path
$logFile = "C:\Temp\service-log.txt"

# Current timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Get service status
$service = Get-Service -Name $serviceName

if ($service.Status -eq "Stopped") {

    Start-Service -Name $serviceName

    "$timestamp - Service $serviceName was stopped and has been started." | Out-File $logFile -Append

    Write-Output "Service started and logged."

} else {

    "$timestamp - Service $serviceName is already running." | Out-File $logFile -Append

    Write-Output "Service already running."
}
```

---

🧩 **Example Log Output**

```
2026-03-04 14:25:10 - Service Spooler was stopped and has been started.
2026-03-04 14:40:21 - Service Spooler is already running.
```

---

🧩 **Improved Version (Error Handling)**

```powershell
$serviceName = "Spooler"
$logFile = "C:\Temp\service-log.txt"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

try {

    $service = Get-Service -Name $serviceName -ErrorAction Stop

    if ($service.Status -eq "Stopped") {

        Start-Service $serviceName

        "$timestamp - Started service $serviceName" | Out-File $logFile -Append
    }
    else {

        "$timestamp - Service $serviceName already running" | Out-File $logFile -Append
    }

}
catch {

    "$timestamp - Error managing service $serviceName : $_" | Out-File $logFile -Append
}
```

---

📋 **Key PowerShell Commands**

| Command            | Purpose                         |
| ------------------ | ------------------------------- |
| `Get-Service`      | Retrieves service information   |
| `Start-Service`    | Starts a stopped service        |
| `Get-Date`         | Generates timestamp             |
| `Out-File -Append` | Writes logs without overwriting |
| `try / catch`      | Handles runtime errors          |

---

🧩 **DevOps Example (Auto-Healing Script)**

```powershell
$criticalServices = @("WinRM","Spooler","W32Time")

foreach ($svc in $criticalServices) {

    $status = Get-Service $svc

    if ($status.Status -eq "Stopped") {

        Start-Service $svc
        Write-Output "$(Get-Date) - Started $svc"
    }
}
```

Used for:

* **server auto-healing scripts**
* **Windows server monitoring**
* **CI/CD environment health validation**

---

✅ **Best Practices**

* Always log **service actions with timestamps**.
* Use **try/catch blocks** for production scripts.
* Monitor only **critical services** to reduce noise.
* Schedule this script using **Windows Task Scheduler** for automated health checks.

---

💡 **In short**

* Use `Get-Service` to check service status.
* If stopped → start with `Start-Service`.
* Log the action with a **timestamp for monitoring and auditing**.

----
## Q28: Write a PowerShell script to stop all services that start with a specific name pattern (e.g., `"Windows*"`)

🧠 **Overview**

* In system administration and DevOps automation, it is sometimes necessary to **stop multiple services that match a naming pattern**, such as during **maintenance, deployments, or troubleshooting**.
* PowerShell allows filtering services using **wildcards (`*`)** and managing them using `Stop-Service`.
* This script retrieves services matching a pattern and stops them in bulk.

---

⚙️ **Purpose / How it works**

1. Define the **service name pattern** (e.g., `"Windows*"`).
2. Use `Get-Service` to retrieve services matching that pattern.
3. Loop through each service using `foreach`.
4. Stop each service using `Stop-Service`.

---

🧩 **PowerShell Script**

```powershell
# Service name pattern
$servicePattern = "Windows*"

# Get matching services
$services = Get-Service -Name $servicePattern

# Stop each service
foreach ($service in $services) {

    if ($service.Status -eq "Running") {

        Stop-Service -Name $service.Name -Force

        Write-Output "Stopped service: $($service.Name)"
    }
}
```

---

🧩 **Example Output**

```
Stopped service: WindowsUpdate
Stopped service: WindowsBackup
Stopped service: WindowsSearch
```

---

🧩 **Simpler One-Line Command**

PowerShell supports direct filtering.

```powershell
Get-Service -Name "Windows*" | Where-Object { $_.Status -eq "Running" } | Stop-Service -Force
```

---

🧩 **Preview Mode (Check Before Stopping)**

Useful for **safe operations in production systems**.

```powershell
Get-Service -Name "Windows*" |
Where-Object { $_.Status -eq "Running" } |
Select-Object Name, Status
```

---

📋 **Key PowerShell Commands**

| Command            | Purpose                              |
| ------------------ | ------------------------------------ |
| `Get-Service`      | Retrieves Windows services           |
| `-Name "pattern*"` | Filters services by name pattern     |
| `Where-Object`     | Filters based on conditions          |
| `Stop-Service`     | Stops a service                      |
| `-Force`           | Stops dependent services if required |

---

🧩 **DevOps Example (Stopping Services Before Deployment)**

```powershell
$services = Get-Service -Name "AppService*"

foreach ($svc in $services) {

    if ($svc.Status -eq "Running") {

        Stop-Service $svc.Name
        Write-Output "Stopped $($svc.Name) before deployment"
    }
}
```

Used in:

* **maintenance windows**
* **application deployments**
* **environment reset scripts**

---

✅ **Best Practices**

* Always **preview services before stopping them** in production.
* Avoid stopping **critical system services** accidentally.
* Use `-Force` carefully because it can stop dependent services.
* Implement **logging for automation scripts**.

---

💡 **In short**

* Use `Get-Service -Name "pattern*"` to find services by name pattern.
* Filter running services and stop them using `Stop-Service`.
* Useful for **bulk service management in automation and maintenance scripts**.

---
## Q29: Write a PowerShell script to get a list of all installed applications on a Windows machine

🧠 **Overview**

* In DevOps and system administration, it is often necessary to **audit installed software** for security compliance, patch management, and inventory tracking.
* Windows stores installed application details in the **registry under Uninstall paths**.
* PowerShell can query these registry locations using `Get-ItemProperty` to retrieve application information such as **Name, Version, and Publisher**.

---

⚙️ **Purpose / How it works**

1. Query the Windows registry locations where installed applications are recorded.
2. Extract properties like **DisplayName, DisplayVersion, and Publisher**.
3. Filter out entries without application names.
4. Display the results.

Main registry paths used:

```text
HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall
HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
```

---

🧩 **PowerShell Script**

```powershell
# Registry paths for installed applications
$paths = @(
"HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
"HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

# Get installed applications
Get-ItemProperty $paths |
Where-Object { $_.DisplayName } |
Select-Object DisplayName, DisplayVersion, Publisher
```

---

🧩 **Example Output**

```
DisplayName              DisplayVersion   Publisher
-----------              --------------   ---------
Google Chrome            122.0.6261.95    Google LLC
Microsoft Edge           122.0.2365.66    Microsoft Corporation
7-Zip 23.01              23.01            Igor Pavlov
```

---

🧩 **Formatted Table Output**

```powershell
Get-ItemProperty $paths |
Where-Object { $_.DisplayName } |
Select DisplayName, DisplayVersion, Publisher |
Sort-Object DisplayName |
Format-Table -AutoSize
```

---

🧩 **Export Installed Applications to CSV**

Useful for **asset inventory or compliance reports**.

```powershell
Get-ItemProperty $paths |
Where-Object { $_.DisplayName } |
Select DisplayName, DisplayVersion, Publisher |
Export-Csv "C:\Temp\installed-apps.csv" -NoTypeInformation
```

---

📋 **Key PowerShell Components**

| Command            | Purpose                       |
| ------------------ | ----------------------------- |
| `Get-ItemProperty` | Retrieves registry properties |
| `Where-Object`     | Filters unwanted entries      |
| `Select-Object`    | Displays specific columns     |
| `Sort-Object`      | Sorts output                  |
| `Export-Csv`       | Exports results to file       |

---

🧩 **DevOps Example (Software Compliance Check)**

```powershell
$apps = Get-ItemProperty $paths |
Where-Object { $_.DisplayName }

$apps | Where-Object { $_.DisplayName -like "*Java*" }
```

Used for:

* **software inventory automation**
* **security compliance checks**
* **patch management audits**

---

✅ **Best Practices**

* Query **both 32-bit and 64-bit registry paths** for complete results.
* Filter results using `Where-Object` to remove empty entries.
* Export results for **auditing and compliance documentation**.
* Avoid using `Win32_Product` WMI class because it can **trigger software repair operations**.

---

💡 **In short**

* Installed applications are stored in **Windows registry uninstall keys**.
* Use `Get-ItemProperty` to retrieve application details.
* Filter and display software name, version, and publisher for **system inventory and compliance checks**.

---
## Q30: Write a PowerShell script to check CPU and memory usage and display them in percentage

🧠 **Overview**

* Monitoring **CPU and memory usage** is critical for **server health checks, performance monitoring, and automation alerts** in DevOps environments.
* PowerShell can retrieve system metrics using **WMI/CIM classes** such as `Win32_Processor` and `Win32_OperatingSystem`.
* These values can be converted into **percentage-based usage** for easier monitoring and reporting.

---

⚙️ **Purpose / How it works**

1. Use `Get-CimInstance Win32_Processor` to get **CPU load percentage**.
2. Use `Get-CimInstance Win32_OperatingSystem` to retrieve **total and free memory**.
3. Calculate memory usage percentage using the formula:

```text
Memory Usage % = ((Total Memory - Free Memory) / Total Memory) × 100
```

4. Display CPU and memory usage.

---

🧩 **PowerShell Script**

```powershell
# Get CPU usage
$cpuUsage = (Get-CimInstance Win32_Processor).LoadPercentage

# Get memory details
$os = Get-CimInstance Win32_OperatingSystem

$totalMemory = $os.TotalVisibleMemorySize
$freeMemory  = $os.FreePhysicalMemory

# Calculate memory usage percentage
$memoryUsage = [math]::Round((($totalMemory - $freeMemory) / $totalMemory) * 100, 2)

# Display results
Write-Output "CPU Usage: $cpuUsage %"
Write-Output "Memory Usage: $memoryUsage %"
```

---

🧩 **Example Output**

```
CPU Usage: 18 %
Memory Usage: 62.45 %
```

---

🧩 **Formatted Output Version**

```powershell
$cpu = (Get-CimInstance Win32_Processor).LoadPercentage
$os = Get-CimInstance Win32_OperatingSystem

$total = $os.TotalVisibleMemorySize
$free  = $os.FreePhysicalMemory

$memUsage = [math]::Round((($total - $free) / $total) * 100, 2)

Write-Host "System Resource Usage"
Write-Host "---------------------"
Write-Host "CPU Usage   : $cpu %"
Write-Host "Memory Usage: $memUsage %"
```

---

📋 **Key PowerShell Components**

| Command                 | Purpose                      |
| ----------------------- | ---------------------------- |
| `Get-CimInstance`       | Retrieves system information |
| `Win32_Processor`       | CPU usage data               |
| `Win32_OperatingSystem` | Memory details               |
| `[math]::Round()`       | Rounds numeric values        |
| `LoadPercentage`        | Current CPU load             |

---

🧩 **DevOps Example (Basic Monitoring Script)**

```powershell
$cpu = (Get-CimInstance Win32_Processor).LoadPercentage
$os = Get-CimInstance Win32_OperatingSystem

$mem = [math]::Round((($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) /
                     $os.TotalVisibleMemorySize) * 100, 2)

if ($cpu -gt 80 -or $mem -gt 80) {
    Write-Output "WARNING: High system resource usage detected!"
}
```

Used for:

* **server monitoring scripts**
* **CI/CD agent health checks**
* **performance alerts**

---

🧩 **Export Metrics to Log File**

```powershell
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

"$timestamp | CPU: $cpu % | Memory: $memUsage %" |
Out-File "C:\Temp\system-metrics.log" -Append
```

---

✅ **Best Practices**

* Use `Get-CimInstance` instead of older `Get-WmiObject`.
* Log metrics periodically for **trend analysis**.
* Integrate scripts with **monitoring systems or scheduled tasks**.
* Add alerts if CPU or memory crosses **threshold values (e.g., 80%)**.

---

💡 **In short**

* Use `Get-CimInstance` to retrieve CPU and memory statistics.
* Calculate memory usage percentage using total and free memory values.
* Display or log the results for **system monitoring and automation health checks**.

---
## Q31: Write a PowerShell script to retrieve the last 10 error events from the **Application** event log

🧠 **Overview**

* Windows Event Logs record **system, application, and security events**, which are critical for **troubleshooting and monitoring production systems**.
* DevOps and system administrators frequently query event logs to **diagnose application failures, deployment issues, or service crashes**.
* PowerShell provides the `Get-WinEvent` cmdlet to efficiently retrieve event log entries.

---

⚙️ **Purpose / How it works**

1. Query the **Application event log** using `Get-WinEvent`.
2. Filter events with **Level = Error**.
3. Limit results to the **latest 10 entries** using `-MaxEvents`.
4. Display relevant details such as **TimeCreated, ProviderName, and Message**.

Error level mapping:

```text
1 → Critical
2 → Error
3 → Warning
4 → Information
```

---

🧩 **PowerShell Script**

```powershell
# Retrieve last 10 error events from Application log
Get-WinEvent -LogName Application -MaxEvents 10 |
Where-Object { $_.LevelDisplayName -eq "Error" } |
Select-Object TimeCreated, ProviderName, Id, Message
```

---

🧩 **Example Output**

```
TimeCreated           ProviderName      Id     Message
-----------           ------------      --     -------
04-03-2026 10:15:22   Application Error 1000   Faulting application name: app.exe
04-03-2026 09:55:10   .NET Runtime      1026   Application crashed due to exception
04-03-2026 09:30:45   MSSQLSERVER       17055  SQL Server error occurred
```

---

🧩 **Optimized Version (Using FilterHashtable)**

More efficient for **large event logs**.

```powershell
Get-WinEvent -FilterHashtable @{
    LogName = "Application"
    Level   = 2
} -MaxEvents 10 |
Select TimeCreated, ProviderName, Id, Message
```

---

🧩 **Formatted Table Output**

```powershell
Get-WinEvent -FilterHashtable @{LogName="Application"; Level=2} -MaxEvents 10 |
Select TimeCreated, ProviderName, Id |
Format-Table -AutoSize
```

---

📋 **Key PowerShell Commands**

| Command         | Purpose                      |
| --------------- | ---------------------------- |
| `Get-WinEvent`  | Retrieves Windows event logs |
| `-LogName`      | Specifies log source         |
| `-MaxEvents`    | Limits number of results     |
| `Where-Object`  | Filters events               |
| `Select-Object` | Displays specific fields     |

---

🧩 **DevOps Example (Automated Error Monitoring)**

```powershell
$errors = Get-WinEvent -FilterHashtable @{LogName="Application"; Level=2} -MaxEvents 10

foreach ($event in $errors) {
    Write-Output "$($event.TimeCreated) - $($event.ProviderName) - EventID: $($event.Id)"
}
```

Used for:

* **server troubleshooting**
* **deployment failure analysis**
* **application crash monitoring**

---

🧩 **Export Errors to CSV Report**

```powershell
Get-WinEvent -FilterHashtable @{LogName="Application"; Level=2} -MaxEvents 10 |
Select TimeCreated, ProviderName, Id, Message |
Export-Csv "C:\Temp\application-errors.csv" -NoTypeInformation
```

---

✅ **Best Practices**

* Use `Get-WinEvent` instead of `Get-EventLog` (better performance).
* Use **FilterHashtable** for faster queries on large logs.
* Export error logs for **incident analysis and compliance reporting**.
* Automate log checks using **scheduled tasks or monitoring systems**.

---

💡 **In short**

* `Get-WinEvent` retrieves Windows event logs.
* Filter **Application log errors (Level = 2)**.
* Limit results to the **last 10 events** for quick troubleshooting.

---
## Q32: Write a PowerShell script to monitor a specific event log for new error entries and send an email alert when detected

🧠 **Overview**

* In production environments, **event log monitoring** helps detect application failures, service crashes, or security issues early.
* PowerShell can monitor Windows event logs using `Get-WinEvent` and trigger alerts when **new error entries appear**.
* Email alerts enable **proactive incident response**, commonly used in **DevOps monitoring scripts, server health checks, and automated operations alerts**.

---

⚙️ **Purpose / How it works**

1. Define the **event log to monitor** (e.g., `Application`).
2. Track the **last checked time**.
3. Retrieve new events using `Get-WinEvent`.
4. Filter events with **Level = Error (2)**.
5. If errors exist → send email alert using `Send-MailMessage`.

Event level reference:

```text
1 → Critical
2 → Error
3 → Warning
4 → Information
```

---

🧩 **PowerShell Script**

```powershell
# Event log to monitor
$logName = "Application"

# Email settings
$smtpServer = "smtp.example.com"
$from = "monitor@example.com"
$to = "admin@example.com"
$subject = "ALERT: New Error Detected in Application Event Log"

# Get events from last 5 minutes
$startTime = (Get-Date).AddMinutes(-5)

$events = Get-WinEvent -FilterHashtable @{
    LogName   = $logName
    Level     = 2
    StartTime = $startTime
}

if ($events) {

    $body = $events | Select TimeCreated, ProviderName, Id, Message |
    Out-String

    Send-MailMessage -From $from `
                     -To $to `
                     -Subject $subject `
                     -Body $body `
                     -SmtpServer $smtpServer

    Write-Output "Alert email sent."
}
else {

    Write-Output "No new errors detected."
}
```

---

🧩 **Example Email Alert**

```
Subject: ALERT: New Error Detected in Application Event Log

TimeCreated           ProviderName       Id     Message
-----------           ------------       --     -------
04-03-2026 11:30:12   Application Error  1000   Application crashed unexpectedly
```

---

🧩 **Continuous Monitoring Version (Loop)**

```powershell
while ($true) {

    $events = Get-WinEvent -FilterHashtable @{
        LogName="Application"
        Level=2
        StartTime=(Get-Date).AddMinutes(-1)
    }

    if ($events) {
        Send-MailMessage -From $from -To $to -Subject $subject -Body ($events | Out-String) -SmtpServer $smtpServer
    }

    Start-Sleep -Seconds 60
}
```

This checks logs **every 60 seconds**.

---

📋 **Key PowerShell Commands**

| Command            | Purpose                                 |
| ------------------ | --------------------------------------- |
| `Get-WinEvent`     | Retrieves Windows event logs            |
| `FilterHashtable`  | Efficient event filtering               |
| `Send-MailMessage` | Sends email notifications               |
| `Start-Sleep`      | Delays script execution                 |
| `Out-String`       | Converts objects to text for email body |

---

🧩 **DevOps Example (Production Monitoring)**

```powershell
$errors = Get-WinEvent -FilterHashtable @{
LogName="Application"
Level=2
StartTime=(Get-Date).AddMinutes(-10)
}

if ($errors.Count -gt 5) {
    Write-Output "Multiple errors detected - escalate incident"
}
```

Used for:

* **application monitoring**
* **automated incident detection**
* **production alerting systems**

---

🧩 **Export Errors for Investigation**

```powershell
$events | Export-Csv "C:\Logs\application-errors.csv" -NoTypeInformation
```

---

✅ **Best Practices**

* Use **FilterHashtable** for better performance.
* Avoid sending **too many alerts** by setting thresholds.
* Store event results in **log files for incident analysis**.
* Integrate with monitoring tools like **Prometheus, Splunk, or ELK**.

---

💡 **In short**

* Monitor Windows event logs using `Get-WinEvent`.
* Detect new **error events** in the Application log.
* Send **email alerts automatically** when errors appear for proactive monitoring.

----
## Q33: Write a PowerShell script to export event logs (Application, System, Security) to CSV files with timestamps

🧠 **Overview**

* Windows Event Logs contain critical data for **system troubleshooting, security auditing, and incident investigations**.
* Exporting logs regularly helps maintain **historical records and compliance reports**.
* PowerShell can retrieve logs using `Get-WinEvent` and export them to **CSV files with timestamps**, making them easy to analyze or import into monitoring tools.

---

⚙️ **Purpose / How it works**

1. Define the **event logs to export** (`Application`, `System`, `Security`).
2. Generate a **timestamp** for the file name.
3. Retrieve log entries using `Get-WinEvent`.
4. Select important fields such as **TimeCreated, ProviderName, EventId, LevelDisplayName, Message**.
5. Export the data to **CSV files** using `Export-Csv`.

---

🧩 **PowerShell Script**

```powershell
# Event logs to export
$logs = @("Application","System","Security")

# Output directory
$outputPath = "C:\Temp\EventLogs"

# Create directory if it doesn't exist
if (!(Test-Path $outputPath)) {
    New-Item -ItemType Directory -Path $outputPath
}

# Generate timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

foreach ($log in $logs) {

    $file = "$outputPath\$log-Log-$timestamp.csv"

    Get-WinEvent -LogName $log |
    Select-Object TimeCreated, ProviderName, Id, LevelDisplayName, Message |
    Export-Csv $file -NoTypeInformation

    Write-Output "Exported $log log to $file"
}
```

---

🧩 **Example Output Files**

```text
C:\Temp\EventLogs\Application-Log-2026-03-04_12-30-10.csv
C:\Temp\EventLogs\System-Log-2026-03-04_12-30-10.csv
C:\Temp\EventLogs\Security-Log-2026-03-04_12-30-10.csv
```

---

🧩 **Example CSV Content**

```text
TimeCreated,ProviderName,Id,LevelDisplayName,Message
2026-03-04 10:15:22,Application Error,1000,Error,Faulting application name: app.exe
2026-03-04 09:55:10,.NET Runtime,1026,Error,Application crashed due to exception
```

---

📋 **Key PowerShell Commands**

| Command         | Purpose                      |
| --------------- | ---------------------------- |
| `Get-WinEvent`  | Retrieves Windows event logs |
| `Select-Object` | Extracts relevant fields     |
| `Export-Csv`    | Saves output to CSV file     |
| `Get-Date`      | Generates timestamp          |
| `Test-Path`     | Checks if directory exists   |
| `New-Item`      | Creates directories          |

---

🧩 **DevOps Example (Daily Log Backup Script)**

```powershell
$timestamp = Get-Date -Format "yyyyMMdd"

Get-WinEvent -LogName System -MaxEvents 500 |
Select TimeCreated, Id, LevelDisplayName |
Export-Csv "C:\Logs\system-log-$timestamp.csv" -NoTypeInformation
```

Used for:

* **incident investigation**
* **log archival**
* **security auditing**
* **compliance reporting**

---

🧩 **Scheduled Export Example**

Run this script using **Windows Task Scheduler** to export logs daily:

```powershell
powershell.exe -File export-eventlogs.ps1
```

---

✅ **Best Practices**

* Limit logs using `-MaxEvents` or **time filters** for large environments.
* Store exports in **central log storage** or backup location.
* Automate exports using **scheduled tasks or monitoring systems**.
* Rotate logs regularly to avoid excessive disk usage.

---

💡 **In short**

* Use `Get-WinEvent` to retrieve logs from **Application, System, and Security**.
* Add timestamps using `Get-Date` for unique file names.
* Export results to CSV using `Export-Csv` for **log analysis and compliance tracking**.

----
## Q34: Write a PowerShell script to count the number of **warning and error events** in the **System log** from the last **24 hours**

🧠 **Overview**

* Windows **System event logs** record important system-level events such as hardware issues, driver failures, and service problems.
* Monitoring the **number of warning and error events** helps administrators quickly identify potential system instability.
* PowerShell can query logs using `Get-WinEvent` and filter events by **Level and time range**, which is useful for **automated monitoring and health reports**.

---

⚙️ **Purpose / How it works**

1. Define the **time range** (last 24 hours).
2. Use `Get-WinEvent` to retrieve events from the **System log**.
3. Filter events where:

   * Level **2 → Error**
   * Level **3 → Warning**
4. Count the results using `.Count`.
5. Display the totals.

Event levels:

```text
1 → Critical
2 → Error
3 → Warning
4 → Information
```

---

🧩 **PowerShell Script**

```powershell
# Time range - last 24 hours
$startTime = (Get-Date).AddHours(-24)

# Get System log events from last 24 hours
$events = Get-WinEvent -FilterHashtable @{
    LogName   = "System"
    StartTime = $startTime
}

# Count warning and error events
$errorCount = ($events | Where-Object { $_.Level -eq 2 }).Count
$warningCount = ($events | Where-Object { $_.Level -eq 3 }).Count

# Display results
Write-Output "System Log Event Summary (Last 24 Hours)"
Write-Output "----------------------------------------"
Write-Output "Errors   : $errorCount"
Write-Output "Warnings : $warningCount"
```

---

🧩 **Example Output**

```
System Log Event Summary (Last 24 Hours)
----------------------------------------
Errors   : 12
Warnings : 5
```

---

🧩 **Optimized Version (Efficient Filtering)**

Instead of filtering twice, query only required levels.

```powershell
$startTime = (Get-Date).AddHours(-24)

$events = Get-WinEvent -FilterHashtable @{
    LogName   = "System"
    StartTime = $startTime
    Level     = @(2,3)
}

$errorCount = ($events | Where-Object Level -eq 2).Count
$warningCount = ($events | Where-Object Level -eq 3).Count

Write-Output "Errors: $errorCount"
Write-Output "Warnings: $warningCount"
```

---

📋 **Key PowerShell Commands**

| Command           | Purpose                      |
| ----------------- | ---------------------------- |
| `Get-WinEvent`    | Retrieves Windows event logs |
| `FilterHashtable` | Efficient log filtering      |
| `Where-Object`    | Filters objects by condition |
| `.Count`          | Counts matching events       |
| `Get-Date`        | Generates time ranges        |

---

🧩 **DevOps Example (System Health Monitoring)**

```powershell
$errors = ($events | Where Level -eq 2).Count

if ($errors -gt 10) {
    Write-Output "ALERT: High number of system errors detected!"
}
```

Used for:

* **server health monitoring**
* **incident detection**
* **infrastructure reliability checks**

---

🧩 **Export Results to Report**

```powershell
[PSCustomObject]@{
    Timestamp = Get-Date
    Errors    = $errorCount
    Warnings  = $warningCount
} | Export-Csv "C:\Temp\system-event-summary.csv" -NoTypeInformation -Append
```

---

✅ **Best Practices**

* Use `FilterHashtable` instead of `Where-Object` when possible for **better performance**.
* Monitor logs regularly using **scheduled scripts or monitoring systems**.
* Trigger alerts if event counts exceed **defined thresholds**.

---

💡 **In short**

* Use `Get-WinEvent` to query the **System log**.
* Filter events from the **last 24 hours** with Level **Error (2)** and **Warning (3)**.
* Count them to produce a **quick system health summary**.

----
## Q35: Write a PowerShell script to clear all event logs on a local machine after backing them up

🧠 **Overview**

* Windows Event Logs grow over time and may consume disk space or make troubleshooting difficult.
* In system administration and DevOps operations, it is common to **backup event logs before clearing them** to preserve historical records for **auditing, compliance, and incident investigation**.
* PowerShell allows exporting logs using `wevtutil` or `Get-WinEvent`, then clearing them safely using `Clear-EventLog` or `wevtutil cl`.

---

⚙️ **Purpose / How it works**

1. Define a **backup directory**.
2. Generate a **timestamp** for unique backup files.
3. Retrieve all event logs using `Get-WinEvent -ListLog`.
4. Export each log to `.evtx` file using `wevtutil epl`.
5. Clear the log using `wevtutil cl`.

Workflow:

```text
List Logs → Backup Logs → Clear Logs
```

---

🧩 **PowerShell Script**

```powershell
# Backup directory
$backupPath = "C:\Temp\EventLogBackup"

# Create directory if it does not exist
if (!(Test-Path $backupPath)) {
    New-Item -ItemType Directory -Path $backupPath
}

# Timestamp for backup files
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# Get all event logs
$logs = Get-WinEvent -ListLog *

foreach ($log in $logs) {

    $logName = $log.LogName
    $backupFile = "$backupPath\$logName-$timestamp.evtx"

    try {

        # Backup event log
        wevtutil epl "$logName" "$backupFile"

        # Clear event log
        wevtutil cl "$logName"

        Write-Output "Backed up and cleared log: $logName"

    }
    catch {

        Write-Output "Failed to process log: $logName"
    }
}
```

---

🧩 **Example Backup Files**

```
C:\Temp\EventLogBackup\Application-2026-03-04_14-20-15.evtx
C:\Temp\EventLogBackup\System-2026-03-04_14-20-15.evtx
C:\Temp\EventLogBackup\Security-2026-03-04_14-20-15.evtx
```

---

📋 **Key PowerShell / Windows Commands**

| Command                 | Purpose                    |
| ----------------------- | -------------------------- |
| `Get-WinEvent -ListLog` | Lists all event logs       |
| `wevtutil epl`          | Exports event logs         |
| `wevtutil cl`           | Clears event logs          |
| `Test-Path`             | Checks directory existence |
| `New-Item`              | Creates directory          |
| `Get-Date`              | Generates timestamp        |

---

🧩 **DevOps Example (Log Maintenance Script)**

```powershell
$timestamp = Get-Date -Format "yyyyMMdd"

wevtutil epl Application "C:\Logs\Application-$timestamp.evtx"
wevtutil cl Application
```

Used for:

* **log rotation automation**
* **server maintenance tasks**
* **system cleanup operations**

---

🧩 **Schedule the Script**

Run periodically using **Windows Task Scheduler**:

```
powershell.exe -File clear-eventlogs.ps1
```

---

⚠️ **Important Notes**

* Administrator privileges are required to **backup and clear logs**.
* Security logs may have **restricted access** depending on system policy.
* Always verify backups before clearing logs.

---

✅ **Best Practices**

* Always **backup logs before clearing them**.
* Store backups in **secure centralized storage**.
* Avoid clearing logs frequently in environments requiring **audit compliance**.
* Monitor backup directory size to prevent disk overflow.

---

💡 **In short**

* Use `Get-WinEvent` to list logs.
* Backup logs using `wevtutil epl`.
* Clear logs using `wevtutil cl` after backup.
* This approach ensures **safe event log maintenance and compliance tracking**.

----
## Q36: Write a PowerShell script to create a new **Active Directory user** with specified properties (name, department, email)

🧠 **Overview**

* In enterprise environments, **Active Directory (AD)** manages user identities, authentication, and access control.
* DevOps and system administrators often automate **user provisioning** using PowerShell to reduce manual work and enforce consistent configurations.
* PowerShell provides the **ActiveDirectory module** with cmdlets like `New-ADUser` to create users and assign properties such as **department, email, and login credentials**.

---

⚙️ **Purpose / How it works**

1. Import the **Active Directory module**.
2. Define user details such as **name, department, email, and password**.
3. Use `New-ADUser` to create the user account.
4. Enable the account and set the password.

Requirements:

```text
- ActiveDirectory PowerShell module
- Domain admin or delegated permissions
- Target OU path
```

---

🧩 **PowerShell Script**

```powershell
# Import Active Directory module
Import-Module ActiveDirectory

# User properties
$firstName = "John"
$lastName = "Doe"
$username = "jdoe"
$department = "IT"
$email = "jdoe@example.com"
$password = ConvertTo-SecureString "P@ssw0rd123" -AsPlainText -Force

# Create AD user
New-ADUser `
-Name "$firstName $lastName" `
-GivenName $firstName `
-Surname $lastName `
-SamAccountName $username `
-UserPrincipalName "$username@example.com" `
-EmailAddress $email `
-Department $department `
-AccountPassword $password `
-Enabled $true `
-Path "OU=Users,DC=example,DC=com"

Write-Output "Active Directory user $username created successfully."
```

---

🧩 **Example Output**

```
Active Directory user jdoe created successfully.
```

---

📋 **Key `New-ADUser` Parameters**

| Parameter            | Purpose                           |
| -------------------- | --------------------------------- |
| `-Name`              | Full display name                 |
| `-SamAccountName`    | Logon name                        |
| `-UserPrincipalName` | User login format (user@domain)   |
| `-Department`        | Department attribute              |
| `-EmailAddress`      | User email                        |
| `-AccountPassword`   | Sets user password                |
| `-Enabled`           | Enables the account               |
| `-Path`              | Organizational Unit (OU) location |

---

🧩 **Version Using Script Parameters**

Useful for **automation pipelines or bulk user creation**.

```powershell
param(
    [string]$Name,
    [string]$Department,
    [string]$Email
)

$password = ConvertTo-SecureString "P@ssw0rd123" -AsPlainText -Force

New-ADUser -Name $Name `
           -Department $Department `
           -EmailAddress $Email `
           -AccountPassword $password `
           -Enabled $true
```

---

🧩 **DevOps Example (Bulk User Creation from CSV)**

```powershell
Import-Csv "users.csv" | ForEach-Object {

New-ADUser `
-Name $_.Name `
-SamAccountName $_.Username `
-Department $_.Department `
-EmailAddress $_.Email `
-AccountPassword (ConvertTo-SecureString "P@ssw0rd123" -AsPlainText -Force) `
-Enabled $true
}
```

Example CSV:

```
Name,Username,Department,Email
John Doe,jdoe,IT,jdoe@example.com
Jane Smith,jsmith,HR,jsmith@example.com
```

---

✅ **Best Practices**

* Always create users in the **correct Organizational Unit (OU)**.
* Use **secure passwords and password policies**.
* Avoid hardcoding passwords in production scripts.
* Use **CSV-based provisioning for bulk user creation**.
* Assign **groups and roles after account creation**.

---

💡 **In short**

* Use the **ActiveDirectory module** and `New-ADUser` cmdlet.
* Provide properties like **name, department, email, and password**.
* Enable the account and place it in the appropriate **OU** for automated user provisioning.

---
## Q37: Write a PowerShell script to list all users in a specific **Active Directory Organizational Unit (OU)**

🧠 **Overview**

* In enterprise environments, administrators often need to **retrieve all users from a specific Organizational Unit (OU)** for reporting, auditing, or automation tasks.
* PowerShell’s **ActiveDirectory module** provides the `Get-ADUser` cmdlet, which allows querying users based on filters and OU paths.
* This is commonly used in **identity management automation, compliance audits, and DevOps user management scripts**.

---

⚙️ **Purpose / How it works**

1. Import the **ActiveDirectory module**.
2. Specify the **OU distinguished name (DN)**.
3. Use `Get-ADUser` with `-SearchBase` to query users only within that OU.
4. Select relevant user properties such as **Name, SamAccountName, Department, Email**.

OU path example:

```text
OU=Employees,DC=example,DC=com
```

---

🧩 **PowerShell Script**

```powershell
# Import Active Directory module
Import-Module ActiveDirectory

# Specify OU path
$ouPath = "OU=Employees,DC=example,DC=com"

# Get users from the OU
Get-ADUser -SearchBase $ouPath -Filter * -Properties Department, EmailAddress |
Select-Object Name, SamAccountName, Department, EmailAddress
```

---

🧩 **Example Output**

```
Name           SamAccountName   Department   EmailAddress
----           --------------   ----------   ------------
John Doe       jdoe             IT           jdoe@example.com
Jane Smith     jsmith           HR           jsmith@example.com
Mike Johnson   mjohnson         Finance      mjohnson@example.com
```

---

🧩 **Formatted Table Output**

```powershell
Get-ADUser -SearchBase $ouPath -Filter * -Properties Department, EmailAddress |
Select Name, SamAccountName, Department, EmailAddress |
Format-Table -AutoSize
```

---

📋 **Key `Get-ADUser` Parameters**

| Parameter       | Purpose                            |
| --------------- | ---------------------------------- |
| `-SearchBase`   | Specifies the OU to search         |
| `-Filter *`     | Retrieves all users                |
| `-Properties`   | Retrieves additional AD attributes |
| `Select-Object` | Displays specific user fields      |

---

🧩 **Export Users to CSV Report**

Useful for **HR audits or access reviews**.

```powershell
Get-ADUser -SearchBase $ouPath -Filter * -Properties Department, EmailAddress |
Select Name, SamAccountName, Department, EmailAddress |
Export-Csv "C:\Temp\OU-users.csv" -NoTypeInformation
```

---

🧩 **DevOps Example (User Audit Script)**

```powershell
$users = Get-ADUser -SearchBase $ouPath -Filter *

foreach ($user in $users) {
    Write-Output "User found: $($user.SamAccountName)"
}
```

Used for:

* **identity audits**
* **bulk access management**
* **user inventory automation**

---

✅ **Best Practices**

* Always specify `-SearchBase` to **limit queries to a specific OU**.
* Use `-Properties` only for required attributes to **improve performance**.
* Export results for **compliance and auditing reports**.
* Use filters instead of `*` when working with **large AD environments**.

---

💡 **In short**

* Use `Get-ADUser` with `-SearchBase` to query users in a specific OU.
* Retrieve attributes like **Name, SamAccountName, Department, Email**.
* Useful for **user audits, reporting, and automation in AD environments**.

---
## Q38: Write a PowerShell script to disable all AD user accounts that have not logged in for more than **90 days**

🧠 **Overview**

* In enterprise environments, inactive accounts can pose **security risks** because unused credentials may be exploited.
* Administrators often automate **account lifecycle management** to disable accounts that have not logged in for a defined period (e.g., 90 days).
* PowerShell’s **ActiveDirectory module** allows querying user login attributes (`LastLogonDate`) and disabling accounts using `Disable-ADAccount`.

---

⚙️ **Purpose / How it works**

1. Define the **inactive period (90 days)**.
2. Retrieve AD users using `Get-ADUser`.
3. Filter users whose `LastLogonDate` is older than the cutoff date.
4. Disable those accounts using `Disable-ADAccount`.
5. Optionally log the disabled users.

Cutoff date logic:

```text
Cutoff Date = Current Date - 90 days
```

---

🧩 **PowerShell Script**

```powershell
# Import Active Directory module
Import-Module ActiveDirectory

# Define cutoff date (90 days ago)
$cutoffDate = (Get-Date).AddDays(-90)

# Find inactive users
$inactiveUsers = Get-ADUser -Filter * -Properties LastLogonDate |
Where-Object { $_.LastLogonDate -lt $cutoffDate }

# Disable accounts
foreach ($user in $inactiveUsers) {

    Disable-ADAccount -Identity $user.SamAccountName

    Write-Output "Disabled account: $($user.SamAccountName)"
}
```

---

🧩 **Example Output**

```
Disabled account: jdoe
Disabled account: mjohnson
Disabled account: asmith
```

---

🧩 **Preview Mode (Safe Check Before Disabling)**

Always check accounts first in production environments.

```powershell
$cutoffDate = (Get-Date).AddDays(-90)

Get-ADUser -Filter * -Properties LastLogonDate |
Where-Object { $_.LastLogonDate -lt $cutoffDate } |
Select Name, SamAccountName, LastLogonDate
```

---

📋 **Key PowerShell Commands**

| Command             | Purpose                    |
| ------------------- | -------------------------- |
| `Get-ADUser`        | Retrieves AD user accounts |
| `LastLogonDate`     | Last login timestamp       |
| `Where-Object`      | Filters inactive accounts  |
| `Disable-ADAccount` | Disables user account      |
| `Get-Date`          | Calculates cutoff date     |

---

🧩 **Export Disabled Users to Report**

Useful for **audit compliance**.

```powershell
$inactiveUsers |
Select Name, SamAccountName, LastLogonDate |
Export-Csv "C:\Temp\disabled-users.csv" -NoTypeInformation
```

---

🧩 **DevOps / IT Operations Example**

```powershell
$inactive = Get-ADUser -Filter * -Properties LastLogonDate |
Where-Object { $_.LastLogonDate -lt (Get-Date).AddDays(-90) }

if ($inactive.Count -gt 0) {
    Write-Output "Inactive accounts detected: $($inactive.Count)"
}
```

Used for:

* **identity lifecycle automation**
* **security compliance enforcement**
* **inactive account cleanup**

---

⚠️ **Important Notes**

* `LastLogonDate` may not update instantly across domain controllers.
* Ensure **service accounts** are excluded before disabling users.

Example exclusion:

```powershell
Where-Object { $_.LastLogonDate -lt $cutoffDate -and $_.Enabled -eq $true }
```

---

✅ **Best Practices**

* Always run a **preview report first** before disabling accounts.
* Exclude **service accounts and system accounts**.
* Log disabled accounts for **audit and compliance**.
* Automate execution using **scheduled tasks or identity governance workflows**.

---

💡 **In short**

* Use `Get-ADUser` with `LastLogonDate` to detect inactive accounts.
* Compare login time with **current date - 90 days**.
* Disable accounts using `Disable-ADAccount` to improve **security and compliance**.

---
## Q39: Write a PowerShell script to reset passwords for multiple users from a CSV file containing usernames

🧠 **Overview**

* In enterprise environments, administrators often need to **reset passwords for multiple users simultaneously**, such as during security incidents, onboarding changes, or password policy enforcement.
* PowerShell can automate this process using the **ActiveDirectory module** by importing usernames from a CSV file and resetting their passwords with `Set-ADAccountPassword`.
* This approach is commonly used for **bulk user management, identity lifecycle automation, and security remediation tasks**.

---

⚙️ **Purpose / How it works**

1. Prepare a **CSV file containing usernames**.
2. Import the CSV using `Import-Csv`.
3. Loop through each user using `ForEach-Object`.
4. Reset the password using `Set-ADAccountPassword`.
5. Optionally force users to **change password at next login**.

Example workflow:

```text
CSV File → Import-Csv → Loop Users → Reset Password
```

---

🧩 **Example CSV File (`users.csv`)**

```csv
Username
jdoe
jsmith
mjohnson
```

---

🧩 **PowerShell Script**

```powershell
# Import Active Directory module
Import-Module ActiveDirectory

# CSV file path
$csvFile = "C:\Temp\users.csv"

# New password
$newPassword = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force

# Import users and reset passwords
Import-Csv $csvFile | ForEach-Object {

    $username = $_.Username

    Set-ADAccountPassword -Identity $username `
                          -NewPassword $newPassword `
                          -Reset

    # Force password change at next login
    Set-ADUser -Identity $username -ChangePasswordAtLogon $true

    Write-Output "Password reset for user: $username"
}
```

---

🧩 **Example Output**

```
Password reset for user: jdoe
Password reset for user: jsmith
Password reset for user: mjohnson
```

---

📋 **Key PowerShell Commands**

| Command                  | Purpose                                      |
| ------------------------ | -------------------------------------------- |
| `Import-Csv`             | Reads user data from CSV file                |
| `ForEach-Object`         | Loops through each user                      |
| `Set-ADAccountPassword`  | Resets user password                         |
| `Set-ADUser`             | Updates user account properties              |
| `ConvertTo-SecureString` | Converts plaintext password to secure format |

---

🧩 **Improved Version with Error Handling**

```powershell
Import-Csv $csvFile | ForEach-Object {

    try {

        Set-ADAccountPassword -Identity $_.Username -NewPassword $newPassword -Reset
        Set-ADUser -Identity $_.Username -ChangePasswordAtLogon $true

        Write-Output "Password reset successful: $($_.Username)"

    } catch {

        Write-Output "Failed to reset password: $($_.Username)"
    }
}
```

---

🧩 **DevOps / IT Automation Example**

```powershell
$users = Import-Csv "users.csv"

foreach ($user in $users) {

    Set-ADAccountPassword -Identity $user.Username `
    -NewPassword (ConvertTo-SecureString "Temp@1234" -AsPlainText -Force) `
    -Reset
}
```

Used for:

* **security incident response**
* **bulk password resets**
* **identity management automation**

---

⚠️ **Security Considerations**

* Avoid storing passwords **in plain text scripts**.
* Use **secure vaults (Azure Key Vault, HashiCorp Vault)** for production automation.
* Ensure only **authorized administrators** can execute the script.

---

✅ **Best Practices**

* Always test scripts in a **non-production environment first**.
* Log reset operations for **audit compliance**.
* Force users to **change password at next login**.
* Use **secure password policies**.

---

💡 **In short**

* Store usernames in a CSV file.
* Import them using `Import-Csv`.
* Reset passwords using `Set-ADAccountPassword`.
* Optionally force users to **change password at next login for security compliance**.

---
## Q40: Write a PowerShell script to export all **Active Directory group members** to a CSV file

🧠 **Overview**

* In enterprise environments, administrators often need to **audit group memberships** to verify access permissions, perform compliance checks, or review security roles.
* PowerShell’s **ActiveDirectory module** provides `Get-ADGroupMember` and `Get-ADUser` to retrieve group members and their attributes.
* Exporting the results to a **CSV file** allows easy analysis in tools like Excel or integration with security reports.

---

⚙️ **Purpose / How it works**

1. Import the **ActiveDirectory module**.
2. Specify the **target AD group name**.
3. Retrieve group members using `Get-ADGroupMember`.
4. Fetch additional attributes (e.g., email, department) using `Get-ADUser`.
5. Export results to a CSV file using `Export-Csv`.

Workflow:

```text
AD Group → Get Members → Select Attributes → Export to CSV
```

---

🧩 **PowerShell Script**

```powershell
# Import Active Directory module
Import-Module ActiveDirectory

# AD group name
$groupName = "IT_Admins"

# Output CSV file
$outputFile = "C:\Temp\AD_Group_Members.csv"

# Get group members and export
Get-ADGroupMember -Identity $groupName -Recursive |
Where-Object { $_.objectClass -eq "user" } |
ForEach-Object {

    Get-ADUser $_.SamAccountName -Properties DisplayName, EmailAddress, Department |
    Select-Object DisplayName, SamAccountName, EmailAddress, Department

} | Export-Csv $outputFile -NoTypeInformation

Write-Output "Group members exported to $outputFile"
```

---

🧩 **Example Output (CSV)**

```text
DisplayName,SamAccountName,EmailAddress,Department
John Doe,jdoe,jdoe@example.com,IT
Jane Smith,jsmith,jsmith@example.com,Security
Mike Johnson,mjohnson,mjohnson@example.com,Infrastructure
```

---

📋 **Key PowerShell Commands**

| Command             | Purpose                          |
| ------------------- | -------------------------------- |
| `Get-ADGroupMember` | Retrieves members of an AD group |
| `-Recursive`        | Includes nested group members    |
| `Get-ADUser`        | Retrieves user details           |
| `Select-Object`     | Chooses attributes for export    |
| `Export-Csv`        | Exports data to CSV file         |

---

🧩 **Export Members for Multiple Groups**

```powershell
$groups = @("IT_Admins","HR_Team","Finance_Team")

foreach ($group in $groups) {

    Get-ADGroupMember $group -Recursive |
    Where-Object {$_.objectClass -eq "user"} |
    Select Name, SamAccountName |
    Export-Csv "C:\Temp\$group-members.csv" -NoTypeInformation
}
```

---

🧩 **DevOps / Security Audit Example**

```powershell
$admins = Get-ADGroupMember "Domain Admins" -Recursive

$admins | Select Name, SamAccountName |
Export-Csv "C:\Reports\DomainAdmins.csv" -NoTypeInformation
```

Used for:

* **access reviews**
* **security compliance audits**
* **identity governance reports**

---

⚠️ **Important Notes**

* Administrator permissions may be required to query certain groups.
* The `-Recursive` parameter ensures **nested group members are included**.

---

✅ **Best Practices**

* Always include **`-Recursive`** when auditing security groups.
* Export reports regularly for **security and compliance audits**.
* Store reports in **secure locations with restricted access**.
* Automate execution using **scheduled tasks or identity governance tools**.

---

💡 **In short**

* Use `Get-ADGroupMember` to retrieve group members.
* Use `Get-ADUser` to fetch additional user attributes.
* Export results using `Export-Csv` for **audit, reporting, and compliance**.

----
## Q41: Write a PowerShell script to ping a list of servers from a text file and display which are online and which are offline

🧠 **Overview**

* In infrastructure management and DevOps operations, administrators often need to **check connectivity to multiple servers** before deployments, patching, or monitoring tasks.
* PowerShell can read server names from a **text file**, ping them using `Test-Connection`, and report whether each server is **online or offline**.
* This is commonly used in **network health checks, environment validation, and monitoring automation**.

---

⚙️ **Purpose / How it works**

1. Store server names or IP addresses in a **text file**.
2. Read the file using `Get-Content`.
3. Loop through each server using `foreach`.
4. Use `Test-Connection` with `-Quiet` to check connectivity.
5. Display whether the server is **Online or Offline**.

Workflow:

```text
servers.txt → Get-Content → Loop Servers → Ping → Display Status
```

---

🧩 **Example Text File (`servers.txt`)**

```
server1
server2
192.168.1.10
google.com
```

---

🧩 **PowerShell Script**

```powershell
# Path to server list
$serverFile = "C:\Temp\servers.txt"

# Read servers from file
$servers = Get-Content $serverFile

foreach ($server in $servers) {

    if (Test-Connection -ComputerName $server -Count 1 -Quiet) {

        Write-Output "$server is ONLINE"

    } else {

        Write-Output "$server is OFFLINE"
    }
}
```

---

🧩 **Example Output**

```
server1 is ONLINE
server2 is OFFLINE
192.168.1.10 is ONLINE
google.com is ONLINE
```

---

📋 **Key PowerShell Commands**

| Command           | Purpose                                       |
| ----------------- | --------------------------------------------- |
| `Get-Content`     | Reads server names from file                  |
| `foreach`         | Iterates through server list                  |
| `Test-Connection` | Performs ping test                            |
| `-Count`          | Number of ping attempts                       |
| `-Quiet`          | Returns True/False instead of detailed output |

---

🧩 **Improved Version (Structured Output)**

Better for **automation and reporting**.

```powershell
$servers = Get-Content "C:\Temp\servers.txt"

foreach ($server in $servers) {

    $status = Test-Connection -ComputerName $server -Count 1 -Quiet

    [PSCustomObject]@{
        Server  = $server
        Status  = if ($status) { "Online" } else { "Offline" }
    }
}
```

---

🧩 **Export Results to CSV**

```powershell
$results | Export-Csv "C:\Temp\server-status.csv" -NoTypeInformation
```

Example CSV output:

```
Server,Status
server1,Online
server2,Offline
192.168.1.10,Online
```

---

🧩 **DevOps Example (Pre-Deployment Server Check)**

```powershell
$servers = Get-Content "servers.txt"

foreach ($s in $servers) {

    if (!(Test-Connection $s -Count 1 -Quiet)) {
        Write-Output "Deployment blocked: $s unreachable"
    }
}
```

Used for:

* **deployment readiness checks**
* **infrastructure monitoring**
* **network troubleshooting**

---

✅ **Best Practices**

* Store server lists in **external files or configuration management systems**.
* Use `-Quiet` for faster connectivity checks.
* Export results to **CSV or logs for monitoring dashboards**.
* Integrate with **CI/CD pipelines for environment validation**.

---

💡 **In short**

* Use `Get-Content` to read servers from a file.
* Use `Test-Connection` to ping each server.
* Display or export whether each server is **online or offline** for infrastructure health checks.

---
## Q42: Write a PowerShell script to retrieve IP configuration details (IP address, subnet mask, gateway) for all network adapters

🧠 **Overview**

* Network configuration details such as **IP address, subnet mask, and default gateway** are critical for troubleshooting connectivity issues and validating server network settings.
* PowerShell can retrieve this information using networking cmdlets like `Get-NetIPAddress` and `Get-NetIPConfiguration`.
* These commands are commonly used in **infrastructure diagnostics, automation scripts, and DevOps environment validation**.

---

⚙️ **Purpose / How it works**

1. Retrieve network adapter configuration using `Get-NetIPConfiguration`.
2. Extract relevant fields such as:

   * IP Address
   * Subnet Prefix Length (subnet mask)
   * Default Gateway
3. Display the results for all network adapters.

Workflow:

```text
Network Adapter → Get-NetIPConfiguration → Extract IP Details
```

---

🧩 **PowerShell Script**

```powershell
# Get network configuration details for all adapters

Get-NetIPConfiguration | ForEach-Object {

    [PSCustomObject]@{
        AdapterName = $_.InterfaceAlias
        IPAddress   = $_.IPv4Address.IPAddress
        SubnetMask  = $_.IPv4Address.PrefixLength
        Gateway     = $_.IPv4DefaultGateway.NextHop
    }
}
```

---

🧩 **Example Output**

```
AdapterName   IPAddress       SubnetMask   Gateway
-----------   ---------       ----------   -------
Ethernet      192.168.1.20    24           192.168.1.1
Wi-Fi         192.168.1.45    24           192.168.1.1
```

---

🧩 **Formatted Table Version**

```powershell
Get-NetIPConfiguration |
Select-Object InterfaceAlias,
              @{Name="IP Address";Expression={$_.IPv4Address.IPAddress}},
              @{Name="Subnet Mask";Expression={$_.IPv4Address.PrefixLength}},
              @{Name="Gateway";Expression={$_.IPv4DefaultGateway.NextHop}} |
Format-Table -AutoSize
```

---

📋 **Key PowerShell Commands**

| Command                  | Purpose                                 |
| ------------------------ | --------------------------------------- |
| `Get-NetIPConfiguration` | Retrieves network adapter configuration |
| `IPv4Address`            | Displays assigned IP address            |
| `PrefixLength`           | Shows subnet mask length                |
| `IPv4DefaultGateway`     | Shows default gateway                   |
| `Select-Object`          | Extracts specific properties            |

---

🧩 **Alternative (Using Get-NetIPAddress)**

```powershell
Get-NetIPAddress -AddressFamily IPv4 |
Select InterfaceAlias, IPAddress, PrefixLength
```

---

🧩 **DevOps Example (Network Validation Script)**

```powershell
$config = Get-NetIPConfiguration

foreach ($adapter in $config) {

    Write-Output "Adapter: $($adapter.InterfaceAlias)"
    Write-Output "IP Address: $($adapter.IPv4Address.IPAddress)"
    Write-Output "Gateway: $($adapter.IPv4DefaultGateway.NextHop)"
}
```

Used for:

* **server network troubleshooting**
* **environment validation scripts**
* **infrastructure automation diagnostics**

---

🧩 **Export Network Configuration to CSV**

```powershell
Get-NetIPConfiguration |
Select InterfaceAlias,
       @{Name="IP";Expression={$_.IPv4Address.IPAddress}},
       @{Name="Gateway";Expression={$_.IPv4DefaultGateway.NextHop}} |
Export-Csv "C:\Temp\network-config.csv" -NoTypeInformation
```

---

✅ **Best Practices**

* Use **Get-NetIPConfiguration** instead of older commands like `ipconfig` for automation.
* Filter by `-AddressFamily IPv4` when needed.
* Export configuration reports for **network audits or troubleshooting**.

---

💡 **In short**

* Use `Get-NetIPConfiguration` to retrieve network adapter details.
* Extract **IP address, subnet mask (prefix length), and gateway**.
* Useful for **network troubleshooting, infrastructure validation, and automation scripts**.

---
## Q43: Write a PowerShell script to test connectivity to a specific port on multiple remote servers

🧠 **Overview**

* In infrastructure and DevOps environments, it is often necessary to verify whether **specific ports (e.g., 22, 80, 443, 3389)** are reachable on remote servers.
* PowerShell provides the `Test-NetConnection` cmdlet to test **TCP connectivity to a specific port**.
* This is useful for **firewall validation, service availability checks, and pre-deployment environment verification**.

---

⚙️ **Purpose / How it works**

1. Define a list of **remote servers**.
2. Specify the **target port**.
3. Loop through each server using `foreach`.
4. Use `Test-NetConnection` to test connectivity.
5. Display whether the port is **Open or Closed**.

Workflow:

```text id="xszru7"
Server List → Loop → Test-NetConnection → Display Port Status
```

---

🧩 **PowerShell Script**

```powershell id="oyx9y4"
# List of servers
$servers = @("server1", "server2", "google.com")

# Port to test
$port = 443

foreach ($server in $servers) {

    $result = Test-NetConnection -ComputerName $server -Port $port -InformationLevel Quiet

    if ($result) {

        Write-Output "$server : Port $port is OPEN"

    } else {

        Write-Output "$server : Port $port is CLOSED"
    }
}
```

---

🧩 **Example Output**

```id="lnzwmo"
server1 : Port 443 is OPEN
server2 : Port 443 is CLOSED
google.com : Port 443 is OPEN
```

---

📋 **Key PowerShell Commands**

| Command                   | Purpose                      |
| ------------------------- | ---------------------------- |
| `Test-NetConnection`      | Tests network connectivity   |
| `-ComputerName`           | Target server                |
| `-Port`                   | Specific port to test        |
| `-InformationLevel Quiet` | Returns True/False           |
| `foreach`                 | Iterates through server list |

---

🧩 **Example with Multiple Ports**

```powershell id="xy1gq0"
$servers = @("server1","server2")
$ports = @(80,443,3389)

foreach ($server in $servers) {

    foreach ($port in $ports) {

        $status = Test-NetConnection $server -Port $port -InformationLevel Quiet

        Write-Output "$server - Port $port : $status"
    }
}
```

---

🧩 **Structured Output Version**

Better for **automation reports**.

```powershell id="rv0b1q"
foreach ($server in $servers) {

    $status = Test-NetConnection $server -Port $port -InformationLevel Quiet

    [PSCustomObject]@{
        Server = $server
        Port   = $port
        Status = if ($status) { "Open" } else { "Closed" }
    }
}
```

---

🧩 **Export Results to CSV**

```powershell id="pzn62q"
$results | Export-Csv "C:\Temp\port-check.csv" -NoTypeInformation
```

Example CSV:

```text id="fdm3y8"
Server,Port,Status
server1,443,Open
server2,443,Closed
```

---

🧩 **DevOps Example (Deployment Readiness Check)**

```powershell id="qv7p8m"
$server = "web-server"

if (!(Test-NetConnection $server -Port 443 -InformationLevel Quiet)) {

    Write-Output "Deployment blocked: HTTPS port unavailable"
}
```

Used for:

* **firewall validation**
* **service availability checks**
* **pre-deployment environment validation**

---

✅ **Best Practices**

* Use `Test-NetConnection` instead of manual tools like `telnet`.
* Test **critical ports (SSH, HTTP, HTTPS, RDP, DB)** before deployments.
* Export results to **CSV for monitoring dashboards**.
* Combine with **server health checks in automation pipelines**.

---

💡 **In short**

* Define server list and port number.
* Use `Test-NetConnection` to check TCP connectivity.
* Display whether each server’s port is **open or closed for network validation**.

---
## Q44: Write a PowerShell script using `Invoke-Command` to execute a command on multiple remote servers simultaneously

🧠 **Overview**

* In DevOps and system administration, administrators often need to **run commands across multiple servers at the same time** for tasks like patch checks, service management, or system diagnostics.
* PowerShell provides **PowerShell Remoting** with `Invoke-Command`, which allows commands to run **remotely and in parallel** on multiple systems.
* This approach is commonly used for **remote automation, infrastructure management, and configuration tasks**.

---

⚙️ **Purpose / How it works**

1. Define a list of **remote servers**.
2. Use `Invoke-Command` to run a script block (`{}`) remotely.
3. The command runs simultaneously on all servers using **PowerShell Remoting (WinRM)**.
4. Results from all servers are returned to the local console.

Requirements:

```text
- PowerShell Remoting enabled (Enable-PSRemoting)
- WinRM service running
- Administrative permissions on remote machines
```

---

🧩 **PowerShell Script**

```powershell
# List of remote servers
$servers = @("Server1", "Server2", "Server3")

# Execute command remotely
Invoke-Command -ComputerName $servers -ScriptBlock {

    # Example command: Get system uptime
    Get-CimInstance Win32_OperatingSystem |
    Select-Object CSName, LastBootUpTime

}
```

---

🧩 **Example Output**

```
CSName    LastBootUpTime
------    --------------
Server1   03-04-2026 09:12:10
Server2   03-04-2026 08:45:30
Server3   02-04-2026 23:15:50
```

---

🧩 **Example: Check Running Services on Multiple Servers**

```powershell
$servers = @("Server1","Server2")

Invoke-Command -ComputerName $servers -ScriptBlock {

    Get-Service | Where-Object {$_.Status -eq "Running"} |
    Select-Object Name, Status

}
```

---

📋 **Key PowerShell Components**

| Command           | Purpose                             |
| ----------------- | ----------------------------------- |
| `Invoke-Command`  | Executes commands on remote systems |
| `-ComputerName`   | Specifies target servers            |
| `-ScriptBlock`    | Command to run remotely             |
| `WinRM`           | Enables PowerShell remoting         |
| `Get-CimInstance` | Retrieves system information        |

---

🧩 **Using Credentials for Remote Execution**

```powershell
$servers = @("Server1","Server2")

$cred = Get-Credential

Invoke-Command -ComputerName $servers -Credential $cred -ScriptBlock {

    hostname
}
```

---

🧩 **Run Command in Parallel with Throttle Limit**

```powershell
Invoke-Command -ComputerName $servers -ScriptBlock { hostname } -ThrottleLimit 5
```

This controls the number of **simultaneous remote sessions**.

---

🧩 **DevOps Example (Check Disk Space on Servers)**

```powershell
$servers = @("app01","app02","db01")

Invoke-Command -ComputerName $servers -ScriptBlock {

    Get-PSDrive C |
    Select-Object Used, Free

}
```

Used for:

* **remote health checks**
* **patch verification**
* **configuration validation**
* **infrastructure automation**

---

✅ **Best Practices**

* Always ensure **PowerShell Remoting is enabled** (`Enable-PSRemoting`).
* Use **credential objects instead of hardcoded passwords**.
* Limit parallel execution using `-ThrottleLimit` for large server environments.
* Log results for **audit and troubleshooting**.

---

💡 **In short**

* `Invoke-Command` runs commands **remotely on multiple servers simultaneously**.
* Use `-ComputerName` with a list of servers and a `ScriptBlock`.
* Commonly used for **remote administration, monitoring, and DevOps automation**.

----
## Q45: Write a PowerShell script to retrieve installed **hotfixes/patches** from multiple remote computers and export to CSV

🧠 **Overview**

* In enterprise environments, administrators must track **installed patches (KB updates)** across servers to ensure systems are **secure and compliant**.
* PowerShell can retrieve installed hotfixes using `Get-HotFix` or `Get-CimInstance Win32_QuickFixEngineering`.
* By querying multiple remote machines and exporting the results to **CSV**, administrators can generate patch compliance reports.

---

⚙️ **Purpose / How it works**

1. Define a list of **remote computers**.
2. Use `Invoke-Command` or `Get-HotFix -ComputerName` to retrieve installed patches.
3. Collect details such as:

   * Computer name
   * HotFix ID
   * Description
   * Installed date
4. Export the results to a **CSV report**.

Workflow:

```text
Server List → Retrieve HotFix Data → Combine Results → Export CSV
```

---

🧩 **PowerShell Script**

```powershell
# List of remote computers
$computers = @("Server1","Server2","Server3")

# Output file
$outputFile = "C:\Temp\Installed-HotFixes.csv"

$results = foreach ($computer in $computers) {

    Get-HotFix -ComputerName $computer | Select-Object @{
        Name="ComputerName"; Expression={$computer}
    }, HotFixID, Description, InstalledOn

}

# Export results
$results | Export-Csv $outputFile -NoTypeInformation

Write-Output "Hotfix report exported to $outputFile"
```

---

🧩 **Example Output (CSV)**

```text
ComputerName,HotFixID,Description,InstalledOn
Server1,KB5030211,Security Update,04-03-2026
Server1,KB5029376,Cumulative Update,01-03-2026
Server2,KB5030211,Security Update,04-03-2026
```

---

📋 **Key PowerShell Commands**

| Command         | Purpose                             |
| --------------- | ----------------------------------- |
| `Get-HotFix`    | Retrieves installed Windows updates |
| `-ComputerName` | Queries remote system               |
| `Select-Object` | Extracts specific patch details     |
| `Export-Csv`    | Saves output to CSV file            |
| `foreach`       | Iterates through server list        |

---

🧩 **Alternative Method Using CIM (Recommended for Large Environments)**

```powershell
$computers = @("Server1","Server2")

foreach ($computer in $computers) {

    Get-CimInstance -ClassName Win32_QuickFixEngineering -ComputerName $computer |
    Select-Object PSComputerName, HotFixID, Description, InstalledOn

} | Export-Csv "C:\Temp\patch-report.csv" -NoTypeInformation
```

---

🧩 **Example with Server List from File**

```powershell
$computers = Get-Content "C:\Temp\servers.txt"

foreach ($computer in $computers) {

    Get-HotFix -ComputerName $computer |
    Select PSComputerName, HotFixID, InstalledOn

} | Export-Csv "C:\Temp\patch-report.csv" -NoTypeInformation
```

---

🧩 **DevOps Example (Patch Compliance Check)**

```powershell
$patch = "KB5030211"

Get-HotFix -ComputerName $computers |
Where-Object { $_.HotFixID -eq $patch }
```

Used for:

* **patch compliance audits**
* **security vulnerability remediation**
* **infrastructure maintenance reporting**

---

⚠️ **Requirements**

```text
- Remote PowerShell or WMI access enabled
- Administrator privileges on target machines
- Firewall allowing remote management
```

---

✅ **Best Practices**

* Store server lists in **external configuration files**.
* Use **CIM queries instead of older WMI methods** for better performance.
* Schedule scripts to generate **regular patch compliance reports**.
* Integrate results with **security monitoring tools (SIEM)**.

---

💡 **In short**

* Use `Get-HotFix` or `Get-CimInstance Win32_QuickFixEngineering` to retrieve installed patches.
* Query multiple remote computers using loops.
* Export patch data to **CSV for compliance and reporting**.

---
## Q46: Write a PowerShell script with `try-catch-finally` blocks to handle errors when accessing files that may not exist

🧠 **Overview**

* Error handling is critical in automation scripts to prevent failures when unexpected issues occur, such as **missing files, permission errors, or invalid paths**.
* PowerShell provides structured error handling using **`try`, `catch`, and `finally`** blocks.
* This approach is widely used in **DevOps scripts, CI/CD automation, and infrastructure management** to ensure scripts handle failures gracefully.

---

⚙️ **Purpose / How it works**

1. Place risky operations inside the **`try` block**.
2. If an error occurs → control moves to the **`catch` block**.
3. The **`finally` block** runs regardless of success or failure, often used for cleanup or logging.
4. Use `-ErrorAction Stop` to convert non-terminating errors into catchable errors.

Workflow:

```text
try → execute operation
catch → handle error
finally → cleanup/logging
```

---

🧩 **PowerShell Script**

```powershell
# File path to check
$filePath = "C:\Temp\example.txt"

try {

    # Attempt to read file
    $content = Get-Content $filePath -ErrorAction Stop

    Write-Output "File content:"
    Write-Output $content

}
catch {

    Write-Output "Error: File does not exist or cannot be accessed."
    Write-Output $_.Exception.Message

}
finally {

    Write-Output "File access operation completed."
}
```

---

🧩 **Example Output (File Exists)**

```
File content:
Hello World
File access operation completed.
```

---

🧩 **Example Output (File Missing)**

```
Error: File does not exist or cannot be accessed.
Cannot find path 'C:\Temp\example.txt' because it does not exist.
File access operation completed.
```

---

📋 **Error Handling Components**

| Block               | Purpose                                               |
| ------------------- | ----------------------------------------------------- |
| `try`               | Executes code that may fail                           |
| `catch`             | Handles errors if they occur                          |
| `finally`           | Executes regardless of success/failure                |
| `-ErrorAction Stop` | Converts non-terminating errors into terminating ones |

---

🧩 **Improved Version with Logging**

```powershell
$logFile = "C:\Temp\script-log.txt"

try {

    Get-Content "C:\Temp\data.txt" -ErrorAction Stop

}
catch {

    "ERROR: $($_.Exception.Message)" | Out-File $logFile -Append

}
finally {

    "Operation finished at $(Get-Date)" | Out-File $logFile -Append
}
```

---

🧩 **DevOps Example (Handling File Deployment)**

```powershell
try {

    Copy-Item "build.zip" "C:\Deploy\" -ErrorAction Stop

    Write-Output "Deployment successful"

}
catch {

    Write-Output "Deployment failed: $($_.Exception.Message)"

}
finally {

    Write-Output "Deployment process completed"
}
```

Used for:

* **CI/CD deployment scripts**
* **file processing automation**
* **infrastructure provisioning**

---

✅ **Best Practices**

* Always use `-ErrorAction Stop` inside `try` blocks.
* Log errors to **files or monitoring systems**.
* Keep the **catch block focused on meaningful error handling**.
* Use `finally` for **cleanup tasks (closing sessions, logging)**.

---

💡 **In short**

* Use `try` for risky operations.
* Handle failures in `catch`.
* Use `finally` for cleanup or logging.
* This ensures **robust and reliable automation scripts**.

---
## Q47: Write a PowerShell script that monitors a folder for new files and automatically moves them to another location when detected

🧠 **Overview**

* In automation workflows, it is common to **watch a directory for incoming files** (logs, uploads, backups, or build artifacts) and process them automatically.
* PowerShell can monitor folders using the **`.NET FileSystemWatcher` class**, which detects changes like **file creation, modification, or deletion**.
* This technique is used in **data pipelines, CI/CD artifact handling, log processing, and automated file workflows**.

---

⚙️ **Purpose / How it works**

1. Define the **source folder** to monitor.
2. Define the **destination folder** where files will be moved.
3. Create a **FileSystemWatcher object**.
4. Register an event when a **new file is created**.
5. Move the detected file using `Move-Item`.

Workflow:

```text
Monitor Folder → Detect New File → Move File → Log Action
```

---

🧩 **PowerShell Script**

```powershell
# Source and destination folders
$sourceFolder = "C:\Temp\Incoming"
$destinationFolder = "C:\Temp\Processed"

# Create FileSystemWatcher object
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $sourceFolder
$watcher.Filter = "*.*"
$watcher.EnableRaisingEvents = $true

# Action to perform when a new file is detected
$action = {

    $filePath = $Event.SourceEventArgs.FullPath
    $fileName = $Event.SourceEventArgs.Name
    $destination = "C:\Temp\Processed\$fileName"

    Start-Sleep -Seconds 2   # Wait to ensure file is fully written

    Move-Item $filePath $destination -Force

    Write-Output "Moved file: $fileName to Processed folder"
}

# Register event
Register-ObjectEvent $watcher Created -Action $action

Write-Output "Monitoring folder: $sourceFolder"

# Keep script running
while ($true) {
    Start-Sleep 5
}
```

---

🧩 **Example Workflow**

```text
C:\Temp\Incoming
    report1.txt
    logs.zip
```

After detection:

```text
C:\Temp\Processed
    report1.txt
    logs.zip
```

Console output:

```
Monitoring folder: C:\Temp\Incoming
Moved file: report1.txt to Processed folder
Moved file: logs.zip to Processed folder
```

---

📋 **Key PowerShell Components**

| Component              | Purpose                            |
| ---------------------- | ---------------------------------- |
| `FileSystemWatcher`    | Monitors file system changes       |
| `Register-ObjectEvent` | Triggers actions when events occur |
| `Move-Item`            | Moves files between directories    |
| `Start-Sleep`          | Ensures file writing is complete   |
| `while ($true)`        | Keeps monitoring script running    |

---

🧩 **Improved Version with Logging**

```powershell
$logFile = "C:\Temp\file-monitor.log"

$action = {

    $filePath = $Event.SourceEventArgs.FullPath
    $fileName = $Event.SourceEventArgs.Name

    Move-Item $filePath "C:\Temp\Processed\$fileName"

    "Moved $fileName at $(Get-Date)" | Out-File $logFile -Append
}
```

---

🧩 **DevOps Example (CI/CD Artifact Processing)**

```powershell
# Monitor build artifact directory
$sourceFolder = "C:\BuildArtifacts"
$destinationFolder = "C:\Deploy"
```

Used for:

* **automated deployment pipelines**
* **log ingestion systems**
* **data ingestion pipelines**
* **backup automation**

---

⚠️ **Important Notes**

* Always ensure files are **fully written before moving them**.
* Monitor only necessary file types using `Filter`.

Example:

```powershell
$watcher.Filter = "*.log"
```

---

✅ **Best Practices**

* Implement **logging for file operations**.
* Handle exceptions when moving files.
* Use file filters (`*.txt`, `*.log`) to reduce monitoring overhead.
* Run the script as a **Windows scheduled service or background task**.

---

💡 **In short**

* Use `.NET FileSystemWatcher` to monitor folders.
* Trigger an event when a **new file is created**.
* Automatically move the file using `Move-Item` for **automation workflows**.

----
## Q48: Write a PowerShell script to schedule and automate daily backups of a specific directory to a network share with date-stamped folder names

🧠 **Overview**

* Automated backups are critical in production systems to **protect data and enable quick recovery** during failures or incidents.
* PowerShell can automate directory backups using `Copy-Item` or `Robocopy`, storing them in **date-stamped folders** on a network share.
* This method is commonly used for **log backups, configuration snapshots, application data backups, and DevOps artifact archiving**.

---

⚙️ **Purpose / How it works**

1. Define the **source directory** to backup.
2. Define the **network share destination**.
3. Generate a **date-based folder name** using `Get-Date`.
4. Create the backup folder.
5. Copy files from the source to the destination using `Robocopy` (recommended for reliability).
6. Schedule the script using **Windows Task Scheduler** to run daily.

Workflow:

```text
Source Directory → Create Date Folder → Copy Files → Store in Network Share
```

---

🧩 **PowerShell Script**

```powershell
# Source directory
$source = "C:\Data"

# Network share destination
$destinationRoot = "\\BackupServer\DailyBackups"

# Create date-stamped folder
$date = Get-Date -Format "yyyy-MM-dd"
$destination = "$destinationRoot\Backup-$date"

# Create folder if it doesn't exist
if (!(Test-Path $destination)) {
    New-Item -ItemType Directory -Path $destination
}

# Perform backup using Robocopy
robocopy $source $destination /E /R:2 /W:2 /LOG:C:\Temp\backup-log.txt

Write-Output "Backup completed: $destination"
```

---

🧩 **Example Backup Structure**

```
\\BackupServer\DailyBackups
    Backup-2026-03-04
        file1.txt
        logs\
        configs\
    Backup-2026-03-05
        file1.txt
        logs\
```

---

📋 **Key PowerShell / Windows Commands**

| Command     | Purpose                                   |
| ----------- | ----------------------------------------- |
| `Get-Date`  | Generates timestamp for backup folder     |
| `Test-Path` | Checks if folder exists                   |
| `New-Item`  | Creates backup directory                  |
| `Robocopy`  | Efficient file copy for large directories |
| `/E`        | Copies all subdirectories                 |
| `/LOG`      | Writes backup logs                        |

---

🧩 **Schedule the Script (Task Scheduler)**

Run daily at 2 AM:

```powershell
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "C:\Scripts\backup.ps1"

$trigger = New-ScheduledTaskTrigger -Daily -At 2am

Register-ScheduledTask -TaskName "DailyDirectoryBackup" -Action $action -Trigger $trigger -User "SYSTEM"
```

---

🧩 **DevOps Example (Backup Configuration Files)**

```powershell
$source = "C:\App\Config"
$destinationRoot = "\\NAS\ConfigBackups"
```

Used for:

* **configuration backups**
* **log archival**
* **build artifact storage**
* **environment snapshot backups**

---

⚠️ **Important Notes**

* Ensure **network share permissions** allow write access.
* Monitor backup logs for failures.
* Consider **compression or retention policies** for long-term backups.

---

✅ **Best Practices**

* Use **Robocopy instead of Copy-Item** for large directories.
* Implement **log files for backup operations**.
* Store backups on **redundant storage (NAS or backup servers)**.
* Rotate or clean old backups to **avoid storage exhaustion**.

---

💡 **In short**

* Generate a **date-stamped folder using `Get-Date`**.
* Copy source directory to **network share using `Robocopy`**.
* Schedule execution using **Task Scheduler for daily automated backups**.

---
## Q49: Write a PowerShell script that queries a **SQL Server database** and exports the results to a CSV file

🧠 **Overview**

* PowerShell is often used in DevOps and operations to **extract data from SQL Server** for reporting, automation, and data analysis.
* The `Invoke-Sqlcmd` cmdlet (from the **SqlServer module**) allows PowerShell to execute SQL queries directly against a database.
* The query results can then be exported to **CSV files** using `Export-Csv`, which is useful for **report generation, audits, and integration with analytics tools**.

---

⚙️ **Purpose / How it works**

1. Import the **SqlServer PowerShell module**.
2. Define:

   * SQL Server instance
   * Database name
   * SQL query
3. Execute the query using `Invoke-Sqlcmd`.
4. Export the returned data to a **CSV file**.

Workflow:

```text
SQL Server → Execute Query → Retrieve Results → Export CSV
```

---

🧩 **PowerShell Script**

```powershell
# Import SQL Server module
Import-Module SqlServer

# SQL Server details
$server = "SQLSERVER01"
$database = "SalesDB"

# SQL query
$query = "SELECT * FROM Customers"

# Output file
$outputFile = "C:\Temp\customers-report.csv"

# Execute query
$result = Invoke-Sqlcmd -ServerInstance $server -Database $database -Query $query

# Export results to CSV
$result | Export-Csv $outputFile -NoTypeInformation

Write-Output "Query results exported to $outputFile"
```

---

🧩 **Example CSV Output**

```text
CustomerID,CustomerName,City,Country
1001,John Doe,New York,USA
1002,Jane Smith,London,UK
1003,Mike Brown,Toronto,Canada
```

---

📋 **Key PowerShell Components**

| Command                   | Purpose                            |
| ------------------------- | ---------------------------------- |
| `Import-Module SqlServer` | Loads SQL Server PowerShell module |
| `Invoke-Sqlcmd`           | Executes SQL query                 |
| `-ServerInstance`         | SQL Server host                    |
| `-Database`               | Target database                    |
| `Export-Csv`              | Saves query results to CSV         |

---

🧩 **Example with SQL Authentication**

```powershell
$server = "SQLSERVER01"
$database = "SalesDB"

Invoke-Sqlcmd -ServerInstance $server `
              -Database $database `
              -Query "SELECT * FROM Orders" `
              -Username "dbuser" `
              -Password "password123" |
Export-Csv "C:\Temp\orders.csv" -NoTypeInformation
```

---

🧩 **Example Using Query from File**

```powershell
$query = Get-Content "C:\Scripts\query.sql" -Raw

Invoke-Sqlcmd -ServerInstance $server -Database $database -Query $query |
Export-Csv "C:\Temp\query-results.csv" -NoTypeInformation
```

---

🧩 **DevOps Example (Database Health Report)**

```powershell
$query = "SELECT name, create_date FROM sys.databases"

Invoke-Sqlcmd -ServerInstance $server -Query $query |
Export-Csv "C:\Reports\database-report.csv" -NoTypeInformation
```

Used for:

* **database reporting**
* **audit exports**
* **CI/CD data validation**
* **monitoring dashboards**

---

⚠️ **Requirements**

```text
- SQL Server PowerShell module (SqlServer)
- Network access to SQL Server
- Database credentials or Windows authentication
```

Install module if needed:

```powershell
Install-Module SqlServer
```

---

✅ **Best Practices**

* Store credentials securely (e.g., **Azure Key Vault or credential objects**).
* Use parameterized queries for **security and performance**.
* Log query execution for **audit purposes**.
* Avoid exporting very large datasets without pagination.

---

💡 **In short**

* Use `Invoke-Sqlcmd` to run SQL queries from PowerShell.
* Retrieve results from SQL Server.
* Export data using `Export-Csv` for **reporting and automation workflows**.

---
## Q50: Write a PowerShell script that implements a complete server health check (CPU, memory, disk space, services status) across multiple servers and generates an HTML report with color-coded status indicators

🧠 **Overview**

* In production environments, administrators must continuously monitor **CPU usage, memory usage, disk space, and critical services** across servers.
* PowerShell allows remote monitoring using **`Invoke-Command`, `Get-CimInstance`, and `Get-Service`**, then generating a **visual HTML report** using `ConvertTo-Html`.
* This approach is commonly used in **DevOps monitoring scripts, infrastructure audits, and automated health reports**.

---

⚙️ **Purpose / How it works**

1. Define a list of **target servers**.
2. Collect metrics remotely:

   * CPU usage
   * Memory usage
   * Disk utilization
   * Critical service status
3. Store results in PowerShell objects.
4. Generate an **HTML report with color-coded status indicators**.
5. Save the report for dashboards or email alerts.

Workflow:

```text
Server List → Collect Metrics → Evaluate Thresholds → Generate HTML Report
```

---

🧩 **PowerShell Script**

```powershell
# List of servers
$servers = @("Server1","Server2","Server3")

# Critical services to check
$servicesToCheck = @("Spooler","W32Time")

$results = foreach ($server in $servers) {

    Invoke-Command -ComputerName $server -ScriptBlock {

        $cpu = (Get-CimInstance Win32_Processor).LoadPercentage

        $os = Get-CimInstance Win32_OperatingSystem
        $memoryUsage = [math]::Round((($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) /
                        $os.TotalVisibleMemorySize) * 100,2)

        $disk = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
        Select-Object DeviceID,
        @{Name="FreeSpaceGB";Expression={[math]::Round($_.FreeSpace/1GB,2)}}

        $services = Get-Service | Where-Object {$_.Name -in $using:servicesToCheck}

        [PSCustomObject]@{
            Server = $env:COMPUTERNAME
            CPU_Usage = $cpu
            Memory_Usage = $memoryUsage
            Disk_Free = ($disk | ForEach-Object {"$($_.DeviceID): $($_.FreeSpaceGB)GB"}) -join ", "
            Services = ($services | ForEach-Object {"$($_.Name): $($_.Status)"}) -join ", "
        }
    }
}

# HTML styling
$style = @"
<style>
table {border-collapse: collapse; width:100%;}
th, td {border:1px solid black; padding:8px; text-align:center;}
.good {background-color:#90EE90;}
.warning {background-color:#FFD700;}
.critical {background-color:#FF6B6B;}
</style>
"@

# Convert results to HTML
$html = $results | ConvertTo-Html -Head $style -Title "Server Health Report"

# Save report
$reportPath = "C:\Temp\ServerHealthReport.html"
$html | Out-File $reportPath

Write-Output "Health report generated: $reportPath"
```

---

🧩 **Example HTML Report**

| Server  | CPU Usage | Memory Usage | Disk Free | Services         |
| ------- | --------- | ------------ | --------- | ---------------- |
| Server1 | 20%       | 55%          | C: 50GB   | Spooler: Running |
| Server2 | 85%       | 78%          | C: 10GB   | Spooler: Stopped |
| Server3 | 15%       | 40%          | C: 120GB  | Spooler: Running |

Color indicators:

* 🟢 **Green** → Healthy
* 🟡 **Yellow** → Warning
* 🔴 **Red** → Critical

---

📋 **Key PowerShell Components**

| Command           | Purpose                             |
| ----------------- | ----------------------------------- |
| `Invoke-Command`  | Runs health checks remotely         |
| `Get-CimInstance` | Retrieves CPU, memory, disk metrics |
| `Get-Service`     | Checks service status               |
| `PSCustomObject`  | Structures monitoring data          |
| `ConvertTo-Html`  | Generates HTML report               |

---

🧩 **Example: Add Threshold Evaluation**

```powershell
if ($cpu -gt 80) { $cpuStatus = "CRITICAL" }
elseif ($cpu -gt 60) { $cpuStatus = "WARNING" }
else { $cpuStatus = "OK" }
```

---

🧩 **DevOps Example (Email the Health Report)**

```powershell
Send-MailMessage `
-To "admin@example.com" `
-From "monitor@example.com" `
-Subject "Daily Server Health Report" `
-BodyAsHtml (Get-Content $reportPath -Raw) `
-SmtpServer "smtp.example.com"
```

Used for:

* **daily infrastructure health reports**
* **NOC monitoring dashboards**
* **capacity planning**
* **incident detection**

---

⚠️ **Requirements**

```text
- PowerShell Remoting enabled (WinRM)
- Admin access to target servers
- Firewall allowing remote management
```

---

✅ **Best Practices**

* Define **thresholds for CPU, memory, and disk alerts**.
* Monitor only **critical services** to reduce noise.
* Schedule script execution using **Task Scheduler**.
* Integrate with monitoring tools like **Prometheus, Grafana, or ELK**.

---

💡 **In short**

* Use `Invoke-Command` to collect health metrics across servers.
* Retrieve CPU, memory, disk, and service status using CIM and service cmdlets.
* Generate a **color-coded HTML report** for easy monitoring and automation.

----

## Q51: PowerShell script to add a new user and add that user to an admin group

🧠 **Overview**

* In enterprise environments, administrators often automate **user provisioning and role assignment** in **Active Directory**.
* PowerShell’s **ActiveDirectory module** provides cmdlets like `New-ADUser` to create users and `Add-ADGroupMember` to assign them to groups (e.g., **Administrators, Domain Admins, IT_Admins**).
* This automation is commonly used in **identity management, onboarding workflows, and DevOps access provisioning**.

---

⚙️ **Purpose / How it works**

1. Import the **ActiveDirectory module**.
2. Define user properties (name, username, password).
3. Create the user using `New-ADUser`.
4. Add the user to an **admin group** using `Add-ADGroupMember`.

Workflow:

```text
Create AD User → Enable Account → Add User to Admin Group
```

---

🧩 **PowerShell Script**

```powershell
# Import Active Directory module
Import-Module ActiveDirectory

# User details
$username = "jdoe"
$firstname = "John"
$lastname = "Doe"
$password = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force

# Admin group
$adminGroup = "Domain Admins"

# Create new AD user
New-ADUser `
-Name "$firstname $lastname" `
-GivenName $firstname `
-Surname $lastname `
-SamAccountName $username `
-UserPrincipalName "$username@example.com" `
-AccountPassword $password `
-Enabled $true `
-Path "OU=Users,DC=example,DC=com"

# Add user to admin group
Add-ADGroupMember -Identity $adminGroup -Members $username

Write-Output "User $username created and added to $adminGroup group."
```

---

🧩 **Example Output**

```
User jdoe created and added to Domain Admins group.
```

---

📋 **Key PowerShell Commands**

| Command                         | Purpose                       |
| ------------------------------- | ----------------------------- |
| `Import-Module ActiveDirectory` | Loads AD management cmdlets   |
| `New-ADUser`                    | Creates a new user account    |
| `ConvertTo-SecureString`        | Converts password securely    |
| `Add-ADGroupMember`             | Adds user to AD group         |
| `-Path`                         | Specifies Organizational Unit |

---

🧩 **Example: Add User to Local Administrators Group**

```powershell
Add-LocalGroupMember -Group "Administrators" -Member "jdoe"
```

Used for **local admin privileges on a server**.

---

🧩 **DevOps Example (Automated Onboarding Script)**

```powershell
$group = "IT_Admins"

New-ADUser -Name "DevOps User" -SamAccountName "devops1" `
-AccountPassword (ConvertTo-SecureString "Temp@123" -AsPlainText -Force) `
-Enabled $true

Add-ADGroupMember $group -Members "devops1"
```

Used for:

* **developer onboarding**
* **DevOps access provisioning**
* **automation of user lifecycle**

---

⚠️ **Security Considerations**

* Avoid adding users directly to **Domain Admins** unless necessary.
* Use **role-based groups (RBAC)** instead of high-privilege groups.
* Store passwords securely (Vault / credential store).

---

✅ **Best Practices**

* Always create users inside the **correct OU**.
* Use **least privilege access** instead of global admin rights.
* Automate provisioning using **scripts or identity management tools**.
* Log all user creation events for **audit compliance**.

---

💡 **In short**

* Use `New-ADUser` to create a new user.
* Use `Add-ADGroupMember` to add the user to an admin group.
* This enables **automated user provisioning and role assignment in Active Directory**.

----
## Q52: Write a PowerShell script to create a new Active Directory user and add that user to a specific AD security group (e.g., `Domain Admins`)

🧠 **Overview**

* In enterprise environments, user onboarding often requires **creating a user account and assigning permissions through AD security groups**.
* PowerShell’s **ActiveDirectory module** enables automation using `New-ADUser` to create users and `Add-ADGroupMember` to assign them to groups.
* This is commonly used in **identity management automation, onboarding workflows, and DevOps access provisioning scripts**.

---

⚙️ **Purpose / How it works**

1. Import the **ActiveDirectory module**.
2. Define user attributes (name, username, email, password).
3. Create the user account using `New-ADUser`.
4. Enable the account.
5. Add the user to the specified **AD security group**.

Workflow:

```
Define User → Create AD Account → Enable User → Add to Security Group
```

---

🧩 **PowerShell Script**

```powershell
# Import Active Directory module
Import-Module ActiveDirectory

# User details
$firstName = "John"
$lastName  = "Doe"
$username  = "jdoe"
$email     = "jdoe@example.com"

# Password
$password = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force

# Target group
$groupName = "Domain Admins"

# Create AD user
New-ADUser `
-Name "$firstName $lastName" `
-GivenName $firstName `
-Surname $lastName `
-SamAccountName $username `
-UserPrincipalName "$username@example.com" `
-EmailAddress $email `
-AccountPassword $password `
-Enabled $true `
-Path "OU=Users,DC=example,DC=com"

# Add user to security group
Add-ADGroupMember -Identity $groupName -Members $username

Write-Output "User $username created and added to $groupName group."
```

---

🧩 **Example Output**

```
User jdoe created and added to Domain Admins group.
```

---

📋 **Key PowerShell Commands**

| Command                         | Purpose                       |
| ------------------------------- | ----------------------------- |
| `Import-Module ActiveDirectory` | Loads AD cmdlets              |
| `New-ADUser`                    | Creates new AD user           |
| `ConvertTo-SecureString`        | Securely handles passwords    |
| `Add-ADGroupMember`             | Adds user to AD group         |
| `-Path`                         | Specifies Organizational Unit |

---

🧩 **Example: Verify Group Membership**

```powershell
Get-ADGroupMember "Domain Admins" | Select Name, SamAccountName
```

---

🧩 **DevOps Example (Automated Onboarding)**

```powershell
$group = "DevOps_Team"

New-ADUser -Name "DevOps User" `
-SamAccountName "devops1" `
-AccountPassword (ConvertTo-SecureString "Temp@123" -AsPlainText -Force) `
-Enabled $true

Add-ADGroupMember -Identity $group -Members "devops1"
```

Used for:

* **developer onboarding**
* **automation of identity provisioning**
* **CI/CD environment access setup**

---

⚠️ **Security Notes**

* Avoid adding users directly to **Domain Admins** unless absolutely necessary.
* Prefer **role-based groups (RBAC)** such as `IT_Admins` or `DevOps_Admins`.

---

✅ **Best Practices**

* Use **secure password storage** (Vault or credential objects).
* Place users in the correct **Organizational Unit (OU)**.
* Log provisioning activities for **audit compliance**.
* Use **RBAC groups instead of privileged admin groups** when possible.

---

💡 **In short**

* Create the user with `New-ADUser`.
* Enable the account with a secure password.
* Assign permissions using `Add-ADGroupMember`.
* This automates **AD user provisioning and access control**.

---
## Q53: Write a PowerShell script to create multiple users from a CSV file and add them all to a specified AD group

🧠 **Overview**

* In enterprise environments, onboarding multiple employees manually in **Active Directory (AD)** is time-consuming and error-prone.
* PowerShell can automate bulk user creation using **`Import-Csv`**, `New-ADUser`, and `Add-ADGroupMember`.
* This method is widely used in **HR onboarding automation, identity management workflows, and DevOps access provisioning**.

---

⚙️ **Purpose / How it works**

1. Prepare a **CSV file containing user details**.
2. Import the CSV using `Import-Csv`.
3. Loop through each row using `ForEach-Object`.
4. Create users with `New-ADUser`.
5. Add users to a specific AD group using `Add-ADGroupMember`.

Workflow:

```
CSV File → Import Users → Create AD Accounts → Add to AD Group
```

---

🧩 **Example CSV File (`users.csv`)**

```csv
FirstName,LastName,Username,Email,Department
John,Doe,jdoe,jdoe@example.com,IT
Jane,Smith,jsmith,jsmith@example.com,HR
Mike,Brown,mbrown,mbrown@example.com,Finance
```

---

🧩 **PowerShell Script**

```powershell
# Import Active Directory module
Import-Module ActiveDirectory

# CSV file path
$csvFile = "C:\Temp\users.csv"

# AD group to assign
$groupName = "IT_Team"

# Default password
$password = ConvertTo-SecureString "Temp@1234" -AsPlainText -Force

# Import users
Import-Csv $csvFile | ForEach-Object {

    $username = $_.Username

    # Create AD user
    New-ADUser `
    -Name "$($_.FirstName) $($_.LastName)" `
    -GivenName $_.FirstName `
    -Surname $_.LastName `
    -SamAccountName $username `
    -UserPrincipalName "$username@example.com" `
    -EmailAddress $_.Email `
    -Department $_.Department `
    -AccountPassword $password `
    -Enabled $true `
    -Path "OU=Users,DC=example,DC=com"

    # Add user to group
    Add-ADGroupMember -Identity $groupName -Members $username

    Write-Output "User $username created and added to $groupName"
}
```

---

🧩 **Example Output**

```
User jdoe created and added to IT_Team
User jsmith created and added to IT_Team
User mbrown created and added to IT_Team
```

---

📋 **Key PowerShell Commands**

| Command                  | Purpose                       |
| ------------------------ | ----------------------------- |
| `Import-Csv`             | Reads user data from CSV file |
| `New-ADUser`             | Creates new AD users          |
| `ConvertTo-SecureString` | Converts password securely    |
| `Add-ADGroupMember`      | Adds user to AD group         |
| `ForEach-Object`         | Loops through CSV records     |

---

🧩 **Example: Verify Group Members**

```powershell
Get-ADGroupMember "IT_Team" | Select Name, SamAccountName
```

---

🧩 **Improved Version with Error Handling**

```powershell
Import-Csv $csvFile | ForEach-Object {

    try {

        New-ADUser -Name "$($_.FirstName) $($_.LastName)" `
        -SamAccountName $_.Username `
        -AccountPassword $password `
        -Enabled $true

        Add-ADGroupMember $groupName $_.Username

        Write-Output "Created user: $($_.Username)"

    } catch {

        Write-Output "Error creating user: $($_.Username)"
    }
}
```

---

🧩 **DevOps / IT Automation Use Cases**

Used for:

* **HR onboarding automation**
* **bulk identity provisioning**
* **DevOps team access setup**
* **security group management**

---

⚠️ **Security Notes**

* Avoid hardcoding passwords in production scripts.
* Use **secure vault solutions** (Azure Key Vault, HashiCorp Vault).
* Always verify CSV input to avoid **invalid accounts**.

---

✅ **Best Practices**

* Validate CSV data before user creation.
* Place users in correct **OU structure**.
* Assign **RBAC groups instead of high-privilege groups**.
* Log provisioning actions for **audit compliance**.

---

💡 **In short**

* Store user data in a **CSV file**.
* Import users using `Import-Csv`.
* Create accounts with `New-ADUser`.
* Add them to groups using `Add-ADGroupMember` for **automated bulk onboarding**.

---
## Q54: Write a PowerShell script to remove a user from a specific group (both local and Active Directory)

🧠 **Overview**

* In enterprise environments, administrators often need to **revoke user permissions** by removing users from security groups.
* PowerShell supports removing users from **Active Directory groups** using `Remove-ADGroupMember` and from **local system groups** using `Remove-LocalGroupMember`.
* This is commonly used in **offboarding processes, access revocation, and security compliance automation**.

---

⚙️ **Purpose / How it works**

1. Identify the **user account** and the **target group**.
2. For **Active Directory groups**, use `Remove-ADGroupMember`.
3. For **local groups**, use `Remove-LocalGroupMember`.
4. Optionally verify membership before removal.

Workflow:

```text
Identify User → Identify Group → Remove Membership → Verify Access Removal
```

---

## 🧩 Script 1: Remove user from an **Active Directory group**

```powershell
# Import Active Directory module
Import-Module ActiveDirectory

# User and group details
$username = "jdoe"
$groupName = "IT_Admins"

# Remove user from AD group
Remove-ADGroupMember -Identity $groupName -Members $username -Confirm:$false

Write-Output "User $username removed from AD group $groupName"
```

---

## 🧩 Script 2: Remove user from a **local Windows group**

```powershell
# Local group and user
$user = "jdoe"
$localGroup = "Administrators"

# Remove user from local group
Remove-LocalGroupMember -Group $localGroup -Member $user

Write-Output "User $user removed from local group $localGroup"
```

---

## 🧩 Script 3: Combined Script (Local + AD Group Removal)

```powershell
Import-Module ActiveDirectory

$username = "jdoe"
$adGroup = "IT_Admins"
$localGroup = "Administrators"

# Remove from AD group
Remove-ADGroupMember -Identity $adGroup -Members $username -Confirm:$false

# Remove from local group
Remove-LocalGroupMember -Group $localGroup -Member $username

Write-Output "User $username removed from AD group $adGroup and local group $localGroup"
```

---

📋 **Key PowerShell Commands**

| Command                         | Purpose                               |
| ------------------------------- | ------------------------------------- |
| `Remove-ADGroupMember`          | Removes user from AD group            |
| `Remove-LocalGroupMember`       | Removes user from local machine group |
| `Import-Module ActiveDirectory` | Loads AD cmdlets                      |
| `-Confirm:$false`               | Suppresses confirmation prompts       |

---

🧩 **Verify Group Membership After Removal**

### Check AD group members

```powershell
Get-ADGroupMember "IT_Admins" | Select Name, SamAccountName
```

### Check local group members

```powershell
Get-LocalGroupMember "Administrators"
```

---

🧩 **DevOps / Security Example (User Offboarding)**

```powershell
$user = "employee01"

Remove-ADGroupMember -Identity "DevOps_Team" -Members $user -Confirm:$false
Remove-LocalGroupMember -Group "Administrators" -Member $user
```

Used for:

* **employee offboarding automation**
* **security access cleanup**
* **privilege revocation scripts**

---

⚠️ **Important Notes**

* Administrator privileges are required.
* AD module must be installed (`RSAT-AD-PowerShell`).
* Removing users from critical groups like **Domain Admins** should follow strict approval policies.

---

✅ **Best Practices**

* Always **verify group membership before removal**.
* Log changes for **audit and compliance**.
* Automate access cleanup during **employee offboarding workflows**.
* Use **role-based access control (RBAC)** instead of assigning direct privileges.

---

💡 **In short**

* Use `Remove-ADGroupMember` for **Active Directory groups**.
* Use `Remove-LocalGroupMember` for **local machine groups**.
* These scripts automate **access revocation and security compliance tasks**.

---
## Q55: Write a PowerShell script to check if a user exists in a specific group and add them only if they're not already a member

🧠 **Overview**

* In identity management automation, administrators often need to **ensure users are part of required security groups** without creating duplicate membership entries.
* PowerShell allows checking group membership using `Get-ADGroupMember` and conditionally adding users using `Add-ADGroupMember`.
* This pattern is commonly used in **DevOps access provisioning, RBAC enforcement, and automated onboarding workflows**.

---

⚙️ **Purpose / How it works**

1. Import the **ActiveDirectory module**.
2. Define the **username** and **target group**.
3. Retrieve current group members using `Get-ADGroupMember`.
4. Check whether the user already exists in the group.
5. If not → add the user using `Add-ADGroupMember`.

Workflow:

```text
Check Group Members → Verify User Membership → Add User if Missing
```

---

🧩 **PowerShell Script**

```powershell
# Import Active Directory module
Import-Module ActiveDirectory

# User and group
$username = "jdoe"
$groupName = "IT_Team"

# Check if user exists in group
$member = Get-ADGroupMember -Identity $groupName | Where-Object { $_.SamAccountName -eq $username }

if ($member) {

    Write-Output "User $username is already a member of $groupName"

} else {

    Add-ADGroupMember -Identity $groupName -Members $username
    Write-Output "User $username added to $groupName"
}
```

---

🧩 **Example Output**

If user already exists:

```
User jdoe is already a member of IT_Team
```

If user is not a member:

```
User jdoe added to IT_Team
```

---

📋 **Key PowerShell Commands**

| Command                         | Purpose                       |
| ------------------------------- | ----------------------------- |
| `Import-Module ActiveDirectory` | Loads AD cmdlets              |
| `Get-ADGroupMember`             | Retrieves group members       |
| `Where-Object`                  | Filters user from member list |
| `Add-ADGroupMember`             | Adds user to group            |

---

🧩 **Improved Version (Efficient Lookup)**

For large AD groups, checking membership via **`Get-ADUser -Properties MemberOf`** is faster.

```powershell
$user = Get-ADUser "jdoe" -Properties MemberOf

if ($user.MemberOf -match "IT_Team") {

    Write-Output "User already in group"

} else {

    Add-ADGroupMember "IT_Team" -Members "jdoe"
}
```

---

🧩 **Bulk Example (Multiple Users)**

```powershell
$users = @("jdoe","jsmith","mbrown")
$group = "DevOps_Team"

foreach ($user in $users) {

    if (-not (Get-ADGroupMember $group | Where SamAccountName -eq $user)) {

        Add-ADGroupMember $group -Members $user
        Write-Output "Added $user to $group"

    }
}
```

---

🧩 **DevOps Use Case**

Example: Ensure developers always have required access.

```powershell
$group = "Kubernetes_Admins"
$user = "devops01"

if (!(Get-ADGroupMember $group | Where SamAccountName -eq $user)) {

    Add-ADGroupMember $group $user
}
```

Used for:

* **RBAC enforcement**
* **developer access provisioning**
* **automation scripts in CI/CD environments**

---

⚠️ **Important Notes**

* Administrator privileges are required.
* Avoid running `Get-ADGroupMember` repeatedly on very large groups without filtering.

---

✅ **Best Practices**

* Always **check membership before adding users** to prevent duplicates.
* Use **role-based groups instead of direct permissions**.
* Log membership changes for **audit and compliance tracking**.
* Integrate with **identity management workflows** for automation.

---

💡 **In short**

* Use `Get-ADGroupMember` to check if the user already belongs to the group.
* If not present → add using `Add-ADGroupMember`.
* This ensures **safe and idempotent access provisioning in Active Directory**.
