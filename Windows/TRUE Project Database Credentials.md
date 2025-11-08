# TRUE Project Configuration

This repository contains configuration files and credentials for the TRUE Project’s database and web services.  
Please ensure these files are kept secure and only accessible to authorized personnel.

---

## 1. Database Credentials

XML files for SQL Server database connections are located at:

```
C:\TRUE\Project\Config
```

### Files

- **Dbcreds.xml**: Credentials for `TDI_Master_July_29`
- **Dbcreds_IP.xml**: Credentials for `TDI_Worker_July_29`
- **Dbcreds_Manager.xml**: Credentials for `True-Manager-Jul-29`
- **Dbcreds_Master.xml**: Credentials for `TDI_Master_July_29`

### XML Structure Example

```xml
<?xml version="1.0" encoding="utf-8"?>
<DatabaseCredentials>
  <Server>finxdlf-dev-mssql.cmcevzbgcfhr.us-east-1.rds.amazonaws.com</Server>
  <Database>DATABASE_NAME</Database>
  <WindowsLogin>false</WindowsLogin>
  <Username>admin</Username>
  <Password>ENCRYPTED_PASSWORD</Password>
  <AdditionalParams>
    <Param>
      <Key>Persist Security Info</Key>
      <Value>False</Value>
    </Param>
  </AdditionalParams>
</DatabaseCredentials>
```

---

## 2. Master API Configuration

Located at:  
`C:\TRUE\web\MasterAPI`

### Example (`appsettings.json`)

```json
{
  "Versioning": {
    "Version": "5.1.82",
    "FormsVersion": "5.0.1",
    "ITHVersion": "2.5.21",
    "APIMajor": 2,
    "APIMinor": 0,
    "APIBuild": 0
  },
  "Logs": {
    "LogPath": "logs"
  },
  "ConnectionStrings": {
    "TrapezeDBConnectionA": "Server=dbServer;Database=TrapezeDatabase;",
    "TrapezeDBConnection1": "Server=dbServer;Database=TrapezeDatabase;User ID=xyz;Password=xyz",
    "TrapezeDBConnection2": "Server=dbServer;Database=TrapezeDatabase;Trusted_Connection=True;MultipleActiveResultSets=true"
  },
  "Project": {
    "BasePath": "\\\\WORKERDC-JULY\\Project",
    "InputPath": "\\\\WORKERDC-JULY\\Input",
    "DBCredPath": "\\\\WORKERDC-JULY\\Project\\config\\DBCreds.xml",
    "ClassListFile": "\\config\\classNameLookup.txt",
    "ClassificationValidationRulesFile": "\\config\\ClassificationValidationRules.xml",
    "UseDefaultDBUser": "true",
    "VersioningAware": "true",
    "ShowFilePath": "false",
    "ValidUploadPaths": [],
    "RetainInputFile": "true"
  },
  "Authentication": {
    "Basic": false,
    "Oidc": false,
    "Issuer": "",
    "Audience": "",
    "BasicSettings": {},
    "JwtSettings": {
      "Secret": "5wSIqaZfU4uCYkB6KPRman50Hd7YuKes",
      "TokenDuration": 60,
      "AlertWindowTime": 5,
      "Secure": false,
      "SameSite": "Lax",
      "ProbabilityToDelete": 0.5,
      "DaysOldToDelete": 3
    },
    "OidcSettings": {
      "Authority": "https://login.microsoftonline.com/tenant/",
      "ClientId": "value",
      "ClientSecret": "value",
      "TokenRequestUrl": "<TokenRequestUrl>",
      "DefaultRole": "User",
      "GroupObjectId": []
    },
    "NoneSettings": {
      "User": "",
      "TenantId": 1,
      "TenantName": ""
    }
  },
  "gui": {
    "changePassword": true,
    "useVerifai": false,
    "timezone": "local",
    "showVersionInExtraction": false,
    "refreshRateInSeconds": 5,
    "idle": 15
  },
  "Verifai": {
    "domain": "http://localhost:8000",
    "username": "TrapezeAdmin",
    "password": "Trapeze123"
  },
  "Theme": "Trapeze"
}
```

---

## 3. Manager Service Configuration

Located at:  
`C:\TRUE\web\Managerservice`

### Example (`appsettings.json`)

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "Logger": {
    "WriteToConsole": false,
    "WriteToFile": true,
    "Path": "\\\\WORKERDC-JULY\\Project\\Logs\\TrapezeManagerServices.log",
    "MinimumLevel": "Information"
  },
  "ManagerServer": {
    "ServerName": "ServerManager",
    "ProjectFolder": "\\\\WORKERDC-JULY\\Project",
    "DatabaseCredentialsFile": "\\\\WORKERDC-JULY\\Project\\config\\Dbcreds_Manager.xml",
    "PollingRateSeconds": 2,
    "MaxBatchRetries": 3,
    "FailedBatchDeleteWaitHours": 0,
    "BatchResetTimeSecs": 300,
    "BatchResetTimePageFactor": 3.0,
    "EnableWorkflowProcessDeletion": false
  },
  "TrapezeServers": {
    "MasterServer": {
      "ServerName": "MServer1",
      "Type": "Master",
      "URL": "http://localhost:8300/",
      "DatabaseCredentialsFile": "\\\\WORKERDC-JULY\\Project\\config\\Dbcreds_Master.xml",
      "IgnoreSsl": true,
      "ApiCredentialsFile": "TrapezeAPICreds.json"
    },
    "WorkerServers": [
      {
        "ServerName": "WServer1",
        "Type": "Worker",
        "URL": "http://10.216.184.48/",
        "DatabaseCredentialsFile": "\\\\WORKERDC-JULY\\Project\\config\\Dbcreds_10.216.184.48.xml",
        "MaxBatches": 5,
        "MaxBatchesPerUpload": 300,
        "IgnoreFormsHealth": true,
        "ApiCredentialsFile": "TrapezeAPICreds.json"
      },
      {
        "ServerName": "WServer2",
        "Type": "Worker",
        "URL": "http://$worker2-private-ip/",
        "DatabaseCredentialsFile": "<unc path>",
        "MaxBatches": 5,
        "MaxBatchesPerUpload": 300,
        "IgnoreFormsHealth": true,
        "ApiCredentialsFile": "TrapezeAPICreds.json"
      }
    ]
  }
  ,
  "Authentication": {
    "JwtSettings": {
      "Secret": "5wSIqaZfU4uCYkB6KPRman50Hd7YuKes",
      "TokenDuration": 60
    }
  },
  "AllowedHosts": "*"
}
```

---

## Security Notice

- **Do not share these files publicly.**
- Ensure all credentials and secrets are kept secure.
- Update passwords and secrets regularly.
- Restrict access to configuration files to authorized users only.

---

## Usage

- Update the `<Database>` and `<Password>` fields in XML files as needed for your environment.
- Adjust JSON configuration files for your deployment specifics (paths, credentials, server URLs, etc.).
- Refer to the configuration files for service setup and troubleshooting.

---