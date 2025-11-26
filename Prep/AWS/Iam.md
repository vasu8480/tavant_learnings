# IAM (Identity and Access Management)

## Q: What is IAM?

### 🧠 Overview

**IAM (Identity and Access Management)** is an AWS service that securely controls access to AWS resources. It manages **who can do what** in your AWS environment through users, groups, roles, and policies.

---

### ⚙️ Purpose / How it Works

- IAM defines **identities** (users, roles, groups) and **permissions** (policies).
- Each request to an AWS service is **authenticated** (who you are) and **authorized** (what you can do).
- Supports **MFA**, **temporary credentials**, and **federated access** via SSO or identity providers (e.g., Okta, AD).

**Flow:**

1. User/role sends a request → IAM verifies identity.
2. IAM checks attached policies (Allow/Deny).
3. If allowed → AWS grants access.

---

### 🧩 Examples / Commands / Config Snippets

#### 🧱 Example 1: Create an IAM user via CLI

```bash
aws iam create-user --user-name devops-user
```

#### 🧱 Example 2: Attach a policy to the user

```bash
aws iam attach-user-policy \
  --user-name devops-user \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
```

#### 🧱 Example 3: Sample IAM policy (JSON)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket", "s3:GetObject"],
      "Resource": ["arn:aws:s3:::my-bucket", "arn:aws:s3:::my-bucket/*"]
    }
  ]
}
```

---

### 📋 IAM Components

| Component  | Description                                    | Example             |
| ---------- | ---------------------------------------------- | ------------------- |
| **User**   | Individual identity with long-term credentials | devops-user         |
| **Group**  | Collection of users with shared permissions    | DevOps-Team         |
| **Role**   | Temporary access identity for AWS resources    | EC2 role for S3     |
| **Policy** | JSON document defining permissions             | AmazonEC2FullAccess |
| **MFA**    | Extra security layer for authentication        | Authenticator App   |

---

### ✅ Best Practices

- Follow **least privilege principle** — only give what’s needed.
- Use **IAM roles** instead of static credentials.
- Rotate **access keys** regularly or avoid them entirely.
- Enable **MFA** for users with console access.
- Use **AWS Organizations SCPs** for account-wide restrictions.

---

### 💡 In short

IAM is AWS’s access control system for managing users, roles, and permissions.
Use roles for temporary access, policies for fine-grained control, and always enforce least privilege.

---

## Q: What are the main IAM components?

---

### 🧠 Overview

AWS **Identity and Access Management (IAM)** consists of several key components that work together to control authentication and authorization for AWS resources.
Each component has a specific role in **defining, grouping, and enforcing permissions**.

---

### ⚙️ Purpose / How It Works

IAM components define **who (identities)** can **access what (resources)** and **how (actions + policies)**.
These components ensure controlled access, whether it’s a human user, an AWS service, or an external identity provider.

---

### 📋 IAM Components Summary

| Component                   | Type                 | Purpose                                                                                               | Example Use Case                             |
| --------------------------- | -------------------- | ----------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| **User**                    | Identity             | Represents an individual or application with long-term credentials (Access keys or console password). | Developer accessing S3 and EC2               |
| **Group**                   | Identity container   | Logical grouping of users to apply shared permissions.                                                | “DevOpsTeam” group with EC2 access           |
| **Role**                    | Identity (temporary) | Grants permissions to AWS services or external identities without long-term credentials.              | EC2 role accessing S3 bucket                 |
| **Policy**                  | Permission           | JSON document defining actions, resources, and conditions (Allow/Deny).                               | AmazonS3FullAccess policy                    |
| **MFA (Multi-Factor Auth)** | Security feature     | Adds an extra authentication layer beyond passwords.                                                  | MFA for console login                        |
| **Access Key**              | Credential           | Used for programmatic (CLI/API) access.                                                               | `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` |
| **Identity Provider (IdP)** | Federation source    | Enables SSO/federated access from corporate directories or third-party providers.                     | SAML with Okta or Azure AD                   |

---

### 🧩 Example IAM Policy (JSON)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ec2:DescribeInstances", "s3:ListBucket"],
      "Resource": "*"
    }
  ]
}
```

---

### ✅ Best Practices

- Use **groups** for permission management (avoid direct user policies).
- Assign **roles** for EC2, Lambda, or EKS workloads instead of embedding credentials.
- Always **enable MFA** for console users.
- Enforce **least privilege** in policies.
- Use **AWS Organizations SCPs** for multi-account governance.

---

### 💡 In short

IAM components — **Users, Groups, Roles, Policies, MFA, and IdPs** — define and secure access in AWS.
Roles = temporary permissions, Policies = rules, Users/Groups = identities.
Together, they form the foundation of AWS security and access control.

---

## Q: What is the default IAM user when you create an AWS account?

---

### 🧠 Overview

When you first create an **AWS account**, AWS automatically creates a **root user** — this is the **default IAM identity** with **full access** to all AWS resources and services.

---

### ⚙️ Purpose / How It Works

- The **root user** is linked to the **email address** used during AWS account creation.
- It has **unrestricted privileges**, including account settings, billing, IAM management, and service access.
- IAM users and roles are created **afterward** to delegate access securely — the root user should rarely be used.

---

### 📋 Root User vs IAM User

| Feature                   | Root User                            | IAM User                           |
| ------------------------- | ------------------------------------ | ---------------------------------- |
| Created Automatically     | ✅ Yes (during AWS account creation) | ❌ Created manually                |
| Access Level              | Full access to everything            | Limited (based on policy)          |
| Recommended for Daily Use | ❌ No                                | ✅ Yes                             |
| Can Manage Billing        | ✅ Yes                               | Only if granted                    |
| Authentication Type       | Email + Password + (MFA optional)    | Username + Password or Access Keys |
| Can Be Deleted            | ❌ No                                | ✅ Yes                             |

---

### 🧩 Example: Secure Setup After Account Creation

1. **Enable MFA** for the root user:

   ```bash
   aws iam enable-mfa-device --user-name root --serial-number arn:aws:iam::123456789012:mfa/root --authentication-code1 123456 --authentication-code2 654321
   ```

2. **Create an admin IAM user**:

   ```bash
   aws iam create-user --user-name admin-user
   aws iam attach-user-policy --user-name admin-user --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
   ```

3. Use the **admin IAM user** for daily tasks, not the root user.

---

### ✅ Best Practices

- **Do not use the root user** for routine operations.
- **Enable MFA** immediately after account creation.
- **Create IAM users/roles** with specific permissions for daily use.
- **Lock away root credentials** and use **AWS Organizations** for multi-account setups.

---

### 💡 In short

The **root user** is the default IAM identity with full control over your AWS account.
Use it **only for critical setup tasks**, enable **MFA**, and create IAM users/roles for daily operations.

---

## Q: What is the difference between IAM User and IAM Role?

---

### 🧠 Overview

Both **IAM Users** and **IAM Roles** are AWS identities used to access AWS resources.
The key difference lies in **how credentials are managed** and **who/what assumes them** — users are for **individuals or applications**, while roles are for **temporary, assumed access**.

---

### ⚙️ Purpose / How It Works

- **IAM User**: A _permanent_ identity created for humans or apps needing long-term credentials (passwords, access keys).
- **IAM Role**: A _temporary_ identity assumed by users, AWS services, or external identities, using **STS (Security Token Service)** to issue short-lived credentials.

**Flow example:**
An EC2 instance assumes an IAM role → AWS STS provides temporary credentials → instance accesses S3 securely **without static keys**.

---

### 📋 Comparison Table

| Feature                    | **IAM User**                     | **IAM Role**                       |
| -------------------------- | -------------------------------- | ---------------------------------- |
| **Identity Type**          | Permanent                        | Temporary / Assumed                |
| **Credentials**            | Long-term (password, access key) | Short-term (STS tokens)            |
| **Usage**                  | Human users or apps              | AWS services, federated users      |
| **How Access Is Gained**   | Direct login or key use          | “Assumed” via STS (`AssumeRole`)   |
| **Use Case Example**       | Developer using AWS CLI          | EC2 accessing S3 without keys      |
| **Credential Rotation**    | Manual                           | Automatic (handled by AWS)         |
| **Can Log in to Console?** | Yes                              | Only if assumed through federation |
| **Trust Policy**           | Not applicable                   | Defines who can assume the role    |
| **Security Risk**          | Higher (static keys)             | Lower (temporary credentials)      |

---

### 🧩 Examples / Config Snippets

#### 🧱 IAM User (CLI)

```bash
aws iam create-user --user-name devops-user
aws iam attach-user-policy \
  --user-name devops-user \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
```

#### 🧱 IAM Role (Terraform Example)

```hcl
resource "aws_iam_role" "ec2_s3_access" {
  name = "EC2S3AccessRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_s3_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
```

---

### ✅ Best Practices

- Use **roles for EC2, Lambda, EKS**, and CI/CD workloads — never embed keys.
- Assign **least privilege** permissions.
- Rotate user access keys frequently or use **temporary tokens (STS)**.
- Monitor access with **CloudTrail**.
- Prefer **federation (SSO)** instead of IAM users for corporate logins.

---

### 💡 In short

- **IAM User** → Long-term identity for humans or apps (with keys/passwords).
- **IAM Role** → Temporary, assumed identity for AWS services or federated users.
  👉 Always **use roles over users** for workloads to avoid managing static credentials.

---

## Q: What is a Policy in IAM?

---

### 🧠 Overview

An **IAM Policy** is a **JSON document** that defines permissions — what actions are **allowed or denied** on specific AWS resources.
Policies are attached to **users, groups, or roles** to control access in AWS.

---

### ⚙️ Purpose / How It Works

- IAM policies use **statements** that specify:

  - **Effect** → Allow or Deny
  - **Action** → API operations (e.g., `s3:GetObject`)
  - **Resource** → AWS resources (e.g., specific S3 bucket)
  - **Condition** → Optional filters (e.g., IP address, MFA, tag-based)

- AWS evaluates all policies and grants access **only if an explicit Allow** exists and **no explicit Deny** applies.

---

### 🧩 Example IAM Policy (JSON)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": [
        "arn:aws:s3:::my-app-bucket",
        "arn:aws:s3:::my-app-bucket/*"
      ],
      "Condition": {
        "Bool": { "aws:MultiFactorAuthPresent": "true" }
      }
    }
  ]
}
```

---

### 📋 Types of IAM Policies

| Policy Type                      | Description                                              | Example                                   |
| -------------------------------- | -------------------------------------------------------- | ----------------------------------------- |
| **AWS Managed Policy**           | Predefined by AWS for common use cases                   | `AmazonS3FullAccess`                      |
| **Customer Managed Policy**      | Created and managed by you                               | `DevOpsEC2AccessPolicy`                   |
| **Inline Policy**                | Embedded directly into a single IAM user, group, or role | Policy directly inside an IAM role        |
| **Permission Boundary**          | Limits maximum permissions an IAM entity can have        | Prevents granting more than defined scope |
| **Service Control Policy (SCP)** | Applied at AWS Organizations level                       | Restrict regions or services globally     |

---

### 🧩 Attach Policy to a User (CLI)

```bash
aws iam attach-user-policy \
  --user-name devops-user \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
```

---

### ✅ Best Practices

- Always use **least privilege** — grant only necessary actions.
- Prefer **managed policies** for reusability.
- Use **inline policies** only for special cases.
- Apply **conditions** (e.g., MFA, IP restrictions) for better security.
- Regularly **review and audit** attached policies with IAM Access Analyzer.

---

### 💡 In short

An **IAM Policy** defines **who can do what** in AWS using a JSON rule set.
It specifies **actions, resources, and conditions** and enforces least privilege for users, roles, and groups.

---

## Q: What is a Managed Policy?

---

### 🧠 Overview

A **Managed Policy** in AWS IAM is a **standalone, reusable policy** that can be attached to **multiple users, groups, or roles**.
It helps simplify permission management by allowing centralized control over access definitions.

---

### ⚙️ Purpose / How It Works

- Managed policies are **not embedded** in a specific user or role — they exist independently.
- You can attach or detach them easily, making permission management **modular and scalable**.
- Two main types exist:

  - **AWS Managed Policies** — Created and maintained by AWS.
  - **Customer Managed Policies** — Created and maintained by you.

When a policy is updated, **all identities attached** to it automatically get the updated permissions — no manual edits required.

---

### 📋 Types of Managed Policies

| Type                        | Description                         | Maintained By | Editable | Example                                      |
| --------------------------- | ----------------------------------- | ------------- | -------- | -------------------------------------------- |
| **AWS Managed Policy**      | Predefined for common job functions | AWS           | ❌ No    | `AmazonEC2FullAccess`, `AdministratorAccess` |
| **Customer Managed Policy** | Custom-built and reusable           | You           | ✅ Yes   | `DevOpsEKSAccessPolicy`                      |

---

### 🧩 Example: Customer Managed Policy (JSON)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["eks:DescribeCluster", "ec2:DescribeInstances"],
      "Resource": "*"
    }
  ]
}
```

#### 🧱 Create via AWS CLI

```bash
aws iam create-policy \
  --policy-name DevOpsEKSAccessPolicy \
  --policy-document file://eks-policy.json
```

#### 🧱 Attach to a Role

```bash
aws iam attach-role-policy \
  --role-name EKSWorkerNodeRole \
  --policy-arn arn:aws:iam::<account-id>:policy/DevOpsEKSAccessPolicy
```

---

### ✅ Best Practices

- Use **AWS Managed Policies** for baseline permissions (e.g., read-only, full access).
- Use **Customer Managed Policies** for custom, project-specific needs.
- **Version** your custom policies to track changes.
- Regularly review **policy usage with IAM Access Analyzer**.
- Avoid inline policies for reusability — prefer managed policies instead.

---

### 💡 In short

A **Managed Policy** is a **standalone, reusable permission set** in AWS.
Use **AWS Managed Policies** for standard access and **Customer Managed Policies** for custom roles — both simplify and centralize IAM permission management.

---

## Q: What is an Inline Policy?

---

### 🧠 Overview

An **Inline Policy** is an **IAM policy embedded directly** into a **specific IAM user, group, or role**.
Unlike managed policies, it exists **only within that identity** and **cannot be reused** or shared with others.

---

### ⚙️ Purpose / How It Works

- Inline policies are **attached inline** — they live _inside_ a user, group, or role definition.
- They provide **tight control** when you need a one-to-one relationship between a policy and an IAM entity.
- If the entity (user/role/group) is deleted, the inline policy is **automatically deleted** too.

Use inline policies for **special-case permissions** that should not be shared or reused.

---

### 📋 Inline vs Managed Policy

| Feature              | **Inline Policy**                   | **Managed Policy**                |
| -------------------- | ----------------------------------- | --------------------------------- |
| **Attachment Scope** | Attached to one IAM entity only     | Reusable across multiple entities |
| **Reusability**      | ❌ No                               | ✅ Yes                            |
| **Lifecycle**        | Deleted with the parent entity      | Independent                       |
| **Ideal For**        | Unique, entity-specific permissions | Standardized access patterns      |
| **Created By**       | You                                 | AWS or You                        |
| **Versioning**       | Not supported                       | Supported (with versions)         |

---

### 🧩 Example: Inline Policy for a Role (JSON)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:PutObject", "s3:GetObject"],
      "Resource": "arn:aws:s3:::project-logs/*"
    }
  ]
}
```

#### 🧱 Attach Inline Policy via AWS CLI

```bash
aws iam put-role-policy \
  --role-name EKSLoggingRole \
  --policy-name S3LoggingAccess \
  --policy-document file://s3-inline-policy.json
```

---

### ✅ Best Practices

- Use **inline policies** only when permissions must stay tightly bound to a specific identity.
- Prefer **managed policies** for scalability and consistency.
- Regularly **audit inline policies** using IAM Policy Reports.
- Avoid duplication — convert repeated inline policies into a **customer managed policy**.

---

### 💡 In short

An **Inline Policy** is a **non-reusable, embedded IAM policy** tied directly to one user, role, or group.
Use it for **unique, one-off permissions**, but favor **managed policies** for maintainability and scalability.

---

## Q: What is the IAM Policy Evaluation Logic?

---

### 🧠 Overview

**IAM Policy Evaluation Logic** defines **how AWS decides** whether a request is **allowed or denied** based on all applicable policies.
It combines **identity-based**, **resource-based**, and **boundary** policies using a strict evaluation sequence.

---

### ⚙️ Purpose / How It Works

When an AWS user, role, or service makes a request:

1. **Authenticate** → AWS verifies who is making the request.
2. **Authorize** → AWS evaluates **all policies** attached to that identity and resource.
3. **Decision** → IAM allows or denies the request based on **explicit Allow**, **explicit Deny**, or **default Deny** rules.

---

### 🧩 Policy Evaluation Flow (Step-by-Step)

| Step  | Evaluation Stage                     | Description                                                                  |
| ----- | ------------------------------------ | ---------------------------------------------------------------------------- |
| **1** | **By default, everything is denied** | No access unless explicitly allowed.                                         |
| **2** | **Explicit Deny**                    | If any policy explicitly denies the request → it’s **denied immediately**.   |
| **3** | **Explicit Allow**                   | If no explicit Deny, IAM checks if any policy explicitly allows the request. |
| **4** | **Implicit Deny**                    | If there’s no explicit Allow, the request is **implicitly denied**.          |

---

### 📋 IAM Policy Evaluation Sources

| Policy Type                      | Evaluated?     | Description                                                          |
| -------------------------------- | -------------- | -------------------------------------------------------------------- |
| **Identity-based Policy**        | ✅             | Attached to user/role/group — defines what actions they can perform. |
| **Resource-based Policy**        | ✅             | Attached to the resource (e.g., S3 bucket policy).                   |
| **Permissions Boundary**         | ✅             | Limits the maximum permissions for IAM roles/users.                  |
| **Service Control Policy (SCP)** | ✅             | Applies at AWS Organization level — restricts member accounts.       |
| **Session Policy**               | ✅             | Applied to temporary credentials (via STS).                          |
| **Explicit Deny**                | 🛑 Always Wins | Overrides all Allow statements.                                      |

---

### 🧩 Example: Policy Evaluation Scenario

**Scenario:**
A user has:

- **Identity policy:** allows `s3:GetObject` on `arn:aws:s3:::my-bucket/*`
- **S3 bucket policy:** explicitly denies all actions from a specific IP

**Result:**
✅ `s3:GetObject` is _denied_ because the **explicit Deny in the bucket policy overrides** the user’s Allow.

---

### 🧩 Visual Summary (Logic Flow)

```
Start → Default Deny
    ↓
Check for Explicit Deny? → Yes → ❌ Deny
    ↓ No
Check for Explicit Allow? → Yes → ✅ Allow
    ↓ No
Implicit Deny → ❌ Deny
```

---

### ✅ Best Practices

- Always **avoid broad permissions** (e.g., `Action: "*"`, `Resource: "*"`)
- Use **explicit Deny** for critical restrictions (e.g., from certain IPs).
- Combine **resource-based + identity-based** policies for fine control.
- Review policy impact with **IAM Policy Simulator**.

---

### 💡 In short

IAM evaluates all policies in order:
1️⃣ Default Deny → 2️⃣ Explicit Deny → 3️⃣ Explicit Allow → 4️⃣ Implicit Deny.
🚫 **Explicit Deny always overrides Allow**, ensuring secure and predictable access control.

---

## Q: What are IAM Credentials?

---

### 🧠 Overview

**IAM Credentials** are the **authentication mechanisms** that allow an IAM user, role, or AWS service to securely access AWS resources.
They prove **who you are** (identity) and enable AWS to **authorize your actions**.

---

### ⚙️ Purpose / How It Works

AWS uses credentials to validate identity during every API request or console login.
Different credentials are issued depending on **how** you access AWS —
Console, CLI, SDK, or temporary sessions via roles and federation.

---

### 📋 Types of IAM Credentials

| Credential Type                    | Used By                        | Description                                                         | Duration                     | Example Use Case                     |
| ---------------------------------- | ------------------------------ | ------------------------------------------------------------------- | ---------------------------- | ------------------------------------ |
| **Password**                       | IAM User                       | Used for AWS Management Console access.                             | Until reset                  | DevOps engineer logging into console |
| **Access Key (ID + Secret)**       | IAM User / Programmatic Access | Used for AWS CLI, SDK, or API requests.                             | Long-term (rotate regularly) | Jenkins using AWS CLI                |
| **X.509 Certificates**             | IAM User (legacy)              | Used for AWS services requiring certificate authentication.         | Long-term                    | IoT or legacy APIs                   |
| **SSH Keys**                       | CodeCommit IAM User            | Used to access AWS CodeCommit repositories via Git over SSH.        | Long-term                    | Developer pushing code               |
| **Temporary Security Credentials** | IAM Role / Federated User      | Generated by **STS (Security Token Service)** when assuming a role. | Short-term (15 min – 12 hrs) | EC2 instance accessing S3 via role   |
| **MFA (Multi-Factor Auth)**        | IAM User / Root User           | Adds extra authentication factor (device or app).                   | Per session                  | Root user login protection           |

---

### 🧩 Example: Access Key Creation (CLI)

```bash
aws iam create-access-key --user-name devops-user
```

Output:

```json
{
  "AccessKey": {
    "AccessKeyId": "AKIAEXAMPLE",
    "SecretAccessKey": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
  }
}
```

#### Use in AWS CLI:

```bash
export AWS_ACCESS_KEY_ID=AKIAEXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

---

### 🧩 Example: Temporary Credentials (STS AssumeRole)

```bash
aws sts assume-role \
  --role-arn arn:aws:iam::123456789012:role/EKSAccessRole \
  --role-session-name DevOpsSession
```

Output includes temporary keys (`AccessKeyId`, `SecretAccessKey`, `SessionToken`).

---

### ✅ Best Practices

- Prefer **roles** (temporary credentials) over static **access keys**.
- **Rotate** access keys every 90 days or less.
- Enable **MFA** for console and critical users.
- Never hard-code credentials — use **environment variables**, **AWS CLI profiles**, or **EC2 instance roles**.
- Use **AWS Secrets Manager** or **Parameter Store** for key storage.

---

### 💡 In short

**IAM credentials** are keys, passwords, or tokens that authenticate users and services in AWS.
Use **temporary role-based credentials** wherever possible, and **avoid static keys** for secure, scalable access.

---

## Q: How do you Rotate IAM Access Keys?

---

### 🧠 Overview

**Access key rotation** is the process of **replacing old IAM access keys** (used for AWS CLI/API access) with **new ones** to minimize security risks from key leaks or long-term use.
Rotation ensures compliance with **AWS security best practices** and **least privilege principles**.

---

### ⚙️ Purpose / How It Works

- Each IAM user can have **two active access keys** at a time (`AccessKeyId` + `SecretAccessKey`).
- This allows safe rotation — you can **create a new key**, **update applications**, and **deactivate the old one** without downtime.
- Once verified, delete the old key to complete the rotation.

---

### 🧩 Step-by-Step Access Key Rotation

#### 🔹 Step 1: List existing access keys

```bash
aws iam list-access-keys --user-name devops-user
```

#### 🔹 Step 2: Create a new access key

```bash
aws iam create-access-key --user-name devops-user
```

Output:

```json
{
  "AccessKey": {
    "AccessKeyId": "AKIAEXAMPLE2",
    "SecretAccessKey": "NEWSECRETEXAMPLEKEY"
  }
}
```

#### 🔹 Step 3: Update your applications or environment

```bash
export AWS_ACCESS_KEY_ID=AKIAEXAMPLE2
export AWS_SECRET_ACCESS_KEY=NEWSECRETEXAMPLEKEY
```

_(Update credentials in Jenkins, CI/CD, environment variables, etc.)_

#### 🔹 Step 4: Verify functionality

Test API/CLI access using the new key:

```bash
aws sts get-caller-identity
```

#### 🔹 Step 5: Deactivate the old access key

```bash
aws iam update-access-key \
  --access-key-id AKIAOLDKEY123 \
  --status Inactive \
  --user-name devops-user
```

#### 🔹 Step 6: Delete the old key (after verification)

```bash
aws iam delete-access-key \
  --access-key-id AKIAOLDKEY123 \
  --user-name devops-user
```

---

### 📋 Key Rotation Lifecycle

| Stage | Action                    | Purpose                        |
| ----- | ------------------------- | ------------------------------ |
| **1** | Create new key            | Prepare for rotation           |
| **2** | Update system credentials | Switch applications to new key |
| **3** | Test new key              | Validate permissions           |
| **4** | Deactivate old key        | Prevent accidental use         |
| **5** | Delete old key            | Final cleanup                  |

---

### ✅ Best Practices

- Rotate access keys **every 90 days or less**.
- Prefer **IAM roles or federated access** to eliminate static keys.
- Use **AWS Secrets Manager** to automate key rotation and secure storage.
- Audit access keys using **IAM Credential Reports**.
- Never share or commit keys in code repositories (use `.gitignore` and scanning tools).

---

### 💡 In short

Rotate IAM access keys by **creating a new one**, **updating configurations**, and **deactivating + deleting the old key**.
For stronger security — **use IAM roles instead of long-term access keys** wherever possible.

---

## Q: What are IAM Roles used for?

---

### 🧠 Overview

An **IAM Role** is a **temporary AWS identity** with specific permissions that can be **assumed by users, services, or applications**.
Unlike IAM users, roles **don’t have long-term credentials** — instead, they issue **short-lived tokens** via **STS (Security Token Service)** for secure access.

---

### ⚙️ Purpose / How It Works

IAM Roles are used to **delegate permissions** without sharing static credentials.
They define:

- **Who can assume the role** (trust policy).
- **What the role can do** (permission policy).

When an entity assumes a role, AWS provides **temporary security credentials** valid for a short period (typically 15 min–12 hrs).

---

### 📋 Common Use Cases

| Use Case                      | Description                                                   | Example                               |
| ----------------------------- | ------------------------------------------------------------- | ------------------------------------- |
| **EC2 → S3 Access**           | Allow EC2 instances to access S3 buckets without access keys. | `AmazonS3ReadOnlyAccess` on EC2 role  |
| **Cross-Account Access**      | Enable users in Account A to access resources in Account B.   | AssumeRole with external account ID   |
| **AWS Services Access**       | Allow services like Lambda, EKS, ECS to call other AWS APIs.  | Lambda role accessing DynamoDB        |
| **Federated Access (SSO)**    | Allow external identities (AD, Okta) to assume roles.         | SAML-based login                      |
| **Temporary Elevated Access** | Give developers short-term admin privileges.                  | Assume role via `aws sts assume-role` |
| **CI/CD Pipelines**           | Jenkins/GitHub Actions assume roles for AWS deployments.      | AssumeRole from CI runner             |

---

### 🧩 Example: IAM Role (Terraform)

```hcl
resource "aws_iam_role" "eks_node_role" {
  name = "EKSNodeRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}
```

---

### 🧩 Example: Assume Role via CLI

```bash
aws sts assume-role \
  --role-arn arn:aws:iam::123456789012:role/DevOpsDeployRole \
  --role-session-name CICDSession
```

Output contains temporary credentials:

```json
{
  "Credentials": {
    "AccessKeyId": "ASIAEXAMPLE",
    "SecretAccessKey": "abc123example",
    "SessionToken": "FQoGZXIvYXdzE...",
    "Expiration": "2025-11-12T13:45:00Z"
  }
}
```

---

### 📋 Trust Policy vs Permission Policy

| Policy Type           | Purpose                                     | Example                                         |
| --------------------- | ------------------------------------------- | ----------------------------------------------- |
| **Trust Policy**      | Defines _who_ can assume the role           | `Principal: { "Service": "ec2.amazonaws.com" }` |
| **Permission Policy** | Defines _what_ actions the role can perform | `Action: ["s3:GetObject"], Resource: "*" `      |

---

### ✅ Best Practices

- Use **roles instead of access keys** for AWS services.
- Apply **least privilege** — grant only necessary permissions.
- Restrict role assumption via **trust policy conditions** (like source IP, MFA).
- Monitor role usage with **CloudTrail**.
- Regularly **review and rotate trust relationships**.

---

### 💡 In short

**IAM Roles** provide **temporary, permission-based access** for users, applications, or AWS services — eliminating the need for static credentials.
They’re the backbone of **secure, automated access** in AWS (e.g., EC2 → S3, CI/CD → EKS).

---

## Q: How to Attach an IAM Role to an EC2 Instance?

---

### 🧠 Overview

Attaching an **IAM Role** to an **EC2 instance** allows that instance to **securely access AWS services** (like S3, CloudWatch, DynamoDB) **without using access keys**.
The instance automatically receives **temporary credentials** via the **Instance Metadata Service (IMDS)**.

---

### ⚙️ Purpose / How It Works

- The role is assigned through an **Instance Profile** (a wrapper for IAM roles).
- When EC2 assumes the role, AWS STS provides **temporary tokens**.
- Applications inside EC2 (CLI, SDK, etc.) automatically use these credentials — no manual setup needed.

**Flow:**

```
EC2 Instance → Instance Profile → IAM Role → STS → Temporary Credentials → Access AWS Services
```

---

### 🧩 Step-by-Step: Attach IAM Role to EC2 (Console & CLI)

#### 🔹 **Step 1: Create IAM Role (Trust EC2 Service)**

```bash
aws iam create-role \
  --role-name EC2S3AccessRole \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }]
  }'
```

#### 🔹 **Step 2: Attach Policy (e.g., S3 Access)**

```bash
aws iam attach-role-policy \
  --role-name EC2S3AccessRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
```

#### 🔹 **Step 3: Create an Instance Profile**

```bash
aws iam create-instance-profile --instance-profile-name EC2S3AccessProfile
aws iam add-role-to-instance-profile \
  --instance-profile-name EC2S3AccessProfile \
  --role-name EC2S3AccessRole
```

#### 🔹 **Step 4: Attach Role (Instance Profile) to Running EC2**

```bash
aws ec2 associate-iam-instance-profile \
  --instance-id i-0abc1234def567890 \
  --iam-instance-profile Name=EC2S3AccessProfile
```

✅ _Or while launching a new EC2 instance (Console):_

- In **Step 3: Configure Instance**, under **IAM role**, choose your role (e.g., `EC2S3AccessRole`).

---

### 🧩 Verify Role Attachment

Login to EC2 and run:

```bash
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/
```

Output (example):

```
EC2S3AccessRole
```

Get temporary credentials:

```bash
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/EC2S3AccessRole
```

---

### 📋 Behind the Scenes

| Component            | Description                                                       |
| -------------------- | ----------------------------------------------------------------- |
| **IAM Role**         | Defines permissions and trust policy                              |
| **Instance Profile** | Container that makes the role usable by EC2                       |
| **STS Tokens**       | Temporary credentials provided to EC2                             |
| **IMDSv2**           | Secure metadata service that provides credentials to the instance |

---

### ✅ Best Practices

- Always use **IMDSv2** for instance metadata access.
- Limit permissions with **least privilege** policies.
- Rotate role credentials automatically (STS handles this).
- Avoid embedding access keys in EC2 environments.
- Monitor access with **CloudTrail** and **IAM Access Analyzer**.

---

### 💡 In short

To attach an IAM role to EC2:
1️⃣ Create role with EC2 trust policy → 2️⃣ Attach policy → 3️⃣ Create instance profile → 4️⃣ Associate it to the EC2 instance.
✅ This enables secure, **keyless access** to AWS services via **temporary credentials**.

---

## Q: What is the IAM Policy Structure?

---

### 🧠 Overview

An **IAM Policy** is a **JSON document** that defines permissions for AWS resources.
It follows a structured format with specific elements — each defining **who**, **what**, and **under what conditions** access is allowed or denied.

---

### ⚙️ Purpose / How It Works

Every policy is evaluated by AWS to determine if a request should be **Allowed** or **Denied**.
A policy contains **statements** with rules specifying:

- **Effect** (Allow/Deny)
- **Action** (which API operations)
- **Resource** (ARNs of AWS resources)
- **Condition** (optional filters for finer control)

---

### 🧩 IAM Policy JSON Structure

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "OptionalStatementID",
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": [
        "arn:aws:s3:::my-app-bucket",
        "arn:aws:s3:::my-app-bucket/*"
      ],
      "Condition": {
        "StringEquals": {
          "aws:username": "devops-user"
        }
      }
    }
  ]
}
```

---

### 📋 IAM Policy Elements

| Element       | Required | Description                                                              | Example                                           |
| ------------- | -------- | ------------------------------------------------------------------------ | ------------------------------------------------- |
| **Version**   | ✅       | Defines policy language version; always `"2012-10-17"` for new policies. | `"Version": "2012-10-17"`                         |
| **Statement** | ✅       | Contains one or more permissions blocks.                                 | `[ {...}, {...} ]`                                |
| **Sid**       | ❌       | Optional identifier for the statement.                                   | `"Sid": "S3AccessStatement"`                      |
| **Effect**    | ✅       | Defines whether to _Allow_ or _Deny_ access.                             | `"Effect": "Allow"`                               |
| **Action**    | ✅       | Lists AWS API operations the policy affects.                             | `"Action": ["ec2:DescribeInstances"]`             |
| **Resource**  | ✅       | Specifies resource ARNs the policy applies to.                           | `"arn:aws:s3:::mybucket/*"`                       |
| **Condition** | ❌       | Adds restrictions (e.g., IP, time, MFA).                                 | `"IpAddress": {"aws:SourceIp": "203.0.113.0/24"}` |

---

### 🧩 Example: Policy with Conditions

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::secure-bucket/*",
      "Condition": {
        "Bool": { "aws:MultiFactorAuthPresent": "true" }
      }
    }
  ]
}
```

✅ _Allows uploading objects to S3 only when MFA is enabled._

---

### 📋 Multiple Statement Example

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowS3Read",
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": ["arn:aws:s3:::mybucket", "arn:aws:s3:::mybucket/*"]
    },
    {
      "Sid": "DenyS3Delete",
      "Effect": "Deny",
      "Action": "s3:DeleteObject",
      "Resource": "arn:aws:s3:::mybucket/*"
    }
  ]
}
```

---

### ✅ Best Practices

- Always use the latest `"Version": "2012-10-17"`.
- Use **least privilege** — specify only required `Action` and `Resource`.
- Use **conditions** for extra security (e.g., IPs, MFA, tags).
- Avoid `"Action": "*"`, `"Resource": "*"`.
- Use **Sid** values for traceability and readability.
- Validate policies using **IAM Policy Simulator** or **Access Analyzer**.

---

### 💡 In short

An **IAM policy** is a JSON document with a defined **structure**:
`Version` → `Statement` → `Effect`, `Action`, `Resource`, and `Condition`.
It tells AWS **what actions** are allowed or denied on **which resources**, and **under what conditions**.

---

## Q: What is the Difference Between AWS Managed and Customer Managed Policies?

---

### 🧠 Overview

In AWS IAM, **Managed Policies** are standalone permission sets that can be attached to multiple users, groups, or roles.
They come in two types — **AWS Managed** and **Customer Managed** — based on who creates and controls them.

---

### ⚙️ Purpose / How It Works

Both policy types help simplify permission management, but differ in **ownership**, **control**, and **customization**:

- **AWS Managed Policies** are prebuilt by AWS for common job functions or use cases.
- **Customer Managed Policies** are custom-built and maintained by you to meet specific organizational needs.

---

### 📋 Comparison Table

| Feature                        | **AWS Managed Policy**                                   | **Customer Managed Policy**                                        |
| ------------------------------ | -------------------------------------------------------- | ------------------------------------------------------------------ |
| **Created & Maintained By**    | AWS                                                      | You (Account Owner)                                                |
| **Editable**                   | ❌ No (read-only)                                        | ✅ Yes (full control)                                              |
| **Customization**              | Not customizable                                         | Fully customizable                                                 |
| **Policy Scope**               | Generic, broad permissions                               | Fine-tuned, specific to workloads                                  |
| **Versioning Support**         | Automatically updated by AWS                             | You manage versions manually                                       |
| **Use Case**                   | Common AWS roles (e.g., EC2FullAccess, S3ReadOnlyAccess) | Company-specific or restricted access (e.g., DevOpsS3AccessPolicy) |
| **Risk**                       | May grant broader access than required                   | Controlled and least privilege possible                            |
| **Maintenance Responsibility** | AWS                                                      | You                                                                |
| **Attachment**                 | Reusable across multiple IAM entities                    | Reusable across multiple IAM entities                              |

---

### 🧩 Example 1: AWS Managed Policy

```json
{
  "PolicyName": "AmazonEC2ReadOnlyAccess",
  "Arn": "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}
```

📘 _Maintained by AWS — grants read-only permissions for all EC2 resources._

---

### 🧩 Example 2: Customer Managed Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket", "s3:GetObject"],
      "Resource": ["arn:aws:s3:::project-logs", "arn:aws:s3:::project-logs/*"]
    }
  ]
}
```

📘 _Created by you — grants S3 read access only to a specific bucket._

---

### 🧩 Create a Customer Managed Policy (CLI)

```bash
aws iam create-policy \
  --policy-name DevOpsS3AccessPolicy \
  --policy-document file://s3-policy.json
```

Attach to a role:

```bash
aws iam attach-role-policy \
  --role-name EKSWorkerRole \
  --policy-arn arn:aws:iam::<account-id>:policy/DevOpsS3AccessPolicy
```

---

### ✅ Best Practices

- Use **AWS Managed Policies** for quick setup and general permissions.
- Use **Customer Managed Policies** for **production** environments requiring custom access control.
- Regularly **review AWS Managed Policies** — AWS may add new permissions automatically.
- Apply **least privilege** and **version control** on custom policies.
- Use **naming conventions** for managed policies (e.g., `Team-Service-AccessPolicy`).

---

### 💡 In short

| AWS Managed                  | Customer Managed                    |
| ---------------------------- | ----------------------------------- |
| Prebuilt by AWS, easy to use | Custom-built by you, fully editable |
| Broad and generic            | Fine-grained and specific           |
| No maintenance               | Full control and ownership          |

👉 Use **AWS Managed Policies** for quick setup or testing, and **Customer Managed Policies** for **secure, production-grade access control**.

---

## Q: What is the Principle of Least Privilege (PoLP)?

---

### 🧠 Overview

The **Principle of Least Privilege (PoLP)** is a **security best practice** in AWS IAM and DevOps that states:

> _“Users, roles, and services should have only the permissions necessary to perform their tasks — and nothing more.”_

It minimizes the **attack surface**, **limits accidental misuse**, and **reduces blast radius** in case of credential compromise.

---

### ⚙️ Purpose / How It Works

- Every IAM entity (user, role, group, service) should get **only the minimal required actions and resources**.
- Avoid granting broad access such as `"Action": "*"`, `"Resource": "*"`.
- Review and refine permissions regularly as responsibilities or workloads change.

**Flow Example:**
1️⃣ Developer needs to read logs → Give `CloudWatchLogsReadOnlyAccess`.
2️⃣ Do not assign `AdministratorAccess`.
3️⃣ Regularly audit and adjust permissions.

---

### 📋 Example Comparison

| Policy Type                   | Description                                        | Risk Level |
| ----------------------------- | -------------------------------------------------- | ---------- |
| ❌ **Over-Privileged Policy** | Grants all actions on all resources                | 🔥 High    |
| ✅ **Least Privilege Policy** | Grants only required read actions on specific logs | 🟢 Low     |

#### ❌ Over-Privileged Example

```json
{
  "Effect": "Allow",
  "Action": "*",
  "Resource": "*"
}
```

#### ✅ Least Privilege Example

```json
{
  "Effect": "Allow",
  "Action": ["logs:DescribeLogGroups", "logs:GetLogEvents"],
  "Resource": "arn:aws:logs:ap-south-1:123456789012:log-group:/aws/eks/*"
}
```

---

### 📋 PoLP in Practice (Where to Apply)

| Layer                               | Example Application                                     |
| ----------------------------------- | ------------------------------------------------------- |
| **IAM**                             | Users/roles get minimum required permissions.           |
| **EC2 / Lambda**                    | Assign roles with limited policies, not full access.    |
| **S3 Buckets**                      | Restrict bucket policies to specific users or prefixes. |
| **Kubernetes**                      | Use fine-grained RBAC roles instead of cluster-admin.   |
| **CI/CD (Jenkins, GitHub Actions)** | Limit pipeline IAM roles to only needed AWS APIs.       |

---

### ✅ Best Practices

- **Start with deny-all → grant incrementally.**
- Use **IAM Access Analyzer** to detect unused or excessive permissions.
- Apply **resource-level permissions** whenever possible.
- Regularly **review IAM roles, users, and groups** for unnecessary access.
- Enforce **MFA** and **temporary credentials (STS)**.
- Use **service-specific roles** (e.g., EC2Role, LambdaRole).

---

### 💡 In short

The **Principle of Least Privilege** means granting **only the permissions absolutely necessary** — nothing extra.
✅ It reduces security risks, prevents accidental misuse, and is a cornerstone of AWS IAM best practices.

---

## Q: How to Enforce MFA for IAM Users?

---

### 🧠 Overview

**Multi-Factor Authentication (MFA)** adds an **extra layer of security** by requiring users to provide a **second verification factor** (e.g., OTP from an authenticator app or hardware token) in addition to their password or access key.
Enforcing MFA ensures that even if credentials are compromised, unauthorized access is still blocked.

---

### ⚙️ Purpose / How It Works

- MFA ties **something you know** (password/access key) with **something you have** (authenticator app/device).
- AWS IAM supports both **virtual MFA devices** (e.g., Google Authenticator, Authy) and **hardware MFA** (YubiKey, Gemalto).
- You can **enforce MFA** using IAM **policies** that deny all requests unless MFA is active in the session.

---

### 🧩 Step-by-Step: Enforce MFA for IAM Users

#### 🔹 **Step 1: Enable MFA for a User (Console)**

1. Sign in to **AWS Management Console** as an admin.
2. Go to **IAM → Users → [Username] → Security Credentials**.
3. Under **Multi-Factor Authentication (MFA)** → Click **Assign MFA device**.
4. Choose:

   - **Virtual MFA** → Scan QR code with Authenticator app.
   - **Hardware MFA** → Enter serial number.

5. Enter 2 consecutive OTPs to complete setup.

---

#### 🔹 **Step 2: Verify via AWS CLI**

```bash
aws iam list-mfa-devices --user-name devops-user
```

Output:

```json
{
  "MFADevices": [
    {
      "UserName": "devops-user",
      "SerialNumber": "arn:aws:iam::123456789012:mfa/devops-user",
      "EnableDate": "2025-11-12T09:20:00Z"
    }
  ]
}
```

---

#### 🔹 **Step 3: Enforce MFA with IAM Policy**

Attach this policy to **users or groups** to deny all actions unless MFA is enabled:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "BlockAccessUnlessMFAPresent",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "BoolIfExists": { "aws:MultiFactorAuthPresent": "false" }
      }
    }
  ]
}
```

✅ _Effect:_ Any request without MFA will be denied — even if other policies allow it.

---

#### 🔹 **Step 4: Test the Policy**

Try accessing AWS CLI or Console without MFA → request fails.
With MFA (via AWS Console or `sts get-session-token`), access succeeds.

---

### 🧩 Optional: Require MFA for CLI Sessions

Use STS to generate **temporary credentials with MFA**:

```bash
aws sts get-session-token \
  --serial-number arn:aws:iam::123456789012:mfa/devops-user \
  --token-code 123456
```

Then export:

```bash
export AWS_ACCESS_KEY_ID=ASIAEXAMPLE
export AWS_SECRET_ACCESS_KEY=SECRETEXAMPLE
export AWS_SESSION_TOKEN=TOKENEXAMPLE
```

---

### 📋 MFA Device Types

| Type                 | Description                      | Example                     |
| -------------------- | -------------------------------- | --------------------------- |
| **Virtual MFA**      | Mobile app generates OTP         | Authy, Google Authenticator |
| **Hardware MFA**     | Physical device with OTP display | YubiKey, Gemalto token      |
| **U2F Security Key** | USB key-based login              | YubiKey Security Key        |

---

### ✅ Best Practices

- Enforce MFA for **all IAM users and root account**.
- Combine with **least privilege** and **strong password policy**.
- Monitor MFA compliance using **IAM Credential Reports**.
- For organizations, enforce MFA across accounts using **AWS Organizations SCPs**.
- Prefer **federated SSO (with MFA)** over local IAM users when possible.

---

### 💡 In short

To enforce MFA for IAM users:
1️⃣ Enable MFA (virtual or hardware),
2️⃣ Attach a deny policy requiring `aws:MultiFactorAuthPresent=true`.
✅ This ensures **no IAM user can access AWS without MFA**, strengthening your account security posture.

---

## Q: What are IAM Access Analyzer Findings?

---

### 🧠 Overview

**IAM Access Analyzer Findings** are **reports generated by AWS Access Analyzer** that help you **identify unintended resource sharing or access permissions** in your AWS environment.
They highlight **who has access** to your resources **from outside your account** — ensuring compliance and least-privilege enforcement.

---

### ⚙️ Purpose / How It Works

IAM Access Analyzer uses **automated reasoning** to analyze **policies attached to resources** (like S3 buckets, IAM roles, KMS keys, etc.).
It continuously monitors for:

- **External access** (public or cross-account)
- **Policy misconfigurations** (e.g., overly broad access)
- **Noncompliance with security standards**

When detected, Access Analyzer generates **findings** that describe:

- **Which resource** is accessible
- **Who** can access it
- **Type of access** (Read, Write, Full)
- **Source account or entity**

---

### 🧩 Example: Access Analyzer Finding (JSON Output)

```json
{
  "findings": [
    {
      "id": "abcd1234-5678-90ef-ghij-1234567890ab",
      "resource": "arn:aws:s3:::public-data-bucket",
      "resourceType": "S3Bucket",
      "principal": "*",
      "action": ["s3:GetObject"],
      "isPublic": true,
      "status": "ACTIVE",
      "createdAt": "2025-11-12T09:00:00Z",
      "findingType": "ExternalAccess"
    }
  ]
}
```

📘 _Indicates that `public-data-bucket` is publicly accessible (`principal: _`).\*

---

### 📋 Types of IAM Access Analyzer Findings

| Finding Type                       | Description                                                 | Example                              |
| ---------------------------------- | ----------------------------------------------------------- | ------------------------------------ |
| **Public Access**                  | Resource accessible by anyone (`Principal: *`).             | Public S3 bucket                     |
| **Cross-Account Access**           | Shared with another AWS account.                            | IAM role trusted by external account |
| **Cross-Organization Access**      | Accessible from another AWS Organization.                   | Shared KMS key                       |
| **Service Access**                 | AWS service (like Lambda, CloudTrail) has resource access.  | S3 bucket accessed by CloudTrail     |
| **Unused Access Analyzer Finding** | Outdated finding; permissions changed but not re-evaluated. | Resolved finding remains “ARCHIVED”  |

---

### 🧩 Supported Resource Types

| Resource Type       | Examples of Analyzed Policies |
| ------------------- | ----------------------------- |
| **S3 Bucket**       | Bucket policy, ACL            |
| **IAM Role**        | Trust policy                  |
| **KMS Key**         | Key policy                    |
| **SQS Queue**       | Queue policy                  |
| **SNS Topic**       | Topic policy                  |
| **Lambda Function** | Function resource policy      |

---

### 🧩 Example: Create Access Analyzer (CLI)

```bash
aws accessanalyzer create-analyzer \
  --analyzer-name account-access-analyzer \
  --type ACCOUNT
```

#### List findings:

```bash
aws accessanalyzer list-findings \
  --analyzer-name account-access-analyzer
```

#### Archive resolved finding:

```bash
aws accessanalyzer archive-findings \
  --analyzer-name account-access-analyzer \
  --ids abcd1234-5678-90ef-ghij-1234567890ab
```

---

### ✅ Best Practices

- Enable **IAM Access Analyzer in all AWS Regions**.
- Regularly **review and resolve ACTIVE findings**.
- Use **AWS Organizations analyzers** for centralized visibility.
- Integrate findings with **Security Hub** or **EventBridge** for alerts.
- Use findings to enforce the **Principle of Least Privilege**.
- Archive or suppress valid findings (e.g., intentional cross-account roles).

---

### 💡 In short

**IAM Access Analyzer Findings** reveal **who can access your AWS resources** — inside or outside your account.
✅ They help detect **public or cross-account exposure** early, ensuring your IAM and resource policies follow **least privilege and compliance best practices**.

---

## Q: What are Service-Linked Roles?

---

### 🧠 Overview

A **Service-Linked Role (SLR)** is a **special type of IAM role** that is **predefined and managed by AWS services**.
It allows an AWS service to **perform actions on your behalf** — using permissions that are automatically defined and maintained by AWS.

---

### ⚙️ Purpose / How It Works

- AWS creates and manages the **trust and permission policies** for service-linked roles.
- These roles are **linked directly to an AWS service** (e.g., ECS, EKS, RDS, CloudTrail).
- They simplify permissions setup — you don’t have to manually create or attach IAM policies.
- When the service performs an operation (like creating or managing resources), it assumes this role automatically.

**Flow Example:**

```
Your AWS Account → Service-Linked Role → AWS Service → Resource Actions (on your behalf)
```

---

### 🧩 Example: Service-Linked Role (ECS)

#### Created automatically when you enable ECS:

```bash
aws iam get-role --role-name AWSServiceRoleForECS
```

#### Example Trust Policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "ecs.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

#### Example Permissions Policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "elasticloadbalancing:RegisterTargets"
      ],
      "Resource": "*"
    }
  ]
}
```

---

### 📋 Key Characteristics

| Feature                  | Description                                                         |
| ------------------------ | ------------------------------------------------------------------- |
| **Created By**           | AWS service automatically or manually by you                        |
| **Owned By**             | AWS service (cannot be reused by others)                            |
| **Policy Management**    | Maintained by AWS — automatically updated when the service changes  |
| **Deletion Restriction** | Cannot be deleted until the related service is disabled or detached |
| **Trust Relationship**   | Fixed — only the specific service can assume the role               |

---

### 🧩 Example: Manually Create a Service-Linked Role (CLI)

```bash
aws iam create-service-linked-role \
  --aws-service-name ecs.amazonaws.com
```

### 🧩 Example: Delete Service-Linked Role

```bash
aws iam delete-service-linked-role \
  --role-name AWSServiceRoleForECS
```

_(Will fail if ECS is still using it.)_

---

### 📋 Common AWS Services That Use SLRs

| Service                    | Role Name Example                       |
| -------------------------- | --------------------------------------- |
| **ECS**                    | `AWSServiceRoleForECS`                  |
| **Elastic Load Balancing** | `AWSServiceRoleForElasticLoadBalancing` |
| **CloudTrail**             | `AWSServiceRoleForCloudTrail`           |
| **RDS**                    | `AWSServiceRoleForRDS`                  |
| **Lambda**                 | `AWSServiceRoleForLambda`               |
| **Organizations**          | `AWSServiceRoleForOrganizations`        |
| **Auto Scaling**           | `AWSServiceRoleForAutoScaling`          |

---

### ✅ Best Practices

- **Do not modify or delete** service-linked roles manually.
- Allow AWS to **auto-manage permissions** to prevent service errors.
- Regularly **review SLRs** using:

  ```bash
  aws iam list-roles --query "Roles[?contains(RoleName, 'AWSServiceRole')].RoleName"
  ```

- Use **least privilege** for your custom roles; reserve SLRs for service automation.
- **Document which services** have active service-linked roles for compliance.

---

### 💡 In short

**Service-Linked Roles (SLRs)** are **predefined IAM roles** created for AWS services to operate securely on your behalf.
✅ AWS manages their policies and trust relationships automatically — ensuring correct, minimal permissions without manual configuration.

---

## Q: How Do You Give Cross-Account Access in AWS IAM?

---

### 🧠 Overview

**Cross-account access** lets users or resources in **one AWS account (Account A)** securely access resources in **another AWS account (Account B)** — without sharing long-term credentials.
This is typically achieved using **IAM roles**, **resource-based policies**, or **AWS Organizations SCPs**.

---

### ⚙️ Purpose / How It Works

AWS uses **trust relationships** between accounts to enable cross-account operations.
Common patterns:

1. **IAM Role-based access** → Account A assumes a role in Account B using `sts:AssumeRole`.
2. **Resource-based policy access** → Account B’s resource (e.g., S3 bucket, KMS key) grants permissions directly to Account A’s principal.

**Flow Example:**

```
Account A (Caller) → STS AssumeRole → Account B (Trusted Role) → Access AWS Resource
```

---

### 🧩 Example 1: Cross-Account Access Using IAM Role

#### 🔹 In **Account B (Resource Owner)**

Create an IAM role and trust **Account A**:

**Trust Policy:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::111111111111:root" },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

**Permissions Policy:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket", "s3:GetObject"],
      "Resource": ["arn:aws:s3:::shared-bucket", "arn:aws:s3:::shared-bucket/*"]
    }
  ]
}
```

**Create Role via CLI:**

```bash
aws iam create-role \
  --role-name CrossAccountS3AccessRole \
  --assume-role-policy-document file://trust-policy.json
```

---

#### 🔹 In **Account A (Requester)**

Use STS to assume the role:

```bash
aws sts assume-role \
  --role-arn arn:aws:iam::222222222222:role/CrossAccountS3AccessRole \
  --role-session-name DevOpsAccess
```

Output:

```json
{
  "Credentials": {
    "AccessKeyId": "ASIAEXAMPLE",
    "SecretAccessKey": "abc123example",
    "SessionToken": "FQoGZXIvYXdzE...",
    "Expiration": "2025-11-12T18:00:00Z"
  }
}
```

Then export the credentials:

```bash
export AWS_ACCESS_KEY_ID=ASIAEXAMPLE
export AWS_SECRET_ACCESS_KEY=abc123example
export AWS_SESSION_TOKEN=FQoGZXIvYXdzE...
```

✅ You now have **temporary access** to Account B resources.

---

### 🧩 Example 2: Cross-Account Access via Resource-Based Policy (S3)

**S3 Bucket Policy in Account B:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CrossAccountAccess",
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::111111111111:user/devops-user" },
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": ["arn:aws:s3:::shared-bucket", "arn:aws:s3:::shared-bucket/*"]
    }
  ]
}
```

📘 This grants **Account A’s user** access directly — no role assumption needed.

---

### 📋 Comparison: Role-Based vs Resource-Based

| Feature             | **Role-Based Access**      | **Resource-Based Policy**      |
| ------------------- | -------------------------- | ------------------------------ |
| **Where Defined**   | In IAM (Account B)         | On Resource (S3, SNS, etc.)    |
| **Credential Type** | Temporary (via STS)        | Existing principal credentials |
| **Best For**        | EC2, Lambda, CI/CD access  | S3, KMS, SQS, SNS sharing      |
| **Security Level**  | High (short-lived)         | Moderate                       |
| **Trust Direction** | Account A trusts Account B | Account B trusts Account A     |

---

### ✅ Best Practices

- Prefer **role-based access** for dynamic, secure cross-account usage.
- Use **STS temporary credentials** instead of static access keys.
- Limit permissions using **least privilege**.
- Add **conditions** (e.g., source account, IP, or VPC endpoint).
- Log and audit with **CloudTrail** to monitor cross-account usage.
- Use **AWS Organizations SCPs** to enforce boundaries centrally.

---

### 💡 In short

To grant **cross-account access**, either:
1️⃣ Create an IAM **role in the target account** and allow trusted accounts to **assume it**, or
2️⃣ Use **resource-based policies** for direct sharing (like S3).
✅ Always apply **least privilege** and use **STS temporary credentials** for secure, auditable access.

---

## Q: How Do You Audit IAM Permissions?

---

### 🧠 Overview

Auditing **IAM permissions** ensures that users, roles, and services in your AWS environment have only the **minimum access required** — a key part of implementing the **Principle of Least Privilege** and maintaining security compliance.
AWS provides several **native tools** for analyzing, reporting, and monitoring IAM permissions.

---

### ⚙️ Purpose / How It Works

IAM auditing involves:

- **Listing current permissions** (who can do what)
- **Identifying unused or over-privileged permissions**
- **Monitoring access patterns and anomalies**
- **Enforcing least privilege via reports and analyzers**

This is typically done using **IAM Access Analyzer**, **Credential Reports**, **Access Advisor**, and **CloudTrail** logs.

---

### 🧩 Core Tools for IAM Auditing

| Tool                      | Purpose                                                                         | Example Use                                    |
| ------------------------- | ------------------------------------------------------------------------------- | ---------------------------------------------- |
| **IAM Credential Report** | Lists all IAM users and their credential details (passwords, access keys, MFA). | Detect inactive users or old access keys.      |
| **IAM Access Analyzer**   | Identifies resources shared publicly or across accounts.                        | Find external access to S3, KMS, or IAM roles. |
| **IAM Access Advisor**    | Shows when services were last accessed by users or roles.                       | Remove unused service permissions.             |
| **AWS CloudTrail**        | Logs all IAM and API actions for auditing.                                      | Track who changed IAM policies.                |
| **AWS Config**            | Monitors compliance of IAM resources and policy changes.                        | Detect noncompliant roles (e.g., missing MFA). |
| **Security Hub**          | Aggregates IAM and access-related findings across accounts.                     | Centralized risk visibility.                   |

---

### 🧩 Example: Generate and Review IAM Credential Report

#### 🔹 Step 1: Generate Report

```bash
aws iam generate-credential-report
```

#### 🔹 Step 2: Retrieve Report

```bash
aws iam get-credential-report --query "Content" --output text | base64 --decode > credential-report.csv
```

📄 **Sample Output Columns:**

| User        | Password Enabled | MFA Active | Access Key 1 Active | Access Key 1 Last Used |
| ----------- | ---------------- | ---------- | ------------------- | ---------------------- |
| devops-user | TRUE             | TRUE       | TRUE                | 2025-11-10             |

➡️ Helps identify inactive credentials, missing MFA, or unused keys.

---

### 🧩 Example: Audit Permissions Using IAM Access Analyzer (CLI)

```bash
aws accessanalyzer create-analyzer --analyzer-name SecurityAnalyzer --type ACCOUNT
aws accessanalyzer list-findings --analyzer-name SecurityAnalyzer
```

Output shows **public or cross-account access** to resources (S3, KMS, IAM roles, etc.).

---

### 🧩 Example: Use Access Advisor via Console

1. Go to **IAM → Users → [username] → Access Advisor**.
2. Review **“Last Accessed”** timestamps for AWS services.
3. Remove unused service permissions from attached policies.

---

### 🧩 Example: Detect Over-Permissioned Roles via CloudTrail Query

Use **CloudTrail Lake** or **Athena** to query IAM events:

```sql
SELECT userIdentity.arn, eventName, eventSource
FROM cloudtrail_logs
WHERE eventSource = 'iam.amazonaws.com'
AND eventName LIKE '%Policy%'
ORDER BY eventTime DESC;
```

➡️ Identifies who modified IAM policies or roles recently.

---

### 📋 Recommended Audit Frequency

| Task                               | Frequency  | Tool                            |
| ---------------------------------- | ---------- | ------------------------------- |
| Review credential report           | Weekly     | `aws iam get-credential-report` |
| Analyze unused permissions         | Monthly    | IAM Access Advisor              |
| Detect public/cross-account access | Continuous | IAM Access Analyzer             |
| Review policy changes              | Continuous | AWS CloudTrail                  |
| Check compliance                   | Monthly    | AWS Config / Security Hub       |

---

### ✅ Best Practices

- Enable **IAM Access Analyzer** in all regions.
- Review **credential reports** and **Access Advisor data** regularly.
- Use **CloudTrail** to log and monitor IAM changes.
- Automate audits via **AWS Config rules** (e.g., MFA enforcement, key rotation).
- Remove **inactive users and access keys** immediately.
- Store audit logs securely in **S3 with encryption**.
- Use **AWS Organizations SCPs** to apply consistent access governance.

---

### 💡 In short

To audit IAM permissions:
1️⃣ Use **Credential Reports** for credential hygiene.
2️⃣ Use **Access Analyzer** and **Access Advisor** to detect risky or unused permissions.
3️⃣ Track all IAM changes via **CloudTrail** and **Config**.
✅ Together, these tools ensure secure, compliant, and least-privileged IAM access across AWS.

---

## Q: What is AWS STS (Security Token Service)?

---

### 🧠 Overview

**AWS Security Token Service (STS)** is an AWS service that issues **temporary, limited-privilege security credentials** for users or applications that need access to AWS resources — **without using long-term IAM credentials**.
These credentials are ideal for **federated access**, **cross-account roles**, and **temporary session-based authentication**.

---

### ⚙️ Purpose / How It Works

AWS STS enables secure, short-lived access to AWS resources by generating **temporary credentials** (Access Key ID, Secret Key, and Session Token).
These credentials are valid for a **specific duration** (from **15 minutes to 12 hours**).

**Flow Example:**

```
1️⃣ User or app requests temporary credentials from STS (AssumeRole or Federation)
2️⃣ STS authenticates and issues short-lived credentials
3️⃣ User/app uses these credentials to access AWS services
4️⃣ Credentials expire automatically after the session duration
```

---

### 📋 STS Credential Structure

Each STS response includes:

| Field               | Description                             |
| ------------------- | --------------------------------------- |
| **AccessKeyId**     | Temporary access key for authentication |
| **SecretAccessKey** | Temporary secret key                    |
| **SessionToken**    | Token required for session validation   |
| **Expiration**      | Timestamp when credentials expire       |

---

### 🧩 Common STS APIs

| API                             | Purpose                                                   | Example Use Case                      |
| ------------------------------- | --------------------------------------------------------- | ------------------------------------- |
| **`AssumeRole`**                | Assume an IAM role to get temporary credentials.          | Cross-account access, CI/CD pipelines |
| **`GetSessionToken`**           | Generate temporary credentials for an IAM user with MFA.  | MFA-based session login               |
| **`AssumeRoleWithSAML`**        | Assume a role using SAML-based federation.                | AD/SSO integration                    |
| **`AssumeRoleWithWebIdentity`** | Assume a role using a web identity (OIDC, Cognito, etc.). | EKS pods or mobile app access         |
| **`GetFederationToken`**        | Generate credentials for federated users.                 | Temporary access for external users   |

---

### 🧩 Example: Assume Role via CLI

```bash
aws sts assume-role \
  --role-arn arn:aws:iam::222222222222:role/CrossAccountRole \
  --role-session-name DevOpsSession
```

Output:

```json
{
  "Credentials": {
    "AccessKeyId": "ASIAEXAMPLE",
    "SecretAccessKey": "abc123EXAMPLE",
    "SessionToken": "IQoJb3JpZ2luX2VjEOr//////////",
    "Expiration": "2025-11-12T17:45:00Z"
  }
}
```

✅ _You can now use these temporary credentials to access AWS securely._

---

### 🧩 Example: MFA-Protected STS Token

```bash
aws sts get-session-token \
  --serial-number arn:aws:iam::123456789012:mfa/devops-user \
  --token-code 123456
```

This enforces MFA before generating temporary credentials.

---

### 📋 Key Differences: STS vs IAM Long-Term Credentials

| Feature           | **STS Credentials**                  | **IAM Credentials**       |
| ----------------- | ------------------------------------ | ------------------------- |
| **Type**          | Temporary                            | Permanent                 |
| **Duration**      | 15 mins – 12 hrs                     | Until rotated/revoked     |
| **Security Risk** | Low (auto-expire)                    | High (if leaked)          |
| **Use Case**      | Federated, cross-account, short-term | Long-term users or apps   |
| **Storage**       | In-memory or environment vars        | Saved in IAM user account |

---

### ✅ Best Practices

- Prefer **STS credentials** over static IAM keys for automation and CI/CD.
- Use **AssumeRole** for **cross-account** or **service-to-service access**.
- Always enforce **MFA** for `GetSessionToken`.
- Monitor usage with **CloudTrail (AssumeRole events)**.
- Use **least privilege policies** for roles assumed via STS.
- Rotate roles or sessions frequently; never cache expired tokens.

---

### 💡 In short

**AWS STS** issues **temporary credentials** to securely access AWS resources **without static IAM keys**.
✅ It’s used for **cross-account**, **federated**, and **MFA-based** access — making it a cornerstone of secure, short-lived authentication in AWS.

---

## Q: What is `AssumeRole` in AWS IAM?

---

### 🧠 Overview

**`AssumeRole`** is an AWS **Security Token Service (STS)** API that lets a **user, application, or AWS service** temporarily assume the permissions of another **IAM role**.
It’s the foundation for **cross-account access**, **temporary elevated privileges**, and **secure, short-term AWS operations** without using long-term credentials.

---

### ⚙️ Purpose / How It Works

When an entity calls `sts:AssumeRole`, AWS STS issues a set of **temporary security credentials** (AccessKeyId, SecretAccessKey, and SessionToken).
These credentials inherit the **permissions of the role** being assumed and **expire automatically** after a defined session duration (15 min – 12 hours).

**Flow Example:**

```
User/App → STS:AssumeRole → Temporary Credentials → Access AWS Resource
```

**Key Concept:**

- The **trust policy** on the role defines _who can assume it_.
- The **permissions policy** on the role defines _what actions they can perform_.

---

### 🧩 Example: Trust & Permission Policies

#### 🔹 **Trust Policy (who can assume)**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::111111111111:user/devops-user" },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

#### 🔹 **Permissions Policy (what can be done)**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket", "s3:GetObject"],
      "Resource": ["arn:aws:s3:::shared-bucket", "arn:aws:s3:::shared-bucket/*"]
    }
  ]
}
```

---

### 🧩 Example: Assume Role via AWS CLI

```bash
aws sts assume-role \
  --role-arn arn:aws:iam::222222222222:role/CrossAccountS3Role \
  --role-session-name DevOpsSession
```

**Output:**

```json
{
  "Credentials": {
    "AccessKeyId": "ASIAEXAMPLE",
    "SecretAccessKey": "abc123EXAMPLE",
    "SessionToken": "IQoJb3JpZ2luX2VjEOr//////////",
    "Expiration": "2025-11-12T18:00:00Z"
  }
}
```

Export these credentials:

```bash
export AWS_ACCESS_KEY_ID=ASIAEXAMPLE
export AWS_SECRET_ACCESS_KEY=abc123EXAMPLE
export AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEOr//////////
```

Now your CLI commands operate under the **assumed role’s permissions**.

---

### 📋 Common Use Cases

| Use Case                      | Description                                       | Example                                |
| ----------------------------- | ------------------------------------------------- | -------------------------------------- |
| **Cross-Account Access**      | Users in Account A access resources in Account B. | Assume `CrossAccountRole`              |
| **Service-to-Service Access** | EC2 instance assumes role to call S3 or DynamoDB. | `ec2.amazonaws.com` → `sts:AssumeRole` |
| **Federated Access**          | AD/SSO users assume roles via SAML or OIDC.       | Okta user assumes `FederatedAdminRole` |
| **Temporary Admin Access**    | Developer assumes admin role only when needed.    | Limited-duration privilege escalation  |
| **CI/CD Pipelines**           | Jenkins or GitHub Actions assume deployment role. | Secure AWS deployments                 |

---

### 📋 Key Parameters (CLI / API)

| Parameter             | Description                          | Example                                     |
| --------------------- | ------------------------------------ | ------------------------------------------- |
| `--role-arn`          | ARN of the role to assume            | `arn:aws:iam::222222222222:role/DeployRole` |
| `--role-session-name` | Session identifier (for logs/audit)  | `CICDPipelineSession`                       |
| `--duration-seconds`  | Session lifetime (900–43200 seconds) | `3600`                                      |
| `--serial-number`     | MFA device ARN (if MFA required)     | `arn:aws:iam::123456789012:mfa/devops-user` |
| `--token-code`        | MFA OTP                              | `123456`                                    |

---

### ✅ Best Practices

- Always apply **least privilege** in the role’s permission policy.
- Use **MFA** with `AssumeRole` for sensitive roles.
- **Log all AssumeRole events** via CloudTrail (`AssumeRole` API calls).
- Limit role assumption with **trust policy conditions** (e.g., source IP, account ID).
- Rotate and **limit session durations** (default 1 hour).
- Use **STS session tags** to track user identity and session context.

---

### 💡 In short

**`AssumeRole`** lets users or services temporarily take on the permissions of another role using **STS-issued short-term credentials**.
✅ It’s essential for **cross-account access**, **federation**, and **secure automation** — no static keys, no long-term exposure.

---

## Q: What is IAM Federation?

---

### 🧠 Overview

**IAM Federation** allows users from an **external identity system** (e.g., Active Directory, Okta, Azure AD, Google Workspace, or any SAML/OIDC provider) to **access AWS resources** **without creating IAM users** inside AWS.
It enables **Single Sign-On (SSO)** and secure, **temporary access** using AWS **STS (Security Token Service)**.

---

### ⚙️ Purpose / How It Works

Federation bridges **external identities → AWS roles** via **STS AssumeRole**.
When a federated user logs in, AWS issues **temporary credentials** instead of permanent IAM credentials.

**Flow Example:**

```
1️⃣ User authenticates with external IdP (e.g., Okta, AD, Azure AD)
2️⃣ IdP validates user → sends SAML/OIDC assertion to AWS STS
3️⃣ AWS STS issues temporary credentials via AssumeRoleWithSAML or AssumeRoleWithWebIdentity
4️⃣ User accesses AWS Management Console or CLI using those credentials
```

---

### 📋 Types of IAM Federation

| Type                        | Protocol    | Typical Source                                      | AWS STS API Used                     |
| --------------------------- | ----------- | --------------------------------------------------- | ------------------------------------ |
| **SAML 2.0 Federation**     | SAML        | Corporate Identity Providers (ADFS, Okta, Azure AD) | `AssumeRoleWithSAML`                 |
| **Web Identity Federation** | OIDC        | Public IdPs (Cognito, Google, Facebook, GitHub)     | `AssumeRoleWithWebIdentity`          |
| **AWS Cognito Federation**  | SAML / OIDC | Web & mobile app users                              | `GetId`, `GetCredentialsForIdentity` |
| **Custom Federation**       | Custom      | In-house IdPs via STS                               | `GetFederationToken`                 |

---

### 🧩 Example: SAML Federation (Corporate SSO)

#### 🔹 Step 1: IdP sends SAML Assertion

The external IdP (e.g., Okta) authenticates the user and sends a signed **SAML assertion** to AWS STS.

#### 🔹 Step 2: STS Exchanges for Temporary Credentials

```bash
aws sts assume-role-with-saml \
  --role-arn arn:aws:iam::222222222222:role/FederatedAdminRole \
  --principal-arn arn:aws:iam::222222222222:saml-provider/OktaProvider \
  --saml-assertion file://samlAssertion.txt
```

#### 🔹 Step 3: AWS STS Issues Temporary Credentials

Output includes:

```json
{
  "Credentials": {
    "AccessKeyId": "ASIAEXAMPLE",
    "SecretAccessKey": "abc123EXAMPLE",
    "SessionToken": "IQoJb3JpZ2luX2VjEOr//////////",
    "Expiration": "2025-11-12T17:00:00Z"
  }
}
```

---

### 🧩 Example: Web Identity Federation (e.g., OIDC for EKS Pods)

IAM Role with OIDC trust policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::123456789012:oidc-provider/oidc.eks.ap-south-1.amazonaws.com/id/EXAMPLE"
      },
      "Action": "sts:AssumeRoleWithWebIdentity"
    }
  ]
}
```

✅ _EKS Pods can assume this role using their OIDC token — no AWS credentials stored in the container._

---

### 📋 Key Benefits

| Benefit                             | Description                                         |
| ----------------------------------- | --------------------------------------------------- |
| **No local IAM users**              | Reduces credential sprawl and management overhead   |
| **Centralized identity management** | Manage users via your existing IdP (e.g., AD, Okta) |
| **Temporary credentials**           | Access expires automatically → lower risk           |
| **SSO support**                     | Seamless console or CLI login for enterprise users  |
| **Scalable and secure**             | Works for web, mobile, and workforce access         |

---

### ✅ Best Practices

- Always **enforce MFA** through your IdP.
- Limit **session duration** for federated users (e.g., 1 hour).
- Use **tags or session policies** to track identity and restrict access.
- **Monitor AssumeRoleWithSAML/WebIdentity** events using CloudTrail.
- Use **AWS IAM Identity Center (formerly SSO)** for centralized federation across accounts.
- Integrate **AWS Organizations + Identity Center** for enterprise-scale SSO.

---

### 💡 In short

**IAM Federation** lets external users (corporate or web app) **access AWS securely** using their existing credentials — no IAM user creation needed.
✅ It leverages **STS** and protocols like **SAML** or **OIDC** to provide **temporary, federated access** with centralized authentication and minimal credential risk.

---

## Q: What is an IAM Permission Boundary?

---

### 🧠 Overview

An **IAM Permission Boundary** is an **advanced IAM feature** that defines the **maximum permissions** an IAM user or role can have — even if additional policies grant broader access.
Think of it as a **“guardrail”** or **upper limit** that restricts what a user or role can do, regardless of other attached policies.

---

### ⚙️ Purpose / How It Works

- Normally, IAM permissions come from **attached policies** (identity or managed).
- A **permission boundary** sets a **limit** on those permissions.
- AWS evaluates _both_:

  1. The **user’s/role’s policies** (what’s allowed).
  2. The **permission boundary** (the ceiling).

- The **effective permissions** = Intersection of the two.

**Formula:**

```
Effective Permission = (Identity Policy) ∩ (Permission Boundary)
```

If a user’s policy allows `s3:*`, but the permission boundary allows only `s3:GetObject`,
➡️ The user can perform **only `s3:GetObject`**.

---

### 🧩 Example: Permission Boundary JSON Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": "*"
    }
  ]
}
```

📘 This boundary restricts the user to **read-only access** on S3, even if their IAM policy includes `s3:PutObject` or `s3:DeleteObject`.

---

### 🧩 Example: Apply Permission Boundary to a Role (CLI)

```bash
aws iam create-policy \
  --policy-name ReadOnlyBoundary \
  --policy-document file://s3-readonly-boundary.json

aws iam create-role \
  --role-name DevOpsReadOnlyRole \
  --assume-role-policy-document file://trust-policy.json \
  --permissions-boundary arn:aws:iam::123456789012:policy/ReadOnlyBoundary
```

✅ The role now **cannot exceed** the permissions defined in `ReadOnlyBoundary`, regardless of what other policies are attached.

---

### 📋 Permission Boundary vs Policy

| Feature        | **Permission Boundary**                        | **IAM Policy**                   |
| -------------- | ---------------------------------------------- | -------------------------------- |
| **Purpose**    | Limits maximum allowed actions                 | Grants specific permissions      |
| **Scope**      | Applies to IAM user or role                    | Attached to user, group, or role |
| **Evaluation** | Acts as an upper limit                         | Directly defines access          |
| **Created By** | Administrator (security control)               | IAM admin or service owner       |
| **Use Case**   | Delegated administration, sandbox environments | Standard access control          |

---

### 📋 Common Use Cases

| Scenario                       | Purpose                                                                                   |
| ------------------------------ | ----------------------------------------------------------------------------------------- |
| **Delegated Administration**   | Allow developers to create IAM roles, but restrict what permissions those roles can have. |
| **Sandbox/Dev Accounts**       | Prevent developers from escalating privileges or accessing production resources.          |
| **Multi-account Environments** | Apply consistent permission ceilings across teams using AWS Organizations.                |
| **Security Governance**        | Enforce limits on roles created by CI/CD or infrastructure automation tools.              |

---

### ✅ Best Practices

- Always **attach a permission boundary** when allowing IAM role or policy creation by non-admin users.
- Use **managed policies** as reusable permission boundaries.
- Combine boundaries with **IAM Access Analyzer** for compliance checks.
- Apply **least privilege principle** even within the boundary.
- Track boundary usage with **AWS Config rule: iam-permissions-boundary-attached**.

---

### 💡 In short

An **IAM Permission Boundary** is a **limit** on the maximum permissions an IAM user or role can have.
✅ It’s ideal for **delegated admin control** — ensuring no entity can exceed the permissions explicitly approved by your security team.

---

## Q: What is an IAM Policy Condition?

---

### 🧠 Overview

An **IAM Policy Condition** is an **optional key-value filter** in an AWS IAM policy that defines **when or under what circumstances** a policy statement applies.
It adds **context-based control** — allowing fine-grained access decisions based on factors like **IP address, time, MFA, tags, or resource attributes**.

---

### ⚙️ Purpose / How It Works

- Each IAM policy statement can include a **`Condition`** block.
- Conditions are evaluated **after** `Effect`, `Action`, and `Resource`.
- They use **condition operators** (e.g., `StringEquals`, `Bool`, `IpAddress`) and **condition keys** (e.g., `aws:SourceIp`, `aws:MultiFactorAuthPresent`).
- The policy statement is effective **only if the condition evaluates to true**.

**Flow Example:**

```
If (Condition == true) → Apply Effect (Allow/Deny)
Else → Skip Statement
```

---

### 🧩 Example: Enforce Access from Specific IP Range

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "203.0.113.0/24"
        }
      }
    }
  ]
}
```

✅ _Allows access to S3 only from the given corporate IP range._

---

### 🧩 Example: Require MFA for Access

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:StartInstances",
      "Resource": "*",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
```

✅ _Grants EC2 start permissions only if the user has MFA enabled._

---

### 🧩 Example: Tag-Based Access Control

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:TerminateInstances",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/Environment": "Dev"
        }
      }
    }
  ]
}
```

✅ _Allows terminating EC2 instances only if they are tagged `Environment=Dev`._

---

### 📋 Common Condition Operators

| Operator          | Description             | Example                                     |
| ----------------- | ----------------------- | ------------------------------------------- |
| `StringEquals`    | Compares string values  | `"aws:username": "vasu"`                    |
| `StringLike`      | Allows wildcards        | `"s3:prefix": "project/*"`                  |
| `Bool`            | Checks boolean values   | `"aws:MultiFactorAuthPresent": "true"`      |
| `NumericLessThan` | Compares numeric values | `"s3:max-keys": "10"`                       |
| `IpAddress`       | Matches IP ranges       | `"aws:SourceIp": "203.0.113.0/24"`          |
| `DateGreaterThan` | Checks date/time        | `"aws:CurrentTime": "2025-11-12T09:00:00Z"` |

---

### 📋 Common Global Condition Keys

| Key                          | Description                         |
| ---------------------------- | ----------------------------------- |
| `aws:PrincipalTag`           | Filters by IAM principal tags       |
| `aws:ResourceTag`            | Filters by resource tags            |
| `aws:RequestedRegion`        | Restricts AWS Region usage          |
| `aws:SourceIp`               | Filters by source IP or CIDR        |
| `aws:MultiFactorAuthPresent` | Ensures MFA-enabled access          |
| `aws:CurrentTime`            | Restricts access by time window     |
| `aws:SecureTransport`        | Enforces HTTPS-only requests        |
| `aws:SourceVpc`              | Restricts access from specific VPCs |

---

### ✅ Best Practices

- Always use **conditions** to add **context-aware restrictions**.
- Enforce **MFA** and **HTTPS-only access** (`aws:SecureTransport`).
- Combine **tag-based** and **IP-based** conditions for multi-layered security.
- Apply **region-based restrictions** to limit unauthorized region usage.
- Use **`BoolIfExists`** to avoid policy failures if a key is missing.
- Test conditions with **IAM Policy Simulator** before deployment.

---

### 💡 In short

An **IAM Policy Condition** adds **contextual control** to your IAM permissions — defining _when, where, or how_ an action is allowed.
✅ It enables **fine-grained, conditional access** based on attributes like **MFA, IP, time, or tags**, making your IAM policies far more secure and flexible.

---

## Q: What’s the Difference Between Identity-Based and Resource-Based Policies?

---

### 🧠 Overview

In AWS IAM, **identity-based** and **resource-based** policies are two fundamental ways to **control access** to AWS resources.
They differ mainly in **where** they are attached and **who** they apply to — one defines **what a user can do**, and the other defines **who can access a resource**.

---

### ⚙️ Purpose / How It Works

- **Identity-based policies** are attached to IAM entities (users, groups, roles) and define **what actions they can perform** on which resources.
- **Resource-based policies** are attached directly to AWS resources and define **who (principal)** can access that resource and **what actions** they can take.

Both are evaluated together during authorization, along with permission boundaries, SCPs, and session policies.

---

### 📋 Comparison Table

| Feature                            | **Identity-Based Policy**              | **Resource-Based Policy**                          |
| ---------------------------------- | -------------------------------------- | -------------------------------------------------- |
| **Attached To**                    | IAM user, group, or role               | AWS resource (e.g., S3 bucket, KMS key, SQS queue) |
| **Defines**                        | What the identity can do (actions)     | Who can access the resource and how                |
| **Specifies Principal?**           | ❌ No (applies to the identity itself) | ✅ Yes (explicitly lists allowed principals)       |
| **Common Use Cases**               | User, role, or service permissions     | Cross-account or public access control             |
| **Cross-Account Access**           | Requires `AssumeRole` via STS          | Can directly allow access from another account     |
| **Evaluation Location**            | IAM system                             | Resource service (e.g., S3, KMS)                   |
| **Supports Deny Rules**            | ✅ Yes                                 | ✅ Yes                                             |
| **Example Services Supporting It** | All IAM entities                       | S3, KMS, SNS, SQS, Lambda, Secrets Manager         |
| **Example Focus**                  | _“What can Vasu do?”_                  | _“Who can access my S3 bucket?”_                   |

---

### 🧩 Example 1: Identity-Based Policy (attached to IAM user)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": ["arn:aws:s3:::project-logs", "arn:aws:s3:::project-logs/*"]
    }
  ]
}
```

📘 _Allows the IAM user to read from the S3 bucket._

---

### 🧩 Example 2: Resource-Based Policy (attached to S3 bucket)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::111111111111:user/devops-user" },
      "Action": ["s3:GetObject"],
      "Resource": ["arn:aws:s3:::project-logs/*"]
    }
  ]
}
```

📘 _Allows a user in another AWS account to access this bucket’s objects._

---

### 📋 How AWS Evaluates Both Together

| Step | Policy Type               | Description                                                                               |
| ---- | ------------------------- | ----------------------------------------------------------------------------------------- |
| 1️⃣   | Identity-Based Policy     | Checks what the user/role is allowed to do.                                               |
| 2️⃣   | Resource-Based Policy     | Checks if the resource explicitly allows the principal.                                   |
| 3️⃣   | Permission Boundary / SCP | Restricts max allowed permissions.                                                        |
| 4️⃣   | Final Decision            | Access is allowed **only if at least one Allow** exists and **no explicit Deny** applies. |

---

### ✅ Best Practices

- Use **identity-based policies** for in-account access management.
- Use **resource-based policies** for **cross-account or public access**.
- Combine both for **defense-in-depth** access control.
- Always add **explicit Deny** rules for sensitive resources.
- Audit resource-based policies using **IAM Access Analyzer** for unintended exposure.
- Avoid using `"Principal": "*"`, unless the resource truly needs public access (e.g., a static website S3 bucket).

---

### 💡 In short

- **Identity-Based Policy:** Attached to IAM entities → _defines what the identity can do._
- **Resource-Based Policy:** Attached to AWS resources → _defines who can access the resource and what they can do._
  ✅ Use identity-based for internal access, and resource-based for **cross-account or external sharing** — together they form AWS’s core access control model.

---

## Q: What are IAM Tags Used For?

---

### 🧠 Overview

**IAM Tags** are **key–value pairs** that you can attach to **IAM users, roles, groups, and policies** to organize, manage, and control access within AWS.
They help with **automation, governance, and fine-grained permissions** by providing **contextual metadata** (e.g., department, environment, project).

---

### ⚙️ Purpose / How It Works

Tags are **metadata attributes** (like `Environment=Dev` or `Team=DevOps`) that AWS IAM uses for:

- **Access control** → define policies that allow or deny actions based on tags.
- **Cost allocation** → track costs by team, project, or environment.
- **Automation & compliance** → identify and manage IAM entities programmatically.

When you tag IAM resources, the tags can be evaluated by IAM **Condition keys** such as `aws:PrincipalTag` and `aws:ResourceTag`.

---

### 🧩 Example: Tag-Based Access Control

#### 🔹 Tag a Role

```bash
aws iam tag-role \
  --role-name DevOpsEngineerRole \
  --tags Key=Environment,Value=Dev Key=Team,Value=CI-CD
```

#### 🔹 IAM Policy Using Tags

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:PrincipalTag/Environment": "Dev"
        }
      }
    }
  ]
}
```

✅ _Allows S3 access only if the role or user has the tag `Environment=Dev`._

---

### 📋 IAM Tag Types

| Tag Type          | Description                                                    | Example                        |
| ----------------- | -------------------------------------------------------------- | ------------------------------ |
| **Principal Tag** | Tags attached to IAM users or roles (evaluated in conditions). | `aws:PrincipalTag/Department`  |
| **Resource Tag**  | Tags attached to AWS resources like S3, EC2, Lambda, etc.      | `aws:ResourceTag/Project`      |
| **Request Tag**   | Temporary tags passed in an API request during role creation.  | `aws:RequestTag/Environment`   |
| **Tag Keys**      | Custom key identifiers for tags.                               | `Environment`, `Team`, `Owner` |

---

### 📋 Common Condition Keys for Tag-Based Policies

| Condition Key          | Description                                     | Example Use                                           |
| ---------------------- | ----------------------------------------------- | ----------------------------------------------------- |
| `aws:PrincipalTag/key` | Checks a tag on the IAM principal (user/role).  | Restrict access to resources based on user’s team.    |
| `aws:ResourceTag/key`  | Checks a tag on the resource being accessed.    | Allow EC2 termination only for tagged instances.      |
| `aws:RequestTag/key`   | Applies when creating or tagging new resources. | Enforce environment tagging during resource creation. |
| `aws:TagKeys`          | Restricts which tags can be attached.           | Limit who can assign cost-allocation tags.            |

---

### 🧩 Example: Enforce Tagging Policy for Resource Creation

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "ec2:RunInstances",
      "Resource": "*",
      "Condition": {
        "Null": {
          "aws:RequestTag/Environment": "true"
        }
      }
    }
  ]
}
```

✅ _Denies EC2 instance creation unless the “Environment” tag is provided._

---

### ✅ Best Practices

- Use **consistent tag keys** across IAM and AWS resources (e.g., `Environment`, `CostCenter`, `Owner`).
- Combine **Principal and Resource tags** for dynamic access control.
- Use tags for **cost allocation reports** and **compliance tracking**.
- Restrict **tag modification** using IAM policies to prevent privilege escalation.
- Automate tagging via **AWS Organizations Tag Policies** or **Service Control Policies (SCPs)**.

---

### 💡 In short

**IAM Tags** add flexible metadata to IAM users, roles, groups, and policies.
✅ They’re used for **fine-grained access control**, **cost tracking**, and **automated management** — enabling scalable, tag-driven governance across AWS environments.

---

## Q: What is an IAM Credential Report?

---

### 🧠 Overview

An **IAM Credential Report** is a **security audit tool** in AWS IAM that provides a **CSV report of all IAM users** and the **status of their credentials** — including passwords, access keys, MFA devices, and certificate usage.  
It helps you **identify security risks** like inactive users, old access keys, missing MFA, or expired passwords.

---

### ⚙️ Purpose / How It Works

The Credential Report provides **account-wide visibility** into IAM credential hygiene.  
It is generated by IAM on demand and contains one row per IAM user with detailed credential metadata.

**Flow:**

```
1️⃣ Admin requests report →
2️⃣ IAM generates it →
3️⃣ You download and review for compliance or automation →
4️⃣ Fix any users violating security policies
```

---

### 🧩 Example: Generate and Download Report (CLI)

#### 🔹 Step 1: Generate Report

```bash
aws iam generate-credential-report
```

#### 🔹 Step 2: Download Report

```bash
aws iam get-credential-report --query "Content" --output text | base64 --decode > credential-report.csv
```

#### 🔹 Step 3: View in CSV Format

Example output (simplified):

| user        | arn                                        | password_enabled | password_last_used | mfa_active | access_key_1_active | access_key_1_last_used_date |
| ----------- | ------------------------------------------ | ---------------- | ------------------ | ---------- | ------------------- | --------------------------- |
| devops-user | arn:aws:iam::123456789012:user/devops-user | TRUE             | 2025-11-10         | TRUE       | TRUE                | 2025-11-11                  |
| old-user    | arn:aws:iam::123456789012:user/old-user    | FALSE            | N/A                | FALSE      | FALSE               | N/A                         |

✅ _Helps identify inactive or noncompliant users instantly._

---

### 📋 Key Columns in Credential Report

| Field                                         | Description                            |
| --------------------------------------------- | -------------------------------------- |
| **user**                                      | IAM username                           |
| **arn**                                       | ARN of the IAM user                    |
| **user_creation_time**                        | When the IAM user was created          |
| **password_enabled**                          | Whether a console password is set      |
| **password_last_used**                        | When the password was last used        |
| **password_last_changed**                     | When the password was last changed     |
| **mfa_active**                                | Whether MFA is enabled                 |
| **access_key_1_active / access_key_2_active** | Whether access keys are active         |
| **access_key_1_last_used_date**               | When the key was last used             |
| **cert_1_active**                             | Whether an X.509 certificate is active |
| **password_next_rotation**                    | When the password must be rotated      |

---

### 🧩 Example Use Case – Detect Inactive Keys

You can easily parse and identify old or inactive credentials:

```bash
cat credential-report.csv | grep "FALSE"
```

📘 _Shows users without MFA, inactive passwords, or disabled keys._

---

### 📋 Credential Report Access Details

| Property             | Description                                                                                       |
| -------------------- | ------------------------------------------------------------------------------------------------- |
| **Available To**     | IAM users and roles with `iam:GenerateCredentialReport` and `iam:GetCredentialReport` permissions |
| **Format**           | Base64-encoded CSV                                                                                |
| **Refresh Interval** | ~4 hours (AWS caches the latest report)                                                           |
| **Scope**            | Account-wide — includes all IAM users                                                             |

---

### ✅ Best Practices

- Generate and **review credential reports weekly or monthly**.
- Ensure **MFA is active** for all console users.
- Rotate access keys every **90 days**.
- Remove **inactive IAM users** or credentials immediately.
- Automate checks using **AWS Config**, **Security Hub**, or custom Lambda functions.
- Store reports securely (e.g., encrypted S3 bucket) for audit tracking.

---

### 💡 In short

An **IAM Credential Report** is a **CSV audit file** listing all IAM users and their credential states — passwords, keys, and MFA.  
✅ Use it regularly to **enforce security hygiene**, **detect unused credentials**, and **maintain compliance** across your AWS accounts.

---

## Q: What is AWS Organizations SCP (Service Control Policy)?

---

### 🧠 Overview

An **AWS Service Control Policy (SCP)** is a **policy type in AWS Organizations** that defines **permission boundaries** for **member accounts** within an organization.
SCPs **do not grant permissions** — instead, they **restrict the maximum available permissions** that IAM users, roles, and groups in those accounts can have, even if their IAM policies allow more.

---

### ⚙️ Purpose / How It Works

- SCPs act as **guardrails** at the **organization or OU (Organizational Unit)** level.
- They **filter permissions** granted by IAM policies — an **implicit deny** applies if an action is not explicitly allowed in the SCP.
- SCPs apply to **all IAM entities (users, roles)** in the target accounts, including the root user (except in the management account).

**Evaluation Logic:**

```
Effective Permissions = IAM Policy Allow ∩ SCP Allow
```

So, even if an IAM policy allows `ec2:TerminateInstances`,
if the SCP doesn’t include that action → ❌ it’s denied.

---

### 📋 SCP Characteristics

| Attribute                 | Description                                               |
| ------------------------- | --------------------------------------------------------- |
| **Scope**                 | Organization root, OU, or individual AWS account          |
| **Applies To**            | All IAM entities within target accounts                   |
| **Cannot Grant Access**   | SCPs only restrict; they never allow access by themselves |
| **Managed In**            | AWS Organizations console or API                          |
| **Default Behavior**      | Implicit deny (if not allowed, it’s denied)               |
| **Supported Policy Type** | `"SERVICE_CONTROL_POLICY"`                                |
| **Evaluation Order**      | SCP → IAM Policy → Resource Policy                        |

---

### 🧩 Example: Deny All Actions Except S3 and CloudWatch

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowOnlyS3AndCloudWatch",
      "Effect": "Allow",
      "Action": ["s3:*", "cloudwatch:*"],
      "Resource": "*"
    }
  ]
}
```

✅ _Attached to a dev OU — this SCP restricts all actions except S3 and CloudWatch._

---

### 🧩 Example: Deny EC2 Deletion Across All Accounts

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyEC2Termination",
      "Effect": "Deny",
      "Action": "ec2:TerminateInstances",
      "Resource": "*"
    }
  ]
}
```

✅ _Prevents anyone from terminating EC2 instances, regardless of IAM permissions._

---

### 📋 SCP vs IAM Policy

| Feature                | **SCP (Service Control Policy)**     | **IAM Policy**                  |
| ---------------------- | ------------------------------------ | ------------------------------- |
| **Attached To**        | Org root, OU, or AWS account         | IAM user, group, or role        |
| **Purpose**            | Restrict permissions across accounts | Grant permissions to identities |
| **Grants Access?**     | ❌ No                                | ✅ Yes                          |
| **Affects Root User?** | ✅ Yes (in member accounts)          | ❌ No                           |
| **Evaluation Level**   | Organization-wide                    | Account-level                   |
| **Best For**           | Central governance and compliance    | Local identity access control   |

---

### 📋 Common SCP Use Cases

| Scenario                      | Example Policy                                     |
| ----------------------------- | -------------------------------------------------- |
| **Restrict region usage**     | Deny actions outside `ap-south-1`                  |
| **Block specific services**   | Deny `iam:*`, `ec2:*` for sandbox accounts         |
| **Prevent data exfiltration** | Deny access to `s3:PutObject` for external buckets |
| **Mandatory tagging**         | Require tags on resource creation                  |
| **Enforce least privilege**   | Limit maximum permissions across business units    |

---

### 🧩 Example: Deny Usage of Non-Approved Regions

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowApprovedRegionsOnly",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": ["ap-south-1", "us-east-1"]
        }
      }
    }
  ]
}
```

✅ _Prevents resource creation in unapproved AWS regions._

---

### ✅ Best Practices

- Always **test SCPs** in a non-production OU first.
- Use **whitelist-based SCPs** (explicit allow) for tighter control.
- Combine SCPs with **IAM Permission Boundaries** for multi-layered governance.
- Monitor SCP impact with **CloudTrail** and **Access Analyzer**.
- Don’t apply restrictive SCPs to the **management account** — it can block administrative functions.
- Maintain **centralized SCP templates** for different OUs (e.g., Prod, Dev, Sandbox).

---

### 💡 In short

An **SCP (Service Control Policy)** is an **AWS Organizations guardrail** that **limits the maximum permissions** an account or OU can have.
✅ SCPs enforce **organization-wide least privilege**, preventing unauthorized actions even if local IAM policies allow them — making them critical for multi-account security governance.

---

## Q: How Can You Limit API Calls per IAM Role?

---

### 🧠 Overview

AWS **does not natively throttle API requests per IAM role** directly, but you can **limit or control API usage** using a combination of **IAM conditions, AWS Service Quotas, CloudWatch alarms, and WAF/Organization policies**.
The idea is to **restrict when, how, and how often** a role can make API calls to AWS services.

---

### ⚙️ Purpose / How It Works

You can control API calls from a role by combining multiple AWS mechanisms:

- **IAM conditions** → restrict _who_, _when_, _where_, and _how_ APIs are called.
- **Service Quotas / Rate limits** → cap API frequency for specific services.
- **CloudWatch + EventBridge monitoring** → detect excessive API activity.
- **AWS WAF / Lambda / SCPs** → block, throttle, or alert on excessive calls.

There’s no single “rate limit per role” feature, but you can **simulate it using policies and automation**.

---

### 🧩 Option 1: IAM Policy with Time-Based Conditions

Limit when a role can call APIs (e.g., only during working hours).

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "DateNotBetween": {
          "aws:CurrentTime": ["2025-11-12T05:00:00Z", "2025-11-12T17:00:00Z"]
        }
      }
    }
  ]
}
```

✅ _Prevents API calls outside 10 AM–10 PM IST._

---

### 🧩 Option 2: Use AWS Organizations SCPs

Block or limit APIs organization-wide, per account or OU.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": ["ec2:RunInstances"],
      "Resource": "*",
      "Condition": {
        "NumericGreaterThan": { "aws:RequestTag/InstanceCount": "5" }
      }
    }
  ]
}
```

✅ _Can simulate quota enforcement using tagging conventions._

---

### 🧩 Option 3: Service Quotas (Indirect API Limiting)

AWS **Service Quotas** let you restrict service-level operations (e.g., max EC2 instances or Lambda concurrency).
This effectively limits API impact per role or account.

```bash
aws service-quotas list-service-quotas --service-code ec2
```

Example:
Limit the number of EC2 instances → indirectly limits `RunInstances` API frequency.

---

### 🧩 Option 4: Monitor & React with CloudWatch + Lambda

You can **track API calls per role** using CloudTrail logs and **throttle reactively**.

**CloudWatch Metric Filter:**

```bash
{ $.userIdentity.sessionContext.sessionIssuer.userName = "DevOpsRole" }
```

**EventBridge Rule → Lambda Action:**

```python
# Pseudo-code: disable excessive callers
if api_call_count(role) > 1000:
    iam.update_assume_role_policy(RoleName="DevOpsRole", PolicyDocument="deny-all")
```

✅ _Automatically throttles a role if it exceeds API thresholds._

---

### 🧩 Option 5: Use AWS WAF or API Gateway (for custom APIs)

If your AWS APIs are exposed via **API Gateway**, use **AWS WAF** or **API Gateway Usage Plans** to rate-limit specific callers (roles, tokens, or users).

```bash
aws apigateway create-usage-plan \
  --name "DevOpsRoleLimit" \
  --throttle burstLimit=10 rateLimit=100
```

✅ _Restricts role-based API traffic to 100 requests per second._

---

### 📋 Summary of Control Mechanisms

| Method                  | Description                                      | Use Case                                     |
| ----------------------- | ------------------------------------------------ | -------------------------------------------- |
| **IAM Conditions**      | Context-based restrictions (IP, time, MFA, tags) | Restrict when/how APIs are called            |
| **SCPs**                | Organizational policy limits                     | Enforce org-wide or OU-specific restrictions |
| **Service Quotas**      | Hard service limits                              | Cap per-service API impact                   |
| **CloudWatch + Lambda** | Reactive throttling                              | Block excessive calls automatically          |
| **API Gateway / WAF**   | Direct rate limiting                             | Custom APIs, per-client throttling           |

---

### ✅ Best Practices

- Use **CloudTrail + CloudWatch dashboards** to monitor per-role API usage.
- Define **SCPs** and **IAM policies** to prevent resource abuse.
- Combine **Service Quotas** + **AWS Budgets** for cost and usage control.
- Rotate or disable roles showing suspicious API spikes.
- Enforce **MFA and IP-based access** for sensitive roles.

---

### 💡 In short

AWS doesn’t have a direct “per-role API rate limit,” but you can enforce it through:
✅ **IAM conditions**, **SCPs**, **Service Quotas**, and **CloudWatch-based automation** — giving you **fine-grained, controlled API governance** across IAM roles and accounts.

---

# Scenario Questions

## Q: Need EC2 to access S3 without keys

---

### 🧠 Overview

Give an EC2 instance **keyless, secure access** to S3 by attaching an **IAM role** (via an instance profile). The instance gets **temporary credentials** from the Instance Metadata Service (IMDSv2) so you **never store static access keys** on the host.

---

### ⚙️ Purpose / How it works

- Create an **IAM role** with a trust policy for `ec2.amazonaws.com`.
- Attach a **permission policy** (least-privilege) that allows the needed S3 actions on specific bucket ARNs.
- Put the role into an **instance profile** and attach it to the EC2 instance (at launch or to a running instance).
- EC2 uses **IMDSv2** to retrieve short-lived credentials (AWS SDK/CLI auto-uses them).

Flow:
`EC2` → IMDSv2 → temporary creds (STS) → S3 API calls

---

### 🧩 Examples / Commands / Config snippets

#### 1) Minimal S3 permission policy (restrict to one bucket)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowSpecificBucketAccess",
      "Effect": "Allow",
      "Action": ["s3:ListBucket", "s3:GetObject", "s3:PutObject"],
      "Resource": ["arn:aws:s3:::my-app-bucket", "arn:aws:s3:::my-app-bucket/*"]
    }
  ]
}
```

#### 2) Create role and attach policy (AWS CLI)

```bash
# 1) create role with EC2 trust
aws iam create-role \
  --role-name EC2S3Role \
  --assume-role-policy-document '{
    "Version":"2012-10-17",
    "Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]
  }'

# 2) create policy (or use existing)
aws iam create-policy --policy-name EC2S3Policy --policy-document file://s3-policy.json

# 3) attach policy to role
aws iam attach-role-policy --role-name EC2S3Role --policy-arn arn:aws:iam::<ACCOUNT_ID>:policy/EC2S3Policy

# 4) create instance profile and add role
aws iam create-instance-profile --instance-profile-name EC2S3Profile
aws iam add-role-to-instance-profile --instance-profile-name EC2S3Profile --role-name EC2S3Role
```

#### 3) Attach to a **running** EC2 instance (CLI)

```bash
aws ec2 associate-iam-instance-profile \
  --instance-id i-0abc1234def567890 \
  --iam-instance-profile Name=EC2S3Profile
```

#### 4) Attach when launching via CLI

```bash
aws ec2 run-instances \
  --image-id ami-xxxx \
  --count 1 \
  --instance-type t3.medium \
  --iam-instance-profile Name=EC2S3Profile \
  --key-name mykey \
  --subnet-id subnet-xxx
```

#### 5) Verify from inside EC2 (use IMDSv2)

```bash
# get role name from IMDS
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
ROLE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/iam/security-credentials/)

# show temporary creds (do NOT store)
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/iam/security-credentials/$ROLE

# test S3 access (aws cli must be installed; SDKs auto-pick up creds)
aws s3 ls s3://my-app-bucket
aws s3 cp /tmp/testfile s3://my-app-bucket/testfile
```

#### 6) Terraform snippet (role + instance profile)

```hcl
resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2_s3_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Effect="Allow", Principal={ Service="ec2.amazonaws.com" }, Action="sts:AssumeRole" }]
  })
}

resource "aws_iam_policy" "s3_policy" {
  name   = "ec2_s3_policy"
  policy = file("s3-policy.json")
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_instance_profile" "profile" {
  name = "ec2_s3_profile"
  role = aws_iam_role.ec2_s3_role.name
}

resource "aws_instance" "app" {
  ami                    = "ami-xxxx"
  instance_type          = "t3.medium"
  iam_instance_profile   = aws_iam_instance_profile.profile.name
  # ...
}
```

---

### 📋 Quick differences & notes

| Topic                       | Recommendation                                                                                                       |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| **Least privilege**         | Scope policy to specific bucket/prefix & exact actions.                                                              |
| **IMDS**                    | Enforce **IMDSv2** (`--instance-metadata-options HttpTokens=required` when launching).                               |
| **Static keys**             | **Never** store access keys on EC2 when using instance roles.                                                        |
| **Cross-account S3 access** | Prefer role assumption + bucket policy allowing the role’s principal, or use resource-based bucket policy as needed. |
| **Credential visibility**   | Temporary creds are available via IMDS only — rotate automatically by STS.                                           |

---

### ✅ Best Practices

- Use **fine-grained S3 policies** (bucket + prefix).
- Enforce **IMDSv2** to prevent SSRF credential theft.
- Use **VPC endpoints (Gateway VPC Endpoint for S3)** to keep S3 traffic inside AWS network.
- Monitor access via **CloudTrail** and S3 access logs.
- Avoid broad managed policies (like `AmazonS3FullAccess`) in production — create scoped customer-managed policies.

---

### 💡 In short

Attach an **IAM role (instance profile)** to the EC2 instance so it gets **temporary credentials from IMDSv2** and can access S3 without long-term keys.
Scope the role’s policy to the specific bucket/prefix and use VPC endpoints + CloudTrail for secure, auditable access.

---

## Q: Developer used root account for API — what to do?

---

### 🧠 Overview

Using the **root account** for programmatic/API access is a critical security risk. Immediate containment, credential removal, audit, and migration to least-privilege IAM roles/users are required. Below is a compact, actionable incident-response checklist with CLI/console commands and remediation steps.

---

### ⚙️ Purpose / How it works

- **Contain**: remove/disable root programmatic access and rotate credentials.
- **Audit**: find what was done using CloudTrail, credential reports and access logs.
- **Remediate**: create proper IAM identities/roles, update apps to use roles (no keys), and enforce policies (MFA, least privilege).
- **Prevent**: enforce guards (no root for day-to-day use, SCPs, monitoring, automation).

---

### 🧩 Immediate Actions (Containment) — do **now**

1. **Revoke root programmatic credentials**

   - Console (recommended): Sign in as root → **My Security Credentials** → **Access keys** → Deactivate/Delete keys.
   - CLI (if you have root creds):

     ```bash
     aws iam delete-access-key --access-key-id <ROOT_ACCESS_KEY_ID> --user-name root
     ```

   - If you cannot access root console, escalate to account owner/AWS support.

2. **Rotate root console password & enable MFA**

   - Console: Root account → **Security Credentials** → change password → assign virtual or hardware MFA.
   - CLI to check MFA devices (if using credentials): `aws iam list-mfa-devices --user-name <username>` (root MFA shown only in console).

3. **Stop any running automated processes using root keys**

   - Find systems using the key (CI jobs, servers, scripts) and disable them or update to temporary creds/roles.

4. **Create an admin IAM user / role for recovery**

   ```bash
   # Create admin user and attach AdministratorAccess (temporary for recovery)
   aws iam create-user --user-name emergency-admin
   aws iam attach-user-policy --user-name emergency-admin --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
   aws iam create-login-profile --user-name emergency-admin --password 'TempP@ssw0rd!' --password-reset-required
   ```

   - Immediately enable MFA for this IAM admin.

---

### 🧩 Investigation (Audit) — next 30–60 minutes

- **Generate credential report**

  ```bash
  aws iam generate-credential-report
  aws iam get-credential-report --query "Content" --output text | base64 --decode > credential-report.csv
  ```

- **Search CloudTrail for root activity / specific root access key**

  ```bash
  # If you have the root access key ID that was used:
  aws cloudtrail lookup-events --lookup-attributes AttributeKey=AccessKeyId,AttributeValue=<ROOT_ACCESS_KEY_ID>
  # Or search events where username contains "root"
  aws cloudtrail lookup-events --lookup-attributes AttributeKey=Username,AttributeValue=root
  ```

- **Check resource changes** (S3 bucket policy edits, IAM changes, security groups, instance creation). Example S3 and IAM events:

  ```bash
  aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=PutBucketPolicy
  aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=CreateUser
  ```

- **Collect indicators**: list of resources modified, IP addresses, timestamps, actors.

---

### 🧩 Remediation (Fix & Harden)

1. **Delete root access keys** (if not already) and **keep root idle** — use only for billing or account-critical tasks.
2. **Migrate workloads to IAM roles**:

   - For EC2 → attach IAM role (instance profile).
   - For CI/CD → let pipelines `AssumeRole` to scoped deployment role.
   - For serverless → use Lambda role.

3. **Create least-privilege IAM policies** and roles. Example minimal S3 role (Terraform/CLI examples in previous messages).
4. **Rotate any impacted credentials** (other IAM user keys, service tokens) discovered during audit.
5. **Revoke temporary sessions** (optional): identify active STS sessions and revoke by rotating role policies or disabling principal.
6. **Alert stakeholders** (security, infra, compliance); open an incident ticket and document timeline.

---

### 📋 Quick Command & Policy Snippets

**Delete root access key (console preferred)**
Console: My Account → My Security Credentials → Access keys → Delete.

**Create scoped role for CI/CD (CLI)**

```bash
# trust policy for CI runner (example)
cat > trust.json <<EOF
{
  "Version":"2012-10-17",
  "Statement":[{"Effect":"Allow","Principal":{"AWS":"arn:aws:iam::111111111111:role/CI-CD-Runner"},"Action":"sts:AssumeRole"}]
}
EOF
aws iam create-role --role-name DeployRole --assume-role-policy-document file://trust.json
aws iam attach-role-policy --role-name DeployRole --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
```

**MFA enforcement policy (deny if no MFA)**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": { "BoolIfExists": { "aws:MultiFactorAuthPresent": "false" } }
    }
  ]
}
```

**CloudTrail lookup by IP**

```bash
aws cloudtrail lookup-events --lookup-attributes AttributeKey=SourceIPAddress,AttributeValue=203.0.113.12
```

---

### 📋 Immediate vs Follow-up Checklist

|      Priority | Action                                                                     |
| ------------: | -------------------------------------------------------------------------- |
| **Immediate** | Delete/deactivate root access keys, rotate root password, enable root MFA. |
| **Immediate** | Stop jobs/processes that used root keys.                                   |
|      **High** | Generate credential report; search CloudTrail for root actions.            |
|      **High** | Create admin IAM user/role with MFA for recovery.                          |
|    **Medium** | Migrate apps to roles/AssumeRole; rotate impacted credentials.             |
|    **Medium** | Review and remediate resource changes (S3, EC2, IAM).                      |
|       **Low** | Implement SCPs, IAM permission boundaries, and automated alerts.           |

---

### ✅ Best Practices (post-incident)

- **Never use root** for API/CLI — remove any root keys immediately.
- Use **IAM roles** (temporary STS) for services and automation.
- Enforce **MFA** for root and all privileged IAM users.
- Implement **CloudTrail, Config, GuardDuty, Access Analyzer** and alerting for anomalous root/API usage.
- Use **AWS Organizations SCPs** to restrict risky actions across accounts.
- Automate credential hygiene: **credential reports**, access key rotation automation, and periodic audits.

---

### 💡 In short

If a developer used root keys: **immediately remove/deactivate root keys, enable MFA, create scoped IAM identities/roles**, audit via CloudTrail and credential reports, rotate any exposed credentials, and migrate workloads to role-based access. Implement strong guardrails so root is never used again.

---

## Q: S3 Bucket Made Public Accidentally — What to Do?

---

### 🧠 Overview

A **public S3 bucket** is a **critical data exposure risk** — it can allow anyone on the internet to list, read, or write your data.
The goal is to **immediately block public access**, **audit what happened**, **verify data integrity**, and **implement preventive controls** so it never happens again.

---

### ⚙️ Purpose / How It Works

AWS S3 buckets can become public via:

- Bucket policy (`"Principal": "*"`)
- Public ACLs (`AllUsers` or `AuthenticatedUsers`)
- Disabled **Block Public Access** settings
- Cross-account misconfiguration

AWS provides **Account-Level** and **Bucket-Level Public Access Blocks**, **Access Analyzer**, and **CloudTrail** to detect and prevent such exposure.

---

### 🧩 Immediate Remediation Steps (Containment)

#### 1️⃣ Enable “Block Public Access” Immediately

**Console:**

- Go to **S3 → Bucket → Permissions → Block Public Access (Bucket settings)**
- Enable **all four options** ✅

  - Block public ACLs
  - Ignore public ACLs
  - Block new public bucket policies
  - Block public and cross-account access

**CLI:**

```bash
aws s3api put-public-access-block \
  --bucket my-bucket-name \
  --public-access-block-configuration '{
    "BlockPublicAcls": true,
    "IgnorePublicAcls": true,
    "BlockPublicPolicy": true,
    "RestrictPublicBuckets": true
  }'
```

✅ _This immediately cuts off all anonymous access._

---

#### 2️⃣ Review and Remove Public Bucket Policy

Check if `"Principal": "*"` or `"Effect": "Allow"` exists.

```bash
aws s3api get-bucket-policy --bucket my-bucket-name --query Policy --output text > policy.json
```

Edit `policy.json` → remove or restrict the public statement, then reapply:

```bash
aws s3api delete-bucket-policy --bucket my-bucket-name
# or reapply restricted policy:
aws s3api put-bucket-policy --bucket my-bucket-name --policy file://secure-policy.json
```

Example secure policy (only internal role access):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowAccessFromEC2Role",
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::111111111111:role/ECSAppRole" },
      "Action": ["s3:GetObject"],
      "Resource": "arn:aws:s3:::my-bucket-name/*"
    }
  ]
}
```

---

#### 3️⃣ Check and Remove Public ACLs

```bash
aws s3api get-bucket-acl --bucket my-bucket-name
aws s3api get-object-acl --bucket my-bucket-name --key file.txt
```

Look for:

```json
"Grantee": {"URI": "http://acs.amazonaws.com/groups/global/AllUsers"}
```

Remove them:

```bash
aws s3api put-bucket-acl --bucket my-bucket-name --acl private
```

---

#### 4️⃣ Verify Exposure with IAM Access Analyzer

Check if the bucket is/was shared publicly:

```bash
aws accessanalyzer list-findings --analyzer-name account-access-analyzer
```

Mark resolved findings after remediation:

```bash
aws accessanalyzer archive-findings --analyzer-name account-access-analyzer --ids <finding-id>
```

---

#### 5️⃣ Audit Who Made It Public (CloudTrail)

```bash
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=PutBucketPolicy \
  --max-results 10
```

Look for `"userIdentity"` and `"sourceIPAddress"` fields to identify the actor and method.

---

#### 6️⃣ Validate That Data Wasn’t Accessed

Use **S3 server access logs** or **CloudTrail Data Events**:

```bash
aws cloudtrail lookup-events --lookup-attributes AttributeKey=ResourceName,AttributeValue=my-bucket-name
```

Check for `"GetObject"` events from unknown IPs or anonymous principals.

---

### 🧩 Example Secure S3 Policy Setup (Post-Fix)

**Least-Privilege Policy (internal access only):**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::111111111111:role/AppAccessRole" },
      "Action": ["s3:GetObject"],
      "Resource": ["arn:aws:s3:::my-secure-bucket/*"]
    }
  ]
}
```

**Optional: Deny public access guardrail**

```json
{
  "Effect": "Deny",
  "Principal": "*",
  "Action": "s3:*",
  "Resource": ["arn:aws:s3:::*", "arn:aws:s3:::*/*"],
  "Condition": { "Bool": { "aws:SecureTransport": "false" } }
}
```

---

### 📋 Prevention & Continuous Monitoring

| Control                            | Description                                                                | Enforcement                |
| ---------------------------------- | -------------------------------------------------------------------------- | -------------------------- |
| **S3 Block Public Access**         | Global & bucket-level switch to prevent public exposure                    | Default = ON               |
| **IAM Access Analyzer**            | Detects public/cross-account sharing                                       | Continuous                 |
| **AWS Config Rule**                | `s3-bucket-public-read-prohibited` and `s3-bucket-public-write-prohibited` | Auto-remediation           |
| **Service Control Policies (SCP)** | Deny public S3 actions org-wide                                            | AWS Organizations          |
| **CloudTrail Alerts**              | Detect `PutBucketPolicy` / `PutBucketAcl` events                           | Real-time SNS/EventBridge  |
| **AWS Security Hub / GuardDuty**   | Centralized detection of public buckets                                    | Security posture dashboard |

Example SCP (prevent public S3 access in all accounts):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyPublicS3",
      "Effect": "Deny",
      "Action": ["s3:PutBucketAcl", "s3:PutBucketPolicy"],
      "Resource": "*",
      "Condition": {
        "StringLike": { "s3:x-amz-acl": ["public-read", "public-read-write"] }
      }
    }
  ]
}
```

---

### ✅ Best Practices

- **Always enable “Block Public Access”** globally for your account.
- Use **IAM roles and VPC endpoints** for controlled private access.
- Enforce **S3 bucket policies with conditions** (`aws:SourceVpc`, `aws:SecureTransport`).
- Monitor with **AWS Config, Access Analyzer, GuardDuty, and Security Hub**.
- Apply **SCPs** in multi-account setups to deny public exposure organization-wide.
- Run regular **S3 bucket audits** via CLI or AWS Trusted Advisor.

---

### 💡 In short

If an S3 bucket becomes public:
1️⃣ Block public access immediately →
2️⃣ Remove public ACLs/policies →
3️⃣ Audit CloudTrail for exposure →
4️⃣ Enable Access Analyzer & Config Rules →
5️⃣ Lock down future access with SCPs and automation.
✅ _Never rely on manual control — enforce least privilege and automated public access prevention._

---

## Q: Audit Requires User MFA Enforcement — How to Enforce MFA for IAM Users

---

### 🧠 Overview

Auditors often require that **all IAM users must use Multi-Factor Authentication (MFA)** for AWS access.
MFA adds a **second authentication factor** — typically a one-time code from a mobile app or hardware token — reducing the risk of credential theft and unauthorized access.

Your goal:
✅ Enforce MFA across all IAM users (for console and CLI),
✅ Detect non-compliant users automatically,
✅ Block API actions if MFA isn’t used.

---

### ⚙️ Purpose / How It Works

AWS lets you enforce MFA using:

1. **IAM policies** (deny access when `aws:MultiFactorAuthPresent` = false)
2. **AWS Config rules** (detect non-MFA users)
3. **AWS Organizations SCPs** (optional org-wide enforcement)
4. **Credential reports + automation** (to verify and alert non-MFA users)

---

### 🧩 Step-by-Step: Enforce MFA for IAM Users

#### **1️⃣ Enable MFA for Each User**

Each IAM user must assign an MFA device.

**Console:**
IAM → Users → Security credentials → “Assign MFA device” → choose virtual/hardware → register two OTPs.

**CLI Example (Virtual MFA):**

```bash
aws iam enable-mfa-device \
  --user-name devops-user \
  --serial-number arn:aws:iam::123456789012:mfa/devops-user \
  --authentication-code1 123456 --authentication-code2 654321
```

---

#### **2️⃣ Enforce MFA with a Deny Policy**

Attach this policy (inline or managed) to _all users or groups_:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAllExceptMFASession",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "BoolIfExists": { "aws:MultiFactorAuthPresent": "false" }
      }
    }
  ]
}
```

✅ _Any request made without MFA (Console or CLI) will be denied._

---

#### **3️⃣ Verify MFA Enforcement (CLI)**

```bash
aws iam generate-credential-report
aws iam get-credential-report --query "Content" --output text | base64 --decode > report.csv
```

Look for `mfa_active` column — should be `TRUE` for all users.

Quick filter for non-MFA users:

```bash
grep FALSE report.csv
```

---

#### **4️⃣ Detect & Alert Non-MFA Users (AWS Config Rule)**

Enable AWS Config rule:

```bash
aws configservice put-config-rule \
  --config-rule-name "iam-user-mfa-enabled" \
  --source "Owner=AWS,SourceIdentifier=IAM_USER_MFA_ENABLED"
```

- Non-compliant users appear in **Config Dashboard**.
- You can trigger **SNS/EventBridge** → Lambda → alert or auto-disable user.

---

#### **5️⃣ (Optional) Organization-Wide Enforcement (SCP)**

To ensure MFA requirement across all accounts in an AWS Organization:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyWithoutMFA",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "BoolIfExists": { "aws:MultiFactorAuthPresent": "false" }
      }
    }
  ]
}
```

Attach the SCP at **Org Root** or specific **OUs** to deny access to any account user/session without MFA.

---

#### **6️⃣ (Optional) CLI MFA Access (STS Tokens)**

IAM users can get **temporary MFA sessions** for CLI/API:

```bash
aws sts get-session-token \
  --serial-number arn:aws:iam::123456789012:mfa/devops-user \
  --token-code 123456
```

Then export the session credentials:

```bash
export AWS_ACCESS_KEY_ID=ASIAEXAMPLE
export AWS_SECRET_ACCESS_KEY=SECRETEXAMPLE
export AWS_SESSION_TOKEN=TOKENEXAMPLE
```

---

### 📋 Compliance Verification Checklist

| Check                                 | Tool                       | Expected                |
| ------------------------------------- | -------------------------- | ----------------------- |
| All IAM users have MFA enabled        | Credential Report / Config | ✅ `mfa_active=TRUE`    |
| Root account has MFA enabled          | Console                    | ✅ Enabled              |
| IAM policy denies actions without MFA | IAM Policy                 | ✅ Active               |
| Non-compliant users auto-detected     | AWS Config Rule            | ✅ Monitoring           |
| No long-term keys in use              | Credential Report          | ✅ Keys rotated/removed |

---

### ✅ Best Practices

- Enforce MFA for **root** and **all IAM users** immediately.
- Prefer **AWS SSO (IAM Identity Center)** or **federation with MFA** for enterprise logins.
- Monitor compliance via **Config Rules**, **Security Hub**, and **CloudWatch Alarms**.
- Automate remediation: disable or notify non-MFA users.
- Rotate all credentials periodically and remove inactive users.

---

### 💡 In short

To satisfy audit MFA requirements:
1️⃣ Enable MFA on all users (root + IAM).
2️⃣ Enforce it with a **deny-unless-MFA IAM policy**.
3️⃣ Continuously monitor via **AWS Config + Credential Report**.
✅ Ensures only **MFA-authenticated** sessions can access AWS, meeting both **security and compliance** mandates.

---

## Q: How to Allow Cross-Account Lambda Invocation (Secure Setup)

---

### 🧠 Overview

A **cross-account Lambda invocation** allows a **resource or principal in one AWS account (Account A)** to invoke a **Lambda function in another AWS account (Account B)**.
This is a common multi-account pattern for **centralized processing, shared services, or event-driven architectures** (e.g., CloudWatch/EventBridge → Lambda).

---

### ⚙️ Purpose / How It Works

AWS enables cross-account invocation via **Lambda resource-based policies**.
You grant the **calling account (A)** permission to invoke your **Lambda function (B)** by adding a statement to its **resource policy**.

**Flow:**

```
Account A (Caller) → Assume Role / Service → Invoke API →
Lambda Function (Account B) → Executes Function Code
```

✅ IAM in **Account A** must have permission to invoke the Lambda.
✅ Lambda in **Account B** must trust Account A (via resource policy).

---

### 🧩 Example Setup — Account A Invokes Lambda in Account B

#### 🧩 Scenario

- **Account A** → `arn:aws:iam::111111111111:user/devops-user`
- **Account B** → Lambda `arn:aws:lambda:ap-south-1:222222222222:function:process-data`

---

### 🧩 Step 1: Add Resource-Based Policy to Lambda (in Account B)

```bash
aws lambda add-permission \
  --function-name process-data \
  --statement-id AllowInvokeFromAccountA \
  --action lambda:InvokeFunction \
  --principal 111111111111 \
  --source-arn arn:aws:iam::111111111111:root \
  --region ap-south-1
```

✅ This allows **any IAM entity** in Account A to invoke the function.

---

#### Example Resource Policy (Result)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowInvokeFromAccountA",
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::111111111111:root" },
      "Action": "lambda:InvokeFunction",
      "Resource": "arn:aws:lambda:ap-south-1:222222222222:function:process-data"
    }
  ]
}
```

---

### 🧩 Step 2: Grant Permission in Account A’s IAM Policy

Attach this policy to the IAM user or role that will invoke the Lambda:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "lambda:InvokeFunction",
      "Resource": "arn:aws:lambda:ap-south-1:222222222222:function:process-data"
    }
  ]
}
```

---

### 🧩 Step 3: Invoke the Function from Account A (CLI)

```bash
aws lambda invoke \
  --function-name arn:aws:lambda:ap-south-1:222222222222:function:process-data \
  --payload '{"key":"value"}' \
  output.json
```

✅ Successful response means cross-account access is working.

---

### 🧩 Step 4: (Optional) Restrict Invocation Source

You can narrow invocation rights using:

- **source ARN** (if invoked from a specific AWS service, like EventBridge)
- **Condition** for stricter access

Example (only EventBridge rule in Account A allowed):

```bash
aws lambda add-permission \
  --function-name process-data \
  --statement-id AllowEventBridgeInvoke \
  --action lambda:InvokeFunction \
  --principal events.amazonaws.com \
  --source-arn arn:aws:events:ap-south-1:111111111111:rule/trigger-lambda
```

---

### 🧩 Step 5: Verify Resource Policy

```bash
aws lambda get-policy --function-name process-data
```

---

### 📋 Common Cross-Account Invocation Patterns

| Source                             | Target                    | Method                                                          |
| ---------------------------------- | ------------------------- | --------------------------------------------------------------- |
| Account A → Lambda (Direct Invoke) | Lambda in Account B       | IAM + Lambda Resource Policy                                    |
| EventBridge Rule (A) → Lambda (B)  | Service-based invoke      | Resource Policy + SourceArn                                     |
| S3 (A) → Lambda (B)                | S3 trigger                | Add-permission with `principal=s3.amazonaws.com` and bucket ARN |
| API Gateway (A) → Lambda (B)       | Cross-account integration | Resource Policy + Role assumption                               |
| Step Function (A) → Lambda (B)     | Workflow invocation       | Role-based or direct resource policy                            |

---

### ✅ Best Practices

- **Use resource-based policies**, not static keys, for cross-account Lambda access.
- Limit `Principal` to specific accounts or roles (never `*`).
- Use **Condition** to restrict invocation source (`aws:SourceArn`).
- Enable **CloudTrail** to track who invoked the function.
- Avoid giving `root` principal blanket access — always scope to specific IAM roles.
- Regularly audit Lambda resource policies via:

  ```bash
  aws lambda get-policy --function-name <function-name> | jq .
  ```

---

### 💡 In short

To allow **cross-account Lambda invocation**:
1️⃣ Add a **resource-based policy** on the target Lambda (Account B).
2️⃣ Grant `lambda:InvokeFunction` in caller’s IAM (Account A).
3️⃣ Optionally restrict using **SourceArn** or **Conditions**.
✅ _This approach is secure, keyless, and fully auditable through IAM and CloudTrail._

---

## Q: Least privilege policy needed

---

### 🧠 Overview

Provide minimal, scoped IAM policies that grant **only the actions required** on **only the resources required**, with conditions where possible. Below are templates and practical steps to create, test, and roll out least-privilege policies for common workloads (S3, EC2, Lambda) plus a reusable policy-authoring checklist.

---

### ⚙️ Purpose / How it works

- Limit blast radius: `Effective = IdentityPolicy ∩ PermissionBoundary ∩ SCP`.
- Build policies by enumerating required actions, scoping resources (ARNs/prefixes), and adding Conditions (MFA, SourceIp, VPC, tags).
- Test with IAM Policy Simulator and run in a limited pilot before wide deployment.

---

### 🧩 Examples / Commands / Config snippets

#### 1) S3: Read-only for a single bucket/prefix

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowListBucket",
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::my-app-bucket"],
      "Condition": { "StringLike": { "s3:prefix": "app-data/*" } }
    },
    {
      "Sid": "AllowGetObjects",
      "Effect": "Allow",
      "Action": ["s3:GetObject"],
      "Resource": ["arn:aws:s3:::my-app-bucket/app-data/*"]
    }
  ]
}
```

Attach via CLI:

```bash
aws iam create-policy --policy-name AppS3ReadOnly --policy-document file://s3-readonly.json
aws iam attach-role-policy --role-name AppRole --policy-arn arn:aws:iam::123456789012:policy/AppS3ReadOnly
```

#### 2) EC2: Allow Describe and Start/Stop only for specific instances (tag-based)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DescribeEC2",
      "Effect": "Allow",
      "Action": ["ec2:DescribeInstances", "ec2:DescribeTags"],
      "Resource": "*"
    },
    {
      "Sid": "StartStopTaggedInstances",
      "Effect": "Allow",
      "Action": ["ec2:StartInstances", "ec2:StopInstances"],
      "Resource": "arn:aws:ec2:ap-south-1:123456789012:instance/*",
      "Condition": {
        "StringEquals": { "ec2:ResourceTag/Environment": "Dev" }
      }
    }
  ]
}
```

#### 3) Lambda invoke by specific principal (cross-account-safe)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowInvokeFromSpecificRole",
      "Effect": "Allow",
      "Action": "lambda:InvokeFunction",
      "Resource": "arn:aws:lambda:ap-south-1:222222222222:function:process-data",
      "Condition": {
        "StringEquals": {
          "aws:PrincipalArn": "arn:aws:iam::111111111111:role/AllowedInvokerRole"
        }
      }
    }
  ]
}
```

#### 4) Generic least-privilege policy template (authoring checklist)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "TemplateStatement",
      "Effect": "Allow",
      "Action": ["service:Action1", "service:Action2"],
      "Resource": ["arn:aws:service:region:account:resource-type/resource-id"],
      "Condition": {
        "BoolIfExists": { "aws:MultiFactorAuthPresent": "true" },
        "StringEqualsIfExists": { "aws:RequestedRegion": "ap-south-1" }
      }
    }
  ]
}
```

---

### 📋 Parameters / Decisions Table

| Decision               | Recommendation                                                             |
| ---------------------- | -------------------------------------------------------------------------- |
| **Action granularity** | List specific API actions, not `"*"`                                       |
| **Resource scope**     | Use ARNs or prefixes; avoid `Resource: "*"`                                |
| **Use Conditions**     | Enforce `aws:MultiFactorAuthPresent`, `aws:SourceIp`, `ec2:ResourceTag/*`  |
| **Policy type**        | Use customer-managed policies + permission boundaries for delegated admins |
| **Testing**            | IAM Policy Simulator + least-privilege pilot role in non-prod              |
| **Monitoring**         | CloudTrail + Access Analyzer + Access Advisor                              |

---

### ✅ Best Practices (practical rollout)

- Start with a **deny-all mindset**: list required actions and add only those.
- **Record required APIs** by instrumenting existing runs (CloudTrail) rather than guessing.
- Use **resource tags** to scope actions (e.g., allow `ec2:StopInstances` only for `Environment=Dev`).
- Combine **permission boundaries** for builders who create roles to prevent privilege escalation.
- Use **session tags** and STS AssumeRole to carry identity context for audits.
- Automate verification: run **Policy Simulator** and a small pilot role for 1–2 weeks.
- Maintain a **policy versioning** process (naming convention + changelog).
- Avoid attaching policies directly to users; prefer roles + groups.
- Periodically run **Access Advisor** to remove unused privileges.

---

### ⚠️ How to test quickly

- IAM Policy Simulator (Console) — simulate principal + action + resource.
- `aws iam simulate-principal-policy` (CLI):

```bash
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::123456789012:role/AppRole \
  --action-names s3:GetObject s3:ListBucket \
  --resource-arns arn:aws:s3:::my-app-bucket arn:aws:s3:::my-app-bucket/app-data/file.txt
```

- Search CloudTrail for expensive/wide actions to validate necessity:

```bash
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=DeleteBucket
```

---

### 💡 In short

Define least-privilege policies by enumerating exact actions, scoping resources tightly (ARNs/tags), and adding conditions (MFA, IP, region). Test with the IAM Policy Simulator and pilot roles, then monitor with CloudTrail/Access Analyzer — iterate to minimize privileges continuously.

---

## Q: Need to restrict IAM access by IP

---

### 🧠 Overview

Restricting IAM access by IP means adding **conditions** (e.g., `aws:SourceIp`) to IAM/resource/SCP policies so requests are allowed **only** from approved IP ranges, VPCs, or VPC endpoints. This prevents API/console access from untrusted networks and reduces blast radius from stolen credentials.

---

### ⚙️ Purpose / How it works

- Use **IAM policy conditions** to allow or **explicitly deny** requests not coming from specified IP CIDRs.
- Apply at multiple layers for defense-in-depth:

  - **Identity-based policies** (users/roles) — block API calls from unknown IPs.
  - **Resource-based policies** (S3, KMS, etc.) — limit resource access by source IP or VPC endpoint.
  - **SCPs** (AWS Organizations) — org-level guardrails.
  - **VPC Endpoints** — keep traffic internal and combine with `aws:SourceVpce`.

- Policy evaluation: explicit Deny (e.g., NotIpAddress) will always override Allows.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Deny-all-except-corporate-IP — attach to users/groups/roles

Use `NotIpAddress` to **deny** requests not from allowed CIDRs (safer than Allow-only).

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyIfNotFromCorpIP",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "NotIpAddress": {
          "aws:SourceIp": ["203.0.113.0/24", "198.51.100.10/32"]
        }
      }
    }
  ]
}
```

CLI — create & attach as customer managed policy:

```bash
aws iam create-policy --policy-name DenyNotCorpIP --policy-document file://deny-not-corp-ip.json
aws iam attach-user-policy --user-name devops-user --policy-arn arn:aws:iam::123456789012:policy/DenyNotCorpIP
```

---

#### 2) Allow Console login only from corporate IP + require MFA

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyConsoleUnlessFromCorpAndMFA",
      "Effect": "Deny",
      "Action": "aws-portal:ViewBilling" /* example; use "*" for full block */,
      "Resource": "*",
      "Condition": {
        "ForAnyValue:StringNotEquals": {
          "aws:SourceIp": ["203.0.113.0/24"]
        },
        "Bool": { "aws:MultiFactorAuthPresent": "false" }
      }
    }
  ]
}
```

> Note: Use two statements (IP + MFA) or `BoolIfExists` to avoid locking out special accounts during roll-out.

---

#### 3) S3 bucket policy: allow GetObject only from VPC Endpoint

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowGetFromVpcEndpoint",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-bucket/*",
      "Condition": {
        "StringEquals": { "aws:SourceVpce": "vpce-0abc1234def567890" }
      }
    }
  ]
}
```

---

#### 4) SCP to deny console/API access unless from approved IP ranges (Org-level)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyUnlessFromApprovedIP",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "NotIpAddress": { "aws:SourceIp": ["203.0.113.0/24"] }
      }
    }
  ]
}
```

> Caution: test on a small OU first — SCPs affect all principals including root.

---

#### 5) Test a policy with IAM Policy Simulator (CLI)

```bash
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::123456789012:role/DevRole \
  --action-names sts:GetCallerIdentity \
  --context-entries ContextKeyName=aws:SourceIp,ContextKeyType=ip,ContextKeyValues=198.51.100.1
```

---

### 📋 Table: Which control to use when

| Goal                                  | Best control                                       | Notes                                 |
| ------------------------------------- | -------------------------------------------------- | ------------------------------------- |
| Stop console/API from public internet | Identity policy with `NotIpAddress` or SCP         | Attach to role/user or OU; test first |
| Limit S3 access to VPC traffic        | S3 bucket policy + VPC endpoint + `aws:SourceVpce` | Keeps traffic inside AWS network      |
| Org-wide enforcement                  | SCP with IP conditions                             | Affects all accounts — high impact    |
| Granular per-role limit               | Identity policy on role with IP condition          | Good for CI/CD or admin roles         |
| Prevent SSRF/IMDS leaks               | Enforce IMDSv2 and metadata protections            | Complement IP restrictions            |

---

### ✅ Best Practices

- **Roll out gradually**: start with a deny-policy in `Test` group/role to validate.
- Prefer **explicit Deny with NotIpAddress** (safer for rollbacks).
- Combine **IP restrictions + MFA + permission boundaries** for strong defense.
- Use **VPC endpoints** and `aws:SourceVpce` for service access to S3/Secrets Manager.
- **Exclude admin break-glass** account/role (protected by separate allow list) and keep recovery process documented.
- Monitor and alert with **CloudTrail** / CloudWatch when denied requests spike.
- Use **IAM Policy Simulator** and automated tests before applying at scale.
- For mobile/federated users, prefer **federation + conditional checks** (e.g., require SSO that enforces IP rules).

---

### 💡 In short

Restrict IAM access by IP via policy **conditions** (`aws:SourceIp`, `aws:SourceVpce`) applied as identity policies, resource policies, or SCPs. Prefer **explicit Deny (NotIpAddress)**, test in a pilot, combine with MFA and VPC endpoints, and monitor CloudTrail for denied attempts.

---

## Q: Developer created too many access keys — how to remediate & prevent

---

### 🧠 Overview

When a user has multiple active access keys it increases risk (leakage, orphaned credentials). Immediate actions: **identify**, **deactivate/delete** excess keys, **rotate** required keys, **audit** who used them, and **prevent** future uncontrolled key creation via policies/automation.

---

### ⚙️ Purpose / How it works

- **Contain**: remove unnecessary keys so only tracked, rotated keys remain.
- **Audit**: use CloudTrail + Credential Report to find usage and implicated systems.
- **Harden**: restrict who can create keys and automate detection (Config/EventBridge/Lambda).
- **Migrate**: prefer roles/STS for apps (no long-term keys).

---

### 🧩 Examples / Commands / Scripts

#### 1) Quick inventory (generate credential report & find users with >1 active key)

```bash
# generate + download credential report
aws iam generate-credential-report
aws iam get-credential-report --query "Content" --output text | base64 --decode > credential-report.csv

# show users with two active keys (simple CSV filter)
awk -F, 'NR>1 { if($11=="true" && $13=="true") print $1,"-> 2 active keys"}' credential-report.csv
# Columns: access_key_1_active = $11, access_key_2_active = $13  (verify positions in your CSV)
```

#### 2) List access keys for a user

```bash
aws iam list-access-keys --user-name devops-user
```

#### 3) Deactivate then delete an old key (safe flow)

```bash
# deactivate
aws iam update-access-key --user-name devops-user --access-key-id AKIAOLDKEY --status Inactive

# verify application/test -- then delete
aws iam delete-access-key --user-name devops-user --access-key-id AKIAOLDKEY
```

#### 4) Create a new key (rotate) and inject to system securely

```bash
aws iam create-access-key --user-name devops-user > newkey.json
# parse and store to secret manager rather than plaintext
jq -r '.AccessKey | .AccessKeyId, .SecretAccessKey' newkey.json
# push to AWS Secrets Manager or Parameter Store, update the app to use it, then delete old key
```

#### 5) Find which key was used (CloudTrail)

```bash
# lookup by AccessKeyId from CloudTrail events
aws cloudtrail lookup-events --lookup-attributes AttributeKey=AccessKeyId,AttributeValue=AKIAEXAMPLE
```

---

### 📋 Preventive controls (policies & automation)

#### A) Deny CreateAccessKey unless principal has an allow tag

Tag approved users with `CanCreateAccessKey=true` and attach this policy **to everyone** (or as a permission guard).

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyCreateAccessKeyUnlessTagged",
      "Effect": "Deny",
      "Action": "iam:CreateAccessKey",
      "Resource": "arn:aws:iam::*:user/*",
      "Condition": {
        "StringNotEquals": {
          "aws:PrincipalTag/CanCreateAccessKey": "true"
        }
      }
    }
  ]
}
```

- Admins tag specific users or a service account when keys are legitimately required.
- This prevents uncontrolled key creation while allowing exceptions.

#### B) Prevent creation via SCP (org-wide) — optional high-impact guard

Use an SCP to block `iam:CreateAccessKey` in child accounts (test first).

#### C) Auto-detect & remediate with CloudWatch/EventBridge + Lambda

- EventBridge rule: scheduled (daily) or on `CreateAccessKey` CloudTrail event → Lambda that:

  - counts active keys for the user,
  - notifies Slack/SNS if >1, optionally **deactivates** oldest key after approval.

- Use AWS Config custom rule that checks `credential-report` for active key count and flags noncompliance.

---

### ✅ Best Practices (practical, production-ready)

- **Prefer IAM Roles & STS** for services (EC2, Lambda, CI/CD) — eliminate long-term keys.
- Enforce **max 1 active key** per user in process/policy, but AWS allows up to 2 (use the other only for rotation).
- **Rotate** keys via automation (store secrets in Secrets Manager; update apps automatically).
- Use **Credential Reports** and **Access Advisor** regularly; schedule weekly checks.
- **Log & monitor** access-key usage with CloudTrail; alert on unusual sources or spikes.
- Keep an **“emergency admin”** procedure: break-glass role not key-based.
- Securely store new secrets (Secrets Manager/Parameter Store with encryption) and avoid plaintext exports.

---

### ⚠️ Short automated remediation script (example pseudo-flow)

```bash
# Pseudo: find users with >1 active key, deactivate the oldest key and notify
for user in $(awk -F, 'NR>1{print $1}' credential-report.csv); do
  keys=$(aws iam list-access-keys --user-name $user --query 'AccessKeyMetadata[?Status==`Active`].AccessKeyId' --output text)
  if [ $(echo $keys | wc -w) -gt 1 ]; then
    # choose oldest key
    oldest=$(aws iam list-access-keys --user-name $user --query 'AccessKeyMetadata | sort_by(@,&CreateDate)[0].AccessKeyId' --output text)
    aws iam update-access-key --user-name $user --access-key-id $oldest --status Inactive
    # send alert to SNS/Slack and wait for confirmation before delete
  fi
done
```

_(Deploy as Lambda with proper IAM permissions + approval flow.)_

---

### 📋 Quick checklist (incident → long-term)

- [ ] Inventory all active keys (credential report).
- [ ] Identify keys created recently / unused / suspicious (CloudTrail).
- [ ] Deactivate extra keys; test systems that break.
- [ ] Delete deactivated, unnecessary keys.
- [ ] Rotate required keys and store in Secrets Manager.
- [ ] Attach a deny-policy (or tag-based allow) to prevent uncontrolled creation.
- [ ] Automate detection (EventBridge + Lambda / AWS Config).
- [ ] Educate developers: use roles/AssumeRole, not long-term keys.

---

### 💡 In short

Immediately **list → deactivate → delete** excess keys, audit usage via CloudTrail/credential reports, rotate required keys into secure storage, and prevent recurrence with a tag-based deny policy plus automated detection (EventBridge/Lambda or AWS Config). Prefer **roles/STS** over long-term keys.

---

## Q: Org-wide restriction on EC2 creation

---

### 🧠 Overview

You can **prevent EC2 instance creation across an AWS Organization** by applying a **Service Control Policy (SCP)** that denies `ec2:RunInstances` (and other EC2 launch APIs) at the Org Root or specific OUs/accounts. SCPs act as an **upper-bound** — they **cannot grant** permissions, only restrict them — and will block instance creation even if account IAM policies allow it.

---

### ⚙️ Purpose / How it works

- **SCP** placed on an OU/account enforces a deny for EC2 launch APIs (`ec2:RunInstances`, `ec2:RunInstancesWithLaunchTemplate`, etc.).
- Evaluation: `Effective = IAM Policy Allow ∩ SCP Allow`. If SCP denies an action, it’s denied regardless of local IAM.
- Use **conditions** to allow exceptions (e.g., allow launches from a specific role, or only with required tags, or only in approved regions).
- Recommended rollout: **test in a sandbox OU → narrow production OU → org-wide**. Don’t lock out management account admin tasks.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Simple SCP — deny all EC2 instance creation

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyEC2RunInstances",
      "Effect": "Deny",
      "Action": [
        "ec2:RunInstances",
        "ec2:RunInstancesWithLaunchTemplate",
        "ec2:CreateFleet"
      ],
      "Resource": "*"
    }
  ]
}
```

**Create & attach SCP via AWS CLI**

```bash
# create SCP
aws organizations create-policy \
  --name "Deny-EC2-RunInstances" \
  --description "Block EC2 instance creation" \
  --type SERVICE_CONTROL_POLICY \
  --content file://deny-ec2-runinstances.json

# attach to OU or Account (replace policy-id and target-id)
aws organizations attach-policy \
  --policy-id p-xxxxxxxx \
  --target-id ou-aaaa-bbbbbbbbb
```

---

#### 2) SCP with an allow-exception for a specific admin role (useful for break-glass)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyEC2RunInstancesExceptSpecificRole",
      "Effect": "Deny",
      "Action": ["ec2:RunInstances", "ec2:CreateFleet"],
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:PrincipalArn": "arn:aws:iam::123456789012:role/Org-EC2-Admin-Role"
        }
      }
    }
  ]
}
```

- Attach the `Org-EC2-Admin-Role` only to the accounts/roles you trust as break-glass.

---

#### 3) SCP: allow launches **only when** a required tag is supplied (enforce tag-driven approval)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyRunInstancesUnlessTagged",
      "Effect": "Deny",
      "Action": ["ec2:RunInstances", "ec2:CreateFleet"],
      "Resource": "*",
      "Condition": {
        "Null": { "aws:RequestTag/CostCenter": "true" }
      }
    }
  ]
}
```

- This denies launches that **do not** provide `CostCenter` tag on creation; combine with tagging enforcement and automation.

---

#### 4) SCP to restrict EC2 creation to approved regions

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyRunInstancesOutsideApprovedRegions",
      "Effect": "Deny",
      "Action": "ec2:RunInstances",
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": ["ap-south-1", "us-east-1"]
        }
      }
    }
  ]
}
```

---

### 📋 Parameters / Decisions Table

| Decision               |                                                               Option | Notes                                                    |
| ---------------------- | -------------------------------------------------------------------: | -------------------------------------------------------- |
| **Where to attach**    |                                                        OU or account | OU for grouped accounts; root to block all (be careful). |
| **Scope**              | `ec2:RunInstances` ± `CreateFleet`, `RunInstancesWithLaunchTemplate` | Cover all launch APIs used in your org.                  |
| **Exceptions**         |     PrincipalArn-based allow, required tags, or source VPC endpoints | Use conditions to allow limited exceptions.              |
| **Testing**            |                                                     Sandbox OU first | Test to avoid accidental lockout.                        |
| **Management account** |                   Exclude management account or use break-glass role | Avoid blocking admin tasks.                              |

---

### ✅ Best Practices

- **Test before org-wide**: deploy the SCP to a sandbox OU first and validate.
- **Cover all launch APIs**: block `ec2:RunInstances`, `CreateFleet`, `RunInstancesWithLaunchTemplate`, and any service used to launch instances (CloudFormation, Autoscaling `CreateAutoScalingGroup` may also create instances).
- **Use least-privilege exceptions**: prefer `Condition`-based exceptions (specific role or required request tags) over `Principal: "*"`.
- **Keep a documented break-glass process**: use a tightly-scoped role (PrincipalArn) that can bypass the deny; audit its use via CloudTrail.
- **Combine controls**: SCP + permission boundaries + IAM policies + CloudFormation Guardrails (e.g., deny in CFN) + AWS Config rules.
- **Monitor**: alert on `CreateFleet`/`RunInstances` CloudTrail events to detect attempts.
- **Avoid locking management account**: don’t attach restrictive SCPs to the management account; test removal steps beforehand.

---

### ⚠️ Caveats & gotchas

- SCPs **only restrict** — they don’t grant access. Make sure necessary automation (e.g., patching or approved autoscaling) has exceptions.
- SCPs apply to all principals in the target accounts (including root) — a too-tight SCP can break automation or admin tasks. Always have a rollback plan.
- When using `aws:RequestTag` conditions, callers **must supply the tag** on the API request (e.g., `--tag-specifications` for `run-instances` or CloudFormation template tags).

---

### 💡 In short

Apply an **SCP** that denies EC2 launch APIs at the desired OU/account to block instance creation org-wide. Use **conditions** to allow safe exceptions (specific role or required tags), test in a sandbox OU first, and maintain a break-glass role + CloudTrail auditing to avoid and recover from accidental lockouts.

---

## Q: Third-Party Service Needs Temporary AWS Access

---

### 🧠 Overview

When a third-party vendor or SaaS platform needs AWS access (for auditing, backups, CI/CD integrations, etc.), **never share static keys**.
Instead, use **temporary, scoped access** via **IAM roles + AWS STS (AssumeRole)** with strict trust, time, and permission limits.

This ensures **keyless, auditable, and auto-expiring** access with minimal blast radius.

---

### ⚙️ Purpose / How It Works

1. You (Account A) create a **dedicated IAM role** with:

   - **Trust policy** that allows the third-party AWS account (Account B) or their external ID.
   - **Permission policy** scoped to required actions (e.g., S3 read, CloudWatch metrics, etc.).

2. The third-party assumes the role using **STS:AssumeRole**.
3. AWS issues **temporary credentials** (valid for up to 1 hour, extendable to 12 with session duration).
4. You monitor, log, and revoke access instantly by removing the trust.

---

### 🧩 Example: Cross-Account Temporary Access (Secure Setup)

#### 🧩 Step 1 — Create Role in Your Account

```bash
aws iam create-role \
  --role-name ThirdPartyReadOnlyRole \
  --assume-role-policy-document file://trust-policy.json
```

**`trust-policy.json`:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::222222222222:root" },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "vendor-unique-token-123"
        }
      }
    }
  ]
}
```

✅ ExternalId prevents “confused-deputy” attacks.

---

#### 🧩 Step 2 — Attach a Scoped Permission Policy

```bash
aws iam put-role-policy \
  --role-name ThirdPartyReadOnlyRole \
  --policy-name ThirdPartyS3ReadOnly \
  --policy-document file://permissions.json
```

**`permissions.json`:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ReadSpecificBucketOnly",
      "Effect": "Allow",
      "Action": ["s3:ListBucket", "s3:GetObject"],
      "Resource": ["arn:aws:s3:::project-logs", "arn:aws:s3:::project-logs/*"]
    }
  ]
}
```

---

#### 🧩 Step 3 — Third-Party Assumes the Role (Their Side)

They call STS using your Role ARN and their ExternalId:

```bash
aws sts assume-role \
  --role-arn arn:aws:iam::111111111111:role/ThirdPartyReadOnlyRole \
  --role-session-name ThirdPartyAudit \
  --external-id vendor-unique-token-123
```

Response:

```json
{
  "Credentials": {
    "AccessKeyId": "ASIAEXAMPLE",
    "SecretAccessKey": "SECRET",
    "SessionToken": "IQoJb3JpZ2luX2Vj...",
    "Expiration": "2025-11-12T17:00:00Z"
  }
}
```

✅ Valid only for the session duration (1h–12h).

---

#### 🧩 Step 4 — Monitor and Revoke

- **Revoke:** `aws iam delete-role-policy` or modify the trust to remove vendor principal.
- **Audit:**

  ```bash
  aws cloudtrail lookup-events --lookup-attributes AttributeKey=Username,AttributeValue=ThirdPartyReadOnlyRole
  ```

- **Set max duration:**

  ```bash
  aws iam update-role --role-name ThirdPartyReadOnlyRole --max-session-duration 3600
  ```

---

### 📋 Alternative: Temporary Federated Access (if non-AWS vendor)

If vendor doesn’t have an AWS account but needs CLI/console access:

- Use **`sts:GetFederationToken`** or **AWS Identity Center** (temporary console login).
- Example (1-hour federated console access for external script):

  ```bash
  aws sts get-federation-token --name vendor-user --policy file://permissions.json --duration-seconds 3600
  ```

- Share the **federated sign-in URL** with the vendor — no IAM user needed.

---

### 📋 Policy Controls Summary

| Control                | Description                              | Best Practice                                              |
| ---------------------- | ---------------------------------------- | ---------------------------------------------------------- |
| **IAM Role**           | Grants scoped, temporary access          | Always use instead of users                                |
| **ExternalId**         | Protects against confused-deputy attacks | Mandatory for 3rd parties                                  |
| **MaxSessionDuration** | Limits token lifetime                    | ≤ 1 hour for vendors                                       |
| **CloudTrail**         | Logs every AssumeRole and API call       | Enable org-wide                                            |
| **Condition Keys**     | Restrict IPs, regions, or tags           | Add `aws:SourceIp` / `aws:RequestedRegion`                 |
| **SCP**                | Org-wide upper limit                     | Prevent unauthorized role creation or privilege escalation |

---

### ✅ Best Practices

- Create **dedicated vendor roles per third party** — don’t reuse.
- Scope policies tightly (resources + actions).
- Always use **`sts:ExternalId`** for vendor-initiated AssumeRole.
- Set **short session duration** (≤ 1 hour, renew if needed).
- Enable **CloudTrail, GuardDuty, Access Analyzer** to monitor cross-account access.
- Rotate or delete vendor roles once engagement ends.
- Use **IAM Access Analyzer** to verify roles aren’t over-permissive or public.

---

### 💡 In short

Use **STS-based cross-account roles** with a **trust policy + ExternalId** to give third-party vendors **temporary, scoped, auditable access**.
✅ No static keys, minimal permissions, and revocable instantly — aligning with least-privilege and compliance best practices.

---

## Q: IAM Architecture Overview

---

### 🧠 Overview

**AWS Identity and Access Management (IAM)** is the **core access control layer** of AWS.
It defines **who (identities)** can **do what (actions)** on **which resources**, and **under what conditions** — using **policies** and **permissions boundaries**.

IAM is global, secure, and highly granular — forming the foundation for **least privilege**, **federation**, and **multi-account governance** in AWS.

---

### ⚙️ Purpose / How It Works

IAM provides:

- **Authentication** → Verifies _who_ the entity is (User, Role, Federated Identity).
- **Authorization** → Determines _what_ that entity can do (via policies).
- **Auditing** → Tracks _what happened_ (via CloudTrail, IAM Access Analyzer, Config).

All access decisions are based on **policy evaluation logic** combining:

```
Explicit Deny > Allow > Implicit Deny
```

---

### 🧩 Core IAM Components

| Component                           | Description                                                                        | Example                           |
| ----------------------------------- | ---------------------------------------------------------------------------------- | --------------------------------- |
| **IAM Users**                       | Named identities with long-term credentials                                        | `vasu-devops`                     |
| **IAM Groups**                      | Logical grouping of users for shared permissions                                   | `DevOps-Team`                     |
| **IAM Roles**                       | Identities with temporary credentials, assumable by AWS services or external users | `EKSNodeRole`, `CICDPipelineRole` |
| **Policies**                        | JSON documents defining permissions (Allow/Deny)                                   | `AmazonS3ReadOnlyAccess`          |
| **Permission Boundaries**           | Max permission limit for a user/role                                               | Restrict devs to non-prod actions |
| **Resource-Based Policies**         | Attached directly to AWS resources (e.g., S3, Lambda)                              | Allow cross-account S3 access     |
| **Trust Policies**                  | Define _who can assume_ a role                                                     | `Principal: ec2.amazonaws.com`    |
| **Identity Providers (Federation)** | External identity systems (SAML, OIDC, Cognito)                                    | Okta, Azure AD                    |
| **Access Analyzer**                 | Detects unintended public or cross-account access                                  | `Public S3 bucket alert`          |

---

### 🧩 IAM Architecture Diagram (Conceptual)

```
          +-------------------+                 +--------------------------+
          | External Identity |<----Federation--|  AWS IAM Identity Center  |
          |  (AD / Okta / IDP)|                 +--------------------------+
          +-------------------+
                   |
                   v
+------------------------------------------------------------+
|                     AWS IAM (Control Plane)                |
|                                                            |
|  +-------------+      +-------------+      +-------------+ |
|  | IAM Users   | ---> | IAM Groups  | ---> | IAM Policies| |
|  +-------------+      +-------------+      +-------------+ |
|          |                   |                    ^        |
|          v                   v                    |        |
|      +-------------+   +-------------+             |        |
|      | IAM Roles   |---| Trust Policy |<------------+        |
|      +-------------+   +-------------+                      |
|               |                                           |
|               v                                           |
|        +-----------------+                                |
|        | AWS Services    |<------- Resource Policies ------|
|        | (EC2, S3, etc.) |                                |
|        +-----------------+                                |
+------------------------------------------------------------+

            ↑               ↑               ↑
            |               |               |
            |               |               |
   CloudTrail Logs   IAM Access Analyzer   AWS Config Rules
     (Auditing)          (Visibility)         (Compliance)
```

---

### 🧩 IAM Policy Evaluation Flow

| Step | Evaluation Component         | Description                                              |
| ---- | ---------------------------- | -------------------------------------------------------- |
| 1️⃣   | Resource-based policy        | Check if resource explicitly allows or denies the action |
| 2️⃣   | SCP (Service Control Policy) | Check if org-level policy permits the action             |
| 3️⃣   | Permission boundary          | Check if within allowed scope                            |
| 4️⃣   | Identity-based policy        | Check user/group/role policies                           |
| 5️⃣   | Session policies             | Temporary session limits (STS/AssumeRole)                |
| 6️⃣   | Final Decision               | Allow only if at least one Allow and no explicit Deny    |

---

### 📋 IAM Deployment Models

| Model                                | Description                                                    | Typical Use Case       |
| ------------------------------------ | -------------------------------------------------------------- | ---------------------- |
| **Single Account IAM**               | All users/roles managed in one account                         | Small setups, dev/test |
| **Multi-Account with Organizations** | SCPs + central IAM identity control                            | Enterprises            |
| **Federated Access**                 | SSO via IDP (AD/Okta) → AssumeRole                             | Corporate workforce    |
| **Hybrid Model**                     | IAM users for CI/CD, roles for services, federation for humans | Standard cloud teams   |

---

### 📋 IAM Best Practices

| Category                 | Recommendation                                               |
| ------------------------ | ------------------------------------------------------------ |
| **Authentication**       | Enable MFA for all IAM and root users                        |
| **Authorization**        | Follow least privilege (grant only needed actions/resources) |
| **Access Control**       | Use IAM Roles instead of Users for applications              |
| **Separation of Duties** | Different roles for admin, deploy, and audit                 |
| **Governance**           | Apply SCPs and permission boundaries                         |
| **Audit & Monitoring**   | Enable CloudTrail, GuardDuty, IAM Access Analyzer            |
| **Federation**           | Integrate with SSO or external IdPs (SAML/OIDC)              |
| **Key Management**       | Avoid static access keys — use temporary credentials via STS |
| **Region Restriction**   | Use SCPs to restrict unauthorized region usage               |

---

### ✅ Best Practices in Production

- **Disable root access keys** (use only for billing if needed).
- **Use IAM roles for EC2, ECS, Lambda** instead of embedding keys.
- **Set IAM Access Analyzer + AWS Config rules** to detect misconfigurations.
- **Rotate access keys every ≤ 90 days** if absolutely needed.
- **Use session tagging & CloudTrail logs** for identity traceability.
- **Restrict high-privilege roles by IP, MFA, and approval workflows.**

---

### 💡 In short

AWS IAM is the **central identity and access layer** of AWS — controlling authentication, authorization, and auditing across all services.
✅ Use **roles (not users)** for workloads, **policies** for least privilege, and **SCPs + federation** for org-wide governance.
IAM = _“Who can do what, where, and when”_ — the backbone of AWS security architecture.

---

## 🧭 IAM Best Practices Overview

| **Category**                | **Recommendation**                                                                                                                                                                            |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 🧑‍💼 **Root Account**         | 🔒 Disable root access keys immediately, enable MFA, and never use the root account for daily operations. Use it **only for billing or account recovery**.                                    |
| 👥 **Users**                | 🚫 Avoid long-term IAM users. Prefer **IAM roles** or **SSO/federation (SAML/OIDC)** for human and application access.                                                                        |
| 🔑 **Access Keys**          | 🔄 Rotate access keys **every 90 days** (or less). Store securely in **AWS Secrets Manager** or **Parameter Store**, not in code or config files.                                             |
| 📜 **Policies**             | 🧩 Implement **least privilege** — grant only required actions on specific resources. Avoid `"Action": "*"` and `"Resource": "*"`. Use **permission boundaries** and **SCPs** for governance. |
| 🧾 **Auditing**             | 👀 Enable **AWS CloudTrail**, **Access Analyzer**, and **AWS Config** across all accounts for visibility, logging, and compliance monitoring. Send logs to a **centralized logging account**. |
| 🛡️ **Security**             | ✅ Enforce **MFA** for all IAM users, secure sensitive API calls with **AWS KMS**, and restrict actions via **IP-based or VPC-based** conditions (`aws:SourceIp`, `aws:SourceVpce`).          |
| ⚙️ **Automation**           | 🧱 Use **Terraform**, **AWS CDK**, or **CloudFormation** to automate IAM resource creation, enforce naming conventions, and maintain version control for policies and roles.                  |
| 🔁 **Cross-Account Access** | 🔐 Use **STS AssumeRole** for temporary access instead of sharing access keys. Add **ExternalId** in trust policies to prevent confused-deputy attacks.                                       |

---

### ✅ Additional Recommendations

| Area                       | Practice                                                                                  |
| -------------------------- | ----------------------------------------------------------------------------------------- |
| **Password Policy**        | Enforce complexity, minimum length (≥ 12), and rotation (≤ 90 days).                      |
| **Tagging**                | Tag IAM roles and users with `Owner`, `Environment`, and `Purpose` for governance.        |
| **Monitoring**             | Use **AWS Security Hub**, **GuardDuty**, and **CloudWatch Alarms** for anomaly detection. |
| **Permissions Management** | Use **IAM Access Advisor** to remove unused permissions regularly.                        |
| **Region Control**         | Use **SCPs** to restrict deployments to approved regions.                                 |
| **Incident Response**      | Keep a **break-glass admin role** with MFA and logging, but disabled by default.          |

---

### 💡 In short

AWS IAM best practices revolve around **least privilege, automation, and governance**:
✅ Use **roles instead of keys**, **MFA everywhere**, **automated policy management**, and **organization-wide SCPs** for consistent security across accounts.
IAM security = **Minimal access + Continuous auditing + Automated enforcement.**
