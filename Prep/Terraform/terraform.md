# Terraform

Below is a **clean, professional README-style Markdown document**, with **20 Terraform basics Q&A**, following your exact format.

---

## Q1: What is Terraform and what problems does it solve?

🧠 **Overview**
Terraform is an open-source IaC tool used to provision and manage infrastructure across multiple cloud providers (AWS, Azure, GCP) using declarative configuration files. It solves problems like manual provisioning, configuration drift, inconsistent environments, and multi-cloud complexity.

⚙️ **Purpose / How it works**

* You write `.tf` files describing infrastructure.
* Terraform builds a dependency graph.
* It generates an execution plan, then applies changes.

🧩 **Example**

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "prod-app-logs"
}
```

💡 **In short**
Terraform standardizes, automates, and versions infrastructure provisioning across clouds.

---

## Q2: What is Infrastructure as Code (IaC)?

🧠 **Overview**
IaC is the practice of defining infrastructure using machine-readable configuration files instead of manual processes.

⚙️ **Purpose / How it works**

* Ensures repeatability and eliminates drift.
* Enables CI/CD for infrastructure.
* Allows versioning and peer review.

🧩 **Example**

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

💡 **In short**
IaC turns infrastructure into code that can be managed, automated, and version-controlled.

---

## Q3: What are the main benefits of using Terraform?

🧠 **Overview**
Terraform provides automation, consistency, and multi-cloud support.

📋 **Benefits**

* Declarative and predictable changes
* Multi-cloud provider support
* Built-in dependency graph
* Version-controlled infrastructure
* Modular design
* Works in CI/CD pipelines

💡 **In short**
Terraform gives consistent, reproducible, automated infra provisioning across clouds.

---

## Q4: What is the difference between Terraform and CloudFormation?

📋 **Comparison Table**

| Feature       | Terraform               | CloudFormation             |
| ------------- | ----------------------- | -------------------------- |
| Cloud support | Multi-cloud             | AWS-only                   |
| Language      | HCL                     | JSON/YAML                  |
| State         | Maintains state         | Manages state internally   |
| Modules       | Strong module ecosystem | Limited                    |
| Speed         | Faster with parallelism | Slower for large templates |

💡 **In short**
Terraform = vendor-neutral, flexible.
CFN = AWS-native, tightly integrated.

---

## Q5: What is the difference between Terraform and Ansible?

📋 **Comparison Table**

| Feature   | Terraform       | Ansible                           |
| --------- | --------------- | --------------------------------- |
| Purpose   | Provisioning    | Configuration management          |
| Execution | Declarative     | Procedural + declarative          |
| State     | Maintains state | Stateless                         |
| Use case  | Infra creation  | App config, patching, deployments |

💡 **In short**
Terraform builds infra; Ansible configures it.

---

## Q6: What is a Terraform provider?

🧠 **Overview**
Providers integrate Terraform with external APIs (AWS, GitHub, Kubernetes, Vault).

⚙️ **Purpose**

* Translate resources into API calls.
* Enable provisioning real cloud services.

🧩 **Example**

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

💡 **In short**
Providers are plugins that let Terraform manage resources via APIs.

---

## Q7: What are Terraform resources?

🧠 **Overview**
Resources are the core building blocks that define infrastructure objects (EC2, VPC, S3, IAM).

🧩 **Example**

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345"
  instance_type = "t3.micro"
}
```

💡 **In short**
A resource = one real-world infrastructure object.

---

## Q8: What is a Terraform configuration file?

🧠 **Overview**
A configuration file contains `.tf` definitions for providers, resources, variables, outputs, and modules.

🧩 **Files example**

```
main.tf
variables.tf
outputs.tf
providers.tf
```

💡 **In short**
It’s the code Terraform reads to build your infra.

---

## Q9: What file extensions does Terraform use?

📋 **Extensions**

| File       | Purpose          |
| ---------- | ---------------- |
| `.tf`      | HCL config       |
| `.tf.json` | JSON alternative |
| `.tfstate` | State file       |
| `.tfvars`  | Variable inputs  |

💡 **In short**
Terraform uses `.tf` for configs and `.tfstate` for state.

---

## Q10: What is the purpose of `terraform init`?

🧠 **Overview**
Initializes a working directory for Terraform.

⚙️ **Actions**

* Downloads providers
* Configures the backend
* Prepares modules

🧩 **Command**

```bash
terraform init
```

💡 **In short**
It prepares Terraform to run.

---

## Q11: What does `terraform plan` do?

🧠 **Overview**
Shows a preview of changes before applying them.

⚙️ **Actions**

* Reads state
* Compares config vs real infra
* Outputs an execution plan

🧩 **Command**

```bash
terraform plan
```

💡 **In short**
Plan = dry-run of infra changes.

---

## Q12: What is the purpose of `terraform apply`?

🧠 **Overview**
Applies changes to reach the desired state.

🧩 **Command**

```bash
terraform apply -auto-approve
```

💡 **In short**
Apply executes the plan and provisions resources.

---

## Q13: What does `terraform destroy` do?

🧠 **Overview**
Destroys all managed infrastructure.

🧩 **Command**

```bash
terraform destroy
```

💡 **In short**
Destroy tears down resources defined by Terraform.

---

## Q14: What is the Terraform state file?

🧠 **Overview**
State file records the mapping between Terraform config and real cloud resources.

⚙️ **Purpose**

* Tracks resource IDs
* Detects drift
* Enables incremental updates

💡 **In short**
State is Terraform’s source of truth.

---

## Q15: Why is the state file important?

🧠 **Overview**
Terraform uses state to understand what exists, detect changes, and plan updates.

📋 **Why it matters**

* Prevents accidental resource recreation
* Required for `plan` and `apply`
* Supports team collaboration (remote state)

💡 **In short**
Without state, Terraform cannot safely manage infra.

---

## Q16: What is `terraform.tfstate`?

🧠 **Overview**
It’s the local JSON file storing Terraform-managed resource states.

🧩 **Snippet**

```json
{
  "resources": [
    {
      "type": "aws_s3_bucket",
      "name": "logs"
    }
  ]
}
```

💡 **In short**
It’s the actual Terraform state stored locally.

---

## Q17: Should you commit the state file to version control?

⚠️ **No. Never.**

🔒 **Reasons**

* Contains secrets
* Can cause conflicts
* Must be stored in remote backends (S3 + DynamoDB lock)

💡 **In short**
State belongs in secure remote storage, not Git.

---

## Q18: What are Terraform variables?

🧠 **Overview**
Variables allow parameterization of configuration, enabling reusable and dynamic infrastructure.

🧩 **Example**

```hcl
variable "region" {
  type = string
}
```

💡 **In short**
Variables make configs flexible and environment-agnostic.

---

## Q19: How do you define input variables in Terraform?

🧩 **variables.tf**

```hcl
variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 Instance type"
}
```

🧩 **terraform.tfvars**

```hcl
instance_type = "t3.medium"
```

💡 **In short**
Define variables in `variables.tf` and assign values via `.tfvars`.

---

## Q20: What are output values in Terraform?

🧠 **Overview**
Outputs expose useful information from Terraform-managed resources—useful in CI/CD, modules, or for debugging.

🧩 **Example**

```hcl
output "public_ip" {
  value = aws_instance.web.public_ip
}
```

💡 **In short**
Outputs return values after provisioning (IP, ARNs, IDs).

---
Below is your next **README-style Terraform Q&A set (Q21–Q40)** — clean, production-ready, and interview-focused.

---

## Q21: What is the purpose of `terraform.tfvars`?

🧠 **Overview**
`terraform.tfvars` stores variable values separately from configuration, enabling environment-based customization.

🧩 **Example**

```hcl
region        = "ap-south-1"
instance_type = "t3.medium"
```

💡 **In short**
It’s the default file Terraform loads for variable inputs.

---

## Q22: How do you pass variables to Terraform?

🧠 **Overview**
Variables can be provided through `.tfvars`, CLI flags, environment variables, or via Terraform Cloud workspaces.

📋 **Methods**

| Method          | Example                                 |
| --------------- | --------------------------------------- |
| `.tfvars` file  | `terraform apply -var-file=prod.tfvars` |
| CLI `-var`      | `terraform apply -var="env=prod"`       |
| Env variables   | `export TF_VAR_env=prod`                |
| Terraform Cloud | Workspace variables UI                  |

💡 **In short**
Variables can be passed via file, CLI, env vars, or workspaces.

---

## Q23: What are data sources in Terraform?

🧠 **Overview**
Data sources query existing infrastructure instead of creating new resources.

🧩 **Example**

```hcl
data "aws_ami" "latest" {
  most_recent = true
  owners      = ["amazon"]
}
```

💡 **In short**
Data sources **read** external data; they don’t create anything.

---

## Q24: What is the difference between a resource and a data source?

📋 **Comparison Table**

| Attribute      | Resource              | Data Source          |
| -------------- | --------------------- | -------------------- |
| Purpose        | Creates/manages infra | Reads existing infra |
| Modifies API?  | Yes                   | No                   |
| Has lifecycle? | Yes                   | No                   |

💡 **In short**
Resource = *create/change*; Data source = *lookup*.

---

## Q25: What is a Terraform module?

🧠 **Overview**
A module is a reusable collection of Terraform resources packaged as a logical unit.

🧩 **Structure**

```
modules/
  vpc/
    main.tf
    variables.tf
    outputs.tf
```

💡 **In short**
Modules help you structure and reuse infrastructure code.

---

## Q26: Why would you use modules in Terraform?

📋 **Benefits**

* Reusability across environments
* Standardized patterns
* Reduced code duplication
* Easier maintenance
* Cleaner repos

💡 **In short**
Modules scale Terraform projects via reusability and consistency.

---

## Q27: What is the Terraform Registry?

🧠 **Overview**
A public repository of Terraform modules and providers.

⚙️ **Usage**

* Find official AWS/EKS/VPC modules
* Version modules using semantic tags

💡 **In short**
Registry = marketplace of ready-made Terraform modules.

---

## Q28: How do you reference a module in Terraform?

🧩 **Example**

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "prod-vpc"
  cidr = "10.0.0.0/16"
}
```

💡 **In short**
Use the `module` block with a `source` and optional version.

---

## Q29: What is `terraform fmt` used for?

🧠 **Overview**
Formats Terraform configuration files to standard HCL style.

🧩 **Command**

```bash
terraform fmt -recursive
```

💡 **In short**
It ensures consistent, readable formatting.

---

## Q30: What does `terraform validate` do?

🧠 **Overview**
Checks Terraform files for syntax correctness and internal consistency.

🧩 **Command**

```bash
terraform validate
```

💡 **In short**
Validate confirms configs are syntactically correct before planning.

---

## Q31: What is the purpose of the `.terraform` directory?

🧠 **Overview**
Holds downloaded provider plugins, backend data, and modules.

📋 **Contents**

* Provider binaries
* Module downloads
* Plugin lockfile references

💡 **In short**
It's Terraform’s internal working directory.

---

## Q32: What are Terraform provisioners?

🧠 **Overview**
Provisioners run scripts or commands on local or remote machines, typically for bootstrapping.

⚠️ **Note:** HashiCorp discourages heavy use; prefer cloud-init or configuration tools (Ansible, Chef).

🧩 **Example**

```hcl
provisioner "local-exec" {
  command = "echo Hello"
}
```

💡 **In short**
Provisioners execute commands—but use sparingly.

---

## Q33: What is the difference between local-exec and remote-exec?

📋 **Comparison Table**

| Provisioner   | Runs Where?                | Use case                                 |
| ------------- | -------------------------- | ---------------------------------------- |
| `local-exec`  | On your machine/CI runner  | Logging, API calls, triggering pipelines |
| `remote-exec` | On remote VM via SSH/WinRM | Bootstrapping EC2 instances              |

🧩 **Examples**

```hcl
local-exec  => terraform runner
remote-exec => remote server
```

💡 **In short**
Local-exec runs locally; remote-exec runs inside target machines.

---

## Q34: What is a Terraform backend?

🧠 **Overview**
A backend defines where Terraform stores its state and how operations are performed.

⚙️ **Common backends**

* S3 + DynamoDB locking
* Terraform Cloud
* Consul

🧩 **Example**

```hcl
terraform {
  backend "s3" {
    bucket = "tf-state"
    key    = "prod/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "tf-locks"
  }
}
```

💡 **In short**
Backend = remote storage + state locking for collaboration.

---

## Q35: What is the default backend in Terraform?

🧠 **Overview**
Terraform uses the **local backend** by default.

💡 **In short**
Without configuration, Terraform stores state locally in `terraform.tfstate`.

---

## Q36: What are the main Terraform commands?

📋 **Common Commands**

| Command               | Purpose                |
| --------------------- | ---------------------- |
| `terraform init`      | Initialize project     |
| `terraform plan`      | Preview changes        |
| `terraform apply`     | Provision/update infra |
| `terraform destroy`   | Remove infra           |
| `terraform fmt`       | Format files           |
| `terraform validate`  | Validate syntax        |
| `terraform providers` | Show providers         |
| `terraform graph`     | Show dependency graph  |

💡 **In short**
Init → Plan → Apply → Destroy are the core workflow.

---

## Q37: How do you check the current Terraform version?

🧩 **Command**

```bash
terraform version
```

💡 **In short**
Shows Terraform CLI version and provider metadata.

---

## Q38: What is HCL (HashiCorp Configuration Language)?

🧠 **Overview**
HCL is Terraform’s human-friendly, JSON-compatible configuration language.

⚙️ **Features**

* Declarative
* Strong typing
* Supports expressions and interpolation

🧩 **Example**

```hcl
name = "${var.env}-app"
```

💡 **In short**
HCL is the syntax Terraform uses for its `.tf` config files.

---

## Q39: What are Terraform dependencies?

🧠 **Overview**
Dependencies define how resources relate to each other and in what order they should be created.

⚙️ **Sources of dependencies**

* Attribute references (`aws_vpc.main.id`)
* Implicit ordering
* Explicit `depends_on`

🧩 **Example**

```hcl
resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
}
```

💡 **In short**
Dependencies ensure Terraform builds infra in the correct order.

---

## Q40: How does Terraform determine resource creation order?

🧠 **Overview**
Terraform builds a dependency graph based on references and then applies resources in the required sequence.

⚙️ **Order logic**

* Implicit dependencies: resource attributes
* Explicit dependencies: `depends_on`
* Parallel execution when no dependencies exist

🧩 **Example**

```hcl
resource "aws_instance" "web" {
  subnet_id = aws_subnet.main.id
}
```

💡 **In short**
Terraform uses dependency graphs to decide creation order automatically.

---

# Intermediate

Below is your **Intermediate Terraform Q&A (Q41–Q60)** in full README-style, production-grade Markdown.

---

## Q41: What are implicit and explicit dependencies in Terraform?

🧠 **Overview**
Terraform uses dependencies to determine resource creation order.

📋 **Types**

| Type                    | How it works                                               | Example                           |
| ----------------------- | ---------------------------------------------------------- | --------------------------------- |
| **Implicit dependency** | Created automatically when one resource references another | `subnet.vpc_id = aws_vpc.main.id` |
| **Explicit dependency** | Manually defined using `depends_on`                        | `depends_on = [aws_iam_role.ecs]` |

💡 **In short**
Implicit = automatic via references; Explicit = forced using `depends_on`.

---

## Q42: How do you create explicit dependencies using depends_on?

🧩 **Example**

```hcl
resource "aws_iam_policy" "policy" {
  name = "app-policy"
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.app.name
  policy_arn = aws_iam_policy.policy.arn

  depends_on = [aws_iam_policy.policy]
}
```

💡 **In short**
Use `depends_on` to manually enforce ordering.

---

## Q43: What is remote state in Terraform?

🧠 **Overview**
Remote state stores Terraform state in a shared backend (S3, Terraform Cloud, Consul) instead of the local file system.

⚙️ **Purpose**

* Collaboration
* Automated CI/CD
* State locking
* Increased security

💡 **In short**
Remote state = shared, secure central storage for `tfstate`.

---

## Q44: Why would you use remote state instead of local state?

📋 **Reasons**

| Benefit            | Explanation                              |
| ------------------ | ---------------------------------------- |
| Team collaboration | Shared state for all engineers/pipelines |
| Locking            | Prevents parallel updates                |
| Security           | Store state in encrypted storage         |
| Reliability        | Reduce risk of losing local files        |

💡 **In short**
Remote state is safer, shareable, and CI/CD-friendly.

---

## Q45: How do you configure S3 as a backend for Terraform state?

🧩 **Example**

```hcl
terraform {
  backend "s3" {
    bucket         = "tf-state-prod"
    key            = "network/vpc.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

💡 **In short**
Define an S3 backend block inside `terraform {}`.

---

## Q46: What is state locking and why is it important?

🧠 **Overview**
State locking prevents multiple users or pipelines from modifying state at the same time.

⚙️ **Why?**

* Avoid race conditions
* Avoid state corruption
* Required for stable CI/CD operations

💡 **In short**
State locking ensures only *one* Terraform process modifies state at a time.

---

## Q47: How do you implement state locking with S3 backend?

🧠 **Overview**
Use **DynamoDB** for locking along with the S3 backend.

🧩 **DynamoDB table**

```hcl
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

💡 **In short**
S3 stores state; DynamoDB locks it.

---

## Q48: What is DynamoDB used for in Terraform with S3 backend?

🧠 **Overview**
DynamoDB provides **state locking and consistency checks**.

⚙️ **Purpose**

* Lock tfstate during apply
* Prevent simultaneous state updates

💡 **In short**
DynamoDB = locking mechanism for S3 state.

---

## Q49: What is terraform refresh and when would you use it?

🧠 **Overview**
`terraform refresh` updates the state file based on real-world infrastructure without applying changes.

🧩 **Command**

```bash
terraform refresh
```

⚙️ **Use cases**

* Detect drift
* Update state after out-of-band modifications

💡 **In short**
Refresh syncs state with actual infrastructure.

---

## Q50: What is the difference between terraform plan and terraform apply?

📋 **Comparison**

| Command | Purpose                                       |
| ------- | --------------------------------------------- |
| `plan`  | Preview changes; no modifications             |
| `apply` | Executes the plan and modifies infrastructure |

💡 **In short**
Plan = preview; Apply = execute.

---

## Q51: How do you target specific resources with terraform plan or apply?

🧩 **Example**

```bash
terraform plan -target=aws_instance.web
terraform apply -target=aws_s3_bucket.logs
```

⚠️ **Caution:** Overuse of `-target` can break dependency flow.

💡 **In short**
Use `-target` to operate on specific resources.

---

## Q52: What is terraform taint and why would you use it?

🧠 **Overview**
Marks a resource for recreation during the next apply.

🧩 **Command**

```bash
terraform taint aws_instance.web
```

⚙️ **Use cases**

* Fix corrupted resources
* Force redeployment

💡 **In short**
Taint forces Terraform to recreate a resource.

---

## Q53: What is terraform untaint?

🧩 **Command**

```bash
terraform untaint aws_instance.web
```

🧠 **Overview**
Removes the tainted flag, preventing forced recreation.

💡 **In short**
Untaint = cancel the forced-recreation mark.

---

## Q54: How do you import existing infrastructure into Terraform?

🧩 **Command**

```bash
terraform import aws_s3_bucket.logs my-existing-bucket
```

🧠 **Overview**
Import maps an existing resource to Terraform state.

💡 **In short**
Import links real infra to Terraform but does not create config.

---

## Q55: What are the limitations of terraform import?

⚠️ **Limitations**

* No automatic code generation (`.tf` must be written manually)
* Complex multi-resource imports require many manual steps
* Does not import interpolations, variables, modules

💡 **In short**
Import only maps resources—**you must write the code yourself**.

---

## Q56: What is terraform state and what subcommands does it have?

🧠 **Overview**
`terraform state` helps inspect and modify state files.

📋 **Common subcommands**

| Subcommand | Purpose                      |
| ---------- | ---------------------------- |
| `list`     | Show tracked resources       |
| `show`     | Display resource attributes  |
| `rm`       | Remove a resource from state |
| `mv`       | Move resources within state  |
| `pull`     | Download state               |
| `push`     | Upload state                 |

💡 **In short**
State subcommands allow controlled state manipulation.

---

## Q57: How do you manually move resources in the state file?

🧩 **Command**

```bash
terraform state mv aws_instance.old aws_instance.new
```

🧠 **Use case**
Renaming resources or restructuring modules.

💡 **In short**
`state mv` relocates resources in state without changing infra.

---

## Q58: How do you remove a resource from state without destroying it?

🧩 **Command**

```bash
terraform state rm aws_s3_bucket.logs
```

🧠 **Overview**
Removes state tracking but leaves real infrastructure intact.

💡 **In short**
`state rm` detaches Terraform from a resource.

---

## Q59: What is the purpose of terraform state pull and push?

🧠 **Overview**
These commands allow manual download/upload of the state file.

🧩 **Examples**

```bash
terraform state pull > state-backup.json
terraform state push state-backup.json
```

⚠️ **Use with caution** — can overwrite remote state.

💡 **In short**
Pull = download state; Push = upload state.

---

## Q60: How do you handle sensitive data in Terraform?

🔒 **Best Practices**

* Use `sensitive = true` for outputs
* Use environment variables (`TF_VAR_*`)
* Store secrets in **SSM Parameter Store**, **Secrets Manager**, Vault
* Avoid committing `.tfvars` with secrets
* Use remote state encryption

🧩 **Example**

```hcl
variable "db_password" {
  type      = string
  sensitive = true
}
```

💡 **In short**
Never store secrets in code; use secure secret stores + sensitive flags.

---

Below is your **Advanced Terraform Q&A (Q61–Q80)** in full README-style, production-ready Markdown.

---

## Q61: What is the `sensitive` flag for variables and outputs?

🧠 **Overview**
The `sensitive` flag hides values from CLI output and logs to prevent accidental disclosure.

🧩 **Example**

```hcl
variable "password" {
  type      = string
  sensitive = true
}

output "db_pass" {
  value     = var.password
  sensitive = true
}
```

💡 **In short**
`key = sensitive` masks values during plan/apply/output.

---

## Q62: How do you use `count` in Terraform?

🧠 **Overview**
`count` lets you create multiple instances of a resource using a numeric value.

🧩 **Example**

```hcl
resource "aws_instance" "web" {
  count         = 3
  instance_type = "t3.micro"
  ami           = var.ami_id
}
```

💡 **In short**
`count` = simple numeric loops.

---

## Q63: What is the difference between `count` and `for_each`?

📋 **Comparison Table**

| Feature             | `count`                 | `for_each`              |
| ------------------- | ----------------------- | ----------------------- |
| Type                | Index-based             | Key-based               |
| Best for            | Simple lists            | Sets, maps, named items |
| Resource addressing | `resource[count.index]` | `resource[key]`         |
| Renaming impact     | High (index shifts)     | Low (stable keys)       |

💡 **In short**
Use `count` for numbers; `for_each` for maps/sets and stable resource identity.

---

## Q64: When would you use `for_each` instead of `count`?

🧠 **Use cases**

* When resources require stable identifiers (no index shifting)
* When working with **maps** or **sets of strings**
* When referencing items by name is easier

🧩 **Example**

```hcl
resource "aws_s3_bucket" "logs" {
  for_each = toset(["prod", "dev", "qa"])
  bucket   = "logs-${each.key}"
}
```

💡 **In short**
Use `for_each` when identity matters.

---

## Q65: What are Terraform expressions?

🧠 **Overview**
Expressions evaluate values at runtime—variables, functions, conditionals, references, loops.

🧩 **Example**

```hcl
instance_name = "${var.env}-app-${count.index}"
```

💡 **In short**
Expressions compute values dynamically inside `.tf` code.

---

## Q66: How do you use conditional expressions in Terraform?

🧠 **Overview**
Conditional expressions choose values dynamically using `condition ? true_val : false_val`.

🧩 **Example**

```hcl
instance_type = var.env == "prod" ? "t3.large" : "t3.micro"
```

💡 **In short**
Conditionals allow branching logic inside Terraform.

---

## Q67: What are Terraform functions and where can you use them?

🧠 **Overview**
Terraform provides built-in functions—string, numeric, collection, encoding, filesystem functions.

🧩 **Examples**

```hcl
upper(var.env)
length(var.subnets)
join(",", var.tags)
cidrsubnet(var.vpc_cidr, 4, 1)
```

⚙️ **Where?**
Anywhere expressions are allowed: variables, resources, outputs, modules.

💡 **In short**
Functions compute dynamic values in Terraform.

---

## Q68: What is the purpose of the `lookup` function?

🧠 **Overview**
`lookup()` retrieves a value from a map with an optional default.

🧩 **Example**

```hcl
lookup(var.instance_sizes, var.env, "t3.micro")
```

💡 **In short**
Lookup safely fetches map values without errors.

---

## Q69: How do you use the `merge` function in Terraform?

🧠 **Overview**
`merge()` combines multiple maps into a single map.

🧩 **Example**

```hcl
locals {
  default_tags = {
    env = "prod"
  }

  extra_tags = {
    owner = "teamA"
  }

  tags = merge(local.default_tags, local.extra_tags)
}
```

💡 **In short**
Merge combines two or more maps.

---

## Q70: What is the `file()` function used for?

🧠 **Overview**
Reads file content from disk—commonly used for SSH keys, policies, templates.

🧩 **Example**

```hcl
public_key = file("id_rsa.pub")
```

💡 **In short**
`file()` loads external file content into Terraform.

---

## Q71: How do you work with lists and maps in Terraform?

🧩 **List example**

```hcl
variable "subnets" {
  type = list(string)
}
element(var.subnets, 0)
```

🧩 **Map example**

```hcl
variable "ami_map" {
  type = map(string)
}

lookup(var.ami_map, "prod")
```

⚙️ **Operations**

* `length()`
* `contains()`
* `merge()`
* `toset()`, `tolist()`

💡 **In short**
Lists = ordered; Maps = key-value access.

---

## Q72: What are dynamic blocks in Terraform?

🧠 **Overview**
Dynamic blocks generate nested blocks dynamically when count/for_each cannot be used directly inside nested structures.

🧩 **Example**

```hcl
resource "aws_security_group" "web" {
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port = ingress.value.port
      to_port   = ingress.value.port
      protocol  = "tcp"
      cidr_blocks = ingress.value.cidr
    }
  }
}
```

💡 **In short**
Dynamic blocks let you programmatically create nested blocks.

---

## Q73: When would you use dynamic blocks?

🧠 **Use cases**

* When child blocks must be generated dynamically
* When input is a map/list of objects
* When AWS resources require multiple repeated nested blocks (SG rules, IAM statements)

💡 **In short**
Use dynamic blocks to loop inside nested block structures.

---

## Q74: What is `terraform workspace`?

🧠 **Overview**
Workspaces provide multiple state instances within a single configuration directory.

🧩 **Commands**

```bash
terraform workspace new dev
terraform workspace select prod
terraform workspace list
```

💡 **In short**
Workspaces = multiple state files managed via one config.

---

## Q75: How do workspaces help manage multiple environments?

🧠 **Overview**
Each workspace maintains its own separate state, allowing reuse of the same configuration for different environments (dev/stage/prod).

🧩 **Example**

```hcl
bucket_name = "app-${terraform.workspace}"
```

💡 **In short**
Workspaces isolate environment state.

---

## Q76: What are the limitations of Terraform workspaces?

⚠️ **Limitations**

* Not ideal for production-scale multi-environment setups
* Folder separation or separate repos are clearer
* Hard to manage different configs (VPC CIDRs, sizes per env)
* Terraform Cloud workspaces offer better separation

💡 **In short**
Workspaces are OK for small projects; not great for large/complex environments.

---

## Q77: How do you reference workspace names in configurations?

🧩 **Usage**

```hcl
locals {
  env = terraform.workspace
}
```

💡 **In short**
Use `terraform.workspace` to get the current workspace name.

---

## Q78: What is the difference between workspaces and separate state files?

📋 **Comparison Table**

| Feature            | Workspaces                          | Separate state files (S3 paths, folders) |
| ------------------ | ----------------------------------- | ---------------------------------------- |
| State location     | Same backend, different state files | Different backend keys per env           |
| Best for           | Small projects                      | Production multi-env                     |
| Config differences | Hard                                | Easy (use separate code or vars)         |
| Isolation          | Weak                                | Strong                                   |

💡 **In short**
Workspaces isolate state; separate state files isolate entire environments.

---

## Q79: What are lifecycle meta-arguments in Terraform?

🧠 **Overview**
Lifecycle rules control Terraform’s behavior for resource creation, deletion, and replacement.

📋 **Common arguments**

* `create_before_destroy`
* `prevent_destroy`
* `ignore_changes`

🧩 **Example**

```hcl
resource "aws_instance" "web" {
  lifecycle {
    prevent_destroy = true
  }
}
```

💡 **In short**
Lifecycle customizes how Terraform handles resource updates.

---

## Q80: What does `create_before_destroy` do?

🧠 **Overview**
Ensures Terraform creates a new resource **before** deleting the old one—important for zero-downtime replacements.

🧩 **Example**

```hcl
lifecycle {
  create_before_destroy = true
}
```

⚙️ **Use cases**

* Load balancers
* Auto Scaling resources
* Stateful apps requiring no downtime

💡 **In short**
Creates new → then destroys old (safe rollout).

---
Below is your **Expert Terraform Q&A (Q81–Q100)** — production-grade, clear, and formatted as requested.

---

## Q81: When would you use `prevent_destroy`?

🧠 **Overview**
`prevent_destroy` blocks accidental deletion of critical resources.

🧩 **Example**

```hcl
resource "aws_rds_instance" "prod" {
  lifecycle {
    prevent_destroy = true
  }
}
```

⚙️ **Use cases**

* Databases
* VPCs
* Production S3 buckets

💡 **In short**
Use to protect critical infra from accidental deletion.

---

## Q82: What is `ignore_changes` used for?

🧠 **Overview**
`ignore_changes` tells Terraform to skip applying changes to specific attributes.

🧩 **Example**

```hcl
lifecycle {
  ignore_changes = [tags, ami]
}
```

⚙️ **Use cases**

* Resources modified outside Terraform
* Autoscaling-managed attributes
* AMI replacements handled by launch templates

💡 **In short**
Use when certain attributes should not trigger recreation.

---

## Q83: How do you handle resource recreation in Terraform?

🧠 **Methods**

* Modify resource attributes → triggers recreation
* Use `terraform taint`
* Lifecycle `create_before_destroy`
* Replace via CLI:

```bash
terraform apply -replace=aws_instance.web
```

💡 **In short**
Use taint or `-replace` to force recreation safely.

---

## Q84: What is `null_resource` and when would you use it?

🧠 **Overview**
A `null_resource` represents a resource with no real infrastructure—used for executing provisioners or triggers.

🧩 **Example**

```hcl
resource "null_resource" "notify" {
  triggers = {
    version = var.version
  }

  provisioner "local-exec" {
    command = "echo Deploy ${self.triggers.version}"
  }
}
```

⚙️ **Use cases**

* Running scripts
* Non-infra workflows
* Trigger-based actions

💡 **In short**
Null resources run scripts or depend on triggers only.

---

## Q85: What are local values (locals) in Terraform?

🧠 **Overview**
Locals store intermediate computed values to avoid duplication.

🧩 **Example**

```hcl
locals {
  instance_name = "${var.env}-app"
}
```

💡 **In short**
Locals simplify complex expressions and reuse logic.

---

## Q86: When would you use locals instead of variables?

📋 **Use locals when**

* Value should not be overridden externally
* It's a computed/derived value
* You want to simplify repeated expressions

📋 **Use variables when**

* Input must be configurable
* Values differ across environments

💡 **In short**
Locals = internal computed constants; Variables = external inputs.

---

## Q87: How do you structure Terraform code for reusability?

🧠 **Best practices**

* Use modules for repeatable infra patterns
* Keep root module clean (providers, backend, env-specific overrides)
* Separate files: `main.tf`, `variables.tf`, `outputs.tf`, `providers.tf`
* Use locals to simplify logic
* Store modules in `modules/` directory or private registry

💡 **In short**
Split code into reusable modules + clean root module.

---

## Q88: What is the difference between root modules and child modules?

📋 **Comparison Table**

| Type         | Purpose                                         | Location                                 |
| ------------ | ----------------------------------------------- | ---------------------------------------- |
| Root Module  | Entry point of Terraform execution              | Directory where `terraform apply` is run |
| Child Module | Reusable building block imported by root/module | `modules/` folder or remote registry     |

💡 **In short**
Root = main config; Child = reusable submodule.

---

## Q89: How do you pass outputs from one module to another?

🧩 **Module A (producer)**

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

🧩 **Module B (consumer)**

```hcl
module "network" {
  source = "./modules/network"
}

module "eks" {
  source = "./modules/eks"
  vpc_id = module.network.vpc_id
}
```

💡 **In short**
Expose using `output` and reference via `module.<name>.<output>`.

---

## Q90: What are module sources and what types are supported?

📋 **Supported sources**

| Source Type        | Example                                             |
| ------------------ | --------------------------------------------------- |
| Local path         | `source = "./modules/vpc"`                          |
| Git repo           | `source = "git::https://github.com/org/repo.git"`   |
| Git subdir         | `?ref=tag&depth=1//subfolder"`                      |
| Terraform Registry | `terraform-aws-modules/vpc/aws`                     |
| S3 bucket          | `s3::https://s3.amazonaws.com/bucket/module`        |
| GCS bucket         | `gcs::https://storage.googleapis.com/bucket/module` |

💡 **In short**
Modules can come from local, Git, registry, or object storage.

---

## Q91: How do you version control Terraform modules?

🧠 **Options**

* Git tags
* Registry version constraints
* Semantic versioning

🧩 **Example**

```hcl
source  = "terraform-aws-modules/vpc/aws"
version = "~> 5.0"
```

💡 **In short**
Pin module versions to avoid unexpected changes.

---

## Q92: What is semantic versioning for modules?

🧠 **Overview**
Semantic versioning = MAJOR.MINOR.PATCH (e.g., `3.4.1`).

📋 **Rules**

* MAJOR: Breaking changes
* MINOR: New features (backward compatible)
* PATCH: Bug fixes

💡 **In short**
SemVer provides predictable, safe version upgrades.

---

## Q93: How do you test Terraform modules?

🧠 **Testing approaches**

* Unit-like testing with Terratest (Go tests)
* Integration tests via Kitchen-Terraform
* Validate syntax: `terraform validate`
* CI pipelines running `terraform plan`

🧩 **Terratest Example (Go)**

```go
terraform.InitAndApply(t, options)
```

💡 **In short**
Use Terratest or Kitchen-Terraform for module validation.

---

## Q94: What tools can you use for Terraform testing (Terratest, Kitchen-Terraform)?

📋 **Tools**

| Tool                  | Purpose                                             |
| --------------------- | --------------------------------------------------- |
| **Terratest**         | Go-based infra testing (provision, assert, cleanup) |
| **Kitchen-Terraform** | Test Kitchen runner for infra lifecycle tests       |
| **Checkov**           | Static code security tests                          |
| **tfsec**             | Security scanning                                   |
| **InSpec**            | Validation of infra post-provisioning               |

💡 **In short**
Terratest = integration tests; Kitchen = lifecycle tests; Checkov/tfsec = static checks.

---

## Q95: What is `terraform graph` used for?

🧠 **Overview**
Generates a DOT output of Terraform’s dependency graph.

🧩 **Command**

```bash
terraform graph > graph.dot
```

💡 **In short**
It visualizes relationships between Terraform resources.

---

## Q96: How do you visualize Terraform resource dependencies?

🧩 **Steps**

```bash
terraform graph | dot -Tpng > graph.png
```

🧠 **Tools**

* Graphviz
* Online DOT visualizers
* Atlantis/Spacelift UI additional graphs

💡 **In short**
Use `terraform graph` + Graphviz for visual diagrams.

---

## Q97: What is the purpose of `.terraformignore`?

🧠 **Overview**
Controls which files/directories are excluded when publishing modules.

🧩 **Example**

```
*.md
test/
scripts/
```

💡 **In short**
`.terraformignore` works like `.gitignore` for module packaging.

---

## Q98: How do you handle multiple providers in a single configuration?

🧠 **Overview**
Declare multiple `provider` blocks and assign them to resources or modules.

🧩 **Example**

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu"
  region = "eu-west-1"
}
```

💡 **In short**
Use multiple provider blocks with different configs.

---

## Q99: What are provider aliases and when would you use them?

🧠 **Overview**
Aliases allow multiple configurations of the same provider.

🧩 **Example**

```hcl
provider "aws" {
  alias  = "eu"
  region = "eu-west-1"
}

resource "aws_s3_bucket" "eu_bucket" {
  provider = aws.eu
}
```

⚙️ **Use cases**

* Multi-region deployments
* Multi-account deployments
* Using different permissions

💡 **In short**
Aliases = separate provider configs for separate use cases.

---

## Q100: How do you manage provider versions?

🧠 **Overview**
Use `required_providers` to specify version constraints.

🧩 **Example**

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

⚙️ **Version constraint types**

* `~>` Compatible version
* `>=, <=` Range
* Exact pinning `"= 3.1.0"`

💡 **In short**
Always pin provider versions for deterministic builds.

---
Below is your **Terraform Troubleshooting & Deep-Dive Q&A (Q101–Q120)** — production-grade, README-style, and interview-ready.

---

## Q101: What is the `required_providers` block?

🧠 **Overview**
Defines which providers your configuration depends on and their version constraints.

🧩 **Example**

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

💡 **In short**
It locks provider sources + versions for deterministic builds.

---

## Q102: Why is it important to pin provider versions?

🧠 **Reasons**

* Prevent unexpected breaking changes
* Ensure reproducible deployments
* Maintain consistent CI/CD pipeline behavior
* Avoid drift between developer machines

💡 **In short**
Provider pinning guarantees stability across environments.

---

## Q103: How do you upgrade provider versions safely?

🧠 **Steps**

1. Modify version constraints in `required_providers`.
2. Run:

```bash
terraform init -upgrade
```

3. Run `terraform plan` to review breaking changes.
4. Apply in lower environments first.

💡 **In short**
Use `init -upgrade` + staged rollout + plan review.

---

## Q104: What is `terraform console` used for?

🧠 **Overview**
Interactive REPL for evaluating expressions, debugging variable values, and testing Terraform functions.

🧩 **Example**

```bash
terraform console
> upper("prod")
"PROD"
```

💡 **In short**
A sandbox to test expressions & inspect module outputs.

---

## Q105: How do you debug Terraform configurations?

🧠 **Methods**

* Enable TF logging (`TF_LOG=DEBUG`)
* Use `terraform console`
* Run `terraform plan` with more detail
* Add debug output variables
* Validate code structure (`terraform validate`)

🧩 **Debug output example**

```hcl
output "debug_subnets" {
  value = var.subnets
}
```

💡 **In short**
Use logs, console, outputs, validate, and small test plans.

---

## Q106: What environment variables affect Terraform behavior?

📋 **Common Terraform ENV vars**

| Variable                 | Purpose                         |
| ------------------------ | ------------------------------- |
| `TF_LOG`                 | Logging level                   |
| `TF_LOG_PATH`            | Log output file                 |
| `TF_VAR_<name>`          | Pass variables                  |
| `TF_CLI_ARGS`            | Add default CLI args            |
| `TF_DATA_DIR`            | Override `.terraform` directory |
| `AWS_ACCESS_KEY_ID` etc. | Provider credentials            |

💡 **In short**
ENV vars control logging, vars, paths, and provider auth.

---

## Q107: What is TF_LOG and how do you use it?

🧠 **Overview**
Enables Terraform internal debug logging.

🧩 **Example**

```bash
export TF_LOG=DEBUG
terraform apply
```

Levels: `TRACE`, `DEBUG`, `INFO`, `WARN`, `ERROR`.

💡 **In short**
Set `TF_LOG` to reveal internal execution details.

---

## Q108: How do you enable detailed logging in Terraform?

🧩 **Command**

```bash
export TF_LOG=TRACE
export TF_LOG_PATH=terraform.log
terraform plan
```

🧠 **Overview**
`TRACE` gives the fullest internal logging, saved to file.

💡 **In short**
Use TRACE + TF_LOG_PATH to record deep execution logs.

---

## Q109: What is the `terraform show` command used for?

🧠 **Overview**
Displays state or plan details in a human-readable or JSON format.

🧩 **Command**

```bash
terraform show terraform.tfstate
```

💡 **In short**
`show` reveals full resource details and state attributes.

---

## Q110: How do you output the state in JSON format?

🧩 **Command**

```bash
terraform show -json terraform.tfstate > state.json
```

💡 **In short**
Use `-json` flag to convert plan/output/state to JSON.

---

## Q111: What are provisioners and why should you avoid them?

🧠 **Overview**
Provisioners run scripts/commands on local or remote hosts.

⚠️ **Why avoid**

* Not idempotent
* Hard to debug
* Break declarative model
* Failure handling is inconsistent

💡 **In short**
Provisioners create fragility—use them as last resort.

---

## Q112: What are the alternatives to using provisioners?

🧠 **Alternatives**

* **User-data** / cloud-init (EC2)
* **Start-up scripts** baked into AMIs
* **Configuration management tools**: Ansible, Chef, Puppet
* **CI/CD pipelines** for app bootstrap

💡 **In short**
Use infra-native bootstrapping rather than Terraform provisioners.

---

## Q113: When is it acceptable to use provisioners?

🧠 **Scenarios**

* One-time bootstrapping
* Not supported by provider (rare cases)
* Trigger-based actions (notifications or small hooks)

💡 **In short**
Use provisioners only when no native alternative exists.

---

## Q114: What is the `connection` block used for?

🧠 **Overview**
Defines SSH/WinRM connection details for remote-exec provisioners.

🧩 **Example**

```hcl
connection {
  type        = "ssh"
  host        = aws_instance.web.public_ip
  user        = "ec2-user"
  private_key = file("id_rsa")
}
```

💡 **In short**
Connection = how Terraform reaches a remote machine for commands.

---

## Q115: How do you handle provisioner failures?

🧠 **Methods**

* Use `on_failure` argument
* Use retry logic inside scripts
* Validate commands locally before provisioning
* Prefer idempotent scripts

💡 **In short**
Control failure behavior with `on_failure` + reliable scripting.

---

## Q116: What is the `on_failure` argument for provisioners?

🧠 **Overview**
Defines what happens if a provisioner fails.

📋 **Options**

* `continue` — ignore failure
* `fail` — default, stop apply

🧩 **Example**

```hcl
provisioner "remote-exec" {
  command = "setup.sh"
  on_failure = "continue"
}
```

💡 **In short**
Controls whether Terraform stops or continues after failure.

---

## Q117: What are Terraform templates (`templatefile` function)?

🧠 **Overview**
`templatefile()` renders external template files with variable substitution.

🧩 **Example**

```hcl
locals {
  nginx_conf = templatefile("${path.module}/nginx.tpl", {
    port = 8080
  })
}
```

`.tpl` file:

```
listen ${port};
```

💡 **In short**
Templatefile renders dynamic config files using variables.

---

## Q118: How do you generate configuration files using Terraform?

🧩 **Example using `local_file` resource**

```hcl
resource "local_file" "config" {
  content  = templatefile("${path.module}/app.tpl", { env = var.env })
  filename = "app.conf"
}
```

⚙️ **Alternative**

* Render JSON/YAML for cloud-init
* Pass templates into user-data fields

💡 **In short**
Use `templatefile` + `local_file` or embed templates into user-data.

---

## Q119: What is the difference between `terraform fmt` and `terraform validate`?

📋 **Comparison**

| Command              | Purpose                              |
| -------------------- | ------------------------------------ |
| `terraform fmt`      | Formats code to standard HCL style   |
| `terraform validate` | Checks syntax & internal consistency |

💡 **In short**
Fmt = formatting; Validate = correctness.

---

## Q120: How do you enforce code style in Terraform?

🧠 **Methods**

* Use `terraform fmt -check` in CI
* Use linters (tfsec, TFLint, checkov)
* Use pre-commit hooks
* Enforce formatting in PR pipelines

🧩 **Pre-commit example**

```yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
```

💡 **In short**
Automate fmt + lint checks in CI/CD and pre-commit.

---

# Advanced

---

## Q121: How would you design a multi-account AWS infrastructure using Terraform?

🧠 **Overview**
Design multi-account AWS by separating accounts per function (org-root, shared-services, networking, security, prod, dev) and managing infra with Terraform modules and per-account state/backends.

⚙️ **Purpose / How it works**

* Use AWS Organizations + SCPs for guardrails.
* Centralize identity (IAM/SSO) and logging in shared account.
* Deploy networking (VPCs, Transit Gateway) from a central “network” account.
* Each account has its own Terraform workspace/backed state and CI pipeline.

🧩 **Example / Commands**

```text
accounts/
  network/        -> state: s3://tf-state/network/terraform.tfstate
  shared_services -> state: s3://tf-state/shared/terraform.tfstate
  prod/app        -> state: s3://tf-state/prod/app/terraform.tfstate
```

✅ **Best Practices**

* One module registry for reusable modules.
* Per-account backend (S3 key + DynamoDB lock).
* Least-privilege service roles for CI (assume-role into each account).
* Use cross-account IAM roles and centralized logging/monitoring.
* Tagging and naming standards enforced via policy checks.

💡 **In short**
Partition by account purpose, centralize shared services, use per-account Terraform state and CI with cross-account roles.

---

## Q122: What strategies would you use for managing Terraform state across multiple teams?

🧠 **Overview**
State should be remote, versioned, locked, and strictly access-controlled to allow safe team collaboration.

⚙️ **Purpose / How it works**

* Remote backends (S3, Terraform Cloud) with locking (DynamoDB / native).
* Role-based access via IAM and least privilege.
* Separate state per environment and per team/service; avoid one monolithic state.

🧩 **Example / Commands**

```hcl
backend "s3" {
  bucket         = "org-terraform-state"
  key            = "team-a/app/terraform.tfstate"
  region         = "ap-south-1"
  dynamodb_table = "tf-locks"
  encrypt        = true
}
```

✅ **Best Practices**

* Split state by logical boundary (service/env/team).
* Enforce backend config in CI (do not allow local state in pipelines).
* Use workspaces sparingly — prefer separate backend keys.
* Audit access with AWS CloudTrail; rotate credentials and use IAM roles.

💡 **In short**
Use remote, locked, per-team/state isolation plus strict IAM to manage team collaboration safely.

---

## Q123: How do you implement state isolation for different environments?

🧠 **Overview**
Implement isolation by using separate state files/keys or separate backends per environment (dev/stage/prod).

⚙️ **Purpose / How it works**

* Use environment-specific backend keys or separate S3 buckets.
* CI pipelines select appropriate backend/key or workspace per env.

🧩 **Example**

```hcl
# backend key pattern
key = "service/${var.env}/terraform.tfstate"
```

CI:

```bash
terraform init -backend-config="key=service/${ENV}/terraform.tfstate"
```

✅ **Best Practices**

* Avoid workspaces for serious environment separation—use distinct backend keys.
* Separate IAM roles and credentials per environment.
* Use environment-specific variable files (prod.tfvars) and approval gates for prod.

💡 **In short**
Use separate backend keys (or buckets) + distinct IAM roles and CI pipelines to isolate environments.

---

## Q124: What are the best practices for organizing large Terraform codebases?

🧠 **Overview**
Structure by layers (root modules, shared modules, service modules), enforce module registry and CI linting; keep root modules small.

⚙️ **Purpose / How it works**

* Logical separation: `platform/` (networking, security), `apps/` (each service), `modules/` (reusable).
* Version modules and consume via registry or git tags.

🧩 **Directory Example**

```
infra/
  modules/
    vpc/
    eks/
  live/
    prod/
      network/
      apps/
    dev/
```

✅ **Best Practices**

* One concern per module (SRP).
* Peripheral code: `providers.tf`, `backend.tf`, `variables.tf`, `outputs.tf`.
* Pin module/provider versions.
* CI: fmt, validate, lint (TFLint, tfsec), plan approval.
* Document module inputs/outputs and maintain CHANGELOGs.

💡 **In short**
Modularize by concern, version everything, enforce CI checks, and keep root modules thin.

---

## Q125: How would you implement a CI/CD pipeline for Terraform?

🧠 **Overview**
CI/CD runs formatting, validation, security scans, plan, human approval, and apply with limited-privilege automation.

⚙️ **Purpose / How it works**

* PR triggers: `terraform fmt` => `terraform validate` => static checks (tflint, tfsec) => `terraform plan` (stored artifact).
* Manual approval for prod plans.
* Apply runs in CI with credentials via short-lived assume-role or Terraform Cloud runs.

🧩 **Pipeline Steps (example)**

1. PR: `terraform fmt -check`
2. CI: `terraform init && terraform validate && terraform plan -out plan.tfplan`
3. Upload plan as artifact + human review
4. After approval: `terraform apply plan.tfplan` (using CI role)

✅ **Best Practices**

* Use ephemeral credentials (OIDC/assume-role).
* Do plan in CI and apply in gated CD stage.
* Archive plans and logs; enable drift detection.
* Require peer review and automated policy enforcement.

💡 **In short**
CI validates and produces a plan; CD applies with controlled creds and approval gates.

---

## Q126: What checks would you include in a Terraform CI/CD pipeline?

🧠 **Overview**
Automate formatting, static analysis, policy/security scans, and infra validation before plan/apply.

⚙️ **Checks**

* `terraform fmt -check` (style)
* `terraform validate` (syntax)
* `tflint` (lint)
* `tfsec` / `checkov` (security)
* `terraform plan` and diff outputs
* Policy-as-code checks (Sentinel/OPA)
* Unit/integration tests (Terratest) for critical modules

🧩 **Example**

```bash
terraform init -backend=false
terraform fmt -check
terraform validate
tflint
tfsec
terraform plan -out plan.tfplan
```

✅ **Best Practices**

* Fail fast on critical issues.
* Produce human-readable plan artifacts.
* Run cost estimation and tagging checks.
* Block PR merges on failing policy checks.

💡 **In short**
Combine style, lint, security, plan review, policy, and testing in CI before apply.

---

## Q127: How do you implement automated testing for Terraform code?

🧠 **Overview**
Use unit-ish tests (static analysis), integration tests (provision resources), and post-provision validation.

⚙️ **Tools & Workflow**

* Static: `terraform validate`, `tflint`, `tfsec`.
* Integration: Terratest (Go) or Kitchen-Terraform to apply and assert real infra.
* Smoke tests: health-check endpoints, IAM policies, security group rules.
* Teardown: ensure clean destroy in test teardown.

🧩 **Terratest Example (concept)**

```go
terraform.InitAndApply(t, opts)
// assert resource exists and endpoints respond
terraform.Destroy(t, opts)
```

✅ **Best Practices**

* Run expensive integration tests on PR merge to main or nightly.
* Use small ephemeral test accounts or isolated prefixes.
* Mock external services where possible.

💡 **In short**
Combine fast static checks with selective integration tests that provision & validate actual infra, then teardown.

---

## Q128: What is Terraform Cloud and how does it differ from open-source Terraform?

🧠 **Overview**
Terraform Cloud is a managed service that provides remote runs, state management, VCS integration, locking, and policy enforcement; OSS Terraform is the CLI tool.

⚙️ **Purpose / Differences**

* Remote execution & state: Terraform Cloud runs `plan/apply` in its environment.
* Team features: workspaces, RBAC, VCS connectors, private module registry.
* Policy engine (Sentinel) and cost estimation (paid tiers).
* OSS runs locally or CI; relies on your remote backend.

🧩 **Usage**

* Configure remote execution by connecting repo to Terraform Cloud workspace.

✅ **Best Practices**

* Use Terraform Cloud for centralized run management and secure state if you want hosted service.
* Use VCS-driven workflows and remote runs to avoid exposing secrets to developer machines.

💡 **In short**
Terraform Cloud adds collaboration, remote execution, policy, and state hosting on top of the open-source CLI.

---

## Q129: What are the benefits of using Terraform Cloud/Enterprise?

🧠 **Overview**
Provides enterprise features: remote runs, secure state, RBAC, policy enforcement, audit logs, private module registry, and SSO.

⚙️ **Core Benefits**

* Centralized state & run orchestration.
* Fine-grained access controls and SSO.
* Policy as code (Sentinel) and governance.
* Private module registry and inventory.
* Team collaboration with history and drift detection.

🧩 **Enterprise Use**

* Large orgs use it to enforce guardrails and separate roles (platform vs app teams).

✅ **Best Practices**

* Use workspaces mapped to environments or services.
* Integrate with VCS and CI for pull-request-driven infra changes.

💡 **In short**
Terraform Cloud/Enterprise simplifies secure, auditable, and policy-driven Terraform at scale.

---

## Q130: How does Terraform Cloud handle state management?

🧠 **Overview**
Terraform Cloud stores state securely in its service, provides state locking, version history, and encryption at rest.

⚙️ **Purpose / How it works**

* Each workspace has a remote state file managed by Terraform Cloud.
* Runs are executed remotely (optional) and state is updated centrally.
* API and UI provide history, locking, and snapshots.

🧩 **Usage**

* Link workspace to VCS repo; Cloud handles init/plan/apply and state updates.

✅ **Best Practices**

* Use workspace-per-environment/service model.
* Enable OIDC/SSO and audit logs for access tracking.
* Back up state snapshots if needed.

💡 **In short**
Terraform Cloud centralizes and secures state with locking and history, removing need for S3/DynamoDB setups.

---

## Q131: What are Sentinel policies in Terraform Enterprise?

🧠 **Overview**
Sentinel is a policy-as-code framework integrated into Terraform Enterprise to enforce governance during runs.

⚙️ **Purpose / How it works**

* Write policies in Sentinel language to allow/deny plans (e.g., disallow public S3).
* Policies run during plan/evaluation and can block applies.

🧩 **Example Policy (concept)**

* Block any S3 bucket with `acl = "public-read"`.

✅ **Best Practices**

* Start with advisory policies, then enforce critical ones.
* Maintain policy library and test policies against sample plans.

💡 **In short**
Sentinel enforces organizational policies by evaluating Terraform plans before apply.

---

## Q132: How would you implement policy as code with Terraform?

🧠 **Overview**
Implement policies using Sentinel (Terraform Enterprise), OPA/Gatekeeper, or pre-merge CI checks (tfsec/checkov).

⚙️ **Workflow**

* Integrate policy checks in CI to fail PRs early.
* Use remote policy engine (Sentinel or OPA) to enforce at run-time.
* Store policies in repo, version them, and test against sample plans.

🧩 **Example**

* CI step: `tfsec` -> produce report; fail on high/critical.
* Terraform Cloud: attach Sentinel policies to workspace.

✅ **Best Practices**

* Enforce least-privilege, tagging, encrypted storage, and region restrictions.
* Keep policies modular and testable; provide clear failure messages.

💡 **In short**
Combine pre-commit/CI policy checks with remote enforcement (Sentinel/OPA) for robust policy-as-code.

---

## Q133: What is OPA (Open Policy Agent) and how does it integrate with Terraform?

🧠 **Overview**
OPA is a general-purpose policy engine; it can evaluate policies (Rego) for Terraform plans via tools like Conftest or Gatekeeper for Kubernetes.

⚙️ **Integration Patterns**

* Use `conftest` to run Rego policies against `terraform show -json plan` in CI.
* Use OPA as a service/controller (Gatekeeper) for runtime enforcement in Kubernetes workflows.

🧩 **CI example**

```bash
terraform plan -out plan.tfplan
terraform show -json plan.tfplan > plan.json
conftest test plan.json
```

✅ **Best Practices**

* Keep Rego policies in repo, run them in CI and pre-apply checks.
* Combine OPA checks with tfsec for security posture.

💡 **In short**
OPA evaluates policies against Terraform plan JSON (via conftest) to enforce org rules in CI.

---

## Q134: How do you implement cost estimation in Terraform?

🧠 **Overview**
Estimate cost using third-party tools or services (Infracost, Terraform Cloud cost estimation) that parse plan JSON and map resources to pricing.

⚙️ **Workflow**

* Generate plan JSON: `terraform show -json plan.tfplan`.
* Feed into Infracost CLI or Terraform Cloud cost estimation to get monthly cost breakdowns.

🧩 **Infracost example**

```bash
infracost breakdown --path plan.json
```

✅ **Best Practices**

* Integrate cost estimation into PR checks for visibility.
* Set budgets/alerts and require cost approval for big changes.

💡 **In short**
Use tools like Infracost or Terraform Cloud to compute cost from plan JSON and gate expensive changes.

---

## Q135: What strategies would you use to optimize infrastructure costs in Terraform?

🧠 **Overview**
Optimize cost by right-sizing, reserved/savings plans, autoscaling, spot instances, and lifecycle automation—all enforced via Terraform.

⚙️ **Tactics**

* Use autoscaling + schedule scaling policies.
* Use spot/spot-fleet for non-critical workloads.
* Implement tagging and cost allocation.
* Use modules to standardize instance types and use variables for sizing.
* Automate cleanup of unused resources.

🧩 **Terraform examples**

```hcl
variable "instance_type" { default = "t3.small" }
resource "aws_autoscaling_group" "asg" { ... }
```

✅ **Best Practices**

* Enforce tagging and budget alerts.
* Use CI checks for cost impact (Infracost).
* Consolidate idle workloads, use smaller instances where possible.

💡 **In short**
Combine right-sizing, autoscaling, spot instances, and cost gating in CI to keep spend efficient.

---

## Q136: How do you handle Terraform state drift?

🧠 **Overview**
Detect drift with periodic `terraform plan` runs, then reconcile by either importing changes, refreshing state, or adjusting config.

⚙️ **Workflow**

* Scheduled jobs: `terraform plan` to detect drift and report differences.
* If drift is legit (manual change), import or update config; if accidental, revert out-of-band change or recreate resource.

🧩 **Commands**

```bash
terraform refresh
terraform plan
terraform import aws_resource.id <real-id>
```

✅ **Best Practices**

* Prevent drift by limiting out-of-band changes, use CI for changes.
* Use monitoring/alerting for config changes (CloudTrail).
* Regular drift detection runs with alerting.

💡 **In short**
Detect via scheduled plans, reconcile via import/refresh or config change, and prevent by reducing manual edits.

---

## Q137: What causes state drift and how do you detect it?

🧠 **Overview**
Drift occurs when infra changes outside Terraform (console, other tools), provider bugs, or manual edits; detect via `terraform plan` or drift detection tooling.

⚙️ **Common Causes**

* Manual edits in cloud console.
* Auto-scaling or provider-managed attributes changed.
* External automation (scripts) altering resources.

🧩 **Detection**

* `terraform plan` shows diffs.
* `terraform refresh` updates state then compare.
* Monitoring: CloudTrail, config rules, or third-party drift detectors.

✅ **Best Practices**

* Block console access, require infra changes via Terraform.
* Use `ignore_changes` for provider-managed attributes.
* Automate periodic drift scans.

💡 **In short**
Drift = out-of-band changes; detect with `plan/refresh` and cloud audit logs.

---

## Q138: How would you reconcile state drift in production?

🧠 **Overview**
Reconcile by carefully evaluating drift, importing legitimate resources, or rolling back unintended changes; follow a controlled runbook and approvals.

⚙️ **Steps**

1. Run `terraform plan` to capture drift details.
2. Triage: is drift intentional, transient, or harmful?
3. If intended: update HCL to represent reality, then `terraform apply`.
4. If unintended: revert out-of-band change where feasible or force recreate via `taint`/`apply`.
5. For unmanaged resources: `terraform import` them to state.

🧩 **Run commands**

```bash
terraform plan -out drift-plan.tfplan
# after deciding
terraform apply drift-plan.tfplan
```

✅ **Best Practices**

* Always plan in a staging copy or with a read-only plan first.
* Use approval workflow for production fixes.
* Communicate changes and document reconciliation steps.

💡 **In short**
Assess drift, choose import/update/recreate path, and perform changes via controlled, approved Terraform runs.

---

## Q139: What strategies would you use to prevent state drift?

🧠 **Overview**
Prevent drift by minimizing out-of-band changes, enforcing policy, automating deployments through CI, and running periodic drift detection.

⚙️ **Strategies**

* Enforce change via Terraform (deny console edits with IAM, SCPs).
* Use `ignore_changes` for provider-managed attributes only.
* CI/CD for all infra changes with plan gating.
* Scheduled `terraform plan` audits and alerts.
* Use IaC policy checks and RBAC to restrict direct access.

✅ **Best Practices**

* Train teams to use Terraform; document runbooks.
* Centralize shared resources to reduce multiple owners.
* Audit and alert on manual changes (CloudTrail + Lambda/Notifier).

💡 **In short**
Prevent drift with policy enforcement, CI-managed changes, restricted console access, and automated drift detection.

---
---

## Q140: How do you handle large Terraform state files?

🧠 **Overview**
Large state files become unwieldy — slow plans, large transfers, and higher blast radius on failures. Handle them by sharding state, using remote backends with locking, and minimizing retained sensitive/unused resources.

⚙️ **How it works / Actions**

* Split state by logical boundary (service, region, environment).
* Use remote backends (S3/TF Cloud) with encryption + locking.
* Keep only managed resources (remove orphaned entries).
* Archive old state snapshots and prune unused resources.

🧩 **Examples**

```hcl
# per-service backend key pattern
key = "org/${var.service}/${var.env}/terraform.tfstate"
```

✅ **Best Practices**

* Shard large monoliths into smaller modules/states.
* Use selective `terraform plan -target` only for emergency ops (avoid as regular).
* Compress/archive state history; use backend snapshots for long-term storage.
* Limit outputs and avoid storing large binary blobs in state.

💡 **In short**
Split state and use a remote, locked backend; avoid storing unnecessary data in state.

---

## Q141: What performance issues can arise with large state files?

🧠 **Overview**
Large state causes slow `plan`/`apply`, high memory/time on state download/upload, longer locking durations, and slower diffs.

📋 **Common issues**

* Slow `terraform plan` and `terraform graph` operations.
* Increased network I/O (state pull/push).
* Longer lock times, causing CI bottlenecks.
* Tooling/linters may time out on very large states.

✅ **Mitigations**

* Split state into smaller logical units.
* Use backend with regional proximity (reduce latency).
* Run plan/apply in environment close to backend (CI runners in same region).
* Keep state minimal (no large file contents).

💡 **In short**
Large states slow tooling and CI; split and optimize to improve performance.

---

## Q142: How would you split a monolithic Terraform configuration?

🧠 **Overview**
Refactor a single big configuration into multiple smaller root modules by logical boundaries (networking, platform, apps, infra-per-service).

⚙️ **Steps**

1. Identify logical boundaries (VPC, EKS, databases, apps).
2. Create new folders/roots for each boundary.
3. Export outputs from producer modules and import via `terraform_remote_state` or module outputs.
4. Move resources incrementally using `terraform state mv` and `moved` blocks as necessary.
5. Validate and run in staging before production.

🧩 **Directory Example**

```
infra/
  modules/
  live/
    prod/
      network/   # VPC, subnets
      platform/  # IAM, logging
      services/  # each service has own state
```

✅ **Best Practices**

* Make changes incremental and test each move.
* Use `terraform state mv` to update state without destroying resources.
* Keep one resource type per module where sensible.

💡 **In short**
Break the monolith into per-concern root modules and move state gradually with `state mv`/`moved` blocks.

---

## Q143: What are the trade-offs of splitting state files?

📋 **Trade-offs**

| Advantage             | Drawback                                   |
| --------------------- | ------------------------------------------ |
| Smaller, faster plans | More cross-state coordination complexity   |
| Reduced blast radius  | Need data-sharing mechanism (remote state) |
| Easier team ownership | More backend/configuration overhead        |
| Better parallelism    | Potential duplication of shared resources  |

✅ **Mitigation**

* Use consistent module interfaces and well-defined outputs.
* Automate backend provisioning and CI orchestration.

💡 **In short**
Splitting improves speed and ownership but increases coordination complexity.

---

## Q144: How do you share data between separate Terraform state files?

🧠 **Overview**
Share outputs from one state to another using `terraform_remote_state` data source or a module output consumed by the dependent root/module.

🧩 **Example (terraform_remote_state)**

```hcl
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "tf-state"
    key    = "network/prod/terraform.tfstate"
    region = "ap-south-1"
  }
}

resource "aws_instance" "app" {
  subnet_id = data.terraform_remote_state.network.outputs.public_subnet_id
}
```

✅ **Best Practices**

* Expose minimal, stable outputs from state producers.
* Treat remote outputs as read-only; changes require coordination.
* Consider using a shared module or central data plane for frequently used resources.

💡 **In short**
Use `terraform_remote_state` or module outputs to read values from other state files safely.

---

## Q145: What is `terraform_remote_state` data source used for?

🧠 **Overview**
`terraform_remote_state` reads outputs from another Terraform workspace/state so you can reference those values without duplicating resources.

⚙️ **Use cases**

* Network IDs (VPC/subnets) produced by a network stack.
* IAM roles or shared resources created in a shared-services stack.

🧩 **Example**
(see Q144 example)

✅ **Best Practices**

* Only export necessary values.
* Keep outputs stable (avoid renaming).
* Consider security: restrict access to remote state backend.

💡 **In short**
It lets a Terraform configuration consume outputs from another state.

---

## Q146: How would you implement a hub-and-spoke Terraform architecture?

🧠 **Overview**
Hub-and-spoke centralizes shared services (hub: networking, transit, logging) and connects multiple spoke accounts/environments.

⚙️ **How it works**

* Hub account manages VPCs/Transit Gateway/central logging.
* Spokes (app accounts/environments) connect to hub via peering or Transit GW attachments.
* Use per-account Terraform state and cross-account IAM roles for deployment.

🧩 **Example layout**

```
live/
  hub/
    network/
  spokes/
    account-a/
      app1/
    account-b/
      app2/
```

✅ **Best Practices**

* Centralize cross-cutting concerns (CSP, logs, security).
* Use SSM/Secrets Manager and cross-account roles to share secrets minimally.
* Automate network attachments and route propagation.
* Use IaC policies to enforce no direct internet exposure.

💡 **In short**
Hub = shared infra; Spokes = per-account app infra connected to hub via secure attachments and cross-account roles.

---

## Q147: What strategies would you use for managing Terraform modules at scale?

🧠 **Overview**
Treat modules as internal libraries: version, document, test, and publish to a registry.

⚙️ **Strategies**

* Central private module registry (or Git with tags).
* Semantic versioning and CHANGELOGs.
* Automated CI tests for module changes (unit & integration).
* Linting and security scanning on module PRs.
* Clear input/output contracts and examples.

🧩 **CI Example**

* PR triggers `terraform fmt`, `validate`, `tflint`, `tfsec`, and Terratest integration.

✅ **Best Practices**

* Keep modules small and single-purpose.
* Deprecate old interfaces gracefully (major version bumps).
* Use module templates and a promotion process (dev→staging→prod).

💡 **In short**
Version, test, document, and publish modules via a registry and automate quality checks.

---

## Q148: How do you implement module versioning and release management?

🧠 **Overview**
Use Git tags and semantic versioning; publish versions to a private registry or reference tags in `source`, and enforce upgrade policies.

⚙️ **Steps**

* Tag releases: `git tag v1.2.0 && git push --tags`.
* Pin modules in consumers:

```hcl
module "vpc" {
  source  = "git::https://...//modules/vpc?ref=v1.2.0"
}
```

* Use CI to publish to a registry when tags are pushed.

✅ **Best Practices**

* Semantic versioning for breaking vs non-breaking changes.
* Release notes and changelogs.
* Automated tests for each release.

💡 **In short**
Tag releases, pin consumers to refs, and automate publishing + tests.

---

## Q149: What is a private module registry and when would you use one?

🧠 **Overview**
A private registry (Terraform Cloud or self-hosted) stores and serves internal modules with versioning, access control, and discoverability.

⚙️ **Use cases**

* Large orgs needing governance and discoverability.
* Enforce approved modules and versions; manage access.

✅ **Benefits**

* Central catalog, RBAC, download metrics, and simplified `source` references.

💡 **In short**
Use private registry to centralize, version, and control internal modules.

---

## Q150: How do you handle breaking changes in Terraform modules?

🧠 **Overview**
Plan breaking changes carefully: bump major version, provide migration guide, and support compatibility layers where possible.

⚙️ **Steps**

1. Create v2 branch/module with new interface.
2. Document migration steps and provide examples.
3. Publish module with major version bump.
4. Update consumers in controlled rollout (CI, canary).
5. Offer deprecation warnings in previous versions.

✅ **Best Practices**

* Avoid breaking changes in minor/patch releases.
* Use `moved` blocks and `state mv` for resource renames when refactoring.
* Communicate changes and timeline to consumers.

💡 **In short**
Use major-version bumps, docs, migration guides, and staged rollouts for breaking changes.

---

## Q151: What strategies would you use for migrating Terraform versions?

🧠 **Overview**
Migrate Terraform CLI and provider versions in controlled stages with compatibility checks, upgrade tools, and testing.

⚙️ **Steps**

1. Read upgrade guides between versions.
2. Pin current versions and test upgrade in a dev/staging workspace.
3. Use upgrade helper commands where available (0.12upgrade, 0.13upgrade historically).
4. Run `terraform init -upgrade`, `terraform plan`, run tests.
5. Rollout across environments incrementally.

✅ **Best Practices**

* Backup state before upgrades.
* Use automation to run `fmt`, `validate`, and `plan`.
* Address deprecation warnings before major upgrades.

💡 **In short**
Stage upgrades in non-prod, backup state, test thoroughly, and roll out incrementally.

---

## Q152: How do you handle deprecated resources and attributes?

🧠 **Overview**
Replace deprecated resources/attributes proactively—update modules, refactor HCL, and run validation.

⚙️ **Steps**

* Identify deprecations via `terraform plan` warnings and provider changelogs.
* Refactor code to new resource/attribute names.
* Use `moved` blocks or `terraform state mv` to keep state consistent.
* Test and deploy in non-prod first.

✅ **Best Practices**

* Monitor provider release notes.
* Track deprecation timelines and plan migration windows.
* Automate static scanning to catch deprecated usage.

💡 **In short**
Detect deprecations early, refactor code, and move state carefully with tests.

---

## Q153: What is the `terraform 0.13upgrade` command used for?

🧠 **Overview**
(`terraform 0.13upgrade` was a helper tool provided for upgrading configurations to be compatible with Terraform 0.13 — it updated provider blocks and module sources.)

⚙️ **Purpose**

* Automated refactor of configs for 0.13 provider/module syntax changes (historical).
* After running, you still needed to `terraform init` and `plan` and fix remaining issues.

💡 **In short**
A one-time migration helper used when moving to Terraform 0.13 (historical upgrade aid).

---

## Q154: How would you migrate from Terraform 0.11 to 1.x?

🧠 **Overview**
Migrate in steps, using intermediate upgrade tools: 0.11 → 0.12 (use `terraform 0.12upgrade`), then iteratively to later versions (0.13, 0.14, … → 1.x), fixing HCL, providers, and state along the way.

⚙️ **Steps**

1. Backup state.
2. Run `terraform 0.12upgrade` and address HCL changes.
3. Upgrade to 0.13/0.14 using `init -upgrade` and config updates.
4. Run `terraform plan` at each step and fix warnings.
5. Run tests and roll out.

✅ **Best Practices**

* Upgrade one workspace at a time (dev first).
* Read provider/module changelogs; pin providers.
* Use CI to run `fmt`, `validate`, and `plan`.

💡 **In short**
Do staged upgrades (0.11→0.12→…→1.x) with backups, fixes, and testing at each stage.

---

## Q155: What are `moved` blocks in Terraform and when were they introduced?

🧠 **Overview**
`moved` blocks (introduced in Terraform 1.1 as part of refactoring aids) let you tell Terraform that resources moved from one address to another — enabling refactoring without destroying/recreating.

⚙️ **Purpose**

* Smooth refactors (renames, module moves) while preserving state association.

🧩 **Example**

```hcl
moved {
  from = aws_instance.old_name
  to   = module.new.aws_instance.new_name
}
```

💡 **In short**
`moved` maps old resource addresses to new ones to preserve state during refactors.

---

## Q156: How do `moved` blocks help with refactoring?

🧠 **Overview**
They allow renaming/restructuring resources/modules in code while telling Terraform to retain the previous resource ID in state — avoiding destructive `taint`/`import` workflows.

⚙️ **Workflow**

* Add `moved` block(s) in a temporary HCL file.
* Run `terraform init && terraform plan` — Terraform updates addresses without recreating resources.

✅ **Best Practices**

* Use for large refactors to maintain uptime and state integrity.
* Test in a staging workspace first.

💡 **In short**
`moved` blocks make refactors safe by remapping state addresses to new code locations.

---

## Q157: What is the `replace` lifecycle argument (Terraform 1.2+)?

🧠 **Overview**
`replace` lifecycle is a modern way to request controlled replacement of a resource without using `taint`/`-replace` CLI; it allows specifying replacement behavior programmatically.

⚙️ **Use**

* Programmatically request a replacement when certain conditions change.

🧩 **Example conceptual**

```hcl
lifecycle {
  replace {
    when = some_condition
  }
}
```

*(Note: exact syntax/semantics vary by Terraform version; prefer `-replace` CLI or `taint` for explicit operations where needed.)*

💡 **In short**
`replace` lets you express replacement intents in cfg (use with care and test per-version docs).

---

## Q158: How do you implement disaster recovery for Terraform state?

🧠 **Overview**
Ensure state availability and recoverability with multi-region backups, snapshots, and documented recovery procedures.

⚙️ **Measures**

* Backend snapshots (S3 versioning + cross-region replication).
* Enable state history retention (Terraform Cloud snapshots).
* Store copies of state in secure backup storage (encrypted).
* Automate periodic downloads of state to archive.

🧩 **Example (S3)**

* Enable S3 Versioning + lifecycle rules to retain versions.
* Configure cross-region replication for additional resilience.

✅ **Best Practices**

* Test state restore drills.
* Keep IAM policies strict and rotate credentials.
* Store offline copies in long-term secure storage.

💡 **In short**
Back up state (versioning/replication), test restores, and document recovery runbooks.

---

## Q159: What backup strategies would you use for Terraform state files?

📋 **Strategies**

* S3 with versioning + lifecycle + cross-region replication.
* Periodic `terraform state pull` artifacts stored in secure object storage.
* Terraform Cloud / Enterprise is used for managed state snapshots.
* Automated retention policies and point-in-time snapshots.

🧩 **Commands**

```bash
terraform state pull > backups/state-$(date +%F).json
aws s3 cp backups/state-2025-12-11.json s3://tf-state-backups/
```

✅ **Best Practices**

* Encrypt backups and restrict access.
* Retain multiple historical versions and test restores.
* Keep backups immutable for a retention period.

💡 **In short**
Use backend features (versioning/replication) + automated state pulls to secure and archive state history.

---

## Q160: How do you recover from a corrupted state file?

🧠 **Overview**
Recover by using backups, `state pull`/`push`, manual state edits as last resort, or re-importing resources into a clean state.

⚙️ **Recovery options**

1. **Restore from backup snapshot** (S3 version or archived `state.json`).

   ```bash
   aws s3 cp s3://tf-state-backups/state-2025-12-10.json ./terraform.tfstate
   ```
2. **Use `terraform state push`** to upload a repaired state (dangerous—use with care).

   ```bash
   terraform state push repaired.tfstate
   ```
3. **Recreate state**: init an empty state and `terraform import` existing resources into it.

   ```bash
   terraform import aws_s3_bucket.mybucket my-bucket-name
   ```
4. **Manual JSON edit** only if you know the format; validate with `terraform show -json` and test in non-prod first.

✅ **Best Practices**

* Always have recent backups and test restore procedures.
* Work in a copy of the state; never overwrite production state without validation.
* Communicate and coordinate with team (state mutation is high-risk).

💡 **In short**
Restore from backup if available; otherwise rebuild state via imports or carefully `push` a repaired state—always test and back up first.

---
Below is your **Terraform Expert+ Q&A (Q161–Q178)** — production-grade, README-style, and CI/CD-friendly.

---

## Q161: What is state versioning and how does it work?

🧠 **Overview**
State versioning means storing previous versions of the Terraform state file so any state change can be reviewed or reverted.

⚙️ **How it works**

* S3 Versioning: every update creates a new object version.
* Terraform Cloud: stores version history automatically.
* State updates after each `apply` generate a new version.

💡 **In short**
State versioning keeps a full history of state changes for auditing and rollback.

---

## Q162: How do you roll back to a previous state version?

🧠 **Overview**
You restore an earlier state snapshot by downloading an older version and pushing it back to the backend.

🧩 **S3 example**

```bash
aws s3api get-object --bucket tf-state --key prod/app/terraform.tfstate --version-id <version> old.tfstate
terraform state push old.tfstate
```

⚠️ **Caution:** Always test rollback in staging before production.

💡 **In short**
Pull an older version → validate → `terraform state push` to restore.

---

## Q163: How would you implement multi-region disaster recovery using Terraform?

🧠 **Overview**
Use Terraform to provision active/standby or active/active infra across regions with replicated data and region-specific modules/states.

⚙️ **Strategy**

* Duplicate modules per region (`region_a`, `region_b`).
* Cross-region replication for S3, DynamoDB, RDS read replicas.
* Health checks + Route53 failover routing.
* Separate backend keys per region for state isolation.

🧩 **Example**

```
live/
  region-a/
  region-b/
```

💡 **In short**
Define infra in multiple regions, replicate data, and use failover routing + region-specific states.

---

## Q164: What strategies would you use for zero-downtime infrastructure updates?

🧠 **Overview**
Use rolling updates, create-before-destroy, ALB/ELB target groups, autoscaling strategies, and phased module updates.

⚙️ **Techniques**

* `create_before_destroy = true`
* Rolling ASG updates
* Immutable AMI deployments
* Use Launch Templates instead of modifying instances in place
* ALB target group draining

💡 **In short**
Leverage rolling/immutable patterns and Terraform lifecycle settings to avoid downtime.

---

## Q165: How do you implement blue-green deployments with Terraform?

🧠 **Overview**
Blue-green uses two separate environments (blue=current, green=new). Switch traffic only when green is tested.

⚙️ **Approach**

* Deploy new infra stack (`green`) with separate resources.
* Reference environment via variables (`active_env`).
* Route traffic using ALB, Route53, or API Gateway cutover.
* Reduce/destroy old (`blue`) after cutover.

🧩 **Example**

```hcl
locals {
  env_suffix = var.active_env == "green" ? "green" : "blue"
}
```

💡 **In short**
Provision duplicate infra and switch traffic atomically.

---

## Q166: How would you handle stateful resources during blue-green deployments?

🧠 **Overview**
Stateful resources must not be duplicated blindly; use shared patterns or migration strategies.

⚙️ **Strategies**

* Shared datastore (e.g., RDS blue-green failover, read replicas).
* Use DB snapshot + restore for new env.
* For S3, use versioned buckets shared across blue/green.
* Avoid duplicating persistent resources in Terraform unless required.

💡 **In short**
Stateful infra is shared or migrated, not duplicated — use DB failover, replication, or snapshots.

---

## Q167: What are the challenges of managing databases with Terraform?

🧠 **Overview**
Databases are long-lived, stateful, sensitive, and risky to destroy.

⚙️ **Challenges**

* Preservation of data (accidental deletes).
* Downtime management on changes.
* Parameter group changes requiring reboot.
* Limited ability to model schema migrations.

💡 **In short**
Terraform is good for DB infra, not schema/data; treat DB updates carefully.

---

## Q168: How do you handle database credentials in Terraform?

🔒 **Secure Methods**

* Store credentials in Secrets Manager or SSM Parameter Store.
* Use environment variables: `TF_VAR_db_password`.
* Avoid hardcoding or using plain `.tfvars`.

🧩 **Example**

```hcl
data "aws_secretsmanager_secret_version" "db_pass" {
  secret_id = "prod/db"
}
```

💡 **In short**
Never store DB passwords in code; fetch via secure secret stores.

---

## Q169: What strategies would you use for managing secrets in Terraform?

🧠 **Overview**
Use Terraform as a consumer of secrets, not a storage mechanism.

⚙️ **Strategies**

* AWS Secrets Manager / SSM Parameter Store / Vault.
* Use `sensitive = true`.
* Pass secrets via environment variables only.
* Avoid storing secrets in state (or mark resources sensitive).

💡 **In short**
Store secrets outside Terraform; only reference them securely.

---

## Q170: How do you integrate HashiCorp Vault with Terraform?

🧠 **Overview**
Terraform uses the Vault provider to read secrets dynamically and generate ephemeral credentials.

⚙️ **How it works**

* Authenticate Terraform to Vault (token, AppRole, AWS IAM auth).
* Use Vault provider to read or generate secrets.
* Outputs treated as `sensitive`.

🧩 **Example**

```hcl
provider "vault" {
  address = "https://vault.company.com"
}

data "vault_kv_secret_v2" "db" {
  mount = "secret"
  name  = "db/creds"
}
```

💡 **In short**
Terraform reads secrets from Vault via the Vault provider—no storage inside state.

---

## Q171: What is the Vault provider and how do you use it?

🧠 **Overview**
The Vault provider lets Terraform authenticate to Vault and read/generate secrets (KV, PKI, dynamic DB creds).

🧩 **Example**

```hcl
data "vault_generic_secret" "api_key" {
  path = "secret/api"
}
```

⚙️ **Usage**

* Use for secret retrieval, PKI generation, or dynamic secrets.
* Avoid writing secrets into Terraform-managed resources unless required.

💡 **In short**
The Vault provider is Terraform’s interface to Vault’s secrets and dynamic credential engines.

---

## Q172: How do you implement dynamic credentials using Terraform?

🧠 **Overview**
Dynamic credentials rotate automatically and have short TTLs—Terraform retrieves them but does not store long-lived creds.

⚙️ **Approach**

* Use Vault dynamic engines (AWS, DB).
* Terraform fetches credentials using data sources (Vault provider).
* Credentials expire naturally.

🧩 **Example**

```hcl
data "vault_aws_access_credentials" "creds" {
  backend = "aws"
  role    = "prod-app-role"
}
```

💡 **In short**
Use Vault dynamic engines + Terraform data sources to consume short-lived creds.

---

## Q173: What are generated resources in Terraform?

🧠 **Overview**
Generated resources produce dynamic values during Terraform operations—random IDs, passwords, timestamps, TLS certs, etc.

⚙️ **Examples**

* `random_id`, `random_password`, `random_pet`
* `tls_private_key`
* `time_rotating`

💡 **In short**
Resources that generate dynamic data used by the rest of your infrastructure.

---

## Q174: How do you use random resources for generating values?

🧩 **Example**

```hcl
resource "random_password" "db_pass" {
  length  = 20
  special = true
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = random_password.db_pass.result
}
```

⚙️ **Use cases**

* Passwords
* Unique names
* IDs for buckets or S3 prefixes

💡 **In short**
Random provider generates reproducible-but-stored values tied to state.

---

## Q175: What is the time provider used for?

🧠 **Overview**
Generates timestamps or triggers periodic updates for rotation patterns.

⚙️ **Examples**

* `time_rotating` for periodic key rotation
* `time_offset` for future/past timestamps

🧩 **Example**

```hcl
resource "time_rotating" "key_rotation" {
  rotation_days = 30
}
```

💡 **In short**
Time provider triggers scheduled updates or timestamp-based workflows.

---

## Q176: How would you implement compliance checks in Terraform?

🧠 **Overview**
Use policy-as-code tools before apply and static checks during CI.

⚙️ **Approach**

* Pre-commit + CI: `tflint`, `tfsec`, `checkov`.
* Policy engine: Sentinel or OPA (conftest).
* PR blocking rules for failing checks.

🧩 **CI Example**

```bash
checkov -d .
conftest test plan.json
```

💡 **In short**
Use static scanners + policy engines to enforce compliance rules before apply.

---

## Q177: What tools would you use for security scanning Terraform code?

📋 **Tools**

| Tool             | Purpose                        |
| ---------------- | ------------------------------ |
| **Checkov**      | Deep IaC security scanning     |
| **tfsec**        | Security checks for Terraform  |
| **TFLint**       | Lint + AWS best practices      |
| **OPA/Conftest** | Policy-as-code validation      |
| **Snyk IaC**     | IaC misconfiguration detection |

💡 **In short**
Use tfsec + Checkov + OPA for strong multi-layer security scanning.

---

## Q178: How do you implement least privilege principles in Terraform?

🧠 **Overview**
Least privilege means granting only the permissions required, nothing more—Terraform must enforce minimal IAM policies.

⚙️ **Strategies**

* Use IAM policy documents with strict actions & resource ARNs.
* Avoid `"*"` in Actions/Resources.
* Use boundary policies, SCPs, IAM conditions.
* Generate IAM using modules with predefined least-privilege templates.
* Use static scanners to detect wildcard permissions.

🧩 **IAM Example**

```hcl
data "aws_iam_policy_document" "restricted" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::mybucket/*"]
  }
}
```

💡 **In short**
Define minimal IAM, avoid wildcards, and enforce privilege boundaries via IaC + policy scans.

---

---

## Q179: What are Terraform Cloud workspaces and how do they differ from CLI workspaces?

🧠 **Overview**
Terraform Cloud workspaces are managed units in Terraform Cloud that store remote state, history, runs, variables, and VCS settings. CLI workspaces are lightweight, local state namespaces within the CLI backend.

⚙️ **Purpose / How it works**

* **TFC workspaces**: map a VCS repo/branch, run plans remotely, enforce policies, store variables securely, provide RBAC and audit logs.
* **CLI workspaces**: provide multiple state instances in one local backend; no remote runs, no RBAC, minimal features.

🧩 **Examples**

```text
# CLI workspace
terraform workspace new dev
terraform workspace select dev

# Terraform Cloud: create workspace in UI or via API and connect repo
```

📋 **Comparison**

| Feature                      | Terraform Cloud Workspaces | CLI Workspaces               |
| ---------------------------- | -------------------------: | ---------------------------- |
| Remote runs & state          |                          ✅ | ❌ (local unless backend set) |
| VCS integration              |                          ✅ | ❌                            |
| RBAC / audit logs            |                          ✅ | ❌                            |
| Variable management (secure) |                          ✅ | basic env/TFVARS             |
| Suitable for teams           |                          ✅ | limited (local)              |

✅ **Best Practices**
Use TFC workspaces for team-driven, VCS-backed workflows; reserve CLI workspaces for simple local experiments.

💡 **In short**
TFC workspaces = managed, secure, team-oriented; CLI workspaces = local, lightweight namespaces.

---

## Q180: How do you implement VCS-driven workflows in Terraform Cloud?

🧠 **Overview**
VCS-driven workflow triggers Terraform Cloud runs automatically on changes to a connected repository or branch, producing plan artifacts and enforcing policy before apply.

⚙️ **How it works**

* Connect a workspace to a VCS repo + branch.
* Commits/PR merges trigger Terraform Cloud to `plan` using workspace variables and the remote backend.
* Policies (Sentinel/OPA) and manual approvals can gate `apply`.

🧩 **Steps**

1. Create workspace in TFC and attach VCS repo.
2. Configure workspace variables (sensitive ones marked).
3. Set automatic run triggers (on PR/merge).
4. Enforce policy checks and optionally require an approval step.

✅ **Best Practices**
Require PRs for changes, run static checks in CI, and enable policy checks in Terraform Cloud before any apply.

💡 **In short**
Connect repo → TFC plans on commits → enforce policies/approvals → apply with remote execution.

---

## Q181: What are run triggers in Terraform Cloud?

🧠 **Overview**
Run triggers are workspace-to-workspace dependencies in Terraform Cloud that automatically queue a run in a downstream workspace after an upstream workspace completes a successful run.

⚙️ **How it works**

* Configure Workspace B to be triggered by Workspace A.
* When A completes an apply, B receives an automatic plan/run (useful for dependent stacks).

🧩 **Use cases**

* Network/workspace provisioning (network apply triggers app workspace plan).
* Sequencing shared resource updates across environments.

✅ **Best Practices**
Use run triggers for controlled orchestration; avoid cascading automatic applies without approvals for production.

💡 **In short**
Run triggers automate cross-workspace orchestration in Terraform Cloud.

---

## Q182: How do you implement cross-workspace dependencies?

🧠 **Overview**
Cross-workspace dependencies can be implemented using Terraform Cloud run triggers and `terraform_remote_state` (or outputs published by upstream workspace) to consume outputs safely.

⚙️ **Approach**

* Upstream workspace exposes outputs.
* Configure run triggers so downstream workspaces plan after upstream applies.
* Downstream uses remote state data source or TFC workspace outputs (via API) to read values.

🧩 **Example**

```hcl
data "terraform_remote_state" "network" {
  backend = "remote"
  config = { organization = "org", workspaces = { name = "network-prod" } }
}
```

✅ **Best Practices**
Use run triggers + remote state to ensure downstream plans have latest upstream outputs and include manual approval gates for production.

💡 **In short**
Use TFC run triggers + remote state to sequence and share data between workspaces.

---

## Q183: What is the `terraform plan -out` feature and when would you use it?

🧠 **Overview**
`terraform plan -out=plan.tfplan` saves a binary plan artifact that can later be applied with `terraform apply plan.tfplan`. It ensures the exact planned actions are applied without recomputing differences.

⚙️ **When to use**

* CI: generate and store plan in PR, then apply the same plan in CD.
* Approval workflows: reviewers inspect plan before apply.
* Prevent drift between plan and apply.

🧩 **Commands**

```bash
terraform plan -out=plan.tfplan
# later
terraform apply plan.tfplan
```

✅ **Best Practices**
Store plan artifacts securely and treat them as sensitive (they contain resource details). Use them for separation of plan/apply duties.

💡 **In short**
`-out` produces a reproducible plan artifact to be applied later (CI → CD separation).

---

## Q184: How do you ensure plan files are not tampered with?

🧠 **Overview**
Protect plan integrity by restricting access, using remote execution (so plans never leave the runner), signing artifacts, and storing them in controlled artifact stores.

⚙️ **Methods**

* Use Terraform Cloud remote runs (no local plan files transferred).
* Store plan artifacts in secure CI artifact storage with strict IAM.
* Sign plans using CI signing keys or use provenance metadata.
* Limit access to artifact storage and audit reads.

🧩 **Example**

* CI: `terraform plan -out=plan.tfplan`; upload to secure S3 with restricted ACLs; sign with GPG.

✅ **Best Practices**
Prefer remote plan+apply in trusted system (TFC) or use signed artifacts and strict access controls when moving plans between stages.

💡 **In short**
Use remote runs or secure, auditable artifact stores + signing to prevent tampering.

---

## Q185: What are the security implications of storing plan files?

🧠 **Overview**
Plan files may contain sensitive information (resource IDs, ARNs, IPs, and sometimes secrets if misconfigured) and can reveal infrastructure topology — exposing them increases attack surface.

⚠️ **Risks**

* Leak of sensitive resource identifiers.
* Exposure of variables mistakenly included (if secrets placed in vars).
* Tampering could change intended operations.

🧩 **Mitigations**

* Mark sensitive variables; avoid secrets in plan.
* Encrypt artifacts at rest and in transit.
* Limit access and enable audit logging.
* Prefer remote runs (no persistent plan artifacts).

✅ **Best Practices**
Treat plan artifacts as sensitive: secure storage, encryption, least privilege, and auditing.

💡 **In short**
Plan files can leak sensitive infra details — secure and minimize their use.

---

## Q186: How would you implement custom providers in Terraform?

🧠 **Overview**
Custom providers are written using the Terraform Plugin SDK to integrate with APIs not covered by existing providers.

⚙️ **How it works**

* Implement provider schema, resources/data sources, authentication, CRUD methods.
* Build the provider binary and distribute (via releases, registry, or local filesystem).

🧩 **High-level steps**

1. Scaffold provider using Plugin SDK (Go).
2. Implement resource/data source handlers (Create/Read/Update/Delete).
3. Build and test provider; publish binary or host in registry.

✅ **Best Practices**
Follow provider patterns used by HashiCorp, provide docs/examples, implement retries/backoff, and include unit/integration tests.

💡 **In short**
Use the Terraform Plugin SDK (Go) to implement and ship custom providers for unsupported APIs.

---

## Q187: What is the Terraform Plugin SDK?

🧠 **Overview**
A Go library and set of tools for building Terraform providers and provisioners. It provides lifecycle hooks, schema types, helpers, and testing utilities.

⚙️ **Use**

* Define provider resources, attributes, validation, and CRUD logic.
* Use SDK testing harness to run acceptance tests.

🧩 **Resources**

* `github.com/hashicorp/terraform-plugin-sdk/v2` (current major).
* Use `terraform-plugin-go` utilities for logging, diagnostics, and schema definitions.

✅ **Best Practices**
Read HashiCorp docs, follow contribution patterns, and write detailed acceptance tests.

💡 **In short**
Plugin SDK = official toolkit for authoring Terraform providers in Go.

---

## Q188: When would you write a custom provider vs using existing ones?

🧠 **Overview**
Write a custom provider when no existing provider supports the API you need or when existing providers cannot meet enterprise-specific auth/behavior requirements.

⚙️ **When to choose custom**

* Integrating with internal/private APIs.
* Need specialized lifecycle behavior or batching.
* Existing provider is unmaintained/insufficient.

🧩 **Considerations**

* Maintenance burden (binary builds, versioning).
* Testing & security responsibilities.

✅ **Best Practices**
Prefer community/official providers first; choose custom only when necessary and plan for long-term maintenance.

💡 **In short**
Custom providers are for gaps in ecosystem or internal platform integrations — expect maintenance cost.

---

## Q189: How do you handle API rate limiting in custom providers?

🧠 **Overview**
Implement client-side rate limiting, retries with exponential backoff, jitter, and respect API `Retry-After` headers.

⚙️ **Strategies**

* Token bucket or leaky-bucket limiter.
* Exponential backoff + full jitter on 429/5xx.
* Circuit breaker to avoid cascading failures.
* Respect API quotas and provide configurable limits.

🧩 **Example (conceptual)**
Use Go rate limiter (`golang.org/x/time/rate`) with retry logic on transient errors.

✅ **Best Practices**
Make rate limits configurable, implement idempotency for retries, and log throttling events for observability.

💡 **In short**
Add backoff, jitter, client-side rate limiting, and honor API guidance when building providers.

---

## Q190: What strategies would you use for managing Terraform at enterprise scale?

🧠 **Overview**
Enterprise-scale Terraform requires governance, modularization, centralized workflows, automated testing, access controls, and observability.

⚙️ **Key strategies**

* Central platform team owning shared modules and policy library.
* Private module registry and versioning.
* Remote state in Terraform Cloud or secure S3 with locking.
* CI gating: fmt/validate/lint/security/plan review.
* RBAC, SSO, audit logs, and metadata tagging enforcement.

🧩 **Organization**

```
platform-team/ -> modules, policies
app-teams/ -> consume modules via registry
central-ci/ -> plan/policy gates
```

✅ **Best Practices**
Define clear ownership, enforce policies as code, automate tests, and provide opinionated starter templates for teams.

💡 **In short**
Combine platform-owned modules, automated gates, and RBAC/policy to scale Terraform safely.

---

## Q191: How do you implement governance and compliance at scale?

🧠 **Overview**
Use a layered approach: pre-merge static checks, policy-as-code in CI, runtime enforcement (Sentinel/OPA), and audit logging.

⚙️ **Components**

* Policy-as-code (Sentinel/OPA) for blocking risky plans.
* Pre-commit hooks and CI scanners (tfsec, checkov).
* RBAC & SSO for workspace access.
* Audit trails (Terraform Cloud/CloudTrail) and drift detection.

🧩 **CI Example**

```bash
tflint
tfsec
conftest test plan.json
```

✅ **Best Practices**
Make policies part of PRs, enforce in Terraform Cloud for runtime checks, and provide clear remediation guidance to teams.

💡 **In short**
Enforce policies early (CI) and at runtime (TFC/OPA) with RBAC and auditing to achieve governance at scale.

---

## Q192: What is the difference between `terraform apply -auto-approve` and manual approval?

🧠 **Overview**
`-auto-approve` skips the interactive prompt and immediately applies changes; manual approval requires human confirmation after reviewing the plan.

⚙️ **Implications**

* `-auto-approve`: faster automation, higher risk if pipelines aren’t gated.
* Manual approval: safer in sensitive environments (production), allows human verification.

🧩 **When to use**

* Use `-auto-approve` in ephemeral/dev automation or trusted CD with strict pre-checks.
* Use manual approval for production changes requiring human oversight.

✅ **Best Practices**
Combine automated plan generation with a separate, auditable approval step for production applies.

💡 **In short**
`-auto-approve` automates applies; manual approval adds human safety checks.

---

## Q193: When is it safe to use `-auto-approve` in production?

🧠 **Overview**
Only safe when strict controls exist: automated thorough CI checks, policy enforcement, restricted IAM, auditable artifact storage, and limited blast radius.

⚙️ **Preconditions**

* Plans are generated, vetted, and recorded in a secure artifact store.
* Policies (OPA/Sentinel, tfsec) block unsafe changes.
* Applies run under least-privilege CI roles with audit logging.
* Small, well-tested changes (e.g., non-destructive config updates).

✅ **Best Practices**
Avoid `-auto-approve` for high-impact operations (DB changes, network reconfig); require approval gates instead.

💡 **In short**
Safe only with strong automation, policy gates, and restricted credentials — otherwise require approval.

---

## Q194: How do you implement peer review processes for Terraform changes?

🧠 **Overview**
Use VCS PRs, CI plan artifacts, automated checks, and required approvers to enforce peer review for infra changes.

⚙️ **Workflow**

1. Developer opens PR with HCL changes.
2. CI runs fmt/validate/lint/security and produces a plan artifact.
3. Peers review code + plan; PR cannot be merged until checks pass and approvals are given.
4. Merge triggers controlled apply (CD) with audit trail.

🧩 **Tools**

* GitHub/GitLab branch protection rules
* CI pipelines producing plan outputs
* Terraform Cloud runs for final apply with approval settings

✅ **Best Practices**
Require at least one reviewer, attach plan as artifact in PR, and disable direct pushes to protected branches.

💡 **In short**
Combine PR reviews, CI checks, plan artifacts, and branch protections for peer-reviewed Terraform changes.

---

## Q195: What strategies would you use for handling long-running Terraform operations?

🧠 **Overview**
Long-running operations (DB replacements, large infra changes) need timeouts, asynchronous orchestration, and progress monitoring to avoid CI timeouts and lock contention.

⚙️ **Strategies**

* Increase timeouts where provider supports.
* Break operations into smaller steps (blue/green, rolling updates).
* Run applies from long-lived runners (self-hosted agents) with stable connectivity.
* Use state locking carefully to avoid CI queue blocking.

🧩 **Examples**

* Use `create_before_destroy` + rolling replacements to avoid big-bang operations.
* Schedule maintenance windows and approvals.

✅ **Best Practices**
Avoid blocking short-lived CI runners; run long operations in dedicated, monitored runners with retry policies.

💡 **In short**
Split changes, increase timeouts, and run long jobs on dedicated runners to avoid CI/back-end contention.

---

## Q196: How do you implement timeouts for resource operations?

🧠 **Overview**
Many providers expose `timeouts` meta-argument on resources to customize create/read/update/delete timeouts.

⚙️ **Example**

```hcl
resource "aws_db_instance" "db" {
  # ...
  timeouts {
    create = "60m"
    update = "30m"
    delete = "30m"
  }
}
```

🧩 **Use cases**

* Long DB provisioning, AMI builds, complex network provisioning.

✅ **Best Practices**
Set conservative timeouts for known slow operations and ensure CI runners can handle the expected duration.

💡 **In short**
Use resource `timeouts` to control provider operation patience and avoid premature failures.

---

## Q197: What are the challenges of managing cloud resources across multiple providers?

🧠 **Overview**
Multi-provider management introduces differences in APIs, resource models, naming, IAM semantics, and lifecycle behavior — increasing complexity.

⚙️ **Challenges**

* Heterogeneous provider features and limitations.
* Divergent IAM/auth models and secrets management.
* Testing complexity and cross-provider networking.
* Provider-specific quirks and versioning.

✅ **Mitigations**

* Abstract provider specifics into modules.
* Strong testing and CI across providers.
* Standardize tagging and monitoring across clouds.

💡 **In short**
Multi-cloud adds heterogeneity and operational overhead—abstract and test heavily.

---

## Q198: How would you implement a multi-cloud strategy with Terraform?

🧠 **Overview**
Design provider-agnostic abstractions for shared concepts (networks, compute, storage) and use provider-specific modules where necessary; centralize governance and CI.

⚙️ **Approach**

* Create high-level modules (compute, storage) with provider-specific implementations behind a consistent interface.
* Use per-cloud state/backends and per-cloud CI pipelines.
* Centralize cross-cutting concerns (auth, secrets, tagging) with shared modules.

🧩 **Example pattern**

```
modules/
  compute/
    aws/
    gcp/
    azure/
  storage/
    aws/
    gcp/
    azure/
live/
  prod/
    service-a/ -> uses modules/compute/aws
```

✅ **Best Practices**
Keep provider-specific code isolated, provide a common interface, and supply examples for each cloud.

💡 **In short**
Abstract common concepts, isolate provider implementations, and orchestrate via CI and modules.

---

## Q199: What are the considerations for provider-agnostic module design?

🧠 **Overview**
Design modules with stable, minimal interfaces that represent business-level concepts rather than provider details.

⚙️ **Considerations**

* Define input/output contract focused on capabilities (e.g., `image`, `size`, `network_id`) not provider types.
* Implement provider-specific submodules behind a facade.
* Use conditional logic and `count/for_each` to select provider implementation.
* Avoid leaking provider-specific attributes in module interface.

🧩 **Example**

```hcl
module "compute" {
  source = "./modules/compute"
  provider = var.provider
  size     = var.size
}
# compute module selects provider-specific implementation internally
```

✅ **Best Practices**
Keep interfaces consistent, document provider-specific limitations, and provide examples for each cloud.

💡 **In short**
Design modules by capability contract and encapsulate provider details inside implementations.

---

## Q200: How do you handle provider-specific features in multi-cloud modules?

🧠 **Overview**
Expose optional provider-specific arguments, use internal provider-specific submodules, and document behaviour; fail fast if unsupported combinations are requested.

⚙️ **Techniques**

* Use `variable` flags for provider selection and `count`/`for_each` to instantiate provider-specific blocks.
* Provide a `provider_config` map for passing provider-specific settings.
* Return warnings or errors when unsupported options are used.

🧩 **Example pattern**

```hcl
module "storage" {
  source = "./modules/storage"
  cloud  = var.cloud

  aws = var.aws_config
  gcp = var.gcp_config
}
```

✅ **Best Practices**
Keep provider-specific knobs minimal, document them clearly, and provide reasonable defaults per provider.

💡 **In short**
Encapsulate provider-specific behavior inside the module, expose minimal opt-ins, and document limitations.

---

# Troubleshooting / Scenarios

---

## Q201: Terraform apply fails with `Error: Error acquiring the state lock`. How do you resolve this?

🧠 **Overview**
This means Terraform couldn’t acquire the backend lock (someone else is running Terraform or a stale lock exists). Fix by confirming there are no running operations and then removing the stale lock.

⚙️ **How to resolve**

1. **Check for running runs** — CI jobs, teammates, Terraform Cloud workspace runs.
2. **If no active run** — unlock the state safely.

🧩 **Commands**

* **S3+DynamoDB backend**

  * Find the lock entry in the DynamoDB table and delete it OR
  * Use Terraform CLI to force-unlock (preferred when you confirm no active run):

    ```bash
    terraform force-unlock LOCK_ID
    ```
  * Get `LOCK_ID` from DynamoDB `LockID` item or Terraform error output.

* **Terraform Cloud** — cancel the active run in the workspace UI or via API.

✅ **Best practices**

* Never force-unlock unless you’ve verified there’s no in-flight apply.
* Investigate why the lock was left (CI timeout, network failure). Fix CI runners to fail-clean and release locks.
* Use short-lived runners and proper error handling to avoid stale locks.

💡 **In short**
Verify no active run, then use `terraform force-unlock` (or remove the backend lock record) — only after confirming it’s safe.

---

## Q202: Your state file is corrupted. What steps would you take to recover?

🧠 **Overview**
Corruption requires careful restore from backups or rebuilding state via imports. Always operate on copies and test in non-prod first.

⚙️ **Recovery steps**

1. **Do not touch production state** — copy current state to a safe location.
2. **Restore from backup/version**:

   * S3: restore an earlier object version.
   * Terraform Cloud: restore snapshot via UI.
   * Local: use your `backups/` directory if you have `terraform state pull` archives.
3. **Validate restored state**:

   ```bash
   terraform state list
   terraform plan
   ```
4. **If no valid backup** — rebuild state by importing resources:

   * Create minimal `.tf` for resource(s).
   * `terraform import aws_s3_bucket.example my-bucket-name`
   * Repeat until state matches real infra.
5. **As last resort** — manually edit JSON only if you understand tfstate format; always test on a copy.

🧩 **Commands**

```bash
# pull current state (backup)
terraform state pull > /tmp/state-backup.json

# restore (example from file)
terraform state push /tmp/state-restore.json
```

✅ **Best practices**

* Enable backend versioning (S3 versioning) and automated periodic `state pull` backups.
* Test restore procedures regularly.
* Lock and coordinate team actions during recovery.

💡 **In short**
Restore a previous state snapshot if available; otherwise rebuild via `terraform import`. Operate on copies and validate before pushing.

---

## Q203: Terraform shows resources will be destroyed and recreated unnecessarily. How do you prevent this?

🧠 **Overview**
Unnecessary replacements often stem from HCL drift vs real attributes, lifecycle settings, provider-managed computed attributes, or absence of stable identifiers.

⚙️ **How to fix**

1. **Inspect the plan carefully**:

   ```bash
   terraform plan -out=plan.tfplan
   terraform show -json plan.tfplan | jq '.'
   ```
2. **Identify which attribute triggers replacement** — look for `forces replacement` in plan.
3. **Common fixes**:

   * Match your config to the provider’s computed attribute (remove hard-coded values).
   * Use `lifecycle { ignore_changes = [attribute] }` for provider-managed attributes.
   * Use `create_before_destroy` if you need zero-downtime replacement.
   * Import resource to state if Terraform isn’t tracking it correctly: `terraform import`.
   * Pin provider versions (sometimes provider changes alter behavior).

🧩 **Examples**

```hcl
resource "aws_instance" "web" {
  lifecycle {
    ignore_changes = [tags]      # if tags are managed elsewhere
  }
}
```

✅ **Best practices**

* Prefer updating config to represent desired state, not workarounds.
* Avoid mutable identifiers in resource names/fields that cause index shift (use `for_each` with stable keys instead of `count`).
* Run `terraform plan` after any provider upgrade to catch behavior changes.

💡 **In short**
Find the attribute forcing replacement, then either align config, import the real resource, use `ignore_changes`, or refactor to stable identities.

---

## Q204: You're getting `Provider configuration not present` errors. What's wrong?

🧠 **Overview**
This means Terraform can’t find a required `provider` block for the provider referenced by a resource — often caused by missing `required_providers`, provider aliases, or forgetting `terraform init`.

⚙️ **Troubleshooting**

1. **Run** `terraform init` — it downloads providers.
2. **Check `required_providers` / provider blocks** in your config:

   ```hcl
   terraform {
     required_providers {
       aws = { source = "hashicorp/aws", version = "~> 5.0" }
     }
   }
   provider "aws" { region = "ap-south-1" }
   ```
3. **If using multiple provider configs**, ensure consumer resources reference the alias:

   ```hcl
   provider "aws" { alias = "eu" region = "eu-west-1" }
   resource "aws_s3_bucket" "b" {
     provider = aws.eu
     ...
   }
   ```
4. **Check module usage** — modules requiring providers must declare provider requirements or accept provider passthrough.

🧩 **Commands**

```bash
terraform init
terraform providers
```

✅ **Best practices**

* Always pin `required_providers` and run `terraform init` in CI.
* When using modules, pass providers explicitly if module uses multiple provider configs.

💡 **In short**
Either you didn’t run `terraform init`, or provider blocks/aliases are missing/misconfigured — add provider config or pass the correct alias.

---

## Q205: Terraform is trying to create a resource that already exists. How do you fix this?

🧠 **Overview**
Terraform is unaware of the resource because it’s not in state. The correct fix is to map the real resource into Terraform state using `terraform import`.

⚙️ **How to fix**

1. **Write the resource block** in your `.tf` matching the real resource (attributes that identify it).
2. **Run import**:

   ```bash
   terraform import aws_s3_bucket.logs my-existing-bucket
   ```
3. **After import** run `terraform plan` and adjust config so Terraform’s desired state matches reality.

🧩 **Notes**

* `terraform import` only updates state; you must ensure HCL matches the resource or Terraform will try to change it on next apply.
* For many resources, you’ll need to add missing required attributes to config before import.

✅ **Best practices**

* Don’t delete the physical resource; import it instead.
* Document imported resources and coordinate with the team to avoid duplication.

💡 **In short**
Import the existing resource into Terraform state (`terraform import`) and align HCL to prevent recreation.

---

## Q206: Your `terraform plan` is taking extremely long to complete. What would you investigate?

🧠 **Overview**
Long plans are usually caused by very large state, slow backend/network, expensive data sources, provider API slowness, or many `refresh` operations.

⚙️ **Investigation checklist**

* **State size**: very large state → slow pull/parse. Consider splitting state.
* **Backend latency**: network/region mismatch between CI runner and backend (S3). Run CI in same region.
* **Provider/API rate limiting or slowness** — check provider logs/errors and throttling.
* **Data sources or loops**: data lookups that call APIs for many items. Optimize by narrowing queries.
* **Refresh behavior**: `terraform plan` does a refresh by default; try `terraform plan -refresh=false` to test difference (use cautiously).
* **Large graphs**: many resources/dependencies → increase compute on runner.

🧩 **Commands**

```bash
# test without refresh (careful)
terraform plan -refresh=false

# inspect state size
terraform state list | wc -l
```

✅ **Best practices**

* Split state and modules to reduce plan scope.
* Use targeted plans only for emergency ops but avoid regular use.
* Run CI/agents closer to backend region and add caching where possible.

💡 **In short**
Check backend latency, state size, expensive data sources, and provider rate-limits — then split state/optimize queries or run in-region CI.

---

## Q207: Terraform shows no changes but resources are actually different in the cloud. Why?

🧠 **Overview**
This happens when the state is stale (no refresh), or someone modified resources out-of-band and Terraform’s last state wasn’t refreshed. Another cause is `ignore_changes` masking differences.

⚙️ **How to reconcile**

1. **Refresh state**:

   ```bash
   terraform refresh
   terraform plan
   ```
2. **If using remote state** — ensure your workspace used the correct backend and has latest state.
3. **Check for `ignore_changes`** in lifecycle that hides modifications.
4. **If changes are intentional** — update HCL to match reality or import/adjust as needed.

🧩 **Commands**

```bash
terraform plan -refresh=true
```

✅ **Best practices**

* Avoid out-of-band changes; enforce changes via Terraform.
* Schedule periodic drift detection via `terraform plan` and alerts.

💡 **In short**
State is out-of-sync — run `terraform refresh` or `plan` to update state, then either import/update HCL or accept `ignore_changes` where appropriate.

---

## Q208: You accidentally ran `terraform destroy` in production. What's your recovery process?

🧠 **Overview**
This is high-severity. Recovery focuses on stopping further damage, restoring from backups, and rebuilding state/resources in a controlled manner.

⚙️ **Immediate steps**

1. **Stop processes** that may continue destructive actions (CI jobs, pipeline runs).
2. **Assess scope** — which resources were destroyed? Check cloud console and activity logs (CloudTrail).
3. **Restore critical infrastructure**:

   * **State restore**: if you have a pre-destroy state snapshot, restore it (`terraform state push`).
   * **If resources destroyed physically**:

     * Restore from backups: DB snapshots, S3 versioning, AMI snapshots.
     * Recreate infra via Terraform using restored state or re-import resources.
4. **Communicate** to stakeholders and activate incident runbook.
5. **Postmortem** — find root cause and add safeguards (prevent_destroy, RBAC, approvals).

🧩 **Commands**

```bash
# restore state from backup (example)
terraform state push /tmp/state-before-destroy.json

# or re-import critical resources
terraform import aws_db_instance.prod <db-identifier>
```

✅ **Best practices**

* Use `prevent_destroy` for critical resources.
* Require manual approvals for production applies/destroys in CI.
* Keep frequent state and data backups; practice restore drills.

💡 **In short**
Stop further actions, restore state/backups or re-import resources, and follow incident runbook — then add safeguards to prevent recurrence.

---

## Q209: Terraform is showing drift but you want to keep the manual changes. How do you handle this?

🧠 **Overview**
If manual changes are intentional and you want Terraform to accept them, you must bring Terraform state/config into alignment without reverting infrastructure.

⚙️ **Options**

1. **Update HCL to match reality** and then `terraform apply` — Terraform will detect no diff.
2. **Import changed resources** if they were created out-of-band: `terraform import`.
3. **Use `lifecycle { ignore_changes = [...] }`** for attributes you want Terraform to ignore going forward.
4. **Remove resource from state** (if you no longer want Terraform to manage it):

   ```bash
   terraform state rm aws_resource.example
   ```

🧩 **Examples**

```hcl
resource "aws_instance" "web" {
  lifecycle {
    ignore_changes = [volume_size]
  }
}
```

✅ **Best practices**

* Prefer updating code to reflect the new, desired state (single source of truth).
* Document manual changes and reasons; avoid frequent out-of-band edits.

💡 **In short**
Either update HCL/import the resource so Terraform knows the new truth, or explicitly ignore the changed attributes with `ignore_changes`.

---

## Q210: Multiple team members are getting state lock conflicts. How do you resolve this?

🧠 **Overview**
Concurrent runs or long-running operations cause lock contention. Fix by coordinating runs, reducing lock duration, and ensuring backends work correctly.

⚙️ **Resolution steps**

1. **Check for an active run** (CI, Terraform Cloud). Cancel if stuck.
2. **Force-unlock only when safe**:

   ```bash
   terraform force-unlock LOCK_ID
   ```
3. **Identify root cause** — long-running applies, flaky CI runners, network failures leaving stale locks.
4. **Operational fixes**:

   * Move long-running applies to dedicated runners.
   * Improve CI timeout/retry handling.
   * Use per-service backends to reduce contention (shard state).
   * Add queuing/orchestration (only one apply per backend/stack at a time).

✅ **Best practices**

* Avoid many engineers applying to the same state concurrently.
* Use per-environment/service states and per-branch workspaces to minimize conflicts.
* Monitor locks and alert on long-held locks.

💡 **In short**
Cancel active stuck runs or force-unlock (after verifying), then reduce contention by sharding state and improving CI/runner behavior.

---

## Q211: Your S3 backend bucket was accidentally deleted. How do you recover?

🧠 **Overview**
If backend S3 bucket is gone, Terraform cannot access state — recovery requires restoring state from S3 versioning, backups, or rebuilding state via imports.

⚙️ **Recovery steps**

1. **Restore the S3 bucket** (if possible) and enable versioning/replication.
2. **Restore latest state object** from backups or S3 object versions (if versioning was enabled).

   ```bash
   aws s3api get-object --bucket tf-state --key path/terraform.tfstate --version-id <id> state.json
   ```
3. **If no backups/versioning** — recreate a new bucket and rebuild state:

   * Recreate backend bucket and recreate required DynamoDB lock table.
   * Recreate an empty state or import resources into new state using `terraform import`.
4. **Validate** by running `terraform plan` in a safe environment and reconciling differences.

🧩 **Commands**

```bash
# push restored state (use with extreme caution)
terraform state push state.json
```

✅ **Best practices**

* Always enable S3 versioning + lifecycle for state buckets.
* Store automated `terraform state pull` backups in a different account/bucket.
* Limit who can delete backend buckets via IAM and use SCPs.

💡 **In short**
Restore bucket + state from versioned backups; if none exist, reconstruct state with imports — and never skip S3 versioning/backups again.

---

## Q212: Terraform shows `Error: Cycle` in the dependency graph. How do you debug this?

🧠 **Overview**
A cycle means resources reference each other circularly so Terraform cannot determine create order. Break the cycle by removing mutual references or introducing explicit `depends_on` or data separation.

⚙️ **Debugging steps**

1. **Generate the graph** to visualize dependencies:

   ```bash
   terraform graph | dot -Tsvg > graph.svg
   ```
2. **Inspect plan output** to find the cycle message — Terraform often lists the cycle path.
3. **Common causes**:

   * Mutual references between resources (A references B and B references A).
   * Using attribute references where a data source would be more appropriate.
   * Outputs from one module consumed by resources that also feed back into the upstream module.
4. **Fixes**

   * Refactor to remove circular reference — split into multiple steps/modules.
   * Use `depends_on` to explicitly control order **only if** it breaks a false-positive implicit cycle (rare).
   * Replace direct resource references with data sources or `terraform_remote_state` to break direct cycle.

🧩 **Example**

* If `aws_lb` needs target group created but target group references LB attribute, move target group into a separate apply step and reference LB via remote state or module output.

✅ **Best practices**

* Design modules so dependencies flow in one direction (producer → consumer).
* Avoid circular architecture (shared stateful resources can be centralised).
* Break complex create paths into multiple apply steps if necessary.

💡 **In short**
Visualize the graph, find the mutual references, and refactor to remove the circular dependency — often by splitting resources or using remote-state/data sources.

---

Below is your **Terraform Troubleshooting Scenarios Q213–Q225** — production-ready, README-style, and interview-focused.

---

## Q213: A resource is stuck in a perpetual update loop. What could cause this?

🧠 **Overview**
Terraform keeps updating the same resource every apply when its *actual* state never matches the *desired* configuration.

⚙️ **Common causes**

* Provider-managed attributes differ every refresh (e.g., timestamps, ordering, metadata).
* Values in config drift from what's actually provisioned.
* Missing `ignore_changes` for attributes mutated outside Terraform.
* Random or dynamic values re-evaluating every plan.
* Module using `count.index` or computed values incorrectly.

🧩 **Fix**

* Identify diff in plan:

  ```bash
  terraform plan
  ```
* Add lifecycle rule for provider-managed attributes:

  ```hcl
  lifecycle { ignore_changes = [last_modified] }
  ```
* Align HCL with real values or refactor random/dynamic computed fields.
* Update provider version if it's a known bug.

💡 **In short**
Find the attribute that keeps changing, then fix config or lifecycle rules.

---

## Q214: Terraform apply succeeds but the actual resource is not created. How do you troubleshoot?

🧠 **Overview**
Apply succeeded but no resource exists → likely a provider bug, missing permissions, wrong region/account, or partial apply.

⚙️ **Steps to investigate**

1. **Check provider credentials & region** — mismatched region = creating in another account/region.
2. **Re-check plan JSON**:

   ```bash
   terraform show -json plan.tfplan | jq .
   ```
3. **Enable logging**:

   ```bash
   export TF_LOG=DEBUG
   ```
4. **Check IAM permissions** — AWS API may allow request but fail silently depending on service.
5. **Look for explicit `prevent_destroy` or faulty conditionals**.
6. **Run plan again** — if Terraform thinks the resource exists, but cloud does not → resource missing from state → import or recreate.

🧩 **Fix options**

* Import real resource if created outside Terraform.
* Re-run apply with debug logs.
* Fix incorrect provider configuration (region, role).

💡 **In short**
Check region/account, permissions, logs, and plan; if resource exists only in state—not cloud—fix via import or recreate.

---

## Q215: You're getting "count cannot be computed" errors. What does this mean and how do you fix it?

🧠 **Overview**
`count` must be a *known*, *static* value during plan. If it depends on unknown values (outputs from yet-to-be-created resources), Terraform cannot determine count.

⚙️ **Examples of invalid usage**

```hcl
count = length(aws_vpc.main.subnets)   # subnets unknown until apply
```

🧩 **Fix**

* Move dependency logic to `for_each` (can handle dynamic keys).
* Use data sources to fetch values that *are* known at plan time.
* Pre-define counts via variables.

💡 **In short**
`count` must be fully known during plan. Use variables, data sources, or `for_each` instead.

---

## Q216: Terraform is creating resources in the wrong order. How do you control this?

🧠 **Overview**
Terraform automatically determines order via references, but wrong ordering happens when dependencies are implicit or missing.

⚙️ **Solutions**

1. **Add explicit dependency**:

   ```hcl
   depends_on = [aws_vpc.main]
   ```
2. **Use references** between resources to create natural dependencies.
3. **Avoid computed values or references hidden inside locals/modules that Terraform can't detect.**
4. **Split resources into separate modules** where ordering is easier to manage.

🧩 **Example**

```hcl
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id
}
```

💡 **In short**
Use references or `depends_on` to enforce ordering when Terraform cannot infer it automatically.

---

## Q217: A module update broke your infrastructure. How do you roll back?

🧠 **Overview**
Module updates, if not pinned, can break infra. Rollback via version pinning or state restore.

⚙️ **Rollback methods**

1. **Pin previous module version**:

   ```hcl
   source  = "git::https://...//modules/vpc?ref=v1.2.3"
   ```
2. **Re-run plan + apply** to revert to stable output.
3. **If state changes occurred**:

   * Restore previous state version (S3 version or TFC snapshot).
   * Then apply using previous module version.

🧩 **Commands**

```bash
terraform init -upgrade=false
terraform apply
```

💡 **In short**
Pin older module version, restore previous state if needed, reapply.

---

## Q218: Terraform shows "Provider produced inconsistent result after apply". What does this mean?

🧠 **Overview**
Provider returned values that differ from what Terraform expected, indicating provider bug, inconsistent API responses, or forbidden attribute mutations.

⚙️ **Causes**

* API changes or inconsistent backend responses.
* Provider bug with Read/Update functions.
* External system mutates fields immediately after creation.
* Race conditions or throttling.

🧩 **Fix**

* Upgrade provider to latest patch.
* Add `ignore_changes` for attributes API overrides.
* Retry apply with TF_LOG enabled.
* Open GitHub issues if reproducible.

💡 **In short**
The provider returned unexpected values → often a provider bug or API inconsistency.

---

## Q219: Your state file grew too large and operations are timing out. What's the solution?

🧠 **Overview**
Large state slows plans and applies because Terraform refreshes every resource.

⚙️ **Solutions**

* **Split monolithic state** into smaller root modules.
* Separate network, platform, app, logging stacks.
* Remove unused resources via `state rm`.
* Avoid outputs containing huge lists or maps.
* Avoid storing data blobs (templates, certs, etc).

🧩 **Structure**

```
infra/
  network/
  shared/
  apps/
```

💡 **In short**
Shard your Terraform configuration into multiple smaller states.

---

## Q220: Terraform cannot destroy resources due to dependencies. How do you force deletion?

🧠 **Overview**
Dependent resources must be deleted first or dependencies must be broken.

⚙️ **Approaches**

1. **Delete dependent resources manually or in Terraform**.
2. **Remove resource from state** (dangerous, not preferred):

   ```bash
   terraform state rm aws_resource.x
   ```
3. **Override dependency with `-target`**:

   ```bash
   terraform destroy -target=aws_resource.x
   ```
4. **Modify lifecycle**:

   ```hcl
   lifecycle {
     ignore_changes = [field]
   }
   ```

⚠️ Only use forced removal when you fully understand the consequences (risk of orphaned infrastructure).

💡 **In short**
Destroy dependencies first or temporarily remove resource from state if necessary.

---

## Q221: You're getting "InvalidParameterValue" errors from AWS. How do you debug this?

🧠 **Overview**
AWS rejects some parameters due to invalid formats, missing dependencies, or mismatched types.

⚙️ **Debugging**

1. **Enable AWS debug logs**:

   ```bash
   export TF_LOG=DEBUG
   ```
2. **Look at AWS error message** for exact invalid field.
3. **Check provider docs** — resource may expect different format or allowed value.
4. **Review AWS API docs** — provider does not always validate input.
5. **Check region-specific availability** (AZ, instance type).
6. **Remove manual formatting mistakes** (e.g., extra spaces, invalid regex).

🧩 **Example**

* Invalid instance type in a region
* Unsupported parameter combination (SG + subnet mismatch)

💡 **In short**
Read AWS error carefully, enable debug logs, verify parameters against AWS APIs.

---

## Q222: Terraform plan shows unexpected changes after upgrading provider versions. Why?

🧠 **Overview**
Upgraded providers may change default values, computed attributes, or schema behavior → plan diffs appear even without code changes.

⚙️ **Causes**

* Provider changed default attribute values.
* Provider now reports previously-ignored fields.
* Normalization behavior changed (ordering, casing).
* Some deprecated fields replaced by new ones.

🧩 **Fix**

* Read provider changelog.
* Update HCL to match new provider expectations.
* Add `ignore_changes` for newly computed attributes.

💡 **In short**
New provider behavior causes diffs → align HCL with new defaults or ignore provider-managed attributes.

---

## Q223: A remote-exec provisioner is failing. How would you troubleshoot?

🧠 **Overview**
Remote-exec relies on successful SSH/WinRM connection and correct script commands.

⚙️ **Troubleshooting**

1. **Verify connection block**:

   ```hcl
   connection {
     host = aws_instance.web.public_ip
     user = "ec2-user"
     private_key = file("id_rsa")
   }
   ```
2. **Check network connectivity** — SG ingress, NACL, route tables.
3. **Check that instance is ready** — use `remote-exec` `inline` or use cloud-init instead.
4. **Enable debug**:

   ```bash
   TF_LOG=DEBUG
   ```
5. **SSH manually** to validate creds, user, and host.
6. **Ensure scripts are idempotent** and exit correctly.

💡 **In short**
Validate SSH connectivity, credentials, network paths, and script behavior.

---

## Q224: Terraform is unable to read outputs from a remote state. What would you check?

🧠 **Overview**
Remote state not accessible means misconfigured backend or missing outputs.

⚙️ **Checks**

1. **Backend configuration** — bucket/key/workspace names correct?
2. **Permissions** — does Terraform IAM role have GetObject rights (S3) or workspace access (TFC)?
3. **Outputs exist** and are not marked `sensitive` in a way that hides them.
4. **State encryption / KMS permissions** correct?
5. **Check remote backend type** (S3, remote, Consul) learning required syntax.

🧩 **Example**

```hcl
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "tf-state"
    key    = "network/prod/terraform.tfstate"
    region = "ap-south-1"
  }
}
```

💡 **In short**
Check remote backend config, IAM or workspace permissions, and ensure outputs actually exist.

---

## Q225: Your `terraform init` is failing to download modules. What could be wrong?

🧠 **Overview**
Failure to download modules indicates network, authentication, version, or source URL issues.

⚙️ **Causes**

* Incorrect module `source` syntax.
* Bad git reference (branch/tag not found).
* Private repo without credentials (SSH keys missing).
* Terraform Registry unavailable or module removed.
* Corporate proxy blocking access.

🧩 **Fix**

* Validate source URL:

  ```hcl
  source = "git::https://github.com/org/repo.git//modules/vpc?ref=v1.2.0"
  ```
* Ensure SSH agent or PAT token is available for private repos.
* Validate registry module name & version constraints.
* Check corporate proxy or VPN.

💡 **In short**
Fix module source URL, authentication, or networking issues; ensure tags/versions exist.

---
Below is your **Terraform Troubleshooting Scenarios (Q226–Q237)** — production-grade, README-style, concise and directly useful.

---

## Q226: Sensitive values are appearing in Terraform logs. How do you prevent this?

🧠 **Overview**
Sensitive values leak into logs when variables/outputs/resources are not marked sensitive or when debug logging (`TF_LOG`) exposes raw values.

⚙️ **Fix**

1. Mark variables/outputs as sensitive:

   ```hcl
   variable "db_password" {
     type      = string
     sensitive = true
   }
   output "secret" {
     value     = var.db_password
     sensitive = true
   }
   ```
2. Avoid printing sensitive values in `local-exec` or debug outputs.
3. Disable debug logging during normal runs:

   ```bash
   unset TF_LOG
   ```
4. Do not echo secrets using `terraform console` on shared terminals.

💡 **In short**
Mark values as `sensitive`, avoid debug logs, and ensure scripts never print secret values.

---

## Q227: Terraform is creating duplicate resources with for_each. What's the issue?

🧠 **Overview**
Duplicates happen when `for_each` keys are unstable or change unexpectedly, causing Terraform to think new resources must be created.

⚙️ **Common causes**

* Using lists instead of sets → list index changes produce new keys.
* Using computed values as keys → keys change every plan.
* Incorrect map structure → duplicate keys with different values.

🧩 **Fix**

* Convert list → set or map with stable keys:

  ```hcl
  for_each = { for s in var.subnets : s.name => s }
  ```
* Ensure keys are deterministic and stable.

💡 **In short**
Use stable, unique keys for `for_each` — not list indices or computed values.

---

## Q228: You're getting "Error: Reference to undeclared resource" but the resource exists. Why?

🧠 **Overview**
Terraform can’t find the resource because of naming, scoping, or module path issues.

⚙️ **Causes**

* Typo in resource name or wrong address.
* Referencing a resource inside a module from outside incorrectly.
* Using `count` or `for_each` but forgetting indexing (`resource.name[0]`).
* Resource is in another module but not outputted.

🧩 **Fix**

* Verify resource name + type.
* Export resource from module using output:

  ```hcl
  output "id" { value = aws_instance.web.id }
  ```
* Use correct indexing when `count`/`for_each` is involved.
* Check module hierarchy.

💡 **In short**
Ensure correct resource address, module output exposure, and required indexing.

---

## Q229: Terraform workspace commands are not working. What would you check?

🧠 **Overview**
Workspaces don’t work when using a non-workspace backend, Terraform Cloud, or wrong directory context.

⚙️ **Checks**

* Are you using **Terraform Cloud remote backend**? → Local workspaces disabled.
* Are you inside a Terraform directory with a valid configuration?
* Backend doesn’t support CLI workspaces (e.g., `remote` backend).
* Version mismatch — check `terraform version`.

🧩 **Commands**

```bash
terraform workspace list
terraform providers
```

💡 **In short**
CLI workspaces don’t work with remote/TFC backends; ensure correct backend and run inside proper project folder.

---

## Q230: A data source is returning null values unexpectedly. How do you debug?

🧠 **Overview**
Data sources pull real cloud data at **plan time**. Null values mean Terraform couldn’t find the resource.

⚙️ **Debug Steps**

1. Confirm the resource actually exists (AWS Console).
2. Check filters:

   ```hcl
   data "aws_ami" "latest" {
     owners = ["amazon"]
     filter { name = "name" values = ["amzn2*"] }
   }
   ```
3. Enable debug logs:

   ```bash
   export TF_LOG=DEBUG
   ```
4. Confirm correct region/account.
5. Validate IAM permissions for read operations (EC2 Describe, S3 List).

💡 **In short**
Check filters, region, permissions, existence of the resource, and enable logs.

---

## Q231: Terraform is trying to replace a resource that shouldn't change. How do you investigate?

🧠 **Overview**
Terraform replaces a resource when a *force-replacement attribute* has changed.

⚙️ **Steps**

1. Run:

   ```bash
   terraform plan
   ```

   Check for `"forces replacement"` tags.
2. Identify which field is causing replacement:

   * Name or ID fields
   * Immutable fields (subnet_id, engine version)
   * Provider bug/computed mismatch
3. Align HCL with real state.
4. Add `ignore_changes` for provider-managed attributes.

🧩 **Example**

```hcl
lifecycle { ignore_changes = [tags] }
```

💡 **In short**
Find the attribute forcing replacement; align config, ignore changes, or remove computed fields.

---

## Q232: Your `.terraform.lock.hcl` file has conflicts after a merge. How do you resolve this?

🧠 **Overview**
Lock files track provider versions. Merge conflicts occur when multiple branches update them.

⚙️ **Fix**

1. Choose the provider versions you want to keep.
2. Manually resolve the conflict in `.terraform.lock.hcl`.
3. Run:

   ```bash
   terraform init -upgrade
   ```
4. Commit the regenerated lock file.

💡 **In short**
Resolve conflicts manually, re-run `terraform init -upgrade`, commit updated lock file.

---

## Q233: Terraform cannot authenticate to the provider. What credentials would you verify?

🧠 **Overview**
Auth failures occur due to missing, expired, or incorrect provider credentials.

⚙️ **Checks by provider (AWS example)**

* `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`
* IAM role assume-role correctness
* Session token (`AWS_SESSION_TOKEN`)
* Credentials file (`~/.aws/credentials`)
* Correct profile set:

  ```bash
  export AWS_PROFILE=prod
  ```

🧩 **Other providers**

* Azure: `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, SSO login
* GCP: `GOOGLE_APPLICATION_CREDENTIALS`

💡 **In short**
Verify env vars, profile, assume-role settings, and correct account/region login.

---

## Q234: You're getting "Error: Insufficient IAM permissions" but permissions look correct. What else could be wrong?

🧠 **Overview**
If permissions appear correct but AWS still denies, another factor is interfering.

⚙️ **Possible issues**

* **IAM permission boundaries** blocking action.
* **SCPs (AWS Organizations)** overriding IAM.
* **Session policies** limiting allowed operations.
* Wrong **region** or wrong **profile**.
* Missing **KMS decrypt/encrypt** permissions for encrypted resources.
* Resource-level policies (S3 bucket, KMS key policy) blocking access.

🧩 **Checks**

* Use AWS IAM policy simulator
* Review SCPs attached to the account/OU
* Check CloudTrail for denial reasons

💡 **In short**
Even if IAM seems correct, SCPs, permission boundaries, or resource policies can override it.

---

## Q235: Terraform state shows a resource but it doesn't exist in the cloud. How do you sync?

🧠 **Overview**
Terraform thinks a resource exists because it's in state; reality is different.

⚙️ **Fix**

1. Remove resource from state:

   ```bash
   terraform state rm aws_s3_bucket.old
   ```
2. Recreate resource using Terraform:

   ```bash
   terraform apply
   ```
3. Or import if resource was recreated manually.

⚠️ Danger: removing from state does not delete real resources — only Terraform’s tracking.

💡 **In short**
Remove stale entry with `state rm`, then recreate or import.

---

## Q236: A module is not updating despite changing its source. What's the issue?

🧠 **Overview**
Modules are cached inside `.terraform/modules`. Terraform won’t pull changes unless you run init or bump ref.

⚙️ **Fix**

1. Run:

   ```bash
   terraform get -update
   terraform init -upgrade
   ```
2. If using Git sources, update the `ref` (tag/commit).
3. Delete `.terraform/modules` if cache is corrupted.

💡 **In short**
Modules require `init -upgrade` or updated Git ref to refresh.

---

## Q237: Terraform is using the wrong provider version. How do you fix this?

🧠 **Overview**
Provider versions are controlled by `.terraform.lock.hcl` plus `required_providers` constraints.

⚙️ **Fix**

1. Pin desired provider version:

   ```hcl
   terraform {
     required_providers {
       aws = { source = "hashicorp/aws", version = "~> 5.7" }
     }
   }
   ```
2. Reinitialize:

   ```bash
   terraform init -upgrade
   ```
3. Regenerate `.terraform.lock.hcl` if stale:

   ```bash
   rm .terraform.lock.hcl
   terraform init
   ```

💡 **In short**
Pin the version in `required_providers` and re-run `terraform init -upgrade`.

---


---

## Q238: You're getting **"Error: Invalid for_each argument"**. What causes this?

🧠 **Overview**
`for_each` requires a map or set of strings. This error occurs when you pass a value of the wrong type (e.g., list of objects, null, or a computed value not known at plan-time).

⚙️ **How it happens / Fix**

* `for_each = var.items` where `var.items` is `list(object)` → invalid.
* `for_each = toset(var.list)` fixes list→set conversion.
* If value is unknown at plan-time, compute it earlier or use `for_each` on a known data source.

🧩 **Examples / Commands**

```hcl
# Bad: list of objects -> causes invalid for_each
variable "subnets" { type = list(object({ name=string })) }

# Good: convert to map with stable keys
locals {
  subnets_map = { for s in var.subnets : s.name => s }
}
resource "aws_subnet" "s" {
  for_each = local.subnets_map
  cidr_block = each.value.cidr
}
```

✅ **Best Practices**

* Use maps or sets for `for_each`.
* Ensure keys are stable and unique.
* Avoid computed values as `for_each` input; use data sources or locals to resolve them first.

💡 **In short**
`for_each` needs a stable map/set; convert lists or computed results into a deterministic map/set before using it.

---

## Q239: **Terraform plan works but apply fails** with the same configuration. Why?

🧠 **Overview**
Plan is a dry-run snapshot; apply interacts with provider APIs and can fail due to permissions, transient API errors, race conditions, or external state changes between plan and apply.

⚙️ **Troubleshooting steps**

1. **Re-run `terraform apply` with TF_LOG=DEBUG** to capture API errors.
2. **Inspect provider error**—often 4xx/5xx, rate-limit, or permission issue.
3. **Validate credentials/roles used during apply** (CI runner vs local user may differ).
4. **Check for out-of-band changes** between plan and apply (someone edited resource).
5. **If plan used `-out`**, ensure you `apply plan.tfplan` (not re-plan) to avoid drift.

🧩 **Commands**

```bash
# If using CI: ensure same credentials as plan step
terraform plan -out=plan.tfplan
terraform apply plan.tfplan
```

✅ **Best Practices**

* Use `plan -out` and apply the same artifact in CD to avoid drift.
* Use same service account for plan & apply and short-lived creds.
* Add retries/backoff for transient provider errors.

💡 **In short**
Plan success ≠ apply success—check provider errors, credentials, drift, and use plan artifacts for deterministic apply.

---

## Q240: Your CI/CD pipeline randomly fails with **state lock** errors. How do you make it more resilient?

🧠 **Overview**
Random lock failures mean concurrent applies or stale locks. Fix with orchestration, retry logic, and state sharding.

⚙️ **Mitigation steps**

* **Queue applies**: ensure only one apply per state (use CI job concurrency limits).
* **Retry with backoff**: implement retries for `terraform init/plan/apply` when lock found.
* **Shorter lock contention**: split state (per-service/environment) to reduce collisions.
* **Detect stuck locks**: CI step to check lock age and alert rather than force-unlock automatically.
* **Use Terraform Cloud**: built-in run queuing avoids many locking issues.

🧩 **Example retry (bash)**

```bash
for i in {1..5}; do
  terraform apply -auto-approve && break || sleep $((i*10))
done
```

✅ **Best Practices**

* Shard state by service/env.
* Run plan & apply as separate controlled stages (plan in PR, apply in gated CD).
* Avoid long-running interactive applies that hold locks.

💡 **In short**
Serialize/queue applies, add retry/backoff, and reduce contention by sharding state.

---

## Q241: Terraform is creating resources with **incorrect tags**. How do you debug default tags?

🧠 **Overview**
Tags can come from provider defaults, provider-level `default_tags`, modules, or automation injecting tags—mismatch may be due to precedence or variable overrides.

⚙️ **Debug checklist**

1. **Search codebase** for `default_tags` (AWS provider) or global tag modules.
2. **Inspect provider config**:

   ```hcl
   provider "aws" {
     default_tags { tags = local.common_tags }
   }
   ```
3. **Check module inputs**—are tags merged inside modules?
4. **Check CI/CD pipeline** for environment tag injection.
5. **Run `terraform plan` and inspect resource `tags` diff** to see source of undesired values.

🧩 **Example (merge tags)**

```hcl
resource "aws_instance" "app" {
  tags = merge(var.common_tags, var.extra_tags, { Name = "app" })
}
```

✅ **Best Practices**

* Standardize tag merging in a single module or provider `default_tags`.
* Document tag precedence and enforce via policy checks.

💡 **In short**
Trace tag source (provider defaults, module, CI), then centralize tag generation and enforce precedence.

---

## Q242: A **security group** resource is being recreated on every apply. What would you check?

🧠 **Overview**
SG recreation loops usually happen because provider reports dynamic fields in different orders, or because nested rules are managed outside Terraform, or computed attributes change each run.

⚙️ **Investigation steps**

1. **Inspect plan** for which attribute forces replacement (look for `forces replacement`).
2. **Check dynamic fields** (ingress/egress rule order, `self` references, description/tags).
3. **Use `for_each` with stable keys** for `aws_security_group_rule` to manage rules separately (avoid inline rules order issues).
4. **Use `ignore_changes`** for attributes mutated by AWS (like `owner_id` or `revoke_rules_on_delete` if provider bug).
5. **Check provider version** for known bugs causing reorder.

🧩 **Example (manage rules separately)**

```hcl
resource "aws_security_group" "sg" { name = "app-sg" }
resource "aws_security_group_rule" "ingress" {
  for_each = var.rules
  type        = "ingress"
  security_group_id = aws_security_group.sg.id
  from_port   = each.value.from
  to_port     = each.value.to
  cidr_blocks = each.value.cidr
}
```

✅ **Best Practices**

* Prefer separate `aws_security_group_rule` resources for stable identity.
* Pin provider version and test provider upgrades in dev.

💡 **In short**
Find the forcing attribute (order/timestamps/provider-managed), then manage rules as separate resources or ignore provider-managed drift.

---

## Q243: **Terraform cannot destroy a VPC** due to dependencies. How do you identify what's blocking it?

🧠 **Overview**
VPC deletion fails when dependent resources (ENIs, subnets, gateways, NATs, EC2 instances, LB attachments) still exist.

⚙️ **Steps to identify blockers**

1. **Check provider/cloud console** for dependent resources tied to VPC.
2. **Use `terraform state list`** to find resources still in state that reference VPC.
3. **AWS specific**: list ENIs, route attachments, NAT gateways, network interfaces in the VPC using AWS CLI.
4. **Run `terraform plan -destroy`** to show destroy order and blockers.
5. **Manually remove or `terraform destroy -target=`** dependent resources first.

🧩 **Commands (AWS examples)**

```bash
aws ec2 describe-network-interfaces --filters Name=vpc-id,Values=<vpc-id>
terraform state list | grep <vpc-resource-prefix>
```

✅ **Best Practices**

* Tear down resources in dependency order or use module-level destroys.
* Automate clean-up scripts for non-Terraform-managed resources that block VPC deletion.

💡 **In short**
Identify dependent resources via state and cloud APIs, destroy them first, then delete the VPC.

---

## Q244: You're getting **"context deadline exceeded"** errors. What could cause timeouts?

🧠 **Overview**
This indicates API calls or provider operations timed out—causes include network issues, high API latency, throttling, or insufficient timeouts for long operations.

⚙️ **Troubleshooting**

1. **Check network connectivity** between runner and cloud endpoints.
2. **Look for provider throttling**/rate limiting in logs.
3. **Increase resource `timeouts`** where supported (DB create, AMI build).
4. **Run again from a runner in same region** to reduce latency.
5. **Use retries/backoff** at retryable error points.

🧩 **Example**

```hcl
resource "aws_db_instance" "db" {
  # ...
  timeouts {
    create = "60m"
    delete = "30m"
  }
}
```

✅ **Best Practices**

* Use regional CI agents, increase timeouts for slow operations, and add retry logic for transient errors.

💡 **In short**
Timeouts come from slow networks, throttling, or long operations—address with timeouts, retries, and local runners.

---

## Q245: Terraform shows **"Error: Missing required argument"** but the argument is provided. What's wrong?

🧠 **Overview**
This typically means the argument is conditionally set or placed in the wrong block (typo, wrong resource type, or HCL expression results in null).

⚙️ **Troubleshooting steps**

1. **Check exact spelling and block**—argument must be in correct resource/type block.
2. **If the argument is provided conditionally**, ensure the condition evaluates to true during plan.
3. **Verify types**—passing list vs string may be treated as missing.
4. **If using modules**, ensure variable is declared in the module `variables.tf` and passed from root.

🧩 **Example**

```hcl
# Wrong: misplaced in provider block instead of resource
provider "aws" {
  instance_type = var.instance_type  # invalid
}
```

✅ **Best Practices**

* Validate with `terraform validate`.
* Use explicit `count`/`for_each` guarding rather than conditional nulls that remove required arguments.

💡 **In short**
Argument may be misspelled, conditionally omitted, or placed in wrong block—verify location, typing, and module var declaration.

---

## Q246: Your **null_resource** triggers are not working as expected. How do you debug?

🧠 **Overview**
`null_resource` uses `triggers` map to detect changes; if triggers are unchanged or unstable, provisioners won’t run predictably.

⚙️ **Checks & fixes**

1. **Ensure `triggers` contain values that change** when you want re-run (not computed per-run random values).
2. **Avoid using `timestamp()` or random values** unless you intentionally want always-trigger.
3. **Inspect `terraform state show null_resource.x`** to see current triggers.
4. **Use stable computed values** (e.g., module output) for triggers instead of ephemeral values.

🧩 **Example**

```hcl
resource "null_resource" "notify" {
  triggers = {
    app_version = var.app_version
    config_hash = sha256(file("${path.module}/config.yml"))
  }
  provisioner "local-exec" { command = "deploy-hook.sh" }
}
```

✅ **Best Practices**

* Use deterministic triggers based on file content or version.
* Avoid `null_resource` for core infra logic—use proper resources or orchestration tools.

💡 **In short**
Make triggers deterministic and meaningful; inspect state to ensure trigger values actually change.

---

## Q247: Terraform is **not detecting changes** in `templatefile` outputs. Why?

🧠 **Overview**
If the content passed to `templatefile()` or the file itself hasn’t changed in Terraform’s view, Terraform won’t detect changes. Also, if output is not referenced, it won’t trigger downstream resource updates.

⚙️ **Debug steps**

1. **Ensure `templatefile()` reads a real file**: changes to included files must be visible to Terraform (use `file()` checksums in triggers).
2. **If output used to create resource content**, ensure that changed content is part of resource attributes (e.g., `user_data`) so Terraform computes diff.
3. **Use `sha256(file(path))`** as explicit trigger for change detection.

🧩 **Example**

```hcl
locals {
  config = templatefile("${path.module}/app.tpl", { port = var.port })
  config_hash = sha256(local.config)
}
resource "local_file" "conf" {
  content  = local.config
  filename = "${path.module}/app.conf"
  # Use config_hash in triggers if needed
}
```

✅ **Best Practices**

* Compute and reference a stable hash of the template content to force updates.
* Avoid editing files in places Terraform cannot see (remote templates).

💡 **In short**
Make template changes observable (hash or include content in resource attrs) so Terraform detects diffs.

---

## Q248: A **local-exec provisioner runs on every apply**. How do you make it run only once?

🧠 **Overview**
Local-exec runs whenever the resource changes. If resource never changes or triggers are unstable, it may run repeatedly.

⚙️ **Solutions**

1. **Use `triggers` on `null_resource`** with a deterministic key that only changes when you want a run.
2. **Persist a marker** in state or external storage and conditionally run provisioner only if marker absent.
3. **Prefer idempotent scripts** so repeated runs are harmless.

🧩 **Example**

```hcl
resource "null_resource" "one_time" {
  triggers = {
    version = var.deploy_version  # only changes for new deploys
  }
  provisioner "local-exec" {
    command = "once.sh"
  }
}
```

✅ **Best Practices**

* Use deploy-version or file-hash as trigger.
* Avoid local-exec for critical one-time operations; prefer orchestration tools or CI steps.

💡 **In short**
Control execution with deterministic triggers (version/hash) so the provisioner runs only when trigger changes.

---

## Q249: You're experiencing **race conditions** with dependent resources. How do you resolve this?

🧠 **Overview**
Race conditions happen when resources depend on side-effects that Terraform cannot infer or when external systems change state concurrently.

⚙️ **Resolutions**

* **Add explicit `depends_on`** to enforce ordering when Terraform cannot infer it.
* **Split operations into multiple apply steps** (create producer, then consumer).
* **Add health/wait checks** (use `null_resource` with `local-exec` or external data source to wait).
* **Use provider-level features** (e.g., wait_for_active) or resource `timeouts`.

🧩 **Example**

```hcl
resource "aws_lb" "lb" { ... }
resource "aws_lb_target_group_attachment" "attach" {
  depends_on = [aws_lb.lb]
  # ensures LB exists before attachment
}
```

✅ **Best Practices**

* Keep dependency flow unidirectional.
* Use `depends_on` sparingly and only when necessary.
* Implement retry/backoff for external API eventual consistency.

💡 **In short**
Break races with explicit dependencies, staged applies, and robust wait/retry logic.

---

## Q250: **Terraform state and reality have diverged significantly.** What's your reconciliation strategy?

🧠 **Overview**
When state and real infra drift widely, you need a safe, auditable plan to reconcile without data loss or downtime.

⚙️ **Strategy**

1. **Inventory & snapshot**:

   * Pull and archive current state: `terraform state pull > state-backup.json`
   * Export cloud inventory (API/CLI) for comparison.
2. **Detect differences**:

   * Run `terraform plan` to list known diffs.
   * Use `terraform show -json` and compare against cloud resources.
3. **Triage resources**:

   * **Critical/stateful resources** (DBs, storage): prefer not to destroy—import or update HCL to match.
   * **Stateless/ephemeral**: consider recreating via Terraform.
4. **Rebuild systematically**:

   * For each resource: either `terraform import` (adopt), `terraform state rm` (stop managing), or adjust config then `apply`.
   * Use `moved {}` blocks for refactors if available.
5. **Test in staging**: run a full reconcile in a sandbox before production.
6. **Communicate & document**: coordinate with teams, schedule maintenance windows where necessary.

🧩 **Commands**

```bash
terraform state pull > backup.json
terraform import aws_s3_bucket.b my-bucket
terraform state rm aws_resource.orphan
```

✅ **Best Practices**

* Prefer importing/aligning rather than destroying.
* Work incrementally per module/service—don’t attempt a big-bang fix.
* Keep frequent backups and automate reconciliation checks going forward.

💡 **In short**
Inventory → triage → adopt/import or remove per-resource → test and proceed incrementally with backups and communication.

---
