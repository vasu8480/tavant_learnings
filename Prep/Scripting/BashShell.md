# Bash Shell 

## Q1: Write a bash script to display "Hello World" and the current date and time

🧠 Overview  
- A **Bash script** automates command execution in Linux systems.  
- Displaying **messages and system time** is commonly used in automation scripts for logging, debugging, and CI/CD pipeline notifications.  
- In DevOps workflows, timestamps are useful for **build logs, deployment tracking, and monitoring tasks**.

⚙️ Purpose / How it works  
- `#!/bin/bash` → Defines the script interpreter.  
- `echo` → Prints text to the terminal or logs.  
- `date` → Retrieves the current system date and time.  
- Command substitution `$(...)` allows embedding command output inside text.

🧩 Examples / Commands / Config snippets  

**Basic Bash Script**

```bash
#!/bin/bash

echo "Hello World"
echo "Current Date and Time: $(date)"
````

**Sample Output**

```
Hello World
Current Date and Time: Wed Mar 04 15:20:10 IST 2026
```

---

**Production-style Script with Formatting**

```bash
#!/bin/bash

CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S")

echo "================================"
echo "Hello World"
echo "Current Date and Time: $CURRENT_TIME"
echo "================================"
```

**Output**

```
================================
Hello World
Current Date and Time: 2026-03-04 15:20:10
================================
```

---

**How to Run the Script**

```bash
# create file
vim hello.sh

# give execute permission
chmod +x hello.sh

# run script
./hello.sh
```

📋 Common `date` Format Options

| Format | Meaning    | Example |
| ------ | ---------- | ------- |
| `%Y`   | Year       | 2026    |
| `%m`   | Month      | 03      |
| `%d`   | Day        | 04      |
| `%H`   | Hour (24h) | 15      |
| `%M`   | Minutes    | 20      |
| `%S`   | Seconds    | 10      |

Example:

```bash
date "+%Y-%m-%d %H:%M:%S"
```

Output:

```
2026-03-04 15:20:10
```

✅ Best Practices

* Always include **shebang (`#!/bin/bash`)**.
* Use **ISO timestamp format (`YYYY-MM-DD HH:MM:SS`)** for logs.
* Store timestamps in variables for reuse in scripts.
* Useful for **deployment scripts, cron jobs, and CI/CD logs**.

💡 In short

* Bash scripts automate Linux tasks.
* `echo` prints messages and `date` retrieves system time.
* Combining both helps create **timestamped logs in DevOps automation scripts**.

----
## Q2: Write a bash script to create a directory called "logs" in /tmp and create 5 empty files inside it named log1.txt to log5.txt

### 🧠 Overview

* Bash scripts automate **Linux file system tasks** such as directory creation and file generation.
* This script creates a directory **`/tmp/logs`** and generates **5 empty log files** (`log1.txt` to `log5.txt`).
* Similar scripts are used in **DevOps automation**, for example creating log directories before starting applications or initializing environments in CI/CD pipelines.

---

### ⚙️ Purpose / How it works

* `mkdir -p` → Creates the directory if it does not exist.
* `for` loop → Iterates numbers from **1 to 5**.
* `touch` → Creates empty files.

---

### 🧩 Bash Script

```bash
#!/bin/bash

LOG_DIR="/tmp/logs"

# Create directory if it does not exist
mkdir -p "$LOG_DIR"

# Create 5 empty files
for i in {1..5}
do
  touch "$LOG_DIR/log$i.txt"
done

echo "Directory /tmp/logs and 5 log files created successfully."
```

---

### ▶️ How to Run

```bash
# create the script
vim create_logs.sh

# give execute permission
chmod +x create_logs.sh

# run the script
./create_logs.sh
```

---

### 🔍 Verify the Files

```bash
ls -l /tmp/logs
```

Example output:

```
log1.txt
log2.txt
log3.txt
log4.txt
log5.txt
```

---

### 📋 Commands Used

| Command    | Purpose                     | Example              |
| ---------- | --------------------------- | -------------------- |
| `mkdir -p` | Create directory safely     | `mkdir -p /tmp/logs` |
| `touch`    | Create empty file           | `touch log1.txt`     |
| `for` loop | Run commands multiple times | `for i in {1..5}`    |

---

### ✅ Best Practices

* Always use **variables for paths** (`LOG_DIR="/tmp/logs"`).
* Use **quotes around variables** to avoid path issues.
* Use `mkdir -p` so the script **does not fail if the directory already exists**.
* Add **echo logs** to help debugging in automation scripts.

---

### 💡 In short

* The script creates `/tmp/logs`.
* A `for` loop runs **5 times**.
* `touch` creates files `log1.txt` → `log5.txt`.

---
## Q3: Write a bash script to list all files in a directory with their sizes and permissions

### 🧠 Overview

* In Linux/DevOps environments, scripts often need to **inspect directories, verify file permissions, and check file sizes**.
* This is useful for **log monitoring, artifact verification, and troubleshooting permission issues** in servers, containers, or CI/CD agents.
* The script below lists all files in a directory along with **file name, size, and permissions**.

---

### ⚙️ Purpose / How it works

* `ls -l` → Displays detailed file information (permissions, size, owner, date).
* `for` loop → Iterates through files in the directory.
* `stat` → Extracts file metadata like **size and permissions**.
* A directory path variable allows **reusability in automation scripts**.

---

### 🧩 Bash Script

```bash
#!/bin/bash

DIR=$1

# Check if directory is provided
if [ -z "$DIR" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Check if directory exists
if [ ! -d "$DIR" ]; then
  echo "Directory does not exist."
  exit 1
fi

echo "Files in directory: $DIR"
echo "--------------------------------------------"
printf "%-20s %-10s %-10s\n" "FILE NAME" "SIZE(B)" "PERMISSIONS"

for file in "$DIR"/*
do
  if [ -f "$file" ]; then
    size=$(stat -c%s "$file")
    perm=$(stat -c%A "$file")
    name=$(basename "$file")

    printf "%-20s %-10s %-10s\n" "$name" "$size" "$perm"
  fi
done
```

---

### ▶️ How to Run

```bash
# create script
vim list_files.sh

# give execute permission
chmod +x list_files.sh

# run script
./list_files.sh /tmp
```

---

### 🔍 Example Output

```
Files in directory: /tmp
--------------------------------------------
FILE NAME            SIZE(B)    PERMISSIONS
log1.txt             0          -rw-r--r--
log2.txt             0          -rw-r--r--
log3.txt             0          -rw-r--r--
```

---

### 📋 Commands Used

| Command     | Purpose           | Example                  |
| ----------- | ----------------- | ------------------------ |
| `ls -l`     | Show file details | `ls -l /tmp`             |
| `stat -c%s` | Get file size     | `stat -c%s file.txt`     |
| `stat -c%A` | Get permissions   | `stat -c%A file.txt`     |
| `basename`  | Extract file name | `basename /tmp/log1.txt` |

---

### ✅ Best Practices

* Always validate **input parameters** before running scripts.
* Use `stat` instead of parsing `ls` output for **reliable metadata extraction**.
* Add formatted output (`printf`) to make logs **clean for monitoring tools or CI pipelines**.
* Useful in **log auditing, artifact validation, and permission checks**.

---

### 💡 In short

* Script takes a **directory as input**.
* Loops through files and extracts **size and permissions using `stat`**.
* Displays a **formatted table for quick inspection**.

---
## Q4: Write a bash script to copy all `.txt` files from `/source` to `/destination`

### 🧠 Overview

* In Linux and DevOps environments, scripts often automate **file transfers between directories** (logs, artifacts, backups).
* This script copies all **`.txt` files** from a source directory to a destination directory.
* Similar logic is used in **CI/CD pipelines to move build artifacts, logs, or reports between stages**.

---

### ⚙️ Purpose / How it works

* `SRC_DIR` → Source directory containing `.txt` files.
* `DEST_DIR` → Destination directory where files will be copied.
* `mkdir -p` → Ensures destination directory exists.
* `cp` → Copies files.
* `for` loop → Iterates through all `.txt` files.

---

### 🧩 Bash Script

```bash
#!/bin/bash

SRC_DIR="/source"
DEST_DIR="/destination"

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Copy all .txt files
for file in "$SRC_DIR"/*.txt
do
  cp "$file" "$DEST_DIR"
done

echo "All .txt files copied from $SRC_DIR to $DEST_DIR"
```

---

### ▶️ How to Run

```bash
# create script
vim copy_txt_files.sh

# give execute permission
chmod +x copy_txt_files.sh

# run script
./copy_txt_files.sh
```

---

### 🔍 Verify Files

```bash
ls /destination
```

Example output:

```
file1.txt
file2.txt
file3.txt
```

---

### 📋 Commands Used

| Command    | Purpose                     | Example                    |
| ---------- | --------------------------- | -------------------------- |
| `cp`       | Copy files                  | `cp file.txt /destination` |
| `mkdir -p` | Create directory if missing | `mkdir -p /destination`    |
| `for` loop | Iterate through files       | `for file in *.txt`        |

---

### ✅ Best Practices

* Always check if **source directory exists** before copying.
* Use **quotes around variables** to avoid path issues.
* Use `mkdir -p` to ensure **destination directory exists**.
* Add logging (`echo`) for **debugging in automation scripts**.

---

### 💡 In short

* The script loops through **all `.txt` files in `/source`**.
* Uses `cp` to copy them into `/destination`.
* Ensures the destination directory exists using **`mkdir -p`**.

---
## Q5: Write a bash script to delete all files older than 30 days from a specified directory

### 🧠 Overview

* In Linux/DevOps environments, directories like **logs, backups, and temporary files** grow quickly and must be cleaned automatically.
* This script deletes files **older than 30 days** from a given directory.
* Such scripts are commonly used in **log rotation, CI/CD workspace cleanup, and server maintenance automation**.

---

### ⚙️ Purpose / How it works

* `find` → Searches files in a directory.
* `-type f` → Targets only files (not directories).
* `-mtime +30` → Finds files modified **more than 30 days ago**.
* `-delete` → Removes the matched files.
* Script accepts a **directory as an input argument**.

---

### 🧩 Bash Script

```bash
#!/bin/bash

DIR=$1

# Check if directory argument is provided
if [ -z "$DIR" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Check if directory exists
if [ ! -d "$DIR" ]; then
  echo "Directory does not exist."
  exit 1
fi

echo "Deleting files older than 30 days from: $DIR"

find "$DIR" -type f -mtime +30 -delete

echo "Cleanup completed."
```

---

### ▶️ How to Run

```bash
# create script
vim cleanup_old_files.sh

# give execute permission
chmod +x cleanup_old_files.sh

# run script
./cleanup_old_files.sh /var/log
```

---

### 🔍 Preview Files Before Deleting (Safer)

```bash
find /var/log -type f -mtime +30
```

This command lists files that **will be deleted**, useful for verification.

---

### 📋 Important `find` Options

| Option          | Meaning              | Example                    |
| --------------- | -------------------- | -------------------------- |
| `-type f`       | Search only files    | `find /logs -type f`       |
| `-mtime +30`    | Older than 30 days   | `find /logs -mtime +30`    |
| `-delete`       | Delete matched files | `find /logs -delete`       |
| `-name "*.log"` | Filter by filename   | `find /logs -name "*.log"` |

---

### ✅ Best Practices

* Always **preview files before deletion** using `find` without `-delete`.
* Run cleanup scripts via **cron jobs** for automation.
* Restrict deletion using file filters if needed (e.g., `*.log`).
* Log deleted files for **audit or troubleshooting**.

Example cron job:

```bash
0 2 * * * /scripts/cleanup_old_files.sh /var/log
```

Runs **daily at 2 AM**.

---

### 💡 In short

* Uses `find` to locate files older than **30 days**.
* Deletes them automatically with `-delete`.
* Commonly used for **log cleanup and server maintenance automation**.

---
## Q6: Write a bash script that takes a username as input and outputs "Hello, [username]!"

### 🧠 Overview

* Bash scripts can accept **user input or command-line arguments** to personalize execution.
* This is commonly used in **automation scripts, CI/CD jobs, and interactive setup scripts** where user information or environment values are required.
* The script below takes a **username as input** and prints a greeting message.

---

### ⚙️ Purpose / How it works

* `$1` → Represents the **first command-line argument** passed to the script.
* The script checks if the username is provided.
* `echo` prints the greeting message.

---

### 🧩 Bash Script

```bash
#!/bin/bash

USERNAME=$1

# Check if username is provided
if [ -z "$USERNAME" ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

echo "Hello, $USERNAME!"
```

---

### ▶️ How to Run

```bash
# create script
vim greet_user.sh

# give execute permission
chmod +x greet_user.sh

# run script
./greet_user.sh vasu
```

---

### 🔍 Example Output

```
Hello, vasu!
```

---

### 📋 Key Bash Variables

| Variable | Meaning             | Example         |
| -------- | ------------------- | --------------- |
| `$0`     | Script name         | `greet_user.sh` |
| `$1`     | First argument      | `vasu`          |
| `$2`     | Second argument     | optional input  |
| `$#`     | Number of arguments | `1`             |

---

### ✅ Best Practices

* Always validate **input arguments** in scripts.
* Use **clear usage messages** for incorrect input.
* Quote variables (`"$USERNAME"`) to prevent issues with spaces.
* Useful in **automation scripts that require parameters (username, environment, cluster name, etc.)**.

---

### 💡 In short

* Script takes **username as a command-line argument**.
* Uses `$1` to read the input.
* Prints greeting using `echo "Hello, username!"`.

---
## Q7: Write a bash script to check if a file exists, and if not, create it with default content

### 🧠 Overview

* In DevOps automation, scripts often need to **verify configuration files, log files, or environment files** before running applications.
* This script checks whether a file exists. If it **does not exist**, the script **creates the file and adds default content**.
* This pattern is commonly used in **application setup scripts, container entrypoints, and CI/CD initialization steps**.

---

### ⚙️ Purpose / How it works

* `-f` → Checks if a file exists.
* `if` condition → Determines whether to create the file.
* `echo` → Writes default content into the file.
* The script accepts the **file name as an argument**.

---

### 🧩 Bash Script

```bash
#!/bin/bash

FILE=$1

# Check if filename is provided
if [ -z "$FILE" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Check if file exists
if [ -f "$FILE" ]; then
  echo "File already exists: $FILE"
else
  echo "File does not exist. Creating file..."
  echo "Default content: File created on $(date)" > "$FILE"
  echo "File created successfully."
fi
```

---

### ▶️ How to Run

```bash
# create script
vim check_file.sh

# give execute permission
chmod +x check_file.sh

# run script
./check_file.sh sample.txt
```

---

### 🔍 Example Output

If file does not exist:

```
File does not exist. Creating file...
File created successfully.
```

Content of the file:

```
Default content: File created on Wed Mar 04 16:10:20 IST 2026
```

---

### 📋 File Test Operators

| Operator | Purpose                           | Example           |
| -------- | --------------------------------- | ----------------- |
| `-f`     | Check if file exists              | `[ -f file.txt ]` |
| `-d`     | Check if directory exists         | `[ -d /tmp ]`     |
| `-e`     | Check if file or directory exists | `[ -e file.txt ]` |
| `-s`     | Check if file is not empty        | `[ -s file.txt ]` |

---

### ✅ Best Practices

* Always validate **input arguments** before script execution.
* Use `>` to create files with **default content safely**.
* Include timestamps (`date`) for **audit and debugging**.
* Useful in **DevOps setup scripts, container startup scripts, and CI/CD initialization tasks**.

---

### 💡 In short

* Script checks file existence using `-f`.
* If missing, it **creates the file and writes default content**.
* Ensures **configuration or log files are always available before application startup**.

---
## Q8: Write a bash script to rename all `.log` files in a directory by appending the current date to their filenames

### 🧠 Overview

* In DevOps and Linux administration, renaming log files with timestamps is common for **log rotation, backups, and audit tracking**.
* This script renames all `.log` files in a directory by **adding the current date to the filename**.
* Similar logic is used in **log archiving scripts, CI/CD build artifact tagging, and server maintenance automation**.

---

### ⚙️ Purpose / How it works

* `date "+%Y-%m-%d"` → Gets the current date in a standard format.
* `for` loop → Iterates through all `.log` files.
* `mv` → Renames the file.
* `basename` → Extracts filename without extension.

---

### 🧩 Bash Script

```bash
#!/bin/bash

DIR=$1
DATE=$(date "+%Y-%m-%d")

# Check if directory argument is provided
if [ -z "$DIR" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Check if directory exists
if [ ! -d "$DIR" ]; then
  echo "Directory does not exist."
  exit 1
fi

for file in "$DIR"/*.log
do
  if [ -f "$file" ]; then
    filename=$(basename "$file" .log)
    mv "$file" "$DIR/${filename}_$DATE.log"
  fi
done

echo "All .log files renamed with date."
```

---

### ▶️ How to Run

```bash
# create script
vim rename_logs.sh

# give execute permission
chmod +x rename_logs.sh

# run script
./rename_logs.sh /var/log
```

---

### 🔍 Example

Before:

```
app.log
server.log
error.log
```

After running script:

```
app_2026-03-04.log
server_2026-03-04.log
error_2026-03-04.log
```

---

### 📋 Commands Used

| Command    | Purpose            | Example                  |
| ---------- | ------------------ | ------------------------ |
| `date`     | Get current date   | `date "+%Y-%m-%d"`       |
| `mv`       | Rename/move file   | `mv old.log new.log`     |
| `basename` | Extract file name  | `basename file.log .log` |
| `for`      | Loop through files | `for f in *.log`         |

---

### ✅ Best Practices

* Use **ISO date format (`YYYY-MM-DD`)** for log filenames.
* Always validate the **directory input** before processing files.
* Use `-f` check to avoid errors if no `.log` files exist.
* Useful in **log rotation scripts, cron jobs, and CI/CD artifact versioning**.

Example cron job for daily log renaming:

```bash
0 1 * * * /scripts/rename_logs.sh /var/log/app
```

Runs every day at **1 AM**.

---

### 💡 In short

* Script loops through all `.log` files.
* Gets the **current date using `date`**.
* Uses `mv` to rename files like `app.log → app_YYYY-MM-DD.log`.

---
## Q9: Write a bash script to count the number of files and subdirectories in a given directory

### 🧠 Overview

* In DevOps operations, it is common to **analyze directory structures** for logs, build artifacts, backups, or container volumes.
* This script counts the **number of files and subdirectories** inside a specified directory.
* Such scripts are useful in **CI/CD workspace validation, storage monitoring, and troubleshooting server directories**.

---

### ⚙️ Purpose / How it works

* `DIR=$1` → Accepts the directory path as an input argument.
* `find` → Searches for files and directories.
* `-type f` → Filters only files.
* `-type d` → Filters only directories.
* `wc -l` → Counts the results.

---

### 🧩 Bash Script

```bash
#!/bin/bash

DIR=$1

# Check if directory argument is provided
if [ -z "$DIR" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Check if directory exists
if [ ! -d "$DIR" ]; then
  echo "Directory does not exist."
  exit 1
fi

# Count files
file_count=$(find "$DIR" -type f | wc -l)

# Count directories (excluding the root directory)
dir_count=$(find "$DIR" -mindepth 1 -type d | wc -l)

echo "Directory: $DIR"
echo "Number of files: $file_count"
echo "Number of subdirectories: $dir_count"
```

---

### ▶️ How to Run

```bash
# create script
vim count_files.sh

# give execute permission
chmod +x count_files.sh

# run script
./count_files.sh /tmp
```

---

### 🔍 Example Output

```
Directory: /tmp
Number of files: 10
Number of subdirectories: 3
```

---

### 📋 Commands Used

| Command       | Purpose                  | Example                         |
| ------------- | ------------------------ | ------------------------------- |
| `find`        | Search files/directories | `find /tmp -type f`             |
| `-type f`     | Filter files only        | `find /tmp -type f`             |
| `-type d`     | Filter directories only  | `find /tmp -type d`             |
| `wc -l`       | Count lines/items        | `wc -l`                         |
| `-mindepth 1` | Exclude root directory   | `find /tmp -mindepth 1 -type d` |

---

### ✅ Best Practices

* Always validate the **input directory** before executing the script.
* Use `find` instead of `ls` for **accurate counting** in large directories.
* Exclude the root directory using `-mindepth 1` to get **true subdirectory counts**.
* Useful in **storage audits, CI/CD workspace checks, and log directory monitoring**.

---

### 💡 In short

* Script accepts a **directory path as input**.
* Uses `find` to count **files and subdirectories**.
* `wc -l` calculates the total counts for quick reporting.

----
## Q10: Write a bash script to read a text file line by line and display each line with a line number

### 🧠 Overview

* Reading files line-by-line is common in **DevOps automation**, such as processing logs, configuration files, or pipeline inputs.
* This script reads a **text file sequentially** and prints each line with its **corresponding line number**.
* Similar logic is used in **log parsers, deployment scripts, and monitoring utilities**.

---

### ⚙️ Purpose / How it works

* `FILE=$1` → Accepts the filename as input.
* `while read` → Reads the file line by line.
* `line_number` → Counter variable that increments for each line.
* `echo` → Prints the line number and content.

---

### 🧩 Bash Script

```bash
#!/bin/bash

FILE=$1
line_number=1

# Check if file argument is provided
if [ -z "$FILE" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Check if file exists
if [ ! -f "$FILE" ]; then
  echo "File does not exist."
  exit 1
fi

while IFS= read -r line
do
  echo "$line_number: $line"
  ((line_number++))
done < "$FILE"
```

---

### ▶️ How to Run

```bash
# create script
vim read_file.sh

# give execute permission
chmod +x read_file.sh

# run script
./read_file.sh sample.txt
```

---

### 🔍 Example Input File (`sample.txt`)

```
Hello
DevOps
Automation
Bash scripting
```

---

### 🔍 Example Output

```
1: Hello
2: DevOps
3: Automation
4: Bash scripting
```

---

### 📋 Commands Used

| Command      | Purpose                       | Example             |
| ------------ | ----------------------------- | ------------------- |
| `while read` | Read file line by line        | `while read line`   |
| `IFS=`       | Preserve whitespace           | `IFS= read -r line` |
| `-r`         | Prevent escape interpretation | `read -r line`      |
| `(( ))`      | Arithmetic operation          | `((line_number++))` |

---

### ✅ Best Practices

* Use `IFS= read -r` to **preserve whitespace and avoid escape issues**.
* Validate the **file exists before reading**.
* Useful for **log processing, config parsing, and automation scripts**.
* Avoid using `cat file | while read` because it can cause **subshell issues**.

---

### 💡 In short

* Script reads a file **line by line** using `while read`.
* Maintains a **counter variable for line numbers**.
* Prints output like `1: line content`, `2: line content`.

----
## Q11: Write a bash script using a for loop to print numbers from 1 to 10

### 🧠 Overview

* Loops are fundamental in Bash scripting and are widely used in **automation, deployments, and CI/CD scripts**.
* A `for` loop allows executing a command **multiple times with different values**.
* This script prints numbers from **1 to 10**, demonstrating basic iteration used in tasks like **batch processing, file handling, and automation jobs**.

---

### ⚙️ Purpose / How it works

* `for i in {1..10}` → Generates numbers from **1 to 10**.
* `echo` → Prints the value of the loop variable.
* The loop runs **10 times**, once for each number.

---

### 🧩 Bash Script

```bash
#!/bin/bash

for i in {1..10}
do
  echo $i
done
```

---

### ▶️ How to Run

```bash
# create script
vim print_numbers.sh

# give execute permission
chmod +x print_numbers.sh

# run script
./print_numbers.sh
```

---

### 🔍 Example Output

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

### 📋 Alternative Method Using `seq`

```bash
#!/bin/bash

for i in $(seq 1 10)
do
  echo $i
done
```

| Method          | Example    | Use Case       |
| --------------- | ---------- | -------------- |
| Brace expansion | `{1..10}`  | Simple loops   |
| `seq` command   | `seq 1 10` | Dynamic ranges |

---

### ✅ Best Practices

* Use **brace expansion `{1..10}`** for simple loops because it is faster.
* Use `seq` when numbers are **dynamic or calculated**.
* Loops are commonly used in **DevOps scripts for file processing, deployments, and automation tasks**.

---

### 💡 In short

* `for` loop iterates through values **1 to 10**.
* `echo` prints each number.
* Used for **repetitive tasks in automation scripts**.

----
## Q12: Write a bash script using a while loop to display a countdown from 10 to 1

### 🧠 Overview

* `while` loops in Bash execute commands **repeatedly while a condition is true**.
* They are commonly used in **monitoring scripts, retry logic, polling APIs, or waiting for services in DevOps automation**.
* This script demonstrates a simple **countdown from 10 to 1**, which is similar to countdown timers used before deployments or job retries.

---

### ⚙️ Purpose / How it works

* `count=10` → Initialize the counter.
* `while [ $count -gt 0 ]` → Loop runs while the value is **greater than 0**.
* `echo` → Prints the current number.
* `((count--))` → Decreases the counter by 1.

---

### 🧩 Bash Script

```bash
#!/bin/bash

count=10

while [ $count -gt 0 ]
do
  echo $count
  ((count--))
done
```

---

### ▶️ How to Run

```bash
# create script
vim countdown.sh

# give execute permission
chmod +x countdown.sh

# run script
./countdown.sh
```

---

### 🔍 Example Output

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

### 📋 Operators Used in While Loop

| Operator | Meaning      | Example             |
| -------- | ------------ | ------------------- |
| `-gt`    | Greater than | `[ $count -gt 0 ]`  |
| `-lt`    | Less than    | `[ $count -lt 10 ]` |
| `-eq`    | Equal        | `[ $count -eq 5 ]`  |
| `-ne`    | Not equal    | `[ $count -ne 0 ]`  |

---

### ✅ Best Practices

* Always **initialize variables before loops**.
* Ensure loop conditions eventually become **false to avoid infinite loops**.
* `while` loops are useful for **waiting on services, retrying commands, and monitoring processes**.

Example DevOps retry loop:

```bash
count=5
while [ $count -gt 0 ]
do
  curl -f http://service:8080 && break
  echo "Retrying..."
  sleep 5
  ((count--))
done
```

---

### 💡 In short

* `while` loop runs **until a condition becomes false**.
* Counter starts at **10 and decreases each iteration**.
* Prints a **countdown from 10 to 1**.

---
## Q13: Write a bash script that uses `if-else` to check if a number is even or odd

### 🧠 Overview

* Conditional statements like `if-else` are fundamental in **Bash automation scripts**.
* They allow scripts to make **decisions based on conditions**, which is common in **CI/CD pipelines, validation scripts, and deployment logic**.
* This script checks whether a **given number is even or odd** using the **modulus (`%`) operator**.

---

### ⚙️ Purpose / How it works

* `$1` → Reads the number passed as a command-line argument.
* `%` (modulus operator) → Returns the remainder after division.
* If `number % 2 == 0`, the number is **even**, otherwise it is **odd**.

---

### 🧩 Bash Script

```bash
#!/bin/bash

num=$1

# Check if input is provided
if [ -z "$num" ]; then
  echo "Usage: $0 <number>"
  exit 1
fi

# Check if number is even or odd
if (( num % 2 == 0 ))
then
  echo "$num is Even"
else
  echo "$num is Odd"
fi
```

---

### ▶️ How to Run

```bash
# create script
vim even_odd.sh

# give execute permission
chmod +x even_odd.sh

# run script
./even_odd.sh 10
```

---

### 🔍 Example Output

```
10 is Even
```

Another example:

```
./even_odd.sh 7
```

Output:

```
7 is Odd
```

---

### 📋 Operators Used

| Operator | Meaning               | Example              |
| -------- | --------------------- | -------------------- |
| `%`      | Modulus (remainder)   | `10 % 2`             |
| `==`     | Equal comparison      | `num == 0`           |
| `(( ))`  | Arithmetic evaluation | `(( num % 2 == 0 ))` |
| `-z`     | Check empty input     | `[ -z "$num" ]`      |

---

### ✅ Best Practices

* Always validate **input arguments** before performing calculations.
* Use `(( ))` for **numeric comparisons in Bash** instead of `[ ]`.
* Add **clear error messages** for better script usability.
* Such checks are often used in **validation steps of automation scripts**.

---

### 💡 In short

* Script takes a **number as input**.
* Uses modulus (`%`) to check remainder after division by 2.
* If remainder is **0 → even**, otherwise **odd**.

----
## Q14: Write a bash script that uses a `case` statement to display the day of the week based on a number (1–7)

### 🧠 Overview

* The `case` statement in Bash is used for **multi-condition branching**, similar to a `switch` statement in other languages.
* It is commonly used in **automation scripts, CLI tools, and menu-driven scripts** where multiple input values must be handled.
* This script takes a **number (1–7)** and displays the corresponding **day of the week**.

---

### ⚙️ Purpose / How it works

* `$1` → Reads the first command-line argument (the number).
* `case` → Matches the number against predefined options.
* `;;` → Ends each case block.
* `*` → Default case for invalid input.

---

### 🧩 Bash Script

```bash
#!/bin/bash

day=$1

# Check if input is provided
if [ -z "$day" ]; then
  echo "Usage: $0 <number 1-7>"
  exit 1
fi

case $day in
  1) echo "Monday" ;;
  2) echo "Tuesday" ;;
  3) echo "Wednesday" ;;
  4) echo "Thursday" ;;
  5) echo "Friday" ;;
  6) echo "Saturday" ;;
  7) echo "Sunday" ;;
  *) echo "Invalid input. Please enter a number between 1 and 7." ;;
esac
```

---

### ▶️ How to Run

```bash
# create script
vim day_of_week.sh

# give execute permission
chmod +x day_of_week.sh

# run script
./day_of_week.sh 3
```

---

### 🔍 Example Output

```
Wednesday
```

Example with invalid input:

```
./day_of_week.sh 9
```

Output:

```
Invalid input. Please enter a number between 1 and 7.
```

---

### 📋 `case` Syntax Breakdown

| Part               | Purpose            | Example              |
| ------------------ | ------------------ | -------------------- |
| `case variable in` | Start case block   | `case $day in`       |
| `pattern)`         | Matching condition | `1)`                 |
| `;;`               | End of case option | `echo Monday ;;`     |
| `*`                | Default option     | `*) echo Invalid ;;` |

---

### ✅ Best Practices

* Always include a **default case (`*`)** to handle invalid inputs.
* Use `case` instead of multiple `if-else` statements for **cleaner logic when many conditions exist**.
* Useful in **CLI menu scripts, environment selection (dev/test/prod), and deployment options**.

Example DevOps menu:

```bash
case $env in
  dev) echo "Deploying to Development" ;;
  stage) echo "Deploying to Staging" ;;
  prod) echo "Deploying to Production" ;;
  *) echo "Invalid environment" ;;
esac
```

---

### 💡 In short

* `case` handles **multiple input conditions cleanly**.
* Script maps numbers **1–7 to days of the week**.
* Includes a **default case for invalid input**.

---
## Q15: Write a bash script using a `for` loop to iterate through an array of server names and ping each one

### 🧠 Overview

* In DevOps and infrastructure monitoring, scripts often **check server availability or health status**.
* Bash arrays allow storing **multiple server names or IP addresses**, and loops can iterate through them.
* This script loops through a list of servers and **pings each server to check if it is reachable**.

---

### ⚙️ Purpose / How it works

* `servers=(...)` → Defines an array of server names or IP addresses.
* `for server in "${servers[@]}"` → Iterates through each server.
* `ping -c 1` → Sends **1 ICMP request** to check connectivity.
* Exit status (`$?`) determines whether the server is **reachable or not**.

---

### 🧩 Bash Script

```bash
#!/bin/bash

servers=("google.com" "github.com" "localhost")

for server in "${servers[@]}"
do
  echo "Pinging $server..."

  ping -c 1 $server > /dev/null 2>&1

  if [ $? -eq 0 ]; then
    echo "$server is reachable"
  else
    echo "$server is not reachable"
  fi

  echo "-----------------------------"
done
```

---

### ▶️ How to Run

```bash
# create script
vim ping_servers.sh

# give execute permission
chmod +x ping_servers.sh

# run script
./ping_servers.sh
```

---

### 🔍 Example Output

```
Pinging google.com...
google.com is reachable
-----------------------------

Pinging github.com...
github.com is reachable
-----------------------------

Pinging localhost...
localhost is reachable
-----------------------------
```

---

### 📋 Key Bash Concepts Used

| Concept     | Purpose                         | Example                    |
| ----------- | ------------------------------- | -------------------------- |
| Array       | Store multiple values           | `servers=("a" "b" "c")`    |
| `for` loop  | Iterate through items           | `for s in "${servers[@]}"` |
| `ping -c 1` | Send one ping request           | `ping -c 1 google.com`     |
| `$?`        | Exit status of previous command | `0 = success`              |

---

### ✅ Best Practices

* Use `> /dev/null 2>&1` to **suppress ping output** and keep logs clean.
* Limit ping count with `-c 1` to avoid delays.
* Store servers in **arrays or external configuration files** for scalability.
* Useful in **health check scripts, monitoring tools, and deployment validation**.

Example infrastructure health check:

```bash
servers=("app1" "app2" "db1")

for server in "${servers[@]}"
do
  ping -c 1 $server >/dev/null && echo "$server OK" || echo "$server DOWN"
done
```

---

### 💡 In short

* Script stores server names in an **array**.
* Uses a **for loop** to iterate through them.
* `ping` checks whether each server is **reachable or not**.

----
## Q16: Write a bash script to create a multiplication table for a given number using loops

### 🧠 Overview

* Bash scripts often use loops to perform **repetitive calculations or automation tasks**.
* A multiplication table example demonstrates how **numeric operations and loops** work in Bash.
* Similar looping logic is used in **batch processing, automation scripts, and CI/CD iteration tasks**.

---

### ⚙️ Purpose / How it works

* `$1` → Reads the number passed as a command-line argument.
* `for` loop → Iterates from **1 to 10**.
* `(( ))` → Performs arithmetic calculation in Bash.
* `echo` → Displays the multiplication result.

---

### 🧩 Bash Script

```bash
#!/bin/bash

num=$1

# Check if input number is provided
if [ -z "$num" ]; then
  echo "Usage: $0 <number>"
  exit 1
fi

echo "Multiplication Table for $num"
echo "-----------------------------"

for i in {1..10}
do
  result=$((num * i))
  echo "$num x $i = $result"
done
```

---

### ▶️ How to Run

```bash
# create script
vim multiplication_table.sh

# give execute permission
chmod +x multiplication_table.sh

# run script
./multiplication_table.sh 5
```

---

### 🔍 Example Output

```
Multiplication Table for 5
-----------------------------
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

### 📋 Key Bash Concepts

| Concept    | Purpose                | Example            |
| ---------- | ---------------------- | ------------------ |
| `$1`       | Command-line argument  | `num=$1`           |
| `for` loop | Iterate values         | `for i in {1..10}` |
| `$(( ))`   | Arithmetic calculation | `$((num * i))`     |
| `echo`     | Print output           | `echo "$num x $i"` |

---

### ✅ Best Practices

* Always validate **user input** before calculations.
* Use `(( ))` for **efficient numeric operations** in Bash.
* Add formatted output to improve **script readability**.
* Similar loop patterns are used in **automation scripts and batch processing tasks**.

---

### 💡 In short

* Script accepts a **number as input**.
* Uses a **for loop from 1 to 10**.
* Calculates multiplication using `$((num * i))`.

----
## Q17: Write a bash script that accepts two numbers and performs addition, subtraction, multiplication, and division based on user choice

### 🧠 Overview

* Bash scripts can implement **simple command-line calculators** using arithmetic operations and conditional logic.
* This pattern is commonly used in **interactive scripts, CLI utilities, and automation tools** where user input determines the operation.
* The script takes **two numbers and an operation choice**, then performs the selected calculation.

---

### ⚙️ Purpose / How it works

* `read` → Accepts user input from the terminal.
* `case` → Selects the operation based on user choice.
* `$(( ))` → Performs arithmetic operations.
* The script supports **addition, subtraction, multiplication, and division**.

---

### 🧩 Bash Script

```bash
#!/bin/bash

# Read two numbers
read -p "Enter first number: " num1
read -p "Enter second number: " num2

echo "Choose operation:"
echo "1) Addition"
echo "2) Subtraction"
echo "3) Multiplication"
echo "4) Division"

read -p "Enter choice (1-4): " choice

case $choice in
  1)
    result=$((num1 + num2))
    echo "Result: $result"
    ;;
  2)
    result=$((num1 - num2))
    echo "Result: $result"
    ;;
  3)
    result=$((num1 * num2))
    echo "Result: $result"
    ;;
  4)
    if [ $num2 -eq 0 ]; then
      echo "Error: Division by zero not allowed"
    else
      result=$((num1 / num2))
      echo "Result: $result"
    fi
    ;;
  *)
    echo "Invalid choice"
    ;;
esac
```

---

### ▶️ How to Run

```bash
# create script
vim calculator.sh

# give execute permission
chmod +x calculator.sh

# run script
./calculator.sh
```

---

### 🔍 Example Execution

```
Enter first number: 10
Enter second number: 5
Choose operation:
1) Addition
2) Subtraction
3) Multiplication
4) Division
Enter choice (1-4): 1
Result: 15
```

---

### 📋 Arithmetic Operators in Bash

| Operator | Operation      | Example      |
| -------- | -------------- | ------------ |
| `+`      | Addition       | `$((a + b))` |
| `-`      | Subtraction    | `$((a - b))` |
| `*`      | Multiplication | `$((a * b))` |
| `/`      | Division       | `$((a / b))` |
| `%`      | Modulus        | `$((a % b))` |

---

### ✅ Best Practices

* Always validate **user input** before performing calculations.
* Handle **division by zero errors** to avoid script failures.
* Use `case` instead of multiple `if` conditions for **cleaner operation selection**.
* Similar patterns are used in **menu-driven automation scripts and CLI tools**.

---

### 💡 In short

* Script reads **two numbers and an operation choice**.
* Uses `case` to select the arithmetic operation.
* Performs calculations using Bash arithmetic `$(( ))`.

---
## Q18: Write a bash script using nested loops to create a 5×5 pattern of asterisks (`*`)

### 🧠 Overview

* Nested loops are used when a task requires **multiple levels of iteration**, such as generating patterns, processing matrices, or iterating through rows and columns.
* In Bash scripting, nested loops are commonly used for **pattern printing, batch operations, and structured data processing**.
* This script uses **two `for` loops** to print a **5×5 grid of asterisks**.

---

### ⚙️ Purpose / How it works

* **Outer loop** → Controls the number of rows (5 rows).
* **Inner loop** → Prints `*` characters in each row (5 columns).
* `echo -n` → Prints output on the same line without a newline.
* `echo` → Moves to the next line after each row.

---

### 🧩 Bash Script

```bash
#!/bin/bash

for i in {1..5}
do
  for j in {1..5}
  do
    echo -n "* "
  done
  echo
done
```

---

### ▶️ How to Run

```bash
# create script
vim star_pattern.sh

# give execute permission
chmod +x star_pattern.sh

# run script
./star_pattern.sh
```

---

### 🔍 Example Output

```
* * * * *
* * * * *
* * * * *
* * * * *
* * * * *
```

---

### 📋 Loop Structure

| Loop       | Purpose              | Example           |
| ---------- | -------------------- | ----------------- |
| Outer Loop | Controls rows        | `for i in {1..5}` |
| Inner Loop | Prints stars per row | `for j in {1..5}` |
| `echo -n`  | Prevent newline      | `echo -n "* "`    |
| `echo`     | Move to next line    | `echo`            |

---

### ✅ Best Practices

* Use **nested loops** when working with **row-column structures**.
* Use `echo -n` to **control output formatting**.
* Prefer `{1..N}` syntax for **fixed loop ranges** because it is simple and efficient.
* Nested loops are useful in **automation tasks that process multiple dimensions of data**.

---

### 💡 In short

* Uses **two loops**: one for rows and one for columns.
* Inner loop prints `*`, outer loop moves to the next row.
* Produces a **5×5 star pattern**.

----
## Q19: Write a bash script to find the largest number in an array of integers

### 🧠 Overview

* Arrays in Bash allow storing **multiple values in a single variable**, which is useful for processing lists of numbers, servers, files, etc.
* In automation scripts, arrays are often used for **resource lists (servers, containers, files)** and loops process them to find values like **maximum, minimum, or status checks**.
* This script iterates through an **array of integers and determines the largest value**.

---

### ⚙️ Purpose / How it works

* `numbers=(...)` → Defines an array of integers.
* `max=${numbers[0]}` → Assumes the first element as the initial maximum.
* `for` loop → Iterates through each number in the array.
* `if (( num > max ))` → Updates the maximum value if a larger number is found.

---

### 🧩 Bash Script

```bash
#!/bin/bash

numbers=(12 45 7 89 34 56)

max=${numbers[0]}

for num in "${numbers[@]}"
do
  if (( num > max ))
  then
    max=$num
  fi
done

echo "Largest number is: $max"
```

---

### ▶️ How to Run

```bash
# create script
vim largest_number.sh

# give execute permission
chmod +x largest_number.sh

# run script
./largest_number.sh
```

---

### 🔍 Example Output

```
Largest number is: 89
```

---

### 📋 Bash Array Concepts

| Concept            | Purpose               | Example                |
| ------------------ | --------------------- | ---------------------- |
| Array declaration  | Store multiple values | `arr=(1 2 3)`          |
| Access element     | Access specific index | `${arr[0]}`            |
| All elements       | Access all values     | `${arr[@]}`            |
| Loop through array | Iterate values        | `for i in "${arr[@]}"` |

---

### ✅ Best Practices

* Initialize the maximum value with the **first array element**.
* Use `(( ))` for **numeric comparison** in Bash.
* Quote `"${array[@]}"` to prevent word-splitting issues.
* Arrays are useful in **DevOps scripts for server lists, container IDs, and file collections**.

Example DevOps scenario:

```bash
servers=(app1 app2 app3)
for s in "${servers[@]}"
do
  echo "Checking $s"
done
```

---

### 💡 In short

* Store numbers in a **Bash array**.
* Loop through each number.
* Update `max` whenever a **larger number is found**.

---
## Q20: Write a bash script to read a CSV file and display specific columns

### 🧠 Overview

* CSV (Comma-Separated Values) files are widely used for **logs, reports, datasets, and configuration exports**.
* In DevOps workflows, scripts often process CSV files generated from **monitoring tools, cloud exports, or pipeline reports**.
* This script reads a **CSV file line by line** and prints **specific columns** (for example: column 1 and column 3).

---

### ⚙️ Purpose / How it works

* `IFS=','` → Sets the delimiter as a comma.
* `read` → Reads CSV fields into variables.
* `while` loop → Processes the file line by line.
* Displays selected columns.

---

### 🧩 Bash Script

```bash
#!/bin/bash

FILE=$1

# Check if file argument is provided
if [ -z "$FILE" ]; then
  echo "Usage: $0 <csv_file>"
  exit 1
fi

# Check if file exists
if [ ! -f "$FILE" ]; then
  echo "File does not exist."
  exit 1
fi

echo "Displaying selected columns from $FILE"

while IFS=',' read -r col1 col2 col3 col4
do
  echo "Column1: $col1 | Column3: $col3"
done < "$FILE"
```

---

### ▶️ How to Run

```bash
# create script
vim read_csv.sh

# give execute permission
chmod +x read_csv.sh

# run script
./read_csv.sh data.csv
```

---

### 🔍 Example CSV File (`data.csv`)

```
ID,Name,Department,Salary
1,Alice,DevOps,80000
2,Bob,Cloud,75000
3,Charlie,Security,82000
```

---

### 🔍 Example Output

```
Column1: ID | Column3: Department
Column1: 1 | Column3: DevOps
Column1: 2 | Column3: Cloud
Column1: 3 | Column3: Security
```

---

### 📋 Key Bash Concepts

| Concept      | Purpose                   | Example               |
| ------------ | ------------------------- | --------------------- |
| `IFS=','`    | Set delimiter             | `IFS=',' read`        |
| `read`       | Read file fields          | `read col1 col2 col3` |
| `while` loop | Process file line by line | `while read line`     |
| `< file`     | Redirect file input       | `done < file.csv`     |

---

### ✅ Best Practices

* Always check if the **CSV file exists before reading**.
* Use `IFS=','` to correctly **split columns by commas**.
* Avoid `cat file | while read` because it runs in a **subshell**.
* Useful in **processing reports, parsing logs, and automation scripts**.

Example quick method using `awk`:

```bash
awk -F',' '{print $1, $3}' data.csv
```

---

### 💡 In short

* Script reads a **CSV file line by line**.
* Uses `IFS=','` to split columns.
* Prints **selected columns (1 and 3)**.

---
## Q21: Write a bash function that takes a directory path as a parameter and returns the total size of all files in MB

### 🧠 Overview

* Bash **functions** help modularize scripts and reuse logic across automation workflows.
* In DevOps environments, functions are commonly used in **deployment scripts, cleanup jobs, and storage monitoring tools**.
* This function accepts a **directory path as input** and calculates the **total size of all files inside the directory in MB**.

---

### ⚙️ Purpose / How it works

* `du -sb` → Calculates the total size of a directory in **bytes**.
* `awk` → Converts bytes into **megabytes (MB)**.
* Function accepts a **directory path parameter** and prints the size.

---

### 🧩 Bash Script with Function

```bash
#!/bin/bash

get_directory_size() {
  dir=$1

  # Check if directory exists
  if [ ! -d "$dir" ]; then
    echo "Directory does not exist."
    return 1
  fi

  size_bytes=$(du -sb "$dir" | awk '{print $1}')
  size_mb=$(awk "BEGIN {printf \"%.2f\", $size_bytes/1024/1024}")

  echo "Total size of $dir: $size_mb MB"
}

# Call the function with argument
get_directory_size "$1"
```

---

### ▶️ How to Run

```bash
# create script
vim dir_size.sh

# give execute permission
chmod +x dir_size.sh

# run script
./dir_size.sh /var/log
```

---

### 🔍 Example Output

```
Total size of /var/log: 120.45 MB
```

---

### 📋 Commands Used

| Command       | Purpose                     | Example              |
| ------------- | --------------------------- | -------------------- |
| `du -sb`      | Get directory size in bytes | `du -sb /var/log`    |
| `awk`         | Process numeric output      | `awk '{print $1}'`   |
| Bash function | Reusable logic block        | `function_name() {}` |
| `$1`          | Function argument           | `dir=$1`             |

---

### ✅ Best Practices

* Always **validate directory existence** before processing.
* Use functions for **modular, reusable DevOps scripts**.
* Convert output to **human-readable units (MB/GB)** for reporting.
* Useful in **disk usage monitoring, log cleanup automation, and CI/CD workspace size checks**.

Example monitoring snippet:

```bash
if [ $(du -sm /var/log | awk '{print $1}') -gt 500 ]; then
  echo "Warning: Log directory size exceeded 500MB"
fi
```

---

### 💡 In short

* Bash function accepts a **directory path parameter**.
* Uses `du` to calculate size and converts it to **MB**.
* Useful for **disk usage monitoring and automation scripts**.

---
## Q22: Write a bash function that accepts a string and returns it in reverse order

### 🧠 Overview

* Bash functions allow reusable logic inside scripts, useful in **automation pipelines, log processing, and string manipulation tasks**.
* Reversing a string demonstrates **basic string operations and loop processing** in Bash.
* Such techniques are used when **processing log data, formatting outputs, or transforming inputs in scripts**.

---

### ⚙️ Purpose / How it works

* The function takes a **string as input parameter**.
* It loops from the **last character to the first**.
* Each character is appended to build the **reversed string**.
* Finally, the function prints the reversed result.

---

### 🧩 Bash Script with Function

```bash
#!/bin/bash

reverse_string() {
  str="$1"
  rev=""

  for (( i=${#str}-1; i>=0; i-- ))
  do
    rev="$rev${str:$i:1}"
  done

  echo "$rev"
}

# Read input
read -p "Enter a string: " input

# Call function
result=$(reverse_string "$input")

echo "Reversed string: $result"
```

---

### ▶️ How to Run

```bash
# create script
vim reverse_string.sh

# give execute permission
chmod +x reverse_string.sh

# run script
./reverse_string.sh
```

---

### 🔍 Example Execution

```
Enter a string: DevOps
Reversed string: spOveD
```

---

### 📋 Key Bash Concepts

| Concept          | Purpose                | Example                |
| ---------------- | ---------------------- | ---------------------- |
| Function         | Reusable block of code | `reverse_string() {}`  |
| `${#var}`        | Length of string       | `${#str}`              |
| `${var:index:1}` | Extract character      | `${str:$i:1}`          |
| `for (( ))`      | C-style loop           | `for ((i=5;i>=0;i--))` |

---

### ✅ Best Practices

* Always **quote variables** (`"$input"`) to prevent issues with spaces.
* Use functions to keep scripts **modular and reusable**.
* Useful for **string transformations in automation scripts or log parsing tasks**.

Alternative simple method using `rev` command:

```bash
echo "$input" | rev
```

---

### 💡 In short

* Function accepts a **string input**.
* Iterates from **last character to first** using a loop.
* Builds and prints the **reversed string**.

----
## Q23: Write a bash function with required and optional parameters that calculates the area of a rectangle

### 🧠 Overview

* Bash functions can accept **required and optional parameters**, making scripts flexible and reusable.
* In automation scripts, optional parameters are useful for **default values, environment configs, or optional flags**.
* This function calculates the **area of a rectangle** using **length (required)** and **width (optional)**. If width is not provided, it defaults to **1**.

---

### ⚙️ Purpose / How it works

* `$1` → Required parameter (length).
* `$2` → Optional parameter (width).
* `${2:-1}` → Assigns a **default value (1)** if width is not provided.
* `$(( ))` → Performs arithmetic calculation.

---

### 🧩 Bash Script with Function

```bash
#!/bin/bash

calculate_area() {
  length=$1
  width=${2:-1}

  area=$((length * width))

  echo "Length: $length"
  echo "Width: $width"
  echo "Area of rectangle: $area"
}

# Call function with arguments
calculate_area "$@"
```

---

### ▶️ How to Run

```bash
# create script
vim rectangle_area.sh

# give execute permission
chmod +x rectangle_area.sh

# run script with both parameters
./rectangle_area.sh 10 5
```

---

### 🔍 Example Output

```
Length: 10
Width: 5
Area of rectangle: 50
```

---

### 🔍 Example with Optional Parameter

```bash
./rectangle_area.sh 10
```

Output:

```
Length: 10
Width: 1
Area of rectangle: 10
```

---

### 📋 Parameter Handling in Bash

| Syntax            | Meaning                | Example         |
| ----------------- | ---------------------- | --------------- |
| `$1`              | First argument         | `length=$1`     |
| `$2`              | Second argument        | `width=$2`      |
| `${var:-default}` | Default value if empty | `${2:-1}`       |
| `$@`              | All arguments          | `function "$@"` |

---

### ✅ Best Practices

* Always validate **required parameters** before using them.
* Use `${var:-default}` to provide **safe defaults**.
* Keep functions **modular and reusable** in automation scripts.
* Useful in **DevOps scripts where optional parameters control behavior (env, region, cluster name)**.

Example DevOps-style function:

```bash
deploy_app() {
  env=$1
  region=${2:-us-east-1}
  echo "Deploying to $env in region $region"
}
```

---

### 💡 In short

* Function takes **length (required)** and **width (optional)**.
* Uses `${2:-1}` to assign a **default width**.
* Calculates rectangle area using `$((length * width))`.

---
## Q24: Write a bash function that validates if a given IP address is valid and returns 0 (success) or 1 (failure)

### 🧠 Overview

* In DevOps and infrastructure automation, validating IP addresses is important when working with **server inventories, network configurations, or deployment scripts**.
* Bash functions can perform validation and return **exit codes** (`0 = success`, `1 = failure`).
* This function checks whether a string is a **valid IPv4 address (format: x.x.x.x where each octet is 0–255)**.

---

### ⚙️ Purpose / How it works

* Uses **regex** to check the IPv4 format.
* Splits the IP using `IFS='.'` into **four octets**.
* Validates each octet to ensure it is **between 0 and 255**.
* Returns `0` if valid, otherwise returns `1`.

---

### 🧩 Bash Script with Function

```bash
#!/bin/bash

validate_ip() {
  local ip=$1
  local IFS='.'
  local -a octets

  # Check basic IPv4 format
  if [[ ! $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    return 1
  fi

  # Split IP into octets
  read -ra octets <<< "$ip"

  for octet in "${octets[@]}"
  do
    if (( octet < 0 || octet > 255 )); then
      return 1
    fi
  done

  return 0
}

# Example usage
ip=$1

validate_ip "$ip"

if [ $? -eq 0 ]; then
  echo "Valid IP address"
else
  echo "Invalid IP address"
fi
```

---

### ▶️ How to Run

```bash
# create script
vim validate_ip.sh

# give execute permission
chmod +x validate_ip.sh

# run script
./validate_ip.sh 192.168.1.10
```

---

### 🔍 Example Output

Valid IP:

```
Valid IP address
```

Invalid IP:

```
./validate_ip.sh 300.10.1.5
Invalid IP address
```

---

### 📋 Key Bash Concepts

| Concept   | Purpose             | Example              |
| --------- | ------------------- | -------------------- |
| Regex     | Validate IP format  | `[[ $ip =~ regex ]]` |
| `IFS='.'` | Split string by dot | `read -ra octets`    |
| Array     | Store IP octets     | `"${octets[@]}"`     |
| `return`  | Function exit code  | `return 0`           |

---

### ✅ Best Practices

* Always validate **input format first using regex**.
* Check **numeric ranges (0–255)** for each octet.
* Use `return` codes so functions integrate easily with **automation pipelines**.
* Useful for **server validation in deployment scripts or inventory checks**.

Example automation usage:

```bash
validate_ip "$server_ip" || { echo "Invalid IP provided"; exit 1; }
```

---

### 💡 In short

* Function checks IPv4 format using **regex**.
* Splits the IP into **four octets** and validates the range **0–255**.
* Returns **0 if valid**, **1 if invalid**.

----
## Q25: Write a bash function that accepts multiple server names as parameters and tests connectivity to each using `ping`

### 🧠 Overview

* In DevOps and infrastructure management, connectivity checks are often required to verify **server availability, network reachability, or deployment readiness**.
* Bash functions can accept **multiple parameters (`$@`)**, allowing scripts to process lists of servers dynamically.
* This function iterates through **multiple server names or IPs** and checks connectivity using `ping`.

---

### ⚙️ Purpose / How it works

* `$@` → Represents **all parameters passed to the function**.
* `for server in "$@"` → Iterates through each server argument.
* `ping -c 1` → Sends **one ICMP packet** to test connectivity.
* Exit code (`$?`) determines whether the server is **reachable or not**.

---

### 🧩 Bash Script with Function

```bash
#!/bin/bash

check_servers() {
  for server in "$@"
  do
    echo "Checking connectivity to $server..."

    if ping -c 1 "$server" > /dev/null 2>&1
    then
      echo "$server is reachable"
    else
      echo "$server is not reachable"
    fi

    echo "---------------------------"
  done
}

# Call function with multiple servers
check_servers "$@"
```

---

### ▶️ How to Run

```bash
# create script
vim check_servers.sh

# give execute permission
chmod +x check_servers.sh

# run script
./check_servers.sh google.com github.com localhost
```

---

### 🔍 Example Output

```
Checking connectivity to google.com...
google.com is reachable
---------------------------

Checking connectivity to github.com...
github.com is reachable
---------------------------

Checking connectivity to localhost...
localhost is reachable
---------------------------
```

---

### 📋 Bash Parameter Concepts

| Parameter | Meaning                      | Example                     |
| --------- | ---------------------------- | --------------------------- |
| `$1`      | First argument               | `server1`                   |
| `$2`      | Second argument              | `server2`                   |
| `$@`      | All arguments                | `"server1 server2 server3"` |
| `"$@"`    | Preserve argument separation | `for s in "$@"`             |

---

### ✅ Best Practices

* Use `ping -c 1` to avoid long delays during checks.
* Redirect output to `/dev/null` to keep logs clean.
* Accept **multiple servers via parameters or configuration files**.
* Useful for **health checks, deployment validation, and monitoring scripts**.

Example infrastructure health check snippet:

```bash
servers=("app1" "app2" "db1")

check_servers "${servers[@]}"
```

---

### 💡 In short

* Function accepts **multiple server names using `$@`**.
* Loops through each server.
* Uses `ping` to verify **network connectivity**.

---
## Q26: Write a bash script to create a new user on a Linux system and add that user to the sudo group

### 🧠 Overview

* In Linux system administration and DevOps automation, scripts are often used to **provision users automatically on servers**.
* This script creates a **new user account** and adds the user to the **sudo group**, allowing the user to execute commands with administrative privileges.
* Such automation is commonly used in **server provisioning, cloud instance initialization, and configuration management workflows**.

---

### ⚙️ Purpose / How it works

* `useradd` → Creates a new Linux user account.
* `passwd` → Sets the password for the user.
* `usermod -aG sudo` → Adds the user to the **sudo group**.
* Script requires **root privileges** to execute.

---

### 🧩 Bash Script

```bash
#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

read -p "Enter new username: " username

# Create user
useradd -m "$username"

# Set password
passwd "$username"

# Add user to sudo group
usermod -aG sudo "$username"

echo "User $username created and added to sudo group successfully."
```

---

### ▶️ How to Run

```bash
# create script
vim create_user.sh

# give execute permission
chmod +x create_user.sh

# run script with sudo
sudo ./create_user.sh
```

---

### 🔍 Example Execution

```
Enter new username: devuser
New password:
Retype new password:
User devuser created and added to sudo group successfully.
```

---

### 📋 Commands Used

| Command            | Purpose                         | Example                    |
| ------------------ | ------------------------------- | -------------------------- |
| `useradd -m`       | Create user with home directory | `useradd -m devuser`       |
| `passwd`           | Set user password               | `passwd devuser`           |
| `usermod -aG sudo` | Add user to sudo group          | `usermod -aG sudo devuser` |
| `$EUID`            | Check effective user ID         | `$EUID -ne 0`              |

---

### ✅ Best Practices

* Always verify the script runs with **root privileges**.
* Use `-m` with `useradd` to automatically create the **home directory**.
* Avoid overwriting existing users; check if the user exists before creating.
* In DevOps environments, user provisioning is often automated using **Ansible, Terraform, or cloud-init**.

Example quick manual command:

```bash
sudo useradd -m devuser && sudo usermod -aG sudo devuser
```

---

### 💡 In short

* Script creates a **new Linux user**.
* Sets the password and **adds the user to the sudo group**.
* Must be executed with **root or sudo privileges**.

---
## Q27: Write a bash script to create multiple users from a text file (one username per line) and set default passwords

### 🧠 Overview

* In DevOps and Linux system administration, bulk user creation is often required during **server provisioning, onboarding, or lab setup**.
* This script reads a **text file containing usernames (one per line)** and creates each user automatically.
* It also sets a **default password** for each user and forces them to **change it on first login**.

---

### ⚙️ Purpose / How it works

* `while read username` → Reads usernames from a file line by line.
* `useradd -m` → Creates the user and home directory.
* `echo "user:password" | chpasswd` → Sets the default password.
* `passwd -e` → Forces password change on first login.
* Script must be run with **root privileges**.

---

### 🧩 Bash Script

```bash
#!/bin/bash

FILE=$1
DEFAULT_PASS="Password@123"

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

# Check if file exists
if [ ! -f "$FILE" ]; then
  echo "User file not found."
  exit 1
fi

while read username
do
  if id "$username" &>/dev/null; then
    echo "User $username already exists."
  else
    useradd -m "$username"
    echo "$username:$DEFAULT_PASS" | chpasswd
    passwd -e "$username"
    echo "User $username created with default password."
  fi
done < "$FILE"
```

---

### ▶️ Example Input File (`users.txt`)

```
devuser1
devuser2
devuser3
```

---

### ▶️ How to Run

```bash
# create script
vim create_users.sh

# give execute permission
chmod +x create_users.sh

# run script
sudo ./create_users.sh users.txt
```

---

### 🔍 Example Output

```
User devuser1 created with default password.
User devuser2 created with default password.
User devuser3 created with default password.
```

---

### 📋 Commands Used

| Command      | Purpose                         | Example              |           |
| ------------ | ------------------------------- | -------------------- | --------- |
| `useradd -m` | Create user with home directory | `useradd -m devuser` |           |
| `chpasswd`   | Set password from stdin         | `echo "user:pass"    | chpasswd` |
| `passwd -e`  | Force password change           | `passwd -e user`     |           |
| `id user`    | Check if user exists            | `id devuser`         |           |

---

### ✅ Best Practices

* Always check if the **user already exists** before creating.
* Use **strong default passwords** and force password change with `passwd -e`.
* Run user management scripts with **root privileges only**.
* In production, user management is often automated using **Ansible, LDAP, or IAM systems**.

Example DevOps-style check:

```bash
id "$username" &>/dev/null || useradd -m "$username"
```

---

### 💡 In short

* Script reads usernames from a **text file**.
* Creates each user with **`useradd -m`**.
* Sets a **default password** and forces change on first login.

---
## Q28: Write a bash script to delete a user and their home directory

### 🧠 Overview

* In Linux system administration and DevOps automation, user management tasks such as **removing inactive users or cleaning up test accounts** are common.
* This script deletes a **specified user account and their home directory** from the system.
* It is useful in **server maintenance, automated lab cleanup, and user lifecycle management scripts**.

---

### ⚙️ Purpose / How it works

* `userdel` → Removes a user account from the system.
* `-r` option → Deletes the user's **home directory and mail spool**.
* The script validates **root privileges and username input** before deleting the user.

---

### 🧩 Bash Script

```bash
#!/bin/bash

username=$1

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Check if username is provided
if [ -z "$username" ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

# Check if user exists
if id "$username" &>/dev/null; then
  userdel -r "$username"
  echo "User $username and their home directory have been deleted."
else
  echo "User $username does not exist."
fi
```

---

### ▶️ How to Run

```bash
# create script
vim delete_user.sh

# give execute permission
chmod +x delete_user.sh

# run script
sudo ./delete_user.sh devuser
```

---

### 🔍 Example Output

```
User devuser and their home directory have been deleted.
```

If the user does not exist:

```
User devuser does not exist.
```

---

### 📋 Commands Used

| Command       | Purpose                      | Example              |
| ------------- | ---------------------------- | -------------------- |
| `userdel`     | Delete a user                | `userdel devuser`    |
| `userdel -r`  | Delete user + home directory | `userdel -r devuser` |
| `id username` | Check if user exists         | `id devuser`         |
| `$EUID`       | Check root privilege         | `$EUID -ne 0`        |

---

### ✅ Best Practices

* Always **check if the user exists before deletion**.
* Run user management scripts only with **root or sudo privileges**.
* Consider backing up important data before removing user accounts.
* In production environments, user lifecycle management is often handled via **IAM systems or configuration management tools (Ansible, Puppet)**.

Example quick command:

```bash
sudo userdel -r devuser
```

---

### 💡 In short

* Script accepts a **username as input**.
* Uses `userdel -r` to **remove the user and their home directory**.
* Requires **root privileges** to execute.

---
## Q29: Write a bash script to list all users who have sudo privileges

### 🧠 Overview

* In Linux administration and DevOps environments, it is important to **audit privileged users** who can execute commands with elevated permissions.
* Users typically gain sudo privileges by being members of the **`sudo` group** (Ubuntu/Debian) or **`wheel` group** (RHEL/CentOS).
* This script lists all users who belong to the **sudo group**, helping with **security audits and privilege management**.

---

### ⚙️ Purpose / How it works

* `getent group sudo` → Retrieves information about the sudo group.
* `cut -d: -f4` → Extracts the **user list** from the group entry.
* `tr ',' '\n'` → Converts comma-separated users into **separate lines**.

---

### 🧩 Bash Script

```bash
#!/bin/bash

echo "Users with sudo privileges:"
echo "---------------------------"

getent group sudo | cut -d: -f4 | tr ',' '\n'
```

---

### ▶️ How to Run

```bash
# create script
vim list_sudo_users.sh

# give execute permission
chmod +x list_sudo_users.sh

# run script
./list_sudo_users.sh
```

---

### 🔍 Example Output

```
Users with sudo privileges:
---------------------------
ubuntu
admin
devuser
```

---

### 📋 Commands Used

| Command        | Purpose                    | Example             |
| -------------- | -------------------------- | ------------------- |
| `getent group` | Retrieve group information | `getent group sudo` |
| `cut -d:`      | Extract specific field     | `cut -d: -f4`       |
| `tr`           | Replace characters         | `tr ',' '\n'`       |

Example raw group output:

```
sudo:x:27:ubuntu,admin,devuser
```

---

### ✅ Best Practices

* Periodically audit **sudo users** for security compliance.
* Restrict sudo privileges using **least privilege principle**.
* Use `sudoers` configuration (`/etc/sudoers` or `/etc/sudoers.d`) for granular control.
* Automate privilege audits in **security monitoring scripts**.

Example command without script:

```bash
getent group sudo | cut -d: -f4
```

---

### 💡 In short

* Script retrieves the **sudo group members**.
* Extracts and displays usernames line by line.
* Useful for **privileged user auditing on Linux systems**.

---
## Q30: Write a bash script to change file permissions recursively for all files in a directory (e.g., 644 for files, 755 for directories)

### 🧠 Overview

* File permissions are critical in Linux systems for **security, access control, and application stability**.
* In DevOps workflows, permission fixes are often required for **application deployments, shared directories, or CI/CD workspaces**.
* This script recursively sets **644 permissions for files** and **755 permissions for directories** in a specified directory.

---

### ⚙️ Purpose / How it works

* `find` → Recursively searches files and directories.
* `-type f` → Targets only files.
* `-type d` → Targets only directories.
* `chmod` → Changes permissions.

Permission meaning:

* **644** → Owner read/write, others read.
* **755** → Owner full access, others read/execute.

---

### 🧩 Bash Script

```bash
#!/bin/bash

DIR=$1

# Check if directory argument is provided
if [ -z "$DIR" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Check if directory exists
if [ ! -d "$DIR" ]; then
  echo "Directory does not exist."
  exit 1
fi

# Set permissions for directories
find "$DIR" -type d -exec chmod 755 {} \;

# Set permissions for files
find "$DIR" -type f -exec chmod 644 {} \;

echo "Permissions updated successfully in $DIR"
```

---

### ▶️ How to Run

```bash
# create script
vim fix_permissions.sh

# give execute permission
chmod +x fix_permissions.sh

# run script
./fix_permissions.sh /var/www/html
```

---

### 🔍 Example

Before:

```
-rwxrwxrwx file1.txt
drwxrwxrwx logs/
```

After running script:

```
-rw-r--r-- file1.txt
drwxr-xr-x logs/
```

---

### 📋 Permission Breakdown

| Permission | Meaning                                                              |
| ---------- | -------------------------------------------------------------------- |
| `644`      | Owner: read/write, Group: read, Others: read                         |
| `755`      | Owner: read/write/execute, Group: read/execute, Others: read/execute |

Numeric permission explanation:

| Value | Permission |
| ----- | ---------- |
| 4     | Read       |
| 2     | Write      |
| 1     | Execute    |

---

### ✅ Best Practices

* Always verify directory path before modifying permissions.
* Avoid `chmod -R 777` in production environments.
* Use **different permissions for files and directories** to maintain proper execution behavior.
* Commonly used during **application deployments (e.g., web servers, shared storage, CI artifacts)**.

Example quick command without script:

```bash
find /var/www -type d -exec chmod 755 {} \;
find /var/www -type f -exec chmod 644 {} \;
```

---

### 💡 In short

* Script recursively finds **directories and files**.
* Applies **755 to directories** and **644 to files**.
* Useful for **fixing permissions after deployments or migrations**.

----
## Q31: Write a bash script to find all files owned by a specific user and change ownership to another user

### 🧠 Overview

* In Linux administration and DevOps environments, file ownership management is critical for **security, application permissions, and user lifecycle management**.
* When users are removed or services migrate, administrators often need to **transfer file ownership from one user to another**.
* This script finds all files owned by a **specific user** and changes ownership to **another user**.

---

### ⚙️ Purpose / How it works

* `find` → Searches files recursively.
* `-user` → Filters files owned by a specific user.
* `chown` → Changes file ownership.
* `-exec` → Executes a command for each matched file.

---

### 🧩 Bash Script

```bash
#!/bin/bash

OLD_USER=$1
NEW_USER=$2
SEARCH_DIR=${3:-/}

# Check arguments
if [ -z "$OLD_USER" ] || [ -z "$NEW_USER" ]; then
  echo "Usage: $0 <old_user> <new_user> [directory]"
  exit 1
fi

echo "Changing ownership from $OLD_USER to $NEW_USER in $SEARCH_DIR"

find "$SEARCH_DIR" -user "$OLD_USER" -exec chown "$NEW_USER" {} \;

echo "Ownership change completed."
```

---

### ▶️ How to Run

```bash
# create script
vim change_owner.sh

# give execute permission
chmod +x change_owner.sh

# run script
sudo ./change_owner.sh olduser newuser /home
```

---

### 🔍 Example Output

```
Changing ownership from devuser1 to devuser2 in /home
Ownership change completed.
```

---

### 📋 Commands Used

| Command | Purpose                  | Example                     |
| ------- | ------------------------ | --------------------------- |
| `find`  | Search files             | `find /home -user olduser`  |
| `-user` | Filter by file owner     | `-user devuser1`            |
| `chown` | Change file ownership    | `chown newuser file.txt`    |
| `-exec` | Execute command per file | `-exec chown newuser {} \;` |

---

### 📋 Optional: Change Ownership Recursively (Faster)

Instead of `find`, you can use:

```bash
sudo chown -R newuser:newuser /home/olduser
```

| Command      | Purpose                    |
| ------------ | -------------------------- |
| `-R`         | Recursive ownership change |
| `user:group` | Set both owner and group   |

---

### ✅ Best Practices

* Always run ownership scripts with **sudo/root privileges**.
* Limit the **search directory** instead of scanning `/` to avoid performance issues.
* Verify files first before changing ownership:

```bash
find /home -user olduser
```

* Useful during **user deprovisioning, server migrations, and application ownership fixes**.

---

### 💡 In short

* Script finds files owned by **old_user**.
* Uses `chown` to change ownership to **new_user**.
* Typically executed with **sudo** for system-wide changes.

----
## Q32: Write a bash script to disable/lock a user account without deleting it

### 🧠 Overview

* In Linux user management, sometimes administrators need to **temporarily disable a user account** without removing it from the system.
* This is common in **security incidents, employee offboarding, or temporary access suspension**.
* The script locks the user account so the user **cannot log in**, but their **files and account data remain intact**.

---

### ⚙️ Purpose / How it works

* `usermod -L` → Locks the user account by disabling the password.
* `passwd -l` → Another method to lock the account password.
* The script checks if the **user exists** and ensures it is run with **root privileges**.

---

### 🧩 Bash Script

```bash id="7klrkl"
#!/bin/bash

username=$1

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Check if username is provided
if [ -z "$username" ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

# Check if user exists
if id "$username" &>/dev/null; then
  usermod -L "$username"
  echo "User account '$username' has been locked."
else
  echo "User '$username' does not exist."
fi
```

---

### ▶️ How to Run

```bash id="ma9o1b"
# create script
vim lock_user.sh

# give execute permission
chmod +x lock_user.sh

# run script
sudo ./lock_user.sh devuser
```

---

### 🔍 Example Output

```id="wvo5ng"
User account 'devuser' has been locked.
```

---

### 📋 Commands Used

| Command       | Purpose              | Example              |
| ------------- | -------------------- | -------------------- |
| `usermod -L`  | Lock user account    | `usermod -L devuser` |
| `passwd -l`   | Lock user password   | `passwd -l devuser`  |
| `id username` | Check if user exists | `id devuser`         |
| `$EUID`       | Check root privilege | `$EUID -ne 0`        |

---

### 📋 Unlock the User Later

To enable the account again:

```bash id="fthrzl"
sudo usermod -U username
```

| Command      | Purpose             |
| ------------ | ------------------- |
| `usermod -U` | Unlock user account |

---

### ✅ Best Practices

* Prefer **locking accounts instead of deleting** when temporary suspension is needed.
* Always verify **active sessions** before locking a user.
* Combine with **SSH key removal or sudo privilege revocation** for better security.
* Maintain logs of **user account state changes for auditing**.

Example quick command:

```bash id="3meu2r"
sudo usermod -L devuser
```

---

### 💡 In short

* Script locks a user using **`usermod -L`**.
* Prevents login but **keeps user data intact**.
* Can be reversed using **`usermod -U`**.

---
## Q33: Write a bash script to check password expiry for all users and list those expiring within 7 days

### 🧠 Overview

* In Linux administration and DevOps security practices, it is important to **monitor password expiration policies** to prevent unexpected login failures.
* The `chage` command allows administrators to **view password aging information** for user accounts.
* This script checks all users and lists those whose **passwords will expire within the next 7 days**, helping with **security audits and proactive alerts**.

---

### ⚙️ Purpose / How it works

* `/etc/passwd` → Contains all system users.
* `cut -d: -f1` → Extracts usernames.
* `chage -l` → Displays password expiry information for a user.
* The script calculates the **days remaining before expiration** and prints users expiring soon.

---

### 🧩 Bash Script

```bash
#!/bin/bash

THRESHOLD=7
TODAY=$(date +%s)

echo "Users with passwords expiring within $THRESHOLD days:"
echo "----------------------------------------------------"

for user in $(cut -d: -f1 /etc/passwd)
do
  expiry=$(chage -l "$user" 2>/dev/null | grep "Password expires" | cut -d: -f2)

  if [[ "$expiry" != " never" ]]; then
    expiry_date=$(date -d "$expiry" +%s 2>/dev/null)

    if [[ -n "$expiry_date" ]]; then
      days_left=$(( (expiry_date - TODAY) / 86400 ))

      if (( days_left <= THRESHOLD && days_left >= 0 )); then
        echo "User: $user | Expires in: $days_left days"
      fi
    fi
  fi
done
```

---

### ▶️ How to Run

```bash
# create script
vim check_password_expiry.sh

# give execute permission
chmod +x check_password_expiry.sh

# run script
sudo ./check_password_expiry.sh
```

---

### 🔍 Example Output

```
Users with passwords expiring within 7 days:
----------------------------------------------------
User: devuser1 | Expires in: 3 days
User: admin    | Expires in: 6 days
```

---

### 📋 Commands Used

| Command    | Purpose                   | Example                   |
| ---------- | ------------------------- | ------------------------- |
| `chage -l` | Show password aging info  | `chage -l devuser`        |
| `cut -d:`  | Extract fields            | `cut -d: -f1 /etc/passwd` |
| `grep`     | Filter output             | `grep "Password expires"` |
| `date -d`  | Convert date to timestamp | `date -d "Jul 10, 2026"`  |

Example manual check:

```bash
chage -l username
```

Example output:

```
Password expires : Jul 10, 2026
```

---

### ✅ Best Practices

* Run password expiry checks **periodically via cron**.
* Notify users or administrators **before password expiration**.
* Exclude **system accounts** when auditing user passwords.
* Integrate with **monitoring or alerting systems**.

Example cron job:

```bash
0 6 * * * /scripts/check_password_expiry.sh
```

Runs **daily at 6 AM**.

---

### 💡 In short

* Script scans all users from `/etc/passwd`.
* Uses `chage` to get password expiry date.
* Lists users whose passwords **expire within 7 days**.

---
## Q34: Write a bash script to add a user to multiple groups at once

### 🧠 Overview

* In Linux system administration and DevOps environments, users often require access to **multiple groups** for services like **Docker, sudo, developers, or monitoring tools**.
* Instead of adding groups one by one, automation scripts can **assign multiple groups at once**.
* This script takes a **username and a list of groups**, then adds the user to all specified groups.

---

### ⚙️ Purpose / How it works

* `usermod -aG` → Adds a user to **supplementary groups**.
* `-a` → Append to existing groups (important to avoid overwriting).
* `-G` → Specifies group list separated by commas.
* Script validates **root privileges and user existence** before execution.

---

### 🧩 Bash Script

```bash
#!/bin/bash

username=$1
shift
groups=$@

# Check root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Check if username is provided
if [ -z "$username" ]; then
  echo "Usage: $0 <username> <group1> <group2> ..."
  exit 1
fi

# Check if user exists
if ! id "$username" &>/dev/null; then
  echo "User $username does not exist."
  exit 1
fi

for group in $groups
do
  usermod -aG "$group" "$username"
  echo "Added $username to group $group"
done

echo "User $username added to specified groups successfully."
```

---

### ▶️ How to Run

```bash
# create script
vim add_user_groups.sh

# give execute permission
chmod +x add_user_groups.sh

# run script
sudo ./add_user_groups.sh devuser docker sudo developers
```

---

### 🔍 Example Output

```
Added devuser to group docker
Added devuser to group sudo
Added devuser to group developers
User devuser added to specified groups successfully.
```

---

### 📋 Commands Used

| Command       | Purpose               | Example                      |
| ------------- | --------------------- | ---------------------------- |
| `usermod -aG` | Add user to group     | `usermod -aG docker devuser` |
| `id username` | Check user existence  | `id devuser`                 |
| `$EUID`       | Check root privileges | `$EUID -ne 0`                |

---

### 📋 Alternative Single Command

You can add a user to multiple groups using one command:

```bash
sudo usermod -aG docker,sudo,developers devuser
```

| Option | Meaning                   |
| ------ | ------------------------- |
| `-a`   | Append to existing groups |
| `-G`   | Specify group list        |

---

### ✅ Best Practices

* Always use **`-aG`** with `usermod` to avoid removing existing groups.
* Verify group existence before adding users in production scripts.
* Use group-based access for **least privilege security**.
* Useful in **DevOps setups for Docker, Kubernetes, CI/CD service accounts**.

---

### 💡 In short

* Script accepts **username and multiple group names**.
* Uses `usermod -aG` to add the user to each group.
* Must be run with **sudo/root privileges**.

----
## Q35: Write a bash script to create a user with a specific UID, GID, home directory, and shell

### 🧠 Overview

* In Linux administration and DevOps automation, creating users with **specific UID, GID, home directory, and shell** is common when managing **service accounts, shared environments, or migrating users across servers**.
* Setting these attributes ensures **consistent identity mapping, proper permissions, and correct login environment**.
* This script creates a user with the required parameters using the `useradd` command.

---

### ⚙️ Purpose / How it works

* `useradd` → Creates a new user account.
* `-u` → Specifies the **UID (User ID)**.
* `-g` → Specifies the **primary group (GID)**.
* `-d` → Defines the **home directory**.
* `-s` → Sets the **login shell**.
* `-m` → Creates the home directory if it does not exist.

---

### 🧩 Bash Script

```bash
#!/bin/bash

USERNAME=$1
UID=$2
GID=$3
HOME_DIR=$4
SHELL=$5

# Check root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Validate input
if [ $# -ne 5 ]; then
  echo "Usage: $0 <username> <uid> <gid> <home_directory> <shell>"
  exit 1
fi

# Create user
useradd -u "$UID" -g "$GID" -d "$HOME_DIR" -s "$SHELL" -m "$USERNAME"

echo "User $USERNAME created successfully."
echo "UID: $UID"
echo "GID: $GID"
echo "Home Directory: $HOME_DIR"
echo "Shell: $SHELL"
```

---

### ▶️ How to Run

```bash
# create script
vim create_user_custom.sh

# give execute permission
chmod +x create_user_custom.sh

# run script
sudo ./create_user_custom.sh devuser 1050 1050 /home/devuser /bin/bash
```

---

### 🔍 Example Output

```
User devuser created successfully.
UID: 1050
GID: 1050
Home Directory: /home/devuser
Shell: /bin/bash
```

---

### 📋 Commands Used

| Option | Purpose                | Example            |
| ------ | ---------------------- | ------------------ |
| `-u`   | Set user ID            | `-u 1050`          |
| `-g`   | Set primary group ID   | `-g 1050`          |
| `-d`   | Specify home directory | `-d /home/devuser` |
| `-s`   | Specify login shell    | `-s /bin/bash`     |
| `-m`   | Create home directory  | `-m`               |

Example command without script:

```bash
sudo useradd -u 1050 -g 1050 -d /home/devuser -s /bin/bash -m devuser
```

---

### ✅ Best Practices

* Always run user management scripts with **root privileges**.
* Ensure **UID and GID are unique** to avoid conflicts.
* Use consistent UID/GID values when **synchronizing users across multiple servers or NFS environments**.
* Validate group existence before assigning the **GID**.

Example group creation if needed:

```bash
sudo groupadd -g 1050 devgroup
```

---

### 💡 In short

* Script creates a user with **custom UID, GID, home directory, and shell**.
* Uses `useradd` options `-u`, `-g`, `-d`, `-s`, and `-m`.
* Requires **sudo/root privileges**.

---
## Q36: Write a bash script to list all running services on a Linux machine (systemd/systemctl)

🧠 **Overview**

* Modern Linux distributions (Ubuntu, RHEL, Amazon Linux) use **systemd** to manage services.
* `systemctl` is the command-line tool used to manage and inspect services.
* DevOps engineers often check running services during **server health checks, deployment validation, and troubleshooting**.

---

⚙️ **Purpose / How it works**

`systemctl list-units` shows all active units managed by systemd.
Adding filters helps show **only running services**.

Command used:

systemctl list-units --type=service --state=running

---

🧩 **Bash Script Example**

```bash
#!/bin/bash

echo "Running services on this system:"
echo "--------------------------------"

systemctl list-units --type=service --state=running --no-pager
```

Make the script executable:

```bash
chmod +x list_running_services.sh
```

Run the script:

```bash
./list_running_services.sh
```

---

🧩 **Script to show only service names**

```bash
#!/bin/bash

echo "Running services:"
echo "----------------"

systemctl list-units --type=service --state=running --no-pager --no-legend | awk '{print $1}'
```

Example output:

docker.service
kubelet.service
ssh.service
cron.service

---

📋 **Important systemctl commands**

| Command                             | Description                   |
| ----------------------------------- | ----------------------------- |
| systemctl list-units                | Shows active systemd units    |
| systemctl list-units --type=service | Lists only services           |
| systemctl status nginx              | Shows detailed service status |
| systemctl start nginx               | Starts a service              |
| systemctl stop nginx                | Stops a service               |
| systemctl restart nginx             | Restarts a service            |

---

✅ **Best Practices**

* Use `--no-pager` in scripts to avoid interactive output.
* Combine with **cron jobs** for periodic monitoring.
* Log service status during **deployment validation**.
* Check critical services like **docker, kubelet, ssh, nginx**.

Example health check:

```bash
systemctl is-active docker
```

---

💡 **In short**

* `systemctl list-units --type=service --state=running` lists all running services.
* A bash script can automate this for **monitoring, debugging, and DevOps automation**.

---
Got it 👍 — the issue is the **extra formatting blocks**. I’ll give **clean Markdown code blocks only**, so you can copy easily.

---

## Q37: Write a bash script to start a service if it is stopped, and log the action with a timestamp to a file

🧠 **Overview**

* In Linux systems using **systemd**, services are controlled with `systemctl`.
* DevOps engineers often create **monitoring scripts** to ensure critical services (docker, nginx, kubelet) are running.
* This script checks if a service is stopped, starts it if necessary, and logs the action with a **timestamp**.

---

⚙️ **Purpose / How it works**

1. Check service status using `systemctl is-active`.
2. If the service is **not running**, start it.
3. Write the action into a **log file with timestamp**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

SERVICE="nginx"
LOG_FILE="/var/log/service_monitor.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

STATUS=$(systemctl is-active $SERVICE)

if [ "$STATUS" != "active" ]; then
    systemctl start $SERVICE
    echo "$TIMESTAMP - $SERVICE was stopped. Started successfully." >> $LOG_FILE
else
    echo "$TIMESTAMP - $SERVICE is already running." >> $LOG_FILE
fi
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x service_check.sh
```

Run the script:

```bash
./service_check.sh
```

---

📋 **Important commands**

| Command                       | Purpose                    |
| ----------------------------- | -------------------------- |
| `systemctl is-active service` | Checks service status      |
| `systemctl start service`     | Starts the service         |
| `date`                        | Generates timestamp        |
| `>>`                          | Appends output to log file |

---

✅ **Best Practices**

* Store logs in `/var/log/` for production systems.
* Use this script with **cron jobs** for automatic monitoring.
* Monitor critical services like **docker, kubelet, nginx, ssh**.

Example cron job:

```bash
*/5 * * * * /scripts/service_check.sh
```

---

💡 **In short**

* `systemctl is-active` checks service status.
* If stopped → start the service using `systemctl start`.
* Log the action with a **timestamp for monitoring and troubleshooting**.

---

If you want, I can also give **20 DevOps Bash scripts commonly asked in interviews** (log cleanup, disk alerts, service monitor, Docker cleanup, etc.). These are **very common in DevOps interviews.**

---
## Q38: Write a bash script to restart a service and verify it started successfully, with retry logic if it fails

🧠 **Overview**

* In Linux systems using **systemd**, services are managed with `systemctl`.
* During deployments or troubleshooting, DevOps engineers often **restart services and verify they started correctly**.
* This script restarts a service, checks its status, and **retries multiple times if the restart fails**.

---

⚙️ **Purpose / How it works**

1. Restart the service using `systemctl restart`.
2. Check if the service is running using `systemctl is-active`.
3. If the service is not running, retry restarting it.
4. Stop retrying after a defined number of attempts.

---

🧩 **Bash Script**

```bash
#!/bin/bash

SERVICE="nginx"
MAX_RETRIES=3
COUNT=1

while [ $COUNT -le $MAX_RETRIES ]
do
    echo "Attempt $COUNT: Restarting $SERVICE"

    systemctl restart $SERVICE
    sleep 2

    STATUS=$(systemctl is-active $SERVICE)

    if [ "$STATUS" = "active" ]; then
        echo "$SERVICE started successfully."
        exit 0
    else
        echo "$SERVICE failed to start."
    fi

    COUNT=$((COUNT+1))
done

echo "ERROR: $SERVICE failed after $MAX_RETRIES attempts."
exit 1
```

---

🧩 **How to run**

Make executable:

```bash
chmod +x restart_service.sh
```

Run:

```bash
./restart_service.sh
```

---

📋 **Key commands used**

| Command                       | Purpose                      |
| ----------------------------- | ---------------------------- |
| `systemctl restart service`   | Restarts the service         |
| `systemctl is-active service` | Checks if service is running |
| `sleep`                       | Wait before checking status  |
| `$((COUNT+1))`                | Increment retry counter      |

---

✅ **Best Practices**

* Always include **retry logic** for production automation.
* Add **logging** when used in monitoring scripts.
* Use for **critical services** like `docker`, `kubelet`, `nginx`, `mysql`.
* Combine with **cron or monitoring tools** for automated recovery.

Example health-check automation:

```bash
systemctl is-active docker || systemctl restart docker
```

---

💡 **In short**

* Restart the service using `systemctl restart`.
* Verify status with `systemctl is-active`.
* If it fails, retry restarting **up to a defined limit**.

---
## Q39: Write a bash script to check if specific services (nginx, mysql, redis) are running and restart them if they are down

🧠 **Overview**

* Production Linux servers run multiple critical services like **nginx (web server), mysql (database), and redis (cache)**.
* If any of these services stop, applications may fail.
* DevOps engineers commonly use **health-check scripts** that verify service status and automatically restart them if they are down.

---

⚙️ **Purpose / How it works**

1. Define a list of services to monitor.
2. Loop through each service.
3. Check service status using `systemctl is-active`.
4. If the service is **not running**, restart it using `systemctl restart`.
5. Print or log the action.

---

🧩 **Bash Script**

```bash
#!/bin/bash

SERVICES=("nginx" "mysql" "redis")

for SERVICE in "${SERVICES[@]}"
do
    STATUS=$(systemctl is-active $SERVICE)

    if [ "$STATUS" != "active" ]; then
        echo "$SERVICE is down. Restarting..."
        systemctl restart $SERVICE

        if systemctl is-active --quiet $SERVICE; then
            echo "$SERVICE restarted successfully."
        else
            echo "Failed to restart $SERVICE."
        fi
    else
        echo "$SERVICE is running."
    fi
done
```

---

🧩 **How to run**

Make executable:

```bash
chmod +x check_services.sh
```

Run the script:

```bash
./check_services.sh
```

---

📋 **Commands used**

| Command                       | Purpose                            |
| ----------------------------- | ---------------------------------- |
| `systemctl is-active service` | Checks if service is running       |
| `systemctl restart service`   | Restarts the service               |
| `for loop`                    | Iterates through multiple services |
| `--quiet`                     | Suppresses command output          |

---

✅ **Best Practices**

* Run this script using **cron for continuous monitoring**.
* Add **logging to /var/log/** for debugging production issues.
* Monitor critical services such as **docker, kubelet, nginx, mysql, redis**.
* Use with **monitoring tools like Prometheus or Nagios**.

Example cron job (run every 5 minutes):

```bash
*/5 * * * * /opt/scripts/check_services.sh
```

---

💡 **In short**

* Define services in an array.
* Check status using `systemctl is-active`.
* If stopped → restart using `systemctl restart`.
* Commonly used for **automated service health monitoring in production servers**.

---
## Q40: Write a bash script to enable a service to start automatically at boot time

🧠 **Overview**

* In Linux systems using **systemd**, services can be configured to **start automatically when the system boots**.
* This is done using `systemctl enable`.
* DevOps engineers ensure critical services like **docker, nginx, kubelet, mysql** automatically start after server reboot.

---

⚙️ **Purpose / How it works**

1. Take the **service name** as input.
2. Check if the service is already enabled.
3. If not enabled, run `systemctl enable <service>`.
4. Confirm that the service will start at boot.

---

🧩 **Bash Script**

```bash
#!/bin/bash

SERVICE=$1

if [ -z "$SERVICE" ]; then
    echo "Usage: $0 <service-name>"
    exit 1
fi

echo "Enabling $SERVICE to start at boot..."

systemctl enable $SERVICE

if [ $? -eq 0 ]; then
    echo "$SERVICE is now enabled to start automatically at boot."
else
    echo "Failed to enable $SERVICE."
fi
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x enable_service.sh
```

Run the script:

```bash
./enable_service.sh nginx
```

Example output:

```
Enabling nginx to start at boot...
nginx is now enabled to start automatically at boot.
```

---

📋 **Important systemctl commands**

| Command                        | Purpose                     |
| ------------------------------ | --------------------------- |
| `systemctl enable service`     | Enable service at boot      |
| `systemctl disable service`    | Disable service at boot     |
| `systemctl is-enabled service` | Check if service is enabled |
| `systemctl start service`      | Start service immediately   |

---

✅ **Best Practices**

* Always enable **critical infrastructure services** (docker, kubelet, nginx).
* Verify status using `systemctl is-enabled`.
* Combine with **configuration management tools** (Ansible, Terraform, Puppet).
* Use in **server bootstrap scripts** during provisioning.

Example verification:

```bash
systemctl is-enabled nginx
```

---

💡 **In short**

* Use `systemctl enable <service>` to start a service at boot.
* Bash scripts help automate this during **server setup and infrastructure provisioning**.

---
## Q41: Write a bash script to monitor CPU and memory usage and alert if usage exceeds 80%

🧠 **Overview**

* Monitoring **CPU and memory usage** is essential for maintaining server health.
* DevOps teams use scripts to detect **resource spikes** that may impact applications.
* This script checks CPU and RAM usage and prints an **alert if usage exceeds 80%**.

---

⚙️ **Purpose / How it works**

1. Collect CPU usage using `top` command.
2. Collect memory usage using `free`.
3. Compare values against a defined **threshold (80%)**.
4. Print an alert message if usage crosses the threshold.

---

🧩 **Bash Script**

```bash
#!/bin/bash

CPU_THRESHOLD=80
MEM_THRESHOLD=80

# Get CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1)

# Get Memory usage
MEM_USAGE=$(free | awk '/Mem/ {printf("%.0f"), $3/$2 * 100}')

echo "CPU Usage: $CPU_USAGE%"
echo "Memory Usage: $MEM_USAGE%"

# Check CPU usage
if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    echo "ALERT: CPU usage is above $CPU_THRESHOLD%"
fi

# Check Memory usage
if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
    echo "ALERT: Memory usage is above $MEM_THRESHOLD%"
fi
```

---

🧩 **How to run**

Make executable:

```bash
chmod +x monitor_resources.sh
```

Run:

```bash
./monitor_resources.sh
```

Example output:

```
CPU Usage: 45%
Memory Usage: 62%
```

If high usage:

```
CPU Usage: 92%
Memory Usage: 85%
ALERT: CPU usage is above 80%
ALERT: Memory usage is above 80%
```

---

📋 **Commands used**

| Command    | Purpose                  |
| ---------- | ------------------------ |
| `top -bn1` | Gets CPU statistics      |
| `free`     | Shows memory usage       |
| `awk`      | Processes command output |
| `grep`     | Filters required lines   |

---

✅ **Best Practices**

* Run this script using **cron** for continuous monitoring.
* Send alerts via **email or Slack** in production systems.
* Integrate with **monitoring tools like Prometheus, Grafana, or CloudWatch**.
* Log results to `/var/log/monitor.log`.

Example cron job (every 5 minutes):

```bash
*/5 * * * * /opt/scripts/monitor_resources.sh
```

---

💡 **In short**

* Use `top` to check CPU usage and `free` for memory usage.
* Compare values with a **threshold (80%)**.
* Trigger an alert if usage exceeds the limit.

---
## Q42: Write a bash script to monitor disk usage and send an email alert when any partition exceeds 85%

🧠 **Overview**

* Disk usage monitoring is critical in production systems because **full disks can crash applications, databases, or CI/CD pipelines**.
* Linux provides the `df` command to check filesystem usage.
* DevOps engineers often automate disk monitoring and trigger **email alerts when usage crosses a threshold (e.g., 85%)**.

---

⚙️ **Purpose / How it works**

1. Use `df -h` to get disk usage information.
2. Extract the **usage percentage** of each partition.
3. Compare it with the **threshold (85%)**.
4. If exceeded, send an **email alert using the `mail` command**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

THRESHOLD=85
EMAIL="admin@example.com"

df -h | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{print $5 " " $6}' | while read output;
do
  usage=$(echo $output | awk '{print $1}' | cut -d'%' -f1)
  partition=$(echo $output | awk '{print $2}')

  if [ $usage -ge $THRESHOLD ]; then
    echo "Warning: Disk usage on $partition is ${usage}%." \
    | mail -s "Disk Usage Alert on $(hostname)" $EMAIL
  fi
done
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x disk_monitor.sh
```

Run the script:

```bash
./disk_monitor.sh
```

---

📋 **Commands used**

| Command    | Purpose                                      |
| ---------- | -------------------------------------------- |
| `df -h`    | Displays disk usage in human-readable format |
| `awk`      | Parses command output                        |
| `cut`      | Extracts usage percentage                    |
| `mail`     | Sends email alerts                           |
| `hostname` | Shows server hostname                        |

---

✅ **Best Practices**

* Install mail utility if not present:

```
sudo apt install mailutils     # Ubuntu/Debian
sudo yum install mailx         # RHEL/Amazon Linux
```

* Run the script using **cron for continuous monitoring**.
* Exclude temporary filesystems (`tmpfs`, `overlay`).
* Store logs in `/var/log/` for audit and troubleshooting.

Example cron job (run every 10 minutes):

```
*/10 * * * * /opt/scripts/disk_monitor.sh
```

---

💡 **In short**

* Use `df -h` to check disk usage.
* If any partition exceeds **85%**, trigger an **email alert**.
* Commonly used in **server monitoring and production operations**.

---
## Q43: Write a bash script to parse an Apache/Nginx access log and display the top 10 IP addresses by request count

🧠 **Overview**

* Web servers like **Apache and Nginx** generate **access logs** that record each client request.
* DevOps engineers analyze these logs to detect **high-traffic clients, bots, or possible attacks (DDoS/brute force)**.
* This script parses the access log and shows the **top 10 IP addresses generating the most requests**.

---

⚙️ **Purpose / How it works**

1. Read the access log file.
2. Extract the **IP address (first column)** from each log entry.
3. Count the number of occurrences of each IP.
4. Sort results by request count.
5. Display the **top 10 IPs**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

LOG_FILE="/var/log/nginx/access.log"

echo "Top 10 IP addresses by request count:"
echo "-------------------------------------"

awk '{print $1}' $LOG_FILE | sort | uniq -c | sort -nr | head -10
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x top_ips.sh
```

Run the script:

```bash
./top_ips.sh
```

---

🧩 **Example Output**

```
450 192.168.1.10
380 10.0.0.25
300 203.0.113.45
210 192.168.1.50
180 172.16.1.12
```

Meaning:

| Requests | IP Address   |
| -------- | ------------ |
| 450      | 192.168.1.10 |
| 380      | 10.0.0.25    |
| 300      | 203.0.113.45 |

---

📋 **Commands used**

| Command            | Purpose                      |
| ------------------ | ---------------------------- |
| `awk '{print $1}'` | Extracts IP address from log |
| `sort`             | Sorts IP addresses           |
| `uniq -c`          | Counts occurrences           |
| `sort -nr`         | Sorts by count (descending)  |
| `head -10`         | Displays top 10 results      |

---

✅ **Best Practices**

* Run this script for **traffic analysis and security monitoring**.
* Useful for detecting **DDoS attacks or abusive clients**.
* Integrate with **fail2ban or firewall rules** to block suspicious IPs.
* Automate with **cron jobs or monitoring pipelines**.

Example for Apache log:

```
/var/log/apache2/access.log
```

---

💡 **In short**

* Extract IPs from access logs using `awk`.
* Count requests using `uniq -c`.
* Sort and display the **top 10 IPs generating traffic**.

----
## Q44: Write a bash script to find all ERROR entries in a log file from the last 24 hours and count occurrences

🧠 **Overview**

* Application and system logs often contain entries like **INFO, WARN, ERROR**.
* DevOps engineers analyze logs to detect **failures, crashes, and service issues**.
* This script scans a log file, filters **ERROR messages from the last 24 hours**, and counts how many occurred.

---

⚙️ **Purpose / How it works**

1. Calculate the **timestamp for 24 hours ago**.
2. Search the log file for entries containing **ERROR**.
3. Filter only entries **within the last 24 hours**.
4. Count the number of matching log entries.

---

🧩 **Bash Script**

```bash
#!/bin/bash

LOG_FILE="/var/log/app.log"

# Time 24 hours ago
START_TIME=$(date -d "24 hours ago" "+%Y-%m-%d %H:%M:%S")

echo "Checking ERROR logs since: $START_TIME"
echo "--------------------------------------"

grep "ERROR" $LOG_FILE | awk -v start="$START_TIME" '$0 >= start {count++} END {print "Total ERROR entries:", count}'
```

---

🧩 **Alternative (Simple method if logs rotate daily)**

If logs are timestamped like `YYYY-MM-DD`:

```bash
#!/bin/bash

LOG_FILE="/var/log/app.log"
YESTERDAY=$(date -d "yesterday" "+%Y-%m-%d")

grep "$YESTERDAY" $LOG_FILE | grep "ERROR" | wc -l
```

---

🧩 **How to run**

Make executable:

```bash
chmod +x error_log_check.sh
```

Run:

```bash
./error_log_check.sh
```

Example output:

```
Checking ERROR logs since: 2026-03-03 15:20:00
--------------------------------------
Total ERROR entries: 17
```

---

📋 **Commands used**

| Command                  | Purpose                    |
| ------------------------ | -------------------------- |
| `grep`                   | Searches for ERROR entries |
| `awk`                    | Filters and counts entries |
| `date -d "24 hours ago"` | Calculates timestamp       |
| `wc -l`                  | Counts lines               |

---

✅ **Best Practices**

* Schedule this script using **cron** for periodic log monitoring.
* Send alerts if error count exceeds a threshold.
* Combine with **centralized logging tools** like **ELK stack or CloudWatch**.
* Rotate logs using **logrotate** to prevent disk exhaustion.

Example cron job (run hourly):

```
0 * * * * /opt/scripts/error_log_check.sh
```

---

💡 **In short**

* Use `grep` to find **ERROR logs**.
* Filter logs from **last 24 hours**.
* Count occurrences using `awk` or `wc -l` for quick troubleshooting.

----
## Q45: Write a bash script to rotate log files: compress logs older than 7 days and delete logs older than 30 days

🧠 **Overview**

* Log files grow quickly in production systems and can consume disk space.
* DevOps engineers implement **log rotation** to compress older logs and remove very old ones.
* This script **compresses logs older than 7 days** and **deletes logs older than 30 days** to maintain disk hygiene.

---

⚙️ **Purpose / How it works**

1. Use `find` to locate log files in a directory.
2. Compress files older than **7 days** using `gzip`.
3. Delete files older than **30 days**.
4. Automate execution using **cron**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

LOG_DIR="/var/log/myapp"

echo "Starting log rotation..."

# Compress logs older than 7 days
find $LOG_DIR -type f -name "*.log" -mtime +7 -exec gzip {} \;

# Delete logs older than 30 days
find $LOG_DIR -type f -name "*.log.gz" -mtime +30 -exec rm -f {} \;

echo "Log rotation completed."
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x rotate_logs.sh
```

Run the script:

```bash
./rotate_logs.sh
```

---

📋 **Commands used**

| Command     | Purpose                           |
| ----------- | --------------------------------- |
| `find`      | Searches for files in directory   |
| `-mtime +7` | Files older than 7 days           |
| `gzip`      | Compresses log files              |
| `rm -f`     | Deletes files                     |
| `-exec`     | Executes command on matched files |

---

🧩 **Example directory before rotation**

```
app.log
app.log.1
app.log.2
app.log.10
```

After script execution:

```
app.log
app.log.1.gz
app.log.2.gz
```

Files older than **30 days** are removed.

---

✅ **Best Practices**

* Store logs in a **dedicated directory** like `/var/log/app/`.
* Always test scripts in **non-production environments** first.
* Run rotation via **cron** daily.
* Prefer **logrotate** for enterprise-grade rotation.

Example cron job:

```
0 2 * * * /opt/scripts/rotate_logs.sh
```

Runs every day at **2 AM**.

---

💡 **In short**

* Compress logs older than **7 days** using `gzip`.
* Delete logs older than **30 days** using `find` and `rm`.
* Automate with **cron for continuous log maintenance**.

---
## Q46: Write a bash script to monitor a specific process by name and restart it if it's not running

🧠 **Overview**

* In production environments, critical applications run as background **processes** (e.g., nginx, node, java apps).
* If a process crashes, services may become unavailable.
* DevOps engineers create monitoring scripts that **check if a process is running and restart it automatically if it stops**.

---

⚙️ **Purpose / How it works**

1. Define the **process name** to monitor.
2. Use `pgrep` or `ps` to check if the process exists.
3. If the process is not running, restart it using `systemctl` or a start command.
4. Print or log the action.

---

🧩 **Bash Script**

```bash
#!/bin/bash

PROCESS="nginx"

if pgrep -x "$PROCESS" > /dev/null
then
    echo "$PROCESS is running."
else
    echo "$PROCESS is not running. Restarting..."
    systemctl restart $PROCESS
fi
```

---

🧩 **How to run**

Make executable:

```bash
chmod +x monitor_process.sh
```

Run the script:

```bash
./monitor_process.sh
```

---

🧩 **Alternative method using `ps`**

```bash
#!/bin/bash

PROCESS="nginx"

if ps -ef | grep -v grep | grep $PROCESS > /dev/null
then
    echo "$PROCESS is running"
else
    echo "$PROCESS stopped. Restarting..."
    systemctl start $PROCESS
fi
```

---

📋 **Commands used**

| Command              | Purpose                      |
| -------------------- | ---------------------------- |
| `pgrep process_name` | Checks if process is running |
| `ps -ef`             | Lists running processes      |
| `grep`               | Filters process name         |
| `systemctl restart`  | Restarts the service         |

---

✅ **Best Practices**

* Prefer **pgrep** over `ps | grep` because it is faster and cleaner.
* Log actions to `/var/log/process_monitor.log`.
* Run the script using **cron for continuous monitoring**.
* Monitor critical services like **nginx, docker, kubelet, redis**.

Example cron job (every 5 minutes):

```bash
*/5 * * * * /opt/scripts/monitor_process.sh
```

---

💡 **In short**

* Use `pgrep` to check if a process is running.
* If not running → restart using `systemctl restart`.
* Automate using **cron for service self-healing**.

---
## Q47: Write a bash script to tail multiple log files simultaneously and highlight ERROR and WARNING keywords

🧠 **Overview**

* In production environments, DevOps engineers often monitor **multiple log files in real-time** to detect issues quickly.
* `tail -f` allows continuous log streaming, while `grep` can highlight important keywords like **ERROR** and **WARNING**.
* This script tails multiple logs simultaneously and **color-highlights critical log entries**.

---

⚙️ **Purpose / How it works**

1. Use `tail -f` to follow multiple log files in real time.
2. Pipe output to `grep` with `--color` option.
3. Highlight **ERROR** and **WARNING** messages for quick troubleshooting.

---

🧩 **Bash Script**

```bash
#!/bin/bash

LOG_FILES=(
/var/log/nginx/access.log
/var/log/nginx/error.log
/var/log/syslog
)

echo "Monitoring logs for ERROR and WARNING messages..."
echo "Press CTRL+C to stop."

tail -f ${LOG_FILES[@]} | grep --color=always -E "ERROR|WARNING|$"
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x monitor_logs.sh
```

Run:

```bash
./monitor_logs.sh
```

---

🧩 **Example Output**

```
[INFO] Server started successfully
[WARNING] High memory usage detected
[ERROR] Database connection failed
```

* **ERROR** → highlighted in red
* **WARNING** → highlighted for visibility

---

📋 **Commands used**

| Command           | Purpose                         |
| ----------------- | ------------------------------- |
| `tail -f`         | Continuously monitors log files |
| `grep -E`         | Searches multiple patterns      |
| `--color=always`  | Highlights matching keywords    |
| `${LOG_FILES[@]}` | Expands array of log files      |

---

✅ **Best Practices**

* Monitor critical logs such as:

  * `/var/log/nginx/error.log`
  * `/var/log/syslog`
  * `/var/log/messages`
* Use this script during **incident debugging or live deployments**.
* Combine with tools like **multitail, less +F, or centralized logging (ELK, Loki)**.

---

💡 **In short**

* `tail -f` streams logs in real time.
* `grep -E` filters and highlights **ERROR** and **WARNING**.
* Useful for **live troubleshooting and monitoring multiple logs simultaneously**.

---
## Q48: Write a bash script to analyze system logs (/var/log/syslog or /var/log/messages) and report the most frequent error messages

🧠 **Overview**

* System logs (`/var/log/syslog` or `/var/log/messages`) contain important events such as **errors, warnings, and system failures**.
* DevOps engineers analyze these logs to detect **recurring issues, failing services, or system misconfigurations**.
* This script scans the log file, extracts **error messages**, and reports the **most frequent ones**.

---

⚙️ **Purpose / How it works**

1. Read the system log file.
2. Filter lines containing **error or failed messages**.
3. Normalize or extract the message portion.
4. Count occurrences.
5. Display the **top frequent error messages**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

LOG_FILE="/var/log/syslog"

echo "Most frequent error messages:"
echo "-----------------------------"

grep -i "error\|fail\|critical" $LOG_FILE | \
awk -F'] ' '{print $NF}' | \
sort | uniq -c | sort -nr | head -10
```

---

🧩 **Alternative for RHEL/CentOS systems**

If the system uses `/var/log/messages`:

```bash
#!/bin/bash

LOG_FILE="/var/log/messages"

grep -i "error\|fail\|critical" $LOG_FILE | \
sort | uniq -c | sort -nr | head -10
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x analyze_logs.sh
```

Run the script:

```bash
./analyze_logs.sh
```

---

🧩 **Example Output**

```
120 Failed password for invalid user
85  Disk error detected on device
60  Connection timeout error
40  Service failed to start
20  Database connection error
```

| Count | Error Message                    |
| ----- | -------------------------------- |
| 120   | Failed password for invalid user |
| 85    | Disk error detected              |
| 60    | Connection timeout               |

---

📋 **Commands used**

| Command    | Purpose                         |
| ---------- | ------------------------------- |
| `grep -i`  | Finds error-related log entries |
| `awk`      | Extracts message portion        |
| `sort`     | Sorts log messages              |
| `uniq -c`  | Counts occurrences              |
| `sort -nr` | Sorts by frequency              |
| `head -10` | Shows top 10 errors             |

---

✅ **Best Practices**

* Run log analysis periodically using **cron jobs**.
* Store reports for **incident analysis**.
* Integrate with **ELK stack, Loki, or CloudWatch Logs** for centralized monitoring.
* Combine with alerting systems to detect **repeated failures early**.

Example cron job:

```
0 * * * * /opt/scripts/analyze_logs.sh
```

Runs **every hour**.

---

💡 **In short**

* Use `grep` to filter **error-related logs**.
* Count repeated messages using `uniq -c`.
* Sort results to find the **most frequent system errors quickly**.

---
## Q49: Write a bash script to ping a list of servers from a text file and report which are online and offline

🧠 **Overview**

* DevOps teams often monitor **server availability** across environments (web servers, DB nodes, Kubernetes nodes).
* A simple way to check connectivity is using the **ping command**.
* This script reads a list of servers from a file and reports whether each server is **online or offline**.

---

⚙️ **Purpose / How it works**

1. Read server/IP list from a text file.
2. Loop through each server.
3. Send a **single ping request**.
4. If ping succeeds → server is **ONLINE**.
5. If ping fails → server is **OFFLINE**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

SERVER_LIST="servers.txt"

for SERVER in $(cat $SERVER_LIST)
do
    ping -c 1 -W 2 $SERVER > /dev/null

    if [ $? -eq 0 ]; then
        echo "$SERVER is ONLINE"
    else
        echo "$SERVER is OFFLINE"
    fi
done
```

---

🧩 **Example server list file**

servers.txt

```
192.168.1.10
192.168.1.20
google.com
8.8.8.8
```

---

🧩 **How to run**

Make script executable:

```bash
chmod +x check_servers.sh
```

Run:

```bash
./check_servers.sh
```

---

🧩 **Example Output**

```
192.168.1.10 is ONLINE
192.168.1.20 is OFFLINE
google.com is ONLINE
8.8.8.8 is ONLINE
```

---

📋 **Commands used**

| Command     | Purpose                         |
| ----------- | ------------------------------- |
| `ping -c 1` | Sends one ping packet           |
| `-W 2`      | Waits 2 seconds for response    |
| `$?`        | Exit status of previous command |
| `for loop`  | Iterates through server list    |

---

✅ **Best Practices**

* Store server lists in a **configuration file** for easier maintenance.
* Add **logging** for monitoring systems.
* Integrate with **cron jobs or monitoring tools**.
* For large environments, use tools like **Nagios, Zabbix, or Prometheus**.

Example cron job (run every 5 minutes):

```bash
*/5 * * * * /opt/scripts/check_servers.sh
```

---

💡 **In short**

* Read server names from a file.
* Use `ping` to test connectivity.
* Print whether each server is **ONLINE or OFFLINE**.

----
## Q50: Write a bash script to check if a specific port (e.g., 80, 443, 22) is open on multiple remote servers

🧠 **Overview**

* In DevOps environments, engineers often verify whether **important ports are open on remote servers** (e.g., SSH 22, HTTP 80, HTTPS 443).
* This helps validate **firewall rules, load balancer configuration, and service availability**.
* The script reads servers from a file and checks if specific ports are **reachable using `nc` (netcat)**.

---

⚙️ **Purpose / How it works**

1. Read server hostnames or IPs from a text file.
2. Define the ports to check (22, 80, 443).
3. Use `nc -z` to test connectivity to each port.
4. Print whether the port is **OPEN or CLOSED**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

SERVER_LIST="servers.txt"
PORTS=(22 80 443)

for SERVER in $(cat $SERVER_LIST)
do
    echo "Checking ports on $SERVER"

    for PORT in "${PORTS[@]}"
    do
        nc -z -w 2 $SERVER $PORT > /dev/null 2>&1

        if [ $? -eq 0 ]; then
            echo "Port $PORT is OPEN on $SERVER"
        else
            echo "Port $PORT is CLOSED on $SERVER"
        fi
    done

    echo "--------------------------"
done
```

---

🧩 **Example server list**

servers.txt

```
192.168.1.10
192.168.1.20
google.com
```

---

🧩 **How to run**

Make script executable:

```bash
chmod +x check_ports.sh
```

Run:

```bash
./check_ports.sh
```

---

🧩 **Example Output**

```
Checking ports on 192.168.1.10
Port 22 is OPEN on 192.168.1.10
Port 80 is OPEN on 192.168.1.10
Port 443 is CLOSED on 192.168.1.10
--------------------------
Checking ports on 192.168.1.20
Port 22 is CLOSED on 192.168.1.20
Port 80 is CLOSED on 192.168.1.20
Port 443 is CLOSED on 192.168.1.20
```

---

📋 **Commands used**

| Command    | Purpose                            |
| ---------- | ---------------------------------- |
| `nc -z`    | Checks if port is open             |
| `-w 2`     | Waits 2 seconds for connection     |
| `for loop` | Iterates through servers and ports |
| `$?`       | Checks exit status                 |

---

✅ **Best Practices**

* Install **netcat** if not available:

```
sudo apt install netcat
sudo yum install nc
```

* Use this script to verify **firewall/security group rules**.
* Helpful for validating **AWS Security Groups, NACLs, and load balancer health checks**.
* Integrate into **CI/CD or infrastructure validation scripts**.

---

💡 **In short**

* Read server list from a file.
* Use `nc -z` to test ports.
* Report whether **ports 22, 80, 443 are open or closed** on each server.

---
## Q51: Write a bash script to retrieve IP address, subnet mask, and gateway for all network interfaces

🧠 **Overview**

* Network configuration details like **IP address, subnet mask, and default gateway** are essential for troubleshooting connectivity issues.
* DevOps engineers often retrieve these details when debugging **server networking, Kubernetes nodes, or cloud instances**.
* This script uses the `ip` command to display network information for **all active interfaces**.

---

⚙️ **Purpose / How it works**

1. Use `ip -o -4 addr show` to list IPv4 addresses for all interfaces.
2. Extract the **interface name and IP/subnet mask**.
3. Use `ip route` to identify the **default gateway**.
4. Print the collected network information.

---

🧩 **Bash Script**

```bash
#!/bin/bash

echo "Network Interface Details"
echo "-------------------------"

# Get gateway
GATEWAY=$(ip route | grep default | awk '{print $3}')

# Get interface IP and subnet
ip -o -4 addr show | while read -r line
do
    INTERFACE=$(echo $line | awk '{print $2}')
    IP_ADDR=$(echo $line | awk '{print $4}')

    echo "Interface : $INTERFACE"
    echo "IP/Subnet : $IP_ADDR"
    echo "Gateway   : $GATEWAY"
    echo "-------------------------"
done
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x network_info.sh
```

Run:

```bash
./network_info.sh
```

---

🧩 **Example Output**

```
Network Interface Details
-------------------------
Interface : eth0
IP/Subnet : 192.168.1.25/24
Gateway   : 192.168.1.1
-------------------------
Interface : docker0
IP/Subnet : 172.17.0.1/16
Gateway   : 192.168.1.1
-------------------------
```

---

📋 **Commands used**

| Command        | Purpose                            |
| -------------- | ---------------------------------- |
| `ip addr`      | Displays network interface details |
| `ip route`     | Shows routing table                |
| `awk`          | Extracts specific fields           |
| `grep default` | Finds default gateway              |

---

✅ **Best Practices**

* Prefer `ip` command instead of deprecated `ifconfig`.
* Use during **network troubleshooting, container networking checks, or server diagnostics**.
* Combine with tools like **netstat, ss, traceroute** for deeper analysis.

Example check for default route:

```bash
ip route | grep default
```

---

💡 **In short**

* `ip addr` shows interface IP and subnet.
* `ip route` identifies the default gateway.
* Script prints **IP address, subnet mask, and gateway for all interfaces**.

----
## Q52: Write a bash script to SSH into multiple servers, execute a command, and collect the output into a single report file

🧠 **Overview**

* DevOps engineers often need to run the **same command on multiple servers** (e.g., checking disk usage, service status, or uptime).
* Using **SSH automation**, a script can connect to multiple hosts, execute a command, and collect results into a **central report file**.
* This is useful for **fleet monitoring, configuration validation, and infrastructure audits**.

---

⚙️ **Purpose / How it works**

1. Maintain a list of servers in a text file.
2. Loop through each server.
3. Connect using **SSH** and execute a command.
4. Save the output into a **single report file** with server labels.

---

🧩 **Bash Script**

```bash
#!/bin/bash

SERVER_LIST="servers.txt"
REPORT_FILE="server_report.txt"
COMMAND="uptime"

> $REPORT_FILE

for SERVER in $(cat $SERVER_LIST)
do
    echo "Connecting to $SERVER..." | tee -a $REPORT_FILE

    ssh -o ConnectTimeout=5 $SERVER "$COMMAND" >> $REPORT_FILE 2>&1

    echo "---------------------------------" >> $REPORT_FILE
done

echo "Report generated in $REPORT_FILE"
```

---

🧩 **Example server list**

servers.txt

```
192.168.1.10
192.168.1.20
server1.example.com
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x run_remote_command.sh
```

Run the script:

```bash
./run_remote_command.sh
```

---

🧩 **Example Output (server_report.txt)**

```
Connecting to 192.168.1.10
 10:15:22 up 5 days,  3 users,  load average: 0.21, 0.15, 0.10
---------------------------------
Connecting to 192.168.1.20
 10:15:23 up 12 days,  2 users, load average: 0.10, 0.05, 0.01
---------------------------------
```

---

📋 **Commands used**

| Command              | Purpose                           |
| -------------------- | --------------------------------- |
| `ssh server command` | Executes command on remote server |
| `ConnectTimeout`     | Prevents hanging SSH connections  |
| `tee -a`             | Writes output to screen and file  |
| `>>`                 | Appends output to report file     |

---

✅ **Best Practices**

* Use **SSH key-based authentication** instead of passwords.
* Add **timeout options** to prevent long waits.
* Store results in **timestamped report files**.
* For large server fleets, consider tools like **Ansible, Fabric, or Parallel SSH**.

Example SSH key setup:

```bash
ssh-keygen
ssh-copy-id user@server
```

---

💡 **In short**

* Read server list from a file.
* Use `ssh` to run commands remotely.
* Append output from all servers into **one consolidated report file**.

---
## Q53: Write a bash script to download a file from a URL with retry logic (up to 3 attempts) if download fails

🧠 **Overview**

* In automation pipelines (CI/CD, server bootstrap, artifact downloads), files are often downloaded from **remote URLs**.
* Network issues may cause downloads to fail.
* DevOps scripts include **retry logic** to automatically attempt the download again before failing.

---

⚙️ **Purpose / How it works**

1. Define the **URL and output file name**.
2. Set a **maximum retry limit (3 attempts)**.
3. Use `curl` or `wget` to download the file.
4. If download fails, retry until the maximum attempts are reached.

---

🧩 **Bash Script**

```bash
#!/bin/bash

URL="https://example.com/file.tar.gz"
OUTPUT="file.tar.gz"
MAX_RETRIES=3
COUNT=1

while [ $COUNT -le $MAX_RETRIES ]
do
    echo "Download attempt $COUNT..."

    curl -f -o $OUTPUT $URL

    if [ $? -eq 0 ]; then
        echo "Download successful."
        exit 0
    else
        echo "Download failed."
    fi

    COUNT=$((COUNT+1))
    sleep 2
done

echo "Download failed after $MAX_RETRIES attempts."
exit 1
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x download_file.sh
```

Run the script:

```bash
./download_file.sh
```

---

🧩 **Alternative using wget**

```bash
#!/bin/bash

URL="https://example.com/file.tar.gz"
wget --tries=3 $URL
```

`wget` already supports built-in retry logic.

---

📋 **Commands used**

| Command          | Purpose                         |
| ---------------- | ------------------------------- |
| `curl -o`        | Downloads file from URL         |
| `-f`             | Fails on HTTP errors            |
| `wget --tries=3` | Retry download automatically    |
| `sleep`          | Wait before retry               |
| `$?`             | Exit status of previous command |

---

✅ **Best Practices**

* Always include **retry logic** in automation scripts.
* Use `curl -f` to fail immediately on HTTP errors.
* Add **timeout and retry delays** for unstable networks.
* Useful in **CI/CD pipelines, container builds, and bootstrap scripts**.

Example in Docker build:

```bash
RUN curl -f -o app.tar.gz https://repo.example.com/app.tar.gz
```

---

💡 **In short**

* Use `curl` or `wget` to download files.
* Retry download **up to 3 times** if it fails.
* Helps make **automation scripts resilient to network failures**.

----
## Q54: Write a bash script to test DNS resolution for a list of domains and report failures

🧠 **Overview**

* DNS resolution ensures that **domain names correctly map to IP addresses**.
* DevOps engineers check DNS during **deployment validation, troubleshooting connectivity, or monitoring external services**.
* This script reads a list of domains from a file, tests DNS resolution, and reports **domains that fail to resolve**.

---

⚙️ **Purpose / How it works**

1. Store domains in a text file.
2. Loop through each domain.
3. Use `nslookup` or `dig` to check DNS resolution.
4. If resolution fails, record it as **FAILED**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

DOMAIN_LIST="domains.txt"

for DOMAIN in $(cat $DOMAIN_LIST)
do
    nslookup $DOMAIN > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "$DOMAIN resolved successfully"
    else
        echo "$DOMAIN FAILED to resolve"
    fi
done
```

---

🧩 **Example domain list**

domains.txt

```
google.com
example.com
github.com
invalid-domain.test
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x dns_check.sh
```

Run the script:

```bash
./dns_check.sh
```

---

🧩 **Example Output**

```
google.com resolved successfully
example.com resolved successfully
github.com resolved successfully
invalid-domain.test FAILED to resolve
```

---

📋 **Commands used**

| Command           | Purpose                         |
| ----------------- | ------------------------------- |
| `nslookup domain` | Queries DNS records             |
| `dig domain`      | Advanced DNS lookup             |
| `$?`              | Exit status of previous command |
| `for loop`        | Iterates through domain list    |

---

✅ **Best Practices**

* Use `dig +short` for faster DNS checks.
* Store failed domains in a **separate report file**.
* Integrate with **monitoring alerts for critical domains**.
* Useful in validating **DNS configuration after infrastructure changes**.

Example using `dig`:

```bash
dig +short google.com
```

---

💡 **In short**

* Read domains from a file.
* Use `nslookup` or `dig` to test DNS resolution.
* Report domains that **fail to resolve**.

---
## Q55: Write a bash script to scan a subnet (e.g., 192.168.1.0/24) and list all active IP addresses

🧠 **Overview**

* Network scanning helps identify **active hosts in a subnet**.
* DevOps engineers use it for **infrastructure discovery, troubleshooting connectivity, and verifying server availability**.
* This script scans a subnet (e.g., `192.168.1.0/24`) and lists **IP addresses that respond to ping**.

---

⚙️ **Purpose / How it works**

1. Define the **subnet range**.
2. Loop through IP addresses (1–254).
3. Send a **single ping request** to each IP.
4. If the ping succeeds → mark the host as **ACTIVE**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

SUBNET="192.168.1"

echo "Scanning subnet $SUBNET.0/24..."
echo "Active hosts:"

for IP in {1..254}
do
    ping -c 1 -W 1 $SUBNET.$IP > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "$SUBNET.$IP is ACTIVE"
    fi
done
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x subnet_scan.sh
```

Run the script:

```bash
./subnet_scan.sh
```

---

🧩 **Example Output**

```
Scanning subnet 192.168.1.0/24...
Active hosts:
192.168.1.1 is ACTIVE
192.168.1.10 is ACTIVE
192.168.1.20 is ACTIVE
192.168.1.50 is ACTIVE
```

---

📋 **Commands used**

| Command     | Purpose                     |
| ----------- | --------------------------- |
| `ping -c 1` | Sends one ping request      |
| `-W 1`      | Waits 1 second for response |
| `for` loop  | Iterates through IP range   |
| `$?`        | Checks command success      |

---

✅ **Best Practices**

* Run network scans **within authorized networks only**.
* For faster scans, use tools like **nmap or fping**.
* Store results in a file for **network inventory tracking**.

Example using `nmap`:

```bash
nmap -sn 192.168.1.0/24
```

---

💡 **In short**

* Loop through IP range `1–254`.
* Use `ping` to test connectivity.
* Print IPs that respond as **active hosts in the subnet**.

---
## Q56: Write a bash script to search for a specific pattern in all files within a directory and display matching lines with filenames

🧠 **Overview**

* Searching logs or configuration files for specific patterns (like **ERROR, failed, connection refused**) is common in DevOps troubleshooting.
* The `grep` command allows searching across **multiple files in a directory** and displaying the matching lines along with filenames.
* This script automates the search process for a given pattern inside all files in a directory.

---

⚙️ **Purpose / How it works**

1. Accept a **directory path and pattern** to search.
2. Use `grep -r` to recursively search inside files.
3. Display **filename and matching lines**.
4. Useful for analyzing logs, debugging deployments, or auditing configs.

---

🧩 **Bash Script**

```bash
#!/bin/bash

DIRECTORY=$1
PATTERN=$2

if [ -z "$DIRECTORY" ] || [ -z "$PATTERN" ]; then
    echo "Usage: $0 <directory> <pattern>"
    exit 1
fi

echo "Searching for pattern '$PATTERN' in directory '$DIRECTORY'..."
echo "--------------------------------------------"

grep -rn "$PATTERN" "$DIRECTORY"
```

---

🧩 **How to run**

Make script executable:

```bash
chmod +x search_pattern.sh
```

Run:

```bash
./search_pattern.sh /var/log ERROR
```

---

🧩 **Example Output**

```
/var/log/app.log:45: ERROR Database connection failed
/var/log/app.log:78: ERROR Timeout while connecting
/var/log/nginx/error.log:12: ERROR upstream connection refused
```

| File      | Line | Message                     |
| --------- | ---- | --------------------------- |
| app.log   | 45   | Database connection failed  |
| app.log   | 78   | Timeout while connecting    |
| error.log | 12   | Upstream connection refused |

---

📋 **Important grep options**

| Option | Purpose                           |
| ------ | --------------------------------- |
| `-r`   | Recursive search in directories   |
| `-n`   | Shows line numbers                |
| `-i`   | Case-insensitive search           |
| `-l`   | Shows only filenames with matches |

Example case-insensitive search:

```bash
grep -rin "error" /var/log
```

---

✅ **Best Practices**

* Use **recursive search** when scanning large log directories.
* Combine with `--include` to filter file types.

Example:

```bash
grep -rn --include="*.log" "ERROR" /var/log
```

* Useful for **log debugging, security audits, and incident analysis**.

---

💡 **In short**

* Use `grep -rn` to search recursively in directories.
* Displays **filename, line number, and matching content**.
* Commonly used for **log analysis and debugging production issues**.

----
## Q57: Write a bash script to replace all occurrences of a word in multiple files

🧠 **Overview**

* In DevOps environments, engineers often need to **update configuration values across multiple files** (e.g., changing a hostname, environment variable, or API endpoint).
* The `sed` command allows **search-and-replace operations directly inside files**.
* This script replaces all occurrences of a specific word in **multiple files within a directory**.

---

⚙️ **Purpose / How it works**

1. Accept a **directory, old word, and new word** as input.
2. Find all files in the directory.
3. Use `sed` to replace the word inside each file.
4. Modify files **in-place**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

DIRECTORY=$1
OLD_WORD=$2
NEW_WORD=$3

if [ -z "$DIRECTORY" ] || [ -z "$OLD_WORD" ] || [ -z "$NEW_WORD" ]; then
    echo "Usage: $0 <directory> <old_word> <new_word>"
    exit 1
fi

for FILE in $(find $DIRECTORY -type f)
do
    sed -i "s/$OLD_WORD/$NEW_WORD/g" $FILE
done

echo "Replacement completed: '$OLD_WORD' → '$NEW_WORD'"
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x replace_word.sh
```

Run the script:

```bash
./replace_word.sh /opt/config old_value new_value
```

---

🧩 **Example**

Before (`config.txt`):

```
DB_HOST=oldserver
API_URL=http://oldserver/api
```

Run script:

```
./replace_word.sh . oldserver newserver
```

After:

```
DB_HOST=newserver
API_URL=http://newserver/api
```

---

📋 **Commands used**

| Command                  | Purpose                      |
| ------------------------ | ---------------------------- |
| `find directory -type f` | Finds all files in directory |
| `sed -i`                 | Edits files in place         |
| `s/old/new/g`            | Replace all occurrences      |
| `for` loop               | Iterates through files       |

---

✅ **Best Practices**

* Always **backup files before bulk replacement**.

Example backup:

```bash
sed -i.bak "s/old/new/g" file.txt
```

* Limit replacement to specific file types:

```bash
find /opt/config -name "*.conf" -exec sed -i 's/old/new/g' {} \;
```

* Test replacement with `grep` before applying changes.

---

💡 **In short**

* Use `find` to list files.
* Use `sed -i` to replace words in place.
* Useful for **updating configurations across multiple files automatically**.

---
## Q58: Write a bash script to merge multiple CSV files into a single file, removing duplicate headers

🧠 **Overview**

* In many DevOps workflows (report aggregation, log exports, monitoring data), multiple **CSV files need to be merged into one dataset**.
* The challenge is that each CSV file usually contains its **own header row**, which must appear only once in the final file.
* This script merges multiple CSV files into one and **keeps only the first header**.

---

⚙️ **Purpose / How it works**

1. Select all `.csv` files from a directory.
2. Copy the **header from the first file**.
3. Append the data from remaining files **without headers**.
4. Produce a **single merged CSV report**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

OUTPUT_FILE="merged.csv"
FIRST_FILE=true

> $OUTPUT_FILE

for FILE in *.csv
do
    if $FIRST_FILE
    then
        cat "$FILE" >> $OUTPUT_FILE
        FIRST_FILE=false
    else
        tail -n +2 "$FILE" >> $OUTPUT_FILE
    fi
done

echo "CSV files merged into $OUTPUT_FILE"
```

---

🧩 **How to run**

Make script executable:

```bash
chmod +x merge_csv.sh
```

Run:

```bash
./merge_csv.sh
```

---

🧩 **Example Files**

file1.csv

```
Name,Age,City
Alice,25,London
Bob,30,New York
```

file2.csv

```
Name,Age,City
Charlie,28,Sydney
David,35,Berlin
```

---

🧩 **Output (merged.csv)**

```
Name,Age,City
Alice,25,London
Bob,30,New York
Charlie,28,Sydney
David,35,Berlin
```

Header appears **only once**.

---

📋 **Commands used**

| Command      | Purpose                    |
| ------------ | -------------------------- |
| `cat`        | Concatenates file contents |
| `tail -n +2` | Skips first line (header)  |
| `> file`     | Clears output file         |
| `for` loop   | Iterates through CSV files |

---

✅ **Best Practices**

* Validate CSV structure before merging.
* Ensure **all CSV files share the same column schema**.
* Use `sort` or `uniq` if you also need **duplicate row removal**.
* Store merged outputs in **reports directory**.

Example with sorting:

```bash
cat merged.csv | sort | uniq > final.csv
```

---

💡 **In short**

* Copy the header from the **first CSV file**.
* Append data from other files using `tail -n +2`.
* Produces a **single merged CSV without duplicate headers**.

---
## Q59: Write a bash script to extract specific columns from a CSV file and save to a new file

🧠 **Overview**

* CSV files are widely used for **reports, logs, monitoring data, and exports from databases or APIs**.
* DevOps engineers often need to **extract only certain columns** (e.g., username, IP, timestamp) for analysis.
* Tools like `cut` or `awk` can efficiently extract columns from CSV files.

---

⚙️ **Purpose / How it works**

1. Specify the **input CSV file**.
2. Choose the **column numbers to extract**.
3. Use `cut` or `awk` with comma delimiter.
4. Save extracted columns to a **new output file**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

INPUT_FILE="data.csv"
OUTPUT_FILE="filtered.csv"

# Extract columns 1 and 3
cut -d',' -f1,3 $INPUT_FILE > $OUTPUT_FILE

echo "Selected columns saved to $OUTPUT_FILE"
```

---

🧩 **How to run**

Make script executable:

```bash
chmod +x extract_columns.sh
```

Run:

```bash
./extract_columns.sh
```

---

🧩 **Example Input (data.csv)**

```
ID,Name,Department,Salary
1,Alice,Engineering,60000
2,Bob,Finance,55000
3,Charlie,IT,65000
```

---

🧩 **Output (filtered.csv)**

```
ID,Department
1,Engineering
2,Finance
3,IT
```

---

📋 **Commands used**

| Command | Purpose                   |
| ------- | ------------------------- |
| `cut`   | Extracts specific columns |
| `-d','` | Sets comma as delimiter   |
| `-f1,3` | Selects columns 1 and 3   |
| `>`     | Writes output to new file |

---

🧩 **Alternative using awk**

```bash
awk -F',' '{print $1","$3}' data.csv > filtered.csv
```

| Option  | Meaning                 |
| ------- | ----------------------- |
| `-F','` | Sets comma delimiter    |
| `$1,$3` | Prints selected columns |

---

✅ **Best Practices**

* Validate column numbers before extraction.
* Use `awk` when performing **complex filtering or transformations**.
* Combine with `sort` or `uniq` for data processing.

Example:

```bash
cut -d',' -f1,3 data.csv | sort | uniq
```

---

💡 **In short**

* Use `cut -d',' -f` to extract CSV columns.
* Save results to a **new file**.
* Useful for **data filtering and report generation**.

---
## Q60: Write a bash script to compare two text files and display the differences

🧠 **Overview**

* Comparing files is common in DevOps workflows when validating **configuration changes, log differences, or deployment outputs**.
* Linux provides tools like `diff` to identify **line-by-line differences between files**.
* This script compares two files and prints the differences if they exist.

---

⚙️ **Purpose / How it works**

1. Accept two file names as input.
2. Use `diff` to compare them.
3. If differences exist, display them.
4. If files are identical, print a confirmation message.

---

🧩 **Bash Script**

```bash
#!/bin/bash

FILE1=$1
FILE2=$2

if [ -z "$FILE1" ] || [ -z "$FILE2" ]; then
    echo "Usage: $0 <file1> <file2>"
    exit 1
fi

echo "Comparing $FILE1 and $FILE2"
echo "--------------------------------"

DIFF_OUTPUT=$(diff $FILE1 $FILE2)

if [ -z "$DIFF_OUTPUT" ]; then
    echo "Files are identical."
else
    echo "Differences found:"
    echo "$DIFF_OUTPUT"
fi
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x compare_files.sh
```

Run:

```bash
./compare_files.sh file1.txt file2.txt
```

---

🧩 **Example**

file1.txt

```
apple
banana
orange
```

file2.txt

```
apple
banana
grape
```

Output:

```
Comparing file1.txt and file2.txt
--------------------------------
Differences found:
3c3
< orange
---
> grape
```

---

📋 **Commands used**

| Command            | Purpose                     |
| ------------------ | --------------------------- |
| `diff file1 file2` | Compares two files          |
| `$?`               | Exit status of last command |
| `if` condition     | Checks if differences exist |
| `echo`             | Displays output             |

---

🧩 **Useful diff options**

| Option    | Description                    |
| --------- | ------------------------------ |
| `diff -u` | Unified format (common in Git) |
| `diff -y` | Side-by-side comparison        |
| `diff -q` | Only shows if files differ     |

Example:

```bash
diff -y file1.txt file2.txt
```

---

✅ **Best Practices**

* Use `diff -u` when reviewing **configuration changes**.
* Combine with **version control tools (Git)** for tracking modifications.
* Useful for comparing **backup files, configs, and logs**.

Example:

```bash
diff -u config_old.conf config_new.conf
```

---

💡 **In short**

* Use `diff` to compare two files.
* If differences exist → display them.
* Commonly used for **configuration and log comparison in DevOps workflows**.

----
## Q61: Write a bash script to count the number of occurrences of each word in a text file and display top 10 most frequent words

🧠 **Overview**

* Text analysis is useful in DevOps for **log analysis, error pattern detection, and content processing**.
* This script reads a text file, counts how many times each word appears, and displays the **top 10 most frequent words**.
* It uses common Linux tools like **tr, sort, uniq, and head** for efficient processing.

---

⚙️ **Purpose / How it works**

1. Read the input text file.
2. Convert text into **one word per line**.
3. Sort words alphabetically.
4. Count occurrences using `uniq -c`.
5. Sort by frequency and display **top 10 results**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

FILE=$1

if [ -z "$FILE" ]; then
    echo "Usage: $0 <text-file>"
    exit 1
fi

echo "Top 10 most frequent words in $FILE"
echo "-----------------------------------"

tr -cs '[:alnum:]' '\n' < "$FILE" | \
tr 'A-Z' 'a-z' | \
sort | \
uniq -c | \
sort -nr | \
head -10
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x word_count.sh
```

Run:

```bash
./word_count.sh sample.txt
```

---

🧩 **Example Input (sample.txt)**

```
DevOps automation improves efficiency.
DevOps tools help automate infrastructure.
Automation reduces manual errors.
```

---

🧩 **Example Output**

```
3 devops
2 automation
1 improves
1 efficiency
1 tools
1 help
1 automate
1 infrastructure
1 reduces
1 manual
```

---

📋 **Commands used**

| Command                   | Purpose                |
| ------------------------- | ---------------------- |
| `tr -cs '[:alnum:]' '\n'` | Splits text into words |
| `tr 'A-Z' 'a-z'`          | Converts to lowercase  |
| `sort`                    | Sorts words            |
| `uniq -c`                 | Counts occurrences     |
| `sort -nr`                | Sorts by frequency     |
| `head -10`                | Shows top 10 results   |

---

✅ **Best Practices**

* Normalize text by converting to **lowercase** to avoid duplicates (`DevOps` vs `devops`).
* Remove punctuation when analyzing logs or text.
* Useful for analyzing **log files, error patterns, or large text datasets**.

Example for log analysis:

```bash
./word_count.sh /var/log/syslog
```

---

💡 **In short**

* Split text into words.
* Count occurrences using `uniq -c`.
* Sort by frequency and display the **top 10 most common words**.

---
## Q62: Write a bash script to remove duplicate lines from a file while preserving the order

🧠 **Overview**

* Removing duplicate lines is common when processing **logs, configuration files, or data exports**.
* Standard tools like `uniq` remove duplicates only from **sorted files**, which changes the order.
* This script uses `awk` to remove duplicates **while preserving the original order of lines**.

---

⚙️ **Purpose / How it works**

1. Read the input file line by line.
2. Track each line using an **associative array**.
3. Print the line only if it appears **for the first time**.
4. Write the output to a new file.

---

🧩 **Bash Script**

```bash
#!/bin/bash

INPUT_FILE=$1
OUTPUT_FILE="unique_lines.txt"

if [ -z "$INPUT_FILE" ]; then
    echo "Usage: $0 <input-file>"
    exit 1
fi

awk '!seen[$0]++' "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Duplicate lines removed."
echo "Output saved to $OUTPUT_FILE"
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x remove_duplicates.sh
```

Run:

```bash
./remove_duplicates.sh data.txt
```

---

🧩 **Example Input (data.txt)**

```
apple
banana
apple
orange
banana
grape
```

---

🧩 **Output (unique_lines.txt)**

```
apple
banana
orange
grape
```

Order is **preserved**, duplicates removed.

---

📋 **Commands used**

| Command       | Purpose                                |
| ------------- | -------------------------------------- |
| `awk`         | Text processing tool                   |
| `!seen[$0]++` | Prints line only first time it appears |
| `>`           | Redirects output to file               |

---

🧩 **Alternative using sort (order not preserved)**

```bash
sort data.txt | uniq
```

| Method              | Order Preserved |      |
| ------------------- | --------------- | ---- |
| `awk '!seen[$0]++'` | ✅ Yes           |      |
| `sort               | uniq`           | ❌ No |

---

✅ **Best Practices**

* Use `awk` when **line order matters** (e.g., log analysis).
* Use `sort | uniq` when **order does not matter and performance is critical**.
* Always keep a **backup before modifying production files**.

Example for logs:

```bash
awk '!seen[$0]++' /var/log/app.log > cleaned.log
```

---

💡 **In short**

* Use `awk '!seen[$0]++' file` to remove duplicates.
* Keeps the **first occurrence and preserves the original order**.
* Useful for **log cleanup and data processing tasks**.

----
## Q63: Write a bash script to sort a file by a specific column (e.g., sort CSV by 3rd column)

🧠 **Overview**

* Sorting files by a specific column is common when working with **CSV reports, logs, or exported datasets**.
* DevOps engineers often sort data by **timestamp, status, or metrics** to analyze results.
* Linux provides the `sort` command with a **field delimiter and key option** to sort based on a chosen column.

---

⚙️ **Purpose / How it works**

1. Define the **input CSV file**.
2. Use `sort` with `-t` to specify the delimiter (comma for CSV).
3. Use `-k` to specify the column number.
4. Save the sorted output to a **new file**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

INPUT_FILE="data.csv"
OUTPUT_FILE="sorted.csv"
COLUMN=3

sort -t',' -k$COLUMN,$COLUMN $INPUT_FILE > $OUTPUT_FILE

echo "File sorted by column $COLUMN and saved to $OUTPUT_FILE"
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x sort_csv.sh
```

Run:

```bash
./sort_csv.sh
```

---

🧩 **Example Input (data.csv)**

```
ID,Name,Score
1,Alice,85
2,Bob,90
3,Charlie,78
4,David,92
```

---

🧩 **Output (sorted.csv)**

```
ID,Name,Score
3,Charlie,78
1,Alice,85
2,Bob,90
4,David,92
```

Sorted by **3rd column (Score)**.

---

📋 **Important sort options**

| Option  | Purpose                 |
| ------- | ----------------------- |
| `-t','` | Sets comma as delimiter |
| `-k3,3` | Sort by column 3        |
| `-n`    | Numeric sorting         |
| `-r`    | Reverse order           |

Example numeric sort:

```bash
sort -t',' -k3,3n data.csv
```

Example reverse order:

```bash
sort -t',' -k3,3nr data.csv
```

---

✅ **Best Practices**

* Use `-n` when sorting **numeric values**.
* Skip headers if needed using `tail`.

Example:

```bash
(head -n 1 data.csv && tail -n +2 data.csv | sort -t',' -k3,3n) > sorted.csv
```

* Validate CSV structure before sorting large datasets.

---

💡 **In short**

* Use `sort -t',' -k3,3` to sort by the **3rd column in a CSV file**.
* Add `-n` for numeric sorting and `-r` for reverse order.

----
## Q64: Write a bash script to create a compressed backup of a directory with a timestamp in the filename

🧠 **Overview**

* Regular backups are critical for protecting **application data, configuration files, and logs**.
* DevOps engineers often create automated backups with **timestamps** so multiple backup versions can be stored safely.
* This script compresses a directory into a **`.tar.gz` archive** and includes the **current date and time in the filename**.

---

⚙️ **Purpose / How it works**

1. Accept the **directory to backup** as input.
2. Generate a **timestamp** using the `date` command.
3. Create a compressed archive using `tar`.
4. Save the backup with a **timestamped filename**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

SOURCE_DIR=$1
BACKUP_DIR="./backups"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p $BACKUP_DIR

BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

tar -czf $BACKUP_FILE $SOURCE_DIR

echo "Backup created: $BACKUP_FILE"
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x backup_directory.sh
```

Run the script:

```bash
./backup_directory.sh /opt/app
```

---

🧩 **Example Output**

```
Backup created: backups/backup_20260304_163210.tar.gz
```

Backup file structure:

```
backups/
backup_20260304_163210.tar.gz
```

---

📋 **Commands used**

| Command                 | Purpose                    |
| ----------------------- | -------------------------- |
| `date +"%Y%m%d_%H%M%S"` | Generates timestamp        |
| `mkdir -p`              | Creates backup directory   |
| `tar -czf`              | Creates compressed archive |
| `.tar.gz`               | Gzip compressed tar file   |

---

🧩 **Tar command breakdown**

| Option | Meaning             |
| ------ | ------------------- |
| `-c`   | Create archive      |
| `-z`   | Compress using gzip |
| `-f`   | Specify output file |

Example manual backup:

```bash
tar -czf backup_$(date +%F).tar.gz /opt/app
```

---

✅ **Best Practices**

* Store backups in a **dedicated backup directory**.
* Schedule backups using **cron jobs**.
* Verify backup integrity regularly.
* Upload backups to **cloud storage (S3, GCS, etc.)** for disaster recovery.

Example cron job (daily backup at 2 AM):

```bash
0 2 * * * /opt/scripts/backup_directory.sh /opt/app
```

---

💡 **In short**

* Use `tar -czf` to create compressed backups.
* Add a **timestamp using `date`** to maintain multiple backup versions.
* Automate using **cron for scheduled backups**.

---
## Q65: Write a bash script to backup MySQL databases and compress them with date-stamped filenames

🧠 **Overview**

* Database backups are critical for **data recovery, disaster recovery, and production safety**.
* DevOps engineers typically use `mysqldump` to export MySQL databases and compress them using `gzip`.
* This script creates a **compressed MySQL backup with a timestamp**, enabling versioned backups.

---

⚙️ **Purpose / How it works**

1. Define **MySQL credentials and database name**.
2. Generate a **timestamp** for the backup filename.
3. Use `mysqldump` to export the database.
4. Compress the dump using `gzip`.
5. Store the backup in a **backup directory**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

DB_USER="root"
DB_PASSWORD="password"
DB_NAME="mydatabase"
BACKUP_DIR="/backup/mysql"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p $BACKUP_DIR

BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_$TIMESTAMP.sql.gz"

mysqldump -u $DB_USER -p$DB_PASSWORD $DB_NAME | gzip > $BACKUP_FILE

echo "Database backup created: $BACKUP_FILE"
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x mysql_backup.sh
```

Run the script:

```bash
./mysql_backup.sh
```

---

🧩 **Example Output**

```
Database backup created: /backup/mysql/mydatabase_backup_20260304_164520.sql.gz
```

Backup file example:

```
/backup/mysql/
mydatabase_backup_20260304_164520.sql.gz
```

---

📋 **Commands used**

| Command     | Purpose                  |
| ----------- | ------------------------ |
| `mysqldump` | Exports MySQL database   |
| `gzip`      | Compresses the backup    |
| `date`      | Generates timestamp      |
| `mkdir -p`  | Creates backup directory |

---

🧩 **Backup all databases (optional)**

```bash
mysqldump -u root -p --all-databases | gzip > all_db_backup_$(date +%F).sql.gz
```

---

🧩 **Restore backup example**

```bash
gunzip < backup.sql.gz | mysql -u root -p mydatabase
```

---

✅ **Best Practices**

* Avoid storing **passwords directly in scripts** (use `.my.cnf` or environment variables).
* Store backups on **remote storage like AWS S3 or NFS**.
* Automate backups with **cron jobs**.
* Periodically test **backup restoration**.

Example cron job (daily backup at 1 AM):

```bash
0 1 * * * /opt/scripts/mysql_backup.sh
```

---

💡 **In short**

* Use `mysqldump` to export MySQL databases.
* Compress using `gzip`.
* Include a **timestamp in the filename** for versioned backups.

---
## Q66: Write a bash script to sync files from a local directory to a remote server using rsync

🧠 **Overview**

* File synchronization is common in DevOps workflows for **backups, deployments, and artifact distribution**.
* `rsync` is a powerful tool that transfers **only changed files**, making it efficient for large datasets.
* This script syncs a **local directory to a remote server using SSH**.

---

⚙️ **Purpose / How it works**

1. Define the **local directory** and **remote server details**.
2. Use `rsync` with archive mode (`-a`) to preserve file attributes.
3. Use `-z` for compression during transfer.
4. Use SSH for **secure remote synchronization**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

LOCAL_DIR="/opt/app/"
REMOTE_USER="ubuntu"
REMOTE_HOST="192.168.1.100"
REMOTE_DIR="/var/www/app/"

rsync -avz -e ssh $LOCAL_DIR ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}

echo "File sync completed."
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x sync_files.sh
```

Run the script:

```bash
./sync_files.sh
```

---

🧩 **Example Output**

```
sending incremental file list
index.html
app.js
config.yaml

sent 2,340 bytes  received 120 bytes  total size 4,500
File sync completed.
```

---

📋 **Important rsync options**

| Option     | Purpose                                          |
| ---------- | ------------------------------------------------ |
| `-a`       | Archive mode (preserves permissions, timestamps) |
| `-v`       | Verbose output                                   |
| `-z`       | Compress data during transfer                    |
| `-e ssh`   | Use SSH for secure connection                    |
| `--delete` | Remove files on remote not present locally       |

Example with delete sync:

```bash
rsync -avz --delete -e ssh /opt/app/ ubuntu@192.168.1.100:/var/www/app/
```

---

🧩 **Example use cases**

| Use Case                | Example                           |
| ----------------------- | --------------------------------- |
| Deploy static website   | Sync `/dist` folder to web server |
| Backup server files     | Sync `/data` to backup server     |
| CI/CD artifact transfer | Push build output to remote host  |

---

✅ **Best Practices**

* Use **SSH key-based authentication** instead of passwords.
* Use `--delete` carefully to avoid accidental file removal.
* Run rsync in **dry-run mode** before production:

```bash
rsync -avz --dry-run /opt/app/ user@server:/var/www/app/
```

* Schedule sync jobs with **cron** if needed.

Example cron job:

```bash
0 * * * * /opt/scripts/sync_files.sh
```

---

💡 **In short**

* `rsync` efficiently syncs files between systems.
* Use `rsync -avz -e ssh` for **secure incremental file transfers**.
* Commonly used for **deployments, backups, and server synchronization**.

----
## Q67: Write a bash script to create incremental backups keeping only the last 7 days of backups

🧠 **Overview**

* Incremental backups store **only files that changed since the last backup**, saving storage and time.
* DevOps teams use tools like **rsync with `--link-dest`** to create efficient incremental backups.
* This script creates **daily timestamped backups** and automatically removes backups older than **7 days**.

---

⚙️ **Purpose / How it works**

1. Define the **source directory and backup location**.
2. Generate a **date-based directory** for each backup.
3. Use `rsync` with `--link-dest` to create incremental backups using hard links.
4. Delete backup directories older than **7 days**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

SOURCE_DIR="/opt/data"
BACKUP_DIR="/backup/incremental"

DATE=$(date +%F)
TODAY_BACKUP="$BACKUP_DIR/$DATE"

LAST_BACKUP=$(ls -dt $BACKUP_DIR/* 2>/dev/null | head -1)

mkdir -p $TODAY_BACKUP

if [ -d "$LAST_BACKUP" ]; then
    rsync -a --delete --link-dest=$LAST_BACKUP $SOURCE_DIR/ $TODAY_BACKUP/
else
    rsync -a $SOURCE_DIR/ $TODAY_BACKUP/
fi

echo "Backup completed: $TODAY_BACKUP"

# Delete backups older than 7 days
find $BACKUP_DIR -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \;

echo "Old backups older than 7 days removed."
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x incremental_backup.sh
```

Run:

```bash
./incremental_backup.sh
```

---

🧩 **Example Backup Structure**

```
/backup/incremental/
2026-03-01/
2026-03-02/
2026-03-03/
2026-03-04/
```

Each directory contains **incremental backup snapshots**.

---

📋 **Commands used**

| Command          | Purpose                                          |
| ---------------- | ------------------------------------------------ |
| `rsync -a`       | Archive mode (preserves permissions, timestamps) |
| `--link-dest`    | Creates incremental backups using hard links     |
| `date +%F`       | Generates date for backup directory              |
| `find -mtime +7` | Finds files older than 7 days                    |
| `rm -rf`         | Deletes old backups                              |

---

🧩 **Example rsync incremental logic**

```
Day1 → Full backup
Day2 → Only changed files stored
Day3 → Only changed files stored
```

Unchanged files are **hard-linked**, saving space.

---

✅ **Best Practices**

* Store backups on **separate storage (NFS, S3, backup server)**.
* Test **restore procedures regularly**.
* Monitor backup size and integrity.
* Use **cron jobs for automated daily backups**.

Example cron job (daily at 2 AM):

```bash
0 2 * * * /opt/scripts/incremental_backup.sh
```

---

💡 **In short**

* Use `rsync --link-dest` for incremental backups.
* Create **daily timestamped backup directories**.
* Automatically remove backups older than **7 days**.

---
## Q68: Write a bash script to backup files to AWS S3 with automatic deletion of backups older than 30 days

🧠 **Overview**

* Storing backups in **AWS S3** provides durable and scalable storage for logs, databases, and application data.
* DevOps engineers commonly upload backups to S3 using the **AWS CLI**.
* This script creates a **compressed backup**, uploads it to **S3**, and removes backups older than **30 days**.

---

⚙️ **Purpose / How it works**

1. Define the **source directory** to backup.
2. Create a **timestamped compressed archive** using `tar`.
3. Upload the backup file to **AWS S3 using aws cli**.
4. Remove **local backups older than 30 days**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

SOURCE_DIR="/opt/app"
BACKUP_DIR="/backup"
S3_BUCKET="s3://my-backup-bucket/app-backups"

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/app_backup_$DATE.tar.gz"

mkdir -p $BACKUP_DIR

# Create backup
tar -czf $BACKUP_FILE $SOURCE_DIR

# Upload to S3
aws s3 cp $BACKUP_FILE $S3_BUCKET/

echo "Backup uploaded to S3: $BACKUP_FILE"

# Delete local backups older than 30 days
find $BACKUP_DIR -type f -mtime +30 -name "*.tar.gz" -exec rm -f {} \;

echo "Old backups older than 30 days removed."
```

---

🧩 **How to run**

Make script executable:

```bash
chmod +x s3_backup.sh
```

Run:

```bash
./s3_backup.sh
```

---

🧩 **Example Output**

```
Backup uploaded to S3: /backup/app_backup_20260304_172200.tar.gz
Old backups older than 30 days removed.
```

---

📋 **Commands used**

| Command           | Purpose                        |
| ----------------- | ------------------------------ |
| `tar -czf`        | Creates compressed backup      |
| `aws s3 cp`       | Uploads file to S3             |
| `date`            | Generates timestamp            |
| `find -mtime +30` | Finds files older than 30 days |
| `rm -f`           | Deletes old backups            |

---

🧩 **AWS CLI setup**

Install AWS CLI:

```bash
sudo apt install awscli
```

Configure credentials:

```bash
aws configure
```

You will provide:

```
AWS Access Key
AWS Secret Key
Region
Output format
```

---

✅ **Best Practices**

* Use **IAM roles instead of storing AWS keys on servers**.
* Enable **S3 lifecycle policies** to automatically delete old backups.
* Encrypt backups using **SSE-S3 or SSE-KMS**.
* Store backups in **separate AWS accounts or regions for disaster recovery**.

Example encrypted upload:

```bash
aws s3 cp backup.tar.gz s3://my-bucket/ --sse AES256
```

---

💡 **In short**

* Create a **compressed backup using tar**.
* Upload backup to **AWS S3 using aws CLI**.
* Automatically delete **local backups older than 30 days**.

----
## Q69: Write a bash script with proper error handling (`set -e`, `trap`) that exits gracefully on errors and cleans up temporary files

🧠 **Overview**

* Production Bash scripts should handle failures safely to avoid **partial execution, corrupted files, or leftover temporary data**.
* DevOps engineers commonly use **`set -e` to stop execution on errors** and **`trap` to perform cleanup actions** before exiting.
* This script demonstrates robust error handling and automatic cleanup of temporary files.

---

⚙️ **Purpose / How it works**

1. `set -e` stops the script if any command fails.
2. Create temporary files during execution.
3. Use `trap` to define a cleanup function.
4. If the script exits (success or failure), the cleanup function removes temporary files.

---

🧩 **Bash Script**

```bash
#!/bin/bash

set -e

TEMP_FILE="/tmp/temp_data.$$"

cleanup() {
    echo "Cleaning up temporary files..."
    rm -f "$TEMP_FILE"
}

trap cleanup EXIT

echo "Creating temporary file..."
touch "$TEMP_FILE"

echo "Writing sample data..."
echo "Processing data..." > "$TEMP_FILE"

# Example command (simulate processing)
cat "$TEMP_FILE"

echo "Script completed successfully."
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x safe_script.sh
```

Run:

```bash
./safe_script.sh
```

---

🧩 **Example Output**

```
Creating temporary file...
Writing sample data...
Processing data...
Script completed successfully.
Cleaning up temporary files...
```

Even if the script fails, the cleanup function runs.

---

📋 **Key Bash Error Handling Options**

| Option            | Purpose                             |
| ----------------- | ----------------------------------- |
| `set -e`          | Exit immediately if a command fails |
| `set -u`          | Error on undefined variables        |
| `set -o pipefail` | Detect failures in pipelines        |
| `trap`            | Run cleanup code on exit or signals |

Recommended production header:

```bash
set -euo pipefail
```

---

🧩 **Example with failure handling**

```bash
#!/bin/bash
set -euo pipefail

TMP="/tmp/script.$$"

cleanup() {
    echo "Cleaning temporary files..."
    rm -f "$TMP"
}

trap cleanup EXIT

touch "$TMP"

# Simulate error
false

echo "This line will not execute"
```

The cleanup still runs.

---

✅ **Best Practices**

* Always enable **strict mode (`set -euo pipefail`)**.
* Use `trap` for **cleanup and graceful exit**.
* Store temporary files in `/tmp` with **unique names (`$$` PID)**.
* Log errors for troubleshooting in production scripts.

Example temp file pattern:

```bash
TEMP_FILE=$(mktemp)
```

---

💡 **In short**

* `set -e` stops scripts on errors.
* `trap cleanup EXIT` ensures temporary files are removed.
* Essential for **safe, production-grade Bash automation**.

---
## Q70: Write a bash script that implements retry logic with exponential backoff for a failing command

🧠 **Overview**

* In production automation (CI/CD, API calls, downloads, deployments), commands may fail due to **network issues, temporary service outages, or rate limits**.
* DevOps engineers implement **retry logic with exponential backoff**, where each retry waits longer than the previous one.
* This improves reliability and prevents overwhelming services during failures.

---

⚙️ **Purpose / How it works**

1. Define the **command to run**.
2. Set **maximum retry attempts**.
3. If the command fails, wait before retrying.
4. Increase wait time exponentially (2s → 4s → 8s → 16s).
5. Exit successfully if command succeeds.

---

🧩 **Bash Script**

```bash
#!/bin/bash

MAX_RETRIES=5
BASE_DELAY=2

COMMAND="curl -f https://example.com"

attempt=1

while [ $attempt -le $MAX_RETRIES ]
do
    echo "Attempt $attempt..."

    if $COMMAND; then
        echo "Command succeeded."
        exit 0
    fi

    delay=$((BASE_DELAY ** attempt))
    echo "Command failed. Retrying in $delay seconds..."

    sleep $delay
    attempt=$((attempt + 1))
done

echo "Command failed after $MAX_RETRIES attempts."
exit 1
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x retry_script.sh
```

Run:

```bash
./retry_script.sh
```

---

🧩 **Example Output**

```
Attempt 1...
Command failed. Retrying in 2 seconds...

Attempt 2...
Command failed. Retrying in 4 seconds...

Attempt 3...
Command succeeded.
```

---

📋 **Key Components**

| Component                    | Purpose                          |
| ---------------------------- | -------------------------------- |
| `MAX_RETRIES`                | Maximum number of retry attempts |
| `BASE_DELAY`                 | Base delay for exponential wait  |
| `sleep`                      | Wait before retry                |
| `$((BASE_DELAY ** attempt))` | Exponential backoff calculation  |

---

🧩 **Typical DevOps Use Cases**

| Scenario         | Example                       |
| ---------------- | ----------------------------- |
| API calls        | Retry failed REST API request |
| File downloads   | Retry artifact download       |
| Service checks   | Wait for service startup      |
| Cloud operations | Retry AWS CLI commands        |

Example AWS retry:

```bash
aws s3 cp file.txt s3://mybucket/ || retry
```

---

✅ **Best Practices**

* Use **exponential backoff instead of constant retry delay**.
* Limit retries to prevent infinite loops.
* Log failures for troubleshooting.
* Combine with **timeout checks** in automation pipelines.

Example with timeout:

```bash
timeout 10 curl https://example.com
```

---

💡 **In short**

* Retry a command if it fails.
* Increase wait time exponentially between retries.
* Improves **resilience in automation scripts and CI/CD pipelines**.

---
## Q71: Write a bash script to monitor a directory for new files and automatically process them when detected (using `inotify` or a polling loop)

🧠 **Overview**

* In many DevOps pipelines, systems must **detect new files and process them automatically** (e.g., log ingestion, ETL jobs, CI artifact processing).
* Linux provides **`inotify`**, which allows real-time monitoring of filesystem events such as file creation or modification.
* This script watches a directory and **triggers a processing action when a new file appears**.

---

⚙️ **Purpose / How it works**

1. Monitor a directory for **file creation events**.
2. When a new file is detected, trigger a **processing function**.
3. The processing function can perform actions such as:

   * Move file
   * Upload to S3
   * Parse logs
   * Trigger ETL pipeline.

---

🧩 **Bash Script using `inotifywait` (real-time monitoring)**

```bash
#!/bin/bash

WATCH_DIR="/opt/input"

echo "Monitoring directory: $WATCH_DIR"

inotifywait -m -e create "$WATCH_DIR" --format "%f" |
while read FILE
do
    echo "New file detected: $FILE"

    # Example processing
    echo "Processing file $FILE..."
    cat "$WATCH_DIR/$FILE"

    echo "Processing completed for $FILE"
done
```

---

🧩 **How to run**

Install inotify tools:

```bash
sudo apt install inotify-tools
```

Make script executable:

```bash
chmod +x monitor_directory.sh
```

Run:

```bash
./monitor_directory.sh
```

---

🧩 **Example Output**

```
Monitoring directory: /opt/input
New file detected: data.txt
Processing file data.txt...
Processing completed for data.txt
```

---

📋 **Important inotify options**

| Option          | Purpose                     |
| --------------- | --------------------------- |
| `-m`            | Monitor continuously        |
| `-e create`     | Detect file creation events |
| `--format "%f"` | Print filename only         |
| `inotifywait`   | Watches filesystem events   |

---

🧩 **Alternative: Polling-based script (without inotify)**

```bash
#!/bin/bash

WATCH_DIR="/opt/input"

while true
do
    for FILE in $WATCH_DIR/*
    do
        if [ -f "$FILE" ]; then
            echo "Processing $FILE"
            cat "$FILE"

            mv "$FILE" "$FILE.processed"
        fi
    done

    sleep 5
done
```

This checks the directory **every 5 seconds**.

---

📋 **inotify vs Polling**

| Method       | Advantage           | Disadvantage           |
| ------------ | ------------------- | ---------------------- |
| `inotify`    | Real-time detection | Requires inotify-tools |
| Polling loop | Works everywhere    | Higher CPU usage       |

---

✅ **Best Practices**

* Move processed files to **archive directory** to avoid reprocessing.
* Add **logging and error handling** for production pipelines.
* Use in **data ingestion pipelines, log processing systems, and automation workflows**.
* Combine with tools like **Kafka producers, S3 uploads, or ETL scripts**.

Example production flow:

```
Incoming files → monitored directory → script → processing pipeline
```

---

💡 **In short**

* `inotifywait` monitors directories for **real-time file events**.
* Script triggers processing automatically when **new files appear**.
* Common in **automation pipelines and data processing systems**.

---
## Q72: Write a bash script that deploys an application: stops the service, backs up current version, deploys new version, starts service, and rolls back if health check fails

🧠 **Overview**

* Deployment automation is a core DevOps task.
* A safe deployment should **stop the running service, backup the current version, deploy the new version, verify health, and rollback automatically if something fails**.
* This pattern is commonly used in **CI/CD pipelines for web applications and microservices**.

---

⚙️ **Purpose / How it works**

1. Stop the running service.
2. Backup the current application version.
3. Deploy the new version.
4. Start the service.
5. Perform a **health check**.
6. If health check fails → rollback to previous version.

---

🧩 **Bash Script**

```bash
#!/bin/bash

SERVICE="myapp"
APP_DIR="/opt/myapp"
NEW_VERSION="/tmp/new_release"
BACKUP_DIR="/opt/backups"
HEALTH_URL="http://localhost:8080/health"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/myapp_backup_$TIMESTAMP.tar.gz"

echo "Starting deployment..."

# Stop service
echo "Stopping service..."
systemctl stop $SERVICE

# Backup current version
echo "Backing up current version..."
mkdir -p $BACKUP_DIR
tar -czf $BACKUP_FILE $APP_DIR

# Deploy new version
echo "Deploying new version..."
cp -r $NEW_VERSION/* $APP_DIR/

# Start service
echo "Starting service..."
systemctl start $SERVICE

sleep 5

# Health check
echo "Running health check..."
if curl -f $HEALTH_URL > /dev/null 2>&1; then
    echo "Deployment successful."
else
    echo "Health check failed! Rolling back..."

    systemctl stop $SERVICE

    rm -rf $APP_DIR/*
    tar -xzf $BACKUP_FILE -C /

    systemctl start $SERVICE

    echo "Rollback completed."
    exit 1
fi
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x deploy_app.sh
```

Run:

```bash
./deploy_app.sh
```

---

🧩 **Deployment Flow**

```
Stop service
      ↓
Backup current version
      ↓
Deploy new release
      ↓
Start service
      ↓
Health check
   ↓         ↓
Success   Failure
   ↓         ↓
Done     Rollback
```

---

📋 **Commands used**

| Command                | Purpose                        |
| ---------------------- | ------------------------------ |
| `systemctl stop/start` | Control application service    |
| `tar -czf`             | Backup current application     |
| `cp -r`                | Deploy new files               |
| `curl -f`              | Perform health check           |
| `tar -xzf`             | Restore backup during rollback |

---

✅ **Best Practices**

* Always perform **health checks after deployment**.
* Keep **timestamped backups for quick rollback**.
* Use **blue-green or canary deployments** in production.
* Integrate with **CI/CD pipelines (Jenkins, GitLab, ArgoCD)**.
* Log deployment steps for auditing.

Example health check:

```bash
curl -f http://localhost:8080/health
```

---

💡 **In short**

* Stop service → backup current version → deploy new version.
* Start service and run **health check**.
* If health check fails → **automatically rollback to previous version**.

---
## Q73: Write a bash script to parse command-line arguments using `getopts` for flags like `-h` (help), `-v` (verbose), `-f` (file)

🧠 **Overview**

* Bash scripts often require **command-line arguments** to control behavior (e.g., specifying input files, enabling verbose logs).
* `getopts` is a built-in Bash utility used to **parse short options like `-h`, `-v`, `-f` safely**.
* This approach is widely used in **DevOps automation scripts, CLI tools, and deployment utilities**.

---

⚙️ **Purpose / How it works**

1. Define flags supported by the script.
2. Use `getopts` to process arguments.
3. Execute different logic depending on the provided options.
4. Handle invalid flags gracefully.

---

🧩 **Bash Script**

```bash
#!/bin/bash

VERBOSE=false
FILE=""

usage() {
    echo "Usage: $0 [-h] [-v] [-f filename]"
    echo "  -h            Show help"
    echo "  -v            Enable verbose mode"
    echo "  -f <file>     Specify input file"
}

while getopts ":hvf:" opt
do
    case ${opt} in
        h )
            usage
            exit 0
            ;;
        v )
            VERBOSE=true
            ;;
        f )
            FILE=$OPTARG
            ;;
        \? )
            echo "Invalid option: -$OPTARG"
            usage
            exit 1
            ;;
    esac
done

echo "Verbose mode: $VERBOSE"
echo "File: $FILE"
```

---

🧩 **How to run**

Make the script executable:

```bash
chmod +x parse_args.sh
```

Run examples:

```bash
./parse_args.sh -h
```

```bash
./parse_args.sh -v -f data.txt
```

---

🧩 **Example Output**

```bash
Verbose mode: true
File: data.txt
```

---

📋 **Important getopts components**

| Component | Purpose                                     |
| --------- | ------------------------------------------- |
| `getopts` | Parses command-line flags                   |
| `:hvf:`   | Defines valid flags (`f:` expects argument) |
| `$OPTARG` | Value passed to option                      |
| `$opt`    | Current flag being processed                |
| `case`    | Handles each flag                           |

---

🧩 **Flag definition explanation**

| Flag | Meaning                    |
| ---- | -------------------------- |
| `h`  | Help flag                  |
| `v`  | Verbose mode               |
| `f:` | File flag (requires value) |

Example call:

```bash
./script.sh -f config.yaml
```

---

✅ **Best Practices**

* Always include a **help option (`-h`)**.
* Validate required arguments before running logic.
* Use `getopts` instead of manual parsing for **cleaner scripts**.
* Combine with logging flags like `-v` for debugging automation scripts.

Example validation:

```bash
if [ -z "$FILE" ]; then
    echo "Error: File argument required"
    exit 1
fi
```

---

💡 **In short**

* `getopts` is used to parse **command-line flags in Bash scripts**.
* Handles options like `-h`, `-v`, `-f` cleanly and safely.
* Essential for building **professional CLI automation scripts**.

---
## Q74: Write a bash script that runs multiple commands in parallel using background processes (`&`) and waits for all to complete

🧠 **Overview**

* In automation workflows, running tasks **sequentially can slow down execution**.
* Bash allows commands to run in **parallel using background processes (`&`)**.
* The `wait` command ensures the script **pauses until all background jobs finish**, which is useful for **parallel builds, batch processing, or multi-server operations**.

---

⚙️ **Purpose / How it works**

1. Start multiple commands in the background using `&`.
2. Each command runs **simultaneously**.
3. Use `wait` to pause the script until all background tasks complete.
4. Continue execution after all processes finish.

---

🧩 **Bash Script**

```bash
#!/bin/bash

echo "Starting tasks in parallel..."

task1() {
    echo "Task 1 started"
    sleep 3
    echo "Task 1 completed"
}

task2() {
    echo "Task 2 started"
    sleep 5
    echo "Task 2 completed"
}

task3() {
    echo "Task 3 started"
    sleep 2
    echo "Task 3 completed"
}

task1 &
task2 &
task3 &

echo "Waiting for all tasks to finish..."

wait

echo "All tasks completed."
```

---

🧩 **How to run**

Make script executable:

```bash
chmod +x parallel_tasks.sh
```

Run:

```bash
./parallel_tasks.sh
```

---

🧩 **Example Output**

```
Starting tasks in parallel...
Task 1 started
Task 2 started
Task 3 started
Waiting for all tasks to finish...
Task 3 completed
Task 1 completed
Task 2 completed
All tasks completed.
```

Notice tasks **finish in different order** because they run in parallel.

---

📋 **Key Bash Concepts**

| Command | Purpose                            |
| ------- | ---------------------------------- |
| `&`     | Runs command in background         |
| `wait`  | Waits for all background jobs      |
| `$!`    | Returns PID of last background job |
| `jobs`  | Lists running background jobs      |

---

🧩 **Example: Parallel server checks**

```bash
for SERVER in server1 server2 server3
do
    ping -c 1 $SERVER &
done

wait
echo "All servers checked."
```

Useful for **parallel health checks or remote operations**.

---

✅ **Best Practices**

* Use `wait` to prevent scripts from exiting before tasks finish.
* Limit parallel jobs in large workloads to avoid CPU overload.
* Capture exit status for error handling in production scripts.

Example capturing process IDs:

```bash
cmd1 &
PID1=$!

cmd2 &
PID2=$!

wait $PID1 $PID2
```

---

💡 **In short**

* Use `&` to run commands in **parallel**.
* Use `wait` to **pause until all background tasks finish**.
* Improves performance in **automation and batch processing scripts**.

---
## Q75: Write a bash script to implement a simple job queue that processes tasks from a file one by one with logging

🧠 **Overview**

* In automation workflows, tasks are often stored in a **queue file** and processed sequentially.
* DevOps engineers use job queues to handle **batch jobs, deployments, log processing, or scheduled tasks**.
* This script reads tasks from a file, executes them **one by one**, and logs execution details.

---

⚙️ **Purpose / How it works**

1. Maintain a **queue file containing commands/tasks**.
2. Read tasks line-by-line.
3. Execute each task sequentially.
4. Log task execution status with timestamps.

---

🧩 **Bash Script**

```bash
#!/bin/bash

QUEUE_FILE="jobs.txt"
LOG_FILE="job_queue.log"

echo "Starting job queue processing..." | tee -a $LOG_FILE

while read -r JOB
do
    echo "----------------------------------" | tee -a $LOG_FILE
    echo "$(date) - Running job: $JOB" | tee -a $LOG_FILE

    eval "$JOB" >> $LOG_FILE 2>&1

    if [ $? -eq 0 ]; then
        echo "$(date) - Job completed successfully." | tee -a $LOG_FILE
    else
        echo "$(date) - Job failed." | tee -a $LOG_FILE
    fi

done < "$QUEUE_FILE"

echo "All jobs processed." | tee -a $LOG_FILE
```

---

🧩 **Example Job Queue File**

jobs.txt

```
echo "Processing file A"
sleep 2
ls -l /tmp
date
```

Each line represents **one job**.

---

🧩 **How to run**

Make script executable:

```bash
chmod +x job_queue.sh
```

Run:

```bash
./job_queue.sh
```

---

🧩 **Example Log Output**

```
Starting job queue processing...
----------------------------------
2026-03-04 17:45:10 - Running job: echo "Processing file A"
Processing file A
2026-03-04 17:45:10 - Job completed successfully.
----------------------------------
2026-03-04 17:45:12 - Running job: sleep 2
2026-03-04 17:45:14 - Job completed successfully.
```

Log file → `job_queue.log`.

---

📋 **Commands used**

| Command      | Purpose                            |
| ------------ | ---------------------------------- |
| `while read` | Reads tasks line-by-line           |
| `eval`       | Executes command from file         |
| `date`       | Adds timestamp to logs             |
| `tee -a`     | Writes output to console and log   |
| `>>`         | Appends command output to log file |

---

🧩 **Execution Flow**

```
jobs.txt
   ↓
Read task
   ↓
Execute command
   ↓
Log result
   ↓
Next task
```

---

✅ **Best Practices**

* Validate job inputs to avoid **malicious commands**.
* Use **locking mechanisms** if multiple scripts access the queue.
* Store logs in `/var/log/` for production systems.
* Consider advanced queues like **RabbitMQ, Kafka, or Celery** for large-scale systems.

Example safe job execution:

```bash
bash -c "$JOB"
```

---

💡 **In short**

* Store tasks in a **queue file**.
* Script reads and executes tasks **one by one**.
* Logs each job’s **execution status and timestamp**.

---
## Q76: Write a bash script to update all packages on a Debian/Ubuntu system (apt) or RHEL/CentOS (yum/dnf)

🧠 **Overview**

* Servers must be patched regularly for **security updates and bug fixes**.
* Linux distributions use different package managers:

  * **Debian/Ubuntu → `apt`**
  * **RHEL/CentOS/Amazon Linux → `yum` or `dnf`**
* In DevOps environments this is often automated via **cron, Ansible, or CI/CD maintenance jobs**.

---

⚙️ **Purpose / How it works**

1. Detect which package manager exists on the system.
2. Run the correct update command.
3. Upgrade installed packages automatically.

---

🧩 **Bash Script (Simple and Production-Ready)**

```bash
#!/bin/bash

echo "Starting system update..."

# Debian / Ubuntu
if command -v apt >/dev/null 2>&1; then
    echo "Detected APT (Debian/Ubuntu)"
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt autoremove -y

# RHEL / CentOS / Amazon Linux (dnf)
elif command -v dnf >/dev/null 2>&1; then
    echo "Detected DNF (RHEL/CentOS 8+)"
    sudo dnf update -y

# Older RHEL / CentOS (yum)
elif command -v yum >/dev/null 2>&1; then
    echo "Detected YUM (RHEL/CentOS 7)"
    sudo yum update -y

else
    echo "No supported package manager found."
    exit 1
fi

echo "System update completed."
```

---

📋 **Package Manager Comparison**

| OS             | Package Manager | Update Command              |
| -------------- | --------------- | --------------------------- |
| Ubuntu         | apt             | `apt update && apt upgrade` |
| Debian         | apt             | `apt update && apt upgrade` |
| CentOS 7       | yum             | `yum update`                |
| RHEL 7         | yum             | `yum update`                |
| CentOS/RHEL 8+ | dnf             | `dnf update`                |
| Amazon Linux   | yum/dnf         | `yum update`                |

---

🧩 **Example: Automate Using Cron**

Run updates every day at **2 AM**.

```bash
crontab -e
```

```bash
0 2 * * * /usr/local/bin/update.sh
```

---

✅ **Best Practices**

* 🔒 Always run updates using **sudo/root**.
* ⚠️ Test updates in **staging before production rollout**.
* 📄 Maintain logs for troubleshooting.
* 🚀 For many servers use **Ansible or configuration management tools**.

---

💡 **In short**

* Different Linux systems use **apt, yum, or dnf**.
* A Bash script can **detect the package manager and run updates automatically**.
* This is commonly automated with **cron or configuration management in DevOps environments**.

---
## Q77: Write a bash script to check if specific packages are installed, and install them if missing

🧠 **Overview**

* In DevOps automation, servers must have **required dependencies installed** (e.g., `docker`, `git`, `curl`).
* A script can **check if packages exist and install them if missing**, ensuring consistent environments across servers.
* This approach is commonly used in **server bootstrap scripts, CI runners, and cloud-init provisioning**.

---

⚙️ **Purpose / How it works**

1. Define a list of required packages.
2. Detect the package manager (`apt`, `yum`, `dnf`).
3. Check if each package is installed.
4. Install missing packages automatically.

---

🧩 **Bash Script Example**

```bash
#!/bin/bash

# List of required packages
PACKAGES=("git" "curl" "wget")

echo "Checking required packages..."

# Detect package manager
if command -v apt >/dev/null 2>&1; then
    PM="apt"
elif command -v dnf >/dev/null 2>&1; then
    PM="dnf"
elif command -v yum >/dev/null 2>&1; then
    PM="yum"
else
    echo "Unsupported package manager"
    exit 1
fi

for pkg in "${PACKAGES[@]}"; do
    if command -v $pkg >/dev/null 2>&1; then
        echo "$pkg is already installed"
    else
        echo "$pkg is not installed. Installing..."

        if [ "$PM" == "apt" ]; then
            sudo apt update -y
            sudo apt install -y $pkg
        else
            sudo $PM install -y $pkg
        fi
    fi
done

echo "Package check completed."
```

---

🧩 **Example Output**

```
Checking required packages...
git is already installed
curl is not installed. Installing...
wget is already installed
Package check completed.
```

---

📋 **Package Check Commands**

| Package Manager     | Check Command                     |
| ------------------- | --------------------------------- |
| apt (Debian/Ubuntu) | `dpkg -l package_name`            |
| yum                 | `yum list installed package_name` |
| dnf                 | `dnf list installed package_name` |
| Generic             | `command -v package`              |

---

🧩 **DevOps Real-world Use Case**

Bootstrap script for a **new EC2 instance**:

```bash
#!/bin/bash

REQUIRED=("docker" "git" "awscli")

for pkg in "${REQUIRED[@]}"; do
    if ! command -v $pkg &> /dev/null; then
        echo "Installing $pkg..."
        sudo apt install -y $pkg
    fi
done
```

Used in:

* **Terraform user_data**
* **Cloud-init**
* **Jenkins agents**
* **Docker build environments**

---

✅ **Best Practices**

* 📦 Define required packages in an **array for easy maintenance**.
* ⚡ Avoid running `apt update` repeatedly inside loops.
* 🔒 Use **sudo carefully in automation scripts**.
* 📄 Add logging for production environments.

---

💡 **In short**

* DevOps scripts often verify **required packages before running automation**.
* The script checks if a package exists and **installs it only if missing**.
* Useful for **server bootstrapping, CI/CD agents, and infrastructure provisioning**.

---
## Q78: Write a bash script to list all installed packages and export to a file for documentation

🧠 **Overview**

* In infrastructure management, it's useful to **document all installed packages** on a server.
* This helps with **system audits, migration, backup, and disaster recovery**.
* DevOps teams often export package lists before **server upgrades, AMI creation, or rebuilding environments**.

---

⚙️ **Purpose / How it works**

1. Detect the Linux package manager (`apt`, `yum`, `dnf`).
2. List all installed packages.
3. Export the list to a **timestamped file** for documentation.

---

🧩 **Bash Script**

```bash
#!/bin/bash

OUTPUT_FILE="installed_packages_$(date +%F).txt"

echo "Collecting installed packages..."

if command -v apt >/dev/null 2>&1; then
    echo "Detected APT (Debian/Ubuntu)"
    dpkg --get-selections > $OUTPUT_FILE

elif command -v dnf >/dev/null 2>&1; then
    echo "Detected DNF (RHEL/CentOS 8+)"
    dnf list installed > $OUTPUT_FILE

elif command -v yum >/dev/null 2>&1; then
    echo "Detected YUM (RHEL/CentOS 7)"
    yum list installed > $OUTPUT_FILE

else
    echo "Unsupported package manager"
    exit 1
fi

echo "Package list exported to $OUTPUT_FILE"
```

---

🧩 **Example Output File**

```
installed_packages_2026-03-04.txt
```

Example content:

```
git.x86_64                2.39.1
curl.x86_64               7.79.1
docker-ce.x86_64          24.0.5
nginx.x86_64              1.24.0
```

---

📋 **Commands to List Installed Packages**

| OS                  | Command                 |
| ------------------- | ----------------------- |
| Ubuntu / Debian     | `dpkg --get-selections` |
| Ubuntu (clean list) | `apt list --installed`  |
| CentOS / RHEL       | `yum list installed`    |
| RHEL / CentOS 8+    | `dnf list installed`    |

---

🧩 **DevOps Real-world Example**

Before creating an **AWS AMI backup**, export packages:

```bash
dpkg --get-selections > server_packages_backup.txt
```

Later you can reinstall the same packages:

```bash
sudo dpkg --set-selections < server_packages_backup.txt
sudo apt-get dselect-upgrade
```

---

✅ **Best Practices**

* 📄 Store exported package lists in **Git or documentation repositories**.
* 🕒 Use **timestamped filenames** for tracking changes.
* 🔍 Combine with `crontab` for periodic audits.
* ☁️ Useful before **server rebuilds, migrations, or Terraform reprovisioning**.

---

💡 **In short**

* Package export scripts help **document system dependencies**.
* The script detects the package manager and **writes installed packages to a file**.
* Commonly used for **server backup, compliance audits, and infrastructure replication**.

---
## Q79: Write a bash script to clean up old kernels keeping only the latest 2 versions

🧠 **Overview**

* Linux servers accumulate **old kernel versions** after system updates.
* Keeping too many kernels wastes **disk space in `/boot`** and may cause upgrade failures.
* DevOps teams often automate **kernel cleanup while keeping the latest 1–2 versions** for rollback safety.

---

⚙️ **Purpose / How it works**

1. Identify installed kernel versions.
2. Detect the **currently running kernel** (`uname -r`).
3. Sort kernel packages by version.
4. Remove old kernels while **keeping the newest 2 versions**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

echo "Cleaning old kernels..."

# Detect OS
if command -v apt >/dev/null 2>&1; then
    echo "Detected Debian/Ubuntu system"

    CURRENT_KERNEL=$(uname -r)

    dpkg --list | grep linux-image | awk '{print $2}' | sort -V | head -n -2 | while read kernel
    do
        if [[ $kernel != *"$CURRENT_KERNEL"* ]]; then
            echo "Removing $kernel"
            sudo apt remove -y $kernel
        fi
    done

    sudo apt autoremove -y

elif command -v dnf >/dev/null 2>&1; then
    echo "Detected RHEL/CentOS system"
    sudo dnf remove $(dnf repoquery --installonly --latest-limit=-2 -q)

elif command -v yum >/dev/null 2>&1; then
    echo "Detected older RHEL/CentOS system"
    sudo package-cleanup --oldkernels --count=2 -y

else
    echo "Unsupported OS"
    exit 1
fi

echo "Old kernels cleaned successfully."
```

---

📋 **Kernel Cleanup Commands**

| OS               | Command                                  |                   |
| ---------------- | ---------------------------------------- | ----------------- |
| Ubuntu / Debian  | `apt autoremove`                         |                   |
| Ubuntu (manual)  | `dpkg --list                             | grep linux-image` |
| CentOS / RHEL 8+ | `dnf repoquery --installonly`            |                   |
| CentOS / RHEL 7  | `package-cleanup --oldkernels --count=2` |                   |

---

🧩 **Example Output**

```
Cleaning old kernels...
Detected Debian/Ubuntu system
Removing linux-image-5.15.0-70-generic
Removing linux-image-5.15.0-72-generic
Old kernels cleaned successfully.
```

---

🧩 **DevOps Real-world Use Case**

Automate kernel cleanup using **cron** to prevent `/boot` from filling:

```bash
crontab -e
```

```
0 3 * * 0 /usr/local/bin/cleanup_kernels.sh
```

Runs every **Sunday at 3 AM**.

---

✅ **Best Practices**

* ⚠️ **Never remove the currently running kernel**.
* 🔒 Keep at least **2 kernel versions for rollback**.
* 📦 Test scripts in **staging before production rollout**.
* 📄 Monitor `/boot` disk usage (`df -h /boot`).
* 🛠 For large fleets use **Ansible or configuration management tools**.

---

💡 **In short**

* Kernel updates leave **old kernels on the system**.
* A cleanup script removes older versions while **keeping the latest 2 kernels**.
* This prevents **/boot disk space issues and maintains rollback safety**.

---
## Q80: Write a bash script to automate security updates and send a report of what was updated

🧠 **Overview**

* Security updates patch **vulnerabilities (CVEs), bugs, and critical system issues**.
* In production environments, DevOps teams automate security patching and generate **update reports for auditing and compliance**.
* The script performs updates and **emails/logs a report of updated packages**.

---

⚙️ **Purpose / How it works**

1. Detect package manager (`apt`, `yum`, `dnf`).
2. Run security updates.
3. Capture the list of upgraded packages in a **log file**.
4. Send the update report using **email or logging system**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

LOG_FILE="/var/log/security_updates_$(date +%F).log"
EMAIL="admin@example.com"

echo "Starting security updates: $(date)" > $LOG_FILE

# Debian / Ubuntu
if command -v apt >/dev/null 2>&1; then
    echo "Detected APT system" >> $LOG_FILE
    sudo apt update >> $LOG_FILE
    sudo apt list --upgradable >> $LOG_FILE
    sudo apt upgrade -y >> $LOG_FILE

# RHEL / CentOS (dnf)
elif command -v dnf >/dev/null 2>&1; then
    echo "Detected DNF system" >> $LOG_FILE
    sudo dnf check-update >> $LOG_FILE
    sudo dnf update -y --security >> $LOG_FILE

# Older RHEL / CentOS (yum)
elif command -v yum >/dev/null 2>&1; then
    echo "Detected YUM system" >> $LOG_FILE
    sudo yum check-update >> $LOG_FILE
    sudo yum update -y --security >> $LOG_FILE

else
    echo "Unsupported package manager" >> $LOG_FILE
    exit 1
fi

echo "Security updates completed: $(date)" >> $LOG_FILE

# Send report via email
mail -s "Security Update Report - $(hostname)" $EMAIL < $LOG_FILE
```

---

🧩 **Example Report Output**

```
Security Update Report - server01

Starting security updates: 2026-03-04
Detected APT system

Upgradable packages:
openssl
curl
libssl3

Installing updates...

Security updates completed: 2026-03-04
```

---

📋 **Security Update Commands**

| OS                   | Command                     |
| -------------------- | --------------------------- |
| Ubuntu / Debian      | `apt update && apt upgrade` |
| Ubuntu security-only | `unattended-upgrades`       |
| RHEL / CentOS        | `yum update --security`     |
| RHEL / CentOS 8+     | `dnf update --security`     |

---

🧩 **Automation with Cron**

Run daily security updates at **1 AM**.

```bash
crontab -e
```

```
0 1 * * * /usr/local/bin/security_update.sh
```

---

🧩 **DevOps Real-world Usage**

This script is commonly used in:

* **EC2 instances patch automation**
* **Jenkins maintenance nodes**
* **Kubernetes worker nodes**
* **Compliance environments (SOC2 / ISO / PCI)**

---

✅ **Best Practices**

* 🔒 Apply **security updates regularly**.
* 📄 Store logs in `/var/log` for auditing.
* ⚠️ Test updates in **staging environments** before production rollout.
* 📦 Use **unattended-upgrades or configuration management tools** for large infrastructures.
* 📧 Integrate with **Slack, email, or monitoring tools** for alerts.

---

💡 **In short**

* Security patching is critical for **server protection and compliance**.
* The script runs updates, **logs the changes**, and sends a **report via email**.
* Typically automated using **cron or configuration management tools in DevOps environments**.

---
## Q81: Write a bash script to list all running Docker containers with their names, IDs, and status

🧠 **Overview**

* Docker containers run applications in isolated environments.
* DevOps engineers often need to **quickly view running containers with metadata** for monitoring and troubleshooting.
* This script uses `docker ps` to extract **Container ID, Name, and Status** and display or export them for operational visibility.

---

⚙️ **Purpose / How it works**

1. Verify Docker is installed and running.
2. Use `docker ps` with a custom format.
3. Display container **ID, name, and status** in a readable table.
4. Optionally export the output to a file for documentation or monitoring.

---

🧩 **Bash Script**

```bash
#!/bin/bash

echo "Listing running Docker containers..."
echo "------------------------------------"

docker ps --format "ID: {{.ID}} | Name: {{.Names}} | Status: {{.Status}}"
```

---

🧩 **Example Output**

```
Listing running Docker containers...
------------------------------------

ID: a1b2c3d4e5f6 | Name: nginx-container | Status: Up 3 hours
ID: b7c8d9e0f1g2 | Name: redis-cache     | Status: Up 15 minutes
ID: c3d4e5f6g7h8 | Name: backend-api    | Status: Up 2 days
```

---

🧩 **Export Output to File (Optional)**

```bash
#!/bin/bash

OUTPUT="docker_running_containers.txt"

docker ps --format "ID: {{.ID}} | Name: {{.Names}} | Status: {{.Status}}" > $OUTPUT

echo "Docker container list exported to $OUTPUT"
```

---

📋 **Useful Docker Commands**

| Command                      | Purpose                                 |
| ---------------------------- | --------------------------------------- |
| `docker ps`                  | List running containers                 |
| `docker ps -a`               | List all containers (including stopped) |
| `docker inspect <container>` | Detailed container information          |
| `docker stats`               | Live resource usage                     |

---

🧩 **DevOps Real-world Use Case**

This script is useful in:

* **CI/CD debugging** to verify containers started correctly
* **Kubernetes worker nodes using Docker runtime**
* **Monitoring scripts or cron jobs**
* **Server health-check automation**

Example health check:

```bash
docker ps --filter "name=nginx"
```

---

✅ **Best Practices**

* ⚠️ Ensure Docker daemon is running (`systemctl status docker`).
* 📄 Export results to logs for auditing.
* 🔍 Combine with `docker inspect` for deeper troubleshooting.
* 🚀 Integrate with monitoring tools (Prometheus, Datadog).

---

💡 **In short**

* `docker ps` lists running containers.
* Using `--format` allows extraction of **container ID, name, and status**.
* DevOps scripts use this for **monitoring, debugging, and automation**.

---
## Q82: Write a bash script to stop and remove all Docker containers

🧠 **Overview**

* Docker containers may accumulate during **CI/CD runs, testing, or development**, consuming system resources.
* DevOps engineers often need a script to **stop and remove all containers** for cleanup or environment reset.
* This is useful in **build servers, testing environments, and troubleshooting scenarios**.

---

⚙️ **Purpose / How it works**

1. Get all container IDs using `docker ps -aq`.
2. Stop all running containers.
3. Remove all containers from the system.
4. Handle cases where no containers exist.

---

🧩 **Bash Script**

```bash
#!/bin/bash

echo "Stopping all running Docker containers..."

CONTAINERS=$(docker ps -aq)

if [ -z "$CONTAINERS" ]; then
    echo "No containers found."
    exit 0
fi

# Stop containers
docker stop $CONTAINERS

# Remove containers
docker rm $CONTAINERS

echo "All Docker containers have been stopped and removed."
```

---

🧩 **One-liner Alternative**

Useful in quick cleanup operations.

```bash
docker stop $(docker ps -aq) && docker rm $(docker ps -aq)
```

---

🧩 **Example Output**

```
Stopping all running Docker containers...

a1b2c3d4e5f6
b7c8d9e0f1g2

a1b2c3d4e5f6
b7c8d9e0f1g2

All Docker containers have been stopped and removed.
```

---

📋 **Relevant Docker Commands**

| Command            | Purpose                 |
| ------------------ | ----------------------- |
| `docker ps`        | List running containers |
| `docker ps -a`     | List all containers     |
| `docker ps -aq`    | Get all container IDs   |
| `docker stop <id>` | Stop a container        |
| `docker rm <id>`   | Remove a container      |

---

🧩 **DevOps Real-world Use Case**

Cleanup script for **CI/CD pipelines (Jenkins/GitLab)** before starting a new build:

```bash
#!/bin/bash
docker stop $(docker ps -aq) 2>/dev/null
docker rm $(docker ps -aq) 2>/dev/null
```

Used to ensure:

* Clean build environment
* No port conflicts
* No leftover test containers

---

✅ **Best Practices**

* ⚠️ Avoid running this script on **production servers** without verification.
* 🔒 Check running containers before deletion using `docker ps`.
* 📦 Use labels (`--filter label`) to clean only **specific containers** in production.
* 📄 Log cleanup actions in automation scripts.

---

💡 **In short**

* `docker ps -aq` retrieves all container IDs.
* The script **stops all running containers and removes them**.
* Commonly used for **CI/CD environment cleanup and Docker host maintenance**.

---
## Q83: Write a bash script to remove all unused Docker images, containers, and volumes to free up disk space

🧠 **Overview**

* Docker environments accumulate **unused containers, dangling images, unused volumes, and networks** over time.
* These artifacts consume significant **disk space on build servers, CI runners, and Docker hosts**.
* DevOps teams automate cleanup using **Docker prune commands** to maintain system health and prevent disk exhaustion.

---

⚙️ **Purpose / How it works**

1. Stop and remove stopped containers.
2. Remove unused Docker images.
3. Delete unused volumes.
4. Remove unused networks.
5. Use Docker's built-in **prune commands** to clean unused resources safely.

---

🧩 **Bash Script**

```bash
#!/bin/bash

echo "Starting Docker cleanup..."

echo "Removing stopped containers..."
docker container prune -f

echo "Removing unused images..."
docker image prune -a -f

echo "Removing unused volumes..."
docker volume prune -f

echo "Removing unused networks..."
docker network prune -f

echo "Docker cleanup completed."
```

---

🧩 **Advanced Cleanup Script (Recommended)**

Uses a single command to remove **all unused Docker resources**.

```bash
#!/bin/bash

echo "Running full Docker system cleanup..."

docker system prune -a --volumes -f

echo "Docker cleanup completed successfully."
```

---

🧩 **Example Output**

```
Running full Docker system cleanup...

Deleted Containers:
c3d4e5f6g7h8

Deleted Images:
untagged: nginx:latest
deleted: sha256:abc123

Deleted Volumes:
volume_data_old

Total reclaimed space: 3.4GB
```

---

📋 **Docker Cleanup Commands**

| Command                  | Purpose                           |
| ------------------------ | --------------------------------- |
| `docker container prune` | Remove stopped containers         |
| `docker image prune`     | Remove unused images              |
| `docker volume prune`    | Remove unused volumes             |
| `docker network prune`   | Remove unused networks            |
| `docker system prune`    | Clean all unused Docker resources |

---

🧩 **DevOps Real-world Use Case**

Cleanup script used on **CI/CD servers (Jenkins, GitLab runners)**:

```bash
#!/bin/bash
docker system prune -a --volumes -f
```

Often scheduled to prevent **disk-full issues on build servers**.

Example cron job:

```
0 2 * * * /usr/local/bin/docker_cleanup.sh
```

Runs daily at **2 AM**.

---

✅ **Best Practices**

* ⚠️ Avoid removing volumes in production unless confirmed unused.
* 📄 Monitor disk usage using `docker system df`.
* 🔒 Use cleanup scripts carefully on **shared Docker hosts**.
* 🚀 Schedule regular cleanup on **CI/CD runners and build nodes**.

---

💡 **In short**

* Docker environments accumulate unused resources over time.
* `docker system prune -a --volumes` removes **unused containers, images, networks, and volumes**.
* DevOps teams schedule cleanup scripts to **prevent disk space issues on Docker hosts**.

---
## Q84: Write a bash script to backup all Docker volumes to a specified directory

🧠 **Overview**

* Docker volumes store **persistent data** for containers (databases, application files, logs).
* If a container or host fails, data inside volumes can be lost without backups.
* DevOps teams automate **volume backups to a directory or storage location (NFS, S3, backup server)** for disaster recovery.

---

⚙️ **Purpose / How it works**

1. Get a list of all Docker volumes.
2. Create a backup directory if it doesn't exist.
3. Use a temporary container to **mount and archive each volume**.
4. Save the volume data as a **`.tar.gz` backup file**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

BACKUP_DIR="/backup/docker_volumes"
DATE=$(date +%F)

mkdir -p $BACKUP_DIR

echo "Starting Docker volume backup..."

for VOLUME in $(docker volume ls -q)
do
    echo "Backing up volume: $VOLUME"

    docker run --rm \
        -v $VOLUME:/volume \
        -v $BACKUP_DIR:/backup \
        alpine \
        tar czf /backup/${VOLUME}_${DATE}.tar.gz -C /volume .

done

echo "Backup completed. Files stored in $BACKUP_DIR"
```

---

🧩 **Example Output**

```
Starting Docker volume backup...

Backing up volume: mysql_data
Backing up volume: redis_cache
Backing up volume: nginx_logs

Backup completed. Files stored in /backup/docker_volumes
```

Example backup files:

```
mysql_data_2026-03-04.tar.gz
redis_cache_2026-03-04.tar.gz
nginx_logs_2026-03-04.tar.gz
```

---

📋 **Important Docker Volume Commands**

| Command                 | Purpose                         |
| ----------------------- | ------------------------------- |
| `docker volume ls`      | List volumes                    |
| `docker volume inspect` | View volume details             |
| `docker run -v`         | Mount volumes inside containers |
| `tar czf`               | Compress backup files           |

---

🧩 **Restore Example**

To restore a volume backup:

```bash
docker run --rm \
-v mysql_data:/volume \
-v /backup/docker_volumes:/backup \
alpine \
tar xzf /backup/mysql_data_2026-03-04.tar.gz -C /volume
```

---

🧩 **DevOps Real-world Use Case**

Commonly used for backing up:

* **MySQL / PostgreSQL Docker volumes**
* **Jenkins home volume**
* **Prometheus / Grafana data**
* **Application storage volumes**

Example scheduled backup:

```bash
crontab -e
```

```
0 1 * * * /usr/local/bin/docker_volume_backup.sh
```

Runs daily at **1 AM**.

---

✅ **Best Practices**

* 🔒 Store backups in **remote storage (S3, NFS, backup servers)**.
* 📄 Use **timestamped backups** for versioning.
* ⚠️ Verify backups regularly with restore tests.
* 🚀 Automate using **cron or backup pipelines**.

---

💡 **In short**

* Docker volumes store **persistent container data**.
* The script loops through volumes and **archives them into `.tar.gz` backups**.
* This enables **quick recovery and disaster resilience in container environments**.

---
## Q85: Write a bash script to monitor Docker container health and restart unhealthy containers

🧠 **Overview**

* Docker supports **container health checks** to determine whether an application inside a container is functioning properly.
* Containers may become **unhealthy due to crashes, memory leaks, or service failures**.
* DevOps teams use monitoring scripts to **detect unhealthy containers and automatically restart them** to maintain application availability.

---

⚙️ **Purpose / How it works**

1. Get a list of running containers.
2. Inspect each container’s **health status**.
3. Identify containers with status **unhealthy**.
4. Restart those containers automatically.

Docker health status values:

| Status      | Meaning                       |
| ----------- | ----------------------------- |
| `healthy`   | Container is running normally |
| `unhealthy` | Health check failed           |
| `starting`  | Container is initializing     |

---

🧩 **Bash Script**

```bash
#!/bin/bash

echo "Checking Docker container health..."

for container in $(docker ps -q)
do
    STATUS=$(docker inspect --format='{{.State.Health.Status}}' $container 2>/dev/null)

    if [ "$STATUS" == "unhealthy" ]; then
        NAME=$(docker inspect --format='{{.Name}}' $container | sed 's/\///')
        echo "Container $NAME is unhealthy. Restarting..."

        docker restart $container
    fi
done

echo "Health check completed."
```

---

🧩 **Example Output**

```
Checking Docker container health...

Container nginx-app is unhealthy. Restarting...
Container redis-cache is unhealthy. Restarting...

Health check completed.
```

---

🧩 **Example Docker Health Check Configuration**

Health checks are defined inside **Dockerfile**.

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
CMD curl -f http://localhost:80 || exit 1
```

This checks the application every **30 seconds**.

---

📋 **Useful Docker Commands**

| Command                               | Purpose                   |
| ------------------------------------- | ------------------------- |
| `docker ps`                           | List running containers   |
| `docker inspect`                      | Get container metadata    |
| `docker restart`                      | Restart a container       |
| `docker ps --filter health=unhealthy` | Show unhealthy containers |

---

🧩 **Optimized DevOps Script**

Check unhealthy containers directly:

```bash
#!/bin/bash

for container in $(docker ps --filter "health=unhealthy" -q)
do
    echo "Restarting unhealthy container: $container"
    docker restart $container
done
```

---

🧩 **Automation Example**

Run the health monitor every **5 minutes**.

```
crontab -e
```

```
*/5 * * * * /usr/local/bin/docker_health_monitor.sh
```

---

✅ **Best Practices**

* ⚠️ Always define **Docker HEALTHCHECK** in Dockerfiles.
* 📄 Log restart events for monitoring.
* 🔍 Integrate with **Prometheus, Datadog, or CloudWatch**.
* 🚀 In production environments prefer **Kubernetes liveness/readiness probes**.

---

💡 **In short**

* Docker health checks detect application failures inside containers.
* The script identifies **unhealthy containers and restarts them automatically**.
* This improves **container reliability and self-healing in DevOps environments**.

---
## Q86: Write a bash script using AWS CLI to list all EC2 instances with their instance IDs, types, and states

🧠 **Overview**

* DevOps engineers frequently need to **audit EC2 infrastructure** to see which instances are running, stopped, or terminated.
* Using **AWS CLI with Bash scripting**, we can automatically extract instance details like **Instance ID, Instance Type, and State**.
* This is commonly used for **infrastructure monitoring, reporting, and automation scripts in CI/CD or operations tasks**.

---

⚙️ **Purpose / How it works**

1. Ensure **AWS CLI is configured** (`aws configure`).
2. Use `aws ec2 describe-instances`.
3. Extract specific fields using **JMESPath query**.
4. Format the output into a readable table.

---

🧩 **Bash Script**

```bash
#!/bin/bash

echo "Listing EC2 instances..."
echo "------------------------------------------"

aws ec2 describe-instances \
--query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name]' \
--output table
```

---

🧩 **Example Output**

```
------------------------------------------
|           DescribeInstances            |
+----------------------+---------------+-----------+
| InstanceId           | InstanceType  | State     |
+----------------------+---------------+-----------+
| i-0ab12345cd6789ef0  | t3.micro      | running   |
| i-0bc23456de7890fa1  | t3.small      | stopped   |
| i-0cd34567ef8901ab2  | t3.medium     | running   |
+----------------------+---------------+-----------+
```

---

🧩 **Export Output to File (for documentation)**

```bash
#!/bin/bash

OUTPUT="ec2_instances_$(date +%F).txt"

aws ec2 describe-instances \
--query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name]' \
--output table > $OUTPUT

echo "EC2 instance list saved to $OUTPUT"
```

---

📋 **Important AWS CLI Parameters**

| Parameter            | Purpose                         |
| -------------------- | ------------------------------- |
| `describe-instances` | Retrieves EC2 instance details  |
| `--query`            | Filters response using JMESPath |
| `--output table`     | Formats output as table         |
| `--output json`      | JSON format                     |
| `--output text`      | Plain text format               |

---

🧩 **DevOps Real-world Use Case**

Infrastructure audit script used in **operations automation**:

```bash
aws ec2 describe-instances \
--query 'Reservations[].Instances[].InstanceId'
```

Used for:

* **Cost analysis**
* **Environment inventory**
* **Compliance reporting**
* **Infrastructure documentation**

---

✅ **Best Practices**

* 🔒 Use **IAM roles instead of access keys** for automation.
* 📄 Export results to **logs or documentation repositories**.
* ⚡ Filter instances using tags for environment separation.

Example filter:

```bash
aws ec2 describe-instances \
--filters "Name=tag:Environment,Values=production"
```

---

💡 **In short**

* `aws ec2 describe-instances` retrieves EC2 metadata.
* A Bash script can extract **Instance ID, type, and state** using `--query`.
* This is commonly used for **infrastructure audits and DevOps automation tasks**.

---
## Q87: Write a bash script to start all stopped EC2 instances tagged with "Environment=Dev"

🧠 **Overview**

* AWS tags help organize resources by **environment, team, or application**.
* DevOps teams often stop **Dev/Test EC2 instances** to reduce costs and start them when needed.
* Using **AWS CLI with Bash**, we can automatically find all instances tagged `Environment=Dev` that are **stopped** and start them.

---

⚙️ **Purpose / How it works**

1. Use `aws ec2 describe-instances` with filters:

   * `tag:Environment=Dev`
   * `instance-state-name=stopped`
2. Extract **instance IDs** using `--query`.
3. Start the instances using `aws ec2 start-instances`.

---

🧩 **Bash Script**

```bash
#!/bin/bash

echo "Finding stopped EC2 instances with tag Environment=Dev..."

INSTANCES=$(aws ec2 describe-instances \
--filters "Name=tag:Environment,Values=Dev" \
         "Name=instance-state-name,Values=stopped" \
--query "Reservations[].Instances[].InstanceId" \
--output text)

if [ -z "$INSTANCES" ]; then
    echo "No stopped Dev instances found."
else
    echo "Starting instances: $INSTANCES"
    aws ec2 start-instances --instance-ids $INSTANCES
fi

echo "Operation completed."
```

---

🧩 **Example Output**

```
Finding stopped EC2 instances with tag Environment=Dev...

Starting instances: i-0ab12345cd6789ef0 i-0bc23456de7890fa1

{
    "StartingInstances": [
        {
            "InstanceId": "i-0ab12345cd6789ef0",
            "CurrentState": { "Name": "pending" },
            "PreviousState": { "Name": "stopped" }
        }
    ]
}
```

---

📋 **AWS CLI Filters Used**

| Filter                        | Purpose                     |
| ----------------------------- | --------------------------- |
| `tag:Environment=Dev`         | Select instances tagged Dev |
| `instance-state-name=stopped` | Only stopped instances      |
| `--query`                     | Extract instance IDs        |
| `--output text`               | Clean CLI output            |

---

🧩 **DevOps Real-world Use Case**

This script is often used to **start development environments automatically in the morning**.

Example **cron job (9 AM weekdays)**:

```bash
crontab -e
```

```
0 9 * * 1-5 /scripts/start-dev-instances.sh
```

Used for:

* Developer environments
* Testing clusters
* Cost optimization

---

🧩 **Related Stop Script (Night Shutdown)**

```bash
aws ec2 stop-instances --instance-ids $INSTANCES
```

Used to stop instances **after working hours**.

---

✅ **Best Practices**

* 🔒 Use **IAM roles instead of static AWS credentials**.
* 🏷 Always tag resources consistently (`Environment`, `Owner`, `Project`).
* ⚠️ Ensure script only targets **Dev instances** to avoid production impact.
* 📄 Log instance start operations for auditing.

---

💡 **In short**

* AWS tags allow filtering EC2 instances by environment.
* The script finds **stopped instances tagged `Environment=Dev`**.
* It automatically starts them using **AWS CLI**, commonly used for **cost-saving Dev environments**.

---
## Q88: Write a bash script to create an AMI backup of all running EC2 instances

🧠 **Overview**

* An **AMI (Amazon Machine Image)** is a snapshot of an EC2 instance including its **OS, configuration, and attached volumes**.
* DevOps teams create AMI backups to enable **disaster recovery, quick instance restoration, and golden image creation**.
* Using **AWS CLI with Bash**, we can automatically create AMIs for **all running EC2 instances**.

---

⚙️ **Purpose / How it works**

1. Retrieve all **running EC2 instance IDs**.
2. Loop through each instance.
3. Create an **AMI backup** using `aws ec2 create-image`.
4. Use a **timestamp-based name** for versioning.

---

🧩 **Bash Script**

```bash
#!/bin/bash

DATE=$(date +%F)

echo "Fetching running EC2 instances..."

INSTANCES=$(aws ec2 describe-instances \
--filters "Name=instance-state-name,Values=running" \
--query "Reservations[].Instances[].InstanceId" \
--output text)

for INSTANCE in $INSTANCES
do
    AMI_NAME="backup-${INSTANCE}-${DATE}"

    echo "Creating AMI for instance: $INSTANCE"

    aws ec2 create-image \
    --instance-id $INSTANCE \
    --name "$AMI_NAME" \
    --no-reboot

    echo "AMI creation started for $INSTANCE"
done

echo "AMI backup process completed."
```

---

🧩 **Example Output**

```
Fetching running EC2 instances...

Creating AMI for instance: i-0ab12345cd6789ef0
AMI creation started for i-0ab12345cd6789ef0

Creating AMI for instance: i-0bc23456de7890fa1
AMI creation started for i-0bc23456de7890fa1

AMI backup process completed.
```

---

📋 **Important AWS CLI Parameters**

| Parameter       | Purpose                             |
| --------------- | ----------------------------------- |
| `create-image`  | Creates an AMI from an instance     |
| `--instance-id` | EC2 instance to back up             |
| `--name`        | Name of the AMI                     |
| `--no-reboot`   | Avoid instance reboot during backup |

---

🧩 **Check Created AMIs**

```bash
aws ec2 describe-images --owners self
```

---

🧩 **DevOps Real-world Use Case**

Commonly used for:

* **Disaster recovery**
* **Golden AMI creation**
* **Pre-deployment backups**
* **Infrastructure rollback**

Example **cron automation (daily backup)**:

```bash
crontab -e
```

```
0 1 * * * /scripts/ec2_ami_backup.sh
```

Runs every day at **1 AM**.

---

🧩 **Optional: Add Instance Name Tag in AMI**

```bash
INSTANCE_NAME=$(aws ec2 describe-instances \
--instance-ids $INSTANCE \
--query "Reservations[0].Instances[0].Tags[?Key=='Name'].Value" \
--output text)
```

AMI name example:

```
web-server-backup-2026-03-04
```

---

✅ **Best Practices**

* 🔒 Use **IAM roles** instead of access keys.
* 📦 Implement **AMI lifecycle cleanup** to remove old images.
* ⚠️ Avoid excessive AMI creation (storage costs).
* 📄 Tag AMIs with **environment and date**.

---

💡 **In short**

* AMIs are used to **backup EC2 instances**.
* The script finds all **running instances and creates AMI snapshots** automatically.
* Often scheduled via **cron or automation pipelines for disaster recovery**.

---
## Q89: Write a bash script to list all S3 buckets and their sizes

🧠 **Overview**

* Amazon S3 stores objects in **buckets**, and monitoring bucket size is important for **cost management, storage planning, and audits**.
* DevOps engineers often need scripts to **inventory all buckets and measure their storage usage**.
* Using **AWS CLI with Bash**, we can list all buckets and calculate their **total size using `aws s3 ls --recursive --summarize`**.

---

⚙️ **Purpose / How it works**

1. Retrieve all S3 buckets using `aws s3 ls`.
2. Loop through each bucket.
3. Use `aws s3 ls --recursive --summarize` to calculate total object size.
4. Extract the **Total Size** field from the output.

---

🧩 **Bash Script**

```bash
#!/bin/bash

echo "Listing all S3 buckets and their sizes..."
echo "------------------------------------------"

for BUCKET in $(aws s3 ls | awk '{print $3}')
do
    SIZE=$(aws s3 ls s3://$BUCKET --recursive --summarize 2>/dev/null | \
           grep "Total Size" | awk '{print $3}')

    echo "Bucket: $BUCKET | Size: $SIZE bytes"
done
```

---

🧩 **Example Output**

```
Listing all S3 buckets and their sizes...

Bucket: dev-app-logs      | Size: 34567890 bytes
Bucket: prod-backups      | Size: 987654321 bytes
Bucket: terraform-state   | Size: 10245 bytes
```

---

📋 **Important AWS CLI Commands**

| Command                 | Purpose                          |
| ----------------------- | -------------------------------- |
| `aws s3 ls`             | List all S3 buckets              |
| `aws s3 ls s3://bucket` | List objects inside bucket       |
| `aws s3 ls --recursive` | List all objects recursively     |
| `--summarize`           | Show total size and object count |

---

🧩 **Export Results to File**

Useful for documentation or audits.

```bash
#!/bin/bash

OUTPUT="s3_bucket_sizes_$(date +%F).txt"

for BUCKET in $(aws s3 ls | awk '{print $3}')
do
    SIZE=$(aws s3 ls s3://$BUCKET --recursive --summarize 2>/dev/null | \
           grep "Total Size" | awk '{print $3}')

    echo "$BUCKET | $SIZE bytes" >> $OUTPUT
done

echo "Report saved to $OUTPUT"
```

---

🧩 **DevOps Real-world Use Case**

This script helps with:

* **Cloud cost analysis**
* **Storage monitoring**
* **Audit reports**
* **Terraform state bucket tracking**
* **Backup storage validation**

Example:

```
terraform-state-prod
logs-backup-bucket
jenkins-artifacts
```

---

✅ **Best Practices**

* 🔒 Ensure AWS CLI is configured using **IAM roles or secure credentials**.
* ⚠️ Large buckets may take time with `--recursive`.
* 📄 Store reports for **monthly cost analysis**.
* 🚀 Use **CloudWatch or S3 Storage Lens** for large-scale monitoring.

---

💡 **In short**

* `aws s3 ls` lists all buckets.
* The script loops through buckets and calculates **total storage size**.
* Useful for **cost monitoring, audits, and storage reporting in DevOps environments**.

----
## Q90: Write a bash script to download all files from an S3 bucket with a specific prefix

🧠 **Overview**

* In AWS S3, a **prefix acts like a folder path** used to organize objects (e.g., `logs/`, `backups/2026/`).
* DevOps teams often download objects with a specific prefix for **log analysis, backup restoration, or data processing**.
* Using **AWS CLI with Bash**, we can automate downloading all objects under a given prefix.

---

⚙️ **Purpose / How it works**

1. Define the **S3 bucket name**.
2. Specify the **prefix (folder path)**.
3. Use `aws s3 sync` or `aws s3 cp --recursive` to download objects.
4. Save files to a local directory.

---

🧩 **Bash Script**

```bash
#!/bin/bash

BUCKET_NAME="my-s3-bucket"
PREFIX="logs/"
DESTINATION="./downloads"

echo "Downloading files from S3 bucket..."

mkdir -p $DESTINATION

aws s3 cp s3://$BUCKET_NAME/$PREFIX $DESTINATION \
--recursive

echo "Download completed."
```

---

🧩 **Example Output**

```
Downloading files from S3 bucket...

download: s3://my-s3-bucket/logs/app1.log to downloads/app1.log
download: s3://my-s3-bucket/logs/app2.log to downloads/app2.log
download: s3://my-s3-bucket/logs/error.log to downloads/error.log

Download completed.
```

---

📋 **AWS CLI Commands**

| Command                        | Purpose                                |
| ------------------------------ | -------------------------------------- |
| `aws s3 cp`                    | Copy files between S3 and local system |
| `--recursive`                  | Copy all objects in a prefix           |
| `aws s3 sync`                  | Sync S3 bucket with local directory    |
| `aws s3 ls s3://bucket/prefix` | List objects with prefix               |

---

🧩 **Alternative (Recommended for Large Data)**

`sync` avoids downloading files that already exist.

```bash
aws s3 sync s3://my-s3-bucket/logs ./downloads
```

---

🧩 **DevOps Real-world Use Case**

Common scenarios:

* Download **application logs from S3**
* Retrieve **backup archives**
* Fetch **CI/CD build artifacts**
* Export **CloudTrail or ALB logs**

Example:

```
s3://company-logs/cloudtrail/2026/03/
s3://backup-bucket/mysql-backups/
```

---

✅ **Best Practices**

* 🔒 Use **IAM roles** instead of static AWS credentials.
* ⚡ Use `aws s3 sync` for **large datasets** to reduce unnecessary downloads.
* 📄 Store downloads in structured directories for easier management.
* 🚀 Compress large downloads for archival storage.

---

💡 **In short**

* S3 prefixes help organize objects like folders.
* The script downloads all files under a **specific prefix using AWS CLI**.
* Commonly used for **log retrieval, backup recovery, and data processing workflows**.

----
## Q91: Write a bash script to clone multiple Git repositories from a list of URLs

🧠 **Overview**

* DevOps engineers often manage **multiple repositories** (microservices, infrastructure code, CI/CD configs).
* Instead of cloning each repository manually, a Bash script can **read repository URLs from a list and clone them automatically**.
* This is useful for **developer onboarding, CI/CD bootstrap environments, and infrastructure setup**.

---

⚙️ **Purpose / How it works**

1. Store repository URLs in a **text file or array**.
2. Read each URL one by one.
3. Use `git clone` to download the repository.
4. Optionally store all repos inside a **specific directory**.

---

🧩 **Example Repository List File**

`repos.txt`

```
https://github.com/company/service-api.git
https://github.com/company/frontend-app.git
https://github.com/company/terraform-infra.git
```

---

🧩 **Bash Script**

```bash
#!/bin/bash

REPO_LIST="repos.txt"
CLONE_DIR="git_repositories"

mkdir -p $CLONE_DIR
cd $CLONE_DIR

echo "Starting repository cloning..."

while read repo
do
    echo "Cloning $repo"
    git clone $repo
done < ../$REPO_LIST

echo "All repositories cloned successfully."
```

---

🧩 **Example Output**

```
Starting repository cloning...

Cloning https://github.com/company/service-api.git
Cloning into 'service-api'...

Cloning https://github.com/company/frontend-app.git
Cloning into 'frontend-app'...

Cloning https://github.com/company/terraform-infra.git
Cloning into 'terraform-infra'...

All repositories cloned successfully.
```

---

📋 **Important Git Commands**

| Command            | Purpose           |
| ------------------ | ----------------- |
| `git clone <repo>` | Clone repository  |
| `git pull`         | Update repository |
| `git branch`       | List branches     |
| `git remote -v`    | Show remote URLs  |

---

🧩 **Alternative: Using an Array in Script**

```bash
#!/bin/bash

REPOS=(
"https://github.com/company/service-api.git"
"https://github.com/company/frontend-app.git"
"https://github.com/company/terraform-infra.git"
)

for repo in "${REPOS[@]}"
do
    git clone $repo
done
```

---

🧩 **DevOps Real-world Use Case**

This script is commonly used for:

* **Microservices environments** with many repositories
* **Terraform + application code bootstrap**
* **Developer onboarding scripts**
* **CI/CD automation setup**

Example project structure:

```
projects/
 ├── service-api
 ├── frontend-app
 ├── terraform-infra
```

---

✅ **Best Practices**

* 🔒 Use **SSH keys instead of HTTPS for private repos**.
* 📄 Store repository URLs in **version-controlled config files**.
* ⚡ Use **parallel cloning** for large repository lists.
* 🚀 Integrate cloning scripts into **bootstrap or setup scripts**.

Example SSH format:

```
git@github.com:company/service-api.git
```

---

💡 **In short**

* The script reads a list of **Git repository URLs**.
* It loops through them and runs **`git clone` automatically**.
* Useful for **DevOps automation, microservice setups, and onboarding environments**.

----
## Q92: Write a bash script to pull the latest changes from all Git repositories in a parent directory

🧠 **Overview**

* DevOps engineers often maintain **multiple Git repositories** in a single workspace (microservices, infrastructure code, Helm charts, etc.).
* Updating each repository manually using `git pull` is inefficient.
* A Bash script can **scan a parent directory, detect Git repositories, and pull the latest changes automatically**.

---

⚙️ **Purpose / How it works**

1. Loop through all directories in the parent folder.
2. Check if the directory contains a **`.git` folder**.
3. Navigate into that repository.
4. Execute `git pull` to fetch the latest changes.

---

🧩 **Bash Script**

```bash
#!/bin/bash

PARENT_DIR="/home/user/projects"

echo "Updating all Git repositories in $PARENT_DIR"
echo "--------------------------------------------"

for dir in $PARENT_DIR/*; do
    if [ -d "$dir/.git" ]; then
        echo "Updating repository: $dir"
        cd $dir
        git pull
        echo "--------------------------------"
    fi
done

echo "All repositories updated."
```

---

🧩 **Example Directory Structure**

```
projects/
 ├── service-api
 │    └── .git
 ├── frontend-app
 │    └── .git
 ├── terraform-infra
 │    └── .git
 └── scripts
```

---

🧩 **Example Output**

```
Updating all Git repositories in /home/user/projects

Updating repository: service-api
Already up to date.

Updating repository: frontend-app
Updating 8c1a23f..9d2bc91

Updating repository: terraform-infra
Already up to date.

All repositories updated.
```

---

📋 **Key Git Commands**

| Command      | Purpose                        |
| ------------ | ------------------------------ |
| `git pull`   | Fetch and merge latest changes |
| `git fetch`  | Download remote changes        |
| `git status` | Show repository status         |
| `git branch` | Show current branch            |

---

🧩 **Improved Script (Production Friendly)**

Handles errors and logs output.

```bash
#!/bin/bash

BASE_DIR=$(pwd)

for dir in */; do
    if [ -d "$dir/.git" ]; then
        echo "Pulling updates for $dir"
        cd "$dir"
        git pull origin $(git branch --show-current)
        cd "$BASE_DIR"
    fi
done
```

---

🧩 **DevOps Real-world Use Case**

Commonly used for:

* **Microservice repositories**
* **Infrastructure-as-Code repos**
* **Helm charts**
* **Automation scripts**

Example workspace:

```
devops-workspace/
 ├── terraform-modules
 ├── kubernetes-manifests
 ├── helm-charts
 └── ci-cd-pipelines
```

---

✅ **Best Practices**

* ⚠️ Ensure repositories have **clean working trees** before pulling.
* 🔒 Use **SSH authentication for private repositories**.
* 📄 Log pull results in automation scripts.
* 🚀 Combine with **cron jobs or developer setup scripts**.

---

💡 **In short**

* The script scans directories for **Git repositories (`.git`)**.
* It runs **`git pull` for each repository automatically**.
* Useful for **updating multiple microservice or infrastructure repositories at once**.

---
## Q93: Write a bash script to check the Git status of multiple repositories and report which have uncommitted changes

🧠 **Overview**

* In environments with **multiple Git repositories (microservices, IaC, CI/CD configs)**, developers may accidentally leave **uncommitted changes**.
* DevOps teams often run scripts to **audit repositories and detect uncommitted modifications** before running builds or deployments.
* This script scans directories, checks `git status`, and reports repositories with **pending changes**.

---

⚙️ **Purpose / How it works**

1. Loop through all directories inside a parent folder.
2. Check if the directory contains a **Git repository (`.git`)**.
3. Run `git status --porcelain` (machine-readable format).
4. If output exists → the repository has **uncommitted changes**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

PARENT_DIR="/home/user/projects"

echo "Checking Git repositories for uncommitted changes..."
echo "-----------------------------------------------------"

for dir in $PARENT_DIR/*; do
    if [ -d "$dir/.git" ]; then
        cd $dir

        STATUS=$(git status --porcelain)

        if [ -n "$STATUS" ]; then
            echo "Repository with uncommitted changes: $dir"
        else
            echo "Clean repository: $dir"
        fi
    fi
done

echo "Git status check completed."
```

---

🧩 **Example Directory Structure**

```
projects/
 ├── service-api
 │    └── .git
 ├── frontend-app
 │    └── .git
 ├── terraform-infra
 │    └── .git
```

---

🧩 **Example Output**

```
Checking Git repositories for uncommitted changes...

Clean repository: /home/user/projects/service-api
Repository with uncommitted changes: /home/user/projects/frontend-app
Clean repository: /home/user/projects/terraform-infra

Git status check completed.
```

---

📋 **Important Git Commands**

| Command                  | Purpose                   |
| ------------------------ | ------------------------- |
| `git status`             | Shows working tree status |
| `git status --porcelain` | Script-friendly output    |
| `git diff`               | Shows code differences    |
| `git add`                | Stage changes             |
| `git commit`             | Save changes              |

---

🧩 **Optimized Script (Cleaner Output)**

```bash
#!/bin/bash

for dir in */; do
    if [ -d "$dir/.git" ]; then
        cd "$dir"

        if [ -n "$(git status --porcelain)" ]; then
            echo "⚠️ Uncommitted changes in: $dir"
        fi

        cd ..
    fi
done
```

---

🧩 **DevOps Real-world Use Case**

Useful for:

* **Developer workstation audits**
* **CI/CD pre-build checks**
* **Infrastructure repository monitoring**
* **Automation scripts before deployments**

Example scenario:

```
devops-workspace/
 ├── terraform-modules
 ├── helm-charts
 ├── kubernetes-manifests
```

Before running **Terraform apply or Helm deployments**, teams ensure repos are **clean**.

---

✅ **Best Practices**

* ⚠️ Always check repository state before **CI/CD builds**.
* 📄 Use `git status --porcelain` for scripting.
* 🔒 Avoid deployments with **uncommitted infrastructure changes**.
* 🚀 Integrate checks into **pre-deployment automation scripts**.

---

💡 **In short**

* The script scans multiple Git repositories.
* It detects **uncommitted changes using `git status --porcelain`**.
* Useful for **DevOps audits, CI/CD validation, and workspace hygiene**.

----
## Q94: Write a bash script to create a Git branch, commit changes, and push to remote repository

🧠 **Overview**

* In DevOps and CI/CD workflows, code changes are typically pushed through **feature branches** rather than directly to the main branch.
* Automating the process of **creating a branch → committing changes → pushing to remote** helps standardize development workflows and reduces manual errors.
* This script creates a new branch, commits changes, and pushes it to the remote repository.

---

⚙️ **Purpose / How it works**

1. Define the **branch name and commit message**.
2. Create and switch to a new branch using `git checkout -b`.
3. Stage changes using `git add`.
4. Commit changes using `git commit`.
5. Push the branch to the remote repository.

---

🧩 **Bash Script**

```bash
#!/bin/bash

BRANCH_NAME="feature-update"
COMMIT_MESSAGE="Automated commit from script"

echo "Creating new branch: $BRANCH_NAME"

# Create and switch to new branch
git checkout -b $BRANCH_NAME

# Add changes
git add .

# Commit changes
git commit -m "$COMMIT_MESSAGE"

# Push branch to remote
git push origin $BRANCH_NAME

echo "Branch created and pushed successfully."
```

---

🧩 **Example Output**

```
Creating new branch: feature-update

Switched to a new branch 'feature-update'
[feature-update a1b2c3d] Automated commit from script
 3 files changed, 20 insertions(+)

Enumerating objects: 6
Counting objects: 100%
Writing objects: 100%
To github.com:company/project.git
 * [new branch] feature-update -> feature-update
```

---

📋 **Git Commands Used**

| Command                    | Purpose                           |
| -------------------------- | --------------------------------- |
| `git checkout -b <branch>` | Create and switch to a new branch |
| `git add .`                | Stage all changes                 |
| `git commit -m "msg"`      | Commit changes                    |
| `git push origin <branch>` | Push branch to remote             |

---

🧩 **Improved Script (Dynamic Input)**

Allows passing **branch name and commit message as arguments**.

```bash
#!/bin/bash

BRANCH_NAME=$1
COMMIT_MESSAGE=$2

if [ -z "$BRANCH_NAME" ]; then
    echo "Usage: ./git_push.sh <branch-name> <commit-message>"
    exit 1
fi

git checkout -b $BRANCH_NAME
git add .
git commit -m "$COMMIT_MESSAGE"
git push -u origin $BRANCH_NAME
```

Run:

```bash
./git_push.sh feature-login "Add login API changes"
```

---

🧩 **DevOps Real-world Use Case**

Commonly used in:

* **Developer automation scripts**
* **CI/CD pipelines**
* **Infrastructure repository updates**
* **Automated configuration updates**

Example workflow:

```
Developer → Feature Branch → Push → Pull Request → CI/CD Pipeline → Merge
```

---

✅ **Best Practices**

* ⚠️ Always create **feature branches instead of committing directly to `main`**.
* 🔒 Use **SSH authentication for Git operations**.
* 📄 Follow consistent **commit message conventions**.
* 🚀 Integrate branch creation into **CI/CD pipelines or automation scripts**.

---

💡 **In short**

* The script automates **branch creation, committing changes, and pushing to remote**.
* It standardizes Git workflows used in **DevOps and CI/CD environments**.
* Helps reduce manual Git operations during development and automation.

----
## Q95: Write a bash script to delete all local Git branches except master/main

🧠 **Overview**

* Over time, Git repositories accumulate many **local feature branches** after merges.
* Keeping unnecessary branches can clutter the repository and confuse developers.
* DevOps teams often run cleanup scripts to **remove all local branches except the main branches (`main` or `master`)**.

---

⚙️ **Purpose / How it works**

1. Switch to a safe base branch (`main` or `master`).
2. List all local branches using `git branch`.
3. Filter out `main` and `master`.
4. Delete the remaining branches using `git branch -d`.

---

🧩 **Bash Script**

```bash
#!/bin/bash

echo "Cleaning local Git branches..."

# Switch to main or master branch
git checkout main 2>/dev/null || git checkout master

# List and delete branches except main/master
git branch | grep -v "main" | grep -v "master" | while read branch
do
    echo "Deleting branch: $branch"
    git branch -d $branch
done

echo "Branch cleanup completed."
```

---

🧩 **Example Output**

```
Cleaning local Git branches...

Deleting branch: feature-login
Deleted branch feature-login (was a1b2c3d).

Deleting branch: bugfix-api
Deleted branch bugfix-api (was d4e5f6g).

Branch cleanup completed.
```

---

📋 **Important Git Commands**

| Command                  | Purpose              |
| ------------------------ | -------------------- |
| `git branch`             | List local branches  |
| `git branch -d <branch>` | Delete merged branch |
| `git branch -D <branch>` | Force delete branch  |
| `git checkout <branch>`  | Switch branch        |

---

🧩 **Alternative One-Liner**

Quick cleanup command:

```bash
git branch | grep -v "main" | grep -v "master" | xargs git branch -d
```

---

🧩 **DevOps Real-world Use Case**

Used for:

* **Developer workspace cleanup**
* **CI/CD repository maintenance**
* **Microservice repo management**

Example repository state before cleanup:

```
main
feature-auth
feature-payment
bugfix-api
dev-test
```

After running the script:

```
main
```

---

✅ **Best Practices**

* ⚠️ Use `git branch -d` to avoid deleting **unmerged branches**.
* 🔒 Only use `-D` when you're sure the branch is no longer needed.
* 📄 Ensure the working branch is **main/master before cleanup**.
* 🚀 Combine with `git fetch --prune` to remove deleted remote branches.

---

💡 **In short**

* Local Git repos accumulate unused feature branches.
* This script deletes **all local branches except `main` and `master`**.
* Helps maintain a **clean and manageable development environment**.

---
## Q96: Write a bash script to find all files with permissions 777 and report their locations

🧠 **Overview**

* File permission `777` means **read, write, and execute permissions for owner, group, and others**.
* This is considered **highly insecure** in production systems because any user can modify or execute the file.
* DevOps and security teams often run **audit scripts** to detect such files and report them for remediation.

---

⚙️ **Purpose / How it works**

1. Use the Linux `find` command to search for files with **permission `777`**.
2. Scan directories recursively.
3. Print the **full path of insecure files**.
4. Optionally store the results in a **report file for auditing**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

SEARCH_DIR="/"
REPORT_FILE="files_with_777_permissions.txt"

echo "Scanning for files with 777 permissions..."
echo "Scan started at: $(date)"

find $SEARCH_DIR -type f -perm 0777 2>/dev/null | tee $REPORT_FILE

echo "Scan completed."
echo "Report saved to $REPORT_FILE"
```

---

🧩 **Example Output**

```
Scanning for files with 777 permissions...

/var/www/html/test.sh
/home/user/tmp/debug_script.sh
/opt/scripts/install.sh

Scan completed.
Report saved to files_with_777_permissions.txt
```

---

📋 **Important `find` Parameters**

| Option        | Purpose                              |
| ------------- | ------------------------------------ |
| `-type f`     | Search only files                    |
| `-perm 0777`  | Match permission 777                 |
| `2>/dev/null` | Hide permission denied errors        |
| `tee`         | Print and save output simultaneously |

---

🧩 **Improved Security Audit Script**

Shows file permissions and owner.

```bash
#!/bin/bash

echo "Files with 777 permissions:"
find / -type f -perm 0777 -exec ls -l {} \; 2>/dev/null
```

Example output:

```
-rwxrwxrwx 1 root root 2456 Mar 4 /opt/scripts/test.sh
-rwxrwxrwx 1 user user 1345 Mar 4 /home/user/debug.sh
```

---

🧩 **DevOps Real-world Use Case**

Security checks often run in:

* **Server hardening scripts**
* **CI/CD security audits**
* **Docker image scans**
* **Compliance checks (CIS benchmarks)**

Example:

```
DevOps Security Scan
 ├── Check 777 permissions
 ├── Check SUID files
 ├── Check world-writable directories
```

---

✅ **Best Practices**

* 🔒 Avoid using `777` permissions in production.
* ⚠️ Use least privilege (`644`, `755`) instead.
* 📄 Run periodic **security audits on servers**.
* 🚀 Integrate checks into **security pipelines or monitoring scripts**.

Example fix:

```bash
chmod 755 file.sh
```

---

💡 **In short**

* Permission `777` allows **any user full access to a file**, which is insecure.
* The script uses `find` to **locate all files with 777 permissions**.
* This helps DevOps teams **identify security risks and enforce proper permissions**.

---
## Q97: Write a bash script to scan for SUID/SGID files on the system and generate a security report

🧠 **Overview**

* **SUID (Set User ID)** and **SGID (Set Group ID)** files run with elevated privileges (owner or group).
* While some system binaries require these permissions (e.g., `passwd`, `sudo`), they can also be **exploited for privilege escalation**.
* DevOps and security teams periodically scan systems to **detect SUID/SGID files and generate security audit reports**.

---

⚙️ **Purpose / How it works**

1. Search the filesystem using `find`.
2. Identify files with:

   * **SUID permission (`-4000`)**
   * **SGID permission (`-2000`)**
3. Log results into a **security report file**.
4. Include **file path, owner, permissions, and timestamp**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

REPORT_FILE="suid_sgid_security_report_$(date +%F).txt"

echo "SUID/SGID Security Scan Report" > $REPORT_FILE
echo "Generated on: $(date)" >> $REPORT_FILE
echo "----------------------------------------" >> $REPORT_FILE

echo "Scanning for SUID files..." >> $REPORT_FILE
find / -type f -perm -4000 -exec ls -l {} \; 2>/dev/null >> $REPORT_FILE

echo "" >> $REPORT_FILE
echo "Scanning for SGID files..." >> $REPORT_FILE
find / -type f -perm -2000 -exec ls -l {} \; 2>/dev/null >> $REPORT_FILE

echo "" >> $REPORT_FILE
echo "Scan completed successfully." >> $REPORT_FILE

echo "Security report generated: $REPORT_FILE"
```

---

🧩 **Example Output**

Example entries in the report:

```
SUID/SGID Security Scan Report
Generated on: Tue Mar 4 2026

Scanning for SUID files...

-rwsr-xr-x 1 root root 54256 /usr/bin/passwd
-rwsr-xr-x 1 root root 40152 /usr/bin/sudo

Scanning for SGID files...

-rwxr-sr-x 1 root shadow 43120 /usr/bin/chage
```

---

📋 **Permission Reference**

| Permission    | Meaning                  |
| ------------- | ------------------------ |
| `4000`        | SUID (run as file owner) |
| `2000`        | SGID (run as file group) |
| `-perm -4000` | Find SUID files          |
| `-perm -2000` | Find SGID files          |

---

🧩 **Manual Commands for Security Checks**

Find SUID files:

```bash
find / -type f -perm -4000 2>/dev/null
```

Find SGID files:

```bash
find / -type f -perm -2000 2>/dev/null
```

---

🧩 **DevOps Real-world Use Case**

Security scanning is commonly performed during:

* **Server hardening**
* **CIS benchmark compliance checks**
* **Container security audits**
* **Infrastructure security reviews**

Example security audit workflow:

```
Security Audit
 ├── Check SUID/SGID files
 ├── Check 777 permissions
 ├── Check open ports
 ├── Verify sudo access
```

---

✅ **Best Practices**

* 🔒 Review **unexpected SUID/SGID files** immediately.
* ⚠️ Remove unnecessary SUID permissions using:

```bash
chmod u-s filename
```

* 📄 Maintain **regular security audit reports**.
* 🚀 Integrate scans into **cron jobs or security automation pipelines**.

Example cron automation:

```
0 3 * * * /usr/local/bin/suid_scan.sh
```

---

💡 **In short**

* **SUID/SGID files run with elevated privileges**, which can be risky if misconfigured.
* The script scans the system using `find` and **generates a security report**.
* This helps detect **potential privilege escalation vulnerabilities** during security audits.

---
## Q98: Write a bash script to check for failed SSH login attempts in `auth.log` and list suspicious IP addresses

🧠 **Overview**

* SSH servers log authentication events in **`/var/log/auth.log` (Ubuntu/Debian)** or **`/var/log/secure` (RHEL/CentOS)**.
* Repeated failed login attempts may indicate **brute-force attacks or unauthorized access attempts**.
* DevOps and security teams analyze these logs to **detect suspicious IP addresses and mitigate threats** (e.g., using firewall rules or Fail2Ban).

---

⚙️ **Purpose / How it works**

1. Read SSH authentication logs (`auth.log`).
2. Filter **failed SSH login attempts** using `grep`.
3. Extract the **source IP addresses**.
4. Count occurrences to identify **suspicious IPs** with repeated failures.

---

🧩 **Bash Script**

```bash
#!/bin/bash

LOG_FILE="/var/log/auth.log"
REPORT="ssh_failed_login_report_$(date +%F).txt"

echo "SSH Failed Login Attempt Report" > $REPORT
echo "Generated on: $(date)" >> $REPORT
echo "----------------------------------------" >> $REPORT

grep "Failed password" $LOG_FILE | \
awk '{print $(NF-3)}' | \
sort | uniq -c | sort -nr >> $REPORT

echo "Report generated: $REPORT"
```

---

🧩 **Example Output**

Example report:

```
SSH Failed Login Attempt Report
Generated on: Wed Mar 4 2026

45 192.168.1.45
22 203.0.113.10
10 185.220.101.32
3  10.0.0.5
```

Meaning:

| Attempts | IP Address     |
| -------- | -------------- |
| 45       | 192.168.1.45   |
| 22       | 203.0.113.10   |
| 10       | 185.220.101.32 |

IPs with many attempts may be **brute-force attackers**.

---

📋 **Key Linux Commands Used**

| Command                  | Purpose                       |
| ------------------------ | ----------------------------- |
| `grep "Failed password"` | Filter failed SSH logins      |
| `awk`                    | Extract IP address            |
| `sort`                   | Sort entries                  |
| `uniq -c`                | Count occurrences             |
| `sort -nr`               | Sort by highest attempt count |

---

🧩 **Improved Script (Flag Suspicious IPs)**

Highlight IPs with more than **10 failed attempts**.

```bash
#!/bin/bash

LOG_FILE="/var/log/auth.log"

echo "Suspicious SSH Login Attempts (>10 failures)"
echo "--------------------------------------------"

grep "Failed password" $LOG_FILE | \
awk '{print $(NF-3)}' | \
sort | uniq -c | sort -nr | \
awk '$1 > 10 {print "⚠️ Suspicious IP:", $2, "- Attempts:", $1}'
```

Example output:

```
⚠️ Suspicious IP: 203.0.113.10 - Attempts: 45
⚠️ Suspicious IP: 185.220.101.32 - Attempts: 22
```

---

🧩 **DevOps Real-world Use Case**

This script is used in:

* **Security monitoring scripts**
* **Server hardening audits**
* **Incident response investigations**
* **SOC monitoring tools**

Typical workflow:

```
Server Logs → Bash Script Analysis → Suspicious IP Detection → Firewall Block
```

Example firewall block:

```bash
sudo iptables -A INPUT -s 203.0.113.10 -j DROP
```

---

✅ **Best Practices**

* 🔒 Use **Fail2Ban** to automatically block repeated failed logins.
* ⚠️ Disable **password authentication** and use **SSH keys**.
* 📄 Regularly audit `/var/log/auth.log`.
* 🚀 Integrate scripts into **security monitoring pipelines**.

Example Fail2Ban install:

```bash
sudo apt install fail2ban
```

---

💡 **In short**

* SSH logs contain **failed login attempts from IP addresses**.
* The script parses `auth.log` to **count and list suspicious IPs**.
* Helps detect **brute-force attacks and improve server security**.

---
## Q99: Write a bash script to enforce password complexity by checking `/etc/login.defs` and PAM configuration

🧠 **Overview**

* Linux systems enforce password policies through **`/etc/login.defs`** and **PAM (Pluggable Authentication Modules)** configuration.
* Security standards (CIS benchmarks, SOC2, ISO) require **strong password policies** such as minimum length, character complexity, and expiration rules.
* DevOps/security teams often automate checks to ensure systems comply with **password complexity policies**.

---

⚙️ **Purpose / How it works**

1. Check password policy values in **`/etc/login.defs`**:

   * Minimum password length
   * Password expiration rules
2. Verify PAM configuration files such as:

   * `/etc/pam.d/common-password` (Ubuntu/Debian)
   * `/etc/pam.d/system-auth` (RHEL/CentOS)
3. Detect whether **`pam_pwquality.so` or `pam_cracklib.so`** is enabled for password complexity enforcement.
4. Generate a **security report** showing compliance status.

---

🧩 **Bash Script**

```bash
#!/bin/bash

REPORT="password_policy_report_$(date +%F).txt"

echo "Password Complexity Audit Report" > $REPORT
echo "Generated on: $(date)" >> $REPORT
echo "----------------------------------------" >> $REPORT

echo "" >> $REPORT
echo "Checking /etc/login.defs settings..." >> $REPORT

grep -E "PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_MIN_LEN|PASS_WARN_AGE" /etc/login.defs >> $REPORT

echo "" >> $REPORT
echo "Checking PAM password complexity configuration..." >> $REPORT

if grep -E "pam_pwquality.so|pam_cracklib.so" /etc/pam.d/* 2>/dev/null >> $REPORT
then
    echo "PAM complexity module detected." >> $REPORT
else
    echo "WARNING: Password complexity module not configured!" >> $REPORT
fi

echo "" >> $REPORT
echo "Audit completed." >> $REPORT

echo "Password policy report generated: $REPORT"
```

---

🧩 **Example Output**

```
Password Complexity Audit Report
Generated on: Wed Mar 4 2026

Checking /etc/login.defs settings...

PASS_MAX_DAYS   90
PASS_MIN_DAYS   1
PASS_MIN_LEN    12
PASS_WARN_AGE   7

Checking PAM password complexity configuration...

password requisite pam_pwquality.so retry=3 minlen=12 ucredit=-1 lcredit=-1 dcredit=-1

PAM complexity module detected.
```

---

📋 **Important Password Policy Parameters**

| Parameter       | Description                             |
| --------------- | --------------------------------------- |
| `PASS_MIN_LEN`  | Minimum password length                 |
| `PASS_MAX_DAYS` | Password expiration period              |
| `PASS_MIN_DAYS` | Minimum days between password changes   |
| `PASS_WARN_AGE` | Days before password expiration warning |

---

🧩 **Example PAM Configuration**

Typical complexity policy:

```
password requisite pam_pwquality.so retry=3 minlen=12 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1
```

Meaning:

| Parameter    | Meaning                   |
| ------------ | ------------------------- |
| `minlen=12`  | Minimum 12 characters     |
| `ucredit=-1` | Require uppercase letter  |
| `lcredit=-1` | Require lowercase letter  |
| `dcredit=-1` | Require digit             |
| `ocredit=-1` | Require special character |

---

🧩 **DevOps Real-world Use Case**

Password policy checks are part of:

* **Server hardening scripts**
* **CIS benchmark audits**
* **Compliance scans**
* **Security automation pipelines**

Example workflow:

```
Security Scan
 ├── Check password policy
 ├── Check SUID files
 ├── Check SSH configuration
 └── Generate compliance report
```

---

✅ **Best Practices**

* 🔒 Use **strong password policies (≥12 characters)**.
* ⚠️ Enforce complexity using **`pam_pwquality`**.
* 📄 Run periodic **security audits on authentication policies**.
* 🚀 Integrate checks into **configuration management tools (Ansible, Chef, Puppet)**.

Example installation:

```bash
sudo apt install libpam-pwquality
```

---

💡 **In short**

* Password complexity is enforced using **`/etc/login.defs` and PAM modules**.
* The script audits these configurations and **generates a security report**.
* This helps ensure systems comply with **security standards and password policies**.

---
## Q100: Write a bash script to audit user accounts: find accounts without passwords, accounts with UID 0, and inactive accounts

🧠 **Overview**

* Linux systems store user information in **`/etc/passwd` and `/etc/shadow`**.
* Misconfigured accounts (no password, UID 0 privileges, inactive accounts) can create **serious security risks**.
* DevOps and security teams run **user account audit scripts** to detect potential vulnerabilities and enforce compliance policies.

---

⚙️ **Purpose / How it works**

1. **Check accounts without passwords** using `/etc/shadow`.
2. **Detect accounts with UID 0** (root-level privileges).
3. **Identify inactive user accounts** based on last login activity.
4. Generate a **security audit report**.

---

🧩 **Bash Script**

```bash
#!/bin/bash

REPORT="user_audit_report_$(date +%F).txt"

echo "User Account Security Audit Report" > $REPORT
echo "Generated on: $(date)" >> $REPORT
echo "----------------------------------------" >> $REPORT

# Accounts without passwords
echo "" >> $REPORT
echo "Accounts without passwords:" >> $REPORT
awk -F: '($2==""){print $1}' /etc/shadow >> $REPORT

# Accounts with UID 0
echo "" >> $REPORT
echo "Accounts with UID 0 (root privileges):" >> $REPORT
awk -F: '($3 == 0) {print $1}' /etc/passwd >> $REPORT

# Inactive accounts (no login for 30+ days)
echo "" >> $REPORT
echo "Inactive accounts (30+ days):" >> $REPORT
lastlog | awk 'NR>1 {if ($4=="**Never" || $5=="logged") print $1}' >> $REPORT

echo "" >> $REPORT
echo "Audit completed." >> $REPORT

echo "User audit report generated: $REPORT"
```

---

🧩 **Example Output**

Example report:

```
User Account Security Audit Report
Generated on: Wed Mar 4 2026

Accounts without passwords:
testuser
guest

Accounts with UID 0 (root privileges):
root
admin

Inactive accounts (30+ days):
olduser
backupadmin
```

---

📋 **Important System Files**

| File               | Purpose                         |
| ------------------ | ------------------------------- |
| `/etc/passwd`      | Stores user account information |
| `/etc/shadow`      | Stores encrypted passwords      |
| `/var/log/lastlog` | Stores last login records       |

---

🧩 **Manual Commands Used**

Check accounts without passwords:

```bash
awk -F: '($2==""){print $1}' /etc/shadow
```

Find UID 0 accounts:

```bash
awk -F: '($3 == 0) {print $1}' /etc/passwd
```

Check inactive users:

```bash
lastlog
```

---

🧩 **DevOps Real-world Use Case**

User audits are part of:

* **Linux server hardening**
* **Security compliance checks**
* **CIS benchmark audits**
* **Access control reviews**

Typical security audit flow:

```
System Audit
 ├── Check user accounts
 ├── Check sudo access
 ├── Check file permissions
 └── Generate security report
```

---

✅ **Best Practices**

* 🔒 Avoid multiple **UID 0 accounts** unless required.
* ⚠️ Disable or lock unused accounts:

```bash
sudo usermod -L username
```

* 📄 Run periodic **user account audits**.
* 🚀 Automate checks with **cron or security monitoring tools**.

Example automation:

```bash
0 2 * * 0 /usr/local/bin/user_audit.sh
```

Runs weekly.

---

💡 **In short**

* Misconfigured user accounts can create **serious security vulnerabilities**.
* The script audits **accounts without passwords, UID 0 accounts, and inactive users**.
* This helps maintain **secure access control and compliance on Linux systems**.
