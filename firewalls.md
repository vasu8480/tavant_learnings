# Server Setup Guide

This guide outlines the steps to prepare a newly launched server for configuration and deployment. Follow these steps immediately after launching the server.

## Prerequisites

- An Amazon EC2 instance or equivalent Linux server.
- Sudo privileges on the server.
- ``` bash
    sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    cd /home/ec2-user
    curl -LO https://user-data-ecs-velox.s3-us-west-1.amazonaws.com/security.sh
    chmod 755 security.sh
    sudo sh security.sh
    curl -LO https://user-data-ecs-velox.s3-us-west-1.amazonaws.com/cisscanfix.sh
    chmod 755 cisscanfix.sh
    sudo sh cisscanfix.sh
    
    
    sudo mkdir crowdstrike
    cd crowdstrike
    sudo curl -LO https://user-data-ecs-velox.s3.us-west-1.amazonaws.com/crowdstrike_install/falcon-sensor-7.20.0-17306.amzn2023.x86_64.rpm
    sudo yum install falcon-sensor-7.20.0-17306.amzn2023.x86_64.rpm -y
    sudo /opt/CrowdStrike/falconctl -s --cid=07993F0C4C924ABD81DBAEC79BE1C562-BC --tags="BAYVIEW,LO-DEV,REDIS-NODE"
    systemctl enable falcon-sensor
    systemctl start falcon-sensor
    ```
## Steps

1. **Update System Packages**
   ```bash
   yum update -y
   ```

2. **Disable SELinux**
   Modify the SELinux configuration to ensure it does not interfere with the setup:
   ```bash
   sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
   ```

3. **Run Security Script**
   Navigate to the home directory and download the security script:
   ```bash
   cd /home/ec2-user
   curl -LO https://user-data-ecs-velox.s3-us-west-1.amazonaws.com/security.sh
   chmod 755 security.sh
   sudo sh security.sh
   ```

4. **Run CIS Scan Fix Script**
   Download and execute the CIS Scan Fix script:
   ```bash
   curl -LO https://user-data-ecs-velox.s3-us-west-1.amazonaws.com/cisscanfix.sh
   chmod 755 cisscanfix.sh
   sudo sh cisscanfix.sh
   ```

5. **Install CrowdStrike Falcon Sensor**
   Create a directory for the CrowdStrike installation and navigate to it:
   ```bash
   sudo mkdir crowdstrike
   cd crowdstrike
   ```

   Download and install the CrowdStrike Falcon Sensor package:
   ```bash
   sudo curl -LO https://user-data-ecs-velox.s3.us-west-1.amazonaws.com/crowdstrike_install/falcon-sensor-7.20.0-17306.amzn2023.x86_64.rpm
   sudo yum install falcon-sensor-7.20.0-17306.amzn2023.x86_64.rpm -y
   ```

6. **Configure and Start CrowdStrike Falcon Sensor**
   Set the CrowdStrike CID and tags You certainly need to change the --tags based on the environment:
   ```bash
   sudo /opt/CrowdStrike/falconctl -s --cid=07993F0C4C924ABD81DBAEC79BE1C562-BC --tags="BAYVIEW,LO-DEV,REDIS-NODE"
   ```

   Enable and start the Falcon Sensor service:
   ```bash
   systemctl enable falcon-sensor
   systemctl start falcon-sensor
   ```

---

## Notes

- Ensure that the CID and tags for CrowdStrike are correctly specified for your environment.
- If you encounter issues during any step, check the system logs for detailed error messages.

Feel free to reach out to your system administrator if additional configuration or troubleshooting is required.
