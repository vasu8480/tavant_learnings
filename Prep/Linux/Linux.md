# Linux 

## Q1: What is Linux and how does it differ from Unix?

🧠 **Overview**
Linux is an open-source operating system kernel that powers various OS distributions (Ubuntu, RHEL, Alpine). It follows Unix principles but is not derived from original AT&T Unix. Used heavily in DevOps, cloud servers, containers, and embedded systems.

⚙️ **Purpose / How it Works**

* Provides process management, memory control, filesystem drivers, networking, and hardware abstraction.
* Forms the foundation for server OSes used in CI/CD, Kubernetes nodes, Docker images, etc.

📋 **Linux vs Unix**

| Feature | Linux                               | Unix                          |
| ------- | ----------------------------------- | ----------------------------- |
| Source  | Open-source                         | Mostly proprietary            |
| Distros | Many (Ubuntu, RHEL, Debian, Alpine) | Limited (AIX, HP-UX, Solaris) |
| Usage   | Cloud, servers, containers          | Legacy enterprise servers     |
| Cost    | Free                                | Paid/commercial               |

💡 **In short**
Linux = open-source Unix-like OS widely used in DevOps; Unix = commercial systems mostly used in legacy enterprises.

---

## Q2: What is the Linux kernel and what is its role?

🧠 **Overview**
The kernel is the **core component** of Linux that interacts directly with hardware. It enables processes, memory, I/O, networking, and device drivers.

⚙️ **Purpose / How it Works**

* Manages CPU scheduling, RAM allocation, system calls.
* Drivers allow software to work with hardware (disks, NICs).
* Container engines (Docker, containerd) rely on kernel features like cgroups & namespaces.

🧩 **Example: Kernel parameters**

```bash
cat /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1
```

💡 **In short**
Kernel = the bridge between hardware and software; controls everything your OS and containers do.

---

## Q3: What are the main differences between Linux distributions (Ubuntu, CentOS, Debian, RHEL)?

🧠 **Overview**
Different distros bundle the Linux kernel + package managers + system tools optimized for specific use cases (cloud, enterprise, security, lightweight servers).

📋 **Comparison Table**

| Distro              | Package Manager | Use Case                | Notes                                     |
| ------------------- | --------------- | ----------------------- | ----------------------------------------- |
| **Ubuntu**          | `apt`           | Cloud, dev environments | Most common in cloud images; fast updates |
| **Debian**          | `apt`           | Stable servers          | Very stable; slower release cycle         |
| **CentOS** (Stream) | `dnf/yum`       | Pre-RHEL testing        | Rolling updates; used less in prod now    |
| **RHEL**            | `dnf/yum`       | Enterprise workloads    | Paid support; stable long-term releases   |

💡 **In short**
Distros differ mainly in package managers, stability, support model, and update frequency.

---

## Q4: What is a shell in Linux?

🧠 **Overview**
A shell is a command-line interpreter that lets users interact with the OS using commands and scripts.

⚙️ **How it Works**

* Takes input from user/scripts
* Executes commands
* Returns output

🧩 **Example**

```bash
echo "Hello"
ls -l /var/log
```

💡 **In short**
Shell = command interface to the OS, essential for scripting and automation.

---

## Q5: What is the difference between bash, sh, zsh, and other shells?

🧠 **Overview**
Different shells offer different features, syntax improvements, scripting capabilities, and interactive enhancements.

📋 **Shell Comparison**

| Shell    | Features                                           | Usage                          |
| -------- | -------------------------------------------------- | ------------------------------ |
| **sh**   | Original Bourne shell                              | Basic scripting                |
| **bash** | Most common; arrays, functions, scripting features | Default in many distros        |
| **zsh**  | Auto-completion, plugins, themes (oh-my-zsh)       | Preferred for interactive use  |
| **fish** | User-friendly, auto-suggestions                    | Not POSIX; less common in prod |

💡 **In short**
bash = standard for scripting; zsh = improved interactive shell.

---

## Q6: What is the root user and what privileges does it have?

🧠 **Overview**
`root` is the superuser account with full system administrative privileges.

⚙️ **Capabilities**

* Install/remove software
* Modify system files (/etc, /var)
* Manage users, permissions
* Access any file/process

🧩 **Example**

```bash
whoami
sudo su -
```

💡 **In short**
root = unrestricted access; must be used carefully to avoid security risks.

---

## Q7: What is the difference between sudo and su commands?

🧠 **Overview**
Both allow privilege escalation but behave differently.

📋 **Comparison Table**

| Command  | Purpose                               | Behavior                                        |
| -------- | ------------------------------------- | ----------------------------------------------- |
| **sudo** | Run a single command as root          | Logs command; requires user to be in `sudoers`  |
| **su**   | Switch to another user (usually root) | Full shell session; uses target user’s password |

🧩 **Examples**

```bash
sudo systemctl restart nginx
su -  # switch to root
```

💡 **In short**
sudo = controlled privilege for one command; su = full user switch.

---

## Q8: How do you check the current Linux version and kernel version?

🧠 **Overview**
Used to verify OS distribution and kernel level (important for debugging, Kubernetes nodes, drivers).

🧩 **Commands**

```bash
cat /etc/os-release   # OS version
lsb_release -a        # distro details
uname -r              # kernel version
hostnamectl           # OS + kernel
```

💡 **In short**
Use `/etc/os-release` for OS, `uname -r` for kernel.

---

## Q9: What is the purpose of the /etc directory?

🧠 **Overview**
`/etc` contains **system-wide configuration files**.

⚙️ **What It Stores**

* Service configs (`/etc/ssh/sshd_config`)
* User/group info (`/etc/passwd`, `/etc/group`)
* Network configs (`/etc/hosts`, `/etc/resolv.conf`)

💡 **In short**
`/etc` = configuration backbone of Linux.

---

## Q10: What is stored in the /var directory?

🧠 **Overview**
`/var` holds variable data files that change frequently.

⚙️ **Common Contents**

* Logs → `/var/log/*`
* Spool files → `/var/spool`
* Cache → `/var/cache`
* App runtime data → `/var/lib`

🧩 **Example**

```bash
ls -l /var/log
```

💡 **In short**
`/var` stores logs, caches, and app runtime data — essential for debugging and services.

---

## Q11: What is the /tmp directory used for?

🧠 **Overview**
`/tmp` stores temporary files created by applications, scripts, or system processes. Contents are not persistent.

⚙️ **Purpose / Behavior**

* Used for caching, session files, installer temp files.
* Automatically cleaned on reboot or by systemd timers.

🧩 **Example**

```bash
touch /tmp/test.log
```

💡 **In short**
`/tmp` = temporary, disposable workspace.

---

## Q12: What is the difference between /bin and /usr/bin?

🧠 **Overview**
Both store user executable binaries but differ in purpose and historical usage.

📋 **Comparison Table**

| Directory    | Purpose                                         | Notes                           |
| ------------ | ----------------------------------------------- | ------------------------------- |
| **/bin**     | Essential binaries needed for boot and recovery | e.g., `ls`, `cp`, `mv`          |
| **/usr/bin** | Non-essential user commands                     | Installed packages’ executables |

💡 **In short**
`/bin` = core system commands; `/usr/bin` = user-level application commands.

---

## Q13: What is the /proc directory and what information does it contain?

🧠 **Overview**
`/proc` is a **virtual filesystem** exposing kernel and process information.

⚙️ **What It Contains**

* Process metadata (`/proc/<pid>/cmdline`, `/proc/<pid>/status`)
* Kernel parameters (`/proc/sys/…`)
* Hardware info (`/proc/cpuinfo`, `/proc/meminfo`)

🧩 **Examples**

```bash
cat /proc/cpuinfo
cat /proc/1234/status
```

💡 **In short**
`/proc` = real-time kernel and process info, not stored on disk.

---

## Q14: What is the purpose of the /home directory?

🧠 **Overview**
`/home` contains personal directories for each non-root user.

⚙️ **Contents**

* User files
* Shell configs (`.bashrc`, `.ssh/`)
* Application settings

💡 **In short**
`/home` = user’s workspace and configuration storage.

---

## Q15: How do you list files and directories in Linux?

🧠 **Overview**
The `ls` command shows directory contents, widely used for navigation and scripting.

🧩 **Examples**

```bash
ls
ls -l        # detailed view
ls -h        # human-readable sizes
ls /var/log  # list specific path
```

💡 **In short**
Use `ls` with flags for details and formatting.

---

## Q16: What is the difference between ls -l and ls -la?

📋 **Comparison**

| Command    | Meaning                     | What It Shows                  |
| ---------- | --------------------------- | ------------------------------ |
| **ls -l**  | Long listing                | Permissions, owner, size, date |
| **ls -la** | Long listing + hidden files | Same as above + dotfiles       |

🧩 **Example**

```bash
ls -l
ls -la
```

💡 **In short**
`-a` flag includes hidden files.

---

## Q17: How do you create a directory in Linux?

🧠 **Overview**
`mkdir` creates new directories at any path.

🧩 **Examples**

```bash
mkdir logs
mkdir -p /opt/app/config   # create nested dirs
```

💡 **In short**
Use `mkdir`; `-p` creates parent directories automatically.

---

## Q18: How do you remove a file and a directory?

🧠 **Overview**
Use `rm` for files and `rmdir`/`rm -r` for directories.

🧩 **Examples**

```bash
rm file.txt          # delete file
rmdir empty_dir      # remove empty directory
rm -r folder         # remove directory + contents
```

💡 **In short**
Files → `rm`; directories → `rmdir` or `rm -r`.

---

## Q19: What is the difference between rm and rm -rf?

📋 **Comparison**

| Command    | Action                         | Risk                        |
| ---------- | ------------------------------ | --------------------------- |
| **rm**     | Delete file(s)                 | Safe-ish                    |
| **rm -r**  | Recursively delete directories | Deletes subfolders          |
| **rm -rf** | Recursive + force delete       | No confirmation → dangerous |

⚠️ **Warning**
`rm -rf /` can destroy the system.

💡 **In short**
`rm -rf` removes everything recursively without confirmation.

---

## Q20: How do you copy files and directories?

🧠 **Overview**
Use `cp` for file and directory copies.

🧩 **Examples**

```bash
cp file1.txt file2.txt           # copy file
cp -r src_dir dest_dir           # copy directory
cp *.log /var/log/backup/        # copy multiple files
```

📋 **Flags Table**

| Flag | Meaning              |
| ---- | -------------------- |
| `-r` | recursive            |
| `-v` | verbose              |
| `-p` | preserve permissions |

💡 **In short**
`cp` copies files; use `cp -r` for directories.

---

## Q21: How do you move or rename files?

🧠 **Overview**
`mv` moves or renames files and directories.

🧩 **Examples**

```bash
mv file.txt /tmp/            # move
mv oldname.txt newname.txt   # rename
mv dir1 dir2/                # move directory
```

💡 **In short**
`mv` = move or rename; same command for both.

---

## Q22: What are file permissions in Linux?

🧠 **Overview**
File permissions control **who can read, write, or execute** files and directories. Essential for security, automation, and multi-user systems.

⚙️ **How It Works**
Each file has 3 permission sets:

* **Owner**
* **Group**
* **Others**

Each set contains:

* `r` → read
* `w` → write
* `x` → execute

🧩 **Example**

```bash
ls -l file.txt
# -rw-r--r-- 1 user user 20 Jan 1 file.txt
```

💡 **In short**
Permissions define allowed actions for owner/group/everyone else.

---

## Q23: What do the numbers 755, 644, and 777 mean in file permissions?

🧠 **Overview**
Numeric permissions are octal values representing read/write/execute bits.

📋 **Permission Table**

| Number | Binary | Meaning |
| ------ | ------ | ------- |
| **7**  | 111    | rwx     |
| **6**  | 110    | rw-     |
| **5**  | 101    | r-x     |
| **4**  | 100    | r--     |

📋 **Common Permission Sets**

| Code    | Meaning                       | Use Case                                    |
| ------- | ----------------------------- | ------------------------------------------- |
| **755** | Owner: rwx, Group/Others: r-x | Binaries, scripts                           |
| **644** | Owner: rw-, Group/Others: r-- | Config files, text files                    |
| **777** | Everyone: rwx                 | ⚠️ Not recommended (full permission to all) |

💡 **In short**
Numbers map to rwx bits; 755 for scripts, 644 for files, avoid 777.

---

## Q24: How do you change file permissions using chmod?

🧠 **Overview**
`chmod` modifies permissions using **numeric** or **symbolic** notation.

🧩 **Examples — Numeric**

```bash
chmod 755 script.sh
chmod 644 config.yaml
```

🧩 **Examples — Symbolic**

```bash
chmod u+x script.sh     # add execute to owner
chmod g-w file.txt      # remove write for group
chmod o+r file.txt      # add read for others
```

💡 **In short**
Use numeric for fast changes, symbolic for fine-grained adjustments.

---

## Q25: How do you change file ownership using chown?

🧠 **Overview**
`chown` changes the owner and/or group of a file or directory.

🧩 **Examples**

```bash
chown user file.txt             # change owner
chown user:group file.txt       # change owner + group
chown -R user:group /opt/app    # recursive
```

💡 **In short**
`chown` updates file ownership; `-R` for directories.

---

## Q26: What is the difference between absolute and symbolic links?

🧠 **Overview**
Links let you reference a file from another location.

📋 **Link Types**

| Type                        | Points To                     | Behavior                              |
| --------------------------- | ----------------------------- | ------------------------------------- |
| **Absolute link**           | Full path (/opt/app/file)     | Works regardless of current directory |
| **Relative link**           | Relative path (../file)       | Depends on link location              |
| **Symbolic link (symlink)** | Shortcut/alias → another file | Breaks if target removed              |
| **Hard link**               | Actual duplicate inode        | Doesn't break unless data removed     |

💡 **In short**
Symlink = pointer to file; hard link = another reference to same inode.

---

## Q27: How do you create a symbolic link?

🧠 **Overview**
Use `ln -s` to create symlinks.

🧩 **Examples**

```bash
ln -s /var/log/nginx/access.log access.log
ln -s /opt/app/config config-link
```

💡 **In short**
`ln -s <target> <link_name>` creates a symbolic link.

---

## Q28: What is the purpose of the grep command?

🧠 **Overview**
`grep` searches text for patterns using regex; heavily used in troubleshooting, logs, and pipelines.

🧩 **Examples**

```bash
grep "error" /var/log/syslog
grep -i "failed" app.log     # case-insensitive
grep -r "timeout" /etc       # recursive search
```

💡 **In short**
grep = pattern search tool for files and command output.

---

## Q29: How do you search for a file using the find command?

🧠 **Overview**
`find` searches files based on name, size, type, modified time, permissions, etc.

🧩 **Examples**

```bash
find / -name "nginx.conf"
find /var/log -type f -size +10M
find . -mtime -1               # modified in last 24h
```

💡 **In short**
`find <path> -options` locates files by various attributes.

---

## Q30: What does the cat command do?

🧠 **Overview**
`cat` displays, concatenates, or creates files.

🧩 **Examples**

```bash
cat file.txt
cat file1 file2 > combined.txt
```

💡 **In short**
`cat` reads or merges files; simplest file viewer.

---

## Q31: What is the difference between cat, less, more, and head commands?

📋 **Comparison Table**

| Command          | Purpose                        | Behavior               |
| ---------------- | ------------------------------ | ---------------------- |
| **cat**          | Print entire file              | No paging              |
| **less**         | View with scroll (recommended) | Move up/down freely    |
| **more**         | View with paging               | Forward only           |
| **head**         | Show first N lines             | Default 10 lines       |
| **tail** (bonus) | Show last N lines              | Use `tail -f` for logs |

🧩 **Examples**

```bash
less /var/log/messages
head -20 file.txt
tail -f app.log
```

💡 **In short**
Use `less` for large files; `head`/`tail` for quick previews; `cat` for small outputs.

---

## Q32: How do you view the last few lines of a file?

🧠 **Overview**
Use the `tail` command to see the most recent lines—useful for logs and debugging apps.

🧩 **Examples**

```bash
tail file.log            # last 10 lines
tail -20 file.log        # last 20 lines
tail -f /var/log/syslog  # live log streaming
```

💡 **In short**
`tail` shows the end of a file; `tail -f` follows updates.

---

## Q33: What is piping (|) in Linux?

🧠 **Overview**
Piping (`|`) sends the **output of one command as input to another**, enabling powerful command chaining.

⚙️ **How It Works**
Command1 → output → Command2 → processed output.

🧩 **Examples**

```bash
ps aux | grep nginx
cat access.log | wc -l
dmesg | less
```

💡 **In short**
Pipes connect commands together for streamlined processing.

---

## Q34: What is output redirection (>, >>) in Linux?

🧠 **Overview**
Redirection writes command output to files instead of the terminal.

📋 **Redirection Table**

| Operator | Action                     |
| -------- | -------------------------- |
| `>`      | Overwrite file with output |
| `>>`     | Append output to file      |
| `2>`     | Redirect errors            |
| `&>`     | Redirect stdout + stderr   |

🧩 **Examples**

```bash
echo "hello" > file.txt      # overwrite
echo "more" >> file.txt      # append
ls /notfound 2> errors.log   # capture errors
```

💡 **In short**
Use `>` to overwrite, `>>` to append.

---

## Q35: How do you check running processes?

🧠 **Overview**
Use `ps`, `top`, or `htop` to list active processes.

🧩 **Examples**

```bash
ps aux            # all processes
ps -ef            # full-format listing
top               # real-time view
```

💡 **In short**
`ps` = snapshot; `top` = live process view.

---

## Q36: What is the difference between ps and top commands?

📋 **Comparison**

| Command | Purpose                 | Behavior               |
| ------- | ----------------------- | ---------------------- |
| **ps**  | Lists current processes | One-time snapshot      |
| **top** | Monitors processes live | Refreshes continuously |

🧩 **Examples**

```bash
ps aux | grep ssh
top
```

💡 **In short**
`ps` for filtering and scripting; `top` for real-time monitoring.

---

## Q37: How do you kill a process in Linux?

🧠 **Overview**
Use `kill` with the process ID (PID).

🧩 **Examples**

```bash
ps aux | grep app
kill 1234             # TERM signal
kill -9 1234          # force kill
```

💡 **In short**
Identify PID → kill PID; use `-9` only if graceful kill fails.

---

## Q38: What is the difference between kill, killall, and pkill?

📋 **Comparison Table**

| Command     | Kills By        | Use Case                                  |
| ----------- | --------------- | ----------------------------------------- |
| **kill**    | PID             | Precise targeting                         |
| **killall** | Process name    | Kill all instances of a program           |
| **pkill**   | Name or pattern | Pattern-based filtering (regex supported) |

🧩 **Examples**

```bash
kill 1234
killall nginx
pkill -f "python app.py"
```

💡 **In short**
kill = PID, killall = name, pkill = pattern.

---

## Q39: How do you check disk space usage?

🧠 **Overview**
Use `df` (disk filesystem usage) and `du` (directory usage).

🧩 **Examples**

```bash
df -h                 # disk usage per filesystem
du -sh /var/log       # size of directory
du -sh *              # size of all items in folder
```

💡 **In short**
`df` = disk, `du` = directory/file sizes.

---

## Q40: How do you check memory usage in Linux?

🧠 **Overview**
Memory usage can be checked via `free`, `top`, `vmstat`, or `/proc/meminfo`.

🧩 **Examples**

```bash
free -h               # human-readable memory usage
top                   # live memory usage
cat /proc/meminfo     # detailed stats
vmstat -s             # system memory summary
```

💡 **In short**
Use `free -h` for quick view, `top` for real-time monitoring.

---

## Q41: What is a process in Linux and what states can it be in?

🧠 **Overview**
A process is an executing instance of a program. The kernel tracks each process with a PID and transitions it through different states.

📋 **Common Process States**

| State                         | Meaning                                                  |
| ----------------------------- | -------------------------------------------------------- |
| **R (Running)**               | Actively executing or ready to run                       |
| **S (Sleeping)**              | Waiting for an event (most processes)                    |
| **D (Uninterruptible sleep)** | Waiting on I/O (disk, network)                           |
| **T (Stopped)**               | Paused (SIGSTOP)                                         |
| **Z (Zombie)**                | Process finished but parent hasn’t collected exit status |

🧩 **Example**

```bash
ps -eo pid,stat,cmd
```

💡 **In short**
Process = running program; processes move through states like running, sleeping, or zombie.

---

## Q42: What is the difference between a process and a thread?

📋 **Comparison Table**

| Aspect        | Process          | Thread                            |
| ------------- | ---------------- | --------------------------------- |
| Memory        | Own memory space | Shares memory with parent process |
| Overhead      | High             | Low                               |
| Isolation     | Strong           | Weak                              |
| Communication | IPC needed       | Shared memory                     |

🧠 **Key Point**
Threads are lightweight units within a process; processes are isolated from each other.

💡 **In short**
Process = independent execution; Thread = lightweight execution inside a process.

---

## Q43: What is a zombie process and how do you identify it?

🧠 **Overview**
A zombie process is a completed process whose parent hasn't read its exit status. It consumes no CPU or memory (except a tiny entry in the process table).

⚙️ **Identification**

```bash
ps aux | grep Z
ps -eo pid,ppid,stat,cmd | grep ' Z '
```

State appears as **Z** or **defunct**.

💡 **In short**
Zombie = dead process waiting for parent cleanup.

---

## Q44: What is an orphan process?

🧠 **Overview**
An orphan process is one whose parent has exited. These are adopted by **init/systemd**, which becomes the new parent.

⚙️ **How It Works**

* Orphan survives parent termination.
* systemd reaps it when it finishes.

💡 **In short**
Orphan = parent died; systemd adopts and manages it.

---

## Q45: What is a daemon process in Linux?

🧠 **Overview**
A daemon is a background service detached from any terminal—e.g., SSHD, CRON, systemd services.

⚙️ **Characteristics**

* Starts at boot
* Runs in background
* No controlling terminal

🧩 **Examples**

```bash
systemctl status sshd
```

💡 **In short**
Daemon = background service performing system tasks.

---

## Q46: How do systemd and init differ in managing services?

📋 **Comparison**

| Aspect              | init (SysV)        | systemd                   |
| ------------------- | ------------------ | ------------------------- |
| Boot Speed          | Slow (sequential)  | Fast (parallel)           |
| Config              | Shell scripts      | Unit files                |
| Logging             | No unified logging | Journal (`journalctl`)    |
| Dependency Handling | Limited            | Advanced dependency graph |

🧠 **Key Point**
systemd is the modern service manager with better logging, dependency handling, and performance.

💡 **In short**
init = legacy; systemd = modern, faster, feature-rich.

---

## Q47: How do you create and manage systemd services?

🧠 **Overview**
Systemd uses **unit files** located in `/etc/systemd/system/`.

🧩 **Example Service File**
`/etc/systemd/system/app.service`

```ini
[Unit]
Description=My App Service
After=network.target

[Service]
ExecStart=/usr/bin/python3 /opt/app/app.py
Restart=always
User=appuser

[Install]
WantedBy=multi-user.target
```

🧩 **Managing the Service**

```bash
systemctl daemon-reload
systemctl start app.service
systemctl stop app.service
systemctl restart app.service
systemctl status app.service
```

💡 **In short**
Create unit file → reload → start/enable service.

---

## Q48: What is the purpose of the systemctl command?

🧠 **Overview**
`systemctl` is the control interface for systemd, used to manage services, units, and system state.

🧩 **Common Commands**

```bash
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
systemctl status nginx
systemctl enable nginx
systemctl disable nginx
systemctl list-units --type=service
```

💡 **In short**
`systemctl` manages services (start/stop/status/enable).

---

## Q49: How do you enable a service to start at boot?

🧠 **Overview**
Use `systemctl enable` to register the service in the appropriate target.

🧩 **Command**

```bash
systemctl enable nginx
systemctl disable nginx
```

💡 **In short**
`enable` adds symlinks so the service auto-starts at boot.

---

## Q50: What are runlevels in Linux?

🧠 **Overview**
Runlevels define system states (traditional init-based systems). systemd replaces this with "targets".

📋 **Traditional Runlevels**

| Runlevel | Meaning             |
| -------- | ------------------- |
| 0        | Halt                |
| 1        | Single-user mode    |
| 3        | Multi-user (no GUI) |
| 5        | Multi-user with GUI |
| 6        | Reboot              |

📋 **systemd Equivalent**

| Runlevel | Target            |
| -------- | ----------------- |
| 3        | multi-user.target |
| 5        | graphical.target  |

🧩 **Check current target**

```bash
systemctl get-default
```

💡 **In short**
Runlevels define system state; systemd uses more flexible "targets".

---

## Q51: What is the difference between systemctl and service commands?

🧠 **Overview**
Both manage services, but `systemctl` is for **systemd**, while `service` is for older **SysVinit** systems (though still works as a wrapper).

📋 **Comparison**

| Feature  | systemctl                        | service               |
| -------- | -------------------------------- | --------------------- |
| System   | systemd                          | SysVinit (legacy)     |
| Controls | services, units, targets, timers | only services         |
| Logging  | journalctl integration           | no native logging     |
| Syntax   | `systemctl start nginx`          | `service nginx start` |

💡 **In short**
`systemctl` = modern, full-featured; `service` = legacy wrapper.

---

## Q52: How do you check system logs in Linux?

🧠 **Overview**
Logs are crucial for debugging services, kernel, authentication, and boot issues.

🧩 **Examples**

```bash
tail -f /var/log/syslog
tail -f /var/log/messages
journalctl -xe        # systemd logs
journalctl -u nginx   # service logs
```

💡 **In short**
Check `/var/log/*` or use `journalctl` on systemd systems.

---

## Q53: What is the purpose of journalctl?

🧠 **Overview**
`journalctl` reads logs from **systemd’s journald**. It provides unified, structured, queryable logs.

🧩 **Common Commands**

```bash
journalctl                # full log
journalctl -u nginx       # service logs
journalctl -xe            # errors + last entries
journalctl --since "1 hour ago"
journalctl -b             # logs from current boot
```

💡 **In short**
`journalctl` = centralized log viewer for systemd-managed systems.

---

## Q54: Where are system logs typically stored in Linux?

🧠 **Overview**
Most logs are in `/var/log/`, including system, application, and authentication logs.

📋 **Common Log Paths**

| Log File            | Purpose                         |
| ------------------- | ------------------------------- |
| `/var/log/syslog`   | System messages (Debian/Ubuntu) |
| `/var/log/messages` | System messages (RHEL/CentOS)   |
| `/var/log/auth.log` | Authentication logs             |
| `/var/log/secure`   | Auth logs (RHEL/CentOS)         |
| `/var/log/kern.log` | Kernel logs                     |
| `/var/log/dmesg`    | Boot + kernel ring buffer       |

💡 **In short**
Logs live in `/var/log`; location varies by distro.

---

## Q55: What is the difference between /var/log/syslog and /var/log/messages?

📋 **Comparison**

| File                  | Distro        | Contains                                              |
| --------------------- | ------------- | ----------------------------------------------------- |
| **/var/log/syslog**   | Debian/Ubuntu | System logs, services, kernel, general events         |
| **/var/log/messages** | RHEL/CentOS   | General system messages, but fewer kernel/auth events |

🧠 **Key Point**
Both are “general system logs,” but the naming depends on the OS family.

💡 **In short**
Ubuntu → `/var/log/syslog`
RHEL → `/var/log/messages`

---

## Q56: How do you configure log rotation in Linux?

🧠 **Overview**
Log rotation prevents log files from growing without limit by compressing, rotating, and purging older logs.

⚙️ **Config Locations**

* Main config: `/etc/logrotate.conf`
* App-specific configs: `/etc/logrotate.d/*`

🧩 **Example Entry**

```conf
/var/log/nginx/*.log {
    daily
    rotate 7
    compress
    missingok
    notifempty
}
```

💡 **In short**
Use logrotate configs to rotate logs daily/weekly and limit retention.

---

## Q57: What is logrotate and how does it work?

🧠 **Overview**
`logrotate` is the Linux tool that **automates log rotation**—splitting, compressing, and cleaning up logs.

⚙️ **How It Works**

* Reads configs from `/etc/logrotate*`
* Rotates based on size/time
* Compresses old logs (`.gz`)
* Deletes logs past retention threshold
* Usually triggered daily via cron or systemd timer

🧩 **Manual rotation**

```bash
logrotate -f /etc/logrotate.conf
```

💡 **In short**
logrotate manages log growth automatically.

---

## Q58: How do you monitor real-time logs?

🧠 **Overview**
Real-time logs are essential for debugging running applications.

🧩 **Examples**

```bash
tail -f /var/log/syslog
tail -f /var/log/nginx/access.log
journalctl -u nginx -f
```

💡 **In short**
Use `tail -f` or `journalctl -f` to stream logs live.

---

## Q59: What is the purpose of the dmesg command?

🧠 **Overview**
`dmesg` displays messages from the **kernel ring buffer**—mostly hardware, drivers, and boot events.

🧩 **Examples**

```bash
dmesg | grep error
dmesg | grep usb
```

⚙️ **Useful for**

* Disk / I/O debugging
* Kernel crashes
* USB/network hardware events
* Boot diagnostics

💡 **In short**
`dmesg` = kernel-level event log viewer.

---

## Q60: How do you troubleshoot boot issues using system logs?

🧠 **Overview**
Boot issues often relate to misconfigured services, failing mounts, kernel problems, or hardware errors. systemd-based systems provide detailed boot logs.

🧩 **Useful Commands**

```bash
journalctl -b         # logs from current boot
journalctl -b -1      # previous boot
journalctl -xe        # errors + warnings
systemctl --failed    # failed services
dmesg | less          # kernel + hardware messages
```

⚙️ **Steps**

1. Check failed units → `systemctl --failed`
2. Inspect boot logs → `journalctl -b`
3. Check kernel messages → `dmesg`
4. Validate mount points in `/etc/fstab`

💡 **In short**
Use `journalctl -b`, `systemctl --failed`, and `dmesg` to identify the service or hardware issue.

---

## Q61: What is swap space in Linux?

🧠 **Overview**
Swap is disk space used as an extension of RAM when memory is full. It prevents OOM (Out-of-Memory) crashes but is slower than RAM.

⚙️ **Used For**

* Memory overflow handling
* Hibernation (on desktops/laptops)

💡 **In short**
Swap = disk-backed virtual memory used when RAM runs out.

---

## Q62: How do you create and configure swap space?

🧠 **Overview**
You can create swap using a **swap file** or **swap partition**.

🧩 **Create Swap File (Most Common)**

```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

🧩 **Make Swap Persistent**
Add to `/etc/fstab`:

```
/swapfile  none  swap  sw  0  0
```

💡 **In short**
Create file → set permissions → `mkswap` → `swapon` → add to fstab.

---

## Q63: What is swappiness and how do you tune it?

🧠 **Overview**
Swappiness controls how aggressively Linux swaps memory to disk (0–100).

📋 **Values**

* **Low value (e.g., 10)** → avoid swap, use RAM more
* **High value (e.g., 60 default)** → swap more aggressively

🧩 **Check Current Value**

```bash
cat /proc/sys/vm/swappiness
```

🧩 **Set Temporarily**

```bash
sudo sysctl vm.swappiness=10
```

🧩 **Set Permanently**
Add to `/etc/sysctl.conf`:

```
vm.swappiness = 10
```

💡 **In short**
Swappiness = kernel’s swap aggressiveness; tune via sysctl.

---

## Q64: What are inodes in Linux?

🧠 **Overview**
Inodes store metadata about files (permissions, size, timestamps, pointers to data blocks). Every file uses an inode.

⚙️ **Inode Does NOT Store**

* Filename
* File content

💡 **In short**
Inode = metadata structure describing a file on disk.

---

## Q65: How do you check inode usage?

🧠 **Overview**
Use `df -i` to check inode capacity and usage.

🧩 **Examples**

```bash
df -i
stat file.txt          # inode number
ls -i                  # show inode for files
```

💡 **In short**
Use `df -i` to see inode usage per filesystem.

---

## Q66: What happens when you run out of inodes?

🧠 **Overview**
Even if disk space is free, you cannot create new files if inodes are exhausted.

⚙️ **Symptoms**

* “No space left on device” errors
* `touch`, or app writes fail
* Lots of tiny files filling inodes

🧩 **Check**

```bash
df -i
```

💡 **In short**
Running out of inodes prevents new files from being created.

---

## Q67: What is the difference between hard links and soft links?

📋 **Comparison Table**

| Feature                  | Hard Link             | Soft Link (Symlink) |
| ------------------------ | --------------------- | ------------------- |
| Points to                | File inode            | File path           |
| Breaks if target removed | No                    | Yes                 |
| Cross filesystem support | No                    | Yes                 |
| File type                | Identical to original | Shortcut            |
| Inode count              | Increases             | No change           |

💡 **In short**
Hard link = same file; symlink = pointer to file path.

---

## Q68: What are the limitations of hard links?

🧠 **Overview**

| Limitation               | Explanation                   |
| ------------------------ | ----------------------------- |
| Cannot link directories  | Prevents recursive loops      |
| Cannot cross filesystems | Must be same partition        |
| Becomes confusing        | All hard links look identical |

💡 **In short**
Hard links only work within the same filesystem and not for directories.

---

## Q69: How does file system mounting work in Linux?

🧠 **Overview**
Mounting attaches a filesystem (disk, partition, NFS, USB) to a directory tree so it becomes accessible.

⚙️ **Steps**

1. Detect device: `/dev/sdb1`
2. Create mount point: `mkdir /mnt/data`
3. Mount filesystem:

```bash
mount /dev/sdb1 /mnt/data
```

🧩 **View Mounts**

```bash
mount | grep sdb1
df -h
```

💡 **In short**
Mounting exposes a filesystem at a directory path.

---

## Q70: What is /etc/fstab and what is its purpose?

🧠 **Overview**
`/etc/fstab` defines filesystems to mount at boot, including mount points, types, and options.

🧩 **Example fstab Entry**

```
/dev/sdb1   /data   ext4    defaults   0  2
```

📋 **Fields**

| Field | Meaning         |
| ----- | --------------- |
| 1     | Device          |
| 2     | Mount point     |
| 3     | Filesystem type |
| 4     | Options         |
| 5     | Dump            |
| 6     | fsck order      |

💡 **In short**
`fstab` automates mounting of filesystems at boot.

---

## Q71: How do you mount and unmount file systems?

🧠 **Overview**
Use `mount` to attach and `umount` to detach filesystems.

🧩 **Mount Examples**

```bash
sudo mount /dev/sdb1 /mnt/data
sudo mount -t nfs 192.168.1.10:/share /mnt/nfs
```

🧩 **Unmount Examples**

```bash
sudo umount /mnt/data
sudo umount /dev/sdb1
```

⚠️ **Warning**
Unmount fails if the directory is in use:

```bash
lsof /mnt/data
```

💡 **In short**
`mount` attaches; `umount` detaches; ensure no process is using the mount.

---

## Q72: What file systems are commonly used in Linux (ext4, xfs, btrfs)?

🧠 **Overview**
Different filesystems are optimized for performance, stability, scalability, and snapshotting.

📋 **Comparison Table**

| Filesystem | Best For                                | Features                               |
| ---------- | --------------------------------------- | -------------------------------------- |
| **ext4**   | General-purpose Linux servers           | Stable, mature, fast                   |
| **XFS**    | Large files, enterprise environments    | High performance, scalable, journaling |
| **Btrfs**  | Snapshots, checksums, advanced features | CoW, RAID, compression, snapshots      |

💡 **In short**
ext4 = default, XFS = high performance, Btrfs = advanced CoW features.

---

## Q73: How do you check file system integrity using fsck?

🧠 **Overview**
`fsck` checks and repairs filesystem inconsistencies. Must run on **unmounted** or **read-only** partitions.

🧩 **Examples**

```bash
sudo fsck /dev/sdb1
sudo fsck -y /dev/sdc1   # auto-fix
```

⚠️ **Warning**
Never run `fsck` on a mounted filesystem—can corrupt data.

💡 **In short**
Use `fsck` offline to fix filesystem errors.

---

## Q74: What is LVM (Logical Volume Manager)?

🧠 **Overview**
LVM provides flexible storage management by abstracting disks into **physical volumes → volume groups → logical volumes**.

📋 **LVM Layers**

| Layer  | Description                                   |
| ------ | --------------------------------------------- |
| **PV** | Physical disks/partitions                     |
| **VG** | Pool of PVs                                   |
| **LV** | Virtual “disk” used as partitions/filesystems |

💡 **In short**
LVM = dynamic storage allowing resizing and flexible allocation.

---

## Q75: How do you create and manage logical volumes?

🧠 **Overview**
LVM commands manage PVs, VGs, and LVs.

🧩 **Create Physical Volume**

```bash
pvcreate /dev/sdb1
```

🧩 **Create Volume Group**

```bash
vgcreate vgdata /dev/sdb1
```

🧩 **Create Logical Volume**

```bash
lvcreate -L 10G -n lvdata vgdata
mkfs.ext4 /dev/vgdata/lvdata
mount /dev/vgdata/lvdata /data
```

🧩 **Extend Logical Volume**

```bash
lvextend -L +5G /dev/vgdata/lvdata
resize2fs /dev/vgdata/lvdata    # ext4
```

💡 **In short**
Create PV → VG → LV → format → mount.

---

## Q76: What are the advantages of using LVM?

📋 **Benefits**

| Feature          | Description                              |
| ---------------- | ---------------------------------------- |
| **Resizing**     | Expand/shrink LVs dynamically            |
| **Snapshots**    | Point-in-time backups                    |
| **Disk pooling** | Combine multiple disks                   |
| **Migration**    | Move data between disks without downtime |

💡 **In short**
LVM provides flexible, scalable, and dynamic storage management.

---

## Q77: How do you extend a logical volume without downtime?

🧠 **Overview**
Online resizing works for most filesystems (ext4, XFS).

🧩 **Steps**

1. Extend LV:

```bash
lvextend -L +5G /dev/vgdata/lvdata
```

2. Resize filesystem:

**ext4**

```bash
resize2fs /dev/vgdata/lvdata
```

**XFS**

```bash
xfs_growfs /data
```

💡 **In short**
Extend LV → grow filesystem; works online on modern filesystems.

---

## Q78: What is RAID and what RAID levels are supported in Linux?

🧠 **Overview**
RAID combines disks for redundancy and/or performance.

📋 **Common RAID Levels**

| Level       | Description                   |
| ----------- | ----------------------------- |
| **RAID 0**  | Striping, no redundancy, fast |
| **RAID 1**  | Mirroring                     |
| **RAID 5**  | Striping + parity             |
| **RAID 6**  | Double parity                 |
| **RAID 10** | Mirrors + stripe              |

Linux uses the **mdadm** tool for software RAID.

💡 **In short**
RAID = redundancy/performance using multiple disks.

---

## Q79: How do you configure software RAID in Linux?

🧠 **Overview**
mdadm manages software RAID arrays.

🧩 **Create RAID1 Array**

```bash
mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc
```

🧩 **Check Status**

```bash
cat /proc/mdstat
```

🧩 **Persist config**

```bash
mdadm --detail --scan >> /etc/mdadm/mdadm.conf
```

💡 **In short**
Create array → monitor with `/proc/mdstat` → persist config.

---

## Q80: What is the difference between cron and at commands?

📋 **Comparison**

| Feature | cron                                | at                          |
| ------- | ----------------------------------- | --------------------------- |
| Purpose | Recurring tasks                     | One-time tasks              |
| Config  | crontab files                       | at queue                    |
| Usage   | Schedules daily/weekly/hourly tasks | Run once at a specific time |

🧩 **Examples**

```bash
at 2pm
cron: * * * * * <cmd>
```

💡 **In short**
cron = recurring; at = one-time scheduled jobs.

---

## Q81: How do you schedule tasks using crontab?

🧠 **Overview**
Crontab runs scheduled jobs at fixed intervals.

🧩 **Edit Crontab**

```bash
crontab -e
```

🧩 **List Jobs**

```bash
crontab -l
```

🧩 **Example Cron Job**

```
0 2 * * * /usr/bin/backup.sh
```

💡 **In short**
Use `crontab -e` to schedule recurring tasks.

---

## Q82: What is the syntax for cron expressions?

📋 **Cron Fields**

| Field | Meaning       | Example |
| ----- | ------------- | ------- |
| 1     | Minute (0–59) | 30      |
| 2     | Hour (0–23)   | 14      |
| 3     | Day of month  | 1       |
| 4     | Month         | 1–12    |
| 5     | Day of week   | 0–7     |

🧩 **Examples**

```
* * * * *     # every minute
0 3 * * 1     # every Monday at 3 AM
*/5 * * * *   # every 5 minutes
```

💡 **In short**
Cron uses 5 fields defining schedule frequency.

---

## Q83: How do you manage user cron jobs vs system cron jobs?

🧠 **Overview**
Linux differentiates between **per-user cron jobs** and **system-wide cron jobs**.

📋 **Comparison Table**

| Type                 | Location                                   | Use Case                            |
| -------------------- | ------------------------------------------ | ----------------------------------- |
| **User crontab**     | `crontab -e`, stored in `/var/spool/cron/` | User-specific tasks                 |
| **System crontab**   | `/etc/crontab`                             | Tasks needing specific user context |
| **System cron jobs** | `/etc/cron.daily`, `/etc/cron.hourly`      | Automated periodic tasks            |

🧩 **Example System Crontab Entry**

```
0 1 * * * root /usr/local/bin/cleanup.sh
```

💡 **In short**
User cron → `crontab -e`; system cron → `/etc/crontab` + cron.* directories.

---

## Q84: What is anacron and when would you use it?

🧠 **Overview**
`anacron` runs scheduled jobs **not tied to specific times**, useful for systems **not running 24/7** (laptops, desktops).

📋 **Key Features**

| Feature                      | Description                       |
| ---------------------------- | --------------------------------- |
| Not time-based               | Runs tasks *after boot* if missed |
| Complements cron             | Ensures periodic jobs still run   |
| Daily/weekly/monthly support | No minute-level schedules         |

🧩 **Config**

```bash
/etc/anacrontab
```

💡 **In short**
Use `anacron` when the system may be powered off during cron runs.

---

## Q85: How do you manage users and groups in Linux?

🧠 **Overview**
Users and groups control access and permissions for multi-user systems.

🧩 **Commands**

```bash
# Users
useradd username
userdel username
passwd username

# Groups
groupadd devops
groupdel devops
usermod -aG devops username
```

💡 **In short**
Use `useradd`, `usermod`, `groupadd`, and `passwd` to manage accounts.

---

## Q86: What files store user and group information?

🧠 **Overview**

📋 **Key Files**

| File           | Stores                                  |
| -------------- | --------------------------------------- |
| `/etc/passwd`  | User account info (UID, home, shell)    |
| `/etc/shadow`  | Encrypted passwords + password policies |
| `/etc/group`   | Group info                              |
| `/etc/gshadow` | Secure group passwords                  |

💡 **In short**
User and group metadata lives in `/etc/passwd`, `/etc/shadow`, `/etc/group`.

---

## Q87: What is the purpose of /etc/passwd and /etc/shadow?

📋 **Comparison**

| File          | Purpose                                          | Security         |
| ------------- | ------------------------------------------------ | ---------------- |
| `/etc/passwd` | Basic user info: username, UID, GID, home, shell | World-readable   |
| `/etc/shadow` | Hashed passwords + password aging rules          | Root-only access |

🧩 **Example Entry**
`/etc/passwd`

```
vasu:x:1001:1001:/home/vasu:/bin/bash
```

`/etc/shadow`

```
vasu:$6$hash...:19230:0:99999:7:::
```

💡 **In short**
passwd = user metadata; shadow = secure password storage.

---

## Q88: How do you add and remove users in Linux?

🧩 **Add User**

```bash
sudo useradd vasu
sudo passwd vasu
```

🧩 **Add User With Home Directory**

```bash
sudo useradd -m vasu
```

🧩 **Remove User**

```bash
sudo userdel vasu
sudo userdel -r vasu   # remove home directory too
```

💡 **In short**
`useradd` + `passwd` to create; `userdel` to remove.

---

## Q89: What is the difference between useradd and adduser?

📋 **Comparison**

| Command     | Type               | Behavior                                              |
| ----------- | ------------------ | ----------------------------------------------------- |
| **useradd** | Low-level          | Requires manual config; minimal defaults              |
| **adduser** | High-level wrapper | Interactive, creates home, sets shell, assigns groups |

💡 **In short**
`adduser` = friendly wrapper; `useradd` = raw low-level tool.

---

## Q90: How do you modify user account properties?

🧠 **Overview**
Use `usermod` to update shell, groups, home directory, lock account, etc.

🧩 **Examples**

```bash
sudo usermod -aG sudo vasu       # add to group
sudo usermod -s /bin/zsh vasu    # change shell
sudo usermod -d /new/home vasu   # change home dir
sudo usermod -L vasu             # lock account
sudo usermod -U vasu             # unlock account
```

💡 **In short**
`usermod` updates user properties; `-aG`, `-s`, `-L`, `-U` are common options.

---

## Q91: What is PAM (Pluggable Authentication Modules)?

🧠 **Overview**
PAM is a modular authentication framework used by Linux to control login, sudo, SSH, and password policies.

📋 **Functions Controlled by PAM**

* Password authentication
* Account lockouts
* Two-factor authentication
* Password strength policies
* Session rules

📍 **Config Location**

```
/etc/pam.d/
```

💡 **In short**
PAM = authentication logic layer behind logins and security policies.

---

## Q92: How do you configure password policies in Linux?

🧠 **Overview**
Password aging, complexity, and retry policies are configured via PAM and `/etc/login.defs`.

🧩 **Password Aging (login.defs)**

```
PASS_MAX_DAYS 90
PASS_MIN_DAYS 7
PASS_WARN_AGE 7
```

🧩 **Enforce Password Complexity (PAM)**
`/etc/pam.d/common-password` (Debian/Ubuntu)

```
password requisite pam_pwquality.so retry=3 minlen=12 dcredit=-1 ucredit=-1
```

🧩 **Lock Account After Failed Attempts**

```
auth required pam_faillock.so deny=5 unlock_time=600
```

💡 **In short**
Use `/etc/login.defs` + PAM (`pam_pwquality`, `pam_faillock`) to enforce password rules.

---

## Q93: What is SELinux and what is its purpose?

🧠 **Overview**
SELinux (Security-Enhanced Linux) provides **mandatory access control (MAC)**, restricting processes based on security contexts.

⚙️ **Purpose**

* Restrict service access even if compromised
* Enforce least-privilege access
* Mandatory security policies independent of file permissions

🧩 **Check Status**

```bash
getenforce
sestatus
```

💡 **In short**
SELinux adds strong, kernel-enforced security beyond standard permissions.

---

## Q94: What are SELinux modes (enforcing, permissive, disabled)?

📋 **Modes**

| Mode           | Behavior                                             |
| -------------- | ---------------------------------------------------- |
| **Enforcing**  | Policies enforced; blocked actions logged and denied |
| **Permissive** | Violations logged only; not blocked                  |
| **Disabled**   | SELinux is turned off                                |

🧩 **Switch Temporarily**

```bash
sudo setenforce 0   # permissive
sudo setenforce 1   # enforcing
```

💡 **In short**
Enforcing = active protection; Permissive = debug mode; Disabled = off.

---

## Q95: How do you troubleshoot SELinux permission denials?

🧠 **Overview**
SELinux denials occur when a process tries to access something forbidden by SELinux policy.

🧩 **Steps to Troubleshoot**

1. **Check logs for denials**

```bash
sudo journalctl -t setroubleshoot
sudo ausearch -m AVC -ts recent
```

2. **Use sealert for human-readable explanation**

```bash
sudo sealert -a /var/log/audit/audit.log
```

3. **Fix context mismatches**

```bash
sudo restorecon -Rv /var/www/html
```

4. **Check file/process context**

```bash
ls -Z file
ps -Z -p <pid>
```

💡 **In short**
Locate AVC denials → interpret via sealert → fix context (`restorecon`) or adjust SELinux rules.

---

## Q96: What is AppArmor and how does it differ from SELinux?

📋 **Comparison Table**

| Feature            | SELinux            | AppArmor       |
| ------------------ | ------------------ | -------------- |
| Model              | Label-based (MAC)  | Path-based     |
| Complexity         | High               | Easier         |
| Policy granularity | Very fine-grained  | Moderate       |
| Default in         | RHEL/CentOS/Fedora | Ubuntu, Debian |
| Logging            | AVC                | AppArmor logs  |

🧠 **Key Point**
SELinux uses security labels; AppArmor uses file paths.

💡 **In short**
SELinux = complex, label-based MAC; AppArmor = simpler, path-based MAC.

---

## Q97: How do you configure firewall rules using iptables?

🧠 **Overview**
`iptables` manages packet filtering and NAT on Linux.

🧩 **Examples**

```bash
# Allow SSH
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP/HTTPS
iptables -A INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT

# Drop all incoming traffic by default
iptables -P INPUT DROP

# Save rules
iptables-save > /etc/iptables/rules.v4
```

💡 **In short**
iptables defines packet rules via INPUT, OUTPUT, FORWARD chains and targets like ACCEPT/DROP.

---

## Q98: What is the difference between iptables and firewalld?

📋 **Comparison**

| Feature     | iptables               | firewalld                  |
| ----------- | ---------------------- | -------------------------- |
| Approach    | Rule-based             | Zone-based                 |
| Ease of use | Manual, static         | Dynamic, simpler           |
| Persistence | Manual save            | Automatic                  |
| Backend     | nftables (new distros) | Uses nftables as backend   |
| Support     | Legacy                 | Modern RHEL/CentOS default |

💡 **In short**
iptables = manual & static; firewalld = dynamic, zone-based, easier to manage.

---

## Q99: How do you configure networking in Linux?

🧠 **Overview**
Networking is configured via network interface files, NetworkManager, or `ip` commands.

🧩 **Check Interfaces**

```bash
ip addr
ip link
ip route
```

🧩 **Manual Assignment**

```bash
sudo ip addr add 192.168.1.10/24 dev eth0
sudo ip route add default via 192.168.1.1
```

🧩 **Persistent Config**

* `/etc/network/interfaces` (Debian/Ubuntu legacy)
* `/etc/sysconfig/network-scripts/ifcfg-*` (RHEL/CentOS)
* `netplan` (Ubuntu modern)

💡 **In short**
Use `ip` for temporary settings; config files/Netplan/NetworkManager for persistence.

---

## Q100: What is the difference between ifconfig and ip commands?

📋 **Comparison Table**

| Feature   | ifconfig   | ip                                  |
| --------- | ---------- | ----------------------------------- |
| Status    | Deprecated | Modern replacement                  |
| Functions | Basic      | Comprehensive (routes, links, addr) |
| Package   | net-tools  | iproute2                            |
| Syntax    | Simple     | More powerful, structured           |

🧩 **Examples**

```bash
ifconfig
ip addr show
ip route
```

💡 **In short**
`ip` is the modern, full-featured networking command; `ifconfig` is outdated.

---

## Q101: How do you configure static IP addresses in Linux?

🧠 **Overview**
Static IP configuration depends on the Linux distribution.

🧩 **Ubuntu (Netplan)**
`/etc/netplan/01-netcfg.yaml`

```yaml
network:
  version: 2
  ethernets:
    eth0:
      addresses: [192.168.1.20/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8]
```

Apply:

```bash
sudo netplan apply
```

🧩 **RHEL / CentOS**
`/etc/sysconfig/network-scripts/ifcfg-eth0`

```
BOOTPROTO=none
IPADDR=192.168.1.20
PREFIX=24
GATEWAY=192.168.1.1
DNS1=8.8.8.8
```

💡 **In short**
Use Netplan (Ubuntu), ifcfg files (RHEL), or NetworkManager for static IPs.

---

## Q102: What is NetworkManager and how does it work?

🧠 **Overview**
NetworkManager is a dynamic networking service that manages interfaces, Wi-Fi, routing, DNS, and VPNs.

⚙️ **Features**

* Automatically detects & manages interfaces
* Supports GUI, CLI (`nmcli`), TUI (`nmtui`)
* Integrates with systemd-resolved & netplan

🧩 **Examples**

```bash
nmcli device status
nmcli con show
nmcli con mod eth0 ipv4.addresses 192.168.1.20/24
nmcli con up eth0
```

💡 **In short**
NetworkManager provides easy, dynamic network management on modern distros.

---

## Q103: How do you troubleshoot DNS resolution issues?

🧠 **Overview**
DNS issues cause failures in hostname resolution.

🧩 **Troubleshooting Steps**

```bash
cat /etc/resolv.conf        # check DNS servers
ping google.com             # test resolution
dig google.com              # detailed DNS query
nslookup github.com
systemd-resolve --status    # check systemd-resolved (Ubuntu)
```

⚙️ **Common fixes**

* Wrong DNS server → update resolv.conf or NetworkManager
* Firewall blocking 53
* systemd-resolved misconfiguration

💡 **In short**
Use dig/nslookup, verify `/etc/resolv.conf`, test connectivity.

---

## Q104: What is the purpose of /etc/resolv.conf?

🧠 **Overview**
`/etc/resolv.conf` defines DNS servers for name resolution.

🧩 **Typical Entry**

```
nameserver 8.8.8.8
nameserver 1.1.1.1
search example.com
```

💡 **In short**
resolv.conf = system DNS configuration file.

---

## Q105: How do you check network connectivity using ping and traceroute?

🧠 **Overview**
Used to validate connectivity and identify routing issues.

🧩 **Examples**

```bash
ping google.com              # DNS + ICMP connectivity
ping -c 5 8.8.8.8            # test raw network reachability

traceroute google.com        # trace network hops
tracepath google.com         # alternative to traceroute
```

💡 **In short**
ping checks host reachability; traceroute identifies network path & failures.

---

## Q106: What is the purpose of netstat and ss commands?

🧠 **Overview**
Both show network connections, listening ports, and socket statistics.

📋 **Comparison**

| Command     | Status             | Features                        |
| ----------- | ------------------ | ------------------------------- |
| **netstat** | Deprecated         | Older tool for sockets, routing |
| **ss**      | Modern replacement | Faster, more detailed output    |

🧩 **Examples**

```bash
ss -tulpn        # listening TCP/UDP ports
ss -an           # all sockets
netstat -tulpn   # legacy equivalent
```

💡 **In short**
`ss` is the modern, faster alternative to `netstat` for socket inspection.

---

## Q107: How do you identify which process is using a specific port?

🧠 **Overview**
Used during debugging when ports are blocked, already in use, or conflicting.

🧩 **Commands**

```bash
sudo ss -tulpn | grep :8080
sudo lsof -i :8080
```

📋 **Output Shows**

* PID
* Program name
* Protocol
* Listening state

💡 **In short**
Use `ss -tulpn` or `lsof -i` to find the process bound to a port.

---

## Q108: What is the difference between TCP and UDP at the Linux level?

📋 **Comparison Table**

| Feature         | TCP                       | UDP                   |
| --------------- | ------------------------- | --------------------- |
| Type            | Connection-oriented       | Connectionless        |
| Reliability     | Guaranteed delivery       | No delivery guarantee |
| Speed           | Slower                    | Faster                |
| Use Cases       | HTTP, SSH, FTP            | DNS, DHCP, VoIP       |
| Kernel Handling | Maintains state (SYN/ACK) | Stateless             |

💡 **In short**
TCP = reliable & stateful; UDP = lightweight & stateless.

---

## Q109: How do you capture network packets using tcpdump?

🧠 **Overview**
`tcpdump` captures and inspects raw network packets—useful for debugging connectivity, DNS, TLS, and routing.

🧩 **Examples**

```bash
sudo tcpdump -i eth0
sudo tcpdump -i eth0 port 80
sudo tcpdump -w capture.pcap
sudo tcpdump -nnvvXSs 0 -i eth0
```

💡 **In short**
tcpdump = CLI packet capture tool; save to `.pcap` for Wireshark analysis.

---

## Q110: How do you analyze network traffic in Linux?

🧠 **Overview**
Use tools like tcpdump, tshark, iptraf, ss, and Wireshark.

🧩 **Examples**

```bash
sudo tcpdump -r capture.pcap
sudo tshark -i eth0
sudo iptraf-ng
sudo ss -tup
```

💡 **In short**
Capture with tcpdump → analyze with tshark or Wireshark.

---

## Q111: What are environment variables and how do you set them?

🧠 **Overview**
Environment variables store configuration values for shell sessions and applications.

🧩 **Set Temporarily**

```bash
export APP_ENV=prod
echo $APP_ENV
```

🧩 **Unset**

```bash
unset APP_ENV
```

💡 **In short**
Environment variables = dynamic shell configuration values.

---

## Q112: What is the difference between .bashrc and .bash_profile?

📋 **Comparison**

| File                | Used For           | When Loaded        |
| ------------------- | ------------------ | ------------------ |
| **~/.bashrc**       | Interactive shells | Every new terminal |
| **~/.bash_profile** | Login shells       | On user login      |

💡 **In short**
`.bashrc` = terminal settings; `.bash_profile` = login initialization.

---

## Q113: How do you make environment variables persistent?

🧠 **Overview**
Persistent variables must be stored in shell startup files.

🧩 **Add to .bashrc or .bash_profile**

```bash
echo 'export PATH=$PATH:/opt/bin' >> ~/.bashrc
echo 'export APP_ENV=prod' >> ~/.bash_profile
```

🧩 **System-wide**

```bash
/etc/environment
/etc/profile
```

💡 **In short**
Add export statements to `.bashrc`, `.bash_profile`, or `/etc/environment`.

---

## Q114: What is the PATH variable and how does it work?

🧠 **Overview**
`PATH` defines where the shell searches for executables.

🧩 **Check PATH**

```bash
echo $PATH
```

🧩 **Add a new path**

```bash
export PATH=$PATH:/opt/tools
```

⚙️ **How It Works**
Shell searches directories in PATH sequentially when you run a command.

💡 **In short**
PATH = directory list for command lookup.

---

## Q115: How do you compile and install software from source?

🧠 **Overview**
Source builds are used for custom versions or software not in package repositories.

🧩 **Steps**

```bash
tar -xvf source.tar.gz
cd source/
./configure
make
sudo make install
```

🧩 **Optional: Uninstall**

```bash
sudo make uninstall
```

💡 **In short**
Configure → compile → install using `make`.

---

## Q116: What is the difference between apt, yum, and dnf package managers?

📋 **Comparison Table**

| Manager | Distros                | Features                                        |
| ------- | ---------------------- | ----------------------------------------------- |
| **apt** | Debian/Ubuntu          | Fast, dependency resolver, PPA support          |
| **yum** | Older RHEL/CentOS      | Deprecated, replaced by dnf                     |
| **dnf** | New RHEL/CentOS/Fedora | Faster resolver, modular repos, better handling |

💡 **In short**
apt = Debian-based; yum/dnf = RHEL-based; dnf is the modern replacement for yum.

---

## Q117: How do you search for packages using package managers?

🧠 **Overview**

🧩 **apt**

```bash
apt search nginx
```

🧩 **yum/dnf**

```bash
yum search nginx
dnf search nginx
```

🧩 **pacman**

```bash
pacman -Ss nginx
```

💡 **In short**
Use `search` with the relevant package manager.

---

## Q118: How do you update all packages on a Linux system?

🧩 **apt**

```bash
sudo apt update
sudo apt upgrade -y
```

🧩 **yum/dnf**

```bash
sudo yum update -y
sudo dnf upgrade -y
```

🧩 **Arch Linux**

```bash
sudo pacman -Syu
```

💡 **In short**
Update metadata → upgrade packages.

---

## Q119: What are package repositories and how do you add them?

🧠 **Overview**
Repositories store software packages for installation.

📋 **Types**

* Official repos
* Third-party repos (EPEL, PPAs)
* Local repositories

🧩 **Add Repo (APT PPA)**

```bash
sudo add-apt-repository ppa:nginx/stable
sudo apt update
```

🧩 **Add Repo (YUM/DNF)**

```bash
sudo yum-config-manager --add-repo=http://repo.example.com/repo.repo
```

💡 **In short**
Repos = package sources; added via repo files or tools like `add-apt-repository` or `yum-config-manager`.

---

## Q120: How do you resolve package dependency conflicts?

🧠 **Overview**
Dependency conflicts occur when packages require incompatible versions.

🧩 **Troubleshooting Steps**

1. **Check broken dependencies**

```bash
sudo apt --fix-broken install
```

2. **Remove conflicting packages**

```bash
sudo apt remove <pkg>
```

3. **Force reinstall**

```bash
sudo apt install -f
```

4. **Clean metadata**

```bash
sudo apt clean
sudo yum clean all
```

5. **Enable correct repos / disable conflicting ones**

💡 **In short**
Fix broken packages → clean caches → reinstall → adjust repositories.

---

# Advanced Questions

## Q121: How does the Linux boot process work from BIOS/UEFI to login prompt?

🧠 **Overview**
The Linux boot sequence is a multi-stage pipeline that initializes hardware, loads the kernel, mounts the root filesystem, and starts system services.

⚙️ **Boot Flow**

1. **BIOS/UEFI** → Performs POST, initializes hardware, selects boot device.
2. **Bootloader (GRUB)** → Loads kernel + initramfs into memory.
3. **Kernel Initialization**

   * Detects hardware
   * Mounts initramfs
   * Starts `/sbin/init` (systemd)
4. **init/systemd**

   * Mounts root filesystem
   * Starts services
   * Reaches default target (multi-user/graphical)
5. **Login Prompt** → Provided by getty (console) or display manager.

💡 **In short**
BIOS → GRUB → Kernel → init/systemd → Login.

---

## Q122: What is the role of GRUB in the boot process?

🧠 **Overview**
GRUB (GRand Unified Bootloader) loads the kernel and initial RAM filesystem.

⚙️ **Responsibilities**

* Present boot menu
* Load Linux kernel (`vmlinuz`)
* Load initramfs
* Pass kernel parameters
* Boot different OSes (multiboot)

🧩 **Config File**

```
/etc/default/grub
```

🧩 **Apply Changes**

```bash
sudo update-grub
```

💡 **In short**
GRUB selects and loads the kernel + initramfs.

---

## Q123: How do you troubleshoot and recover from a failed boot?

🧠 **Overview**
Boot failures come from GRUB issues, kernel problems, or filesystem corruption.

🧩 **Steps**

1. **Access GRUB menu**

   * Edit kernel boot params (press `e`)
   * Add `systemd.unit=multi-user.target` or `single`

2. **Boot into rescue mode**

```bash
systemctl rescue
systemctl emergency
```

3. **Fix filesystem**

```bash
fsck /dev/sda1
```

4. **Reinstall GRUB**

```bash
grub-install /dev/sda
update-grub
```

5. **Check broken services**

```bash
systemctl --failed
journalctl -b -1
```

💡 **In short**
Use GRUB rescue, single-user mode, fsck, and GRUB reinstall to fix boot failures.

---

## Q124: What is initramfs and why is it needed?

🧠 **Overview**
`initramfs` is a temporary root filesystem stored in memory during boot.

⚙️ **Purpose**

* Contains drivers needed before real root filesystem mounts
* Initializes storage: LVM, RAID, encrypted disks
* Loads kernel modules
* Hands control to main OS root filesystem

📍 **Location**

```
/boot/initramfs-<kernel>.img
```

💡 **In short**
initramfs = pre-root filesystem used for hardware initialization.

---

## Q125: How do you customize the kernel boot parameters?

🧠 **Overview**
Kernel parameters control kernel behavior (memory, tuning, debug options).

🧩 **Edit GRUB**
Edit:

```
/etc/default/grub
```

Example:

```
GRUB_CMDLINE_LINUX="quiet splash intel_iommu=on"
```

Apply:

```bash
sudo update-grub
```

🧩 **Temporary Edit**

* At GRUB menu → press `e` → edit kernel line → boot.

💡 **In short**
Edit GRUB → modify GRUB_CMDLINE_LINUX → update-grub.

---

## Q126: What are kernel modules and how do you manage them?

🧠 **Overview**
Kernel modules are loadable components (drivers) that extend kernel functionality without reboot.

⚙️ **Examples**

* Filesystem drivers (xfs, ext4)
* Networking drivers (e1000, igb)
* Firewall modules (ip_tables, nf_conntrack)

🧩 **List Modules**

```bash
lsmod
```

🧩 **Module Info**

```bash
modinfo <module>
```

💡 **In short**
Modules = on-demand kernel extensions (drivers, features).

---

## Q127: How do you load and unload kernel modules dynamically?

🧠 **Overview**

🧩 **Load Module**

```bash
sudo modprobe <module>
```

🧩 **Unload Module**

```bash
sudo modprobe -r <module>
```

🧩 **Insert/Remove Raw Module**

```bash
sudo insmod module.ko
sudo rmmod module
```

⚠️ **Caution**
Cannot remove modules in use → check with:

```bash
lsmod
```

💡 **In short**
Use `modprobe` to load/unload modules with dependency handling.

---

## Q128: How would you compile a custom Linux kernel?

🧠 **Overview**
Custom kernels are used for performance tuning, debugging, or adding specific hardware support.

🧩 **Steps**

```bash
sudo apt-get build-dep linux
wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.1.tar.xz
tar -xf linux-6.1.tar.xz
cd linux-6.1
make menuconfig           # customize options
make -j $(nproc)          # compile
sudo make modules_install
sudo make install
sudo update-grub
```

💡 **In short**
Download → configure → compile → install → update GRUB.

---

## Q129: What kernel parameters would you tune for performance optimization?

🧠 **Overview**
Kernel tuning depends on workload: networking, memory, IO, and process management.

📋 **Common Parameters**

| Area             | Parameter                        | Purpose                |
| ---------------- | -------------------------------- | ---------------------- |
| Memory           | `vm.swappiness`                  | Swap behavior          |
| Memory           | `vm.dirty_ratio`                 | Writeback tuning       |
| Networking       | `net.core.somaxconn`             | Max connection backlog |
| Networking       | `net.ipv4.tcp_fin_timeout`       | TCP cleanup speed      |
| File Descriptors | `fs.file-max`                    | Max open files         |
| Kernel Threads   | `kernel.sched_migration_cost_ns` | Scheduler tuning       |

🧩 **Apply Temporary**

```bash
sysctl -w net.core.somaxconn=65535
```

🧩 **Permanent**

```
/etc/sysctl.conf
```

💡 **In short**
Use sysctl to tune memory, IO, and network performance.

---

## Q130: How does the Linux scheduler work?

🧠 **Overview**
Linux uses the **Completely Fair Scheduler (CFS)** to allocate CPU time fairly across processes.

⚙️ **CFS Concepts**

* Each process gets “virtual runtime.”
* Processes with lower runtime get CPU first.
* Load balancing happens across CPU cores.
* Priorities via *nice* values influence scheduling.

🧩 **View Scheduling Stats**

```bash
cat /proc/sched_debug
```

💡 **In short**
Linux scheduler ensures fair CPU distribution using CFS + priorities.

---

## Q131: What scheduling policies are available in Linux (CFS, real-time)?

🧠 **Overview**
Linux supports multiple scheduling classes, each designed for different workloads.

📋 **Scheduling Policies**

| Policy                | Type            | Description                               |
| --------------------- | --------------- | ----------------------------------------- |
| **CFS (SCHED_OTHER)** | Default         | Fair CPU sharing using virtual runtime    |
| **SCHED_BATCH**       | Non-interactive | For background jobs; low responsiveness   |
| **SCHED_IDLE**        | Lowest priority | Runs only when system idle                |
| **SCHED_FIFO**        | Real-time       | First-in-first-out, strict priority       |
| **SCHED_RR**          | Real-time       | Round-robin among equal-priority RT tasks |

💡 **In short**
CFS for normal tasks, FIFO/RR for real-time tasks requiring deadlines.

---

## Q132: How do you set process priorities using nice and renice?

🧠 **Overview**
nice/renice adjust a process’s “niceness,” affecting how often it gets CPU time.

📋 **Range**

* Nice values: **-20 (highest priority) to +19 (lowest)**

🧩 **Start Process with Nice Value**

```bash
nice -n 10 ./script.sh
```

🧩 **Change Priority of Running Process**

```bash
renice -n -5 -p 1234
```

💡 **In short**
Use `nice` to start with priority; `renice` to modify running processes.

---

## Q133: What is CPU affinity and how do you configure it?

🧠 **Overview**
CPU affinity binds a process to specific CPU cores to improve cache locality or limit CPU usage.

🧩 **Set CPU Affinity**

```bash
taskset -c 0,2 my_app
```

🧩 **Modify Running Process**

```bash
taskset -cp 0 1234
```

💡 **In short**
CPU affinity assigns processes to specific cores via `taskset`.

---

## Q134: How does Linux handle memory management?

🧠 **Overview**
Linux manages memory using paging, caching, swapping, and the buddy allocator.

⚙️ **Components**

* **Page Cache** → speeds up disk reads/writes
* **Virtual Memory** → abstraction of memory space
* **Swap** → overflow area
* **OOM Killer** → handles memory exhaustion
* **cgroups** → enforce memory limits

💡 **In short**
Linux balances RAM between processes, cache, and swap through virtual memory.

---

## Q135: What is the difference between virtual and physical memory?

📋 **Comparison Table**

| Memory Type         | Meaning                                    |
| ------------------- | ------------------------------------------ |
| **Physical Memory** | Actual RAM chips                           |
| **Virtual Memory**  | Logical address space mapped to RAM + swap |

🧠 **Key Point**
Processes think they have continuous memory, but the kernel maps it to real RAM pages.

💡 **In short**
Virtual memory = abstraction; physical memory = real hardware.

---

## Q136: How does the OOM (Out of Memory) killer work?

🧠 **Overview**
When memory + swap are exhausted, OOM-killer terminates processes to prevent a system freeze.

⚙️ **How It Chooses Process**

* Badness score based on memory usage, priority, oom_score_adj
* Prefers killing the largest memory consumers
* Logs actions in `/var/log/syslog` or `dmesg`

💡 **In short**
OOM kills processes when RAM is exhausted to keep system alive.

---

## Q137: How do you tune OOM killer behavior?

🧠 **Overview**
Control OOM selection using **oom_score_adj** per process.

🧩 **Check badness score**

```bash
cat /proc/<pid>/oom_score
cat /proc/<pid>/oom_score_adj
```

🧩 **Increase or Decrease OOM Likelihood**

```bash
echo -500 > /proc/<pid>/oom_score_adj   # protect
echo 500 > /proc/<pid>/oom_score_adj    # target for kill
```

💡 **In short**
Use `oom_score_adj` to make processes more protected or more killable.

---

## Q138: What is memory overcommitment in Linux?

🧠 **Overview**
The kernel can allow processes to allocate more memory than physically available.

⚙️ **Modes**

```
vm.overcommit_memory = 0  # heuristic
vm.overcommit_memory = 1  # always allow
vm.overcommit_memory = 2  # strict (no overcommit)
```

💡 **In short**
Overcommit allows memory allocations beyond RAM, risking OOM.

---

## Q139: How do you analyze memory usage at a granular level?

🧠 **Overview**
Use tools that show per-process, per-page, or per-cgroup memory usage.

🧩 **Commands**

```bash
top, htop
ps aux --sort=-%mem
smem -r
cat /proc/meminfo
cat /proc/<pid>/smaps
```

💡 **In short**
Use `/proc/<pid>` and smem for deep memory insights.

---

## Q140: What tools would you use for memory profiling (valgrind, perf)?

🧠 **Overview**
Memory profiling helps detect leaks, fragmentation, and inefficient allocations.

📋 **Tools**

| Tool                    | Purpose                        |
| ----------------------- | ------------------------------ |
| **valgrind (memcheck)** | Detect leaks, invalid accesses |
| **perf**                | CPU + memory performance       |
| **gperf/gperftools**    | Heap profiling                 |
| **strace**              | Syscall tracing                |
| **massif (valgrind)**   | Heap memory usage breakdown    |

🧩 **Example**

```bash
valgrind --leak-check=full ./app
```

💡 **In short**
valgrind for correctness; perf for performance; massif/gperftools for heap profiling.

---

## Q141: How does Linux handle I/O scheduling?

🧠 **Overview**
I/O scheduling determines how read/write operations are prioritized to block devices.

⚙️ **Goals**

* Reduce seek time
* Improve throughput
* Fairness among processes

💡 **In short**
Linux uses schedulers to optimize disk operations for different workloads.

---

## Q142: What I/O schedulers are available (noop, deadline, cfq, mq-deadline)?

📋 **I/O Schedulers**

| Scheduler       | Best For                    | Notes                            |
| --------------- | --------------------------- | -------------------------------- |
| **noop**        | SSDs                        | Minimal scheduling; FIFO         |
| **deadline**    | Latency-sensitive workloads | Guarantees max wait time         |
| **cfq**         | General workloads           | Fair-sharing (deprecated)        |
| **mq-deadline** | NVMe high-speed devices     | Multi-queue optimized            |
| **none**        | NVMe                        | No scheduling; device handles it |

💡 **In short**
SSD/NVMe → noop/none/mq-deadline; HDD → deadline.

---

## Q143: How do you tune I/O scheduler for different workloads?

🧠 **Overview**
Change scheduler by writing to the device’s scheduler file.

🧩 **Check Available Schedulers**

```bash
cat /sys/block/sda/queue/scheduler
```

🧩 **Set Scheduler**

```bash
echo deadline | sudo tee /sys/block/sda/queue/scheduler
```

💡 **In short**
Choose deadline for latency, noop for SSDs, mq-deadline for NVMe.

---

## Q144: What is direct I/O and when would you use it?

🧠 **Overview**
Direct I/O bypasses the OS page cache and reads/writes directly to disk.

📋 **Use Cases**

* Databases (PostgreSQL, Oracle)
* Applications doing their own caching
* Benchmarking raw disk performance

💡 **In short**
Direct I/O = bypass page cache for predictable performance.

---

## Q145: How do you measure and optimize disk I/O performance?

🧠 **Overview**
Use benchmarking tools and tune kernel + filesystem parameters.

🧩 **Tools**

```bash
fio       # synthetic testing
iostat    # per-device stats
vmstat
dstat
```

🧩 **Optimization Areas**

* Choose right I/O scheduler
* Tune read-ahead:

```bash
echo 4096 | sudo tee /sys/block/sda/queue/read_ahead_kb
```

* Use LVM striping or RAID

💡 **In short**
Measure with fio/iostat → tune scheduler, readahead, RAID/LVM layout.

---

## Q146: What is the purpose of the iostat command?

🧠 **Overview**
`iostat` reports CPU + block device I/O stats.

🧩 **Example**

```bash
iostat -xz 1
```

📋 **Key Metrics**

* `r/s`, `w/s` → read/write operations
* `await` → average wait time
* `%util` → device saturation

💡 **In short**
iostat = detailed I/O performance + bottleneck indicator.

---

## Q147: How do you identify I/O bottlenecks in Linux?

🧠 **Overview**
Use performance metrics from iostat, vmstat, pidstat, and sar.

🧩 **Checklist**

1. High disk utilization

```bash
iostat -xz 1 | grep -v idle
```

2. Long I/O wait times (`iowait`)

```bash
vmstat 1
```

3. Process-level I/O

```bash
pidstat -d 1
```

4. Kernel dmesg errors (I/O, blocks)

```bash
dmesg | grep -i error
```

💡 **In short**
High `%util`, high `await`, and high `iowait` = clear I/O bottlenecks.

---

## Q148: What is the page cache and how does it work?

🧠 **Overview**
The page cache stores recently accessed file data in RAM to speed up disk I/O.

⚙️ **How It Works**

* Reads are served from RAM if cached → fast
* Writes go to cache first → flushed to disk later
* Managed by kernel’s memory manager
* Frees pages automatically when RAM is needed

🧩 **Check Cache Usage**

```bash
grep -i cached /proc/meminfo
```

💡 **In short**
Page cache accelerates I/O by keeping disk-backed data in RAM.

---

## Q149: How do you clear the page cache and when would you do it?

🧠 **Overview**
Clearing cache is mostly for benchmarking—not for normal operations.

🧩 **Commands**

```bash
sync                      # flush dirty pages
echo 1 > /proc/sys/vm/drop_caches    # clear page cache
echo 2 > /proc/sys/vm/drop_caches    # clear dentries/inodes
echo 3 > /proc/sys/vm/drop_caches    # clear everything
```

⚠️ **Use only for**:

* Performance testing
* Debugging memory leaks
* Storage benchmarking

💡 **In short**
Use `drop_caches` only for tests—not in production.

---

## Q150: What is the difference between buffered and direct I/O?

📋 **Comparison Table**

| Type             | Uses Page Cache? | Use Cases                              |
| ---------------- | ---------------- | -------------------------------------- |
| **Buffered I/O** | Yes              | Most applications, general file access |
| **Direct I/O**   | No               | Databases, low-latency workloads       |

🧠 **Explanation**
Buffered I/O leverages kernel cache; direct I/O bypasses the cache and reads/writes to disk directly.

💡 **In short**
Buffered I/O = cached; direct I/O = predictable, uncached.

---

## Q151: How do you implement disk quotas in Linux?

🧠 **Overview**
Disk quotas limit user/group disk usage.

🧩 **Steps**

1. **Enable quotas in fstab**

```
/dev/sda1 /home ext4 defaults,usrquota,grpquota 0 1
```

2. **Remount filesystem**

```bash
mount -o remount /home
```

3. **Create quota database**

```bash
quotacheck -cug /home
quotaon /home
```

4. **Set quota for user**

```bash
edquota username
```

💡 **In short**
Enable quotas → check database → activate → assign limits.

---

## Q152: What are control groups (cgroups) and what are they used for?

🧠 **Overview**
cgroups limit, isolate, and monitor resource usage for processes or containers.

📋 **Resource Control**

* CPU
* Memory
* I/O
* PIDs
* Hugepages

💡 **In short**
cgroups enforce resource limits and isolation.

---

## Q153: How do you configure resource limits using cgroups?

🧩 **Steps (cgroups v1 Example)**

1. **Create cgroup**

```bash
mkdir /sys/fs/cgroup/cpu/mygroup
```

2. **Set CPU limit**

```bash
echo 50000 > /sys/fs/cgroup/cpu/mygroup/cpu.cfs_quota_us
echo 100000 > /sys/fs/cgroup/cpu/mygroup/cpu.cfs_period_us
```

3. **Attach process**

```bash
echo <pid> > /sys/fs/cgroup/cpu/mygroup/tasks
```

💡 **In short**
Create cgroup → set limits → attach process.

---

## Q154: What is the difference between cgroups v1 and v2?

📋 **Comparison Table**

| Aspect            | cgroups v1              | cgroups v2                   |
| ----------------- | ----------------------- | ---------------------------- |
| Hierarchy         | Multiple per controller | Unified                      |
| Controllers       | Independent             | Unified API                  |
| Complexity        | Higher                  | Simpler                      |
| Container engines | Old Docker used v1      | Modern Docker/K8s support v2 |
| Features          | Lacks memory protection | Better memory control        |

💡 **In short**
cgroups v2 unifies all controllers and provides cleaner resource control.

---

## Q155: How do you isolate resources for containers using cgroups?

🧠 **Overview**
Container runtimes (Docker, containerd, CRI-O) automatically create cgroups.

🧩 **Example (Docker limits)**

```bash
docker run --cpus=1 --memory=512m nginx
```

⚙️ **Behind the Scenes**

* Docker creates cgroups
* Moves container processes into them
* Enforces limits via kernel

💡 **In short**
Containers use cgroups to limit CPU, memory, PIDs, I/O.

---

## Q156: What are namespaces in Linux and what types exist?

🧠 **Overview**
Namespaces isolate kernel resources between processes.

📋 **Types of Namespaces**

| Namespace  | Isolates                   |
| ---------- | -------------------------- |
| **PID**    | Process IDs                |
| **NET**    | Network interfaces, routes |
| **UTS**    | Hostname                   |
| **IPC**    | Shared memory              |
| **MNT**    | Filesystems                |
| **USER**   | User IDs                   |
| **CGROUP** | Cgroup hierarchy           |

💡 **In short**
Namespaces provide isolation similar to containers.

---

## Q157: How do namespaces enable container isolation?

🧠 **Overview**
Each container runs inside isolated namespaces, giving it a private view of system resources.

⚙️ **Example**

* PID namespace → container sees its own PID 1
* NET namespace → own virtual NIC
* MNT namespace → own filesystem mounts
* USER namespace → remaps UIDs

💡 **In short**
Namespaces isolate views; cgroups isolate resources.

---

## Q158: How would you implement network isolation using network namespaces?

🧩 **Example: Create isolated namespace**

```bash
ip netns add ns1
```

🧩 **Create veth pair**

```bash
ip link add veth0 type veth peer name veth1
ip link set veth1 netns ns1
```

🧩 **Assign IPs**

```bash
ip addr add 10.0.0.1/24 dev veth0
ip netns exec ns1 ip addr add 10.0.0.2/24 dev veth1
```

🧩 **Bring interfaces up**

```bash
ip link set veth0 up
ip netns exec ns1 ip link set veth1 up
```

💡 **In short**
Use network namespaces + veth pairs to create isolated network stacks.

---

## Q159: What are capabilities in Linux and how do they enhance security?

🧠 **Overview**
Capabilities split root’s privileges into fine-grained permissions, allowing least-privilege operation.

📋 **Examples**

* `CAP_NET_ADMIN` → network config
* `CAP_SYS_ADMIN` → broad system control
* `CAP_CHOWN` → change file ownership

💡 **In short**
Capabilities avoid giving full root privileges.

---

## Q160: How do you assign specific capabilities to processes?

🧩 **Use setcap**

```bash
sudo setcap cap_net_bind_service=+ep /usr/bin/nginx
```

🧩 **Check capabilities**

```bash
getcap /usr/bin/nginx
```

⚙️ **This allows**:
nginx to bind to port 80 without root privilege.

💡 **In short**
setcap grants fine-grained privileges to binaries.

---

## Q161: What is seccomp and how does it restrict system calls?

🧠 **Overview**
seccomp (Secure Computing Mode) filters system calls to reduce attack surface.

📋 **Modes**

* **Strict** → allow only read/write/exit
* **Filter** → custom syscall allow/deny lists

🧩 **Example (Docker)**

```bash
docker run --security-opt seccomp=/path/profile.json nginx
```

💡 **In short**
seccomp blocks dangerous syscalls to harden apps and containers.

---

## Q162: How would you implement a hardened Linux system?

🧠 **Checklist**

* Enforce SELinux/AppArmor
* Use strong password and PAM policies
* Configure auditd
* Restrict SSH (key-only login, disable root login)
* Patch system regularly
* Enable firewall + disable unused services
* Use FDE (LUKS)
* Enforce cgroup limits for workloads
* Use seccomp/capabilities for apps

💡 **In short**
Combine MAC, firewalls, PAM, encryption, and syscall restrictions.

---

## Q163: What security benchmarks would you follow (CIS, STIG)?

📋 **Comparison**

| Benchmark          | Purpose                     | Used By            |
| ------------------ | --------------------------- | ------------------ |
| **CIS Benchmarks** | Hardening best practices    | Enterprises, cloud |
| **DISA STIG**      | Strict government standards | DoD, Fed agencies  |

🧠 **Key Point**
Both provide step-by-step checks for OS & application hardening.

💡 **In short**
Follow CIS for commercial hardening; STIG for regulated environments.

---

## Q164: How do you implement disk encryption using LUKS?

🧩 **Steps**

1. **Install cryptsetup**

```bash
sudo apt install cryptsetup
```

2. **Encrypt disk**

```bash
sudo cryptsetup luksFormat /dev/sdb
```

3. **Open encrypted disk**

```bash
sudo cryptsetup luksOpen /dev/sdb secure_disk
```

4. **Create filesystem**

```bash
mkfs.ext4 /dev/mapper/secure_disk
mount /dev/mapper/secure_disk /secure
```

💡 **In short**
Use cryptsetup luksFormat → luksOpen → create FS → mount.

---

## Q165: What is dm-crypt and how does it relate to LUKS?

🧠 **Overview**
`dm-crypt` is the kernel subsystem providing block-level encryption.

📋 **Relationship**

| Component      | Description                                                  |
| -------------- | ------------------------------------------------------------ |
| **dm-crypt**   | Low-level kernel encryption engine                           |
| **LUKS**       | Standardized metadata + encryption format on top of dm-crypt |
| **cryptsetup** | User tool to manage LUKS/dm-crypt                            |

💡 **In short**
dm-crypt does raw encryption; LUKS adds headers, keyslots, and usability.

---
## Q166: How do you secure SSH access to Linux servers?

🧠 **Overview**

* SSH is the primary remote access method; securing it reduces attack surface and prevents unauthorized access in production systems.

⚙️ **Purpose / How it works**

* Harden the SSH daemon (`sshd`) and authentication methods, restrict accounts/networks, and monitor access to reduce brute-force and credential theft risks.

🧩 **Examples / Commands / Config snippets**

```bash
# Install OpenSSH (Debian/Ubuntu)
sudo apt-get update && sudo apt-get install -y openssh-server

# Basic sshd_config hardening (edit /etc/ssh/sshd_config)
PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
PubkeyAuthentication yes
AllowUsers ec2-user ops@192.0.2.0/24
X11Forwarding no
PermitTunnel no
MaxAuthTries 3
LoginGraceTime 30s
```

```bash
# Reload sshd
sudo systemctl reload sshd
# Add public key
mkdir -p ~/.ssh && chmod 700 ~/.ssh
echo "ssh-rsa AAAA..." >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
```

📋 **Table — Quick controls**

| Control       |                                File/Command | Effect                      |
| ------------- | ------------------------------------------: | --------------------------- |
| Disable root  | `/etc/ssh/sshd_config` `PermitRootLogin no` | Blocks root login           |
| Key-only auth |                 `PasswordAuthentication no` | Requires SSH keys           |
| IP allow      |                        `AllowUsers user@IP` | Limit by user/IP            |
| Fail2ban      |                                  `fail2ban` | Blocks brute-force attempts |

✅ **Best Practices**

* Use key-based auth + passphrase-protected keys + SSH agent forwarding only when necessary.
* Use jump/bastion hosts and `ProxyJump` in `~/.ssh/config`.
* Enforce MFA (see Q168) and centrally manage keys (Vault, AWS SSM).
* Rotate and audit keys regularly; log to central syslog/ELK.
* Use `AllowUsers`/`AllowGroups` and network ACLs.

💡 **In short**
Disable password/root login, require keys, restrict by user/IP, log and rotate keys.

---

## Q167: What SSH hardening techniques would you implement?

🧠 **Overview**

* Hardening is layered: config changes, auth mechanisms, access controls, monitoring, and policy enforcement.

⚙️ **Purpose / How it works**

* Reduce attack vectors (brute-force, stolen creds), limit exposure, and improve detectability.

🧩 **Examples / Commands / Config snippets**

```bash
# /etc/ssh/sshd_config core lines
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
KexAlgorithms curve25519-sha256@libssh.org
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
MACs hmac-sha2-512-etm@openssh.com
AllowUsers ops@203.0.113.10
```

```bash
# Fail2ban basic
sudo apt-get install fail2ban
# /etc/fail2ban/jail.local
[sshd]
enabled = true
maxretry = 5
banaction = iptables-multiport
```

📋 **Table — Techniques & purpose**

| Technique      |         Tool/File | Why                    |
| -------------- | ----------------: | ---------------------- |
| Key-only auth  |       sshd_config | Remove passwords       |
| Strong ciphers |       sshd_config | Protect session crypto |
| Rate-limiting  | fail2ban/iptables | Mitigate brute-force   |
| Bastion hosts  |     SSH ProxyJump | Central control/audit  |
| Key management |         Vault/SSM | Rotate & revoke keys   |
| MFA            |   PAM/Google Auth | Protect credentials    |

✅ **Best Practices**

* Enforce least-privilege, use bastion + MFA, rotate keys, monitor `auth.log`, block suspicious IPs, and enforce compliance via configuration management (Ansible/Terraform).

💡 **In short**
Apply config hardening + network controls + monitoring + key lifecycle management.

---

## Q168: How do you implement two-factor authentication in Linux?

🧠 **Overview**

* Implement 2FA for SSH using a PAM module (time-based one-time password) or hardware tokens to require a second factor during login.

⚙️ **Purpose / How it works**

* Adds TOTP (Google Authenticator/Authenticator apps) or U2F (YubiKey) in addition to SSH keys/passwords via PAM hooks.

🧩 **Examples / Commands / Config snippets**
TOTP (libpam-google-authenticator):

```bash
# Install (Debian/Ubuntu)
sudo apt-get install libpam-google-authenticator

# Per-user setup (run on each account)
google-authenticator

# Edit /etc/pam.d/sshd - add at top:
auth required pam_google_authenticator.so nullok

# Edit /etc/ssh/sshd_config
ChallengeResponseAuthentication yes
AuthenticationMethods publickey,keyboard-interactive

# Reload
sudo systemctl reload sshd
```

U2F (YubiKey):

```bash
# Install pam_u2f and map keys for users in ~/.config/Yubico/u2f_keys
# Add to /etc/pam.d/sshd: auth required pam_u2f.so
```

📋 **Table — 2FA options**

| Method |                   Module |             UX | Use-case            |
| ------ | -----------------------: | -------------: | ------------------- |
| TOTP   | pam_google_authenticator | Mobile app OTP | Easy deploy         |
| U2F    |                  pam_u2f | Hardware touch | Highest security    |
| Duo    |             Duo Unix PAM |    Push or OTP | Enterprise with SSO |

✅ **Best Practices**

* Prefer SSH key + 2FA (AuthenticationMethods publickey,keyboard-interactive).
* Use `nullok` carefully (allows bypass). Enforce for privileged accounts.
* Document recovery/backup codes; use hardware tokens for critical accounts.

💡 **In short**
Add a PAM-based TOTP or U2F layer combined with SSH keys for strong 2FA.

---

## Q169: What is auditd and how do you configure system auditing?

🧠 **Overview**

* `auditd` is the Linux Audit Daemon for recording security-relevant events (syscalls, file access, auth events) to support forensics and compliance.

⚙️ **Purpose / How it works**

* Hooks into kernel audit subsystem; rules specify which events to log; outputs to `/var/log/audit/audit.log`.

🧩 **Examples / Commands / Config snippets**

```bash
# Install
sudo apt-get install auditd audispd-plugins

# Start/enable
sudo systemctl enable --now auditd

# Add simple rule: watch /etc/passwd
sudo auditctl -w /etc/passwd -p wa -k passwd_changes

# Persist rule (Debian): add to /etc/audit/rules.d/audit.rules
-w /etc/passwd -p wa -k passwd_changes

# Audit syscall (execve)
-a always,exit -F arch=b64 -S execve -k exec_calls
```

```bash
# Search audit log using ausearch
ausearch -k passwd_changes
# Generate report with aureport
aureport --summary
```

📋 **Table — Common rules**

| Rule                                           | Meaning                        |
| ---------------------------------------------- | ------------------------------ |
| `-w /etc/shadow -p wa -k shadow`               | Watch modifications/attributes |
| `-a always,exit -F arch=b64 -S execve -k exec` | Log executed binaries          |
| `-w /var/log/auth.log -p r -k auth_logs`       | Read access to auth logs       |

✅ **Best Practices**

* Log minimal necessary events to avoid overload; focus on auth, privileged file changes, execs, and network binds.
* Forward audit logs to a centralized collector and use immutable storage for compliance.
* Monitor with alerting (SIEM) for suspicious patterns.

💡 **In short**
`auditd` captures kernel-level security events — configure rules, persist them, and centralize logs for analysis.

---

## Q170: How do you track and investigate security events using audit logs?

🧠 **Overview**

* Use audit logs for incident detection, root-cause analysis, and compliance: search, correlate, and reconstruct attacker actions.

⚙️ **Purpose / How it works**

* Collect logs (auditd), parse (ausearch/auparse), enrich (user, process, network), and forward to SIEM for correlation and alerts.

🧩 **Examples / Commands / Config snippets**

```bash
# Find executions by a user
ausearch -ua alice -k exec_calls

# Show recent failed sudo attempts
ausearch -m USER_AUTH -sv no

# Convert to readable form
ausearch -k passwd_changes -i
# Generate summary for timeframe
aureport --start today --end now --summary
```

Workflow:

1. Pull relevant events (auth, exec, file write).
2. Correlate with system logs (/var/log/auth.log, syslog).
3. Check process tree (`ps -ef --forest`) and binary hashes.
4. Isolate host, collect forensic image if needed.

📋 **Table — Investigation steps**

| Step          |           Command / Tool | Output            |
| ------------- | -----------------------: | ----------------- |
| Search events |      `ausearch -k <key>` | Raw audit entries |
| Decode        | `aureport / ausearch -i` | Human-readable    |
| Correlate     |       syslog + auth logs | Timeline          |
| Forensics     |  `ps`, `lsof`, `netstat` | Live indicators   |

✅ **Best Practices**

* Timestamp-sync all hosts (NTP), centralize logs to SIEM, define alert rules (e.g., exec of suspicious binaries), and maintain retention policies for investigations.

💡 **In short**
Query auditd with `ausearch`/`aureport`, correlate logs, and follow a forensic workflow to investigate incidents.

---

## Q171: How would you implement centralized logging for multiple Linux servers?

🧠 **Overview**

* Centralized logging collects logs from many servers to a central store (ELK/EFK, Splunk, Loki) for search, alerting, and retention.

⚙️ **Purpose / How it works**

* Agents (rsyslog, Filebeat, Fluentd) forward logs over TLS to collectors; data gets indexed, visualized, and alerted on.

🧩 **Examples / Commands / Config snippets**
Filebeat → Elasticsearch:

```yaml
# filebeat.yml (agent on hosts)
filebeat.inputs:
- type: log
  paths: ["/var/log/syslog","/var/log/auth.log","/var/log/myapp/*.log"]
output.elasticsearch:
  hosts: ["https://es-cluster.example:9200"]
  username: "beat_user"
  password: "secure"
  ssl.certificate_authorities: ["/etc/ssl/ca.crt"]
```

rsyslog TLS forwarding:

```conf
# /etc/rsyslog.d/50-forward.conf
$DefaultNetstreamDriverCAFile /etc/pki/tls/certs/ca.pem
$ActionSendStreamDriver gtls
*.* @@logserver.example:6514;RSYSLOG_SyslogProtocol23Format
```

📋 **Table — Agent choices**

| Agent    |            Use-case | Notes                     |
| -------- | ------------------: | ------------------------- |
| Filebeat | File log forwarding | Lightweight, ECS modules  |
| Fluentd  |     Complex parsing | Many plugins              |
| rsyslog  |   Syslog forwarding | Native syslog integration |

✅ **Best Practices**

* Transport logs over TLS, authenticate agents, filter at source to reduce noise, index meaningful fields, and enforce retention/archival.
* Use structured logging (JSON) for app logs.
* Tag logs with host/application metadata (labels).

💡 **In short**
Deploy agents (Filebeat/rsyslog/Fluentd) on hosts, forward logs securely to central indexer (ELK/Loki/Splunk), and alert from SIEM.

---

## Q172: What is rsyslog and how does it differ from syslog-ng?

🧠 **Overview**

* Both `rsyslog` and `syslog-ng` are syslog implementations for collecting and forwarding logs; each offers different features and ecosystems.

⚙️ **Purpose / How it works**

* They read local syslog input, apply filters/transformations, and output to files, remote servers, databases, or message queues.

🧩 **Examples / Commands / Config snippets**
rsyslog TLS forward example (see Q171).
syslog-ng config snippet:

```conf
source s_sys { system(); internal(); };
destination d_network { tcp("logserver.example" port(514) tls( ca-dir("/etc/pki/tls/certs"))); };
log { source(s_sys); destination(d_network); };
```

📋 **Table — rsyslog vs syslog-ng**

| Feature            |                        rsyslog | syslog-ng                             |
| ------------------ | -----------------------------: | ------------------------------------- |
| Performance        |          High (multi-threaded) | High                                  |
| Config syntax      |          Legacy + RainerScript | More declarative                      |
| Modules/plugins    | Many (omgrok, omelasticsearch) | Many (parsers, transports)            |
| Structured logging |        Supports JSON templates | Strong structured logging support     |
| Community          |     Widely used in RHEL/Ubuntu | Preferred in some distros/enterprises |

✅ **Best Practices**

* Choose based on existing environment, required outputs, and team familiarity. Use TLS, structured logging templates, and central parsers.

💡 **In short**
Both are capable syslog daemons; choose `rsyslog` for wide distro defaults and `syslog-ng` when you prefer its config style or parsers.

---

## Q173: How do you configure high availability Linux clusters?

🧠 **Overview**

* HA clusters coordinate multiple nodes to provide failover of services (IP, services, storage) to minimize downtime.

⚙️ **Purpose / How it works**

* Use cluster manager (Pacemaker/Corosync) to monitor resources and orchestrate failover; shared storage for data consistency; fencing to split nodes.

🧩 **Examples / Commands / Config snippets**
Basic Pacemaker + Corosync bootstrap:

```bash
# Install
sudo apt-get install pacemaker corosync

# Corosync conf: /etc/corosync/corosync.conf (multicast or unicast)
# Start services
sudo systemctl enable --now corosync pacemaker

# Create a primitive (example: IP)
pcs resource create vip ocf:heartbeat:IPaddr2 ip=10.0.0.100 cidr_netmask=24 op monitor interval=30s
```

(Or use `pcs` on RHEL-family: `pcs cluster setup --name mycluster node1 node2`)

📋 **Table — Components**

| Component       | Role                         |
| --------------- | ---------------------------- |
| Corosync        | Messaging & membership       |
| Pacemaker       | Resource manager             |
| STONITH/Fencing | Force-node isolation         |
| Shared storage  | Data availability (NFS/DRBD) |

✅ **Best Practices**

* Implement fencing (STONITH), quorum awareness, split-brain prevention, and test failover. Automate config via Ansible/Terraform. Monitor cluster health and logs.

💡 **In short**
Use Corosync + Pacemaker, shared storage, and fencing to provide robust service failover.

---

## Q174: What is Pacemaker and how does it manage cluster resources?

🧠 **Overview**

* Pacemaker is a cluster resource manager that enforces policies to start/stop/move resources across nodes based on health and constraints.

⚙️ **Purpose / How it works**

* It maintains desired state: primitives (services, IPs), groups, constraints (location, colocation, order) and monitors resources with agents (OCF/LRM).

🧩 **Examples / Commands / Config snippets**

```bash
# Create a resource (RHEL/CentOS with pcs)
pcs resource create apache ocf:heartbeat:apache configfile=/etc/httpd/conf/httpd.conf op monitor interval=30s

# Colocation constraint: ensure VIP and apache on same node
pcs constraint colocation add apache with vip INFINITY

# Show status
pcs status
```

📋 **Table — Resource types**

| Type       |                 Example | Use                       |
| ---------- | ----------------------: | ------------------------- |
| Primitive  |         IPaddr2, apache | Single resource           |
| Group      |                DB + VIP | Start/stop order together |
| Clone      | HAProxy (active/active) | Run on multiple nodes     |
| Constraint |         location, order | Control placement         |

✅ **Best Practices**

* Use appropriate monitor intervals, set failure-timeouts, test resource scripts, and use STONITH for safe failover.

💡 **In short**
Pacemaker enforces resource state with primitives, groups, clones, and constraints, reacting to node/resource failures.

---

## Q175: How do you implement shared storage for HA clusters?

🧠 **Overview**

* Shared storage lets multiple nodes access the same data: implemented via NFS, clustered filesystems (GFS2, OCFS2), or block replication (DRBD) plus fencing.

⚙️ **Purpose / How it works**

* Choice depends on workload: NFS for simplicity, clustered FS for simultaneous multi-writer, DRBD for block-level replication with failover.

🧩 **Examples / Commands / Config snippets**
NFS server:

```bash
# Export /srv/data
echo "/srv/data 10.0.0.0/24(rw,sync,no_root_squash)" >> /etc/exports
exportfs -rav
```

DRBD + GFS2 pattern (simplified):

```bash
# Install drbd-utils, configure /etc/drbd.d/resource.res
# Create filesystem on promoted node (when primary)
drbdadm create-md r0
drbdadm up r0
drbdadm primary --force r0
mkfs.gfs2 -p lock_dlm -t mycluster:fsname /dev/drbd0
mount -t gfs2 /dev/drbd0 /mnt/cluster
```

📋 **Table — Shared storage options**

| Option            |           Writer model | Use-case                    |
| ----------------- | ---------------------: | --------------------------- |
| NFS               | Single/multi via locks | Simple shared data          |
| DRBD + FS         |   Active/Passive block | Replicated block devices    |
| GFS2/OCFS2        |          Active/Active | Clustered concurrent access |
| Object store (S3) |                  Multi | Stateless app data          |

✅ **Best Practices**

* Use fencing, quorum, and clustered locks for multi-writer filesystems. Prefer object storage for scale-out apps. Test failover and consistent mounts.

💡 **In short**
Select NFS/DRBD/clustered FS per access patterns; always combine with fencing and HA cluster management.

---

## Q176: What is split-brain in clustering and how do you prevent it?

🧠 **Overview**

* Split-brain occurs when cluster nodes lose communication but each believes it should be primary, causing data divergence or dual-active services.

⚙️ **Purpose / How it works**

* Happens due to network partition or quorum loss; prevention requires fencing, quorum devices, and tie-breakers.

🧩 **Examples / Commands / Config snippets**
Preventive measures:

```bash
# Configure STONITH (example with fence_ipmilan)
pcs stonith create fence1 fence_ipmilan pcmk_host_list="node1,node2" ipaddr="1.2.3.4" ...
# Use quorum device or set no-quorum-policy:
pcs property set no-quorum-policy=stop
```

📋 **Table — Prevention techniques**

| Technique            | Effect                                 |
| -------------------- | -------------------------------------- |
| STONITH fencing      | Forcefully isolates failed node        |
| Quorum               | Ensures majority decision              |
| Tie-breaker          | External witness (QDevice)             |
| Network redundancy   | Reduce partitions                      |
| Resource constraints | Prevent dual-active resource placement |

✅ **Best Practices**

* Always configure STONITH and proper quorum policy (`stop`), use redundant cluster networks, and test failure scenarios in staging.

💡 **In short**
Split-brain is dual-primary due to partitioning — prevent with fencing, quorum, and network redundancy.

---

## Q177: How do you configure load balancing at the Linux level?

🧠 **Overview**

* Linux-level load balancing uses software (HAProxy, Nginx, ipvs, LVS) or kernel features to distribute traffic across backends.

⚙️ **Purpose / How it works**

* Receive client traffic on a front-end, apply balancing algorithm, and forward to backends; can be L4 (ipvs/LVS) or L7 (HAProxy/nginx).

🧩 **Examples / Commands / Config snippets**
HAProxy minimal config:

```haproxy
global
  daemon
defaults
  mode http
  timeout connect 5s
frontend http-in
  bind *:80
  default_backend web-backends
backend web-backends
  balance roundrobin
  server web1 10.0.0.11:80 check
  server web2 10.0.0.12:80 check
```

LVS via `ipvsadm`:

```bash
# Add virtual service
sudo ipvsadm -A -t 10.0.0.100:80 -s rr
# Add real servers
sudo ipvsadm -a -t 10.0.0.100:80 -r 10.0.0.11:80 -m
sudo ipvsadm -a -t 10.0.0.100:80 -r 10.0.0.12:80 -m
```

📋 **Table — LB options**

| Tool       |              Layer |      Perf | Use-case                 |
| ---------- | -----------------: | --------: | ------------------------ |
| HAProxy    |              L4/L7 |      High | HTTP/HTTPS routing       |
| Nginx      |                 L7 |      High | Reverse proxy + caching  |
| LVS/ipvs   |                 L4 | Very high | Kernel-level forwarding  |
| Keepalived | HA for virtual IPs |       N/A | VRRP failover (see Q178) |

✅ **Best Practices**

* Health checks, SSL termination, sticky sessions only when needed, metrics/exporters, and scale LBs horizontally. Use ipvs for very high throughput.

💡 **In short**
Use HAProxy/Nginx for L7, LVS/ipvs for L4 kernel-level performance, and combine with VRRP for HA.

---

## Q178: What is keepalived and how does it implement VRRP?

🧠 **Overview**

* `keepalived` provides HA by managing virtual IPs using VRRP and optionally performs health checks to failover services.

⚙️ **Purpose / How it works**

* VRRP elects a master for a virtual IP; keepalived runs on nodes, advertises priority, and moves VIP to backup on failure.

🧩 **Examples / Commands / Config snippets**
`/etc/keepalived/keepalived.conf`:

```conf
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication { auth_type PASS; auth_pass secret }
    virtual_ipaddress {
        10.0.0.100/24
    }
}
```

Health check script example:

```conf
vrrp_script chk_haproxy {
  script "/usr/local/bin/check_haproxy.sh"
  interval 2
  weight -20
}
```

📋 **Table — VRRP fields**

| Field               | Purpose                     |
| ------------------- | --------------------------- |
| `priority`          | Higher = master             |
| `virtual_router_id` | VRRP group identifier       |
| `advert_int`        | Advertisement interval      |
| `state`             | MASTER/BACKUP initial state |

✅ **Best Practices**

* Use secure auth, consistent `virtual_router_id`, and health-check integration to only failover VIP when services actually fail.

💡 **In short**
`keepalived` provides VRRP-based VIP failover and integrates health checks to manage active/passive service endpoints.

---

## Q179: How would you optimize Linux for database workloads?

🧠 **Overview**

* Tune kernel, I/O, memory, and scheduler settings to reduce latency and increase throughput for DBMS (Postgres, MySQL).

⚙️ **Purpose / How it works**

* Prioritize direct I/O, reduce swapping, tune disk scheduler, and adjust network/timeouts for DB traffic.

🧩 **Examples / Commands / Config snippets**
`sysctl` tweaks:

```bash
# /etc/sysctl.d/99-db.conf
vm.swappiness = 1
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5
vm.overcommit_memory = 2
net.core.somaxconn = 1024
fs.file-max = 2097152
```

Disk scheduler:

```bash
# For HDD
echo noop > /sys/block/sda/queue/scheduler
# For NVMe
echo none > /sys/block/nvme0n1/queue/ioscheduler
```

Filesystem options:

```bash
# Mount with noatime
UUID=... /var/lib/postgresql ext4 defaults,noatime,nodiratime,barrier=1 0 2
```

📋 **Table — Areas to tune**

| Area       |                       Setting | Why                        |
| ---------- | ----------------------------: | -------------------------- |
| Memory     |    `swappiness`, `overcommit` | Avoid swapping DB pages    |
| I/O        |          scheduler, `dirty_*` | Reduce write latency       |
| Filesystem |             noatime, barriers | Reduce metadata writes     |
| Network    | `somaxconn`, `tcp_deferred_*` | Handle many DB connections |

✅ **Best Practices**

* Provision dedicated disks (RAID/ENCRYPTION as needed), use low-latency storage (NVMe), monitor IO wait, and benchmark changes in staging.

💡 **In short**
Minimize swap, tune I/O and filesystem options, and provision low-latency storage for database performance.

---

## Q180: What kernel parameters affect network performance?

🧠 **Overview**

* Several `sysctl` network params control buffers, connection handling, and TCP behaviors which impact throughput and latency.

⚙️ **Purpose / How it works**

* Adjust socket buffers, backlog limits, and TCP options to match workload (high concurrency vs low latency).

🧩 **Examples / Commands / Config snippets**
Key parameters (`/etc/sysctl.d/99-network.conf`):

```conf
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 5000
net.core.somaxconn = 1024
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_congestion_control = cubic
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65535
```

Apply:

```bash
sudo sysctl --system
```

📋 **Table — Parameter groups**

| Param                          | Purpose                      |
| ------------------------------ | ---------------------------- |
| `rmem_max/wmem_max`            | Max socket buffer sizes      |
| `somaxconn/netdev_max_backlog` | Backlog for accept/packets   |
| `tcp_*mem`                     | Kernel TCP memory thresholds |
| `tcp_congestion_control`       | Congestion algorithm         |
| `ip_local_port_range`          | Available ephemeral ports    |

✅ **Best Practices**

* Tune based on benchmarking; don’t arbitrarily inflate buffers. Ensure NIC offloads are correct and IRQ affinity is set for high throughput.

💡 **In short**
Tune socket buffers, backlog, TCP memory, and congestion control to optimize network throughput and latency.

---

## Q181: How do you tune TCP/IP stack parameters?

🧠 **Overview**

* Tuning TCP/IP involves adjusting sysctl parameters to fit application demands (more connections, higher throughput, lower latency).

⚙️ **Purpose / How it works**

* Configure kernel memory, timewait behavior, congestion control, and timeouts to avoid connection exhaustion and optimize transfer rates.

🧩 **Examples / Commands / Config snippets**
Common adjustments:

```conf
# /etc/sysctl.d/99-tcp.conf
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 0   # deprecated / unsafe on NAT
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_tw_buckets = 200000
net.ipv4.tcp_no_metrics_save = 1
```

Apply:

```bash
sudo sysctl -p /etc/sysctl.d/99-tcp.conf
```

📋 **Table — TCP tune targets**

| Goal                     | Params to change                        |
| ------------------------ | --------------------------------------- |
| Reduce TIME_WAIT         | `tcp_tw_reuse`, `tcp_fin_timeout`       |
| Prevent SYN flood        | `tcp_syncookies`, `tcp_max_syn_backlog` |
| High throughput          | `tcp_rmem`, `tcp_wmem`, `rmem_max`      |
| Lots of concurrent conns | `ip_local_port_range`                   |

✅ **Best Practices**

* Measure baseline, tune incrementally, be wary of `tcp_tw_recycle`, and retest under realistic load.

💡 **In short**
Adjust TCP memory, TIME_WAIT handling, and backlog/syn settings to match your connection and throughput needs.

---

## Q182: What is the purpose of sysctl and how do you use it?

🧠 **Overview**

* `sysctl` reads/writes kernel parameters at runtime (under `/proc/sys`) to tune system behavior.

⚙️ **Purpose / How it works**

* Use `sysctl` for network, VM, and kernel tunables without reboot. Persist changes via `/etc/sysctl.conf` or `/etc/sysctl.d/*.conf`.

🧩 **Examples / Commands / Config snippets**

```bash
# View a parameter
sysctl net.ipv4.ip_forward

# Set a parameter at runtime
sudo sysctl -w net.ipv4.ip_forward=1

# Persist: /etc/sysctl.d/99-custom.conf
net.ipv4.ip_forward = 1
net.core.somaxconn = 1024

# Apply all
sudo sysctl --system
```

📋 **Table — Common sysctl namespaces**

| Namespace  | What it controls        |
| ---------- | ----------------------- |
| `vm.*`     | Virtual memory/swapping |
| `net.*`    | Networking TCP/IP       |
| `fs.*`     | Filesystem limits       |
| `kernel.*` | Kernel behavior         |

✅ **Best Practices**

* Store overrides in `/etc/sysctl.d/` with small, named files. Use configuration management to enforce values.

💡 **In short**
`sysctl` modifies kernel params at runtime and persists via `/etc/sysctl.d/*` for system tuning.

---

## Q183: How do you make sysctl changes persistent?

🧠 **Overview**

* Persist sysctl changes by placing key=value pairs into files under `/etc/sysctl.d/` (or `/etc/sysctl.conf`) so they apply at boot.

⚙️ **Purpose / How it works**

* The init system loads `/etc/sysctl.conf` and `/etc/sysctl.d/*.conf` at boot; `sysctl --system` applies them immediately.

🧩 **Examples / Commands / Config snippets**

```bash
# Create file
sudo tee /etc/sysctl.d/99-custom.conf <<'EOF'
vm.swappiness = 1
net.core.somaxconn = 1024
EOF

# Apply now
sudo sysctl --system
```

📋 **Table — File precedence**

| File                   | Precedence             |
| ---------------------- | ---------------------- |
| `/etc/sysctl.d/*.conf` | Highest (alphabetical) |
| `/etc/sysctl.conf`     | Lower                  |
| `/run/sysctl.d/*.conf` | Runtime overrides      |

✅ **Best Practices**

* Use descriptive filenames and configuration management (Ansible/Terraform) for reproducibility. Avoid editing global `/etc/sysctl.conf` directly where possible.

💡 **In short**
Put key=value into `/etc/sysctl.d/99-name.conf` and run `sysctl --system` to persist and apply settings.

---

## Q184: How would you optimize Linux for web server workloads?

🧠 **Overview**

* Web workloads need quick request handling, low latency, and high concurrency; tune network, file descriptors, and web server settings.

⚙️ **Purpose / How it works**

* Optimize socket backlog, increase file descriptor limits, enable keepalive tuning, and use caching and compression.

🧩 **Examples / Commands / Config snippets**
System-level:

```conf
# /etc/sysctl.d/99-web.conf
net.core.somaxconn = 1024
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_tw_reuse = 1
```

Nginx example:

```nginx
worker_processes auto;
worker_rlimit_nofile 100000;
events { worker_connections 4096; multi_accept on; }
http {
  sendfile on;
  tcp_nopush on;
  keepalive_timeout 15;
  gzip on;
}
```

Ulimits:

```bash
# /etc/security/limits.conf
www-data soft nofile 65536
www-data hard nofile 100000
```

📋 **Table — Tuning targets**

| Area        |               Setting | Why                             |
| ----------- | --------------------: | ------------------------------- |
| FD limits   |           `ulimit -n` | Support many concurrent sockets |
| TCP backlog |           `somaxconn` | Accept queue length             |
| Caching     | Nginx cache / Varnish | Reduce origin load              |
| SSL         |     TLS session cache | Reduce handshake cost           |

✅ **Best Practices**

* Use connection pooling, reverse proxy + caching, monitor 95/99th percentile latencies, and autoscale horizontally for load spikes.

💡 **In short**
Raise file descriptors/backlogs, tune web server workers/keepalive, and use caching to improve web server throughput.

---

## Q185: What performance monitoring tools would you use (perf, ftrace, bpftrace)?

🧠 **Overview**

* Use `perf`, `ftrace`, and `bpftrace` for deep kernel/user-space performance profiling and tracing. Each has trade-offs in granularity and ease-of-use.

⚙️ **Purpose / How it works**

* `perf` profiles CPU, `ftrace` traces kernel functions, and `bpftrace` uses eBPF for dynamic tracing with low overhead.

🧩 **Examples / Commands / Config snippets**

```bash
# perf top
sudo perf top -p $(pidof myapp)

# perf record + report
sudo perf record -F 99 -p $(pidof myapp) -- sleep 30
sudo perf report

# ftrace example (trace function calls)
echo function > /sys/kernel/debug/tracing/current_tracer
echo 1 > /sys/kernel/debug/tracing/tracing_on

# bpftrace one-liner: trace all execs
sudo bpftrace -e 'tracepoint:sched:sched_process_exec { printf("%s %d %s\n", comm, pid, args->filename); }'
```

📋 **Table — Tool comparison**

| Tool       |            Level | Strength                           |
| ---------- | ---------------: | ---------------------------------- |
| perf       | Kernel+userspace | CPU hotspots, flamegraphs          |
| ftrace     |           Kernel | Low-level kernel tracing           |
| bpftrace   |             eBPF | High-level, flexible, low overhead |
| strace     |     User syscall | Syscall-level debugging            |
| sar/iostat |   System metrics | Historical performance             |

✅ **Best Practices**

* Use perf for hotspots, bpftrace for dynamic metrics, and record baselines. Run in staging when possible and limit probe overhead in production.

💡 **In short**
Combine perf, ftrace, and bpftrace for complementary profiling and tracing needs.

---

## Q186: How do you use strace to debug application behavior?

🧠 **Overview**

* `strace` traces system calls and signals a process makes—useful to debug I/O, file access, permission errors, and blocking syscalls.

⚙️ **Purpose / How it works**

* Attach to a process or run a command under `strace` to see syscalls, arguments, return values, and timing.

🧩 **Examples / Commands / Config snippets**

```bash
# Run command under strace
strace -ff -o /tmp/strace.out -e trace=file,network -T myapp arg1

# Attach to running process
sudo strace -p 12345 -e trace=all

# Filter by syscall and show timestamps
strace -tt -e open,read,write myapp
```

Analyze:

```bash
# Combine per-thread logs
cat /tmp/strace.out.* | less
```

📋 **Table — Common flags**

| Flag        | Use                   |
| ----------- | --------------------- |
| `-e trace=` | Filter syscalls       |
| `-ff -o`    | Follow forks to files |
| `-tt`       | Timestamp each event  |
| `-T`        | Show syscall timing   |

✅ **Best Practices**

* Use selective tracing (file, network) to reduce noise. Don’t run heavy tracing on production without load testing; collect outputs centrally if needed.

💡 **In short**
Use `strace` to see syscalls and pinpoint permission issues, missing files, or blocking calls in applications.

---

## Q187: How do you analyze system performance using sar?

🧠 **Overview**

* `sar` (sysstat) collects and reports historical system performance metrics (CPU, memory, I/O, network) for trend analysis.

⚙️ **Purpose / How it works**

* `sar` runs a background data collector (`sysstat` cron/systemd) and stores binary logs in `/var/log/sa/` for later reporting.

🧩 **Examples / Commands / Config snippets**
Install and enable:

```bash
sudo apt-get install sysstat
sudo systemctl enable --now sysstat
# Configure collection interval in /etc/default/sysstat or /etc/cron.d/sysstat
```

Usage:

```bash
# Show CPU report for today, interval 1s 5 times
sar -u 1 5

# Read historical file (e.g., sa21)
sar -f /var/log/sa/sa21 -q
# Show IO
sar -b 1 3
```

📋 **Table — Useful sar metrics**

| Command      | Metric                   |
| ------------ | ------------------------ |
| `sar -u`     | CPU usage                |
| `sar -q`     | Load average / run queue |
| `sar -b`     | I/O and transfer rates   |
| `sar -n DEV` | Network interface stats  |
| `sar -r`     | Memory usage             |

✅ **Best Practices**

* Keep appropriate retention, forward summaries to monitoring, and use `sar` for historical baselining and capacity planning.

💡 **In short**
Enable sysstat collection and use `sar` to review historical CPU, memory, I/O, and network trends.

---

## Q188: What is eBPF and what capabilities does it provide?

🧠 **Overview**

* eBPF (extended Berkeley Packet Filter) runs sandboxed programs in kernel context for observability, tracing, networking, and security with low overhead.

⚙️ **Purpose / How it works**

* Load small programs attached to hooks (tracepoints, kprobes, sockets); interact via maps to user-space; safe (verifier) and efficient.

🧩 **Examples / Commands / Config snippets**
Use `bpftool` / `bpftrace`:

```bash
# bpftrace one-liner: count syscalls open
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_openat { @[comm] = count(); }'
```

📋 **Table — eBPF capabilities**

| Domain        | Use-cases                             |
| ------------- | ------------------------------------- |
| Observability | Tracing, metrics, flamegraphs         |
| Networking    | XDP, tc, load-balancing, filtering    |
| Security      | System call filters, LSM integrations |
| Performance   | Low-overhead instrumentation          |

✅ **Best Practices**

* Use high-level tools (bpftrace, BCC) for quicker development; vet eBPF programs for verifier acceptance; prefer read-only probes in production for safety.

💡 **In short**
eBPF enables powerful, safe kernel-level instrumentation for tracing, networking, and security with minimal overhead.

---

## Q189: How would you use eBPF for performance monitoring?

🧠 **Overview**

* eBPF provides low-overhead tracing of kernel and userspace events to collect granular performance metrics and build flamegraphs or histograms.

⚙️ **Purpose / How it works**

* Attach eBPF probes (kprobes, uprobes, tracepoints) to measure function latencies, syscall frequency, and I/O patterns.

🧩 **Examples / Commands / Config snippets**
bpftrace examples:

```bash
# Latency of accept syscall per process
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_accept { @start[tid] = nsecs; }
tracepoint:syscalls:sys_exit_accept /@start[tid]/ { @latency[comm] = hist((nsecs - @start[tid])/1000); delete(@start[tid]); }'
```

Using BCC `offcputime.py`:

```bash
# off-CPU time per process (bcc)
sudo /usr/share/bcc/tools/offcputime -p $(pidof myapp) --threshold 1
```

📋 **Table — Typical eBPF metrics**

| Metric           | Probe                            |
| ---------------- | -------------------------------- |
| Function latency | kprobe/uprobes                   |
| Syscall counts   | tracepoints                      |
| Off-CPU time     | stack traces + scheduling events |
| Network drops    | XDP/tc hooks                     |

✅ **Best Practices**

* Aggregate metrics and export to Prometheus via exporters, sample intelligently to limit overhead, and profile in staging first.

💡 **In short**
Use eBPF probes to collect high-cardinality, low-overhead performance metrics and visualize via histograms/flamegraphs.

---

## Q190: How do you implement custom monitoring using eBPF programs?

🧠 **Overview**

* Build custom eBPF programs (using C, libbpf, BCC, or bpftrace) to capture application- or kernel-level events and export metrics/logs to user-space.

⚙️ **Purpose / How it works**

* Create probes, use maps for state, and use user-space readers to push metrics to monitoring systems (Prometheus, InfluxDB) or logs/alerts.

🧩 **Examples / Commands / Config snippets**
bpftrace simple script (save `http_latency.bt`):

```bpftrace
# Measure userland function latency (example: nginx function)
uprobe:/usr/sbin/nginx:ngx_http_process_request { @s[tid] = nsecs; }
uretprobe:/usr/sbin/nginx:ngx_http_process_request /@s[tid]/ {
  @lat_ms = hist((nsecs - @s[tid])/1000000);
  delete(@s[tid]);
}
```

Run and export: parse `bpftrace` output and push to Prometheus via a small exporter (Python/Go) reading `bpffs` maps or parsing stdout.

Using libbpf (C/CO-RE) pattern:

* Write BPF program in C, compile with clang to object, use libbpf to load, attach probes, and read maps in user-space to expose metrics.

📋 **Table — Development approaches**

| Tooling        |               Ease | Use-case                  |
| -------------- | -----------------: | ------------------------- |
| bpftrace       |    Fast prototypes | Ad-hoc scripts            |
| BCC (Python)   | Easier than libbpf | Rapid development         |
| libbpf (CO-RE) | Production quality | Robust, portable programs |

✅ **Best Practices**

* Start with `bpftrace` prototype, validate performance, then implement libbpf CO-RE for production. Limit map sizes, ensure verifier acceptance, and expose metrics via a robust exporter with auth.

💡 **In short**
Prototype with bpftrace/BCC, then move to libbpf CO-RE for production—export maps to Prometheus or SIEM for alerting and dashboards.

---

# Troubleshooting / Scenarios

Understood.
Generating **all questions (Q191–Q206)** in **full README-style format** now.

---

# 🚨 **Linux Troubleshooting & Scenarios (Q191–Q206)**

Production-grade, senior-level DevOps answers.

---

# ## Q191: Your Linux server is unresponsive and you cannot SSH into it. What steps would you take?

🧠 **Overview**
SSH failure + unresponsiveness usually indicates CPU starvation, memory exhaustion, disk I/O stall, network issues, or kernel panic. Troubleshooting focuses on isolating **host reachability**, **resource starvation**, and **console-level access**.

⚙️ **Purpose / How it works**
Use out-of-band access and network diagnostics to identify whether the host, kernel, or network stack is stuck.

🧩 **Steps / Commands**

### 1️⃣ **Check network reachability**

```bash
ping <server-ip>
traceroute <server-ip>
nc -zv <server-ip> 22
```

### 2️⃣ **Try alternate access**

* Cloud console (AWS EC2 serial console, Azure Serial Console).
* Hypervisor console (vSphere, Proxmox).
* IPMI / iDRAC / iLO.

### 3️⃣ **Check system health from console**

```bash
dmesg -T | tail
top
vmstat 1
iostat -xz 1
journalctl -xe
```

### 4️⃣ **Common failure indicators**

| Symptom                    | Likely cause                  |
| -------------------------- | ----------------------------- |
| High load but low CPU idle | I/O wait / stuck disks        |
| Kernel panic screen        | Driver issue, OOM             |
| Frozen console             | Hardware fault / soft lockups |

### 5️⃣ **Remediation**

* Restart failed service / process.
* Kill runaway process.
* Unmount or isolate failing disk.
* Last resort: reboot via console / cloud API.

✅ **Best Practices**

* Always enable serial console.
* Use monitoring + alerts for sshd, load average, disk health.
* Set up fallback access (bastion, SSM Session Manager).

💡 **In short**
Use console access, check I/O, CPU, logs, and recover services; reboot only when evidence confirms kernel/hardware freeze.

---

# ## Q192: The system load average is extremely high but CPU usage is low. What could cause this?

🧠 **Overview**
High load ≠ high CPU. Load also counts **processes waiting for I/O**, blocked on locks, or in uninterruptible sleep (D state).

⚙️ **Purpose / How it works**
Identify bottlenecks: I/O, disk, NFS, deadlocks, zombie processes, or kernel waits.

🧩 **Commands / Diagnosis**

```bash
# See D-state tasks
ps -eo pid,stat,cmd | grep ' D '

# Check disk I/O
iostat -xz 1

# Hung NFS mounts
df -hT
mount | grep nfs

# Kernel lockups
dmesg -T | grep -i "block" -i "hung"
```

📋 **Common causes**

| Condition                  | Explanation                |
| -------------------------- | -------------------------- |
| I/O wait                   | Slow disk / RAID rebuild   |
| D-state processes          | Uninterruptible waits      |
| NFS storage issues         | Mounted volume unreachable |
| Mutex/lock contention      | DB/App deadlocks           |
| Memory pressure + swapping | Thrashing                  |

✅ **Best Practices**

* Monitor disk latency (iostat, sar).
* Avoid blocking NFS mounts (`soft` + proper timeouts).
* Fix failing disks before user impact.

💡 **In short**
High load + low CPU → disk or I/O stall, NFS hangs, kernel locks, or blocked processes.

---

# ## Q193: Your server is running out of disk space. How do you identify what's consuming space?

🧠 **Overview**
Disk exhaustion impacts logs, apps, services, and OS stability. Find large files, directories, and growing logs.

⚙️ **Purpose / How it works**
Use du, find, lsof to detect both visible and deleted-but-open files.

🧩 **Commands**

### 1️⃣ Find large directories

```bash
du -ahx / | sort -hr | head -20
```

### 2️⃣ Find large individual files

```bash
find / -type f -size +500M -exec ls -lh {} \;
```

### 3️⃣ Check log files

```bash
du -sh /var/log/*
```

### 4️⃣ Check deleted-but-open files

```bash
lsof | grep deleted
```

### 5️⃣ Find journal logs

```bash
journalctl --disk-usage
journalctl --vacuum-size=1G
```

📋 **Common space culprits**

| Location            | Description                      |
| ------------------- | -------------------------------- |
| `/var/log`          | Rotated logs                     |
| `/tmp` / `/var/tmp` | Temp growth                      |
| Docker              | `/var/lib/docker` images, layers |
| Coredumps           | Large crash dumps                |
| App logs            | Unrotated logs                   |

✅ **Best Practices**

* Configure logrotate.
* Use filesystem quotas.
* Use monitoring alerts on disk usage.

💡 **In short**
Use du, find, and lsof to pinpoint large directories, files, and deleted open files.

---

# ## Q194: A process is consuming 100% CPU. How do you identify and troubleshoot it?

🧠 **Overview**
High CPU from a process may indicate loops, memory thrashing, bugs, or legitimate load.

⚙️ **Purpose / How it works**
Identify the process, inspect thread stack traces, and check system calls.

🧩 **Commands**

```bash
top -Hp <pid>
pidstat -p <pid> 1
strace -p <pid>
```

### Check thread stack traces

```bash
sudo gstack <pid>
```

### Check what file or network ops it does

```bash
lsof -p <pid>
```

📋 **Possible causes**

| Cause         | Evidence                           |
| ------------- | ---------------------------------- |
| Infinite loop | High CPU single thread             |
| Memory leak   | Res mem ↑ steadily                 |
| Bad queries   | DB-bound process                   |
| High I/O      | strace shows repeated reads/writes |

✅ **Best Practices**

* Limit CPU via cgroups.
* Optimize app code.
* Use monitoring for CPU thresholds.

💡 **In short**
Find PID, inspect threads, trace syscalls, isolate cause, and fix code or restart.

---

# ## Q195: Your system is experiencing high memory usage and applications are being killed. How do you diagnose?

🧠 **Overview**
OOM (Out-of-memory) killer terminates processes when RAM is exhausted. Identify what is consuming memory and why.

⚙️ **Purpose / How it works**
Kernel selects a victim based on OOM score. Check logs and memory metrics.

🧩 **Commands**

### 1️⃣ Check OOM logs

```bash
dmesg -T | grep -i "killed process"
```

### 2️⃣ Check per-process memory

```bash
ps aux --sort=-%mem | head
```

### 3️⃣ Check slab memory

```bash
slabtop
```

### 4️⃣ Check kernel buffers

```bash
free -m
vmstat 1
```

### 5️⃣ Check memory leaks

```bash
pmap <pid>
```

📋 **Common causes**

| Cause               | Description            |
| ------------------- | ---------------------- |
| Memory leak         | App not freeing memory |
| Cache pressure      | FS cache misconfigured |
| Unbounded processes | Fork bombs             |
| Too many containers | Consuming host RAM     |

✅ **Best Practices**

* Set cgroup memory limits.
* Increase swap only for non-performance workloads.
* Use monitoring to alert early.

💡 **In short**
Check OOM logs, identify memory hogs, inspect leaks, fix configs, set limits.

---

# ## Q196: You're seeing "too many open files" errors. How do you resolve this?

🧠 **Overview**
Every process has file descriptor limits (ulimit). When exceeded, the kernel blocks new file/socket creation.

⚙️ **Purpose / How it works**
Increase system limits and fix underlying leak.

🧩 **Commands**

### 1️⃣ Check current limits

```bash
ulimit -n
cat /proc/<pid>/limits
```

### 2️⃣ Increase global limit

```bash
# /etc/sysctl.d/99-fd.conf
fs.file-max = 2097152
sysctl --system
```

### 3️⃣ Per-user/per-service limit

```bash
# /etc/security/limits.conf
appuser soft nofile 65536
appuser hard nofile 65536
```

### 4️⃣ For systemd services

```bash
# /etc/systemd/system/app.service
LimitNOFILE=65536
```

📋 **Root causes**

| Issue               | Why                         |
| ------------------- | --------------------------- |
| Socket leak         | App not closing connections |
| Too many logs/files | Watchers opened             |
| Burst connections   | Need higher limits          |

✅ **Best Practices**

* Fix leaks before raising limits.
* Use monitoring for FD usage.

💡 **In short**
Raise OS + user limits and fix file/socket leaks.

---

# ## Q197: A service fails to start after system reboot. How would you troubleshoot?

🧠 **Overview**
Service startup issues usually arise from dependency failures, wrong permissions, missing files, or systemd misconfigurations.

⚙️ **Purpose / How it works**
Check systemd logs, environment, dependencies.

🧩 **Commands**

```bash
systemctl status <service>
journalctl -u <service> -b
```

### Check dependencies

```bash
systemctl list-dependencies <service>
```

### Verify paths and permissions

```bash
ls -l /etc/<svc> /var/lib/<svc>
```

### Validate systemd unit

```bash
systemd-analyze verify /etc/systemd/system/<svc>.service
```

📋 **Common reasons**

| Cause               | Example                  |
| ------------------- | ------------------------ |
| Missing directories | /var/run/app not created |
| Wrong permissions   | Denied by SELinux        |
| Env vars missing    | ExecStart script fails   |
| Port already in use | Bound by old process     |

✅ **Best Practices**

* Use `After=` and `Requires=` correctly.
* Keep unit files simple and explicit.

💡 **In short**
Use systemctl + journal logs to trace startup issues; fix dependencies, permissions, or unit configs.

---

# ## Q198: DNS resolution is failing on your Linux server. What would you check?

🧠 **Overview**
DNS issues break networking for apps, packages, and services. Must validate resolver configuration and upstream DNS availability.

⚙️ **Purpose / How it works**
Check `/etc/resolv.conf`, DNS servers, firewall ports, systemd-resolved.

🧩 **Commands**

```bash
cat /etc/resolv.conf
dig google.com
dig @8.8.8.8 google.com
systemd-resolve --status
```

### Check UDP/TCP 53

```bash
sudo nc -uvz <dns-server-ip> 53
```

📋 **Common causes**

| Issue                      | Description            |
| -------------------------- | ---------------------- |
| Wrong resolv.conf          | Bad nameserver entries |
| systemd-resolved conflicts | Symlink overwritten    |
| Firewall                   | Blocks DNS queries     |
| Broken DNS server          | Local resolver down    |

✅ **Best Practices**

* Use at least 2 DNS servers.
* Use monitoring for DNS failures.

💡 **In short**
Check resolv.conf → test dig → test DNS server reachability → fix nameservers or service.

---

# ## Q199: You cannot ping external IPs but can ping the gateway. How do you troubleshoot?

🧠 **Overview**
If gateway reachable but external IP unreachable → routing or firewall/NAT problem.

⚙️ **Purpose / How it works**
Identify outbound connectivity path failures beyond first hop.

🧩 **Commands**

### 1️⃣ Check default route

```bash
ip route show
```

### 2️⃣ Check NAT/masquerading

```bash
sudo iptables -t nat -L -n
```

### 3️⃣ Trace route

```bash
traceroute 8.8.8.8
```

### 4️⃣ Check firewall

```bash
sudo iptables -L -n
sudo ufw status
```

### 5️⃣ Check MTU issues

```bash
ping -M do -s 1472 8.8.8.8
```

📋 **Common root causes**

| Cause                 | Explanation               |
| --------------------- | ------------------------- |
| Missing default route | Can't exit local subnet   |
| NAT misconfigured     | Private IP not translated |
| ISP routing issue     | Beyond gateway failure    |
| MTU mismatch          | Packets dropped           |

💡 **In short**
If gateway works, check routes, NAT, firewalls, and MTU issues.

---

# ## Q200: A user cannot log in with correct credentials. What would you investigate?

🧠 **Overview**
Login failures can stem from authentication, account lockouts, shell issues, or PAM module problems.

⚙️ **Purpose / How it works**
Trace the login flow: PAM → NSS → shell.

🧩 **Commands**

### 1️⃣ Check auth logs

```bash
grep -i "auth" /var/log/secure
journalctl -xe
```

### 2️⃣ Verify user exists

```bash
id <username>
getent passwd <username>
```

### 3️⃣ Check account expiry

```bash
chage -l <user>
```

### 4️⃣ Check shell validity

```bash
grep <user> /etc/passwd
ls -l /bin/bash
```

### 5️⃣ Check permissions of home and ssh keys

```bash
ls -ld /home/<user>
ls -l /home/<user>/.ssh
```

📋 **Possible causes**

| Issue             | Symptoms              |
| ----------------- | --------------------- |
| Expired password  | PAM denies login      |
| Locked account    | `/etc/shadow` has `!` |
| Wrong shell       | `/bin/false` assigned |
| Permissions wrong | SSH refuses keys      |

💡 **In short**
Check auth logs, user info, expiry, shell, home perms, SSH settings.

---

# ## Q201: The file system is showing as read-only. How do you diagnose and fix this?

🧠 **Overview**
FS goes read-only when kernel detects I/O errors to protect data integrity.

⚙️ **Purpose / How it works**
Check disk health, logs, and remount if safe.

🧩 **Commands**

### 1️⃣ Check dmesg for disk errors

```bash
dmesg -T | grep -i error
```

### 2️⃣ Check filesystem health (offline)

```bash
sudo umount /dev/sda1
sudo fsck -f /dev/sda1
```

### 3️⃣ Attempt remount

```bash
sudo mount -o remount,rw /
```

### 4️⃣ Check SMART status

```bash
smartctl -a /dev/sda
```

📋 **Common causes**

| Cause              | Description      |
| ------------------ | ---------------- |
| Disk failure       | Bad sectors      |
| Cable/RAID failure | I/O timeout      |
| Journal corruption | FS inconsistency |

💡 **In short**
Inspect disk errors, run fsck, remount, replace failing disk if needed.

---

# ## Q202: Your system time is incorrect and causing authentication issues. How do you fix it?

🧠 **Overview**
Incorrect time breaks Kerberos, SSL, SSH, tokens, and logs.

⚙️ **Purpose / How it works**
Use NTP/chrony for time sync.

🧩 **Commands**

### 1️⃣ Check current time & sync status

```bash
timedatectl
chronyc tracking
```

### 2️⃣ Configure NTP/chrony

```bash
sudo apt install chrony
sudo vi /etc/chrony/chrony.conf
server time.google.com iburst
```

### 3️⃣ Restart service

```bash
systemctl restart chrony
```

📋 **Common issues**

| Issue           | Effect         |
| --------------- | -------------- |
| Drift           | Token failures |
| Stopped chronyd | No sync        |
| Wrong timezone  | Log confusion  |

💡 **In short**
Enable chrony/NTP and verify time sync status.

---

# ## Q203: A disk is showing errors in dmesg. What steps would you take?

🧠 **Overview**
Disk errors often precede data loss. Diagnose ASAP.

⚙️ **Purpose / How it works**
Check SMART, isolate disk, backup, replace.

🧩 **Commands**

```bash
dmesg -T | grep -i 'sd' -i 'error'
smartctl -a /dev/sdX
iostat -xz 1
```

### Check filesystem

```bash
umount /dev/sdX1
fsck -f /dev/sdX1
```

### Check RAID

```bash
cat /proc/mdstat
```

📋 **Disk error types**

| Error       | Meaning          |
| ----------- | ---------------- |
| I/O error   | Disk unreachable |
| Bad sectors | Surface damage   |
| Timeout     | Cable/RAID issue |

💡 **In short**
Check SMART, backup data, replace disk; run fsck only after unmounting.

---

# ## Q204: You're experiencing intermittent network packet loss. How would you diagnose?

🧠 **Overview**
Packet loss may originate from NIC, cable, switch, MTU mismatch, congestion, kernel buffers, or interrupts.

⚙️ **Purpose / How it works**
Trace loss across layers: L1 → L2 → L3 → L4.

🧩 **Commands**

### 1️⃣ Ping with pattern

```bash
ping -c 100 <target>
```

### 2️⃣ Check NIC counters

```bash
ip -s link
ethtool -S eth0
```

### 3️⃣ Check MTU mismatch

```bash
ping -M do -s 1472 <target>
```

### 4️⃣ Check routing & ARP

```bash
ip route
ip neigh
```

### 5️⃣ Capture packets

```bash
tcpdump -i eth0
```

📋 **Root causes**

| Cause           | Symptom                 |
| --------------- | ----------------------- |
| Duplex mismatch | CRC errors              |
| MTU mismatch    | Drops on large packets  |
| Buffer overflow | Drops under load        |
| Bad cable/NIC   | Increasing RX/TX errors |

💡 **In short**
Check NIC counters, MTU, routes, and packet captures.

---

# ## Q205: A cron job is not running as expected. How do you troubleshoot?

🧠 **Overview**
Cron failures usually involve permissions, PATH issues, environment variables, or script errors.

⚙️ **Purpose / How it works**
Cron runs with minimal environment; scripts must be fully path-qualified.

🧩 **Commands**

### 1️⃣ Check cron logs

```bash
grep CRON /var/log/syslog
journalctl -u cron
```

### 2️⃣ Verify crontab

```bash
crontab -l
```

### 3️⃣ Test script manually

```bash
sudo -u <user> /path/script.sh
```

### 4️⃣ Check file permissions

```bash
chmod +x /path/script.sh
```

### 5️⃣ Add PATH variable inside cron

```bash
PATH=/usr/bin:/bin:/usr/local/bin
```

📋 **Common causes**

| Issue                   | Description             |
| ----------------------- | ----------------------- |
| Wrong PATH              | Programs not found      |
| Permission denied       | Script non-executable   |
| Missing environment     | Script expects env vars |
| Cron daemon not running | Check systemctl         |

💡 **In short**
Review logs, validate script paths/permissions, add PATH, and test manually.

---

# ## Q206: The system boots to emergency mode. How do you recover?

🧠 **Overview**
Emergency mode means critical boot components (fstab, root FS, SELinux, initramfs) failed.

⚙️ **Purpose / How it works**
Use emergency shell to repair configuration or disk.

🧩 **Steps**

### 1️⃣ Check failure log

```bash
journalctl -xb
```

### 2️⃣ Check fstab errors

```bash
cat /etc/fstab
mount -a
```

### 3️⃣ Repair root filesystem

```bash
fsck -f /dev/sda1
```

### 4️⃣ Rebuild initramfs

```bash
dracut --force
# or
update-initramfs -u
```

### 5️⃣ Fix SELinux relabeling

```bash
touch /.autorelabel
reboot
```

### 6️⃣ Fix missing kernel/modules

```bash
yum reinstall kernel
```

📋 **Common causes**

| Cause            | Description       |
| ---------------- | ----------------- |
| Bad fstab entry  | Nonexistent mount |
| Corrupt FS       | Disk failure      |
| SELinux mislabel | Denied boot       |
| Broken initramfs | Missing drivers   |

💡 **In short**
Inspect logs, fix fstab, repair FS, rebuild initramfs, relabel SELinux, reboot.

---

Understood — delivering **all Q207–Q222** in **one large, fully detailed, README-style Markdown output**, just like the previous batch.

---

# # 🔧 Linux Troubleshooting & Scenarios (Q207–Q222)

---

# ## Q207: You accidentally deleted `/etc/passwd`. How do you recover?

🧠 **Overview**
`/etc/passwd` contains critical user metadata. Without it, login and many services fail. Recovery involves restoring from backups or recreating minimal system entries.

⚙️ **Purpose / How it works**
The system won’t authenticate, but root shell from console still works. Use recovery mode, rescue system, or cloud serial console.

🧩 **Recovery Steps**

### 1️⃣ Boot into rescue / single-user mode

AWS: *EC2 serial console → "Recovery/Rescue" mode*
Bare metal: *GRUB → edit → append `systemd.unit=rescue.target`*

---

### 2️⃣ Restore from backup (preferred)

If running automated backups:

```bash
cp /backup/etc/passwd /etc/passwd
cp /backup/etc/shadow /etc/shadow
```

---

### 3️⃣ Recreate minimal `/etc/passwd`

For most distros:

```bash
cat <<EOF > /etc/passwd
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
EOF
```

### 4️⃣ Rebuild `/etc/shadow`

```bash
pwconv
```

### 5️⃣ Fix permissions

```bash
chmod 644 /etc/passwd
chmod 600 /etc/shadow
```

📋 **Table — Critical files**

| File          | Purpose           |
| ------------- | ----------------- |
| `/etc/passwd` | User metadata     |
| `/etc/shadow` | Password hashes   |
| `/etc/group`  | Group definitions |

💡 **In short**
Boot into rescue mode → restore from backup → recreate minimal entries → regenerate shadow file.

---

# ## Q208: A server is experiencing very slow disk I/O. What would you investigate?

🧠 **Overview**
Slow I/O indicates disk bottlenecks, hardware failure, filesystem problems, or scheduler misconfiguration.

⚙️ **Purpose / How it works**
Analyze I/O latency, queue depth, disk health, and filesystem behavior.

🧩 **Commands**

### 1️⃣ Check disk latency

```bash
iostat -xz 1
```

Look at:

* `await` → high latency
* `svctm` → slow service time
* `%util` → >90% busy

---

### 2️⃣ Check kernel logs

```bash
dmesg -T | grep -i "error" -i "blk"
```

---

### 3️⃣ Check SMART health

```bash
smartctl -a /dev/sdX
```

---

### 4️⃣ Identify heavy I/O processes

```bash
iotop -ao
```

---

### 5️⃣ Check filesystem and mount options

```bash
mount | grep /data
```

📋 **Common causes**

| Cause          | Indicator                       |
| -------------- | ------------------------------- |
| Dying disk     | SMART "Reallocated sectors"     |
| RAID rebuild   | High latency                    |
| NFS hang       | D-state tasks                   |
| Bad scheduler  | Wrong I/O scheduler on SSD/NVMe |
| Heavy app load | High queue depth                |

💡 **In short**
Measure latency (iostat), inspect logs, check SMART, identify I/O-heavy processes.

---

# ## Q209: Multiple zombie processes are accumulating. What's the cause and solution?

🧠 **Overview**
Zombie processes are dead children whose exit status wasn’t reaped by the parent. They do *not* use CPU/RAM, but many indicate parent process bugs.

⚙️ **Cause**
Parent failed to call `wait()` or `waitpid()`.

🧩 **Commands**

### Identify zombies

```bash
ps aux | grep 'Z'
```

### Find parent PID

```bash
ps -o ppid= -p <zombie-pid>
```

### Restart parent process

```bash
systemctl restart <service>
```

### As last resort, kill parent process

(Children then reparent to PID 1 which reaps them)

```bash
kill -9 <ppid>
```

📋 **Common root causes**

| Cause              | Explanation             |
| ------------------ | ----------------------- |
| App bug            | Not reaping children    |
| Orphaned processes | Parent terminated badly |
| Fork bombs         | Too many children       |

💡 **In short**
Zombies → parent not reaping → restart or fix parent → reaping happens automatically.

---

# ## Q210: SSH connections are timing out. What could be causing this?

🧠 **Overview**
SSH timeout means packets aren’t reaching the server or the server is overloaded/unresponsive.

⚙️ **Purpose / How it works**
Check network path, firewall, sshd status, and resource starvation.

🧩 **Commands**

### 1️⃣ Check sshd is running

```bash
systemctl status sshd
```

### 2️⃣ Check port 22 reachability

```bash
nc -zv <server> 22
```

### 3️⃣ Firewall rules

```bash
iptables -L -n
ufw status
```

### 4️⃣ Identify TCP drops

```bash
ss -tlnp | grep 22
```

### 5️⃣ Check server load / I/O wait

```bash
top
vmstat 1
iostat -xz 1
```

📋 **Common Causes**

| Issue         | Explanation            |
| ------------- | ---------------------- |
| Firewall drop | Port 22 blocked        |
| I/O freeze    | sshd stuck waiting     |
| Network ACL   | Cloud SG rules         |
| DNS latency   | Reverse lookup timeout |
| Max sessions  | `MaxStartups` limit    |

💡 **In short**
Check sshd status → port 22 → firewall/NACL → server load → DNS delays.

---

# ## Q211: Your web server returns "connection refused" errors. How do you diagnose?

🧠 **Overview**
Connection refused = TCP RST, meaning nothing is listening on the target port.

⚙️ **Purpose / How it works**
Check the service, port binding, firewall, and network path.

🧩 **Commands**

### 1️⃣ Verify process listening

```bash
ss -tlnp | grep :80
```

### 2️⃣ Check service status

```bash
systemctl status nginx
systemctl status httpd
```

### 3️⃣ Check firewall

```bash
iptables -L -n
ufw status
```

### 4️⃣ Check SELinux

```bash
sudo ausearch -m AVC -ts recent
```

### 5️⃣ Check logs

```bash
journalctl -u nginx
journalctl -u httpd
```

📋 **Common causes**

| Cause               | Explanation             |
| ------------------- | ----------------------- |
| Service not running | Nothing listening       |
| Port blocked        | Firewall drop           |
| SELinux             | Denies bind to port     |
| Wrong IP bind       | Bound to localhost only |

💡 **In short**
Check if service is listening → verify firewall → inspect logs → confirm SELinux context.

---

# ## Q212: The server ran out of inodes. How do you identify and resolve this?

🧠 **Overview**
Inodes represent file metadata. Too many small files → zero inodes left → FS becomes unusable.

⚙️ **Purpose / How it works**
Identify directories spawning excessive files and clean them.

🧩 **Commands**

### Check inode usage

```bash
df -i
```

### Find dirs with many files

```bash
sudo find / -xdev -type d -print0 | xargs -0 ls -U | wc -l
```

More accurate:

```bash
sudo du --inodes -x / | sort -rn | head
```

📋 **Common inode hogs**

| Location           | Description            |
| ------------------ | ---------------------- |
| `/var/log`         | Rotating logs          |
| `/tmp`             | Temp file leaks        |
| Application caches | Millions of tiny files |
| Mail queues        | Stale messages         |

### Resolve:

* Delete unnecessary small files

```bash
find /path -type f -delete
```

* Increase inode count (requires FS recreation)

```bash
mkfs.ext4 -N <number> /dev/sdX
```

💡 **In short**
Check df -i, find dirs with too many files, delete them, recreate FS if needed.

---

# ## Q213: A process is stuck in "D" state (uninterruptible sleep). What does this mean and how do you handle it?

🧠 **Overview**
“D-state” means waiting on I/O that cannot be interrupted (disk, NFS, kernel). The process cannot be killed until I/O completes.

⚙️ **Purpose / How it works**
Kernel blocks thread until I/O returns.

🧩 **Commands**

### Identify D-state tasks

```bash
ps -eo pid,stat,cmd | grep ' D '
```

### Check disk/NFS issues

```bash
dmesg -T | grep -i "nfs" -i "blk" -i "error"
```

### Check blocked files

```bash
lsof -p <pid>
```

📋 **Common causes**

| Issue              | Explanation     |
| ------------------ | --------------- |
| Disk I/O timeout   | Bad disk        |
| Stale NFS mount    | Server down     |
| Kernel driver hang | SCSI driver bug |

### Solutions:

* Fix underlying I/O issue.
* Unmount bad NFS mount.
* As last resort → reboot.

💡 **In short**
D-state = stuck I/O; cannot kill; fix underlying disk/NFS issue.

---

# ## Q214: Your server cannot resolve hostnames in `/etc/hosts`. What's wrong?

🧠 **Overview**
Hostname resolution order is controlled by `/etc/nsswitch.conf`. If not configured properly, `/etc/hosts` may be ignored.

⚙️ **Purpose / How it works**
Ensure "files" comes before "dns" in NSS configuration.

🧩 **Commands**

### Check nsswitch

```bash
cat /etc/nsswitch.conf | grep hosts
```

Correct entry:

```
hosts: files dns
```

📋 **Common causes**

| Issue                | Explanation               |
| -------------------- | ------------------------- |
| Wrong nsswitch order | DNS used instead of hosts |
| Missing permissions  | `/etc/hosts` unreadable   |
| Wrong format         | Tabs/extra spaces         |

💡 **In short**
Set `hosts: files dns` and verify permissions/format.

---

# ## Q215: Swap usage is at 100% causing performance degradation. What would you do?

🧠 **Overview**
Full swap indicates memory pressure; system is thrashing.

⚙️ **Purpose / How it works**
Reduce memory footprint, adjust swappiness, add more RAM or swap.

🧩 **Commands**

### Check memory usage

```bash
free -m
top
vmstat 1
```

### Check which processes are swapping

```bash
smem -sw
```

### Reduce swappiness

```bash
echo "vm.swappiness=10" >> /etc/sysctl.d/99-swap.conf
sysctl --system
```

### Add temporary swap

```bash
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
```

📋 **Root causes**

| Cause             | Explanation          |
| ----------------- | -------------------- |
| Memory leak       | App consumes all RAM |
| Too many services | Exhaustion           |
| Heavy caching     | FS cache pressure    |

💡 **In short**
Reduce memory load, check leaks, tune swappiness, add swap/RAM.

---

# ## Q216: A filesystem mount is hanging. How do you troubleshoot and unmount it?

🧠 **Overview**
Hanging mounts (often NFS) cause uninterruptible D-state processes.

⚙️ **Purpose / How it works**
Fix underlying storage or force-detach.

🧩 **Commands**

### 1️⃣ Identify hung mount

```bash
mount | grep nfs
df -hT
```

### 2️⃣ Show processes using mount

```bash
lsof +f -- /mnt/data
fuser -vm /mnt/data
```

### 3️⃣ Attempt graceful unmount

```bash
umount /mnt/data
```

### 4️⃣ Force unmount

```bash
umount -f /mnt/data
umount -l /mnt/data   # Lazy unmount
```

📋 **Common causes**

| Cause                  | Explanation        |
| ---------------------- | ------------------ |
| NFS server unreachable | IO blocking        |
| Disk failure           | Block device hangs |
| Kernel bug             | Stuck driver       |

💡 **In short**
Identify mount → kill processes → lazy/force unmount → fix underlying storage.

---

# ## Q217: SELinux is blocking a legitimate application. How do you diagnose and fix?

🧠 **Overview**
SELinux denies actions outside policy; must inspect logs and assign correct labels or booleans.

⚙️ **Purpose / How it works**
Audit subsystem logs AVC denials, which guide policy fixes.

🧩 **Commands**

### 1️⃣ Check denials

```bash
ausearch -m AVC -ts recent
journalctl -t setroubleshoot
```

### 2️⃣ Use audit2allow

```bash
audit2allow -w -a
audit2allow -M mypolicy
semodule -i mypolicy.pp
```

### 3️⃣ Check context

```bash
ls -Z /var/www/html
restorecon -Rv /var/www/html
```

📋 **Fix types**

| Fix                 | Example                                     |
| ------------------- | ------------------------------------------- |
| Restore context     | `restorecon -Rv /path`                      |
| Enable boolean      | `setsebool -P httpd_can_network_connect on` |
| Write custom policy | Using audit2allow                           |

💡 **In short**
View AVC logs → restore context → enable booleans → create custom policy if needed.

---

# ## Q218: Your server's network interface keeps going down. What would you check?

🧠 **Overview**
Intermittent NIC drops often stem from hardware, driver, cable, switch, or power-saving settings.

⚙️ **Purpose / How it works**
Inspect NIC counters, logs, link flaps, and physical layer.

🧩 **Commands**

### Check NIC status

```bash
ip link show eth0
dmesg -T | grep eth0
```

### Check errors

```bash
ethtool -S eth0
```

### Disable power saving

```bash
ethtool -s eth0 wol d
```

### Check duplex/speed mismatch

```bash
ethtool eth0
```

📋 **Root causes**

| Cause                     | Evidence           |
| ------------------------- | ------------------ |
| Bad cable                 | CRC errors         |
| Switch issues             | Link flaps         |
| Driver problems           | Dmesg warnings     |
| Auto-negotiation failures | Wrong speed/duplex |

💡 **In short**
Check dmesg, NIC counters, cables, speed/duplex, drivers, and power-saving settings.

---

# ## Q219: A user's home directory has disappeared. How do you investigate?

🧠 **Overview**
Missing home directory affects login and data access; determine whether it was deleted, unmounted, or wrongly set.

⚙️ **Purpose / How it works**
Check user config, mounts, backup, and audit logs.

🧩 **Commands**

### Check user entry

```bash
getent passwd <user>
```

### Check if home is mounted

```bash
mount | grep home
```

### Look for deleted files

```bash
lsof | grep deleted
```

### Search for directory

```bash
find / -type d -name "<user>"
```

### Check audit logs

```bash
ausearch -f /home/<user>
```

📋 **Root causes**

| Cause                  | Explanation        |
| ---------------------- | ------------------ |
| NFS/home mount missing | Home not mounted   |
| Directory deleted      | Accidental removal |
| Wrong UID path         | Home mismatch      |

💡 **In short**
Check passwd → check mount → search directory → review audit logs → restore from backup.

---

# ## Q220: System logs show kernel panic messages. How do you analyze the root cause?

🧠 **Overview**
Kernel panics indicate fatal kernel faults: memory, hardware, modules, drivers.

⚙️ **Purpose / How it works**
Analyze crash dumps, logs, and patterns.

🧩 **Commands**

### 1️⃣ Check logs

```bash
journalctl -k -b -1
```

### 2️⃣ Enable kdump

```bash
systemctl enable --now kdump
```

### 3️⃣ Analyze crash dump

```bash
crash /usr/lib/debug/lib/modules/$(uname -r)/vmlinux /var/crash/vmcore
```

### 4️⃣ Check hardware

```bash
memtest86
smartctl -a /dev/sdX
```

📋 **Common causes**

| Cause          | Evidence           |
| -------------- | ------------------ |
| Driver bugs    | Backtrace in stack |
| Faulty RAM     | ECC errors         |
| Disk failure   | I/O errors         |
| Kernel modules | tainted kernel     |

💡 **In short**
Enable kdump, inspect crash logs, analyze vmcore, check hardware integrity.

---

# ## Q221: Package installation fails with dependency errors. How do you resolve?

🧠 **Overview**
Dependency issues arise from broken repos, mismatched versions, or partial upgrades.

⚙️ **Purpose / How it works**
Fix repo config, rebuild cache, or force reinstall.

🧩 **Commands**

### For RPM-based systems

```bash
yum clean all
yum makecache
yum deplist <package>
yum install --skip-broken
yum distro-sync
```

### For Debian-based systems

```bash
apt --fix-broken install
apt-get update
apt-get -f install
```

📋 **Common causes**

| Cause             | Explanation          |
| ----------------- | -------------------- |
| Mixed repos       | Wrong versions       |
| Partial upgrades  | Missing dependencies |
| Old package cache | Stale metadata       |

💡 **In short**
Clean repo cache, fix broken dependencies, sync distro versions.

---

# ## Q222: Your NFS mount is stale. How do you fix it without affecting running processes?

🧠 **Overview**
A stale NFS mount means the server is unreachable or not responding. Force unmounting may break processes.

⚙️ **Purpose / How it works**
Perform lazy unmount or remount when safe.

🧩 **Commands**

### Check NFS status

```bash
dmesg -T | grep nfs
showmount -e <server>
```

### Lazy unmount (does not affect active FDs)

```bash
umount -l /mnt/data
```

### Force remount

```bash
mount -o remount /mnt/data
```

### Restart NFS services (client side)

```bash
systemctl restart nfs-client.target
```

📋 **Causes**

| Issue             | Effect         |
| ----------------- | -------------- |
| Server down       | Stale handle   |
| Network issues    | Timeout        |
| Permission change | Invalid handle |

💡 **In short**
Lazy unmount (`umount -l`), remount, fix server/network issues.

---

Perfect — I will always use **Option A: one single large README-style answer** for every batch moving forward.

Below is the **full detailed output for Q223–Q234**, with the same structure (🧠 Overview → ⚙️ Purpose → 🧩 Commands → 📋 Tables → Best Practices → 💡 In short).

---

# # 🔧 Linux Troubleshooting & Scenarios (Q223–Q234)

---

# ## Q223: The server is experiencing time drift. How do you diagnose and configure NTP?

🧠 **Overview**
Time drift breaks authentication, TLS, distributed systems, logs, and databases. Use chrony or ntpd to ensure accurate clock sync.

⚙️ **Purpose / How it works**
NTP synchronizes system time with authoritative time servers through polling + correction algorithms.

🧩 **Commands / Steps**

### 1️⃣ Check current time status

```bash
timedatectl
chronyc tracking
```

### 2️⃣ Check NTP sources

```bash
chronyc sources -v
```

### 3️⃣ Configure chrony

Edit `/etc/chrony/chrony.conf`:

```
server time.google.com iburst
server 0.pool.ntp.org iburst
```

Restart:

```bash
systemctl restart chronyd
```

### 4️⃣ Force sync

```bash
chronyc makestep
```

📋 **Common causes**

| Cause                    | Explanation            |
| ------------------------ | ---------------------- |
| NTP disabled             | chronyd off            |
| Firewall blocked UDP/123 | No sync                |
| VM hosts drifting        | Hypervisor time issues |
| Mixed NTP/chrony         | Conflicts              |

💡 **In short**
Check chrony sync → configure reliable NTP servers → allow UDP/123 → force sync.

---

# ## Q224: A script works manually but fails in cron. What could be the issue?

🧠 **Overview**
Cron runs with a *minimal environment*. Missing PATHs, environment variables, permissions, and relative paths commonly break scripts.

⚙️ **Purpose / How it works**
Cron jobs execute non-interactively under `/usr/sbin/cron`, lacking shell profile settings.

🧩 **Diagnosis**

### 1️⃣ Check cron logs

```bash
grep CRON /var/log/syslog
```

### 2️⃣ Add PATH explicitly

```bash
PATH=/usr/local/bin:/usr/bin:/bin
```

### 3️⃣ Use absolute paths in scripts

❌ `python script.py`
✔️ `/usr/bin/python /opt/scripts/script.py`

### 4️⃣ Check permissions

```bash
chmod +x /opt/scripts/script.sh
```

### 5️⃣ Check environment needs

```bash
env > /tmp/env.txt    # Compare cron vs shell
```

📋 **Common issues**

| Issue          | Why                     |
| -------------- | ----------------------- |
| Missing PATH   | Commands not found      |
| Relative paths | Cron starts in `/`      |
| No environment | Missing variables       |
| SELinux        | Blocks execution        |
| Wrong shell    | `/bin/sh` ≠ `/bin/bash` |

💡 **In short**
Cron = minimal environment → set PATH, use absolute paths, add env vars, check logs.

---

# ## Q225: Your server's entropy pool is depleted affecting cryptographic operations. What's the solution?

🧠 **Overview**
Low entropy slows random number generation affecting SSH, TLS, VPNs, and key generation.

⚙️ **Purpose / How it works**
Linux uses `/dev/random` (blocking) and `/dev/urandom` (non-blocking) backed by entropy from kernel sources.

🧩 **Fixes**

### 1️⃣ Check entropy

```bash
cat /proc/sys/kernel/random/entropy_avail
```

### 2️⃣ Install haveged (common solution)

```bash
sudo apt install haveged
sudo systemctl enable --now haveged
```

### 3️⃣ Or enable rngd if hardware RNG available

```bash
sudo apt install rng-tools
sudo rngd -r /dev/hwrng
```

📋 **Entropy sources**

| Source     | Notes                       |
| ---------- | --------------------------- |
| haveged    | Userspace entropy generator |
| rngd       | Hardware RNG                |
| TPM RNG    | Modern servers              |
| Jitter RNG | Kernel-based                |

💡 **In short**
Install haveged or rng-tools; ensure entropy >1000 for crypto operations.

---

# ## Q226: Port 80 is already in use but no process is showing in netstat. How do you find it?

🧠 **Overview**
If no process appears in netstat, it may be held by:

* Kernel (IPVS)
* Docker / container engine
* Systemd socket activation
* IPv6 vs IPv4 mismatch
* Rootkit hiding processes

⚙️ **Purpose / How it works**
Use lower-level tools to inspect in-kernel listeners.

🧩 **Commands**

### 1️⃣ Use ss (more accurate than netstat)

```bash
ss -tulpn | grep :80
```

### 2️⃣ Check systemd socket activation

```bash
systemctl list-sockets | grep 80
```

### 3️⃣ Check IPVS / Kubernetes

```bash
ipvsadm -Ln | grep 80
```

### 4️⃣ Check Docker/Nginx in container

```bash
docker ps
docker port <container-id>
```

### 5️⃣ Check hidden processes

```bash
lsof -i :80
```

📋 **Possible causes**

| Cause          | Tool            |
| -------------- | --------------- |
| systemd socket | `list-sockets`  |
| IPVS           | `ipvsadm`       |
| Docker proxy   | `docker ps`     |
| IPv6 only      | Check `[::]:80` |

💡 **In short**
Use ss/lsof/systemd sockets/IPVS/Kubernetes to identify real bind owner.

---

# ## Q227: File permissions look correct but users still cannot access files. What else would you check?

🧠 **Overview**
Permissions alone don’t guarantee access. Check parent directories, SELinux, ACLs, and mount options.

⚙️ **Purpose / How it works**
Access verification includes:

* Directory traversal permissions
* SELinux contexts
* Extended ACLs
* Filesystem flags

🧩 **What to check**

### 1️⃣ Parent directory execute permission

```bash
namei -l /path/to/file
```

### 2️⃣ SELinux context

```bash
ls -Z /path/to/file
restorecon -Rv /path
```

### 3️⃣ ACLs

```bash
getfacl /path/file
```

### 4️⃣ Mount options

```bash
mount | grep noexec
```

📋 **Potential issues**

| Issue                 | Explanation          |
| --------------------- | -------------------- |
| Wrong directory perms | Need `x` to traverse |
| SELinux denies        | Logs show AVC        |
| ACL overrides         | User not in ACL      |
| noexec/nodev          | Prevents execution   |

💡 **In short**
Check directory exec perms, ACLs, SELinux, mount options.

---

# ## Q228: Your LVM volume group is showing as inactive. How do you activate it?

🧠 **Overview**
Inactive VG/LV means LVM metadata not loaded or disk not detected.

⚙️ **Purpose / How it works**
Reactivate PV → VG → LV chain.

🧩 **Commands**

### 1️⃣ Scan PVs

```bash
pvscan
```

### 2️⃣ Activate VG

```bash
vgchange -ay <vgname>
```

### 3️⃣ Activate LV

```bash
lvchange -ay <lvpath>
```

### 4️⃣ Mount

```bash
mount /dev/<vg>/<lv> /mnt
```

📋 **Common causes**

| Cause              | Explanation           |
| ------------------ | --------------------- |
| Missing disks      | Cloud/VM not attached |
| Corrupted metadata | Use `vgcfgrestore`    |
| LVM filters        | Wrong device filters  |

💡 **In short**
Run pvscan → vgchange -ay → lvchange -ay → mount.

---

# ## Q229: A RAID array has a failed disk. What's your procedure for replacement?

🧠 **Overview**
RAID protects against disk failure, but failed disks must be replaced quickly.

⚙️ **Purpose / How it works**
Identify failed disk → remove → replace → rebuild.

🧩 **Commands**

### 1️⃣ Check RAID status

```bash
cat /proc/mdstat
mdadm --detail /dev/md0
```

### 2️⃣ Mark failed disk

```bash
mdadm /dev/md0 --fail /dev/sdX
```

### 3️⃣ Remove disk

```bash
mdadm /dev/md0 --remove /dev/sdX
```

### 4️⃣ Add new disk

```bash
mdadm /dev/md0 --add /dev/sdY
```

### 5️⃣ Monitor rebuild

```bash
watch cat /proc/mdstat
```

📋 **RAID levels**

| Level  | Tolerance |
| ------ | --------- |
| RAID1  | 1 disk    |
| RAID5  | 1 disk    |
| RAID6  | 2 disks   |
| RAID10 | depends   |

💡 **In short**
Fail → remove → replace → rebuild → monitor.

---

# ## Q230: The system journal is consuming excessive disk space. How do you manage it?

🧠 **Overview**
`journald` retains logs on disk; default retention may be too large.

⚙️ **Purpose / How it works**
Use `journalctl` vacuum features and configure retention limits.

🧩 **Commands**

### 1️⃣ Check usage

```bash
journalctl --disk-usage
```

### 2️⃣ Reduce size

```bash
journalctl --vacuum-size=1G
journalctl --vacuum-time=7d
```

### 3️⃣ Configure persist settings

Edit `/etc/systemd/journald.conf`:

```
SystemMaxUse=1G
SystemMaxFileSize=200M
MaxRetentionSec=1week
```

Restart:

```bash
systemctl restart systemd-journald
```

💡 **In short**
Vacuum logs → set retention limits in journald.conf.

---

# ## Q231: Your /tmp directory is mounted as noexec breaking installations. How do you handle this?

🧠 **Overview**
Executables cannot run in a `noexec` mount; installers, pip, and Java apps often fail.

⚙️ **Purpose / How it works**
Temporarily remount or configure tools to use alternative temp directories.

🧩 **Fix options**

### 1️⃣ Temporarily remount with exec

```bash
mount -o remount,exec /tmp
```

### 2️⃣ Use an alternate TMPDIR

```bash
export TMPDIR=/var/tmp
```

### 3️⃣ For systemd-managed /tmp

Edit `/etc/fstab` if persistent fix needed:

```
tmpfs /tmp tmpfs defaults 0 0
```

📋 **Why noexec is used**

| Reason                  |
| ----------------------- |
| Security hardening      |
| Prevent running malware |

💡 **In short**
Either remount /tmp with exec or point applications to another writable location.

---

# ## Q232: Network throughput is much lower than expected. What would you investigate?

🧠 **Overview**
Low throughput can come from NIC negotiation issues, MTU mismatch, CPU bottlenecks, offload settings, or switch constraints.

⚙️ **Purpose / How it works**
Diagnose from NIC → kernel → network → app.

🧩 **Commands**

### 1️⃣ Check NIC speed/duplex

```bash
ethtool eth0
```

### 2️⃣ Check MTU mismatch

```bash
ip link show eth0
ping -M do -s 1472 <target>
```

### 3️⃣ Check TCP offloading

```bash
ethtool -k eth0
```

### 4️⃣ Check IRQ distribution

```bash
cat /proc/interrupts
```

### 5️⃣ Measure performance

```bash
iperf3 -s
iperf3 -c <server>
```

📋 **Common causes**

| Cause             | Evidence           |
| ----------------- | ------------------ |
| Half-duplex       | Collisions, errors |
| MTU mismatch      | Fragmentation      |
| Disabled offloads | Slow TCP           |
| CPU bottleneck    | SoftIRQ spikes     |

💡 **In short**
Check speed/duplex, MTU, offloads, IRQ load, and measure with iperf.

---

# ## Q233: A symbolic link is broken. How do you identify where it should point?

🧠 **Overview**
Broken symlinks occur when targets are removed or moved. Determine correct target and recreate.

⚙️ **Purpose / How it works**
Read link contents and locate intended target.

🧩 **Commands**

### 1️⃣ Show symlink target

```bash
ls -l /path/symlink
readlink -f /path/symlink
```

### 2️⃣ Find possible real target

```bash
find / -name <target-name>
```

### 3️⃣ Recreate symlink

```bash
ln -s /correct/path /path/symlink
```

📋 **Common causes**

| Issue                   | Explanation         |
| ----------------------- | ------------------- |
| Package upgrade         | File moved          |
| Deleted directory       | Symlink now invalid |
| Incorrect relative path | Wrong target        |

💡 **In short**
Check symlink → find correct target → recreate.

---

# ## Q234: Your server cannot mount a filesystem due to "bad superblock" error. How do you recover?

🧠 **Overview**
"Bad superblock" indicates filesystem metadata corruption.

⚙️ **Purpose / How it works**
Use filesystem-specific recovery tools and alternate superblocks.

🧩 **Commands**

### 1️⃣ Verify device

```bash
blkid /dev/sdX1
fdisk -l
```

### 2️⃣ Check alternate superblocks (ext2/3/4)

```bash
dumpe2fs /dev/sdX1 | grep -i superblock
```

### 3️⃣ Run fsck using backup superblock

```bash
fsck -b <alternate-superblock> /dev/sdX1
```

### 4️⃣ If XFS

```bash
xfs_repair /dev/sdX1
```

### 5️⃣ Mount again

```bash
mount /dev/sdX1 /mnt
```

📋 **Root causes**
| Cause | Explanation |
|---|
| Power loss | Dirty FS |
| Disk errors | Bad sectors |
| Metadata corruption | Journal corrupted |

💡 **In short**
Find alternate superblock → fsck repair → remount.

---
Great — as always, I will return a **single large, fully detailed README-style answer** for **Q235–Q250** with:

* 🧠 Overview
* ⚙️ Purpose / How it works
* 🧩 Commands / Examples
* 📋 Tables
* ✅ Best Practices
* 💡 In short

Here is the complete output:

---

# # 🔧 Linux Troubleshooting & Scenarios (Q235–Q250)

---

# ## Q235: Users are experiencing random disconnections from SSH sessions. What would you check?

🧠 **Overview**
Random SSH drops generally result from network instability, idle timeouts, MTU issues, or server-side resource pressure.

⚙️ **Purpose / How it works**
SSH relies on stable TCP sessions; packet loss or timeouts will force disconnects.

🧩 **Diagnosis**

### 1️⃣ Check server logs

```bash
journalctl -u sshd
grep -i ssh /var/log/auth.log
```

### 2️⃣ Check network stability

```bash
ping -c100 <client-ip>
mtr <client-ip>
```

### 3️⃣ Check MTU issues

```bash
ping -M do -s 1472 <client-ip>
```

### 4️⃣ Enable keepalive

Client-side:

```
ServerAliveInterval 60
```

Server-side `/etc/ssh/sshd_config`:

```
ClientAliveInterval 60
ClientAliveCountMax 3
```

### 5️⃣ Check CPU / load

```bash
sar -n tcp 1
vmstat 1
```

📋 **Common causes**

| Issue                 | Description          |
| --------------------- | -------------------- |
| Firewall idle timeout | Drops idle sessions  |
| MTU mismatch          | Packet fragmentation |
| Network jitter        | Wireless/VPN hops    |
| High load             | sshd starved         |

💡 **In short**
Check network quality, MTU, sshd keepalive settings, and server load.

---

# ## Q236: A file cannot be deleted despite having correct permissions. What could prevent deletion?

🧠 **Overview**
File deletion depends not only on file permissions but also on directory permissions, immutable attributes, mount settings, and open file handles.

⚙️ **Purpose / How it works**
Deletion requires write permission on the *directory*, not the file itself.

🧩 **Commands to Diagnose**

### 1️⃣ Check directory permissions

```bash
ls -ld <directory>
```

### 2️⃣ Check immutable flag

```bash
lsattr <file>
chattr -i <file>
```

### 3️⃣ Check open handles

```bash
lsof | grep <file>
```

### 4️⃣ Check if filesystem is read-only

```bash
mount | grep <mountpoint>
```

📋 **Other blockers**

| Issue               | Prevent deletion? | Notes              |
| ------------------- | ----------------- | ------------------ |
| Sticky bit          | Yes               | `/tmp` style dirs  |
| Immutable attribute | Yes               | `chattr +i file`   |
| NFS lock            | Yes               | Stale file handles |
| Read-only FS        | Yes               | Any write blocked  |

💡 **In short**
Check directory perms, immutable bit, open handles, and FS mode.

---

# ## Q237: Your server's ARP table is full. What issues does this cause and how do you fix it?

🧠 **Overview**
ARP table exhaustion prevents the server from learning new MAC → IP mappings, causing intermittent connectivity failures.

⚙️ **Purpose / How it works**
Linux manages ARP entries based on memory limits; floods or misconfigurations fill ARP cache.

🧩 **Diagnosis**

### 1️⃣ View ARP entries

```bash
ip neigh
```

### 2️⃣ Check kernel limits

```bash
sysctl net.ipv4.neigh.default.gc_thresh*
```

### 3️⃣ Increase ARP thresholds

```bash
sysctl -w net.ipv4.neigh.default.gc_thresh1=1024
sysctl -w net.ipv4.neigh.default.gc_thresh2=2048
sysctl -w net.ipv4.neigh.default.gc_thresh3=4096
```

### 4️⃣ Check for ARP flood attacks

```bash
tcpdump -n -i eth0 arp
```

📋 **Impact**

| Impact                | Description                |
| --------------------- | -------------------------- |
| New hosts unreachable | Cannot resolve MAC         |
| Packet drops          | No ARP entry → no delivery |
| Network stalls        | Random failures            |

💡 **In short**
Increase ARP table limits and investigate ARP floods or misconfigurations.

---

# ## Q238: System commands are running extremely slowly after an update. How do you diagnose?

🧠 **Overview**
Post-update slowness often ties to library mismatches, broken PATH, missing shared libraries, or failing storage.

⚙️ **Purpose / How it works**
Commands depend on dynamic loaders, shared libs, and shell PATH resolution.

🧩 **Steps**

### 1️⃣ Check command resolution

```bash
strace ls
```

Look for long delays → NFS, DNS, or missing libs.

### 2️⃣ Check dynamic linker

```bash
ldd /bin/ls
```

### 3️⃣ Check disk I/O

```bash
iostat -xz 1
```

### 4️⃣ Check DNS delay

```bash
strace ping google.com
```

### 5️⃣ Check missing or broken libraries

```bash
ldconfig -p
```

📋 **Common causes**

| Cause         | Why                               |
| ------------- | --------------------------------- |
| Broken glibc  | Commands stall                    |
| DNS misconfig | Reverse lookups slow SSH/commands |
| Slow NFS      | Commands waiting on I/O           |
| Full disk     | Metadata operations block         |

💡 **In short**
Strace slow commands → check DNS, libraries, I/O performance.

---

# ## Q239: The server cannot allocate more process IDs. What's the issue and solution?

🧠 **Overview**
Linux enforces process ID limits; once exhausted, new forks fail.

⚙️ **Purpose / How it works**
If PIDs wrap but remain allocated, fork bombs or zombie buildup cause exhaustion.

🧩 **Diagnosis**

### 1️⃣ Check PID max

```bash
cat /proc/sys/kernel/pid_max
```

### 2️⃣ Count processes

```bash
ps -e | wc -l
```

### 3️⃣ Find fork bombs

```bash
top -b -n1 | grep defunct
```

### 4️⃣ Increase pid_max

```bash
sysctl -w kernel.pid_max=4194303
```

📋 **Common causes**

| Cause        | Notes                          |
| ------------ | ------------------------------ |
| Fork bomb    | Too many child processes       |
| Daemon leaks | Creates processes continuously |
| Low pid_max  | Defaults too small             |

💡 **In short**
Find runaway process generators → increase pid_max if required.

---

# ## Q240: Your firewall rules are blocking legitimate traffic. How do you troubleshoot iptables rules?

🧠 **Overview**
iptables rules are order-dependent; earlier rules override later ones.

⚙️ **Purpose / How it works**
Inspect chains, trace packet flow, and log drops.

🧩 **Commands**

### 1️⃣ Show rules with line numbers

```bash
iptables -L -n --line-numbers
```

### 2️⃣ Insert debug logging

```bash
iptables -I INPUT 1 -j LOG --log-prefix "IPTABLES DROP: "
```

### 3️⃣ Use packet tracing

```bash
iptables -t raw -A PREROUTING -p tcp --dport 80 -j TRACE
```

### 4️⃣ Check policies

```bash
iptables -L | grep policy
```

📋 **Common causes**

| Issue                 | Explanation            |
| --------------------- | ---------------------- |
| DROP earlier in chain | Blocks later ALLOW     |
| Wrong interface       | `eth0` vs `ens3`       |
| NAT missing           | Traffic not translated |
| Invalid states        | Conntrack issues       |

💡 **In short**
Review rules with line numbers → add logging → test packet path.

---

# ## Q241: A disk shows as mounted but files are not accessible. What would you investigate?

🧠 **Overview**
Unmounted or partially mounted disks may appear mounted but point to wrong devices, corrupted FS, or stale mounts.

⚙️ **Purpose / How it works**
Validate device-path consistency and filesystem health.

🧩 **Diagnosis**

### 1️⃣ Verify mount device

```bash
mount | grep <mountpoint>
lsblk -f
```

### 2️⃣ Check FS corruption

```bash
dmesg -T | grep -i "I/O" -i "error"
```

### 3️⃣ Run fsck (if unmounted)

```bash
fsck -f /dev/sdX1
```

### 4️⃣ Check permissions and ownership

```bash
ls -ld <mountpoint>
```

📋 **Possible causes**

| Cause             | Description          |
| ----------------- | -------------------- |
| Mounted empty dir | Wrong device mounted |
| FS corruption     | Missing metadata     |
| NFS stale mount   | Hung operations      |

💡 **In short**
Confirm correct device, check corruption, verify permissions, unmount + fsck.

---

# ## Q242: Your server's mail queue is growing and causing issues. How do you clear it?

🧠 **Overview**
Large mail queues indicate unreachable mail servers, bad DNS, or spam floods.

⚙️ **Purpose / How it works**
Manage mail queue for Postfix or Exim.

🧩 **Commands**

### For Postfix

Check queue:

```bash
mailq
```

Delete all:

```bash
postsuper -d ALL
```

Delete deferred messages:

```bash
postsuper -d ALL deferred
```

### For Exim

```bash
exim -bp
exim -Mrm <msg-id>
```

📋 **Root causes**

| Cause        | Why                 |
| ------------ | ------------------- |
| DNS failure  | Cannot resolve MX   |
| SMTP block   | Port 25 blocked     |
| Spam scripts | Compromised account |

💡 **In short**
Clear queue and fix DNS/SMTP issues; ensure no spam activity.

---

# ## Q243: CPU steal time is high on a virtualized server. What does this indicate?

🧠 **Overview**
CPU steal means the hypervisor is taking CPU away from your VM.

⚙️ **Purpose / How it works**
Indicates CPU contention on the host — oversubscription.

🧩 **Commands**

### Check steal %

```bash
top
mpstat -P ALL 1
```

📋 **Interpretation**

| Steal % | Meaning                |
| ------- | ---------------------- |
| <5%     | Normal                 |
| 5–20%   | Mild contention        |
| >20%    | Severe host contention |

### Solutions

* Move VM to different hypervisor host
* Increase CPU allocation
* Reduce overcommit
* Use dedicated hosts

💡 **In short**
High steal → hypervisor competition → move VM or allocate dedicated CPU.

---

# ## Q244: A service keeps restarting every few seconds. How do you identify the cause?

🧠 **Overview**
Systemd restarts services based on failure status and `Restart=` rules.

⚙️ **Purpose / How it works**
Inspect logs, restart loops, and failing Exec commands.

🧩 **Commands**

### 1️⃣ Check logs

```bash
journalctl -u <service> -f
```

### 2️⃣ Check restart settings

```bash
systemctl cat <service>
```

Look for:

```
Restart=always
RestartSec=1
```

### 3️⃣ Test service manually

```bash
/usr/bin/myservice
```

### 4️⃣ Check environment variables and permissions

```bash
systemctl show <service> | grep Environment
```

📋 **Common causes**

| Issue             | Explanation          |
| ----------------- | -------------------- |
| Crash loop        | Runtime failure      |
| Missing config    | App exits instantly  |
| Permission denied | SELinux or ownership |
| Wrong ExecStart   | Binary missing       |

💡 **In short**
Check logs → inspect Restart policies → run service manually → fix failure.

---

# ## Q245: Your server has duplicate IP addresses causing network issues. How do you resolve this?

🧠 **Overview**
Duplicate IPs lead to ARP conflicts and connectivity drops.

⚙️ **Purpose / How it works**
Identify both MACs responding to ARP for same IP.

🧩 **Commands**

### 1️⃣ Detect conflict

```bash
arping -I eth0 <ip>
```

### 2️⃣ Check ARP table

```bash
ip neigh | grep <ip>
```

### 3️⃣ Identify culprit

```bash
arp -a
```

### 4️⃣ Fix IP assignment

* DHCP conflict
* Static IP misconfigured
* Cloud metadata mismatch

📋 **Common conflict sources**

| Cause               | Example             |
| ------------------- | ------------------- |
| Duplicate static IP | Two servers same IP |
| DHCP misconfig      | Same lease issued   |
| VM cloning          | Retains old IP      |

💡 **In short**
Find conflicting MAC via arping → fix static/DHCP assignments.

---

# ## Q246: Kernel modules are failing to load. What would you check?

🧠 **Overview**
Module loading fails due to version mismatch, missing dependencies, or incorrect kernel version.

⚙️ **Purpose / How it works**
Modules must match kernel build and dependencies.

🧩 **Commands**

### 1️⃣ Check error

```bash
dmesg -T | grep -i module
```

### 2️⃣ Check kernel version

```bash
uname -r
```

### 3️⃣ Check module exists

```bash
modinfo <module>
```

### 4️⃣ Update initramfs

```bash
update-initramfs -u
# or
dracut --force
```

📋 **Common causes**

| Issue        | Explanation                    |
| ------------ | ------------------------------ |
| Wrong kernel | Booting older/different kernel |
| Missing deps | Module needs others            |
| Secure boot  | Blocks unsigned modules        |

💡 **In short**
Check kernel version, module info, dependencies, and secure boot.

---

# ## Q247: The server responds to ping but not to HTTP requests. How do you troubleshoot?

🧠 **Overview**
Ping (ICMP) works → server reachable. HTTP (TCP 80/443) failing indicates service, firewall, or routing issue.

⚙️ **Purpose / How it works**
Check listening sockets, process status, firewall, and SELinux.

🧩 **Commands**

### 1️⃣ Check service

```bash
systemctl status nginx
```

### 2️⃣ Check listening port

```bash
ss -tlnp | grep :80
```

### 3️⃣ Browser for error logs

```bash
tail -f /var/log/nginx/error.log
```

### 4️⃣ Firewall

```bash
iptables -L -n
```

### 5️⃣ SELinux

```bash
ausearch -m AVC
```

📋 **Common causes**

| Issue                   | Why             |
| ----------------------- | --------------- |
| HTTP server down        | No listener     |
| Port blocked            | Firewall        |
| SELinux                 | Denies bind     |
| Reverse proxy misconfig | Upstream errors |

💡 **In short**
Ping works → check HTTP listener, firewall, SELinux, logs.

---

# ## Q248: You're seeing "segmentation fault" errors for a critical application. How do you debug?

🧠 **Overview**
Segfault = invalid memory access → code bug, corrupt library, bad pointer, or memory corruption.

⚙️ **Purpose / How it works**
Use strace, gdb, core dumps, and library checks.

🧩 **Commands**

### 1️⃣ Enable core dumps

```bash
ulimit -c unlimited
```

### 2️⃣ Run app under gdb

```bash
gdb /path/app core
bt
```

### 3️⃣ Use strace

```bash
strace -f /path/app
```

### 4️⃣ Check shared libraries

```bash
ldd /path/app
```

📋 **Common causes**

| Issue            | Example     |
| ---------------- | ----------- |
| Null pointer     | Code bug    |
| Library mismatch | Wrong glibc |
| Corrupt files    | Disk error  |

💡 **In short**
Enable core → debug with gdb → check libraries → inspect code logic.

---

# ## Q249: The root filesystem is 100% full and system is unstable. How do you free up space safely?

🧠 **Overview**
Full root FS breaks systemd, journald, temp files, package installs.

⚙️ **Purpose / How it works**
Identify large files, logs, orphaned temporary files.

🧩 **Commands**

### 1️⃣ Check disk usage

```bash
df -h /
```

### 2️⃣ Clear journal logs

```bash
journalctl --vacuum-size=500M
```

### 3️⃣ Identify big files

```bash
du -ahx / | sort -hr | head -20
```

### 4️⃣ Clear package cache

```bash
apt-get clean
yum clean all
```

### 5️⃣ Check deleted-but-open files

```bash
lsof | grep deleted
```

### 6️⃣ Move logs to another disk

```bash
mv /var/log /mnt/logs/
ln -s /mnt/logs /var/log
```

📋 **Critical locations**

| Path              | Notes               |
| ----------------- | ------------------- |
| `/var/log`        | Often large         |
| `/tmp`            | Installer leftovers |
| `/var/lib/docker` | Huge images         |
| `/var/cache`      | Package cache       |

💡 **In short**
Vacuum logs, clean cache, investigate big files, move logs to other disk if needed.

---

# ## Q250: A user reports very slow login times. What could cause this and how do you fix it?

🧠 **Overview**
Slow logins usually stem from DNS delays, slow home directories, oversized profiles, or authentication backend issues.

⚙️ **Purpose / How it works**
Login sequence: NSS → PAM → Home mount → Shell init.

🧩 **Diagnosis**

### 1️⃣ Check DNS resolution delays

```bash
strace -T -e connect getent hosts <hostname>
```

### 2️⃣ Check home directory mount (NFS slow)

```bash
time ls /home/<user>
```

### 3️⃣ Check `.bashrc` or profile scripts

```bash
grep -E 'sleep|ping|slow' ~/.bashrc
```

### 4️⃣ Check LDAP/AD authentication delays

```bash
journalctl -u sssd
```

### 5️⃣ Profile shell startup

```bash
bash -x /etc/profile
```

📋 **Common causes**

| Cause                 | Explanation           |
| --------------------- | --------------------- |
| DNS timeout           | Reverse lookup slow   |
| NFS hang              | Home mount slow       |
| Heavy startup scripts | Long-running commands |
| LDAP/SSSD delays      | Network/auth issues   |

💡 **In short**
Check DNS, home mount performance, profile scripts, and identity services.

