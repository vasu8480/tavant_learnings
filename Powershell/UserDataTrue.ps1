<powershell>
# Robust EC2 User Data Script with Fallback Mechanisms
$ErrorActionPreference="Continue";$ProgressPreference="SilentlyContinue"

# Configuration Variables
$CID='07993F0C4C924ABD81DBAEC79BE1C562-BC'
$GROUPING_TAGS="TLP,PREPROD,TRUIAI-NODE"

# Enhanced logging with multiple fallback locations
$LogLocations=@("C:\WindowsUserData","C:\Temp","C:\Users\Public","C:\")
$LogDir=$null
foreach($loc in $LogLocations){
    try{
        if(!(Test-Path $loc)){New-Item -ItemType Directory -Path $loc -Force|Out-Null}
        $testFile="$loc\test.tmp";"">>$testFile;Remove-Item $testFile -Force -EA 0
        $LogDir=$loc;break
    }catch{continue}
}
if(!$LogDir){$LogDir="C:\"}

function Log($m){
    $ts=Get-Date -f 'HH:mm:ss yyyy-MM-dd'
    $msg="$ts $m"
    Write-Host $msg -ForegroundColor Green
    try{Add-Content "$LogDir\userdata.log" $msg -EA 0}catch{}
    try{Add-Content "C:\ProgramData\userdata.log" $msg -EA 0}catch{}
}

# Environment check and initialization
Log "=== TRUE User Data Script Starting ==="
Log "PowerShell Version: $($PSVersionTable.PSVersion)"
Log "OS Version: $((Get-CimInstance Win32_OperatingSystem).Caption)"
Log "Log Directory: $LogDir"

# Wait for system readiness with retry mechanism
function Wait-ForSystemReady {
    $maxRetries=10;$retryCount=0
    while($retryCount -lt $maxRetries){
        try{
            $services=Get-Service -Name @("Winmgmt","EventLog") -EA Stop
            if(($services|Where-Object Status -eq "Running").Count -eq 2){
                Log "System services ready";return $true
            }
        }catch{}
        $retryCount++;Start-Sleep 15;Log "Waiting for system readiness... ($retryCount/$maxRetries)"
    }
    Log "System readiness check timed out - continuing anyway";return $false
}
Wait-ForSystemReady

# Set Windows Administrator Password with retry mechanism
Log "Setting Administrator password"
$passwordSet=$false;$retryCount=0;$maxRetries=3
while(!$passwordSet -and $retryCount -lt $maxRetries){
    try{
        Start-Sleep 5  # Allow system to settle
        $p='Tavant$TRUE#2025'
        Set-LocalUser Administrator -Password(ConvertTo-SecureString $p -AsPlainText -Force) -PasswordNeverExpires $true -EA Stop
        Log "Password set successfully and configured to never expire"
        $passwordSet=$true
    }catch{
        $retryCount++
        Log "Password setting attempt $retryCount failed: $_"
        if($retryCount -eq $maxRetries){Log "CRITICAL: Password setting failed after $maxRetries attempts"}
        else{Start-Sleep 10}
    }
}

# Enhanced DNS Configuration with fallback
Log "Configuring DNS with retry mechanism"
try{
    $dns=@("8.8.8.8","8.8.4.4")
    $adapters=Get-NetAdapter -EA 0|Where-Object Status -eq 'Up'
    if($adapters){
        foreach($adapter in $adapters){
            try{
                Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ServerAddresses $dns -EA Stop
                Log "DNS configured for adapter: $($adapter.Name)"
            }catch{Log "DNS failed for $($adapter.Name): $_"}
        }
        try{ipconfig /flushdns>$null;Log "DNS cache flushed"}catch{}
    }else{Log "Warning: No active network adapters found"}
}catch{Log "DNS configuration failed: $_"}

# Robust download function with multiple retry mechanisms
function Get-FileWithRetry {
    param([string]$Url,[string]$OutFile,[int]$MaxRetries=3,[int]$TimeoutSec=300)
    
    for($i=1;$i -le $MaxRetries;$i++){
        try{
            Log "Download attempt $i/$MaxRetries`: $(Split-Path $OutFile -Leaf)"
            
            # Try different download methods
            $methods=@(
                {Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing -TimeoutSec $TimeoutSec -EA Stop},
                {(New-Object System.Net.WebClient).DownloadFile($Url,$OutFile)},
                {Start-BitsTransfer -Source $Url -Destination $OutFile -EA Stop}
            )
            
            foreach($method in $methods){
                try{
                    & $method
                    if(Test-Path $OutFile){Log "Download successful: $(Split-Path $OutFile -Leaf)";return $true}
                }catch{Log "Download method failed: $_"}
            }
        }catch{Log "Download attempt $i failed: $_"}
        
        if($i -lt $MaxRetries){Start-Sleep (30*$i)}
    }
    Log "CRITICAL: Download failed after $MaxRetries attempts: $Url"
    return $false
}

# Enhanced installation function
function Install-WithRetry {
    param([string]$Name,[string]$Url,[string]$Args="",[string]$Type="msi",[string]$ServiceCheck="")
    
    Log "Installing $Name"
    
    # Check if already installed
    if($ServiceCheck -and (Get-Service $ServiceCheck -EA 0)){
        Log "$Name already installed (service check: $ServiceCheck)";return $true
    }
    
    $fileName="$Name.$Type"
    $filePath="$env:TEMP\$fileName"
    
    # Ensure temp directory exists
    if(!(Test-Path $env:TEMP)){New-Item -ItemType Directory $env:TEMP -Force|Out-Null}
    
    if(Get-FileWithRetry -Url $Url -OutFile $filePath){
        try{
            if($Type -eq "msi"){
                $process=Start-Process msiexec -ArgumentList "/i `"$filePath`" $Args /quiet /norestart /l*v `"$env:TEMP\$Name-install.log`"" -Wait -PassThru -NoNewWindow
            }else{
                $process=Start-Process $filePath -ArgumentList $Args -Wait -PassThru -NoNewWindow
            }
            
            if($process.ExitCode -eq 0 -or $process.ExitCode -eq 3010){
                Log "$Name installed successfully (Exit: $($process.ExitCode))"
                Remove-Item $filePath -Force -EA 0
                return $true
            }else{
                Log "$Name installation failed (Exit: $($process.ExitCode))"
                if(Test-Path "$env:TEMP\$Name-install.log"){
                    $logContent=Get-Content "$env:TEMP\$Name-install.log" -Tail 10 -EA 0
                    Log "Last 10 lines of install log: $($logContent -join '; ')"
                }
            }
        }catch{Log "$Name installation error: $_"}
        Remove-Item $filePath -Force -EA 0
    }
    return $false
}
# Configure TLS and create temp directory
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
if(!(Test-Path "C:\Temp")){New-Item -ItemType Directory "C:\Temp" -Force|Out-Null}

# Install software
Log "Installing WMI Exporter"
Invoke-WebRequest -Uri https://github.com/prometheus-community/windows_exporter/releases/download/v0.12.0/wmi_exporter-0.12.0-amd64.msi -OutFile C:\Users\Administrator\Downloads\wmi_exporter-0.12.0-amd64.msi
msiexec /i C:\Users\Administrator\Downloads\wmi_exporter-0.12.0-amd64.msi ENABLED_COLLECTORS=os,iis,cpu,cs,logical_disk,net,service,system LISTEN_PORT=9182

Log "Installing CrowdStrike"
Invoke-WebRequest -Uri https://user-data-ecs-velox.s3-us-west-1.amazonaws.com/crowdstrike_install/WindowsSensor.MaverickGyr.exe -Outfile C:\Users\Administrator\Downloads\WindowsSensor.MaverickGyr.exe
if(!(Test-Path C:\Temp)){New-Item -ItemType Directory C:\Temp -Force}
Copy-Item C:\Users\Administrator\Downloads\WindowsSensor.MaverickGyr.exe C:\Temp\WindowsSensor.exe -Force
if(!(Get-Service CSFalconService -EA 0)){& C:\Temp\WindowsSensor.exe /install /quiet /norestart CID=$CID provisioning-token=C9461665 GROUPING_TAGS=$GROUPING_TAGS}

Log "Installing Filebeat"
Invoke-WebRequest -Uri https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-7.12.1-windows-x86_64.zip -Outfile C:\Users\Administrator\Downloads\filebeat.zip
Expand-Archive C:\Users\Administrator\Downloads\filebeat.zip -DestinationPath C:\Users\Administrator\Downloads\
Rename-Item "C:\Users\Administrator\Downloads\filebeat-oss-7.12.1-windows-x86_64\filebeat-oss-7.12.1-windows-x86_64" "C:\Users\Administrator\Downloads\filebeat-oss-7.12.1-windows-x86_64\Filebeat"
Move-Item "C:\Users\Administrator\Downloads\filebeat-oss-7.12.1-windows-x86_64\Filebeat" "C:\Program Files\"
Copy-Item "C:\Program Files\Filebeat\filebeat.yml" "C:\Program Files\Filebeat\filebeat.yml_backup"
Remove-Item "C:\Program Files\Filebeat\filebeat.yml"
Invoke-WebRequest -Uri https://user-data-ecs-velox.s3-us-west-1.amazonaws.com/filebeat/mac-prod-ecs-filebeat-conf/filebeat.yml -Outfile "C:\Program Files\Filebeat\filebeat.yml"
$ip=$(ipconfig|where{$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'} |out-null;$Matches[1])
(Get-Content "C:\Program Files\Filebeat\filebeat.yml").Replace("worker_ip",$ip)|Set-Content "C:\Program Files\Filebeat\filebeat.yml"
Set-Location "C:\Program Files\Filebeat";.\install-service-filebeat.ps1;Start-Service filebeat

Set-ExecutionPolicy Bypass -Scope Process -Force
Start-Transcript "$LogDir\install.log" -Append
Log "Starting main installations"

# Install Chocolatey
if(!(Get-Command choco -EA 0)){
    [Net.ServicePointManager]::SecurityProtocol=[Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression((New-Object Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    $env:PATH=[Environment]::GetEnvironmentVariable("PATH","Machine")+";"+[Environment]::GetEnvironmentVariable("PATH","User")
    Log "Chocolatey installed"
}

# Install packages
@("nginx","winscp") | %{if(!(Get-Package $_ -EA 0)){& choco install $_ -y;Log "$_ installed"}}

# Install IIS
$isServer=(Get-CimInstance Win32_OperatingSystem).ProductType -ge 2
if($isServer){
    Install-WindowsFeature Web-Server,Web-WebServer,Web-Common-Http,Web-AppInit -IncludeManagementTools
    Log "IIS server installed"
}else{
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole,IIS-WebServer,IIS-CommonHttpFeatures -All -NoRestart
    Log "IIS client installed"
}

# Install .NET 8.0
if(!(Test-Path C:\Temp)){New-Item -ItemType Directory C:\Temp -Force}
$dotnet="C:\Temp\dotnet.exe"
Invoke-WebRequest -Uri "https://download.visualstudio.microsoft.com/download/pr/fdec46ca-0355-4fa5-a0fb-a7b798d24957/c44beca075d298a722ff18adbfad3b81/dotnet-hosting-8.0.14-win.exe" -OutFile $dotnet
Start-Process $dotnet -ArgumentList "/quiet" -Wait -NoNewWindow
if($LASTEXITCODE -eq 0){Log ".NET 8.0 installed"}
Remove-Item $dotnet -Force -EA 0

# Install AWS SSM
if(!(Get-Service AmazonSSMAgent -EA 0|?{$_.Status -eq "Running"})){
    $arch=if($env:PROCESSOR_ARCHITECTURE -eq "AMD64"){"amd64"}else{"386"}
    $ssm="C:\Temp\ssm.msi"
    Invoke-WebRequest -Uri "https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_$arch/AmazonSSMAgent.msi" -OutFile $ssm
    Start-Process msiexec -ArgumentList "/i",$ssm,"/quiet" -Wait -NoNewWindow
    if($LASTEXITCODE -eq 0){Start-Service AmazonSSMAgent -EA 0;Log "SSM installed"}
    Remove-Item $ssm -Force -EA 0
}

# Install AWS CLI
try{$v=& aws --version 2>&1;if($v -match "aws-cli"){Log "AWS CLI exists"}}catch{
    $cli="C:\Temp\aws.msi"
    Invoke-WebRequest -Uri "https://awscli.amazonaws.com/AWSCLIV2.msi" -OutFile $cli
    Start-Process msiexec -ArgumentList "/i",$cli,"/quiet" -Wait -NoNewWindow
    if($LASTEXITCODE -eq 0){Log "AWS CLI installed"}
    Remove-Item $cli -Force -EA 0
}

# Create PowerShell Admin shortcut with error handling
Log "Creating PowerShell Admin shortcut"
try{
    $desktop=[Environment]::GetFolderPath('Desktop')
    $shortcut=(New-Object -ComObject WScript.Shell).CreateShortcut("$desktop\PowerShell (Admin).lnk")
    $shortcut.TargetPath="powershell.exe"
    $shortcut.Description="Windows PowerShell (Administrator)"
    $shortcut.WorkingDirectory="%USERPROFILE%"
    $shortcut.IconLocation="powershell.exe,0"
    $shortcut.Save()
    $bytes=[System.IO.File]::ReadAllBytes($shortcut.FullName)
    $bytes[0x15]=$bytes[0x15] -bor 0x20
    [System.IO.File]::WriteAllBytes($shortcut.FullName,$bytes)
    Log "PowerShell Admin shortcut created successfully"
}catch{Log "PowerShell shortcut creation failed: $_"}

Log "Installation completed successfully"
Stop-Transcript
Log "=== User Data Script Completed ==="
</powershell>
