# Terraform

## Q: What is Terraform?

### 🧠 Overview

**Terraform** is an **open-source Infrastructure as Code (IaC)** tool by HashiCorp that lets you **define, provision, and manage cloud infrastructure** using declarative configuration files.
It supports multiple providers (AWS, Azure, GCP, Kubernetes, etc.) and ensures consistent, version-controlled, and reproducible infrastructure deployments.

---

### ⚙️ Core Concept

Terraform manages infrastructure lifecycle through three key phases:

|     Phase | Command           | Description                                                              |
| --------: | ----------------- | ------------------------------------------------------------------------ |
| **Write** | `.tf` files       | Define desired infrastructure in HCL (HashiCorp Configuration Language). |
|  **Plan** | `terraform plan`  | Preview changes Terraform will apply to reach desired state.             |
| **Apply** | `terraform apply` | Create, update, or destroy infrastructure safely.                        |

Example:

```bash
terraform init     # Initialize provider plugins
terraform plan     # Preview changes
terraform apply    # Apply changes to create/update infra
```

---

### ⚙️ Example — AWS EC2 Instance

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  tags = {
    Name = "MyWebServer"
  }
}
```

* Defines an EC2 instance.
* Terraform tracks it in **state** (`terraform.tfstate`).
* If you change instance type and reapply, Terraform modifies it automatically.

---

### 🧩 Key Features

| Feature                       | Description                                          |
| ----------------------------- | ---------------------------------------------------- |
| 🧱 **Declarative IaC**        | Define *what* you want, Terraform figures out *how*. |
| ☁️ **Multi-cloud support**    | Works with AWS, Azure, GCP, Kubernetes, etc.         |
| 🧾 **State Management**       | Tracks real-world resources vs configuration.        |
| 🔄 **Dependency Graph**       | Automatically orders operations (create/destroy).    |
| 🧰 **Modules**                | Reusable infra components (like functions for IaC).  |
| 🔐 **Remote State & Locking** | Prevent concurrent updates (S3 + DynamoDB).          |
| 🔁 **Idempotent Execution**   | Repeated applies yield same result.                  |

---

### 🧱 Typical Workflow

```bash
terraform init                 # Initialize provider & modules
terraform fmt -check           # Format check
terraform validate             # Validate syntax
terraform plan -out=tfplan     # Generate execution plan
terraform apply tfplan         # Apply infrastructure changes
terraform destroy              # Clean up resources
```

---

### 📦 Common Providers

| Provider       | Usage                            |
| -------------- | -------------------------------- |
| **AWS**        | EC2, S3, IAM, EKS, Lambda        |
| **AzureRM**    | VM, Resource Groups, Storage     |
| **Google**     | GCE, GCS, IAM                    |
| **Kubernetes** | Deploy workloads and services    |
| **Helm**       | Manage Helm charts in Kubernetes |
| **Vault**      | Manage secrets and policies      |

---

### ✅ Best Practices

* 🧩 Use **modules** for reusable, versioned components.
* 🔐 Store state remotely (e.g., **S3 + DynamoDB** for locking).
* 🧾 Always **review `terraform plan`** before `apply`.
* 🧰 Manage secrets via environment variables or Vault (never hardcode).
* 🧪 Use **workspaces** for environment isolation (`dev`, `staging`, `prod`).
* 🧩 Integrate with **CI/CD** (Jenkins/GitHub Actions) for automation.
* 📜 Version control `.tf` files and keep `terraform.tfstate` secure.

---

### 💡 In short

Terraform = **Infrastructure as Code tool** that **creates, updates, and manages** cloud resources declaratively across multiple providers — safely, predictably, and repeatably.
Write infra in code → plan → apply → track in state → version → automate. ✅

---

---

## Q: Why use Terraform over CloudFormation?

### 🧠 Overview

Both **Terraform (HashiCorp)** and **AWS CloudFormation (CFN)** are **Infrastructure as Code (IaC)** tools — but Terraform is **multi-cloud**, **declarative**, and more **modular**, while CloudFormation is **AWS-native** and limited to AWS resources.
Terraform is often preferred for portability, reusability, and ecosystem maturity.

---

### ⚙️ Comparison Table — Terraform 🆚 CloudFormation

| Feature                          | 🟢 **Terraform**                                                           | 🟠 **CloudFormation (CFN)**                                           |
| -------------------------------- | -------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| **Cloud Support**                | ✅ Multi-cloud (AWS, Azure, GCP, Kubernetes, etc.)                          | ❌ AWS-only (some extensions to 3rd-party via CloudFormation Registry) |
| **Language**                     | HCL (HashiCorp Configuration Language) — clean, readable                   | JSON / YAML (verbose, harder to maintain)                             |
| **Execution Model**              | Declarative, uses **`terraform plan`** & **`apply`** with dependency graph | Declarative, uses stacks & stack sets                                 |
| **State Management**             | Local or remote (`terraform.tfstate`) — tracks real-world infra            | Managed by AWS; no direct access to state file                        |
| **Change Preview**               | `terraform plan` shows detailed diffs before apply                         | Change sets available but less intuitive                              |
| **Modules & Reusability**        | Strong module ecosystem (Terraform Registry)                               | Nested stacks; less modular and reusable                              |
| **Multi-account / Multi-region** | Easy with providers and variables                                          | Possible but complex (StackSets, cross-account roles)                 |
| **Extensibility**                | Providers for almost anything (cloud, SaaS, APIs, GitHub, Datadog, etc.)   | Mostly AWS resources; limited external                                |
| **CLI & Workflow**               | Consistent CLI (`init`, `plan`, `apply`, `destroy`)                        | Integrated into AWS Console/CLI                                       |
| **Speed**                        | Generally faster (parallel graph execution)                                | Slower (serial stack operations)                                      |
| **Community**                    | Large, open-source, active (Terraform Registry + modules)                  | AWS-native community only                                             |
| **State Locking**                | Built-in (remote backend + DynamoDB lock)                                  | Handled by AWS stack service (auto-locks)                             |
| **Cost**                         | Free & open source (Terraform CLI)                                         | Free, but AWS-only                                                    |
| **Learning Curve**               | Simple HCL syntax                                                          | Verbose YAML/JSON syntax                                              |

---

### ⚙️ Example comparison

#### Terraform

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  tags = { Name = "web" }
}
```

#### CloudFormation

```yaml
Resources:
  WebInstance:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: ami-0c55b159cbfafe1f0
      InstanceType: t3.micro
      Tags:
        - Key: Name
          Value: web
```

> Terraform’s HCL is concise, supports variables, conditionals, loops, and reusable modules more elegantly.

---

### ⚙️ Terraform advantages in real-world DevOps pipelines

| Use-case                                                      | Why Terraform Wins                              |
| ------------------------------------------------------------- | ----------------------------------------------- |
| **Multi-cloud infra (AWS + Azure + GCP)**                     | One tool, one syntax                            |
| **Infra + SaaS integration** (e.g., Cloud + Datadog + GitHub) | Providers for all                               |
| **Modular infra across environments**                         | Modules and workspaces simplify DRY             |
| **Automation with CI/CD (Jenkins, GitHub Actions)**           | CLI-first design integrates easily              |
| **Terraform Cloud/Enterprise**                                | Centralized state, RBAC, drift detection        |
| **Drift Detection**                                           | `terraform plan` reveals drift even outside AWS |
| **Policy as Code**                                            | Sentinel / OPA support for compliance           |
| **Provider Extensibility**                                    | Can manage Kubernetes, Helm, Vault, etc.        |

---

### ⚙️ When to prefer CloudFormation

* Your org is **100% AWS** and uses **native AWS services (CodePipeline + StackSets)**.
* You want **tight integration** with AWS Console / CloudTrail / IAM.
* You require **AWS-native change control** (e.g., CloudFormation drift detection, Stack events).
* Your team already uses AWS CDK (Cloud Development Kit) — which compiles to CFN.

---

### ✅ Best Practices

* 🔐 Use **Terraform for multi-cloud or hybrid** infrastructures.
* 🧩 Use **modules** for environment reusability (`dev`, `staging`, `prod`).
* 🧾 Store Terraform state in **S3 + DynamoDB** (locking).
* 🧰 For pure AWS orgs, consider **CloudFormation** or **AWS CDK** for native IaC.
* ⚡ Integrate Terraform with CI/CD to ensure immutable deployments (`plan` → approval → `apply`).

---

### 💡 In short

Use **Terraform** if you need:

* Multi-cloud or hybrid infra
* Modular, DRY, and scalable IaC
* Rich provider ecosystem
* Full CLI + GitOps automation

Use **CloudFormation** if:

* You’re **AWS-only**, prefer **AWS-native integration**, and want AWS-managed state and permissions.

✅ **Terraform** wins on flexibility, portability, and developer experience.

---

---

## Q: What language does Terraform use?

### 🧠 Overview

Terraform uses **HCL (HashiCorp Configuration Language)** — a **declarative, human-readable language** designed specifically for **Infrastructure as Code (IaC)**.
HCL expresses **what** infrastructure you want, not **how** to build it, letting Terraform automatically determine the order and dependencies between resources.

---

### ⚙️ Key Points

| Concept            | Description                                                                 |
| ------------------ | --------------------------------------------------------------------------- |
| **Language**       | HCL (HashiCorp Configuration Language)                                      |
| **File extension** | `.tf` (main.tf, variables.tf, outputs.tf)                                   |
| **Style**          | Declarative (not procedural or imperative)                                  |
| **Syntax type**    | JSON-like but human-friendly (also supports JSON `.tf.json`)                |
| **Goal**           | Define infrastructure in code — readable for humans, parseable for machines |

---

### ⚙️ Example — HCL Syntax

#### Simple AWS Example

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  tags = {
    Name = "web-server"
  }
}
```

* **Blocks**: `provider`, `resource`, `variable`, `output`
* **Arguments**: `key = value` pairs
* **Nested maps**: `{}` for objects and metadata

---

### ⚙️ HCL Structure (Building Blocks)

| Block Type   | Purpose                              | Example                                                  |
| ------------ | ------------------------------------ | -------------------------------------------------------- |
| **provider** | Define which cloud or service to use | `provider "aws" { region = "us-east-1" }`                |
| **resource** | Define infrastructure object         | `resource "aws_s3_bucket" "data" { ... }`                |
| **variable** | Input parameters                     | `variable "region" { default = "us-east-1" }`            |
| **output**   | Values to print/export               | `output "bucket_name" { value = aws_s3_bucket.data.id }` |
| **module**   | Reusable infra components            | `module "vpc" { source = "./modules/vpc" }`              |
| **locals**   | Define computed constants            | `locals { app_name = "inventory-api" }`                  |
| **data**     | Fetch existing resources             | `data "aws_ami" "latest" { ... }`                        |

---

### ⚙️ Expressions, Variables & Interpolation

#### Variables

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}
```

#### Use variable

```hcl
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
}
```

#### String interpolation & expressions

```hcl
output "instance_info" {
  value = "Instance Type: ${var.instance_type}, Region: ${var.region}"
}
```

#### Conditional expressions

```hcl
resource "aws_instance" "app" {
  instance_type = var.env == "prod" ? "t3.large" : "t3.micro"
}
```

---

### ⚙️ Functions in HCL

HCL includes a library of built-in functions:

```hcl
# Example: join, length, format, file, concat, tolower
locals {
  instance_names = join("-", ["prod", "app", "web"])
  env_lower      = lower(var.env)
}
```

Common ones:

| Function   | Example                             | Purpose            |
| ---------- | ----------------------------------- | ------------------ |
| `concat()` | `concat(["a"], ["b"])`              | Combine lists      |
| `join()`   | `join("-", ["app","dev"])`          | String join        |
| `lookup()` | `lookup(var.map, "key", "default")` | Safe map lookup    |
| `length()` | `length(var.list)`                  | List size          |
| `format()` | `format("%s-%s", var.env, var.app)` | String format      |
| `file()`   | `file("user_data.sh")`              | Read file contents |

---

### ⚙️ JSON Alternative (rarely used)

Terraform can also read `.tf.json` files if you prefer JSON syntax:

```json
{
  "resource": {
    "aws_s3_bucket": {
      "example": {
        "bucket": "my-json-bucket"
      }
    }
  }
}
```

> But most teams prefer **HCL** for readability and maintainability.

---

### ✅ Best Practices

* 📦 Split files by function — `main.tf`, `variables.tf`, `outputs.tf`, `providers.tf`.
* 🧱 Use **modules** to group reusable components.
* 🧩 Keep naming consistent and descriptive.
* 🔍 Use `terraform fmt` to auto-format HCL code.
* 🧪 Validate syntax with `terraform validate`.
* 🧾 Add variable descriptions and types for clarity.

---

### 💡 In short

Terraform uses **HCL (HashiCorp Configuration Language)** — a **declarative, easy-to-read syntax** purpose-built for **infrastructure as code**.
You describe *what* your infrastructure should look like — Terraform figures out *how* to build it. ✅

---

---

## Q: What are Providers in Terraform?

### 🧠 Overview

**Providers** in Terraform are **plugins that interact with APIs** of cloud platforms, SaaS tools, or services — enabling Terraform to **create, read, update, and delete (CRUD)** infrastructure resources.
Each provider (e.g., AWS, Azure, GCP, Kubernetes, Vault, GitHub) exposes a set of supported **resources** and **data sources**.

---

### ⚙️ Key Concept

A **provider** = Terraform’s bridge between your `.tf` code and the real-world service API.

When you run `terraform init`, Terraform:

1. **Downloads** the provider plugin from the Terraform Registry.
2. **Authenticates** using credentials/config you provide.
3. **Executes** CRUD operations for defined resources.

---

### ⚙️ Provider Block Syntax

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "devops"
}
```

✅ **Notes:**

* The `required_providers` block ensures reproducible versions.
* The provider block configures authentication, region, endpoints, etc.
* You can define **multiple provider blocks** for multi-region or multi-account use cases.

---

### 🧩 Example: Multi-Provider Setup

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

resource "aws_instance" "east_vm" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
}

resource "aws_instance" "west_vm" {
  provider      = aws.west
  ami           = "ami-0abcdef1234567890"
  instance_type = "t3.micro"
}
```

🧭 **Alias** lets you use multiple regions/accounts within one configuration.

---

### ⚙️ Data Sources (read-only via Providers)

Providers can also fetch existing infrastructure details:

```hcl
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t3.micro"
}
```

🧾 **`data` blocks** use the provider API to query resources but do not modify them.

---

### ⚙️ Common Terraform Providers (Registry Examples)

| Provider       | Source                  | Typical Use                  |
| -------------- | ----------------------- | ---------------------------- |
| **AWS**        | `hashicorp/aws`         | EC2, S3, IAM, EKS, Lambda    |
| **AzureRM**    | `hashicorp/azurerm`     | VMs, Storage, Networking     |
| **Google**     | `hashicorp/google`      | GCE, GKE, IAM                |
| **Kubernetes** | `hashicorp/kubernetes`  | Deploy workloads to clusters |
| **Helm**       | `hashicorp/helm`        | Install/manage Helm charts   |
| **Vault**      | `hashicorp/vault`       | Secrets, policies            |
| **GitHub**     | `integrations/github`   | Repos, teams, workflows      |
| **Datadog**    | `DataDog/datadog`       | Monitors, dashboards         |
| **Cloudflare** | `cloudflare/cloudflare` | DNS, WAF, CDN configs        |

🔗 Browse all official and community providers:
👉 [registry.terraform.io/browse/providers](https://registry.terraform.io/browse/providers)

---

### ⚙️ Provider Authentication Methods (Examples)

| Provider   | Typical Auth Method                                                            |
| ---------- | ------------------------------------------------------------------------------ |
| AWS        | `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` env vars or `~/.aws/credentials` |
| Azure      | Service Principal (client ID/secret) or Azure CLI login                        |
| GCP        | `GOOGLE_APPLICATION_CREDENTIALS` JSON key                                      |
| Kubernetes | `kubeconfig` or token                                                          |
| Vault      | Token, AppRole, OIDC                                                           |

Example (using env vars securely):

```bash
export AWS_ACCESS_KEY_ID=AKIA...
export AWS_SECRET_ACCESS_KEY=secret...
terraform apply
```

---

### ⚙️ How Providers Work Internally

When you run Terraform:

1. `terraform init` → downloads provider binaries into `.terraform/providers/`.
2. Each provider registers **resources** & **data sources** it supports.
3. During `plan/apply`, Terraform calls provider APIs via gRPC.
4. Provider returns results → Terraform updates **state file** accordingly.

Example provider workflow:

```
[Terraform] ⇄ [Provider Plugin] ⇄ [Cloud/SaaS API]
```

---

### ⚙️ Provider Version Pinning (Best Practice)

Lock provider versions to prevent breaking changes:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

* `~> 5.0` means “any version 5.x.x but not 6.0+”.
* Always commit `.terraform.lock.hcl` to version control for reproducible builds.

---

### ✅ Best Practices

* 🧱 **Pin provider versions** (avoid unexpected updates).
* 🔐 **Use least-privilege IAM/service accounts** for provider auth.
* 📦 **Group providers per environment** (e.g., dev/prod).
* ⚙️ **Use aliases** for multi-region/multi-account deployments.
* 🔁 **Keep providers up to date** (new resource support, bug fixes).
* 📊 **Store credentials securely** (Vault, Jenkins Credentials, AWS Secrets Manager).
* 🧩 **Run `terraform init -upgrade`** periodically to refresh provider binaries safely.

---

### 💡 In short

**Providers = Terraform’s API connectors.**
They let Terraform manage external systems (AWS, Azure, Kubernetes, GitHub, etc.).
You define the provider, authenticate, and Terraform handles all API calls for resource lifecycle management. ✅

---
---

## Q: What are Resources in Terraform?

### 🧠 Overview

In Terraform, a **resource** represents a **real-world infrastructure object** — such as an EC2 instance, S3 bucket, Kubernetes pod, or DNS record — that Terraform **creates, updates, or destroys** via the configured **provider**.
Resources are the **core building blocks** of Terraform configurations.

---

### ⚙️ Key Concept

Each `resource` block tells Terraform **what to manage** and **how it should look**.
Terraform then compares that desired configuration with what already exists (tracked in **state**) and makes only the necessary changes.

---

### ⚙️ Syntax

```hcl
resource "<PROVIDER>_<TYPE>" "<NAME>" {
  <ARGUMENTS...>
}
```

| Element       | Description                                                                  |
| ------------- | ---------------------------------------------------------------------------- |
| **provider**  | The plugin handling resource creation (e.g., `aws`, `azurerm`, `kubernetes`) |
| **type**      | The kind of resource (e.g., `instance`, `bucket`, `pod`)                     |
| **name**      | Local name used within Terraform config to reference it                      |
| **arguments** | Properties and configuration details of the resource                         |

---

### ⚙️ Example — AWS EC2 Instance

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  tags = {
    Name = "web-server"
    Env  = "dev"
  }
}
```

* Terraform calls AWS EC2 API via the AWS provider.
* Tracks it as `aws_instance.web` in the state file.
* If AMI or instance_type changes → Terraform replaces or updates the instance.

---

### ⚙️ Resource Lifecycle

| Stage              | Description                                    | Command                                   |
| ------------------ | ---------------------------------------------- | ----------------------------------------- |
| **Create**         | Terraform builds resource via provider API     | `terraform apply`                         |
| **Read (Refresh)** | Checks current state from cloud                | `terraform refresh` or auto during `plan` |
| **Update**         | Reconfigures resource if configuration changed | `terraform apply`                         |
| **Delete**         | Removes resource from cloud and state          | `terraform destroy`                       |

Terraform guarantees **idempotency** — running `apply` repeatedly doesn’t recreate unchanged resources.

---

### ⚙️ Resource Dependencies

Terraform automatically builds a **dependency graph** between resources.

Example:

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "web" {
  vpc_id     = aws_vpc.main.id   # dependency created here
  cidr_block = "10.0.1.0/24"
}
```

✅ Terraform knows it must create the VPC **before** the subnet.

---

### ⚙️ Resource Attributes

Each resource has **input arguments** (configuration) and **output attributes** (computed values).

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "my-log-bucket-${random_id.suffix.hex}"
}

output "bucket_name" {
  value = aws_s3_bucket.logs.id
}
```

* `aws_s3_bucket.logs.id` is an **attribute** exposed by the provider.
* Attributes can be used as input to other resources or outputs.

---

### ⚙️ Meta-Arguments (Advanced)

| Meta-Arg         | Description                                  | Example                                |
| ---------------- | -------------------------------------------- | -------------------------------------- |
| **`depends_on`** | Explicit dependency (when not auto-detected) | `depends_on = [aws_iam_role.app_role]` |
| **`count`**      | Create multiple identical resources          | `count = 3`                            |
| **`for_each`**   | Create resources from map or set             | `for_each = toset(["dev","prod"])`     |
| **`lifecycle`**  | Control create/update/destroy behavior       | `lifecycle { prevent_destroy = true }` |
| **`provider`**   | Use a specific provider instance             | `provider = aws.us_west_2`             |

Example using `count` and `lifecycle`:

```hcl
resource "aws_instance" "web" {
  count         = 2
  ami           = var.ami
  instance_type = var.type

  lifecycle {
    prevent_destroy = true
  }
}
```

---

### ⚙️ Data Source vs Resource (Key Difference)

| Feature     | **resource**                      | **data**                      |
| ----------- | --------------------------------- | ----------------------------- |
| **Purpose** | Create/manage real infra          | Read existing infra           |
| **Action**  | Create/update/delete via API      | Read-only query               |
| **Example** | `resource "aws_s3_bucket" "data"` | `data "aws_s3_bucket" "data"` |

Example:

```hcl
data "aws_ami" "ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "vm" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
}
```

---

### ⚙️ Resource Lifecycle Control Examples

#### 1. Ignore specific changes

```hcl
lifecycle {
  ignore_changes = [tags]
}
```

#### 2. Create before destroy (for replacements)

```hcl
lifecycle {
  create_before_destroy = true
}
```

#### 3. Prevent accidental deletion

```hcl
lifecycle {
  prevent_destroy = true
}
```

---

### ✅ Best Practices

* 🧱 **Use meaningful names** (e.g., `aws_instance.web_app`).
* 🔐 **Use variables for sensitive inputs** (AMI IDs, credentials).
* 🧩 **Group related resources into modules**.
* ⚙️ **Avoid hardcoded dependencies** — rely on Terraform’s implicit graph.
* 🧾 **Use lifecycle rules** to manage update/destroy safety.
* 🔍 **Use `terraform plan`** before every apply to confirm changes.
* 🧪 **Tag all resources** for cost tracking & ownership.

---

### 💡 In short

**Resources** are the **core building blocks** in Terraform — each represents an infrastructure object Terraform can manage through a provider.
They define **what** exists (not how), and Terraform handles the rest — creation, update, dependencies, and deletion — safely and automatically. ✅

---
---

## Q: What are Variables in Terraform?

### 🧠 Overview

**Variables** in Terraform are **input parameters** that make configurations **dynamic, reusable, and environment-agnostic**.
They let you define infrastructure once and customize it across environments (e.g., dev, staging, prod) without editing the `.tf` files directly.

---

### ⚙️ Purpose

Variables help:

* Avoid **hardcoding values** like AMI IDs, instance types, or regions.
* Simplify **module reuse**.
* Support **parameterization** in CI/CD pipelines.
* Allow **environment-specific overrides** using `.tfvars` files or environment variables.

---

### ⚙️ Types of Variables

| Type                | Description                                | Example                                                       |
| ------------------- | ------------------------------------------ | ------------------------------------------------------------- |
| **Input Variables** | Accept user-provided input                 | `variable "region" { default = "us-east-1" }`                 |
| **Local Values**    | Internal constants or computed expressions | `locals { env_prefix = "${var.env}-app" }`                    |
| **Output Values**   | Exported values after apply                | `output "instance_ip" { value = aws_instance.web.public_ip }` |

---

### ⚙️ Variable Declaration

Create in a file like `variables.tf`:

```hcl
variable "region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
```

Use in code:

```hcl
provider "aws" {
  region = var.region
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
}
```

---

### ⚙️ Variable Types

| Type       | Example                                   | Description                   |
| ---------- | ----------------------------------------- | ----------------------------- |
| **string** | `"t3.micro"`                              | Text value                    |
| **number** | `3`, `8080`                               | Numeric value                 |
| **bool**   | `true` / `false`                          | Boolean                       |
| **list**   | `["us-east-1", "us-west-2"]`              | Ordered sequence              |
| **map**    | `{ dev = "t3.micro", prod = "t3.large" }` | Key/value dictionary          |
| **object** | `{ name = string, size = number }`        | Structured complex data       |
| **tuple**  | `[string, number]`                        | Fixed sequence of mixed types |

Example (map variable):

```hcl
variable "instance_types" {
  type = map(string)
  default = {
    dev  = "t3.micro"
    prod = "t3.medium"
  }
}

resource "aws_instance" "web" {
  instance_type = var.instance_types[var.env]
}
```

---

### ⚙️ Variable Defaulting & Precedence Order

Terraform reads variables in this order (lowest → highest precedence):

| Priority | Source                          | Example                                   |
| -------- | ------------------------------- | ----------------------------------------- |
| 1️⃣      | Default in `.tf`                | `default = "us-east-1"`                   |
| 2️⃣      | `.tfvars` or `terraform.tfvars` | `region = "us-west-2"`                    |
| 3️⃣      | `-var` or `-var-file` flag      | `terraform apply -var="region=eu-west-1"` |
| 4️⃣      | Environment variable            | `export TF_VAR_region=ap-south-1`         |

Example:

```bash
terraform apply -var-file="dev.tfvars"
```

`dev.tfvars`

```hcl
region         = "us-east-2"
instance_type  = "t3.micro"
```

---

### ⚙️ Environment Variables

Prefix with `TF_VAR_` for Terraform to pick up automatically:

```bash
export TF_VAR_region=us-west-2
export TF_VAR_instance_type=t3.medium
terraform apply
```

---

### ⚙️ Validation Rules

You can validate variable values using **validation blocks**:

```hcl
variable "instance_type" {
  description = "Allowed EC2 instance types"
  type        = string

  validation {
    condition     = contains(["t3.micro", "t3.small", "t3.medium"], var.instance_type)
    error_message = "Instance type must be t3.micro, t3.small, or t3.medium."
  }
}
```

---

### ⚙️ Locals (Derived Variables)

Use `locals` for calculated or derived values:

```hcl
locals {
  env_tag = "${var.env}-service"
  subnet  = var.env == "prod" ? "subnet-prod" : "subnet-dev"
}
```

Use in resources:

```hcl
tags = {
  Name = local.env_tag
}
```

---

### ⚙️ Outputs (Complementary to Variables)

Output values show useful results after apply:

```hcl
output "instance_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.web.public_ip
}
```

---

### ✅ Best Practices

* 📦 **Separate `variables.tf`** for clarity.
* ⚙️ **Use `.tfvars`** for environment-specific values (`dev.tfvars`, `prod.tfvars`).
* 🔐 **Never hardcode secrets** — use Vault, SSM, or environment variables.
* 🧪 **Validate inputs** using `validation` blocks.
* 🧩 **Use descriptive names & types** for maintainability.
* 🔁 **Use locals** to compute derived values instead of inline expressions everywhere.
* 📊 **Document variables** using `description`.

---

### 💡 In short

Terraform **variables** make configurations **reusable, parameterized, and flexible**.
They allow dynamic inputs through `.tfvars`, environment variables, or CI/CD pipelines — enabling consistent infra across environments without code duplication. ✅

---

---

## Q: What are Outputs in Terraform?

### 🧠 Overview

**Outputs** in Terraform are **exported values** that display important information after a successful `terraform apply` or can be **passed to other configurations, modules, or CI/CD pipelines**.
They act like **“return values”** for your infrastructure — showing results such as IP addresses, resource IDs, or connection URLs.

---

### ⚙️ Purpose of Outputs

* 📋 Display essential info (e.g., public IP, DB endpoint) after deployment.
* 🔗 Pass values between **modules** or **Terraform workspaces**.
* 🧰 Integrate outputs into CI/CD workflows for automation (e.g., Jenkins, GitHub Actions).
* 🧩 Debug or inspect computed infrastructure attributes.

---

### ⚙️ Syntax

```hcl
output "<NAME>" {
  value       = <EXPRESSION>
  description = "<OPTIONAL_DESCRIPTION>"
  sensitive   = <true|false>
}
```

| Attribute       | Description                                        |
| --------------- | -------------------------------------------------- |
| **name**        | Logical name of the output                         |
| **value**       | What Terraform should display/return               |
| **description** | (Optional) Explanation of the output               |
| **sensitive**   | Hide value in CLI/UI for secrets (default = false) |

---

### ⚙️ Example — Basic EC2 Output

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Public IP address of web instance"
  value       = aws_instance.web.public_ip
}
```

✅ **Result after `terraform apply`:**

```bash
Outputs:

instance_id = "i-0a1b2c3d4e5f6g7h8"
instance_public_ip = "3.112.45.67"
```

---

### ⚙️ Sensitive Outputs (for secrets)

Hide outputs like passwords or tokens from console and logs:

```hcl
output "db_password" {
  value     = random_password.db.result
  sensitive = true
}
```

CLI hides the value:

```bash
Outputs:

db_password = <sensitive>
```

> Still accessible programmatically (e.g., via `terraform output -json`), so protect your state file!

---

### ⚙️ How to View Outputs

| Command                   | Description                    |
| ------------------------- | ------------------------------ |
| `terraform output`        | Lists all outputs              |
| `terraform output <name>` | Shows a specific output        |
| `terraform output -json`  | JSON format (useful for CI/CD) |

Example:

```bash
terraform output instance_public_ip
terraform output -json | jq '.instance_public_ip.value'
```

---

### ⚙️ Passing Outputs Between Modules

**Parent module:**

```hcl
module "vpc" {
  source = "./modules/vpc"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
```

**Child module (modules/vpc/outputs.tf):**

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

✅ The parent can now reference:
`module.vpc.vpc_id`

---

### ⚙️ Example — Multi-Environment CI/CD

```bash
# Jenkinsfile snippet
stage('Deploy Infra') {
  steps {
    sh 'terraform apply -auto-approve'
    script {
      def ec2_ip = sh(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
      echo "Deployed instance available at ${ec2_ip}"
    }
  }
}
```

➡️ Jenkins retrieves the Terraform output dynamically and uses it for post-deploy actions (tests, notifications, etc.).

---

### ⚙️ Example — JSON output (for automation)

```bash
terraform output -json | jq '.instance_public_ip.value'
# Returns clean JSON, ideal for CI/CD pipelines or API integration.
```

---

### ✅ Best Practices

* 📋 **Always provide descriptions** for clarity.
* 🔒 **Mark sensitive outputs** (e.g., passwords, secrets).
* 🧾 **Use `terraform output -json`** in automation (structured, parseable).
* 🔗 **Expose only what’s necessary** — avoid leaking internal IDs or tokens.
* 📦 **Export module outputs** for reusability.
* 🧰 **Keep state secure** since outputs (especially sensitive ones) live inside it.

---

### 💡 In short

Terraform **outputs** expose key information from your infrastructure — such as IPs, URLs, or resource IDs — after `apply`.
They help connect modules, automate deployments, and display useful results while keeping sensitive data hidden. ✅

---
---

## Q: What is `terraform init` used for?

### 🧠 Overview

`terraform init` is the **first command** you run in any Terraform project.
It **initializes** your working directory — downloading required providers and modules, setting up the backend (state storage), and preparing Terraform for `plan` or `apply`.
Think of it as **“bootstrapping”** your Terraform environment.

---

### ⚙️ Purpose of `terraform init`

* 📦 **Download Providers** (e.g., AWS, Azure, GCP, Kubernetes).
* 🔗 **Initialize Backend** for storing Terraform state (local or remote like S3).
* 🧩 **Install Modules** (from local paths, Git, Terraform Registry, etc.).
* 🔍 **Validate Provider Versions** defined in `required_providers`.
* 🏗️ **Prepare Workspace** for execution (creates `.terraform/` directory).

---

### ⚙️ Syntax

```bash
terraform init [options]
```

Example:

```bash
terraform init
```

---

### ⚙️ Typical Output

```bash
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 5.0"...
- Installing hashicorp/aws v5.13.0...
- Installed hashicorp/aws v5.13.0 (signed by HashiCorp)

Terraform has been successfully initialized!
```

This confirms:
✅ Backend configured
✅ Providers installed
✅ Directory ready for use

---

### ⚙️ Common Flags

| Flag               | Purpose                                            | Example                                                              |
| ------------------ | -------------------------------------------------- | -------------------------------------------------------------------- |
| `-backend-config`  | Override backend settings                          | `terraform init -backend-config="bucket=my-tfstate-bucket"`          |
| `-reconfigure`     | Reinitialize backend (ignore saved config)         | `terraform init -reconfigure`                                        |
| `-upgrade`         | Upgrade provider/plugins to latest allowed version | `terraform init -upgrade`                                            |
| `-input=false`     | Disable interactive prompts (for CI/CD)            | `terraform init -input=false`                                        |
| `-from-module=URL` | Initialize new directory from a module             | `terraform init -from-module=git::https://github.com/org/module.git` |

---

### ⚙️ Example — AWS S3 Remote Backend Initialization

`backend.tf`

```hcl
terraform {
  backend "s3" {
    bucket         = "my-tfstate-prod"
    key            = "network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

Run:

```bash
terraform init
```

Terraform will:

1. Configure backend connection (S3 + DynamoDB).
2. Migrate any existing local state.
3. Lock state remotely to prevent concurrent applies.

---

### ⚙️ Example — Module Initialization

If your configuration references external modules:

```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
}
```

`terraform init` will:

* Download the VPC module from the Terraform Registry.
* Cache it inside `.terraform/modules`.

---

### ⚙️ What happens under the hood

After running `terraform init`, Terraform:

```
1. Reads configuration files (*.tf)
2. Determines providers & versions
3. Downloads provider binaries into .terraform/plugins
4. Installs and caches external modules (.terraform/modules)
5. Configures the backend for remote state
6. Validates everything is ready for plan/apply
```

Directory structure created:

```
.
├── main.tf
├── variables.tf
├── backend.tf
└── .terraform/
    ├── providers/
    ├── modules/
    └── terraform.tfstate (if local)
```

---

### ⚙️ CI/CD Example (Jenkins or GitHub Actions)

```bash
terraform init \
  -backend-config="bucket=mybucket" \
  -backend-config="key=env/dev/terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -input=false
```

Then:

```bash
terraform plan -out=tfplan
terraform apply tfplan
```

---

### ✅ Best Practices

* 🧩 Always run `terraform init` after:

  * Cloning a repo
  * Adding a new provider or module
  * Changing backend configuration
* 🔒 Use `-reconfigure` if you switch from local to remote backend.
* 🧱 Commit `.terraform.lock.hcl` (provider versions) for reproducibility.
* ⚙️ Automate initialization in CI pipelines before plan/apply.
* 🧾 Avoid manual edits inside `.terraform/` — it’s managed automatically.

---

### 💡 In short

`terraform init` = Terraform’s **setup command**.
It **downloads providers**, **initializes modules**, **configures backends**, and prepares the directory for execution — the very first step before running `plan` or `apply`. ✅

---
---

## Q: What does `terraform plan` do?

### 🧠 Overview

`terraform plan` is the **dry-run command** of Terraform.
It **previews** what changes Terraform *will make* to your infrastructure — **without actually applying them**.
It compares your `.tf` configuration files with the current **state file** and cloud provider’s real resources, then generates an **execution plan**.

---

### ⚙️ Purpose

`terraform plan` helps you:

* 🔍 **See exactly what will change** before deployment.
* ✅ **Review and approve** planned actions (Add, Change, Destroy).
* 🧾 **Detect drift** between config and actual infrastructure.
* ⚙️ **Generate a plan file** (`.tfplan`) for controlled apply in CI/CD.

---

### ⚙️ Syntax

```bash
terraform plan [options]
```

Common usage:

```bash
terraform plan
terraform plan -out=tfplan
terraform plan -var-file=prod.tfvars
terraform plan -destroy
```

---

### ⚙️ Example — AWS EC2 Instance

#### `main.tf`

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  tags = {
    Name = "web-server"
  }
}
```

#### Run:

```bash
terraform plan
```

#### Output:

```bash
Terraform will perform the following actions:

  # aws_instance.web will be created
  + resource "aws_instance" "web" {
      + ami           = "ami-0c55b159cbfafe1f0"
      + instance_type = "t3.micro"
      + tags = {
          + "Name" = "web-server"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

✅ **Meaning:**
Terraform will create **1 new EC2 instance**, no updates or deletions.

---

### ⚙️ Plan Actions Explained

| Symbol | Meaning                                | Example                    |
| ------ | -------------------------------------- | -------------------------- |
| `+`    | Resource will be **created**           | `+ aws_instance.web`       |
| `~`    | Resource will be **modified in-place** | `~ aws_s3_bucket.logs`     |
| `-`    | Resource will be **destroyed**         | `- aws_security_group.old` |
| `-/+`  | Resource will be **recreated**         | `-/+ aws_db_instance.db`   |

Example diff:

```bash
~ aws_instance.web
      instance_type: "t3.micro" => "t3.small"
```

Terraform plans to **modify** the instance type from micro → small.

---

### ⚙️ Save and Reuse Plan Files

Generate a plan for controlled apply:

```bash
terraform plan -out=tfplan
```

Then apply it later (ensures consistency):

```bash
terraform apply tfplan
```

> Useful in CI/CD: `plan` and `apply` run in separate pipeline stages with manual approval in between.

---

### ⚙️ Example — Destroy Plan

Preview what will be destroyed before teardown:

```bash
terraform plan -destroy
```

Output:

```
Plan: 0 to add, 0 to change, 3 to destroy.
```

---

### ⚙️ Plan with Variable Files

Specify input variables:

```bash
terraform plan -var-file="dev.tfvars"
```

Example `dev.tfvars`:

```hcl
instance_type = "t3.micro"
region        = "us-west-2"
```

---

### ⚙️ Real-world CI/CD Example (Jenkins)

```bash
terraform init -backend-config="env=prod"
terraform plan -var-file="prod.tfvars" -out=tfplan

# Send plan summary to Slack
PLAN_SUMMARY=$(terraform show -no-color tfplan | grep "Plan:")
slackSend channel: '#devops', message: "Terraform Plan: ${PLAN_SUMMARY}"

# Manual approval before apply
terraform apply tfplan
```

---

### ⚙️ Exit Codes (for automation)

| Exit Code | Meaning                                               |
| --------- | ----------------------------------------------------- |
| `0`       | No changes required                                   |
| `1`       | Error during planning                                 |
| `2`       | Changes are pending (resources to add/change/destroy) |

Used in pipelines for conditional logic:

```bash
terraform plan -detailed-exitcode || CODE=$?
if [ "$CODE" -eq 2 ]; then
  echo "Changes detected — approval required."
fi
```

---

### ✅ Best Practices

* 🧾 Always **run `plan` before `apply`** — never apply blind.
* 📦 Use `-out=tfplan` for reproducible apply (especially in CI/CD).
* 🔒 Review plans in PRs or with manual approvals.
* 🧩 Combine `terraform fmt` + `validate` + `plan` in pipeline.
* 🧰 Store plan artifacts (`tfplan`, JSON) securely in CI for traceability.
* 🚫 Never ignore warnings — they often signal drift or deprecations.

---

### 💡 In short

`terraform plan` = your **preview & safety check**.
It compares your desired configuration with existing infrastructure and shows exactly **what Terraform will change** — add, update, or destroy — **before applying**.
Use it before every deployment for safe, auditable IaC. ✅

---

---

## Q: What does `terraform apply` do?

### 🧠 Overview

`terraform apply` is the **execution command** in Terraform — it takes the plan you created and **applies it to real infrastructure**.
It creates, updates, or deletes resources to make your cloud environment match the configuration defined in your `.tf` files (or in a saved plan file like `tfplan`).

---

### ⚙️ Purpose

* 🚀 Executes the **actions proposed by `terraform plan`**.
* 🔄 Updates both your **infrastructure** and the **Terraform state**.
* 🔐 Supports **manual or automatic approval** (`-auto-approve`).
* 🧾 Ensures infrastructure is **idempotent and consistent** with your configuration.

---

### ⚙️ Syntax

```bash
terraform apply [options] [plan-file]
```

Common examples:

```bash
terraform apply                     # Interactive approval
terraform apply -auto-approve        # Skip confirmation (for CI/CD)
terraform apply tfplan               # Apply pre-saved plan file
terraform apply -var-file=prod.tfvars
```

---

### ⚙️ Example — AWS EC2 Instance

#### `main.tf`

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  tags = {
    Name = "web-server"
  }
}
```

#### Run:

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

#### Output:

```bash
Terraform will perform the following actions:

  # aws_instance.web will be created
  + resource "aws_instance" "web" {
      + ami           = "ami-0c55b159cbfafe1f0"
      + instance_type = "t3.micro"
      + tags = {
          + "Name" = "web-server"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

✅ Terraform provisions the instance and updates the **state file** to reflect the change.

---

### ⚙️ What Happens Internally

1. 🧩 **Reads** configuration (`.tf` files).
2. 🔍 **Compares** with current state file.
3. ⚙️ **Plans** changes (auto if no plan provided).
4. 🧠 **Asks for confirmation** (unless `-auto-approve`).
5. 🪄 **Executes API calls** via provider (e.g., AWS, Azure, GCP).
6. 🧾 **Updates state file** to reflect new resource statuses.

---

### ⚙️ Example — Automatic Approval (CI/CD)

In CI/CD (e.g., Jenkins, GitHub Actions), you don’t want interactive prompts:

```bash
terraform apply -auto-approve -var-file="prod.tfvars"
```

Used after `terraform plan -out=tfplan` step in pipelines.

---

### ⚙️ Example — Destroy via Apply

You can also trigger destruction through:

```bash
terraform apply -destroy
```

Equivalent to:

```bash
terraform destroy
```

---

### ⚙️ Example — Apply with Variables

```bash
terraform apply -var="region=us-west-2" -var="instance_type=t3.medium"
```

Or load from file:

```bash
terraform apply -var-file="staging.tfvars"
```

---

### ⚙️ State Update Example

After a successful apply:

* Terraform updates `terraform.tfstate`
* Records all resource metadata (IDs, ARNs, dependencies)
* Marks any destroyed or replaced resources as removed

You can inspect it:

```bash
terraform show
```

---

### ⚙️ Typical Workflow

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
terraform output
```

✅ This ensures a **predictable, auditable** deployment.

---

### ⚙️ Exit Codes

| Exit Code | Meaning                                  |
| --------- | ---------------------------------------- |
| `0`       | Apply completed successfully (no errors) |
| `1`       | Error occurred during apply              |
| `2`       | Reserved (plan only — not used in apply) |

Useful in CI/CD automation for conditional logic.

---

### ✅ Best Practices

* 🧾 Always run `terraform plan` before `apply` to review changes.
* 🔐 Use `-auto-approve` **only** in automated environments with reviews upstream.
* 🧩 Keep the **state file secure** (especially when using remote backend).
* 🧰 Use saved plan files (`terraform apply tfplan`) for reproducibility.
* 🚫 Never manually edit the state file.
* 🔁 Apply small, incremental changes rather than massive ones.
* 🧪 Validate your configuration before applying:

  ```bash
  terraform validate
  terraform fmt -check
  ```
* 🧱 Use versioned state backends (S3 + DynamoDB) for rollback protection.

---

### 💡 In short

`terraform apply` **executes** the infrastructure changes defined by your configuration —
creating, updating, or deleting resources to match your desired state.
It’s the step where “plan becomes reality” — **review, approve, and apply safely.** ✅

---

---

## Q: What is the Terraform State File?

### 🧠 Overview

The **Terraform state file** (`terraform.tfstate`) is Terraform’s **single source of truth** about your deployed infrastructure.
It records the **current state** of all managed resources — mapping what Terraform *thinks* exists to what actually exists in the real cloud environment.
Without it, Terraform wouldn’t know which resources to update, destroy, or leave unchanged.

---

### ⚙️ Purpose

Terraform state serves as a **bridge between your configuration (`.tf`) and real infrastructure**.

| Function                                    | Description                                                                 |
| ------------------------------------------- | --------------------------------------------------------------------------- |
| 🧩 **Mapping**                              | Links Terraform resources → real-world cloud resources (e.g., AWS EC2 IDs). |
| 🔁 **Tracking changes**                     | Detects drift between config and deployed infra.                            |
| ⚙️ **Dependency management**                | Tracks relationships (e.g., subnet depends on VPC).                         |
| 🚀 **Performance optimization**             | Caches metadata to avoid frequent API calls.                                |
| 🔒 **Source of truth for `plan` & `apply`** | Terraform reads & updates it every run.                                     |

---

### ⚙️ Example — State File Structure (Simplified)

```json
{
  "version": 4,
  "terraform_version": "1.8.5",
  "resources": [
    {
      "mode": "managed",
      "type": "aws_instance",
      "name": "web",
      "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
      "instances": [
        {
          "attributes": {
            "id": "i-0a123b456c789d012",
            "ami": "ami-0c55b159cbfafe1f0",
            "instance_type": "t3.micro",
            "tags": { "Name": "web-server" }
          }
        }
      ]
    }
  ]
}
```

✅ **Key Point:**

* Terraform uses this file to understand *what exists* before every `plan` or `apply`.

---

### ⚙️ State File Location Options

| Type                             | Description                                                               |
| -------------------------------- | ------------------------------------------------------------------------- |
| **Local (default)**              | Stored in the current working directory as `terraform.tfstate`.           |
| **Remote backend (recommended)** | Stored in cloud storage like AWS S3, GCS, Azure Blob, or Terraform Cloud. |

Example:

```bash
terraform.tfstate
.terraform/
```

---

### ⚙️ Why Use Remote State (Production Best Practice)

Local state is fine for testing, but **remote state** is essential for teams.

| Benefit              | Description                                                 |
| -------------------- | ----------------------------------------------------------- |
| 🔒 **Locking**       | Prevents concurrent applies (e.g., using DynamoDB with S3). |
| 👥 **Collaboration** | Shared state across multiple users/pipelines.               |
| 💾 **Backups**       | Stored safely in cloud storage.                             |
| 🧾 **Auditability**  | Versioned and traceable (e.g., S3 object versions).         |

---

### ⚙️ Example — Remote State with AWS S3 + DynamoDB

`backend.tf`

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-states"
    key            = "network/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

#### Initialize backend:

```bash
terraform init
```

This:

* Creates/uses the `my-terraform-states` S3 bucket for state storage.
* Uses DynamoDB for **state locking** (prevents race conditions).
* Automatically uploads state updates after every `apply`.

---

### ⚙️ Locking Behavior Example

When two users try `terraform apply` simultaneously:

```
Error: Error acquiring the state lock
```

✅ The DynamoDB lock prevents both from modifying the state at the same time.

---

### ⚙️ Commands to Inspect and Manage State

| Command                           | Description                                        |
| --------------------------------- | -------------------------------------------------- |
| `terraform state list`            | Show all tracked resources                         |
| `terraform state show <resource>` | Display details for one resource                   |
| `terraform state mv`              | Move resource within state (rename or refactor)    |
| `terraform state rm`              | Remove resource from state (stop tracking)         |
| `terraform state pull`            | View full raw state JSON                           |
| `terraform state push`            | Manually upload modified state (use with caution!) |

Example:

```bash
terraform state list
# aws_instance.web
terraform state show aws_instance.web
```

---

### ⚙️ Drift Detection via State

Terraform uses state to detect **drift** — when real infrastructure changes outside Terraform:

```bash
terraform plan
```

If someone manually modified or deleted a resource, Terraform shows:

```bash
~ aws_s3_bucket.logs
    tags.Name: "old-name" => "new-name"
```

✅ You can fix drift by reapplying or importing updated resources.

---

### ⚙️ State and `terraform import`

If resources were created manually:

```bash
terraform import aws_instance.web i-0abcd12345ef6789
```

Terraform adds the resource to state without recreating it.

---

### ⚙️ Sensitive Data in State (⚠️ Important)

* The state file may contain **sensitive data** (e.g., passwords, access keys).
* Always:

  * 🔒 Encrypt state (S3 encryption, Vault, etc.).
  * 🧾 Restrict access via IAM.
  * 🧰 Avoid committing it to Git!
  * 🧹 Add to `.gitignore`:

    ```bash
    terraform.tfstate
    terraform.tfstate.backup
    ```

---

### ✅ Best Practices

* 📦 **Use remote backends** (S3, Terraform Cloud, etc.).
* 🔒 **Enable encryption & locking**.
* 👥 **Do not share local state files manually**.
* 🧾 **Never commit state files to version control**.
* ⚙️ **Backup & version** your state automatically (e.g., via S3 versioning).
* 🧩 **Use workspaces** or separate state files per environment (`dev`, `staging`, `prod`).
* 🧰 **Run `terraform state list`** periodically to ensure tracking consistency.

---

### 💡 In short

The **Terraform state file** is the **truth record** of what Terraform manages — mapping configurations to actual infrastructure.
It ensures **accurate planning, updates, and destroys**, but must be **secured, versioned, and shared safely**.
👉 **Without state, Terraform can’t track or safely manage your infrastructure.** ✅

---

---

## Q: How to store Terraform state remotely?

### 🧠 Overview

Store Terraform state remotely to **share state across teams**, **enable locking**, **backup/versioning**, and **prevent concurrent `apply` conflicts**. Common remote backends: **S3 + DynamoDB** (AWS), **GCS** (GCP), **Azure Blob Storage**, and **Terraform Cloud/Enterprise**. Remote backends also support encryption, access control, and CI-friendly automation.

---

### ⚙️ Why remote state?

* 🔒 **Locking** to prevent race conditions (DynamoDB / built-in locks)
* 🧩 **Collaboration**: multiple users/CI share single source-of-truth
* 💾 **Durability & versioning** via cloud object storage (S3/GCS/Azure)
* 🔐 **Encryption at rest / in transit** and fine-grained IAM access
* 🧰 **Integrates with CI/CD** (init in pipeline, no local files)

---

### ⚙️ Backend examples & config

#### 1) AWS — **S3 + DynamoDB** (recommended for AWS)

`backend.tf`

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "envs/prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true               # AES256 / SSE
    dynamodb_table = "terraform-locks"  # for state locking
    acl            = "bucket-owner-full-control" # optional
  }
}
```

**Init / migrate**

```bash
terraform init -backend-config="bucket=my-terraform-state-bucket" \
               -backend-config="key=envs/prod/terraform.tfstate" \
               -backend-config="region=us-east-1"
# if migrating from local: terraform init will prompt to copy local state to remote
```

**DynamoDB table (for locking)**

```bash
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region us-east-1
```

**Minimal S3 IAM policy (producer/CI)**

```json
{
  "Version":"2012-10-17","Statement":[
    {"Effect":"Allow","Action":["s3:GetObject","s3:PutObject","s3:DeleteObject"],"Resource":"arn:aws:s3:::my-terraform-state-bucket/*"},
    {"Effect":"Allow","Action":["s3:ListBucket"],"Resource":"arn:aws:s3:::my-terraform-state-bucket"},
    {"Effect":"Allow","Action":["dynamodb:GetItem","dynamodb:PutItem","dynamodb:DeleteItem","dynamodb:Query"],"Resource":"arn:aws:dynamodb:us-east-1:123456789012:table/terraform-locks"}
  ]
}
```

---

#### 2) GCP — **GCS backend**

`backend.tf`

```hcl
terraform {
  backend "gcs" {
    bucket = "my-terraform-state-gcs"
    prefix = "envs/prod"   # path-like prefix
  }
}
```

**Init**

```bash
terraform init \
  -backend-config="bucket=my-terraform-state-gcs" \
  -backend-config="prefix=envs/prod"
```

**Notes**

* Use service account JSON via `GOOGLE_APPLICATION_CREDENTIALS` for CI.
* GCS supports object versioning for state history.

---

#### 3) Azure — **Azure Blob Storage backend**

`backend.tf`

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "tfstateaccount"
    container_name       = "tfstate"
    key                  = "envs/prod/terraform.tfstate"
  }
}
```

**Init**

```bash
terraform init \
  -backend-config="resource_group_name=rg-terraform" \
  -backend-config="storage_account_name=tfstateaccount" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=envs/prod/terraform.tfstate"
```

**Notes**

* Use a service principal for CI: `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`.
* Enable soft-delete/versioning on blob container.

---

#### 4) Terraform Cloud / Enterprise (native)

`backend.tf`

```hcl
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "my-org"
    workspaces { name = "project-prod" }
  }
}
```

**Init**

```bash
terraform login              # stores API token
terraform init
```

**Benefits**

* Built-in locking, VCS-driven runs, policy (Sentinel), team RBAC, state history, UI.

---

### ⚙️ CI/CD pattern (Jenkins / GitHub Actions)

* **Step 1:** `terraform init -input=false -backend-config=...`
* **Step 2:** `terraform plan -out=tfplan`
* **Step 3:** optionally `terraform apply tfplan` with approval
* **Use least-privileged credentials** injected from secrets manager / Jenkins Credentials.

Example (shell snippet)

```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
terraform init -input=false -backend-config="bucket=$BUCKET" -backend-config="region=$REGION"
terraform plan -var-file=$ENV.tfvars -out=tfplan
terraform apply -input=false -auto-approve tfplan
```

---

### ⚙️ State migration (local → remote)

1. Add backend block to config.
2. Run `terraform init` — Terraform prompts to migrate local state to the remote backend.
3. Confirm and verify with `terraform state list` and `terraform show`.

If you need non-interactive migration:

```bash
terraform init -migrate-state -backend-config="bucket=..." -input=false
```

---

### ✅ Best Practices & Hardening

| Practice                                                                  | Why                                    |
| ------------------------------------------------------------------------- | -------------------------------------- |
| 🧩 Use **remote backend + locking** (S3 + DynamoDB / Terraform Cloud)     | Prevent concurrent conflicting applies |
| 🔐 **Encrypt state** at rest & in transit                                 | State may contain secrets              |
| 🧾 **Enable versioning** on bucket/container                              | Recover previous state if needed       |
| 🔒 **Tight IAM** (least-privilege) for CI/service accounts                | Limit who/what can read/write state    |
| 🧰 **Store `.terraform.lock.hcl` in VCS**                                 | Reproducible provider versions         |
| 🧪 **Use separate state per environment** (workspaces or different keys)  | Avoid accidental cross-env changes     |
| 🔁 **Automate backups** and retention rules                               | Long-term recovery & audit trail       |
| 🧯 **Rotate credentials** used by CI to access backend periodically       | Security hygiene                       |
| 📜 **Audit & monitor access** to backend bucket/objects                   | Detect suspicious access               |
| 🔍 **Avoid storing secrets** in outputs if possible (or mark `sensitive`) | Reduce leakage risk                    |

---

### ⚙️ Troubleshooting tips

* **Lock acquisition error** → another apply is running; check DynamoDB locks or Terraform Cloud runs.
* **Permissions error** → verify IAM/service-principal has `GetObject/PutObject/ListBucket` and DynamoDB permissions.
* **State drift after migration** → run `terraform plan` to ensure remote state matches current infra.
* **State corruption** → restore prior object version from bucket versioning backup.

Commands:

```bash
terraform state list            # inspect remote state
terraform state pull > state.json  # download state JSON
terraform state push state.json    # push (use with caution)
```

---

### 💡 In short

Use a **remote backend** (S3+DynamoDB, GCS, Azure Blob, or Terraform Cloud) to **share, lock, and secure your state**. Configure backend in `backend` block, run `terraform init` to initialize/migrate, and enforce encryption, versioning, and least-privilege IAM so multiple users and CI pipelines can manage infrastructure reliably. ✅

---
---

## Q: How do you refresh the Terraform state?

### 🧠 Overview

Refreshing the Terraform state means **syncing Terraform’s state file (`terraform.tfstate`) with the actual infrastructure** in your cloud environment.
It updates Terraform’s knowledge of real-world resources — detecting drift (manual changes outside Terraform) and ensuring future `plan` or `apply` runs are accurate.

---

### ⚙️ Purpose

* 🔍 **Detect drift:** if someone manually changed or deleted a resource in AWS/Azure/GCP.
* 🧾 **Update attributes:** update IPs, tags, or metadata fetched from the provider.
* ⚙️ **Prepare for accurate planning:** ensures `terraform plan` reflects current state.
* 🧰 **Troubleshooting:** fix state mismatches before destroying or updating resources.

---

### ⚙️ Commands to refresh state

#### 1️⃣ **Automatic refresh (default behavior)**

Every time you run:

```bash
terraform plan
terraform apply
```

Terraform automatically refreshes state by querying the provider APIs.

> ✅ By default, `plan` always refreshes before showing diffs.

---

#### 2️⃣ **Manual refresh (explicit)**

```bash
terraform refresh
```

**Description:**

* Reads the current remote infrastructure via provider APIs.
* Updates the local or remote state file to match.
* Does **not** modify real resources — only updates state.

**Example:**

```bash
terraform refresh
```

Output:

```bash
aws_instance.web: Refreshing state... [id=i-0abc123def456]
aws_s3_bucket.logs: Refreshing state... [id=my-log-bucket]
```

✅ This updates the state file to reflect any out-of-band (manual) changes.

---

#### 3️⃣ **Refresh specific resource**

Use **target flag** if you only want to refresh a single resource:

```bash
terraform refresh -target=aws_instance.web
```

Useful for large states where you want to minimize API calls.

---

#### 4️⃣ **Refresh disabled during plan**

You can skip refresh during plan for faster CI/CD runs:

```bash
terraform plan -refresh=false
```

> ⚡ Use this when you *know* infra hasn’t drifted (e.g., short-lived test pipeline).

---

### ⚙️ Example Scenario

#### Case: EC2 instance type changed manually

You manually resized an EC2 instance in AWS Console from `t3.micro` → `t3.small`.

Run:

```bash
terraform refresh
```

Terraform updates its state to:

```bash
aws_instance.web.instance_type = "t3.small"
```

Now `terraform plan` shows **no diff** — Terraform knows about the change.

If you **don’t refresh**, Terraform still thinks it’s `t3.micro`, and the next apply may revert it.

---

### ⚙️ Refresh vs. Import vs. Plan

| Command             | Purpose                                                             |
| ------------------- | ------------------------------------------------------------------- |
| `terraform refresh` | Syncs existing tracked resources in state with provider APIs        |
| `terraform import`  | Adds *new* manually created resources into Terraform state          |
| `terraform plan`    | Compares refreshed state vs. configuration to show intended changes |

---

### ⚙️ Refresh and Remote State

If you use remote backends (e.g., S3, Terraform Cloud), the refreshed state is automatically updated remotely — no manual copy needed.

Example:

```bash
terraform refresh
# uploads refreshed state to remote S3 backend
```

---

### ⚙️ State Backup Behavior

Whenever the state is updated (including refresh), Terraform writes:

* `terraform.tfstate` — new state
* `terraform.tfstate.backup` — previous state backup (for rollback)

You can restore easily:

```bash
mv terraform.tfstate.backup terraform.tfstate
```

---

### ⚙️ Caution: When **not** to refresh

* 🚫 During critical apply operations (might conflict with locking).
* 🚫 If you’re working offline (no provider access).
* 🚫 When someone else has the lock on remote state — wait until it’s released.
* ⚠️ For deleted resources: refresh will remove them from state silently — be cautious!

---

### ✅ Best Practices

* 🔁 **Run `terraform refresh` or `terraform plan` regularly** in CI/CD to detect drift early.
* 🧾 **Review changes** after refresh — it might reflect manual edits you didn’t intend.
* 📦 **Store state remotely (S3, GCS, etc.)** so refreshed updates are shared.
* 🧱 **Use locking (DynamoDB/Terraform Cloud)** to avoid concurrent refresh conflicts.
* 🧩 **Combine refresh with import** when manually bringing in unmanaged resources.
* 🚫 **Never manually edit the state file** — always use `refresh` or `import`.

---

### 💡 In short

`terraform refresh` **updates your state file** to reflect the **current reality** in your cloud.
It doesn’t change your infrastructure — only synchronizes Terraform’s internal understanding, ensuring future `plan` and `apply` actions are accurate and safe. ✅

---

---

## Q: What’s `terraform destroy`?

### 🧠 Overview

`terraform destroy` is Terraform’s **tear-down command** — it **deletes all resources** defined in your Terraform configuration (and tracked in the state file).
It’s the **inverse of `terraform apply`**, used to safely and predictably **destroy infrastructure** while keeping state consistent.

---

### ⚙️ Purpose

* 🧹 **Remove** all managed infrastructure.
* 🔒 **Clean up** resources tracked in the state file.
* 🧾 **Decommission** environments (dev/test/staging).
* ⚙️ **Free up** cloud costs by destroying unused resources.

---

### ⚙️ Syntax

```bash
terraform destroy [options]
```

Common options:

```bash
terraform destroy
terraform destroy -auto-approve
terraform destroy -target=aws_instance.web
terraform destroy -var-file=prod.tfvars
```

---

### ⚙️ Example — Destroy AWS Infrastructure

#### `main.tf`

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
}
```

#### Destroy all:

```bash
terraform destroy
```

Terraform asks for confirmation:

```bash
Terraform will perform the following actions:
  - aws_instance.web

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

✅ Terraform deletes the EC2 instance and updates the state file.

---

### ⚙️ Automatic approval (non-interactive)

Used in CI/CD pipelines:

```bash
terraform destroy -auto-approve
```

> ⚠️ Use carefully — no confirmation prompt.

---

### ⚙️ Targeted destroy (specific resource only)

Destroy a single resource:

```bash
terraform destroy -target=aws_instance.web
```

Example output:

```
Plan: 0 to add, 0 to change, 1 to destroy.
```

✅ Only deletes `aws_instance.web`; other resources remain untouched.

---

### ⚙️ Destroy with variable files

To destroy specific environment:

```bash
terraform destroy -var-file=staging.tfvars
```

Or using environment variable:

```bash
export TF_VAR_env=dev
terraform destroy
```

---

### ⚙️ How it works internally

When you run `terraform destroy`:

1. Reads configuration (`.tf` files).
2. Loads **current state** (local or remote).
3. Compares configuration vs state.
4. Builds a plan — all resources marked for deletion (`-` actions).
5. Confirms or auto-approves.
6. Calls provider APIs to delete each resource.
7. Updates state file (removes deleted resources).

---

### ⚙️ Example — Partial Resource Lifecycle Control

You can prevent accidental deletion:

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "critical-logs"
  lifecycle {
    prevent_destroy = true
  }
}
```

If you try to destroy:

```
Error: Resource aws_s3_bucket.logs has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed.
```

✅ Terraform stops you from deleting critical infra accidentally.

---

### ⚙️ Remote State Handling

If using a remote backend (e.g., S3, Terraform Cloud):

* Terraform **locks** the state before destroy.
* Updates remote state once all deletions succeed.
* Prevents parallel destroys via DynamoDB lock or Terraform Cloud concurrency control.

---

### ⚙️ CI/CD Example

Example Jenkins/GitHub Actions cleanup job:

```bash
terraform init -input=false
terraform destroy -auto-approve -var-file="dev.tfvars"
```

Or selective cleanup after integration test:

```bash
terraform destroy -target=aws_instance.test -auto-approve
```

---

### ⚙️ Troubleshooting Tips

| Issue                         | Fix                                                       |
| ----------------------------- | --------------------------------------------------------- |
| **Lock acquisition error**    | Wait for current apply/destroy to finish (DynamoDB lock). |
| **Permission denied**         | Ensure CI user has delete permissions (IAM policy).       |
| **Orphaned resources remain** | Run `terraform refresh` or `terraform plan` to re-sync.   |
| **Dependent resource errors** | Delete dependencies first or remove dependency blocks.    |
| **Manual deletes**            | Run `terraform state rm` for already-removed resources.   |

---

### ✅ Best Practices

* 🔐 Use **`prevent_destroy`** for production-critical resources.
* 🧩 **Target destroy** specific resources for partial cleanup.
* 🧾 **Review plan carefully** before confirming destruction.
* 🧱 Run `terraform refresh` before destroy to ensure accurate state.
* 🧰 Always **backup your state** (`terraform.tfstate`) before major teardown.
* 🧪 Automate destroys for ephemeral test environments (short-lived).
* 🚫 Never use `-auto-approve` on prod manually — only through reviewed CI/CD jobs.

---

### 💡 In short

`terraform destroy` cleanly **removes all resources** Terraform manages, updating the state to match.
It’s your **safe teardown command** — perfect for **decommissioning environments**, cleaning up test infrastructure, or resetting deployments.
Use **cautiously** and **protect production with lifecycle rules**. ✅

---

---

## Q: Difference between `terraform fmt`, `terraform validate`, and `terraform plan`

### 🧠 Overview

These three Terraform commands are part of the **IaC quality and deployment workflow** — each serves a specific stage:

| Command              | Purpose                                           | Stage                  |
| -------------------- | ------------------------------------------------- | ---------------------- |
| `terraform fmt`      | Format `.tf` files (syntax style consistency)     | **Code cleanup**       |
| `terraform validate` | Check syntax & internal logic (static validation) | **Pre-deploy check**   |
| `terraform plan`     | Preview infra changes (execution plan)            | **Deployment preview** |

Together, they ensure your Terraform code is **clean**, **valid**, and **safe to apply**. ✅

---

### ⚙️ 1️⃣ `terraform fmt` — *Format & Standardize Code*

**Purpose:**
Auto-formats Terraform configuration files to follow HCL (HashiCorp Configuration Language) best practices.

**Usage:**

```bash
terraform fmt
```

**Options:**

```bash
terraform fmt -check    # Check formatting (no change)
terraform fmt -recursive # Format files in all subfolders
```

**Example:**
Before:

```hcl
resource "aws_instance" "web" {ami="ami-123" instance_type="t2.micro"}
```

After:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-123"
  instance_type = "t2.micro"
}
```

✅ **Used in CI pipelines** for style enforcement (`terraform fmt -check`).

---

### ⚙️ 2️⃣ `terraform validate` — *Syntax & Logic Validation*

**Purpose:**
Verifies that your Terraform configuration files are **syntactically valid** and **internally consistent**.

**Usage:**

```bash
terraform validate
```

**Checks performed:**

* Syntax correctness of `.tf` files.
* Provider & resource blocks are properly defined.
* Variable types and references are valid.
* No missing required arguments.
* Module references are resolvable (after `terraform init`).

**Example:**
If you reference a missing variable:

```bash
Error: Reference to undeclared input variable
  on main.tf line 8, in resource "aws_instance" "web":
  var.instance_type is not declared.
```

✅ Ensures configuration correctness **before planning/applying**.

> 💡 **Note:** Doesn’t contact cloud providers — it’s an offline check.

---

### ⚙️ 3️⃣ `terraform plan` — *Execution Plan (Preview Changes)*

**Purpose:**
Generates an **action plan** showing what Terraform will create, update, or destroy — without making changes.

**Usage:**

```bash
terraform plan
terraform plan -out=tfplan
```

**Output:**

```bash
Terraform will perform the following actions:

  # aws_instance.web will be created
  + resource "aws_instance" "web" {
      + ami           = "ami-0c55b159cbfafe1f0"
      + instance_type = "t3.micro"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

✅ Helps you **review and approve** infrastructure changes safely.

---

### ⚙️ Comparison Summary

| Command              | Function               | Validates Syntax | Checks Cloud State | Modifies Files | Makes Infra Changes |
| -------------------- | ---------------------- | ---------------- | ------------------ | -------------- | ------------------- |
| `terraform fmt`      | Formats `.tf` files    | ✅                | ❌                  | ✅              | ❌                   |
| `terraform validate` | Validates config logic | ✅                | ❌                  | ❌              | ❌                   |
| `terraform plan`     | Previews infra changes | ✅                | ✅                  | ❌              | ❌                   |

---

### ⚙️ Typical CI/CD Usage

```bash
terraform fmt -check           # Enforce consistent formatting
terraform validate             # Validate syntax and logic
terraform plan -out=tfplan     # Preview and save execution plan
```

Example Jenkins pipeline snippet:

```bash
stage('Terraform Validate') {
  steps {
    sh 'terraform fmt -check'
    sh 'terraform validate'
  }
}
stage('Terraform Plan') {
  steps {
    sh 'terraform plan -var-file=prod.tfvars -out=tfplan'
  }
}
```

---

### ✅ Best Practices

* 🧩 Run `fmt`, `validate`, and `plan` in CI before every merge or apply.
* ⚙️ Use `terraform fmt -check` in pre-commit hooks to enforce style.
* 🧾 Always review `terraform plan` output before `apply`.
* 🔒 Store `.tfplan` artifacts securely in CI/CD for audit trails.
* 🚫 Never skip `validate` — it catches most human mistakes early.

---

### 💡 In short

| Command                     | Purpose                                                        |
| --------------------------- | -------------------------------------------------------------- |
| 🧱 **`terraform fmt`**      | Formats and cleans up `.tf` files for consistent style.        |
| 🧠 **`terraform validate`** | Ensures Terraform config syntax and logic are correct.         |
| 🚀 **`terraform plan`**     | Previews what will change in your cloud — your safe “dry run.” |

Together, they form Terraform’s **pre-deploy safety net** — format → validate → plan → apply. ✅

---

---

## Q: How to import an existing AWS resource into Terraform?

### 🧠 Overview

`terraform import` lets you **bring existing (manually created) AWS resources** under Terraform management **without recreating them**.
It updates your **Terraform state file** to include the resource, so Terraform can track, plan, and modify it going forward — **no downtime or data loss**.

---

### ⚙️ Purpose

* 🧩 Adopt manually created infrastructure (e.g., via AWS Console or CLI).
* 🔄 Migrate unmanaged resources into Infrastructure as Code (IaC).
* ⚙️ Maintain a single Terraform-managed state for all infra.
* 🧾 Enable drift detection and consistent future changes.

---

### ⚙️ Syntax

```bash
terraform import <RESOURCE_TYPE>.<NAME> <RESOURCE_ID>
```

Example:

```bash
terraform import aws_instance.web i-0abcd1234ef567890
```

This imports the existing EC2 instance with ID `i-0abcd1234ef567890` into the Terraform resource `aws_instance.web`.

---

### ⚙️ Step-by-Step: Import an AWS Resource

#### 🧱 1. Define the resource in your `.tf` file

Terraform requires a **resource block** to know what type and name you’re importing.

Example (`main.tf`):

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  # No need to fill properties yet
}
```

> ⚠️ The configuration must contain the correct `resource` type and logical name (`aws_instance.web` here).

---

#### ⚙️ 2. Run the import command

```bash
terraform import aws_instance.web i-0abcd1234ef567890
```

Output:

```
aws_instance.web: Importing from ID "i-0abcd1234ef567890"...
aws_instance.web: Import prepared!
  Prepared aws_instance for import
aws_instance.web: Refreshing state... [id=i-0abcd1234ef567890]

Import successful!
```

✅ Terraform now records this instance in the **state file**.

---

#### 🧩 3. Verify imported resource

Check what’s now tracked:

```bash
terraform state list
```

Output:

```
aws_instance.web
```

Show details:

```bash
terraform state show aws_instance.web
```

---

#### 🧾 4. Update your `.tf` file to match actual attributes

The import only updates **state**, not your configuration.
You must manually **copy the values** from the imported resource into your `.tf` file.

Example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  tags = {
    Name = "my-imported-instance"
  }
}
```

> ⚠️ If attributes differ between `.tf` and real infra, Terraform will try to modify the resource on next `apply`.

---

#### 🧮 5. Validate and plan

Run:

```bash
terraform validate
terraform plan
```

You should see **no changes** if your `.tf` and the state match.

Output:

```
No changes. Infrastructure is up-to-date.
```

---

### ⚙️ Example — Import AWS S3 Bucket

```bash
terraform import aws_s3_bucket.logs my-company-logs
```

Configuration (`main.tf`):

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "my-company-logs"
}
```

---

### ⚙️ Example — Import Multiple Resources (Scripted)

For bulk imports:

```bash
for id in $(aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --output text); do
  terraform import aws_instance.ec2_${id} ${id}
done
```

---

### ⚙️ Common AWS Resource ID Formats

| AWS Resource   | Terraform Type       | Example ID                |
| -------------- | -------------------- | ------------------------- |
| EC2 Instance   | `aws_instance`       | `i-0abc12345def6789`      |
| S3 Bucket      | `aws_s3_bucket`      | `my-logs-bucket`          |
| VPC            | `aws_vpc`            | `vpc-0abc12345def6789`    |
| Subnet         | `aws_subnet`         | `subnet-0abc12345def6789` |
| Security Group | `aws_security_group` | `sg-0abc12345def6789`     |
| IAM Role       | `aws_iam_role`       | role-name                 |
| RDS Instance   | `aws_db_instance`    | db-instance-identifier    |
| ELB            | `aws_elb`            | `my-elb-name`             |

> 💡 You can always use the AWS CLI to list resource IDs before import.

---

### ⚙️ Example — Import via Module

If resource lives inside a module:

```bash
terraform import 'module.vpc.aws_vpc.main' vpc-0abc12345def6789
```

> Use quotes when importing module-scoped resources.

---

### ⚙️ Troubleshooting

| Error                                   | Reason / Fix                                                           |
| --------------------------------------- | ---------------------------------------------------------------------- |
| `Error: Resource not found`             | Wrong ID or region — verify via AWS CLI.                               |
| `Resource already managed`              | Resource already tracked in state — check with `terraform state list`. |
| `Provider not initialized`              | Run `terraform init` before importing.                                 |
| Resource attributes differ after import | Update `.tf` to match actual config, then re-run `plan`.               |

---

### ✅ Best Practices

* 🧩 Always **define resource blocks** before importing.
* 🧾 **Run `terraform state list`** to confirm import success.
* 🔍 **Run `terraform plan`** immediately after import to check drift.
* 🧱 **Align `.tf` attributes** to prevent accidental changes on next apply.
* 📦 **Commit `.tf` files**, but **never commit state files**.
* ⚙️ For **bulk imports**, script with `for` loops + AWS CLI.
* 🔒 Use the same **region and credentials** that created the resource.
* 🧰 Use **remote state backend** to sync imports across teams.

---

### 💡 In short

`terraform import` brings **existing AWS resources** under Terraform management **without recreating them**.
It updates the **state file** to include the resource, then you **manually align configuration** to match reality.
✅ Ideal for migrating manual AWS setups to fully managed IaC safely and incrementally.

---

---

## Q: How to handle sensitive data in Terraform?

### 🧠 Short summary

Treat secrets (API keys, DB passwords, tokens) as **first-class sensitive values**: do **not** hard-code them in `.tf` files or commit them to VCS. Use secret backends (Vault, AWS Secrets Manager/SSM), mark Terraform variables/outputs `sensitive = true`, secure remote state, enforce least-privilege IAM, and inject secrets at runtime from CI/CD in a way that never writes them to disk or logs. 🛡️

---

### ⚙️ Overview

* **Never** commit secrets or state to Git.
* Keep **state encrypted & remote** (S3 + SSE + DynamoDB locking / Terraform Cloud).
* Use **secret managers** (Vault, AWS Secrets Manager, SSM Parameter Store, Azure Key Vault) and fetch at runtime.
* Mark `variable`/`output` as `sensitive = true` so Terraform hides values in CLI/UI.
* Use short-lived credentials and strict IAM policies.
* Mask secrets in CI logs and use credential stores in Jenkins/GitHub Actions. ✅

---

### ⚙️ Practical patterns & examples

#### 1) Mark variables & outputs as sensitive

```hcl
variable "db_password" {
  type      = string
  sensitive = true
}

resource "aws_db_instance" "db" {
  allocated_storage    = 20
  instance_class       = "db.t3.micro"
  engine               = "postgres"
  username             = "admin"
  password             = var.db_password
}

output "db_endpoint" {
  value       = aws_db_instance.db.endpoint
  description = "DB endpoint (non-sensitive)"
}
```

* `terraform output` will hide `sensitive` outputs.
* Avoid printing `$var` in scripts/logs.

---

#### 2) Use Vault provider (example—best for dynamic, short-lived secrets)

```hcl
provider "vault" {
  address = var.vault_addr
  token   = var.vault_token    # inject token from env / CI
}

data "vault_generic_secret" "db" {
  path = "secret/data/prod/db"
}

resource "aws_db_instance" "db" {
  password = data.vault_generic_secret.db.data["password"]
}
```

* Store Vault token in CI secrets; prefer AppRole or OIDC for non-interactive auth.
* Vault issues short-lived creds — reduces blast radius.

---

#### 3) AWS Secrets Manager / SSM Parameter Store (recommended for AWS)

**Read secret via data source** (keeps secret out of commits):

```hcl
data "aws_secretsmanager_secret_version" "db_secret" {
  secret_id = "prod/db-credentials"
}

locals {
  db_password = jsondecode(data.aws_secretsmanager_secret_version.db_secret.secret_string)["password"]
}
```

* Ensure IAM role used by Terraform has `secretsmanager:GetSecretValue` only for necessary secrets.

---

#### 4) Inject via environment variables (CI-safe)

* Set `TF_VAR_*` in CI from secret store — Terraform reads them as variables without writing files.

```bash
# CI step (do not echo)
export TF_VAR_db_password="${{ secrets.DB_PASSWORD }}"
terraform apply -auto-approve
```

* In Jenkins use `withCredentials(...)` to map credentials to env vars and avoid printing.

---

#### 5) Avoid writing secrets into state / outputs

* Some providers *must* store secrets in state (e.g., DB password in resource attributes). Mitigate:

  * Use data sources to **read** secrets from the secret manager instead of storing them in TF config.
  * Mark outputs `sensitive = true`.
  * Limit IAM who can `terraform state pull`.

---

### 📋 Security & operational checklist

| Area               | Action                                                                          |
| ------------------ | ------------------------------------------------------------------------------- |
| Repo               | Add `terraform.tfstate` & `*.tfvars` to `.gitignore`                            |
| State              | Remote backend (S3/GCS/Azure/TFC) + encryption + versioning + locking           |
| Secrets store      | Use Vault / AWS Secrets Manager / Azure Key Vault / GCP Secret Manager          |
| Variable injection | Use CI secret stores → `TF_VAR_...` or provider auth, **never** files committed |
| Outputs            | Mark `sensitive = true`, avoid exposing tokens                                  |
| IAM                | Least-privilege roles for Terraform/CI — restrict Get/Put to required secrets   |
| Logs               | Mask secrets in CI; do not `echo $SECRET`                                       |
| Rotation           | Use short-lived creds & automated rotation where supported                      |
| Audit              | Enable access logs (CloudTrail, Vault audit) and alert on secret access         |

---

### ✅ CI/CD examples (safe patterns)

**GitHub Actions** (use secrets, parse output as JSON safely):

```yaml
- name: Terraform Init/Apply
  env:
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_KEY }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET }}
    TF_VAR_db_password: ${{ secrets.DB_PASSWORD }}
  run: |
    terraform init -input=false
    terraform plan -out=tfplan -input=false
    terraform apply -input=false -auto-approve tfplan
```

**Jenkins** (with Credentials Binding)

```groovy
withCredentials([string(credentialsId: 'db-pass', variable: 'DB_PASS')]) {
  sh '''
    export TF_VAR_db_password=$DB_PASS
    terraform init -input=false
    terraform apply -auto-approve
  '''
}
```

---

### 🔐 Hardening remote state (must-dos)

* Enable encryption (SSE for S3, CMEK if required).
* Enable bucket/object versioning to recover from corruption.
* Use DynamoDB for locks (S3 backend).
* Restrict who can `GetObject`/`PutObject` on state.
* Consider Terraform Cloud for RBAC & secure state storage if enterprise needs.

Example S3 policy snippet (minimum):

```json
{
  "Effect":"Allow",
  "Action":["s3:GetObject","s3:PutObject","s3:DeleteObject"],
  "Resource":"arn:aws:s3:::tf-state-bucket/*"
}
```

---

### ⚠️ Common pitfalls & how to avoid them

* **Never** store raw `.tfvars` with secrets in VCS — use CI secret injection.
* **Don’t** `echo` sensitive vars in scripts or logs.
* **Avoid** outputs that contain secrets (or mark sensitive).
* **Don’t** give Terraform full admin—grant only necessary privileges for infra + secret reads.
* **Be careful**: some providers write secrets into state (encrypt state & restrict access).

---

### 🔎 Recovery & incident response

* On secret compromise: rotate secrets immediately, update secret store + Terraform variables, re-run `apply`.
* Audit `terraform state` access; rotate backend credentials if leaked.
* Use versioned state to roll back to pre-compromise if needed.

---

### 💡 In short

Handle sensitive data by **never committing** it, **storing it in a secrets manager**, **injecting it at runtime** (CI env vars or provider auth), **marking Terraform variables/outputs as sensitive**, securing remote state (encrypted + locked), and enforcing least-privilege IAM & audit logging. These combined controls minimize leak surface and make rotation/recovery straightforward. ✅

---
---

## Q: How to target specific resources in Terraform apply?

### 🧠 Overview

Terraform’s **`-target`** flag lets you **apply or destroy only selected resources** instead of the entire configuration.
It’s useful for **incremental deployments**, **troubleshooting**, or **partial infrastructure updates** — while keeping the rest untouched. ⚙️

> ⚠️ Use cautiously — targeting skips dependency validation and can cause drift if misused.

---

### ⚙️ Syntax

```bash
terraform apply -target=<RESOURCE_ADDRESS>
```

You can target:

* A **specific resource**
* A **module**
* A **resource type** (less common)

---

### ⚙️ Examples

#### 🧩 Apply a single resource

```bash
terraform apply -target=aws_instance.web
```

✅ Only the EC2 instance `aws_instance.web` will be created or updated.

---

#### 🧩 Apply multiple resources

```bash
terraform apply \
  -target=aws_instance.web \
  -target=aws_security_group.web_sg
```

✅ Both the instance and its security group will be deployed, other resources skipped.

---

#### 🧩 Apply a resource inside a module

```bash
terraform apply -target=module.network.aws_vpc.main
```

✅ Applies only the VPC resource inside the `network` module.

---

#### 🧩 Apply a resource count or for_each element

```bash
terraform apply -target='aws_instance.app[0]'
terraform apply -target='aws_instance.app["dev"]'
```

---

#### 🧩 Apply for a specific environment via workspace

```bash
terraform workspace select dev
terraform apply -target=aws_s3_bucket.logs
```

---

### ⚙️ Plan + Apply with Target

Recommended safe workflow:

```bash
terraform plan -target=aws_instance.web -out=tfplan
terraform apply tfplan
```

✅ Always review the targeted plan before applying.

---

### ⚙️ Example Use Case — Fix or Deploy Partial Infra

Scenario: VPC + EC2 + RDS defined, but only EC2 failed in last run.

Instead of applying all again:

```bash
terraform apply -target=aws_instance.web
```

Terraform recreates only the EC2 resource.

---

### ⚙️ Destroy specific resources

Use `-target` with destroy:

```bash
terraform destroy -target=aws_security_group.web_sg
```

✅ Only removes the targeted security group.

---

### ⚙️ Example with Modules and Dependencies

Terraform automatically includes dependencies when needed:

```bash
terraform apply -target=aws_instance.web
```

If `aws_instance.web` depends on a subnet or VPC, Terraform **creates those dependencies** even if not explicitly targeted.

---

### ⚙️ Common Patterns in CI/CD

**Partial Apply Stage**

```bash
terraform plan -target=module.eks -out=tfplan
terraform apply -auto-approve tfplan
```

**Post-deployment Fix**

```bash
terraform apply -target=aws_lb_listener.frontend -auto-approve
```

---

### ⚠️ Warnings & Limitations

| Issue                                | Explanation / Fix                                                              |
| ------------------------------------ | ------------------------------------------------------------------------------ |
| ⚠️ **Partial graph**                 | Terraform might skip dependencies not in target → inconsistent infra           |
| ⚠️ **Drift risk**                    | Un-targeted resources won’t be updated → possible mismatch with desired config |
| ⚠️ **Temporary use only**            | Use for troubleshooting, not as permanent workflow                             |
| ⚙️ **Always re-run full plan later** | To re-sync state after partial applies                                         |

---

### ✅ Best Practices

* 🧩 Use `-target` **only when necessary** (debugging, incremental rollout).
* 🧾 Always run a **full `terraform plan`** after a targeted apply to revalidate all infra.
* ⚙️ **Include dependencies** if they’re not auto-detected.
* 🔒 **Don’t use in CI/CD** as the default apply strategy — better to separate infra by modules/states.
* 🧰 Use **modularization** or **separate workspaces** instead of heavy reliance on `-target`.

---

### 💡 In short

`terraform apply -target` lets you **deploy or update specific resources** selectively — great for **debugging or fixing failed applies**.
Use it **sparingly**, review the plan first, and **run a full plan afterward** to ensure infrastructure consistency. ✅

---

---

## Q: How to ignore resource changes in Terraform?

### 🧠 Overview

Terraform’s `lifecycle` block provides the **`ignore_changes`** argument, allowing you to **prevent Terraform from modifying certain attributes** of a resource — even if they differ from the configuration.
This is essential when **external systems or users** manage part of a resource’s configuration (e.g., tags, auto-scaling size, metadata).

---

### ⚙️ Purpose

Use `ignore_changes` when:

* 🔁 External systems (scripts, operators, console changes) modify attributes.
* 🧩 Terraform should **not overwrite** those changes during future applies.
* ⚙️ You want **partial management** of a resource — Terraform manages some attributes, ignores others.

---

### ⚙️ Syntax

```hcl
resource "<PROVIDER>_<TYPE>" "<NAME>" {
  # Configuration...

  lifecycle {
    ignore_changes = [<ATTRIBUTE_NAMES>]
  }
}
```

---

### ⚙️ Example 1️⃣ — Ignore Tag Changes

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  tags = {
    Name = "app-server"
    Env  = "prod"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
```

✅ Terraform **will not update the instance** if tags are changed manually in AWS Console.

---

### ⚙️ Example 2️⃣ — Ignore Specific Attribute

```hcl
resource "aws_autoscaling_group" "web_asg" {
  name                = "web-asg"
  desired_capacity     = 3
  min_size             = 1
  max_size             = 5
  launch_configuration = aws_launch_configuration.web_lc.name

  lifecycle {
    ignore_changes = [desired_capacity]
  }
}
```

✅ Terraform won’t reset `desired_capacity` when scaling is changed by AWS Auto Scaling policies or CloudWatch alarms.

---

### ⚙️ Example 3️⃣ — Ignore Multiple Attributes

```hcl
resource "aws_launch_template" "app" {
  name = "app-launch-template"

  instance_type = "t3.medium"
  tags = {
    Owner = "DevOps"
  }

  lifecycle {
    ignore_changes = [
      instance_type,
      tags["Owner"]
    ]
  }
}
```

✅ Terraform will not modify instance type or the `Owner` tag if they change externally.

---

### ⚙️ Example 4️⃣ — Ignore Entire Block

To ignore an entire nested block:

```hcl
lifecycle {
  ignore_changes = [user_data]
}
```

Useful when `user_data` contains dynamic values like timestamps or build numbers.

---

### ⚙️ Example 5️⃣ — Dynamic or Module Resources

Inside modules:

```hcl
module "ec2_app" {
  source = "./modules/ec2"
  ami_id = var.ami_id

  lifecycle {
    ignore_changes = [ami_id]
  }
}
```

> ⚠️ Only supported at **resource level**, not module root — define inside the module itself.

---

### ⚙️ Behavior in Practice

| Scenario                                   | Behavior                                                 |
| ------------------------------------------ | -------------------------------------------------------- |
| Resource attribute changed manually in AWS | Terraform will **not update** it                         |
| Resource drift detected by plan            | Plan ignores that attribute                              |
| Attribute changed in `.tf` config          | Terraform still ignores it (won’t apply)                 |
| Run `terraform refresh`                    | State updates but plan/apply still respects ignore rules |

---

### ⚙️ When to Avoid It

| Situation                                   | Why to Avoid                         |
| ------------------------------------------- | ------------------------------------ |
| You expect Terraform to control all aspects | It can cause **drift and confusion** |
| Used for temporary fix                      | Might **hide misconfigurations**     |
| Applied on too many attributes              | Makes IaC less deterministic         |

---

### ✅ Best Practices

* ⚙️ Use `ignore_changes` **only for externally controlled attributes** (like scaling metrics).
* 🧩 Add comments explaining **why** it’s ignored.
* 🔍 Run `terraform plan` periodically — ensure you’re not ignoring critical drift.
* 🧾 Combine with **`prevent_destroy = true`** for extra safety if ignoring destructive attributes.
* 🧰 Document ignored attributes in module README.
* 🚫 Avoid using `ignore_changes = all` — too risky.

---

### ⚙️ Example — Safe Lifecycle Block

```hcl
lifecycle {
  create_before_destroy = true
  prevent_destroy       = true
  ignore_changes        = [desired_capacity, tags]
}
```

✅ This combination ensures:

* Resource recreation safety (`create_before_destroy`)
* Accidental deletion prevention (`prevent_destroy`)
* External attribute tolerance (`ignore_changes`)

---

### 💡 In short

Use `ignore_changes` inside a resource’s `lifecycle` block to **tell Terraform to skip updating certain attributes** — perfect for resources partially managed by other systems.
🔐 Use it sparingly, document it clearly, and revalidate regularly to avoid silent drift. ✅

---

---

## Q: What’s the Difference Between `count` and `for_each` in Terraform?

### 🧠 Overview

Both `count` and `for_each` let you **create multiple instances of a resource or module dynamically**, instead of writing repetitive blocks.
They differ in **input type**, **indexing behavior**, and **how you reference individual resources**.

---

### ⚙️ Summary Table

| Feature                 | `count`                             | `for_each`                                       |
| ----------------------- | ----------------------------------- | ------------------------------------------------ |
| **Purpose**             | Create multiple identical resources | Create multiple unique resources (map/set-based) |
| **Input Type**          | Number (integer)                    | Map or Set (of strings or objects)               |
| **Index Reference**     | Uses numeric index (`count.index`)  | Uses key name (`each.key`, `each.value`)         |
| **Best For**            | Simple lists / fixed quantities     | Complex data (maps, objects)                     |
| **Resource Addressing** | `resource.name[count.index]`        | `resource.name["key"]`                           |
| **Diff Detection**      | Recreates all if list order changes | Stable (based on keys)                           |
| **Output Style**        | Indexed list                        | Map (keyed by `each.key`)                        |
| **Flexibility**         | Simpler, but less readable          | More expressive and maintainable                 |

---

### ⚙️ Example 1️⃣ — Using `count` (Index-based)

```hcl
variable "instance_names" {
  default = ["app1", "app2", "app3"]
}

resource "aws_instance" "web" {
  count         = length(var.instance_names)
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  tags = {
    Name = var.instance_names[count.index]
  }
}
```

✅ **Creates 3 EC2 instances**:
`aws_instance.web[0]`, `aws_instance.web[1]`, `aws_instance.web[2]`

Reference example:

```hcl
output "first_instance_id" {
  value = aws_instance.web[0].id
}
```

> ⚠️ If you reorder `instance_names`, Terraform **destroys and recreates** instances — index-based mapping.

---

### ⚙️ Example 2️⃣ — Using `for_each` (Key-based)

```hcl
variable "instances" {
  default = {
    app1 = "t3.micro"
    app2 = "t3.small"
    app3 = "t3.medium"
  }
}

resource "aws_instance" "web" {
  for_each      = var.instances
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = each.value

  tags = {
    Name = each.key
  }
}
```

✅ Creates **3 EC2 instances**:

* `aws_instance.web["app1"]`
* `aws_instance.web["app2"]`
* `aws_instance.web["app3"]`

Reference example:

```hcl
output "app2_id" {
  value = aws_instance.web["app2"].id
}
```

> ✅ Adding or removing keys **only affects those specific instances** — no mass recreation.

---

### ⚙️ Example 3️⃣ — `for_each` with Sets

```hcl
variable "regions" {
  default = toset(["us-east-1", "us-west-2"])
}

resource "aws_s3_bucket" "multi_region" {
  for_each = var.regions
  bucket   = "my-bucket-${each.key}"
}
```

Terraform automatically treats set elements as keys.

---

### ⚙️ Example 4️⃣ — Module usage

```hcl
module "network" {
  source = "./modules/vpc"
  for_each = {
    dev  = "10.0.0.0/16"
    prod = "10.1.0.0/16"
  }

  cidr_block = each.value
}
```

✅ Deploys one VPC per environment (`dev`, `prod`).

---

### ⚙️ Resource Referencing Differences

| Operation                  | `count`                         | `for_each`                 |
| -------------------------- | ------------------------------- | -------------------------- |
| Reference                  | `aws_instance.web[count.index]` | `aws_instance.web["app1"]` |
| Output Type                | List                            | Map                        |
| Add/remove order-sensitive | ✅ Yes                           | ❌ No                       |
| Rename or key changes      | Forces full recreation          | Affects only changed key   |

---

### ⚙️ When to Use Which

| Use Case                                                 | Recommended |
| -------------------------------------------------------- | ----------- |
| Same configuration for all instances                     | `count`     |
| Each resource has unique attributes (tags, sizes, names) | `for_each`  |
| You need stable references (independent of list order)   | `for_each`  |
| You want to loop through a list without unique keys      | `count`     |
| You want fine-grained adds/removes without recreation    | `for_each`  |

---

### ⚙️ Example: Why `for_each` is safer than `count`

If using `count`:

```hcl
["app1", "app2", "app3"] → remove app1 → ["app2", "app3"]
```

Terraform sees indexes shifted → destroys/recreates all instances. ❌

If using `for_each`:

```hcl
{ app1, app2, app3 } → remove app1
```

Terraform destroys **only `app1`**, keeps others intact. ✅

---

### ✅ Best Practices

* 🧩 Prefer `for_each` for **maps and sets** — stable keys, predictable diffs.
* 🧾 Use `count` only for **homogeneous** or simple resource lists.
* 🧰 Avoid mixing `count` and `for_each` on the same resource type.
* 🔍 Use `toset()` or `tomap()` conversions for flexibility.
* 🧪 For safety: test plan output before switching between them — switching changes state resource addresses.
* 📦 Document the iteration logic for maintainability.

---

### 💡 In short

| Feature     | `count`                 | `for_each`                       |
| ----------- | ----------------------- | -------------------------------- |
| Input       | Number                  | Map or Set                       |
| Index       | Numeric (`count.index`) | Key (`each.key`, `each.value`)   |
| Diff Safety | Sensitive to list order | Stable per key                   |
| Use Case    | Identical resources     | Unique configurations            |
| Example     | Create 3 EC2s           | Create EC2s with different types |

👉 Use **`for_each`** for flexibility & safety, and **`count`** for simple loops. ✅

---

---

# Q: How to manage multiple environments (dev / stage / prod)

### 🧠 Short summary

Manage environments by **separating state** (per-env backends or Terraform Cloud workspaces), **reusing modules** for DRY infrastructure, and **parameterizing** differences with `*.tfvars` / variables. Automate via CI/CD (build once → promote), enforce approvals for sensitive envs, secure secrets per-environment, and always test changes in non-prod before prod.

---

## ✅ Strategies (high-level comparison)

|                                               Strategy | When to use                                            | Pros                                        | Cons                                                     |
| -----------------------------------------------------: | ------------------------------------------------------ | ------------------------------------------- | -------------------------------------------------------- |
|                 **Separate directories/repos per env** | Strict separation, different teams/accounts            | Clear isolation, simple backends per env    | Duplication unless modules used                          |
| **Single repo + tfvars + backend per env (init time)** | Small infra, same account                              | Low friction, easy variable override        | Care with state backend config                           |
|                               **Terraform Workspaces** | Lightweight environment variants (short-lived or test) | Easy switching `terraform workspace select` | Not ideal for different accounts/major infra differences |
|            **Terraform Cloud / Enterprise workspaces** | Team-scale, remote runs, policy enforcement            | Built-in locking, RBAC, VCS-driven runs     | Requires TF Cloud (paid features for enterprise)         |
|                    **Separate repos + shared modules** | Large org / strict CI/CD                               | Strong isolation, per-repo CI controls      | More repo maintenance                                    |

---

## ⚙️ Recommended pattern (practical, scalable)

1. **Create reusable modules** (`modules/`) for VPC, EKS, RDS, etc. ✅
2. **Keep one repo for modules** and one repo for each application/environment layout or a mono-repo with env dirs. 🧩
3. **Use a remote backend** per environment (S3 key / Azure blob / GCS / Terraform Cloud). 🔒
4. **Parameterize env differences** with `dev.tfvars`, `stage.tfvars`, `prod.tfvars`. 📝
5. **CI/CD pipeline per repo**: `plan` in PR → apply to `dev` on merge → manual approval to promote to `prod`. 🔁
6. **Store secrets in secret manager** (Vault / AWS Secrets Manager / SSM) and inject via CI (never in VCS). 🔐

---

## ⚙️ Example layout & files

```
infra/
├─ modules/
│  ├─ vpc/
│  ├─ eks/
│  └─ rds/
├─ live/
│  ├─ dev/
│  │  ├─ main.tf
│  │  ├─ backend.tf
│  │  └─ terraform.tfvars
│  ├─ staging/
│  │  ├─ backend.tf
│  │  └─ terraform.tfvars
│  └─ prod/
│     ├─ backend.tf
│     └─ terraform.tfvars
```

`live/dev/main.tf` (module usage)

```hcl
module "vpc" {
  source = "../../modules/vpc"
  cidr   = var.vpc_cidr
  tags   = local.common_tags
}
```

`live/prod/terraform.tfvars`

```hcl
vpc_cidr = "10.0.0.0/16"
instance_type = "m5.large"
environment = "prod"
```

---

## ⚙️ Remote backend per environment (S3 + DynamoDB example)

**backend-prod.tf**

```hcl
terraform {
  backend "s3" {}
}
```

Initialize with env-specific backend-config (do not hardcode secrets):

```bash
terraform init \
  -backend-config="bucket=my-tfstate-bucket" \
  -backend-config="key=prod/infra/terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -input=false
```

Do the same for `dev` / `staging` with different `key` paths. Use DynamoDB table for locking:

```bash
# create lock table (once)
aws dynamodb create-table --table-name terraform-locks --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```

> 🔐 Keep IAM policies scoped to allowed S3 key prefixes per environment.

---

## ⚙️ Using Terraform Workspaces (when appropriate)

Good for small differences (feature branches, ephemeral infra):

```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace select dev

terraform plan -var-file=env/${workspace}.tfvars
```

**Caveat:** Workspaces share the same config and backend unless you change backend; not recommended for separate cloud accounts or drastically different infra.

---

## ⚙️ CI/CD Promotion Flow (Jenkins / GitHub Actions example)

**Flow:** PR → `terraform plan` in PR environment → merge → apply to `dev` → smoke tests → manual approval → apply to `staging/prod`.

Jenkinsfile snippet (simplified)

```groovy
stage('Terraform Init') {
  steps {
    sh '''
      terraform init -backend-config="key=${ENV}/infra.tfstate" -input=false
    '''
  }
}
stage('Plan') {
  steps {
    sh 'terraform plan -var-file=${ENV}.tfvars -out=tfplan'
    sh 'terraform show -json tfplan > tfplan.json'
  }
}
stage('Apply (Dev)') {
  when { expression { return env.ENV == 'dev' } }
  steps { sh 'terraform apply -auto-approve tfplan' }
}
stage('Promote to Prod') {
  steps {
    input message: "Promote to prod?", submitter: 'release-managers'
    sh 'terraform apply -var-file=prod.tfvars -auto-approve'
  }
}
```

---

## ⚙️ Secrets & Credentials per environment

* **Never** store secrets in `*.tfvars` in VCS.
* Use CI to export `TF_VAR_*` from secrets store:

  ```bash
  export TF_VAR_db_password=$SECRET_FROM_VAULT
  terraform apply -var-file=prod.tfvars -auto-approve
  ```
* For provider auth, prefer role/assume-role per environment (AWS) instead of long-lived keys.

---

## ⚙️ Multi-account & Multi-region

* Use provider aliases and per-env provider configuration, or better: run each env in its own AWS account with cross-account roles:

```hcl
provider "aws" {
  alias  = "prod"
  region = "us-east-1"
  assume_role {
    role_arn = var.prod_role_arn
  }
}
```

* Keep state isolated to avoid cross-env accidental changes.

---

## ✅ Practical checklist & best practices

* 🧩 **Modularize**: build reusable modules and version them.
* 🔒 **Isolate state**: one backend key / workspace per env.
* 🔁 **Build once, promote**: use immutable artifacts (AMI/image digests).
* 🛡️ **Gate prod**: require human approval + tests before apply.
* 🔑 **Secrets**: use Vault / Secrets Manager and inject at runtime.
* 🧪 **Test infra changes** in dev/staging before prod.
* 🧾 **Tag & name** resources with env and owner metadata.
* 🧰 **CI jobs** per env with least-privilege credentials.
* 🔍 **Audit & logging**: enable cloud logs and state access audit.
* 🧯 **Backups & versioning**: enable bucket object versioning for state.
* ♻️ **Avoid overuse of workspaces** for production-critical multi-account infra.

---

## ⚠️ Common pitfalls

* Using the same backend key for all envs → catastrophic cross-env changes.
* Committing `*.tfstate` or secrets to Git.
* Relying on workspaces for isolated accounts (use separate backends/accounts instead).
* Applying to prod without approval/tests.

---

### 💡 In short

Manage environments by **separating state per environment**, **reusing versioned modules**, and **parameterizing with tfvars**. Automate `plan` → `apply` in CI with promotion gates for staging/prod, secure secrets via secret managers, and enforce least-privilege access to state and providers. This gives reproducible, auditable, and safe multi-environment infrastructure. ✅

---
## Q: What’s the difference between `terraform state rm` and `terraform taint`?

---

### 🧠 Overview

Both commands modify Terraform state, but they serve **different purposes**:

* `terraform taint` marks a resource for **recreation** in the next apply.
* `terraform state rm` **removes** a resource from state (Terraform “forgets” it), without touching real infrastructure.

---

### ⚙️ Purpose / How It Works

| Command              | Purpose                                                                              | Effect on State                        | Effect on Actual Resource               |
| -------------------- | ------------------------------------------------------------------------------------ | -------------------------------------- | --------------------------------------- |
| `terraform taint`    | Marks a resource as tainted so Terraform destroys and recreates it during next apply | Keeps it in state but marks as tainted | Resource is **recreated**               |
| `terraform state rm` | Deletes the resource entry from state file                                           | Removes from state file completely     | Resource remains **untouched** in cloud |

---

### 🧩 Examples / Commands / Config Snippets

#### 🔹 Example: Using `terraform taint`

```bash
# Mark resource for recreation
terraform taint aws_instance.web_server

# Apply will destroy and recreate it
terraform apply
```

**Use case:** When an EC2 instance becomes corrupted or misconfigured, but resource definition hasn’t changed.

---

#### 🔹 Example: Using `terraform state rm`

```bash
# Remove from state (Terraform forgets it)
terraform state rm aws_instance.web_server

# Resource still exists in AWS, but Terraform won’t manage it anymore
terraform apply
```

**Use case:** When a resource was manually deleted or needs to be imported again using `terraform import`.

---

### 📋 Comparison Table

| Aspect                   | `terraform taint`      | `terraform state rm`       |
| ------------------------ | ---------------------- | -------------------------- |
| Purpose                  | Force recreation       | Remove from state          |
| Changes infra?           | Yes (on apply)         | No                         |
| Keeps resource in state? | Yes                    | No                         |
| Next `apply` behavior    | Destroys and recreates | Ignores the resource       |
| Typical use case         | Rebuild broken infra   | Fix drift or import issues |

---

### ✅ Best Practices

* Use `taint` when a resource **needs to be recreated** safely by Terraform.
* Use `state rm` when resource was **manually deleted**, corrupted in state, or you’ll **import it again**.
* Always **backup your state file** before removing entries.
* After using `state rm`, run `terraform import` to reattach if needed.

---

### 💡 In short

* 🧩 `taint` → marks for **recreation** on next apply.
* 🧩 `state rm` → **forgets** the resource without destroying it.
* Use `taint` to fix bad infra; use `state rm` to fix bad state.

---
## Q: How to use modules in Terraform?

---

### 🧠 Overview

Terraform **modules** let you organize and reuse infrastructure code efficiently.
A module is simply a directory with `.tf` files that define related resources — like a reusable building block (e.g., “VPC”, “EKS Cluster”, “S3 bucket setup”).

You can:

* Reuse the same configuration across environments.
* Share code internally (via local path or Git/Nexus/S3).
* Simplify large projects with modular structure.

---

### ⚙️ Purpose / How It Works

1. **Define a module** (reusable component).
2. **Call the module** from your main Terraform config.
3. Pass **inputs** and consume **outputs**.

Terraform automatically pulls and applies modules before provisioning resources.

---

### 🧩 Examples / Commands / Config Snippets

#### 🔹 Folder Structure

```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
    └── s3_bucket/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

#### 🔹 Example: Module Definition (`modules/s3_bucket/main.tf`)

```hcl
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = var.acl
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}
```

#### 🔹 Example: Module Call (`main.tf`)

```hcl
module "my_bucket" {
  source      = "./modules/s3_bucket"
  bucket_name = "myapp-dev-bucket"
  acl         = "private"
}
```

#### 🔹 Using Remote Module (from GitHub or Registry)

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  name    = "my-vpc"
  cidr    = "10.0.0.0/16"
}
```

---

### 📋 Table: Module Source Types

| Source Type        | Example                                            | Use Case                    |
| ------------------ | -------------------------------------------------- | --------------------------- |
| Local path         | `./modules/vpc`                                    | Internal modules            |
| Git repo           | `git::https://github.com/org/repo.git//vpc`        | Shared modules in Git       |
| Terraform Registry | `terraform-aws-modules/vpc/aws`                    | Public modules              |
| S3 or GCS bucket   | `s3::https://s3.amazonaws.com/org/modules/vpc.zip` | Private module distribution |

---

### ✅ Best Practices

* Keep each module **focused** (one purpose per module).
* Always **pin module versions** for stability.
* Define clear **inputs/outputs** (`variables.tf`, `outputs.tf`).
* Store shared modules in **Git or Terraform Registry**.
* Use **naming conventions** for readability (e.g., `module.network`, `module.eks`).
* Run `terraform get -update` when updating remote modules.

---

### 💡 In short

* Modules = reusable Terraform components.
* Use `source` to reference local or remote code.
* Pass inputs, use outputs, and keep modules versioned and isolated for cleaner infra management.

---
## Q: How to reference one module’s output in another?

---

### 🧠 Overview

In Terraform, you can **pass outputs from one module as inputs to another**.
This allows **module chaining** — where one module’s result (like a VPC ID) becomes input for another (like a subnet or EKS cluster).
Terraform automatically handles the dependency graph between modules.

---

### ⚙️ Purpose / How It Works

1. Define an **output** in the source module (`outputs.tf`).
2. Access it from the **calling module** using `module.<module_name>.<output_name>`.
3. Pass it as input to another module or resource.

Terraform ensures the **dependency order** so the producer module runs before the consumer module.

---

### 🧩 Examples / Commands / Config Snippets

#### 🔹 Folder Structure

```
main.tf
modules/
├── vpc/
│   ├── main.tf
│   └── outputs.tf
└── eks/
    └── main.tf
```

#### 🔹 Step 1: Define Output in First Module (`modules/vpc/outputs.tf`)

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

#### 🔹 Step 2: Use Output in Another Module (`main.tf`)

```hcl
module "vpc" {
  source = "./modules/vpc"
}

module "eks" {
  source = "./modules/eks"
  vpc_id = module.vpc.vpc_id   # 👈 referencing vpc output here
}
```

#### 🔹 Step 3: Example EKS Module Variable (`modules/eks/variables.tf`)

```hcl
variable "vpc_id" {
  description = "VPC ID to deploy EKS cluster into"
  type        = string
}
```

---

### 📋 Table: Reference Syntax

| Context                       | Syntax                                          | Description            |
| ----------------------------- | ----------------------------------------------- | ---------------------- |
| Access module output          | `module.<module_name>.<output_name>`            | Refer to output value  |
| Use in another resource       | `vpc_id = module.vpc.vpc_id`                    | Pass as variable       |
| Output again from root module | `output "vpc_id" { value = module.vpc.vpc_id }` | Expose to parent level |

---

### ✅ Best Practices

* Always define **clear, descriptive outputs** in modules.
* Avoid **circular dependencies** (e.g., modules referencing each other mutually).
* Use **outputs only for necessary shared values** (VPC IDs, subnet IDs, etc.).
* Use **root-level outputs** if external systems or CI/CD need those values.
* Keep **variable types consistent** between modules (e.g., string vs list).

---

### 💡 In short

* Use `module.<name>.<output>` to reference outputs.
* Outputs enable **data flow between modules** safely.
* Common pattern: `VPC → Subnets → EKS` (each consuming previous outputs).

---
## Q: What’s the purpose of `depends_on` in Terraform?

---

### 🧠 Overview

`depends_on` is used to explicitly define **resource or module dependencies** in Terraform.
Even though Terraform automatically detects most dependencies through variable references, `depends_on` ensures **correct execution order** when the dependency isn’t obvious from configuration.

---

### ⚙️ Purpose / How It Works

* Terraform builds a **dependency graph** before execution.
* If a resource doesn’t reference another directly (via interpolation), Terraform might not know the dependency.
* `depends_on` explicitly enforces that one resource/module **must be created, updated, or destroyed after** another.

---

### 🧩 Examples / Commands / Config Snippets

#### 🔹 Example 1: Explicit Resource Dependency

```hcl
resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  depends_on    = [aws_security_group.app_sg]  # 👈 ensures SG created first
}

resource "aws_security_group" "app_sg" {
  name = "app-sg"
}
```

📘 Without `depends_on`, Terraform might try to create both simultaneously.

---

#### 🔹 Example 2: Module Dependency

```hcl
module "vpc" {
  source = "./modules/vpc"
}

module "eks" {
  source     = "./modules/eks"
  depends_on = [module.vpc]  # 👈 ensures EKS waits for VPC creation
}
```

---

#### 🔹 Example 3: Null Resource Trigger Dependency

```hcl
resource "null_resource" "deploy" {
  depends_on = [aws_instance.app_server]
  provisioner "local-exec" {
    command = "echo 'App deployed after EC2 creation'"
  }
}
```

---

### 📋 When to Use `depends_on`

| Use Case                                                  | Example                                           |
| --------------------------------------------------------- | ------------------------------------------------- |
| Indirect dependency (no interpolation)                    | `aws_instance` depends on SG or IAM role creation |
| Module ordering                                           | `eks` after `vpc`                                 |
| Custom provisioners or null resources                     | Run scripts after resource creation               |
| Resources using count/for_each where dependency not clear | Dynamic relations                                 |

---

### ✅ Best Practices

* Avoid overusing — rely on **implicit dependencies** when possible.
* Use only when Terraform **cannot infer** order automatically.
* For modules, always prefer `depends_on` over hacky workarounds.
* Keep `depends_on` **declarative** (avoid runtime command logic).
* Use lists: `depends_on = [aws_s3_bucket.logs, aws_iam_role.policy]`.

---

### 💡 In short

* `depends_on` enforces **execution order** manually.
* Use it when Terraform **can’t detect relationships automatically**.
* Great for sequencing between **modules, provisioners, or indirect resources**.

---
## Q: How do you lock Terraform state?

---

### 🧠 Overview

Terraform **state locking** prevents multiple users or CI/CD jobs from **modifying the same state file simultaneously**, which could corrupt your infrastructure state.
State locking ensures that **only one operation** (e.g., `terraform apply`, `plan`, or `destroy`) can run at a time for a given state backend.

---

### ⚙️ Purpose / How It Works

* When you run a Terraform command that modifies the state, it tries to **acquire a lock**.
* If another process already holds the lock, Terraform will **wait or fail** depending on backend configuration.
* Once the operation completes, the lock is released.

💡 **Supported only by certain backends** like S3 (with DynamoDB), Consul, and Terraform Cloud.

---

### 🧩 Examples / Commands / Config Snippets

#### 🔹 Example: Remote State Locking with AWS S3 + DynamoDB

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-states"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"

    # 👇 Enable state locking using DynamoDB
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

#### 🔹 DynamoDB Lock Table Definition

Create DynamoDB table before first apply:

```bash
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```

🛡️ This table stores lock information (LockID, owner, and timestamps).

---

### 📋 Table: Backend Locking Support

| Backend Type                   | Locking Supported | Notes                           |
| ------------------------------ | ----------------- | ------------------------------- |
| `local`                        | ❌ No              | Manual locking only             |
| `s3` + `dynamodb_table`        | ✅ Yes             | Most common in AWS              |
| `gcs`                          | ✅ Yes             | Uses GCS object preconditions   |
| `consul`                       | ✅ Yes             | Built-in locking                |
| `terraform cloud / enterprise` | ✅ Yes             | Automatic locking               |
| `azurerm`                      | ✅ Yes             | Uses Azure blob lease mechanism |

---

### ✅ Best Practices

* Always **use remote backend** with locking enabled (S3 + DynamoDB is standard).
* Never share or edit `terraform.tfstate` manually.
* In CI/CD, serialize Terraform runs (avoid parallel applies).
* Use `terraform force-unlock <LOCK_ID>` **only when absolutely necessary** (e.g., failed job didn’t release lock).

#### Example:

```bash
terraform force-unlock <LOCK_ID>
```

---

### 💡 In short

* Terraform locks prevent **simultaneous state updates**.
* Enable it using **S3 backend + DynamoDB table** (AWS best practice).
* Use `terraform force-unlock` only for recovery — never to bypass active locks.

---
## Q: How to use conditionals in Terraform?

---

### 🧠 Overview

Terraform supports **conditional expressions** (ternary-like syntax) to dynamically choose values based on conditions — useful for toggling features, resource creation, or configuration differences between environments (e.g., dev vs prod).

Conditionals make Terraform code **flexible**, **DRY**, and **environment-aware**.

---

### ⚙️ Purpose / How It Works

* Syntax:

  ```hcl
  condition ? true_value : false_value
  ```
* Terraform evaluates the `condition` at plan time and assigns either the true or false value.
* Can be used for **variables**, **resource arguments**, or **count logic**.

---

### 🧩 Examples / Commands / Config Snippets

#### 🔹 Example 1: Basic Conditional in a Variable

```hcl
variable "env" {
  type    = string
  default = "dev"
}

resource "aws_instance" "app" {
  instance_type = var.env == "prod" ? "t3.large" : "t3.micro"
}
```

✅ Uses a larger instance in production only.

---

#### 🔹 Example 2: Conditional Count (Resource Creation)

```hcl
variable "enable_s3" {
  type    = bool
  default = true
}

resource "aws_s3_bucket" "logs" {
  count  = var.enable_s3 ? 1 : 0
  bucket = "my-logs-${terraform.workspace}"
}
```

✅ Creates the bucket only if `enable_s3` is true.

---

#### 🔹 Example 3: Conditional Module Input

```hcl
module "monitoring" {
  source = "./modules/monitoring"
  enabled = var.env == "prod"
}
```

Inside module:

```hcl
resource "aws_cloudwatch_alarm" "cpu" {
  count = var.enabled ? 1 : 0
  ...
}
```

---

#### 🔹 Example 4: Nested or Complex Condition

```hcl
locals {
  instance_size = var.env == "prod" ? "t3.large" : var.env == "stage" ? "t3.medium" : "t3.micro"
}
```

✅ Multi-environment handling in one line.

---

### 📋 Table: Common Conditional Use Cases

| Use Case                 | Example                                                                    | Description                   |
| ------------------------ | -------------------------------------------------------------------------- | ----------------------------- |
| Enable/disable resources | `count = var.enable ? 1 : 0`                                               | Conditional resource creation |
| Switch instance types    | `var.env == "prod" ? "m5.large" : "t3.micro"`                              | Environment-based             |
| Optional tags            | `merge(var.common_tags, var.env == "prod" ? { "Tier" = "Critical" } : {})` | Conditional map merge         |
| Feature toggles          | `enable_feature ? "on" : "off"`                                            | Boolean feature flags         |

---

### ✅ Best Practices

* Keep conditions **simple** — use locals for readability if complex.
* Prefer **booleans** for toggles (`enable_x = true/false`).
* Avoid `count` + `for_each` conflicts — pick one per resource.
* Use **`locals`** to centralize conditional logic.
* Combine with `terraform.workspace` for environment-based toggling.

---

### 💡 In short

* Use `condition ? true_value : false_value` syntax.
* Ideal for **feature toggles**, **env-based configs**, and **optional resources**.
* Simplifies logic, reduces duplication, and keeps Terraform code environment-aware.

---

## Q: How to debug Terraform?

---

### 🧠 Overview

Debugging Terraform means systematically finding why plans/applies behave unexpectedly — broken dependencies, state drift, provider errors, or CI failures. Use Terraform logs, state inspection, plan artifacts, graphing, and provider/cloud logs to isolate root cause quickly.

---

### ⚙️ Purpose / How it works

* Collect runtime logs (`TF_LOG`) to see provider / plugin interactions.
* Inspect the state and plan outputs to confirm what Terraform *thinks* vs what exists.
* Use `terraform console`, `graph`, and `show -json` to validate expressions and dependency graph.
* Correlate Terraform activity with cloud provider logs (CloudTrail, CloudWatch, etc.) for infra-level failures.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Capture detailed Terraform logs

```bash
# Trace level (very verbose)
export TF_LOG=TRACE
export TF_LOG_PATH=./tf-debug.log
terraform apply -auto-approve
# Inspect tf-debug.log for provider calls, HTTP payloads, errors
```

#### 2) Produce and examine a plan file (inspectable)

```bash
terraform init
terraform plan -out=tfplan.bin
terraform show -json tfplan.bin > tfplan.json
# Open tfplan.json or use `jq` to find changes
jq '.resource_changes[] | {address,change}' tfplan.json
```

#### 3) Inspect remote state and specific resources

```bash
# Pull remote state to local file
terraform state pull > state.json

# Show a single resource's state
terraform state show aws_instance.app_server
```

#### 4) Interactive expression evaluation

```bash
terraform console
> module.vpc.cidr_block
"10.0.0.0/16"
> length(module.subnets.private_subnet_ids)
2
```

#### 5) Visualize dependency graph

```bash
terraform graph | dot -Tpng -o graph.png
# Open graph.png to see resource/module ordering
```

#### 6) Isolate and test a resource/module (use sparingly)

```bash
terraform plan -target=module.db -out=db.plan
# Use -target only for temporary debugging; avoid long-term reliance
```

#### 7) Inspect provider/plugin versions and schema

```bash
terraform providers
terraform providers lock -platform=linux_amd64
```

#### 8) Fix state or lock issues

```bash
# If state locked (e.g., S3+DynamoDB), get lock id from logs and force unlock only if safe
terraform force-unlock <LOCK_ID>
```

---

### 📋 Quick reference — common problems & steps

|                               Problem | First check                   | Commands / Action                                                                             |
| ------------------------------------: | ----------------------------- | --------------------------------------------------------------------------------------------- |
|               Unexpected diff / drift | What does state say vs cloud? | `terraform state show <addr>`, cloud console, `terraform plan -out=plan`                      |
|                   Provider auth error | Provider credentials/role     | Check env vars/assume-role, `TF_LOG=TRACE` for auth calls                                     |
|                  Slow / hanging apply | Locking or provider timeout   | Check backend (DynamoDB locks), `terraform force-unlock` if stale, increase provider timeouts |
| Plan shows change but infra unchanged | Data vs computed values       | `terraform refresh` / `terraform plan -refresh=false` to test behavior                        |
|                Complex expression bug | Evaluate in console           | `terraform console`                                                                           |
|                  Graph/ordering issue | Missing dependency            | `terraform graph` + add `depends_on` if needed                                                |
|                CI failures (headless) | Missing env/secret or backend | Reproduce locally; `terraform init -backend-config=...`                                       |

---

### ✅ Best Practices for efficient debugging

* Always run `terraform init` and `terraform validate` before planning.
* Use `terraform plan -out` + `terraform show -json` to inspect exactly what will change.
* Keep `TF_LOG` logs short-lived (sensitive data may appear) and store securely.
* Don’t overuse `-target`; it hides full graph effects.
* Backup state (`state pull`) before manual edits or `state rm`.
* Correlate with cloud provider logs (CloudTrail, CloudWatch, GCP Audit Logs) for failed resource operations.
* Add short, descriptive outputs in modules to make debugging cross-module values easier.
* In CI, capture and attach `tfplan.json`, `tf-debug.log`, and `state.json` to job artifacts.

---

### 💡 In short

* Start with `terraform plan -out` + `terraform show -json` and `terraform state show` to compare intent vs reality.
* Use `TF_LOG` for provider-level traces, `terraform console` for expressions, and `terraform graph` to visualize dependencies.
* Backup state, avoid long-term use of `-target`, and always correlate with cloud logs for infra-level failures.

---
## Q: What is Terraform Workspace?

---

### 🧠 Overview

Terraform **workspaces** let you manage **multiple environments (dev, stage, prod, etc.)** using the **same configuration** and backend.
Each workspace maintains a **separate state file**, allowing you to isolate infrastructure deployments under one codebase.

Workspaces are especially useful for managing environment-based infrastructure in a single Terraform project.

---

### ⚙️ Purpose / How It Works

* Each workspace = its **own state file** in the backend.
* The same `.tf` files are applied with different variable values and state contexts.
* Default workspace = `default`.
* You can create or switch workspaces using CLI commands.

**Terraform auto-maps** workspace names to state files like:

```
s3://my-tf-state-bucket/env:dev/terraform.tfstate
```

---

### 🧩 Examples / Commands / Config Snippets

#### 🔹 Manage Workspaces

```bash
# List all workspaces
terraform workspace list

# Create a new workspace
terraform workspace new dev

# Switch between workspaces
terraform workspace select prod

# Show current workspace
terraform workspace show
```

#### 🔹 Use Workspace in Configuration

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "myapp-${terraform.workspace}-bucket"
  acl    = "private"
}
```

✅ Automatically names buckets based on the active workspace (e.g., `myapp-dev-bucket`).

---

#### 🔹 Example: Environment-Specific Variables

```hcl
variable "instance_type" {
  default = terraform.workspace == "prod" ? "t3.large" : "t3.micro"
}
```

✅ Dynamically adjusts configuration per environment.

---

### 📋 Table: Workspace vs Separate Folder Approach

| Aspect              | Terraform Workspace         | Separate Folder/Repo            |
| ------------------- | --------------------------- | ------------------------------- |
| State separation    | ✅ Automatic (per workspace) | ✅ Manual (per backend)          |
| Code reuse          | ✅ Same config               | ❌ Duplicated configs            |
| Variable management | Conditional logic / tfvars  | Separate tfvars per folder      |
| Isolation level     | Logical (same backend)      | Full (different backend)        |
| Recommended for     | Small / mid environments    | Complex / production org setups |

---

### ✅ Best Practices

* Use workspaces for **lightweight environment separation** (dev/stage/test).
* For **production isolation**, prefer **separate state files or backends**.
* Always include `${terraform.workspace}` in resource names to avoid collisions.
* Use workspace-aware logic for variable defaults (`terraform.workspace == "prod"`).
* Avoid mixing manual and workspace-based environment strategies.

---

### 💡 In short

* Workspaces = multiple **state contexts** under one config.
* Great for **dev/stage/prod** management with the same code.
* Use `${terraform.workspace}` in resource names and variables for clean isolation.

---
## Q: How to integrate Terraform in Jenkins / GitLab CI?

---

### 🧠 Overview

Integrate Terraform into CI pipelines to automate `init`, `plan`, `apply`, and drift detection while keeping state locked and secrets safe. Use remote state (S3 + DynamoDB or Terraform Cloud), produce plan artifacts, and gate `apply` behind approvals in Jenkins or GitLab.

---

### ⚙️ Purpose / How it works

* **Init** backend & providers (once per run).
* **Validate / fmt** to enforce code quality.
* **Plan** generates a binary plan file and human-readable diff; store plan as artifact.
* **Apply** executed only after manual approval (or an automated policy), using the saved plan file.
* **Locking** via backend (DynamoDB / Terraform Cloud) prevents concurrent writes.
* **Secrets & creds** come from CI secret store (Jenkins credentials / GitLab CI variables / Vault) — never hardcode.

---

### 🧩 Examples / Commands / Config snippets

#### 🔹 Terraform backend (example: S3 + DynamoDB)

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-states"
    key            = "envs/${terraform.workspace}/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

---

## Jenkins Integration

### 🔹 Declarative `Jenkinsfile` (recommended CI agent is ephemeral)

```groovy
pipeline {
  agent any
  environment {
    TF_WORKING_DIR = "infra"
    TF_VERSION     = "hashicorp/terraform:<VERSION>" // pin the image version
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Terraform fmt / validate') {
      steps {
        sh 'docker run --rm -v $PWD:/workspace -w /workspace/$TF_WORKING_DIR $TF_VERSION terraform fmt -check=true'
        sh 'docker run --rm -v $PWD:/workspace -w /workspace/$TF_WORKING_DIR $TF_VERSION terraform validate'
      }
    }

    stage('Init') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
          sh 'docker run --rm -v $PWD:/workspace -w /workspace/$TF_WORKING_DIR -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY $TF_VERSION terraform init -input=false'
        }
      }
    }

    stage('Plan') {
      steps {
        sh 'docker run --rm -v $PWD:/workspace -w /workspace/$TF_WORKING_DIR -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY $TF_VERSION terraform plan -out=tfplan.bin -input=false'
        sh 'docker run --rm -v $PWD:/workspace -w /workspace/$TF_WORKING_DIR $TF_VERSION terraform show -no-color -json tfplan.bin > tfplan.json'
        archiveArtifacts artifacts: "${TF_WORKING_DIR}/tfplan.bin, ${TF_WORKING_DIR}/tfplan.json"
      }
    }

    stage('Apply (manual)') {
      steps {
        input message: "Approve terraform apply?"
        sh 'docker run --rm -v $PWD:/workspace -w /workspace/$TF_WORKING_DIR -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY $TF_VERSION terraform apply -input=false tfplan.bin'
      }
    }
  }
  post {
    failure {
      sh 'echo "Terraform job failed — check tfplan.json and tf-debug.log in artifacts"'
    }
  }
}
```

* Use Jenkins Credentials for AWS keys or an IAM role via instance profile.
* Store `tfplan.bin` and `tfplan.json` as build artifacts for audit.

---

## GitLab CI Integration

### 🔹 `.gitlab-ci.yml`

```yaml
stages:
  - fmt
  - validate
  - init
  - plan
  - manual_apply

variables:
  TF_WORKING_DIR: "infra"
  TERRAFORM_IMAGE: "hashicorp/terraform:<VERSION>"

before_script:
  - mkdir -p $TF_WORKING_DIR
  - cd $TF_WORKING_DIR

fmt:
  image: $TERRAFORM_IMAGE
  stage: fmt
  script:
    - terraform fmt -check=true
  rules: [{ exists: ["$TF_WORKING_DIR/*.tf"] }]

validate:
  image: $TERRAFORM_IMAGE
  stage: validate
  script:
    - terraform init -backend-config="bucket=$S3_BUCKET" -backend-config="region=$AWS_REGION" -input=false
    - terraform validate

plan:
  image: $TERRAFORM_IMAGE
  stage: plan
  script:
    - terraform init -backend-config="bucket=$S3_BUCKET" -backend-config="region=$AWS_REGION" -input=false
    - terraform plan -out=tfplan.bin -input=false
    - terraform show -json tfplan.bin > tfplan.json
  artifacts:
    paths:
      - tfplan.bin
      - tfplan.json
    expire_in: 1 week

apply:
  image: $TERRAFORM_IMAGE
  stage: manual_apply
  script:
    - terraform init -backend-config="bucket=$S3_BUCKET" -backend-config="region=$AWS_REGION" -input=false
    - terraform apply -input=false tfplan.bin
  when: manual
  environment:
    name: production
```

* Use GitLab CI protected variables for AWS creds or assume-role with AWS CLI.
* `apply` job is `when: manual` to require an explicit click/approval.

---

### 📋 Jenkins vs GitLab CI — quick comparison

|            Feature |           Jenkins           |              GitLab CI             |
| -----------------: | :-------------------------: | :--------------------------------: |
|      Secrets store | Jenkins Credentials / Vault |     GitLab CI Variables / Vault    |
|  Built-in approval |         `input` step        |         `when: manual` job         |
|          Artifacts |       Build artifacts       | Job artifacts (retention settings) |
|     Runners/agents |     Node / Docker agents    |      Shared / Specific runners     |
| Integration effort |       Flexible plugins      |    YAML-first, simpler for repos   |

---

### ✅ Best Practices (must-follow)

* **Remote state + locking:** Use S3 backend + DynamoDB or Terraform Cloud/Enterprise.
* **Pin Terraform versions** in CI image to avoid surprises.
* **Plan artifacts:** Save `tfplan.bin` and `tfplan.json` as artifacts for audits and automated reviewers.
* **Manual approval:** Gate `apply` with manual approval for prod.
* **Least-privilege IAM:** Use short-lived credentials or assume-role with scoped policies.
* **Secrets management:** Use CI secret stores or Vault; never store creds in repo.
* **Immutable workers:** Use ephemeral docker runners/agents; no local state.
* **State backup:** Enable versioning on S3 and backup mechanism.
* **DRY pipelines:** Reuse common pipeline templates or shared libraries.
* **Detect drift:** Schedule periodic `terraform plan -refresh-only` or use drift detectors.
* **Logging:** Capture `TF_LOG` only on demand and store securely (contains secrets).

---

### ⚠️ Common gotchas & fixes

* **Concurrent runs causing lock waits:** Ensure DynamoDB table exists and check for stale locks; use `terraform force-unlock` only when safe.
* **Different TF versions:** Pin the same version in local dev and CI.
* **Missing provider plugins:** Use `terraform init` with same backend config in each job.
* **Credentials leakage in logs:** Avoid `TF_LOG=TRACE` in shared CI; mask sensitive variables.

---

### 💡 In short

* Automate `init → validate → plan → store artifact → manual apply` with remote state and locking.
* Use CI secrets and least-privilege IAM; pin TF versions and keep `apply` gated for production.
* Save plan artifacts and use ephemeral runners for safe, auditable Terraform automation.

---
## Q: Common Terraform Commands

---

### 🧠 Overview

Terraform commands manage the entire **infrastructure lifecycle** — from initialization to deployment and destruction.
They’re grouped by **workflow stage**: *init → plan → apply → validate → destroy → debug*.

Each command is **idempotent**, **state-aware**, and **backend-integrated**.

---

### ⚙️ Purpose / How It Works

Terraform CLI interacts with:

* **.tf configuration files** (your code)
* **state file** (tracks deployed resources)
* **providers** (AWS, Azure, GCP, etc.)

Commands help you **initialize**, **plan**, **apply**, **inspect**, and **clean up** your infrastructure.

---

### 🧩 Common Commands / Examples

| Stage         | Command                           | Description                                        | Example                                                   |                        |
| :------------ | :-------------------------------- | :------------------------------------------------- | :-------------------------------------------------------- | ---------------------- |
| 🏗️ Setup     | `terraform init`                  | Initializes backend, provider plugins, and modules | `terraform init -backend-config="bucket=my-state-bucket"` |                        |
| 🧾 Formatting | `terraform fmt`                   | Formats `.tf` files to standard style              | `terraform fmt -recursive`                                |                        |
| 🔍 Validation | `terraform validate`              | Validates syntax and structure                     | `terraform validate`                                      |                        |
| 📋 Planning   | `terraform plan`                  | Shows what changes will occur                      | `terraform plan -out=tfplan.bin`                          |                        |
| ⚙️ Apply      | `terraform apply`                 | Executes the planned changes                       | `terraform apply tfplan.bin`                              |                        |
| 💣 Destroy    | `terraform destroy`               | Removes all managed infrastructure                 | `terraform destroy -auto-approve`                         |                        |
| 🔄 Refresh    | `terraform refresh`               | Syncs state with real-world resources              | `terraform refresh`                                       |                        |
| 📂 Show       | `terraform show`                  | Displays state or plan details                     | `terraform show -json tfplan.bin > plan.json`             |                        |
| 🧠 Output     | `terraform output`                | Prints module outputs from state                   | `terraform output vpc_id`                                 |                        |
| 🧱 State mgmt | `terraform state list`            | Lists all tracked resources                        | `terraform state list`                                    |                        |
|               | `terraform state show <addr>`     | Shows detailed info about a resource               | `terraform state show aws_instance.web`                   |                        |
|               | `terraform state rm <addr>`       | Removes a resource from state                      | `terraform state rm aws_s3_bucket.logs`                   |                        |
| 🧩 Import     | `terraform import`                | Brings existing infra under Terraform control      | `terraform import aws_instance.web i-0abcd1234`           |                        |
| 🔒 Locking    | `terraform force-unlock`          | Manually releases stuck state locks                | `terraform force-unlock <LOCK_ID>`                        |                        |
| 🧠 Console    | `terraform console`               | Opens REPL to test expressions                     | `terraform console`                                       |                        |
| 🔁 Graph      | `terraform graph`                 | Outputs dependency graph (DOT format)              | `terraform graph                                          | dot -Tpng > graph.png` |
| 🧰 Version    | `terraform version`               | Shows installed Terraform version                  | `terraform version`                                       |                        |
| 🧩 Modules    | `terraform get`                   | Downloads or updates modules                       | `terraform get -update`                                   |                        |
| 🌍 Workspace  | `terraform workspace list`        | Lists all workspaces                               | `terraform workspace list`                                |                        |
|               | `terraform workspace new dev`     | Creates a new workspace                            | `terraform workspace new dev`                             |                        |
|               | `terraform workspace select prod` | Switches workspace                                 | `terraform workspace select prod`                         |                        |

---

### ✅ Best Practices

* Run `terraform fmt` and `terraform validate` before commits.
* Use `terraform plan -out=tfplan.bin` before `apply` (never apply blind).
* Use remote state (S3/DynamoDB, GCS, etc.) for collaboration.
* Backup state before destructive operations.
* Use `terraform apply -auto-approve` **only in CI/CD**, never manually.
* Pin Terraform and provider versions in `required_version` blocks.
* Use `terraform output -json` for programmatic integrations (Jenkins, GitLab CI).

---

### 💡 In short

* 🚀 **Init → Plan → Apply → Destroy** = core Terraform workflow.
* 🧩 Use **fmt**, **validate**, **output**, **state**, and **workspace** for management.
* Always **plan before apply**, **lock state**, and **version your configs** for safe, reproducible deployments.
---

# Scenario Questions

## Q: Team modifies infra manually in AWS — how to detect, reconcile, and prevent it?

---

### 🧠 Overview

Manual changes in AWS cause **state drift** and break Terraform’s source-of-truth model. The goal is to **detect** drift quickly, **reconcile** state safely, and **prevent** future out-of-band changes using policies, automation, and GitOps.

---

### ⚙️ Purpose / How it works

* **Detect:** Find drift by comparing Terraform state vs real resources (`terraform plan`, `refresh`) and cloud audit logs (CloudTrail, AWS Config).
* **Reconcile:** Choose to **import**, **recreate**, or **adopt** resources into Terraform, or update code to reflect approved manual edits.
* **Prevent:** Limit console/API access, enforce IaC-only changes (SCPs, IAM, AWS Config rules), and adopt GitOps or gated CI for infrastructure changes.

---

### 🧩 Examples / Commands / Config snippets

#### 1) **Detect drift quickly**

```bash
# Show what Terraform thinks will change (refreshes state)
terraform init
terraform plan -refresh=true -out=tfplan.bin

# Produce JSON plan for CI / audit
terraform show -json tfplan.bin > tfplan.json
jq '.resource_changes[] | {address,type,change}' tfplan.json
```

#### 2) **Inspect specific resource state**

```bash
terraform state show aws_instance.web_server
# Or pull remote state to inspect
terraform state pull > state.json
```

#### 3) **Reconcile approaches**

* **Import** resource so Terraform manages it (preferred if manual resource is correct):

```bash
# Example: import EC2 into Terraform resource aws_instance.web_server
terraform import aws_instance.web_server i-0abcd1234
terraform plan
terraform apply
```

* **Adopt & update code**: Update HCL to match manual changes, run `terraform plan` → `apply` to align state.

* **Recreate** resource via Terraform if manual change is incorrect:

```bash
terraform taint aws_instance.web_server   # mark for recreation
terraform apply
```

* **Forget resource** if you want Terraform to stop managing it (use rarely):

```bash
terraform state rm aws_instance.legacy_db
```

#### 4) **Audit / find who changed what**

```bash
# CloudTrail (CLI example)
aws cloudtrail lookup-events --lookup-attributes AttributeKey=ResourceName,AttributeValue=i-0abcd1234

# AWS Config can show resource timeline & compliance (console / AWS CLI)
aws configservice get-resource-config-history --resource-type AWS::EC2::Instance --resource-id i-0abcd1234
```

#### 5) **Preventive controls (examples)**

* **S3 + DynamoDB backend + locking** (prevents concurrent CI runs):

```hcl
terraform {
  backend "s3" {
    bucket         = "my-tf-states"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
  }
}
```

* **Enforce IaC-only changes** with GitOps (example pattern):

  * All infra changes via PR to `infra/` repo
  * CI validates `terraform plan` and posts plan to PR
  * Protected branch + approvals to `apply` in CI

* **IAM policy snippet** to restrict console IAM or tag-based write:

```json
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"DenyEC2ConsoleModifyUnlessTag",
      "Effect":"Deny",
      "Action":"ec2:ModifyInstanceAttribute",
      "Resource":"*",
      "Condition":{
        "StringNotEquals":{"aws:RequestTag/ManagedBy":"Terraform"}
      }
    }
  ]
}
```

*(Use carefully — test in staging before wide roll-out.)*

* **AWS Organizations SCP** to block certain APIs except from CI role or Terraform role.

* **AWS Config rules** to detect unmanaged changes and trigger Lambda remediation or alerts.

---

### 📋 Table: Quick decision matrix for manual change reconciliation

| Situation                                | Detect                         | Action                        | Terraform commands                           |
| ---------------------------------------- | ------------------------------ | ----------------------------- | -------------------------------------------- |
| Manual change is **correct**             | `terraform plan` shows diff    | Import into state             | `terraform import <addr> <id>`               |
| Manual change is **incorrect**           | Drift identified, breaking app | Recreate via Terraform        | `terraform taint <addr>` → `terraform apply` |
| Resource should be **excluded** from IaC | Confirmed non-managed          | Remove from state             | `terraform state rm <addr>`                  |
| Multiple conflicting manual edits        | Audit logs show churn          | Lock/Restrict access + GitOps | IAM/SCP + CI gating                          |

---

### ✅ Best Practices (practical, production-ready)

* **Detect automatically:** Schedule `terraform plan -refresh-only` (or run `terragrunt plan`/Terraform Cloud runs) and fail if unexpected diffs. Store `tfplan.json` artifacts for review.
* **Audit trail:** Enable **CloudTrail** + **AWS Config** for resource timelines. Integrate alerts to Slack/Teams.
* **Adopt GitOps:** All infra changes via PR → CI runs `plan` → human approval → `apply` in controlled runner.
* **Least privilege:** Use IAM roles for CI (assume-role) with minimal scope; restrict console/API edits for sensitive resources.
* **Tagging convention:** Add `ManagedBy = "Terraform"` tag; use IAM conditions to allow modifications only when tag present.
* **Automated remediation:** Use AWS Config + Lambda to auto-remediate or create tickets for unauthorized changes.
* **State hygiene:** Remote backend + locking; enable S3 versioning and restricted access to state.
* **Train team:** Document workflows, runbooks for when manual fixes are needed (import vs recreate).
* **Playbook & backups:** Keep a documented playbook: `detect → notify → decide (import/taint/rm) → apply`, and backup state before manual edits.

---

### 💡 In short

* Detect drift with `terraform plan`/CloudTrail/AWS Config.
* Reconcile by **importing** correct manual resources, **tainting** to recreate incorrect ones, or **removing** purposely unmanaged items.
* Prevent recurrence with **GitOps**, IAM restrictions, AWS Config rules, and remote state + locking.

---

## Q: Need blue/green infra deployment

---

### 🧠 Overview

Blue/Green deployment is a release pattern that keeps two production-equivalent environments — **Blue** (current) and **Green** (new). Traffic is switched from Blue → Green once Green is validated, enabling near-zero-downtime and quick rollback by switching back.

Use this at **infrastructure** level (ALB/Route53/ASG/ECS/EKS) or **application** level (Kubernetes / ECS). This README shows practical patterns, Terraform snippets, Kubernetes manifests, CI examples (Jenkins / GitLab), and operational best practices.

---

### ⚙️ Purpose / How it works

* Provision two identical environments (blue/green) or two runtime revisions.
* Deploy new version to Green while Blue serves production traffic.
* Run smoke and integration tests against Green.
* Switch traffic atomically (DNS, ALB target-group swap, or weighted routing).
* Rollback by switching traffic back to Blue if issues occur.
* Optional canary step: use weighted routing for gradual shift.

Key traffic switch techniques:

* **ALB target-group swap** (recommended for AWS): update listener rules to point to green TG.
* **Route53 weighted records**: shift weight from Blue to Green.
* **Kubernetes**: swap service selector or use Ingress/Service mesh routing (Istio/NGINX) with weights.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Terraform: ALB Target-group swap pattern (AWS)

**High-level:** Create two target groups (`tg-blue`, `tg-green`) and one listener. Switch listener `default_action` to point to green TG on promotion.

```hcl
# modules/alb/main.tf (snippet)
resource "aws_lb_target_group" "blue" {
  name     = "service-blue"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "green" {
  name     = "service-green"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = var.alb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.active == "green" ? aws_lb_target_group.green.arn : aws_lb_target_group.blue.arn
  }
}
```

**Switch traffic:** change `var.active` from `"blue"` → `"green"` then `terraform apply`. In CI, use plan artifact + manual approval.

---

#### 2) Terraform: Route53 weighted DNS (gradual shift)

```hcl
resource "aws_route53_record" "app" {
  zone_id = var.zone_id
  name    = "app.example.com"
  type    = "A"

  alias {
    name                   = aws_lb.my_alb.dns_name
    zone_id                = aws_lb.my_alb.zone_id
    evaluate_target_health = true
  }

  set_identifier = "green"
  weighted_routing_policy {
    weight = var.green_weight  # 0..100
  }
}
```

Use two records (blue/green) with weights. Gradually increase `green_weight` to shift traffic.

---

#### 3) Kubernetes: Service selector swap (simple)

* Blue Deployment: label `app: myapp, version: blue`
* Green Deployment: label `app: myapp, version: green`
* Service selector uses `app: myapp, version: active` → update `active` label to green, or better switch Ingress/VirtualService weights.

**K8s manifests:**

```yaml
# deployment-green.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
      version: green
  template:
    metadata:
      labels:
        app: myapp
        version: green
    spec:
      containers:
      - name: app
        image: myrepo/myapp:2.0.0
        ports:
        - containerPort: 8080

# service uses label version: active (switch with kubectl)
apiVersion: v1
kind: Service
metadata:
  name: myapp-svc
spec:
  selector:
    app: myapp
    version: active
  ports:
  - port: 80
    targetPort: 8080
```

Switch `version: active` label using `kubectl label` or update Service selector via `kubectl apply`.

---

#### 4) EKS / Istio: Weighted traffic (recommended for gradual shift)

**VirtualService example (Istio):**

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: myapp
spec:
  hosts:
  - "myapp.example.com"
  http:
  - route:
    - destination:
        host: myapp
        subset: blue
      weight: 10
    - destination:
        host: myapp
        subset: green
      weight: 90
```

Adjust weights to shift traffic gradually.

---

#### 5) CI/CD Pipeline snippets

**Jenkinsfile (blue/green flow)**:

```groovy
pipeline {
  agent any
  stages {
    stage('Build & Push') {
      steps {
        sh 'docker build -t repo/myapp:${BUILD_NUMBER} .'
        sh 'docker push repo/myapp:${BUILD_NUMBER}'
      }
    }
    stage('Deploy Green') {
      steps {
        sh 'kubectl apply -f k8s/deployment-green.yaml'
        sh 'kubectl set image deployment/myapp-green myapp=repo/myapp:${BUILD_NUMBER}'
      }
    }
    stage('Smoke Tests') {
      steps {
        sh 'curl -f http://green.example.com/health || exit 1'
      }
    }
    stage('Switch Traffic') {
      steps {
        input message: 'Approve traffic switch to green?'
        sh 'kubectl apply -f k8s/switch-service-to-green.yaml'
      }
    }
    stage('Cleanup Blue') {
      steps {
        sh 'kubectl delete deployment myapp-blue || true'
      }
    }
  }
}
```

**GitLab CI (weighted Route53 gradual shift)**:

```yaml
stages: [build, deploy, promote]
deploy-green:
  stage: deploy
  script:
    - docker build -t repo/myapp:$CI_PIPELINE_ID .
    - docker push repo/myapp:$CI_PIPELINE_ID
    - kubectl apply -f k8s/deployment-green.yaml
promote:
  stage: promote
  when: manual
  script:
    - terraform apply -var="active=green" -auto-approve
```

---

### 📋 Table: Approaches Comparison

|               Pattern | Switch Mechanism          |     Granularity     |     Rollback Speed    |  Complexity |
| --------------------: | :------------------------ | :-----------------: | :-------------------: | :---------: |
| ALB target-group swap | Listener action swap      |        Atomic       | Very fast (swap back) |  Low-Medium |
|      Route53 weighted | DNS weight change         |       Gradual       |     Depends on TTL    |     Low     |
|  K8s Service selector | Update service selector   |        Atomic       |    Fast (swap back)   |     Low     |
|  Service Mesh (Istio) | Weighted VirtualService   | Fine-grained weight |          Fast         | Medium-High |
|        ASG blue/green | Replace AutoScaling group |        Atomic       |  Fast if infra ready  |    Medium   |

---

### ✅ Best Practices

* **Immutable infra:** Build new infra (Green) rather than mutating Blue.
* **Health checks & readiness:** Use ALB / k8s readiness probes to ensure Green is healthy before switching.
* **DB migrations:** Handle schema changes carefully — use backward-compatible migrations or migration orchestration (separate migration job before traffic cutover).
* **Automation + Approval:** CI deploys to Green and runs smoke tests; require manual approval to flip production traffic.
* **Observability:** Monitor logs, latency, error rates, and automated SLO checks during and after swap.
* **DNS TTLs:** Keep low TTLs (e.g., 30s) for DNS-based shifts; ALB swaps are immediate.
* **State & infra in IaC:** Provision Blue/Green infra with Terraform modules and track active target via a variable (e.g., `active = "green"`). Keep plan artifacts for audits.
* **Rollback plan:** Scripted rollback (toggle listener or weights) so ops can revert in one command.
* **Cost considerations:** Two full environments double infra cost — consider scaling down Blue after promotion and before teardown.
* **Security:** Use separate IAM roles for CI/CD deployers and restrict who can switch traffic.

---

### ⚠️ Common Gotchas

* Forgetting to update session affinity or cookies on ALB leading to user sticky sessions still hitting Blue.
* DB schema incompatible with both versions — require backward-compatible changes.
* Long DNS TTLs delaying cutover.
* Not draining connections on Blue before deletion — use target-group deregistration delay or pod terminationGracePeriodSeconds.
* Missing smoke tests — promote broken Green.

---

### 💡 In short

* Provision Green, validate, then switch traffic atomically (ALB) or gradually (Route53/Istio).
* Automate deploy → smoke tests → manual approval → traffic switch; keep rollback script ready.
* Prefer ALB TG swap or Service Mesh weights for predictable, fast rollouts and easy rollback.
---
## Q: A module resource is deleted accidentally — how to detect, recover, and prevent it?

---

### 🧠 Overview

When a resource defined in a module is **accidentally deleted** (either removed from the cloud console or removed from the module code), Terraform and the team must determine whether to **recreate**, **re-adopt**, or **ignore** the resource. This guide shows quick detection steps, safe recovery options (import / restore / recreate), and prevention controls.

---

### ⚙️ Purpose / How it works

* **Detect** drift by comparing Terraform state vs cloud.
* **Recover** by either importing the live resource back into state, restoring state from backups, or recreating via Terraform.
* **Prevent** future incidents through CI checks, restricted permissions, state versioning, and runbooks.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Detect the accidental deletion

```bash
# Init backend in repo
terraform init -input=false

# Plan to see what Terraform thinks changed (refreshes state by default)
terraform plan -out=tfplan.bin

# Inspect plan JSON for missing resource changes
terraform show -json tfplan.bin > tfplan.json
jq '.resource_changes[] | select(.change.actions | index("create") or index("delete")) | {address,change}' tfplan.json
```

```bash
# Or inspect specific resource in state (if you know address)
terraform state show module.my_module.aws_instance.web || echo "not found"
```

---

#### 2) Recover options (pick one based on situation)

##### A) Resource exists in cloud but removed from state → **terraform import**

* Use when the resource was deleted from state (or state is stale) but the actual cloud resource still exists and should be managed by Terraform.

```bash
# Example: import EC2 instance i-012345 into module resource
terraform import 'module.my_module.aws_instance.web' i-0123456789abcdef0

# Validate and plan
terraform plan
```

> ✅ After import, run `terraform plan` and **update HCL** (attributes/arguments) so the imported resource matches code.

---

##### B) Resource deleted in cloud but state still thinks it exists → **recreate via Terraform**

* If the resource should be recreated:

```bash
# Mark for recreation (if present in state)
terraform taint 'module.my_module.aws_instance.web'
# Or just run plan/apply: Terraform will plan a create if resource missing remotely
terraform apply -auto-approve
```

> ⚠️ Ensure any dependent data (IP, DNS) and secrets are handled. Check for immutable identifiers.

---

##### C) State accidentally removed or corrupted → **restore state from backup**

* For remote backends (S3 + versioning): restore prior `terraform.tfstate` object from S3 versioning or Terraform Cloud snapshots.

```bash
# Pull the current state copy locally for inspection
terraform state pull > state.json

# For S3: use aws cli to list/restore versions, then overwrite backend state object with desired version
aws s3api list-object-versions --bucket my-terraform-states --prefix prod/terraform.tfstate
# Download a previous version, then `terraform state push` (if using local state) or replace backend file carefully.
```

> 🔒 Always backup current state before any manual replace. Prefer Terraform Cloud's snapshot restore UI where available.

---

##### D) Resource intentionally removed from IaC → **state rm** (forget)

* If the resource should be unmanaged going forward:

```bash
terraform state rm 'module.my_module.aws_instance.web'
```

> Use only if you truly want Terraform to stop managing the resource.

---

#### 3) Verify and finalize recovery

```bash
# Validate plan shows no unexpected delete/create
terraform plan

# Apply only after review; prefer apply from saved plan in CI
terraform apply tfplan.bin
```

---

### 📋 Decision matrix: how to choose recovery action

|                             Situation | Resource exists in cloud? | State entry present? | Recommended action                                                             |
| ------------------------------------: | :-----------------------: | :------------------: | :----------------------------------------------------------------------------- |
|     Deleted from state, resource live |             ✅             |           ❌          | `terraform import` → `terraform plan` → align HCL                              |
| Deleted in cloud, state still present |             ❌             |           ✅          | `terraform taint` or `apply` to recreate; confirm external data (IPs, DB data) |
|           State corrupted/overwritten |            ✅/❌            |      unreliable      | Restore state from S3/GCS/TFC snapshot, then `terraform plan`                  |
|      Resource intentionally unmanaged |             ✅             |           ✅          | `terraform state rm` (and document decision)                                   |

---

### ✅ Best Practices (production-ready)

* **Enable backend versioning** (S3 versioning or Terraform Cloud snapshots) and test restore procedure.
* **Protect state**: remote backend with locking (S3 + DynamoDB / Terraform Cloud).
* **Restrict console/API access**: use least-privilege IAM; require change approvals for destructive actions.
* **Require PR + plan review**: CI must generate `tfplan.json` and attach to PR; gate `apply` to protected branches and manual approvals.
* **Audit & alert**: enable CloudTrail/AWS Config to detect manual deletes and notify on suspicious API calls.
* **Runbooks**: maintain a short runbook for `accidental delete` (detect → decide → import/restore/recreate → verify).
* **State backups**: periodically export state with `terraform state pull` to a secure artifact (CI job).
* **Practice restores**: rehearse state restore and `terraform import` in a staging environment.
* **Use immutable resource naming** where appropriate and tag resources with `ManagedBy=Terraform` to identify drift quickly.

---

### ⚠️ Common gotchas & mitigation

* **Imported resource HCL mismatch** → plan may attempt to change attributes; fix HCL to match cloud resource.
* **Dependent resources may fail on recreate** → check ordering, add `depends_on` if needed.
* **Manual state edits are risky** → avoid unless last resort; always backup.
* **Sensitive data exposure** in `TF_LOG` or plan JSON → redact secrets and keep artifacts in secure storage.

---

### 💡 In short

* Detect drift with `terraform plan` / `terraform state show`.
* If resource still exists: `terraform import 'module.<name>.<res>' <id>` and align HCL. If deleted: restore state from backup or recreate via `apply`.
* Prevent re-occurrence with remote state versioning, IAM restrictions, CI plan reviews, and a short runbook.
---

## Q: Remote backend unavailable — what to do?

---

### 🧠 Overview

When your remote Terraform backend (S3/DynamoDB, GCS, Azure Blob, Consul, or Terraform Cloud) is unreachable, Terraform CLI operations that read/write state will fail — risking blocked CI, stalled changes, or accidental divergence if people fallback unsafely. This doc shows immediate troubleshooting steps, safe recovery options, and prevention/DR practices.

---

### ⚙️ Purpose / How it works

* Terraform reads/writes state to the **remote backend**; if that backend is down or inaccessible, `terraform init`, `plan`, `apply`, and `state` commands that hit the backend will error.
* The correct response is **diagnose → avoid unsafe local changes → recover state / restore backend → resume operations**.

---

### 🧩 Immediate troubleshooting (fast checklist + commands)

1. **Don’t apply anything locally** — avoid creating divergent state.
2. **Check CLI error message** — it often indicates the backend (S3/GCS/TFC) and auth failure type.
3. **Verify network & DNS**

```bash
# example for S3 endpoint/region reachability
ping s3.amazonaws.com
nslookup s3.amazonaws.com
```

4. **Check credentials / assume-role** (AWS example)

```bash
# confirm current identity
aws sts get-caller-identity

# test S3 access
aws s3 ls s3://my-terraform-states --region ap-south-1
```

5. **Check backend service health**

* S3/GCS/Azure: check cloud provider status page or your infra (VPC endpoints).
* Terraform Cloud: check status.terraform.io and organization tokens.

6. **If using VPC endpoints / PrivateLink** — ensure routing/NACL/SGs allow access to the backend.
7. **Check backend-specific resources**

* S3 backend + DynamoDB locking: ensure DynamoDB table exists & accessible:

```bash
aws dynamodb get-item --table-name terraform-locks --key '{"LockID":{"S":"my-lock"}}'
```

* Azure Blob: check storage account, container, and SAS/credentials.

8. **Look for recent config changes** — IAM policy, KMS key rotation, bucket policy, firewall change that might block access.

---

### 🧩 Safe temporary options (use with caution)

#### A — Use read-only commands locally

* You can still run `terraform plan -refresh=false` to inspect code without touching backend.

```bash
terraform init -backend=false   # skip backend init -> local-only mode
terraform plan -refresh=false
```

**Note:** This prevents state reads; plan won't reflect real infra. Use only for code checks — not for making changes.

#### B — Restore from a known-good local copy (only if backend remains down)

* If you have a recent `state` artifact from CI (e.g., `state.json`), you may run read-only checks. Avoid `state push` unless backend fully restored and you understand the risk.

#### C — If backend is temporarily unavailable and you must proceed (last-resort)

* **Never** apply with a different state backend unless you fully understand divergence risk. If you must, create an explicit temporary plan and coordinate with the team; prefer manual orchestration outside Terraform.
* Better: **pause** changes and restore backend.

---

### 🧩 Recovery steps (recommended path)

1. **Fix the root cause** (network, creds, IAM, KMS, PrivateLink, Terraform Cloud token).
2. **Verify backend access**:

```bash
# AWS S3 example
aws s3 ls s3://my-terraform-states --region ap-south-1
aws s3api list-object-versions --bucket my-terraform-states --prefix prod/terraform.tfstate
```

3. **If state file was corrupted / overwritten, restore from versioned object** (S3) or Terraform Cloud snapshot:

   * For **S3**: find previous version and restore it (download then overwrite the object or use console version-restore).
   * For **Terraform Cloud**: use snapshots / run history to restore.
4. **Re-init Terraform** locally and in CI after backend restored:

```bash
terraform init -reconfigure
terraform plan -out=tfplan.bin
```

5. **Validate with plan** and only `apply` from the saved plan artifact (CI recommended) to avoid drift.

---

### 📋 Troubleshooting table (common causes & checks)

|                     Symptom | Likely cause                     | Quick check/command                                        |
| --------------------------: | :------------------------------- | :--------------------------------------------------------- |
|      `Error: access denied` | IAM/perms or KMS                 | `aws sts get-caller-identity`; check KMS grants            |
|         `Could not connect` | Network, DNS, PrivateLink        | `ping`, `nslookup`, VPC route tables                       |
|      `Lock table not found` | Missing DynamoDB table           | `aws dynamodb describe-table --table-name terraform-locks` |
| `Backend unavailable` (TFC) | TFC outage or token invalid      | Check status.terraform.io; `terraform login`               |
|           `State corrupted` | Partial write / object overwrite | S3 versioning / TFC snapshots                              |

---

### ✅ Best Practices / Disaster Recovery (must-have)

* **Enable versioning** on S3 backend; enable lifecycle retention for state object versions.
* **Enable automatic snapshots** in Terraform Cloud / Enterprise.
* **Backup state artifacts** in CI (store `terraform state pull` output or `tfplan.json`) with secure retention.
* **Monitor and alert**: CloudWatch/Stackdriver/Monitor on backend errors (S3 4XX/5XX, DynamoDB throttling, TFC errors).
* **Use least-privilege but stable IAM** (avoid rotating keys without rollout plan).
* **Test restore process** regularly (drills). Document exact commands and responsible on-call.
* **Multi-region DR**: replicate state bucket or keep cross-region backup for major region failures.
* **Avoid local-only `apply` fallbacks** — they create divergence. If a critical emergency requires manual change, document and re-import/align later.
* **CI gating**: require `plan` artifact and `apply` only from CI runners that use the same backend account/role.
* **Automated detection**: run scheduled checks that `terraform workspace list` / `terraform state pull` and alert on failures.

---

### ⚠️ Gotchas / Cautions

* **`terraform init -backend=false` then apply** will create local state and diverge from remote — **do not** do this except in fully coordinated emergency with post-fix reconciliation.
* **Manual `terraform state push`** can overwrite remote state — use only after careful validation and after taking backups.
* **Restoring older state** may roll back recent legitimate changes if not coordinated — always review `terraform plan` after restore.
* **KMS permission errors** often look like backend failures; verify encryption keys & grants.

---

### 💡 In short

* Don’t apply changes while backend is down. Diagnose network/credentials/KMS/locking issues, restore backend access, then re-init and run `terraform plan` from CI.
* Have S3 versioning / TFC snapshots + CI state backups and a practiced restore playbook — these prevent outages from becoming destructive.

---
## Q: How to manage large Terraform infra (100+ resources)?

---

### 🧠 Overview

Managing large infrastructure (100+ resources) requires **structure, state hygiene, collaboration controls, performance tuning, testing, and safe deployment workflows**. The goals are: reliable builds, fast plans/applies, clear ownership, minimal blast radius, and repeatable CI/CD.

---

### ⚙️ Purpose / How it works

* **Modularize** to group related resources (network, infra, apps).
* **Split state** across logical units (modules/backends) to reduce plan/apply scope and lock contention.
* **Use remote backend + locking** to prevent concurrent state corruption.
* **Adopt CI pipelines** that produce plan artifacts and require approvals for production.
* **Automate testing & drift detection** to catch issues early.
* **Optimize provider and Terraform settings** for faster operations.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Folder layout (recommended)

```
infra/
├── modules/
│   ├── vpc/
│   ├── eks/
│   └── rds/
├── envs/
│   ├── dev/
│   │   └── main.tf  # references modules, separate backend
│   └── prod/
│       └── main.tf
└── shared/
    └── networking.tf  # if using shared state or separate backend
```

#### 2) Example: split backends per domain (envs/prod/backend.tf)

```hcl
terraform {
  backend "s3" {
    bucket         = "tf-states-company"
    key            = "prod/networking/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
  required_version = ">= 1.5.0"
}
```

#### 3) Example: module call

```hcl
module "vpc" {
  source = "../../modules/vpc"
  cidr   = var.vpc_cidr
  tags   = local.common_tags
}
```

#### 4) Moving resources between states safely

```bash
# initialize both backends locally (one workspace at a time)
terraform init -reconfigure -backend-config="key=prod/networking/terraform.tfstate"

# move resource to new module/state (example)
terraform state mv module.old_module.aws_vpc.main module.vpc.aws_vpc.main
# then re-run plan/apply in respective states
```

#### 5) CI snippet: plan per module (GitLab CI example)

```yaml
stages: [validate, plan, apply]
validate:
  script:
    - terraform fmt -check=true
    - terraform init -backend-config="key=$TF_KEY"
    - terraform validate

plan:
  parallel: 4
  script:
    - terraform init -backend-config="key=$TF_KEY"
    - terraform plan -out=tfplan.bin -input=false
    - terraform show -json tfplan.bin > tfplan.json
  artifacts:
    paths: [tfplan.bin, tfplan.json]
apply:
  when: manual
  script:
    - terraform apply -input=false tfplan.bin
```

#### 6) Performance tuning

```bash
# limit provider parallelism if API rate-limited
export TF_CLI_ARGS_apply="-parallelism=10"
terraform apply

# or pass flag
terraform apply -parallelism=10
```

---

### 📋 Table: Split strategies — pros & cons

|                   Strategy | Description                            | Pros                            | Cons                                              |
| -------------------------: | :------------------------------------- | :------------------------------ | :------------------------------------------------ |
|    Single state (monorepo) | All resources in one state file        | Simple, single view of infra    | Slow plans, larger lock blast radius              |
|             Split by layer | Network / infra / apps separate states | Smaller plans, lower contention | More orchestration; cross-state references needed |
|     Split by owner/project | Teams own separate states              | Clear ownership, isolated risk  | Requires design for shared resources              |
| Terraform Cloud workspaces | Workspace per environment/module       | Centralized locking + runs      | Cost (TFC), learning curve                        |

---

### ✅ Best Practices (practical & production-ready)

* **Modularize**: Keep modules small and purposeful (VPC, EKS, RDS, ALB).
* **Split state**: Put long-lived shared infra (VPC, IAM) in their own state; app stacks in separate states.
* **Remote backend + locking**: Use S3 + DynamoDB, GCS, Consul, or Terraform Cloud to avoid concurrent writes.
* **Pin versions**: `required_version` for Terraform and `required_providers` with exact or constrained versions.
* **CI-driven plans**: Always run `terraform plan -out=tfplan.bin` in CI and require manual approval to `apply` for prod. Archive plan JSON for audit.
* **Avoid long `-target` usage**: Use `-target` only for emergency debug; it hides graph effects.
* **State refactor plan**: When splitting state, create a migration runbook: `terraform init`, `terraform state mv`, validate, and commit. Test in staging first.
* **Use data sources for cross-state reads**: `terraform_remote_state` or TFC data sources to consume outputs from other states (minimize tight coupling).
* **Automated drift detection**: Scheduled `terraform plan -refresh-only` or periodic runs in Terraform Cloud. Alert on unexpected diffs.
* **Resource tagging & ownership**: Tags like `Owner`, `Env`, `ManagedBy=Terraform` — helps audits and IAM scoping.
* **Limit blast radius**: Use smaller states for frequently changing resources (app autoscaling groups), keep stable infra separate.
* **Test & lint**: `terraform fmt`, `validate`, `tflint`, `checkov` in CI pre-merge.
* **Secure secrets**: Use Vault/SSM/Secrets Manager + CI role-based access; never store secrets in state or repo.
* **Backup state**: Enable S3 versioning and store state snapshots; practice restores regularly.
* **Monitor & alert**: Log Terraform run failures and backend access issues; instrument provider API rate limits and DynamoDB throttling.
* **Parallelize safely**: Run independent module plans in parallel CI jobs, not concurrent writes to same backend.

---

### ⚠️ Gotchas & mitigation

* **Cross-state dependencies** can cause brittle coupling — prefer outputs + `terraform_remote_state` read-only patterns.
* **State migration risk**: `terraform state mv` can break if types/addresses differ — validate in staging.
* **Lock contention**: Large teams should split state or use run queues in CI.
* **Provider rate limits**: Lower `-parallelism` or add retry/backoff in provider config.
* **Cost & duplication**: Multiple environments double infra—scale down unused envs or use autoscaling to reduce cost.

---

### 💡 In short

* Split infra into small, well-named modules + separate backends to reduce plan scope and lock contention.
* Enforce CI-driven `plan → approve → apply`, pin versions, backup state, and schedule drift detection.
* Migrate state carefully (use `terraform state mv`), test in staging, and keep ownership/tags clear for large teams.

---
## Q: Security & Best Practices (Terraform + AWS)

---

### 🧠 Overview

Practical, production-ready Terraform security and hygiene rules for AWS: protect state, manage secrets, enforce CI checks, and maintain consistent tagging and governance across environments.

---

### ⚙️ Purpose / How it works

* **Remote state + locking** prevents concurrent writes and state corruption.
* **Secrets management** and **no hardcoding** avoid credential leaks in code or state.
* **CI checks** (`fmt`/`validate`) and tagging enforce quality and observability.
* **Least-privilege IAM** and runtime roles limit blast radius.

---

### 🧩 Examples / Commands / Config snippets

#### 🔒 Remote backend (S3 + DynamoDB) — `backend.tf`

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-states"
    key            = "envs/${terraform.workspace}/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

#### 🛡️ Avoid hardcoding / use SSM or Secrets Manager (example using SSM)

```hcl
data "aws_ssm_parameter" "db_password" {
  name = "/prod/db/password"
  with_decryption = true
}

resource "aws_db_instance" "db" {
  identifier = "prod-db"
  password   = data.aws_ssm_parameter.db_password.value
  # other args...
}
```

#### 🔁 CI: fmt & validate (shell)

```bash
terraform fmt -recursive
terraform init -backend-config="bucket=$TF_STATE_BUCKET" -input=false
terraform validate
```

#### 🔖 Tagging standard (locals + usage)

```hcl
locals {
  common_tags = {
    ManagedBy = "Terraform"
    Owner     = "team-infra"
    Env       = terraform.workspace
  }
}

resource "aws_s3_bucket" "app" {
  bucket = "demo-app-${terraform.workspace}"
  tags   = local.common_tags
}
```

---

### 📋 Table: Best Practices (compact)

| Best Practice                      | Why                                | Example / Command                                 |
| ---------------------------------- | ---------------------------------- | ------------------------------------------------- |
| Use Remote State                   | Centralized state + collaboration  | S3 + DynamoDB backend (see snippet)               |
| Lock State Files                   | Prevent concurrent writes          | DynamoDB locking via backend                      |
| Avoid Hardcoding                   | Prevent credential leakage         | Use SSM / Secrets Manager data sources            |
| Secret Management                  | Remove secrets from state          | Use `data.aws_ssm_parameter` or Vault             |
| `terraform fmt` & `validate` in CI | Enforce style & catch errors early | `terraform fmt -recursive` / `terraform validate` |
| Tag All Resources                  | Cost, ownership, filtering         | `tags = local.common_tags`                        |

---

### ✅ Best Practices (quick checklist)

* Remote backend + locking (S3 + DynamoDB) ✅
* S3 bucket versioning & encryption enabled ✅
* Secrets in SSM/Secrets Manager or Vault (never `.tfvars` in repo) ✅
* CI runs `fmt`, `validate`, `plan -out` and stores `tfplan.json` artifacts ✅
* Use short-lived credentials / assume-role for CI (OIDC or STS) ✅
* Tagging policy (`ManagedBy`, `Owner`, `Env`, `CostCenter`) ✅
* Restrict console/API destructive ops via IAM/SCP and require approvals ✅

---

### 💡 In short

Use S3+DynamoDB for remote state+locking, never hardcode secrets (use SSM/Secrets Manager/Vault), enforce `fmt`/`validate` in CI, and tag everything consistently for ownership and cost tracking.

---

## Q: Terraform with AWS (Real-World Integration)

---

### 🧠 Overview

Common, production-focused Terraform resources in AWS: EC2, S3, ECR, IAM — with examples and key commands for integration into CI (Jenkins/GitLab).

---

### ⚙️ Purpose / How it works

* Define resources in modules, reuse across environments, and let CI run `init → plan → apply`.
* Use IAM roles or CI credentials to interact with AWS; prefer assume-role or OIDC for short-lived creds.

---

### 🧩 Examples / Resource Snippets

#### EC2 instance

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  tags = merge(local.common_tags, { Name = "web-${terraform.workspace}" })
}
```

#### S3 bucket

```hcl
resource "aws_s3_bucket" "app_bucket" {
  bucket = "demo-app-${terraform.workspace}"
  acl    = "private"

  versioning { enabled = true }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.common_tags
}
```

#### ECR for Docker images

```hcl
resource "aws_ecr_repository" "repo" {
  name                 = "app"
  image_tag_mutability = "IMMUTABLE"
  tags                 = local.common_tags
}
```

#### IAM role for Lambda / CI assume-role

```hcl
data "aws_iam_policy_document" "lambda_assume" {
  statement {
    effect = "Allow"
    principals { type = "Service"  , identifiers = ["lambda.amazonaws.com"] }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}
```

---

### 📋 Table: Use Case → Key Command

| Use Case               | Terraform Resource                                                      | Key Command / Note                                                    |
| ---------------------- | ----------------------------------------------------------------------- | --------------------------------------------------------------------- |
| Create EC2             | `aws_instance`                                                          | `terraform apply` after plan                                          |
| Create S3 bucket       | `aws_s3_bucket`                                                         | Enable versioning & encryption                                        |
| Use ECR for Docker     | `aws_ecr_repository`                                                    | Build/push from CI (`docker build`, `docker push`)                    |
| Manage IAM Role        | `aws_iam_role`                                                          | Use least-privilege policies; assume-role for CI                      |
| Integrate with Jenkins | CI runs `terraform init/plan/apply` using IAM role or credential plugin | Store artifacts (`tfplan.json`) and gate `apply` with manual approval |

---

### ✅ Best Practices for AWS integration

* Pin provider & Terraform versions (`required_providers` / `required_version`).
* Use module outputs for cross-stack values and `terraform_remote_state` or data sources when needed.
* Push Docker images to ECR from CI using role-based auth (ECR login via `aws ecr get-login-password`).
* Use IAM assume-role / OIDC for CI; avoid long-lived keys in CI variables.
* Keep resource policies (S3, ECR) minimal and scoped to CI roles when needed.

---

### 💡 In short

Common AWS resources (EC2, S3, ECR, IAM) are managed via Terraform modules; integrate via CI using short-lived credentials/assume-role, keep secrets out of state, and enforce best practices (versioning, encryption, tagging, plan artifacts).
