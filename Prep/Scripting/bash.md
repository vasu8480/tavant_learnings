# 50 Top Bash Scripting Questions & Answers for SRE/DevOps Interviews

## Q1: Write a bash script that monitors disk usage and sends an alert email when any partition exceeds 80% usage.

### 🧠 Overview

* Uses `df -h` to check disk usage.
* If any partition > 80%, send email alert.
* Can be scheduled via `cron` for continuous monitoring.

---

### ✅ Bash Script (`disk_alert.sh`)

```bash
#!/bin/bash

THRESHOLD=80
EMAIL="admin@example.com"
HOSTNAME=$(hostname)
DATE=$(date)

# Check disk usage
df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $1 " " $5 }' | while read output;
do
  usage=$(echo $output | awk '{ print $2 }' | sed 's/%//g')
  partition=$(echo $output | awk '{ print $1 }')

  if [ $usage -ge $THRESHOLD ]; then
    echo "Alert: Disk usage on $partition is ${usage}% on $HOSTNAME at $DATE" \
    | mail -s "Disk Usage Alert - $HOSTNAME" $EMAIL
  fi
done
```

---

### 🔎 What it does

* Filters real partitions (ignores tmpfs, cdrom).
* Extracts usage %.
* Sends email if usage ≥ 80%.

---

### 📦 Prerequisites

Install mail utility:

```bash
sudo apt install mailutils   # Ubuntu/Debian
sudo yum install mailx       # RHEL/CentOS
```

Make script executable:

```bash
chmod +x disk_alert.sh
```

---

### ⏱ Run via Cron (Every 5 Minutes)

```bash
crontab -e
```

Add:

```bash
*/5 * * * * /path/to/disk_alert.sh >> /var/log/disk_alert.log 2>&1
```

---

### 🚀 Production Improvements (Recommended)

* Use `sendmail` or SMTP relay (SES/Postfix) instead of local mail.
* Add alert deduplication (avoid repeated emails).
* Push metrics to Prometheus + Alertmanager for scalable monitoring.
* Store threshold in config file.

---

If you want, I can also provide:

* **Enterprise version (Prometheus node_exporter based)**
* **Script with Slack/MS Teams webhook**
* **AWS CloudWatch based monitoring version**
----

## Q2: Write a script that automatically rotates log files older than 7 days, compresses them, and deletes files older than 30 days

### 🧠 Overview

* Compress logs older than **7 days**
* Delete logs older than **30 days**
* Uses `find`, `gzip`, and `rm`
* Suitable for cron scheduling

---

## ✅ Bash Script (`log_rotate.sh`)

```bash
#!/bin/bash

LOG_DIR="/var/log/myapp"
COMPRESS_DAYS=7
DELETE_DAYS=30
DATE=$(date)

echo "Log rotation started at $DATE"

# 1️⃣ Compress logs older than 7 days (only .log files, not already compressed)
find "$LOG_DIR" -type f -name "*.log" -mtime +$COMPRESS_DAYS ! -name "*.gz" -exec gzip {} \;

# 2️⃣ Delete compressed logs older than 30 days
find "$LOG_DIR" -type f -name "*.gz" -mtime +$DELETE_DAYS -exec rm -f {} \;

echo "Log rotation completed at $(date)"
```

---

## 🔎 What It Does

| Step     | Command                     | Purpose                         |
| -------- | --------------------------- | ------------------------------- |
| Compress | `find -mtime +7 -exec gzip` | Compress logs older than 7 days |
| Delete   | `find -mtime +30 -exec rm`  | Remove old compressed logs      |
| Filter   | `-name "*.log"`             | Prevents system file impact     |

---

## 📌 Make Executable

```bash
chmod +x log_rotate.sh
```

---

## ⏱ Schedule via Cron (Daily at 2 AM)

```bash
crontab -e
```

Add:

```bash
0 2 * * * /path/to/log_rotate.sh >> /var/log/log_rotate.log 2>&1
```

---

## 🚀 Production-Ready Improvements

* Add log file locking (`flock`) to avoid parallel runs.
* Use `-print` before delete in dry-run mode for safety:

  ```bash
  find ... -print
  ```
* Add email alert if deletion fails.
* Consider using built-in Linux tool:
  👉 `logrotate` (more robust, supports size-based rotation).

---

## 🔥 Enterprise Alternative (Recommended)

Use native `logrotate`:

Example config:

```
/var/log/myapp/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
}
```

This is preferred in production environments over custom scripts.

---

If you want, I can provide:

* Version with size-based rotation
* Version with S3 archival before deletion
* Kubernetes sidecar log rotation setup

----
## Q3: Write a bash script that checks if a list of services (nginx, mysql, redis) are running and restarts them if they are down, logging all actions with timestamps.

### 🧠 Overview

* Checks service status using `systemctl`
* Restarts service if inactive
* Logs every action with timestamp
* Suitable for cron or systemd timer

---

## ✅ Bash Script (`service_monitor.sh`)

```bash
#!/bin/bash

# Services to monitor
SERVICES=("nginx" "mysql" "redis")

# Log file
LOG_FILE="/var/log/service_monitor.log"

# Timestamp function
timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

echo "$(timestamp) - Service check started" >> $LOG_FILE

for SERVICE in "${SERVICES[@]}"; do

    if systemctl is-active --quiet "$SERVICE"; then
        echo "$(timestamp) - $SERVICE is running" >> $LOG_FILE
    else
        echo "$(timestamp) - $SERVICE is DOWN. Attempting restart..." >> $LOG_FILE
        
        systemctl restart "$SERVICE"

        # Recheck after restart
        if systemctl is-active --quiet "$SERVICE"; then
            echo "$(timestamp) - $SERVICE restarted successfully" >> $LOG_FILE
        else
            echo "$(timestamp) - ERROR: $SERVICE failed to restart" >> $LOG_FILE
        fi
    fi

done

echo "$(timestamp) - Service check completed" >> $LOG_FILE
echo "----------------------------------------" >> $LOG_FILE
```

---

## 🔎 What It Does

| Step         | Command                       | Purpose                      |
| ------------ | ----------------------------- | ---------------------------- |
| Check status | `systemctl is-active --quiet` | Detect if service is running |
| Restart      | `systemctl restart`           | Attempt recovery             |
| Logging      | `date` + append (`>>`)        | Timestamped audit trail      |

---

## 📌 Make Executable

```bash
chmod +x service_monitor.sh
```

---

## ⏱ Schedule via Cron (Every 5 Minutes)

```bash
crontab -e
```

Add:

```bash
*/5 * * * * /path/to/service_monitor.sh
```

---

## 🚀 Production Enhancements (Recommended)

* Add email/Slack alert if restart fails.
* Use `flock` to avoid concurrent execution:

  ```bash
  flock -n /tmp/service_monitor.lock ./service_monitor.sh
  ```
* Use systemd timer instead of cron (better control).
* In Kubernetes → use liveness/readiness probes instead of restart scripts.
* In cloud → use auto-scaling + health checks (ALB/ELB).

---

If needed, I can provide:

* Version with Slack webhook alerts
* Version with AWS SNS notifications
* Version using `supervisord`
* Kubernetes-native health monitoring approach

----
## Q4: Write a script that reads a CSV file containing server IPs and usernames, SSHes into each server, and collects CPU, memory, and disk usage into a report.

### 🧠 Overview

* Reads `servers.csv` (IP,username)
* SSH into each server (key-based auth recommended)
* Collects:

  * CPU usage
  * Memory usage
  * Disk usage
* Writes consolidated report (`report.csv`)

---

## 📄 Sample `servers.csv`

```
192.168.1.10,ubuntu
192.168.1.20,ec2-user
```

---

## ✅ Bash Script (`server_health_report.sh`)

```bash
#!/bin/bash

INPUT_FILE="servers.csv"
OUTPUT_FILE="server_report_$(date +%F).csv"

echo "IP,CPU_Usage(%),Memory_Usage(%),Disk_Usage(%)" > "$OUTPUT_FILE"

while IFS=',' read -r IP USER
do
    echo "Collecting data from $IP..."

    STATS=$(ssh -o ConnectTimeout=5 -o BatchMode=yes "$USER@$IP" bash << 'EOF'
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
MEM=$(free | awk '/Mem/ {printf("%.2f"), $3/$2 * 100}')
DISK=$(df -h / | awk 'NR==2 {gsub("%",""); print $5}')
echo "$CPU,$MEM,$DISK"
EOF
)

    if [ $? -eq 0 ]; then
        echo "$IP,$STATS" >> "$OUTPUT_FILE"
    else
        echo "$IP,ERROR,ERROR,ERROR" >> "$OUTPUT_FILE"
    fi

done < "$INPUT_FILE"

echo "Report generated: $OUTPUT_FILE"
```

---

## 🔎 What It Collects

| Metric | Command Used | What It Measures     |
| ------ | ------------ | -------------------- |
| CPU    | `top -bn1`   | % CPU used           |
| Memory | `free`       | % RAM used           |
| Disk   | `df -h /`    | Root partition usage |

---

## 🔐 Prerequisites (Important)

* SSH key-based authentication setup:

  ```bash
  ssh-copy-id user@server_ip
  ```
* Passwordless login required (BatchMode=yes avoids password prompts).
* Ensure `top`, `free`, `df` available (standard on Linux).

---

## 📦 Make Executable

```bash
chmod +x server_health_report.sh
```

---

## 📊 Output Example (`server_report_2026-02-14.csv`)

```
IP,CPU_Usage(%),Memory_Usage(%),Disk_Usage(%)
192.168.1.10,23.5,45.67,61
192.168.1.20,12.8,33.21,55
```

---

## 🚀 Production-Grade Improvements

* Use parallel execution (`&` or `xargs -P`) for large fleets.
* Add timeout handling (`timeout 10 ssh ...`).
* Send report via email/S3 upload.
* Replace with:

  * Ansible ad-hoc command
  * Prometheus + node_exporter
  * AWS SSM Run Command (no SSH needed)

---

If you want, I can give:

* Parallel execution version
* AWS SSM-based script (no SSH)
* Version pushing report to S3
* Enterprise Ansible playbook version

----
## Q5: Write a bash script that parses an application log file, extracts all ERROR lines, counts occurrences by error type, and outputs a summary sorted by frequency.

---

### 🧠 Overview

* Reads application log file
* Extracts lines containing `ERROR`
* Groups by error message/type
* Counts occurrences
* Sorts by highest frequency
* Outputs summary report

---

## 📄 Example Log Format

```
2026-02-14 10:10:01 INFO Application started
2026-02-14 10:11:05 ERROR Database connection failed
2026-02-14 10:11:07 ERROR Timeout while calling API
2026-02-14 10:12:01 ERROR Database connection failed
```

---

## ✅ Bash Script (`error_summary.sh`)

```bash
#!/bin/bash

LOG_FILE="/var/log/myapp/app.log"
OUTPUT_FILE="error_summary_$(date +%F).txt"

if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found!"
    exit 1
fi

echo "Error Summary Report - $(date)" > "$OUTPUT_FILE"
echo "---------------------------------" >> "$OUTPUT_FILE"

# Extract ERROR lines, remove timestamp + level, count & sort
grep "ERROR" "$LOG_FILE" \
| sed -E 's/^.*ERROR[[:space:]]+//' \
| sort \
| uniq -c \
| sort -nr \
>> "$OUTPUT_FILE"

echo "Report generated: $OUTPUT_FILE"
```

---

## 🔎 What Each Step Does

| Command        | Purpose                           |
| -------------- | --------------------------------- |
| `grep "ERROR"` | Extract ERROR lines               |
| `sed`          | Remove timestamp + "ERROR" prefix |
| `sort`         | Required before `uniq -c`         |
| `uniq -c`      | Count occurrences                 |
| `sort -nr`     | Sort by highest frequency         |

---

## 📊 Sample Output

```
Error Summary Report - Fri Feb 14 12:10:01 UTC 2026
---------------------------------
      12 Database connection failed
       7 Timeout while calling API
       3 Invalid user input
```

---

## 🚀 Production-Ready Improvements

* Case-insensitive matching:

  ```bash
  grep -i "error"
  ```

* Support structured logs (JSON):

  ```bash
  jq -r '.level=="ERROR" | .message'
  ```

* Filter only today’s logs:

  ```bash
  grep "$(date +%F)"
  ```

* Large file optimization:

  ```bash
  awk '/ERROR/ {sub(/^.*ERROR[ \t]+/, ""); print}' app.log
  ```

* Ship summary to:

  * Email
  * Slack webhook
  * S3 bucket
  * ELK / OpenSearch

---

If you want, I can provide:

* High-performance `awk-only` version
* JSON log parsing version
* Real-time monitoring (tail -f based)
* Kubernetes pod log aggregation version

----
## Q6: Write a script that takes a directory as input, finds all files modified in the last 24 hours, and backs them up to an S3 bucket with a timestamp prefix.

### 🧠 Overview

* Accepts directory as argument
* Finds files modified in last 24 hours
* Uploads to S3 with timestamp prefix
* Uses AWS CLI (IAM role or configured profile)

---

## ✅ Prerequisites

```bash
aws --version
aws configure     # or use IAM role (EC2/EKS)
```

IAM permission required:

* `s3:PutObject`
* `s3:ListBucket`

---

## ✅ Bash Script (`s3_backup.sh`)

```bash
#!/bin/bash

# Usage: ./s3_backup.sh /path/to/dir my-s3-bucket

SOURCE_DIR="$1"
S3_BUCKET="$2"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
TMP_FILE_LIST="/tmp/file_list_$TIMESTAMP.txt"

if [ -z "$SOURCE_DIR" ] || [ -z "$S3_BUCKET" ]; then
    echo "Usage: $0 <source_directory> <s3_bucket>"
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Directory does not exist!"
    exit 1
fi

echo "Finding files modified in last 24 hours..."

find "$SOURCE_DIR" -type f -mtime -1 > "$TMP_FILE_LIST"

if [ ! -s "$TMP_FILE_LIST" ]; then
    echo "No files modified in last 24 hours."
    exit 0
fi

echo "Uploading files to s3://$S3_BUCKET/$TIMESTAMP/"

while read -r FILE
do
    REL_PATH="${FILE#$SOURCE_DIR/}"
    aws s3 cp "$FILE" "s3://$S3_BUCKET/$TIMESTAMP/$REL_PATH"
done < "$TMP_FILE_LIST"

rm -f "$TMP_FILE_LIST"

echo "Backup completed successfully."
```

---

## 🔎 What It Does

| Step               | Command                | Purpose                   |
| ------------------ | ---------------------- | ------------------------- |
| Find recent files  | `find -mtime -1`       | Last 24 hours             |
| Timestamp prefix   | `date +%Y%m%d_%H%M%S`  | Versioned folder          |
| Upload             | `aws s3 cp`            | Backup to S3              |
| Preserve structure | `${FILE#$SOURCE_DIR/}` | Keeps directory hierarchy |

---

## 📌 Example Run

```bash
chmod +x s3_backup.sh
./s3_backup.sh /var/log my-backup-bucket
```

Uploads to:

```
s3://my-backup-bucket/20260214_153000/...
```

---

## 🚀 Production-Ready Version (Optimized)

Instead of looping file-by-file, use:

```bash
aws s3 sync "$SOURCE_DIR" "s3://$S3_BUCKET/$TIMESTAMP/" \
    --exclude "*" \
    --include "*" \
    --size-only
```

Or better (handles metadata, parallelism):

```bash
aws s3 cp "$SOURCE_DIR" "s3://$S3_BUCKET/$TIMESTAMP/" \
    --recursive \
    --exclude "*" \
    --include "*"
```

---

## 🔐 Enterprise Improvements

* Use `--storage-class STANDARD_IA` for cost optimization.
* Enable bucket versioning.
* Add retry logic.
* Log to CloudWatch.
* Use lifecycle rule to auto-delete old backups.
* Use KMS encryption:

```bash
--sse aws:kms --sse-kms-key-id <key-id>
```

---

If you want, I can provide:

* Terraform S3 + IAM setup
* Cron-based automated backup
* EKS pod version using IAM role for service account (IRSA)
* Parallel upload version for large directories

----
## Q7: Write a bash script that implements a retry mechanism with exponential backoff for any command that fails.

### 🧠 Overview

* Retries a failed command
* Uses exponential backoff (2^n delay)
* Stops after max retries
* Returns original exit code
* Production-friendly (logging + configurable)

---

## ✅ Generic Retry Script (`retry.sh`)

```bash
#!/bin/bash

# Usage:
# ./retry.sh <max_retries> <initial_delay_seconds> <command>

MAX_RETRIES=${1:-5}
INITIAL_DELAY=${2:-2}
shift 2

if [ $# -eq 0 ]; then
    echo "Usage: $0 <max_retries> <initial_delay> <command>"
    exit 1
fi

ATTEMPT=1
DELAY=$INITIAL_DELAY

while true; do
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Attempt $ATTEMPT: Running command..."
    
    "$@"
    EXIT_CODE=$?

    if [ $EXIT_CODE -eq 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Command succeeded."
        exit 0
    fi

    if [ $ATTEMPT -ge $MAX_RETRIES ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Command failed after $ATTEMPT attempts."
        exit $EXIT_CODE
    fi

    echo "$(date '+%Y-%m-%d %H:%M:%S') - Command failed. Retrying in $DELAY seconds..."
    sleep $DELAY

    DELAY=$((DELAY * 2))   # Exponential backoff
    ATTEMPT=$((ATTEMPT + 1))
done
```

---

## 📌 Example Usage

Retry AWS S3 upload:

```bash
./retry.sh 5 2 aws s3 cp file.txt s3://my-bucket/
```

Retry curl API call:

```bash
./retry.sh 4 1 curl -f https://api.example.com/health
```

---

## 🔎 What It Does

| Feature             | Explanation                   |
| ------------------- | ----------------------------- |
| Retry limit         | Stops after max attempts      |
| Exponential delay   | 2, 4, 8, 16… seconds          |
| Exit code preserved | Returns original failure code |
| Command-agnostic    | Works with any shell command  |

---

## 🚀 Production Improvements (Enterprise)

### 1️⃣ Add Max Delay Cap

```bash
DELAY=$((DELAY * 2))
[ $DELAY -gt 60 ] && DELAY=60
```

### 2️⃣ Add Jitter (Recommended for distributed systems)

```bash
JITTER=$((RANDOM % 3))
sleep $((DELAY + JITTER))
```

### 3️⃣ Log to File

```bash
LOG_FILE="/var/log/retry.log"
exec >> $LOG_FILE 2>&1
```

---

## 🔥 Real-World Use Cases

* AWS CLI failures (network throttling)
* Helm deployments
* Kubernetes API retries
* API health checks
* Database migrations

---

If you want, I can provide:

* Library-style reusable retry function
* Kubernetes job wrapper version
* CI/CD pipeline (GitLab/GitHub Actions) implementation
* Version with circuit-breaker logic

----
## Q8: Write a script that deploys a new application version by stopping the current process, replacing the binary, starting the new version, and rolling back automatically if the health check fails.

### 🧠 Overview

* Stop current app
* Backup existing binary
* Deploy new binary
* Start app
* Perform health check
* Auto-rollback if health check fails
* Production-safe (exit codes + logging)

---

## 📁 Assumptions

| Item            | Example                        |
| --------------- | ------------------------------ |
| App binary path | `/opt/myapp/myapp`             |
| New binary      | `/tmp/myapp_new`               |
| Backup dir      | `/opt/myapp/backup`            |
| Health endpoint | `http://localhost:8080/health` |
| Service name    | `myapp` (systemd managed)      |

---

## ✅ Bash Script (`deploy_with_rollback.sh`)

```bash
#!/bin/bash

APP_NAME="myapp"
APP_DIR="/opt/myapp"
APP_BINARY="$APP_DIR/$APP_NAME"
NEW_BINARY="/tmp/myapp_new"
BACKUP_DIR="$APP_DIR/backup"
HEALTH_URL="http://localhost:8080/health"
LOG_FILE="/var/log/${APP_NAME}_deploy.log"

MAX_HEALTH_RETRIES=5
SLEEP_BETWEEN_CHECKS=5

timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

log() {
    echo "$(timestamp) - $1" | tee -a "$LOG_FILE"
}

rollback() {
    log "Health check failed. Initiating rollback..."

    systemctl stop "$APP_NAME"
    cp "$BACKUP_DIR/${APP_NAME}_backup" "$APP_BINARY"
    chmod +x "$APP_BINARY"
    systemctl start "$APP_NAME"

    log "Rollback completed."
    exit 1
}

# --- Start Deployment ---

log "Deployment started."

if [ ! -f "$NEW_BINARY" ]; then
    log "New binary not found!"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

log "Stopping application..."
systemctl stop "$APP_NAME"

log "Backing up current binary..."
cp "$APP_BINARY" "$BACKUP_DIR/${APP_NAME}_backup"

log "Deploying new binary..."
cp "$NEW_BINARY" "$APP_BINARY"
chmod +x "$APP_BINARY"

log "Starting application..."
systemctl start "$APP_NAME"

# --- Health Check ---

log "Performing health checks..."

for ((i=1; i<=MAX_HEALTH_RETRIES; i++)); do
    sleep $SLEEP_BETWEEN_CHECKS

    STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$HEALTH_URL")

    if [ "$STATUS" == "200" ]; then
        log "Health check passed."
        log "Deployment successful."
        exit 0
    fi

    log "Health check attempt $i failed (HTTP $STATUS)."
done

rollback
```

---

## 🔎 What It Does

| Step     | Action                           |
| -------- | -------------------------------- |
| Backup   | Saves previous working binary    |
| Replace  | Copies new version               |
| Start    | Starts service via systemctl     |
| Validate | Calls health endpoint            |
| Rollback | Restores old binary if unhealthy |

---

## 📌 Run

```bash
chmod +x deploy_with_rollback.sh
sudo ./deploy_with_rollback.sh
```

---

## 🚀 Production Improvements (Enterprise Grade)

### 1️⃣ Versioned Backups

Instead of single backup:

```bash
cp "$APP_BINARY" "$BACKUP_DIR/${APP_NAME}_$(date +%F_%H%M%S)"
```

### 2️⃣ Atomic Symlink Deployment (Safer)

Deploy new version to versioned folder:

```
/opt/myapp/releases/v2/
/opt/myapp/current -> symlink
```

Then switch symlink instead of overwriting binary.

### 3️⃣ Add Retry Wrapper (from Q7)

Wrap `systemctl start` and `curl` with retry logic.

### 4️⃣ Zero Downtime Alternative

* Blue/Green deployment
* Load balancer switch
* Kubernetes rolling update

---

## 🔥 Real-World Mapping

| Environment | Recommended Approach             |
| ----------- | -------------------------------- |
| Bare Metal  | This script                      |
| EC2         | Systemd + ALB health check       |
| Kubernetes  | Rolling update + readiness probe |
| Enterprise  | Canary + Feature flags           |

---

If you want, I can provide:

* Zero-downtime Blue/Green script
* Kubernetes deployment YAML version
* GitLab CI/CD pipeline version
* Symlink-based atomic deployment script (recommended for production)

-----
## Q9: Write a bash script that monitors a web endpoint every 30 seconds and logs response time, status code, and alerts if response time exceeds 2 seconds.

### 🧠 Overview

* Runs continuously (every 30 sec)
* Uses `curl` to capture:

  * HTTP status code
  * Total response time
* Logs to file with timestamps
* Triggers alert if response time > 2 sec

---

## ✅ Bash Script (`endpoint_monitor.sh`)

```bash
#!/bin/bash

URL="https://example.com/health"
LOG_FILE="/var/log/endpoint_monitor.log"
THRESHOLD=2
INTERVAL=30
ALERT_EMAIL="admin@example.com"

timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

while true; do

    RESPONSE=$(curl -s -o /dev/null \
        -w "%{http_code} %{time_total}" \
        --max-time 10 \
        "$URL")

    STATUS_CODE=$(echo $RESPONSE | awk '{print $1}')
    RESPONSE_TIME=$(echo $RESPONSE | awk '{print $2}')

    echo "$(timestamp) | Status: $STATUS_CODE | ResponseTime: ${RESPONSE_TIME}s" >> "$LOG_FILE"

    # Compare response time (float comparison using awk)
    ALERT=$(awk -v t="$RESPONSE_TIME" -v th="$THRESHOLD" 'BEGIN {print (t > th) ? 1 : 0}')

    if [ "$ALERT" -eq 1 ]; then
        echo "$(timestamp) - ALERT: Response time exceeded threshold (${RESPONSE_TIME}s)" \
        | mail -s "Endpoint Performance Alert" "$ALERT_EMAIL"
    fi

    sleep $INTERVAL
done
```

---

## 🔎 What It Captures

| Metric        | curl Option     | Meaning               |
| ------------- | --------------- | --------------------- |
| Status Code   | `%{http_code}`  | HTTP response         |
| Response Time | `%{time_total}` | Total time in seconds |
| Timeout       | `--max-time 10` | Prevent hanging       |

---

## 📌 Run

```bash
chmod +x endpoint_monitor.sh
sudo ./endpoint_monitor.sh
```

Or run in background:

```bash
nohup ./endpoint_monitor.sh &
```

---

## 📊 Sample Log Output

```
2026-02-14 15:30:00 | Status: 200 | ResponseTime: 0.342s
2026-02-14 15:30:30 | Status: 200 | ResponseTime: 2.543s
```

---

## 🚀 Production Improvements (Recommended)

### 1️⃣ Add Status Code Alert

```bash
if [ "$STATUS_CODE" -ne 200 ]; then
    # trigger alert
fi
```

### 2️⃣ Use Slack Instead of Email

```bash
curl -X POST -H 'Content-type: application/json' \
--data '{"text":"High response time detected"}' \
https://hooks.slack.com/services/XXX
```

### 3️⃣ Avoid Duplicate Alerts

* Add cooldown timer
* Alert only if threshold breached 3 times consecutively

### 4️⃣ Systemd Service Instead of while-loop

Create:

```
/etc/systemd/system/endpoint-monitor.service
```

### 5️⃣ Enterprise Alternative

* Prometheus + Blackbox Exporter
* Alertmanager
* AWS CloudWatch Synthetics

---

## 🔥 Real-World Mapping

| Setup              | Recommended Tool              |
| ------------------ | ----------------------------- |
| Small server       | This script                   |
| Multi-server infra | Prometheus Blackbox           |
| AWS                | CloudWatch + ALB health check |
| Kubernetes         | Liveness + Readiness probe    |

---

If you want, I can provide:

* Version with alert throttling
* Multi-endpoint monitoring version
* Docker container version
* Prometheus blackbox configuration example

----
## Q10: Write a script that cleans up Docker resources (stopped containers, unused images, dangling volumes) and reports how much disk space was freed.

### 🧠 Overview

* Removes:

  * Stopped containers
  * Unused images
  * Dangling volumes
* Calculates disk usage **before and after**
* Reports total space freed
* Safe for cron automation

---

## ✅ Bash Script (`docker_cleanup.sh`)

```bash
#!/bin/bash

LOG_FILE="/var/log/docker_cleanup.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

log() {
    echo "$TIMESTAMP - $1" | tee -a "$LOG_FILE"
}

# Check if Docker is running
if ! systemctl is-active --quiet docker; then
    log "Docker service is not running."
    exit 1
fi

log "Docker cleanup started."

# Get disk usage before cleanup (in bytes)
BEFORE=$(docker system df -v | awk '/Total space used/ {print $4}')
BEFORE_BYTES=$(docker system df --format "{{.Size}}" | awk '
function tobytes(x){
    if (x ~ /GB/) return x*1024*1024*1024
    if (x ~ /MB/) return x*1024*1024
    if (x ~ /kB/) return x*1024
    return x
}
{gsub(/GB|MB|kB|B/, "", $1); total+=tobytes($1)}
END {print total}')

# Cleanup commands
docker container prune -f
docker image prune -a -f
docker volume prune -f

# Get disk usage after cleanup
AFTER_BYTES=$(docker system df --format "{{.Size}}" | awk '
function tobytes(x){
    if (x ~ /GB/) return x*1024*1024*1024
    if (x ~ /MB/) return x*1024*1024
    if (x ~ /kB/) return x*1024
    return x
}
{gsub(/GB|MB|kB|B/, "", $1); total+=tobytes($1)}
END {print total}')

FREED=$((BEFORE_BYTES - AFTER_BYTES))
FREED_MB=$((FREED / 1024 / 1024))

log "Docker cleanup completed."
log "Total space freed: ${FREED_MB} MB"
```

---

## 🔎 What It Cleans

| Resource   | Command                     | What It Removes    |
| ---------- | --------------------------- | ------------------ |
| Containers | `docker container prune -f` | Stopped containers |
| Images     | `docker image prune -a -f`  | Unused images      |
| Volumes    | `docker volume prune -f`    | Dangling volumes   |

---

## 📌 Run

```bash
chmod +x docker_cleanup.sh
sudo ./docker_cleanup.sh
```

---

## ⏱ Schedule via Cron (Weekly)

```bash
0 3 * * 0 /path/docker_cleanup.sh
```

---

## 🚀 Production Improvements

### 1️⃣ Safer Cleanup (No `-a`)

Remove only dangling images:

```bash
docker image prune -f
```

### 2️⃣ Include Networks

```bash
docker network prune -f
```

### 3️⃣ Full System Cleanup

```bash
docker system prune -a -f --volumes
```

### 4️⃣ Add Alert if Freed Space > Threshold

```bash
if [ "$FREED_MB" -gt 500 ]; then
   # send alert
fi
```

---

## 🔥 Enterprise Notes

* Avoid aggressive pruning on shared CI runners.
* Use lifecycle cleanup policies in:

  * ECR (image lifecycle rules)
  * GitLab Runner cache cleanup
* Monitor Docker disk usage:

  ```bash
  docker system df
  ```

---

If you want, I can provide:

* ECR cleanup automation script
* Kubernetes node cleanup version
* CI/CD runner-safe cleanup version
* Version with Slack notification

----
## Q11: Write a Python script that uses boto3 to list all EC2 instances across all regions, showing instance ID, type, state, and associated tags.

### 🧠 Overview

* Uses `boto3`
* Dynamically fetches all AWS regions
* Lists:

  * Instance ID
  * Instance type
  * State
  * Tags
* Production-safe (handles region errors)

---

## ✅ Prerequisites

```bash
pip install boto3
```

Authentication:

* `aws configure`
  **OR**
* IAM role (EC2 / EKS / GitHub OIDC)

Required IAM permissions:

* `ec2:DescribeRegions`
* `ec2:DescribeInstances`

---

## ✅ Python Script (`list_ec2_all_regions.py`)

```python
import boto3
from botocore.exceptions import ClientError

def get_all_regions():
    ec2 = boto3.client("ec2")
    regions = ec2.describe_regions(AllRegions=True)
    return [r["RegionName"] for r in regions["Regions"] if r["OptInStatus"] in ("opt-in-not-required", "opted-in")]

def format_tags(tags):
    if not tags:
        return {}
    return {tag["Key"]: tag["Value"] for tag in tags}

def list_instances():
    regions = get_all_regions()

    for region in regions:
        print(f"\n===== Region: {region} =====")

        try:
            ec2 = boto3.client("ec2", region_name=region)
            response = ec2.describe_instances()

            instances_found = False

            for reservation in response["Reservations"]:
                for instance in reservation["Instances"]:
                    instances_found = True
                    instance_id = instance["InstanceId"]
                    instance_type = instance["InstanceType"]
                    state = instance["State"]["Name"]
                    tags = format_tags(instance.get("Tags"))

                    print(f"InstanceId: {instance_id}")
                    print(f"Type      : {instance_type}")
                    print(f"State     : {state}")
                    print(f"Tags      : {tags}")
                    print("-" * 40)

            if not instances_found:
                print("No instances found.")

        except ClientError as e:
            print(f"Error in region {region}: {e}")

if __name__ == "__main__":
    list_instances()
```

---

## 📌 Run

```bash
python3 list_ec2_all_regions.py
```

---

## 📊 Sample Output

```
===== Region: ap-south-1 =====
InstanceId: i-0abc123456789
Type      : t3.medium
State     : running
Tags      : {'Name': 'web-server', 'Env': 'prod'}
----------------------------------------
```

---

## 🚀 Production Improvements

### 1️⃣ Handle Pagination (Large Accounts)

Replace:

```python
response = ec2.describe_instances()
```

With paginator:

```python
paginator = ec2.get_paginator("describe_instances")
for page in paginator.paginate():
    ...
```

---

### 2️⃣ Export to CSV

```python
import csv
```

Write to file for audit/reporting.

---

### 3️⃣ Add Filtering (Optional)

Only running instances:

```python
Filters=[{"Name": "instance-state-name", "Values": ["running"]}]
```

---

### 4️⃣ Enterprise Optimizations

* Use AWS Organizations + AssumeRole
* Parallel region scanning (threading)
* Send output to:

  * S3
  * DynamoDB
  * Security audit pipeline
* Integrate with cost governance automation

---

## 🔥 Real-World Use Case

* Security audit
* Cost optimization
* Asset inventory
* Compliance reporting

---

If you want, I can provide:

* Cross-account version (AssumeRole)
* CSV export version
* Parallel threaded version (faster)
* Terraform-based IAM policy for this script

----
## Q12: Write a Python script that automatically stops EC2 instances tagged with `Environment: Dev` every day at 8 PM and starts them at 8 AM.

### 🧠 Overview

* Finds EC2 instances with tag: `Environment=Dev`
* Stops them at **8 PM**
* Starts them at **8 AM**
* Works across all regions
* Designed to run via **cron** or **EventBridge**

---

## ✅ Required IAM Permissions

```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:DescribeInstances",
    "ec2:StartInstances",
    "ec2:StopInstances",
    "ec2:DescribeRegions"
  ],
  "Resource": "*"
}
```

---

## ✅ Python Script (`ec2_dev_scheduler.py`)

```python
import boto3
from datetime import datetime
from botocore.exceptions import ClientError

TAG_KEY = "Environment"
TAG_VALUE = "Dev"

STOP_HOUR = 20   # 8 PM
START_HOUR = 8   # 8 AM

def get_all_regions():
    ec2 = boto3.client("ec2")
    regions = ec2.describe_regions()["Regions"]
    return [r["RegionName"] for r in regions]

def get_dev_instances(ec2_client):
    paginator = ec2_client.get_paginator("describe_instances")

    filters = [
        {"Name": f"tag:{TAG_KEY}", "Values": [TAG_VALUE]},
        {"Name": "instance-state-name", "Values": ["running", "stopped"]}
    ]

    instances = []

    for page in paginator.paginate(Filters=filters):
        for reservation in page["Reservations"]:
            for instance in reservation["Instances"]:
                instances.append({
                    "InstanceId": instance["InstanceId"],
                    "State": instance["State"]["Name"]
                })

    return instances

def main():
    current_hour = datetime.now().hour
    regions = get_all_regions()

    for region in regions:
        print(f"\nProcessing region: {region}")
        ec2 = boto3.client("ec2", region_name=region)

        try:
            instances = get_dev_instances(ec2)

            for instance in instances:
                instance_id = instance["InstanceId"]
                state = instance["State"]

                if current_hour == STOP_HOUR and state == "running":
                    print(f"Stopping {instance_id}")
                    ec2.stop_instances(InstanceIds=[instance_id])

                elif current_hour == START_HOUR and state == "stopped":
                    print(f"Starting {instance_id}")
                    ec2.start_instances(InstanceIds=[instance_id])

        except ClientError as e:
            print(f"Error in region {region}: {e}")

if __name__ == "__main__":
    main()
```

---

## 📌 Run via Cron (Linux Server)

Edit crontab:

```bash
crontab -e
```

Add:

```bash
0 8 * * * /usr/bin/python3 /path/ec2_dev_scheduler.py
0 20 * * * /usr/bin/python3 /path/ec2_dev_scheduler.py
```

---

## 🚀 Enterprise-Recommended Setup (Better Than Cron)

### 🔹 Use AWS EventBridge + Lambda

1. Create Lambda with above logic.
2. Create two EventBridge rules:

   * `cron(0 8 * * ? *)`
   * `cron(0 20 * * ? *)`
3. Attach IAM role to Lambda.

Benefits:

* Serverless
* No cron dependency
* Multi-account ready

---

## 🔥 Production Improvements

### 1️⃣ Add Timezone Handling

Use:

```python
import pytz
datetime.now(pytz.timezone("Asia/Kolkata"))
```

### 2️⃣ Add Dry Run Mode

```python
ec2.stop_instances(InstanceIds=[instance_id], DryRun=True)
```

### 3️⃣ Add Slack Notification

### 4️⃣ Exclude Critical Instances

Add extra tag filter:

```
AutoSchedule=True
```

---

## 💡 Real-World Use Case

* Save Dev/QA infra cost
* Auto-schedule non-production workloads
* Governance & cost optimization

---

If you want, I can provide:

* Lambda-ready zip structure
* Terraform to deploy Lambda + EventBridge
* Cross-account scheduler (AssumeRole)
* EKS node group auto-stop version

----
## Q14: Write a Python script that checks all S3 buckets in your AWS account for public access settings and generates a compliance report.

---

### 🧠 Overview

* Lists all S3 buckets
* Checks:

  * Public Access Block configuration
  * Bucket ACL
  * Bucket policy (public access)
* Generates compliance report (CSV)
* Handles exceptions safely

---

## ✅ Required IAM Permissions

```json
{
  "Effect": "Allow",
  "Action": [
    "s3:ListAllMyBuckets",
    "s3:GetBucketAcl",
    "s3:GetBucketPolicyStatus",
    "s3:GetBucketPublicAccessBlock"
  ],
  "Resource": "*"
}
```

---

## ✅ Install Dependency

```bash
pip install boto3
```

---

## ✅ Python Script (`s3_public_access_audit.py`)

```python
import boto3
import csv
from botocore.exceptions import ClientError

s3 = boto3.client("s3")

def check_public_access(bucket_name):
    result = {
        "Bucket": bucket_name,
        "PublicACL": "Unknown",
        "PublicPolicy": "Unknown",
        "PublicAccessBlockEnabled": "Unknown",
        "Compliant": "Yes"
    }

    # Check ACL
    try:
        acl = s3.get_bucket_acl(Bucket=bucket_name)
        for grant in acl["Grants"]:
            grantee = grant.get("Grantee", {})
            if grantee.get("URI") in [
                "http://acs.amazonaws.com/groups/global/AllUsers",
                "http://acs.amazonaws.com/groups/global/AuthenticatedUsers"
            ]:
                result["PublicACL"] = "Yes"
                result["Compliant"] = "No"
                break
        else:
            result["PublicACL"] = "No"
    except ClientError:
        result["PublicACL"] = "Error"

    # Check Bucket Policy
    try:
        policy_status = s3.get_bucket_policy_status(Bucket=bucket_name)
        if policy_status["PolicyStatus"]["IsPublic"]:
            result["PublicPolicy"] = "Yes"
            result["Compliant"] = "No"
        else:
            result["PublicPolicy"] = "No"
    except ClientError:
        result["PublicPolicy"] = "No"

    # Check Public Access Block
    try:
        pab = s3.get_bucket_public_access_block(Bucket=bucket_name)
        config = pab["PublicAccessBlockConfiguration"]
        if all(config.values()):
            result["PublicAccessBlockEnabled"] = "Yes"
        else:
            result["PublicAccessBlockEnabled"] = "Partial/No"
            result["Compliant"] = "No"
    except ClientError:
        result["PublicAccessBlockEnabled"] = "Not Set"
        result["Compliant"] = "No"

    return result


def main():
    buckets = s3.list_buckets()["Buckets"]

    report_file = "s3_compliance_report.csv"

    with open(report_file, "w", newline="") as csvfile:
        fieldnames = [
            "Bucket",
            "PublicACL",
            "PublicPolicy",
            "PublicAccessBlockEnabled",
            "Compliant"
        ]
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()

        for bucket in buckets:
            bucket_name = bucket["Name"]
            print(f"Checking bucket: {bucket_name}")
            result = check_public_access(bucket_name)
            writer.writerow(result)

    print(f"\nCompliance report generated: {report_file}")


if __name__ == "__main__":
    main()
```

---

## 📌 Run

```bash
python3 s3_public_access_audit.py
```

---

## 📊 Sample Output (CSV)

| Bucket        | PublicACL | PublicPolicy | PublicAccessBlockEnabled | Compliant |
| ------------- | --------- | ------------ | ------------------------ | --------- |
| my-app-prod   | No        | No           | Yes                      | Yes       |
| static-assets | Yes       | No           | Partial/No               | No        |

---

## 🚀 Production Improvements

### 1️⃣ Multi-Region & Multi-Account

* Use AWS Organizations + AssumeRole

### 2️⃣ Upload Report to S3

```python
s3.upload_file("s3_compliance_report.csv", "audit-bucket", "reports/s3_report.csv")
```

### 3️⃣ Send Slack / Email Alert for Non-Compliant Buckets

### 4️⃣ Convert to Lambda + EventBridge (Daily Audit)

---

## 🔥 Enterprise Alternative

Instead of custom script, consider:

* AWS Config rule: `s3-bucket-public-read-prohibited`
* AWS Security Hub
* Control Tower guardrails

---

## 💡 Real-World Use Case

* Security compliance audit
* CIS benchmark validation
* Prevent accidental public exposure
* SOC2 / ISO reporting automation

---

If you want, I can provide:

* Cross-account AssumeRole version
* Terraform to deploy Lambda auditor
* Version that auto-remediates non-compliant buckets
* Full security audit script (S3 + IAM + EC2)

----
## Q15: Write a Python script that parses CloudWatch logs, identifies patterns of failed login attempts, and blocks suspicious IP addresses by adding them to a Security Group.

---

### 🧠 Overview

* Reads CloudWatch log group
* Detects repeated failed login attempts from same IP
* Threshold-based detection (e.g., 5 failures in 10 mins)
* Adds offending IP to Security Group inbound deny rule
* Production-safe (dedup + error handling)

---

## ⚠️ Assumptions

| Item              | Example                |
| ----------------- | ---------------------- |
| Log Group         | `/aws/ec2/app-auth`    |
| Failure Pattern   | `"Failed password"`    |
| Security Group ID | `sg-0123456789abcdef0` |
| Block Port        | 22 (SSH example)       |
| Threshold         | 5 failures             |

---

## ✅ Required IAM Permissions

```json
{
  "Effect": "Allow",
  "Action": [
    "logs:FilterLogEvents",
    "ec2:AuthorizeSecurityGroupIngress",
    "ec2:DescribeSecurityGroups"
  ],
  "Resource": "*"
}
```

---

## ✅ Install

```bash
pip install boto3
```

---

## ✅ Python Script (`cw_intrusion_blocker.py`)

```python
import boto3
import re
from collections import Counter
from datetime import datetime, timedelta

# Config
LOG_GROUP = "/aws/ec2/app-auth"
SECURITY_GROUP_ID = "sg-0123456789abcdef0"
FAILED_PATTERN = "Failed password"
FAIL_THRESHOLD = 5
LOOKBACK_MINUTES = 10
BLOCK_PORT = 22

logs = boto3.client("logs")
ec2 = boto3.client("ec2")

def get_recent_logs():
    start_time = int((datetime.utcnow() - timedelta(minutes=LOOKBACK_MINUTES)).timestamp() * 1000)

    response = logs.filter_log_events(
        logGroupName=LOG_GROUP,
        startTime=start_time,
        filterPattern=FAILED_PATTERN
    )

    return response.get("events", [])

def extract_ip(message):
    match = re.search(r"\b\d{1,3}(?:\.\d{1,3}){3}\b", message)
    return match.group(0) if match else None

def block_ip(ip):
    try:
        ec2.authorize_security_group_ingress(
            GroupId=SECURITY_GROUP_ID,
            IpPermissions=[
                {
                    "IpProtocol": "tcp",
                    "FromPort": BLOCK_PORT,
                    "ToPort": BLOCK_PORT,
                    "IpRanges": [{"CidrIp": f"{ip}/32"}],
                }
            ],
        )
        print(f"Blocked IP: {ip}")
    except Exception as e:
        if "InvalidPermission.Duplicate" in str(e):
            print(f"IP already blocked: {ip}")
        else:
            print(f"Error blocking {ip}: {e}")

def main():
    events = get_recent_logs()

    ip_counter = Counter()

    for event in events:
        ip = extract_ip(event["message"])
        if ip:
            ip_counter[ip] += 1

    for ip, count in ip_counter.items():
        if count >= FAIL_THRESHOLD:
            print(f"Suspicious IP detected: {ip} ({count} failures)")
            block_ip(ip)

if __name__ == "__main__":
    main()
```

---

## 📌 Run

```bash
python3 cw_intrusion_blocker.py
```

Or deploy as:

* Lambda (recommended)
* Cron job on EC2
* EventBridge scheduled rule

---

## 🔎 How It Works

| Step       | Action              |
| ---------- | ------------------- |
| Fetch logs | Last 10 minutes     |
| Filter     | `"Failed password"` |
| Extract IP | Regex               |
| Count      | `Counter()`         |
| Block      | Add SG ingress rule |

---

## 🚀 Production Improvements

### 1️⃣ Handle Pagination

Use `nextToken` for large log sets.

### 2️⃣ Avoid SG Rule Explosion

Instead of adding per-IP rule:

* Use AWS WAF IP set
* Use NACL rule (better scale)
* Use managed firewall

### 3️⃣ Auto-Unblock After X Hours

Store blocked IPs in DynamoDB with TTL.

### 4️⃣ Multi-Region Support

Loop through regions.

### 5️⃣ Use AWS WAF Instead (Enterprise Recommended)

Better approach:

* CloudWatch Logs → Lambda
* Update WAF IPSet
* Attach WAF to ALB / CloudFront

---

## 🔥 Real-World Mapping

| Small Setup | Security Group blocking |
| Enterprise | AWS WAF + IPSet |
| Kubernetes | NGINX ingress rate limiting |
| High Traffic | Fail2ban + WAF combo |

---

## 💡 Use Case

* SSH brute force prevention
* API login abuse detection
* Automated intrusion response
* SOC automation

---

If you want, I can provide:

* Lambda-ready version
* WAF IPSet implementation
* Terraform to deploy full pipeline
* Version with Slack alerting
* Fail2ban-style advanced detection logic

----
## Q16: Write a Python script that monitors an SQS queue depth and automatically scales ECS tasks up or down based on the queue size.

---

### 🧠 Overview

* Reads SQS queue depth (`ApproximateNumberOfMessages`)
* Decides desired ECS task count
* Updates ECS Service desired count
* Prevents aggressive scaling (min/max limits)
* Designed for cron/Lambda execution

---

## ⚙️ Assumptions

| Item                 | Example               |
| -------------------- | --------------------- |
| SQS Queue            | `my-processing-queue` |
| ECS Cluster          | `my-ecs-cluster`      |
| ECS Service          | `worker-service`      |
| Min Tasks            | 1                     |
| Max Tasks            | 10                    |
| Scale Up Threshold   | > 50 messages         |
| Scale Down Threshold | < 10 messages         |

---

## ✅ Required IAM Permissions

```json
{
  "Effect": "Allow",
  "Action": [
    "sqs:GetQueueAttributes",
    "ecs:DescribeServices",
    "ecs:UpdateService"
  ],
  "Resource": "*"
}
```

---

## ✅ Install

```bash
pip install boto3
```

---

## ✅ Python Script (`sqs_ecs_autoscaler.py`)

```python
import boto3

# Config
QUEUE_URL = "https://sqs.ap-south-1.amazonaws.com/123456789012/my-processing-queue"
ECS_CLUSTER = "my-ecs-cluster"
ECS_SERVICE = "worker-service"

MIN_TASKS = 1
MAX_TASKS = 10

SCALE_UP_THRESHOLD = 50
SCALE_DOWN_THRESHOLD = 10
SCALE_STEP = 2  # scale increment/decrement

sqs = boto3.client("sqs")
ecs = boto3.client("ecs")

def get_queue_depth():
    response = sqs.get_queue_attributes(
        QueueUrl=QUEUE_URL,
        AttributeNames=["ApproximateNumberOfMessages"]
    )
    return int(response["Attributes"]["ApproximateNumberOfMessages"])

def get_current_task_count():
    response = ecs.describe_services(
        cluster=ECS_CLUSTER,
        services=[ECS_SERVICE]
    )
    return response["services"][0]["desiredCount"]

def update_task_count(new_count):
    ecs.update_service(
        cluster=ECS_CLUSTER,
        service=ECS_SERVICE,
        desiredCount=new_count
    )
    print(f"Updated ECS desired count to {new_count}")

def main():
    queue_depth = get_queue_depth()
    current_tasks = get_current_task_count()

    print(f"Queue depth: {queue_depth}")
    print(f"Current tasks: {current_tasks}")

    if queue_depth > SCALE_UP_THRESHOLD:
        new_count = min(current_tasks + SCALE_STEP, MAX_TASKS)
        if new_count != current_tasks:
            update_task_count(new_count)

    elif queue_depth < SCALE_DOWN_THRESHOLD:
        new_count = max(current_tasks - SCALE_STEP, MIN_TASKS)
        if new_count != current_tasks:
            update_task_count(new_count)

    else:
        print("No scaling action required.")

if __name__ == "__main__":
    main()
```

---

## 📌 Run

```bash
python3 sqs_ecs_autoscaler.py
```

Or schedule:

```bash
*/2 * * * * python3 /path/sqs_ecs_autoscaler.py
```

---

## 🔎 How Scaling Logic Works

| Condition     | Action                |
| ------------- | --------------------- |
| Queue > 50    | Scale up by 2 tasks   |
| Queue < 10    | Scale down by 2 tasks |
| Between 10–50 | No change             |
| Max cap       | 10 tasks              |
| Min cap       | 1 task                |

---

## 🚀 Production Improvements (Highly Recommended)

### 1️⃣ Use Target Tracking Auto Scaling (Better Approach)

Instead of custom script:

* Enable ECS Service Auto Scaling
* Metric: `SQS ApproximateNumberOfMessagesVisible`
* Target: e.g., 10 messages per task

This is more stable and managed by AWS.

---

### 2️⃣ Add Cooldown Period

Prevent frequent scaling:

```python
COOLDOWN_SECONDS = 300
```

Store last scaling time in:

* DynamoDB
* Parameter Store

---

### 3️⃣ Consider In-flight Messages

Also check:

```
ApproximateNumberOfMessagesNotVisible
```

---

### 4️⃣ Multi-Region Support

Loop across regions if needed.

---

## 🔥 Enterprise Architecture

**Recommended Setup:**

SQS → CloudWatch Metric → Application Auto Scaling → ECS Service

No custom script required.

---

## 💡 Real-World Use Case

* Background job processors
* Video encoding workers
* Batch processing pipelines
* Event-driven microservices

---

If you want, I can provide:

* Terraform for ECS Auto Scaling setup
* Lambda version
* Multi-queue multi-service version
* Cost-optimized scaling formula version

-----
## Q17: Write a Python script that compares two Terraform state files and reports differences in resource configurations.

---

### 🧠 Overview

* Reads two Terraform state files (`.tfstate`)
* Compares:

  * Resources added
  * Resources removed
  * Attribute-level changes
* Outputs structured diff report
* Useful for drift detection / audit

---

## 📌 Assumptions

* Input files:

  * `state_old.tfstate`
  * `state_new.tfstate`
* Terraform state format v4+
* JSON format (standard)

---

## ✅ Python Script (`tfstate_diff.py`)

```python
import json
import sys
from deepdiff import DeepDiff

# Usage:
# python tfstate_diff.py old.tfstate new.tfstate

def load_state(file_path):
    with open(file_path, "r") as f:
        return json.load(f)

def extract_resources(state):
    resources = {}

    for res in state.get("resources", []):
        for instance in res.get("instances", []):
            key = f"{res['type']}.{res['name']}"
            resources[key] = instance.get("attributes", {})

    return resources

def main(old_file, new_file):
    old_state = load_state(old_file)
    new_state = load_state(new_file)

    old_resources = extract_resources(old_state)
    new_resources = extract_resources(new_state)

    print("==== Resources Added ====")
    for r in new_resources.keys() - old_resources.keys():
        print(f"+ {r}")

    print("\n==== Resources Removed ====")
    for r in old_resources.keys() - new_resources.keys():
        print(f"- {r}")

    print("\n==== Modified Resources ====")
    common_resources = old_resources.keys() & new_resources.keys()

    for r in common_resources:
        diff = DeepDiff(old_resources[r], new_resources[r], ignore_order=True)
        if diff:
            print(f"\nChanges in {r}:")
            print(diff)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python tfstate_diff.py old.tfstate new.tfstate")
        sys.exit(1)

    main(sys.argv[1], sys.argv[2])
```

---

## ✅ Install Dependency

```bash
pip install deepdiff
```

---

## 📌 Run

```bash
python3 tfstate_diff.py state_old.tfstate state_new.tfstate
```

---

## 📊 Sample Output

```
==== Resources Added ====
+ aws_s3_bucket.logs

==== Resources Removed ====
- aws_instance.web

==== Modified Resources ====

Changes in aws_instance.app:
{'values_changed': {"root['instance_type']": {'old_value': 't2.micro', 'new_value': 't3.medium'}}}
```

---

## 🔎 What It Detects

| Change Type | Meaning                           |
| ----------- | --------------------------------- |
| Added       | Resource exists only in new state |
| Removed     | Resource removed                  |
| Modified    | Attribute-level change            |

---

## 🚀 Production Improvements

### 1️⃣ Include Resource Address with Index

Improve key:

```python
key = f"{res['type']}.{res['name']}[{instance.get('index_key', 0)}]"
```

---

### 2️⃣ Export to JSON or HTML Report

```python
with open("tfstate_diff_report.json", "w") as f:
    json.dump(diff, f, indent=2)
```

---

### 3️⃣ Compare Remote States (S3 Backend)

Instead of local file:

* Download from S3
* Compare automatically in CI

---

### 4️⃣ Better Alternative (Recommended)

Instead of comparing raw state files:

```bash
terraform plan -detailed-exitcode
```

or

```bash
terraform show -json plan.out
```

Then parse plan output (cleaner and safer).

---

## 🔥 Enterprise Use Cases

* Drift detection automation
* CI/CD state validation
* Security audit before apply
* Pre-merge infrastructure validation

---

## 💡 Real-World Recommendation

| Scenario        | Recommended Method         |
| --------------- | -------------------------- |
| CI/CD           | `terraform plan`           |
| Drift Detection | `terraform refresh` + plan |
| State Audit     | This script                |
| Enterprise      | Terraform Cloud Run Tasks  |

---

If you want, I can provide:

* Version that compares remote S3 backend states
* CI pipeline integration example
* Drift detection automation script
* Terraform plan JSON parser version (better approach)
-----
## Q18: Write a Python script that queries Prometheus metrics API, analyzes trends, and generates a daily performance report in PDF format.

---

### 🧠 Overview

* Queries Prometheus HTTP API (`/api/v1/query_range`)
* Pulls last 24h metrics
* Calculates:

  * Avg
  * Min
  * Max
* Generates charts
* Creates PDF report using `reportlab`
* Production-ready (separate plots, no seaborn)

---

## 📌 Assumptions

| Item           | Example                               |
| -------------- | ------------------------------------- |
| Prometheus URL | `http://prometheus:9090`              |
| Metric         | `node_cpu_seconds_total` (rate-based) |
| Time Range     | Last 24 hours                         |
| Output         | `daily_report.pdf`                    |

---

## ✅ Install Dependencies

```bash
pip install requests matplotlib reportlab
```

---

## ✅ Python Script (`prometheus_daily_report.py`)

```python
import requests
import datetime
import matplotlib.pyplot as plt
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Image
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib import colors
from reportlab.lib.units import inch
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import Table
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import TableStyle

PROM_URL = "http://prometheus:9090"
METRIC = 'rate(node_cpu_seconds_total{mode!="idle"}[5m])'
OUTPUT_PDF = "daily_performance_report.pdf"

def query_prometheus():
    end = datetime.datetime.utcnow()
    start = end - datetime.timedelta(days=1)

    params = {
        "query": METRIC,
        "start": start.timestamp(),
        "end": end.timestamp(),
        "step": 300
    }

    response = requests.get(f"{PROM_URL}/api/v1/query_range", params=params)
    return response.json()

def process_data(data):
    values = []
    timestamps = []

    for result in data["data"]["result"]:
        for point in result["values"]:
            timestamps.append(datetime.datetime.fromtimestamp(float(point[0])))
            values.append(float(point[1]))

    return timestamps, values

def generate_plot(timestamps, values):
    plt.figure()
    plt.plot(timestamps, values)
    plt.title("CPU Usage Trend (Last 24h)")
    plt.xlabel("Time")
    plt.ylabel("CPU Usage")
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig("cpu_trend.png")
    plt.close()

def generate_pdf(avg, minimum, maximum):
    doc = SimpleDocTemplate(OUTPUT_PDF)
    elements = []
    styles = getSampleStyleSheet()

    elements.append(Paragraph("Daily Performance Report", styles["Heading1"]))
    elements.append(Spacer(1, 0.3 * inch))

    data = [
        ["Metric", "Value"],
        ["Average CPU Usage", f"{avg:.4f}"],
        ["Minimum CPU Usage", f"{minimum:.4f}"],
        ["Maximum CPU Usage", f"{maximum:.4f}"]
    ]

    table = Table(data)
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), colors.grey),
        ("GRID", (0, 0), (-1, -1), 1, colors.black)
    ]))

    elements.append(table)
    elements.append(Spacer(1, 0.5 * inch))

    elements.append(Image("cpu_trend.png", width=6*inch, height=3*inch))

    doc.build(elements)

def main():
    data = query_prometheus()
    timestamps, values = process_data(data)

    if not values:
        print("No data returned from Prometheus.")
        return

    avg = sum(values) / len(values)
    minimum = min(values)
    maximum = max(values)

    generate_plot(timestamps, values)
    generate_pdf(avg, minimum, maximum)

    print(f"Report generated: {OUTPUT_PDF}")

if __name__ == "__main__":
    main()
```

---

## 📌 Run

```bash
python3 prometheus_daily_report.py
```

---

## 📊 What the Report Contains

* CPU usage trend graph
* Average usage (24h)
* Minimum usage
* Maximum usage
* PDF output

---

## 🚀 Production Improvements

### 1️⃣ Multiple Metrics

Add:

* Memory usage
* Disk usage
* HTTP request rate
* Pod restart count

Generate separate plot per metric.

---

### 2️⃣ Authentication Support

If Prometheus requires auth:

```python
requests.get(..., auth=("user","pass"))
```

or Bearer token header.

---

### 3️⃣ Run as Cron (Daily 1 AM)

```bash
0 1 * * * python3 /path/prometheus_daily_report.py
```

---

### 4️⃣ Upload PDF to S3

```python
import boto3
s3.upload_file(OUTPUT_PDF, "reports-bucket", OUTPUT_PDF)
```

---

## 🔥 Enterprise Alternative

Instead of custom PDF:

* Grafana Scheduled Reports
* Prometheus Alertmanager
* Loki + Grafana dashboards
* Thanos for long-term trends

---

## 💡 Real-World Use Case

* Daily management report
* SLA validation
* Capacity planning
* Performance baseline tracking

---

If you want, I can provide:

* Multi-metric PDF version
* HTML report version
* EKS-specific metrics version
* Fully production-hardened version with error handling and retries

----
## Q19: Write a Python script that automates the rotation of IAM access keys older than 90 days and notifies the key owner via email.

---

### 🧠 Overview

* Lists IAM users
* Checks access keys older than 90 days
* Creates new access key
* Deactivates old key
* Emails user (based on IAM tag: `Email`)
* Safe rotation flow (create → notify → disable)

---

## ⚠️ Assumptions

| Item            | Requirement              |
| --------------- | ------------------------ |
| IAM User Tag    | `Email=user@example.com` |
| Rotation Policy | > 90 days                |
| Email Service   | AWS SES                  |
| Region          | `ap-south-1` (example)   |

---

## ✅ Required IAM Permissions

```json
{
  "Effect": "Allow",
  "Action": [
    "iam:ListUsers",
    "iam:ListAccessKeys",
    "iam:CreateAccessKey",
    "iam:UpdateAccessKey",
    "iam:GetUser",
    "iam:ListUserTags",
    "ses:SendEmail"
  ],
  "Resource": "*"
}
```

---

## ✅ Install

```bash
pip install boto3
```

---

## ✅ Python Script (`iam_key_rotation.py`)

```python
import boto3
from datetime import datetime, timezone
import os

# Config
MAX_AGE_DAYS = 90
SES_REGION = "ap-south-1"
SENDER_EMAIL = "admin@example.com"

iam = boto3.client("iam")
ses = boto3.client("ses", region_name=SES_REGION)

def send_email(to_email, subject, body):
    ses.send_email(
        Source=SENDER_EMAIL,
        Destination={"ToAddresses": [to_email]},
        Message={
            "Subject": {"Data": subject},
            "Body": {"Text": {"Data": body}}
        }
    )

def get_user_email(username):
    tags = iam.list_user_tags(UserName=username)["Tags"]
    for tag in tags:
        if tag["Key"] == "Email":
            return tag["Value"]
    return None

def rotate_key(username, access_key_id):
    print(f"Rotating key for user: {username}")

    # Create new key
    new_key = iam.create_access_key(UserName=username)["AccessKey"]

    # Disable old key
    iam.update_access_key(
        UserName=username,
        AccessKeyId=access_key_id,
        Status="Inactive"
    )

    return new_key

def main():
    users = iam.list_users()["Users"]

    for user in users:
        username = user["UserName"]
        keys = iam.list_access_keys(UserName=username)["AccessKeyMetadata"]

        for key in keys:
            create_date = key["CreateDate"]
            age_days = (datetime.now(timezone.utc) - create_date).days

            if age_days > MAX_AGE_DAYS:
                email = get_user_email(username)
                if not email:
                    print(f"No email tag found for {username}")
                    continue

                new_key = rotate_key(username, key["AccessKeyId"])

                message = f"""
Hello {username},

Your IAM access key older than {MAX_AGE_DAYS} days has been rotated.

New Access Key ID: {new_key['AccessKeyId']}
Secret Access Key: {new_key['SecretAccessKey']}

Please update your applications immediately.
The old key has been disabled.

Regards,
Cloud Security Team
"""

                send_email(email, "IAM Access Key Rotated", message)
                print(f"Email sent to {email}")

if __name__ == "__main__":
    main()
```

---

## 📌 Run

```bash
python3 iam_key_rotation.py
```

---

## 🔎 How It Works

| Step            | Action                |
| --------------- | --------------------- |
| List users      | `iam.list_users()`    |
| Check key age   | Compare creation date |
| Create new key  | `create_access_key()` |
| Disable old key | `update_access_key()` |
| Notify user     | SES email             |

---

## 🚀 Production Improvements (Highly Recommended)

### 1️⃣ Safer Rotation Flow

Better process:

1. Create new key
2. Email user
3. Wait 7 days
4. Disable old key
5. Delete old key after confirmation

---

### 2️⃣ Handle IAM 2-Key Limit

IAM allows max 2 keys per user.
If already 2 keys:

* Disable oldest first
* Then create new

---

### 3️⃣ Store Secrets Securely

Instead of emailing secret:

* Store in AWS Secrets Manager
* Send link only

---

### 4️⃣ Multi-Account Setup

* Use Organizations
* AssumeRole into child accounts

---

### 5️⃣ Deploy as Lambda + EventBridge (Monthly)

```
cron(0 1 1 * ? *)
```

---

## 🔥 Enterprise Best Practice

Better than rotating keys:

* Eliminate IAM users
* Use:

  * IAM Roles
  * IRSA (EKS)
  * EC2 Instance Profiles
  * OIDC for CI/CD
  * STS temporary credentials

---

## 💡 Real-World Use Case

* CIS compliance
* SOC2 audit requirement
* IAM hygiene automation
* Security governance enforcement

---

If you want, I can provide:

* Lambda-ready version
* Multi-account AssumeRole version
* Version using Secrets Manager
* Terraform to deploy full automation
* Enterprise-grade safe-rotation workflow

----
## Q20: Write a Python script that implements a deployment orchestrator which deploys to multiple environments sequentially, runs smoke tests, and rolls back if tests fail.

---

### 🧠 Overview

* Deploys sequentially: `dev → staging → prod`
* Runs smoke tests after each deployment
* Stops pipeline on failure
* Automatically triggers rollback
* Designed for CI/CD or manual execution

---

## 📌 Assumptions

| Item             | Example                            |
| ---------------- | ---------------------------------- |
| Environments     | dev, staging, prod                 |
| Deploy Command   | `./deploy.sh <env>`                |
| Rollback Command | `./rollback.sh <env>`              |
| Smoke Test       | HTTP health check                  |
| Health URL       | `https://<env>.example.com/health` |

---

## ✅ Python Script (`deployment_orchestrator.py`)

```python
import subprocess
import requests
import time
import sys

ENVIRONMENTS = ["dev", "staging", "prod"]
HEALTH_TEMPLATE = "https://{}.example.com/health"

SMOKE_RETRIES = 5
SMOKE_DELAY = 5


def run_command(command):
    print(f"Running: {command}")
    result = subprocess.run(command, shell=True)
    return result.returncode == 0


def smoke_test(env):
    url = HEALTH_TEMPLATE.format(env)

    for attempt in range(1, SMOKE_RETRIES + 1):
        try:
            response = requests.get(url, timeout=5)
            if response.status_code == 200:
                print(f"[{env}] Smoke test passed")
                return True
        except Exception:
            pass

        print(f"[{env}] Smoke test attempt {attempt} failed")
        time.sleep(SMOKE_DELAY)

    return False


def deploy(env):
    return run_command(f"./deploy.sh {env}")


def rollback(env):
    print(f"[{env}] Initiating rollback...")
    run_command(f"./rollback.sh {env}")


def main():
    for env in ENVIRONMENTS:
        print(f"\n===== Deploying to {env.upper()} =====")

        if not deploy(env):
            print(f"[{env}] Deployment failed")
            sys.exit(1)

        if not smoke_test(env):
            print(f"[{env}] Smoke test failed. Rolling back.")
            rollback(env)
            sys.exit(1)

        print(f"[{env}] Deployment successful")

    print("\nAll environments deployed successfully.")


if __name__ == "__main__":
    main()
```

---

## 📌 Run

```bash
pip install requests
python3 deployment_orchestrator.py
```

---

## 🔎 Execution Flow

```
dev
  ↓
smoke test
  ↓
staging
  ↓
smoke test
  ↓
prod
  ↓
smoke test
```

If any step fails:

```
rollback → exit
```

---

## 🚀 Production Improvements

### 1️⃣ Store Previous Version

Pass version number:

```bash
./deploy.sh staging v2.1.3
```

Store previous version for rollback.

---

### 2️⃣ Parallel Canary for Prod

Instead of direct prod:

* Deploy to `prod-canary`
* Run tests
* Shift traffic gradually

---

### 3️⃣ Add Slack Notification

```python
def notify(msg):
    requests.post(SLACK_WEBHOOK, json={"text": msg})
```

---

### 4️⃣ Use Structured Logging

Replace prints with `logging` module.

---

### 5️⃣ Integrate with Kubernetes

Instead of shell scripts:

```bash
kubectl apply -f deployment.yaml
kubectl rollout status deployment/myapp
```

Rollback:

```bash
kubectl rollout undo deployment/myapp
```

---

## 🔥 Enterprise Architecture Mapping

| Setup      | Recommended Approach              |
| ---------- | --------------------------------- |
| Bare VM    | This script                       |
| ECS        | Blue/Green with CodeDeploy        |
| EKS        | Rolling update + readiness probes |
| Enterprise | ArgoCD / Spinnaker                |

---

## 💡 Real-World Use Case

* Multi-environment release pipeline
* Controlled production rollout
* Automated release gating
* CI/CD stage orchestration

---

If you want, I can provide:

* Kubernetes-native orchestrator version
* Blue/Green deployment orchestrator
* Canary deployment version
* GitLab CI pipeline YAML equivalent
* Fully production-hardened version with version tracking

-----
## Q21: Jenkins Pipeline (Jenkinsfile) — Build → Test → Trivy Scan → Push to ECR → Deploy to EKS

---

### 🧠 Overview

Pipeline Flow:

```
Checkout
   ↓
Build Docker Image
   ↓
Run Unit Tests (inside container)
   ↓
Trivy Image Scan
   ↓
Push to ECR
   ↓
Deploy to EKS
```

Deployment happens **only if all previous stages succeed**.

---

## 📌 Assumptions

| Item            | Example                                               |
| --------------- | ----------------------------------------------------- |
| ECR Repo        | `123456789012.dkr.ecr.ap-south-1.amazonaws.com/myapp` |
| EKS Cluster     | `my-eks-cluster`                                      |
| Namespace       | `default`                                             |
| Deployment Name | `myapp`                                               |
| AWS Region      | `ap-south-1`                                          |
| Jenkins Agent   | Docker + AWS CLI + kubectl + Trivy installed          |

---

## ✅ Jenkinsfile (Declarative Pipeline)

```groovy
pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        ECR_REPO = "123456789012.dkr.ecr.ap-south-1.amazonaws.com/myapp"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        CLUSTER_NAME = "my-eks-cluster"
        NAMESPACE = "default"
        DEPLOYMENT = "myapp"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t myapp:${IMAGE_TAG} .
                """
            }
        }

        stage('Run Unit Tests Inside Container') {
            steps {
                sh """
                    docker run --rm myapp:${IMAGE_TAG} pytest
                """
            }
        }

        stage('Trivy Vulnerability Scan') {
            steps {
                sh """
                    trivy image --exit-code 1 --severity HIGH,CRITICAL myapp:${IMAGE_TAG}
                """
            }
        }

        stage('Login to ECR') {
            steps {
                sh """
                    aws ecr get-login-password --region ${AWS_REGION} \
                    | docker login --username AWS --password-stdin ${ECR_REPO}
                """
            }
        }

        stage('Push to ECR') {
            steps {
                sh """
                    docker tag myapp:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
                    docker push ${ECR_REPO}:${IMAGE_TAG}
                """
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh """
                    aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}

                    kubectl set image deployment/${DEPLOYMENT} \
                    ${DEPLOYMENT}=${ECR_REPO}:${IMAGE_TAG} \
                    -n ${NAMESPACE}

                    kubectl rollout status deployment/${DEPLOYMENT} -n ${NAMESPACE}
                """
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed. Deployment aborted."
        }
        success {
            echo "Deployment successful!"
        }
    }
}
```

---

## 🔎 Key Controls

| Control                  | Purpose                                    |
| ------------------------ | ------------------------------------------ |
| `--exit-code 1` (Trivy)  | Fail pipeline if HIGH/CRITICAL vulns found |
| `docker run pytest`      | Ensures app tests pass before push         |
| `kubectl rollout status` | Waits until deployment is stable           |
| Declarative pipeline     | Stops automatically on failure             |

---

## 🚀 Production-Grade Enhancements

### 1️⃣ Use Jenkins Credentials Store

Instead of plain AWS access:

```groovy
withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
   ...
}
```

---

### 2️⃣ Use ECR Lifecycle Policy

Auto-clean old images.

---

### 3️⃣ Add Image Digest Deployment (Safer)

```bash
DIGEST=$(docker inspect --format='{{index .RepoDigests 0}}' ${ECR_REPO}:${IMAGE_TAG})
kubectl set image deployment/myapp myapp=$DIGEST
```

---

### 4️⃣ Add Helm Deployment (Recommended)

Replace `kubectl set image` with:

```bash
helm upgrade --install myapp ./helm \
  --set image.tag=${IMAGE_TAG}
```

---

### 5️⃣ Add Approval Gate Before Prod

```groovy
input message: "Approve production deployment?"
```

---

## 🔥 Enterprise Recommended Architecture

| Layer    | Best Practice                   |
| -------- | ------------------------------- |
| Build    | Use Docker-in-Docker agent      |
| Scan     | Trivy + Dependency Check        |
| Registry | ECR with immutable tags         |
| Deploy   | Helm + GitOps (ArgoCD)          |
| Security | OIDC instead of static AWS keys |

---

## 💡 Real-World Interview Summary (2–3 lines)

> This pipeline builds the Docker image, runs unit tests inside the container, performs a Trivy vulnerability scan, pushes the image to ECR, and deploys to EKS only if all stages pass. It ensures security, quality, and controlled rollout using `kubectl rollout status`.

---

If you want, I can provide:

* GitHub Actions equivalent
* GitLab CI version
* Helm-based deployment pipeline
* Blue/Green deployment Jenkinsfile
* Production-ready Jenkins shared library version
----
## Q22: GitHub Actions Workflow — PR Trigger → Parallel Lint & Tests → Coverage Check → PR Comment

---

### 🧠 Overview

* Trigger: Pull Requests
* Runs **lint** and **tests** in parallel
* Fails if coverage < threshold (e.g., 80%)
* Posts results as a PR comment
* Designed for production CI

---

## 📌 Assumptions

| Item          | Example                                                |
| ------------- | ------------------------------------------------------ |
| Language      | Python (pytest + coverage)                             |
| Linter        | flake8                                                 |
| Coverage Tool | pytest-cov                                             |
| Threshold     | 80%                                                    |
| Repo          | Public or PR from same repo (token permissions needed) |

---

## ✅ `.github/workflows/pr-ci.yml`

```yaml
name: PR CI Pipeline

on:
  pull_request:
    branches:
      - main
      - develop

permissions:
  contents: read
  pull-requests: write

jobs:

  lint:
    name: Lint Code
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install Dependencies
        run: |
          pip install flake8

      - name: Run Linter
        run: |
          flake8 .

  test:
    name: Run Tests + Coverage
    runs-on: ubuntu-latest

    outputs:
      coverage: ${{ steps.coverage.outputs.coverage }}

    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install Dependencies
        run: |
          pip install -r requirements.txt
          pip install pytest pytest-cov

      - name: Run Tests with Coverage
        run: |
          pytest --cov=. --cov-report=term --cov-report=xml

      - name: Extract Coverage
        id: coverage
        run: |
          COVERAGE=$(grep -oP 'line-rate="\K[^"]+' coverage.xml | head -1)
          PERCENT=$(awk "BEGIN {print int($COVERAGE * 100)}")
          echo "coverage=$PERCENT" >> $GITHUB_OUTPUT

      - name: Check Coverage Threshold
        run: |
          if [ "${{ steps.coverage.outputs.coverage }}" -lt 80 ]; then
            echo "Coverage below threshold!"
            exit 1
          fi

  comment:
    name: Comment PR Results
    runs-on: ubuntu-latest
    needs: [lint, test]

    steps:
      - name: Post PR Comment
        uses: actions/github-script@v7
        with:
          script: |
            const lintStatus = "${{ needs.lint.result }}";
            const testStatus = "${{ needs.test.result }}";
            const coverage = "${{ needs.test.outputs.coverage }}";

            const message = `
            ## CI Results

            ✅ Lint: ${lintStatus}
            ✅ Tests: ${testStatus}
            📊 Coverage: ${coverage}%

            Threshold: 80%
            `;

            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: message
            });
```

---

## 🔎 What This Workflow Does

| Job            | Purpose                |
| -------------- | ---------------------- |
| lint           | Runs flake8            |
| test           | Runs pytest + coverage |
| coverage check | Fails if < 80%         |
| comment        | Posts results in PR    |

---

## 🚀 Execution Flow

```
Pull Request
     ↓
Lint  ─┐
       ├──> PR Comment
Tests ─┘
```

Jobs `lint` and `test` run in parallel automatically.

---

## 📌 Sample PR Comment

```
CI Results

Lint: success
Tests: success
Coverage: 84%

Threshold: 80%
```

---

## 🚀 Production Improvements

### 1️⃣ Cache Dependencies

```yaml
- uses: actions/cache@v4
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
```

---

### 2️⃣ Upload Coverage Report Artifact

```yaml
- uses: actions/upload-artifact@v4
  with:
    name: coverage-report
    path: coverage.xml
```

---

### 3️⃣ Prevent Direct Merge if Fails

Enable branch protection:

* Require status checks
* Require PR review

---

### 4️⃣ Multi-language Version

* Node.js → ESLint + Jest
* Java → Maven + JaCoCo
* Go → golangci-lint + go test

---

## 🔥 Enterprise Best Practices

| Feature         | Recommended    |
| --------------- | -------------- |
| Coverage gate   | Required       |
| Lint gate       | Required       |
| Secret scanning | Add CodeQL     |
| Docker scan     | Add Trivy      |
| PR labeling     | Add automation |

---

## 💡 Interview Summary (2–3 lines)

> This workflow triggers on pull requests, runs linting and tests in parallel, enforces a coverage threshold, and posts results as a PR comment. It ensures code quality before merge using GitHub branch protection rules.

---

If you want, I can provide:

* Node.js version
* Java/Maven version
* Docker build + scan version
* Enterprise reusable workflow template
* Monorepo optimized version

----
## Q23: GitLab CI Pipeline — Multi-Environment Deployment (Dev → Staging → Prod)

* Sequential promotion
* Prod requires **manual approval**
* Automatic rollback on failure
* Safe for Kubernetes/ECS-style deployments

---

## 🧠 Deployment Flow

```
Build
  ↓
Deploy Dev
  ↓
Deploy Staging
  ↓
Manual Approval (Prod)
  ↓
Deploy Prod
  ↓
Auto Rollback if Failed
```

---

## 📌 Assumptions

| Item               | Example                                          |
| ------------------ | ------------------------------------------------ |
| Image Registry     | GitLab Registry                                  |
| Kubernetes Cluster | Already configured via GitLab Agent / kubeconfig |
| Deployment Name    | myapp                                            |
| Namespace          | per-environment                                  |
| Helm Used          | Yes (recommended)                                |

---

## ✅ `.gitlab-ci.yml`

```yaml
stages:
  - build
  - deploy_dev
  - deploy_staging
  - deploy_prod

variables:
  IMAGE_TAG: $CI_COMMIT_SHORT_SHA
  APP_NAME: myapp

# -------------------
# BUILD STAGE
# -------------------
build:
  stage: build
  image: docker:24
  services:
    - docker:24-dind
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $CI_REGISTRY_IMAGE:$IMAGE_TAG .
    - docker push $CI_REGISTRY_IMAGE:$IMAGE_TAG
  only:
    - main

# -------------------
# DEPLOY TEMPLATE
# -------------------
.deploy_template:
  image: alpine/helm:3.13.0
  before_script:
    - helm version
  script:
    - helm upgrade --install $APP_NAME ./helm \
        --set image.repository=$CI_REGISTRY_IMAGE \
        --set image.tag=$IMAGE_TAG \
        --namespace $KUBE_NAMESPACE \
        --create-namespace
    - kubectl rollout status deployment/$APP_NAME -n $KUBE_NAMESPACE
  allow_failure: false

# -------------------
# DEV DEPLOYMENT
# -------------------
deploy_dev:
  stage: deploy_dev
  extends: .deploy_template
  variables:
    KUBE_NAMESPACE: dev
  environment:
    name: dev
  only:
    - main

# -------------------
# STAGING DEPLOYMENT
# -------------------
deploy_staging:
  stage: deploy_staging
  extends: .deploy_template
  variables:
    KUBE_NAMESPACE: staging
  environment:
    name: staging
  only:
    - main
  needs:
    - deploy_dev

# -------------------
# PROD DEPLOYMENT (MANUAL)
# -------------------
deploy_prod:
  stage: deploy_prod
  extends: .deploy_template
  variables:
    KUBE_NAMESPACE: prod
  environment:
    name: prod
  only:
    - main
  needs:
    - deploy_staging
  when: manual
  allow_failure: false
  after_script:
    - |
      if [ "$CI_JOB_STATUS" != "success" ]; then
        echo "Deployment failed. Rolling back..."
        helm rollback $APP_NAME -n prod
      fi
```

---

## 🔎 Key Features

| Feature              | Implementation                   |
| -------------------- | -------------------------------- |
| Sequential promotion | `needs:`                         |
| Manual approval      | `when: manual`                   |
| Rollback on failure  | `after_script` + `helm rollback` |
| Environment tracking | `environment:` keyword           |
| Deployment safety    | `kubectl rollout status`         |

---

## 🚀 Automatic Rollback Logic

If:

* Helm upgrade fails
* Pod crashes
* Rollout timeout

Then:

```bash
helm rollback myapp -n prod
```

This reverts to the previous release revision.

---

## 🔥 Production Improvements

### 1️⃣ Add Rollout Timeout

```bash
kubectl rollout status deployment/$APP_NAME -n prod --timeout=120s
```

---

### 2️⃣ Blue/Green Instead of Direct Upgrade

Use:

```bash
helm upgrade --install --set strategy=blueGreen
```

---

### 3️⃣ Add Trivy Scan Before Deploy

Add stage before deploy:

```yaml
trivy:
  stage: build
  script:
    - trivy image --exit-code 1 $CI_REGISTRY_IMAGE:$IMAGE_TAG
```

---

### 4️⃣ Protect Production Environment

In GitLab:

* Protect `prod` environment
* Allow only Maintainers to approve

---

## 🔥 Enterprise Architecture

| Layer    | Best Practice                   |
| -------- | ------------------------------- |
| Dev      | Auto deploy                     |
| Staging  | Auto deploy + integration tests |
| Prod     | Manual gate + approval          |
| Rollback | Helm revision-based             |
| Security | OIDC for cluster access         |

---

## 💡 Interview Summary (2–3 lines)

> This GitLab CI pipeline builds the image, deploys sequentially to dev and staging, requires manual approval for prod, and performs automatic rollback using Helm if the production deployment fails.

---

If you want, I can provide:

* ECS version (CodeDeploy Blue/Green)
* ArgoCD GitOps version
* Canary deployment version
* Terraform-integrated pipeline
* Enterprise hardened template with approvals + change management

----

## Q24: Jenkinsfile — Blue/Green Deployment with Health Check & 24h Rollback Window

---

### 🧠 Strategy

* Two environments: **blue** (current) and **green** (new)
* Deploy new version to idle environment
* Run health checks
* Switch traffic (ALB / Ingress update)
* Keep previous version for 24 hours
* Rollback possible during 24h window

---

## 📌 Assumptions

| Item             | Example                                               |
| ---------------- | ----------------------------------------------------- |
| ECR Repo         | `123456789012.dkr.ecr.ap-south-1.amazonaws.com/myapp` |
| EKS Namespace    | prod                                                  |
| Deployment Names | myapp-blue, myapp-green                               |
| Service          | myapp-service                                         |
| ALB              | Managed via Kubernetes Service                        |
| Health Endpoint  | `/health`                                             |

---

## ✅ Jenkinsfile (Blue-Green)

```groovy
pipeline {
    agent any

    environment {
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        ECR_REPO = "123456789012.dkr.ecr.ap-south-1.amazonaws.com/myapp"
        NAMESPACE = "prod"
        APP_NAME = "myapp"
    }

    stages {

        stage('Determine Active Color') {
            steps {
                script {
                    def active = sh(
                        script: "kubectl get svc ${APP_NAME}-service -n ${NAMESPACE} -o jsonpath='{.spec.selector.color}'",
                        returnStdout: true
                    ).trim()

                    env.ACTIVE_COLOR = active ?: "blue"
                    env.NEW_COLOR = (env.ACTIVE_COLOR == "blue") ? "green" : "blue"

                    echo "Active: ${env.ACTIVE_COLOR}"
                    echo "Deploying to: ${env.NEW_COLOR}"
                }
            }
        }

        stage('Deploy New Version') {
            steps {
                sh """
                    kubectl set image deployment/${APP_NAME}-${NEW_COLOR} \
                    ${APP_NAME}=${ECR_REPO}:${IMAGE_TAG} \
                    -n ${NAMESPACE}

                    kubectl rollout status deployment/${APP_NAME}-${NEW_COLOR} -n ${NAMESPACE}
                """
            }
        }

        stage('Health Check') {
            steps {
                script {
                    retry(5) {
                        sleep 10
                        sh """
                            kubectl run tmp-curl --rm -i --restart=Never \
                            --image=curlimages/curl \
                            -- curl -f http://${APP_NAME}-${NEW_COLOR}.${NAMESPACE}.svc.cluster.local/health
                        """
                    }
                }
            }
        }

        stage('Switch Traffic') {
            steps {
                sh """
                    kubectl patch svc ${APP_NAME}-service \
                    -n ${NAMESPACE} \
                    -p '{"spec":{"selector":{"app":"${APP_NAME}","color":"${NEW_COLOR}"}}}'
                """
            }
        }

        stage('Mark Deployment Timestamp') {
            steps {
                sh """
                    kubectl annotate deployment ${APP_NAME}-${ACTIVE_COLOR} \
                    rollback-expiry=$(date -d '+24 hours' +%s) \
                    -n ${NAMESPACE} --overwrite
                """
            }
        }
    }

    post {
        failure {
            echo "Deployment failed before traffic switch. No impact."
        }
        success {
            echo "Blue-Green deployment successful."
        }
    }
}
```

---

## 🔁 Manual Rollback Script (Valid for 24h)

```bash
ACTIVE=$(kubectl get svc myapp-service -n prod -o jsonpath='{.spec.selector.color}')

PREVIOUS=$( [ "$ACTIVE" == "blue" ] && echo "green" || echo "blue" )

kubectl patch svc myapp-service -n prod \
  -p '{"spec":{"selector":{"app":"myapp","color":"'"$PREVIOUS"'"}}}'
```

Optional safety check:

```bash
EXPIRY=$(kubectl get deployment myapp-$PREVIOUS -n prod \
  -o jsonpath='{.metadata.annotations.rollback-expiry}')

CURRENT=$(date +%s)

if [ "$CURRENT" -gt "$EXPIRY" ]; then
  echo "Rollback window expired"
  exit 1
fi
```

---

## 🔎 Key Controls

| Control                    | Purpose                    |
| -------------------------- | -------------------------- |
| Deploy to inactive color   | Zero downtime              |
| Health check before switch | Safe promotion             |
| Service selector patch     | Traffic switch             |
| 24h annotation             | Controlled rollback window |
| No deletion                | Previous version retained  |

---

## 🚀 Production Improvements

### 1️⃣ Use ALB Weighted Target Groups

Gradual traffic shift (Canary-like).

### 2️⃣ Add Automatic Old Deployment Cleanup After 24h

```bash
kubectl delete deployment myapp-$OLD_COLOR
```

### 3️⃣ Add Slack Notification

### 4️⃣ Add Trivy Scan Before Deploy

---

## 🔥 Enterprise Mapping

| Setup      | Recommended Tool                |
| ---------- | ------------------------------- |
| EKS        | Blue/Green via Service selector |
| ECS        | CodeDeploy Blue/Green           |
| Advanced   | Argo Rollouts                   |
| Enterprise | Istio traffic shifting          |

---

## 💡 Interview Summary (2–3 lines)

> This Jenkins pipeline performs blue-green deployment by deploying to the inactive environment, validating health, then switching traffic via Kubernetes service selector. It keeps the previous version available for 24 hours to allow controlled rollback.

---

# Q25## Terraform Plan Validation Script (Fail on Critical Resource Deletions)

### 🧠 Objective

* Parse `terraform plan` output (JSON)
* Detect resources marked for **delete**
* Fail pipeline if critical resources are being destroyed
* Designed for CI/CD (GitHub, GitLab, Jenkins)

---

## ✅ Recommended CI Flow

Always generate JSON plan:

```bash
terraform init
terraform plan -out=tfplan.binary
terraform show -json tfplan.binary > tfplan.json
```

---

## ✅ Bash Script (`validate_tf_plan.sh`)

```bash
#!/bin/bash

PLAN_FILE="tfplan.json"

# Define critical resource types (extend as needed)
CRITICAL_RESOURCES=(
  "aws_db_instance"
  "aws_rds_cluster"
  "aws_s3_bucket"
  "aws_eks_cluster"
  "aws_lb"
)

if [ ! -f "$PLAN_FILE" ]; then
  echo "Terraform plan JSON file not found!"
  exit 1
fi

echo "Validating Terraform plan..."

DELETIONS=$(jq -r '
  .resource_changes[]
  | select(.change.actions | index("delete"))
  | "\(.type).\(.name)"
' "$PLAN_FILE")

if [ -z "$DELETIONS" ]; then
  echo "No resource deletions detected."
  exit 0
fi

echo "Resources marked for deletion:"
echo "$DELETIONS"

FAIL=0

for resource in $DELETIONS; do
  for critical in "${CRITICAL_RESOURCES[@]}"; do
    if [[ "$resource" == "$critical"* ]]; then
      echo "CRITICAL resource deletion detected: $resource"
      FAIL=1
    fi
  done
done

if [ "$FAIL" -eq 1 ]; then
  echo "Pipeline failed due to critical resource deletion."
  exit 1
fi

echo "No critical resource deletions found."
exit 0
```

---

## 📌 Usage in CI

### Jenkins

```groovy
sh """
terraform plan -out=tfplan.binary
terraform show -json tfplan.binary > tfplan.json
./validate_tf_plan.sh
"""
```

---

### GitHub Actions

```yaml
- name: Terraform Plan
  run: |
    terraform plan -out=tfplan.binary
    terraform show -json tfplan.binary > tfplan.json

- name: Validate Plan
  run: bash validate_tf_plan.sh
```

---

## 🔎 What It Detects

| Action                  | Behavior                                |
| ----------------------- | --------------------------------------- |
| create                  | Allowed                                 |
| update                  | Allowed                                 |
| delete                  | Checked                                 |
| replace (create+delete) | Treated as delete (blocked if critical) |

---

## 🚀 Production-Grade Improvements

### 1️⃣ Match by Resource Address (Safer)

Instead of only type:

```bash
| "\(.address)"
```

Then define critical resources by full address:

```bash
CRITICAL_RESOURCES=(
  "aws_db_instance.prod_db"
  "module.network.aws_vpc.main"
)
```

---

### 2️⃣ Block Replace Actions Too

```bash
select(.change.actions | contains(["delete"]))
```

---

### 3️⃣ Fail If More Than X Resources Deleted

```bash
COUNT=$(echo "$DELETIONS" | wc -l)
if [ "$COUNT" -gt 5 ]; then exit 1; fi
```

---

### 4️⃣ Better Enterprise Alternative

Instead of custom script:

* Sentinel (Terraform Cloud)
* OPA / Conftest
* Checkov policy
* Atlantis policy checks

---

## 🔥 Real-World Use Case

* Prevent accidental DB deletion
* Protect EKS clusters
* Block S3 bucket destruction
* Governance guardrail in CI/CD

---

## 💡 Interview Summary (2–3 lines)

> This script parses the Terraform JSON plan output, detects delete actions, and fails the pipeline if critical infrastructure resources are marked for destruction. It acts as a CI safety guard to prevent accidental infrastructure loss.

---

If you want, I can provide:

* OPA policy version
* Sentinel policy example
* GitLab policy enforcement version
* Version that comments on PR instead of failing immediately

---

## Q26: Python Script (boto3) — Create VPC with Public/Private Subnets, NAT Gateway & Security Groups from YAML

---

### 🧠 Overview

* Reads infrastructure config from YAML
* Creates:

  * VPC
  * Public + Private Subnets (multi-AZ)
  * Internet Gateway
  * NAT Gateway
  * Route Tables
  * Security Groups
* Idempotent-friendly structure
* Suitable for CI/CD provisioning

> ⚠️ In production, prefer Terraform or CDK. This is imperative provisioning.

---

## 📄 Example `vpc_config.yaml`

```yaml
region: ap-south-1
vpc:
  cidr: 10.0.0.0/16
  name: my-vpc

subnets:
  public:
    - cidr: 10.0.1.0/24
      az: ap-south-1a
    - cidr: 10.0.2.0/24
      az: ap-south-1b
  private:
    - cidr: 10.0.11.0/24
      az: ap-south-1a
    - cidr: 10.0.12.0/24
      az: ap-south-1b

security_groups:
  - name: web-sg
    description: Allow HTTP/HTTPS
    ingress:
      - protocol: tcp
        from_port: 80
        to_port: 80
        cidr: 0.0.0.0/0
      - protocol: tcp
        from_port: 443
        to_port: 443
        cidr: 0.0.0.0/0
```

---

## ✅ Install Dependencies

```bash
pip install boto3 pyyaml
```

---

## ✅ Python Script (`create_vpc_from_yaml.py`)

```python
import boto3
import yaml
import time

CONFIG_FILE = "vpc_config.yaml"

with open(CONFIG_FILE) as f:
    config = yaml.safe_load(f)

region = config["region"]
ec2 = boto3.client("ec2", region_name=region)

# --------------------
# Create VPC
# --------------------
vpc = ec2.create_vpc(CidrBlock=config["vpc"]["cidr"])
vpc_id = vpc["Vpc"]["VpcId"]

ec2.create_tags(Resources=[vpc_id],
                Tags=[{"Key": "Name", "Value": config["vpc"]["name"]}])

ec2.modify_vpc_attribute(VpcId=vpc_id, EnableDnsSupport={"Value": True})
ec2.modify_vpc_attribute(VpcId=vpc_id, EnableDnsHostnames={"Value": True})

print(f"Created VPC: {vpc_id}")

# --------------------
# Internet Gateway
# --------------------
igw = ec2.create_internet_gateway()
igw_id = igw["InternetGateway"]["InternetGatewayId"]
ec2.attach_internet_gateway(VpcId=vpc_id, InternetGatewayId=igw_id)

print(f"Attached IGW: {igw_id}")

# --------------------
# Public Subnets
# --------------------
public_subnet_ids = []

for subnet in config["subnets"]["public"]:
    s = ec2.create_subnet(
        VpcId=vpc_id,
        CidrBlock=subnet["cidr"],
        AvailabilityZone=subnet["az"]
    )
    subnet_id = s["Subnet"]["SubnetId"]
    public_subnet_ids.append(subnet_id)

    ec2.modify_subnet_attribute(
        SubnetId=subnet_id,
        MapPublicIpOnLaunch={"Value": True}
    )

print("Created Public Subnets")

# --------------------
# Private Subnets
# --------------------
private_subnet_ids = []

for subnet in config["subnets"]["private"]:
    s = ec2.create_subnet(
        VpcId=vpc_id,
        CidrBlock=subnet["cidr"],
        AvailabilityZone=subnet["az"]
    )
    private_subnet_ids.append(s["Subnet"]["SubnetId"])

print("Created Private Subnets")

# --------------------
# NAT Gateway
# --------------------
eip = ec2.allocate_address(Domain="vpc")
nat = ec2.create_nat_gateway(
    SubnetId=public_subnet_ids[0],
    AllocationId=eip["AllocationId"]
)

nat_id = nat["NatGateway"]["NatGatewayId"]

print("Waiting for NAT Gateway to become available...")
time.sleep(60)

# --------------------
# Route Tables
# --------------------
# Public Route Table
pub_rt = ec2.create_route_table(VpcId=vpc_id)
ec2.create_route(
    RouteTableId=pub_rt["RouteTable"]["RouteTableId"],
    DestinationCidrBlock="0.0.0.0/0",
    GatewayId=igw_id
)

for subnet_id in public_subnet_ids:
    ec2.associate_route_table(
        RouteTableId=pub_rt["RouteTable"]["RouteTableId"],
        SubnetId=subnet_id
    )

# Private Route Table
priv_rt = ec2.create_route_table(VpcId=vpc_id)
ec2.create_route(
    RouteTableId=priv_rt["RouteTable"]["RouteTableId"],
    DestinationCidrBlock="0.0.0.0/0",
    NatGatewayId=nat_id
)

for subnet_id in private_subnet_ids:
    ec2.associate_route_table(
        RouteTableId=priv_rt["RouteTable"]["RouteTableId"],
        SubnetId=subnet_id
    )

print("Configured Route Tables")

# --------------------
# Security Groups
# --------------------
for sg in config.get("security_groups", []):
    sg_obj = ec2.create_security_group(
        GroupName=sg["name"],
        Description=sg["description"],
        VpcId=vpc_id
    )

    sg_id = sg_obj["GroupId"]

    for rule in sg.get("ingress", []):
        ec2.authorize_security_group_ingress(
            GroupId=sg_id,
            IpProtocol=rule["protocol"],
            FromPort=rule["from_port"],
            ToPort=rule["to_port"],
            CidrIp=rule["cidr"]
        )

    print(f"Created Security Group: {sg_id}")

print("VPC setup complete.")
```

---

## 📌 Run

```bash
python3 create_vpc_from_yaml.py
```

---

## 🔎 What This Script Creates

| Component        | Created          |
| ---------------- | ---------------- |
| VPC              | Yes              |
| Public Subnets   | Multi-AZ         |
| Private Subnets  | Multi-AZ         |
| Internet Gateway | Attached         |
| NAT Gateway      | Single NAT       |
| Route Tables     | Public + Private |
| Security Groups  | From YAML        |

---

## 🚀 Production Improvements

### 1️⃣ Add Waiters Instead of `sleep`

```python
ec2.get_waiter('nat_gateway_available')
```

### 2️⃣ Make Idempotent

* Check if VPC exists before creating
* Tag-based lookup

### 3️⃣ Multi-NAT for HA

Create NAT per AZ (best practice).

### 4️⃣ Use CDK Instead (Recommended)

CDK Example:

```python
from aws_cdk import (
    Stack,
    aws_ec2 as ec2
)
from constructs import Construct

class VpcStack(Stack):
    def __init__(self, scope: Construct, id: str, **kwargs):
        super().__init__(scope, id, **kwargs)

        ec2.Vpc(self, "MyVpc",
            max_azs=2,
            nat_gateways=1
        )
```

---

## 🔥 Enterprise Recommendation

| Scenario               | Recommended Tool |
| ---------------------- | ---------------- |
| CI quick provisioning  | boto3            |
| Infrastructure as Code | Terraform        |
| Python-native IaC      | CDK              |
| Enterprise Governance  | Terraform + OPA  |

---

## 💡 Interview Summary (2–3 lines)

> This script reads a YAML configuration and provisions a full VPC setup using boto3, including public/private subnets, NAT gateway, route tables, and security groups. It demonstrates infrastructure automation but in production should be replaced with declarative IaC like Terraform or CDK.

---

If you want, I can provide:

* Fully idempotent version
* Multi-NAT high availability version
* CDK version reading YAML
* Terraform equivalent configuration
----
## Q27: Bash Script — Detect Terraform State Drift & Generate Report

---

### 🧠 Objective

* Compare Terraform state vs actual AWS infrastructure
* Detect drift
* Generate structured drift report
* Fail CI if drift detected (optional)

---

## ✅ Recommended Approach (Correct Way)

Terraform drift detection should use:

```bash
terraform plan -detailed-exitcode
```

Exit codes:

* `0` → No drift
* `2` → Drift detected
* `1` → Error

This works because Terraform refreshes state from real AWS APIs before planning.

---

## ✅ Bash Script (`detect_tf_drift.sh`)

```bash
#!/bin/bash

REPORT_FILE="drift_report_$(date +%F_%H%M%S).txt"

echo "Initializing Terraform..."
terraform init -input=false -no-color > /dev/null

echo "Running Terraform plan for drift detection..."
terraform plan -detailed-exitcode -no-color > plan_output.txt
PLAN_EXIT_CODE=$?

echo "Drift Detection Report - $(date)" > "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"

if [ $PLAN_EXIT_CODE -eq 0 ]; then
    echo "No drift detected." | tee -a "$REPORT_FILE"
    exit 0

elif [ $PLAN_EXIT_CODE -eq 2 ]; then
    echo "Drift detected!" | tee -a "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    # Extract changes summary
    grep -E "^[#~+-]" plan_output.txt >> "$REPORT_FILE"

    echo "" >> "$REPORT_FILE"
    echo "Full plan output saved in plan_output.txt" >> "$REPORT_FILE"

    exit 1

else
    echo "Terraform plan failed." | tee -a "$REPORT_FILE"
    exit 1
fi
```

---

## 📌 Usage in CI

### Jenkins

```groovy
sh """
bash detect_tf_drift.sh
"""
```

---

### GitHub Actions

```yaml
- name: Detect Terraform Drift
  run: bash detect_tf_drift.sh
```

---

## 📊 Sample Drift Report

```
Drift Detection Report - 2026-02-14
----------------------------------------
Drift detected!

~ aws_instance.web
  instance_type: "t2.micro" => "t3.medium"

- aws_security_group_rule.old_rule
```

---

## 🔎 What This Detects

| Symbol | Meaning       |
| ------ | ------------- |
| `~`    | Modified      |
| `-`    | Deleted       |
| `+`    | To be created |
| `-/+`  | Replaced      |

---

## 🚀 Production-Grade Version (JSON-Based)

More accurate parsing:

```bash
terraform plan -out=tfplan.binary
terraform show -json tfplan.binary > tfplan.json
```

Then detect drift:

```bash
jq '.resource_changes[] 
    | select(.change.actions != ["no-op"])' tfplan.json
```

---

## 🚀 Enterprise Improvements

### 1️⃣ Scheduled Drift Detection

Run nightly via:

```bash
0 2 * * * bash detect_tf_drift.sh
```

---

### 2️⃣ Slack Alert on Drift

```bash
curl -X POST -H 'Content-type: application/json' \
--data "{\"text\":\"Terraform drift detected in prod\"}" \
$SLACK_WEBHOOK
```

---

### 3️⃣ Use Terraform Cloud Drift Detection (Better)

Terraform Cloud provides:

* Automatic drift detection
* UI visibility
* Policy enforcement

---

### 4️⃣ Use AWS Config for Cross-Validation

Detect manual changes outside Terraform.

---

## 🔥 Enterprise Recommendation

| Scenario             | Recommended            |
| -------------------- | ---------------------- |
| Small setup          | Script-based detection |
| Production infra     | Terraform Cloud        |
| Multi-account        | Scheduled CI job       |
| Governance-heavy org | OPA + Drift Alerts     |

---

## 💡 Interview Summary (2–3 lines)

> This script runs `terraform plan -detailed-exitcode` to detect infrastructure drift. If the exit code is 2, drift is present and a report is generated. It can be integrated into CI/CD to enforce infrastructure integrity.

---

If you want, I can provide:

* JSON-diff version with detailed attribute comparison
* Multi-workspace drift detection script
* Cross-account automated drift scanner
* Slack-integrated enterprise version
----
## Q28: Python Script — Read Static Ansible Inventory, Group by Environment Tags, Generate Dynamic Inventory (JSON)

---

### 🧠 Objective

* Read existing Ansible inventory (INI format)
* Detect environment tags (e.g., `env=dev`)
* Group hosts by environment
* Output dynamic inventory JSON (compatible with Ansible)

---

## 📌 Assumptions

### Example `inventory.ini`

```ini
[web]
web1 ansible_host=10.0.1.10 env=dev role=web
web2 ansible_host=10.0.2.10 env=staging role=web

[db]
db1 ansible_host=10.0.1.20 env=dev role=db
db2 ansible_host=10.0.2.20 env=prod role=db
```

Goal → Generate dynamic inventory:

```json
{
  "dev": { "hosts": ["web1", "db1"] },
  "staging": { "hosts": ["web2"] },
  "prod": { "hosts": ["db2"] }
}
```

---

## ✅ Python Script (`dynamic_inventory_generator.py`)

```python
#!/usr/bin/env python3

import json
import sys
import re
from collections import defaultdict

INVENTORY_FILE = "inventory.ini"

def parse_inventory(file_path):
    env_groups = defaultdict(list)
    hostvars = {}

    with open(file_path) as f:
        for line in f:
            line = line.strip()

            # Skip empty lines & groups
            if not line or line.startswith("["):
                continue

            # Parse host line
            parts = line.split()
            hostname = parts[0]

            vars_dict = {}
            for part in parts[1:]:
                if "=" in part:
                    k, v = part.split("=", 1)
                    vars_dict[k] = v

            hostvars[hostname] = vars_dict

            # Group by environment tag
            env = vars_dict.get("env")
            if env:
                env_groups[env].append(hostname)

    return env_groups, hostvars


def build_dynamic_inventory(env_groups, hostvars):
    inventory = {}

    # Environment groups
    for env, hosts in env_groups.items():
        inventory[env] = {"hosts": hosts}

    # Host variables
    inventory["_meta"] = {"hostvars": hostvars}

    return inventory


def main():
    env_groups, hostvars = parse_inventory(INVENTORY_FILE)
    inventory = build_dynamic_inventory(env_groups, hostvars)

    print(json.dumps(inventory, indent=2))


if __name__ == "__main__":
    main()
```

---

## 📌 Run

```bash
chmod +x dynamic_inventory_generator.py
./dynamic_inventory_generator.py
```

Or:

```bash
python3 dynamic_inventory_generator.py
```

---

## 📊 Example Output

```json
{
  "dev": {
    "hosts": ["web1", "db1"]
  },
  "staging": {
    "hosts": ["web2"]
  },
  "prod": {
    "hosts": ["db2"]
  },
  "_meta": {
    "hostvars": {
      "web1": {"ansible_host": "10.0.1.10", "env": "dev", "role": "web"},
      "db2": {"ansible_host": "10.0.2.20", "env": "prod", "role": "db"}
    }
  }
}
```

---

## 🔎 How This Works

| Step              | Action                           |
| ----------------- | -------------------------------- |
| Parse INI         | Read hosts + variables           |
| Extract `env`     | Group by environment             |
| Preserve hostvars | Required for dynamic inventory   |
| Output JSON       | Ansible dynamic inventory format |

---

## 🚀 Use as True Dynamic Inventory Script

Update Ansible config:

```ini
[defaults]
inventory = ./dynamic_inventory_generator.py
```

Now:

```bash
ansible-inventory --list
```

---

## 🚀 Production Improvements

### 1️⃣ Support YAML Inventory

Use `pyyaml` to parse YAML-based inventories.

### 2️⃣ Fetch From Cloud Instead

Instead of static file, pull:

* EC2 instances (boto3)
* Tags: `Environment=dev`
* Auto-group dynamically

### 3️⃣ Add Role-Based Groups

```python
role = vars_dict.get("role")
inventory.setdefault(role, {"hosts": []})["hosts"].append(hostname)
```

---

## 🔥 Enterprise Alternative

Instead of custom script:

* Use built-in AWS dynamic inventory plugin:

  ```
  ansible-inventory -i aws_ec2.yml --list
  ```
* Use Terraform → Ansible integration
* Use Service Discovery

---

## 💡 Interview Summary (2–3 lines)

> This script parses a static Ansible inventory, groups hosts by environment tags, and generates a dynamic JSON inventory compatible with Ansible. It enables flexible environment-based automation and cloud migration readiness.

---

If you want, I can provide:

* AWS EC2 dynamic inventory version
* YAML inventory parser version
* Multi-cloud dynamic inventory generator
* CI-integrated inventory validation script
----
## Q31: Bash Script — Detect High Pod Restart Counts Across All Namespaces (>5) and Alert

---

### 🧠 Objective

* Scan **all namespaces**
* Detect pods with restart count > 5
* Log details (pod, namespace, restart count)
* Send alert (email or Slack)
* CI / Cron / Ops-ready

---

## 📌 Assumptions

| Requirement        | Value                              |
| ------------------ | ---------------------------------- |
| kubectl configured | Yes                                |
| Restart threshold  | 5                                  |
| Alert type         | Email (example)                    |
| Log file           | `/var/log/k8s_restart_monitor.log` |

---

## ✅ Bash Script (`check_pod_restarts.sh`)

```bash
#!/bin/bash

THRESHOLD=5
LOG_FILE="/var/log/k8s_restart_monitor.log"
ALERT_EMAIL="admin@example.com"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

echo "[$DATE] Checking pod restart counts..." >> "$LOG_FILE"

# Get all pods in all namespaces with restart counts
PODS=$(kubectl get pods --all-namespaces \
  -o jsonpath='{range .items[*]}{.metadata.namespace}{"|"}{.metadata.name}{"|"}{range .status.containerStatuses[*]}{.restartCount}{" "}{end}{"\n"}{end}')

ALERT_MSG=""

while IFS="|" read -r NAMESPACE POD RESTARTS; do

  # Sum all container restarts in pod
  TOTAL_RESTARTS=$(echo "$RESTARTS" | awk '{sum=0; for(i=1;i<=NF;i++) sum+=$i; print sum}')

  if [ "$TOTAL_RESTARTS" -gt "$THRESHOLD" ]; then
    MSG="Namespace: $NAMESPACE | Pod: $POD | Restarts: $TOTAL_RESTARTS"
    echo "$MSG" >> "$LOG_FILE"
    ALERT_MSG+="$MSG\n"
  fi

done <<< "$PODS"

if [ -n "$ALERT_MSG" ]; then
  echo -e "High Restart Alert:\n\n$ALERT_MSG" \
    | mail -s "Kubernetes Pod Restart Alert" "$ALERT_EMAIL"
fi

echo "[$DATE] Restart check completed." >> "$LOG_FILE"
```

---

## 📌 Run

```bash
chmod +x check_pod_restarts.sh
./check_pod_restarts.sh
```

---

## ⏱ Schedule (Every 10 Minutes)

```bash
*/10 * * * * /path/check_pod_restarts.sh
```

---

## 📊 Sample Log Output

```
Namespace: prod | Pod: api-78c9d8f | Restarts: 7
Namespace: staging | Pod: worker-6a2f9 | Restarts: 12
```

---

## 🚀 Slack Alert Version (Recommended)

Replace email section with:

```bash
SLACK_WEBHOOK="https://hooks.slack.com/services/XXX"

curl -X POST -H 'Content-type: application/json' \
--data "{\"text\":\"High Restart Alert:\n$ALERT_MSG\"}" \
$SLACK_WEBHOOK
```

---

## 🔎 What This Script Detects

| Case                     | Detected?  |
| ------------------------ | ---------- |
| CrashLoopBackOff         | Yes        |
| OOMKilled                | Yes        |
| Single container restart | Yes        |
| Multi-container pod      | Aggregated |

---

## 🚀 Production Improvements

### 1️⃣ Ignore Certain Namespaces

```bash
if [[ "$NAMESPACE" == "kube-system" ]]; then continue; fi
```

---

### 2️⃣ Only Check Running Pods

```bash
kubectl get pods --field-selector=status.phase=Running
```

---

### 3️⃣ Use Prometheus Instead (Enterprise)

Better query:

```promql
kube_pod_container_status_restarts_total > 5
```

Alert via Alertmanager.

---

### 4️⃣ Detect Restart Increase (Better Logic)

Instead of absolute count:

* Store previous restart count
* Alert only if restart increases

---

## 🔥 Enterprise Architecture

| Small cluster | This script |
| Medium | CronJob in cluster |
| Production | Prometheus + Alertmanager |
| Advanced | Auto-remediation via Argo |

---

## 💡 Interview Summary (2–3 lines)

> This script scans all Kubernetes namespaces, aggregates container restart counts per pod, logs pods exceeding the threshold, and sends alerts. It can run as a cron job or be replaced by Prometheus alerts in production environments.

---

If you want, I can provide:

* Kubernetes CronJob YAML version
* Prometheus alert rule
* Version with auto-restart logic
* EKS IRSA-enabled monitoring pod

----
## Q32: Python Script — Time-Based Auto Scaling of Kubernetes Deployments (9 AM Scale Up, 6 PM Scale Down)

---

### 🧠 Objective

* Scale deployments across specific namespaces
* Scale **up at 9 AM**
* Scale **down at 6 PM**
* Uses Kubernetes Python client
* Suitable for CronJob / CI / Lambda-style execution

---

## 📌 Assumptions

| Item                | Value                  |
| ------------------- | ---------------------- |
| Scale Up Replicas   | 5                      |
| Scale Down Replicas | 1                      |
| Namespaces          | dev, staging           |
| Timezone            | Asia/Kolkata (example) |

---

## ✅ Install Dependencies

```bash
pip install kubernetes pytz
```

---

## ✅ Python Script (`k8s_time_based_scaler.py`)

```python
from kubernetes import client, config
from datetime import datetime
import pytz

# Configuration
NAMESPACES = ["dev", "staging"]
SCALE_UP_HOUR = 9
SCALE_DOWN_HOUR = 18
SCALE_UP_REPLICAS = 5
SCALE_DOWN_REPLICAS = 1
TIMEZONE = "Asia/Kolkata"

def load_config():
    try:
        config.load_incluster_config()
    except:
        config.load_kube_config()

def scale_deployments(namespace, replicas):
    apps_v1 = client.AppsV1Api()

    deployments = apps_v1.list_namespaced_deployment(namespace)

    for deploy in deployments.items:
        name = deploy.metadata.name
        current_replicas = deploy.spec.replicas

        if current_replicas != replicas:
            print(f"Scaling {namespace}/{name} from {current_replicas} → {replicas}")

            body = {
                "spec": {
                    "replicas": replicas
                }
            }

            apps_v1.patch_namespaced_deployment_scale(
                name=name,
                namespace=namespace,
                body=body
            )

def main():
    load_config()

    tz = pytz.timezone(TIMEZONE)
    current_hour = datetime.now(tz).hour

    if current_hour == SCALE_UP_HOUR:
        print("Scaling UP deployments...")
        for ns in NAMESPACES:
            scale_deployments(ns, SCALE_UP_REPLICAS)

    elif current_hour == SCALE_DOWN_HOUR:
        print("Scaling DOWN deployments...")
        for ns in NAMESPACES:
            scale_deployments(ns, SCALE_DOWN_REPLICAS)

    else:
        print("No scaling action required at this time.")

if __name__ == "__main__":
    main()
```

---

## 📌 Run Manually

```bash
python3 k8s_time_based_scaler.py
```

---

## ⏱ Run via Cron (Recommended)

```bash
0 9 * * * python3 /path/k8s_time_based_scaler.py
0 18 * * * python3 /path/k8s_time_based_scaler.py
```

---

## 🚀 Run as Kubernetes CronJob (Better)

Example schedule:

```yaml
schedule: "0 9,18 * * *"
```

---

## 🔐 Required RBAC (If Running Inside Cluster)

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: scaler
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: scaler-role
rules:
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "patch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: scaler-binding
subjects:
- kind: ServiceAccount
  name: scaler
roleRef:
  kind: Role
  name: scaler-role
  apiGroup: rbac.authorization.k8s.io
```

---

## 🔎 What This Script Does

| Time        | Action                          |
| ----------- | ------------------------------- |
| 9 AM        | Scale deployments to 5 replicas |
| 6 PM        | Scale deployments to 1 replica  |
| Other times | No action                       |

---

## 🚀 Production Improvements

### 1️⃣ Scale Only Labeled Deployments

```python
list_namespaced_deployment(namespace, label_selector="autoscale=true")
```

---

### 2️⃣ Store Previous Replica Count

So scale down restores original replica number.

---

### 3️⃣ Combine with HPA

Use:

* HPA for load-based scaling
* Script for business-hour baseline scaling

---

### 4️⃣ Enterprise Alternative

Better approach:

* Use Kubernetes **KEDA**
* Use HPA with scheduled scaling (via KEDA Cron scaler)
* Use Argo Rollouts for advanced control

---

## 🔥 Real-World Use Case

* Dev clusters cost optimization
* Business-hour scaling
* QA environment scheduling
* Non-prod EKS auto-cost control

---

## 💡 Interview Summary (2–3 lines)

> This script uses the Kubernetes Python client to scale deployments up or down based on time of day. It supports multiple namespaces and can run as a cron job or Kubernetes CronJob for automated cost optimization in non-production environments.

---

If you want, I can provide:

* KEDA cron-based scaler YAML
* HPA + time-based hybrid solution
* Version that scales StatefulSets too
* EKS IRSA-enabled deployment version
----
## Q33: Bash Script — Rolling Restart All Deployments in a Namespace (Sequential + Health Wait)

---

### 🧠 Objective

* Restart all deployments in a given namespace
* Process **one deployment at a time**
* Wait until rollout is healthy before moving to next
* Fail immediately if any rollout fails
* CI/CD safe

---

## ✅ Script: `rolling_restart_namespace.sh`

```bash
#!/bin/bash

NAMESPACE="$1"
TIMEOUT="300s"   # rollout timeout per deployment

if [ -z "$NAMESPACE" ]; then
  echo "Usage: $0 <namespace>"
  exit 1
fi

echo "Starting rolling restart in namespace: $NAMESPACE"
echo "---------------------------------------------"

# Get all deployments in namespace
DEPLOYMENTS=$(kubectl get deployments -n "$NAMESPACE" -o jsonpath='{.items[*].metadata.name}')

if [ -z "$DEPLOYMENTS" ]; then
  echo "No deployments found in namespace: $NAMESPACE"
  exit 0
fi

for DEPLOY in $DEPLOYMENTS; do
  echo ""
  echo "Restarting deployment: $DEPLOY"

  # Trigger rolling restart
  kubectl rollout restart deployment "$DEPLOY" -n "$NAMESPACE"

  echo "Waiting for rollout to complete..."

  if ! kubectl rollout status deployment "$DEPLOY" \
      -n "$NAMESPACE" \
      --timeout="$TIMEOUT"; then

      echo "Rollout failed for $DEPLOY. Exiting."
      exit 1
  fi

  echo "Deployment $DEPLOY successfully rolled out."
done

echo ""
echo "All deployments restarted successfully."
exit 0
```

---

## 📌 Usage

```bash
chmod +x rolling_restart_namespace.sh
./rolling_restart_namespace.sh dev
```

---

## 🔎 What This Script Does

| Step                  | Action                    |
| --------------------- | ------------------------- |
| List deployments      | `kubectl get deployments` |
| Restart               | `kubectl rollout restart` |
| Wait                  | `kubectl rollout status`  |
| Sequential processing | `for` loop                |
| Fail fast             | Exit if rollout fails     |

---

## 🚀 Example Output

```
Restarting deployment: api
Waiting for rollout to complete...
deployment "api" successfully rolled out

Restarting deployment: worker
Waiting for rollout to complete...
deployment "worker" successfully rolled out

All deployments restarted successfully.
```

---

## 🚀 Production Improvements

### 1️⃣ Restart Only Labeled Deployments

```bash
kubectl get deployments -l restart=true
```

---

### 2️⃣ Add Max Surge Control

Ensure deployment has:

```yaml
strategy:
  rollingUpdate:
    maxUnavailable: 1
    maxSurge: 1
```

---

### 3️⃣ Add Slack Alert on Failure

```bash
curl -X POST -H 'Content-type: application/json' \
--data "{\"text\":\"Rollout failed for $DEPLOY in $NAMESPACE\"}" \
$SLACK_WEBHOOK
```

---

### 4️⃣ Parallel with Concurrency Limit

Use GNU parallel if needed for large namespaces.

---

### 5️⃣ Safer Variant (Skip Already Progressing Deployments)

```bash
kubectl rollout status --watch=false
```

---

## 🔥 Enterprise Alternative

| Setup          | Better Option        |
| -------------- | -------------------- |
| Large clusters | Argo Rollouts        |
| Zero downtime  | Canary rollout       |
| GitOps         | ArgoCD sync          |
| High safety    | Progressive delivery |

---

## 💡 Interview Summary (2–3 lines)

> This script performs a sequential rolling restart of all deployments in a namespace and waits for each deployment to become healthy before proceeding. It ensures controlled restarts and prevents cascading failures.

---

If you want, I can provide:

* Version that restarts StatefulSets
* Canary-style restart script
* Multi-namespace version
* Jenkins pipeline wrapper
* Argo Rollouts equivalent implementation

----
## Q34: Python Script — Audit Kubernetes Deployments for Security Best Practices & Generate Compliance Report

---

### 🧠 Objective

Audit all deployments for:

* ✅ `runAsNonRoot: true`
* ✅ `readOnlyRootFilesystem: true`
* ✅ Resource limits set (CPU & memory)
* Generate JSON compliance report
* Works locally or in-cluster

---

## 📌 Security Checks

| Check                  | Why                                    |
| ---------------------- | -------------------------------------- |
| runAsNonRoot           | Prevent container privilege escalation |
| readOnlyRootFilesystem | Protect container filesystem           |
| CPU & Memory limits    | Prevent noisy neighbor & DoS risk      |

---

## ✅ Install Dependencies

```bash
pip install kubernetes
```

---

## ✅ Python Script (`k8s_security_audit.py`)

```python
from kubernetes import client, config
import json
from datetime import datetime

OUTPUT_FILE = f"k8s_security_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"

def load_config():
    try:
        config.load_incluster_config()
    except:
        config.load_kube_config()

def audit_deployments():
    apps_v1 = client.AppsV1Api()
    deployments = apps_v1.list_deployment_for_all_namespaces()

    report = []

    for deploy in deployments.items:
        namespace = deploy.metadata.namespace
        name = deploy.metadata.name

        for container in deploy.spec.template.spec.containers:
            container_name = container.name

            security_context = container.security_context or {}
            resources = container.resources or {}

            run_as_non_root = security_context.run_as_non_root
            read_only_fs = security_context.read_only_root_filesystem

            limits = resources.limits or {}

            cpu_limit = limits.get("cpu")
            mem_limit = limits.get("memory")

            compliance = {
                "namespace": namespace,
                "deployment": name,
                "container": container_name,
                "runAsNonRoot": run_as_non_root is True,
                "readOnlyRootFilesystem": read_only_fs is True,
                "cpuLimitSet": cpu_limit is not None,
                "memoryLimitSet": mem_limit is not None
            }

            compliance["compliant"] = all([
                compliance["runAsNonRoot"],
                compliance["readOnlyRootFilesystem"],
                compliance["cpuLimitSet"],
                compliance["memoryLimitSet"]
            ])

            report.append(compliance)

    return report

def generate_summary(report):
    total = len(report)
    compliant = sum(1 for r in report if r["compliant"])

    summary = {
        "total_containers_checked": total,
        "compliant_containers": compliant,
        "non_compliant_containers": total - compliant
    }

    return summary

def main():
    load_config()
    report = audit_deployments()
    summary = generate_summary(report)

    output = {
        "generated_at": datetime.now().isoformat(),
        "summary": summary,
        "details": report
    }

    with open(OUTPUT_FILE, "w") as f:
        json.dump(output, f, indent=2)

    print(f"Compliance report generated: {OUTPUT_FILE}")
    print(json.dumps(summary, indent=2))

if __name__ == "__main__":
    main()
```

---

## 📌 Run

```bash
python3 k8s_security_audit.py
```

---

## 📊 Sample Summary Output

```json
{
  "total_containers_checked": 12,
  "compliant_containers": 7,
  "non_compliant_containers": 5
}
```

---

## 🔎 Sample Non-Compliant Entry

```json
{
  "namespace": "prod",
  "deployment": "api",
  "container": "api-container",
  "runAsNonRoot": false,
  "readOnlyRootFilesystem": false,
  "cpuLimitSet": true,
  "memoryLimitSet": false,
  "compliant": false
}
```

---

## 🚀 Production Improvements

### 1️⃣ Add Pod-Level Security Context Check

Check:

```python
deploy.spec.template.spec.security_context
```

---

### 2️⃣ Check Additional Security Controls

| Check                          | Add Logic                                   |
| ------------------------------ | ------------------------------------------- |
| privileged=false               | container.security_context.privileged       |
| allowPrivilegeEscalation=false | security_context.allow_privilege_escalation |
| Image tag not `latest`         | container.image                             |
| Pod security admission labels  | namespace labels                            |

---

### 3️⃣ Generate CSV Report

```python
import csv
```

---

### 4️⃣ Send Slack Alert for Non-Compliant Deployments

---

### 5️⃣ Enterprise Alternative (Recommended)

Instead of custom script:

* **OPA Gatekeeper**
* **Kyverno**
* **Kubescape**
* **Trivy Kubernetes Scan**
* **Polaris**

---

## 🔥 Enterprise Architecture

| Small cluster | This script |
| Production | Policy as Code (OPA/Kyverno) |
| CI/CD | Admission Controller |
| Compliance | Kubescape + Reporting |

---

## 💡 Interview Summary (2–3 lines)

> This script audits all Kubernetes deployments for key security best practices such as non-root execution, read-only filesystem, and resource limits. It generates a structured compliance report and can be integrated into CI or scheduled audits.

---

If you want, I can provide:

* Slack-integrated version
* CSV report version
* CI/CD gate version (fail on non-compliance)
* OPA policy equivalent
* Enterprise-grade extended security audit version
----
## Q35: Bash Script — Graceful Node Drain + Reschedule Wait + Cluster Health Verification

---

### 🧠 Objective

* Cordon node
* Drain gracefully
* Wait until pods are rescheduled
* Verify cluster health
* Mark maintenance complete
* Fail safely if something is wrong

---

## 📌 Assumptions

| Item               | Value          |
| ------------------ | -------------- |
| kubectl configured | Yes            |
| Ignore DaemonSets  | Yes            |
| Timeout per check  | 300s           |
| Namespace scope    | All namespaces |

---

## ✅ Script: `graceful_node_maintenance.sh`

```bash
#!/bin/bash

NODE_NAME="$1"
TIMEOUT=300   # seconds
CHECK_INTERVAL=10

if [ -z "$NODE_NAME" ]; then
  echo "Usage: $0 <node-name>"
  exit 1
fi

echo "Starting maintenance for node: $NODE_NAME"
echo "------------------------------------------"

# Step 1: Cordon Node
echo "Cordoning node..."
kubectl cordon "$NODE_NAME" || exit 1

# Step 2: Drain Node
echo "Draining node..."
kubectl drain "$NODE_NAME" \
  --ignore-daemonsets \
  --delete-emptydir-data \
  --grace-period=30 \
  --timeout=${TIMEOUT}s || exit 1

echo "Node drained successfully."

# Step 3: Wait for pods to reschedule
echo "Waiting for pods to stabilize..."

ELAPSED=0
while [ $ELAPSED -lt $TIMEOUT ]; do

  NOT_READY_PODS=$(kubectl get pods --all-namespaces \
    --field-selector=status.phase!=Running,status.phase!=Succeeded \
    --no-headers 2>/dev/null | wc -l)

  if [ "$NOT_READY_PODS" -eq 0 ]; then
    echo "All pods are healthy."
    break
  fi

  echo "Pods not ready yet: $NOT_READY_PODS"
  sleep $CHECK_INTERVAL
  ELAPSED=$((ELAPSED + CHECK_INTERVAL))
done

if [ $ELAPSED -ge $TIMEOUT ]; then
  echo "Timeout waiting for pods to stabilize."
  exit 1
fi

# Step 4: Verify Cluster Health

echo "Verifying node and cluster health..."

NOT_READY_NODES=$(kubectl get nodes \
  --no-headers | awk '$2 != "Ready" {print $1}' | wc -l)

if [ "$NOT_READY_NODES" -gt 1 ]; then
  echo "Cluster has unhealthy nodes."
  kubectl get nodes
  exit 1
fi

echo "Cluster health verified."

echo "Maintenance completed successfully for node: $NODE_NAME"
exit 0
```

---

## 📌 Usage

```bash
chmod +x graceful_node_maintenance.sh
./graceful_node_maintenance.sh ip-10-0-1-25
```

---

## 🔎 What This Script Does

| Step         | Action                      |
| ------------ | --------------------------- |
| cordon       | Prevent new pods scheduling |
| drain        | Evict running pods safely   |
| wait         | Ensure pods are rescheduled |
| check health | All nodes Ready             |
| complete     | Maintenance safe            |

---

## 🚀 Safer Production Enhancements

### 1️⃣ Exclude Critical Namespaces

```bash
--pod-selector='!critical=true'
```

---

### 2️⃣ Verify Workload Readiness Specifically

Instead of generic pod check:

```bash
kubectl get deployments --all-namespaces \
  -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.status.availableReplicas}{"\n"}{end}'
```

---

### 3️⃣ Slack Alert on Failure

```bash
curl -X POST -H 'Content-type: application/json' \
--data "{\"text\":\"Node drain failed for $NODE_NAME\"}" \
$SLACK_WEBHOOK
```

---

### 4️⃣ Auto-Uncordon After Maintenance

Add at end:

```bash
kubectl uncordon "$NODE_NAME"
```

---

### 5️⃣ EKS Production Approach

For EKS nodes:

* Use ASG lifecycle hooks
* Use Cluster Autoscaler
* Use Karpenter disruption budgets

---

## 🔥 Enterprise Best Practice

| Environment    | Recommended                       |
| -------------- | --------------------------------- |
| Small cluster  | This script                       |
| Production EKS | Managed node group rolling update |
| Large cluster  | Automated maintenance controller  |
| Advanced       | Node termination handler          |

---

## 💡 Interview Summary (2–3 lines)

> This script cordons and drains a Kubernetes node gracefully, waits for pods to be rescheduled, verifies cluster health, and completes maintenance safely. It ensures zero disruption during node maintenance operations.

---

If you want, I can provide:

* EKS Auto Scaling lifecycle hook version
* Multi-node rolling maintenance script
* Version integrated into Jenkins pipeline
* Advanced health validation version
----
## Q36: Python Script — Prometheus Firing Alerts → Deduplicate → Enrich from CMDB → Prioritized Slack Summary

---

### 🧠 Objective

* Query Prometheus **/api/v1/alerts**
* Filter `state = firing`
* Deduplicate similar alerts
* Enrich with service owner from CMDB (YAML/JSON)
* Prioritize (Critical > Warning > Info)
* Post structured summary to Slack

---

## 📌 Assumptions

| Item           | Example                                |
| -------------- | -------------------------------------- |
| Prometheus URL | `http://prometheus:9090`               |
| Slack Webhook  | `https://hooks.slack.com/services/...` |
| CMDB File      | `cmdb.yaml`                            |
| Alert Labels   | `alertname`, `severity`, `service`     |

---

## 📄 Example `cmdb.yaml`

```yaml
services:
  api:
    owner: api-team@example.com
    priority: P1
  worker:
    owner: worker-team@example.com
    priority: P2
  db:
    owner: db-team@example.com
    priority: P0
```

---

## ✅ Install Dependencies

```bash
pip install requests pyyaml
```

---

## ✅ Python Script (`prom_alert_router.py`)

```python
import requests
import yaml
from collections import defaultdict

PROM_URL = "http://prometheus:9090/api/v1/alerts"
SLACK_WEBHOOK = "https://hooks.slack.com/services/XXX"
CMDB_FILE = "cmdb.yaml"

SEVERITY_PRIORITY = {
    "critical": 1,
    "warning": 2,
    "info": 3
}

def load_cmdb():
    with open(CMDB_FILE) as f:
        return yaml.safe_load(f)["services"]

def get_firing_alerts():
    response = requests.get(PROM_URL)
    data = response.json()

    firing_alerts = [
        alert for alert in data["data"]["alerts"]
        if alert["state"] == "firing"
    ]

    return firing_alerts

def deduplicate(alerts):
    unique = {}
    for alert in alerts:
        key = (
            alert["labels"].get("alertname"),
            alert["labels"].get("service"),
            alert["labels"].get("severity")
        )
        if key not in unique:
            unique[key] = alert
    return list(unique.values())

def enrich_alerts(alerts, cmdb):
    enriched = []

    for alert in alerts:
        labels = alert["labels"]
        service = labels.get("service", "unknown")
        severity = labels.get("severity", "info")

        owner_info = cmdb.get(service, {})
        owner = owner_info.get("owner", "unknown")
        priority = owner_info.get("priority", "P3")

        enriched.append({
            "alertname": labels.get("alertname"),
            "service": service,
            "severity": severity,
            "owner": owner,
            "priority": priority
        })

    return enriched

def sort_by_priority(alerts):
    return sorted(
        alerts,
        key=lambda x: (
            SEVERITY_PRIORITY.get(x["severity"], 99),
            x["priority"]
        )
    )

def send_to_slack(alerts):
    if not alerts:
        return

    message = "*🚨 Firing Alerts Summary*\n\n"

    for alert in alerts:
        message += (
            f"*{alert['alertname']}*\n"
            f"Service: {alert['service']}\n"
            f"Severity: {alert['severity']}\n"
            f"Owner: {alert['owner']}\n"
            f"Priority: {alert['priority']}\n\n"
        )

    requests.post(SLACK_WEBHOOK, json={"text": message})

def main():
    cmdb = load_cmdb()
    alerts = get_firing_alerts()

    if not alerts:
        print("No firing alerts.")
        return

    unique_alerts = deduplicate(alerts)
    enriched_alerts = enrich_alerts(unique_alerts, cmdb)
    prioritized_alerts = sort_by_priority(enriched_alerts)

    send_to_slack(prioritized_alerts)
    print("Slack notification sent.")

if __name__ == "__main__":
    main()
```

---

## 📌 Run

```bash
python3 prom_alert_router.py
```

---

## 📊 Example Slack Output

```
🚨 Firing Alerts Summary

HighCPUUsage
Service: api
Severity: critical
Owner: api-team@example.com
Priority: P1

DBConnectionErrors
Service: db
Severity: warning
Owner: db-team@example.com
Priority: P0
```

---

## 🔎 What This Script Does

| Step             | Function                                 |
| ---------------- | ---------------------------------------- |
| Query Prometheus | Get all firing alerts                    |
| Deduplicate      | Unique by alertname + service + severity |
| Enrich           | Add owner + business priority            |
| Sort             | Critical first                           |
| Notify           | Slack summary                            |

---

## 🚀 Production Improvements

### 1️⃣ Deduplicate by Fingerprint

Use:

```python
alert["fingerprint"]
```

---

### 2️⃣ Add Alert Age Filter

Ignore alerts firing < 2 minutes.

---

### 3️⃣ Group by Owner

```python
owner_groups = defaultdict(list)
```

Send per-team summary.

---

### 4️⃣ Replace CMDB File with API

Call:

* ServiceNow
* DynamoDB
* Internal CMDB API

---

### 5️⃣ Rate Limit Slack Messages

Prevent spam during alert storms.

---

## 🔥 Enterprise Architecture

| Layer      | Recommended               |
| ---------- | ------------------------- |
| Alerting   | Prometheus + Alertmanager |
| Enrichment | Lambda alert processor    |
| CMDB       | ServiceNow / DynamoDB     |
| Routing    | PagerDuty / OpsGenie      |
| Dedup      | Alertmanager grouping     |

---

## 💡 Interview Summary (2–3 lines)

> This script queries Prometheus for firing alerts, deduplicates them, enriches them with service ownership from a CMDB, prioritizes them based on severity and business impact, and posts a structured summary to Slack.

---

If you want, I can provide:

* PagerDuty integration version
* Alertmanager webhook receiver version
* Multi-channel routing version
* Enterprise-grade alert correlation engine
----
## Q37: Bash Script — Nginx Log Analysis → Top 10 Slow Endpoints + Error Rate >5% → HTML Report

---

### 🧠 Objective

* Parse Nginx access logs
* Calculate:

  * Top 10 endpoints by **average response time**
  * Endpoints with **error rate > 5%**
* Generate HTML report
* CI / cron friendly

---

## 📌 Assumptions

Your Nginx log format includes request + status + request_time:

Example:

```
log_format main '$remote_addr - $remote_user [$time_local] '
                '"$request" $status $body_bytes_sent '
                '"$http_referer" "$http_user_agent" '
                '$request_time';
```

---

## ✅ Script: `nginx_log_report.sh`

```bash
#!/bin/bash

LOG_FILE="/var/log/nginx/access.log"
OUTPUT_FILE="nginx_report_$(date +%F_%H%M%S).html"

if [ ! -f "$LOG_FILE" ]; then
  echo "Log file not found!"
  exit 1
fi

TMP_STATS=$(mktemp)

# Extract endpoint, status, response_time
awk '
{
  request=$7
  status=$9
  response_time=$NF
  print request, status, response_time
}
' "$LOG_FILE" > "$TMP_STATS"

# ----------------------------
# Top 10 Endpoints by Avg Response Time
# ----------------------------
TOP_SLOW=$(awk '
{
  endpoint=$1
  time=$3
  total[endpoint]+=time
  count[endpoint]++
}
END {
  for (e in total) {
    avg = total[e]/count[e]
    printf "%s %.6f\n", e, avg
  }
}
' "$TMP_STATS" | sort -k2 -nr | head -10)

# ----------------------------
# Error Rate > 5%
# ----------------------------
ERRORS=$(awk '
{
  endpoint=$1
  status=$2

  total[endpoint]++

  if (status ~ /^[45]/)
    errors[endpoint]++
}
END {
  for (e in total) {
    err_rate = (errors[e]/total[e])*100
    if (err_rate > 5)
      printf "%s %.2f%%\n", e, err_rate
  }
}
' "$TMP_STATS")

# ----------------------------
# Generate HTML Report
# ----------------------------

cat <<EOF > "$OUTPUT_FILE"
<!DOCTYPE html>
<html>
<head>
  <title>Nginx Log Report</title>
  <style>
    body { font-family: Arial; }
    table { border-collapse: collapse; width: 70%; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
    th { background-color: #f2f2f2; }
    h2 { color: #2c3e50; }
  </style>
</head>
<body>

<h1>Nginx Log Analysis Report</h1>
<p>Generated at: $(date)</p>

<h2>Top 10 Endpoints by Average Response Time</h2>
<table>
<tr><th>Endpoint</th><th>Avg Response Time (s)</th></tr>
EOF

echo "$TOP_SLOW" | while read endpoint avg; do
  echo "<tr><td>$endpoint</td><td>$avg</td></tr>" >> "$OUTPUT_FILE"
done

cat <<EOF >> "$OUTPUT_FILE"
</table>

<h2>Endpoints with Error Rate > 5%</h2>
<table>
<tr><th>Endpoint</th><th>Error Rate</th></tr>
EOF

echo "$ERRORS" | while read endpoint rate; do
  echo "<tr><td>$endpoint</td><td>$rate</td></tr>" >> "$OUTPUT_FILE"
done

cat <<EOF >> "$OUTPUT_FILE"
</table>

</body>
</html>
EOF

rm "$TMP_STATS"

echo "Report generated: $OUTPUT_FILE"
```

---

## 📌 Run

```bash
chmod +x nginx_log_report.sh
./nginx_log_report.sh
```

---

## 📊 Output Example (HTML)

* Top 10 slowest endpoints by average response time
* Endpoints exceeding 5% error rate
* Clean table format

---

## 🔎 What This Script Calculates

| Metric            | Method                    |
| ----------------- | ------------------------- |
| Avg response time | Sum / Count per endpoint  |
| Error rate        | (4xx + 5xx) / total * 100 |
| Top 10 slow       | Sorted descending         |
| Threshold         | Error rate > 5%           |

---

## 🚀 Production Improvements

### 1️⃣ Use Last 24 Hours Only

```bash
grep "$(date '+%d/%b/%Y')" access.log
```

---

### 2️⃣ Exclude Static Assets

```bash
if (endpoint !~ /\.(css|js|png|jpg)$/)
```

---

### 3️⃣ Add P95 Latency Instead of Avg

Use sorting per endpoint.

---

### 4️⃣ Auto-Email Report

```bash
mail -s "Nginx Report" admin@example.com < nginx_report.html
```

---

### 5️⃣ Enterprise Alternative

Instead of manual log parsing:

| Tool       | Recommended        |
| ---------- | ------------------ |
| Prometheus | nginx_exporter     |
| ELK        | Logstash + Kibana  |
| Grafana    | Loki               |
| APM        | Datadog / NewRelic |

---

## 🔥 Enterprise-Grade Approach

Use:

* Nginx → Prometheus exporter
* Alert if:

  * P95 latency > threshold
  * Error rate > 5%
* Grafana dashboard instead of HTML

---

## 💡 Interview Summary (2–3 lines)

> This script parses Nginx access logs, computes the top 10 endpoints by average response time, identifies endpoints with error rates above 5%, and generates a structured HTML report. It demonstrates log analytics using awk and shell scripting.

---

If you want, I can provide:

* Version with P95 calculation
* Prometheus exporter alternative
* CI-integrated version
* Version that uploads report to S3
* Multi-log file aggregated version
---
## Q38: Python Script — Auto-Create CloudWatch Dashboards & Alarms from YAML Config

---

### 🧠 Objective

* Read YAML config defining:

  * Services
  * Metrics
  * Thresholds
* Automatically:

  * Create CloudWatch Dashboard
  * Create CloudWatch Alarms
* CI/CD compatible
* Production-ready structure

---

## 📄 Example `monitoring_config.yaml`

```yaml
region: ap-south-1
dashboard_name: my-services-dashboard

services:
  - name: api
    namespace: AWS/ApplicationELB
    metrics:
      - metric_name: TargetResponseTime
        statistic: Average
        period: 60
        threshold: 1
        comparison: GreaterThanThreshold
      - metric_name: HTTPCode_Target_5XX_Count
        statistic: Sum
        period: 60
        threshold: 10
        comparison: GreaterThanThreshold

  - name: worker
    namespace: AWS/ECS
    metrics:
      - metric_name: CPUUtilization
        statistic: Average
        period: 60
        threshold: 80
        comparison: GreaterThanThreshold
```

---

## ✅ Install Dependencies

```bash
pip install boto3 pyyaml
```

---

## ✅ Python Script (`cw_dashboard_alarm_creator.py`)

```python
import boto3
import yaml
import json

CONFIG_FILE = "monitoring_config.yaml"

with open(CONFIG_FILE) as f:
    config = yaml.safe_load(f)

region = config["region"]
dashboard_name = config["dashboard_name"]

cw = boto3.client("cloudwatch", region_name=region)

widgets = []

def create_alarm(service, metric):
    alarm_name = f"{service['name']}-{metric['metric_name']}-alarm"

    cw.put_metric_alarm(
        AlarmName=alarm_name,
        Namespace=service["namespace"],
        MetricName=metric["metric_name"],
        Statistic=metric["statistic"],
        Period=metric["period"],
        EvaluationPeriods=1,
        Threshold=metric["threshold"],
        ComparisonOperator=metric["comparison"],
        AlarmActions=[],  # Add SNS ARN here
        Dimensions=[],
    )

    print(f"Created alarm: {alarm_name}")

def create_widget(service, metric, y_position):
    return {
        "type": "metric",
        "x": 0,
        "y": y_position,
        "width": 24,
        "height": 6,
        "properties": {
            "metrics": [
                [
                    service["namespace"],
                    metric["metric_name"]
                ]
            ],
            "period": metric["period"],
            "stat": metric["statistic"],
            "region": region,
            "title": f"{service['name']} - {metric['metric_name']}"
        }
    }

def main():
    y_position = 0

    for service in config["services"]:
        for metric in service["metrics"]:
            create_alarm(service, metric)
            widgets.append(create_widget(service, metric, y_position))
            y_position += 6

    dashboard_body = json.dumps({
        "widgets": widgets
    })

    cw.put_dashboard(
        DashboardName=dashboard_name,
        DashboardBody=dashboard_body
    )

    print(f"Dashboard created/updated: {dashboard_name}")

if __name__ == "__main__":
    main()
```

---

## 📌 Run

```bash
python3 cw_dashboard_alarm_creator.py
```

---

## 📊 What This Script Creates

| Component       | Created             |
| --------------- | ------------------- |
| Dashboard       | With metric widgets |
| Alarms          | Per service metric  |
| Threshold rules | From YAML           |
| Multi-service   | Supported           |

---

## 🔎 What It Automates

Instead of manually:

* Creating alarms in console
* Creating dashboard widgets
* Setting thresholds

You define everything in YAML.

---

## 🚀 Production Improvements

### 1️⃣ Add SNS Alarm Actions

Update:

```python
AlarmActions=["arn:aws:sns:ap-south-1:123456789012:alerts-topic"]
```

---

### 2️⃣ Add Dimensions Support

Extend YAML:

```yaml
dimensions:
  LoadBalancer: app/my-lb
```

Modify script to pass:

```python
Dimensions=[{"Name": k, "Value": v} for k, v in metric["dimensions"].items()]
```

---

### 3️⃣ Add Composite Alarms

Use:

```python
put_composite_alarm()
```

---

### 4️⃣ Idempotent Update Logic

CloudWatch overwrites dashboard automatically.
Alarms also updated via `put_metric_alarm`.

---

### 5️⃣ Deploy via Lambda + EventBridge

Run nightly to ensure monitoring drift detection.

---

## 🔥 Enterprise Architecture

| Level      | Approach                           |
| ---------- | ---------------------------------- |
| Small      | This script                        |
| Medium     | Terraform CloudWatch modules       |
| Large      | CDK monitoring stack               |
| Enterprise | Centralized Observability Platform |

---

## 💡 Interview Summary (2–3 lines)

> This script reads a YAML configuration defining services, metrics, and thresholds, and automatically creates CloudWatch dashboards and alarms using boto3. It enables monitoring as code and ensures consistent observability across environments.

---

If you want, I can provide:

* Terraform equivalent module
* CDK version
* Multi-account monitoring setup
* SNS + Slack integration version
* Fully production-hardened version with tagging & IAM validation
----
## Q39: Python Script — Synthetic Monitoring (User Journey Simulation + SLA Check + Alerting)

---

### 🧠 Objective

* Simulate real user journey:

  * Login
  * Navigate
  * API call
* Measure response time per step
* Validate HTTP status
* Check SLA thresholds
* Send Slack alert if:

  * Any step fails
  * SLA exceeded

---

## 📌 Assumptions

| Item           | Example                                    |
| -------------- | ------------------------------------------ |
| Base URL       | [https://example.com](https://example.com) |
| Login Endpoint | /login                                     |
| Dashboard      | /dashboard                                 |
| API            | /api/orders                                |
| SLA Threshold  | 2 seconds                                  |
| Alert          | Slack webhook                              |

---

## ✅ Install Dependencies

```bash
pip install requests
```

---

## ✅ Python Script (`synthetic_monitor.py`)

```python
import requests
import time
from datetime import datetime

BASE_URL = "https://example.com"
SLACK_WEBHOOK = "https://hooks.slack.com/services/XXX"
SLA_THRESHOLD = 2  # seconds

session = requests.Session()

def send_alert(message):
    requests.post(SLACK_WEBHOOK, json={"text": message})

def run_step(name, method, url, **kwargs):
    start = time.time()
    try:
        response = session.request(method, url, timeout=10, **kwargs)
        duration = time.time() - start

        if response.status_code != 200:
            raise Exception(f"HTTP {response.status_code}")

        if duration > SLA_THRESHOLD:
            raise Exception(f"SLA exceeded: {duration:.2f}s")

        print(f"[PASS] {name} ({duration:.2f}s)")
        return duration

    except Exception as e:
        error_msg = f"[FAIL] {name}: {str(e)}"
        print(error_msg)
        raise

def main():
    journey_results = {}
    start_time = datetime.utcnow()

    try:
        # Step 1: Login
        journey_results["login"] = run_step(
            "Login",
            "POST",
            f"{BASE_URL}/login",
            json={"username": "testuser", "password": "password"}
        )

        # Step 2: Access Dashboard
        journey_results["dashboard"] = run_step(
            "Dashboard",
            "GET",
            f"{BASE_URL}/dashboard"
        )

        # Step 3: Call Orders API
        journey_results["orders_api"] = run_step(
            "Orders API",
            "GET",
            f"{BASE_URL}/api/orders"
        )

        print("User journey successful.")

    except Exception as e:
        alert_message = (
            f"🚨 Synthetic Monitoring Failure\n"
            f"Time: {start_time}\n"
            f"Error: {str(e)}"
        )
        send_alert(alert_message)
        return

    # SLA Summary
    summary = "\n".join(
        [f"{k}: {v:.2f}s" for k, v in journey_results.items()]
    )

    print("Synthetic monitoring completed successfully.")
    print(summary)

if __name__ == "__main__":
    main()
```

---

## 📌 Run

```bash
python3 synthetic_monitor.py
```

---

## 📊 Example Output

```
[PASS] Login (0.45s)
[PASS] Dashboard (0.30s)
[PASS] Orders API (0.60s)
User journey successful.
```

If SLA breach:

```
[FAIL] Dashboard: SLA exceeded: 2.75s
```

Slack alert sent.

---

## 🔎 What This Script Validates

| Check              | Validated   |
| ------------------ | ----------- |
| HTTP status        | Must be 200 |
| SLA threshold      | < 2 seconds |
| Sequential journey | Yes         |
| Failure stops flow | Yes         |

---

## 🚀 Production Improvements

### 1️⃣ Add Retry Logic

Retry step before failing:

```python
for i in range(3):
    try:
        ...
```

---

### 2️⃣ Track P95 Over Time

Store metrics in:

* Prometheus Pushgateway
* CloudWatch custom metric

---

### 3️⃣ Add Authentication Token Handling

Extract JWT from login response.

---

### 4️⃣ Run as Kubernetes CronJob

```yaml
schedule: "*/5 * * * *"
```

---

### 5️⃣ Enterprise Alternative (Recommended)

Instead of custom script:

| Tool                         | Purpose               |
| ---------------------------- | --------------------- |
| Prometheus Blackbox Exporter | HTTP synthetic checks |
| Grafana Synthetic Monitoring | SaaS synthetic        |
| AWS CloudWatch Synthetics    | Canary tests          |
| Datadog Synthetics           | Advanced journeys     |

---

## 🔥 Enterprise Architecture

```
Synthetic Script → Push metrics → Prometheus → Alertmanager → Slack
```

or

```
CloudWatch Synthetics → Alarm → SNS → Slack
```

---

## 💡 Interview Summary (2–3 lines)

> This script simulates a real user journey, measures response times, validates SLA thresholds, and alerts if any step fails. It provides proactive monitoring beyond simple uptime checks.

---

If you want, I can provide:

* Multi-region synthetic monitoring version
* Prometheus metrics exporter version
* CloudWatch Synthetics equivalent
* Kubernetes CronJob YAML
* Enterprise-grade parallel journey testing version

----
## Q40: Python Script — Correlate Logs + Metrics + Deployment Events → Identify Probable Root Cause

---

### 🧠 Objective

Automatically correlate:

* 📝 Application logs (errors/spikes)
* 📊 Infrastructure metrics (CPU, memory, latency)
* 🚀 Deployment events (recent releases)

And determine:

> Most probable root cause of production incident

---

## 📌 Assumptions

| Source           | Example         |
| ---------------- | --------------- |
| Logs             | CloudWatch Logs |
| Metrics          | Prometheus      |
| Deployments      | Kubernetes      |
| Time window      | Last 15 minutes |
| Incident trigger | High error rate |

---

## ✅ Install Dependencies

```bash
pip install boto3 requests kubernetes
```

---

## ✅ Python Script (`incident_root_cause_analyzer.py`)

```python
import boto3
import requests
from kubernetes import client, config
from datetime import datetime, timedelta

# Config
LOG_GROUP = "/aws/app/prod"
PROM_URL = "http://prometheus:9090"
TIME_WINDOW_MIN = 15
ERROR_THRESHOLD = 20

logs_client = boto3.client("logs")

def get_recent_logs():
    start_time = int((datetime.utcnow() - timedelta(minutes=TIME_WINDOW_MIN)).timestamp() * 1000)

    response = logs_client.filter_log_events(
        logGroupName=LOG_GROUP,
        startTime=start_time,
        filterPattern="ERROR"
    )

    return response.get("events", [])

def analyze_log_spike(events):
    return len(events) > ERROR_THRESHOLD

def get_cpu_spike():
    query = 'avg(rate(node_cpu_seconds_total{mode!="idle"}[5m]))'
    response = requests.get(f"{PROM_URL}/api/v1/query", params={"query": query})
    result = response.json()

    if result["data"]["result"]:
        value = float(result["data"]["result"][0]["value"][1])
        return value > 0.8  # 80% CPU threshold

    return False

def get_recent_deployments():
    try:
        config.load_incluster_config()
    except:
        config.load_kube_config()

    apps_v1 = client.AppsV1Api()
    deployments = apps_v1.list_deployment_for_all_namespaces()

    recent = []

    cutoff = datetime.utcnow() - timedelta(minutes=TIME_WINDOW_MIN)

    for deploy in deployments.items:
        creation = deploy.metadata.creation_timestamp.replace(tzinfo=None)
        if creation > cutoff:
            recent.append(deploy.metadata.name)

    return recent

def main():
    print("Analyzing incident signals...")

    logs = get_recent_logs()
    log_spike = analyze_log_spike(logs)
    cpu_spike = get_cpu_spike()
    recent_deploys = get_recent_deployments()

    print(f"Log spike detected: {log_spike}")
    print(f"CPU spike detected: {cpu_spike}")
    print(f"Recent deployments: {recent_deploys}")

    # Correlation Logic
    if log_spike and recent_deploys:
        root_cause = "Recent deployment likely introduced errors."
    elif log_spike and cpu_spike:
        root_cause = "Infrastructure resource exhaustion (CPU spike)."
    elif cpu_spike and not recent_deploys:
        root_cause = "High system load without deployment changes."
    else:
        root_cause = "Unable to determine root cause. Further investigation required."

    print("\nProbable Root Cause:")
    print(root_cause)

if __name__ == "__main__":
    main()
```

---

## 📊 Correlation Logic Used

| Signal                      | Interpretation |
| --------------------------- | -------------- |
| Error spike + recent deploy | Bad release    |
| Error spike + CPU spike     | Infra overload |
| CPU spike only              | Traffic surge  |
| None clear                  | Unknown cause  |

---

## 📌 Example Output

```
Log spike detected: True
CPU spike detected: False
Recent deployments: ['api-v2']

Probable Root Cause:
Recent deployment likely introduced errors.
```

---

## 🚀 Production Improvements

### 1️⃣ Use Prometheus Query Range (Better Trend Analysis)

```python
/api/v1/query_range
```

Analyze slope instead of single snapshot.

---

### 2️⃣ Add Memory + Disk + Latency Correlation

Add PromQL:

```
node_memory_MemAvailable_bytes
http_request_duration_seconds
```

---

### 3️⃣ Use Deployment Revision Instead of Creation Timestamp

Check:

```python
deploy.metadata.annotations["deployment.kubernetes.io/revision"]
```

---

### 4️⃣ Add Slack Alert with RCA Summary

---

### 5️⃣ Add ML-Based Pattern Detection

* Isolation Forest
* Statistical anomaly detection
* Log pattern clustering

---

## 🔥 Enterprise-Grade Architecture

```
Logs (CloudWatch / ELK)
      +
Metrics (Prometheus)
      +
Deploy Events (ArgoCD / K8s)
      ↓
Correlation Engine (Lambda / Service)
      ↓
Slack / PagerDuty RCA Summary
```

---

## 🚀 Recommended Production Tooling Instead of Custom Script

| Category       | Tool                |
| -------------- | ------------------- |
| Logs           | ELK / OpenSearch    |
| Metrics        | Prometheus + Thanos |
| APM            | Datadog / NewRelic  |
| RCA Engine     | Moogsoft / BigPanda |
| ML Correlation | Dynatrace           |

---

## 💡 Interview Summary (2–3 lines)

> This script correlates application error spikes, infrastructure metrics, and recent deployment events to infer the most probable root cause of a production incident. It demonstrates automated observability signal correlation for faster incident response.

---

If you want, I can provide:

* Enterprise-grade correlation engine
* Slack-integrated RCA bot
* Prometheus-only version
* ML-based anomaly detection version
* Full SRE automation blueprint
----
## Q41: Python Script — Scan Running Docker Containers with Trivy → Group by Severity → Fail on Critical

---

### 🧠 Objective

* Detect all **running Docker containers**
* Extract unique images
* Scan images using **Trivy**
* Group vulnerabilities by severity
* Generate JSON risk report
* Exit with failure if **CRITICAL** vulns exist (CI/CD ready)

---

## 📌 Assumptions

| Requirement     | Value                      |
| --------------- | -------------------------- |
| Trivy Installed | Yes                        |
| Docker Running  | Yes                        |
| Output Format   | JSON                       |
| Fail Condition  | Any CRITICAL vulnerability |

---

## ✅ Install Requirements

```bash
pip install docker
```

> Trivy must be installed on host:

```bash
trivy --version
```

---

## ✅ Python Script (`docker_trivy_scanner.py`)

```python
import subprocess
import json
import docker
from collections import defaultdict
from datetime import datetime
import sys

OUTPUT_FILE = f"docker_risk_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"

def get_running_images():
    client = docker.from_env()
    containers = client.containers.list()
    images = list(set(container.image.tags[0] for container in containers if container.image.tags))
    return images

def scan_image(image):
    print(f"Scanning image: {image}")

    result = subprocess.run(
        ["trivy", "image", "--quiet", "--format", "json", image],
        capture_output=True,
        text=True
    )

    if result.returncode not in [0, 5]:  # 5 means vulnerabilities found
        print(f"Error scanning image: {image}")
        return None

    return json.loads(result.stdout)

def process_results(scan_results):
    severity_summary = defaultdict(int)
    details = []

    for result in scan_results:
        if not result:
            continue

        for target in result.get("Results", []):
            for vuln in target.get("Vulnerabilities", []):
                severity = vuln.get("Severity")
                severity_summary[severity] += 1

                details.append({
                    "image": result.get("ArtifactName"),
                    "package": vuln.get("PkgName"),
                    "severity": severity,
                    "vulnerability_id": vuln.get("VulnerabilityID"),
                    "title": vuln.get("Title")
                })

    return severity_summary, details

def main():
    images = get_running_images()

    if not images:
        print("No running containers found.")
        sys.exit(0)

    all_results = []
    for image in images:
        result = scan_image(image)
        all_results.append(result)

    severity_summary, details = process_results(all_results)

    report = {
        "generated_at": datetime.utcnow().isoformat(),
        "images_scanned": images,
        "severity_summary": dict(severity_summary),
        "details": details
    }

    with open(OUTPUT_FILE, "w") as f:
        json.dump(report, f, indent=2)

    print(f"Risk report generated: {OUTPUT_FILE}")
    print("Severity Summary:")
    print(json.dumps(severity_summary, indent=2))

    # Fail if CRITICAL vulnerabilities exist
    if severity_summary.get("CRITICAL", 0) > 0:
        print("CRITICAL vulnerabilities detected. Failing.")
        sys.exit(1)

    print("No critical vulnerabilities found.")
    sys.exit(0)

if __name__ == "__main__":
    main()
```

---

## 📌 Run

```bash
python3 docker_trivy_scanner.py
```

---

## 📊 Example Output

```json
{
  "CRITICAL": 2,
  "HIGH": 5,
  "MEDIUM": 10,
  "LOW": 3
}
```

If CRITICAL > 0:

```
CRITICAL vulnerabilities detected. Failing.
```

Exit code: `1`

---

## 🔎 What This Script Does

| Step                  | Action            |
| --------------------- | ----------------- |
| Discover containers   | Docker SDK        |
| Extract images        | Unique image list |
| Scan images           | Trivy JSON mode   |
| Parse vulnerabilities | Group by severity |
| Generate report       | JSON file         |
| Enforce policy        | Fail on CRITICAL  |

---

## 🚀 Production Improvements

### 1️⃣ Use Trivy Exit Code Directly

Instead of parsing:

```bash
trivy image --exit-code 1 --severity CRITICAL image
```

---

### 2️⃣ Add Slack Alert on Critical

---

### 3️⃣ Run in CI Instead of Prod Node

Best practice:

* Scan image in CI before push
* Not on running container host

---

### 4️⃣ Scan Filesystem & Config

```bash
trivy fs /
trivy config .
```

---

### 5️⃣ Store Results in Security Dashboard

Push to:

* S3
* ELK
* Security Hub

---

## 🔥 Enterprise Architecture

| Stage      | Recommended  |
| ---------- | ------------ |
| Build      | Trivy scan   |
| Registry   | ECR scan     |
| Runtime    | Falco        |
| Governance | Security Hub |
| Policy     | OPA          |

---

## 💡 Interview Summary (2–3 lines)

> This script scans all running Docker container images using Trivy, aggregates vulnerabilities by severity, generates a risk report, and fails execution if critical vulnerabilities are found. It enables automated security enforcement in CI/CD pipelines.

---

If you want, I can provide:

* CI pipeline integration version
* ECR image scanning automation
* Slack-integrated version
* Kubernetes cluster-wide scan version
* Enterprise-grade security reporting dashboard version
----
## Q42: Bash Script — Audit SSH Configuration Across Multiple Servers & Generate Remediation Report

---

### 🧠 Objective

* Connect to multiple servers via SSH
* Audit:

  * Root login enabled
  * Password authentication enabled
  * Weak/legacy ciphers
  * Weak MACs / KEX algorithms
* Generate structured remediation report
* CI / Security audit ready

---

## 📌 Assumptions

| Item                      | Value                |
| ------------------------- | -------------------- |
| Access Method             | SSH key-based        |
| SSH Config Path           | /etc/ssh/sshd_config |
| Server List               | servers.txt          |
| Output                    | HTML + text report   |
| No sudo password required | Yes                  |

---

## 📄 Example `servers.txt`

```
ubuntu@10.0.1.10
ubuntu@10.0.1.11
ec2-user@10.0.2.20
```

---

## ✅ Script: `ssh_audit.sh`

```bash
#!/bin/bash

SERVER_LIST="servers.txt"
OUTPUT_FILE="ssh_audit_report_$(date +%F_%H%M%S).html"

echo "<html><head><title>SSH Audit Report</title></head><body>" > "$OUTPUT_FILE"
echo "<h1>SSH Security Audit Report</h1>" >> "$OUTPUT_FILE"
echo "<p>Generated: $(date)</p>" >> "$OUTPUT_FILE"
echo "<table border='1' cellpadding='5'>" >> "$OUTPUT_FILE"
echo "<tr><th>Server</th><th>Root Login</th><th>Password Auth</th><th>Weak Ciphers</th><th>Weak MACs</th><th>Weak KEX</th></tr>" >> "$OUTPUT_FILE"

while read -r SERVER; do
  echo "Auditing $SERVER..."

  CONFIG=$(ssh -o BatchMode=yes -o ConnectTimeout=5 "$SERVER" "cat /etc/ssh/sshd_config 2>/dev/null")

  if [ $? -ne 0 ]; then
    echo "<tr><td>$SERVER</td><td colspan='5'>Connection Failed</td></tr>" >> "$OUTPUT_FILE"
    continue
  fi

  ROOT_LOGIN=$(echo "$CONFIG" | grep -i "^PermitRootLogin" | awk '{print $2}')
  PASSWORD_AUTH=$(echo "$CONFIG" | grep -i "^PasswordAuthentication" | awk '{print $2}')
  CIPHERS=$(echo "$CONFIG" | grep -i "^Ciphers")
  MACS=$(echo "$CONFIG" | grep -i "^MACs")
  KEX=$(echo "$CONFIG" | grep -i "^KexAlgorithms")

  # Evaluate Weak Settings
  ROOT_STATUS="OK"
  PASS_STATUS="OK"
  CIPHER_STATUS="OK"
  MAC_STATUS="OK"
  KEX_STATUS="OK"

  if [[ "$ROOT_LOGIN" != "no" ]]; then
    ROOT_STATUS="❌ Enabled"
  fi

  if [[ "$PASSWORD_AUTH" != "no" ]]; then
    PASS_STATUS="❌ Enabled"
  fi

  if echo "$CIPHERS" | grep -qiE "cbc|3des"; then
    CIPHER_STATUS="❌ Weak"
  fi

  if echo "$MACS" | grep -qiE "hmac-md5"; then
    MAC_STATUS="❌ Weak"
  fi

  if echo "$KEX" | grep -qiE "diffie-hellman-group1-sha1"; then
    KEX_STATUS="❌ Weak"
  fi

  echo "<tr>
        <td>$SERVER</td>
        <td>$ROOT_STATUS</td>
        <td>$PASS_STATUS</td>
        <td>$CIPHER_STATUS</td>
        <td>$MAC_STATUS</td>
        <td>$KEX_STATUS</td>
        </tr>" >> "$OUTPUT_FILE"

done < "$SERVER_LIST"

echo "</table></body></html>" >> "$OUTPUT_FILE"

echo "SSH audit completed. Report: $OUTPUT_FILE"
```

---

## 📌 Run

```bash
chmod +x ssh_audit.sh
./ssh_audit.sh
```

---

## 📊 What This Script Checks

| Setting                | Secure Value                  |
| ---------------------- | ----------------------------- |
| PermitRootLogin        | no                            |
| PasswordAuthentication | no                            |
| Ciphers                | No CBC / 3DES                 |
| MACs                   | No hmac-md5                   |
| KexAlgorithms          | No diffie-hellman-group1-sha1 |

---

## 🚀 Sample Report Output (HTML)

| Server    | Root Login | Password Auth | Weak Ciphers | Weak MACs | Weak KEX |
| --------- | ---------- | ------------- | ------------ | --------- | -------- |
| 10.0.1.10 | ❌ Enabled  | OK            | ❌ Weak       | OK        | OK       |

---

## 🔐 Remediation Recommendations

Add to `/etc/ssh/sshd_config`:

```bash
PermitRootLogin no
PasswordAuthentication no

Ciphers aes256-gcm@openssh.com,aes256-ctr
MACs hmac-sha2-512,hmac-sha2-256
KexAlgorithms curve25519-sha256@libssh.org
```

Then:

```bash
sudo systemctl restart sshd
```

---

## 🚀 Production Improvements

### 1️⃣ Use sshd -T Instead of Raw Config

More accurate:

```bash
sshd -T
```

---

### 2️⃣ Parallel Execution

```bash
cat servers.txt | xargs -P5 -I{} ssh {} ...
```

---

### 3️⃣ Add CIS Benchmark Checks

Check:

* ClientAliveInterval
* LoginGraceTime
* MaxAuthTries

---

### 4️⃣ Export JSON Instead of HTML

---

### 5️⃣ Enterprise Alternative

Instead of custom script:

| Tool                   | Purpose            |
| ---------------------- | ------------------ |
| OpenSCAP               | Compliance         |
| CIS-CAT                | Benchmarking       |
| AWS Inspector          | EC2 assessment     |
| Ansible audit playbook | Config enforcement |

---

## 🔥 Enterprise Architecture

```
Servers → SSH Audit Script → Report → Security Dashboard → Remediation Automation
```

Or:

```
Ansible Playbook → Enforce SSH Hardening
```

---

## 💡 Interview Summary (2–3 lines)

> This script connects to multiple servers via SSH, audits sshd configuration for weak security settings such as root login and legacy ciphers, and generates a remediation report. It helps enforce SSH hardening across infrastructure.

---

If you want, I can provide:

* Ansible-based SSH compliance playbook
* CIS benchmark audit version
* Auto-remediation script
* Parallel high-scale audit version
* CI-integrated SSH compliance check
----
## Q43: Python Script — AWS Config Non-Compliant Resources → Auto Tag → Notify Owner

---

### 🧠 Objective

* Query AWS Config for **NON_COMPLIANT** resources
* Tag each resource with:

  ```
  Compliance=Violation
  ComplianceRule=<rule-name>
  ```
* Identify resource owner (from `Owner` tag)
* Notify owner via SNS (or SES)
* CI / Lambda ready

---

## 📌 Assumptions

| Item               | Example                                               |
| ------------------ | ----------------------------------------------------- |
| Region             | ap-south-1                                            |
| SNS Topic          | arn:aws:sns:ap-south-1:123456789012:compliance-alerts |
| Owner Tag          | Owner=[email@example.com](mailto:email@example.com)   |
| AWS Config Enabled | Yes                                                   |

---

## ✅ Required IAM Permissions

```json
{
  "Effect": "Allow",
  "Action": [
    "config:GetComplianceDetailsByConfigRule",
    "config:DescribeConfigRules",
    "resourcegroupstaggingapi:GetResources",
    "tag:TagResources",
    "sns:Publish"
  ],
  "Resource": "*"
}
```

---

## ✅ Install

```bash
pip install boto3
```

---

## ✅ Python Script (`aws_config_auto_tag_notify.py`)

```python
import boto3
from datetime import datetime

REGION = "ap-south-1"
SNS_TOPIC_ARN = "arn:aws:sns:ap-south-1:123456789012:compliance-alerts"

config_client = boto3.client("config", region_name=REGION)
sns_client = boto3.client("sns", region_name=REGION)
tag_client = boto3.client("resourcegroupstaggingapi", region_name=REGION)

def get_non_compliant_resources(rule_name):
    paginator = config_client.get_paginator("get_compliance_details_by_config_rule")

    resources = []
    for page in paginator.paginate(
        ConfigRuleName=rule_name,
        ComplianceTypes=["NON_COMPLIANT"]
    ):
        resources.extend(page["EvaluationResults"])

    return resources

def tag_resource(resource_arn, rule_name):
    tag_client.tag_resources(
        ResourceARNList=[resource_arn],
        Tags={
            "Compliance": "Violation",
            "ComplianceRule": rule_name,
            "ViolationTimestamp": datetime.utcnow().isoformat()
        }
    )

def get_owner_tag(resource_arn):
    response = tag_client.get_resources(
        ResourceARNList=[resource_arn]
    )

    if response["ResourceTagMappingList"]:
        tags = response["ResourceTagMappingList"][0]["Tags"]
        for tag in tags:
            if tag["Key"] == "Owner":
                return tag["Value"]
    return None

def notify_owner(owner_email, resource_id, rule_name):
    message = f"""
Resource: {resource_id}
Compliance Rule: {rule_name}
Status: NON_COMPLIANT

Please remediate immediately.
"""

    sns_client.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject="Compliance Violation Detected",
        Message=message
    )

def main():
    rules = config_client.describe_config_rules()["ConfigRules"]

    for rule in rules:
        rule_name = rule["ConfigRuleName"]
        print(f"Checking rule: {rule_name}")

        resources = get_non_compliant_resources(rule_name)

        for res in resources:
            resource_id = res["EvaluationResultIdentifier"]["EvaluationResultQualifier"]["ResourceId"]
            resource_type = res["EvaluationResultIdentifier"]["EvaluationResultQualifier"]["ResourceType"]

            resource_arn = f"arn:aws:{resource_type.lower()}:{REGION}:::{resource_id}"

            print(f"Non-compliant resource: {resource_id}")

            # Tag resource
            tag_resource(resource_arn, rule_name)

            # Notify owner
            owner = get_owner_tag(resource_arn)
            if owner:
                notify_owner(owner, resource_id, rule_name)

    print("Compliance enforcement completed.")

if __name__ == "__main__":
    main()
```

---

## 📌 Run

```bash
python3 aws_config_auto_tag_notify.py
```

---

## 🔎 What This Script Does

| Step                          | Action                   |
| ----------------------------- | ------------------------ |
| List Config rules             | describe_config_rules    |
| Fetch non-compliant resources | get_compliance_details   |
| Tag resource                  | tag_resources            |
| Get Owner tag                 | resourcegroupstaggingapi |
| Notify                        | SNS publish              |

---

## 🚀 Production Improvements

### 1️⃣ Use Proper ARN Construction

Instead of manual ARN building:

* Use `res["EvaluationResultIdentifier"]["EvaluationResultQualifier"]["ResourceType"]`
* Map to ARN correctly per service

---

### 2️⃣ Use SES for Direct Email Instead of SNS

```python
ses.send_email()
```

---

### 3️⃣ Multi-Account Support

* AssumeRole into child accounts
* Run from central compliance account

---

### 4️⃣ Avoid Re-Tagging Already Tagged Resources

Check existing tag before tagging.

---

### 5️⃣ Auto-Remediation Option

Instead of only tagging:

* Trigger SSM Automation
* Trigger Lambda remediation
* Integrate with ServiceNow

---

## 🔥 Enterprise Architecture

```
AWS Config → Lambda → Tag → SNS → Slack / Email
                     ↓
              Auto Remediation
```

---

## 🚀 Enterprise Best Practice

| Level      | Approach                   |
| ---------- | -------------------------- |
| Small      | Script-based               |
| Medium     | Lambda auto-remediation    |
| Large      | Config + SSM Automation    |
| Enterprise | Control Tower + Guardrails |

---

## 💡 Interview Summary (2–3 lines)

> This script queries AWS Config for non-compliant resources, automatically tags them with compliance violation labels, and notifies resource owners via SNS. It enables automated governance enforcement and improves compliance visibility.

---

If you want, I can provide:

* Lambda-ready version
* Multi-account Organization-wide version
* SES direct email version
* Slack-integrated version
* Auto-remediation workflow using SSM

----
## Q44: Python Script — Scan All GitHub Org Repositories for Hardcoded Secrets & Generate Security Report

---

### 🧠 Objective

* Scan **all repositories** in a GitHub organization
* Clone or fetch content via GitHub API
* Detect hardcoded secrets using regex patterns
* Generate structured security findings report (JSON)
* CI / security audit ready

---

## 📌 Assumptions

| Item        | Example                      |
| ----------- | ---------------------------- |
| GitHub Org  | my-org                       |
| Auth        | GitHub Personal Access Token |
| Scan Method | Regex pattern matching       |
| Output      | JSON report                  |

---

## 🔐 Example Secret Patterns

| Secret Type     | Regex Pattern                                |                                         |                            |
| --------------- | -------------------------------------------- | --------------------------------------- | -------------------------- |
| AWS Access Key  | `AKIA[0-9A-Z]{16}`                           |                                         |                            |
| AWS Secret      | `(?i)aws(.{0,20})?(secret                    | key)[^a-zA-Z0-9]{0,5}[0-9a-zA-Z/+]{40}` |                            |
| Generic API Key | `(?i)(api[_-]?key)["'\s:=]+[0-9a-zA-Z]{16,}` |                                         |                            |
| Private Key     | `-----BEGIN (RSA                             | EC                                      | OPENSSH) PRIVATE KEY-----` |
| Slack Token     | `xox[baprs]-[0-9a-zA-Z]{10,}`                |                                         |                            |

---

## ✅ Install Dependencies

```bash
pip install requests
```

---

## ✅ Python Script (`github_secret_scanner.py`)

```python
import requests
import re
import base64
import json
from datetime import datetime

GITHUB_TOKEN = "ghp_xxx"
ORG_NAME = "my-org"
HEADERS = {"Authorization": f"token {GITHUB_TOKEN}"}

OUTPUT_FILE = f"github_secret_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"

SECRET_PATTERNS = {
    "AWS Access Key": r"AKIA[0-9A-Z]{16}",
    "AWS Secret Key": r"(?i)aws(.{0,20})?(secret|key)[^a-zA-Z0-9]{0,5}[0-9a-zA-Z/+]{40}",
    "Generic API Key": r"(?i)(api[_-]?key)[\"'\s:=]+[0-9a-zA-Z]{16,}",
    "Private Key": r"-----BEGIN (RSA|EC|OPENSSH) PRIVATE KEY-----",
    "Slack Token": r"xox[baprs]-[0-9a-zA-Z]{10,}"
}

def get_repos():
    repos = []
    page = 1

    while True:
        url = f"https://api.github.com/orgs/{ORG_NAME}/repos?page={page}&per_page=100"
        response = requests.get(url, headers=HEADERS)
        data = response.json()

        if not data:
            break

        repos.extend(data)
        page += 1

    return repos

def get_repo_files(repo_name):
    url = f"https://api.github.com/repos/{ORG_NAME}/{repo_name}/git/trees/main?recursive=1"
    response = requests.get(url, headers=HEADERS)

    if response.status_code != 200:
        return []

    return response.json().get("tree", [])

def scan_file(repo_name, file_path):
    url = f"https://api.github.com/repos/{ORG_NAME}/{repo_name}/contents/{file_path}"
    response = requests.get(url, headers=HEADERS)

    if response.status_code != 200:
        return []

    content = response.json().get("content")
    if not content:
        return []

    decoded = base64.b64decode(content).decode(errors="ignore")

    findings = []

    for name, pattern in SECRET_PATTERNS.items():
        matches = re.findall(pattern, decoded)
        if matches:
            findings.append({
                "repo": repo_name,
                "file": file_path,
                "secret_type": name,
                "matches": len(matches)
            })

    return findings

def main():
    repos = get_repos()
    report = []

    for repo in repos:
        repo_name = repo["name"]
        print(f"Scanning repo: {repo_name}")

        files = get_repo_files(repo_name)

        for file in files:
            if file["type"] == "blob":
                file_path = file["path"]

                # Skip large/binary files
                if any(file_path.endswith(ext) for ext in [".png", ".jpg", ".zip", ".exe"]):
                    continue

                findings = scan_file(repo_name, file_path)
                report.extend(findings)

    output = {
        "generated_at": datetime.utcnow().isoformat(),
        "organization": ORG_NAME,
        "total_findings": len(report),
        "findings": report
    }

    with open(OUTPUT_FILE, "w") as f:
        json.dump(output, f, indent=2)

    print(f"Scan complete. Report: {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
```

---

## 📌 Run

```bash
python3 github_secret_scanner.py
```

---

## 📊 Sample Output (JSON)

```json
{
  "organization": "my-org",
  "total_findings": 3,
  "findings": [
    {
      "repo": "api-service",
      "file": "config.py",
      "secret_type": "AWS Access Key",
      "matches": 1
    }
  ]
}
```

---

## 🔎 What This Script Does

| Step            | Action           |
| --------------- | ---------------- |
| Fetch repos     | GitHub API       |
| List repo files | Recursive tree   |
| Decode file     | Base64 content   |
| Regex scan      | Pattern matching |
| Generate report | JSON output      |

---

## 🚀 Production Improvements

### 1️⃣ Use Local Clone Instead of API (Better)

Clone repo:

```bash
git clone --depth 1
```

Scan faster and avoid API rate limits.

---

### 2️⃣ Add Entropy Detection (High-Entropy Strings)

Use Shannon entropy to detect unknown secrets.

---

### 3️⃣ Skip Known Safe Files

Ignore:

* package-lock.json
* node_modules
* vendor/

---

### 4️⃣ Fail CI if Secrets Found

Add:

```python
if len(report) > 0:
    exit(1)
```

---

### 5️⃣ Enterprise Alternative (Recommended)

Instead of custom regex:

| Tool                   | Purpose                 |
| ---------------------- | ----------------------- |
| GitHub Secret Scanning | Native                  |
| TruffleHog             | High-entropy + patterns |
| Gitleaks               | Enterprise-grade        |
| GitGuardian            | SaaS                    |

---

## 🔥 Enterprise Architecture

```
GitHub Org → Secret Scanner → Security Report → Slack/SIEM → Remediation
```

Or integrate into:

```
Pre-commit → CI → Merge Block
```

---

## 💡 Interview Summary (2–3 lines)

> This script scans all repositories in a GitHub organization using the GitHub API, detects hardcoded secrets via regex patterns, and generates a security findings report. It can be integrated into CI to prevent secret leakage across repositories.

---

If you want, I can provide:

* CI-integrated version
* High-entropy detection version
* Slack alerting version
* Multi-branch scanner
* Enterprise-scale optimized version
---
## Q45: Bash Script — Certificate Expiry Monitoring + Alert + Auto Renewal (Let’s Encrypt)

---

### 🧠 Objective

* Check SSL certificate expiry for multiple domains
* Alert if expiry ≤ 30 days
* Automatically renew Let's Encrypt certificates
* Generate report
* CI / Cron ready

---

## 📌 Assumptions

| Item         | Value                     |
| ------------ | ------------------------- |
| Domains file | domains.txt               |
| Renewal Tool | certbot                   |
| Alert        | Email (or Slack optional) |
| Port         | 443                       |

---

## 📄 Example `domains.txt`

```
example.com
api.example.com
myapp.com
```

---

## ✅ Script: `cert_monitor.sh`

```bash
#!/bin/bash

DOMAINS_FILE="domains.txt"
THRESHOLD_DAYS=30
REPORT_FILE="cert_expiry_report_$(date +%F_%H%M%S).txt"
ALERT_EMAIL="admin@example.com"

echo "Certificate Expiry Report - $(date)" > "$REPORT_FILE"
echo "----------------------------------------" >> "$REPORT_FILE"

check_expiry() {
  DOMAIN=$1

  EXPIRY_DATE=$(echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null \
    | openssl x509 -noout -enddate | cut -d= -f2)

  if [ -z "$EXPIRY_DATE" ]; then
    echo "$DOMAIN - Unable to fetch certificate" >> "$REPORT_FILE"
    return
  fi

  EXPIRY_SECONDS=$(date -d "$EXPIRY_DATE" +%s)
  CURRENT_SECONDS=$(date +%s)

  DAYS_LEFT=$(( (EXPIRY_SECONDS - CURRENT_SECONDS) / 86400 ))

  echo "$DOMAIN - Expires in $DAYS_LEFT days" >> "$REPORT_FILE"

  if [ "$DAYS_LEFT" -le "$THRESHOLD_DAYS" ]; then
    echo "ALERT: $DOMAIN expires in $DAYS_LEFT days" >> "$REPORT_FILE"
    alert_and_renew "$DOMAIN"
  fi
}

alert_and_renew() {
  DOMAIN=$1

  echo "Attempting Let's Encrypt renewal for $DOMAIN..." >> "$REPORT_FILE"

  certbot renew --cert-name "$DOMAIN" --quiet

  if [ $? -eq 0 ]; then
    echo "Renewal successful for $DOMAIN" >> "$REPORT_FILE"
  else
    echo "Renewal failed for $DOMAIN" >> "$REPORT_FILE"
  fi

  echo "Certificate for $DOMAIN expiring soon." \
    | mail -s "SSL Expiry Alert - $DOMAIN" "$ALERT_EMAIL"
}

while read -r DOMAIN; do
  check_expiry "$DOMAIN"
done < "$DOMAINS_FILE"

echo "Monitoring complete. Report saved: $REPORT_FILE"
```

---

## 📌 Run

```bash
chmod +x cert_monitor.sh
./cert_monitor.sh
```

---

## ⏱ Schedule (Daily at 2 AM)

```bash
0 2 * * * /path/cert_monitor.sh
```

---

## 📊 Sample Report

```
example.com - Expires in 18 days
ALERT: example.com expires in 18 days
Renewal successful for example.com
```

---

## 🔎 What This Script Does

| Step                | Action           |
| ------------------- | ---------------- |
| Fetch certificate   | openssl s_client |
| Parse expiry        | openssl x509     |
| Calculate days left | date arithmetic  |
| Alert               | Email            |
| Renew               | certbot renew    |

---

## 🚀 Slack Alert Version

Replace email section:

```bash
curl -X POST -H 'Content-type: application/json' \
--data "{\"text\":\"SSL Expiry Alert: $DOMAIN ($DAYS_LEFT days left)\"}" \
$SLACK_WEBHOOK
```

---

## 🚀 Production Improvements

### 1️⃣ Check Local Cert Files Instead (Better for LE)

```bash
openssl x509 -enddate -noout -in /etc/letsencrypt/live/$DOMAIN/fullchain.pem
```

---

### 2️⃣ Reload Nginx After Renewal

```bash
systemctl reload nginx
```

---

### 3️⃣ Parallel Domain Checks

```bash
cat domains.txt | xargs -P5 -I{} ./cert_check {}
```

---

### 4️⃣ Monitor Wildcard Certs

Handle:

```
*.example.com
```

---

### 5️⃣ Enterprise Alternative

| Tool                | Recommended          |
| ------------------- | -------------------- |
| Prometheus Blackbox | SSL monitoring       |
| AWS ACM             | Managed certificates |
| Cert-Manager (K8s)  | Auto renewal         |
| Datadog             | Expiry alerts        |

---

## 🔥 Enterprise Architecture

```
Domains → SSL Check Script → Alert → Renewal → Reload → Report
```

Or Kubernetes:

```
cert-manager → Auto Renew → Prometheus Alert
```

---

## 💡 Interview Summary (2–3 lines)

> This script monitors SSL certificate expiry across multiple domains, alerts when certificates are within 30 days of expiry, and automatically triggers Let's Encrypt renewal using certbot. It enables proactive certificate lifecycle management.

---

If you want, I can provide:

* Kubernetes cert-manager version
* AWS ACM monitoring version
* Prometheus exporter version
* Multi-region enterprise monitoring version

----
## Q46: Automated Incident Response Workflow (Amazon-Style)

### 🧠 Objective

End-to-end automated incident response:

1. Detect anomaly from CloudWatch metric
2. Identify impacted EC2 instance
3. Isolate instance (Security Group quarantine)
4. Capture diagnostics (logs + system status)
5. Notify on-call with full context (SNS)

Production-ready pattern (Lambda / EventBridge compatible).

---

## 📌 Assumptions

| Item               | Example                                           |
| ------------------ | ------------------------------------------------- |
| Metric             | CPUUtilization                                    |
| Threshold          | > 85%                                             |
| Namespace          | AWS/EC2                                           |
| Isolation SG       | sg-quarantine                                     |
| SNS Topic          | arn:aws:sns:ap-south-1:123456789012:oncall-alerts |
| Diagnostics Bucket | incident-diagnostics-bucket                       |

---

## 🔐 Required IAM Permissions

```json
ec2:DescribeInstances
ec2:ModifyInstanceAttribute
ec2:CreateTags
cloudwatch:GetMetricData
logs:FilterLogEvents
sns:Publish
s3:PutObject
```

---

## ✅ Python Script (`automated_incident_response.py`)

```python
import boto3
import json
from datetime import datetime, timedelta

REGION = "ap-south-1"
THRESHOLD = 85
QUARANTINE_SG = "sg-xxxxxxxx"
SNS_TOPIC = "arn:aws:sns:ap-south-1:123456789012:oncall-alerts"
S3_BUCKET = "incident-diagnostics-bucket"

cw = boto3.client("cloudwatch", region_name=REGION)
ec2 = boto3.client("ec2", region_name=REGION)
sns = boto3.client("sns", region_name=REGION)
s3 = boto3.client("s3", region_name=REGION)

def detect_anomaly():
    end = datetime.utcnow()
    start = end - timedelta(minutes=5)

    response = cw.get_metric_statistics(
        Namespace="AWS/EC2",
        MetricName="CPUUtilization",
        StartTime=start,
        EndTime=end,
        Period=300,
        Statistics=["Average"]
    )

    if not response["Datapoints"]:
        return None

    datapoint = max(response["Datapoints"], key=lambda x: x["Timestamp"])
    if datapoint["Average"] > THRESHOLD:
        return True
    return False

def get_impacted_instances():
    response = ec2.describe_instances(
        Filters=[
            {"Name": "instance-state-name", "Values": ["running"]}
        ]
    )

    instances = []
    for r in response["Reservations"]:
        for i in r["Instances"]:
            instances.append(i["InstanceId"])

    return instances

def isolate_instance(instance_id):
    ec2.modify_instance_attribute(
        InstanceId=instance_id,
        Groups=[QUARANTINE_SG]
    )

    ec2.create_tags(
        Resources=[instance_id],
        Tags=[{"Key": "Incident", "Value": "Quarantined"}]
    )

def capture_diagnostics(instance_id):
    diagnostics = {
        "instance_id": instance_id,
        "timestamp": datetime.utcnow().isoformat(),
        "status": ec2.describe_instance_status(InstanceIds=[instance_id])
    }

    key = f"incident-{instance_id}-{datetime.utcnow().timestamp()}.json"

    s3.put_object(
        Bucket=S3_BUCKET,
        Key=key,
        Body=json.dumps(diagnostics, default=str)
    )

    return key

def notify_oncall(instance_id, s3_key):
    message = f"""
🚨 Incident Detected

Instance: {instance_id}
Isolation: Security Group Applied
Diagnostics: s3://{S3_BUCKET}/{s3_key}
Time: {datetime.utcnow().isoformat()}
"""

    sns.publish(
        TopicArn=SNS_TOPIC,
        Subject="Production Incident - Automated Response",
        Message=message
    )

def main():
    print("Checking for anomalies...")

    if not detect_anomaly():
        print("No anomaly detected.")
        return

    print("Anomaly detected. Identifying impacted instances...")

    instances = get_impacted_instances()

    for instance in instances:
        print(f"Isolating instance: {instance}")
        isolate_instance(instance)

        print("Capturing diagnostics...")
        s3_key = capture_diagnostics(instance)

        print("Notifying on-call...")
        notify_oncall(instance, s3_key)

    print("Incident response workflow completed.")

if __name__ == "__main__":
    main()
```

---

## 🔎 Workflow Summary

| Step                | Action                     |
| ------------------- | -------------------------- |
| Detect anomaly      | CPU > threshold            |
| Identify instances  | Running EC2                |
| Isolate             | Attach quarantine SG       |
| Tag                 | Mark as incident           |
| Capture diagnostics | Save instance status to S3 |
| Notify              | SNS alert                  |

---

## 🚀 Production Enhancements

### 1️⃣ Use CloudWatch Alarms → EventBridge

Trigger Lambda automatically instead of polling.

---

### 2️⃣ Better Isolation Strategy

Instead of replacing SG:

* Add quarantine SG (preserve original)
* Store original SG in tag for rollback

---

### 3️⃣ Capture More Diagnostics

* VPC Flow Logs
* CloudWatch Logs
* Memory dump via SSM
* EBS snapshot

---

### 4️⃣ Integrate With SSM

```python
ssm.send_command()
```

Run forensic commands automatically.

---

### 5️⃣ Add Auto-Recovery Option

After validation:

* Restore original SG
* Restart instance
* Scale replacement

---

## 🔥 Enterprise Architecture

```
CloudWatch Alarm
      ↓
EventBridge
      ↓
Lambda Incident Handler
      ↓
Quarantine + Snapshot + Diagnostics
      ↓
SNS / Slack / PagerDuty
      ↓
Security Team
```

---

## 🔥 Enterprise-Grade Add-ons

| Feature                  | Tool                         |
| ------------------------ | ---------------------------- |
| ML anomaly detection     | CloudWatch Anomaly Detection |
| Threat intel integration | GuardDuty                    |
| Forensics automation     | SSM Automation               |
| SOAR                     | AWS Security Hub             |
| Ticket creation          | ServiceNow API               |

---

## 💡 Interview Summary (2–3 lines)

> This script implements an automated incident response workflow by detecting CloudWatch anomalies, isolating impacted EC2 instances, capturing diagnostics to S3, and notifying on-call engineers via SNS. It demonstrates automation-driven SRE and security response.

---

If you want, I can provide:

* Lambda + EventBridge production version
* GuardDuty-integrated version
* Kubernetes incident automation version
* SOAR-style full remediation workflow
* Multi-account enterprise IR architecture

----
## Q47: Google-Style Canary Deployment Controller

**Auto promote on healthy metrics · Auto rollback on degradation**

---

### 🧠 Objective

Controller behavior:

1. Shift small traffic (e.g., 10%) to canary
2. Monitor:

   * Error rate
   * P95 latency
3. If healthy → increase traffic gradually → 100%
4. If degraded → rollback immediately
5. Fully automated decision loop

Production-style SRE logic.

---

## 📌 Assumptions

| Component         | Example                         |
| ----------------- | ------------------------------- |
| Platform          | Kubernetes                      |
| Traffic split     | Service mesh / weighted service |
| Metrics           | Prometheus                      |
| Canary Deployment | `myapp-canary`                  |
| Stable Deployment | `myapp-stable`                  |
| Service           | `myapp-service`                 |
| Error metric      | `http_requests_total`           |
| Latency metric    | `histogram_quantile(0.95, ...)` |

---

## 🚦 Promotion Strategy

```
10% → 25% → 50% → 100%
```

Health check window: 2 minutes per stage.

---

## ✅ Python Script (`canary_controller.py`)

```python
import requests
import time
import subprocess
import sys

PROM_URL = "http://prometheus:9090"
SERVICE = "myapp-service"
CANARY_DEPLOY = "myapp-canary"
NAMESPACE = "prod"

ERROR_THRESHOLD = 0.05      # 5%
LATENCY_THRESHOLD = 0.8     # 800ms
CHECK_INTERVAL = 30         # seconds
PROMOTION_STEPS = [10, 25, 50, 100]


def query_prometheus(query):
    r = requests.get(f"{PROM_URL}/api/v1/query", params={"query": query})
    data = r.json()
    if data["data"]["result"]:
        return float(data["data"]["result"][0]["value"][1])
    return 0


def get_error_rate():
    query = """
    sum(rate(http_requests_total{version="canary",status=~"5.."}[1m]))
    /
    sum(rate(http_requests_total{version="canary"}[1m]))
    """
    return query_prometheus(query)


def get_p95_latency():
    query = """
    histogram_quantile(0.95,
      sum(rate(http_request_duration_seconds_bucket{version="canary"}[1m]))
      by (le))
    """
    return query_prometheus(query)


def set_traffic_weight(weight):
    print(f"Setting canary traffic to {weight}%")

    subprocess.run([
        "kubectl", "patch", "svc", SERVICE,
        "-n", NAMESPACE,
        "-p",
        f'{{"spec":{{"selector":{{"version":"canary-{weight}"}}}}}}'
    ])


def rollback():
    print("Rolling back to stable...")
    subprocess.run([
        "kubectl", "rollout", "undo", "deployment", CANARY_DEPLOY,
        "-n", NAMESPACE
    ])
    sys.exit(1)


def promote():
    print("Promoting canary to stable...")
    subprocess.run([
        "kubectl", "set", "image", "deployment/myapp-stable",
        "myapp=myapp:canary",
        "-n", NAMESPACE
    ])
    print("Promotion complete.")
    sys.exit(0)


def health_check():
    error_rate = get_error_rate()
    latency = get_p95_latency()

    print(f"Error Rate: {error_rate:.4f}")
    print(f"P95 Latency: {latency:.4f}")

    if error_rate > ERROR_THRESHOLD:
        print("Error rate too high.")
        return False

    if latency > LATENCY_THRESHOLD:
        print("Latency too high.")
        return False

    return True


def main():
    print("Starting Canary Deployment Controller...")

    for weight in PROMOTION_STEPS:
        set_traffic_weight(weight)

        print("Monitoring metrics...")
        time.sleep(CHECK_INTERVAL)

        if not health_check():
            rollback()

        print(f"Stage {weight}% successful.")

    promote()


if __name__ == "__main__":
    main()
```

---

## 🔎 What This Script Does

| Step             | Action                   |
| ---------------- | ------------------------ |
| Shift traffic    | Increase canary weight   |
| Monitor metrics  | Prometheus queries       |
| Check thresholds | Error + P95              |
| Rollback         | kubectl undo             |
| Promote          | Update stable deployment |

---

## 📊 Decision Logic

| Condition             | Action       |
| --------------------- | ------------ |
| Error > 5%            | Rollback     |
| P95 > 800ms           | Rollback     |
| Healthy at all stages | Promote 100% |

---

## 🚀 Production Improvements

### 1️⃣ Use Service Mesh Instead of Selector Hack

Recommended:

* Istio VirtualService weighted routing
* NGINX ingress canary annotations

---

### 2️⃣ Add Statistical Comparison

Compare canary vs stable:

```
canary_error_rate > stable_error_rate * 1.5
```

---

### 3️⃣ Add Burn Rate SLO Check

Use multi-window error budget:

```
error_budget_burn_rate > 2
```

---

### 4️⃣ Use Argo Rollouts (Enterprise Best Practice)

Instead of custom script:

```yaml
analysis:
  metrics:
    - name: error-rate
      provider:
        prometheus:
```

---

### 5️⃣ Add Slack Alerting

---

## 🔥 Enterprise Architecture

```
Deployment → Canary 10%
      ↓
Prometheus Metrics
      ↓
Controller Decision Engine
      ↓
Promote OR Rollback
      ↓
Notify SRE
```

---

## 🔥 Google-Style Enhancements

| Feature             | Why                   |
| ------------------- | --------------------- |
| SLO-based gating    | Not just raw metrics  |
| Automated rollback  | Reduce MTTR           |
| Progressive traffic | Minimize blast radius |
| Metric comparison   | Canary vs baseline    |
| Error budget aware  | SRE-aligned           |

---

## 💡 Interview Summary (2–3 lines)

> This script implements a canary deployment controller that progressively shifts traffic to a new version, monitors error rate and P95 latency via Prometheus, and automatically promotes or rolls back based on health metrics. It models SRE-style automated release validation.

---

If you want, I can provide:

* Istio weighted routing version
* Argo Rollouts YAML
* SLO-based burn rate controller
* Enterprise progressive delivery blueprint
* Multi-cluster canary controller
----
## Q48: Netflix-Style Chaos Engineering Tool

**Random Pod Termination (Non-Prod) + Self-Healing Report**

---

### 🧠 Objective

* Randomly terminate pods in **non-production namespaces**
* Only during **business hours**
* Observe Kubernetes self-healing behavior
* Generate resilience report:

  * Was pod recreated?
  * Did deployment return to desired replica count?
* SRE-style chaos experiment

---

## 📌 Assumptions

| Item                | Value        |
| ------------------- | ------------ |
| Non-prod namespaces | dev, staging |
| Business hours      | 9 AM – 6 PM  |
| Platform            | Kubernetes   |
| Observation window  | 120 seconds  |
| Report output       | JSON         |

---

## ✅ Install Dependencies

```bash
pip install kubernetes pytz
```

---

## ✅ Python Script (`chaos_pod_terminator.py`)

```python
import random
import time
import json
from datetime import datetime
import pytz
from kubernetes import client, config

NAMESPACES = ["dev", "staging"]
BUSINESS_START = 9
BUSINESS_END = 18
TIMEZONE = "Asia/Kolkata"
OBSERVATION_WINDOW = 120  # seconds
REPORT_FILE = f"chaos_report_{datetime.utcnow().timestamp()}.json"

def load_config():
    try:
        config.load_incluster_config()
    except:
        config.load_kube_config()

def within_business_hours():
    tz = pytz.timezone(TIMEZONE)
    hour = datetime.now(tz).hour
    return BUSINESS_START <= hour < BUSINESS_END

def select_random_pod(api, namespace):
    pods = api.list_namespaced_pod(namespace)
    eligible = [p for p in pods.items if p.status.phase == "Running"]
    return random.choice(eligible) if eligible else None

def delete_pod(api, namespace, pod_name):
    api.delete_namespaced_pod(name=pod_name, namespace=namespace)

def check_self_healing(apps_api, namespace, deployment_name):
    deploy = apps_api.read_namespaced_deployment(deployment_name, namespace)
    desired = deploy.spec.replicas
    available = deploy.status.available_replicas or 0
    return available >= desired

def main():
    load_config()

    if not within_business_hours():
        print("Outside business hours. Exiting.")
        return

    core_api = client.CoreV1Api()
    apps_api = client.AppsV1Api()

    report = {
        "timestamp": datetime.utcnow().isoformat(),
        "results": []
    }

    for ns in NAMESPACES:
        pod = select_random_pod(core_api, ns)
        if not pod:
            continue

        pod_name = pod.metadata.name
        owner_refs = pod.metadata.owner_references

        if not owner_refs:
            continue

        deployment_name = owner_refs[0].name

        print(f"Terminating pod {pod_name} in {ns}")

        delete_pod(core_api, ns, pod_name)

        time.sleep(OBSERVATION_WINDOW)

        healed = check_self_healing(apps_api, ns, deployment_name)

        report["results"].append({
            "namespace": ns,
            "deployment": deployment_name,
            "pod_terminated": pod_name,
            "self_healed": healed
        })

    with open(REPORT_FILE, "w") as f:
        json.dump(report, f, indent=2)

    print(f"Chaos experiment completed. Report: {REPORT_FILE}")

if __name__ == "__main__":
    main()
```

---

## 📊 Sample Report Output

```json
{
  "timestamp": "2026-02-14T10:15:00",
  "results": [
    {
      "namespace": "dev",
      "deployment": "api",
      "pod_terminated": "api-7c8d9f",
      "self_healed": true
    }
  ]
}
```

---

## 🔎 What This Script Does

| Step                    | Action                  |
| ----------------------- | ----------------------- |
| Check business hours    | Avoid off-hour chaos    |
| Pick random running pod | Per namespace           |
| Delete pod              | Simulate failure        |
| Wait 120 sec            | Observe recovery        |
| Verify replicas         | Deployment health check |
| Generate report         | JSON output             |

---

## 🚀 Production Enhancements

### 1️⃣ Add Rate Limit

Only terminate:

* Max 1 pod per namespace
* Avoid stateful workloads

---

### 2️⃣ Add Label Filter

Only chaos-test:

```python
label_selector="chaos=true"
```

---

### 3️⃣ Add Prometheus Metrics Collection

Measure:

* Recovery time
* Error rate spike
* Latency impact

---

### 4️⃣ Add Slack Summary

---

### 5️⃣ Enterprise-Grade Chaos (Netflix-Style)

Instead of custom script:

| Tool                            | Purpose           |
| ------------------------------- | ----------------- |
| Chaos Monkey                    | EC2 termination   |
| LitmusChaos                     | Kubernetes chaos  |
| Gremlin                         | SaaS chaos        |
| Argo Rollouts + Fault Injection | Canary resilience |

---

## 🔥 Netflix-Style Enhancements

| Feature                 | Why                           |
| ----------------------- | ----------------------------- |
| Random scheduling       | Unpredictable resilience test |
| Automated report        | MTTR measurement              |
| Business hour only      | Safe experimentation          |
| Self-healing validation | HA verification               |
| SLO tracking            | Resilience score              |

---

## 💡 Interview Summary (2–3 lines)

> This script simulates chaos engineering by randomly terminating pods in non-production namespaces during business hours, verifying Kubernetes self-healing behavior, and generating a resilience report. It demonstrates automated resilience validation similar to Netflix Chaos Monkey principles.

---

If you want, I can provide:

* EC2 Chaos Monkey version
* StatefulSet-aware chaos controller
* Prometheus-integrated recovery time measurement
* Kubernetes CronJob deployment YAML
* Enterprise-grade resilience scoring engine
----
## Q49: Meta-Style High-Volume Log Processor (10GB+)

**Streaming + Parallel Processing → Extract Metrics → Load into Time-Series DB**

---

### 🧠 Objective

* Process very large log files (10GB+)
* Use streaming (no full file load)
* Use parallel processing
* Extract:

  * Request count
  * Error rate
  * Avg latency
  * P95 latency
* Push to Time-Series DB (InfluxDB example)
* Production-scale design

---

## 📌 Assumptions

Example log format:

```
2026-02-14T10:01:23Z GET /api/orders 200 0.245
2026-02-14T10:01:24Z GET /api/orders 500 0.812
```

Fields:

```
timestamp method endpoint status latency
```

---

# 🚀 Architecture (Meta-style)

```
10GB Log File
      ↓
Chunked Streaming
      ↓
Multiprocessing Workers
      ↓
Metric Aggregation
      ↓
Batch Push → InfluxDB
```

---

## ✅ Install

```bash
pip install requests
```

---

## ✅ Python Script (`high_volume_log_processor.py`)

```python
import multiprocessing as mp
import requests
import time
import os
from collections import defaultdict
from datetime import datetime

LOG_FILE = "app.log"
INFLUX_URL = "http://localhost:8086/api/v2/write?org=myorg&bucket=mybucket&precision=s"
INFLUX_TOKEN = "your-token"
CHUNK_SIZE = 50 * 1024 * 1024  # 50MB
WORKERS = mp.cpu_count()

def process_chunk(lines):
    metrics = defaultdict(lambda: {"count": 0, "errors": 0, "latencies": []})

    for line in lines:
        parts = line.strip().split()
        if len(parts) != 5:
            continue

        timestamp, method, endpoint, status, latency = parts
        latency = float(latency)
        status = int(status)

        key = (timestamp[:13], endpoint)  # hourly aggregation

        metrics[key]["count"] += 1
        if status >= 500:
            metrics[key]["errors"] += 1

        metrics[key]["latencies"].append(latency)

    return metrics

def aggregate_results(results):
    final = defaultdict(lambda: {"count": 0, "errors": 0, "latencies": []})

    for partial in results:
        for key, data in partial.items():
            final[key]["count"] += data["count"]
            final[key]["errors"] += data["errors"]
            final[key]["latencies"].extend(data["latencies"])

    return final

def compute_stats(metrics):
    output_lines = []

    for (hour, endpoint), data in metrics.items():
        count = data["count"]
        errors = data["errors"]
        latencies = sorted(data["latencies"])

        avg_latency = sum(latencies) / count if count else 0
        p95_index = int(0.95 * len(latencies)) - 1
        p95_latency = latencies[p95_index] if latencies else 0
        error_rate = errors / count if count else 0

        line = (
            f"app_metrics,endpoint={endpoint} "
            f"count={count},error_rate={error_rate},"
            f"avg_latency={avg_latency},p95_latency={p95_latency} "
            f"{int(datetime.strptime(hour, '%Y-%m-%dT%H').timestamp())}"
        )

        output_lines.append(line)

    return output_lines

def push_to_influx(lines):
    headers = {
        "Authorization": f"Token {INFLUX_TOKEN}",
        "Content-Type": "text/plain"
    }

    data = "\n".join(lines)
    requests.post(INFLUX_URL, headers=headers, data=data)

def stream_file():
    with open(LOG_FILE, "r") as f:
        chunk = []
        size = 0

        for line in f:
            chunk.append(line)
            size += len(line)

            if size >= CHUNK_SIZE:
                yield chunk
                chunk = []
                size = 0

        if chunk:
            yield chunk

def main():
    start_time = time.time()

    pool = mp.Pool(WORKERS)
    results = []

    for chunk in stream_file():
        results.append(pool.apply_async(process_chunk, (chunk,)))

    pool.close()
    pool.join()

    partials = [r.get() for r in results]
    aggregated = aggregate_results(partials)
    lines = compute_stats(aggregated)

    push_to_influx(lines)

    print(f"Processed in {time.time() - start_time:.2f} seconds")

if __name__ == "__main__":
    main()
```

---

## 🔎 What Makes This “Meta-Style”

| Feature                 | Why                     |
| ----------------------- | ----------------------- |
| Streaming               | Avoid 10GB memory load  |
| Chunked processing      | Memory efficient        |
| Multiprocessing         | CPU parallelism         |
| Batched DB writes       | Reduce network overhead |
| Time-bucket aggregation | TSDB optimized          |

---

## 📊 Metrics Extracted

| Metric      | Description                    |
| ----------- | ------------------------------ |
| count       | Requests per hour per endpoint |
| error_rate  | 5xx errors / total             |
| avg_latency | Mean response time             |
| p95_latency | Tail latency                   |

---

## 🚀 Performance Characteristics

* O(N) streaming
* CPU bound (parallel)
* Memory controlled (~50MB per worker)
* Handles 10GB+ easily

---

## 🚀 Production Improvements

### 1️⃣ Use mmap Instead of Read Loop

Better I/O performance.

---

### 2️⃣ Use PyArrow / Polars for Faster Parsing

For columnar processing.

---

### 3️⃣ Use Kafka Instead of File

Real-time streaming ingestion.

---

### 4️⃣ Push to Prometheus Pushgateway Instead

---

### 5️⃣ Add Backpressure Control

---

## 🔥 Enterprise Architecture (Meta-Scale)

```
Logs → Kafka → Stream Processor (Flink / Spark) → TSDB → Dashboard
```

Instead of standalone script.

---

## 💡 Interview Summary (2–3 lines)

> This script processes 10GB+ logs using streaming and multiprocessing to efficiently extract performance metrics and batch-load them into a time-series database. It demonstrates scalable log analytics with memory-safe streaming and parallel computation.

---

If you want, I can provide:

* Apache Spark version
* Kafka streaming version
* Rust ultra-high-performance version
* AWS Kinesis real-time ingestion version
* Fully distributed log analytics architecture
----
## Q50: Microsoft-Style Infrastructure Compliance Engine

**CIS Benchmark Scanner → Account Compliance Score → Remediation Runbooks → Historical Tracking**

---

### 🧠 Objective

Enterprise-grade compliance workflow:

1. Scan AWS account against CIS-style rules
2. Evaluate pass/fail per control
3. Calculate compliance score per account
4. Generate remediation runbook for failed controls
5. Store score history (trend tracking)

Designed for:

* Security governance
* Multi-account monitoring
* CI / scheduled execution
* Executive dashboard integration

---

## 📌 Example CIS Controls (Simplified)

| Control ID | Description                            | Service    |
| ---------- | -------------------------------------- | ---------- |
| CIS-1.1    | Root account MFA enabled               | IAM        |
| CIS-1.4    | Access keys rotated < 90 days          | IAM        |
| CIS-2.1    | CloudTrail enabled in all regions      | CloudTrail |
| CIS-3.1    | S3 buckets block public access         | S3         |
| CIS-4.1    | Security groups restrict 0.0.0.0/0 SSH | EC2        |

---

## 🔐 Required IAM Permissions

```
iam:GetAccountSummary
iam:ListAccessKeys
iam:ListUsers
cloudtrail:DescribeTrails
s3:GetBucketPolicyStatus
ec2:DescribeSecurityGroups
sts:GetCallerIdentity
s3:PutObject
```

---

## 🗂 Architecture

```
AWS Account
    ↓
Compliance Scanner
    ↓
Score Calculator
    ↓
Runbook Generator
    ↓
S3 (Score History JSON)
```

---

## ✅ Python Script (`infra_compliance_checker.py`)

```python
import boto3
import json
from datetime import datetime, timedelta

REGION = "ap-south-1"
HISTORY_BUCKET = "compliance-history-bucket"

iam = boto3.client("iam", region_name=REGION)
ec2 = boto3.client("ec2", region_name=REGION)
s3 = boto3.client("s3", region_name=REGION)
cloudtrail = boto3.client("cloudtrail", region_name=REGION)
sts = boto3.client("sts")

account_id = sts.get_caller_identity()["Account"]

results = []

# ---------------------------
# CIS 1.1 Root MFA Enabled
# ---------------------------
def check_root_mfa():
    summary = iam.get_account_summary()["SummaryMap"]
    mfa_enabled = summary.get("AccountMFAEnabled", 0) == 1

    return {
        "control_id": "CIS-1.1",
        "description": "Root account MFA enabled",
        "status": "PASS" if mfa_enabled else "FAIL",
        "remediation": "Enable MFA for root user via IAM console."
    }

# ---------------------------
# CIS 2.1 CloudTrail Enabled
# ---------------------------
def check_cloudtrail():
    trails = cloudtrail.describe_trails()["trailList"]
    enabled = any(trail.get("IsMultiRegionTrail") for trail in trails)

    return {
        "control_id": "CIS-2.1",
        "description": "CloudTrail enabled",
        "status": "PASS" if enabled else "FAIL",
        "remediation": "Create multi-region CloudTrail with logging enabled."
    }

# ---------------------------
# CIS 3.1 S3 Public Access
# ---------------------------
def check_s3_public_access():
    buckets = s3.list_buckets()["Buckets"]
    compliant = True

    for bucket in buckets:
        status = s3.get_bucket_policy_status(Bucket=bucket["Name"])
        if status["PolicyStatus"]["IsPublic"]:
            compliant = False
            break

    return {
        "control_id": "CIS-3.1",
        "description": "S3 buckets not publicly accessible",
        "status": "PASS" if compliant else "FAIL",
        "remediation": "Enable Block Public Access on all S3 buckets."
    }

# ---------------------------
# CIS 4.1 Restrict SSH
# ---------------------------
def check_security_groups():
    groups = ec2.describe_security_groups()["SecurityGroups"]
    compliant = True

    for sg in groups:
        for perm in sg.get("IpPermissions", []):
            if perm.get("FromPort") == 22:
                for ip in perm.get("IpRanges", []):
                    if ip["CidrIp"] == "0.0.0.0/0":
                        compliant = False

    return {
        "control_id": "CIS-4.1",
        "description": "Security groups restrict SSH from 0.0.0.0/0",
        "status": "PASS" if compliant else "FAIL",
        "remediation": "Remove 0.0.0.0/0 SSH access from security groups."
    }

def calculate_score(results):
    total = len(results)
    passed = sum(1 for r in results if r["status"] == "PASS")
    return round((passed / total) * 100, 2)

def store_history(score, results):
    record = {
        "account_id": account_id,
        "timestamp": datetime.utcnow().isoformat(),
        "score": score,
        "details": results
    }

    key = f"{account_id}/compliance_{datetime.utcnow().isoformat()}.json"

    s3.put_object(
        Bucket=HISTORY_BUCKET,
        Key=key,
        Body=json.dumps(record, indent=2)
    )

def main():
    results.append(check_root_mfa())
    results.append(check_cloudtrail())
    results.append(check_s3_public_access())
    results.append(check_security_groups())

    score = calculate_score(results)

    print(f"\nAccount: {account_id}")
    print(f"Compliance Score: {score}%\n")

    for r in results:
        print(f"{r['control_id']} - {r['status']}")

    store_history(score, results)
    print("\nCompliance report stored in S3.")

if __name__ == "__main__":
    main()
```

---

## 📊 Example Output

```
Account: 123456789012
Compliance Score: 75%

CIS-1.1 - PASS
CIS-2.1 - FAIL
CIS-3.1 - PASS
CIS-4.1 - FAIL
```

---

## 📈 Score Tracking Over Time

Stored in S3:

```
compliance-history-bucket/
    └── 123456789012/
            compliance_2026-02-14T10:12.json
```

You can:

* Load into Athena
* Visualize in QuickSight
* Track score improvements trend

---

## 🚀 Enterprise Improvements

### 1️⃣ Multi-Account Support

* AssumeRole into all AWS accounts
* Aggregate org-wide score

---

### 2️⃣ Automated Remediation

Trigger SSM Automation:

```
ssm.start_automation_execution()
```

---

### 3️⃣ Integrate AWS Config Instead of Direct Checks

Better:

* Use Config compliance results
* Reduce custom logic

---

### 4️⃣ Dashboard Integration

Push score to:

* DynamoDB
* Grafana
* Security Hub

---

### 5️⃣ Add Weighted Controls

Example:

* IAM controls weight 30%
* Networking weight 25%

---

## 🔥 Enterprise Architecture (Microsoft-Style Governance)

```
AWS Accounts
      ↓
Compliance Engine (Lambda)
      ↓
Score + Remediation Plan
      ↓
S3 + DynamoDB
      ↓
Dashboard + Executive Reporting
```

---

## 💡 Interview Summary (2–3 lines)

> This script evaluates AWS resources against CIS benchmark-style controls, calculates a compliance score per account, generates remediation guidance for failed controls, and stores historical results to track improvement trends over time.

---

If you want, I can provide:

* Organization-wide compliance scanner
* Security Hub integrated version
* Terraform policy-as-code version
* Azure equivalent (Microsoft-style)
* Executive compliance dashboard architecture
