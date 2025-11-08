Got it! I’ll give you a **concise, interview-ready Terraform guide** covering all your questions. I’ll structure it by your numbering, include examples, tables, and command snippets.

---

## **1️⃣ Basics & Fundamentals**

**Q: What is Terraform and what problems does it solve?**

* Terraform is an **Infrastructure as Code (IaC) tool** by HashiCorp.
* **Problem it solves**: Provisioning, configuring, and managing cloud resources in a **repeatable, version-controlled, declarative way**.

---

**Q: Declarative vs Imperative infrastructure**

| Type        | Definition                                             | Example                                                  |
| ----------- | ------------------------------------------------------ | -------------------------------------------------------- |
| Declarative | Describe **desired state**; Terraform determines steps | `resource "aws_s3_bucket" "mybucket" { bucket = "abc" }` |
| Imperative  | Describe **how to achieve state** step-by-step         | AWS CLI commands: `aws s3 mb s3://abc`                   |

---

**Q: Terraform providers**

* Plugins for interacting with cloud APIs.
* Examples: `aws`, `azurerm`, `google`, `kubernetes`.

---

**Q: Resources, data sources, variables, outputs**

* **Resource**: Actual infra to create (`aws_instance`).
* **Data source**: Read existing infra (`aws_ami`).
* **Variable**: Input params for code (`variable "env" {}`)
* **Output**: Expose values after apply (`output "bucket_name" {}`).

---

**Q: Terraform vs CloudFormation vs CDK**

| Feature  | Terraform     | CloudFormation | CDK            |
| -------- | ------------- | -------------- | -------------- |
| Language | HCL           | YAML/JSON      | TS/Python/Java |
| Cloud    | Multi-cloud   | AWS only       | AWS only       |
| Reuse    | Modules       | Macros/Stacks  | Constructs     |
| State    | Yes (tfstate) | No             | Uses CFN state |

---

**Q: .tf vs .tfstate files**

* **.tf**: Code that declares infra.
* **.tfstate**: JSON file storing current deployed state.

---

**Q: Terraform commands**

* `terraform init`: Download providers, initialize working dir.
* `terraform plan`: Shows what will change.
* `terraform apply`: Applies changes to reach desired state.
* `terraform apply -auto-approve`: Applies changes without manual confirmation.

---

## **2️⃣ Terraform State**

* **State**: Snapshot of infrastructure, critical for drift detection & updates.

* **Local vs Remote state**:

  | Type   | Storage             | Pros                        | Cons                 |
  | ------ | ------------------- | --------------------------- | -------------------- |
  | Local  | Local file          | Simple                      | Hard for teams       |
  | Remote | S3, Terraform Cloud | Team collaboration, locking | Needs backend config |

* **State locking**: Prevents concurrent updates (S3 + DynamoDB, Terraform Cloud).

* `terraform refresh`: Updates state file with actual infra.

* Multiple environments: Use **workspaces** or separate backends.

* Handle conflicts: Locking + manual `terraform state pull`/`push`.

---

## **3️⃣ Terraform Lifecycle**

* **Lifecycle blocks**: Control resource actions

```hcl
lifecycle {
  create_before_destroy = true
  prevent_destroy = true
  ignore_changes = [tags]
}
```

* **depends\_on**: Force dependency between resources.
* **Updates vs replacements**: Terraform replaces if immutable property changes.
* **Provisioners**: Run scripts on VM creation (use sparingly).
* **Destroy safely**: `terraform destroy -target=resource_name`.
* **Modules**: Encapsulate reusable infra; manage lifecycle collectively.

---

## **4️⃣ Terraform Modules**

* **Module**: A folder of `.tf` files (reusable infra).
* Create reusable modules with input variables and outputs.
* Pass variables:

```hcl
module "vpc" { source = "./modules/vpc" env = "prod" }
```

* Root module = entry `.tf` files; child module = imported module.
* Version constraints: Lock module versions for stability (`version = "1.2.0"`).

---

## **5️⃣ Terraform CLI Commands**

* `terraform fmt` → Format code
* `terraform validate` → Validate syntax
* `terraform import` → Bring existing infra under Terraform management
* `terraform taint/un-taint` → Mark a resource for recreation
* `terraform graph` → Visualize resource dependencies
* Destroy specific resources: `terraform destroy -target=aws_instance.foo`
* `terraform state list/show` → Inspect state
* Move resources in state: `terraform state mv`
* `terraform plan -out file` → Save plan for review or later apply

---

## **6️⃣ Terraform Variables**

* **Variable vs locals vs env**:

  | Type     | Use                      |
  | -------- | ------------------------ |
  | variable | Input from CLI/env/file  |
  | local    | Computed values          |
  | env var  | Override variable values |

* Sensitive variables: `sensitive = true`

* Default values: `variable "region" { default = "us-east-1" }`

* Override via CLI: `-var "env=prod"`, or `terraform.tfvars`.

---

Here’s a **structured, interview-ready explanation** for your questions from **Terraform Workspaces → Advanced → Security → Troubleshooting**, with examples and best practices.

---

## **7️⃣ Terraform Workspaces**

**Q: What are Terraform workspaces and why are they used?**

* Workspaces allow **multiple states for the same configuration** (e.g., dev/prod/staging).
* Useful to **isolate environments** without duplicating code.

**Q: How to create, select, and switch workspaces?**

```bash
# List workspaces
terraform workspace list

# Create new workspace
terraform workspace new dev

# Switch workspace
terraform workspace select dev
```

**Q: How does workspace isolation affect state files?**

* Each workspace has its **own `.tfstate`** file.
* Prevents conflicts between environments.
* Example: `terraform.tfstate` → default workspace, `terraform.tfstate.d/dev/terraform.tfstate` → dev workspace.

---

## **8️⃣ Terraform Advanced Concepts**

**Q: Remote backends and benefits**

* Store state in **S3, GCS, or Terraform Cloud** instead of local machine.
* Benefits:

  * Team collaboration
  * State locking (avoid concurrent edits)
  * Versioning & history
* Example S3 backend:

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-locks"
  }
}
```

**Q: Drift detection**

* Detects changes made outside Terraform.
* `terraform plan` or `terraform refresh` compares **current state vs real infrastructure**.

**Q: terraform refresh vs plan vs apply**

| Command             | Purpose                                                            |
| ------------------- | ------------------------------------------------------------------ |
| `terraform refresh` | Updates state file to match real infra; **does not apply changes** |
| `terraform plan`    | Shows changes required to reach desired state                      |
| `terraform apply`   | Applies changes to reach desired state                             |

**Q: Handling dependencies automatically**

* Terraform tracks **resource references** automatically.

```hcl
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  subnet_id     = aws_subnet.public.id
}
```

* `web` depends on `subnet` automatically.

**Q: count, for\_each, dynamic blocks**

```hcl
# count - create N resources
resource "aws_instance" "example" { count = 3 ... }

# for_each - create resource per map/item
resource "aws_sg" "example" { for_each = var.sg_map ... }

# dynamic - loop inside resource
dynamic "ingress" { for_each = var.rules ... content { from_port = ingress.value.from } }
```

**Q: Provider versions and multiple configurations**

```hcl
terraform {
  required_providers {
    aws = { source = "hashicorp/aws" version = "~> 5.0" }
  }
}

provider "aws" {
  alias  = "us"
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu"
  region = "eu-west-1"
}
```

**Q: terraform console**

* Interactive console for evaluating expressions or querying outputs.

```bash
terraform console
> aws_instance.example.id
```

**Q: Manage multiple AWS accounts/regions**

* Use **multiple provider blocks with alias**.
* Use **workspaces** for environment separation.
* Example: `provider "aws" { alias = "prod"; region = "us-east-1" }`.

**Q: Conditional logic (if, for, lookup)**

```hcl
count = var.create ? 1 : 0
name  = lookup(var.map, "key", "default")
```

---

## **9️⃣ Terraform Security & Best Practices**

**Q: Store secrets securely**

* Do **not hardcode**. Use:

  * AWS SSM Parameter Store
  * AWS Secrets Manager
  * Environment variables

```hcl
variable "db_password" {
  type      = string
  sensitive = true
}
```

**Q: Prevent accidental deletion**

```hcl
lifecycle { prevent_destroy = true }
```

**Q: Terraform drift**

* Occurs when infra is modified outside Terraform.
* Mitigate:

  * Run `terraform plan` regularly
  * Use remote state for teams
  * Apply changes through Terraform only

**Q: Best practices for organizing code**

* Separate **modules** per resource type
* Use **folders per environment**
* Keep **root module** simple
* Use **tfvars** files per environment

**Q: Testing Terraform code**

* `terraform validate` → syntax check
* `terraform plan` → review changes
* Use **Terratest** or **Kitchen-Terraform** for automated testing

---

## **🔟 Terraform Troubleshooting & Debugging**

**Q: Debug terraform apply errors**

```bash
TF_LOG=DEBUG terraform apply
TF_LOG_PATH=./terraform.log
```

**Q: Provider authentication issues**

* Check AWS credentials: `aws configure list`
* Verify role assumptions, environment variables, session tokens.

**Q: Fix state file corruption**

* Restore from backup (`terraform.tfstate.backup`)
* Use `terraform state pull`/`terraform state push`
* Consider remote backend for automatic versioning

**Q: Rollback changes**

* Revert to **previous state file** or use **plan saved with -out**

```bash
terraform apply "planfile"
```

---

✅ **TL;DR Cheat Sheet for Advanced Terraform**

* **Workspaces** → separate states per environment
* **Remote backends** → collaboration + locking
* **Drift detection** → plan vs real infra
* **Dependencies** → auto via references; `depends_on` if explicit
* **Count/for\_each/dynamic** → loops & multiple resources
* **Secrets & prevent\_destroy** → secure infra & prevent mistakes
* **Debugging** → `TF_LOG=DEBUG`, state restore, saved plans

---

If you want, I can **merge all your Terraform answers (Basics → Troubleshooting) into a single 2-page interview cheat sheet** with commands, best practices, and examples—ready for quick prep.

Do you want me to do that?
