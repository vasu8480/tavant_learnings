# Load Balancer

## Q: What is a Load Balancer in AWS?

### 🧠 Overview

An **AWS Load Balancer (ELB)** automatically distributes incoming traffic across multiple targets (EC2 instances, containers, IPs, Lambda functions) in one or more Availability Zones.
It ensures **high availability**, **scalability**, and **fault tolerance** for applications.

---

### ⚙️ Purpose / How it Works

- Detects healthy targets using **health checks** and routes traffic only to them.
- Provides a **single DNS endpoint** for client access.
- Supports **auto-scaling** — adjusts backend capacity dynamically.
- Integrates tightly with **EKS, ECS, EC2, and Lambda**.
- Can operate in **public or internal** mode depending on subnet configuration.

---

### 🧩 Examples / Commands / Config snippets

#### **1️⃣ Types of AWS Load Balancers**

| Type                                | Layer       | Best For                 | Target Type      | Protocols Supported |
| ----------------------------------- | ----------- | ------------------------ | ---------------- | ------------------- |
| **ALB (Application Load Balancer)** | Layer 7     | HTTP/HTTPS apps          | EC2, ECS, Lambda | HTTP, HTTPS, gRPC   |
| **NLB (Network Load Balancer)**     | Layer 4     | TCP/UDP high performance | EC2, IP          | TCP, UDP, TLS       |
| **CLB (Classic Load Balancer)**     | Layer 4 & 7 | Legacy use               | EC2              | HTTP, HTTPS, TCP    |
| **GLB (Gateway Load Balancer)**     | Layer 3     | Security appliances      | IP               | IP packets          |

---

#### **2️⃣ Terraform Example (ALB)**

```hcl
resource "aws_lb" "app_lb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public[*].id
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path = "/health"
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
```

---

#### **3️⃣ AWS CLI Example**

```bash
aws elbv2 create-load-balancer \
  --name web-alb \
  --subnets subnet-1 subnet-2 \
  --security-groups sg-123456 \
  --type application
```

---

### ✅ Best Practices

- Use **ALB** for HTTP/HTTPS traffic with path or host-based routing.
- Use **NLB** for low-latency TCP/UDP traffic (databases, game servers).
- Always enable **cross-zone load balancing** for even distribution.
- Configure **access logs** and **CloudWatch metrics** for observability.
- Use **target groups per service** for microservices/ECS setups.
- Secure with **SSL certificates (ACM)** for HTTPS listeners.

---

### 💡 In short

AWS Load Balancer = single entry point + intelligent routing + fault tolerance.
Use ALB for web apps, NLB for performance-critical traffic, and enable health checks for reliability.

---

## Q: What are the Types of Load Balancers in AWS?

---

### 🧠 Overview

AWS offers multiple types of **Elastic Load Balancers (ELB)**, each designed for different layers of the OSI model and use cases.
They distribute incoming traffic across multiple targets to ensure **availability, scalability, and fault tolerance**.

---

### ⚙️ Purpose / How it Works

Each Load Balancer operates at a specific **network layer** and supports different **target types** and **protocols**.
They automatically detect healthy targets and route requests efficiently based on configured rules.

---

### 🧩 Load Balancer Types in AWS

| **Type**                            | **Layer (OSI)** | **Use Case**                            | **Target Type**      | **Protocols**     | **Features / Highlights**                                                  |
| ----------------------------------- | --------------- | --------------------------------------- | -------------------- | ----------------- | -------------------------------------------------------------------------- |
| **Application Load Balancer (ALB)** | Layer 7         | HTTP/HTTPS traffic                      | EC2, ECS, Lambda, IP | HTTP, HTTPS, gRPC | Path-based & host-based routing, WebSockets, WAF, native container support |
| **Network Load Balancer (NLB)**     | Layer 4         | TCP/UDP, TLS, high-performance apps     | EC2, IP              | TCP, UDP, TLS     | Extreme performance, static IP, low latency, TLS termination               |
| **Gateway Load Balancer (GLB)**     | Layer 3         | Network appliances (firewalls, IDS/IPS) | IP                   | IP                | Combines transparent network gateway + load balancing for inspection       |
| **Classic Load Balancer (CLB)**     | Layer 4/7       | Legacy EC2 applications                 | EC2                  | HTTP, HTTPS, TCP  | Basic routing, older generation, limited flexibility                       |

---

### 🧩 Terraform Example (ALB + NLB)

```hcl
# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-alb"
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
}

# Network Load Balancer
resource "aws_lb" "net_lb" {
  name               = "app-nlb"
  load_balancer_type = "network"
  subnets            = aws_subnet.private[*].id
}
```

---

### 🧩 AWS CLI Example

```bash
# Create Application Load Balancer
aws elbv2 create-load-balancer \
  --name app-alb \
  --type application \
  --subnets subnet-123 subnet-456

# Create Network Load Balancer
aws elbv2 create-load-balancer \
  --name app-nlb \
  --type network \
  --subnets subnet-789 subnet-101
```

---

### ✅ Best Practices

- Use **ALB** for web-based microservices (HTTP/HTTPS).
- Use **NLB** for database, streaming, or low-latency workloads.
- Use **GLB** when chaining **security appliances** or network middleboxes.
- Avoid **CLB** for new deployments (deprecated).
- Always enable **cross-zone load balancing** for even traffic spread.
- Use **AWS WAF + ALB** for application security.

---

### 💡 In short

AWS supports 4 load balancers: **ALB (Layer 7)**, **NLB (Layer 4)**, **GLB (Layer 3)**, and **CLB (legacy)**.
Choose based on your traffic type — ALB for web, NLB for performance, GLB for security, CLB only for backward compatibility.

---

## Q: What is the Default Port for ALB (Application Load Balancer)?

---

### 🧠 Overview

The **Application Load Balancer (ALB)** in AWS operates at **Layer 7 (Application Layer)** and supports HTTP and HTTPS traffic by default.
It listens on **standard web ports (80 and 443)** for client requests.

---

### ⚙️ Purpose / How it Works

- **Port 80** → Used for **HTTP** traffic (unencrypted).
- **Port 443** → Used for **HTTPS** traffic (encrypted with SSL/TLS).
- You can add **custom listener ports** (e.g., 8080, 8443) as needed.
- ALB forwards incoming requests to **target groups**, which have their own backend port mappings.

---

### 🧩 Example: Terraform Configuration

```hcl
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.ssl_cert.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
```

---

### 📋 Default ALB Listener Ports

| **Protocol** | **Default Port**       | **Description**                   |
| ------------ | ---------------------- | --------------------------------- |
| HTTP         | 80                     | Default web traffic (unencrypted) |
| HTTPS        | 443                    | Secure web traffic (TLS/SSL)      |
| Custom       | Any (e.g., 8080, 8443) | Optional, configurable            |

---

### ✅ Best Practices

- Always use **HTTPS (443)** with **ACM-managed certificates** for production.
- Redirect all **HTTP (80)** traffic to **HTTPS (443)** for security.
- Keep backend **target ports** (e.g., 8080) internal to your VPC.
- Monitor listener metrics (e.g., `HTTPCode_Target_5XX_Count`) in **CloudWatch**.

---

### 💡 In short

By default, **ALB listens on port 80 (HTTP)** and **443 (HTTPS)**.
Use 443 in production for encrypted traffic, and redirect 80 → 443 for secure access.

---

## Q: What is a Target Group in AWS?

---

### 🧠 Overview

A **Target Group** in AWS is a logical grouping of backend resources (like **EC2 instances, IP addresses, Lambda functions, or ECS tasks**) that a **Load Balancer** routes traffic to.
It acts as the connection point between your **Load Balancer** and **application targets**.

---

### ⚙️ Purpose / How it Works

- A **Load Balancer listener** forwards requests to a **Target Group**.
- Each Target Group defines:

  - **Target type** (EC2, IP, Lambda, etc.)
  - **Port and protocol** (e.g., HTTP:80 or HTTPS:443)
  - **Health check path** to verify target availability.

- Targets are registered dynamically (e.g., via Auto Scaling groups or ECS services).
- Only **healthy targets** receive traffic.

---

### 🧩 Example: Terraform Configuration

```hcl
resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
```

---

### 📋 Target Group Parameters

| **Parameter**  | **Description**                                | **Example**                   |
| -------------- | ---------------------------------------------- | ----------------------------- |
| `target_type`  | Defines what kind of targets can be registered | `instance`, `ip`, `lambda`    |
| `protocol`     | Communication protocol                         | `HTTP`, `HTTPS`, `TCP`, `UDP` |
| `port`         | Port on which targets receive traffic          | `80`, `443`, `8080`           |
| `health_check` | Verifies target health status                  | `/health`, `/status`          |
| `stickiness`   | Enables session stickiness                     | Cookie-based session affinity |

---

### 🧩 AWS CLI Example

```bash
aws elbv2 create-target-group \
  --name web-tg \
  --protocol HTTP \
  --port 80 \
  --vpc-id vpc-123456 \
  --target-type instance
```

```bash
aws elbv2 register-targets \
  --target-group-arn arn:aws:elasticloadbalancing:region:acct:targetgroup/web-tg/abc123 \
  --targets Id=i-0a12bc34d56ef78gh Id=i-0h87gf65d43cb21ji
```

---

### ✅ Best Practices

- Use **separate Target Groups** per microservice for better routing and scaling.
- Always configure **health checks** with dedicated endpoints (e.g., `/health`).
- For ECS/EKS, integrate with **service discovery** for dynamic registration.
- Use **IP target type** for **Fargate** or cross-AZ networking.
- Monitor **`HealthyHostCount`** and **`UnhealthyHostCount`** in CloudWatch.

---

### 💡 In short

A **Target Group** is where your Load Balancer sends traffic — it groups EC2s, IPs, or Lambdas and checks their health.
Think of it as the **bridge between your ALB/NLB and application backend**.

---

## Q: How Does ELB Check if a Target is Healthy?

---

### 🧠 Overview

An **Elastic Load Balancer (ELB)** continuously monitors the health of registered **targets** (EC2, ECS, IPs, or Lambdas) using **health checks**.
These checks determine whether traffic should be routed to a target — **only healthy targets receive requests**.

---

### ⚙️ Purpose / How it Works

1. **Health Check Configuration**

   - Defined per **Target Group**, not per Load Balancer.
   - ELB sends periodic requests (HTTP/TCP/HTTPS/GRPC) to targets.
   - The response determines if a target is **healthy** or **unhealthy**.

2. **Health Evaluation Logic**

   - ELB marks a target **healthy** after a specific number of successful checks (`healthy_threshold`).
   - Marks a target **unhealthy** after a specific number of failures (`unhealthy_threshold`).
   - Traffic is stopped to unhealthy targets until they recover.

3. **Health States**

   - `healthy` → Target responds successfully.
   - `unhealthy` → Target fails health checks.
   - `initial` → Health check just started or re-registered.
   - `unused` → Target not in use or deregistered.

---

### 🧩 Example: Terraform Health Check Configuration

```hcl
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200-302"
  }
}
```

---

### 🧩 AWS CLI Example

```bash
aws elbv2 describe-target-health \
  --target-group-arn arn:aws:elasticloadbalancing:region:acct:targetgroup/app-tg/abc123
```

Example output:

```json
{
  "TargetHealthDescriptions": [
    {
      "Target": { "Id": "i-0123456789abcdef0", "Port": 80 },
      "TargetHealth": { "State": "healthy" }
    }
  ]
}
```

---

### 📋 Key Health Check Parameters

| **Parameter**         | **Description**                        | **Typical Value** |
| --------------------- | -------------------------------------- | ----------------- |
| `protocol`            | Type of check (HTTP, HTTPS, TCP, GRPC) | HTTP              |
| `path`                | Endpoint to test                       | `/health`         |
| `interval`            | Time between checks (sec)              | 30                |
| `timeout`             | Max time to wait for response (sec)    | 5                 |
| `healthy_threshold`   | # of successes before marking healthy  | 3                 |
| `unhealthy_threshold` | # of failures before marking unhealthy | 2                 |
| `matcher`             | Expected HTTP status codes             | `200-302`         |

---

### ✅ Best Practices

- Always expose a **lightweight `/health` endpoint** in applications.
- Avoid performing DB or external calls inside health checks (keep them fast).
- Configure **grace period** for new instances during scaling.
- Monitor health metrics in **CloudWatch → ELB → TargetGroup metrics**.
- Use **different health check paths** for different services (e.g., `/api/health`).

---

### 💡 In short

ELB checks target health by **sending periodic requests (HTTP/TCP)** to a defined path or port.
If a target consistently passes, it’s marked **healthy**; if it fails multiple times, it’s marked **unhealthy** and traffic stops until it recovers.

---

## Q: What is a Listener in ELB?

---

### 🧠 Overview

A **Listener** in AWS Elastic Load Balancer (ELB) is a **logical component** that checks for **incoming client connection requests** using a specified **protocol and port**, and **forwards traffic** to one or more **Target Groups** based on configured **rules**.

Think of a **listener** as the **entry gate** for your ELB — it defines _how clients connect_ and _where the requests go_.

---

### ⚙️ Purpose / How it Works

1. **Listens for incoming requests** on a defined protocol/port (e.g., HTTP:80 or HTTPS:443).
2. **Evaluates listener rules** (like path or host-based routing).
3. **Routes requests** to appropriate Target Groups.
4. Supports **redirects, fixed responses, or forwarding** actions.

> 🔁 Multiple listeners can be configured per Load Balancer (e.g., one for HTTP and another for HTTPS).

---

### 🧩 Example: Terraform Configuration

```hcl
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.ssl_cert.arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
```

---

### 🧩 AWS CLI Example

```bash
aws elbv2 create-listener \
  --load-balancer-arn arn:aws:elasticloadbalancing:region:acct:loadbalancer/app/my-alb/123456 \
  --protocol HTTP \
  --port 80 \
  --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:region:acct:targetgroup/web-tg/abc123
```

---

### 📋 Listener Components

| **Component**       | **Description**                          | **Example**                 |
| ------------------- | ---------------------------------------- | --------------------------- |
| **Protocol**        | Protocol to listen on                    | HTTP / HTTPS / TCP / UDP    |
| **Port**            | Port number for incoming traffic         | 80 / 443                    |
| **Default Action**  | Action if no rule matches                | Forward to Target Group     |
| **Listener Rules**  | Conditions to match traffic (path, host) | `/api/* → app-tg`           |
| **SSL Policy**      | Defines SSL/TLS configuration for HTTPS  | `ELBSecurityPolicy-2016-08` |
| **Certificate ARN** | Required for HTTPS listeners             | ACM Certificate ARN         |

---

### ✅ Best Practices

- Always configure **HTTPS (443)** with **ACM-managed SSL** for production.
- Use **redirect rules** from HTTP (80) → HTTPS (443).
- Implement **path-based or host-based rules** for microservices.
- Keep **listener rules minimal** for fast evaluation.
- Use **CloudWatch metrics** (`ProcessedBytes`, `RequestCount`) for monitoring.

---

### 💡 In short

A **Listener** defines **how ELB accepts and routes traffic** — it listens on a port/protocol and forwards requests to target groups.
Example: ALB listens on **HTTP:80 / HTTPS:443**, applies routing rules, and sends traffic to the right backend service.

---

## Q: What is Cross-Zone Load Balancing in AWS?

---

### 🧠 Overview

**Cross-Zone Load Balancing** is an **Elastic Load Balancer (ELB)** feature that distributes incoming traffic **evenly across all targets in all Availability Zones (AZs)**, not just within the zone where the load balancer node is deployed.

Without it, each load balancer node routes traffic **only to targets in its own AZ**, which can lead to **uneven load** if target counts differ per zone.

---

### ⚙️ Purpose / How it Works

| **Scenario**      | **Without Cross-Zone LB**                     | **With Cross-Zone LB**                          |
| ----------------- | --------------------------------------------- | ----------------------------------------------- |
| Load Distribution | Each ELB node routes to targets in its own AZ | ELB nodes distribute traffic across **all AZs** |
| Result            | Uneven load if AZs have unequal target counts | Even distribution and better utilization        |

**How it works:**

1. The ELB creates nodes in each enabled AZ.
2. When Cross-Zone LB is enabled, each node can forward requests to **targets in any AZ**.
3. Improves **application availability and scaling** consistency.

---

### 🧩 Example: Terraform Configuration

```hcl
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id

  # Enable cross-zone load balancing
  enable_cross_zone_load_balancing = true
}
```

> For **ALB**: Enabled **by default** (and cannot be disabled).
> For **NLB**: Disabled by default but can be manually enabled.
> For **CLB**: Optional, can be toggled via console or CLI.

---

### 🧩 AWS CLI Example

```bash
aws elbv2 modify-load-balancer-attributes \
  --load-balancer-arn arn:aws:elasticloadbalancing:region:acct:loadbalancer/app/my-lb/123456 \
  --attributes Key=load_balancing.cross_zone.enabled,Value=true
```

---

### 📋 Cross-Zone Load Balancing Behavior

| **Load Balancer Type** | **Default State** | **Can be Modified?** | **Billing Impact**              |
| ---------------------- | ----------------- | -------------------- | ------------------------------- |
| **Application (ALB)**  | ✅ Enabled        | ❌ No (always on)    | No additional charge            |
| **Network (NLB)**      | ❌ Disabled       | ✅ Yes               | Data transfer across AZs billed |
| **Classic (CLB)**      | ❌ Disabled       | ✅ Yes               | No extra charge                 |

---

### ✅ Best Practices

- **Keep Cross-Zone enabled** to ensure balanced traffic across AZs.
- Combine with **Auto Scaling** for full multi-AZ resilience.
- Be aware of **inter-AZ data transfer costs** for NLBs.
- Always register **targets in multiple AZs** to prevent single-AZ dependency.

---

### 💡 In short

**Cross-Zone Load Balancing** allows ELB nodes to route traffic **across all AZs**, ensuring even load and higher resilience.
👉 ALB → always enabled, NLB → enable manually (extra inter-AZ cost), CLB → optional.

---

## Q: What is a Load Balancer DNS Name in AWS?

---

### 🧠 Overview

The **Load Balancer DNS name** is the **publicly accessible endpoint** automatically created by AWS when you launch an **Elastic Load Balancer (ELB)**.
It’s used by clients or applications to send requests to your load balancer — AWS then distributes this traffic to backend targets (EC2, ECS, etc.) based on configured listeners and rules.

---

### ⚙️ Purpose / How it Works

- AWS **automatically assigns** a **unique DNS name** when the ELB is created.
- This DNS name points to the ELB’s **entry point** — not to a static IP.
- The DNS record resolves to **multiple IP addresses** (per Availability Zone) for redundancy.
- You can **map this DNS name** to a custom domain via **Route 53 CNAME or Alias** record.

> 🔁 ELB DNS names are **region-specific**, **highly available**, and **don’t change** during the LB’s lifetime.

---

### 🧩 Example: DNS Name Format

| **ELB Type**                        | **Example DNS Name**                               |
| ----------------------------------- | -------------------------------------------------- |
| **Application Load Balancer (ALB)** | `my-alb-1234567890.ap-south-1.elb.amazonaws.com`   |
| **Network Load Balancer (NLB)**     | `my-nlb-abcdef123456.ap-south-1.elb.amazonaws.com` |
| **Classic Load Balancer (CLB)**     | `my-clb-123456789.ap-south-1.elb.amazonaws.com`    |

---

### 🧩 Terraform Example

```hcl
output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.app_lb.zone_id
}
```

Then map to Route53:

```hcl
resource "aws_route53_record" "app_record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "app.example.com"
  type    = "A"
  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }
}
```

---

### 🧩 AWS CLI Example

```bash
aws elbv2 describe-load-balancers \
  --names my-alb \
  --query "LoadBalancers[*].DNSName" \
  --output text
```

Output:

```
my-alb-1234567890.ap-south-1.elb.amazonaws.com
```

---

### 📋 Key Points

| **Property**        | **Description**                                      |
| ------------------- | ---------------------------------------------------- |
| **Auto-assigned**   | Created automatically when ELB is provisioned        |
| **Region-specific** | Includes AWS Region in the name (e.g., `ap-south-1`) |
| **Not Static IP**   | DNS resolves to multiple dynamic IPs                 |
| **Can be mapped**   | Use Route 53 Alias or CNAME for custom domains       |
| **Global Reach**    | DNS name is publicly resolvable (unless internal LB) |

---

### ✅ Best Practices

- Always use **Route 53 Alias records** instead of hardcoding the ELB DNS name.
- Avoid using the raw DNS in apps — map it to a friendly domain.
- Use **internal ALBs** for private traffic (DNS name only resolvable inside VPC).
- Monitor DNS resolution issues using **`dig` or `nslookup`** when debugging.

---

### 💡 In short

A **Load Balancer DNS name** is the **entry URL** AWS assigns to your ELB — e.g., `my-alb-xxxx.elb.amazonaws.com`.
You map it to your custom domain (via Route 53 Alias) so users can access your app seamlessly while AWS handles traffic routing and availability behind the scenes.

---

## Q: Can an ALB (Application Load Balancer) Have a Static IP?

---

### 🧠 Overview

By default, an **Application Load Balancer (ALB)** does **not** have a static or fixed IP address.
Instead, AWS assigns **dynamic IPs** that can **change** over time — but the **DNS name remains constant**.
This is because ALB scales horizontally and dynamically across multiple Availability Zones for **high availability**.

---

### ⚙️ Purpose / How it Works

- ALB DNS name resolves to **multiple IP addresses** behind the scenes.
- These IPs may change due to:

  - Scaling events (adding/removing nodes)
  - Maintenance or failover
  - AZ-level adjustments

To maintain connectivity, clients and systems should **use the DNS name**, not hard-coded IPs.

> 🧩 For applications that **require static IPs**, AWS recommends using a **Network Load Balancer (NLB)** instead.

---

### 🧩 Workarounds / Solutions

#### ✅ **Option 1: Use NLB in Front of ALB (Best Practice)**

Combine a **Network Load Balancer** (which supports static IPs) with an **ALB** behind it.

```text
Client → NLB (Static IP) → ALB → Target Group (EC2/ECS)
```

Terraform example:

```hcl
resource "aws_lb" "nlb" {
  name               = "static-nlb"
  load_balancer_type = "network"
  subnets            = aws_subnet.public[*].id
  enable_cross_zone_load_balancing = true
  subnet_mapping {
    subnet_id     = aws_subnet.public[0].id
    allocation_id = aws_eip.nlb_eip_1.id
  }
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 443
  protocol          = "TLS"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}
```

This setup provides **fixed Elastic IPs (EIPs)** for clients and still benefits from ALB’s Layer 7 routing.

---

#### ✅ **Option 2: Use Route 53 Alias Record**

Map the ALB’s **DNS name** to your custom domain using a Route 53 **Alias record**.
This ensures traffic stays routed correctly even if ALB IPs change.

```hcl
resource "aws_route53_record" "app_alias" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "app.example.com"
  type    = "A"
  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }
}
```

---

### 📋 Comparison Table

| **Feature**    | **Application LB (ALB)**  | **Network LB (NLB)**                       |
| -------------- | ------------------------- | ------------------------------------------ |
| **Static IPs** | ❌ Not supported          | ✅ Supported (EIP attachable)              |
| **Layer**      | 7 (HTTP/HTTPS)            | 4 (TCP/UDP/TLS)                            |
| **DNS Name**   | Auto-generated (constant) | Auto-generated (can resolve to static IPs) |
| **Use Case**   | Web apps, microservices   | Fixed-IP apps, VPNs, IoT, APIs             |

---

### ✅ Best Practices

- Always use **DNS names** for ALBs — never hard-code IPs.
- If static IPs are mandatory, **front your ALB with an NLB**.
- Use **Route 53 Alias records** for stable custom domains.
- Avoid directly exposing ALB IPs — they are not guaranteed to persist.

---

### 💡 In short

❌ **ALBs don’t support static IPs** — they use dynamic IPs behind a constant DNS name.
✅ For fixed IP requirements, **use a Network Load Balancer (NLB)** or **NLB → ALB architecture** for the best of both worlds.

---

## Q: What is the Difference Between Classic Load Balancer (CLB) and Application Load Balancer (ALB)?

---

### 🧠 Overview

Both **Classic Load Balancer (CLB)** and **Application Load Balancer (ALB)** are part of AWS’s **Elastic Load Balancing (ELB)** family, but they serve **different generations and layers** of the OSI model.
CLB is **legacy (Layer 4 & 7)**, while ALB is **modern (Layer 7)** — designed for **microservices, containers, and advanced routing**.

---

### ⚙️ Purpose / How it Works

- **CLB** distributes traffic at both Layer 4 (TCP) and Layer 7 (HTTP/HTTPS).
- **ALB** operates purely at Layer 7 (Application Layer), enabling **content-based routing**.
- ALB supports **modern app architectures** (ECS, EKS, Lambda), while CLB is for **legacy EC2 workloads**.

---

### 📋 Comparison Table

| **Feature**                   | **Classic Load Balancer (CLB)** | **Application Load Balancer (ALB)**             |
| ----------------------------- | ------------------------------- | ----------------------------------------------- |
| **Layer**                     | L4 (TCP) & L7 (HTTP/HTTPS)      | L7 (HTTP, HTTPS, gRPC)                          |
| **Use Case**                  | Legacy apps, EC2 monoliths      | Modern web apps, microservices, containers      |
| **Routing Type**              | Basic (no rules)                | Advanced (path-based, host-based)               |
| **Target Type**               | EC2 instances only              | EC2, ECS, EKS, IPs, Lambda                      |
| **Listener Rules**            | One listener, single action     | Multiple listeners with rule-based actions      |
| **HTTP/2 & gRPC**             | ❌ Not supported                | ✅ Supported                                    |
| **WebSockets**                | ❌ Not supported                | ✅ Supported                                    |
| **WAF Integration**           | ❌ No                           | ✅ Yes                                          |
| **Cross-Zone LB**             | Optional                        | Always enabled                                  |
| **Stickiness**                | Cookie or duration-based        | Cookie-based (app/session stickiness)           |
| **Access Logs & Metrics**     | Basic                           | Enhanced (CloudWatch, ALB logs, target metrics) |
| **SSL Termination**           | Supported                       | Supported (with SNI for multiple certs)         |
| **Dynamic Host Registration** | Manual                          | Automatic via Target Groups                     |
| **Container Support (ECS)**   | ❌ No                           | ✅ Yes                                          |
| **Lambda Targets**            | ❌ No                           | ✅ Yes                                          |
| **Pricing**                   | Based on hours & data processed | Based on LCUs (Load Balancer Capacity Units)    |

---

### 🧩 Example: ALB Routing Rule (Terraform)

```hcl
resource "aws_lb_listener_rule" "path_based" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}
```

➡️ ALB can direct `/api/*` traffic to one service and `/app/*` to another.

---

### 🧩 Example: CLB (Legacy Configuration)

```hcl
resource "aws_elb" "classic_lb" {
  name = "legacy-clb"
  subnets = aws_subnet.public[*].id
  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }
  health_check {
    target              = "HTTP:80/health"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
  }
}
```

➡️ CLB routes all HTTP traffic equally — no routing logic or rules.

---

### ✅ Best Practices

- ✅ Use **ALB** for modern workloads (ECS/EKS, HTTP routing, HTTPS offloading).
- ⚠️ Avoid **CLB** for new projects — it’s **legacy and limited**.
- Use **NLB** if you need **static IPs or TCP/UDP** support.
- Enable **WAF with ALB** for security filtering.
- Use **target groups** for flexible scaling and health checks.

---

### 💡 In short

| **CLB** → Legacy, basic L4/L7 load balancing — use only for old EC2-based apps. |
| **ALB** → Modern Layer 7 load balancer — supports microservices, containers, and intelligent routing. |
👉 Always prefer **ALB** for new deployments — it’s more secure, flexible, and cloud-native.

---

## Q: What is Path-Based Routing in AWS ALB?

---

### 🧠 Overview

**Path-Based Routing** (also known as **URL-based routing**) is a feature of the **Application Load Balancer (ALB)** that routes incoming HTTP/HTTPS requests to different **Target Groups** based on the **URL path** of the request.

This allows you to run **multiple services (microservices or APIs)** behind a single ALB — each handling a specific path like `/api`, `/auth`, `/images`, etc.

---

### ⚙️ Purpose / How it Works

1. The ALB **listener** (e.g., port 80 or 443) receives client requests.
2. **Listener rules** inspect the request path (e.g., `/app/*`, `/api/*`).
3. Based on the path condition, traffic is **forwarded** to the corresponding **Target Group**.
4. If no rule matches, the **default action** (e.g., main web app) is applied.

Example Flow:

```
/api/*  →  API Target Group
/images/*  →  Image Service Target Group
/*  →  Default Web App Target Group
```

---

### 🧩 Example: Terraform Configuration

```hcl
resource "aws_lb_listener_rule" "path_based" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}

resource "aws_lb_listener_rule" "default" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
```

---

### 🧩 Example: AWS Console Configuration

**Listener → Add Rule → Path-based routing:**

- `/api/*` → Target Group: `api-tg`
- `/images/*` → Target Group: `img-tg`
- Default → Target Group: `web-tg`

---

### 📋 Comparison Table

| **Feature**                 | **Description**                      | **Example**                    |
| --------------------------- | ------------------------------------ | ------------------------------ |
| **Routing Criteria**        | URL Path                             | `/api/*`, `/app/*`, `/login`   |
| **Supported Load Balancer** | ALB only (Layer 7)                   | –                              |
| **Action**                  | Forward, Redirect, or Fixed Response | Forward to different TGs       |
| **Default Action**          | Used if no rule matches              | `/` or catch-all               |
| **Use Case**                | Microservices, modular web apps      | `/api` → API TG, `/ui` → UI TG |

---

### ✅ Best Practices

- Always include a **default rule** (`/*`) for unmatched requests.
- Use **priority numbers** carefully — lower = higher precedence.
- Combine with **host-based routing** for multi-domain apps.
- Keep path conditions specific (`/api/*` > `/app/*` > `/*`).
- Use **health checks** per target group for isolated fault tolerance.

---

### 💡 In short

**Path-Based Routing** in ALB lets you **route requests by URL path** — e.g., `/api/*` → API service, `/app/*` → Web app.
It’s perfect for **microservice or multi-app architectures**, allowing one ALB to handle many services efficiently.

---

---

## Q: Can an ALB Forward Traffic to Lambda Functions?

---

### 🧠 Overview

Yes ✅ — an **Application Load Balancer (ALB)** can **forward traffic directly to AWS Lambda functions** as a **target type** in a **Target Group**.
This makes it possible to serve **serverless applications** (HTTP-based) behind an ALB, providing a unified entry point for **EC2, ECS, EKS, and Lambda** backends together.

---

### ⚙️ Purpose / How it Works

1. You create a **Target Group** with `target_type = "lambda"`.
2. The **ALB listener** receives incoming HTTP(S) requests.
3. ALB **invokes the Lambda function synchronously** and passes request data (headers, path, method, body, etc.) as a JSON payload.
4. Lambda processes the request and returns a **standard HTTP response (status code, headers, body)** to the ALB.
5. The ALB sends that response back to the client.

---

### 🧩 Example: Terraform Configuration

```hcl
resource "aws_lb_target_group" "lambda_tg" {
  name         = "lambda-target-group"
  target_type  = "lambda"
}

resource "aws_lambda_permission" "alb_invoke_permission" {
  statement_id  = "AllowALBInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.lambda_tg.arn
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lambda_tg.arn
  }
}
```

---

### 🧩 Example: Lambda Request Payload (from ALB)

```json
{
  "httpMethod": "GET",
  "path": "/api/health",
  "headers": {
    "host": "my-alb-123.ap-south-1.elb.amazonaws.com",
    "user-agent": "curl/7.64.1"
  },
  "queryStringParameters": {
    "name": "Vasu"
  },
  "body": null,
  "isBase64Encoded": false
}
```

### Example Lambda Response

```json
{
  "statusCode": 200,
  "statusDescription": "200 OK",
  "isBase64Encoded": false,
  "headers": { "Content-Type": "application/json" },
  "body": "{\"message\": \"Hello from Lambda via ALB!\"}"
}
```

---

### 📋 Key Features

| **Feature**             | **Description**                                           |
| ----------------------- | --------------------------------------------------------- |
| **Target Type**         | `lambda`                                                  |
| **Invocation Type**     | Synchronous                                               |
| **Protocols Supported** | HTTP, HTTPS                                               |
| **Payload Format**      | JSON event (includes headers, method, query, etc.)        |
| **Scaling**             | Automatic via Lambda concurrency                          |
| **Timeout**             | Limited to Lambda’s max timeout (15 mins)                 |
| **Security**            | IAM permission (`lambda:InvokeFunction`) required for ALB |

---

### ✅ Best Practices

- Use **Lambda for lightweight, stateless** HTTP APIs.
- Configure **reserved concurrency** to control scaling behavior.
- Return proper **HTTP headers** (`Content-Type`, `CORS`, etc.) in Lambda response.
- Use **custom domain + Route 53 alias** to simplify ALB access.
- Monitor with **CloudWatch logs** and **ALB target metrics** (`TargetResponseTime`).

---

### 💡 In short

Yes — **ALB can directly invoke Lambda functions** by defining a **Lambda target group**.
It enables **serverless web APIs** behind a standard ALB endpoint, unifying EC2, ECS, and Lambda under one scalable load balancer.

---

## Q: How Do You Enable SSL Termination in AWS (ALB/ELB)?

---

### 🧠 Overview

**SSL Termination** means the **Load Balancer handles HTTPS decryption** (TLS handshake) instead of your backend servers.
In AWS, this is done at the **Application Load Balancer (ALB)** or **Classic Load Balancer (CLB)** using **SSL certificates** (usually managed via **AWS Certificate Manager – ACM**).

This setup simplifies SSL management and improves backend performance since traffic between ALB and targets can use plain HTTP.

---

### ⚙️ Purpose / How It Works

1. **Client → ALB:**

   - Client connects via HTTPS (port 443).
   - ALB presents the SSL certificate and decrypts the request.

2. **ALB → Target Group:**

   - ALB forwards decrypted HTTP traffic (port 80) to backend targets.

3. Optionally, you can use **re-encryption (HTTPS → HTTPS)** if you need end-to-end encryption.

> 🔒 SSL termination centralizes certificate management and reduces CPU overhead on EC2/ECS instances.

---

### 🧩 Example: Terraform Configuration (SSL Termination on ALB)

```hcl
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.alb_sg.id]
}

# HTTPS Listener (SSL Termination)
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.app_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# HTTP → HTTPS Redirect (Optional)
resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
```

---

### 🧩 AWS CLI Example

```bash
aws elbv2 create-listener \
  --load-balancer-arn arn:aws:elasticloadbalancing:region:acct:loadbalancer/app/my-alb/123456 \
  --protocol HTTPS \
  --port 443 \
  --certificates CertificateArn=arn:aws:acm:region:acct:certificate/abc123 \
  --ssl-policy ELBSecurityPolicy-2016-08 \
  --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:region:acct:targetgroup/web-tg/xyz987
```

---

### 📋 Key Components

| **Component**             | **Purpose**                    | **Example / Notes**                       |
| ------------------------- | ------------------------------ | ----------------------------------------- |
| **ACM Certificate**       | SSL/TLS certificate for HTTPS  | Issued via AWS Certificate Manager        |
| **Listener Port**         | Port 443                       | Used for HTTPS traffic                    |
| **Protocol**              | HTTPS                          | ALB decrypts SSL traffic                  |
| **SSL Policy**            | Defines TLS version & ciphers  | `ELBSecurityPolicy-2016-08`               |
| **Certificate ARN**       | Identifies the SSL cert in ACM | Needed for listener config                |
| **Target Group Protocol** | HTTP or HTTPS                  | HTTP → termination, HTTPS → re-encryption |

---

### ✅ Best Practices

- Always use **AWS ACM** for certificate management (auto-renewal).
- Redirect **HTTP (80)** → **HTTPS (443)** for secure access.
- Use **modern SSL policies** (`ELBSecurityPolicy-TLS-1-2-2017-01` or newer).
- Store and rotate **private certs securely** (if using imported ones).
- For sensitive data, use **end-to-end encryption (HTTPS → HTTPS)**.

---

### 💡 In short

**SSL termination** means ALB decrypts HTTPS traffic using an ACM-managed certificate on port **443**, then forwards plain HTTP to backend targets.
It simplifies cert management, improves performance, and provides centralized TLS handling — the standard setup for production web apps in AWS.

---

## Q: What is SSL Passthrough?

---

### 🧠 Overview

**SSL Passthrough** is a load balancing technique where **encrypted HTTPS traffic is passed directly to backend servers without decryption** at the Load Balancer.
In this mode, the **SSL/TLS handshake** and **certificate management** occur **on the backend (EC2/ECS/Nginx/etc.)**, not on the Load Balancer.

Unlike **SSL Termination**, the Load Balancer acts purely as a **TCP proxy** — it doesn’t inspect, decrypt, or modify traffic.

---

### ⚙️ Purpose / How It Works

1. **Client → Load Balancer (TCP 443):**

   - Client initiates an SSL/TLS handshake.
   - The Load Balancer **forwards encrypted packets** without decrypting.

2. **Load Balancer → Backend:**

   - Backend server (e.g., Nginx, Apache, ECS task) completes the SSL handshake.

3. **Decryption happens only at the backend**, preserving full end-to-end encryption.

> ⚙️ Used when you need **end-to-end encryption** and want to keep private keys **only on backend servers**.

---

### 🧩 Example: Network Load Balancer (NLB) SSL Passthrough

Only **Network Load Balancer (Layer 4)** supports SSL passthrough since it operates at the **TCP/connection level**.

```hcl
resource "aws_lb" "nlb" {
  name               = "nlb-ssl-passthrough"
  load_balancer_type = "network"
  subnets            = aws_subnet.public[*].id
}

resource "aws_lb_target_group" "https_tg" {
  name     = "https-target-group"
  port     = 443
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "tcp_443" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.https_tg.arn
  }
}
```

In this setup:

- NLB forwards encrypted HTTPS traffic to backend servers.
- Each backend must have its own **SSL certificate** and handle **TLS termination**.

---

### 📋 SSL Termination vs SSL Passthrough

| **Feature**                     | **SSL Termination**             | **SSL Passthrough**                        |
| ------------------------------- | ------------------------------- | ------------------------------------------ |
| **Where Decryption Happens**    | At Load Balancer                | At Backend Server                          |
| **Supported By**                | ALB, CLB                        | NLB (Layer 4)                              |
| **Load Balancer Layer**         | Layer 7                         | Layer 4                                    |
| **Performance**                 | Lower backend CPU usage         | Higher backend CPU usage                   |
| **Visibility (Headers, Paths)** | Can inspect & route by URL/host | Cannot inspect encrypted payload           |
| **End-to-End Encryption**       | Optional                        | Always preserved                           |
| **Cert Management**             | Centralized at LB               | Decentralized (each target needs certs)    |
| **Use Case**                    | Web apps, public HTTPS sites    | Compliance, strict encryption (PCI, HIPAA) |

---

### ✅ Best Practices

- Use **SSL Passthrough** when **security compliance** demands that the Load Balancer cannot see or terminate SSL traffic.
- Ensure **backend servers** have valid and updated certificates.
- Use **NLB with TCP listeners** for passthrough scenarios.
- Combine with **ALB behind NLB** for mixed traffic — NLB (TLS passthrough) → ALB (app routing).
- Monitor using **VPC Flow Logs** or **target-side metrics**, since LB cannot see decrypted data.

---

### 💡 In short

**SSL Passthrough** forwards encrypted HTTPS traffic directly to backend servers — the Load Balancer doesn’t decrypt or inspect it.
It’s used for **strict end-to-end encryption** scenarios and is supported by **Network Load Balancers (NLB)** at **Layer 4**.

---

## Q: How do you enable stickiness (session persistence)?

---

### 🧠 Overview

**Stickiness (session persistence)** ensures a client’s requests are consistently routed to the same backend target (or target group) for a configurable time window. AWS supports multiple stickiness types depending on LB type: **ALB** (load-balancer or app cookies), **CLB** (classic cookies), and **NLB** (client IP affinity / target-group stickiness). ([AWS Documentation][1])

---

### ⚙️ Purpose / How it Works

- **ALB (Application Load Balancer)**: stickiness is configured on the **Target Group**. Types:

  - `lb_cookie` — ALB inserts a cookie (AWSALB…) and honors `duration_seconds`.
  - `app_cookie` — ALB uses an application-supplied cookie name and duration. ([AWS Documentation][1])

- **CLB (Classic Load Balancer)**: supports **load-balancer generated** (`AWSELB`) and **application-generated** cookies; configured per listener/policy. ([AWS Documentation][2])
- **NLB (Network Load Balancer)**: supports **target-group stickiness / client IP affinity** for TCP/UDP listeners (affinity based on source IP / configured attributes). ([AWS Documentation][3])

---

### 🧩 Examples / Commands / Config snippets

#### 1) ALB — Terraform (target group stickiness)

```hcl
resource "aws_lb_target_group" "web_tg" {
  name       = "web-tg"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.main.id

  stickiness {
    enabled         = true
    type            = "lb_cookie"       # or "app_cookie"
    cookie_duration = 3600              # seconds (1 hour)
    # when type="app_cookie" add: cookie_name = "MYAPPSESSION"
  }
}
```

(Stickiness is a target-group attribute for ALB.) ([Terraform Registry][4])

#### 2) ALB — AWS CLI (modify attributes)

```bash
aws elbv2 modify-target-group-attributes \
  --target-group-arn <tg-arn> \
  --attributes Key=stickiness.enabled,Value=true \
               Key=stickiness.type,Value=lb_cookie \
               Key=stickiness.lb_cookie.duration_seconds,Value=3600
```

(Enables LB-generated cookie with 3600s TTL.) ([AWS Documentation][5])

#### 3) Classic ELB — AWS CLI (create lb cookie policy)

```bash
aws elb create-lb-cookie-stickiness-policy \
  --load-balancer-name my-classic-elb \
  --policy-name my-lb-cookie-policy \
  --cookie-expiration-period 3600

aws elb set-load-balancer-policies-of-listener \
  --load-balancer-name my-classic-elb \
  --load-balancer-port 80 \
  --policy-names my-lb-cookie-policy
```

(CLASSIC uses AWSELB/app cookies.) ([AWS Documentation][2])

#### 4) NLB — AWS CLI (enable target-group stickiness)

```bash
aws elbv2 modify-target-group-attributes \
  --target-group-arn <nlb-tg-arn> \
  --attributes Key=stickiness.enabled,Value=true \
               Key=stickiness.type,Value=source_ip \
               Key=stickiness.lb_cookie.duration_seconds,Value=86400
```

(Note: NLB stickiness behavior = client IP affinity / target-group attribute — confirm supported attributes for your target type). ([AWS Documentation][3])

---

### 📋 Parameters / Differences Table

| **LB Type** | **Stickiness Type**              | **Configured On**       | **Cookie Name / Affinity**       | **Where Used**                                                         |
| ----------- | -------------------------------- | ----------------------- | -------------------------------- | ---------------------------------------------------------------------- |
| ALB         | `lb_cookie` or `app_cookie`      | Target Group            | `AWSALB` (LB) or app cookie name | HTTP/HTTPS apps (Layer 7) ([AWS Documentation][1])                     |
| CLB         | LB or App cookie                 | Listener / Policy       | `AWSELB` or app cookie           | Legacy EC2 HTTP/HTTPS (classic) ([AWS Documentation][2])               |
| NLB         | `source_ip` (client IP affinity) | Target Group Attributes | affinity via client IP           | TCP/UDP (Layer 4) — preserves client affinity ([AWS Documentation][3]) |

---

### ✅ Best Practices

- Prefer **ALB target-group stickiness** for HTTP session affinity (cookie-based). ([AWS Documentation][1])
- Keep **health checks light**; sticky sessions should not hide unhealthy targets.
- Set reasonable `cookie_duration` (balance UX vs. load distribution).
- For stateless or scalable architectures, prefer **stateless sessions (JWT / shared cache / DB)** over long stickiness.
- If compliance requires IP affinity, use **NLB** and document implications (cross-AZ, costs). ([AWS Documentation][3])

---

### ⚠️ Caveats / Notes

- Stickiness can reduce even load distribution — monitor `HealthyHostCount` and latency.
- ALB `app_cookie` requires the app to set a cookie name; ALB will honor it. ([AWS Documentation][1])
- Not all target types (e.g., some Lambda configurations) make sense with stickiness — check docs for target-type support. ([AWS Documentation][6])

---

### 💡 In short

Enable stickiness on the **target group** for ALB (use `lb_cookie` or `app_cookie`), on **listener policies** for CLB (`AWSELB`/app cookie), and via **target-group attributes** for NLB (client-IP affinity). Configure TTL (`duration_seconds`) and monitor load/health closely. ([AWS Documentation][1])

[1]: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/edit-target-group-attributes.html?utm_source=chatgpt.com "Edit target group attributes for your Application Load Balancer"
[2]: https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-sticky-sessions.html?utm_source=chatgpt.com "Configure sticky sessions for your Classic Load Balancer"
[3]: https://docs.aws.amazon.com/elasticloadbalancing/latest/network/edit-target-group-attributes.html?utm_source=chatgpt.com "Edit target group attributes for your Network Load Balancer"
[4]: https://registry.terraform.io/providers/hashicorp/aws/2.58.0/docs/resources/lb_target_group?utm_source=chatgpt.com "aws_lb_target_group | Resources | hashicorp/aws | Terraform"
[5]: https://docs.aws.amazon.com/cli/latest/reference/elbv2/modify-target-group-attributes.html?utm_source=chatgpt.com "modify-target-group-attributes"
[6]: https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_TargetGroupAttribute.html?utm_source=chatgpt.com "TargetGroupAttribute - Elastic Load Balancing"

---

## Q: How do you integrate ALB with ECS?

---

### 🧠 Overview

Integrating an **Application Load Balancer (ALB)** with **ECS** lets you expose containerized services (EC2 or Fargate) via HTTP/HTTPS with path/host routing, health checks, and autoscaling.
Key pieces: **ALB (listener + target group)** + **ECS task definition** + **ECS service** (registers tasks with the target group).

---

### ⚙️ Purpose / How it Works

- **ALB** receives client requests (HTTP/HTTPS) and forwards them to a **Target Group**.
- **ECS Service** registers each running task as a target (IP or instance) in that Target Group.
- **Health checks** on the Target Group determine target availability.
- Use **path/host rules** to route multiple services through one ALB.
- For **Fargate/awsvpc** use `target_type = "ip"`; for EC2 tasks use `target_type = "instance"`.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Terraform (Fargate — ALB + TG + Listener + ECS service)

```hcl
# ALB
resource "aws_lb" "alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]
}

# Target Group (for Fargate use ip)
resource "aws_lb_target_group" "web_tg" {
  name        = "web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"               # use "instance" for EC2 launch type

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# ECS Task Definition (Fargate) - minimal example
resource "aws_ecs_task_definition" "web" {
  family                   = "web-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "web"
      image     = "nginx:stable"
      portMappings = [{ containerPort = 80, protocol = "tcp" }]
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 10
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/web"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# ECS Service connecting to ALB target group
resource "aws_ecs_service" "web" {
  name            = "web-svc"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.svc_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web_tg.arn
    container_name   = "web"
    container_port   = 80
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  depends_on = [aws_lb_listener.http]
}
```

> Notes:
>
> - For **EC2** tasks (bridge/host), set `target_type = "instance"` and `portMappings` accordingly.
> - Ensure ALB security group allows inbound 80/443 from the internet and ECS service SG allows traffic from ALB SG.

---

#### 2) AWS CLI: create TG + register target example (EC2)

```bash
# create tg
aws elbv2 create-target-group \
  --name web-tg \
  --protocol HTTP \
  --port 80 \
  --vpc-id vpc-012345 \
  --target-type instance

# register instance(s)
aws elbv2 register-targets \
  --target-group-arn arn:aws:elasticloadbalancing:...:targetgroup/web-tg/abc \
  --targets Id=i-0123456789abcdef0 Id=i-0fedcba9876543210
```

---

#### 3) Minimal ECS Task Definition (container JSON snippet)

```json
"containerDefinitions": [
  {
    "name": "web",
    "image": "myrepo/web:latest",
    "portMappings": [{ "containerPort": 80 }],
    "essential": true
  }
]
```

ECS Service `loadBalancers` field must reference the ALB target group ARN and container name/port.

---

### 📋 Parameters / Checklist (what to configure)

| Item                              | Where / Why                                                               |
| --------------------------------- | ------------------------------------------------------------------------- |
| Target Group `target_type`        | `ip` for Fargate/awsvpc, `instance` for EC2                               |
| Health check path                 | Target Group → keep lightweight (`/health`)                               |
| Security groups                   | ALB SG: allow 80/443; Service SG: allow ALB SG inbound                    |
| Listener                          | ALB listener on 80/443 forwarding to TG                                   |
| ECS Service `load_balancer` block | Registers tasks into TG automatically                                     |
| IAM roles                         | Task execution role (ECR, CloudWatch logs) & ECS service role if required |
| Subnets                           | ALB in public subnets; Fargate tasks in private subnets (awsvpc)          |

---

### ✅ Best Practices

- Use **awsvpc** networking for predictable IPs and security group control (Fargate).
- Use **target_type = "ip"** for Fargate services.
- Create **one target group per service** (simpler health checks, separate scaling).
- Keep health check endpoints lightweight and fast (avoid DB calls).
- Use **path/host-based listener rules** to host multiple services behind one ALB.
- Use **Route 53 alias** for a friendly domain name (point to ALB DNS).
- Secure with **HTTPS (ACM cert)** on the ALB and optionally re-encrypt to backend if required.
- Monitor `TargetResponseTime`, `HealthyHostCount`, and `HTTPCode_Target_5XX_Count` in CloudWatch.
- For zero-downtime deploys, tune ECS deployment `minimum_healthy_percent` and `maximum_percent`.

---

### 💡 In short

Register each ECS task with an ALB **target group** via the ECS **service** (`load_balancer` block).
Use `target_type="ip"` for Fargate (`awsvpc`) or `instance` for EC2, configure lightweight health checks, and secure listeners with HTTPS.

---

## Q: How do you handle WebSocket traffic?

---

### 🧠 Overview

WebSockets are **long-lived, bidirectional TCP connections** used for real-time apps (chat, live updates). In AWS you can handle WebSocket traffic via **ALB (Layer-7 HTTP Upgrade)**, **NLB (Layer-4 TCP passthrough)**, or managed services like **API Gateway WebSocket** — choose based on routing needs, TLS termination, and scaling/latency requirements.

---

### ⚙️ Purpose / How it Works

- **ALB**: supports the HTTP `Upgrade: websocket` flow (HTTP/1.1 Upgrade). ALB terminates TLS (optional), inspects HTTP headers, and forwards the upgraded TCP stream to targets. Good when you need path/host routing, WAF, or ALB features.
- **NLB**: acts as pure TCP proxy (passthrough). Best for lowest latency, static IPs, or when you need true end-to-end TLS/termination at backend.
- **API Gateway (WebSocket)**: serverless WebSocket management, connection lifecycle and built-in message routing — useful for serverless backends but with different semantics and costs.
- **Key operational concerns**: idle timeouts, connection limits, health checks, sticky sessions (if needed), TLS handling, and metrics/logging.

---

### 🧩 Examples / Commands / Config snippets

#### 1) ALB — Terraform (listener + target group)

```hcl
resource "aws_lb" "alb" {
  name               = "ws-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "ws_tg" {
  name        = "ws-tg"
  port        = 3000
  protocol    = "HTTP"          # ALB requires HTTP/HTTPS for upgrade
  vpc_id      = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ws_tg.arn
  }
}
```

**Note:** ALB default idle timeout = **60s** — increase if connections remain idle longer (see best practices).

---

#### 2) NLB — Terraform (TCP passthrough)

```hcl
resource "aws_lb" "nlb" {
  name               = "ws-nlb"
  load_balancer_type = "network"
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "nlb_tg" {
  name     = "nlb-ws-tg"
  port     = 443
  protocol = "TCP"
  vpc_id   = var.vpc_id
}
```

**Use when:** you want static IPs (EIP), minimal latency, or backend TLS termination.

---

#### 3) Node.js WebSocket server (simple)

```js
// server.js
const http = require("http");
const WebSocket = require("ws");

const server = http.createServer((req, res) => res.end("ok"));
const wss = new WebSocket.Server({ server });

wss.on("connection", (ws) => {
  ws.on("message", (msg) => ws.send(`echo: ${msg}`));
});

server.listen(3000);
```

Containerize and expose port `3000`; register tasks in ALB target group (protocol HTTP).

---

#### 4) Test a websocket (wscat)

```bash
# install: npm i -g wscat
wscat -c wss://app.example.com/socket    # ALB with TLS
wscat -c ws://nlb-static-ip:443           # NLB passthrough (if backend accepts plain WS/TLS on 443)
```

---

### 📋 Comparison Table (ALB vs NLB vs API Gateway WebSocket)

| **Feature**       | **ALB**                                 | **NLB**                             | **API Gateway (WebSocket)**           |
| ----------------- | --------------------------------------- | ----------------------------------- | ------------------------------------- |
| Layer             | 7 (HTTP Upgrade)                        | 4 (TCP)                             | Managed WebSocket API                 |
| TLS termination   | Yes (on ALB)                            | Optional (passthrough)              | Yes (managed)                         |
| Path/Host routing | ✅                                      | ❌                                  | ❌ (message routing via routes)       |
| Static IPs        | ❌ (DNS)                                | ✅ (EIP)                            | ❌                                    |
| Idle timeout      | Default 60s (configurable)              | No LB idle timeout                  | Managed                               |
| Best for          | WebSocket apps needing HTTP routing/WAF | Low latency, static IP, backend TLS | Serverless WS with built-in lifecycle |
| Scaling           | Managed                                 | Managed                             | Managed, but different scaling model  |

---

### ✅ Best Practices

- **Choose ALB** if you need path/host routing, WAF, or certificate centralization. Use **NLB** when you need static IPs or minimal latency.
- **Increase ALB idle timeout** if you expect long idle periods: ALB default is 60s — adjust via `modify-load-balancer-attributes` or Terraform provider attr.
- **Backend must support connection concurrency** — size instances/tasks for concurrent sockets; use connection pooling metrics.
- **Use sticky sessions cautiously** — WebSockets are stateful; prefer shared session store (Redis) for horizontal scaling.
- **Health checks**: use a lightweight HTTP health endpoint; do not rely on WebSocket handshake as health check.
- **TLS**: centralize certs on ALB for easier management; if passthrough (NLB), manage certs on targets.
- **Logging & metrics**: monitor `ActiveConnectionCount`, `TargetResponseTime`, NLB flow logs, and backend socket errors.
- **Connection draining / graceful shutdown**: implement SIGTERM handlers to close sockets gracefully before task termination.
- **Limits**: be aware of per-instance and per-service connection limits; configure autoscaling appropriately.

---

### 💡 In short

- Use **ALB** for WebSockets when you need HTTP routing/WAF and can accept ALB’s idle timeout (configurable).
- Use **NLB** for ultra-low latency or static IPs (TLS passthrough).
- Ensure backends handle many concurrent connections, increase idle timeouts, and implement graceful shutdown and proper health checks.

---

## Q: How Does NLB Differ from ALB in Terms of Performance?

---

### 🧠 Overview

Both **Network Load Balancer (NLB)** and **Application Load Balancer (ALB)** are part of AWS’s Elastic Load Balancing (ELB) family, but they differ significantly in **layer, latency, throughput, and performance behavior**.
Simply put:

> 🧩 **NLB = raw speed (Layer 4, TCP/UDP)**
> 🧩 **ALB = smart routing (Layer 7, HTTP/HTTPS)**

---

### ⚙️ Purpose / How It Works

| **Aspect**              | **NLB (Network Load Balancer)**                               | **ALB (Application Load Balancer)**                                |
| ----------------------- | ------------------------------------------------------------- | ------------------------------------------------------------------ |
| **OSI Layer**           | Layer 4 (TCP, UDP, TLS)                                       | Layer 7 (HTTP, HTTPS, gRPC)                                        |
| **Traffic Handling**    | Passes packets directly to targets with minimal overhead      | Terminates HTTP/S, inspects headers, and routes intelligently      |
| **Processing Overhead** | Very low (packet forwarding)                                  | Higher (header parsing, SSL termination, routing rules)            |
| **Throughput**          | Millions of requests/sec                                      | Hundreds of thousands of requests/sec (depends on rule complexity) |
| **Latency**             | Sub-millisecond (≈ 200–400 µs)                                | Slightly higher (≈ 2–5 ms typical)                                 |
| **TLS Termination**     | Optional (can do passthrough or termination)                  | Always terminates SSL/TLS                                          |
| **Scaling**             | Instantly scales to extreme load spikes                       | Scales fast, but slightly slower due to rule evaluation            |
| **Connection Type**     | Long-lived TCP/UDP                                            | Short-lived HTTP(s) connections                                    |
| **Ideal Use Case**      | Low-latency, high-throughput workloads (gRPC, DB, IoT, games) | Web apps, APIs, microservices (routing, WAF, HTTP headers)         |

---

### 🧩 Real-World Example

#### **NLB Performance Case**

- Used for **financial trading**, **real-time telemetry**, or **gaming servers**.
- Handles **>1 million concurrent connections** with very low jitter.
- Supports **static IPs / EIPs**, useful for firewall whitelisting.

#### **ALB Performance Case**

- Used for **web applications, REST APIs, ECS/EKS services**.
- Inspects headers for **path/host routing, authentication, redirects, WAF filtering**.
- Slightly higher latency due to **TLS termination and L7 rule evaluation**, but **optimized for HTTP semantics**.

---

### 🧩 Benchmark Snapshot (Typical AWS Lab Results)

| **Metric**                       | **NLB**                                   | **ALB**                            |
| -------------------------------- | ----------------------------------------- | ---------------------------------- |
| Latency (p95)                    | 0.2–0.5 ms                                | 2–5 ms                             |
| Throughput                       | 10+ million req/sec                       | ~1 million req/sec                 |
| TLS Handshake Time               | Optional (depends if termination enabled) | Always terminated (~5–15 ms setup) |
| CPU Utilization Impact (backend) | Higher (if backends handle SSL/TLS)       | Lower (if ALB offloads SSL)        |
| Cross-AZ Data Cost               | Billed (inter-AZ traffic charge)          | Included                           |
| Header/Body Inspection           | ❌ No                                     | ✅ Yes                             |
| WAF / HTTP/2 / gRPC Support      | ❌                                        | ✅                                 |

> ⚡ **Bottom line:** NLB is ~5–10× faster at raw packet forwarding but doesn’t understand HTTP, while ALB adds routing intelligence at the cost of ~a few ms latency.

---

### ✅ Best Practices for High Performance

**For NLB:**

- Use for **TCP/UDP workloads** needing ultra-low latency (e.g., game servers, FIX gateways).
- Attach **Elastic IPs** for predictable endpoints.
- Combine with **TLS termination on backend** for secure but high-speed traffic.

**For ALB:**

- Use for **HTTP/HTTPS microservices** where routing logic outweighs latency cost.
- Keep **listener rules minimal** to reduce evaluation time.
- Use **HTTP/2** and **gzip compression** for throughput optimization.
- Enable **connection reuse** and **keep-alives** to reduce handshake overhead.

---

### 💡 In short

- **NLB = raw performance (L4)** — near-zero latency, static IPs, extreme throughput.
- **ALB = smart routing (L7)** — path/host-based routing, SSL termination, WAF, at small latency cost.
  Choose **NLB for speed-sensitive TCP traffic**, and **ALB for HTTP-aware, feature-rich web apps**.

---

## Q: How do you log Load Balancer requests?

---

### 🧠 Overview

You can capture ALB/NLB/CLB activity via **(1) Load Balancer access logs (S3)**, **(2) CloudWatch metrics & logs**, **(3) VPC Flow Logs** (network-level), and **(4) CloudTrail** (API-level events).
Use access logs for request-level details, CloudWatch for real-time metrics/alarms, VPC Flow Logs for packet-level troubleshooting, and CloudTrail for auditing LB configuration changes.

---

### ⚙️ Purpose / How it Works

- **ALB / NLB / CLB access logs** — each request/connection entry is written to an S3 bucket (one object per time window). Useful for analytics, forensics, and debugging.
- **CloudWatch metrics** — aggregated metrics (RequestCount, TargetResponseTime, HealthyHostCount) for monitoring/alerting.
- **VPC Flow Logs** — logs ENI traffic (src/dst IP/port, bytes, action) to CloudWatch Logs or S3; good for network debugging and security.
- **CloudTrail** — records control-plane API calls (create/delete/modify load balancer) for audit trails.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Enable ALB access logs — Terraform

```hcl
resource "aws_s3_bucket" "alb_logs" {
  bucket = "acme-alb-logs-prod"
  acl    = "private"
  versioning { enabled = true }
}

resource "aws_lb" "alb" {
  name               = "app-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.bucket
    enabled = true
    prefix  = "alb/app-alb"
  }
}
```

#### 2) Enable ALB access logs — AWS CLI

```bash
aws elbv2 modify-load-balancer-attributes \
  --load-balancer-arn <alb-arn> \
  --attributes Key=access_logs.s3.enabled,Value=true \
               Key=access_logs.s3.bucket,Value=acme-alb-logs-prod \
               Key=access_logs.s3.prefix,Value=alb/app-alb
```

> Note: the S3 bucket must allow the ELB service to write logs. Configure bucket policy and lifecycle (archive/delete) per retention needs.

---

#### 3) Example ALB access log line (fields)

```
http 2025-11-12T12:00:00.000000Z app/my-alb/abcd1234 10.0.1.2:61773 10.0.2.5:80 0.000 0.020 0.001 200 200 0 123 "GET http://example.com:80/path HTTP/1.1" "curl/7.79.1" - - arn:aws:elasticloadbalancing:... true
```

Key fields: `type`, `timestamp`, `elb`, `client:port`, `target:port`, `request_processing_time`, `target_processing_time`, `response_processing_time`, `elb_status_code`, `target_status_code`, `received_bytes`, `sent_bytes`, `request`, `user_agent`, `ssl_cipher`, `ssl_protocol`, `target_group_arn`, `trace_id`.

---

#### 4) Create Athena table for ALB logs (sample)

```sql
CREATE EXTERNAL TABLE IF NOT EXISTS alb_logs (
  type string,
  time string,
  elb string,
  client_port string,
  target_port string,
  request_processing_time double,
  target_processing_time double,
  response_processing_time double,
  elb_status_code string,
  target_status_code string,
  received_bytes bigint,
  sent_bytes bigint,
  request string,
  user_agent string,
  ssl_cipher string,
  ssl_protocol string,
  target_group_arn string,
  trace_id string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
  "input.regex" = "([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" ([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*)"
)
LOCATION 's3://acme-alb-logs-prod/alb/'
TBLPROPERTIES ('has_encrypted_data'='false');
```

Use Athena/Glue to query, partition by date via object prefix for performance.

---

#### 5) CloudWatch metrics & alarm example (CLI)

```bash
# Get RequestCount (last 5 minutes)
aws cloudwatch get-metric-statistics \
  --namespace AWS/ApplicationELB \
  --metric-name RequestCount \
  --dimensions Name=LoadBalancer,Value=app/my-alb/abcd1234 \
  --start-time 2025-11-12T11:55:00Z --end-time 2025-11-12T12:00:00Z \
  --period 300 --statistics Sum
```

```bash
# Create alarm: high 5xx error rate
aws cloudwatch put-metric-alarm \
  --alarm-name "ALB-5XX-High" \
  --metric-name HTTPCode_Target_5XX_Count \
  --namespace AWS/ApplicationELB \
  --statistic Sum --period 300 --threshold 10 \
  --comparison-operator GreaterThanOrEqualToThreshold \
  --dimensions Name=TargetGroup,Value=targetgroup/my-tg/xyz \
  --evaluation-periods 2 --alarm-actions <sns-arn>
```

---

#### 6) Enable VPC Flow Logs (to CloudWatch Logs)

```bash
aws ec2 create-flow-logs \
  --resource-type VPC \
  --resource-ids vpc-0123456789abcdef0 \
  --traffic-type ALL \
  --log-group-name "/aws/vpc/flow-logs" \
  --deliver-logs-permission-arn arn:aws:iam::123456789012:role/flow-logs-role
```

---

#### 7) CloudTrail (audit load balancer config changes)

- Enable CloudTrail to log management API calls (`CreateLoadBalancer`, `ModifyLoadBalancerAttributes`, etc.).
- Query CloudTrail logs in CloudWatch or S3 for change history.

---

### 📋 Differences & Where to Use Which Log

| **Log Type**                 | **Level**                 | **Retention / Use**                        |
| ---------------------------- | ------------------------- | ------------------------------------------ |
| ALB/NLB/CLB Access Logs (S3) | Request/connection-level  | Forensics, analytics, traffic patterns     |
| CloudWatch Metrics           | Aggregated metrics        | Alerts, dashboards, realtime monitoring    |
| VPC Flow Logs                | ENI network flows         | Network debugging, security investigations |
| CloudTrail                   | API calls (control plane) | Audit & change tracking                    |

---

### ✅ Best Practices

- **Enable ALB/NLB access logs** to S3 with lifecycle rules (GLACIER/expire) to control cost.
- **Use Athena + Glue** for ad-hoc query/analytics of access logs.
- **Create CloudWatch alarms** on key metrics (5xx, target latency, unhealthy hosts).
- **Enable VPC Flow Logs** for network-level visibility (use sampling if cost-sensitive).
- **Protect log buckets**: enforce encryption, restrict writes to ELB service + MFA delete if required.
- **Instrument correlation**: include X-Request-ID / trace headers so ALB logs, app logs, and X-Ray/CloudWatch traces can be correlated.
- **Automate retention/pipeline**: lifecycle, Glue crawler, scheduled Athena partitions, and alerts on missing logs.

---

### 💡 In short

Enable **ALB/NLB access logs to S3** for per-request details, use **CloudWatch metrics/alarms** for realtime monitoring, add **VPC Flow Logs** for network-level debugging, and enable **CloudTrail** for audit trails. Combine Athena + CloudWatch for analytics and set S3 lifecycle policies to control cost.

---

## Q: What is the Difference Between AWS Global Accelerator and ALB?

---

### 🧠 Overview

Both **AWS Global Accelerator (GA)** and **Application Load Balancer (ALB)** distribute incoming traffic, but they operate at **different layers and scopes**:

- **Global Accelerator (GA)** → **Network-layer (Layer 4)**, **global** traffic routing using **anycast static IPs**.
- **ALB** → **Application-layer (Layer 7)**, **regional** HTTP/HTTPS routing using domain-based DNS.

Think of GA as a **global traffic entry point (edge-based TCP/UDP accelerator)** that directs users to the **best ALB or endpoint** in the closest AWS Region.

---

### ⚙️ Purpose / How It Works

| **Component**        | **AWS Global Accelerator**                                      | **Application Load Balancer (ALB)**   |
| -------------------- | --------------------------------------------------------------- | ------------------------------------- |
| **Layer**            | Layer 4 (TCP/UDP)                                               | Layer 7 (HTTP/HTTPS)                  |
| **Scope**            | Global (multi-region)                                           | Regional (within one AWS Region)      |
| **Routing Basis**    | Network latency & health (via AWS Global Edge Network)          | URL path, host, HTTP headers          |
| **Static IPs**       | ✅ Yes — two global anycast IPs                                 | ❌ No — DNS name only                 |
| **Protocol Support** | TCP, UDP                                                        | HTTP, HTTPS, gRPC                     |
| **Client Proximity** | Routes users to nearest AWS Region using edge PoPs              | Routes traffic within its own Region  |
| **Traffic Flow**     | Client → Edge Location (GA) → Optimal Region → ALB/NLB → Target | Client → ALB (in one Region) → Target |
| **DNS Resolution**   | No DNS dependency (uses static IPs)                             | DNS-based (regional ELB endpoint)     |
| **Performance Gain** | Up to 60% latency reduction using AWS backbone                  | Regional latency only                 |
| **Health Checks**    | Global endpoint health checks                                   | Target group health checks            |
| **Failover**         | Cross-region automatic failover                                 | No cross-region failover              |
| **Ideal Use Case**   | Global apps needing low latency and HA (multi-region)           | Regional web/app tier load balancing  |

---

### 🧩 Example Architecture

```
Client
   |
   v
AWS Global Accelerator (Static IPs)
   |
   +--> ALB - Region A (ap-south-1)
   |
   +--> ALB - Region B (us-east-1)
```

- GA routes traffic to the **nearest healthy ALB** based on latency and health.
- Each ALB then distributes HTTP requests to backend targets (EC2, ECS, Lambda, etc.) in its region.

---

### 🧩 Example: Terraform Configuration (Global Accelerator + ALB)

```hcl
resource "aws_globalaccelerator_accelerator" "ga" {
  name = "global-alb-accelerator"
  enabled = true
}

resource "aws_globalaccelerator_listener" "listener" {
  accelerator_arn = aws_globalaccelerator_accelerator.ga.id
  protocol        = "TCP"
  port_range {
    from_port = 80
    to_port   = 80
  }
}

resource "aws_globalaccelerator_endpoint_group" "alb_group_ap" {
  listener_arn = aws_globalaccelerator_listener.listener.id
  endpoint_group_region = "ap-south-1"
  endpoint_configuration {
    endpoint_id = aws_lb.alb_ap.arn
    weight      = 100
  }
}

resource "aws_globalaccelerator_endpoint_group" "alb_group_us" {
  listener_arn = aws_globalaccelerator_listener.listener.id
  endpoint_group_region = "us-east-1"
  endpoint_configuration {
    endpoint_id = aws_lb.alb_us.arn
    weight      = 100
  }
}
```

➡️ **Result:** Users connect to GA’s static IPs, which route them to the **closest healthy ALB** region via AWS’s high-speed global backbone.

---

### 📋 Comparison Summary

| **Feature**                  | **Global Accelerator**                   | **ALB**                           |
| ---------------------------- | ---------------------------------------- | --------------------------------- |
| **Layer**                    | L4 (TCP/UDP)                             | L7 (HTTP/HTTPS)                   |
| **Scope**                    | Global                                   | Regional                          |
| **Routing Criteria**         | Latency, health, geolocation             | Path, host, HTTP header           |
| **Failover**                 | Multi-region automatic                   | Region-specific                   |
| **Static IPs**               | ✅ Yes                                   | ❌ No                             |
| **Protocol Support**         | TCP/UDP                                  | HTTP/HTTPS                        |
| **Performance Optimization** | Uses AWS global backbone                 | Regional routing only             |
| **Use Case**                 | Global low-latency access (multi-region) | Web/app routing within one region |
| **WAF Integration**          | ❌ No (but ALB behind can have WAF)      | ✅ Yes                            |
| **Pricing Unit**             | Per accelerator + data transfer          | Per LCU (capacity unit)           |

---

### ✅ Best Practices

- Use **Global Accelerator** in front of **regional ALBs/NLBs** for **global** applications (multi-region active-active or DR).
- Keep ALB regional — use it for **Layer 7 intelligent routing** within each Region.
- **Combine both:** GA → ALB → ECS/EKS → targets.
- Enable **cross-region failover** via GA endpoint health checks.
- Use GA when your users are **geographically distributed** and require **consistent performance**.

---

### 💡 In short

- **ALB** = Layer 7 HTTP/HTTPS routing within **one region**.
- **Global Accelerator** = Layer 4 global routing that uses AWS’s backbone to route users to the **nearest healthy region** with **static IPs**.
  ➡️ Combine both: **Global Accelerator → ALB → Application** for optimal **global performance + intelligent request routing.**

---

## Q: How Do You Restrict Access to Specific IPs or Regions in AWS Load Balancers?

---

### 🧠 Overview

You can restrict client access to an **Application Load Balancer (ALB)** or **Network Load Balancer (NLB)** using several mechanisms:

- **Security Groups (L4 — IP-based)**
- **AWS WAF (L7 — IP and Geo-based)**
- **Network ACLs (subnet-level filtering)**
- **Reverse proxy / app-layer filters (for fine-grained logic)**

The choice depends on your **load balancer type** (ALB/NLB) and whether you need **Layer 4 (IP)** or **Layer 7 (application/geo)** filtering.

---

### ⚙️ Purpose / How It Works

| **Method**               | **Layer** | **Scope**                    | **Best For**                            |
| ------------------------ | --------- | ---------------------------- | --------------------------------------- |
| **Security Groups**      | Layer 4   | ALB or NLB ENIs              | IP/CIDR restrictions                    |
| **AWS WAF**              | Layer 7   | ALB, CloudFront, API Gateway | Geo-blocking, IP sets, request patterns |
| **Network ACLs**         | Layer 3   | Subnet-level                 | Coarse-grained IP allow/deny            |
| **Route 53 Geo Routing** | DNS       | Global                       | Region-based access at DNS layer        |

---

### 🧩 Option 1: Restrict by IP (Security Groups)

**Use when:** You want to allow traffic only from specific IP ranges (e.g., corporate VPN or office IPs).

#### Example (Terraform)

```hcl
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow only specific office IPs"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.0/24", "198.51.100.10/32"]
  }

  ingress {
    description = "Allow HTTPS from corporate VPN"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["203.55.10.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

#### AWS CLI Example

```bash
aws ec2 authorize-security-group-ingress \
  --group-id sg-1234567890abcdef \
  --protocol tcp --port 443 \
  --cidr 203.0.113.0/24
```

---

### 🧩 Option 2: Restrict by Country / IP Set (AWS WAF on ALB)

**Use when:** You need **Geo-blocking** or **IP reputation control** at **Layer 7**.
Attach a **Web ACL** to your ALB.

#### Example (Terraform)

```hcl
resource "aws_wafv2_ip_set" "allowed_ips" {
  name        = "allowed-ips"
  scope       = "REGIONAL"
  ip_address_version = "IPV4"
  addresses   = ["203.0.113.0/24", "198.51.100.10/32"]
}

resource "aws_wafv2_web_acl" "restrict_access" {
  name        = "restrict-access"
  scope       = "REGIONAL"
  default_action { block {} }

  rule {
    name     = "AllowSpecificIPs"
    priority = 1
    action { allow {} }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.allowed_ips.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AllowSpecificIPs"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AllowUSOnly"
    priority = 2
    action { allow {} }

    statement {
      geo_match_statement {
        country_codes = ["US", "IN"]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AllowUSOnly"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "restrict-access"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "alb_attach" {
  resource_arn = aws_lb.app_lb.arn
  web_acl_arn  = aws_wafv2_web_acl.restrict_access.arn
}
```

This configuration:
✅ Allows requests from **specific IPs** or **countries (US, IN)**
❌ Blocks everything else.

---

### 🧩 Option 3: Restrict at Network ACL (Subnet Level)

**Use when:** You want to block entire CIDRs at the **subnet level** (affects all resources).

```hcl
resource "aws_network_acl_rule" "deny_all" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}
```

---

### 🧩 Option 4: Route 53 Geo Routing (Region Restriction)

**Use when:** You want to direct or restrict access by **client geography** at the DNS layer.

Example:

- US users → ALB in `us-east-1`
- APAC users → ALB in `ap-south-1`
- All others → “Access Denied” endpoint

Route 53 automatically serves DNS responses based on the user’s **resolver location**.

---

### 📋 Comparison Summary

| **Method**               | **Layer** | **Supports Geo Restriction** | **Best For**               | **Notes**                     |
| ------------------------ | --------- | ---------------------------- | -------------------------- | ----------------------------- |
| **Security Groups**      | L4        | ❌                           | Allow specific IPs         | Simple, efficient             |
| **AWS WAF**              | L7        | ✅                           | Block/allow countries, IPs | Most flexible                 |
| **Network ACLs**         | L3        | ❌                           | Subnet-wide restrictions   | Coarse-grained                |
| **Route 53 Geo Routing** | DNS       | ✅                           | Regional routing control   | For multi-region access logic |

---

### ✅ Best Practices

- ✅ Use **WAF** for dynamic IP or Geo-based filtering.
- ✅ Use **Security Groups** for static IP allowlists (VPN, office networks).
- ⚠️ Avoid mixing too many layers of filtering unless required — manage complexity carefully.
- 🔒 Always enforce **least privilege** — default deny, then explicitly allow.
- 💾 Log blocked requests with **WAF sample logging → CloudWatch or Kinesis Firehose**.
- 🧩 Combine **WAF + ALB + CloudFront** for global web app protection and access control.

---

### 💡 In short

- Use **Security Groups** for simple **IP-based allowlists**.
- Use **AWS WAF** for **Geo-based** or **dynamic IP restriction** at Layer 7.
- Combine both for strong multi-layer protection:
  👉 **Security Group (IP control)** + **WAF (geo/IP rules)** + **Route 53 (geo-routing)** for global, secure access control.

---

## Q: What’s the Difference Between ALB and NLB for TLS Termination?

---

### 🧠 Overview

Both **Application Load Balancer (ALB)** and **Network Load Balancer (NLB)** support **TLS termination**, but they do it at **different OSI layers** and serve **different performance and feature goals**.
In short:

> 🧩 **ALB = Layer 7 termination (HTTP-aware)**
> 🧩 **NLB = Layer 4 termination (TCP-aware, performance-focused)**

---

### ⚙️ Purpose / How It Works

| **Feature**                          | **ALB (Application Load Balancer)**         | **NLB (Network Load Balancer)**                                   |
| ------------------------------------ | ------------------------------------------- | ----------------------------------------------------------------- |
| **OSI Layer**                        | Layer 7 (Application)                       | Layer 4 (Transport)                                               |
| **TLS Termination Point**            | At ALB (decrypted before routing)           | At NLB (decrypted before TCP forwarding)                          |
| **Routing Decisions**                | Based on HTTP headers, path, host, query    | Based only on IP + port                                           |
| **Certificate Source**               | AWS ACM (Region-specific)                   | AWS ACM or IAM Server Certificate                                 |
| **Decryption**                       | Done by ALB, forwards plain HTTP to targets | Done by NLB, forwards plain TCP to targets                        |
| **Target Protocol Post-Termination** | HTTP                                        | TCP                                                               |
| **Re-encryption (optional)**         | Yes (HTTPS → HTTPS)                         | Yes (TLS → TLS backend)                                           |
| **Performance**                      | Slightly higher latency (L7 parsing)        | Lower latency, higher throughput                                  |
| **Static IP Support**                | ❌ No                                       | ✅ Yes (EIP supported)                                            |
| **HTTP/2, gRPC Support**             | ✅ Yes                                      | ❌ No                                                             |
| **WAF Integration**                  | ✅ Supported                                | ❌ Not supported                                                  |
| **Use Case**                         | Web/API traffic (HTTP/HTTPS)                | High-speed TCP workloads needing TLS (MQTT, RDP, custom TCP apps) |

---

### 🧩 Example: TLS Termination with **ALB**

```hcl
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.web.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http_tg.arn
  }
}

resource "aws_lb_target_group" "http_tg" {
  name     = "web-http"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}
```

➡️ The ALB decrypts HTTPS and forwards plain HTTP traffic to backend targets (SSL termination).

---

### 🧩 Example: TLS Termination with **NLB**

```hcl
resource "aws_lb_listener" "tls" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 443
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.app.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tcp_tg.arn
  }
}

resource "aws_lb_target_group" "tcp_tg" {
  name     = "app-tcp"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
}
```

➡️ NLB decrypts TLS and forwards raw TCP traffic to targets — high-performance TLS termination without HTTP awareness.

---

### 📋 Key Behavioral Differences

| **Aspect**                 | **ALB (L7)**                           | **NLB (L4)**                                      |
| -------------------------- | -------------------------------------- | ------------------------------------------------- |
| **Traffic Visibility**     | Can inspect HTTP headers, URL, cookies | Cannot inspect; blind TCP forwarding              |
| **Routing Logic**          | Advanced (path/host/header-based)      | Simple (port/IP-based)                            |
| **Health Checks**          | HTTP-based                             | TCP or TLS-based                                  |
| **Idle Timeout**           | Configurable (default 60s)             | No idle timeout                                   |
| **Scaling Reaction Time**  | Fast (seconds)                         | Instant (connection-level)                        |
| **SSL Offload CPU Relief** | ✅ Yes                                 | ✅ Yes                                            |
| **End-to-End Encryption**  | Optional (re-encrypt)                  | Optional (TLS passthrough/termination)            |
| **Pricing Model**          | LCU-based (requests, rules, data)      | NLCU-based (new connections, active flows, bytes) |

---

### ✅ Best Practices

**Use ALB when:**

- You need **Layer 7 features** — path-based routing, WAF, redirects, cookies.
- You’re serving **HTTP/HTTPS** or **gRPC** apps.
- You want **centralized SSL management** with AWS ACM.

**Use NLB when:**

- You require **static IPs** or **Elastic IPs** for whitelisting.
- You’re handling **non-HTTP protocols** (SMTP, RDP, MQTT).
- You need **ultra-low latency** and high throughput.
- You want **TLS termination for TCP** services with minimal overhead.

**Combine Both:**
For complex architectures —

> 🌍 **NLB (static IP + TLS termination)** → **ALB (L7 routing + WAF)** → **App targets**

---

### 💡 In short

| **ALB:** Smart TLS termination (Layer 7), for **HTTP/HTTPS apps** with routing and WAF support. |
| **NLB:** Fast TLS termination (Layer 4), for **TCP-based apps** needing **static IPs & low latency**. |
👉 Choose **ALB** for web traffic intelligence, **NLB** for raw encrypted transport performance.

---

## Q: How to Protect an Application Load Balancer (ALB) from DDoS Attacks?

---

### 🧠 Overview

AWS provides **multi-layer DDoS protection** for ALB through **AWS Shield**, **AWS WAF**, **CloudFront**, and **security group/network design**.
By combining these services, you can mitigate **volumetric (L3/L4)**, **protocol (L4)**, and **application-layer (L7)** DDoS attacks effectively.

---

### ⚙️ Protection Layers & How They Work

| **Layer**                   | **Service / Control**                      | **Purpose**                                                  |
| --------------------------- | ------------------------------------------ | ------------------------------------------------------------ |
| **Network (L3/L4)**         | **AWS Shield Standard / Advanced**         | Protects against SYN floods, UDP floods, reflection attacks  |
| **Application (L7)**        | **AWS WAF**                                | Filters malicious HTTP requests (bots, SQLi, XSS, bad IPs)   |
| **Edge Network**            | **CloudFront + Shield**                    | Absorbs global DDoS traffic at edge PoPs before reaching ALB |
| **Access Control**          | **Security Groups / NACLs / IP filtering** | Restricts ingress to known IPs or ranges                     |
| **Monitoring & Automation** | **CloudWatch + AWS Firewall Manager**      | Detects, alerts, and auto-mitigates spikes or anomalies      |

---

### 🧩 Step-by-Step: Hardening ALB Against DDoS

#### **1️⃣ Enable AWS Shield (Always On)**

- **AWS Shield Standard**: enabled **by default** for all ALBs, NLBs, and CloudFront distributions.
  → Protects automatically against L3/L4 volumetric attacks.
- **AWS Shield Advanced**: paid service with 24x7 DDoS response team (DRT) and enhanced mitigation.

```bash
# Check Shield protection
aws shield list-protections
```

✅ **Recommended** for production-facing ALBs, especially in banking, e-commerce, or gaming.

---

#### **2️⃣ Use AWS WAF for Application-Layer Filtering**

Attach **AWS WAF** to the ALB to mitigate malicious HTTP(S) traffic.

**Example WAF rules:**

- Block requests from **known malicious IPs** or **bots**.
- Allow only specific **countries or IP ranges**.
- Rate-limit requests (e.g., **max 200 requests per 5 seconds per IP**).
- Block **SQL injection**, **XSS**, and **HTTP flood** patterns.

**Terraform Example:**

```hcl
resource "aws_wafv2_web_acl" "ddos_protect" {
  name  = "alb-ddos-protect"
  scope = "REGIONAL"

  default_action { allow {} }

  rule {
    name     = "RateLimitRule"
    priority = 1
    action { block {} }
    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRule"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "BlockMaliciousIPs"
    priority = 2
    action { block {} }
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.bad_ips.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockMaliciousIPs"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ALB-WAF"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "attach_alb" {
  resource_arn = aws_lb.app_lb.arn
  web_acl_arn  = aws_wafv2_web_acl.ddos_protect.arn
}
```

---

#### **3️⃣ Place ALB Behind CloudFront (Edge Protection Layer)**

CloudFront provides:

- **Edge caching** to absorb large traffic spikes.
- **Global Shield integration** for edge-level protection.
- **Web ACL integration** at edge + origin (ALB).

**Flow:**

```
Client → CloudFront (Edge Caching + WAF) → ALB → ECS/EKS/EC2
```

> ✅ This setup offloads 70–90% of malicious requests **before they ever hit your ALB.**

---

#### **4️⃣ Restrict ALB Access with Security Groups**

Allow only trusted networks (VPN, CloudFront IPs, internal CIDRs) to access ALB.

```hcl
ingress {
  description = "Allow traffic only from CloudFront Edge"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["AWS_CLOUDFRONT_EDGE_IP_RANGES"]
}
```

> 📘 Use AWS published [CloudFront IP ranges](https://ip-ranges.amazonaws.com/ip-ranges.json) to automate whitelist updates.

---

#### **5️⃣ Configure Rate-Limiting & Timeouts**

- Set **ALB idle timeout** appropriately (e.g., 60s) to prevent slowloris attacks.
- Use **WAF rate-based rules** to throttle IPs sending excessive requests.
- Monitor **5XX errors** and **RequestCount** metrics in CloudWatch.

---

#### **6️⃣ Monitor & Auto-Mitigate**

Enable detailed monitoring:

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/ApplicationELB \
  --metric-name RequestCount \
  --dimensions Name=LoadBalancer,Value=app/my-alb/123456 \
  --start-time 2025-11-12T12:00:00Z --end-time 2025-11-12T12:10:00Z \
  --period 60 --statistics Sum
```

Use **CloudWatch alarms + SNS** to alert or trigger **Lambda-based remediation** (e.g., add IPs to a WAF block list dynamically).

---

#### **7️⃣ Use Shield Advanced for Critical Apps**

Enables:

- **Automatic traffic engineering** and **attack detection.**
- **DRT (AWS DDoS Response Team)** access during active events.
- **Cost protection** against DDoS scaling spikes.
- **Attack diagnostics dashboard** in AWS Shield console.

---

### 📋 Layered DDoS Defense Summary

| **Layer** | **Service**                  | **Purpose**                                  |
| --------- | ---------------------------- | -------------------------------------------- |
| L3/L4     | AWS Shield Standard/Advanced | Mitigate SYN/UDP/volumetric attacks          |
| L7        | AWS WAF                      | Block malicious HTTP floods, rate-limit bots |
| Edge      | CloudFront                   | Cache + absorb global load                   |
| Access    | Security Groups / NACLs      | Restrict source IPs                          |
| Detection | CloudWatch + Shield Metrics  | Monitor attack patterns                      |
| Response  | AWS Firewall Manager + DRT   | Centralized auto-mitigation                  |

---

### ✅ Best Practices

- ✅ Always use **CloudFront + WAF + Shield combo** for internet-facing ALBs.
- ✅ Apply **rate-limiting** and **IP reputation** rules (AWS Managed WAF Rules).
- ✅ Monitor **RequestCount**, **RejectedCount**, and **HTTPCode_ELB_5XX_Count** metrics.
- ✅ Keep **ALB security group minimal** — allow only required ports (80/443).
- ✅ Use **Shield Advanced** for mission-critical applications.
- ✅ Automate IP blacklisting using **AWS Lambda + WAF APIs**.

---

### 💡 In short

Protect ALB from DDoS using **multi-layer defense**:

> 🛡️ **AWS Shield** for L3/L4,
> 🧱 **AWS WAF** for L7 filtering,
> 🌍 **CloudFront** for edge absorption,
> 🔒 **Security Groups** for IP whitelisting, and
> 📊 **CloudWatch + Shield Advanced** for real-time detection and auto-mitigation.

✅ Combined, these layers provide **comprehensive, scalable DDoS protection** for any ALB-hosted application.

---

## Q: How Does an Application Load Balancer (ALB) Support Microservices?

---

### 🧠 Overview

An **AWS Application Load Balancer (ALB)** is designed to natively support **microservice architectures** running on **ECS, EKS, EC2, or Lambda**.
It acts as an **intelligent Layer 7 router**, distributing requests across multiple **independent services** based on **path**, **host**, or **header rules** — all behind a single DNS endpoint.

> 💡 In microservice environments, ALB eliminates the need for multiple external load balancers by using **target groups** and **routing rules** for each service.

---

### ⚙️ Purpose / How It Works

| **ALB Component**          | **Role in Microservices**                      |
| -------------------------- | ---------------------------------------------- |
| **Listeners (HTTP/HTTPS)** | Receive client traffic (port 80/443).          |
| **Rules**                  | Match requests by host/path/header/query.      |
| **Target Groups**          | Logical backend groups — one per microservice. |
| **Health Checks**          | Monitor service health individually.           |
| **Dynamic Registration**   | ECS/EKS tasks auto-register to target groups.  |

---

### 🧩 Example Architecture

```
                        +-------------------------+
Client → HTTPS (443) →  | Application Load Balancer |
                        +-----------+--------------+
                                    |
                                    +-- /auth/*   → auth-service (ECS Task Group 1)
                                    |
                                    +-- /orders/* → orders-service (ECS Task Group 2)
                                    |
                                    +-- /cart/*   → cart-service (EKS Pods)
                                    |
                                    +-- default   → web-frontend (EC2)
```

Each **microservice** runs in its own **Target Group** with its own **health check** and **autoscaling policy**.

---

### 🧩 Example: Terraform Configuration (Multi-Service ALB)

```hcl
# ALB Definition
resource "aws_lb" "micro_alb" {
  name               = "micro-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]
}

# Target Groups for microservices
resource "aws_lb_target_group" "auth_tg" {
  name     = "auth-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path = "/health"
  }
}

resource "aws_lb_target_group" "orders_tg" {
  name     = "orders-tg"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path = "/health"
  }
}

# HTTPS Listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.micro_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.app.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth_tg.arn
  }
}

# Listener Rules for Routing
resource "aws_lb_listener_rule" "auth_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth_tg.arn
  }

  condition {
    path_pattern {
      values = ["/auth/*"]
    }
  }
}

resource "aws_lb_listener_rule" "orders_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.orders_tg.arn
  }

  condition {
    path_pattern {
      values = ["/orders/*"]
    }
  }
}
```

➡️ Each service (`/auth`, `/orders`) has:

- Its own **target group**
- Independent **health checks**
- Path-based **routing rule**

---

### 🧩 ECS Integration Example

ECS automatically registers tasks to the right target group via the **service definition**:

```json
"loadBalancers": [
  {
    "targetGroupArn": "arn:aws:elasticloadbalancing:...:targetgroup/auth-tg",
    "containerName": "auth",
    "containerPort": 8080
  }
],
"serviceRegistries": [],
"desiredCount": 2,
"launchType": "FARGATE"
```

✅ ECS manages registration/deregistration of tasks as they scale.
✅ ALB performs **per-target health checks** and routes only to healthy instances.

---

### 📋 Key ALB Features Supporting Microservices

| **Feature**                   | **Description**                         | **Use Case**                        |
| ----------------------------- | --------------------------------------- | ----------------------------------- |
| **Path-based routing**        | Route based on URL path                 | `/auth/*`, `/orders/*`              |
| **Host-based routing**        | Route based on domain                   | `api.example.com`, `ui.example.com` |
| **Header-based routing**      | Route based on HTTP headers             | Canary or versioned APIs            |
| **Target groups per service** | Independent scaling/health              | Microservice isolation              |
| **Container-aware (ECS/EKS)** | Dynamic port mapping                    | Multiple services on same EC2       |
| **WAF integration**           | Protect all services centrally          | Security filtering                  |
| **HTTPS termination**         | Single SSL certificate for all services | Simplified TLS management           |

---

### ✅ Best Practices

- 🧩 Use **one target group per microservice** for clear health and scaling boundaries.
- ⚙️ Combine **path** and **host-based routing** for multi-domain or multi-service deployments.
- 🔒 Terminate SSL at ALB; internal traffic can be HTTP (or HTTPS for sensitive data).
- 📈 Enable **access logs** and **CloudWatch metrics** per target group.
- 🚀 Use **ECS dynamic port mapping** (`containerPort`, `hostPort = 0`) for multiple containers per host.
- 🛡️ Apply **WAF** at ALB level for centralized web security.
- ⚡ Integrate **Route 53** for DNS-based service discovery and versioned deployments.

---

### 💡 In short

The **Application Load Balancer (ALB)** enables microservice architectures by:

- Providing **intelligent routing** (path, host, header)
- Allowing **service-level isolation** via target groups
- Supporting **containerized deployments** (ECS/EKS)
- Centralizing **TLS termination**, **monitoring**, and **security**

👉 **One ALB = Many microservices**, each independently scalable, secure, and observable.

---

## Q: What is Deregistration Delay in AWS Load Balancers?

---

### 🧠 Overview

**Deregistration Delay** (also known as **connection draining**) is the **time period an Elastic Load Balancer (ALB/NLB/CLB)** waits before **removing a target** (EC2, ECS task, IP, or Lambda) from service **after it’s marked unhealthy or during scale-in events**.

This ensures that **in-flight requests complete gracefully** instead of being abruptly terminated when targets are deregistered.

---

### ⚙️ Purpose / How It Works

1. When a target (e.g., EC2 instance or ECS task) is being **deregistered** (due to scaling down, deployment, or health failure):

   - The load balancer **stops routing new requests** to it.
   - But it continues to **allow existing connections to complete** for a specified period.

2. After the **deregistration delay** expires:

   - All open connections are forcibly closed.
   - The target is removed from the target group.

This prevents **client errors (5xx/connection reset)** during ECS service updates, rolling deployments, or autoscaling events.

---

### 🧩 Default Behavior

| **Load Balancer Type** | **Default Delay**       | **Configurable Range** |
| ---------------------- | ----------------------- | ---------------------- |
| **Application (ALB)**  | 300 seconds (5 minutes) | 0 – 3600 seconds       |
| **Network (NLB)**      | 300 seconds             | 0 – 3600 seconds       |
| **Classic (CLB)**      | 300 seconds             | 1 – 3600 seconds       |

---

### 🧩 Example: Terraform Configuration

```hcl
resource "aws_lb_target_group" "web_tg" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  deregistration_delay = 60  # Wait 60 seconds before removing target

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}
```

➡️ This configuration gives each target **60 seconds** to finish in-flight requests before deregistration.

---

### 🧩 AWS CLI Example

```bash
aws elbv2 modify-target-group-attributes \
  --target-group-arn arn:aws:elasticloadbalancing:region:acct:targetgroup/web-tg/abc123 \
  --attributes Key=deregistration_delay.timeout_seconds,Value=60
```

---

### 🧩 ECS Example (During Deployments)

When ECS replaces old tasks during a deployment:

1. ECS **deregisters** the old task from the target group.
2. ALB stops sending new traffic to it.
3. ALB **waits (deregistration delay)** → allows old requests to complete.
4. After the delay, ALB **removes** the target.

✅ Prevents user-facing request failures during rolling updates or blue/green deployments.

---

### 📋 Key Notes

| **Setting**                        | **Impact**                                       |
| ---------------------------------- | ------------------------------------------------ |
| **Too short (0–10s)**              | May cause client disconnects during deployments  |
| **Too long (300–600s)**            | Slower scaling and deployments                   |
| **Ideal Range**                    | 30–120 seconds for most web services             |
| **For streaming/long connections** | Use longer delay (e.g., 300s+)                   |
| **For stateless APIs**             | Shorter delay (10–30s) improves deployment speed |

---

### ✅ Best Practices

- Tune **deregistration_delay** based on **average request duration**.
- For **ECS Fargate/EC2 rolling updates**, align deregistration delay with **container shutdown grace period**.
- Ensure applications handle **SIGTERM** gracefully — close connections before container stop.
- Monitor **TargetDeregistrationCount** and **HTTPCode_ELB_5XX_Count** to validate graceful draining.
- Combine with **Connection Draining** (Classic LB) or **TargetGroup deregistration_delay** (ALB/NLB).

---

### 💡 In short

**Deregistration Delay** defines **how long ALB/NLB waits before removing a target** after it stops receiving new traffic — allowing existing connections to complete gracefully.
👉 It prevents user-facing errors during scaling or deployments and should match your app’s **request completion time** for smooth blue/green or rolling updates.

---

## Q: How to route traffic to multiple Target Groups?

---

### 🧠 Overview

ALB routes traffic to **Target Groups** using **listeners + rules**. You can forward requests to different TGs based on **host/path/header/method/query**, or **split traffic** across multiple TGs (weighted forwarding) for canary or A/B deployments. Rules evaluate in priority order; the **default action** applies if no rule matches.

---

### ⚙️ Purpose / How it Works

- **Listener receives** request (HTTP/HTTPS).
- **Rules** evaluate conditions (host, path, header, method, query-string).
- **Action** types: `forward` (single TG), `forward` (multiple TGs with weights), `redirect`, `fixed-response`.
- **Weighted forward** allows X% → TG-A and Y% → TG-B for gradual rollouts.
- **Priority** determines rule evaluation order; lower number = higher precedence.
- **Default action** is used when no rule matches.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Path-based routing (Terraform)

```hcl
# Target groups
resource "aws_lb_target_group" "api_v1" { name="api-v1"; port=80; protocol="HTTP"; vpc_id=var.vpc }
resource "aws_lb_target_group" "api_v2" { name="api-v2"; port=80; protocol="HTTP"; vpc_id=var.vpc }

# Listener on ALB
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert.arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.api_v1.arn
  }
}

# Rule: /v2/* → api-v2
resource "aws_lb_listener_rule" "v2" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.api_v2.arn
  }
  condition {
    path_pattern { values = ["/v2/*"] }
  }
}
```

#### 2) Host-based routing (Terraform)

```hcl
# api.example.com -> api-tg ; admin.example.com -> admin-tg
condition { host_header { values = ["api.example.com"] } }
condition { host_header { values = ["admin.example.com"] } }
```

#### 3) Weighted (traffic-splitting) forward action (Terraform)

```hcl
resource "aws_lb_listener_rule" "canary" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 20

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.api_v1.arn
        weight = 90
      }
      target_group {
        arn    = aws_lb_target_group.api_v2.arn
        weight = 10
      }
    }
  }

  condition { path_pattern { values = ["/api/*"] } }
}
```

#### 4) AWS CLI — create listener rule with weighted forward

```bash
aws elbv2 create-rule \
  --listener-arn <listener-arn> \
  --priority 20 \
  --conditions Field=path-pattern,Values="/api/*" \
  --actions Type=forward,ForwardConfig='{"TargetGroups":[{"TargetGroupArn":"arn:...:api-v1","Weight":90},{"TargetGroupArn":"arn:...:api-v2","Weight":10}], "TargetGroupStickinessConfig":{"Enabled":false}}'
```

#### 5) Header / Method / Query-string routing examples (Terraform conditions)

```hcl
# Header
condition { http_header { http_header_name = "X-Canary"; values = ["true"] } }

# HTTP method
condition { http_request_method { values = ["POST"] } }

# Query string
condition {
  query_string {
    values = [{ key="version", value="beta" }]
  }
}
```

---

### 📋 Parameters / Rules Table

| **Field**              | **Where**            | **Purpose / Example**                                                               |
| ---------------------- | -------------------- | ----------------------------------------------------------------------------------- |
| `priority`             | Listener rule        | Lower number = higher precedence                                                    |
| `condition`            | Rule                 | `path_pattern`, `host_header`, `http_header`, `http_request_method`, `query_string` |
| `action.type`          | Rule action          | `forward`, `redirect`, `fixed-response`                                             |
| `forward.target_group` | Forward action       | single TG + weight (for multi-TG)                                                   |
| `forward.weight`       | Forward target entry | integer weight for traffic split                                                    |
| `stickiness`           | ForwardConfig        | Optional per-rule stickiness for weighted routing                                   |
| `default_action`       | Listener             | Fallback action when no rule matches                                                |

---

### ✅ Best Practices

- Use **one target group per service/version** for clean health checks and scaling.
- Prefer **path/host rules** for deterministic routing; use **weighted forward** for canary/A–B.
- Keep rules **simple and prioritized** — avoid overlapping conditions that complicate debugging.
- Use **health checks** per TG; unhealthy targets won’t receive traffic.
- For canaries, start small (1–5%) and monitor latency/errors before increasing weight.
- Correlate logs: inject **request-id / trace headers** so ALB logs + app logs can be matched.
- Use **WAF** ahead of ALB if you need to filter malicious traffic before routing.
- Automate rollbacks: if error rate > threshold, revert weights via CI/CD.

---

### 💡 In short

Use ALB **listener rules** (host/path/header/method) to route to multiple Target Groups; use **weighted forward** for traffic splits (canary/A-B). Configure priorities, keep per-service target groups, and monitor health/metrics when rolling traffic.

---

## Q: What Metrics Can Be Monitored in CloudWatch for AWS Load Balancers (ALB / NLB / CLB)?

---

### 🧠 Overview

**Amazon CloudWatch** automatically collects detailed metrics from **Elastic Load Balancing (ELB)** — including **Application Load Balancer (ALB)**, **Network Load Balancer (NLB)**, and **Classic Load Balancer (CLB)**.
These metrics help you **monitor traffic, performance, errors, latency, and target health** to ensure high availability and fast response times.

---

### ⚙️ Purpose / How It Works

- Metrics are published automatically to CloudWatch under the namespace:

  - `AWS/ApplicationELB` for **ALB**
  - `AWS/NetworkELB` for **NLB**
  - `AWS/ELB` for **CLB**

- You can view metrics in **CloudWatch console**, **AWS CLI**, or via **Grafana/Prometheus**.
- Metrics are reported in **1-minute intervals** (standard resolution).

---

### 🧩 Common CloudWatch Metrics — Application Load Balancer (ALB)

| **Metric Name**                    | **Unit** | **Description / Purpose**                                           |
| ---------------------------------- | -------- | ------------------------------------------------------------------- |
| **RequestCount**                   | Count    | Number of HTTP(S) requests processed by the ALB.                    |
| **ActiveConnectionCount**          | Count    | Total concurrent TCP connections to the ALB.                        |
| **NewConnectionCount**             | Count    | Number of new connections established.                              |
| **TargetResponseTime**             | Seconds  | End-to-end latency between ALB and target response.                 |
| **HTTPCode_ELB_4XX_Count**         | Count    | Number of client-side (4xx) errors generated by ALB (e.g., 404).    |
| **HTTPCode_ELB_5XX_Count**         | Count    | Number of server-side (5xx) errors generated by ALB.                |
| **HTTPCode_Target_2XX_Count**      | Count    | Successful responses (200–299) from targets.                        |
| **HTTPCode_Target_3XX_Count**      | Count    | Redirect responses (300–399).                                       |
| **HTTPCode_Target_4XX_Count**      | Count    | Application-level client errors from targets.                       |
| **HTTPCode_Target_5XX_Count**      | Count    | Server errors from targets (critical for app health).               |
| **TargetConnectionErrorCount**     | Count    | Failed connections between ALB and targets.                         |
| **TargetTLSNegotiationErrorCount** | Count    | TLS handshake failures with targets.                                |
| **UnHealthyHostCount**             | Count    | Number of unhealthy targets in a Target Group.                      |
| **HealthyHostCount**               | Count    | Number of healthy targets in a Target Group.                        |
| **RejectedConnectionCount**        | Count    | Connections rejected due to listener/target capacity.               |
| **ProcessedBytes**                 | Bytes    | Total data processed by the ALB.                                    |
| **ConsumedLCUs**                   | Count    | Number of Load Balancer Capacity Units consumed (used for billing). |

---

### 🧩 Common CloudWatch Metrics — Network Load Balancer (NLB)

| **Metric Name**                    | **Unit** | **Description / Purpose**                              |
| ---------------------------------- | -------- | ------------------------------------------------------ |
| **ProcessedBytes**                 | Bytes    | Total bytes processed (ingress + egress).              |
| **TCP_Client_Reset_Count**         | Count    | Client-side TCP resets (RST packets).                  |
| **TCP_Target_Reset_Count**         | Count    | Target-side TCP resets.                                |
| **TCP_ELB_Reset_Count**            | Count    | Resets initiated by the load balancer.                 |
| **HealthyHostCount**               | Count    | Number of healthy targets.                             |
| **UnHealthyHostCount**             | Count    | Number of unhealthy targets.                           |
| **NewFlowCount**                   | Count    | Number of new TCP/UDP connections (flows) established. |
| **ActiveFlowCount**                | Count    | Concurrent active connections.                         |
| **TargetResponseTime**             | Seconds  | (TCP TLS termination) Time taken for response.         |
| **ClientTLSNegotiationErrorCount** | Count    | TLS negotiation failures from clients.                 |
| **TargetTLSNegotiationErrorCount** | Count    | TLS negotiation failures with targets.                 |

---

### 🧩 AWS CLI Example — Get ALB Metrics

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/ApplicationELB \
  --metric-name RequestCount \
  --dimensions Name=LoadBalancer,Value=app/my-alb/abc123 \
  --start-time 2025-11-12T12:00:00Z \
  --end-time 2025-11-12T12:10:00Z \
  --period 60 \
  --statistics Sum
```

---

### 🧩 Example: Monitoring Dashboard (CloudWatch)

**Useful graphs to include:**

- 📈 RequestCount (Sum) – total incoming traffic
- ⚡ TargetResponseTime (Average) – backend latency
- 🔴 HTTPCode_Target_5XX_Count (Sum) – app errors
- 🔵 UnHealthyHostCount (Max) – unhealthy targets
- 🟢 ConsumedLCUs (Average) – cost metric
- 🟠 ActiveConnectionCount – concurrency

You can build a **CloudWatch Dashboard**:

```bash
aws cloudwatch put-dashboard --dashboard-name "ALB-Dashboard" \
  --dashboard-body file://alb-dashboard.json
```

---

### 🧩 Example: Alerting (High 5xx Error Rate)

```bash
aws cloudwatch put-metric-alarm \
  --alarm-name "ALB-5XX-High" \
  --metric-name HTTPCode_Target_5XX_Count \
  --namespace AWS/ApplicationELB \
  --statistic Sum \
  --period 300 \
  --threshold 10 \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 2 \
  --alarm-actions arn:aws:sns:us-east-1:123456789012:DevOpsAlerts \
  --dimensions Name=TargetGroup,Value=targetgroup/my-tg/xyz
```

---

### 📋 Comparison Summary

| **Metric Category** | **ALB (L7)**                        | **NLB (L4)**                    |
| ------------------- | ----------------------------------- | ------------------------------- |
| Request Metrics     | ✅ Yes (RequestCount, ResponseTime) | ⚠️ Limited (FlowCount)          |
| Latency             | ✅ TargetResponseTime               | ✅ TargetResponseTime           |
| HTTP Codes          | ✅ 2xx–5xx per target               | ❌ Not available                |
| Connection Metrics  | ✅ Active/New Connection Count      | ✅ Active/New Flow Count        |
| TLS Metrics         | ✅ Target/Client TLS errors         | ✅ TLS Negotiation errors       |
| Health Metrics      | ✅ Healthy/Unhealthy Host Count     | ✅ Healthy/Unhealthy Host Count |
| Data Processed      | ✅ ProcessedBytes                   | ✅ ProcessedBytes               |
| Billing Metric      | ✅ ConsumedLCUs                     | ✅ ConsumedNLCUs                |

---

### ✅ Best Practices

- Monitor **TargetResponseTime** and **5XX errors** — key indicators of app health.
- Set **CloudWatch alarms** on:

  - `UnHealthyHostCount` > 0
  - `HTTPCode_Target_5XX_Count` rising
  - `TargetResponseTime` spike

- Track **ConsumedLCUs/NLCUs** for cost optimization.
- Enable **access logs** (S3) for deeper request tracing.
- Use **CloudWatch dashboards** for visualization + correlation with EC2/ECS metrics.
- Integrate with **SNS / Slack / PagerDuty** for alerting.

---

### 💡 In short

CloudWatch monitors key **performance, error, connection, and health metrics** for ALB/NLB.

- 🧩 **ALB:** Focus on `RequestCount`, `TargetResponseTime`, `HTTPCode_*`, `UnHealthyHostCount`.
- ⚡ **NLB:** Focus on `NewFlowCount`, `ActiveFlowCount`, `ProcessedBytes`, and `TCP_Reset_Count`.
  Together, these metrics provide **real-time visibility and proactive alerting** for your load-balanced workloads.

---

## Q: How Do You Troubleshoot 502 and 504 Errors in AWS Application Load Balancer (ALB)?

---

### 🧠 Overview

**502 (Bad Gateway)** and **504 (Gateway Timeout)** are common ALB errors indicating **communication failures between the ALB and backend targets** — not client-side issues.
They usually happen when:

- Targets **don’t respond properly**,
- There’s a **protocol or port mismatch**,
- Or the **application takes too long to respond**.

---

### ⚙️ Error Meaning

| **Error Code**          | **Meaning**                                                                                    | **Typical Cause**                                        |
| ----------------------- | ---------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| **502 Bad Gateway**     | ALB received an invalid response (malformed headers, connection reset, SSL handshake failure). | App crash, port mismatch, invalid HTTP response.         |
| **504 Gateway Timeout** | Target didn’t respond within the configured timeout.                                           | App slowness, DB latency, network/Security Group issues. |

---

### 🧩 Step-by-Step Troubleshooting Guide

---

#### 🔹 1️⃣ Verify Target Health

```bash
aws elbv2 describe-target-health \
  --target-group-arn arn:aws:elasticloadbalancing:region:acct:targetgroup/my-tg/abc123
```

**Check:**

- Are targets `healthy`?
- If unhealthy → check health check path, port, SGs.

**Common fix:**

- Wrong `path` (`/health` missing or returning 404).
- Target app listening on wrong port (e.g., app on 8080 but TG expects 80).

---

#### 🔹 2️⃣ Check Security Groups & Network ACLs

Ensure **ALB → Target** communication allowed on target group port.

**Example (for HTTP 80):**

- ALB SG: outbound → 80 (to target SG)
- Target SG: inbound → 80 (from ALB SG)

```bash
aws ec2 describe-security-groups --group-ids sg-alb sg-target
```

**Fix:** Add missing rules if blocked.

---

#### 🔹 3️⃣ Verify Listener & Target Group Configuration

**Misconfigurations cause 502:**

- Wrong **protocol** (HTTP vs HTTPS)
- **Target port mismatch** (e.g., app listening on 5000, TG expecting 80)
- Target responding with **non-HTTP data** or malformed headers

**Check via Terraform / Console:**

```hcl
listener { protocol = "HTTPS" port = 443 }
target_group { protocol = "HTTP" port = 80 }
```

> ⚠️ ALB expects **valid HTTP responses** — ensure backend sends proper `HTTP/1.1 200 OK` and headers.

---

#### 🔹 4️⃣ Check Application Logs (on Targets)

- Look for request rejections, crashes, or long-running queries.
- Use web server logs (`/var/log/nginx/access.log` or app logs).
- A 502 may appear as:

  ```
  upstream prematurely closed connection
  connection reset by peer
  broken pipe
  ```

---

#### 🔹 5️⃣ Analyze ALB Access Logs

Enable and inspect **ALB access logs** (stored in S3).
A sample entry shows backend timing & status codes:

```
http 2025-11-12T12:10:10Z app/my-alb/abcd 1.2.3.4:54321 10.0.1.2:80 0.001 5.002 0.000 504 504 0 0 "GET /api/users HTTP/1.1" ...
```

**Interpretation:**

- `target_processing_time` (second number) → backend delay (5.002s here).
- High value → app slow → 504 timeout.

---

#### 🔹 6️⃣ Increase Target Group Timeout (if app slow)

If the app takes > ALB timeout (default **30s**), you’ll see 504.

**Terraform:**

```hcl
resource "aws_lb_target_group" "web" {
  name     = "web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path = "/health"
  }

  stickiness { enabled = false }

  deregistration_delay = 60
  slow_start {
    duration = 30
  }

  # Adjust idle timeout on ALB (separately)
}
```

**ALB Idle Timeout (HTTP/HTTPS):**

```bash
aws elbv2 modify-load-balancer-attributes \
  --load-balancer-arn arn:aws:elasticloadbalancing:...:loadbalancer/app/my-alb/1234 \
  --attributes Key=idle_timeout.timeout_seconds,Value=60
```

---

#### 🔹 7️⃣ Check SSL/TLS Handshake (for HTTPS targets)

If your ALB connects to targets via **HTTPS**, ensure:

- Correct **certificate chain** on target.
- **TLS version/cipher** compatible with ALB policy.
- **TargetTLSNegotiationErrorCount** metric not increasing.

**Metric:**

```
AWS/ApplicationELB → TargetTLSNegotiationErrorCount
```

---

#### 🔹 8️⃣ Monitor CloudWatch Metrics

| **Metric**                  | **Meaning**                   | **Use To Detect**       |
| --------------------------- | ----------------------------- | ----------------------- |
| `HTTPCode_ELB_5XX_Count`    | ALB internal errors (502/504) | Sudden backend failures |
| `HTTPCode_Target_5XX_Count` | Errors from your app          | Application issues      |
| `TargetResponseTime`        | Target latency                | Timeout trend           |
| `UnHealthyHostCount`        | Unhealthy targets             | Failed health checks    |

**Command:**

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/ApplicationELB \
  --metric-name HTTPCode_ELB_5XX_Count \
  --statistics Sum --period 300 \
  --start-time 2025-11-12T11:55:00Z --end-time 2025-11-12T12:00:00Z
```

---

#### 🔹 9️⃣ Common ECS / EKS-Specific Causes

**ECS:**

- Container shutting down before draining (set deregistration_delay properly).
- Wrong container port mapping (`containerPort ≠ target port`).
- Health check path mismatch (`/` vs `/health`).

**EKS / Ingress:**

- Pod not ready or missing readiness probe.
- Node security group blocks ALB → Pod communication.

---

#### 🔹 🔟 Network / NAT / DNS Issues

- If using **private subnets**, ensure ALB can resolve target DNS.
- Verify **route tables** and **NAT gateways** for outbound connections.
- Ensure no intermittent network throttling from NACLs or firewalls.

---

### 📋 Quick Root Cause Reference

| **Error** | **Likely Cause**                  | **Fix**                                 |
| --------- | --------------------------------- | --------------------------------------- |
| 502       | App crashed / invalid response    | Restart app, validate HTTP headers      |
| 502       | Protocol mismatch (HTTPS vs HTTP) | Match TG and listener protocols         |
| 502       | SSL negotiation error             | Check target TLS cert                   |
| 504       | Target timeout                    | Increase idle_timeout / fix app latency |
| 504       | Network SG blocked                | Allow ALB → Target on correct port      |
| 504       | Unhealthy targets                 | Fix health check failures               |

---

### ✅ Best Practices

- ✅ Set **proper health checks** (`/health`) with fast responses.
- ✅ Ensure **listener and target protocols/ports match**.
- ✅ Use **CloudWatch dashboards** for latency and 5xx monitoring.
- ✅ Tune **idle_timeout** (30–60s) for long requests (APIs, uploads).
- ✅ Use **AWS WAF** to block malicious slowloris / HTTP floods.
- ✅ For ECS: match **deregistration delay** with **container shutdown grace**.
- ✅ Collect **ALB access logs** for post-incident RCA.

---

### 💡 In short

- **502 = invalid/malformed response** from backend.
- **504 = backend timeout** before ALB got a reply.
  ✅ Check **target health, ports, timeouts, and app logs** — adjust ALB idle timeout or fix backend latency.
  Use **CloudWatch + ALB access logs** for precise root cause analysis.

---

## Q: How Do You Attach an Application Load Balancer (ALB) to Multiple Security Groups?

---

### 🧠 Overview

An **Application Load Balancer (ALB)** in AWS can be associated with **multiple security groups (SGs)** to allow flexible **network access control**.
Each security group can define specific inbound/outbound rules — combining multiple SGs lets you **segregate responsibilities**, e.g.:

- One SG for public HTTP/HTTPS traffic,
- Another SG for internal admin or monitoring access.

---

### ⚙️ Purpose / How It Works

- ALB operates at **Layer 7** (HTTP/HTTPS) and requires at least **one security group** (for inbound traffic).
- You can attach **multiple SGs** either:

  1. During ALB creation, or
  2. After creation (via console, CLI, or Terraform).

- AWS merges the rules of all attached SGs → if **any SG allows** traffic, it’s allowed.
- Outbound rules apply to **responses to clients** (typically open to `0.0.0.0/0`).

---

### 🧩 Example 1: Terraform Configuration

```hcl
resource "aws_security_group" "alb_http_sg" {
  name   = "alb-http-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_https_sg" {
  name   = "alb-https-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "app_alb" {
  name               = "multi-sg-alb"
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id

  # Attach multiple SGs
  security_groups = [
    aws_security_group.alb_http_sg.id,
    aws_security_group.alb_https_sg.id
  ]
}
```

✅ Result:

- ALB accepts both **HTTP (80)** and **HTTPS (443)** traffic using two different SGs.
- You can also mix **public** and **private** access SGs for hybrid patterns.

---

### 🧩 Example 2: AWS CLI

```bash
# Create ALB with multiple security groups
aws elbv2 create-load-balancer \
  --name my-alb \
  --subnets subnet-abc123 subnet-def456 \
  --security-groups sg-001 sg-002 \
  --type application
```

To **update security groups** for an existing ALB:

```bash
aws elbv2 set-security-groups \
  --load-balancer-arn arn:aws:elasticloadbalancing:region:acct:loadbalancer/app/my-alb/1234abcd \
  --security-groups sg-001 sg-002 sg-003
```

---

### 🧩 Example 3: AWS Console Steps

1. Go to **EC2 → Load Balancers**.
2. Select your **Application Load Balancer**.
3. Choose **Listeners and Security → Edit Security Groups**.
4. Add multiple SGs → Save changes.

---

### 📋 How Security Groups Combine

| **Scenario**           | **Effective Rule**                                          |
| ---------------------- | ----------------------------------------------------------- |
| SG-1 allows `80/tcp`   | ✅ ALB allows port 80                                       |
| SG-2 allows `443/tcp`  | ✅ ALB allows port 443                                      |
| Both attached          | ✅ Both ports 80 & 443 allowed                              |
| SG-1 denies everything | ⚠️ ALB still allows 443 via SG-2 (allow rules are additive) |

> 🔒 **Important:** SGs are **stateful**, meaning response traffic is automatically allowed — no need to open outbound ports for replies.

---

### ✅ Best Practices

- Group SGs by **purpose**, not by resource:

  - `alb-public-sg` → open to world (HTTP/HTTPS)
  - `alb-internal-sg` → restricted to corporate IPs/VPN

- Always **restrict** admin/test SGs to known CIDR ranges.
- Avoid using **overlapping SGs** with conflicting rules (harder to audit).
- Regularly audit attached SGs using:

  ```bash
  aws ec2 describe-security-groups --group-ids $(aws elbv2 describe-load-balancers --query "LoadBalancers[*].SecurityGroups[]" --output text)
  ```

- Use **AWS Config** or **Security Hub** to detect overly permissive SGs.

---

### 💡 In short

You can attach **multiple Security Groups** to an ALB for flexible network control.

- Combine SGs to separate **HTTP, HTTPS, internal, or admin** traffic policies.
- AWS **merges all SG allow rules**, enhancing modularity and manageability.
  👉 Use `security_groups = [sg1, sg2, ...]` in Terraform or `set-security-groups` in CLI to attach them safely.

---

# Scenario-Based Questions

## Q: ALB not routing traffic to targets

---

### 🧠 Overview

ALB not forwarding traffic usually means the ALB **is healthy and receiving requests** but **no healthy targets** or **misconfiguration** prevents forwarding. Quick checks: **listeners → rules → target group → target health → networking (SG/NACL/Subnet/Route)**.

---

### ⚙️ Purpose / How it Works (quick flow)

- Client → **ALB listener** (port/protocol)
- Listener evaluates **rules** → chooses **target group(s)**
- ALB forwards to **registered targets** (instance / IP / lambda) only if **health checks pass** and **networking allows** connections

---

### 🧩 Troubleshooting Steps (fast runbook — do these now)

1. **Confirm ALB is receiving traffic**

```bash
# check ALB RequestCount in CloudWatch (last 5m)
aws cloudwatch get-metric-statistics \
  --namespace AWS/ApplicationELB \
  --metric-name RequestCount \
  --dimensions Name=LoadBalancer,Value=app/my-alb/<id> \
  --start-time $(date -u -d '5 minutes ago' +"%Y-%m-%dT%H:%M:%SZ") \
  --end-time $(date -u +"%Y-%m-%dT%H:%M:%SZ") --period 300 --statistics Sum
```

2. **Check listener → rule → target group mapping**

```bash
# list listeners
aws elbv2 describe-listeners --load-balancer-arn <alb-arn>

# list rules for a listener
aws elbv2 describe-rules --listener-arn <listener-arn>
```

- Ensure the listener protocol/port matches client requests (HTTP/80 or HTTPS/443).
- Ensure rule conditions (host/path/header) match incoming requests.

3. **Verify target group & target registration / health**

```bash
# describe TG
aws elbv2 describe-target-groups --names my-tg

# describe registered targets + health
aws elbv2 describe-target-health --target-group-arn <tg-arn>
```

- If `TargetHealth.State` ≠ `healthy`, inspect target `Reason` and `Description`.

4. **Check health check config**

- Validate `path`, `port`, `protocol`, `matcher`, `interval`, `timeout`, thresholds.
- Example misconfigs: health path returns 404, health check using HTTPS while target listens HTTP, wrong port.

5. **Network connectivity: Security groups / NACL / routes**

- Ensure **ALB SG** outbound allows target port and **Target SG** inbound allows ALB SG (use SG-id in `source_security_group`). Example quick verification:

```bash
# get ALB ENIs
aws ec2 describe-network-interfaces --filters Name=description,Values="ELB app/my-alb/*" --query 'NetworkInterfaces[*].{ID:NetworkInterfaceId,Subnet:SubnetId,PrivateIp:PrivateIpAddress}'
```

- From a bastion inside VPC, test connectivity to target IP:port:

```bash
# from bastion
nc -vz <target-ip> <port>
curl -v http://<target-ip>:<port>/<health-path>
```

6. **ECS / Fargate specific checks**

- If using **awsvpc** (Fargate) ensure `target_type = "ip"` and the container `portMapping.containerPort` is correct. Verify ECS service `loadBalancers` references the correct TG ARN and container name/port.
- Check **task ENIs** and their SG allowing ALB SG.

7. **Check ALB access logs & CloudWatch metrics**

- Enable/inspect ALB access logs in S3 to see request → response codes and timing (target_processing_time).
- Look for `503` or `504` returned by ALB in logs.

8. **Protocol / Header / Response correctness**

- ALB expects **valid HTTP responses** from targets. A target returning non-HTTP data or closing connection early can be treated as unhealthy or produce 502/503.
- If ALB → target uses HTTPS, verify target cert and TLS ciphers.

9. **Registration delays / draining**

- New targets can be `initial` until healthy thresholds met; during deployments ensure `deregistration_delay` and ECS graceful shutdown align.

---

### 📋 Common Causes & Fixes

| **Cause**                                 |                          **How it shows** | **Fix**                                                   |
| ----------------------------------------- | ----------------------------------------: | --------------------------------------------------------- |
| Health check path/port mismatch           |   Targets `unhealthy`, `HTTP 404` in logs | Fix health path/port or app endpoint                      |
| Security group blocks ALB→target          |             Connection refused / nc fails | Allow ALB SG (source) in Target SG inbound on target port |
| Listener->TG mismatch (protocol/port)     |    ALB receives request but TG never used | Update listener default action/rules to correct TG        |
| Target not registered (wrong target_type) | `describe-target-health` shows no targets | For Fargate use `target_type=ip`, for EC2 use `instance`  |
| App not listening on expected port        |    Health checks fail; curl to port fails | Update app/container port mappings or TG port             |
| Target returns non-HTTP payload           |                          502 or unhealthy | Ensure correct protocol, return valid HTTP response       |
| NACL or route table misconfig             |          Intermittent networking failures | Check subnet NACLs and route tables                       |
| ECS task networking (awsvpc) SG wrong     |           ALB → task connectivity blocked | Ensure task ENI SG allows ALB SG                          |
| ALB rules too specific                    |     Requests hit default route (wrong TG) | Adjust rule priority/conditions                           |

---

### 🧩 Quick actionable CLI/Terraform snippets

**Terraform target group (Fargate)**

```hcl
resource "aws_lb_target_group" "web_tg" {
  name        = "web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"           # for Fargate/awsvpc
  health_check { path = "/health" }
}
```

**Re-check registered targets & health**

```bash
aws elbv2 describe-target-health --target-group-arn <tg-arn> --output table
```

**Enable / fetch ALB access logs**

```bash
# modify attributes to enable logs (if not enabled)
aws elbv2 modify-load-balancer-attributes \
  --load-balancer-arn <alb-arn> \
  --attributes Key=access_logs.s3.enabled,Value=true Key=access_logs.s3.bucket,Value=my-alb-logs
```

---

### ✅ Best Practices (prevent recurrence)

- One **target group per service/version** with its own health check.
- Use **awsvpc + target_type=ip** for Fargate; validate containerPort mapping.
- Use **ALB access logs + CloudWatch dashboards** for quick root-cause.
- Always reference **ALB SG** in target SG inbound rules (not 0.0.0.0/0).
- Automate health-check tests from CI/CD (verify endpoint before promoting).
- Implement graceful shutdown handlers in app (SIGTERM) and tune `deregistration_delay`.

---

### 💡 In short

Check listener rules → target group registration → target health → networking (SG/NACL/route) in that order. Use `aws elbv2 describe-target-health`, ALB access logs, and in-VPC `curl/nc` tests to find the bottleneck — usually a health-check mismatch, SG block, or wrong `target_type`/port mapping.

---

## Q: 504 Gateway Timeout

---

### 🧠 Overview

**504 Gateway Timeout** from an ALB/NLB means the load balancer **did not receive a timely response from the backend target** (EC2/ECS/Fargate/Lambda or upstream proxy). It’s a server-side timeout — usually app slowness, wrong ports/protocols, network blocks, or LB timeout settings.

---

### ⚙️ Purpose / How it Works

- Client → ALB listener → ALB forwards to Target Group → Target must respond within LB time limits.
- If the **target doesn’t reply** (or reply takes too long), the LB returns **504** to the client.
- Useful signals: `target_processing_time` (ALB access logs) and CloudWatch `TargetResponseTime`/`HTTPCode_Target_5XX_Count`.

Common root causes:

- Backend request takes longer than LB idle/timeout.
- Backend busy, stuck, or crashed (DB lock, thread exhaustion).
- Security group / network path issues (ALB can’t reach target).
- Misconfigured listener → target protocol mismatch (HTTPS vs HTTP).
- NAT / route table / DNS problems in private subnets.
- Container shutdown/draining during deployment.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Check target health + registration

```bash
aws elbv2 describe-target-health --target-group-arn <tg-arn>
```

#### 2) Inspect ALB access logs (S3) — locate 504s and times

Access log sample fields:

```
http 2025-11-12T12:10:10.000000Z app/my-alb/abcd 1.2.3.4:54321 10.0.1.2:80 0.001 30.005 0.000 504 504 0 123 "GET /api HTTP/1.1" "ua" - - arn:... true
```

Interpretation:

- `request_processing_time` = 0.001
- `target_processing_time` = 30.005 → backend took 30s (likely timeout)
- `elb_status_code` = 504

#### 3) Check CloudWatch metrics (example: TargetResponseTime)

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/ApplicationELB \
  --metric-name TargetResponseTime \
  --dimensions Name=TargetGroup,Value=targetgroup/my-tg/xyz \
  --start-time $(date -u -d '10 minutes ago' +"%Y-%m-%dT%H:%M:%SZ") \
  --end-time $(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --period 60 --statistics Average,Maximum
```

#### 4) Test connectivity from inside VPC (bastion)

```bash
# TCP check
nc -vz <target-ip> <port>

# HTTP health endpoint
curl -sv http://<target-ip>:<port>/health
```

#### 5) Increase ALB idle timeout (if needed)

```bash
aws elbv2 modify-load-balancer-attributes \
  --load-balancer-arn <alb-arn> \
  --attributes Key=idle_timeout.timeout_seconds,Value=60
# set to desired value (default 60s for ALB; WebSocket default is 60)
```

Terraform snippet:

```hcl
resource "aws_lb" "alb" {
  # ...
  idle_timeout {
    timeout_seconds = 60
  }
}
```

_(Note: provider/config syntax may differ; CLI is reliable.)_

#### 6) Ensure listener/target protocol match

- ALB listener HTTPS → TG protocol HTTP (re-encrypt optional) — verify port/protocols.

#### 7) If using NLB and TLS passthrough, verify backend TLS handshake metrics:

```bash
# CloudWatch metric for TLS negotiation errors
aws cloudwatch get-metric-statistics --namespace AWS/NetworkELB --metric-name TargetTLSNegotiationErrorCount ...
```

---

### 📋 Quick Checklist (triage steps)

1. **Is ALB receiving traffic?** → `RequestCount` in CloudWatch.
2. **Are targets healthy?** → `describe-target-health` (healthy/unhealthy + reason).
3. **Does target respond quickly from inside VPC?** → `curl`/`nc` from bastion.
4. **Are SGs/NACLs/route tables correct?** → ALB SG → target SG inbound allowed.
5. **Is app slow or overloaded?** → app logs, DB queries, thread pools.
6. **Is there a protocol/port mismatch?** → listener vs TG config.
7. **LB timeout vs app processing time?** → consider increasing `idle_timeout` or optimizing app.
8. **Are there deployment/draining events?** → ECS task state, deregistration delay.
9. **Check ALB access logs** for `target_processing_time` spikes and repeated 504s.
10. **Monitor CloudWatch** for `HTTPCode_Target_5XX_Count`, `TargetResponseTime`, `UnHealthyHostCount`.

---

### ✅ Best Practices / Remediations

- 🔧 **Fix slow backends**: optimize queries, add caching, increase concurrency (worker pools), or autoscale.
- ⏱️ **Tune timeouts carefully**:

  - ALB `idle_timeout` default ~**60s** for ALB — increase only if necessary.
  - For long-running requests (file uploads, long polling), prefer chunked uploads or asynchronous jobs.

- 🔁 **Use asynchronous processing**: return 202 and use background worker for long tasks.
- 🧪 **Health checks**: keep them lightweight and separate from heavy endpoints.
- 🔒 **Networking**: ensure ALB SG is allowed in target SG inbound; test from VPC.
- 🔃 **Graceful shutdown**: implement SIGTERM handling and align ECS `deregistration_delay` with app shutdown to avoid dropped requests.
- 🪝 **Circuit breaker / bulkhead patterns**: protect downstream DB/external services.
- 📊 **Alerting**: create CloudWatch alarms on `TargetResponseTime` and `HTTPCode_Target_5XX_Count`.
- 🧾 **Logs & Tracing**: correlate ALB access logs, app logs, and distributed traces (X-Request-ID / X-Ray) for RCA.
- 🌐 **If global users**: consider edge caching (CloudFront) for static content and Global Accelerator to reduce network latency.

---

### 💡 In short

A **504** means the load balancer waited too long for a backend reply. Triage by checking **target health**, **ALB access logs (`target_processing_time`)**, **CloudWatch `TargetResponseTime`**, and **VPC connectivity (SGs, routes)**. Fix by optimizing backend response time, scaling capacity, or increasing LB timeouts only when appropriate — plus implement graceful shutdown and lightweight health checks.

---

## Q: ECS service unhealthy behind ALB

---

### 🧠 Overview

When an **ECS service** shows as **unhealthy behind an ALB**, the ALB’s target group health checks are failing or networking/configuration prevents the ALB from reaching the task ENIs/containers. This blocks traffic routing and auto-scaling.

---

### ⚙️ Purpose / How it Works

- ECS Service registers tasks into the ALB **Target Group** (target_type = `ip` for Fargate/awsvpc or `instance` for EC2).
- ALB performs **health checks** on each registered target; only `healthy` targets receive traffic.
- Failures = ALB marks target `unhealthy` → traffic not forwarded → service appears unhealthy.

---

### 🧩 Quick Triage Checklist (do these in order)

1. **Check Target Health**

```bash
aws elbv2 describe-target-health --target-group-arn <tg-arn> --output table
```

- Look at `State` and `Description` for reasons (`Health checks failed`, `Connection refused`, `Target responded with 404`, etc).

2. **Verify Health Check Path & Settings**

- Ensure TG `health_check.path` returns 200 quickly (no DB calls).
- Typical config: `path=/health`, `interval=15-30s`, `timeout=5s`, `healthy_threshold=2`, `unhealthy_threshold=2`.

```bash
aws elbv2 describe-target-groups --target-group-arns <tg-arn> --query 'TargetGroups[*].HealthCheck*'
```

3. **Confirm target_type and ports**

- Fargate (awsvpc) → `target_type = "ip"`, register container `hostPort`/`containerPort` mapping correctly.
- EC2 → `target_type = "instance"` and TG port should match `hostPort`.
- In ECS task definition, `containerPort` must match what ALB expects.

4. **Test connectivity from inside VPC**

- From a bastion in same subnet/VPC:

```bash
# HTTP
curl -sv http://<task-ip>:<port>/health
# TCP
nc -vz <task-ip> <port>
```

- If connection fails → SG / route / ENI problem.

5. **Security Groups**

- ALB security group must allow inbound (80/443) from internet.
- Target task ENI security group must allow inbound from **ALB SG** (use SG-id, not 0.0.0.0/0). Example rule:

  - Source: `sg-ALB`, Port: target port (e.g., 8080), Protocol: TCP.

6. **Check ECS task ENI & assignment**

```bash
aws ecs describe-tasks --cluster <cluster> --tasks <task-id>
# then check networkInterfaces in the response (ENI IPs)
```

- Ensure tasks have ENIs and correct IPs; find those IPs and curl them.

7. **Container startup / readiness**

- Ensure app binds to `0.0.0.0` inside container (not localhost).
- Ensure startup time < health check timeout; if slow, increase `startPeriod` in container health or adjust TG health thresholds.

8. **ECS & ALB registration logs**

- Check ECS events (service page) and CloudWatch logs for `deregister` / `registration` messages and reasons.

```bash
aws ecs describe-services --cluster <c> --services <s> --query 'services[*].events'
```

9. **Health check vs Container health checks**

- ALB health checks are separate from container `HEALTHCHECK` in Docker — both can be used; ensure consistency.

10. **Task role / IAM / DNS**

- If health path calls internal services by DNS, ensure task can resolve DNS and has network egress (NAT) if required.

---

### 🧩 Common Root Causes & Fixes

| Cause                               |                                   Symptom | Fix                                                        |
| ----------------------------------- | ----------------------------------------: | ---------------------------------------------------------- |
| Health path returns 404/500         |          `unhealthy` with 4xx/5xx in logs | Correct endpoint; make it lightweight (no DB)              |
| Security Group blocks ALB→task      |         `Connection refused` or `timeout` | Allow ALB SG in task SG inbound on target port             |
| Wrong target_type or port           |          No targets registered or failing | Use `ip` for Fargate; align ports between TG and container |
| App listening on localhost only     |               Connection refused from ALB | Bind to `0.0.0.0` inside container                         |
| Long startup / heavy init           | `initial` or failing health until timeout | Increase startPeriod or TG timeout/thresholds              |
| ENI not attached / subnet misconfig |                     No route to target IP | Ensure correct subnets and ENI assignment                  |
| Docker container crashes            |             Targets deregister repeatedly | Inspect container logs, restart reason, fix crash          |
| Path TLS mismatch                   |                    TLS negotiation errors | Match TG protocol (HTTP vs HTTPS) and certificates         |

---

### 🧩 Helpful Commands & Terraform snippets

**Describe target health**

```bash
aws elbv2 describe-target-health --target-group-arn <tg-arn>
```

**Check ECS service events**

```bash
aws ecs describe-services --cluster my-cluster --services my-svc --query 'services[0].events' --output table
```

**Test from bastion**

```bash
curl -sv http://10.0.2.45:8080/health
nc -vz 10.0.2.45 8080
```

**Terraform: correct TG for Fargate**

```hcl
resource "aws_lb_target_group" "svc_tg" {
  name        = "svc-tg"
  target_type = "ip"           # Fargate/awsvpc
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}
```

**ECS task definition port mapping (awsvpc)**

```json
"portMappings": [
  { "containerPort": 8080, "hostPort": 8080, "protocol": "tcp" }
]
```

---

### ✅ Best Practices (prevent recurrence)

- One **target group per service** with dedicated health endpoint (`/health`) that returns 200 quickly.
- For **Fargate/awsvpc** use `target_type="ip"` and ensure tasks get ENIs in private subnets with correct SGs.
- Bind containers to `0.0.0.0`.
- Keep health checks lightweight; avoid DB or network calls.
- Align ECS **deregistration_delay** and container **graceful shutdown** (SIGTERM handling).
- Add CloudWatch alarms for `UnHealthyHostCount` and `HTTPCode_Target_5XX_Count`.
- Use ALB access logs + app logs + X-Request-ID to correlate failures.

---

### 💡 In short

If ECS tasks are unhealthy behind an ALB, first check **`describe-target-health`** and the TG health-check config, then verify **SGs, target_type (ip vs instance), port mappings**, and that the container binds to `0.0.0.0`. Fix the smallest failing item (health path, SG rule, or port) then redeploy and monitor health.

---

## Q: Traffic uneven across AZs

---

### 🧠 Overview

Uneven traffic across Availability Zones (AZs) means one AZ receives significantly more requests than others.
Common causes: per-AZ LB node routing, unequal target counts, cross-zone load balancing disabled, client IP affinity, health-check failures, or misconfigured placement (ECS/EKS).

---

### ⚙️ Purpose / How it Works

- An ELB creates nodes in each enabled AZ.
- By default **ALB** distributes across all AZs (cross-zone enabled by default). **NLB/CLB** may route only to targets in the node’s AZ unless cross-zone is enabled.
- If AZ A has fewer targets than AZ B, a node in AZ A may route more traffic to its local targets → apparent imbalance.
- Source-IP affinity (NLB, client IP hash, or sticky sessions) concentrates traffic from clients clustered geographically or behind NATs.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Quick checks (CLI)

```bash
# 1. See Load Balancer attributes (cross-zone)
aws elbv2 describe-load-balancer-attributes --load-balancer-arn <alb-arn>

# 2. Check target health & registration
aws elbv2 describe-target-health --target-group-arn <tg-arn>

# 3. Number of healthy targets per AZ (map target IP → AZ)
aws elbv2 describe-target-health --target-group-arn <tg-arn> --query 'TargetHealthDescriptions[*].Target' --output json

# then map instance-id / ENI IPs to AZs:
aws ec2 describe-instances --instance-ids i-...
aws ec2 describe-network-interfaces --network-interface-ids eni-...

# 4. Inspect RequestCount per AvailabilityZone (CloudWatch)
aws cloudwatch get-metric-statistics \
  --namespace AWS/ApplicationELB \
  --metric-name RequestCount \
  --dimensions Name=LoadBalancer,Value=app/my-alb/abc123 Name=AvailabilityZone,Value=ap-south-1a \
  --start-time $(date -u -d '10 minutes ago' +"%Y-%m-%dT%H:%M:%SZ") \
  --end-time $(date -u +"%Y-%m-%dT%H:%M:%SZ") --period 300 --statistics Sum
```

#### 2) Enable cross-zone load balancing (NLB or CLB) — CLI

```bash
aws elbv2 modify-load-balancer-attributes \
  --load-balancer-arn <lb-arn> \
  --attributes Key=load_balancing.cross_zone.enabled,Value=true
```

> Note: **ALB** has cross-zone enabled by default (cannot be disabled).

#### 3) Terraform (enable cross-zone on aws_lb)

```hcl
resource "aws_lb" "nlb" {
  name               = "nlb"
  load_balancer_type = "network"
  subnets            = var.subnets
  enable_cross_zone_load_balancing = true    # ensure provider supports this attr
}
```

#### 4) Even target placement (ECS Fargate example)

```hcl
# ECS service: use placement strategy to spread tasks across AZs
resource "aws_ecs_service" "svc" {
  # ...
  deployment_controller { type = "ECS" }
  placement_constraints { type = "distinctInstance" }   # for EC2
  placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }
}
```

---

### 📋 Causes & Fixes Table

| **Cause**                        |                              **Symptom** | **Fix**                                                      |
| -------------------------------- | ---------------------------------------: | ------------------------------------------------------------ |
| Cross-zone LB disabled (NLB/CLB) |       Local nodes overload local targets | Enable cross-zone load balancing                             |
| Uneven target counts per AZ      |         AZ with fewer targets overloaded | Register equal # of targets per AZ (autoscaling placement)   |
| Target health differences        |          Some AZs show unhealthy targets | Fix health checks, app errors, SGs                           |
| Source IP affinity / stickiness  |              Same clients map to same AZ | Disable stickiness or use ALB `lb_cookie`; use NLB carefully |
| ECS/EKS placement skew           |                 Tasks scheduled unevenly | Use placement strategies to spread tasks                     |
| Route or subnet misconfig        |                Requests fail to some AZs | Check subnet routing, NACLs, NAT gateways                    |
| DNS caching at clients           | Clients keep resolving to one LB node IP | Use Route53/short TTLs; ALB DNS manages multi-AZ IPs         |

---

### ✅ Best Practices

- **Enable cross-zone load balancing** for even distribution (ALB already enabled).
- **Ensure equal healthy targets per AZ** — autoscale per-AZ or use spread placement.
- **Avoid per-client affinity** unless necessary; prefer short cookie TTLs or stateless design.
- **Use ALB** for HTTP L7 routing (ALB handles cross-zone by default and supports stickiness control).
- **Monitor per-AZ metrics** (`RequestCount` by AvailabilityZone) and `HealthyHostCount`.
- **Place targets in all enabled AZs** and ensure ALB subnets include all AZs.
- **For NLB with static IP needs**, enable cross-zone but be aware of inter-AZ data charges.
- **Test from synthetic clients in multiple regions/AZs** to validate distribution.

---

### 💡 In short

Uneven AZ traffic usually stems from **cross-zone disabled**, **unequal target counts**, or **source-IP affinity**. Fix by **enabling cross-zone**, **spreading/registering equal targets per AZ**, and removing unwanted stickiness — then verify with CloudWatch per-AZ `RequestCount` and `describe-target-health`.

---

## Q: ALB logs missing

---

### 🧠 Overview

ALB access logs are delivered to an **S3 bucket**. If logs are missing, the problem is usually one of: **ALB attributes not enabled**, **S3 bucket/policy/KMS permissions blocking delivery**, wrong **prefix/region**, or **you’re checking the wrong place/time**. This doc is a focused runbook to find and fix the issue.

---

### ⚙️ Purpose / How it Works

- ALB writes access-log objects to the configured S3 bucket/prefix.
- ALB must be allowed to `PutObject` into that bucket (via bucket policy or ACL) and — if the bucket uses KMS encryption — the ALB service must be allowed to use the KMS key.
- ALB delivery is asynchronous (objects are created periodically), so check attributes, permissions, and S3 contents.

---

### 🧩 Troubleshooting steps (ordered, run these)

1. **Confirm ALB logging is enabled**

```bash
aws elbv2 describe-load-balancer-attributes \
  --load-balancer-arn <alb-arn> \
  --query 'Attributes[?starts_with(Key, `access_logs.`)]'
```

- Look for: `access_logs.s3.enabled` = `true`, `access_logs.s3.bucket` and `access_logs.s3.prefix`.

2. **List objects in the target S3 prefix**

```bash
aws s3api list-objects-v2 --bucket my-alb-logs --prefix "alb/app-my-alb/" --max-items 20
```

- If objects exist, logs are being delivered — check timeframe and prefixes.

3. **Check S3 bucket policy / ACL**

```bash
aws s3api get-bucket-policy --bucket my-alb-logs || echo "no policy"
aws s3api get-bucket-acl --bucket my-alb-logs
```

- Ensure policy allows ALB to `s3:PutObject` for the `access_logs.s3.prefix`. Best practice: allow PutObject with conditions `aws:SourceArn` = ALB ARN and `aws:SourceAccount` = your account id.

**Example minimal bucket policy (use your ARNs/account IDs):**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowALBAccess",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::my-alb-logs/alb/*",
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": "123456789012",
          "aws:SourceArn": "arn:aws:elasticloadbalancing:ap-south-1:123456789012:loadbalancer/app/my-alb/abcdef"
        }
      }
    }
  ]
}
```

4. **If bucket uses SSE-KMS — check KMS key policy / grants**

- If S3 objects are encrypted with a customer-managed KMS key, add the ALB service principal permission to use the key. Example principal: `"Service": "elasticloadbalancing.amazonaws.com"` with condition on `aws:SourceArn`/`aws:SourceAccount`.
- Without this, PutObject will be denied and ALB cannot write logs.

5. **Check S3 Block Public Access / Ownership settings**

- Ensure bucket ownership or object-ownership doesn’t interfere with ELB writes. Bucket owner preferred; if cross-account delivery is used, ensure object-ownership settings allow it.

6. **Verify ALB and S3 prefix/region**

- Confirm you are looking in the _exact_ bucket + prefix the ALB is configured with. Use the `describe-load-balancer-attributes` output to avoid mistakes.

7. **Check for delivery errors / CloudTrail / CloudWatch**

- Look for S3 `PutObject` Deny events in CloudTrail or S3 access logs for denied PutObject attempts.
- If you have CloudTrail or AWS Config, search for `PutObject` or `PutBucketPolicy` denied events.

8. **Enable/Check ALB attributes if missing**

```bash
# enable logging
aws elbv2 modify-load-balancer-attributes \
  --load-balancer-arn <alb-arn> \
  --attributes Key=access_logs.s3.enabled,Value=true \
               Key=access_logs.s3.bucket,Value=my-alb-logs \
               Key=access_logs.s3.prefix,Value=alb/my-alb
```

9. **Allow time & validate cadence**

- Logs are generated periodically — verify across a wider time window and check multiple prefixes (date-based). If you just enabled logging, wait a few minutes and re-check objects.

10. **If still missing: test delivery manually**

- From an IAM principal, try to `PutObject` into the bucket using the same prefix to validate permissions (this doesn’t prove ALB access, but validates the bucket policy).

```bash
aws s3 cp /tmp/test.txt s3://my-alb-logs/alb/my-alb/test.txt
```

- If this fails with an AccessDenied, correct the bucket/KMS policy.

---

### 🧩 Quick commands summary

- Describe ALB attributes:

```bash
aws elbv2 describe-load-balancer-attributes --load-balancer-arn <alb-arn>
```

- List recent objects:

```bash
aws s3api list-objects-v2 --bucket my-alb-logs --prefix "alb/my-alb/" --max-items 50
```

- Inspect bucket policy / ACL:

```bash
aws s3api get-bucket-policy --bucket my-alb-logs
aws s3api get-bucket-acl --bucket my-alb-logs
```

- Check CloudTrail for denied PutObject:

```bash
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=PutObject --max-results 50
```

---

### 📋 Common Causes & Fixes

| **Symptom**                           | **Likely Cause**                               | **Fix**                                                                                                      |
| ------------------------------------- | ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| No objects in S3                      | Logging not enabled or wrong prefix            | Enable logging or correct prefix via `modify-load-balancer-attributes`                                       |
| AccessDenied on PutObject             | Bucket policy/KMS denies ELB                   | Update S3 bucket policy and/or KMS key policy to allow ALB service (with SourceArn/SourceAccount conditions) |
| Objects exist but older than expected | ALB writes periodically; time window misread   | Search wider date ranges and prefixes                                                                        |
| Logs intermittently missing           | Delivery blocked occasionally by policy or KMS | Check CloudTrail for denied PutObject events and add necessary grants                                        |
| Testing PutObject fails               | Bucket ownership/object-ownership issues       | Adjust bucket owner settings or use bucket policy with SourceArn condition                                   |

---

### ✅ Best Practices (prevent recurrence)

- Use the ALB **attributes** block (Terraform) or `modify-load-balancer-attributes` to set bucket + prefix.
- Use an S3 bucket policy with `aws:SourceArn` and `aws:SourceAccount` to tightly allow only your ALB to write.
- If using KMS encryption, add **elasticloadbalancing.amazonaws.com** (service principal) to the key policy with source ARN/account conditions.
- Enable S3 lifecycle rules to manage log retention and cost.
- Enable CloudTrail or S3 server access logs to capture delivery failures.
- Keep a consistent prefix pattern (e.g., `alb/<alb-name>/YYYY/MM/DD/`) to simplify queries and Athena tables.

---

### 💡 In short

Check `describe-load-balancer-attributes` → confirm `access_logs.s3.*` settings → verify the S3 bucket + prefix exist → check bucket policy/ACL and KMS key policy (if SSE-KMS) to ensure ALB can `PutObject`. Use CloudTrail or S3 access logs to find denied deliveries and fix permissions; once fixed, verify objects appear under the configured prefix.

---

## Q: How to Redirect HTTP → HTTPS in AWS Application Load Balancer (ALB)

---

### 🧠 Overview

Redirecting **HTTP traffic to HTTPS** ensures all users securely connect to your application.
In AWS ALB, you achieve this using a **listener rule** with an **action type = `redirect`** on the **port 80 (HTTP)** listener.
This is handled **natively by ALB** — no need for app-level redirection (like Nginx or code changes).

---

### ⚙️ Purpose / How It Works

- ALB listens on **port 80 (HTTP)** and **port 443 (HTTPS)**.
- The HTTP listener’s **default action** redirects all incoming requests to HTTPS (port 443).
- The redirect preserves host, path, and query string unless overridden.
- The browser receives an **HTTP 301 (permanent redirect)** or **302 (temporary)** response.

---

### 🧩 Example 1: Terraform Configuration

```hcl
resource "aws_lb" "app_alb" {
  name               = "app-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]
}

# HTTPS Listener (port 443)
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.app_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# HTTP Listener (port 80) with redirect to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
```

✅ **Result:**
Any HTTP request (port 80) → ALB sends a `301 Redirect` → Client reconnects over HTTPS (port 443).

---

### 🧩 Example 2: AWS CLI

```bash
# Create HTTP listener with redirect action
aws elbv2 create-listener \
  --load-balancer-arn arn:aws:elasticloadbalancing:region:acct:loadbalancer/app/my-alb/abc123 \
  --protocol HTTP \
  --port 80 \
  --default-actions Type=redirect,RedirectConfig='{Port="443",Protocol="HTTPS",StatusCode="HTTP_301"}'
```

---

### 🧩 Example 3: AWS Console Steps

1. Go to **EC2 → Load Balancers → [Your ALB]**.
2. Open **Listeners** tab → click **Add Listener** (or edit port 80).
3. Choose:

   - **Protocol:** HTTP
   - **Port:** 80
   - **Default action:** Redirect to → `HTTPS://:443/`
   - **Status code:** `HTTP_301` (permanent redirect)

4. Save changes.
5. Verify using:

   ```bash
   curl -I http://your-domain.com
   ```

   Output should show:

   ```
   HTTP/1.1 301 Moved Permanently
   location: https://your-domain.com/
   ```

---

### 📋 Redirect Config Parameters

| **Parameter** | **Description**                          | **Example**                     |
| ------------- | ---------------------------------------- | ------------------------------- |
| `protocol`    | Destination protocol (`HTTP` or `HTTPS`) | `"HTTPS"`                       |
| `port`        | Destination port                         | `"443"`                         |
| `status_code` | Redirect type (`HTTP_301`, `HTTP_302`)   | `"HTTP_301"`                    |
| `host`        | (Optional) Override hostname             | `example.com`                   |
| `path`        | (Optional) Override path                 | `/newpath`                      |
| `query`       | (Optional) Append/modify query string    | `#{query}` to preserve existing |

Example for preserving everything:

```hcl
redirect {
  port        = "443"
  protocol    = "HTTPS"
  status_code = "HTTP_301"
  host        = "#{host}"
  path        = "/#{path}"
  query       = "#{query}"
}
```

---

### ✅ Best Practices

- Always use **HTTP_301 (permanent redirect)** for SEO and browser caching.
- Use **AWS ACM** certificates for HTTPS (auto-renewal).
- Enable **HTTPS (port 443)** listener _before_ applying redirect to avoid downtime.
- Enforce **modern TLS policy** (e.g., `ELBSecurityPolicy-TLS-1-2-Ext-2018-06`).
- Redirect only at **ALB layer** — don’t duplicate redirection in app code.
- Optionally enable **HSTS** header in your app to force HTTPS at the browser level.

---

### 💡 In short

Create an **HTTP listener (port 80)** → add a **redirect action** to `HTTPS:443` with `HTTP_301`.
This offloads HTTPS enforcement to ALB, simplifies app config, and guarantees **secure-by-default access**.

---

## Q: NLB Target Showing Unhealthy

---

### 🧠 Overview

When **Network Load Balancer (NLB)** targets show **Unhealthy**, it means the **target health checks are failing** — either the NLB cannot reach the target on the configured port/protocol, or the target isn’t responding as expected.
Unlike ALB, NLB operates at **Layer 4 (TCP/TLS)**, so the root cause is usually **networking**, **ports**, or **target health configuration**, not application-level errors.

---

### ⚙️ Purpose / How It Works

- NLB continuously performs **TCP or TLS health checks** on each target.
- If a target fails a configured number of checks (default: 3), it’s marked **unhealthy**.
- NLB will **stop routing** new connections to unhealthy targets.
- Common culprits:

  - Wrong **health check port or protocol**
  - **Security Group/NACL** blocking health probe
  - **App not listening** on correct port or IP
  - **Target_type mismatch** (instance vs IP)
  - **Private link or subnet routing** issues

---

### 🧩 Step-by-Step Troubleshooting Guide

#### 🔹 1️⃣ Verify Target Health via CLI

```bash
aws elbv2 describe-target-health --target-group-arn <tg-arn> --output table
```

✅ Check:

- **`TargetHealth.State`** — should be `healthy`.
- **`Description`** — tells you why it’s unhealthy (`Target.Timeout`, `Connection refused`, `Health checks failed`, etc).

Example output:

```
| Target.Id | Target.Port | TargetHealth.State | Description               |
|------------|-------------|--------------------|---------------------------|
| 10.0.1.25  | 8080        | unhealthy          | Target.Timeout            |
```

---

#### 🔹 2️⃣ Validate Health Check Configuration

Run:

```bash
aws elbv2 describe-target-groups --target-group-arn <tg-arn> \
  --query "TargetGroups[*].HealthCheck*"
```

✅ Check:

| Setting                | Expected Value                   |
| ---------------------- | -------------------------------- |
| **Protocol**           | TCP / TLS (use HTTP only if ALB) |
| **Port**               | Matches your app listener port   |
| **HealthyThreshold**   | ≥2                               |
| **UnhealthyThreshold** | ≥2                               |
| **Timeout**            | 5–10s (reasonable)               |
| **Interval**           | 10–30s (typical)                 |

🧩 Example Terraform:

```hcl
resource "aws_lb_target_group" "nlb_tg" {
  name     = "nlb-tg"
  port     = 8080
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    protocol            = "TCP"
    port                = "8080"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}
```

---

#### 🔹 3️⃣ Test Network Reachability (from same VPC)

If health check is TCP/port 8080, test manually:

```bash
nc -vz <target-ip> 8080
```

✅ Should show:

```
Connection to <target-ip> 8080 port [tcp/*] succeeded!
```

If it fails:

- Target isn’t listening on that port → fix app config.
- Security Group/NACL blocks → check inbound/outbound rules.

---

#### 🔹 4️⃣ Check Security Groups / NACLs

| **Component**  | **Rule Type** | **Direction**                     | **Rule Example**               |
| -------------- | ------------- | --------------------------------- | ------------------------------ |
| **Target SG**  | Inbound       | Allow from NLB’s source IP or SG  | TCP 8080 from NLB subnet CIDRs |
| **NLB Subnet** | NACL          | Allow inbound + outbound TCP 8080 | Ensure no Deny rules           |

🧩 Example SG fix:

```bash
aws ec2 authorize-security-group-ingress \
  --group-id sg-target \
  --protocol tcp --port 8080 \
  --cidr 10.0.0.0/16  # NLB subnet CIDR or source ALB SG
```

> 🔎 NLBs use **private IPs of subnet ENIs** as the source of health checks — not a fixed IP range.
> If you’re locking down with SGs, **allow the entire subnet CIDR** for health check traffic.

---

#### 🔹 5️⃣ Check Target App Configuration

- Ensure service is **listening on correct port/IP (0.0.0.0)**.
- For **ECS tasks (awsvpc)**: container must bind to `0.0.0.0` and **containerPort** = TG port.
- For **EC2**: verify service running:

  ```bash
  sudo netstat -tulnp | grep 8080
  ```

  or

  ```bash
  ss -tuln | grep 8080
  ```

---

#### 🔹 6️⃣ Verify Target Registration Type

- **target_type = instance** → NLB connects to instance private IP.
- **target_type = ip** → NLB connects directly to IP address.
- Wrong type = unreachable target.

Check:

```bash
aws elbv2 describe-target-groups --names my-nlb-tg --query "TargetGroups[*].TargetType"
```

---

#### 🔹 7️⃣ Check for Network Routing / Subnet Misconfigurations

- Target and NLB must be in **same VPC** and **routable subnets**.
- For **private NLBs**, ensure route tables allow return traffic.
- For **targets behind NAT**, ensure NAT allows internal VPC communication.

---

#### 🔹 8️⃣ Verify Target Logs

- Check your application logs for startup delays, binding errors, or TCP resets.
- If you see “connection refused” or “bind failed,” update the service configuration.

---

#### 🔹 9️⃣ Check CloudWatch Metrics

Use metrics under namespace **`AWS/NetworkELB`**:

- `UnHealthyHostCount`
- `HealthyHostCount`
- `TCP_Target_Reset_Count`
- `TargetTLSNegotiationErrorCount`

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/NetworkELB \
  --metric-name UnHealthyHostCount \
  --dimensions Name=TargetGroup,Value=targetgroup/my-tg/abc123 \
  --start-time $(date -u -d '10 minutes ago' +"%Y-%m-%dT%H:%M:%SZ") \
  --end-time $(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --period 60 --statistics Maximum
```

---

### 📋 Common Root Causes & Fixes

| **Cause**                              | **Symptom**                       | **Fix**                                      |
| -------------------------------------- | --------------------------------- | -------------------------------------------- |
| Target SG blocks health checks         | `Connection timed out`            | Allow NLB subnet CIDR inbound on target port |
| Wrong health check port                | Always unhealthy                  | Use actual app port                          |
| App not listening / crashed            | TCP timeout                       | Restart app / fix port binding               |
| Target binds to localhost only         | `Connection refused`              | Bind to `0.0.0.0`                            |
| Wrong target type (`instance` vs `ip`) | Target unreachable                | Use correct type for EC2/Fargate             |
| NACL denies ephemeral ports            | Health checks fail intermittently | Allow ephemeral port range 1024–65535        |
| TLS health check with self-signed cert | `TLS negotiation error`           | Use valid cert or switch to TCP check        |
| Subnet routing / VPC misconfig         | No return path                    | Fix route tables / ensure same VPC           |

---

### ✅ Best Practices

- Use **TCP health checks** for NLBs unless TLS termination is needed.
- For ECS Fargate: set `target_type = ip`, ensure containerPort = TG port, and container listens on `0.0.0.0`.
- Keep **health checks lightweight** — no app-level logic required for TCP.
- Always allow **NLB subnet CIDRs** in the target SG inbound.
- Use **CloudWatch alarms** for `UnHealthyHostCount` > 0.
- Validate health check responses manually using `nc` or `telnet`.
- Use **AWS VPC Reachability Analyzer** to test paths between NLB and target ENIs.

---

### 💡 In short

An **unhealthy NLB target** means the NLB can’t complete health checks.
Check **security groups**, **target port/protocol**, and **app listening state**.
✅ Ensure health checks match actual service port, SGs allow NLB subnet CIDRs, and the app binds to `0.0.0.0`.
Once fixed, rerun `describe-target-health` until all targets are `healthy`.

---

## Q: Need Static IP for ALB

---

### 🧠 Overview

**Application Load Balancer (ALB)** does **not support static IP addresses** directly — ALB endpoints are **DNS-based** and AWS dynamically manages their underlying IPs for scalability and fault tolerance.
However, you can still achieve a _static-IP-like setup_ using **AWS Global Accelerator** or by placing an **NLB in front of your ALB**.

---

### ⚙️ Purpose / How It Works

- ALB’s DNS name (e.g., `my-alb-123456.ap-south-1.elb.amazonaws.com`) resolves to **multiple IPs** that **change** when AWS replaces nodes for scaling or AZ maintenance.
- Some firewalls or clients require **fixed IPs** (whitelisting).
- AWS provides **two recommended solutions**:

  1. **AWS Global Accelerator (preferred)** → provides **static Anycast IPs** that route to your ALB.
  2. **NLB + ALB chaining** → use an **NLB (static IP)** to forward traffic to your ALB.

---

### 🧩 Option 1: AWS Global Accelerator (Recommended ✅)

#### 💡 How it works

- Provides **two static Anycast IPs** (global, fault-tolerant).
- Routes client traffic to your ALB endpoint in the closest AWS region.
- Handles DDoS protection, latency optimization, and failover automatically.

#### Terraform Example

```hcl
resource "aws_globalaccelerator_accelerator" "example" {
  name               = "alb-static-ip-accelerator"
  enabled            = true
  ip_address_type    = "IPV4"
}

resource "aws_globalaccelerator_listener" "listener" {
  accelerator_arn = aws_globalaccelerator_accelerator.example.id
  protocol        = "TCP"
  port_ranges {
    from_port = 80
    to_port   = 443
  }
}

resource "aws_globalaccelerator_endpoint_group" "alb_endpoint" {
  listener_arn = aws_globalaccelerator_listener.listener.id
  endpoint_configuration {
    endpoint_id = aws_lb.app_alb.arn
    weight      = 100
  }
}
```

#### Output

```bash
aws globalaccelerator describe-accelerator --accelerator-arn <arn>
```

You’ll get:

```json
"IpSets": [
  { "IpAddresses": ["13.248.xx.xx", "76.223.xx.xx"], "IpFamily": "IPv4" }
]
```

✅ **These are your permanent, static IPs** — clients can safely whitelist them.

---

### 🧩 Option 2: NLB → ALB Chaining

#### 💡 How it works

- Create an **NLB** with **Elastic IPs** (static).
- The NLB listens on TCP 80/443 and forwards to the ALB’s private endpoint.
- Provides static IPs but still uses ALB’s advanced L7 routing.

#### Terraform Example

```hcl
# Static Elastic IPs for NLB
resource "aws_eip" "nlb_eip" {
  count = 2
  domain = "vpc"
}

resource "aws_lb" "nlb" {
  name               = "nlb-static"
  load_balancer_type = "network"
  subnets            = var.public_subnets
  enable_cross_zone_load_balancing = true

  subnet_mapping {
    subnet_id     = element(var.public_subnets, 0)
    allocation_id = aws_eip.nlb_eip[0].id
  }
  subnet_mapping {
    subnet_id     = element(var.public_subnets, 1)
    allocation_id = aws_eip.nlb_eip[1].id
  }
}

# Target group pointing to ALB DNS
resource "aws_lb_target_group" "alb_tg" {
  name     = "nlb-alb-tg"
  port     = 443
  protocol = "TCP"
  vpc_id   = var.vpc_id
  target_type = "ip"  # Use ALB private IPs or Route53 alias via Lambda registration
}

# NLB listener
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 443
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}
```

⚠️ **Limitations:**

- Adds one more hop (minor latency).
- Target group must use ALB **private IPs** or be dynamically registered.
- You lose Layer 7 intelligence at NLB — it’s TCP only.

---

### 📋 Comparison Table

| Feature         | **ALB**           | **Global Accelerator + ALB**      | **NLB → ALB**                           |
| --------------- | ----------------- | --------------------------------- | --------------------------------------- |
| Static IPs      | ❌ No             | ✅ Yes (2 Anycast IPs)            | ✅ Yes (Elastic IPs)                    |
| Layer           | L7 (HTTP/HTTPS)   | L4 (TCP/UDP) → L7 (ALB)           | L4 → L7                                 |
| Global Routing  | ❌ Regional only  | ✅ Yes                            | ❌ Regional only                        |
| DDoS Protection | ✅ AWS Shield Std | ✅ AWS Shield Advanced built-in   | ✅ AWS Shield Std                       |
| Cost            | Low               | Moderate (Global Accelerator)     | Moderate                                |
| Ideal For       | Web apps          | Global or enterprise whitelisting | Region-specific apps needing static IPs |

---

### ✅ Best Practices

- **Prefer Global Accelerator** for global/static IP needs.
- If using NLB fronting ALB, monitor latency and health closely.
- Keep **DNS (Route53)** pointing to **ALB DNS**, not static IPs, when static IPs aren’t required.
- Use **ACM Certificates** for HTTPS at the ALB — not at NLB (unless TLS pass-through).
- Avoid hardcoding ALB IPs; AWS may change them at any time.

---

### 💡 In short

ALB itself doesn’t offer static IPs — it’s **DNS-managed**.
To get static IPs:

1. Use **AWS Global Accelerator** ✅ (recommended, global, 2 static Anycast IPs).
2. Or **front ALB with NLB + Elastic IPs** for regional static IPs.
   👉 Global Accelerator is simpler, faster, and fully AWS-supported for enterprise whitelisting use cases.

---

## Q: Restrict API Access to Internal VPCs (via ALB / AWS Network Controls)

---

### 🧠 Overview

To restrict API access so that **only internal VPC resources** (e.g., EC2, ECS, Lambda in same VPC) can reach your Application Load Balancer (ALB) or API endpoints — you must **limit exposure at the network and routing level**.
This ensures your APIs are **not reachable from the public internet** and are only accessible **within your AWS VPC or over VPN/Direct Connect**.

---

### ⚙️ Purpose / How It Works

There are **3 main patterns** to restrict ALB/API access to internal traffic:

| **Method**                              | **Use Case**                                 | **Key Mechanism**                                     |
| --------------------------------------- | -------------------------------------------- | ----------------------------------------------------- |
| **1️⃣ Internal ALB (private)**           | For internal microservices or APIs           | ALB deployed in private subnets only                  |
| **2️⃣ Security Groups (SGs)**            | Limit access to specific VPC resources       | Allow inbound only from trusted SGs                   |
| **3️⃣ WAF / PrivateLink / VPC Endpoint** | Advanced control or cross-VPC private access | Use AWS WAF or PrivateLink for internal-only exposure |

---

### 🧩 1️⃣ Use an **Internal ALB** (Recommended ✅)

#### 💡 How it works

- Set ALB **scheme = internal**.
- ALB’s DNS name resolves to **private IPs** — no public access.
- Only accessible from within the VPC, peered VPCs, or VPN.

#### Terraform Example

```hcl
resource "aws_lb" "internal_alb" {
  name               = "internal-api-alb"
  internal           = true                # 👈 Private ALB
  load_balancer_type = "application"
  subnets            = aws_subnet.private[*].id
  security_groups    = [aws_security_group.internal_alb_sg.id]
}
```

#### AWS CLI

```bash
aws elbv2 create-load-balancer \
  --name internal-api-alb \
  --scheme internal \
  --type application \
  --subnets subnet-abc subnet-def \
  --security-groups sg-0123456789abcdef
```

✅ **Result:**
The ALB DNS (e.g., `internal-api-alb-123456.ap-south-1.elb.amazonaws.com`) resolves only to **private IPs** — no internet exposure.

---

### 🧩 2️⃣ Restrict via **Security Groups (SGs)**

#### 💡 How it works

Attach restrictive **security groups** to both ALB and your target instances/tasks.

#### Example SG setup:

- **ALB Security Group (sg-alb)**

  - **Inbound:** Allow TCP 80/443 **only from trusted SGs** (like EC2/ECS SG).
  - **Outbound:** Allow all (default).

- **Target SG (sg-app)**

  - **Inbound:** Allow TCP 8080 **from sg-alb** only.

#### Terraform Example

```hcl
resource "aws_security_group" "alb_sg" {
  name   = "alb-internal-sg"
  vpc_id = var.vpc_id

  ingress {
    description      = "Allow from internal app servers only"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups  = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

✅ **Result:**
Only EC2/ECS tasks in `app_sg` can reach the ALB — blocked for all others (including public internet).

---

### 🧩 3️⃣ Restrict via **AWS WAF / VPC Endpoints / PrivateLink**

#### 🧱 Option A: **Attach AWS WAF (L7 filtering)**

Block non-VPC traffic using source IP conditions.

```bash
aws wafv2 create-ip-set \
  --name internal-ips \
  --scope REGIONAL \
  --ip-address-version IPV4 \
  --addresses 10.0.0.0/8 192.168.0.0/16
```

Attach IPSet-based rule to ALB → only allow internal CIDR ranges.

---

#### 🧱 Option B: **Expose ALB via PrivateLink (NLB + VPC Endpoint)**

Use **PrivateLink** for cross-VPC or hybrid private access.

High-level architecture:

```
Client VPC --> VPC Endpoint --> NLB (fronts ALB) --> ALB --> ECS/EKS targets
```

Terraform outline:

```hcl
resource "aws_vpc_endpoint_service" "private_alb" {
  acceptance_required = false
  network_load_balancer_arns = [aws_lb.nlb.arn]
}
```

✅ Use this for:

- Cross-account or cross-VPC private access
- Internal APIs shared with limited consumers

---

### 📋 Quick Comparison Table

| **Approach**       | **Scope**                 | **Best For**                           | **Internet Exposure** |
| ------------------ | ------------------------- | -------------------------------------- | --------------------- |
| Internal ALB       | VPC only                  | Intra-VPC APIs, internal microservices | ❌ None               |
| Security Groups    | Fine-grained within VPC   | ECS ↔ ALB, EC2 ↔ ALB                   | ❌ None               |
| WAF IP Restriction | Regional / CIDR-based     | Hybrid internal + limited external     | ⚠️ Controlled         |
| PrivateLink        | Cross-VPC / Cross-Account | Shared internal APIs                   | ❌ None               |

---

### ✅ Best Practices

- **Use internal ALB** whenever API is purely internal.
- **Never** associate internal ALBs with public subnets or public route tables.
- Combine **private subnets + SG rules** for strongest isolation.
- Enable **access logs + CloudWatch metrics** to audit all incoming requests.
- For hybrid environments, prefer **PrivateLink** over opening VPN CIDRs broadly.
- Use **AWS WAF IPSet rules** only for coarse-grained IP filtering (not security-critical enforcement).

---

### 💡 In short

To restrict API access to internal traffic:

1. Deploy ALB as **`internal`** (private subnets only).
2. Use **SG rules** to allow only trusted sources (EC2/ECS SGs).
3. For cross-VPC, use **PrivateLink** or **VPC endpoints**.
   ✅ This ensures your ALB/API is fully **isolated from the public internet** and accessible **only inside your VPC network**.

---

## 🏗️ Load Balancer Architecture Overview

| **Component**                          | **Purpose / Description**                                                                                                                                                                                                          |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Listener**                           | Accepts incoming connections on a specific **protocol and port** (e.g., HTTP:80, HTTPS:443). Routes requests to appropriate **target groups** based on listener **rules** (path, host, headers, etc.).                             |
| **Target Group**                       | A **logical group of backend resources** (EC2 instances, ECS tasks, IP addresses, or Lambda functions) that receive traffic from the load balancer. Each target group has its own **health checks** and **routing configuration**. |
| **Health Checks**                      | Periodically **probe each target’s endpoint** to verify availability. Unhealthy targets are automatically **removed** from rotation until they recover. Configurable path, port, interval, and thresholds.                         |
| **Cross-Zone Load Balancing**          | Distributes incoming traffic **evenly across all registered targets** in **all Availability Zones (AZs)**, improving resilience and utilization. _(Enabled by default for ALB; optional for NLB/CLB.)_                             |
| **Access Logs**                        | Detailed **request-level logs** automatically stored in **Amazon S3**, containing client IP, request path, latency, response codes, and target info — used for debugging and analytics.                                            |
| **Stickiness (Session Persistence)**   | Ensures requests from the same client session are consistently routed to the **same backend target**, maintaining session state (via cookies).                                                                                     |
| **AWS WAF (Web Application Firewall)** | Protects web apps from **OWASP Top 10** attacks (SQL injection, XSS, etc.). Integrated at the ALB level to **filter, rate-limit, or block** malicious requests before reaching backends.                                           |
| **Security Group**                     | **Firewall rules** controlling inbound and outbound traffic for the load balancer. Defines **who can access (source IPs, ports)** and **where it can send traffic** (targets, subnets).                                            |

---

### 💡 In short

An **AWS Load Balancer** consists of key components like **listeners** (entry point), **target groups** (backends), **health checks** (resilience), and **cross-zone balancing** (distribution).
Security and observability are ensured via **SGs, WAF, access logs**, and **stickiness** for session consistency — forming a robust, scalable entry layer for applications.

---

## Q: Best Practices for Load Balancers (ALB / NLB)

---

### 🧠 Overview

Concise, production-ready best practices for ALB/NLB covering **security, resilience, performance, logging, cost, monitoring, automation, and routing**. Use these as a checklist when designing or auditing load-balancer architecture.

---

### ⚙️ Purpose / How it Works

- Secure ingress (TLS + WAF), robust routing (listeners → rules → target groups), and observability (access logs + metrics) together provide a protected, highly available entry layer.
- Automation (Terraform/CDK) ensures reproducible config and safe rollouts.

---

### 🧩 Examples / Commands / Config snippets

#### 1) HTTPS listener with ACM cert (Terraform)

```hcl
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.site.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
```

#### 2) HTTP→HTTPS redirect (Terraform)

```hcl
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
```

#### 3) Enable ALB access logs to S3 (Terraform)

```hcl
resource "aws_s3_bucket" "alb_logs" { bucket = "org-alb-logs-prod" }
resource "aws_lb" "app" {
  # ...
  access_logs {
    bucket  = aws_s3_bucket.alb_logs.id
    enabled = true
    prefix  = "alb/app"
  }
}
```

#### 4) Attach WAF to ALB (CLI)

```bash
aws wafv2 associate-web-acl \
  --web-acl-arn <waf-arn> \
  --resource-arn <alb-arn>
```

#### 5) Enable cross-zone (CLI)

```bash
aws elbv2 modify-load-balancer-attributes \
  --load-balancer-arn <alb-arn> \
  --attributes Key=load_balancing.cross_zone.enabled,Value=true
```

#### 6) Terraform: Listener rule for host/path routing

```hcl
resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10
  action { type = "forward"; target_group_arn = aws_lb_target_group.api.arn }
  condition { path_pattern { values = ["/api/*"] } }
}
```

---

### 📋 Best Practices Table

| **Area**              | **Recommendation**                                                                                       | Quick Rationale                            |
| --------------------- | -------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| **Security**          | Use **HTTPS (ACM)**, HTTP→HTTPS redirect, attach **WAF**, restrict SGs to ALB SGs only.                  | Centralized TLS + L7 protection.           |
| **Resilience**        | Deploy ALB across **multiple AZs**, enable **cross-zone LB**, register equal targets per AZ.             | Even distribution & high availability.     |
| **Performance**       | Monitor `TargetResponseTime`, use **NLB** for L4 low-latency needs, tune idle/connection timeouts.       | Minimize latency and avoid timeouts.       |
| **Logging**           | Enable **ALB access logs** → S3 + Athena; keep lifecycle rules.                                          | Request-level for RCA & analytics.         |
| **Cost Optimization** | One ALB per environment; use **listener rules** to host multiple apps.                                   | Reduce LB-count and LCUs.                  |
| **Monitoring**        | CloudWatch dashboards + alarms (5xx, latency, UnHealthyHostCount), instrument with **X-Ray** or tracing. | Rapid detection & traceability.            |
| **Automation**        | Manage LB config with **Terraform/CDK**; CI/CD changes with review and staged rollout.                   | Reproducible infra + safe changes.         |
| **Routing**           | Use **host/path/header** rules; one Target Group per service/version.                                    | Clear routing, independent health/scaling. |

---

### ✅ Quick Operational Checklist

- [ ] TLS via ACM + periodic cert validation.
- [ ] ALB spans all AZs; cross-zone enabled (if NLB enable manually).
- [ ] Health checks: lightweight `/health`, appropriate intervals/timeouts.
- [ ] Access logs enabled + lifecycle (archive/delete).
- [ ] WAF rules: rate-limit, managed rule groups, IP sets.
- [ ] Security groups: ALB SG inbound from client; app SG inbound from ALB SG only.
- [ ] CloudWatch alarms for `HTTPCode_Target_5XX_Count`, `TargetResponseTime`, `UnHealthyHostCount`.
- [ ] Use Terraform/CDK with PR-based changes and automated plan/apply in non-prod first.
- [ ] Use weighted forwarding for canary releases (10% → 50% → 100%).

---

### ⚠️ Gotchas (short)

- Don’t hardcode ALB IPs — use DNS/Route53 alias or Global Accelerator for static IPs.
- Long-running requests: increase idle_timeout carefully; prefer async processing.
- Heavy WAF rules may add latency — test rule impact.
- Cross-AZ NLB data transfer costs may apply.

---

### 💡 In short

Use **HTTPS + ACM + WAF**, deploy ALB across AZs with **cross-zone balancing**, enable access logs, and automate everything with Terraform. Route via host/path rules and monitor `TargetResponseTime` + 5xx errors — these steps give secure, resilient, observable, and cost-efficient LB architectures.

---
