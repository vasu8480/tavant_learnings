# Kubernetes

## Q: What is Kubernetes?

### 🧠 Overview

**Kubernetes (K8s)** is an **open-source container orchestration platform** that automates the **deployment, scaling, and management** of containerized applications.
It abstracts underlying infrastructure (VMs, cloud, bare metal) and ensures apps run **reliably and efficiently** across distributed systems.

---

### ⚙️ Purpose / How It Works

Kubernetes manages a **cluster** of nodes and **schedules containers (Pods)** onto them based on resource requirements and policies.

**Core functions:**

* **Orchestration:** Deploy and manage containerized workloads (Docker, containerd).
* **Scaling:** Automatically scale Pods up/down (HPA, VPA).
* **Self-healing:** Restarts failed Pods, replaces unhealthy nodes automatically.
* **Load balancing:** Distributes traffic via Services or Ingress.
* **Rolling updates:** Zero-downtime application updates.
* **Declarative management:** Desired state defined in YAML manifests.

---

### 🧩 Examples / Commands / Config Snippets

#### 1️⃣ Simple Pod Example

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

Deploy:

```bash
kubectl apply -f nginx-pod.yaml
kubectl get pods
```

---

#### 2️⃣ Deployment (Manages ReplicaSets)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
```

---

#### 3️⃣ Service (Expose Pods)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  type: ClusterIP
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
```

---

### 📋 Kubernetes Components (High-Level)

| Component                   | Type          | Description                                         |
| --------------------------- | ------------- | --------------------------------------------------- |
| **Pod**                     | Workload      | Smallest deployable unit (1+ containers).           |
| **Deployment**              | Controller    | Manages desired state, rolling updates.             |
| **Service**                 | Networking    | Stable endpoint exposing Pods.                      |
| **Ingress**                 | Networking    | Routes HTTP/S traffic to Services.                  |
| **ConfigMap / Secret**      | Data          | Inject configuration or secrets.                    |
| **Node**                    | Worker        | Machine running containers (via Kubelet).           |
| **Kube-scheduler**          | Control plane | Assigns Pods to Nodes.                              |
| **Kube-controller-manager** | Control plane | Ensures cluster desired state.                      |
| **etcd**                    | Control plane | Key-value store for cluster state.                  |
| **API Server**              | Control plane | Central communication hub (kubectl interacts here). |

---

### ✅ Best Practices

* Use **Deployments**, not Pods, for production workloads.
* Separate **config/secrets** from images using ConfigMaps and Secrets.
* Enforce **RBAC** for access control.
* Use **Namespaces** for isolation (dev/stage/prod).
* Implement **liveness/readiness probes** for health checks.
* Monitor with **Prometheus + Grafana**, and log with **ELK or EFK** stacks.
* Use **NetworkPolicies** to restrict pod-to-pod traffic.
* Keep **resource limits/requests** defined for each container.

---

### 💡 In short

* **Kubernetes = container orchestrator** for automating deploy, scale, and heal.
* It manages **Pods** across a **cluster of nodes**, ensuring apps stay available.
* Think of it as “the OS for your containers” — declarative, scalable, and self-healing.

---
## Q: What are Pods in Kubernetes?

---

### 🧠 Overview

A **Pod** is the **smallest deployable unit** in Kubernetes — it represents **one or more containers** that run together on the same node and share **network and storage resources**.
Pods provide an abstraction over containers, allowing Kubernetes to schedule, restart, and manage them as a single logical unit.

---

### ⚙️ Purpose / How It Works

* Each Pod runs **one or more tightly coupled containers** (e.g., app + sidecar).
* Containers inside a Pod share:

  * **Network namespace** → same IP and port space.
  * **Volumes** → shared storage.
* Pods are **ephemeral** — if a Pod dies, Kubernetes replaces it automatically (usually via a controller like a Deployment).
* You don’t usually create Pods directly in production — instead, you use higher-level controllers (Deployments, StatefulSets, DaemonSets) that manage Pods.

---

### 🧩 Examples / YAML Snippets

#### 1️⃣ Single-Container Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: web
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

Deploy and verify:

```bash
kubectl apply -f nginx-pod.yaml
kubectl get pods
kubectl describe pod nginx-pod
```

---

#### 2️⃣ Multi-Container Pod (Sidecar Pattern)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-sidecar
spec:
  containers:
  - name: main-app
    image: myorg/app:latest
    ports:
    - containerPort: 8080
  - name: log-agent
    image: fluentd:latest
    volumeMounts:
    - name: logs
      mountPath: /var/log/app
  volumes:
  - name: logs
    emptyDir: {}
```

✅ The `main-app` and `log-agent` share logs via the same volume.

---

### 📋 Pod Lifecycle States

| Phase         | Description                                           |
| ------------- | ----------------------------------------------------- |
| **Pending**   | Pod accepted but waiting for resources or image pull. |
| **Running**   | Containers are up and healthy.                        |
| **Succeeded** | All containers exited successfully.                   |
| **Failed**    | One or more containers exited with error.             |
| **Unknown**   | Node unreachable or status fetch failed.              |

---

### 📋 Common Pod Commands

| Command                             | Description                                   |
| ----------------------------------- | --------------------------------------------- |
| `kubectl get pods`                  | List Pods                                     |
| `kubectl describe pod <name>`       | Detailed info and events                      |
| `kubectl logs <pod>`                | Get container logs                            |
| `kubectl exec -it <pod> -- /bin/sh` | Exec into container                           |
| `kubectl delete pod <name>`         | Delete Pod (K8s will recreate via controller) |

---

### ✅ Best Practices

* Use **Deployments** or **ReplicaSets**, not raw Pods, for resiliency.
* Define **liveness/readiness probes** for health checks.
* Set **resource requests/limits** for CPU and memory.
* Use **sidecars** for logging, monitoring, or proxying instead of mixing logic in one container.
* Keep Pods lightweight — they’re not VMs; containers inside share kernel and IP.
* Use **labels/selectors** to manage Pods logically (e.g., `app=backend`).

---

### 💡 In short

* **Pods = wrapper around containers**, the smallest deployable unit in Kubernetes.
* Containers in a Pod share **network & storage** and run together.
* Pods are **ephemeral** — managed by higher-level controllers for auto-healing and scaling.
---
## Q: Difference between **Deployment**, **ReplicaSet**, and **Pod** in Kubernetes

---

### 🧠 Overview

These three are **core workload objects** in Kubernetes — each serves a different level of abstraction for running and managing containers.
They build on top of each other:

> **Deployment → ReplicaSet → Pod**

---

### ⚙️ Purpose / How They Work

| Level          | What It Manages                   | Purpose                                                                 |
| -------------- | --------------------------------- | ----------------------------------------------------------------------- |
| **Pod**        | Containers                        | Smallest deployable unit — runs one or more containers.                 |
| **ReplicaSet** | Pods                              | Ensures a specific number of Pod replicas are running.                  |
| **Deployment** | ReplicaSets (and Pods indirectly) | Adds declarative updates, rollouts, and rollbacks for Pods/ReplicaSets. |

---

### 🧩 Example Hierarchy

```
Deployment
 └── ReplicaSet
      └── Pod(s)
```

---

### 🧩 YAML Examples

#### 1️⃣ Pod (basic)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
```

#### 2️⃣ ReplicaSet (ensures N Pods)

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-rs
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
```

#### 3️⃣ Deployment (adds rollout strategy)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
```

---

### 📋 Detailed Comparison Table

| Feature             | **Pod**                           | **ReplicaSet**                      | **Deployment**                                  |
| ------------------- | --------------------------------- | ----------------------------------- | ----------------------------------------------- |
| **Purpose**         | Runs containers                   | Ensures desired # of Pods           | Manages ReplicaSets and rollouts                |
| **Manages**         | Containers                        | Pods                                | ReplicaSets & Pods                              |
| **Scalability**     | Manual                            | Automatic via `replicas:`           | Automatic + rolling updates                     |
| **Self-healing**    | No                                | Recreates Pods if deleted           | Manages rollouts & rollback                     |
| **Updates**         | Recreate manually                 | Replace all Pods manually           | Rolling updates / rollback supported            |
| **Rollback**        | ❌                                 | ❌                                   | ✅ Built-in                                      |
| **Usage**           | Testing, debugging                | Low-level scaling                   | Production workloads                            |
| **Example Command** | `kubectl run nginx --image=nginx` | `kubectl create -f replicaset.yaml` | `kubectl create deployment nginx --image=nginx` |

---

### ✅ Best Practices

* Use **Deployments** for most workloads — they handle scaling, rollout, and rollback automatically.
* Avoid using **ReplicaSets** directly unless you need low-level control (e.g., custom controllers).
* Use **Pods** only for debugging, one-off tasks, or static system components (like DaemonSets).
* Always define **readiness/liveness probes** in Deployment specs.
* Use **labels/selectors** consistently (`app`, `env`, `version`) to associate Pods and ReplicaSets.

---

### 💡 In short

* **Pod** = runs containers.
* **ReplicaSet** = maintains N Pods alive.
* **Deployment** = manages ReplicaSets, enabling **rolling updates and rollbacks** — the standard for production apps.
---
## Q: What is a Namespace in Kubernetes?

---

### 🧠 Overview

A **Namespace** in Kubernetes is a **logical isolation boundary** within a cluster — used to group and manage related resources (Pods, Services, Deployments, etc.).
Think of it as a **virtual cluster** inside your physical cluster that helps **organize, secure, and limit** resource usage per team, project, or environment.

---

### ⚙️ Purpose / How It Works

Namespaces allow:

* **Segregation** — isolate workloads (e.g., `dev`, `stage`, `prod`).
* **Access control** — apply RBAC roles, quotas, and policies per namespace.
* **Resource management** — limit CPU/memory via ResourceQuotas and LimitRanges.
* **Scalability** — manage large clusters with many teams or applications.

By default, Kubernetes creates these namespaces:

* `default` – for resources without a specified namespace
* `kube-system` – for system components (DNS, controller-manager, etc.)
* `kube-public` – readable by all users (e.g., cluster info)
* `kube-node-lease` – manages node heartbeats

---

### 🧩 Examples / YAML / Commands

#### 1️⃣ Create a Namespace

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev
  labels:
    env: dev
```

Apply:

```bash
kubectl apply -f namespace-dev.yaml
```

#### 2️⃣ Deploy a Pod in a Namespace

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-dev
  namespace: dev
spec:
  containers:
  - name: nginx
    image: nginx:latest
```

#### 3️⃣ CLI Commands

```bash
# List namespaces
kubectl get namespaces

# Create namespace
kubectl create namespace prod

# Set default namespace for context
kubectl config set-context --current --namespace=prod

# Delete a namespace (caution: deletes all resources inside)
kubectl delete namespace dev
```

---

### 📋 Table: Key Namespace Features

| Feature              | Description                                     | Example                                  |
| -------------------- | ----------------------------------------------- | ---------------------------------------- |
| **Isolation**        | Logical separation of workloads                 | `dev`, `staging`, `prod` namespaces      |
| **RBAC Control**     | Define role-based access per namespace          | `Role` + `RoleBinding` per team          |
| **Resource Limits**  | Control CPU/memory per namespace                | `ResourceQuota`, `LimitRange`            |
| **Network Policies** | Restrict traffic between namespaces             | `NetworkPolicy` with `namespaceSelector` |
| **Multi-Tenancy**    | Supports multiple teams/projects on one cluster | Separate namespace per project           |

---

### ✅ Best Practices

* Use **one namespace per environment or team** for better separation.
* Apply **ResourceQuotas** and **LimitRanges** to prevent resource exhaustion.
* Implement **RBAC** rules to limit access (e.g., devs can’t touch `prod`).
* Use **network policies** to isolate traffic between namespaces.
* Name namespaces meaningfully: `dev`, `staging`, `prod`, `monitoring`, etc.
* Avoid deploying user workloads in `default` or `kube-system`.
* Automate namespace creation via Terraform or Helm for consistency.

---

### 💡 In short

* A **Namespace** = a **virtual cluster** inside Kubernetes for isolating resources.
* Used for **multi-tenancy, RBAC, and resource management**.
* Enables cleaner organization, safer access control, and efficient scaling in large clusters.
---
## Q: Kubernetes Architecture — Core Components and How It Works ⚙️

---

### 🧠 Overview

Kubernetes follows a **master–worker (control plane–node)** architecture.
The **Control Plane** makes *decisions* (scheduling, scaling, healing) and maintains *cluster state*,
while **Worker Nodes** actually *run the workloads (Pods)*.

All communication between components goes through the **API Server**, making it the single source of truth.

---

### 🧩 Core Architecture Diagram (conceptually)

```
                +---------------------------+
                |       Control Plane       |
                |---------------------------|
                |  API Server  <---->  etcd |
                |     ↑   ↓                 |
                | Controller Manager        |
                | Scheduler                 |
                +-----------+---------------+
                            |
                            | (K8s API)
                            ↓
        +-------------------------------------------+
        |               Worker Nodes                |
        |-------------------------------------------|
        | Kubelet     |  Kube Proxy  |   Container Runtime |
        |  (Agent)    | (Networking) |   (Docker/CRI-O)    |
        |-------------------------------------------|
        | Pods (Containers running your apps)       |
        +-------------------------------------------+
```

---

### ⚙️ Control Plane Components

| Component                                          | Purpose                                                               | How it Works                                                                                                                                                                                                     |
| -------------------------------------------------- | --------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **API Server (`kube-apiserver`)**                  | Central hub & gateway for all commands (kubectl, controllers, nodes). | All operations (CRUD) go via REST API. Auth, RBAC, admission controls, and validation happen here. Communicates with `etcd` for state.                                                                           |
| **etcd**                                           | Highly available key–value store for cluster state.                   | Stores data like Pods, Deployments, ConfigMaps, Secrets, node info. Every cluster change (spec/status) is persisted here. Usually runs as a secured cluster with snapshots.                                      |
| **Controller Manager (`kube-controller-manager`)** | Runs background controllers that maintain desired state.              | Continuously watches the cluster via API server and reconciles state (e.g., if a Pod dies, ReplicaSet controller creates a new one). Includes node, replication, job, endpoint, and service account controllers. |
| **Scheduler (`kube-scheduler`)**                   | Decides where new Pods will run.                                      | Evaluates Pod specs (resource requests, taints/tolerations, affinities) → finds best node → assigns Pod. Writes binding info back to API server.                                                                 |
| **Cloud Controller Manager** *(if cloud-managed)*  | Integrates cluster with cloud provider APIs.                          | Manages cloud resources like load balancers, routes, and volumes based on Kubernetes objects (e.g., Service → ELB).                                                                                              |

---

### ⚙️ Node (Worker) Components

| Component             | Purpose                                                  | How it Works                                                                                                                                                            |
| --------------------- | -------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Kubelet**           | Node agent — ensures Pods are running as expected.       | Watches API Server for assigned Pods → runs them via the container runtime (Docker/Containerd/CRI-O). Reports Pod status, metrics, and events back to the API server.   |
| **Kube Proxy**        | Manages network rules for services and Pod connectivity. | Configures iptables/ipvs rules for service load balancing. Routes external/internal traffic to correct Pod endpoints.                                                   |
| **Container Runtime** | Actually runs the containers inside Pods.                | Follows CRI (Container Runtime Interface). Examples: containerd, CRI-O, Docker shim (deprecated). Handles pulling images, managing namespaces, and starting containers. |

---

### 🧠 Control Plane → Node Interaction (Step-by-Step Flow)

1. **kubectl apply -f deployment.yaml**
   → API request to **kube-apiserver**.
2. **API Server** stores desired state (Deployment object) in **etcd**.
3. **Controller Manager** detects a new Deployment → creates ReplicaSet → creates Pod objects.
4. **Scheduler** sees unassigned Pods → picks the best Node → updates binding info.
5. **Kubelet (on that Node)** sees new Pod assigned → pulls image → starts containers using **container runtime**.
6. **Kubelet** reports Pod status back to API Server → visible via `kubectl get pods`.
7. **Kube Proxy** updates service routing → traffic automatically load-balanced to the new Pod.

---

### 📋 Real-World Control Plane Flow Example

| Action                                  | Component Involved                      | Description                           |
| --------------------------------------- | --------------------------------------- | ------------------------------------- |
| User runs `kubectl apply -f nginx.yaml` | **kubectl → API Server**                | Request hits API Server (REST call).  |
| Object persisted                        | **API Server → etcd**                   | Desired state stored in etcd.         |
| Deployment reconciliation               | **Controller Manager**                  | Ensures ReplicaSet & Pods exist.      |
| Pod scheduling                          | **Scheduler**                           | Chooses Node based on CPU/mem/taints. |
| Pod creation                            | **Kubelet (on node)**                   | Starts containers via containerd.     |
| Network setup                           | **Kube Proxy + CNI plugin**             | Configures routing & Pod IPs.         |
| Monitoring                              | **Kubelet reports status → API Server** | Updates Pod conditions and health.    |

---

### ⚙️ Networking Stack (High-Level)

* **CNI Plugin (e.g., Calico, Weave, Cilium):** allocates Pod IPs, configures routes between Pods across nodes.
* **Kube Proxy:** implements service-level virtual IP and load balancing via iptables or IPVS.
* **Cluster DNS (CoreDNS):** resolves service names (`my-svc.default.svc.cluster.local`) to virtual IPs.
* **Ingress Controller:** handles Layer 7 (HTTP) traffic into cluster.

---

### ✅ Best Practices (production-ready)

* **etcd:** use dedicated nodes, encrypted at rest, with regular snapshots.
* **Control Plane:** run as HA (3+ masters) across zones; secure with TLS & RBAC.
* **Kubelet:** ensure resource monitoring (cAdvisor/metrics-server).
* **Kube Proxy:** prefer IPVS mode for performance.
* **Audit logging:** enable at API Server for traceability.
* **Pod Security & Admission Control:** enforce via OPA/Gatekeeper or PSP replacements.
* **Metrics:** monitor API latency, controller queue depth, scheduler decisions, etc.

---

### 💡 In short

* **Control Plane = Brain** 🧠 → defines, schedules, and maintains desired state.
* **Worker Nodes = Muscles** 💪 → run the actual workloads (Pods).
* **API Server = Gateway**, **etcd = Memory**, **Controller = Self-healing**, **Scheduler = Placement logic**, **Kubelet = Executor**, **Kube Proxy = Networking brain**.
  Together they form a **self-healing, declarative orchestration system** that continuously drives actual state toward desired state.
---
## Q: What is a Service in Kubernetes?

---

### 🧠 Overview

A **Service** in Kubernetes is an **abstraction that exposes a set of Pods** as a single **network endpoint**.
It provides **stable networking and load balancing** for Pods, whose IPs are **ephemeral** (they change when Pods restart or reschedule).
Services enable **reliable communication** between applications **inside and outside** the cluster.

---

### ⚙️ Purpose / How It Works

* Each Pod gets its own internal IP, but these IPs are **not persistent**.
* A Service defines a **stable virtual IP (ClusterIP)** that remains constant.
* The Service uses **label selectors** to dynamically route traffic to matching Pods.
* Kubernetes maintains the mapping automatically via **Endpoints**.
* Services can also **expose workloads externally** using `NodePort`, `LoadBalancer`, or `Ingress`.

---

### 🧩 Examples / YAML / Commands

#### 1️⃣ ClusterIP (default — internal only)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-svc
spec:
  type: ClusterIP
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 8080
```

✅ Exposes Pods internally in-cluster on a stable DNS name:
`web-svc.default.svc.cluster.local`

---

#### 2️⃣ NodePort (exposes service on each node’s IP:port)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-nodeport
spec:
  type: NodePort
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 8080
    nodePort: 30080
```

✅ Access externally:
`http://<NodeIP>:30080`

---

#### 3️⃣ LoadBalancer (cloud integration)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-lb
spec:
  type: LoadBalancer
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 8080
```

✅ Provisions a **cloud load balancer** (AWS ELB, Azure LB, GCP LB) and routes traffic to backend Pods.

---

#### 4️⃣ Headless Service (no ClusterIP)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: db-headless
spec:
  clusterIP: None
  selector:
    app: db
  ports:
  - port: 5432
```

✅ Used for StatefulSets — exposes individual Pod DNS records (e.g., `db-0.db-headless.default.svc.cluster.local`).

---

### 📋 Service Types Comparison

| Type                  | Scope             | Use Case                                   | Externally Accessible? |
| --------------------- | ----------------- | ------------------------------------------ | ---------------------- |
| **ClusterIP**         | Internal          | Default; pod-to-pod communication          | ❌                      |
| **NodePort**          | Node-level        | Access from outside via Node IP + port     | ✅                      |
| **LoadBalancer**      | Cloud provider LB | Publicly expose service                    | ✅                      |
| **ExternalName**      | DNS alias         | Maps internal service to external hostname | ✅ (DNS only)           |
| **Headless (`None`)** | Direct Pod DNS    | StatefulSets or custom discovery           | ❌                      |

---

### ✅ Best Practices

* Use **ClusterIP** for internal microservice communication.
* Use **LoadBalancer** only for public-facing apps; pair with **Ingress** for advanced routing.
* **Headless Services** are ideal for databases and StatefulSets.
* Use **labels and selectors** consistently (e.g., `app`, `tier`, `env`).
* Use **NetworkPolicies** to control which Pods/Namespaces can access the Service.
* Use **DNS** instead of IPs (`myservice.default.svc.cluster.local`).
* Enable **session affinity** if needed for stateful traffic (`sessionAffinity: ClientIP`).

---

### 💡 In short

* A **Service** gives Pods a **stable IP and DNS name** to enable reliable communication.
* It automatically load-balances traffic across healthy Pods.
* Choose **ClusterIP** (internal), **NodePort** (test/dev), or **LoadBalancer** (prod/external) depending on exposure needs.
---
## Q: What is a ConfigMap in Kubernetes?

---

### 🧠 Overview

A **ConfigMap** in Kubernetes is an API object used to **store non-sensitive configuration data** (key-value pairs) that can be **injected into Pods** as environment variables, command-line arguments, or mounted files.
It lets you **decouple configuration from container images**, so you can change app settings **without rebuilding** your containers.

---

### ⚙️ Purpose / How It Works

* ConfigMaps provide a **centralized way to manage app configuration**.
* They can be referenced by multiple Pods and updated independently.
* When a ConfigMap changes, **Pods using it must be restarted** (unless mounted as volumes with reloading support via sidecars like `reloader` or `configmap-reload`).
* They are ideal for **non-sensitive data** (for secrets, use `Secret` objects).

---

### 🧩 Examples / YAML / Commands

#### 1️⃣ Create ConfigMap from YAML

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_MODE: "production"
  LOG_LEVEL: "info"
  MAX_CONNECTIONS: "100"
```

Apply:

```bash
kubectl apply -f configmap.yaml
```

---

#### 2️⃣ Create ConfigMap from CLI

```bash
# From literal values
kubectl create configmap app-config \
  --from-literal=APP_MODE=dev \
  --from-literal=LOG_LEVEL=debug

# From a file
kubectl create configmap app-config --from-file=config.env
```

---

#### 3️⃣ Use ConfigMap in a Pod (as environment variables)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
spec:
  containers:
  - name: web
    image: nginx
    envFrom:
    - configMapRef:
        name: app-config
```

✅ Inside the container:

```bash
echo $APP_MODE        # => production
echo $LOG_LEVEL       # => info
```

---

#### 4️⃣ Mount ConfigMap as files

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: configmap-volume
spec:
  containers:
  - name: app
    image: alpine
    command: ["/bin/sh", "-c", "cat /etc/config/APP_MODE"]
    volumeMounts:
    - name: config-vol
      mountPath: /etc/config
  volumes:
  - name: config-vol
    configMap:
      name: app-config
```

✅ Each key becomes a file under `/etc/config`.

---

### 📋 ConfigMap vs Secret

| Feature         | **ConfigMap**               | **Secret**                               |
| --------------- | --------------------------- | ---------------------------------------- |
| Purpose         | Store non-sensitive data    | Store sensitive data (passwords, tokens) |
| Encoding        | Plain text                  | Base64 encoded                           |
| Mount / Env use | ✅ Supported                 | ✅ Supported                              |
| Encryption      | ❌ (unless enabled with KMS) | ✅ Supported via KMS/EncryptionConfig     |
| Example data    | Log level, app name         | DB password, API key                     |

---

### ✅ Best Practices

* Use **ConfigMaps for environment-specific settings** (URLs, modes, limits).
* Never store **passwords or API keys** — use **Secrets** instead.
* **Mount via volumes** when large configurations are required (files, templates).
* Automate **reload** using tools like:

  * [Stakater Reloader](https://github.com/stakater/Reloader)
  * `configmap-reload` sidecar container.
* Version your ConfigMaps via GitOps (e.g., `app-config-v2`).
* Label ConfigMaps (`app`, `env`) for easy tracking.
* Manage via Helm values or Terraform to maintain consistency.

---

### 💡 In short

* **ConfigMap = external config for Pods (non-sensitive)**.
* Inject into containers via **env vars or volume mounts**.
* Change configuration **without rebuilding images**, promoting flexibility and clean separation between app code and environment settings.
---
## Q: What is a Secret in Kubernetes?

---

### 🧠 Overview

A **Secret** in Kubernetes is an object that stores **sensitive data** — such as passwords, API tokens, SSH keys, or TLS certificates — in a secure and base64-encoded format.
Secrets help you **avoid embedding credentials** directly in Pod specs, container images, or ConfigMaps, improving **security and manageability**.

---

### ⚙️ Purpose / How It Works

* Secrets keep sensitive values **separate from code and configurations**.
* They can be used as:

  * **Environment variables** in containers.
  * **Mounted files** in Pods.
  * **Referenced by other resources** (like ServiceAccounts, Ingress TLS, etc.).
* Data is **base64-encoded**, not encrypted by default (enable Encryption at Rest for real security).
* Access is controlled via **RBAC**, ensuring only authorized Pods/users can read secrets.

---

### 🧩 Examples / YAML / Commands

#### 1️⃣ Create Secret (YAML)

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  username: YWRtaW4=        # "admin" (base64)
  password: cGFzc3dvcmQxMjM= # "password123"
```

Apply:

```bash
kubectl apply -f db-secret.yaml
```

---

#### 2️⃣ Create Secret from CLI

```bash
# From literal key-value pairs
kubectl create secret generic db-secret \
  --from-literal=username=admin \
  --from-literal=password=password123

# From file
kubectl create secret generic tls-cert --from-file=tls.crt --from-file=tls.key
```

---

#### 3️⃣ Use Secret in a Pod (Environment Variables)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-app
spec:
  containers:
  - name: app
    image: nginx
    env:
    - name: DB_USER
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: username
    - name: DB_PASS
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: password
```

✅ Inside container:

```bash
echo $DB_USER     # admin
echo $DB_PASS     # password123
```

---

#### 4️⃣ Mount Secret as Files

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
  - name: app
    image: alpine
    command: ["/bin/sh", "-c", "cat /etc/secret/password"]
    volumeMounts:
    - name: secret-vol
      mountPath: /etc/secret
  volumes:
  - name: secret-vol
    secret:
      secretName: db-secret
```

✅ Each key becomes a file under `/etc/secret/`.

---

### 📋 Common Secret Types

| Type                               | Description                            | Example             |
| ---------------------------------- | -------------------------------------- | ------------------- |
| **Opaque**                         | Default type, arbitrary key/value data | App credentials     |
| **kubernetes.io/dockerconfigjson** | Docker registry auth                   | ImagePullSecrets    |
| **kubernetes.io/tls**              | TLS cert and key                       | Ingress SSL         |
| **bootstrap.kubernetes.io/token**  | Bootstrap tokens for nodes             | Kubelet join tokens |

---

### 📋 Secret vs ConfigMap

| Feature            | **Secret**                                | **ConfigMap**                      |
| ------------------ | ----------------------------------------- | ---------------------------------- |
| Purpose            | Sensitive data (passwords, keys)          | Non-sensitive config (URLs, flags) |
| Storage            | Base64 encoded (can be encrypted at rest) | Plain text                         |
| Mounted as         | Env vars / files                          | Env vars / files                   |
| Encryption at rest | ✅ (when enabled)                          | ❌                                  |
| Access control     | Strict via RBAC                           | Normal via RBAC                    |

---

### ✅ Best Practices

* **Enable Encryption at Rest** for Secrets (`EncryptionConfiguration` in API server).
* **Use RBAC** to restrict who/what can read Secrets.
* Avoid `kubectl get secret -o yaml` unless necessary (shows base64-encoded data).
* Rotate Secrets periodically and automate using tools (e.g., **External Secrets Operator**, **Vault**).
* Avoid storing Secrets in Git — store references (e.g., in Helm values or Terraform variables).
* Mount Secrets as **volumes** rather than env vars if they are large or need rotation.
* Audit Secret access via **API server logs** and **Kubernetes audit logging**.

---

### 💡 In short

* **Secret = secure storage** for sensitive values like passwords, tokens, and certs.
* Mounted or injected into Pods securely, controlled via RBAC.
* Enable **Encryption at Rest** and rotate regularly to maintain compliance and safety.
---
## Q: What is a **kubelet** in Kubernetes?

---

### 🧠 Overview

The **kubelet** is a **node-level agent** in Kubernetes that ensures **containers are running** in the desired state as defined by the **control plane**.
It’s responsible for **managing Pods on each node**, communicating with the **API server**, and reporting node and pod status back to the cluster.

---

### ⚙️ Purpose / How It Works

* Runs on **every worker and master node** (except control-plane-only nodes without workloads).
* Continuously watches for **PodSpecs** assigned to its node.
* Ensures containers (via container runtime like Docker, containerd, or CRI-O) are running as defined.
* Reports **node and Pod status** to the Kubernetes API server.
* Performs **health checks** and **restarts containers** if they fail.

**Core workflow:**

1. API server schedules a Pod onto a node.
2. The kubelet on that node retrieves the Pod spec.
3. It uses the **Container Runtime Interface (CRI)** to start containers.
4. Monitors and reports Pod/Node status back to the API server.

---

### 🧩 Key Responsibilities

| Function                     | Description                                                         |
| ---------------------------- | ------------------------------------------------------------------- |
| **Pod lifecycle management** | Creates, monitors, and restarts containers per PodSpec.             |
| **Health checking**          | Executes liveness/readiness probes and restarts failing containers. |
| **Node registration**        | Registers node metadata (CPU, memory, labels) with the API server.  |
| **Resource reporting**       | Sends node metrics (CPU/mem/disk) to control plane.                 |
| **Log & metrics access**     | Exposes `/metrics`, `/stats`, and `/logs` endpoints.                |
| **Volume management**        | Mounts and unmounts persistent volumes for Pods.                    |
| **Image management**         | Pulls container images and manages caching.                         |

---

### 🧩 Commands / Useful Info

#### Check kubelet status

```bash
systemctl status kubelet
journalctl -u kubelet -f    # live logs
```

#### kubelet configuration file (example: `/var/lib/kubelet/config.yaml`)

```yaml
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
address: 0.0.0.0
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
authorization:
  mode: Webhook
failSwapOn: false
cgroupDriver: systemd
```

#### Check node health via kubelet API (local)

```bash
curl -s http://127.0.0.1:10255/metrics | head
```

---

### 📋 kubelet vs Other Components

| Component          | Role                                                      |
| ------------------ | --------------------------------------------------------- |
| **kubelet**        | Node agent that manages Pods and containers.              |
| **kube-proxy**     | Handles networking and routing between Services and Pods. |
| **kube-apiserver** | Central control-plane API that all components talk to.    |
| **scheduler**      | Assigns Pods to nodes based on resources and policies.    |

---

### ✅ Best Practices

* Ensure **kubelet is managed as a system service** (e.g., `systemd`) for automatic restarts.
* Keep kubelet and container runtime **version-aligned** with the cluster.
* Enable **TLS & authentication** for kubelet API endpoints (disable anonymous access).
* Use **read-only port (10255)** only for debugging; disable in production.
* Configure **resource limits & eviction policies** to handle node pressure gracefully.
* Monitor kubelet metrics via Prometheus (`/metrics` endpoint).
* Rotate **kubelet certificates** periodically (`kubelet cert rotation` feature).

---

### 💡 In short

* The **kubelet** is the **node agent** ensuring containers are running as defined by the control plane.
* It handles **Pod lifecycle**, **health checks**, **metrics**, and **node status reporting**.
* Without kubelet, Kubernetes **cannot run or manage Pods** on that node.
---
## Q: What is a **Node** in Kubernetes?

---

### 🧠 Overview

A **Node** in Kubernetes is a **worker machine** (physical or virtual) that runs application workloads as **Pods**.
Each node is managed by the **control plane**, and it contains the necessary services to run Pods — including the **kubelet**, **container runtime**, and **kube-proxy**.

You can think of a **node as the compute unit** of a Kubernetes cluster.

---

### ⚙️ Purpose / How It Works

* The **control plane (API Server, Scheduler, Controller Manager)** assigns Pods to nodes based on resource availability and policies.
* The **kubelet** on the node ensures that the containers for those Pods are running.
* **kube-proxy** manages networking, allowing Pods on different nodes to communicate.
* Each node periodically reports its health and resource metrics to the control plane.
* If a node fails, the scheduler automatically reschedules Pods to healthy nodes.

---

### 🧩 Node Architecture

```
+--------------------------------------------+
|                  Node                      |
|--------------------------------------------|
| kubelet      → Ensures Pods are running    |
| kube-proxy   → Handles networking/routing  |
| Container runtime → Runs containers (Docker, containerd) |
|--------------------------------------------|
| OS / Kernel  → Host machine                |
+--------------------------------------------+
```

---

### 🧩 Node Types

| Type                                  | Description                                                   |
| ------------------------------------- | ------------------------------------------------------------- |
| **Master (Control Plane)**            | Runs cluster control components (API server, scheduler, etc.) |
| **Worker Node**                       | Runs application Pods and workloads                           |
| **Managed Node Groups (EKS/GKE/AKS)** | Cloud-managed worker nodes integrated with autoscaling        |

---

### 🧩 Commands / Examples

#### 1️⃣ List nodes

```bash
kubectl get nodes
```

#### 2️⃣ Node details

```bash
kubectl describe node <node-name>
```

#### 3️⃣ Check node status

```bash
kubectl get nodes -o wide
```

#### 4️⃣ Drain / Cordon a node (maintenance)

```bash
kubectl cordon <node-name>     # Mark node unschedulable
kubectl drain <node-name>      # Evict all Pods
kubectl uncordon <node-name>   # Make node schedulable again
```

#### 5️⃣ Node resource usage

```bash
kubectl top node
```

---

### 📋 Node Conditions

| Condition              | Description                        |
| ---------------------- | ---------------------------------- |
| **Ready**              | Node is healthy and accepting Pods |
| **NotReady**           | Node is unreachable or unhealthy   |
| **MemoryPressure**     | Node is low on memory              |
| **DiskPressure**       | Node is low on disk space          |
| **PIDPressure**        | Node is running too many processes |
| **NetworkUnavailable** | Network setup failed               |

---

### 📋 Key Node Components

| Component             | Role                                                     |
| --------------------- | -------------------------------------------------------- |
| **kubelet**           | Ensures Pods are running on the node                     |
| **kube-proxy**        | Handles Pod networking and Service routing               |
| **Container Runtime** | Runs containers (Docker, containerd, CRI-O)              |
| **cAdvisor**          | Collects node-level resource metrics (CPU, memory, etc.) |

---

### ✅ Best Practices

* Use **labels** to categorize nodes (e.g., `env=prod`, `type=gpu`).
* Define **node selectors, affinities, and tolerations** for smart scheduling.
* Use **node taints** to reserve special-purpose nodes (e.g., GPU or DB).
* Enable **autoscaling** (Cluster Autoscaler / Managed Node Groups) for elasticity.
* Regularly **patch and monitor node OS** for security.
* Use **node pools** per environment or workload type.
* Collect **metrics and logs** (via Prometheus, Fluentd, etc.) for visibility.

---

### 💡 In short

* A **Node** = a **worker machine** in the Kubernetes cluster that runs Pods.
* It contains **kubelet**, **kube-proxy**, and a **container runtime**.
* The control plane **schedules Pods** onto nodes, while kubelet ensures they stay healthy and running.
---
## Q: What is **kubectl** in Kubernetes?

---

### 🧠 Overview

**kubectl** is the **command-line tool** used to **interact with the Kubernetes API Server**.
It lets you **deploy, inspect, manage, and troubleshoot** Kubernetes resources — such as Pods, Deployments, Services, and more.
Think of it as the **CLI interface for Kubernetes**, similar to how `awscli` is for AWS or `git` is for GitHub.

---

### ⚙️ Purpose / How It Works

* `kubectl` communicates with the **API Server** using the **kubeconfig** file (`~/.kube/config`).
* It sends REST API requests to perform operations like create, update, delete, or view cluster objects.
* Works with **both local and remote clusters** (via multiple contexts).
* Every `kubectl` command maps to a Kubernetes API request.

---

### 🧩 Examples / Common Commands

#### 1️⃣ Basic Operations

```bash
kubectl version                   # Show client/server versions
kubectl cluster-info              # Display cluster info
kubectl get nodes                 # List all nodes
kubectl get pods                  # List all pods in current namespace
kubectl get all -n dev            # All resources in 'dev' namespace
```

#### 2️⃣ Create / Apply / Delete Resources

```bash
kubectl apply -f deployment.yaml  # Apply or update a manifest
kubectl create -f pod.yaml        # Create resource from YAML
kubectl delete -f pod.yaml        # Delete resource
kubectl delete pod nginx-pod      # Delete specific pod
```

#### 3️⃣ Describe / Inspect Resources

```bash
kubectl describe pod nginx-pod
kubectl get pods -o wide          # Show Pod IPs, Nodes, etc.
kubectl get svc -o yaml           # View Service details in YAML
```

#### 4️⃣ Debugging / Logs / Exec

```bash
kubectl logs nginx-pod                  # View logs from Pod
kubectl exec -it nginx-pod -- /bin/bash # Access container shell
kubectl port-forward pod/nginx-pod 8080:80  # Forward local port to Pod
```

#### 5️⃣ Namespaces

```bash
kubectl get namespaces
kubectl config set-context --current --namespace=dev
```

#### 6️⃣ Contexts / Clusters

```bash
kubectl config get-contexts
kubectl config use-context prod-cluster
```

#### 7️⃣ Scale & Rollout

```bash
kubectl scale deployment web --replicas=5
kubectl rollout status deployment web
kubectl rollout undo deployment web
```

---

### 📋 Key Command Patterns

| Command Pattern               | Example                        | Description                  |
| ----------------------------- | ------------------------------ | ---------------------------- |
| `kubectl get <resource>`      | `kubectl get pods`             | List resources               |
| `kubectl describe <resource>` | `kubectl describe svc web`     | Detailed info                |
| `kubectl create -f <file>`    | `kubectl create -f pod.yaml`   | Create resource              |
| `kubectl apply -f <file>`     | `kubectl apply -f deploy.yaml` | Apply config changes         |
| `kubectl delete <resource>`   | `kubectl delete pod web`       | Delete resource              |
| `kubectl exec`                | `kubectl exec -it pod -- bash` | Run command inside container |
| `kubectl logs`                | `kubectl logs pod-name`        | Fetch container logs         |

---

### 📂 kubeconfig File Example (`~/.kube/config`)

```yaml
apiVersion: v1
clusters:
- cluster:
    server: https://<api-server-endpoint>
    certificate-authority-data: <base64>
  name: prod-cluster
contexts:
- context:
    cluster: prod-cluster
    user: admin
    namespace: default
  name: prod-context
current-context: prod-context
users:
- name: admin
  user:
    client-certificate-data: <base64>
    client-key-data: <base64>
```

---

### ✅ Best Practices

* Always set a **default namespace** to avoid deploying in the wrong one.
* Use **`kubectl apply`** instead of `create` for idempotent (repeatable) deployments.
* Use **shortnames** (`po`, `svc`, `dep`) for quicker commands:

  ```bash
  kubectl get po,svc,dep
  ```
* Add **aliases** in your shell (e.g., `alias k=kubectl`).
* Use **contexts** for multi-cluster setups.
* Use **`kubectl diff`** before applying manifests in production.
* Integrate **kubectl plugins** (e.g., `kubectl-neat`, `kubectl-tree`, `kubens`).
* Enable **auto-completion**:

  ```bash
  source <(kubectl completion bash)
  ```

---

### 💡 In short

* **kubectl** is the **CLI for Kubernetes** — it talks to the API server to manage cluster resources.
* You use it to **deploy, inspect, debug, and control** workloads declaratively or imperatively.
* It’s your **primary tool** for operating Kubernetes — whether locally (Minikube) or on cloud clusters (EKS, GKE, AKS).
---
## Q: What is the Difference Between **ReplicaSet** and **StatefulSet** in Kubernetes?

---

### 🧠 Overview

Both **ReplicaSet** and **StatefulSet** manage **multiple Pods** and ensure **high availability** by maintaining a specified number of replicas.
However, they differ in **how they handle Pod identity, storage, and ordering** — making **ReplicaSets** ideal for stateless apps, while **StatefulSets** are designed for **stateful, persistent workloads**.

---

### ⚙️ Purpose / How They Work

| Concept              | **ReplicaSet**                                        | **StatefulSet**                                                              |
| -------------------- | ----------------------------------------------------- | ---------------------------------------------------------------------------- |
| **Use Case**         | Stateless apps (e.g., web servers, APIs)              | Stateful apps (e.g., databases, Kafka, Redis)                                |
| **Pod Identity**     | Pods are interchangeable (no unique name or identity) | Each Pod gets a **stable, unique identity** (e.g., `mysql-0`, `mysql-1`)     |
| **Storage**          | No persistent storage by default                      | Each Pod gets its own **PersistentVolumeClaim (PVC)**                        |
| **Pod Names**        | Randomly generated                                    | Predictable, ordered (`app-0`, `app-1`, `app-2`)                             |
| **Deployment Order** | All Pods start/stop simultaneously                    | Pods created/destroyed **sequentially** (ordered startup/termination)        |
| **Scaling Behavior** | Adds/removes Pods in any order                        | Adds/removes Pods **one at a time** (ensures stability)                      |
| **Networking**       | Uses Service with load balancing (no fixed identity)  | Pods have **stable DNS** (`podname.servicename.namespace.svc.cluster.local`) |
| **Controller**       | Typically managed by a **Deployment**                 | Managed directly as a StatefulSet (no Deployment wrapper)                    |
| **Rolling Updates**  | Fast, non-sequential                                  | Sequential and controlled (ensures data safety)                              |

---

### 🧩 Examples / YAML Snippets

#### 1️⃣ ReplicaSet Example (Stateless App)

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: web-rs
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:latest
```

✅ Each Pod is identical and interchangeable (`web-rs-abcde`).

---

#### 2️⃣ StatefulSet Example (Stateful DB)

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
spec:
  serviceName: "mysql"
  replicas: 3
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
  volumeClaimTemplates:
  - metadata:
      name: mysql-data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

✅ Each Pod (`mysql-0`, `mysql-1`, `mysql-2`) has its own **persistent storage**.

---

### 📋 Key Features Comparison

| Feature              | **ReplicaSet**                     | **StatefulSet**                        |
| -------------------- | ---------------------------------- | -------------------------------------- |
| **Pod identity**     | Random, ephemeral                  | Unique, stable                         |
| **Storage**          | Shared / none                      | Dedicated PVC per Pod                  |
| **Pod hostname**     | Random                             | Predictable (DNS-based)                |
| **Scaling behavior** | Parallel                           | Sequential                             |
| **Order guarantee**  | ❌                                  | ✅                                      |
| **Persistent data**  | ❌                                  | ✅                                      |
| **Common use case**  | Frontend / stateless microservices | Databases, queues, distributed storage |
| **Example**          | NGINX, API, worker nodes           | MySQL, MongoDB, Zookeeper, Kafka       |

---

### ✅ Best Practices

* Use **ReplicaSets** for **stateless** workloads that don’t store data (e.g., web servers, APIs).
* Use **Deployments** instead of managing ReplicaSets directly — they handle rollouts and rollbacks automatically.
* Use **StatefulSets** for **databases or apps requiring identity and persistence**.
* Always define **PersistentVolumeClaims** in StatefulSets.
* Use **Headless Services** (`clusterIP: None`) with StatefulSets for stable Pod DNS.
* Avoid scaling StatefulSets too aggressively — creation and deletion are sequential.
* Use **PodDisruptionBudgets (PDB)** to maintain minimum available replicas during updates.

---

### 💡 In short

* **ReplicaSet → stateless, identical Pods**, fast scaling, managed by Deployments.
* **StatefulSet → stateful, ordered Pods** with **stable storage and identity**.
* Use ReplicaSets for **web tiers**, StatefulSets for **databases, message queues, and distributed systems**.
---
## Q: What is a **DaemonSet** in Kubernetes?

---

### 🧠 Overview

A **DaemonSet** ensures that a **copy of a Pod runs on every (or selected) node** in a Kubernetes cluster.
It’s typically used for **node-level services** such as logging, monitoring, networking, or storage daemons that must run on all or specific nodes.

In short — a DaemonSet = **“one Pod per node”** pattern.

---

### ⚙️ Purpose / How It Works

* When a new node joins the cluster, the **DaemonSet controller** automatically schedules its Pod onto that node.
* When a node is removed, the DaemonSet’s Pod on that node is also deleted.
* You can use **node selectors, labels, or taints/tolerations** to control which nodes run the DaemonSet Pods.
* Common use cases:

  * Log collection (Fluentd, Filebeat)
  * Node monitoring (Prometheus Node Exporter)
  * CNI plugins (Calico, Weave, Cilium)
  * Security agents or node-level sidecars

---

### 🧩 YAML Example

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-logger
  labels:
    app: logger
spec:
  selector:
    matchLabels:
      app: logger
  template:
    metadata:
      labels:
        app: logger
    spec:
      containers:
      - name: fluentd
        image: fluent/fluentd:latest
        resources:
          limits:
            cpu: "200m"
            memory: "200Mi"
```

✅ This ensures a **Fluentd** log collector Pod runs on **every node**.

---

### 🧩 Schedule on Specific Nodes

#### By Label:

```yaml
spec:
  template:
    spec:
      nodeSelector:
        role: storage
```

#### By Tolerations:

```yaml
spec:
  template:
    spec:
      tolerations:
      - key: "node-role.kubernetes.io/master"
        effect: NoSchedule
```

✅ Runs on master/control-plane nodes if needed.

---

### 📋 Key Features

| Feature              | Description                                         |
| -------------------- | --------------------------------------------------- |
| **Pod Distribution** | One Pod per node (or per matching node selector)    |
| **Auto Sync**        | Automatically adds/removes Pods as nodes join/leave |
| **Update Strategy**  | Supports rolling updates with `updateStrategy`      |
| **Node Selection**   | Controlled via labels, selectors, or tolerations    |
| **Common Use Cases** | Monitoring, logging, networking, storage agents     |

---

### 📋 DaemonSet vs Deployment vs StatefulSet

| Feature          | **DaemonSet**                          | **Deployment**            | **StatefulSet**           |
| ---------------- | -------------------------------------- | ------------------------- | ------------------------- |
| **Purpose**      | Run a Pod on every node                | Manage stateless apps     | Manage stateful apps      |
| **Pod Count**    | One per node                           | User-defined (`replicas`) | Sequential replicas       |
| **Pod Identity** | Node-based                             | Random                    | Stable (`app-0`, `app-1`) |
| **Typical Use**  | Node services (Fluentd, CNI, exporter) | Web, API                  | DBs, Kafka                |
| **Scaling**      | Auto (per node)                        | Manual/auto (`replicas`)  | Ordered, manual           |

---

### ✅ Best Practices

* Use **DaemonSets** for node-level workloads only (logging, metrics, networking).
* Avoid running user applications as DaemonSets — use **Deployments** instead.
* Control placement via **nodeSelector**, **affinity**, and **tolerations**.
* Enable **rolling updates** for version upgrades:

  ```yaml
  updateStrategy:
    type: RollingUpdate
  ```
* Use **Resource limits** for DaemonSet Pods to prevent node starvation.
* Combine with **PodAntiAffinity** to avoid conflicts with other critical Pods.
* Monitor via `kubectl get daemonsets -A` and verify node coverage.

---

### 💡 In short

* **DaemonSet = one Pod per node** — perfect for background system agents.
* Automatically scales with cluster size (adds/removes Pods with nodes).
* Commonly used for **logging, monitoring, networking, or security** agents.
---
## Q: What is the Difference Between **Job** and **CronJob** in Kubernetes?

---

### 🧠 Overview

Both **Job** and **CronJob** are **Kubernetes workload resources** used to run **tasks that are not long-running services** — such as **batch processes, data imports, or cleanups**.
The key difference:

* A **Job** runs **once** (on demand).
* A **CronJob** runs **on a schedule** (recurring).

---

### ⚙️ Purpose / How They Work

| Concept              | **Job**                                         | **CronJob**                        |
| -------------------- | ----------------------------------------------- | ---------------------------------- |
| **Purpose**          | Run a task to completion once                   | Run Jobs on a defined schedule     |
| **Execution**        | Manual / one-time                               | Automatic / recurring              |
| **Pod Lifecycle**    | Creates Pods → waits until they succeed → exits | Creates a new Job per schedule run |
| **Restart Policy**   | `OnFailure` or `Never`                          | Inherited from Job template        |
| **Scheduling**       | Immediate                                       | Cron expression (like Linux cron)  |
| **Typical Use Case** | Data migration, backups, reports                | Daily/weekly jobs, cleanup tasks   |

---

### 🧩 YAML Examples

#### 1️⃣ **Job Example (One-time Execution)**

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: db-migration
spec:
  template:
    spec:
      containers:
      - name: migrate
        image: alpine
        command: ["sh", "-c", "echo 'Running DB migration'; sleep 5"]
      restartPolicy: OnFailure
```

✅ Runs **once** and exits after completion.

---

#### 2️⃣ **CronJob Example (Scheduled Job)**

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: daily-cleanup
spec:
  schedule: "0 2 * * *"   # Runs every day at 2 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: cleanup
            image: alpine
            command: ["sh", "-c", "echo 'Cleaning temp files'; rm -rf /tmp/*"]
          restartPolicy: OnFailure
```

✅ Creates a **Job every day** at 2 AM — each Job manages its own Pods.

---

### 🧩 Useful Commands

```bash
# List all jobs
kubectl get jobs

# Check job status
kubectl describe job db-migration

# Get logs of a job Pod
kubectl logs job/db-migration

# List all CronJobs
kubectl get cronjobs

# Trigger a CronJob manually
kubectl create job --from=cronjob/daily-cleanup manual-run
```

---

### 📋 Key Parameters

| Field                        | Description                                                             |
| ---------------------------- | ----------------------------------------------------------------------- |
| `completions`                | Number of Pods to complete successfully before Job is marked successful |
| `parallelism`                | Max Pods running in parallel                                            |
| `backoffLimit`               | Retry count before marking failed                                       |
| `schedule`                   | CronJob time pattern                                                    |
| `successfulJobsHistoryLimit` | Retain count of completed Jobs                                          |
| `failedJobsHistoryLimit`     | Retain count of failed Jobs                                             |

---

### 📋 Job vs CronJob — Comparison Table

| Feature            | **Job**                               | **CronJob**                                           |
| ------------------ | ------------------------------------- | ----------------------------------------------------- |
| **Run type**       | One-time                              | Repeated / Scheduled                                  |
| **Scheduling**     | Immediate                             | Cron syntax (`0 2 * * *`)                             |
| **Creates**        | Pods                                  | Jobs (which create Pods)                              |
| **Retries**        | Controlled by `backoffLimit`          | Same (per Job)                                        |
| **Manual trigger** | ✅ Yes                                 | ❌ Auto (can trigger manually via `create job --from`) |
| **Use case**       | Data import, DB migration, batch task | Nightly backup, cleanup, ETL job                      |
| **Resource kind**  | `Job`                                 | `CronJob` (creates Jobs)                              |

---

### ✅ Best Practices

* Always set:

  ```yaml
  restartPolicy: OnFailure
  backoffLimit: 3
  ```
* For **CronJobs**, include:

  ```yaml
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 1
  ```
* Avoid overlapping runs — use:

  ```yaml
  concurrencyPolicy: Forbid
  ```
* Use **resource limits** for batch Pods to prevent node exhaustion.
* Log and monitor job completions (`kubectl get jobs -w` or Prometheus metrics).
* Clean up old jobs automatically or via TTL controller:

  ```yaml
  ttlSecondsAfterFinished: 3600
  ```
* Store scripts in container images or mount from ConfigMaps for consistency.

---

### 💡 In short

* **Job** → runs **once** until success (ideal for migrations or one-time tasks).
* **CronJob** → runs **periodically** on a **schedule**, creating Jobs automatically.
* Use `Job` for ad-hoc tasks, `CronJob` for recurring automation (like backups, reports, or cleanup tasks).
---
## Q: How does **Kubernetes perform load balancing**?

---

### 🧠 Overview

Kubernetes performs **load balancing** at **multiple layers** — distributing traffic between:

1. **Pods inside the cluster** (internal traffic).
2. **Nodes or external endpoints** (external traffic).

It uses **Services, kube-proxy, and Ingress controllers** to achieve both **east-west** (Pod-to-Pod) and **north-south** (external-to-cluster) load balancing.

---

### ⚙️ Purpose / How It Works

Kubernetes provides **three main load balancing mechanisms**:

| Layer               | Component                                                 | Description                                                       |
| ------------------- | --------------------------------------------------------- | ----------------------------------------------------------------- |
| **L4 (TCP/UDP)**    | **Service (ClusterIP / NodePort / LoadBalancer)**         | Distributes traffic among Pods using IP and port rules.           |
| **L7 (HTTP/HTTPS)** | **Ingress Controller**                                    | Routes and balances traffic using domain/path rules.              |
| **External**        | **Cloud Load Balancer** (via Service type `LoadBalancer`) | Distributes external traffic into the cluster (cloud-integrated). |

---

### 🧩 1️⃣ Internal Load Balancing — **Service (ClusterIP)**

Kubernetes uses **Services** to load-balance traffic between Pods.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-svc
spec:
  type: ClusterIP
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 8080
```

* Creates a **virtual IP (ClusterIP)** reachable within the cluster.
* **kube-proxy** handles load distribution to all matching Pods (`app=web`).
* Traffic is balanced **round-robin** (or via iptables/IPVS).

✅ Ideal for **Pod-to-Pod** or **microservice-to-microservice** communication.

---

### 🧩 2️⃣ External Load Balancing — **Service (LoadBalancer)**

For exposing apps to the internet in **cloud environments (AWS, Azure, GCP)**:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-lb
spec:
  type: LoadBalancer
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 8080
```

* Automatically provisions a **cloud load balancer** (ELB, ALB, etc.).
* Routes incoming external traffic → node port → Pod.
* Works at **Layer 4 (TCP/UDP)** by default.

✅ Used for **public apps or APIs**.

---

### 🧩 3️⃣ Application-Level Load Balancing — **Ingress (L7)**

**Ingress controllers** (like NGINX, AWS ALB, Traefik) perform **HTTP/HTTPS load balancing** with advanced routing rules.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-svc
            port:
              number: 80
```

* Balances traffic **based on hostname, path, or headers**.
* Supports **TLS termination**.
* Provides **fine-grained control** compared to Services.

✅ Ideal for **multi-service routing**, **API gateways**, and **HTTPS**.

---

### 🧩 How kube-proxy Handles Load Balancing

| Mode          | Description                                         | Mechanism                      |
| ------------- | --------------------------------------------------- | ------------------------------ |
| **iptables**  | Default mode; forwards traffic using iptables rules | Round-robin routing            |
| **IPVS**      | Faster and more scalable alternative                | Kernel-level L4 load balancing |
| **userspace** | Legacy mode (not used in production)                | Proxy process forwards traffic |

Example:

* Service selects Pods by label.
* `kube-proxy` creates routing rules for those Pods.
* Traffic to the Service’s ClusterIP is distributed among backend Pods.

---

### 📋 Load Balancing Flow Summary

```
Client
  ↓
Ingress Controller (L7)
  ↓
Service (LoadBalancer / NodePort / ClusterIP)
  ↓
kube-proxy (iptables / IPVS)
  ↓
Pod (selected by labels)
```

---

### 📋 Types of Load Balancing in Kubernetes

| Type                       | Scope           | Component              | Description                            |
| -------------------------- | --------------- | ---------------------- | -------------------------------------- |
| **Internal (East-West)**   | Pod-to-Pod      | ClusterIP              | Distributes traffic within cluster     |
| **External (North-South)** | Internet-to-Pod | LoadBalancer / Ingress | Exposes service to outside world       |
| **DNS-based**              | Cluster-level   | CoreDNS                | Resolves service names to ClusterIPs   |
| **Client-side (optional)** | App-level       | Custom logic           | Clients handle load balancing manually |

---

### ✅ Best Practices

* Use **Ingress** for HTTP/S traffic (L7) and **Service (LoadBalancer)** for TCP-based apps.
* Use **readiness probes** to prevent routing to unhealthy Pods.
* For internal-only balancing, prefer **ClusterIP**.
* Enable **IPVS mode** for better performance on large clusters.
* Use **Session Affinity** (`sessionAffinity: ClientIP`) if required for sticky sessions.
* In hybrid setups, integrate **external load balancers** (e.g., AWS ALB + Ingress).
* Always secure ingress traffic with **TLS termination**.

---

### 💡 In short

* Kubernetes load balancing works through **Services (L4)** and **Ingress (L7)**.
* **kube-proxy** distributes internal traffic across Pods using label selectors.
* For external access, Kubernetes integrates with **cloud load balancers** or **Ingress controllers** for intelligent routing and high availability.
---
## Q: How to Check **Logs of a Pod** in Kubernetes?

---

### 🧠 Overview

Kubernetes stores container logs for each running Pod, which you can view using the **`kubectl logs`** command.
Logs are essential for **debugging, monitoring, and troubleshooting** containerized applications.

Each container inside a Pod has its own log stream, accessible from the node’s container runtime or directly via `kubectl`.

---

### ⚙️ Purpose / How It Works

* The **kubelet** collects logs from the container runtime (e.g., Docker, containerd) and stores them on the node (`/var/log/containers`).
* `kubectl logs` fetches logs **directly from the container** via the **Kubernetes API server**.
* If the Pod has multiple containers, you must specify which container’s logs you want.

---

### 🧩 Commands / Examples

#### 1️⃣ View logs of a single-container Pod

```bash
kubectl logs <pod-name>
```

Example:

```bash
kubectl logs nginx-pod
```

✅ Shows logs from the container’s stdout and stderr streams.

---

#### 2️⃣ View logs of a Pod with multiple containers

```bash
kubectl logs <pod-name> -c <container-name>
```

Example:

```bash
kubectl logs web-app -c backend
```

---

#### 3️⃣ View logs across all Pods (with label selector)

```bash
kubectl logs -l app=nginx
```

✅ Useful when multiple replicas are managed by a Deployment.

---

#### 4️⃣ Stream logs in real-time (`tail -f` equivalent)

```bash
kubectl logs -f <pod-name>
```

✅ Continuously streams logs (Ctrl + C to stop).

---

#### 5️⃣ View logs from a **previously crashed Pod**

```bash
kubectl logs -p <pod-name>
```

✅ Shows logs from the last terminated container (useful for crash debugging).

---

#### 6️⃣ Combine options

```bash
kubectl logs -f -p <pod-name> -c <container-name>
```

✅ Stream logs of a specific container, including previous runs.

---

#### 7️⃣ Get logs from all Pods in a namespace

```bash
kubectl logs -n dev -l app=myapp --tail=50
```

---

#### 8️⃣ Get logs from all containers in all Pods (Kubernetes v1.23+)

```bash
kubectl logs --all-containers=true --selector app=myapp
```

---

### 🧩 Example: Logs of a failed Pod

```bash
kubectl get pods
kubectl describe pod <pod-name> | grep -A 10 "Events"
kubectl logs <pod-name> --previous
```

---

### 🧩 Node-level (Advanced)

If `kubectl logs` fails (e.g., Pod was evicted or node issue):

```bash
# SSH into node
ssh ec2-user@<node-ip>

# Check container logs on node
sudo ls /var/log/containers/
sudo cat /var/log/containers/<pod_name>_<namespace>_<container>.log
```

---

### 📋 Useful Flags

| Flag           | Description                         |
| -------------- | ----------------------------------- |
| `-f`           | Follow (stream logs)                |
| `--tail=N`     | Show last N lines                   |
| `--since=10m`  | Show logs since last 10 minutes     |
| `--previous`   | Show logs from terminated container |
| `-l`           | Filter by label selector            |
| `--timestamps` | Show timestamps with logs           |
| `-n`           | Specify namespace                   |

---

### ✅ Best Practices

* Always use **label selectors** when debugging replicated workloads (e.g., `kubectl logs -l app=myapp`).
* Use `--since` or `--tail` to limit output size.
* Use `kubectl logs -f` for real-time monitoring in CI/CD or debugging live issues.
* Integrate logs with centralized systems like **ELK / EFK / Loki / CloudWatch / Stackdriver** for persistence.
* For short-lived Pods, capture logs early using `--previous` before they’re garbage collected.
* Avoid `kubectl logs` for production observability — use a proper log aggregator.

---

### 💡 In short

* Use `kubectl logs <pod>` to view container logs directly.
* Add `-c` for multi-container Pods, `-f` for streaming, `-p` for previous runs.
* For scalable visibility, integrate logs with **ELK, Loki, or CloudWatch**.
---
## Q: How do you Access a **Pod Shell** in Kubernetes?

---

### 🧠 Overview

To access a **running container’s shell** inside a Pod, you use the **`kubectl exec`** command.
It opens an **interactive terminal session** (`/bin/sh` or `/bin/bash`) directly into the container — useful for **debugging, inspecting environment variables, or testing network connectivity**.

---

### ⚙️ Purpose / How It Works

* `kubectl exec` connects to a container through the **Kubernetes API Server** (not via SSH).
* Works only if the container image includes a shell (e.g., `bash`, `sh`, `ash`).
* If the Pod has multiple containers, you must specify which container to connect to.
* You can also run **single commands** inside the container instead of an interactive session.

---

### 🧩 Commands / Examples

#### 1️⃣ Access an interactive shell inside a Pod

```bash
kubectl exec -it <pod-name> -- /bin/bash
```

Example:

```bash
kubectl exec -it nginx-pod -- /bin/bash
```

✅ Opens an interactive Bash shell.

If the image doesn’t have Bash:

```bash
kubectl exec -it nginx-pod -- /bin/sh
```

---

#### 2️⃣ Access a specific container (multi-container Pod)

```bash
kubectl exec -it <pod-name> -c <container-name> -- /bin/sh
```

Example:

```bash
kubectl exec -it web-app -c backend -- /bin/sh
```

---

#### 3️⃣ Run a single command inside a container

```bash
kubectl exec <pod-name> -- ls /app
kubectl exec <pod-name> -- cat /etc/hosts
kubectl exec <pod-name> -- env
```

✅ Executes and exits without opening an interactive shell.

---

#### 4️⃣ Check environment variables

```bash
kubectl exec -it <pod-name> -- printenv
```

---

#### 5️⃣ Run a debug container (if shell not available)

For minimal or distroless images (no shell binaries):

```bash
kubectl debug -it <pod-name> --image=busybox --target=<container-name>
```

✅ Launches a **temporary debug container** in the same network namespace.

---

#### 6️⃣ Example Workflow

```bash
# 1. Get pod list
kubectl get pods

# 2. Access shell
kubectl exec -it myapp-pod -- /bin/sh

# 3. Check files, network, env
ls /etc
cat /etc/resolv.conf
ping google.com
```

---

### 📋 Common Flags

| Flag          | Description                                               |
| ------------- | --------------------------------------------------------- |
| `-i`          | Interactive mode                                          |
| `-t`          | Allocate a TTY (for shell experience)                     |
| `-c`          | Specify container name                                    |
| `--`          | Marks the end of kubectl args, start of container command |
| `--namespace` | Specify namespace if Pod is not in default                |

---

### ⚠️ Troubleshooting Tips

* **“error: unable to upgrade connection”** → Container may not be running. Check `kubectl get pods` or `describe pod`.
* **“/bin/bash not found”** → Try `/bin/sh` or `/bin/ash`.
* **No shell in container** → Use `kubectl debug` with `busybox` or `alpine` image.
* **Permission denied** → Container’s user may lack shell access; check image’s user permissions.

---

### ✅ Best Practices

* Prefer `/bin/sh` over `/bin/bash` for maximum compatibility.
* Avoid changing configs inside the Pod — they’ll reset on restart.
* Use `kubectl exec` for short debugging only — not as a persistent access method.
* Use `kubectl debug` for immutable or minimal images.
* If frequent troubleshooting is required, integrate with **Kubernetes Debug Container** feature (Ephemeral Containers).

---

### 💡 In short

* Use `kubectl exec -it <pod> -- /bin/sh` to get a shell inside a running container.
* Add `-c <container>` for multi-container Pods.
* For shell-less images, use `kubectl debug` with a temporary debug container.
* It’s the **primary method for on-cluster debugging** without SSH access.
---
## Q: What is a **PersistentVolume (PV)** and **PersistentVolumeClaim (PVC)** in Kubernetes?

---

### 🧠 Overview

In Kubernetes, **storage is abstracted** from the underlying infrastructure using two key objects:

* **PersistentVolume (PV):** A **cluster-wide storage resource** provisioned by an admin (or dynamically by StorageClasses).
* **PersistentVolumeClaim (PVC):** A **user request for storage** that consumes a PV.

Together, PVs and PVCs enable **persistent, decoupled, and portable storage** for Pods — ensuring data **survives Pod restarts, rescheduling, and node failures**.

---

### ⚙️ Purpose / How It Works

**Storage Flow:**

```
Pod → PersistentVolumeClaim → PersistentVolume → Physical Storage (EBS, NFS, etc.)
```

1. **PersistentVolume (PV):**

   * Represents **actual physical storage** (EBS, NFS, Azure Disk, etc.).
   * Managed by cluster admin or **dynamically provisioned** using a StorageClass.
   * Has lifecycle independent of any Pod.

2. **PersistentVolumeClaim (PVC):**

   * A **user’s request** for storage (size, access mode, etc.).
   * Binds automatically to a matching PV.
   * Pod mounts the PVC to access data.

---

### 🧩 Example: PV and PVC YAMLs

#### 1️⃣ **PersistentVolume (PV)**

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-data
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
  hostPath:
    path: /mnt/data
```

✅ A **5Gi local volume** available under `/mnt/data`.

---

#### 2️⃣ **PersistentVolumeClaim (PVC)**

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
  storageClassName: manual
```

✅ Requests **2Gi** storage and binds to a matching PV.

---

#### 3️⃣ **Pod using PVC**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - mountPath: /usr/share/nginx/html
      name: app-storage
  volumes:
  - name: app-storage
    persistentVolumeClaim:
      claimName: pvc-data
```

✅ Mounts the PVC inside the Pod at `/usr/share/nginx/html`.

---

### 📋 Access Modes

| Access Mode                 | Description                          | Example Use                          |
| --------------------------- | ------------------------------------ | ------------------------------------ |
| **ReadWriteOnce (RWO)**     | Mounted by one node read/write       | EBS, local storage                   |
| **ReadOnlyMany (ROX)**      | Mounted by many nodes read-only      | NFS, GlusterFS                       |
| **ReadWriteMany (RWX)**     | Mounted by many nodes read/write     | NFS, CephFS, EFS                     |
| **ReadWriteOncePod (RWOP)** | Mounted by a single Pod (K8s v1.22+) | Stateful apps needing exclusive disk |

---

### 📋 PV Reclaim Policies

| Policy                   | Behavior After PVC Deletion             | Use Case                    |
| ------------------------ | --------------------------------------- | --------------------------- |
| **Retain**               | Keeps data; manual cleanup needed       | Databases, critical data    |
| **Recycle (deprecated)** | Wipes and reuses volume                 | Legacy clusters             |
| **Delete**               | Deletes volume from backend (e.g., EBS) | Dynamic provisioning setups |

---

### 🧩 Dynamic Provisioning Example (using StorageClass)

#### StorageClass

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gp2
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
  fsType: ext4
reclaimPolicy: Delete
```

#### PVC using StorageClass

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-dynamic
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: gp2
```

✅ Kubernetes automatically provisions an **EBS volume** and binds it to this PVC.

---

### 📋 PV vs PVC — Comparison Table

| Feature        | **PersistentVolume (PV)**           | **PersistentVolumeClaim (PVC)** |
| -------------- | ----------------------------------- | ------------------------------- |
| **Created by** | Admin or StorageClass               | User / Pod definition           |
| **Represents** | Actual storage resource             | Request for storage             |
| **Scope**      | Cluster-level                       | Namespace-scoped                |
| **Binding**    | One PV ↔ One PVC                    | One PVC ↔ One PV                |
| **Lifecycle**  | Independent of Pod                  | Bound to Pod usage              |
| **Defines**    | Capacity, access mode, backend path | Requested size, mode, class     |

---

### ✅ Best Practices

* Use **dynamic provisioning** with `StorageClass` instead of manual PV creation.
* Use **Retain** policy for critical data (databases, logs).
* Match **`storageClassName`** between PV and PVC.
* Use **`ReadWriteMany (RWX)`** for shared file systems (e.g., NFS/EFS).
* Use **namespaced PVCs** to isolate team storage.
* Clean up unused PVs to reclaim cluster storage.
* Use **`volumeMounts.subPath`** to isolate multiple apps in a single PVC.
* Monitor PV utilization with tools like **Prometheus + kube-state-metrics**.

---

### 💡 In short

* **PV = physical volume (admin-defined or dynamic)**
* **PVC = user’s storage request** bound to a PV
* Together, they give Pods **persistent storage** that **survives restarts and rescheduling** — essential for **stateful applications** like databases and file servers.
---
## Q: What is a **PersistentVolume (PV)** and **PersistentVolumeClaim (PVC)** in Kubernetes?

---

### 🧠 Overview

In Kubernetes, **storage is abstracted** from the underlying infrastructure using two key objects:

* **PersistentVolume (PV):** A **cluster-wide storage resource** provisioned by an admin (or dynamically by StorageClasses).
* **PersistentVolumeClaim (PVC):** A **user request for storage** that consumes a PV.

Together, PVs and PVCs enable **persistent, decoupled, and portable storage** for Pods — ensuring data **survives Pod restarts, rescheduling, and node failures**.

---

### ⚙️ Purpose / How It Works

**Storage Flow:**

```
Pod → PersistentVolumeClaim → PersistentVolume → Physical Storage (EBS, NFS, etc.)
```

1. **PersistentVolume (PV):**

   * Represents **actual physical storage** (EBS, NFS, Azure Disk, etc.).
   * Managed by cluster admin or **dynamically provisioned** using a StorageClass.
   * Has lifecycle independent of any Pod.

2. **PersistentVolumeClaim (PVC):**

   * A **user’s request** for storage (size, access mode, etc.).
   * Binds automatically to a matching PV.
   * Pod mounts the PVC to access data.

---

### 🧩 Example: PV and PVC YAMLs

#### 1️⃣ **PersistentVolume (PV)**

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-data
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
  hostPath:
    path: /mnt/data
```

✅ A **5Gi local volume** available under `/mnt/data`.

---

#### 2️⃣ **PersistentVolumeClaim (PVC)**

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
  storageClassName: manual
```

✅ Requests **2Gi** storage and binds to a matching PV.

---

#### 3️⃣ **Pod using PVC**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - mountPath: /usr/share/nginx/html
      name: app-storage
  volumes:
  - name: app-storage
    persistentVolumeClaim:
      claimName: pvc-data
```

✅ Mounts the PVC inside the Pod at `/usr/share/nginx/html`.

---

### 📋 Access Modes

| Access Mode                 | Description                          | Example Use                          |
| --------------------------- | ------------------------------------ | ------------------------------------ |
| **ReadWriteOnce (RWO)**     | Mounted by one node read/write       | EBS, local storage                   |
| **ReadOnlyMany (ROX)**      | Mounted by many nodes read-only      | NFS, GlusterFS                       |
| **ReadWriteMany (RWX)**     | Mounted by many nodes read/write     | NFS, CephFS, EFS                     |
| **ReadWriteOncePod (RWOP)** | Mounted by a single Pod (K8s v1.22+) | Stateful apps needing exclusive disk |

---

### 📋 PV Reclaim Policies

| Policy                   | Behavior After PVC Deletion             | Use Case                    |
| ------------------------ | --------------------------------------- | --------------------------- |
| **Retain**               | Keeps data; manual cleanup needed       | Databases, critical data    |
| **Recycle (deprecated)** | Wipes and reuses volume                 | Legacy clusters             |
| **Delete**               | Deletes volume from backend (e.g., EBS) | Dynamic provisioning setups |

---

### 🧩 Dynamic Provisioning Example (using StorageClass)

#### StorageClass

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gp2
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
  fsType: ext4
reclaimPolicy: Delete
```

#### PVC using StorageClass

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-dynamic
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: gp2
```

✅ Kubernetes automatically provisions an **EBS volume** and binds it to this PVC.

---

### 📋 PV vs PVC — Comparison Table

| Feature        | **PersistentVolume (PV)**           | **PersistentVolumeClaim (PVC)** |
| -------------- | ----------------------------------- | ------------------------------- |
| **Created by** | Admin or StorageClass               | User / Pod definition           |
| **Represents** | Actual storage resource             | Request for storage             |
| **Scope**      | Cluster-level                       | Namespace-scoped                |
| **Binding**    | One PV ↔ One PVC                    | One PVC ↔ One PV                |
| **Lifecycle**  | Independent of Pod                  | Bound to Pod usage              |
| **Defines**    | Capacity, access mode, backend path | Requested size, mode, class     |

---

### ✅ Best Practices

* Use **dynamic provisioning** with `StorageClass` instead of manual PV creation.
* Use **Retain** policy for critical data (databases, logs).
* Match **`storageClassName`** between PV and PVC.
* Use **`ReadWriteMany (RWX)`** for shared file systems (e.g., NFS/EFS).
* Use **namespaced PVCs** to isolate team storage.
* Clean up unused PVs to reclaim cluster storage.
* Use **`volumeMounts.subPath`** to isolate multiple apps in a single PVC.
* Monitor PV utilization with tools like **Prometheus + kube-state-metrics**.

---

### 💡 In short

* **PV = physical volume (admin-defined or dynamic)**
* **PVC = user’s storage request** bound to a PV
* Together, they give Pods **persistent storage** that **survives restarts and rescheduling** — essential for **stateful applications** like databases and file servers.


## Q: What is a **PersistentVolume (PV)** and **PersistentVolumeClaim (PVC)** in Kubernetes?

---

### 🧠 Overview

Kubernetes uses **PersistentVolumes (PVs)** and **PersistentVolumeClaims (PVCs)** to provide **persistent storage** that survives Pod restarts and rescheduling.
They abstract the underlying storage so Pods can request storage without knowing where or how it’s provided.

---

### ⚙️ Purpose / How It Works

* **PersistentVolume (PV):** Represents an actual piece of storage (EBS, NFS, etc.). Created manually or dynamically by a **StorageClass**.
* **PersistentVolumeClaim (PVC):** A user’s request for storage (size, access mode). Kubernetes binds the PVC to a matching PV.
* Once bound, Pods can **mount the PVC** as a volume to persist data.

```
Pod → PVC → PV → Backend Storage (EBS/NFS/EFS)
```

---

### 🧩 YAML Examples

#### 1️⃣ PersistentVolume (PV)

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-data
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
  hostPath:
    path: /mnt/data
```

#### 2️⃣ PersistentVolumeClaim (PVC)

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: manual
```

#### 3️⃣ Pod Using PVC

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: data
      mountPath: /usr/share/nginx/html
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: pvc-data
```

---

### 📋 Access Modes

| Mode                    | Description                         | Example Storage |
| ----------------------- | ----------------------------------- | --------------- |
| **ReadWriteOnce (RWO)** | Mounted read/write by a single node | EBS, Disk       |
| **ReadOnlyMany (ROX)**  | Mounted read-only by many nodes     | NFS             |
| **ReadWriteMany (RWX)** | Mounted read/write by many nodes    | EFS, CephFS     |

---

### 📋 PV Reclaim Policies

| Policy      | Behavior                             | Use Case             |
| ----------- | ------------------------------------ | -------------------- |
| **Retain**  | Keeps data for manual recovery       | Databases            |
| **Delete**  | Deletes backend storage              | Dynamic provisioning |
| **Recycle** | Wipes and reuses volume (deprecated) | Legacy               |

---

### 📋 PV vs PVC

| Feature    | **PV**               | **PVC**             |
| ---------- | -------------------- | ------------------- |
| Defined by | Admin / StorageClass | User                |
| Represents | Actual storage       | Request for storage |
| Scope      | Cluster-wide         | Namespace-scoped    |
| Lifecycle  | Independent          | Bound to Pod        |
| Binding    | One-to-one           | One-to-one          |

---

### ✅ Best Practices

* Prefer **dynamic provisioning** via `StorageClass`.
* Use **Retain** for critical data, **Delete** for ephemeral.
* Always match `storageClassName` between PV & PVC.
* Monitor PV utilization (Prometheus, kube-state-metrics).
* Use **subPath** when sharing PVCs among containers.
* Define clear **resource quotas** per namespace to avoid overuse.

---

### 💡 In short

* **PV** = actual storage resource; **PVC** = request for that storage.
* Together they let Pods use **persistent, portable, and decoupled storage**.
* Essential for **stateful workloads** like databases, caches, and file storage.
---
## Q: How do you expose a Deployment externally?

---

### 🧠 Overview

You can expose a Kubernetes `Deployment` to external clients via multiple mechanisms: **Service (LoadBalancer / NodePort / ExternalName)**, **Ingress (HTTP/S routing + TLS)**, or ad-hoc methods (`kubectl port-forward`) for debugging.
Choose method based on protocol (HTTP vs TCP), cloud provider, and production requirements (TLS, WAF, DNS).

---

### ⚙️ Purpose / How it works

* **Service (ClusterIP)** gives internal access.
* **NodePort** opens a fixed port on every node → simple but not ideal for prod.
* **LoadBalancer** provisions a cloud LB (ELB/NLB/SLB) and routes traffic to Service.
* **Ingress** provides L7 routing (host/path), TLS termination, and is backed by an Ingress Controller (NGINX, AWS ALB Controller, Traefik).
* **ExternalName** maps a K8s service to an external DNS name (no proxy).
* **kubectl port-forward** is for local debugging only.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Quick: `kubectl expose` (creates a NodePort or ClusterIP)

```bash
# create deployment
kubectl create deployment web --image=nginx

# expose as NodePort (not recommended for prod)
kubectl expose deployment web --type=NodePort --port=80 --target-port=80

# show service
kubectl get svc web -o wide
```

#### 2) Service type: **LoadBalancer** (AWS/GCP/Azure)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-lb
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http
spec:
  type: LoadBalancer
  selector:
    app: web
  ports:
    - port: 80
      targetPort: 80
```

```bash
kubectl apply -f svc-loadbalancer.yaml
# wait for EXTERNAL-IP, then map DNS to it
kubectl get svc web-lb
```

**AWS NLB example annotation**

```yaml
metadata:
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
    service.beta.kubernetes.io/aws-load-balancer-internal: "0.0.0.0/0"
```

#### 3) Ingress (recommended for HTTP/S routing + TLS)

**Ingress + Service**
`svc-clusterip.yaml` (ClusterIP service)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-svc
spec:
  type: ClusterIP
  selector:
    app: web
  ports:
    - port: 80
      targetPort: 80
```

`ingress.yaml` (Ingress resource)

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"            # depends on your ingress controller
    cert-manager.io/cluster-issuer: "letsencrypt"   # example TLS automation
spec:
  tls:
  - hosts:
    - app.example.com
    secretName: app-tls
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-svc
            port:
              number: 80
```

Apply:

```bash
kubectl apply -f svc-clusterip.yaml
kubectl apply -f ingress.yaml
# Ensure an Ingress Controller (NGINX / AWS ALB Controller) is running in cluster.
```

#### 4) Ingress with AWS Load Balancer Controller (ALB) annotations

```yaml
metadata:
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80},{"HTTPS":443}]'
```

#### 5) Debug: `kubectl port-forward` (local dev)

```bash
kubectl port-forward deployment/web 8080:80
# open http://localhost:8080
```

#### 6) ExternalName (DNS mapping to external service)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-api
spec:
  type: ExternalName
  externalName: api.external.com
```

---

### 📋 Comparison Table

|                   Method |              Best for             |   TLS/HTTP routing  |         Cloud integration         |   Prod-friendly?  |
| -----------------------: | :-------------------------------: | :-----------------: | :-------------------------------: | :---------------: |
|              **Ingress** |   HTTP/S with host/path routing   | ✅ (TLS termination) |  Requires controller (NGINX/ALB)  |  ✅ (recommended)  |
|         **LoadBalancer** |    Simple external LB (TCP/UDP)   |     ✅ (LB-level)    | Auto-provision cloud LB (ELB/NLB) |         ✅         |
|             **NodePort** | Quick test or bare-metal fallback |      ❌ (basic)      |            No cloud LB            |   ⚠️ (not ideal)  |
|         **ExternalName** |   Proxy DNS to external service   |         n/a         |              DNS only             | ✅ (for remapping) |
| **kubectl port-forward** |          Local debugging          |          ❌          |                None               |    ❌ (dev only)   |

---

### ✅ Best Practices

* **Prefer Ingress** for HTTP/S traffic — central TLS, path-based routing, WAF, auth.
* Use **LoadBalancer** for non-HTTP TCP/UDP or single-service exposure.
* **Do not use NodePort in production** (security, limited ports, manual LB required).
* Configure **readiness probes** so LB/Ingress only routes to healthy Pods.
* Set `externalTrafficPolicy: Local` if preserving client IP is required.
* Use **DNS records** (Route53/Cloud DNS) pointing to LB/Ingress endpoint; use low TTL if you need quick failover.
* Terminate TLS at Ingress (or ALB) and enforce strong ciphers & HSTS.
* Use cloud-native controllers (AWS ALB Controller / GCP GLBC) for integration and health checks.
* Secure public endpoints with WAF, security groups, and network policies.
* Automate certificate provisioning using **cert-manager**.
* Monitor LB health & request metrics (Prometheus, ALB logs).

---

### 💡 In short

* For HTTP/S: **Ingress** (with an Ingress Controller) is the standard — TLS, routing, central control.
* For TCP/UDP or simple setups: **Service type=LoadBalancer** provisions cloud LB.
* Use **NodePort** only for testing or on-prem fallbacks; use **kubectl port-forward** for local debugging.
* Always combine readiness probes, DNS, TLS, and least-privilege network controls for production exposure.
---
## Q: What is a **NodePort Service** in Kubernetes?

---

### 🧠 Overview

A **NodePort** service is a **Kubernetes Service type** that exposes a Pod (via a ClusterIP) on a **static port (30000–32767)** on **each node’s IP**.
It enables **external access** to applications running inside the cluster without needing a cloud load balancer.

It’s typically used for **development, testing**, or **bare-metal clusters**, not production (due to manual load management and open node ports).

---

### ⚙️ Purpose / How It Works

* When you create a Service of type `NodePort`, Kubernetes:

  1. Creates an internal **ClusterIP** service.
  2. Opens the specified port on **every node** in the cluster.
  3. Routes incoming traffic from `<NodeIP>:<NodePort>` → ClusterIP → backend Pods.

**Flow:**

```
External Client → NodeIP:NodePort → kube-proxy → ClusterIP → Pod(s)
```

This allows you to access the app from **any node’s IP address** using that port.

---

### 🧩 Example YAML

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-nodeport
spec:
  type: NodePort
  selector:
    app: web
  ports:
  - port: 80              # Service (ClusterIP) port
    targetPort: 8080      # Container port
    nodePort: 30080       # Fixed external port (optional)
```

Apply:

```bash
kubectl apply -f web-nodeport.yaml
kubectl get svc web-nodeport
```

✅ Access the app:

```
http://<NodeIP>:30080
```

If using Minikube:

```bash
minikube service web-nodeport
```

---

### 🧩 Command-Line Shortcut

```bash
kubectl expose deployment web --type=NodePort --port=80 --target-port=8080
```

---

### 📋 Key Ports Explanation

| Port Type      | Description                                                                |
| -------------- | -------------------------------------------------------------------------- |
| **port**       | Cluster-internal Service port                                              |
| **targetPort** | Container’s listening port                                                 |
| **nodePort**   | External port opened on each node (default auto-assigned from 30000–32767) |

---

### 📋 NodePort vs LoadBalancer vs ClusterIP

| Feature               | **ClusterIP**                | **NodePort**                | **LoadBalancer**      |
| --------------------- | ---------------------------- | --------------------------- | --------------------- |
| **Access Scope**      | Internal only                | External via node IP + port | External via cloud LB |
| **Port Range**        | Custom (any)                 | 30000–32767                 | Managed by cloud      |
| **Cloud Integration** | ❌                            | ❌                           | ✅                     |
| **Typical Use**       | Microservice-to-microservice | Dev/test, bare-metal        | Production            |
| **DNS Resolution**    | Cluster DNS                  | Manual or external DNS      | Cloud-managed DNS     |

---

### ✅ Best Practices

* Use **NodePort** for:

  * On-prem / bare-metal clusters without LoadBalancer integration.
  * Testing simple external access without Ingress or LB.
* Avoid hardcoding ports — let Kubernetes assign automatically unless required.
* Protect open node ports using **firewalls or NetworkPolicies**.
* Combine with **Ingress** for HTTP routing instead of exposing NodePort directly.
* For production, prefer **Service type=LoadBalancer** or **Ingress**.
* Use **readiness probes** to ensure traffic hits only healthy Pods.
* Monitor NodePorts to prevent port conflicts or exposure of sensitive services.

---

### 💡 In short

* A **NodePort Service** exposes Pods on each node’s IP at a fixed port (30000–32767).
* Access: `http://<NodeIP>:<NodePort>`
* Great for quick testing or bare-metal clusters — but use **LoadBalancer** or **Ingress** for scalable, secure production setups.
---
## Q: What is an **Ingress** in Kubernetes?

---

### 🧠 Overview

An **Ingress** in Kubernetes is an **API object** that manages **external HTTP(S) access** to Services inside a cluster.
It provides **Layer 7 (application-level)** routing — based on **domain names, paths, or protocols** — and supports **TLS termination**, eliminating the need to expose each service via separate LoadBalancers or NodePorts.

Think of it as Kubernetes’ **reverse proxy and traffic router**.

---

### ⚙️ Purpose / How It Works

* Ingress routes **external client traffic → cluster Services (Pods)** using defined **rules**.
* It requires an **Ingress Controller** (e.g., NGINX, AWS ALB, Traefik, HAProxy) that actually performs routing.
* The Ingress resource defines *what to route* and *how*, while the Ingress Controller implements *where and with what settings*.

**Flow:**

```
Client → Ingress Controller → Service (ClusterIP) → Pod
```

---

### 🧩 Example — Basic HTTP Routing

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

✅ Traffic to `http://myapp.example.com` → routes to Service `web-service` → backend Pods.

---

### 🧩 Example — Multiple Paths (Path-based Routing)

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
spec:
  rules:
  - host: mysite.example.com
    http:
      paths:
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 8080
      - path: /web
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

✅ `/api` → `api-service`; `/web` → `web-service`.

---

### 🧩 Example — TLS (HTTPS Termination)

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: secure-ingress
spec:
  tls:
  - hosts:
    - myapp.example.com
    secretName: tls-secret
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

✅ Uses TLS certificate from secret `tls-secret` for HTTPS.

---

### 🧩 Example — With AWS ALB Controller

```yaml
metadata:
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80},{"HTTPS":443}]'
    alb.ingress.kubernetes.io/target-type: ip
```

✅ Creates an **AWS ALB** and registers Pods as IP targets.

---

### 📋 Key Ingress Components

| Component               | Description                                          |
| ----------------------- | ---------------------------------------------------- |
| **Ingress Resource**    | Defines routing rules (host/path/TLS)                |
| **Ingress Controller**  | Implements routing logic (NGINX, Traefik, ALB, etc.) |
| **Service (ClusterIP)** | Backend service the Ingress routes traffic to        |
| **Secret (TLS)**        | Stores certificates for HTTPS termination            |

---

### 📋 Ingress vs Service Comparison

| Feature             | **Service (LoadBalancer)** | **Ingress**                       |
| ------------------- | -------------------------- | --------------------------------- |
| **Layer**           | L4 (TCP/UDP)               | L7 (HTTP/HTTPS)                   |
| **Routing**         | Single service per LB      | Multi-service routing (path/host) |
| **TLS Termination** | Cloud LB-level             | Ingress Controller                |
| **DNS/Domain**      | Single endpoint            | Multiple domains                  |
| **Cost Efficiency** | 1 LB per service           | 1 LB shared across apps           |
| **Common Use**      | Simple apps or non-HTTP    | Web/API routing with TLS          |

---

### ✅ Best Practices

* Deploy an **Ingress Controller** (e.g., NGINX Ingress Controller or AWS ALB Controller).
* Use **pathType: Prefix** for flexible routing.
* Automate TLS using **cert-manager** for Let’s Encrypt certificates.
* Use **rewrite-target annotations** for clean URL rewrites when needed.
* Use **NetworkPolicies** or **WAFs** to restrict ingress traffic.
* Use **`defaultBackend`** for handling 404 or root requests.
* For multi-domain routing, prefer one Ingress with multiple host rules.
* Always verify DNS (e.g., `CNAME` → Ingress/LoadBalancer external IP).

---

### 💡 In short

* **Ingress = HTTP/HTTPS router** that controls external access to internal Services.
* Works via an **Ingress Controller** (NGINX, ALB, etc.).
* Supports **path-based, host-based routing**, and **TLS termination** — making it the **standard production method** for exposing web applications in Kubernetes.
---
## Q: What is an **Ingress Controller** and Why Do You Need It?

---

### 🧠 Overview

An **Ingress Controller** is the **actual implementation** that makes Kubernetes **Ingress resources work**.
While an **Ingress** defines *rules* (how traffic should route), the **Ingress Controller** is the **engine** that reads those rules and configures a **reverse proxy or load balancer** (like NGINX, AWS ALB, or Traefik) to enforce them.

Without an Ingress Controller, **Ingress resources do nothing** — they’re just definitions in the API.

---

### ⚙️ Purpose / How It Works

**Ingress = What to do**
**Ingress Controller = How to do it**

Here’s how it works step-by-step:

1. You create an **Ingress resource** with routing/TLS rules.
2. The **Ingress Controller** continuously watches the API server for new or updated Ingress objects.
3. It dynamically updates its **reverse proxy config** (NGINX, ALB, Traefik, etc.) to match those rules.
4. Incoming external requests hit the controller (via LoadBalancer or NodePort).
5. The controller **routes requests** to the correct Service/Pod based on hostname or path.

**Flow:**

```
Client → Ingress Controller (LoadBalancer) → Ingress Rules → Service → Pod
```

---

### 🧩 Common Ingress Controllers

| Controller                                                    | Description                                                    | Typical Environment                 |
| ------------------------------------------------------------- | -------------------------------------------------------------- | ----------------------------------- |
| **NGINX Ingress Controller**                                  | Most popular; open-source; supports rich annotations           | On-prem, Minikube, generic clusters |
| **AWS ALB Ingress Controller (AWS Load Balancer Controller)** | Uses AWS ALB for routing; integrates with Route53, ACM         | AWS EKS                             |
| **Traefik Ingress Controller**                                | Lightweight, dynamic configuration                             | Cloud-native, microservice setups   |
| **HAProxy Ingress Controller**                                | Enterprise-grade performance and advanced routing              | High-throughput clusters            |
| **GKE Ingress Controller**                                    | Managed by GCP; auto-creates Google Cloud LBs                  | Google Kubernetes Engine            |
| **Istio Gateway**                                             | Layer 7 gateway built on Envoy; advanced service mesh features | Service mesh environments           |

---

### 🧩 Example — NGINX Ingress Controller Setup

#### Step 1: Deploy Controller

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```

This deploys:

* `ingress-nginx-controller` (Deployment + Service)
* `Service` of type `LoadBalancer` exposing the controller

#### Step 2: Create Ingress Resource

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  annotations:
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

✅ The controller watches this Ingress, updates its NGINX config, and begins routing traffic to `web-service`.

---

### 📋 Why You Need an Ingress Controller

| Reason                       | Description                                         |
| ---------------------------- | --------------------------------------------------- |
| **Implements Ingress rules** | Without it, Ingress objects have no effect          |
| **Centralized routing**      | One load balancer can route traffic to many apps    |
| **TLS termination**          | Handles HTTPS certificates (e.g., via cert-manager) |
| **Advanced routing**         | Host/path-based routing, rewrites, redirects        |
| **Security features**        | WAF, rate limiting, basic auth, IP whitelisting     |
| **Cost efficiency**          | Avoids one LoadBalancer per app; single entry point |
| **Observability**            | Exposes metrics/logs for incoming HTTP traffic      |

---

### 📋 Ingress Controller vs Ingress vs LoadBalancer

| Feature                   | **Ingress Resource** | **Ingress Controller**    | **Service (LoadBalancer)** |
| ------------------------- | -------------------- | ------------------------- | -------------------------- |
| Defines routing rules?    | ✅ Yes                | ❌ No (implements them)    | ❌ No                       |
| Handles HTTP/S traffic?   | ❌                    | ✅                         | ✅ (basic L4 only)          |
| Performs TLS termination? | ❌                    | ✅                         | ✅                          |
| Cloud integration?        | ❌                    | ✅ (depends on controller) | ✅                          |
| Multi-service routing?    | ✅                    | ✅                         | ❌ (one service per LB)     |

---

### ✅ Best Practices

* Always deploy **one Ingress Controller** per cluster (multiple only if needed).
* Use **IngressClass** to specify which controller should handle which Ingress.
* Automate **TLS certificate provisioning** using **cert-manager**.
* Enable **access logs and Prometheus metrics** for monitoring.
* Secure controller with **NetworkPolicies** and **WAF integration**.
* Use **annotations** to customize behavior (timeouts, rewrites, security headers).
* For high availability, use a **Deployment** (not DaemonSet) with replicas behind a LoadBalancer.

---

### 💡 In short

* An **Ingress Controller** is the **runtime component** that enforces Ingress rules.
* It **listens to the Kubernetes API**, updates its routing dynamically, and manages **HTTP(S) load balancing**.
* Without it, an Ingress resource is inert — the controller is what actually makes external web traffic reach your Pods securely and efficiently.
---
## Q: What is a **ServiceAccount** in Kubernetes?

---

### 🧠 Overview

A **ServiceAccount (SA)** in Kubernetes is an **identity used by Pods** (or other Kubernetes components) to **authenticate and access the API server** securely.
It provides **fine-grained access control** for workloads running inside the cluster — similar to how **user accounts** are used for humans.

Each Pod automatically gets a **default ServiceAccount**, but you can (and should) create custom ones for specific apps or automation tasks with **least-privilege access**.

---

### ⚙️ Purpose / How It Works

* ServiceAccounts are used by **processes inside Pods**, not by humans.
* When a Pod runs, it automatically:

  1. Is **assigned a ServiceAccount** (default or specified).
  2. Mounts a **JWT token** into the Pod (`/var/run/secrets/kubernetes.io/serviceaccount/token`).
  3. Uses that token to **authenticate** to the **API Server** via RBAC.
* Admins define **Roles/ClusterRoles** and bind them to ServiceAccounts via **RoleBindings** or **ClusterRoleBindings** to control permissions.

---

### 🧩 Example — Create and Use a Custom ServiceAccount

#### 1️⃣ Create a ServiceAccount

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-sa
  namespace: dev
```

Apply:

```bash
kubectl apply -f sa.yaml
```

---

#### 2️⃣ Use the ServiceAccount in a Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-pod
  namespace: dev
spec:
  serviceAccountName: app-sa
  containers:
  - name: demo
    image: bitnami/kubectl
    command: ["sleep", "3600"]
```

✅ This Pod now authenticates to the API as `app-sa` instead of `default`.

---

#### 3️⃣ Grant Permissions (RBAC)

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: dev
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-pods
  namespace: dev
subjects:
- kind: ServiceAccount
  name: app-sa
  namespace: dev
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

✅ The `app-sa` can now only **list and get Pods** in the `dev` namespace.

---

### 📋 Key Fields

| Field                          | Description                                              |
| ------------------------------ | -------------------------------------------------------- |
| `metadata.name`                | Name of the ServiceAccount                               |
| `automountServiceAccountToken` | Controls if the token is auto-mounted in Pods            |
| `secrets`                      | Optional; references specific secrets for authentication |
| `imagePullSecrets`             | Used to pull private container images                    |

---

### 📋 Default vs Custom ServiceAccount

| Type                   | Description                                | Use Case                                          |
| ---------------------- | ------------------------------------------ | ------------------------------------------------- |
| **default**            | Automatically created in every namespace   | Basic Pods without special privileges             |
| **custom**             | Created by users; attached manually        | Apps needing API access (e.g., controllers, jobs) |
| **automount disabled** | Security hardening to avoid token exposure | High-security environments                        |

---

### 🧩 Example — Disable Token Mounting (for security)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
spec:
  serviceAccountName: app-sa
  automountServiceAccountToken: false
  containers:
  - name: app
    image: nginx
```

✅ Prevents automatic mounting of the ServiceAccount token.

---

### 📋 Common Uses

| Use Case                         | Example                                                           |
| -------------------------------- | ----------------------------------------------------------------- |
| **Controller authentication**    | Deployments, Jobs, CronJobs use SA to talk to API                 |
| **CI/CD pipelines**              | Jenkins or ArgoCD uses SA to deploy apps                          |
| **Monitoring tools**             | Prometheus uses SA to scrape API metrics                          |
| **Secrets or ConfigMaps access** | Pods read configs via API securely                                |
| **Cloud integrations**           | AWS IRSA, GCP Workload Identity use SAs to assume cloud IAM roles |

---

### 📋 ServiceAccount vs User Account

| Feature     | **ServiceAccount**              | **User Account**                |
| ----------- | ------------------------------- | ------------------------------- |
| Used by     | Pods / workloads                | Humans                          |
| Managed by  | Kubernetes API                  | External (via OIDC, LDAP, etc.) |
| Token type  | JWT (auto-mounted)              | kubeconfig / OIDC               |
| Scope       | Namespace (default)             | Cluster-wide                    |
| Created by  | `kubectl create serviceaccount` | External IAM or kubeconfig      |
| Typical use | In-cluster automation           | kubectl, CI/CD operators        |

---

### ✅ Best Practices

* Create **dedicated ServiceAccounts** per app or component.
* Apply **least privilege RBAC** — only required verbs/resources.
* Avoid `default` SA for production workloads.
* Disable token auto-mounting if not required:

  ```yaml
  automountServiceAccountToken: false
  ```
* Use **Namespace-scoped Roles** for limited access.
* For multi-cluster/cloud environments, integrate with:

  * **AWS IRSA (IAM Roles for Service Accounts)**
  * **GCP Workload Identity**
  * **Azure Managed Identity for Pods**
* Rotate or invalidate tokens regularly for security.

---

### 💡 In short

* A **ServiceAccount** is the **Pod’s identity** for authenticating with the Kubernetes API.
* It enables secure, **role-based access** for in-cluster workloads.
* Use **custom ServiceAccounts + RBAC** for **least-privilege**, and disable tokens if not needed.
---
## Q: How Do You Handle **Rolling Updates** in Kubernetes?

---

### 🧠 Overview

A **rolling update** in Kubernetes allows you to **update your application version or configuration** without downtime.
It gradually replaces **old Pods** with **new ones**, ensuring that a minimum number of Pods are **always available** during the update — achieving **zero-downtime deployments**.

Rolling updates are **managed by Deployments**, which handle the entire rollout, monitoring, and rollback process automatically.

---

### ⚙️ Purpose / How It Works

**Rolling Update Workflow:**

1. You change something in your Deployment (e.g., container image tag).
2. Kubernetes creates **new Pods** (new ReplicaSet) with the updated spec.
3. As new Pods become **Ready**, old Pods are **terminated gradually**.
4. The process continues until all Pods run the new version.

This strategy is defined under `strategy: type: RollingUpdate` in your Deployment.

---

### 🧩 Example — Rolling Update Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web
        image: nginx:1.24   # change this to trigger a rolling update
        ports:
        - containerPort: 80
```

✅ Explanation:

* `maxUnavailable: 1` → Only 1 Pod can be down during update.
* `maxSurge: 1` → 1 extra Pod can be created temporarily.
* Ensures **3 Pods are always available** out of 4.

---

### 🧩 Triggering a Rolling Update

#### Update the image manually:

```bash
kubectl set image deployment/web-app web=nginx:1.25
```

#### Verify rollout:

```bash
kubectl rollout status deployment/web-app
```

#### Watch Pods updating:

```bash
kubectl get pods -l app=web -w
```

---

### 🧩 Rollback if Update Fails

```bash
# Rollback to previous revision
kubectl rollout undo deployment/web-app

# Check rollout history
kubectl rollout history deployment/web-app

# Rollback to specific revision
kubectl rollout undo deployment/web-app --to-revision=2
```

✅ Kubernetes automatically keeps a history of ReplicaSets for rollback.

---

### 📋 RollingUpdate Parameters

| Field                     | Description                                             |
| ------------------------- | ------------------------------------------------------- |
| `type`                    | Defines update strategy (`RollingUpdate` or `Recreate`) |
| `maxUnavailable`          | Max Pods unavailable during update (number or %)        |
| `maxSurge`                | Max extra Pods above desired count during update        |
| `minReadySeconds`         | Time Pod must be ready before next Pod is updated       |
| `progressDeadlineSeconds` | Timeout before marking deployment failed                |

---

### 📋 Rolling Update vs Recreate

| Strategy                | Behavior                                           | Downtime              |
| ----------------------- | -------------------------------------------------- | --------------------- |
| **RollingUpdate**       | Gradually replaces old Pods with new               | ❌ No downtime         |
| **Recreate**            | Kills all old Pods, then starts new ones           | ⚠️ Causes downtime    |
| **Blue/Green / Canary** | Controlled by external tools (e.g., Argo Rollouts) | ✅ Safest but advanced |

---

### ✅ Best Practices

* Always use **readiness probes** to ensure only healthy Pods receive traffic.
* Set proper **`maxUnavailable`** and **`maxSurge`** to balance speed vs stability.
* Use **`minReadySeconds`** to give time for app warm-up.
* Enable **health checks** (liveness/readiness probes) in Deployments.
* Monitor rollout progress:

  ```bash
  kubectl rollout status deployment <name>
  ```
* Automate and visualize rollouts with **Argo Rollouts** or **Flagger** for canary deployments.
* Store Deployment manifests in Git for **GitOps-based rollback**.
* Always test updates in **staging namespaces** before production.

---

### 💡 In short

* **Rolling updates** = zero-downtime app updates handled by **Deployments**.
* Kubernetes gradually replaces old Pods with new ones while keeping services online.
* Tune **`maxUnavailable`**, **`maxSurge`**, and use **readiness probes** to ensure smooth rollouts and easy rollback if something fails.
---
## Q: How Do You Restrict **Resource Usage per Pod** in Kubernetes?

---

### 🧠 Overview

In Kubernetes, you can **limit CPU and memory usage per Pod (or container)** using **resource requests and limits** in the Pod spec.
These settings prevent a single Pod from consuming excessive resources, ensuring **cluster stability**, **fair sharing**, and **predictable performance**.

---

### ⚙️ Purpose / How It Works

| Term        | Description                                                                                        |
| ----------- | -------------------------------------------------------------------------------------------------- |
| **Request** | Minimum guaranteed resources for a container. Scheduler uses this to decide placement.             |
| **Limit**   | Maximum resources a container can use. Exceeding this causes throttling (CPU) or OOMKill (memory). |

When a Pod is scheduled:

* The **kube-scheduler** places it on a node that has enough **requested** resources.
* The **kubelet** enforces the **limit** during runtime using **cgroups**.

---

### 🧩 Example — Pod with Resource Requests & Limits

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-app
spec:
  containers:
  - name: nginx
    image: nginx:latest
    resources:
      requests:
        cpu: "100m"       # 0.1 vCPU guaranteed
        memory: "128Mi"   # 128 MB guaranteed
      limits:
        cpu: "500m"       # 0.5 vCPU max
        memory: "256Mi"   # 256 MB max
```

✅ Meaning:

* The container gets **at least 0.1 CPU & 128Mi memory**,
  and can **burst up to 0.5 CPU & 256Mi memory**.

If memory exceeds 256Mi → container **OOMKilled**.
If CPU exceeds 500m → CPU **throttled** (no crash).

---

### 🧩 Apply Resource Quotas (Namespace-level Control)

You can restrict **total resources per namespace** using a **ResourceQuota**.

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev-quota
  namespace: dev
spec:
  hard:
    requests.cpu: "2"
    requests.memory: 4Gi
    limits.cpu: "4"
    limits.memory: 8Gi
    pods: "10"
```

✅ Enforces:

* Max 10 Pods
* Total CPU ≤ 4 cores
* Total memory ≤ 8 GiB

---

### 🧩 Default Limits — Using LimitRange

You can define **default requests/limits** for Pods in a namespace using `LimitRange`.

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: default-limits
  namespace: dev
spec:
  limits:
  - default:
      cpu: 500m
      memory: 256Mi
    defaultRequest:
      cpu: 100m
      memory: 128Mi
    type: Container
```

✅ Any container created **without explicit resources** will inherit these defaults.

---

### 📋 Behavior Summary

| Scenario         | Behavior                                              |
| ---------------- | ----------------------------------------------------- |
| No limits set    | Pod can consume as much as available → risk to others |
| Only request set | Scheduler guarantees min resources                    |
| Only limit set   | Risk of overcommitment                                |
| Request < Limit  | Allows bursty workloads                               |
| Limit < usage    | CPU throttled / container OOMKilled                   |

---

### ✅ Best Practices

* Always define **requests and limits** in **all production Pods**.
* Use **LimitRange** and **ResourceQuota** to enforce namespace-level defaults.
* Avoid setting limits **too low** — may cause performance degradation.
* For CPU-bound apps, allow **CPU bursting** (`request < limit`).
* For memory-critical apps (e.g., DBs), keep **limit = request** to avoid OOMKills.
* Monitor usage with:

  ```bash
  kubectl top pod -n <namespace>
  ```
* Use **Vertical Pod Autoscaler (VPA)** to adjust limits automatically.
* Combine with **HPA (Horizontal Pod Autoscaler)** for full auto-scaling behavior.

---

### 💡 In short

* Use `resources.requests` and `resources.limits` in Pod specs to **control CPU and memory usage**.
* `Request` = guaranteed minimum, `Limit` = enforced maximum.
* Apply **LimitRange** and **ResourceQuota** to enforce defaults and boundaries cluster-wide.
* This ensures **fair resource sharing**, **predictable performance**, and **no noisy neighbors** in your cluster.
---
## Q: How Do You Perform **Blue-Green** or **Canary Deployments** in Kubernetes?

---

### 🧠 Overview

Both **Blue-Green** and **Canary** deployments are **zero-downtime release strategies** that reduce risk during updates:

| Strategy       | Goal                                                                    | Traffic Behavior                               |
| -------------- | ----------------------------------------------------------------------- | ---------------------------------------------- |
| **Blue-Green** | Deploy new version alongside old one, then switch all traffic instantly | 100% switch from blue → green                  |
| **Canary**     | Gradually route a small % of traffic to the new version                 | Incremental rollout (e.g., 5%, 25%, 50%, 100%) |

They’re implemented in Kubernetes using **Services**, **Deployments**, **Ingress**, or **progressive delivery tools** like **Argo Rollouts** or **Flagger**.

---

## 🔵 Blue-Green Deployment

---

### ⚙️ How It Works

1. You have **two identical environments**:

   * **Blue** (current, live)
   * **Green** (new version to test)
2. Both run behind the same Service selector.
3. When the new version is verified, you **switch the Service selector** from blue to green — instant cutover.
4. Rollback = switch selector back to blue.

---

### 🧩 Example — Blue-Green using Service Selector

#### Blue Deployment (v1)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
      version: blue
  template:
    metadata:
      labels:
        app: web
        version: blue
    spec:
      containers:
      - name: web
        image: nginx:1.24
```

#### Green Deployment (v2)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
      version: green
  template:
    metadata:
      labels:
        app: web
        version: green
    spec:
      containers:
      - name: web
        image: nginx:1.25
```

#### Service (Switch Target)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-svc
spec:
  selector:
    app: web
    version: blue    # <-- Switch this to 'green' when ready
  ports:
  - port: 80
    targetPort: 80
```

✅ Switch traffic:

```bash
kubectl patch service web-svc -p '{"spec":{"selector":{"app":"web","version":"green"}}}'
```

Rollback instantly by reverting to:

```bash
kubectl patch service web-svc -p '{"spec":{"selector":{"app":"web","version":"blue"}}}'
```

---

### 📋 Pros & Cons

| ✅ Pros                                    | ⚠️ Cons                                    |
| ----------------------------------------- | ------------------------------------------ |
| Zero downtime                             | Requires double infrastructure temporarily |
| Instant rollback                          | Slightly higher cost                       |
| Easy to test green version before go-live | May need traffic sync (DB, cache)          |

---

## 🟡 Canary Deployment

---

### ⚙️ How It Works

1. Deploy a **new version (canary)** alongside the old one.
2. Gradually send a **small percentage of traffic** to the canary version.
3. Observe metrics (latency, errors, logs).
4. If stable → increase traffic gradually until 100%.
5. If issues → rollback immediately.

---

### 🧩 Example — Simple Canary Using Two Deployments + Service

#### Stable Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-stable
spec:
  replicas: 4
  selector:
    matchLabels:
      app: web
      version: stable
  template:
    metadata:
      labels:
        app: web
        version: stable
    spec:
      containers:
      - name: web
        image: nginx:1.24
```

#### Canary Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
      version: canary
  template:
    metadata:
      labels:
        app: web
        version: canary
    spec:
      containers:
      - name: web
        image: nginx:1.25
```

#### Shared Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-svc
spec:
  selector:
    app: web   # Matches both stable & canary
  ports:
  - port: 80
    targetPort: 80
```

✅ Result:

* Traffic split ~80% (stable) : 20% (canary) based on replica count (4:1).
* Adjust replicas to modify traffic ratio.

---

### 🧩 Canary with Ingress (Weighted Routing)

For advanced control, use **Ingress with weights** (NGINX, Traefik, or ALB).

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-canary
  annotations:
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "10"  # 10% traffic
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-svc
            port:
              number: 80
```

✅ The Ingress controller sends **10% of traffic** to canary.

---

### 🧩 Automated Canary — Argo Rollouts Example

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: web-rollout
spec:
  strategy:
    canary:
      steps:
      - setWeight: 10
      - pause: {duration: 2m}
      - setWeight: 50
      - pause: {duration: 5m}
      - setWeight: 100
  replicas: 4
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web
        image: nginx:1.25
```

✅ Automatically increases traffic gradually with monitoring and rollback triggers.

---

### 📋 Blue-Green vs Canary — Comparison

| Feature                     | **Blue-Green**                        | **Canary**                        |
| --------------------------- | ------------------------------------- | --------------------------------- |
| **Traffic switch**          | Instant (100% cutover)                | Gradual (e.g., 5% → 25% → 100%)   |
| **Risk**                    | Low                                   | Very low                          |
| **Rollback**                | Instant (switch service)              | Roll back before full rollout     |
| **Complexity**              | Simple                                | Moderate                          |
| **Infrastructure overhead** | 2 environments                        | Partial duplication               |
| **Best for**                | Stable apps with predictable upgrades | Experimental or high-traffic apps |

---

### ✅ Best Practices

* Use **readiness probes** to ensure new Pods are healthy before serving traffic.
* Automate progressive rollout via **Argo Rollouts**, **Flagger**, or **Spinnaker**.
* Monitor key metrics (latency, errors, CPU, memory) using Prometheus/Grafana.
* For Blue-Green, use distinct **database schemas or versioning** if possible.
* Always **test the green/canary** version in isolation before routing real traffic.
* Use **Ingress weight-based routing** for HTTP apps.
* Use **Service Mesh (Istio / Linkerd)** for per-request canary control (headers, percentages).

---

### 💡 In short

* **Blue-Green:** Two environments → instant switch → easy rollback.
* **Canary:** Gradual rollout → low risk → great for production experimentation.
* Use **Service + Ingress** for simple setups, or **Argo Rollouts / Flagger / Istio** for full automation, metrics-based promotion, and rollback.

---
## Q: How Do You **Troubleshoot a Failing Pod** in Kubernetes?

---

### 🧠 Overview

When a Pod fails in Kubernetes, you must determine **why it failed** — whether it’s due to **crashes, scheduling issues, configuration errors, resource limits, or network problems**.
Kubernetes provides multiple built-in tools (`kubectl describe`, `logs`, `events`, etc.) to systematically identify and fix the root cause.

---

### ⚙️ Step-by-Step Troubleshooting Workflow

---

### 🔹 **1️⃣ Check Pod Status**

```bash
kubectl get pods -n <namespace>
```

Example output:

```
NAME          READY   STATUS             RESTARTS   AGE
api-server    0/1     CrashLoopBackOff   5          2m
```

🧩 Common Pod statuses:

| Status                | Meaning                                          |
| --------------------- | ------------------------------------------------ |
| **Pending**           | Waiting for node or resource allocation          |
| **ContainerCreating** | Image pull or volume mount issue                 |
| **CrashLoopBackOff**  | Container keeps crashing and restarting          |
| **ImagePullBackOff**  | Image can’t be downloaded (bad name, auth issue) |
| **ErrImagePull**      | Registry/authentication problem                  |
| **Completed**         | Job finished successfully                        |
| **Evicted**           | Node pressure (disk, memory)                     |
| **OOMKilled**         | Memory limit exceeded                            |

---

### 🔹 **2️⃣ Describe the Pod (Detailed Events)**

```bash
kubectl describe pod <pod-name> -n <namespace>
```

Focus on:

* **Events section** → shows last errors (e.g., image pull, scheduling)
* **Conditions** → Ready / Initialized / ContainersReady
* **Exit codes** → tells you why container stopped

Example:

```
Last State:   Terminated
Reason:       OOMKilled
Exit Code:    137
```

✅ → The Pod was killed because it exceeded its memory limit.

---

### 🔹 **3️⃣ Check Pod Logs**

```bash
kubectl logs <pod-name> -n <namespace>
```

For multi-container Pods:

```bash
kubectl logs <pod-name> -c <container-name>
```

If the Pod restarted:

```bash
kubectl logs -p <pod-name> -c <container-name>
```

✅ Use logs to check runtime errors (exceptions, config issues, DB connection errors, etc.).

---

### 🔹 **4️⃣ Access Pod Shell for Live Debugging**

```bash
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh
```

Check:

* Files/configs: `cat /etc/config/...`
* Network: `curl`, `ping`, `nslookup`
* Permissions: `ls -l`, `env`
* Volume mounts: `df -h`, `mount`

If image has no shell:

```bash
kubectl debug -it <pod-name> --image=busybox --target=<container-name>
```

✅ Launches an **ephemeral debug container**.

---

### 🔹 **5️⃣ Check Events in Namespace**

```bash
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp
```

Look for:

* Image pull errors
* Node pressure (memory/disk)
* Network policy denials
* Scheduling issues

---

### 🔹 **6️⃣ Check Node & Resource Issues**

```bash
kubectl get nodes
kubectl describe node <node-name>
```

Look for:

* Disk pressure: `NodeHasDiskPressure`
* Memory pressure: `NodeHasInsufficientMemory`
* Taints preventing scheduling

Check resource limits:

```bash
kubectl top pod -n <namespace>
kubectl top node
```

✅ Identify Pods being throttled or OOMKilled due to CPU/memory constraints.

---

### 🔹 **7️⃣ Check Image and Secret Issues**

* Verify the container image:

  ```bash
  kubectl describe pod <pod> | grep -i image
  ```
* If private image:

  * Check `imagePullSecrets`
  * Ensure credentials are valid

Common issue:

```
Failed to pull image "nginx:v9": rpc error: not found
```

✅ Fix: Correct tag or registry credentials.

---

### 🔹 **8️⃣ Check Networking / DNS**

Inside the Pod:

```bash
kubectl exec -it <pod> -- nslookup kubernetes.default
kubectl exec -it <pod> -- curl http://service-name:port
```

Check cluster DNS:

```bash
kubectl get svc kube-dns -n kube-system
```

✅ Confirms if the Pod can resolve internal services.

---

### 🔹 **9️⃣ Check ConfigMap or Secret Mount Issues**

If Pods fail to start with:

```
Error: configmap not found
Error: secret "xyz" not found
```

→ Validate existence:

```bash
kubectl get configmap,secret -n <namespace>
```

✅ Fix mount paths or missing resources.

---

### 🔹 **10️⃣ Look for Misconfigured Probes**

Pods may restart repeatedly due to **readiness or liveness probe failures**.

Check:

```bash
kubectl describe pod <pod> | grep -A5 Liveness
```

✅ If probes fail frequently → increase `initialDelaySeconds` or fix the probe path.

---

### 📋 Common Root Causes

| Issue                   | Example                         | Solution                          |
| ----------------------- | ------------------------------- | --------------------------------- |
| **CrashLoopBackOff**    | App startup crash or bad config | Check logs, fix env/config        |
| **ImagePullBackOff**    | Wrong image tag or secret       | Fix image name / credentials      |
| **OOMKilled**           | Exceeded memory limit           | Increase memory limit or fix leak |
| **FailedMount**         | Missing PV/PVC or config        | Check volume bindings             |
| **NetworkPolicy block** | Pod can’t connect to service    | Update NetworkPolicy              |
| **Probe failures**      | Liveness/readiness too strict   | Tune probe settings               |

---

### ✅ Best Practices

* Always define **resource limits & probes** for predictable Pod behavior.
* Use **readiness probes** to prevent traffic to unready Pods.
* Enable **centralized logging (ELK, Loki, CloudWatch)** for faster diagnosis.
* Use **`kubectl get events`** as your first check — it’s often the fastest hint.
* Integrate **Prometheus & Grafana** to monitor Pod health and performance trends.
* For recurring issues, automate alerts using **Kubernetes events → Alertmanager**.

---

### 💡 In short

1️⃣ Check Pod status → 2️⃣ Describe Pod → 3️⃣ View logs → 4️⃣ Exec into Pod → 5️⃣ Review events.
Kubernetes gives full observability — most failures trace back to **image, config, probe, or resource** issues.
**Systematic debugging = fast recovery + stable cluster.**

---
## Q: What’s the Difference Between **Readiness** and **Liveness Probes** in Kubernetes?

---

### 🧠 Overview

Kubernetes uses **probes** to automatically check the **health of containers** and manage them accordingly.
Both **Readiness** and **Liveness probes** are defined inside the Pod spec, but serve **different purposes**:

| Probe               | Purpose                                                     |
| ------------------- | ----------------------------------------------------------- |
| **Readiness Probe** | Checks if the container is **ready to serve traffic**       |
| **Liveness Probe**  | Checks if the container is **still alive or needs restart** |

These probes ensure **high availability**, **graceful traffic routing**, and **automatic self-healing** of applications.

---

### ⚙️ Purpose / How It Works

| Type                | What It Checks                          | Action Taken by Kubernetes                                                 |
| ------------------- | --------------------------------------- | -------------------------------------------------------------------------- |
| **Readiness Probe** | If the app is ready to receive requests | If **failed**, Pod is **removed** from Service endpoints (no traffic sent) |
| **Liveness Probe**  | If the app is healthy and running       | If **failed**, **container is restarted** by kubelet                       |

✅ **Readiness = Traffic gate**
✅ **Liveness = Life monitor**

---

### 🧩 Example — Readiness & Liveness Probes Together

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-app
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
    readinessProbe:
      httpGet:
        path: /healthz
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 10
    livenessProbe:
      httpGet:
        path: /live
        port: 80
      initialDelaySeconds: 15
      periodSeconds: 20
```

✅ Breakdown:

* **Readiness probe:** After 5s, checks `/healthz` every 10s.

  * If fails → Pod temporarily removed from load balancer.
* **Liveness probe:** After 15s, checks `/live` every 20s.

  * If fails → Kubernetes restarts the container.

---

### 🧩 Probe Types

| Type     | Definition                      | Example                         |
| -------- | ------------------------------- | ------------------------------- |
| **HTTP** | Checks via HTTP GET request     | `/health`, `/ready`             |
| **TCP**  | Opens a TCP socket              | Checks DB/API port availability |
| **Exec** | Runs a command in the container | `cat /tmp/healthy`              |

**Examples:**

```yaml
# Exec probe example
livenessProbe:
  exec:
    command:
    - cat
    - /tmp/healthy
  initialDelaySeconds: 5
  periodSeconds: 10
```

```yaml
# TCP probe example
readinessProbe:
  tcpSocket:
    port: 8080
  initialDelaySeconds: 10
```

---

### 📋 Behavior Comparison

| Feature            | **Readiness Probe**                        | **Liveness Probe**                      |
| ------------------ | ------------------------------------------ | --------------------------------------- |
| Purpose            | Checks if container can handle traffic     | Checks if container should be restarted |
| Failure Action     | Pod removed from Service endpoints         | Container restarted                     |
| Traffic impact     | Stops receiving traffic                    | Container rebooted, may cause downtime  |
| When used          | During startup, reload, or dependency wait | During runtime health monitoring        |
| Restart triggered? | ❌ No                                       | ✅ Yes                                   |
| Typical check      | `/ready` endpoint, DB connection           | `/health`, process running check        |

---

### 📋 Example: Combined Behavior

| State          | Readiness | Liveness | Effect                           |
| -------------- | --------- | -------- | -------------------------------- |
| Startup delay  | ❌         | ❌        | Pod not ready yet                |
| App warming up | ❌         | ✅        | No traffic, container alive      |
| App ready      | ✅         | ✅        | Pod receives traffic             |
| App hung       | ✅         | ❌        | K8s restarts container           |
| App overloaded | ❌         | ✅        | Removed from Service temporarily |

---

### ✅ Best Practices

* Always define **both probes** for production apps.
* Set **different initial delays**:

  * Readiness starts earlier (so traffic waits)
  * Liveness starts later (to avoid false restarts)
* Avoid **identical endpoints** for both probes (different semantics).
* Make sure probes **respond fast (<1s)**.
* Use **`initialDelaySeconds`**, **`failureThreshold`**, and **`timeoutSeconds`** wisely to prevent flapping.
* Log probe failures for analysis (`kubectl describe pod` → Events).
* Combine with **PodDisruptionBudgets** for graceful rolling updates.

---

### 💡 In short

* **Readiness Probe → Controls traffic routing** (is app ready?).
* **Liveness Probe → Controls container restarts** (is app alive?).
* Together, they enable **self-healing** and **zero-downtime reliability** in Kubernetes applications.

---
## Q: How do you **scale Pods automatically** in Kubernetes?

---

### 🧠 Overview

Kubernetes supports **automatic scaling** at three levels:

* **Horizontal Pod Autoscaler (HPA)** — scales number of Pod replicas (most common).
* **Vertical Pod Autoscaler (VPA)** — adjusts CPU/memory requests/limits of containers.
* **Cluster Autoscaler (CA)** — scales the underlying nodes so Pods have capacity.

Use them together: HPA for load-driven replica changes, VPA for right-sizing containers, CA to add/remove nodes.

---

### ⚙️ Purpose / How it works

* **HPA** watches metrics (CPU, memory, custom) and adjusts `Deployment/ReplicaSet` `replicas` between `minReplicas` and `maxReplicas`.
* **VPA** observes usage and recommends or applies new `requests/limits` (can be **recommendation** or **eviction-based**).
* **Cluster Autoscaler** runs on cluster and modifies node pools (cloud node groups / autoscaling groups) based on pending Pods and utilization.

**Prerequisites:** metrics collection (metrics-server for resource metrics; Prometheus + adapter for custom metrics).

---

### 🧩 Examples / Commands / Config snippets

#### 1) Quick manual scale (imperative)

```bash
kubectl scale deployment web --replicas=10
kubectl get deployment web -o=jsonpath='{.spec.replicas}'
```

---

#### 2) HPA — CPU-based (simplest)

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50   # target avg CPU% across pods
```

Apply:

```bash
kubectl apply -f web-hpa.yaml
kubectl get hpa
kubectl describe hpa web-hpa
```

> **Note:** `metrics-server` must be installed and `requests` set on containers.

---

#### 3) HPA — Custom metric (Prometheus adapter) example

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-hpa-custom
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web
  minReplicas: 2
  maxReplicas: 20
  metrics:
  - type: Pods
    pods:
      metric:
        name: requests_per_second
      target:
        type: AverageValue
        averageValue: "100"   # 100 RPS per pod
```

Setup: install Prometheus + prometheus-adapter mapping query → `requests_per_second`.

---

#### 4) VPA — recommendation mode

```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: web-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind:       Deployment
    name:       web
  updatePolicy:
    updateMode: "Off"   # Off = only recommendations. Use "Auto" carefully.
```

Check recommendations:

```bash
kubectl get vpa web-vpa -o yaml
```

**Caution:** `updateMode: Auto` can evict Pods to apply new requests — plan maintenance windows.

---

#### 5) Cluster Autoscaler (cloud example — EKS/GKE/AKS)

Install CA as a deployment in cluster (or enable managed CA). Example Helm / manifest from upstream; CA watches Pending Pods and scales node groups (auto-scaling groups / instance groups).
Important: Node groups must have correct labels/tags and be discoverable by CA.

Basic check:

```bash
kubectl get deployment cluster-autoscaler -n kube-system
# review logs for scale decisions
kubectl logs -n kube-system deploy/cluster-autoscaler
```

---

#### 6) Enable metrics-server (resource metrics required)

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
# verify
kubectl top nodes
kubectl top pods
```

---

### 📋 Comparison Table

|        Concern |                HPA               |                   VPA                   |        Cluster Autoscaler       |
| -------------: | :------------------------------: | :-------------------------------------: | :-----------------------------: |
| What it scales |          Pods (replicas)         |  Container CPU/memory requests & limits |           Nodes (VMs)           |
|           Uses |     CPU/memory/custom metrics    |      Observed usage (right-sizing)      | Pending pods / node utilization |
|    Typical use |  Web services under varying load |     Stateful apps or baseline tuning    |   Provide capacity for HPA/VPA  |
|           Risk |      Pod churn if aggressive     | Pod eviction when applied automatically |      VM spin-up time & cost     |
|   Prerequisite | metrics-server or custom adapter |         VPA admission components        |    Cloud provider node groups   |

---

### ✅ Best Practices (production-ready)

* **Always set resource `requests`** for containers — HPA uses requests to compute utilization.
* Install **metrics-server** for CPU/memory; use **Prometheus + adapter** for custom metrics.
* Start with conservative HPA `min/max` and `target` values; adjust after load testing.
* Use **stabilization windows** and sensible `behavior` (scaleUp/scaleDown policies in `autoscaling/v2`) to avoid flapping.
* Combine HPA + VPA carefully: prefer VPA in `recommendation` mode with HPA for horizontal autoscaling, or use VPA `Off` for HPA-managed apps.
* Ensure **Cluster Autoscaler** is configured for your node groups (labels, taints, scaling limits).
* Use **PodDisruptionBudget (PDB)** to protect availability during scaling/evictions.
* Monitor scaling events and health (Prometheus alerts, Cloud provider autoscaling logs).
* Test scaling with realistic load (locust, artillery) and validate end-to-end (pods → nodes → LB).

---

### ⚠️ Common Gotchas

* No requests set → HPA can't compute CPU utilization properly.
* metrics-server missing or misconfigured → `kubectl top` fails and HPA no-op.
* Custom metrics require adapter mapping and Prometheus queries.
* VPA `Auto` may evict Pods unexpectedly — schedule maintenance windows or use `Off` for recommendations.
* Cluster Autoscaler can take minutes to add nodes — set appropriate burst capacity or warm pools for latency-sensitive apps.

---

### 💡 In short

* Use **HPA** to scale replicas based on metrics (CPU/custom).
* Use **VPA** to right-size container requests (recommendations first).
* Use **Cluster Autoscaler** to add node capacity when Pods are pending.
* Ensure metrics-server / Prometheus adapter and proper resource `requests` are configured before enabling autoscaling.
---
## Q: What is a **Taint** and **Toleration** in Kubernetes?

---

### 🧠 Overview

**Taints** and **Tolerations** work together in Kubernetes to **control which Pods can be scheduled on which Nodes**.
They act as a **filtering mechanism**:

* **Taints** *repel* Pods from nodes (unless Pods explicitly “tolerate” them).
* **Tolerations** *allow* Pods to be scheduled on nodes with matching taints.

> 🔹 In short: **Taints protect Nodes; Tolerations allow exceptions.**

---

### ⚙️ Purpose / How It Works

* A **Taint** is applied **on a Node** — it says *“Only Pods that can tolerate this taint may run here.”*
* A **Toleration** is applied **on a Pod** — it says *“I’m OK to run on nodes with this taint.”*

Kubernetes scheduler:

1. Checks taints on nodes.
2. Skips nodes whose taints are not tolerated by the Pod.
3. Schedules Pods only where tolerations match taints (or no taint exists).

---

### 🧩 Example — Add a Taint to a Node

```bash
# Syntax:
kubectl taint nodes <node-name> key=value:effect
```

```bash
kubectl taint nodes node1 env=prod:NoSchedule
```

✅ Node `node1` will now **reject all Pods** unless they have a matching toleration for `env=prod`.

---

### 🧩 Example — Add a Matching Toleration to a Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: tolerant-pod
spec:
  tolerations:
  - key: "env"
    operator: "Equal"
    value: "prod"
    effect: "NoSchedule"
  containers:
  - name: nginx
    image: nginx
```

✅ This Pod *tolerates* the `env=prod:NoSchedule` taint and can run on that node.

---

### 🧩 Remove a Taint

```bash
kubectl taint nodes node1 env=prod:NoSchedule-
```

✅ Removes the taint from the node (note the trailing `-`).

---

### 📋 Taint Effects

| Effect               | Description                                                                         |
| -------------------- | ----------------------------------------------------------------------------------- |
| **NoSchedule**       | Pods **will not be scheduled** unless they tolerate the taint.                      |
| **PreferNoSchedule** | Scheduler tries to **avoid** placing Pods on the node (soft rule).                  |
| **NoExecute**        | Existing Pods without toleration are **evicted** and **no new Pods** are scheduled. |

---

### 🧩 Example — NoExecute (Eviction Case)

```bash
kubectl taint node node1 maintenance=true:NoExecute
```

Pods without matching toleration:

* Are **evicted immediately**.
* Can only remain if they define toleration like:

  ```yaml
  tolerations:
  - key: "maintenance"
    operator: "Exists"
    effect: "NoExecute"
    tolerationSeconds: 300
  ```

✅ This Pod can **stay for 300 seconds** before being evicted.

---

### 🧩 Operator Types

| Operator   | Meaning                                 |
| ---------- | --------------------------------------- |
| **Equal**  | Key and value must match exactly        |
| **Exists** | Only key needs to exist (value ignored) |

Example:

```yaml
tolerations:
- key: "env"
  operator: "Exists"
  effect: "NoSchedule"
```

✅ Tolerates any taint with key `env`, regardless of value.

---

### 📋 Common Use Cases

| Use Case                       | Example                                                                 |
| ------------------------------ | ----------------------------------------------------------------------- |
| **Dedicated Nodes**            | Taint nodes with `dedicated=teamA:NoSchedule` to isolate workloads      |
| **GPU / Special Hardware**     | Taint GPU nodes `gpu=true:NoSchedule` and let ML Pods tolerate it       |
| **Maintenance Mode**           | Temporarily taint nodes `maintenance=true:NoExecute` to evict workloads |
| **Critical System Pods**       | System-level Pods tolerate master/control-plane taints automatically    |
| **Multi-tenancy / Compliance** | Enforce strict separation of workloads between namespaces or teams      |

---

### 📋 Default Control-Plane Taints

| Node                   | Default Taint                                      | Purpose                                 |
| ---------------------- | -------------------------------------------------- | --------------------------------------- |
| **Control-plane node** | `node-role.kubernetes.io/control-plane:NoSchedule` | Prevents user workloads on master nodes |
| **Worker node**        | (None)                                             | Schedulable by default                  |

---

### ✅ Best Practices

* Use **taints** to isolate nodes for specific workloads (e.g., production-only, GPU, compliance).
* Always **pair taints with tolerations** to allow specific Pods.
* Use **`NoExecute`** for eviction scenarios (e.g., maintenance, draining).
* Avoid overusing taints — can cause **unschedulable Pods** if misconfigured.
* Combine with **nodeSelector** or **affinity** for precise placement control.
* Monitor **unschedulable Pods** using:

  ```bash
  kubectl get pods --field-selector=status.phase=Pending
  kubectl describe pod <name>
  ```

---

### 💡 In short

* **Taint (Node)** = *“Keep Pods away unless they tolerate me.”*
* **Toleration (Pod)** = *“I’m okay running on tainted nodes.”*
* Use them to enforce **node isolation, environment segregation, maintenance, or hardware targeting**, ensuring **predictable and secure scheduling** across your cluster.
---
## Q: What is a **ConfigMap reload issue**, and how do you fix it?

---

### 🧠 Overview

A **ConfigMap reload issue** is when you update a Kubernetes `ConfigMap` but the running Pods **don't pick up the change**.
Symptoms: files under a mounted `configMap` volume are stale, environment variables don't update, or app continues using old config after `kubectl apply` on the ConfigMap.

There are **two independent behaviours** that cause surprises:

* **Env vars** from ConfigMaps are injected **only at pod start** — they never update in a running container.
* **Mounted files** from a ConfigMap *do* update on the node, but many apps/processes **won’t notice** file changes (or will miss them due to `subPath`/inode behavior or kubelet sync delay).

---

### ⚙️ Purpose / How it works

* **Env injection**: `envFrom` / `env` values are baked into the container process environment at creation — updating the ConfigMap does **not** change those variables in-place.
* **Volume mounts**: kubelet updates the mounted file contents by writing new files (atomic rename). The update is propagated on a **sync interval** (default ~1m). Some apps watch file **content** (works), others watch **inode** (broken after atomic rename) or require explicit reload.
* `subPath` prevents automatic updates — files copied at mount time and **not** refreshed.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Typical problem patterns

* Config used via `env` → env never updates until Pod restart.
* Config mounted with `subPath` → file **won’t** update on ConfigMap change.
* App expects inode to remain same (atomic rename breaks it) → app ignores update.

#### 2) Quick fixes (safe, immediate)

* **Restart Pod(s)** to pick new env or mounted file in a clean way:

```bash
kubectl rollout restart deployment/my-app -n myns
# or restart a single pod (debug only)
kubectl delete pod my-app-xxxxx -n myns
```

* **Patch Deployment to force rolling restart** (use in CI/CD to automate):

```bash
kubectl patch deployment my-app -n myns -p "{\"spec\":{\"template\":{\"metadata\":{\"annotations\":{\"configmap-timestamp\":\"$(date +%s)\"}}}}}"
```

#### 3) Preferred long-term solutions

**A — Use a reloader sidecar/operator** (recommended)

* Add a small container that watches the mounted ConfigMap and either:

  * sends SIGHUP to the main process, or
  * calls the app’s reload endpoint, or
  * triggers a rolling restart via the Kubernetes API.
* Example sidecar pattern (conceptual):

```yaml
containers:
- name: app
  image: myapp:1.2
  lifecycle:
    # app should handle SIGHUP to reload config
- name: config-reloader
  image: jimmidyson/configmap-reload
  args:
    - --volume-dir=/etc/config
    - --webhook-url=http://127.0.0.1:8080/-/reload  # optional: call app reload endpoint
  volumeMounts:
    - name: config
      mountPath: /etc/config
```

**B — Use a GitOps/CI approach**

* Update ConfigMap in Git → CI runs `kubectl apply` then **triggers** `kubectl rollout restart` on the Deployment (or uses an annotation-based patch). Keeps audit trail.

**C — Avoid `subPath` where possible**

* `subPath` prevents kubelet from updating the file. If you must use `subPath`, implement a reload mechanism (sidecar, init container to copy file on change).

**D — Make app reloadable**

* Implement an HTTP `/-/reload` or signal handler (SIGHUP) in your app that reloads config without restart.

**E — Use projected ConfigMap + watch libraries**

* Some libraries can watch files for content changes; test your app’s file-watching behavior with atomic file replacement.

#### 4) Check behavior & debug

```bash
# Show file timestamps on pod (verify kubelet updated file)
kubectl exec -it <pod> -- stat -c '%n %Y %i' /etc/config/my.conf

# See if kubelet refreshed mount (look for new mtime or content)
kubectl exec -it <pod> -- cat /etc/config/my.conf

# If using env vars, verify they are unchanged (you must restart pod)
kubectl exec -it <pod> -- printenv | grep MY_SETTING
```

---

### 📋 Causes vs Fixes (quick table)

| Cause                             | Why it breaks                                                                | Fix                                                                     |
| --------------------------------- | ---------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| ConfigMap → Pod env               | Env injected only at container start                                         | Roll pods (`rollout restart`) or use reloader to restart app            |
| Mounted file with `subPath`       | kubelet does not update `subPath` files                                      | Avoid `subPath` or implement sidecar copy/reload                        |
| App watches inode (atomic rename) | kubelet replaces file via atomic rename → inode changes → some watchers fail | Use sidecar to signal app; update app to watch content or handle SIGHUP |
| Kubelet sync delay                | Updates take time (~1m)                                                      | Wait or restart for immediate effect; use reloader for faster reaction  |
| No reload handler in app          | App never re-reads file                                                      | Add SIGHUP/HTTP reload endpoint or implement file-watcher in app        |

---

### ✅ Best Practices (production-ready)

* **Design apps for reloadable config**: support SIGHUP or an HTTP reload endpoint.
* **Prefer mount (volume) + reloader** over relying on env updates. Use a lightweight reloader sidecar/operator to handle atomic updates safely.
* **Avoid `subPath`** for config files when you expect runtime updates. If unavoidable, implement a copy-on-change sidecar.
* **Use a GitOps/CI flow** to apply ConfigMap changes and trigger controlled rolling restarts (audit-friendly).
* **Test your reload behavior**: update a ConfigMap in staging and verify pod picks it up without restart (if expected) or with controlled restart.
* **Document** how config changes propagate in runbooks (who restarts, how to force reload).
* **Monitor** application logs for reload errors and probe failures after config changes.

---

### 💡 In short

* **Env vars = static** (only at pod start). **Mounted files update**, but apps often **don't auto-reload** or `subPath` blocks updates.
* Fixes: **rollout restart** for immediate update, or implement a **reloader sidecar/operator** and make your app support SIGHUP/HTTP reloads. Avoid `subPath` if you want live updates.
---
## Q: Common **kubectl Commands** for Kubernetes Engineers 🧰

---

### 🧠 Overview

`kubectl` is the **CLI tool** used to interact with the Kubernetes API — to **deploy, inspect, debug, and manage** resources.
Here’s a **practical command reference** for daily DevOps & troubleshooting tasks.

---

## ⚙️ 1️⃣ **Basic Cluster Info**

| Command                        | Description                                       |
| ------------------------------ | ------------------------------------------------- |
| `kubectl version --short`      | Show client & server versions                     |
| `kubectl cluster-info`         | Display cluster master & DNS details              |
| `kubectl get nodes -o wide`    | List all nodes with status & IP                   |
| `kubectl describe node <node>` | Detailed info about a node                        |
| `kubectl top nodes`            | Show node CPU/memory usage (needs metrics-server) |

---

## 🧩 2️⃣ **Get Resources**

| Command                                                    | Description                             |
| ---------------------------------------------------------- | --------------------------------------- |
| `kubectl get pods`                                         | List all Pods                           |
| `kubectl get pods -A`                                      | List Pods in all namespaces             |
| `kubectl get svc`                                          | List Services                           |
| `kubectl get deployments`                                  | List Deployments                        |
| `kubectl get all`                                          | List all resources in current namespace |
| `kubectl get events --sort-by=.metadata.creationTimestamp` | Show recent cluster events              |
| `kubectl get ingress`                                      | List all Ingress rules                  |
| `kubectl get ns`                                           | Show all namespaces                     |

---

## 🧠 3️⃣ **Describe / Inspect Resources**

| Command                              | Description                           |
| ------------------------------------ | ------------------------------------- |
| `kubectl describe pod <pod>`         | Show details, events, container state |
| `kubectl logs <pod>`                 | View Pod logs                         |
| `kubectl logs -f <pod>`              | Stream logs in real-time              |
| `kubectl logs <pod> -c <container>`  | Logs from a specific container        |
| `kubectl exec -it <pod> -- /bin/sh`  | Get shell access into a Pod           |
| `kubectl port-forward <pod> 8080:80` | Access a Pod locally via port-forward |

---

## 🚀 4️⃣ **Create / Apply / Delete**

| Command                            | Description                            |
| ---------------------------------- | -------------------------------------- |
| `kubectl apply -f <file.yaml>`     | Apply changes (create/update resource) |
| `kubectl create -f <file.yaml>`    | Create a resource from YAML            |
| `kubectl delete -f <file.yaml>`    | Delete resource(s)                     |
| `kubectl delete pod <name>`        | Delete a Pod manually                  |
| `kubectl delete all --all -n <ns>` | Delete everything in a namespace       |
| `kubectl replace -f <file.yaml>`   | Replace a resource completely          |

---

## 🔄 5️⃣ **Deployments & Scaling**

| Command                                                                 | Description                      |
| ----------------------------------------------------------------------- | -------------------------------- |
| `kubectl rollout status deployment/<name>`                              | Check rollout progress           |
| `kubectl rollout history deployment/<name>`                             | Show revision history            |
| `kubectl rollout undo deployment/<name>`                                | Rollback to previous version     |
| `kubectl scale deployment/<name> --replicas=5`                          | Manually scale replicas          |
| `kubectl set image deployment/<name> <container>=<image:tag>`           | Update container image           |
| `kubectl autoscale deployment/<name> --min=2 --max=10 --cpu-percent=70` | Create Horizontal Pod Autoscaler |

---

## 📦 6️⃣ **Namespaces**

| Command                                                 | Description                               |
| ------------------------------------------------------- | ----------------------------------------- |
| `kubectl get ns`                                        | List all namespaces                       |
| `kubectl create ns <name>`                              | Create a namespace                        |
| `kubectl delete ns <name>`                              | Delete a namespace                        |
| `kubectl config set-context --current --namespace=<ns>` | Set default namespace for current context |

---

## 🧱 7️⃣ **ConfigMaps & Secrets**

| Command                                                         | Description                |
| --------------------------------------------------------------- | -------------------------- |
| `kubectl get configmap`                                         | List ConfigMaps            |
| `kubectl describe configmap <name>`                             | Inspect ConfigMap          |
| `kubectl create configmap <name> --from-file=<path>`            | Create ConfigMap from file |
| `kubectl get secret`                                            | List Secrets               |
| `kubectl describe secret <name>`                                | View Secret metadata       |
| `kubectl get secret <name> -o yaml`                             | Decode Secret contents     |
| `kubectl create secret generic <name> --from-literal=key=value` | Create Secret quickly      |

---

## 🧩 8️⃣ **Access & Context Management**

| Command                                | Description                  |
| -------------------------------------- | ---------------------------- |
| `kubectl config get-contexts`          | List all kubeconfig contexts |
| `kubectl config current-context`       | Show current cluster context |
| `kubectl config use-context <context>` | Switch context               |
| `kubectl config view`                  | Show merged kubeconfig       |
| `kubectl config unset contexts.<name>` | Remove context entry         |

---

## 🧩 9️⃣ **Debugging & Troubleshooting**

| Command                                                  | Description                             |
| -------------------------------------------------------- | --------------------------------------- |
| `kubectl describe pod <pod>`                             | Check events, restarts, resource limits |
| `kubectl get events -A`                                  | See cluster-wide events                 |
| `kubectl get pods --field-selector=status.phase=Pending` | Find unschedulable Pods                 |
| `kubectl exec -it <pod> -- /bin/sh`                      | Debug live Pod                          |
| `kubectl debug <pod> --image=busybox`                    | Create ephemeral debug container        |
| `kubectl cp <pod>:/path ./local`                         | Copy files from Pod to local machine    |
| `kubectl top pod -n <ns>`                                | Show Pod CPU/memory usage               |

---

## ⚙️ 🔟 **Cluster Admin / Maintenance**

| Command                                                           | Description                       |
| ----------------------------------------------------------------- | --------------------------------- |
| `kubectl cordon <node>`                                           | Mark node unschedulable           |
| `kubectl drain <node> --ignore-daemonsets --delete-emptydir-data` | Evict Pods for maintenance        |
| `kubectl uncordon <node>`                                         | Make node schedulable again       |
| `kubectl taint nodes <node> key=value:NoSchedule`                 | Prevent Pods on that node         |
| `kubectl label nodes <node> env=prod`                             | Add node label for scheduling     |
| `kubectl get csr`                                                 | View certificate signing requests |

---

## 🧩 11️⃣ **YAML Helpers / Advanced Output**

| Command                                                                                | Description                  |
| -------------------------------------------------------------------------------------- | ---------------------------- |
| `kubectl explain <resource>`                                                           | View field-level schema/docs |
| `kubectl get pod -o yaml`                                                              | View Pod manifest            |
| `kubectl get pod -o wide`                                                              | Show more details (node/IP)  |
| `kubectl get svc -o jsonpath='{.items[*].spec.clusterIP}'`                             | Extract specific field       |
| `kubectl get deployment -o custom-columns=NAME:.metadata.name,REPLICAS:.spec.replicas` | Custom table output          |

---

## 🧩 12️⃣ **Apply/Debug Shortcuts for CI/CD**

| Purpose                       | Command                                               |
| ----------------------------- | ----------------------------------------------------- |
| Apply all manifests in folder | `kubectl apply -f k8s/`                               |
| Dry-run validation            | `kubectl apply -f file.yaml --dry-run=client -o yaml` |
| Diff before applying          | `kubectl diff -f file.yaml`                           |
| Force update pods             | `kubectl rollout restart deployment/<name>`           |

---

### ✅ Best Practices

* Always use `-n <namespace>` when managing multi-tenant clusters.
* Use `kubectl explain <resource>` to explore YAML fields.
* Combine with **jq**, **grep**, or **jsonpath** for scripting.
* Integrate `kubectl` into **CI/CD pipelines** for automated apply, diff, and rollout.
* For daily ops, use **`kubectl top`**, **`get events`**, and **`describe`** for quick troubleshooting.

---

### 💡 In short

* `kubectl get` → list
* `kubectl describe` → inspect
* `kubectl logs / exec` → debug
* `kubectl apply / delete` → manage resources
* `kubectl rollout / scale` → manage deployments
* Combine `kubectl + jq/jsonpath` for **fast automation** and **production-grade observability**.

---

# Scenario Based Questions

## Q: Pods keep crashing — how to troubleshoot and fix it?

---

### 🧠 Overview

Pods crashing (CrashLoopBackOff, OOMKilled, ImagePullBackOff, ErrImagePull, Completed, etc.) means containers are failing to start or keep running. Troubleshoot systematically: **inspect status → check events & logs → verify resources/config → reproduce locally or exec** → apply fixes (probes, resources, image, config, mounts, permissions).

---

### ⚙️ Purpose / How it works

* Kubernetes reports pod/container lifecycle and events.
* `kubelet` enforces resource limits (OOM kills, CPU throttling).
* `kube-proxy`/network and volume mounts can cause runtime failures.
* Readiness/liveness probes can cause restarts if misconfigured.
* Image pull/auth issues prevent startup.
  Use CLI to gather evidence, then fix configuration or app.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Quick evidence collection (do this first)

```bash
# list pods + status
kubectl get pods -n <ns>

# describe for events + exit codes
kubectl describe pod <pod> -n <ns>

# recent events (sorted)
kubectl get events -n <ns> --sort-by=.metadata.creationTimestamp

# logs (current / previous)
kubectl logs <pod> -n <ns>
kubectl logs -p <pod> -n <ns>       # previous container run
kubectl logs -c <container> <pod> -n <ns>

# stream logs
kubectl logs -f <pod> -n <ns>

# exec into running container (if possible)
kubectl exec -it <pod> -c <container> -n <ns> -- /bin/sh

# inspect node health and resources
kubectl get nodes -o wide
kubectl describe node <node>
kubectl top pod -n <ns>
kubectl top node

# check PVC / volume mounts
kubectl get pvc -n <ns>
kubectl describe pvc <pvc> -n <ns>

# check image pull secrets
kubectl get secret -n <ns> | grep image
kubectl describe secret <name> -n <ns>

# check probe failures quickly
kubectl describe pod <pod> -n <ns> | sed -n '/Liveness/,/Readiness/p'
```

#### 2) Common fixes (apply after diagnosing)

* **OOMKilled** → increase `resources.limits.memory` or fix memory leak.

```yaml
resources:
  requests: { cpu: "200m", memory: "256Mi" }
  limits:   { cpu: "1",    memory: "1Gi" }
```

* **CrashLoopBackOff (app error)** → check `kubectl logs -p`, fix app config, env, DB connectivity.
* **ImagePullBackOff** → correct image:tag or add `imagePullSecrets`.
* **Probe failures** → tune `initialDelaySeconds`, `timeoutSeconds`, or fix probe endpoints.

```yaml
readinessProbe:
  httpGet: { path: /health, port: 8080 }
  initialDelaySeconds: 10
  periodSeconds: 10
```

* **Volume mount issues (FailedMount)** → ensure PVC bound, permissions, storage class capacity.
* **Permission / SecurityContext** → add `securityContext.runAsUser` or adjust Pod's serviceAccount.
* **ConfigMap/Secret issues** → verify keys exist and mount paths are correct; restart if env was used.
* **Node resource pressure / taints** → cordon/drain node, move pods, or add capacity.

#### 3) Force a controlled restart (when safe)

```bash
kubectl rollout restart deployment/<name> -n <ns>
# or delete the pod to let controller recreate
kubectl delete pod <pod> -n <ns>
```

---

### 📋 Causes → Symptoms → Fix (quick table)

|                         Cause |                  Symptom (kubectl)                  | Typical Fix                                                         |
| ----------------------------: | :-------------------------------------------------: | :------------------------------------------------------------------ |
| Application crash / exception | `CrashLoopBackOff`, `kubectl logs` shows stacktrace | Fix app, env, DB connections; add retries                           |
|                  OOM (memory) |      `OOMKilled` in `describe` / exit code 137      | Increase memory limit/requests, fix leaks, use memory profiling     |
|              Bad image / auth |         `ImagePullBackOff` / `ErrImagePull`         | Correct image tag, add `imagePullSecrets`, fix registry permissions |
|               Probe misconfig |         Frequent restarts; readiness = false        | Adjust `initialDelaySeconds`, probe path, or fix endpoint           |
|         Missing config/secret |     Startup error in logs; `ConfigMap not found`    | Create/patch ConfigMap/Secret; restart pods or use reloader         |
|            Volume / PVC error |      `FailedMount` / `MountVolume.SetUp failed`     | Ensure PVC bound, storageClass available, permissions               |
|           Node pressure/taint |             Pod Pending / Evicted events            | Free disk/memory, cordon & drain node, scale nodes                  |
|                 Crash on init |                InitContainer failing                | Check init logs: `kubectl logs -c <init>`; fix script or image      |
|            Permissions (RBAC) |                  403 errors in logs                 | Grant minimal RBAC or use proper SA                                 |
|           SubPath mount issue |           File not updated or mount error           | Avoid `subPath` or use sidecar copy pattern                         |

---

### ✅ Best Practices (production-ready)

* **Start with logs & events** — they tell the root cause in >80% cases.
* **Set resource `requests` and `limits`** for predictable scheduling and autoscaling.
* **Use readiness & liveness probes** with sensible delays; liveness later than readiness.
* **CI builds should validate image tags** and push immutable tags (not `latest`).
* **Use imagePullSecrets / OIDC / IRSA** for private registries; avoid long-lived keys.
* **Mount configs as volumes + implement reload or do controlled rollout** for env changes.
* **Automate restarts via CI (rollout restart)** instead of ad-hoc pod deletes for reproducibility.
* **Centralize logs & metrics** (ELK/Loki + Prometheus) to spot trends and correlate restarts.
* **Run chaos / failure drills** to ensure runbooks for OOM, node failures, and config issues.
* **Protect critical workloads** with PodDisruptionBudgets and multiple replicas.

---

### 💡 In short

1. **Gather evidence**: `kubectl describe pod` → `kubectl logs -p` → `kubectl get events`.
2. **Identify cause** (OOM, image, probes, mounts, config, node).
3. **Apply targeted fix** (increase limits, correct image/auth, tune probes, restore PVC, restart via rollout).
4. **Harden** with requests/limits, probes, centralized logs, and CI-driven rollouts to prevent recurrence.

---
## Q: ConfigMap changes not reflecting — why & how to fix it

---

### 🧠 Overview

ConfigMap updates **often don’t appear immediately** inside running Pods because:

* **Env vars** from ConfigMaps are injected **only at container start** (won’t update in-place).
* **Mounted files** are updated by kubelet but with an **atomic replace** (inode changes) and a **sync delay**; many apps or `subPath` mounts won’t notice the change.

This doc gives a concise diagnosis checklist, immediate fixes, safe automation patterns, and production best-practices.

---

### ⚙️ Purpose / How it works

* **Env injection**: values are baked into process env at Pod start → requires Pod restart to change.
* **Volume mount**: kubelet updates files by writing a new file and renaming it (atomic). Sync happens periodically; apps must detect content changes (not inode) or be signalled to reload.
* **`subPath`**: files copied at mount time → **won’t** be updated by kubelet.

---

### 🧩 Quick diagnostic & fixes (commands)

1. **Confirm how config is used**

```bash
# Inspect Pod spec
kubectl get pod <pod> -n <ns> -o yaml | yq '.spec.containers[].envFrom, .spec.volumes'
```

2. **If env variables are used → restart pods**

```bash
# Rolling restart (Deployment)
kubectl rollout restart deployment/my-app -n myns

# Patch deployment annotation (CI-friendly)
kubectl patch deployment my-app -n myns \
  -p '{"spec":{"template":{"metadata":{"annotations":{"configmap-reload":"'"$(date +%s)"'"}}}}}'
```

3. **If mounted file not updating — check timestamps & content**

```bash
kubectl exec -it <pod> -n myns -- stat -c '%n %Y %i' /etc/config/my.conf
kubectl exec -it <pod> -n myns -- cat /etc/config/my.conf
```

* If file mtime updated but app didn’t pick up → app likely watches inode or needs reload.

4. **If `subPath` is used → avoid or use copy-on-change**

* `subPath` blocks updates. Replace with direct mount or implement sidecar to copy file into `subPath` path.

---

### 🧩 Preferred long-term solutions (examples)

#### A — Add a config-reloader sidecar (sends SIGHUP or calls reload endpoint)

```yaml
containers:
- name: app
  image: myorg/app:1.2
  # app must handle SIGHUP or an HTTP reload endpoint
- name: config-reloader
  image: jimmidyson/configmap-reload:0.5
  args:
    - --volume-dir=/etc/config
    - --webhook-url=http://127.0.0.1:8080/-/reload   # optional: call app endpoint
  volumeMounts:
    - name: config
      mountPath: /etc/config
volumes:
- name: config
  configMap:
    name: app-config
```

#### B — Use an operator (Reloader / Stakater / External Secrets)

* Install Reloader or similar operator to watch ConfigMap changes and **trigger rollout** automatically.

#### C — GitOps / CI restart flow

* Update ConfigMap in Git → CI `kubectl apply` → CI patches Deployment annotation to trigger controlled rolling restart (auditable).

---

### 📋 Causes → Symptoms → Fix (compact table)

| Cause                                  | Symptom                                 | Fix                                                                |
| -------------------------------------- | --------------------------------------- | ------------------------------------------------------------------ |
| Env var injection                      | Env not changed after `kubectl apply`   | Restart Pod / rollout restart                                      |
| Mounted file, app ignores inode change | File mtime updated, app uses old config | Add sidecar to signal app (SIGHUP/webhook) or implement app reload |
| `subPath` mount                        | File never updates                      | Avoid `subPath` or copy file into subPath via sidecar              |
| Kubelet sync delay                     | Updates visible after ~1m               | Wait or use reloader for faster update                             |
| App lacks reload support               | App never re-reads config               | Add SIGHUP/HTTP reload handler or restart Pod                      |

---

### ✅ Best Practices (production-ready)

* **Design apps to reload config** (SIGHUP, HTTP `/-/reload`) rather than relying on env updates.
* **Avoid `subPath`** for runtime-updateable configs; if unavoidable, use sidecar copy.
* Use **config-reloader sidecar** or an operator (Reloader/Flux) to trigger safe rollouts.
* For auditable changes, use **GitOps + CI** that patches Deployment template to force rolling restart.
* Document the config-change runbook: whether to restart, reload endpoint, or wait for sync.
* Centralize logs/alerts for reload failures and monitor application health after config changes.

---

### 💡 In short

* **Env vars = only at startup** → restart Pods to apply.
* **Mounted files update**, but apps often need a **reload signal** (or avoid `subPath`).
* Use a **reloader sidecar/operator** or CI-driven rolling restart for safe, automated config propagation.

---
## Q: Node is `NotReady` — how to detect, troubleshoot, fix, and prevent it?

---

### 🧠 Overview

A `NotReady` node means the **kubelet stopped reporting the node as healthy** to the control plane. Consequence: Pods may be evicted or unschedulable, services lose capacity, and cluster reliability is impacted. This guide is a concise runbook: **detect → diagnose → remediate → prevent**.

---

### ⚙️ Purpose / How it works

Kubernetes marks a node `NotReady` when the API server stops receiving heartbeats/status from the kubelet or when node conditions (DiskPressure, MemoryPressure, NetworkUnavailable, etc.) are present. Root causes usually fall into: **kubelet crash**, **container runtime down**, **CNI/network failure**, **disk or inode exhaustion**, **certificate expiry**, or **cloud/VM issues**.

---

### 🧩 Examples / Commands / Quick-run checklist

#### 1) Observe state & events

```bash
kubectl get nodes
kubectl describe node <node-name>        # check Conditions + Events
kubectl get events --field-selector involvedObject.kind=Node,involvedObject.name=<node-name> --sort-by=.lastTimestamp
```

#### 2) Inspect kubelet & node services (SSH to node)

```bash
# check kubelet and container runtime
systemctl status kubelet -l
journalctl -u kubelet -n 200 --no-pager
# container runtime (containerd/docker)
systemctl status containerd && journalctl -u containerd -n 200
# or for Docker
systemctl status docker && journalctl -u docker -n 200
```

#### 3) Check node health endpoints (local)

```bash
# kubelet read-only (if enabled)
curl -sS http://127.0.0.1:10255/healthz
# kubelet metrics / health (secure)
curl --cacert /var/lib/kubelet/pki/kubelet.crt https://127.0.0.1:10250/healthz
```

#### 4) Inspect disk, inode, memory

```bash
df -h          # disk usage
df -i          # inode exhaustion
free -m        # memory pressure
ls -lah /var/log | tail
```

#### 5) Check CNI and kube-proxy pods (on control plane / kube-system)

```bash
kubectl get pods -n kube-system -o wide | egrep 'calico|cilium|weave|flannel|kube-proxy|aws-node'
kubectl logs -n kube-system <cni-pod>     # inspect CNI issues
kubectl logs -n kube-system kube-proxy-<id>
```

#### 6) Quick remediation commands

```bash
# If kubelet hung: restart kubelet
sudo systemctl restart kubelet

# If container runtime crashed:
sudo systemctl restart containerd    # or docker

# Evacuate node for maintenance:
kubectl cordon <node-name>
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data --force

# Uncordon after fix:
kubectl uncordon <node-name>
```

#### 7) Rejoin node (last resort)

```bash
# On control plane: get join command (or from cluster docs)
# On node (after kubeadm reset + fix):
sudo kubeadm reset -f
# Re-run kubeadm join ... (use saved token or create new token)
```

---

### 📋 Decision matrix — symptoms → likely cause → focused check/fix

|                                    Symptom | Likely cause                    | Quick check                                          | Fix                                                                         |
| -----------------------------------------: | :------------------------------ | :--------------------------------------------------- | :-------------------------------------------------------------------------- |
|                      kubelet not heartbeat | kubelet crashed                 | `systemctl status kubelet` / `journalctl -u kubelet` | restart kubelet; check logs                                                 |
|                        Node `DiskPressure` | Disk full or inode exhaustion   | `df -h` / `df -i`                                    | Clean logs (`/var/log`), rotate, remove orphaned docker images, expand disk |
|                      Pod networking broken | CNI plugin down                 | `kubectl get pods -n kube-system` for CNI            | restart CNI pods; check CNI config, MTU, iptables/ipvs                      |
| ImagePullBackOff / container runtime error | container runtime down          | `systemctl status containerd`                        | restart container runtime; check overlayfs and kernel                       |
|                         Certificate issues | kubelet client cert expired     | kubelet logs show x509 errors                        | rotate kubelet certs or enable cert rotation; kubeadm alpha certs renew     |
|                       Cloud VM unreachable | Node terminated or network loss | Cloud console, `ssh` failure                         | fix cloud instance, restart VM, reconcile cloud IAM/metadata                |
|                     kube-proxy misbehaving | Service routing broken          | `kubectl logs kube-proxy -n kube-system`             | restart kube-proxy DaemonSet; check iptables vs IPVS                        |
|                    Node tainted by kubelet | Node marked NotReady with taint | `kubectl describe node`                              | fix underlying issue; taint is auto-managed when NotReady                   |

---

### ✅ Best Practices — prevent `NotReady` and speed recovery

* **Monitoring & Alerts**: Alert on node `NotReady`, kubelet errors, disk/inode usage (Prometheus + Alertmanager).
* **Log rotation & disk quotas**: Rotate `/var/log`, prune images (`docker image prune -af` / `crictl`), ensure rootfs has headroom.
* **Health checks for kubelet & CRI**: Systemd + process monitoring (Datadog, Prometheus node-exporter).
* **CNI & kube-proxy HA**: Use stable, tested CNI; monitor CNI pods and iptables/IPVS.
* **Automated remediation**: Runbooks + automation to cordon/drain, restart services, or replace node via autoscaling.
* **Certificate rotation**: Enable kubelet cert rotation and monitor expiry.
* **Capacity & eviction settings**: Tune `kubelet` eviction thresholds to avoid sudden evictions.
* **Immutable infrastructure**: Replace unhealthy nodes (scale down/up or recreate VM) rather than manual fixes when possible.
* **Pre-flight checks before upgrades/maintenance**: cordon + drain, verify kubelet and CRI versions match recommended cgroup drivers.

---

### ⚠️ Safety notes & cautions

* **Don’t apply risky fixes blindly** (e.g., `kubeadm reset`) unless you understand cluster state & have backup.
* When restarting kubelet/containerd, ephemeral Pods will be briefly disrupted — cordon/drain if production-sensitive.
* Avoid overwriting stateful node volumes (EBS) without ensuring data integrity.

---

### 💡 In short

* `NotReady` = kubelet or node health problem. Start with `kubectl describe node` and node `journalctl -u kubelet` → check container runtime, disk/inode, CNI, and kube-proxy → restart services or cordon/drain node → rejoin/replace if necessary.
* Prevent with monitoring, log rotation, kubelet cert rotation, and automated remediation playbooks.

---
## Q: Need to deploy logging (ELK) stack

---

### 🧠 Overview

Deploying an **ELK/EFK** stack (Elasticsearch + Logstash/Fluentd + Kibana) on Kubernetes gives you centralized logging for searching, alerting, and observability. For production use on EKS/GKE/AKS prefer **managed or Helm-based installs**, secure communication, persistent storage, and index lifecycle management.

---

### ⚙️ Purpose / How it works

* **Elasticsearch (ES)**: stores and indexes logs (stateful, scales by shards / nodes).
* **Logstash / Fluentd / Filebeat**: collects logs from nodes/Pods and ships to ES (Logstash for heavy processing, Fluentd/Filebeat for lightweight shipping).
* **Kibana**: UI for search, dashboards, and alerts.
* **In Kubernetes**: run collectors as **DaemonSets** (one per node), ES as **StatefulSet** with PVs, Kibana as Deployment/Service + Ingress. Use **ILM (Index Lifecycle Management)** to manage retention and rollups.

---

### 🧩 Examples / Commands / Config snippets

> **Recommendation:** Use the official Elastic Helm charts or ECK (Elastic Cloud on Kubernetes) operator for production. Below shows both Helm and a minimal Fluentd DaemonSet example.

---

#### Option A — **Managed / Operator (recommended for prod)**

* **Elastic Cloud on Kubernetes (ECK)** operator manages ES+Kibana lifecycle, security, TLS, backup/restore.

```bash
# install ECK operator (namespace elastic-system)
kubectl apply -f https://download.elastic.co/downloads/eck/2.9.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/2.9.0/operator.yaml

# create an Elasticsearch cluster (example)
cat <<EOF | kubectl apply -f -
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: quickstart
spec:
  version: 8.8.0
  nodeSets:
  - name: default
    count: 3
    config:
      node.store.allow_mmap: false
    volumeClaimTemplates:
    - metadata:
        name: elasticsearch-data
      spec:
        accessModes: [ "ReadWriteOnce" ]
        resources:
          requests:
            storage: 100Gi
EOF

# create Kibana
cat <<EOF | kubectl apply -f -
apiVersion: kibana.k8s.elastic.co/v1
kind: Kibana
metadata:
  name: quickstart-kb
spec:
  version: 8.8.0
  count: 1
  elasticsearchRef:
    name: quickstart
EOF
```

* ECK handles TLS, users, snapshots (if configured), and rolling upgrades.

---

#### Option B — **Helm charts (Elastic Official)**

```bash
# add repo
helm repo add elastic https://helm.elastic.co
helm repo update

# install Elasticsearch (example 3-node)
helm install es-stack elastic/elasticsearch -f es-values.yaml --version 8.8.0

# sample es-values.yaml (minimal)
cat <<EOF > es-values.yaml
replicas: 3
minimumMasterNodes: 2
esConfig:
  elasticsearch.yml: |
    xpack.security.enabled: true
volumeClaimTemplate:
  accessModes: ["ReadWriteOnce"]
  resources:
    requests:
      storage: 100Gi
resources:
  requests:
    cpu: "1000m"
    memory: "2Gi"
  limits:
    cpu: "2000m"
    memory: "4Gi"
EOF
```

Install Kibana:

```bash
helm install kibana elastic/kibana -f kb-values.yaml
```

---

#### Fluentd DaemonSet (collect logs from `/var/log/containers` and forward to Elasticsearch)

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluentd-config
  namespace: kube-logging
data:
  fluent.conf: |
    <source>
      @type tail
      path /var/log/containers/*.log
      pos_file /var/log/fluentd-pos/es.pos
      tag kubernetes.*
      <parse>
        @type multi_format
        <pattern>
          format json
        </pattern>
        <pattern>
          format none
        </pattern>
      </parse>
    </source>

    <match kubernetes.**>
      @type elasticsearch
      host elasticsearch-es-http.kube-logging.svc.cluster.local
      port 9200
      scheme http
      logstash_format true
      flush_interval 5s
    </match>
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd
  namespace: kube-logging
spec:
  selector:
    matchLabels:
      app: fluentd
  template:
    metadata:
      labels:
        app: fluentd
    spec:
      serviceAccountName: fluentd
      tolerations:
      - key: node-role.kubernetes.io/master
        effect: NoSchedule
        operator: Exists
      containers:
      - name: fluentd
        image: fluent/fluentd:v1.14-debian-1
        env:
        - name: FLUENT_ELASTICSEARCH_HOST
          value: "elasticsearch-es-http.kube-logging.svc.cluster.local"
        volumeMounts:
        - name: varlog
          mountPath: /var/log
        - name: config
          mountPath: /fluentd/etc
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
      - name: config
        configMap:
          name: fluentd-config
```

Notes:

* Use `serviceAccount` with proper RBAC to read node logs if needed.
* For JSON log parsing of container logs follow Kubernetes log format.

---

### 📋 Table: Deployment Options — pros & cons

|                                               Option | Pros                                                 | Cons                                           |
| ---------------------------------------------------: | :--------------------------------------------------- | :--------------------------------------------- |
|                                   **ECK (Operator)** | Automates ES/Kibana lifecycle, TLS, backups, scaling | Operator learning curve; needs RBAC            |
|                           **Helm (official charts)** | Familiar for k8s users; flexible values              | You manage security, TLS, snapshots manually   |
| **Managed service (AWS OpenSearch / Elastic Cloud)** | Less ops, SLA, autoscaling, snapshots                | Cost; less direct control; version constraints |
|               **Self-built StatefulSet + DaemonSet** | Full control, minimal dependencies                   | Hard to operate at scale; operational burden   |

---

### ✅ Best Practices (production-ready)

**Storage & sizing**

* Use **fast disks** (gp3, local NVMe) for ES data; use `vm.max_map_count` tuning (`sysctl -w vm.max_map_count=262144`).
* Start with at least **3 master-eligible nodes**, separate data and master roles. Use dedicated ingest/coord nodes if high throughput.
* Use persistent volumes with `storageClassName` and snapshot schedule (VolSnapshots or cloud snapshots).

**Security**

* **Enable TLS** between all components (ECK automates).
* **Enable authentication** (native ES users or integrate with IdP).
* Restrict Kibana/ES access through Ingress + auth (OIDC/proxy) or use private access + VPN.

**Index Management**

* Use **ILM (Index Lifecycle Management)** to rollover indices (e.g., daily indices) and delete old ones automatically.
* Set appropriate **shard count** per index; avoid many small shards. Follow sizing guidelines: **~20–40GB per shard**.

**Collector configuration**

* Use **DaemonSets** for Fluentd/Filebeat; set backpressure and buffering to avoid OOM. Configure `bulk` size and retry/backoff.
* Prefer **Filebeat** if you want lightweight agent with Kubernetes autodiscovery.

**Observability & Alerts**

* Monitor ES cluster health (`green/yellow/red`), JVM memory, GC, disk utilization, and queue sizes.
* Alerts: shard failures, disk watermark, JVM OOM, node down.

**High availability & backups**

* Use **snapshots** to S3/GCS for backups and test restores.
* Use anti-affinity rules to spread ES pods across nodes/zones.

**Resource quotas & limits**

* Assign CPU/memory requests and limits for all pods (ES, Kibana, Fluentd).
* Use node taints/affinity for heavy stateful workloads.

**Cost & scale**

* Consider **hot-warm-cold** architecture: hot nodes for recent data, warm for less accessed, cold for long-term. Use searchable snapshots to reduce cost.

---

### ⚠️ Common Gotchas

* Running ES on small VMs with default settings → JVM OOM/GC issues. Tune heap (Xms/Xmx ≤ 50% of container memory, max 31GB for compressed oops).
* Too many shards → cluster overhead. Plan shards per index and time-based rollover.
* Forgetting `vm.max_map_count` → ES fails to start.
* Not securing ES → public data leakage.
* Log flood (high QPS) causing disk pressure — enforce backpressure and throttling at collector.

---

### 💡 In short

* **Recommended:** Use **ECK** or **managed OpenSearch/Elastic Cloud** for production to reduce operational burden.
* Run collectors (Fluentd/Filebeat) as **DaemonSets**, ES as **StatefulSet/Operator-managed** with PVs, and Kibana behind Ingress with TLS.
* Enforce **ILM**, **TLS/auth**, snapshots, proper sizing, and monitoring to ensure a reliable logging platform.
---
## Q: Application requires persistent storage — how to design, provision, and operate it in Kubernetes

---

### 🧠 Overview

Persistent storage for apps means data must survive Pod restarts, rescheduling, and node failures. In Kubernetes this is handled with **PersistentVolumes (PV)** and **PersistentVolumeClaims (PVC)** backed by cloud disks, NFS/EFS, Ceph, or CSI-managed storage. Choose storage by **access mode**, **performance**, **durability**, and **operational requirements** (snapshots, backups, encryption).

---

### ⚙️ Purpose / How it works

* **PVC** = app’s request for storage (size, access mode, storage class).
* **PV** = actual storage resource (manual or dynamically provisioned via `StorageClass`/CSI).
* **Stateful workloads** (DBs, queues) usually use **StatefulSets** + `volumeClaimTemplates`.
* **CSI drivers** provide cloud & on-prem integration, resizing, snapshots, encryption, and advanced features.
* A controller (provisioner) creates PVs for PVCs (dynamic provisioning) or binds to existing PV (static).

---

### 🧩 Examples / Commands / Config snippets

#### 1) StorageClass (AWS EBS example — dynamic provisioning)

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gp3-ssd
provisioner: ebs.csi.aws.com
parameters:
  type: gp3
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
mountOptions:
  - debug
```

#### 2) PVC (request 20Gi, RWO)

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-data-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
  storageClassName: gp3-ssd
```

#### 3) Deployment using PVC

```yaml
apiVersion: apps/v1
kind: Deployment
metadata: { name: app }
spec:
  replicas: 2
  selector: { matchLabels: { app: app } }
  template:
    metadata: { labels: { app: app } }
    spec:
      containers:
      - name: app
        image: myapp:1.0
        volumeMounts:
        - name: data
          mountPath: /var/lib/app/data
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: app-data-pvc
```

#### 4) StatefulSet with `volumeClaimTemplates` (recommended for DBs)

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata: { name: mysql }
spec:
  serviceName: mysql
  replicas: 3
  selector: { matchLabels: { app: mysql } }
  template:
    metadata: { labels: { app: mysql } }
    spec:
      containers:
      - name: mysql
        image: mysql:8
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
  volumeClaimTemplates:
  - metadata: { name: mysql-data }
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources: { requests: { storage: 50Gi } }
      storageClassName: gp3-ssd
```

#### 5) Resize PVC (if `allowVolumeExpansion: true`)

```bash
kubectl patch pvc app-data-pvc -p '{"spec":{"resources":{"requests":{"storage":"40Gi"}}}}'
# then check:
kubectl get pvc app-data-pvc
# Some filesystems require an exec into Pod to resize filesystem:
kubectl exec -it <pod> -- resize2fs /dev/<device>   # provider-specific
```

#### 6) Volume snapshots (CSI VolumeSnapshot API)

```yaml
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata: { name: ebs-snapclass }
driver: ebs.csi.aws.com
deletionPolicy: Delete
---
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata: { name: app-snap }
spec:
  volumeSnapshotClassName: ebs-snapclass
  source:
    persistentVolumeClaimName: app-data-pvc
```

```bash
# Create PVC from snapshot (restore)
kubectl apply -f pvc-from-snap.yaml
```

---

### 📋 Key differences / parameters (table)

|            Concern | Option / Setting                        | Notes                                                                        |
| -----------------: | :-------------------------------------- | :--------------------------------------------------------------------------- |
|   **Access modes** | `RWO`, `ROX`, `RWX`                     | RWO = single-node write; RWX = multi-node read/write (use EFS, CephFS)       |
|   **Provisioning** | Static PV vs Dynamic via `StorageClass` | Dynamic is preferred in cloud                                                |
|   **Binding mode** | `Immediate` vs `WaitForFirstConsumer`   | Use WaitForFirstConsumer for topology-aware volumes (zones)                  |
| **Reclaim policy** | `Delete` / `Retain`                     | `Delete` auto-cleans cloud disk; `Retain` preserves data for manual recovery |
|      **Expansion** | `allowVolumeExpansion: true`            | Requires CSI & storage backend support                                       |
|      **Snapshots** | CSI VolumeSnapshot                      | Requires CSI snapshotter installed                                           |
|    **Performance** | disk type (gp3, io2, SSD, HDD)          | Choose based on IOPS / throughput / latency needs                            |
|     **Encryption** | KMS / provider encryption               | Ensure PV encryption at rest if required by compliance                       |
| **Access control** | RBAC, IAM for CSI driver                | CSI plugin needs proper cloud IAM permissions                                |

---

### ✅ Best Practices (production-ready)

* **Pick correct storage for workload**

  * Databases → single-node high-performance block storage (RWO) with provisioned IOPS.
  * Shared files → EFS/EFS/Gluster/Ceph (RWX).
  * Logs/elastic → fast disks + replication + index lifecycle management.

* **Use CSI + StorageClass & dynamic provisioning** — avoid manual PVs where possible.

* **Set `volumeBindingMode: WaitForFirstConsumer`** for zone-aware provisioning (prevents cross-zone PVC binding).

* **Set `allowVolumeExpansion: true`** and test PVC resize flow in staging.

* **Use StatefulSet for stateful apps** (stable network id + stable storage per replica via `volumeClaimTemplates`).

* **Snapshots & backups**

  * Use CSI VolumeSnapshot (point-in-time) + periodic snapshots to S3/GCS.
  * Implement backup & restore runbooks (test restores regularly).

* **Reclaim policy**: use `Delete` for ephemeral workloads, `Retain` for critical data so accidental PVC delete won’t wipe disk.

* **Node affinity & topology**

  * Use Pod anti-affinity and node affinity to spread replicas across AZs/racks.
  * Ensure PVs are provisioned in same topology as Pod (use WaitForFirstConsumer).

* **Security**

  * Enable encryption-at-rest for disks (cloud provider KMS).
  * Use IAM or cloud credentials for CSI via Workload Identity / IRSA.
  * Limit who can create PVCs via RBAC and `StorageClass` allowed-by policy if needed.

* **Resource sizing & monitoring**

  * Right-size PVs and monitor disk utilization (Prometheus + node-exporter).
  * Set alerts for storage pressure, IOPS saturation, disk latency, and low capacity.

* **PodDisruptionBudget (PDB)** to keep minimum replicas during maintenance.

* **Avoid `subPath`** for files you expect to update; it prevents live updates.

---

### ⚠️ Common gotchas & quick fixes

* **PVC stuck `Pending`** → StorageClass missing or no matching provisioner; check `kubectl describe pvc`.
* **PVC bound to wrong zone** → Use `WaitForFirstConsumer` or correct topology.
* **Resize fails** → ensure `allowVolumeExpansion` and CSI support; check controller logs.
* **Snapshots not found** → install CSI snapshotter + VolumeSnapshotClass with correct driver.
* **RWX requirement on cloud** → use managed file storage (EFS) or a distributed FS (Ceph), not EBS.
* **Performance surprises** → tune disk type (gp3/io2) and IOPS/throughput; provision appropriately.

---

### 💡 In short

* Use **StorageClass + PVC** (dynamic provisioning via CSI) for production storage.
* Use **StatefulSet + volumeClaimTemplates** for databases and per-replica storage.
* Choose disk type (RWO vs RWX) by workload, enable snapshots & backups, and enforce security (encryption + IAM).
* Test resize/snapshot/restore flows and monitor disk health — implement PDBs and topology-aware binding for resilience.

--- 

## Q: Canary deployment

---

### 🧠 Overview

A **canary deployment** gradually rolls a new version to a small subset of users or requests, observes behavior, then increases traffic until 100% if metrics look good. It reduces risk vs full cutover and enables quick rollback on regressions.

---

### ⚙️ Purpose / How it works

* **Goal:** validate new release in production with minimal blast radius.
* **Mechanics:** run *stable* and *canary* instances concurrently; route a small percentage of traffic to canary; monitor errors/latency/metrics; promote or rollback automatically or manually.
* **Tools/approaches:** Replica ratio (simple), Ingress/Controller weighted routing, Service Mesh (Istio/Linkerd) request splitting, progressive delivery controllers (Argo Rollouts / Flagger), cloud LB weighted targets.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Simple replica-based canary (manual)

* Deploy stable and canary Deployments, use same Service selector that matches both — traffic split ≈ replica ratio.

```yaml
# stable
apiVersion: apps/v1
kind: Deployment
metadata: { name: web-stable }
spec:
  replicas: 4
  selector: { matchLabels: { app: web, version: stable } }
  template:
    metadata: { labels: { app: web, version: stable } }
    spec:
      containers: [{ name: web, image: myapp:1.0 }]
---
# canary
apiVersion: apps/v1
kind: Deployment
metadata: { name: web-canary }
spec:
  replicas: 1
  selector: { matchLabels: { app: web, version: canary } }
  template:
    metadata: { labels: { app: web, version: canary } }
    spec:
      containers: [{ name: web, image: myapp:1.1 }]
```

Scale canary up/down:

```bash
kubectl scale deploy/web-canary --replicas=2
kubectl scale deploy/web-stable --replicas=3
```

---

#### 2) Ingress weighted canary (NGINX annotations)

* NGINX Ingress supports simple canary via annotations.

```yaml
# stable ingress (normal)
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
spec:
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        backend:
          service:
            name: web-stable-svc
            port: { number: 80 }

# canary ingress (10% traffic)
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-canary-ingress
  annotations:
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "10"
spec:
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        backend:
          service:
            name: web-canary-svc
            port: { number: 80 }
```

---

#### 3) Service mesh splitting (Istio VirtualService — 10% canary)

```yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata: { name: web-vs }
spec:
  hosts: ["web-svc"]
  http:
  - route:
    - destination: { host: web, subset: stable } , weight: 90
    - destination: { host: web, subset: canary } , weight: 10
```

Use `DestinationRule` and `Deployment` with labels `version: stable|canary`.

---

#### 4) Progressive delivery with Argo Rollouts (recommended for automation)

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata: { name: web-rollout }
spec:
  replicas: 5
  strategy:
    canary:
      steps:
      - setWeight: 10
      - pause: {duration: 3m}
      - setWeight: 50
      - pause: {duration: 5m}
      - setWeight: 100
  selector: { matchLabels: { app: web } }
  template:
    metadata: { labels: { app: web } }
    spec:
      containers:
      - name: web
        image: myapp:1.1
```

Commands:

```bash
kubectl argo rollouts get rollout web-rollout
kubectl argo rollouts promote web-rollout   # force promote to 100%
kubectl argo rollouts undo web-rollout      # rollback
```

---

#### 5) Automated canary analysis with Flagger + Prometheus

* Flagger monitors Prometheus metrics (errors, latency) and promotes/rolls back automatically. Typical flow:

  * Deploy Flagger + Prometheus
  * Define an `Experiment` or `Canary` CR with metric thresholds
  * Flagger controls traffic shifts and rollback.

---

### 📋 Table: Strategy Comparison

|             Strategy |  Complexity |          Traffic control granularity          |      Automation      | Best for                               |
| -------------------: | :---------: | :-------------------------------------------: | :------------------: | :------------------------------------- |
|        Replica ratio |     Low     |              Approx (by replicas)             |        Manual        | Simple apps, small teams               |
|     Ingress weighted |    Medium   | Percent weights (Ingress controller features) |         Semi         | HTTP apps without service mesh         |
| Service mesh (Istio) |     High    |   Per-request weights, header-based routing   |         High         | Fine-grained control, AB tests         |
|        Argo Rollouts | Medium-High |         Precise step weights + pauses         |   High (integrated)  | Progressive delivery with CI           |
| Flagger (Prometheus) |    Medium   |           Metrics-driven automation           | High (auto rollback) | Auto analysis + rollback based on SLOs |

---

### ✅ Best Practices (production-ready)

* **Start small:** initial canary ≤ 5% traffic or 1 replica.
* **Use health checks:** liveness/readiness probes must be correct before routing traffic.
* **Monitor key metrics** (error rate, latency, saturation, logs, business KPIs) and set thresholds.
* **Automate promotion/rollback** when possible (Argo Rollouts, Flagger). Manual gating OK for critical systems.
* **Use immutable image tags** (no `latest`) and CI-generated artifacts.
* **Use PodDisruptionBudget** to protect minimum capacity during rollout.
* **Avoid DB-breaking changes** — handle schema migrations safely (backwards compatible).
* **Traffic routing strategies:** canary by % (broad), by header/cookie (target subset), by user segment (safer).
* **Run safety tests** (smoke, load, integration) during each pause step.
* **Observe for a stabilization window** between steps (allow metrics to settle).
* **Have rollback fast & automated:** rollback should revert traffic and recreate previous stable set.
* **Document runbook**: who approves promotion, rollback criteria, and emergency steps.

---

### ⚠️ Common Gotchas

* **Probes misconfigured** → canary marked unhealthy and killed; tune `initialDelaySeconds`.
* **Stateful changes** (DB migrations) not backward-compatible → use migration orchestration.
* **Logging/metrics not present** → you cannot evaluate canary. Ensure telemetry is in place.
* **Traffic flapping** from wrong ingress/controller config → test in staging first.
* **Auto-scaling interactions**: canary replicas affect HPA; plan minima/maxima.

---

### 💡 In short

* Canary = **gradual, measured rollout** of a new version.
* Start with a tiny traffic slice, automate metric-based promotion/rollback (Argo Rollouts / Flagger), and always monitor errors/latency and readiness probes.
* Use service mesh or ingress-weighting for precise traffic control; keep DB and schema changes backward-compatible.
---

Perfect timing 🚀 — here’s your **Kubernetes (K8s) interview Q&A set**, written DevOps-style:
✅ concise (2–3 lines)
✅ includes real-world context (EKS, deployments, networking, storage)
✅ ready for interviews or internal training docs.

---

## 🟢 **Kubernetes Basics**

| **Question**                                               | **Answer (Concise & Practical)**                                                                                                                |
| ---------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| **1. What is Kubernetes?**                                 | Kubernetes (K8s) is an **open-source container orchestration system** that automates deployment, scaling, and management of containerized apps. |
| **2. What are Pods in Kubernetes?**                        | Smallest deployable unit — a pod runs one or more containers sharing storage, network, and lifecycle.                                           |
| **3. Difference between Deployment, ReplicaSet, and Pod?** | - **Pod:** single instance<br>- **ReplicaSet:** ensures desired number of pods<br>- **Deployment:** manages ReplicaSets and updates.            |
| **4. What is a Namespace?**                                | Logical isolation inside a cluster for separating environments (dev, staging, prod).                                                            |
| **5. What is a Service?**                                  | Exposes pods as a network service. Types: **ClusterIP, NodePort, LoadBalancer, ExternalName.**                                                  |
| **6. What is a ConfigMap?**                                | Stores **non-sensitive configuration data** as key-value pairs (e.g., app settings). Mounted as env vars or files.                              |
| **7. What is a Secret?**                                   | Similar to ConfigMap, but stores **sensitive data** (e.g., passwords, tokens). Base64 encoded.                                                  |
| **8. What is a kubelet?**                                  | Node agent that runs pods and reports to the control plane.                                                                                     |
| **9. What is a node in Kubernetes?**                       | A **worker machine** (VM or EC2) that runs pods. Each node has kubelet, kube-proxy, and container runtime.                                      |
| **10. What is `kubectl`?**                                 | CLI tool to interact with Kubernetes API server. Example:<br>`kubectl get pods -n dev`.                                                         |

---

## 🟡 **Intermediate (Real-World Concepts)**

| **Question**                                                             | **Answer (Concise & Practical)**                                                                                           |
| ------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| **11. What is a ReplicaSet vs StatefulSet?**                             | - **ReplicaSet:** stateless pods (no identity).<br>- **StatefulSet:** maintains stable network IDs and persistent storage. |
| **12. What is a DaemonSet?**                                             | Ensures one pod runs on **every node** — used for logging, monitoring, or network agents.                                  |
| **13. What is a Job vs CronJob?**                                        | - **Job:** runs task once until success.<br>- **CronJob:** runs tasks on schedule (like cron).                             |
| **14. How does Kubernetes perform load balancing?**                      | Uses **kube-proxy** to route traffic among healthy pods behind a Service.                                                  |
| **15. How to check logs of a pod?**                                      | `kubectl logs <pod>` or for multi-container pods: `kubectl logs <pod> -c <container>`.                                     |
| **16. How do you access a pod shell?**                                   | `kubectl exec -it <pod> -- /bin/bash`.                                                                                     |
| **17. What is a PersistentVolume (PV) and PersistentVolumeClaim (PVC)?** | PV = actual storage resource; PVC = request by pod for storage.                                                            |
| **18. How do you expose a deployment externally?**                       | `kubectl expose deployment myapp --type=LoadBalancer --port=80`.                                                           |
| **19. What is a NodePort service?**                                      | Exposes a service on a static port (30000–32767) on each node’s IP.                                                        |
| **20. What is an Ingress in Kubernetes?**                                | Ingress manages HTTP/HTTPS routing via rules and optionally TLS.                                                           |

---

## 🔵 **Advanced / Production-Level**

| **Question**                                                         | **Answer (Concise & Practical)**                                                                                                                        |
| -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **21. What is an Ingress Controller and why do you need it?**        | It’s a reverse proxy (e.g., NGINX, AWS ALB) that implements Ingress rules — required for routing external traffic.                                      |
| **22. What is a ServiceAccount?**                                    | Provides identity for pods to interact with the Kubernetes API securely.                                                                                |
| **23. How do you handle rolling updates in Kubernetes?**             | Done via Deployments: `kubectl rollout restart deployment myapp`. Rollback with `kubectl rollout undo deployment myapp`.                                |
| **24. How do you restrict resource usage per pod?**                  | Define `resources.requests` and `resources.limits` in YAML to control CPU/memory.                                                                       |
| **25. How do you perform blue-green or canary deployments?**         | Use separate deployments or Ingress routing with weighted traffic.                                                                                      |
| **26. How do you troubleshoot a failing pod?**                       | `kubectl describe pod <pod>` → event logs; `kubectl logs` → container logs.                                                                             |
| **27. What’s the difference between readiness and liveness probes?** | - **Liveness:** restarts unhealthy container.<br>- **Readiness:** controls if pod should receive traffic.                                               |
| **28. How do you scale pods automatically?**                         | Use **Horizontal Pod Autoscaler (HPA)** based on CPU/memory metrics. Example:<br>`kubectl autoscale deployment myapp --cpu-percent=70 --min=2 --max=5`. |
| **29. What is taint and toleration?**                                | - **Taint:** marks node for specific workloads.<br>- **Toleration:** lets pods run on tainted nodes (e.g., GPU or infra-only nodes).                    |
| **30. What is a ConfigMap reload issue, and how to fix it?**         | Pods don’t auto-reload ConfigMap changes — restart the pod or use reloader (e.g., Stakater Reloader).                                                   |

---

## ⚙️ **Common kubectl Commands**

| **Command**                              | **Purpose**                       |
| ---------------------------------------- | --------------------------------- |
| `kubectl get pods`                       | List all pods                     |
| `kubectl describe pod <pod>`             | Show pod details and events       |
| `kubectl logs <pod>`                     | View container logs               |
| `kubectl exec -it <pod> -- /bin/bash`    | Access pod shell                  |
| `kubectl apply -f app.yaml`              | Apply manifest file               |
| `kubectl delete -f app.yaml`             | Delete resources                  |
| `kubectl get all -n <ns>`                | List all resources in a namespace |
| `kubectl top pod`                        | View pod resource usage           |
| `kubectl rollout undo deployment <name>` | Rollback deployment               |
| `kubectl config use-context <context>`   | Switch between clusters           |

---

## 🧠 **Scenario-Based Kubernetes Questions**

| **Scenario**                            | **Answer / Solution**                                                              |
| --------------------------------------- | ---------------------------------------------------------------------------------- |
| Pods keep crashing                      | Check `kubectl describe pod` for OOM or CrashLoopBackOff. Review probes and image. |
| ConfigMap changes not reflecting        | Restart deployment or use sidecar reloader.                                        |
| Node is NotReady                        | Check kubelet, networking, and node resource pressure.                             |
| Need to deploy logging (ELK) stack      | Use DaemonSet for Filebeat/FluentD to ship logs to Elasticsearch.                  |
| Application requires persistent storage | Use PV + PVC, or dynamic provisioning via StorageClass (EBS, NFS, EFS).            |
| Canary deployment                       | Use multiple deployments with Ingress weight-based routing.                        |
| Access pod in private cluster           | Use `kubectl port-forward` or Bastion host + kubeconfig.                           |

---

## 🧩 **Kubernetes Components Overview**

| **Component**          | **Purpose**                                            |
| ---------------------- | ------------------------------------------------------ |
| **API Server**         | Exposes K8s API — entry point for all commands.        |
| **etcd**               | Key-value store holding cluster state.                 |
| **Controller Manager** | Manages background controllers (replica, job, node).   |
| **Scheduler**          | Decides where pods run based on resource availability. |
| **Kubelet**            | Runs pods and communicates with API server.            |
| **Kube Proxy**         | Handles network routing for services.                  |

---

## ☸️ **Kubernetes with AWS (EKS)**

| **Use Case**       | **Implementation**                                          |
| ------------------ | ----------------------------------------------------------- |
| Create EKS cluster | `eksctl create cluster --name demo --region ap-south-1`     |
| Manage nodes       | NodeGroups (via EC2 ASG or Fargate profiles).               |
| Access EKS         | Update kubeconfig: `aws eks update-kubeconfig --name demo`. |
| Store logs         | Integrate with CloudWatch or ELK.                           |
| Deploy apps        | Use `kubectl apply -f deployment.yaml`.                     |

---

## 🔐 **Best Practices**

| **Area**              | **Recommendation**                                          |
| --------------------- | ----------------------------------------------------------- |
| **Security**          | Use RBAC, ServiceAccounts, and NetworkPolicies.             |
| **Storage**           | Use dynamic PVs and StorageClasses.                         |
| **Configuration**     | Use ConfigMaps/Secrets; avoid hardcoding.                   |
| **Resource Limits**   | Always define CPU/memory requests and limits.               |
| **Networking**        | Use Ingress controllers (ALB, NGINX).                       |
| **Monitoring**        | Use Prometheus + Grafana, or CloudWatch Container Insights. |
| **Logging**           | Centralize logs with FluentD/Filebeat.                      |
| **High Availability** | Use multi-AZ node groups and pod anti-affinity.             |

---

## 🚀 **Pro Tips**

* Always use **namespaces** for environment isolation.
* Store manifests in Git → manage via **GitOps (ArgoCD / Flux)**.
* Prefer **Deployments** for stateless, **StatefulSets** for databases.
* Use `kubectl get events` for troubleshooting.
* Enable **autoscaling (HPA + Cluster Autoscaler)** for cost optimization.

---
## Q: Canary deployment

---

### 🧠 Overview

A **canary deployment** gradually rolls a new version to a small subset of users or requests, observes behavior, then increases traffic until 100% if metrics look good. It reduces risk vs full cutover and enables quick rollback on regressions.

---

### ⚙️ Purpose / How it works

* **Goal:** validate new release in production with minimal blast radius.
* **Mechanics:** run *stable* and *canary* instances concurrently; route a small percentage of traffic to canary; monitor errors/latency/metrics; promote or rollback automatically or manually.
* **Tools/approaches:** Replica ratio (simple), Ingress/Controller weighted routing, Service Mesh (Istio/Linkerd) request splitting, progressive delivery controllers (Argo Rollouts / Flagger), cloud LB weighted targets.

---

### 🧩 Examples / Commands / Config snippets

#### 1) Simple replica-based canary (manual)

* Deploy stable and canary Deployments, use same Service selector that matches both — traffic split ≈ replica ratio.

```yaml
# stable
apiVersion: apps/v1
kind: Deployment
metadata: { name: web-stable }
spec:
  replicas: 4
  selector: { matchLabels: { app: web, version: stable } }
  template:
    metadata: { labels: { app: web, version: stable } }
    spec:
      containers: [{ name: web, image: myapp:1.0 }]
---
# canary
apiVersion: apps/v1
kind: Deployment
metadata: { name: web-canary }
spec:
  replicas: 1
  selector: { matchLabels: { app: web, version: canary } }
  template:
    metadata: { labels: { app: web, version: canary } }
    spec:
      containers: [{ name: web, image: myapp:1.1 }]
```

Scale canary up/down:

```bash
kubectl scale deploy/web-canary --replicas=2
kubectl scale deploy/web-stable --replicas=3
```

---

#### 2) Ingress weighted canary (NGINX annotations)

* NGINX Ingress supports simple canary via annotations.

```yaml
# stable ingress (normal)
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
spec:
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        backend:
          service:
            name: web-stable-svc
            port: { number: 80 }

# canary ingress (10% traffic)
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-canary-ingress
  annotations:
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "10"
spec:
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        backend:
          service:
            name: web-canary-svc
            port: { number: 80 }
```

---

#### 3) Service mesh splitting (Istio VirtualService — 10% canary)

```yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata: { name: web-vs }
spec:
  hosts: ["web-svc"]
  http:
  - route:
    - destination: { host: web, subset: stable } , weight: 90
    - destination: { host: web, subset: canary } , weight: 10
```

Use `DestinationRule` and `Deployment` with labels `version: stable|canary`.

---

#### 4) Progressive delivery with Argo Rollouts (recommended for automation)

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata: { name: web-rollout }
spec:
  replicas: 5
  strategy:
    canary:
      steps:
      - setWeight: 10
      - pause: {duration: 3m}
      - setWeight: 50
      - pause: {duration: 5m}
      - setWeight: 100
  selector: { matchLabels: { app: web } }
  template:
    metadata: { labels: { app: web } }
    spec:
      containers:
      - name: web
        image: myapp:1.1
```

Commands:

```bash
kubectl argo rollouts get rollout web-rollout
kubectl argo rollouts promote web-rollout   # force promote to 100%
kubectl argo rollouts undo web-rollout      # rollback
```

---

#### 5) Automated canary analysis with Flagger + Prometheus

* Flagger monitors Prometheus metrics (errors, latency) and promotes/rolls back automatically. Typical flow:

  * Deploy Flagger + Prometheus
  * Define an `Experiment` or `Canary` CR with metric thresholds
  * Flagger controls traffic shifts and rollback.

---

### 📋 Table: Strategy Comparison

|             Strategy |  Complexity |          Traffic control granularity          |      Automation      | Best for                               |
| -------------------: | :---------: | :-------------------------------------------: | :------------------: | :------------------------------------- |
|        Replica ratio |     Low     |              Approx (by replicas)             |        Manual        | Simple apps, small teams               |
|     Ingress weighted |    Medium   | Percent weights (Ingress controller features) |         Semi         | HTTP apps without service mesh         |
| Service mesh (Istio) |     High    |   Per-request weights, header-based routing   |         High         | Fine-grained control, AB tests         |
|        Argo Rollouts | Medium-High |         Precise step weights + pauses         |   High (integrated)  | Progressive delivery with CI           |
| Flagger (Prometheus) |    Medium   |           Metrics-driven automation           | High (auto rollback) | Auto analysis + rollback based on SLOs |

---

### ✅ Best Practices (production-ready)

* **Start small:** initial canary ≤ 5% traffic or 1 replica.
* **Use health checks:** liveness/readiness probes must be correct before routing traffic.
* **Monitor key metrics** (error rate, latency, saturation, logs, business KPIs) and set thresholds.
* **Automate promotion/rollback** when possible (Argo Rollouts, Flagger). Manual gating OK for critical systems.
* **Use immutable image tags** (no `latest`) and CI-generated artifacts.
* **Use PodDisruptionBudget** to protect minimum capacity during rollout.
* **Avoid DB-breaking changes** — handle schema migrations safely (backwards compatible).
* **Traffic routing strategies:** canary by % (broad), by header/cookie (target subset), by user segment (safer).
* **Run safety tests** (smoke, load, integration) during each pause step.
* **Observe for a stabilization window** between steps (allow metrics to settle).
* **Have rollback fast & automated:** rollback should revert traffic and recreate previous stable set.
* **Document runbook**: who approves promotion, rollback criteria, and emergency steps.

---

### ⚠️ Common Gotchas

* **Probes misconfigured** → canary marked unhealthy and killed; tune `initialDelaySeconds`.
* **Stateful changes** (DB migrations) not backward-compatible → use migration orchestration.
* **Logging/metrics not present** → you cannot evaluate canary. Ensure telemetry is in place.
* **Traffic flapping** from wrong ingress/controller config → test in staging first.
* **Auto-scaling interactions**: canary replicas affect HPA; plan minima/maxima.

---

### 💡 In short

* Canary = **gradual, measured rollout** of a new version.
* Start with a tiny traffic slice, automate metric-based promotion/rollback (Argo Rollouts / Flagger), and always monitor errors/latency and readiness probes.
* Use service mesh or ingress-weighting for precise traffic control; keep DB and schema changes backward-compatible.

---
## Q: Kubernetes Architecture — Core Components and How It Works ⚙️

---

### 🧠 Overview

Kubernetes follows a **master–worker (control plane–node)** architecture.
The **Control Plane** makes *decisions* (scheduling, scaling, healing) and maintains *cluster state*,
while **Worker Nodes** actually *run the workloads (Pods)*.

All communication between components goes through the **API Server**, making it the single source of truth.

---

### 🧩 Core Architecture Diagram (conceptually)

```
                +---------------------------+
                |       Control Plane       |
                |---------------------------|
                |  API Server  <---->  etcd |
                |     ↑   ↓                 |
                | Controller Manager        |
                | Scheduler                 |
                +-----------+---------------+
                            |
                            | (K8s API)
                            ↓
        +-------------------------------------------+
        |               Worker Nodes                |
        |-------------------------------------------|
        | Kubelet     |  Kube Proxy  |   Container Runtime |
        |  (Agent)    | (Networking) |   (Docker/CRI-O)    |
        |-------------------------------------------|
        | Pods (Containers running your apps)       |
        +-------------------------------------------+
```

---

### ⚙️ Control Plane Components

| Component                                          | Purpose                                                               | How it Works                                                                                                                                                                                                     |
| -------------------------------------------------- | --------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **API Server (`kube-apiserver`)**                  | Central hub & gateway for all commands (kubectl, controllers, nodes). | All operations (CRUD) go via REST API. Auth, RBAC, admission controls, and validation happen here. Communicates with `etcd` for state.                                                                           |
| **etcd**                                           | Highly available key–value store for cluster state.                   | Stores data like Pods, Deployments, ConfigMaps, Secrets, node info. Every cluster change (spec/status) is persisted here. Usually runs as a secured cluster with snapshots.                                      |
| **Controller Manager (`kube-controller-manager`)** | Runs background controllers that maintain desired state.              | Continuously watches the cluster via API server and reconciles state (e.g., if a Pod dies, ReplicaSet controller creates a new one). Includes node, replication, job, endpoint, and service account controllers. |
| **Scheduler (`kube-scheduler`)**                   | Decides where new Pods will run.                                      | Evaluates Pod specs (resource requests, taints/tolerations, affinities) → finds best node → assigns Pod. Writes binding info back to API server.                                                                 |
| **Cloud Controller Manager** *(if cloud-managed)*  | Integrates cluster with cloud provider APIs.                          | Manages cloud resources like load balancers, routes, and volumes based on Kubernetes objects (e.g., Service → ELB).                                                                                              |

---

### ⚙️ Node (Worker) Components

| Component             | Purpose                                                  | How it Works                                                                                                                                                            |
| --------------------- | -------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Kubelet**           | Node agent — ensures Pods are running as expected.       | Watches API Server for assigned Pods → runs them via the container runtime (Docker/Containerd/CRI-O). Reports Pod status, metrics, and events back to the API server.   |
| **Kube Proxy**        | Manages network rules for services and Pod connectivity. | Configures iptables/ipvs rules for service load balancing. Routes external/internal traffic to correct Pod endpoints.                                                   |
| **Container Runtime** | Actually runs the containers inside Pods.                | Follows CRI (Container Runtime Interface). Examples: containerd, CRI-O, Docker shim (deprecated). Handles pulling images, managing namespaces, and starting containers. |

---

### 🧠 Control Plane → Node Interaction (Step-by-Step Flow)

1. **kubectl apply -f deployment.yaml**
   → API request to **kube-apiserver**.
2. **API Server** stores desired state (Deployment object) in **etcd**.
3. **Controller Manager** detects a new Deployment → creates ReplicaSet → creates Pod objects.
4. **Scheduler** sees unassigned Pods → picks the best Node → updates binding info.
5. **Kubelet (on that Node)** sees new Pod assigned → pulls image → starts containers using **container runtime**.
6. **Kubelet** reports Pod status back to API Server → visible via `kubectl get pods`.
7. **Kube Proxy** updates service routing → traffic automatically load-balanced to the new Pod.

---

### 📋 Real-World Control Plane Flow Example

| Action                                  | Component Involved                      | Description                           |
| --------------------------------------- | --------------------------------------- | ------------------------------------- |
| User runs `kubectl apply -f nginx.yaml` | **kubectl → API Server**                | Request hits API Server (REST call).  |
| Object persisted                        | **API Server → etcd**                   | Desired state stored in etcd.         |
| Deployment reconciliation               | **Controller Manager**                  | Ensures ReplicaSet & Pods exist.      |
| Pod scheduling                          | **Scheduler**                           | Chooses Node based on CPU/mem/taints. |
| Pod creation                            | **Kubelet (on node)**                   | Starts containers via containerd.     |
| Network setup                           | **Kube Proxy + CNI plugin**             | Configures routing & Pod IPs.         |
| Monitoring                              | **Kubelet reports status → API Server** | Updates Pod conditions and health.    |

---

### ⚙️ Networking Stack (High-Level)

* **CNI Plugin (e.g., Calico, Weave, Cilium):** allocates Pod IPs, configures routes between Pods across nodes.
* **Kube Proxy:** implements service-level virtual IP and load balancing via iptables or IPVS.
* **Cluster DNS (CoreDNS):** resolves service names (`my-svc.default.svc.cluster.local`) to virtual IPs.
* **Ingress Controller:** handles Layer 7 (HTTP) traffic into cluster.

---

### ✅ Best Practices (production-ready)

* **etcd:** use dedicated nodes, encrypted at rest, with regular snapshots.
* **Control Plane:** run as HA (3+ masters) across zones; secure with TLS & RBAC.
* **Kubelet:** ensure resource monitoring (cAdvisor/metrics-server).
* **Kube Proxy:** prefer IPVS mode for performance.
* **Audit logging:** enable at API Server for traceability.
* **Pod Security & Admission Control:** enforce via OPA/Gatekeeper or PSP replacements.
* **Metrics:** monitor API latency, controller queue depth, scheduler decisions, etc.

---

### 💡 In short

* **Control Plane = Brain** 🧠 → defines, schedules, and maintains desired state.
* **Worker Nodes = Muscles** 💪 → run the actual workloads (Pods).
* **API Server = Gateway**, **etcd = Memory**, **Controller = Self-healing**, **Scheduler = Placement logic**, **Kubelet = Executor**, **Kube Proxy = Networking brain**.
  Together they form a **self-healing, declarative orchestration system** that continuously drives actual state toward desired state.
---