Worker-DC
password: True@123456

Master-DC
password: 0;i62gMfcn-6FJP.mq?aOrzPMk2IIDET



=OX1&P7;!EJ$lnLsx)%P9ApfMVlTa43k

DomainName: True.com
Password: True@123456



Host:SFTP.true.ai
U:Tavant_User
P:YL3a+Kaf


Use this sql servr - finxdlf-dev-mssql.cmcevzbgcfhr.us-east-1.rds.amazonaws.com
user - admin
password - F!nxdlfdevdbAdm!n1433


Get-ChildItem -Path C:\ -Recurse -Filter nginx.exe -ErrorAction SilentlyContinue


Stop-Process -Name nginx -Force -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "C:\Install_inginx\nginx-1.26.3"



powershell -ExecutionPolicy Bypass -File "_Universal_Prereqs_Windows.ps1"


Restart-Computer -Force


True-Manager01

\\Worker-dc\true\Project\Config\DBCreds_10.216.184.62.xml


\\Worker-dc\true\Project\Logs\TrapezeManagerServices.log



=OX1&P7;!EJ$lnLsx)%P9ApfMVlTa43k


\\Ec2amaz-ga9pf4c\true\Project\\config\DBCreds_10.216.184.62.xml

\\Worker-dc\true\Project\config\Dbcreds_Master.xml

\\Ec2amaz-ga9pf4c\true\Project\config\Dbcreds_Manager.xml



\\\\Worker-dc\\true\\Project\\config\\Dbcreds_Master.xml

New-NetFirewallRule -DisplayName "Allow HTTP Port 80" -Direction Inbound -LocalPort 80 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "testing 8000" -Direction Inbound -LocalPort 8000 -Protocol TCP -Action Allow

New-NetFirewallRule -DisplayName "Allow Trapeze manger HTTP 8400" -Direction Inbound -LocalPort 8400 -Protocol TCP -Action Allow


New-NetFirewallRule -DisplayName "Allow HTTP (80)"           -Direction Inbound -LocalPort 80    -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow HTTPS (443)"         -Direction Inbound -LocalPort 443   -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Manager (8400)"      -Direction Inbound -LocalPort 8400  -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Master API (8300)"   -Direction Inbound -LocalPort 8300  -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Worker API (8301)"   -Direction Inbound -LocalPort 8301  -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow ImageTrust (8199)"   -Direction Inbound -LocalPort 8199  -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow Master API (8001)"   -Direction Inbound -LocalPort 8001  -Protocol TCP -Action Allow


netstat -ano | findstr :8001


Test-NetConnection -ComputerName localhost -Port 8001



Get-NetFirewallRule | Where-Object {$_.DisplayName -like "*8001*"}


Test-NetConnection -ComputerName localhost -Port 8001


dism /online /Enable-Feature /FeatureName:TelnetClient
