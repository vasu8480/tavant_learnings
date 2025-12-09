#Requires -RunAsAdministrator
#Requires -Version 5.1

<#
.SYNOPSIS
    Domain Controller Setup and Domain Join Script - PASTE-READY VERSION
.DESCRIPTION
    Optimized for direct PowerShell console pasting
.NOTES
    To use this script when pasting directly:
    1. Set $ServerRole = "worker" for Domain Controller
    2. Set $ServerRole = "master" for Domain Join
    3. Paste the entire script into PowerShell console
#>

# ===== CONFIGURATION SECTION - MODIFY THIS BEFORE PASTING =====
# IMPORTANT: Set this value before pasting the script!
$ServerRole = "worker"  # Change to "master" for domain join, "worker" for domain controller

# Configuration - MODIFY AS NEEDED
$Config = @{
    Domain = @{
        Name = "tavant-prmi-Nov2025.com"
        NetBIOSName = "PRMINOV2025"
        SafeModePassword = "True@123456"
        ControllerIP = "10.216.184.40"
        JoinUsername = "Administrator@tavant-prmi-Nov2025.com"
        JoinPassword = 'Tavant$TRUE#2025'
    }
    Folders = @{
        BasePath = "C:\TRUE"
        DCFolders = @("Web", "Project", "Input")
        MasterFolders = @("Web")
        ShareUser = "IIS_IUSRS"
    }
    DNS = @{
        DomainController = @{
            Primary = "8.8.8.8"
            Secondary = "8.8.4.4"
        }
        Master = @{
            Primary = "10.217.92.165"
            Secondary = "8.8.8.8"
        }
    }
}

# Error handling setup
$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

# Logging function
function Write-Log {
    param([string]$Message, [string]$Level = "Info")
    $Colors = @{ "Info" = "White"; "Success" = "Green"; "Warning" = "Yellow"; "Error" = "Red" }
    $Prefix = @{ "Info" = "[INFO]"; "Success" = "[SUCCESS]"; "Warning" = "[WARNING]"; "Error" = "[ERROR]" }
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$Timestamp] $($Prefix[$Level]) $Message" -ForegroundColor $Colors[$Level]
}

# Validate ServerRole at the beginning
Write-Log "=== DOMAIN SETUP SCRIPT STARTED ===" "Success"
Write-Log "PowerShell version: $($PSVersionTable.PSVersion)" "Info"
Write-Log "Execution Policy: $(Get-ExecutionPolicy)" "Info"

# Input validation with user prompt if needed
if ([string]::IsNullOrEmpty($ServerRole) -or ($ServerRole -notin @("worker", "master"))) {
    Write-Log "ServerRole is not properly set or invalid: '$ServerRole'" "Warning"
    Write-Host ""
    Write-Host "Please specify the server role:" -ForegroundColor Yellow
    Write-Host "1. 'worker' - Install Domain Controller" -ForegroundColor Cyan
    Write-Host "2. 'master' - Join to existing domain" -ForegroundColor Cyan
    Write-Host ""
    
    do {
        $UserChoice = Read-Host "Enter 'worker' or 'master'"
        if ($UserChoice -in @("worker", "master")) {
            $ServerRole = $UserChoice
            break
        }
        Write-Host "Invalid choice. Please enter 'worker' or 'master'" -ForegroundColor Red
    } while ($true)
}

Write-Log "ServerRole confirmed: $ServerRole" "Success"

if ($ServerRole -eq "worker") {
    Write-Log "Mode: Domain Controller Installation" "Info"
} else {
    Write-Log "Mode: Domain Join" "Info"
}

# Folder and share management function
function Initialize-FolderStructure {
    param(
        [Parameter(Mandatory)]
        [string]$BasePath,
        [Parameter(Mandatory)]
        [string[]]$FolderNames,
        [string]$GrantUser,
        [switch]$CreateShares
    )
    
    Write-Log "Initializing folder structure at $BasePath" "Info"
    
    # Create base path
    if (-not (Test-Path $BasePath)) {
        New-Item -Path $BasePath -ItemType Directory -Force | Out-Null
        Write-Log "Created base directory: $BasePath" "Success"
    }
    
    # Create subfolders
    foreach ($FolderName in $FolderNames) {
        $FolderPath = Join-Path $BasePath $FolderName
        if (-not (Test-Path $FolderPath)) {
            New-Item -Path $FolderPath -ItemType Directory -Force | Out-Null
            Write-Log "Created folder: $FolderPath" "Success"
        } else {
            Write-Log "Folder already exists: $FolderPath" "Info"
        }
    }
    
    # Set permissions
    try {
        $ACL = Get-Acl $BasePath
        $EveryoneRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $ACL.SetAccessRule($EveryoneRule)
        
        if ($GrantUser) {
            $UserRule = New-Object System.Security.AccessControl.FileSystemAccessRule($GrantUser, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
            $ACL.SetAccessRule($UserRule)
        }
        
        Set-Acl -Path $BasePath -AclObject $ACL
        Write-Log "Permissions configured successfully" "Success"
    }
    catch {
        Write-Log "Permission configuration failed: $($_.Exception.Message)" "Warning"
    }
    
    # Create network shares if requested
    if ($CreateShares) {
        Write-Log "Installing File Server role..." "Info"
        $Feature = Get-WindowsFeature -Name FS-FileServer
        if ($Feature.InstallState -ne "Installed") {
            Install-WindowsFeature -Name FS-FileServer -IncludeManagementTools | Out-Null
            Write-Log "File Server role installed" "Success"
        }
        
        # Create shares
        $ShareName = "TRUE"
        if (-not (Get-SmbShare -Name $ShareName -ErrorAction SilentlyContinue)) {
            New-SmbShare -Name $ShareName -Path $BasePath -FullAccess "Everyone" -Description "TRUE folder share" | Out-Null
            Write-Log "Share created: \\$env:COMPUTERNAME\$ShareName" "Success"
        }
        
        foreach ($FolderName in $FolderNames) {
            if (-not (Get-SmbShare -Name $FolderName -ErrorAction SilentlyContinue)) {
                $FolderPath = Join-Path $BasePath $FolderName
                New-SmbShare -Name $FolderName -Path $FolderPath -FullAccess "Everyone" -Description "$FolderName folder share" | Out-Null
                Write-Log "Share created: \\$env:COMPUTERNAME\$FolderName" "Success"
            }
        }
    }
}

# Domain Controller installation function
function Install-DomainController {
    Write-Log "=== STARTING DOMAIN CONTROLLER INSTALLATION ===" "Success"
    Write-Log "Domain: $($Config.Domain.Name)" "Info"
    Write-Log "NetBIOS Name: $($Config.Domain.NetBIOSName)" "Info"
    
    try {
        # Step 1: Setup folders and shares
        Write-Log "Setting up folder structure..." "Info"
        Initialize-FolderStructure -BasePath $Config.Folders.BasePath -FolderNames $Config.Folders.DCFolders -GrantUser $Config.Folders.ShareUser -CreateShares
        
        # Step 2: Configure DNS
        Write-Log "Configuring DNS settings..." "Info"
        $NetworkAdapters = Get-NetAdapter | Where-Object Status -eq 'Up'
        foreach ($Adapter in $NetworkAdapters) {
            Set-DnsClientServerAddress -InterfaceAlias $Adapter.Name -ServerAddresses @($Config.DNS.DomainController.Primary, $Config.DNS.DomainController.Secondary)
            Write-Log "DNS configured for adapter: $($Adapter.Name)" "Success"
        }
        
        # Step 3: Install AD DS role
        Write-Log "Installing Active Directory Domain Services..." "Info"
        Write-Log "This operation may take several minutes. Please wait..." "Warning"
        
        $InstallResult = Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
        
        if ($InstallResult.Success) {
            Write-Log "AD DS role installed successfully" "Success"
            Write-Log "Exit Code: $($InstallResult.ExitCode)" "Info"
        } else {
            throw "AD DS installation failed with exit code: $($InstallResult.ExitCode)"
        }
        
        # Step 4: Promote to Domain Controller
        Write-Log "Promoting server to Domain Controller..." "Success"
        Write-Log "Creating new forest: $($Config.Domain.Name)" "Info"
        Write-Log "WARNING: Do NOT close this window during forest installation!" "Warning"
        
        $SecurePassword = ConvertTo-SecureString $Config.Domain.SafeModePassword -AsPlainText -Force
        
        $ForestParams = @{
            DomainName = $Config.Domain.Name
            DomainNetbiosName = $Config.Domain.NetBIOSName
            SafeModeAdministratorPassword = $SecurePassword
            InstallDns = $true
            CreateDnsDelegation = $false
            DatabasePath = "C:\Windows\NTDS"
            LogPath = "C:\Windows\NTDS"
            SysvolPath = "C:\Windows\SYSVOL"
            NoRebootOnCompletion = $true
            Force = $true
            Confirm = $false
        }
        
        Write-Log "Starting forest installation..." "Info"
        Install-ADDSForest @ForestParams
        
        Write-Log "=== DOMAIN CONTROLLER INSTALLATION COMPLETED SUCCESSFULLY! ===" "Success"
        Write-Log "Domain Controller is ready" "Success"
        Write-Log "Forest: $($Config.Domain.Name)" "Success"
        Write-Log "NetBIOS: $($Config.Domain.NetBIOSName)" "Success"
        
        # Restart notification
        Write-Log "IMPORTANT: Server restart is required to complete the installation" "Warning"
        Write-Log "After restart, the server will be fully functional as a Domain Controller" "Info"
        
        $RestartChoice = Read-Host "Do you want to restart now? (Y/N)"
        if ($RestartChoice -match '^[Yy]$') {
            Write-Log "Restarting server..." "Info"
            Restart-Computer -Force
        } else {
            Write-Log "Please restart manually when ready" "Warning"
        }
        
    }
    catch {
        Write-Log "CRITICAL ERROR during Domain Controller installation: $($_.Exception.Message)" "Error"
        Write-Log "Troubleshooting tips:" "Warning"
        Write-Log "• Ensure the server has a static IP address" "Warning"
        Write-Log "• Verify the server is not already domain-joined" "Warning"
        Write-Log "• Check DNS settings are correct" "Warning"
        Write-Log "• Ensure sufficient disk space is available" "Warning"
        Write-Log "• Run PowerShell as Administrator" "Warning"
        throw
    }
}

# Domain join function
function Join-ToDomain {
    Write-Log "=== STARTING DOMAIN JOIN PROCESS ===" "Success"
    Write-Log "Target Domain: $($Config.Domain.Name)" "Info"
    Write-Log "Domain Controller: $($Config.Domain.ControllerIP)" "Info"
    
    try {
        # Setup folders (no shares for domain join)
        Write-Log "Setting up folder structure..." "Info"
        Initialize-FolderStructure -BasePath $Config.Folders.BasePath -FolderNames $Config.Folders.MasterFolders
        
        # Configure DNS to point to Domain Controller
        Write-Log "Configuring DNS to point to Domain Controller..." "Info"
        $NetworkAdapters = Get-NetAdapter | Where-Object Status -eq 'Up'
        foreach ($Adapter in $NetworkAdapters) {
            Set-DnsClientServerAddress -InterfaceAlias $Adapter.Name -ServerAddresses @($Config.Domain.ControllerIP, $Config.DNS.Master.Secondary)
            Write-Log "DNS configured for adapter: $($Adapter.Name) -> DC: $($Config.Domain.ControllerIP)" "Success"
        }
        
        # Check current domain membership
        $ComputerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
        if ($ComputerSystem.PartOfDomain) {
            if ($ComputerSystem.Domain -eq $Config.Domain.Name) {
                Write-Log "Computer is already joined to the target domain: $($Config.Domain.Name)" "Success"
                return
            } else {
                Write-Log "Computer is currently joined to: $($ComputerSystem.Domain)" "Warning"
                Write-Log "Target domain is: $($Config.Domain.Name)" "Info"
                $Confirm = Read-Host "Do you want to leave the current domain and join the target domain? (Y/N)"
                if ($Confirm -notmatch '^[Yy]$') {
                    Write-Log "Domain join cancelled by user" "Warning"
                    return
                }
            }
        } else {
            Write-Log "Computer is currently in workgroup: $($ComputerSystem.Workgroup)" "Info"
        }
        
        # Connectivity tests
        Write-Log "Testing connectivity to Domain Controller..." "Info"
        
        $PingTest = Test-Connection -ComputerName $Config.Domain.ControllerIP -Count 2 -Quiet
        if ($PingTest) {
            Write-Log "Ping test: SUCCESS" "Success"
        } else {
            Write-Log "Ping test: FAILED" "Error"
            Write-Log "Cannot reach Domain Controller at $($Config.Domain.ControllerIP)" "Error"
            throw "Network connectivity test failed"
        }
        
        $LDAPTest = Test-NetConnection -ComputerName $Config.Domain.ControllerIP -Port 389 -WarningAction SilentlyContinue
        if ($LDAPTest.TcpTestSucceeded) {
            Write-Log "LDAP connectivity (port 389): SUCCESS" "Success"
        } else {
            Write-Log "LDAP connectivity (port 389): FAILED" "Warning"
        }
        
        # Join domain
        Write-Log "Attempting to join domain..." "Info"
        Write-Log "Using credentials: $($Config.Domain.JoinUsername)" "Info"
        
        $Credential = New-Object PSCredential($Config.Domain.JoinUsername, (ConvertTo-SecureString $Config.Domain.JoinPassword -AsPlainText -Force))
        
        try {
            Add-Computer -DomainName $Config.Domain.Name -Credential $Credential -Force -Verbose -ErrorAction Stop
            Write-Log "Domain join command executed successfully!" "Success"
            $JoinSuccess = $true
        }
        catch {
            Write-Log "Domain join failed: $($_.Exception.Message)" "Error"
            $JoinSuccess = $false
            
            # Specific error handling
            $ErrorMessage = $_.Exception.Message
            if ($ErrorMessage -like "*user name or password is incorrect*") {
                Write-Log "CREDENTIAL ERROR: Username or password is incorrect" "Error"
                Write-Log "Verify these settings on the Domain Controller:" "Warning"
                Write-Log "• Administrator account is enabled and accessible" "Warning"
                Write-Log "• Password is correct and not expired" "Warning"
                Write-Log "• Account is not locked out" "Warning"
            }
            elseif ($ErrorMessage -like "*network path was not found*") {
                Write-Log "NETWORK ERROR: Cannot find the domain" "Error"
                Write-Log "Check these settings:" "Warning"
                Write-Log "• DNS points to the correct Domain Controller" "Warning"
                Write-Log "• Domain Controller is running and accessible" "Warning"
                Write-Log "• Firewall is not blocking the connection" "Warning"
            }
            
            throw "Domain join operation failed"
        }
        
        # Verify domain join
        Start-Sleep 5  # Allow time for system to update
        $UpdatedComputerInfo = Get-CimInstance -ClassName Win32_ComputerSystem
        
        if ($UpdatedComputerInfo.PartOfDomain -and $UpdatedComputerInfo.Domain -eq $Config.Domain.Name) {
            Write-Log "=== DOMAIN JOIN SUCCESSFUL ===" "Success"
            Write-Log "Computer Name: $($UpdatedComputerInfo.Name)" "Success"
            Write-Log "Domain: $($UpdatedComputerInfo.Domain)" "Success"
            Write-Log "Domain join completed successfully!" "Success"
            
            Write-Log "RECOMMENDATION: Restart the computer to ensure all domain features work properly" "Warning"
            $RestartChoice = Read-Host "Do you want to restart now? (Y/N)"
            if ($RestartChoice -match '^[Yy]$') {
                Write-Log "Restarting computer..." "Info"
                Restart-Computer -Force
            } else {
                Write-Log "Please restart manually when convenient" "Warning"
            }
        } else {
            Write-Log "=== DOMAIN JOIN VERIFICATION FAILED ===" "Error"
            Write-Log "Expected domain: $($Config.Domain.Name)" "Error"
            Write-Log "Current domain: $($UpdatedComputerInfo.Domain)" "Error"
            Write-Log "Part of domain: $($UpdatedComputerInfo.PartOfDomain)" "Error"
            throw "Domain join verification failed"
        }
        
    }
    catch {
        Write-Log "Domain join process failed: $($_.Exception.Message)" "Error"
        Write-Log "Troubleshooting checklist:" "Warning"
        Write-Log "• Verify Domain Controller is running and accessible" "Warning"
        Write-Log "• Check DNS configuration points to Domain Controller" "Warning"
        Write-Log "• Confirm credentials are valid" "Warning"
        Write-Log "• Ensure computer is not already domain-joined" "Warning"
        Write-Log "• Check network connectivity and firewall settings" "Warning"
        throw
    }
}


# --- Pre-Domain Setup Logic ---
function Pre-DomainSetup {
    Write-Log "=== PRE-DOMAIN SETUP: Ensuring TRUE\\web folder, subfolders, app pools, and IIS sites exist ===" "Info"
    $webFolder = Join-Path $Config.Folders.BasePath "web"
    if (-not (Test-Path $webFolder)) {
        New-Item -Path $webFolder -ItemType Directory -Force | Out-Null
        Write-Log "Created folder: $webFolder" "Success"
    } else {
        Write-Log "Folder already exists: $webFolder" "Info"
    }

    Import-Module WebAdministration

    $siteConfigs = @()
    if ($ServerRole -eq "master") {
        $siteConfigs = @(
            @{ Name = "MasterAPI"; Port = 8300 },
            @{ Name = "ManagerService"; Port = 8400 }
        )
    } elseif ($ServerRole -eq "worker") {
        $siteConfigs = @(
            @{ Name = "WORKERAPI"; Port = 8301 }
        )
    }

    foreach ($site in $siteConfigs) {
        $sub = $site.Name
        $subPath = Join-Path $webFolder $sub
        if (-not (Test-Path $subPath)) {
            New-Item -Path $subPath -ItemType Directory -Force | Out-Null
            Write-Log "Created folder: $subPath" "Success"
        } else {
            Write-Log "Folder already exists: $subPath" "Info"
        }
        # Create App Pool for each
        $appPoolCreated = $false
        if (-not (Test-Path "IIS:\AppPools\$sub")) {
            Write-Log "Creating Application Pool: $sub (pre-domain setup)" "Info"
            New-WebAppPool -Name $sub | Out-Null
            $appPoolCreated = $true
        } else {
            Write-Log "Application Pool $sub already exists (pre-domain setup)." "Info"
        }
        # Set App Pool Identity to custom domain user
        $appPoolPath = "IIS:\AppPools\$sub"
        $username = $Config.Domain.JoinUsername
        $password = $Config.Domain.JoinPassword
        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
        $appPool = Get-Item $appPoolPath
        $appPool.processModel.identityType = 3  # 3 = SpecificUser
        $appPool.processModel.userName = $username
        $appPool.processModel.password = $securePassword
        $appPool | Set-Item
        Write-Log "Set identity for App Pool $sub to custom domain user: $username" "Info"

        # Create IIS Site for each
        if (Test-Path "IIS:\Sites\$sub") {
            Write-Log "Site $sub already exists. Removing for clean setup..." "Warning"
            Remove-Website -Name $sub
        }
        Write-Log "Creating IIS Website: $sub at $subPath on port $($site.Port)" "Success"
        New-Website -Name $sub -Port $site.Port -PhysicalPath $subPath -ApplicationPool $sub -Force | Out-Null
    }
}

# Main execution logic
Write-Log "=== MAIN EXECUTION STARTING ===" "Info"
Write-Log "Selected mode: $ServerRole" "Info"

try {
    # Execute pre-domain setup logic
    Pre-DomainSetup

    if ($ServerRole -eq "worker") {
        Write-Log "Executing Domain Controller installation..." "Info"
        Install-DomainController
    } elseif ($ServerRole -eq "master") {
        Write-Log "Executing Domain Join..." "Info"
        Join-ToDomain
    } else {
        throw "Invalid ServerRole: $ServerRole. Must be 'worker' or 'master'"
    }
    Write-Log "=== SCRIPT EXECUTION COMPLETED SUCCESSFULLY ===" "Success"
}
catch {
    Write-Log "=== SCRIPT EXECUTION FAILED ===" "Error"
    Write-Log "Error details: $($_.Exception.Message)" "Error"
    Write-Log "" "Info"
    Write-Log "Common solutions:" "Warning"
    Write-Log "• Ensure PowerShell is running as Administrator" "Warning"
    Write-Log "• Check network connectivity" "Warning"
    Write-Log "• Verify server configuration and credentials" "Warning"
    Write-Log "• Review the error message above for specific guidance" "Warning"
}


# === IIS Application Pool and Site Setup ===
Import-Module WebAdministration

function Remove-DefaultSite {
    if (Test-Path IIS:\Sites\'Default Web Site') {
        Write-Log "Removing Default Web Site from IIS..." "Info"
        Remove-Website -Name 'Default Web Site'
    } else {
        Write-Log "Default Web Site not found, skipping removal." "Info"
    }
}

function Ensure-AppPool {
    param([string]$AppPoolName)
    if (-not (Test-Path IIS:\AppPools\$AppPoolName)) {
        Write-Log "Creating Application Pool: $AppPoolName" "Info"
        New-WebAppPool -Name $AppPoolName | Out-Null
    } else {
        Write-Log "Application Pool $AppPoolName already exists." "Info"
    }
}

function Ensure-Website {
    param(
        [string]$SiteName,
        [string]$PhysicalPath,
        [int]$Port,
        [string]$AppPoolName
    )
    Ensure-AppPool -AppPoolName $AppPoolName
    if (Test-Path IIS:\Sites\$SiteName) {
        Write-Log "Site $SiteName already exists. Removing for clean setup..." "Warning"
        Remove-Website -Name $SiteName
    }
    Write-Log "Creating IIS Website: $SiteName at $PhysicalPath on port $Port" "Success"
    New-Website -Name $SiteName -Port $Port -PhysicalPath $PhysicalPath -ApplicationPool $AppPoolName -Force | Out-Null
}

Write-Log "Script completed. Press Enter to close..." "Info"
