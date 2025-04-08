# Windows Server Setup Guide

This guide will help you set up a Windows Server machine with the necessary components for web hosting and application deployment.

## Prerequisites
Ensure you are running as an Administrator in PowerShell or Command Prompt throughout this setup.

---

## 1. Install Chocolatey

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = "Tls12"
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

---

## 2. Install IIS (Internet Information Services)

```powershell
Install-WindowsFeature -name Web-Server -IncludeManagementTools
```

**Verify IIS Installation:**
- Open a browser and go to `http://localhost`. You should see the IIS default page.

**Check IIS Version:**
```powershell
Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\InetStp' | Select-Object VersionString
```
Ensure it's IIS 10 or higher.

---

## 3. Install NGINX (1.25.1 or higher)
- Download from: [https://nginx.org/en/download.html](https://nginx.org/en/download.html)
- Extract to `C:\nginx`

**Start NGINX:**
```powershell
C:\nginx\nginx.exe
```

**Check the nginx version or whether installed or not**
```powershell
Get-ChildItem -Path C:\ -Recurse -Filter nginx.exe -ErrorAction SilentlyContinue
```

**Verify:**
- Open a browser and go to `http://localhost`. NGINX welcome page should appear.

---

## 4. Install .NET Framework 4.7.2 or Higher
- Download from: [https://dotnet.microsoft.com/en-us/download/dotnet-framework](https://dotnet.microsoft.com/en-us/download/dotnet-framework)
- Run the installer and restart your server.

---

## 5. Install .NET Hosting Bundle 8.0
- Download from: [https://dotnet.microsoft.com/en-us/download/dotnet/8.0](https://dotnet.microsoft.com/en-us/download/dotnet/8.0)
- Look for **ASP.NET Core Runtime 8.0.x** → Download **Hosting Bundle**
- Run the installer and restart the server.

---

## 6. Install SQL Server 2019 or Higher
- Download from: [https://www.microsoft.com/en-us/sql-server/sql-server-downloads](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
- Install Standard or Enterprise Edition
- Enable **Mixed Mode Authentication**

**Install SSMS (SQL Server Management Studio):**
- [https://aka.ms/ssmsfullsetup](https://aka.ms/ssmsfullsetup)

**Note:** If using RDS (AWS) or Azure SQL, configure connection strings accordingly.

---

## 7. Install Microsoft Edge or Google Chrome
- [Edge Download](https://www.microsoft.com/en-us/edge/download)
- [Chrome Download](https://www.google.com/chrome/)
- Install and optionally set as default browser.

---

## 8. Verify Setup

### IIS
- Open `http://localhost` → IIS page should appear.

### NGINX
- Open `http://localhost:80` → NGINX welcome page should appear.

### .NET Runtime
```powershell
dotnet --list-runtimes
```
Ensure `.NET Core Runtime 8.0.x` is listed.

### SQL Server
- Open SSMS and connect to the SQL Server instance.

---

## Final Step: Restart Machine
```powershell
shutdown /r /t 0
```

Once restarted, test your application deployment.

---

## ✅ Setup Complete
Your Windows Server is now ready for hosting applications and running services.

