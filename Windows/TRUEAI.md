# Deployment Instructions
## Worker Setup
### 1. Prepare Worker API
- **Create Path:** `C:\\TRUE\\web\\workerapi`
- **Copy Files:** Transfer from `TDI_APIv5.1.80` to these folder file (e.g., af, ar) as needed.

### 2. IIS Configuration
- **Open IIS** and navigate to **Sites**.
- **Delete** the default site.
- **Add Website:**
  - **Site Name:** WORKERAPI
  - **Physical Path:** `C:\\TRUE\\web\\workerapi`
  - **Port:** 8301

## Master Setup

### 1. Prepare APIs
- **Paths:** 
  - `C:\\TRUE\\web\\MasterAPI`
  - **Copy Files:** Transfer from `TDI_APIv5.1.80` to these folder file (e.g., af, ar) as needed.
  - **Copy Files:** Transfer from `manager_service_v5.1.71` to these folder file (e.g., appsettings,... ) as needed.

### 2. IIS Configuration
- **Delete** default site in IIS.
- **Add Sites:**
  - **ManagerService:** 
    - **Path:** `C:\\TRUE\\web\\ManagerService`
    - **Port:** 8400
  - **MasterAPI:**
    - **Path:** `C:\\TRUE\\web\\MasterAPI`
    - **Port:** 8300

## Nginx Configuration (Frontend)
1. **Copy Files:** 
   - From `Delivery\\frontend_v5.1.107` to `C:\\tools\\nginx\\html` (delete existing files first).
2. **Service Management:**
   - Stop **Nginx Service** via **Services**.
   - Copy `nginx.conf` from `Delivery\\manager_service_v5\\nginx.conf` to `C:\\tools\\nginx\\conf\\`.
   - Start **Nginx Service**.
   - **For Worker Machine**: Use `nginx.worker.conf`, rename to `nginx.conf`, and repeat the steps above.

## TRUE Data Intelligence Installation (Worker)
- **Install:** TrueDataIntelligence_5 App from Delivery.
- **License Monitor:** Search for TRUE License Monitor and take a screenshot.
- **Navigate to Program Data:**
   - Open **C Drive**.
   - Locate and select the top right **View** option.
   - Enable **Hidden Files**.
- **Access Configuration Files:**
   - Go to `Program Data` → `TRUE Data Intelligence` → `Config` → `AdminGUI`.
- **Modify Database Schema:**
   - Change the following configurations:
     - `DBSchema` to `DBSchemadefault`
     - `DBSchema.AWS` to `DBSchema`

---

# Folder Sharing with UNC Path Access

1. **Create Project Folder:**
   - **Navigate to**: TRUE.
   - **Create Folder**: Name it `Project`.

2. **Configure Sharing Properties:**
   - **Right-click** on the `Project` folder.
   - **Select**: `Properties`.
   - **Go to**: `Sharing` tab.

3. **Set Up Sharing:**
   - Click on **Share**.
   - Confirm sharing by clicking the **Share** button at the bottom of the dialog box.

4. **Access via UNC Path:**
   - **Use** the UNC path to access the folder from another machine, labeled the **Master Machine**.

5. **Credentials Setup:**
   - **Login As**: Administrator.
   - **Enter Password**: Provide the Administrator password.
   - **Remember Credentials**: Ensure the option is selected to store the credentials.

---

# Additional Configuration Steps for TRUE Data Intelligence
### Editing the Database Schema
1. **Navigate to AdminGUI Folder:**
   - Follow the path to `Program Data` → `TRUE Data Intelligence` → `Config` → `AdminGUI`.

2. **Open DBSchema:**
   - Use Microsoft SQL Server Management Studio (SSMS) to open `DBSchema`.

### Modifying the Manager Schema

1. **Open Delivery Folder:**
   - Access the folder `manager_service_v5` within your delivery directory.

2. **Access ManagerDBSchema:**
   - Locate `ManagerDBSchema` and open it in Microsoft SQL Server Management Studio (SSMS).

3. **Modify Database Names:**
   - Ensure that you update the database names within the `ManagerDBSchema` as needed.

---
### Importing Project from ZIP File

1. **Open TRUE Intelligence App**:
   - Navigate to **File** → **Import Project from Zip File**.

2. **Select the Delivery Folder**:
   - Locate and choose `MortgageEnterprise-5.1`.
   - Confirm by clicking **OK**.
   - Enter the UNC path: `\\\\WORKER-DC\\Project`.
   - Click **OK**.
3. **Configure Database**:
   - **Server Name**: `finxdlf-dev-mssql.cmcevzbgcfhr.us-east-1.rds.amazonaws.com`
   - **Database Name**:  `TDI_Master2`. `(change this DB name like TDI_Master3 )`
   - **Advanced Options**:
     - **Check**: Use My Windows Credentials.
     - **Provide**: Database Username and Password.
     - **Create New Database**: Confirm with **Yes** then **OK**.
4. **Watch Folder Setup**:
   - Click **Start Watch Folder**.
   - Enter path: `\\\\WORKER-DC\\Input`.
   - Confirm with **OK** and **Yes**.
   - **Stop Watch Folder** after setup is complete.

### Project Tables
- **Bottom Left in App**: Click on `Project 51.0......_tables` link `click` on that.

#### Additional Database Connection:

1. **Configure Database for Worker**:
   - **Server Name**: As previously defined.
   - **Database Name**: `TDI_Worker2` `(change this DB name like TDI_Worker3 )`.
   - **Create** the database as needed.

### Configuration Files Update

1. **Navigate to TRUE → Project → Config**.

2. **Edit DBCredential Files**:
   - **Open with Notepad**: `DBCreds_IP`.
   - **`Copy`** : `entire content`.

3. **Update DBCreds**:
   - **Open** `DBCreds` and replace `TDI_Worker2` with `TDI_Master2`.

4. **Edit DBCreds_Master**:
   - **Paste** copied content, no additional changes needed.

5. **Create and Configure DBCreds_Manager**:
   - Make a copy of `DBCreds`.
   - **Rename** to `DBCreds_Manager`.
   - Copy content from `DBCreds_IP` into `DBCreds_Manager`.
   - **Update** Database Name: Use the primary database created in SSMS (`TDI_Manager01`).

---

# Configuration Instructions for TRUE Intelligence
### Worker Configuration

1. **Access Worker API Configurations:**
   - Navigate to `C:\\TRUE\\web\\workerapi`.
   - Open `appsettings.json` with Notepad.
     ```json
     "Project": {
       "BasePath": "\\\\Worker-dc\\true\\Project",
       "InputPath": "\\\\Worker-dc\\true\\Input",
       "DBCredPath": "config\\\\DBCreds_10.216.184.62.xml"
     }
     ```

2. **Set File and Directory Permissions:**
   - Right-click `C:\\TRUE` → Security → Add Users.
   - **Locations**: Set to `WORKER-DC`.
   - **Object Name**: Enter `iis_iusrs`, then click `Check Name` and `OK`.
   - **Permissions**: Grant `Full Control` to `IIS_IUSRS`.

3. **Configure IIS Application Pool:**
   - Open IIS → Application Pools → Right-click `WORKERAPI`.
   - Select **Advanced Settings** → Process Model → Identity.
   - Use custom account with username `True\\Administrator` and worker password.

4. **Start Watch Folder:**
   - Initiate watch folder, confirm with `OK`.

### Master Configuration

1. **Access Manager Service Configurations:**
   - Navigate to `C:\\TRUE\\web\\ManagerService`.
   - Open `appsettings.json` with Notepad.
     ```json
     "Logger": {
       "Path": "\\\\Worker-dc\\true\\Project\\Logs\\TrapezeManagerServices.log"
     },
     "ManagerServer": {
       "ServerName": "ServerManager",
       "ProjectFolder": "\\\\Worker-dc\\true\\Project",
       "DatabaseCredentialsFile": "\\\\Worker-dc\\true\\Project\\config\\Dbcreds_Manager.xml"
     },
     "TrapezeServers": {
       "MasterServer": {
         "DatabaseCredentialsFile": "\\\\Worker-dc\\true\\Project\\config\\Dbcreds_Master.xml",
         "ApiCredentialsFile": "TrapezeAPICreds.json"
       },
       "WorkerServers": [
         {
           "ServerName": "WServer1",
           "Type": "Worker",
           "URL": "http://10.216.184.62/",
           "DatabaseCredentialsFile": "\\\\Worker-dc\\true\\Project\\config\\Dbcreds_10.216.184.62.xml",
           "ApiCredentialsFile": "TrapezeAPICreds.json"
         }
       ]
     }
     ```

2. **Security Settings for Master:**
   - Follow the same security setup instructions as for the Worker.

3. **Configure Master IIS Application Pools:**
   - Open IIS → Application Pools → ManagerService and MasterAPI.
   - Right-click → Advanced Settings → Process Model → Identity.
   - Use custom account with username `True\\Administrator` and worker password.
### Network Configuration
- **Network Port Configuration:**
  - Allow Port 80 from the Worker machine for network access.
