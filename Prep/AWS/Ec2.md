# EC2

## Q: What is Amazon EC2?

### 🧠 Overview

**Amazon EC2 (Elastic Compute Cloud)** is a core AWS service that provides scalable virtual servers — called **instances** — for running applications in the cloud.
You can launch, configure, and manage compute capacity on-demand, without maintaining physical hardware.

---

### ⚙️ Purpose / How it Works

- EC2 allows you to **provision virtual machines** (VMs) with custom CPU, memory, storage, and networking configurations.
- It supports **auto-scaling** to match capacity with demand and **load balancing** for traffic distribution.
- You can choose OS (Linux/Windows), instance type, storage (EBS/Instance Store), and region.
- Instances are managed using **EC2 Dashboard**, **AWS CLI**, **SDKs**, or **Terraform/IaC tools**.

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ Launch an EC2 instance using AWS CLI:

```bash
aws ec2 run-instances \
  --image-id ami-0abcd1234efgh5678 \
  --count 1 \
  --instance-type t3.micro \
  --key-name my-keypair \
  --security-group-ids sg-0abc123456def7890 \
  --subnet-id subnet-0abc123456def7890
```

#### ✅ Example Terraform configuration:

```hcl
resource "aws_instance" "web_server" {
  ami           = "ami-0abcd1234efgh5678"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "web-server"
    Env  = "dev"
  }
}
```

---

### 📋 Key EC2 Concepts

| Concept            | Description                                                             |
| ------------------ | ----------------------------------------------------------------------- |
| **AMI**            | Amazon Machine Image — template for launching instances (OS + software) |
| **Instance Type**  | Defines CPU, memory, and network capacity (e.g., t3.micro, m5.large)    |
| **EBS Volume**     | Persistent block storage attached to EC2 instances                      |
| **Security Group** | Virtual firewall controlling inbound/outbound traffic                   |
| **Elastic IP**     | Static public IPv4 address for EC2 instance                             |
| **Key Pair**       | Used for SSH authentication (private/public keys)                       |
| **User Data**      | Script executed at instance boot time (for init automation)             |

---

### ✅ Best Practices

- Use **Auto Scaling Groups** for high availability and elasticity.
- Enable **CloudWatch monitoring** and **CloudTrail logging**.
- Use **IAM roles** instead of storing AWS keys on EC2.
- Regularly **patch OS and software** or automate via **SSM Patch Manager**.
- Always **restrict SSH access** via Security Groups (e.g., only from office IP).

---

### 💡 In short

Amazon EC2 is AWS’s scalable compute service for deploying virtual servers.
You define resources (CPU, memory, network), automate provisioning via CLI or Terraform, and manage security using IAM + Security Groups.

---

## Q: What are EC2 Instance Types?

---

### 🧠 Overview

**EC2 Instance Types** define the **hardware configuration** (CPU, memory, storage, and network) of virtual machines on AWS.
Each instance type is optimized for specific workloads — such as compute, memory, storage, or GPU-intensive tasks.

---

### ⚙️ Purpose / How It Works

- AWS groups EC2 instances into **families** based on performance characteristics.
- Each family has **sizes** (e.g., `t3.micro`, `t3.large`, `m5.xlarge`) that scale up in vCPUs and memory.
- You select the type depending on workload requirements — balancing performance vs cost.

Example:

- `t3.micro` → low-cost, general-purpose (testing/dev)
- `c6g.xlarge` → high CPU for compute workloads
- `r5.2xlarge` → high memory for databases

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ AWS CLI — List all instance types:

```bash
aws ec2 describe-instance-types \
  --query "InstanceTypes[*].InstanceType"
```

#### ✅ Terraform Example:

```hcl
resource "aws_instance" "app_server" {
  ami           = "ami-0abcd1234efgh5678"
  instance_type = "t3.medium"

  tags = {
    Name = "app-server"
    Env  = "prod"
  }
}
```

---

### 📋 EC2 Instance Families

| **Family**                        | **Use Case**                     | **Example Types** | **Notes**                |
| --------------------------------- | -------------------------------- | ----------------- | ------------------------ |
| **t (Burstable General Purpose)** | Low-cost, variable CPU workloads | t3, t4g           | Ideal for dev/test       |
| **m (General Purpose)**           | Balanced CPU and memory          | m5, m6i           | Web/app servers          |
| **c (Compute Optimized)**         | High CPU workloads               | c5, c6g           | Batch jobs, CI/CD builds |
| **r (Memory Optimized)**          | Memory-heavy workloads           | r5, r6i           | Databases, caching       |
| **x (High Memory)**               | SAP HANA, in-memory DBs          | x1e, x2idn        | Up to 24 TB RAM          |
| **p / g (Accelerated Computing)** | Machine learning, GPU rendering  | p3, g4dn          | GPU-based                |
| **i / d / h (Storage Optimized)** | I/O-intensive, databases         | i3, i4i, d2       | High IOPS                |
| **z (High Performance Compute)**  | High single-thread performance   | z1d               | HPC workloads            |

---

### ✅ Best Practices

- Choose **latest generation** (e.g., M7, C7, R7) for better price/performance.
- Use **Spot Instances** for non-critical, interruptible workloads.
- Use **Savings Plans or Reserved Instances** for long-term workloads.
- Right-size regularly using **AWS Compute Optimizer**.
- Always benchmark before production scaling.

---

### 💡 In short

EC2 instance types define compute configurations optimized for specific workloads — general, compute, memory, GPU, or storage.
Pick based on performance needs and cost-efficiency; automate provisioning with Terraform or Auto Scaling Groups.

---

## Q: What is an Amazon Machine Image (AMI)?

---

### 🧠 Overview

An **Amazon Machine Image (AMI)** is a **pre-configured template** used to launch EC2 instances.
It defines the **operating system**, **application server**, and **installed software**, serving as the base image for your virtual machines in AWS.

---

### ⚙️ Purpose / How It Works

- When launching an EC2 instance, you **must specify an AMI**.
- An AMI includes:

  - A **root volume** (OS and software)
  - **Launch permissions** (who can use it)
  - **Block device mappings** (attached volumes)

- You can use:

  - **AWS-provided AMIs** (e.g., Amazon Linux 2, Ubuntu)
  - **Marketplace AMIs** (vendor-provided)
  - **Custom AMIs** (your own configurations, reusable templates)

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ View available AMIs (AWS CLI)

```bash
aws ec2 describe-images --owners amazon \
  --filters "Name=platform,Values=linux" \
  --query "Images[*].{ID:ImageId,Name:Name}" --output table
```

#### ✅ Create a Custom AMI from an existing EC2 instance

```bash
aws ec2 create-image \
  --instance-id i-0abcd1234efgh5678 \
  --name "my-custom-ami" \
  --description "AMI with Nginx and App pre-installed"
```

#### ✅ Terraform Example

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0abcd1234efgh5678"
  instance_type = "t3.micro"

  tags = {
    Name = "web-server"
  }
}
```

---

### 📋 AMI Components

| **Component**            | **Description**                                            |
| ------------------------ | ---------------------------------------------------------- |
| **Root Volume**          | Base OS + software (e.g., Amazon Linux, Ubuntu)            |
| **Launch Permissions**   | Determines who can launch instances from the AMI           |
| **Block Device Mapping** | Defines storage volumes attached at launch                 |
| **Region-specific**      | AMIs are region-bound; must be copied for multi-region use |

---

### ✅ Best Practices

- **Create AMIs after configuring baseline software** (e.g., Docker, monitoring agents).
- **Automate AMI creation** using **Packer** or **EC2 Image Builder**.
- **Version AMIs** for traceability (e.g., `webapp-v1.2.3`).
- **Encrypt AMIs** containing sensitive data using **KMS**.
- **Deregister unused AMIs** to reduce EBS snapshot costs.

---

### 💡 In short

An **AMI** is the blueprint for launching EC2 instances — defining OS, configuration, and storage.
You can use AWS-provided, Marketplace, or custom-built AMIs to standardize and automate server provisioning.

---

## Q: What is the Difference Between EBS and Instance Store?

---

### 🧠 Overview

Both **EBS (Elastic Block Store)** and **Instance Store** are storage options for EC2 instances — but they differ in **persistence, durability, and use cases**.
EBS provides **persistent block storage**, while Instance Store offers **temporary (ephemeral) storage** that’s physically attached to the host.

---

### ⚙️ Purpose / How It Works

- **EBS**: Network-attached block storage that **persists independently** of the EC2 instance.
- **Instance Store**: Disk storage **physically attached** to the host; data is **lost when the instance stops or terminates**.

---

### 📋 Comparison Table

| Feature           | **EBS (Elastic Block Store)**                       | **Instance Store**                                   |
| ----------------- | --------------------------------------------------- | ---------------------------------------------------- |
| **Persistence**   | Data persists after instance stop/terminate         | Data lost when instance stops or terminates          |
| **Storage Type**  | Network-attached (via EBS service)                  | Local physical disk attached to EC2 host             |
| **Performance**   | Consistent but slightly slower (network latency)    | Very high IOPS and low latency                       |
| **Backup**        | Supports snapshots (S3-based)                       | No backup or snapshot support                        |
| **Detach/Attach** | Can detach and attach to another instance           | Tied to specific instance only                       |
| **Use Cases**     | Databases, app storage, OS volumes, persistent data | Cache, temporary files, high-speed buffer storage    |
| **Cost**          | Charged per GB/month                                | Included in instance price                           |
| **Resilience**    | Data replicated within Availability Zone            | No replication — single hardware failure = data loss |

---

### 🧩 Examples / Config Snippets

#### ✅ Example: Launch EC2 with EBS volume

```bash
aws ec2 run-instances \
  --image-id ami-0abcd1234efgh5678 \
  --instance-type t3.micro \
  --block-device-mappings '[{
      "DeviceName": "/dev/xvda",
      "Ebs": { "VolumeSize": 20, "DeleteOnTermination": true }
  }]'
```

#### ✅ Example: Instance Store in Terraform

```hcl
resource "aws_instance" "fast_compute" {
  ami           = "ami-0abcd1234efgh5678"
  instance_type = "i3.large" # i3 supports NVMe instance store
}
```

---

### ✅ Best Practices

- Use **EBS** for critical data or applications needing persistence.
- Use **Instance Store** for **ephemeral workloads** (e.g., caching, scratch space).
- Regularly **snapshot EBS volumes** for backup and disaster recovery.
- Combine both: Instance Store for temp compute + EBS for persistent state.

---

### 💡 In short

- **EBS** = Persistent, network-attached block storage (backed by AWS infrastructure).
- **Instance Store** = High-speed, ephemeral local storage tied to the instance’s lifecycle.
  Use EBS for data retention, and Instance Store for temporary, high-performance workloads.

---

## Q: How Do You Access an EC2 Instance?

---

### 🧠 Overview

You can access an **EC2 instance** using **SSH (Linux/Unix)** or **RDP (Windows)** depending on the OS.
Access control is managed via **key pairs**, **Security Groups**, and **IAM roles/policies** for secure authentication and authorization.

---

### ⚙️ Purpose / How It Works

- When launching an EC2 instance, you attach an **SSH key pair** (for Linux) or **password/RDP key** (for Windows).
- Access is allowed only if:

  - The **Security Group** allows inbound port 22 (SSH) or 3389 (RDP).
  - You use the **correct private key** that matches the instance’s key pair.

- For private instances, access is usually via **bastion host** or **Session Manager (SSM)**.

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ 1. SSH Access (Linux)

```bash
chmod 400 my-key.pem
ssh -i my-key.pem ec2-user@<Public-IP-or-DNS>
```

- `ec2-user` → Amazon Linux
- `ubuntu` → Ubuntu AMI
- `centos` → CentOS AMI

#### ✅ 2. RDP Access (Windows)

1. Obtain the Administrator password:

   ```bash
   aws ec2 get-password-data --instance-id i-0abcd1234efgh5678 --priv-launch-key my-key.pem
   ```

2. Open **Remote Desktop Connection** → Enter **Public DNS** → Use credentials.

#### ✅ 3. AWS Systems Manager (SSM) — No SSH Needed

```bash
aws ssm start-session --target i-0abcd1234efgh5678
```

- Requires `AmazonSSMManagedInstanceCore` IAM role on EC2
- Useful for private subnets (no public IP)

---

### 📋 Access Methods Summary

| **Access Type**             | **OS**  | **Port**  | **Requires**               | **Use Case**                    |
| --------------------------- | ------- | --------- | -------------------------- | ------------------------------- |
| **SSH**                     | Linux   | 22        | `.pem` key + public IP     | Standard CLI access             |
| **RDP**                     | Windows | 3389      | Decrypted admin password   | GUI-based access                |
| **SSM Session Manager**     | Both    | None      | IAM role + SSM Agent       | Secure access without SSH/RDP   |
| **Bastion Host (Jump Box)** | Both    | 22 / 3389 | Private instance + Bastion | Access private subnet instances |

---

### ✅ Best Practices

- Restrict **SSH/RDP** ports to trusted IPs only.
- Use **SSM Session Manager** instead of open SSH for better security.
- Rotate and manage SSH keys using **AWS Secrets Manager** or **IAM policies**.
- Disable root login and enforce key-based authentication.
- Use **bastion host** for accessing private subnet instances.

---

### 💡 In short

Access EC2 via **SSH (Linux)**, **RDP (Windows)**, or **SSM Session Manager**.
Secure access by using IAM roles, private keys, restricted Security Groups, and avoiding direct public exposure where possible.

---

## Q: What is a Key Pair in EC2?

---

### 🧠 Overview

An **EC2 Key Pair** is a **secure authentication mechanism** used to connect to Amazon EC2 instances.
It consists of a **public key** (stored by AWS) and a **private key** (downloaded and owned by you) that together enable **SSH (Linux)** or **RDP (Windows)** access without using passwords.

---

### ⚙️ Purpose / How It Works

- When launching an EC2 instance, you specify a **key pair**.
- AWS injects the **public key** into the instance’s metadata.
- You use the **private key file (`.pem`)** locally to authenticate via SSH or decrypt Windows passwords.
- Key pairs ensure **secure, encrypted login** — no need for storing static passwords.

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ 1. Create a Key Pair using AWS CLI

```bash
aws ec2 create-key-pair --key-name my-keypair \
  --query "KeyMaterial" --output text > my-keypair.pem
chmod 400 my-keypair.pem
```

#### ✅ 2. Use Key Pair for SSH Login

```bash
ssh -i my-keypair.pem ec2-user@<Public-IP-or-DNS>
```

#### ✅ 3. Create Key Pair via Terraform

```hcl
resource "aws_key_pair" "dev_key" {
  key_name   = "dev-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
```

#### ✅ 4. Attach Key Pair when Launching EC2

```bash
aws ec2 run-instances \
  --image-id ami-0abcd1234efgh5678 \
  --instance-type t3.micro \
  --key-name my-keypair
```

---

### 📋 Key Pair Components

| **Component**          | **Description**                                               |
| ---------------------- | ------------------------------------------------------------- |
| **Public Key**         | Stored in AWS; injected into EC2 at launch                    |
| **Private Key (.pem)** | Stored securely by user; used for SSH or decrypting passwords |
| **Key Algorithm**      | RSA or ED25519                                                |
| **Storage Location**   | Default: `~/.ssh/` or local secure path                       |
| **Permissions**        | Must be `chmod 400` before use                                |

---

### ✅ Best Practices

- Always **store private keys securely** (never share or commit to Git).
- Restrict key usage per environment (e.g., `dev-key`, `prod-key`).
- Rotate keys periodically and **delete unused ones**.
- Use **AWS Systems Manager Session Manager** or **EC2 Instance Connect** to reduce key management overhead.
- Enforce IAM policies to control who can create or use key pairs.

---

### 💡 In short

A **key pair** is the SSH/RDP authentication method for EC2 — AWS keeps the **public key**, you hold the **private key**.
It enables secure, passwordless access to instances; always protect and rotate private keys regularly.

---

## Q: How to Attach a Volume to an EC2 Instance?

---

### 🧠 Overview

Attaching a volume to an EC2 instance means **mounting an Amazon EBS (Elastic Block Store)** volume to provide additional storage.
This can be used for application data, logs, or backups — separate from the root filesystem.

---

### ⚙️ Purpose / How It Works

- EBS volumes act like **virtual hard drives** attached to EC2 instances.
- A volume can only attach to **one instance at a time** (except multi-attach-enabled).
- After attaching, you **mount it** to a directory on the instance to make it usable.

**Steps:**

1. Create a new EBS volume.
2. Attach it to the desired EC2 instance.
3. Format (if new) and mount it to a directory.
4. (Optional) Update `/etc/fstab` for persistence.

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ 1. Create a new EBS volume

```bash
aws ec2 create-volume \
  --availability-zone us-east-1a \
  --size 20 \
  --volume-type gp3 \
  --tag-specifications 'ResourceType=volume,Tags=[{Key=Name,Value=data-volume}]'
```

#### ✅ 2. Attach the volume to an instance

```bash
aws ec2 attach-volume \
  --volume-id vol-0abcd1234efgh5678 \
  --instance-id i-0123456789abcdef0 \
  --device /dev/xvdf
```

#### ✅ 3. Format and mount (inside EC2 instance)

```bash
# Check attached volume
lsblk

# Format volume (first time only)
sudo mkfs -t ext4 /dev/xvdf

# Create mount directory
sudo mkdir /data

# Mount the volume
sudo mount /dev/xvdf /data

# Verify mount
df -h
```

#### ✅ 4. Persist mount on reboot (optional)

Add this line in `/etc/fstab`:

```bash
/dev/xvdf   /data   ext4   defaults,nofail   0   2
```

#### ✅ Terraform Example:

```hcl
resource "aws_ebs_volume" "data" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp3"
}

resource "aws_volume_attachment" "data_attach" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.data.id
  instance_id = aws_instance.app.id
}
```

---

### 📋 Parameters / Options

| **Parameter**         | **Description**      | **Example**             |
| --------------------- | -------------------- | ----------------------- |
| `--volume-id`         | ID of the EBS volume | `vol-0abcd1234efgh5678` |
| `--instance-id`       | ID of EC2 instance   | `i-0123456789abcdef0`   |
| `--device`            | Logical device name  | `/dev/xvdf`             |
| `--availability-zone` | Must match EC2 AZ    | `us-east-1a`            |

---

### ✅ Best Practices

- Ensure **EBS and EC2 are in the same AZ**.
- Use **gp3** for general workloads; **io1/io2** for high IOPS.
- Always **unmount and detach** before deleting a volume.
- Take **snapshots** for backup before modifying or detaching.
- Tag volumes (e.g., `Name`, `Env`, `Owner`) for management and cost tracking.

---

### 💡 In short

Attach an EBS volume to EC2 using the AWS CLI, Console, or Terraform.
Then format and mount it inside the instance to use as extra storage.
Ensure same-AZ placement, tag volumes, and snapshot regularly for durability.

---

## Q: What Happens When You Stop vs Terminate an EC2 Instance?

---

### 🧠 Overview

When you **stop** an EC2 instance, it’s **temporarily shut down**, and you can **start it again later**.
When you **terminate** an instance, it’s **permanently deleted** — along with its attached resources (unless configured otherwise).

---

### ⚙️ Purpose / How It Works

#### 🟥 Stop:

- The instance **shuts down gracefully** (like powering off a server).
- The **EBS root volume** and attached data volumes are **preserved**.
- You can **start** it later with the same instance ID.
- **Instance Store volumes are lost.**
- The **Elastic IP (if not associated to EIP resource)** is released.

#### 🧨 Terminate:

- The instance and **all attached EBS volumes (if DeleteOnTermination=true)** are **permanently deleted**.
- **Elastic IPs** are released unless explicitly disassociated.
- The instance **cannot be restarted** — termination is final.

---

### 📋 Comparison Table

| **Aspect**              | **Stop**                                  | **Terminate**                                |
| ----------------------- | ----------------------------------------- | -------------------------------------------- |
| **Instance State**      | Stopped (can restart)                     | Terminated (deleted)                         |
| **Billing**             | Stops compute charges (EBS still charged) | All charges stop (EBS deleted if configured) |
| **Root EBS Volume**     | Retained                                  | Deleted (if `DeleteOnTermination=true`)      |
| **Instance Store Data** | Lost                                      | Lost                                         |
| **Elastic IP**          | Released (unless associated to EIP)       | Released                                     |
| **Restart Possible**    | ✅ Yes                                    | ❌ No                                        |
| **Use Case**            | Temporary shutdown                        | Permanent deletion                           |

---

### 🧩 Examples / Commands

#### ✅ Stop an instance

```bash
aws ec2 stop-instances --instance-ids i-0123456789abcdef0
```

#### ✅ Start an instance

```bash
aws ec2 start-instances --instance-ids i-0123456789abcdef0
```

#### ✅ Terminate an instance

```bash
aws ec2 terminate-instances --instance-ids i-0123456789abcdef0
```

---

### ✅ Best Practices

- Use **Stop** when performing maintenance or cost optimization for dev/test.
- Use **Terminate** for instances you’ll never reuse.
- Always **create AMI snapshots or EBS backups** before termination.
- Check **DeleteOnTermination** flag for attached EBS volumes to prevent data loss.
- For automation, use **Instance Lifecycle Hooks** in Auto Scaling to handle cleanup safely.

---

### 💡 In short

- **Stop** = Pause the instance (EBS data retained, reusable).
- **Terminate** = Permanently delete the instance (data lost if not backed up).
  Use **Stop** for temporary shutdowns; **Terminate** for complete teardown.

---

## Q: What is EC2 User Data?

---

### 🧠 Overview

**EC2 User Data** is a script or configuration that runs **automatically at instance launch** — typically used for **bootstrapping, configuration, or automation**.
It’s often a **Bash script (Linux)** or **PowerShell script (Windows)** that installs software, configures services, or runs initialization tasks.

---

### ⚙️ Purpose / How It Works

- When launching an EC2 instance, you can pass **user data** in the configuration.
- The script executes **only once** (by default) during the **first boot**.
- The EC2 instance reads user data from **instance metadata service (IMDS)**.
- Common use cases:

  - Install packages (e.g., Nginx, Docker)
  - Fetch configuration from S3 or Git
  - Register instance with monitoring tools
  - Run Cloud-Init tasks (Linux)

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ Example 1: Linux — Install and start Nginx

```bash
#!/bin/bash
yum update -y
amazon-linux-extras install nginx1 -y
systemctl enable nginx
systemctl start nginx
echo "<h1>Deployed via EC2 User Data</h1>" > /usr/share/nginx/html/index.html
```

#### ✅ Example 2: Terraform — Pass user_data to EC2

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0abcd1234efgh5678"
  instance_type = "t3.micro"

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd
  EOF

  tags = {
    Name = "web-server"
  }
}
```

#### ✅ Example 3: View user data from EC2 instance

```bash
curl http://169.254.169.254/latest/user-data
```

---

### 📋 Key Notes

| **Feature**           | **Description**                                                 |
| --------------------- | --------------------------------------------------------------- |
| **Execution Timing**  | Runs at first boot (can be configured to re-run)                |
| **Supported Formats** | Shell scripts (Linux), PowerShell (Windows), MIME (Cloud-Init)  |
| **Access Method**     | Available via instance metadata service (IMDS)                  |
| **Default Behavior**  | Executes once per instance unless manually configured otherwise |
| **Logs Location**     | `/var/log/cloud-init-output.log` or `/var/log/user-data.log`    |

---

### ✅ Best Practices

- Use **Cloud-Init** for structured, repeatable setups.
- Store scripts in **version control** (e.g., Git) and inject dynamically.
- Keep scripts **idempotent** (safe to re-run).
- Avoid hardcoding secrets — use **AWS Secrets Manager** or **SSM Parameter Store**.
- Use **Base AMIs + User Data** for lightweight automation during instance launch.

---

### 💡 In short

**EC2 User Data** is a startup script that runs automatically when an instance launches — used for automation like installing packages, configuring servers, or deploying apps.
Think of it as **boot-time configuration** for EC2 provisioning.

---

## Q: How Do You Resize an EC2 Instance?

---

### 🧠 Overview

Resizing an **EC2 instance** means changing its **instance type** (CPU, memory, network performance) to match workload needs — for example, scaling up from `t3.micro` to `t3.large` or moving to a different family like `m5.xlarge`.
This process helps **optimize performance and cost** without redeploying the application.

---

### ⚙️ Purpose / How It Works

- EC2 instance type defines compute capacity (vCPUs, RAM, network).
- You can **stop** the instance, **change its type**, and **start** it again.
- For **EBS-backed instances**, resizing is seamless since the root volume persists.
- You can resize via **AWS Console**, **CLI**, or **Terraform**.

**Note:**

- The instance must be **in “stopped” state** to change its type.
- Instance type must be **supported in the same Availability Zone**.

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ 1. Using AWS CLI

```bash
# Stop the instance
aws ec2 stop-instances --instance-ids i-0123456789abcdef0

# Modify the instance type
aws ec2 modify-instance-attribute \
  --instance-id i-0123456789abcdef0 \
  --instance-type "{\"Value\": \"t3.large\"}"

# Start the instance again
aws ec2 start-instances --instance-ids i-0123456789abcdef0
```

#### ✅ 2. Terraform Example

```hcl
resource "aws_instance" "web_server" {
  ami           = "ami-0abcd1234efgh5678"
  instance_type = "t3.large" # Updated type

  tags = {
    Name = "web-server"
  }
}
```

Then apply the change:

```bash
terraform apply
```

#### ✅ 3. Using AWS Console

1. Stop the instance.
2. Go to **Actions → Instance Settings → Change Instance Type**.
3. Choose new type (e.g., `m5.large`).
4. Start the instance again.

---

### 📋 Resizing Considerations

| **Aspect**                 | **Details**                                |
| -------------------------- | ------------------------------------------ |
| **Root Volume**            | Retained if EBS-backed                     |
| **Public IP**              | Reassigned if not Elastic IP               |
| **Instance Store Volumes** | Lost on stop/start                         |
| **AZ Support**             | Instance type must be available in same AZ |
| **Network Performance**    | May change with instance type              |
| **Downtime**               | Required (during stop/start)               |

---

### ✅ Best Practices

- Use **EBS-backed instances** to retain data during resize.
- Take an **AMI or snapshot** before resizing for rollback safety.
- Test performance and cost before scaling production workloads.
- Use **Auto Scaling Groups** to manage dynamic resizing automatically.
- Validate that **security groups**, **IAM roles**, and **Elastic IPs** remain attached.

---

### 💡 In short

To resize EC2: **Stop → Change instance type → Start.**
EBS volumes persist, but downtime occurs.
Always snapshot first, confirm AZ support, and consider Auto Scaling for automated right-sizing.

---

## Q: What is EC2 Instance Metadata?

---

### 🧠 Overview

**EC2 Instance Metadata** is a special service that provides **information about the running EC2 instance** — such as its ID, IP, region, AMI ID, IAM role, and user data.
It’s accessed locally from within the instance and is used for **automation, configuration, and dynamic application behavior**.

---

### ⚙️ Purpose / How It Works

- AWS exposes metadata through a **link-local IP: `169.254.169.254`** (only accessible from within the instance).
- The **Instance Metadata Service (IMDS)** allows applications, scripts, and agents to retrieve instance details **without requiring AWS credentials**.
- Common uses:

  - Fetching **instance identity** (for tagging, logging)
  - Retrieving **IAM role credentials**
  - Accessing **user data scripts**
  - Reading **network and region information**

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ 1. View All Metadata (Linux)

```bash
curl http://169.254.169.254/latest/meta-data/
```

#### ✅ 2. Get Specific Metadata Fields

```bash
# Instance ID
curl http://169.254.169.254/latest/meta-data/instance-id

# Private IP
curl http://169.254.169.254/latest/meta-data/local-ipv4

# IAM Role name
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/

# User Data (if configured)
curl http://169.254.169.254/latest/user-data
```

#### ✅ 3. Use IMDSv2 (Recommended — Token-Based)

```bash
# Step 1: Get session token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Step 2: Use token to query metadata securely
curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id
```

---

### 📋 Metadata Categories

| **Category**       | **Example Path**                           | **Description**                                   |
| ------------------ | ------------------------------------------ | ------------------------------------------------- |
| **Instance Info**  | `/instance-id`, `/hostname`, `/local-ipv4` | Identifiers and networking                        |
| **AMI Info**       | `/ami-id`                                  | Source AMI ID used to launch instance             |
| **IAM Role Info**  | `/iam/security-credentials/`               | Temporary credentials for assigned IAM role       |
| **User Data**      | `/user-data`                               | Custom script or configuration provided at launch |
| **Placement Info** | `/placement/availability-zone`             | Region and AZ information                         |

---

### ✅ Best Practices

- Always use **IMDSv2** (token-based) — prevents SSRF and credential theft.
- Restrict metadata access to trusted applications only.
- Avoid exposing metadata responses in logs or APIs.
- Use metadata for dynamic automation — e.g., auto-tagging instances, logging context, etc.
- Rotate IAM roles rather than embedding credentials in AMIs or scripts.

---

### 💡 In short

**EC2 metadata** provides runtime info about the instance — ID, IP, IAM role, user data, and more — accessible from within the instance via `169.254.169.254`.
Use **IMDSv2** for secure, token-based access to automate instance configuration and authentication safely.

---

## Q: How to Check EC2 Instance Health?

---

### 🧠 Overview

**EC2 instance health** determines whether the instance and its underlying AWS infrastructure are functioning correctly.
AWS performs **two types of health checks** — _System Status Checks_ and _Instance Status Checks_ — to detect hardware or software issues.

---

### ⚙️ Purpose / How It Works

AWS automatically monitors instances and reports their health status:

- **System Status Check**: Detects problems with AWS hardware or networking.
- **Instance Status Check**: Detects issues inside your instance (e.g., OS crash, corrupted file system).
  You can view or monitor health via **AWS Console**, **CLI**, or **CloudWatch alarms**.

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ 1. Check Health via AWS CLI

```bash
aws ec2 describe-instance-status \
  --instance-ids i-0123456789abcdef0 \
  --query "InstanceStatuses[*].{Instance:InstanceId,SystemStatus:SystemStatus.Status,InstanceStatus:InstanceStatus.Status}" \
  --output table
```

**Example Output:**

```
--------------------------------------------------------------
|                DescribeInstanceStatus                      |
+-------------+----------------+-----------------------------+
|  Instance   | SystemStatus   | InstanceStatus              |
+-------------+----------------+-----------------------------+
| i-0123456789abcdef0 | ok     | ok                          |
+-------------+----------------+-----------------------------+
```

#### ✅ 2. Using AWS Console

- Navigate to **EC2 → Instances → Status Checks tab**
- You’ll see:

  - ✅ **2/2 checks passed** → Healthy
  - ⚠️ **1/2 checks passed** → Partial issue
  - ❌ **0/2 checks passed** → Unhealthy

#### ✅ 3. Create CloudWatch Alarm for Instance Health

```bash
aws cloudwatch put-metric-alarm \
  --alarm-name "EC2InstanceHealthCheck" \
  --metric-name StatusCheckFailed \
  --namespace AWS/EC2 \
  --statistic Maximum \
  --dimensions Name=InstanceId,Value=i-0123456789abcdef0 \
  --period 60 \
  --threshold 1 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --evaluation-periods 2 \
  --alarm-actions arn:aws:sns:us-east-1:123456789012:NotifyOps
```

---

### 📋 Health Check Types

| **Check Type**            | **What It Monitors**                    | **Possible Actions**                               |
| ------------------------- | --------------------------------------- | -------------------------------------------------- |
| **System Status Check**   | Hardware, networking, power, hypervisor | Stop/start instance or migrate to healthy host     |
| **Instance Status Check** | OS-level issues (kernel panic, crash)   | Restart instance, fix application/OS configuration |
| **Custom Health Check**   | App-level monitoring (via CloudWatch)   | Use scripts, agents, or ALB target health          |

---

### ✅ Best Practices

- Automate health recovery using **Auto Scaling** or **AWS EC2 Auto-Recovery**.
- Configure **CloudWatch Alarms** to notify or restart unhealthy instances.
- Regularly patch OS and monitor app-level health with **Application Load Balancer target checks**.
- Ensure proper IAM and network configurations to prevent false failures.

---

### 💡 In short

EC2 health = **System Check + Instance Check**.
Use AWS Console, CLI, or CloudWatch to monitor — “2/2 checks passed” means healthy.
Automate recovery using **Auto Scaling** or **EC2 Auto-Recovery** for production resilience.

---

## Q: What is an EC2 Placement Group?

---

### 🧠 Overview

An **EC2 Placement Group** is a **logical grouping of EC2 instances** within a single AWS region that influences **how instances are physically placed** on underlying hardware.
It helps achieve **high performance**, **low latency**, or **fault isolation** — depending on the chosen strategy.

---

### ⚙️ Purpose / How It Works

Placement Groups control the **placement strategy** of instances across physical hosts to optimize performance or availability.
AWS offers three main strategies:

- **Cluster** → Low latency, high bandwidth (HPC, real-time apps)
- **Spread** → High availability (isolates instances across hardware)
- **Partition** → Large-scale distributed systems (e.g., Hadoop, Kafka)

---

### 📋 Placement Group Types

| **Type**      | **Description**                                                       | **Use Case**                                            | **Notes**                          |
| ------------- | --------------------------------------------------------------------- | ------------------------------------------------------- | ---------------------------------- |
| **Cluster**   | Instances placed in a **single AZ and close together**                | High-performance computing (HPC), low-latency workloads | Same rack; high network throughput |
| **Spread**    | Instances spread across **distinct hardware racks**                   | Critical applications needing isolation                 | Max 7 instances per AZ             |
| **Partition** | Instances divided into **logical partitions**, each on separate racks | Big data, distributed systems (HDFS, Cassandra)         | Up to 7 partitions per AZ          |

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ 1. Create a Placement Group (CLI)

```bash
aws ec2 create-placement-group \
  --group-name hpc-cluster \
  --strategy cluster
```

#### ✅ 2. Launch Instance into Placement Group

```bash
aws ec2 run-instances \
  --image-id ami-0abcd1234efgh5678 \
  --instance-type c5n.large \
  --placement "GroupName=hpc-cluster" \
  --count 2
```

#### ✅ 3. Terraform Example

```hcl
resource "aws_placement_group" "hpc_pg" {
  name     = "hpc-placement"
  strategy = "cluster"
}

resource "aws_instance" "compute" {
  ami           = "ami-0abcd1234efgh5678"
  instance_type = "c5n.large"
  placement_group = aws_placement_group.hpc_pg.id
  count = 2
}
```

---

### ⚙️ Additional Notes

- Placement groups are **per Availability Zone** (except Partition — can span multiple).
- Must use **supported instance types** (mostly compute/network optimized).
- You **cannot move** an existing instance into a placement group — must relaunch.
- Can combine placement groups with **Auto Scaling** and **EBS volumes** for performance and resilience.

---

### ✅ Best Practices

- Use **Cluster** groups for network-bound workloads needing <10µs latency.
- Use **Spread** for maximum fault tolerance (one instance per rack).
- Use **Partition** for distributed workloads like Kafka, HDFS, or Cassandra.
- Monitor placement constraints with `describe-placement-groups`.
- Always **plan group strategy before deployment** — moving after launch isn’t allowed.

---

### 💡 In short

An **EC2 Placement Group** controls how instances are placed on AWS hardware to optimize **performance, fault tolerance, or scalability**.
Use:

- 🧠 _Cluster_ → High performance
- 🧱 _Spread_ → Isolation & resilience
- ⚙️ _Partition_ → Distributed systems scalability

---

## Q: What is EC2 Auto Recovery?

---

### 🧠 Overview

**EC2 Auto Recovery** is an AWS feature that automatically **detects and recovers impaired EC2 instances** caused by **hardware or system issues** — without changing the instance ID, IP address, or metadata.
It ensures **high availability** by automatically moving the instance to healthy underlying hardware.

---

### ⚙️ Purpose / How It Works

- AWS monitors the **system status checks** of EC2 instances.
- If a hardware or network issue is detected, AWS **automatically recovers** the instance to a healthy host in the same Availability Zone.
- During recovery:

  - Instance ID, EBS volumes, private IP, Elastic IP, and metadata **remain unchanged**.
  - Only the **underlying physical host** is replaced.

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ 1. Enable Auto Recovery using AWS CLI

```bash
aws ec2 create-tags \
  --resources i-0123456789abcdef0 \
  --tags Key=aws:ec2:auto-recovery,Value=default
```

#### ✅ 2. Create a CloudWatch Alarm to Trigger Auto Recovery

```bash
aws cloudwatch put-metric-alarm \
  --alarm-name "EC2AutoRecovery" \
  --metric-name StatusCheckFailed_System \
  --namespace AWS/EC2 \
  --statistic Maximum \
  --dimensions Name=InstanceId,Value=i-0123456789abcdef0 \
  --period 60 \
  --evaluation-periods 2 \
  --threshold 1 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --alarm-actions arn:aws:automate:us-east-1:ec2:recover
```

#### ✅ 3. Terraform Example

```hcl
resource "aws_cloudwatch_metric_alarm" "auto_recover" {
  alarm_name          = "ec2-auto-recovery"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 1

  alarm_actions = [
    "arn:aws:automate:us-east-1:ec2:recover"
  ]

  dimensions = {
    InstanceId = "i-0123456789abcdef0"
  }
}
```

---

### 📋 Key Features

| **Feature**             | **Description**                                     |
| ----------------------- | --------------------------------------------------- |
| **Triggers**            | System status check failures (hardware, networking) |
| **Recovery Type**       | Instance migrated to healthy host                   |
| **Data Impact**         | EBS data and IPs retained                           |
| **Availability Zone**   | Remains in same AZ                                  |
| **Supported Instances** | Only EBS-backed instances (not instance-store)      |
| **Downtime**            | Minimal (typically <5 minutes)                      |

---

### ✅ Best Practices

- Use **EBS-backed instances** — auto recovery doesn’t work for instance-store volumes.
- Combine with **CloudWatch alarms** for proactive monitoring.
- Use **Auto Scaling** for app-level fault tolerance (beyond hardware).
- Enable **detailed monitoring** for faster detection and recovery.
- Test recovery periodically in non-prod environments.

---

### 💡 In short

**EC2 Auto Recovery** automatically restores impaired instances due to hardware or network issues — keeping the same ID, IP, and data intact.
It’s an AWS-managed resilience feature for **EBS-backed EC2s**, ensuring minimal downtime without manual intervention.

---

## Q: What is EC2 Auto Scaling?

---

### 🧠 Overview

**EC2 Auto Scaling** automatically **adds or removes EC2 instances** in response to changing workload demands.
It ensures that your application always has the **right number of instances** running — optimizing **performance, availability, and cost**.

---

### ⚙️ Purpose / How It Works

- EC2 Auto Scaling uses **Auto Scaling Groups (ASGs)** to manage instance fleets.
- ASGs monitor metrics (like CPU, memory, requests) via **CloudWatch** and scale the number of instances **up or down automatically**.
- It supports both **dynamic scaling** (based on policies) and **scheduled scaling** (based on time).

**Scaling Lifecycle:**

1. Define a **Launch Template** (AMI, instance type, security groups, etc.).
2. Create an **Auto Scaling Group** linked to the template and VPC subnets.
3. Configure **scaling policies** (target tracking, step, or scheduled).
4. AWS automatically launches or terminates EC2 instances as per rules.

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ 1. Create Launch Template

```bash
aws ec2 create-launch-template \
  --launch-template-name web-template \
  --version-description "v1" \
  --launch-template-data '{
    "ImageId": "ami-0abcd1234efgh5678",
    "InstanceType": "t3.micro",
    "SecurityGroupIds": ["sg-0123abcd4567efgh8"],
    "KeyName": "web-key"
  }'
```

#### ✅ 2. Create Auto Scaling Group

```bash
aws autoscaling create-auto-scaling-group \
  --auto-scaling-group-name web-asg \
  --launch-template "LaunchTemplateName=web-template,Version=1" \
  --min-size 2 --max-size 5 --desired-capacity 3 \
  --vpc-zone-identifier "subnet-abc12345,subnet-def67890"
```

#### ✅ 3. Add Target Tracking Policy

```bash
aws autoscaling put-scaling-policy \
  --auto-scaling-group-name web-asg \
  --policy-name cpu-scaling-policy \
  --policy-type TargetTrackingScaling \
  --target-tracking-configuration '{
    "PredefinedMetricSpecification": {"PredefinedMetricType": "ASGAverageCPUUtilization"},
    "TargetValue": 60.0
  }'
```

#### ✅ 4. Terraform Example

```hcl
resource "aws_autoscaling_group" "web_asg" {
  name                 = "web-asg"
  min_size             = 2
  max_size             = 5
  desired_capacity     = 3
  vpc_zone_identifier  = ["subnet-abc123", "subnet-def456"]
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}
```

---

### 📋 Auto Scaling Policies

| **Policy Type**       | **Description**                                        | **Example Use Case**                       |
| --------------------- | ------------------------------------------------------ | ------------------------------------------ |
| **Target Tracking**   | Scales to maintain a specific metric (e.g., CPU = 60%) | Web servers                                |
| **Step Scaling**      | Scales in steps based on thresholds                    | Batch jobs                                 |
| **Scheduled Scaling** | Scales at specific times                               | Predictable workloads (e.g., office hours) |

---

### ✅ Best Practices

- Always deploy across **multiple AZs** for fault tolerance.
- Use **Elastic Load Balancer (ALB/NLB)** for traffic distribution.
- Combine with **Launch Templates** (not Launch Configurations — deprecated).
- Enable **Instance Health Checks** for automatic replacement.
- Use **CloudWatch alarms** for dynamic and predictive scaling.

---

### 💡 In short

**EC2 Auto Scaling** automatically manages EC2 instance counts in an **Auto Scaling Group (ASG)** to maintain performance and reduce costs.
It dynamically adjusts capacity using **CloudWatch metrics and scaling policies** — ensuring reliability, elasticity, and operational efficiency.

---

## Q: What is the Difference Between Stop/Start and Reboot in EC2?

---

### 🧠 Overview

Both **Stop/Start** and **Reboot** operations restart an EC2 instance — but they differ in **behavior, downtime, and underlying host handling**.

- **Stop/Start** → Shuts down the instance completely and may move it to a new physical host.
- **Reboot** → Simply restarts the operating system without changing host hardware or configuration.

---

### ⚙️ Purpose / How It Works

#### 🟥 Stop/Start

- Stops the instance (like shutting down a computer).
- **Releases underlying hardware** and may allocate new hardware upon restart.
- The **instance ID, EBS data, and private IP** remain the same (EBS-backed).
- The **public IP** may change unless using an **Elastic IP**.
- Useful for patching, resizing, or applying new configurations.

#### 🔄 Reboot

- Performs a **soft restart of the OS**, similar to a “Restart” button.
- Instance stays on the **same host** — no hardware migration.
- The **public/private IPs, instance ID, and data** all remain unchanged.
- Used for **applying updates** or **restarting services** without full downtime.

---

### 📋 Comparison Table

| **Aspect**              | **Stop/Start**                        | **Reboot**                          |
| ----------------------- | ------------------------------------- | ----------------------------------- |
| **Action Type**         | Full shutdown and restart             | Soft restart of the OS              |
| **Hardware Change**     | Possible (new host assigned)          | None (same host retained)           |
| **Public IP**           | Changes (unless Elastic IP)           | Remains same                        |
| **Private IP**          | Retained                              | Retained                            |
| **Instance ID**         | Retained                              | Retained                            |
| **EBS Volumes**         | Preserved (EBS-backed only)           | Preserved                           |
| **Instance Store Data** | Lost                                  | Retained (if not rebooted via stop) |
| **Downtime**            | Higher                                | Minimal                             |
| **Use Case**            | Maintenance, resizing, host migration | OS-level restart, applying updates  |

---

### 🧩 Examples / Commands

#### ✅ Stop and Start

```bash
aws ec2 stop-instances --instance-ids i-0123456789abcdef0
aws ec2 start-instances --instance-ids i-0123456789abcdef0
```

#### ✅ Reboot

```bash
aws ec2 reboot-instances --instance-ids i-0123456789abcdef0
```

---

### ✅ Best Practices

- Use **Reboot** for quick restarts (OS-level maintenance).
- Use **Stop/Start** when:

  - Changing instance type or EBS settings.
  - Applying updates needing hardware reassignment.
  - Performing maintenance or recovering from host issues.

- Always use **Elastic IPs** if you need consistent public IPs after stop/start.
- Check for **instance-store data loss** before stopping instances.

---

### 💡 In short

- **Stop/Start** = Full shutdown → new host, possible new public IP, EBS data persists.
- **Reboot** = Soft restart → same host, IPs unchanged, minimal downtime.
  Use **Reboot** for quick fixes and **Stop/Start** for maintenance or configuration changes.

---

## Q: How Do You Schedule EC2 Start/Stop?

---

### 🧠 Overview

Scheduling **EC2 start/stop** helps reduce costs by running instances **only during specific hours** (e.g., business hours).
You can automate it using **AWS Lambda**, **EventBridge (CloudWatch Events)**, or **Instance Scheduler on AWS** (a managed solution).

---

### ⚙️ Purpose / How It Works

- **Goal:** Automatically start and stop EC2 instances at defined times (daily/weekly).
- **How:**

  - Create an **EventBridge rule** to trigger a **Lambda function**.
  - The Lambda function calls `start-instances` or `stop-instances` API for target EC2s.

- This approach helps **save costs** in non-production environments while maintaining flexibility.

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ 1. AWS CLI — Manual Start/Stop

```bash
# Stop instance
aws ec2 stop-instances --instance-ids i-0123456789abcdef0

# Start instance
aws ec2 start-instances --instance-ids i-0123456789abcdef0
```

---

#### ✅ 2. Using EventBridge + Lambda (Recommended)

##### **Step 1: Create Lambda Function**

**Example (Python 3.9):**

```python
import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    action = event.get('action', 'stop')  # default stop
    instances = ['i-0123456789abcdef0', 'i-0fedcba9876543210']

    if action == 'start':
        ec2.start_instances(InstanceIds=instances)
        print("Started instances:", instances)
    else:
        ec2.stop_instances(InstanceIds=instances)
        print("Stopped instances:", instances)
```

##### **Step 2: Add IAM Role to Lambda**

Attach a policy with:

```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:StartInstances",
    "ec2:StopInstances",
    "ec2:DescribeInstances"
  ],
  "Resource": "*"
}
```

##### **Step 3: Create EventBridge Rules**

- **Morning Rule (Start)**

  ```bash
  aws events put-rule --schedule-expression "cron(30 2 ? * MON-FRI *)" --name StartEC2Instances
  ```

  _(Starts at 08:00 AM IST)_

- **Evening Rule (Stop)**

  ```bash
  aws events put-rule --schedule-expression "cron(30 12 ? * MON-FRI *)" --name StopEC2Instances
  ```

  _(Stops at 06:00 PM IST)_

Attach the Lambda function as the **target** for both rules.

---

#### ✅ 3. Terraform Example

```hcl
resource "aws_cloudwatch_event_rule" "stop_rule" {
  name                = "stop-ec2"
  schedule_expression = "cron(30 12 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_target" "stop_target" {
  rule      = aws_cloudwatch_event_rule.stop_rule.name
  target_id = "stop-ec2"
  arn       = aws_lambda_function.ec2_scheduler.arn
}
```

---

### 📋 Options Comparison

| **Method**                            | **Ease**        | **Best For**        | **Notes**                         |
| ------------------------------------- | --------------- | ------------------- | --------------------------------- |
| **EventBridge + Lambda**              | ✅ Easy         | Small/medium setups | Fully serverless and customizable |
| **Instance Scheduler (AWS Solution)** | ✅✅ Simplified | Enterprise-scale    | Managed, tag-based scheduling     |
| **Systems Manager Automation**        | Moderate        | Custom workflows    | Uses SSM runbooks                 |
| **Custom Cron (on EC2)**              | ❌ Legacy       | Not recommended     | Adds maintenance overhead         |

---

### ✅ Best Practices

- Use **Instance Scheduler** for multi-account or tag-based scheduling.
- Always tag EC2s (e.g., `Schedule=OfficeHours`) for dynamic Lambda targeting.
- Test Lambda permissions using `dry-run`.
- Combine with **CloudWatch alarms** for cost visibility.
- Use **UTC time** in cron expressions and convert for your timezone (e.g., IST = UTC+5:30).

---

### 💡 In short

Schedule EC2 **start/stop** using **EventBridge + Lambda** or **AWS Instance Scheduler**.
It’s a cost-efficient way to power down non-prod instances automatically — saving compute costs while keeping control and flexibility.

---

## Q: How to Share Custom AMIs Between AWS Accounts?

---

### 🧠 Overview

A **custom Amazon Machine Image (AMI)** can be shared across AWS accounts to allow other users or teams to **launch EC2 instances** using the same pre-configured image.
Sharing is done by **modifying AMI launch permissions** and, if needed, **sharing associated snapshots**.

---

### ⚙️ Purpose / How It Works

By default, custom AMIs are **private** to the AWS account that created them.
To share an AMI:

1. Modify the **launch permissions** to include the target AWS account(s).
2. If the AMI uses **EBS snapshots**, those snapshots must also be shared.
3. The receiving account can then **copy** or **launch** instances from that shared AMI.

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ 1. Share AMI Using AWS CLI

```bash
aws ec2 modify-image-attribute \
  --image-id ami-0abcd1234efgh5678 \
  --launch-permission "Add=[{UserId=987654321012}]"
```

- Replace `987654321012` with the **target AWS Account ID**.

#### ✅ 2. Share the Underlying EBS Snapshot

```bash
aws ec2 modify-snapshot-attribute \
  --snapshot-id snap-0123abcd4567efgh8 \
  --attribute createVolumePermission \
  --operation-type add \
  --user-ids 987654321012
```

#### ✅ 3. Verify Shared Permissions

```bash
aws ec2 describe-image-attribute \
  --image-id ami-0abcd1234efgh5678 \
  --attribute launchPermission
```

#### ✅ 4. From Target Account — Copy Shared AMI

```bash
aws ec2 copy-image \
  --source-image-id ami-0abcd1234efgh5678 \
  --source-region us-east-1 \
  --name "copied-custom-ami"
```

---

### 📋 Sharing Options

| **Method**            | **Scope**                                 | **Use Case**                     |
| --------------------- | ----------------------------------------- | -------------------------------- |
| **Specific Account**  | Private sharing via Account ID            | Internal team or project sharing |
| **Public AMI**        | Shared with all AWS users                 | Community or open-source AMIs    |
| **Cross-Region Copy** | Copy AMI to another region before sharing | Multi-region deployments         |

---

### ⚙️ Notes on Permissions

- AMI sharing does **not include billing**; each account pays for its own usage.
- The AMI must use **EBS-backed snapshots** (not instance-store).
- Both AMI and snapshots must have **matching permissions**.
- Encrypted AMIs require **KMS key sharing** too:

  ```bash
  aws kms create-grant \
    --key-id <kms-key-id> \
    --grantee-principal arn:aws:iam::<target-account-id>:root \
    --operations Decrypt,DescribeKey
  ```

---

### ✅ Best Practices

- **Copy shared AMIs** into your own account before use for independence.
- Always **share via specific Account IDs**, not public, unless intended.
- Tag AMIs and snapshots for tracking (e.g., `SharedWith=Account12345`).
- Revoke permissions when access is no longer required.
- Use **KMS key grants** properly when sharing **encrypted** AMIs.

---

### 💡 In short

To share a custom AMI:

1. Add **launch permissions** for the target AWS account.
2. Share the **EBS snapshot(s)** and **KMS key (if encrypted)**.
3. The target account can **copy** or **launch** from that AMI.
   ✅ Simple, secure, and ideal for sharing pre-configured images across teams or environments.

---

## Q: How to Enforce Patch Compliance on EC2 Instances?

---

### 🧠 Overview

**Patch compliance** in EC2 ensures that all instances are **up-to-date with OS and application security patches**, minimizing exposure to CVEs and vulnerabilities.
AWS provides **Systems Manager (SSM) Patch Manager** and **AWS Inspector** to automate and monitor patch compliance across your fleet.

---

### ⚙️ Purpose / How It Works

- **SSM Patch Manager** automates the **scan, install, and compliance reporting** of OS and software patches.
- You define:

  - **Patch Baselines** → which patches to approve/deny
  - **Maintenance Windows** → when to apply patches
  - **Compliance Reporting** → view patch status in the SSM console

- Optionally integrate **AWS Inspector** to identify unpatched CVEs and trigger patch automation.

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ 1. Prerequisites

- EC2 instances must have:

  - **SSM Agent installed and running**
  - **IAM Role** attached with policy `AmazonSSMManagedInstanceCore`
  - **Outbound internet access** (or SSM VPC endpoints)

---

#### ✅ 2. Create a Patch Baseline

```bash
aws ssm create-patch-baseline \
  --name "AmazonLinux2Baseline" \
  --operating-system AMAZON_LINUX_2 \
  --approval-rules "PatchRules=[{PatchFilterGroup={PatchFilters=[{Key=CLASSIFICATION,Values=[Security]}]},ApproveAfterDays=3}]"
```

This baseline approves all **security patches** automatically after 3 days.

---

#### ✅ 3. Scan for Missing Patches

```bash
aws ssm send-command \
  --document-name "AWS-RunPatchBaseline" \
  --targets "Key=InstanceIds,Values=i-0123456789abcdef0" \
  --parameters '{"Operation":["Scan"]}'
```

---

#### ✅ 4. Install Patches

```bash
aws ssm send-command \
  --document-name "AWS-RunPatchBaseline" \
  --targets "Key=InstanceIds,Values=i-0123456789abcdef0" \
  --parameters '{"Operation":["Install"]}'
```

---

#### ✅ 5. Check Patch Compliance

```bash
aws ssm list-compliance-summaries
```

or in AWS Console → **Systems Manager → Compliance → Patch Compliance**

---

#### ✅ 6. Terraform Example (Attach SSM Role)

```hcl
resource "aws_iam_role" "ssm_role" {
  name = "EC2-SSM-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
```

---

### 📋 Compliance Integration Options

| **Tool**                     | **Purpose**                              | **Output**         |
| ---------------------------- | ---------------------------------------- | ------------------ |
| **SSM Patch Manager**        | Scans, installs, reports missing patches | Compliance summary |
| **AWS Inspector**            | Detects vulnerable software (CVE-based)  | Risk findings      |
| **AWS Config**               | Tracks configuration & compliance drift  | Compliance rules   |
| **CloudWatch + EventBridge** | Automates notifications & remediation    | Alerts             |

---

### ✅ Best Practices

- Use **Maintenance Windows** to patch during off-hours.
- Create **custom patch baselines** for critical workloads.
- Integrate **AWS Inspector** for CVE-based compliance validation.
- Use **SSM State Manager** to enforce continuous patching.
- Send compliance reports to **Security Hub** or **SNS** for visibility.
- Always test patches in **staging** before applying to production.

---

### 💡 In short

Enforce patch compliance using **AWS Systems Manager Patch Manager** — define baselines, scan, install, and monitor automatically.
Combine with **AWS Inspector** for CVE scanning and **AWS Config** for compliance tracking.
👉 Ensures EC2 fleet stays secure, compliant, and up to date — automatically.

---

## Q: How Do You Harden EC2 Instances?

---

### 🧠 Overview

**EC2 hardening** means securing your instances against unauthorized access, exploitation, and data compromise.
It involves applying **OS-level, network-level, and AWS-level** security best practices to reduce the attack surface and ensure compliance with frameworks like CIS, NIST, or ISO 27001.

---

### ⚙️ Purpose / How It Works

The goal of hardening EC2 is to:

- Prevent unauthorized access
- Enforce least privilege
- Protect data in transit and at rest
- Maintain secure configurations
  AWS provides multiple tools — **IAM roles, Security Groups, SSM, Inspector, GuardDuty, and Config** — to automate and enforce hardening controls.

---

### 🧩 Examples / Steps / Config Snippets

#### ✅ 1. Identity & Access Management (IAM)

- Use **IAM Roles** for EC2 instead of embedding AWS keys.
- Apply **least privilege** — attach only required policies.
- Rotate credentials automatically using **AWS Secrets Manager**.

```bash
aws iam create-role --role-name EC2-SSM-Role \
  --assume-role-policy-document file://trust-policy.json
```

---

#### ✅ 2. Network & Firewall Security

- Use **Security Groups** as stateful firewalls — allow only necessary ports (e.g., 22, 443).
- Restrict **SSH/RDP** to specific IPs or via Bastion/SSM Session Manager.
- Use **Network ACLs** for subnet-level restrictions.
- Deploy instances in **private subnets** where possible.

Example Security Group (restrictive):

```bash
aws ec2 authorize-security-group-ingress \
  --group-id sg-0123456789abcdef0 \
  --protocol tcp --port 22 --cidr 203.0.113.0/32
```

---

#### ✅ 3. OS & Patch Management

- Regularly **update OS and packages** using **AWS Systems Manager Patch Manager**.
- Enforce automatic patching and compliance scanning.
- Disable unused services and ports.

```bash
sudo yum update -y
sudo systemctl disable telnet
sudo systemctl stop telnet
```

---

#### ✅ 4. Data Protection

- Enable **EBS encryption** by default using AWS KMS.
- Use **encrypted AMIs** and **TLS/HTTPS** for in-transit data.
- Configure **disk encryption policies** via AWS Config rules.

Terraform example:

```hcl
resource "aws_ebs_volume" "secure_data" {
  size              = 50
  type              = "gp3"
  encrypted         = true
  kms_key_id        = "alias/myKMSKey"
  availability_zone = "us-east-1a"
}
```

---

#### ✅ 5. Access & Authentication Hardening

- Disable password-based SSH; use **key pairs** only.
- Rotate SSH keys regularly.
- Use **MFA** for privileged access.
- Leverage **SSM Session Manager** instead of open SSH ports.

```bash
aws ssm start-session --target i-0123456789abcdef0
```

---

#### ✅ 6. Monitoring & Logging

- Enable **CloudTrail**, **CloudWatch**, and **VPC Flow Logs**.
- Stream logs to **CloudWatch Logs** or **SIEM**.
- Use **GuardDuty** for continuous threat detection.
- Configure **AWS Config** to detect insecure changes (e.g., open ports).

---

#### ✅ 7. Vulnerability Management

- Enable **AWS Inspector** to automatically detect CVEs and insecure configurations.
- Use **Security Hub** to aggregate findings from multiple services.
- Remediate using **SSM Automation Documents (Runbooks)**.

---

#### ✅ 8. System-Level Hardening

- Enforce **file and process auditing** with tools like `auditd`.
- Disable root login and use `sudo` for admin actions.
- Limit cron jobs and background daemons.
- Enable host-based firewalls like `ufw` or `firewalld`.

```bash
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
```

---

### 📋 Hardening Checklist

| **Category**       | **Key Actions**                       | **AWS Tools**           |
| ------------------ | ------------------------------------- | ----------------------- |
| IAM & Access       | Use IAM roles, MFA, no static keys    | IAM, Secrets Manager    |
| Network            | Restrict ports, private subnets, WAF  | Security Groups, NACLs  |
| OS Security        | Patch, disable root login, audit logs | SSM Patch Manager       |
| Data Protection    | Encrypt at rest & transit             | KMS, EBS encryption     |
| Monitoring         | Enable logging & alerts               | CloudWatch, GuardDuty   |
| Vulnerability Mgmt | Scan for CVEs                         | Inspector, Security Hub |

---

### ✅ Best Practices

- Apply **CIS Benchmark for EC2** via AWS Security Hub or Inspector.
- Automate checks with **AWS Config Rules** and **SSM Compliance**.
- Enforce security at **AMI level** — build hardened golden images with **Packer**.
- Never expose **port 22/3389** directly — use Bastion or SSM.
- Regularly review logs and IAM access reports.

---

### 💡 In short

Harden EC2 by:

1. **Locking down access** (IAM, Security Groups, MFA)
2. **Patching & encrypting** systems and data
3. **Monitoring continuously** with AWS-native tools (SSM, Inspector, GuardDuty)
   It’s a layered defense approach — from OS to network to AWS-level controls — ensuring strong, auditable EC2 security posture.

---

## Q: What’s the Difference Between On-Demand, Reserved, and Spot Instances in EC2?

---

### 🧠 Overview

AWS EC2 offers multiple **pricing models** to optimize cost and flexibility based on workload type.
The main options are **On-Demand**, **Reserved**, and **Spot Instances**, each balancing **cost, commitment, and availability** differently.

---

### ⚙️ Purpose / How It Works

- **On-Demand** — Pay only for what you use (per second/hour), no commitment.
- **Reserved** — Commit for 1 or 3 years, get up to 72% discount.
- **Spot** — Bid for unused EC2 capacity at up to 90% discount, but can be interrupted anytime.

These models help optimize cost depending on whether your workloads are **steady**, **predictable**, or **fault-tolerant**.

---

### 📋 Comparison Table

| **Feature**           | **On-Demand**                       | **Reserved Instances (RI)**    | **Spot Instances**                     |
| --------------------- | ----------------------------------- | ------------------------------ | -------------------------------------- |
| **Pricing**           | Standard hourly rate                | Up to 72% cheaper              | Up to 90% cheaper                      |
| **Commitment**        | None                                | 1 or 3 years                   | None                                   |
| **Payment Options**   | Pay-as-you-go                       | All/Partial/No Upfront         | Variable (market-based)                |
| **Availability**      | Always available                    | Guaranteed capacity (if zonal) | Depends on spare capacity              |
| **Interruption Risk** | ❌ None                             | ❌ None                        | ⚠️ Can be terminated with 2-min notice |
| **Best For**          | Short-term, unpredictable workloads | Long-running, stable workloads | Fault-tolerant, flexible jobs          |
| **Examples**          | Dev/Test, bursts, short apps        | Web servers, DBs               | Batch jobs, CI/CD, ML training         |
| **Billing Unit**      | Per second (Linux)                  | Reserved capacity              | Variable (market rate)                 |

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ 1. Launch an On-Demand Instance

```bash
aws ec2 run-instances \
  --image-id ami-0abcd1234efgh5678 \
  --instance-type t3.medium \
  --count 1
```

#### ✅ 2. Purchase a Reserved Instance

```bash
aws ec2 purchase-reserved-instances-offering \
  --reserved-instances-offering-id 1234abcd-56ef-78gh-90ij-1234567890kl \
  --instance-count 1
```

#### ✅ 3. Request a Spot Instance

```bash
aws ec2 request-spot-instances \
  --spot-price "0.015" \
  --instance-count 1 \
  --launch-specification file://spot-spec.json
```

**spot-spec.json**

```json
{
  "ImageId": "ami-0abcd1234efgh5678",
  "InstanceType": "t3.large",
  "KeyName": "my-keypair"
}
```

---

### ⚙️ Example Use Cases

| **Use Case**              | **Recommended Instance Type** | **Reason**                                 |
| ------------------------- | ----------------------------- | ------------------------------------------ |
| CI/CD or build agents     | Spot                          | Cost-efficient for interruptible workloads |
| Web servers               | Reserved                      | Predictable load, always on                |
| Dev/Test environments     | On-Demand                     | Flexibility, short usage                   |
| Machine Learning training | Spot                          | High compute at low cost                   |
| Databases                 | Reserved                      | Consistent performance, long-term use      |

---

### ✅ Best Practices

- Use **Savings Plans** (modern alternative to Reserved Instances).
- Mix **Spot + On-Demand** in **Auto Scaling Groups** for cost-efficiency.
- Use **Spot Fleet** or **EC2 Fleet** for managing spot interruptions.
- Monitor **Spot Instance interruptions** using EventBridge.
- Periodically review usage and convert long-running workloads to **Reserved/Savings Plans**.

---

### 💡 In short

| **Model**        | **Key Idea**                             | **When to Use**                       |
| ---------------- | ---------------------------------------- | ------------------------------------- |
| 🟢 **On-Demand** | Pay per hour, full flexibility           | Unpredictable or short-term workloads |
| 🟣 **Reserved**  | Commit for 1–3 years, lower price        | Always-on, steady workloads           |
| 🔵 **Spot**      | Use spare AWS capacity at huge discounts | Fault-tolerant or batch workloads     |

💰 Combine all three — **On-Demand for base**, **Reserved for steady**, and **Spot for burst** — to achieve maximum **cost-efficiency and performance balance**.

---

## Q: How to Monitor CPU, Memory, and Disk Usage on EC2 Instances?

---

### 🧠 Overview

Monitoring **CPU, memory, and disk** metrics in EC2 ensures system performance, helps detect bottlenecks, and maintains SLA compliance.
AWS offers **CloudWatch** for system-level metrics and **CloudWatch Agent** for in-depth OS metrics (like memory, swap, and disk utilization).

---

### ⚙️ Purpose / How It Works

- **Default CloudWatch metrics** (via EC2) include:

  - CPU utilization
  - Network traffic
  - Disk read/write (for EBS)

- **Custom CloudWatch metrics** (via CloudWatch Agent) add:

  - Memory usage
  - Disk space & inode usage
  - Swap utilization

- Data is pushed to **CloudWatch**, where you can set **alarms, dashboards, and alerts**.

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ 1. Check Default Metrics (No Agent Needed)

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value=i-0123456789abcdef0 \
  --statistics Average \
  --period 300 \
  --start-time 2025-11-11T10:00:00Z \
  --end-time 2025-11-11T11:00:00Z
```

---

#### ✅ 2. Install and Configure CloudWatch Agent (for Memory/Disk)

```bash
sudo yum install -y amazon-cloudwatch-agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

Follow the wizard to select:

- **Metrics** → CPU, memory, disk, swap
- **Aggregation** → 1 or 5 minutes
- **Output** → CloudWatch

Then start the agent:

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
```

---

#### ✅ 3. Sample CloudWatch Agent Config (`config.json`)

```json
{
  "metrics": {
    "append_dimensions": {
      "InstanceId": "${aws:InstanceId}"
    },
    "metrics_collected": {
      "cpu": {
        "measurement": ["cpu_usage_idle", "cpu_usage_iowait"],
        "metrics_collection_interval": 60
      },
      "mem": {
        "measurement": ["mem_used_percent"],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": ["disk_used_percent"],
        "metrics_collection_interval": 60,
        "resources": ["*"]
      }
    }
  }
}
```

---

#### ✅ 4. Create a CloudWatch Alarm (Example: CPU > 80%)

```bash
aws cloudwatch put-metric-alarm \
  --alarm-name "HighCPUUtilization" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 300 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold \
  --dimensions Name=InstanceId,Value=i-0123456789abcdef0 \
  --evaluation-periods 2 \
  --alarm-actions arn:aws:sns:us-east-1:123456789012:NotifyOps
```

---

#### ✅ 5. View Metrics in AWS Console

Navigate to:
**CloudWatch → Metrics → EC2 → Per-Instance Metrics**
You can view:

- CPUUtilization
- DiskReadOps / DiskWriteOps
- NetworkIn / NetworkOut
- (With agent) Memory and Disk utilization

---

### 📋 Comparison of Monitoring Options

| **Metric**                 | **Source**       | **Agent Needed?** | **Namespace** |
| -------------------------- | ---------------- | ----------------- | ------------- |
| CPUUtilization             | EC2 native       | ❌ No             | `AWS/EC2`     |
| DiskReadOps / DiskWriteOps | EC2 native       | ❌ No             | `AWS/EC2`     |
| NetworkIn / Out            | EC2 native       | ❌ No             | `AWS/EC2`     |
| MemoryUtilization          | CloudWatch Agent | ✅ Yes            | `CWAgent`     |
| DiskSpaceUtilization       | CloudWatch Agent | ✅ Yes            | `CWAgent`     |
| Swap / Processes           | CloudWatch Agent | ✅ Yes            | `CWAgent`     |

---

### ✅ Best Practices

- Always install the **CloudWatch Agent** for complete visibility.
- Set **CloudWatch Alarms** for key thresholds (CPU > 80%, Mem > 75%).
- Use **CloudWatch Dashboards** for unified visibility.
- Integrate **SNS notifications** for alerts.
- Combine with **AWS Systems Manager** for automated remediation.
- Collect logs using **CloudWatch Logs Agent** for deeper analysis.

---

### 💡 In short

- **CPU** → Monitored by default via CloudWatch.
- **Memory & Disk** → Require **CloudWatch Agent**.
- Use **alarms + dashboards** for proactive monitoring.
  ✅ Combine metrics, logging, and SSM automation to keep EC2 performance and health fully observable.

---

## Q: How Do You Troubleshoot a Slow EC2 Instance?

---

### 🧠 Overview

Troubleshooting a **slow EC2 instance** involves identifying whether the performance issue originates from **compute, memory, disk, or network bottlenecks**.
AWS provides tools like **CloudWatch**, **SSM Agent**, **EC2 Instance Metadata**, and **VPC Flow Logs** to pinpoint root causes.

---

### ⚙️ Purpose / How It Works

You troubleshoot slow EC2 by checking in layers:

1. **Instance metrics** — CPU, memory, disk, network
2. **Application performance** — services, logs, and resource utilization
3. **AWS infrastructure** — EBS, networking, or hypervisor issues
4. **Configuration** — instance type, EBS IOPS, or Security Group rules

---

### 🧩 Step-by-Step Troubleshooting Guide

#### ✅ 1. Check CPU, Memory, and Disk Metrics

Use **CloudWatch** and **CloudWatch Agent**:

```bash
# Check CPU Utilization
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value=i-0123456789abcdef0 \
  --statistics Average --period 300 \
  --start-time 2025-11-11T10:00:00Z --end-time 2025-11-11T11:00:00Z
```

- High CPU → Use larger instance type or optimize app.
- Low CPU + high memory usage → Possible memory leak or swap pressure.

Install **CloudWatch Agent** for memory/disk metrics:

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
```

---

#### ✅ 2. Analyze System Processes (Inside Instance)

SSH or use SSM Session Manager:

```bash
# View top resource-consuming processes
top -o %CPU
# Check memory usage
free -m
# Disk I/O usage
sudo iostat -xz 1
# Check open file limits
ulimit -a
```

**Symptoms & Causes:**

| **Symptom**          | **Possible Cause**                    |
| -------------------- | ------------------------------------- |
| High CPU load        | App inefficiency, small instance size |
| High I/O wait        | Slow EBS, heavy read/write            |
| High memory          | Memory leak or insufficient RAM       |
| Swap usage           | Memory pressure                       |
| Load avg > CPU count | CPU saturation                        |

---

#### ✅ 3. Check EBS Volume Performance

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/EBS \
  --metric-name VolumeQueueLength \
  --dimensions Name=VolumeId,Value=vol-0abcd1234efgh5678 \
  --statistics Average --period 300
```

- High queue length → EBS throttling or small IOPS limit
- Consider switching to **gp3/io1** with provisioned IOPS

Example (increase IOPS):

```bash
aws ec2 modify-volume \
  --volume-id vol-0abcd1234efgh5678 \
  --iops 6000 --throughput 500
```

---

#### ✅ 4. Check Network Performance

```bash
sudo ethtool eth0       # View NIC speed/duplex
ping <target-ip>        # Test latency
sudo traceroute <ip>    # Check route hops
```

- Verify **Security Groups/NACLs** are not blocking critical ports.
- Enable **VPC Flow Logs** to inspect packet drops or latency.

---

#### ✅ 5. Review Logs

- **System Logs:** `/var/log/messages`, `/var/log/syslog`
- **Application Logs:** app-specific (e.g., `/var/log/nginx/`, `/var/log/httpd/`)
- **CloudWatch Logs:** integrated metrics and app logs

```bash
sudo tail -f /var/log/messages
```

Look for `OOM-killer`, disk errors, or network timeouts.

---

#### ✅ 6. Check for AWS Infrastructure or Host Issues

- In **AWS Console → EC2 → Status Checks Tab**

  - “System Status Check failed” → hardware or hypervisor issue
  - AWS Auto Recovery or Stop/Start may fix it

- Use **AWS Health Dashboard** for region-wide issues.

---

#### ✅ 7. Right-Size or Upgrade Instance

If consistently resource-constrained:

```bash
aws ec2 modify-instance-attribute \
  --instance-id i-0123456789abcdef0 \
  --instance-type "{\"Value\": \"t3.large\"}"
```

Or use **Compute Optimizer**:

```bash
aws compute-optimizer get-ec2-instance-recommendations
```

---

#### ✅ 8. Test with Benchmark Tools

- **CPU:** `stress-ng --cpu 4 --timeout 60`
- **Disk:** `fio --name=test --size=1G --rw=randwrite --bs=4k`
- **Network:** `iperf3 -c <server-ip>`

These identify performance ceilings vs instance specs.

---

### 📋 Common Root Causes

| **Category** | **Typical Issue**           | **Resolution**                  |
| ------------ | --------------------------- | ------------------------------- |
| CPU          | Overloaded instance         | Resize or optimize code         |
| Memory       | Leak or swap usage          | Patch app or increase RAM       |
| Disk         | High IOPS demand            | Switch to gp3/io1               |
| Network      | High latency or packet loss | Check SGs, use placement groups |
| AWS Host     | Underlying issue            | Auto Recovery or Stop/Start     |

---

### ✅ Best Practices

- Enable **CloudWatch Agent + Alarms** for CPU/memory/disk thresholds.
- Use **Auto Scaling** for elastic performance.
- Keep OS and packages patched.
- Avoid running multiple heavy processes on small instances.
- Regularly review **AWS Compute Optimizer** recommendations.
- Implement **performance dashboards** in CloudWatch or Grafana.

---

### 💡 In short

Troubleshoot slow EC2 by analyzing **CloudWatch metrics**, **system processes**, **EBS/Network performance**, and **AWS status checks**.
Use **CloudWatch Agent + SSM** for deep insight, and **resize or optimize** based on findings — ensuring stable, cost-efficient performance.

---

## Q: How Do You Create a Golden AMI (Image) for Auto Scaling in EC2?

---

### 🧠 Overview

A **Golden AMI** (Amazon Machine Image) is a **pre-hardened, pre-configured base image** that includes your application, dependencies, monitoring agents, and security patches — ready for deployment in **Auto Scaling Groups (ASGs)** or **EC2 fleets**.
It ensures consistent, secure, and fast instance launches across environments (Dev → Prod).

---

### ⚙️ Purpose / How It Works

Golden AMIs eliminate the need to configure software on boot.
Instead, you **bake everything into the AMI** once, then reuse it for Auto Scaling.
This drastically **reduces launch time**, **improves reliability**, and **standardizes configurations**.

**Golden AMI Lifecycle:**

1. Launch base instance
2. Install patches, apps, and configurations
3. Harden & test
4. Create AMI from it
5. Reference AMI in Launch Template / Auto Scaling Group

---

### 🧩 Step-by-Step — Creating a Golden AMI

#### ✅ 1. Launch a Base EC2 Instance

- Start from a clean, latest OS image (e.g., Amazon Linux 2, Ubuntu).
- Choose instance type suitable for setup tasks.
- Attach IAM Role (for SSM, CloudWatch, etc.).

```bash
aws ec2 run-instances \
  --image-id ami-0abcd1234efgh5678 \
  --instance-type t3.medium \
  --key-name my-keypair \
  --security-group-ids sg-0123456789abcdef0
```

---

#### ✅ 2. Configure the Instance

Install application dependencies, patches, and security tools:

```bash
sudo yum update -y
sudo yum install -y nginx docker amazon-cloudwatch-agent
sudo systemctl enable nginx docker
sudo systemctl start nginx docker
```

Add monitoring and logging:

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start
```

---

#### ✅ 3. Harden the Instance (Security Baseline)

- Disable root SSH, enforce key-based login.
- Patch OS vulnerabilities.
- Apply CIS hardening scripts.
- Configure log rotation and agent heartbeat.
- Clean sensitive data (e.g., `/home/ec2-user/.ssh/authorized_keys`).

---

#### ✅ 4. Create AMI from the Instance

```bash
aws ec2 create-image \
  --instance-id i-0123456789abcdef0 \
  --name "golden-ami-v1.0" \
  --description "Base AMI with Nginx, CloudWatch agent, and Docker"
```

The AMI ID (e.g., `ami-0a1b2c3d4e5f6g7h8`) will be used in your **Launch Template**.

---

#### ✅ 5. Test the AMI

- Launch a test EC2 using the AMI.
- Verify application, logs, monitoring, and agents start automatically.
- Ensure no hardcoded environment configs or credentials remain.

---

#### ✅ 6. Use AMI in Auto Scaling Group (ASG)

Create a **Launch Template** using your Golden AMI:

```bash
aws ec2 create-launch-template \
  --launch-template-name webserver-template \
  --version-description "v1" \
  --launch-template-data '{
    "ImageId": "ami-0a1b2c3d4e5f6g7h8",
    "InstanceType": "t3.micro",
    "SecurityGroupIds": ["sg-0123456789abcdef0"],
    "IamInstanceProfile": {"Name": "EC2-SSM-Role"}
  }'
```

Then link it to your **Auto Scaling Group**:

```bash
aws autoscaling create-auto-scaling-group \
  --auto-scaling-group-name web-asg \
  --launch-template "LaunchTemplateName=webserver-template,Version=1" \
  --min-size 2 --max-size 5 --desired-capacity 3 \
  --vpc-zone-identifier "subnet-abc123,subnet-def456"
```

---

### 📋 Tools for AMI Automation

| **Tool**                    | **Purpose**                      | **Use Case**                           |
| --------------------------- | -------------------------------- | -------------------------------------- |
| **HashiCorp Packer**        | Automate AMI creation            | CI/CD AMI baking pipelines             |
| **AWS EC2 Image Builder**   | Managed AMI pipeline service     | Compliance & versioned AMIs            |
| **Ansible / Chef / Puppet** | Configuration management         | Hardening and setup during image build |
| **SSM Automation**          | Patching and snapshot automation | Scheduled AMI refresh                  |

---

### ✅ Best Practices

- Tag AMIs with version, environment, and creation date:
  `Name=golden-ami-v1.0, Env=Prod, Owner=DevOps`
- Automate builds via **Packer or EC2 Image Builder**.
- Regularly **rebuild AMIs** (monthly or per patch cycle).
- Store AMIs in a **central account** and share across environments.
- Clean temporary files and logs before creating AMI.
- Test AMI in **staging** before deploying in ASG.

---

### 💡 In short

A **Golden AMI** is a reusable, hardened, and pre-configured EC2 image used in Auto Scaling for fast, consistent deployments.
Create once → Bake configs → Test → Use in Launch Template.
✅ Automate with **Packer or EC2 Image Builder** for secure, versioned image pipelines.

---

## Q: How Do You Encrypt EBS Volumes in AWS?

---

### 🧠 Overview

**Amazon EBS encryption** protects data at rest by automatically encrypting your **EBS volumes, snapshots, and their data-in-transit** between EC2 instances and EBS.
Encryption is handled by **AWS Key Management Service (KMS)** using **AES-256** encryption, with **no performance impact** or app changes required.

---

### ⚙️ Purpose / How It Works

- Encryption occurs **at the storage layer** — fully managed by AWS.
- It encrypts:

  - Data at rest (on the EBS volume)
  - Data in transit (between EC2 and EBS)
  - Snapshots created from the volume

- Managed by **KMS Customer Master Keys (CMKs)** (default or custom).
- You can **enable encryption by default** at the account or region level.

---

### 🧩 Examples / Commands / Config Snippets

#### ✅ 1. Encrypt a New EBS Volume (AWS CLI)

```bash
aws ec2 create-volume \
  --availability-zone us-east-1a \
  --size 50 \
  --encrypted \
  --kms-key-id arn:aws:kms:us-east-1:123456789012:key/abcd1234-5678-90ef-ghij-klmn98765432
```

#### ✅ 2. Encrypt an Existing Unencrypted Volume

You **can’t encrypt in place** — must create an **encrypted copy**:

```bash
# Step 1: Create a snapshot of the unencrypted volume
aws ec2 create-snapshot --volume-id vol-0123456789abcdef0 --description "unencrypted snapshot"

# Step 2: Copy snapshot with encryption
aws ec2 copy-snapshot \
  --source-region us-east-1 \
  --source-snapshot-id snap-0123abcd4567efgh8 \
  --encrypted \
  --kms-key-id arn:aws:kms:us-east-1:123456789012:key/abcd1234-5678-90ef-ghij-klmn98765432

# Step 3: Create a new encrypted volume from the encrypted snapshot
aws ec2 create-volume \
  --snapshot-id snap-0abcd1234efgh5678 \
  --availability-zone us-east-1a \
  --encrypted
```

Then **detach the old volume** and **attach the new encrypted one**:

```bash
aws ec2 detach-volume --volume-id vol-0123456789abcdef0
aws ec2 attach-volume --volume-id vol-0abcd1234efgh5678 --instance-id i-0123abcd4567efgh8 --device /dev/xvdf
```

---

#### ✅ 3. Enable Encryption by Default (Account-Level)

```bash
aws ec2 enable-ebs-encryption-by-default
```

Verify:

```bash
aws ec2 get-ebs-encryption-by-default
```

Now all new volumes and snapshots are automatically encrypted.

---

#### ✅ 4. Terraform Example

```hcl
resource "aws_ebs_volume" "secure_data" {
  availability_zone = "us-east-1a"
  size              = 100
  encrypted         = true
  kms_key_id        = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-5678-90ef-ghij-klmn98765432"
  tags = {
    Name = "secure-data-volume"
  }
}
```

---

### 📋 Key Concepts

| **Feature**            | **Description**                                                   |
| ---------------------- | ----------------------------------------------------------------- |
| **Encryption Scope**   | Data at rest, in transit, and snapshots                           |
| **KMS Key Options**    | AWS-managed key (`aws/ebs`) or customer-managed CMK               |
| **Default Encryption** | Can be enabled per account/region                                 |
| **Performance Impact** | None (hardware acceleration)                                      |
| **Copy Behavior**      | Encrypted → Encrypted; Unencrypted → must copy with `--encrypted` |

---

### ✅ Best Practices

- **Enable EBS encryption by default** for all new volumes.
- Use **custom KMS CMKs** for compliance or audit control.
- Regularly **rotate CMKs** via AWS KMS key policies.
- **Encrypt snapshots and AMIs** that contain sensitive data.
- Use **IAM policies** to restrict who can disable encryption.
- Monitor compliance with **AWS Config rule: `ebs-encryption-by-default-enabled`**.

---

### 💡 In short

Encrypt EBS volumes using AWS-managed or custom KMS keys.

- Use `--encrypted` when creating or copying volumes.
- Enable **default encryption** for full coverage.
  ✅ Ensures all EC2 storage is secure at rest and in transit with **zero performance overhead**.

---

# Scenario Questions

## Q: How Do You Troubleshoot EC2 Unreachable via SSH?

---

### 🧠 Overview

When an EC2 instance becomes **unreachable via SSH**, it usually indicates issues with **network configuration**, **firewall rules**, **SSH keys**, or **instance-level problems** (like OS boot or CPU/memory lock).
This guide helps you systematically identify and fix SSH connectivity issues for Linux-based EC2 instances.

---

### ⚙️ Purpose / How It Works

SSH access to EC2 relies on:

1. **Networking** — Correct VPC, Subnet, Route Table, Internet Gateway, Elastic IP
2. **Security** — Proper Security Group, NACL, and IAM permissions
3. **Instance OS** — SSH service running, key pair valid, no disk or OS corruption

When any layer fails, SSH (`port 22`) becomes unreachable.

---

### 🧩 Step-by-Step Troubleshooting Guide

#### ✅ 1. Check EC2 Status

- **System Status Check:** Infrastructure (AWS host/hypervisor)
- **Instance Status Check:** OS-level (boot/SSH daemon)

```bash
aws ec2 describe-instance-status --instance-ids i-0123456789abcdef0
```

- If “System Status Check” fails → Try **Stop/Start** (hardware issue).
- If “Instance Status Check” fails → OS or configuration problem.

---

#### ✅ 2. Verify Network Reachability

**a. Ensure Instance Has a Public IP**

```bash
aws ec2 describe-instances --instance-ids i-0123456789abcdef0 --query "Reservations[*].Instances[*].PublicIpAddress"
```

If no public IP →

- Assign an **Elastic IP**
- Or connect via **SSM Session Manager** if in a private subnet.

**b. Check Route Table**

- Subnet must have route to Internet Gateway (`0.0.0.0/0 → igw-xxxxxx`)

**c. Security Group Rules**

```bash
aws ec2 describe-security-groups --group-ids sg-0123456789abcdef0
```

Inbound rule must allow:

| **Type** | **Protocol** | **Port** | **Source**                     |
| -------- | ------------ | -------- | ------------------------------ |
| SSH      | TCP          | 22       | Your IP (e.g., 203.0.113.0/32) |

**d. Network ACLs**

- Inbound: Allow TCP port 22
- Outbound: Allow ephemeral ports (1024–65535)

---

#### ✅ 3. Verify Local SSH Command & Key

**a. Command Example**

```bash
ssh -i my-key.pem ec2-user@<public-ip>
```

**b. Check File Permissions**

```bash
chmod 400 my-key.pem
```

**c. Wrong Key or Username**

- Amazon Linux → `ec2-user`
- Ubuntu → `ubuntu`
- CentOS → `centos`
- RedHat → `ec2-user`

---

#### ✅ 4. Check OS-Level Issues via AWS SSM or Console

If **no SSH but SSM works**, use:

```bash
aws ssm start-session --target i-0123456789abcdef0
```

Then:

```bash
sudo systemctl status sshd
sudo systemctl start sshd
sudo tail -n 20 /var/log/secure
```

If SSH service is disabled or misconfigured, re-enable:

```bash
sudo systemctl enable sshd
sudo systemctl restart sshd
```

If SSM is not enabled, use **EC2 Instance Console Screenshot** (from AWS Console → Monitor → Get Screenshot) to check if OS is stuck on boot.

---

#### ✅ 5. Recover Access Using a Rescue Instance (if SSH completely fails)

1. **Stop** the unreachable instance (don’t terminate).
2. **Detach its root EBS volume**:

   ```bash
   aws ec2 detach-volume --volume-id vol-0abcd1234efgh5678
   ```

3. **Attach to another healthy EC2** as a secondary volume.
4. Mount and fix SSH configs:

   ```bash
   sudo mkdir /mnt/rescue
   sudo mount /dev/xvdf1 /mnt/rescue
   sudo vi /mnt/rescue/etc/ssh/sshd_config
   sudo vi /mnt/rescue/home/ec2-user/.ssh/authorized_keys
   ```

5. **Unmount and reattach** the volume to the original instance.
6. **Start** the original instance and try connecting again.

---

### 📋 Common Root Causes

| **Category**   | **Issue**                        | **Resolution**                        |
| -------------- | -------------------------------- | ------------------------------------- |
| Network        | Missing IGW / Private Subnet     | Add public IP or use SSM              |
| Security Group | Port 22 not open                 | Allow TCP/22 from your IP             |
| NACL           | Port 22 blocked inbound/outbound | Adjust NACL rules                     |
| SSH Key        | Wrong or corrupt key             | Use correct `.pem`                    |
| OS             | `sshd` service stopped           | Restart or fix via SSM/rescue         |
| Disk           | Full root volume                 | Extend or clean `/var`                |
| IAM            | SSM permissions missing          | Attach `AmazonSSMManagedInstanceCore` |

---

### ✅ Best Practices

- Use **SSM Session Manager** for bastion-less secure access.
- Restrict SSH access to specific IPs (never `0.0.0.0/0`).
- Always use **Elastic IPs** for static public connectivity.
- Enable **CloudWatch + Config** to monitor changes to SGs/NACLs.
- Regularly snapshot volumes for quick rollback if config breaks.

---

### 💡 In short

If EC2 is **unreachable via SSH**:

1. ✅ Check **network (public IP, SG, route table)**
2. ⚙️ Validate **SSH key & username**
3. 🔍 Use **SSM or rescue volume** to inspect and repair OS
4. 💪 Automate access monitoring with CloudWatch/Config

🧩 **Tip:** For long-term security and reliability, migrate from SSH to **AWS SSM Session Manager** — no keys, no open ports, no headaches.

---

## Q: How Do You Fix a Full Root Volume on an EC2 Instance?

---

### 🧠 Overview

A **full root volume** means your EC2 instance’s primary EBS disk (`/` or `/dev/xvda`) has **run out of space**, causing issues like:

- SSH login failures
- Service crashes (nginx, docker, journald)
- “No space left on device” errors

You can fix this by **freeing space** or **expanding the root volume** safely.

---

### ⚙️ Purpose / How It Works

The root volume is an **EBS-backed block device** mounted as `/`.
When it’s full, the OS can’t write to logs or swap — even SSH may fail.
You can:

1. Free up space by removing unused files/logs.
2. Or expand the root EBS volume size and resize the filesystem.

---

### 🧩 Step-by-Step Fix

#### ✅ 1. Check Disk Usage

Once inside (via SSH or **SSM Session Manager**):

```bash
df -h
```

Example output:

```
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1       8G   8G     0 100% /
```

Identify space hogs:

```bash
sudo du -h --max-depth=1 / | sort -hr | head -10
```

Look inside heavy directories:

```bash
sudo du -sh /var/log/*
sudo du -sh /var/cache/*
sudo du -sh /tmp/*
```

---

#### ✅ 2. Clean Up Unnecessary Files

```bash
# Clear system logs
sudo journalctl --vacuum-time=3d
sudo rm -rf /var/log/*.gz /var/log/*.[0-9]

# Clean YUM/DNF cache
sudo yum clean all

# Remove old packages
sudo package-cleanup --oldkernels --count=1

# Clear temp directories
sudo rm -rf /tmp/* /var/tmp/*
```

If using **Docker**:

```bash
docker system prune -af
```

If using **Jenkins**:

```bash
sudo rm -rf /var/lib/jenkins/workspace/*
```

---

#### ✅ 3. Expand the Root EBS Volume (if cleanup isn’t enough)

**Step 1: Check current volume**

```bash
lsblk
```

**Step 2: Modify volume size**

```bash
aws ec2 modify-volume \
  --volume-id vol-0123456789abcdef0 \
  --size 30
```

(Example increases from 8 GB → 30 GB)

Check progress:

```bash
aws ec2 describe-volumes-modifications --volume-id vol-0123456789abcdef0
```

**Step 3: Resize filesystem (after AWS expansion completes)**
For Amazon Linux 2, Ubuntu (XFS/ext4):

```bash
sudo growpart /dev/xvda 1
sudo resize2fs /dev/xvda1      # for ext4
# or
sudo xfs_growfs -d /           # for XFS
```

Verify:

```bash
df -h
```

---

#### ✅ 4. (If Instance Is Unreachable)

If volume is full and SSH doesn’t work:

1. Stop the instance.
2. Detach root EBS volume.
3. Attach it to another EC2 as a secondary volume.
4. Mount and clean up manually:

   ```bash
   sudo mkdir /mnt/rescue
   sudo mount /dev/xvdf1 /mnt/rescue
   sudo du -sh /mnt/rescue/*
   sudo rm -rf /mnt/rescue/var/log/*
   ```

5. Detach and reattach to the original instance, then start it.

---

### 📋 Common Disk Fillers

| **Location**      | **Cause**             | **Action**            |
| ----------------- | --------------------- | --------------------- |
| `/var/log`        | Log accumulation      | Rotate or vacuum logs |
| `/var/lib/docker` | Old containers/images | `docker system prune` |
| `/tmp`            | Temporary build files | Clear regularly       |
| `/home/ec2-user`  | Large downloads       | Delete unused files   |
| `/var/cache/yum`  | Package cache         | `yum clean all`       |

---

### ✅ Best Practices

- Enable **CloudWatch Disk Utilization metrics** (via CloudWatch Agent).
- Implement **log rotation** (`logrotate.conf`, journald cleanup).
- Keep root volume ≥ 20 GB for OS + logs.
- Store app data on **separate EBS volumes**.
- Create **snapshot backups** before cleanup or resize.
- Monitor **`EBS VolumeUtilization`** in CloudWatch alarms.

---

### 💡 In short

If the **root volume is full**:

1. 🧹 Clean logs and temp files.
2. 📈 Expand volume with `modify-volume` + `growpart`.
3. 🧯 If locked out, mount via rescue instance to clean manually.
   ✅ Prevent it by monitoring disk space and separating app data from `/`.

---

## Q: EC2 Rebooted Unexpectedly — How to Diagnose & Fix It

---

### 🧠 Overview

An **unexpected EC2 reboot** can occur due to **AWS infrastructure events**, **kernel panics**, **resource exhaustion**, or **manual/automated triggers** (like patching or SSM actions).
The goal is to determine **who or what caused the reboot** — AWS, the OS, or user automation — and **prevent recurrence**.

---

### ⚙️ Purpose / How It Works

EC2 instances can reboot in three broad categories:

1. 🟢 **Planned AWS maintenance** (e.g., host replacement)
2. 🟠 **Unplanned hardware/OS crash** (e.g., kernel panic, OOM)
3. 🔵 **Intentional reboot** (manual or automation like SSM, CloudWatch, or patch manager)

The instance **retains its instance ID and IP**, unlike a stop/start event.

---

### 🧩 Step-by-Step Troubleshooting Guide

#### ✅ 1. Check System Logs for Reboot Cause

Once the instance is back online:

```bash
# View recent reboots
last -x | head -10

# Check kernel messages around reboot time
sudo dmesg -T | grep -i "panic"
sudo dmesg -T | grep -i "oom"

# Review system logs
sudo grep -i "reboot" /var/log/messages
sudo grep -i "panic" /var/log/messages
sudo grep -i "kernel" /var/log/syslog
```

**Common signs:**

- `Kernel panic` → OS or driver issue
- `Out of memory: Kill process` → RAM exhaustion
- `Rebooted by EC2 system` → AWS infrastructure or automation

---

#### ✅ 2. Verify if AWS Initiated the Reboot

Check **EC2 Events** and **AWS Health Dashboard**:

```bash
aws ec2 describe-instance-status \
  --instance-ids i-0123456789abcdef0 \
  --query "InstanceStatuses[*].Events"
```

If output shows:

```
"Code": "system-reboot" or "instance-reboot"
```

→ AWS initiated the reboot (e.g., host maintenance or patching).

Also check the **Personal Health Dashboard (PHD)** in AWS Console:

> AWS Console → Health → Event Log → Affected Resources

If the event is listed there → AWS maintenance.

---

#### ✅ 3. Check if a User or Automation Triggered It

Use **CloudTrail**:

```bash
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=RebootInstances \
  --max-results 10
```

Output shows who initiated the reboot:

```
"userIdentity": {"arn": "arn:aws:iam::123456789012:user/devops-admin"},
"eventTime": "2025-11-11T18:32:15Z"
```

If initiated by `ssm.amazonaws.com` or `autoscaling.amazonaws.com`, it’s automated (e.g., patch manager or ASG health check).

---

#### ✅ 4. Check Auto Scaling or Health Checks

If your instance is part of an **Auto Scaling Group (ASG)**:

- It may reboot or **replace unhealthy instances** automatically.

```bash
aws autoscaling describe-auto-scaling-instances \
  --instance-ids i-0123456789abcdef0
```

If `LifecycleState` changed → ASG replaced/rebooted due to failed health check.

---

#### ✅ 5. Check for Resource Exhaustion (CPU, Memory, Disk)

Use **CloudWatch metrics**:

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value=i-0123456789abcdef0 \
  --start-time $(date -u -d '-1 hour' +%Y-%m-%dT%H:%M:%SZ) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%SZ) \
  --period 60 --statistics Maximum
```

Also monitor:

- `mem_used_percent` (via CloudWatch Agent)
- Disk I/O spikes
- Kernel OOM events (`/var/log/messages`)

---

#### ✅ 6. Check for OS-Level Auto Updates or Maintenance Agents

Some images (e.g., Amazon Linux) enable automatic updates:

```bash
sudo cat /etc/yum/yum-cron.conf | grep apply_updates
```

If set to `yes`, OS updates may trigger auto reboot.

Also verify:

```bash
crontab -l
sudo systemctl list-timers | grep reboot
```

To disable auto reboots:

```bash
sudo systemctl disable yum-cron
```

---

#### ✅ 7. Enable Auto Recovery (for Future Protection)

If reboots are due to AWS hardware issues, enable **Auto Recovery**:

```bash
aws cloudwatch put-metric-alarm \
  --alarm-name "EC2AutoRecovery" \
  --metric-name StatusCheckFailed_System \
  --namespace AWS/EC2 \
  --statistic Maximum --period 60 --threshold 1 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --evaluation-periods 2 \
  --alarm-actions arn:aws:automate:us-east-1:ec2:recover \
  --dimensions Name=InstanceId,Value=i-0123456789abcdef0
```

---

### 📋 Root Cause Summary

| **Category**     | **Example Trigger**               | **Resolution**                                  |
| ---------------- | --------------------------------- | ----------------------------------------------- |
| AWS Maintenance  | Host replacement, hardware issue  | Auto recovery or migrate instance               |
| Kernel Panic     | OS bug, driver crash              | Update kernel, review `/var/log/dmesg`          |
| Out of Memory    | Memory leak, large process        | Optimize app, add swap or resize instance       |
| User Error       | Manual reboot or CI/CD automation | Audit via CloudTrail                            |
| Auto Scaling     | Health check failure              | Tune health check grace periods                 |
| Patch Automation | SSM patch cycle                   | Disable “Reboot if required” or schedule better |

---

### ✅ Best Practices

- Enable **CloudTrail**, **CloudWatch Logs**, and **AWS Config** to trace reboots.
- Regularly apply **kernel updates** to prevent panics.
- Use **SSM Agent** + **CloudWatch Agent** for memory/disk metrics.
- Schedule patching during maintenance windows.
- Enable **Auto Recovery** for mission-critical instances.
- Use **ASGs or Load Balancers** for redundancy if reboots impact uptime.

---

### 💡 In short

If EC2 **rebooted unexpectedly**:

1. 🔍 Check **system logs** → kernel panic, OOM, or reboot logs
2. ☁️ Check **AWS events or CloudTrail** → maintenance or user action
3. 🧰 Check **CloudWatch metrics** → CPU, memory, disk anomalies
4. 🛠️ Mitigate → enable Auto Recovery, patch kernel, and monitor with alarms

✅ Combine **CloudWatch + CloudTrail + SSM** for full visibility and automated self-healing against unexpected reboots.

---

## Q: Can’t Attach EBS Volume to EC2 — How to Diagnose & Fix It

---

### 🧠 Overview

If you can’t attach an **Amazon EBS volume** to an EC2 instance, it usually means there’s a **configuration mismatch, state issue, or permission restriction**.
Common causes include **different Availability Zones**, **incorrect volume state**, or **IAM/Snapshot policy limitations**.

---

### ⚙️ Purpose / How It Works

EBS volumes are **AZ-bound** resources — they can only attach to EC2 instances **in the same Availability Zone**.
When you attach a volume, AWS:

1. Validates the **volume state** (`available`)
2. Confirms **zone compatibility**
3. Applies **IAM and encryption (KMS)** permissions
   If any check fails, the operation is blocked.

---

### 🧩 Step-by-Step Troubleshooting Guide

#### ✅ 1. Check Volume and Instance State

```bash
aws ec2 describe-volumes --volume-ids vol-0123456789abcdef0 \
  --query "Volumes[*].{ID:VolumeId,State:State,AZ:AvailabilityZone,Attached:Attachments}"
```

Output Example:

```
ID: vol-0123456789abcdef0
State: in-use
AZ: us-east-1a
Attached: []
```

**Fix:**

- Volume must be in **`available`** state to attach.
- If it’s still **`in-use`**, detach it first:

  ```bash
  aws ec2 detach-volume --volume-id vol-0123456789abcdef0
  ```

---

#### ✅ 2. Ensure Volume and Instance Are in the Same Availability Zone

```bash
aws ec2 describe-instances --instance-ids i-0123456789abcdef0 \
  --query "Reservations[*].Instances[*].Placement.AvailabilityZone"
```

Example:

```
Instance AZ: us-east-1b
Volume AZ:   us-east-1a
```

**Fix:**
EBS volumes cannot be moved across AZs directly — you must **create a snapshot and restore it in the target AZ**:

```bash
# Create snapshot
aws ec2 create-snapshot --volume-id vol-0123456789abcdef0 --description "Copy for us-east-1b"

# Create new volume from snapshot in correct AZ
aws ec2 create-volume --availability-zone us-east-1b --snapshot-id snap-0123abcd4567efgh8
```

---

#### ✅ 3. Check IAM Permissions

Your IAM role or user must have:

```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:AttachVolume",
    "ec2:DescribeInstances",
    "ec2:DescribeVolumes",
    "ec2:DetachVolume"
  ],
  "Resource": "*"
}
```

If using **encrypted volumes**, also ensure:

- Permission to use the **KMS key** (`kms:Decrypt`, `kms:CreateGrant`).
- The **KMS key policy** allows your IAM principal and the EC2 service.

---

#### ✅ 4. Check for Encryption Conflicts

If the volume is **encrypted with a customer-managed KMS key**, ensure:

- The instance’s IAM role can access that key.
- The key is in the **same region**.
- Key policy includes:

```json
{
  "Effect": "Allow",
  "Principal": { "AWS": "arn:aws:iam::123456789012:role/EC2Role" },
  "Action": "kms:*",
  "Resource": "*"
}
```

If you see:

```
Client.UnauthorizedOperation: You are not authorized to perform this operation
```

→ It’s usually a **KMS or IAM permission** issue.

---

#### ✅ 5. Check Device Name Collision

Each Linux instance supports limited device names like `/dev/xvda` → `/dev/xvdz`.
If a device is already used, attachment fails.
Check:

```bash
lsblk
```

When attaching, pick an unused device name:

```bash
aws ec2 attach-volume \
  --volume-id vol-0123456789abcdef0 \
  --instance-id i-0123456789abcdef0 \
  --device /dev/xvdf
```

---

#### ✅ 6. Confirm Volume Type Compatibility

- Some instance types (e.g., **i3, d2**) use **NVMe or instance-store** and cannot attach standard EBS volumes.
- Check instance EBS support:

  ```bash
  aws ec2 describe-instance-types --instance-types t3.large --query "InstanceTypes[*].EbsInfo"
  ```

---

#### ✅ 7. Look for Pending Attachments

If multiple attach requests were made, the volume may be “stuck”.
Detach forcefully:

```bash
aws ec2 detach-volume --volume-id vol-0123456789abcdef0 --force
```

Wait a few seconds, then retry attachment.

---

#### ✅ 8. Review CloudTrail for Errors

If attachment fails silently, check logs:

```bash
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=ResourceName,AttributeValue=vol-0123456789abcdef0
```

This shows **who** tried to attach, and any **policy denials or region mismatch** errors.

---

### 📋 Common Root Causes

| **Cause**                        | **Symptom**                                                    | **Fix**                                    |
| -------------------------------- | -------------------------------------------------------------- | ------------------------------------------ |
| Volume in another AZ             | “InvalidParameter: Volume and instance must be in the same AZ” | Create new volume from snapshot in same AZ |
| Volume not in `available` state  | “VolumeInUse”                                                  | Detach or wait for it to become available  |
| KMS key permission issue         | UnauthorizedOperation                                          | Update IAM and KMS key policy              |
| Wrong device name                | Device already used                                            | Use `/dev/xvdf` or higher                  |
| IAM policy restriction           | AccessDenied                                                   | Grant `ec2:AttachVolume` permissions       |
| Instance type not EBS-compatible | Attach silently fails                                          | Verify instance supports EBS               |

---

### ✅ Best Practices

- Always tag volumes (e.g., `Name=AppData`, `Env=Prod`) for quick identification.
- Enable **EBS encryption by default**.
- Keep **snapshots** before major changes.
- Use **AWS Config rule `ebs-in-same-az-as-instance`** for compliance.
- For automation, validate AZ compatibility before attachment in scripts.

---

### 💡 In short

If an EBS volume can’t attach:

1. ✅ Verify **same AZ**
2. ⚙️ Ensure **volume state = available**
3. 🔒 Check **IAM & KMS key permissions**
4. 🧩 Use a unique **device name**
5. 💡 Recreate volume from **snapshot** if zone mismatch

✅ Root cause: 90% of failures come from **different Availability Zones** or **KMS/IAM permission errors**.

---

## Q: EC2 Instance in Boot Loop — How to Diagnose & Fix

---

### 🧠 Overview

An **EC2 boot loop** means the instance repeatedly **starts → fails to boot → reboots automatically**.
This is often caused by:

- Corrupted OS/kernel files
- Incorrect fstab entries
- Faulty drivers or kernel panic
- Full or damaged root EBS volume
- Invalid user-data scripts or misconfigurations

When this happens, you usually **can’t SSH or SSM into the instance**.

---

### ⚙️ Purpose / How It Works

During startup, EC2 instances:

1. Load the **bootloader** and **kernel**.
2. Mount the **root filesystem**.
3. Run **systemd/init** processes.
4. Execute **user-data scripts (if any)**.

If any of these steps fail, the system restarts, enters **boot loop**, or halts at emergency mode.

---

### 🧩 Step-by-Step Troubleshooting Guide

#### ✅ 1. Check EC2 Console Output (AWS Console)

- Go to: **EC2 → Instances → Select Instance → Monitor → Get System Log**
- Look for errors like:

  - `kernel panic`
  - `mount: can't find /dev/xvda1`
  - `Failed to mount /etc/fstab`
  - `Out of memory: Kill process`
  - `Exec format error`
  - `cloud-init user data failed`

If logs show continuous reboot attempts → OS-level crash or mount issue.

---

#### ✅ 2. Take a Snapshot (Before Making Changes)

Always create a backup before repair:

```bash
aws ec2 create-snapshot --volume-id vol-0123456789abcdef0 --description "Pre-fix snapshot"
```

---

#### ✅ 3. Detach the Root Volume

Stop the instance (⚠️ **Do not terminate!**):

```bash
aws ec2 stop-instances --instance-ids i-0123456789abcdef0
```

Detach the root volume:

```bash
aws ec2 detach-volume --volume-id vol-0123456789abcdef0
```

---

#### ✅ 4. Attach Root Volume to a Rescue Instance

- Launch or use another **healthy EC2** instance in the same AZ.
- Attach the problematic root volume as a secondary disk:

```bash
aws ec2 attach-volume \
  --volume-id vol-0123456789abcdef0 \
  --instance-id i-0fedcba9876543210 \
  --device /dev/xvdf
```

Mount the volume:

```bash
sudo mkdir /mnt/rescue
sudo mount /dev/xvdf1 /mnt/rescue
```

---

#### ✅ 5. Investigate the Problem

**a. Check Disk Space**

```bash
sudo df -h /mnt/rescue
sudo du -sh /mnt/rescue/var/log/*
```

If full → clean logs, cache, or Docker data:

```bash
sudo rm -rf /mnt/rescue/var/log/*.gz /mnt/rescue/var/log/*.[0-9]
sudo rm -rf /mnt/rescue/tmp/*
```

**b. Check fstab Configuration**
Incorrect `/etc/fstab` entries often cause boot loops:

```bash
sudo cat /mnt/rescue/etc/fstab
```

If you see a bad mount (like a missing EBS or NFS mount), comment it out:

```bash
# /dev/xvdf  /data  ext4  defaults,nofail  0  2
```

Use the `nofail` option to prevent blocking on boot.

**c. Review Kernel Logs**

```bash
sudo cat /mnt/rescue/var/log/dmesg | grep -i error
sudo cat /mnt/rescue/var/log/messages | grep -i panic
```

If kernel panic — consider updating kernel or reverting changes.

**d. Inspect User-Data Script**
If the boot loop began after deploying a new AMI or startup script:

```bash
sudo cat /mnt/rescue/var/lib/cloud/instances/*/user-data.txt
```

Comment or fix faulty script lines that cause reboots or hangs.

---

#### ✅ 6. Reattach and Reboot the Fixed Volume

Unmount and detach from rescue instance:

```bash
sudo umount /mnt/rescue
aws ec2 detach-volume --volume-id vol-0123456789abcdef0
```

Reattach to the original instance:

```bash
aws ec2 attach-volume \
  --volume-id vol-0123456789abcdef0 \
  --instance-id i-0123456789abcdef0 \
  --device /dev/xvda
```

Then start the instance:

```bash
aws ec2 start-instances --instance-ids i-0123456789abcdef0
```

Check console log again to verify successful boot.

---

#### ✅ 7. Optional: Replace Corrupted Kernel (if needed)

If kernel panic continues:

- Mount rescue volume
- `chroot` into it:

  ```bash
  sudo chroot /mnt/rescue
  yum reinstall kernel -y
  exit
  ```

- Then reattach and reboot.

---

### 📋 Common Causes & Fixes

| **Root Cause**       | **Symptom**                    | **Fix**                                    |
| -------------------- | ------------------------------ | ------------------------------------------ |
| Full root volume     | “No space left on device”      | Clean `/var/log`, `/tmp`, or expand volume |
| Bad `/etc/fstab`     | Boot stops at “emergency mode” | Add `nofail` or comment bad mounts         |
| Kernel panic         | Looping reboots, kernel error  | Reinstall or update kernel                 |
| Bad user data script | Boot loops during cloud-init   | Fix or disable script                      |
| Corrupted filesystem | `fsck` errors on mount         | Run `fsck -y /dev/xvdf1` in rescue mode    |
| AWS hardware fault   | System status check fails      | Stop/Start instance (new host)             |

---

### ✅ Best Practices

- Always **test new AMIs** before production rollout.
- Keep **root EBS volumes ≥ 20 GB** to prevent log saturation.
- Use `nofail` in `/etc/fstab` for non-critical mounts.
- Use **CloudWatch Alarms** on `StatusCheckFailed_System`.
- Automate backups with **EBS snapshots** or **AMI versioning**.
- Implement **SSM Session Manager** access for emergency repairs (no SSH dependency).

---

### 💡 In short

If your EC2 is in a **boot loop**:

1. 🧩 Check **system logs** → identify kernel/fstab/user-data issues
2. 🛠️ Mount the volume on a **rescue instance** → clean, fix, or comment bad configs
3. 🔁 Reattach → reboot → monitor via **console output**
   ✅ Most boot loops are fixed by cleaning a full root volume or correcting `/etc/fstab`.

---

## Q: EC2 Instance Showing Slow Performance — How to Diagnose & Fix

---

### 🧠 Overview

**Slow EC2 performance** can result from **CPU saturation, memory pressure, disk bottlenecks, or network congestion.**
Diagnosing involves analyzing system metrics, CloudWatch data, and workload characteristics to isolate the bottleneck and take corrective action.

---

### ⚙️ Purpose / How It Works

EC2 performance depends on:

- **Instance type & size** (CPU, RAM, network bandwidth)
- **Storage performance** (EBS IOPS or throughput)
- **Application load patterns**
- **AWS limits** (credit-based CPUs like t2/t3 instances)

You can use **CloudWatch**, **CloudWatch Agent**, and **SSM Session Manager** to investigate and remediate performance issues in real time.

---

### 🧩 Step-by-Step Troubleshooting Guide

#### ✅ 1. Check CPU Utilization

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value=i-0123456789abcdef0 \
  --start-time $(date -u -d '-15 minutes' +%Y-%m-%dT%H:%M:%SZ) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%SZ) \
  --period 60 --statistics Maximum
```

If CPU is consistently >80%, you might:

- **Upgrade instance type** (e.g., `t3.medium` → `m5.large`)
- **Enable unlimited CPU credits** (for burstable `t2/t3`)

  ```bash
  aws ec2 modify-instance-credit-specification --instance-id i-0123456789abcdef0 --cpu-credits unlimited
  ```

- Check for **CPU-throttled processes** using:

  ```bash
  top -o %CPU
  ```

---

#### ✅ 2. Check Memory Usage

By default, CloudWatch doesn’t collect memory metrics — use **CloudWatch Agent**:

```bash
sudo yum install -y amazon-cloudwatch-agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

Then check memory usage:

```bash
free -m
vmstat 1 5
```

**Symptoms:**

- `Swap` usage or OOM (Out-Of-Memory) errors → increase instance size or optimize app memory usage.

---

#### ✅ 3. Analyze Disk I/O

```bash
iostat -xz 1 3
```

- **High `await` (>20ms)** → EBS throttling
- **High `%util` (~100%)** → Disk I/O saturated

Check CloudWatch:

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/EBS \
  --metric-name VolumeQueueLength \
  --dimensions Name=VolumeId,Value=vol-0abcd1234efgh5678 \
  --statistics Average --period 300
```

**Fixes:**

- Move to higher IOPS volume type (`gp3`, `io1`)
- Increase provisioned IOPS:

  ```bash
  aws ec2 modify-volume --volume-id vol-0abcd1234efgh5678 --iops 6000
  ```

- Offload logs or temp data to separate volumes.

---

#### ✅ 4. Check Network Performance

```bash
ping <target>
iperf3 -c <remote_ip>
```

**Symptoms:**

- High latency → overloaded network interface
- Slow transfer → instance bandwidth limit reached

Check instance type’s **network bandwidth** limit in AWS docs.
If you hit limits, move to **enhanced networking (ENA)** instance:

```bash
ethtool -i eth0
```

If not enabled:

```bash
sudo modprobe ena
```

---

#### ✅ 5. Check System Health & AWS Host Issues

- In **AWS Console → EC2 → Status Checks**

  - **System Status Check failed** → AWS hardware/network issue → stop/start instance
  - **Instance Status Check failed** → OS or configuration problem

Command:

```bash
aws ec2 describe-instance-status --instance-ids i-0123456789abcdef0
```

---

#### ✅ 6. Application-Level Issues

- Check logs: `/var/log/messages`, `/var/log/syslog`, `/var/log/app.log`
- Confirm no long-running queries or blocking threads.
- Use APM tools (e.g., CloudWatch Application Insights, New Relic, Datadog) for profiling.

---

#### ✅ 7. Evaluate Instance Type & Right-Sizing

Use **AWS Compute Optimizer**:

```bash
aws compute-optimizer get-ec2-instance-recommendations
```

Recommendations may suggest:

- Newer family (e.g., `t2 → t3a` for better cost/perf)
- More vCPUs or memory
- Different storage type (EBS vs. Instance Store)

---

### 📋 Common Causes & Fixes

| **Cause**                 | **Symptoms**           | **Fix**                              |
| ------------------------- | ---------------------- | ------------------------------------ |
| CPU throttling (T-series) | Slow CPU response      | Enable unlimited mode or upgrade     |
| Low memory                | Swap usage, OOM        | Resize or optimize apps              |
| EBS IOPS bottleneck       | High `await` in iostat | Move to `gp3/io1`                    |
| Full disk                 | “No space left” errors | Clean or expand volume               |
| Network bandwidth limit   | Slow data transfer     | Use ENA-enabled or larger instance   |
| Background tasks          | Constant high load     | Tune cron, services, or Docker       |
| AWS maintenance           | Sudden lag             | Check EC2 events or Health Dashboard |

---

### ✅ Best Practices

- Use **CloudWatch Dashboards** for CPU, memory, and disk trending.
- Enable **detailed monitoring** (1-min interval).
- Schedule **instance right-sizing reviews** monthly.
- Separate workloads (e.g., DB vs. App) onto different instances.
- Use **Auto Scaling Groups** to handle peak load gracefully.
- Apply **EBS-optimized instances** for high I/O workloads.
- Use **elastic load balancing** to distribute web load.

---

### 💡 In short

If EC2 is slow:

1. 🧠 Check **CPU, memory, disk, network metrics** in CloudWatch.
2. ⚙️ Identify bottleneck (CPU throttle, EBS IOPS, memory leak).
3. 🛠️ Fix → clean, resize, optimize, or upgrade instance.
   ✅ Most slowness comes from **CPU credit exhaustion**, **I/O throttling**, or **resource limits** — easily fixed by resizing or tuning workloads.

---

## Q: Lost SSH Key for EC2 — How to Regain Access Safely

---

### 🧠 Overview

If you **lose the SSH private key (.pem)** for an EC2 instance, you can’t log in using SSH — but your data is still safe.
AWS doesn’t store private keys, so recovery involves **attaching the root volume to another instance**, **adding a new key**, or using **AWS Systems Manager (SSM)** if enabled.

---

### ⚙️ Purpose / How It Works

SSH keys authenticate access to EC2 Linux instances.

- The public key is stored in `/home/ec2-user/.ssh/authorized_keys` (inside the instance).
- The private key (.pem) is stored by you.
  If the private key is lost, the only way to re-access is by **injecting a new public key** manually into the instance’s authorized keys file.

---

### 🧩 Step-by-Step Recovery Methods

---

### ✅ **Option 1: Use Systems Manager (If SSM Agent Enabled)**

If your instance has:

- IAM role with **AmazonSSMManagedInstanceCore**
- SSM Agent installed
- Outbound internet or VPC endpoint access

You can connect **without SSH**.

#### 🔹 Start a Session

```bash
aws ssm start-session --target i-0123456789abcdef0
```

Once inside:

```bash
# Create new authorized_keys entry
sudo mkdir -p /home/ec2-user/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIw... your_new_public_key" | sudo tee -a /home/ec2-user/.ssh/authorized_keys
sudo chmod 600 /home/ec2-user/.ssh/authorized_keys
sudo chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys
```

✅ You can now SSH using your **new private key**.

---

### ✅ **Option 2: Use Root Volume Recovery (If SSM Not Enabled)**

#### Step 1️⃣ — Stop the Instance

```bash
aws ec2 stop-instances --instance-ids i-0123456789abcdef0
```

#### Step 2️⃣ — Detach the Root Volume

```bash
aws ec2 detach-volume --volume-id vol-0123456789abcdef0
```

#### Step 3️⃣ — Attach Volume to Rescue Instance

Attach it to another EC2 instance in the same AZ:

```bash
aws ec2 attach-volume \
  --volume-id vol-0123456789abcdef0 \
  --instance-id i-0fedcba9876543210 \
  --device /dev/xvdf
```

Mount it:

```bash
sudo mkdir /mnt/rescue
sudo mount /dev/xvdf1 /mnt/rescue
```

#### Step 4️⃣ — Add a New SSH Key

Generate a new key pair:

```bash
aws ec2 create-key-pair --key-name new-keypair --query "KeyMaterial" --output text > new-keypair.pem
chmod 400 new-keypair.pem
```

Get its public key:

```bash
ssh-keygen -y -f new-keypair.pem
```

Add it to the lost instance’s authorized keys:

```bash
sudo mkdir -p /mnt/rescue/home/ec2-user/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIw... new_public_key" | sudo tee -a /mnt/rescue/home/ec2-user/.ssh/authorized_keys
sudo chmod 600 /mnt/rescue/home/ec2-user/.ssh/authorized_keys
sudo chown -R 1000:1000 /mnt/rescue/home/ec2-user/.ssh
```

#### Step 5️⃣ — Detach and Reattach Volume

Unmount and detach:

```bash
sudo umount /mnt/rescue
aws ec2 detach-volume --volume-id vol-0123456789abcdef0
```

Reattach to the original instance as root:

```bash
aws ec2 attach-volume \
  --volume-id vol-0123456789abcdef0 \
  --instance-id i-0123456789abcdef0 \
  --device /dev/xvda
```

Start the instance:

```bash
aws ec2 start-instances --instance-ids i-0123456789abcdef0
```

Now SSH using the new key:

```bash
ssh -i new-keypair.pem ec2-user@<public-ip>
```

---

### ✅ **Option 3: Replace Root Volume with New AMI (Last Resort)**

If the instance is unrecoverable:

1. Create an **AMI** from the root volume snapshot.
2. Launch a **new instance** with a new key pair.
3. Mount or import data from the old volume.

---

### 📋 Common Pitfalls

| **Issue**                     | **Cause**                     | **Fix**                                                |
| ----------------------------- | ----------------------------- | ------------------------------------------------------ |
| “Permission denied”           | Wrong key or user             | Use correct user (e.g., `ec2-user`, `ubuntu`)          |
| “SSM not available”           | No IAM role or agent disabled | Use volume-attach method                               |
| “Access denied modifying key” | Missing IAM perms             | Ensure role has `ec2:AttachVolume`, `ssm:StartSession` |
| “Volume not mounting”         | Different device names        | Try `/dev/xvdf` or `/dev/nvme1n1`                      |

---

### ✅ Best Practices

- Always **download and back up PEM files securely** (e.g., AWS Secrets Manager or Vault).
- Use **SSM Session Manager** instead of direct SSH for production.
- Store SSH public keys in **AWS EC2 Launch Templates** or **Parameter Store**.
- Rotate keys periodically and automate injection with **cloud-init** or **Terraform**.
- Enable **EBS snapshots** regularly for recovery readiness.

---

### 💡 In short

If you’ve lost your EC2 SSH key:

1. ✅ Try **SSM Session Manager** (if enabled).
2. 🔧 Otherwise, **attach the root volume to another instance**, inject a new key, and reattach.
3. 🔒 Always back up keys and migrate to **SSM-based access** to avoid future key loss.

➡️ **Fastest recovery path:** `SSM Session Manager` → no downtime, no PEM headaches.

---

## Q: EC2 Instance Not Patch Compliant — How to Diagnose & Fix

---

### 🧠 Overview

An EC2 instance marked as **“Not Patch Compliant”** in AWS means it’s **missing required OS or security updates** as defined in your **AWS Systems Manager (SSM) Patch Baseline**.
Patch compliance is managed by **SSM Patch Manager**, which scans, installs, and reports on patch status across your fleet.

---

### ⚙️ Purpose / How It Works

SSM Patch Manager:

1. Uses **Patch Baselines** to define which patches are approved.
2. **Scans instances** using the `AWS-RunPatchBaseline` document.
3. Reports compliance results in **SSM → Compliance dashboard**.

An instance becomes _non-compliant_ if:

- It misses security or critical patches.
- It hasn’t run a recent scan.
- The SSM agent or IAM permissions are missing.

---

### 🧩 Step-by-Step Troubleshooting Guide

#### ✅ 1. Verify SSM Agent Is Running

On the instance:

```bash
sudo systemctl status amazon-ssm-agent
```

If not running:

```bash
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
```

For manual installation:

```bash
sudo yum install -y amazon-ssm-agent  # Amazon Linux
sudo snap install amazon-ssm-agent --classic  # Ubuntu
```

---

#### ✅ 2. Check IAM Role Permissions

Ensure the EC2 instance has an IAM role attached with at least:

- **AmazonSSMManagedInstanceCore** policy
- Optional: **AmazonSSMPatchAssociation** or **CloudWatchAgentServerPolicy**

```bash
aws iam list-attached-role-policies --role-name EC2-SSM-Role
```

If not attached:

```bash
aws iam attach-role-policy \
  --role-name EC2-SSM-Role \
  --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
```

---

#### ✅ 3. Trigger a Manual Patch Scan

```bash
aws ssm send-command \
  --document-name "AWS-RunPatchBaseline" \
  --targets "Key=InstanceIds,Values=i-0123456789abcdef0" \
  --parameters '{"Operation":["Scan"]}'
```

View compliance summary:

```bash
aws ssm list-compliance-summaries
```

If you see:

```
ComplianceType: Patch
Status: NON_COMPLIANT
```

→ Missing patches detected.

---

#### ✅ 4. Install Missing Patches

```bash
aws ssm send-command \
  --document-name "AWS-RunPatchBaseline" \
  --targets "Key=InstanceIds,Values=i-0123456789abcdef0" \
  --parameters '{"Operation":["Install"]}'
```

You can also use **SSM Maintenance Windows** for scheduled patching:

```bash
aws ssm create-maintenance-window \
  --name "PatchWindow" \
  --schedule "cron(0 2 ? * SUN *)" \
  --duration 2 \
  --cutoff 1 \
  --allow-unassociated-targets
```

---

#### ✅ 5. Review Patch Baseline Configuration

Check which baseline is applied:

```bash
aws ssm describe-instance-patch-states \
  --instance-ids i-0123456789abcdef0
```

Common baselines:

| **Type**    | **Baseline ID**                        | **Description**              |
| ----------- | -------------------------------------- | ---------------------------- |
| AWS Default | `AWS-AmazonLinux2DefaultPatchBaseline` | Default security patches     |
| Custom      | `pb-0abcd1234ef567890`                 | Your org-defined patch rules |

Check baseline rules:

```bash
aws ssm get-patch-baseline --baseline-id pb-0abcd1234ef567890
```

---

#### ✅ 6. Review Patch Compliance Report

Get detailed compliance info:

```bash
aws ssm describe-instance-patch-state --instance-id i-0123456789abcdef0
```

Example output:

```
MissingCount: 5
FailedCount: 0
InstalledCount: 250
Operation: Scan
```

---

#### ✅ 7. Validate Network & Repo Access

Instances must reach:

- **Amazon SSM endpoints**
- **OS update repositories (YUM/APT)**
  For Amazon Linux:

```bash
sudo yum repolist
```

For Ubuntu:

```bash
sudo apt-get update
```

If repos are unreachable (private subnet), configure:

- **VPC Endpoints for SSM + EC2Messages**
- **NAT Gateway** for internet access

---

### 📋 Common Root Causes

| **Category** | **Issue**                      | **Fix**                                       |
| ------------ | ------------------------------ | --------------------------------------------- |
| Agent        | SSM Agent stopped              | Restart or reinstall agent                    |
| IAM Role     | Missing SSM permissions        | Attach `AmazonSSMManagedInstanceCore`         |
| Baseline     | Wrong or expired baseline      | Update to default or valid baseline           |
| Network      | No repo or SSM endpoint access | Add NAT or VPC endpoint                       |
| Scan         | Never scanned                  | Run `AWS-RunPatchBaseline` with Scan          |
| OS           | Custom repo misconfigured      | Validate `/etc/yum.repos.d` or `sources.list` |

---

### ✅ Best Practices

- Automate patching via **SSM Maintenance Windows** or **State Manager**.
- Use **Patch Groups** with tags (e.g., `PatchGroup=Prod`).
- Enforce **approval rules** for security and critical updates.
- Send compliance reports to **Security Hub** or **SNS notifications**.
- Regularly verify compliance using:

  ```bash
  aws ssm list-compliance-summaries
  ```

- Integrate patch compliance with **AWS Config** rule `EC2-PATCH-COMPLIANCE-STATUS-CHECK`.

---

### 💡 In short

If EC2 shows **Not Patch Compliant**:

1. 🧩 Verify **SSM Agent + IAM Role**
2. ⚙️ Run `AWS-RunPatchBaseline` → Scan + Install
3. 🌐 Ensure **network access** to SSM + OS repos
4. 🕓 Schedule via **Maintenance Windows**

✅ Compliance turns “Compliant” after successful patch install and rescan — use **CloudWatch dashboards** or **Security Hub** for continuous visibility.

---

## Q: AMI Creation Failed — How to Diagnose & Fix

---

### 🧠 Overview

**AMI creation failure** in EC2 usually happens when AWS cannot **snapshot the instance’s EBS volumes** or **communicate with the instance** during the AMI build process.
This can result in errors like:

- `Client.InternalError: An internal error has occurred.`
- `InvalidAMIID.NotFound`
- `Instance is not in a valid state for CreateImage`

---

### ⚙️ Purpose / How It Works

When you run `create-image`, AWS:

1. Freezes the filesystem (if `--no-reboot=false`)
2. Creates **snapshots** of all attached EBS volumes
3. Registers those snapshots as a new **AMI**

The process fails if:

- The instance or EBS volume is **in-use, degraded, or misconfigured**
- You lack **IAM permissions**
- **Snapshots** can’t be created due to region, KMS, or quota issues

---

### 🧩 Step-by-Step Troubleshooting Guide

#### ✅ 1. Verify Instance State

AMI creation only works if the instance is in `running` or `stopped` state.

```bash
aws ec2 describe-instances --instance-ids i-0123456789abcdef0 \
  --query "Reservations[*].Instances[*].State.Name"
```

If not `running` or `stopped`, stop it:

```bash
aws ec2 stop-instances --instance-ids i-0123456789abcdef0
```

Then retry:

```bash
aws ec2 create-image \
  --instance-id i-0123456789abcdef0 \
  --name "golden-ami-v1.0" \
  --description "AMI with app and agents" \
  --no-reboot
```

---

#### ✅ 2. Check IAM Permissions

Your IAM user or role must have:

```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:CreateImage",
    "ec2:CreateSnapshot",
    "ec2:RegisterImage",
    "ec2:DescribeInstances",
    "ec2:DescribeSnapshots",
    "ec2:CreateTags"
  ],
  "Resource": "*"
}
```

If volumes are encrypted with a **custom KMS key**, add:

```json
{
  "Effect": "Allow",
  "Action": [
    "kms:CreateGrant",
    "kms:Encrypt",
    "kms:Decrypt",
    "kms:DescribeKey"
  ],
  "Resource": "arn:aws:kms:us-east-1:123456789012:key/abcd-efgh-ijkl"
}
```

---

#### ✅ 3. Verify EBS Volume Health

List attached volumes:

```bash
aws ec2 describe-volumes \
  --filters Name=attachment.instance-id,Values=i-0123456789abcdef0 \
  --query "Volumes[*].{ID:VolumeId,State:State,Encrypted:Encrypted,AZ:AvailabilityZone}"
```

If any volume is `error` or `deleting` → detach or replace before creating AMI:

```bash
aws ec2 detach-volume --volume-id vol-0abcd1234efgh5678
```

---

#### ✅ 4. Check for Encryption or KMS Key Issues

If you see:

```
Client.UnauthorizedOperation: Not authorized to perform CreateSnapshot
```

Then:

- You’re missing access to the **KMS key** used for EBS encryption.
- Either **use AWS-managed key (`aws/ebs`)** or update the key policy.

To update key policy:

```bash
aws kms create-grant \
  --key-id <kms-key-id> \
  --grantee-principal arn:aws:iam::<account-id>:role/<role-name> \
  --operations CreateGrant,Encrypt,Decrypt,DescribeKey
```

---

#### ✅ 5. Check for Snapshot Quota or Limit

Each AMI creates **one snapshot per EBS volume**.
If you’ve hit snapshot limits:

```bash
aws service-quotas get-service-quota \
  --service-code ec2 \
  --quota-code L-309BACF6
```

If near limit → delete old snapshots:

```bash
aws ec2 describe-snapshots --owner-ids self
aws ec2 delete-snapshot --snapshot-id snap-0123456789abcdef0
```

---

#### ✅ 6. Check if Instance Uses Instance Store (Ephemeral) Volumes

AMI creation **fails for instance-store-backed volumes** — they’re **non-persistent**.
Verify:

```bash
aws ec2 describe-instance-attribute --instance-id i-0123456789abcdef0 --attribute rootDeviceType
```

If `rootDeviceType=instance-store` →
AMI creation is **not supported**; create a new instance using an **EBS-backed AMI**.

---

#### ✅ 7. Check Region and Availability Zone Consistency

If you attempt to create AMI in a different region or cross-account setup, ensure all attached volumes are in the **same region** as the instance.

---

#### ✅ 8. Review CloudTrail Logs for Failure Cause

```bash
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=CreateImage \
  --max-results 10
```

Look for:

- `AccessDenied`
- `KMS key not found`
- `Snapshot creation failed`
- `InvalidVolumeState`

---

### 📋 Common Root Causes

| **Cause**                    | **Error Message / Symptom**      | **Fix**                  |
| ---------------------------- | -------------------------------- | ------------------------ |
| Instance not running/stopped | `Instance is not in valid state` | Stop instance, retry     |
| EBS volume degraded          | `InvalidVolumeState`             | Detach/replace volume    |
| KMS key access denied        | `UnauthorizedOperation`          | Update KMS or IAM policy |
| Instance-store root          | No AMI created                   | Use EBS-backed instance  |
| Snapshot limit exceeded      | `Snapshot quota exceeded`        | Delete old snapshots     |
| Internal AWS issue           | `Client.InternalError`           | Retry after few minutes  |
| Disk space full              | Incomplete snapshot              | Clean and retry          |

---

### ✅ Best Practices

- Use **EBS-backed AMIs** for persistence.
- Always **stop the instance before AMI creation** for data consistency.
- Tag AMIs and snapshots clearly (`Name=golden-ami`, `Env=Prod`).
- Automate AMI builds using **EC2 Image Builder** or **Packer**.
- Regularly delete outdated AMIs and snapshots.
- Use **KMS grants** instead of sharing keys directly.

---

### 💡 In short

If **AMI creation fails**:

1. 🧩 Check **instance state** (`running/stopped`)
2. 🔒 Verify **IAM + KMS permissions**
3. ⚙️ Ensure **healthy EBS volumes**
4. 🧱 Confirm **EBS-backed root device**
5. ♻️ Retry after cleanup or snapshot limit check

✅ Most AMI creation failures come from **KMS permission issues**, **EBS snapshot errors**, or **instance-store-backed volumes** — all fixable with proper IAM and volume validation.

---

## Q: How to Achieve Zero-Downtime Patching for EC2 Instances

---

### 🧠 Overview

**Zero-downtime patching** ensures your EC2 workloads remain **available and responsive** while operating system and security patches are applied.
Instead of patching in-place (which requires reboot), you maintain continuous uptime by using **rolling updates**, **load balancing**, and **immutable AMI deployment** strategies.

---

### ⚙️ Purpose / How It Works

The idea is simple:

1. Don’t patch directly on live production instances.
2. Instead, **replace** them with pre-patched instances using automation.
3. Use **load balancers** and **Auto Scaling Groups (ASGs)** to shift traffic gracefully.

This approach leverages:

- **SSM Patch Manager** for controlled patching
- **Auto Scaling rolling updates** for instance replacement
- **Load Balancer health checks** for seamless cutover

---

### 🧩 Zero-Downtime Patching Methods

---

#### ✅ **Option 1: Rolling Patching via Auto Scaling Group (Recommended)**

##### **Step 1. Use Auto Scaling Group (ASG) + Load Balancer**

- All EC2 instances are behind an **Application Load Balancer (ALB)**.
- Health checks ensure traffic goes only to healthy instances.

##### **Step 2. Create a New Launch Template (with Latest Patches)**

Bake a **Golden AMI** using **SSM Patch Manager**, **EC2 Image Builder**, or **Packer**:

```bash
aws ec2 create-image \
  --instance-id i-0123456789abcdef0 \
  --name "golden-ami-v2.0" \
  --description "Patched AMI with security updates" \
  --no-reboot
```

##### **Step 3. Update ASG Launch Template**

```bash
aws autoscaling update-auto-scaling-group \
  --auto-scaling-group-name prod-asg \
  --launch-template "LaunchTemplateName=web-template,Version=2"
```

##### **Step 4. Perform Rolling Update**

- Set **max surge = 1**, **min in-service = N-1** to ensure capacity remains during replacement.
- Instances are terminated and replaced **one by one**.
- The load balancer routes traffic only to patched, healthy nodes.

##### Example (CloudFormation or Terraform Rolling Policy)

```yaml
AutoScalingRollingUpdate:
  MaxBatchSize: 1
  MinInstancesInService: 2
  PauseTime: PT5M
  WaitOnResourceSignals: true
```

✅ **Result:**
New patched instances come online → old ones drain gracefully → no downtime.

---

#### ✅ **Option 2: In-Place Patching with Load Balancer Deregistration**

Use **SSM Patch Manager** for OS-level patching but **remove instances temporarily** from the ALB target group.

##### **Workflow:**

1. **Deregister instance** from load balancer:

   ```bash
   aws elbv2 deregister-targets --target-group-arn arn:aws:... --targets Id=i-0123456789abcdef0
   ```

2. **Patch using SSM:**

   ```bash
   aws ssm send-command \
     --document-name "AWS-RunPatchBaseline" \
     --targets "Key=InstanceIds,Values=i-0123456789abcdef0" \
     --parameters '{"Operation":["Install"]}'
   ```

3. **Reboot instance if needed**, then **re-register**:

   ```bash
   aws elbv2 register-targets --target-group-arn arn:aws:... --targets Id=i-0123456789abcdef0
   ```

4. Confirm healthy via:

   ```bash
   aws elbv2 describe-target-health --target-group-arn arn:aws:...
   ```

✅ Used when Auto Scaling isn’t implemented (static instances).
🕓 Slight delay per node, but traffic stays uninterrupted.

---

#### ✅ **Option 3: Blue-Green Deployment for Immutable Environments**

For large-scale or critical apps, use a **blue-green** approach:

1. **Blue** = Current environment (old AMI)
2. **Green** = New environment (patched AMI)

Use tools:

- **CodeDeploy**
- **Terraform**
- **EC2 Image Builder + CloudFormation StackSets**

##### Example (CodeDeploy Strategy)

```yaml
deploymentConfigurationName: CodeDeployDefault.OneAtATime
loadBalancerInfo:
  targetGroupInfoList:
    - name: production-alb-tg
```

Cut traffic to green environment once health checks pass — zero downtime guaranteed.

---

### 📋 Comparison of Zero-Downtime Strategies

| **Method**                           | **Downtime** | **Tools Used**                 | **Best For**               |
| ------------------------------------ | ------------ | ------------------------------ | -------------------------- |
| **Rolling ASG Update**               | None         | ALB + ASG + Launch Template    | Web apps, microservices    |
| **In-Place Patch w/ Deregistration** | Near-zero    | SSM Patch Manager              | Small static workloads     |
| **Blue-Green Deployment**            | None         | CodeDeploy / EC2 Image Builder | Large-scale immutable apps |

---

### ✅ Best Practices

- Always patch **staging** before production.
- Use **health checks + connection draining** on ALB to prevent dropped sessions.
- Automate AMI baking and deployment (Packer, EC2 Image Builder).
- Tag EC2s with `PatchGroup=Prod` for targeted SSM automation.
- Use **CloudWatch Alarms + SNS** for patching event alerts.
- Use **SSM Maintenance Windows** for automated rolling patching:

  ```bash
  aws ssm create-maintenance-window --name "RollingPatchWindow" --schedule "cron(0 2 ? * SUN *)"
  ```

- Integrate with **AWS CodePipeline** for CI/CD-driven patch rollouts.

---

### 💡 In short

To achieve **zero-downtime patching**:

1. 🧱 Use **Auto Scaling + ALB** for rolling updates.
2. ⚙️ Patch via **SSM or pre-baked AMIs** — never live on production.
3. 🔁 Gradually replace instances (blue-green or rolling).

✅ Immutable, automated, and load-balanced patching = **no downtime, no user impact**.
