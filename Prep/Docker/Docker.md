## **1️⃣ Basics & Fundamentals**

### 🧠 **Q: What is Docker?**

**Docker** is a **containerization platform** that packages an application and all its dependencies into a **lightweight, portable container**.
These containers can run consistently across environments — from a developer’s laptop to production servers — eliminating “works on my machine” issues.

---

### ⚙️ **Key Concepts**

| **Component**             | **Description**                                                           |
| ------------------------- | ------------------------------------------------------------------------- |
| **Image**                 | A read-only blueprint for a container (includes OS, libraries, app code). |
| **Container**             | A running instance of an image (isolated process).                        |
| **Dockerfile**            | A text file with instructions to build a Docker image.                    |
| **Docker Engine**         | The runtime that builds and runs containers.                              |
| **Docker Hub / Registry** | Repository to store and share Docker images.                              |

---

### 🧩 **Example**

**Dockerfile**

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

**Commands**

```bash
# Build image
docker build -t myapp:latest .

# Run container
docker run -d -p 3000:3000 myapp:latest
```

✅ Runs the same way on any host with Docker installed.

---

### ⚙️ **Why Use Docker**

| **Benefit**     | **Explanation**                                                      |
| --------------- | -------------------------------------------------------------------- |
| **Portability** | Runs anywhere — laptop, VM, Kubernetes, or cloud.                    |
| **Isolation**   | Each container has its own filesystem, processes, and dependencies.  |
| **Efficiency**  | Lightweight compared to full VMs — shares OS kernel.                 |
| **Scalability** | Integrates easily with orchestrators like **Kubernetes** or **ECS**. |
| **Consistency** | Ensures reproducible builds and environments.                        |

---

### ✅ **In short:**

> **Docker** is a platform to build, ship, and run applications inside lightweight containers — ensuring consistency, portability, and isolation across environments.

---
---

## **Q: What’s the difference between a Virtual Machine (VM) and a Docker Container?**

### 🧠 **Overview**

Both VMs and Docker containers isolate workloads, but **VMs virtualize hardware**, while **containers virtualize the OS** — making containers lighter, faster, and more portable.

---

### ⚙️ **Comparison Table**

| **Aspect**          | **Virtual Machine (VM)**                                               | **Docker Container**                                                     |
| ------------------- | ---------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| **Architecture**    | Includes **entire OS** with virtualized hardware via a **hypervisor**. | Shares the **host OS kernel**; isolates apps using namespaces & cgroups. |
| **Startup Time**    | Slow — boots full OS (minutes).                                        | Fast — starts in seconds.                                                |
| **Resource Usage**  | Heavy — each VM runs its own OS (GBs of RAM).                          | Lightweight — shares OS kernel (MBs).                                    |
| **Isolation Level** | Strong — hardware-level via hypervisor.                                | Process-level isolation — depends on kernel features.                    |
| **Performance**     | Slight overhead due to full virtualization.                            | Near-native performance (minimal overhead).                              |
| **Portability**     | VM image tied to hypervisor (e.g., VMware, Hyper-V).                   | Runs anywhere Docker is available.                                       |
| **Management**      | Managed with hypervisors (VMware, KVM).                                | Managed with Docker CLI, Compose, or Kubernetes.                         |
| **Use Case**        | Full OS environments, legacy apps, high isolation.                     | Microservices, CI/CD, cloud-native deployments.                          |
| **Example**         | Ubuntu VM on VMware.                                                   | Node.js app in Docker container.                                         |

---

### 🧩 **Visual Representation**

```
VMs:                    Containers:
+------------------+    +----------------+
| Guest OS (Ubuntu)|    |   App Binaries |
| App & Libs       |    |   App Libs     |
|------------------|    |----------------|
| Hypervisor       |    | Docker Engine  |
| Host OS          |    | Host OS Kernel |
+------------------+    +----------------+
```

---

### ✅ **In short:**

> **VMs** emulate full hardware and OS — heavier, slower, but fully isolated.
> **Docker containers** share the host OS kernel — lightweight, faster, and ideal for **microservices and DevOps workflows**.

---
---

## **Q: What is the difference between a Docker Image and a Docker Container?**

### 🧠 **Overview**

A **Docker image** is a **blueprint** (read-only template) that defines what’s inside your app environment — code, dependencies, OS packages.
A **Docker container** is a **runtime instance** of that image — a live, running process.

---

### ⚙️ **Comparison Table**

| **Aspect**           | **Docker Image**                                                 | **Docker Container**                                           |
| -------------------- | ---------------------------------------------------------------- | -------------------------------------------------------------- |
| **Definition**       | Read-only **template** with app code, runtime, and dependencies. | **Running instance** of a Docker image.                        |
| **State**            | Static — does not change once built.                             | Dynamic — can be started, stopped, deleted, or modified.       |
| **Persistence**      | Immutable (build-time artifact).                                 | Temporary (data lost when stopped unless persisted to volume). |
| **Storage**          | Stored in Docker registry (e.g., Docker Hub, ECR).               | Created on host filesystem when run.                           |
| **Creation Command** | `docker build`                                                   | `docker run`                                                   |
| **Lifecycle**        | Build → Push → Pull                                              | Create → Start → Stop → Remove                                 |
| **Example**          | `nginx:latest` (image stored in registry).                       | Running `nginx` server process.                                |

---

### 🧩 **Example**

**1️⃣ Build an image**

```bash
docker build -t myapp:latest .
```

**2️⃣ Run a container**

```bash
docker run -d -p 8080:80 myapp:latest
```

**What happens:**

* `myapp:latest` → image (template)
* Running instance → container (actual process)

---

### ⚙️ **Visual**

```
Docker Image  →  Immutable template (like a class)
Docker Container  →  Running instance (like an object)
```

---

### ✅ **In short:**

> A **Docker image** is the **recipe** for your app environment,
> a **Docker container** is the **running instance** created from that recipe.
---
---

## **Q: What is a Dockerfile?**

### 🧠 **Overview**

A **Dockerfile** is a **text file** containing a list of **instructions** that tell Docker **how to build an image** — like a recipe for packaging your application (code, dependencies, OS libraries, etc.) into a Docker image.

---

### ⚙️ **Key Facts**

| **Aspect**  | **Description**                                              |
| ----------- | ------------------------------------------------------------ |
| **Purpose** | Automate Docker image creation.                              |
| **Type**    | Simple text file (named `Dockerfile`).                       |
| **Used By** | `docker build` command to produce an image.                  |
| **Output**  | A reusable Docker **image** that can run as a **container**. |

---

### 🧩 **Common Dockerfile Instructions**

| **Instruction** | **Purpose**                             | **Example**             |
| --------------- | --------------------------------------- | ----------------------- |
| `FROM`          | Base image (starting point).            | `FROM node:18-alpine`   |
| `WORKDIR`       | Set working directory inside container. | `WORKDIR /app`          |
| `COPY`          | Copy files from host into image.        | `COPY package*.json ./` |
| `RUN`           | Execute commands during image build.    | `RUN npm ci`            |
| `EXPOSE`        | Document port used by container.        | `EXPOSE 3000`           |
| `CMD`           | Default command when container starts.  | `CMD ["npm", "start"]`  |

---

### ⚙️ **Example: Node.js App**

**Dockerfile**

```dockerfile
# Use official Node.js base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy dependencies and install
COPY package*.json ./
RUN npm ci

# Copy application code
COPY . .

# Expose app port
EXPOSE 3000

# Start app
CMD ["npm", "start"]
```

**Build & Run**

```bash
# Build image
docker build -t myapp:latest .

# Run container
docker run -d -p 3000:3000 myapp:latest
```

---

### 🧠 **Analogy**

A **Dockerfile** is like a **recipe**;
the **image** is the **prepared dish**;
the **container** is the **dish being served and eaten** (running process).

---

### ✅ **In short:**

> A **Dockerfile** is a script of build instructions that Docker uses to create an **image**,
> which you can then run as a **container** — ensuring consistent environments everywhere.
---
---

## **Q: What are the common Dockerfile commands?**

### 🧠 **Overview**

A **Dockerfile** uses a set of simple build commands to define how a **Docker image** should be created — specifying the base image, software installation, environment setup, and default runtime behavior.

---

### ⚙️ **Most Common Dockerfile Commands**

| **Command**       | **Purpose**                                                                        | **Example**                                                             |   |         |
| ----------------- | ---------------------------------------------------------------------------------- | ----------------------------------------------------------------------- | - | ------- |
| **`FROM`**        | Defines the **base image** to build from. (First instruction in every Dockerfile.) | `FROM ubuntu:22.04`                                                     |   |         |
| **`WORKDIR`**     | Sets the **working directory** inside the container.                               | `WORKDIR /app`                                                          |   |         |
| **`COPY`**        | Copies files/folders from host → image.                                            | `COPY . /app`                                                           |   |         |
| **`ADD`**         | Like `COPY`, but supports remote URLs & auto-extracts archives.                    | `ADD app.tar.gz /app/`                                                  |   |         |
| **`RUN`**         | Executes **commands at build time** (install packages, build code).                | `RUN apt-get update && apt-get install -y nginx`                        |   |         |
| **`CMD`**         | Sets the **default command** to run when the container starts.                     | `CMD ["npm", "start"]`                                                  |   |         |
| **`ENTRYPOINT`**  | Defines the **main process**; combines with `CMD` for arguments.                   | `ENTRYPOINT ["python", "app.py"]`                                       |   |         |
| **`EXPOSE`**      | Documents the port(s) the container listens on.                                    | `EXPOSE 8080`                                                           |   |         |
| **`ENV`**         | Sets **environment variables** inside the container.                               | `ENV NODE_ENV=production`                                               |   |         |
| **`ARG`**         | Defines **build-time variables** (used during image build).                        | `ARG VERSION=1.0`                                                       |   |         |
| **`USER`**        | Specifies which **user** the container runs as.                                    | `USER appuser`                                                          |   |         |
| **`VOLUME`**      | Creates a **mount point** for persistent data.                                     | `VOLUME /data`                                                          |   |         |
| **`LABEL`**       | Adds **metadata** to the image (for tracking/ownership).                           | `LABEL maintainer="vasu@devops.io"`                                     |   |         |
| **`HEALTHCHECK`** | Defines a command to **monitor container health**.                                 | `HEALTHCHECK CMD curl -f [http://localhost:8080](http://localhost:8080) |   | exit 1` |
| **`ONBUILD`**     | Adds a **trigger instruction** for child images built from this one.               | `ONBUILD RUN npm install`                                               |   |         |
| **`SHELL`**       | Changes the **default shell** for `RUN` commands.                                  | `SHELL ["/bin/bash", "-c"]`                                             |   |         |

---

### 🧩 **Example: Simple Dockerfile**

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
EXPOSE 3000
ENV NODE_ENV=production
CMD ["npm", "start"]
```

---

### 🧠 **Best Practices**

✅ Use `alpine` base images for lightweight builds.
✅ Combine `RUN` steps to reduce image layers.
✅ Use `.dockerignore` to skip unnecessary files.
✅ Always pin image versions (`FROM node:18.18.0-alpine`).
✅ Use `HEALTHCHECK` for container monitoring.

---

### ✅ **In short:**

> Common Dockerfile commands like **FROM, RUN, COPY, CMD, EXPOSE, ENV, and WORKDIR** define how to **build, configure, and run** a Docker image — each instruction forming a **layer** in the final container image.
---
---

## **Q: How do you build and run a Docker image?**

### 🧠 **Overview**

You use two core Docker commands:

* `docker build` → creates an **image** from a **Dockerfile**
* `docker run` → starts a **container** from that image

---

### ⚙️ **Step-by-Step Example**

#### 1️⃣ **Create a Dockerfile**

```dockerfile
# Dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
EXPOSE 5000
CMD ["python", "app.py"]
```

---

#### 2️⃣ **Build the image**

```bash
docker build -t myapp:latest .
```

| Flag              | Meaning                                                 |
| ----------------- | ------------------------------------------------------- |
| `-t myapp:latest` | Tags the image (name: `myapp`, tag: `latest`)           |
| `.`               | Build context (current directory containing Dockerfile) |

✅ Output:

```
Successfully built a1b2c3d4e5f6
Successfully tagged myapp:latest
```

---

#### 3️⃣ **Verify image**

```bash
docker images
```

Example output:

```
REPOSITORY   TAG       IMAGE ID       SIZE
myapp        latest    a1b2c3d4e5f6   145MB
```

---

#### 4️⃣ **Run the container**

```bash
docker run -d -p 5000:5000 --name myapp-container myapp:latest
```

| Flag           | Description                        |
| -------------- | ---------------------------------- |
| `-d`           | Run in detached mode (background). |
| `-p 5000:5000` | Map host port → container port.    |
| `--name`       | Assign a custom container name.    |

✅ Now your app is running at `http://localhost:5000`.

---

#### 5️⃣ **Check running containers**

```bash
docker ps
```

#### 6️⃣ **Stop & remove**

```bash
docker stop myapp-container
docker rm myapp-container
```

---

### 🧩 **Optional Commands**

| Command                                           | Purpose                           |
| ------------------------------------------------- | --------------------------------- |
| `docker logs myapp-container`                     | View app logs                     |
| `docker exec -it myapp-container /bin/sh`         | Get shell access inside container |
| `docker rmi myapp:latest`                         | Remove image                      |
| `docker build -f ./Dockerfile.dev -t myapp-dev .` | Specify custom Dockerfile         |

---

### ✅ **In short:**

> Build with `docker build -t myapp:latest .`
> Run with `docker run -d -p 8080:8080 myapp:latest`
> This builds the image from your Dockerfile and launches a container from it.
---
---

## **Q: How do you check running Docker containers?**

### 🧠 **Overview**

You can list, inspect, and monitor running containers using Docker CLI commands like `docker ps`, `docker inspect`, and `docker logs`.

---

### ⚙️ **Common Commands**

| **Command**                           | **Purpose**                                                      | **Example Output**                                               |
| ------------------------------------- | ---------------------------------------------------------------- | ---------------------------------------------------------------- |
| **`docker ps`**                       | Lists **running containers** only.                               | `CONTAINER ID  IMAGE  STATUS  PORTS  NAMES`                      |
| **`docker ps -a`**                    | Lists **all containers** (running + stopped).                    | Includes `Exited` containers.                                    |
| **`docker ps --format`**              | Custom output format (filter columns).                           | `docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"` |
| **`docker container ls`**             | Same as `docker ps`.                                             | Modern syntax equivalent.                                        |
| **`docker inspect <container_name>`** | Shows **detailed metadata** (IP, mounts, env vars, etc.).        | JSON output.                                                     |
| **`docker logs <container_name>`**    | Displays logs from a running (or stopped) container.             | Useful for debugging.                                            |
| **`docker top <container_name>`**     | Shows running **processes** inside container.                    | Like `ps aux` for containers.                                    |
| **`docker stats`**                    | Real-time CPU, memory, network stats for all running containers. | Live performance metrics.                                        |

---

### 🧩 **Example**

```bash
docker ps
```

**Output:**

```
CONTAINER ID   IMAGE         COMMAND             STATUS         PORTS                  NAMES
e7a1c2f0a1b3   myapp:latest  "python app.py"     Up 2 minutes   0.0.0.0:5000->5000/tcp myapp-container
```

To include stopped containers:

```bash
docker ps -a
```

---

### 🧱 **Inspect container details**

```bash
docker inspect myapp-container
```

➡ Returns JSON with info like:

* IP address
* Mounts
* Env variables
* Network mode

---

### 🧩 **Monitor resource usage**

```bash
docker stats
```

Example:

```
CONTAINER ID   NAME              CPU %   MEM USAGE / LIMIT   NET I/O
e7a1c2f0a1b3   myapp-container   1.2%    85MiB / 2GiB        1.2MB / 1.0MB
```

---

### ✅ **In short:**

> Use `docker ps` to view **running containers**,
> `docker ps -a` for **all containers**,
> and `docker stats` or `docker inspect` for **detailed runtime info**.
---
---

## **Q: How do you stop or remove Docker containers and images?**

### 🧠 **Overview**

Docker provides simple commands to **stop**, **remove**, and **clean up** containers and images safely.
You can manage them individually or in bulk.

---

### ⚙️ **1️⃣ Stop Running Containers**

| **Command**                          | **Description**                           |
| ------------------------------------ | ----------------------------------------- |
| `docker stop <container_id_or_name>` | Gracefully stops a running container.     |
| `docker kill <container_id_or_name>` | Forcefully stops (immediate SIGKILL).     |
| `docker ps`                          | View running containers to get IDs/names. |

**Example:**

```bash
docker stop myapp-container
```

✅ The container moves from **“Up” → “Exited”** state.

---

### ⚙️ **2️⃣ Remove Containers**

| **Command**                           | **Description**                                    |
| ------------------------------------- | -------------------------------------------------- |
| `docker rm <container_id_or_name>`    | Removes a stopped container.                       |
| `docker rm -f <container_id_or_name>` | Force remove even if running (combines stop + rm). |
| `docker container prune`              | Removes **all stopped** containers (cleanup).      |

**Example:**

```bash
docker rm myapp-container
# or
docker rm -f myapp-container
```

**Bulk cleanup:**

```bash
docker container prune
```

🧹 Output:
`Deleted Containers: ...`
`Total reclaimed space: XX MB`

---

### ⚙️ **3️⃣ Remove Images**

| **Command**                     | **Description**                                                               |
| ------------------------------- | ----------------------------------------------------------------------------- |
| `docker rmi <image_id_or_name>` | Deletes a Docker image.                                                       |
| `docker rmi -f <image_id>`      | Force delete (even if used by stopped containers).                            |
| `docker image prune`            | Removes **unused** images.                                                    |
| `docker system prune -a`        | Cleans up **containers, images, networks, build cache** (aggressive cleanup). |

**Example:**

```bash
docker rmi myapp:latest
```

**List images:**

```bash
docker images
```

**Prune unused ones:**

```bash
docker image prune -a
```

---

### ⚙️ **4️⃣ Remove All Containers & Images (use with caution)**

```bash
# Stop and remove all containers
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

# Remove all images
docker rmi $(docker images -q)
```

---

### 🧠 **Best Practices**

✅ Stop containers before removing.
✅ Use `docker system prune -a` only in non-production systems.
✅ Avoid `-f` unless you’re sure — it can delete running or dependent resources.
✅ Use labels to filter cleanup (e.g., `docker ps -a --filter "label=env=dev"`).

---

### ✅ **In short:**

> Stop containers with `docker stop`, remove them with `docker rm`,
> delete images with `docker rmi`, and clean up unused data using `docker system prune -a`.
---
---

## **Q: What are Docker Volumes?**

### 🧠 **Overview**

A **Docker volume** is a **persistent storage mechanism** that allows data to **live outside** a container’s lifecycle.
When a container is removed, its data (in a volume) **remains intact** — enabling data sharing and persistence between containers.

---

### ⚙️ **Why Volumes Are Needed**

| **Without Volumes**                               | **With Volumes**                                        |
| ------------------------------------------------- | ------------------------------------------------------- |
| Container writes data to its internal filesystem. | Data stored in a separate managed location on the host. |
| When the container is deleted → data is lost.     | Data **persists** even after container removal.         |
| Data can’t easily be shared between containers.   | Multiple containers can **mount the same volume**.      |

---

### ⚙️ **Types of Docker Storage**

| **Type**        | **Description**                                  | **Use Case**                           |
| --------------- | ------------------------------------------------ | -------------------------------------- |
| **Volume**      | Managed by Docker in `/var/lib/docker/volumes/`. | Preferred for persistent, shared data. |
| **Bind Mount**  | Maps a host directory into the container.        | Development (edit local files live).   |
| **Tmpfs Mount** | Stored in memory only (not persisted).           | Temporary or sensitive data (fast).    |

---

### 🧩 **Basic Commands**

| **Command**                    | **Purpose**               |
| ------------------------------ | ------------------------- |
| `docker volume create <name>`  | Create a named volume.    |
| `docker volume ls`             | List existing volumes.    |
| `docker volume inspect <name>` | View details of a volume. |
| `docker volume rm <name>`      | Remove a volume.          |
| `docker volume prune`          | Delete unused volumes.    |

---

### 🧩 **Example: Using a Volume**

**1️⃣ Create a volume**

```bash
docker volume create mydata
```

**2️⃣ Run a container using the volume**

```bash
docker run -d \
  -v mydata:/var/lib/mysql \
  --name mysql-db \
  mysql:8
```

✅ The MySQL database files are stored in the **`mydata` volume**, not inside the container.

**3️⃣ Check volumes**

```bash
docker volume ls
```

```
DRIVER    VOLUME NAME
local     mydata
```

**4️⃣ Inspect volume**

```bash
docker volume inspect mydata
```

---

### 🧩 **Example: Bind Mount (for dev environments)**

```bash
docker run -d \
  -v $(pwd):/usr/share/nginx/html \
  -p 8080:80 \
  nginx
```

✅ Mounts your local folder into the container — ideal for live code reload during development.

---

### ⚙️ **Named vs Anonymous Volumes**

| **Type**             | **Created How**   | **Persistence**                                             |
| -------------------- | ----------------- | ----------------------------------------------------------- |
| **Named Volume**     | `-v mydata:/path` | Persists with a recognizable name.                          |
| **Anonymous Volume** | `-v /path`        | Docker assigns random name; deleted when container removed. |

---

### 🧠 **Best Practices**

✅ Use **named volumes** for databases or stateful apps.
✅ Use **bind mounts** only for dev/test (can cause permission drift).
✅ Always mount to **application-specific paths** (e.g., `/data`, `/var/lib/mysql`).
✅ Combine with `--mount` syntax for clarity:

```bash
docker run --mount type=volume,source=mydata,target=/app/data myapp
```

---

### ✅ **In short:**

> **Docker volumes** store persistent data **outside containers**, allowing it to **survive restarts, rebuilds, and updates** — perfect for databases, logs, or shared application state.
---
---

## **Q: What is Docker Hub?**

### 🧠 **Overview**

**Docker Hub** is **Docker’s official cloud-based registry service** where developers can **store, share, and distribute Docker images**.
It acts like **GitHub for container images** — the default registry that `docker pull` and `docker push` commands use.

---

### ⚙️ **Key Features**

| **Feature**              | **Description**                                                                    |
| ------------------------ | ---------------------------------------------------------------------------------- |
| **Image Registry**       | Stores public and private Docker images.                                           |
| **Public Repositories**  | Free, open access images (e.g., `nginx`, `mysql`, `ubuntu`).                       |
| **Private Repositories** | Secure, access-controlled image storage for teams.                                 |
| **Automated Builds**     | Build images directly from GitHub/GitLab commits.                                  |
| **Webhooks**             | Trigger CI/CD actions after a successful image push.                               |
| **Organization & Teams** | Manage user permissions and collaboration.                                         |
| **Verified Publishers**  | Official images from trusted vendors (e.g., `amazon/aws-cli`, `microsoft/dotnet`). |

---

### ⚙️ **Common CLI Commands**

| **Command**            | **Purpose**                        |
| ---------------------- | ---------------------------------- |
| `docker login`         | Authenticate with Docker Hub.      |
| `docker pull <image>`  | Download an image from Docker Hub. |
| `docker push <image>`  | Upload an image to Docker Hub.     |
| `docker search <term>` | Search for images on Docker Hub.   |

---

### 🧩 **Example Workflow**

#### 1️⃣ Login to Docker Hub

```bash
docker login
```

#### 2️⃣ Pull a public image

```bash
docker pull nginx:latest
```

#### 3️⃣ Tag and push your own image

```bash
docker tag myapp:latest vasu/myapp:1.0
docker push vasu/myapp:1.0
```

#### 4️⃣ Run directly from Docker Hub

```bash
docker run -d -p 8080:80 vasu/myapp:1.0
```

---

### ⚙️ **Repository Types**

| **Type**         | **Visibility**                                   | **Example**                  |
| ---------------- | ------------------------------------------------ | ---------------------------- |
| **Public Repo**  | Anyone can pull (e.g., open-source base images). | `docker pull nginx`          |
| **Private Repo** | Only authorized users can access.                | `docker pull myorg/app:prod` |

---

### 🧠 **Best Practices**

✅ Use **versioned tags** (e.g., `app:1.2.3`) — avoid `latest` in production.
✅ Enable **2FA** and access tokens for secure pushes.
✅ Use **Automated Builds** or CI/CD pipelines to publish images.
✅ Clean up unused or outdated image tags to save space.

---

### ✅ **In short:**

> **Docker Hub** is Docker’s **central image registry** for storing and sharing container images —
> developers use it to **push** their own images and **pull** base or official images for their apps.
---
---

## **Q: What’s the difference between `COPY` and `ADD` in a Dockerfile?**

### 🧠 **Overview**

Both `COPY` and `ADD` place files into a Docker image during build,
but `ADD` has **extra features** (auto-extracting archives and fetching remote URLs) — which can introduce unintended behavior.
👉 **Best practice:** use `COPY` unless you specifically need `ADD`’s extras.

---

### ⚙️ **Comparison Table**

| **Aspect**                        | **`COPY`**                                                        | **`ADD`**                                                                        |
| --------------------------------- | ----------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| **Purpose**                       | Copies local files/directories from build context into the image. | Copies local files **or** downloads from URLs **or** auto-extracts tar archives. |
| **Supports Remote URLs**          | ❌ No                                                              | ✅ Yes (`ADD https://example.com/file.tar.gz /app/`)                              |
| **Auto-Extracts `.tar` Archives** | ❌ No (copies as-is)                                               | ✅ Yes (automatically extracts `.tar`, `.tar.gz`, `.tgz`, etc.)                   |
| **Simplicity**                    | Very explicit — only copies local files.                          | Multi-purpose — can lead to unexpected results.                                  |
| **Recommended Use**               | Always use for static file copies.                                | Use **only** for `.tar` extraction or remote file download.                      |

---

### 🧩 **Example: Using `COPY`**

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
```

✅ Straightforward and predictable.
Copies files from your local directory into `/app` inside the image.

---

### 🧩 **Example: Using `ADD` for specific purpose**

```dockerfile
# 1️⃣ Auto-extracts tar.gz archive
ADD app.tar.gz /opt/app/

# 2️⃣ Downloads a remote file
ADD https://example.com/config.json /etc/config/
```

⚠️ These are valid uses of `ADD`, but use cautiously — remote URLs can cause caching issues.

---

### 🧠 **Caching Impact**

* Docker’s layer caching can behave differently if a remote URL changes with `ADD`.
* `COPY` only changes the image layer if the **source file** changes, making builds more predictable.

---

### ✅ **Best Practices**

✅ Prefer `COPY` for all local file transfers.
✅ Use `ADD` **only** when you need its special abilities (auto-extract or remote fetch).
✅ Avoid `ADD` for downloading files — use `RUN curl` or `RUN wget` for explicit control.

---

### ✅ **In short:**

> `COPY` → Simple, predictable file copy (recommended).
> `ADD` → Can also fetch URLs and auto-extract archives — **use sparingly** to avoid hidden side effects.
---
---

## **Q: What’s the difference between `CMD` and `ENTRYPOINT` in a Dockerfile?**

### 🧠 **Overview**

Both **`CMD`** and **`ENTRYPOINT`** define what command runs when a container starts.
But their **behavior differs** — `ENTRYPOINT` sets the **main executable**, and `CMD` provides **default arguments** (or a fallback command).

---

### ⚙️ **Comparison Table**

| **Aspect**            | **`CMD`**                                                      | **`ENTRYPOINT`**                                                                         |
| --------------------- | -------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| **Purpose**           | Provides **default command or arguments** to run.              | Defines the **main executable** that always runs.                                        |
| **Override Behavior** | Completely overridden if arguments are passed to `docker run`. | Not overridden — arguments from `docker run` are **passed to ENTRYPOINT** as parameters. |
| **Typical Use**       | Default behavior (like `python app.py`).                       | Define fixed command (like `python`) that should always execute.                         |
| **Syntax**            | `CMD ["executable", "param1"]` or `CMD command param1`         | `ENTRYPOINT ["executable", "param1"]` or `ENTRYPOINT command param1`                     |
| **Best Practice**     | Use for providing defaults that users can override.            | Use for defining a container’s “main command”.                                           |

---

### 🧩 **Example 1: Using `CMD` Alone**

```dockerfile
FROM ubuntu
CMD ["echo", "Hello World"]
```

**Run:**

```bash
docker run myimage
# Output: Hello World
```

**Override CMD:**

```bash
docker run myimage echo "Hi Vasu"
# Output: Hi Vasu
```

✅ `CMD` is **fully replaced** by new arguments.

---

### 🧩 **Example 2: Using `ENTRYPOINT` Alone**

```dockerfile
FROM ubuntu
ENTRYPOINT ["echo", "Hello"]
```

**Run:**

```bash
docker run myimage World
# Output: Hello World
```

✅ `ENTRYPOINT` is **not overridden** — it always runs `echo`, and you just pass arguments.

---

### 🧩 **Example 3: Combine `ENTRYPOINT` + `CMD`**

```dockerfile
FROM python:3.11
ENTRYPOINT ["python", "app.py"]
CMD ["--env=prod"]
```

**Run (default):**

```bash
docker run myapp
# Runs → python app.py --env=prod
```

**Run (override CMD only):**

```bash
docker run myapp --env=dev
# Runs → python app.py --env=dev
```

✅ Perfect combo — `ENTRYPOINT` defines *what* runs, `CMD` defines *how* it runs.

---

### ⚙️ **Best Practices**

| ✅ Recommended Pattern                | 💡 Example                               |
| ------------------------------------ | ---------------------------------------- |
| Fixed executable → `ENTRYPOINT`      | `ENTRYPOINT ["nginx", "-g"]`             |
| Default arguments → `CMD`            | `CMD ["daemon off;"]`                    |
| Use **exec form** (`["cmd", "arg"]`) | Avoid shell form for signal handling     |
| Combine both for flexibility         | Works well for configurable apps/scripts |

---

### ✅ **In short:**

> 🧩 **`ENTRYPOINT`** = sets the **main command** (always runs)
> 🧩 **`CMD`** = sets **default arguments** or fallback command (can be overridden)
---
# Short answer (2 lines)

Use **multi-stage builds**, tiny base images (Alpine / distroless / slim), and remove build-time deps & caches so only runtime artifacts remain. Combine RUN steps, use a `.dockerignore`, and analyze layers (dive/docker history) — iterate until your image is minimal and reproducible.

# How to reduce Docker image size — practical checklist + examples

## Quick checklist (apply these in order)

* Use **multi-stage builds**: build in one stage, copy only final artifacts to runtime stage.
* Prefer **smaller bases**: `node:18-alpine`, `python:3.11-slim`, or `gcr.io/distroless/*`.
* **Remove build dependencies** after compile (or don’t install them in final stage).
* Combine `RUN` lines and clean package manager caches in the same layer.
* Use **`--no-install-recommends`** for `apt-get` and `--no-cache` for `apk`.
* Add a **`.dockerignore`** (exclude node_modules, .git, tests, docs).
* Use production-only install steps (npm `--production` / `npm prune --production`, `pip install --no-dev` or use wheels).
* Strip debug symbols / remove docs, locales, tests from packages if possible.
* Use `COPY --from=builder` to copy only runtime files.
* Analyze with `docker history`, `docker image inspect`, and `dive` to find big layers.
* Automate size checks in CI and fail on regressions.

---

## Useful commands

```bash
# build image
docker build -t myapp:latest .

# list images with size
docker images

# show layer history
docker history myapp:latest

# interactive layer explorer (install separately)
dive myapp:latest

# remove dangling images/cache
docker system prune -a --volumes
```

---

## Examples

### Node.js — Multi-stage build (recommended)

```dockerfile
# Stage 1: builder
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --production=false
COPY . .
RUN npm run build        # produce dist/ or build artifacts

# Stage 2: runtime (minimal)
FROM node:18-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production
# copy only built files + package.json for runtime deps
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./
RUN npm ci --production=true --no-audit --no-fund
USER node
CMD ["node", "dist/index.js"]
```

Notes:

* Build tools (compilers, dev deps) remain in builder stage only.
* Final image contains only runtime deps + built artifacts.

---

### Python — Multi-stage with slim & wheel caching

```dockerfile
# Stage 1: builder
FROM python:3.11-slim AS builder
WORKDIR /app
RUN apt-get update && apt-get install -y build-essential --no-install-recommends && rm -rf /var/lib/apt/lists/*
COPY pyproject.toml poetry.lock ./
RUN pip install --upgrade pip build
RUN pip wheel --no-deps --wheel-dir /wheels .
COPY . .
RUN pip install --no-deps --no-index --find-links /wheels -r requirements.txt

# Stage 2: runtime (distroless or slim)
FROM python:3.11-slim AS runtime
WORKDIR /app
COPY --from=builder /wheels /wheels
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /app /app
ENV PYTHONUNBUFFERED=1
USER 1000
CMD ["python", "app/main.py"]
```

Notes:

* Use wheels to avoid build tools in runtime.
* Consider distroless for even smaller images (no shell).

---

## `.dockerignore` example

```
node_modules
.git
.gitignore
Dockerfile*
README.md
tests
.vscode
.env
```

Always add `node_modules`/`venv` to avoid copying heavy dev files into the image context.

---

## Layer & package manager tips

* Combine apt-get commands:

  ```dockerfile
  RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
      && do-build \
      && apt-get purge -y build-essential \
      && rm -rf /var/lib/apt/lists/*
  ```

  This ensures build deps and caches are removed in the same layer.
* For Alpine:

  ```dockerfile
  RUN apk add --no-cache build-base python3-dev \
      && build-stuff \
      && apk del build-base python3-dev
  ```
* For npm, build with `npm ci` and install runtime deps only in final stage: `npm ci --production`.

---

## Advanced options

* Use **distroless** or **scratch** for smallest runtime (no package manager, no shell) — great for single-binary apps.
* Use **multi-arch** and `--platform` to pick smaller base images (some base images are lighter on certain architectures).
* Use image minifiers like `docker-slim` (experimental) to strip unused files.
* Use `upx` to compress binaries (for Go / static binaries).

---

## How to analyze where size comes from

* `docker history <image>` shows layer sizes — identify which `RUN`/`COPY` caused bloat.
* `dive <image>` lets you inspect each layer and the filesystem contents (excellent for root-cause).
* `docker image ls --format "{{.Repository}}:{{.Tag}}\t{{.Size}}"` for quick overview.

---

## Small checklist for CI

* Fail CI if image > threshold.
* Run `dive` or automated script to extract large files and report.
* Cache intermediate build artifacts in CI to avoid re-building everything every pipeline run.

---

### Final one-line tip

Start with multi-stage builds and a strict `.dockerignore` — then iterate with `dive` to remove the biggest offenders (dev deps, build caches, large static files).

---
---

## **Q: What is a Multi-Stage Build in Docker?**

### 🧠 **Overview**

A **multi-stage build** is a Docker technique that lets you use **multiple `FROM` statements** in a single Dockerfile — so you can **build** your application in one stage (with all tools/dependencies) and **copy only the final artifacts** into a **smaller runtime image**.

✅ **Goal:** produce a **lightweight, secure image** without build tools or unnecessary files.

---

### ⚙️ **Why It’s Needed**

| **Without Multi-Stage Build**                           | **With Multi-Stage Build**                   |
| ------------------------------------------------------- | -------------------------------------------- |
| Single image contains compilers, caches, and dev tools. | Only final binaries or app files are copied. |
| Large, insecure, slow to deploy.                        | Smaller, faster, production-ready image.     |
| Must manually clean dependencies.                       | Automatically discarded after build stage.   |

---

### 🧩 **Basic Syntax**

```dockerfile
# ---- Stage 1: Build ----
FROM golang:1.21 AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp .

# ---- Stage 2: Runtime ----
FROM gcr.io/distroless/base
WORKDIR /app
COPY --from=builder /app/myapp .
CMD ["./myapp"]
```

✅ Result:

* The first stage builds the binary.
* The second stage copies only the compiled binary — no Go compiler, no source code.

---

### 🧩 **Example: Node.js App**

```dockerfile
# ---- Stage 1: Build ----
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ---- Stage 2: Runtime ----
FROM node:18-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./
RUN npm ci --omit=dev
CMD ["node", "dist/server.js"]
```

✅ **Advantages:**

* Keeps build tools (TypeScript, Webpack, etc.) out of the final image.
* Cuts image size from ~700 MB → ~150 MB.

---

### ⚙️ **Common Use Cases**

* **Compiled apps** (Go, Java, Rust, C#): keep only binary/JAR.
* **Web apps**: build front-end bundles and copy static assets only.
* **CI/CD pipelines**: generate one Dockerfile for both build & deploy stages.
* **Security**: final stage has fewer packages and no compilers.

---

### ⚙️ **Inspecting Multi-Stage Builds**

```bash
docker build -t myapp:latest .
docker images  # Only shows the final stage image
docker build --target builder -t myapp-builder .  # Optionally keep build stage
```

---

### ✅ **In short:**

> A **multi-stage build** lets you **build and package** in one Dockerfile using multiple `FROM` stages —
> copy only what’s needed into the final stage to create **smaller, faster, and more secure images**.
---
---

## **Q: What are Docker Networks?**

### 🧠 **Overview**

**Docker networks** allow containers to **communicate with each other** and the **outside world** securely and efficiently.
Each network defines how containers connect — isolating traffic, managing DNS, and enabling service discovery.

---

### ⚙️ **Purpose of Docker Networks**

* Enable **container-to-container communication** (e.g., app ↔ database).
* Provide **isolation** between environments (e.g., dev, test, prod).
* Control **connectivity and access** (like private subnets).
* Provide **automatic DNS resolution** — containers can use names instead of IPs.

---

### ⚙️ **Types of Docker Networks**

| **Network Type**       | **Description**                                                                       | **Use Case**                                                    |
| ---------------------- | ------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| **bridge** *(default)* | Containers share a private network on the same host; communicate via container names. | Most common for standalone apps.                                |
| **host**               | Removes network isolation; container uses the **host’s network stack**.               | High-performance apps (e.g., monitoring agents).                |
| **none**               | No network access (completely isolated).                                              | Security or offline jobs.                                       |
| **overlay**            | Multi-host network using Docker Swarm; connects containers across hosts.              | Clustered / distributed apps.                                   |
| **macvlan**            | Assigns a container a **unique MAC address** on the host’s LAN.                       | Integrate containers with physical network (e.g., legacy apps). |

---

### 🧩 **Example: Bridge Network**

**1️⃣ Create a custom bridge**

```bash
docker network create mynet
```

**2️⃣ Run two containers on the same network**

```bash
docker run -d --name db --network mynet mysql:8
docker run -d --name app --network mynet myapp:latest
```

**3️⃣ Verify communication**
Inside `app` container:

```bash
ping db
```

✅ Works! Docker auto-creates DNS for container names (`db` resolves to container IP).

---

### 🧩 **Inspect Networks**

```bash
docker network ls
```

```
NETWORK ID     NAME      DRIVER    SCOPE
a1b2c3d4e5f6   bridge    bridge    local
b2c3d4e5f6g7   host      host      local
```

Inspect a network in detail:

```bash
docker network inspect mynet
```

---

### 🧩 **Connect/Disconnect Containers Dynamically**

```bash
docker network connect mynet app-container
docker network disconnect mynet app-container
```

---

### ⚙️ **Example: Compose YAML**

Docker Compose automatically creates networks:

```yaml
services:
  web:
    image: nginx
    networks:
      - appnet
  db:
    image: mysql
    networks:
      - appnet

networks:
  appnet:
    driver: bridge
```

✅ Both `web` and `db` share `appnet` and can reach each other by name.

---

### 🧠 **Best Practices**

✅ Use **user-defined bridge** networks (not default) — better DNS and isolation.
✅ Avoid exposing internal services (like DB) to `0.0.0.0`.
✅ Use **`--network-alias`** for multiple hostnames.
✅ In Swarm/Kubernetes, prefer **overlay networks** for cross-node traffic.

---

### ✅ **In short:**

> **Docker networks** connect containers securely and define how they communicate.
> Use **bridge** for local apps, **overlay** for multi-host, and **host** for high-performance or monitoring workloads.
---
---

## **Q: How do you inspect container details like IP, environment variables, and mounts?**

### 🧠 **Overview**

You can use the **`docker inspect`** command to view **complete metadata** about any container — including **network settings (IP)**, **environment variables**, **mounts**, **volumes**, and **runtime config**.

---

### ⚙️ **1️⃣ Basic Command**

```bash
docker inspect <container_name_or_id>
```

✅ Returns detailed **JSON output** with all container properties:

* Network settings (IP, MAC)
* Mounts / volumes
* Environment variables
* Image, entrypoint, command
* Host configuration (ports, binds, resources)

---

### ⚙️ **2️⃣ Filter Specific Fields (using `--format`)**

You can extract only the info you need using **Go template syntax**:

| **Info**                   | **Command**                                                                                  | **Example Output**                                              |
| -------------------------- | -------------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| **Container IP**           | `docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container>`    | `172.18.0.3`                                                    |
| **Container Name**         | `docker inspect -f '{{.Name}}' <container>`                                                  | `/myapp`                                                        |
| **Image Used**             | `docker inspect -f '{{.Config.Image}}' <container>`                                          | `myapp:latest`                                                  |
| **Environment Variables**  | `docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' <container>`                  | `NODE_ENV=prod` ...                                             |
| **Mount Points / Volumes** | `docker inspect -f '{{json .Mounts}}' <container>`                                           | `[{ "Source": "/var/lib/docker/volumes/app_data/_data", ... }]` |
| **Network Name**           | `docker inspect -f '{{range $k, $v := .NetworkSettings.Networks}}{{$k}}{{end}}' <container>` | `mynet`                                                         |
| **Ports Mapped**           | `docker inspect -f '{{json .NetworkSettings.Ports}}' <container>`                            | `{ "80/tcp": [{"HostPort": "8080"}] }`                          |

---

### 🧩 **Example**

```bash
docker inspect -f 'Container IP: {{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' myapp
```

Output:

```
Container IP: 172.18.0.5
```

---

### ⚙️ **3️⃣ Inspect Mounts**

```bash
docker inspect -f '{{range .Mounts}}{{println .Source "->" .Destination}}{{end}}' myapp
```

Output:

```
/var/lib/docker/volumes/mydata/_data -> /app/data
```

---

### ⚙️ **4️⃣ Check Environment Variables**

```bash
docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' myapp
```

Output:

```
NODE_ENV=production
DB_HOST=db
PORT=3000
```

---

### 🧩 **Alternative: `docker exec` (quick view)**

If the container is running, you can inspect live values:

```bash
docker exec -it myapp env       # show environment vars
docker exec -it myapp hostname -I  # show IP
docker exec -it myapp df -h      # check mounted volumes
```

---

### ⚙️ **5️⃣ List all network details**

```bash
docker inspect -f '{{json .NetworkSettings}}' myapp | jq
```

Shows IP addresses, gateways, and MAC addresses across all attached networks.

---

### 🧠 **Best Practices**

✅ Use `--format` to avoid parsing large JSON manually.
✅ Combine with `jq` for structured output.
✅ Always check `.NetworkSettings.Networks` for container IP — not `.IPAddress` (deprecated).

---

### ✅ **In short:**

> Use `docker inspect <container>` to view **container metadata**.
> Add `--format` to extract fields like **IP**, **environment vars**, and **mounts** quickly.
> Example:
>
> ```bash
> docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' myapp
> ```
---
Short answer (2 lines)
Authenticate using the AWS ECR login helper (`aws ecr get-login-password | docker login ...`), tag the image with the ECR repo URI, then `docker push`. In CI use OIDC or an assume-role flow (no long-lived keys), build in the pipeline, tag, and push with the temporary creds.

---

# README.md — Push Docker images to AWS ECR (copy-ready)

## Overview

Steps to log in and push images to a private AWS ECR registry from local or CI:

1. Ensure an ECR repo exists (create if needed).
2. Authenticate Docker to ECR with `aws ecr get-login-password`.
3. Build, tag the image with the ECR repo URI, then `docker push`.
4. In CI: use OIDC or `sts:AssumeRole` to obtain temporary credentials (preferred).

---

## Pre-reqs

* AWS CLI v2 installed and configured OR CI that can assume a role / use OIDC.
* Docker installed.
* IAM principal has ECR permissions: `ecr:GetAuthorizationToken`, `ecr:BatchCheckLayerAvailability`, `ecr:PutImage`, `ecr:InitiateLayerUpload`, `ecr:UploadLayerPart`, `ecr:CompleteLayerUpload`, `ecr:CreateRepository` (if creating repos).

---

## 1) Create repo (if it doesn’t exist)

```bash
aws ecr describe-repositories --repository-names my-app || \
aws ecr create-repository --repository-name my-app --image-scanning-configuration scanOnPush=true
```

---

## 2) Authenticate Docker to ECR (local / ephemeral creds)

Replace `<ACCOUNT>`, `<REGION>` and optionally `<AWS_PROFILE>`.

```bash
aws ecr get-login-password --region <REGION> \
  | docker login --username AWS --password-stdin <ACCOUNT>.dkr.ecr.<REGION>.amazonaws.com
```

If using a named profile:

```bash
aws --profile myprofile ecr get-login-password --region <REGION> \
  | docker login --username AWS --password-stdin <ACCOUNT>.dkr.ecr.<REGION>.amazonaws.com
```

---

## 3) Build, tag, push

```bash
# build
docker build -t myapp:1.2.3 .

# tag for ECR (URI format: <account>.dkr.ecr.<region>.amazonaws.com/<repo>:<tag>)
docker tag myapp:1.2.3 123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app:1.2.3

# push
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app:1.2.3
```

If you use manifest lists / multi-arch images, use `docker buildx` and push the manifest.

---

## 4) GitLab CI snippet (recommended: OIDC or assume-role)

Example using **assume-role** (works in most runners). Prefer OIDC in managed runners when available.

```yaml
stages: [build, push]

variables:
  AWS_REGION: "us-east-1"
  ECR_ACCOUNT: "123456789012"
  ECR_REPO: "my-app"
  IMAGE_TAG: "$CI_COMMIT_SHORT_SHA"

before_script:
  - apk add --no-cache python3 py3-pip jq docker-cli  # runner image needs docker client / awscli
  - pip install awscli --upgrade
  # If using assume-role:
  - |
    if [ -n "$ASSUME_ROLE_ARN" ]; then
      CREDS=$(aws sts assume-role --role-arn "$ASSUME_ROLE_ARN" --role-session-name gitlab-ci --duration-seconds 900 --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' --output text)
      export AWS_ACCESS_KEY_ID=$(echo $CREDS | awk '{print $1}')
      export AWS_SECRET_ACCESS_KEY=$(echo $CREDS | awk '{print $2}')
      export AWS_SESSION_TOKEN=$(echo $CREDS | awk '{print $3}')
    fi
  - aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com

build:
  stage: build
  script:
    - docker build -t $ECR_REPO:$IMAGE_TAG .
    - docker tag $ECR_REPO:$IMAGE_TAG $ECR_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
    - docker push $ECR_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
  only:
    - branches
```

If your runner supports OIDC, replace assume-role with OIDC token exchange (preferred—no secrets).

---

## 5) CI best practices

* Use **short-lived credentials** (OIDC or STS assume-role).
* Protect image tags for `latest` and `prod` pushes (use protected branches/tags).
* Scan images on push (ECR image scanning or third-party scanners).
* Use immutable tags (SHA, semantic tags) and avoid `latest` for prod.
* Push multi-arch images with `docker buildx` and `docker buildx push`.

---

## Troubleshooting

* `no basic auth credentials` → Docker not logged in; run `aws ecr get-login-password | docker login ...`.
* `denied: requested access to the resource is denied` → wrong account or repo name, or IAM lacks ECR permissions.
* `repository not found` → create the repo first or check URI.
* Large pushes failing → check network; consider pushing smaller layers or using a CI runner in same region/VPC.

---

## Quick checklist

* [ ] Repo exists (`aws ecr create-repository` if needed)
* [ ] Docker authenticated (`aws ecr get-login-password`)
* [ ] Image tagged to full ECR URI
* [ ] Push succeeded (`docker push`)
* [ ] CI uses OIDC/assume-role; images scanned and tags protected

---

### One-line summary

Log in with `aws ecr get-login-password | docker login --username AWS --password-stdin <account>.dkr.ecr.<region>.amazonaws.com`, tag your image to the ECR URI, then `docker push` — and in CI use short-lived creds (OIDC or assume-role) and protect prod pushes.

---
---

## **Q: How do you exec into a running Docker container?**

### 🧠 **Overview**

You can use the **`docker exec`** command to **open a shell session** inside a running container — just like SSH into a VM — to inspect logs, run commands, or debug applications.

---

### ⚙️ **1️⃣ Basic Syntax**

```bash
docker exec -it <container_name_or_id> <command>
```

| Flag | Description                                |
| ---- | ------------------------------------------ |
| `-i` | Interactive mode (keeps STDIN open).       |
| `-t` | Allocates a pseudo-TTY (for shell access). |

---

### 🧩 **2️⃣ Common Examples**

| **Use Case**                                              | **Command**                     |
| --------------------------------------------------------- | ------------------------------- |
| Open an **interactive shell** (`bash`)                    | `docker exec -it myapp bash`    |
| If the container uses **Alpine** or **busybox** (no bash) | `docker exec -it myapp sh`      |
| Run a **single command** inside container                 | `docker exec myapp ls /app`     |
| Check running **processes**                               | `docker exec myapp ps aux`      |
| View **environment variables**                            | `docker exec myapp env`         |
| Check **container’s IP address**                          | `docker exec myapp hostname -I` |

---

### 🧩 **3️⃣ Identify Container Name/ID**

List running containers first:

```bash
docker ps
```

Example output:

```
CONTAINER ID   IMAGE          COMMAND            STATUS          PORTS         NAMES
e1b2c3d4f5g6   myapp:latest   "python app.py"    Up 2 minutes    8080->80/tcp  myapp
```

Then exec into it:

```bash
docker exec -it myapp bash
```

---

### ⚙️ **4️⃣ Exit the Container**

Type:

```
exit
```

or press
**Ctrl + D**
➡ This returns you to your host shell, the container keeps running.

---

### 🧠 **5️⃣ If Container Has No Shell**

Some minimal images (like `scratch` or `distroless`) don’t include shells.
In those cases:

* You **can’t exec into them** interactively.
* Use sidecar containers or debugging images (like `busybox` or `alpine`) on the same network/namespace:

  ```bash
  docker run -it --network container:<container_name> busybox sh
  ```

  This lets you inspect the same network/filesystem.

---

### ✅ **In short:**

> Use `docker exec -it <container> bash` (or `sh`) to get a shell inside a running container.
> It’s the standard way to **debug or inspect live containers** without restarting them.

---
---

## **Q: What is `.dockerignore` used for?**

### 🧠 **Overview**

A **`.dockerignore`** file tells Docker **which files and directories to exclude** from the **build context** when running `docker build`.
It works just like `.gitignore` — keeping unnecessary files out of your image and speeding up builds.

---

### ⚙️ **Purpose**

| **Goal**                          | **Explanation**                                                              |
| --------------------------------- | ---------------------------------------------------------------------------- |
| 🧹 **Reduce image size**          | Prevents copying unwanted files (e.g., logs, build artifacts, node_modules). |
| ⚡ **Speed up builds**             | Smaller build context → faster upload to Docker daemon.                      |
| 🔒 **Improve security**           | Avoids leaking sensitive files like `.env`, SSH keys, secrets.               |
| 📦 **Prevent cache invalidation** | Changes in ignored files don’t break build cache.                            |

---

### 🧩 **Example `.dockerignore`**

```bash
# Ignore build system files
.git
.gitignore
Dockerfile
.dockerignore

# Node.js example
node_modules
npm-debug.log
yarn.lock
coverage
dist

# Python example
__pycache__/
*.pyc
venv/

# Environment / secrets
.env
*.pem
*.key

# OS files
.DS_Store
Thumbs.db
```

✅ Result:
Only the required app source files and dependencies get sent into the Docker build context.

---

### ⚙️ **How It Works**

1️⃣ When you run `docker build`, Docker sends the **build context** (current directory) to the Docker daemon.
2️⃣ `.dockerignore` filters out matching paths — these never leave your disk.
3️⃣ The remaining files are used for instructions like `COPY` or `ADD`.

Example:

```bash
docker build -t myapp:latest .
```

If `.env` and `.git` are listed in `.dockerignore`, they **won’t be included** in the image or even sent to the daemon.

---

### 🧠 **Best Practices**

✅ Always include `.git`, `.env`, `node_modules`, and temp folders.
✅ Keep `.dockerignore` at the root next to your Dockerfile.
✅ Keep it updated as your project grows.
✅ For CI/CD pipelines, verify it matches your `.gitignore` but keep sensitive files explicitly ignored.

---

### ✅ **In short:**

> The `.dockerignore` file excludes unnecessary or sensitive files from the Docker build context —
> making builds **faster**, **smaller**, and **more secure**.

---
---

## **Q: How do you pass environment variables to Docker containers?**

### 🧠 **Overview**

Environment variables let you **configure container behavior** (e.g., DB credentials, API URLs, runtime mode) without modifying the image.
You can pass them at **runtime**, from **files**, or directly inside a **Dockerfile**.

---

### ⚙️ **1️⃣ Pass via `docker run -e`**

```bash
docker run -d \
  -e ENV=prod \
  -e DB_HOST=db.example.com \
  -p 8080:80 \
  myapp:latest
```

| Flag          | Description                                 |
| ------------- | ------------------------------------------- |
| `-e`          | Pass an environment variable (`KEY=VALUE`). |
| Multiple `-e` | You can pass several variables at once.     |

Check inside container:

```bash
docker exec myapp env
```

---

### ⚙️ **2️⃣ Load from an Environment File**

**Create `.env` file:**

```bash
ENV=staging
DB_USER=admin
DB_PASS=secret123
```

**Run container:**

```bash
docker run --env-file .env myapp:latest
```

✅ Cleaner and reusable for multiple containers.

---

### ⚙️ **3️⃣ Define in Dockerfile (build-time default)**

```dockerfile
FROM node:18-alpine
ENV NODE_ENV=production
ENV PORT=3000
CMD ["npm", "start"]
```

✅ These become default environment variables in all containers based on that image.
They can still be **overridden** at runtime with `-e`.

---

### ⚙️ **4️⃣ Pass from Host Environment**

If you already have variables in your shell:

```bash
export API_KEY=abcd1234
docker run -e API_KEY myapp
```

✅ Docker picks up `$API_KEY` from your host environment.

---

### ⚙️ **5️⃣ Docker Compose (Recommended for Multi-Service)**

**docker-compose.yml**

```yaml
version: "3.9"
services:
  app:
    image: myapp:latest
    ports:
      - "8080:80"
    env_file:
      - .env
    environment:
      - NODE_ENV=production
      - LOG_LEVEL=debug
```

✅ Compose automatically injects `.env` and inline environment variables.

---

### ⚙️ **6️⃣ Verify Environment Variables**

Inside container:

```bash
docker exec -it myapp env
```

Or using `inspect`:

```bash
docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' myapp
```

---

### 🧠 **Best Practices**

✅ Prefer `--env-file` or Compose for maintainability.
✅ Never bake secrets directly into Dockerfile (`ENV DB_PASS=password` ❌).
✅ Use secret managers (AWS Secrets Manager, Vault, Docker secrets) for sensitive data.
✅ Use consistent naming (e.g., `APP_ENV`, `DB_HOST`, `DB_USER`).

---

### ✅ **In short:**

> Pass env vars using `-e`, `--env-file`, or via Docker Compose.
> Example:
>
> ```bash
> docker run -e ENV=prod --env-file .env myapp
> ```
>
> Use `.env` files for config and secret managers for sensitive values.
---
Short answer (2 lines)
Use **volumes** (named volumes or bind mounts) to store data outside the container filesystem so it survives container restart/recreate. For multi-host or production use cases use a network-backed volume (EFS/NFS, cloud block storage, or Kubernetes PVs) and handle backups/permissions explicitly.

---

## Quick checklist

* Use **named volumes** for portability and Docker-managed persistence.
* Use **bind mounts** (`host_dir:/container_dir`) for dev or when you need host files.
* For multi-host or scale-out, use **EFS/NFS/CIFS** or cloud block volumes (EBS, EFS, EFS Access Points).
* Always handle UID/GID and file permissions, and add a backup/restore strategy.

---

## Commands & examples

### 1) Named volume (recommended for persistent data)

```bash
# create volume
docker volume create mydata

# run container using named volume
docker run -d --name mydb -v mydata:/var/lib/mysql mysql:8

# inspect where Docker stores it on the host
docker volume inspect mydata
```

Named volumes are managed by Docker and survive container removal (`docker rm`) unless you explicitly remove the volume (`docker volume rm mydata`).

---

### 2) Bind mount (host directory) — great for dev

```bash
docker run -d \
  --name myapp-dev \
  -v $(pwd)/app_data:/app/data \
  myapp:latest
```

Use bind mounts to see host-side files live (hot-reload). Be careful with permissions and portability.

---

### 3) Docker Compose example (named volume)

```yaml
version: "3.8"
services:
  db:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: example
    volumes:
      - db-data:/var/lib/mysql

volumes:
  db-data:
    driver: local
```

`docker-compose up -d` will create `db-data` and persist it across container restarts/removals.

---

### 4) Backup & restore a volume (tar via temporary container)

```bash
# backup
docker run --rm -v mydata:/data -v $(pwd):/backup busybox \
  sh -c "cd /data && tar czf /backup/mydata.tar.gz ."

# restore
docker run --rm -v mydata:/data -v $(pwd):/backup busybox \
  sh -c "cd /data && tar xzf /backup/mydata.tar.gz"
```

---

### 5) Migrating data to another host

* Export with backup method above, copy archive to new host, restore into a new volume there.

---

## Multi-host / production persistence

* **Single-host**: named volumes or bind mounts are fine.
* **Multi-host / clustered**: use network storage:

  * AWS: **EBS** for single-node stateful or **EFS** for multi-AZ shared volumes.
  * NFS/CIFS for on-prem.
  * Docker plugins (e.g., rexray, portworx) or orchestrator volumes (Kubernetes PVs) for distributed storage.
* For ECS/Fargate: use **EFS** (mount targets + access points). For Kubernetes, use **PersistentVolumes** backed by cloud storage.

---

## Permissions & ownership

Containers often run as a uid/gid — ensure host volume ownership matches or `chown` at container start:

```dockerfile
# in Dockerfile or entrypoint script (runtime)
chown -R 1000:1000 /app/data
exec "$@"
```

Or use Docker `--user` to run container as matching UID.

---

## Tips & gotchas

* **Removing container ≠ removing volume.** `docker rm` doesn't remove named volumes by default. Use `docker rm -v` to remove anonymous volumes tied to container. `docker volume prune` removes unused volumes.
* **Do not rely on ephemeral tmpfs** for persistence — tmpfs is memory-only and lost on stop.
* **Backups are essential** for databases/files. Automate snapshots (EBS/EFS), or use `mysqldump`/database-native backups.
* **Performance**: bind mounts may be slower on some platforms (Docker Desktop on macOS/Windows); consider volume drivers or remote mount.
* **Consistency**: for clustered apps, avoid shared writable volumes unless the filesystem and app support concurrent access (use proper locking or per-node storage + replication).

---

## Example: MySQL with persistent named volume (ready-for-prod quick pattern)

```bash
docker volume create mysql-data

docker run -d --name mysql \
  -e MYSQL_ROOT_PASSWORD=SecretPwd \
  -v mysql-data:/var/lib/mysql \
  mysql:8
```

Then stop/start or recreate the container — the DB files remain in `mysql-data`.

---

### One-line summary

Use Docker **named volumes** (or bind mounts for dev) to persist container data across restarts; for multi-host production use a network-backed volume (EFS/NFS, cloud block) and implement backups, permission fixes, and proper orchestration.

---
---

## **Q: How do you handle container logs in Docker?**

### 🧠 **Overview**

Docker automatically captures **stdout** and **stderr** from containers and stores them using a **logging driver** (default: `json-file`).
You can view, stream, or forward these logs to external systems like ELK, CloudWatch, or Loki.

---

### ⚙️ **1️⃣ View Logs**

| **Command**                           | **Description**                     |
| ------------------------------------- | ----------------------------------- |
| `docker logs <container>`             | Show logs (stdout + stderr).        |
| `docker logs -f <container>`          | Stream logs live (like `tail -f`).  |
| `docker logs --since 10m <container>` | Show logs from the last 10 minutes. |
| `docker logs --tail 100 <container>`  | Show last 100 lines only.           |

**Example:**

```bash
docker logs -f myapp
```

---

### ⚙️ **2️⃣ Default Log Storage**

By default, logs are stored as JSON under:

```
/var/lib/docker/containers/<container-id>/<container-id>-json.log
```

> Each container has its own log file.
> The file can grow large — manage it with rotation options or an external aggregator.

---

### ⚙️ **3️⃣ Configure Log Rotation (important for production)**

Edit `/etc/docker/daemon.json`:

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "3"
  }
}
```

Restart Docker:

```bash
sudo systemctl restart docker
```

✅ Limits each log file to 100 MB, keeps 3 files max (auto-rotates).

---

### ⚙️ **4️⃣ Change Logging Driver**

You can switch the logging backend at **container run time** or **globally**.

#### Example — syslog:

```bash
docker run -d \
  --log-driver=syslog \
  --log-opt syslog-address=udp://192.168.1.10:514 \
  myapp
```

#### Common Drivers:

| **Driver**  | **Description**                             |
| ----------- | ------------------------------------------- |
| `json-file` | Default local log storage (plain JSON).     |
| `journald`  | For systemd-based systems.                  |
| `syslog`    | Send logs to syslog servers.                |
| `awslogs`   | Send logs to AWS CloudWatch.                |
| `gelf`      | Send logs to Graylog or Logstash.           |
| `fluentd`   | Send logs to Fluentd/Fluent Bit collectors. |
| `none`      | Disable logging (use carefully).            |

---

### ⚙️ **5️⃣ Centralized Log Aggregation (recommended)**

For multiple containers or hosts, forward logs to a centralized solution:

| **Tool**                                                  | **Purpose**                              |
| --------------------------------------------------------- | ---------------------------------------- |
| **ELK / EFK** (Elasticsearch + Logstash/Fluentd + Kibana) | Full-featured log analytics.             |
| **AWS CloudWatch**                                        | Managed log aggregation for ECS/EKS.     |
| **Grafana Loki**                                          | Lightweight log storage + visualization. |
| **Fluent Bit / Fluentd**                                  | Collect and forward logs efficiently.    |

**Example (Fluent Bit):**

```bash
docker run -d \
  --log-driver=fluentd \
  --log-opt fluentd-address=localhost:24224 \
  --log-opt tag=docker.myapp \
  myapp
```

---

### ⚙️ **6️⃣ For Docker Compose**

You can configure logging drivers per service:

```yaml
services:
  web:
    image: nginx
    logging:
      driver: "json-file"
      options:
        max-size: "50m"
        max-file: "5"
```

---

### ⚙️ **7️⃣ Application-Level Logging Best Practices**

✅ Log to **stdout/stderr** — not to files inside containers.
✅ Use structured JSON logging (easy to parse).
✅ Don’t log sensitive info.
✅ Add correlation IDs / request IDs for tracing.
✅ Use log rotation and centralized collection for scale.

---

### ✅ **In short:**

> Docker captures logs from `stdout` and `stderr` by default.
> View with `docker logs -f <container>`, configure rotation via `daemon.json`,
> and forward logs to centralized systems like **ELK, CloudWatch, or Loki** for scalable management.

---
---

## **Q: How do you secure Docker containers?**

### 🧠 **Overview**

Docker security means minimizing the **attack surface** at every layer — image, container runtime, host, and network.
The goal: **least privilege**, **isolation**, and **immutability**.

---

### ⚙️ **1️⃣ Secure the Docker Host**

| **Action**                  | **Why it matters**                                                   |
| --------------------------- | -------------------------------------------------------------------- |
| 🔒 Keep Docker & OS updated | Security patches fix known exploits.                                 |
| 🧍‍♂️ Limit root access     | Only trusted users should run Docker commands (Docker runs as root). |
| 🚫 Disable SSH root login   | Prevents host compromise → container compromise.                     |
| 🧱 Use firewall rules       | Limit exposed ports and inter-container traffic.                     |
| 🔍 Enable audit logs        | Track container and image changes.                                   |

---

### ⚙️ **2️⃣ Use Minimal & Trusted Images**

| **Practice**                                                                         | **Description** |
| ------------------------------------------------------------------------------------ | --------------- |
| ✅ Use **official base images** from Docker Hub / verified publishers.                |                 |
| ⚙️ **Pin image versions** (e.g., `nginx:1.25.3-alpine`) to avoid unverified updates. |                 |
| 🧩 Use **Alpine / distroless** images — fewer packages, smaller attack surface.      |                 |
| 🧼 **Scan images** using tools like `docker scan`, Trivy, or Clair.                  |                 |
| 🧹 **Remove build tools** & caches via multi-stage builds.                           |                 |

Example:

```bash
docker scan myapp:latest
```

---

### ⚙️ **3️⃣ Run Containers with Least Privilege**

| **Recommendation**                   | **Example / Command**                       |
| ------------------------------------ | ------------------------------------------- |
| ⚠️ Avoid `--privileged` mode         | `--privileged` = full host access ❌         |
| 👤 Drop root user                    | Use `USER` in Dockerfile: `USER appuser`    |
| 📦 Read-only filesystem              | `--read-only` flag or `tmpfs` for writes    |
| 🔐 Limit capabilities                | `--cap-drop ALL --cap-add NET_BIND_SERVICE` |
| 🚫 Disable host mounts unless needed | Avoid `-v /:/host` patterns                 |
| ⚙️ Set seccomp / AppArmor profiles   | `--security-opt seccomp=default.json`       |

Example:

```bash
docker run -d --read-only --cap-drop ALL --user 1000:1000 myapp
```

---

### ⚙️ **4️⃣ Secure Networking**

| **Action**                                          | **Reason**                      |
| --------------------------------------------------- | ------------------------------- |
| Use **user-defined bridge** networks (not default). | Better isolation, internal DNS. |
| Restrict container-to-container traffic.            | Prevent lateral movement.       |
| Use **TLS** for exposed endpoints.                  | Encrypt in-transit data.        |
| Don’t expose sensitive ports with `-p 0.0.0.0`.     | Use internal-only networking.   |

Example:

```bash
docker network create secure-net
docker run --network secure-net myapp
```

---

### ⚙️ **5️⃣ Manage Secrets Securely**

| **Best Practice**                                                                | **Description** |
| -------------------------------------------------------------------------------- | --------------- |
| ❌ Don’t bake secrets into images (`ENV DB_PASS=...`).                            |                 |
| ✅ Use Docker **secrets** or environment variables injected securely.             |                 |
| ✅ Integrate with **AWS Secrets Manager**, **Vault**, or **SSM Parameter Store**. |                 |
| ✅ Use `--env-file` but never commit `.env` to Git.                               |                 |

---

### ⚙️ **6️⃣ Apply Resource Limits**

Prevent DoS by constraining resource usage:

```bash
docker run -m 512m --cpus=1 myapp
```

| Flag              | Description                 |
| ----------------- | --------------------------- |
| `-m` / `--memory` | Memory limit                |
| `--cpus`          | CPU quota                   |
| `--pids-limit`    | Max processes per container |

---

### ⚙️ **7️⃣ Regular Security Scans & Compliance**

| **Tool**                      | **Purpose**                          |
| ----------------------------- | ------------------------------------ |
| **Trivy / Grype**             | Image vulnerability scanning.        |
| **Docker Bench for Security** | Audit Docker daemon & host configs.  |
| **Hadolint**                  | Lint Dockerfiles for best practices. |

Example:

```bash
docker run --rm aquasec/trivy image myapp:latest
```

---

### ⚙️ **8️⃣ Use Signed & Verified Images**

* Enable **Docker Content Trust (DCT)**:

  ```bash
  export DOCKER_CONTENT_TRUST=1
  ```

  Ensures only signed images are pulled/run.

* Use **Notary v2 / cosign** for image signing in CI/CD pipelines.

---

### ⚙️ **9️⃣ Secure CI/CD Pipeline**

* Build in **isolated runners**, not shared agents.
* Use **short-lived credentials** (OIDC, STS) for registry push/pull.
* Scan images pre-deploy (fail build if CVEs found).
* Sign images after scan and before push.

---

### ⚙️ **🔟 Monitor Runtime & Containers**

| **Tool**                   | **Use**                                           |
| -------------------------- | ------------------------------------------------- |
| Falco                      | Detect runtime anomalies (syscalls, file access). |
| Sysdig Secure              | Runtime threat detection.                         |
| AWS GuardDuty / CloudTrail | Cloud-level monitoring for ECR/ECS.               |

---

### ✅ **In short:**

> Secure Docker by hardening **host**, using **minimal images**, enforcing **least privilege**, isolating **networks**, managing **secrets properly**, and enabling **resource & runtime security**.
> Combine **image scanning + runtime monitoring** for full lifecycle protection.

---
---

## **Q: What’s the difference between a Bind Mount and a Volume in Docker?**

### 🧠 **Overview**

Both **bind mounts** and **volumes** let containers persist data beyond their lifecycle,
but they differ in **management, location, portability, and performance**.

---

### ⚙️ **Comparison Table**

| **Feature**                | **Bind Mount**                                                 | **Volume**                                                      |
| -------------------------- | -------------------------------------------------------------- | --------------------------------------------------------------- |
| **Definition**             | Maps a **host directory or file** directly into the container. | Managed storage created and controlled by **Docker**.           |
| **Path Location**          | Any path on host (e.g. `/home/user/data`).                     | Stored under Docker-managed path: `/var/lib/docker/volumes/...` |
| **Created By**             | User manually specifies full path.                             | Docker automatically manages (via `docker volume create`).      |
| **Portability**            | Not portable — depends on host directory path.                 | Portable — Docker can reattach volume across hosts.             |
| **Backup & Restore**       | Manual (since it's on the host).                               | Easier — can use `docker volume` commands.                      |
| **Isolation**              | Tight coupling to host filesystem.                             | Fully abstracted — safer and cleaner.                           |
| **When Container Removed** | Data persists, but depends on host path.                       | Data persists until volume is explicitly deleted.               |
| **Use Case**               | Dev environments (live code sync, debugging).                  | Production data persistence (DBs, stateful apps).               |
| **Performance (Linux)**    | Slightly slower (depends on filesystem type).                  | Optimized by Docker (uses storage drivers).                     |
| **Security**               | Risky — direct access to host FS.                              | Safer — Docker enforces access isolation.                       |

---

### 🧩 **Example: Bind Mount**

```bash
docker run -d \
  -v /home/vasu/app-data:/usr/src/app/data \
  myapp:latest
```

✅ Directly mounts a host directory (`/home/vasu/app-data`) into the container path.

* Great for **development** — edit code locally, auto-reflect inside container.
* Not ideal for **production** (tight host coupling).

---

### 🧩 **Example: Volume**

```bash
# create a named volume
docker volume create appdata

# use the volume
docker run -d \
  -v appdata:/usr/src/app/data \
  myapp:latest
```

✅ Data stored in `/var/lib/docker/volumes/appdata/_data`.

* Safe, managed, and reusable across containers.
* Preferred for **databases**, **logs**, or **persistent state**.

---

### ⚙️ **Inspect Volumes**

```bash
docker volume ls
docker volume inspect appdata
```

---

### ⚙️ **Docker Compose Example**

```yaml
services:
  db:
    image: mysql:8
    volumes:
      - dbdata:/var/lib/mysql

volumes:
  dbdata:
```

✅ Automatically creates and mounts a **named volume** (`dbdata`).

---

### 🧠 **Best Practices**

✅ Use **bind mounts** for development — quick, flexible, host-coupled.
✅ Use **volumes** for production — managed, secure, and easy to back up.
✅ Never mount critical host directories (like `/`, `/etc`, `/var/lib/docker`) as bind mounts.
✅ Use named volumes with databases to avoid accidental data loss.

---

### ✅ **In short:**

> **Bind Mount:** Direct link to a **host path** — fast but less portable.
> **Volume:** **Docker-managed storage**, safer and ideal for production persistence.

---
---

## **Q: How do you clean unused Docker resources (images, containers, volumes, networks)?**

### 🧠 **Overview**

Over time, Docker accumulates **stopped containers**, **dangling images**, **unused volumes**, and **networks** — all consuming disk space.
Docker provides simple commands to **prune** (clean) these safely.

---

### ⚙️ **1️⃣ Clean Up Stopped Containers**

```bash
docker container prune
```

🧹 Removes all stopped containers.

Optional prompt bypass:

```bash
docker container prune -f
```

---

### ⚙️ **2️⃣ Remove Unused Images**

```bash
docker image prune
```

Removes **dangling images** (not tagged or used by any container).

To remove **all unused images**:

```bash
docker image prune -a
```

⚠️ This deletes all images not linked to any running/stopped container.

---

### ⚙️ **3️⃣ Remove Unused Volumes**

```bash
docker volume prune
```

Removes **volumes not used by any container**.
💡 Safe for space cleanup — doesn’t affect active containers.

---

### ⚙️ **4️⃣ Remove Unused Networks**

```bash
docker network prune
```

Removes **user-defined networks** not connected to any container.
(Default `bridge`, `host`, and `none` networks are preserved.)

---

### ⚙️ **5️⃣ Full Cleanup in One Command**

```bash
docker system prune
```

Removes:

* Stopped containers
* Unused networks
* Dangling images
* Build cache

To include **unused images and volumes**:

```bash
docker system prune -a --volumes
```

✅ Example output:

```
Total reclaimed space: 4.2GB
```

---

### ⚙️ **6️⃣ View Disk Usage Before Cleaning**

```bash
docker system df
```

Shows:

* Container space
* Image space
* Local volumes
* Build cache

---

### ⚙️ **7️⃣ Remove Specific Resources (manually)**

| Resource  | Command                            |
| --------- | ---------------------------------- |
| Container | `docker rm <container_id>`         |
| Image     | `docker rmi <image_id>`            |
| Volume    | `docker volume rm <volume_name>`   |
| Network   | `docker network rm <network_name>` |

---

### 🧠 **8️⃣ Automate Periodic Cleanup (optional)**

Schedule via **cron** or **systemd timer**:

```bash
0 3 * * 0 /usr/bin/docker system prune -af --volumes > /var/log/docker-prune.log 2>&1
```

✅ Runs weekly cleanup every Sunday at 3 AM.

---

### ⚠️ **Cleanup Safety Notes**

* `docker system prune -a` removes **all unused images**, even if you’ll rebuild them later.
* Never run prune on **production nodes** without understanding what’s active.
* Use `docker system df` before pruning.
* Always confirm volume names before `volume prune` — data loss risk.

---

### ✅ **In short:**

> Use `docker system prune -a --volumes` to remove **all unused Docker data** (containers, images, networks, volumes).
>
> For targeted cleanup:
>
> * Containers → `docker container prune`
> * Images → `docker image prune -a`
> * Volumes → `docker volume prune`
> * Networks → `docker network prune`

---
---

## **Q: How do you link Docker containers together?**

### 🧠 **Overview**

You can link containers so they **communicate over a private network**.
The modern, recommended way is to use **user-defined bridge networks** (not the old `--link` flag, which is deprecated).

---

### ⚙️ **1️⃣ Modern Method — Use a User-Defined Bridge Network**

Docker automatically creates DNS entries for containers on the same network —
so you can connect by **container name** instead of IP.

#### **Step 1: Create a custom network**

```bash
docker network create mynet
```

#### **Step 2: Run containers on that network**

```bash
# Run database container
docker run -d --name db --network mynet mysql:8

# Run app container and connect to db by name
docker run -d --name web --network mynet -e DB_HOST=db myapp:latest
```

✅ Now, inside `web`:

```bash
ping db
```

and environment variable `DB_HOST=db` will resolve to the container’s IP automatically.

---

### ⚙️ **2️⃣ Docker Compose (Recommended for Multi-Container Apps)**

Docker Compose automatically creates a **shared network** for all services in a file.

```yaml
version: "3.9"
services:
  db:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: root
  app:
    image: myapp:latest
    environment:
      DB_HOST: db
    depends_on:
      - db
```

Run:

```bash
docker compose up -d
```

✅ Both containers share an internal network — `app` can reach `db` at hostname `db`.

---

### ⚙️ **3️⃣ Legacy Method (Deprecated) — Using `--link`**

```bash
docker run -d --name db mysql:8
docker run -d --name web --link db:db myapp:latest
```

This:

* Injects `db`'s IP into `/etc/hosts` inside `web`.
* Also sets env vars like `DB_PORT_3306_TCP`.

⚠️ **Deprecated:** doesn’t support dynamic IP updates, limited scope, and no DNS resolution — use **user-defined networks** instead.

---

### ⚙️ **4️⃣ Check Connectivity Between Linked Containers**

Inside the app container:

```bash
docker exec -it web ping db
```

Or test DB connection:

```bash
docker exec -it web mysql -h db -uroot -p
```

---

### 🧠 **5️⃣ View Network Details**

```bash
docker network ls
docker network inspect mynet
```

Shows connected containers and IPs.

---

### ✅ **Best Practices**

✅ Use **user-defined networks** (default `bridge` is shared and less secure).
✅ Use **Compose** for multi-service applications.
✅ Avoid hardcoding IPs — always use **container names** as DNS hosts.
✅ Keep sensitive containers (like DBs) in **private networks** (no `-p` exposed).

---

### ✅ **In short:**

> To link containers, use a **user-defined bridge network** or **Docker Compose** —
> containers on the same network can communicate via **container names** (built-in DNS),
> replacing the old `--link` approach.

---
---

## **Q: What’s the difference between `docker-compose` and `docker run`?**

### 🧠 **Overview**

Both are used to run containers —
but `docker run` launches **a single container manually**,
while `docker-compose` orchestrates **multi-container applications** declaratively using a **YAML file**.

---

### ⚙️ **Comparison Table**

| **Aspect**                | **`docker run`**                         | **`docker-compose`**                                  |
| ------------------------- | ---------------------------------------- | ----------------------------------------------------- |
| **Purpose**               | Run one container from the command line. | Define and run multi-container apps.                  |
| **Configuration**         | CLI flags (`-p`, `-v`, `-e`, etc.).      | YAML file (`docker-compose.yml`).                     |
| **Complexity**            | Simple, manual, one container at a time. | Automates multiple containers, networks, and volumes. |
| **Networking**            | Must manually use `--network`.           | Auto-creates a shared network for all services.       |
| **Environment variables** | Passed with `-e` or `--env-file`.        | Declared under `environment:` or `env_file:` in YAML. |
| **Scaling**               | Must run multiple `docker run` commands. | Use `docker-compose up --scale service=n`.            |
| **Reproducibility**       | Harder (manual CLI repetition).          | Fully reproducible from one file.                     |
| **Logs**                  | `docker logs <container>` per container. | `docker compose logs` for all services combined.      |
| **Lifecycle management**  | No built-in orchestration.               | Supports `up`, `down`, `restart`, `ps`, `logs`.       |
| **Best suited for**       | Simple testing or single container apps. | Multi-container stacks (app + DB + cache, etc.).      |

---

### 🧩 **Example 1: Using `docker run`**

```bash
# Run backend API
docker run -d --name api -p 8080:8080 -e ENV=prod myapp:latest

# Run database
docker run -d --name db -e MYSQL_ROOT_PASSWORD=secret mysql:8
```

You must manually create networks and link them if needed.

---

### 🧩 **Example 2: Using `docker-compose.yml`**

```yaml
version: "3.9"
services:
  api:
    image: myapp:latest
    ports:
      - "8080:8080"
    environment:
      ENV: prod
    depends_on:
      - db

  db:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: secret
```

Then:

```bash
docker compose up -d
```

✅ Automatically creates network, starts both containers, and links them.

---

### ⚙️ **Key Commands**

| **`docker run` Equivalent**   | **`docker compose` Alternative**     |
| ----------------------------- | ------------------------------------ |
| `docker run`                  | `docker compose up`                  |
| `docker stop`                 | `docker compose down`                |
| `docker ps`                   | `docker compose ps`                  |
| `docker logs <name>`          | `docker compose logs`                |
| `docker exec -it <name> bash` | `docker compose exec <service> bash` |

---

### 🧠 **Best Practices**

✅ Use `docker run` for quick one-off containers (debugging, testing).
✅ Use `docker-compose` for applications requiring multiple services (API + DB + Cache + Queue).
✅ Keep configuration in version control (`docker-compose.yml`).
✅ In CI/CD, use Compose to bring up full integration stacks easily.

---

### ✅ **In short:**

> **`docker run`** = manual, single-container CLI command.
> **`docker-compose`** = YAML-based, multi-container orchestration tool — automates networking, dependencies, and lifecycle with one command.

---
Perfect 🔥 — here’s a **complete, interview-ready Docker Q&A set** tailored for **DevOps and Cloud Engineer roles**, focusing on **real-world, production-level concepts** (not just basics).
Answers are concise (2–3 lines), practical, and include short examples or commands.

---

## 🟢 **Docker Basics**

| **Question**                                       | **Answer (Concise & Practical)**                                                                                                                              |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1. What is Docker?**                             | Docker is a containerization platform that packages apps with dependencies into lightweight, portable containers. It ensures consistency across environments. |
| **2. Difference between VM and Docker container?** | VMs virtualize hardware; Docker virtualizes OS. Containers share the host kernel and are faster, smaller, and more portable.                                  |
| **3. What is a Docker image vs container?**        | An **image** is a read-only template (blueprint). A **container** is a running instance of an image.                                                          |
| **4. What is a Dockerfile?**                       | A script of instructions to build a Docker image. Example: <br>`FROM nginx:alpine` → base image, `COPY . /usr/share/nginx/html` → add files.                  |
| **5. Common Dockerfile commands?**                 | `FROM`, `RUN`, `COPY`, `ADD`, `EXPOSE`, `ENV`, `CMD`, `ENTRYPOINT`, `WORKDIR`.                                                                                |
| **6. How to build and run an image?**              | `bash docker build -t myapp:v1 .  docker run -d -p 8080:80 myapp:v1 `                                                                                         |
| **7. How to check running containers?**            | `docker ps` (active), `docker ps -a` (all).                                                                                                                   |
| **8. How to stop/remove containers and images?**   | `bash docker stop <id> docker rm <id> docker rmi <image> `                                                                                                    |
| **9. What are Docker volumes?**                    | Volumes persist container data on the host. Example: `docker run -v /data:/var/lib/mysql mysql`.                                                              |
| **10. What is Docker Hub?**                        | A public registry to store and share Docker images. You can also use private registries like AWS ECR or Nexus.                                                |

---

## 🟡 **Intermediate / Practical**

| **Question**                                                        | **Answer (Concise & Practical)**                                                                                                             |                                                                                           |
| ------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| **11. What’s the difference between COPY and ADD in Dockerfile?**   | `COPY` is for static files. `ADD` can also extract tar files or fetch remote URLs. Prefer `COPY` for clarity.                                |                                                                                           |
| **12. What is the difference between CMD and ENTRYPOINT?**          | - `CMD`: default command (can be overridden).<br>- `ENTRYPOINT`: fixed executable (arguments appended).                                      |                                                                                           |
| **13. How to reduce Docker image size?**                            | Use minimal base images (`alpine`), multi-stage builds, and clean up temp files with `RUN apt-get clean`.                                    |                                                                                           |
| **14. What is multi-stage build?**                                  | Technique to build and copy only needed artifacts to the final image. Example: build app in one stage, copy binary to a lightweight runtime. |                                                                                           |
| **15. What are Docker networks?**                                   | Networks let containers communicate. Types: bridge (default), host, none, and overlay (for Swarm/K8s).                                       |                                                                                           |
| **16. How to inspect container details (IP, env, mounts)?**         | `docker inspect <container_id>`                                                                                                              |                                                                                           |
| **17. How to log in and push to private registry (e.g., AWS ECR)?** | ```bash aws ecr get-login-password                                                                                                           | docker login --username AWS --password-stdin <ECR_URI> docker push <ECR_URI>/myapp:v1 ``` |
| **18. How to exec into a running container?**                       | `docker exec -it <container_id> /bin/bash`                                                                                                   |                                                                                           |
| **19. What is `.dockerignore` used for?**                           | Similar to `.gitignore`; excludes files from build context to reduce image size.                                                             |                                                                                           |
| **20. How to pass environment variables to containers?**            | `bash docker run -e ENV=prod -e DEBUG=false myapp ` or define in `ENV` inside Dockerfile.                                                    |                                                                                           |

---

## 🔵 **Advanced / Production-Level**

| **Question**                                                             | **Answer (Concise & Practical)**                                                                                                                  |
| ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| **21. How to persist data between container restarts?**                  | Use named volumes or bind mounts. Example: `docker run -v dbdata:/var/lib/mysql mysql`.                                                           |
| **22. How do you handle container logs?**                                | Use `docker logs <id>` or configure log drivers (e.g., `awslogs`, `fluentd`, `json-file`). For production — centralize via ELK/CloudWatch.        |
| **23. How do you secure Docker containers?**                             | Use non-root users, minimal images, scan with `trivy`, sign images, enable seccomp/apparmor, limit resources (`--memory`, `--cpus`).              |
| **24. Difference between bind mount and volume?**                        | - **Bind mount:** host path → container path.<br>- **Volume:** managed by Docker under `/var/lib/docker/volumes`. Volumes are portable and safer. |
| **25. How do you clean unused Docker resources?**                        | `docker system prune -a` → removes stopped containers, unused images, and networks.                                                               |
| **26. How to link containers together?**                                 | Use user-defined bridge networks or Docker Compose service names for DNS resolution.                                                              |
| **27. What’s the difference between `docker-compose` and `docker run`?** | `docker-compose` manages multi-container apps via YAML, whereas `docker run` runs one container at a time.                                        |
| **28. What’s inside a Docker image (layers)?**                           | Each Dockerfile instruction creates a read-only **layer**. Layers are cached and reused to optimize builds.                                       |
| **29. How do you scan Docker images for vulnerabilities?**               | Use `docker scan <image>` or third-party tools like **Trivy**, **Grype**, or **Anchore**.                                                         |
| **30. How to limit container resources (CPU, memory)?**                  | `bash docker run --memory=512m --cpus=1 nginx ` — ensures containers don’t consume all host resources.                                            |

---

## ⚙️ **Real-World Scenarios**

| **Scenario**                               | **Best Practice / Solution**                                                 |
| ------------------------------------------ | ---------------------------------------------------------------------------- |
| App not reflecting new code changes?       | Ensure image rebuild (`docker build --no-cache`) and container restart.      |
| Container crashes repeatedly?              | Check logs with `docker logs <id>`; verify `CMD/ENTRYPOINT` correctness.     |
| Need multiple services (DB + App + Redis)? | Use **Docker Compose** with a shared network.                                |
| Need CI/CD integration?                    | Use Docker in Jenkins/GitLab pipelines to build → push → deploy via ECR/K8s. |
| Large image size issue?                    | Switch to `alpine` base image or use multi-stage builds.                     |

---

## 🧠 **Bonus: Docker Compose Basics**

| **Command**              | **Purpose**                         |
| ------------------------ | ----------------------------------- |
| `docker-compose up -d`   | Start all services in detached mode |
| `docker-compose down`    | Stop and remove containers/networks |
| `docker-compose ps`      | List running services               |
| `docker-compose logs -f` | Follow container logs               |
| `docker-compose build`   | Rebuild service images              |

Example `docker-compose.yml`:

```yaml
version: '3'
services:
  web:
    image: nginx
    ports:
      - "8080:80"
  db:
    image: mysql
    environment:
      MYSQL_ROOT_PASSWORD: example
```

---

## 🚀 **Quick Summary**

| **Concept**    | **Key Idea**                                    |
| -------------- | ----------------------------------------------- |
| **Dockerfile** | Blueprint to build container images             |
| **Image**      | Immutable, reusable template                    |
| **Container**  | Running instance of an image                    |
| **Volume**     | Persistent data storage                         |
| **Network**    | Enables container communication                 |
| **Compose**    | Defines multi-container apps                    |
| **Registry**   | Stores and distributes images (Hub, ECR, Nexus) |

---

Would you like me to generate a **formatted Markdown version (README.md)** of these Docker Q&As with code blocks and downloadable link (like your CDK one)?

---
Short answer (2 lines)
Scan images with a vulnerability scanner (Trivy/Grype/docker scan), generate an SBOM (syft), fail CI on high/critical hits, and automate fixes (dependabot/renovate, rebuild with patched base). Run scans locally, in CI, and before pushing to registries.

---

## Practical checklist

* Choose a scanner: **Trivy**, **Grype**, or `docker scan` (Snyk-backed) are simplest to adopt.
* Generate an **SBOM** (Syft) for audit/compliance.
* Run scans **in CI** (fail on configurable severities).
* Block/policy-enforce vulnerable images (registry policies, admission controllers).
* Automate upgrades (Dependabot/Renovate) and rebuild images ASAP.

---

## Tools & one-line commands

* **Trivy** (fast, popular)

```bash
# quick report (local)
trivy image myorg/myapp:1.2.3

# fail on HIGH/CRITICAL and exit non-zero
trivy image --severity HIGH,CRITICAL --exit-code 1 myorg/myapp:1.2.3

# save JSON report
trivy image --format json -o trivy-report.json myorg/myapp:1.2.3
```

* **Grype**

```bash
grype myorg/myapp:1.2.3
grype myorg/myapp:1.2.3 -o json > grype-report.json
```

* **Docker Scan** (Snyk-backed; requires Docker Desktop / Docker CLI login)

```bash
docker scan myorg/myapp:1.2.3
```

* **SBOM (Syft)** — generate Software Bill of Materials

```bash
syft myorg/myapp:1.2.3 -o json > sbom.json
```

* **Optional**: `anchore` / `clair` for on-prem scanning or deeper policy engines.

---

## Example — GitLab CI job (Trivy)

```yaml
stages: [build, scan, push]

scan_image:
  image: aquasec/trivy:latest
  stage: scan
  variables:
    IMAGE: "$CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA"
  script:
    - docker pull $IMAGE || true
    - trivy image --format json --output trivy-report.json --severity HIGH,CRITICAL $IMAGE || true
    - cat trivy-report.json
    # Fail pipeline if any HIGH/CRITICAL found (exit code 1 triggers job failure)
    - trivy image --severity HIGH,CRITICAL --exit-code 1 $IMAGE
  only:
    - branches
```

Notes: run scan after build or after pulling from registry; use `--exit-code` to enforce policy.

---

## Where in the pipeline to scan

* **Build stage**: scan the image you just built (quick feedback to dev).
* **Pre-push / registry**: scan before pushing to production registry.
* **Post-push**: registry-level scans & image promotion gating.
* **Runtime**: complement with runtime detection (Falco, Sysdig).

---

## Remediation workflow

1. Review report → identify vulnerable packages and CVEs.
2. If vulnerability is in your app dependency, bump the dependency and rebuild.
3. If in base image, upgrade base (e.g., `node:18-alpine` → newer patch) or switch to a smaller/maintained base.
4. If no fix exists, apply mitigations (reduce capability, disable feature, restrict network).
5. Regenerate SBOM + re-scan, then redeploy.

---

## Best practices

* Fail CI for **HIGH/CRITICAL** by default; WARN for MEDIUM/LOW.
* Pin base image versions (avoid floating `latest`) and track upstream CVEs.
* Automate dependency updates (Dependabot/Renovate) and rebuild images.
* Generate and store **SBOMs** for every image build.
* Sign images (`cosign`) after scanning; verify signatures in deploy pipelines.
* Enforce registry/policy gates (block unscanned or vulnerable images).
* Run scheduled full scans of registry images (nightly) to catch new CVEs.

---

## Quick remediation tips

* `docker history` / `dive` to find offending layer/files.
* Re-order Dockerfile to maximize cache for dependencies, making upgrades/rebuilds easier.
* Prefer minimal, frequently-patched base images (Alpine/distroless/scratch where possible).
* If an old package is unfixable, consider multi-stage rebuild that removes that package or vendor a patched binary.

---

If you want, I can:

* produce a ready-to-drop **GitLab CI** snippet that scans, generates SBOM, uploads reports as artifacts, and fails on severity — tailored to your existing pipeline (give me your pipeline stages and preferred severity rules).
---
---

## **Q: How do you limit container resources (CPU, Memory, etc.)?**

### 🧠 **Overview**

Docker lets you **throttle CPU, memory, and process limits** to prevent containers from overusing host resources — using **cgroups (control groups)** under the hood.
You can define these limits when running containers or inside Compose/Kubernetes configs.

---

### ⚙️ **1️⃣ Limit Memory Usage**

```bash
docker run -d \
  --name myapp \
  -m 512m \
  --memory-swap 1g \
  myapp:latest
```

| **Option**             | **Description**                                             |
| ---------------------- | ----------------------------------------------------------- |
| `-m`, `--memory`       | Max memory container can use.                               |
| `--memory-swap`        | Total memory + swap allowed (e.g., 512m RAM + 512m swap).   |
| `--memory-reservation` | Soft limit (container can exceed if free memory available). |

**Example:**

* `-m 512m --memory-swap 1g` → container gets 512 MB RAM, can swap up to total 1 GB.
* `--memory-swap 512m` → disables swap (strict limit).

✅ If memory limit exceeded → OOM (Out Of Memory) → container killed and restarted (if managed by Compose/K8s).

---

### ⚙️ **2️⃣ Limit CPU Usage**

```bash
docker run -d \
  --cpus="1.5" \
  myapp:latest
```

| **Option**            | **Description**                          |
| --------------------- | ---------------------------------------- |
| `--cpus="1.5"`        | Restrict CPU to 1.5 cores.               |
| `--cpu-shares`        | Relative CPU weight (e.g., 512 vs 1024). |
| `--cpuset-cpus="0,1"` | Bind container to specific cores.        |

**Example:**

```bash
docker run -d --cpus=0.5 myapp   # uses 50% of one core
docker run -d --cpuset-cpus="1,2" myapp  # pinned to CPU cores 1 & 2
```

---

### ⚙️ **3️⃣ Limit PIDs (Processes)**

```bash
docker run --pids-limit=100 myapp
```

Prevents fork bombs or runaway processes consuming all host PIDs.

---

### ⚙️ **4️⃣ Disk I/O Limits (optional)**

```bash
docker run \
  --device-read-bps /dev/sda:10mb \
  --device-write-bps /dev/sda:5mb \
  myapp
```

Limits read/write speed per device.

---

### ⚙️ **5️⃣ Using Docker Compose**

```yaml
version: "3.9"
services:
  app:
    image: myapp:latest
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
        reservations:
          cpus: '0.5'
          memory: 256M
```

> ⚠️ Note: `deploy.resources` works in **Docker Swarm**.
> For standalone Compose, use `mem_limit` and `cpus`:

```yaml
services:
  app:
    image: myapp
    mem_limit: 512m
    cpus: 1.5
```

---

### ⚙️ **6️⃣ Check Resource Usage**

```bash
docker stats
```

Output:

```
CONTAINER ID   NAME     CPU %   MEM USAGE / LIMIT   MEM %   NET I/O   BLOCK I/O
a1b2c3d4e5f6   myapp    75.2%   230MiB / 512MiB     44.9%   12MB / 8MB   0B / 0B
```

---

### ⚙️ **7️⃣ Best Practices**

✅ Always set both memory **and** CPU limits for predictable performance.
✅ Use `--memory-reservation` for soft limits in shared environments.
✅ Tune limits based on load testing, not guesses.
✅ Combine limits with **healthchecks** to restart unhealthy containers after OOM.
✅ For production, monitor usage via **Prometheus + cAdvisor** or **Grafana** dashboards.

---

### ✅ **In short:**

> Limit memory using `-m`, CPUs using `--cpus`, and PIDs using `--pids-limit`.
> Example:
>
> ```bash
> docker run -d -m 512m --cpus=1 myapp
> ```
>
> Prevents one container from starving others — a key part of **resource isolation & stability**.

---
### Short answer (1–2 lines)

Most often it's a **build / cache / mount** issue: the container is still running an old image or a host bind mount is hiding the new files. Rebuild the image, confirm the running container’s image, and check for bind-mounts or cache layers.

---

## Quick troubleshooting checklist (ordered, actionable)

1. **Check container logs (fast hint)**

   * `docker logs -f <container>` — look for startup errors or evidence of old code running.

2. **Confirm which image the container is using**

   * `docker ps --format "table {{.Names}}\t{{.Image}}\t{{.ID}}"`
   * If image tag is `latest` or a mutable tag, the running container may still reference an old image.

3. **Rebuild and restart (local single-container)**

   * `docker build -t myapp:dev .`
   * `docker stop myapp && docker rm myapp`
   * `docker run -d --name myapp -p 3000:3000 myapp:dev`

4. **If using Docker Compose**

   * Rebuild without cache and restart:

     * `docker compose build --no-cache`
     * `docker compose up -d --force-recreate`
   * Or fully tear down then up:

     * `docker compose down --volumes` (careful: drops volumes)
     * `docker compose up -d --build`

5. **Check for bind-mounts shadowing image files**

   * If you mount host dir into container (dev mode), the container shows host files, not image contents:

     * `docker inspect <container> --format '{{json .Mounts}}' | jq`
   * If present, update files on host or remove the mount to use built image.

6. **Inspect image layers / cache issues**

   * Use `docker history myapp:tag` and `dive myapp:tag` to find which layer contains your code.
   * Ensure you COPY sources **after** installing deps to preserve cache:

     * Good pattern:

       ```dockerfile
       COPY package*.json ./
       RUN npm ci
       COPY . .
       ```

7. **Ensure build context includes the files**

   * Build context is the `.` folder you pass to `docker build`. Missing files in context → not copied into image.
   * Check `.dockerignore` isn’t excluding your source.

8. **Check entrypoint / command**

   * `docker inspect <container> --format '{{.Config.Cmd}} {{.Config.Entrypoint}}'`
   * Maybe container runs a different file or a server that doesn’t auto-reload.

9. **If using volumes for persistent data (DB/uploads)**

   * Host volume may contain old assets; update or remove volume if you expect new files to appear from the image.

10. **Browser / client caching**

    * For web frontends, hard-refresh or check network tab. Also ensure static assets weren’t cached or fingerprinted.

11. **CI/CD or registry gotcha**

    * If pushing to registry: ensure you pushed the new tag and the runtime pulls that exact tag.
    * In Kubernetes/ECS, set imagePullPolicy to `Always` or use immutable tags (SHA) and restart the pod/service.

12. **Force cleanup if you suspect stale images/containers**

    * `docker stop $(docker ps -q)`
      `docker rm $(docker ps -aq)`
      `docker rmi $(docker images -q)`
      (Use carefully—this removes everything on the host.)

13. **Quick in-container sanity check**

    * `docker exec -it <container> sh` (or `bash`) then inspect files, `cat` version file, run `ls -la` of app dir to confirm code.

---

## Useful commands summary

* Show running containers: `docker ps`
* Show images: `docker images`
* Rebuild & run:
  `docker build -t myapp:dev . && docker run -d --name myapp myapp:dev`
* Compose rebuild: `docker compose up -d --build --force-recreate`
* Inspect mounts: `docker inspect <container> --format '{{json .Mounts}}' | jq`
* Inspect entrypoint/cmd: `docker inspect <container> --format '{{.Config.Entrypoint}} {{.Config.Cmd}}'`
* Clean build cache: `docker builder prune` / `docker system prune -a` (careful)

---

## Common root causes (one-liners)

* Forgot to rebuild image after code change.
* Container running an old image/tag (didn’t recreate).
* Host bind-mount hides image files (dev mode).
* `.dockerignore` excluded your code from build context.
* Entrypoint runs precompiled assets, not source (you updated source but didn’t rebuild assets).
* CI pushed image with same tag but runtime pulled cached version (use immutable tags or `Always` pull).
* Browser caching static assets.

---

If you tell me: your runtime (Docker Compose / ECS / Kubernetes), the commands you use to build/deploy, and whether you use bind-mounts, I’ll give the exact commands and a minimal checklist to fix it right away.

---
Short interview answer (2 lines)
Treat repeated crashes as a classic 3-step loop: **observe → isolate → fix**. Start by checking `docker logs` and `docker inspect` (health, restart policy, OOM), run the container interactively to reproduce, then apply fixes (resource limits, dependency fixes, entrypoint, permissions, or code bug) and add proper healthchecks/restart policies.

---

## Quick actionable troubleshooting checklist (run these now)

1. **See why it crashed (logs)**

```bash
docker logs --tail 200 --timestamps <container>        # recent logs
docker logs -f <container>                            # follow live
```

2. **Inspect container metadata (restart policy, health, exit code)**

```bash
docker inspect <container> --format '{{json .State}}' | jq
# or check specific fields
docker inspect -f 'ExitCode={{.State.ExitCode}} Status={{.State.Status}} Reason={{.State.Error}} RestartCount={{.RestartCount}}' <container>
docker inspect -f '{{json .State.Health}}' <container>  # if healthcheck present
```

3. **Check host-level events and crashes**

```bash
journalctl -u docker.service --since "10m"      # docker daemon errors (Linux)
dmesg | tail -n 50                               # OOM killer notices
```

4. **Check OOM / resource issues & live metrics**

```bash
docker stats --no-stream <container>             # CPU / mem usage
docker stats                                       # monitor all
# Check if kernel OOM killed process: look for "Killed process" in dmesg/journalctl
```

5. **Inspect mounts, env, entrypoint — common causes**

```bash
docker inspect --format '{{json .Config}}' <container> | jq
docker inspect --format '{{json .Mounts}}' <container> | jq
```

* Missing env vars, wrong ENTRYPOINT/CMD, or a mount hiding app files are common.

6. **Reproduce interactively to debug**

```bash
# Run image with same command but interactive shell to poke around
docker run --rm -it --entrypoint sh <image>   # or bash if available
# Or override CMD to start app manually and see immediate error
docker run --rm -it <image> sh -c "your-start-cmd"
```

7. **Check image health / integrity**

```bash
docker image ls
docker history <image>
# Rebuild image locally and run to ensure build not the culprit:
docker build -t myapp:debug .
docker run --rm -it myapp:debug
```

8. **If crash is immediate, collect exit code and stack traces**

* `ExitCode` 137 → OOM (killed).
* `ExitCode` 139 → segmentation fault (native crash).
* `ExitCode` 1/2/3 → app-level error (check logs and startup scripts).

9. **Use strace / ldd / core dumps for native crashes**

```bash
# If image has strace available (or run a debug image)
docker run --rm --cap-add SYS_PTRACE --security-opt seccomp=unconfined -it <image> strace -f -o /tmp/trace.txt <your-cmd>
# For core dumps: enable ulimit in run command and inspect core file with gdb
docker run --ulimit core=-1 --cap-add SYS_PTRACE -it <image> sh -c 'ulimit -c unlimited; your-cmd'
```

10. **Check restart loop behavior & change restart policy during debugging**

```bash
# See restart count
docker inspect -f '{{.RestartCount}}' <container>

# Temporarily stop auto-restart to debug
docker update --restart=no <container>   # prevents immediate restart so you can inspect
```

---

## Common root causes & fixes (short)

* **OOM / resource shortage** → Increase memory/CPU or set limits to prevent host OOM.
  `docker run -m 1g --cpus=1.0 ...` or lower app memory usage; investigate leaks.
* **Missing environment variables / secrets** → Ensure envs passed (`-e` / `--env-file`) or read from secret manager.
* **Bad ENTRYPOINT/CMD or script exiting** → Check entrypoint script for `set -e` and unhandled errors; run it interactively.
* **Port conflict** → Ensure host port not already used; check `docker ps` and host `ss -ltnp`.
* **Permission errors on mounted volumes** → `chown` files or run with correct user (`--user`), or fix UID/GID in container.
* **Healthcheck failing → container killed by orchestrator** → fix app to pass healthcheck or adjust healthcheck command/interval/retries.
* **Immediate native crash (segfault)** → inspect core, rebuild with debug symbols, or replace problematic native dependency.
* **Dependency/service not ready (app crashes connecting to DB)** → add start-up retry/backoff or make startup wait for dependencies.

---

## Preventive & production hygiene

* Add **proper healthcheck** in Dockerfile or compose so orchestrator can avoid tight crash loops:

```dockerfile
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
```

* Use **restart policy with backoff**: `--restart on-failure[:max-retries]` or rely on swarm/k8s backoff settings.
* Log structured errors to stdout/stderr and centralize logs (ELK/CloudWatch) so you can search crashes.
* Add **resource limits** to avoid host instability; monitor with Prometheus/Grafana.
* In CI/CD, run smoke tests after deploy to catch runtime issues.

---

## Quick recovery recipe (safe order)

1. `docker logs <container>` — capture recent errors.
2. `docker update --restart=no <container>` — stop restart loop.
3. `docker inspect` — collect exit code, mounts, envs.
4. `docker run --rm -it --entrypoint sh <image>` — reproduce and fix.
5. Apply fix (config/resource/code), rebuild image, deploy.

---

If you paste the **recent `docker logs` output** or the `docker inspect` `State`/`Config` JSON (or tell me whether you’re on Docker Compose / ECS / Kubernetes), I’ll give exact commands and the minimal change you should make to stop the crash loop and fix the root cause.

---
---

## 🧠 **Docker Compose Basics — with Equivalent `docker` Commands**

Docker Compose simplifies **multi-container management** using a `docker-compose.yml` file —
while plain `docker` commands manage containers one-by-one.

Below is a clear side-by-side comparison with **examples** 👇

---

### ⚙️ **1️⃣ Start Services**

| **Action**                       | **Docker Compose**         | **Docker Equivalent**                                    |
| -------------------------------- | -------------------------- | -------------------------------------------------------- |
| Start all services in background | `docker compose up -d`     | Multiple `docker run -d ...` commands for each container |
| Start in foreground (show logs)  | `docker compose up`        | Manually attach: `docker logs -f <container>`            |
| Start only one service           | `docker compose up -d web` | `docker run -d --name web myapp:latest`                  |

**Example:**

```bash
docker compose up -d
```

✅ Brings up all containers, networks, and volumes defined in `docker-compose.yml`.

---

### ⚙️ **2️⃣ Stop / Restart / Remove Containers**

| **Action**         | **Docker Compose**       | **Docker Equivalent**           |
| ------------------ | ------------------------ | ------------------------------- |
| Stop containers    | `docker compose stop`    | `docker stop $(docker ps -q)`   |
| Restart containers | `docker compose restart` | `docker restart <container>`    |
| Remove containers  | `docker compose down`    | `docker rm -f $(docker ps -aq)` |

**Example:**

```bash
docker compose down
```

✅ Stops and removes containers, networks, and by default keeps volumes.

Add volumes too:

```bash
docker compose down -v
```

---

### ⚙️ **3️⃣ Build Images**

| **Action**               | **Docker Compose**                | **Docker Equivalent**                 |
| ------------------------ | --------------------------------- | ------------------------------------- |
| Build all service images | `docker compose build`            | `docker build -t myapp .` (per image) |
| Rebuild without cache    | `docker compose build --no-cache` | `docker build --no-cache .`           |

**Example:**

```bash
docker compose build web
```

✅ Builds only the `web` service image defined in YAML.

---

### ⚙️ **4️⃣ Check Status**

| **Action**              | **Docker Compose**     | **Docker Equivalent** |
| ----------------------- | ---------------------- | --------------------- |
| List running services   | `docker compose ps`    | `docker ps`           |
| List all (even stopped) | `docker compose ps -a` | `docker ps -a`        |

---

### ⚙️ **5️⃣ Logs**

| **Action**                | **Docker Compose**        | **Docker Equivalent**                                  |
| ------------------------- | ------------------------- | ------------------------------------------------------ |
| View logs of all services | `docker compose logs`     | `docker logs <container>` (run separately per service) |
| Follow logs live          | `docker compose logs -f`  | `docker logs -f <container>`                           |
| Logs for one service      | `docker compose logs web` | `docker logs web`                                      |

---

### ⚙️ **6️⃣ Execute Commands in Running Container**

| **Action**             | **Docker Compose**               | **Docker Equivalent**           |
| ---------------------- | -------------------------------- | ------------------------------- |
| Shell into a container | `docker compose exec web sh`     | `docker exec -it web sh`        |
| Run one-time command   | `docker compose run web ls /app` | `docker run --rm myapp ls /app` |

**Example:**

```bash
docker compose exec db mysql -uroot -p
```

✅ Opens MySQL shell inside the `db` container.

---

### ⚙️ **7️⃣ Scale Services**

| **Action**     | **Docker Compose**                   | **Docker Equivalent**                |
| -------------- | ------------------------------------ | ------------------------------------ |
| Scale replicas | `docker compose up --scale web=3 -d` | Run `docker run -d` 3 times manually |
| Stop scaling   | `docker compose down`                | Manually stop each                   |

---

### ⚙️ **8️⃣ Manage Networks**

| **Action**    | **Docker Compose**                      | **Docker Equivalent**           |
| ------------- | --------------------------------------- | ------------------------------- |
| View networks | `docker compose network ls`             | `docker network ls`             |
| Inspect       | `docker compose network inspect <name>` | `docker network inspect <name>` |

> Compose auto-creates a project network — e.g., if project = `myapp`, network = `myapp_default`.

---

### ⚙️ **9️⃣ Manage Volumes**

| **Action**    | **Docker Compose**         | **Docker Equivalent** |
| ------------- | -------------------------- | --------------------- |
| List volumes  | `docker compose volume ls` | `docker volume ls`    |
| Remove unused | `docker compose down -v`   | `docker volume prune` |

---

### ⚙️ **🔟 Environment Variables**

| **Compose YAML** | **CLI Equivalent** |
| ---------------- | ------------------ |
| `env_file: .env` | `--env-file .env`  |
| `environment:`   | `-e VAR=value`     |

**Example (`docker-compose.yml`):**

```yaml
services:
  app:
    image: myapp
    environment:
      - ENV=prod
    env_file:
      - .env
```

---

### ⚙️ **🔢 Compose Lifecycle Summary**

| **Task**            | **Compose Command**            | **Plain Docker Command(s)**                 |
| ------------------- | ------------------------------ | ------------------------------------------- |
| Build images        | `docker compose build`         | `docker build -t ...`                       |
| Run containers      | `docker compose up -d`         | `docker run -d ...`                         |
| Stop containers     | `docker compose stop`          | `docker stop ...`                           |
| Logs                | `docker compose logs -f`       | `docker logs -f ...`                        |
| Exec into container | `docker compose exec <svc> sh` | `docker exec -it ... sh`                    |
| Clean up            | `docker compose down -v`       | `docker rm -f ...` + `docker volume rm ...` |

---

### ⚙️ **Example: `docker-compose.yml`**

```yaml
version: "3.9"
services:
  web:
    image: nginx
    ports:
      - "8080:80"

  app:
    build: .
    depends_on:
      - db
    environment:
      - ENV=dev

  db:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: root
```

Then run:

```bash
docker compose up -d
docker compose ps
docker compose logs -f
docker compose down
```

---

### 🧠 **Best Practices**

✅ Use Compose for **multi-service stacks** (web + db + cache).
✅ Keep **`.env`** and **`docker-compose.yml`** versioned for reproducible setups.
✅ Use `depends_on` for startup ordering.
✅ Never use `latest` tags in production; pin versions.
✅ For CI/CD, use `docker compose up -d --build` and destroy with `down` after tests.

---

### ✅ **In short:**

> **`docker`** = one container at a time (manual).
> **`docker compose`** = full app stack management (automated).
> Compose bundles build, network, volumes, envs, and dependencies — all from one YAML file.
