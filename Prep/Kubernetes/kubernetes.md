# Kubernetes

# 🧠 Kubernetes Architecture — Detailed Explanation

Kubernetes uses a **control-plane + worker-node** model.
The **control plane** makes global decisions (scheduling, cluster state, API access).
The **worker nodes** run workloads (Pods) and the components needed to keep them running.

---

## ⭐ CONTROL PLANE COMPONENTS

### **1. kube-apiserver**

* The **central communication hub** for the entire cluster.
* All kubectl, controllers, operators interact **only** with the API Server.
* Stores cluster state in etcd.

### **2. etcd**

* Distributed key-value store.
* Source of truth for cluster state (Pods, Deployments, Secrets, ConfigMaps, CRDs, etc.).
* High availability and quorum-based consistency.

### **3. kube-scheduler**

* Decides **which node** each Pod runs on.
* Considers CPU/memory requests, taints/tolerations, affinity/anti-affinity, topology, and node availability.

### **4. kube-controller-manager**

Runs multiple controllers:

* **Node controller** – handles node health.
* **Deployment controller** – manages rollout/rollbacks.
* **ReplicaSet controller** – ensures desired replica count.
* **ServiceAccount controller**, **Namespace controller**, etc.

### **5. cloud-controller-manager** *(AWS/GCP/Azure/OpenStack)*

Manages cloud-specific control loops:

* Node lifecycle
* Load Balancer provisioning
* Route management
* Volumes (EBS/EFS/GCE-PD) lifecycle

---

## ⭐ WORKER NODE COMPONENTS

### **1. kubelet**

* Primary agent on each node.
* Talks to API server, runs containers, reports node & pod status.
* Enforces PodSpecs on the node.

### **2. kube-proxy**

* Manages service VIPs → Pod endpoint traffic.
* Implements iptables or IPVS-based load balancing on each node.

### **3. Container Runtime**

Docker / containerd / CRI-O

* Pulls images
* Manages container lifecycle
* Provides Pod sandbox networking

### **4. CNI Plugin (AWS VPC CNI, Calico, Cilium, Weave)**

* Configures Pod networking.
* Assigns IPs, configures routes.
* Implements NetworkPolicies.

---

## ⭐ ADD-ONS

### **DNS (CoreDNS)**

* Resolves service DNS names (`svc.namespace.svc.cluster.local`).

### **Metrics Server**

* Provides resource metrics for HPA/VPA.

### **Ingress Controller**

* ALB/NGINX/Istio Envoy → HTTP/S routing.

### **Service Mesh (Istio/App Mesh/Linkerd)**

* mTLS, traffic shaping, observability.

---

---

# 🏗️ KUBERNETES ARCHITECTURE — ASCII DIAGRAM (DETAILED)

```
                           ┌──────────────────────────────────────────────┐
                           │             CONTROL PLANE (Master)           │
                           │                                              │
                           │   ┌──────────────────────────────────────┐    │
                           │   │            kube-apiserver            │    │
                           │   │  - Entry point for all requests      │    │
                           │   └──────────────────────────────────────┘    │
                           │                     ▲                         │
                           │                     │                         │
                           │   ┌──────────────────────────────────────┐    │
                           │   │                 etcd                  │    │
                           │   │  - Cluster state key-value store     │    │
                           │   └──────────────────────────────────────┘    │
                           │                     ▲                         │
                           │                     │                         │
                           │   ┌──────────────────────────────────────┐    │
                           │   │            kube-scheduler            │    │
                           │   │ - Chooses nodes for pods             │    │
                           │   └──────────────────────────────────────┘    │
                           │                     ▲                         │
                           │                     │                         │
                           │   ┌──────────────────────────────────────┐    │
                           │   │       kube-controller-manager        │    │
                           │   │ - Node, Deployment, RS controllers   │    │
                           │   └──────────────────────────────────────┘    │
                           │                                              │
                           │   ┌──────────────────────────────────────┐    │
                           │   │        cloud-controller-manager      │    │
                           │   │ - Cloud LB, Routes, Volumes          │    │
                           │   └──────────────────────────────────────┘    │
                           └──────────────────────────────────────────────┘
                                               │
                                               │
                                               ▼
     ┌────────────────────────────────────────────────────────────────────────────┐
     │                              WORKER NODES                                  │
     │────────────────────────────────────────────────────────────────────────────┤

     │ Node #1                                                     Node #2        │
     │                                                                              │
     │  ┌───────────────────────┐                          ┌───────────────────────┐
     │  │       kubelet         │                          │       kubelet         │
     │  ├───────────────────────┤                          ├───────────────────────┤
     │  │  Talks to API server  │                          │  Enforces pod spec    │
     │  └───────────────────────┘                          └───────────────────────┘
     │                                                                              │
     │  ┌───────────────────────┐                          ┌───────────────────────┐
     │  │      kube-proxy       │                          │      kube-proxy       │
     │  │  iptables/IPVS rules  │                          │  Service load-balancer│
     │  └───────────────────────┘                          └───────────────────────┘
     │                                                                              │
     │  ┌───────────────────────┐                          ┌───────────────────────┐
     │  │   Container Runtime   │                          │   Container Runtime   │
     │  │ (containerd/Docker)   │                          │ (containerd/Docker)   │
     │  └───────────────────────┘                          └───────────────────────┘
     │                                                                              │
     │  ┌──────────────────────────────────────────────────────────────────┐        │
     │  │                             PODs                                 │        │
     │  │      ┌───────────────────────────┐   ┌────────────────────────┐  │        │
     │  │      │           POD A           │   │         POD B          │  │        │
     │  │      │  + Containers             │   │ + Containers            │  │        │
     │  │      │  + Sidecars (mesh, logs)  │   │ + Volumes               │  │        │
     │  │      └───────────────────────────┘   └────────────────────────┘  │        │
     │  └──────────────────────────────────────────────────────────────────┘        │
     │                                                                              │
     │───────────────────────────── NETWORK (CNI) ──────────────────────────────────│
     │ CNI Plugin (AWS VPC CNI / Calico / Cilium): Pod IPAM, routing, policies     │
     └──────────────────────────────────────────────────────────────────────────────┘
```

---

# 🧩 How Traffic Flows

### **kubectl → API Server → Controllers → Scheduler → Nodes → Pods**

Example workflow:

1. You run `kubectl apply -f deployment.yaml`
2. `kube-apiserver` stores desired state in `etcd`
3. The Deployment controller creates a ReplicaSet
4. Scheduler decides best node for each pod
5. kubelet on chosen nodes:

   * pulls container images
   * creates sandbox network
   * runs containers
   * updates status back to API server
6. kube-proxy & CNI program networking
7. Services route traffic to Pods

---

# 💡 In short

Kubernetes architecture is:

| Layer         | Components                               | Responsibility             |
| ------------- | ---------------------------------------- | -------------------------- |
| Control Plane | API Server, etcd, Scheduler, Controllers | Cluster decisions & state  |
| Worker Nodes  | Kubelet, Kube-proxy, Runtime             | Running pods & services    |
| Add-ons       | CNI, DNS, Metrics, Ingress               | Networking & observability |

---

## Q1: What is Amazon EKS and how does it differ from self-managed Kubernetes?

🧠 **Overview**
Amazon EKS is a **fully managed Kubernetes control plane** on AWS. It removes operational overhead such as control-plane setup, HA, patching, upgrades, and security hardening.
Self-managed Kubernetes requires **manual installation, scaling, HA design, upgrades**, and complete lifecycle ownership.

⚙️ **Purpose / How it works**

* AWS hosts the **API server, etcd, controllers, scheduler**, and automatically ensures multi-AZ HA.
* You manage **worker nodes**, networking, IAM, autoscaling, and workloads.
* Integrates deeply with AWS (IAM, VPC CNI, ALB/NLB, CloudWatch, KMS).

📋 **Comparison: EKS vs Self-managed Kubernetes**

| Feature            | Amazon EKS                        | Self-managed Kubernetes      |
| ------------------ | --------------------------------- | ---------------------------- |
| Control plane mgmt | AWS managed                       | You manage                   |
| Upgrades           | Automated options                 | Manual, risky                |
| HA & multi-AZ      | Built-in                          | You design/operate           |
| etcd backup        | AWS managed                       | You must manage              |
| Cost               | Control plane fee + node cost     | Infra + ops cost             |
| Security           | Automated control-plane hardening | You maintain CIS/K8s patches |

💡 **In short**
EKS = AWS-managed control plane.
Self-managed = you operate everything (more control, more effort).

---

## Q2: What are the main components of an EKS cluster?

🧠 **Overview**
An EKS cluster consists of **AWS-managed control plane** and **customer-managed worker nodes** running in your VPC.

⚙️ **Main Components**

| Component             | Description                                                      |
| --------------------- | ---------------------------------------------------------------- |
| **Control Plane**     | API Server, etcd, Scheduler, Controllers — fully managed by AWS. |
| **Worker Nodes**      | EC2 or Fargate compute that runs Pods.                           |
| **Node Groups**       | Logical grouping of worker nodes with shared config.             |
| **VPC CNI**           | Handles Pod networking, assigns ENIs/IPs.                        |
| **Cluster IAM Roles** | Permissions for nodes, cluster operations.                       |
| **Add-ons**           | Core components like kube-proxy, CNI, CoreDNS.                   |

🧩 **Diagram (Conceptual)**

```
[EKS Control Plane] <-- AWS-managed
       |
[VPC + Node Groups] <-- Your responsibility
       |
[Pods/Deployments/Services]
```

💡 **In short**
Control plane (AWS) + worker nodes (you) + networking + IAM = EKS cluster.

---

## Q3: What is the difference between EKS and ECS?

🧠 **Overview**
Both are AWS container orchestration services, but ECS is **AWS-native**, while EKS is **Kubernetes-native**.

📋 **Comparison Table**

| Feature       | EKS                        | ECS                           |
| ------------- | -------------------------- | ----------------------------- |
| Orchestrator  | Kubernetes                 | AWS proprietary               |
| Portability   | Multi-cloud                | AWS only                      |
| Complexity    | Higher (K8s concepts)      | Lower (simple tasks/services) |
| Control Plane | AWS-managed Kubernetes API | AWS-managed scheduler         |
| Networking    | VPC CNI, K8s model         | ENI-based task networking     |
| Deployment    | Helm, K8s manifests        | Task Definitions, Services    |

💡 **In short**
EKS = Kubernetes on AWS (flexible + complex).
ECS = AWS-native orchestrator (simple + tightly integrated).

---

## Q4: What is a node group in EKS?

🧠 **Overview**
A node group is a **collection of worker nodes** in an EKS cluster that share common configuration (AMI, instance type, scaling, labels, etc.).

⚙️ **Usage in Real World**

* Separate workloads (e.g., GPU nodes, spot nodes, dev/prod pools).
* Configure autoscaling, taints, labels for scheduling.

🧩 **Terraform Example**

```hcl
resource "aws_eks_node_group" "app_nodes" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "app-ng"
  instance_types  = ["t3.medium"]

  scaling_config {
    min_size = 2
    max_size = 6
    desired_size = 3
  }
}
```

💡 **In short**
A node group = a managed pool of worker nodes powering K8s workloads.

---

## Q5: What are the two types of node groups available in EKS?

🧠 **Overview**
EKS offers **Managed Node Groups** and **Self-Managed (Unmanaged) Node Groups**.

📋 **Comparison**

| Type                        | Description                                                    | Who manages lifecycle? |
| --------------------------- | -------------------------------------------------------------- | ---------------------- |
| **Managed Node Group**      | AWS manages node provisioning, upgrades, draining, replacement | AWS                    |
| **Self-managed Node Group** | You build nodes with Launch Templates/Autoscaling Groups       | You                    |

💡 **In short**
Managed = AWS handles node lifecycle.
Self-managed = full control but higher ops cost.

---

## Q6: What is the EKS control plane and what does AWS manage?

🧠 **Overview**
The control plane is the heart of Kubernetes — responsible for scheduling, cluster state, and API access. In EKS, AWS fully manages it.

⚙️ **AWS-Manages**

* API server
* etcd cluster replication & backups
* Multi-AZ availability
* Control plane patching & upgrades
* Control plane security hardening
* Automatic failover

⚙️ **You Manage**

* Worker nodes
* Networking
* Add-ons
* IAM roles & RBAC
* Application workloads

💡 **In short**
AWS manages everything control-plane related; you manage worker nodes + workloads.

---

## Q7: What is kubectl and how is it used with EKS?

🧠 **Overview**
`kubectl` is the Kubernetes CLI used to deploy, debug, and manage resources in EKS.

🧩 **Common Commands**

```bash
# Check cluster connectivity
kubectl get nodes

# Deploy app
kubectl apply -f deployment.yaml

# Debug pod
kubectl logs -f pod-name
kubectl exec -it pod-name -- bash
```

⚙️ **How It Works with EKS**

* AWS updates your `kubeconfig` via:

```bash
aws eks update-kubeconfig --name mycluster --region ap-south-1
```

* Then kubectl communicates with the EKS API server using IAM-authenticated requests.

💡 **In short**
kubectl = CLI for Kubernetes; AWS provides kubeconfig integration.

---

## Q8: How do you authenticate to an EKS cluster?

🧠 **Overview**
EKS authentication uses **AWS IAM + aws-iam-authenticator**, not native K8s username/password.

⚙️ **Authentication Flow**

1. User runs `kubectl` → triggers AWS CLI IAM authentication.
2. IAM is checked against **aws-auth ConfigMap** to map IAM users/roles → Kubernetes RBAC.
3. Control plane verifies signer → grants access.

🧩 **Add IAM Role Access**

```bash
kubectl edit configmap aws-auth -n kube-system
```

Example entry:

```yaml
mapRoles:
  - rolearn: arn:aws:iam::111122223333:role/EKSAdminRole
    username: admin
    groups:
      - system:masters
```

🧩 **Generate kubeconfig**

```bash
aws eks update-kubeconfig --name prod-eks --region ap-south-1
```

💡 **In short**
Authentication = IAM → aws-auth ConfigMap → RBAC.
You don’t manage certs/users manually.

---

## Q9: What is the aws-auth ConfigMap in EKS?

🧠 **Overview**
`aws-auth` is a special ConfigMap in the **kube-system** namespace that maps **AWS IAM users/roles** to **Kubernetes RBAC identities**. Without it, IAM principals cannot access the cluster.

⚙️ **Purpose / How it works**

* Controls **who can connect** to the EKS cluster.
* Maps IAM → Kubernetes username/group (RBAC).
* Required to grant access to admins, CI/CD roles, node IAM roles.

🧩 **Example**

```yaml
mapRoles:
  - rolearn: arn:aws:iam::111122223333:role/NodeRole
    username: system:node:{{EC2PrivateDNSName}}
    groups:
      - system:bootstrappers
      - system:nodes
```

💡 **In short**
`aws-auth` bridges IAM identities with Kubernetes RBAC permissions.

---

## Q10: What are the minimum IAM permissions required to create an EKS cluster?

🧠 **Overview**
To create an EKS cluster, the user/role must be allowed to manage **EKS**, **EC2**, **IAM**, **VPC**, and **CloudFormation** resources.

⚙️ **Minimum permission sets**

* `eks:*` (or `eks:CreateCluster`, `eks:DescribeCluster`, `eks:CreateNodegroup`)
* `ec2:*` for VPC/subnets/security groups/ENIs
* `iam:CreateRole`, `iam:PassRole` (for cluster and node IAM roles)
* `cloudformation:*` (EKS uses CFN internally for node groups)

🧩 **IAM policy snippet**

```json
{
  "Effect": "Allow",
  "Action": [
    "eks:*",
    "ec2:*",
    "iam:PassRole",
    "iam:CreateRole",
    "cloudformation:*"
  ],
  "Resource": "*"
}
```

💡 **In short**
You need permissions across EKS + EC2 networking + IAM role creation/pass-role + CloudFormation.

---

## Q11: What is a Kubernetes namespace and how is it used?

🧠 **Overview**
A namespace logically segments cluster resources. Useful for **multi-team**, **multi-environment**, or **resource isolation** scenarios.

⚙️ **Purpose**

* Avoid name collisions.
* Apply resource quotas per namespace.
* Group RBAC permissions.
* Separate dev/stage/prod workloads.

🧩 **Create a namespace**

```bash
kubectl create namespace dev
```

🧩 **Using it in YAML**

```yaml
metadata:
  name: api
  namespace: dev
```

💡 **In short**
Namespaces = logical partitions of the cluster for isolation, RBAC, and quota control.

---

## Q12: What is the difference between a Pod and a Deployment in Kubernetes?

🧠 **Overview**
A **Pod** is the smallest runnable unit; a **Deployment** manages Pods at scale.

📋 **Comparison Table**

| Item            | Pod                     | Deployment                     |
| --------------- | ----------------------- | ------------------------------ |
| Purpose         | Run one/more containers | Declarative management of Pods |
| Scaling         | Manual                  | Automatic replicas             |
| Self-healing    | No                      | Yes (recreates Pods)           |
| Rolling updates | No                      | Yes                            |

💡 **In short**
Pod = single unit.
Deployment = controller that manages pods with scaling & updates.

---

## Q13: What is a Kubernetes Service and why is it needed?

🧠 **Overview**
A Service exposes a stable **virtual IP + DNS name** to access Pods, solving the problem of Pod IP churn.

⚙️ **Purpose**

* Stable networking endpoint.
* Load balance traffic across Pod replicas.
* Enable internal or external connectivity.

🧩 **Example**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: api-svc
spec:
  selector:
    app: api
  ports:
    - port: 80
      targetPort: 8080
```

💡 **In short**
Services provide stable access and load balancing to ephemeral Pods.

---

## Q14: What are the different Service types in Kubernetes (ClusterIP, NodePort, LoadBalancer)?

🧠 **Overview**
Service type determines **how** traffic reaches your application.

📋 **Service Types**

| Type             | Description                        | Use Case                          |
| ---------------- | ---------------------------------- | --------------------------------- |
| **ClusterIP**    | Default; internal-only virtual IP  | Microservice-to-microservice      |
| **NodePort**     | Exposes service on `<NodeIP>:port` | Simple external access, debugging |
| **LoadBalancer** | Provisions cloud LB (ELB/NLB)      | Production external traffic       |

🧩 **Service Example (LoadBalancer)**

```yaml
spec:
  type: LoadBalancer
  ports:
    - port: 80
      targetPort: 8080
```

💡 **In short**
ClusterIP = internal, NodePort = basic external, LoadBalancer = cloud-managed external LB.

---

## Q15: What is a ReplicaSet in Kubernetes?

🧠 **Overview**
ReplicaSet ensures a specified number of **identical Pods** are running at all times.

⚙️ **How it works**

* Monitors Pods with matching labels.
* Creates new Pods if replicas fall below desired count.
* Used indirectly via Deployments (rarely used directly).

🧩 **Example**

```yaml
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api
```

💡 **In short**
ReplicaSet maintains desired Pod count; Deployment wraps it with updates & rollout logic.

---

## Q16: What is the purpose of a Kubernetes ConfigMap?

🧠 **Overview**
ConfigMap stores **non-sensitive configuration** (env vars, config files, flags) separately from images.

⚙️ **Use Cases**

* Externalize config.
* Inject env vars or files into Pods.
* Avoid rebuilding images for config changes.

🧩 **Example**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: api-config
data:
  LOG_LEVEL: debug
```

💡 **In short**
ConfigMap = plain configuration injection for containers.

---

## Q17: What is a Kubernetes Secret and how does it differ from ConfigMap?

🧠 **Overview**
Secret stores **sensitive data** (passwords, tokens, keys) in base64-encoded form and can be encrypted at rest.

📋 **Secret vs ConfigMap**

| Feature    | ConfigMap            | Secret                                 |
| ---------- | -------------------- | -------------------------------------- |
| Purpose    | Non-sensitive config | Sensitive data                         |
| Encoding   | Plain text           | Base64                                 |
| Encryption | Optional             | Recommended (KMS, envelope encryption) |
| Access     | Normal RBAC          | Stricter RBAC                          |

🧩 **Example**

```yaml
apiVersion: v1
kind: Secret
type: Opaque
data:
  DB_PASS: cGFzc3dvcmQ=
```

💡 **In short**
ConfigMap = regular config.
Secret = sensitive credentials.

---

## Q18: What is a DaemonSet in Kubernetes?

🧠 **Overview**
DaemonSet ensures **one Pod runs on every node** (or specific nodes). Perfect for node-level services.

⚙️ **Common Use Cases**

* Log collectors (Fluentd, Filebeat).
* Monitoring agents (Prometheus Node Exporter).
* CNI plugins.
* Security agents.

🧩 **Spec Snippet**

```yaml
apiVersion: apps/v1
kind: DaemonSet
spec:
  selector:
    matchLabels:
      app: node-agent
```

💡 **In short**
DaemonSet = run Pod on all nodes (or targeted nodes).

---

## Q19: What is a StatefulSet and when would you use it?

🧠 **Overview**
StatefulSet manages **stateful applications** requiring stable identities, persistent volumes, and ordered scaling/updates.

⚙️ **Key Features**

* Persistent identities (`pod-0`, `pod-1`, …)
* Stable network hostnames
* Ordered deployment & termination
* Works with PersistentVolumeClaims

🧩 **Use Cases**

* Databases: MongoDB, Cassandra, MySQL
* Kafka, Zookeeper
* Any app needing disk state + stable hostname

🧩 **Example**

```yaml
spec:
  serviceName: "db"
  replicas: 3
  volumeClaimTemplates:
    - metadata:
        name: data
```

💡 **In short**
StatefulSet = stable identity + persistent volumes for stateful workloads.

---

## Q20: What is the AWS VPC CNI plugin in EKS?

🧠 **Overview**
The **AWS VPC CNI plugin** (amazon-vpc-cni-k8s) allows Kubernetes Pods in EKS to receive **real VPC IP addresses**, enabling native VPC networking and security policies.

⚙️ **How it works**

* Each Pod gets an IP from the subnet using ENIs attached to worker nodes.
* Enables Pods to be first-class citizens in the VPC (SGs, routing).
* Supports IP prefix delegation for higher pod density.

🧩 **Check CNI version**

```bash
kubectl describe daemonset aws-node -n kube-system
```

💡 **In short**
VPC CNI = native VPC IPs for Pods → seamless AWS networking integration.

---

## Q21: How does networking work in EKS pods?

🧠 **Overview**
Pods in EKS use the **VPC CNI** to get **VPC-native IPs** and communicate directly using AWS networking.

⚙️ **Networking Flow**

* Node ENIs supply IPs to Pods.
* Pod-to-Pod in same subnet → local VPC route.
* Pod-to-Pod cross subnet → routed via VPC.
* Pod-to-external traffic → NAT Gateway / Internet Gateway.

📋 **Key Components**

| Component       | Purpose                         |
| --------------- | ------------------------------- |
| VPC CNI         | Pod IP allocation               |
| Security Groups | Node-level traffic restrictions |
| Route Tables    | Cross-subnet Pod routing        |

🧩 **View Pod IP**

```bash
kubectl get pods -o wide
```

💡 **In short**
Every Pod gets a VPC IP → direct routing + AWS network security.

---

## Q22: What is the default storage class in EKS?

🧠 **Overview**
Most EKS clusters default to **gp2** or **gp3** EBS-backed StorageClasses depending on region and cluster version.

⚙️ **Example Default StorageClass**

```yaml
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp3
reclaimPolicy: Delete
```

🧩 **Check**

```bash
kubectl get storageclass
```

💡 **In short**
Default storage = GP2/GP3 EBS volumes for dynamic PV provisioning.

---

## Q23: What is a PersistentVolume (PV) in Kubernetes?

🧠 **Overview**
A PersistentVolume is a cluster-wide storage resource that provides a **piece of storage** backed by EBS/EFS/NFS/etc.

⚙️ **Purpose**

* Decouples storage lifecycle from Pods.
* Supports static or dynamic provisioning.

🧩 **Example**

```yaml
apiVersion: v1
kind: PersistentVolume
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
```

💡 **In short**
PV = storage resource abstraction inside Kubernetes.

---

## Q24: What is a PersistentVolumeClaim (PVC)?

🧠 **Overview**
PVC is a **request for storage** by a Pod. Kubernetes binds PVC → PV automatically.

⚙️ **Purpose**

* Abstract storage provisioning.
* Allow dynamic volume creation via StorageClass.

🧩 **Example**

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
spec:
  accessModes: [ "ReadWriteOnce" ]
  resources:
    requests:
      storage: 10Gi
```

💡 **In short**
PVC = request; PV = actual storage.

---

## Q25: What are labels and selectors in Kubernetes?

🧠 **Overview**
Labels are **key-value tags** attached to objects. Selectors are **queries** used to match those labels.

⚙️ **Use Cases**

* Service → Pod selection
* Deployment → ReplicaSet/POD matching
* Organizing resources
* Scheduling (node labels)

🧩 **Example**

```yaml
labels:
  app: api
selector:
  matchLabels:
    app: api
```

💡 **In short**
Labels tag objects; selectors find objects with matching labels.

---

## Q26: What is a Kubernetes annotation?

🧠 **Overview**
Annotations store **non-identifying metadata** used by tools, controllers, or add-ons.

⚙️ **Use Cases**

* Ingress controllers
* Service mesh config
* GitOps metadata
* Autoscaler hints

🧩 **Example**

```yaml
metadata:
  annotations:
    kubernetes.io/ingress.class: alb
```

💡 **In short**
Annotations = metadata for tools; labels = used for selection.

---

## Q27: What is the difference between managed and self-managed node groups?

🧠 **Overview**
Node groups determine how worker nodes are provisioned and managed.

📋 **Comparison**

| Feature       | Managed Node Group   | Self-Managed Node Group |
| ------------- | -------------------- | ----------------------- |
| Provisioning  | AWS handles          | You define ASG + LT     |
| Upgrades      | One-click, automated | Manual                  |
| Draining      | Automatic            | You manage              |
| Health checks | AWS-managed          | Manual                  |
| Customization | Limited              | Highly customizable     |

💡 **In short**
Managed = AWS lifecycle automation.
Self-managed = more control, more ops burden.

---

## Q28: What is Fargate for EKS?

🧠 **Overview**
Fargate is a **serverless compute engine** that runs Pods without provisioning EC2 nodes.

⚙️ **How it works**

* You define Fargate profiles with namespace/label selectors.
* Pods matching the profile run on Fargate.
* No nodes, no patching, no scaling ops.

🧩 **Fargate Profile Example**

```yaml
selectors:
  - namespace: backend
```

💡 **In short**
Fargate = serverless Pods → no EC2 nodes & simplified ops.

---

## Q29: What is the EKS add-ons feature?

🧠 **Overview**
EKS add-ons provide **managed versions** of critical cluster components such as VPC CNI, CoreDNS, kube-proxy.

⚙️ **Benefits**

* Automated lifecycle & version compatibility
* Security patching
* Easier upgrades
* AWS-supported versions

🧩 **CLI Example**

```bash
aws eks create-addon --cluster-name prod --addon-name vpc-cni
```

💡 **In short**
Add-ons = AWS-managed system components for stability + easier ops.

---

## Q30: What versions of Kubernetes does EKS support?

🧠 **Overview**
EKS supports **multiple recent minor versions** of Kubernetes, typically supporting versions for ~14 months.

⚙️ **Key Points**

* EKS usually supports the **3–4 latest Kubernetes versions**.
* Older versions get deprecated and then retired.
* Control plane and node versions must stay within compatible range.

🧩 **Check versions**

```bash
aws eks describe-cluster --name prod --query "cluster.version"
```

💡 **In short**
EKS supports only recent minor K8s versions, with regular deprecations following upstream release cycles.

---

# Intermediate

## Q31: How do you configure IAM roles for service accounts (IRSA) in EKS?

🧠 **Overview**
IRSA lets Pods assume fine-grained IAM roles instead of relying on the node’s IAM role, improving security and least-privilege design.

⚙️ **Steps to Configure IRSA**

1. **Enable OIDC provider**

```bash
aws eks describe-cluster --name prod --query "cluster.identity.oidc.issuer"
aws iam create-open-id-connect-provider ...
```

2. **Create IAM role with trust policy**

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": { "Federated": "arn:aws:iam::<ACC_ID>:oidc-provider/<OIDC>" },
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Condition": {
      "StringEquals": {
        "<OIDC>:sub": "system:serviceaccount:app-namespace:app-sa"
      }
    }
  }]
}
```

3. **Annotate ServiceAccount**

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-sa
  namespace: app-namespace
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::<ACC_ID>:role/app-role
```

💡 **In short**
IRSA = Bind IAM role → ServiceAccount → Pods assume IAM role via OIDC token.

---

## Q32: What is the advantage of using IRSA over traditional IAM roles for nodes?

🧠 **Overview**
Traditional node IAM roles give **all Pods on the node** permission to AWS APIs. IRSA eliminates this broad permission model.

📋 **Comparison**

| Feature        | Node IAM Role                     | IRSA                            |
| -------------- | --------------------------------- | ------------------------------- |
| Granularity    | Node-level                        | Pod-level                       |
| Security       | High risk of privilege escalation | Least privilege                 |
| Access Control | All Pods inherit permissions      | Only annotated service accounts |
| Multi-tenancy  | Weak                              | Strong                          |

💡 **In short**
IRSA = Pod-level IAM with least privilege and no credential sharing.

---

## Q33: How does the EKS OIDC provider work?

🧠 **Overview**
EKS creates an **OIDC identity provider** that issues tokens to Pods. AWS Security Token Service (STS) trusts this provider to allow Pods to assume IAM roles.

⚙️ **How It Works**

1. Pod uses ServiceAccount token projected as OIDC JWT.
2. Token presented to STS → STS validates token with OIDC provider.
3. If IAM trust policy matches (`sub` claim), an STS session is issued.
4. Pod gets temporary credentials for allowed AWS APIs.

🧩 **Check OIDC Provider**

```bash
aws iam list-open-id-connect-providers
```

💡 **In short**
OIDC provider verifies Pod identities → IAM roles issued securely to Pods.

---

## Q34: How do you integrate EKS with Application Load Balancer (ALB)?

🧠 **Overview**
Integration is done using the **AWS Load Balancer Controller** which interprets Ingress or Service annotations to create ALBs.

⚙️ **Steps**

1. Install AWS Load Balancer Controller (Helm).
2. Configure IRSA for the controller.
3. Create Ingress with ALB annotations.

🧩 **Example Ingress**

```yaml
metadata:
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
```

💡 **In short**
Install LB Controller → Apply Ingress → ALB automatically created & managed.

---

## Q35: What is the AWS Load Balancer Controller and why is it needed?

🧠 **Overview**
The AWS Load Balancer Controller manages **ALBs and NLBs** for Kubernetes workloads.

⚙️ **Why Needed**

* Kubernetes does not natively know AWS Load Balancers.
* Controller watches Ingress/Service and provisions ALB/NLB accordingly.
* Handles listeners, rules, target groups, health checks.

🧩 **Install via Helm**

```bash
helm repo add eks https://aws.github.io/eks-charts
helm install aws-lbc eks/aws-load-balancer-controller \
  --set clusterName=prod
```

💡 **In short**
Controller = bridge between K8s Ingress/Services and AWS ALB/NLB.

---

## Q36: How do you configure Ingress resources in EKS?

🧠 **Overview**
Ingress defines HTTP routing rules; ALB/Nginx/Traefik controllers implement them.

⚙️ **Steps**

1. Install Ingress Controller (AWS ALB Controller).
2. Apply Ingress YAML with routing rules + annotations.

🧩 **Example Ingress**

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: api-ing
  annotations:
    kubernetes.io/ingress.class: alb
spec:
  rules:
    - http:
        paths:
          - path: /api
            pathType: Prefix
            backend:
              service:
                name: api-svc
                port:
                  number: 80
```

💡 **In short**
Ingress = routing; controller = load balancer provisioning + rule management.

---

## Q37: What is the difference between Ingress and Service in Kubernetes?

🧠 **Overview**
Both expose applications, but on different layers.

📋 **Comparison**

| Feature       | Service                           | Ingress                      |
| ------------- | --------------------------------- | ---------------------------- |
| Purpose       | Expose Pods internally/externally | HTTP/HTTPS routing + LB mgmt |
| Network Level | L3/L4                             | L7                           |
| LB Creation   | NodePort/LoadBalancer             | Via Ingress Controller       |
| Routing       | No routing logic                  | Path/Host routing            |

💡 **In short**
Service = basic networking.
Ingress = advanced HTTP routing + ALB/NLB integration.

---

## Q38: How do you implement horizontal pod autoscaling (HPA) in EKS?

🧠 **Overview**
HPA automatically scales Pods based on metrics like CPU, memory, or custom metrics.

⚙️ **Steps**

1. Ensure metrics-server is deployed.
2. Define HPA YAML referencing Deployment.

🧩 **Example**

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

🧩 **Check HPA**

```bash
kubectl get hpa
```

💡 **In short**
HPA scales Pods using CPU/memory/custom metrics → requires metrics-server.

---

## Q39: What is the Cluster Autoscaler and how does it work in EKS?

🧠 **Overview**
Cluster Autoscaler automatically adjusts **node group size** based on pending or unused Pod capacity.

⚙️ **How It Works**

1. Watches for Pods stuck in Pending due to insufficient resources.
2. Requests AWS to scale up node group.
3. Detects underutilized nodes and scales down when safe.

🧩 **Install with Helm**

```bash
helm install cluster-autoscaler autoscaler/cluster-autoscaler \
  --set autoDiscovery.clusterName=prod
```

🧩 **Node Group Requirements**

* ASG must have tags:

```
k8s.io/cluster-autoscaler/enabled
k8s.io/cluster-autoscaler/<cluster-name>
```

💡 **In short**
Cluster Autoscaler scales nodes up/down based on Pod demand in EKS.

---

## Q40: How do you configure the EKS Cluster Autoscaler?

🧠 **Overview**
Cluster Autoscaler (CA) automatically scales EKS node groups based on pending Pod resource requirements.

⚙️ **Steps to Configure**

1. **Tag your node groups (Auto Scaling Groups):**

```
k8s.io/cluster-autoscaler/enabled = true  
k8s.io/cluster-autoscaler/<cluster-name> = owned
```

2. **Create IRSA for CA**

```bash
eksctl utils associate-iam-oidc-provider --cluster prod
```

3. **Deploy CA via Helm**

```bash
helm repo add autoscaler https://kubernetes.github.io/autoscaler
helm install cluster-autoscaler autoscaler/cluster-autoscaler \
  --namespace kube-system \
  --set autoDiscovery.clusterName=prod \
  --set awsRegion=ap-south-1
```

4. **Set recommended flags**

```yaml
--scale-down-enabled=true
--balance-similar-node-groups=true
--skip-nodes-with-local-storage=false
```

💡 **In short**
Tag ASG → configure IRSA → deploy CA → it auto-scales nodes based on pending pods.

---

## Q41: What is the difference between Cluster Autoscaler and Karpenter?

🧠 **Overview**

| Feature         | Cluster Autoscaler            | Karpenter                                    |
| --------------- | ----------------------------- | -------------------------------------------- |
| Scaling Trigger | Pending pods                  | Pending pods + advanced scheduling           |
| Provisioning    | Scales predefined node groups | Creates optimal instances dynamically        |
| Granularity     | ASG-level                     | Per-Pod-level decisions                      |
| Performance     | Slower                        | Very fast (seconds)                          |
| Flexibility     | Fixed instance types          | Flexible instance selection (Spot/On-demand) |

💡 **In short**
CA scales node groups; Karpenter creates optimal nodes dynamically.

---

## Q42: How does Karpenter improve upon Cluster Autoscaler?

🧠 **Overview**
Karpenter provides **faster, smarter, and more efficient** scaling decisions.

⚙️ **Improvements**

* Launches nodes **directly using EC2 APIs** (no ASG needed).
* Optimizes instance types, AZ selection, Spot/On-Demand mix.
* Drains & deletes nodes when unused.
* Scales up in **seconds**, not minutes.
* Handles bin-packing more efficiently.

🧩 **Provisioner Example**

```yaml
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
spec:
  requirements:
    - key: node.kubernetes.io/instance-type
      operator: In
      values: [ "t3.medium", "m5.large" ]
```

💡 **In short**
Karpenter = fast, cost-optimized, flexible autoscaling without ASGs.

---

## Q43: How do you implement vertical pod autoscaling (VPA) in EKS?

🧠 **Overview**
VPA automatically adjusts CPU/memory **requests** (not limits) for Pods based on usage.

⚙️ **Steps**

1. Install VPA:

```bash
kubectl apply -f https://github.com/kubernetes/autoscaler/releases/latest/download/vpa.yaml
```

2. Create VPA resource:

```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api
  updatePolicy:
    updateMode: Auto
```

💡 **In short**
VPA tunes CPU/memory requests based on real usage for right-sizing pods.

---

## Q44: What are node affinity and pod affinity rules?

🧠 **Overview**
Affinity rules influence **where** pods are scheduled based on labels or pod placement.

📋 **Types**

| Type              | Purpose                      |
| ----------------- | ---------------------------- |
| Node Affinity     | Place pods on matching nodes |
| Pod Affinity      | Place pods near other pods   |
| Pod Anti-Affinity | Keep pods apart              |

🧩 **Node Affinity Example**

```yaml
nodeAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    nodeSelectorTerms:
      - matchExpressions:
          - key: env
            operator: In
            values: ["prod"]
```

💡 **In short**
Affinity = intelligent placement rules based on nodes/pods.

---

## Q45: How do you use taints and tolerations in EKS?

🧠 **Overview**
Taints **repel** pods; tolerations **allow** pods to schedule on tainted nodes.

⚙️ **Use Cases**

* Dedicated nodes for workloads
* GPU workloads
* Prevent noisy neighbors

🧩 **Add taint**

```bash
kubectl taint nodes node1 dedicated=api:NoSchedule
```

🧩 **Pod toleration**

```yaml
tolerations:
  - key: "dedicated"
    operator: "Equal"
    value: "api"
    effect: "NoSchedule"
```

💡 **In short**
Taints repel; tolerations allow pods onto restricted nodes.

---

## Q46: What are node selectors and when would you use them?

🧠 **Overview**
Node selectors schedule Pods to nodes matching specific labels—simplest form of affinity.

🧩 **Example**

```yaml
nodeSelector:
  instance-type: m5.large
```

📌 **Use Cases**

* Deploy pod only on GPU nodes
* Separate dev/prod workloads
* Restrict workloads to specific AZ

💡 **In short**
nodeSelector = simple equality-based placement constraint.

---

## Q47: How do you configure resource requests and limits for pods?

🧠 **Overview**
Requests = minimum guaranteed resources.
Limits = maximum allowed usage.

🧩 **Example**

```yaml
resources:
  requests:
    cpu: "200m"
    memory: "256Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"
```

⚙️ **Purpose**

* Proper scheduling
* Prevents resource starvation
* Helps autoscaling

💡 **In short**
Set requests for scheduling; limits to cap resource usage.

---

## Q48: What happens when a pod exceeds its memory limit?

🧠 **Overview**
Memory limits are strict—when exceeded, the Pod is **OOMKilled**.

⚙️ **Behavior**

* Kernel OOM killer terminates container.
* Pod restarts per restartPolicy.
* Events show:

```
OOMKilled
```

💡 **In short**
Exceed memory → immediate OOMKill.

---

## Q49: What happens when a pod exceeds its CPU limit?

🧠 **Overview**
CPU limits throttle CPU usage but **do not kill the pod**.

⚙️ **Behavior**

* CPU usage capped.
* Performance slows.
* Pod continues running.

💡 **In short**
Exceed CPU → throttling, not termination.

---

## Q50: How do you implement pod disruption budgets (PDB)?

🧠 **Overview**
PDB ensures minimum Pods remain available during voluntary disruptions.

🧩 **Example**

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: api
```

⚙️ **Protects Against**

* Node upgrades
* Cluster maintenance
* Rolling restarts

💡 **In short**
PDB = availability guarantees during disruptions.

---

## Q51: What is the purpose of liveness and readiness probes?

🧠 **Overview**

| Probe         | Purpose                                        |
| ------------- | ---------------------------------------------- |
| **Liveness**  | Detect if container is stuck → restart it      |
| **Readiness** | Detect if container is ready to serve traffic  |
| **Startup**   | Delay other probes until app fully initializes |

🧩 **Example**

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
```

💡 **In short**
Liveness = restart if unhealthy; readiness = only send traffic when ready.

---

## Q52: What is the difference between liveness, readiness, and startup probes?

🧠 **Overview**

| Probe         | When Used                | What It Does                           |
| ------------- | ------------------------ | -------------------------------------- |
| **Liveness**  | During runtime           | Restart container if unhealthy         |
| **Readiness** | During startup + runtime | Remove pod from LB if not ready        |
| **Startup**   | App with long boot time  | Prevent false failures until app is up |

🧩 **Startup Probe Example**

```yaml
startupProbe:
  httpGet:
    path: /startup
    port: 8080
  failureThreshold: 30
  periodSeconds: 10
```

💡 **In short**
Startup protects slow apps → readiness controls traffic → liveness ensures self-healing.

---

## Q53: How do you configure logging for EKS clusters using CloudWatch Container Insights?

🧠 **Overview**
CloudWatch Container Insights collects logs, metrics, and performance telemetry from Pods and nodes.

⚙️ **Steps**

1. Deploy CloudWatch agent via Fluent Bit DaemonSet:

```bash
kubectl apply -f https://raw.githubusercontent.com/aws/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-quickstart/cwagent-fluent-bit-quickstart.yaml
```

2. Configure log group:

```yaml
  logs:
    metrics_collected:
      kubernetes:
        cluster_name: prod
```

3. Validate logs:

```bash
aws logs describe-log-groups --log-group-name-prefix /aws/containerinsights
```

📋 **You Get**

* Pod logs
* Node metrics
* Container CPU/memory
* Cluster maps & dashboards

💡 **In short**
Install Fluent Bit → ship logs/metrics to CloudWatch → view dashboards.

---

## Q54: What is Fluent Bit and how is it used in EKS?

🧠 **Overview**
Fluent Bit is a **lightweight log forwarder** widely used to collect, process, and ship Pod and node logs from EKS to CloudWatch, S3, Elasticsearch, Datadog, etc.

⚙️ **How It Works in EKS**

* Runs as a **DaemonSet** on every node.
* Reads container logs from `/var/log/containers`.
* Applies filters/parsers and sends logs to CloudWatch or another backend.

🧩 **Deploy Fluent Bit**

```bash
kubectl apply -f fluent-bit.yaml
```

💡 **In short**
Fluent Bit = fast, minimal log shipper for EKS clusters.

---

## Q55: How do you integrate EKS with Amazon CloudWatch for monitoring?

🧠 **Overview**
CloudWatch collects metrics, logs, cluster insights, and container-level telemetry from EKS.

⚙️ **Steps**

1. **Install CloudWatch agent + Fluent Bit**

```bash
kubectl apply -f cwagent-fluent-bit-quickstart.yaml
```

2. **Enable Container Insights**

```bash
aws ecs put-account-setting-default --setting-name containerInsights --value enabled
```

3. **Verify metrics**
   CloudWatch → Container Insights → EKS Cluster.

📋 **You Get**

* CPU/memory usage per Pod/Node
* Container logs
* Node health & disk metrics
* Cluster maps & performance views

💡 **In short**
Install CloudWatch agent + Fluent Bit → CloudWatch dashboards auto-populate.

---

## Q56: How do you use AWS Secrets Manager with EKS pods?

🧠 **Overview**
EKS Pods can fetch Secrets Manager secrets using **IRSA + SDK/API calls** or through the **Secrets Store CSI Driver**.

⚙️ **Method 1: App fetches secret via SDK**

* Assign IRSA role with permission:

```json
"Action": "secretsmanager:GetSecretValue"
```

* Code uses AWS SDK to read secrets.

⚙️ **Method 2: CSI Driver mounts secret as file**

1. Install Secrets Store CSI driver.
2. Create SecretProviderClass.
3. Mount secret into Pod.

🧩 **SecretProviderClass Example**

```yaml
provider: aws
parameters:
  objects: |
    - objectName: mysecret
```

💡 **In short**
Use IRSA + SDK or Secrets Store CSI driver to inject AWS Secrets Manager secrets into pods.

---

## Q57: What is the External Secrets Operator?

🧠 **Overview**
ESO syncs secrets from **AWS Secrets Manager**, Parameter Store, Vault, etc. into Kubernetes Secrets.

⚙️ **Why It’s Used**

* Native Kubernetes-style management.
* Automatically refreshes secrets.
* Supports multiple backends.

🧩 **Example ExternalSecret**

```yaml
apiVersion: external-secrets.io/v1alpha1
kind: ExternalSecret
spec:
  secretStoreRef:
    name: aws-backend
  data:
    - secretKey: db_pass
      remoteRef:
        key: prod/db/password
```

💡 **In short**
ESO keeps Kubernetes Secrets in sync with external secret stores automatically.

---

## Q58: How do you mount EFS volumes to EKS pods?

🧠 **Overview**
Use the **EFS CSI driver** to mount EFS onto Pods. Suitable for shared, scalable, multi-writer storage.

⚙️ **Steps**

1. Install EFS CSI driver.
2. Create EFS Access Point.
3. Define StorageClass.
4. Create PVC using StorageClass.
5. Mount PVC in Pod.

🧩 **StorageClass Example**

```yaml
provisioner: efs.csi.aws.com
```

🧩 **Pod Mount**

```yaml
volumeMounts:
  - mountPath: /data
    name: efs-vol
```

💡 **In short**
Install EFS CSI → create PVC → mount shared EFS storage into pods.

---

## Q59: How do you use EBS volumes with EKS?

🧠 **Overview**
EBS is block storage for **single-node** workloads. Pods get EBS volumes via PVCs and StorageClasses.

⚙️ **Steps**

1. Install **EBS CSI driver**.
2. Create StorageClass using ebs.csi.aws.com.
3. Create PVC.
4. Mount in Pod.

🧩 **StorageClass Example**

```yaml
provisioner: ebs.csi.aws.com
parameters:
  type: gp3
```

💡 **In short**
Use EBS CSI driver to provide persistent, single-node storage for workloads.

---

## Q60: What is the EBS CSI driver and why is it required?

🧠 **Overview**
EBS CSI driver enables Kubernetes to provision and manage EBS volumes dynamically.

⚙️ **Why Needed**

* In-tree EBS controller is deprecated.
* CSI driver supports snapshots, resizing, encryption, etc.
* Required for GA support on EKS.

🧩 **Install**

```bash
aws eks create-addon --addon-name aws-ebs-csi-driver --cluster-name prod
```

💡 **In short**
EBS CSI = modern CSI-based storage system for EKS with dynamic provisioning.

---

## Q61: How do you implement network policies in EKS?

🧠 **Overview**
NetworkPolicies restrict Pod-to-Pod and Pod-to-external communication at L3/L4.

⚙️ **Steps**

1. Use a CNI supporting network policies (Calico, Cilium).
2. Create NetworkPolicy YAML.

🧩 **Example**

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
spec:
  podSelector:
    matchLabels:
      app: api
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
```

💡 **In short**
Install policy-capable CNI → write NetworkPolicies → enforce zero-trust.

---

## Q62: What CNI plugins support network policies in EKS?

🧠 **Overview**

| Plugin      | Network Policy Support | Notes                            |
| ----------- | ---------------------- | -------------------------------- |
| **Calico**  | Yes                    | Most common; full eBPF support   |
| **Cilium**  | Yes                    | High performance, eBPF-based     |
| AWS VPC CNI | ❌                      | Does NOT enforce NetworkPolicies |

💡 **In short**
Use Calico or Cilium—not AWS VPC CNI—for network policy enforcement.

---

## Q63: How do you configure pod security policies in EKS?

🧠 **Overview**
PodSecurityPolicy (PSP) was deprecated; but some older clusters still support it.

⚙️ **Steps (Legacy)**

1. Enable PSP admission plugin.
2. Create PSP YAML.
3. Bind PSP via RBAC.

🧩 **Example**

```yaml
privileged: false
runAsUser:
  rule: MustRunAsNonRoot
```

⚠️ **Modern Replacement:** Use **Pod Security Standards (PSS)** instead.

💡 **In short**
PSP = deprecated security control for restricting Pod permissions.

---

## Q64: What is the Pod Security Standards (PSS) framework?

🧠 **Overview**
PSS is Kubernetes’s replacement for PSP, providing **three predefined security profiles**.

📋 **PSS Levels**

| Level          | Purpose                                                    |
| -------------- | ---------------------------------------------------------- |
| **Privileged** | No restrictions                                            |
| **Baseline**   | Prevent known privilege escalations                        |
| **Restricted** | Strongest hardening (non-root, seccomp, capabilities drop) |

⚙️ **Applied via Admission Controller: Pod Security Admission**

🧩 **Namespace Labels**

```bash
kubectl label ns prod pod-security.kubernetes.io/enforce=restricted
```

💡 **In short**
PSS = standardized security baselines enforceable per namespace.

---

## Q65: How do you implement blue-green deployments in EKS?

🧠 **Overview**
Blue = current version; Green = new version. Switch traffic only after validation.

⚙️ **Approaches**

1. **Service selector swap**
2. **Ingress/ALB rule change**
3. **Argo Rollouts/Spinnaker**

🧩 **Service Selector Swap**

```yaml
spec:
  selector:
    app: api-green
```

💡 **In short**
Run both versions → validate green → switch traffic instantly.

---

## Q66: How do you implement canary deployments in EKS?

🧠 **Overview**
Canary sends a **subset of traffic** to new version before full rollout.

⚙️ **Ways to Implement**

* ALB weighted forward actions
* Service mesh (Istio/Linkerd)
* Argo Rollouts

🧩 **Argo Rollouts Canary Example**

```yaml
strategy:
  canary:
    steps:
      - setWeight: 10
      - pause: {}
      - setWeight: 50
```

💡 **In short**
Canary = gradually shift traffic to new version + automated rollback.

---

## Q67: What is a rolling update strategy in Kubernetes?

🧠 **Overview**
Rolling updates allow Deployments to replace old Pods with new Pods **gradually**, ensuring zero downtime.

⚙️ **How It Works**

* Creates new Pods
* Waits for them to become Ready
* Terminates old Pods progressively

🧩 **Example**

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

💡 **In short**
Rolling update = seamless upgrade with controlled Pod replacement.

---

## Q68: How do you perform a rollback in Kubernetes?

🧠 **Overview**
Kubernetes stores Deployment revisions, allowing fast rollbacks.

⚙️ **Commands**

```bash
kubectl rollout undo deployment/api
kubectl rollout undo deployment/api --to-revision=3
kubectl rollout status deployment/api
```

💡 **In short**
Use `kubectl rollout undo` to restore previous working versions.

---

## Q69: What is the difference between a Job and a CronJob?

🧠 **Overview**

| Feature   | Job                        | CronJob                |
| --------- | -------------------------- | ---------------------- |
| Purpose   | Run task once              | Run task on schedule   |
| Execution | Immediate                  | Periodic               |
| Use Cases | Data processing, migration | Backups, nightly tasks |

🧩 **CronJob Example**

```yaml
schedule: "0 1 * * *"
jobTemplate:
  spec:
    template:
      spec:
        containers:
          - name: backup
```

💡 **In short**
Job = run once; CronJob = run repeatedly on schedule.

---

## Q70: How do you handle stateful applications in EKS?

🧠 **Overview**
Use **StatefulSets**, **PersistentVolumes**, and **Headless Services** to manage stable identity and storage.

⚙️ **Components**

* StatefulSet for stable naming (`pod-0`, `pod-1`).
* PV/PVC for persistent disk.
* Headless Service for stable DNS.

💡 **In short**
Stateful apps use StatefulSet + PV + Headless Service for ordered, stable storage.

---

## Q71: What is a Headless Service in Kubernetes?

🧠 **Overview**
A Headless Service (`clusterIP: None`) provides **DNS records per Pod** instead of a single ClusterIP.

🧩 **Example**

```yaml
spec:
  clusterIP: None
```

⚙️ **Use Cases**

* StatefulSets
* Databases (Cassandra, ZooKeeper)
* Direct pod discovery

💡 **In short**
Headless Service = pod-level DNS, not load balancing.

---

## Q72: How do you configure DNS resolution for services in EKS?

🧠 **Overview**
CoreDNS handles cluster DNS. Service DNS naming follows:

📋 **Format**

```
<service>.<namespace>.svc.cluster.local
```

⚙️ **Verify**

```bash
kubectl get configmap coredns -n kube-system
```

💡 **In short**
CoreDNS provides internal DNS resolution for Services and Pods.

---

## Q73: What is CoreDNS and what role does it play in EKS?

🧠 **Overview**
CoreDNS is the **cluster DNS server** for Kubernetes. It resolves Service/Pod names to IPs.

⚙️ **Responsibilities**

* Resolve service names → ClusterIP
* Resolve Pod names → Pod IP
* Apply DNS rewrite rules
* Integrate with VPC DNS (Amazon Route 53 resolver)

💡 **In short**
CoreDNS = DNS engine for every Kubernetes network lookup.

---

## Q74: How do you update an EKS cluster to a new Kubernetes version?

🧠 **Overview**
EKS upgrades follow **control plane → data plane** flow.

⚙️ **Steps**

1. Upgrade control plane:

```bash
aws eks update-cluster-version --region ap-south-1 --name prod --kubernetes-version 1.30
```

2. Update addons (CNI, CoreDNS, kube-proxy).
3. Upgrade node groups.
4. Verify workloads with canary rollout.

💡 **In short**
Upgrade control plane first → update addons → upgrade nodes.

---

## Q75: What is the recommended approach for upgrading EKS node groups?

🧠 **Overview**
Use **Managed Node Groups** with rolling upgrades.

⚙️ **Steps**

1. Create new version of node group.
2. AWS drains old nodes automatically.
3. New nodes join with updated AMI.
4. Delete old node group if using "blue/green" node groups.

🧩 **Blue/Green Node Group Pattern**

* Create **ng-v2** → cordon/drain old nodes → delete **ng-v1**.

💡 **In short**
Use managed node groups for safe, automated, HA node upgrades.

---

## Q76: How do you configure spot instances in EKS node groups?

🧠 **Overview**
Spot instances reduce compute cost by 70–90%, ideal for scalable and fault-tolerant workloads.

⚙️ **Steps**

1. Create a Managed Node Group:

```bash
capacityType: SPOT
instanceTypes:
  - m5.large
  - m5a.large
  - m4.large
```

2. Provide multiple instance types for availability.
3. Set proper Pod Disruption Budgets.

💡 **In short**
Use SPOT capacity type + multiple instance types for reliability.

---

## Q77: What considerations are important when using spot instances for production workloads?

🧠 **Overview**

📋 **Key Considerations**

| Risk               | Mitigation                         |
| ------------------ | ---------------------------------- |
| Spot interruption  | Use diverse instance types & AZs   |
| Sudden node loss   | Implement PDBs and HPA             |
| Eviction notice    | Handle SIGTERM + graceful shutdown |
| Stateful workloads | Avoid on Spot unless replicated    |

💡 **In short**
Use Spot only for flexible workloads; build resiliency into deployment.

---

## Q78: How do you implement multi-tenancy in EKS?

🧠 **Overview**
Multi-tenancy separates teams/apps through namespaces, RBAC, network segmentation, and resource quotas.

⚙️ **Methods**

* Namespace-per-team
* RBAC role bindings
* ResourceQuota + LimitRange
* NetworkPolicies
* IRSA for per-team credentials
* Pod Security Standards per namespace

💡 **In short**
Multi-tenancy = isolation via namespaces + RBAC + quotas + network policies.

---

## Q79: What is the AWS CNI custom networking feature?

🧠 **Overview**
Custom networking enables Pods to use **secondary VPC subnets** for IP allocation instead of node subnets.

⚙️ **Benefits**

* More IP capacity
* Place pods in different routing domains
* Separate Pod vs Node traffic

🧩 **Enable Feature**

```bash
WARM_IP_TARGET=5
AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG=true
```

💡 **In short**
Custom networking = assign Pod IPs from separate dedicated subnets.

---

## Q80: How do you troubleshoot ImagePullBackOff errors in EKS?

🧠 **Overview**
ImagePullBackOff means Kubernetes cannot pull the container image.

⚙️ **Checklist**

1. **Check registry permissions (ECR)**

```bash
aws ecr get-login-password ...
```

2. **Check image name/tag**

```bash
kubectl describe pod <pod>
```

3. **Verify node IAM role permissions** (ECR Pull).

4. **Check network path**

* NAT Gateway required for private subnets.

5. **Check Docker rate limiting (Docker Hub)**
   Use ECR instead.

🧩 **Example Error**

```
Failed to pull image "nginx:v100": manifest not found
```

💡 **In short**
Validate image exists, IAM/ECR permissions, network access, and correct tags.

---

# Advanced

## Q81: How would you design a multi-tenant EKS architecture with strong isolation guarantees?

🧠 **Overview**
Design for multi-tenancy by combining **soft isolation** (namespaces, RBAC, network policies, quotas) with **hard isolation** (separate clusters or node groups, VPC segmentation, IAM boundaries) depending on trust boundaries. Balance cost vs security: co-tenancy for dev/test, strong isolation (clusters/accounts) for high-risk tenants.

⚙️ **Purpose / How it works**

* **Soft isolation**: tenant = namespace. Fast onboarding, lower cost. Enforce via RBAC, ResourceQuotas, LimitRanges, Pod Security Standards, NetworkPolicies, and IRSA.
* **Hard isolation**: tenant = cluster/account/AWS Org OU. Use when tenants are untrustworthy or require compliance (PCI/HIPAA). Separate VPCs, separate KMS keys, separate AWS accounts.
* **Hybrid**: grouping tenants by risk into dedicated clusters for high-risk and shared cluster for low-risk.

🧩 **Examples / Commands / Config snippets**

* Namespace + RBAC + quota:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: tenant-a

---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: tenant-a-quota
  namespace: tenant-a
spec:
  hard:
    pods: "20"
    requests.cpu: "8"
    requests.memory: 16Gi
```

* IRSA (high-level):

```bash
eksctl create iamserviceaccount \
  --cluster prod \
  --namespace tenant-a \
  --name tenant-a-secret-sa \
  --attach-policy-arn arn:aws:iam::111122223333:policy/TenantSecretsReadOnly \
  --approve
```

* NetworkPolicy (deny-by-default, allow only frontend):

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata: { name: deny-all, namespace: tenant-a }
spec:
  podSelector: {}
  policyTypes: [Ingress, Egress]
```

📋 **Decision matrix (trade-offs)**

| Isolation Level        | Cost   | Security  | Operational Complexity | Use when                            |
| ---------------------- | ------ | --------- | ---------------------- | ----------------------------------- |
| Namespace (soft)       | Low    | Medium    | Low                    | Trusted tenants, dev/test           |
| Node groups per-tenant | Medium | High      | Medium                 | Performance or scheduling isolation |
| Cluster per-tenant     | High   | Very High | High                   | Untrusted tenants, compliance       |

✅ **Best Practices**

* Apply **deny-by-default** NetworkPolicies & PSS per namespace.
* Use **IRSA** for least-privilege AWS access.
* Enforce **ResourceQuotas** + LimitRanges to prevent noisy neighbors.
* Centralize monitoring/logging but ensure tenant log separation (labels/log groups).
* Use **automation (Terraform/eksctl/ArgoCD)** for reproducible tenant onboarding.
* For sensitive tenants, use **separate AWS accounts** and dedicate clusters.

💡 **In short**
Mix namespace-based controls for cost-efficiency and cluster/account isolation for strict security/compliance; automate onboarding and enforce least privilege everywhere.

---

## Q82: How do you implement cross-cluster service communication in EKS?

🧠 **Overview**
Cross-cluster service communication lets services in different Kubernetes clusters talk to each other. Options: **service mesh federation**, **API Gateway / VPC peering / NLBs**, **DNS-based service discovery (ExternalName)**, or **VPN/Transit Gateway** for networking across clusters/accounts/regions.

⚙️ **Purpose / How it works**

* Mesh-based (Istio/Linkerd/Consul) provides identity, mTLS, traffic routing, observability across clusters.
* Networking (VPC Peering / Transit Gateway / AWS PrivateLink) provides L3 connectivity; expose services via NLBs + private DNS.
* DNS & ExternalName for simple HTTP calls to public/private endpoints.

🧩 **Examples / Patterns**

* **Service exposed via private NLB + target group**: expose Service (type=LoadBalancer) → create VPC peering or TGW → resolve DNS in other cluster.

```yaml
spec:
  type: LoadBalancer
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: nlb
```

* **Istio multi-cluster (simplified)**:

  * Install Istio control planes in each cluster.
  * Configure mesh networking (east-west gateways) + mutual TLS.
  * Use `ServiceEntry`/`DestinationRule` to route cross-cluster traffic.

📋 **Comparison (choose by requirement)**

| Requirement                         | Recommended Pattern                           |
| ----------------------------------- | --------------------------------------------- |
| Low latency, private networking     | VPC Peering / Transit Gateway + NLB           |
| Global routing, observability, mTLS | Service mesh federation                       |
| Simple public API                   | API Gateway / Internet-facing ALB             |
| Multi-account across org            | PrivateLink or Transit Gateway + private NLBs |

✅ **Best Practices**

* Use **mTLS/mesh** for secure service-to-service identity.
* Prefer **private connectivity** (TGW/Peering) over public endpoints for internal traffic.
* Centralize DNS (Route53 private zones) for consistent resolution.
* Automate certificate/key distribution (cert-manager or mesh).
* Monitor cross-cluster latency and enforce circuit breakers.

💡 **In short**
Pick networking (TGW/NLB) for raw connectivity; use a service mesh for secure, observable, fine-grained cross-cluster communication.

---

## Q83: What strategies would you use for disaster recovery in EKS?

🧠 **Overview**
DR for EKS covers **control plane & cluster state**, **workloads/data**, and **network/infra**. Strategies include backups, cross-region clusters, infrastructure as code, and runbooks for RTO/RPO targets.

⚙️ **Purpose / How it works**

* **Cluster state**: backup cluster configs (CRDs, manifests, Helm charts, GitOps repo).
* **Workloads**: store container images in regional ECR with replication.
* **Data**: back up PV data (EBS snapshots, EFS backups, RDS snapshots).
* **Recovery**: rebuild cluster from IaC (Terraform/CloudFormation) and restore workloads/data.

🧩 **Concrete Steps**

1. **GitOps**: keep desired state in Git (ArgoCD/Flux).
2. **EBS snapshots**: schedule snapshots (AWS Backup / Lambda).
3. **EFS / RDS**: enable cross-region replication or scheduled backups.
4. **ECR replication**: configure cross-region replication of images.
5. **Cluster manifests & CRDs**: export and version-controlled (`kubectl get all --all-namespaces -o yaml` or `velero` backups).
6. **Velero** for cluster-level backups (supports S3, snapshots).

```bash
velero install --provider aws --bucket dr-backups --use-volume-snapshots
```

📋 **DR Patterns**

| Pattern                                    | RTO        | RPO             | Cost   |
| ------------------------------------------ | ---------- | --------------- | ------ |
| Single region backups + IaC restore        | Medium     | Hours           | Low    |
| Active-passive (cold standby in DR region) | Low-Medium | Minutes-Hours   | Medium |
| Active-active multi-region clusters        | Very Low   | Seconds-Minutes | High   |

✅ **Best Practices**

* Test restores regularly (drills).
* Keep **IaC + GitOps** to recreate clusters quickly.
* Automate snapshot lifecycle and replication.
* Secure backup artifacts (encryption, separate account).
* Document precise runbooks and a communication plan.

💡 **In short**
Combine GitOps + automated backups (Velero/EBS/EFS/RDS) + IaC to meet RTO/RPO—test restores frequently.

---

## Q84: How would you architect a multi-region EKS deployment?

🧠 **Overview**
Multi-region EKS: replicate cluster infrastructure, datasets, and routing across regions for resilience and locality. Design for data replication, global load balancing, and deployment automation.

⚙️ **Purpose / How it works**

* Deploy **clusters per region** (active-active or active-passive).
* Use **global routing** (Route53 latency-based or geolocation routing) with health checks.
* Replicate stateful data (RDS read replicas, Aurora global DB, S3 replication, ECR replication).
* Use pipeline automation to deploy to all regions (CI/CD + GitOps).

🧩 **Architecture Components**

* **Per-region EKS clusters** with same IaC/GitOps templates.
* **Data layer**: Aurora Global / cross-region RDS replicas / DynamoDB global tables.
* **Images**: ECR cross-region replication.
* **Networking**: CloudFront + Route53 or Route53 latency-based routing to regional ALBs/NLBs.
* **Secrets & KMS**: manage per-region KMS keys or replicate secrets using Secrets Manager replication.

📋 **Considerations**

| Concern          | Recommendation                                                   |
| ---------------- | ---------------------------------------------------------------- |
| Data consistency | Use global DB solutions (DynamoDB global tables / Aurora Global) |
| DNS routing      | Route53 latency / geoproximity + health checks                   |
| Image sync       | ECR cross-region replication                                     |
| Config drift     | Use centralized GitOps + region-specific overlays                |
| Regulatory       | Keep data locality constraints in mind                           |

✅ **Best Practices**

* Test failover and failback automation.
* Keep stateful services designed for replication or run them in a single region with cross-region disaster recovery.
* Use global observability (centralized metrics/logs or per-region with aggregation).
* Automate deployment pipelines to all regions with canaries per region.

💡 **In short**
Multi-region = regional clusters + replicated data + global DNS; automate everything and prefer data services built for global replication.

---

## Q85: How do you implement GitOps workflows with EKS using ArgoCD or Flux?

🧠 **Overview**
GitOps = single source of truth (Git) for cluster state. ArgoCD and Flux continuously reconcile cluster state to the Git repository, enabling auditable, declarative deployments.

⚙️ **Purpose / How it works**

* Store manifests/Helm charts/Kustomize overlays in Git.
* Git pushes trigger reconciliation (pull model) by ArgoCD/Flux.
* Reconciliation applies changes; drift is detected and optionally auto-synced.

🧩 **Quick setup (ArgoCD)**

1. Install ArgoCD in cluster:

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

2. Create Application CR pointing to Git repo:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
spec:
  source:
    repoURL: https://git.example.com/org/infra
    path: clusters/prod
  destination:
    server: https://kubernetes.default.svc
    namespace: default
```

🧩 **Flux (GitOps)**

* Install flux CLI and bootstrap:

```bash
flux bootstrap github --owner=org --repository=infra --path=clusters/prod
```

📋 **Feature comparison (short)**

| Feature       | ArgoCD           | Flux                  |
| ------------- | ---------------- | --------------------- |
| UI            | Rich built-in UI | Add-on (Weave GitOps) |
| Pull-based    | Yes              | Yes                   |
| Multi-cluster | Yes              | Yes                   |
| Helm support  | Yes              | Yes (Helm Controller) |

✅ **Best Practices**

* Use **branch-per-environment** or Kustomize overlays.
* Keep secrets out of Git (use SealedSecrets / ExternalSecrets / SOPS).
* Protect main branch with PRs + review + CI checks.
* Use automated health checks and progressive delivery (Argo Rollouts).
* Emit auditable change logs and alert on drift.

💡 **In short**
GitOps = Git as source of truth + ArgoCD/Flux to continuously reconcile cluster state—automate, secure secrets, and use progressive delivery.

---

## Q86: What is a service mesh and how would you implement it in EKS?

🧠 **Overview**
A service mesh is an infrastructure layer (sidecars + control plane) that manages service-to-service communication (mTLS, retries, circuit breaking, observability, traffic shaping) without changing application code.

⚙️ **Purpose / How it works**

* Sidecar proxies (Envoy) run alongside app containers to intercept traffic.
* Control plane configures proxies (routing, policies, telemetry).
* Provides secure identity (mTLS), observability (traces/metrics), and traffic control (canary, fault injection).

🧩 **Implementation steps (Istio example)**

1. Install Istio control plane (Helm or istioctl).
2. Annotate namespaces for automatic sidecar injection:

```bash
kubectl label namespace prod istio-injection=enabled
```

3. Apply `DestinationRule`, `VirtualService` for traffic shaping.

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
spec:
  hosts: [api.prod.svc.cluster.local]
  http:
  - route:
    - destination:
        host: api
        subset: v2
      weight: 10
    - destination:
        host: api
        subset: v1
      weight: 90
```

📋 **Service Mesh Options**

| Mesh     | Notes                               |
| -------- | ----------------------------------- |
| Istio    | Full-featured, steep learning curve |
| Linkerd  | Lightweight, simpler                |
| Consul   | Integrates service discovery + mesh |
| App Mesh | AWS-managed, integrates with Envoy  |

✅ **Best Practices**

* Start small (non-critical services), measure performance overhead.
* Use mTLS and strict identity for intra-cluster traffic.
* Centralize telemetry (Prometheus + Grafana + Jaeger/X-Ray).
* Implement progressive delivery via mesh features.
* Consider resource overhead (sidecar CPU/memory).

💡 **In short**
Service mesh = sidecars + control plane for secure, observable, and controllable service communication—choose mesh based on feature needs vs. operational complexity.

---

## Q87: How does AWS App Mesh integrate with EKS?

🧠 **Overview**
AWS App Mesh is a managed service mesh that integrates with EKS via **Envoy sidecars** and Kubernetes CRDs; it provides unified traffic routing, observability, and resilience across services running in EKS and other compute (ECS, EC2).

⚙️ **Purpose / How it works**

* Deploy **Envoy** as a sidecar into pods (via injection).
* App Mesh control plane (managed by AWS) holds virtual services, virtual nodes, and routing rules.
* Kubernetes controller (`appmesh-controller`) syncs K8s resources to App Mesh APIs.
* Supports observability (CloudWatch X-Ray), retries, circuit breaking, traffic shifting.

🧩 **Quick Integration Steps**

1. Install App Mesh controller for Kubernetes:

```bash
kubectl apply -k "github.com/aws/aws-app-mesh-controller-for-k8s//config/crds"
```

2. Annotate pods/namespaces and inject Envoy sidecar (via admission webhook).
3. Create `VirtualNode`, `VirtualService`, and `Route` CRs representing services and routes.

📋 **Integration benefits**

| Benefit               | Explanation                                     |
| --------------------- | ----------------------------------------------- |
| Managed control plane | AWS handles API surface & scale                 |
| Multi-environment     | Works across EKS, ECS, EC2                      |
| Observability         | Integrates with X-Ray/CloudWatch                |
| Consistent routing    | Centralized traffic control via VirtualServices |

✅ **Best Practices**

* Use App Mesh when you want AWS-managed mesh with strong integration into AWS telemetry.
* Ensure IAM + IRSA permissions are in place for the controller.
* Test sidecar resource overhead and set resource requests/limits.
* Use App Mesh for cross-platform meshes (EKS + ECS).

💡 **In short**
App Mesh = AWS-managed service mesh for EKS using Envoy sidecars + controller CRDs—good when you want cloud-native mesh with AWS telemetry and multi-platform support.

---

## Q88: How would you implement Istio on EKS for advanced traffic management?

🧠 **Overview**
Install Istio as a service mesh on EKS to get advanced L7 traffic control (virtual services, traffic splitting, retries, timeouts, mirroring, fault injection) and observability (tracing, metrics). Use canary/blue-green flows, A/B tests, and fine-grained routing without changing application code.

⚙️ **Purpose / How it works**

* Control plane (istiod) manages Envoy sidecars injected into app pods.
* VirtualService + DestinationRule express traffic routing and policies.
* Sidecar injection is namespace/label driven (automatic or manual).
* Use Gateway for ingress (IngressGateway/EGressGateway).

🧩 **Examples / Commands / Config snippets**

1. **Install Istio (recommended: istioctl + Helm-like mode)**

```bash
# download istioctl and install
istioctl install --set profile=default -y
kubectl label namespace prod istio-injection=enabled
```

2. **Enable automatic sidecar injection**

```bash
kubectl label namespace my-app istio-injection=enabled
```

3. **Canary: VirtualService that splits traffic 90/10**

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata: { name: api-vs }
spec:
  hosts: ["api.prod.svc.cluster.local"]
  http:
  - route:
    - destination: { host: api, subset: v1, weight: 90 }
    - destination: { host: api, subset: v2, weight: 10 }
```

4. **DestinationRule for subsets**

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata: { name: api-dr }
spec:
  host: api
  subsets:
    - name: v1
      labels: { version: v1 }
    - name: v2
      labels: { version: v2 }
```

5. **Enable telemetry (Prometheus/Grafana/Jaeger)**

```bash
kubectl apply -f samples/addons
```

📋 **Quick checklist**

* Prepare cluster: resource quotas + mutating webhook ports free.
* Use IRSA for Istio components needing AWS permissions.
* Use NodeSelector/Taints for gateway placement (dedicated nodes).
* Use mTLS and AuthorizationPolicies for secure routing.

✅ **Best Practices**

* Start in a non-prod namespace; validate sidecar resource overhead.
* Use **strict mTLS** only after testing; gradually enable.
* Limit Envoy RBAC and set resource requests/limits for sidecars.
* Use **timeout/retry** defaults to avoid cascading failures.
* Automate config via GitOps (ArgoCD/Flux) and test traffic policies in staging.

💡 **In short**
Install istioctl, enable sidecar injection, use VirtualService/DestinationRule for traffic splits and Argo/CI to manage configs — enable mTLS and telemetry for production-grade traffic management.

---

## Q89: What are the performance implications of using a service mesh?

🧠 **Overview**
Service mesh adds CPU/memory and network latency overhead because sidecars (Envoy) proxy all traffic. Impact depends on mesh implementation, traffic volume, POD density, and sidecar tuning.

⚙️ **Purpose / How it works**

* Every request traverses a proxy → additional hop + TLS (mTLS) cost.
* Sidecars consume CPU/memory; increased memory pressure may cause scheduling changes.
* Control plane churn (config updates) can add transient CPU/network spikes.

📋 **Performance impact summary**

| Area          | Impact                            | Typical Mitigation                                    |
| ------------- | --------------------------------- | ----------------------------------------------------- |
| Latency       | +1–10 ms per hop (depends on env) | Locality routing, mTLS offload tuning                 |
| CPU           | Sidecar CPU consumption           | Set requests/limits; use smaller proxies like Linkerd |
| Memory        | Sidecar memory per pod            | Increase node memory or use node pools                |
| Network       | More connections + TLS handshakes | Connection pooling, reuse, keepalives                 |
| Observability | Storage & ingest costs            | Sample traces, reduce retention                       |

🧩 **Practical tuning**

```yaml
# Example: set envoy resources via sidecar injector config
sidecar.istio.io/status: |
  resources:
    requests:
      cpu: "50m"
      memory: "64Mi"
    limits:
      cpu: "200m"
      memory: "256Mi"
```

✅ **Best Practices**

* Measure: baseline app latency/throughput before mesh.
* Right-size sidecars (requests/limits).
* Use eBPF-based meshes (Cilium) or lighter meshes (Linkerd) if overhead is critical.
* Offload heavy TLS at ingress (ALB/NLB) where appropriate.
* Sample traces and metrics—don’t ingest everything.

💡 **In short**
Expect added latency and resource cost from sidecars; mitigate with tuning, sampling, and choosing a mesh suited to your performance needs.

---

## Q90: How do you implement mutual TLS (mTLS) between services in EKS?

🧠 **Overview**
mTLS provides service identity and encrypts in-cluster traffic. Implement via service mesh (Istio/Linkerd/App Mesh) or sidecar proxies; meshes automate certificate issuance and rotation.

⚙️ **Purpose / How it works**

* Control plane issues short-lived certificates to sidecars using an internal CA.
* Sidecars perform TLS handshakes per connection and validate peer identity.
* Authorization policies enforce which services may communicate.

🧩 **Istio example (enable strict mTLS)**

1. **Enable PeerAuthentication (namespace-wide strict mTLS)**

```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: prod
spec:
  mtls:
    mode: STRICT
```

2. **AuthorizationPolicy to restrict access**

```yaml
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: allow-frontend
  namespace: prod
spec:
  selector:
    matchLabels: { app: backend }
  rules:
    - from:
        - source:
            principals: ["cluster.local/ns/prod/sa/frontend"]
```

3. **Verify**

```bash
istioctl authn tls-check deployment/backend -n prod
```

✅ **Best Practices**

* Roll out mTLS gradually (per-namespace) and monitor.
* Use mesh tooling to rotate certificates automatically.
* Enforce RBAC/AuthorizationPolicy in addition to mTLS for least privilege.
* Ensure sidecar injection and health checks are compatible before enabling STRICT mode.

💡 **In short**
Use a service mesh to automate cert issuance and enforce mTLS; enable STRICT gradually and couple with fine-grained authorization.

---

## Q91: How would you design a zero-trust security model for EKS workloads?

🧠 **Overview**
Zero-trust = “never trust, always verify.” Require authentication + authorization for every request, restrict network flows, and continuously validate posture.

⚙️ **Purpose / How it works**

* Authenticate identities (IRSA for AWS calls, mTLS/service identity for service-to-service).
* Authorize via RBAC + network policies + OPA/Gatekeeper.
* Encrypt in transit (mTLS) and at rest (KMS).
* Assume breach: logging, monitoring, runtime protection.

🧩 **Concrete building blocks**

* **Identity & Access**

  * IRSA for Pods (fine-grained AWS IAM).
  * Use short-lived certs (mesh) for service identity.
* **Network**

  * Deny-by-default NetworkPolicies per namespace.
  * Use private subnets, internal ALBs/NLBs, no public access except where required.
* **Policy & Admission**

  * Gatekeeper/Open Policy Agent for admission controls (image provenance, disallow root).
  * Pod Security Admission (PSS) enforcing `restricted` profile.
* **Secrets**

  * Secrets Manager + External Secrets / SOPS + KMS, no plaintext in Git.
* **Runtime & Monitoring**

  * ECR image scanning, Falco for runtime detection, CloudWatch/Prometheus for metrics, centralized SIEM.
* **Least Privilege**

  * ResourceQuota, LimitRange, RBAC least privilege, restrict node SSH.

📋 **Example OPA/Gatekeeper constraint (no privileged containers)**

```yaml
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sAllowedCapabilities
metadata: { name: disallow-priv }
spec:
  match:
    kinds: [{apiGroups:[""], kinds:["Pod"]}]
  parameters:
    allowedCapabilities: []
```

✅ **Best Practices**

* Implement layered controls: identity → network → policy → runtime.
* Automate detection & remediation (CI checks + admission + runtime).
* Maintain immutable infrastructure & GitOps for config drift prevention.
* Regularly audit with pentest and compliance scans.

💡 **In short**
Zero-trust on EKS = IRSA + mTLS + NetworkPolicies + OPA + strict PodSecurity + continuous monitoring and automation.

---

## Q92: What strategies would you use for secrets rotation in EKS?

🧠 **Overview**
Secrets rotation reduces blast radius: rotate secrets automatically, inject at runtime, and avoid storing raw secrets in Git.

⚙️ **Approaches**

1. **Use a secrets manager + CSI/ExternalSecrets** (Secrets Manager/SSM + Secrets Store CSI Driver or External Secrets Operator) so rotating in AWS propagates to pods.
2. **Application-driven rotation**: App uses AWS SDK to fetch current secrets at runtime and caches with TTL.
3. **Use SOPS/SealedSecrets** for Git-stored encrypted secrets; re-encrypt on rotation.
4. **Automate rotation workflows**: CloudWatch Events / EventBridge + Lambda + CI pipeline to update K8s Secrets or SecretProviderClass.

🧩 **Example: Secrets Store CSI (refreshInterval)**

```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
spec:
  provider: aws
  parameters:
    objects: |
      - objectName: my/secret
  secretObjects:
    - secretName: my-secret
      type: Opaque
  refreshInterval: "1m"
```

📋 **Rotation flow**

* Rotate secret in AWS Secrets Manager → Secrets Store CSI refresh pulls new value → Kubernetes Secret updated (if configured) → Pod watches file or app re-reads secret.

✅ **Best Practices**

* Use **IRSA** for the components accessing Secrets Manager.
* Prefer **mounting secrets** (CSI) over env vars to reduce leak risk.
* Set short TTLs and rotate regularly for high-risk credentials.
* Audit and alert on failed rotations.
* Keep rotation runbooks and automated rollback.

💡 **In short**
Use Secrets Manager + CSI/ExternalSecrets with refresh automation (or app fetch patterns) and avoid storing plaintext secrets in Git.

---

## Q93: How do you implement Open Policy Agent (OPA) for policy enforcement in EKS?

🧠 **Overview**
OPA (Gatekeeper) enforces declarative policies at admission time. Use it to validate manifests (deny privileged containers, enforce image registries, enforce labels, etc.).

⚙️ **Purpose / How it works**

* Gatekeeper installs as an admission webhook that evaluates incoming API requests against Rego policies (ConstraintTemplates + Constraints).
* Violations block the API call (deny) or audit mode logs the violation.

🧩 **Install & Example**

1. **Install Gatekeeper**

```bash
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
```

2. **ConstraintTemplate (example: require label)**

```yaml
apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata: { name: k8srequiredlabels }
spec:
  crd:
    spec:
      names:
        kind: K8sRequiredLabels
  target: admission.k8s.gatekeeper.sh
  rego: |
    package k8srequiredlabels
    violation[{"msg": msg}] { ... }
```

3. **Constraint**

```yaml
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sRequiredLabels
metadata: { name: ns-must-have-owner }
spec:
  match:
    kinds: [{apiGroups: [""], kinds: ["Namespace"]}]
  parameters:
    labels: ["owner", "team"]
```

📋 **Modes**

* **Enforce**: blocks violations.
* **Audit**: logs violations (good for gradual rollout).

✅ **Best Practices**

* Start in **audit** mode; iterate policies based on findings.
* Version policies in Git and manage via GitOps.
* Keep policy library small and focused initially (security, compliance).
* Test policies with CI (conftest or opa test).
* Monitor Gatekeeper performance; avoid very expensive Rego queries in hot paths.

💡 **In short**
Install Gatekeeper, write ConstraintTemplates + Constraints in Rego, roll out in audit mode, then enforce once validated.

---

## Q94: How would you design an EKS architecture to meet compliance requirements (PCI-DSS, HIPAA)?

🧠 **Overview**
Compliance requires controls across people/process/technology: isolation, encryption, audit, access control, secure configs, logging, and documented processes. Use AWS controls + Kubernetes controls and provide evidence for audits.

⚙️ **Key Controls & How to Implement**

* **Account isolation**: separate AWS accounts (Org OUs) per environment (prod, PCI scope).
* **Network isolation**: private subnets, no public access to control plane or sensitive workloads; use VPC flow logs.
* **Data protection**: encrypt EBS/EFS/S3 using KMS CMKs (per-regional, with key policies).
* **Access control**: IRSA, MFA, least-privilege IAM, RBAC mapped to roles, no static AWS creds.
* **Logging & Auditing**: centralize CloudTrail, CloudWatch logs, VPC Flow Logs, Kubernetes audit logs to immutable S3 (WORM/lock if required).
* **Configuration hardening**: Pod Security Standards (restricted), CIS Kubernetes Benchmark, automated CIS scans.
* **Backup & DR**: Encrypted backups, documented restore drills.
* **Change management**: GitOps (ArgoCD/Flux) with PR reviews, signed commits, and immutable images.
* **Monitoring & Detection**: IDS/IPS (Falco), runtime security, alerting to SOC.

🧩 **Compliance-specific examples**

* **PCI**: Isolate cardholder data into separate account/cluster; encrypt all at rest; strict logging retention and auditability.
* **HIPAA**: Business Associate Agreement (BAA) with AWS; ensure PHI encrypted + access logged + minimal personnel access.

✅ **Best Practices**

* Maintain **evidence** (configs, logs, IAM policies) in a secure, immutable store for auditors.
* Use automation (Terraform + CI) to reduce drift and prove reproducible infra.
* Use managed services where they are compliant (RDS with encryption, EKS control plane).
* Engage compliance/security early and run regular audits/pen tests.

💡 **In short**
Combine AWS account segmentation, strong encryption, IRSA + RBAC, logging/audit trails, hardened configs, and automated GitOps to meet compliance—document everything and run regular tests.

---

## Q95: How do you implement pod-to-pod encryption in EKS?

🧠 **Overview**
Pod-to-pod encryption = encrypt traffic between pods. Best implemented with mTLS via service mesh (Istio/Linkerd/App Mesh) or mutual TLS mechanisms at the application layer.

⚙️ **Options**

* **Service mesh (recommended)**: automatic mTLS between sidecars.
* **Application-level TLS**: apps manage certs and perform TLS.
* **IPsec/eBPF**: cluster-level encryption using CNI/overlay (less common on EKS with VPC CNI).

🧩 **Istio (enable mTLS)**

```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata: { name: default, namespace: prod }
spec:
  mtls:
    mode: STRICT
```

🧩 **Verify traffic is encrypted**

* Capture traffic on node loopback and confirm TLS handshakes between proxies (or use istioctl authn tls-check).

✅ **Best Practices**

* Use mesh-managed mTLS for most cases; it handles cert lifecycle.
* Ensure Ingress/Egress boundaries are protected (terminate TLS at ALB only if required).
* Monitor and rotate mesh CA and keys.
* Test connectivity and performance impact.

💡 **In short**
Use a service mesh to get automatic pod-to-pod mTLS, or implement TLS in the app if mesh is not an option.

---

## Q96: What strategies would you use to optimize EKS costs at scale?

🧠 **Overview**
Cost optimization is multi-dimensional: instance choices, autoscaling, spot usage, storage tuning, registry/layer optimizations, and operational automation.

⚙️ **Tactics & How they work**

1. **Right-size & auto-scale**

   * Use HPA + Cluster Autoscaler or Karpenter to only run required nodes.
2. **Leverage Spot + Mixed Instances**

   * Run fault-tolerant workloads on Spot; use diversified instance types and AZs.
3. **Use Savings Plans / Reserved Instances**

   * For stable baseline capacity, buy Savings Plans or Convertible RIs.
4. **Use Karpenter for bin-packing**

   * Karpenter provisions optimal instance types and sizes; reduces wasted CPU/RAM.
5. **Node pooling**

   * Separate pools (on-demand, spot, GPU, burstable) for specific workloads and pricing.
6. **Optimize storage**

   * Move from gp2 → gp3, use lifecycle policies for snapshots, delete unused volumes.
7. **Image and CI efficiency**

   * Minimize image size, use multi-stage builds, share base images via ECR, enable ECR lifecycle policies.
8. **Consolidate clusters where safe**

   * Shared clusters for dev/test; separate prod for critical workloads—balance cost vs isolation.
9. **Monitor & alert on waste**

   * Use tools (Kubecost, Prometheus + alerts) to detect idle nodes, low utilization, or orphaned volumes.
10. **Autoscale CI runners & ephemeral environments**

    * Spin up ephemeral environments and tear them down after use.

🧩 **Sample Karpenter Provisioner for cost efficiency**

```yaml
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
spec:
  requirements:
    - key: node.kubernetes.io/instance-type
      operator: In
      values: ["m5.large","m5a.large","t3.large"]
  ttlSecondsAfterEmpty: 30
  consolidation: true
```

📋 **Cost-impact checklist**

| Action                | Expected Benefit       |
| --------------------- | ---------------------- |
| Use Spot + fallback   | 50–90% compute savings |
| Karpenter/autoscaling | Reduce idle capacity   |
| gp3 volumes           | Lower $/GB than gp2    |
| ECR lifecycle         | Reduce storage costs   |
| Right-sizing          | Lower CPU/RAM waste    |

✅ **Best Practices**

* Measure & attribute costs to teams/projects (tagging + Kubecost).
* Automate cluster & node lifecycle (scale-to-zero dev clusters).
* Use mixed instance types and diversified Spot pools.
* Continuously review Savings Plans/RIs as usage stabilizes.

💡 **In short**
Combine autoscaling (HPA + Karpenter/CA), Spot + mixed instances, storage optimizations, and continuous cost monitoring (Kubecost) to shrink EKS spend while maintaining reliability.

---

# Q97: How do you implement chargeback/showback for EKS resources across teams?

🧠 **Overview**
Chargeback/Showback attributes EKS costs (compute, storage, networking) to teams/projects so finance/engineering can see and control spend.

⚙️ **Purpose / How it works**

* Tagging + metadata (Kubernetes labels, AWS tags) → map resources to teams.
* Export metrics (CPU/Memory/Node-hours, PV GB-month, EBS snapshots, ELB hours).
* Aggregate & attribute costs using tools that ingest both cloud billing and K8s telemetry.

🧩 **Concrete approach**

1. **Enforce tagging / labels at deployment**

   * Kubernetes: `metadata.labels: team: payments project: checkout`
   * AWS: Tag EKS node groups, EBS volumes, ELBs, ECR repos via IaC (Terraform).
2. **Collect telemetry**

   * Use Prometheus (node/cadvisor), kube-state-metrics, kubelet metrics.
   * Export cloud billing (AWS Cost & Usage Report) to S3.
3. **Cost attribution engine**

   * Use Kubecost (recommended) or CloudZero/Apptio/CostExplorer + custom ETL to join K8s usage → cloud cost.
   * Kubecost example: provides allocation by namespace/label and shows unallocated infra waste.
4. **Showback/Chargeback process**

   * Daily/weekly reports by namespace/team.
   * Dashboards + automated Slack/email alerts.
   * For chargeback, bill internal teams by allocated costs.

📋 **Minimal components table**

| Component   | Tool / Example                                       |
| ----------- | ---------------------------------------------------- |
| Tagging     | Terraform `aws_eks_node_group` + k8s labels          |
| Metrics     | Prometheus + kube-state-metrics                      |
| Cost data   | AWS CUR (S3) + Athena / Glue                         |
| Attribution | Kubecost or custom data pipeline (Athena + Redshift) |

✅ **Best Practices**

* Enforce labels via admission controller (Gatekeeper).
* Standardize label schema (`team`, `env`, `app`, `cost-center`).
* Account for shared infra (apportion by CPU/ram or fixed split).
* Automate reports and attach actionable recommendations (idle nodes, unused volumes).
* Audit tag compliance daily.

💡 **In short**
Use enforced labels/tags + telemetry + a cost-attribution tool (Kubecost or CUR+analytics) to produce showback and chargeback reports.

---

# Q98: How would you design an EKS architecture to handle 10,000+ pods?

🧠 **Overview**
Scale-out by designing for IP capacity, control-plane stability, multiple node pools, partitioning workloads, and using autoscaling & scheduling optimizations.

⚙️ **Purpose / How it works**

* Break cluster into logical node pools (node groups/provisioners) and possibly multiple clusters (scale and isolation).
* Use Karpenter/Cluster Autoscaler + HPA for autoscaling.
* Optimize Pod density per node (use larger instance types or ENI prefix delegation).
* Shard workloads (namespaces/clusters) for control-plane and API latency reduction.

🧩 **Architecture patterns & examples**

* **Multi-cluster or multi-AZ clusters**: split by environment/tenant or workload type (stateless vs stateful).
* **Node pools**: GPU, burstable, spot, on-demand — each with labels/taints.
* **Karpenter**: fast pod-driven provisioning to minimize pending pods.
* **IP capacity**: enable `prefix-delegation` (or secondary CIDR, see Q101) and use instance types with higher ENI/IP quotas.
* **Control plane load**: use multiple clusters or federation to avoid too many objects per cluster (10k pods ≈ thousands of objects).

🧩 **Practical checks**

```bash
# Use larger instance types for dense packing
eksctl create nodegroup --cluster prod --node-type m5.4xlarge --nodes-min 5 --nodes-max 50
# Karpenter provisioner skeleton (bin-packing)
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
spec:
  ttlSecondsAfterEmpty: 60
  consolidation: true
```

📋 **When to shard to multiple clusters**

| Criterion                                | When to split                       |
| ---------------------------------------- | ----------------------------------- |
| API server latency                       | Many thousands of CRs / deployments |
| Different compliance/security boundaries | Yes — separate clusters             |
| Failure domain isolation                 | Yes — mission-critical separation   |

✅ **Best Practices**

* Use larger instances and ENI/prefix delegation to increase pod density.
* Partition control-plane-heavy workloads across clusters.
* Centralize logging/monitoring but distribute compute.
* Use Horizontal + Cluster autoscalers and spot capacity with fallbacks.
* Test scale with load tests (kube-burner/kubemark).

💡 **In short**
Scale to 10k+ pods by combining node density, IP management (prefixes/secondary CIDR), autoscaling (Karpenter/CA), and—when needed—sharding into multiple clusters to protect the control plane.

---

# Q99: What are the networking limits in EKS and how do you work around them?

🧠 **Overview**
Practical networking limits are typically driven by **ENI and IP address limits per EC2 instance**, VPC CIDR exhaustion, and CNI behavior; these constrain maximum pods/node and overall cluster IP capacity.

⚙️ **Common limits (conceptually)**

* ENIs per instance and **IPs per ENI** define pod density on a node with `aws-vpc-cni`.
* VPC CIDR size limits total IP count for pods.
* Control-plane throughput/ConnTrack limits may surface at scale.

🧩 **Workarounds / Solutions**

1. **Increase pod density per node**

   * Use instance types with higher ENI/IP quotas (large instances).
   * Enable **prefix delegation** (IP prefix mode) to boost IPs per node.
2. **Custom networking / secondary CIDR (see Q101)**

   * Reserve separate subnets for pods (custom networking) or add secondary CIDR to VPC to expand address pool.
3. **Use CNI alternatives or enhancements**

   * Use **AWS VPC CNI with prefix delegation** or `warm-ip-target` settings.
   * Consider **Cilium with ENI allocation** or overlay CNIs if you need different IP models.
4. **Multi-subnet / Multi-AZ planning**

   * Spread nodes across subnets and AZs; ensure adequate route table & TGW configuration.
5. **Scale-out across clusters**

   * If one VPC exhausted or control-plane hit, shard workloads into additional clusters.
6. **Use NAT/egress optimizations**

   * Minimize ephemeral port exhaustion; tune `conntrack` and use egress proxies if needed.

📋 **Workaround summary**

| Problem                      | Workaround                                     |
| ---------------------------- | ---------------------------------------------- |
| ENI/IP per node insufficient | Use larger instance types or prefix-delegation |
| VPC CIDR exhausted           | Add secondary CIDR / new VPC / subnets         |
| Control plane limits         | Shard into multiple clusters                   |
| Pod-to-pod cross-AZ latency  | Use appropriate subnet placement + TGW         |

✅ **Best Practices**

* Plan IP address space early (allow for growth).
* Use secondary CIDR or prefix-delegation proactively.
* Monitor IP utilization and set alerts.
* Automate provisioning of node groups across multiple subnets/AZs.
* When scaling beyond single-VPC limits, adopt multi-cluster architecture.

💡 **In short**
EKS networking limits stem from EC2 ENI/IP constraints and VPC CIDR sizes — mitigate by prefix delegation, secondary CIDRs, larger instances, alternative CNIs, or by sharding into multiple clusters.

---

# Q100: How do you optimize IP address utilization in large EKS clusters?

🧠 **Overview**
Optimizing IP utilization reduces wasted IPs and delays hitting VPC limits — done via prefix delegation, custom networking, right-sizing node types, and pod density tuning.

⚙️ **Actions to optimize**

1. **Enable prefix delegation (IP prefix mode)**

   * Allocates IP prefixes to nodes (more efficient than single IPs per ENI).
2. **Use larger instance types**

   * Bigger instances have higher ENI/IP capacity → fewer nodes for same pods.
3. **Custom networking**

   * Use dedicated subnets for pods with extra CIDR space or secondary CIDRs.
4. **Tune CNI settings**

   * `WARM_IP_TARGET`, `WARM_ENI_TARGET`, `WARM_PREFIX_TARGET` to reduce over-provisioning.
5. **Right-size Pods**

   * Reduce unnecessary pod replicas and batch small services into shared pods where possible.
6. **Use IPv6 where appropriate**

   * Dual-stack (IPv4+IPv6) can expand addressability (check compatibility).
7. **Garbage collection**

   * Remove unused node groups, orphaned ENIs, unattached EBS/ELB resources.

🧩 **Example CNI env settings (daemonset config)**

```bash
# in aws-node daemonset env
WARM_ENI_TARGET=3
WARM_PREFIX_TARGET=1
WARM_IP_TARGET=10
```

📋 **Monitoring**

* Track Pod IP usage via CloudWatch / Prometheus exporter for `aws-vpc-cni` metrics (AvailableIPs, AllocatedIPs).
* Alert when subnet free IPs drop below threshold.

✅ **Best Practices**

* Use prefix-delegation + instance families with high ENI limits.
* Proactively add secondary CIDRs before exhaustion.
* Automate IP utilization dashboards and alerts.
* Consider multi-cluster approach when single VPC is constrained.

💡 **In short**
Use prefix-delegation, bigger instance types, tuned CNI warm settings, and secondary CIDRs to squeeze more pods per IP budget and avoid VPC exhaustion.

---

# Q101: What is the secondary CIDR feature in EKS and when would you use it?

🧠 **Overview**
A **secondary CIDR** lets you add an additional IPv4 CIDR block to an existing VPC (or to EKS pod networking) to expand address capacity without re-creating the VPC.

⚙️ **Purpose / When to use**

* Use when primary VPC CIDR is near exhaustion and you need more IPs for nodes/pods.
* Useful for migrating workloads or enabling custom networking for pods in a new CIDR range.
* Alternative to creating new VPCs/clusters when address growth is required.

🧩 **Practical notes**

* Add secondary CIDR to VPC → create subnets in the new CIDR → configure routing & security groups.
* In EKS, enable CNI custom networking to leverage subnets from the secondary CIDR for pod IP allocation.
* Ensure any peering, TGW, or route propagation is updated for the new CIDR.

📋 **When NOT to use**

* If governance/regulatory reasons require separate VPCs/accounts — then prefer cluster/account isolation.
* If you need complete failure-domain separation, use separate VPC/cluster.

✅ **Best Practices**

* Plan CIDR allocation ahead; reserve secondary CIDR proactively.
* Update infrastructure as code (Terraform) for reproducibility.
* Test routing and security group rules before moving production traffic.

💡 **In short**
Secondary CIDR = quick way to grow IP capacity in-place; use it to avoid disruptive VPC/cluster re-creation when you need more pod/node IPs.

---

# Q102: How would you implement custom scheduling logic in EKS?

🧠 **Overview**
Custom scheduling lets you control Pod placement beyond built-in kube-scheduler rules (affinity/taints/priority). Options: scheduler plugins, custom scheduler, scheduler extender, or controllers that pre-bind pods.

⚙️ **Approaches**

1. **Prefer built-in features first**

   * Node affinity, pod affinity/anti-affinity, taints & tolerations, priorityClass, and topologySpreadConstraints.
2. **Custom scheduler**

   * Deploy your own scheduler binary; set `schedulerName` in Pod spec.
   * Example Pod:

```yaml
spec:
  schedulerName: my-custom-scheduler
```

3. **Kube-scheduler policy / scheduler framework plugin**

   * Implement a scheduler plugin (best for kubeadm clusters; managed EKS may limit direct scheduler changes).
4. **Scheduling controllers / mutating webhook**

   * Use a controller to pre-bind Pods (create binding via API) or mutate pods with nodeSelector before scheduling.
5. **Use Karpenter/Cluster Autoscaler for capacity decisions**

   * Offload provisioning decisions to Karpenter which reacts to unschedulable pods and provisions optimal nodes.

🧩 **Custom scheduler deployment example (simple)**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata: name: custom-scheduler
spec:
  template:
    spec:
      containers:
      - name: scheduler
        image: myorg/custom-scheduler:latest
        args: ["--v=2", "--leader-elect"]
```

📋 **Trade-offs**

| Method                |   Control | Complexity |                     EKS-friendly |
| --------------------- | --------: | ---------: | -------------------------------: |
| Affinity/Taints       |    Medium |        Low |                              Yes |
| Custom scheduler      | Very High |       High |                 Yes (deployable) |
| Scheduler plugins     | Very High |  Very High | Limited on managed control plane |
| Scheduling controller |      High |     Medium |                              Yes |

✅ **Best Practices**

* Prefer composable primitives (taints/affinity) before custom schedulers.
* If using custom scheduler, ensure high availability, leader election, and metrics.
* Use `schedulerName` explicit pods for special placement; keep most pods on default scheduler.
* Use admission controllers to prevent accidental bypass of scheduling constraints.

💡 **In short**
Start with node affinity/taints; for complex logic deploy a separate scheduler (set `schedulerName`) or use controllers/Karpenter to handle provisioning and placement.

---

# Q103: What strategies would you use for handling large-scale batch processing in EKS?

🧠 **Overview**
Large batch workloads need efficient scheduling, autoscaling, cost-optimization (Spot), job orchestration, and data locality considerations.

⚙️ **Strategies**

1. **Use Kubernetes Jobs / Job Arrays / Parallelism**

   * `spec.parallelism` and `completions` for splitting work.
2. **Batch orchestration frameworks**

   * Argo Workflows, Airflow, or AWS Batch (for extremely large scale) integrated with EKS workers.
3. **Spot + mixed instance node pools**

   * Run ephemeral workers on Spot with fallbacks to on-demand.
4. **Queue-based decoupling**

   * Use SQS/Kafka to store tasks; workers scale with queue depth (KEDA can autoscale based on queue length).
5. **Data locality**

   * Schedule workers in same AZ as data (S3 is cross-AZ but network egress matters). Use EFS/EBS where necessary and node affinity for locality.
6. **Pod/Node sizing & bin-packing**

   * Use larger instances for many concurrent jobs and tune resource requests to reduce fragmentation.
7. **Horizontal scaling & retries**

   * HPA for controllers (KEDA) and robust retry/failure handling in job definitions.

🧩 **KEDA + SQS example**

```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
spec:
  scaleTargetRef:
    name: batch-worker
  triggers:
    - type: aws-sqs-queue
      metadata:
        queueURL: https://sqs.../queue
        queueLength: "50"
```

📋 **When to use AWS Batch vs EKS**

| Need                                                  | Use EKS Jobs/Argo | Use AWS Batch              |
| ----------------------------------------------------- | ----------------: | -------------------------- |
| Kubernetes-native orchestration                       |               Yes | No                         |
| Massive scale with heavy retries & spot orchestration |             Maybe | Yes                        |
| Complex DAGs / workflows                              |    Argo Workflows | AWS Batch + Step Functions |

✅ **Best Practices**

* Architect idempotent jobs.
* Use job queues + KEDA for reactive scaling.
* Use spot where tolerable; provide checkpointing to survive interruptions.
* Monitor job latencies & failures and tune parallelism/limits.

💡 **In short**
Use Jobs + orchestration (Argo/Airflow), queue-driven autoscaling (KEDA), Spot with fallbacks, and careful resource bin-packing to run large-scale batch reliably and cost-effectively.

---

# Q104: How do you implement cluster federation across multiple EKS clusters?

🧠 **Overview**
Cluster federation connects multiple clusters to share services, workloads, and policies. Approaches include Kubernetes Federation (kubefed), service mesh federation, DNS/ingress routing, or custom control-plane tooling (ArgoCD multi-cluster).

⚙️ **Patterns & How they work**

1. **GitOps multi-cluster with ArgoCD/Flux**

   * Single Git repo deploys manifests to multiple clusters. Best for config sync and multi-cluster deployments.
2. **Kubernetes Federation (kubefed)**

   * Syncs resources (Service, Deployments) across clusters (complex, evolving project).
3. **Service mesh federation**

   * Istio/Linkerd/App Mesh federation for cross-cluster service discovery, mTLS, and routing.
4. **Network-level federation (Submariner/Transit Gateway)**

   * Submariner or TGW/PrivateLink connect pod networks across clusters for L3 connectivity.
5. **DNS-based federation**

   * Use Route53 and health-checked ALBs/NLBs per region to route to healthy clusters.

🧩 **Example multi-cluster GitOps (ArgoCD)**

* Install ArgoCD in a management cluster and add multiple clusters as destinations.
* Create `Application` CRs per cluster pointing to cluster-specific overlays.

🧩 **Service mesh + Submariner**

* Use Submariner for cross-cluster networking + Istio for cross-cluster mTLS and routing.

📋 **Comparison**

| Goal                            | Recommended                                     | Notes                                         |
| ------------------------------- | ----------------------------------------------- | --------------------------------------------- |
| Config sync / deployments       | ArgoCD multi-cluster                            | Simple + reliable                             |
| Service-to-service connectivity | Service mesh federation + Submariner            | More complex but powerful                     |
| Cross-cluster data sync         | DB-level replication (Aurora Global / DynamoDB) | Don’t federate stateful services at K8s level |
| Single control plane            | Kubefed (experimental)                          | Less mature & operationally heavy             |

✅ **Best Practices**

* Keep stateful services regional; replicate databases rather than federate PVs.
* Use GitOps for reproducible multi-cluster deployments.
* Secure cross-cluster networking with mTLS and RBAC.
* Automate cluster onboarding and rotate cluster credentials via IRSA/central controller.
* Monitor/control costs and failover SLAs with Route53 health checks and multi-region routing.

💡 **In short**
Prefer GitOps for config/manifest federation and use mesh + networking solutions (Submariner, TGW) for secure cross-cluster service communication—avoid trying to federate stateful storage; replicate data instead.

---

## Q105: How would you design a CI/CD pipeline for EKS that supports 100+ microservices?

🧠 **Overview**
Design for scale, speed and safety: treat pipelines as *templates* (reusable), use *GitOps* for cluster state, separate build from delivery, and offload progressive delivery to rollout controllers. Optimize for concurrency, caching, and per-service ownership.

⚙️ **Purpose / How it works**

* **Build**: containerize, run unit tests, produce immutable image artifacts in a registry (ECR).
* **Scan**: SAST, SBOM, image-scan (ECR/Image scanning).
* **Publish**: tag images with commit SHA and push to ECR (immutable).
* **Deploy**: GitOps controller (ArgoCD/Flux) or push-based CD (Jenkins/X) to apply manifests/Helm charts.
* **Promote & Release**: use Rollout controllers (Argo Rollouts), service mesh, or ALB weights for canary/blue-green.
* **Observe & Automate**: automated health checks + automated rollback.

🧩 **Examples / Commands / Snippets**

* **Build + push (GitHub Actions / Jenkins shell)**

```bash
# build and push
docker build -t $ECR_REPO:$GIT_SHA .
aws ecr get-login-password | docker login --username AWS --password-stdin $ACCOUNT.dkr.ecr.$REGION.amazonaws.com
docker push $ACCOUNT.dkr.ecr.$REGION.amazonaws.com/$ECR_REPO:$GIT_SHA
```

* **Minimal Jenkinsfile (shared library template)**

```groovy
pipeline {
  agent any
  stages {
    stage('Build') { steps { sh './gradlew build' } }
    stage('Image')  { steps { sh 'docker build -t ${IMAGE}:${GIT_COMMIT} .' } }
    stage('Push')   { steps { sh 'docker push ...' } }
    stage('Publish Manifest') { steps { sh 'helm upgrade --install app ./chart --set image.tag=${GIT_COMMIT}' } }
  }
}
```

* **GitOps flow (recommended)**

  * CI writes an image tag update commit to `infrastructure/repos/<service>/overlays/prod` (or creates PR).
  * ArgoCD/Flux reconciles and deploys automatically.

📋 **Table — CI/CD patterns (tradeoffs)**

| Pattern                              |  Scale |                 Speed |                   Safety |  Complexity |
| ------------------------------------ | -----: | --------------------: | -----------------------: | ----------: |
| Push-based CD (Jenkins → kubectl)    | Medium |                  Fast |                  Riskier |         Low |
| GitOps (ArgoCD/Flux)                 |   High | Async (fast on merge) | High (audit + rollbacks) |      Medium |
| Hybrid (GitOps + rollout controller) |   High |           Fast + safe |                Very High | Medium-High |

✅ **Best Practices**

* Use **shared pipeline templates** (Jenkins shared libs / GitHub Action composites / reusable workflows).
* Build once, deploy many — reference images by **immutable SHA**.
* Use **ArgoCD/Flux** for declarative cluster state + audit trail.
* Use **Argo Rollouts** or service-mesh weighted routing for progressive delivery.
* Add gates: automated tests, integration tests in ephemeral environments, and manual approvals for prod.
* Scale CI runners (Kubernetes runners) and cache layers (build caches, registry caches).
* Automate security scans and enforce policy via OPA/Gatekeeper pre-merge or admission.

💡 **In short**
Use CI to build & push immutable images; use GitOps for declarative deployments; enable progressive delivery and automated observability for safe, scalable CI/CD across 100+ services.

---

## Q106: What strategies would you use for database schema migrations in EKS deployments?

🧠 **Overview**
Treat migrations as first-class, versioned, automated operations with clear ownership and safety controls. Avoid running ad-hoc migrations in app startup for production-critical systems.

⚙️ **Purpose / How it works**

* Use dedicated migration tools (Flyway, Liquibase, Alembic, Sqitch, Django migrations) or Kubernetes Jobs that run controlled migration scripts against the DB.
* Implement *backward-compatible* migrations (expand → deploy → migrate → shrink), feature flags, and rollback paths.

🧩 **Patterns & Examples**

* **Migration as a Kubernetes Job (recommended)**

```yaml
apiVersion: batch/v1
kind: Job
metadata: name: schema-migrate
spec:
  template:
    spec:
      serviceAccountName: db-migrator-sa # IRSA
      containers:
      - name: migrate
        image: myorg/db-migrate:latest
        env:
          - name: DATABASE_URL
            valueFrom:
              secretKeyRef: { name: prod-db-secret, key: url }
      restartPolicy: OnFailure
```

* **Blue/Green-safe migration sequence (expand/contract)**

  1. Add new nullable columns / new tables (backwards compatible).
  2. Deploy application version that writes both old & new schema or reads new if present.
  3. Run data migration to populate new columns.
  4. Switch application to use new columns.
  5. Drop old columns once verified.

* **Online migrations for large data**

  * Use **batched updates**, copy tables, or use logical replication (CDC) + backfill. Tools: pt-online-schema-change, gh-ost, or custom batch jobs.

📋 **Comparison Table — Migration runners**

| Runner                     | When to use     | Pros                        | Cons                            |
| -------------------------- | --------------- | --------------------------- | ------------------------------- |
| K8s Job (CI-triggered)     | Most production | Controlled, auditable, IRSA | Must manage retries/locks       |
| App-start migration        | Small apps/dev  | Simple                      | Risky in prod (race conditions) |
| External migration service | Large/complex   | Powerful (CDC)              | Additional infra & ops          |

✅ **Best Practices**

* Use **single writer** migration Job with locking to avoid concurrent runs.
* Keep migrations **idempotent** and **versioned**.
* Test migrations in staging with production-sized data.
* Prefer **backwards-compatible** schema changes.
* Include **feature flags** to decouple deploy & schema changes.
* Store migration scripts alongside app code in Git and run via CI job that creates a PR for infra repo if using GitOps.

💡 **In short**
Run versioned migrations with Kubernetes Jobs (CI-triggered), design changes to be backward compatible, use batching/CDC for big data, and orchestrate via pipeline with rollbacks & feature flags.

---

## Q107: How do you implement progressive delivery with feature flags in EKS?

🧠 **Overview**
Feature flags decouple code deploy from feature exposure. Combined with canary/capacity-based routing and observability, flags enable safe, gradual rollout and fast rollback.

⚙️ **Purpose / How it works**

* Feature flags determine behavioral switches at runtime.
* Use a central flag service (LaunchDarkly, Unleash, Flagr) or self-hosted.
* Tie flags to rollout mechanisms (Ingress weights, service mesh traffic split, Argo Rollouts) and observability (metrics/log-based SLOs).

🧩 **Implementation Roadmap**

1. **Choose flag system**: LaunchDarkly (SaaS), Unleash (OSS), or custom.
2. **Instrument app**: evaluate flag in code; keep defaults safe (off).
3. **Deploy** app to cluster (safe by default).
4. **Progressive rollout**:

   * Start with percentage-based exposure via feature flag.
   * Combine with traffic-splitting at network layer: Argo Rollouts + Istio/App Mesh/ALB weighted routing.
5. **Observe & Decide**:

   * Auto-promote on success (SLO-based) or rollback on errors using automation (Argo Rollouts can auto-promote/rollback based on K8s metrics or Prometheus alerts).

🧩 **Argo Rollouts + Flag combo (concept)**

* Create Rollout that shifts weights (10 → 50 → 100).
* Feature flag controls behavior behind the scenes for the target subset; flag toggled gradually for user groups.

📋 **Example: simple flag check (pseudo-code)**

```python
if feature_flag_client.is_enabled('new_search', user_id):
    use_new_search()
else:
    use_old_search()
```

✅ **Best Practices**

* Keep flags **short-lived** and remove stale flags.
* Use **targeted flags** (by user or tenant) for small cohorts.
* Combine flags with **observability** and automated promotion/rollback rules.
* Secure flag management (RBAC on who can toggle).
* Test flag behavior in staging and ephemeral environments.

💡 **In short**
Use a feature-flag system + progressive traffic control (Argo Rollouts/mesh) + automated observability-driven promotion to implement safe progressive delivery on EKS.

---

## Q108: How would you architect EKS for running machine learning workloads at scale?

🧠 **Overview**
ML workloads demand specialized compute (GPUs), scalable data pipelines, model training/serving frameworks, and efficient data storage. Architect for reproducibility, data locality, and cost-efficiency.

⚙️ **Core Components**

* **Node pools**: GPU node groups (on-demand + spot), CPU-heavy instance pools, inference-optimized instances.
* **Storage**: S3 for raw data & model artifacts; FSx for Lustre or EFS for high-performance shared filesystems during training.
* **Orchestration & frameworks**: Kubeflow / KServe / MLFlow or SageMaker integration for training/serving + experiment tracking.
* **Data pipeline**: Managed ETL (Glue, Spark on EMR/EKS) or in-cluster Spark (Spark Operator).
* **Autoscaling**: Karpenter or CA for fast provisioning of GPU nodes.
* **Model registry**: MLflow or SageMaker Model Registry, with CI to build and push containerized model images.
* **Serving**: KServe/TFServing/Bentoml + autoscale (KEDA or HPA) with GPU pooling where needed.

🧩 **Practical snippets**

* **GPU Pod request**

```yaml
resources:
  limits:
    nvidia.com/gpu: 1
```

* **FSx Lustre for training scratch** (provision via Terraform + mount via CSI).

📋 **Architecture notes**

| Concern              | Recommendation                                                  |
| -------------------- | --------------------------------------------------------------- |
| Large-scale training | Use spot + checkpointing + batch orchestration (Argo Workflows) |
| High I/O             | FSx Lustre or local NVMe + parallel IO                          |
| Model serving        | KServe with autoscaling & canary deployments                    |
| Experiment tracking  | MLflow + artifact store (S3)                                    |

✅ **Best Practices**

* Use **checkpointing** and resume training for spot interruptions.
* Size GPU node pools and diversify instance types to improve spot reliability.
* Keep heavy data transfers close to compute (same AZ or use FSx Lustre).
* Containerize training jobs and orchestrate via Argo Workflows or Kubeflow Pipelines.
* Automate model validation and promotion to production via GitOps + model registry.

💡 **In short**
Use EKS node pools with GPU + FSx/S3 for storage, orchestrate jobs with Kubeflow/Argo, autoscale with Karpenter, and use model registries + CI for reproducible ML at scale.

---

## Q109: How do you implement GPU scheduling and sharing in EKS?

🧠 **Overview**
GPU resources are scheduled as dedicated devices (`nvidia.com/gpu`) via the NVIDIA device plugin. For finer sharing, use MIG (on supported GPUs) or GPU partitioning solutions.

⚙️ **How it works**

* Deploy **NVIDIA device plugin** DaemonSet so kubelet can advertise GPU resources.
* Request GPUs in Pod spec (`limits.nvidia.com/gpu: 1`).
* Use node selectors / taints & tolerations to target GPU node pools.

🧩 **Examples / Commands**

* **Install NVIDIA device plugin**

```bash
kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.11.0/nvidia-device-plugin.yml
```

* **Pod requesting GPU**

```yaml
spec:
  nodeSelector:
    beta.kubernetes.io/instance-type: p3.2xlarge
  containers:
  - name: trainer
    image: my-trainer:latest
    resources:
      limits:
        nvidia.com/gpu: 1
```

* **Use NVIDIA MIG (A100/V100 family)**

  * Configure MIG profiles at node/driver level to expose fractional GPU devices (e.g., 7g.20gb). Device plugin will expose MIG slices as separate resources (e.g., `nvidia.com/mig-1g.5gb`).

📋 **Sharing strategies**

| Method                  | Benefit                                                     | Consideration                               |
| ----------------------- | ----------------------------------------------------------- | ------------------------------------------- |
| Dedicated GPU per pod   | Simple, isolated                                            | Lower utilization for small jobs            |
| MIG (GPU slicing)       | Fractional GPU, better utilization                          | Requires supported hardware & driver config |
| Multi-instance batching | Batch small jobs onto single GPU with in-process scheduling | App-level complexity                        |

✅ **Best Practices**

* Use **taints/labels** for GPU nodes (prevent non-GPU workloads).
* Mix Spot + On-demand GPU pools; use checkpointing.
* Prefer **MIG** when hardware supports it to improve utilization for many small jobs.
* Monitor GPU utilization (Prometheus + DCGM exporter).
* Use Karpenter for fast GPU provisioning where supported.

💡 **In short**
Install NVIDIA device plugin, schedule with `nvidia.com/gpu` requests, use MIG for fractional sharing, and orchestrate GPU pools with taints/labels + autoscaler.

---

## Q110: What strategies would you use for handling data-intensive workloads in EKS?

🧠 **Overview**
Data-intensive workloads need high I/O, network throughput, locality, and scalable storage. Architect storage/access to avoid network bottlenecks and optimize throughput.

⚙️ **Key Strategies**

* **Use right storage**:

  * **S3**: object storage for large datasets, use parallel multipart transfers.
  * **FSx for Lustre**: high-throughput parallel file system for HPC-style workloads and fast ephemeral scratch.
  * **EBS io2/Provisioned IOPS**: high IOPS/low-latency block storage for single-node workloads.
  * **EFS (with performance mode set appropriately)** for shared POSIX workloads (watch throughput limits).
* **Data locality & placement**:

  * Place compute in same AZ as storage or use caching layers (FSx + S3 data repository).
  * Use node-local NVMe ephemeral storage for very high I/O scratch.
* **Parallelize IO**:

  * Use sharding/partitioning across workers; use parallel readers/writers.
  * Use data formats that support parallel reads (Parquet, TFRecords).
* **Network & Instance selection**:

  * Use instances with **enhanced networking** (ENA) and high network bandwidth (e.g., `c5n`, `m5n`, `i3en`).
  * Use large instances for fewer network hops and higher per-node throughput.
* **Caching & Pre-fetch**:

  * Use sidecar caches (Redis, memcached) or local SSD caches for hot data.
  * Use S3 Transfer Acceleration or multipart uploads for faster transfers across regions.
* **Orchestration**:

  * Use Spark on EKS (Spark Operator), Dask, or Ray for distributed processing.
  * Use KubeBatch/Volcano for scheduling large batch jobs that require gang-scheduling.
* **Observability & throttling**:

  * Monitor IOPS, network, and S3 request rates; throttle or backoff on 429s.

🧩 **Quick Pod snippet mounting FSx via CSI**

```yaml
volumeClaimTemplates:
  - metadata: { name: scratch }
    spec:
      storageClassName: fsx-lustre-sc
      accessModes: [ReadWriteMany]
      resources:
        requests: { storage: 1Ti }
```

📋 **Data workload mapping**

| Workload                    | Recommended storage    | Notes                                           |
| --------------------------- | ---------------------- | ----------------------------------------------- |
| ML training (large dataset) | S3 + FSx Lustre cache  | FSx for high throughput scratch                 |
| Low-latency DB              | EBS io2                | Single-writer block storage                     |
| Shared POSIX                | EFS (max IOPS caveats) | Good for many small files, but check throughput |
| HPC / parallel              | FSx Lustre             | Optimal for parallel IO                         |

✅ **Best Practices**

* Co-locate data and compute (same AZ).
* Use bulk parallel transfer tools (aws s3 sync with parallelism, s5cmd).
* Use compression and columnar formats to reduce data volume.
* Tune filesystem mount options and kernel params for throughput.
* Use autoscaling for compute but ensure storage can keep up (burst limits).

💡 **In short**
Pick storage based on IO pattern (S3 + FSx for throughput, EBS for low-latency block), co-locate compute and data, parallelize IO, and use specialized schedulers/operators for distributed data processing.

---

## Q111: How do you implement custom metrics for autoscaling decisions in EKS?

🧠 **Overview**
Custom metrics let autoscalers (HPA, KEDA) scale pods on business or application signals (queue length, request latency, custom counters) instead of only CPU/memory. The typical flow: app → exposes Prometheus metrics → metrics adapter (Prometheus Adapter / custom metrics API) → HPA (or KEDA) reads metric → scales.

⚙️ **Purpose / How it works**

* Expose metrics from app (/metrics Prometheus format).
* Scrape with Prometheus (or push with PushGateway).
* Use an adapter (Prometheus Adapter or custom metrics API) to surface metrics to Kubernetes HPA (v2) or use KEDA to directly read metrics and scale deployments/Jobs.

🧩 **Examples / Commands / Config snippets**

1. **Expose a custom metric (example in Go / Python pseudo)**

```text
# HTTP /metrics returns Prometheus metrics
# example metric name: myapp_pending_jobs_total
```

2. **Prometheus + ServiceMonitor (Prometheus Operator)**

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: myapp-sm
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: myapp
  endpoints:
    - port: metrics
      path: /metrics
      interval: 15s
```

3. **Install Prometheus Adapter (maps Prometheus metrics → K8s customMetrics)**

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus-adapter prometheus-community/prometheus-adapter \
  --namespace monitoring \
  --set prometheus.url=http://prometheus-operated.monitoring.svc
```

Adapter config maps PromQL → metric name (ConfigMap `rules`).

4. **HPA using custom metric (autoscaling/v2)**

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: myapp-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: myapp
  minReplicas: 2
  maxReplicas: 20
  metrics:
  - type: Pods
    pods:
      metric:
        name: myapp_pending_jobs_total
      target:
        type: AverageValue
        averageValue: "5"
```

5. **Alternative: KEDA (direct connectors to queues, Kafka, CloudWatch)**

```bash
kubectl apply -f https://github.com/kedacore/keda/releases/latest/download/keda-2.10.0.yaml
```

Example ScaledObject:

```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
spec:
  scaleTargetRef:
    name: myapp
  triggers:
  - type: aws-sqs-queue
    metadata:
      queueURL: https://sqs...
      queueLength: "50"
```

📋 **When to use what**

| Need                            | Use                                       |
| ------------------------------- | ----------------------------------------- |
| Metric from Prometheus          | Prometheus Adapter + HPA                  |
| Queue length or external scaler | KEDA (connectors out-of-the-box)          |
| Complex scaling logic           | External controller or custom metrics API |

✅ **Best Practices**

* Expose stable metric names and labels; avoid cardinality explosion.
* Ensure metrics have appropriate scrape interval for responsiveness.
* Test metric → adapter → HPA mapping in staging.
* Use smoothing (rolling window / moving average) to avoid flapping.
* Alert on adapter failures (Prometheus Adapter/KEDA health).

💡 **In short**
Expose Prometheus-format metrics → scrape with Prometheus → expose via Prometheus Adapter (or use KEDA) → configure HPA/ScaledObject to act on those metrics.

---

## Q112: How would you design an observability stack for EKS using Prometheus, Grafana, and Jaeger?

🧠 **Overview**
A production observability stack collects metrics (Prometheus), visualizes them (Grafana), captures traces (Jaeger/OpenTelemetry), and centralizes logs (Fluent Bit → Loki/Elasticsearch/CloudWatch). Use operators/Helm to make deployment repeatable and use GitOps for config.

⚙️ **Components & responsibilities**

* **Prometheus (Operator)** — scrape kubelet, kube-state-metrics, app `/metrics`.
* **Grafana** — dashboards, alerts (or Alertmanager integrated with Prometheus).
* **Alertmanager** — aggregation & routing (Slack/pager).
* **Jaeger / OpenTelemetry Collector** — receive traces, export to storage/backends (Elasticsearch/S3/AWS X-Ray).
* **Fluent Bit / Fluentd** — forward container logs to central store (CloudWatch/Elasticsearch/Loki).
* **Storage** — Thanos / Cortex for long-term metric storage & global view across clusters.

🧩 **Quick install snippets (Helm / Operator)**

```bash
# Prometheus Operator
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install kube-prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace

# Grafana is included in the stack; expose via ingress+auth
# Jaeger (all-in-one for dev, or collector+ingester for prod)
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm install jaeger jaegertracing/jaeger -n monitoring
```

🧩 **Instrument apps with OpenTelemetry**

* Use OpenTelemetry SDKs to instrument traces/metrics.
* Configure apps to export to `otel-collector` service in cluster; collector forwards to Jaeger and Prometheus remote_write/OTLP endpoints.

**otel-collector** snippet:

```yaml
receivers:
  otlp:
exporters:
  jaeger:
    endpoint: jaeger-collector.monitoring.svc.cluster.local:14250
service:
  pipelines:
    traces:
      receivers: [otlp]
      exporters: [jaeger]
```

📋 **Architecture patterns**

| Requirement                       | Component                                      |
| --------------------------------- | ---------------------------------------------- |
| Short-term metrics & alerts       | Prometheus Operator                            |
| Long-term metrics / multi-cluster | Thanos / Cortex                                |
| Traces                            | Jaeger + OTel Collector                        |
| Dashboards                        | Grafana + provisioning                         |
| Logs                              | Fluent Bit → Loki / Elasticsearch / CloudWatch |

✅ **Best Practices**

* Use **ServiceMonitors** and **PodMonitors** to manage scrape configs via Git.
* Keep scrape intervals balanced for cost vs latency.
* Use **remote_write** to offload long-term storage (Thanos/Cortex).
* Secure Grafana and Jaeger (auth, RBAC, TLS).
* Use sampling for traces to control cost and storage.
* Provision dashboards as code (Grafana provisioning) and manage via GitOps.

💡 **In short**
Deploy Prometheus Operator + Grafana + Jaeger + Fluent Bit, instrument apps with OpenTelemetry, use Thanos/Cortex for long-term metrics and manage all configs with GitOps for repeatable, observable EKS clusters.

---

## Q113: What strategies would you use for log aggregation in a multi-cluster EKS environment?

🧠 **Overview**
Centralized logging aggregates logs from multiple clusters into a central backend for search, alerting, and retention. Primary patterns: centralized collectors (Fluent Bit/Fluentd) forwarding to a scalable backend (CloudWatch, ELK, Loki, S3 + Athena), or cluster-local agents with centralized ingestion.

⚙️ **Options & patterns**

1. **Cluster-local Fluent Bit → central ingestion endpoints**

   * Each cluster runs Fluent Bit DaemonSet shipping logs to a central Fluentd/Logstash, Elasticsearch cluster, Loki, or CloudWatch Log Group per cluster/account.
2. **Central FluentD aggregator (pull model)**

   * Agents forward to a central aggregator service in a logging VPC / account.
3. **S3-backed archive + query**

   * Ship raw logs to S3 (cost-effective) and use Athena for ad-hoc queries; send indices to ES/Loki for real-time search.
4. **Multi-tenant Loki + labels**

   * Use tenant labels/namespaces to separate log access and apply retention per tenant.

🧩 **Example Fluent Bit config (forward to CloudWatch)**

```ini
[INPUT]
    Name tail
    Path /var/log/containers/*.log
    Tag kube.*

[OUTPUT]
    Name cloudwatch_logs
    Match kube.*
    region ap-south-1
    log_group_name /aws/eks/cluster-logs
    log_stream_prefix from-fluentbit-
```

🧩 **Cross-cluster considerations**

* Standardize log format & labels (`cluster`, `namespace`, `pod`, `app`, `team`).
* Use centralized auth & access control (IAM roles per cluster via IRSA).
* Use index templates & retention policies per cluster or tenant.

📋 **Comparison table**

| Backend        | Pros                              | Cons                                   |
| -------------- | --------------------------------- | -------------------------------------- |
| CloudWatch     | AWS-managed, IAM integrated       | Cost at scale, search UX less flexible |
| ELK (Elastic)  | Powerful search & aggregations    | Operationally heavy & expensive        |
| Loki + Grafana | Cost-effective for logs by labels | Not as full-text powerful as ES        |
| S3 + Athena    | Very cheap long-term archive      | Not real-time, query latency           |

✅ **Best Practices**

* Tag logs with `cluster`, `namespace`, `team` to enable chargeback & filtering.
* Use per-team/cluster log retention and lifecycle policies.
* Protect PII by scrubbing logs before shipping or using filters in Fluent Bit.
* Scale backend separately (use managed Elasticsearch/Opensearch or Grafana Cloud).
* Use sampling for noisy logs (e.g., debug logs) and rate limiting in the collector.

💡 **In short**
Run lightweight collectors (Fluent Bit) in each cluster with consistent labels, forward to a central backend (CloudWatch/ELK/Loki/S3) and manage retention, access and indexing centrally for multi-cluster observability.

---

## Q114: How do you implement distributed tracing across microservices in EKS?

🧠 **Overview**
Distributed tracing follows requests across services to detect latency hotspots and errors. Implement by instrumenting code with OpenTelemetry SDKs, deploying an OTEL collector, and using a tracing backend (Jaeger, Tempo, X-Ray).

⚙️ **Purpose / How it works**

* Each service instruments requests and emits spans including trace-context headers (W3C `traceparent`).
* Spans go to an **OTel Collector** (in-cluster) which exports to Jaeger/Tempo/AWS X-Ray.
* Correlate traces with logs & metrics (use trace IDs in logs).

🧩 **Practical steps**

1. **Instrument services** with OpenTelemetry (Java/.NET/Python/Node). Example (pseudo):

```python
from opentelemetry import trace
tracer = trace.get_tracer(__name__)
with tracer.start_as_current_span("handle_request"):
    ...
```

2. **Deploy OpenTelemetry Collector** as a Deployment/DaemonSet:

```yaml
receivers:
  otlp:
exporters:
  jaeger:
    endpoint: jaeger-collector.monitoring.svc.cluster.local:14250
service:
  pipelines:
    traces:
      receivers: [otlp]
      exporters: [jaeger]
```

3. **Propagate trace context** through HTTP/gRPC using standard headers; configure HTTP clients/servers to forward headers automatically.
4. **Store & visualize** traces in Jaeger/Grafana Tempo; connect traces to Grafana dashboards and logs (log lines include trace_id).

🧩 **Sample Env vars for app**

```yaml
env:
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: "http://otel-collector.monitoring.svc.cluster.local:4317"
- name: OTEL_TRACES_SAMPLER
  value: "parentbased_traceidratio"
- name: OTEL_TRACES_SAMPLER_ARG
  value: "0.1" # 10% sampling
```

📋 **Best Practices**

* Use **OpenTelemetry** as a standard for portability.
* Use **sampling** (head-based or tail-based) to control cost; reserve 100% sampling for error traces.
* Propagate trace IDs into logs (structured logging) for correlation.
* Secure collector endpoints and limit data retention/sampling to control costs.
* Use a central trace store (Jaeger/Tempo/X-Ray) and link traces to Grafana dashboards and alerts.

💡 **In short**
Instrument apps with OpenTelemetry, send spans to an OTEL collector in-cluster, export to Jaeger/Tempo/X-Ray, and correlate traces with logs & metrics for end-to-end observability.

---

## Q115: How would you design chaos engineering experiments for EKS clusters?

🧠 **Overview**
Chaos engineering systematically introduces controlled failures to validate resilience and recovery. Use tools like LitmusChaos, Chaos Mesh, or kube-monkey and run experiments in a staged way (dev → staging → prod with safety guards).

⚙️ **Purpose / How it works**

* Define hypotheses (e.g., “Service X should recover within 60s on node failure”).
* Inject faults (pod kill, node drain, network delay, EBS IO errors).
* Observe SLOs and alerts; automate remediation if needed.

🧩 **Experiment lifecycle**

1. **Define hypothesis & steady-state** (SLOs/metrics).
2. **Create an experiment** (e.g., pod-kill, network-latency).
3. **Run experiment in staging**, measure & review.
4. **Automate experiments in prod under strict guardrails** (time windows, blast radius limits).
5. **Remediate and harden** based on findings.

🧩 **LitmusChaos example (pod-delete)**

```yaml
apiVersion: litmuschaos.io/v1alpha1
kind: ChaosExperiment
metadata: { name: pod-delete }
spec:
  definition:
    selector:
      matchLabels: { name: pod-delete }
    image: litmus/pod-delete:latest
    args: ["-pods=app"]
```

Run with ChaosEngine and ChaosWorkflow, and include probes (Prometheus queries) to assert SLOs.

📋 **Common experiments**

| Type          | Example                                 |
| ------------- | --------------------------------------- |
| Compute       | Kill pods, drain/terminate nodes        |
| Network       | Add latency, packet loss, blackhole     |
| IO            | Throttle disk IO, attach/detach volumes |
| Control plane | API server latency (non-destructive)    |

✅ **Safety & Best Practices**

* Start in **non-prod** until stable.
* Limit **blast radius** (one pod, one node, specific namespace).
* Always have **automated rollback** and runbooks.
* Use **probes** to automatically fail experiment if SLOs breach.
* Schedule experiments during business hours with on-call support.
* Store results & remediation actions in runbook; iterate.

💡 **In short**
Use LitmusChaos/Chaos Mesh to inject controlled failures, start small (staging), have guards/probes and runbooks, then expand scope as confidence grows.

---

## Q116: What strategies would you use to implement rate limiting at the cluster level?

🧠 **Overview**
Cluster-level rate limiting controls request ingress (L7) or service-to-service (L7/L4) traffic to protect services from overload and enforce quotas. Implement using ingress controllers (NGINX/Envoy/ALB), service mesh (Istio/Linkerd/App Mesh), or API Gateway (API Gateway v2 / Gateway API).

⚙️ **Options & How they work**

1. **Ingress controller (NGINX) annotations** — simple per-service rate-limits (requests/sec, burst).
2. **Envoy-based rate limiting** via an external rate-limit service or Istio EnvoyFilter + Redis-based limiter for global quotas.
3. **Service Mesh (Istio + Envoy RLS / Global Rate Limiter)** — fine-grained policies (per user, per service, per route).
4. **API Gateway / WAF** — centralized ingress-level throttling with quotas and API keys.
5. **Egress / inter-service limiting** — sidecar-based enforcement or egress proxy to prevent noisy neighbors.

🧩 **Examples**

* **NGINX Ingress annotations**

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/limit-connections: "20"
    nginx.ingress.kubernetes.io/limit-rpm: "100"
```

* **Istio + Envoy rate limit (conceptual)**

  * Deploy a rate-limit service (Redis backend).
  * Configure Envoy/istio `EnvoyFilter` to call rate-limit service for specific routes.
  * Use `VirtualService` + `DestinationRule` to apply policies.

* **Gateway API + WASM/Filters** (future-proof)

  * Use Gateway API with filters (WASM) to implement per-route rate limiting and consistent policies.

📋 **Comparison table**

| Need              | Simple      | Advanced/global | Per-user quotas |
| ----------------- | ----------- | --------------- | --------------- |
| NGINX Ingress     | ✅           | ❌               | Limited         |
| ALB + WAF         | ✅           | ✅ (WAF rules)   | Limited         |
| Istio/Envoy + RLS | ✅ (complex) | ✅               | ✅               |
| API Gateway       | ✅           | ✅               | ✅ (API keys)    |

✅ **Best Practices**

* Rate-limit at the **edge** (ingress) first, then service-to-service for protection-in-depth.
* Implement per-client and per-route limits where applicable.
* Use a **centralized rate-limiter** (Redis/Policy service) for global quotas across replicas/clusters.
* Expose meaningful `Retry-After` and HTTP 429 responses and implement client-side backoff.
* Test limits with load tests and ensure monitoring/alerts on rate-limit rejections.

💡 **In short**
Edge-rate-limit with ingress/API Gateway for coarse protection; use Envoy/Istio + centralized rate-limiter for advanced per-user/global quotas and fine-grained control across services.

---

## Q117: How do you implement API gateway patterns in front of EKS services?

🧠 **Overview**
An API Gateway provides a single entry point for external clients to multiple backend services running in EKS. It handles routing, auth, rate-limiting, TLS termination, caching, request/response transformation, observability, and can centralize policy enforcement.

⚙️ **Purpose / How it works**

* Gateways terminate TLS and expose unified endpoints.
* They route requests to Services/Ingresses (ALB/NLB + Ingress, API Gateway HTTP APIs, or an Envoy/NGINX/Traefik gateway).
* Integrate with authentication (Cognito/OAuth/OIDC/jwt), WAF, throttling, and can offload L7 concerns from apps.

🧩 **Examples / Commands / Config snippets**

**Pattern A — AWS native (recommended for many cases)**

* External traffic → **Amazon API Gateway (HTTP API)** or **ALB** → target EKS Ingress (Ingress Controller/ALB Controller).
* Use **API Gateway** for global endpoints, caching, API keys, usage plans, and WAF integration.
* Example: API Gateway invokes private NLB (VPC link) which forwards to Ingress/Service.

**Pattern B — In-cluster Gateway (service mesh / Envoy)**

* External ALB → Ingress (Envoy/Gateway API) → Envoy handles routing, rate-limiting, auth (JWT), retries.

```yaml
# Example: Gateway API + HTTPRoute snippet (conceptual)
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata: name: public-gateway
spec:
  listeners:
    - hostname: api.example.com
      port: 443
      protocol: HTTPS
---
apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
spec:
  parentRefs:
    - name: public-gateway
  rules:
    - matches: ...
      backendRefs:
        - name: service-a
          port: 80
```

**Auth & policies**

* JWT validation at gateway (API Gateway authorizer or Envoy JWT filter).
* Rate limiting at gateway (API Gateway usage plans, NGINX annotations, Envoy RLS).

📋 **Comparison: API Gateway vs In-cluster Gateway**

| Concern                                | API Gateway (AWS) | In-Cluster Gateway (Envoy/Gateway API) |
| -------------------------------------- | ----------------: | -------------------------------------- |
| Global reach & caching                 |                 ✅ | Partial                                |
| Fine-grained L7 control                |           Limited | ✅                                      |
| Operational overhead                   |               Low | Higher (manage controllers)            |
| Native AWS integrations (WAF, Cognito) |                 ✅ | Some manual wiring                     |
| Cost model                             |   Pay-per-request | EC2/EKS resource cost                  |

✅ **Best Practices**

* Use **private integrations** (VPC Link / NLB) for secure communication to cluster.
* Offload TLS + WAF + caching to API Gateway/ALB where appropriate.
* Implement auth at the edge (JWT/OIDC) and enforce RBAC inside cluster.
* Use Gateway API or Ingress with annotations for consistent routing config in GitOps.
* Centralize observed metrics and traces (API Gateway + OTel + Jaeger) and propagate trace-id to pods.

💡 **In short**
Choose AWS API Gateway/ALB for managed edge features; use in-cluster Envoy/Gateway API for advanced L7 control. Combine both for edge security + internal traffic management.

---

## Q118: How would you design a hybrid architecture connecting on-premises and EKS workloads?

🧠 **Overview**
A hybrid design connects on-prem systems with EKS running in AWS for bursting, data locality, or phased cloud migration. Core: secure, low-latency network connectivity + centralized identity, consistent DNS, and data access patterns.

⚙️ **Purpose / How it works**

* Provide secure, routable connectivity (Direct Connect / VPN / Transit Gateway) between on-prem and VPC(s).
* Ensure authentication/authorization consistency (AD/Azure AD via SSO, or federated IdP).
* Choose data access model: replicate data to S3/DB in cloud, use on-prem DB via private links, or use caching.

🧩 **Architecture components & patterns**

1. **Network**

   * Use **AWS Direct Connect** (preferred) or **Site-to-Site VPN** to link on-prem to AWS VPC/Transit Gateway.
   * Attach VPC to **Transit Gateway** for multi-VPC/hybrid scale.
2. **Service connectivity**

   * Expose internal services via **private NLBs**, **PrivateLink**, or **internal ALB**; on-prem clients access via VPC connectivity.
   * For cross-cluster pod networking, use **Transit Gateway** + route tables or VPN.
3. **DNS**

   * Use Route53 private hosted zones + conditional forwarding from on-prem DNS to Route53 Resolver endpoints.
4. **Identity**

   * Federate on-prem ID (AD) with AWS IAM (SSO) and use IRSA for pod-level AWS access; integrate authentication via OIDC/OAuth for services.
5. **Data**

   * Prefer replicating hot datasets to S3/managed DBs (RDS/Aurora) or using caching layers (Redis) near compute to reduce latency.
6. **Security**

   * Enforce granular network policies, ZTNA principles, and monitoring (VPC Flow Logs, IDS).

🧩 **Simple connectivity example**

* On-prem → Direct Connect → Transit Gateway → VPC with EKS subnets and NLB connected to EKS Ingress.

📋 **Trade-offs**

| Goal                            | Preferred approach                        |
| ------------------------------- | ----------------------------------------- |
| Low latency stable connection   | Direct Connect + TGW                      |
| Cost-sensitive / low-throughput | Site-to-Site VPN                          |
| Secure private service access   | PrivateLink / NLB                         |
| DNS consistency                 | Route53 Resolver + conditional forwarders |

✅ **Best Practices**

* Route only required networks over the connection (avoid full mesh).
* Use PrivateLink for exposing specific APIs securely without routing entire VPC ranges.
* Keep data replication and caching for latency-sensitive workloads.
* Standardize IaC (Terraform) to create consistent hybrid infra and apply network ACLs/SGs.
* Monitor latency and failover paths; test incident runbooks.

💡 **In short**
Connect via Direct Connect/TGW or VPN, use PrivateLink/NLB for private service exposure, replicate hot data to cloud, and centralize identity and DNS for a seamless hybrid experience.

---

## Q119: What strategies would you use for migrating from self-managed Kubernetes to EKS?

🧠 **Overview**
Migrate incrementally: automate infra with IaC, export workloads/configs, validate compatibility, and move workloads with minimal disruption (canary migration, blue/green, or re-create & cutover). Prioritize stateless services first, stateful later with careful data migration.

⚙️ **Purpose / How it works**

* Recreate cluster infra in EKS via Terraform/eksctl.
* Use GitOps (ArgoCD/Flux) to push manifests to new cluster.
* Synchronize data and cut over traffic when ready.

🧩 **Migration plan (step-by-step)**

1. **Assess**: inventory apps, CRDs, security policies, network, storage, and dependencies.
2. **Prepare infra**: create EKS cluster(s) with required VPC, subnets, node pools, and RBAC using IaC.
3. **Compatibility fixes**: adapt deprecated APIs, PodSecurity/policies, and admission webhooks.
4. **CI/CD & GitOps**: point CI to new cluster or use GitOps to deploy manifests into EKS (use immutable image tags).
5. **Migrate stateless apps**: deploy to EKS, validate, then switch traffic (DNS/Ingress).
6. **Migrate stateful apps**:

   * For DBs: use logical replication, backups + restore (RDS/Aurora migration or dump/restore), or snapshot/replicate PVs (Velero/EBS snapshots).
   * Use Storage CSI drivers (EBS/EFS) and test restore/resize.
7. **Data sync & cutover**: use dual-write (if possible) or cutover window; validate.
8. **Decommission**: retire old cluster once traffic and monitoring validated.

🧩 **Tools & commands**

* `eksctl` / `terraform-aws-eks` module — create EKS reproducibly.
* `kubectl get all --all-namespaces -o yaml` & transform manifests.
* `velero` for backup/restore of workloads & PV snapshots.

📋 **Migration patterns**

| Pattern                              | Use when                                  |
| ------------------------------------ | ----------------------------------------- |
| Recreate & cutover                   | Small clusters, minimal state             |
| Blue/green (two clusters)            | Critical services, zero-downtime          |
| Lift-and-shift (node-by-node)        | Complex setups needing minimal app change |
| Incremental (namespace-by-namespace) | Large microservice landscapes             |

✅ **Best Practices**

* Automate everything (IaC + GitOps) to avoid config drift.
* Validate infra (security groups, IAM, PodSecurity) early.
* Test backups & restores before migrating stateful services.
* Use canaries and feature flags to limit blast radius.
* Keep thorough runbooks and rollback plans.

💡 **In short**
Inventory → recreate infra in EKS via IaC → migrate stateless first → migrate stateful with snapshots/replication → cutover using canary/blue-green; automate and test every step.

---

## Q120: How do you implement backup and restore strategies for EKS clusters?

🧠 **Overview**
Backups must cover cluster configuration (manifests, CRDs), persistent data (PV snapshots), container images, and cloud infra state. Restore procedures should be documented, automated, and tested regularly.

⚙️ **Purpose / How it works**

* Use Velero for cluster-level backups (including CRDs and PV snapshots via CSI).
* Use AWS-native backups: EBS snapshots, EFS backups, RDS snapshots, S3 versioning/replication.
* Store IaC & manifests in Git (single source of truth) for rapid recreation.

🧩 **Backup components & commands**

**Velero (cluster + PV snapshots)**

```bash
velero install --provider aws --bucket my-backup-bucket --plugins velero/velero-plugin-for-aws:v1.5.0 --use-volume-snapshots
# Backup:
velero backup create cluster-backup-$(date +%Y%m%d) --include-namespaces prod
# Restore:
velero restore create --from-backup cluster-backup-20251201
```

**EBS snapshots (automated)**

* Use AWS Backup or lifecycle Lambda to snapshot EBS volumes; tag snapshots with cluster/app metadata.

**GitOps + IaC**

* Keep all manifests & Helm charts in Git. Recreate cluster and reapply manifests for config restore.

📋 **What to back up**

| Item                        | Tool / Method                                                |
| --------------------------- | ------------------------------------------------------------ |
| Cluster manifests & CRDs    | Git + Velero backup of resources                             |
| PersistentVolumes (EBS/EFS) | CSI snapshots (Velero) / AWS Backup                          |
| Container images            | ECR + cross-region replication                               |
| IAM / infra                 | Terraform state (remote backend), CloudFormation templates   |
| Secrets                     | Secrets Manager (replication) or encrypted SOPS files in Git |

✅ **Best Practices**

* Test restore DR drills regularly (full restore validation).
* Encrypt backups at rest and control access separately.
* Automate backup schedules and retention policies.
* Keep backups in a different account/region for disaster recovery.
* Document step-by-step restore runbooks and RTO/RPO expectations.

💡 **In short**
Use Velero for cluster + PV snapshots, AWS Backup/EBS/EFS/RDS snapshots for data, store config in Git/IaC, and test restores regularly with documented runbooks.

---

## Q121: What tools would you use for EKS cluster state management and disaster recovery?

🧠 **Overview**
Cluster state management mixes IaC for infrastructure, GitOps for desired state, and backup tools for runtime/resource recovery. Combine these with cross-region replication and strong DR runbooks.

⚙️ **Primary tools & roles**

* **Terraform / CloudFormation / CDK** — manage and version infrastructure (VPC, EKS cluster, node groups) reliably.
* **GitOps (ArgoCD / Flux)** — maintain and reconcile Kubernetes manifests (desired cluster state).
* **Velero** — backup/restore Kubernetes cluster resources and PV snapshots.
* **AWS Backup / EBS snapshots** — provider-native backup for volumes, RDS, maybe EFS.
* **ECR replication** — replicate images cross-region.
* **S3 + Athena / Glacier** — archive logs and backups.
* **Monitoring & Alerts** — CloudWatch, Prometheus + Alertmanager for DR detection.
* **Drill automation** — runbooks via scripts/Playbooks (Ansible, runbooks in docs) and automation for recovery steps.

🧩 **Recommended stack**

* Infra: Terraform (state in remote backend like S3 + locking via DynamoDB).
* Cluster state: GitOps (ArgoCD) — your Git repo is the source of truth.
* Backups: Velero + AWS Backup (for EBS/RDS/EFS).
* Image registry: ECR with cross-region replication.
* Secrets: AWS Secrets Manager + External Secrets or SOPS for Git-managed secrets.

📋 **DR responsibilities table**

| Responsibility                | Tool                                       |
| ----------------------------- | ------------------------------------------ |
| Infrastructure reprovisioning | Terraform / CloudFormation                 |
| Kubernetes desired state      | ArgoCD / Flux (Git)                        |
| Resource + PV backups         | Velero                                     |
| Snapshot backups              | AWS Backup (EBS, RDS, EFS)                 |
| Image availability            | ECR replication                            |
| Secrets restore               | Secrets Manager replication / SOPS reapply |

✅ **Best Practices**

* Keep Terraform state secure and backed up; replicate state to another region/account if needed.
* Keep a fully reproducible Git repo (manifests + Helm values) as the “golden copy”.
* Automate DR runbooks to spin up infra + GitOps sync to rehydrate clusters.
* Maintain immutable images in ECR with replication enabled.
* Run scheduled DR failover tests and update playbooks.

💡 **In short**
Use Terraform + GitOps (ArgoCD/Flux) as the primary state control plane, Velero/AWS Backup for backups, and automate DR drills — your Git + IaC are your fastest path to recovery.

---

## Q122: How do you implement infrastructure as code for EKS using Terraform or CloudFormation?

🧠 **Overview**
Use IaC to provision EKS consistently and reproducibly. Terraform offers modular, multi-cloud-friendly workflows while CloudFormation (or CDK) is AWS-native and integrates tightly with AWS services.

⚙️ **Purpose / How it works**

* Define EKS cluster, node groups, VPC, IAM roles, Security Groups, and add-ons as code.
* Store state remotely (Terraform: S3 + DynamoDB locking; CloudFormation: managed).
* Use modules (Terraform) or nested stacks (CloudFormation) to standardize patterns.

🧩 **Terraform example (brief)**

```hcl
# main.tf — minimal EKS using aws_eks_cluster and aws_eks_node_group
provider "aws" { region = "ap-south-1" }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 3.0"
  name = "eks-vpc"
  cidr = "10.0.0.0/16"
  azs  = ["ap-south-1a","ap-south-1b"]
  public_subnets  = ["10.0.0.0/24","10.0.1.0/24"]
  private_subnets = ["10.0.2.0/24","10.0.3.0/24"]
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "prod-eks"
  cluster_version = "1.27"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  node_groups = {
    default = {
      desired_capacity = 3
      instance_types   = ["t3.medium"]
    }
  }
}
```

* State backend:

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "eks/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "tf-locks"
  }
}
```

🧩 **CloudFormation snippet (AWS::EKS::Cluster)**

```yaml
Resources:
  EKSCluster:
    Type: AWS::EKS::Cluster
    Properties:
      Name: prod-eks
      RoleArn: !GetAtt EKSClusterRole.Arn
      ResourcesVpcConfig:
        SubnetIds:
          - subnet-aaaa
          - subnet-bbbb
```

**CDK alternative**

* Use AWS CDK to synthesize CloudFormation with higher-level constructs and patterns.

📋 **Comparison table**

| Concern                |              Terraform | CloudFormation / CDK                            |
| ---------------------- | ---------------------: | ----------------------------------------------- |
| Multi-cloud            |                      ✅ | ❌ (AWS only)                                    |
| Community modules      | ✅ (Terraform Registry) | Limited                                         |
| Native AWS integration |                Partial | ✅                                               |
| State management       |          S3 + DynamoDB | Managed (stack)                                 |
| Learning curve         |             Low-medium | Low for CloudFormation, higher for CDK patterns |

✅ **Best Practices**

* Use **modules** (Terraform) or constructs (CDK) to standardize cluster creation.
* Keep state remote with locking and encryption.
* Use variables/overlays for environment-specific config.
* Automate IaC runs in CI with plan → approve → apply.
* Keep secrets out of code (use SSM/Secrets Manager or encrypted vars).
* Test IaC in non-prod and run `terraform fmt`/`validate`/`plan` in CI.

💡 **In short**
Use Terraform modules (or CDK/CloudFormation) to declare VPC, EKS, node groups, and IAM; store state remotely, modularize patterns, and run IaC via CI for repeatable, auditable infrastructure.

---
## Q123: What strategies would you use for managing multiple EKS environments (dev, staging, prod)?

🧠 **Overview**
Manage environments with reproducible IaC, GitOps, and isolation boundaries so dev/staging/prod are consistent but cost-optimized. Use environment-specific overlays, CI pipelines, and policy gates to move changes safely between environments.

⚙️ **Purpose / How it works**

* **Isolation**: each environment in separate AWS account or separate cluster/namespace depending on required isolation.
* **Reproducibility**: same Terraform/Helm manifests with parameterized values per environment.
* **Promotion pipeline**: CI builds → image pushed → manifest update in `dev` repo → promote to `staging` → `prod` via PRs or automated approvals.
* **Policy control**: Gatekeeper/OPA, PSS, and automated tests in pipeline to ensure safe promotion.

🧩 **Examples / Commands / Config snippets**

* **Git repo layout (recommended)**

```
infra/
  eks/           # Terraform modules
  modules/
apps/
  service-a/
    charts/
envs/
  dev/           # Helm values / kustomize overlays
  staging/
  prod/
```

* **Terraform workspace example**

```bash
terraform workspace new dev
terraform workspace new prod
```

* **ArgoCD Application per env**

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata: { name: myapp-dev }
spec:
  source:
    repoURL: git@github.com:org/apps.git
    path: envs/dev/service-a
  destination:
    server: https://kubernetes.default.svc
    namespace: service-a
```

📋 **Environment isolation patterns**

| Isolation Level                       |   Cost | Use case                          |
| ------------------------------------- | -----: | --------------------------------- |
| Namespace-per-env (single cluster)    |    Low | Small teams, dev/test             |
| Cluster-per-env (same AWS account)    | Medium | Clear failure-domain separation   |
| Account-per-env (cluster-per-account) |   High | Strong security/compliance (prod) |

✅ **Best Practices**

* Use **one IaC module** and environment-specific variables (no copy/paste).
* Use **GitOps** for deployment (ArgoCD/Flux) and protect `prod` branch (PR + approvals).
* Automate smoke/integration tests in staging before prod promotion.
* Enforce policies (OPA/Gatekeeper) and PSS per environment.
* Use cost controls for dev (scale-to-zero, smaller nodes, Spot).

💡 **In short**
Standardize manifests + GitOps, isolate by namespace/cluster/account based on risk, and automate promotion with CI gates and policy checks.

---

## Q124: How would you implement environment parity while minimizing cost?

🧠 **Overview**
Aim for *behavioral parity* (same code paths, same infra components) while using scaled-down resources for lower environments to save cost.

⚙️ **Purpose / How it works**

* Keep **same topology** (same services, same add-ons) but **different sizes** (smaller instance types, fewer replicas).
* Use **feature toggles** and test data that exercise production code paths.
* Use **ephemeral environments** for integration/PR testing and scale-to-zero for dev.

🧩 **Techniques / Examples**

* **Same Helm chart, different values**:

```bash
helm upgrade --install svc ./chart -f values-prod.yaml   # prod
helm upgrade --install svc ./chart -f values-dev.yaml    # dev (smaller CPU/mem)
```

* **Scale-to-zero dev workloads** (KEDA or custom controller).
* **Ephemeral preview environments** spun up per PR (GitHub Actions -> create namespace + deploy).
* **Use Spot for non-critical envs** and autoscale with Karpenter/CA.

📋 **Trade-offs table**

| Parity Type                | Cost Impact | Implementation                          |
| -------------------------- | ----------: | --------------------------------------- |
| Exact infra parity         |        High | Same instance types & counts            |
| Behavioral parity          |  Low-Medium | Same services and config, smaller sizes |
| Functional parity (subset) |         Low | Only critical components mirrored       |

✅ **Best Practices**

* Keep **production-like configs** for integration tests (e.g., same DB schema, same feature flags) but use smaller capacity.
* Use **data sampling or masked production copies** rather than full datasets.
* Automate ephemeral environments for PR validation and destroy them after tests.
* Use **service virtualization** for expensive dependencies.

💡 **In short**
Match architecture and behavior across envs but right-size resources, use ephemeral instances, Spot capacity, and automated PR environments to reduce cost.

---

## Q125: How do you handle certificate management and rotation in EKS?

🧠 **Overview**
Automate TLS lifecycle — issuance, renewal, rotation — using cert-manager (ACME, AWS ACM, Vault) and IRSA for cloud integrations. Ensure secrets rotation is safe (rolling restarts, no downtime).

⚙️ **Purpose / How it works**

* **Ingress/Service certificates**: cert-manager issues/renews certs via ACME (Let's Encrypt) or integrates with AWS ACM PCA.
* **mTLS / service certs**: managed by service mesh (Istio/Linkerd) auto-rotates sidecar certs.
* **Secrets rotation**: use Secrets Store CSI / External Secrets to refresh rotated certs into pods and trigger safe reloads.

🧩 **Commands / Config snippets**

* **Install cert-manager**

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.crds.yaml
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace
```

* **ClusterIssuer (ACME example)**

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata: { name: letsencrypt-prod }
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: ops@example.com
    privateKeySecretRef: { name: le-prod-key }
    solvers:
      - http01:
          ingress:
            class: nginx
```

* **Certificate for Ingress**

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
spec:
  secretName: app-tls
  dnsNames: ["app.example.com"]
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
```

📋 **Rotation strategies**

| Type            | Rotation method                                                   |
| --------------- | ----------------------------------------------------------------- |
| Ingress TLS     | cert-manager automatic renewals; hot reload by ingress controller |
| Service mTLS    | Mesh-managed auto-rotation (Istio)                                |
| App-level certs | Secrets Store CSI + app SIGHUP on file update                     |

✅ **Best Practices**

* Use cert-manager + ACME for public TLS or ACM PCA for private CA.
* Automate renewals and monitor expiry with alerts.
* Use **zero-downtime** cert rotation: update secret and let controllers reload config; avoid manual restarts.
* Store private keys in Secrets Manager or KMS-encrypted Kubernetes Secrets (with encryption at rest).
* Use short-lived certs where possible (mesh-managed) and rotate frequently.

💡 **In short**
Automate issuance & renewals with cert-manager or mesh CA, store keys securely, and use CSI/ExternalSecrets for safe, automated rotation without downtime.

---

## Q126: What strategies would you use for implementing external DNS in EKS?

🧠 **Overview**
External DNS automates DNS records (Route53) for Kubernetes Services/Ingresses so application DNS matches deployed resources. Use the ExternalDNS controller with proper IAM/IRSA permissions.

⚙️ **Purpose / How it works**

* ExternalDNS watches Ingress/Service/IngressRoute resources and creates/updates Route53 records using AWS API.
* Use hostname annotations to specify DNS names and TTL.

🧩 **Install & Example**

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install external-dns bitnami/external-dns \
  --set provider=aws \
  --set aws.region=ap-south-1 \
  --set txtOwnerId=cluster-prod
```

* **Ingress annotation**

```yaml
metadata:
  annotations:
    external-dns.alpha.kubernetes.io/hostname: app.example.com.
```

* **IRSA policy (minimal)**

```json
{
  "Effect": "Allow",
  "Action": [
    "route53:ChangeResourceRecordSets",
    "route53:ListHostedZones",
    "route53:ListResourceRecordSets"
  ],
  "Resource": ["*"]
}
```

📋 **Patterns / Options**

| Pattern                                   | When to use                           |
| ----------------------------------------- | ------------------------------------- |
| ExternalDNS (Route53)                     | Auto-management of public/private DNS |
| Route53 Resolver + conditional forwarding | Hybrid DNS with on-prem               |
| ExternalDNS + Private Hosted Zones        | Services accessible only inside VPC   |

✅ **Best Practices**

* Use **IRSA** with least-priv privilege to call Route53.
* Restrict ExternalDNS to specific hosted zones using `--zone-id-filter` or `--domain-filter`.
* Use TXT ownership (`--txt-owner-id`) to avoid record conflicts.
* Secure DNS updates and audit changes via CloudTrail.
* Use private hosted zones for internal services and Route53 resolver for hybrid DNS.

💡 **In short**
Run ExternalDNS with IRSA to reconcile Service/Ingress hostnames to Route53 records; scope permissions and hosted zones tightly for safety.

---

## Q127: How would you design a multi-account EKS strategy in AWS Organizations?

🧠 **Overview**
Multi-account strategy isolates environments, compliance boundaries, and blast radius. Use AWS Organizations with landing zones (Control, Shared Services, Prod, Non-prod) and centralize common services.

⚙️ **Purpose / How it works**

* **Control account**: centralized IAM, guardrails (SPM), SCPs.
* **Shared services**: logging, CI/CD, artifact registry, security tooling in dedicated account(s).
* **Workload accounts**: each environment (prod/staging/dev) or team has its own account with an EKS cluster(s).
* **Cross-account networking**: Transit Gateway or VPC peering for shared services access.

🧩 **Account topology example**

```
org-root
 ├─ management (billing/Org)
 ├─ security (GuardDuty, Config aggregator)
 ├─ shared-services (CI/CD, logging, ECR, S3)
 ├─ dev-account (EKS clusters)
 ├─ prod-account (EKS clusters)
```

📋 **IAM & Access patterns**

* Use IAM Identity Center / SSO for cross-account user access.
* Use cross-account roles (assume-role) and IRSA for cross-account pod access when needed.

✅ **Best Practices**

* Use **SCPs** to enforce organization-wide guardrails (e.g., no public S3).
* Centralize logging & monitoring to a dedicated account (CloudWatch/Elasticsearch).
* Centralize CI/CD in Shared Services but deploy to workload accounts via cross-account roles or ArgoCD agents.
* Automate account provisioning (Control Tower, Landing Zone, or Terraform AWS org modules).
* Tag and label resources consistently for cost allocation.

💡 **In short**
Use Organizations with dedicated management/shared/workload accounts, centralize common services, enforce guardrails with SCPs, and automate account provisioning for consistent, secure multi-account EKS deployments.

---

## Q128: How do you implement cross-account access for EKS resources?

🧠 **Overview**
Cross-account access is done via IAM roles with `sts:AssumeRole`. For Kubernetes admin access, map the AWS role to Kubernetes RBAC via `aws-auth` or GitOps controllers; for API access to AWS services from pods, use IRSA with roles in the target account (trust relationships).

⚙️ **Purpose / How it works**

* **Human/operator access**: user assumes role in target account → kubeconfig points to cluster with role-based mapping.
* **CI/CD or controllers**: use cross-account IAM roles or agents in shared services that assume roles in workload accounts.
* **Pod access to other account resources**: create an IRSA role in the workload account that trusts OIDC and has a trust policy to assume cross-account role, or allow role chaining.

🧩 **Example: cross-account assume-role (operator)**

* **Target account role** (trusts management account):

```json
{
  "Version": "2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Principal":{"AWS":"arn:aws:iam::MANAGEMENT_ACCT:role/CI_CD_Role"},
      "Action":"sts:AssumeRole"
    }
  ]
}
```

* **Use in CI**:

```bash
aws sts assume-role --role-arn arn:aws:iam::TARGET:role/CI_CD_Role --role-session-name ci-session
export AWS_ACCESS_KEY_ID=...
```

* **Kubernetes RBAC mapping** via `aws-auth` (map role to Kubernetes group):

```yaml
mapRoles:
- rolearn: arn:aws:iam::TARGET:role/CI_CD_Role
  username: ci-cd
  groups:
    - system:masters
```

📋 **Cross-account IRSA pattern**

* Create OIDC provider in target account if not present.
* Create role in target account with trust to OIDC and permissions for AWS resources.
* Annotate ServiceAccount in target cluster with role ARN — pods assume role within that account.

✅ **Best Practices**

* Prefer **role chaining with short-lived creds** (sts:AssumeRole) over long-lived keys.
* Limit permissions to exact resources and use least privilege.
* Audit assume-role activity via CloudTrail.
* For GitOps, use **ArgoCD cluster agents** in each account or central ArgoCD with multi-cluster credentials managed via cross-account roles.
* Automate trust policies and role provisioning via IaC.

💡 **In short**
Use `sts:AssumeRole` for human and CI cross-account access; map assumed roles to Kubernetes RBAC via `aws-auth`; use IRSA + cross-account roles for pod-level AWS API access.

---

## Q129: What strategies would you use for implementing service discovery across multiple clusters?

🧠 **Overview**
Multi-cluster service discovery options: DNS-based, service mesh federation, dedicated API gateways, or platform-level solutions (Submariner/Consul). Choose based on latency, security, and topology requirements.

⚙️ **Approaches**

* **DNS + LB**: expose service via internal NLB + Route53 (private hosted zone) and route by DNS to cluster-specific endpoints.
* **Service mesh federation**: Istio/App Mesh/Linkerd federation for cross-cluster name resolution, mTLS, and traffic routing.
* **Network layer**: Submariner or Transit Gateway to bridge pod networks for direct pod-to-pod resolution.
* **API Gateway / Aggregator**: central gateway routes to cluster-local services (good for public APIs).

🧩 **Patterns & Examples**

* **Route53 private DNS**: create `service.internal` record that uses health-checked regional ALBs/NLBs pointing to each cluster.
* **Istio multi-cluster**: configure istiod controlplane peering or multi-primary with remote clusters and use `ServiceEntry` for cross-cluster services.
* **Submariner**: provides L3 connectivity + service discovery across clusters where pod networks are disjoint.

📋 **Comparison table**

| Method                  | Pros                         | Cons                                    |
| ----------------------- | ---------------------------- | --------------------------------------- |
| Route53 + NLB           | Simple, AWS-native           | Not real pod-level discovery            |
| Service mesh federation | mTLS, routing, observability | Operational complexity                  |
| Submariner              | True pod-to-pod connectivity | Networking complexity & ops             |
| API Gateway             | Centralized control          | Single entrypoint; potential bottleneck |

✅ **Best Practices**

* Avoid federating stateful PVs — replicate data instead.
* Use service mesh if you need secure identity & fine-grained routing.
* Use Route53 + NLB for simpler cross-cluster service exposure.
* Keep service discovery consistent and record cluster of origin in metadata for observability.
* Automate configuration via GitOps.

💡 **In short**
Use DNS + NLB for simple cross-cluster exposure, service mesh for secure cross-cluster service-to-service, or Submariner for direct pod networking; choose based on required features and complexity tolerance.

---

## Q130: How would you optimize container image pull times in large EKS clusters?

🧠 **Overview**
Reduce pull latency by minimizing image size, using regional/private registries, pull-through caches, pre-pulling images, node-local registries, and tuning CRI runtime registry mirrors.

⚙️ **Techniques / How it works**

* **Smaller images**: multi-stage builds, minimal base images (distroless, scratch).
* **Immutable tags + layer caching**: push frequently-layered base images and use shared base images.
* **Regional ECR + replication**: enable cross-region replication for ECR to keep images local to clusters.
* **ECR Pull-Through Cache**: mirror public registries into ECR for faster pulls and rate-limiting avoidance.
* **Registry mirrors / containerd config**: configure container runtime to use local mirrors.
* **DaemonSet pre-pull**: proactively pull critical images to nodes on scale-up.
* **Node-local registry / cache**: run a small registry cache (registry:2) on each node or per-AZ to serve pulls locally.
* **ImagePullPolicy**: use `IfNotPresent` for stable images to avoid repeated pulls.
* **Parallel & chunked pulls**: tune kubelet / containerd to maximize parallel downloads.

🧩 **Commands / Examples**

* **ECR lifecycle & replication** (Terraform/ECR console) — enable replication rules across regions.

* **DaemonSet pre-pull example** (simple):

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata: name: prepull
spec:
  template:
    spec:
      containers:
      - name: prepull
        image: amazonlinux
        command: ["sh","-c","docker pull $IMAGE && sleep 3600"]
        env:
        - name: IMAGE
          value: "111122223333.dkr.ecr.ap-south-1.amazonaws.com/app:latest"
```

* **containerd registry mirror (node config)**

```toml
[plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
  endpoint = ["https://my-registry-mirror.local"]
```

📋 **Comparison table**

| Method                 |  Pull speed |   Ops cost | Use case                           |
| ---------------------- | ----------: | ---------: | ---------------------------------- |
| Small images           |        High | Dev effort | Always do                          |
| Regional ECR           |        High |        Low | Multi-AZ, multi-region clusters    |
| ECR pull-through cache |        High |        Low | Avoid Docker Hub rate limits       |
| Pre-pull DaemonSet     | Medium-High |     Medium | Fast startup after scale           |
| Node-local registry    |        High |     Medium | Large clusters with repeated pulls |

✅ **Best Practices**

* Make images **small & layered** for reuse.
* Use **ECR with replication** or **ECR pull-through cache** for public images.
* Pre-pull critical images on node startup or via DaemonSet after scale-up.
* Use **IfNotPresent** policy for immutable tags and avoid unnecessary pulls.
* Monitor pull durations and failed pulls (CloudWatch, kubelet logs) and instrument alerts.

💡 **In short**
Shrink images, keep them close (ECR + replication / pull-through), use runtime mirrors or node-local caches and pre-pull strategies to dramatically reduce startup times at scale.

---

# Troubleshooting / Scenarios

## Q131: Your EKS pods are stuck in "Pending" state. What are the common causes and how would you diagnose?

🧠 **Overview**
Pods stay in *Pending* when the scheduler can't place them on any node. Root causes include capacity shortage, resource requests too high, taints, network/IP exhaustion, missing PVCs, or node pool misconfiguration.

⚙️ **Common Causes**

* **Insufficient CPU/Memory** (resource requests > available).
* **No nodes match selectors / affinity**.
* **Node taints without matching tolerations**.
* **CNI IP exhaustion** (no Pod IPs left).
* **Pending PVC** (StorageClass/PV binding issues).
* **Node group scaling issues** (Cluster Autoscaler blocked).

🧩 **Diagnosis Commands**

```bash
kubectl get pods -A | grep Pending
kubectl describe pod <pod>   # LOOK FOR: 0/xx nodes are available...
kubectl get nodes
kubectl describe node <node>
```

* Check scheduler messages in `kubectl describe pod`:

  * `insufficient cpu` / `insufficient memory`
  * `node(s) had taints`
  * `0/10 nodes available: pod has unbound immediate PersistentVolumeClaims`
  * `node(s) didn't match Pod's node affinity`
* Check **CNI IP**:

```bash
kubectl -n kube-system logs -l k8s-app=aws-node
```

* Check **free IPs**:

```bash
aws ec2 describe-subnets --subnet-ids <id> --query 'Subnets[].AvailableIpAddressCount'
```

📋 **Common root causes vs indicators**

| Symptom in `describe`          | Likely Issue                        |
| ------------------------------ | ----------------------------------- |
| `insufficient cpu`             | Resource too high / nodes too small |
| `unbound immediate PVC`        | Storage misconfigured               |
| `had taints... no tolerations` | Missing tolerations                 |
| `didn't match node selector`   | Selector mismatch                   |
| `failed to assign ip`          | ENI/IP exhaustion                   |

✅ **Best Practices**

* Use smaller resource requests for baseline, use HPA for spikes.
* Ensure matching node groups for GPU/high-memory workloads.
* Enable prefix delegation or add secondary CIDR if IP exhaustion.
* Validate PVC/StorageClass binding in staging.

💡 **In short**
Check pod events → resource requests, taints, affinity rules, PVCs, and subnets for IP capacity. Most Pending pods are caused by lack of scheduling resources or missing PVCs.

---

## Q132: Pods are getting OOMKilled repeatedly. How do you identify the root cause?

🧠 **Overview**
OOMKilled happens when a container exceeds its **memory limit**. Identify memory spikes, leaks, mis-sized limits, or application bugs.

⚙️ **How it works**
Kubelet kills the container when it crosses its memory limit. Examine pod events, container logs, metrics (Prometheus), and memory profiling.

🧩 **Diagnostic Steps**

1. **Check pod events**

```bash
kubectl describe pod <pod> | grep -i oom
kubectl get events --sort-by=.lastTimestamp
```

2. **Check memory usage via `metrics-server` or Prometheus**

```bash
kubectl top pod <pod>
```

3. **Compare requests/limits**

```yaml
resources:
  requests: { memory: "256Mi" }
  limits:   { memory: "256Mi" }
```

If equal, container will be killed on small spikes → increase limit.

4. **Check logs of container right before crash**

```bash
kubectl logs <pod> --previous
```

5. **Identify memory leaks**

* Use profiling tools (JVM heap dump, pprof for Go/Python, Node.js heap snapshots).
* Check Prometheus metrics (`container_memory_working_set_bytes`).

📋 **Root causes**

| Cause                | Indicator                        |
| -------------------- | -------------------------------- |
| Memory leak          | Increasing working set over time |
| Cache/unbounded data | Sudden spikes                    |
| Too low memory limit | Repeated kills under load        |
| Bursty traffic       | OOM during spikes                |

✅ **Best Practices**

* Set **requests < limits** to allow burst headroom.
* Right-size limits using Prometheus/Grafana memory graphs.
* Add liveness & readiness probes to avoid cascading failures.
* Use HPA to scale horizontally under memory-based load.

💡 **In short**
Examine `kubectl describe`, memory metrics, and logs → adjust limits, fix leaks, or scale pods to prevent recurring OOMKills.

---

## Q133: The Cluster Autoscaler is not scaling up despite pending pods. What would you check?

🧠 **Overview**
Cluster Autoscaler (CA) scales nodes when pods can't schedule. If scaling doesn't happen, it's usually due to node group misconfiguration, IAM issues, or CA deciding that adding nodes won’t help.

⚙️ **Checklist**

🧩 **1. CA logs**

```bash
kubectl -n kube-system logs -l app.kubernetes.io/name=cluster-autoscaler
```

Look for:

* `node group min size reached`
* `max size reached`
* `unready node`
* `pod is unschedulable: predicate mismatch`

🧩 **2. Node group capacity**

```bash
aws eks describe-nodegroup ...
```

Check:

* Desired < Max?
* ASG scaling policies overridden? (tag `k8s.io/cluster-autoscaler/enabled` missing)

🧩 **3. ASG Tags**
Must include:

```
k8s.io/cluster-autoscaler/enabled: "true"
k8s.io/cluster-autoscaler/<cluster-name>: "owned"
```

🧩 **4. Permissions (IRSA)**
Cluster Autoscaler needs IAM:

```
autoscaling:DescribeAutoScalingGroups
autoscaling:SetDesiredCapacity
autoscaling:TerminateInstanceInAutoScalingGroup
```

🧩 **5. Pod resource issues**

* If pending pods require GPU or specific instance type **not available**, CA will not scale.
* Pod cannot fit on node-type (too large) → CA won't scale.

🧩 **6. Pod Disruption Budgets / Affinity**

* Anti-affinity may block scheduling.
* PDBs may prevent eviction → CA blocked.

📋 **Common misconfigurations**

| Issue            | Outcome                    |
| ---------------- | -------------------------- |
| Missing ASG tags | CA does nothing            |
| Max size reached | No scale-up                |
| Incorrect IAM    | CA logs permission errors  |
| Pod too big      | CA: “no scale-up possible” |
| IP exhaustion    | Nodes added but no Pod IPs |

✅ **Best Practices**

* Check CA logs first.
* Ensure ASG tags & IRSA permissions.
* Use instanceType lists in node groups.
* Enable Karpenter for quicker provisioning.

💡 **In short**
Inspect CA logs → verify ASG tags, IAM, node group limits, and pod fit. Most scale-up failures come from ASG tag/IAM misconfig or CA deciding no node type can fit the pod.

---

## Q134: Nodes are in "NotReady" state in your EKS cluster. What troubleshooting steps would you take?

🧠 **Overview**
Nodes become NotReady when kubelet can’t report health. Causes include CNI issues, disk pressure, kubelet failure, network misconfig, or IAM/credential problems.

⚙️ **Step-by-step Diagnosis**

🧩 **1. Check node status**

```bash
kubectl describe node <node>
```

Look at:

* `NetworkUnavailable`
* `KernelDeadlock`
* `DiskPressure`
* `MemoryPressure`

🧩 **2. Check kubelet logs**

```bash
journalctl -u kubelet -f   # On the node (SSM Session Manager)
```

🧩 **3. CNI issues**

```bash
kubectl -n kube-system logs -l k8s-app=aws-node
kubectl -n kube-system logs -l app=aws-cni
```

Failures here prevent pods from getting IPs → node NotReady.

🧩 **4. Check node disk**

```bash
df -h
```

If disk full → kubelet marks node NotReady.

🧩 **5. Check network**

* Security groups blocking kubelet → API server communication failures.
* API endpoint not reachable (`curl https://$EKS_ENDPOINT/healthz`).

🧩 **6. Bootstrap/IAM issues**

* Missing IAM role policies for worker nodes:

  * `AmazonEKSWorkerNodePolicy`
  * `AmazonEC2ContainerRegistryReadOnly`
  * `AmazonEKS_CNI_Policy`

🧩 **7. Node lost EC2 instance metadata access**
Check:

```bash
curl http://169.254.169.254/latest/meta-data/
```

📋 **Common root causes**

| Symptom                     | Root Cause                               |
| --------------------------- | ---------------------------------------- |
| DiskPressure=True           | EBS volume full                          |
| kubelet unable to reach API | SG/firewall/VPC routing                  |
| CNI errors                  | ENI/IP exhaustion or misconfig           |
| Node drained                | Administrative action / ASG health check |

✅ **Best Practices**

* Enable node auto-repair via ASG health checks.
* Rotate nodes periodically with managed node groups.
* Monitor node disk, memory, kubelet health.
* Ensure SG rules allow kubelet → API server.

💡 **In short**
Check kubelet, CNI, disk space, network, and IAM role issues. Most NotReady nodes occur from CNI/network faults or kubelet communication failure.

---

## Q135: Your application cannot resolve service DNS names. How would you debug this?

🧠 **Overview**
Service DNS resolution depends on CoreDNS. Failures come from CoreDNS misconfig, kube-proxy issues, network policies, or wrong cluster DNS settings.

⚙️ **Diagnosis Steps**

🧩 **1. Test DNS inside pod**

```bash
kubectl exec -it <pod> -- nslookup my-service.default.svc.cluster.local
```

🧩 **2. Check CoreDNS pods**

```bash
kubectl -n kube-system get pods -l k8s-app=kube-dns
kubectl -n kube-system logs <coredns-pod>
```

Look for:

* Loop detection
* Upstream not reachable
* Plugin errors
* NodeLocal DNS issues

🧩 **3. Validate CoreDNS ConfigMap**

```bash
kubectl -n kube-system get configmap coredns -o yaml
```

🧩 **4. Check kube-proxy**

```bash
kubectl -n kube-system logs -l k8s-app=kube-proxy
```

🧩 **5. Network policies**

* Policies may block DNS (UDP 53) between pods and CoreDNS.

🧩 **6. VPC CNI**

* Ensure CoreDNS pods have IPs and can reach kube-apiserver.

📋 **Common root causes**

| Symptom                 | Root cause                             |
| ----------------------- | -------------------------------------- |
| `SERVFAIL` from CoreDNS | Upstream DNS unreachable               |
| Timeout on DNS          | NetworkPolicies blocking UDP 53        |
| Service not resolvable  | Service not created or wrong namespace |
| `Loop detected` in logs | NodeLocal DNS or upstream misconfig    |

✅ **Best Practices**

* Use NodeLocal DNS for high-scale clusters.
* Keep CoreDNS replicas ≥ 2 across AZs.
* Ensure DNS queries are allowed in network policies.
* Avoid custom resolv.conf overrides unless required.

💡 **In short**
Exec into pod → test DNS → inspect CoreDNS logs/config → check kube-proxy and network policies. Almost always a CoreDNS or network policy issue.

---

## Q136: Pods cannot pull images from ECR with "ImagePullBackOff" error. What would you investigate?

🧠 **Overview**
ImagePullBackOff indicates the container runtime repeatedly failed to pull from ECR. Causes: wrong permissions, missing ECR login, wrong image tag, network restrictions, or throttling.

⚙️ **Troubleshooting checklist**

🧩 **1. Validate image exists**

```bash
aws ecr describe-images --repository-name myrepo --image-ids imageTag=latest
```

🧩 **2. Check ServiceAccount → IRSA role**

* Ensure pod has permission:

```
ecr:GetAuthorizationToken
ecr:BatchGetImage
ecr:GetDownloadUrlForLayer
```

🧩 **3. Node IAM Role**
Nodes must have:

* `AmazonEC2ContainerRegistryReadOnly`

🧩 **4. Check kubelet/container runtime logs on node**

```bash
journalctl -u kubelet -f
```

🧩 **5. DNS / network**

* Check nodes can reach ECR endpoints:

```bash
curl -I https://<aws_account>.dkr.ecr.<region>.amazonaws.com
```

🧩 **6. Image tag mismatch**

* Using `:latest` → cluster may pull stale image or tag not found.

🧩 **7. ECR throttling**
If cluster scales fast, ECR rate limits may block pulls → use pull-through cache or pre-pull.

📋 **Root causes vs indicators**

| Indicator                   | Root Cause                    |
| --------------------------- | ----------------------------- |
| `no basic auth credentials` | Missing IAM/ECR permissions   |
| `manifest unknown`          | Wrong tag                     |
| Timeout                     | Network/VPC endpoints missing |
| Slow pull then fail         | ECR throttling                |

✅ **Best Practices**

* Use IRSA for fine-grained access control.
* Always use immutable tags (SHA).
* Use ECR pull-through cache for public images.
* Pre-pull critical images on node bootstrap.

💡 **In short**
Check IAM (IRSA/node role), image tags, network access to ECR endpoints, and kubelet logs. Most failures are permission or tag mismatches.

---

## Q137: The AWS Load Balancer Controller is not creating ALBs for Ingress resources. What could be wrong?

🧠 **Overview**
If ALBs aren’t created, the Ingress controller likely lacks IAM permissions, Ingress annotations are incorrect, or the controller is not watching the right class or namespace.

⚙️ **Common causes**

🧩 **1. Missing IAM permissions / wrong IRSA**
IAM role must include:

```
"elasticloadbalancing:*"
"ec2:Describe*"
"ec2:CreateSecurityGroup"
```

Check:

```bash
kubectl -n kube-system logs -l app.kubernetes.io/name=aws-load-balancer-controller
```

🧩 **2. IngressClass missing**
Your Ingress must reference correct class:

```yaml
ingressClassName: alb
```

or annotation:

```yaml
kubernetes.io/ingress.class: alb
```

🧩 **3. Missing required annotations**
Example:

```yaml
alb.ingress.kubernetes.io/scheme: internet-facing
alb.ingress.kubernetes.io/target-type: ip
```

🧩 **4. Subnet tagging incorrect**
Subnets must have:

```
kubernetes.io/role/elb: "1"              # public
kubernetes.io/role/internal-elb: "1"     # private
```

🧩 **5. Controller not installed correctly**

* Wrong cluster name passed to Helm chart.
* CRDs missing.
  Check:

```bash
kubectl get deployment -n kube-system aws-load-balancer-controller
```

🧩 **6. Conflicting Ingress controllers**
If using NGINX + ALB, ensure correct IngressClass selection.

📋 **Common misconfigurations**

| Symptom                             | Root Cause                     |
| ----------------------------------- | ------------------------------ |
| ALB never appears                   | Wrong IAM or IngressClass      |
| ALB created but not routing         | Wrong target-type or SG config |
| Events: “no suitable subnets found” | Subnet tags missing            |

✅ **Best Practices**

* Install ALB controller via Helm with IRSA.
* Tag subnets explicitly and verify via AWS console.
* Use `kubectl describe ingress` to examine events.
* Use `ingressClassName: alb` instead of old annotation.
* Version-lock controller with IaC.

💡 **In short**
Check IRSA permissions, IngressClass, subnet tags, and controller logs. ALB failures almost always come from IAM or subnet tagging issues.

---

## Q138: Pods are experiencing intermittent network connectivity issues. How would you troubleshoot?

🧠 **Overview**
Intermittent network issues typically relate to CNI problems, ENI/IP exhaustion, DNS instability, NetworkPolicies, kube-proxy issues, or underlying VPC routing/Security Groups.

⚙️ **Troubleshooting Steps**

🧩 **1. Check CNI (AWS VPC CNI) logs**

```bash
kubectl -n kube-system logs -l k8s-app=aws-node
```

Look for:

* `failed to assign ip`
* ENI attachment errors
* `failed to set up pod ENI`

🧩 **2. Validate Pod-to-Pod connectivity**

```bash
kubectl exec -it <pod> -- curl http://<other-pod>
```

🧩 **3. Test DNS (CoreDNS)**

```bash
kubectl exec -it <pod> -- nslookup kubernetes.default
kubectl -n kube-system logs -l k8s-app=kube-dns
```

🧩 **4. Check NetworkPolicies**

* Ensure traffic is not being dropped by overly restrictive policies.

🧩 **5. Check kube-proxy**

```bash
kubectl -n kube-system logs -l k8s-app=kube-proxy
```

Look for conntrack, iptables programming errors.

🧩 **6. Check ENI/IP availability**

```bash
aws ec2 describe-subnets --subnet-ids ... --query 'Subnets[].AvailableIpAddressCount'
```

Low IP count → intermittent assignment failures.

🧩 **7. Check node-level connectivity**
Use SSM → check routes & SGs:

```bash
ip route
curl https://google.com
```

📋 **Common root causes**

| Symptom           | Root Cause                                           |
| ----------------- | ---------------------------------------------------- |
| Random failures   | Conntrack table exhaustion                           |
| DNS intermittency | CoreDNS overloaded / NetworkPolicies blocking UDP 53 |
| Sudden spikes     | ENI/IP exhaustion                                    |
| Connection reset  | kube-proxy or MTU mismatch                           |

✅ **Best Practices**

* Enable **prefix delegation** to avoid IP shortages.
* Scale CoreDNS appropriately (HPA) and consider NodeLocal DNS.
* Increase conntrack limits on nodes (`net.netfilter.nf_conntrack_max`).
* Validate MTU settings when using service mesh or overlay modes.

💡 **In short**
Check CNI logs, DNS, NetworkPolicies, kube-proxy, and VPC IP capacity. Most intermittent issues correlate with CNI/ENI/IP exhaustion or DNS problems.

---

## Q139: Your EKS cluster has run out of IP addresses. What solutions would you implement?

🧠 **Overview**
IP exhaustion happens when subnets or ENI/IP capacity are fully consumed. Mitigation involves increasing IP supply or using more efficient CNI allocation modes.

⚙️ **Solutions**

🧩 **1. Enable AWS VPC CNI Prefix Delegation (recommended)**

```bash
kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true
```

* Dramatically increases Pod IP density per node.

🧩 **2. Add secondary CIDR to VPC**

```bash
aws ec2 associate-vpc-cidr-block \
  --vpc-id vpc-xxxx \
  --cidr-block 100.64.0.0/16
```

* Add new subnets → update nodegroups to use them.

🧩 **3. Increase subnet size**

* Replace /24 with /20 or /16 → requires re-creation if resizing not possible.

🧩 **4. Add new nodegroups in additional subnets**

* More subnets = more IP pools for pods.

🧩 **5. Reduce pod IP usage**

* Use fewer replicas or consolidate low-utilization apps.
* Use virtual-kubelet/Fargate for bursty workloads.

🧩 **6. Switch to IPv6 (optional for long-term scale)**

* EKS supports dual-stack IPv4/IPv6.

📋 **When to use what**

| Situation                  | Fix                   |
| -------------------------- | --------------------- |
| Node ENI/IP limits reached | Prefix delegation     |
| VPC CIDR exhausted         | Secondary CIDR        |
| Subnet too small           | Expand/replace subnet |
| Extreme scale              | IPv6 or multi-cluster |

✅ **Best Practices**

* Monitor IP usage (CNI metrics).
* Plan subnet sizing early.
* Automate subnet creation via Terraform.
* Use larger instance types for higher ENI/IP capacity.

💡 **In short**
Enable prefix delegation, expand VPC CIDRs/subnets, or add more subnets/nodegroups. IP exhaustion is solved by increasing IP supply or improving IP efficiency.

---

## Q140: HPA is not scaling pods despite high CPU utilization. What would you check?

🧠 **Overview**
HPA relies on metrics from the `metrics-server` or custom metrics provider. If scaling doesn’t occur, the cause is usually missing metrics, misconfigured target, or low resource requests.

⚙️ **Troubleshooting Steps**

🧩 **1. Check HPA status**

```bash
kubectl describe hpa <name>
```

Look for:

* `unable to get metrics`
* `failed to compute desired number of replicas`

🧩 **2. Verify metrics-server**

```bash
kubectl get deployment -n kube-system metrics-server
kubectl logs -n kube-system deploy/metrics-server
```

🧩 **3. Check resource requests**
If CPU **requests** are too high or too low, autoscaler may not scale.

🧩 **4. Ensure containers have CPU requests set**
HPA works on **requests**, not absolute CPU usage:

```yaml
resources:
  requests:
    cpu: 100m
```

🧩 **5. Confirm target average utilization matches**
Example:

```yaml
metrics:
- type: Resource
  resource:
    name: cpu
    target:
      type: Utilization
      averageUtilization: 70
```

🧩 **6. Check throttling**
If CPU throttled due to low limits, measured usage may be inaccurate.

🧩 **7. Check no conflicting PDB or deployment issues**
Pods may not scale due to maxUnavailable or PDB limitations.

📋 **Common root causes**

| Symptom                  | Root Cause                    |
| ------------------------ | ----------------------------- |
| HPA cannot fetch metrics | metrics-server broken         |
| CPU always 0m            | missing CPU requests          |
| High CPU but no scaling  | limits/request mismatch       |
| Scaling delayed          | stabilization window too long |

✅ **Best Practices**

* Always set `requests` for CPU.
* Ensure metrics-server is functional.
* Tune HPA stabilization and cooldown periods.
* Use custom metrics (Prometheus Adapter) if CPU alone isn’t representative.

💡 **In short**
Check HPA status, metrics-server, CPU requests, and throttling. HPA fails mainly when metrics can’t be retrieved or requests are misconfigured.

---

## Q141: A deployment rollout is stuck and not progressing. How would you resolve this?

🧠 **Overview**
Stuck rollouts occur when new pods fail readiness, required replicas never become ready, or update strategies are blocked.

⚙️ **Troubleshooting Steps**

🧩 **1. Check rollout status**

```bash
kubectl rollout status deployment/<name>
```

🧩 **2. Describe the ReplicaSet & Pods**

```bash
kubectl describe pod <pod>
```

Look for:

* Readiness probe failing
* Image pull errors
* PVC pending
* CrashLoopBackOff

🧩 **3. Events on Deployment**

```bash
kubectl describe deployment <name>
```

🧩 **4. Check strategy settings**
Example maxUnavailable=0 → rollout may block:

```yaml
strategy:
  rollingUpdate:
    maxUnavailable: 0
    maxSurge: 1
```

🧩 **5. Verify resource limits**
Pods may be pending → rollout stuck.

🧩 **6. Check PDBs**
If PDB prevents disruption, old pods cannot be terminated → rollout halted.

🧩 **7. Force rollback or restart**

```bash
kubectl rollout undo deployment/<name>
kubectl rollout restart deployment/<name>
```

📋 **Common root causes**

| Symptom              | Root Cause                                 |
| -------------------- | ------------------------------------------ |
| New pods never ready | bad image, failing probes                  |
| Pods pending         | low resources, wrong node selectors/taints |
| No pods terminate    | PDB blocks rollout                         |
| Rollout stuck at 1/3 | readiness gates never satisfied            |

✅ **Best Practices**

* Implement liveness + readiness probes correctly.
* Avoid overly strict PDBs.
* Use `maxUnavailable: >0` for flexibility.
* Test readiness behavior in staging before prod rollout.

💡 **In short**
Inspect pod readiness, PDBs, rollout strategy, image validity, and resource scheduling. Most stuck rollouts come from readiness probe failures or PDB constraints.

---

## Q142: Pods cannot assume IAM roles despite IRSA being configured. What would you verify?

🧠 **Overview**
IRSA depends on an OIDC provider, correct IAM trust policy, ServiceAccount annotation, and no conflicting credentials. Failure happens due to misconfigured trust relationships or missing token files.

⚙️ **Verification Checklist**

🧩 **1. Check OIDC provider for cluster**

```bash
aws eks describe-cluster --name <cluster> --query "cluster.identity.oidc.issuer"
aws iam list-open-id-connect-providers
```

🧩 **2. Verify IAM role trust policy**
Trust must match OIDC provider:

```json
"Principal": {
  "Federated": "arn:aws:iam::<ACCOUNT>:oidc-provider/oidc.eks.<region>.amazonaws.com/id/<provider-id>"
},
"Condition": {
  "StringEquals": {
    "oidc.eks.<region>.amazonaws.com/id/<provider-id>:sub": "system:serviceaccount:<ns>:<sa>"
  }
}
```

🧩 **3. Confirm ServiceAccount annotation**

```yaml
metadata:
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::<ACCOUNT>:role/<IRSA-Role>
```

🧩 **4. Check token volume & audience**

```bash
kubectl exec <pod> -- ls /var/run/secrets/eks.amazonaws.com/serviceaccount
```

🧩 **5. Check app environment**
Look for env variables overriding credentials:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`

These override IRSA → pod won’t use role.

🧩 **6. Check STS calls inside pod**

```bash
kubectl exec <pod> -- aws sts get-caller-identity
```

🧩 **7. Verify IAM role permissions**

* Includes required ECR/S3/DynamoDB actions.

📋 **Common failures**

| Symptom                  | Root cause                                |
| ------------------------ | ----------------------------------------- |
| `InvalidIdentityToken`   | Trust policy mismatch / wrong issuer URL  |
| Pod still uses node role | Missing SA annotation or legacy creds set |
| STS timeout              | Network/VPC endpoints missing for STS     |

✅ **Best Practices**

* Never hardcode AWS credentials in env vars for IRSA pods.
* Use Terraform modules that auto-generate correct trust relationships.
* Validate with `aws sts get-caller-identity` after deployment.
* Ensure STS endpoint reachable (VPC endpoint if using private-only nodes).

💡 **In short**
Verify OIDC provider, trust policy, ServiceAccount annotation, and that no static AWS credentials override IRSA. Most IRSA failures come from trust policy mismatches.

---

## Q143: Services of type LoadBalancer are not creating ELBs. What would you troubleshoot?

🧠 **Overview**
EKS uses the AWS cloud provider integration to provision ELBs for `Service type=LoadBalancer`. Failures are usually tied to IAM, subnet tagging, controller issues, or unsupported configs.

⚙️ **Troubleshooting Checklist**

🧩 **1. Verify Service annotations & type**

```bash
kubectl get svc <svc> -o yaml
```

Check:

```yaml
spec:
  type: LoadBalancer
```

Required AWS annotations for NLB/CLB:

```yaml
service.beta.kubernetes.io/aws-load-balancer-type: nlb
```

🧩 **2. Check AWS subnet tagging**
Subnets must be tagged:

**Public LB**

```
kubernetes.io/role/elb = 1
```

**Internal LB**

```
kubernetes.io/role/internal-elb = 1
```

🧩 **3. IAM permissions**
Node IAM role must have:

* `AmazonEKSWorkerNodePolicy`
* `AmazonEC2ContainerRegistryReadOnly`
* `AmazonEKS_CNI_Policy`
* Cloud provider controller permissions (for older clusters)

🧩 **4. Controller logs**

```bash
kubectl -n kube-system logs -l k8s-app=cloud-controller-manager
```

🧩 **5. VPC configuration**

* Mixed subnet types
* Wrong routing tables
* No free IPs in subnets for LB resources

🧩 **6. Ensure Service is not using conflicting annotations**
Incorrect annotations can suppress LB creation.

📋 **Common root causes**

| Symptom                          | Root cause                |
| -------------------------------- | ------------------------- |
| No subnets detected              | Missing subnet tags       |
| “Unsupported load balancer type” | Wrong annotations         |
| LB created but not assigned      | Wrong SG or IP exhaustion |

✅ **Best Practices**

* Tag subnets explicitly.
* Use NLB for better performance + stability.
* Use AWS Load Balancer Controller for ALB-based ingress instead.

💡 **In short**
Check subnet tags, IAM, service annotations, and controller logs. 90% of failures are subnet-tag or annotation problems.

---

## Q144: Your EKS nodes are running out of disk space. How would you diagnose and fix this?

🧠 **Overview**
Node disk pressure causes NotReady states, pod eviction, and slow performance. Causes include container logs, image cache growth, unused volumes, or application writing excessively to node FS.

⚙️ **Diagnosis**

🧩 **1. SSH/SSM into node**

```bash
df -h
du -sh /var/lib/containerd
du -sh /var/log
```

🧩 **2. Check container logs**
Logs accumulate under:

```
/var/log/pods/
```

🧩 **3. Check container image cache**

```bash
crictl images
```

Large unused images fill disk.

🧩 **4. Check ephemeral directories**

* `/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs`
* `/var/lib/kubelet/pods/*/*`

🧩 **5. Check pod logs for noisy writers**
Apps writing heavily to stdout or `/tmp` fill node disk.

⚙️ **Fixes**

🧩 **1. Prune unused images**

```bash
crictl rmi --prune
```

🧩 **2. Rotate logs**
Enable log rotation:

```
/etc/logrotate.d/docker-containers
```

🧩 **3. Increase disk size**
Modify Launch Template → scale node group → new nodes replace old ones.

🧩 **4. Use larger root volumes**
Terraform example:

```hcl
root_volume_size = 100
```

🧩 **5. Move heavy writes to PVs**
Use EBS/EFS instead of node FS.

📋 **Common root causes**

| Issue                | Root Cause                      |
| -------------------- | ------------------------------- |
| Huge `/var/log/pods` | Excessive app logs              |
| Huge overlayfs dirs  | Image layer buildup             |
| NodePressureEviction | Disk usage > eviction threshold |

✅ **Best Practices**

* Set log rotation.
* Use 50–100 GB node root volumes for production.
* Regularly prune container images.
* Use ephemeral-storage resource limits.

💡 **In short**
Check disk usage under containerd, logs, and overlays. Fix via pruning, larger root volumes, log rotation, and redirect heavy writes to PVs.

---

## Q145: Pods are being evicted with "The node was low on resource: ephemeral-storage". What's the solution?

🧠 **Overview**
Ephemeral storage is disk usage on the node for container logs, cache, `/tmp`, and overlay filesystem. Eviction occurs when usage exceeds thresholds.

⚙️ **How to fix**

🧩 **1. Inspect pod-level ephemeral storage usage**

```bash
kubectl describe pod <pod>
```

🧩 **2. Set ephemeral-storage requests/limits**

```yaml
resources:
  requests:
    ephemeral-storage: "1Gi"
  limits:
    ephemeral-storage: "2Gi"
```

🧩 **3. Reduce log noise**

* Avoid massive stdout logging.
* Implement log rotation.

🧩 **4. Externalize temp data**

* Move app data to EBS/EFS volumes.

🧩 **5. Increase node disk size**
Replace node group root disks with larger EBS volumes.

🧩 **6. Clean up unused images / logs on nodes**
Use cron or daemonset-based cleanup.

📋 **Root causes vs Indicators**

| Indicator                  | Cause               |
| -------------------------- | ------------------- |
| `/var/lib/containerd` huge | Image layer cache   |
| `/var/log/pods` huge       | Application logs    |
| EKS NodePressureEviction   | NodeStoragePressure |

✅ **Best Practices**

* Always set ephemeral-storage limits for apps.
* Use managed log solutions (CloudWatch agent / Fluent Bit).
* Use bigger root disks for nodes.

💡 **In short**
Right-size ephemeral-storage, reduce log/tmp usage, move app data to PVs, and increase disk size to avoid eviction.

---

## Q146: CoreDNS pods are crashlooping in your cluster. What would you investigate?

🧠 **Overview**
CoreDNS crashes break internal DNS. Causes include bad ConfigMap, insufficient resources, node-local DNS issues, plugin misconfig, or CNI network problems.

⚙️ **Troubleshooting**

🧩 **1. Check logs**

```bash
kubectl -n kube-system logs <coredns-pod>
```

Look for:

* `plugin/loop`
* `no upstream resolvers`
* `failed to load zone`
* segmentation faults (OOM)

🧩 **2. Check CoreDNS ConfigMap**

```bash
kubectl -n kube-system get configmap coredns -o yaml
```

Common misconfigs:

* Wrong upstream DNS
* Looping config (e.g., forwarding to itself)

🧩 **3. Check pod resource limits**
Increase:

```yaml
resources:
  limits:
    cpu: 200m
    memory: 200Mi
```

🧩 **4. Check CNI & networking**

* CoreDNS requires cluster DNS IP reachable from nodes.
* ENI/IP exhaustion may cause container startup failures.

🧩 **5. NodeLocal DNSCache issues**

* If NodeLocal DNSCache enabled, ensure `nodelocaldns` iptables rules are correct.

🧩 **6. Check RBAC for CoreDNS**
Incorrect RBAC can cause boot failures.

📋 **Common CoreDNS crash reasons**

| Message          | Cause                          |
| ---------------- | ------------------------------ |
| `plugin/loop`    | Misconfigured forwarders       |
| OOMKilled        | Low memory limit               |
| Timeout upstream | VPC DNS endpoint unreachable   |
| Segfault         | Image mismatch / version issue |

✅ **Best Practices**

* Keep CoreDNS replicas ≥ 2 across AZs.
* Validate ConfigMap after upgrades.
* Use NodeLocal DNS for large clusters.
* Monitor CoreDNS latency.

💡 **In short**
Inspect logs, ConfigMap, resources, CNI health, and upstream DNS. Most CoreDNS crashes come from bad forwarding configs or resource starvation.

---

## Q147: Network policies are not blocking traffic as expected. How would you debug this?

🧠 **Overview**
NetworkPolicies require a **policy-aware CNI** (e.g., Calico, Cilium). AWS VPC CNI **does NOT enforce NetworkPolicies** alone. Misconfigs or missing selectors also cause enforcement gaps.

⚙️ **Debugging Checklist**

🧩 **1. Verify policy enforcement support**

```bash
kubectl -n kube-system get pods | grep calico
```

If only AWS VPC CNI is installed, policies **will not work**.

🧩 **2. Check policy selectors**

```yaml
spec:
  podSelector:
    matchLabels:
```

If selectors don’t match pods → policy ineffective.

🧩 **3. Confirm namespace selection**

```yaml
namespaceSelector:
```

🧩 **4. Order & deny rules**
NetworkPolicies are **default allow** unless a default deny policy is configured.

🧩 **5. Test with ephemeral pod**

```bash
kubectl run tmp --rm -it --image=busybox -- sh
wget http://<target-pod>
```

🧩 **6. Check calico/cilium logs**

```bash
kubectl -n kube-system logs <calico-node>
```

📋 **Common issues**

| Issue                              | Root Cause                  |
| ---------------------------------- | --------------------------- |
| Policy defined but no effect       | AWS CNI (no enforcement)    |
| Ingress blocked but egress allowed | Policy missing egress rules |
| Doesn’t match pods                 | Wrong labels                |

✅ **Best Practices**

* Use Calico or Cilium for real NetworkPolicies.
* Always create a **default deny** baseline.
* Standardize labels for policy targeting.
* Test policies in staging using connectivity tooling (e.g., `kubectl-debug`).

💡 **In short**
NetworkPolicies only work with Calico/Cilium, not AWS CNI. Validate selectors and define default-deny policies to enforce correctly.

---

## Q148: Your EKS cluster upgrade failed midway. How would you recover?

🧠 **Overview**
Mid-upgrade failures can leave control plane, node groups, or add-ons in inconsistent states. Recovery involves stabilizing the control plane, fixing add-ons, then upgrading nodes safely.

⚙️ **Recovery Steps**

🧩 **1. Check control plane status**

```bash
aws eks describe-cluster --name <cluster>
```

Look for:

* `ACTIVE`
* `FAILED`
* `UPDATING`

If FAILED → open AWS Support ticket immediately (control plane repair needed).

🧩 **2. Validate cluster add-ons (CNI, kube-proxy, CoreDNS)**

```bash
kubectl get pods -n kube-system
```

Manually upgrade:

```bash
eksctl utils update-kube-proxy
eksctl utils update-aws-node
eksctl utils update-coredns
```

🧩 **3. Re-run upgrade command**

```bash
aws eks update-cluster-version --name <cluster> --kubernetes-version 1.xx
```

🧩 **4. Fix node groups**

* Managed node groups may fail mid-upgrade → reset version:

```bash
aws eks update-nodegroup-version \
  --cluster-name <cluster> \
  --nodegroup-name <ng> \
  --force \
  --version 1.xx
```

🧩 **5. Drain problematic nodes**

```bash
kubectl drain <node> --ignore-daemonsets --force
```

Then cycle them:

```bash
aws autoscaling terminate-instance-in-auto-scaling-group \
  --should-decrement-desired-capacity false
```

🧩 **6. Validate workloads**

* Run health checks, DNS, networking, logging.

📋 **Common upgrade failure causes**

| Symptom             | Root Cause              |
| ------------------- | ----------------------- |
| Control plane stuck | Add-on version mismatch |
| Nodes NotReady      | kubelet mismatch        |
| CoreDNS fails       | ConfigMap incompatible  |
| CNI errors          | aws-node not updated    |

✅ **Best Practices**

* Always upgrade in steps: Control plane → Add-ons → Node groups.
* Use **blue/green node group rollout** instead of in-place upgrades.
* Run cluster conformance tests before/after upgrade.
* Use IaC/GitOps for add-on version pinning to avoid surprises.

💡 **In short**
Check cluster state, repair add-ons, re-run upgrade, then cycle node groups. Most failures relate to missing add-on updates or nodegroup version mismatches.

---

## Q149: Pods in different namespaces cannot communicate despite no network policies. Why?

🧠 **Overview**
If no NetworkPolicies exist, all pod-to-pod traffic **should** be allowed. Communication issues usually originate from DNS, Service misconfiguration, CNI routing, or node-level restrictions—not NetworkPolicies.

⚙️ **Root Causes to Check**

🧩 **1. DNS resolution failure**
Pods use fully qualified names:

```
service.namespace.svc.cluster.local
```

Check:

```bash
kubectl exec -it <pod> -- nslookup service.otherns
```

🧩 **2. Service misconfiguration**

* Wrong port
* Wrong selector → no endpoints
  Check:

```bash
kubectl get svc -n <ns>
kubectl get endpoints -n <ns>
```

🧩 **3. CNI routing issues (AWS VPC CNI)**

* ENI/IP exhaustion
* Mis-tagged subnets
* Routing table inconsistencies
  Check:

```bash
kubectl -n kube-system logs -l k8s-app=aws-node
```

🧩 **4. Security Groups for Pods (SGP)**
If you enabled Security Groups for Pods (SGP), SG rules may block cross-namespace traffic.

🧩 **5. Firewall/NACL blocks**
AWS NACLs or VPC firewalls may block pod networks.

📋 **Common causes**

| Symptom                     | Cause                  |
| --------------------------- | ---------------------- |
| DNS works but no connection | Node SG/NACL blocking  |
| Pod gets no IP              | CNI failing            |
| “No endpoints”              | Wrong service selector |

✅ **Best Practices**

* Verify DNS, service selectors, endpoints.
* Avoid overly restrictive SGs for Pods unless required.
* Use Cilium/Calico for clear network policy enforcement.

💡 **In short**
If NetworkPolicies aren’t used, check DNS, service selectors, CNI routing, and SGs for Pods—those are the real blockers.

---

## Q150: The VPC CNI plugin is showing errors and pods are not getting IPs. What would you check?

🧠 **Overview**
The AWS VPC CNI assigns ENIs & Pod IPs. Failures usually relate to IAM, subnet IP exhaustion, CNI misconfiguration, or prefix-delegation issues.

⚙️ **Troubleshooting Steps**

🧩 **1. Check aws-node logs**

```bash
kubectl -n kube-system logs -l k8s-app=aws-node
```

Look for:

* `failed to assign ip`
* `insufficient ENI capacity`
* `cannot allocate IP`

🧩 **2. Check subnet IP availability**

```bash
aws ec2 describe-subnets --subnet-ids <id> --query 'Subnets[].AvailableIpAddressCount'
```

🧩 **3. Check node IAM role**
Must include:

* `AmazonEKS_CNI_Policy`
* `ec2:CreateNetworkInterface`
* `ec2:AssignPrivateIpAddresses`

🧩 **4. Check ENI limits for instance type**
Example:

```bash
aws ec2 describe-instance-types --instance-types m5.large
```

🧩 **5. Check prefix delegation is enabled**

```bash
kubectl get ds aws-node -n kube-system -o yaml | grep ENABLE_PREFIX_DELEGATION
```

🧩 **6. Check CNI version compatibility**
Mismatch between cluster version and CNI version causes failures.

📋 **Root causes**

| Issue                     | Cause                         |
| ------------------------- | ----------------------------- |
| IP exhaustion             | Small subnets / too many pods |
| ENI not created           | Wrong IAM                     |
| Prefix delegation missing | CNI not updated               |
| CNI race condition        | Version mismatch              |

✅ **Best Practices**

* Use prefix delegation for high density.
* Enlarge subnets or add secondary CIDRs.
* Keep CNI version updated through EKS Add-ons.
* Ensure node IAM is correct for ENI ops.

💡 **In short**
Check CNI logs, IP availability, IAM, ENI limits, and prefix delegation. Almost all IP assignment failures originate from subnet exhaustion or node IAM issues.

---

## Q151: Your application experiences high latency after deploying a service mesh. How do you diagnose?

🧠 **Overview**
Service meshes (Istio, App Mesh, Linkerd) add sidecar proxies, which introduce latency from mTLS, routing rules, retries, and telemetry collection.

⚙️ **Diagnosis Steps**

🧩 **1. Measure baseline vs mesh latency**
Compare application metrics before/after mesh injection.

🧩 **2. Check proxy (Envoy) CPU/memory**

```bash
kubectl top pod <pod>
```

High proxy load → latency.

🧩 **3. Inspect Envoy stats**

```bash
curl localhost:15000/stats
```

Look for:

* retry attempts
* circuit breaker triggered
* upstream connect timeout

🧩 **4. Check mesh configuration**

* Too many retries
* Global mTLS set to STRICT
* Fault injection rules accidentally enabled

🧩 **5. Check MTU issues**
Sidecar overhead can cause fragmentation → latency spikes.

🧩 **6. Check mesh telemetry**
Too many access logs or tracing exports increase latency.

📋 **Common root causes**

| Cause                  | Evidence                                     |
| ---------------------- | -------------------------------------------- |
| Retry storms           | `envoy_cluster_retry.upstream_rq_retry` high |
| mTLS overhead          | CPU spike in proxy containers                |
| Misconfigured timeouts | Requests hanging in proxy                    |
| Tracing overload       | High proxy CPU                               |

✅ **Best Practices**

* Tune retries/timeouts globally.
* Use minimal telemetry sampling.
* Disable mesh for low-latency critical paths using `sidecar.istio.io/inject: "false"`.
* Validate MTU settings (1400 typical with mesh).

💡 **In short**
Inspect Envoy metrics, retries, mTLS overhead, MTU, and telemetry. Mesh latency is usually misconfigured retries or resource-starved proxies.

---

## Q152: EBS volumes are not attaching to pods with "FailedAttachVolume" error. What's wrong?

🧠 **Overview**
EBS volumes must attach to nodes in the **same AZ**, with correct IAM, correct StorageClass, and correct PVC/PV mapping.

⚙️ **What to check**

🧩 **1. AZ mismatch**
Pods scheduled in AZ-A but the EBS volume created in AZ-B → attach fails.

```bash
kubectl get pvc -o wide
kubectl get nodes -o wide
```

🧩 **2. Verify CSI driver**
Ensure EBS CSI driver installed:

```bash
kubectl get pods -n kube-system | grep ebs
```

🧩 **3. IAM permissions (IRSA)**
EBS CSI controller needs:

```
ec2:CreateVolume
ec2:AttachVolume
ec2:DeleteVolume
ec2:DescribeVolumes
```

🧩 **4. StorageClass config**
Check:

```yaml
volumeBindingMode: WaitForFirstConsumer
```

This ensures PVC will bind only after pod is scheduled → prevents AZ mismatch.

🧩 **5. Check node security groups**
Node SG must allow:

```
ec2:AttachVolume
ec2:DetachVolume
```

🧩 **6. Existing mount point conflicts**
Pods may crash if directories are already mounted.

📋 **Common root causes**

| Issue                        | Cause                        |
| ---------------------------- | ---------------------------- |
| Volume in AZ A, node in AZ B | AZ mismatch                  |
| Wrong StorageClass           | Immediate binding → mismatch |
| CSI not installed            | Attach errors                |
| IAM missing                  | CSI denied                   |

✅ **Best Practices**

* Always set `WaitForFirstConsumer` for EBS-backed workloads.
* Use EBS CSI driver (modern workloads).
* Label nodes by AZ and confirm pod scheduling constraints.

💡 **In short**
Check AZ mismatch, CSI installation, IAM, and StorageClass mode. 95% of attach failures come from AZ mismatch.

---

## Q153: Pods are failing liveness probes causing constant restarts. How would you troubleshoot?

🧠 **Overview**
Liveness probe failures mean the kubelet thinks the container is unhealthy. Causes: probe misconfig, slow startup, insufficient resources, or app actually failing.

⚙️ **Troubleshooting Steps**

🧩 **1. Check container logs**

```bash
kubectl logs <pod>
```

Look for:

* startup errors
* dependency failures
* deadlocks

🧩 **2. Describe pod for probe events**

```bash
kubectl describe pod <pod>
```

🧩 **3. Review probe configuration**
Example:

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 5
  timeoutSeconds: 1
  periodSeconds: 10
```

Common misconfigs:

* Too aggressive initial delay
* Wrong path
* Timeout too low
* Port mismatch

🧩 **4. Check resource throttling**

```bash
kubectl top pod <pod>
```

If CPU throttled, app becomes slow → probe fails.

🧩 **5. Check readiness vs liveness**
Do not conflate both → liveness should detect dead apps, not slow startup.

🧩 **6. Check external dependencies**
If the app blocks on DB, cache, or API → health endpoint becomes slow.

📋 **Common root causes**

| Symptom                         | Root Cause                       |
| ------------------------------- | -------------------------------- |
| Works locally, fails in cluster | Wrong probe path                 |
| Fails only at startup           | Too small initialDelaySeconds    |
| Fail under load                 | CPU/memory starvation            |
| Flaky 200/500                   | app health endpoint logic broken |

✅ **Best Practices**

* Use generous initial delays for heavy apps.
* Set `timeoutSeconds >= 2`.
* Keep liveness simple & fast.
* Monitor probe failures in Grafana.

💡 **In short**
Check logs → examine probe settings → ensure app isn’t slow or resource-throttled. Most restart loops stem from misconfigured probes.

---

## Q154: The metrics-server is not reporting metrics. How would you fix this?

🧠 **Overview**
Metrics-server collects CPU/memory metrics from kubelets. Failures result in HPA not scaling and `kubectl top` returning errors.

⚙️ **Troubleshooting Steps**

🧩 **1. Check logs**

```bash
kubectl -n kube-system logs deploy/metrics-server
```

Common messages:

* “x509: certificate signed by unknown authority”
* “unable to fully scrape metrics”

🧩 **2. Enable insecure TLS to kubelets (EKS requirement)**
EKS uses self-signed kubelet certs. Add:

```yaml
--kubelet-insecure-tls
```

🧩 **3. Check APIService registration**

```bash
kubectl get apiservice | grep metrics
kubectl describe apiservice v1beta1.metrics.k8s.io
```

🧩 **4. Ensure metrics-server can reach kubelets**
Check node SG:

* Allow port 10250 from cluster nodes.

🧩 **5. Fix resource limits**
Metrics-server may get OOM → missing metrics.

🧩 **6. Install correct configuration**

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

📋 **Common root causes**

| Issue                            | Root Cause                        |
| -------------------------------- | --------------------------------- |
| Certificate errors               | Missing `--kubelet-insecure-tls`  |
| No metrics                       | SG blocking port 10250            |
| APIService not “Available: True” | Registration failure              |
| OOM                              | Too low memory for large clusters |

✅ **Best Practices**

* Use Helm chart for EKS-specific defaults.
* Set memory limit ≥ 300Mi for clusters > 200 nodes.
* Monitor APIService health regularly.

💡 **In short**
Enable `--kubelet-insecure-tls`, allow port 10250, verify APIService, and check logs for cert or scrape errors.

---

## Q155: Your EKS nodes are showing high CPU iowait. What could be causing this?

🧠 **Overview**
High iowait indicates CPU waiting on disk operations. Causes include slow EBS volumes, high IOPS workloads, ephemeral storage exhaustion, or container writes misconfigured.

⚙️ **Diagnosis Steps**

🧩 **1. Check node I/O metrics**

```bash
iostat -x 1
```

🧩 **2. Check container filesystem usage**

```bash
du -sh /var/lib/containerd
```

🧩 **3. Check for heavy disk writers**

* Applications writing large logs
* Apps writing temp files to `/tmp` or `/var/cache`

🧩 **4. Check EBS volume type**

* gp2 may be too slow → switch to gp3 and set baseline IOPS.

🧩 **5. Check swap**

* If swap enabled accidentally → high iowait.

🧩 **6. Check daemonset workloads**

* Logging agents, scanning tools may overload disk.

📋 **Root causes**

| Cause                          | Evidence               |
| ------------------------------ | ---------------------- |
| Slow EBS (gp2 burst exhausted) | High await in `iostat` |
| Log-heavy apps                 | Large /var/log/pods    |
| Image churn                    | containerd slow writes |
| Node disk nearly full          | node pressure          |

⚙️ **Fixes**

* Switch node groups to **gp3** with sufficient IOPS:

```hcl
root_volume_type = "gp3"
root_volume_iops = 6000
```

* Reduce logging verbosity.
* Move heavy data to PVs.
* Clean containerd cache regularly.
* Use larger root volumes.

💡 **In short**
High iowait usually means slow or saturated EBS volumes. Fix by upgrading EBS type, reducing log/tmp writes, and cleaning container filesystem.

---

## Q156: Pods scheduled on Fargate are taking too long to start. What would you investigate?

🧠 **Overview**
Fargate pod startup delays are typically due to slow image pulls, VPC ENI provisioning time, Fargate profile mismatches, or heavy init containers.

⚙️ **Troubleshooting Steps**

🧩 **1. Fargate profile matching**
Verify the pod's namespace/labels match the Fargate Profile selector:

```bash
aws eks describe-fargate-profile --cluster-name <cluster>
```

If no match → pod stays Pending for a long time.

🧩 **2. Image pull time**
Fargate must pull images from ECR/Docker Hub each time → slow for large images.
Check pod events:

```bash
kubectl describe pod <pod> | grep -i pull
```

🧩 **3. VPC ENI provisioning delays**
Fargate requires an ENI per pod. If subnets have low IP availability → slow startup.

```bash
aws ec2 describe-subnets --query "Subnets[].AvailableIpAddressCount"
```

🧩 **4. Use of init containers**
Heavy or long init containers delay readiness.

🧩 **5. Logging configuration delays**
Fargate configures FireLens / log streaming containers; misconfig slows startup.

🧩 **6. Fargate platform version**
Older platform versions may cause slow network bootstrap.

📋 **Common causes**

| Issue                    | Evidence                                  |
| ------------------------ | ----------------------------------------- |
| Fargate profile mismatch | Pod stuck Pending                         |
| Large images             | Long ImagePull events                     |
| ENI provisioning         | Delayed transition from Pending → Running |
| Heavy init containers    | Long init phase                           |

✅ **Best Practices**

* Keep images < 300MB.
* Use multi-stage builds + distroless.
* Ensure prefix delegation or large CIDRs for IP capacity.
* Pre-warm images using ECR Pull-through cache.
* Create accurate Fargate Profiles per namespace/environment.

💡 **In short**
Check Fargate profile matching, large image pulls, ENI/IP availability, and init containers. Fargate slowness almost always comes from image size or IP provisioning delays.

---

## Q157: Your application cannot connect to RDS despite proper security group configuration. How do you debug?

🧠 **Overview**
Connectivity failures to RDS are usually due to DNS, routing, SSL requirements, wrong username/password, IAM auth issues, or RDS-specific network settings.

⚙️ **Debugging Steps**

🧩 **1. Test connectivity from pod**

```bash
kubectl exec -it <pod> -- nc -zv <rds-endpoint> 5432
```

If DNS resolves but connection fails → SG/subnet routing.

🧩 **2. Verify RDS SG rules**

* INBOUND: allow from EKS node/pod SG.
* Outbound on pod SG must allow DB port.

🧩 **3. Check RDS subnet group**
Ensure RDS is in **private subnets** with route to EKS nodes.

🧩 **4. Check RDS parameter group**
If SSL required:

```bash
jdbc:postgresql://<endpoint>:5432/db?sslmode=require
```

🧩 **5. IAM authentication (if using IAM token)**
Check:

```bash
aws rds generate-db-auth-token ...
```

Ensure pod has IRSA role permission:

```
rds-db:connect
```

🧩 **6. Check route tables**
Nodes and RDS must be in the same VPC or connected via VPC peering/TGW.

🧩 **7. Check DNS resolution**

```bash
kubectl exec -it <pod> -- nslookup <rds-endpoint>
```

📋 **Common root causes**

| Symptom                             | Cause                          |
| ----------------------------------- | ------------------------------ |
| DNS resolves but connection refused | Wrong port/SGL outbound rules  |
| Timeout                             | Route table / NACL blocking    |
| `SSL error`                         | SSL required by RDS            |
| `Access denied`                     | Wrong creds / IAM auth failure |

✅ **Best Practices**

* Use RDS Proxy for stable connections.
* Use IRSA for IAM DB auth.
* Restrict RDS access only to required SGs.
* Test connectivity via debug pods.

💡 **In short**
Check connectivity from pod, routing, SSL, IAM auth, and DNS. Most RDS failures come from DNS or routing, not SG rules.

---

## Q158: StatefulSet pods are stuck in "Terminating" state. How would you resolve this?

🧠 **Overview**
StatefulSets follow strict ordering during delete/rotate. Pods get stuck Terminating when finalizers, mounted volumes, preStop hooks, or PodDisruptionBudgets block cleanup.

⚙️ **Debugging Steps**

🧩 **1. Check finalizers**

```bash
kubectl get pod <pod> -o json | jq .metadata.finalizers
```

Remove finalizer if safe:

```bash
kubectl patch pod <pod> -p '{"metadata":{"finalizers":null}}'
```

🧩 **2. Check volume detach issues**
EBS volume still mounted:

```bash
kubectl describe pod <pod> | grep -i volume
```

Detach manually if stuck:

```bash
aws ec2 detach-volume --volume-id <id>
```

🧩 **3. Check PodDisruptionBudget**
If PDB is blocking deletion:

```bash
kubectl get pdb
```

🧩 **4. Check preStop hooks**
If hooks take too long, pod remains Terminating.

🧩 **5. Force delete**

```bash
kubectl delete pod <pod> --force --grace-period=0
```

(Last resort — may corrupt state)

📋 **Root causes**

| Cause             | Indicator                             |
| ----------------- | ------------------------------------- |
| Finalizers        | Pod won’t delete                      |
| EBS not detaching | Stateful workloads                    |
| PDB strict        | No eviction allowed                   |
| Hung preStop      | PodTerminating logs show delayed hook |

✅ **Best Practices**

* Use `WaitForFirstConsumer` StorageClass to avoid AZ mismatch.
* Keep preStop hooks <10 seconds.
* Avoid unnecessary finalizers.
* Handle graceful shutdown in app logic.

💡 **In short**
Check finalizers, PDBs, volume detach stalls, and hooks. Most stuck StatefulSet terminations stem from volume detach issues or PDB constraints.

---

## Q159: You're seeing "too many open files" errors in your pods. What's the solution?

🧠 **Overview**
This happens when the app hits OS file descriptor (FD) limits. Fix by increasing ulimits, adjusting kernel parameters, or reducing connection count.

⚙️ **Solutions**

🧩 **1. Increase pod/container ulimits via securityContext**

```yaml
securityContext:
  fsGroup: 2000
  runAsUser: 1000
  privileged: true
  capabilities:
    add: ["SYS_RESOURCE"]
```

But Kubernetes does NOT natively support `ulimit` settings — must use:

🧩 **2. Set ulimits at node level**
Modify Launch Template user-data:

```bash
echo "fs.file-max=500000" >> /etc/sysctl.conf
ulimit -n 65536
```

🧩 **3. Tune application (preferred)**

* Use connection pools
* Reduce per-request file handles
* Close file descriptors properly

🧩 **4. Increase ephemeral ports (if network sockets are the issue)**

```bash
sysctl -w net.ipv4.ip_local_port_range="1024 65535"
```

🧩 **5. Check for file descriptor leaks**
Use inside pod:

```bash
lsof | wc -l
```

📋 **Common root causes**

| Cause                 | Evidence             |
| --------------------- | -------------------- |
| Leaky connections     | lsof grows over time |
| High traffic          | exhausted FDs        |
| Node-level limits low | FDs capped at 1024   |

✅ **Best Practices**

* Tune node-level ulimits via Launch Template.
* Profile app for FD leaks.
* Use proper connection pools.

💡 **In short**
Increase FD limits at the node level, tune app to reduce open handles, and fix leaks. Kubernetes does not directly manage ulimits.

---

## Q160: The Cluster Autoscaler scaled down nodes with running pods. How do you prevent this?

🧠 **Overview**
Cluster Autoscaler may evict pods if it thinks they are “safe-to-evict”. Prevent unwanted eviction by using PDBs, node selectors, and pod-level annotations.

⚙️ **Solutions**

🧩 **1. Annotate pods to prevent eviction**

```yaml
metadata:
  annotations:
    cluster-autoscaler.kubernetes.io/safe-to-evict: "false"
```

🧩 **2. Use PodDisruptionBudgets**
Prevent CA from draining too many pods:

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
spec:
  minAvailable: 1
```

🧩 **3. Use dedicated node groups**
Move critical workloads to a node group with:

```
--expander=least-waste
```

Or taint nodes:

```bash
kubectl taint nodes critical=true:NoSchedule
```

🧩 **4. Check CA logs for “evictable” logic**

```bash
kubectl -n kube-system logs -l app=cluster-autoscaler
```

🧩 **5. Disable scale-down on certain node groups**
Annotate ASG:

```
k8s.io/cluster-autoscaler/node-template/label/scale-down-disabled=true
```

📋 **Eviction prevention tools**

| Method                | Level     | Purpose                       |
| --------------------- | --------- | ----------------------------- |
| `safe-to-evict=false` | Pod       | Prevent eviction              |
| PDB                   | App       | Maintain minimum availability |
| Taints                | Node      | Separate critical nodes       |
| Scale-down-disable    | Nodegroup | No scale-down                 |

✅ **Best Practices**

* Mark system-critical pods as non-evictable.
* Use PDBs for all production deployments.
* Separate core workloads in their own nodegroups.

💡 **In short**
Use pod annotation `safe-to-evict=false`, apply PDBs, and isolate critical workloads. Cluster Autoscaler only evicts pods it considers safe—override this for important services.

---

## Q161: Your EKS API server is rate limiting requests. What strategies would you implement?

🧠 **Overview**
API-server throttling happens when clients (kubectl, controllers, CI, operators) overwhelm the control plane. On EKS you can’t tune control-plane internals directly, so fix is usually **client-side, architectural, or organizational**: reduce chatty callers, use caches/informers, introduce throttling/queuing, or apply server-side fairness where available.

⚙️ **Purpose / How it works**

* **Reduce QPS/burst** from clients (client-go, kubectl).
* **Use informers/listers** or a caching proxy so controllers watch instead of polling.
* **Centralize heavy operations** (bulk read/write) and schedule/serialize them.
* **Detect & mitigate offenders** via audit logs and RBAC restrictions.
* Optionally enable **API Priority & Fairness (APF)** if your cluster/control plane supports it to protect important flows.

🧩 **Examples / Commands / Config snippets**

```bash
# Refresh kubeconfig token less often in CI, use `--request-timeout` with kubectl
kubectl get pods --request-timeout=30s

# In Go clients use shared informers (client-go)
factory := informers.NewSharedInformerFactory(clientset, 0)
podInformer := factory.Core().V1().Pods().Informer()
```

Audit + find offenders:

```bash
# Enable / query audit logs (CloudTrail & EKS audit) and find high-frequency principals
# Search in CloudWatch Logs / S3 where audit logs are exported
```

Rate-limit CI & bots (example GitHub Actions wrapper):

```bash
# add exponential backoff / jitter in scripts, or sleep between heavy kubectl calls
sleep $((RANDOM % 10))
```

📋 **Quick checklist (what to fix first)**

| Symptom                | Quick fix                                     |
| ---------------------- | --------------------------------------------- |
| Many `kubectl` in CI   | Add caching, batch operations, reduce polling |
| Controllers polling    | Use shared informer caches                    |
| One noisy user/service | Throttle client or restrict via RBAC          |
| Global overload        | Gate heavy jobs with queue worker + backoff   |

✅ **Best Practices**

* Prefer **watch/informer pattern** over frequent list calls.
* Add **client-side QPS and burst limits** (client-go config).
* Implement **exponential backoff + jitter** for transient errors.
* Use **audit logs** to identify noisy principals and apply RBAC limits or rate limiting at CI.
* Consider **API Priority & Fairness** to protect critical API traffic (confirm availability in EKS version).

💡 **In short**
Stop the noise at the source: replace polling with informers/caches, add client-side throttling/backoff in CI and operators, identify offenders with audit logs, and use APF where available.

---

## Q162: Pods are experiencing DNS resolution delays. How would you optimize CoreDNS?

🧠 **Overview**
DNS latency usually stems from CoreDNS overload, upstream resolver slowness, or misconfig (long cache TTLs, too few replicas). Fix by scaling, caching at node-level, tuning corefile, and reducing upstream latency.

⚙️ **Purpose / How it works**

* Increase CoreDNS capacity (replicas/resources).
* Use **NodeLocal DNSCache** (node-local agent) to serve pod queries locally.
* Tune CoreDNS `Corefile` to optimize `cache`, `forward`, and `errors`.
* Ensure CoreDNS pods are spread across AZs and have stable upstream resolvers.

🧩 **Examples / Commands / Config snippets**

Scale & resource example:

```bash
kubectl -n kube-system scale deployment coredns --replicas=4
kubectl -n kube-system set resources deployment/coredns \
  --limits=cpu=200m,memory=512Mi --requests=cpu=50m,memory=128Mi
```

CoreDNS `Corefile` tuning (cache + loop prevention):

```yaml
apiVersion: v1
kind: ConfigMap
metadata: name: coredns -n kube-system
data:
  Corefile: |
    .:53 {
      errors
      health
      ready
      kubernetes cluster.local in-addr.arpa ip6.arpa {
        pods insecure
        fallthrough in-addr.arpa ip6.arpa
      }
      prometheus :9153
      cache 30            # TTL seconds for cached responses
      loop
      forward . /etc/resolv.conf
      reload
      loadbalance
    }
```

Enable NodeLocal DNSCache:

```bash
# Use the NodeLocal add-on from Kubernetes SIGs or EKS addon where available
kubectl apply -f nodelocaldns.yaml
```

📋 **Tuning checklist**

| Action                               | Effect                                        |
| ------------------------------------ | --------------------------------------------- |
| Increase replicas & resources        | More throughput, lower latency                |
| NodeLocal DNS                        | Pod queries answered locally                  |
| Lower cache miss penalty             | Shorter `cache` + faster failover to upstream |
| Use reliable upstream (VPC Resolver) | Eliminate upstream slowness                   |

✅ **Best Practices**

* Run at least **2+ CoreDNS replicas per AZ** for HA.
* Use **NodeLocal DNSCache** on large clusters (reduces pod→dns network hops).
* Set a sensible `cache` (30–60s) to reduce load while allowing fast TTL changes.
* Monitor `coredns_dns_request_duration_seconds` and tune.
* Avoid wildcard `forward` to slow external resolvers—use Route53 resolver or VPC resolver.

💡 **In short**
Scale CoreDNS, add NodeLocal caching, tune Corefile cache/forward settings, and ensure stable upstream DNS to cut resolution delays.

---

## Q163: Your EKS cluster certificate expired and kubectl commands fail. How do you fix this?

🧠 **Overview**
“Certificate expired” can mean: (A) your **kubectl client certificate/token** expired, or (B) the **server CA** used by kubeconfig is invalid. EKS typically uses IAM auth — common fix is to **refresh kubeconfig** or re-create credentials; control-plane cert rotation is managed by AWS.

⚙️ **Purpose / How it works**

* If client creds expired → update kubeconfig (aws eks update-kubeconfig) or refresh AWS SSO token.
* If server certificate truly expired on control plane → contact AWS Support (EKS managed control plane rotates certs automatically; intervention may be required).

🧩 **Commands / Resolution steps**

1. **Refresh kubeconfig (common fix)**:

```bash
aws eks update-kubeconfig --name my-cluster --region ap-south-1
# or if using SSO:
aws sso login --profile myprofile
```

2. **Check current kubeconfig entries**

```bash
kubectl config view --minify
# Inspect certificate-authority-data and user exec tokens
```

3. **If using client certs (rare)** regenerate client certs or switch to AWS IAM auth.

4. **If control-plane server cert expired**:

* Validate via `curl https://<cluster-endpoint>/healthz` (from an allowed host) and inspect certificate chain.
* Contact **AWS Support** to trigger control-plane cert rotation — EKS is managed and AWS usually rotates certs for you.

📋 **Diagnostics**

| Symptom                                         | Action                                  |
| ----------------------------------------------- | --------------------------------------- |
| `x509: certificate has expired` in kubectl      | Run `aws eks update-kubeconfig`         |
| `certificate signed by unknown authority`       | Validate CA data in kubeconfig          |
| Control-plane unreachable / expired server cert | Check via AWS console & contact support |

✅ **Best Practices**

* Use **aws eks update-kubeconfig** in automation (CI) before kubectl calls.
* Prefer **IAM auth / IRSA** — reduces client-certificate management.
* Ensure SSO tokens are refreshed in CI runners.
* Monitor cert expiry for any non-managed certificates and set alerts.

💡 **In short**
First, refresh kubeconfig / AWS SSO tokens. If the server CA truly expired (rare on EKS), contact AWS Support — EKS control plane certificate rotation is an AWS-managed process.

---

## Q164: DaemonSet pods are not running on some nodes. What would you check?

🧠 **Overview**
DaemonSets should run on all “eligible” nodes. Missing DaemonSet pods usually mean **node selectors/taints/architecture/conditions** or resource/CRI issues are preventing scheduling.

⚙️ **Purpose / How it works**
Kube-scheduler places DaemonSet pods only on nodes that match the DaemonSet’s `nodeSelector`, `nodeAffinity`, tolerations, and `host` OS/arch. Nodes in `NotReady`, `SchedulingDisabled` or with insufficient resources are skipped.

🧩 **Diagnostics & Commands**

```bash
kubectl describe daemonset <ds-name> -n <ns>
kubectl get nodes -o wide
kubectl describe node <node>
# Check DaemonSet Desired vs Current
kubectl -n <ns> get ds
```

Check common blockers:

* **Taints** on nodes (e.g., `node.kubernetes.io/not-ready` or custom taints).
* **NodeSelector / NodeAffinity** in DaemonSet spec:

```yaml
spec:
  template:
    spec:
      nodeSelector:
        kubernetes.io/os: linux
```

* **Pod tolerations** missing for tainted nodes:

```yaml
tolerations:
- key: "node-role.kubernetes.io/master"
  operator: "Exists"
  effect: "NoSchedule"
```

* **Architecture mismatch** (arm vs amd).
* **Insufficient resources** (rare for DS since usually small).
* **Kubelet or runtime issues** preventing pod creation (check `kubelet` logs on node).
* **Image pull errors** causing CrashLoopBackOff immediately after creation.

🧩 **Example: find nodes missing DS pod**

```bash
kubectl -n kube-system get ds aws-node -o jsonpath='{.status}'
# or loop
for n in $(kubectl get nodes -o name); do kubectl get pod -n kube-system -o wide --field-selector spec.nodeName=${n#node/} | grep aws-node || echo missing on $n; done
```

✅ **Best Practices**

* Ensure DaemonSet tolerations match node taints.
* Use `nodeSelector` or `nodeAffinity` appropriately and keep labels consistent.
* Check node conditions (`Ready`, `DiskPressure`, `MemoryPressure`).
* Deploy minimal resource requests for DaemonSets to avoid scheduling rejections.

💡 **In short**
Check DaemonSet `nodeSelector/affinity/tolerations`, node taints/conditions, architecture and kubelet logs — DaemonSets only run on nodes that meet both node and pod constraints.

---

## Q165: Your application logs are not appearing in CloudWatch. How would you troubleshoot?

🧠 **Overview**
Log shipping failures are usually due to collector misconfiguration (Fluent Bit/Fluentd), missing IAM permissions (IRSA), wrong log group/stream names, or Collector crashing/being rate-limited.

⚙️ **Purpose / How it works**
A DaemonSet (Fluent Bit) reads `/var/log/containers/*.log` and forwards to CloudWatch Logs using an output plugin and AWS credentials via IRSA or node IAM.

🧩 **Troubleshooting Steps & Commands**

1. **Check collector pods**

```bash
kubectl -n kube-logging get pods
kubectl -n kube-logging logs <fluent-bit-pod>
```

Look for `403` or “AccessDenied” errors.

2. **Verify ServiceAccount / IRSA role**

* Confirm the Fluent Bit SA has `iam.amazonaws.com/role` annotation and correct policy:

```json
"logs:PutLogEvents","logs:CreateLogStream","logs:CreateLogGroup"
```

3. **Validate Fluent Bit Output config**
   Check `Output` section points to correct `log_group_name`/`log_stream_prefix` and region.

4. **Check CloudWatch Logs quotas & retention**

* Ensure log group exists or Fluent Bit can create it (permissions).
* Check if rate limits or throttling occur (look for `ThrottlingException` in logs).

5. **Confirm container logs exist on node**
   If container runtime not writing logs, nothing to ship:

```bash
ls /var/log/containers | grep <pod-name>
```

6. **Network path**
   For private clusters, ensure Fluent Bit can reach CloudWatch endpoints (VPC endpoints or NAT).

🧩 **Sample Fluent Bit output snippet**

```ini
[OUTPUT]
    Name   cloudwatch_logs
    Match  kube.*
    region ap-south-1
    log_group_name /aws/eks/cluster/app
    log_stream_prefix from-fluent-bit-
```

📋 **Checklist**

| Symptom                  | Likely Fix                           |
| ------------------------ | ------------------------------------ |
| AccessDenied             | Fix IAM policy / IRSA                |
| No logs on node          | Check container runtime & file paths |
| Throttling               | Add batching/retry, monitor quotas   |
| Wrong group/stream names | Fix Fluent Bit config                |

✅ **Best Practices**

* Use **IRSA** for Fluent Bit and least-privilege policy.
* Tag logs with `cluster`, `namespace`, `pod` for easy queries.
* Use buffering and retry settings to survive transient CloudWatch throttling.
* Test with a debug pod that writes to stdout and check for shipping.

💡 **In short**
Check Fluent Bit logs, IAM permissions (IRSA), collector config (log group/stream), node-local log files, and network reachability. Most failures are permissions or misconfiguration.

---

## Q166: Pods are getting scheduled on inappropriate nodes despite affinity rules. Why?

🧠 **Overview**
Affinity rules can be **preferred** (soft) or **required** (hard). If pods land on “wrong” nodes, often the affinity was configured as `preferredDuringSchedulingIgnoredDuringExecution` or there are conflicting constraints that force the scheduler to break affinity.

⚙️ **Purpose / How it works**

* **requiredDuringSchedulingIgnoredDuringExecution** = hard constraint; scheduler will not place pod on nodes that don’t match.
* **preferredDuringSchedulingIgnoredDuringExecution** = soft constraint; scheduler tries but may place elsewhere if no fit.

🧩 **Diagnostic steps & examples**

1. **Inspect pod spec** — check if affinity is `required` vs `preferred`:

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms: [...]
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference: { ... }
```

2. **Check for conflicting constraints**

* Taints/tolerations, nodeSelector, topologySpreadConstraints, resource requests might override preference.

```bash
kubectl describe pod <pod>   # look for scheduling messages
```

3. **Check schedulerName**
   A custom scheduler could ignore Kubernetes built-in affinity:

```yaml
spec:
  schedulerName: my-custom-scheduler
```

4. **Look at events**

```bash
kubectl get events --field-selector involvedObject.name=<pod>
```

Shows why scheduler placed it where it did.

5. **Pod was pre-bound or patched**
   Someone may have used `kubectl patch` to force binding.

📋 **Common causes**

| Observed behavior                      | Root cause                                      |
| -------------------------------------- | ----------------------------------------------- |
| Pod on wrong node but affinity present | Affinity was `preferred` not `required`         |
| Pod scheduled ignoring rules           | Custom scheduler or pre-binding                 |
| Pod moves after scheduling             | `ignoredDuringExecution` vs runtime constraints |

✅ **Best Practices**

* Use **requiredDuringScheduling** for placement guarantees.
* Combine affinities with **taints & tolerations** for stronger enforcement.
* Review event logs for scheduler decisions.
* Avoid over-constraining (can cause Pending); prefer taints for strictness.

💡 **In short**
Most “ignored” affinities are actually **soft (preferred)**. Use `requiredDuringSchedulingIgnoredDuringExecution` or taints/tolerations for strict placement, and inspect scheduler events to see the exact reason the pod was placed.

---

## Q167: PersistentVolumeClaims are stuck in "Pending" state. What are the possible causes?

🧠 **Overview**
PVCs remain `Pending` when Kubernetes cannot bind them to a suitable `PersistentVolume`. Causes include mismatched `StorageClass`, capacity shortage, incorrect accessModes, `volumeBindingMode` behavior (AZ/Toplogy), CSI driver problems, or quota limits.

⚙️ **Purpose / How it works**

* PVC → StorageClass → CSI provisioner creates PV in the correct AZ/zone.
* If the provisioner can’t create a PV that satisfies capacity/accessModes/topology, PVC stays `Pending`.

🧩 **Examples / Commands / Diagnostics**

```bash
kubectl get pvc -A
kubectl describe pvc <pvc-name> -n <ns>     # shows events/messages
kubectl get storageclass
kubectl describe storageclass <sc>
kubectl get pv
# Check CSI provisioner logs
kubectl -n kube-system logs -l app=csi-ebs-controller
```

Common `describe pvc` events:

* `failed to provision volume with StorageClass "fast": ...` (CSI error)
* `no persistent volumes available for this claim and no storage class is set` (no SC/default)
* `can't find any available PersistentVolume` (capacity/accessMode mismatch)
* `pod scheduled in az-a but StorageClass uses az-b` (topology/WaitForFirstConsumer)

📋 **Root causes table**

| Symptom in `kubectl describe pvc`     | Likely cause                                                  |
| ------------------------------------- | ------------------------------------------------------------- |
| `no storage class`                    | Missing/incorrect StorageClass or default SC unset            |
| `failed to provision`                 | CSI driver missing/permissions/bug                            |
| `no matching PV`                      | AccessMode or capacity mismatch                               |
| `Provisioner indicates zone mismatch` | `volumeBindingMode` and pod AZ binding (WaitForFirstConsumer) |
| `quota exceeded`                      | PV quota or AWS account limits                                |

✅ **Best Practices**

* Use `WaitForFirstConsumer` for AZ-aware provisioning for EBS.
* Confirm CSI driver is installed and has IAM permissions (IRSA/Node role).
* Keep StorageClass names and defaults standardized via IaC.
* Use `kubectl describe` and CSI controller logs as first step.
* Pre-provision PVs for stateful workloads in critical paths.

💡 **In short**
Check `kubectl describe pvc` → StorageClass → CSI provisioner logs → AZ/topology and quotas. Most Pending PVCs are StorageClass/CSI or topology mismatches.

---

## Q168: Your ingress is returning 503 errors. How would you diagnose the issue?

🧠 **Overview**
HTTP 503 indicates the ingress/load-balancer received the request but had no healthy backend or could not route. Causes: service endpoints missing, target group health failing, mis-configured Ingress annotations, security groups, or backend crash/CrashLoopBackOff.

⚙️ **Purpose / How it works**

* Ingress → Ingress Controller (ALB/NGINX/Traefik) → Service → Pod endpoints.
* 503 can result if any step fails or health checks mark targets unhealthy.

🧩 **Diagnostics / Commands**

```bash
kubectl get ingress -A
kubectl describe ingress <ing> -n <ns>       # check events/annotations
kubectl get svc -n <ns> <svc>
kubectl get endpoints -n <ns> <svc>          # must list pod IPs
kubectl get pods -l app=<label> -n <ns> -o wide
kubectl describe pod <pod> -n <ns>           # CrashLoop or probe failures
# For AWS ALB:
kubectl describe ingress <ing> | grep -i alb
# Check target group health in AWS Console / CLI
aws elbv2 describe-target-health --target-group-arn <arn>
```

📋 **Common causes & checks**

| 503 scenario                  | What to check                                          |
| ----------------------------- | ------------------------------------------------------ |
| No endpoints                  | `kubectl get endpoints` empty — service selector wrong |
| Pods unhealthy                | Pod readiness probe failing → targets marked unhealthy |
| ALB target group unhealthy    | Check AWS target health & security groups              |
| Incorrect `service.spec.port` | Port mismatch between Service and Pod containerPort    |
| Ingress annotation error      | Wrong `target-type` or path rules                      |

✅ **Quick fixes**

* Fix service selector or labels so endpoints populate.
* Correct readiness probes (or fix app) so pods become healthy.
* Ensure ALB SG allows node/target communication and health checks.
* Verify Ingress uses correct Service port names (if named ports used).

💡 **In short**
503 → the ingress found no healthy backend. Verify `endpoints`, pod readiness, service ports/selectors, and LB target health. Fix the component that shows “no healthy targets”.

---

## Q169: Jobs are not completing and running indefinitely. What would you investigate?

🧠 **Overview**
Kubernetes Jobs/Batch workloads run until completion conditions are met. If they hang, likely reasons are application-level deadlock, incorrect command/args, missing input/credentials, stuck in backoff, or resources/timeouts.

⚙️ **Purpose / How it works**

* Job controller creates pods. Success depends on container exit code 0 (for simple Jobs) or completion of defined tasks. BackoffLimit, activeDeadlineSeconds and concurrency control the lifecycle.

🧩 **Diagnostics / Commands**

```bash
kubectl get jobs -n <ns>
kubectl describe job <job> -n <ns>
kubectl get pods -l job-name=<job> -n <ns>
kubectl logs <pod> -n <ns>
kubectl logs <pod> -n <ns> --previous  # if restarted
# Check events for backoff or mount issues
kubectl describe pod <pod> -n <ns>
```

Things to inspect:

* Container exit codes and logs (infinite loops or awaiting input).
* `backoffLimit` reached? pods in CrashLoopBackOff?
* `activeDeadlineSeconds` too long/short.
* Stuck waiting on external resources (DB, S3, secret retrieval).
* Resource starvation (CPU/memory) causing timeouts.

📋 **Common failure modes**

| Symptom                     | Cause                                   |
| --------------------------- | --------------------------------------- |
| Pod Running forever         | App blocking/waiting, no exit condition |
| CrashLoopBackOff            | Bad command or missing deps; check logs |
| Stuck Pending               | Node resources or PVC binding issues    |
| No start / ImagePull errors | Registry auth / tag mismatch            |

✅ **Best Practices**

* Make Jobs idempotent and time-bounded; set `activeDeadlineSeconds`.
* Use `backoffLimit` to limit retries.
* Emit progress logs and health markers and use sidecar for watchdog if needed.
* Use `kubectl logs` and pod-level tracing to diagnose blocked calls.
* Use ephemeral volumes or checkpoints for long-running batch tasks.

💡 **In short**
Check pod logs, exit codes, Job events (backoff/activeDeadline), and dependencies (DB/Secrets). Jobs usually hang due to app logic waiting for I/O or misconfiguration.

---

## Q170: The EKS add-on installation failed. How would you troubleshoot and retry?

🧠 **Overview**
EKS Add-ons (managed CNI, CoreDNS, kube-proxy, etc.) install via the EKS API and create resources. Failures can be due to version incompatibility, IAM/IRSA permissions, missing resources, or transient API errors.

⚙️ **Purpose / How it works**
EKS Add-on install triggers AWS to deploy or update controller resources in the cluster (via EKS service role and IAM). Some add-ons also require node-level IAM or CRDs present.

🧩 **Diagnostics / Commands**

```bash
# Inspect add-on status
aws eks describe-addon --cluster-name <cluster> --addon-name vpc-cni
# Or using eksctl
eksctl utils describe-addon --cluster <cluster> --name vpc-cni
# Check EKS control plane events
kubectl get events -n kube-system
# Check the controller pod logs (where add-on is expected)
kubectl -n kube-system get pods | grep aws-node
kubectl -n kube-system logs <addon-pod>
```

Check:

* AWS IAM role permissions for EKS service to manage add-ons.
* Add-on version compatibility with cluster Kubernetes version.
* Required CRDs are present before add-on creation.
* Cluster has network and node resources for add-on pods.

🧩 **Retry steps**

1. Fix root cause (correct IAM, install missing CRDs, upgrade cluster if incompatible).
2. Retry via AWS CLI / Console:

```bash
aws eks update-addon --cluster-name <cluster> --addon-name <addon> --resolve-conflicts OVERWRITE
# Or reinstall:
aws eks delete-addon --cluster-name <cluster> --addon-name <addon>
aws eks create-addon --cluster-name <cluster> --addon-name <addon> --addon-version <ver>
```

3. Alternatively, uninstall and install add-on via helm or manifests if managed addon fails.

📋 **Common issues**

| Failure message                | Fix                                      |
| ------------------------------ | ---------------------------------------- |
| `Insufficient IAM permissions` | Update EKS service role policies         |
| `Version not supported`        | Pick compatible add-on version           |
| `CRD not found`                | Install required CRDs first              |
| `Pod CrashLoop`                | Check addon pod logs & image permissions |

✅ **Best Practices**

* Pin add-on versions in IaC and test in staging.
* Ensure IRSA or node IAM roles meet add-on requirements.
* Monitor add-on lifecycle and check CloudTrail for API errors.
* Use `--resolve-conflicts` cautiously (OVERWRITE can replace local changes).

💡 **In short**
Check `describe-addon` output, controller pod logs, IAM and CRD prerequisites; fix root cause and retry using AWS CLI or reinstall manually if needed.

---

## Q171: Your EKS nodes are not joining the cluster. What would you check?

🧠 **Overview**
Nodes fail to join when kubelet cannot register with API server due to networking, incorrect bootstrap tokens/AMIs, wrong IAM role/policies, or kubelet misconfiguration.

⚙️ **Purpose / How it works**
Worker nodes use a bootstrap process (user-data or managed node group provisioning) to run kubelet and register with cluster API. Failures occur before or during that handshake.

🧩 **Diagnostics / Commands**

* Check EC2 instance state & console logs (SSM session if available).
* Look at node bootstrap logs (`/var/log/eks/bootstrap.log`, `/var/log/messages`, `journalctl -u kubelet`).
* Verify user-data & Launch Template settings (correct cluster name & endpoint).
* Verify IAM instance role has required policies:

  * `AmazonEKSWorkerNodePolicy`, `AmazonEC2ContainerRegistryReadOnly`, `AmazonEKS_CNI_Policy`.
* Check security groups and network reachability to control plane endpoint (port 443).
* Validate cluster CA & discovery token (for self-managed joins).

Commands:

```bash
aws ec2 describe-instances --instance-ids <id>
# On instance via SSM:
journalctl -u kubelet -f
curl -v https://<cluster-endpoint>/healthz
```

📋 **Common causes**

| Symptom                    | Likely cause                          |
| -------------------------- | ------------------------------------- |
| kubelet errors on instance | Wrong bootstrap args or AMI mismatch  |
| Can't reach API endpoint   | SGs or route tables blocking port 443 |
| `x509` errors              | Wrong cluster CA/token                |
| Node fails CNI init        | Missing IAM permissions for CNI       |

✅ **Best Practices**

* Use managed node groups or EKS-optimized AMIs to avoid bootstrap errors.
* Test bootstrap user-data via a single test instance.
* Ensure instances have network path to control plane (VPC endpoints or public access).
* Keep instance IAM roles minimal but sufficient.

💡 **In short**
Inspect instance logs (kubelet/bootstrap), network path to API server, IAM role policies, and launch/user-data configuration. Nodes not joining almost always trace to network or bootstrap misconfig.

---

## Q172: Pods scheduled with resource limits are being throttled unexpectedly. How do you optimize?

🧠 **Overview**
CPU throttling occurs when pods hit `cpu` **limits** — kernel enforces cgroup quotas. Unexpected throttling arises from incorrect limits, bursting workloads, or noisy neighbors; fix by right-sizing requests/limits, tuning QoS, and adjusting scheduling.

⚙️ **Purpose / How it works**

* `requests` control scheduling; `limits` control runtime cgroup quotas. If `limit == request`, no burst capacity; if limit < required during bursts, container throttled.

🧩 **Diagnostics / Commands**

```bash
kubectl top pod -n <ns> <pod>
kubectl describe pod <pod> -n <ns>   # see resource requests/limits
# Check throttling metrics (if using cAdvisor/Prometheus)
rate(container_cpu_cfs_throttled_seconds_total[5m])
# On node:
cat /sys/fs/cgroup/cpu,cpuacct/kubepods.slice/.../cpu.cfs_throttled_time
```

Optimization strategies:

* Ensure `requests` reflect baseline and `limits` allow bursts: `request < limit`.
* For latency-sensitive services give them dedicated nodes (nodeSelector/taints) to avoid contention.
* Use QoS `Guaranteed` (request==limit) for predictability, but accept no burst.
* Tune Horizontal Pod Autoscaler (HPA) to scale under load rather than relying on burst.
* Use `cpuManagerPolicy: static` for guaranteed CPU pinning for performance-critical workloads.

📋 **Tactics comparison**

| Goal                                  | Tactic                                                        |
| ------------------------------------- | ------------------------------------------------------------- |
| Reduce throttling during bursts       | increase limits or lower requests to allow headroom           |
| Predictable single-thread performance | use guaranteed QoS + CPU pinning (`cpuManagerPolicy: static`) |
| Avoid noisy neighbors                 | dedicated node pools (taints) + limits on other pods          |
| Autoscale under sustained load        | HPA based on CPU/custom metrics                               |

✅ **Best Practices**

* Set realistic **requests** (what app needs) and **limits** (what it may use) — use monitoring to size.
* Use HPA and Cluster Autoscaler to add capacity under sustained load.
* For microservices requiring low latency, prefer `Guaranteed` QoS with dedicated nodes.
* Monitor `container_cpu_cfs_throttled_seconds_total` and alert on sustained throttling.

💡 **In short**
Throttling = hitting CPU limits. Right-size requests/limits, give latency-sensitive services reserved capacity or dedicated nodes, and autoscale for sustained load rather than relying on burst.

----
## Q173: Your multi-AZ deployment has all pods running in a single AZ. How do you fix this?

🧠 **Overview**
When pods concentrate in one AZ you lose availability. Fix by ensuring nodes exist in all AZs, making scheduling topology-aware (node affinity / topologySpreadConstraints), and letting autoscalers and provisioning place nodes across AZs.

⚙️ **Purpose / How it works**

* Kubernetes schedules pods to nodes that satisfy selectors/affinities; if nodes only exist in one AZ or your scheduling constraints bias one AZ, pods will land there.
* Use multi-AZ nodegroups, proper `topologySpreadConstraints`, and avoid AZ-specific nodeSelectors. Ensure cluster autoscaler/Karpenter is provisioning evenly across AZs.

🧩 **Examples / Commands / Config snippets**

1. **Check node AZ distribution**

```bash
kubectl get nodes -o wide --show-labels
# or
kubectl get nodes -L topology.kubernetes.io/zone
```

2. **If nodes only exist in one AZ — create node groups across AZs**

* EKS (eksctl example):

```bash
eksctl create nodegroup --cluster prod --name ng-multi --node-ami auto \
  --node-type m5.large --nodes-min 2 --nodes-max 6 --zones ap-south-1a,ap-south-1b,ap-south-1c
```

3. **Add topologySpreadConstraints to workloads**

```yaml
spec:
  topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: topology.kubernetes.io/zone
    whenUnsatisfiable: DoNotSchedule
    labelSelector:
      matchLabels:
        app: frontend
```

4. **Avoid hard AZ nodeSelector** — use labels like `node-role.kubernetes.io/worker: ""` instead of `topology.kubernetes.io/zone`.

5. **Check Pod Anti-Affinity (if present)**

```yaml
podAntiAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
  - labelSelector:
      matchLabels: { app: frontend }
    topologyKey: topology.kubernetes.io/zone
```

📋 **Quick checklist**

| Check                          | Command                                            |
| ------------------------------ | -------------------------------------------------- |
| Node AZ distribution           | `kubectl get nodes -L topology.kubernetes.io/zone` |
| Pod distribution by zone       | `kubectl get pods -o wide --all-namespaces`        |
| Deployment constraints         | `kubectl describe deploy <name>`                   |
| Autoscaler provisioning config | Inspect ASG/Karpenter provisioner AZ list          |

✅ **Best Practices**

* Provision nodegroups/provisioners across all AZs you want pods in.
* Use `topologySpreadConstraints` and/or required `nodeAffinity` for strict placement.
* Let Karpenter/Cluster Autoscaler balance across AZs via diversified instance types.
* Avoid AZ hardcoding in manifests; prefer topology keys and labels.
* Test failure scenarios to ensure pods reschedule across AZs.

💡 **In short**
Ensure nodes exist in all AZs, add topology-aware constraints (spread/anti-affinity), and let autoscalers/provisioners distribute capacity — don’t hard-pin pods to a single AZ.

---

## Q174: ConfigMap or Secret changes are not being reflected in running pods. What's the issue?

🧠 **Overview**
Kubernetes mounts ConfigMaps/Secrets as files or exposes them as env vars. File mounts update automatically (with a small delay) but environment variables do **not** update; containers must re-read files or be restarted for env var changes.

⚙️ **Purpose / How it works**

* **Mounted volumes:** kubelet updates projected files when content changes. Apps must re-read files to pick up changes.
* **Env vars:** injected at pod start — changing the underlying Secret/ConfigMap does not update environment variables; pod restart required.

🧩 **Examples / Commands / Fixes**

1. **Check how pods consume config**

* Mounted file:

```yaml
volumeMounts:
- mountPath: /etc/config
  name: app-config
env:
- name: CONFIG_PATH
  value: /etc/config/app.yaml
```

* Env var (won’t update until restart):

```yaml
env:
- name: APP_CONFIG
  valueFrom:
    configMapKeyRef: { name: my-cm, key: config.yaml }
```

2. **Ways to make changes take effect**

* If mounted as file → design app to **watch** file or SIGHUP to reload config.
  Example: send SIGHUP:

  ```bash
  kubectl exec -n ns <pod> -- kill -HUP 1
  ```
* If env var needed → **restart pod** (Deployment rollout):

```bash
kubectl rollout restart deployment/my-deployment -n myns
```

* Use automation: CI writes new image tag or patches deployment with annotation:

```bash
kubectl patch deployment my-deployment -p '{"spec":{"template":{"metadata":{"annotations":{"configmap-reload":"<ts>"}}}}}'
```

* Use a sidecar such as `kiwi/reload` or `stakater/Reloader` / `Flux`/`ArgoCD` auto-reload controllers.

3. **Check that kubelet updated the files**

```bash
kubectl exec -it <pod> -- ls -l /etc/config
kubectl exec -it <pod> -- cat /etc/config/app.yaml
```

📋 **Common pitfalls**

| Symptom                            | Cause                                            |
| ---------------------------------- | ------------------------------------------------ |
| Env vars unchanged after CM update | Env vars are static at pod start                 |
| File content unchanged             | kubelet update failed / volume mount not present |
| App ignores file changes           | App doesn’t re-read or reload on SIGHUP          |

✅ **Best Practices**

* Prefer **mounted files** for live reloading; implement config reload handlers in the app.
* For env var-driven apps, use **Deployment rollouts** on config change or controllers that patch pod template annotations.
* Consider using a **ConfigMap reloader** sidecar or native libs (Spring Cloud Config, etc.).
* Keep secrets rotation secure: use Secrets Store CSI driver to mount secrets as files and CSI refresh features.

💡 **In short**
Mounted files update automatically (app must re-read); env vars don’t — restart pods or implement a reload mechanism (SIGHUP/sidecar/controller) to pick up changes.

---

## Q175: Your EKS cluster is experiencing cascading failures during deployment. How do you identify the root cause?

🧠 **Overview**
Cascading failures (massive restarts, degraded services) during deployment usually result from resource exhaustion, misconfigured probes causing mass restarts, dependency overload, noisy deployments (thundering herd), or a bad config/image pushed to many services.

⚙️ **Purpose / How it works**
Identify the initial failure trigger, then track how dependent components fail. Use metrics, events, and logs to trace the propagation path.

🧩 **Runbook / Diagnostic Steps**

1. **Pause deployments**

* Stop new rollouts to prevent further spread.

```bash
kubectl rollout pause deployment --all -n <suspected-ns>
```

2. **Check cluster-level metrics** (CPU, memory, disk, API server QPS) — Prometheus/Grafana.

* Look for sudden spikes or resource depletion.

3. **Inspect Kubernetes events and top errors**

```bash
kubectl get events --sort-by='.lastTimestamp' -A | tail -n 200
```

4. **Identify first failing component**

* Use timestamps: which pods started failing first? `kubectl get pods -A --sort-by=.metadata.creationTimestamp` and check events/logs.

5. **Check control plane errors**

* API server throttling, etcd (EKS managed), kubelet saturations visible in `kubectl top nodes` and control-plane logs (CloudWatch/AWS Console).

6. **Check readiness/liveness probe behavior**

* Aggressive liveness causing restarts → downstream dependencies overwhelmed.

7. **Check resource-requests and quota exhaustion**

* Node pressure or quota prevents scheduling → backlog and retries.

8. **Check network/storage**

* Shared infra failure (EBS, CNI, DNS) can cause many pods to fail.

9. **Rollback / isolate**

* Roll back the offending image or scale down the problematic deployment:

```bash
kubectl rollout undo deployment/bad-deploy -n ns
kubectl scale deployment bad-deploy --replicas=0 -n ns
```

10. **Postmortem**

* Capture logs, timeline, and mitigation steps.

📋 **Investigation checklist**

| Area              | Command / Metric                                             |
| ----------------- | ------------------------------------------------------------ |
| Events            | `kubectl get events -A`                                      |
| Pod restarts      | `kubectl get pods -A --field-selector=status.phase!=Running` |
| Resource pressure | `kubectl top nodes` / `kubectl top pods`                     |
| API server load   | CloudWatch EKS API metrics                                   |
| Storage errors    | CSI/controller logs, `kubectl describe pvc`                  |

✅ **Best Practices**

* Deploy **canaries** and progressive rollouts (Argo Rollouts / Istio weights).
* Use resource limits/requests and HPA to avoid overload.
* Enforce `readiness` to avoid routing traffic to unhealthy pods.
* Implement circuit breakers and rate limits at ingress.
* Automate rollback on SLO violations (Argo Rollouts) and have runbooks.

💡 **In short**
Stop the deployment, identify the first failing component via events/metrics/logs, isolate/rollback it, then fix root cause (resources, probe config, or bad image) before resuming incremental rollout.

---

## Q176: Spot instances are being terminated but pods are not being rescheduled gracefully. What's wrong?

🧠 **Overview**
Spot terminations are expected; graceful rescheduling requires proper pod disruption handling, node termination notices, and autoscaler reacting to scale events. Failures happen if pods are non-evictable, not using proper taints/tolerations, or termination notice handling is missing.

⚙️ **Purpose / How it works**

* When EC2 Spot is about to terminate, AWS sends a 2-minute termination notice—kubelet/daemonset handlers should cordon/drain node and let pods terminate gracefully. CA/Karpenter should trigger replacement capacity.

🧩 **Checks & Fixes**

1. **Check termination notice handling**

* Ensure `aws-node-termination-handler` or similar is deployed (DaemonSet) to catch spot termination events and cordon/drain nodes:

```bash
kubectl -n kube-system get ds | grep node-termination
```

2. **Pod eviction settings**

* Ensure pods are **evictable** (no `safe-to-evict: "false"` annotation, PDBs allow disruptions).
* For stateful/critical pods use `pod-disruption-budget` wisely (minAvailable not 100%).

3. **Graceful shutdown handling in app**

* App must handle `SIGTERM` and finish in `terminationGracePeriodSeconds`.

```yaml
spec:
  terminationGracePeriodSeconds: 120
```

4. **Cluster Autoscaler / Karpenter response**

* Confirm CA/Karpenter is configured to provision replacement nodes quickly and that nodegroups allow scale-up.

5. **Use Pod Topology / Mixed node groups**

* Run critical pods on on-demand nodegroups; run batch/ephemeral on Spot.

6. **Logs & events**

* Check node events around termination, and pod termination logs:

```bash
kubectl describe node <node>
kubectl get events --field-selector involvedObject.name=<node>
```

📋 **Common root causes**

| Symptom                                 | Cause                                       |
| --------------------------------------- | ------------------------------------------- |
| Node terminated, pods stuck Terminating | No termination handler or handler failed    |
| Pods not drained                        | PDB prevents eviction; safe-to-evict=false  |
| Pod restarts elsewhere delayed          | Autoscaler slow or ASG min size reached     |
| App not exiting gracefully              | No SIGTERM handler / too short grace period |

✅ **Best Practices**

* Run **aws-node-termination-handler** (or node daemon that handles spot interruption) or enable EKS managed node termination handling.
* Annotate critical pods to run on on-demand nodegroups.
* Use reasonable `terminationGracePeriodSeconds` and implement `SIGTERM` handling.
* Use PDBs that allow at least one replica to be evicted during scale events.
* Monitor spot interruption metrics and pre-warm capacity.

💡 **In short**
Install and verify a termination handler that cordons/drains nodes, ensure pods are evictable and apps handle SIGTERM with sufficient grace period, and ensure autoscaler/provisioner replaces Spot capacity quickly.

---

## Q177: The VPC CNI is running out of warm IP pools. How would you tune this?

🧠 **Overview**
The AWS VPC CNI pre-allocates ENIs/IPs (warm pool) for faster pod bootstrap. Running out of warm IPs causes scheduling delays. Tune CNI env variables and instance selection to increase warm IP availability.

⚙️ **Purpose / How it works**
Key CNI env vars control warm behavior: `WARM_IP_TARGET`, `WARM_ENI_TARGET`, `WARM_PREFIX_TARGET`, and `MINIMUM_IP_TARGET` (depending on CNI version). For prefix-delegation mode, `WARM_PREFIX_TARGET` matters.

🧩 **Commands / Config & Tuning**

1. **Inspect current aws-node env**

```bash
kubectl -n kube-system get ds aws-node -o yaml | yq '.spec.template.spec.containers[0].env'
```

2. **Example tuning (daemonset env edits)**

```bash
kubectl -n kube-system set env daemonset/aws-node WARM_ENI_TARGET=2 WARM_IP_TARGET=20
```

3. **Enable prefix delegation (if not enabled)**

```bash
kubectl -n kube-system set env daemonset/aws-node ENABLE_PREFIX_DELEGATION=true
# Also configure WARM_PREFIX_TARGET
kubectl -n kube-system set env daemonset/aws-node WARM_PREFIX_TARGET=1
```

4. **Use larger instance types or instance families**
   Larger instances support more ENIs/IPs → more pod density and room for warm pools.

5. **Tune `MAX_ENI` and `MAX_IP_PER_ENI` via instance choice**
   Switch to instance types with higher ENI/IP quotas.

📋 **Tuning guidance**

| Scenario                                | Tune                                                         |
| --------------------------------------- | ------------------------------------------------------------ |
| Sudden pod spikes                       | Increase `WARM_IP_TARGET`                                    |
| High pod density with prefix-delegation | Enable `ENABLE_PREFIX_DELEGATION` + set `WARM_PREFIX_TARGET` |
| Low ENI quota per node                  | Use larger instance types with higher ENIs                   |

✅ **Best Practices**

* Prefer **prefix delegation** for large clusters (more efficient).
* Monitor `AvailableIPs` metrics from `aws-vpc-cni` and alert when low.
* Right-size `WARM_IP_TARGET` for steady-state vs burst patterns.
* Use instance families with higher ENI/IP quotas for dense packing.
* Keep CNI addon updated (use EKS add-ons) to get efficient IP allocation features.

💡 **In short**
Increase warm pool targets (`WARM_IP_TARGET`, `WARM_PREFIX_TARGET`), enable prefix delegation, and/or use instance types with higher ENI/IP capacity to avoid running out of warm IPs.

---

## Q178: Your application experiences connection resets during pod restarts. How do you implement graceful shutdown?

🧠 **Overview**
Connection resets during restarts occur when pods terminate abruptly. Graceful shutdown requires application-level handling of `SIGTERM`, appropriate Kubernetes `terminationGracePeriodSeconds`, and draining/connection draining at ingress.

⚙️ **Purpose / How it works**

* Kubernetes sends `SIGTERM` to the main container, waits `terminationGracePeriodSeconds` for shutdown before SIGKILL. During that time, the pod should stop accepting new requests, finish in-flight work, and close connections. Readiness probe must be removed so ingress stops sending traffic.

🧩 **Implementation Steps & Examples**

1. **Handle SIGTERM in application**

* Example Node.js:

```js
process.on('SIGTERM', async () => {
  server.close(() => process.exit(0));
  // finish ongoing requests or flush
});
```

2. **Use readiness probe + on-shutdown to mark not ready**

* Set `preStop` hook to delay or call health endpoint to mark pod unready:

```yaml
lifecycle:
  preStop:
    exec:
      command: ["sh", "-c", "curl -s -X POST http://127.0.0.1:8080/health/disable; sleep 10"]
readinessProbe:
  httpGet: { path: /health, port: 8080 }
```

3. **Set termination grace period**

```yaml
spec:
  terminationGracePeriodSeconds: 120
```

4. **Ingress/Service drain & connection draining**

* ALB/NLB: configure **deregistration delay** to allow in-flight connections to finish. For ALB, set target group `deregistration_delay` (default 300s).
* For Envoy/Ingress, ensure `drain` time matches pod grace period.

5. **Avoid immediate SIGKILL**

* Ensure app can shut down within grace period; increase if long-running tasks.

📋 **Checklist**

| Action                                 | Purpose                            |
| -------------------------------------- | ---------------------------------- |
| Implement SIGTERM handler              | Finish requests cleanly            |
| Use preStop to set not-ready           | Stop receiving new traffic quickly |
| Increase terminationGracePeriodSeconds | Allow graceful cleanup time        |
| Configure LB deregistration delay      | Prevent early client disconnects   |
| Ensure readiness probe reacts quickly  | Remove pod from service ASAP       |

✅ **Best Practices**

* Keep readiness probe and preStop in sync — preStop should quickly make pod not-ready.
* Use `terminationGracePeriodSeconds` slightly longer than LB deregistration time.
* Make shutdown idempotent; checkpoint long jobs.
* Test shutdown flow regularly with load tests.

💡 **In short**
Handle `SIGTERM`, mark pod not-ready early (preStop), set adequate `terminationGracePeriodSeconds`, and align ingress/LB deregistration to avoid connection resets.

---

## Q179: PodDisruptionBudgets are preventing node draining during cluster maintenance. How do you resolve this?

🧠 **Overview**
PDBs protect availability by limiting voluntary disruptions. If they block node drains, either PDBs are too strict or you need to sequence maintenance. Fix via temporary PDB relaxation, targeted drains, or scheduling maintenance windows.

⚙️ **Purpose / How it works**

* PDBs (`minAvailable` or `maxUnavailable`) prevent standard `kubectl drain` from evicting pods if eviction would violate PDB. For maintenance, you must ensure PDBs allow necessary disruptions or coordinate drain order.

🧩 **Strategies & Commands**

1. **Identify blocking PDBs**

```bash
kubectl get pdb -A
kubectl describe pdb <pdb-name> -n <ns>
# Check which pods are protected
kubectl get pods -l <selector> -n <ns>
```

2. **Option A — Temporarily increase allowed disruption**

* Patch PDB to allow eviction (e.g., lower `minAvailable` or raise `maxUnavailable`):

```bash
kubectl patch pdb my-pdb -n ns -p '{"spec":{"minAvailable":0}}'
```

* After maintenance, restore original values.

3. **Option B — Drain nodes with `--force` (last resort)**

```bash
kubectl drain <node> --ignore-daemonsets --delete-emptydir-data --force
```

**Warning:** can cause application downtime.

4. **Option C — Use targeted/rolling drains**

* Drain nodes gradually so PDBs remain satisfied:

```bash
kubectl drain <node1> && wait && kubectl drain <node2>
```

* Evict non-critical pods first (use `safe-to-evict` annotation) and cordon nodes selectively.

5. **Option D — Scale down non-critical workloads temporarily**

* For deployments with PDBs, scale replicas down/up with care.

6. **Plan & automation**

* Implement maintenance jobs that patch PDBs automatically with approval + audit trail.

📋 **Decision table**

| Situation                             | Recommended action                                               |
| ------------------------------------- | ---------------------------------------------------------------- |
| PDB too strict for urgent maintenance | Temporarily relax PDB                                            |
| Need zero downtime                    | Sequence drains across AZs and nodes carefully                   |
| Emergency (no time)                   | `kubectl drain --force` (accept downtime)                        |
| Regular maintenance                   | Schedule maintenance window and patch PDBs via CI with approvals |

✅ **Best Practices**

* Design PDBs to allow at least one disruption per AZ for rolling maintenance.
* Use labels/annotations to separate critical and non-critical pods (so PDBs apply only where needed).
* Automate safe PDB relaxation (with approvals) and restore.
* Test maintenance procedures in staging and document runbooks.

💡 **In short**
Either relax PDBs temporarily, sequence drains to keep PDBs satisfied, or (only as last resort) force-drain. Better: design PDBs and maintenance processes so routine drains don’t get blocked.

----    
## Q180: Your EKS control plane logs show authentication failures. What would you investigate?

🧠 **Overview**
Authentication failures mean clients (kubectl, controllers, kubelets, or cloud agents) are failing to authenticate to the API (IAM/oidc tokens, client certs, kubeconfig issues). Focus on the identity chain: who is calling, how they authenticate, and what the API server sees.

⚙️ **Purpose / How it works**

* EKS typically uses **IAM (aws-iam-authenticator)** or IAM-based `aws eks get-token` (exec) for users and **IRSA/OIDC** for pods. Failures arise from expired tokens, incorrect kubeconfig, mis-mapped IAM role → Kubernetes group mapping (`aws-auth`), or revoked/rotated credentials.

🧩 **Examples / Commands / Config snippets**

```bash
# Identify failing principal/actor from control plane logs (CloudWatch)
# (Check timestamp & source principal)

# Validate your kubeconfig / token
aws eks update-kubeconfig --name my-cluster --region ap-south-1
kubectl config view --minify
kubectl auth can-i --list --as=system:serviceaccount:ns:sa

# Test STS identity from pod or CI
kubectl exec -it <pod> -- aws sts get-caller-identity

# Check aws-auth ConfigMap mapping (for worker/role access)
kubectl -n kube-system get configmap aws-auth -o yaml

# Check OIDC provider exists for IRSA
aws eks describe-cluster --name my-cluster --query cluster.identity.oidc.issuer
```

📋 **Common causes & quick checks**

| Symptom                      | Likely check                                                  |
| ---------------------------- | ------------------------------------------------------------- |
| `Invalid token`              | Expired kubeconfig token / SSO token                          |
| `Unauthorized` for a pod     | ServiceAccount annotation or IAM trust policy mismatch (IRSA) |
| `user not found in aws-auth` | Missing role mapping in `aws-auth` ConfigMap                  |
| Intermittent auth            | Clock skew (node/CI), STS endpoint network issues             |

✅ **Best Practices**

* Use `aws eks update-kubeconfig` in automation; refresh SSO tokens if used.
* Validate IRSA trust policy `sub` matches `system:serviceaccount:<ns>:<sa>`.
* Keep `aws-auth` mappings in Git (GitOps) and audit changes.
* Rotate credentials with automation and monitor CloudTrail for `sts:AssumeRole` failures.
* Check node/CI system clocks; fix NTP/chrony if tokens fail sporadically.

💡 **In short**
Trace the failing principal → verify kubeconfig/token/IRSA trust and aws-auth mappings → fix expired tokens, trust policy `sub`, or missing role mappings.

---

## Q181: Karpenter is not provisioning nodes despite pending pods. What would you check?

🧠 **Overview**
Karpenter provisions nodes when pods are unschedulable. If it doesn’t, inspect its decision path: Provisioner config, IAM permissions, cluster constraints, scheduling restrictions on pods, and Karpenter controller logs.

⚙️ **Purpose / How it works**

* Karpenter watches unschedulable pods and creates EC2 instances using Provisioner CRD rules (instance types, zones, taints/tolerations). It requires proper IAM (IRSA) and sufficient capacity/quotas.

🧩 **Examples / Commands / Config snippets**

```bash
# Check Karpenter controller logs
kubectl -n karpenter logs deploy/karpenter

# See pending pods & why unschedulable
kubectl describe pod <pod>

# Inspect Provisioner
kubectl get provisioner -o yaml
kubectl describe provisioner <name>

# Common Karpenter issues to check:
# - Provisioner selectors don't match pod requirements (labels/annotations)
# - Pod requests require unsupported instance types (GPU/arch)
# - IAM role (IRSA) lacks ec2:RunInstances, iam:PassRole, ec2:CreateFleet
```

**Sample Provisioner (minimal)**

```yaml
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: default
spec:
  requirements:
    - key: node.kubernetes.io/instance-type
      operator: In
      values: ["m5.large","m5.xlarge"]
  provider:
    subnetSelector:
      karpenter.sh/discovery: my-cluster
    securityGroupSelector:
      karpenter.sh/discovery: my-cluster
  ttlSecondsAfterEmpty: 30
```

📋 **Checklist — what to inspect**

| Area               | What to check                                            |
| ------------------ | -------------------------------------------------------- |
| Karpenter logs     | Errors (capacity, permissions, API throttling)           |
| Provisioner config | Zone/subnet selectors, instance type constraints         |
| Pod requirements   | Requests/limits, nodeSelector, affinity, GPU requirement |
| IAM/IRSA           | `iam:PassRole`, `ec2:RunInstances`, `ec2:CreateFleet`    |
| Account limits     | EC2 instance quota, ENI/IP limits                        |

✅ **Best Practices**

* Ensure Provisioner allows a **wide instance type set** for flexibility.
* Give Karpenter an IAM role with least-privilege but necessary EC2 actions and `iam:PassRole`.
* Use mixed instance types and zones to improve capacity.
* Monitor Karpenter metrics/logs and set alerts for provisioning failures.

💡 **In short**
Check Karpenter logs, Provisioner rules vs pod constraints, IAM permissions, and AWS capacity/quotas — mismatch in any of these commonly prevents provisioning.

---

## Q182: Your EFS-mounted volumes are causing pod startup delays. How would you optimize?

🧠 **Overview**
EFS (NFS) can introduce latency at mount time and first-read (metadata) operations. Optimize by tuning mount options, using caching, parallelizing mounts, and minimizing synchronous metadata operations.

⚙️ **Purpose / How it works**

* Pods mount EFS via the EFS CSI driver. Delays often stem from DNS resolution of mount target, EFS throughput mode, EFS access patterns (many small files), or lack of caching.

🧩 **Examples / Commands / Config snippets**

```yaml
# PersistentVolumeClaim using EFS CSI
apiVersion: v1
kind: PersistentVolumeClaim
spec:
  storageClassName: efs-sc
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
```

**Mount options / CSI parameters**

* Use `tls` (secure) but tune `mountOptions` e.g., `rsize=1048576,wsize=1048576,noatime`.
* Use `transient` or performance-mode settings via EFS (throughput mode: bursting/provisioned).

**Cache approaches**

* Use a node-local cache sidecar (e.g., `cachefilesd`) or client-side caching (FSx for Lustre if high-throughput is required).
* For read-heavy workloads, consider **FSx for Lustre** with S3-backed dataset for high throughput and low latency.

📋 **Optimization checklist**

| Problem                 | Fix                                                                            |
| ----------------------- | ------------------------------------------------------------------------------ |
| Slow mounts (DNS)       | Ensure mount target DNS resolves quickly; use VPC + Route53 Resolver if needed |
| Many small file ops     | Use caching (sidecar) or switch to FSx Lustre                                  |
| High metadata latency   | Reduce metadata ops; bundle files; avoid heavy `ls` at startup                 |
| Insufficient throughput | Increase throughput (provisioned) or use caching                               |

✅ **Best Practices**

* Avoid heavy file-system walks or `stat` on startup.
* Pre-warm caches by starting a lightweight pre-warm job that accesses files.
* Use EFS lifecycle/throughput provisioning for consistent performance.
* Consider FSx for Lustre for high-performance training/ML workloads and use EFS for shared persistent config.

💡 **In short**
Tune EFS mount options, reduce metadata-heavy ops at startup, add caching or use FSx for high-throughput needs, and ensure fast DNS & mount target reachability.

---

## Q183: Pods cannot reach external internet despite NAT gateway being configured. What's wrong?

🧠 **Overview**
If NAT exists but pods lack outbound Internet, likely causes are route table not attached to the private subnet, wrong subnet selection for nodes, missing IGW, network ACLs or security group blocking, or lack of proper source/destination check configuration.

⚙️ **Purpose / How it works**

* Private subnets route 0.0.0.0/0 to NAT Gateway in a public subnet. Worker node ENIs or NAT gateway misconfig prevents egress if routing, SGs, or NACLs are misconfigured.

🧩 **Diagnostics & Commands**

```bash
# From a debug pod in cluster:
kubectl run -it --rm debug --image=alpine -- sh
# Inside pod:
nslookup google.com
curl -I https://example.com
ip route
```

Check AWS side:

* Verify **route table** for private subnets: `0.0.0.0/0 -> nat-xxxx`.
* Confirm subnets used by node ENIs are private subnets with correct route.
* Ensure **NAT Gateway** is healthy and in a public subnet that has IGW route.
* Check **Security Groups**: outbound rules on node SG allow 0.0.0.0/0 for required ports.
* Check **NACLs**: they are stateless and must allow ephemeral port ranges inbound/outbound.
* If using **VPC endpoints** (e.g., S3), ensure they don’t block other egress.
* Confirm **source/destination check** is enabled on NAT and disabled appropriately on NAT instances (for NAT instance setups).

📋 **Common failure points**

| Symptom                                 | Cause                                          |
| --------------------------------------- | ---------------------------------------------- |
| DNS resolves but TCP times out          | NACL or SG blocking ephemeral ports            |
| `No route to host`                      | Route table missing NAT route                  |
| Works occasionally                      | NAT Gateway exhausted (concurrent connections) |
| Private subnets using wrong route table | Node ENIs are in public subnet w/o SNAT        |

✅ **Best Practices**

* Use **NAT Gateways** (managed) in each AZ for resiliency.
* Ensure **private subnets** have `0.0.0.0/0` → NAT in their route table.
* Allow ephemeral port ranges (1024–65535) in NACLs for return traffic.
* Monitor NAT metrics and scale/replicate NAT Gateways per AZ.

💡 **In short**
Check private subnet route → NAT Gateway, IGW on public subnet, security groups and NACLs, and NAT health/throughput. Routing misconfiguration is usually the culprit.

---

## Q184: Your EKS cluster is experiencing etcd performance issues. How would you diagnose?

🧠 **Overview**
In EKS the etcd control plane is managed by AWS; you can’t access etcd directly, but you can diagnose symptoms (slow API calls, high latency, API server errors) that point to etcd pressure from excessive or heavy control-plane traffic (too many watches, big objects, or frequent writes).

⚙️ **Purpose / How it works**

* API server latency often maps to underlying etcd load. Common causes: high QPS from controllers/CI, too many large objects (ConfigMaps/Secrets with big data), frequent leader elections, or bursty reconciliation loops.

🧩 **Diagnostic steps & commands**

```bash
# Observe API server latency & errors (CloudWatch / EKS control-plane metrics)
# Check for high API request rates
# List high-count objects:
kubectl get configmap --all-namespaces --no-headers | wc -l
kubectl get secret --all-namespaces --no-headers | wc -l

# Search for frequent writes:
kubectl get events --sort-by='.lastTimestamp' -A | tail -n 200
# Check controllers / operators that do heavy writes (e.g., many CRD updates)
```

📋 **Mitigation checklist**

| Cause                     | Mitigation                                                                  |
| ------------------------- | --------------------------------------------------------------------------- |
| Many small/large objects  | Reduce object size; avoid storing large blobs in Secrets/ConfigMaps         |
| High QPS from automation  | Throttle CI & bots; batch reconciliations                                   |
| Many watches              | Use label selectors / field selectors; reduce unnecessary watchers          |
| Frequent leader elections | Ensure stable control plane (contact AWS Support if managed plane unstable) |

✅ **Best Practices**

* Avoid storing large binary data (images/backups) in Kubernetes objects.
* Use `kubectl proxy` or caching controllers rather than frequent full-list operations.
* Consolidate frequent writes into fewer batched operations.
* Use efficient informers (client-go shared informers) in custom controllers.
* If issues persist on managed EKS control plane, engage AWS Support with exact metrics/timestamps.

💡 **In short**
Look for control-plane overload: high API QPS, many objects, or noisy controllers. Reduce writes/watches, throttle clients, and engage AWS Support if managed etcd shows persistent slowness.

---

## Q185: Service endpoints are not being updated after pod replacement. How do you troubleshoot?

🧠 **Overview**
Service endpoints are populated by kube-proxy watching Endpoints/EndpointSlices. If endpoints don't update after pods change, check Service selectors, labels, EndpointSlice controller, kube-proxy, and health/readiness of pods.

⚙️ **Purpose / How it works**

* Service selects pods via label selectors. Endpoints/EndpointSlices reflect pods matching selectors and readiness. If pods are not ready or selectors don't match, endpoints won't update.

🧩 **Commands / Checks**

```bash
# Check service selector
kubectl get svc mysvc -o yaml

# Check pods labels match
kubectl get pods -l app=mypod -o wide

# Check Endpoints/EndpointSlices
kubectl get endpoints mysvc -o yaml
kubectl get endpointslices -l kubernetes.io/service-name=mysvc -o yaml

# Check pod readiness
kubectl describe pod <pod>   # readiness probe events

# Check kube-proxy logs on nodes (iptables/ipvs programming)
kubectl -n kube-system logs -l k8s-app=kube-proxy
```

📋 **Common reasons**

| Symptom                             | Cause                                           |
| ----------------------------------- | ----------------------------------------------- |
| Endpoints empty after pod ready     | Selector mismatch or pod not matching labels    |
| Endpoints not reflecting new pod IP | EndpointSlice controller failed or API lag      |
| Endpoints contain pods not ready    | Readiness probe not configured properly         |
| kube-proxy not programming rules    | kube-proxy crash or iptables/ipvs error on node |

✅ **Best Practices**

* Prefer **EndpointSlices** (modern) and ensure EndpointSlice controller healthy.
* Use `readinessProbe` so only healthy pods are in endpoints.
* Ensure deployment updates maintain labels used by Service selector.
* Monitor kube-proxy and EndpointSlice controller metrics.

💡 **In short**
Verify Service selectors match pod labels, pods are Ready (readiness probe), and EndpointSlices/kube-proxy are functioning — selector or readiness mismatches are the most common causes.

---

## Q186: Your application experiences split-brain scenarios after network partitions. How do you prevent this?

🧠 **Overview**
Split-brain occurs when multiple components think they are primary after partitioning. Avoid by designing for consensus (leader election), quorum-based storage, and isolation-aware architectures.

⚙️ **Purpose / How it works**

* Use distributed systems patterns: leader election (with etcd/raft), quorum writes for databases, fencing tokens, and avoiding multi-primary writes when partitions occur.

🧩 **Strategies & Examples**

* **Leader election** for controllers/services using Kubernetes leases:

```go
// use client-go leaderelection package in controllers
```

* Use databases with **quorum/consensus** (RDS Multi-AZ, Aurora, Cassandra with quorum writes) so writes require majority.
* Implement **fencing** (lock tokens or `leaseId`) before allowing writes.
* Prefer **single-writer** designs (leader + followers) and failover procedures that verify leadership with quorum.

📋 **Design checklist**

| Aspect          | Recommendation                                                 |
| --------------- | -------------------------------------------------------------- |
| Coordination    | Use Kubernetes leader election (leases)                        |
| Data stores     | Use quorum-based replication (avoid async only)                |
| Failover        | Use health checks + fencing, never auto-promote without quorum |
| Cache coherence | Use strongly-consistent cache invalidation or central store    |

✅ **Best Practices**

* Avoid split-brain by relying on **consensus protocols**, not ad-hoc health checks.
* Design failover processes that **verify majority** before promoting new leaders.
* Test network partitions in staging with chaos engineering.
* Use consistent timeouts and leader-election TTLs tuned to network characteristics.

💡 **In short**
Implement leader election + quorum-based storage/fencing and test partition scenarios — don’t rely on naive primary promotion logic.

---

## Q187: Init containers are failing and preventing main containers from starting. How do you debug?

🧠 **Overview**
Init containers run sequentially before app containers. If any init container fails, the pod stays in Init state. Debug by inspecting init container logs, exit codes, resource constraints, images, or volume mounts.

⚙️ **Purpose / How it works**

* Kubernetes retries init containers until success (backoff policy). Failure reasons include command errors, missing dependencies, permission/volume issues, or insufficient resources.

🧩 **Commands / Troubleshooting**

```bash
kubectl describe pod <pod>
kubectl logs <pod> -c <init-container-name>
kubectl logs <pod> -c <init-container-name> --previous  # if restarted
# Check init container exit code / events
kubectl get pods -o wide
```

Common failure checks:

* **Command**: wrong entrypoint or script errors — view logs.
* **Images**: imagePullBackOff — check registry auth & tags.
* **Volume mounts & permissions**: init container may lack rights to write to a mounted PV.
* **Env/Secrets**: missing env vars or secret keys cause failures.
* **Resource limits**: init container can be OOMKilled — check `resources` and node capacity.

📋 **Quick fixes**

| Problem                    | Fix                                                     |
| -------------------------- | ------------------------------------------------------- |
| Script error               | Run command manually in debug pod to iterate            |
| Permission denied on mount | Ensure correct `securityContext` and volume permissions |
| Missing secret             | Confirm Secret exists & SA has access (IRSA)            |
| Image pull error           | Check image tag and node IAM/registry auth              |
| Too short timeout          | Increase init logic timeout or resource limits          |

✅ **Best Practices**

* Keep init containers simple and idempotent.
* Emit clear logs & exit codes for quick diagnosis.
* Give them modest resource requests and proper `securityContext`.
* Use `kubectl run --rm -it --image=...` to reproduce init commands interactively.

💡 **In short**
Inspect init container logs and pod events, check mounts/permissions, image pulls, environment, and resource limits — the init container log is usually the quickest path to the root cause.

---

## Q188: Your EKS nodes have mismatched security groups causing connectivity issues. How do you fix this?

🧠 **Overview**
EKS worker nodes require consistent security group rules to communicate with the control plane, cluster add-ons, and other nodes. If nodes have mismatched SGs (from multiple Launch Templates, MNGs, Karpenter provisioners), pod-to-pod or node-to-API communication may break.

⚙️ **Purpose / How it works**
Worker node SGs define allowed traffic for kubelet, API server communication, CNI traffic, and inter-node overlay/VPC networking. Mismatched SGs → dropped packets → DNS failures, CNI attachment errors, pod connectivity issues.

🧩 **Steps to Fix / Validate**

1. **List all SGs attached to nodes**

```bash
kubectl get nodes -o wide --show-labels
aws ec2 describe-instances --instance-ids <node-id> --query "Reservations[*].Instances[*].SecurityGroups"
```

2. **Verify expected SGs for MNG or custom LT**

* Managed Node Groups apply: `AmazonEKSNodeSecurityGroup` + additional SGs.
* Karpenter nodes: ensure Provisioner uses correct SG selector:

```yaml
provider:
  securityGroupSelector:
    karpenter.sh/discovery: <cluster-name>
```

3. **Ensure SG rules allow required ports**
   | Direction | Purpose | Ports |
   |---|---|---|
   | Node → API server | kubelet heartbeats | 443 |
   | Node ↔ Node | VPC CNI, kube-proxy | all traffic within worker SG |
   | Node → ECR | image pulls | 443 |
   | Node → ENI attachment API | AWS APIs | 443 |

4. **Fix by aligning SGs**

* Update Launch Template used by MNG.
* Patch Karpenter Provisioner with correct SG selectors.
* Recreate nodes if needed.

📋 **Common failure modes**

| Symptoms                    | Cause                                                 |
| --------------------------- | ----------------------------------------------------- |
| Nodes remain `NotReady`     | SG doesn’t allow API server traffic                   |
| Pods can’t reach other pods | Worker SGs not allowing inter-node communication      |
| CNI ENI errors              | SG missing required AWS API access (via endpoint/NAT) |

✅ **Best Practices**

* Use consistent discovery tags for SG auto-selection.
* Keep worker node SGs managed via IaC, not manually edited.
* Avoid mixing manually created nodes with MNG/Karpenter unless SGs are standardized.

💡 **In short**
Align all node security groups, ensure they allow API server & inter-node communication, and standardize SG selection via LT/MNG/Karpenter.

---

## Q189: The aws-auth ConfigMap was accidentally deleted. How do you recover cluster access?

🧠 **Overview**
`aws-auth` provides IAM → RBAC bindings. Deleting it blocks worker nodes and IAM users/roles from authenticating. Recovery requires a principal already having **direct EKS admin permissions** (IAM: `eks:AccessKubernetesApi`) or using AWS Console’s EKS “Access” feature (if enabled).

⚙️ **Purpose / How it works**

* `aws-auth` lives in `kube-system`.
* EKS control plane still trusts IAM, but without mappings → principal has no RBAC rights.

🧩 **Recovery Methods**

### **Method A: Using AWS Console "Cluster Access" (New EKS Access Control)**

If EKS access entries exist:

1. Go to EKS → Access.
2. Add your IAM user/role back as admin.
3. A new identity-based RBAC ConfigMap replaces `aws-auth`.

### **Method B: Using IAM role with cluster-admin rights (via EKS API)**

If you have an IAM principal with:

```
eks:AccessKubernetesApi
eks:DescribeCluster
```

Then:

```bash
aws eks update-kubeconfig --name <cluster>
kubectl apply -f aws-auth-backup.yaml
```

**Recreate aws-auth:**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::<acct>:role/EKSNodeRole
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
  mapUsers: |
    - userarn: arn:aws:iam::<acct>:user/admin
      username: admin
      groups:
        - system:masters
```

### **Method C: Using EKS bootstrap role (if it was bound previously)**

If EKS cluster creator IAM role still has admin access, update kubeconfig and recreate the ConfigMap.

📋 **If *no* IAM principal has access:**
You must open AWS Support (EKS control plane access recovery).

✅ **Best Practices**

* Store `aws-auth` in Git and manage via GitOps.
* Use EKS Access Control (recommended) to avoid accidental lockouts.
* Always keep at least two admin IAM principals.

💡 **In short**
Use an IAM principal with EKS API access to reapply `aws-auth`. If none exist, recover via EKS Access or AWS Support.

---

## Q190: Your application is experiencing higher than expected cross-AZ data transfer costs. How do you optimize?

🧠 **Overview**
Cross-AZ cost occurs when pods or services communicate across AZ boundaries. Fix involves co-locating dependent workloads, using topology constraints, smarter data placement, and optimizing service mesh/LB routing.

⚙️ **Purpose / How it works**
AWS charges for traffic leaving an AZ. Common causes: databases in one AZ, pods spread unevenly, NodePort/LoadBalancer routing, or service mesh always routing cross-AZ.

🧩 **Optimization Steps**

### **1. Co-locate workloads**

Use topology spread or affinity to ensure pods talk to local replicas:

```yaml
affinity:
  podAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
    - topologyKey: topology.kubernetes.io/zone
      labelSelector: { matchLabels: { app: backend } }
```

### **2. Use multi-AZ databases/caches**

* Use **Aurora Multi-AZ**, **Redis Multi-AZ**, or **Kafka multi-AZ**.
* Avoid single-AZ DB writes when consumers live in other AZs.

### **3. Fix cross-AZ Service routing**

* For NLB/ALB, enable **cross-zone load balancing** only if required; otherwise disable for same-AZ locality.
* Use **topology-aware hints**:

```yaml
service.kubernetes.io/topology-aware-hints: "auto"
```

### **4. Service Mesh tuning (Istio/App Mesh)**

* Enable locality-aware load balancing to prefer same-AZ endpoints:

```yaml
trafficPolicy:
  loadBalancer:
    localityLbSetting:
      enabled: true
```

### **5. Reduce data shuffling**

* Move stateful services close to data producers.
* Use local caching layers to minimize cross-AZ reads.

📋 **Common causes**

| Cause                                | Cost inflator                   |
| ------------------------------------ | ------------------------------- |
| ALB routing traffic to other AZ      | 2× cost (ingress + return)      |
| Data pipelines/ETL across AZs        | sustained high cross-AZ charges |
| Pods in one AZ calling DB in another | frequent queries, expensive     |

✅ **Best Practices**

* Keep latency-sensitive + data-heavy services in same AZ.
* Tune topology hints + anti-affinity rules.
* Implement locality-aware load balancing (service mesh or native hints).
* Use caching to reduce DB calls.

💡 **In short**
Co-locate pods and databases, tune LB/mesh routing for locality, and avoid single-AZ bottlenecks.

---

## Q191: Pods are being scheduled on nodes with insufficient resources despite requests being set. Why?

🧠 **Overview**
Usually caused by **resource overcommit**, **incorrect requests**, **burstable QoS**, **node-level reserved resources**, or **topology constraints** causing scheduler to place pods despite tight fit.

⚙️ **Purpose / How it works**
Scheduler looks at `requests`, not actual usage. If requests are low (underestimated), scheduler assumes node has room → CPU throttling/OOM occurs later.

🧩 **Why this happens**

1. **Requests undervalued**

```yaml
resources:
  requests:
    cpu: "10m"
    memory: "32Mi"
```

Scheduler thinks pod is tiny, packs many onto node.

2. **Node reserved resources not accounted**
   EKS allocates resources for kubelet/system:

```bash
cat /etc/kubernetes/kubelet/kubelet-config.json
```

This reduces real allocatable resource.

3. **Topology constraints force placement**
   PodAffinity/AntiAffinity or topologySpread can force placement on suboptimal nodes.

4. **Scheduler extender (HPA/CA) not in sync**
   Cluster Autoscaler scales only when pods are unschedulable; wrong requests make them “schedulable”.

📋 **Checklist**

| Symptom                   | Cause                              |
| ------------------------- | ---------------------------------- |
| Node pressure / OOM       | memory requests too low            |
| CPU throttling            | CPU requests too low               |
| “Schedulable but starved” | scheduler uses requests not limits |

🧩 **Fix**

* Right-size requests based on historical usage:

```promql
histogram_quantile(0.99, rate(container_cpu_usage_seconds_total[5m]))
```

* Increase request to reflect baseline load.
* Separate noisy workloads via taints.
* Tune topology constraints.

✅ **Best Practices**

* Use vertical autoscaling (VPA) in recommendation-only mode.
* Regularly tune requests using Prometheus metrics.
* Avoid tiny placeholder requests like `10m`.

💡 **In short**
Scheduler relies on requests, not actual usage — underestimate them and pods get packed onto insufficient nodes.

---

## Q192: Your Horizontal Pod Autoscaler is scaling up and down rapidly (flapping). How do you stabilize it?

🧠 **Overview**
HPA flapping is caused by noisy metrics, short evaluation windows, or sudden demand spikes. Stabilize with proper cooldown windows, stable windows, smoothing, and correct target utilization.

⚙️ **Purpose / How it works**

* HPA checks metrics periodically and modifies replica count. Without smoothing, small metric fluctuations cause oscillation.

🧩 **Stabilization Techniques**

1. **Enable stabilization window**

```yaml
behavior:
  scaleDown:
    stabilizationWindowSeconds: 300
```

2. **Use longer averaging window (Prometheus Adapter)**

```yaml
--horizontal-pod-autoscaler-downscale-stabilization=5m
```

3. **Set reasonable CPU/memory targets**
   Avoid tight thresholds like `50%`; use `70–80%`.

4. **Use custom metrics smoothing**
   Prometheus + adapter:

```promql
avg(rate(http_requests_total[2m]))
```

5. **Prevent over-reacting to spikes**
   Use `scaleUp` policies:

```yaml
scaleUp:
  policies:
  - type: Percent
    value: 50
    periodSeconds: 60
```

📋 **Common causes**

| Cause                           | Fix                                 |
| ------------------------------- | ----------------------------------- |
| No stabilization window         | Configure scaleDown stabilization   |
| Spiky metrics                   | Smooth via PromQL / moving averages |
| Too aggressive scaling policies | Add rate limits / cooldowns         |
| Low target utilization          | Increase target %                   |

✅ **Best Practices**

* Always set stabilization windows (scaleDown).
* Smooth input metrics using PromQL.
* Use percentage-based scale policies to limit drastic steps.
* Combine HPA with Cluster Autoscaler for node expansion.

💡 **In short**
Use stabilization windows, metric smoothing, and better scaling policies to prevent oscillation.

---

## Q193: External-dns is not creating Route53 records for services. What would you troubleshoot?

🧠 **Overview**
ExternalDNS syncs Kubernetes Services/Ingress to DNS providers (Route53). Failures come from IAM permission issues, missing annotations, unsupported Service types, or namespace RBAC issues.

⚙️ **Purpose / How it works**
ExternalDNS watches Services/Ingress resources with DNS annotations and updates Route53 hosted zones via IAM credentials.

🧩 **Troubleshooting Steps**

1. **Check ExternalDNS logs**

```bash
kubectl -n external-dns logs deploy/external-dns
```

2. **Verify annotations on Service/Ingress**
   E.g., Service:

```yaml
metadata:
  annotations:
    external-dns.alpha.kubernetes.io/hostname: api.example.com
```

3. **Ensure Service type is supported**

* Supported: `LoadBalancer`, `NodePort` (with `--publish-internal-services`).
* For ALB ingress, ensure Ingress resources have correct rules.

4. **Check IAM permissions for ExternalDNS (IRSA)**
   Required:

```
route53:ChangeResourceRecordSets
route53:ListHostedZones
route53:ListResourceRecordSets
```

5. **Check Hosted Zone matching**

* Domain in annotation must match an existing Route53 hosted zone.
* Check private zone vs public zone mismatch.

6. **Check RBAC permissions**
   Ensure external-dns service account can read Services/Ingress:

```bash
kubectl auth can-i get services --as=system:serviceaccount:external-dns:external-dns
```

📋 **Common failures**

| Symptom                      | Cause                                                    |
| ---------------------------- | -------------------------------------------------------- |
| Logs: “AccessDenied”         | IAM policy missing `ChangeResourceRecordSets`            |
| No logs of service detection | RBAC prevents listing svc/ingress                        |
| No hosted zone found         | Wrong domain or incorrect zone (private/public mismatch) |
| Ingress resources ignored    | Missing ALB ingress annotations                          |

✅ **Best Practices**

* Use IRSA for ExternalDNS IAM access.
* Keep DNS annotations in IaC.
* Monitor Route53 API rate limits.
* Use ExternalDNS policy mode “sync” for authoritative mapping.

💡 **In short**
Check ExternalDNS logs, IAM permissions, service/ingress annotations, and hosted zone alignment. Most failures are annotation or IAM issues.

---

## Q194: Your EKS cluster has inconsistent behavior across nodes with the same configuration. How do you identify the issue?

🧠 **Overview**
Inconsistent behavior across “identical” nodes usually means something drifted: different AMIs, different kubelet configs, CNI inconsistency, outdated DaemonSets, or node-level OS/kernel differences.

⚙️ **Purpose / How it works**
Nodes should behave uniformly—if not, kubelet, CNI, kernel, or DaemonSet agents may differ. Detect drift by comparing node metadata, AMIs, versions, kernel, kubelet config, and running DaemonSets.

🧩 **Diagnostic Steps**

1. **Check node details**

```bash
kubectl get nodes -o wide --show-labels
kubectl describe node <node>
```

2. **Compare AMIs / Launch Template versions**

```bash
aws ec2 describe-instances --instance-ids <id> --query "Reservations[].Instances[].ImageId"
```

Nodes may be from different LC/LT versions.

3. **Check kubelet configuration**

```bash
journalctl -u kubelet
cat /etc/kubernetes/kubelet/kubelet-config.json
```

4. **Check CNI plugin versions**

```bash
kubectl -n kube-system get ds aws-node -o yaml | grep image:
```

Nodes may run different plugin version if rollout failed.

5. **Check DaemonSets (monitoring, service mesh, logging, etc.)**

```bash
kubectl -n kube-system get ds -o wide
```

6. **Check kernel versions**

```bash
uname -r
```

7. **Look for node taints**

```bash
kubectl get nodes --show-labels
kubectl describe node <node> | grep Taint
```

📋 **Common causes**

| Symptom                    | Cause                             |
| -------------------------- | --------------------------------- |
| Only some nodes fail CNI   | DS update stuck on specific nodes |
| Workloads fail differently | Different AMI, missing libraries  |
| Different performance      | Kernel/OS patch difference        |

✅ **Best Practices**

* Enforce **Launch Template version pinning**.
* Use **managed node groups** and avoid manual node provisioning.
* Monitor node drift using AWS Config / Karpenter drift detection.
* Redeploy nodes in rolling fashion after AMI or DS updates.

💡 **In short**
Compare node AMIs, kubelet/CNI versions, DaemonSets, and kernel; drift in any of these creates inconsistent behavior.

---

## Q195: Pods are failing to mount secrets from AWS Secrets Manager. What would you check?

🧠 **Overview**
Mounting AWS Secrets Manager secrets requires the Secrets Store CSI driver + AWS provider + IRSA permissions. Failures usually stem from IRSA misconfig, missing provider installation, wrong secret ARNs, or network restrictions.

⚙️ **Purpose / How it works**
Secrets Store CSI driver fetches secrets using the pod’s IAM role and mounts them as files. Without proper permissions, token audience, trust policy, or provider CRDs, mounts fail.

🧩 **Troubleshooting Steps**

1. **Check CSI driver pods**

```bash
kubectl -n kube-system get pods | grep csi
kubectl -n kube-system logs <csi-driver-pod>
```

2. **Check SecretProviderClass**

```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
spec:
  provider: aws
  parameters:
    objects: |
      - objectName: "my-secret"
        objectType: "secretsmanager"
```

3. **Validate IAM via IRSA**

* Pod’s service account must have:

```
secretsmanager:GetSecretValue
```

Check:

```bash
aws sts get-caller-identity  # via pod
```

4. **Verify trust policy**
   Trust must match:

```
"sub": "system:serviceaccount:<ns>:<sa>"
```

5. **Check Secret ARN / region**

* Ensure ARN exists and region matches cluster.

6. **Check network**

* Secrets Manager calls require outbound HTTPS to AWS APIs.

📋 **Common causes**

| Issue                             | Fix                                   |
| --------------------------------- | ------------------------------------- |
| SecretProviderClass misconfigured | Correct objectName/objectType         |
| IRSA not applied                  | Recreate pod or annotate SA correctly |
| Wrong secret ARN                  | Correct ARN and region                |
| CSI driver not installed          | Reinstall via helm or EKS addon       |

✅ **Best Practices**

* Validate IRSA permissions using `sts get-caller-identity`.
* Use least-privilege IAM roles for secrets access.
* Keep SecretProviderClass configs in Git.
* Prefer CSI driver (not Kubernetes Secrets) for security-sensitive workloads.

💡 **In short**
Check CSI driver, IRSA permissions, trust policy `sub`, secret ARN/region, and outbound access.

---

## Q196: Your service mesh is causing certificate validation errors. How would you debug?

🧠 **Overview**
Service meshes (Istio/App Mesh/Linkerd) use mTLS; certificate errors indicate mismatch in trust bundle, expired certs, wrong SAN fields, or mis-synced sidecars.

⚙️ **Purpose / How it works**
Sidecars validate peer certificates via mesh-issued CA. If workload identity isn’t matching expected SPIFFE ID or cert rotation fails, requests fail.

🧩 **Debug Steps**

1. **Check sidecar logs (Envoy)**

```bash
kubectl logs <pod> -c istio-proxy
```

Look for: `CERTIFICATE_VERIFY_FAILED`, `x509: certificate is not valid for…`.

2. **Check mTLS policy & PeerAuthentication**

```bash
kubectl get peerauthentication -A
kubectl get destinationrule -A
```

3. **Check trust bundle**
   Ensure root CA in mesh matches rotated CA:

```bash
istioctl proxy-config secret <pod>
```

4. **Check workload identity (SPIFFE)**

```bash
istioctl proxy-config identity <pod>
```

5. **Check cert rotation**
   Mesh certs typically rotate every ~24 hours; verify rotation did not stall.

6. **Check mesh sidecar injection**

```bash
kubectl get pods -n ns -o json | jq '.[].spec.containers[].name'
```

📋 **Possible Root Causes**

| Symptom               | Cause                                   |
| --------------------- | --------------------------------------- |
| Expired certs         | Mesh certificate rotation stuck         |
| SAN mismatch          | Wrong trust domain / namespace mismatch |
| One-way TLS only      | PeerAuthentication misaligned           |
| Wrong DestinationRule | Enforcing strict mTLS unexpectedly      |

✅ **Best Practices**

* Monitor cert rotation and Envoy health.
* Keep mesh control plane version consistent across nodes.
* Use strict mTLS only after confirming workloads support it.
* Rotate CA carefully following mesh documentation.

💡 **In short**
Check Envoy logs → mTLS policies → CA/trust bundle → cert SAN/SPIFEE identity → cert rotation.

---

## Q197: EKS pod security policies are preventing legitimate pods from running. How do you adjust them?

🧠 **Overview**
PodSecurityPolicies (deprecated) or Pod Security Standards (PSS) enforce safety constraints. If legitimate workloads are blocked, adjust allowed capabilities, security contexts, or namespace-level policies.

⚙️ **Purpose / How it works**
PSP/PSS validate pod specs before scheduling. Any mismatch (privileged mode, hostNetwork, volume types, capabilities) results in rejection.

🧩 **Debug Steps**

1. **Check events**

```bash
kubectl get events -A | grep -i denied
```

2. **Check PSP / PSS policies**

```bash
kubectl get psp
kubectl get podsecurity -A
```

3. **Patch policies or apply exceptions**
   Example PSP update to allow required capabilities:

```yaml
allowedCapabilities:
- NET_ADMIN
```

4. **Move workload to appropriate namespace level**
   PSS example:

```bash
kubectl label ns prod pod-security.kubernetes.io/enforce=baseline
```

5. **Use RBAC to bind service accounts to PSPs**

```yaml
roleRef:
  kind: ClusterRole
  name: eks-psp-privileged
subjects:
- kind: ServiceAccount
  name: app-sa
  namespace: app
```

📋 **Common restrictions causing block**

| Field        | Restriction                       |
| ------------ | --------------------------------- |
| privileged   | disallowed by restricted policies |
| hostNetwork  | restricted disallows it           |
| hostPath     | often forbidden                   |
| capabilities | NET_ADMIN, SYS_ADMIN not allowed  |

✅ **Best Practices**

* Use PSS over PSP.
* Apply restrictive policies globally, exceptions per namespace.
* Document required capabilities and approve via GitOps.
* Avoid privileged containers unless truly needed.

💡 **In short**
Check deny events, adjust PSP/PSS or namespace labels, and bind proper policies via RBAC.

---

## Q198: Your cluster has orphaned resources after failed deployments. How do you clean them up?

🧠 **Overview**
Orphaned objects (PVCs, PVs, LoadBalancers, ReplicaSets, pods, CRDs) occur after interrupted or flawed deployments. Clean up using label-based search, ownerReferences inspection, and IaC drift tools.

⚙️ **Purpose / How it works**
Kubernetes garbage collector removes objects with proper ownerReferences. If references are missing or helm/ArgoCD failed mid-deployment, cleanup is manual or via CI.

🧩 **Cleanup Steps**

1. **List orphaned ReplicaSets / pods**

```bash
kubectl get rs -A
kubectl get pods -A --field-selector 'status.phase!=Running'
```

2. **Check ownerReferences**

```bash
kubectl get rs <rs> -o json | jq .metadata.ownerReferences
```

3. **Cleanup LB Services**

```bash
kubectl delete svc <svc>
aws elbv2 describe-load-balancers --query ...
```

4. **Delete unused PVCs/PVs**

```bash
kubectl get pvc,pv
kubectl delete pvc <pvc>
```

5. **Helm cleanup**

```bash
helm list -A
helm uninstall <release> -n <ns>
```

6. **GitOps cleanup (ArgoCD/Flux)**

* Sync app
* Or manually remove orphaned resources:

```bash
argocd app diff myapp
argocd app delete myapp --cascade
```

7. **Use tools**

* `kubectl prune`
* ArgoCD automated pruning
* Terraform `-target` cleanup or drift detection.

📋 **Common leftover resources**

| Type   | Root cause                                   |
| ------ | -------------------------------------------- |
| PV/PVC | StatefulSet deleted before PVC               |
| LB     | Service type LoadBalancer deleted improperly |
| CRDs   | Removed charts but left CRDs                 |

✅ **Best Practices**

* Use GitOps/Helm with consistent ownership.
* Run periodic orphan cleanup job (CI) using labels.
* Never delete stateful workloads without first deleting PVCs (if needed).

💡 **In short**
Identify resources missing ownerReferences, delete PVC/LB leftovers, and rely on Helm/GitOps pruning to prevent future drift.

---

## Q199: Network throughput is significantly lower than expected for pods. What would you investigate?

🧠 **Overview**
Low throughput usually stems from instance ENI limits, CNI bottlenecks, pod placement, kernel params, or overloaded nodes. Diagnose both node-level and pod-level network paths.

⚙️ **Purpose / How it works**
Pods use the primary ENI or prefix-delegated ENIs for traffic. Throughput depends on instance type, network mode, and CNI health.

🧩 **Investigation Steps**

1. **Check instance type network bandwidth**

```bash
aws ec2 describe-instance-types --instance-types m5.large
```

Some instances provide limited throughput.

2. **Check CNI mode**

* If prefix delegation is disabled, ENI-per-pod model may throttle.

3. **Check pod-to-pod path**

```bash
iperf3 -s
iperf3 -c <pod-ip>
```

4. **Check kernel/sysctl settings**

```bash
sysctl net.core.*
sysctl net.ipv4.*
```

5. **Check node load**

```bash
kubectl top node
```

High CPU can constrain network throughput.

6. **Check network queues**

```bash
ethtool -S eth0
```

7. **Check encapsulation overhead (service mesh / overlay)**

* Service mesh sidecars add latency & reduce throughput (~10–20%).

8. **Check AWS throttling events**

* CloudWatch metrics: `NetworkPacketsIn/Out`, `NetworkThroughputExceeded`.

📋 **Common root causes**

| Issue                     | Impact                           |
| ------------------------- | -------------------------------- |
| Small instance (m5.large) | ~10 Gbps max, shared across pods |
| CNI issues                | Packet drops, ENI contention     |
| Mesh/iptables overhead    | Additional latency per hop       |
| CPU throttling            | Less cycles for network stack    |

✅ **Best Practices**

* Choose instance families with high network performance.
* Enable prefix delegation for more efficient IP allocation.
* Minimize iptables chain length (CNI tuning).
* Keep nodes below 70% CPU utilization.
* Offload heavy traffic to NLB or service mesh gateways.

💡 **In short**
Check instance network limits, CNI overhead, node load, kernel settings, and service mesh impact.

---

## Q200: Your EKS cluster experienced a complete outage and needs recovery. What's your recovery procedure?

🧠 **Overview**
Full-cluster outages require a structured disaster recovery plan: restore control plane access, node pools, workloads, storage, and cluster state (manifests). Success depends on GitOps/IaC and backups.

⚙️ **Purpose / How it works**
EKS control plane is managed by AWS, so recovery focuses on: re-establishing control plane reachability, rebuilding worker nodes, reapplying manifests, and restoring stateful data.

🧩 **Recovery Procedure**

### **1. Validate control plane availability**

```bash
aws eks describe-cluster --name <cluster>
```

If unavailable, open AWS Support case.

### **2. Rebuild worker nodes**

* Recreate Managed Node Groups or Karpenter Provisioners.
* Ensure correct IAM roles, SGs, subnets, bootstrap.

### **3. Reapply GitOps/IaC**

* Redeploy all manifests:

```bash
kubectl apply -k ./clusters/prod
```

or Helm/ArgoCD sync:

```bash
argocd app sync --all
```

### **4. Restore data for Stateful workloads**

* Restore EBS snapshots → PVs.
* Restore EFS backups.
* Restore database from RDS snapshots if required.

### **5. Validate networking**

* Ensure CNI add-ons running (`aws-node`, `kube-proxy`, `coredns`).
* Fix ENI/IP shortages or SG issues.

### **6. Validate add-ons**

* Reinstall EKS add-ons (VPC CNI, CoreDNS, kube-proxy):

```bash
aws eks update-addon --cluster-name prod --addon-name vpc-cni
```

### **7. Validate cluster-wide health**

```bash
kubectl get nodes
kubectl get pods -A
kubectl get events -A
```

### **8. Post-recovery hardening**

* Implement cluster backups (Velero).
* Snapshot critical PVs regularly.
* Move to GitOps if not already using it.
* Test failover and DR plans quarterly.

📋 **Key dependencies**

| Area        | Restore                    |
| ----------- | -------------------------- |
| Workloads   | GitOps/Helm                |
| Data        | PV snapshots/EFS backups   |
| Node groups | MNG/Karpenter IaC          |
| Add-ons     | EKS Add-ons or helm charts |

✅ **Best Practices**

* Use Velero for backup/restore of Kubernetes objects + PVs.
* Run GitOps for complete cluster-state recreation.
* Maintain multi-AZ and multi-region DR strategy for critical apps.

💡 **In short**
Recreate nodes, reapply manifests (GitOps/IaC), restore stateful data, validate add-ons/networking, and harden cluster with backups & DR processes.

---

