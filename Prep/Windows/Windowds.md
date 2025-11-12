# IIS and Domain Services

## Q: What is IIS?

### 🧠 Overview

**IIS (Internet Information Services)** is a **web server** developed by **Microsoft** for hosting and managing web applications and websites on **Windows Server** and **Windows OS**.
It supports **HTTP, HTTPS, FTP, FTPS, SMTP**, and **NNTP** protocols.

---

### ⚙️ Purpose / How it works

* IIS serves **web content** (HTML, ASP.NET, PHP, static files, APIs) to clients over HTTP/S.
* It acts as a **bridge** between client requests and backend application logic.
* Works on a **modular architecture** with components like:

  * **Worker Process (w3wp.exe):** Executes web apps.
  * **Application Pool:** Isolates web apps for reliability.
  * **IIS Manager (GUI)** and **PowerShell / appcmd.exe** for configuration.
* Integrated with **Windows Authentication**, **Active Directory**, and **Event Viewer** for security and logging.

---

### 🧩 Examples / Commands / Config snippets

#### 🖥️ Start/Stop IIS (CLI)

```powershell
# Start IIS service
iisreset /start

# Stop IIS service
iisreset /stop

# Restart IIS service
iisreset /restart
```

#### 🧱 Create New Website via PowerShell

```powershell
New-WebSite -Name "MyApp" -Port 80 -PhysicalPath "C:\inetpub\myapp" -ApplicationPool "DefaultAppPool"
```

#### 🌐 IIS Application Pool Setup

```powershell
New-WebAppPool -Name "MyAppPool"
Set-ItemProperty IIS:\AppPools\MyAppPool -Name "managedRuntimeVersion" -Value "v4.0"
```

---

### 📋 Key IIS Components

| Component                     | Description                                                  |
| ----------------------------- | ------------------------------------------------------------ |
| **Worker Process (w3wp.exe)** | Executes web applications and handles requests.              |
| **Application Pool**          | Logical isolation for different web apps.                    |
| **Virtual Directory**         | Maps folder paths to URLs.                                   |
| **Modules**                   | Extend functionality (Authentication, Compression, Logging). |
| **IIS Manager**               | GUI tool for configuration.                                  |

---

### ✅ Best Practices

* Run each app in a **separate Application Pool** for isolation.
* Use **HTTPS with valid SSL certificates**.
* Enable **request filtering** and **IP restrictions**.
* Regularly **back up IIS configuration** using `appcmd add backup`.
* Monitor logs and worker process health via **Event Viewer** or **PerfMon**.

---

### 💡 In short

IIS is Microsoft’s web server for hosting web apps on Windows. It uses **Application Pools** for isolation and supports multiple protocols like **HTTP/S, FTP**. Ideal for **.NET** and **Windows-based web deployments**.

---
## Q: What’s the default port for IIS?

---

### 🧠 Overview

The **default port** for **IIS (Internet Information Services)** depends on the **protocol** used:

* **HTTP → Port 80**
* **HTTPS → Port 443**

These are the **standard web ports** that IIS listens on unless manually changed in the site configuration.

---

### ⚙️ Purpose / How it works

* IIS binds each website to a specific **IP address, port number, and host header**.
* The **default binding** for a new site is:

  * `http://*:80/` (HTTP)
  * `https://*:443/` (HTTPS)
* Multiple sites can share the same port if differentiated by **host headers** (domain names).

---

### 🧩 Examples / Commands / Config snippets

#### 🔍 Check current bindings in IIS (PowerShell)

```powershell
Get-WebBinding
```

#### 🌐 Change IIS Site Port

```powershell
Set-WebBinding -Name "Default Web Site" -BindingInformation "*:8080:" -PropertyName Port -Value 8080
```

#### ⚙️ GUI Path

> IIS Manager → Sites → Default Web Site → **Bindings** → Edit → Change Port

---

### 📋 Default Port Reference

| Protocol | Default Port | Description                   |
| -------- | ------------ | ----------------------------- |
| HTTP     | **80**       | Unsecured web traffic         |
| HTTPS    | **443**      | Secured web traffic (TLS/SSL) |
| FTP      | 21           | File Transfer Protocol        |
| FTPS     | 990          | Secure FTP                    |
| SMTP     | 25           | Mail transport                |
| NNTP     | 119          | Newsgroup service             |

---

### ✅ Best Practices

* Always use **HTTPS (443)** for production environments.
* Avoid using default ports in **internal/test setups** — helps prevent conflicts and improves security.
* Update **firewall and security group rules** accordingly when changing ports.

---

### 💡 In short

IIS runs on **port 80 (HTTP)** and **443 (HTTPS)** by default.
Use HTTPS for secure connections and customize ports via **IIS bindings** if needed.

---
## Q: What is a Domain Controller (DC)?

---

### 🧠 Overview

A **Domain Controller (DC)** is a **Windows Server** that manages **authentication, authorization, and security policies** within an **Active Directory (AD)** domain.
It stores and enforces the **Active Directory database (NTDS.dit)** — which contains users, groups, and computer objects.

---

### ⚙️ Purpose / How it works

* Acts as the **central authority** for verifying user credentials and granting access.
* Uses **Kerberos** and **NTLM** protocols for authentication.
* Replicates AD data across multiple DCs for **redundancy** and **fault tolerance**.
* Manages:

  * **User login validation**
  * **Password policies**
  * **Group memberships**
  * **Access control lists (ACLs)**
  * **DNS integration** (since AD relies heavily on DNS)

---

### 🧩 Examples / Commands / Config snippets

#### 🖥️ Promote a Server to Domain Controller

```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "example.local"
```

#### 🧾 Verify DC Status

```powershell
dcdiag /v
```

#### 🔍 Check all Domain Controllers in Domain

```powershell
Get-ADDomainController -Filter *
```

#### 🔁 Force Replication Between DCs

```powershell
repadmin /syncall /AdeP
```

---

### 📋 Key Domain Controller Roles

| Role                          | Description                                                                            |
| ----------------------------- | -------------------------------------------------------------------------------------- |
| **Primary DC (PDC Emulator)** | Handles password changes, time sync, and GPO updates.                                  |
| **Backup DC (BDC)**           | Receives replicated data from PDC for redundancy.                                      |
| **Global Catalog (GC)**       | Stores a partial replica of all domain objects for faster lookups.                     |
| **FSMO Roles**                | Special roles (Schema Master, RID Master, etc.) managing unique domain-wide functions. |

---

### ✅ Best Practices

* Always have **at least two DCs** per domain for redundancy.
* Enable **regular AD replication monitoring** (`repadmin /replsummary`).
* Back up the **System State** regularly.
* Use **strong password and lockout policies**.
* Keep DCs on **isolated, secured subnets** and patched regularly.

---

### 💡 In short

A **Domain Controller** is the **core security and identity server** in a Windows domain.
It authenticates users, enforces policies, and synchronizes identity data through **Active Directory** — making it the backbone of enterprise Windows networks.

---
## Q: What is Active Directory (AD)?

---

### 🧠 Overview

**Active Directory (AD)** is a **directory service** developed by **Microsoft** that stores, organizes, and manages information about network resources — such as **users, computers, groups, and policies** — within a **Windows domain environment**.
It’s the **centralized identity and access management (IAM)** system in enterprise Windows networks.

---

### ⚙️ Purpose / How it works

* AD provides **authentication (who you are)** and **authorization (what you can access)**.
* Operates on a **hierarchical database** structure (Forest → Domain → Organizational Unit → Objects).
* Uses **LDAP (Lightweight Directory Access Protocol)** and **Kerberos** for communication and authentication.
* Works closely with **Domain Controllers (DCs)** to replicate and enforce security policies across the network.

---

### 🧩 Examples / Commands / Config snippets

#### 🧱 Install Active Directory Domain Services (AD DS)

```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "corp.example.com"
```

#### 🔍 View AD Users and Groups

```powershell
Get-ADUser -Filter * | Select-Object Name, Enabled
Get-ADGroup -Filter * | Select-Object Name
```

#### 🏢 Add a New User to AD

```powershell
New-ADUser -Name "Vasu DevOps" -SamAccountName "vasu" -AccountPassword (Read-Host -AsSecureString "Enter Password") -Enabled $true
```

---

### 📋 Active Directory Structure

| Level                        | Description                                                                     |
| ---------------------------- | ------------------------------------------------------------------------------- |
| **Forest**                   | Top-level AD container that holds one or more domains.                          |
| **Domain**                   | Logical group of network objects (users, computers).                            |
| **Organizational Unit (OU)** | Subdivision within a domain for organizing objects and applying Group Policies. |
| **Objects**                  | Actual items like users, computers, printers, and groups.                       |

---

### 📋 Key Active Directory Services

| Service    | Description                                            |
| ---------- | ------------------------------------------------------ |
| **AD DS**  | Core directory service managing user/computer data.    |
| **AD LDS** | Lightweight version without domain dependencies.       |
| **AD FS**  | Enables single sign-on (SSO) across apps and services. |
| **AD CS**  | Manages certificates (PKI).                            |
| **AD RMS** | Protects digital information via rights management.    |

---

### ✅ Best Practices

* Maintain **multiple DCs** for fault tolerance.
* Enforce **Group Policy Objects (GPOs)** for centralized management.
* Implement **Role-Based Access Control (RBAC)** using groups.
* Regularly **audit logons and AD changes**.
* Backup **System State** and **AD database** regularly.

---

### 💡 In short

**Active Directory** is Microsoft’s **central identity and access management system**, controlling **who can log in**, **what they can access**, and **how policies are enforced** across Windows domains.
It’s the backbone of **enterprise authentication, authorization, and security policy management**.

---
## Q: What is DNS and why is it used in Active Directory (AD)?

---

### 🧠 Overview

**DNS (Domain Name System)** is a **naming service** that translates **human-readable domain names** (e.g., `example.com`) into **IP addresses** (e.g., `192.168.1.10`).
In **Active Directory (AD)**, DNS is **critical** because AD relies on DNS to **locate Domain Controllers**, **replicate data**, and **authenticate users** across the network.

---

### ⚙️ Purpose / How it works

* AD uses **DNS SRV (Service) records** to find domain services like:

  * `_ldap._tcp.dc._msdcs.<domain>` → locates domain controllers
  * `_kerberos._tcp.<domain>` → locates Kerberos authentication services
* When a user logs into the domain, the client queries DNS to find a **DC (Domain Controller)** for authentication.
* Without DNS, **Active Directory can’t function properly**, since clients and DCs wouldn’t be able to communicate or replicate.

---

### 🧩 Examples / Commands / Config snippets

#### 🔍 Check AD DNS Records

```powershell
nslookup -type=SRV _ldap._tcp.dc._msdcs.corp.local
```

#### 🧱 Install DNS Server Role (on DC)

```powershell
Install-WindowsFeature DNS -IncludeManagementTools
```

#### 🌐 Add a DNS Zone for AD Domain

```powershell
Add-DnsServerPrimaryZone -Name "corp.local" -ReplicationScope "Domain"
```

#### 🧭 View DNS Configuration

```powershell
Get-DnsServerZone
Get-DnsServerResourceRecord -ZoneName "corp.local"
```

---

### 📋 Relationship Between DNS and AD

| Feature             | Role in Active Directory                         |
| ------------------- | ------------------------------------------------ |
| **DNS Zone**        | Stores AD domain name and related records.       |
| **SRV Records**     | Help clients find services (LDAP, Kerberos, GC). |
| **A Records**       | Map hostnames (e.g., DC01) to IP addresses.      |
| **Dynamic Updates** | Automatically register new computers into DNS.   |
| **Replication**     | DNS records replicate along with AD data.        |

---

### ✅ Best Practices

* Use **AD-integrated DNS zones** → they replicate securely with AD.
* Enable **dynamic updates** for automatic record registration.
* Ensure all **clients point to internal DNS servers**, not public ones.
* Regularly verify **SRV and A records** for all DCs.
* Back up DNS zones with AD backups.

---

### 💡 In short

**DNS is the backbone of Active Directory communication.**
It lets clients and servers **locate domain controllers**, **authenticate users**, and **replicate data**. Without DNS, AD can’t resolve or find domain services, breaking authentication and replication.

----
## Q: What is Group Policy?

---

### 🧠 Overview

**Group Policy (GP)** is a **feature of Active Directory (AD)** that provides **centralized management and configuration** of operating systems, applications, and user settings across a Windows domain.
It allows administrators to **enforce security, configuration, and access control policies** for users and computers.

---

### ⚙️ Purpose / How it works

* Group Policy works by applying **Group Policy Objects (GPOs)** to **containers** like:

  * **Sites**
  * **Domains**
  * **Organizational Units (OUs)**
* When a user logs in or a computer starts up, AD delivers GPOs that control:

  * Password rules
  * Software deployment
  * Desktop restrictions
  * Network and firewall settings
* GPOs are processed in the order:
  **Local → Site → Domain → OU** (LSDOU)

---

### 🧩 Examples / Commands / Config snippets

#### 🧱 Create a New GPO and Link It

```powershell
# Create a new GPO
New-GPO -Name "PasswordPolicy" -Comment "Strong password enforcement"

# Link the GPO to an OU
New-GPLink -Name "PasswordPolicy" -Target "OU=Users,DC=corp,DC=local"
```

#### 🔍 List Applied GPOs for a System

```powershell
gpresult /r
```

#### 🌀 Force Group Policy Update

```powershell
gpupdate /force
```

#### ⚙️ Common Group Policy Path

> **Run → gpedit.msc** → Configure user/computer policies

---

### 📋 Key Components

| Component                        | Description                                           |
| -------------------------------- | ----------------------------------------------------- |
| **GPO (Group Policy Object)**    | A set of rules applied to users/computers.            |
| **Group Policy Container (GPC)** | Stored in AD (policy metadata).                       |
| **Group Policy Template (GPT)**  | Stored in SYSVOL (policy data/files).                 |
| **OU (Organizational Unit)**     | Logical grouping of AD objects where GPOs are linked. |

---

### 📋 Examples of Group Policy Settings

| Category                | Example Policy                          |
| ----------------------- | --------------------------------------- |
| **Security**            | Enforce password length and complexity. |
| **Software Deployment** | Auto-install MSI packages.              |
| **User Restrictions**   | Disable Control Panel or USB ports.     |
| **Windows Update**      | Force automatic patch installation.     |
| **Network**             | Configure proxy or firewall rules.      |

---

### ✅ Best Practices

* Apply GPOs to **OUs** — avoid linking directly to the domain root.
* Use **security filtering** or **WMI filters** for targeted application.
* Document all GPOs and their purposes.
* Avoid excessive GPOs — too many can slow down login/startup times.
* Regularly test GPOs in **staging OUs** before production rollout.

---

### 💡 In short

**Group Policy** is the **centralized configuration system** of Active Directory.
It enforces security, software, and user settings across domain systems — ensuring **consistency, compliance, and control** in enterprise Windows environments.

---
## Q: What is an Organizational Unit (OU)?

---

### 🧠 Overview

An **Organizational Unit (OU)** is a **container within Active Directory (AD)** used to organize and manage **users, groups, computers, and other OUs** logically within a domain.
OUs help structure AD for **delegated administration** and **targeted Group Policy application**.

---

### ⚙️ Purpose / How it works

* OUs group AD objects by **department, location, or function** (e.g., HR, IT, Finance).
* Administrators can:

  * **Delegate permissions** (e.g., allow HR to reset passwords for HR users only).
  * **Apply Group Policies (GPOs)** at the OU level for specific users or computers.
* OUs exist **within a domain** — they cannot span multiple domains.

---

### 🧩 Examples / Commands / Config snippets

#### 🧱 Create an OU using PowerShell

```powershell
New-ADOrganizationalUnit -Name "IT" -Path "DC=corp,DC=local" -ProtectedFromAccidentalDeletion $true
```

#### 🔍 List All OUs

```powershell
Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName
```

#### 🧭 Move a User into an OU

```powershell
Move-ADObject -Identity "CN=John Doe,DC=corp,DC=local" -TargetPath "OU=IT,DC=corp,DC=local"
```

#### 🧩 Example AD Structure

```
corp.local
 ├── OU=IT
 │     ├── Users
 │     └── Computers
 ├── OU=Finance
 └── OU=HR
```

---

### 📋 Key Differences: OU vs Container

| Feature                  | OU (Organizational Unit)  | Container (Built-in)                          |
| ------------------------ | ------------------------- | --------------------------------------------- |
| **Purpose**              | Custom logical grouping   | Default system group (e.g., Users, Computers) |
| **Can apply GPOs?**      | ✅ Yes                     | ❌ No                                          |
| **Delegation possible?** | ✅ Yes                     | ❌ No                                          |
| **Typical Use Case**     | Departmental organization | System-level storage                          |

---

### ✅ Best Practices

* Use **OUs** to mirror **organizational hierarchy** (e.g., Dept → Teams).
* Apply **GPOs at the OU level** for clarity and control.
* Protect OUs from **accidental deletion** using PowerShell or ADUC.
* Avoid deep nesting (over 5 levels) to keep **policy processing fast**.
* Delegate admin rights **per OU** to limit privileges.

---

### 💡 In short

An **Organizational Unit (OU)** is a logical container in AD used to group users, computers, and resources.
It enables **delegation, structure, and targeted Group Policy application** — making AD easier to manage in large enterprises.

--- 
## Q: What are Service Accounts?

---

### 🧠 Overview

**Service Accounts** are **special user accounts** in **Active Directory (AD)** or Windows systems that are used to **run services, applications, or scheduled tasks** — not for human logins.
They provide **secure, isolated identities** for system services (like IIS, SQL Server, or Jenkins) to access resources.

---

### ⚙️ Purpose / How it works

* A **service account** allows applications to run with the **minimum privileges** required.
* These accounts are typically used for:

  * Windows services (e.g., `SQLSERVERAGENT`, `MSSQLSERVER`)
  * IIS application pools
  * Scheduled tasks or background jobs
  * CI/CD tools (e.g., Jenkins, GitLab Runners)
* AD-based service accounts can **automatically manage passwords** and **SPNs** (Service Principal Names).

---

### 🧩 Examples / Commands / Config snippets

#### 🧱 Create a Manual (Standard) Service Account

```powershell
New-ADUser -Name "svc_iis_app" -SamAccountName "svc_iis_app" `
-AccountPassword (Read-Host -AsSecureString "Enter Password") -Enabled $true
```

#### ⚙️ Assign Service Account to a Windows Service

```powershell
sc config "MyService" obj= "corp\svc_iis_app" password= "P@ssw0rd!"
```

#### 🧩 Example: Create a Managed Service Account (MSA)

```powershell
Install-WindowsFeature AD-Service-Account
New-ADServiceAccount -Name "svc_jenkins" -DNSHostName "jenkins.corp.local"
Add-ADComputerServiceAccount -Identity "JENKINS-SRV1" -ServiceAccount "svc_jenkins"
```

#### 🔍 Verify MSA on Server

```powershell
Test-ADServiceAccount svc_jenkins
```

---

### 📋 Types of Service Accounts

| Type                                     | Description                                  | Password Management | Scope             |
| ---------------------------------------- | -------------------------------------------- | ------------------- | ----------------- |
| **User Service Account**                 | Standard AD user used by services.           | Manual              | Single server     |
| **Managed Service Account (MSA)**        | Auto-managed account by AD.                  | Automatic           | Single server     |
| **Group Managed Service Account (gMSA)** | Shared managed account for multiple servers. | Automatic           | Multi-server      |
| **Virtual Account**                      | Built-in local account, no password.         | System-managed      | Local system only |

---

### ✅ Best Practices

* Use **gMSAs** for clustered or distributed services (e.g., IIS, SQL, Jenkins).
* Avoid using **domain admin accounts** for services.
* Apply **“Log on as a service”** rights to the service account only.
* Regularly **audit service accounts** and disable unused ones.
* Enforce **least privilege** — give only the required permissions.
* For manual accounts, **rotate passwords** periodically.

---

### 💡 In short

**Service Accounts** are **non-human AD or local accounts** used to run services securely.
Use **Managed (MSA/gMSA)** accounts where possible for **automatic password rotation and higher security** — a key practice in enterprise DevOps and Windows environments.

---
## Q: How to Check IIS Version?

---

### 🧠 Overview

You can check your **IIS (Internet Information Services)** version using multiple methods — through **GUI, PowerShell, CMD, or configuration files**.
This is useful for verifying compatibility, troubleshooting, or ensuring the right IIS features are installed on a Windows Server.

---

### ⚙️ Purpose / How it works

IIS version details are stored in **Windows components**, **registry**, or **the `inetmgr` console**.
You can use **CLI tools** or **system files** to quickly check the installed version.

---

### 🧩 Examples / Commands / Config snippets

#### 🪟 1. Check IIS Version via GUI

* Press **`Win + R` → `inetmgr`** to open **IIS Manager**
* Click **Help → About Internet Information Services**

  > Displays the version (e.g., *IIS 10.0*)

---

#### ⚙️ 2. Using PowerShell

```powershell
Get-ItemProperty -Path "HKLM:\Software\Microsoft\InetStp\" | Select-Object MajorVersion, MinorVersion
```

✅ Output Example:

```
MajorVersion MinorVersion
------------ ------------
10           0
```

> IIS 10.0 → Windows Server 2016/2019/2022

---

#### 🧩 3. Using Command Prompt

```cmd
%SystemRoot%\System32\inetsrv\InetMgr.exe
```

If IIS opens, it’s installed. To check version:

```cmd
reg query "HKLM\Software\Microsoft\InetStp" /v VersionString
```

✅ Output Example:

```
VersionString    REG_SZ    Version 10.0
```

---

#### 🗂️ 4. Check `iisver.ini` File

```cmd
type "%SystemRoot%\System32\inetsrv\iisver.ini"
```

✅ Example Output:

```
[IIS]
MajorVersion=10
MinorVersion=0
```

---

### 📋 IIS Version Reference Table

| IIS Version | Windows Version              |
| ----------- | ---------------------------- |
| IIS 10.0    | Windows 10 / Server 2016+    |
| IIS 8.5     | Windows 8.1 / Server 2012 R2 |
| IIS 8.0     | Windows 8 / Server 2012      |
| IIS 7.5     | Windows 7 / Server 2008 R2   |
| IIS 7.0     | Windows Vista / Server 2008  |
| IIS 6.0     | Windows Server 2003          |

---

### ✅ Best Practices

* Always use **IIS 10.0 or later** for better **HTTP/2, TLS, and security support**.
* Keep IIS patched via **Windows Update**.
* Verify version compatibility before deploying **ASP.NET, PHP, or reverse proxy configurations**.

---

### 💡 In short

To check IIS version:

```powershell
Get-ItemProperty "HKLM:\Software\Microsoft\InetStp\" | Select MajorVersion, MinorVersion
```

Most modern servers run **IIS 10.0**, bundled with **Windows Server 2016+** — always confirm version before applying modules or updates.

---
## Q: How to Restart IIS?

---

### 🧠 Overview

Restarting **IIS (Internet Information Services)** helps refresh web applications, clear stuck worker processes, and apply configuration or deployment changes without rebooting the entire server.
You can restart IIS using **Command Prompt**, **PowerShell**, or the **IIS Manager GUI**.

---

### ⚙️ Purpose / How it works

When you restart IIS:

* It **stops and restarts** all **application pools**, **websites**, and **services** (like `W3SVC`).
* The **worker processes (`w3wp.exe`)** are terminated and relaunched.
* It’s equivalent to a controlled restart of the entire web server subsystem.

---

### 🧩 Examples / Commands / Config snippets

#### ⚙️ 1. Restart IIS (Command Prompt)

```cmd
iisreset /restart
```

✅ **Output Example:**

```
Attempting stop...
Internet services successfully stopped
Attempting start...
Internet services successfully restarted
```

* `/stop` → Stops IIS services
* `/start` → Starts IIS services
* `/status` → Shows IIS status

---

#### 💻 2. Using PowerShell

```powershell
Restart-Service W3SVC
```

or to restart all IIS-related services:

```powershell
Restart-Service WAS, W3SVC
```

> `WAS` (Windows Process Activation Service) manages application pools.

---

#### 🪟 3. Using IIS Manager (GUI)

1. Open **IIS Manager** → Select server node
2. Click **"Restart"** in the right-side **Actions pane**

---

#### 🔄 4. Restart a Specific Site (Optional)

```powershell
Stop-WebSite -Name "Default Web Site"
Start-WebSite -Name "Default Web Site"
```

---

### 📋 Common IIS Reset Commands

| Command             | Description                       |
| ------------------- | --------------------------------- |
| `iisreset /restart` | Stops and restarts IIS completely |
| `iisreset /stop`    | Stops IIS services                |
| `iisreset /start`   | Starts IIS services               |
| `iisreset /status`  | Checks if IIS is running          |

---

### ✅ Best Practices

* Prefer **recycling only the affected Application Pool** (`Restart-WebAppPool`) for minimal downtime.
* Avoid running `iisreset` on **production servers** during active traffic — it restarts all sites.
* Schedule restarts during **maintenance windows**.
* Monitor event logs after restart to confirm services started cleanly.

---

### 💡 In short

Restart IIS via:

```cmd
iisreset /restart
```

or

```powershell
Restart-Service W3SVC
```

It stops and restarts all web services — useful after configuration, deployment, or performance issues. For production, prefer **application pool recycle** over full restart.

---
## Q: How to Host a Website on IIS?

---

### 🧠 Overview

Hosting a website on **IIS (Internet Information Services)** means deploying your web files (HTML, ASP.NET, PHP, etc.) on a Windows Server and configuring IIS to **serve them over HTTP/HTTPS**.
IIS provides a scalable, secure platform for hosting **internal portals, web APIs, and public sites**.

---

### ⚙️ Purpose / How it works

IIS hosts websites by binding a **site name**, **port**, and **physical directory** to serve content.
When a client requests a URL, IIS maps it to the correct site and delivers the corresponding web files through the **HTTP protocol**.

---

### 🧩 Step-by-Step Setup

#### 🪟 **1. Install IIS**

```powershell
Install-WindowsFeature -name Web-Server -IncludeManagementTools
```

Verify installation:

```cmd
iisreset /status
```

> Open **[http://localhost](http://localhost)** — you should see the default IIS welcome page.

---

#### 📁 **2. Prepare Website Files**

* Create a folder for your site:

  ```
  C:\inetpub\mywebsite
  ```
* Place your site files:

  ```
  index.html, app.js, style.css, web.config, etc.
  ```

---

#### ⚙️ **3. Add a New Website in IIS Manager**

1. Open **IIS Manager** → Right-click **Sites** → **Add Website**
2. Fill in details:

   * **Site name:** `MyWebsite`
   * **Physical path:** `C:\inetpub\mywebsite`
   * **Binding:** `http`, **IP:** `All Unassigned`, **Port:** `80`
   * **Host name (optional):** `myapp.local`
3. Click **OK**

✅ The website will now appear under the *Sites* tree.

---

#### 🔐 **4. (Optional) Add HTTPS Binding**

To enable SSL/TLS:

```powershell
New-WebBinding -Name "MyWebsite" -Protocol https -Port 443
```

Then assign a certificate:

```powershell
netsh http add sslcert hostnameport=myapp.local:443 certhash=<CertHash> appid={<AppID>}
```

---

#### 🔁 **5. Test the Site**

Open browser → `http://localhost` or `http://<server-ip>`
If DNS is configured → `http://myapp.local`

---

### 📋 IIS Website Components

| Component            | Description                                       |
| -------------------- | ------------------------------------------------- |
| **Site Name**        | Logical identifier for the hosted site            |
| **Application Pool** | Isolates web apps for security and reliability    |
| **Binding**          | Defines protocol, port, and hostname              |
| **Physical Path**    | Points to the site’s root folder                  |
| **Authentication**   | Controls access (Anonymous, Windows, Basic, etc.) |

---

### ✅ Best Practices

* Use **HTTPS (port 443)** for all public or internal sites.
* Create **separate Application Pools** for each site.
* Keep file permissions minimal — use **`IIS_IUSRS`** for access.
* Enable **request filtering and logging**.
* Automate deployments with **Web Deploy**, **CI/CD (Jenkins, GitHub Actions)**, or **Terraform IIS module**.

---

### 💡 In short

To host a website on IIS:

1. Install IIS → `Install-WindowsFeature Web-Server`
2. Place site files in `C:\inetpub\<site>`
3. Add new site via **IIS Manager** or PowerShell
4. Bind to **port 80/443** and test on `http://localhost`

IIS then serves your web files securely and reliably to users over the network.

---
## Q: What is an Application Pool in IIS?

---

### 🧠 Overview

An **Application Pool** in **IIS (Internet Information Services)** is a **container that isolates one or more web applications** for better **security, reliability, and resource management**.
Each Application Pool runs in its own **worker process (`w3wp.exe`)**, preventing one faulty app from affecting others.

---

### ⚙️ Purpose / How it works

* When you host multiple sites in IIS, each can have a **dedicated Application Pool**.
* IIS uses a **worker process** per pool to handle requests.
* If an app crashes or leaks memory, only that pool restarts — others remain unaffected.
* Application Pools define:

  * **Runtime version** (e.g., .NET CLR v4.0)
  * **Pipeline mode** (Integrated or Classic)
  * **Identity** (security account under which the app runs)
  * **Recycling** and **Idle Time-out policies**

---

### 🧩 Examples / Commands / Config snippets

#### 🧱 Create a New Application Pool

```powershell
New-WebAppPool -Name "MyAppPool"
```

#### ⚙️ Configure Runtime and Mode

```powershell
Set-ItemProperty IIS:\AppPools\MyAppPool -Name "managedRuntimeVersion" -Value "v4.0"
Set-ItemProperty IIS:\AppPools\MyAppPool -Name "managedPipelineMode" -Value "Integrated"
```

#### 🔍 View All Application Pools

```powershell
Get-WebAppPoolState *
```

#### 🔄 Recycle or Restart an App Pool

```powershell
Restart-WebAppPool -Name "MyAppPool"
Recycle-WebAppPool -Name "MyAppPool"
```

#### 🧩 Assign a Website to an App Pool

```powershell
Set-ItemProperty "IIS:\Sites\MyWebsite" -Name "applicationPool" -Value "MyAppPool"
```

---

### 📋 Application Pool Components

| Component                     | Description                                        |
| ----------------------------- | -------------------------------------------------- |
| **Worker Process (w3wp.exe)** | Runs web apps within the pool                      |
| **Application Pool Identity** | The security context (user/service account)        |
| **Recycling**                 | Automatically restarts the pool to free resources  |
| **Idle Timeout**              | Stops pool after inactivity                        |
| **Pipeline Mode**             | Integrated (modern) or Classic (legacy ISAPI mode) |

---

### 📋 Comparison: Shared vs. Dedicated Pool

| Setup              | Description                   | Use Case                            |
| ------------------ | ----------------------------- | ----------------------------------- |
| **Shared Pool**    | Multiple sites share one pool | Small static sites or same app type |
| **Dedicated Pool** | One site per pool             | Production or sensitive apps        |

---

### ✅ Best Practices

* Always use **dedicated pools** for critical apps.
* Schedule **periodic recycling** during low-traffic hours.
* Run pools under **least-privilege service accounts** (not LocalSystem).
* Monitor **CPU/memory usage** per pool via **IIS Manager → Worker Processes**.
* Use **“Start Automatically”** to ensure auto-start after server reboot.

---

### 💡 In short

An **Application Pool** isolates web apps within IIS, each running in its own **`w3wp.exe` worker process**.
It improves **stability, security, and performance** — a best practice is to assign **one pool per major web app** in production.

---
## Q: How Do You Configure HTTPS on IIS?

---

### 🧠 Overview

Configuring **HTTPS (SSL/TLS)** in **IIS (Internet Information Services)** secures communication between the client and the web server by **encrypting HTTP traffic**.
This prevents data theft, man-in-the-middle attacks, and ensures trust and compliance.

---

### ⚙️ Purpose / How it works

* HTTPS uses **SSL/TLS certificates** to encrypt traffic on **port 443**.
* IIS binds a certificate to a specific **site, IP address, and port**.
* The browser verifies the certificate’s authenticity before establishing a secure connection.
* Certificates can be:

  * **Self-signed** (for testing)
  * **CA-issued** (for production)
  * **Wildcard or SAN** (for multiple domains)

---

### 🧩 Step-by-Step: Configure HTTPS in IIS

#### 🪟 **1. Obtain or Create an SSL Certificate**

**Option 1: Generate a self-signed certificate (for test)**

```powershell
New-SelfSignedCertificate -DnsName "myapp.local" -CertStoreLocation "cert:\LocalMachine\My"
```

**Option 2: Import a CA-issued certificate**

```powershell
Import-PfxCertificate -FilePath "C:\certs\myapp.pfx" -CertStoreLocation "cert:\LocalMachine\My"
```

---

#### ⚙️ **2. Open IIS Manager**

* Run → `inetmgr`
* Expand server node → Go to **Sites**
* Select the site you want to secure

---

#### 🔒 **3. Add HTTPS Binding**

1. Click **“Bindings”** → **Add**
2. Choose:

   * **Type:** `https`
   * **IP address:** `All Unassigned` or specific IP
   * **Port:** `443`
   * **SSL certificate:** Select from dropdown
3. Click **OK** to apply.

---

#### 🔁 **4. Test the HTTPS Configuration**

Open browser → `https://myapp.local`
If the certificate is valid, you’ll see a **secure padlock 🔒** in the address bar.
If using a self-signed cert, accept the browser’s warning for local testing.

---

### 🧩 (Optional) Configure via PowerShell

```powershell
New-WebBinding -Name "MyWebsite" -Protocol https -Port 443 -SslFlags 1
netsh http add sslcert hostnameport=myapp.local:443 certhash=<CertHash> appid={<AppID>}
```

To get `CertHash`:

```powershell
Get-ChildItem cert:\LocalMachine\My
```

---

### 📋 HTTPS Configuration Reference

| Setting              | Description                                             |
| -------------------- | ------------------------------------------------------- |
| **Protocol**         | HTTPS                                                   |
| **Port**             | 443                                                     |
| **Certificate Type** | Self-signed / CA-issued / Wildcard                      |
| **SSL Flags**        | 0 = IP-based, 1 = SNI-based (multiple sites on same IP) |
| **Store Location**   | cert:\LocalMachine\My                                   |

---

### ✅ Best Practices

* Use **SNI (Server Name Indication)** for hosting multiple HTTPS sites on one IP.
* Always use **CA-signed** certificates in production.
* Enable **HTTP to HTTPS redirection** via URL Rewrite or HSTS.
* Renew certificates before expiry using **Certbot**, **ACME**, or **AWS Certificate Manager**.
* Enforce **strong ciphers and TLS 1.2+** only.

---

### 💡 In short

To configure HTTPS on IIS:

1. Get or import an SSL certificate
2. Add an **HTTPS binding** in IIS Manager on **port 443**
3. Assign the certificate and test `https://yourdomain`

👉 HTTPS secures your IIS site with **SSL/TLS encryption**, ensuring **data integrity and user trust**.

---
## Q: How to Redirect HTTP to HTTPS in IIS?

---

### 🧠 Overview

Redirecting **HTTP (port 80)** to **HTTPS (port 443)** ensures all client requests are **encrypted and secure**.
In **IIS (Internet Information Services)**, this can be done using **URL Rewrite**, **HTTP Redirect**, or **web.config rules** — depending on setup requirements.

---

### ⚙️ Purpose / How it works

* HTTP requests are intercepted and redirected to the HTTPS version of the same URL.
* The redirect can be **temporary (302)** or **permanent (301)**.
* Commonly done to enforce **security compliance (TLS)** and prevent **mixed-content issues**.
* IIS handles this via modules or rewrite rules at the **server** or **site** level.

---

### 🧩 Method 1: Using IIS **URL Rewrite Module** (Recommended)

#### 🔧 Step-by-Step

1. Install **URL Rewrite Module** (if not already installed):
   [Download from Microsoft](https://www.iis.net/downloads/microsoft/url-rewrite)
2. Open **IIS Manager** → Select your site
3. Double-click **“URL Rewrite”** → **Add Rules…** → Choose **Blank Rule**
4. Configure as follows:

   * **Condition:** `{HTTPS}` equals `off`
   * **Action:** Redirect → URL: `https://{HTTP_HOST}/{R:1}`
   * **Redirect type:** `Permanent (301)`

---

#### 🧩 Example web.config Rule

```xml
<configuration>
  <system.webServer>
    <rewrite>
      <rules>
        <rule name="HTTP to HTTPS Redirect" stopProcessing="true">
          <match url="(.*)" ignoreCase="true" />
          <conditions>
            <add input="{HTTPS}" pattern="off" ignoreCase="true" />
          </conditions>
          <action type="Redirect" url="https://{HTTP_HOST}/{R:1}" redirectType="Permanent" />
        </rule>
      </rules>
    </rewrite>
  </system.webServer>
</configuration>
```

---

### 🧩 Method 2: Using IIS **HTTP Redirect Feature**

#### 🪟 Steps

1. Open **IIS Manager** → Select your **HTTP site (port 80)**
2. Double-click **HTTP Redirect**
3. Check:

   * ✅ “Redirect requests to this destination” → `https://yourdomain.com`
   * ✅ “Redirect all requests to exact destination”
   * ✅ “Permanent (301)”
4. Click **Apply** (top right corner)

> ⚠️ This method redirects all requests to a single domain (less flexible than URL Rewrite).

---

### 🧩 Method 3: PowerShell (Automation)

```powershell
Add-WebConfigurationProperty -pspath 'IIS:\Sites\MyWebsite' `
  -filter "system.webServer/rewrite/rules" `
  -name "." -value @{
    name = "HTTP to HTTPS Redirect";
    patternSyntax = "ECMAScript";
    stopProcessing = "true";
    match = @{ url = "(.*)" };
    conditions = @{ add = @(@{ input = "{HTTPS}"; pattern = "off" }) };
    action = @{ type = "Redirect"; url = "https://{HTTP_HOST}/{R:1}"; redirectType = "Permanent" }
  }
```

---

### 📋 Comparison of Redirect Methods

| Method              | Flexibility | Best For                   | Config Scope          |
| ------------------- | ----------- | -------------------------- | --------------------- |
| **URL Rewrite**     | ⭐⭐⭐⭐        | Most control, regex rules  | Per site / web.config |
| **HTTP Redirect**   | ⭐⭐          | Simple one-domain redirect | Site level only       |
| **web.config edit** | ⭐⭐⭐         | CI/CD / code deployment    | App-level config      |

---

### ✅ Best Practices

* Always use **301 Permanent Redirects** for SEO and browser caching.
* Test redirect after enabling HTTPS to avoid **redirect loops**.
* Combine with **HSTS headers** for stricter HTTPS enforcement:

  ```xml
  <add name="Strict-Transport-Security" value="max-age=31536000; includeSubDomains" />
  ```
* Use **SNI (Server Name Indication)** when hosting multiple HTTPS sites.
* Validate redirect rules after deployment using:

  ```bash
  curl -I http://yourdomain.com
  ```

---

### 💡 In short

To redirect HTTP → HTTPS in IIS:

* Install **URL Rewrite Module**
* Add a rule that checks `{HTTPS} == off` and redirects to `https://{HTTP_HOST}/{R:1}`

This enforces **secure, encrypted connections** site-wide with a **301 permanent redirect** — the recommended best practice for all IIS-hosted web apps.

---
## Q: How to Troubleshoot Website 500 or 503 Errors in IIS

---

### 🧠 Overview

**500 (Internal Server Error)** and **503 (Service Unavailable)** are common IIS errors indicating **server-side issues**.

* **500** → Application or configuration failure.
* **503** → Application Pool or service unavailable (IIS cannot process requests).

These typically occur due to **misconfigurations, code errors, permission issues**, or **app pool crashes**.

---

### ⚙️ Purpose / How it works

When a client hits an IIS-hosted site:

* IIS routes the request to the correct **Application Pool** → handled by a **worker process (`w3wp.exe`)**.
* A **500** occurs when the **worker process is running** but encounters a **runtime or config error**.
* A **503** occurs when the **Application Pool is stopped, misconfigured, or crashed** before handling the request.

---

### 🧩 Common Root Causes & Fixes

| Error                           | Cause                                                    | Fix                                                    |
| ------------------------------- | -------------------------------------------------------- | ------------------------------------------------------ |
| **500 – Internal Server Error** | Faulty web.config, missing modules, unhandled exceptions | Check **Event Viewer**, enable **detailed errors**     |
| **500.19**                      | Corrupted or invalid XML in web.config                   | Validate config syntax, check file permissions         |
| **500.21**                      | ASP.NET module not registered                            | Run `aspnet_regiis -i` or enable required feature      |
| **500.50**                      | URL Rewrite or config failure                            | Disable/review rewrite rules                           |
| **503 – Service Unavailable**   | Application Pool stopped                                 | Start App Pool via IIS Manager or PowerShell           |
| **503.2**                       | Rapid-fail protection triggered                          | Review crash frequency, disable rapid-fail temporarily |
| **503.3**                       | App Pool disabled by admin                               | Start App Pool manually                                |

---

### 🧩 Diagnostic Commands / Steps

#### 🧾 1. Check Application Pool Status

```powershell
Get-WebAppPoolState
```

If **Stopped**, start it:

```powershell
Start-WebAppPool -Name "MyAppPool"
```

---

#### 🧾 2. Review Event Viewer Logs

* Open **Event Viewer → Windows Logs → Application/System**
* Look for:

  * `.NET Runtime` exceptions
  * **WAS (Windows Process Activation Service)** errors
  * **IIS-W3SVC-WP** or **WAS Event ID 5059, 5002, 5011**

---

#### 🧾 3. Enable Detailed Error Pages (for debugging)

In **web.config**:

```xml
<configuration>
  <system.web>
    <customErrors mode="Off" />
    <compilation debug="true" />
  </system.web>
  <system.webServer>
    <httpErrors errorMode="Detailed" />
  </system.webServer>
</configuration>
```

> ⚠️ Use only in **non-production** environments.

---

#### 🧾 4. Check Application Pool Identity & Permissions

```powershell
Get-ItemProperty IIS:\AppPools\MyAppPool | Select-Object name, processModel.identityType
```

Ensure the **identity** (e.g., `ApplicationPoolIdentity` or a service account) has:

* Read permissions on the **site directory**
* Rights to access **config files** and **database connections**

---

#### 🧾 5. Review IIS Logs

Logs are located at:

```
C:\inetpub\logs\LogFiles\W3SVC<site_id>\
```

Look for **HTTP status codes**, **substatus**, and **Win32 error codes**:

```
#Fields: date time s-ip cs-method cs-uri-stem sc-status sc-substatus sc-win32-status
```

---

#### 🧾 6. Restart IIS & Clear Cache

```cmd
iisreset /restart
```

Optionally recycle the application pool:

```powershell
Recycle-WebAppPool -Name "MyAppPool"
```

---

### 📋 Example: 503 Root Cause Analysis

| Step | Check                 | Result                                                 |
| ---- | --------------------- | ------------------------------------------------------ |
| 1    | `Get-WebAppPoolState` | Stopped                                                |
| 2    | Event Viewer          | Event ID 5059: App Pool failed to start                |
| 3    | Fix                   | Corrected invalid path in `web.config`, restarted pool |
| 4    | Verify                | Site responds on `https://localhost` ✅                 |

---

### ✅ Best Practices

* Enable **Failed Request Tracing (FREB)** to capture detailed diagnostics.
* Keep **Application Pools separate** for isolation.
* Use **rapid-fail protection** to detect recurring crashes but fix root causes.
* Regularly check for **Windows & .NET updates**.
* Monitor **IIS logs**, **CPU/memory usage**, and **event logs** proactively.

---

### 💡 In short

**500 errors** = app/config issues; **503 errors** = app pool/service problems.
✅ Check **Event Viewer**, **IIS logs**, **app pool status**, and **web.config syntax**.
Restart IIS or recycle the app pool after resolving the root cause for a clean recovery.

---
## Q: What is AD Replication?

---

### 🧠 Overview

**Active Directory (AD) Replication** is the **process of synchronizing directory data** (users, groups, computers, policies, etc.) between **Domain Controllers (DCs)** within a domain or forest.
It ensures **consistency and availability** of Active Directory information across all DCs.

---

### ⚙️ Purpose / How it works

* AD replication uses a **multi-master model**, meaning **any Domain Controller** can accept changes.
* Updates made on one DC (e.g., user creation) are **propagated automatically** to others.
* Replication happens over **RPC (Remote Procedure Call)** or **SMTP** depending on network setup.
* The **Knowledge Consistency Checker (KCC)** builds and maintains the **replication topology** automatically.

---

### 🧩 Replication Flow

1. Change made on DC1 (e.g., password reset)
2. DC1 updates its **update sequence number (USN)**
3. DC1 notifies replication partners
4. Other DCs pull changes and update their own AD database (`NTDS.dit`)
5. Data becomes consistent across all DCs

---

### 🧩 Commands / Examples

#### 🔍 Check Replication Status

```powershell
repadmin /replsummary
```

#### 📊 View Replication Partners

```powershell
repadmin /showrepl
```

#### 🔁 Force Replication Manually

```powershell
repadmin /syncall /AdeP
```

* **/A** → All naming contexts
* **/d** → Identify servers by distinguished name
* **/e** → Enterprise (across sites)
* **/P** → Push changes immediately

#### 🧭 Check Site Replication Topology

```powershell
repadmin /kcc
```

#### 🧱 Using PowerShell

```powershell
Get-ADReplicationPartnerMetadata -Target DC1 -Scope Domain
```

---

### 📋 Types of Replication

| Type                       | Description                                                                          |
| -------------------------- | ------------------------------------------------------------------------------------ |
| **Intra-site Replication** | Between DCs in the same site; uses RPC over IP; frequent and fast.                   |
| **Inter-site Replication** | Between DCs in different sites; scheduled; can use RPC or SMTP; bandwidth-optimized. |

---

### 📋 Key Components

| Component                               | Description                                                     |
| --------------------------------------- | --------------------------------------------------------------- |
| **USN (Update Sequence Number)**        | Tracks changes on each DC.                                      |
| **KCC (Knowledge Consistency Checker)** | Builds/optimizes replication links.                             |
| **Bridgehead Server**                   | Manages inter-site replication.                                 |
| **Replication Topology**                | The network map defining which DCs replicate with which others. |

---

### ✅ Best Practices

* Place **at least two DCs per site** for redundancy.
* Monitor replication using:

  ```powershell
  repadmin /replsummary
  ```
* Avoid **manual topology changes** unless necessary.
* Configure **site links** with realistic **schedules and costs**.
* Ensure **DNS resolution** works correctly between DCs.
* Regularly back up **System State** for recovery.

---

### 💡 In short

**AD Replication** keeps all Domain Controllers synchronized, ensuring every DC has the same directory data.
It’s **automatic, secure, and fault-tolerant**, using the **multi-master model** managed by the **KCC** — critical for reliable authentication and directory consistency across the enterprise.

---
## Q: How Do You Join a Windows Server to a Domain?

---

### 🧠 Overview

Joining a **Windows Server** to an **Active Directory (AD) domain** allows it to become part of a centralized authentication and policy management system.
Once joined, the server can authenticate users via the **Domain Controller (DC)** and apply **Group Policies**.

---

### ⚙️ Purpose / How it works

* The server communicates with the **Domain Controller** using **Kerberos** and **LDAP**.
* It creates a **computer object** in AD under the **Computers** container (or specified OU).
* After joining, all **authentication and authorization** are handled by AD instead of local accounts.

---

### 🧩 Methods to Join a Domain

#### 🪟 **1. Using System Properties (GUI)**

1. Right-click **This PC → Properties → Advanced system settings**
2. Go to **Computer Name** tab → Click **Change**
3. Select **Domain**, enter domain name (e.g., `corp.local`)
4. Enter **domain admin credentials** when prompted
5. Reboot the server when prompted ✅

---

#### ⚙️ **2. Using PowerShell (Recommended for automation)**

```powershell
Add-Computer -DomainName "corp.local" -Credential (Get-Credential) -Restart
```

> Prompts for domain credentials and automatically restarts after joining.

**Optional parameters:**

```powershell
Add-Computer -DomainName "corp.local" -OUPath "OU=Servers,DC=corp,DC=local" -Credential (Get-Credential) -Restart
```

---

#### 💻 **3. Using Command Prompt**

```cmd
netdom join %computername% /domain:corp.local /userd:corp\adminuser /passwordd:P@ssw0rd
shutdown /r /t 0
```

---

### 🧩 Verify Domain Membership

```powershell
systeminfo | findstr /B /C:"Domain"
```

or

```powershell
(Get-WmiObject Win32_ComputerSystem).Domain
```

✅ Output example:

```
Domain: corp.local
```

---

### 📋 Requirements Checklist

| Requirement              | Description                                                 |
| ------------------------ | ----------------------------------------------------------- |
| **DNS Configuration**    | Server must use the AD DNS server (e.g., DC IP)             |
| **Network Connectivity** | Server must reach Domain Controller (ping or resolve name)  |
| **User Permissions**     | Domain credentials with “Add Workstations to Domain” rights |
| **Firewall Ports**       | Ports 88 (Kerberos), 389 (LDAP), 445 (SMB), 53 (DNS) open   |

---

### ✅ Best Practices

* Always set the **primary DNS** to point to the **Domain Controller’s IP**, not public DNS.
* Place servers in **appropriate OUs** (e.g., “OU=Servers”) for policy management.
* Verify **time synchronization (NTP)** — Kerberos requires ≤5 min time difference.
* Use **PowerShell** for automation in DevOps or infrastructure-as-code environments.
* Reboot after join for **policy and authentication** initialization.

---

### 💡 In short

To join a Windows Server to a domain:

```powershell
Add-Computer -DomainName "corp.local" -Credential (Get-Credential) -Restart
```

Ensure **DNS points to the Domain Controller**, **network connectivity** exists, and **valid credentials** are used.
This securely integrates the server into your **Active Directory environment**.

---
## Q: How to Manage DNS in Windows Server?

---

### 🧠 Overview

**DNS (Domain Name System)** in **Windows Server** resolves hostnames to IP addresses, enabling clients to locate services like **Domain Controllers, websites, and applications**.
Windows Server provides **DNS Manager (GUI)** and **PowerShell** tools to configure and maintain the DNS service.

---

### ⚙️ Purpose / How it works

* DNS maintains **zones**, **records**, and **forwarders** to route traffic efficiently.
* It integrates tightly with **Active Directory (AD)** — creating **AD-integrated zones** that automatically replicate across **Domain Controllers**.
* Clients use these DNS records to locate servers and services on the network.

---

### 🧩 Common DNS Tasks

#### 🧱 1. **Install DNS Server Role**

```powershell
Install-WindowsFeature DNS -IncludeManagementTools
```

Verify installation:

```powershell
Get-WindowsFeature DNS
```

---

#### 🌐 2. **Open DNS Manager (GUI)**

* Run → `dnsmgmt.msc`
* You can now manage:

  * **Forward Lookup Zones** (Name → IP)
  * **Reverse Lookup Zones** (IP → Name)
  * **Resource Records** (A, PTR, CNAME, MX, SRV, etc.)

---

#### ⚙️ 3. **Create a New Forward Lookup Zone**

```powershell
Add-DnsServerPrimaryZone -Name "corp.local" -ReplicationScope "Domain"
```

> Stores host-to-IP mappings for your domain.

---

#### 🔁 4. **Add DNS Records**

**A Record (Host → IP)**

```powershell
Add-DnsServerResourceRecordA -Name "web01" -ZoneName "corp.local" -IPv4Address "192.168.1.20"
```

**CNAME (Alias)**

```powershell
Add-DnsServerResourceRecordCName -Name "intranet" -HostNameAlias "web01.corp.local" -ZoneName "corp.local"
```

**PTR Record (Reverse Lookup)**

```powershell
Add-DnsServerResourceRecordPtr -Name "20" -ZoneName "1.168.192.in-addr.arpa" -PtrDomainName "web01.corp.local"
```

---

#### 🔍 5. **Verify DNS Records**

```powershell
Get-DnsServerResourceRecord -ZoneName "corp.local"
```

Test resolution:

```cmd
nslookup web01.corp.local
```

---

#### 🚀 6. **Configure DNS Forwarders**

Forwarders send unresolved queries to external DNS servers (e.g., Google, Cloudflare).

```powershell
Add-DnsServerForwarder -IPAddress 8.8.8.8,1.1.1.1
```

List forwarders:

```powershell
Get-DnsServerForwarder
```

---

#### 🧭 7. **Enable Dynamic Updates (for AD integration)**

```powershell
Set-DnsServerPrimaryZone -Name "corp.local" -DynamicUpdate Secure
```

> Ensures clients and Domain Controllers automatically register their DNS records.

---

### 📋 Common DNS Record Types

| Record Type | Purpose                                | Example                           |
| ----------- | -------------------------------------- | --------------------------------- |
| **A**       | Maps hostname → IPv4                   | `web01.corp.local → 192.168.1.20` |
| **AAAA**    | Maps hostname → IPv6                   | `web01 → fe80::1`                 |
| **CNAME**   | Alias for another record               | `intranet → web01.corp.local`     |
| **MX**      | Mail exchange record                   | `mail.corp.local`                 |
| **PTR**     | Reverse lookup (IP → name)             | `192.168.1.20 → web01.corp.local` |
| **SRV**     | Service locator (e.g., LDAP, Kerberos) | `_ldap._tcp.dc._msdcs.corp.local` |

---

### ✅ Best Practices

* Use **AD-integrated zones** for redundancy and security.
* Enable **secure dynamic updates** only (prevents spoofing).
* Regularly **back up DNS zones**:

  ```powershell
  dnscmd /zoneexport corp.local corp.local.dns
  ```
* Monitor **Event Viewer → DNS Server Logs** for errors.
* Use **forwarders** to minimize external DNS load.
* Never point internal clients to **public DNS servers** directly — always resolve through your internal DNS.

---

### 💡 In short

Manage DNS in Windows Server via **DNS Manager (`dnsmgmt.msc`)** or PowerShell:

```powershell
Add-DnsServerResourceRecordA -Name "web01" -ZoneName "corp.local" -IPv4Address "192.168.1.20"
```

Use **AD-integrated zones**, **forwarders**, and **secure updates** for a robust, scalable DNS setup in enterprise environments.

---
## Q: What Are AD User Types?

---

### 🧠 Overview

In **Active Directory (AD)**, **user accounts** represent individuals or services that authenticate and access resources in a Windows domain.
AD provides **different types of user accounts** based on their purpose — from regular domain users to administrative and service-level identities.

---

### ⚙️ Purpose / How it works

* Each user in AD has a **unique security identifier (SID)** and **authentication token**.
* AD user accounts define **access rights, group memberships, and permissions**.
* These accounts are used for:

  * Logging into domain-joined machines
  * Running services or applications
  * Applying Group Policy and permissions

---

### 📋 Types of AD User Accounts

| Type                                    | Description                                                                         | Typical Use Case                             |
| --------------------------------------- | ----------------------------------------------------------------------------------- | -------------------------------------------- |
| **Domain User Accounts**                | Created and stored in Active Directory; can log in from any domain-joined system.   | Regular employees, admins                    |
| **Local User Accounts**                 | Created on individual machines, not stored in AD; access only that specific system. | Standalone servers or local-only access      |
| **Built-in Accounts**                   | Predefined accounts created by Windows during installation.                         | System management and service operations     |
| **Service Accounts**                    | Used by applications, services, or scheduled tasks.                                 | Running IIS, SQL Server, Jenkins             |
| **Managed Service Accounts (MSA/gMSA)** | Auto-managed by AD; handle password rotation and SPNs automatically.                | Secure, automated service account management |
| **Guest Accounts**                      | Temporary access for non-domain users; disabled by default.                         | Limited external access or contractors       |

---

### 🧩 Examples / Commands / Config snippets

#### 🧱 1. Create a Domain User

```powershell
New-ADUser -Name "John Doe" -SamAccountName "jdoe" -UserPrincipalName "jdoe@corp.local" `
  -AccountPassword (Read-Host -AsSecureString "Enter Password") -Enabled $true
```

#### 🧱 2. Create a Service Account

```powershell
New-ADUser -Name "svc_sql" -SamAccountName "svc_sql" -Description "SQL Server Service Account" `
  -AccountPassword (Read-Host -AsSecureString "Password") -Enabled $true
```

#### 🧩 3. Create a Managed Service Account

```powershell
New-ADServiceAccount -Name "svc_web" -DNSHostName "web01.corp.local"
```

---

### 📋 Common Built-in AD Accounts

| Account            | Description                                                                         |
| ------------------ | ----------------------------------------------------------------------------------- |
| **Administrator**  | Full control over domain; created during AD setup.                                  |
| **Guest**          | Default disabled; used for anonymous access (avoid enabling).                       |
| **krbtgt**         | Special account for **Kerberos Ticket Granting Service** — do not modify or delete. |
| **DefaultAccount** | Internal system account used by Windows components.                                 |

---

### ✅ Best Practices

* **Disable or rename default Administrator** and Guest accounts for security.
* Use **service accounts (gMSA/MSA)** for apps instead of user accounts.
* Enforce **password policies** and **MFA** for all interactive users.
* Group users logically (e.g., “HR_Users”, “IT_Admins”) for role-based access control (RBAC).
* Audit user logons and **disable inactive accounts** regularly.

---

### 💡 In short

Active Directory includes several user types:

* **Domain users** (for human logins)
* **Local users** (machine-specific)
* **Service & managed service accounts** (for apps/services)
* **Built-in system accounts** (Administrator, Guest, krbtgt)

Each serves a distinct role — use **domain and managed service accounts** for most enterprise environments to ensure **secure, centralized access control**.

---
## Q: What’s the Difference Between a Workgroup and a Domain?

---

### 🧠 Overview

In Windows networking, **Workgroup** and **Domain** are two distinct models for organizing and managing computers.

* A **Workgroup** is a **peer-to-peer** network where each machine manages its own users and settings.
* A **Domain** is a **centralized** network model managed via **Active Directory (AD)** and **Domain Controllers (DCs)**.

---

### ⚙️ Purpose / How it works

| Concept                 | **Workgroup**                         | **Domain**                                                |
| ----------------------- | ------------------------------------- | --------------------------------------------------------- |
| **Architecture**        | Peer-to-peer                          | Client–Server                                             |
| **Control**             | Each computer manages itself          | Centralized management via Domain Controller              |
| **Authentication**      | Local to each system                  | Centralized via AD (Kerberos/LDAP)                        |
| **User Accounts**       | Stored locally on each PC             | Stored in AD; accessible across all domain-joined systems |
| **Group Policies**      | Not supported                         | Enforced via Group Policy Objects (GPOs)                  |
| **Scalability**         | Suitable for small networks (<10 PCs) | Designed for large enterprises (100s–1000s of nodes)      |
| **Security Management** | Manual and isolated                   | Centralized; managed via AD permissions and roles         |
| **Login Type**          | Local username/password               | Domain credentials (e.g., `corp\vasu`)                    |
| **Resource Sharing**    | Must configure individually           | Centrally managed shares and permissions                  |
| **Administration**      | Decentralized                         | Managed by IT admins from DC or GPMC                      |

---

### 🧩 Example Scenarios

#### 🧱 Workgroup

* Small office or home setup with 5–10 PCs.
* Each user logs in locally (`vasu-pc\vasu`).
* No centralized policy, authentication, or security enforcement.

#### 🧱 Domain

* Enterprise or corporate environment (e.g., `corp.local`).
* Users log in using AD credentials (`corp\vasu`).
* Admins control:

  * Password policies
  * Group Policies (firewall, scripts, etc.)
  * Central file sharing and printer access

---

### 🧩 Commands / Config Snippets

#### 🔍 Check if Computer is in Domain or Workgroup

```powershell
systeminfo | findstr /B /C:"Domain"
```

✅ Example output:

```
Domain: WORKGROUP
```

or

```
Domain: corp.local
```

#### 💻 Join a Computer to a Domain

```powershell
Add-Computer -DomainName "corp.local" -Credential (Get-Credential) -Restart
```

---

### ✅ Best Practices

* Use **Workgroup** for home labs, standalone test servers, or small unmanaged environments.
* Use **Domain** for any environment requiring:

  * Centralized user management
  * Group Policy enforcement
  * Security auditing and compliance
* Ensure **DNS** is configured to point to the Domain Controller when joining to a domain.

---

### 💡 In short

| Feature      | **Workgroup** | **Domain**           |
| ------------ | ------------- | -------------------- |
| **Control**  | Local         | Centralized (AD/DC)  |
| **Login**    | Local account | Domain credentials   |
| **Scale**    | Small         | Enterprise           |
| **Security** | Manual        | Centralized policies |

👉 **Workgroup = standalone PCs**; **Domain = centrally managed enterprise network** using **Active Directory** for unified control, authentication, and policy enforcement.

---## Q: How to Secure IIS Web Servers?

---

### 🧠 Overview

Securing an **IIS (Internet Information Services)** web server is crucial to protect against **unauthorized access, data leaks, and web attacks** such as XSS, SQL injection, and privilege escalation.
Security in IIS involves **hardening the OS**, **restricting access**, **configuring HTTPS/TLS**, and **monitoring activity**.

---

### ⚙️ Purpose / How it works

IIS security follows a **defense-in-depth** approach:

1. Harden the Windows server (least privilege, patching).
2. Secure IIS modules, file permissions, and app pools.
3. Enforce HTTPS, authentication, and logging.
4. Continuously monitor and audit access.

---

### 🧩 Step-by-Step IIS Security Hardening

#### 🔐 1. **Use HTTPS (TLS) for All Connections**

* Install SSL/TLS certificate and bind it to port **443**.
* Redirect HTTP → HTTPS via **URL Rewrite**.

```powershell
New-WebBinding -Name "MyApp" -Protocol https -Port 443
```

> Use modern protocols: **TLS 1.2 or TLS 1.3**, disable **SSLv2/v3** and **TLS 1.0/1.1**.

---

#### 🧱 2. **Harden File System Permissions**

* Remove **write access** from `C:\inetpub\wwwroot` for non-admins.
* Assign only **`IIS_IUSRS`** and **App Pool identity** with necessary read/execute rights.
* Deny anonymous access to sensitive folders (config, logs, backups).

---

#### 🧩 3. **Secure Application Pools**

* Use **one Application Pool per site** (process isolation).
* Run each under a **least-privilege account** (not LocalSystem).
* Enable **Rapid-Fail Protection** to handle crashes gracefully.

```powershell
Set-ItemProperty IIS:\AppPools\MyAppPool -Name processModel.identityType -Value ApplicationPoolIdentity
```

---

#### 🧱 4. **Remove Unused IIS Modules**

Minimize attack surface:

```powershell
Get-WebGlobalModule | Remove-WebGlobalModule -Name "WebDAVModule"
```

Common modules to disable if unused:

* **WebDAV**
* **Request Filtering**
* **CGI/ISAPI Extensions**
* **Directory Browsing**

---

#### 🧩 5. **Enable Request Filtering & URL Rewrite Rules**

```xml
<requestFiltering>
  <fileExtensions allowUnlisted="false">
    <add fileExtension=".config" allowed="false" />
  </fileExtensions>
  <requestLimits maxAllowedContentLength="10485760" /> <!-- 10 MB -->
</requestFiltering>
```

> Prevents serving of `.config`, `.exe`, `.bak`, etc., and limits upload sizes.

---

#### 🧠 6. **Implement Authentication & Authorization**

* Use **Windows Authentication** for internal apps.
* For public apps, use **Forms Auth** or **OAuth**.
* Disable **Anonymous Authentication** where not needed.
* Restrict IP access via **IP and Domain Restrictions**.

```powershell
Set-WebConfigurationProperty -filter /system.webServer/security/authentication/anonymousAuthentication -Name enabled -Value false -PSPath IIS:\ -Location "MyApp"
```

---

#### 🧩 7. **Set Security HTTP Headers**

In `web.config`:

```xml
<system.webServer>
  <httpProtocol>
    <customHeaders>
      <add name="X-Frame-Options" value="DENY" />
      <add name="X-Content-Type-Options" value="nosniff" />
      <add name="Strict-Transport-Security" value="max-age=31536000; includeSubDomains" />
      <add name="Content-Security-Policy" value="default-src 'self';" />
    </customHeaders>
  </httpProtocol>
</system.webServer>
```

> Helps mitigate clickjacking, MIME sniffing, and man-in-the-middle attacks.

---

#### 🧾 8. **Enable Detailed Logging & Monitoring**

* Enable **IIS logs**: `C:\inetpub\logs\LogFiles\W3SVC*`
* Integrate with **Windows Event Viewer**, **SIEM**, or **Azure Log Analytics**.
* Use:

```powershell
Get-WebConfigurationProperty -pspath IIS:\ -filter system.applicationHost/sites/siteDefaults/logFile -name directory
```

---

#### 🔄 9. **Keep Server and IIS Updated**

* Apply **Windows Updates** and **IIS patches** regularly.
* Use **Security Baselines** from Microsoft Security Compliance Toolkit (SCT).
* Scan with:

```powershell
Get-WindowsUpdateLog
```

---

#### 🔒 10. **Backups and Recovery**

* Backup IIS config:

```powershell
appcmd add backup "IIS_Secure_Config"
```

* Regularly back up:

  * `applicationHost.config`
  * Certificates
  * Web content

---

### 📋 IIS Security Checklist

| Security Layer            | Key Controls                                   |
| ------------------------- | ---------------------------------------------- |
| **Transport Layer**       | HTTPS (TLS 1.2+), disable weak ciphers         |
| **Access Control**        | Authentication, App Pool identity, permissions |
| **Application Hardening** | Remove unused modules, request filtering       |
| **Headers & Policies**    | CSP, HSTS, X-Frame-Options                     |
| **Monitoring**            | Logging, Event Viewer, SIEM integration        |
| **Maintenance**           | Patching, backups, vulnerability scanning      |

---

### ✅ Best Practices

* Use **HTTPS everywhere** with **modern ciphers**.
* Isolate sites with **dedicated app pools**.
* Enforce **least privilege** on service accounts.
* Disable **directory browsing** and **unused features**.
* Deploy **Web Application Firewall (WAF)** (e.g., Azure Front Door, AWS WAF).
* Automate configuration compliance via **PowerShell DSC** or **Terraform**.

---

### 💡 In short

To secure IIS:

1. Enforce **HTTPS + TLS 1.2+**
2. Harden file permissions and app pools
3. Remove unused modules
4. Add **security headers & request filtering**
5. Enable **logging & patch regularly**

A properly hardened IIS server minimizes risk from **common web exploits** and ensures **secure, compliant hosting** for production workloads.

---
## Q: How to Implement Load Balancing for IIS Web Servers

---

### 🧠 Overview

**Load balancing for IIS** distributes incoming web traffic across multiple IIS servers to ensure **high availability, fault tolerance, and scalability**.
It can be implemented using **Windows native features (NLB)**, **reverse proxies**, or **cloud/load balancer solutions** (e.g., AWS ELB, Azure Front Door, NGINX, HAProxy).

---

### ⚙️ Purpose / How it works

* Distributes incoming requests among IIS servers in a **server farm**.
* Improves **performance** by balancing the load and preventing overload on a single node.
* Ensures **redundancy** — if one IIS server fails, traffic is routed to healthy nodes.
* Supports **session persistence** (sticky sessions) when needed.

---

### 🧩 Common Load Balancing Options

| Method                                   | Description                                      | Use Case                       |
| ---------------------------------------- | ------------------------------------------------ | ------------------------------ |
| **Windows Network Load Balancing (NLB)** | Built-in Windows feature using Layer 4 (TCP/IP). | Small/medium on-prem setups    |
| **Application Request Routing (ARR)**    | IIS module acting as a reverse proxy (Layer 7).  | Web apps, SSL offloading       |
| **Azure/AWS Load Balancers**             | Cloud-native managed services.                   | Scalable, cloud-hosted IIS     |
| **Hardware Load Balancer (F5, Citrix)**  | Enterprise-grade L7 devices.                     | Large production environments  |
| **NGINX/HAProxy Reverse Proxy**          | Software-based load balancer.                    | Hybrid or containerized setups |

---

### 🧩 Option 1: **Windows NLB (Network Load Balancing)**

#### ⚙️ Step-by-Step Setup

1. **Install NLB feature on all IIS nodes**

```powershell
Install-WindowsFeature NLB -IncludeManagementTools
```

2. **Open NLB Manager** → **Create New Cluster**

   * Add each IIS server node.
   * Assign a **shared virtual IP (VIP)**.
   * Choose **Multicast** mode (recommended for most environments).

3. **Set Port Rules**

   * Port: `80, 443`
   * Protocol: `TCP`
   * Affinity: **Single** (for sticky sessions)

4. **Verify cluster status**

```powershell
nlb query
```

✅ Clients now access the site using the **virtual IP**, which distributes requests among all IIS nodes.

---

### 🧩 Option 2: **IIS Application Request Routing (ARR) Reverse Proxy**

#### 🧱 Prerequisites

* Install **IIS + URL Rewrite + ARR** on a separate reverse proxy server.

#### ⚙️ Steps

1. **Install ARR**

   * Download from: [IIS ARR](https://www.iis.net/downloads/microsoft/application-request-routing)
   * Install via GUI or PowerShell.

2. **Configure Server Farm**

   * IIS Manager → **Server Farms → Create Server Farm**
   * Add all backend IIS servers (e.g., `web01`, `web02`).

3. **Set Load Balancing Rules**

   * Load Balancing algorithm: **Round Robin** or **Least Requests**.
   * Enable **Health Monitoring** (URL: `/healthcheck`).

4. **Enable SSL Offloading (optional)**

   * Terminate SSL at ARR, forward HTTP to backend nodes.

5. **Add URL Rewrite Rule**

   ```xml
   <rule name="ReverseProxyInbound" stopProcessing="true">
     <match url="(.*)" />
     <action type="Rewrite" url="http://{C:1}/{R:1}" />
   </rule>
   ```

---

### 🧩 Option 3: **Cloud Load Balancer Example**

#### 🟦 Azure Load Balancer / Application Gateway

* Create **Backend Pool** → Add all IIS VMs.
* Configure **Health Probe** on `/healthcheck`.
* Set **Rule**:

  * Frontend Port: 443
  * Backend Port: 443
  * Protocol: TCP

#### 🟧 AWS Elastic Load Balancer (ELB)

* Create **Target Group** (IIS instances).
* Health check path: `/` or `/status`.
* Register IIS instances → Attach to **Application Load Balancer (ALB)**.

---

### 📋 Load Balancing Algorithms

| Algorithm                | Description                                           |
| ------------------------ | ----------------------------------------------------- |
| **Round Robin**          | Requests distributed sequentially.                    |
| **Least Connections**    | Routes to the server with the fewest active sessions. |
| **IP Hash**              | Ensures same client hits the same backend (sticky).   |
| **Weighted Round Robin** | Assigns higher capacity servers more requests.        |

---

### ✅ Best Practices

* Use **at least two IIS nodes** in the cluster.
* Deploy a **shared configuration** or **DFS replication** for web content consistency.
* Implement **shared session state** (SQL Server / Redis) if sticky sessions are not used.
* Monitor **health probes** and **logs** (Event Viewer, IIS logs).
* Use **HTTPS offloading** and **modern TLS** versions only.
* Keep load balancer in **redundant HA mode** (active-active or active-passive).

---

### 💡 In short

To implement load balancing for IIS:

* Use **Windows NLB** for simple L4 balancing, or **ARR Reverse Proxy** for HTTP-level balancing.
* Cloud setups use **Azure Load Balancer** or **AWS ALB**.
* Configure **health probes, session persistence, and SSL offloading** for reliability and performance.

👉 Load balancing ensures **scalability, redundancy, and seamless performance** for IIS-based web applications in production.

---
## Q: What is Kerberos Authentication in Active Directory (AD)?

---

### 🧠 Overview

**Kerberos Authentication** is the **default and most secure authentication protocol** used in **Active Directory (AD)** environments.
It provides **mutual authentication** between clients and servers using **encrypted tickets** rather than passwords, reducing exposure to credential theft.

---

### ⚙️ Purpose / How it works

Kerberos is based on a **ticket-granting system** that uses symmetric key cryptography and timestamps for validation.
It authenticates users without repeatedly sending passwords across the network.

---

### 🧩 Kerberos Authentication Flow (Step-by-Step)

| Step  | Process                                         | Description                                                                                                                                 |
| ----- | ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| **1** | **AS-REQ (Authentication Service Request)**     | The client sends a request to the **Key Distribution Center (KDC)** (part of the Domain Controller) for a **Ticket Granting Ticket (TGT)**. |
| **2** | **AS-REP (Authentication Service Reply)**       | KDC verifies the user and issues a **TGT**, encrypted with the user’s password hash.                                                        |
| **3** | **TGS-REQ (Ticket Granting Service Request)**   | The client presents the TGT to the **Ticket Granting Service (TGS)** to request access to a specific service (e.g., file server, IIS site). |
| **4** | **TGS-REP (Ticket Granting Service Reply)**     | The TGS returns a **Service Ticket**, encrypted with the service’s secret key.                                                              |
| **5** | **AP-REQ / AP-REP (Application Request/Reply)** | The client presents the Service Ticket to the target server, which validates it and grants access.                                          |

✅ **At no point is the password transmitted over the network.**

---

### 🧱 Components Involved

| Component                         | Description                                                                           |
| --------------------------------- | ------------------------------------------------------------------------------------- |
| **KDC (Key Distribution Center)** | Runs on the Domain Controller; issues TGTs and Service Tickets.                       |
| **TGT (Ticket Granting Ticket)**  | Proof that the client is authenticated; used to request service tickets.              |
| **Service Ticket**                | Used to access a specific resource or service.                                        |
| **krbtgt Account**                | Special account in AD used by KDC to encrypt/decrypt tickets.                         |
| **SPN (Service Principal Name)**  | Unique ID that associates a service with its account (e.g., `HTTP/web01.corp.local`). |

---

### 🧩 Example Commands / Tools

#### 🔍 Check Kerberos Tickets (Client)

```powershell
klist
```

✅ Output shows cached TGTs and service tickets.

#### 🧾 Purge Tickets (Force Reauth)

```powershell
klist purge
```

#### 🧱 Register a Service Principal Name (SPN)

```powershell
setspn -S HTTP/web01.corp.local corp\svc_iis
```

#### 🔒 Validate Kerberos Authentication

```powershell
Test-ComputerSecureChannel -Verbose
```

---

### 📋 Key Features vs NTLM

| Feature                   | **Kerberos**            | **NTLM**           |
| ------------------------- | ----------------------- | ------------------ |
| **Authentication Type**   | Ticket-based            | Challenge/Response |
| **Password Transmission** | No                      | Yes (hashed)       |
| **Mutual Authentication** | ✅ Yes                   | ❌ No               |
| **Performance**           | Faster (cached tickets) | Slower             |
| **Delegation Support**    | ✅ Yes (for SSO)         | ❌ No               |
| **Security Level**        | Strong (AES)            | Weak (DES/MD4)     |

---

### ✅ Best Practices

* Always use **Kerberos** over NTLM where possible.
* Regularly **rotate service account passwords** (especially `krbtgt`).
* Use **Managed Service Accounts (gMSA)** for apps that require SPNs.
* Monitor **Event ID 4768, 4769, 4771** in Event Viewer (Security logs) for Kerberos failures.
* Avoid **duplicate SPNs** — they cause authentication failures.
* Ensure **time synchronization** across all systems (Kerberos requires <5 min skew).

---

### 💡 In short

**Kerberos** is the **default AD authentication protocol** using **encrypted tickets** for secure, mutual authentication between clients and services.
It’s **faster, safer, and more scalable** than NTLM — forming the backbone of **Windows domain authentication**.

--- 
## Q: How Do You Back Up IIS Configuration?

---

### 🧠 Overview

Backing up **IIS (Internet Information Services)** configuration ensures you can **recover site settings, application pools, SSL bindings, and modules** in case of system corruption, migration, or accidental misconfiguration.
IIS stores its configuration in **XML files**, mainly in `applicationHost.config`, which can be backed up manually or using IIS tools.

---

### ⚙️ Purpose / How it works

* IIS configuration is stored centrally in the **`%windir%\System32\inetsrv\config`** directory.
* The **`applicationHost.config`** file contains global IIS settings (sites, bindings, pools, etc.).
* You can back up configurations via:

  * **AppCmd CLI**
  * **PowerShell**
  * **Manual copy**
  * **IIS Shared Configuration** (for multi-server farms)

---

### 🧩 1. Backup Using `appcmd` (Recommended)

#### 🔹 Create a Backup

```powershell
%windir%\system32\inetsrv\appcmd add backup "PreDeploymentBackup"
```

✅ This creates a backup under:

```
C:\Windows\System32\inetsrv\backup\PreDeploymentBackup\
```

#### 🔹 List Available Backups

```powershell
%windir%\system32\inetsrv\appcmd list backup
```

#### 🔹 Restore from Backup

```powershell
%windir%\system32\inetsrv\appcmd restore backup "PreDeploymentBackup"
```

---

### 🧩 2. Backup IIS Configuration via PowerShell

```powershell
Import-Module WebAdministration
Backup-WebConfiguration -Name "WeeklyBackup"
```

List existing backups:

```powershell
Get-WebConfigurationBackup
```

Restore a backup:

```powershell
Restore-WebConfiguration -Name "WeeklyBackup"
```

---

### 🧩 3. Manual Backup (File Copy)

Copy the following directories:

```bash
C:\Windows\System32\inetsrv\config\
C:\inetpub\
C:\ProgramData\Microsoft\Crypto\RSA\MachineKeys\
```

Include:

* `applicationHost.config` (IIS settings)
* `administration.config`, `redirection.config` (management and remote configs)
* SSL certificates from the **Windows Certificate Store**

> ⚠️ Ensure IIS service is stopped before manual copy to avoid partial backups:

```cmd
iisreset /stop
```

---

### 🧩 4. Enable Automatic Configuration Backups

IIS automatically creates history snapshots of `applicationHost.config` every time a change is made.

📂 Default path:

```
C:\inetpub\history\
```

Each folder is timestamped (e.g., `CFGHISTORY_0000001234`).

> You can restore from these snapshots by manually replacing `applicationHost.config`.

---

### 🧩 5. Backup IIS Shared Configuration (for multiple servers)

If using shared configuration:

1. In IIS Manager → Server node → **Shared Configuration**
2. Click **Export Configuration**
3. Provide:

   * **Destination path (e.g., shared folder)**
   * **Encryption password**

Restore on another node:

* Import via **Shared Configuration → Import Configuration**.

---

### 📋 Key Files to Include in Backups

| File/Folder              | Description                                |
| ------------------------ | ------------------------------------------ |
| `applicationHost.config` | Core IIS settings (sites, bindings, pools) |
| `administration.config`  | IIS Manager settings                       |
| `redirection.config`     | Remote management settings                 |
| `C:\inetpub\wwwroot`     | Default site content                       |
| `MachineKeys`            | SSL cert private keys                      |
| `C:\inetpub\history`     | Auto backups (config history)              |

---

### ✅ Best Practices

* Automate backups with **PowerShell + Task Scheduler**.
* Store backups securely and off-server (e.g., NAS or S3).
* Always back up **SSL certificates** along with IIS config.
* Perform **test restores** regularly.
* Before applying **patches or deployments**, take a backup:

  ```powershell
  appcmd add backup "PrePatchBackup"
  ```

---

### 💡 In short

To back up IIS configuration:

```powershell
appcmd add backup "MyBackup"
```

or

```powershell
Backup-WebConfiguration -Name "MyBackup"
```

It saves all **site, binding, and app pool settings** to `C:\Windows\System32\inetsrv\backup\`.
💾 Combine this with file and SSL certificate backups for complete IIS recovery coverage.

----
## Q: How to automate IIS setup in CI/CD?

---

### 🧠 Overview

Automating IIS setup in CI/CD means provisioning Windows hosts, installing IIS and dependencies, configuring sites/app pools/bindings, and deploying app artifacts automatically from your pipeline (Jenkins/GitLab/GitHub/Azure).
Goal: **repeatable, idempotent, auditable** deployments that fit into normal CI/CD flows.

---

### ⚙️ Purpose / How it works

* **Provisioning**: create/prepare Windows servers (baked images, cloud instances, or VMs).
* **Configuration**: idempotently install IIS features, app pools, bindings, certificates, request filtering, etc. (PowerShell DSC / Desired State / scripts).
* **Deployment**: push web artifacts (zip, msdeploy, files) and activate site.
* **Pipeline integration**: pipeline stages run scripts/agents that perform the above, use secrets manager for credentials, run health checks and rollback if necessary.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Minimal PowerShell script (idempotent) — install IIS, create site & app pool

```powershell
# scripts/setup-iis.ps1
param(
  [string]$SiteName = "MySite",
  [string]$PhysicalPath = "C:\inetpub\mysite",
  [int]$Port = 80,
  [string]$AppPool = "MySitePool"
)

Import-Module WebAdministration

# Install IIS features (idempotent)
Install-WindowsFeature -Name Web-Server,Web-Asp-Net45 -IncludeManagementTools -ErrorAction Stop

# Create folder and set permissions
New-Item -Path $PhysicalPath -ItemType Directory -Force | Out-Null
$acl = Get-Acl $PhysicalPath
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS","ReadAndExecute,Modify","ContainerInherit,ObjectInherit","None","Allow")
if (-not ($acl.Access | Where-Object { $_.IdentityReference -eq "IIS_IUSRS" })) {
  $acl.AddAccessRule($rule); Set-Acl -Path $PhysicalPath -AclObject $acl
}

# Create app pool if missing
if (-not (Test-Path IIS:\AppPools\$AppPool)) {
  New-WebAppPool -Name $AppPool
  Set-ItemProperty IIS:\AppPools\$AppPool -Name processModel.identityType -Value "ApplicationPoolIdentity"
}

# Create or update site
if (-not (Test-Path IIS:\Sites\$SiteName)) {
  New-Website -Name $SiteName -Port $Port -PhysicalPath $PhysicalPath -ApplicationPool $AppPool
} else {
  Set-ItemProperty "IIS:\Sites\$SiteName" -Name physicalPath -Value $PhysicalPath
  Set-ItemProperty "IIS:\Sites\$SiteName" -Name applicationPool -Value $AppPool
}
```

Run from pipeline agent (Windows) with:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup-iis.ps1 -SiteName "MySite" -PhysicalPath "C:\inetpub\mysite" -Port 443 -AppPool "MyPool"
```

---

#### 2) Use Web Deploy (msdeploy) to push the app artifact

```bash
# Package on build server
msbuild /t:Package /p:PackageLocation=Package.zip MyWebApp.sln

# Deploy from CI agent (requires Web Deploy on target or remote agent)
msdeploy -verb:sync -source:package='C:\artifacts\Package.zip' -dest:auto,computerName='https://web01.corp.local:8172/msdeploy.axd',username='$svc_deploy',password='$(DEPLOY_PASS)',authType='Basic' -allowUntrusted
```

---

#### 3) PowerShell DSC (idempotent, declarative)

```powershell
Configuration IISSiteConfig {
  Param ($NodeName = 'localhost')
  Node $NodeName {
    WindowsFeature IIS { Name = "Web-Server"; Ensure = "Present" }
    xWebAppPool AppPool {
      Name = "MyPool"
      Ensure = "Present"
      State = "Started"
      AutoStart = $true
    }
    xWebsite MySite {
      Ensure = "Present"
      Name = "MySite"
      State = "Started"
      PhysicalPath = "C:\inetpub\mysite"
      BindingInfo = @(
        MSFT_xWebBindingInformation { Protocol = "http"; Port = 80; HostName = "myapp.local" }
      )
      ApplicationPool = "MyPool"
    }
  }
}
IISSiteConfig -OutputPath .\dsc
Start-DscConfiguration -Path .\dsc -Wait -Verbose -Force
```

(Use xPSDesiredStateConfiguration / xWebAdministration resources.)

---

#### 4) Jenkinsfile example (Windows agent)

```groovy
pipeline {
  agent { label 'windows' }
  environment {
    DEPLOY_USER = credentials('svc-deploy-user')
  }
  stages {
    stage('Build') {
      steps {
        bat 'msbuild MyWebApp.sln /p:Configuration=Release'
        archiveArtifacts artifacts: '**\\bin\\**\\*.zip', fingerprint: true
      }
    }
    stage('Provision IIS') {
      steps {
        // copy scripts to target host and execute via WinRM or run on agent if agent is target
        powershell script: 'powershell -ExecutionPolicy Bypass -File scripts\\setup-iis.ps1 -SiteName MySite -PhysicalPath C:\\inetpub\\mysite -AppPool MyPool'
      }
    }
    stage('Deploy') {
      steps {
        powershell script: "msdeploy -verb:sync -source:package='artifacts\\MyApp.zip' -dest:msdeployAgent,computerName='localhost',includeAcls='False'"
      }
    }
    stage('Smoke Test') {
      steps {
        powershell script: 'Invoke-WebRequest -UseBasicParsing http://localhost/health -TimeoutSec 15'
      }
    }
  }
  post {
    failure { mail to: 'ops@corp.local', subject: "Deploy failed", body: "${env.BUILD_URL}" }
  }
}
```

---

### 📋 Methods Comparison

| Method                                          | Idempotent                     | Complexity | Best For                         | Notes                                           |
| ----------------------------------------------- | ------------------------------ | ---------- | -------------------------------- | ----------------------------------------------- |
| **PowerShell scripts**                          | Medium (if written idempotent) | Low        | Simple apps, quick automation    | Easy to run on target agents                    |
| **PowerShell DSC / Desired State**              | ✅ High                         | Medium     | Long-term config drift control   | Declarative, integrated with pull servers       |
| **Web Deploy (msdeploy)**                       | N/A (artifact deploy)          | Low        | Deploying web packages           | Needs Web Deploy on target or agent             |
| **Image baking (Packer/AMI/Golden image)**      | ✅ High                         | Medium     | Fast scale-out / immutable infra | Bake IIS + config, less runtime bootstrap       |
| **Configuration management (Ansible/CFEngine)** | ✅ High                         | Medium     | Multi-server orchestration       | Ansible WinRM modules widely used               |
| **IIS ARR / Load balancer configs in pipeline** | Depends                        | Medium     | Multi-node farms                 | Combine with shared content sync (DFS/rsync/S3) |

---

### ✅ Best Practices

* **Idempotency**: scripts/configs must be repeatable; prefer DSC or well-written PowerShell.
* **Secrets**: never store passwords in repo. Use **Vault/AWS Secrets Manager/Azure Key Vault/Jenkins Credentials**.
* **Agents**: run pipeline steps on a Windows agent with required tools (PowerShell, msdeploy, WebAdministration module).
* **Artifacts**: store build artifacts in artifact repo (Nexus/S3/Artifactory) and reference immutable versions.
* **Health checks & rollback**: include smoke tests and automatic rollback or alerting on failure.
* **Certificates**: automate SSL provisioning via ACME or centralized cert store; handle private keys securely.
* **Configuration-as-code**: keep IIS config in source (DSC scripts, web.config transforms, URL rewrite rules).
* **Content sync**: for multiple nodes, use shared storage (SMB/DFS/ASR) or push via pipeline to each node; avoid manual sync.
* **Least privilege**: run app pools under gMSA or low-privilege accounts, not local admin.
* **CI stages separation**: build → verify → provision → deploy → test → promote.

---

### ⚠️ Common Pitfalls

* Running non-idempotent scripts causing drift.
* Hard-coded hostnames/paths or credentials in pipeline.
* Missing firewall/WinRM or misconfigured agents preventing remote exec.
* Deploying without content sync (nodes inconsistent).
* Not handling certificate installation in automation.

---

### 💡 In short

Automate IIS setup by making configuration **declarative & idempotent** (DSC or idempotent PowerShell), deploy artifacts with **Web Deploy or file copy**, and integrate these steps into your CI/CD pipeline (Jenkins/GitHub Actions/Azure).
Use secrets management, smoke tests, and image-baking or DSC for reliable, repeatable production deployments.

---
## Q: How Do You Monitor IIS Performance?

---

### 🧠 Overview

Monitoring **IIS (Internet Information Services)** performance ensures your web applications are **healthy, fast, and reliable**.
You track **server metrics, site availability, request performance, and application pool health** to detect bottlenecks and prevent downtime.

---

### ⚙️ Purpose / How it works

IIS exposes detailed telemetry via **Windows Performance Counters**, **IIS logs**, and **Event Viewer**.
You can collect and visualize these metrics using **native tools (PerfMon, PowerShell, Event Viewer)** or external solutions like **Prometheus, Grafana, Azure Monitor, or ELK Stack**.

---

### 🧩 1. **Monitor with Performance Monitor (PerfMon)**

Use built-in **Performance Monitor (`perfmon.msc`)** to track IIS counters.

#### Key Performance Counters

| Category                 | Counter                                | Description                       |
| ------------------------ | -------------------------------------- | --------------------------------- |
| **Web Service**          | `Current Connections`                  | Number of active connections      |
|                          | `Total Method Requests/sec`            | Throughput for all requests       |
|                          | `Bytes Sent/sec`, `Bytes Received/sec` | Network throughput                |
| **ASP.NET Applications** | `Requests/Sec`                         | Overall application throughput    |
|                          | `Requests Queued`                      | Pending requests (should be low)  |
|                          | `Request Execution Time`               | Average response time             |
| **Process (w3wp.exe)**   | `% Processor Time`                     | CPU usage per app pool            |
|                          | `Private Bytes`                        | Memory used by worker process     |
| **System**               | `Processor Queue Length`               | System-level bottleneck indicator |

📌 **Example:**
If `Requests Queued` > 0 or `Request Execution Time` > 1s → performance bottleneck.

---

### 🧩 2. **Use PowerShell for Real-Time Metrics**

```powershell
# Monitor IIS requests per second
Get-Counter "\Web Service(_Total)\Current Connections"

# Monitor ASP.NET Requests Queued
Get-Counter "\ASP.NET\Requests Queued"
```

Capture metrics over time:

```powershell
Get-Counter -Counter "\Web Service(_Total)\Total Method Requests/sec" -SampleInterval 5 -MaxSamples 10
```

---

### 🧩 3. **Analyze IIS Logs**

IIS logs every request in:

```
C:\inetpub\logs\LogFiles\W3SVC1\
```

Log Fields (configure in IIS → Logging):

```
date time cs-method cs-uri-stem sc-status time-taken cs-bytes sc-bytes
```

#### Example: Identify Slow Requests

```powershell
Select-String "time-taken" C:\inetpub\logs\LogFiles\W3SVC1\u_ex*.log | Select-String "time-taken=[1-9][0-9]{3,}"
```

> Filters requests taking more than 1s (1000 ms).

---

### 🧩 4. **Monitor via Event Viewer**

* Open → `eventvwr.msc` → **Applications and Services Logs → Microsoft → Windows → IIS-Logging / WAS**
* Key Event IDs:

  * **5002** – Application Pool stopped unexpectedly
  * **5059** – Application Pool failed to start
  * **2280** – Module load failure
  * **1309** – ASP.NET application error

> Export to SIEM (Splunk / Sentinel / ELK) for centralized alerting.

---

### 🧩 5. **Set Up Performance Alerts**

Using `perfmon.msc`:

1. Create **Data Collector Set → Create manually → Performance counter alert**
2. Add counters like `Processor Time`, `Requests Queued`
3. Set thresholds → send **email or execute a script** on breach.

Example PowerShell Alert:

```powershell
if ((Get-Counter "\Web Service(_Total)\Current Connections").CounterSamples.CookedValue -gt 1000) {
  Send-MailMessage -To "admin@corp.local" -Subject "IIS High Connection Alert" -Body "Connections exceeded 1000" -SmtpServer smtp.corp.local
}
```

---

### 🧩 6. **Centralized Monitoring Options**

| Tool                                        | Features                                     | Use Case                     |
| ------------------------------------------- | -------------------------------------------- | ---------------------------- |
| **Azure Monitor / App Insights**            | Deep telemetry, request tracing, auto alerts | Cloud-hosted IIS             |
| **ELK (Elastic Stack)**                     | Log parsing, dashboards                      | On-prem / hybrid             |
| **Prometheus + Grafana (via WMI Exporter)** | Metrics + visualization                      | DevOps-native setups         |
| **SolarWinds / PRTG / Zabbix**              | SNMP/WMI-based performance dashboards        | Enterprise monitoring        |
| **Nagios / CheckMK**                        | Availability + health checks                 | Lightweight infra monitoring |

---

### 🧩 7. **Monitor Application Pool Health**

Use PowerShell to check App Pool states:

```powershell
Get-WebAppPoolState *
```

If a pool is stopped:

```powershell
Start-WebAppPool -Name "MyAppPool"
```

Track App Pool recycling:

```powershell
Get-WinEvent -LogName "System" | Where-Object { $_.Message -match "recycled" }
```

---

### 🧩 8. **Custom Health Check Endpoint**

Expose `/healthcheck` in your app returning HTTP 200.
Then probe via:

```bash
curl -I http://web01.corp.local/healthcheck
```

Integrate this into **CI/CD pipelines** or **load balancer probes** for real-time health verification.

---

### ✅ Best Practices

* Track **CPU, Memory, Queue Length, and Request Time** continuously.
* Configure **log rotation and forwarding** for central analysis.
* Enable **Failed Request Tracing (FREB)** for detailed request diagnostics:

  ```cmd
  %SystemRoot%\System32\inetsrv\appcmd set config "MySite" -section:system.webServer/tracing/traceFailedRequestsLogging /enabled:"True"
  ```
* Use **Application Insights or ELK** for full observability (logs, metrics, traces).
* Set alerts for:

  * High CPU (>80%)
  * Memory leaks (steady increase)
  * HTTP 5xx errors
  * App Pool restarts

---

### 💡 In short

Monitor IIS using **PerfMon, PowerShell, and logs** for performance metrics like **requests/sec, CPU, queue length, response times**.
For modern setups, integrate with **App Insights, Prometheus, or ELK** for real-time dashboards and alerting.
✅ Focus on **availability, performance, and proactive alerts** for production reliability.

---
## Q: How Do You Handle Domain Trust Between Two Forests?

---

### 🧠 Overview

A **domain or forest trust** in **Active Directory (AD)** allows users in one domain or forest to **access resources** in another securely.
When two forests establish a **trust relationship**, authentication requests can **flow between them** using Kerberos or NTLM.

---

### ⚙️ Purpose / How it works

* Forest trusts enable **cross-forest authentication and resource sharing** (e.g., file shares, applications).
* Trusts work by allowing **security principals** (users, groups) in one forest to be **recognized** by another.
* Trust relationships are managed by **Domain Controllers** and stored in the **AD database**.
* Kerberos authentication is used across trusts for **secure ticket exchange**.

---

### 🧩 Types of AD Trusts

| Trust Type             | Direction         | Scope                                      | Authentication | Description                                                           |
| ---------------------- | ----------------- | ------------------------------------------ | -------------- | --------------------------------------------------------------------- |
| **Forest Trust**       | Two-way / One-way | Between forests                            | Kerberos       | Used between entire forests (root domains)                            |
| **External Trust**     | Two-way / One-way | Between domains (different forests)        | NTLM           | For legacy or isolated domains                                        |
| **Shortcut Trust**     | Two-way / One-way | Between child domains in same forest       | Kerberos       | Reduces authentication latency                                        |
| **Realm Trust**        | Two-way / One-way | Between AD and non-Windows Kerberos realms | Kerberos       | Used for cross-platform integration                                   |
| **Trust Transitivity** | N/A               | Forest/Domain level                        | N/A            | Determines if trust extends beyond direct partners (transitive = yes) |

---

### 🧩 Example Scenario

You have:

* **Forest A:** `corp.local`
* **Forest B:** `dev.local`
  You want users in `corp.local` to access resources in `dev.local`.

✅ Solution: Create a **two-way forest trust**.

---

### 🧱 Steps to Create a Forest Trust (via GUI)

#### 1. **Prepare DNS Name Resolution**

* Ensure both forests can resolve each other’s FQDNs.
  Add conditional forwarders:

  ```powershell
  Add-DnsServerConditionalForwarderZone -Name "dev.local" -MasterServers 10.0.2.10
  Add-DnsServerConditionalForwarderZone -Name "corp.local" -MasterServers 10.0.1.10
  ```

#### 2. **Open Active Directory Domains and Trusts**

* On a domain controller → Run `domain.msc`
* Right-click your **domain node → Properties → Trusts → New Trust Wizard**

#### 3. **Select Trust Type**

* Choose **Forest Trust**
* Enter the **FQDN of the target forest** (`dev.local`)
* Choose **Two-way trust** (for bidirectional access)

#### 4. **Choose Authentication Scope**

* **Forest-wide authentication** (default): users from one forest can access any domain in the other.
* **Selective authentication**: admins must explicitly allow which users can access which servers.

#### 5. **Provide Credentials**

* Enter an account with **Enterprise Admin** rights in both forests.

#### 6. **Confirm and Verify Trust**

* Test the trust immediately from the wizard.
* Verify using:

  ```powershell
  netdom trust dev.local /domain:corp.local /verify
  ```

---

### 🧩 PowerShell Method (Scripted Setup)

```powershell
New-ADForestTrust -Name "dev.local" -TargetForestName "dev.local" `
-TrustType Forest -Direction Bidirectional -ForestTransitive $true
```

Verify:

```powershell
Get-ADTrust -Filter *
```

---

### 🧩 Validate and Test the Trust

* On `corp.local` DC:

  ```powershell
  netdom trust dev.local /domain:corp.local /verify
  ```
* On `dev.local` DC:

  ```powershell
  netdom trust corp.local /domain:dev.local /verify
  ```

✅ You should see:

```
The trust relationship was successfully verified.
```

---

### 📋 Authentication Behavior

| Mode                         | Description                                     | Use Case                   |
| ---------------------------- | ----------------------------------------------- | -------------------------- |
| **Forest-wide**              | Automatic authentication across all domains     | Trusted environments       |
| **Selective Authentication** | Explicit “Allow logon from” permission required | High-security environments |

> Example selective access:

```powershell
Grant-ADPermission -Identity "Server01" -User "corp\UserA" -ExtendedRights "Allowed to Authenticate"
```

---

### ✅ Best Practices

* Use **Forest Trusts** for modern, transitive, secure communication.
* Configure **DNS forwarders** or **conditional zones** between forests.
* Enable **Kerberos across trust** (default in forest trusts).
* Use **Selective Authentication** for high-security networks.
* Audit and verify trust relationships periodically:

  ```powershell
  Get-ADTrust -Filter * | Select-Object Name,Direction,TrustType,TrustAttributes
  ```
* Limit **Enterprise Admin** rights — use dedicated service accounts for trust setup.
* Ensure **time synchronization (NTP)** between forests — Kerberos requires <5 min skew.

---

### 💡 In short

A **domain/forest trust** connects two AD forests, allowing secure **cross-forest authentication**.
Steps:

1. Configure **DNS forwarders**
2. Create a **two-way forest trust**
3. Choose **selective or forest-wide authentication**
4. Verify via `netdom trust`

👉 Use **Forest Trusts** for full AD integration and **Selective Authentication** for tight access control.

---
## Q: How Do You Replicate Active Directory (AD) Between Sites?

---

### 🧠 Overview

**Active Directory (AD) replication between sites** allows **Domain Controllers (DCs)** in different physical locations (sites) to **synchronize directory data securely and efficiently**.
This ensures that all domain controllers across WAN or branch offices share **consistent user, group, and policy information**.

---

### ⚙️ Purpose / How it works

* AD uses **multi-master replication**, where every DC can accept updates.
* **Intra-site replication** → frequent & automatic (LAN, high-speed).
* **Inter-site replication** → scheduled & compressed (WAN, limited bandwidth).
* Replication occurs over **RPC over IP** (default) or **SMTP** (for non-domain data only).

---

### 🧩 AD Replication Architecture Components

| Component                               | Description                                                             |
| --------------------------------------- | ----------------------------------------------------------------------- |
| **Site**                                | Logical group of DCs connected by fast LAN links.                       |
| **Site Link**                           | Defines how sites replicate with each other (cost, interval, schedule). |
| **Bridgehead Server**                   | DC designated to handle inter-site replication.                         |
| **KCC (Knowledge Consistency Checker)** | Builds and optimizes replication topology automatically.                |
| **NTDS Settings**                       | Object under each DC defining inbound/outbound connections.             |

---

### 🧩 Step-by-Step: Configure AD Inter-Site Replication

#### 🪟 1. **Create Sites in Active Directory Sites and Services**

1. Open → `dssite.msc`
2. Right-click **Sites → New Site**
3. Assign a **name** (e.g., `Site-HQ`, `Site-Branch1`)
4. Select **Default IP Site Link**

---

#### 🌐 2. **Create Subnets and Link to Sites**

Associate IP ranges with sites:

```powershell
New-ADReplicationSubnet -Name "10.10.1.0/24" -Site "Site-HQ"
New-ADReplicationSubnet -Name "10.20.1.0/24" -Site "Site-Branch1"
```

> Ensures domain members automatically associate with their nearest DC.

---

#### 🔗 3. **Create a Site Link**

Site links define **replication path, cost, and schedule**.

```powershell
New-ADReplicationSiteLink -Name "HQ-BRANCH1" -SitesIncluded "Site-HQ","Site-Branch1" -Cost 100 -ReplicationFrequencyInMinutes 180
```

* **Cost:** Lower = higher priority path
* **ReplicationFrequency:** Interval between syncs (15–10,080 minutes)

---

#### 🧱 4. **Assign a Bridgehead Server (Optional)**

Let AD automatically select, or manually assign for control:

```powershell
Set-ADReplicationSite -Identity "Site-HQ" -BridgeheadServerList @("DC01.corp.local")
```

> Bridgehead DC handles replication traffic between sites.

---

#### 🔁 5. **Force Replication Between Sites**

```powershell
repadmin /syncall /AdeP
```

or

```powershell
repadmin /kcc
```

> Forces immediate synchronization and topology rebuild.

---

#### 🔍 6. **Verify Replication**

```powershell
repadmin /replsummary
repadmin /showrepl
```

✅ Output Example:

```
Destination DSA    largest delta    fails/total %%   error
DC01               00h:20m:32s      0 / 20   0
DC02               00h:19m:50s      0 / 20   0
```

---

### 🧩 Example Site Link Schedule (GUI)

* Open `Active Directory Sites and Services`
* Expand **Inter-Site Transports → IP**
* Right-click your site link → **Properties**
* Click **Change Schedule**
* Define replication window (e.g., 8 AM – 8 PM, Mon–Fri)

---

### 📋 Inter-Site vs Intra-Site Replication

| Feature                | **Intra-Site**           | **Inter-Site**               |
| ---------------------- | ------------------------ | ---------------------------- |
| **Transport Protocol** | RPC over IP              | RPC over IP / SMTP           |
| **Compression**        | None                     | Compressed (~15% data size)  |
| **Frequency**          | Immediate / Event-driven | Scheduled                    |
| **Topology**           | Automatic (KCC)          | Controlled via site links    |
| **Latency**            | Low                      | Higher (scheduled intervals) |

---

### ✅ Best Practices

* Always use **RPC over IP** unless SMTP is mandatory.
* Keep **replication frequency** balanced (15–180 min typical for WAN).
* Monitor using:

  ```powershell
  repadmin /replsummary
  ```
* Ensure **DNS resolution and NTP synchronization** between sites.
* Configure **site link bridging** only when multiple WAN paths exist.
* Place **at least one DC per site** (prefer two for redundancy).
* Audit replication failures (Event ID 1311, 2042, 2087 in Event Viewer).
* Encrypt WAN traffic via **VPN or IPsec** for secure replication.

---

### 💡 In short

AD **inter-site replication** keeps domain data consistent across geographically separated sites using **site links** and **bridgehead servers**.
Steps:

1. Create sites and subnets
2. Define site links (cost, schedule)
3. Verify with `repadmin /replsummary`

👉 Proper site design ensures **efficient, secure, and bandwidth-optimized replication** across distributed Active Directory environments.

---
## Q: How to Delegate Administrative Control in Active Directory (AD)?

---

### 🧠 Overview

**Delegation of administrative control** in **Active Directory (AD)** allows you to **assign limited administrative rights** to specific users or groups for managing a subset of AD objects — such as users, computers, or OUs — **without giving them full domain admin privileges**.
This supports **least privilege**, **security separation**, and **scalable administration**.

---

### ⚙️ Purpose / How it works

* Delegation uses **Access Control Lists (ACLs)** on **Organizational Units (OUs)** or objects.
* Permissions are granted via **Active Directory Users and Computers (ADUC)** or **PowerShell**.
* Common delegations:

  * Reset passwords
  * Create/delete user accounts
  * Manage group memberships
  * Join computers to the domain
  * Manage GPO links for an OU

---

### 🧩 1️⃣ Delegating Control Using GUI (ADUC)

#### 🔧 Step-by-Step:

1. Open **Active Directory Users and Computers** (`dsa.msc`)
2. Enable **Advanced Features** (View → Advanced Features)
3. Right-click the **OU** you want to delegate (e.g., *OU=IT-Users*)
4. Click **“Delegate Control…”** → Launches Delegation Wizard
5. Add user or group (e.g., `helpdesk_team`)
6. Choose a task to delegate:

   * “Create, delete, and manage user accounts”
   * “Reset user passwords and force password change at next logon”
   * “Read all user information”
   * “Manage Group Policy links”
7. Finish the wizard ✅

This automatically modifies the OU’s **ACL entries (DACL)**.

---

### 🧩 2️⃣ Delegating Specific Permissions (Advanced)

For granular control:

1. Right-click the OU → **Properties → Security → Advanced**
2. Add user/group → **Edit permissions**
3. Choose:

   * **Applies to:** “Descendant User objects” or “This object and all child objects”
   * Check boxes like:

     * ✅ Reset password
     * ✅ Write `memberOf` (for group membership)
     * ✅ Create/Delete user objects

---

### 🧩 3️⃣ Delegating via PowerShell (Scripted / CI/CD Friendly)

#### 🪄 Example: Allow “HelpdeskAdmins” to Reset Passwords in OU

```powershell
Import-Module ActiveDirectory
$ou = "OU=IT-Users,DC=corp,DC=local"
$group = "corp\HelpdeskAdmins"

# Delegate Reset Password Permission
dsacls $ou /G "$group:CA;Reset Password"
```

#### 🧩 Delegate User Creation/Deletion

```powershell
dsacls "OU=IT-Users,DC=corp,DC=local" /G "corp\HelpdeskAdmins:CC;user"
dsacls "OU=IT-Users,DC=corp,DC=local" /G "corp\HelpdeskAdmins:DC;user"
```

#### 🧩 Verify Permissions

```powershell
dsacls "OU=IT-Users,DC=corp,DC=local"
```

> ✅ `CA` = Control Access
> ✅ `CC` = Create Child
> ✅ `DC` = Delete Child

---

### 🧩 4️⃣ Delegate Group Policy Control

To allow GPO management for a specific OU:

```powershell
Set-GPPermissions -Name "Default Domain Policy" -TargetName "corp\HelpdeskAdmins" -TargetType Group -PermissionLevel GpoEdit
```

> Options: `GpoApply`, `GpoEdit`, `GpoEditDeleteModifySecurity`

---

### 🧩 5️⃣ Common Delegation Scenarios

| Role / Team       | Delegated Rights                                         | OU Example                 |
| ----------------- | -------------------------------------------------------- | -------------------------- |
| **Helpdesk**      | Reset passwords, unlock accounts, enable/disable users   | OU=Users                   |
| **HR Admins**     | Create new users, modify department/job title attributes | OU=HR                      |
| **Server Admins** | Join computers to domain, manage computer objects        | OU=Servers                 |
| **GPO Managers**  | Edit and link Group Policies                             | Domain root / specific OUs |
| **App Support**   | Modify service accounts, read group memberships          | OU=ServiceAccounts         |

---

### 📋 Important Delegation Attributes

| Type                | Example Permission                                                     |
| ------------------- | ---------------------------------------------------------------------- |
| **Object-level**    | Create/Delete User, Group, Computer                                    |
| **Property-level**  | Read/Write specific attributes (e.g., `telephoneNumber`, `department`) |
| **Extended Rights** | Reset Password, Force Change Password, Send As, Receive As             |
| **Container-level** | Manage all child objects under an OU                                   |

---

### ✅ Best Practices

* Always **delegate at the OU level**, not at the domain root.
* Use **security groups**, not individual users, for delegation.
* Apply **least privilege** — only necessary rights.
* Document all delegated permissions (who, where, what).
* Review with:

  ```powershell
  Get-ADPermission -Identity "OU=IT-Users,DC=corp,DC=local"
  ```
* Avoid giving **Full Control** unless absolutely required.
* Periodically audit delegations using `dsacls` or AD auditing tools.

---

### 💡 In short

Delegating admin control in AD means assigning **limited, role-based rights** on specific **OUs or objects** — e.g., allowing helpdesk teams to reset passwords or HR to create users — **without granting Domain Admin rights**.
✅ Use the **Delegation Wizard**, **PowerShell (`dsacls`)**, and **least privilege principle** to maintain security and scalability.

---
## Q: How to Enforce Password Policies in Active Directory (AD)?

---

### 🧠 Overview

**Password policies** in **Active Directory (AD)** define rules that control **password complexity, length, age, and history** for domain users.
These policies help enforce **strong authentication**, reduce **account compromise risks**, and ensure compliance with organizational or security standards (e.g., NIST, ISO, CIS).

---

### ⚙️ Purpose / How it works

* AD applies **password and account lockout policies** via **Group Policy Objects (GPOs)**.
* By default, the **Default Domain Policy** sets the **domain-wide password policy**.
* You can also define **Fine-Grained Password Policies (FGPP)** for **specific users or groups** (available since Windows Server 2008).

---

### 🧩 1️⃣ Configure Default Domain Password Policy (Applies to All Users)

#### 🪟 Steps (GUI)

1. Open **Group Policy Management Console (GPMC)** → `gpmc.msc`

2. Edit the **Default Domain Policy** (located at domain root).

3. Navigate to:

   ```
   Computer Configuration →
     Policies →
       Windows Settings →
         Security Settings →
           Account Policies →
             Password Policy
   ```

4. Configure the following settings:

   * **Enforce password history** → `24`
   * **Maximum password age** → `90 days`
   * **Minimum password age** → `1 day`
   * **Minimum password length** → `12 characters`
   * **Password must meet complexity requirements** → `Enabled`
   * **Store passwords using reversible encryption** → `Disabled`

5. Close and update the policy:

   ```powershell
   gpupdate /force
   ```

---

### 🧩 2️⃣ Fine-Grained Password Policy (FGPP)

Use FGPP when different password rules are needed for **specific users or groups** (e.g., admins vs. regular users).

#### 🔹 Create via PowerShell

```powershell
New-ADFineGrainedPasswordPolicy -Name "AdminsPolicy" `
  -Precedence 1 `
  -ComplexityEnabled $true `
  -PasswordHistoryCount 24 `
  -MinPasswordLength 14 `
  -MinPasswordAge (New-TimeSpan -Days 1) `
  -MaxPasswordAge (New-TimeSpan -Days 60) `
  -LockoutThreshold 5 `
  -LockoutDuration (New-TimeSpan -Minutes 15)
```

#### 🔹 Apply to a Group

```powershell
Add-ADFineGrainedPasswordPolicySubject -Identity "AdminsPolicy" -Subjects "Domain Admins"
```

> FGPPs are stored in the **Password Settings Container** within AD and evaluated by **lowest precedence number first**.

#### 🔹 Verify Applied Policy

```powershell
Get-ADUserResultantPasswordPolicy -Identity vasu
```

---

### 🧩 3️⃣ Account Lockout Policy

Defined in the same GPO path:

```
Computer Configuration → Policies → Windows Settings → Security Settings → Account Policies → Account Lockout Policy
```

| Setting                                 | Recommended | Description                      |
| --------------------------------------- | ----------- | -------------------------------- |
| **Account lockout threshold**           | 5           | Number of invalid login attempts |
| **Lockout duration**                    | 15 mins     | Time account remains locked      |
| **Reset account lockout counter after** | 15 mins     | Reset failure count timer        |

---

### 🧩 4️⃣ Command-Line Verification

#### 🔍 View Current Domain Password Policy

```powershell
net accounts /domain
```

✅ Output Example:

```
Minimum password length (chars): 12
Maximum password age (days): 90
Password history length: 24
Lockout threshold: 5
```

#### 🔍 Check Effective Policy on a User

```powershell
Get-ADUserResultantPasswordPolicy -Identity "vasu"
```

---

### 📋 Password Policy Parameters

| Setting                     | Description                                        | Example / Recommendation |
| --------------------------- | -------------------------------------------------- | ------------------------ |
| **Minimum Password Length** | Prevents short passwords                           | 12–16 characters         |
| **Complexity Requirements** | Enforces use of upper, lower, number, special char | Enabled                  |
| **Password History**        | Prevents reuse of old passwords                    | 24                       |
| **Maximum Password Age**    | Forces periodic password changes                   | 60–90 days               |
| **Minimum Password Age**    | Prevents quick password cycling                    | 1 day                    |
| **Lockout Threshold**       | Protects against brute-force attacks               | 5 attempts               |
| **Reversible Encryption**   | Should be disabled                                 | Disabled                 |

---

### ✅ Best Practices

* Enforce **complex passwords** and **MFA** for privileged accounts.
* Use **Fine-Grained Policies** for admin/service accounts.
* Avoid **reversible encryption** — it stores passwords insecurely.
* Rotate **service account passwords** periodically (or use **gMSAs**).
* Regularly audit password settings:

  ```powershell
  Get-ADFineGrainedPasswordPolicy -Filter *
  ```
* Combine password policies with **Account Lockout** and **Smart Lockout (Azure AD)** for cloud-hybrid environments.
* Consider **Password Protection** (Windows Server 2019+) with banned password lists.

---

### 💡 In short

You enforce password policies in AD by:

1. Configuring **Default Domain Policy** for global settings.
2. Using **Fine-Grained Password Policies (FGPP)** for specific groups.
3. Validating via `net accounts /domain` or PowerShell.

✅ Strong AD security = **complex passwords + lockout policy + least privilege + MFA**.

---
## Q: Common Windows & IIS Commands (Admin & DevOps Reference)

---

### 🧠 Overview

Here’s a **quick reference guide** of **commonly used Windows and IIS administrative commands** — essential for **DevOps, system administration, CI/CD automation**, and **IIS troubleshooting**.
Includes **PowerShell, CMD, and IIS-specific utilities** (`appcmd`, `iisreset`, etc.).

---

## ⚙️ Windows Server Administration Commands

| Purpose                    | Command                               | Description                                  |
| -------------------------- | ------------------------------------- | -------------------------------------------- |
| **System Info**            | `systeminfo`                          | Displays OS version, build, and domain info. |
| **IP Configuration**       | `ipconfig /all`                       | Shows all IP settings.                       |
| **Flush DNS Cache**        | `ipconfig /flushdns`                  | Clears local DNS cache.                      |
| **Ping Test**              | `ping <hostname>`                     | Checks connectivity.                         |
| **Test Port (PowerShell)** | `Test-NetConnection <host> -Port 443` | Tests port accessibility.                    |
| **Network Routes**         | `route print`                         | Displays routing table.                      |
| **Show Open Ports**        | `netstat -ano`                        | Shows active TCP/UDP connections.            |
| **Firewall Config**        | `netsh advfirewall show allprofiles`  | Displays firewall status.                    |
| **User Info**              | `whoami` / `query user`               | Shows logged-in user info.                   |
| **Services List**          | `Get-Service`                         | Lists all services (PowerShell).             |
| **Restart a Service**      | `Restart-Service W3SVC`               | Restarts IIS service.                        |
| **View Processes**         | `tasklist`                            | Lists running processes.                     |
| **Kill Process by PID**    | `taskkill /PID <id> /F`               | Force stop a process.                        |
| **System Updates**         | `sconfig`                             | Manage Windows updates (Server Core).        |
| **Event Viewer (GUI)**     | `eventvwr.msc`                        | Opens Windows Event Viewer.                  |

---

## 🌐 IIS Administration Commands

### 🧩 IIS Service Management

| Task                 | Command             | Description                     |
| -------------------- | ------------------- | ------------------------------- |
| **Start IIS**        | `iisreset /start`   | Starts IIS service.             |
| **Stop IIS**         | `iisreset /stop`    | Stops IIS service.              |
| **Restart IIS**      | `iisreset /restart` | Restarts IIS (site + app pool). |
| **Check IIS Status** | `iisreset /status`  | Displays IIS running state.     |

---

### 🧱 AppCmd Utility (Powerful IIS CLI Tool)

📂 Path:

```
C:\Windows\System32\inetsrv\appcmd.exe
```

| Task                 | Command                                                                                       | Description                  |
| -------------------- | --------------------------------------------------------------------------------------------- | ---------------------------- |
| **List Sites**       | `appcmd list site`                                                                            | Lists all hosted websites.   |
| **List App Pools**   | `appcmd list apppool`                                                                         | Lists all application pools. |
| **Start Site**       | `appcmd start site "MyWebsite"`                                                               | Starts a specific website.   |
| **Stop Site**        | `appcmd stop site "MyWebsite"`                                                                | Stops a specific website.    |
| **Start App Pool**   | `appcmd start apppool /apppool.name:MyAppPool`                                                | Starts app pool.             |
| **Recycle App Pool** | `appcmd recycle apppool /apppool.name:MyAppPool`                                              | Recycles app pool.           |
| **Add New Site**     | `appcmd add site /name:MySite /bindings:http/*:80:myapp.local /physicalPath:C:\inetpub\myapp` | Creates a new site.          |
| **View Config**      | `appcmd list config`                                                                          | Displays IIS configuration.  |
| **Backup Config**    | `appcmd add backup "PreDeployBackup"`                                                         | Backs up IIS config.         |
| **Restore Config**   | `appcmd restore backup "PreDeployBackup"`                                                     | Restores a backup.           |

---

### ⚙️ PowerShell IIS Cmdlets (WebAdministration Module)

Import module:

```powershell
Import-Module WebAdministration
```

| Task                          | Command                                                                                           | Description                       |
| ----------------------------- | ------------------------------------------------------------------------------------------------- | --------------------------------- |
| **List Websites**             | `Get-Website`                                                                                     | Lists all hosted IIS sites.       |
| **List App Pools**            | `Get-WebAppPoolState *`                                                                           | Shows app pool status.            |
| **Start/Stop Site**           | `Start-Website -Name "MySite"` / `Stop-Website -Name "MySite"`                                    | Controls a website.               |
| **Create New Site**           | `New-Website -Name "MyApp" -Port 8080 -PhysicalPath "C:\inetpub\myapp"`                           | Creates a new IIS website.        |
| **Create App Pool**           | `New-WebAppPool -Name "MyAppPool"`                                                                | Creates an application pool.      |
| **Assign App Pool to Site**   | `Set-ItemProperty "IIS:\Sites\MyApp" -Name applicationPool -Value "MyAppPool"`                    | Binds a site to its app pool.     |
| **Recycle App Pool**          | `Restart-WebAppPool -Name "MyAppPool"`                                                            | Recycles app pool via PowerShell. |
| **Set Site Binding**          | `New-WebBinding -Name "MyApp" -Protocol https -Port 443 -SslFlags 1`                              | Adds HTTPS binding.               |
| **Enable Directory Browsing** | `Set-WebConfigurationProperty -Filter system.webServer/directoryBrowse -Name enabled -Value true` | Toggles directory browsing.       |

---

### 🔒 SSL/TLS and Certificates

| Task                                 | Command                                                                                   | Description                |
| ------------------------------------ | ----------------------------------------------------------------------------------------- | -------------------------- |
| **View Certificates (LocalMachine)** | `Get-ChildItem Cert:\LocalMachine\My`                                                     | Lists installed certs.     |
| **Bind SSL Certificate**             | `netsh http add sslcert hostnameport=myapp.local:443 certhash=<cert_hash> appid={<GUID>}` | Binds certificate to port. |
| **Remove SSL Binding**               | `netsh http delete sslcert ipport=0.0.0.0:443`                                            | Deletes SSL binding.       |

---

### 🧾 IIS Log & Diagnostics

| Task                                     | Command                                                                                                                | Description                         |
| ---------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ----------------------------------- |
| **View Log Path**                        | `Get-WebConfigurationProperty -pspath IIS:\ -filter system.applicationHost/sites/siteDefaults/logFile -name directory` | Shows log directory.                |
| **Enable Failed Request Tracing (FREB)** | `appcmd set config "MySite" -section:system.webServer/tracing/traceFailedRequestsLogging /enabled:"True"`              | Enables tracing.                    |
| **Check Worker Processes**               | `Get-WmiObject Win32_Process -Filter "name='w3wp.exe'"`                                                                | Lists running IIS worker processes. |
| **Monitor Requests/sec**                 | `Get-Counter "\Web Service(_Total)\Total Method Requests/sec"`                                                         | Measures request throughput.        |

---

### 🧰 User, Group, and Policy Management

| Task                          | Command                                     | Description                      |
| ----------------------------- | ------------------------------------------- | -------------------------------- |
| **Create User**               | `net user devops P@ssw0rd! /add`            | Adds local user.                 |
| **Add User to Group**         | `net localgroup administrators devops /add` | Adds user to local admins.       |
| **Show Domain Info**          | `net accounts /domain`                      | Displays AD password policy.     |
| **Force Group Policy Update** | `gpupdate /force`                           | Applies latest GPO changes.      |
| **View Effective GPOs**       | `gpresult /r`                               | Displays applied Group Policies. |

---

### 📦 Windows Service & Feature Management

| Task                        | Command                                                     | Description                         |
| --------------------------- | ----------------------------------------------------------- | ----------------------------------- |
| **Install IIS**             | `Install-WindowsFeature Web-Server -IncludeManagementTools` | Installs IIS role.                  |
| **List Installed Features** | `Get-WindowsFeature`                                        | Lists all available roles/features. |
| **Enable Feature**          | `Install-WindowsFeature Web-Asp-Net45`                      | Adds ASP.NET 4.5 support.           |
| **Restart Windows Service** | `Restart-Service W3SVC`                                     | Restarts IIS service.               |

---

### 🧠 Monitoring and Troubleshooting

| Task                             | Command                                        | Description                         |                            |
| -------------------------------- | ---------------------------------------------- | ----------------------------------- | -------------------------- |
| **Check Event Logs**             | `Get-EventLog -LogName Application -Newest 10` | Shows latest app logs.              |                            |
| **View IIS App Pool Crashes**    | `Get-WinEvent -LogName "Application"           | where {$_.Message -match "w3wp"}`   | Detects app pool restarts. |
| **Network Latency Check**        | `Test-Connection <server>`                     | Pings target server multiple times. |                            |
| **Disk Usage**                   | `Get-PSDrive`                                  | Lists drive usage info.             |                            |
| **Monitor Performance Counters** | `perfmon.msc`                                  | Opens Performance Monitor GUI.      |                            |

---

### ✅ Best Practices

* Always run administrative commands from **elevated PowerShell/CMD**.
* Combine **PowerShell + AppCmd** in CI/CD for IIS automation.
* Maintain **pre-deployment backups**:

  ```powershell
  appcmd add backup "PreDeployBackup"
  ```
* Automate IIS health checks using:

  ```powershell
  Invoke-WebRequest http://localhost/healthcheck -UseBasicParsing
  ```
* Export configuration regularly:

  ```powershell
  appcmd list site /config > IIS_config_backup.xml
  ```

---

### 💡 In short

For quick IIS administration:

```powershell
iisreset /restart               # Restart IIS
Get-Website                     # List sites
Restart-WebAppPool -Name MyApp  # Recycle app pool
appcmd add backup "PreDeploy"   # Backup IIS config
Get-Counter "\Web Service(_Total)\Current Connections"  # Monitor connections
```

✅ Mastering these **core Windows & IIS commands** gives you full control over **web hosting, troubleshooting, and automation** in production and DevOps pipelines.

----

# Scenario-Based Questions

## Q: IIS site not loading

---

### 🧠 Overview

This is a step-by-step troubleshooting checklist for when an IIS-hosted site returns blank pages, errors, **503/500**, or just won’t respond. Follow the steps in order — each step includes commands and what to look for so you can quickly isolate the root cause and fix it.

---

### ⚙️ Purpose / How it works

IIS serves requests via **sites → bindings → application pool → w3wp.exe**. If any link in that chain fails (DNS/bindings, firewall, stopped service, app pool crash, permission, config error, or app exception) the site will not load. We systematically check each layer from network → IIS service → site/app pool → application code/config.

---

### 🧩 Quick checklist & commands (run these in order)

#### 1) Basic connectivity & DNS

```powershell
# From client or server
ping <server-ip-or-hostname>
nslookup mysite.example.com
Test-NetConnection mysite.example.com -Port 80
Test-NetConnection mysite.example.com -Port 443
```

**Look for:** DNS resolves to expected IP; port reachable. If DNS fails, fix DNS or hosts file.

---

#### 2) Check IIS service & Windows services

```powershell
Get-Service W3SVC, WAS
# start if stopped
Start-Service W3SVC; Start-Service WAS
iisreset /status
```

**Look for:** W3SVC/WAS running. If stopped, start and check Event Viewer for why.

---

#### 3) Verify site & binding configuration

```powershell
Import-Module WebAdministration
Get-Website | Format-Table Name,State,Bindings
Get-WebBinding -Name "MySite"
```

**Look for:** Site state ≠ **Started**, missing binding, wrong host header, or port mismatch.

---

#### 4) Application Pool health

```powershell
Get-WebAppPoolState -Name "MyAppPool"
Get-ChildItem IIS:\AppPools\ | Select Name, managedRuntimeVersion, processModel.identity
Restart-WebAppPool -Name "MyAppPool"
```

**Look for:** App pool **Stopped** or crashes on start. If stopped, check identity/permissions and Event Viewer.

---

#### 5) Check worker processes & crashes

```powershell
Get-WmiObject Win32_Process -Filter "Name='w3wp.exe'"
# Or view recent app pool crashes/events
Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-WAS'} -MaxEvents 50
```

**Look for:** Frequent restarts, rapid-fail protection events, crash stack traces.

---

#### 6) Inspect IIS logs and failed requests (fastest clues)

```powershell
# Locate log dir
(Get-WebConfigurationProperty -pspath IIS:\ -filter "system.applicationHost/sites/siteDefaults/logFile" -name directory).Value
# Tail latest log (PowerShell)
Get-ChildItem 'C:\inetpub\logs\LogFiles\W3SVC*' | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | ForEach-Object { Get-Content $_.FullName -Tail 40 }
```

Enable Failed Request Tracing for a specific status (e.g., 500):

```cmd
%windir%\system32\inetsrv\appcmd set config "MySite" -section:system.webServer/tracing/traceFailedRequestsLogging /enabled:"True"
```

**Look for:** `sc-status` and `sc-substatus` codes, `time-taken`, and request URLs.

---

#### 7) Check Event Viewer for detailed errors

Open **Event Viewer → Windows Logs → Application / System** or query:

```powershell
Get-WinEvent -FilterHashtable @{LogName='Application'; Level=2} -MaxEvents 50 | where {$_.Message -match 'IIS|w3wp|ASP.NET|WAS'}
```

**Look for:** .NET exceptions, module load failures, permission denied, or CLR errors.

---

#### 8) Validate web.config / application start errors

* Temporarily enable detailed errors (only on internal/test systems):

```xml
<!-- web.config -->
<system.web>
  <customErrors mode="Off" />
  <compilation debug="true" />
</system.web>
<system.webServer>
  <httpErrors errorMode="Detailed" />
</system.webServer>
```

* Check for XML syntax errors in `web.config` — invalid XML yields 500.19.

**Look for:** 500.19, 500.21 subcodes pointing to invalid configuration or missing modules.

---

#### 9) File system & permissions

```powershell
# Check ACLs for site folder
(Get-Acl 'C:\inetpub\mysite').Access | Format-Table IdentityReference, FileSystemRights, InheritanceFlags
```

Ensure AppPool identity (e.g., `IIS AppPool\MyAppPool` or gMSA) has read/execute on the content and read/write where needed (uploads/logs).

---

#### 10) SSL / Certificate issues (if HTTPS)

```powershell
Get-ChildItem Cert:\LocalMachine\My
netsh http show sslcert
```

**Look for:** Expired cert, wrong binding (cert hash mismatch), SNI misconfiguration.

---

#### 11) Firewall / Load balancer / Proxy

* Confirm local Windows Firewall allows port:

```powershell
Get-NetFirewallRule | Where-Object { $_.DisplayName -like '*IIS*' -or $_.DisplayName -like '*HTTP*' } 
Test-NetConnection serverip -Port 443
```

* If behind LB, verify health probe path and LB->node connectivity; check ARR or reverse-proxy config for rewrite loops.

---

#### 12) Application-specific checks

* Check database connectivity strings, remote resources, external API timeouts.
* Reproduce locally (run the app in debug if possible) or check app logs.

---

### 📋 Quick error-code cheat sheet

| HTTP Status   | Common cause in IIS                                         | Quick fix                                                               |
| ------------- | ----------------------------------------------------------- | ----------------------------------------------------------------------- |
| **503**       | App pool stopped / Rapid-fail protection / Identity failure | Start app pool, check identity, view WAS events                         |
| **500**       | App exception / web.config error                            | Check failed request trace, Event Viewer, enable detailed errors (test) |
| **500.19**    | web.config invalid or permission denied                     | Validate XML, check config file ACL                                     |
| **502 / 504** | Reverse proxy / ARR or LB upstream error                    | Check proxy logs, backend health probe                                  |

---

### ✅ Common fixes (apply once root cause found)

* **App pool stopped** → fix identity perms or replace bad native modules → restart pool.
* **web.config error** → correct XML/section or install missing IIS feature (ASP.NET, CGI).
* **Permission denied** → grant `IIS_IUSRS` or AppPool identity proper NTFS permissions.
* **SSL binding issues** → rebind cert with `netsh http add sslcert` using correct thumbprint.
* **Binding/Host header mismatch** → update site binding or DNS/hosts.
* **Port in use** → `netstat -ano | findstr :80` → stop conflicting service.
* **Rapid-fail** → inspect app exceptions, disable rapid-fail temporarily to gather info, then fix code.
* **Reverse proxy loop** → check X-Forwarded-Proto and rewrite rules.

---

### ✅ Best Practices during troubleshooting

* Reproduce safely: enable detailed errors only on non-prod or restricted IPs.
* Always back up `applicationHost.config` before major changes:

```powershell
%windir%\system32\inetsrv\appcmd add backup "Before_Troubleshoot"
```

* Use Failed Request Tracing (FREB) for deep dives into 5xx issues.
* Automate health checks and have log aggregation (ELK/Log Analytics) to speed diagnosis.

---

### 💡 In short

Start with network/DNS → ensure W3SVC/WAS running → verify site bindings and app pool state → check IIS logs & Event Viewer → inspect `web.config`, permissions, and SSL. Use `Get-Website`, `Get-WebAppPoolState`, IIS logs, and Failed Request Tracing to pinpoint the issue; then fix app pool identity, binding, permissions, or app errors accordingly.

---
## Q: Users Can’t Log into the Domain — Active Directory Troubleshooting Guide

---

### 🧠 Overview

When domain users **can’t log in**, it typically means **authentication** between the client, Domain Controller (DC), or network path is broken.
Root causes are usually related to **DNS**, **network reachability**, **time sync**, **account lockout**, or **replication issues** between DCs.

This guide provides a **structured, production-grade troubleshooting workflow** for **AD login failures**.

---

## ⚙️ Step-by-Step Troubleshooting

---

### 🧩 1️⃣ Verify Network & DNS Connectivity

**On the affected client:**

```powershell
# Ping DC and check DNS resolution
ping dc01.corp.local
nslookup dc01.corp.local
ipconfig /all
```

✅ **Expected:**

* Client DNS points to **Domain Controller’s IP**, not Google (8.8.8.8).
* DC responds to ping and resolves FQDN correctly.

> ⚠️ If DNS misconfigured, update the NIC DNS server to your DC:

```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 10.0.0.10
ipconfig /flushdns
```

---

### 🧩 2️⃣ Check Domain Controller Availability

Run from any DC or admin workstation:

```powershell
nltest /dclist:corp.local
```

✅ Should list all domain controllers.

Check connectivity to each DC:

```powershell
nltest /dsgetdc:corp.local
```

If it fails:

* DC might be offline or not advertising.
* Verify **Netlogon** and **Active Directory Domain Services** are running:

```powershell
Get-Service -Name Netlogon, NTDS
```

Start them if stopped:

```powershell
Start-Service Netlogon, NTDS
```

---

### 🧩 3️⃣ Verify Time Synchronization (Kerberos-critical)

Kerberos fails if time difference > 5 minutes between client & DC.

```powershell
w32tm /query /status
```

If time skew detected, sync manually:

```powershell
w32tm /resync /force
```

✅ Also ensure the PDC emulator has a reliable external NTP source.

---

### 🧩 4️⃣ Test Domain Trust / Authentication Channel

From a client:

```powershell
nltest /sc_verify:corp.local
```

✅ Should return:
`Status = 0x0 NERR_Success`

If it fails:

* Machine’s **secure channel** to the DC is broken.
  Fix it:

```powershell
Test-ComputerSecureChannel -Repair -Credential corp\AdminUser
```

Then reboot.

---

### 🧩 5️⃣ Check Account Lockout / Disabled Users

On the DC:

```powershell
Search-ADAccount -LockedOut
Get-ADUser -Filter 'Enabled -eq $false' | Select Name
```

Unlock accounts:

```powershell
Unlock-ADAccount -Identity vasu
```

Re-enable users if disabled:

```powershell
Enable-ADAccount -Identity vasu
```

---

### 🧩 6️⃣ Check AD Replication (multi-DC environments)

If passwords or objects don’t sync between DCs, authentication may fail.

```powershell
repadmin /replsummary
repadmin /showrepl
```

✅ Fix replication errors:

```powershell
repadmin /syncall /AdeP
```

Check **Event Viewer → Directory Service Log** for replication errors (Event ID 1311, 2087).

---

### 🧩 7️⃣ Confirm Domain Trusts (if multiple domains/forests)

```powershell
netdom trust dev.local /domain:corp.local /verify
```

✅ Should return success.

If broken, recreate or revalidate the trust.

---

### 🧩 8️⃣ Inspect Event Viewer for Authentication Failures

On DC:

```
Event Viewer → Windows Logs → Security
```

Look for:

| Event ID | Description                 |
| -------- | --------------------------- |
| **4625** | Failed logon attempt        |
| **4771** | Kerberos pre-auth failed    |
| **4768** | Kerberos TGT requested      |
| **4776** | NTLM authentication failure |

> Focus on reasons like **bad password**, **expired account**, or **unknown user**.

---

### 🧩 9️⃣ Validate Group Policy & Login Script Processing

```powershell
gpupdate /force
gpresult /r
```

If slow login or profile issues — check **SYSVOL** and **Netlogon** shares:

```powershell
net share
```

✅ You should see:

```
NETLOGON   C:\Windows\SYSVOL\sysvol\corp.local\SCRIPTS
SYSVOL     C:\Windows\SYSVOL\sysvol
```

If missing, fix **File Replication Service (FRS)** or **DFS-R** issues.

---

### 🧩 🔟 Check DC Health

Run:

```powershell
dcdiag /v /c /d /e /s:dc01 > C:\temp\dcdiag.txt
```

Analyze output for:

* **Netlogon** errors
* **DNS registration issues**
* **Replication failures**

---

### 🧩 11️⃣ Password Expired or User Policy Conflict

```powershell
net user vasu /domain
```

Check for:

* “Password expired”
* “User may not change password”
* “Logon hours allowed” (ensure user has valid logon times)

Reset password if expired:

```powershell
Set-ADAccountPassword -Identity vasu -Reset -NewPassword (Read-Host -AsSecureString)
```

---

### 🧩 12️⃣ Client Machine AD Binding

If a specific PC can’t log in to the domain:

* Remove and rejoin the domain:

```powershell
Remove-Computer -UnjoinDomainCredential corp\AdminUser -PassThru -Verbose -Restart
Add-Computer -DomainName "corp.local" -Credential corp\AdminUser -Restart
```

---

## 📋 Common Root Causes & Fixes

| Symptom                      | Likely Cause                       | Fix                                  |
| ---------------------------- | ---------------------------------- | ------------------------------------ |
| All users can’t log in       | DC or Netlogon service down        | Restart AD DS, verify replication    |
| One site impacted            | WAN / replication / DNS issue      | Check site link replication          |
| Some users only              | Locked, disabled, expired accounts | Unlock/enable, reset password        |
| “Clock skew too great”       | Time mismatch                      | Run `w32tm /resync`                  |
| “Cannot contact DC”          | Network / firewall / DNS issue     | Check port 88, 389, 445, 135         |
| “Trust relationship failed”  | Broken machine account             | `Test-ComputerSecureChannel -Repair` |
| Login very slow              | GPO or SYSVOL not replicating      | Fix DFS-R / replication              |
| Users in another forest fail | Broken forest trust                | Verify with `netdom trust`           |

---

### ✅ Best Practices

* Always verify **DNS** before touching AD.
* Configure **NTP sync** on all DCs and clients.
* Monitor DC health with:

  ```powershell
  dcdiag /test:Connectivity /test:DNS /test:NetLogons
  ```
* Use **multiple DCs** per site for redundancy.
* Regularly review **Event ID 4771 & 4625** for authentication failures.
* Automate **AD replication health checks** in your monitoring (Zabbix, SCOM, Prometheus, etc.).

---

### 💡 In short

If users can’t log in to the domain:

1. Check **DNS → Network → DC availability**
2. Verify **time sync** and **Netlogon** service
3. Repair **secure channel** if needed
4. Inspect **account status and replication**
5. Run **dcdiag** and **repadmin** for root cause

✅ 90% of domain login failures trace back to **DNS misconfigurations, time drift, or replication issues** between DCs.

---
## Q: Group Policy (GPO) Not Applying — Troubleshooting Guide 🧩

---

### 🧠 Overview

When a **Group Policy Object (GPO)** doesn’t apply, it usually means a problem in **scope**, **replication**, **permissions**, **network connectivity**, or **client processing**.
This guide helps you **systematically diagnose and fix** GPO issues affecting users or computers in an **Active Directory domain**.

---

### ⚙️ Purpose / How it works

Group Policy settings flow from **AD → SYSVOL → Client**.
If any stage (DC replication, permissions, GPO link, or client refresh) breaks, policies won’t apply.
Clients fetch GPOs during:

* **Startup / Logon**
* **Periodic refresh** (`gpupdate`)
* Or **forced refresh** by admin

---

## 🧩 Step-by-Step Troubleshooting

---

### 1️⃣ Confirm Domain Connectivity & DNS Resolution

**On the affected client:**

```powershell
echo %logonserver%
nltest /dsgetdc:corp.local
ipconfig /all
```

✅ **Expected:**

* DNS server = Domain Controller
* Correct domain logon server (not `\\localhost` or blank)
* Network can reach DC over ports 389 (LDAP), 445 (SMB), 135 (RPC)

> ⚠️ GPOs rely on **DNS + SMB (SYSVOL)**; using wrong DNS (like 8.8.8.8) breaks policy delivery.

---

### 2️⃣ Force Policy Refresh

```powershell
gpupdate /force
```

✅ Expected output:

```
Updating policy...
Computer Policy update has completed successfully.
User Policy update has completed successfully.
```

If it says:

> *“The processing of Group Policy failed. Windows attempted to read the file … from a domain controller …”*

→ Likely a **SYSVOL replication** or **network** problem (see Step 5).

---

### 3️⃣ View Which Policies Are Applied

```powershell
gpresult /r
```

Or for detailed HTML report:

```powershell
gpresult /h C:\GPOReport.html
start C:\GPOReport.html
```

✅ Check:

* **Applied Group Policy Objects** — ensure your GPO appears.
* **Denied GPOs** — shows if blocked or filtered (by security or WMI filter).

---

### 4️⃣ Check GPO Scope (Link, OU, Filtering)

| Check                 | Command                                                   | Description                                                |
| --------------------- | --------------------------------------------------------- | ---------------------------------------------------------- |
| Linked to correct OU? | ADUC → Right-click OU → **Properties → Group Policy tab** | GPO must be linked to OU containing target user/computer.  |
| Security Filtering    | GPMC → GPO → **Scope tab**                                | Group must have *Read* + *Apply Group Policy* permissions. |
| WMI Filter            | GPMC → GPO → **WMI Filtering**                            | WMI query must match client’s system attributes.           |

> 💡 Common issue: GPO linked at wrong OU or security filter excludes the target group.

---

### 5️⃣ Verify SYSVOL Replication

**On Domain Controllers:**

```powershell
repadmin /replsummary
```

Check for **replication errors** — if SYSVOL isn’t consistent, GPOs may be missing or outdated.

**On a DC:**

```powershell
net share
```

✅ Should show:

```
SYSVOL   C:\Windows\SYSVOL\sysvol
NETLOGON C:\Windows\SYSVOL\sysvol\corp.local\SCRIPTS
```

If missing → check **DFS-R / FRS replication**:

```powershell
dfsrdiag backlog /rgname:"Domain System Volume" /rfname:"SYSVOL Share"
```

Fix replication or restart **DFS Replication** service:

```powershell
Restart-Service DFSR
```

---

### 6️⃣ Check Event Viewer (Client Side)

Open:

```
Event Viewer → Applications and Services Logs → Microsoft → Windows → GroupPolicy → Operational
```

Look for:

| Event ID | Description                                                |
| -------- | ---------------------------------------------------------- |
| **1058** | Failed to read GPO from SYSVOL (network/DNS issue)         |
| **1030** | Failed to retrieve policy list (replication or auth issue) |
| **1129** | Slow link detection triggered fallback                     |
| **7016** | GPO applied successfully                                   |

**Example fix for 1058/1030:**

* Ensure `\\domain.local\SYSVOL` is reachable:

```powershell
dir \\corp.local\SYSVOL
```

If access denied, check **NTFS and share permissions** on SYSVOL.

---

### 7️⃣ Check Permissions on GPO

Open GPMC → Select GPO → **Delegation Tab** → Confirm:

* `Authenticated Users` → *Read* + *Apply Group Policy*
* Or custom security group with those permissions

Fix via PowerShell:

```powershell
Set-GPPermissions -Name "Workstation Policy" -TargetName "Domain Computers" -TargetType Group -PermissionLevel GpoApply
```

---

### 8️⃣ Validate GPO Inheritance and Blockings

Check OU hierarchy:

* **Blocked inheritance** → OU → right-click → "Block Inheritance" disables parent GPOs.
* **Enforced GPO** → overrides block.

Use:

```powershell
gpresult /scope computer /v
```

Check the "Denied GPOs" section — often lists inheritance or filtering issues.

---

### 9️⃣ Network Latency / Offline Issues

Group Policy defaults to "slow link" detection if network speed <500 Kbps.
Force it to always apply:

```powershell
Set-GPRegistryValue -Name "Network Policy" -Key "HKLM\Software\Policies\Microsoft\Windows\System" -ValueName "GroupPolicyMinTransferRate" -Type DWord -Value 0
```

Also verify computer can reach DC at startup (no VPN delay).

---

### 🔟 Check Client-Side Extension (CSE) Failures

Each GPO type (e.g., Folder Redirection, Drive Maps, Scripts, Security) uses a specific CSE.
Check **Event Viewer → GroupPolicy/Operational** for CSE error messages.

Example:

* **Event 1085** → Folder Redirection CSE failure
* **Event 4098** → Logon script issue

---

### 🧱 11️⃣ Use PowerShell for GPO Diagnostics

```powershell
# Verify GPO links
Get-GPLink -Target "OU=Workstations,DC=corp,DC=local"

# List all GPOs
Get-GPO -All | Select DisplayName, GpoStatus

# Backup all GPOs (for audit)
Backup-GPO -All -Path "C:\GPOBackups"
```

---

### ✅ 12️⃣ Common Root Causes & Fixes

| Symptom                                          | Root Cause                          | Fix                                |
| ------------------------------------------------ | ----------------------------------- | ---------------------------------- |
| GPO not listed in `gpresult`                     | Wrong OU / Filter                   | Relink or update scope             |
| “The system cannot find the path \domain\sysvol” | SYSVOL/DNS issue                    | Fix replication, check DFSR        |
| Only some users affected                         | Security filtering                  | Add users/groups to GPO scope      |
| GPO applies on some DCs but not others           | Replication delay                   | Force replication                  |
| GPO applies after login only                     | Slow startup or WMI filter mismatch | Adjust WMI filter or force refresh |
| GPO denied in `gpresult`                         | Blocked inheritance / filter        | Enforce GPO or remove block        |
| Event 1058 / 1030                                | Network / DFSR / permissions        | Fix DC connectivity, reset DFSR    |
| Client in workgroup                              | Not domain-joined                   | Rejoin domain                      |

---

### ✅ Best Practices

* Always use **authenticated DNS resolution** (no public DNS).
* Create **OU-based delegation** — link GPOs to appropriate OUs.
* Use **Versioning / GPO backup** before edits:

  ```powershell
  Backup-GPO -Name "Default Domain Policy" -Path "C:\Backup\GPOs"
  ```
* Monitor DC replication health (`repadmin /replsummary`).
* Use **Event ID 1502–1504** to catch login script or policy load issues.
* For critical GPOs, enable **“Enforced”** to guarantee application.

---

### 💡 In short

If **GPO isn’t applying**:

1. Confirm **DNS + domain connectivity**
2. Run `gpupdate /force` and `gpresult /r`
3. Check **GPO scope, link, and filtering**
4. Verify **SYSVOL replication and DC health**
5. Inspect **Event Viewer (1058/1030)**

✅ 90% of GPO issues = **wrong OU, DNS misconfig, or SYSVOL replication failure**.

---
## Q: IIS Website Returns 403 Forbidden Error

---

### 🧠 Overview

A **403 Forbidden** error in IIS means the **web server understood the request but refused to authorize it**.
This happens when the requested URL is valid, but **permissions**, **authentication**, or **authorization rules** block access.
It’s one of the most common IIS production issues — especially after deployments, migrations, or security hardening.

---

### ⚙️ Purpose / How it works

When a request hits IIS:

1. IIS checks **bindings and URL authorization**
2. Then applies **authentication (Anonymous, Windows, etc.)**
3. Next, it checks **NTFS file permissions** and **web.config authorization rules**
4. If any step fails — it throws a **403.x** code

The **substatus code** (`403.1`, `403.14`, etc.) indicates the exact cause.

---

### 🧩 Common 403 Substatus Codes

| Code             | Meaning                         | Typical Cause                        | Fix                                             |
| ---------------- | ------------------------------- | ------------------------------------ | ----------------------------------------------- |
| **403.1**        | Execute access forbidden        | CGI/ISAPI execution disabled         | Enable "Execute" permission                     |
| **403.2**        | Read access forbidden           | Folder lacks read permissions        | Grant `IIS_IUSRS` read rights                   |
| **403.3**        | Write access forbidden          | IIS or NTFS blocks write             | Enable write or correct ACL                     |
| **403.4**        | SSL required                    | Request over HTTP but HTTPS required | Use `https://` or disable SSL requirement       |
| **403.5**        | SSL 128 required                | Client using weak cipher             | Use stronger SSL/TLS                            |
| **403.6**        | IP address rejected             | IP restricted in site settings       | Remove IP restriction rule                      |
| **403.7**        | Client certificate required     | SSL client cert missing              | Install or disable requirement                  |
| **403.8**        | Site access denied              | URL Authorization / IP rule          | Check IP/domain restrictions                    |
| **403.9**        | Too many users                  | Concurrent connections limit         | Increase limit or check licensing               |
| **403.12**       | Mapper denied access            | Invalid user mapping                 | Fix authentication mapping                      |
| **403.14**       | Directory listing denied        | Default document missing             | Add default doc (index.html) or enable browsing |
| **403.16 / .17** | Client cert untrusted / expired | Invalid client certificate           | Install trusted CA certs                        |

---

### 🧩 1️⃣ Check Site & File Permissions

#### Verify NTFS Permissions

```powershell
$path = "C:\inetpub\mysite"
Get-Acl $path | Format-Table -AutoSize
```

✅ Ensure:

* App pool identity (e.g., `IIS AppPool\MyAppPool`) or group `IIS_IUSRS`
  has **Read & Execute** permissions on the folder and files.

Add missing permission:

```powershell
icacls "C:\inetpub\mysite" /grant "IIS_IUSRS:(OI)(CI)(RX)"
```

---

### 🧩 2️⃣ Check IIS Authentication Settings

In IIS Manager → Select your site → **Authentication**:

| Setting                      | When to Enable                     |
| ---------------------------- | ---------------------------------- |
| **Anonymous Authentication** | For public sites or static content |
| **Windows Authentication**   | For internal domain users          |
| **Basic Authentication**     | For legacy or external systems     |
| **Forms Authentication**     | For web apps handling login pages  |

#### PowerShell Check

```powershell
Get-WebConfigurationProperty -Filter system.webServer/security/authentication/* -PSPath IIS:\Sites\MySite
```

If both **Anonymous** and **Windows Auth** are disabled → IIS returns 403.

---

### 🧩 3️⃣ Verify Directory Browsing or Default Document

If the site root has no default file (e.g., `index.html`, `default.aspx`), IIS throws `403.14`.

#### Fix:

Enable directory browsing (optional):

```powershell
Set-WebConfigurationProperty -filter system.webServer/directoryBrowse -name enabled -value true -PSPath IIS:\Sites\MySite
```

Or add a default document:

```powershell
Add-WebConfigurationProperty -pspath IIS:\ -filter system.webServer/defaultDocument/files -name "." -value @{value='index.html'}
```

---

### 🧩 4️⃣ Check `web.config` Authorization Rules

Inspect the `web.config` file for `<authorization>` settings:

```xml
<system.web>
  <authorization>
    <deny users="?" />  <!-- denies anonymous -->
    <allow users="DOMAIN\User1" />
  </authorization>
</system.web>
```

✅ Ensure:

* Deny/Allow rules are correct.
* `"?"` = anonymous users, `"*"` = everyone.

To allow all:

```xml
<authorization>
  <allow users="*" />
</authorization>
```

---

### 🧩 5️⃣ Validate App Pool Identity Access

Find which identity runs the app pool:

```powershell
Get-ItemProperty IIS:\AppPools\MyAppPool | Select name, processModel.identityType, processModel.userName
```

If using **Custom** identity, make sure that user has **NTFS Read/Execute** rights to:

* Website root
* `web.config`
* Any dependent content folder

---

### 🧩 6️⃣ Check IP and Domain Restrictions

In IIS Manager → `IP Address and Domain Restrictions`

Or via PowerShell:

```powershell
Get-WebConfiguration system.webServer/security/ipSecurity -PSPath IIS:\Sites\MySite
```

If you see entries like:

```xml
<ipSecurity allowUnlisted="false">
  <add ipAddress="10.10.10.10" allowed="true" />
</ipSecurity>
```

✅ Either set `allowUnlisted="true"` or remove restrictive entries.

---

### 🧩 7️⃣ SSL/HTTPS Enforcement

If site enforces SSL (403.4), check:

```powershell
Get-WebConfigurationProperty -Filter system.webServer/security/access -PSPath IIS:\Sites\MySite
```

Disable SSL requirement temporarily for testing:

```powershell
Set-WebConfigurationProperty -Filter system.webServer/security/access -Name sslFlags -Value "None" -PSPath IIS:\Sites\MySite
```

---

### 🧩 8️⃣ Check Event Viewer & Logs

#### IIS Log (403 details)

```
C:\inetpub\logs\LogFiles\W3SVC1\u_exYYMMDD.log
```

Look for:

```
sc-status: 403
sc-substatus: 14
```

→ use substatus table above.

#### Event Viewer:

```
Event Viewer → Windows Logs → Security / System / Application
```

Look for event IDs **4625 (failed logon)** or **4013 (IIS Auth failure)**.

---

### 🧩 9️⃣ Test with Static File

Drop a simple HTML file:

```
C:\inetpub\mysite\test.html
```

Access via browser:

```
http://servername/test.html
```

✅ If it works → problem is in app/web.config
❌ If still 403 → permissions, authentication, or IIS config.

---

### 🧩 10️⃣ Firewall or URL Rewrite Blocking

If using **URL Rewrite**, verify no rule incorrectly denies access:

```xml
<rule name="Block Admin Access" stopProcessing="true">
  <match url="admin/*" />
  <action type="CustomResponse" statusCode="403" />
</rule>
```

Comment out or adjust incorrectly restrictive rules.

---

### 📋 Common Root Causes & Fixes

| Issue                        | Error         | Fix                                            |
| ---------------------------- | ------------- | ---------------------------------------------- |
| Missing default file         | 403.14        | Add `index.html` or enable directory browsing  |
| App pool lacks folder access | 403.2         | Grant `IIS_IUSRS` or app pool user read access |
| Anonymous disabled           | 403.1 / 403.2 | Enable Anonymous Authentication                |
| IP restrictions              | 403.6 / 403.8 | Update IP allow list                           |
| SSL required                 | 403.4         | Access via HTTPS or disable SSL flag           |
| Bad web.config rules         | 403.x         | Fix `<authorization>` section                  |
| URL Rewrite blocking         | 403           | Review rewrite rules                           |
| Permissions on shared folder | 403           | NTFS + Share perms for app pool identity       |

---

### ✅ Best Practices

* Always check **403 substatus** — it pinpoints the cause.
* Ensure correct **permissions chain**: IIS site → App Pool → Folder → Files.
* Keep **Anonymous Authentication enabled** for public sites.
* Verify **NTFS permissions** after deployment or copy.
* Review **web.config** for unintended `<deny users="*">`.
* Maintain **IIS logs** with timestamp correlation for quick analysis.

---

### 💡 In short

A 403 means IIS received the request but **denied access**.
Check:

1. **Substatus code** (403.x)
2. **NTFS permissions** (`IIS_IUSRS`, app pool identity)
3. **Authentication mode**
4. **web.config authorization**
5. **Default document or SSL requirement**

✅ 403.14 = Missing default page
✅ 403.2 = NTFS or authentication issue
✅ 403.4 = HTTP→HTTPS redirect required

Fix the root cause based on the substatus — **permissions and authentication misconfigurations** cause 90% of 403 errors.

--- 
Good question — let’s clarify this 👇

The type of questions I just gave you (IIS, Domain Controller, AD, DNS, GPO, PowerShell, etc.) generally fall under **Windows System Administration** or **Windows Server Administration** — not end-user desktop support.

Here’s how the roles break down 👇

| **Role Title**                                 | **Focus Area**                                          | **Example Topics Covered**                                               |
| ---------------------------------------------- | ------------------------------------------------------- | ------------------------------------------------------------------------ |
| 🖥️ **Windows System Administrator**           | Core Windows Server setup & management                  | Active Directory, DNS, DHCP, IIS, GPO, File Shares, Backup, PowerShell   |
| 🧱 **Windows Server Administrator**            | Similar to System Admin, but server-only scope          | Domain Controllers, Failover Clustering, IIS, AD Sites, WSUS             |
| ⚙️ **Infrastructure Engineer (Windows)**       | End-to-end infra including cloud/on-prem                | AD Federation, DNS, IIS, RDP, Group Policy, Hybrid (Azure AD / AWS AD)   |
| ☁️ **Cloud Windows Administrator (AWS/Azure)** | Windows servers in cloud (EC2, EBS, FSx, SSM, Azure VM) | EC2 Windows patching, domain joins, FSx shares, CloudWatch logs          |
| 🔐 **Active Directory Administrator**          | Focused on identity & access                            | User provisioning, GPOs, Kerberos, LDAP, trust relationships             |
| 🌐 **IIS Administrator / Web Admin**           | Web hosting and configuration on IIS                    | App Pools, HTTPS binding, ARR load balancing, troubleshooting 500 errors |

---
## Q: DNS Name Not Resolving — Troubleshooting Guide 🌐

---

### 🧠 Overview

When a **DNS name fails to resolve**, it means the system can’t translate the hostname (e.g., `app.corp.local`) into an IP address.
This issue commonly affects **domain logons, IIS sites, GPOs, and internal apps**, since Active Directory and IIS heavily rely on DNS for communication.

---

### ⚙️ Purpose / How it works

DNS resolution follows this chain:
**Client → Local cache → DNS server → Forwarders → Root hints**
If any step fails — you’ll get errors like:

* ❌ *“DNS name does not exist”*
* ❌ *“Ping request could not find host”*
* ❌ *“Cannot contact domain controller”*

We’ll verify **connectivity, configuration, and DNS server health** systematically.

---

## 🧩 Step-by-Step Troubleshooting

---

### 1️⃣ Check Basic Connectivity

```powershell
ping <IP>
ping <hostname>
```

✅ **If IP works but hostname fails → it’s DNS-related.**

Next, test DNS directly:

```powershell
nslookup app.corp.local
```

* If you get **“Non-existent domain”** → record missing in DNS.
* If you get **“Timed out”** → DNS server unreachable.

---

### 2️⃣ Verify DNS Server Settings on Client

```powershell
ipconfig /all
```

✅ Ensure:

* DNS server IP points to **your Domain Controller (DC)**, not 8.8.8.8 or 1.1.1.1.
* Connection-specific suffix is correct (`corp.local`).

If incorrect:

```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 10.0.0.10
ipconfig /flushdns
ipconfig /registerdns
```

---

### 3️⃣ Clear and Rebuild DNS Cache

```powershell
ipconfig /flushdns
ipconfig /displaydns
```

Then re-register the computer’s DNS record:

```powershell
ipconfig /registerdns
```

✅ You should see:

> “Registration of the DNS resource records for all adapters has been initiated successfully.”

---

### 4️⃣ Check DNS Zone and Records (on DNS Server)

Open **DNS Manager (`dnsmgmt.msc`)** → Expand your zone (`corp.local`) → verify:

* A (Host) record for the hostname exists
* Reverse (PTR) record created (optional)
* Zone is **Active** and not paused

Or use PowerShell:

```powershell
Get-DnsServerResourceRecord -ZoneName "corp.local" -Name "app"
```

Add missing record:

```powershell
Add-DnsServerResourceRecordA -ZoneName "corp.local" -Name "app" -IPv4Address 10.0.0.25
```

---

### 5️⃣ Test DNS Server Reachability

From client:

```powershell
Test-NetConnection -ComputerName 10.0.0.10 -Port 53
```

✅ Should show:

```
TcpTestSucceeded : True
```

If it fails:

* Check firewall on DNS server:

```powershell
Get-NetFirewallRule | where DisplayName -like '*DNS*'
```

* Ensure **DNS Server service** is running:

```powershell
Get-Service DNS
Start-Service DNS
```

---

### 6️⃣ Validate Forward Lookup Zones

In **DNS Manager → Forward Lookup Zones**:

* Confirm your zone (`corp.local`) exists.
* Verify **Start of Authority (SOA)** and **Name Server (NS)** records.

PowerShell check:

```powershell
Get-DnsServerZone
```

If zone is missing → recreate:

```powershell
Add-DnsServerPrimaryZone -Name "corp.local" -ReplicationScope "Domain"
```

---

### 7️⃣ Check DNS Forwarders / Conditional Forwarders

If the name belongs to **another domain** (e.g., `dev.local`), verify forwarders:

```powershell
Get-DnsServerForwarder
```

Add or fix forwarder:

```powershell
Add-DnsServerForwarder -IPAddress 10.1.0.10
```

For specific domains:

```powershell
Add-DnsServerConditionalForwarderZone -Name "dev.local" -MasterServers 10.1.0.10
```

---

### 8️⃣ Verify Replication of DNS Records (Multi-DC Setup)

Replication problems cause outdated or missing records on some DCs.

```powershell
repadmin /showrepl
repadmin /replsummary
```

Force sync:

```powershell
repadmin /syncall /AdeP
```

---

### 9️⃣ Check Event Viewer for DNS Errors

On the DNS Server:

```
Event Viewer → Applications and Services Logs → Microsoft → Windows → DNS-Server
```

Common Event IDs:

| ID       | Meaning                          | Action                                      |
| -------- | -------------------------------- | ------------------------------------------- |
| **4013** | DNS waiting for AD replication   | Wait for replication / restart DNS          |
| **4000** | DNS service encountered AD error | Verify AD DS health                         |
| **4015** | DNS server critical failure      | Restart DNS service, check zone replication |

---

### 🔟 Test Using Alternate Tools

**Resolve-DnsName** (PowerShell alternative to `nslookup`):

```powershell
Resolve-DnsName app.corp.local -Server 10.0.0.10
```

**DNSLint** (Advanced validation):

```cmd
dnslint /d corp.local /ad /s 10.0.0.10
```

---

### 📋 Common Root Causes & Fixes

| Problem                      | Root Cause                          | Fix                                 |
| ---------------------------- | ----------------------------------- | ----------------------------------- |
| Can ping IP but not hostname | Wrong DNS server / cache            | Point client DNS to DC, flush cache |
| “Non-existent domain”        | Missing A record                    | Add A record manually               |
| Works on one PC, not another | Client cache or DNS suffix mismatch | Flush cache, verify suffix          |
| Cross-domain name fails      | Missing conditional forwarder       | Add forwarder between zones         |
| New record not found         | DNS replication delay               | Force `repadmin /syncall`           |
| Intermittent resolution      | Secondary DNS misconfigured         | Remove public DNS from NIC          |
| Clients use ISP DNS          | Split-brain / wrong resolver        | Enforce AD DNS via DHCP or GPO      |

---

### ✅ Best Practices

* All **domain clients must use internal DNS (AD-integrated)**.
* Never configure **external/public DNS** on domain clients.
* Use **DHCP** to hand out the correct DNS servers.
* Monitor DNS service health:

  ```powershell
  dcdiag /test:DNS /v
  ```
* Enable **scavenging** to clean stale records:

  ```powershell
  Set-DnsServerScavenging -ScavengingInterval 7.00:00:00 -ApplyOnAllZones
  ```
* Regularly back up DNS zones:

  ```powershell
  Export-DnsServerZone -Name "corp.local" -FileName "corp.local.dns"
  ```

---

### 💡 In short

If a **DNS name isn’t resolving**:

1. Check **DNS server IP** on client (`ipconfig /all`)
2. Run **`nslookup`** to see if record exists
3. Fix **missing A record or forwarder** in DNS Manager
4. Ensure **DNS service and replication** are healthy (`repadmin /replsummary`)
5. Avoid **external DNS** for domain clients

✅ 90% of resolution issues = **clients using wrong DNS** or **missing A records** in AD DNS.

---
## Q: SSL Certificate Expired — IIS / Windows Server Troubleshooting Guide 🔒

---

### 🧠 Overview

An **expired SSL/TLS certificate** causes browsers or applications to reject secure HTTPS connections with warnings like:

> “⚠️ Your connection is not private” or “ERR_CERT_DATE_INVALID”.

This typically happens when the **IIS website certificate has passed its validity period**, affecting **HTTPS, LDAPS, or API endpoints**.
Below are the steps to **verify, renew, install, and rebind** an SSL certificate in IIS.

---

### ⚙️ Purpose / How it works

When clients connect via HTTPS:

1. IIS presents the site’s SSL certificate.
2. The browser checks validity (issuer, CN/SAN, expiration).
3. If expired, trust fails →  **IIS still serves traffic, but clients reject it**.

---

## 🧩 Step-by-Step Resolution

---

### 1️⃣ Verify Certificate Expiration

#### 🪟 From IIS:

* Open **IIS Manager → Site → Bindings → https → View → Details tab**
* Check **Valid from / to** dates.

#### 🧠 PowerShell:

```powershell
Get-ChildItem Cert:\LocalMachine\My | Select-Object FriendlyName, Subject, NotAfter
```

✅ Look for expired (`NotAfter` < Today) entries.

---

### 2️⃣ Generate or Request a New Certificate

You can use **internal CA**, **public CA (e.g., DigiCert, GoDaddy, Let’s Encrypt)**, or **ACME automation**.

#### 🧩 Option A: Using Certificate Authority (CA)

```powershell
# Generate a certificate signing request (CSR)
New-SelfSignedCertificate -DnsName "site.corp.local" -CertStoreLocation Cert:\LocalMachine\My -KeyExportPolicy Exportable -NotAfter (Get-Date).AddYears(1)
```

Export CSR (if required):

```powershell
certreq -new C:\cert\request.inf C:\cert\request.req
```

Submit `.req` to your internal CA or external CA → download `.cer` or `.pfx`.

#### 🧩 Option B: Using Let’s Encrypt (Free, Automated)

Use **win-acme (WACS)** tool:

```cmd
wacs.exe --target manual --host site.corp.local --installation iis --store centralssl --sslport 443 --renew 60 --email admin@corp.local
```

---

### 3️⃣ Import the New Certificate into Windows

If you have a `.pfx` file:

```powershell
Import-PfxCertificate -FilePath "C:\certs\site_corp_local.pfx" -CertStoreLocation Cert:\LocalMachine\My
```

Or manually via:

* MMC → Certificates (Local Computer) → Personal → Import

✅ Ensure private key is included and trusted chain exists (CA + Intermediate).

---

### 4️⃣ Bind the New Certificate in IIS

#### GUI:

1. Open **IIS Manager → Sites → Bindings → https**
2. Select the binding → **Edit**
3. Choose the **new certificate** from the dropdown
4. Click **OK** and restart site

#### PowerShell:

```powershell
$cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -like "*site.corp.local*" }
New-WebBinding -Name "MySite" -Protocol https -Port 443
Push-Location IIS:\SslBindings
Get-Item cert:\LocalMachine\My\$($cert.Thumbprint) | New-Item 0.0.0.0!443
Pop-Location
```

---

### 5️⃣ Remove Old Expired Certificates

(Optional but recommended)

```powershell
Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.NotAfter -lt (Get-Date)} | Remove-Item
```

---

### 6️⃣ Restart IIS and Test HTTPS

Restart IIS:

```powershell
iisreset /restart
```

Test:

```powershell
Test-NetConnection site.corp.local -Port 443
```

Check via browser:

* `https://site.corp.local` → padlock icon should be green.
* Click certificate → confirm new expiration date.

---

### 🧩 7️⃣ Automate Renewal (Optional but Best Practice)

#### For internal certs (PowerShell task):

```powershell
Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.NotAfter -lt (Get-Date).AddDays(30) } | 
ForEach-Object { Renew-Certificate -Thumbprint $_.Thumbprint }
```

#### For Let’s Encrypt (WACS):

* Run:

  ```cmd
  wacs.exe --renew --baseuri https://acme-v02.api.letsencrypt.org/
  ```
* Or schedule via Windows Task Scheduler every week.

---

### 🧩 8️⃣ Verify via Browser or CLI

#### Browser:

* Click 🔒 → Certificate → Validity period.

#### CLI:

```bash
openssl s_client -connect site.corp.local:443 | openssl x509 -noout -dates
```

Output:

```
notBefore=Nov 10 08:00:00 2024 GMT
notAfter=Nov 10 08:00:00 2025 GMT
```

---

### 📋 Common Root Causes & Fixes

| Problem                                   | Root Cause                          | Fix                                                  |
| ----------------------------------------- | ----------------------------------- | ---------------------------------------------------- |
| Site shows expired cert                   | Certificate not renewed or re-bound | Import new cert & bind to site                       |
| Renewal installed but still using old one | IIS binding not updated             | Edit binding → select new cert                       |
| Clients show chain error                  | Missing intermediate CA             | Install CA/intermediate certs                        |
| Cert renewed on wrong server              | Load balancer / web farm sync issue | Copy updated cert to all nodes                       |
| Auto-renew failed                         | Task Scheduler / permissions        | Check WACS or renewal task logs                      |
| LDAPS login fails                         | Domain Controller cert expired      | Request new DC Auth cert, import in “Personal” store |

---

### ✅ Best Practices

* Monitor expiration proactively:

  ```powershell
  Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.NotAfter -lt (Get-Date).AddDays(30) }
  ```
* Set renewal alerts (email/monitoring).
* Use **ACME or centralized certificate management** for automation.
* Always install **Intermediate CA certificates** if required.
* For multi-node farms, distribute new certs via **Group Policy or PowerShell script**.

---

### 💡 In short

If your IIS website shows an **expired certificate**:

1. Check expiry date → `Get-ChildItem Cert:\LocalMachine\My`
2. Obtain or renew cert (CA or Let’s Encrypt)
3. Import to Windows certificate store
4. Rebind it in IIS
5. Restart IIS and verify HTTPS

✅ **Key takeaway:** Renewal ≠ Replacement — always **rebind the new cert** in IIS after renewal to activate it.

---
## Q: Domain Trust Failure — Troubleshooting Guide 🔐

---

### 🧠 Overview

A **domain trust failure** means the **secure channel** between **two domains or forests** in Active Directory (AD) has been broken.
This can cause users to see errors like:

> ❌ *“The trust relationship between this workstation and the primary domain failed.”*
> or
> ❌ *“The trust relationship between the two domains failed.”*

Trust failures usually affect **authentication**, **cross-domain access**, and **replication**.

---

### ⚙️ Purpose / How it works

* Trusts allow **secure authentication** between AD domains/forests.
* They rely on a **shared secret (password)** maintained between **Domain Controllers (DCs)**.
* If the secret or synchronization breaks (due to replication, clock drift, or network issues), the **Kerberos authentication handshake fails**, breaking trust.

---

## 🧩 Types of Trust Failures

| Scope             | Example              | Description                                                   |
| ----------------- | -------------------- | ------------------------------------------------------------- |
| **Machine trust** | Workstation ↔ Domain | Workstation’s secure channel with domain controller is broken |
| **Domain trust**  | DomainA ↔ DomainB    | Authentication between two AD domains fails                   |
| **Forest trust**  | ForestA ↔ ForestB    | Cross-forest authentication or resource access fails          |

---

## 🧩 Step-by-Step Troubleshooting

---

### 1️⃣ Verify the Trust from Both Domains

Run from **both domain controllers**:

```powershell
# Verify trust from DomainA
netdom trust DomainB /domain:DomainA /verify

# From DomainB
netdom trust DomainA /domain:DomainB /verify
```

✅ Expected output:

```
The trust relationship verification was successful.
```

❌ If it fails — the trust password or replication between DCs is broken.

---

### 2️⃣ Revalidate the Trust

```powershell
netdom trust DomainB /domain:DomainA /verify /usero:DomainA\Admin /passwordo:*
```

If it still fails:

```powershell
netdom trust DomainB /domain:DomainA /reset /usero:DomainA\Admin /passwordo:*
```

Then confirm:

```powershell
netdom trust DomainB /domain:DomainA /verify
```

---

### 3️⃣ Check DNS Resolution Between Domains

```powershell
nslookup dc1.domainb.local
ping dc1.domainb.local
```

✅ Ensure both domains can resolve each other’s **Domain Controllers (DCs)**.

If not, configure **DNS Conditional Forwarders**:

```powershell
Add-DnsServerConditionalForwarderZone -Name "domainb.local" -MasterServers 10.10.2.10
Add-DnsServerConditionalForwarderZone -Name "domaina.local" -MasterServers 10.10.1.10
```

---

### 4️⃣ Check Time Synchronization (Kerberos Sensitive)

If clocks differ by >5 minutes, Kerberos trust fails.

```powershell
w32tm /query /status
w32tm /resync /force
```

Ensure all DCs and clients sync with a **common NTP source** (ideally, the forest root PDC emulator).

---

### 5️⃣ Validate Domain Controller Health

Run these from both DCs:

```powershell
dcdiag /v /c /d /e /s:dc1
repadmin /replsummary
repadmin /showrepl
```

✅ Check for:

* AD replication errors
* DNS misconfigurations
* Event IDs **1311**, **2087**, **4015**

If replication fails:

```powershell
repadmin /syncall /AdeP
```

---

### 6️⃣ Rebuild the Machine Trust (if workstation trust failure)

Run on the **affected workstation or member server**:

```powershell
Test-ComputerSecureChannel
```

If it returns `False`:

```powershell
Test-ComputerSecureChannel -Repair -Credential corp\AdminUser
```

Reboot after repair.

Or remove and rejoin the domain:

```powershell
Remove-Computer -UnjoinDomainCredential corp\AdminUser -PassThru -Verbose -Restart
Add-Computer -DomainName "corp.local" -Credential corp\AdminUser -Restart
```

---

### 7️⃣ Reset the Trust Password (DC-to-DC Trust)

```powershell
netdom trust DomainB /domain:DomainA /resetpassword /usero:DomainA\Admin /passwordo:*
```

Then verify again:

```powershell
netdom trust DomainB /domain:DomainA /verify
```

---

### 8️⃣ Check Security Filtering / Firewall Rules

* Ports required for trust:

  * **TCP/UDP 88** (Kerberos)
  * **TCP/UDP 389** (LDAP)
  * **TCP 445** (SMB)
  * **TCP 135** (RPC)
  * **Dynamic RPC ports (49152–65535)**

Ensure firewall allows **RPC + Kerberos** between DCs in both domains.

Test with:

```powershell
Test-NetConnection dc2.domainb.local -Port 88
```

---

### 9️⃣ Recreate the Domain Trust (Last Resort)

If the trust is completely broken:

**On both domains:**

1. Open `Active Directory Domains and Trusts`
2. Delete the existing trust
3. Recreate:

   * Right-click domain → **Properties → Trusts → New Trust Wizard**
   * Enter target domain (e.g., `domainb.local`)
   * Choose **Two-way / Forest-wide**
   * Enter credentials for both domains
   * Verify at the end of wizard

✅ Then verify with:

```powershell
netdom trust domainb.local /domain:domaina.local /verify
```

---

### 📋 Common Root Causes & Fixes

| Issue                                        | Root Cause                                 | Fix                                   |
| -------------------------------------------- | ------------------------------------------ | ------------------------------------- |
| “Trust relationship failed” on a workstation | Machine account password mismatch          | `Test-ComputerSecureChannel -Repair`  |
| Cross-domain login fails                     | Broken DNS or replication                  | Fix DNS forwarders, force replication |
| `netdom trust verify` fails                  | Expired or mismatched trust password       | `netdom trust /resetpassword`         |
| Kerberos authentication fails                | Time skew between DCs                      | `w32tm /resync`                       |
| Cannot find DC in other domain               | DNS misconfiguration                       | Add conditional forwarder             |
| “Access denied” verifying trust              | Wrong credentials                          | Use Domain Admin or Enterprise Admin  |
| Forest trust not working                     | UPN suffix mismatch or SID filtering       | Disable SID filtering if intentional  |
| Repeated trust breakage                      | Replication delays or stale secure channel | Audit DC health and sync regularly    |

---

### ✅ Best Practices

* Always use **conditional forwarders** for cross-domain DNS.
* Monitor **trust validation** periodically:

  ```powershell
  netdom trust /verify /alltrusts /verbose
  ```
* Synchronize clocks across forests with **PDC emulator** → reliable NTP source.
* Avoid manual DC restorations or snapshots without resetting machine passwords afterward.
* For forest trusts, ensure both sides have **matching functional levels** and **replication health**.
* Audit trust-related events (Event ID **5719**, **5783**, **5722**) in Event Viewer → System Log.

---

### 💡 In short

If you see *“Domain trust failed”*:

1. Verify with `netdom trust /verify`
2. Check **DNS**, **replication**, and **time sync**
3. Repair trust:

   * For **machine** → `Test-ComputerSecureChannel -Repair`
   * For **domain** → `netdom trust /resetpassword`
4. If all fails → **recreate the trust** via GUI or PowerShell

✅ 90% of domain trust issues come from **replication, DNS misconfiguration, or time skew**.

---
# 🧩 Windows Server / IIS Architecture Overview

A concise, production-ready overview of **core Windows Server components** that support **IIS-based web applications** in enterprise environments — covering architecture, roles, and operational best practices.

---

## ⚙️ Components and Their Purpose

| **Component**                                | **Purpose**                                                                                                        |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| **IIS Web Server**                           | Hosts and serves web applications using HTTP/HTTPS protocols. Supports ASP.NET, PHP, and static content delivery.  |
| **Application Pool**                         | Provides isolated runtime environments for applications, ensuring process-level fault isolation and security.      |
| **Active Directory Domain Services (AD DS)** | Centralized directory for identity, authentication, and policy management across the domain.                       |
| **DNS Server**                               | Resolves domain names (e.g., `app.corp.local`) to IP addresses; critical for AD, IIS, and Kerberos authentication. |
| **Group Policy (GPO)**                       | Automates enforcement of configuration, security, and compliance policies across domain-joined systems.            |
| **Domain Controller (DC)**                   | Core AD server role responsible for user authentication, replication, and policy distribution.                     |
| **Certificate Services (CA)**                | Issues and manages digital certificates for HTTPS, LDAPS, and service authentication. Enables PKI.                 |

---

## 🔐 Best Practices

| **Area**        | **Recommendation**                                                                                                                                          |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Security**    | Disable anonymous access for sensitive sites; enforce HTTPS with valid certificates; support only TLS 1.2 or higher; apply regular Windows and IIS patches. |
| **Performance** | Enable **IIS dynamic/static compression** and **output caching**; optimize **app pool recycling** and **worker process limits** for high-load sites.        |
| **Backup**      | Automate daily backups using: <br>`appcmd add backup "DailyBackup"`<br> and schedule file-level/system backups.                                             |
| **Logging**     | Centralize **IIS logs** (e.g., to ELK, Splunk, or Azure Log Analytics); enable **AD audit logging** for authentication events.                              |
| **Monitoring**  | Use **SCOM**, **ELK**, or **CloudWatch** to monitor performance counters (`Requests/sec`, `CPU`, `Memory`, `Queue Length`).                                 |
| **Permissions** | Apply **least-privilege model** — use **gMSA or service accounts** instead of domain admins for IIS and app pools.                                          |
| **Automation**  | Implement **PowerShell Desired State Configuration (DSC)** or **Ansible playbooks** to deploy, configure, and enforce drift-free environments.              |

---

## 💡 In short

**Windows Server + IIS architecture** combines **IIS (frontend)**, **AD/DNS (identity + resolution)**, and **CA (security)** to provide a **secure, scalable, and policy-controlled web platform**.
Following **least privilege**, **TLS enforcement**, and **configuration automation** ensures reliability, security, and compliance in production deployments.
