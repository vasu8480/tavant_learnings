# Linux 

## Q: What is Linux?

### 🧠 Overview

**Linux** is a **free, open-source operating system (OS)** based on **UNIX**.
It manages hardware resources, runs applications, and provides a multiuser, multitasking environment.
Linux powers servers, desktops, mobile devices (Android), and most **cloud infrastructure** — including **AWS EC2**, **Kubernetes**, and **Docker** containers.

---

### ⚙️ Purpose / How It Works

🧭 **Core Components:**

| Component              | Description                                                                         |
| ---------------------- | ----------------------------------------------------------------------------------- |
| **Kernel**             | The core of Linux — manages CPU, memory, devices, and processes.                    |
| **Shell**              | Command-line interface that lets users execute commands.                            |
| **File System**        | Hierarchical structure (`/bin`, `/etc`, `/var`, `/home`, etc.) organizing all data. |
| **Services / Daemons** | Background processes (e.g., `sshd`, `systemd`, `crond`) providing system functions. |
| **Userspace Tools**    | Utilities like `ls`, `grep`, `top`, `vim` used for management and scripting.        |

Linux uses a **modular architecture**, so you can customize components — ideal for servers, IoT, and containerized workloads.

---

### 🧩 Examples / Commands

#### Check OS and Kernel Version

```bash
cat /etc/os-release
uname -r
```

#### List Running Processes

```bash
ps -ef
```

#### Check Disk and Memory Usage

```bash
df -h
free -m
```

#### Update and Patch Packages

```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade -y

# RHEL/CentOS/Amazon Linux
sudo yum update -y
```

---

### 📋 Common Linux Distributions

| Distribution                          | Package Manager | Common Use                                   |
| ------------------------------------- | --------------- | -------------------------------------------- |
| **Ubuntu / Debian**                   | `apt`           | General-purpose servers, DevOps environments |
| **RHEL / CentOS / AlmaLinux / Rocky** | `yum` / `dnf`   | Enterprise servers                           |
| **Amazon Linux**                      | `yum`           | AWS EC2 instances                            |
| **SUSE / openSUSE**                   | `zypper`        | SAP and enterprise workloads                 |
| **Kali / Arch / Fedora**              | Various         | Security testing, bleeding-edge development  |

---

### ✅ Best Practices

* 🔒 Keep the OS patched regularly using **SSM Patch Manager** or package updates.
* ⚙️ Use **systemctl** for service management and **journalctl** for logs.
* 🧠 Automate tasks using **cron jobs** or **shell scripts**.
* 🧩 Harden systems with **SELinux/AppArmor**, firewall (`iptables`/`firewalld`), and least-privilege accounts.
* 📊 Monitor performance with tools like `top`, `iostat`, `vmstat`, or `dstat`.

---

### 💡 In short

**Linux** is a **stable, secure, and highly customizable open-source OS** that underpins most cloud and DevOps environments.
It’s the backbone of **containers, Kubernetes, and cloud servers**, making it essential for modern infrastructure and automation.

---
## Q: How to Check OS Version and Kernel Version in Linux?

---

### 🧠 Overview

Knowing the **OS version** and **kernel version** helps in patching, troubleshooting, and ensuring compatibility with drivers, tools, or container runtimes.
Linux provides several built-in commands to display this information — both **distribution release** (e.g., Ubuntu 22.04, Amazon Linux 2) and **kernel details** (e.g., `5.15.0-1071-aws`).

---

### ⚙️ Purpose / How It Works

Linux maintains:

* OS metadata in `/etc/os-release` or `/etc/*release`
* Kernel information in `/proc/version` and `uname` system call output

---

### 🧩 Commands / Examples

#### 🟢 1. Check OS Version (Distribution Info)

```bash
cat /etc/os-release
```

**Example Output:**

```
NAME="Amazon Linux"
VERSION="2"
ID="amzn"
PRETTY_NAME="Amazon Linux 2"
```

Other distro files (if `/etc/os-release` missing):

```bash
cat /etc/redhat-release    # RHEL/CentOS
cat /etc/lsb-release       # Ubuntu/Debian
cat /etc/SuSE-release      # SUSE
```

---

#### 🟢 2. Check Kernel Version

```bash
uname -r
```

**Output Example:**

```
5.10.212-203.855.amzn2.x86_64
```

Additional kernel info:

```bash
uname -a
```

**Output Example:**

```
Linux ip-10-0-0-1 5.10.212-203.855.amzn2.x86_64 #1 SMP Thu Aug 22 2024 x86_64 GNU/Linux
```

---

#### 🟢 3. Combined Quick Summary

```bash
echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2)"
echo "Kernel: $(uname -r)"
```

**Output Example:**

```
OS: "Ubuntu 22.04.3 LTS"
Kernel: 5.15.0-122-generic
```

---

#### 🟢 4. For Systemd-based Summary

```bash
hostnamectl
```

**Output Example:**

```
Operating System: Ubuntu 22.04.3 LTS
Kernel: Linux 5.15.0-122-generic
Architecture: x86-64
```

---

### 📋 Common Output Examples

| Distro             | OS Command Output                             | Kernel Command Output           |
| ------------------ | --------------------------------------------- | ------------------------------- |
| **Amazon Linux 2** | `PRETTY_NAME="Amazon Linux 2"`                | `5.10.212-203.855.amzn2.x86_64` |
| **RHEL 9**         | `Red Hat Enterprise Linux release 9.4 (Plow)` | `5.14.0-427.22.1.el9_4.x86_64`  |
| **Ubuntu 22.04**   | `Ubuntu 22.04.3 LTS (Jammy)`                  | `5.15.0-122-generic`            |

---

### ✅ Best Practices

* 🧩 Always **document OS + kernel versions** in patching and compliance reports.
* ⚙️ Use `uname -r` to confirm **kernel updates applied** after patching.
* 🧠 Automate version checks via **SSM inventory** or a **startup script**.
* 🔒 Ensure new kernel versions are **tested in staging** before production rollout.

---

### 💡 In short

Use `cat /etc/os-release` to check your **Linux distribution** and `uname -r` for the **kernel version**.
Together, they provide a quick snapshot of your system’s OS environment — critical for **patching, compliance, and troubleshooting**.

---
## Q: How to Check System Uptime in Linux?

---

### 🧠 Overview

**System uptime** shows how long a Linux system has been running since its last reboot — a key metric for **stability, patch verification, and troubleshooting**.
Admins often check uptime after patching or reboot operations to confirm the system restarted correctly.

---

### ⚙️ Purpose / How It Works

* The **kernel** tracks uptime since boot and exposes it via `/proc/uptime`.
* Utilities like `uptime`, `top`, and `who -b` read this data.
* AWS monitoring tools (like **SSM Inventory** or **CloudWatch**) can also collect uptime metrics for compliance.

---

### 🧩 Commands / Examples

#### 🟢 1. Simple Uptime Command

```bash
uptime
```

**Example Output:**

```
 10:22:45 up 7 days,  4:15,  2 users,  load average: 0.10, 0.07, 0.09
```

* **“up 7 days, 4:15”** → server has been running for 7 days and 4 hours
* **Load average** → CPU load over the last 1, 5, and 15 minutes

---

#### 🟢 2. From /proc/uptime (raw data)

```bash
cat /proc/uptime
```

**Example Output:**

```
629871.23 618912.50
```

* First number = seconds since last boot
  Convert seconds to readable format:

```bash
awk '{print int($1/86400)" days, "int(($1%86400)/3600)" hours, "int(($1%3600)/60)" minutes"}' /proc/uptime
```

**Output:**

```
7 days, 4 hours, 15 minutes
```

---

#### 🟢 3. Using `who -b` (Last Boot Time)

```bash
who -b
```

**Example Output:**

```
 system boot  2025-11-04 06:12
```

> Useful for verifying **reboot timing after patching** or maintenance.

---

#### 🟢 4. Using `top` Command

```bash
top -bn1 | head -1
```

**Example Output:**

```
top - 10:25:01 up 7 days,  4:15,  2 users,  load average: 0.10, 0.07, 0.09
```

---

#### 🟢 5. Using `systemctl` (Modern Systems)

```bash
systemctl status
```

**Example Output (snippet):**

```
   Hostname: prod-api
   Kernel: Linux 5.15.0-122-generic
   Uptime: 7 days 4h 15min
```

---

### 📊 Common Use Cases

| Scenario                    | Purpose                                     |
| --------------------------- | ------------------------------------------- |
| **Post-patch verification** | Confirm reboot applied new kernel           |
| **Availability tracking**   | Identify uptime trend for stability reports |
| **Troubleshooting**         | Detect unplanned reboots or crashes         |
| **Compliance**              | Validate scheduled maintenance completion   |

---

### ✅ Best Practices

* ⚙️ Use `uptime` or `who -b` after patching to confirm **reboot success**.
* 🧠 Log uptime to **CloudWatch metrics** via SSM RunCommand for compliance tracking.
* 🚀 Integrate uptime checks into **CI/CD validation steps** for auto-scaling instances.
* 🔒 Long uptimes ≠ secure — **regular reboots** post-patching are recommended.

---

### 💡 In short

Check system uptime using `uptime` or `who -b`.
These commands show how long the system has been running and confirm **reboot success** after patching — a simple yet crucial step in **post-maintenance validation**.

----
## Q: How to Check CPU and Memory Usage in Linux?

---

### 🧠 Overview

Monitoring **CPU** and **memory** usage is essential for **performance tuning**, **patch validation**, and **incident troubleshooting**.
Linux provides multiple native tools to inspect resource utilization in real time or from system snapshots — helping identify **bottlenecks**, **high-load processes**, or **memory leaks**.

---

### ⚙️ Purpose / How It Works

* The **kernel** tracks CPU and memory metrics in `/proc/stat` and `/proc/meminfo`.
* Utilities like `top`, `vmstat`, `free`, and `sar` present that data in human-readable form.
* Cloud-native setups (AWS/EKS) can export the same data to **CloudWatch** or **Prometheus** for monitoring and alerts.

---

### 🧩 Commands / Examples

#### 🟢 1. Check CPU & Memory in Real Time — `top`

```bash
top
```

**Example Output (top 5 lines):**

```
top - 11:24:38 up 1 day,  4:12,  2 users,  load average: 0.31, 0.45, 0.27
Tasks: 212 total,   1 running, 211 sleeping,   0 stopped,   0 zombie
%Cpu(s): 12.3 us,  3.5 sy,  0.0 ni, 84.0 id,  0.0 wa,  0.0 hi,  0.2 si,  0.0 st
MiB Mem :   7976.6 total,   1254.3 free,   4167.5 used,   2554.8 buff/cache
MiB Swap:   2048.0 total,   2048.0 free,      0.0 used.   3465.2 avail Mem
```

**Key fields:**

* `%Cpu(s):` — user/system/idle CPU usage
* `Mem:` — total, used, and free RAM
* `Swap:` — total swap space and current usage

Exit with `q`.

---

#### 🟢 2. Quick CPU Summary — `mpstat`

```bash
mpstat -P ALL 1 3
```

**Example Output:**

```
Average:     all     5.00   1.25   0.00  92.00   0.00   0.00
```

> Shows per-core CPU utilization every 1 second (3 intervals).

---

#### 🟢 3. Check Memory Usage — `free`

```bash
free -h
```

**Example Output:**

```
              total        used        free      shared  buff/cache   available
Mem:           15Gi       6.2Gi       5.1Gi       150Mi       3.7Gi        8.1Gi
Swap:          2.0Gi         0B       2.0Gi
```

> Focus on the **“available”** column — memory truly available for use.

---

#### 🟢 4. CPU Load Over Time — `uptime`

```bash
uptime
```

**Example Output:**

```
11:28:52 up 1 day,  4:20,  2 users,  load average: 0.32, 0.45, 0.29
```

> Load average = CPU queue length over 1, 5, and 15 mins
> Rough rule: load ≈ number of CPU cores → system is healthy.

---

#### 🟢 5. Process-Specific Usage — `ps`

```bash
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head
```

**Output Example:**

```
  PID COMMAND         %CPU %MEM
12345 java            95.3 12.5
23456 nginx            3.1  0.6
```

---

#### 🟢 6. System-Wide Snapshot — `vmstat`

```bash
vmstat 1 5
```

**Columns Explained:**

* `r` → running processes
* `us`/`sy` → CPU usage (user/system)
* `id` → idle time
* `si`/`so` → swap activity

---

#### 🟢 7. Historical Metrics — `sar` (sysstat package)

```bash
sar -u 1 3     # CPU
sar -r 1 3     # Memory
```

> Useful for trend analysis or troubleshooting past performance issues.

---

### 📊 Example Combined Output

| Metric                | Command                     | Key Output Example                       |
| --------------------- | --------------------------- | ---------------------------------------- |
| **CPU Usage**         | `top`, `mpstat`, `vmstat`   | `%Cpu(s): 15.2 us, 4.3 sy, 80.0 id`      |
| **Memory Usage**      | `free -h`, `top`, `sar -r`  | `Mem: 8Gi total, 6.1Gi used, 1.9Gi free` |
| **Per-Process Stats** | `ps -eo pid,comm,%cpu,%mem` | Highest CPU/memory-consuming processes   |
| **Historical Load**   | `sar -u` or `uptime`        | `load average: 0.5, 0.6, 0.7`            |

---

### ✅ Best Practices

* ⚙️ Use `top` or `htop` for **real-time monitoring**.
* 🧠 Automate data collection via **CloudWatch Agent** or **Prometheus Node Exporter**.
* 🔍 Investigate persistent high CPU (`>80%`) or low memory (`<10% free`).
* 🚀 Correlate with **application logs** and **I/O metrics** for root cause.
* 🧾 Schedule **resource utilization checks** post-patch or deployments.

---

### 💡 In short

Use `top` or `free -h` to monitor **CPU and memory usage** in real time.
For automation or audits, leverage **mpstat**, **sar**, or **CloudWatch metrics** — ensuring your servers stay performant and stable after patches or workload changes.

---
## Q: How to Find Disk Usage by Directory in Linux?

---

### 🧠 Overview

Checking **disk usage by directory** helps identify what’s consuming space — crucial for **troubleshooting full volumes**, **cleaning up logs**, and **verifying patch or backup space**.
Linux provides tools like `du`, `df`, and `ncdu` to display directory-level storage usage in both **human-readable** and **summarized** formats.

---

### ⚙️ Purpose / How It Works

* The `du` (disk usage) command reads inode metadata and file sizes recursively.
* The `df` (disk free) command shows overall filesystem utilization.
* Tools like `ncdu` or `find` add interactivity and filtering.

---

### 🧩 Commands / Examples

#### 🟢 1. Check Overall Filesystem Usage

```bash
df -h
```

**Example Output:**

```
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1       40G   29G  9.2G  76% /
tmpfs           7.8G  1.0M  7.8G   1% /dev/shm
```

> Shows total disk space used and available on each mount.

---

#### 🟢 2. Find Directory Usage (Recursive)

```bash
du -sh /var/log
```

**Output Example:**

```
2.1G    /var/log
```

> Displays total size of `/var/log` directory in human-readable format.

**Flags:**

* `-s` → summary (don’t show subdirectories)
* `-h` → human-readable (MB/GB units)

---

#### 🟢 3. List Top-Level Directory Usage

```bash
du -sh /* 2>/dev/null
```

**Output Example:**

```
4.3G    /var
2.1G    /usr
512M    /opt
```

> Quickly shows usage by major directories under root (`/`).

---

#### 🟢 4. Sort Directories by Size (Top Usage)

```bash
du -h --max-depth=1 /var | sort -hr | head -10
```

**Example Output:**

```
2.1G    /var/log
1.5G    /var/cache
512M    /var/tmp
```

> Displays the **largest subdirectories** under `/var`.

---

#### 🟢 5. Analyze Disk Interactively with `ncdu`

```bash
sudo apt install ncdu -y       # Ubuntu/Debian
sudo yum install ncdu -y       # RHEL/Amazon Linux
sudo ncdu /
```

> Opens a **TUI (text UI)** showing directories sorted by size, easy for drill-down cleanup.

---

#### 🟢 6. Find Large Files (≥ 1 GB)

```bash
find / -type f -size +1G -exec ls -lh {} \; 2>/dev/null
```

**Example Output:**

```
-rw-r--r-- 1 root root 2.5G /var/log/messages.1
-rw-r--r-- 1 ec2-user ec2-user 1.2G /home/ec2-user/dump.sql
```

> Identifies files consuming excessive disk space.

---

#### 🟢 7. Check Disk Usage for Specific Filesystem

```bash
df -hT /var
```

**Example Output:**

```
Filesystem     Type  Size  Used Avail Use% Mounted on
/dev/xvda1     ext4   40G   29G  9.2G  76% /var
```

---

### 📋 Example Summary

| Command                     | Description                 | Example Use                    |                        |
| --------------------------- | --------------------------- | ------------------------------ | ---------------------- |
| `df -h`                     | Filesystem-level disk usage | Check volume capacity          |                        |
| `du -sh <dir>`              | Directory size summary      | Check `/var` or `/home`        |                        |
| `du -sh /*`                 | Top-level usage overview    | Identify large directories     |                        |
| `du -h --max-depth=1 <path> | sort -hr`                   | Sorted directory usage         | Find top 10 large dirs |
| `ncdu /`                    | Interactive analysis        | Drill down disk usage          |                        |
| `find / -size +1G`          | Large file detection        | Locate oversized logs or dumps |                        |

---

### ✅ Best Practices

* ⚙️ Run `du -sh /*` before patching to ensure **free disk space** for updates.
* 🧩 Monitor `/var/log`, `/tmp`, `/opt`, and `/home` — common space offenders.
* 🧠 Use **logrotate** and **tmpreaper** to auto-clean logs and temp files.
* 🚀 Install **CloudWatch Agent** or **Prometheus Node Exporter** for ongoing disk monitoring.
* 🔒 Avoid deleting system files manually under `/usr` or `/lib`.

---

### 💡 In short

Use `du -sh` and `du -h --max-depth=1 / | sort -hr` to find **disk usage by directory** and identify which paths consume the most space.
For interactive cleanup, use `ncdu`, and always check `df -h` first to understand **overall disk utilization** before deleting or resizing volumes.

----
## Q: How to Check Which Process Uses the Most Memory or CPU in Linux?  

---

### 🧠 Overview  
When a Linux system is **slow, overloaded, or unstable**, identifying the **top CPU and memory-consuming processes** helps isolate root causes (e.g., runaway apps, memory leaks, or stuck services).  
You can quickly find the culprit using tools like `top`, `ps`, or `htop`.

---

### ⚙️ Purpose / How It Works  
- The Linux **kernel tracks CPU and memory usage** for each running process via `/proc`.  
- Utilities like `ps`, `top`, and `htop` display that information in real time or snapshots.  
- These metrics help troubleshoot **high load**, **swap usage**, or **crash loops**.

---

### 🧩 Commands / Examples  

#### 🟢 1. Real-Time Monitoring — `top`
```bash
top
```
**Example Output:**
```
top - 12:25:10 up 3 days,  2:16,  2 users,  load average: 3.15, 2.90, 1.87
Tasks: 214 total,   2 running, 212 sleeping,   0 stopped,   0 zombie
%Cpu(s): 85.3 us,  4.2 sy,  0.0 ni,  9.9 id,  0.3 wa,  0.1 hi,  0.2 si,  0.0 st
MiB Mem :   7976.6 total,   512.3 free,   6321.5 used,   1142.8 buff/cache
  PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND
 2043 webuser   20   0 1320m 922m  12m R  95.6 11.6  23:11.42 java
 1125 root      20   0  157m  24m  12m S   5.3  0.3   1:52.77 dockerd
```

**Keys:**  
- `P` → sort by CPU  
- `M` → sort by memory  
- `1` → show all CPU cores  
- `q` → quit  

> 🔍 **Use Case:** Quickly find processes hogging resources (e.g., Java, MySQL, Python).

---

#### 🟢 2. Static Snapshot — `ps`
```bash
ps -eo pid,user,comm,%cpu,%mem --sort=-%cpu | head
```
**Example Output:**
```
  PID USER     COMMAND         %CPU %MEM
 2043 webuser  java            95.6 11.6
 1125 root     dockerd          5.3  0.3
```

To sort by memory usage:
```bash
ps -eo pid,user,comm,%cpu,%mem --sort=-%mem | head
```

---

#### 🟢 3. Interactive View — `htop` (Recommended)
```bash
sudo apt install htop -y   # Ubuntu/Debian
sudo yum install htop -y   # RHEL/Amazon Linux
htop
```
**Highlights:**
- Displays CPU & memory bars graphically  
- Sort by CPU, memory, or process ID (`F6`)  
- Kill or renice processes directly (`F9`, `F7/F8`)  

> 💡 Perfect for **DevOps engineers** monitoring real-time production load.

---

#### 🟢 4. Check Per-User or Per-Process CPU Load
```bash
ps -eo user,pid,pcpu,pmem,comm --sort=-pcpu | head
```
**Example Output:**
```
USER       PID  %CPU %MEM COMMAND
ec2-user  2043  95.6 11.6 java
root      1125   5.3  0.3 dockerd
```

---

#### 🟢 5. Find Top 10 Memory Hogs
```bash
ps -eo pid,comm,pmem --sort=-pmem | head -10
```
**Example Output:**
```
PID   COMMAND        %MEM
2043  java           11.6
1523  mysqld          9.2
```

---

#### 🟢 6. Combine CPU + Memory + Time
```bash
ps -eo pid,user,%cpu,%mem,etime,cmd --sort=-%cpu | head
```
> Shows which processes are both long-running and resource-intensive.

---

#### 🟢 7. Find Process Tree (Parent/Child Relationship)
```bash
pstree -p | less
```
> Useful when a parent process (like `systemd`, `gunicorn`, or `docker`) spawns children that consume resources.

---

### 📋 Quick Reference Table  

| Command | Focus | Description |
|----------|--------|-------------|
| `top` | Live | Real-time view of CPU & memory usage |
| `ps -eo ... --sort=-%cpu` | Snapshot | Top CPU consumers |
| `ps -eo ... --sort=-%mem` | Snapshot | Top memory consumers |
| `htop` | Interactive | Visual interface, sorting, and process management |
| `pstree` | Tree view | Parent-child process visualization |

---

### ✅ Best Practices  
- 🧠 **Use `top` for real-time** analysis; **`ps` for logging** or scripting.  
- ⚙️ Automate alerts using **CloudWatch Agent** or **Prometheus Node Exporter**.  
- 🔍 Investigate sustained high usage — may indicate **memory leaks** or **runaway threads**.  
- 🚀 Use `nice` or `renice` to adjust process priorities during load spikes.  
- 🧩 Include CPU/mem utilization in **post-patch verification scripts** to confirm stability.  

---

### 💡 In short  
Use `top` or `htop` for real-time monitoring, and `ps -eo pid,comm,%cpu,%mem --sort=-%cpu` for quick snapshots.  
These tools let you instantly identify **which processes consume the most CPU or memory**, helping you **debug performance issues** or **verify post-patch system health**.

---
## Q: How to List All Open Network Ports in Linux?

---

### 🧠 Overview

Checking **open ports** helps identify which **applications or services are listening for connections**, verify firewall rules, and detect potential **security risks**.
Linux provides multiple tools — like `ss`, `netstat`, `lsof`, and `nmap` — to list active ports and their associated processes.

---

### ⚙️ Purpose / How It Works

* Each network service binds to a **port number** (e.g., `22` for SSH, `80` for HTTP).
* The **kernel** maintains socket state information, visible via `/proc/net` or utilities.
* Tools like `ss` and `lsof` query the kernel to show **listening (LISTEN)** and **active (ESTABLISHED)** sockets.

---

### 🧩 Commands / Examples

#### 🟢 1. Modern Way (Recommended) — Using `ss`

```bash
sudo ss -tuln
```

**Output Example:**

```
Netid State   Recv-Q Send-Q Local Address:Port   Peer Address:Port
tcp   LISTEN  0      128    0.0.0.0:22          0.0.0.0:*
tcp   LISTEN  0      128    127.0.0.1:5432      0.0.0.0:*
udp   UNCONN  0      0      127.0.0.1:123       0.0.0.0:*
```

**Flags explained:**

* `-t` → TCP
* `-u` → UDP
* `-l` → Listening sockets only
* `-n` → Don’t resolve names (faster, shows numeric ports)

> ✅ Use `ss` instead of `netstat` — it’s faster and default in modern distros.

---

#### 🟢 2. Show Listening Ports with Process Info

```bash
sudo ss -tulnp
```

**Output Example:**

```
Netid State  Local Address:Port  PID/Program name
tcp   LISTEN 0.0.0.0:22          745/sshd
tcp   LISTEN 127.0.0.1:5432      1143/postgres
```

> Displays **which process (PID + name)** is bound to each port.

---

#### 🟢 3. Using Legacy Command — `netstat`

```bash
sudo netstat -tuln
```

**Output Example:**

```
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN
```

To include process names:

```bash
sudo netstat -tulnp
```

> ⚠️ `netstat` is part of the **net-tools** package (deprecated on modern distros).

---

#### 🟢 4. Using `lsof` (List Open Files)

```bash
sudo lsof -i -P -n
```

**Output Example:**

```
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
sshd      745 root   3u  IPv4  18425      0t0  TCP *:22 (LISTEN)
nginx    1234 root   6u  IPv4  19726      0t0  TCP *:80 (LISTEN)
```

Filter for specific port:

```bash
sudo lsof -i :443
```

---

#### 🟢 5. Show Only Open TCP Ports

```bash
sudo ss -lt
```

Show UDP ports:

```bash
sudo ss -lu
```

---

#### 🟢 6. Check Ports by Process Name

```bash
sudo ss -tulnp | grep nginx
```

**Output Example:**

```
tcp   LISTEN  0  128  0.0.0.0:80  0.0.0.0:*  users:(("nginx",pid=1234,fd=6))
```

---

#### 🟢 7. Remote Port Scan (External Check)

```bash
sudo yum install nmap -y   # or apt install nmap -y
nmap -sT -p 1-1024 localhost
```

**Example Output:**

```
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
5432/tcp open  postgresql
```

> Great for verifying **firewall exposure** and external accessibility.

---

### 📋 Common Default Service Ports

| Port | Protocol | Common Service           |
| ---- | -------- | ------------------------ |
| 22   | TCP      | SSH                      |
| 80   | TCP      | HTTP                     |
| 443  | TCP      | HTTPS                    |
| 3306 | TCP      | MySQL                    |
| 5432 | TCP      | PostgreSQL               |
| 8080 | TCP      | Tomcat / App Server      |
| 9090 | TCP      | Prometheus / App Metrics |

---

### ✅ Best Practices

* 🧩 Use `ss -tulnp` for fast, detailed local port checks.
* 🔒 Limit open ports using **firewalld** or **ufw** — principle of least exposure.
* 🧠 Periodically scan with **nmap** to detect unexpected services.
* ⚙️ Integrate port monitoring in **CloudWatch / Prometheus** for real-time visibility.
* 🚨 In production, alert on any new port opened outside maintenance windows.

---

### 💡 In short

Use `sudo ss -tulnp` to list **all open ports with their owning processes**.
For external visibility, run an **nmap** scan.
Together, these commands help verify **network exposure**, detect **rogue services**, and maintain **secure, compliant environments**.

---

## Q: How to Check Which Process Is Using a Specific Port (e.g., 8080) in Linux?

---

### 🧠 Overview

If a port like **8080** is already in use, your application (e.g., Tomcat, Jenkins, Nginx) may fail to start.
You can identify **which process (PID/program)** owns that port using built-in tools such as `ss`, `lsof`, or `netstat`.

---

### ⚙️ Purpose / How It Works

Every listening socket is associated with:

* A **protocol** (TCP/UDP)
* A **port number** (e.g., 8080)
* A **process ID (PID)** and program that opened it

Linux exposes this mapping via `/proc/net/tcp` and tools that read it.

---

### 🧩 Commands / Examples

#### 🟢 1. Using `ss` (Modern & Fast)

```bash
sudo ss -ltnp | grep 8080
```

**Example Output:**

```
LISTEN 0 128 0.0.0.0:8080  0.0.0.0:*  users:(("java",pid=1234,fd=6))
```

**Explanation:**

* `LISTEN` → socket is actively accepting connections
* `java` → process name
* `pid=1234` → process ID

> ✅ Preferred method on modern systems (`ss` replaces `netstat`).

---

#### 🟢 2. Using `lsof` (List Open Files)

```bash
sudo lsof -i :8080
```

**Example Output:**

```
COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
java    1234 root   6u  IPv6  19726      0t0  TCP *:8080 (LISTEN)
```

**Breakdown:**

* `COMMAND` → name of the executable
* `PID` → process ID
* `USER` → process owner
* `NAME` → port & protocol (e.g., `TCP *:8080`)

> 💡 Works on both **TCP** and **UDP** ports.

---

#### 🟢 3. Using `netstat` (Legacy Tool)

```bash
sudo netstat -tulnp | grep 8080
```

**Example Output:**

```
tcp   0   0 0.0.0.0:8080   0.0.0.0:*   LISTEN   1234/java
```

> ⚠️ Requires `net-tools` package (`apt install net-tools -y`).

---

#### 🟢 4. Verify Process Info with `ps`

Once you have the PID:

```bash
ps -fp 1234
```

**Example Output:**

```
UID   PID  PPID  C STIME TTY   TIME CMD
root 1234     1  2 10:12 ?     00:15:02 /usr/bin/java -jar /opt/jenkins.war
```

> ✅ Confirms **which application** and **how it was started**.

---

#### 🟢 5. Using `fuser` (Quick Check)

```bash
sudo fuser 8080/tcp
```

**Example Output:**

```
8080/tcp: 1234
```

Then:

```bash
ps -p 1234 -o pid,comm,cmd
```

**Output:**

```
PID  COMMAND  CMD
1234 java     /usr/bin/java -jar /opt/app.jar
```

> ⚙️ Simple and fast when only the PID is needed.

---

#### 🟢 6. Find All Listening Processes (Optional)

```bash
sudo ss -tulnp
```

> Displays all open ports and their associated processes.

---

### 📋 Command Comparison

| Command          | Purpose       | Output Includes            |                   |
| ---------------- | ------------- | -------------------------- | ----------------- |
| `ss -ltnp        | grep 8080`    | Modern, fast               | Process name, PID |
| `lsof -i :8080`  | Most detailed | PID, user, file descriptor |                   |
| `netstat -tulnp  | grep 8080`    | Legacy                     | PID/program       |
| `fuser 8080/tcp` | Lightweight   | PID only                   |                   |

---

### ✅ Best Practices

* 🧩 Always confirm **PID → Command mapping** with `ps` before killing or restarting.
* 🔒 Avoid killing system daemons (e.g., `systemd`, `dockerd`) accidentally.
* ⚙️ For app conflicts (e.g., Jenkins/Tomcat), reconfigure to use alternate ports in `/etc/default/<app>` or config files.
* 🧠 In CI/CD or AWS EC2, integrate port usage checks before deployments to avoid service collisions.

---

### 💡 In short

Use `sudo ss -ltnp | grep 8080` or `sudo lsof -i :8080` to instantly find **which process is using port 8080**, along with its **PID and program name**.
Then verify with `ps -fp <PID>` — a quick, safe way to resolve **port conflicts or blocked deployments**.

---
## Q: How to View Logs in Linux?

---

### 🧠 Overview

Logs are the **first place to check** when troubleshooting errors, performance issues, or patch failures in Linux.
Most logs are stored in **`/var/log/`**, managed by **rsyslog** or **systemd-journald**, and can be viewed with standard commands like `cat`, `less`, `tail`, or `journalctl`.

---

### ⚙️ Purpose / How It Works

* **System logs** record kernel, authentication, service, and application events.
* **rsyslog / journald** collect logs from all sources into central files or the journal.
* Tools like `tail` and `journalctl` let you **view, filter, and follow logs in real time**.

---

### 🧩 Commands / Examples

#### 🟢 1. View System Log Files

```bash
cd /var/log
ls -lh
```

**Common log files:**

| Log File                               | Purpose                                        |
| -------------------------------------- | ---------------------------------------------- |
| `/var/log/messages`                    | General system messages (most distros)         |
| `/var/log/syslog`                      | System log (Debian/Ubuntu)                     |
| `/var/log/secure`                      | Security and authentication logs (RHEL/CentOS) |
| `/var/log/auth.log`                    | Authentication log (Debian/Ubuntu)             |
| `/var/log/dmesg`                       | Kernel boot logs                               |
| `/var/log/cron`                        | Cron job logs                                  |
| `/var/log/httpd/` or `/var/log/nginx/` | Web server logs                                |
| `/var/log/amazon/ssm/`                 | AWS Systems Manager Agent logs                 |

---

#### 🟢 2. View Logs with `cat`, `less`, or `more`

```bash
sudo cat /var/log/syslog
sudo less /var/log/messages
```

> Use `less` for large logs — supports scrolling and search (`/keyword`).

---

#### 🟢 3. Follow Logs in Real-Time

```bash
sudo tail -f /var/log/messages
```

**Output Example:**

```
Nov 11 12:42:01 ip-10-0-1-21 systemd[1]: Started Session 3921 of user ec2-user.
Nov 11 12:42:05 ip-10-0-1-21 sshd[2209]: Accepted publickey for ec2-user
```

> Useful for monitoring logs **during patching or app deployment**.

---

#### 🟢 4. Filter Logs by Keyword

```bash
sudo grep "error" /var/log/syslog
sudo grep -i "fail" /var/log/messages
```

> Use `grep -i` for **case-insensitive** search.

---

#### 🟢 5. Check Boot & Kernel Logs

```bash
dmesg | less
```

**Example Output:**

```
[    0.000000] Linux version 5.15.0-122-generic (buildd@lcy02-amd64)
[    2.103142] EXT4-fs (xvda1): mounted filesystem with ordered data mode.
```

> Shows **hardware, kernel, and driver messages** since last boot.

---

#### 🟢 6. View Service-Specific Logs (systemd)

```bash
sudo journalctl -u sshd
```

**Example Output:**

```
Nov 11 12:42:01 ip-10-0-1-21 sshd[2209]: Accepted password for ec2-user from 10.0.0.15 port 50222 ssh2
```

> `-u` = filter by **unit/service name**
> Works for any service (e.g., `nginx`, `docker`, `sshd`, `ssm-agent`)

---

#### 🟢 7. View Logs Since Specific Time

```bash
sudo journalctl --since "2025-11-10 10:00:00"
sudo journalctl --since "1 hour ago"
```

#### 🟢 8. Real-Time Logs (journalctl)

```bash
sudo journalctl -f
```

> Equivalent to `tail -f`, but includes **systemd journal entries**.

---

#### 🟢 9. Application Logs

Application logs are usually in:

* `/var/log/<app-name>/`
* Custom directories (e.g., `/opt/myapp/logs/`)
* Or configured via environment variables/log frameworks (e.g., Log4j, syslog)

**Example:**

```bash
sudo tail -n 100 /var/log/nginx/access.log
```

---

### 📋 Command Summary

| Command                          | Description                  | Example                 |
| -------------------------------- | ---------------------------- | ----------------------- |
| `ls /var/log`                    | List available log files     | Identify what’s logged  |
| `cat /var/log/messages`          | View log contents            | Simple view             |
| `less /var/log/syslog`           | Scroll/search logs           | `/error`, `q` to exit   |
| `tail -f /var/log/messages`      | Follow new logs in real-time | Live monitoring         |
| `grep "error" /var/log/messages` | Search for keywords          | Filtered view           |
| `journalctl -u sshd`             | Logs for specific service    | systemd logs            |
| `journalctl -f`                  | Follow journal logs live     | Equivalent to `tail -f` |
| `dmesg`                          | Kernel/boot logs             | Hardware and drivers    |

---

### ✅ Best Practices

* ⚙️ Use `journalctl -u <service>` for **systemd-managed apps**.
* 🧠 Monitor `/var/log/messages` or `/var/log/syslog` for system issues.
* 🔒 Secure logs — restrict access to `/var/log` (contains sensitive info).
* 📦 Rotate logs automatically with `logrotate` to avoid disk full issues.
* 🚀 Send logs to **CloudWatch Logs**, **ELK**, or **Splunk** for centralized visibility.
* 🧩 Use `tail -f` during patching or deployments to watch live events.

---

### 💡 In short

Use `sudo tail -f /var/log/messages` for live logs, `journalctl -u <service>` for systemd service logs, and `grep "error"` to search failures.
All Linux logs reside in **`/var/log/`**, and mastering these tools is essential for **debugging, monitoring, and auditing production systems**.

--- 
## Q: How to Find a File by Name in Linux?

---

### 🧠 Overview

Finding files quickly is a key Linux skill — useful for **locating configuration files**, **logs**, **scripts**, or **binaries**.
Linux provides several commands (`find`, `locate`, `ls`, `grep`) to search for files **by name**, **extension**, or **pattern** efficiently.

---

### ⚙️ Purpose / How It Works

* The `find` command searches the filesystem recursively by checking directories and file metadata.
* The `locate` command uses a prebuilt database for faster lookups (via `updatedb`).
* Both can search using wildcards (`*`, `?`) and filters (e.g., size, date, type).

---

### 🧩 Commands / Examples

#### 🟢 1. Search by Exact Name (Case-Sensitive)

```bash
find / -name "myapp.conf" 2>/dev/null
```

**Example Output:**

```
/etc/myapp/myapp.conf
```

> `2>/dev/null` hides permission errors for cleaner output.

---

#### 🟢 2. Case-Insensitive Search

```bash
find /etc -iname "nginx.conf"
```

**Output:**

```
/etc/nginx/nginx.conf
```

> `-iname` ignores case differences (useful for mixed naming).

---

#### 🟢 3. Search by Partial Match (Wildcard)

```bash
find /var/log -name "*error*"
```

**Output Example:**

```
/var/log/httpd/error.log
/var/log/nginx/error.log
```

> Matches any file with “error” in its name.

---

#### 🟢 4. Find by File Extension

```bash
find /opt -type f -name "*.sh"
```

**Output Example:**

```
/opt/scripts/deploy.sh
/opt/tools/startup.sh
```

> `-type f` restricts search to files (omit for both files & directories).

---

#### 🟢 5. Search by Directory Name

```bash
find / -type d -name "backup"
```

**Output:**

```
/home/ec2-user/backup
/var/tmp/backup
```

> Use `-type d` for **directories only**.

---

#### 🟢 6. Using `locate` (Fastest Method)

```bash
sudo updatedb     # Update database (if needed)
locate myapp.conf
```

**Output:**

```
/etc/myapp/myapp.conf
/usr/local/etc/myapp.conf
```

> ⚙️ Faster than `find`, but results depend on the **last database update**.

---

#### 🟢 7. Search Specific Path + Depth

```bash
find /etc -maxdepth 2 -name "*.conf"
```

> Limits search recursion to 2 levels under `/etc` for performance.

---

#### 🟢 8. Combine Search + Command (e.g., display details)

```bash
find /var/log -name "*.log" -exec ls -lh {} \;
```

**Output Example:**

```
-rw-r--r-- 1 root root 2.1G /var/log/messages
-rw-r--r-- 1 root root 512M /var/log/secure
```

> Lists size and ownership of all `.log` files.

---

#### 🟢 9. Search for Recently Modified Files

```bash
find /var/log -name "*.log" -mtime -1
```

> Shows files modified in the last **1 day** (`-mtime -1`).

---

### 📋 Command Comparison

| Command                   | Speed  | Case        | Search Type    | Notes               |
| ------------------------- | ------ | ----------- | -------------- | ------------------- |
| `find / -name <file>`     | Medium | Sensitive   | File/directory | Most flexible       |
| `find / -iname <file>`    | Medium | Insensitive | File/directory | Case-insensitive    |
| `locate <file>`           | Fast   | Sensitive   | File only      | Uses prebuilt index |
| `grep -R "pattern" /path` | Slow   | N/A         | Inside files   | For content search  |

---

### ✅ Best Practices

* ⚙️ Use `find` for **accurate live searches**, `locate` for **quick lookups**.
* 🧠 Combine with `grep` to find both **filename** and **content**:

  ```bash
  find /etc -type f -name "*.conf" -exec grep -H "Listen" {} \;
  ```
* 🚀 Exclude system directories to speed up:

  ```bash
  find / -path /proc -prune -o -name "*.log" -print
  ```
* 🔒 Always include `2>/dev/null` to suppress permission errors.

---

### 💡 In short

Use `find / -name "<filename>"` to locate files instantly across the system.
For faster indexed searches, use `locate <filename>`.
Together, they’re your go-to tools for **finding configuration files, logs, or scripts** quickly and safely on any Linux server.

---
## Q: How Do You Check Which User Executed a Command in Linux?

---

### 🧠 Overview

Identifying **who executed a command** is key for **auditing**, **incident response**, and **compliance**.
Linux tracks user activity through **shell history**, **audit logs**, and **system logs** — allowing you to trace **commands, timestamps, and user IDs**.

---

### ⚙️ Purpose / How It Works

When a user runs a command:

* The shell (like **bash**) logs it in `~/.bash_history`.
* System-level actions (e.g., `sudo`, `su`, or privileged commands) are recorded in `/var/log/secure` or `/var/log/auth.log`.
* Audit frameworks like **auditd** capture detailed events — including command, user, PID, and timestamp.

---

### 🧩 Commands / Examples

#### 🟢 1. Check Bash History (Per User)

```bash
cat ~/.bash_history
```

**Example Output:**

```
sudo systemctl restart nginx
yum update -y
rm -rf /tmp/test
```

> Shows commands executed by the **current user**.

Check another user’s history:

```bash
sudo cat /home/ec2-user/.bash_history
```

> ⚙️ Note: Bash history is updated **after session logout** unless `PROMPT_COMMAND` is configured to log in real-time.

---

#### 🟢 2. Check `sudo` Command Logs

For privileged commands executed via `sudo`:

```bash
sudo cat /var/log/secure     # RHEL/CentOS/Amazon Linux
sudo cat /var/log/auth.log   # Ubuntu/Debian
```

**Example Output:**

```
Nov 11 10:52:14 ip-10-0-1-20 sudo: ec2-user : TTY=pts/0 ; PWD=/home/ec2-user ; USER=root ; COMMAND=/bin/systemctl restart nginx
```

> Shows:

* Who executed it → `ec2-user`
* As which user → `root`
* What command → `systemctl restart nginx`

---

#### 🟢 3. Check User Login & Session Info

```bash
last
```

**Example Output:**

```
ec2-user pts/0 10.0.0.25 Mon Nov 11 10:42   still logged in
root     pts/1 10.0.0.30 Mon Nov 11 09:10 - 09:32  (00:22)
```

> Correlate timestamps with commands from logs for attribution.

---

#### 🟢 4. Using Auditd (If Enabled)

```bash
sudo ausearch -x systemctl
```

**Example Output:**

```
type=EXECVE msg=audit(1731310210.123:88): argc=3 a0="systemctl" a1="restart" a2="nginx"
type=SYSCALL msg=audit(1731310210.123:88): pid=2178 uid=1000 auid=1000 comm="systemctl" exe="/bin/systemctl"
```

> `uid`/`auid` → the user who executed the command.
> Requires **auditd** to be running:

```bash
sudo systemctl start auditd
```

---

#### 🟢 5. Search for Command in Logs

```bash
sudo grep "systemctl restart nginx" /var/log/secure
```

> Finds who ran a specific command and when.

---

#### 🟢 6. Live Monitoring with `auditd`

To track all executed commands:

```bash
sudo auditctl -a always,exit -F arch=b64 -S execve -k command_log
ausearch -k command_log
```

> Logs every executed command system-wide (useful for production audit trails).

---

#### 🟢 7. View Active Users and TTYs

```bash
who
```

**Output Example:**

```
ec2-user  pts/0  2025-11-11 10:40 (10.0.0.25)
```

> Helps identify which user session is currently active when a command was executed interactively.

---

### 📋 Key Log Files

| File                       | Purpose                                     | Typical Distro           |
| -------------------------- | ------------------------------------------- | ------------------------ |
| `/var/log/secure`          | Records `sudo`, `su`, authentication events | RHEL/CentOS/Amazon Linux |
| `/var/log/auth.log`        | Authentication & sudo logs                  | Ubuntu/Debian            |
| `/var/log/audit/audit.log` | Full command audit via `auditd`             | All (if enabled)         |
| `~/.bash_history`          | Per-user shell command history              | All                      |
| `/root/.bash_history`      | Root user command history                   | All                      |

---

### ✅ Best Practices

* 🧩 **Enable `auditd`** for centralized, tamper-resistant command logging.
* ⚙️ Configure **real-time bash logging**:

  ```bash
  export PROMPT_COMMAND='history -a'
  ```
* 🔒 Restrict write access to history/log files (`chmod 600 ~/.bash_history`).
* 📦 Forward logs to **CloudWatch**, **Splunk**, or **SIEM** for long-term storage.
* 🧠 Regularly review `/var/log/secure` for unexpected privilege escalations.

---

### 💡 In short

To check **who executed a command**:

* Use `~/.bash_history` for user activity,
* `/var/log/secure` or `/var/log/auth.log` for `sudo` actions,
* and `auditd` (`ausearch`) for full forensic-level tracking.
  Together, these provide a complete audit trail of **what was run, by whom, and when**.

---
## Q: How Do You Check System Resource Usage History in Linux?

---

### 🧠 Overview

System resource history (CPU, memory, disk, network) helps you **analyze performance trends**, **debug past incidents**, and **verify patch or deployment impacts**.
Linux provides **CLI tools**, **system logs**, and **persistent monitoring daemons** (like `sar`, `sysstat`, or `atop`) to review **historical usage data**.

---

### ⚙️ Purpose / How It Works

* Tools like **sysstat (sar)** collect periodic snapshots of system metrics and save them in `/var/log/sa/`.
* **Cloud/agent tools** (e.g., AWS CloudWatch, Prometheus) export metrics for long-term retention.
* You can view CPU, memory, and I/O history directly from stored data or monitoring dashboards.

---

### 🧩 Commands / Examples

#### 🟢 1. View Historical Resource Usage via `sar` (sysstat)

Install if missing:

```bash
sudo yum install sysstat -y     # RHEL/CentOS/Amazon Linux
sudo apt install sysstat -y     # Ubuntu/Debian
sudo systemctl enable --now sysstat
```

##### a) CPU Usage History

```bash
sar -u 1 3
```

**Output Example:**

```
Linux 5.15.0-122-generic (ip-10-0-1-10)  11/11/2025
12:01:01 AM     CPU     %user  %nice %system %iowait %steal %idle
12:10:01 AM     all      3.12   0.01    1.05    0.02    0.00  95.80
```

To view data from previous days:

```bash
sar -u -f /var/log/sa/sa10
```

> (10 = 10th day of the month)

---

##### b) Memory Usage History

```bash
sar -r -f /var/log/sa/sa10
```

**Output Example:**

```
12:00:01 AM kbmemfree kbmemused  %memused kbbuffers kbcached
12:10:01 AM   1320944   6578044     83.3     25896   310428
```

---

##### c) Disk I/O Usage History

```bash
sar -d -f /var/log/sa/sa10
```

> Identifies disk throughput trends and busy devices.

---

##### d) Network Traffic History

```bash
sar -n DEV -f /var/log/sa/sa10
```

**Output Example:**

```
12:10:01 AM  eth0  rxpck/s  txpck/s  rxkB/s  txkB/s
12:10:01 AM  eth0    13.02    14.05     1.2     1.1
```

---

#### 🟢 2. View Historical Load Average (From Logs)

```bash
grep "load average" /var/log/syslog
```

or

```bash
grep "load average" /var/log/messages
```

**Output Example:**

```
Nov 11 03:02:01 ip-10-0-1-10 systemd[1]: Started Session load average: 1.02, 0.78, 0.45
```

---

#### 🟢 3. Using `atop` for Process-Level History

Install and enable service:

```bash
sudo apt install atop -y
sudo systemctl enable --now atop
```

View yesterday’s performance log:

```bash
sudo atop -r /var/log/atop/atop_20251110
```

> Use `t` (time), `m` (memory), `d` (disk), `n` (network) to filter stats.
> Great for post-incident root cause analysis (e.g., “what spiked at midnight?”).

---

#### 🟢 4. Using Cloud-Native Monitoring (AWS Example)

**Amazon CloudWatch Metrics**

```bash
# View CPU Utilization for an EC2 instance
aws cloudwatch get-metric-statistics \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --dimensions Name=InstanceId,Value=i-0123456789abcdef0 \
  --statistics Average \
  --period 300 \
  --start-time 2025-11-10T00:00:00Z \
  --end-time 2025-11-11T00:00:00Z
```

> Returns 5-minute average CPU usage across a 24-hour window.

---

#### 🟢 5. Historical Data from `/proc/stat` or `/proc/meminfo` (Real-Time Snapshot)

```bash
cat /proc/stat     # CPU stats since boot
cat /proc/meminfo  # Memory stats
```

> Combine with cron-based scripts for your own custom logs.

---

### 📋 Common Tools Summary

| Tool                            | Type                                | Data Retention            | Use Case                                   |
| ------------------------------- | ----------------------------------- | ------------------------- | ------------------------------------------ |
| `sar`                           | System activity collector (sysstat) | 7–30 days (configurable)  | Historical CPU, memory, disk, network      |
| `atop`                          | Detailed per-process history        | Configurable (daily logs) | Root cause analysis, performance debugging |
| `vmstat`, `iostat`, `mpstat`    | Real-time snapshot tools            | N/A                       | Quick performance checks                   |
| `journalctl`                    | System log                          | Days to weeks             | Event logs, not metrics                    |
| **AWS CloudWatch / Prometheus** | Cloud/agent metrics                 | Long-term                 | Graphs, alerts, trend analysis             |

---

### ✅ Best Practices

* ⚙️ Enable **sysstat (`sar`)** on all critical servers — lightweight and reliable.
* 🧠 Retain at least **7 days of `sar` logs** for post-patch or incident reviews.
* 📊 Use **atop** for deep-dive per-process history.
* 🚀 For AWS, integrate **CloudWatch Agent** or **Prometheus Node Exporter** for long-term retention.
* 🔒 Restrict access to logs — they may reveal system usage and credentials.

---

### 💡 In short

Use `sar -u`, `sar -r`, `sar -d`, and `sar -n` to review **CPU, memory, disk, and network history**.
For deep analysis, use `atop` (local) or **CloudWatch** (AWS).
Together, these tools give a complete picture of your system’s **past performance and resource utilization trends** — critical for capacity planning and post-incident reviews.

---
## Q: How to Find Large Files Consuming Disk Space in Linux?

---

### 🧠 Overview

Finding **large files** is essential when your server’s disk is full — especially before patching, backups, or deployments.
Linux provides several built-in commands like `find`, `du`, and `ls` to identify large files and their locations quickly.

---

### ⚙️ Purpose / How It Works

The Linux filesystem stores metadata (size, owner, timestamp) for every file.
Tools like `find` and `du` recursively scan directories and report file sizes so you can identify and clean up space hogs — like **old logs, dumps, and backups**.

---

### 🧩 Commands / Examples

#### 🟢 1. Find Files Larger Than 1 GB

```bash
sudo find / -type f -size +1G -exec ls -lh {} \; 2>/dev/null
```

**Example Output:**

```
-rw-r--r-- 1 root root 2.5G /var/log/messages.1
-rw-r--r-- 1 ec2-user ec2-user 1.2G /home/ec2-user/dump.sql
```

> `-size +1G` → files >1 GB
> `-type f` → only files
> `2>/dev/null` → suppress permission errors

---

#### 🟢 2. List Top 10 Largest Files (Human Readable)

```bash
sudo find / -type f -exec du -h {} + 2>/dev/null | sort -hr | head -10
```

**Example Output:**

```
3.8G /var/lib/mysql/ibdata1
2.5G /var/log/messages.1
1.2G /opt/app/dump.sql
```

---

#### 🟢 3. Check Largest Directories at Root Level

```bash
sudo du -h --max-depth=1 / | sort -hr | head
```

**Example Output:**

```
4.3G    /var
2.8G    /usr
1.2G    /opt
```

> Identify **which directory** is consuming space before diving deeper.

---

#### 🟢 4. Analyze Disk Usage by Directory (Recursive)

```bash
sudo du -ah /var | sort -hr | head -20
```

> Displays top 20 largest files/directories under `/var`.

---

#### 🟢 5. Check Large Log Files (Common Disk Hogs)

```bash
sudo du -h /var/log | sort -hr | head -10
```

**Example Output:**

```
2.5G /var/log/messages.1
1.8G /var/log/secure
```

> Often `/var/log`, `/opt`, or `/home` contain oversized logs or dumps.

---

#### 🟢 6. Using `ncdu` (Interactive Disk Analyzer)

```bash
sudo apt install ncdu -y      # Ubuntu/Debian
sudo yum install ncdu -y      # RHEL/Amazon Linux
sudo ncdu /
```

> Opens a **TUI interface** showing directories sorted by size — easy to navigate and delete files safely.

---

#### 🟢 7. Check Large Files in Home Directory

```bash
find /home -type f -size +500M -exec ls -lh {} \; | awk '{ print $5, $9 }' | sort -hr
```

> Quick check for user-uploaded large files or archives.

---

#### 🟢 8. Check Free Disk Space Before Cleanup

```bash
df -h
```

**Example Output:**

```
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1       40G   38G  1.2G  97% /
```

> Confirms which partition is filling up before deleting files.

---

### 📋 Useful File Size Units

| Flag    | Meaning             |
| ------- | ------------------- |
| `+1G`   | Larger than 1 GB    |
| `+500M` | Larger than 500 MB  |
| `+100K` | Larger than 100 KB  |
| `-100M` | Smaller than 100 MB |

---

### ✅ Best Practices

* ⚙️ Always check `/var/log`, `/opt`, `/tmp`, and `/home` — most common culprits.
* 🧩 Compress old logs instead of deleting:

  ```bash
  sudo gzip /var/log/messages.1
  ```
* 🧠 Enable **logrotate** for automatic cleanup.
* 🔒 Never delete system binaries under `/usr`, `/lib`, or `/bin`.
* 📊 Use **CloudWatch Agent / Prometheus Node Exporter** to monitor disk usage trends.
* 🧾 Document cleanup actions for audit traceability (especially on production systems).

---

### 💡 In short

Use `find / -type f -size +1G -exec ls -lh {} \;` to locate **large files**, or `du -h --max-depth=1 / | sort -hr` to spot **space-hungry directories**.
For quick, safe cleanup — use `ncdu`.
These commands give you full visibility into **what’s consuming disk space** so you can reclaim storage confidently and avoid downtime.

---
## Q: How to Check Running Services in Linux?

---

### 🧠 Overview

Checking **running services** helps ensure that critical system components (e.g., `sshd`, `nginx`, `docker`, `ssm-agent`) are **up and active** — especially after **patching, rebooting, or deployments**.
In modern Linux systems, **`systemd`** manages services, while older ones may use **`service`** or **`init.d`**.

---

### ⚙️ Purpose / How It Works

* **Systemd-based distros (Amazon Linux 2, Ubuntu ≥16.04, RHEL ≥7)** use `systemctl`.
* **SysVinit-based systems (older CentOS, RHEL 6)** use `service`.
* Both display **service status**, **start/stop state**, and **enabled (boot) configuration**.

---

### 🧩 Commands / Examples

#### 🟢 1. List All Active (Running) Services

```bash
systemctl list-units --type=service --state=running
```

**Example Output:**

```
  UNIT                      LOAD   ACTIVE SUB     DESCRIPTION
  sshd.service              loaded active running OpenSSH server daemon
  amazon-ssm-agent.service  loaded active running Amazon SSM Agent
  docker.service            loaded active running Docker Application Container Engine
```

> Displays only **currently active services** under systemd.

---

#### 🟢 2. Check All Services (Running or Stopped)

```bash
systemctl list-units --type=service
```

or the concise version:

```bash
systemctl --type=service --all
```

> Shows **active, inactive, failed, and disabled** services.

---

#### 🟢 3. Check Status of a Specific Service

```bash
systemctl status sshd
```

**Example Output:**

```
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled)
   Active: active (running) since Mon 2025-11-11 10:41:34 UTC; 1h 15min ago
 Main PID: 987 (sshd)
```

> Includes process ID, uptime, and last start time.

---

#### 🟢 4. Start / Stop / Restart Services

```bash
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
```

> Control services interactively or in automation scripts.

---

#### 🟢 5. Check Services Enabled on Boot

```bash
systemctl list-unit-files --type=service | grep enabled
```

**Example Output:**

```
sshd.service                 enabled
docker.service               enabled
amazon-ssm-agent.service     enabled
```

> Useful for ensuring **auto-start** after patch reboots.

---

#### 🟢 6. For SysVinit-Based Systems (Older OS)

```bash
service --status-all
```

**Output Example:**

```
 [ + ]  ssh
 [ + ]  crond
 [ - ]  nginx
```

> `+` → running, `-` → stopped.
> To check individual service:

```bash
service ssh status
```

---

#### 🟢 7. Filter Running Services by Keyword

```bash
systemctl list-units --type=service --state=running | grep nginx
```

**Output Example:**

```
nginx.service  loaded active running  A high performance web server
```

---

#### 🟢 8. Check Failed Services (Post-Patching)

```bash
systemctl --failed
```

**Output Example:**

```
  UNIT              LOAD   ACTIVE SUB    DESCRIPTION
● nginx.service     loaded failed failed A high performance web server
```

> ✅ Use this after reboot or patching to detect **failed startup services**.

---

#### 🟢 9. Check Service Logs (via systemd)

```bash
sudo journalctl -u nginx --since "1 hour ago"
```

> View logs of a specific service to debug startup issues.

---

### 📋 Common Services to Monitor

| Service            | Purpose               |
| ------------------ | --------------------- |
| `sshd`             | Secure remote access  |
| `amazon-ssm-agent` | AWS Systems Manager   |
| `docker`           | Container runtime     |
| `kubelet`          | Kubernetes node agent |
| `crond`            | Scheduled jobs        |
| `nginx` / `httpd`  | Web server            |
| `rsyslog`          | System logging        |
| `firewalld`        | Firewall management   |

---

### ✅ Best Practices

* ⚙️ Use `systemctl --failed` post-patching to confirm all critical services restarted.
* 🧠 Enable essential services to **start automatically on boot**:

  ```bash
  sudo systemctl enable sshd docker amazon-ssm-agent
  ```
* 🧩 Monitor service states continuously via **CloudWatch Agent** or **Prometheus Node Exporter**.
* 🚀 Use `journalctl -u <service>` for **debugging startup failures**.
* 🔒 Limit unnecessary services to reduce attack surface and resource usage.

---

### 💡 In short

Use `systemctl list-units --type=service --state=running` to list **running services**, and `systemctl status <service>` for details.
For older systems, use `service --status-all`.
Always verify critical services (like SSH, SSM, Docker) are **running and enabled on boot** after any **patch or reboot** event.

---
## Q: How to Restart a Specific Service in Linux?

---

### 🧠 Overview

Restarting a service is a common administrative task to **apply configuration changes**, **recover from failures**, or **refresh a daemon** after an update.
In modern Linux systems, **`systemd`** is used to manage services via `systemctl`.
Older systems use the `service` command or `/etc/init.d/` scripts.

---

### ⚙️ Purpose / How It Works

When you restart a service:

* The **current process stops** gracefully.
* The **service configuration** (from `/etc/systemd/system/` or `/etc/init.d/`) is **reloaded**.
* A **new process starts** under the same service unit, usually logged in `journalctl` or `/var/log/`.

---

### 🧩 Commands / Examples

#### 🟢 1. Restart Service (Systemd)

```bash
sudo systemctl restart nginx
```

**Example Output:**

```
# no output means success
```

To verify:

```bash
sudo systemctl status nginx
```

**Output:**

```
● nginx.service - A high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled)
   Active: active (running) since Tue 2025-11-11 11:30:02 UTC; 2s ago
```

> ✅ Recommended for **modern distros** (Amazon Linux 2, RHEL 7+, Ubuntu 16.04+).

---

#### 🟢 2. Restart Multiple Services

```bash
sudo systemctl restart sshd docker ssm-agent
```

> Useful after patching or configuration updates.

---

#### 🟢 3. Reload Config Without Full Restart (Zero Downtime)

```bash
sudo systemctl reload nginx
```

> Reloads configuration files (like `/etc/nginx/nginx.conf`) without stopping the service.

---

#### 🟢 4. Restart Service and Confirm

```bash
sudo systemctl restart docker && sudo systemctl is-active docker
```

**Output:**

```
active
```

> Ensures the service restarted successfully.

---

#### 🟢 5. For Older (SysVinit) Systems

```bash
sudo service httpd restart
```

**Output:**

```
Stopping httpd: [OK]
Starting httpd: [OK]
```

> Used in older RHEL 6, CentOS 6, or legacy systems.

---

#### 🟢 6. Using Init Scripts (Legacy)

```bash
sudo /etc/init.d/sshd restart
```

> Fallback option if `systemctl` or `service` commands aren’t available.

---

#### 🟢 7. Check Logs After Restart

```bash
sudo journalctl -u nginx -n 20
```

or

```bash
sudo tail -f /var/log/nginx/error.log
```

> View startup logs and verify successful service launch.

---

### 📋 Common Examples

| Service             | Restart Command                           |
| ------------------- | ----------------------------------------- |
| **SSH**             | `sudo systemctl restart sshd`             |
| **Docker**          | `sudo systemctl restart docker`           |
| **Nginx**           | `sudo systemctl restart nginx`            |
| **Apache (httpd)**  | `sudo systemctl restart httpd`            |
| **SSM Agent (AWS)** | `sudo systemctl restart amazon-ssm-agent` |
| **Kubelet**         | `sudo systemctl restart kubelet`          |

---

### ✅ Best Practices

* ⚙️ Always verify restart with `systemctl status <service>`.
* 🧠 Prefer `reload` for config changes (e.g., Nginx) to avoid downtime.
* 🧾 For critical services (like SSH), **test changes in a second session** before restart — prevents lockout.
* 🚀 Automate restarts via **CI/CD post-deploy hooks** or **AWS SSM RunCommand**.
* 📊 Use `systemctl is-failed <service>` post-restart to detect failures.

---

### 💡 In short

Use `sudo systemctl restart <service>` (e.g., `sshd`, `nginx`, `docker`) to safely restart a service, then verify with `systemctl status`.
For older systems, use `sudo service <service> restart`.
Always check logs and confirm the service **came back healthy** after restart — especially on production servers.

---
## Q: How to Monitor Disk I/O Performance in Linux?

---

### 🧠 Overview

Monitoring **Disk I/O (Input/Output)** performance helps identify **storage bottlenecks**, **slow applications**, or **patching impacts**.
I/O metrics show **how much data is read/written** and **how long operations take**, helping detect overloaded or failing disks.

---

### ⚙️ Purpose / How It Works

* The Linux kernel exposes I/O stats via `/proc/diskstats`.
* Tools like `iostat`, `vmstat`, `iotop`, and `dstat` read this data in real-time.
* Cloud environments (like AWS EC2) can also send I/O metrics to **CloudWatch**.

---

### 🧩 Commands / Examples

#### 🟢 1. Using `iostat` (Recommended)

Install **sysstat** package if missing:

```bash
sudo yum install sysstat -y      # RHEL / CentOS / Amazon Linux
sudo apt install sysstat -y      # Ubuntu / Debian
```

Run:

```bash
iostat -xz 2 5
```

**Example Output:**

```
Device:         r/s     w/s   rkB/s   wkB/s  await  svctm  %util
xvda           12.5     5.3   640.2   210.4   4.10   0.52   2.50
```

**Key Metrics:**

| Metric           | Description                                       |
| ---------------- | ------------------------------------------------- |
| `r/s`, `w/s`     | Reads/writes per second                           |
| `rkB/s`, `wkB/s` | Read/write throughput                             |
| `await`          | Avg. time (ms) I/O waits — **<10ms is good**      |
| `%util`          | Disk utilization — **close to 100% = bottleneck** |

> ✅ **Best all-in-one tool** for ongoing disk performance analysis.

---

#### 🟢 2. Using `iotop` (Per-Process I/O Usage)

```bash
sudo apt install iotop -y     # or yum install iotop -y
sudo iotop
```

**Example Output:**

```
Total DISK READ: 2.00 M/s | Total DISK WRITE: 1.50 M/s
PID  USER      DISK READ  DISK WRITE  COMMAND
1234 root      1.80 M/s   0.00 B/s    mysqld
5678 ec2-user  0.20 M/s   1.50 M/s    tar -czf backup.tgz
```

> Shows **which processes** are performing heavy reads/writes in real-time.

---

#### 🟢 3. Using `vmstat` (Quick Snapshot)

```bash
vmstat 2 5
```

**Output Example:**

```
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b  swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 1  0     0 512000  23456 120000    0    0   200   150  320  540  5  2 90  3  0
```

**Columns Explained:**

* `bi` = blocks read from disk/sec
* `bo` = blocks written to disk/sec
* `wa` = time CPU waits for I/O (% I/O wait)

> 🔍 If `wa` > 20%, disk I/O may be slowing the system.

---

#### 🟢 4. Using `dstat` (All-in-One Realtime)

```bash
sudo yum install dstat -y
sudo dstat -cdngy
```

**Output Example:**

```
----total-cpu-usage---- ---disk/total--- ---net/total---
usr sys idl wai hiq siq | read  writ | recv  send
  5   2  90   3   0   0 | 200k  150k |  25k   20k
```

> Combines **CPU + Disk + Network** — great for live troubleshooting.

---

#### 🟢 5. Using `pidstat` (Per-Process Disk Stats)

```bash
pidstat -d 2 5
```

**Output Example:**

```
11:42:01 AM   UID   PID  kB_rd/s  kB_wr/s  Command
11:42:03 AM  1001  3245    1.20     350.00  java
11:42:03 AM  1001  5687    0.00     420.00  postgres
```

> See **which process is writing/reading most**.

---

#### 🟢 6. Check Disk Latency via `sar`

```bash
sar -d 2 5
```

**Output Example:**

```
DEV   tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz  await  %util
xvda  8.5   640.3    210.5     38.5      0.12      4.52   2.5
```

> Excellent for **historical I/O performance** (from `/var/log/sa/`).

---

#### 🟢 7. AWS CloudWatch Example (EC2 I/O Metrics)

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name DiskWriteOps \
  --dimensions Name=InstanceId,Value=i-0123456789abcdef \
  --statistics Average \
  --period 300 \
  --start-time 2025-11-11T00:00:00Z \
  --end-time 2025-11-11T12:00:00Z
```

> Retrieve historical IOPS for EC2 instances.

---

### 📋 Tool Comparison

| Tool         | Focus             | Use Case                   | Frequency                |
| ------------ | ----------------- | -------------------------- | ------------------------ |
| `iostat`     | Disk device stats | Overall disk performance   | Periodic (every few sec) |
| `iotop`      | Process-level I/O | Find heavy I/O processes   | Realtime                 |
| `vmstat`     | CPU + I/O summary | Quick performance snapshot | Realtime                 |
| `dstat`      | Combined metrics  | Live multi-resource view   | Realtime                 |
| `sar -d`     | Historical I/O    | Long-term trend analysis   | From `/var/log/sa/`      |
| `pidstat -d` | Per-process I/O   | Application-level insights | Realtime                 |

---

### ✅ Best Practices

* ⚙️ Use `iostat -xz 1` for baseline performance checks.
* 🧠 Watch `%util` and `await` — indicators of disk pressure.
* 📊 Collect data with `sar` for post-incident analysis.
* 🚀 Monitor long-term trends via **AWS CloudWatch**, **Prometheus**, or **Grafana**.
* 🔒 Separate logs and data disks in production to reduce contention.
* 🧩 Run I/O checks **after patching or kernel updates** to confirm storage health.

---

### 💡 In short

Use `iostat -xz 2 5` for quick disk I/O stats, `iotop` for **process-level analysis**, and `sar -d` for **historical trends**.
Focus on **%util** and **await** — if they’re consistently high, your disk or EBS volume may be a **performance bottleneck**.

---
## Q: How to Check User Permissions on a File in Linux?

---

### 🧠 Overview

File permissions in Linux define **who can read, write, or execute** a file.
Checking permissions is crucial for **security**, **troubleshooting access errors**, and **deployment validation** (e.g., config files, scripts, SSH keys).

Linux uses a **permission model** with **user (owner)**, **group**, and **others** — represented in symbolic (`rwx`) or numeric (`755`) format.

---

### ⚙️ Purpose / How It Works

Each file’s metadata includes:

* **Owner (user)** → creator or assigned user.
* **Group** → group that has access.
* **Permission bits** → define read/write/execute rights.

Permissions are stored in the file’s **inode** and displayed via commands like `ls -l` or `stat`.

---

### 🧩 Commands / Examples

#### 🟢 1. Check File Permissions (Symbolic View)

```bash
ls -l /etc/passwd
```

**Example Output:**

```
-rw-r--r-- 1 root root 2458 Nov 11 10:22 /etc/passwd
```

**Breakdown:**

| Part        | Meaning                                 |
| ----------- | --------------------------------------- |
| `-`         | File type (`-` = file, `d` = directory) |
| `rw-`       | Owner can **read/write**                |
| `r--`       | Group can **read only**                 |
| `r--`       | Others can **read only**                |
| `root root` | Owner = root, Group = root              |

> So `/etc/passwd` is readable by everyone, writable only by `root`.

---

#### 🟢 2. Check Permissions on a Directory

```bash
ls -ld /var/log
```

**Output:**

```
drwxr-xr-x 10 root root 4096 Nov 11 11:20 /var/log
```

> `d` → directory
> `rwx` (owner) → full access
> `r-x` (group/others) → read + execute (can list/enter)

---

#### 🟢 3. Numeric (Octal) Permission Representation

```bash
stat -c "%A %a %U %G %n" /etc/ssh/sshd_config
```

**Output:**

```
-rw------- 600 root root /etc/ssh/sshd_config
```

| Field | Description                 |
| ----- | --------------------------- |
| `600` | Octal permission            |
| `%A`  | Symbolic form (`rw-------`) |
| `%a`  | Numeric form (600)          |
| `%U`  | Owner user                  |
| `%G`  | Owner group                 |
| `%n`  | Filename                    |

---

#### 🟢 4. Verify If a Specific User Can Access a File

```bash
sudo -u ec2-user test -r /etc/ssh/sshd_config && echo "Readable" || echo "Not readable"
sudo -u ec2-user test -w /etc/ssh/sshd_config && echo "Writable" || echo "Not writable"
```

> Checks **read/write** permission for a given user.

---

#### 🟢 5. View Access Control Lists (Extended Permissions)

```bash
getfacl /var/log/messages
```

**Example Output:**

```
# file: var/log/messages
# owner: root
# group: root
user::rw-
group::r--
other::r--
```

> Shows standard permissions + any **ACL overrides** (used in fine-grained access control).

---

#### 🟢 6. Check Ownership Only

```bash
ls -l /opt/myapp/config.yaml | awk '{print $3, $4}'
```

**Output:**

```
appuser appgroup
```

---

#### 🟢 7. Search Files Owned by a User

```bash
sudo find /var/www -user nginx
```

> Lists all files owned by user `nginx` — useful for audits or cleanup.

---

### 📋 Permission Levels (Quick Reference)

| Symbolic | Numeric | Meaning        | Access Rights                     |
| -------- | ------- | -------------- | --------------------------------- |
| `r--`    | 4       | Read           | View file contents                |
| `-w-`    | 2       | Write          | Modify or delete                  |
| `--x`    | 1       | Execute        | Run as program or enter directory |
| `rw-`    | 6       | Read + Write   | Edit file                         |
| `r-x`    | 5       | Read + Execute | View + run                        |
| `rwx`    | 7       | Full Access    | Read + Write + Execute            |

---

### ✅ Best Practices

* ⚙️ Use `stat` for precise permission + owner info.
* 🔒 Sensitive files (like `/etc/shadow`, SSH keys) should be `600` or stricter.
* 🧠 Regularly verify permissions after **deployments or patching**.
* 🧩 Use **ACLs (`getfacl`, `setfacl`)** for complex permission needs.
* 🚀 Automate permission checks in **CI/CD** or **compliance pipelines** using shell or Ansible tasks.

---

### 💡 In short

Use `ls -l` for a quick view or `stat -c "%A %a %U %G %n" <file>` for detailed info.
Permissions show **who can read, write, or execute** a file, helping secure your Linux environment and troubleshoot **“Permission denied”** errors efficiently.

---
## Q: How to Change File Permissions or Ownership in Linux?

---

### 🧠 Overview

Changing file **permissions** and **ownership** is a key Linux admin task — used for securing files, enabling application access, or fixing “**Permission denied**” errors.
Linux uses two primary commands for this:

* `chmod` → change file permissions (read/write/execute)
* `chown` / `chgrp` → change file owner and group

---

### ⚙️ Purpose / How It Works

Each file has 3 permission sets:

* **User (Owner)**
* **Group**
* **Others**

Permissions can be modified in:

* **Symbolic mode** (`u`, `g`, `o`, `a` + `+`, `-`, `=`)
* **Numeric mode** (`chmod 755`, `chmod 600`, etc.)

Ownership defines **who owns** the file (`user:group`) — controlled by `chown`.

---

### 🧩 Commands / Examples

#### 🟢 1. Change File Permissions (Symbolic Mode)

```bash
chmod u+x script.sh
```

> Adds execute (`x`) permission for the **owner**.

```bash
chmod g-w report.txt
```

> Removes write permission from the **group**.

```bash
chmod o=r /tmp/data.txt
```

> Gives **read-only** access to others.

---

#### 🟢 2. Change File Permissions (Numeric Mode)

```bash
chmod 755 /usr/local/bin/deploy.sh
```

**Breakdown:**

| User | Group | Others | Meaning                                       |
| ---- | ----- | ------ | --------------------------------------------- |
| 7    | 5     | 5      | `rwxr-xr-x` (owner full, others read/execute) |

Other common permission values:

| Mode  | Meaning                       | Example Usage                  |
| ----- | ----------------------------- | ------------------------------ |
| `600` | Owner can read/write          | Private files (e.g., SSH keys) |
| `644` | Owner read/write, others read | Config files                   |
| `700` | Owner full access             | Scripts or home directories    |
| `755` | Everyone can read/execute     | Public scripts or binaries     |

---

#### 🟢 3. Change Ownership of a File

```bash
sudo chown ec2-user /opt/app/config.yaml
```

> Sets owner to `ec2-user`.

Change owner **and group**:

```bash
sudo chown ec2-user:appgroup /opt/app/config.yaml
```

**Output check:**

```bash
ls -l /opt/app/config.yaml
```

```
-rw-r--r-- 1 ec2-user appgroup 2048 Nov 11 11:42 config.yaml
```

---

#### 🟢 4. Change Group Only

```bash
sudo chgrp devops /var/www/html
```

> Sets group to `devops` (without changing owner).

---

#### 🟢 5. Recursively Change Ownership/Permissions

```bash
sudo chown -R nginx:nginx /var/www/html
sudo chmod -R 755 /var/www/html
```

> Applies changes to all **subdirectories and files** recursively.

---

#### 🟢 6. Set Default Permissions for Newly Created Files

```bash
umask 022
```

> Default: files get `644`, directories get `755`.
> Adjust in `/etc/profile` or `~/.bashrc` for persistent settings.

---

#### 🟢 7. Verify Changes

```bash
ls -l /opt/app/
```

**Example Output:**

```
-rwxr-xr-- 1 appuser appgroup 3.2K deploy.sh
```

> Confirms `chmod 754` + ownership assignment.

---

### 📋 Symbolic Reference

| Symbol | Meaning      | Applies To    |
| ------ | ------------ | ------------- |
| `u`    | user (owner) | Owner only    |
| `g`    | group        | Group members |
| `o`    | others       | Everyone else |
| `a`    | all          | All users     |

| Operator | Effect               |
| -------- | -------------------- |
| `+`      | Add permission       |
| `-`      | Remove permission    |
| `=`      | Set exact permission |

---

### ✅ Best Practices

* 🔒 Set **least privilege** (e.g., `600` for sensitive files like SSH keys).
* 🧩 Use `sudo chown` for system-owned files only — avoid permission issues.
* ⚙️ Combine `chmod` + `chown` for app deployments:

  ```bash
  sudo chown -R nginx:nginx /var/www/html
  sudo chmod -R 755 /var/www/html
  ```
* 🧾 Always verify with `ls -l` or `stat`.
* 🚀 For multi-user environments, manage access via **groups** rather than “others”.
* 🧠 Avoid using `chmod 777` — it allows **anyone full access**, a major security risk.

---

### 💡 In short

Use `chmod` to **change permissions**, `chown` to **change owner**, and `chgrp` to **change group**.
Example:

```bash
sudo chown ec2-user:devops /opt/app/config.yaml
sudo chmod 640 /opt/app/config.yaml
```

This gives `ec2-user` secure ownership with read access for `devops` — the safest, most common setup in production.

---
## Q: How to Check Which Users Are Logged In on a Linux System?

---

### 🧠 Overview

Knowing who’s **logged in** helps monitor **active sessions**, detect **unauthorized access**, and verify **admin activity** during maintenance or patching.
Linux provides multiple commands (`who`, `w`, `users`, `last`) to list currently logged-in users, their session details, and login history.

---

### ⚙️ Purpose / How It Works

When users log in (via SSH, console, or TTY), Linux records session details in `/var/run/utmp` (active sessions) and `/var/log/wtmp` (login history).
Utilities like `who` and `w` read from these files to show real-time user activity.

---

### 🧩 Commands / Examples

#### 🟢 1. Show All Logged-In Users (Simple)

```bash
who
```

**Example Output:**

```
ec2-user  pts/0  2025-11-11 10:40 (10.0.0.25)
root      pts/1  2025-11-11 11:05 (10.0.0.30)
```

**Fields:**

| Field     | Description           |
| --------- | --------------------- |
| Username  | Logged-in user        |
| TTY       | Terminal session      |
| Date/Time | Login time            |
| Host      | Remote IP or hostname |

> ✅ Quick snapshot of who is currently connected.

---

#### 🟢 2. Detailed View of Logged-In Users

```bash
w
```

**Example Output:**

```
 11:25:43 up 2 days,  3:17,  2 users,  load average: 0.15, 0.12, 0.08
USER     TTY      FROM         LOGIN@   IDLE   JCPU   PCPU WHAT
ec2-user pts/0    10.0.0.25    10:40    1:21   0.10s  0.10s -bash
root     pts/1    10.0.0.30    11:05    2.00s  0.20s  0.01s top
```

> Shows who’s logged in, **from where**, and **what command** they are running.

---

#### 🟢 3. List Usernames Only

```bash
users
```

**Output:**

```
ec2-user root
```

> Simple list of currently logged-in users — no timestamps or session info.

---

#### 🟢 4. Show Current User (Your Session)

```bash
whoami
```

**Output:**

```
ec2-user
```

> Prints the **effective username** of your current shell session.

---

#### 🟢 5. Display Login History

```bash
last
```

**Example Output:**

```
ec2-user pts/0  10.0.0.25 Mon Nov 11 10:40   still logged in
root     pts/1  10.0.0.30 Mon Nov 11 09:10 - 09:32  (00:22)
reboot   system boot      Mon Nov 11 08:05
```

> Shows **past logins**, **durations**, and **reboots** — useful for audit and compliance.

---

#### 🟢 6. Check User Logged In via SSH

```bash
sudo journalctl -u sshd | grep "Accepted"
```

**Output Example:**

```
Nov 11 10:40:21 ip-10-0-1-25 sshd[2209]: Accepted publickey for ec2-user from 10.0.0.25 port 50222 ssh2
```

> Displays accepted SSH logins — includes user, source IP, and timestamp.

---

#### 🟢 7. Display Active Sessions (TTY Info)

```bash
who -a
```

**Output Example:**

```
           system boot  2025-11-11 08:05
LOGIN      tty1         2025-11-11 08:05
ec2-user   pts/0        2025-11-11 10:40   00:02   2209 (:0)
```

> Includes both **console** and **remote** sessions.

---

### 📋 Command Comparison

| Command              | Purpose                | Output Example                   |
| -------------------- | ---------------------- | -------------------------------- |
| `who`                | Current logins (basic) | User, TTY, time, IP              |
| `w`                  | Detailed session info  | User, idle time, running process |
| `users`              | Usernames only         | List of active users             |
| `whoami`             | Current session user   | Single username                  |
| `last`               | Login history          | Past logins & reboots            |
| `journalctl -u sshd` | SSH login tracking     | Accepted connections             |

---

### ✅ Best Practices

* 🔒 Monitor user logins using `w` or `who` before patching or rebooting.
* 🧠 Use `last` to audit login patterns for anomalies.
* 🚨 Set up **login alerts** via `auditd`, **CloudWatch Events**, or `fail2ban`.
* ⚙️ For production, disable root SSH login and enforce key-based authentication.
* 📦 Forward `/var/log/secure` or `/var/log/auth.log` to a central SIEM for auditing.

---

### 💡 In short

Use `who` or `w` to see **who’s logged in right now**, and `last` to review **login history**.
For security and compliance, always monitor `/var/log/auth.log` or `journalctl -u sshd` for **SSH login events** — ensuring only authorized users access your system.

---
## Q: How to See Scheduled Cron Jobs in Linux?

---

### 🧠 Overview

Cron jobs automate recurring tasks like **backups, log rotations, patch checks, or cleanup scripts**.
You can list and manage cron jobs at the **user level** or **system level** using commands like `crontab`, `ls`, and by checking cron configuration directories.

---

### ⚙️ Purpose / How It Works

* The **cron daemon (`crond`)** runs jobs on defined schedules (minute/hour/day/month/week).
* Jobs are defined in **crontab files**, either per user or globally in system cron directories.
* Cron schedules use a **5-field syntax** representing time and frequency.

---

### 🧩 Commands / Examples

#### 🟢 1. List Cron Jobs for Current User

```bash
crontab -l
```

**Example Output:**

```
# ┌──────────── minute (0 - 59)
# │ ┌────────── hour (0 - 23)
# │ │ ┌──────── day of month (1 - 31)
# │ │ │ ┌────── month (1 - 12)
# │ │ │ │ ┌──── day of week (0 - 6)
# │ │ │ │ │
# │ │ │ │ │
  0  2  *  *  *  /usr/local/bin/db-backup.sh
  30 4  *  *  1  /usr/local/bin/weekly-report.sh
```

> Displays the **cron jobs scheduled for the current user**.

---

#### 🟢 2. List Cron Jobs for Another User

```bash
sudo crontab -u ec2-user -l
```

> Requires root privileges — lists cron jobs owned by `ec2-user`.

---

#### 🟢 3. View System-Wide Cron Jobs

System-level cron jobs are defined in:

```bash
cat /etc/crontab
```

**Example Output:**

```
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

# m h dom mon dow user command
0 * * * * root /usr/lib64/sa/sa1 1 1
```

> Includes an extra **user field** (the account executing the command).

---

#### 🟢 4. Check Cron Directories

| Location             | Purpose                                   |
| -------------------- | ----------------------------------------- |
| `/etc/cron.hourly/`  | Scripts run hourly                        |
| `/etc/cron.daily/`   | Scripts run daily                         |
| `/etc/cron.weekly/`  | Scripts run weekly                        |
| `/etc/cron.monthly/` | Scripts run monthly                       |
| `/etc/cron.d/`       | Custom cron job definitions (system-wide) |

**Example:**

```bash
ls -lh /etc/cron.daily/
```

**Output:**

```
-rwxr-xr-x  root  logrotate
-rwxr-xr-x  root  0yum-daily.cron
```

> These jobs are triggered automatically by system cron timers.

---

#### 🟢 5. Check Active Cron Service

```bash
sudo systemctl status crond
```

**Output Example:**

```
● crond.service - Command Scheduler
   Loaded: loaded (/usr/lib/systemd/system/crond.service; enabled)
   Active: active (running) since Tue 2025-11-11 10:42:13 UTC; 1h 2min ago
```

> Ensures cron daemon is running — required for scheduled jobs to execute.

---

#### 🟢 6. View Logs of Executed Cron Jobs

```bash
sudo grep CRON /var/log/syslog     # Ubuntu/Debian
sudo grep CRON /var/log/cron       # RHEL/CentOS/Amazon Linux
```

**Example Output:**

```
Nov 11 02:00:01 ip-10-0-1-5 CRON[1123]: (root) CMD (/usr/local/bin/db-backup.sh)
```

> Useful for **verifying cron execution** and **debugging failed jobs**.

---

#### 🟢 7. Using `systemctl list-timers` (For `systemd`-based Jobs)

Some modern systems (Amazon Linux 2023, Ubuntu ≥20.04) use `systemd` timers instead of cron.

```bash
systemctl list-timers --all
```

**Output Example:**

```
NEXT                        LEFT       LAST                        UNIT                      ACTIVATES
Tue 2025-11-11 02:00:00 UTC 4h 10min   Mon 2025-11-10 02:00:01 UTC logrotate.timer          logrotate.service
```

> Shows **scheduled systemd timers** and when they’ll next execute.

---

### 📋 Cron Syntax Quick Reference

| Field        | Range | Description                |
| ------------ | ----- | -------------------------- |
| Minute       | 0–59  | When in the hour           |
| Hour         | 0–23  | When in the day            |
| Day of Month | 1–31  | Which day of the month     |
| Month        | 1–12  | Which month                |
| Day of Week  | 0–6   | Sunday (0) to Saturday (6) |

**Example:**

```
30 3 * * 1 /usr/local/bin/backup.sh
```

→ Runs every **Monday at 3:30 AM**

---

### ✅ Best Practices

* ⚙️ Use `crontab -e` for editing — it prevents syntax mistakes.
* 🧠 Redirect cron output to logs for debugging:

  ```bash
  0 2 * * * /usr/local/bin/backup.sh >> /var/log/backup.log 2>&1
  ```
* 🔒 Avoid using root’s cron unless necessary — prefer app-level users.
* 🚀 Verify cron execution via `/var/log/cron` or systemd timer logs.
* 📦 In cloud/DevOps setups, use **AWS Systems Manager Automation** or **GitLab CI/CD schedules** for scalable job orchestration.

---

### 💡 In short

Use `crontab -l` for user jobs, `cat /etc/crontab` and `/etc/cron.*` for system jobs, and `grep CRON /var/log/syslog` to verify execution.
Together, these let you **inspect, validate, and troubleshoot** all scheduled cron activities on your Linux servers.

---
## Q: How to Check Network Connectivity Without Using `ping` in Linux?

---

### 🧠 Overview

If **ICMP (`ping`) is blocked** by a firewall or security group, you can still test network connectivity using other TCP/UDP-based tools like `curl`, `nc`, `telnet`, or `ss`.
These methods help confirm whether a **specific port/service** (e.g., 22, 80, 443) is reachable — which is often more relevant in production than plain ICMP.

---

### ⚙️ Purpose / How It Works

* `ping` uses **ICMP Echo**, which many firewalls drop.
* Alternatives use **application-layer or TCP/UDP** checks (e.g., connect to HTTP, SSH, or DNS).
* These provide **real connectivity validation** — not just route availability.

---

### 🧩 Commands / Examples

#### 🟢 1. Test TCP Port Connectivity with `nc` (Netcat)

```bash
nc -zv google.com 443
```

**Output:**

```
Connection to google.com 443 port [tcp/https] succeeded!
```

> ✅ Confirms that TCP 443 (HTTPS) is reachable.

**Options:**

* `-z` → scan without sending data
* `-v` → verbose (show connection result)

You can test multiple ports:

```bash
nc -zv 10.0.0.5 22 80 443
```

---

#### 🟢 2. Use `curl` to Test HTTP/HTTPS

```bash
curl -I https://example.com
```

**Output:**

```
HTTP/1.1 200 OK
Server: nginx/1.18.0
```

> Confirms HTTP/HTTPS connectivity and retrieves response headers.

To test only TCP connection (no output):

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://example.com
```

---

#### 🟢 3. Check DNS Resolution (Without ICMP)

```bash
dig google.com
```

or

```bash
nslookup google.com
```

**Output Example:**

```
google.com.   300  IN  A  142.250.185.206
```

> Verifies DNS resolution — if it fails, the host might not be reachable by name.

---

#### 🟢 4. Test Specific TCP Port with `telnet` (Simple)

```bash
telnet github.com 443
```

**Output:**

```
Trying 140.82.112.3...
Connected to github.com.
Escape character is '^]'.
```

> If it connects, TCP communication works.
> If it hangs or fails — port is blocked or service down.

> ⚠️ `telnet` may not be installed by default — use `nc` instead for modern systems.

---

#### 🟢 5. Using `ss` (Socket Statistics)

Check if a local service port is listening:

```bash
sudo ss -tuln | grep 22
```

**Output:**

```
LISTEN 0 128 0.0.0.0:22 0.0.0.0:*
```

> Confirms SSH (port 22) is open locally — useful for inbound troubleshooting.

---

#### 🟢 6. Using `tracepath` (Layer 3/4 Route Test)

```bash
tracepath example.com
```

**Output Example:**

```
 1?: [LOCALHOST]                      pmtu 9001
 1:  10.0.0.1                         0.524ms
 2:  52.93.8.4                        2.220ms
```

> Similar to `traceroute`, but **does not require root** or ICMP — shows routing path.

---

#### 🟢 7. Check Outbound Port via `/dev/tcp`

```bash
echo > /dev/tcp/google.com/443 && echo "Connected" || echo "Connection failed"
```

**Output:**

```
Connected
```

> Uses Bash’s built-in TCP socket feature — handy in restricted shells.

---

#### 🟢 8. Verify Service Accessibility Using `wget`

```bash
wget --spider https://aws.amazon.com
```

**Output:**

```
Spider mode enabled. Checking if remote file exists...
Remote file exists.
```

> Confirms **internet and web service connectivity**.

---

### 📋 Comparison of Methods

| Command            | Checks                    | ICMP Needed | Common Use          |
| ------------------ | ------------------------- | ----------- | ------------------- |
| `nc -zv`           | TCP/UDP port reachability | ❌ No        | Any port/service    |
| `curl`             | HTTP/HTTPS                | ❌ No        | Web endpoints       |
| `dig` / `nslookup` | DNS resolution            | ❌ No        | Name resolution     |
| `telnet`           | TCP connectivity          | ❌ No        | Legacy port test    |
| `tracepath`        | Routing path              | ❌ No        | Network route debug |
| `/dev/tcp`         | TCP socket                | ❌ No        | Quick shell test    |
| `wget --spider`    | HTTP availability         | ❌ No        | App-level check     |

---

### ✅ Best Practices

* ⚙️ Use `nc` for **port reachability** — reliable and scriptable.
* 🧠 Always verify **DNS resolution** (`dig`) before testing ports.
* 🔒 Test **specific ports** instead of ICMP for firewall-limited networks.
* 🚀 In AWS or Kubernetes, combine with `curl` or `wget` inside pods to test **service connectivity**.
* 🧩 Automate connectivity checks in CI/CD using `nc`, `curl`, or `dig`.

---

### 💡 In short

When `ping` is blocked, use:

* `nc -zv <host> <port>` → test TCP/UDP reachability
* `curl -I <URL>` → test HTTP/HTTPS
* `dig <domain>` → test DNS
  These tools verify real-world connectivity to **services and applications**, not just raw network reachability.

---
## Q: How to Check DNS Resolution in Linux?

---

### 🧠 Overview

**DNS resolution** translates domain names (like `google.com`) into IP addresses.
If DNS fails, commands like `ping`, `curl`, or `yum` will fail even when the network is up.
You can test DNS using commands like `dig`, `nslookup`, and `host`, or by inspecting system resolver settings.

---

### ⚙️ Purpose / How It Works

When you access a domain:

1. The resolver checks `/etc/resolv.conf` for DNS servers.
2. It queries them to resolve the name → IP address (A/AAAA record).
3. The system caches the result temporarily for faster lookups.

DNS testing tools help validate whether this name resolution process is **working, slow, or misconfigured**.

---

### 🧩 Commands / Examples

#### 🟢 1. Check DNS Resolution with `dig` (Recommended)

```bash
dig google.com
```

**Example Output:**

```
;; QUESTION SECTION:
;google.com.          IN  A

;; ANSWER SECTION:
google.com.     300  IN  A  142.250.185.206

;; Query time: 25 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Tue Nov 11 12:45:01 UTC 2025
```

**Key Fields:**

| Field            | Description                 |
| ---------------- | --------------------------- |
| `ANSWER SECTION` | The resolved IP(s)          |
| `Query time`     | Response latency            |
| `SERVER`         | DNS server used             |
| `A`              | IPv4 record (`AAAA` = IPv6) |

> ✅ `dig` gives detailed diagnostics and confirms **which DNS server** responded.

---

#### 🟢 2. Use `dig` for Specific Record Types

```bash
dig www.github.com A
dig www.github.com AAAA
dig github.com MX
dig github.com NS
```

**Record Types:**

| Type    | Meaning                |
| ------- | ---------------------- |
| `A`     | IPv4 address           |
| `AAAA`  | IPv6 address           |
| `MX`    | Mail server            |
| `NS`    | Name server            |
| `CNAME` | Canonical name (alias) |

---

#### 🟢 3. Quick Output with `dig +short`

```bash
dig +short amazon.com
```

**Output:**

```
176.32.103.205
205.251.242.103
```

> Minimal output — perfect for scripting or quick lookups.

---

#### 🟢 4. Test DNS Resolution with `nslookup`

```bash
nslookup google.com
```

**Output Example:**

```
Server:    8.8.8.8
Address:   8.8.8.8#53

Non-authoritative answer:
Name: google.com
Address: 142.250.185.206
```

> Shows DNS server and resolved IP; simpler than `dig`.

Specify a DNS server:

```bash
nslookup google.com 1.1.1.1
```

> Tests resolution using Cloudflare’s DNS (1.1.1.1).

---

#### 🟢 5. Check Reverse DNS (IP → Hostname)

```bash
dig -x 142.250.185.206 +short
```

**Output:**

```
del03s03-in-f14.1e100.net.
```

> Confirms the reverse DNS mapping for an IP address.

---

#### 🟢 6. Using `host` Command (Simple)

```bash
host example.com
```

**Output:**

```
example.com has address 93.184.216.34
```

> Lightweight alternative to `dig` and `nslookup`.

---

#### 🟢 7. Verify DNS Configuration File

```bash
cat /etc/resolv.conf
```

**Example Output:**

```
nameserver 8.8.8.8
nameserver 1.1.1.1
search corp.local
```

> Lists the DNS servers your system uses for name resolution.

---

#### 🟢 8. Check Local Hostname Resolution

```bash
getent hosts localhost
```

**Output:**

```
127.0.0.1   localhost
::1         localhost
```

> Confirms name-to-IP mapping via `/etc/hosts` and DNS combined.

---

#### 🟢 9. Test DNS Resolution Through a Specific Interface

```bash
dig @8.8.8.8 example.com
```

> Forces query through a specific DNS server (e.g., Google DNS).

---

### 📋 Command Comparison

| Command        | Description                        | Output Detail | Use Case        |
| -------------- | ---------------------------------- | ------------- | --------------- |
| `dig`          | Detailed DNS lookup                | High          | Troubleshooting |
| `dig +short`   | Minimal IP output                  | Low           | Scripting       |
| `nslookup`     | Simple lookup with DNS server info | Medium        | Quick check     |
| `host`         | Minimal, fast                      | Low           | Lightweight     |
| `getent hosts` | Uses system resolver (hosts + DNS) | Medium        | Host validation |

---

### ✅ Best Practices

* ⚙️ Always verify `/etc/resolv.conf` → ensure valid DNS servers.
* 🧠 Use `dig +trace` to debug DNS propagation or delegation issues:

  ```bash
  dig +trace example.com
  ```
* 🔒 Avoid relying solely on internal DNS servers — configure public fallback (e.g., `8.8.8.8`, `1.1.1.1`).
* 🚀 For cloud environments, test both **private (VPC)** and **public** DNS resolution.
* 📊 In Kubernetes, test inside pods:

  ```bash
  kubectl exec -it pod-name -- nslookup google.com
  ```

---

### 💡 In short

Use `dig` (or `nslookup`) to confirm DNS resolution.
For quick results:

```bash
dig +short example.com
```

For debugging:

```bash
dig example.com @8.8.8.8
```

These commands confirm that **domain names resolve correctly**, DNS servers are reachable, and your Linux system can translate hostnames into IPs — the foundation of all network connectivity.

---
## Q: How Do You Secure SSH Access in Linux?

---

### 🧠 Overview

Securing SSH is a **critical part of Linux hardening** — especially on production servers or cloud environments (AWS EC2, EKS nodes, on-prem VMs).
SSH (Secure Shell) provides encrypted access, but weak configurations or credentials can lead to compromise.

---

### ⚙️ Purpose / How It Works

SSH uses **public-key cryptography** for secure, encrypted connections.
Hardening SSH involves:

* Restricting who can log in,
* Enforcing key-based authentication,
* Reducing attack surface (e.g., port, users), and
* Monitoring for intrusion attempts.

---

### 🧩 Key Commands / Configuration Examples

#### 🟢 1. Disable Root Login (Direct Access)

Edit SSH config:

```bash
sudo vi /etc/ssh/sshd_config
```

Change:

```
PermitRootLogin no
```

Apply changes:

```bash
sudo systemctl restart sshd
```

> ✅ Prevents direct `root` access — users must log in as normal users and escalate via `sudo`.

---

#### 🟢 2. Use Key-Based Authentication (No Passwords)

Generate SSH key on client:

```bash
ssh-keygen -t ed25519 -C "vasu@devops"
```

Copy public key to server:

```bash
ssh-copy-id ec2-user@<server-ip>
```

Or manually append:

```bash
cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

Disable password login:

```
PasswordAuthentication no
ChallengeResponseAuthentication no
```

> 🔒 Ensures only authorized SSH keys are accepted.

---

#### 🟢 3. Limit Which Users Can Log In

In `/etc/ssh/sshd_config`:

```
AllowUsers ec2-user adminuser
```

or

```
AllowGroups devops ssm
```

> Restricts SSH access to specific accounts or groups only.

---

#### 🟢 4. Change Default SSH Port

In `/etc/ssh/sshd_config`:

```
Port 2222
```

Restart SSH:

```bash
sudo systemctl restart sshd
```

> 🚫 Avoids mass automated attacks targeting port 22.
> *(Remember to open this port in firewall or AWS Security Group.)*

---

#### 🟢 5. Use Fail2Ban to Block Brute Force Attempts

Install & enable Fail2Ban:

```bash
sudo apt install fail2ban -y
sudo systemctl enable --now fail2ban
```

> Automatically bans IPs after multiple failed SSH login attempts.

Configuration file:

```bash
/etc/fail2ban/jail.local
```

Example:

```
[sshd]
enabled = true
bantime = 1h
findtime = 10m
maxretry = 3
```

---

#### 🟢 6. Restrict SSH Access via Firewall (UFW / iptables)

Using UFW:

```bash
sudo ufw allow 2222/tcp
sudo ufw deny 22/tcp
sudo ufw enable
```

Or AWS Security Group:

* Allow SSH from **trusted IPs only** (e.g., your office IP, VPN CIDR).

> ✅ Prevents open SSH exposure to the internet.

---

#### 🟢 7. Use SSH Protocol 2 Only

Ensure in `/etc/ssh/sshd_config`:

```
Protocol 2
```

> SSHv1 is deprecated and insecure — always use v2.

---

#### 🟢 8. Enable Idle Session Timeout

```
ClientAliveInterval 300
ClientAliveCountMax 2
```

> Disconnects idle SSH sessions after **10 minutes** (300s × 2).

---

#### 🟢 9. Use Multi-Factor Authentication (MFA)

Install Google PAM module:

```bash
sudo apt install libpam-google-authenticator -y
google-authenticator
```

Enable in `/etc/pam.d/sshd` and `/etc/ssh/sshd_config`:

```
AuthenticationMethods publickey,keyboard-interactive
```

> Adds a one-time token (OTP) to SSH logins for added protection.

---

#### 🟢 10. Audit SSH Logs

```bash
sudo tail -f /var/log/auth.log     # Ubuntu/Debian
sudo tail -f /var/log/secure       # RHEL/Amazon Linux
```

Look for:

```
Failed password for invalid user admin from 203.0.113.10 port 54022 ssh2
Accepted publickey for ec2-user from 10.0.0.5 port 51212 ssh2
```

> 🧠 Regularly review or forward these logs to a SIEM (CloudWatch, Splunk, ELK).

---

### 📋 SSH Hardening Summary

| Measure            | Purpose                     | Example                     |
| ------------------ | --------------------------- | --------------------------- |
| Disable Root Login | Prevent direct root access  | `PermitRootLogin no`        |
| Use SSH Keys       | Replace passwords           | `PasswordAuthentication no` |
| Restrict Users     | Allow specific users/groups | `AllowUsers ec2-user`       |
| Change Port        | Avoid port 22 attacks       | `Port 2222`                 |
| Enable Fail2Ban    | Block brute force           | `/etc/fail2ban/jail.local`  |
| Use Firewall Rules | Limit source IPs            | `ufw allow from <IP>`       |
| Protocol 2         | Secure version              | `Protocol 2`                |
| MFA                | Two-factor SSH              | PAM module                  |
| Log Auditing       | Detect intrusions           | `/var/log/auth.log`         |

---

### ✅ Best Practices

* 🔒 Always use **key-based SSH**; disable password and root logins.
* 🧠 Use **SSM Session Manager (AWS)** instead of SSH when possible (no open ports).
* 🧩 Rotate SSH keys regularly and remove stale ones.
* 🚀 Automate SSH hardening via **Ansible playbooks** or **Terraform user data**.
* 🧾 Forward logs to **CloudWatch / ELK** for central monitoring.

---

### 💡 In short

To secure SSH access:

1. Use **key-based auth only**,
2. Disable **root & password logins**,
3. Limit **users and source IPs**,
4. Add **Fail2Ban + firewall rules**, and
5. Monitor **SSH logs** regularly.

These practices make SSH resilient against brute-force, credential theft, and unauthorized access — a must for **production-grade DevOps systems**.

---
## Q: How Do You Find and Kill Zombie or Stuck Processes in Linux?

---

### 🧠 Overview

Zombie and stuck (hung) processes can **consume system resources**, **block service restarts**, or **indicate faulty applications**.

* 🧟 **Zombie process** = finished execution but parent hasn’t cleaned it (defunct).
* ⚠️ **Stuck process** = running or waiting on I/O indefinitely (can’t exit normally).

Identifying and cleaning these processes keeps your system **stable and performant**.

---

### ⚙️ Purpose / How It Works

* The kernel tracks every process (via PID and state in `/proc`).
* Zombie = state `Z` (defunct, waiting for parent cleanup).
* Stuck = state `D` (uninterruptible sleep, usually due to I/O lock).
* You can find them with `ps`, `top`, or `htop`, and safely terminate or trace them.

---

### 🧩 Commands / Examples

#### 🟢 1. Find Zombie Processes

```bash
ps aux | grep 'Z'
```

or

```bash
ps -eo pid,ppid,state,cmd | grep 'Z'
```

**Example Output:**

```
1234  1123  Z  [nginx] <defunct>
```

> * `PID 1234` is zombie.
> * `PPID 1123` → parent process not reaping its child.

---

#### 🟢 2. Verify Zombies Using `top`

```bash
top
```

Look at the **“Tasks”** line:

```
Tasks: 212 total, 1 running, 0 sleeping, 1 zombie
```

> Shows how many zombie processes exist system-wide.

You can press `Z` in `top` to highlight zombie processes.

---

#### 🟢 3. List Only Zombies

```bash
ps -el | grep Z
```

**Output:**

```
F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY  TIME CMD
0 Z  1000  2234  1123  0  80   0 -    0 exit   ?    00:00:00 nginx <defunct>
```

---

#### 🟢 4. Kill the Parent Process (to Clear Zombies)

Find parent PID (PPID) of the zombie:

```bash
ps -o ppid= -p 2234
```

Kill it:

```bash
sudo kill -HUP <parent_pid>
```

> Sends hang-up signal to force the parent to reap its child.
> If it doesn’t work:

```bash
sudo kill -9 <parent_pid>
```

> ⚠️ Be cautious — killing a parent can terminate an entire service.

---

#### 🟢 5. Find Stuck (Uninterruptible Sleep) Processes

```bash
ps -eo pid,stat,comm | grep 'D'
```

**Example Output:**

```
3345 D disk_io_worker
4450 D java
```

> `D` = **waiting on disk or I/O**, often due to kernel/hardware issues.

---

#### 🟢 6. Analyze Why a Process Is Stuck

Use `strace` to trace system calls:

```bash
sudo strace -p <pid>
```

**Example Output:**

```
read(3, 0x7ffcf234, 1024) = ? EAGAIN (Resource temporarily unavailable)
```

> Shows where the process is hanging (e.g., file lock, network wait).

---

#### 🟢 7. Kill Stuck Process Safely

Try normal termination first:

```bash
sudo kill <pid>
```

If unresponsive:

```bash
sudo kill -9 <pid>
```

> `SIGKILL (-9)` immediately ends the process (cannot be caught).

---

#### 🟢 8. Monitor Resource-Hogging or Frozen Processes

```bash
top -o %CPU
```

or

```bash
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head
```

> Identify processes consuming excessive CPU/memory before they hang.

---

#### 🟢 9. Check Kernel/Hardware Locks

```bash
sudo dmesg | tail
```

**Output Example:**

```
blk_update_request: I/O error, dev xvda, sector 10240
```

> Indicates a process stuck due to **disk I/O issue** — killing won’t help until hardware recovers.

---

#### 🟢 10. Forcefully Clear All Defunct Zombies (Rare)

```bash
sudo pkill -HUP -P 1
```

> Sends cleanup signal to init/systemd (PID 1) to reap orphaned zombies.
> *(Do not use indiscriminately on production unless necessary.)*

---

### 📋 Process State Reference

| Code | Meaning               | Description                             |
| ---- | --------------------- | --------------------------------------- |
| `R`  | Running               | Actively executing                      |
| `S`  | Sleeping              | Waiting for event                       |
| `D`  | Uninterruptible Sleep | Stuck (I/O wait)                        |
| `T`  | Stopped               | Paused by signal or job control         |
| `Z`  | Zombie                | Process finished but not reaped         |
| `X`  | Dead                  | Should not be seen in normal conditions |

---

### ✅ Best Practices

* 🧠 Investigate **why** processes hang — don’t just `kill -9`.
* ⚙️ Restart affected services rather than killing parents randomly.
* 🧩 Use `strace` or `lsof -p <pid>` to trace hung file/network operations.
* 🚀 Automate zombie detection via monitoring tools (e.g., `ps`, `top`, `nagios`, `cloudwatch-agent`).
* 🔒 Keep kernels and drivers up to date to prevent I/O stalls.

---

### 💡 In short

* Use `ps -eo pid,ppid,state,cmd | grep Z` → find zombies.
* Use `ps -eo pid,stat,comm | grep D` → find stuck I/O processes.
* Clear by killing **parent (zombie)** or **process itself (stuck)**.
  Always confirm the cause using `strace` before killing — in production, focus on **preventing** stuck processes via **code fixes, timeouts, and monitoring**.

----
## Q: How Do You Monitor Logs in Real Time in Linux?

---

### 🧠 Overview

Real-time log monitoring helps **detect issues as they occur** — such as failed SSH attempts, service crashes, or deployment errors.
In Linux, logs are typically stored under `/var/log/` and can be tailed, streamed, or monitored continuously using tools like `tail`, `less +F`, `journalctl -f`, or centralized log agents (e.g., CloudWatch, ELK).

---

### ⚙️ Purpose / How It Works

* Log files grow as system or app events occur.
* Real-time monitoring tools stream **new lines appended** to a file or journal.
* You can filter, follow, and analyze logs interactively — perfect for patching, deployments, or troubleshooting.

---

### 🧩 Commands / Examples

#### 🟢 1. Follow Logs in Real Time with `tail`

```bash
sudo tail -f /var/log/messages
```

**Example Output:**

```
Nov 11 12:42:01 ip-10-0-1-21 systemd[1]: Started Session 123 of user ec2-user.
Nov 11 12:42:05 ip-10-0-1-21 sshd[2209]: Accepted publickey for ec2-user from 10.0.0.5 port 50022 ssh2
```

> `-f` keeps the file open and prints new entries as they are written.

To show the last 50 lines and continue:

```bash
sudo tail -n 50 -f /var/log/syslog
```

---

#### 🟢 2. Monitor Multiple Log Files Simultaneously

```bash
sudo tail -f /var/log/syslog /var/log/auth.log
```

> Streams both logs in one view — useful for correlation between system and authentication events.

---

#### 🟢 3. Use `less +F` for Scrollable Real-Time View

```bash
sudo less +F /var/log/secure
```

> Similar to `tail -f`, but allows **scrolling back** while following new data (`Ctrl+C` to stop following, `Shift+F` to resume).

---

#### 🟢 4. Filter Live Logs by Keyword

```bash
sudo tail -f /var/log/messages | grep "error"
```

**Example Output:**

```
Nov 11 12:43:22 httpd[3402]: [error] Permission denied: access to /admin denied
```

> Filters only lines containing “error” — perfect for live debugging.
> For case-insensitive search:

```bash
grep -i "fail"
```

---

#### 🟢 5. Monitor Systemd Service Logs (Modern Systems)

```bash
sudo journalctl -u nginx -f
```

**Output Example:**

```
Nov 11 12:45:01 ip-10-0-1-21 nginx[1203]: Starting nginx: [ OK ]
Nov 11 12:45:05 ip-10-0-1-21 nginx[1203]: nginx started successfully
```

> `-u` = unit (service), `-f` = follow new entries.

You can combine with filters:

```bash
sudo journalctl -u sshd --since "10 min ago"
```

> Shows SSH logs from the last 10 minutes.

---

#### 🟢 6. Colorize & Highlight Log Output

```bash
sudo tail -f /var/log/syslog | ccze
```

> Use `ccze` (install via `sudo apt install ccze -y`) for color-coded log readability.

---

#### 🟢 7. Monitor Application-Specific Logs

Examples:

```bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/httpd/error_log
sudo tail -f /var/log/amazon/ssm/amazon-ssm-agent.log
```

> Each application typically logs to its own directory under `/var/log/`.

---

#### 🟢 8. Real-Time Monitoring with `multitail`

```bash
sudo multitail /var/log/syslog /var/log/auth.log
```

> Interactive tool that splits the screen and shows **multiple logs side-by-side** — great for multi-service debugging.

---

#### 🟢 9. Follow Logs Over SSH (Remote Systems)

```bash
ssh ec2-user@server "sudo tail -f /var/log/messages"
```

> Stream logs from remote machines without transferring files.

---

#### 🟢 10. Forward Logs to Cloud Monitoring (AWS Example)

Install and configure **CloudWatch Agent**:

```bash
sudo yum install amazon-cloudwatch-agent -y
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent.json -s
```

> Streams local logs to CloudWatch for **real-time dashboarding and alerting**.

---

### 📋 Common Log Locations

| Log File                             | Description                           |
| ------------------------------------ | ------------------------------------- |
| `/var/log/messages`                  | General system messages (RHEL/CentOS) |
| `/var/log/syslog`                    | System logs (Ubuntu/Debian)           |
| `/var/log/secure`                    | Authentication, sudo, SSH logs        |
| `/var/log/dmesg`                     | Kernel and hardware logs              |
| `/var/log/httpd/`, `/var/log/nginx/` | Web server logs                       |
| `/var/log/amazon/ssm/`               | AWS Systems Manager logs              |
| `/var/log/cron`                      | Cron job logs                         |

---

### ✅ Best Practices

* 🧠 Use `journalctl -u <service> -f` for **systemd-based** services.
* ⚙️ Combine `tail -f` with `grep` or `awk` for **targeted filtering**.
* 🚀 Use `multitail` or `ccze` for real-time multi-log analysis.
* 🔒 Restrict log access — `/var/log` often contains sensitive info.
* 📦 Centralize logs with **CloudWatch, ELK, or Loki** for long-term analysis.
* 🧩 Set up alerting based on log patterns (e.g., “error”, “failed”, “denied”).

---

### 💡 In short

Use `tail -f /var/log/<file>` or `journalctl -u <service> -f` to monitor logs live.
Add `grep` to filter and `multitail` or `ccze` for better visualization.
In production, stream logs to **CloudWatch or ELK** for real-time centralized monitoring and alerting.

---
## Q: How to Check Firewall Rules in Linux?

---

### 🧠 Overview

Firewalls protect your Linux system by **controlling inbound and outbound network traffic** based on rules.
Depending on your distribution and version, firewall management is done via **`iptables`**, **`firewalld`**, or **`ufw`**.
Checking firewall rules helps verify **open ports**, **blocked services**, and **security configurations** — especially after deployments or patching.

---

### ⚙️ Purpose / How It Works

* **`iptables`**: legacy tool — manages rules directly in the Linux kernel.
* **`firewalld`**: modern daemon — uses “zones” and dynamic configuration.
* **`ufw` (Uncomplicated Firewall)**: simplified wrapper (mainly Ubuntu/Debian).

All ultimately control **netfilter**, the kernel-level packet filtering framework.

---

### 🧩 Commands / Examples

#### 🟢 1. Check if Firewall Is Active

**For `firewalld`:**

```bash
sudo systemctl status firewalld
```

**Output:**

```
● firewalld.service - firewalld - dynamic firewall daemon
   Active: active (running)
```

**For `ufw`:**

```bash
sudo ufw status
```

**Output:**

```
Status: active
```

**For `iptables`:**

```bash
sudo iptables -L
```

If no rules appear, it may not be active or rules are empty.

---

#### 🟢 2. View All Firewall Rules (firewalld)

```bash
sudo firewall-cmd --list-all
```

**Output Example:**

```
public (active)
  interfaces: eth0
  services: ssh dhcpv6-client
  ports: 8080/tcp 9000/tcp
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

> Shows active **zone**, allowed services, and open ports.

To list all zones:

```bash
sudo firewall-cmd --list-all-zones
```

To check the zone for a specific interface:

```bash
sudo firewall-cmd --get-active-zones
```

---

#### 🟢 3. List All Rules in `iptables`

```bash
sudo iptables -L -v -n
```

**Output Example:**

```
Chain INPUT (policy ACCEPT 102 packets, 12800 bytes)
 pkts bytes target     prot opt in  out  source      destination
  512  38K ACCEPT     tcp  --  *   *    0.0.0.0/0   0.0.0.0/0  tcp dpt:22
  120  10K DROP       all  --  *   *    192.168.1.100  0.0.0.0/0
```

**Flags:**

* `-L` → list rules
* `-v` → verbose (packet/byte counts)
* `-n` → numeric (don’t resolve hostnames)

> 🔍 Shows rules for **INPUT**, **OUTPUT**, and **FORWARD** chains.

---

#### 🟢 4. Show NAT Rules (useful for forwarding)

```bash
sudo iptables -t nat -L -n -v
```

**Example:**

```
Chain POSTROUTING (policy ACCEPT)
MASQUERADE  all  --  10.0.0.0/24  !10.0.0.0/24
```

> Used for routing and masquerading (common in Kubernetes, Docker).

---

#### 🟢 5. Using `nftables` (Newer Systems)

```bash
sudo nft list ruleset
```

**Example Output:**

```
table inet firewalld {
  chain input {
    type filter hook input priority 0;
    policy accept;
    tcp dport 22 accept
    tcp dport 80 accept
  }
}
```

> `nftables` is the successor to `iptables` on RHEL 9, Ubuntu 22+, and Debian 12.

---

#### 🟢 6. UFW (Ubuntu/Debian) Rules Overview

```bash
sudo ufw status verbose
```

**Output Example:**

```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
8080/tcp                   ALLOW       10.0.0.0/24
```

> Shows default policies and per-port rules.

List raw iptables rules behind UFW:

```bash
sudo iptables -L -n -v
```

---

#### 🟢 7. Check Listening Ports (for Cross-Validation)

```bash
sudo ss -tuln
```

**Output Example:**

```
Netid State  Recv-Q Send-Q Local Address:Port  Peer Address:Port
tcp   LISTEN 0      128    0.0.0.0:22         0.0.0.0:*
tcp   LISTEN 0      128    0.0.0.0:8080       0.0.0.0:*
```

> Verifies which services are **actually listening** vs. firewall rules.

---

#### 🟢 8. Save/Export Firewall Rules

**Firewalld:**

```bash
sudo firewall-cmd --runtime-to-permanent
```

**iptables:**

```bash
sudo iptables-save > /root/firewall-backup.rules
```

**nftables:**

```bash
sudo nft list ruleset > /root/nftables-backup.conf
```

> Good practice before patching or system upgrades.

---

### 📋 Comparison of Firewall Tools

| Tool        | Distro                                   | Command to View Rules     | Default Config File       |
| ----------- | ---------------------------------------- | ------------------------- | ------------------------- |
| `firewalld` | RHEL / CentOS 7+, Fedora, Amazon Linux 2 | `firewall-cmd --list-all` | `/etc/firewalld/`         |
| `iptables`  | All (legacy)                             | `iptables -L -v -n`       | `/etc/sysconfig/iptables` |
| `ufw`       | Ubuntu / Debian                          | `ufw status verbose`      | `/etc/ufw/`               |
| `nftables`  | RHEL 9 / Ubuntu 22+                      | `nft list ruleset`        | `/etc/nftables.conf`      |

---

### ✅ Best Practices

* 🔒 Default policy should be **deny incoming**, **allow outgoing**.
* ⚙️ Open only necessary ports (e.g., 22, 443, 80).
* 🧩 Combine with **security groups** or **VPC NACLs** (in AWS).
* 🧠 Regularly export and version-control firewall rules.
* 🚀 After any patching/reboot, verify the firewall is active:

  ```bash
  sudo systemctl is-active firewalld
  ```
* 📊 Integrate firewall logs into **CloudWatch / ELK** for intrusion monitoring.

---

### 💡 In short

Use:

* `sudo firewall-cmd --list-all` → for `firewalld`
* `sudo iptables -L -v -n` → for legacy setups
* `sudo ufw status verbose` → for Ubuntu systems
  These show all active rules, ports, and policies — helping ensure your firewall correctly enforces **least-privilege network access**.

---
## Q: How to Mount and Unmount File Systems in Linux?

---

### 🧠 Overview

Mounting a file system makes a **storage device (disk, partition, NFS share, ISO, etc.)** accessible within the Linux directory tree.
Unmounting safely detaches it, ensuring all data is written to disk and no corruption occurs.
You’ll typically mount disks under `/mnt` or `/media` for temporary use or `/data` for permanent storage.

---

### ⚙️ Purpose / How It Works

Linux uses a **virtual file system (VFS)** to unify all storage under `/`.
Each device or partition is linked (“mounted”) to a specific **mount point** (a directory).
The kernel uses the **mount table** (`/etc/mtab` or `/proc/mounts`) to track all active mounts.

---

### 🧩 Commands / Examples

#### 🟢 1. Identify Available Disks and Partitions

```bash
lsblk
```

**Example Output:**

```
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
xvda    202:0    0   40G  0 disk
├─xvda1 202:1    0   10G  0 part /
├─xvda2 202:2    0   10G  0 part /data
└─xvdb  202:16   0   20G  0 disk
```

> `xvdb` = new unmounted volume.

You can also run:

```bash
sudo fdisk -l
```

to see partitions and file system types (e.g., ext4, xfs).

---

#### 🟢 2. Create a Mount Point

```bash
sudo mkdir -p /mnt/data
```

> This directory will be used to attach (mount) the disk.

---

#### 🟢 3. Mount the File System

```bash
sudo mount /dev/xvdb1 /mnt/data
```

> Mounts partition `/dev/xvdb1` to `/mnt/data`.

Check success:

```bash
df -h | grep /mnt/data
```

**Output:**

```
/dev/xvdb1  20G  1.1G  18G  6%  /mnt/data
```

---

#### 🟢 4. Mount by File System Type

```bash
sudo mount -t ext4 /dev/xvdb1 /mnt/data
```

> `-t ext4` explicitly specifies the filesystem type.

---

#### 🟢 5. Mount a Network File System (NFS)

```bash
sudo mount -t nfs 10.0.0.5:/shared /mnt/nfs
```

> Mounts an NFS share from a remote host to `/mnt/nfs`.

---

#### 🟢 6. Mount an ISO Image

```bash
sudo mount -o loop /tmp/ubuntu.iso /mnt/iso
```

> `-o loop` mounts the ISO file as a virtual disk.

---

#### 🟢 7. View All Mounted File Systems

```bash
mount | column -t
```

or

```bash
findmnt
```

**Output Example:**

```
TARGET     SOURCE     FSTYPE  OPTIONS
/          /dev/xvda1 ext4    rw,relatime
/mnt/data  /dev/xvdb1 ext4    rw,relatime
```

---

#### 🟢 8. Unmount a File System

```bash
sudo umount /mnt/data
```

or by device name:

```bash
sudo umount /dev/xvdb1
```

> Always unmount before detaching disks (especially in AWS EBS or USB drives).

If busy (device in use):

```bash
sudo umount -l /mnt/data       # Lazy unmount
sudo fuser -vm /mnt/data       # Show which process is using it
sudo kill <PID>                # Kill process and retry
```

---

#### 🟢 9. Mount File System Automatically on Boot (`/etc/fstab`)

Edit the file:

```bash
sudo vi /etc/fstab
```

Add entry:

```
/dev/xvdb1   /mnt/data   ext4   defaults,nofail   0   2
```

Then reload:

```bash
sudo mount -a
```

> ✅ Ensures the disk mounts automatically after reboot.

---

#### 🟢 10. Check Mount Options and Status

```bash
cat /proc/mounts
```

**Example Output:**

```
/dev/xvda1 / ext4 rw,relatime,data=ordered 0 0
```

> Shows all current mounts with options like `rw`, `noexec`, `relatime`.

---

### 📋 Common Mount Options

| Option     | Meaning                                                |
| ---------- | ------------------------------------------------------ |
| `rw`       | Read-write access                                      |
| `ro`       | Read-only                                              |
| `noexec`   | Disallow execution of binaries                         |
| `nosuid`   | Ignore SUID bits for security                          |
| `nodev`    | Prevent device files                                   |
| `defaults` | Common defaults (`rw,suid,dev,exec,auto,nouser,async`) |
| `nofail`   | Prevent boot failure if device missing                 |

---

### ✅ Best Practices

* ⚙️ Always unmount before detaching or resizing disks.
* 🧩 Use `mount -o noexec,nodev,nosuid` for shared or untrusted volumes.
* 🔒 For sensitive mounts, restrict permissions on the mount point.
* 🚀 Automate mounting via `/etc/fstab` or cloud-init user data.
* 🧾 Monitor mount status post-boot using `findmnt` or `df -h`.

---

### 💡 In short

Use:

* `sudo mount /dev/xvdb1 /mnt/data` → to mount
* `sudo umount /mnt/data` → to unmount
* Add to `/etc/fstab` for persistence.
  Check with `lsblk`, `findmnt`, or `df -h`.
  These commands let you safely attach, verify, and detach storage volumes on any Linux system — from local disks to cloud EBS or NFS shares.

---
## Q: How Do You Check SELinux Status in Linux?

---

### 🧠 Overview

**SELinux (Security-Enhanced Linux)** is a mandatory access control (MAC) system that enforces security policies beyond traditional file permissions.
It controls how **processes, users, and files** interact — critical for hardening systems like **RHEL, CentOS, and Amazon Linux**.
Checking SELinux status helps confirm if it’s **enforcing, permissive, or disabled** — especially after deployments or policy changes.

---

### ⚙️ Purpose / How It Works

* SELinux applies **context-based rules** to processes and files.
* Operates in one of three modes:

  * **Enforcing** → actively blocks policy violations
  * **Permissive** → only logs violations (no blocking)
  * **Disabled** → completely turned off

---

### 🧩 Commands / Examples

#### 🟢 1. Check SELinux Status (Quick)

```bash
getenforce
```

**Example Output:**

```
Enforcing
```

> Returns one of: `Enforcing`, `Permissive`, or `Disabled`.

---

#### 🟢 2. Detailed Status Report

```bash
sestatus
```

**Example Output:**

```
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
Current mode:                   enforcing
Mode from config file:          enforcing
Policy version:                 33
Policy from config file:        targeted
```

> ✅ Shows runtime status, policy type (`targeted`, `mls`, `minimum`), and configuration source.

---

#### 🟢 3. View Configuration File

```bash
cat /etc/selinux/config
```

**Example Output:**

```
# This file controls the state of SELinux on the system.
SELINUX=enforcing
SELINUXTYPE=targeted
```

| Setting                | Description                               |
| ---------------------- | ----------------------------------------- |
| `SELINUX=enforcing`    | SELinux active and enforcing policy       |
| `SELINUX=permissive`   | Logs policy violations only               |
| `SELINUX=disabled`     | SELinux completely off                    |
| `SELINUXTYPE=targeted` | Applies to targeted system processes only |

> ⚠️ Changing this file requires a reboot to take effect.

---

#### 🟢 4. Check File or Process Contexts

To verify file context:

```bash
ls -Z /var/www/html/
```

**Output Example:**

```
-rw-r--r--. root root system_u:object_r:httpd_sys_content_t:s0 index.html
```

> Shows **SELinux context** (user:role:type:level).

To check process context:

```bash
ps -eZ | grep httpd
```

**Output:**

```
system_u:system_r:httpd_t:s0   1234 ?  Ss   0:00 /usr/sbin/httpd
```

---

#### 🟢 5. Temporarily Change SELinux Mode

Switch to permissive (for debugging):

```bash
sudo setenforce 0
```

Re-enable enforcing:

```bash
sudo setenforce 1
```

Verify:

```bash
getenforce
```

**Output:**

```
Permissive
```

> 🔧 Temporary change — resets to config file mode on reboot.

---

#### 🟢 6. Check SELinux Logs for Violations

```bash
sudo cat /var/log/audit/audit.log | grep denied
```

or via `ausearch`:

```bash
sudo ausearch -m avc -ts recent
```

> Shows **access denials** (e.g., Apache blocked from reading `/home/user`).

---

#### 🟢 7. List Installed SELinux Policies

```bash
semodule -l
```

**Output Example:**

```
abrt  1.0.0
apache  2.9.0
dhcp  1.2.1
```

> Lists loaded SELinux modules controlling application behavior.

---

### 📋 SELinux Modes Summary

| Mode           | Description                                   | Typical Use Case                |
| -------------- | --------------------------------------------- | ------------------------------- |
| **Enforcing**  | Enforces security policies, denies violations | Production servers              |
| **Permissive** | Logs policy violations, does not enforce      | Testing / Debugging             |
| **Disabled**   | SELinux off entirely                          | Containers / Debug environments |

---

### ✅ Best Practices

* 🔒 Keep SELinux **enabled (enforcing)** in production — disabling weakens system security.
* 🧠 Use `setenforce 0` only for **temporary troubleshooting**.
* 🧩 Always inspect audit logs (`audit.log`) when apps fail unexpectedly — SELinux may be blocking them.
* 🚀 For custom services, assign correct **SELinux context** using:

  ```bash
  sudo restorecon -Rv /var/www/html
  ```
* 📦 Tools like `semanage`, `audit2allow`, and `chcon` help manage or create SELinux policies safely.

---

### 💡 In short

Use:

```bash
getenforce        # Quick check  
sestatus          # Detailed view  
cat /etc/selinux/config  # Persistent mode  
```

If SELinux blocks an app, check `/var/log/audit/audit.log` for “denied” entries.
Keep it **Enforcing** in production — it’s a powerful layer of defense against privilege escalation and misconfigurations.

----
## Q: How to Limit CPU and Memory Usage of a Process in Linux?

---

### 🧠 Overview

In Linux, you can **throttle or limit** how much **CPU** or **memory** a process can use to prevent system overload or ensure fair resource sharing.
This is critical in **multi-user**, **CI/CD**, or **containerized environments** where one misbehaving process can impact others.

Linux offers multiple tools for resource control — **`ulimit`**, **`cgroups`**, and utilities like **`cpulimit`** or **`systemd` service limits**.

---

### ⚙️ Purpose / How It Works

* **CPU limiting** → restricts how much CPU time a process can consume.
* **Memory limiting** → caps RAM usage; exceeding the limit can trigger OOM (Out-Of-Memory kill).
* Linux kernel **cgroups (control groups)** provide fine-grained, persistent resource control.

---

### 🧩 Commands / Examples

#### 🟢 1. Limit CPU Usage for a Process (`cpulimit`)

Install first (if not available):

```bash
sudo apt install cpulimit -y   # Ubuntu/Debian
sudo yum install cpulimit -y   # RHEL/CentOS
```

Run a process with CPU limit:

```bash
cpulimit -l 50 -- stress --cpu 1
```

> Limits process to **50% of one CPU core**.

To limit an existing process:

```bash
sudo cpulimit -p <PID> -l 30
```

> Example: restricts process `<PID>` to **30% CPU**.

---

#### 🟢 2. Limit Memory or CPU for a Command (`ulimit`)

Temporary per-session limits:

```bash
ulimit -v 524288   # Max virtual memory (KB) = 512MB
ulimit -t 60       # Max CPU time (seconds)
```

Run your process afterward:

```bash
./run-heavy-job.sh
```

> If it exceeds limits → process is **killed automatically**.

Check current limits:

```bash
ulimit -a
```

**Output Example:**

```
core file size          (blocks, -c) unlimited
cpu time               (seconds, -t) 60
max memory size        (kbytes, -m) 524288
open files             (-n) 1024
```

---

#### 🟢 3. Persistent Limits per User (`/etc/security/limits.conf`)

Edit:

```bash
sudo vi /etc/security/limits.conf
```

Add entries:

```
devopsuser  hard  cpu   120
devopsuser  hard  as    524288
```

> Limits user `devopsuser` to **120 seconds of CPU** and **512MB address space**.

Reload session to apply.

---

#### 🟢 4. Using `cgroups` (Modern, Persistent Method)

Create control group:

```bash
sudo cgcreate -g cpu,memory:/limited
```

Set limits:

```bash
sudo cgset -r cpu.shares=512 limited          # Half of available CPU
sudo cgset -r memory.limit_in_bytes=512M limited
```

Run a command under that cgroup:

```bash
sudo cgexec -g cpu,memory:limited /usr/bin/python3 app.py
```

Check cgroup stats:

```bash
sudo cat /sys/fs/cgroup/cpu/limited/cpuacct.usage
sudo cat /sys/fs/cgroup/memory/limited/memory.usage_in_bytes
```

> ✅ Best for **persistent**, **fine-grained**, and **system-level** control.

---

#### 🟢 5. Limit via `systemd` (For Services)

For systemd-managed apps (like Nginx, Jenkins, etc.):

Edit unit file:

```bash
sudo systemctl edit nginx.service
```

Add resource directives:

```
[Service]
CPUQuota=50%
MemoryMax=512M
```

Reload systemd and restart:

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart nginx
```

Check:

```bash
systemctl status nginx
```

> ⏱️ Applies **hard limits automatically** on every service start.

---

#### 🟢 6. Using Docker / Kubernetes (Container Environments)

**Docker Example:**

```bash
docker run -d --name web --cpus="1.0" --memory="512m" nginx
```

> Limits container to **1 CPU core** and **512 MB memory**.

**Kubernetes Pod YAML Example:**

```yaml
resources:
  requests:
    cpu: "500m"
    memory: "256Mi"
  limits:
    cpu: "1"
    memory: "512Mi"
```

> Enforces hard resource caps per container — preferred for production workloads.

---

### 📋 Comparison of Methods

| Method                      | Scope           | Persistence  | CPU Limit | Memory Limit | Typical Use            |
| --------------------------- | --------------- | ------------ | --------- | ------------ | ---------------------- |
| `ulimit`                    | User/session    | Temporary    | ✅         | ✅            | Shell scripts, testing |
| `/etc/security/limits.conf` | User            | Persistent   | ✅         | ✅            | Per-user policy        |
| `cpulimit`                  | Process         | Runtime only | ✅         | ❌            | Single command control |
| `cgroups`                   | System-level    | Persistent   | ✅         | ✅            | Fine-grained control   |
| `systemd`                   | Service-level   | Persistent   | ✅         | ✅            | Daemonized apps        |
| `docker/k8s`                | Container-level | Persistent   | ✅         | ✅            | Cloud-native workloads |

---

### ✅ Best Practices

* ⚙️ Use **systemd or cgroups** for persistent and reliable control.
* 🧠 Apply limits to **specific services** (e.g., Jenkins, Nginx, Python apps).
* 🚫 Avoid using `kill -9` on limited processes; let the kernel enforce limits.
* 📊 Monitor resource usage with `top`, `htop`, or `systemd-cgtop`.
* 🧩 In CI/CD or containerized setups, always define **CPU/memory limits** per workload.

---

### 💡 In short

Use:

* `cpulimit -p <PID> -l 50` → limit CPU to 50%.
* `ulimit -v 524288` → cap memory to 512MB.
* `systemd` or `cgroups` → for **persistent**, **production-grade** enforcement.

These tools keep rogue processes from overloading your Linux system — ensuring stability, fairness, and predictable performance.

---
## Q: How Do You Troubleshoot High Load Average in Linux?

---

### 🧠 Overview

A **high load average** means the system has **too many processes waiting for CPU or I/O** — it’s a symptom, not a cause.
Load average reflects **CPU utilization + I/O wait + runnable tasks**, averaged over 1, 5, and 15 minutes.
Troubleshooting involves identifying **what’s overloading** (CPU, memory, disk, or I/O) and **why** (process, service, or misconfiguration).

---

### ⚙️ Purpose / How It Works

* Displayed via `uptime`, `top`, or `w`:

  ```
  load average: 6.24, 4.12, 2.91
  ```

  → Meaning: 6.24 (1 min), 4.12 (5 min), 2.91 (15 min)
* Ideally, **load ≈ number of CPU cores** (e.g., 4-core system → load ≤ 4).
* Causes:

  * 🧠 CPU-bound tasks (e.g., compression, build jobs)
  * 💾 Disk I/O bottlenecks
  * 🔄 Memory pressure & swapping
  * 🌐 Network saturation
  * 🧩 Zombie/stuck processes

---

### 🧩 Step-by-Step Troubleshooting

#### 🟢 1. Check Load & Uptime

```bash
uptime
```

**Example Output:**

```
12:42:08 up 5 days,  3:22,  3 users,  load average: 9.24, 5.32, 3.11
```

> Load is **very high** for a 4-core system — next step: find which resource is saturated.

---

#### 🟢 2. Identify CPU Usage

```bash
top -o %CPU
```

or

```bash
ps -eo pid,ppid,comm,%cpu --sort=-%cpu | head
```

**Look for:**

* Processes constantly at **>90% CPU**
* Background jobs (`gcc`, `java`, `python`, etc.)

If multiple cores are maxed:

```bash
mpstat -P ALL 2
```

> Shows per-core CPU utilization — helps spot imbalanced load.

---

#### 🟢 3. Check I/O Wait (Disk Bottlenecks)

In `top`, look at **`%wa`** (I/O wait):

```
%Cpu(s): 10.0 us, 2.5 sy, 85.0 id, 2.0 wa
```

If `wa > 5%`, disk I/O is slow.

Detailed view:

```bash
iostat -xz 2
```

**Focus on:**

| Metric  | Meaning               | Threshold             |
| ------- | --------------------- | --------------------- |
| `%util` | Disk busy percentage  | > 80% = bottleneck    |
| `await` | Average I/O wait time | > 20ms = slow storage |

> Common cause: overloaded EBS, NFS latency, or log write bursts.

---

#### 🟢 4. Check Memory and Swap

```bash
free -h
```

**Output Example:**

```
              total   used   free  shared  buff/cache  available
Mem:           4.0G   3.6G   0.2G   0.1G        0.3G       0.2G
Swap:          2.0G   1.8G   0.2G
```

> If swap is heavily used → memory exhaustion.

Identify top memory consumers:

```bash
ps -eo pid,comm,%mem,%cpu --sort=-%mem | head
```

If swap usage is high → add RAM or limit memory per process (`ulimit`, `systemd`).

---

#### 🟢 5. Check Stuck or Uninterruptible Tasks

```bash
ps -eo pid,stat,cmd | grep 'D'
```

> State `D` = uninterruptible sleep (usually I/O wait).
> Processes in `D` state for long → disk or NFS problems.

---

#### 🟢 6. Check System Load by Process Count

```bash
vmstat 2 5
```

Focus on:

* `r` (runnable): > number of CPUs → CPU overload
* `b` (blocked): > 0 → I/O bottlenecks

Example:

```
r  b  swpd  free  buff  cache  si  so  bi  bo  in  cs  us  sy  id  wa  st
8  2   100   500  200   800    0   0  40  50  100 200 90  5   3   2   0
```

> 8 runnable tasks on 4 CPUs → overloaded.

---

#### 🟢 7. Check Disk Usage and Inodes

```bash
df -h
```

If a partition is full:

```
/dev/xvda1  20G  20G  0G  100%  /
```

> Disk full → processes stuck writing logs.

Also check inode usage:

```bash
df -i
```

> High inode use (100%) can block file creation.

---

#### 🟢 8. Check Network Load (Optional)

```bash
sar -n DEV 2 5
```

or

```bash
iftop
```

> Look for high bandwidth processes causing network I/O wait.

---

#### 🟢 9. Identify Kernel or Hardware Issues

```bash
dmesg | tail -20
```

**Examples:**

```
blk_update_request: I/O error, dev xvda, sector 2048
Out of memory: Kill process 2345 (java)
```

> Hardware I/O errors or OOM events can spike load.

---

#### 🟢 10. Correlate with Logs

* System logs:

  ```bash
  sudo tail -n 50 -f /var/log/messages
  ```
* Application logs:

  ```bash
  tail -f /var/log/nginx/error.log
  ```

> Check for crashes, timeouts, or resource errors around spike time.

---

### 📋 Load Average Cheat Sheet

| Resource  | Command                     | Key Metric       | Action                        |
| --------- | --------------------------- | ---------------- | ----------------------------- |
| CPU       | `top`, `mpstat`             | `%CPU`, `%sys`   | Kill/optimize CPU-heavy tasks |
| Disk      | `iostat`, `iotop`           | `%util`, `await` | Check disk I/O latency        |
| Memory    | `free -h`, `ps`             | `Swap`, `%mem`   | Add RAM or limit usage        |
| I/O Wait  | `vmstat`, `top`             | `wa`             | Check for slow I/O            |
| Processes | `ps -eo state`              | `D`, `Z`, `R`    | Kill hung/zombie procs        |
| Logs      | `tail -f /var/log/messages` | Errors, OOMs     | Root cause trace              |

---

### ✅ Best Practices

* ⚙️ Always correlate load with **CPU count** (`nproc`).
* 🧠 Investigate **I/O wait** and **swap**, not just CPU.
* 🚀 Use `htop` or `atop` for interactive diagnosis.
* 🧩 Limit CPU/memory hogs using **`cpulimit`**, **`ulimit`**, or **cgroups**.
* 🔒 Automate monitoring via **CloudWatch**, **Prometheus**, or **Netdata** to detect spikes early.

---

### 💡 In short

1. Run `uptime` → confirm load.
2. Check `top` → identify high `%CPU`, `%wa`, or `%mem`.
3. Use `iostat`, `vmstat`, and `ps` → isolate CPU vs I/O bottleneck.
4. Inspect logs and kernel messages for root cause.

A **high load average ≠ high CPU** — it often means blocked I/O or memory contention. Always diagnose by **correlating all system metrics** before taking action.

----
# 🧰 Common Linux Commands for DevOps Engineers

A practical, ready-to-use Linux command reference for **system administration, troubleshooting, automation, and DevOps tasks**.

---

## 🖥️ **System Information**

| Task                    | Command          | Description                                    |
| ----------------------- | ---------------- | ---------------------------------------------- |
| Kernel & system details | `uname -a`       | Shows kernel version, architecture, OS type    |
| Linux distribution info | `lsb_release -a` | Displays distro version (Ubuntu, CentOS, etc.) |
| Hostname details        | `hostnamectl`    | Prints hostname, OS, and kernel details        |
| CPU information         | `lscpu`          | CPU model, cores, threads, and architecture    |
| Memory info             | `free -h`        | Shows total, used, and free RAM                |
| System uptime           | `uptime`         | Shows system uptime and load averages          |

---

## ⚙️ **Process Management**

| Task                       | Command                | Description                             |
| -------------------------- | ---------------------- | --------------------------------------- |
| List all processes         | `ps aux`               | Displays all running processes          |
| View dynamic process usage | `top` or `htop`        | Real-time CPU/memory usage              |
| Search for process         | `pgrep nginx`          | Finds process IDs by name               |
| Kill a process             | `kill -9 <PID>`        | Force-terminates a process              |
| Check process tree         | `pstree -p`            | Displays hierarchical process structure |
| Track system load          | `uptime` or `vmstat 2` | Shows CPU load averages                 |

---

## 💾 **Disk & File Management**

| Task                | Command                           | Description                            |
| ------------------- | --------------------------------- | -------------------------------------- |
| Check disk usage    | `df -h`                           | Human-readable filesystem usage        |
| Find directory size | `du -sh *`                        | Shows size of each item in current dir |
| List block devices  | `lsblk`                           | Displays mounted disks/partitions      |
| Mount filesystem    | `sudo mount /dev/xvdb1 /mnt/data` | Mounts a device to a directory         |
| Unmount filesystem  | `sudo umount /mnt/data`           | Safely detaches a device               |
| Check inode usage   | `df -i`                           | Shows inode usage per filesystem       |

---

## 🌐 **Networking**

| Task                     | Command                                   | Description                      |
| ------------------------ | ----------------------------------------- | -------------------------------- |
| Show interfaces          | `ifconfig` or `ip addr`                   | Lists all network interfaces     |
| Check active connections | `netstat -an` or `ss -ltnp`               | Shows listening sockets and PIDs |
| Test connectivity        | `curl -I https://example.com`             | Checks HTTP/HTTPS access         |
| DNS lookup               | `dig google.com` or `nslookup google.com` | Tests DNS resolution             |
| Trace route              | `tracepath example.com`                   | Checks route to destination      |
| View routing table       | `ip route`                                | Displays routing information     |

---

## 📜 **Logs & Monitoring**

| Task                    | Command                         | Description                          |
| ----------------------- | ------------------------------- | ------------------------------------ |
| View latest log lines   | `tail -n 100 /var/log/syslog`   | Shows last 100 lines                 |
| Follow log in real time | `tail -f /var/log/messages`     | Live stream system logs              |
| View service logs       | `journalctl -u nginx`           | Shows logs for a systemd unit        |
| Filter log entries      | `grep -i error /var/log/syslog` | Finds error lines (case-insensitive) |
| Check login attempts    | `sudo less /var/log/secure`     | View SSH/sudo login logs             |

---

## 🔍 **Search & File Operations**

| Task                | Command                                                     | Description                    |
| ------------------- | ----------------------------------------------------------- | ------------------------------ |
| Search text in file | `grep -i "error" app.log`                                   | Case-insensitive search        |
| Recursive search    | `grep -R "keyword" /etc/`                                   | Searches in all subdirectories |
| Find file by name   | `find / -type f -name "*.conf"`                             | Finds config files             |
| Count lines         | `wc -l filename`                                            | Counts lines in file           |
| Compare files       | `diff file1 file2`                                          | Shows line differences         |
| Compress/uncompress | `tar -czvf backup.tar.gz /data` / `tar -xzvf backup.tar.gz` | Create/extract archives        |

---

## 👥 **Users & Groups**

| Task               | Command                   | Description              |
| ------------------ | ------------------------- | ------------------------ |
| Add user           | `sudo useradd devopsuser` | Creates new user         |
| Set password       | `sudo passwd devopsuser`  | Sets user password       |
| View user info     | `id devopsuser`           | UID, GID, groups         |
| List user groups   | `groups devopsuser`       | Shows group memberships  |
| Switch user        | `su - devopsuser`         | Switch to another user   |
| Check current user | `whoami`                  | Shows logged-in username |

---

## 📦 **Package Management**

| Distro        | Commands                            | Description                    |
| ------------- | ----------------------------------- | ------------------------------ |
| Ubuntu/Debian | `apt update && apt install nginx`   | Manage packages                |
| RHEL/CentOS   | `yum install httpd` or `dnf update` | Install/update/remove packages |
| openSUSE      | `zypper install git`                | Package operations             |
| Amazon Linux  | `sudo yum install docker -y`        | Common cloud environment usage |

---

## 🤖 **Automation & Scheduling**

| Task                | Command                            | Description                 |
| ------------------- | ---------------------------------- | --------------------------- |
| Create cron job     | `crontab -e`                       | Opens user’s cron file      |
| List cron jobs      | `crontab -l`                       | Shows scheduled jobs        |
| Run job once        | `at now + 5 minutes`               | One-time job execution      |
| List systemd timers | `systemctl list-timers`            | View automated system tasks |
| Schedule script     | `0 2 * * * /opt/scripts/backup.sh` | Runs backup daily at 2AM    |
| View scheduled jobs | `cat /etc/crontab`                 | System-wide cron schedule   |

---

## ✅ **Bonus: DevOps Quick Checks**

| Use Case              | Command                      | Purpose                       |
| --------------------- | ---------------------------- | ----------------------------- |
| Check open ports      | `sudo ss -tuln`              | See listening ports/services  |
| Check service status  | `systemctl status docker`    | Verify systemd service health |
| Check CPU/memory load | `top`, `htop`, or `vmstat 2` | Performance monitoring        |
| Check disk I/O        | `iostat -xz 2`               | Detect I/O bottlenecks        |
| Monitor processes     | `pidstat -p <PID> 1`         | Track CPU/memory per process  |
| Check SELinux         | `getenforce` or `sestatus`   | Verify SELinux mode           |

---

### 💡 In short

For DevOps work:

* **System:** `uname -a`, `df -h`, `lsblk`
* **Network:** `ss -ltnp`, `curl -I`, `dig`
* **Logs:** `journalctl -u <service>`, `grep error /var/log/*`
* **Automation:** `crontab -l`, `systemctl list-timers`
* **Processes:** `ps aux | grep <service>`

These are the **core Linux commands** every DevOps engineer should master — for quick diagnosis, automation, and system stability.

---
## Q: How Do You Troubleshoot High CPU Usage on a Linux Server?  

---

### 🧠 Overview  
High CPU usage means one or more processes are consuming **excessive CPU time**, slowing down the system or affecting other services.  
It can result from **runaway processes, application loops, I/O wait misinterpretation, or insufficient CPU capacity**.  

The goal is to **identify the culprit**, **analyze its behavior**, and **take corrective action** without bringing the server down.

---

### ⚙️ Purpose / How It Works  
- The kernel scheduler distributes CPU time among processes.  
- High CPU load can occur due to:  
  - 🧮 CPU-bound processes (computation-heavy jobs)  
  - 🧠 Memory pressure → swapping  
  - 💾 Disk or I/O wait misread as CPU load  
  - 🧩 Zombie or hung threads  
- Load average and CPU usage are related but **not identical** — one shows system demand, the other shows actual usage.

---

### 🧩 Step-by-Step Troubleshooting  

#### 🟢 1. Check Load and CPU Summary  
```bash
uptime
```
**Example Output:**
```
12:43:01 up 2 days, 4:22, 2 users, load average: 9.24, 7.18, 4.12
```
> Compare load average with number of CPU cores:
```bash
nproc
```
If `load > cores`, CPU is overloaded.

---

#### 🟢 2. Identify Top CPU Consumers  
```bash
top -o %CPU
```
or  
```bash
ps -eo pid,ppid,comm,%cpu,%mem --sort=-%cpu | head
```
**Example Output:**
```
PID   PPID  COMMAND      %CPU  %MEM
2431  1     java         185.2  32.5
1256  1     nginx        60.1   5.2
```
> The top process (`java`) is consuming excessive CPU.

---

#### 🟢 3. Check Per-Core CPU Usage  
```bash
mpstat -P ALL 2
```
**Output:**
```
CPU    %usr %sys %iowait %idle
all    85.0 10.0  1.0    4.0
0      92.0  6.0  1.0    1.0
```
> If all cores are >80% busy → system-wide issue.  
> If one core is maxed → single-threaded bottleneck.

---

#### 🟢 4. View Process Thread Usage  
```bash
top -H -p <PID>
```
> Shows per-thread CPU — helpful for multi-threaded apps (Java, Python, Nginx).

Identify hot thread and map to function:
```bash
printf "%x\n" <TID>     # convert thread ID to hex
jstack <PID> | grep <hex_tid> -A 10
```
> For Java apps — see which method is looping.

---

#### 🟢 5. Check I/O Wait (Misleading “High CPU”)  
```bash
iostat -xz 2
```
**Example:**
```
%util: 95%, await: 30ms
```
> CPU looks high because processes are **waiting on disk**.  
If `%wa` (I/O wait) in `top` > 10%, it’s a **storage issue**, not CPU.

---

#### 🟢 6. Check System Stats Over Time  
```bash
sar -u 1 5
```
**Output:**
```
%user %system %iowait %steal %idle
80.2  10.3   0.5     0.0     9.0
```
> Identifies whether CPU pressure is from user processes or kernel/system calls.

---

#### 🟢 7. Investigate Specific Process Behavior  
```bash
strace -p <PID>
```
> Traces system calls to see if it’s stuck in a loop, waiting on I/O, or thrashing memory.  

Example:
```
read(3, "", 4096) = 0
read(3, "", 4096) = 0
```
> Looping reads = bug in application code.

---

#### 🟢 8. Check Kernel Logs for CPU or Hardware Errors  
```bash
dmesg | grep -i cpu
```
**Example:**
```
CPU1: Core temperature above threshold, throttling
```
> CPU throttling or hardware failure can also cause load spikes.

---

#### 🟢 9. Look for Runaway or Zombie Processes  
```bash
ps -eo pid,ppid,stat,cmd | grep 'Z'
```
> Zombies consume process table slots, not CPU, but can cause confusion in load readings.

---

#### 🟢 10. Kill or Throttle the Offending Process  
Gracefully:
```bash
sudo kill <PID>
```
Forcefully:
```bash
sudo kill -9 <PID>
```
Limit CPU instead of killing:
```bash
sudo cpulimit -p <PID> -l 50
```
> Restricts process to 50% CPU.

---

#### 🟢 11. Verify After Fix  
```bash
top
```
Ensure CPU usage stabilizes:
```
%Cpu(s): 20.5 us, 3.0 sy, 1.0 ni, 75.5 id, 0.0 wa
```

---

### 📋 Key Tools Summary  

| Purpose | Command | Notes |
|----------|----------|-------|
| Load average | `uptime`, `top` | Overall CPU demand |
| Top processes | `ps`, `top -o %CPU` | Identify CPU hogs |
| Per-core stats | `mpstat -P ALL` | Check imbalance |
| I/O waits | `iostat -xz` | Rule out disk bottleneck |
| Historical CPU | `sar -u` | CPU trend over time |
| Trace process | `strace -p PID` | Debug stuck loops |
| Throttle CPU | `cpulimit` | Temporary mitigation |

---

### ✅ Best Practices  
- 🧠 Compare load average vs CPU count — avoid false alarms.  
- 🧩 Identify *which process* and *why* (loop, I/O, memory, etc.).  
- ⚙️ Tune applications (thread pools, GC tuning, Nginx workers).  
- 🚀 Use **systemd limits** (`CPUQuota=50%`) for noisy daemons.  
- 🔒 Monitor continuously with **CloudWatch**, **Prometheus**, or **Netdata**.  

---

### 💡 In short  
1. Run `top` → find high `%CPU` process.  
2. Use `ps` or `pidstat` → confirm offender.  
3. Check `mpstat` / `iostat` → verify CPU vs I/O issue.  
4. `strace` or `jstack` → debug application loop.  
5. Throttle (`cpulimit`) or restart if needed.  

High CPU = **symptom**, not root cause — always correlate with **I/O, memory, and process behavior** before acting.

---
## Q: How Do You Troubleshoot and Fix “Disk Full on Root ( / )” in Linux?

---

### 🧠 Overview

When the root filesystem (`/`) becomes full, critical services like **SSH, logging, cron, or systemd** may fail.
This usually happens due to **log bloat, core dumps, temp files, Docker images, or old kernels**.

The goal: **quickly identify large files/directories, clean them safely, and prevent recurrence**.

---

### ⚙️ Purpose / How It Works

The root (`/`) partition contains system directories: `/var`, `/etc`, `/usr`, `/tmp`, `/home`, etc.
A full root filesystem can cause:

* Failed package installs/updates
* Unreachable system (cannot write PID/logs)
* Crashed services (e.g., `systemd-journald`, `nginx`)

---

### 🧩 Step-by-Step Troubleshooting

#### 🟢 1. Check Overall Disk Usage

```bash
df -h
```

**Example Output:**

```
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1       20G   20G     0 100% /
/dev/xvdb        50G   10G    40G  20% /data
```

> `Use% = 100%` confirms `/` is full.

---

#### 🟢 2. Identify Which Directories Are Consuming Space

Start from `/` and go down:

```bash
sudo du -xh --max-depth=1 / | sort -h
```

**Output:**

```
1.2G /etc
3.5G /usr
8.9G /var
5.1G /home
```

Then drill deeper:

```bash
sudo du -xh --max-depth=1 /var | sort -h
```

> Often `/var/log`, `/var/lib/docker`, or `/tmp` are the culprits.

---

#### 🟢 3. Find the Largest Files

```bash
sudo find / -xdev -type f -size +500M -exec ls -lh {} \; | sort -k5 -rh | head -10
```

**Example Output:**

```
-rw------- 1 root root 8.2G /var/log/messages
-rw------- 1 root root 4.0G /var/log/journal/abcd123/system.journal
```

> Quickly pinpoints large log or dump files.

---

#### 🟢 4. Clean Log Files Safely

##### Option 1: Truncate Instead of Delete

```bash
sudo truncate -s 0 /var/log/messages
sudo truncate -s 0 /var/log/syslog
```

##### Option 2: Clear Journald Logs

```bash
sudo journalctl --vacuum-size=500M
```

> Keeps only 500 MB of systemd logs.

##### Option 3: Rotate Logs Manually

```bash
sudo logrotate -f /etc/logrotate.conf
```

---

#### 🟢 5. Remove Old Kernels (RHEL/Debian)

Check installed kernels:

```bash
rpm -q kernel | wc -l    # RHEL/CentOS
dpkg --list | grep linux-image  # Ubuntu/Debian
```

Remove old ones (keep at least 2):

```bash
sudo dnf remove kernel-oldversion
sudo apt autoremove --purge
```

---

#### 🟢 6. Clean Temporary Files

```bash
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*
```

> ⚠️ Ensure no running processes use these dirs before cleaning.

---

#### 🟢 7. Check for Large Deleted Files Still Open

Sometimes logs deleted while in use still consume space.

Check open deleted files:

```bash
sudo lsof | grep deleted
```

**Output Example:**

```
rsyslogd  890 root  txt REG 8,1 2.1G /var/log/messages (deleted)
```

> Restart the process holding the deleted file:

```bash
sudo systemctl restart rsyslog
```

→ Frees up space instantly.

---

#### 🟢 8. Check Docker Images, Containers, and Volumes

```bash
docker system df
docker system prune -af
docker volume prune -f
```

> Docker often fills `/var/lib/docker`.

---

#### 🟢 9. Check Package Cache

**APT:**

```bash
sudo apt clean
sudo apt autoremove
```

**YUM/DNF:**

```bash
sudo yum clean all
sudo dnf clean all
```

---

#### 🟢 10. Identify Orphaned Files on Deleted Mounts

If a partition (like `/var`) failed to mount, data may have filled `/var` on root instead.

Check mounts:

```bash
mount | grep /var
```

> If missing, remount it correctly:

```bash
sudo mount /dev/xvdb1 /var
```

---

### 📋 Common Directories to Check

| Directory          | Typical Cause             | Safe Cleanup                   |
| ------------------ | ------------------------- | ------------------------------ |
| `/var/log/`        | Log bloat                 | Truncate or vacuum             |
| `/var/lib/docker/` | Container images          | `docker system prune -af`      |
| `/tmp/`            | Temp files                | `rm -rf /tmp/*`                |
| `/var/cache/`      | Package/cache files       | `apt clean` or `yum clean all` |
| `/home/`           | User backups or downloads | Compress or move to /data      |
| `/var/crash/`      | Core dumps                | Delete with `rm -f`            |

---

### ✅ Prevention Measures

* 🧠 Set up **log rotation** (`/etc/logrotate.conf`):

  ```bash
  /var/log/*.log {
      weekly
      rotate 4
      compress
      missingok
      notifempty
  }
  ```

* ⚙️ Limit journal size permanently:

  ```bash
  sudo vi /etc/systemd/journald.conf
  SystemMaxUse=500M
  ```

* 🧩 Move heavy data to separate partitions:

  ```
  /dev/xvdb1  → /var
  /dev/xvdc1  → /home
  ```

* 📊 Set up monitoring (CloudWatch, Prometheus, Netdata) for **disk alerts**:

  * Trigger alerts at **80% usage threshold**.

---

### 💡 In short

1. Check usage → `df -h`
2. Find large dirs/files → `du -xh --max-depth=1 /`
3. Clear logs, caches, and temp files safely
4. Restart services holding deleted files (`lsof | grep deleted`)
5. Prune Docker data and old kernels
6. Configure log rotation and disk monitoring

✅ **Goal:** Bring root usage <80%, prevent recurrence with automation (logrotate + monitoring).

---
## Q: How Do You Troubleshoot and Fix Slow SSH Login in Linux?

---

### 🧠 Overview

Slow SSH logins (delay before password prompt or key acceptance) are **very common** in cloud and on-prem environments.
The delay usually happens **before authentication**, caused by **DNS lookups, GSSAPI/Kerberos, PAM checks, or entropy shortage**.
Fixing it involves disabling unnecessary lookups and optimizing SSH daemon settings.

---

### ⚙️ Purpose / How It Works

When an SSH client connects:

1. Server performs **reverse DNS lookup** on the client IP.
2. Tries **GSSAPI (Kerberos)** authentication if enabled.
3. Runs **PAM modules**, **banner scripts**, or **login checks**.
4. Only then shows a password or key prompt.

Each of these can introduce seconds of delay if misconfigured.

---

### 🧩 Step-by-Step Troubleshooting

#### 🟢 1. Measure Login Delay

Check total connection time:

```bash
ssh -vvv user@server
```

**Look for:**

* `Connecting to ...` → delay = network or DNS issue
* `Authentications that can continue:` → delay = PAM/GSSAPI
* `debug1: Offering public key:` → delay = key auth or permissions

Example:

```
debug1: Connecting to 10.0.0.10 [10.0.0.10] port 22.
debug1: Next authentication method: gssapi-with-mic
```

> Long gap before “Authentications that can continue” → DNS or GSSAPI issue.

---

#### 🟢 2. Disable Reverse DNS Lookup on Server

Edit SSH daemon config:

```bash
sudo vi /etc/ssh/sshd_config
```

Add or modify:

```
UseDNS no
```

Restart SSH:

```bash
sudo systemctl restart sshd
```

> This is **the most common fix** (saves 3–5 seconds per login).

---

#### 🟢 3. Disable GSSAPI (Kerberos) Authentication

In `/etc/ssh/sshd_config`:

```
GSSAPIAuthentication no
```

Restart service:

```bash
sudo systemctl restart sshd
```

> Prevents unnecessary Kerberos lookups in enterprise environments.

---

#### 🟢 4. Check for Reverse DNS Configuration

If `UseDNS` must remain enabled (security policies), ensure reverse DNS exists:

```bash
dig -x <client-ip>
```

If no result, add a PTR record or entry in `/etc/hosts`:

```bash
echo "10.0.0.25 devops-client" | sudo tee -a /etc/hosts
```

> Missing PTR records often cause SSH to hang before login.

---

#### 🟢 5. Check Authentication Order

In `/etc/ssh/sshd_config`, adjust the order:

```
AuthenticationMethods publickey,password
PubkeyAuthentication yes
PasswordAuthentication yes
```

> Ensures SSH tries key-based authentication first (faster, more secure).

---

#### 🟢 6. Disable PAM if Not Needed

```bash
UsePAM no
```

> PAM runs multiple modules (like `mkhomedir`, `faillock`) that can slow logins.
> Only disable if you don’t use PAM-based authentication.

---

#### 🟢 7. Check Server Entropy (Slow Key Generation)

Low entropy affects SSHD crypto operations:

```bash
cat /proc/sys/kernel/random/entropy_avail
```

If < 1000 → add entropy generator:

```bash
sudo apt install haveged -y
sudo systemctl enable --now haveged
```

> Helps on VMs where random data generation is slow.

---

#### 🟢 8. Check Login Scripts or Network Filesystems

Inspect:

```bash
cat ~/.bashrc
cat ~/.bash_profile
```

> Long-running scripts, NFS mounts, or remote commands here can delay login.

If `/home` is NFS-mounted, test:

```bash
time ls /home
```

> If slow → NFS latency causes login delay.

---

#### 🟢 9. Monitor SSHD Logs for Hints

```bash
sudo tail -f /var/log/auth.log    # Ubuntu/Debian
sudo tail -f /var/log/secure      # RHEL/CentOS
```

Look for timestamps and gaps:

```
Nov 11 10:40 sshd[1024]: Connection from 10.0.0.25
Nov 11 10:45 sshd[1024]: Accepted publickey for user
```

> The 5-minute gap indicates pre-auth delay (DNS, PAM, or GSSAPI).

---

#### 🟢 10. Test from Another Host or Subnet

```bash
time ssh user@server exit
```

> Confirms if delay is **client-side (SSH config, DNS)** or **server-side (sshd)**.

---

### 📋 Common Root Causes and Fixes

| Root Cause         | Symptom                          | Fix                            |
| ------------------ | -------------------------------- | ------------------------------ |
| Reverse DNS lookup | Delay before password prompt     | `UseDNS no`                    |
| GSSAPI / Kerberos  | 5–10s delay pre-auth             | `GSSAPIAuthentication no`      |
| PAM checks         | Long delay before shell          | `UsePAM no` (optional)         |
| Low entropy        | High CPU, slow SSHD startup      | Install `haveged`              |
| NFS / remote home  | Slow shell after login           | Check `/etc/fstab` and mounts  |
| Hostname mismatch  | Delay + “reverse mapping failed” | Add correct `/etc/hosts` entry |
| Misordered auth    | Public key ignored               | Adjust `AuthenticationMethods` |

---

### ✅ Best Practices

* ⚙️ Always disable **UseDNS** and **GSSAPI** unless required.
* 🧠 Use **SSH keys**, not passwords, for faster login and automation.
* 🚀 Keep `sshd_config` clean — avoid unnecessary modules.
* 📊 Monitor `/var/log/auth.log` for consistent slow entries.
* 🧩 For fleets (AWS, Azure), bake optimal SSHD configs into AMIs or Cloud-init.

---

### 💡 In short

Slow SSH login?

1. `UseDNS no`
2. `GSSAPIAuthentication no`
3. Check reverse DNS (`dig -x <client-ip>`)
4. Verify PAM and NFS mounts

✅ Most login delays are caused by **DNS or GSSAPI lookups** — disabling them cuts login time from 10s → <1s instantly.

---
## Q: How Do You Troubleshoot a Service That Fails to Start in Linux?

---

### 🧠 Overview

When a service fails to start (e.g., `nginx`, `docker`, `jenkins`, etc.), it’s typically due to **misconfiguration, missing dependencies, permission issues, or resource exhaustion**.
Linux services are usually managed via **systemd** (`systemctl`) or **init.d**, and system logs are your best starting point.

---

### ⚙️ Purpose / How It Works

`systemd` manages service lifecycles:

* Starts and stops processes via unit files (`/etc/systemd/system/*.service`).
* Logs detailed errors to **`journalctl`**.
* Tracks dependencies, environment variables, and restart policies.

A failed service usually means **`ExecStart` failed**, the **binary crashed**, or a **dependency service isn’t available**.

---

### 🧩 Step-by-Step Troubleshooting

#### 🟢 1. Check Service Status

```bash
sudo systemctl status <service-name>
```

**Example:**

```bash
sudo systemctl status nginx
```

**Output:**

```
● nginx.service - A high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled)
   Active: failed (Result: exit-code) since Tue 2025-11-11 12:44:03 UTC; 15s ago
  Process: 1214 ExecStart=/usr/sbin/nginx (code=exited, status=1/FAILURE)
  Main PID: 1214 (code=exited, status=1/FAILURE)
```

> Focus on: **exit code**, **timestamp**, and **ExecStart** command.

---

#### 🟢 2. View Detailed Logs

```bash
sudo journalctl -u <service-name> -xe
```

**Example:**

```bash
sudo journalctl -u nginx -xe
```

**Output Example:**

```
nginx[1214]: nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx[1214]: nginx: configuration file /etc/nginx/nginx.conf test failed
```

> Root cause: port conflict or config syntax error.

---

#### 🟢 3. Test the Service Configuration

Many services support built-in config validation:

| Service          | Command                                                             | Purpose                 |
| ---------------- | ------------------------------------------------------------------- | ----------------------- |
| **Nginx**        | `sudo nginx -t`                                                     | Test config syntax      |
| **Apache**       | `sudo apachectl configtest`                                         | Validate HTTPD configs  |
| **sshd**         | `sudo sshd -t`                                                      | Test SSH configuration  |
| **systemd unit** | `sudo systemd-analyze verify /etc/systemd/system/<service>.service` | Verify unit file syntax |

> Run tests before restarting the service.

---

#### 🟢 4. Check for Port Conflicts

```bash
sudo ss -ltnp | grep :<port>
```

**Example:**

```bash
sudo ss -ltnp | grep :80
```

**Output:**

```
LISTEN 0 128 0.0.0.0:80 users:(("httpd",pid=2021,fd=4))
```

> Another service (Apache) may already be using port 80 → stop it or change port in config.

---

#### 🟢 5. Verify Permissions and Ownership

```bash
ls -l /var/run /var/log /etc/<service>/
```

Check that:

* Service user (e.g., `nginx`, `jenkins`, `mysql`) can access its config and data directories.
* Config files are not **owned by root** when the service runs as a non-root user.

Example:

```bash
sudo chown -R nginx:nginx /var/www/html
```

---

#### 🟢 6. Check Resource Limits

```bash
free -h
df -h
ulimit -a
```

> If memory or disk space is full, service startup may fail.
> Look for errors like:

```
Cannot allocate memory
No space left on device
```

---

#### 🟢 7. Identify Dependency Failures

List dependencies:

```bash
sudo systemctl list-dependencies <service-name>
```

Check their status:

```bash
sudo systemctl status <dependency>
```

Example:

```
docker.service requires containerd.service
containerd.service failed → docker fails
```

---

#### 🟢 8. Restart Service and Watch Logs Live

```bash
sudo systemctl restart <service-name>
sudo journalctl -fu <service-name>
```

> Follows live logs as the service starts.

---

#### 🟢 9. Fix SELinux or Firewall Blocks (RHEL/CentOS)

Check SELinux denials:

```bash
sudo ausearch -m avc -ts recent
```

Temporarily disable SELinux (for testing only):

```bash
sudo setenforce 0
```

Check firewall:

```bash
sudo firewall-cmd --list-all
```

> Ensure required ports (e.g., 80, 443, 8080) are open.

---

#### 🟢 10. Check for Missing or Corrupted Binaries

```bash
sudo which <binary>
rpm -V <package>        # RHEL/CentOS
dpkg -V <package>       # Debian/Ubuntu
```

Reinstall if necessary:

```bash
sudo yum reinstall nginx -y
sudo apt reinstall nginx -y
```

---

### 📋 Common Root Causes and Fixes

| Root Cause         | Example Error                                 | Resolution                                    |
| ------------------ | --------------------------------------------- | --------------------------------------------- |
| Port conflict      | `Address already in use`                      | Stop conflicting service or change port       |
| Bad config syntax  | `nginx: [emerg] invalid directive`            | Fix config file (`nginx -t`)                  |
| Missing dependency | `Failed to start because X.service not found` | Install/start dependency                      |
| Permission issue   | `Permission denied`                           | Fix file ownership or permissions             |
| Low disk or memory | `No space left on device`                     | Free space or add swap                        |
| SELinux blocking   | `avc: denied`                                 | Update SELinux context or disable temporarily |
| Corrupt binary     | `Exec format error`                           | Reinstall service package                     |

---

### ✅ Best Practices

* 🧠 Always check logs (`journalctl -u <service> -xe`) first.
* ⚙️ Validate configurations before restarting services.
* 🔒 Keep proper ownership for `/etc/<service>` and `/var/lib/<service>`.
* 🚀 Monitor system resources — low memory or full disk often cause startup failures.
* 🧩 For systemd custom units, always reload config after changes:

  ```bash
  sudo systemctl daemon-reload
  ```

---

### 💡 In short

1. `systemctl status <service>` → check failure reason
2. `journalctl -u <service> -xe` → find exact error
3. Validate configs (`nginx -t`, `sshd -t`, etc.)
4. Fix ports, permissions, or dependencies
5. Restart and verify logs live

✅ **Root cause is almost always visible in journalctl output** — start there, fix the error, reload, and revalidate.

---
## Q: How Do You Troubleshoot an Unreachable Linux Server?

---

### 🧠 Overview

When a server becomes **unreachable**, it could be due to **network, firewall, routing, SSH, or system failure**.
The key is to **narrow down where the communication breaks** — client, network, or server — using systematic network-layer testing (ICMP, TCP, routing, DNS, etc.).

---

### ⚙️ Purpose / How It Works

Connectivity depends on multiple layers:

1. **DNS resolution** (hostname → IP)
2. **Network path** (ping, route)
3. **Firewall/Security Group** (ports open)
4. **Service availability** (e.g., SSHD running)
5. **System state** (CPU, memory, crash, kernel panic)

Troubleshooting should proceed layer by layer — from **local client → network → target host**.

---

### 🧩 Step-by-Step Troubleshooting

#### 🟢 1. Check if Host Resolves via DNS

```bash
nslookup server.example.com
# or
dig server.example.com
```

**Output:**

```
server.example.com.  IN  A  10.0.0.25
```

> ❌ If DNS fails, use IP address directly or fix `/etc/resolv.conf`.

---

#### 🟢 2. Test Network Reachability (Ping or Alternative)

If ICMP is allowed:

```bash
ping -c 4 10.0.0.25
```

**Output:**

```
PING 10.0.0.25 (10.0.0.25): 56 data bytes
Request timeout for icmp_seq 1
```

> If blocked (common in AWS/Azure), use TCP test instead:

```bash
nc -zv 10.0.0.25 22
```

or

```bash
telnet 10.0.0.25 22
```

> ✅ Success = server reachable at TCP level.
> ❌ Failure = network/firewall issue.

---

#### 🟢 3. Check Routing from Client

```bash
ip route get 10.0.0.25
```

**Output:**

```
10.0.0.25 via 10.0.0.1 dev eth0 src 10.0.0.10
```

> If missing route or wrong interface, adjust routing or VPN configuration.

For detailed path:

```bash
tracepath 10.0.0.25
```

or

```bash
traceroute 10.0.0.25
```

> Identify where traffic stops (router, firewall, gateway).

---

#### 🟢 4. Verify Security Group / Firewall Rules

On **client**:

```bash
sudo iptables -L -v -n
sudo ufw status verbose
```

On **server** (via console access or rescue mode):

```bash
sudo firewall-cmd --list-all
```

In **AWS/Azure/GCP**:

* Confirm Security Group allows inbound TCP 22 (SSH).
* Verify NACL or subnet ACL rules.

| Check                | Expected                  |
| -------------------- | ------------------------- |
| Inbound SSH (22/tcp) | ✅ Allowed                 |
| Outbound responses   | ✅ Allowed                 |
| ICMP                 | Optional (for ping tests) |

---

#### 🟢 5. Confirm SSHD is Running on Server

If console or management access is available (e.g., AWS EC2 Session Manager, VMware Console):

```bash
sudo systemctl status sshd
```

**Output:**

```
sshd.service - OpenSSH Daemon
   Active: active (running)
```

> If inactive:

```bash
sudo systemctl restart sshd
```

If missing:

```bash
sudo apt install openssh-server -y
sudo systemctl enable --now sshd
```

---

#### 🟢 6. Check Server’s Network Interfaces

```bash
ip addr
```

**Output Example:**

```
eth0: inet 10.0.0.25/24 brd 10.0.0.255
```

> Ensure interface is **up** and has the correct IP.

If interface is down:

```bash
sudo ip link set eth0 up
sudo systemctl restart network
```

---

#### 🟢 7. Check Default Gateway and Routes on Server

```bash
ip route
```

**Expected Output:**

```
default via 10.0.0.1 dev eth0
```

> Missing route = no outbound connectivity. Add manually:

```bash
sudo ip route add default via 10.0.0.1 dev eth0
```

---

#### 🟢 8. Check for Network Interface Errors

```bash
dmesg | grep eth
```

**Possible Errors:**

```
eth0: link is down
Network unreachable
```

> May indicate NIC failure or misconfigured driver.

---

#### 🟢 9. Check Disk Space and System Health (If Reachable via Console)

```bash
df -h
top
journalctl -p 3 -xb
```

> Full root filesystem (`/` 100%) or OOM can cause SSH and network daemons to hang.

---

#### 🟢 10. Boot into Rescue or Console Mode (If Completely Unreachable)

Use **cloud console access** (AWS EC2 Serial Console / Azure Serial Console / VMware Console):

* Check `/var/log/messages` or `/var/log/syslog` for boot/network issues.
* Fix misconfigured `/etc/network/interfaces` or `/etc/netplan/*.yaml`.
* Restart network:

  ```bash
  sudo systemctl restart NetworkManager
  ```
* Bring NIC up manually:

  ```bash
  sudo ip link set eth0 up
  sudo dhclient eth0
  ```

---

### 📋 Common Causes and Fixes

| Root Cause            | Symptom                           | Fix                                            |
| --------------------- | --------------------------------- | ---------------------------------------------- |
| DNS failure           | `ssh: Could not resolve hostname` | Check `/etc/resolv.conf` or DNS server         |
| Firewall block        | Timeout on SSH                    | Open port 22 via `firewalld` or Security Group |
| SSHD stopped          | “Connection refused”              | Start service: `systemctl restart sshd`        |
| Interface down        | No ping/route                     | `ip link set eth0 up`                          |
| IP conflict           | Intermittent reachability         | Check `arp -n`, fix duplicate IP               |
| Disk full             | No response / hangs               | `df -h` → free up space                        |
| Kernel panic          | Totally unresponsive              | Check via console logs or reboot               |
| Route misconfig       | “Network unreachable”             | Add default route or correct gateway           |
| Cloud SG / NACL block | Works from inside, not outside    | Update inbound/outbound rules                  |

---

### ✅ Best Practices

* ⚙️ Always keep **out-of-band access** (console, SSM, IPMI, etc.) configured.
* 🔒 Limit SSH access to known IPs but confirm it’s **open for your admin source**.
* 🧩 Use monitoring (CloudWatch, Pingdom, Prometheus) to detect downtime early.
* 🧠 For automation, run **connectivity checks** in CI/CD (e.g., `nc -zv host 22`).
* 🚀 Keep network configs (`/etc/netplan`, `/etc/sysconfig/network-scripts`) versioned.

---

### 💡 In short

1. `dig <hostname>` → check DNS
2. `nc -zv <ip> 22` → check port reachability
3. Verify **firewall & Security Group** rules
4. Console in → check **sshd**, **network interfaces**, **default route**, **disk space**
5. Fix and **restart networking** (`systemctl restart network` or `NetworkManager`)

✅ **Most “unreachable” servers** are due to misconfigured firewall, downed NIC, or stopped SSHD — always start from network layer and move upward.

---
## Q: How Do You Troubleshoot Missing Application Logs in Linux?

---

### 🧠 Overview

Missing application logs are a **critical issue** in DevOps and production environments — without logs, you lose visibility into errors, performance, and deployments.
This typically happens due to **misconfigured log paths, permission issues, rotation/truncation, disk full, or application-level logging misconfigurations**.

The goal: **find where logs should be**, verify **logging mechanisms**, and **restore continuous logging** safely.

---

### ⚙️ Purpose / How It Works

Applications log through one of these mechanisms:

* **Direct file logging** → `/var/log/<app>/app.log`
* **System logging (journald/syslog)** → `journalctl -u <service>`
* **Container logs** → `/var/lib/docker/containers/.../json.log`
* **Custom stdout/stderr handlers** in modern apps (e.g., microservices).

When logs disappear, the issue usually lies in the **logging destination** or **permissions/config rotation**.

---

### 🧩 Step-by-Step Troubleshooting

#### 🟢 1. Identify How the Application Logs

Check process details:

```bash
ps -ef | grep <app>
```

> Look for startup parameters like `--log-file`, `--log-dir`, or `-Dlogging.file`.

Example:

```
/usr/bin/java -jar app.jar --logging.file=/var/log/myapp/app.log
```

> Tells you **where logs should exist**.

If it’s a systemd service:

```bash
sudo systemctl cat <app>.service
```

> Inspect `ExecStart` or `Environment` lines for log paths or `StandardOutput` directives.

---

#### 🟢 2. Check if Logs Are Redirected to Journald or Syslog

```bash
sudo journalctl -u <app> -f
```

> If logs appear here, the app is logging to **stdout/stderr** via **systemd journald** instead of files.

If using syslog:

```bash
sudo grep <app> /var/log/syslog
sudo grep <app> /var/log/messages
```

> Application logs might be forwarded there instead of `/var/log/<app>/`.

---

#### 🟢 3. Verify Log Directory and File Permissions

```bash
ls -ld /var/log/<app>
ls -l /var/log/<app>/
```

**Example Output:**

```
drwxr-xr-x 2 root root 4096 Nov 11  /var/log/myapp
-rw-r--r-- 1 root root  0 Nov 11  app.log
```

> If owned by `root`, but app runs as `tomcat`, `nginx`, or `jenkins` → it can’t write.

Fix ownership:

```bash
sudo chown -R <appuser>:<appgroup> /var/log/<app>
```

Fix permissions:

```bash
sudo chmod 755 /var/log/<app>
sudo chmod 644 /var/log/<app>/*.log
```

---

#### 🟢 4. Check for Log Rotation or Deletion

Check logrotate configuration:

```bash
sudo cat /etc/logrotate.d/<app>
```

**Example:**

```
/var/log/myapp/*.log {
    rotate 4
    weekly
    compress
    missingok
    notifempty
}
```

> If `notifempty` or `missingok` present, empty logs might be skipped silently.

Force a rotation test:

```bash
sudo logrotate -f /etc/logrotate.conf
```

Check rotated archives:

```bash
ls -lh /var/log/myapp/*.gz
```

> Logs might have rotated and compressed.

---

#### 🟢 5. Check if Disk Is Full or Read-Only

```bash
df -h /
```

If `Use% = 100%`, no new logs can be written.
Free space, then restart service.

Also check filesystem status:

```bash
mount | grep /var/log
```

If it shows `(ro)`, remount as read-write:

```bash
sudo mount -o remount,rw /
```

---

#### 🟢 6. Confirm Application Log Configuration

For Java apps (Spring Boot, Tomcat, etc.):

```bash
grep "logging" application.properties
```

**Examples:**

```
logging.file.name=/var/log/myapp/app.log
logging.level.root=INFO
```

> Missing or misconfigured `logging.file` entry = logs go to console only.

For Nginx:

```bash
cat /etc/nginx/nginx.conf | grep log
```

**Expected:**

```
access_log /var/log/nginx/access.log;
error_log /var/log/nginx/error.log;
```

> If paths missing → add and restart service.

---

#### 🟢 7. Check SELinux or AppArmor Restrictions

SELinux can silently block write access to `/var/log`.

Test:

```bash
sudo ausearch -m avc -ts recent
```

If denied:

```
type=AVC msg=audit: ... denied { write } for pid=1234 comm="java" name="app.log"
```

Allow correct context:

```bash
sudo restorecon -Rv /var/log/myapp/
```

Or disable temporarily for testing:

```bash
sudo setenforce 0
```

---

#### 🟢 8. Check Containerized Applications (Docker/Kubernetes)

**Docker logs:**

```bash
docker logs <container_name> | tail
```

If missing, check Docker JSON logs:

```bash
sudo ls -lh /var/lib/docker/containers/*/*-json.log
```

> Logs may be rotated or deleted by Docker:

```bash
sudo docker system prune -af
```

**Kubernetes logs:**

```bash
kubectl logs <pod> -n <namespace> --tail=50
```

> If logs lost after pod restart → use persistent logging (FluentBit, CloudWatch, Loki, etc.).

---

#### 🟢 9. Check for Manual Deletion or Truncation

```bash
sudo lsof | grep deleted | grep log
```

**Example Output:**

```
java  2193 root  txt REG 8,1  2.1G /var/log/myapp/app.log (deleted)
```

> The file was deleted while app still writing to it → restart the service:

```bash
sudo systemctl restart <app>
```

---

#### 🟢 10. Verify Centralized Logging Configuration (ELK / CloudWatch / Fluentd)

If logs are sent remotely, check agent health:

```bash
sudo systemctl status filebeat
sudo systemctl status amazon-cloudwatch-agent
```

> Misconfigured or stopped agents can cause local logs to rotate and vanish.

---

### 📋 Common Causes and Fixes

| Root Cause               | Symptom                       | Resolution                                           |
| ------------------------ | ----------------------------- | ---------------------------------------------------- |
| Wrong file path          | Log file not generated        | Fix `logging.file` or `access_log` path              |
| Permission denied        | Empty or missing log files    | `chown -R <appuser> /var/log/<app>`                  |
| Log rotation             | Old logs archived             | Check `/var/log/<app>/*.gz`                          |
| Disk full / read-only FS | No logs being written         | Free space / remount as rw                           |
| SELinux block            | App running but no logs       | `restorecon -Rv /var/log/<app>`                      |
| Logging disabled         | App runs but silent           | Check config for `logging.level` or `access_log off` |
| Deleted log handle       | File missing but process open | Restart app                                          |
| Cloud log redirection    | Logs missing locally          | Check CloudWatch / ELK / Loki agent                  |

---

### ✅ Best Practices

* 🧠 Always define **absolute log paths** in app configs.
* ⚙️ Configure **logrotate** to compress but not delete too aggressively.
* 🧩 Set `/var/log/<app>` ownership to the **same user as the service**.
* 🚀 Use centralized log shipping (ELK, CloudWatch, Loki) for retention.
* 🔒 For containerized workloads, log to **stdout/stderr** — not local files.
* 📊 Monitor `/var/log` disk space and rotation schedules.

---

### 💡 In short

1. Check journald: `journalctl -u <app>`
2. Verify log path & permissions: `ls -l /var/log/<app>`
3. Inspect rotation: `/etc/logrotate.d/<app>`
4. Free disk space or remount FS
5. Restart service after fixing

✅ Most missing log issues come from **permissions, rotation, or deletion** — verify configuration and ownership before restarting.

---
## Q: How Do You Recover or Handle an Accidentally Deleted File in Linux?

---

### 🧠 Overview

Accidentally deleting a file in Linux (`rm -rf`) is common and dangerous — especially in production environments.
Unlike Windows, Linux doesn’t have a “recycle bin”; recovery depends on **file type**, **storage type (ext4, xfs, etc.)**, and whether the **file’s data blocks** have been overwritten.

Your recovery approach changes based on:

* Whether the file is **still open by a process** (recoverable easily).
* Whether it’s on a **local disk**, **EBS volume**, or **mounted filesystem**.
* Whether **backups or snapshots** exist.

---

### ⚙️ Purpose / How It Works

When a file is deleted:

* The **directory entry** is removed, but **data blocks** remain until overwritten.
* If a process still has it open, you can **recover contents from memory or file descriptor**.
* Once overwritten → recovery becomes difficult without forensic tools.

---

### 🧩 Step-by-Step Recovery Workflow

#### 🟢 1. Stop Writing to the Disk Immediately

**Do not** create new files or restart services — it may overwrite the deleted file’s data blocks.
If possible, **mount the filesystem as read-only**:

```bash
sudo mount -o remount,ro /
```

Or stop the application:

```bash
sudo systemctl stop <app>
```

> This preserves the best chance of recovery.

---

#### 🟢 2. Check if File Is Still Open by a Process

```bash
sudo lsof | grep deleted
```

**Example Output:**

```
java   2245  root  txt REG 8,1  2.1G /var/log/myapp/app.log (deleted)
```

> The file is deleted but still open in process `PID=2245`.

Recover it immediately:

```bash
sudo cp /proc/2245/fd/4 /tmp/recovered-app.log
```

> Copies the still-open file handle to a safe location.

💡 **Best case scenario** — 100% recovery possible if the file is still open.

---

#### 🟢 3. Check Backups or Snapshots

If on a cloud system (e.g., AWS, Azure, GCP):

* **AWS EBS snapshot**:

  ```bash
  aws ec2 create-snapshot --volume-id <vol-id> --description "Post-delete recovery"
  ```

  Mount the snapshot to a recovery instance and restore the file.

* **AMI / Cloud Backup / rsync / S3 Sync**:
  Restore from the latest available backup:

  ```bash
  aws s3 cp s3://mybackup/app.log /var/log/myapp/
  ```

If using local backup:

```bash
sudo cp /backup/var/log/myapp/app.log /var/log/myapp/
```

---

#### 🟢 4. Use File Recovery Tools (If No Backup / Not Open)

If the file isn’t open and no backup exists, use recovery utilities.

**Unmount filesystem first** (to avoid overwriting):

```bash
sudo umount /dev/xvda1
```

Then run tools from a live or recovery system:

**For ext4:**

```bash
sudo apt install extundelete -y
sudo extundelete /dev/xvda1 --restore-file /var/log/myapp/app.log
```

> Restores deleted file if its data blocks are intact.

**For xfs:**

```bash
sudo yum install xfsprogs -y
sudo xfs_undelete -i /dev/xvda1 -o /tmp/recovery
```

**For generic file carving:**

```bash
sudo apt install testdisk -y
sudo photorec
```

> Interactively scans and recovers file fragments based on signatures.

---

#### 🟢 5. Check If File Was on a Mounted Partition

If the file was under `/mnt/data` or `/var`, ensure the mount point is still valid:

```bash
mount | grep /mnt
```

> Sometimes files appear “deleted” because the mount point changed or unmounted temporarily.

Remount:

```bash
sudo mount /dev/xvdb1 /mnt/data
```

---

#### 🟢 6. Check Version-Controlled or App-Level Logs

If the file was configuration or code:

```bash
git log -- <file>
git checkout HEAD^ -- <file>
```

> Restore from version control rather than disk recovery.

If it was an application log or DB dump, check:

* **/tmp** or rotated logs:

  ```bash
  ls -lh /var/log/*.gz
  ```
* **Service backups** (e.g., Jenkins `jobs/`, MySQL `mysqldump`).

---

#### 🟢 7. If File System Is Corrupted or Damaged

Run filesystem check:

```bash
sudo fsck /dev/xvda1
```

> Fixes metadata or inode table issues that can make files appear “missing”.

---

#### 🟢 8. Future Prevention

* Enable **versioned backups**:

  * Local: `rsnapshot`, `rsync`, or `restic`
  * Cloud: S3 with `--versioning-enabled`
* Protect critical files:

  ```bash
  chattr +i /etc/fstab   # Immutable flag prevents deletion
  ```
* Enable **logrotate with retention** to prevent manual deletion:

  ```bash
  /var/log/myapp/*.log {
      rotate 7
      compress
      missingok
      notifempty
  }
  ```

---

### 📋 Recovery Scenarios Summary

| Scenario                           | Recovery Method            | Success Chance |
| ---------------------------------- | -------------------------- | -------------- |
| File still open by process         | Copy from `/proc/<pid>/fd` | ✅ 100%         |
| Backups/snapshots exist            | Restore from backup        | ✅ 100%         |
| Recently deleted (ext4, unmounted) | `extundelete` / `testdisk` | ⚙️ 60–90%      |
| Overwritten or old deletion        | Low-level forensic tools   | ⚠️ <30%        |
| Mounted FS issue                   | Remount or check mounts    | ✅ Quick fix    |
| Config/code under Git              | `git checkout`             | ✅ 100%         |

---

### ✅ Best Practices

* 🧠 Always use **backups or snapshots** for critical systems.
* 🧩 Keep `/var/log`, `/etc`, `/data` under separate partitions.
* ⚙️ Use **immutable flags (`chattr +i`)** for key configs.
* 🚀 Add **“safe delete” alias** for interactive confirmation:

  ```bash
  alias rm='rm -i'
  ```
* 🧾 Automate daily offsite backups (S3, rsync, NFS).

---

### 💡 In short

1. Check if file is open → `lsof | grep deleted` → recover via `/proc/<pid>/fd/`.
2. Restore from backup or snapshot if available.
3. If no backup, use `extundelete` or `testdisk` on unmounted disk.
4. Prevent future loss with immutable flags, backups, and “safe delete” policies.

✅ **If a process still holds the file open, recover immediately — otherwise unmount and use recovery tools before writing new data.**

---
# 🧩 Linux System Architecture Overview

A Linux system is built using a **modular, layered architecture** where each component plays a specific role — from hardware control to user interaction.
Here’s a clear, DevOps-friendly breakdown:

---

## 🧠 Core Components and Their Purpose

| **Component**                              | **Purpose / Functionality**                                                                                                                                                                             |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Kernel**                                 | 🧩 The **core of the OS** — directly interacts with hardware (CPU, memory, I/O, storage). Handles **process scheduling, device drivers, memory management, and system calls**.                          |
| **System Libraries (glibc)**               | 🧠 Provide **standard APIs** (like `printf()`, `malloc()`) and **system call interfaces** for applications to interact with the kernel without dealing with hardware directly.                          |
| **System Utilities**                       | ⚙️ Essential **user-space tools** like `ls`, `cat`, `grep`, `ps`, `df` that let users perform basic operations and maintenance. Found under `/bin`, `/usr/bin`.                                         |
| **Shell**                                  | 💻 The **command-line interface (CLI)** between user and OS — interprets commands (e.g., Bash, Zsh, Fish). Also used for scripting and automation in DevOps.                                            |
| **Init System (systemd / init / upstart)** | 🔄 Responsible for **booting the system**, **starting/stopping services**, and **managing daemons and processes**. Systemd units control dependencies and startup order.                                |
| **File System Hierarchy**                  | 🗂️ Defines how data and configurations are organized under `/` (root):<br> `/etc` → configs<br> `/var` → logs/data<br> `/home` → user files<br> `/bin`, `/sbin` → system binaries<br> `/dev` → devices |
| **Networking Stack**                       | 🌐 Manages **network interfaces, routing, DNS, sockets, and firewalling**. Uses tools like `ip`, `ss`, `iptables`, and kernel modules like `netfilter` for packet control.                              |

---

## 🧩 How the Layers Interact

```
+---------------------------+
|    User Applications      | ← (e.g., nginx, git, curl)
+---------------------------+
|   Shell & System Utilities| ← (bash, ls, ps)
+---------------------------+
|   System Libraries (glibc)| ← (standard C library, APIs)
+---------------------------+
|          Kernel           | ← (schedules, manages hardware)
+---------------------------+
|       Hardware Layer      | ← (CPU, RAM, Disk, NIC)
+---------------------------+
```

> Applications interact with the **kernel** via **system libraries**, which translate user-space calls into **system calls** handled by the kernel.

---

## ⚙️ Example: How a Command Executes (`ls /home`)

1. **User Input:** You type `ls /home` in Bash.
2. **Shell:** Parses the command and executes `/bin/ls`.
3. **System Libraries:** `ls` calls C library functions (`opendir()`, `readdir()`) from glibc.
4. **Kernel:** Executes system calls to read directory contents via the **VFS (Virtual File System)**.
5. **Kernel ↔ Hardware:** Reads data blocks from disk via the **I/O scheduler and disk driver**.
6. **Output:** Results are displayed in the terminal via the shell.

---

## 📋 Key Directories by Role

| **Directory**        | **Purpose**                            |
| -------------------- | -------------------------------------- |
| `/bin`, `/usr/bin`   | Core user commands                     |
| `/sbin`, `/usr/sbin` | System administration binaries         |
| `/etc`               | Configuration files                    |
| `/var`               | Variable data (logs, cache, mail)      |
| `/home`              | User directories                       |
| `/dev`               | Device files (block/character devices) |
| `/proc`, `/sys`      | Virtual kernel/system info             |
| `/lib`, `/usr/lib`   | Shared libraries                       |

---

## ✅ Best Practices for DevOps

* ⚙️ Keep **system logs** under `/var/log` monitored (`journalctl`, `rsyslog`).
* 🧠 Use **systemd units** for service reliability and restarts.
* 🧩 Store persistent data and configs in proper locations (`/etc`, `/opt`, `/var/lib`).
* 🔒 Limit direct kernel interaction; use APIs or utilities.
* 🚀 Understand layers — critical for **troubleshooting, performance tuning, and containerization**.

---

### 💡 In short

Linux architecture =
**Hardware → Kernel → Libraries → Utilities → Shell → Applications**.
Each layer abstracts complexity and isolates functionality — making Linux **stable, modular, and ideal for DevOps automation and containers.**
