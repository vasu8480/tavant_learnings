# Setting Up the Domain Controller on the Worker Instance

---
## Pre-Setup Checklist
1. To log in to the domain instance, use `DomainName\Administrator` or just the `DomainName`.
2. Take note of the `Root Domain` and `NetBIOS Domain Names`. Also, remember the password you set during configuration.
3. Ensure an entry is created in the AWS DHCP option sets with the domain name and IP address of the Machine which you created the Domain Name. Enable the DHCP options in the VPC settings. If the option is not available, it should still work as expected.
4. The Domain User Name will be `Administrator` and remember the Passowrd for DomainName you are seeting because with thtat passowrd only you can login to that windows system
---

## 1. Prepare the Worker Instance
Ensure the prerequisites are met:
- The server runs a Windows Server operating system (e.g., Windows Server 2019/2022).
- A static IP address is configured.

### Set the Server Name:
1. Open **Server Manager > Local Server**.
2. Change the computer name to something meaningful (e.g., `WORKER-DC`).

### Install Active Directory Domain Services (AD DS):
1. Open **Server Manager**.
2. Go to **Manage > Add Roles and Features**.
3. Select **Active Directory Domain Services (AD DS)** and proceed with the installation.

---

## 2. Promote the Server to a Domain Controller
1. After AD DS installation, in **Server Manager**, click **Promote this server to a domain controller**.
2. Create a new forest:
   - Enter the domain name (e.g., `example.local`).
   - Choose a **Domain and Forest Functional Level** (default is fine for most setups).
   - Set the **Directory Services Restore Mode (DSRM)** password.
3. Follow through the wizard and restart the server after installation.

---

## 3. Joining Master Instances to the Domain

### Configure Network Settings

## Ensure the Domain Controller's IP is Used as the DNS Server

### Step 1: Open Network and Sharing Center
- Press `Win + R` to open the **Run** dialog.
- Type `ncpa.cpl` and press **Enter**.

### Step 2: Configure the Network Adapter
1. Right-click the active network adapter and select **Properties**.
2. Select **Internet Protocol Version 4 (TCP/IPv4)** and click **Properties**.
3. Under **Use the following DNS server addresses**, enter the IP address of the domain controller (Woker IP).
4. Click **OK** to save the changes.

---

## Test Connectivity to the Domain Controller

### Step 1: Open Command Prompt or PowerShell
- ping **<IP_of_the_DomainController>** or **DomainURL (e.g., `example.local`)**. 


### Step 2: Join the Domain
1. Open **System Properties**:
   - Use `Windows Key + Pause` > **Change Settings**.
2. Under **Computer Name**, click **Change**.
3. Select **Domain** and enter the domain name (e.g., `example.local`).
4. Provide the **domain admin credentials** created during the domain controller setup.
5. Restart the master instance.

---

## 4. Configuring Folder Sharing and Permissions

### Step 1: Share Folders on the Worker Instance
1. Right-click the folder (e.g., **Project** or **Input**) > **Properties > Sharing tab > Advanced Sharing**.
2. Enable **Share this folder** and set permissions for the domain users or groups (e.g., `Domain Users`).

### Step 2: Configure NTFS Permissions
1. Go to the **Security tab** under folder properties.
2. Add the required **domain users/groups** and set the necessary permissions (**Read/Write**).

---

## 5. Verifying Connectivity

### Test Access from Master Instances
1. On the master instance, open **File Explorer**.
2. Navigate to the shared folder using the UNC path (e.g., `\\WORKER-DC\Project`).
3. Ensure proper authentication:
   - Use **domain credentials** to access the shared folder if prompted.

---

## 6. Testing and Finalization
- Ensure the worker instance (domain controller) and master instances are part of the same network.
- Verify that the shared folders are accessible with appropriate permissions.
- Optionally, configure **Group Policy** on the domain controller for advanced management.

This setup ensures centralized authentication and easy communication between worker and master instances.

---
# Troubleshooting

## 1. Reset the Domain Administrator Password on the Worker Instance

### Step 1: Open Active Directory Users and Computers
- Press `Win + R`, type `dsa.msc`, and press **Enter**.

### Step 2: Locate the Domain Administrator Account
- Navigate to your domain (e.g., `example.local`) > **Users**.
- Look for the **Administrator** account or the specific domain admin account you created.

### Step 3: Reset the Password
1. Right-click on the account and select **Reset Password**.
2. Enter and confirm the new password.
3. Click **OK** to apply the changes.


---
