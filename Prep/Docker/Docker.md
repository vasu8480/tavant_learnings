# Docker

## Q1: What is Docker and what problems does it solve?

🧠 **Overview**

* Docker is a **containerization platform** that packages applications and their dependencies into **lightweight, portable containers**.
* Containers ensure the app runs **consistently across environments**—dev, test, and production.

⚡ **Problems Docker Solves**

| Problem                            | How Docker Solves It                                  | Example / Real-world                                                                                        |
| ---------------------------------- | ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| **“It works on my machine” issue** | Packages app + dependencies in one container          | A Python app with specific library versions runs the same on developer laptop, CI/CD server, and production |
| **Environment inconsistency**      | Containers isolate dependencies from host OS          | Node.js app works on Ubuntu, Windows, or Mac without changes                                                |
| **Complex deployment**             | Containers are portable and easy to deploy            | Kubernetes can orchestrate hundreds of Docker containers across multiple servers                            |
| **Resource overhead**              | Containers share OS kernel, lighter than VMs          | Run 10 containers on one server vs 2-3 VMs                                                                  |
| **Scaling challenges**             | Works with orchestration tools for horizontal scaling | Auto-scale web servers during traffic spikes                                                                |

💻 **Simple Docker Commands**

```bash
docker build -t myapp:1.0 .      # Build image from Dockerfile
docker run -d -p 8080:80 myapp   # Run container in background, map port
docker ps                         # List running containers
docker stop <container_id>        # Stop container
```

✅ **Key Notes**

* Containers are **immutable** and **ephemeral**; any changes inside a running container disappear unless committed.
* Works well with CI/CD pipelines for **automated, repeatable deployments**.
* Often used with Kubernetes for **production-grade orchestration**.

---
## Q2: Difference Between Container and Virtual Machine

| Feature            | Container                                | Virtual Machine (VM)                             | Example / Real-world                                                                   |
| ------------------ | ---------------------------------------- | ------------------------------------------------ | -------------------------------------------------------------------------------------- |
| **OS Dependency**  | Shares host OS kernel                    | Runs full guest OS                               | Docker container runs Ubuntu apps on Windows host without full Linux OS                |
| **Resource Usage** | Lightweight, uses fewer resources        | Heavy, each VM needs full OS                     | Run 50 containers on 1 server vs 5 VMs                                                 |
| **Startup Time**   | Fast (seconds)                           | Slow (minutes)                                   | CI/CD pipeline can spin up containers in seconds                                       |
| **Isolation**      | Process-level isolation                  | Hardware-level isolation                         | Multiple apps on same OS kernel isolated at process level                              |
| **Portability**    | Highly portable                          | Less portable                                    | Docker image can run anywhere Docker is installed                                      |
| **Persistence**    | Usually ephemeral; uses volumes for data | Persistent by default                            | Containers lose data on stop unless volume used; VMs keep disk state                   |
| **Use Case**       | Microservices, CI/CD, cloud-native apps  | Running multiple OS, legacy apps, full isolation | Kubernetes runs microservices in containers; VMware runs Windows/Linux VMs for testing |

💻 **Example**

* Container: `docker run -it ubuntu bash` → runs a lightweight Ubuntu process sharing host kernel
* VM: `virt-manager` or AWS EC2 → runs full Ubuntu OS with dedicated virtualized resources

**Key Note:** Containers are **faster and lighter**; VMs offer **stronger isolation and full OS environment**.

---
## Q3: What is a Docker Image

🧠 **Overview**

* A **Docker image** is a **read-only template** containing everything needed to run an application: code, runtime, libraries, environment variables, and configuration files.
* It is used to create **Docker containers**, which are the running instances of the image.

⚡ **Key Points**

* Immutable and versioned (like `myapp:1.0`)
* Can be stored and shared via **Docker Hub** or private registries
* Built using a **Dockerfile**

💻 **Example**
**Dockerfile:**

```dockerfile
FROM python:3.11
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "app.py"]
```

**Commands:**

```bash
docker build -t myapp:1.0 .   # Build image from Dockerfile
docker images                  # List available images
docker run myapp:1.0           # Run a container from the image
```

✅ **Explanation:**

* `FROM python:3.11` → Base image with Python
* `COPY` + `RUN` → Adds code and installs dependencies
* `CMD` → Default command when container starts

**Real-world scenario:**

* CI/CD pipelines build Docker images for each commit, push to registry, and deploy the same image to dev, staging, and production—ensuring **consistency across environments**.

---
## Q4: What is a Docker Container

🧠 **Overview**

* A **Docker container** is a **running instance of a Docker image**.
* It’s a **lightweight, isolated environment** where your application runs with all its dependencies, without affecting the host system.

⚡ **Key Points**

* Containers are **ephemeral**: changes disappear unless saved with volumes or committed.
* Share the **host OS kernel**, so they are faster and use fewer resources than VMs.
* Can be **started, stopped, paused, or deleted** easily.

💻 **Example**

```bash
docker run -d -p 8080:80 myapp:1.0   # Run container in background, map host port 8080 to container 80
docker ps                              # List running containers
docker stop <container_id>             # Stop container
docker logs <container_id>             # View container logs
```

✅ **Explanation:**

* `-d` → Run container in detached mode
* `-p` → Map host port to container port
* `docker ps` → Check which containers are running

**Real-world scenario:**

* In CI/CD pipelines, containers are used to **run tests or deploy microservices** consistently across environments.
* Kubernetes orchestrates **hundreds of containers** for large-scale apps.

----
## Q5: Difference Between Docker Image and Container

| Feature        | Docker Image                                                      | Docker Container                                          | Example / Real-world                                            |
| -------------- | ----------------------------------------------------------------- | --------------------------------------------------------- | --------------------------------------------------------------- |
| **Definition** | Read-only **template** with app code, libraries, and dependencies | **Running instance** of an image, isolated and executable | Image: `myapp:1.0`; Container: running `myapp:1.0` on port 8080 |
| **State**      | Static, immutable                                                 | Dynamic, can change during runtime                        |                                                                 |
| **Storage**    | Stored in Docker Hub / registry                                   | Runs in memory/storage, ephemeral unless volume used      |                                                                 |
| **Lifecycle**  | Built once, versioned                                             | Can be started, stopped, paused, removed                  |                                                                 |
| **Purpose**    | Blueprint for creating containers                                 | Executes the app in a controlled environment              |                                                                 |
| **Commands**   | `docker build`, `docker images`                                   | `docker run`, `docker ps`, `docker stop`                  |                                                                 |

💻 **Example**

```bash
docker build -t myapp:1.0 .   # Create image
docker run -d -p 8080:80 myapp:1.0  # Run container from image
```

✅ **Key Note:**

* **Image = blueprint** (like a class in programming)
* **Container = running object/instance** (like an object created from class)

---
## Q6: What is a Dockerfile

🧠 **Overview**

* A **Dockerfile** is a **text file with instructions** to build a Docker image.
* It defines **base image, dependencies, code, environment variables, and commands** needed for the application.

⚡ **Key Points**

* Automates image creation → **reproducible builds**
* Supports version control (like Git)
* Can define **multi-stage builds** to optimize image size

💻 **Example Dockerfile**

```dockerfile
# Use official Python image as base
FROM python:3.11

# Set working directory inside container
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy app code
COPY . .

# Default command to run app
CMD ["python", "app.py"]
```

✅ **Explanation:**

* `FROM` → Base image
* `WORKDIR` → Directory inside container
* `COPY` → Copy files from host to container
* `RUN` → Execute commands (e.g., install packages)
* `CMD` → Command executed when container starts

💡 **Real-world scenario:**

* In CI/CD pipelines, Dockerfiles ensure **the same environment is built every time** for dev, staging, and production.

---
## Q7: Purpose of the `FROM` Instruction in a Dockerfile

🧠 **Overview**

* `FROM` specifies the **base image** for your Docker image.
* It is **the first instruction** in most Dockerfiles and sets the environment your app will build on.

⚡ **Key Points**

* Can use **official images** (e.g., `python:3.11`, `ubuntu:22.04`) or **custom images**
* Supports **versioning/tagging** to ensure consistent builds (`python:3.11-slim`)
* Enables **layered builds** — all subsequent instructions build on top of this base

💻 **Example**

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "app.py"]
```

✅ **Explanation:**

* `FROM python:3.11-slim` → Starts from a minimal Python environment
* All other commands (`COPY`, `RUN`, etc.) **layer on top** of this base image

💡 **Real-world scenario:**

* Using `FROM node:18-alpine` in a web app Dockerfile ensures **lightweight, consistent Node.js runtime** across dev, CI/CD, and production.

---
## Q8: What Does the `RUN` Instruction Do in a Dockerfile

🧠 **Overview**

* `RUN` executes **commands inside the image at build time**.
* It’s used to **install packages, dependencies, or perform setup** that your app needs to run.

⚡ **Key Points**

* Creates a **new layer** in the Docker image for each `RUN` command
* Executed **during image build**, not when the container runs
* Can use **shell form** or **exec form**

💻 **Example**

```dockerfile
# Install Python dependencies
RUN pip install -r requirements.txt

# Install OS packages
RUN apt-get update && apt-get install -y curl
```

✅ **Explanation:**

* `RUN pip install -r requirements.txt` → Installs Python packages into the image
* `RUN apt-get install` → Installs OS-level packages needed for the app

💡 **Real-world scenario:**

* In a CI/CD pipeline, `RUN` ensures the container **has all dependencies baked in**, so developers and production servers run the app consistently.

---
## Q9: Difference Between `CMD` and `ENTRYPOINT` in Dockerfile

| Feature      | CMD                                                                   | ENTRYPOINT                                                      | Example / Real-world                                                                                                                                          |
| ------------ | --------------------------------------------------------------------- | --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Purpose**  | Default command for container, can be overridden at `docker run`      | Fixed command that always runs, can accept additional arguments | CMD: `CMD ["python", "app.py"]` → can override with `docker run myapp python test.py`<br>ENTRYPOINT: `ENTRYPOINT ["python", "app.py"]` → always runs `app.py` |
| **Override** | Easily overridden via `docker run`                                    | Harder to override; additional args are appended                | CMD is flexible; ENTRYPOINT ensures container always runs the main app                                                                                        |
| **Syntax**   | Exec form (`["executable", "param"]`) or Shell form (`command param`) | Exec form recommended                                           | ENTRYPOINT ["nginx", "-g", "daemon off;"] → always starts Nginx                                                                                               |
| **Use Case** | Set default behavior                                                  | Enforce main executable, allow arguments                        | CMD for optional default command, ENTRYPOINT for enforcing app start in production                                                                            |

💻 **Example**

```dockerfile
# CMD example
CMD ["python", "app.py"]

# ENTRYPOINT example
ENTRYPOINT ["python", "app.py"]
```

* With CMD, you can override: `docker run myapp python test.py`
* With ENTRYPOINT, additional args are appended: `docker run myapp --debug` → runs `python app.py --debug`

✅ **Key Note:**

* Use **ENTRYPOINT** for the main application to always run
* Use **CMD** for defaults that can be overridden

---
## Q10: What is the `COPY` Instruction Used For

🧠 **Overview**

* `COPY` copies **files or directories from the host machine into the Docker image** at build time.
* Used to include **application code, configuration files, or assets** inside the image.

⚡ **Key Points**

* Source is **relative to the build context** (usually the folder with Dockerfile)
* Destination is the **path inside the container**
* Only works **during build**, not at container runtime

💻 **Example**

```dockerfile
# Copy requirements file
COPY requirements.txt /app/

# Copy all source code
COPY . /app/
```

✅ **Explanation:**

* `COPY requirements.txt /app/` → Adds `requirements.txt` into `/app` in the image
* `COPY . /app/` → Copies the entire current directory into the container

💡 **Real-world scenario:**

* In CI/CD, `COPY . /app/` ensures **all app code and configs** are included in the image so containers run consistently across dev, staging, and production.

---
## Q11: Difference Between `COPY` and `ADD` in Dockerfile

| Feature                | COPY                                         | ADD                                                                        | Example / Real-world                                                                          |
| ---------------------- | -------------------------------------------- | -------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| **Purpose**            | Copy files or directories from host to image | Copy files/directories **and can also extract tar archives or fetch URLs** | COPY: `COPY . /app/` → copies app code<br>ADD: `ADD myapp.tar.gz /app/` → copies and extracts |
| **Tar Extraction**     | ❌ Does not extract                           | ✅ Automatically extracts compressed tar files                              | ADD handles `.tar.gz` directly during build                                                   |
| **URL Support**        | ❌ Cannot fetch URLs                          | ✅ Can download files from URL into image                                   | `ADD https://example.com/app.tar.gz /app/`                                                    |
| **Use Recommendation** | Preferred for **simple copy**                | Only when **tar extraction or URL fetching** is needed                     | Best practice: use COPY for clarity and predictability                                        |

💡 **Key Notes:**

* **COPY is simpler, safer, and predictable** → widely recommended
* **ADD is more powerful** but can be **less explicit**, which may confuse builds

💻 **Example**

```dockerfile
# Using COPY
COPY requirements.txt /app/

# Using ADD to extract tar archive
ADD myapp.tar.gz /app/
```

✅ **Real-world scenario:**

* Most Dockerfiles in production **use COPY** for code and configs
* ADD is rarely used except when downloading or extracting archives during build

---
## Q12: What is the `WORKDIR` Instruction

🧠 **Overview**

* `WORKDIR` sets the **working directory inside the container** for subsequent instructions (`COPY`, `RUN`, `CMD`, etc.).
* If the directory doesn’t exist, Docker **creates it automatically**.

⚡ **Key Points**

* Makes Dockerfiles cleaner by avoiding repeated path specifications
* Can be **used multiple times**; each `WORKDIR` overrides the previous one

💻 **Example**

```dockerfile
# Set working directory
WORKDIR /app

# Copy files into /app
COPY . .

# Run commands inside /app
RUN pip install -r requirements.txt

# Default command
CMD ["python", "app.py"]
```

✅ **Explanation:**

* `WORKDIR /app` → All subsequent instructions execute relative to `/app`
* No need to write full paths in `COPY` or `RUN` commands

💡 **Real-world scenario:**

* In CI/CD pipelines, WORKDIR ensures **all app code, dependencies, and commands are executed in a consistent directory**, avoiding path errors during build or deployment.

---
## Q13: What Does the `EXPOSE` Instruction Do

🧠 **Overview**

* `EXPOSE` **declares the network ports** the container will listen on at runtime.
* It **does not publish the port to the host** by itself; it’s mainly **documentation for developers and orchestration tools**.

⚡ **Key Points**

* Can declare **multiple ports**
* Works with `docker run -p` or Docker Compose to map container ports to host ports
* Optional, but improves **readability and maintainability**

💻 **Example**

```dockerfile
# Expose port 8080 inside the container
EXPOSE 8080

# Default command
CMD ["python", "app.py"]
```

**Running container with port mapping:**

```bash
docker run -d -p 8080:8080 myapp
```

✅ **Explanation:**

* `EXPOSE 8080` → Tells others “this container listens on port 8080”
* `-p 8080:8080` → Maps container port 8080 to host port 8080 so traffic can reach the app

💡 **Real-world scenario:**

* In microservices architecture, `EXPOSE` helps orchestration tools like **Kubernetes or Docker Compose** know which ports to route traffic to.

---
## Q14: What is the `ENV` Instruction

🧠 **Overview**

* `ENV` sets **environment variables inside the Docker image**, which can be used by the application or other Dockerfile instructions.
* Useful for **configurable values** like API keys, database URLs, or app settings.

⚡ **Key Points**

* Variables persist in the image and containers created from it
* Can be **overridden at runtime** with `docker run -e`
* Improves **flexibility and portability**

💻 **Example**

```dockerfile
# Set environment variables
ENV APP_ENV=production
ENV DB_HOST=database.example.com

WORKDIR /app
COPY . .
CMD ["python", "app.py"]
```

**Override at runtime:**

```bash
docker run -e APP_ENV=staging myapp
```

✅ **Explanation:**

* `ENV APP_ENV=production` → Sets a default value inside the container
* `-e APP_ENV=staging` → Overrides default when running container

💡 **Real-world scenario:**

* In CI/CD pipelines, ENV allows **same image to run in dev, staging, and production** with different configurations without rebuilding the image.

---
## Q15: What is Docker Hub

🧠 **Overview**

* Docker Hub is a **cloud-based registry** for storing, sharing, and distributing Docker images.
* Acts like **GitHub for Docker images** — public or private repositories can host images.

⚡ **Key Points**

* Hosts **official images** (Python, Ubuntu, Node, etc.) and **custom images**
* Supports **pulling images** (`docker pull`) and **pushing images** (`docker push`)
* Integrates with **CI/CD pipelines** for automated builds and deployments
* Provides **image versioning and access control**

💻 **Example**

```bash
# Pull official Python image
docker pull python:3.11

# Push custom image to Docker Hub
docker tag myapp:1.0 vasu/myapp:1.0
docker push vasu/myapp:1.0
```

✅ **Explanation:**

* `docker pull` → Downloads image from Docker Hub
* `docker push` → Uploads your built image to your repository on Docker Hub

💡 **Real-world scenario:**

* In DevOps, Docker Hub is used to **share images between developers and deploy the same image to production** for consistent environments.

---
## Q16: How to Pull an Image from Docker Hub

🧠 **Overview**

* `docker pull` downloads an image from Docker Hub (or another registry) to your local system.
* Required before you can **run a container** from that image.

💻 **Basic Command**

```bash
docker pull <image_name>:<tag>
```

**Example:**

```bash
# Pull latest Python image
docker pull python:3.11

# Pull a custom image from a user repository
docker pull vasu/myapp:1.0
```

✅ **Explanation:**

* `<image_name>` → Name of the image (official or user repository)
* `<tag>` → Version of the image; defaults to `latest` if omitted
* After pulling, the image is available locally (`docker images`) and can be run with `docker run`

💡 **Real-world scenario:**

* In CI/CD pipelines, pulling the latest image ensures **developers and production use the same tested image**.

---
## Q17: How to Run a Docker Container

🧠 **Overview**

* `docker run` creates and starts a container from a Docker image.
* You can specify options like **port mapping, environment variables, volumes, and detach mode**.

💻 **Basic Command**

```bash
docker run [OPTIONS] <image_name>:<tag>
```

**Examples:**

```bash
# Run container interactively
docker run -it python:3.11 bash

# Run container in detached mode and map ports
docker run -d -p 8080:80 myapp:1.0

# Run with environment variable
docker run -e APP_ENV=production myapp:1.0

# Mount a volume
docker run -v /host/data:/container/data myapp:1.0
```

✅ **Explanation:**

* `-it` → Interactive terminal
* `-d` → Detached mode (runs in background)
* `-p host_port:container_port` → Expose container port to host
* `-v host_path:container_path` → Mount host directory into container

💡 **Real-world scenario:**

* In CI/CD, `docker run` spins up **temporary containers for testing, integration, or deployment** without affecting the host system.

---
## Q18: What Does `docker ps` Command Do

🧠 **Overview**

* `docker ps` lists **running Docker containers** on your system.
* Useful for **monitoring, troubleshooting, and managing containers**.

💻 **Basic Command**

```bash
docker ps
```

**Common Options:**

| Option                     | Description                                                  |
| -------------------------- | ------------------------------------------------------------ |
| `-a`                       | Show all containers, including stopped ones (`docker ps -a`) |
| `-q`                       | Show only container IDs (useful for scripting)               |
| `--filter "status=exited"` | Filter containers by status                                  |

✅ **Example Output:**

```text
CONTAINER ID   IMAGE       COMMAND           STATUS         PORTS        NAMES
f1a2b3c4d5e6   myapp:1.0  "python app.py"   Up 5 minutes  0.0.0.0:8080->80/tcp   myapp_container
```

💡 **Explanation:**

* Shows container ID, image, command, status, port mappings, and name
* Helps **check if your container is running** and troubleshoot port or status issues

💡 **Real-world scenario:**

* During deployment, `docker ps` ensures all **microservices containers are up and running** before traffic routing or testing.

---
## Q19: Difference Between `docker ps` and `docker ps -a`

| Command        | What it Shows                                   | Use Case / Real-world                                                                      |
| -------------- | ----------------------------------------------- | ------------------------------------------------------------------------------------------ |
| `docker ps`    | Only **running containers**                     | Quickly check which containers are currently active in production or dev environment       |
| `docker ps -a` | **All containers**: running, stopped, or exited | Useful for troubleshooting or cleaning up old containers; shows history of container usage |

💻 **Example:**

```bash
docker ps
# Shows only active containers
docker ps -a
# Shows all containers, e.g., exited or stopped ones
```

✅ **Key Note:**

* `docker ps` = snapshot of current running containers
* `docker ps -a` = full history of container instances

💡 **Real-world scenario:**

* In CI/CD or testing, `docker ps -a` helps **identify failed containers** for logs and debugging.

---
## Q20: How to Stop a Running Docker Container

🧠 **Overview**

* `docker stop` **gracefully stops a running container** by sending a `SIGTERM` signal.
* If the container doesn’t stop within a timeout (default 10s), Docker sends `SIGKILL`.

💻 **Basic Command**

```bash
docker stop <container_id_or_name>
```

**Example:**

```bash
# Stop container by ID
docker stop f1a2b3c4d5e6

# Stop container by name
docker stop myapp_container
```

✅ **Explanation:**

* `<container_id_or_name>` → Unique identifier or name of the container
* Use `docker ps` to find running containers first

💡 **Real-world scenario:**

* During deployment or testing, you may **stop old containers** before starting updated versions in CI/CD pipelines or Kubernetes nodes.

---

## Q21: How to Remove a Docker Container

🧠 **Overview**

* `docker rm` deletes a container from your system.
* The container must be **stopped** before removing (or use `-f` to force).

💻 **Basic Command**

```bash
docker rm <container_id_or_name>
```

**Examples:**

```bash
# Remove a stopped container
docker rm myapp_container

# Force remove a running container
docker rm -f myapp_container

# Remove multiple containers at once
docker rm container1 container2 container3
```

✅ **Explanation:**

* `docker rm` → Deletes the container’s writable layer
* Doesn’t remove the **image**; the image can be reused to create new containers

💡 **Real-world scenario:**

* In CI/CD pipelines or dev environments, `docker rm` is used to **clean up old containers** after tests or deployments to free up resources.

---
## Q22: How to Remove a Docker Image

🧠 **Overview**

* `docker rmi` deletes a Docker image from your local system.
* You cannot remove an image if **containers are still using it**, unless you force it with `-f`.

💻 **Basic Command**

```bash
docker rmi <image_name_or_id>
```

**Examples:**

```bash
# Remove an image by name
docker rmi myapp:1.0

# Remove an image by ID
docker rmi f1a2b3c4d5e6

# Force remove image (even if containers exist)
docker rmi -f myapp:1.0

# Remove multiple images
docker rmi image1 image2 image3
```

✅ **Explanation:**

* Frees up disk space by deleting image layers
* Image can be re-pulled later from Docker Hub if needed

💡 **Real-world scenario:**

* In CI/CD or dev environments, `docker rmi` is used to **clean up old images** after builds to save storage on build servers or developer machines.

---
## Q23: What is the `docker build` Command

🧠 **Overview**

* `docker build` **creates a Docker image** from a Dockerfile.
* It reads the instructions in the Dockerfile and builds **layered image** that can be run as a container.

💻 **Basic Command**

```bash
docker build -t <image_name>:<tag> <path_to_dockerfile>
```

**Example:**

```bash
# Build an image named myapp:1.0 from current directory
docker build -t myapp:1.0 .
```

✅ **Explanation:**

* `-t myapp:1.0` → Tags the image for easy reference
* `.` → Build context (current directory with Dockerfile and app files)
* Each Dockerfile instruction (`FROM`, `RUN`, `COPY`) creates a **layer** in the image

💡 **Real-world scenario:**

* In CI/CD pipelines, `docker build` is used to **automatically create images** for every commit, which can then be tested, pushed to Docker Hub, and deployed to production.

---
## Q24: What is a Docker Tag

🧠 **Overview**

* A **Docker tag** is a **label assigned to a Docker image** to identify a specific version.
* Helps manage **image versions** and **ensure consistency** across environments.

⚡ **Key Points**

* Format: `<repository>:<tag>` (e.g., `myapp:1.0`)
* Default tag is `latest` if not specified
* Tags are used when **pushing, pulling, or running images**

💻 **Example**

```bash
# Build an image with a tag
docker build -t myapp:1.0 .

# Pull a specific tagged image
docker pull python:3.11

# Run a container from a tagged image
docker run -d myapp:1.0
```

✅ **Explanation:**

* `myapp:1.0` → Version 1.0 of the app image
* Using tags ensures **you don’t accidentally run an unintended version**

💡 **Real-world scenario:**

* In CI/CD, every build can be tagged with the **commit SHA, build number, or release version**, allowing precise rollbacks and reproducible deployments.

----
## Q25: How to Tag a Docker Image

🧠 **Overview**

* `docker tag` assigns a **tag to an existing Docker image**, giving it a version or repository name for easier identification and pushing to a registry.

💻 **Basic Command**

```bash
docker tag <source_image>:<source_tag> <target_repository>:<target_tag>
```

**Example:**

```bash
# Tag local image myapp:1.0 for Docker Hub repository
docker tag myapp:1.0 vasu/myapp:1.0

# Push the tagged image to Docker Hub
docker push vasu/myapp:1.0
```

✅ **Explanation:**

* `<source_image>:<source_tag>` → Existing image on your local system
* `<target_repository>:<target_tag>` → New name or version for registry or versioning
* Tagging is **optional for local use**, but essential for **sharing images or version control**

💡 **Real-world scenario:**

* In CI/CD pipelines, images are tagged with **build numbers, commit SHAs, or release versions** to ensure **consistent deployment and easy rollback**.

---
## Q26: What is the `docker exec` Command

🧠 **Overview**

* `docker exec` runs a **command inside a running container** without starting a new container.
* Useful for **debugging, inspecting, or interacting** with containers on the fly.

💻 **Basic Command**

```bash
docker exec [OPTIONS] <container_name_or_id> <command>
```

**Examples:**

```bash
# Run bash shell inside a running container interactively
docker exec -it myapp_container bash

# Check logs or run a command inside container
docker exec myapp_container ls /app

# Run a Python script inside container
docker exec myapp_container python /app/script.py
```

✅ **Explanation:**

* `-i` → Keep STDIN open
* `-t` → Allocate a pseudo-TTY (interactive terminal)
* Allows you to **inspect or modify a container** without stopping it

💡 **Real-world scenario:**

* During production debugging, `docker exec -it container bash` lets DevOps engineers **inspect file structures, logs, or run maintenance scripts** without restarting the container.

----
## Q27: How to View Logs from a Docker Container

🧠 **Overview**

* `docker logs` shows the **stdout and stderr output** of a running or stopped container.
* Useful for **debugging, monitoring, and troubleshooting** containerized applications.

💻 **Basic Command**

```bash
docker logs [OPTIONS] <container_name_or_id>
```

**Examples:**

```bash
# View logs of a container
docker logs myapp_container

# Follow logs in real-time
docker logs -f myapp_container

# Show last 10 lines
docker logs --tail 10 myapp_container

# Include timestamps
docker logs -t myapp_container
```

✅ **Explanation:**

* `-f` → Stream logs continuously (like `tail -f`)
* `--tail` → Limit number of lines displayed
* `-t` → Add timestamps for each log line

💡 **Real-world scenario:**

* In CI/CD or production, `docker logs -f` is used to **monitor application behavior** after deployment or during troubleshooting.

---
## Q28: What is Port Mapping in Docker

🧠 **Overview**

* **Port mapping** connects a **port inside a container** to a **port on the host machine**, allowing external access to containerized applications.
* Essential because containers are isolated by default and **cannot be accessed directly from the host**.

💻 **Basic Command**

```bash
docker run -d -p <host_port>:<container_port> <image_name>:<tag>
```

**Example:**

```bash
# Map host port 8080 to container port 80
docker run -d -p 8080:80 myapp:1.0
```

✅ **Explanation:**

* `-p 8080:80` → Host can access container’s service via `http://localhost:8080`
* Container listens internally on port 80, host forwards traffic to it

💡 **Real-world scenario:**

* Running a web server container: port mapping allows developers to **access the app from browser or CI/CD pipelines** for testing, staging, or production deployments.

---

## Q29: How to Map Container Ports to Host Ports

🧠 **Overview**

* Use the `-p` or `--publish` flag in `docker run` to **map a container’s internal port to a host port**.
* This allows **external access** to services running inside containers.

💻 **Basic Command**

```bash
docker run -d -p <host_port>:<container_port> <image_name>:<tag>
```

**Examples:**

```bash
# Map host port 8080 to container port 80
docker run -d -p 8080:80 myapp:1.0

# Map multiple ports
docker run -d -p 8080:80 -p 8443:443 myapp:1.0
```

✅ **Explanation:**

* Format: `host_port:container_port`
* External clients access the app using the **host port**, while the container listens internally on its **container port**

💡 **Real-world scenario:**

* In CI/CD pipelines or local dev, mapping allows **testing multiple services locally** without port conflicts.
* Example: Run multiple web apps simultaneously with different host ports (8080, 8081, etc.) while all use port 80 internally.

---
## Q30: What is a Docker Volume

🧠 **Overview**

* A **Docker volume** is a **persistent storage mechanism** for containers, independent of the container’s lifecycle.
* Volumes allow data to **survive container deletion or recreation**.

⚡ **Key Points**

* Stored outside the container’s writable layer (usually in Docker-managed directories)
* Can be **shared between multiple containers**
* Preferred over bind mounts for **data persistence and portability**

💻 **Basic Command**

```bash
# Create a volume
docker volume create mydata

# Run container with volume
docker run -d -v mydata:/app/data myapp:1.0

# List volumes
docker volume ls

# Inspect volume details
docker volume inspect mydata
```

✅ **Explanation:**

* `-v mydata:/app/data` → Mounts volume `mydata` to `/app/data` inside container
* Data written to `/app/data` persists even if container is removed

💡 **Real-world scenario:**

* Storing **database files, logs, or uploaded files** in a containerized app ensures data **is not lost during container updates or redeployments**.

----
## Q31: Why Use Docker Volumes

🧠 **Overview**

* Docker volumes provide **persistent, managed storage** for containers, keeping data safe across container lifecycle events.

⚡ **Key Benefits**

| Benefit                               | Explanation                                                | Real-world Example                                                    |
| ------------------------------------- | ---------------------------------------------------------- | --------------------------------------------------------------------- |
| **Persistence**                       | Data remains even if container is deleted                  | Database files in a MySQL container survive restarts or redeployments |
| **Sharing Data**                      | Multiple containers can access the same volume             | Web app and worker container sharing uploaded files                   |
| **Decoupling Storage from Container** | Keeps storage separate from container filesystem           | Easier backups, migrations, or scaling containers without losing data |
| **Performance**                       | Optimized by Docker and OS for I/O operations              | Faster than bind mounts in production for databases or logs           |
| **Security & Management**             | Managed by Docker, with access control and easy inspection | `docker volume inspect` for debugging or maintenance                  |

💻 **Example Command:**

```bash
docker run -d -v mydata:/var/lib/mysql mysql:8
```

* `mydata` volume stores MySQL data outside the container
* Even if the container is removed, data remains intact

💡 **Real-world scenario:**

* In CI/CD pipelines or production, volumes **ensure databases, logs, and persistent files are not lost** when containers are redeployed or scaled.

---
## Q32: Difference Between Docker Volumes and Bind Mounts

| Feature         | Volume                                                 | Bind Mount                                 | Example / Real-world                                                                                |
| --------------- | ------------------------------------------------------ | ------------------------------------------ | --------------------------------------------------------------------------------------------------- |
| **Location**    | Managed by Docker (usually `/var/lib/docker/volumes/`) | Specific path on host filesystem           | Volume: `docker volume create mydata`<br>Bind mount: `-v /host/data:/app/data`                      |
| **Management**  | Docker handles creation, backup, and removal           | User manually manages host path            | Volumes easier for production; bind mounts useful for dev/testing                                   |
| **Portability** | Portable across hosts (with volume drivers)            | Tied to host filesystem path               | Volume can be reused in CI/CD pipelines; bind mount only works on that host                         |
| **Permissions** | Docker manages permissions                             | Depends on host file permissions           | Volumes safer for shared containers; bind mounts may need manual chmod/chown                        |
| **Use Case**    | Production storage, databases, logs                    | Development, debugging, or local code sync | Volume: MySQL data persistence<br>Bind mount: Local code edits reflected inside container instantly |

💻 **Example:**

```bash
# Volume
docker run -v mydata:/app/data myapp:1.0

# Bind mount
docker run -v /home/vasu/project:/app myapp:1.0
```

✅ **Key Note:**

* **Volumes** = Managed, safe, persistent → preferred for production
* **Bind mounts** = Flexible, instant host sync → preferred for development

---
## Q33: How to Create a Docker Volume

🧠 **Overview**

* `docker volume create` is used to **create a new persistent storage volume** that can be attached to containers.

💻 **Basic Command**

```bash
docker volume create <volume_name>
```

**Example:**

```bash
# Create a volume named mydata
docker volume create mydata

# List all volumes
docker volume ls

# Inspect details of a volume
docker volume inspect mydata
```

✅ **Explanation:**

* `<volume_name>` → Name you assign to the volume
* Docker stores it in a managed location, separate from container filesystem
* Volumes can be **shared between containers** and persist data even after container removal

💡 **Real-world scenario:**

* Used to store **databases, logs, or uploads** so that container redeployments do not result in data loss:

```bash
docker run -d -v mydata:/var/lib/mysql mysql:8
```

----  
## Q34: What is Docker Compose

🧠 **Overview**

* Docker Compose is a **tool for defining and running multi-container Docker applications** using a **YAML file (`docker-compose.yml`)**.
* Simplifies **orchestration, networking, and configuration** of multiple containers together.

⚡ **Key Points**

* Defines **services, networks, and volumes** in a single file
* Supports **environment variables, build instructions, and dependencies**
* Commands like `docker-compose up` and `docker-compose down` manage **all containers at once**

💻 **Example `docker-compose.yml`:**

```yaml
version: '3'
services:
  web:
    image: myapp:1.0
    ports:
      - "8080:80"
    volumes:
      - webdata:/app/data
  db:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
volumes:
  webdata:
```

**Commands:**

```bash
docker-compose up -d    # Start all services in detached mode
docker-compose down     # Stop and remove all containers, networks, and volumes
```

💡 **Real-world scenario:**

* In DevOps, Docker Compose is used to **spin up development or test environments** with web apps, databases, and caches in **one command**, ensuring consistency across environments.

----
## Q35: Purpose of a `docker-compose.yml` File

🧠 **Overview**

* The `docker-compose.yml` file **defines the configuration of multiple containers** as a single application.
* It specifies **services, networks, volumes, ports, and environment variables** in a structured way.

⚡ **Key Points**

* Makes **multi-container orchestration simple**
* Enables **consistent setup across development, testing, and production**
* Supports **dependency management** (e.g., DB starts before web service)

💻 **Example Structure:**

```yaml
version: '3'
services:
  web:
    image: myapp:1.0
    ports:
      - "8080:80"
    depends_on:
      - db
  db:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
volumes:
  dbdata:
```

✅ **Explanation:**

* `services` → Each container in the app
* `volumes` → Persistent storage
* `depends_on` → Control start order of services
* `ports` → Map container ports to host ports

💡 **Real-world scenario:**

* In CI/CD pipelines, developers can **start a complete app stack (web + database + cache) with a single command** using `docker-compose.yml`, ensuring everyone uses the same environment.

----
## Q36: How to Start Services Defined in `docker-compose.yml`

🧠 **Overview**

* Use `docker-compose up` to **create and start all services** defined in a `docker-compose.yml` file.
* Supports running in **foreground or detached mode**.

💻 **Basic Commands**

```bash
# Start services in foreground
docker-compose up

# Start services in detached (background) mode
docker-compose up -d

# Rebuild images before starting
docker-compose up --build -d
```

✅ **Explanation:**

* `-d` → Runs services in background
* `--build` → Rebuilds images if Dockerfile or code has changed
* Stops and removes services with `docker-compose down`

💡 **Real-world scenario:**

* In development, a single `docker-compose up -d` can **spin up a web app, database, and cache** together, making the environment consistent for all team members.

---
## Q37: Difference Between `docker-compose up` and `docker-compose start`

| Feature                | `docker-compose up`                                | `docker-compose start`                   | Example / Real-world                                                 |
| ---------------------- | -------------------------------------------------- | ---------------------------------------- | -------------------------------------------------------------------- |
| **Creates containers** | ✅ Creates missing containers                       | ❌ Only starts existing containers        | `up` can start fresh environment; `start` resumes stopped containers |
| **Builds images**      | ✅ Builds images if Dockerfile or image not present | ❌ Does not build                         | Use `up --build` to rebuild images                                   |
| **Attach to logs**     | ✅ Attaches to container logs by default            | ❌ Does not attach                        | `up` useful for debugging; `start` for background services           |
| **Initial run**        | Required for first-time setup                      | Only works after `up` created containers | For a new app, always run `docker-compose up` first                  |

💻 **Example:**

```bash
docker-compose up -d     # Create and start all services
docker-compose start      # Start services that were previously stopped
```

✅ **Key Note:**

* **`up` = create + start + attach (and optionally build)**
* **`start` = only start existing containers**

💡 **Real-world scenario:**

* In CI/CD or dev environments, `up` is used to **deploy new stacks**, while `start` is used to **resume stopped services** without recreating them.

----
## Q38: How to Scale Services in Docker Compose

🧠 **Overview**

* Docker Compose allows you to **run multiple instances of a service** for load balancing or testing.
* Scaling is done using the `--scale` option with `docker-compose up`.

💻 **Basic Command**

```bash
docker-compose up -d --scale <service_name>=<number_of_instances>
```

**Example:**

```bash
# Scale web service to 3 instances
docker-compose up -d --scale web=3
```

✅ **Explanation:**

* `<service_name>` → Name of the service defined in `docker-compose.yml`
* `<number_of_instances>` → Number of container replicas to run
* Useful for **horizontal scaling of stateless services**

💡 **Real-world scenario:**

* In development or testing, you can **simulate multiple web servers** behind a load balancer without manually creating containers.
* In production, scaling helps handle **increased traffic** by running multiple container instances of a service.

----
## Q39: What is a Docker Network

🧠 **Overview**

* A Docker network allows **containers to communicate** with each other and with the host or external services.
* Provides **isolation, name resolution, and connectivity** between containers.

⚡ **Key Points**

* Types of Docker networks: **bridge, host, overlay, macvlan**
* Containers on the same network can **refer to each other by name**
* Networks help **segregate traffic and improve security**

💻 **Basic Commands**

```bash
# List networks
docker network ls

# Create a custom network
docker network create mynetwork

# Run container attached to a network
docker run -d --name web --network mynetwork myapp:1.0

# Inspect network
docker network inspect mynetwork
```

💡 **Real-world scenario:**

* In microservices, Docker networks allow a **web container to communicate with a database container** using container names instead of IPs, simplifying configuration in CI/CD or production deployments.

---
## Q40: Default Docker Network Types

🧠 **Overview**
Docker creates **three default networks** when installed: `bridge`, `host`, and `none`. Each has specific use cases.

| Network Type | Description                                                                              | Use Case / Real-world                                                                |
| ------------ | ---------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| **bridge**   | Default network for containers; provides **private internal networking** and NAT to host | Most common for standalone containers or simple multi-container apps                 |
| **host**     | Container **shares the host’s network stack**; no isolation                              | High-performance apps needing direct access to host network, e.g., monitoring agents |
| **none**     | Container has **no network**; isolated completely                                        | Security testing or fully isolated containers                                        |

💻 **Example Commands**

```bash
# List networks
docker network ls

# Run container on default bridge network
docker run -d --name web myapp:1.0
```

✅ **Explanation:**

* By default, containers use the **bridge network** unless specified otherwise
* `host` bypasses network isolation, `none` disables networking completely

💡 **Real-world scenario:**

* Most CI/CD pipelines and development setups use **bridge network** for communication between app and database containers.
* `host` may be used for performance-critical tools like network monitoring agents.

---
# Intermediate
## Q41: What is the Docker daemon?

🧠 **Overview**

* The **Docker daemon (`dockerd`)** is a background service that manages Docker objects: **containers, images, networks, and volumes**.
* It **listens for Docker API requests** and performs container lifecycle operations.

💡 **Key Points**

* Runs as a **background process** on the host machine.
* Can be controlled via the **Docker CLI** (`docker` commands) or REST API.
* Responsible for **building, running, and distributing containers**.
* Requires **root or sudo** privileges to run.

⚡ **Real-world example**

```bash
sudo systemctl start docker    # Starts the Docker daemon
sudo systemctl status docker   # Checks daemon status
docker run hello-world         # CLI sends request to daemon to run a container
```

* Here, the CLI command `docker run` communicates with the **daemon**, which pulls the image, creates, and runs the container.

✅ **Notes**

* On Linux, it’s `dockerd`. On Windows/macOS, it runs inside a lightweight VM.
* Multiple clients (CLI, API) can talk to the same daemon, enabling **remote management**.

----

## Q42: What is the Docker client?

🧠 **Overview**

* The **Docker client (`docker`)** is a command-line tool that allows users to **interact with the Docker daemon**.
* It **sends commands** to the daemon via **REST API** or sockets to manage containers, images, networks, and volumes.

💡 **Key Points**

* Acts as the **user interface** for Docker.
* Can run on the **same host as the daemon** or remotely.
* Examples of common commands: `docker run`, `docker build`, `docker ps`.

⚡ **Real-world example**

```bash
docker ps             # Lists all running containers
docker pull nginx     # Pulls the nginx image from Docker Hub
docker run -d -p 80:80 nginx  # Starts nginx container in detached mode
```

* These commands are sent from the **client to the daemon**, which executes the requested operations.

✅ **Notes**

* CLI is **stateless** — all state is managed by the daemon.
* Supports **remote Docker hosts** via `DOCKER_HOST` environment variable:

```bash
export DOCKER_HOST=tcp://192.168.1.10:2375
docker ps
```

* Useful for **centralized container management** in a multi-host setup.

----
## Q43: How does the Docker client communicate with the daemon?

🧠 **Overview**

* The **Docker client** communicates with the **Docker daemon** using the **Docker REST API** over a **socket or TCP connection**.
* The client sends commands, and the daemon executes them and returns responses.

💡 **Communication Methods**

| Method                                   | Description                                 | Example                          |
| ---------------------------------------- | ------------------------------------------- | -------------------------------- |
| **Unix socket (default on Linux/macOS)** | Local communication between client & daemon | `/var/run/docker.sock`           |
| **TCP socket**                           | Remote communication over network           | `tcp://192.168.1.10:2375`        |
| **Windows named pipe**                   | Local communication on Windows              | `npipe:////./pipe/docker_engine` |

⚡ **Real-world example**

```bash
# Local (Unix socket)
docker ps  

# Remote (TCP)
export DOCKER_HOST=tcp://192.168.1.10:2375
docker run nginx
```

* `docker ps` → client sends REST API request → daemon reads `/var/run/docker.sock` → returns container list.
* Remote TCP example allows managing Docker on another server.

✅ **Notes**

* Unix socket is **secure**; TCP needs **TLS for encryption**.
* All operations go through the **daemon**, the client itself doesn’t execute containers.

----
## Q44: What is the Docker registry?

🧠 **Overview**

* A **Docker registry** is a **storage and distribution system for Docker images**.
* It allows users to **push (upload) and pull (download) images** for container deployment.

💡 **Key Points**

* **Public registry:** Docker Hub (most common, open to everyone).
* **Private registry:** Hosted internally (e.g., Harbor, AWS ECR, GCP Artifact Registry) for proprietary images.
* Supports **versioning** via **tags** (e.g., `nginx:1.25`).

⚡ **Real-world example**

```bash
# Pulling an image from Docker Hub
docker pull nginx:latest  

# Tagging an image for private registry
docker tag my-app:latest myregistry.example.com/my-app:1.0  

# Pushing to private registry
docker push myregistry.example.com/my-app:1.0
```

* Here, Docker client communicates with the **registry** to upload/download images.
* Tagging ensures the correct version is stored and retrieved.

✅ **Notes**

* Registries can be **public or private** depending on security needs.
* Integration with CI/CD pipelines allows **automatic image build and push** after code changes.
* Supports **image layers**, which makes storage efficient — only layers that change are updated.

---
## Q45: Difference between Docker Hub and a Private Registry

| Feature         | **Docker Hub**                                              | **Private Registry**                                                  |
| --------------- | ----------------------------------------------------------- | --------------------------------------------------------------------- |
| **Access**      | Public by default; anyone can pull images                   | Restricted; controlled by organization                                |
| **Hosting**     | Hosted by Docker Inc.                                       | Hosted internally (on-prem) or cloud (AWS ECR, GCP Artifact Registry) |
| **Security**    | Standard security; supports private repos with subscription | Full control over access, authentication, and network                 |
| **Cost**        | Free tier for public repos; paid for private                | Depends on infrastructure and storage costs                           |
| **Use case**    | Open-source images, community sharing                       | Proprietary images, enterprise compliance                             |
| **Integration** | Works with any Docker client                                | Works with Docker client, CI/CD pipelines, and IAM integration        |
| **Example**     | `docker pull nginx:latest`                                  | `docker push myregistry.example.com/my-app:1.0`                       |

⚡ **Scenario**

* **Docker Hub:** You pull `ubuntu:22.04` for a dev environment — quick, public, no setup.
* **Private Registry:** Your company stores proprietary microservices images, only accessible internally, ensuring **security and compliance**.

----
## Q46: How to Set Up a Private Docker Registry

🧠 **Overview**

* A **private Docker registry** allows you to securely store and manage Docker images internally.
* Can be **hosted on-premises** or in the cloud (AWS ECR, GCP Artifact Registry).

💡 **Steps to Set Up On-Prem Private Registry**

1. **Run Docker Registry container**

```bash
docker run -d -p 5000:5000 --name registry registry:2
```

* `registry:2` → official Docker Registry image
* `-p 5000:5000` → exposes registry on port 5000

2. **Tag your image for the registry**

```bash
docker tag my-app:latest localhost:5000/my-app:latest
```

* `localhost:5000` points to your private registry
* Tagging tells Docker where to push the image

3. **Push the image**

```bash
docker push localhost:5000/my-app:latest
```

* Uploads the image to your private registry

4. **Pull the image**

```bash
docker pull localhost:5000/my-app:latest
```

* Retrieve the image from the registry

5. **Optional: Enable TLS & authentication**

```bash
docker run -d -p 5000:5000 \
  --restart=always \
  -v /certs:/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  registry:2
```

* Ensures **secure connections** and optionally **basic auth** for access control

✅ **Real-world notes**

* For production, always use **TLS + authentication**.
* Can integrate with **CI/CD pipelines**: Jenkins/GitLab pipelines push new images automatically.
* Cloud options (AWS ECR, GCP Artifact Registry, Azure ACR) simplify authentication and scaling.

----
## Q47: What is Docker Content Trust (DCT)

🧠 **Overview**

* **Docker Content Trust (DCT)** is a security feature that **ensures the authenticity and integrity of Docker images** using **digital signatures**.
* It prevents pulling or running images that are **unsigned or tampered with**.

💡 **Key Points**

* Enabled via **Notary** in Docker.
* Uses **public/private key cryptography** to sign images.
* Helps in **supply chain security**, ensuring only trusted images are deployed.

⚡ **Real-world example**

```bash
# Enable Docker Content Trust
export DOCKER_CONTENT_TRUST=1

# Pull an image (only signed images will be pulled)
docker pull my-app:latest

# Push a signed image
docker push my-app:latest
```

* With DCT enabled, Docker **refuses unsigned images**, reducing security risks in production.

✅ **Notes**

* Default: DCT is **disabled**, so unsigned images are allowed.
* Works well in **CI/CD pipelines** to enforce trusted image usage.
* Key management: Private keys are used to sign, public keys are used to verify.

----
## Q48: How to Sign and Verify Docker Images

🧠 **Overview**

* Docker images can be **signed** to guarantee integrity and origin.
* **Signing** uses Docker Content Trust (DCT) with Notary; **verification** ensures the image is trusted before pulling or running.

💡 **Steps**

1. **Enable Docker Content Trust**

```bash
export DOCKER_CONTENT_TRUST=1
```

* Activates signing and verification for Docker operations.

2. **Sign an image (push with DCT)**

```bash
docker tag my-app:latest myregistry.example.com/my-app:1.0
docker push myregistry.example.com/my-app:1.0
```

* On push, Docker automatically **creates a digital signature** with your private key.
* Requires first-time setup of **signing keys** (Docker prompts to generate them).

3. **Verify an image**

```bash
docker pull myregistry.example.com/my-app:1.0
```

* Docker verifies the **signature** against the public key in the registry.
* Pull **fails** if the image is unsigned or altered.

4. **Check signatures manually (optional)**

```bash
notary list myregistry.example.com/my-app
```

* Lists all **signed tags** and signing keys.

✅ **Real-world notes**

* Ensures **only trusted images** are deployed in production.
* Common in **secure CI/CD pipelines** to prevent unverified images from reaching clusters.
* Works with **private registries** and Docker Hub.

----
## Q49: What are Docker Image Layers

🧠 **Overview**

* A **Docker image** is built in **layers**, each representing a filesystem change (e.g., adding a file, installing a package).
* Layers are **stacked**, forming the final image.

💡 **Key Points**

* **Immutable:** Once created, layers don’t change; new layers are added for updates.
* **Shared:** Common layers between images are reused, saving disk space and bandwidth.
* **Cached:** Layers enable **faster builds** by reusing unchanged layers.

⚡ **Real-world example** (`Dockerfile`)

```dockerfile
FROM ubuntu:22.04       # Layer 1: base OS
RUN apt-get update      # Layer 2: updates
RUN apt-get install -y nginx  # Layer 3: installs nginx
COPY app/ /var/www/html/      # Layer 4: app code
```

* Each instruction creates a **new layer**.
* If only `COPY app/` changes, **previous layers are cached**, speeding up rebuilds.

✅ **Notes**

* Layers are identified by **SHA256 hashes**.
* **Minimize layers** to reduce image size (combine commands with `&&`).
* Understanding layers is important for **efficient CI/CD pipelines and registry storage**.

---
## Q50: How Layer Caching Works in Docker

🧠 **Overview**

* Docker **caches image layers** during builds to **avoid rebuilding unchanged steps**, improving speed and efficiency.
* Each instruction in a `Dockerfile` creates a **layer**, and Docker reuses layers if the instruction and its context haven’t changed.

💡 **Key Points**

* **Cache hit:** Docker reuses an existing layer if nothing changed.
* **Cache miss:** Docker rebuilds the layer and all subsequent layers.
* **Order matters:** Layers earlier in the Dockerfile are reused more effectively; changes in early layers invalidate later cached layers.

⚡ **Real-world example** (`Dockerfile`)

```dockerfile
FROM ubuntu:22.04           # Layer 1
RUN apt-get update          # Layer 2
RUN apt-get install -y nginx  # Layer 3
COPY app/ /var/www/html/      # Layer 4
```

* If only the `app/` folder changes, Docker **reuses layers 1–3** and rebuilds **only layer 4**, saving time.

✅ **Notes**

* Use **`--no-cache`** to force rebuild:

```bash
docker build --no-cache -t my-app:latest .
```

* Combine commands with `&&` to **reduce layer count** and improve caching efficiency.
* Layer caching is crucial in **CI/CD pipelines** for faster image builds and reduced network usage.

---
## Q51: Difference Between `ADD` and `COPY` (Layer Optimization)

| Feature                  | **COPY**                                | **ADD**                                                                                   |
| ------------------------ | --------------------------------------- | ----------------------------------------------------------------------------------------- |
| **Purpose**              | Copy local files/directories into image | Copy files + extra features                                                               |
| **URL support**          | ❌ Only local files                      | ✅ Can fetch files from remote URLs                                                        |
| **Automatic extraction** | ❌ Does not extract archives             | ✅ Automatically extracts `.tar`, `.tar.gz`, `.zip`                                        |
| **Best practice**        | ✅ Preferred for **simple file copy**    | ⚠ Use only if archive extraction or URL fetch needed                                      |
| **Layer impact**         | Creates one layer per instruction       | Creates one layer, but may include unnecessary files if URL or archive adds extra content |

⚡ **Example**

```dockerfile
# COPY - safer, predictable
COPY app/ /var/www/html/

# ADD - can fetch & extract archive
ADD https://example.com/app.tar.gz /var/www/html/
```

* **COPY**: Predictable, smaller layers → better caching.
* **ADD**: Convenience, but may **invalidate caching** due to changing URLs or archive content.

✅ **Notes**

* For **layer optimization**, prefer `COPY` to keep layers minimal and cache-friendly.
* Use `ADD` only when **URL download or archive extraction** is required.

----
## Q52: How to Optimize Dockerfile Layer Caching

🧠 **Overview**

* Optimizing layer caching **speeds up builds**, reduces network usage, and minimizes image size.
* Focus on **ordering, minimizing layers, and separating frequently changing steps**.

💡 **Best Practices**

1. **Order instructions from least to most frequently changing**

```dockerfile
# Base OS rarely changes → cache reused
FROM ubuntu:22.04  
RUN apt-get update && apt-get install -y nginx  

# Application code changes often → put last
COPY app/ /var/www/html/
```

2. **Combine commands to reduce layers**

```dockerfile
# Instead of multiple RUN statements
RUN apt-get update
RUN apt-get install -y curl git

# Combine into one layer
RUN apt-get update && apt-get install -y curl git
```

3. **Use `.dockerignore`**

* Exclude unnecessary files to **avoid cache invalidation**:

```
node_modules
*.log
.git
```

4. **Pin base images and dependencies**

* Prevents cache invalidation when upstream images change unexpectedly:

```dockerfile
FROM python:3.11.5-slim
```

5. **Separate frequently changing steps**

* Copy config or code **after installing dependencies** to reuse base layers:

```dockerfile
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY src/ /app/
```

✅ **Real-world notes**

* CI/CD pipelines benefit from **fast incremental builds** using optimized caching.
* Smaller, fewer layers → faster **push/pull** to registries.
* Use **`docker build --cache-from`** in pipelines for remote cache reuse.

----
## Q53: What is a Multi-Stage Build in Docker

🧠 **Overview**

* A **multi-stage build** allows you to use **multiple `FROM` statements** in a Dockerfile.
* Helps **separate build environment from runtime environment**, producing **smaller, optimized images**.

💡 **Key Points**

* First stage: build or compile your application.
* Later stage(s): copy only the **artifacts needed to run**.
* Reduces image size and **improves security** by excluding build tools.

⚡ **Real-world example** (`Dockerfile`)

```dockerfile
# Stage 1: Build
FROM golang:1.21 AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp

# Stage 2: Runtime
FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/myapp .
CMD ["./myapp"]
```

* `golang:1.21` has compilers → build stage.
* `alpine:3.18` is minimal → runtime stage.
* Final image contains only **compiled binary**, not build tools.

✅ **Notes**

* Saves **disk space** and **reduces attack surface**.
* Ideal for **compiled languages** (Go, Java, C++), but also useful for **frontend apps** (Node → static files).
* Supports **naming stages** with `AS` and copying selectively with `--from`.

----
## Q54: Why Use Multi-Stage Builds

🧠 **Overview**

* Multi-stage builds are used to **create smaller, cleaner, and more secure Docker images** by separating build-time dependencies from runtime.

💡 **Key Benefits**

| Benefit                | Explanation                                              | Example/Scenario                                                           |
| ---------------------- | -------------------------------------------------------- | -------------------------------------------------------------------------- |
| **Smaller image size** | Only copy necessary artifacts, exclude compilers & tools | Go app: final image ~5MB instead of 700MB with build tools                 |
| **Improved security**  | Build tools and secrets are not in final image           | No Node.js compiler or credentials in production container                 |
| **Cleaner builds**     | Isolate build environment from runtime                   | Use different OS or base images per stage (Ubuntu → Alpine)                |
| **Better caching**     | Each stage can leverage caching independently            | Dependencies cached in build stage, code changes don’t invalidate OS layer |
| **Flexibility**        | Copy only required artifacts selectively                 | Multiple microservices built in one Dockerfile                             |

⚡ **Real-world scenario**

* **Frontend build**:

  * Stage 1: Build React app using Node.js → generates static files
  * Stage 2: Copy static files into lightweight Nginx image → deploy production-ready image

✅ **Notes**

* Recommended for **production-ready images** to reduce storage, network transfer, and runtime attack surface.
* Works well in **CI/CD pipelines** for efficient automated builds.

---
## Q55: How Multi-Stage Builds Reduce Image Size

🧠 **Overview**

* Multi-stage builds **separate the build environment from the runtime**, copying only the necessary artifacts to the final image.
* This eliminates **compilers, libraries, and temporary files**, reducing the overall image size.

💡 **Key Points**

| Feature                        | Explanation                                                                                      |
| ------------------------------ | ------------------------------------------------------------------------------------------------ |
| **Only copy artifacts**        | Use `COPY --from=builder` to move compiled binaries or static files, not full build environment  |
| **Exclude unnecessary layers** | Build tools, caches, and source code remain in intermediate layers, not in final image           |
| **Lightweight base image**     | Final stage can use minimal OS (Alpine, scratch) instead of heavy build image (Ubuntu, Node, Go) |

⚡ **Real-world example**

```dockerfile
# Stage 1: Build
FROM golang:1.21 AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp

# Stage 2: Runtime
FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/myapp .
CMD ["./myapp"]
```

* **Builder stage:** 700MB (includes Go compiler & libraries)
* **Final stage:** ~5MB (only the compiled binary)
* Result: **drastically smaller image**, faster pulls, and less storage usage.

✅ **Notes**

* Essential for **production deployments** to reduce network transfer and improve security.
* Works well in **CI/CD pipelines** with caching for faster incremental builds.

---
## Q56: What is the `.dockerignore` File

🧠 **Overview**

* The `.dockerignore` file tells Docker **which files or directories to exclude** when building an image.
* Similar to `.gitignore`, it **reduces build context size**, speeds up builds, and prevents sensitive files from being included in the image.

💡 **Key Points**

* Placed in the **root of the build context**.
* Supports **wildcards and patterns**.
* Helps **optimize caching** by ignoring frequently changing files that don’t affect the image.

⚡ **Real-world example**

```
# .dockerignore
node_modules
*.log
.git
.env
```

```bash
docker build -t my-app:latest .
```

* Docker ignores `node_modules`, `.git` folder, logs, and `.env` files during the build.
* Result: **smaller build context**, faster image build, and no sensitive data in layers.

✅ **Notes**

* Essential for **large projects** to avoid unnecessary files in images.
* Improves **CI/CD pipeline speed** and **layer caching efficiency**.
* Always review `.dockerignore` before building production images.

----
## Q57: How `.dockerignore` Improves Build Performance

🧠 **Overview**

* `.dockerignore` **excludes unnecessary files** from the Docker build context, reducing the amount of data sent to the Docker daemon.
* Smaller context → **faster builds, better caching, and less network usage**.

💡 **Key Points**

| Improvement                | Explanation                                                                |
| -------------------------- | -------------------------------------------------------------------------- |
| **Reduced build context**  | Only required files are sent to the daemon, lowering I/O and transfer time |
| **Better layer caching**   | Ignored files don’t invalidate layers, so unchanged layers are reused      |
| **Faster CI/CD pipelines** | Less data to transfer and process → quicker automated builds               |
| **Security**               | Prevents sensitive files from being included in image layers               |

⚡ **Real-world example**

```
# .dockerignore
node_modules
.git
*.log
.env
```

* Without `.dockerignore`: `node_modules` and `.git` are sent → slow build, large image.
* With `.dockerignore`: only necessary files are included → faster build and smaller image.

✅ **Notes**

* Especially important for **large projects** with many dependencies or heavy logs.
* Helps **optimize multi-stage builds** by keeping build context lean.

---
## Q58: What is the `ARG` Instruction in Dockerfile

🧠 **Overview**

* `ARG` defines **build-time variables** in a Dockerfile.
* Values are **only available during image build**, not at runtime.

💡 **Key Points**

* Can set a **default value** or override with `--build-arg`.
* Useful for **configurable builds** (versions, environment-specific settings).
* Unlike `ENV`, `ARG` **does not persist in the final image** unless explicitly used to set an `ENV`.

⚡ **Real-world example**

```dockerfile
# Dockerfile
ARG APP_VERSION=1.0
FROM python:3.11
RUN echo "Building version $APP_VERSION"
```

```bash
# Build with default version
docker build -t my-app .

# Build with custom version
docker build --build-arg APP_VERSION=2.0 -t my-app:v2 .
```

* `$APP_VERSION` is available **only during the build**.
* After build, `my-app` image does **not retain `APP_VERSION`** unless you set it as `ENV`.

✅ **Notes**

* Use `ARG` for **flexible, repeatable builds** in CI/CD pipelines.
* Combine with **multi-stage builds** to pass variables between stages.

---
## Q59: Difference Between `ARG` and `ENV` in Dockerfile

| Feature           | **ARG**                                      | **ENV**                                                   |
| ----------------- | -------------------------------------------- | --------------------------------------------------------- |
| **Scope**         | Build-time only                              | Runtime and build-time                                    |
| **Persistence**   | Not persisted in final image                 | Persisted in image layers                                 |
| **Default value** | Can have default; override via `--build-arg` | Can have default; override at runtime via `docker run -e` |
| **Access**        | Only available during `docker build`         | Available inside container at runtime                     |
| **Use case**      | Configure builds, versions, flags            | Environment configuration for containers                  |
| **Example**       | `ARG APP_VERSION=1.0`                        | `ENV APP_VERSION=1.0`                                     |

⚡ **Real-world example**

```dockerfile
# Dockerfile
ARG APP_VERSION=1.0
ENV APP_ENV=production

RUN echo "Building version $APP_VERSION"
CMD ["echo", "Running in $APP_ENV"]
```

```bash
docker build --build-arg APP_VERSION=2.0 -t my-app:v2 .
docker run -e APP_ENV=staging my-app:v2
```

* `APP_VERSION` is only used during build.
* `APP_ENV` persists in the running container and can be overridden at runtime.

✅ **Notes**

* **Use ARG** for build-time variables.
* **Use ENV** for runtime configuration inside the container.

---
## Q60: How to Pass Build-Time Variables to Docker Build

🧠 **Overview**

* Build-time variables are defined using `ARG` in the Dockerfile.
* Values are passed with the `--build-arg` option during `docker build`.

💡 **Steps**

1. **Define ARG in Dockerfile**

```dockerfile
# Dockerfile
ARG APP_VERSION=1.0
FROM python:3.11
RUN echo "Building version $APP_VERSION"
```

2. **Pass value during build**

```bash
docker build --build-arg APP_VERSION=2.0 -t my-app:v2 .
```

* `$APP_VERSION` is **used during the build**, overriding the default `1.0`.

3. **Multiple build args**

```bash
docker build --build-arg APP_VERSION=2.0 --build-arg DEBUG=true -t my-app:v2 .
```

✅ **Notes**

* Build-time variables **do not persist** in the final image unless explicitly set as `ENV`.
* Useful in **CI/CD pipelines** to dynamically configure builds (e.g., different versions or dependencies).
* Can be combined with **multi-stage builds** to pass variables between stages.

----
## Q61: What are Docker Build Contexts

🧠 **Overview**

* The **build context** is the **set of files and directories** that Docker has access to during a `docker build`.
* It’s sent from the client to the Docker daemon and forms the **context in which Dockerfile instructions are executed**.

💡 **Key Points**

* Specified as the **last argument** in `docker build`:

```bash
docker build -t my-app:latest ./app
```

* In this example, `./app` is the **build context**.
* All `COPY` and `ADD` instructions **refer to files inside the build context**.
* Large build contexts **slow down builds** and can waste cache efficiency.

⚡ **Real-world example**

```
project/
├─ Dockerfile
├─ src/
├─ node_modules/
├─ logs/
```

* Build context is `project/`.
* Without `.dockerignore`, `node_modules` and `logs` are sent → slow build.
* With `.dockerignore`, only `Dockerfile` and `src/` are sent → faster build and smaller context.

✅ **Notes**

* Always keep **build context minimal** using `.dockerignore`.
* Docker cannot access files **outside the build context** in `COPY` or `ADD`.
* Proper build context improves **layer caching** and **CI/CD pipeline speed**.

---
## Q62: Difference Between `ENTRYPOINT` and `CMD` in Dockerfile

| Feature               | **ENTRYPOINT**                                               | **CMD**                                                                                    |
| --------------------- | ------------------------------------------------------------ | ------------------------------------------------------------------------------------------ |
| **Purpose**           | Defines the **main executable** for the container            | Provides **default arguments** to ENTRYPOINT or runs a command if no ENTRYPOINT is defined |
| **Override behavior** | Hard to override at `docker run` unless using `--entrypoint` | Easily overridden by arguments passed at `docker run`                                      |
| **Syntax**            | `ENTRYPOINT ["executable", "param"]` (exec form recommended) | `CMD ["param1","param2"]` or `CMD command`                                                 |
| **Multiple allowed**  | Only one `ENTRYPOINT` is effective; last one wins            | Only last `CMD` is used                                                                    |
| **Use case**          | Set a **fixed container process**                            | Set **default arguments** or fallback command                                              |

⚡ **Real-world example**

```dockerfile
# Dockerfile
FROM ubuntu:22.04

ENTRYPOINT ["echo"]
CMD ["Hello, World!"]
```

```bash
docker run my-image          # Output: Hello, World!
docker run my-image "Hi!"    # Output: Hi!
```

* `ENTRYPOINT` defines the **executable (`echo`)**.
* `CMD` provides **default arguments** (`Hello, World!`) that can be overridden.

✅ **Notes**

* Combine `ENTRYPOINT` + `CMD` for **flexible yet controlled containers**.
* `ENTRYPOINT` ensures a fixed process runs; `CMD` makes it configurable.

---
## Q63: How to Override `CMD` at Runtime

🧠 **Overview**

* `CMD` provides **default arguments or a default command** in a Dockerfile.
* You can **override it easily** by specifying a new command when running the container.

💡 **Example**

```dockerfile
# Dockerfile
FROM ubuntu:22.04
CMD ["echo", "Hello, World!"]
```

```bash
# Run with default CMD
docker run my-image
# Output: Hello, World!

# Override CMD at runtime
docker run my-image echo "Hi there!"
# Output: Hi there!
```

* Docker replaces the `CMD` instruction with **what you provide at `docker run`**.
* Works for **both exec form** (`["echo", "text"]`) and **shell form** (`echo Hello`) of CMD.

✅ **Notes**

* `CMD` **cannot override ENTRYPOINT**; it provides default arguments to ENTRYPOINT.
* Useful for **flexible container behavior** in production or CI/CD pipelines.

----
## Q64: How to Override `ENTRYPOINT` at Runtime

🧠 **Overview**

* `ENTRYPOINT` defines the **fixed executable** for a container.
* You can override it **using the `--entrypoint` flag** when running the container.

💡 **Example**

```dockerfile
# Dockerfile
FROM ubuntu:22.04
ENTRYPOINT ["echo"]
CMD ["Hello, World!"]
```

```bash
# Default behavior
docker run my-image
# Output: Hello, World!

# Override ENTRYPOINT
docker run --entrypoint /bin/bash my-image -c "echo Hi there!"
# Output: Hi there!
```

* `--entrypoint` replaces the Dockerfile’s `ENTRYPOINT`.
* CMD can still provide **default arguments** if ENTRYPOINT isn’t overridden.

✅ **Notes**

* ENTRYPOINT override is less common; used for **debugging or alternative execution**.
* Combining `ENTRYPOINT` + CMD allows **flexible yet controlled containers**.

---
## Q65: What is the `SHELL` Instruction in Dockerfile

🧠 **Overview**

* The `SHELL` instruction **changes the default shell** used for `RUN`, `CMD`, and `ENTRYPOINT` instructions in the Dockerfile.
* Default shell: `/bin/sh -c` on Linux, `cmd /S /C` on Windows.

💡 **Key Points**

* Useful when you need **specific shell features** (e.g., Bash arrays, scripts).
* Affects **all subsequent instructions** until another `SHELL` is declared.
* Supports **exec form** (`["/bin/bash", "-c"]`) and **shell form** (`/bin/bash -c`).

⚡ **Real-world example**

```dockerfile
FROM ubuntu:22.04

# Change default shell to bash with -eux flags
SHELL ["/bin/bash", "-eux", "-o", "pipefail", "-c"]

RUN echo "Current shell: $SHELL" && ls -la
```

* `-eux` → prints commands, exits on errors
* `pipefail` → ensures failure in a pipe is detected

✅ **Notes**

* Useful for **complex scripts** during image build.
* Works well in **CI/CD pipelines** where robust error handling is required.
* Can reduce errors caused by shell differences across base images.

----
## Q66: What Are Docker Bridge Networks

🧠 **Overview**

* A **bridge network** is Docker’s **default network type** for containers on a single host.
* Provides **container-to-container communication** via private IPs while **isolating them from the host network**.

💡 **Key Points**

* **Default network:** `bridge` is automatically created.
* **Containers get private IPs** in the bridge subnet.
* **Port mapping** (`-p hostPort:containerPort`) exposes containers to the host.
* Supports **container name resolution** via DNS within the bridge network.

⚡ **Real-world example**

```bash
# Create a custom bridge network
docker network create my-bridge-network

# Run containers on the bridge
docker run -d --name web --network my-bridge-network nginx
docker run -d --name app --network my-bridge-network my-app

# Containers can communicate internally
docker exec app ping web
```

* `web` and `app` can talk using **container names** (`web`) as DNS.
* Host can access `web` via mapped port (e.g., `-p 8080:80`).

✅ **Notes**

* Use **custom bridge networks** for better DNS resolution and isolation.
* Suitable for **multi-container apps on the same host** (e.g., web + database).
* Avoid using default bridge for production; custom bridges offer **predictable subnets and names**.

----
## Q67: What Are Docker Host Networks

🧠 **Overview**

* A **host network** makes a container **share the host’s network stack**.
* The container **uses the host’s IP address** and does **not get a separate network namespace**.

💡 **Key Points**

* No port mapping is required; container ports are **directly accessible** via host IP.
* Provides **low-latency network performance**.
* Only available on **Linux hosts** (Windows doesn’t support host mode).

⚡ **Real-world example**

```bash
# Run container on host network
docker run --network host nginx
```

* `nginx` listens on the host’s ports directly.
* Example: container port 80 is immediately accessible at host IP:80.

✅ **Notes**

* Pros: faster network, simpler configuration.
* Cons: **no network isolation**, port conflicts possible, less secure.
* Use cases: **high-performance services** or containers needing host network access (e.g., monitoring agents, network tools).

----
## Q68: What Are Docker Overlay Networks

🧠 **Overview**

* An **overlay network** allows containers running on **different Docker hosts** to communicate securely as if they were on the same network.
* Commonly used in **Docker Swarm or multi-host setups**.

💡 **Key Points**

* **Encapsulates container traffic** using VXLAN tunneling between hosts.
* Supports **service discovery and DNS** across hosts.
* Requires a **key-value store** (built-in Swarm or external like Consul/Etcd) to manage network state.

⚡ **Real-world example (Docker Swarm)**

```bash
# Create an overlay network
docker network create -d overlay my-overlay-network

# Deploy services on the overlay
docker service create --name web --network my-overlay-network nginx
docker service create --name app --network my-overlay-network my-app
```

* `web` and `app` can communicate across **different swarm nodes** using service names.

✅ **Notes**

* Ideal for **microservices across multiple hosts**.
* Provides **isolation, secure communication, and service discovery**.
* Requires **Swarm mode** or **Docker Enterprise** for multi-host orchestration.

---
## Q69: When to Use Overlay Networks

🧠 **Overview**

* Overlay networks are used when you need **secure container communication across multiple Docker hosts**.
* Common in **Swarm, Kubernetes, or multi-host deployments**.

💡 **Use Cases / Scenarios**

| Scenario                       | Explanation                                                                          |
| ------------------------------ | ------------------------------------------------------------------------------------ |
| **Multi-host container apps**  | Containers on different physical/virtual hosts can communicate as if on the same LAN |
| **Microservices architecture** | Services (web, app, DB) across nodes can discover each other using service names     |
| **Swarm mode deployments**     | Overlay networks enable **service-to-service networking** across swarm nodes         |
| **Isolation & segmentation**   | Create multiple overlay networks to **segregate traffic** between services           |
| **Secure communication**       | Traffic is **encapsulated in VXLAN**, reducing exposure to host network              |

⚡ **Real-world example**

* E-commerce app with 3 services (frontend, backend, database) running on 3 different servers.
* Using overlay network, **frontend on host A** can securely talk to **backend on host B** and **DB on host C**.

✅ **Notes**

* Only needed for **multi-host setups**; for single-host, bridge network is sufficient.
* Overlay networks are **key for orchestrated environments** like Docker Swarm or Kubernetes.

----
## Q70: What Is the `none` Network in Docker

🧠 **Overview**

* The `none` network disables networking for a container.
* The container **does not get a network interface**, IP, or DNS.
* Useful for **isolated or highly secure containers**.

💡 **Key Points**

* Default `none` network: no bridge, host, or overlay connectivity.
* Container can still communicate via **localhost inside itself**, but **cannot reach other containers or the host**.
* Manual networking can be added later using `docker network connect`.

⚡ **Real-world example**

```bash
docker run --network none --name isolated-container alpine
```

* `isolated-container` has **no external network access**.
* Use cases: running **secure tasks, experiments, or builds** that don’t need network access.

✅ **Notes**

* Provides **maximum isolation** from host and other containers.
* Often used in **security-sensitive environments** or **sandboxed testing**.
* Can combine with **volumes** to access necessary files without network access.

----
## Q71: How Containers Communicate on the Same Network

🧠 **Overview**

* Containers on the **same Docker network** can communicate using **container names or IP addresses**.
* Docker provides **built-in DNS resolution** for networks like **bridge, overlay, or custom networks**.

💡 **Key Points**

* Each container gets a **private IP** in the network subnet.
* **Container names act as DNS entries**, simplifying service-to-service communication.
* Works for **bridge, overlay, or user-defined networks**, not `none` network.

⚡ **Real-world example**

```bash
# Create a custom network
docker network create my-network

# Run containers on the same network
docker run -d --name web --network my-network nginx
docker run -d --name app --network my-network my-app

# Ping between containers
docker exec app ping web
```

* `app` can reach `web` using **container name `web`**.
* No need to manually manage IPs; Docker’s **internal DNS** resolves names automatically.

✅ **Notes**

* Use **custom networks** for better isolation and DNS resolution.
* Essential in **multi-container applications** (web + DB + cache) for internal communication.
* Overlay networks extend this communication **across multiple hosts**.

---
## Q72: How to Connect a Container to Multiple Networks

🧠 **Overview**

* Docker allows a container to **join more than one network** for **multi-network communication**.
* Useful when a container needs **internal communication on one network** and **external access on another**.

💡 **Key Points**

* Use `--network` at `docker run` for the **first network**.
* Use `docker network connect` to **attach additional networks** to a running container.
* Container can communicate with other containers on each connected network using **container names or IPs**.

⚡ **Real-world example**

```bash
# Create networks
docker network create frontend
docker network create backend

# Run container on first network
docker run -d --name app --network frontend my-app

# Connect to second network
docker network connect backend app

# Verify networks
docker inspect app --format '{{json .NetworkSettings.Networks}}'
```

* `app` can now talk to containers on **frontend** and **backend** networks.

✅ **Notes**

* Useful for **multi-tier apps**, e.g., web app on frontend network, database access on backend network.
* Helps **isolate traffic**, improving security and management.
* Supports **bridge, overlay, and custom networks**, but `none` cannot be connected.

---
## Q73: What Is Docker DNS and How Does It Work

🧠 **Overview**

* Docker provides **built-in DNS** for containers on user-defined networks.
* It allows containers to **resolve each other by name** instead of manually using IPs.

💡 **Key Points**

* **Automatic DNS resolution:** Container names act as hostnames.
* Works with **bridge, overlay, and custom networks**.
* Not available on the default `none` network.
* For multi-host (overlay) networks, Docker Swarm manages DNS across nodes.

⚡ **Real-world example**

```bash
# Create network
docker network create my-network

# Run containers on the network
docker run -d --name web --network my-network nginx
docker run -d --name app --network my-network my-app

# Container-to-container communication
docker exec app ping web
```

* `app` can resolve `web` using Docker DNS.
* No need to know or manage container IP addresses.

✅ **Notes**

* DNS simplifies **microservices communication**.
* Supports **service discovery** in Swarm mode.
* Avoid default bridge network for production; use **custom networks** for better DNS support and isolation.

----
## Q74: How to Create a Custom Docker Network

🧠 **Overview**

* Custom networks give containers **better isolation, DNS resolution, and control** over subnets and IPs.
* Recommended over the default bridge network for **multi-container apps**.

💡 **Steps**

1. **Create a custom bridge network**

```bash
docker network create \
  --driver bridge \
  --subnet 192.168.10.0/24 \
  my-custom-network
```

* `--driver bridge` → type of network (bridge, overlay, macvlan)
* `--subnet` → optional, sets IP range

2. **Run containers on the network**

```bash
docker run -d --name web --network my-custom-network nginx
docker run -d --name app --network my-custom-network my-app
```

* Containers can communicate using **container names**.

3. **Inspect network**

```bash
docker network inspect my-custom-network
```

* Shows **connected containers, IPs, and configuration**.

✅ **Notes**

* Use **custom networks** for **service isolation, DNS resolution, and easier scaling**.
* Overlay networks are preferred for **multi-host communication**.
* Helps in **CI/CD pipelines** for predictable multi-container setups.

---
## Q75: Named Volumes vs Anonymous Volumes

| Feature         | **Named Volumes**                            | **Anonymous Volumes**                               |
| --------------- | -------------------------------------------- | --------------------------------------------------- |
| **Definition**  | Volumes with a specific name                 | Volumes automatically created without a name        |
| **Reference**   | Can be reused by multiple containers         | Only accessible by the container it was created for |
| **Persistence** | Persistent and can survive container removal | Can persist, but harder to manage; often temporary  |
| **Management**  | Easier to inspect, backup, and remove        | Managed by Docker, typically cleaned up with `--rm` |
| **Example**     | `docker run -v mydata:/data ubuntu`          | `docker run -v /data ubuntu`                        |

⚡ **Real-world example**

```bash
# Named volume
docker volume create mydata
docker run -d -v mydata:/app/data my-app

# Anonymous volume
docker run -d -v /app/data my-app
```

* Named volumes allow **sharing data between containers**.
* Anonymous volumes are convenient for **temporary or isolated container storage**.

✅ **Notes**

* Use **named volumes** for persistent data (databases, logs).
* Use **anonymous volumes** for short-lived data or disposable containers.
* Inspect volumes: `docker volume ls` and `docker volume inspect mydata`.

----
## Q76: How to Mount a Volume to a Container

🧠 **Overview**

* Volumes provide **persistent storage** for Docker containers, surviving container removal.
* Can be **named volumes, anonymous volumes, or host directories**.

💡 **Ways to Mount Volumes**

1. **Named volume**

```bash
docker volume create mydata
docker run -d -v mydata:/app/data my-app
```

* Mounts `mydata` volume to `/app/data` inside the container.
* Data persists even if the container is removed.

2. **Anonymous volume**

```bash
docker run -d -v /app/data my-app
```

* Docker creates a volume automatically.
* Data persists while the container exists; harder to manage.

3. **Bind mount (host directory)**

```bash
docker run -d -v /host/path:/container/path my-app
```

* Mounts host directory `/host/path` into the container.
* Useful for **dev environments or sharing files**.

✅ **Notes**

* Named volumes are preferred for **production data** (databases, logs).
* Bind mounts are useful for **development and local testing**.
* Inspect volumes: `docker volume ls` and `docker volume inspect mydata`.

---
## Q77: Difference Between `-v` and `--mount` Flags in Docker

| Feature                    | **`-v` / `--volume`**                             | **`--mount`**                                                                  |        |         |
| -------------------------- | ------------------------------------------------- | ------------------------------------------------------------------------------ | ------ | ------- |
| **Syntax**                 | Short, simple                                     | More verbose, explicit key-value pairs                                         |        |         |
| **Flexibility**            | Limited options                                   | Supports named volumes, bind mounts, tmpfs, and advanced options               |        |         |
| **Readability**            | Harder to read in complex setups                  | Clear and self-documenting                                                     |        |         |
| **Type specification**     | Implicit (bind or volume based on path)           | Explicit (`type=bind                                                           | volume | tmpfs`) |
| **Example (named volume)** | `docker run -v mydata:/app/data my-app`           | `docker run --mount type=volume,source=mydata,target=/app/data my-app`         |        |         |
| **Example (bind mount)**   | `docker run -v /host/path:/container/path my-app` | `docker run --mount type=bind,source=/host/path,target=/container/path my-app` |        |         |

⚡ **Key Points**

* `--mount` is **preferred for new scripts and CI/CD pipelines** due to clarity and flexibility.
* `-v` is **shorter** and widely used for simple cases.
* Both achieve the same functionality, but `--mount` **avoids ambiguity** in complex setups.

✅ **Notes**

* Use `--mount` when dealing with **multiple options**, like read-only volumes:

```bash
docker run --mount type=volume,source=mydata,target=/app/data,readonly my-app
```

---
## Q78: How to Share Volumes Between Containers

🧠 **Overview**

* Sharing volumes allows **multiple containers to read/write the same data**, useful for databases, logs, or config files.
* Achieved using **named volumes** or **bind mounts**.

💡 **Steps**

1. **Using Named Volumes**

```bash
# Create a named volume
docker volume create shared-data

# Run first container with the volume
docker run -d --name app1 -v shared-data:/app/data my-app

# Run second container with the same volume
docker run -d --name app2 -v shared-data:/app/data my-app
```

* `app1` and `app2` share `/app/data`.
* Changes in one container are immediately visible to the other.

2. **Using Bind Mounts**

```bash
docker run -d --name app1 -v /host/shared:/app/data my-app
docker run -d --name app2 -v /host/shared:/app/data my-app
```

* Both containers read/write files from **host directory `/host/shared`**.

✅ **Notes**

* Named volumes are preferred in **production** (managed by Docker).
* Bind mounts are useful for **development** (direct access to host files).
* Avoid anonymous volumes for sharing, as they are **container-specific and hard to manage**.

---
## Q79: What Are `tmpfs` Mounts in Docker

🧠 **Overview**

* `tmpfs` mounts store data **in memory (RAM)** instead of on disk.
* Useful for **temporary, fast, or sensitive data** that should not persist after the container stops.

💡 **Key Points**

* **Non-persistent:** Data disappears when the container stops.
* **Fast access:** Stored in memory, ideal for caching or ephemeral files.
* **Security:** Useful for **sensitive data**, avoiding disk writes.

⚡ **Real-world example**

```bash
# Mount tmpfs at /app/cache
docker run -d --name temp-container --tmpfs /app/cache:rw,size=100m my-app
```

* `size=100m` → limits RAM usage for tmpfs mount
* Data in `/app/cache` is **fast and ephemeral**

✅ **Notes**

* Cannot share `tmpfs` between containers.
* Works only on **Linux hosts**.
* Ideal for **build caches, session storage, or sensitive credentials** in memory.

---
## Q80: When to Use `tmpfs` Mounts

🧠 **Overview**

* `tmpfs` mounts are used for **temporary, high-speed, in-memory storage** inside containers.
* Data is **ephemeral** and does not persist after container stops.

💡 **Use Cases / Scenarios**

| Scenario                          | Explanation                                                               |
| --------------------------------- | ------------------------------------------------------------------------- |
| **Caching**                       | Store temporary build artifacts or computed data for fast access          |
| **Session or runtime data**       | Ephemeral data like user sessions that don’t need persistence             |
| **Sensitive data**                | Store secrets, tokens, or credentials in RAM to avoid disk writes         |
| **High-performance temp storage** | Applications needing very fast I/O (e.g., temporary files for processing) |
| **Testing / ephemeral workloads** | Containers that don’t need persistent storage between runs                |

⚡ **Real-world example**

```bash
docker run -d --tmpfs /app/cache:rw,size=100m my-app
```

* `/app/cache` is fast, in-memory storage that disappears when the container stops.

✅ **Notes**

* Cannot share between containers.
* Only supported on **Linux hosts**.
* Often combined with **CI/CD pipelines or ephemeral containers** for secure, fast temporary storage.

----
## Q81: What Is Docker’s Storage Driver

🧠 **Overview**

* Docker’s **storage driver** manages **how images and containers are stored and layered on disk**.
* Implements **copy-on-write (CoW)** to efficiently share and manage image layers.

💡 **Key Points**

* Determines **filesystem behavior**, performance, and features (e.g., snapshots, quotas).
* Each container and image layer is stored as a **filesystem snapshot**.
* Popular storage drivers: `overlay2` (default on Linux), `aufs`, `btrfs`, `devicemapper`, `zfs`.

⚡ **Real-world example**

```bash
# Check current storage driver
docker info | grep "Storage Driver"
```

* Example output: `Storage Driver: overlay2`
* Overlay2 uses **union filesystem**, stacking layers efficiently.

✅ **Notes**

* **overlay2** is preferred on modern Linux for performance and reliability.
* Storage drivers affect **image size, build speed, and container I/O performance**.
* Important in **CI/CD pipelines and production systems** for efficiency and stability.

----
## Q82: Available Docker Storage Drivers

🧠 **Overview**

* Storage drivers manage **how image layers and container filesystems are stored**.
* Choice of driver affects **performance, features, and stability**.

| Storage Driver   | Description                                                    | Key Points / Use Cases                                                                       |
| ---------------- | -------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| **overlay2**     | Default on modern Linux. Uses **overlay filesystem**           | Fast, efficient, supports copy-on-write, stable. Preferred for most deployments.             |
| **aufs**         | Advanced multi-layered filesystem (deprecated in many distros) | Supports multiple layers; used in older Ubuntu versions; slower than overlay2.               |
| **devicemapper** | Uses **block-level storage with device-mapper**                | Can provide thin provisioning; good for legacy systems; complex setup; slower than overlay2. |
| **btrfs**        | Built on **B-tree filesystem**, supports snapshots and CoW     | Advanced features; not widely used in production due to stability concerns.                  |
| **zfs**          | Advanced filesystem with CoW, snapshots, compression           | Useful for special setups needing filesystem-level features; heavier setup.                  |

⚡ **Check current storage driver**

```bash
docker info | grep "Storage Driver"
```

* Example output: `Storage Driver: overlay2`

✅ **Notes**

* **overlay2** is recommended for **modern Linux** due to simplicity, speed, and reliability.
* Storage driver choice affects **image build speed, layer sharing, and container I/O performance**.
* Some drivers require **specific kernel support**.

---
## Q83: How to Check Which Storage Driver Docker Is Using

🧠 **Overview**

* Docker uses a **storage driver** to manage images and container filesystems.
* Knowing the driver helps **troubleshoot performance, compatibility, and disk usage issues**.

💡 **Commands**

1. **Using `docker info`**

```bash
docker info | grep "Storage Driver"
```

* Example output: `Storage Driver: overlay2`

2. **Full storage info**

```bash
docker info
```

* Look for **Storage Driver** section, including **backing filesystem, pool name, and options**.

✅ **Notes**

* Default on modern Linux: `overlay2`.
* Older systems may use `aufs`, `devicemapper`, `btrfs`, or `zfs`.
* Storage driver choice affects **build speed, image layer management, and container I/O performance**.

---
## Q84: Container Filesystem vs Volumes

🧠 **Overview**

* **Container filesystem**: The writable layer created **on top of image layers** for each container.
* **Volumes**: Persistent storage stored **outside the container’s writable layer**, managed by Docker.

| Feature                 | **Container Filesystem**                    | **Volumes**                              |
| ----------------------- | ------------------------------------------- | ---------------------------------------- |
| **Persistence**         | Lost when container is removed              | Persists beyond container lifecycle      |
| **Storage Location**    | Inside container (copy-on-write layer)      | Docker-managed storage or host paths     |
| **Purpose**             | Container runtime filesystem (temp changes) | Persistent/shared data (databases, logs) |
| **Sharing**             | Not shareable between containers            | Can be shared across multiple containers |
| **Backup / Management** | Harder to manage and backup                 | Easy to inspect, backup, restore         |

⚡ **Real-world example**

```bash
# Container filesystem
docker run -it ubuntu
touch /tmp/file.txt
exit
# file.txt is gone when container removed

# Volume
docker volume create mydata
docker run -v mydata:/app/data my-app
# Data persists even after container removal
```

✅ **Notes**

* Use **container filesystem** for temporary, ephemeral data.
* Use **volumes** for persistent, shareable, or production-critical data.
* Best practice: keep **application state in volumes**, not in container layers.

----
## Q85: What Are Health Checks in Docker

🧠 **Overview**

* Health checks allow Docker to **monitor whether a container is healthy** or ready to serve requests.
* Defined in the Dockerfile or at runtime, Docker updates the container’s **health status** (`healthy`, `unhealthy`, `starting`).

💡 **Key Points**

* Useful for **orchestration tools** (Swarm, Kubernetes) to restart or reschedule unhealthy containers.
* Can check **HTTP endpoints, commands, or scripts**.
* Default: no health check; container considered healthy as long as it’s running.

⚡ **Real-world example** (`Dockerfile`)

```dockerfile
FROM nginx:alpine
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1
```

* Checks `http://localhost/` every 30 seconds.
* If command fails 3 times, container status becomes `unhealthy`.

✅ **Notes**

* Inspect container health:

```bash
docker ps
docker inspect --format='{{.State.Health.Status}}' <container_name>
```

* Helps **CI/CD pipelines and orchestrators** make decisions based on container readiness.
* Can reduce downtime by **automatically restarting unhealthy containers**.

---
## Q86: How to Define a `HEALTHCHECK` in Dockerfile

🧠 **Overview**

* `HEALTHCHECK` instructs Docker to **periodically test a container’s health** using a command or script.
* Updates container status: `starting`, `healthy`, or `unhealthy`.

💡 **Syntax**

```dockerfile
HEALTHCHECK [OPTIONS] CMD <command>
```

* **Options**:

  * `--interval=30s` → time between checks (default 30s)
  * `--timeout=5s` → max time for a check (default 30s)
  * `--start-period=5s` → initial delay before first check
  * `--retries=3` → number of consecutive failures before unhealthy

⚡ **Real-world example**

```dockerfile
FROM nginx:alpine

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1
```

* Checks the container’s HTTP endpoint every 30 seconds.
* Marks container `unhealthy` after 3 consecutive failures.

✅ **Notes**

* Can also **disable health checks** inherited from base images:

```dockerfile
HEALTHCHECK NONE
```

* Useful in **production** to let orchestrators (Swarm, Kubernetes) manage unhealthy containers.
* Health checks improve **reliability and monitoring** in CI/CD pipelines.

----
## Q87: Purpose of the `--health-cmd` Flag

🧠 **Overview**

* The `--health-cmd` flag is used with `docker run` to **define a container health check at runtime**, instead of in the Dockerfile.
* Docker executes this command **periodically** to determine if the container is healthy.

💡 **Key Points**

* Returns `0` → container is healthy
* Returns non-zero → container is unhealthy
* Works with other **health options**: `--health-interval`, `--health-retries`, `--health-timeout`, `--health-start-period`

⚡ **Real-world example**

```bash
docker run -d \
  --name my-nginx \
  --health-cmd="curl -f http://localhost/ || exit 1" \
  --health-interval=30s \
  --health-retries=3 \
  nginx:alpine
```

* Docker checks `http://localhost/` every 30 seconds.
* After 3 consecutive failures, container status becomes `unhealthy`.

✅ **Notes**

* Useful when **you don’t want to modify the Dockerfile**.
* Helps orchestrators and monitoring systems **react to container health** dynamically.
* Provides **flexibility for runtime environments** or temporary health policies.

---
## Q88: How to View Container Health Status

🧠 **Overview**

* Docker tracks **container health** when a `HEALTHCHECK` is defined.
* Health status can be **starting**, **healthy**, or **unhealthy**.

💡 **Commands**

1. **Using `docker ps`**

```bash
docker ps
```

* Adds a **`STATUS` column** showing health:

```
Up 5m (healthy)
Up 3m (unhealthy)
```

2. **Using `docker inspect`**

```bash
docker inspect --format='{{.State.Health.Status}}' <container_name>
```

* Output example: `healthy`

3. **Full health details**

```bash
docker inspect <container_name> | grep -i health -A 10
```

* Shows **last health check, retries, and output**.

✅ **Notes**

* Requires `HEALTHCHECK` to be defined in the Dockerfile or with `--health-cmd`.
* Useful in **CI/CD pipelines, orchestrators, or monitoring scripts** to react to unhealthy containers.
* Can combine with `docker events` to trigger alerts when a container becomes unhealthy.

---
## Q89: What Are Docker Restart Policies

🧠 **Overview**

* Restart policies control **how Docker handles container restarts** after failures or daemon restarts.
* Ensures **high availability** for critical services.

💡 **Key Points**

| Policy                     | Behavior                                                                       |
| -------------------------- | ------------------------------------------------------------------------------ |
| `no` (default)             | Do **not restart** automatically                                               |
| `always`                   | Always restart container if it stops, even after Docker daemon restart         |
| `unless-stopped`           | Like `always`, but **does not restart** if container was manually stopped      |
| `on-failure[:max-retries]` | Restart only if container exits with **non-zero status**; optional max retries |

⚡ **Real-world example**

```bash
# Always restart
docker run -d --restart always nginx

# Restart on failure, max 5 retries
docker run -d --restart on-failure:5 my-app
```

* Useful for **database, web servers, or microservices** in production.

✅ **Notes**

* Helps maintain **service uptime** in CI/CD, staging, or production environments.
* Combine with **health checks** for smarter restarts (only restart unhealthy containers).
* Policies are configurable at **runtime with `docker update`**:

```bash
docker update --restart=always <container_name>
```

----

## Q90: Difference Between Docker Restart Policies

| Policy             | Description                                                                 | Use Case / Behavior                                          |
| ------------------ | --------------------------------------------------------------------------- | ------------------------------------------------------------ |
| **no** (default)   | Do not restart automatically                                                | Default; container stops and stays stopped                   |
| **on-failure[:N]** | Restart only if exit code ≠ 0; optional max retries `N`                     | For error-prone processes; e.g., retry a failing job 3 times |
| **always**         | Always restart container if it stops, including after Docker daemon restart | Critical services needing high availability                  |
| **unless-stopped** | Like `always`, but **does not restart** if container was manually stopped   | Use for long-running apps you may occasionally stop manually |

⚡ **Real-world example**

```bash
docker run -d --restart no my-app         # Default, no automatic restart
docker run -d --restart on-failure:5 my-app  # Retry up to 5 times on failure
docker run -d --restart always nginx      # Always restart, even after Docker daemon restart
docker run -d --restart unless-stopped nginx # Restart unless manually stopped
```

✅ **Notes**

* Combine with **HEALTHCHECK** for smarter restarts (restart only unhealthy containers).
* Useful for **production microservices**, databases, and CI/CD worker containers.

----
## Q91: How to Set Resource Limits for Containers

🧠 **Overview**

* Docker allows you to **limit CPU, memory, and other resources** for containers to ensure **fair usage** and prevent one container from overwhelming the host.

💡 **Key Resource Options**

| Resource        | Flag / Option     | Description                                                         |
| --------------- | ----------------- | ------------------------------------------------------------------- |
| **CPU**         | `--cpus`          | Limit container CPU usage (e.g., `--cpus="1.5"` uses 1.5 CPU cores) |
| **Memory**      | `--memory` / `-m` | Max memory a container can use (e.g., `-m 512m`)                    |
| **Memory swap** | `--memory-swap`   | Total memory + swap available                                       |
| **CPU shares**  | `--cpu-shares`    | Relative weight for CPU allocation (default 1024)                   |
| **CPU set**     | `--cpuset-cpus`   | Bind container to specific CPU cores (e.g., `0,1`)                  |

⚡ **Real-world example**

```bash
docker run -d \
  --name my-app \
  --cpus="1.5" \
  -m 512m \
  --memory-swap 1g \
  nginx
```

* Limits container to **1.5 CPU cores**, **512MB memory**, and **1GB memory+swap**.

✅ **Notes**

* Helps in **production multi-container environments** to avoid resource contention.
* Can be used in **CI/CD pipelines** or local testing to simulate resource constraints.
* Resource limits can also be set in **Docker Compose** for multi-container apps.

----
## Q92: What Is the `--memory` Flag Used For

🧠 **Overview**

* The `--memory` (or `-m`) flag sets the **maximum memory limit** a container can use.
* Prevents a container from consuming more RAM than specified, protecting the host and other containers.

💡 **Key Points**

* Syntax: `-m 512m` or `--memory=1g`
* Combined with `--memory-swap` to limit **total memory + swap**.
* Exceeding memory limit can trigger **OOM (Out of Memory) kills**.

⚡ **Real-world example**

```bash
docker run -d --name my-app -m 512m nginx
```

* Limits `my-app` to **512MB of RAM**.
* Docker kills the container if it exceeds this memory limit.

✅ **Notes**

* Useful in **production** to avoid a single container hogging system memory.
* Can simulate **resource-constrained environments** in CI/CD testing.
* Combine with CPU limits (`--cpus`) for full resource control.

---
## Q93: What Is the `--cpus` Flag

🧠 **Overview**

* The `--cpus` flag limits the **number of CPU cores** a container can use.
* Ensures **fair CPU allocation** among containers and prevents a single container from monopolizing CPU resources.

💡 **Key Points**

* Syntax: `--cpus="1.5"` → allows container to use up to **1.5 CPU cores**.
* Works with **multi-core hosts**, fractional values are allowed.
* Can be combined with **CPU shares** (`--cpu-shares`) and **CPU set** (`--cpuset-cpus`) for fine-grained control.

⚡ **Real-world example**

```bash
docker run -d --name my-app --cpus="2.0" nginx
```

* Limits `my-app` container to **2 CPU cores**.
* Ensures other containers or host processes retain CPU availability.

✅ **Notes**

* Useful in **production and CI/CD pipelines** to prevent CPU contention.
* Helps simulate **resource-constrained environments** for testing.
* Combine with memory limits (`-m`) for full container resource control.

----
## Q94: How to Limit Container CPU Usage

🧠 **Overview**

* Docker allows you to **control CPU allocation** for containers using several options to prevent resource contention and ensure fair usage.

💡 **Key Options**

| Option          | Description                                                            |
| --------------- | ---------------------------------------------------------------------- |
| `--cpus`        | Limit the **number of CPU cores** (e.g., `--cpus="1.5"`)               |
| `--cpu-shares`  | Relative weight for CPU allocation (default 1024)                      |
| `--cpuset-cpus` | Bind container to **specific CPU cores** (e.g., `--cpuset-cpus="0,1"`) |

⚡ **Real-world examples**

```bash
# Limit to 1.5 CPU cores
docker run -d --name app1 --cpus="1.5" my-app

# Set CPU weight
docker run -d --name app2 --cpu-shares=512 my-app

# Bind container to cores 0 and 1
docker run -d --name app3 --cpuset-cpus="0,1" my-app
```

* `--cpus` provides **hard limit**, while `--cpu-shares` is **relative prioritization**.
* `--cpuset-cpus` ensures container runs only on **specific cores**.

✅ **Notes**

* Combine with memory limits (`-m`) for **full resource control**.
* Essential in **production environments** with multiple containers or CI/CD pipelines.
* Helps prevent **CPU starvation** for critical containers.

---
## Q95: What Is the `docker stats` Command

🧠 **Overview**

* `docker stats` provides **real-time metrics** about running containers, including **CPU, memory, network, and I/O usage**.
* Useful for **monitoring container performance** and troubleshooting resource issues.

💡 **Key Points**

* Displays **live, updating statistics**.
* Can monitor **all containers** or a specific container.
* Includes metrics like **CPU %, memory usage, memory limit, network I/O, block I/O**.

⚡ **Real-world example**

```bash
# Monitor all running containers
docker stats

# Monitor a specific container
docker stats my-app
```

* Sample output:

```
CONTAINER ID   NAME     CPU %   MEM USAGE / LIMIT   NET I/O     BLOCK I/O
a1b2c3d4       my-app   2.5%    100MiB / 512MiB    1MB / 0B    5MB / 2MB
```

✅ **Notes**

* Useful for **CI/CD, production monitoring, and debugging performance issues**.
* Can combine with `--no-stream` to get a **single snapshot**:

```bash
docker stats --no-stream my-app
```

* Helps **analyze resource consumption** before setting limits (`--cpus`, `--memory`).

---
## Q96: How to Monitor Container Resource Usage in Real-Time

🧠 **Overview**

* Docker provides tools to **track container CPU, memory, network, and disk I/O usage in real-time**.
* Essential for **performance monitoring, troubleshooting, and resource planning**.

💡 **Methods**

1. **Using `docker stats`**

```bash
# Monitor all containers
docker stats

# Monitor specific container
docker stats my-app
```

* Displays **CPU %, memory usage/limit, network I/O, block I/O** in real-time.
* Add `--no-stream` to get a **single snapshot**.

2. **Using `docker top`**

```bash
docker top my-app
```

* Shows **processes running inside a container**, useful for CPU/memory monitoring per process.

3. **Using monitoring tools**

* **cAdvisor, Prometheus + Grafana, Datadog**: collect metrics over time, visualize trends, set alerts.
* Integrates with **orchestration platforms** (Swarm, Kubernetes) for multi-container monitoring.

✅ **Notes**

* `docker stats` is **quick and built-in**, ideal for local or ad-hoc checks.
* For **production monitoring**, use **Prometheus/Grafana or cloud monitoring tools**.
* Helps decide **resource limits (`--cpus`, `--memory`)** for containers.

---
## Q97: What Are Container Labels and How Are They Used

🧠 **Overview**

* **Labels** are key-value pairs that **add metadata to Docker objects** (containers, images, volumes, networks).
* Useful for **organization, automation, and filtering** in CI/CD and orchestration.

💡 **Key Points**

* Labels are **optional** and do not affect container functionality.
* Can be applied in **Dockerfile** or at **runtime with `docker run`**.
* Supports **filtering and grouping** in commands or orchestration platforms.

⚡ **Real-world examples**

1. **Dockerfile**

```dockerfile
FROM nginx:alpine
LABEL maintainer="devops@example.com"
LABEL version="1.0"
LABEL environment="production"
```

2. **Runtime**

```bash
docker run -d --name my-app \
  --label environment=staging \
  --label team=devops \
  my-app-image
```

3. **Filtering by labels**

```bash
docker ps --filter "label=environment=staging"
```

✅ **Notes**

* Labels are widely used in **Docker Swarm, Kubernetes, and CI/CD pipelines** for service identification.
* Can be applied to **images, containers, networks, and volumes**.
* Supports automation: e.g., deploy all containers with `label=frontend` to a specific node.

---
## Q98: How to Filter Containers by Labels

🧠 **Overview**

* Docker allows filtering containers using **labels** to easily manage or query specific groups.
* Works with `docker ps`, `docker inspect`, and other commands that list containers.

💡 **Steps / Commands**

1. **Filter with `docker ps`**

```bash
# Show all containers with label environment=staging
docker ps --filter "label=environment=staging"

# Multiple labels (AND logic)
docker ps --filter "label=environment=staging" --filter "label=team=devops"
```

2. **Inspect container with label**

```bash
docker inspect $(docker ps -q --filter "label=team=devops")
```

* Returns detailed info only for containers matching the label filter.

✅ **Notes**

* Labels provide **flexible grouping** for orchestration, monitoring, or CI/CD pipelines.
* Use labels for **environment (prod/staging), team ownership, or application tiers**.
* Works for **containers, images, networks, and volumes** with `--filter label=<key>=<value>`.

---
## Q99: What Is the `docker inspect` Command Used For

🧠 **Overview**

* `docker inspect` provides **detailed low-level information** about Docker objects: containers, images, volumes, networks, or nodes.
* Returns data in **JSON format**, including configuration, network settings, mounts, labels, and runtime state.

💡 **Key Points**

* Useful for **debugging, monitoring, and automation**.
* Can filter specific fields with Go templates.
* Works for **containers, images, volumes, and networks**.

⚡ **Real-world examples**

1. **Inspect a container**

```bash
docker inspect my-app
```

* Returns full JSON with container config, IP, mounts, labels, and state.

2. **Inspect specific field**

```bash
docker inspect --format='{{.State.Status}}' my-app
```

* Output example: `running`

3. **Inspect a volume**

```bash
docker inspect my-volume
```

✅ **Notes**

* Ideal for **troubleshooting network issues, mounts, or resource limits**.
* Can be combined with **scripts or CI/CD pipelines** to extract runtime info.
* Provides insights into **container environment variables, health status, and labels**.

----
## Q100: How to Extract Specific Information Using `docker inspect`

🧠 **Overview**

* `docker inspect` outputs **JSON data**.
* You can extract specific fields using the **`--format` flag** with Go templates.
* Useful for automation, scripts, or quick debugging.

💡 **Syntax**

```bash
docker inspect --format='{{<template>}}' <object>
```

⚡ **Real-world examples**

1. **Get container status**

```bash
docker inspect --format='{{.State.Status}}' my-app
# Output: running
```

2. **Get container IP address**

```bash
docker inspect --format='{{.NetworkSettings.IPAddress}}' my-app
# Output: 172.17.0.2
```

3. **Get mounted volumes**

```bash
docker inspect --format='{{json .Mounts}}' my-app
# Output: JSON array with volume details
```

4. **Get container labels**

```bash
docker inspect --format='{{json .Config.Labels}}' my-app
# Output: {"environment":"staging","team":"devops"}
```

✅ **Notes**

* Go templates allow **powerful querying** of nested JSON fields.
* Combine with `jq` for **more complex parsing**:

```bash
docker inspect my-app | jq '.[0].NetworkSettings.IPAddress'
```

* Essential in **CI/CD pipelines and monitoring scripts** to extract container info automatically.

----
## Q101: What Is Docker Compose `depends_on` Directive

🧠 **Overview**

* In Docker Compose, `depends_on` **defines dependency order** between services.
* Ensures one service **starts before another**.

💡 **Key Points**

* Does **not wait for a service to be “ready”**, only ensures **container start order**.
* Useful for **multi-service applications** (e.g., web app depends on a database).
* For **health-based waits**, combine `depends_on` with **healthchecks** (Docker Compose v3.4+ supports `condition: service_healthy`).

⚡ **Real-world example**

```yaml
version: "3.8"
services:
  db:
    image: postgres:15
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      retries: 5

  web:
    image: my-web-app
    depends_on:
      db:
        condition: service_healthy
```

* `web` service waits until `db` is **healthy** before starting.

✅ **Notes**

* Simple `depends_on` (without health check) only ensures **startup order**, not readiness.
* Useful in **multi-container apps** to prevent errors from missing dependencies.
* Works in both **development and CI/CD environments**.

----
## Q102: Limitations of `depends_on` in Docker Compose

🧠 **Overview**

* `depends_on` controls **container startup order**, but has **important limitations**.

💡 **Key Limitations**

| Limitation                             | Explanation                                                                                                                |
| -------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| **Does not wait for readiness**        | Containers may start but **not be fully ready** (e.g., DB not accepting connections)                                       |
| **No automatic retry**                 | If a dependent service fails to start, Compose does **not retry** starting the dependent service                           |
| **Limited to startup order**           | Only controls **which container starts first**, does not guarantee **runtime dependency management**                       |
| **Healthcheck required for readiness** | To ensure dependent service is **actually ready**, you need to use `condition: service_healthy` with a healthcheck (v3.4+) |
| **Not dynamic**                        | If a service restarts due to failure, `depends_on` **does not enforce re-dependency checks**                               |

⚡ **Real-world example**

```yaml
services:
  db:
    image: postgres:15

  web:
    image: my-web-app
    depends_on:
      - db
```

* `web` starts after `db` container starts, but if `db` is **still initializing**, `web` may fail to connect.

✅ **Notes**

* Always pair `depends_on` with **healthchecks** for reliable multi-service startups.
* Useful for **startup sequencing**, but **not a substitute for proper orchestration** in production.
* For production-grade orchestration, consider **Kubernetes, Swarm, or wait-for scripts**.

----
## Q103: How to Ensure Service Startup Order in Docker Compose

🧠 **Overview**

* Docker Compose can **control service startup order** using `depends_on` combined with **healthchecks** to ensure services are **ready before dependent services start**.

💡 **Key Steps**

1. **Define healthchecks for services**

```yaml
services:
  db:
    image: postgres:15
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      retries: 5
```

2. **Use `depends_on` with `condition: service_healthy`**

```yaml
  web:
    image: my-web-app
    depends_on:
      db:
        condition: service_healthy
```

* Ensures `web` starts **only after `db` is healthy**, not just started.

3. **Alternative approach (if healthcheck not used)**

* Use **wait-for scripts** inside the container entrypoint to poll dependent services before starting.

⚡ **Real-world scenario**

* Web app depends on DB:

  * Without healthchecks: web may fail if DB is initializing.
  * With healthchecks + `depends_on`: web starts only after DB is ready, preventing errors.

✅ **Notes**

* `depends_on` alone **does not guarantee readiness**; always combine with healthchecks.
* Useful in **development and CI/CD pipelines** for reliable multi-container startups.
* For production orchestration, consider **Swarm or Kubernetes**, which handle service readiness more robustly.

---

## Q104: What Are Docker Compose Profiles

🧠 **Overview**

* **Profiles** in Docker Compose allow you to **group services** and selectively **start subsets of services**.
* Useful for **environment-specific setups**, e.g., development vs testing vs production.

💡 **Key Points**

* Introduced in **Docker Compose v3.9+**.
* A service can belong to **one or more profiles**.
* Only services in **active profiles** are started when `docker compose up` is run with the `--profile` flag.
* Services **without a profile** are always started.

⚡ **Real-world example**

```yaml
version: "3.9"
services:
  db:
    image: postgres:15

  web:
    image: my-web-app

  debug:
    image: my-debug-tool
    profiles:
      - dev
```

* Start **all services**:

```bash
docker compose up
# db + web (debug not started)
```

* Start **dev profile**:

```bash
docker compose --profile dev up
# db + web + debug
```

✅ **Notes**

* Profiles are ideal for **optional services** like monitoring, debugging tools, or staging-specific components.
* Helps **simplify environment management** without multiple Compose files.
* Can be combined with **override files** (`docker-compose.override.yml`) for flexibility.

---
## Q105: How to Use Environment Variables in `docker-compose.yml`

🧠 **Overview**

* Environment variables allow **dynamic configuration** of services in Docker Compose.
* Can be used for **image versions, ports, credentials, or other runtime settings**.

💡 **Key Methods**

1. **Inline in `docker-compose.yml`**

```yaml
services:
  web:
    image: "my-web-app:${APP_VERSION}"
    environment:
      - ENV=production
      - DEBUG=false
```

* `${APP_VERSION}` is replaced from the **shell environment** when running `docker compose up`.

2. **Using `.env` file**

```bash
# .env file
APP_VERSION=2.0
ENV=production
DEBUG=false
```

```yaml
services:
  web:
    image: "my-web-app:${APP_VERSION}"
    environment:
      - ENV
      - DEBUG
```

* Variables are automatically **loaded from `.env`**.

3. **Using `env_file`**

```yaml
services:
  web:
    image: my-web-app
    env_file:
      - ./config.env
```

* Reads key-value pairs from a separate file into container environment.

✅ **Notes**

* Inline variables override `.env` or `env_file`.
* Useful for **CI/CD pipelines, staging vs production, and secret management**.
* Combine with **healthchecks or entrypoint scripts** for dynamic configuration at runtime.

---
## Q106: What Is the `.env` File in Docker Compose

🧠 **Overview**

* The `.env` file is used to **define environment variables** for a Docker Compose project.
* Variables in `.env` can be **referenced in `docker-compose.yml`** for dynamic configuration.

💡 **Key Points**

* Automatically loaded by **Docker Compose** in the same directory as `docker-compose.yml`.
* Supports key-value format: `KEY=VALUE`
* Can be overridden by **shell environment variables**.
* Helps **avoid hardcoding sensitive or environment-specific values** in Compose files.

⚡ **Real-world example**

`.env` file:

```
APP_VERSION=2.0
DB_PASSWORD=secret
```

`docker-compose.yml`:

```yaml
services:
  web:
    image: my-web-app:${APP_VERSION}
    environment:
      - DB_PASSWORD
```

* `${APP_VERSION}` is replaced by the value from `.env`.
* `DB_PASSWORD` is passed as an environment variable into the container.

✅ **Notes**

* `.env` simplifies **multi-environment deployments** (dev, staging, prod).
* Avoid committing sensitive values to **version control**; use secrets for production.
* Can be combined with `env_file` for **more granular container-specific variables**.

----
## Q107: How to Override `docker-compose.yml` Settings

🧠 **Overview**

* Docker Compose allows **overriding default settings** for services using **multiple Compose files**, **environment variables**, or **runtime flags**.
* Useful for **different environments** (development, staging, production) without modifying the main file.

💡 **Key Methods**

1. **Using Override Files (`docker-compose.override.yml`)**

```bash
# Default file: docker-compose.yml
# Override file: docker-compose.override.yml
docker compose up
```

* Compose automatically applies **override settings** from `docker-compose.override.yml`.
* Example: change environment variables or ports for dev:

```yaml
# docker-compose.override.yml
services:
  web:
    environment:
      - DEBUG=true
    ports:
      - "8080:80"
```

2. **Specifying multiple Compose files**

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up
```

* Later files **override or extend** settings from earlier files.
* Example: production file sets **replicas, resource limits, secrets**.

3. **Using Environment Variables**

```yaml
services:
  web:
    image: my-web-app:${APP_VERSION}
```

```bash
export APP_VERSION=2.0
docker compose up
```

* Environment variables **override defaults** in Compose.

4. **Runtime Flags**

```bash
docker compose up -d --build
docker compose up -d -p myproject
```

* Can override **project name, build behavior, detached mode**, etc.

✅ **Notes**

* Combine multiple methods for **flexible CI/CD pipelines**.
* Override files are a **best practice** to separate dev/prod configs.
* Environment variables help **parameterize builds** and avoid hardcoding values.

---
## Q108: What Is `docker-compose.override.yml`

🧠 **Overview**

* `docker-compose.override.yml` is a **special override file** automatically applied by Docker Compose.
* It allows you to **modify or extend the base `docker-compose.yml`** without changing the original file.
* Commonly used for **development-specific settings**, while keeping the main file suitable for production.

💡 **Key Points**

* Automatically merged with `docker-compose.yml` when running `docker compose up`.
* Later settings **override** or **add to** base configurations.
* Supports all Docker Compose options: `environment`, `ports`, `volumes`, `command`, etc.

⚡ **Real-world example**

`docker-compose.yml`:

```yaml
services:
  web:
    image: my-web-app:1.0
    ports:
      - "80:80"
```

`docker-compose.override.yml`:

```yaml
services:
  web:
    environment:
      - DEBUG=true
    ports:
      - "8080:80"
```

* When running `docker compose up`:

  * Port `8080:80` and `DEBUG=true` are applied.
  * Base settings remain unless overridden.

✅ **Notes**

* Useful for **local development**, adding debugging, bind mounts, or environment variables.
* Can be combined with **other override files** using `-f` flag for more control.
* Keeps **production and development configs separate** without duplication.

----
## Q109: How to Specify Multiple Compose Files

🧠 **Overview**

* Docker Compose allows combining **multiple YAML files** to **override or extend settings**.
* Later files **override** earlier ones, enabling **environment-specific configurations** without modifying the base file.

💡 **Key Points**

* Use `-f` flag to specify multiple files in order.
* Useful for **development, staging, or production setups**.
* Supports all Compose options: services, volumes, networks, environment variables.

⚡ **Real-world example**

```bash
docker compose -f docker-compose.yml -f docker-compose.override.yml up
```

* Base settings from `docker-compose.yml` are **merged** with overrides from `docker-compose.override.yml`.

```bash
# Example for production
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

* `docker-compose.prod.yml` may set **replicas, resource limits, secrets, or env vars** for production.

✅ **Notes**

* Order matters: **later files override earlier ones**.
* Combine with `.env` files for **dynamic environment variables**.
* Recommended practice for **maintaining separate dev/prod configurations** without duplication.

---
## Q110: What Are Docker Compose Networks

🧠 **Overview**

* Docker Compose networks allow **containers in a Compose project to communicate** with each other and optionally with external networks.
* Each Compose project gets **its own default network**, isolating services from other projects.

💡 **Key Points**

* **Default network:** Automatically created per project (usually `projectname_default`).
* **Custom networks:** Defined explicitly in `docker-compose.yml` using the `networks:` section.
* Services can be attached to **one or more networks**.
* Supports network drivers: `bridge`, `overlay`, `macvlan`, `host`.

⚡ **Real-world example**

```yaml
version: "3.9"
services:
  web:
    image: nginx
    networks:
      - frontend
      - backend

  app:
    image: my-app
    networks:
      - backend

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
```

* `web` can communicate with both `frontend` and `backend` services.
* `app` can only communicate with `backend` network services.

✅ **Notes**

* Default network isolates projects, preventing **name conflicts**.
* Custom networks improve **service isolation, DNS resolution, and security**.
* Essential for **multi-service applications**, microservices, and testing environments.

---
## Q111: How to Define Custom Networks in `docker-compose.yml`

🧠 **Overview**

* Docker Compose allows defining **custom networks** to control service connectivity, isolation, and network driver options.
* Custom networks are defined under the `networks:` section and referenced by services.

💡 **Key Points**

* Can define **network driver** (e.g., `bridge`, `overlay`) and **subnet/IP range**.
* Services can attach to **one or multiple networks**.
* Enables **service isolation and communication control**.

⚡ **Real-world example**

```yaml
version: "3.9"
services:
  web:
    image: nginx
    networks:
      - frontend
      - backend

  app:
    image: my-app
    networks:
      - backend

networks:
  frontend:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16

  backend:
    driver: bridge
    ipam:
      config:
        - subnet: 172.21.0.0/16
```

* `web` can communicate with both networks, `app` only with `backend`.
* Custom subnets ensure **predictable IP allocation**.

✅ **Notes**

* Use **custom networks** to avoid conflicts and improve **DNS resolution**.
* Supports **multi-host networks** with overlay driver (Swarm).
* Essential for **production multi-service deployments** to manage traffic and isolation.

----
## Q111: How to Define Custom Networks in `docker-compose.yml`

🧠 **Overview**

* Docker Compose allows defining **custom networks** to control service connectivity, isolation, and network driver options.
* Custom networks are defined under the `networks:` section and referenced by services.

💡 **Key Points**

* Can define **network driver** (e.g., `bridge`, `overlay`) and **subnet/IP range**.
* Services can attach to **one or multiple networks**.
* Enables **service isolation and communication control**.

⚡ **Real-world example**

```yaml
version: "3.9"
services:
  web:
    image: nginx
    networks:
      - frontend
      - backend

  app:
    image: my-app
    networks:
      - backend

networks:
  frontend:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16

  backend:
    driver: bridge
    ipam:
      config:
        - subnet: 172.21.0.0/16
```

* `web` can communicate with both networks, `app` only with `backend`.
* Custom subnets ensure **predictable IP allocation**.

✅ **Notes**

* Use **custom networks** to avoid conflicts and improve **DNS resolution**.
* Supports **multi-host networks** with overlay driver (Swarm).
* Essential for **production multi-service deployments** to manage traffic and isolation.

---
## Q113: Why `docker commit` Is Generally Discouraged

🧠 **Overview**

* `docker commit` creates a new image from a **running container**, capturing its current state.
* While convenient, it has **major drawbacks** for production and maintainability.

💡 **Key Reasons**

| Reason                    | Explanation                                                                            |
| ------------------------- | -------------------------------------------------------------------------------------- |
| **Non-repeatable builds** | Changes in the container are manual; cannot reproduce the exact image consistently     |
| **No version control**    | Container state is not tracked in code or Dockerfile                                   |
| **Unstructured layers**   | Creates a single layer with all changes, losing layer granularity and caching benefits |
| **Harder to automate**    | Not suitable for CI/CD pipelines; cannot enforce build rules or dependencies           |
| **Potential for errors**  | Manual tweaks may introduce misconfigurations or sensitive data accidentally           |

⚡ **Real-world example**

* Developer installs packages manually inside a container and commits it:

```bash
docker commit <container_id> my-app:latest
```

* Later, reproducing the image on another system **may fail**, and the process is not automated.

✅ **Best Practice**

* Use **Dockerfile + `docker build`** for repeatable, version-controlled, and automated builds.
* Treat `docker commit` only as a **temporary snapshot for experimentation or debugging**.

----
## Q114: How to Export and Import Docker Images

🧠 **Overview**

* Docker allows you to **export and import images or containers** to move them between systems or backup images.
* **Export** is for containers (filesystem snapshot), **save/load** is for images (recommended).

💡 **Key Methods**

1. **Export a container (filesystem only)**

```bash
docker export <container_id> -o container.tar
```

* Exports **container filesystem**, **does not include image history or metadata**.

2. **Import a container tar as a new image**

```bash
docker import container.tar my-new-image:latest
```

* Creates a **new image** from the exported filesystem.

3. **Save an image (recommended)**

```bash
docker save -o my-app.tar my-app:1.0
```

* Saves the **image with all layers, tags, and metadata**.

4. **Load an image**

```bash
docker load -i my-app.tar
```

* Restores the image on another host, fully usable.

✅ **Notes**

* Prefer `docker save` / `docker load` for **images** to preserve **layers, history, and tags**.
* `docker export` / `docker import` is useful for **quick container snapshots**, but metadata and layer info are lost.
* Useful for **offline transfers, backups, or migration between hosts without a registry**.

---
## Q115: Difference Between `docker save` and `docker export`

| Feature                     | **docker save**                                  | **docker export**                                       |
| --------------------------- | ------------------------------------------------ | ------------------------------------------------------- |
| **Purpose**                 | Save a **Docker image** to a tar archive         | Export a **container’s filesystem** to a tar archive    |
| **Includes history/layers** | ✅ Preserves all image layers, tags, and metadata | ❌ Does not include image history, layers, or tags       |
| **Input**                   | Image (e.g., `my-app:1.0`)                       | Running or stopped container (e.g., `<container_id>`)   |
| **Restoring**               | Use `docker load` to restore image               | Use `docker import` to create new image from filesystem |
| **Use case**                | Backup, migrate images with full metadata        | Snapshot of container state or filesystem only          |
| **Repeatability**           | Fully reproducible (layers retained)             | Not fully reproducible (no history, single layer)       |

⚡ **Real-world examples**

1. **docker save / load**

```bash
docker save -o my-app.tar my-app:1.0
docker load -i my-app.tar
```

2. **docker export / import**

```bash
docker export <container_id> -o container.tar
docker import container.tar my-new-image:latest
```

✅ **Notes**

* **Use `save/load` for images** in production or CI/CD pipelines.
* **Use `export/import` for quick snapshots** or debugging container filesystems.
* Understanding the distinction is important for **backup strategy and image portability**.

----
## Q116: How to Load a Docker Image from a Tar File

🧠 **Overview**

* Docker allows importing a saved image from a **tar archive** using `docker load`.
* This restores the image **with all layers, tags, and metadata**, making it ready to run.

💡 **Command**

```bash
docker load -i <tar-file>
```

⚡ **Real-world example**

```bash
# Load image from tar
docker load -i my-app.tar

# Verify image is loaded
docker images
```

* If the tar contains a tagged image, the tag is preserved.
* Can then run the container as usual:

```bash
docker run -d --name my-app my-app:1.0
```

✅ **Notes**

* Recommended for **image migration between hosts**, offline backup, or CI/CD pipelines.
* Works with images saved using `docker save`.
* Unlike `docker import`, **metadata, layers, and tags are preserved**, ensuring reproducibility.

---
## Q117: What Is `docker system prune` and What Does It Clean

🧠 **Overview**

* `docker system prune` is a **cleanup command** that removes **unused Docker resources** to free disk space.
* Helps manage storage in environments with **many containers, images, and volumes**.

💡 **Key Points**

* Removes **stopped containers**, **unused networks**, **dangling images**, and **build cache**.
* Can optionally remove **unused volumes** with `--volumes`.
* Interactive prompt asks for confirmation unless `-f` (force) is used.

⚡ **Real-world example**

```bash
# Dry run / interactive
docker system prune

# Force removal without prompt
docker system prune -f

# Include unused volumes
docker system prune -f --volumes
```

| Resource Type         | What Gets Removed                              |
| --------------------- | ---------------------------------------------- |
| Stopped containers    | Containers not currently running               |
| Networks              | Networks not used by at least one container    |
| Dangling images       | Untagged images (`<none>`)                     |
| Build cache           | Intermediate build layers                      |
| Volumes (`--volumes`) | Unused volumes not referenced by any container |

✅ **Notes**

* Use in **development or CI/CD environments** to reclaim space.
* Be careful with `--volumes` as **data in unused volumes will be permanently deleted**.
* Can combine with `docker image prune`, `docker container prune`, and `docker volume prune` for more **granular cleanup**.

----
## Q118: How to Remove All Stopped Containers

🧠 **Overview**

* Stopped containers consume disk space and resources.
* Docker provides commands to **clean them up** efficiently.

💡 **Commands**

1. **Using `docker container prune`**

```bash
docker container prune
```

* Prompts for confirmation.
* Removes **all containers with status "exited" or "created"**.

2. **Force removal without prompt**

```bash
docker container prune -f
```

3. **Using `docker rm` with filtering**

```bash
docker rm $(docker ps -a -q -f status=exited)
```

* `docker ps -a -q -f status=exited` lists all stopped containers.
* `docker rm` removes them.

✅ **Notes**

* Safe for **cleaning development environments**.
* Combine with `docker volume prune` or `docker network prune` to free additional space.
* Do **not use on running containers**, as only stopped containers are targeted.

----
## Q119: How to Remove Unused Docker Images

🧠 **Overview**

* Unused images consume disk space.
* Docker provides commands to **remove dangling or unused images** safely.

💡 **Commands**

1. **Remove dangling images (untagged `<none>` images)**

```bash
docker image prune
```

* Prompts for confirmation; removes images **not referenced by any container**.

2. **Force removal without prompt**

```bash
docker image prune -f
```

3. **Remove all unused images (dangling + not referenced)**

```bash
docker image prune -a
```

* `-a` removes **all images not used by any container**, not just dangling ones.

4. **Manual removal**

```bash
docker rmi <image_id>
```

* Can remove **specific images** by ID or name.

✅ **Notes**

* Combine with `docker system prune` to clean **containers, networks, images, and build cache** in one command.
* Be careful with `-a` as it may remove images **needed for other projects**.
* Use in **development, CI/CD pipelines, or disk cleanup routines**.

---
## Q120: How to Clean Up Unused Docker Volumes

🧠 **Overview**

* Volumes store persistent data for containers.
* Unused volumes (not referenced by any container) consume disk space and can be cleaned.

💡 **Commands**

1. **Remove all unused volumes**

```bash
docker volume prune
```

* Prompts for confirmation; removes **volumes not used by any container**.

2. **Force removal without prompt**

```bash
docker volume prune -f
```

3. **Remove specific volume**

```bash
docker volume rm <volume_name>
```

✅ **Notes**

* Safe to remove **only volumes not in use**; active volumes are protected.
* Combine with `docker system prune --volumes` for **full cleanup**.
* Useful in **development or CI/CD environments** to reclaim disk space.

----

# Advanced
## Q121: How does Docker implement container isolation?

🧠 **Overview**

* Docker isolates containers using **Linux kernel features**, not virtual machines.
* Each container runs its own process space while sharing the same host kernel.

---

### 🔒 Core Isolation Mechanisms

| Mechanism              | What it isolates                      | Why it matters                                 |
| ---------------------- | ------------------------------------- | ---------------------------------------------- |
| **Namespaces**         | Processes, network, filesystem, users | Containers can’t see or affect each other      |
| **cgroups**            | CPU, memory, disk I/O                 | Prevents one container from hogging resources  |
| **Union File System**  | Filesystem layers                     | Containers get isolated, read-only base images |
| **Capabilities**       | Kernel privileges                     | Drops unnecessary root powers                  |
| **Seccomp**            | System calls                          | Blocks dangerous syscalls                      |
| **AppArmor / SELinux** | Access control                        | Enforces security policies                     |

---

### 🧩 Key Components Explained (with examples)

#### 1️⃣ Linux Namespaces

Isolate **views of the system** per container.

```bash
docker run -it --pid=container:nginx busybox ps aux
```

* **What it does:** Shares PID namespace with another container
* **Why:** Shows how process isolation normally prevents visibility
* **Key note:** Default is full isolation (`pid`, `net`, `mnt`, `ipc`, `uts`, `user`)

---

#### 2️⃣ cgroups (Control Groups)

Limit and account resource usage.

```bash
docker run -m 512m --cpus="1.0" nginx
```

* **What it does:** Caps memory to 512MB and CPU to 1 core
* **Why:** Prevents noisy-neighbor issues in production
* **Key note:** Enforced by kernel, not Docker itself

---

#### 3️⃣ Filesystem Isolation (UnionFS / OverlayFS)

* Image layers are **read-only**
* Each container gets a **writable layer**

```bash
docker inspect nginx | grep Overlay
```

* **Why:** Changes in one container don’t affect others
* **Real-world:** Faster image reuse, safer rollbacks

---

#### 4️⃣ Linux Capabilities

Docker drops most root privileges by default.

```bash
docker run --cap-drop ALL --cap-add NET_BIND_SERVICE nginx
```

* **What it does:** Allows binding to port 80 without full root
* **Why:** Least-privilege security model
* **Key note:** Containers are *not* full root on host

---

#### 5️⃣ Seccomp Profiles

Restricts allowed system calls.

```bash
docker run --security-opt seccomp=default.json nginx
```

* **Why:** Prevents kernel exploit vectors
* **Example:** Blocks `ptrace`, `mount`, `kexec`

---

#### 6️⃣ AppArmor / SELinux

Mandatory Access Control (MAC).

```bash
docker run --security-opt apparmor=docker-default nginx
```

* **Why:** Prevents container breakout
* **Production:** Common in EKS, OpenShift, hardened hosts

---

### 🌍 Real-World Production Context

* **Kubernetes** builds on Docker isolation using the same kernel primitives
* **EKS / AKS** rely heavily on:

  * Namespaces + cgroups for multi-tenancy
  * Seccomp + SELinux for compliance (PCI, SOC2)

---

### 💡 In short (quick recall)

* Docker uses **namespaces + cgroups** for isolation
* Adds **filesystem layering, dropped capabilities, seccomp, SELinux**
* Containers share the **host kernel** but are **strongly isolated**

If you want:

* 2-line **ultra-short interview answer**
* **Container vs VM isolation** comparison table
* **Kubernetes pod isolation** follow-up
  Just say the word.

---
## Q122: What are Linux namespaces and how does Docker use them?

🧠 **Overview**

* **Linux namespaces** isolate system resources so processes think they have their **own system view**.
* Docker uses namespaces to make each container appear like a **separate OS instance**, even though all containers share the same kernel.

---

### 🔒 Types of Linux Namespaces (Docker usage)

| Namespace | Isolates                  | Docker benefit                                |
| --------- | ------------------------- | --------------------------------------------- |
| **PID**   | Process IDs               | Containers see only their own processes       |
| **NET**   | Network stack             | Each container gets its own IP, ports, routes |
| **MNT**   | Mount points              | Isolated filesystems per container            |
| **IPC**   | Shared memory, semaphores | Prevents cross-container IPC                  |
| **UTS**   | Hostname & domain         | Containers have their own hostname            |
| **USER**  | UID/GID mapping           | Root inside ≠ root on host                    |

---

### 🧩 How Docker uses namespaces (with examples)

#### 1️⃣ PID Namespace

```bash
docker run -it busybox ps
```

* **What it does:** Shows only container processes
* **Why:** Prevents process visibility/interference
* **Key note:** PID 1 inside container ≠ host PID 1

---

#### 2️⃣ Network Namespace

```bash
docker run -d -p 8080:80 nginx
```

* **What it does:** Creates a private network stack
* **Why:** Avoids port/IP conflicts between containers
* **Real-world:** Each microservice gets its own IP

---

#### 3️⃣ Mount Namespace

```bash
docker run -it busybox mount
```

* **What it does:** Shows container-only mount points
* **Why:** File changes don’t affect host or other containers
* **Key note:** Uses OverlayFS for layered images

---

#### 4️⃣ UTS Namespace

```bash
docker run -it --hostname app1 busybox hostname
```

* **What it does:** Sets container hostname
* **Why:** Useful for service identity & debugging

---

#### 5️⃣ IPC Namespace

```bash
docker run -it busybox ipcs
```

* **What it does:** Isolates shared memory/semaphores
* **Why:** Prevents IPC collisions between containers

---

#### 6️⃣ User Namespace

```bash
docker run --userns=host busybox id
```

* **What it does:** Controls UID/GID mapping
* **Why:** Improves security by avoiding host root access
* **Production:** Strongly recommended for hardened clusters

---

### 🌍 Real-World Production Use

* **Kubernetes Pods**

  * Each pod shares **NET + IPC** namespaces
  * Containers inside a pod communicate via `localhost`
* **EKS / AKS**

  * Namespaces + cgroups enforce multi-tenant isolation
  * Combined with **seccomp & SELinux** for compliance

---

### 💡 In short (quick recall)

* Linux namespaces isolate **processes, network, filesystem, and identity**
* Docker creates a **set of namespaces per container**
* Result: Containers behave like **independent systems** without VMs

If you want next:

* **Namespaces vs cgroups** (table)
* **Pod namespace sharing in Kubernetes**
* **Security risks if namespaces are misconfigured**
---
## Q123: What namespace types does Docker use (PID, NET, IPC, MNT, UTS)?

🧠 **Overview**

* Docker uses **Linux namespaces** to isolate containers.
* Each namespace gives a container its **own view of a system resource**, even though the kernel is shared.

---

### 🔒 Docker Namespace Types (Core)

| Namespace | What it isolates          | What Docker gives the container | Real-world impact                        |
| --------- | ------------------------- | ------------------------------- | ---------------------------------------- |
| **PID**   | Process IDs               | Own process tree (PID 1 inside) | Containers can’t see/kill host processes |
| **NET**   | Network stack             | Own IP, ports, routing table    | No port/IP conflicts                     |
| **IPC**   | Shared memory, semaphores | Private IPC objects             | Prevents cross-container IPC leaks       |
| **MNT**   | Mount points              | Isolated filesystem view        | File changes don’t affect host           |
| **UTS**   | Hostname, domain          | Custom hostname                 | Easier service identity & debugging      |

---

### 🧩 How Docker applies each namespace (with examples)

#### 1️⃣ PID Namespace

```bash
docker run -it busybox ps
```

* **Does:** Shows only container processes
* **Why:** Strong process isolation
* **Note:** PID 1 has special signal-handling behavior

---

#### 2️⃣ NET Namespace

```bash
docker run -d -p 8080:80 nginx
```

* **Does:** Assigns a private network stack
* **Why:** Each container can bind same ports internally
* **Production:** Used heavily in microservices

---

#### 3️⃣ IPC Namespace

```bash
docker run -it busybox ipcs
```

* **Does:** Shows container-only IPC objects
* **Why:** Avoids shared memory collisions
* **K8s:** Containers in same Pod share IPC if enabled

---

#### 4️⃣ MNT (Mount) Namespace

```bash
docker run -it busybox mount
```

* **Does:** Shows container-specific mounts
* **Why:** Filesystem isolation using OverlayFS
* **Note:** Volumes intentionally break isolation

---

#### 5️⃣ UTS Namespace

```bash
docker run -it --hostname app-api busybox hostname
```

* **Does:** Sets container hostname
* **Why:** Easier logging, debugging, clustering

---

### ⚠️ Important Note

* Docker also supports **USER namespace** (UID/GID mapping)
* Often disabled by default but **recommended for security**

---

### 💡 In short (quick recall)

* Docker uses **PID, NET, IPC, MNT, UTS** namespaces
* Each isolates a critical OS resource
* Together, they make containers feel like **mini-systems**

If you want:

* **Namespace sharing in Kubernetes Pods**
* **USER namespace deep dive**
* **Namespace vs VM isolation (interview table)**
---
## Q124: What are cgroups and how does Docker use them for resource management?

🧠 **Overview**

* **cgroups (Control Groups)** are a Linux kernel feature to **limit, prioritize, and monitor resources** used by processes.
* Docker uses cgroups to ensure **containers don’t overuse CPU, memory, or I/O**, preventing noisy-neighbor issues.

---

### 🔧 What resources cgroups control in Docker

| Resource     | What cgroups do           | Docker flag              |
| ------------ | ------------------------- | ------------------------ |
| **CPU**      | Limit & schedule CPU time | `--cpus`, `--cpu-shares` |
| **Memory**   | Cap RAM & handle OOM      | `-m`, `--memory-swap`    |
| **Disk I/O** | Throttle read/write       | `--device-read-bps`      |
| **PIDs**     | Limit process count       | `--pids-limit`           |
| **Network**  | Indirect (via tc)         | CNI / tc                 |

---

### 🧩 How Docker uses cgroups (with examples)

#### 1️⃣ CPU limits

```bash
docker run --cpus="1.5" nginx
```

* **Does:** Allows max 1.5 CPU cores
* **Why:** Prevents CPU starvation of other containers
* **Prod use:** Fair CPU sharing on shared nodes

---

#### 2️⃣ Memory limits

```bash
docker run -m 512m --memory-swap 1g nginx
```

* **Does:** Caps RAM at 512MB, swap at 1GB
* **Why:** Stops memory leaks from crashing the host
* **Key note:** Exceeding limit → OOM kill

---

#### 3️⃣ Disk I/O throttling

```bash
docker run \
  --device-read-bps /dev/xvda:10mb \
  --device-write-bps /dev/xvda:5mb \
  nginx
```

* **Does:** Limits disk throughput
* **Why:** Protects databases from I/O starvation

---

#### 4️⃣ Process count (PID cgroup)

```bash
docker run --pids-limit 100 nginx
```

* **Does:** Max 100 processes
* **Why:** Prevents fork bombs inside containers

---

### 📊 Monitoring cgroups

```bash
docker stats
```

* **Does:** Shows live CPU, memory, I/O usage
* **Real-world:** Used in incident debugging

---

### 🌍 Real-World Production Context

* **Kubernetes**

  * Pod `requests` → scheduling
  * Pod `limits` → enforced by cgroups
* **EKS / AKS**

  * Prevents one pod from exhausting node resources
  * Critical for multi-tenant clusters

---

### ⚠️ Key Notes (Interview Traps)

* cgroups **limit resources**, namespaces **isolate views**
* cgroups **don’t virtualize hardware**
* CPU limits ≠ CPU reservation (requests vs limits in K8s)

---

### 💡 In short (quick recall)

* cgroups control **how much CPU, memory, I/O a container can use**
* Docker configures cgroups per container
* Prevents **noisy neighbors** and improves stability

---

## Q125: How does Docker implement security with seccomp?

🧠 **Overview**

* **seccomp (Secure Computing Mode)** restricts which **Linux system calls (syscalls)** a process can make.
* Docker uses seccomp to **reduce the kernel attack surface**, even if an attacker breaks into a container.

---

### 🔒 How seccomp works in Docker

* Docker applies a **default seccomp profile** to every container
* The profile **allows common syscalls** and **blocks dangerous ones**
* Blocked syscalls result in **EPERM** or container termination

---

### 🚫 Syscalls blocked by Docker (examples)

| Syscall              | Why it’s blocked                   |
| -------------------- | ---------------------------------- |
| `mount`              | Prevents mounting host filesystems |
| `ptrace`             | Stops process spying / debugging   |
| `kexec_load`         | Prevents kernel replacement        |
| `swapon`             | Blocks memory manipulation         |
| `clone` (with flags) | Prevents privilege escalation      |

---

### 🧩 Using seccomp in Docker (examples)

#### 1️⃣ Default seccomp profile (recommended)

```bash
docker run nginx
```

* **Does:** Applies Docker’s default seccomp policy
* **Why:** Secure-by-default behavior
* **Note:** Most apps work without changes

---

#### 2️⃣ Custom seccomp profile

```bash
docker run \
  --security-opt seccomp=/path/custom.json \
  nginx
```

* **Does:** Uses a custom syscall allow/deny list
* **Why:** Needed for low-level apps (e.g., databases, JVM tuning)
* **Production:** Common in hardened environments

---

#### 3️⃣ Disable seccomp (⚠️ not recommended)

```bash
docker run --security-opt seccomp=unconfined nginx
```

* **Does:** Allows all syscalls
* **Risk:** High — increases breakout surface
* **Use only:** Debugging or trusted workloads

---

### 🌍 Real-World Production Context

* **Kubernetes**

  ```yaml
  securityContext:
    seccompProfile:
      type: RuntimeDefault
  ```
* **EKS / AKS**

  * `RuntimeDefault` maps to Docker / containerd default seccomp
  * Required for **PSA Restricted** profiles

---

### ⚠️ Common Interview Pitfalls

* seccomp ≠ AppArmor / SELinux (syscalls vs filesystem access)
* seccomp **does not replace** namespaces or cgroups
* seccomp works **at kernel syscall level**

---

### 💡 In short (quick recall)

* seccomp restricts **what syscalls a container can make**
* Docker applies a **default restrictive profile**
* Reduces **kernel attack surface** and container escapes

---
## Q126: What is AppArmor and how does it integrate with Docker?

🧠 **Overview**

* **AppArmor (Application Armor)** is a Linux **Mandatory Access Control (MAC)** system.
* Docker integrates AppArmor to **restrict what containers can access on the host**, even if they run as root inside the container.

---

### 🔒 What AppArmor controls

* File & directory access
* Network permissions
* Linux capabilities
* Execution of binaries

👉 Think of AppArmor as **“what files and resources a container is allowed to touch.”**

---

### 🧩 How Docker uses AppArmor

| Mode               | Description                 | Use case                  |
| ------------------ | --------------------------- | ------------------------- |
| **docker-default** | Default restrictive profile | Most containers           |
| **Custom profile** | User-defined rules          | Databases, low-level apps |
| **Unconfined** ⚠️  | No AppArmor protection      | Debug only                |

---

### 🧪 Docker AppArmor examples

#### 1️⃣ Default AppArmor profile

```bash
docker run nginx
```

* **Does:** Applies `docker-default`
* **Why:** Blocks sensitive host paths like `/sys`, `/proc`
* **Safe:** Recommended for production

---

#### 2️⃣ Custom AppArmor profile

```bash
docker run \
  --security-opt apparmor=my-profile \
  nginx
```

* **Does:** Applies `my-profile`
* **Why:** Fine-grained access control
* **Real-world:** Databases needing shared memory access

---

#### 3️⃣ Disable AppArmor (⚠️ not recommended)

```bash
docker run --security-opt apparmor=unconfined nginx
```

* **Risk:** Container has fewer restrictions
* **Use only:** Temporary debugging

---

### 🔐 AppArmor vs seccomp (quick contrast)

| Feature        | AppArmor                   | seccomp                  |
| -------------- | -------------------------- | ------------------------ |
| Controls       | Files, paths, capabilities | System calls             |
| Level          | Filesystem / process       | Kernel syscall           |
| Goal           | Access control             | Attack surface reduction |
| Docker default | Enabled                    | Enabled                  |

---

### 🌍 Real-World Production Context

* **Ubuntu-based hosts:** AppArmor enabled by default
* **Kubernetes**

  ```yaml
  securityContext:
    appArmorProfile:
      type: RuntimeDefault
  ```
* **Compliance:** Helps meet **PCI-DSS, SOC2**

---

### ⚠️ Interview Traps

* AppArmor is **path-based** (unlike SELinux labels)
* It **complements** namespaces, cgroups, and seccomp
* Not available on all distros (Ubuntu yes, RHEL prefers SELinux)

---

### 💡 In short (quick recall)

* AppArmor restricts **what files/resources a container can access**
* Docker applies **docker-default** profile automatically
* Works alongside **seccomp & namespaces** for defense-in-depth

---
## Q127: What are Docker capabilities and how do they enhance security?

🧠 **Overview**

* **Linux capabilities** split the all-powerful **root** privilege into **fine-grained permissions**.
* Docker uses capabilities to **drop unnecessary root powers**, following **least-privilege** security.

👉 Root inside a container ≠ full root on the host.

---

### 🔐 Common Docker capabilities (examples)

| Capability             | What it allows        | Why it’s sensitive          |
| ---------------------- | --------------------- | --------------------------- |
| `CAP_NET_BIND_SERVICE` | Bind ports <1024      | Low-port access             |
| `CAP_NET_ADMIN`        | Network config        | Can change routes, iptables |
| `CAP_SYS_ADMIN`        | Mount, kernel ops     | Most dangerous              |
| `CAP_CHOWN`            | Change file ownership | File manipulation           |
| `CAP_KILL`             | Send signals          | Kill other processes        |

---

### 🧩 How Docker uses capabilities

* Docker **drops many capabilities by default**
* Containers start with a **restricted capability set**
* You explicitly **add or remove** capabilities when needed

---

### 🧪 Docker capability examples

#### 1️⃣ Drop all capabilities (max security)

```bash
docker run --cap-drop ALL nginx
```

* **Does:** Removes all extra privileges
* **Why:** Hardens untrusted workloads
* **Note:** App must not need privileged ops

---

#### 2️⃣ Add only required capability

```bash
docker run \
  --cap-drop ALL \
  --cap-add NET_BIND_SERVICE \
  nginx
```

* **Does:** Allows binding to port 80
* **Why:** Avoids running full root
* **Best practice:** Add one capability at a time

---

#### 3️⃣ Dangerous example (avoid)

```bash
docker run --cap-add SYS_ADMIN nginx
```

* **Risk:** Near-root access to host
* **Interview tip:** `SYS_ADMIN` ≈ “god capability”

---

### 🔒 Capabilities vs privileged mode

| Feature        | Capabilities | `--privileged`              |
| -------------- | ------------ | --------------------------- |
| Granularity    | Fine-grained | Full access                 |
| Security       | High         | Very low                    |
| Production use | ✅ Yes        | ❌ No (except special cases) |

---

### 🌍 Real-World Production Context

* **Kubernetes**

  ```yaml
  securityContext:
    capabilities:
      drop: ["ALL"]
      add: ["NET_BIND_SERVICE"]
  ```
* Used in **EKS / AKS** for PSA Restricted workloads
* Common for **Nginx, Envoy, API gateways**

---

### ⚠️ Interview Pitfalls

* Capabilities **don’t isolate** resources (namespaces do)
* Capabilities **don’t limit usage** (cgroups do)
* Avoid `SYS_ADMIN` unless absolutely required

---

### 💡 In short (quick recall)

* Docker capabilities split root into **smaller privileges**
* Docker drops most by default
* Improves security via **least privilege**

---
## Q128: How do you run containers with minimal capabilities?

🧠 **Overview**

* Running containers with **minimal capabilities** follows the **least-privilege principle**.
* You **drop all Linux capabilities** and **add back only what the app needs**, reducing blast radius if compromised.

---

### 🔐 Recommended minimal-capability pattern

**Drop everything → add only required capability**

```bash
docker run \
  --cap-drop ALL \
  --cap-add NET_BIND_SERVICE \
  nginx
```

* **Does:** Removes all extra privileges, adds only low-port binding
* **Why:** Nginx needs port 80, not full root
* **Production:** Standard hardening practice

---

### 🧩 Common minimal capability setups

| Workload            | Required capabilities |
| ------------------- | --------------------- |
| Web server (80/443) | `NET_BIND_SERVICE`    |
| App on high port    | None                  |
| Non-root app        | None                  |
| Debug container     | Temporary adds only   |

---

### 🧪 Non-root + minimal capabilities (best practice)

```Dockerfile
FROM nginx
RUN useradd -r appuser
USER appuser
```

```bash
docker run --cap-drop ALL nginx
```

* **Why:** Even if container breaks, attacker has no privileges
* **Real-world:** Strongly recommended for prod

---

### 🔒 Kubernetes equivalent

```yaml
securityContext:
  runAsNonRoot: true
  capabilities:
    drop: ["ALL"]
    add: ["NET_BIND_SERVICE"]
```

* Used in **EKS / AKS**
* Required for **Pod Security Admission – Restricted**

---

### ⚠️ What to avoid

```bash
docker run --privileged nginx   # ❌
docker run --cap-add SYS_ADMIN  # ❌
```

* Grants near-host-level access
* Common interview red flag

---

### 🌍 Real-World Production Checklist

* Drop **ALL** capabilities
* Run as **non-root**
* Enable **seccomp + AppArmor**
* Avoid `--privileged`

---

### 💡 In short (quick recall)

* Use `--cap-drop ALL`
* Add only required capabilities
* Combine with **non-root + seccomp**

---
## Q129: What is the `--privileged` flag and why is it dangerous?

🧠 **Overview**

* `--privileged` gives a container **almost full access to the host system**.
* It **disables most Docker security controls**, effectively making the container behave like a host process.

👉 In interviews: **`--privileged` ≈ root access on the host**

---

### 🔓 What `--privileged` actually does

| Security control   | Normal container | `--privileged`     |
| ------------------ | ---------------- | ------------------ |
| Linux capabilities | Limited          | **All enabled**    |
| Device access      | Restricted       | **All devices**    |
| seccomp            | Enforced         | **Disabled**       |
| AppArmor / SELinux | Enforced         | **Disabled**       |
| `/dev` access      | Minimal          | **Full host /dev** |

---

### 🧪 Example (dangerous)

```bash
docker run --privileged -it ubuntu bash
```

* **Does:** Container can access host devices and kernel features
* **Risk:** Container escape becomes trivial
* **Interview note:** Major security red flag in production

---

### ⚠️ Why `--privileged` is dangerous

* **Kernel attack surface fully exposed**
* Can **mount host filesystems**
* Can **load kernel modules**
* Can **modify iptables / networking**
* Easy **host takeover if compromised**

---

### 🌍 Real-World Incidents

* Misconfigured privileged containers have led to:

  * Host filesystem access
  * Credential theft
  * Full node compromise in Kubernetes clusters

---

### 🔒 Safer alternatives (what to say in interviews)

| Need              | Safe alternative                 |
| ----------------- | -------------------------------- |
| Low ports (<1024) | `--cap-add NET_BIND_SERVICE`     |
| Device access     | `--device /dev/xyz`              |
| Extra privileges  | Add **specific capabilities**    |
| Debugging         | Temporary + isolated environment |

---

### 🔐 Kubernetes equivalent (dangerous)

```yaml
securityContext:
  privileged: true
```

* **Disallowed** in Pod Security Admission – Restricted
* Only allowed for system-level components (CNI, CSI)

---

### 💡 In short (quick recall)

* `--privileged` disables container isolation
* Grants near-host-level access
* **Never use in production** unless absolutely required

---
## Q130: What are the security implications of running containers as root?

🧠 **Overview**

* Running a container as **root** means processes have **UID 0 inside the container**.
* Even with isolation, root containers **increase the impact of vulnerabilities** and make **container escapes far more dangerous**.

👉 **Root in container ≠ full host root**, but it’s still risky.

---

### 🔓 Security risks of root containers

| Risk                     | Why it matters                          |
| ------------------------ | --------------------------------------- |
| **Privilege escalation** | Kernel or runtime bugs → host takeover  |
| **Filesystem damage**    | Can modify mounted volumes & host paths |
| **Capability abuse**     | Root + extra caps = near-host power     |
| **Supply-chain attacks** | Malicious images gain maximum control   |
| **Harder compliance**    | Violates least-privilege policies       |

---

### 🧩 Real-world attack scenarios

1️⃣ **Vulnerable app + root**

* Exploit → attacker gains root in container
* Next step: abuse capabilities or kernel bugs

2️⃣ **HostPath / volume mount**

```bash
docker run -v /:/host ubuntu
```

* Root inside container can **modify host files**
* Common misconfiguration during debugging

---

### 🔐 Docker default behavior (important)

* Docker runs containers as **root by default**
* Root is **restricted by namespaces + capabilities**
* Still **not safe for production**

---

### 🧪 How to avoid running as root

#### 1️⃣ Use non-root user in Dockerfile

```Dockerfile
FROM node:20
USER node
```

* **Does:** App runs as non-root
* **Why:** Limits blast radius

---

#### 2️⃣ Drop capabilities

```bash
docker run --cap-drop ALL nginx
```

* **Does:** Removes privileged operations
* **Why:** Even root can’t do dangerous actions

---

#### 3️⃣ Enable user namespaces

```bash
dockerd --userns-remap=default
```

* **Does:** Maps container root → non-root host UID
* **Why:** Strong host protection

---

### 🔒 Kubernetes best practice

```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  capabilities:
    drop: ["ALL"]
```

* Required for **Pod Security Admission – Restricted**
* Standard in **EKS / AKS production**

---

### ⚠️ Interview traps

* “Containers are safe because root is isolated” ❌
* Root containers are **one exploit away** from host risk
* Defense-in-depth is mandatory

---

### 💡 In short (quick recall)

* Root containers **increase blast radius**
* Combined with caps/volumes → host compromise
* Always prefer **non-root + minimal capabilities**

----
## Q131: How do you implement rootless Docker?

🧠 **Overview**

* **Rootless Docker** runs the Docker daemon **and containers without root privileges**.
* Even if a container is compromised, the attacker **cannot gain host root access**.
* Ideal for **developer laptops, shared servers, and hardened prod hosts**.

---

### 🔒 Why rootless Docker matters

* Eliminates **daemon running as root**
* Reduces impact of **container escape vulnerabilities**
* Strong **least-privilege** model

---

### ⚙️ Prerequisites

* Linux kernel **≥ 4.18**
* `uidmap` package (`newuidmap`, `newgidmap`)
* Non-root user with subuid/subgid mappings

```bash
grep $(whoami) /etc/subuid /etc/subgid
```

---

### 🛠️ Step-by-step: Enable rootless Docker

#### 1️⃣ Install rootless dependencies

```bash
sudo apt install -y uidmap dbus-user-session
```

* **Does:** Enables user namespace mappings
* **Why:** Required for rootless mode

---

#### 2️⃣ Run rootless setup

```bash
dockerd-rootless-setuptool.sh install
```

* **Does:** Installs rootless Docker for current user
* **Why:** Starts daemon in user space

---

#### 3️⃣ Configure environment

```bash
export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock
```

* **Does:** Points Docker CLI to rootless daemon
* **Why:** Avoids using system Docker socket

---

#### 4️⃣ Verify rootless mode

```bash
docker info | grep Rootless
```

Output:

```text
Rootless: true
```

---

### 🔐 How rootless Docker works (internals)

* Uses **user namespaces**
* Container root → **unprivileged host UID**
* No access to:

  * Host devices
  * Privileged ports (<1024)
  * Kernel modules

---

### ⚠️ Limitations (important for interviews)

| Limitation               | Why                    |
| ------------------------ | ---------------------- |
| No privileged containers | Needs real root        |
| No host networking       | Security restriction   |
| Ports <1024              | Need authbind or proxy |
| Lower I/O performance    | FUSE-overlayfs         |

---

### 🌍 Real-World Usage

* **Developer environments**
* **CI runners** (GitHub Actions self-hosted)
* **Multi-tenant servers**
* **Not common in Kubernetes nodes** (yet)

---

### 🔒 Kubernetes alternative

* Use **non-root containers + user namespaces**
* Rootless Docker ≠ rootless Kubernetes

---

### 💡 In short (quick recall)

* Rootless Docker runs **daemon + containers as non-root**
* Uses **user namespaces**
* Greatly reduces **host compromise risk**

----
## Q132: What is Docker user namespaces remapping?

🧠 **Overview**

* **User namespace remapping** maps **container user IDs (UID/GID)** to **different, unprivileged IDs on the host**.
* Result: **root (UID 0) inside the container is NOT root on the host**.
* It’s a key feature to **reduce container escape impact**.

---

### 🔐 Why user namespace remapping matters

* Limits damage if a container is compromised
* Protects host files even when containers run as root
* Strong **defense-in-depth** for production Docker hosts

---

### ⚙️ How it works (simple view)

| Container UID | Host UID |
| ------------- | -------- |
| 0 (root)      | 100000   |
| 1             | 100001   |
| 1000          | 101000   |

* Mappings come from `/etc/subuid` and `/etc/subgid`

---

### 🛠️ Enable user namespace remapping (Docker)

#### 1️⃣ Configure subuids/subgids

```bash
sudo usermod --add-subuids 100000-165536 dockeruser
sudo usermod --add-subgids 100000-165536 dockeruser
```

---

#### 2️⃣ Enable in Docker daemon

```json
{
  "userns-remap": "default"
}
```

File:

```bash
/etc/docker/daemon.json
```

---

#### 3️⃣ Restart Docker

```bash
sudo systemctl restart docker
```

---

#### 4️⃣ Verify

```bash
docker info | grep userns
```

---

### 🧪 Practical effect (example)

```bash
docker run -it ubuntu bash
id
```

Output inside container:

```text
uid=0(root) gid=0(root)
```

Host view:

```bash
ls -ln /var/lib/docker/
```

* Files owned by **UID 100000+**, not root

---

### ⚠️ Limitations & gotchas

| Issue              | Impact                    |
| ------------------ | ------------------------- |
| Volume permissions | May break existing mounts |
| Some images        | Expect real root          |
| Debugging          | More complex              |
| Kubernetes         | Limited support           |

---

### 🔒 User namespace remap vs rootless Docker

| Feature        | Userns remap | Rootless Docker   |
| -------------- | ------------ | ----------------- |
| Docker daemon  | Root         | Non-root          |
| Container root | Mapped       | Non-root host UID |
| Prod usage     | Common       | Limited           |

---

### 🌍 Real-World Usage

* Production Docker hosts with **untrusted workloads**
* Shared CI/CD build servers
* Environments needing extra isolation

---

### 💡 In short (quick recall)

* User namespace remapping maps container root → non-root host UID
* Reduces blast radius of container escapes
* Strong Docker security hardening feature

----
## Q133: How do you configure user namespace remapping?

🧠 **Overview**

* **User namespace remapping** maps container UIDs/GIDs to **unprivileged host IDs**.
* Even if a container runs as root, it **cannot act as host root**.
* This is a **production-grade Docker hardening** feature.

---

## ⚙️ Step-by-step configuration (Docker)

### 1️⃣ Verify kernel & tools

```bash
uname -r
which newuidmap newgidmap
```

* **Why:** User namespaces require kernel + uidmap tools

---

### 2️⃣ Configure subuid / subgid ranges

```bash
sudo usermod --add-subuids 100000-165536 dockremap
sudo usermod --add-subgids 100000-165536 dockremap
```

Check:

```bash
grep dockremap /etc/subuid /etc/subgid
```

* **What it does:** Reserves a UID/GID range for containers
* **Key note:** Range must be large enough for all containers

---

### 3️⃣ Enable user namespace remapping

Edit:

```bash
sudo vi /etc/docker/daemon.json
```

```json
{
  "userns-remap": "default"
}
```

* **Options:**

  * `"default"` → Docker creates `dockremap` user
  * `"user:group"` → Custom user/group

---

### 4️⃣ Restart Docker

```bash
sudo systemctl restart docker
```

---

### 5️⃣ Verify configuration

```bash
docker info | grep -i userns
```

Expected:

```text
userns
```

---

## 🧪 Validation test (important)

```bash
docker run -it ubuntu bash
id
```

Inside container:

```text
uid=0(root)
```

On host:

```bash
ls -ln /var/lib/docker/
```

* Files owned by **UID ≥ 100000**, not root

---

## ⚠️ Common issues & fixes

| Issue                    | Fix                              |
| ------------------------ | -------------------------------- |
| Volume permission denied | `chown` volume to mapped UID     |
| Existing containers fail | Recreate containers              |
| Third-party images break | Run as non-root inside container |
| Kubernetes nodes         | Avoid (limited support)          |

---

## 🔐 Best practices (interview gold)

* Enable **before** running production containers
* Combine with:

  * `--cap-drop ALL`
  * seccomp + AppArmor
  * Non-root containers
* Avoid on hosts heavily using **bind mounts**

---

### 💡 In short (quick recall)

* Configure `/etc/subuid`, `/etc/subgid`
* Enable `"userns-remap": "default"`
* Restart Docker and verify
* Container root ≠ host root

---
## Q134: What strategies would you use for container image security?

🧠 **Overview**

* Container image security focuses on **preventing vulnerable or malicious code from ever reaching production**.
* The goal is to secure the image **build → store → deploy** lifecycle.

---

## 🔐 Core container image security strategies

### 1️⃣ Use minimal & trusted base images

```Dockerfile
FROM gcr.io/distroless/nodejs20
```

* **Why:** Smaller attack surface, fewer CVEs
* **Best practice:** Prefer `distroless`, `alpine`, or vendor-official images

---

### 2️⃣ Scan images for vulnerabilities (CI/CD)

```bash
trivy image myapp:1.0
```

* **Does:** Finds OS & dependency CVEs
* **Why:** Fail builds on critical vulnerabilities
* **Prod:** Mandatory in pipelines

---

### 3️⃣ Pin image versions (no `latest`)

```Dockerfile
FROM nginx:1.26.2
```

* **Why:** Prevents surprise changes
* **Interview tip:** `latest` = non-reproducible builds

---

### 4️⃣ Run as non-root

```Dockerfile
USER 1000
```

* **Why:** Limits blast radius if exploited
* **Combine with:** capability drops

---

### 5️⃣ Drop unnecessary capabilities

```bash
docker run --cap-drop ALL myapp
```

* **Why:** Least privilege
* **Prod:** Add only what’s needed

---

### 6️⃣ Enable seccomp & AppArmor

* **seccomp:** Restricts syscalls
* **AppArmor/SELinux:** Restricts filesystem & resources

```bash
docker run --security-opt seccomp=default.json myapp
```

---

### 7️⃣ Sign & verify images

```bash
cosign sign myapp:1.0
cosign verify myapp:1.0
```

* **Why:** Prevents image tampering
* **Used in:** Supply-chain security

---

### 8️⃣ Multi-stage builds

```Dockerfile
FROM golang:1.22 AS build
RUN go build -o app

FROM gcr.io/distroless/base
COPY --from=build /app /app
```

* **Why:** Removes compilers, secrets, build tools
* **Result:** Smaller & safer images

---

### 9️⃣ Scan registries continuously

* Amazon ECR image scanning
* Azure Container Registry scanning
* Detects **new CVEs after push**

---

### 🔒 Kubernetes-specific controls

```yaml
securityContext:
  runAsNonRoot: true
  readOnlyRootFilesystem: true
```

* Enforce via **OPA / Kyverno**
* Block unsigned or vulnerable images

---

## ⚠️ Common mistakes (interview traps)

* Using `latest`
* Skipping scans in CI
* Running as root
* Baking secrets into images
* Large base images

---

### 💡 In short (quick recall)

* Minimal images + scans + signing
* Non-root + dropped capabilities
* CI/CD enforcement before prod

---
## Q135: How do you implement image scanning in CI/CD?

🧠 **Overview**

* Image scanning in CI/CD ensures **vulnerable container images never reach production**.
* The scan runs **after build, before push/deploy**, and **fails the pipeline** on critical issues.

---

## 🔐 Standard CI/CD image scanning flow

```text
Code → Build Image → Scan Image → (Fail/Pass) → Push → Deploy
```

---

## 🧩 Tooling (common choices)

| Tool         | Where used    | Notes             |
| ------------ | ------------- | ----------------- |
| **Trivy**    | CI pipelines  | Fast, popular     |
| **Grype**    | CI pipelines  | Good SBOM support |
| **Clair**    | Registry-side | Server-based      |
| **ECR Scan** | AWS ECR       | Native            |
| **ACR Scan** | Azure ACR     | Defender-backed   |

---

## 🛠️ Example: Trivy in CI/CD (production-ready)

### 1️⃣ Build image

```bash
docker build -t myapp:${GIT_COMMIT} .
```

* **Why:** Immutable, traceable image

---

### 2️⃣ Scan image (fail on critical)

```bash
trivy image \
  --exit-code 1 \
  --severity HIGH,CRITICAL \
  myapp:${GIT_COMMIT}
```

* **Does:** Fails pipeline on HIGH/CRITICAL CVEs
* **Best practice:** Block CRITICAL at minimum

---

### 3️⃣ Push only if scan passes

```bash
docker push myapp:${GIT_COMMIT}
```

---

## 🧪 GitHub Actions example

```yaml
- name: Build image
  run: docker build -t myapp:${{ github.sha }} .

- name: Scan image
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: myapp:${{ github.sha }}
    severity: CRITICAL,HIGH
    exit-code: 1
```

---

## 🧪 GitLab CI example

```yaml
image_scan:
  stage: test
  script:
    - docker build -t myapp:$CI_COMMIT_SHA .
    - trivy image --exit-code 1 myapp:$CI_COMMIT_SHA
```

---

## 🌍 Cloud-native scanning

### AWS ECR

* Enable **Enhanced Scanning**
* Scans on **push + continuously**
* Integrates with **Inspector**

### Azure ACR

* Enable **Defender for Containers**
* Policy-based enforcement

---

## 🔒 Advanced (interview bonus)

* Generate **SBOM** (`syft`)
* Scan SBOM instead of image
* Enforce with **OPA / Kyverno**
* Block unsigned images (cosign)

---

## ⚠️ Common mistakes

* Scanning after deploy ❌
* Ignoring base image CVEs ❌
* Not failing pipelines ❌
* No re-scan after new CVEs ❌

---

### 💡 In short (quick recall)

* Scan **during CI**, before push
* Fail pipeline on critical CVEs
* Use Trivy/Grype + registry scanning

----
## Q136: What tools would you use for vulnerability scanning (Trivy, Clair, Anchore)?

🧠 **Overview**

* Vulnerability scanning tools detect **known CVEs** in container images and dependencies.
* Tool choice depends on **CI/CD speed, scale, and governance needs**.

---

## 🔍 Tool comparison (interview-ready)

| Tool        | Type                | Best for            | Strengths                           | Limitations         |
| ----------- | ------------------- | ------------------- | ----------------------------------- | ------------------- |
| **Trivy**   | CLI / CI-first      | Fast CI pipelines   | Simple, all-in-one (image, FS, IaC) | Limited policy mgmt |
| **Clair**   | Server-based        | Registry scanning   | Continuous scanning                 | Needs setup & ops   |
| **Anchore** | Platform (CLI + UI) | Enterprise security | Policies, SBOM, compliance          | Heavier, slower     |

---

## 🧩 When to use each (real-world)

### 🔹 Trivy

```bash
trivy image myapp:1.0
```

* **Use when:** You want fast feedback in CI
* **Why:** Minimal setup, pipeline-friendly
* **Seen in:** GitHub Actions, GitLab CI, Jenkins

---

### 🔹 Clair

* **Use when:** You need **continuous registry scanning**
* **Why:** Scans images *after push*
* **Seen in:** Private registries, long-lived images

---

### 🔹 Anchore (Enterprise)

```bash
anchore-cli image add myapp:1.0
```

* **Use when:** Large orgs with compliance needs
* **Why:** Policy enforcement, audit trails
* **Seen in:** Regulated environments

---

## ☁️ Cloud-native alternatives (mention in interviews)

| Cloud | Native tool             |
| ----- | ----------------------- |
| AWS   | ECR + Inspector         |
| Azure | Defender for Containers |
| GCP   | Container Analysis      |

---

## 🔒 Best-practice strategy (production)

* **CI scan:** Trivy (fast fail)
* **Registry scan:** ECR / Clair
* **Governance:** Anchore (policy + audit)
* **SBOM:** Syft + scan

---

## ⚠️ Interview traps

* Relying only on registry scanning ❌
* Not failing CI on CRITICAL ❌
* Ignoring base image vulnerabilities ❌

---

### 💡 In short (quick recall)

* **Trivy:** Fast, CI-friendly
* **Clair:** Registry-level, continuous
* **Anchore:** Enterprise policy & compliance

----
## Q137: How do you implement least privilege for container processes?

🧠 **Overview**

* **Least privilege** means a container process gets **only the permissions it needs—nothing more**.
* Goal: **limit blast radius** if the container or app is compromised.

---

## 🔐 Core least-privilege strategies (production-ready)

### 1️⃣ Run containers as non-root

```Dockerfile
FROM node:20
USER node
```

* **Why:** Prevents root-level actions inside container
* **Interview line:** First and most important step

---

### 2️⃣ Drop all Linux capabilities

```bash
docker run --cap-drop ALL myapp
```

* **Why:** Removes powerful kernel privileges
* **Add back only if needed**

```bash
docker run --cap-drop ALL --cap-add NET_BIND_SERVICE myapp
```

---

### 3️⃣ Use seccomp (restrict syscalls)

```bash
docker run --security-opt seccomp=default.json myapp
```

* **Why:** Blocks dangerous syscalls like `mount`, `ptrace`
* **Default profile is usually enough**

---

### 4️⃣ Enforce AppArmor / SELinux

```bash
docker run --security-opt apparmor=docker-default myapp
```

* **Why:** Restricts filesystem & resource access
* **Production:** Mandatory on Ubuntu/RHEL hosts

---

### 5️⃣ Read-only root filesystem

```bash
docker run --read-only myapp
```

* **Why:** Prevents tampering with binaries
* **Allow writes only via volumes**

---

### 6️⃣ Limit resources (cgroups)

```bash
docker run -m 512m --cpus="1.0" myapp
```

* **Why:** Prevents DoS from runaway containers

---

### 7️⃣ Avoid privileged mode

```bash
docker run --privileged myapp   # ❌
```

* Use **specific capabilities** instead

---

## ☸️ Kubernetes equivalent (gold standard)

```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  readOnlyRootFilesystem: true
  capabilities:
    drop: ["ALL"]
```

* Enforce with **Pod Security Admission (Restricted)**
* Use **OPA / Kyverno** for policy-as-code

---

## ⚠️ Common mistakes (interview traps)

* Running as root “because it works”
* Using `--privileged`
* Adding `SYS_ADMIN`
* Writable root filesystem

---

### 💡 In short (quick recall)

* Non-root user
* Drop ALL capabilities
* Enable seccomp + AppArmor
* Read-only filesystem
* Resource limits

----
## Q138: What is a read-only root filesystem and how do you implement it?

🧠 **Overview**

* A **read-only root filesystem** means the container **cannot write to `/`** (its root FS).
* This prevents attackers or buggy apps from **modifying binaries, configs, or system paths**.
* It’s a key **least-privilege and hardening** control.

---

## 🔐 Why read-only root filesystem matters

| Risk without it    | Protection with read-only FS |
| ------------------ | ---------------------------- |
| Binary tampering   | ❌ Blocked                    |
| Dropping malware   | ❌ Blocked                    |
| Accidental writes  | ❌ Blocked                    |
| Persistent attacks | ❌ Blocked                    |

---

## 🛠️ Docker implementation

### 1️⃣ Run container with read-only root FS

```bash
docker run --read-only nginx
```

* **Does:** Mounts `/` as read-only
* **Why:** Prevents writes to image layers

---

### 2️⃣ Allow writes via volumes (required)

```bash
docker run \
  --read-only \
  -v /var/log/nginx \
  -v /tmp \
  nginx
```

* **Why:** Apps need writable paths for logs, temp files
* **Best practice:** Mount only what’s required

---

### 3️⃣ tmpfs for temporary writes

```bash
docker run \
  --read-only \
  --tmpfs /tmp \
  --tmpfs /run \
  nginx
```

* **Does:** In-memory writable dirs
* **Why:** No disk persistence, safer & faster

---

## ☸️ Kubernetes implementation

```yaml
securityContext:
  readOnlyRootFilesystem: true
```

With writable paths:

```yaml
volumeMounts:
- name: tmp
  mountPath: /tmp
volumes:
- name: tmp
  emptyDir: {}
```

* **emptyDir:** Ephemeral writable storage
* Required for many apps

---

## ⚠️ Common breakages & fixes

| Error              | Fix                    |
| ------------------ | ---------------------- |
| App fails to start | Identify writable path |
| Logs fail          | Mount `/var/log`       |
| Java apps crash    | Add `/tmp` tmpfs       |
| PID file error     | Mount `/run`           |

---

## 🌍 Real-World Production Use

* Standard in **EKS / AKS hardened workloads**
* Required for **Pod Security Admission – Restricted**
* Used with **non-root + dropped capabilities**

---

### 💡 In short (quick recall)

* Root filesystem is mounted **read-only**
* Prevents image & binary tampering
* Use **volumes/tmpfs** for required writes
----
## Q139: How do you handle writable directories with a read-only filesystem?

🧠 **Overview**

* When the root filesystem is **read-only**, applications still need **specific writable paths** (logs, temp files, PID files).
* Solution: **explicitly mount writable directories** using **volumes or tmpfs**, while keeping everything else locked down.

---

## 🔐 Core strategies (production-ready)

### 1️⃣ Use `tmpfs` for temporary data (best default)

```bash
docker run \
  --read-only \
  --tmpfs /tmp \
  --tmpfs /run \
  myapp
```

* **Does:** Creates in-memory writable dirs
* **Why:** No disk persistence, safer, fast
* **Use for:** `/tmp`, `/run`, `/var/run`

---

### 2️⃣ Mount specific directories as volumes

```bash
docker run \
  --read-only \
  -v /var/log/myapp \
  myapp
```

* **Does:** Makes only `/var/log/myapp` writable
* **Why:** Logs need persistence
* **Best practice:** Mount **only what’s required**

---

### 3️⃣ Pre-create writable paths in the image

```Dockerfile
RUN mkdir -p /var/log/myapp && chown 1000:1000 /var/log/myapp
```

* **Why:** Prevents permission errors
* **Combine with:** non-root user

---

## ☸️ Kubernetes implementation

```yaml
securityContext:
  readOnlyRootFilesystem: true
```

### Writable directories

```yaml
volumeMounts:
- name: tmp
  mountPath: /tmp
- name: logs
  mountPath: /var/log/myapp

volumes:
- name: tmp
  emptyDir: {}
- name: logs
  emptyDir: {}
```

* `emptyDir`: Ephemeral, pod-scoped storage
* Use PVC only if persistence is required

---

## 🧪 Common writable paths by runtime

| Runtime | Writable paths needed          |
| ------- | ------------------------------ |
| Java    | `/tmp`, `/var/tmp`             |
| Nginx   | `/var/cache/nginx`, `/var/run` |
| Node.js | `/tmp`                         |
| Python  | `/tmp`, app-specific logs      |

---

## ⚠️ Common mistakes (interview traps)

* Making whole filesystem writable ❌
* Using hostPath volumes ❌
* Forgetting `/tmp` (causes crashes) ❌

---

### 💡 In short (quick recall)

* Keep root FS read-only
* Use **tmpfs** for temp data
* Use **volumes** for logs/state
* Mount **minimum required paths**

---
## Q140: What strategies would you use for secrets management in Docker?

🧠 **Overview**

* Secrets management ensures **passwords, tokens, and keys are never baked into images or code**.
* Goal: **secure injection at runtime**, minimal exposure, easy rotation.

---

## 🔐 Core strategies (production-ready)

### 1️⃣ Never bake secrets into images ❌

```Dockerfile
ENV DB_PASSWORD=secret123   # ❌
```

* **Why dangerous:** Leaks via image history, registries, scans

---

### 2️⃣ Use Docker Secrets (best for Swarm)

```bash
echo "mypassword" | docker secret create db_password -
```

```bash
docker service create \
  --secret db_password \
  myapp
```

Inside container:

```bash
/run/secrets/db_password
```

* **Why:** Secrets stored in-memory, not env vars
* **Security:** Encrypted at rest & in transit

---

### 3️⃣ Environment variables (basic, not ideal)

```bash
docker run -e DB_PASSWORD=$DB_PASSWORD myapp
```

* **Pros:** Simple
* **Cons:** Visible via `docker inspect`, process dumps
* **Use only:** Non-critical or short-lived secrets

---

### 4️⃣ Mount secrets as files (recommended)

```bash
docker run \
  -v /secrets/db_password:/run/secrets/db_password:ro \
  myapp
```

* **Why:** Not exposed in process list
* **Best practice:** Read-only mount

---

### 5️⃣ External secrets managers (best practice)

| Tool                        | Use case                |
| --------------------------- | ----------------------- |
| **AWS Secrets Manager**     | AWS workloads           |
| **AWS SSM Parameter Store** | Simple + cheap          |
| **HashiCorp Vault**         | Multi-cloud, enterprise |
| **Azure Key Vault**         | Azure workloads         |

Example (AWS SDK):

```bash
aws secretsmanager get-secret-value --secret-id db_password
```

* **Why:** Central rotation, audit logs, IAM control

---

### 6️⃣ Inject secrets at runtime (entrypoint pattern)

```bash
export DB_PASSWORD=$(aws ssm get-parameter ...)
exec ./app
```

* **Why:** Secrets never stored on disk
* **Used in:** EKS, ECS, CI/CD jobs

---

## 🔒 CI/CD best practices

* Store secrets in:

  * GitHub Actions Secrets
  * GitLab CI Variables
  * Jenkins Credentials
* Never echo secrets in logs
* Rotate secrets regularly

---

## ⚠️ Common mistakes (interview traps)

* Hardcoding secrets ❌
* Committing `.env` files ❌
* Using `latest` images with secrets baked ❌
* Using hostPath for secrets ❌

---

## ☸️ Kubernetes note (bonus)

* Prefer **Kubernetes Secrets + External Secrets Operator**
* Mount secrets as **files**, not env vars

---

### 💡 In short (quick recall)

* Never bake secrets into images
* Prefer **file-based secrets**
* Use **external secret managers**
* Inject at runtime, rotate often

---
## Q141: What are Docker secrets in Swarm mode?

🧠 **Overview**

* **Docker secrets** are a **secure way to store and distribute sensitive data** (passwords, tokens, certificates) in **Docker Swarm**.
* Secrets are **encrypted**, **never baked into images**, and **only exposed to authorized services at runtime**.

---

## 🔐 Key characteristics

| Feature     | Behavior                             |
| ----------- | ------------------------------------ |
| Storage     | Encrypted at rest (Raft log)         |
| Transit     | Encrypted between managers & workers |
| Exposure    | Mounted as files, not env vars       |
| Scope       | Only available to assigned services  |
| Persistence | In-memory (`tmpfs`)                  |

---

## 🛠️ How Docker secrets work

```text
Secret → Swarm Manager → Authorized Service → /run/secrets/<name>
```

* Containers read secrets **as files**
* Secrets disappear when container stops

---

## 🧪 Docker secrets example

### 1️⃣ Create a secret

```bash
echo "db_password_123" | docker secret create db_password -
```

* **Does:** Stores secret securely in Swarm

---

### 2️⃣ Use secret in a service

```bash
docker service create \
  --name myapp \
  --secret db_password \
  nginx
```

---

### 3️⃣ Read secret inside container

```bash
cat /run/secrets/db_password
```

* **Mounted as:** Read-only file
* **Not visible in:** `docker inspect`, env vars

---

## 🔒 Why Docker secrets are secure

* Not stored in images
* Not exposed via environment variables
* Not accessible to non-authorized services
* Automatically cleaned up

---

## ⚠️ Limitations (important for interviews)

| Limitation  | Note                               |
| ----------- | ---------------------------------- |
| Swarm-only  | Not available in standalone Docker |
| No rotation | Requires service update            |
| File-only   | App must read from file            |

---

## 🌍 Real-World Usage

* Databases credentials
* TLS private keys
* API tokens
* Used mainly in **legacy Swarm setups**

---

## ☸️ Comparison (quick mention)

| Feature   | Docker secrets | K8s secrets                 |
| --------- | -------------- | --------------------------- |
| Platform  | Swarm          | Kubernetes                  |
| Storage   | Encrypted Raft | etcd (encrypted if enabled) |
| Injection | File-based     | File / env                  |

---

### 💡 In short (quick recall)

* Docker secrets securely store sensitive data in **Swarm**
* Encrypted, file-based, service-scoped
* Not available outside Swarm mode

----
## Q142: How do you pass secrets to standalone Docker containers?

🧠 **Overview**

* Standalone Docker (non-Swarm) **has no native secrets manager**.
* Best practice is to **inject secrets at runtime**, avoid images/env leaks, and prefer **external secret stores**.

---

## 🔐 Recommended methods (best → worst)

### 1️⃣ Mount secrets as read-only files (best practice)

```bash
docker run \
  -v /secure/secrets/db_password:/run/secrets/db_password:ro \
  myapp
```

* **Why:** Not visible in env/process list
* **App reads:** `/run/secrets/db_password`
* **Production:** Preferred approach

---

### 2️⃣ Use external secrets manager (best overall)

| Platform    | Tool                  |
| ----------- | --------------------- |
| AWS         | Secrets Manager / SSM |
| Azure       | Key Vault             |
| Multi-cloud | HashiCorp Vault       |

Example:

```bash
docker run myapp \
  sh -c 'export DB_PASS=$(aws ssm get-parameter ...); exec app'
```

* **Why:** Central rotation, audit, IAM
* **Real-world:** Most production setups

---

### 3️⃣ `.env` file (acceptable for local/dev)

```bash
docker run --env-file .env myapp
```

* **Pros:** Simple
* **Cons:** Plain text, easy to leak
* **Never commit** `.env` files

---

### 4️⃣ Environment variables (last resort)

```bash
docker run -e DB_PASSWORD=secret myapp
```

* **Risks:** Visible via `docker inspect`, crashes, logs
* **Use only:** Short-lived, non-critical secrets

---

## ⚠️ What NOT to do (interview red flags)

* Hardcode secrets in Dockerfile ❌
* Commit secrets to Git ❌
* Use `ENV` for passwords ❌
* Bake secrets into image layers ❌

---

## 🔒 Extra hardening tips

* Mount secrets **read-only**
* Use **non-root containers**
* Enable **read-only root filesystem**
* Rotate secrets regularly

---

### 💡 In short (quick recall)

* Standalone Docker has **no native secrets**
* Use **file mounts or external secret managers**
* Avoid env vars & baked secrets

---
## Q143: What are the security risks of using environment variables for secrets?

🧠 **Overview**

* Environment variables are **easy but insecure** for secrets.
* They expose secrets to **multiple unintended surfaces**, increasing leak risk.

👉 In interviews: **env vars ≠ secret management**

---

## 🔓 Key security risks

| Risk                    | Why it’s dangerous                |
| ----------------------- | --------------------------------- |
| **Visible via inspect** | `docker inspect` exposes env vars |
| **Process leakage**     | Accessible via `/proc/*/environ`  |
| **Accidental logging**  | Debug logs may print env          |
| **Crash dumps**         | Secrets appear in memory dumps    |
| **Shell history**       | CLI exports can be logged         |
| **Shared environments** | Other processes/users may read    |

---

## 🧪 Practical examples

### 1️⃣ Exposed via Docker inspect

```bash
docker inspect mycontainer | grep PASSWORD
```

* **Leak:** Anyone with Docker access sees secrets

---

### 2️⃣ Visible inside container

```bash
cat /proc/1/environ | tr '\0' '\n'
```

* **Leak:** Secrets readable from process memory

---

### 3️⃣ CI/CD logs leak

```bash
export DB_PASSWORD=secret
echo "Connecting with $DB_PASSWORD"
```

* **Leak:** Stored permanently in logs

---

## 🔐 Why files are safer than env vars

| Method             | Visibility | Risk |
| ------------------ | ---------- | ---- |
| Env vars           | High       | ❌    |
| File-based secrets | Low        | ✅    |

* File secrets can be **read-only**
* Not exposed in process list

---

## ⚠️ Interview traps

* “Env vars are secure because container is isolated” ❌
* Isolation does **not** protect secrets
* Root inside container can read env vars

---

## 🔒 Safer alternatives (what to recommend)

* Mount secrets as **files**
* Use **Docker secrets (Swarm)**
* Use **Vault / AWS Secrets Manager / Azure Key Vault**
* Inject secrets at runtime

---

### 💡 In short (quick recall)

* Env vars are **easy to leak**
* Visible via inspect, logs, memory
* Use **file-based or external secrets managers** instead
---
## Q144: How would you integrate external secret management (Vault, AWS Secrets Manager)?

🧠 **Overview**

* External secret managers provide **centralized, encrypted, auditable secrets** with **IAM-based access and rotation**.
* Integration pattern: **authenticate → fetch secret at runtime → inject securely → never bake into image**.

---

## 🔐 Core integration patterns (interview-ready)

### Pattern 1️⃣ Runtime fetch (most common)

* Container authenticates using **IAM / Kubernetes SA / Vault role**
* Fetches secrets on startup
* Injects into app (env var or file)

---

### Pattern 2️⃣ Sidecar / Agent

* Vault Agent runs alongside app
* Writes secrets to **in-memory files**
* App reads from file

---

### Pattern 3️⃣ Platform-native injection

* ECS / EKS / Kubernetes inject secrets automatically
* App never talks directly to secret manager

---

## ☁️ AWS Secrets Manager – Docker integration

### 1️⃣ IAM-based access (best practice)

* Attach IAM role to:

  * EC2 instance / ECS task / EKS service account
* **No static credentials**

---

### 2️⃣ Fetch secret at runtime

```bash
aws secretsmanager get-secret-value \
  --secret-id db_password \
  --query SecretString \
  --output text
```

---

### 3️⃣ Entrypoint injection pattern

```bash
#!/bin/sh
export DB_PASSWORD=$(aws secretsmanager get-secret-value \
  --secret-id db_password \
  --query SecretString \
  --output text)

exec ./app
```

* **Why:** Secrets fetched only at runtime
* **Note:** Avoid logging

---

## 🔐 HashiCorp Vault – Docker integration

### Option A️⃣ Vault Agent (recommended)

```hcl
auto_auth {
  method "aws" {
    mount_path = "auth/aws"
    config = { type = "iam" }
  }
}

sink "file" {
  config = { path = "/run/secrets/db_password" }
}
```

* App reads from `/run/secrets/db_password`
* **Rotation handled automatically**

---

### Option B️⃣ Direct API (not ideal)

```bash
vault kv get -field=password secret/db
```

* **Cons:** App manages auth & renewal

---

## ☸️ Kubernetes-native (best in prod)

### AWS (EKS)

* **IRSA** + External Secrets Operator

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
```

### Vault

* Vault Agent Injector
* Secrets mounted as files

---

## 🔒 Security best practices

* Use **IAM / workload identity**
* Prefer **file-based secrets**
* Enable **rotation**
* Enforce **least privilege policies**
* Never log secrets

---

## ⚠️ Interview pitfalls

* Baking secrets into images ❌
* Using static AWS keys ❌
* Fetching secrets at build time ❌
* Long-lived tokens ❌

---

### 💡 In short (quick recall)

* Authenticate via **workload identity**
* Fetch secrets **at runtime**
* Inject as **files**
* Rotate & audit centrally

---
## Q145: What is Docker BuildKit and what advantages does it offer?

🧠 **Overview**

* **Docker BuildKit** is Docker’s **next-generation build engine**.
* It replaces the legacy builder with **faster, more secure, and more efficient image builds**, especially for CI/CD.

---

## ⚙️ How BuildKit works (high level)

* Builds stages **in parallel**
* Uses **smart caching** (local + remote)
* Executes only **changed layers**
* Supports **secure secret handling at build time**

---

## 🚀 Key advantages of BuildKit

| Feature              | Benefit                | Why it matters             |
| -------------------- | ---------------------- | -------------------------- |
| **Parallel builds**  | Faster builds          | Shorter CI pipelines       |
| **Advanced caching** | Reuse unchanged layers | Cost & time savings        |
| **Build secrets**    | No secret leaks        | Secure builds              |
| **Mount types**      | Cache, tmpfs           | Efficient builds           |
| **Multi-platform**   | `linux/amd64`, `arm64` | One pipeline, many targets |

---

## 🧩 Practical examples

### 1️⃣ Enable BuildKit

```bash
export DOCKER_BUILDKIT=1
```

* **Does:** Switches Docker to BuildKit engine
* **Note:** Enabled by default in newer Docker versions

---

### 2️⃣ Build-time secrets (huge security win)

```bash
docker build \
  --secret id=npm_token,src=$HOME/.npmrc \
  -t myapp .
```

Dockerfile:

```Dockerfile
# syntax=docker/dockerfile:1.6
RUN --mount=type=secret,id=npm_token \
    npm install
```

* **Why:** Secrets never end up in image layers
* **Interview gold:** Solves secret leakage during builds

---

### 3️⃣ Cache mounts (faster CI builds)

```Dockerfile
RUN --mount=type=cache,target=/root/.cache \
    pip install -r requirements.txt
```

* **Why:** Reuses dependency cache across builds
* **Result:** Massive speed-up in CI

---

### 4️⃣ Multi-platform builds

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t myapp:1.0 .
```

* **Use case:** ARM + x86 clusters

---

## 🔒 Security improvements vs legacy builder

| Area            | Legacy builder   | BuildKit             |
| --------------- | ---------------- | -------------------- |
| Secrets         | Leaked in layers | Secure secret mounts |
| Cache isolation | Weak             | Strong               |
| Attack surface  | Larger           | Smaller              |

---

## 🌍 Real-World Usage

* Default in **modern Docker**
* Used heavily in **GitHub Actions, GitLab CI**
* Required for **secure multi-stage builds**

---

### 💡 In short (quick recall)

* BuildKit = faster, parallel, secure Docker builds
* Enables **build secrets & cache mounts**
* Essential for modern CI/CD

----
## Q146: How do you enable Docker BuildKit?

🧠 **Overview**

* **BuildKit** is Docker’s modern build engine.
* It can be enabled **temporarily**, **per user**, or **globally**, depending on your setup (local, CI, prod).

---

## 🔧 Ways to enable BuildKit (interview-ready)

### 1️⃣ Enable per command (quickest)

```bash
DOCKER_BUILDKIT=1 docker build -t myapp .
```

* **Use when:** Testing or one-off builds
* **No config change**

---

### 2️⃣ Enable per user (recommended for dev/CI)

```bash
export DOCKER_BUILDKIT=1
```

Add to:

```bash
~/.bashrc  or  ~/.zshrc
```

* **Effect:** All `docker build` commands use BuildKit
* **Common in:** CI runners

---

### 3️⃣ Enable globally (system-wide)

Edit Docker daemon config:

```bash
sudo vi /etc/docker/daemon.json
```

```json
{
  "features": {
    "buildkit": true
  }
}
```

Restart Docker:

```bash
sudo systemctl restart docker
```

* **Use when:** Standardizing builds across hosts

---

### 4️⃣ Enable in CI/CD (best practice)

#### GitHub Actions

```yaml
env:
  DOCKER_BUILDKIT: 1
```

#### GitLab CI

```yaml
variables:
  DOCKER_BUILDKIT: "1"
```

---

## 🧪 Verify BuildKit is enabled

```bash
docker build .
```

You should see:

```text
[+] Building ...
```

(instead of legacy step-by-step output)

---

## ⚠️ Important notes (interview traps)

* New Docker versions **enable BuildKit by default**
* BuildKit is required for:

  * Build secrets
  * Cache mounts
  * `buildx`
* Legacy builder is **deprecated**

---

### 💡 In short (quick recall)

* Set `DOCKER_BUILDKIT=1`
* Or enable via `daemon.json`
* Enabled by default in modern Docker

----
## Q147: What are BuildKit cache mounts?

🧠 **Overview**

* **BuildKit cache mounts** let you **persist and reuse build-time caches** between Docker builds.
* They dramatically **speed up CI/CD builds** by avoiding repeated downloads or compilations.
* Cache data is **not baked into the final image**, keeping images clean and secure.

---

## ⚙️ How cache mounts work

* Cache directories are stored **outside image layers**
* Reused across builds when the same cache key is used
* Invalidated automatically when inputs change

---

## 🧩 Syntax (BuildKit-only)

```Dockerfile
RUN --mount=type=cache,target=<path> <command>
```

> Requires:

```Dockerfile
# syntax=docker/dockerfile:1.6
```

---

## 🚀 Practical examples

### 1️⃣ Python dependencies (pip)

```Dockerfile
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt
```

* **Why:** Reuses downloaded wheels
* **Result:** Faster rebuilds in CI

---

### 2️⃣ Node.js (npm)

```Dockerfile
RUN --mount=type=cache,target=/root/.npm \
    npm ci
```

* **Why:** Avoids re-downloading packages

---

### 3️⃣ Go modules

```Dockerfile
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download
```

* **Why:** Speeds up module resolution

---

## 🔐 Security benefits

* Cache content **never ends up in the final image**
* No risk of leaking credentials or build tools
* Safer than copying cache into layers

---

## 🧪 Cache mounts vs layer cache

| Feature                   | Layer cache | Cache mounts |
| ------------------------- | ----------- | ------------ |
| Stored in image           | Yes         | No           |
| Speeds dependency install | Limited     | Excellent    |
| Secure                    | Medium      | High         |
| CI-friendly               | Poor        | Excellent    |

---

## 🌍 Real-World Usage

* Standard in **modern CI pipelines**
* Used with **GitHub Actions cache**, **GitLab runners**
* Critical for large monorepos

---

## ⚠️ Interview traps

* Cache mounts are **build-time only**
* Require **BuildKit**
* Not available in legacy builder

---

### 💡 In short (quick recall)

* Cache mounts persist build caches across builds
* Speed up dependency-heavy steps
* Don’t bloat or pollute final images

---
## Q148: How do BuildKit secrets differ from multi-stage builds for secrets?

🧠 **Overview**

* Both approaches aim to **avoid leaking secrets into final images**, but they solve **different problems**.
* **BuildKit secrets** are the **secure, modern solution**.
* **Multi-stage builds** are a **workaround**, not true secret handling.

---

## 🔐 Core difference (interview-ready)

| Aspect          | BuildKit secrets                  | Multi-stage builds              |
| --------------- | --------------------------------- | ------------------------------- |
| Secret exposure | **Never written to image layers** | Can leak if misused             |
| Storage         | In-memory mount                   | Filesystem layers               |
| Cleanup         | Automatic                         | Manual                          |
| Risk            | Very low                          | Medium                          |
| Recommended     | ✅ Yes                             | ⚠️ Only if BuildKit unavailable |

---

## 🧩 BuildKit secrets (secure way)

```bash
docker build \
  --secret id=npm_token,src=$HOME/.npmrc \
  -t myapp .
```

Dockerfile:

```Dockerfile
# syntax=docker/dockerfile:1.6
RUN --mount=type=secret,id=npm_token \
    npm install
```

* **What happens:** Secret is available **only during this RUN**
* **Never cached or stored**
* **Best practice**

---

## 🧩 Multi-stage build (workaround)

```Dockerfile
FROM node:20 AS build
ARG NPM_TOKEN
RUN echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > .npmrc
RUN npm install

FROM node:20
COPY --from=build /app /app
```

* **Risk:** Secret may exist in:

  * Build cache
  * Intermediate layers
  * CI logs
* **Requires discipline** to avoid leaks

---

## ⚠️ Why multi-stage builds are not enough

* Secrets may:

  * Be cached
  * Be recovered from layers
  * Appear in build history
* Human error = secret leak

---

## 🌍 Real-World Recommendation

* Use **BuildKit secrets** everywhere
* Use multi-stage builds **only** to reduce image size
* Enforce BuildKit in CI

---

### 💡 In short (quick recall)

* BuildKit secrets = **true secret handling**
* Multi-stage builds = **partial mitigation**
* Prefer BuildKit for secure CI builds

---
## Q149: What is Docker Buildx?

🧠 **Overview**

* **Docker Buildx** is a **CLI plugin for Docker BuildKit**.
* It enables **advanced build features** like **multi-platform images, remote builders, and advanced caching**.
* Buildx is the **recommended way to build images today**, especially in CI/CD.

---

## ⚙️ What Buildx adds on top of Docker build

| Feature             | `docker build`    | `docker buildx`   |
| ------------------- | ----------------- | ----------------- |
| Build engine        | Legacy / BuildKit | **BuildKit only** |
| Multi-platform      | ❌                 | ✅                 |
| Remote builders     | ❌                 | ✅                 |
| Cache export/import | ❌                 | ✅                 |
| Advanced outputs    | ❌                 | ✅                 |

---

## 🚀 Key capabilities of Buildx

### 1️⃣ Multi-platform builds (biggest use case)

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t myapp:1.0 .
```

* **Why:** Run same image on x86 & ARM (EKS, Graviton)
* **Interview gold**

---

### 2️⃣ Create and use a builder

```bash
docker buildx create --name mybuilder --use
```

* **Does:** Creates a BuildKit builder instance
* **Why:** Enables isolated, reproducible builds

---

### 3️⃣ Push directly to registry

```bash
docker buildx build --push -t myapp:1.0 .
```

* **Why:** Multi-arch images must be pushed (not loaded locally)

---

### 4️⃣ Advanced caching

```bash
docker buildx build \
  --cache-from=type=registry,ref=myapp:cache \
  --cache-to=type=registry,ref=myapp:cache \
  .
```

* **Why:** Fast builds across CI runs

---

## 🔒 Security & CI/CD benefits

* Works with **BuildKit secrets**
* Supports **rootless builders**
* Isolated build environments

---

## 🌍 Real-World Usage

* Default in **modern CI pipelines**
* Used for:

  * ARM + x86 clusters
  * Multi-region builds
  * Cloud-native deployments

---

## ⚠️ Interview traps

* `buildx` ≠ separate daemon
* Requires **BuildKit**
* Multi-platform images require `--push`

---

### 💡 In short (quick recall)

* Buildx = advanced CLI for BuildKit
* Enables multi-platform & remote builds
* Essential for modern CI/CD

---
## Q150: How do you build multi-platform images with Buildx?

🧠 **Overview**

* **Multi-platform images** support multiple CPU architectures (e.g., **amd64**, **arm64**) under **one image tag**.
* **Docker Buildx** uses **BuildKit** + **QEMU emulation** or native builders to create these images.
* Essential for **EKS Graviton, Apple Silicon, hybrid clusters**.

---

## ⚙️ Step-by-step: Build multi-platform images

### 1️⃣ Enable Buildx (verify)

```bash
docker buildx version
```

* **Why:** Confirms Buildx is available

---

### 2️⃣ Create & use a Buildx builder

```bash
docker buildx create --name multiarch --use
docker buildx inspect --bootstrap
```

* **Does:** Starts a BuildKit builder with emulation support

---

### 3️⃣ Build & push multi-platform image

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t myorg/myapp:1.0 \
  --push .
```

* **Why `--push`:** Multi-arch images must be stored in registry
* **Output:** Single tag with multiple architectures (manifest list)

---

## 🧪 Verify multi-platform image

```bash
docker buildx imagetools inspect myorg/myapp:1.0
```

Output:

```text
Manifests:
  linux/amd64
  linux/arm64
```

---

## 🔒 Security & performance notes

* Prefer **native builders** over QEMU for performance
* Use **BuildKit secrets + cache mounts**
* Scan **all architectures** for vulnerabilities

---

## 🌍 CI/CD example (GitHub Actions)

```yaml
- uses: docker/setup-buildx-action@v3
- uses: docker/build-push-action@v5
  with:
    platforms: linux/amd64,linux/arm64
    push: true
    tags: myorg/myapp:1.0
```

---

## ⚠️ Interview traps

* Forgetting `--push` ❌
* Using `docker build` instead of `buildx` ❌
* Assuming single-arch images work everywhere ❌

---

### 💡 In short (quick recall)

* Use `docker buildx build`
* Specify `--platform`
* Push to registry to create multi-arch manifests

----
## Q151: What are Docker manifest lists?

🧠 **Overview**

* A **Docker manifest list** (also called a **multi-arch manifest**) is a **single image tag that points to multiple architecture-specific images**.
* Docker automatically pulls the **correct image for the client’s OS/CPU**.

👉 One tag → many architectures.

---

## 🧩 How manifest lists work

```text
myapp:1.0
 ├─ linux/amd64 → image digest A
 ├─ linux/arm64 → image digest B
 └─ linux/arm/v7 → image digest C
```

* Docker client checks host architecture
* Pulls the matching image transparently

---

## 🚀 Why manifest lists matter

| Benefit       | Why it’s important               |
| ------------- | -------------------------------- |
| Single tag    | No arch-specific tags            |
| Portability   | Works on x86, ARM, Apple Silicon |
| Cloud-ready   | Supports Graviton, edge devices  |
| CI simplicity | One release artifact             |

---

## 🛠️ Creating manifest lists (Buildx – recommended)

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t myorg/myapp:1.0 \
  --push .
```

* Buildx automatically creates the **manifest list**
* No manual steps needed

---

## 🧪 Inspect a manifest list

```bash
docker buildx imagetools inspect myorg/myapp:1.0
```

Output:

```text
Manifests:
  Name: linux/amd64
  Name: linux/arm64
```

---

## 🧪 Manual creation (older method)

```bash
docker manifest create myapp:1.0 myapp:amd64 myapp:arm64
docker manifest push myapp:1.0
```

* **Legacy approach**
* Buildx is preferred

---

## ⚠️ Interview pitfalls

* Manifest list ≠ image layer
* Requires registry support (Docker Hub, ECR, ACR)
* Multi-arch images must be **pushed**, not just built locally

---

## 🌍 Real-World Usage

* **EKS Graviton (ARM) + x86 clusters**
* **Apple Silicon dev machines**
* **Edge deployments**

---

### 💡 In short (quick recall)

* Manifest list = one tag, many architectures
* Docker pulls the right image automatically
* Created automatically by Buildx

---
## Q152: How do you create and push multi-architecture images?

🧠 **Overview**

* Multi-architecture images allow **one image tag** to run on **multiple CPU architectures** (amd64, arm64, etc.).
* Best practice is to use **Docker Buildx**, which builds per-arch images and publishes a **manifest list** to the registry.

---

## ⚙️ Step-by-step (production-ready)

### 1️⃣ Ensure Buildx is available

```bash
docker buildx version
```

* **Why:** Multi-arch builds require Buildx (BuildKit).

---

### 2️⃣ Create and use a Buildx builder

```bash
docker buildx create --name multiarch --use
docker buildx inspect --bootstrap
```

* **Does:** Starts a BuildKit builder with QEMU/native support.
* **Why:** Needed to build for non-native architectures.

---

### 3️⃣ Build and push multi-arch image

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t myorg/myapp:1.0 \
  --push .
```

* **`--platform`**: Target architectures
* **`--push`**: Required to publish a manifest list
* **Result**: One tag (`myapp:1.0`) → multiple arch images

---

## 🧪 Verify the pushed image

```bash
docker buildx imagetools inspect myorg/myapp:1.0
```

You should see multiple manifests:

```text
linux/amd64
linux/arm64
```

---

## 🔒 CI/CD example (GitHub Actions)

```yaml
- uses: docker/setup-buildx-action@v3
- uses: docker/build-push-action@v5
  with:
    platforms: linux/amd64,linux/arm64
    push: true
    tags: myorg/myapp:1.0
```

---

## ⚠️ Common mistakes (interview traps)

* Forgetting `--push` ❌ (no manifest list created)
* Using `docker build` instead of `buildx` ❌
* Assuming single-arch images work on ARM ❌

---

## 🌍 Real-world usage

* **EKS Graviton (ARM) + x86 clusters**
* **Apple Silicon developers**
* **Edge/IoT workloads**

---

### 💡 In short (quick recall)

* Use `docker buildx build`
* Specify `--platform`
* Push to registry to create the **multi-arch manifest**

---
## Q153: What strategies would you use for optimizing Docker image size?

🧠 **Overview**

* Smaller images are **faster to build, pull, and deploy**, and have a **smaller attack surface**.
* Image optimization focuses on **base image choice, build process, and cleanup**.

---

## 🔑 Core strategies (production-ready)

### 1️⃣ Use minimal base images

```Dockerfile
FROM gcr.io/distroless/base-debian12
```

* **Why:** Removes shells, package managers, OS clutter
* **Result:** Fewer CVEs, smaller size

---

### 2️⃣ Multi-stage builds (most important)

```Dockerfile
FROM golang:1.22 AS build
RUN go build -o app

FROM gcr.io/distroless/base
COPY --from=build /app /app
```

* **Why:** Excludes compilers & build tools
* **Interview gold**

---

### 3️⃣ Clean up package manager caches

```Dockerfile
RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*
```

* **Why:** Prevents cache bloat
* **Note:** Always clean in the same layer

---

### 4️⃣ Reduce number of layers

```Dockerfile
RUN npm install && npm cache clean --force
```

* **Why:** Fewer layers → smaller image
* **Tip:** Combine related commands

---

### 5️⃣ Use `.dockerignore`

```dockerignore
node_modules
.git
tests
```

* **Why:** Reduces build context size
* **Often overlooked**

---

### 6️⃣ Avoid unnecessary files

* Don’t copy:

  * Docs
  * Tests
  * `.git`
* Copy only what app needs

```Dockerfile
COPY dist/ /app/
```

---

### 7️⃣ Prefer runtime-only dependencies

* Example: Use `node:20-slim` instead of full `node`

---

### 8️⃣ Strip binaries (for compiled apps)

```bash
strip app
```

* **Why:** Removes debug symbols

---

## 🔒 Security + size win

* Smaller images → fewer CVEs
* Faster vulnerability scanning
* Faster rollbacks

---

## ⚠️ Common mistakes (interview traps)

* Using `latest` full images ❌
* Single-stage builds ❌
* Copying entire repo ❌
* Leaving package caches ❌

---

### 💡 In short (quick recall)

* Minimal base image
* Multi-stage builds
* Clean caches
* `.dockerignore`
* Copy only runtime artifacts

---
## Q154: How do you analyze image layers to identify bloat?

🧠 **Overview**

* Image bloat comes from **large layers, cached files, and unnecessary artifacts**.
* Layer analysis helps you **pinpoint exactly what increased image size** and fix it at the Dockerfile level.

---

## 🔍 Core tools for layer analysis

| Tool             | Purpose                    | Why use it               |
| ---------------- | -------------------------- | ------------------------ |
| `docker history` | Layer size view            | Quick inspection         |
| `docker inspect` | Metadata                   | Understand layer config  |
| **dive**         | Interactive layer analysis | Best for bloat detection |
| `docker save`    | Export layers              | Deep manual analysis     |

---

## 🧩 Step-by-step analysis

### 1️⃣ Check layer sizes (quick win)

```bash
docker history myapp:1.0
```

Example output:

```text
<missing>  350MB  apt-get install ...
<missing>   50MB  npm install
```

* **What to look for:** Huge layers → optimization target

---

### 2️⃣ Use Dive (best tool)

```bash
dive myapp:1.0
```

* **Shows:**

  * Size per layer
  * Files added/removed
  * Wasted space
* **Why:** Visual, precise, fast

---

### 3️⃣ Inspect filesystem inside container

```bash
docker run --rm -it myapp:1.0 sh
du -sh /*
```

* **Why:** Finds large directories (`/usr`, `/var`, `/node_modules`)

---

### 4️⃣ Export and inspect layers (deep dive)

```bash
docker save myapp:1.0 | tar -tv
```

* **Why:** Manual forensics
* **Use:** Rare, but useful for audits

---

## 🔧 Common bloat patterns & fixes

| Cause          | Symptom              | Fix                  |
| -------------- | -------------------- | -------------------- |
| Package cache  | Large `/var/lib/apt` | Clean in same RUN    |
| Build tools    | Compilers present    | Multi-stage build    |
| Node modules   | Huge `node_modules`  | Production-only deps |
| Copy all files | `.git`, tests        | Use `.dockerignore`  |

---

## 🛠️ Dockerfile fix example

❌ Bad:

```Dockerfile
RUN apt-get update
RUN apt-get install -y curl
```

✅ Good:

```Dockerfile
RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*
```

---

## 🌍 Real-World CI Practice

* Add **Dive** or size checks in CI
* Fail build if image size > threshold
* Track image size trends per commit

---

### 💡 In short (quick recall)

* Use `docker history` for quick checks
* Use **dive** for detailed analysis
* Fix bloat in Dockerfile layers

---
## Q154: How do you analyze image layers to identify bloat?

🧠 **Overview**

* Image bloat comes from **large layers, cached files, and unnecessary artifacts**.
* Layer analysis helps you **pinpoint exactly what increased image size** and fix it at the Dockerfile level.

---

## 🔍 Core tools for layer analysis

| Tool             | Purpose                    | Why use it               |
| ---------------- | -------------------------- | ------------------------ |
| `docker history` | Layer size view            | Quick inspection         |
| `docker inspect` | Metadata                   | Understand layer config  |
| **dive**         | Interactive layer analysis | Best for bloat detection |
| `docker save`    | Export layers              | Deep manual analysis     |

---

## 🧩 Step-by-step analysis

### 1️⃣ Check layer sizes (quick win)

```bash
docker history myapp:1.0
```

Example output:

```text
<missing>  350MB  apt-get install ...
<missing>   50MB  npm install
```

* **What to look for:** Huge layers → optimization target

---

### 2️⃣ Use Dive (best tool)

```bash
dive myapp:1.0
```

* **Shows:**

  * Size per layer
  * Files added/removed
  * Wasted space
* **Why:** Visual, precise, fast

---

### 3️⃣ Inspect filesystem inside container

```bash
docker run --rm -it myapp:1.0 sh
du -sh /*
```

* **Why:** Finds large directories (`/usr`, `/var`, `/node_modules`)

---

### 4️⃣ Export and inspect layers (deep dive)

```bash
docker save myapp:1.0 | tar -tv
```

* **Why:** Manual forensics
* **Use:** Rare, but useful for audits

---

## 🔧 Common bloat patterns & fixes

| Cause          | Symptom              | Fix                  |
| -------------- | -------------------- | -------------------- |
| Package cache  | Large `/var/lib/apt` | Clean in same RUN    |
| Build tools    | Compilers present    | Multi-stage build    |
| Node modules   | Huge `node_modules`  | Production-only deps |
| Copy all files | `.git`, tests        | Use `.dockerignore`  |

---

## 🛠️ Dockerfile fix example

❌ Bad:

```Dockerfile
RUN apt-get update
RUN apt-get install -y curl
```

✅ Good:

```Dockerfile
RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*
```

---

## 🌍 Real-World CI Practice

* Add **Dive** or size checks in CI
* Fail build if image size > threshold
* Track image size trends per commit

---

### 💡 In short (quick recall)

* Use `docker history` for quick checks
* Use **dive** for detailed analysis
* Fix bloat in Dockerfile layers

---
## Q156: How do you implement distroless images?

🧠 **Overview**

* **Distroless images** contain **only the application and runtime dependencies**—no shell, no package manager, no OS utilities.
* They **dramatically reduce image size and attack surface**, making them ideal for production.

---

## 🔐 Why distroless images

| Benefit           | Impact                  |
| ----------------- | ----------------------- |
| Smaller size      | Faster pull & deploy    |
| Fewer CVEs        | Better security posture |
| No shell/tools    | Harder for attackers    |
| Immutable runtime | Predictable behavior    |

---

## ⚙️ Implementation pattern (best practice)

### 1️⃣ Use multi-stage builds

Build in a full image, run in distroless.

---

### 🧩 Example: Go application

```Dockerfile
FROM golang:1.22 AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app

FROM gcr.io/distroless/base-debian12
WORKDIR /app
COPY --from=build /app/app /app/app
USER nonroot:nonroot
CMD ["/app/app"]
```

* **Why:** No compiler or shell in final image
* **Security:** Runs as non-root

---

### 🧩 Example: Node.js application

```Dockerfile
FROM node:20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .

FROM gcr.io/distroless/nodejs20-debian12
WORKDIR /app
COPY --from=build /app /app
USER nonroot
CMD ["server.js"]
```

---

## 🛠️ Distroless image variants

| Image     | Use case        |
| --------- | --------------- |
| `base`    | Native binaries |
| `nodejs`  | Node.js apps    |
| `java17`  | Java apps       |
| `python3` | Python apps     |

---

## ⚠️ Common pitfalls (interview traps)

* No shell → `exec` form only (`CMD ["app"]`)
* Debugging is harder (use debug images)
* Apps writing to `/` will fail (use volumes/tmpfs)

---

## 🔧 Debugging distroless images

```bash
docker run --rm -it --entrypoint sh gcr.io/distroless/base:debug
```

* **Use only for debugging**
* Never in production

---

## 🌍 Real-World Usage

* Standard for **production microservices**
* Used in **EKS, GKE, AKS**
* Combined with:

  * Read-only FS
  * Dropped capabilities
  * Seccomp

---

### 💡 In short (quick recall)

* Build with full image, run with distroless
* Multi-stage builds are mandatory
* Smaller, safer, production-grade images

---
## Q157: What are the benefits and challenges of distroless images?

🧠 **Overview**

* **Distroless images** remove shells, package managers, and OS utilities, shipping **only the app and runtime**.
* This improves **security and performance**, but changes how you **debug and build** containers.

---

## ✅ Benefits (why teams use them)

| Benefit                        | Why it matters in production           |
| ------------------------------ | -------------------------------------- |
| **Smaller image size**         | Faster pulls, faster deploys           |
| **Reduced attack surface**     | Fewer binaries → fewer CVEs            |
| **No shell / package manager** | Harder for attackers to move laterally |
| **Predictable runtime**        | Immutable, reproducible images         |
| **Better compliance**          | Easier to pass security reviews        |

---

## ⚠️ Challenges (what to plan for)

| Challenge             | Impact                | How to handle                |
| --------------------- | --------------------- | ---------------------------- |
| **No shell/tools**    | Hard to exec/debug    | Use debug images or sidecars |
| **Strict filesystem** | Apps may fail writing | Use volumes/tmpfs            |
| **Build complexity**  | Multi-stage required  | Standardize Dockerfiles      |
| **Logging issues**    | No log tools          | Log to stdout/stderr         |
| **Package installs**  | Impossible at runtime | Install at build time only   |

---

## 🧩 Real-world example challenge

❌ Fails:

```Dockerfile
CMD sh -c "node server.js"
```

✅ Works:

```Dockerfile
CMD ["node", "server.js"]
```

* Distroless **requires exec form**

---

## 🔒 Security trade-offs (interview gold)

* **Pro:** Smaller attack surface
* **Con:** Harder to investigate incidents
* **Mitigation:** Debug variants + observability

---

## 🌍 When to use distroless

* Production microservices
* Internet-facing APIs
* Compliance-driven environments

## 🚫 When NOT to use

* Heavy debugging workloads
* Legacy apps expecting OS tools
* Ad-hoc admin containers

---

### 💡 In short (quick recall)

* Distroless = **secure, small, immutable**
* Trade-off = **debugging & flexibility**
* Best for **production**, not dev

---
## Q158: How would you implement scratch-based images?

🧠 **Overview**

* **`scratch`** is an **empty base image** (literally nothing).
* Scratch-based images contain **only your application binary**, giving the **smallest possible image** and **minimal attack surface**.
* Best suited for **statically compiled binaries** (Go, Rust).

---

## ⚙️ Implementation pattern (step-by-step)

### 1️⃣ Build a static binary (example: Go)

```Dockerfile
FROM golang:1.22 AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app
```

* **Why:** Static binary doesn’t need OS libraries

---

### 2️⃣ Use scratch as final image

```Dockerfile
FROM scratch
WORKDIR /app
COPY --from=build /app/app /app/app
USER 1000
ENTRYPOINT ["/app/app"]
```

* **Result:** Image size often **<10MB**
* **Security:** No shell, no package manager, no libc

---

## 🔐 Handling common needs

### TLS certificates (very important)

```Dockerfile
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
```

Or build certs explicitly:

```Dockerfile
RUN apk add --no-cache ca-certificates
```

---

### Non-root user

* Scratch has no users → use numeric UID

```Dockerfile
USER 1000
```

---

### Writable paths

* Scratch FS is empty
* Mount writable dirs at runtime

```bash
docker run -v /tmp myapp
```

---

## ⚠️ Challenges & limitations

| Limitation         | Impact                     |
| ------------------ | -------------------------- |
| No shell/tools     | No exec debugging          |
| No package manager | All deps must be static    |
| No libc            | Dynamic binaries won’t run |
| No certs           | TLS fails unless added     |

---

## 🌍 When to use scratch

* Go / Rust / C static services
* High-security environments
* Performance-sensitive microservices

---

## 🚫 When NOT to use

* Java, Node, Python apps
* Apps needing OS utilities
* Heavy debugging workflows

---

### 💡 In short (quick recall)

* Scratch = empty image
* Requires static binary
* Ultra-small and ultra-secure
* Harder to debug

---
## Q159: When would you use Alpine vs Ubuntu vs Distroless base images?

🧠 **Overview**

* Base image choice impacts **security, size, compatibility, and operability**.
* There’s no single “best” image — choose based on **runtime needs, debugging, and risk tolerance**.

---

## 🔍 Comparison table (interview-ready)

| Base image     | Best for                 | Pros                   | Cons                  |
| -------------- | ------------------------ | ---------------------- | --------------------- |
| **Alpine**     | Lightweight apps, CI     | Very small, fast pulls | `musl` libc issues    |
| **Ubuntu**     | Complex/legacy apps      | Maximum compatibility  | Large size, more CVEs |
| **Distroless** | Production microservices | Minimal, secure        | Harder debugging      |

---

## 🧩 When to use each (real-world guidance)

### 🟢 Alpine

**Use when:**

* Small footprint matters
* App works with `musl`
* You want package installs

```Dockerfile
FROM alpine:3.20
RUN apk add --no-cache curl
```

**Avoid when:**

* Native deps expect `glibc`
* Java apps with native libraries

---

### 🔵 Ubuntu

**Use when:**

* Debugging is frequent
* App depends on OS packages
* Legacy or vendor software

```Dockerfile
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y curl
```

**Trade-off:** Bigger images, slower CI

---

### 🟣 Distroless

**Use when:**

* Production-ready microservices
* Security is priority
* App doesn’t need OS tools

```Dockerfile
FROM gcr.io/distroless/base-debian12
```

**Note:** Use multi-stage builds

---

## 🔒 Security & operations trade-offs

| Requirement     | Best choice |
| --------------- | ----------- |
| Fast CI builds  | Alpine      |
| Lowest CVEs     | Distroless  |
| Debug-friendly  | Ubuntu      |
| Production APIs | Distroless  |
| Legacy apps     | Ubuntu      |

---

## ⚠️ Interview traps

* Alpine is not always safest (musl issues)
* Distroless is not for development
* Ubuntu is often overused

---

### 💡 In short (quick recall)

* **Alpine:** Small, flexible, CI-friendly
* **Ubuntu:** Compatible, debug-friendly
* **Distroless:** Secure, production-grade

----
## Q160: What strategies would you use for Docker layer caching in CI/CD?

🧠 **Overview**

* Docker layer caching **dramatically speeds up CI/CD builds** by reusing unchanged layers.
* A good strategy combines **Dockerfile design**, **BuildKit features**, and **CI-native caching**.

---

## 🔑 Core caching strategies (production-ready)

### 1️⃣ Order Dockerfile instructions correctly (most important)

```Dockerfile
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
```

* **Why:** Dependency layers change less often than source code
* **Result:** `npm ci` layer is cached

---

### 2️⃣ Use BuildKit cache mounts

```Dockerfile
RUN --mount=type=cache,target=/root/.cache/npm \
    npm ci
```

* **Why:** Reuses dependency cache across CI runs
* **Works best with:** BuildKit + Buildx

---

### 3️⃣ Enable BuildKit everywhere

```bash
export DOCKER_BUILDKIT=1
```

* **Why:** Required for advanced caching
* **Default in modern Docker**

---

### 4️⃣ Use remote cache (registry-based)

```bash
docker buildx build \
  --cache-from=type=registry,ref=myorg/myapp:cache \
  --cache-to=type=registry,ref=myorg/myapp:cache \
  .
```

* **Why:** CI runners are ephemeral
* **Result:** Cache survives across jobs

---

### 5️⃣ Use CI-native cache (fallback)

* GitHub Actions cache
* GitLab CI cache
* Jenkins persistent workspaces

Used mainly for:

* Dependency caches
* Build artifacts

---

### 6️⃣ Avoid cache-busting patterns ❌

```Dockerfile
RUN apt-get update
```

* Always changes → cache miss

✅ Fix:

```Dockerfile
RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*
```

---

## 🌍 CI/CD example (GitHub Actions + Buildx)

```yaml
- uses: docker/setup-buildx-action@v3
- uses: docker/build-push-action@v5
  with:
    cache-from: type=registry,ref=myorg/myapp:cache
    cache-to: type=registry,ref=myorg/myapp:cache,mode=max
```

---

## ⚠️ Common mistakes (interview traps)

* Relying on local cache in CI ❌
* Poor Dockerfile instruction order ❌
* Disabling BuildKit ❌

---

### 💡 In short (quick recall)

* Optimize Dockerfile order
* Use BuildKit cache mounts
* Persist cache remotely in CI

----
## Q161: How do you implement remote caching for Docker builds?

🧠 **Overview**

* **Remote caching** stores Docker build cache **outside the CI runner** (usually in a registry).
* This enables **fast builds across ephemeral CI agents** and consistent cache reuse.

---

## 🔑 Core approaches (production-ready)

### 1️⃣ Registry-based cache (Buildx + BuildKit) ⭐ **Best**

* Store cache as OCI artifacts in a container registry (ECR/ACR/Docker Hub).
* Works across pipelines and runners.

---

### 2️⃣ CI-native cache (secondary)

* GitHub/GitLab/Jenkins workspace caches.
* Good for **dependency caches**, not full Docker layers.

---

## ⚙️ Registry-based remote cache (step-by-step)

### 1️⃣ Enable BuildKit & Buildx

```bash
export DOCKER_BUILDKIT=1
docker buildx create --name builder --use
docker buildx inspect --bootstrap
```

---

### 2️⃣ Push cache to registry

```bash
docker buildx build \
  --cache-to=type=registry,ref=myorg/myapp:buildcache,mode=max \
  -t myorg/myapp:1.0 \
  --push .
```

* **`mode=max`**: Stores all intermediate layers
* **Result:** Cache artifact stored in registry

---

### 3️⃣ Pull cache in next build

```bash
docker buildx build \
  --cache-from=type=registry,ref=myorg/myapp:buildcache \
  -t myorg/myapp:1.1 \
  --push .
```

* **Effect:** Reuses unchanged layers → faster builds

---

## ☁️ Cloud registry examples

### AWS ECR

```bash
--cache-from=type=registry,ref=123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:cache
--cache-to=type=registry,ref=123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:cache,mode=max
```

### Azure ACR

```bash
--cache-to=type=registry,ref=myacr.azurecr.io/myapp:cache,mode=max
```

---

## 🧪 GitHub Actions example

```yaml
- uses: docker/setup-buildx-action@v3
- uses: docker/build-push-action@v5
  with:
    push: true
    tags: myorg/myapp:1.0
    cache-from: type=registry,ref=myorg/myapp:buildcache
    cache-to: type=registry,ref=myorg/myapp:buildcache,mode=max
```

---

## 🧠 Dockerfile tips to maximize cache hits

* Copy dependency files **before** source code
* Avoid cache-busting commands
* Use **BuildKit cache mounts** for package managers

---

## ⚠️ Common pitfalls (interview traps)

* Using local cache in CI ❌
* Forgetting `--cache-to` ❌
* Poor Dockerfile instruction order ❌
* Mixing cache tags with app tags ❌

---

### 💡 In short (quick recall)

* Use **Buildx registry cache**
* `--cache-to` to push, `--cache-from` to pull
* Essential for **fast CI/CD on ephemeral runners**

----
## Q162: What is Docker registry caching and how does it work?

🧠 **Overview**

* **Docker registry caching** stores pulled container images locally so repeated pulls don’t hit the remote registry.
* Used to **speed up builds**, **reduce bandwidth**, and **avoid rate limits** (Docker Hub, ECR, etc.).
* Common in CI/CD and large Kubernetes clusters.

---

⚙️ **How it works**

1. Client (Docker/K8s node) requests an image.
2. Cache registry checks **local storage**:

   * **Hit** → serves image immediately.
   * **Miss** → pulls from upstream registry, **stores it**, then serves it.
3. Next pulls use the cached copy.

---

🧩 **Example: Docker Registry as pull-through cache**

```bash
docker run -d -p 5000:5000 \
  -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io \
  --name registry-cache registry:2
```

```bash
docker pull localhost:5000/library/nginx:latest
```

**Explanation**

* Acts as a **proxy cache** for Docker Hub.
* First pull fetches from Docker Hub; next pulls are **served locally**.
* Helps avoid Docker Hub rate limits.

---

🧩 **Real-world CI/CD scenario**

* Jenkins/GitLab runners pull base images (e.g., `node`, `python`) many times.
* With caching:

  * Faster pipelines
  * Stable builds during Docker Hub outages
  * Lower egress cost

---

📋 **Common caching solutions**

| Tool                         | Use case                               |
| ---------------------------- | -------------------------------------- |
| Docker Registry (proxy mode) | Simple on-prem cache                   |
| Harbor                       | Enterprise registry + cache + security |
| Nexus Repository             | Docker + Maven + npm caching           |
| AWS ECR pull-through cache   | Cache Docker Hub/Quay in AWS           |

---

⚠️ **Important notes**

* Cached images **don’t auto-refresh** until re-pulled after TTL/cleanup.
* Tag `latest` can cause **stale images** → prefer versioned tags.
* Secure cache registry with auth + TLS.

---

💡 **In short (quick recall)**

* Docker registry caching = **local image cache for faster, reliable pulls**.
* Works via **cache hit/miss** against upstream registries.
* Critical for **CI/CD, Kubernetes at scale, and rate-limit protection**.
---
## Q163: How would you implement a pull-through cache for Docker Hub?

🧠 **Overview**

* A **pull-through cache** proxies Docker Hub and stores images locally.
* Reduces **pull latency**, **rate limits**, and **external dependency** in CI/CD & Kubernetes.

---

## Option 1: Docker Registry (official, simplest)

⚙️ **Steps**

### 1️⃣ Run registry in proxy (cache) mode

```bash
docker run -d --restart=always \
  -p 5000:5000 \
  -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io \
  --name dockerhub-cache registry:2
```

**What it does**

* Acts as a **pull-through cache** for Docker Hub.
* First pull → Docker Hub
* Next pulls → local cache

---

### 2️⃣ Pull images via cache

```bash
docker pull localhost:5000/library/nginx:1.25
```

**Why**

* Docker always checks the local registry first.
* Avoids Docker Hub rate limits.

---

### 3️⃣ (Optional) Configure Docker daemon globally

`/etc/docker/daemon.json`

```json
{
  "registry-mirrors": ["http://<cache-ip>:5000"]
}
```

```bash
systemctl restart docker
```

**Result**

* All `docker pull` requests automatically use the cache.
* Best for CI agents & K8s nodes.

---

## Option 2: AWS ECR Pull-Through Cache (managed, production-grade)

⚙️ **Steps**

```bash
aws ecr create-pull-through-cache-rule \
  --ecr-repository-prefix dockerhub \
  --upstream-registry-url https://registry-1.docker.io
```

```bash
docker pull <aws_account>.dkr.ecr.<region>.amazonaws.com/dockerhub/library/nginx:1.25
```

**Why**

* Fully managed, IAM-secured.
* Ideal for **EKS + AWS CI/CD**.
* No infra maintenance.

---

## Option 3: Nexus / Harbor (enterprise)

| Tool   | When to use                             |
| ------ | --------------------------------------- |
| Nexus  | Multi-format repos (Docker, Maven, npm) |
| Harbor | Security, vulnerability scanning, RBAC  |

---

⚠️ **Best practices**

* Use **versioned tags**, avoid `latest`.
* Enable **TLS + auth**.
* Monitor disk usage & garbage collection.
* Document cache prefix usage for developers.

---

💡 **In short (quick recall)**

* Run Docker Registry in **proxy mode** or use **ECR pull-through cache**.
* Configure Docker daemon with `registry-mirrors`.
* Results: **faster pulls, fewer failures, no rate limits**.
---
## Q164: What strategies would you use for Docker image promotion across environments?

🧠 **Overview**

* Docker image promotion = **moving the same tested image** from Dev → QA → Stage → Prod.
* Goal: **immutability, traceability, zero rebuilds**, and safe rollbacks.

---

## 1️⃣ Tag-based promotion (most common)

```bash
docker tag app:1.3.2 app:qa
docker tag app:1.3.2 app:prod
docker push app:prod
```

**Why**

* Same image digest, different environment tags.
* Simple and CI-friendly.

**Risk**

* Tags can be **mutable** → control with RBAC.

---

## 2️⃣ Digest-based promotion (best practice)

```bash
image: myrepo/app@sha256:abc123...
```

**Why**

* Guarantees **exact image** runs in all environments.
* Prevents “works in QA, fails in Prod”.

**Real-world**

* Kubernetes production deployments should always use **digest**.

---

## 3️⃣ Registry-to-registry promotion (copy, don’t rebuild)

```bash
skopeo copy \
  docker://dev-reg/app:1.3.2 \
  docker://prod-reg/app:1.3.2
```

**Why**

* No rebuild → no drift.
* Common with **ECR, Harbor, Nexus**.

---

## 4️⃣ Environment-specific repositories

| Env  | Example repo   |
| ---- | -------------- |
| Dev  | `ecr/dev/app`  |
| QA   | `ecr/qa/app`   |
| Prod | `ecr/prod/app` |

**Why**

* Strong isolation.
* Clear access control (Prod = read-only).

---

## 5️⃣ CI/CD pipeline–driven promotion

**Pipeline flow**

1. Build once → push to Dev
2. Run tests & scans
3. Manual approval
4. Promote image to Prod repo/tag

**Example (GitLab)**

```yaml
promote_prod:
  script:
    - skopeo copy docker://dev/app:$CI_COMMIT_SHA docker://prod/app:$CI_COMMIT_SHA
```

---

## 6️⃣ Security & policy gates

* Image scanning (Trivy, ECR scan)
* Signature verification (Cosign)
* Block promotion if **CVEs / policy violations**

---

⚠️ **Anti-patterns**

* Rebuilding images per environment ❌
* Using `latest` in production ❌
* Environment-specific logic inside Dockerfile ❌

---

💡 **In short (quick recall)**

* **Build once, promote everywhere**.
* Prefer **digest-based references**.
* Use **registry copy + CI approvals** for production safety.
---
## Q165: How do you implement immutable tags vs mutable tags strategy?

🧠 **Overview**

* **Immutable tags** → once pushed, **never change** (safe, auditable).
* **Mutable tags** → can be re-pointed to new images (convenient, risky).
* Best practice: **use both together**, with clear rules.

---

## 📋 Immutable vs Mutable tags (comparison)

| Aspect          | Immutable tags        | Mutable tags          |
| --------------- | --------------------- | --------------------- |
| Example         | `1.4.3`, `sha-abc123` | `dev`, `qa`, `latest` |
| Can change?     | ❌ No                  | ✅ Yes                 |
| Reproducibility | High                  | Low                   |
| Rollback safety | Excellent             | Risky                 |
| Prod usage      | ✅ Recommended         | ❌ Avoid               |
| CI convenience  | Medium                | High                  |

---

## 1️⃣ Implement **immutable tags** (build once)

### CI build step

```bash
IMAGE_TAG=$CI_COMMIT_SHA

docker build -t app:$IMAGE_TAG .
docker push app:$IMAGE_TAG
```

**Why**

* Tag uniquely maps to one image digest.
* Perfect for audit, rollback, and prod.

---

## 2️⃣ Implement **mutable tags** (environment pointers)

```bash
docker tag app:$IMAGE_TAG app:dev
docker push app:dev
```

**What it does**

* `dev` always points to the **latest approved build**.
* Easy for teams and automation.

---

## 3️⃣ Protect immutable tags in the registry

**Examples**

* **ECR**: enable *tag immutability*
* **Harbor/Nexus**: repo-level immutability rules

```bash
aws ecr put-image-tag-mutability \
  --repository-name app \
  --image-tag-mutability IMMUTABLE
```

---

## 4️⃣ Deployment strategy (best practice)

### Kubernetes (Prod)

```yaml
image: myrepo/app@sha256:abc123
```

### Kubernetes (Dev)

```yaml
image: myrepo/app:dev
```

**Why**

* Prod = guaranteed image
* Dev = fast iteration

---

## 5️⃣ Promotion flow (real-world)

1. Build → push `app:<commit-sha>` (immutable)
2. Scan & test
3. Move `qa` / `prod` tag to that SHA (mutable)
4. Deploy prod using **digest**

---

⚠️ **Common mistakes**

* Using mutable tags in prod
* Overwriting version tags
* No registry-level immutability

---

💡 **In short (quick recall)**

* **Immutable tags** = source of truth.
* **Mutable tags** = convenience pointers.
* Prod should always deploy **immutable (digest-based)** images.
---
## Q166: What is the `latest` tag anti-pattern and why should you avoid it?

🧠 **Overview**

* The **`latest` tag is mutable** and does **not guarantee the newest or same image**.
* Using it causes **non-reproducible builds**, unexpected prod changes, and hard rollbacks.
* Considered an **anti-pattern**, especially in CI/CD and production.

---

## 📋 Why `latest` is dangerous

| Problem                   | Why it happens              | Real-world impact           |
| ------------------------- | --------------------------- | --------------------------- |
| Non-deterministic deploys | Tag can be re-pointed       | Same YAML → different image |
| Broken rollbacks          | Old image lost              | Can’t recover fast          |
| CI inconsistency          | Cache pulls different image | “Works on my machine”       |
| Silent prod changes       | Node pulls new `latest`     | Outage without code change  |

---

## 🧩 Example: Kubernetes failure scenario

```yaml
image: myapp:latest
```

**What happens**

* Pod restart pulls **new image** with breaking change.
* No Git change, no approval → production incident.

---

## 🧩 CI/CD example (hidden risk)

```bash
docker build -t myapp:latest .
docker push myapp:latest
```

**Why bad**

* Every push overwrites history.
* Impossible to trace which commit is running.

---

## ✅ Correct alternatives

### 1️⃣ Versioned / immutable tags

```bash
myapp:1.3.7
myapp:git-9f3a21c
```

### 2️⃣ Digest-based deployment (best)

```yaml
image: myapp@sha256:abc123...
```

### 3️⃣ Mutable tags only as pointers

```bash
myapp:dev
myapp:qa
```

Used **outside prod** only.

---

## 🔒 Registry best practices

* Enable **tag immutability** (ECR, Harbor).
* Restrict overwrite permissions.
* Enforce policy checks in CI.

---

💡 **In short (quick recall)**

* `latest` is **mutable and unpredictable**.
* Breaks reproducibility and rollback.
* Use **versioned or digest-based images** instead.
---
## Q167: How would you implement semantic versioning for Docker images?

🧠 **Overview**

* **Semantic Versioning (SemVer)** = `MAJOR.MINOR.PATCH` (e.g., `2.4.1`)
* Applied to Docker images to ensure **predictable upgrades, safe rollbacks, and clear compatibility**.
* Best practice: **SemVer for releases + immutable build identifiers**.

---

## 1️⃣ Define versioning rules (policy)

| Change type                 | Version bump | Example         |
| --------------------------- | ------------ | --------------- |
| Breaking API change         | MAJOR        | `1.9.2 → 2.0.0` |
| Backward-compatible feature | MINOR        | `1.8.1 → 1.9.0` |
| Bug fix / patch             | PATCH        | `1.8.1 → 1.8.2` |

---

## 2️⃣ Store version in source control

**Example**

```text
VERSION=1.4.2
```

**Why**

* Single source of truth.
* Version changes are code-reviewed.

---

## 3️⃣ CI pipeline: build once, tag multiple ways

```bash
VERSION=$(cat VERSION)
GIT_SHA=$(git rev-parse --short HEAD)

docker build -t myapp:${VERSION} .
docker tag myapp:${VERSION} myapp:${VERSION}-${GIT_SHA}
docker push myapp:${VERSION}
docker push myapp:${VERSION}-${GIT_SHA}
```

**What it does**

* `1.4.2` → human-friendly release tag.
* `1.4.2-a1b2c3` → immutable traceability.

---

## 4️⃣ Optional mutable pointers (controlled)

```bash
docker tag myapp:${VERSION} myapp:1.4
docker tag myapp:${VERSION} myapp:1
docker push myapp:1.4
docker push myapp:1
```

**Why**

* Allows safe auto-upgrades within a boundary.
* Never use these in prod.

---

## 5️⃣ Deployment strategy (recommended)

### Kubernetes – Prod

```yaml
image: myrepo/myapp:1.4.2
# or (best)
image: myrepo/myapp@sha256:abc123...
```

### Kubernetes – Dev

```yaml
image: myrepo/myapp:1.4
```

---

## 6️⃣ Registry & governance

* Enable **tag immutability** for `MAJOR.MINOR.PATCH`.
* Block overwrite of release tags.
* Sign images (Cosign) and scan before publish.

---

⚠️ **Common mistakes**

* Using `latest` instead of versions
* Rebuilding the same version tag
* No link between image and Git commit

---

💡 **In short (quick recall)**

* Use `MAJOR.MINOR.PATCH` for Docker tags.
* Build once, tag with **version + commit SHA**.
* Deploy prod with **exact version or digest** only.
---
## Q168: What strategies would you use for Docker logging at scale?

🧠 **Overview**

* At scale, Docker logging must be **centralized, structured, reliable, and low-overhead**.
* Goal: **collect once, store centrally, search fast, alert smartly** across hundreds/thousands of containers.

---

## 1️⃣ Use stdout/stderr only (golden rule)

```bash
docker run myapp
# app logs to stdout/stderr
```

**Why**

* Docker captures stdout/stderr natively.
* Enables pluggable log drivers and sidecar agents.
* Avoids in-container log files.

---

## 2️⃣ Choose the right Docker log driver

| Driver      | When to use  | Notes                    |
| ----------- | ------------ | ------------------------ |
| `json-file` | Small setups | Default, disk grows fast |
| `fluentd`   | Large scale  | Streams logs directly    |
| `awslogs`   | ECS / EC2    | Native CloudWatch        |
| `gelf`      | Graylog      | Structured logs          |
| `splunk`    | Enterprises  | Paid, reliable           |

**Example**

```bash
docker run \
  --log-driver=awslogs \
  --log-opt awslogs-group=/app/prod \
  myapp
```

---

## 3️⃣ Centralized logging pipeline (recommended)

**Architecture**

```
Container → Fluent Bit → Elasticsearch / CloudWatch / Loki
```

**Why**

* Decouples app from storage.
* Scales independently.
* Handles backpressure.

---

## 4️⃣ Structured logging (JSON)

```json
{
  "level": "ERROR",
  "service": "payment",
  "request_id": "abc123",
  "msg": "DB timeout"
}
```

**Benefits**

* Easy filtering, alerting, correlation.
* Required for microservices.

---

## 5️⃣ Log enrichment & metadata

Add:

* container_id
* image tag / digest
* env (`prod`, `staging`)
* pod / node (K8s)

**Why**

* Faster root cause analysis.
* Clear ownership.

---

## 6️⃣ Control log volume (cost + stability)

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "5"
  }
}
```

**Why**

* Prevents disk exhaustion.
* Avoids node crashes.

---

## 7️⃣ Alerting on logs (not everything)

* Alert only on:

  * ERROR / FATAL
  * Known patterns
* Use metrics for high-frequency signals.

---

⚠️ **Anti-patterns**

* Writing logs to files inside containers ❌
* SSHing into nodes to read logs ❌
* Logging secrets / PII ❌

---

💡 **In short (quick recall)**

* Log to **stdout/stderr only**.
* Use **centralized collectors** (Fluent Bit).
* Enforce **structured JSON logs**.
* Control volume, alert selectively.
---
## Q169: What are Docker logging drivers?

🧠 **Overview**

* **Docker logging drivers** define **how and where container logs are stored or sent**.
* They control the log destination (files, cloud services, log systems).
* Critical for **scalability, performance, and observability**.

---

## ⚙️ How logging drivers work

1. Container writes logs to **stdout/stderr**.
2. Docker engine captures logs.
3. Logging driver forwards logs to the configured backend.

---

## 📋 Common Docker logging drivers

| Driver      | Sends logs to          | When to use           | Key notes          |
| ----------- | ---------------------- | --------------------- | ------------------ |
| `json-file` | Local disk             | Default, small setups | Needs rotation     |
| `local`     | Local disk (optimized) | Better than json-file | Lower disk I/O     |
| `awslogs`   | CloudWatch Logs        | ECS / AWS EC2         | IAM required       |
| `fluentd`   | Fluentd/Fluent Bit     | Large-scale logging   | Best for pipelines |
| `gelf`      | Graylog                | Structured logging    | UDP/TCP            |
| `splunk`    | Splunk                 | Enterprise logging    | Paid               |
| `syslog`    | Syslog server          | Legacy systems        | Simple             |
| `none`      | Nowhere                | Disable logging       | Debug only         |

---

## 🧩 Example: run container with log driver

```bash
docker run \
  --log-driver=fluentd \
  --log-opt fluentd-address=localhost:24224 \
  myapp
```

**Explanation**

* Sends container logs to Fluentd.
* Fluentd forwards to Elasticsearch / Loki / CloudWatch.

---

## 🔧 Configure default driver (daemon-level)

`/etc/docker/daemon.json`

```json
{
  "log-driver": "local",
  "log-opts": {
    "max-size": "10m",
    "max-file": "5"
  }
}
```

```bash
systemctl restart docker
```

**Why**

* Enforces consistent logging across all containers.
* Prevents disk exhaustion.

---

⚠️ **Important notes**

* `json-file` grows fast if not rotated.
* Network drivers (`fluentd`, `awslogs`) can block if backend is down → use buffering.
* Logging drivers only capture **stdout/stderr**.

---

💡 **In short (quick recall)**

* Logging drivers decide **where container logs go**.
* Choose based on **scale and backend**.
* Always configure **rotation and reliability**.
----

## Q170: How do you configure `json-file`, `syslog`, `journald`, and other Docker log drivers?

🧠 **Overview**

* Docker log drivers are configured **per container** or **globally at daemon level**.
* Configuration controls **where logs go**, **rotation**, and **performance behavior**.
* At scale, daemon-level defaults + per-container overrides are common.

---

## 1️⃣ `json-file` (default driver)

### Per-container

```bash
docker run \
  --log-driver=json-file \
  --log-opt max-size=10m \
  --log-opt max-file=5 \
  myapp
```

**What it does**

* Stores logs locally as JSON.
* Rotates logs to prevent disk fill.

---

### Daemon-level (recommended)

`/etc/docker/daemon.json`

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "5"
  }
}
```

```bash
systemctl restart docker
```

**Why**

* Enforces rotation for **all containers**.
* Prevents node outages due to disk exhaustion.

---

## 2️⃣ `syslog` driver

### Per-container

```bash
docker run \
  --log-driver=syslog \
  --log-opt syslog-address=tcp://syslog.example.com:514 \
  --log-opt tag="{{.Name}}" \
  myapp
```

**Explanation**

* Sends logs to a **remote syslog server**.
* Useful for legacy or centralized syslog setups.

---

## 3️⃣ `journald` driver (systemd-based systems)

### Per-container

```bash
docker run \
  --log-driver=journald \
  myapp
```

### View logs

```bash
journalctl -u docker
journalctl CONTAINER_NAME=myapp
```

**Why**

* Integrates with **systemd logging**.
* Common on RHEL / Ubuntu servers.

---

## 4️⃣ `awslogs` (CloudWatch)

```bash
docker run \
  --log-driver=awslogs \
  --log-opt awslogs-group=/app/prod \
  --log-opt awslogs-region=us-east-1 \
  --log-opt awslogs-stream-prefix=web \
  myapp
```

**What it does**

* Pushes logs directly to **CloudWatch Logs**.
* Needs IAM permissions on the host/role.

---

## 5️⃣ `fluentd` (large-scale pipelines)

```bash
docker run \
  --log-driver=fluentd \
  --log-opt fluentd-address=localhost:24224 \
  --log-opt tag="docker.{{.Name}}" \
  myapp
```

**Why**

* Best for **high-throughput, centralized logging**.
* Fluentd/Fluent Bit forwards to ES, Loki, S3, etc.

---

## 6️⃣ `gelf` (Graylog)

```bash
docker run \
  --log-driver=gelf \
  --log-opt gelf-address=udp://graylog.example.com:12201 \
  myapp
```

**Use case**

* Structured logging with Graylog.

---

## 7️⃣ `none` (disable logging)

```bash
docker run --log-driver=none myapp
```

**Why**

* Debug or batch jobs where logs aren’t needed.
* Avoid in production.

---

## ⚠️ Key best practices

* Always configure **log rotation** (`json-file`, `local`).
* Prefer **network drivers** (`fluentd`, `awslogs`) at scale.
* Never log secrets or PII.
* Monitor logging backend health to avoid blocking.

---

💡 **In short (quick recall)**

* Configure log drivers via `docker run` or `daemon.json`.
* `json-file` → rotate logs.
* `syslog/journald` → system-level logging.
* `fluentd/awslogs` → production-scale centralized logging.
----

## Q171: What is the difference between local and centralized logging?

🧠 **Overview**

* **Local logging** stores logs on the same host where the container/app runs.
* **Centralized logging** ships logs to a **central system** for search, alerting, and long-term storage.
* At scale, **centralized logging is mandatory**.

---

## 📋 Local vs Centralized logging (comparison)

| Aspect           | Local logging           | Centralized logging   |
| ---------------- | ----------------------- | --------------------- |
| Log location     | On the same host        | Central log system    |
| Examples         | `json-file`, `journald` | ELK, Loki, CloudWatch |
| Scalability      | Poor                    | Excellent             |
| Troubleshooting  | SSH into nodes          | Search in one place   |
| Retention        | Limited by disk         | Long-term storage     |
| Alerts           | Manual / limited        | Automated alerts      |
| Prod suitability | ❌ Not recommended       | ✅ Required            |

---

## 🧩 Local logging example

```bash
docker run --log-driver=json-file myapp
```

**What happens**

* Logs stored under `/var/lib/docker/containers/`.
* Node disk fills if not rotated.
* Logs lost if node crashes.

---

## 🧩 Centralized logging example

```bash
docker run \
  --log-driver=fluentd \
  myapp
```

**Flow**

```
Container → Fluent Bit → Elasticsearch / Loki
```

**Why better**

* Logs survive node failure.
* Easy correlation across services.

---

## 🌍 Real-world production scenario

* Kubernetes cluster with 500+ pods.
* Local logs → impossible to debug incidents.
* Centralized logging → filter by `trace_id`, service, namespace.

---

⚠️ **Key risks of local logging**

* Disk exhaustion
* No historical data
* Manual debugging

---

💡 **In short (quick recall)**

* Local logging = **host-level, short-lived**.
* Centralized logging = **scalable, searchable, production-grade**.
* Use local only for **dev/debug**, centralized for **prod**.
----
## Q172: How would you implement log rotation for Docker containers?

🧠 **Overview**

* Log rotation prevents **container logs from filling disk** and crashing nodes.
* Rotation is mainly needed for **local log drivers** (`json-file`, `local`).
* At scale, combine **rotation + centralized logging**.

---

## 1️⃣ Log rotation using `json-file` (most common)

### Per-container

```bash
docker run \
  --log-driver=json-file \
  --log-opt max-size=10m \
  --log-opt max-file=5 \
  myapp
```

**What it does**

* Rotates logs after 10MB.
* Keeps last 5 files → old logs deleted.

---

## 2️⃣ Global rotation (best practice)

`/etc/docker/daemon.json`

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "5"
  }
}
```

```bash
systemctl restart docker
```

**Why**

* Applies rotation to **all containers**.
* Prevents human error.

---

## 3️⃣ Use `local` log driver (optimized)

```json
{
  "log-driver": "local",
  "log-opts": {
    "max-size": "20m",
    "max-file": "3"
  }
}
```

**Why**

* More efficient than `json-file`.
* Lower disk I/O, automatic rotation.

---

## 4️⃣ Centralized logging (rotation offloaded)

```bash
docker run --log-driver=fluentd myapp
```

**What happens**

* Logs streamed out immediately.
* Rotation handled by **log backend** (ES/Loki/CloudWatch).

---

## 5️⃣ Kubernetes note (important)

* Docker log rotation applies to **node-level runtime**.
* In K8s, also configure:

  * `containerLogMaxSize`
  * `containerLogMaxFiles`

---

⚠️ **Anti-patterns**

* Relying on `logrotate` inside containers ❌
* No rotation on prod nodes ❌
* Storing logs in application files ❌

---

💡 **In short (quick recall)**

* Enable rotation using `max-size` + `max-file`.
* Set it **globally in `daemon.json`**.
* Prefer **centralized logging** for large systems.
----
## Q173: What strategies would you use for container monitoring?

🧠 **Overview**

* Container monitoring ensures **availability, performance, and capacity** of apps running in Docker/Kubernetes.
* At scale, monitoring must be **layered: infrastructure → container → application**.
* Goal: **detect issues early, reduce MTTR, and prevent outages**.

---

## 1️⃣ Monitor at multiple layers (must-have)

| Layer     | What to monitor            | Tools                     |
| --------- | -------------------------- | ------------------------- |
| Host      | CPU, memory, disk, network | Node Exporter, CloudWatch |
| Container | CPU/mem limits, restarts   | cAdvisor, kubelet         |
| App       | Latency, errors, QPS       | Prometheus, APM           |
| Platform  | Pod health, scaling        | Kubernetes metrics        |

---

## 2️⃣ Use metrics, not logs, for alerting

```yaml
# Example Prometheus metric
container_cpu_usage_seconds_total
```

**Why**

* Metrics are lightweight and real-time.
* Logs are for **debugging**, not frequent alerts.

---

## 3️⃣ Prometheus-based monitoring (standard)

**Architecture**

```
Containers → cAdvisor → Prometheus → Alertmanager → Slack/PagerDuty
```

**Why**

* De facto standard for containers & Kubernetes.
* Pull-based, scalable, flexible queries.

---

## 4️⃣ Resource usage & limits (critical)

```yaml
resources:
  requests:
    cpu: "250m"
    memory: "256Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"
```

**What it prevents**

* Noisy neighbor problems.
* OOMKills and CPU starvation.

---

## 5️⃣ Health checks & restarts

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
```

**Why**

* Auto-recovery instead of manual intervention.
* Reduces downtime.

---

## 6️⃣ Alert on symptoms, not noise

**Good alerts**

* High error rate
* CrashLoopBackOff
* Sustained CPU/memory saturation

**Avoid**

* Alerting on every spike ❌

---

## 7️⃣ Visualization with dashboards

* Grafana dashboards:

  * Container CPU/mem
  * Pod restarts
  * Latency percentiles (P95/P99)

**Why**

* Faster incident analysis.
* Capacity planning.

---

## 🌍 Real-world production setup

* **EKS** → Prometheus + Grafana + Alertmanager
* **CloudWatch Container Insights** for infra metrics
* **APM** (Datadog/New Relic) for deep tracing

---

⚠️ **Common mistakes**

* Monitoring only host metrics
* No alerts on OOMKills
* No SLO/SLA-based alerts

---

💡 **In short (quick recall)**

* Monitor **host + container + app layers**.
* Use **metrics for alerts**, logs for debugging.
* Prometheus + Grafana is the industry standard.
* Set resource limits and health checks.
---
## Q174: How do you expose container metrics for Prometheus?

🧠 **Overview**

* Prometheus **scrapes metrics over HTTP** from targets.
* Container metrics come from **host, runtime, Kubernetes, and the application itself**.
* Best practice: **multiple exporters, each for a specific layer**.

---

## 1️⃣ Expose application-level metrics (most important)

### App exposes `/metrics`

```python
# Python example
from prometheus_client import start_http_server, Counter

requests = Counter('http_requests_total', 'Total HTTP requests')

start_http_server(8000)
```

**What it does**

* Exposes business/app metrics.
* Used for SLIs, alerts, and dashboards.

---

## 2️⃣ Container & runtime metrics (cAdvisor)

* cAdvisor runs on each node (often via kubelet).
* Exposes:

  * CPU, memory, network, filesystem per container.

**Prometheus scrape**

```yaml
- job_name: cadvisor
  static_configs:
    - targets: ['node1:4194']
```

---

## 3️⃣ Host-level metrics (Node Exporter)

```bash
docker run -d -p 9100:9100 prom/node-exporter
```

**Metrics**

* CPU, disk, memory, network.
* Helps distinguish host vs container issues.

---

## 4️⃣ Kubernetes-native metrics (recommended)

### kubelet / metrics-server

* Exposes pod & container stats.
* Used by:

  * Prometheus
  * HPA

```yaml
- job_name: kubelet
  kubernetes_sd_configs:
    - role: node
```

---

## 5️⃣ Auto-discovery using Kubernetes labels

```yaml
- job_name: kubernetes-pods
  kubernetes_sd_configs:
    - role: pod
  relabel_configs:
    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
      action: keep
      regex: true
```

**Why**

* No hardcoded IPs.
* Scales automatically.

---

## 6️⃣ ServiceMonitor (Prometheus Operator – best practice)

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
spec:
  endpoints:
    - port: metrics
      path: /metrics
```

**Why**

* Clean, declarative, Kubernetes-native.
* Standard in production clusters.

---

## ⚠️ Common mistakes

* Exposing metrics without auth in public networks
* Mixing logs and metrics
* Scraping too frequently (high cardinality)

---

💡 **In short (quick recall)**

* Apps expose `/metrics`.
* cAdvisor + kubelet → container metrics.
* Node Exporter → host metrics.
* Use **ServiceMonitor + labels** in Kubernetes.
---
## Q175: What is cAdvisor and how does it integrate with Docker?

🧠 **Overview**

* **cAdvisor (Container Advisor)** is a **container resource monitoring agent**.
* It collects **CPU, memory, disk, and network metrics** for running containers.
* Widely used by **Docker, Kubernetes, and Prometheus** for container-level visibility.

---

## ⚙️ What cAdvisor monitors

* CPU usage per container
* Memory usage & OOM events
* Network I/O
* Filesystem usage
* Container lifecycle stats (start/stop/restart)

---

## 🔗 How cAdvisor integrates with Docker

### 1️⃣ Runs alongside Docker

* cAdvisor reads data from:

  * **Docker API**
  * **Linux cgroups**
  * **/sys and /proc**

```text
Docker Engine → cgroups → cAdvisor → Prometheus
```

---

### 2️⃣ Docker-native deployment (standalone)

```bash
docker run -d \
  --name=cadvisor \
  -p 8080:8080 \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  gcr.io/cadvisor/cadvisor
```

**What it does**

* Mounts host paths to read container stats.
* Exposes metrics at `http://localhost:8080/metrics`.

---

## 3️⃣ Prometheus integration

```yaml
- job_name: cadvisor
  static_configs:
    - targets: ['node1:8080']
```

**Why**

* Prometheus scrapes container-level metrics.
* Used for dashboards and alerts.

---

## 4️⃣ Kubernetes integration (important)

* cAdvisor is **embedded in kubelet**.
* No separate deployment needed.
* Metrics exposed via:

  * `/metrics/cadvisor` on kubelet.

**Prometheus scrape**

```yaml
- job_name: kubelet-cadvisor
  metrics_path: /metrics/cadvisor
```

---

## 🌍 Real-world usage

* Detect **memory leaks** inside containers.
* Identify **CPU throttling** due to limits.
* Capacity planning for Kubernetes nodes.

---

⚠️ **Limitations**

* No application/business metrics.
* High metric cardinality if misconfigured.
* UI is basic (metrics > dashboards).

---

💡 **In short (quick recall)**

* cAdvisor = **container resource metrics collector**.
* Integrates via **Docker API + cgroups**.
* Prometheus scrapes cAdvisor for container metrics.
* In Kubernetes, it’s **built into kubelet**.
---
## Q176: How would you implement distributed tracing for containerized applications?

🧠 **Overview**

* **Distributed tracing** tracks a request **end-to-end across multiple containers/services**.
* Helps debug **latency, failures, and service dependencies** in microservices.
* Standard approach today: **OpenTelemetry + centralized tracer (Jaeger/Tempo/X-Ray)**.

---

## 1️⃣ Use OpenTelemetry (industry standard)

**Why**

* Vendor-neutral
* Works with Docker, Kubernetes, cloud providers

**Components**

```
App → OpenTelemetry SDK → Collector → Tracing backend
```

---

## 2️⃣ Instrument applications

### Example: Python service

```python
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter

trace.set_tracer_provider(TracerProvider())
tracer = trace.get_tracer(__name__)
```

**What it does**

* Creates spans for each request.
* Captures latency, errors, dependencies.

---

## 3️⃣ Propagate trace context between services

* Use headers:

  * `traceparent`
  * `tracestate`

**Why**

* Allows downstream services to **continue the same trace**.
* Automatic in most frameworks (Spring, Flask, Node).

---

## 4️⃣ Deploy OpenTelemetry Collector (container)

```bash
docker run -d \
  -p 4318:4318 \
  otel/opentelemetry-collector
```

**Role**

* Receives traces from apps.
* Batches, samples, and forwards to backend.

---

## 5️⃣ Choose a tracing backend

| Backend             | When to use              |
| ------------------- | ------------------------ |
| Jaeger              | OSS, Kubernetes-friendly |
| Grafana Tempo       | Metrics + logs + traces  |
| AWS X-Ray           | AWS-native (EKS/ECS)     |
| Datadog / New Relic | Managed APM              |

---

## 6️⃣ Kubernetes / service mesh option (zero-code)

* **Istio / Linkerd**
* Sidecar proxies auto-generate traces.

**Why**

* No app code change.
* Fast adoption for legacy apps.

---

## 7️⃣ Sampling strategy (critical)

* Head-based (SDK)
* Tail-based (Collector)

**Why**

* Reduce overhead.
* Keep slow/error traces only.

---

## 🌍 Real-world production setup

* Microservices on EKS
* OpenTelemetry SDK in apps
* OTel Collector as DaemonSet
* Tempo + Grafana dashboards
* Correlate logs ↔ metrics ↔ traces

---

⚠️ **Common mistakes**

* No trace context propagation
* 100% sampling in production
* Not correlating logs with trace IDs

---

💡 **In short (quick recall)**

* Use **OpenTelemetry** for tracing.
* Instrument apps + propagate context.
* Collect via **OTel Collector**.
* Visualize in **Jaeger/Tempo/X-Ray**.
* Enable sampling to control cost.
----
## Q177: What is Docker Swarm mode?

🧠 **Overview**

* **Docker Swarm mode** is Docker’s **native container orchestration** feature.
* It lets you run containers as **services across multiple Docker hosts**.
* Provides **clustering, scaling, load balancing, and self-healing** without extra tools.

---

## ⚙️ Key components

| Component    | Role                               |
| ------------ | ---------------------------------- |
| Manager node | Controls cluster state, scheduling |
| Worker node  | Runs containers                    |
| Service      | Desired state of containers        |
| Task         | One running container instance     |

---

## 1️⃣ Enable Swarm mode

```bash
docker swarm init
```

**What it does**

* Turns a Docker host into a **Swarm manager**.
* Creates a cluster control plane.

---

## 2️⃣ Join nodes to the swarm

```bash
docker swarm join --token <token> <manager-ip>:2377
```

**Why**

* Adds worker or manager nodes to the cluster.

---

## 3️⃣ Deploy a service

```bash
docker service create \
  --name web \
  --replicas 3 \
  -p 80:80 \
  nginx
```

**What happens**

* Runs 3 replicas across nodes.
* Swarm load-balances traffic automatically.

---

## 4️⃣ Built-in features

* **Service discovery** (DNS-based)
* **Overlay networking**
* **Rolling updates**
* **Self-healing** (auto-restart failed tasks)
* **Secrets & configs**

---

## 5️⃣ Scaling & updates

```bash
docker service scale web=5
docker service update --image nginx:1.25 web
```

**Why**

* Declarative scaling and zero-downtime updates.

---

## 🌍 Real-world usage

* Small to medium clusters.
* Teams needing orchestration **without Kubernetes complexity**.
* Legacy Docker environments.

---

⚠️ **Limitations**

* Smaller ecosystem than Kubernetes.
* Limited community adoption today.
* Not ideal for large, complex platforms.

---

💡 **In short (quick recall)**

* Docker Swarm = **Docker’s built-in orchestrator**.
* Simple setup, built-in LB, self-healing.
* Good for small clusters; Kubernetes dominates at scale.
----
## Q178: What are the components of Docker Swarm?

🧠 **Overview**

* Docker Swarm is a **cluster of Docker hosts** working as one system.
* Core components are **Manager nodes** and **Worker nodes**.
* Swarm follows a **desired-state model** (you declare *what you want*, Swarm maintains it).

---

## 🧩 Main components

### 1️⃣ Manager Node

**Role**

* Controls the **Swarm control plane**.
* Maintains cluster state using **Raft consensus**.

**Responsibilities**

* Schedules tasks to workers
* Manages services, scaling, updates
* Maintains cluster membership
* Handles leader election
* Stores secrets and configs

**Key commands**

```bash
docker swarm init
docker node ls
docker service ls
```

**Best practice**

* Use **odd number of managers** (3 or 5) for HA.
* Don’t run heavy workloads on managers in prod.

---

### 2️⃣ Worker Node

**Role**

* Executes the **containers (tasks)** assigned by managers.
* Has **no cluster decision power**.

**Responsibilities**

* Runs service containers
* Reports health/status to managers
* Joins swarm using a token

**Key command**

```bash
docker swarm join --token <worker-token> <manager-ip>:2377
```

---

## 🧱 Supporting Swarm components

| Component            | Purpose                     |
| -------------------- | --------------------------- |
| Service              | Desired state of containers |
| Task                 | Single running container    |
| Overlay Network      | Cross-node networking       |
| Ingress Routing Mesh | Built-in load balancing     |
| Secrets & Configs    | Secure data injection       |

---

## 🌍 Real-world example

```text
3 Managers  → Scheduling + HA
10 Workers  → Run application containers
```

* If a worker fails → manager reschedules tasks.
* If a manager fails → another manager becomes leader.

---

⚠️ **Common mistakes**

* Single manager in production
* Running critical workloads on managers
* Not backing up swarm state

---

💡 **In short (quick recall)**

* **Manager nodes** = brain (control plane).
* **Worker nodes** = muscle (run containers).
* Managers decide, workers execute.
----
## Q179: How does Docker Swarm differ from Kubernetes?

🧠 **Overview**

* **Docker Swarm** and **Kubernetes** are container orchestration platforms.
* Swarm focuses on **simplicity and ease of use**.
* Kubernetes focuses on **scalability, flexibility, and enterprise-grade control**.
* In real production today, **Kubernetes is the standard**.

---

## 📋 Docker Swarm vs Kubernetes (comparison)

| Aspect              | Docker Swarm                      | Kubernetes                 |
| ------------------- | --------------------------------- | -------------------------- |
| Setup               | Very simple (`docker swarm init`) | Complex (kubeadm/EKS/GKE)  |
| Learning curve      | Low                               | Steep                      |
| Scalability         | Limited                           | Very high                  |
| Networking          | Built-in overlay                  | CNI-based (Calico, Cilium) |
| Load balancing      | Routing mesh                      | Services + Ingress         |
| Auto-scaling        | Manual                            | HPA / VPA                  |
| Ecosystem           | Small                             | Massive                    |
| Community           | Declining                         | Very active                |
| Production adoption | Low                               | Industry standard          |

---

## 🧩 Deployment example

### Swarm

```bash
docker service create --replicas 3 nginx
```

### Kubernetes

```bash
kubectl apply -f deployment.yaml
```

**Difference**

* Swarm is **imperative & simple**.
* Kubernetes is **declarative & extensible**.

---

## 🌍 Real-world usage guidance

**Use Swarm when**

* Small cluster
* Minimal ops team
* Simple workloads

**Use Kubernetes when**

* Large-scale systems
* Multi-tenant environments
* Advanced networking, security, autoscaling
* Cloud-native platforms (EKS/AKS/GKE)

---

⚠️ **Why Swarm lost to Kubernetes**

* Limited extensibility
* Smaller ecosystem
* Slower feature evolution

---

💡 **In short (quick recall)**

* Swarm = **simple, fast to start**.
* Kubernetes = **powerful, scalable, production-grade**.
* For serious production → **Kubernetes wins**.
----
## Q180: When would you use Docker Swarm over Kubernetes?

🧠 **Overview**

* Docker Swarm is chosen **only in specific, limited scenarios**.
* Kubernetes is the default for most modern production systems.
* Swarm fits when **simplicity > flexibility**.

---

## ✅ Use Docker Swarm when

### 1️⃣ Small, simple environments

* 2–10 nodes
* Few stateless services
* No complex networking or autoscaling

**Why**

* `docker swarm init` → cluster ready in minutes.

---

### 2️⃣ Minimal ops / skillset

* Team already knows Docker, not Kubernetes
* No time for Kubernetes learning curve

**Why**

* Same Docker CLI, no new concepts.

---

### 3️⃣ Legacy Docker-based platforms

* Existing Docker Compose setups
* Need basic HA without full platform redesign

```bash
docker stack deploy -c docker-compose.yml app
```

---

### 4️⃣ Dev / POC / internal tools

* Short-lived environments
* Low blast radius if issues occur

---

### 5️⃣ No advanced requirements

You **do NOT need**:

* HPA / autoscaling
* Complex RBAC
* Service mesh
* CRDs / operators
* Multi-cluster support

---

## ❌ Avoid Swarm when

* Production at scale
* Multi-tenant workloads
* Strong security/compliance needs
* Cloud-managed orchestration (EKS/AKS/GKE)
* Long-term platform growth

---

## 🌍 Real-world recommendation

* **New projects** → Kubernetes.
* **Existing small Docker clusters** → Swarm can be acceptable.
* **Enterprise / cloud-native** → Kubernetes always.

---

💡 **In short (quick recall)**

* Use Swarm for **small, simple, low-risk** setups.
* Use Kubernetes for **anything serious or long-term**.
----
## Q181: What are Docker services in Swarm?

🧠 **Overview**

* A **Docker service** is the **core abstraction in Docker Swarm**.
* It defines the **desired state** of an application (image, replicas, ports, resources).
* Swarm ensures the service **runs, scales, and heals automatically**.

---

## ⚙️ What a Docker service includes

* Container image
* Number of replicas
* Network & ports
* CPU/memory limits
* Update strategy
* Restart policy

---

## 1️⃣ Create a service

```bash
docker service create \
  --name web \
  --replicas 3 \
  -p 80:80 \
  nginx:1.25
```

**What happens**

* Swarm schedules 3 containers across worker nodes.
* Built-in load balancing distributes traffic.

---

## 2️⃣ Service vs container

| Aspect         | Docker Container | Docker Service      |
| -------------- | ---------------- | ------------------- |
| Scope          | Single container | Group of containers |
| Scaling        | Manual           | Declarative         |
| Self-healing   | ❌                | ✅                   |
| Load balancing | ❌                | ✅                   |

---

## 3️⃣ Scale a service

```bash
docker service scale web=5
```

**Why**

* Adds replicas automatically across nodes.

---

## 4️⃣ Rolling updates

```bash
docker service update \
  --image nginx:1.26 \
  web
```

**What it does**

* Updates containers **one-by-one** (zero downtime).

---

## 5️⃣ Service discovery & networking

* Built-in **DNS-based discovery**
* Overlay networks across nodes
* Ingress routing mesh

---

## 🌍 Real-world example

* Web app service (5 replicas)
* DB service (1 replica, constrained)
* If a node fails → tasks rescheduled automatically

---

⚠️ **Limitations**

* Limited deployment strategies
* Less flexible than Kubernetes Deployments
* Smaller ecosystem

---

💡 **In short (quick recall)**

* Docker service = **desired-state app definition**.
* Provides **scaling, load balancing, self-healing**.
* Core building block of Docker Swarm.
----
## Q182: How do you deploy a stack in Docker Swarm?

🧠 **Overview**

* A **Docker stack** is a group of services deployed together in Docker Swarm.
* Defined using a **Docker Compose (`docker-compose.yml`) file**.
* `docker stack deploy` converts Compose services into **Swarm services**.

---

## 1️⃣ Prerequisites

```bash
docker swarm init
```

**Why**

* Stacks work **only in Swarm mode**.

---

## 2️⃣ Example `docker-compose.yml`

```yaml
version: "3.8"

services:
  web:
    image: nginx:1.25
    ports:
      - "80:80"
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure

  api:
    image: myapp:1.0.0
    deploy:
      replicas: 2
      resources:
        limits:
          cpus: "0.5"
          memory: 512M
```

**Key points**

* `deploy` section is **Swarm-specific**.
* Ignored by `docker-compose up`.

---

## 3️⃣ Deploy the stack

```bash
docker stack deploy -c docker-compose.yml mystack
```

**What happens**

* Creates multiple Swarm services.
* Applies scaling, networks, and policies.

---

## 4️⃣ Verify stack & services

```bash
docker stack ls
docker stack services mystack
docker stack ps mystack
```

---

## 5️⃣ Update the stack

```bash
docker stack deploy -c docker-compose.yml mystack
```

**Why**

* Re-running the command applies **rolling updates**.

---

## 6️⃣ Remove the stack

```bash
docker stack rm mystack
```

---

## 🌍 Real-world usage

* Deploy multi-service apps (web + API + worker).
* Simple alternative to Kubernetes manifests for small clusters.

---

⚠️ **Common mistakes**

* Using Compose v2 features (not supported in Swarm)
* Expecting `docker-compose up` behavior
* Forgetting `deploy` section

---

💡 **In short (quick recall)**

* Stack = **group of Swarm services**.
* Defined using **Compose v3+**.
* Deploy with `docker stack deploy`.
* Requires Swarm mode.
----
## Q183: What is the difference between replicated and global services in Docker Swarm?

🧠 **Overview**

* Docker Swarm supports **two service modes**: **replicated** and **global**.
* They define **how many tasks (containers) run and where**.
* Choice depends on **application purpose**.

---

## 📋 Replicated vs Global services (comparison)

| Aspect          | Replicated Service    | Global Service                    |
| --------------- | --------------------- | --------------------------------- |
| Number of tasks | Fixed number          | One per eligible node             |
| Scaling         | Manual (`--replicas`) | Automatic (node-based)            |
| Typical use     | Web apps, APIs        | Agents, daemons                   |
| Node failure    | Tasks rescheduled     | Recreated on new node             |
| Common examples | Nginx, API servers    | Log collectors, monitoring agents |

---

## 1️⃣ Replicated service example

```bash
docker service create \
  --name web \
  --replicas 3 \
  nginx
```

**What happens**

* Runs exactly **3 containers** across the cluster.
* Load-balanced automatically.

---

## 2️⃣ Global service example

```bash
docker service create \
  --name node-exporter \
  --mode global \
  prom/node-exporter
```

**What happens**

* Runs **one container per node**.
* New node joins → container starts automatically.

---

## 🌍 Real-world scenarios

* **Replicated** → frontend, backend, workers.
* **Global** → monitoring, logging, security agents.

---

⚠️ **Important notes**

* Global services **ignore replica count**.
* You can limit nodes using **constraints**.

```bash
--constraint 'node.role==worker'
```

---

💡 **In short (quick recall)**

* Replicated = **N copies anywhere**.
* Global = **1 copy per node**.
* Use replicated for apps, global for node-level agents.
----
## Q184: How does Docker Swarm handle load balancing?

🧠 **Overview**

* Docker Swarm provides **built-in load balancing** for services.
* It works at **Layer 4 (TCP/UDP)** using the **routing mesh** and **internal DNS**.
* No external LB is required for basic use.

---

## 1️⃣ Routing Mesh (ingress load balancing)

```bash
docker service create \
  --name web \
  --replicas 3 \
  -p 80:80 \
  nginx
```

**How it works**

* Any node can receive traffic on port `80`.
* Swarm routes traffic to **any healthy task** (even on other nodes).
* Uses **IPVS** under the hood.

**Flow**

```
Client → Any Node → Routing Mesh → Service Task
```

---

## 2️⃣ Internal service load balancing (DNS-based)

* Each service gets a **virtual IP (VIP)**.
* Internal containers resolve service name via DNS.

```bash
curl http://web
```

**What happens**

* DNS resolves to service VIP.
* VIP load-balances traffic across replicas.

---

## 3️⃣ Host-mode publishing (no routing mesh)

```bash
docker service create \
  --name web \
  --publish mode=host,target=80,published=8080 \
  nginx
```

**Why**

* Traffic goes only to the **node running the task**.
* Used when you want **external LBs** (ALB/NLB).

---

## 4️⃣ External load balancer integration

**Common pattern**

```
ALB / NLB → Swarm Nodes → Services
```

**Why**

* TLS termination
* Advanced routing
* Better observability

---

## ⚠️ Limitations

* No L7 (HTTP path/header) routing.
* No traffic splitting or canary deployments.
* Less flexible than Kubernetes Ingress.

---

💡 **In short (quick recall)**

* Swarm uses **routing mesh + VIP** for load balancing.
* L4 only, built-in, simple.
* For advanced needs → use an **external load balancer** or Kubernetes.
---
## Q185: What is the routing mesh in Docker Swarm?

🧠 **Overview**

* The **routing mesh** is Docker Swarm’s **built-in L4 load-balancing mechanism**.
* It allows **any node** in the Swarm to accept traffic for a service,
  even if the service’s container is running on a **different node**.
* Enabled **by default** for published service ports.

---

## ⚙️ How the routing mesh works

1. A service publishes a port (e.g., `80`).
2. **Every Swarm node** listens on that port.
3. Incoming traffic is forwarded to a **healthy service task** anywhere in the cluster.
4. Uses **IPVS (Linux kernel)** for fast L4 routing.

```
Client → Any Node → Routing Mesh → Service Task
```

---

## 🧩 Example

```bash
docker service create \
  --name web \
  --replicas 3 \
  -p 80:80 \
  nginx
```

**What happens**

* Port `80` is open on all nodes.
* Requests to any node are load-balanced across the 3 replicas.

---

## 🔄 Internal vs External traffic

### External (ingress)

* Traffic enters via routing mesh.
* Load-balanced automatically.

### Internal (service-to-service)

* Uses **VIP + DNS-based load balancing**.
* Routing mesh is **not involved**.

---

## 🚫 Disable routing mesh (host mode)

```bash
docker service create \
  --publish mode=host,target=80,published=8080 \
  nginx
```

**Why**

* Bypass routing mesh.
* Required for:

  * External LBs (ALB/NLB)
  * Performance-sensitive workloads

---

## ⚠️ Limitations

* Layer 4 only (TCP/UDP).
* No path-based or header-based routing.
* No canary or weighted traffic.

---

## 🌍 Real-world usage

* Simple web services with no advanced routing needs.
* Small Swarm clusters needing quick HA.

---

💡 **In short (quick recall)**

* Routing mesh = **cluster-wide port exposure**.
* Any node can accept traffic.
* Built-in, L4, simple—but limited compared to Kubernetes Ingress.
----
## Q186: How do you implement rolling updates in Docker Swarm?

🧠 **Overview**

* **Rolling updates** in Swarm update service containers **gradually**, not all at once.
* Goal: **zero downtime**, controlled rollout, easy rollback.
* Configured via **service update options** or the **Compose `deploy.update_config`** section.

---

## 1️⃣ Rolling update using CLI

```bash
docker service update \
  --image myapp:1.1.0 \
  --update-parallelism 1 \
  --update-delay 10s \
  web
```

**What it does**

* Updates **1 task at a time**.
* Waits **10 seconds** between updates.
* Old tasks are replaced gradually.

---

## 2️⃣ Rolling update using Compose file (recommended)

```yaml
services:
  web:
    image: myapp:1.0.0
    deploy:
      replicas: 4
      update_config:
        parallelism: 1
        delay: 10s
        order: start-first
      rollback_config:
        parallelism: 1
        delay: 5s
```

**Key options**

* `parallelism` → number of containers updated at once
* `delay` → wait time between batches
* `order: start-first` → new container starts before old stops

---

## 3️⃣ Deploy the update

```bash
docker stack deploy -c docker-compose.yml mystack
```

**Why**

* Applies rolling update automatically.
* Safe for multi-service apps.

---

## 4️⃣ Monitor update progress

```bash
docker service ps web
docker service inspect web
```

---

## 5️⃣ Rollback if needed

```bash
docker service rollback web
```

**When**

* Health checks fail
* Error rate increases

---

## ⚠️ Best practices

* Use **health checks** in images.
* Set `start-first` for zero downtime.
* Monitor metrics during rollout.
* Avoid large `parallelism` in prod.

---

💡 **In short (quick recall)**

* Rolling updates are **built into Swarm services**.
* Control with `parallelism`, `delay`, and `order`.
* Use Compose `update_config`.
* Roll back instantly if issues occur.
----
## Q187: What strategies would you use for zero-downtime deployments?

🧠 **Overview**

* Zero-downtime deployments ensure **users see no outage** during releases.
* Achieved by **running old and new versions in parallel** and switching traffic safely.
* Choice depends on **orchestrator, traffic control, and risk level**.

---

## 1️⃣ Rolling updates (baseline strategy)

```bash
docker service update \
  --update-parallelism 1 \
  --update-delay 10s \
  web
```

**Why**

* Gradually replaces instances.
* Low risk, simple.

**Key**

* Always use **health checks**.

---

## 2️⃣ Blue-Green deployments

```
Blue (v1)  ← traffic
Green (v2) ← deploy & test
Switch traffic → Green
```

**How**

* Deploy new version alongside old.
* Flip load balancer / service label.

**Why**

* Instant rollback.
* Clear separation.

---

## 3️⃣ Canary deployments

* Release to **small % of users first**.
* Monitor metrics → expand rollout.

**Example**

* 1 pod (v2), 9 pods (v1)
* Increase v2 gradually.

**Why**

* Catches issues early.
* Best for high-risk releases.

---

## 4️⃣ Readiness & liveness probes (mandatory)

```yaml
readinessProbe:
  httpGet:
    path: /health
    port: 8080
```

**Why**

* Traffic sent only to **ready containers**.
* Prevents broken deployments.

---

## 5️⃣ Start-first strategy

```yaml
update_config:
  order: start-first
```

**What it does**

* Starts new container before stopping old one.
* Ensures capacity is never reduced.

---

## 6️⃣ Graceful shutdown handling

* Handle `SIGTERM`.
* Finish in-flight requests.
* Use connection draining.

**Why**

* Prevents user-visible errors.

---

## 7️⃣ Database & schema safety

* Backward-compatible schema changes.
* Expand → migrate → contract pattern.

---

## 🌍 Real-world production setup

* Kubernetes + ALB
* Canary via weighted target groups
* Prometheus alerts during rollout
* Instant rollback on error spike

---

⚠️ **Common mistakes**

* No health checks
* Deploying DB breaking changes
* Updating too many instances at once

---

💡 **In short (quick recall)**

* Run **old and new versions in parallel**.
* Use **rolling, blue-green, or canary**.
* Health checks + graceful shutdown are mandatory.
* Always have **fast rollback**.
---
## Q188: How do you handle stateful applications in Docker?

🧠 **Overview**

* Containers are **ephemeral**, but stateful apps need **persistent data**.
* Solution: **externalize state** using volumes, external services, and careful orchestration.
* Goal: **data durability, safe restarts, and predictable scaling**.

---

## 1️⃣ Use Docker volumes (primary method)

```bash
docker volume create db-data

docker run -d \
  -v db-data:/var/lib/mysql \
  mysql:8
```

**Why**

* Data survives container restarts/redeployments.
* Managed by Docker (safer than bind mounts).

---

## 2️⃣ Bind mounts (use carefully)

```bash
docker run -v /data/mysql:/var/lib/mysql mysql
```

**When**

* Dev or single-host setups.

**Risk**

* Tight coupling to host filesystem.
* Harder to migrate/backup.

---

## 3️⃣ Externalize state (best practice)

| State type | Recommended approach       |
| ---------- | -------------------------- |
| Database   | RDS, Cloud SQL, managed DB |
| Cache      | Redis/ElastiCache          |
| Files      | S3, EFS, NFS               |
| Sessions   | Redis / DB                 |

**Why**

* Containers stay stateless.
* Easier scaling, upgrades, rollbacks.

---

## 4️⃣ Stateful apps in Docker Swarm

```yaml
deploy:
  placement:
    constraints:
      - node.labels.db==true
```

**Why**

* Pin stateful containers to specific nodes.
* Prevents data inconsistency.

---

## 5️⃣ Backup & restore strategy (mandatory)

* Volume snapshots
* Scheduled DB backups
* Test restores regularly

```bash
docker run --rm \
  -v db-data:/data \
  -v $(pwd):/backup \
  busybox tar czf /backup/db.tar.gz /data
```

---

## 6️⃣ Avoid scaling stateful containers blindly

❌ Multiple replicas sharing same volume
❌ Auto-scaling databases via containers

✅ Single replica + external DB
✅ Managed database services

---

## 🌍 Real-world production pattern

* Containers run **stateless APIs**
* State stored in **RDS + S3**
* Docker used only for compute
* DB scaling handled separately

---

⚠️ **Common mistakes**

* Storing data inside container filesystem
* Sharing one volume across replicas
* No backup/restore plan

---

💡 **In short (quick recall)**

* Containers are ephemeral → **state must be external**.
* Use **Docker volumes** or **managed services**.
* Avoid scaling stateful containers.
* Always plan **backup & recovery**.

----
## Q189: What are the challenges of running databases in containers?

🧠 **Overview**

* Databases are **stateful**, while containers are **ephemeral**.
* Running databases in containers is possible, but **operationally risky at scale**.
* Most production systems prefer **managed databases** over containerized ones.

---

## ⚠️ Key challenges

### 1️⃣ Data persistence & durability

* Containers can be deleted or rescheduled.
* Risk of **data loss** if volumes aren’t managed correctly.

```bash
# Bad
docker run mysql   # data lost on container removal
```

---

### 2️⃣ Storage performance

* Databases need **low-latency, high IOPS**.
* Overlay FS / network volumes may cause **performance bottlenecks**.

---

### 3️⃣ Scaling complexity

* Databases don’t scale like stateless apps.
* Horizontal scaling requires:

  * Replication
  * Sharding
  * Leader election

**Hard to automate in containers.**

---

### 4️⃣ Backup & recovery

* No built-in backup lifecycle.
* Requires custom jobs and volume snapshots.
* Restore testing is often missed.

---

### 5️⃣ Upgrades & schema migrations

* Rolling upgrades can corrupt data.
* Version mismatch risks.
* Downtime likely without careful orchestration.

---

### 6️⃣ High availability (HA)

* Failover logic is complex.
* Volume reattachment delays.
* Split-brain risk.

---

### 7️⃣ Networking & latency

* Extra network hops.
* Service discovery changes can break clients.
* DNS caching issues.

---

### 8️⃣ Security & compliance

* Secrets management (DB passwords).
* Encryption at rest/in transit.
* Audit & compliance harder to enforce.

---

## 🌍 Real-world recommendation

| Scenario       | Recommendation              |
| -------------- | --------------------------- |
| Production     | Managed DB (RDS, Cloud SQL) |
| Dev/Test       | Containerized DB            |
| Edge / On-prem | StatefulSets / operators    |

---

## ⚠️ When containers are acceptable

* Dev/test environments
* CI pipelines
* Lightweight databases (SQLite, Redis cache)

---

💡 **In short (quick recall)**

* Databases ≠ stateless workloads.
* Containers add complexity for persistence, HA
---
## Q190: What strategies would you use for persistent storage in containers?

🧠 **Overview**

* Containers are **ephemeral**, but many apps need **durable data**.
* Persistent storage strategy depends on **environment (Docker vs Kubernetes)** and **data criticality**.
* Best practice: **externalize state whenever possible**.

---

## 1️⃣ Docker volumes (default & recommended)

```bash
docker volume create app-data

docker run -d \
  -v app-data:/var/lib/app \
  myapp
```

**Why**

* Data survives container restarts.
* Docker manages lifecycle.
* Safer than bind mounts.

---

## 2️⃣ Bind mounts (host-based)

```bash
docker run -v /data/app:/var/lib/app myapp
```

**When to use**

* Local dev
* Single-host setups

**Risks**

* Tight host coupling
* Hard to migrate

---

## 3️⃣ Network file systems (shared storage)

| Storage | Use case               |
| ------- | ---------------------- |
| NFS     | On-prem shared data    |
| EFS     | AWS multi-AZ workloads |
| CephFS  | Cloud-native storage   |

**Why**

* Multiple containers access same data.
* Required for HA stateful apps.

---

## 4️⃣ Cloud-managed storage (best for prod)

| Data type | Storage           |
| --------- | ----------------- |
| Objects   | S3 / GCS          |
| Files     | EFS / Azure Files |
| Databases | RDS / Cloud SQL   |

**Why**

* High durability
* Built-in backups
* Scales independently

---

## 5️⃣ Kubernetes-native storage (if applicable)

```yaml
volumeClaimTemplates:
- spec:
    accessModes: ["ReadWriteOnce"]
    resources:
      requests:
        storage: 20Gi
```

**Components**

* PersistentVolume (PV)
* PersistentVolumeClaim (PVC)
* StorageClass

---

## 6️⃣ Backup & snapshot strategy (mandatory)

* Volume snapshots
* Scheduled backups
* Restore testing

```bash
tar czf backup.tar.gz /data
```

---

## ⚠️ Anti-patterns

* Storing data inside container FS ❌
* Sharing local volumes across replicas ❌
* No backup strategy ❌

---

💡 **In short (quick recall)**

* Containers are ephemeral → **storage must persist externally**.
* Use **Docker volumes** or **managed storage**.
* Prefer **cloud-native storage services** in production.
* Always plan **backup & recovery**.
---
## Q191: How would you implement backup strategies for containerized databases?

🧠 **Overview**

* Backup strategy must protect against **container loss, node failure, and data corruption**.
* Backups should be **automated, consistent, off-node, and tested**.
* Rule: **backup the data, not the container**.

---

## 1️⃣ Database-native logical backups (most common)

```bash
docker exec db \
  mysqldump -u root -p appdb > appdb.sql
```

**Why**

* Portable across environments.
* Easy restore and migration.
* Works well for small–medium DBs.

**Limitation**

* Slower for large databases.

---

## 2️⃣ Scheduled backup sidecar/container

```bash
docker run --rm \
  --volumes-from db \
  -v /backups:/backups \
  mysql:8 \
  sh -c 'mysqldump -u root -p appdb > /backups/appdb.sql'
```

**Why**

* Separates backup logic from DB container.
* Easier automation via cron / CI.

---

## 3️⃣ Volume-level snapshots (fast & scalable)

* Take snapshots of:

  * EBS
  * LVM
  * Ceph
  * ZFS

```bash
aws ec2 create-snapshot --volume-id vol-xxxx
```

**Why**

* Fast backups for large datasets.
* Minimal downtime.

**Important**

* Use **DB freeze / flush** before snapshot for consistency.

---

## 4️⃣ Push backups to remote storage (mandatory)

* S3 / GCS / Azure Blob
* Encrypt + version backups

```bash
aws s3 cp appdb.sql s3://db-backups/prod/
```

**Why**

* Node loss ≠ data loss.
* Meets DR requirements.

---

## 5️⃣ Kubernetes-specific approach (if applicable)

* CronJob for dumps
* CSI volume snapshots
* Operators (Percona, Zalando)

---

## 6️⃣ Backup policy & automation

| Item       | Best practice         |
| ---------- | --------------------- |
| Frequency  | Daily + hourly WAL    |
| Retention  | 7–30 days             |
| Encryption | At rest + in transit  |
| Testing    | Regular restore tests |

---

## ⚠️ Common mistakes

* Backing up container images instead of data ❌
* No restore testing ❌
* Storing backups on same node ❌

---

💡 **In short (quick recall)**

* Use **DB-native dumps + volume snapshots**.
* Store backups **off-node** (S3).
* Automate, encrypt, and **test restores regularly**.

---
## Q192: What is Docker’s plugin system?

🧠 **Overview**

* Docker’s **plugin system** lets you **extend Docker Engine functionality** without modifying Docker itself.
* Plugins run as **managed containers** and integrate via **well-defined APIs**.
* Common uses: **storage (volumes)** and **networking**.

---

## ⚙️ What plugins can do

* Add **volume drivers** (EBS, NFS, NetApp, Ceph)
* Add **network drivers** (Weave, Calico – legacy Docker use)
* Provide **authorization** or **logging** extensions (less common today)

---

## 🧩 How it works

1. Plugin is installed from a registry.
2. Docker manages its lifecycle (enable/disable).
3. Docker Engine calls the plugin via a **socket/API**.

```
Docker Engine → Plugin API → Plugin (containerized)
```

---

## 1️⃣ Common plugin types

| Plugin type   | Purpose            | Example      |
| ------------- | ------------------ | ------------ |
| Volume        | Persistent storage | EBS, NFS     |
| Network       | Custom networking  | Weave        |
| Authorization | Access control     | Custom authz |
| Logging       | Log forwarding     | (rare now)   |

---

## 2️⃣ Example: Install a volume plugin

```bash
docker plugin install vieux/sshfs
```

**What it does**

* Installs an SSHFS-based volume driver.
* Docker can now mount volumes via SSH.

---

## 3️⃣ Use the plugin

```bash
docker volume create -d vieux/sshfs myvol
```

```bash
docker run -v myvol:/data myapp
```

**Why**

* Enables storage not supported natively by Docker.

---

## 4️⃣ Manage plugins

```bash
docker plugin ls
docker plugin enable <plugin>
docker plugin disable <plugin>
```

---

## ⚠️ Limitations & reality today

* Plugins require **host-level privileges**.
* Smaller ecosystem compared to Kubernetes CSI/CNI.
* In cloud-native setups, **Kubernetes drivers** usually replace Docker plugins.

---

## 🌍 Real-world usage

* On-prem Docker hosts needing **enterprise storage**
* Legacy Swarm deployments
* Single-host Docker setups with custom storage

---

💡 **In short (quick recall)**

* Docker plugin system = **extensibility mechanism**.
* Plugins add storage, networking, or auth features.
* Managed by Docker, run as containers.
* Less common today; Kubernetes has largely replaced it.

----
## Q193: What types of plugins does Docker support?

🧠 **Overview**

* Docker supports **pluggable extensions** that integrate with the Docker Engine via stable APIs.
* Plugins allow Docker to support **custom storage, networking, and security** needs.
* Most commonly used plugins today are **volume plugins**.

---

## 📋 Docker plugin types

| Plugin Type       | Purpose            | Typical Use Cases      | Examples               |
| ----------------- | ------------------ | ---------------------- | ---------------------- |
| **Volume**        | Persistent storage | Databases, shared data | EBS, NFS, Ceph, NetApp |
| **Network**       | Custom networking  | Multi-host networking  | Weave, Calico (legacy) |
| **Authorization** | Access control     | Security & governance  | AuthZ plugins          |
| **Logging**       | Log forwarding     | Centralized logging    | Fluentd (older)        |
| **Metrics**       | Stats collection   | Monitoring             | (rarely used)          |

---

## 1️⃣ Volume plugins (most common)

```bash
docker plugin install rexray/ebs
```

**What they do**

* Enable Docker volumes backed by **external storage systems**.
* Decouple container lifecycle from storage.

**Why**

* Required for **stateful workloads**.

---

## 2️⃣ Network plugins

```bash
docker network create -d weave mynet
```

**What they do**

* Provide overlay networking across hosts.
* Extend Docker’s default bridge/overlay behavior.

**Note**

* Mostly replaced by **Kubernetes CNI** today.

---

## 3️⃣ Authorization plugins

**Purpose**

* Intercept Docker API requests.
* Allow/deny actions based on policies.

**Use case**

* Multi-tenant Docker environments.
* Compliance and governance.

---

## 4️⃣ Logging plugins (legacy use)

```bash
docker run --log-driver=fluentd myapp
```

**Why less common**

* Modern setups use **sidecars/agents** instead.

---

## ⚠️ Key considerations

* Plugins often require **privileged access**.
* Limited ecosystem compared to Kubernetes.
* Evaluate security and maintenance before use.

---

💡 **In short (quick recall)**

* Docker plugins extend engine capabilities.
* Main types: **Volume, Network, Authorization**.
* Volume plugins are most widely used.
* Kubernetes CSI/CNI have largely replaced them.
----
## Q194: How do you install and manage Docker plugins?

🧠 **Overview**

* Docker plugins extend the Docker Engine (storage, networking, security).
* Plugins are **installed from a registry**, run as **managed components**, and are **controlled by Docker**.
* Admin-level access is required.

---

## 1️⃣ List installed plugins

```bash
docker plugin ls
```

**Why**

* Shows installed, enabled/disabled plugins.
* Helps audit extensions on a host.

---

## 2️⃣ Search for a plugin

```bash
docker search plugin rexray
```

**What it does**

* Finds available plugins in Docker Hub or registries.

---

## 3️⃣ Install a plugin

```bash
docker plugin install rexray/ebs
```

**What happens**

* Docker pulls the plugin image.
* Shows permissions required.
* Plugin is **disabled by default** until approved.

---

## 4️⃣ Enable / disable a plugin

```bash
docker plugin enable rexray/ebs
docker plugin disable rexray/ebs
```

**Why**

* Control when a plugin is active.
* Required before using the plugin.

---

## 5️⃣ Configure plugin settings

```bash
docker plugin set rexray/ebs EBS_REGION=us-east-1
```

**Why**

* Provide environment-specific config.
* Some settings require plugin restart.

---

## 6️⃣ Use the plugin (example: volume)

```bash
docker volume create -d rexray/ebs myvol
```

```bash
docker run -v myvol:/data myapp
```

---

## 7️⃣ Upgrade a plugin

```bash
docker plugin disable rexray/ebs
docker plugin upgrade rexray/ebs
docker plugin enable rexray/ebs
```

**Why**

* Ensure compatibility.
* Minimize downtime.

---

## 8️⃣ Remove a plugin

```bash
docker plugin disable rexray/ebs
docker plugin rm rexray/ebs
```

**Important**

* Plugin must be **disabled first**.

---

## ⚠️ Best practices

* Review requested **permissions carefully**.
* Install plugins only from **trusted sources**.
* Keep plugins **updated**.
* Avoid plugins when managed services exist.

---

💡 **In short (quick recall)**

* Install → enable → configure → use.
* Manage via `docker plugin` commands.
* Plugins require admin access and careful security review.
----

## Q195: What are third-party volume plugins (Rex-Ray, Portworx)?

🧠 **Overview**

* **Third-party volume plugins** extend Docker to provide **enterprise-grade persistent storage**.
* They allow containers to use **external storage systems** transparently.
* Used mainly for **stateful workloads** on Docker/Swarm (and historically before K8s CSI matured).

---

## 📋 Why third-party volume plugins are needed

* Native Docker volumes are **local to a host**.
* No built-in support for:

  * Cloud block storage
  * HA volumes
  * Snapshots & replication

**Plugins solve this gap.**

---

## 1️⃣ Rex-Ray

🧠 **What it is**

* Open-source **storage orchestration engine**.
* Acts as a bridge between Docker and cloud/on-prem storage.

**Supported backends**

* AWS EBS
* Azure Disk
* GCP PD
* NFS, Isilon, etc.

**Example**

```bash
docker plugin install rexray/ebs
docker volume create -d rexray/ebs myvol
docker run -v myvol:/data mysql
```

**Strengths**

* Simple
* Cloud-friendly
* Good for Docker & Swarm

**Limitations**

* Limited advanced features
* Mostly replaced by CSI in Kubernetes

---

## 2️⃣ Portworx

🧠 **What it is**

* **Enterprise-grade container storage platform**.
* Runs as a **distributed storage layer** across nodes.

**Key features**

* Replication & HA
* Snapshots & backups
* Encryption
* Performance tuning
* Stateful app awareness

**Example**

```bash
docker volume create -d pxd myvol
```

**Strengths**

* Production-ready for **databases**
* Strong HA & DR capabilities

**Tradeoff**

* Commercial (licensed)
* Operational complexity

---

## 📊 Rex-Ray vs Portworx

| Feature          | Rex-Ray              | Portworx                |
| ---------------- | -------------------- | ----------------------- |
| Type             | Storage driver       | Full storage platform   |
| HA / Replication | Limited              | Built-in                |
| Snapshots        | Basic                | Advanced                |
| Best for         | Simple cloud volumes | Mission-critical DBs    |
| Cost             | Open-source          | Commercial              |
| Modern usage     | Legacy Docker        | Kubernetes & enterprise |

---

## 🌍 Real-world guidance

* **Docker Swarm / legacy Docker** → Rex-Ray acceptable
* **Production databases** → Portworx (or managed DB)
* **Modern platforms** → Kubernetes CSI + managed storage

---

⚠️ **Important note**

* In Kubernetes, **CSI drivers have replaced Docker volume plugins**.
* New designs should prefer CSI over Docker plugins.

---

💡 **In short (quick recall)**

* Third-party volume plugins add **persistent, external storage** to Docker.
* **Rex-Ray** = simple cloud volume integration.
* **Portworx** = enterprise HA storage for containers.
* Largely superseded by **Kubernetes CSI** today.
----

## Q196: How would you implement high availability (HA) for Docker infrastructure?

🧠 **Overview**

* High availability ensures **no single point of failure** in Docker platforms.
* HA must cover **compute, networking, storage, control plane, and data**.
* Strategy differs for **standalone Docker vs Docker Swarm**.

---

## 1️⃣ Use a multi-node cluster (baseline)

* Never run production Docker on a single host.
* Minimum:

  * **3 nodes** (for quorum and failover)

**Why**

* Node failure ≠ service outage.

---

## 2️⃣ Docker Swarm HA (control plane)

### Manager nodes (critical)

* Use **odd number of managers** (3 or 5).
* Raft consensus ensures state consistency.

```bash
docker node promote worker1
```

**Best practice**

* Managers in different AZs.
* No heavy workloads on managers.

---

## 3️⃣ Service-level HA

### Replicas

```bash
docker service create --replicas 3 nginx
```

### Restart policies

```yaml
restart_policy:
  condition: on-failure
```

**Why**

* Failed containers restart automatically.
* Traffic spreads across replicas.

---

## 4️⃣ Load balancing & traffic HA

* Use **external load balancer** (ALB/NLB/HAProxy).
* Forward traffic to multiple Swarm nodes.
* Avoid single-entry nodes.

```
Client → LB → Swarm Nodes → Services
```

---

## 5️⃣ Networking HA

* Use **overlay networks**.
* Spread nodes across AZs.
* Monitor inter-node connectivity.

---

## 6️⃣ Storage HA (stateful workloads)

| Storage | HA strategy             |
| ------- | ----------------------- |
| Volumes | Replication / snapshots |
| DB      | Managed DB (RDS)        |
| Files   | EFS / NFS               |

**Rule**

* Externalize state wherever possible.

---

## 7️⃣ Backup & disaster recovery

* Automated backups (DB + volumes).
* Cross-AZ / cross-region copies.
* Test restore procedures.

---

## 8️⃣ Monitoring & self-healing

* Health checks
* Container auto-restarts
* Node monitoring & alerts

---

## 🌍 Real-world HA setup (example)

* 3 Swarm managers (AZ1/2/3)
* 6 worker nodes
* ALB in front
* EFS for shared storage
* Prometheus + Alertmanager

---

⚠️ **Common HA mistakes**

* Single manager
* Local-only volumes
* No backups
* No monitoring

---

💡 **In short (quick recall)**

* Use **multi-node clusters**.
* HA Swarm managers (odd number).
* Multiple service replicas.
* External load balancer.
* External, replicated storage.
* Backups + monitoring are mandatory.
----
## Q197: What strategies would you use for Docker registry high availability?

🧠 **Overview**

* A Docker registry is **critical infrastructure** for CI/CD and production.
* Registry downtime = **pipeline failures + blocked deployments**.
* HA requires **stateless registry nodes + highly available storage + load balancing**.

---

## 1️⃣ Use a managed registry (best practice)

| Registry              | HA handled by  |
| --------------------- | -------------- |
| AWS ECR               | AWS (multi-AZ) |
| GCP Artifact Registry | Google         |
| Azure ACR             | Azure          |

**Why**

* Built-in HA, scaling, backups.
* No infra maintenance.
* Recommended for production.

---

## 2️⃣ Stateless registry + external storage (self-hosted)

### Architecture

```
Clients → Load Balancer → Multiple Registry Pods
                          ↓
                     Shared Storage (S3 / NFS)
```

**Key idea**

* Registry containers are **stateless**.
* Images stored in **shared backend**.

---

## 3️⃣ Configure Docker Registry with S3 backend

```yaml
storage:
  s3:
    bucket: my-registry-bucket
    region: us-east-1
```

**Why**

* S3 is durable and highly available.
* Registry nodes can fail safely.

---

## 4️⃣ Run multiple registry instances

```bash
docker service create \
  --name registry \
  --replicas 3 \
  registry:2
```

**Why**

* One instance failure ≠ outage.
* Supports rolling upgrades.

---

## 5️⃣ Front with a load balancer

* ALB / NLB / HAProxy / Nginx
* Enable:

  * Health checks
  * TLS termination

```
Docker Clients → LB → Registry replicas
```

---

## 6️⃣ Enable registry caching (performance + resilience)

* Pull-through cache for Docker Hub / upstream registries.
* Reduces external dependency and rate limits.

---

## 7️⃣ Backup & disaster recovery

* S3 versioning enabled
* Cross-region replication
* Periodic registry metadata backups

---

## 8️⃣ Security & access HA

* Use token-based auth
* Avoid single auth backend
* IAM-based access (cloud registries)

---

## 9️⃣ Monitoring & alerting

Monitor:

* Registry availability
* Push/pull latency
* Storage errors
* Disk usage (if self-hosted)

---

## 🌍 Real-world production patterns

### Small / Medium

* **ECR / ACR / GCR** → done

### Enterprise / On-prem

* Harbor (HA mode)
* Nexus Repository (HA)
* Registry + S3 + LB

---

⚠️ **Common mistakes**

* Single registry instance ❌
* Local disk storage ❌
* No backups ❌
* Registry inside same node as CI ❌

---

💡 **In short (quick recall)**

* Prefer **managed registries** for HA.
* Self-hosted → **multiple replicas + shared storage + LB**.
* Registry must be **stateless**.
* Backups and monitoring are mandatory.
----
## Q198: How do you implement disaster recovery (DR) for Docker environments?

🧠 **Overview**

* Disaster recovery ensures Docker workloads can **recover after major failures** (AZ, region, data loss).
* DR focuses on **data, images, configuration, and automation**, not containers themselves.
* Strategy depends on **RTO/RPO requirements**.

---

## 1️⃣ Define DR objectives first (must)

| Metric | Meaning                  |
| ------ | ------------------------ |
| RTO    | Time to restore service  |
| RPO    | Max acceptable data loss |

**Why**

* Determines architecture (backup vs active-active).

---

## 2️⃣ Backup persistent data (highest priority)

### Databases & volumes

* DB-native dumps
* Volume snapshots (EBS, Ceph, LVM)
* Cross-region copy

```bash
aws ec2 copy-snapshot --source-region us-east-1 ...
```

---

## 3️⃣ Use HA, replicated container images

* Use **managed registries** (ECR/ACR/GCR).
* Enable cross-region replication.
* Avoid single-node registries.

---

## 4️⃣ Infrastructure as Code (mandatory)

* Docker hosts
* Networking
* Security
* Storage

**Tools**

* Terraform
* CloudFormation
* Ansible

**Why**

* Rebuild entire environment quickly.

---

## 5️⃣ Multi-AZ / multi-region strategy

| DR Type          | Setup                 |
| ---------------- | --------------------- |
| Backup + restore | Cheapest              |
| Pilot light      | Minimal infra standby |
| Warm standby     | Partial infra running |
| Active-active    | Zero downtime         |

---

## 6️⃣ Swarm / orchestration recovery

* Multiple managers (odd number).
* Backup Swarm state:

```bash
/var/lib/docker/swarm
```

* Automate cluster re-init if needed.

---

## 7️⃣ Configuration & secrets backup

* Version Docker Compose / stack files in Git.
* Backup secrets securely.
* Avoid manual config.

---

## 8️⃣ Automation & runbooks

* One-click restore scripts.
* Document:

  * Restore order
  * Validation steps
  * Rollback

---

## 9️⃣ Test DR regularly (often skipped)

* Chaos testing
* Game days
* Full restore drills

---

## 🌍 Real-world DR example

* EKS/ECR (multi-region)
* DB snapshots replicated cross-region
* Terraform to rebuild infra
* Docker images already available
* RTO < 30 minutes

---

⚠️ **Common mistakes**

* Backing up containers instead of data
* No restore testing
* Manual rebuild steps
* Single-region registries

---

💡 **In short (quick recall)**

* DR = **data + images + infra code**.
* Define RTO/RPO.
* Backup & replicate persistent data.
* Use IaC for fast rebuilds.
* Test recovery regularly.
----
## Q199: What are the considerations for Docker in production at scale?

🧠 **Overview**

* Running Docker at scale requires **standardization, automation, security, observability, and resilience**.
* Focus shifts from “running containers” to **operating a reliable platform**.

---

## 1️⃣ Orchestration & scheduling

* Use an orchestrator (**Kubernetes** preferred; Swarm only for small setups).
* Enable **self-healing, rolling updates, autoscaling**.
* Avoid manual `docker run` in prod.

---

## 2️⃣ Image strategy & registry

* **Immutable images** (versioned tags + digests).
* Avoid `latest`.
* Use **HA registries** (ECR/ACR/GCR) with replication.
* Enable **pull-through cache** for CI/K8s nodes.

---

## 3️⃣ CI/CD & automation

* Build once, promote across envs.
* Automated tests, scans, approvals.
* Blue/green or canary for risky releases.

```bash
docker build -t app:$GIT_SHA .
docker push app:$GIT_SHA
```

---

## 4️⃣ Security (non-negotiable)

* Minimal base images (distroless/alpine).
* Image scanning (Trivy, ECR scan).
* Secrets via **Vault / AWS Secrets Manager** (not env vars).
* Run as non-root, drop capabilities.

---

## 5️⃣ Networking & traffic management

* Stable service discovery.
* External LBs for ingress.
* TLS everywhere.
* Avoid hardcoded IPs/ports.

---

## 6️⃣ Storage & state management

* Containers are **stateless by default**.
* Use:

  * Managed DBs (RDS, Cloud SQL)
  * Network storage (EFS, NFS)
* Never store critical data in container FS.

---

## 7️⃣ Observability (logs, metrics, traces)

* Centralized logging (Fluent Bit → ELK/Loki/CloudWatch).
* Metrics via Prometheus.
* Tracing via OpenTelemetry.
* Alert on **symptoms**, not noise.

---

## 8️⃣ Resource management

* Enforce CPU/memory **requests & limits**.
* Prevent noisy neighbors.
* Capacity planning + autoscaling.

---

## 9️⃣ High availability & resilience

* Multi-node, multi-AZ setup.
* Multiple replicas for services.
* Externalized state.
* Regular backups + DR testing.

---

## 🔟 Operations & governance

* Infrastructure as Code (Terraform).
* Versioned configs in Git.
* RBAC and access controls.
* Clear runbooks & on-call readiness.

---

## ⚠️ Common production failures

* Single-node Docker
* `latest` tag in prod
* No log rotation
* No backups
* Manual deployments

---

💡 **In short (quick recall)**

* Use an orchestrator.
* Immutable images + HA registry.
* Strong security & observability.
* Externalize state.
* Automate everything.
* Plan for failure by default.
----
## Q200: How would you implement container orchestration beyond Docker Compose?

🧠 **Overview**

* Docker Compose is **single-host** and not production-grade at scale.
* For real orchestration you need **scheduling, HA, scaling, rolling updates, and self-healing**.
* The choice depends on **scale, complexity, and cloud maturity**.

---

## 1️⃣ Kubernetes (industry standard – recommended)

### Why Kubernetes

* Multi-node orchestration
* Auto-healing, autoscaling
* Rolling, blue-green, canary deployments
* Massive ecosystem (Ingress, CSI, CNI, Operators)

### Basic flow

```bash
kubectl apply -f deployment.yaml
```

```yaml
apiVersion: apps/v1
kind: Deployment
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
```

**Use when**

* Production workloads
* Microservices
* Cloud-native platforms

---

## 2️⃣ Docker Swarm (simple step up from Compose)

```bash
docker swarm init
docker stack deploy -c docker-compose.yml app
```

**Pros**

* Easy transition from Compose
* Built-in LB and rolling updates

**Cons**

* Limited ecosystem
* Not ideal at scale

**Use when**

* Small clusters
* Minimal ops team

---

## 3️⃣ Cloud-managed container platforms

| Platform  | Best for                        |
| --------- | ------------------------------- |
| AWS ECS   | Simple AWS-native orchestration |
| AWS EKS   | Managed Kubernetes              |
| Azure AKS | Managed Kubernetes              |
| GKE       | Best-in-class K8s               |

**Why**

* Control plane HA handled by cloud.
* Faster time to production.

---

## 4️⃣ GitOps-based orchestration

**Tools**

* Argo CD
* Flux

**Flow**

```
Git → Controller → Cluster
```

**Why**

* Declarative, auditable deployments.
* Easy rollback.
* Strong governance.

---

## 5️⃣ Advanced deployment patterns

| Pattern              | Tooling       |
| -------------------- | ------------- |
| Blue-Green           | K8s + LB      |
| Canary               | Argo Rollouts |
| Progressive delivery | Flagger       |

---

## 6️⃣ Migration path from Docker Compose

```text
Compose → Swarm → Kubernetes
or
Compose → ECS → EKS
```

* Convert Compose to K8s manifests (Kompose).
* Externalize config & secrets.
* Add observability and CI/CD.

---

## ⚠️ What NOT to do

* Use Compose in production ❌
* Manual container management ❌
* Hardcode scaling & IPs ❌

---

💡 **In short (quick recall)**

* Compose is **not orchestration**.
* Kubernetes is the **default choice**.
* Swarm/ECS for simpler needs.
* Use **managed services + GitOps** for scale.

----

# Troubleshooting / Scenarios

## Q201: A container exits immediately after starting. How do you troubleshoot?

### 🔍 Step-by-step troubleshooting (practical)

### 1️⃣ Check container exit status

```bash
docker ps -a
```

* **What**: Shows stopped containers
* **Why**: Exit code tells why it stopped
* **Key**:

  * `0` → app finished normally
  * `1/125/126/127` → app/command error

---

### 2️⃣ Inspect container logs

```bash
docker logs <container_id>
```

* **What**: Prints stdout/stderr of the container
* **Why**: Most common place to see crashes, config errors, missing env vars
* **Example**: App failed due to missing DB connection

---

### 3️⃣ Inspect container configuration

```bash
docker inspect <container_id>
```

Check:

* `Cmd` / `Entrypoint` → wrong command?
* `Env` → missing environment variables?
* `Mounts` → volume path issues?

---

### 4️⃣ Run container interactively

```bash
docker run -it --entrypoint /bin/sh <image>
```

* **What**: Opens shell inside container
* **Why**: Validate binaries, configs, file paths
* **Real-world**: App binary not found at runtime

---

### 5️⃣ Verify CMD / ENTRYPOINT behavior

```dockerfile
CMD ["app"]
ENTRYPOINT ["sh", "-c"]
```

* **Issue**: App runs once and exits
* **Fix**: Use a long-running process (web server, worker loop)

---

### 6️⃣ Check resource limits (OOM kills)

```bash
docker inspect <container_id> | grep OOMKilled
```

* **What**: Detects memory kill
* **Why**: Container exits without logs
* **Fix**: Increase memory or optimize app

---

### 7️⃣ Validate image locally

```bash
docker run --rm <image> <command>
```

* **What**: Runs image without orchestration
* **Why**: Confirms image itself is healthy

---

### 8️⃣ If on Kubernetes (very common in interviews)

```bash
kubectl describe pod <pod>
kubectl logs <pod> --previous
```

* **What**: Shows CrashLoopBackOff reason
* **Why**: Container restarts hide first failure

---

### ✅ Common root causes (interview-ready)

* Application crashes on startup
* Wrong `CMD` / `ENTRYPOINT`
* Missing env vars / secrets
* Port already in use
* Image built incorrectly
* Container expects foreground process but exits

---

### 💡 In short (2–3 lines)

A container exits immediately when its main process fails or finishes. Check **exit code, logs, CMD/ENTRYPOINT, env vars, and OOM kills**. Run it interactively to debug and ensure a long-running foreground process.

----
## Q202: Docker build is failing with **“No space left on device”**. What would you check?

### 🔍 Step-by-step checks (production-focused)

---

### 1️⃣ Check disk usage on Docker host

```bash
df -h
```

* **What**: Shows filesystem usage
* **Why**: Docker uses host disk (`/var/lib/docker`)
* **Key**: Root disk often fills up in CI agents

---

### 2️⃣ Check Docker disk consumption

```bash
docker system df
```

* **What**: Space used by images, containers, volumes, cache
* **Why**: Build cache and old images pile up

---

### 3️⃣ Clean unused Docker data (most common fix)

```bash
docker system prune -af
```

* **What**: Removes unused images, containers, networks
* **Why**: Frees disk immediately
* **Note**: Use carefully on shared hosts

For volumes:

```bash
docker volume prune
```

---

### 4️⃣ Check build cache size

```bash
docker builder prune -af
```

* **What**: Clears Docker build cache
* **Why**: Large multi-stage builds create huge cache layers
* **Real-world**: CI/CD agents frequently hit this issue

---

### 5️⃣ Check inode exhaustion (often missed)

```bash
df -i
```

* **What**: Shows inode usage
* **Why**: Many small files (node_modules, pip cache) exhaust inodes even if disk looks free

---

### 6️⃣ Verify large files in build context

```bash
du -sh .
```

* **What**: Size of Docker build context
* **Why**: Sending large folders (logs, .git, node_modules)
* **Fix**: Use `.dockerignore`

Example:

```dockerignore
.git
node_modules
*.log
```

---

### 7️⃣ Check CI runner / agent limits

* **GitHub Actions / GitLab Runner / Jenkins**
* Runners often have **small ephemeral disks**
* Fix:

  * Increase disk size
  * Use self-hosted runners
  * Clean workspace after build

---

### 8️⃣ Check overlay2 storage driver path

```bash
docker info | grep "Docker Root Dir"
```

* **What**: Shows Docker storage location
* **Why**: Disk might be full on that mount specifically

---

### ✅ Common root causes (interview-ready)

* Old images and stopped containers
* Large build cache
* Missing `.dockerignore`
* Inode exhaustion
* Limited disk on CI runners

---

### 💡 In short (2–3 lines)

Docker build fails when the **host or Docker storage disk is full**. Check disk/inodes, clean unused images and build cache, reduce build context with `.dockerignore`, and watch CI runner disk limits.

----
## Q203: A container cannot connect to another container on the same network. How do you debug?

### 🔍 Step-by-step debugging (Docker-focused)

---

### 1️⃣ Verify both containers are on the same network

```bash
docker network ls
docker network inspect <network_name>
```

* **What**: Lists networks and connected containers
* **Why**: Containers must share a user-defined bridge network
* **Key**: `bridge` default has limitations; prefer custom networks

---

### 2️⃣ Use container name (not localhost)

```bash
curl http://app:8080
```

❌ Wrong:

```bash
curl http://localhost:8080
```

* **Why**: `localhost` refers to the same container
* **Fix**: Use **container name or service name** (Docker DNS)

---

### 3️⃣ Check target container is listening

```bash
docker exec -it <container> netstat -tulnp
# or
ss -tulnp
```

* **What**: Confirms port is open inside container
* **Why**: App may be running but not listening

---

### 4️⃣ Test connectivity from source container

```bash
docker exec -it <source> ping <target>
docker exec -it <source> curl http://<target>:<port>
```

* **What**: Validates DNS and network path
* **Why**: Confirms whether it’s DNS, port, or app issue

---

### 5️⃣ Check exposed vs published ports (common confusion)

```bash
docker inspect <container> | grep -i port
```

* **Key**:

  * `EXPOSE` → documentation only
  * `-p` → host access
* **Note**: **Containers don’t need `-p` to talk to each other**

---

### 6️⃣ Verify container health & startup order

```bash
docker ps
docker inspect --format='{{.State.Health.Status}}' <container>
```

* **Why**: App may not be ready when connection attempted
* **Fix**: Use retries or `depends_on` + healthchecks

---

### 7️⃣ Check firewall / iptables rules

```bash
iptables -L -n
```

* **Why**: Host-level firewall may block inter-container traffic
* **Real-world**: Hardened hosts or cloud images

---

### 8️⃣ If using Docker Compose (very common)

```yaml
services:
  app:
    depends_on:
      - db
```

* **Key**: Use service names (`db:5432`)
* **Compose** automatically creates a shared network

---

### ✅ Common root causes (interview-ready)

* Containers on different networks
* Using `localhost` instead of container name
* App not listening on expected port
* Wrong port or protocol
* App not ready (startup timing issue)

---

### 💡 In short (2–3 lines)

Containers must be on the **same user-defined network** and connect using **container/service names**, not `localhost`. Verify network attachment, port listening, DNS resolution, and app readiness.

----

## Q204: Docker daemon fails to start. What logs would you examine?

### 🔍 Primary logs to check (Linux / production)

---

### 1️⃣ systemd service status (first check)

```bash
systemctl status docker
```

* **What**: Shows immediate failure reason
* **Why**: Quick visibility into crash loops, exit codes

---

### 2️⃣ Docker daemon logs (journal)

```bash
journalctl -u docker
journalctl -u docker -n 100
journalctl -u docker -f
```

* **What**: Detailed daemon startup errors
* **Why**: Most accurate source (storage, config, permission issues)

---

### 3️⃣ Docker config file issues

```bash
cat /etc/docker/daemon.json
```

* **Why**: Invalid JSON or unsupported options stop Docker
* **Common errors**:

  * Bad log driver
  * Wrong registry config
  * Invalid DNS settings

Validate:

```bash
jq . /etc/docker/daemon.json
```

---

### 4️⃣ Storage driver & disk errors

```bash
journalctl -u docker | grep -i overlay
df -h
df -i
```

* **Why**: `overlay2` corruption, disk full, inode exhaustion
* **Real-world**: Most common prod issue

---

### 5️⃣ Permissions & socket issues

```bash
ls -l /var/run/docker.sock
```

* **Why**: Wrong ownership or stale socket blocks startup
* **Key**: Should be owned by `root:docker`

---

### 6️⃣ Kernel & OS compatibility

```bash
uname -r
dmesg | tail
```

* **Why**: Kernel missing required features (cgroups, overlayfs)
* **Seen in**: Minimal AMIs, custom OS images

---

### 7️⃣ SELinux / AppArmor (if enabled)

```bash
getenforce
ausearch -m avc
```

* **Why**: Security policies blocking Docker startup
* **Common on**: RHEL / CentOS / Amazon Linux

---

### 8️⃣ If recently upgraded Docker

```bash
docker version
```

* **Why**: Version mismatch with containerd or runc
* **Fix**: Restart containerd or rollback

---

### ✅ Most common root causes (interview-ready)

* Invalid `daemon.json`
* Disk/inode full under `/var/lib/docker`
* Storage driver corruption
* Permission or socket issues
* Kernel / SELinux restrictions

---

### 💡 In short (2–3 lines)

Start with **`systemctl status docker`** and **`journalctl -u docker`**. Most failures come from **bad daemon config, disk issues, storage driver errors, or permission/security restrictions**.

---
## Q205: A container is running but not responding to requests. How do you investigate?

### 🔍 Step-by-step investigation (production-style)

---

### 1️⃣ Verify container status & port mapping

```bash
docker ps
```

* **What**: Confirms container is running
* **Why**: Running ≠ healthy
* **Check**: Correct port published (`-p 80:8080`)

---

### 2️⃣ Check application logs

```bash
docker logs <container>
```

* **What**: App-level errors, timeouts, startup failures
* **Real-world**: App stuck waiting for DB or external API

---

### 3️⃣ Confirm process is running inside container

```bash
docker exec -it <container> ps aux
```

* **Why**: App may have crashed but container kept alive by wrapper process

---

### 4️⃣ Verify app is listening on expected port

```bash
docker exec -it <container> ss -tulnp
# or
netstat -tulnp
```

* **Why**: App might be listening on `127.0.0.1` instead of `0.0.0.0`

---

### 5️⃣ Test from inside the container

```bash
docker exec -it <container> curl localhost:8080
```

* **What**: Bypasses Docker networking
* **Why**: Confirms if issue is app-level or network-level

---

### 6️⃣ Test from another container (same network)

```bash
docker exec -it <other_container> curl http://app:8080
```

* **Why**: Validates inter-container networking and DNS

---

### 7️⃣ Check healthcheck status

```bash
docker inspect --format='{{.State.Health.Status}}' <container>
```

* **Why**: Container may be `unhealthy` even if running
* **Fix**: Review healthcheck command

---

### 8️⃣ Check resource saturation

```bash
docker stats
```

* **What**: CPU, memory, network usage
* **Why**: App may be stuck due to CPU throttling or memory pressure

---

### 9️⃣ Validate firewall / security rules

* Host firewall (`iptables`, `ufw`)
* Cloud SG/NACL (AWS security groups)
* App-level ACLs

---

### 10️⃣ If on Kubernetes (interview bonus)

```bash
kubectl describe pod <pod>
kubectl logs <pod>
kubectl exec -it <pod> -- curl localhost:8080
```

* **Why**: Readiness probe failures block traffic

---

### ✅ Common root causes (interview-ready)

* App listening on wrong interface/port
* Failed dependency (DB, cache)
* Healthcheck failing
* Resource exhaustion
* Network/firewall blocking traffic

---

### 💡 In short (2–3 lines)

If a container runs but doesn’t respond, check **logs, listening ports, healthchecks, and resource usage**. Test requests **inside the container first** to isolate app vs network issues.

----
## Q206: Docker build is extremely slow. What would you optimize?

### 🔍 Key optimizations (practical & interview-ready)

---

### 1️⃣ Reduce Docker build context size

```bash
docker build .
```

Check context size in output:

```text
Sending build context to Docker daemon  1.2GB
```

**Fix with `.dockerignore`:**

```dockerignore
.git
node_modules
target
*.log
```

* **Why**: Large context = slow upload + hashing

---

### 2️⃣ Reorder Dockerfile for better layer caching

```dockerfile
# ❌ Bad
COPY . .
RUN npm install

# ✅ Good
COPY package*.json ./
RUN npm install
COPY . .
```

* **Why**: Dependency layers get cached
* **Impact**: Huge speedup in CI builds

---

### 3️⃣ Use multi-stage builds

```dockerfile
FROM node:20 AS build
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
```

* **Why**: Smaller final image, faster push/pull

---

### 4️⃣ Enable BuildKit (major win)

```bash
export DOCKER_BUILDKIT=1
docker build .
```

* **Why**: Parallel steps, better caching
* **Real-world**: Default in modern CI runners

---

### 5️⃣ Cache dependencies in CI/CD

* **GitHub Actions / GitLab / Jenkins**
* Cache:

  * `.m2`
  * `node_modules`
  * `pip cache`

Example (GitHub Actions):

```yaml
- uses: actions/cache@v4
```

---

### 6️⃣ Minimize RUN layers

```dockerfile
# ❌
RUN apt update
RUN apt install -y curl

# ✅
RUN apt update && apt install -y curl && rm -rf /var/lib/apt/lists/*
```

* **Why**: Fewer layers + smaller image

---

### 7️⃣ Use smaller base images

```dockerfile
FROM python:3.12-alpine
```

* **Why**: Faster pulls, less disk IO
* **Note**: Watch for missing system libs

---

### 8️⃣ Avoid downloading deps every build

* Pin versions
* Use lock files (`package-lock.json`, `poetry.lock`)
* Avoid `latest` tags

---

### 9️⃣ Parallelize builds in CI

* Split builds by service
* Use remote cache (BuildKit + registry cache)

---

### ✅ Most common causes (interview-ready)

* Huge build context
* Poor layer caching
* No BuildKit
* Heavy base images
* Reinstalling dependencies every build

---

### 💡 In short (2–3 lines)

Slow Docker builds are usually caused by **large build contexts and poor layer caching**. Use `.dockerignore`, reorder Dockerfile, enable **BuildKit**, cache dependencies, and use smaller base images.

----
## Q207: Image layers are not being cached during build. Why?

### 🔍 Common reasons & how to verify (interview-ready)

---

### 1️⃣ Files copied before dependencies change every time

```dockerfile
COPY . .
RUN npm install
```

* **Why cache breaks**: Any file change invalidates the layer
* **Fix**:

```dockerfile
COPY package*.json ./
RUN npm install
COPY . .
```

---

### 2️⃣ Using `--no-cache` flag

```bash
docker build --no-cache .
```

* **Why**: Explicitly disables caching
* **Check**: CI pipelines often add this by default

---

### 3️⃣ Build context changes on every run

* Timestamps, logs, `.git`, temp files
* **Fix**: `.dockerignore`

```dockerignore
.git
*.log
tmp/
```

---

### 4️⃣ Non-deterministic commands in `RUN`

```dockerfile
RUN apt update
RUN npm install
```

* **Why**: Downloads change → cache invalidated
* **Fix**:

  * Pin versions
  * Use lock files
  * Combine steps

---

### 5️⃣ Different build args or env values

```dockerfile
ARG BUILD_TIME
RUN echo $BUILD_TIME
```

* **Why**: Changing ARG invalidates cache
* **Seen in**: CI metadata injection

---

### 6️⃣ Base image changes

```dockerfile
FROM node:latest
```

* **Why**: `latest` updates frequently
* **Fix**:

```dockerfile
FROM node:20.11
```

---

### 7️⃣ BuildKit cache not enabled or misconfigured

```bash
docker buildx build .
```

* **Why**: Local cache not reused across runners
* **Fix**: Use registry or inline cache

```bash
--cache-from --cache-to
```

---

### 8️⃣ Multi-stage build cache scope misunderstood

* Cache applies **per stage**
* Changing early stages invalidates downstream stages

---

### 9️⃣ CI runners are ephemeral

* Fresh VM → no local cache
* **Fix**:

  * Enable remote cache
  * Use self-hosted runners

---

### ✅ Quick checklist (interview-ready)

* Dockerfile order correct?
* `.dockerignore` present?
* No `--no-cache`?
* Base image pinned?
* Deterministic installs?
* CI cache configured?

---

### 💡 In short (2–3 lines)

Docker cache breaks when **inputs change**—files, args, base images, or commands. Fix by **reordering Dockerfile, pinning versions, ignoring noise, and enabling BuildKit with remote cache in CI**.

----
## Q208: A container is using excessive memory. How do you identify the cause?

### 🔍 Step-by-step diagnosis (production-ready)

---

### 1️⃣ Identify the offending container

```bash
docker stats
```

* **What**: Live CPU/memory usage per container
* **Why**: Quickly spot memory hogs

---

### 2️⃣ Check container memory limits

```bash
docker inspect <container> | grep -i memory
```

* **Why**: No limit → container can consume all host memory
* **Best practice**: Always set `--memory`

Example:

```bash
docker run -m 512m my-app
```

---

### 3️⃣ Check for OOM kills

```bash
docker inspect <container> | grep OOMKilled
```

* **Why**: Confirms if kernel killed the process
* **Real-world**: App restarts without clear logs

---

### 4️⃣ Inspect processes inside the container

```bash
docker exec -it <container> ps aux --sort=-%mem | head
```

* **What**: Find which process is leaking memory
* **Why**: App-level vs runtime-level issue

---

### 5️⃣ Analyze application memory behavior

* JVM: heap too large / GC issues
* Python: unbounded caches, pandas objects
* Node.js: memory leaks, missing `--max-old-space-size`

Example (Node.js):

```bash
node --max-old-space-size=512 app.js
```

---

### 6️⃣ Check logs for memory pressure signals

```bash
docker logs <container>
```

* **Look for**:

  * GC thrashing
  * OutOfMemoryError
  * Cache growth warnings

---

### 7️⃣ Validate cgroup memory stats

```bash
cat /sys/fs/cgroup/memory/memory.usage_in_bytes
```

* **Why**: Confirms actual cgroup usage vs app metrics

---

### 8️⃣ Check swap usage

```bash
docker info | grep Swap
```

* **Why**: Swap hides real memory pressure
* **Production**: Often disabled for predictability

---

### 9️⃣ Correlate with traffic/load

* Memory spike after traffic surge?
* Batch jobs accumulating data?
* Missing cache eviction?

---

### 1️⃣0️⃣ If running in Kubernetes (bonus)

```bash
kubectl top pod
kubectl describe pod <pod>
```

* **Why**: Requests/limits mismatch cause throttling or OOMKills

---

### ✅ Common root causes (interview-ready)

* No memory limits set
* Application memory leak
* Cache growing unbounded
* JVM heap misconfiguration
* High traffic / batch spikes

---

### 💡 In short (2–3 lines)

Use `docker stats` to identify the container, inspect **memory limits and OOM kills**, then check **process-level memory inside the container**. Most issues come from **missing limits or application-level leaks**, not Docker itself.

----
## Q209: Port mapping is not working and the application is not accessible. What would you check?

### 🔍 Step-by-step checks (Docker → Host → App)

---

### 1️⃣ Verify port mapping on container

```bash
docker ps
```

* **Check**: `0.0.0.0:80->8080/tcp`
* **Why**: Confirms port is actually published

---

### 2️⃣ Validate `docker run -p` syntax

```bash
docker run -p 80:8080 my-app
```

* **Meaning**: `host_port:container_port`
* **Common mistake**: Reversed ports

---

### 3️⃣ Confirm app is listening on correct port

```bash
docker exec -it <container> ss -tulnp
```

* **Why**: App might listen on `3000` while exposing `8080`

---

### 4️⃣ Check bind address (VERY common)

```bash
docker exec -it <container> curl localhost:8080
```

* **Issue**:

  * App listening on `127.0.0.1`
* **Fix**:

  * Bind to `0.0.0.0`

Example:

```bash
app --host 0.0.0.0
```

---

### 5️⃣ Test access from host

```bash
curl localhost:80
```

* **Why**: Confirms Docker → host networking works

---

### 6️⃣ Check host firewall / iptables

```bash
iptables -L -n
ufw status
```

* **Why**: Host firewall may block the port

---

### 7️⃣ Check cloud security rules (AWS/Azure)

* **AWS**: Security Group allows port?
* **Azure**: NSG allows inbound traffic?

---

### 8️⃣ Verify no port conflict on host

```bash
ss -tulnp | grep :80
```

* **Why**: Another process may already be using the port

---

### 9️⃣ EXPOSE vs -p confusion

```dockerfile
EXPOSE 8080
```

* **Key**:

  * `EXPOSE` ≠ publish port
  * `-p` is required for host access

---

### 1️⃣0️⃣ If using Docker Compose

```yaml
ports:
  - "80:8080"
```

* **Check**: Correct service and port mapping

---

### ✅ Common root causes (interview-ready)

* App bound to `localhost` inside container
* Wrong port mapping order
* Host firewall / cloud SG blocking
* Port already in use
* EXPOSE misunderstood

---

### 💡 In short (2–3 lines)

Confirm the port is **published (`-p`)**, the app listens on the **correct port and `0.0.0.0`**, and nothing (firewall, SG, port conflict) is blocking host access.

----  
## Q210: Docker pull is failing with **“TLS handshake timeout”**. How do you resolve this?

### 🔍 Step-by-step troubleshooting (real-world)

---

### 1️⃣ Check basic network connectivity

```bash
ping google.com
curl https://registry-1.docker.io/v2/
```

* **Why**: Confirms internet + HTTPS access
* **If slow/fails**: Network or DNS issue, not Docker

---

### 2️⃣ Verify DNS configuration (VERY common)

```bash
cat /etc/resolv.conf
```

* **Issue**: Corporate or broken DNS
* **Fix (temporary test)**:

```bash
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
```

---

### 3️⃣ Check proxy configuration

```bash
env | grep -i proxy
```

* **Why**: TLS timeout often caused by misconfigured proxy
* **Fix**: Configure Docker proxy correctly

Example:

```bash
mkdir -p /etc/systemd/system/docker.service.d
cat <<EOF > /etc/systemd/system/docker.service.d/proxy.conf
[Service]
Environment="HTTP_PROXY=http://proxy:port"
Environment="HTTPS_PROXY=http://proxy:port"
EOF
systemctl daemon-reexec
systemctl restart docker
```

---

### 4️⃣ Try pulling with increased timeout

```bash
docker pull --disable-content-trust=false nginx
```

Or test via curl:

```bash
curl -Iv https://registry-1.docker.io
```

* **Why**: Identifies TLS negotiation delays

---

### 5️⃣ Check system time & certificates

```bash
date
timedatectl
```

* **Why**: Time skew breaks TLS handshakes
* **Fix**:

```bash
timedatectl set-ntp true
```

---

### 6️⃣ Validate CA certificates

```bash
update-ca-certificates
```

* **Why**: Missing/expired CA certs cause TLS failures
* **Seen in**: Minimal OS images, old AMIs

---

### 7️⃣ Test alternate registry or mirror

```bash
docker pull public.ecr.aws/nginx/nginx
```

* **Why**: Confirms Docker Hub–specific issue
* **Fix**: Configure registry mirror

```json
{
  "registry-mirrors": ["https://mirror.gcr.io"]
}
```

---

### 8️⃣ Check firewall / corporate network restrictions

* SSL inspection
* Blocked Docker Hub domains
* MTU issues (VPNs)

Test MTU:

```bash
ping -M do -s 1472 registry-1.docker.io
```

---

### 9️⃣ Retry after restarting Docker

```bash
systemctl restart docker
```

* **Why**: Clears stuck network state

---

### ✅ Most common root causes (interview-ready)

* DNS resolution problems
* Proxy misconfiguration
* Firewall / corporate network blocking
* Incorrect system time
* CA certificate issues

---

### 💡 In short (2–3 lines)

TLS handshake timeouts during `docker pull` are usually **network, DNS, or proxy-related**. Verify internet/DNS, fix proxy or firewall rules, ensure system time and CA certs are valid, and use registry mirrors if needed.

----
## Q211: A volume mount is not working and files are not visible in the container. What’s wrong?

### 🔍 Step-by-step checks (most common causes first)

---

### 1️⃣ Verify volume / bind mount syntax

```bash
docker run -v /host/data:/app/data my-app
```

* **Why**: Wrong order or path = empty directory
* **Key**: `host_path:container_path`

---

### 2️⃣ Check host path exists

```bash
ls -ld /host/data
```

* **Why**: Docker creates an **empty directory** if host path doesn’t exist
* **Result**: Files appear “missing” inside container

---

### 3️⃣ Check container path overwrite (VERY common)

```dockerfile
VOLUME /app/data
```

* **Issue**: `VOLUME` in Dockerfile overrides bind mount
* **Fix**: Remove `VOLUME` or mount to a different path

---

### 4️⃣ Check permissions / ownership

```bash
ls -l /host/data
docker exec -it <container> ls -l /app/data
```

* **Why**: Container user may not have read permissions
* **Fix**:

```bash
chmod -R 755 /host/data
```

or run container with correct user:

```bash
docker run --user 1000:1000 ...
```

---

### 5️⃣ SELinux blocking access (RHEL/CentOS)

```bash
getenforce
```

* **Issue**: SELinux denies mount access
* **Fix**:

```bash
docker run -v /host/data:/app/data:Z my-app
```

---

### 6️⃣ Wrong mount type (named volume vs bind mount)

```bash
docker volume ls
docker inspect <container>
```

* **Why**: Named volume ≠ host directory
* **Real-world**: Expecting host files but volume is empty

---

### 7️⃣ Relative paths in `docker run`

```bash
docker run -v ./data:/app/data my-app
```

* **Why**: Path resolved relative to current directory
* **Fix**: Use absolute paths

---

### 8️⃣ Docker Compose overrides

```yaml
volumes:
  - ./data:/app/data
```

* **Check**: Correct service, correct path, no duplicate mounts

---

### 9️⃣ Files created after container start

* **Why**: App writes elsewhere or different path
* **Check**: App config and working directory

---

### ✅ Most common root causes (interview-ready)

* Host path doesn’t exist
* Wrong mount path or order
* Permission / SELinux issues
* `VOLUME` instruction overriding mount
* Named volume used instead of bind mount

---

### 💡 In short (2–3 lines)

Volume mounts fail when the **host path is wrong, missing, or blocked by permissions/SELinux**, or when a Dockerfile `VOLUME` overrides it. Always verify mount paths, permissions, and mount type with `docker inspect`.

----
## Q212: Docker Compose up fails with **“network not found”**. How do you fix this?

### 🔍 Step-by-step fixes (common → rare)

---

### 1️⃣ Check networks defined in `docker-compose.yml`

```yaml
networks:
  app-net:
    driver: bridge
```

* **Why**: Service may reference a network that isn’t defined
* **Fix**: Define it or correct the name

---

### 2️⃣ Verify service network references

```yaml
services:
  web:
    networks:
      - app-net
```

* **Common mistake**: Typo or mismatch in network name

---

### 3️⃣ List existing Docker networks

```bash
docker network ls
```

* **Why**: Compose may expect a network that was deleted manually

---

### 4️⃣ Recreate networks cleanly (most common fix)

```bash
docker compose down
docker compose up -d
```

* **Why**: Recreates missing or corrupted networks

---

### 5️⃣ External network misconfiguration

```yaml
networks:
  shared-net:
    external: true
```

* **Issue**: Network must already exist
* **Fix**:

```bash
docker network create shared-net
```

---

### 6️⃣ Project name mismatch

```bash
docker compose -p myapp up
```

* **Why**: Networks are created as `<project>_<network>`
* **Issue**: Running with different project names

---

### 7️⃣ Leftover containers from old Compose versions

```bash
docker ps -a
docker rm -f <container>
```

* **Why**: Old containers reference deleted networks

---

### 8️⃣ Docker daemon/network issues

```bash
systemctl restart docker
```

* **Why**: Clears stale network state

---

### 9️⃣ Check Docker Compose version

```bash
docker compose version
```

* **Why**: Old Compose bugs with network cleanup

---

### ✅ Common root causes (interview-ready)

* Network referenced but not defined
* External network missing
* Compose project name mismatch
* Stale containers or deleted networks

---

### 💡 In short (2–3 lines)

The error occurs when Compose references a **missing or deleted network**. Define the network correctly, create external networks beforehand, or recreate everything using `docker compose down && up`.

---- 
## Q213: Containers cannot resolve DNS names. What would you investigate?

### 🔍 Step-by-step investigation (Docker DNS → Host → Network)

---

### 1️⃣ Verify DNS inside the container

```bash
docker exec -it <container> cat /etc/resolv.conf
```

* **What**: Shows DNS servers used by container
* **Why**: Usually points to Docker DNS (`127.0.0.11`)

---

### 2️⃣ Test DNS resolution from container

```bash
docker exec -it <container> nslookup google.com
# or
docker exec -it <container> dig google.com
```

* **Why**: Confirms DNS failure vs app issue

---

### 3️⃣ Check Docker DNS service

```bash
docker info | grep DNS
```

* **Why**: Confirms Docker is injecting DNS correctly

---

### 4️⃣ Verify host DNS works

```bash
nslookup google.com
```

* **Why**: Docker forwards queries to host resolvers

---

### 5️⃣ Check `/etc/resolv.conf` on host

```bash
cat /etc/resolv.conf
```

* **Issues**:

  * Broken corporate DNS
  * VPN overwriting DNS
  * Too many `nameserver` entries

---

### 6️⃣ Check custom DNS configuration

```bash
docker run --dns 8.8.8.8 busybox nslookup google.com
```

* **Why**: Isolate Docker DNS vs upstream DNS issue

---

### 7️⃣ Docker network type matters

* **Default bridge**: limited DNS
* **User-defined bridge**: built-in DNS resolution

```bash
docker network create app-net
```

---

### 8️⃣ Check firewall / iptables

```bash
iptables -L -n
```

* **Why**: DNS (UDP/TCP 53) may be blocked

---

### 9️⃣ MTU / VPN issues

```bash
ip link
```

* **Why**: VPNs often break DNS packets

---

### 🔟 If using Docker Compose

* Use **service names** for DNS
* Ensure all services are on same network

---

### ✅ Common root causes (interview-ready)

* Broken host DNS
* VPN or corporate proxy
* Using default bridge network
* Firewall blocking port 53
* Misconfigured custom DNS

---

### 💡 In short (2–3 lines)

Containers rely on **Docker DNS (127.0.0.11)** which forwards to the host resolver. Check DNS inside the container, verify host DNS, ensure a **user-defined network**, and rule out VPN/firewall issues.

---
## Q214: A container is in **“Created”** state but won’t start. How do you debug?

### 🔍 Step-by-step debugging (Created → Failed to start)

---

### 1️⃣ Inspect container state and error

```bash
docker inspect <container>
```

Focus on:

* `State.Error`
* `State.ExitCode`
* `State.Status`

👉 **Why**: “Created” means Docker set up the container but failed **before** the process started.

---

### 2️⃣ Try starting manually and capture error

```bash
docker start <container>
```

* **Why**: Immediate CLI error often shows root cause (permission, mount, exec issue)

---

### 3️⃣ Check Docker daemon logs

```bash
journalctl -u docker -n 100
```

* **Why**: Startup failures (cgroups, mounts, seccomp, storage) are logged here
* **Very common in prod**

---

### 4️⃣ Verify ENTRYPOINT / CMD

```bash
docker inspect <container> | grep -A5 -i entrypoint
```

Common issues:

* Binary doesn’t exist
* Wrong path
* Script not executable

Fix example:

```dockerfile
RUN chmod +x start.sh
ENTRYPOINT ["./start.sh"]
```

---

### 5️⃣ Check volume mount errors (VERY common)

```bash
docker inspect <container> | grep Mounts -A10
```

* **Issues**:

  * Host path doesn’t exist
  * Permission denied
  * SELinux blocking

Fix (SELinux):

```bash
-v /data:/app/data:Z
```

---

### 6️⃣ Check image architecture mismatch

```bash
docker inspect <image> | grep Architecture
uname -m
```

* **Why**: `arm64` image on `amd64` host won’t start
* **Seen on**: Apple Silicon vs Linux servers

---

### 7️⃣ Check resource constraints

```bash
docker inspect <container> | grep -i memory
```

* **Why**: Extremely low memory or invalid limits prevent start

---

### 8️⃣ Validate user / permission issues

```bash
docker inspect <container> | grep -i user
```

* **Why**: Non-root user without permission to run entrypoint
* **Fix**: Adjust ownership or run as root temporarily

---

### 9️⃣ Run container interactively (best isolation)

```bash
docker run -it --entrypoint /bin/sh <image>
```

* **Why**: Confirms image itself is runnable
* **If this fails** → image is broken

---

### 🔟 Check seccomp / AppArmor (hardened hosts)

```bash
docker info | grep -i security
```

* **Why**: Security profile blocking syscalls
* **Test**:

```bash
docker run --security-opt seccomp=unconfined ...
```

---

### ✅ Common root causes (interview-ready)

* Invalid ENTRYPOINT / CMD
* Volume mount failure
* Permission or SELinux issue
* Architecture mismatch
* Corrupted image
* Security profile blocking startup

---

### 💡 In short (2–3 lines)

A container stuck in **Created** usually fails **before process execution**. Check `docker inspect`, daemon logs, ENTRYPOINT, volume mounts, permissions, and image architecture. Most issues are config or mount related.

---
## Q215: Docker `ps` shows different container IDs than expected. Why?

### 🔍 Common reasons (interview-focused)

---

### 1️⃣ Containers were recreated

```bash
docker ps
docker ps -a
```

* **Why**: Restarting with `docker run`, `docker compose up`, or CI redeploy
* **Result**: New container → new ID

---

### 2️⃣ Docker Compose recreates containers

```bash
docker compose up -d
```

* **Why**:

  * Image updated
  * Config changed
  * Volume/network change
* **Key**: Compose destroys & creates new containers

---

### 3️⃣ Container restart vs recreate confusion

```bash
docker restart <container>
```

* **Restart** → same ID
* **Recreate** → new ID

---

### 4️⃣ Containers auto-removed

```bash
docker run --rm alpine echo hello
```

* **Why**: Container removed after exit
* **Next run**: New ID

---

### 5️⃣ Multiple containers from same image

```bash
docker run nginx
docker run nginx
```

* **Why**: Each run creates a new container
* **IDs are always unique**

---

### 6️⃣ CI/CD pipelines redeploy containers

* Blue/green or rolling deployments
* Old container stopped, new one started
* **Expected behavior**

---

### 7️⃣ You’re comparing short vs full IDs

```bash
docker ps
docker inspect <container>
```

* **Why**: `docker ps` shows **short ID**
* **Full ID** is much longer (same container)

---

### 8️⃣ Kubernetes / Swarm managed containers

* Orchestrator constantly recreates containers
* Manual tracking by ID is unreliable

---

### ✅ Key takeaway (interview-ready)

* **Container IDs are ephemeral**
* **Recreation = new ID**
* **Names, labels, and services** are stable identifiers

---

### 💡 In short (2–3 lines)

Docker assigns a **new container ID every time a container is created**. Tools like Docker Compose, CI/CD, or orchestrators often **recreate containers**, so IDs change—this is normal. Use **names or labels**, not IDs, for tracking.

----
## Q216: Container logs are not appearing with `docker logs`. What could be wrong?

### 🔍 Common causes & checks (practical order)

---

### 1️⃣ Application is not logging to stdout/stderr (MOST common)

```bash
docker exec -it <container> ls /var/log
```

* **Why**: `docker logs` only shows **stdout/stderr**
* **Issue**: App writes to files instead
* **Fix**: Configure app to log to console

Example:

```bash
app --log-level=info --log-output=stdout
```

---

### 2️⃣ Container uses a non-default logging driver

```bash
docker inspect <container> | grep LogConfig -A5
```

* **Why**: Drivers like `syslog`, `fluentd`, `awslogs` don’t show logs via `docker logs`
* **Fix**: Check logs in the external system

---

### 3️⃣ Container exited immediately

```bash
docker ps -a
```

* **Why**: No output was ever written
* **Check exit code**:

```bash
docker inspect <container> | grep ExitCode
```

---

### 4️⃣ Logs were rotated or truncated

```bash
docker inspect <container> | grep max-size -A3
```

* **Why**: Log rotation removes old logs
* **Seen in**: Long-running containers

---

### 5️⃣ Logging disabled

```bash
docker inspect <container> | grep "LogConfig"
```

* **Issue**:

```json
"log-driver": "none"
```

* **Result**: No logs captured at all

---

### 6️⃣ Entry point swallows output

```bash
ENTRYPOINT ["sh", "-c", "start.sh"]
```

* **Why**: Script redirects output to file
* **Check**:

```bash
cat start.sh
```

---

### 7️⃣ Permission or disk issues

```bash
df -h /var/lib/docker
```

* **Why**: Disk full → logging fails silently

---

### 8️⃣ Container running in detached TTY mode

```bash
docker run -dit my-app
```

* **Why**: Some apps behave differently with TTY
* **Test**:

```bash
docker run -d my-app
```

---

### 9️⃣ Kubernetes / orchestrator case (bonus)

```bash
kubectl logs <pod>
kubectl logs <pod> --previous
```

* **Why**: Logs handled by kubelet, not Docker CLI

---

### ✅ Most common root causes (interview-ready)

* App logs to files instead of stdout
* Non-default logging driver
* Logging disabled (`none`)
* Log rotation or truncation
* Container never produced output

---

### 💡 In short (2–3 lines)

`docker logs` only shows **stdout/stderr**. If logs are missing, the app is likely logging to files, using a different logging driver, or logging is disabled/rotated. Always verify the logging driver and app logging config.

---
## Q217: A health check is failing but the application seems to work. How do you debug?

### 🔍 Step-by-step debugging (Docker & real-world)

---

### 1️⃣ Inspect health check definition

```bash
docker inspect <container> | grep -A10 -i health
```

* **Check**:

  * Command
  * Interval / timeout
  * Retries
* **Why**: Wrong command or path is the #1 cause

---

### 2️⃣ Run the health check command manually

```bash
docker exec -it <container> <healthcheck-command>
```

* **Why**: Confirms whether the check itself is broken
* **Common issue**: Missing curl/wget inside image

---

### 3️⃣ Check exit codes (health checks rely on them)

```bash
echo $?
```

* **Key**:

  * `0` → healthy
  * `!=0` → unhealthy
* **Issue**: App returns `200` but script exits non-zero

---

### 4️⃣ Verify endpoint & protocol

```bash
curl -v http://localhost:8080/health
```

* **Why**: Health check hitting wrong port, path, or protocol (HTTP vs HTTPS)

---

### 5️⃣ Check timing issues (startup vs readiness)

```yaml
healthcheck:
  start_period: 30s
```

* **Why**: App works after startup, but health check runs too early
* **Fix**: Increase `start_period` or `retries`

---

### 6️⃣ Resource constraints affect health checks

```bash
docker stats
```

* **Why**: CPU starvation or GC pauses cause timeouts

---

### 7️⃣ DNS / dependency checks in health command

```bash
curl http://db:5432
```

* **Issue**: Health check depends on external service
* **Best practice**: Check **app process**, not downstream dependencies

---

### 8️⃣ User / permission issues

```bash
docker exec -it <container> id
```

* **Why**: Health check runs as container user
* **Issue**: No permission to run command or access socket

---

### 9️⃣ TTY / shell issues

```dockerfile
HEALTHCHECK CMD curl -f http://localhost || exit 1
```

* **Issue**: `sh` vs `bash`, missing shell
* **Fix**:

```dockerfile
HEALTHCHECK CMD ["CMD-SHELL", "curl -f http://localhost || exit 1"]
```

---

### 🔟 If on Kubernetes (important interview angle)

* Liveness vs Readiness confusion
* App serves traffic but **readiness probe** failing

```bash
kubectl describe pod <pod>
```

---

### ✅ Common root causes (interview-ready)

* Incorrect health check command/path
* Missing binaries (curl)
* Timing/startup mismatch
* Dependency-based health checks
* Exit code handling issues

---

### 💡 In short (2–3 lines)

If the app works but health check fails, the **check itself is wrong**. Inspect and manually run the health command, verify exit codes, ports, and timing, and avoid coupling health checks to external dependencies.

----
## Q218: Docker build fails with **“unable to prepare context”**. What’s the issue?

### 🔍 What this error really means

Docker cannot **read or send the build context** (the files you’re building from) to the daemon.

---

### 1️⃣ Invalid or wrong build path (MOST common)

```bash
docker build .
```

* **Issue**: Running from the wrong directory
* **Fix**:

```bash
cd project-root
ls Dockerfile
```

Or explicitly:

```bash
docker build -f Dockerfile .
```

---

### 2️⃣ Permission denied in build context

```bash
ls -l
```

* **Why**: Docker tries to read **all files** in the context
* **Common**: Root-owned files, restricted dirs

Fix:

```bash
chmod -R o+r .
```

---

### 3️⃣ Broken symlinks inside context

```bash
find . -type l ! -exec test -e {} \; -print
```

* **Why**: Docker fails when resolving dangling symlinks
* **Seen in**: Monorepos, vendor dirs

---

### 4️⃣ Extremely large or invalid context

```text
Sending build context to Docker daemon  10GB
```

* **Why**: Timeout or memory failure
* **Fix**: `.dockerignore`

```dockerignore
.git
node_modules
target
```

---

### 5️⃣ File system or disk issues

```bash
df -h
df -i
```

* **Why**: Disk full or inode exhaustion prevents context creation

---

### 6️⃣ Docker daemon or socket issues

```bash
systemctl status docker
ls -l /var/run/docker.sock
```

* **Why**: Daemon not reachable or permission denied

---

### 7️⃣ Invalid Dockerfile path

```bash
docker build -f ./docker/Dockerfile .
```

* **Why**: File path incorrect or unreadable

---

### 8️⃣ Special characters / filesystem incompatibility

* **Seen on**: NFS, CIFS, WSL, mounted volumes
* **Fix**: Copy project to local disk and retry

---

### 9️⃣ CI/CD workspace issues

* Workspace cleaned mid-build
* Read-only filesystem
* Volume mount misconfigured

---

### ✅ Common root causes (interview-ready)

* Wrong build directory
* Permission issues in context
* Broken symlinks
* Huge or polluted build context
* Disk / filesystem problems

---

### 💡 In short (2–3 lines)

“Unable to prepare context” means Docker **can’t read the build directory**. Check you’re in the right path, fix permissions or broken symlinks, reduce context with `.dockerignore`, and ensure disk/daemon health.

----
## Q219: A multi-stage build is not reducing image size as expected. What would you check?

### 🔍 Key checks (most common → advanced)

---

### 1️⃣ Verify the final stage base image

```dockerfile
FROM node:20 AS build
# build steps

FROM node:20
```

* **Issue**: Final stage uses same heavy base image
* **Fix**:

```dockerfile
FROM node:20-alpine
# or
FROM gcr.io/distroless/nodejs
```

---

### 2️⃣ Ensure artifacts are copied **only** from build stage

```dockerfile
COPY . .
```

❌ **Wrong in final stage**

✅ **Correct**:

```dockerfile
COPY --from=build /app/dist /app/dist
```

* **Why**: Copying from context brings back source, node_modules, secrets

---

### 3️⃣ Check build tools leaking into final image

```dockerfile
RUN apt install gcc make
```

* **Issue**: Tools installed in final stage
* **Fix**: Install tools **only** in build stage

---

### 4️⃣ Validate stage naming and references

```dockerfile
FROM golang:1.22 AS builder
FROM alpine
COPY --from=builder /app/app /app/app
```

* **Issue**: Wrong stage name → copies from context instead

---

### 5️⃣ Confirm final image size

```bash
docker images
docker history <image>
```

* **Why**: Shows which layers are large
* **Real-world**: Debug unexpected bloat

---

### 6️⃣ Avoid `ADD` extracting large archives

```dockerfile
ADD app.tar.gz /app
```

* **Issue**: Auto-extraction creates big layers
* **Fix**: Use `COPY` and clean up

---

### 7️⃣ Clean package manager caches

```dockerfile
RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*
```

* **Why**: Cache files remain in layers

---

### 8️⃣ `.dockerignore` still matters

```dockerignore
.git
node_modules
target
```

* **Why**: Large context copied accidentally

---

### 9️⃣ Static vs dynamic binary mismatch

* Go / Rust builds should copy **single binary**
* If not static → pulls runtime libs

---

### 🔟 Distroless debugging misconception

* Distroless images are small
* But missing shell/tools makes size *appear* misleading during debugging

---

### ✅ Common root causes (interview-ready)

* Heavy final base image
* Copying entire context in final stage
* Build tools installed in runtime image
* Wrong stage referenced
* Package caches not cleaned

---

### 💡 In short (2–3 lines)

Multi-stage builds reduce size only if the **final stage is minimal** and copies **only runtime artifacts**. Check the final base image, `COPY --from`, and ensure no build tools or source files leak into the runtime image.

----
## Q220: Environment variables are not being passed to the container. How do you fix this?

### 🔍 Step-by-step checks (most common first)

---

### 1️⃣ Verify env vars inside the container

```bash
docker exec -it <container> env | grep MY_VAR
```

* **Why**: Confirms whether Docker injected the variable at all

---

### 2️⃣ Check `docker run -e` syntax

```bash
docker run -e MY_VAR=value my-app
```

Common mistakes:

* Missing `-e`
* Typo in variable name
* Quoting issues

---

### 3️⃣ Verify `--env-file` format

```bash
MY_VAR=value
DB_HOST=localhost
```

* ❌ No spaces
* ❌ No quotes unless needed

Run:

```bash
docker run --env-file .env my-app
```

---

### 4️⃣ Docker Compose env precedence (VERY common)

```yaml
environment:
  - MY_VAR=value
env_file:
  - .env
```

**Precedence order**:

1. `docker compose run -e`
2. `environment`
3. `env_file`
4. Dockerfile `ENV`

* **Issue**: Overwritten or shadowed values

---

### 5️⃣ Dockerfile `ENV` overriding runtime values

```dockerfile
ENV MY_VAR=default
```

* **Why**: Hardcoded default hides runtime expectation
* **Fix**: Remove or treat as fallback only

---

### 6️⃣ Variable expansion confusion

```yaml
environment:
  DB_HOST: ${DB_HOST}
```

* **Why**: Host env var not set → empty value
* **Fix**:

```bash
export DB_HOST=db
docker compose up
```

---

### 7️⃣ Shell vs exec form ENTRYPOINT

```dockerfile
ENTRYPOINT ["echo", "$MY_VAR"]   # ❌
ENTRYPOINT ["sh", "-c", "echo $MY_VAR"]  # ✅
```

* **Why**: Exec form doesn’t expand env vars

---

### 8️⃣ App-specific config overriding env vars

* App reads config file instead of env
* Wrong env var name expected by app
* Case sensitivity issues

---

### 9️⃣ Kubernetes / orchestrator case (bonus)

```bash
kubectl describe pod <pod>
```

* Check:

  * ConfigMap / Secret mounted?
  * `envFrom` applied?

---

### ✅ Common root causes (interview-ready)

* Wrong `-e` / `env_file` usage
* Env precedence confusion in Compose
* Shell expansion misunderstanding
* App not reading env vars
* Hardcoded Dockerfile ENV

---

### 💡 In short (2–3 lines)

Verify env vars inside the container, then check **`-e` / `.env` / Compose precedence**. Most issues come from **overrides, missing host vars, or shell vs exec form confusion**.

---
## Q221: A container keeps restarting in a loop. What would you investigate?

### 🔍 Step-by-step investigation (CrashLoop-style)

---

### 1️⃣ Check restart count & exit code

```bash
docker ps
docker inspect <container> | grep -i ExitCode
```

* **Why**: Exit code explains *why* it restarts
* **Examples**:

  * `1` → app crash
  * `137` → OOM kill
  * `0` → app exits normally (but restart policy restarts it)

---

### 2️⃣ Review container logs (current & previous)

```bash
docker logs <container>
```

* **Why**: Startup failures, config errors, missing env vars

---

### 3️⃣ Verify restart policy

```bash
docker inspect <container> | grep -i RestartPolicy
```

* **Issue**:

  * `--restart=always` + app exits immediately
* **Fix**: Ensure app is long-running

---

### 4️⃣ Check OOM kills (VERY common)

```bash
docker inspect <container> | grep OOMKilled
docker stats
```

* **Why**: Memory limit too low or leak

---

### 5️⃣ Validate ENTRYPOINT / CMD

```bash
docker inspect <container> | grep -A5 -i entrypoint
```

* **Issue**: Script exits instead of blocking
* **Fix**: Use foreground process

---

### 6️⃣ Check health check failures

```bash
docker inspect <container> | grep -i Health -A10
```

* **Why**: Unhealthy containers get restarted
* **Fix**: Adjust health check command or timing

---

### 7️⃣ Confirm dependencies are reachable

* DB, Redis, APIs
* DNS / network issues cause startup crash

Test:

```bash
docker exec -it <container> ping db
```

---

### 8️⃣ Check permissions & volume mounts

* Missing config files
* Permission denied on mounted paths

---

### 9️⃣ Test interactive run (best isolation)

```bash
docker run -it --entrypoint /bin/sh <image>
```

* **Why**: Confirms if image itself is broken

---

### 🔟 Kubernetes angle (interview bonus)

```bash
kubectl describe pod <pod>
kubectl logs <pod> --previous
```

* **Why**: CrashLoopBackOff details

---

### ✅ Common root causes (interview-ready)

* Application crash on startup
* OOMKilled
* Wrong CMD / ENTRYPOINT
* Failed health checks
* Missing env vars or configs
* Restart policy misuse

---

### 💡 In short (2–3 lines)

A restart loop means the **main process exits repeatedly**. Check exit codes, logs, OOM kills, restart policy, and startup dependencies. Most loops are caused by **app crashes or misconfigured ENTRYPOINT/health checks**.

---
## Q222: Docker daemon is consuming high CPU. What could be causing this?

### 🔍 Common causes & how to verify (production-focused)

---

### 1️⃣ Too many containers / frequent restarts

```bash
docker ps -a
```

* **Why**: Crash loops force the daemon to constantly manage containers
* **Seen in**: Bad deploys, broken health checks

---

### 2️⃣ Heavy logging activity (VERY common)

```bash
docker inspect <container> | grep LogConfig -A5
```

* **Why**: High log volume + `json-file` logging = CPU spike
* **Fix**:

  * Reduce log verbosity
  * Enable log rotation

```json
{
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

---

### 3️⃣ Build or pull operations running

```bash
docker ps
docker build .
docker pull <image>
```

* **Why**: Image builds, pulls, and layer extraction are CPU-heavy
* **Real-world**: CI agents

---

### 4️⃣ Docker events flood

```bash
docker events
```

* **Why**: Orchestrators constantly creating/deleting containers

---

### 5️⃣ Corrupted or overloaded storage driver

```bash
docker info | grep -i Storage
```

* **Why**: `overlay2` issues cause retries and CPU churn
* **Fix**: Cleanup `/var/lib/docker`

---

### 6️⃣ Disk I/O wait masquerading as CPU

```bash
iostat -xz 1
```

* **Why**: Slow disk makes Docker spin
* **Seen in**: EBS gp2 burst exhaustion

---

### 7️⃣ Network / DNS issues

* Docker retries network operations
* Registry timeouts cause busy loops

---

### 8️⃣ Docker bugs or version mismatch

```bash
docker version
```

* **Why**: Known daemon bugs in specific versions
* **Fix**: Upgrade or downgrade

---

### 9️⃣ Container stats polling

```bash
docker stats
```

* **Why**: Constant stats collection (monitoring agents)

---

### 🔟 Kubernetes / Swarm workloads

* Kubelet talks to Docker frequently
* Misconfigured probes increase daemon load

---

### ✅ Most common root causes (interview-ready)

* Excessive logging
* Crash loops / health check failures
* Heavy builds or pulls
* Storage driver or disk I/O issues
* Orchestrator churn

---

### 💡 In short (2–3 lines)

High Docker daemon CPU is usually caused by **crash loops, excessive logging, heavy builds/pulls, or storage I/O issues**. Check container restarts, logging config, disk health, and Docker version.

---## Q223: Cannot remove a container – **“device or resource busy”**. How do you resolve this?

### 🔍 Why this happens

Docker can’t remove the container because **something is still using it** (process, mount, volume, or filesystem lock).

---

### 1️⃣ Ensure the container is stopped

```bash
docker ps
docker stop <container>
```

* **Why**: Running containers cannot be removed

Force stop if needed:

```bash
docker stop -t 0 <container>
```

---

### 2️⃣ Force remove the container

```bash
docker rm -f <container>
```

* **What**: Kills container + removes it
* **Why**: Clears most stuck containers

---

### 3️⃣ Check for active volume mounts (VERY common)

```bash
docker inspect <container> | grep Mounts -A10
```

* **Why**: Host process may be using the mounted directory

Find open files:

```bash
lsof +D /path/on/host
```

---

### 4️⃣ Unmount busy volumes (host-side)

```bash
mount | grep docker
```

If needed:

```bash
umount /path/on/host
```

* **Seen in**: NFS, EFS, bind mounts

---

### 5️⃣ Check for zombie / stuck processes

```bash
ps aux | grep docker
```

* **Why**: Container process still alive on host

Kill manually:

```bash
kill -9 <pid>
```

---

### 6️⃣ Restart Docker daemon (MOST reliable fix)

```bash
systemctl restart docker
```

* **Why**: Clears stale mounts and locks
* **Common in prod incidents**

---

### 7️⃣ Check for container using the root filesystem

```bash
df -h
```

* **Why**: Overlay filesystem still mounted

---

### 8️⃣ If using Kubernetes / orchestrator

* Orchestrator may immediately recreate container
* Stop workload first:

```bash
kubectl scale deploy app --replicas=0
```

---

### 9️⃣ Last resort (dangerous – interview mention only)

```bash
rm -rf /var/lib/docker/containers/<container-id>
```

⚠️ **Only when Docker is stopped**

---

### ✅ Common root causes (interview-ready)

* Active bind mount or volume
* Zombie container process
* NFS/EFS mount still in use
* Orchestrator recreating container
* Docker daemon stuck state

---

### 💡 In short (2–3 lines)

This error means **something is still using the container’s filesystem**. Stop and force-remove the container, check volume mounts, and restart the Docker daemon if needed.

---
## Q224: Docker `network inspect` shows **no containers attached** despite containers running. Why?

### 🔍 Common reasons (most → least common)

---

### 1️⃣ Containers are on a **different network**

```bash
docker ps
docker inspect <container> | grep -i NetworkMode -A10
```

* **Why**: Containers can run but be attached to another network
* **Fix**: Connect them to the correct network

```bash
docker network connect my-net <container>
```

---

### 2️⃣ Inspecting the wrong network name

```bash
docker network ls
```

* **Why**: Docker Compose auto-prefixes networks
  (`<project>_default`)
* **Very common in interviews**

---

### 3️⃣ Containers use `--network host`

```bash
docker inspect <container> | grep NetworkMode
```

* **Why**: Host network containers **don’t appear** under bridge networks
* **Expected behavior**

---

### 4️⃣ Containers attached to **multiple networks**

```bash
docker inspect <container> | grep Networks -A20
```

* **Why**: Inspecting only one network won’t show containers attached elsewhere

---

### 5️⃣ Containers started **before** the network existed

* Network recreated later
* Running containers still attached to old network

Fix:

```bash
docker network disconnect my-net <container>
docker network connect my-net <container>
```

---

### 6️⃣ Docker Compose project mismatch

```bash
docker compose -p myapp up
```

* **Why**: Different project name → different network
* Containers look “missing”

---

### 7️⃣ Swarm / overlay networks

* `docker network inspect` behaves differently
* Containers may be scheduled on other nodes

---

### 8️⃣ Stale Docker daemon state

```bash
systemctl restart docker
```

* **Why**: Clears stale network metadata

---

### ✅ Key takeaway (interview-ready)

* Containers appear in `network inspect` **only if they are attached**
* **Host-networked containers never appear**
* Compose networks are **auto-named**

---

### 💡 In short (2–3 lines)

You’re likely inspecting the **wrong network** or the containers are using **host mode or a different network**. Check the container’s `NetworkMode` and Compose-generated network names.

---
## Q225: Container file permissions are incorrect causing application failures. How do you fix this?

### 🔍 Step-by-step fixes (practical & production-safe)

---

### 1️⃣ Identify which file/path is failing

```bash
docker logs <container>
docker exec -it <container> ls -l /app
```

* **Why**: Confirms permission denied (`EACCES`) and target path

---

### 2️⃣ Check container user

```bash
docker inspect <container> | grep -i User
```

* **Why**: Non-root user may not own files
* **Common in**: Distroless / security-hardened images

---

### 3️⃣ Fix ownership during image build (BEST PRACTICE)

```dockerfile
RUN chown -R appuser:appuser /app
USER appuser
```

* **Why**: Permissions fixed at build time, immutable & safe

---

### 4️⃣ Avoid permission fixes at runtime (anti-pattern)

```bash
chmod -R 777 /app   # ❌
```

* **Why**: Security risk, hides real issue

---

### 5️⃣ Check bind mount permissions (VERY common)

```bash
ls -ld /host/data
```

* **Why**: Host UID/GID mismatch
* **Fix options**:

```bash
docker run --user 1000:1000 ...
```

or

```bash
chown -R 1000:1000 /host/data
```

---

### 6️⃣ SELinux context issues (RHEL / Amazon Linux)

```bash
getenforce
```

* **Fix**:

```bash
-v /host/data:/app/data:Z
```

---

### 7️⃣ Kubernetes volume permissions (bonus)

```yaml
securityContext:
  runAsUser: 1000
  fsGroup: 1000
```

* **Why**: Ensures mounted volumes are writable

---

### 8️⃣ ENTRYPOINT scripts not executable

```bash
ls -l entrypoint.sh
```

* **Fix**:

```dockerfile
RUN chmod +x entrypoint.sh
```

---

### 9️⃣ Read-only filesystem enabled

```bash
docker inspect <container> | grep ReadonlyRootfs
```

* **Fix**: Write only to allowed paths (`/tmp`, mounted volumes)

---

### ✅ Common root causes (interview-ready)

* Wrong file ownership
* UID/GID mismatch with bind mounts
* SELinux blocking access
* Non-executable entrypoint scripts
* Read-only root filesystem

---

### 💡 In short (2–3 lines)

Permission issues come from **wrong ownership or UID/GID mismatch**, especially with bind mounts. Fix permissions **at build time**, run containers with the correct user, and handle SELinux or read-only filesystems properly.

---
## Q226: Docker build fails with **“COPY failed: stat”**. What path issue exists?

### 🔍 What this error means

Docker tried to `COPY` a file or directory that **does not exist in the build context**.

---

### 1️⃣ Source path is wrong or missing (MOST common)

```dockerfile
COPY app.jar /app/app.jar
```

* **Issue**: `app.jar` not present in build context
* **Fix**:

```bash
ls app.jar
```

---

### 2️⃣ File exists locally but excluded by `.dockerignore`

```dockerignore
*.jar
target/
```

* **Why**: Docker never sees ignored files
* **Fix**: Update `.dockerignore` or move file

---

### 3️⃣ Wrong build context directory

```bash
docker build -f Dockerfile .
```

* **Issue**: Dockerfile is in subdir, but context is wrong
* **Fix**:

```bash
docker build -f docker/Dockerfile .
```

or

```bash
docker build docker/
```

---

### 4️⃣ Relative paths misunderstood

```dockerfile
COPY ../config.yml /app/
```

* ❌ **Invalid**: Docker cannot access files outside context
* **Fix**: Move files into context

---

### 5️⃣ Case sensitivity mismatch (Linux)

```dockerfile
COPY App.jar /app/
```

* **Issue**: Actual file is `app.jar`
* **Fix**: Match exact case

---

### 6️⃣ Broken symlinks in source path

```bash
ls -l
```

* **Why**: Docker can’t resolve dangling symlinks
* **Seen in**: Monorepos

---

### 7️⃣ Permissions blocking file access

```bash
ls -l file
```

* **Why**: Docker daemon can’t read file
* **Fix**:

```bash
chmod o+r file
```

---

### 8️⃣ Multi-stage build wrong stage path

```dockerfile
COPY --from=build /app/dist /app/dist
```

* **Issue**: Path doesn’t exist in build stage
* **Verify**:

```bash
docker run --rm build-image ls /app
```

---

### ✅ Common root causes (interview-ready)

* File not in build context
* Ignored by `.dockerignore`
* Wrong relative path or case mismatch
* Attempting to copy outside context
* Wrong path in multi-stage build

---

### 💡 In short (2–3 lines)

`COPY failed: stat` means Docker **cannot find the source path in the build context**. Check file existence, `.dockerignore`, correct build context, and exact path/case—especially in multi-stage builds.

---
## Q227: A container cannot write to a mounted volume. What permission issue exists?

### 🔍 Root cause in one line

**UID/GID mismatch or filesystem security (SELinux / read-only mount)** prevents the container user from writing to the host-mounted path.

---

### 1️⃣ Check container user vs volume ownership

```bash
docker inspect <container> | grep -i User
ls -ld /host/data
```

* **Why**: Container runs as non-root (e.g., UID 1000) but host path owned by root
* **Result**: `Permission denied`

---

### 2️⃣ Verify permissions inside container

```bash
docker exec -it <container> ls -ld /app/data
```

* **Why**: Confirms write bit is missing for container user/group

---

### 3️⃣ Fix ownership on host (BEST & common)

```bash
chown -R 1000:1000 /host/data
```

* **Why**: Matches container user UID/GID
* **Production-safe** if path dedicated to container

---

### 4️⃣ Run container with correct UID/GID

```bash
docker run --user 1000:1000 -v /host/data:/app/data my-app
```

* **Why**: Aligns container process with host ownership

---

### 5️⃣ SELinux blocking writes (RHEL / Amazon Linux)

```bash
getenforce
```

* **Fix**:

```bash
docker run -v /host/data:/app/data:Z my-app
```

* **Why**: Applies correct SELinux label

---

### 6️⃣ Volume mounted as read-only (very common)

```bash
docker inspect <container> | grep -i ReadOnly
```

or

```bash
-v /host/data:/app/data:ro   # ❌
```

* **Fix**: Remove `:ro`

---

### 7️⃣ Kubernetes case (bonus)

```yaml
securityContext:
  runAsUser: 1000
  fsGroup: 1000
```

* **Why**: Ensures volume is writable by pod user

---

### 8️⃣ Filesystem type limitations

* NFS / EFS / CIFS mounted `root_squash`
* **Fix**: Use correct UID/GID or disable squash

---

### ✅ Common permission issues (interview-ready)

* UID/GID mismatch
* Read-only mount
* SELinux denial
* Non-root container user
* Network filesystem restrictions

---

### 💡 In short (2–3 lines)

Containers fail to write to volumes due to **UID/GID mismatch or security restrictions**. Fix by aligning ownership, running with the correct user, removing read-only mounts, and handling SELinux or NFS settings properly.

---
## Q228: Docker Compose `depends_on` is not enforcing startup order. How do you handle this?

### 🔍 Why this happens

`depends_on` **only controls container start order**, **not readiness**. A service may start but still not be ready to accept connections.

---

### 1️⃣ Use healthchecks with `depends_on` (Compose v2+)

```yaml
services:
  db:
    image: postgres
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      retries: 5

  app:
    depends_on:
      db:
        condition: service_healthy
```

* **Why**: App waits until DB is healthy, not just started

---

### 2️⃣ Add retry logic in application (BEST PRACTICE)

```bash
until nc -z db 5432; do sleep 2; done
```

* **Why**: Works everywhere (Docker, K8s, cloud)
* **Real-world**: Required even with healthchecks

---

### 3️⃣ Avoid `sleep` hacks (anti-pattern)

```bash
sleep 30   # ❌
```

* **Why**: Flaky and environment-dependent

---

### 4️⃣ Verify Compose version

```bash
docker compose version
```

* **Why**: Older Compose versions ignore `condition`

---

### 5️⃣ Check healthcheck command correctness

```bash
docker inspect <container> | grep -i Health -A10
```

* **Why**: Broken healthcheck = app never waits correctly

---

### 6️⃣ Use proper service DNS names

```bash
DB_HOST=db
```

* **Why**: Hardcoded IPs break startup logic

---

### 7️⃣ Kubernetes comparison (interview angle)

* No `depends_on`
* Use:

  * Readiness probes
  * Init containers
  * Retry logic

---

### ✅ Key takeaway (interview-ready)

* `depends_on` ≠ readiness
* Healthchecks + retries are mandatory

---

### 💡 In short (2–3 lines)

`depends_on` only starts containers in order—it doesn’t wait for readiness. Fix this by **adding healthchecks and using `condition: service_healthy`**, plus **retry logic in the app**.

---
## Q229: Containers are using the wrong DNS servers. How do you configure custom DNS?

### 🔍 Ways to configure custom DNS (Docker → Compose → Daemon)

---

### 1️⃣ Set DNS per container (quick fix)

```bash
docker run --dns 8.8.8.8 --dns 1.1.1.1 my-app
```

* **Why**: Overrides Docker’s default DNS (`127.0.0.11`)
* **Use when**: Testing or single container

---

### 2️⃣ Configure DNS in Docker Compose (recommended)

```yaml
services:
  app:
    image: my-app
    dns:
      - 8.8.8.8
      - 1.1.1.1
```

* **Why**: Consistent across environments

---

### 3️⃣ Set DNS globally via Docker daemon (BEST for prod)

```json
{
  "dns": ["8.8.8.8", "1.1.1.1"]
}
```

File:

```bash
/etc/docker/daemon.json
```

Restart Docker:

```bash
systemctl restart docker
```

---

### 4️⃣ Verify DNS inside container

```bash
docker exec -it <container> cat /etc/resolv.conf
```

* **Expect**: Custom nameservers listed

---

### 5️⃣ Check network-specific DNS overrides

```bash
docker network inspect <network>
```

* **Why**: Some networks define their own DNS config

---

### 6️⃣ Corporate proxy / VPN consideration

* Internal DNS servers required
* Public DNS may break internal name resolution

---

### 7️⃣ Kubernetes comparison (interview bonus)

```yaml
dnsPolicy: None
dnsConfig:
  nameservers:
    - 8.8.8.8
```

---

### ✅ Best practices (interview-ready)

* Prefer **daemon-level DNS** for consistency
* Use **Compose DNS** for app-level control
* Avoid hardcoding public DNS in corporate networks

---

### 💡 In short (2–3 lines)

Override Docker DNS using `--dns`, `docker-compose dns`, or globally via `daemon.json`. Always verify via `/etc/resolv.conf` inside the container and align with corporate/VPC DNS requirements.

---
## Q230: A containerized application is experiencing **network latency**. What would you investigate?

### 🔍 Layer-by-layer investigation (container → host → network)

---

### 1️⃣ Confirm latency is real and where it occurs

```bash
curl -w "@curl-format.txt" -o /dev/null -s http://service
```

* **Why**: Separate DNS, connect, TLS, and server time
* **Real-world**: Often DNS or TLS, not app logic

---

### 2️⃣ Check DNS resolution latency

```bash
docker exec -it <container> time nslookup api.example.com
```

* **Why**: Slow DNS is a top cause
* **Fix**: Use correct DNS servers, avoid VPN DNS

---

### 3️⃣ Test raw network latency

```bash
docker exec -it <container> ping service
```

* **Why**: Confirms baseline RTT

---

### 4️⃣ Compare container vs host latency

```bash
ping service          # host
docker exec -it <container> ping service
```

* **Why**: Identifies Docker bridge / overlay overhead

---

### 5️⃣ Check container network mode

```bash
docker inspect <container> | grep NetworkMode
```

* **Why**:

  * `bridge` → NAT overhead
  * `host` → lowest latency (trade-off: isolation)

---

### 6️⃣ Inspect MTU issues (VERY common with VPNs)

```bash
docker exec -it <container> ping -M do -s 1472 service
```

* **Why**: Fragmentation causes retransmits → latency

---

### 7️⃣ Check host network & NIC saturation

```bash
iftop
ip -s link
```

* **Why**: Packet drops, queue congestion

---

### 8️⃣ Look at container resource throttling

```bash
docker stats
```

* **Why**: CPU throttling delays network processing

---

### 9️⃣ Check proxy / service mesh overhead

* Sidecars (Envoy)
* Corporate proxies
* SSL inspection

---

### 🔟 Cloud-level checks (AWS/Azure)

* Cross-AZ traffic
* Security Group rules
* Load balancer health
* NAT Gateway saturation

---

### ✅ Common root causes (interview-ready)

* Slow DNS
* MTU mismatch
* NAT/bridge overhead
* CPU throttling
* Proxy / VPN interference

---

### 💡 In short (2–3 lines)

Start by isolating **DNS vs network vs app latency**. Compare container and host behavior, check DNS, MTU, network mode, and resource throttling—most container latency issues are environmental, not code-related.

---
## Q231: Docker build is not using **BuildKit** despite being enabled. What configuration is wrong?

### 🔍 What usually goes wrong (most common → advanced)

---

### 1️⃣ BuildKit not enabled in the environment

```bash
docker build .
```

* **Why**: BuildKit is **not always default**
* **Fix**:

```bash
export DOCKER_BUILDKIT=1
docker build .
```

Verify:

```bash
docker version | grep BuildKit
```

---

### 2️⃣ Docker daemon config not enabling BuildKit

```json
{
  "features": { "buildkit": true }
}
```

File:

```bash
/etc/docker/daemon.json
```

Restart:

```bash
systemctl restart docker
```

---

### 3️⃣ Using old Docker / client version

```bash
docker version
```

* **Why**: Older Docker doesn’t support BuildKit fully
* **Fix**: Upgrade Docker Engine & CLI

---

### 4️⃣ CI/CD overrides BuildKit (VERY common)

* Jenkins, GitHub Actions, GitLab often disable it
* Check pipeline config:

```bash
env | grep DOCKER_BUILDKIT
```

---

### 5️⃣ Using `docker-compose build` (version mismatch)

* Older Compose versions **ignore BuildKit**
* **Fix**:

```bash
docker compose build
```

(not `docker-compose`)

---

### 6️⃣ Using remote Docker daemon

* BuildKit must be enabled **on the daemon**, not just client
* Seen in Docker-in-Docker (DinD)

---

### 7️⃣ BuildKit features not used (false assumption)

```dockerfile
RUN --mount=type=cache,target=/root/.cache pip install -r req.txt
```

* **Why**: Without BuildKit, this syntax fails or is ignored
* **Fix**: Ensure BuildKit frontend is active

---

### 8️⃣ Buildx confusion

```bash
docker buildx ls
```

* **Why**: `buildx` uses separate builder instances
* **Fix**:

```bash
docker buildx use default
```

---

### 9️⃣ Docker Desktop vs Linux Engine mismatch

* Desktop enables BuildKit by default
* Linux engine often does not

---

### ✅ Quick verification (interview-ready)

```bash
DOCKER_BUILDKIT=1 docker build --progress=plain .
```

* BuildKit output looks different (parallel steps)

---

### 💡 In short (2–3 lines)

BuildKit isn’t used when it’s **not enabled on the daemon, overridden in CI, or you’re using old Docker/Compose**. Set `DOCKER_BUILDKIT=1`, enable it in `daemon.json`, and use `docker compose` or `buildx` correctly.

---
## Q232: Image push to registry fails with **“denied: access forbidden”**. What would you check?

### 🔍 Step-by-step checks (auth → repo → permissions)

---

### 1️⃣ Verify you are logged in to the correct registry

```bash
docker login
docker info | grep -i Username
```

* **Why**: Login to Docker Hub ≠ ECR/ACR/GCR
* **Common mistake**: Logged into the wrong registry

---

### 2️⃣ Check image name & registry prefix

```bash
docker images
```

Correct formats:

* **Docker Hub**: `username/repo:tag`

* **ECR**: `123456789012.dkr.ecr.us-east-1.amazonaws.com/app:tag`

* **ACR**: `myacr.azurecr.io/app:tag`

* **Why**: Missing prefix pushes to wrong registry

---

### 3️⃣ Confirm repository exists

* Docker Hub / ECR / ACR UI
* Some registries **do not auto-create** repos

Example (ECR):

```bash
aws ecr describe-repositories
aws ecr create-repository --repository-name app
```

---

### 4️⃣ Check push permissions (IAM / RBAC)

* **AWS ECR**:

  * `ecr:PutImage`
  * `ecr:InitiateLayerUpload`
  * `ecr:UploadLayerPart`
  * `ecr:CompleteLayerUpload`
* **ACR**:

  * `AcrPush` role
* **Docker Hub**:

  * Repo write access

---

### 5️⃣ Token expired or wrong credentials

```bash
docker logout
docker login
```

* **Why**: ECR tokens expire every 12 hours

```bash
aws ecr get-login-password ...
```

---

### 6️⃣ Tag mismatch

```bash
docker tag my-app app:latest
```

* **Issue**: Pushing `latest` without tagging image for registry

---

### 7️⃣ Check registry policy / namespace

* Org repo vs personal repo
* Protected repos require explicit permission

---

### 8️⃣ CI/CD secrets misconfigured

* Wrong secret name
* Old token
* Missing permissions

---

### 9️⃣ Network / proxy interference (rare)

* Proxy strips auth headers
* TLS MITM

---

### ✅ Most common root causes (interview-ready)

* Not logged in to correct registry
* Missing repo or wrong image name
* Insufficient push permissions
* Expired registry token
* CI secret misconfiguration

---

### 💡 In short (2–3 lines)

“Access forbidden” means **auth or permission failure**. Verify registry login, correct image tag/registry prefix, repository existence, and push permissions (IAM/RBAC), especially in CI where tokens often expire.

----
## Q233: `docker exec` fails with **“container not running”**. Why can this happen?

### 🔍 Most common reasons (what to check)

---

### 1️⃣ Container is restarting / crash-looping

```bash
docker ps
docker inspect <container> | grep -i RestartCount
```

* **Why**: `docker ps` briefly shows *running*, but it exits before `exec` attaches
* **Fix**: Check logs and exit codes

```bash
docker logs <container>
```

---

### 2️⃣ Main process exited, side process kept container “alive”

```bash
docker inspect <container> | grep -i State -A5
```

* **Why**: PID 1 exited; wrapper process or runtime kept state inconsistent
* **Result**: `exec` rejected

---

### 3️⃣ Container is unhealthy / failing health checks

```bash
docker inspect <container> | grep -i Health -A10
```

* **Why**: Some setups restart/mark containers during unhealthy state
* **Fix**: Debug healthcheck command

---

### 4️⃣ Using the wrong container ID / name (very common)

```bash
docker ps -a
```

* **Why**: Container was recreated; old ID no longer valid
* **Fix**: Use current ID or container name

---

### 5️⃣ Paused container

```bash
docker inspect <container> | grep -i Paused
```

* **Why**: Paused containers reject `exec`
* **Fix**:

```bash
docker unpause <container>
```

---

### 6️⃣ Container is in `Created` or `Exited` state

```bash
docker ps -a
```

* **Why**: `docker ps` vs `docker ps -a` confusion
* **Rule**: `exec` works **only** on running containers

---

### 7️⃣ Docker daemon state issue

```bash
systemctl status docker
```

* **Why**: Daemon lost track of container state
* **Fix**:

```bash
systemctl restart docker
```

---

### 8️⃣ Orchestrator interference (Compose / Kubernetes)

* Container restarted/replaced automatically
* Your `exec` targets a container that no longer exists

---

### ✅ Interview-ready summary (root causes)

* CrashLoop / rapid restarts
* Container recreated (ID changed)
* Paused or unhealthy container
* Docker daemon state mismatch

---

### 💡 In short (2–3 lines)

`docker exec` fails when the container **isn’t actually running at that moment**—often due to **crash loops, restarts, recreation, or pause state**. Always recheck `docker ps -a`, logs, and restart count before exec’ing.

----
## Q234: A container is showing **“unhealthy”**. How do you debug the health check?

### 🔍 Step-by-step debugging (healthcheck-focused)

---

### 1️⃣ Inspect health check configuration

```bash
docker inspect <container> | grep -A20 -i Health
```

Check:

* `Test` command
* `Interval`, `Timeout`, `Retries`, `StartPeriod`

---

### 2️⃣ Run the health check command manually

```bash
docker exec -it <container> <healthcheck-command>
```

* **Why**: Confirms if the check itself is failing
* **Common issue**: `curl` / `wget` not installed

---

### 3️⃣ Verify exit codes (critical)

```bash
echo $?
```

* **Rule**:

  * `0` → healthy
  * non-zero → unhealthy
* **Mistake**: Endpoint returns 200 but script exits non-zero

---

### 4️⃣ Validate endpoint, port, and protocol

```bash
curl -v http://localhost:8080/health
```

* **Why**: Wrong path, port, HTTP vs HTTPS mismatch

---

### 5️⃣ Check timing / startup issues

```dockerfile
HEALTHCHECK --start-period=30s CMD curl -f http://localhost || exit 1
```

* **Why**: App works later, but check runs too early

---

### 6️⃣ Check dependency-based health checks (anti-pattern)

```bash
curl http://db:5432   # ❌
```

* **Why**: Downstream dependency makes app unhealthy
* **Fix**: Healthcheck should test **app itself**, not dependencies

---

### 7️⃣ Resource starvation

```bash
docker stats
```

* **Why**: CPU/memory pressure causes timeout failures

---

### 8️⃣ User / permission issues

```bash
docker exec -it <container> id
```

* **Why**: Health check runs as container user
* **Fix**: Adjust permissions or command

---

### 9️⃣ Shell vs exec form issues

```dockerfile
HEALTHCHECK CMD curl -f http://localhost || exit 1   # ❌
```

Fix:

```dockerfile
HEALTHCHECK CMD ["CMD-SHELL", "curl -f http://localhost || exit 1"]
```

---

### 🔟 Orchestrator behavior (bonus)

* Docker restarts unhealthy containers
* Kubernetes:

```bash
kubectl describe pod <pod>
```

---

### ✅ Common root causes (interview-ready)

* Wrong health check command/path
* Missing binaries
* Exit code mishandling
* Startup timing mismatch
* Dependency-based checks

---

### 💡 In short (2–3 lines)

Inspect and manually run the **health check command**, verify exit codes, ports, and timing. Most “unhealthy” states are caused by **broken healthcheck logic**, not a broken app.

---
## Q235: Docker Compose volumes are not persisting data between restarts. What’s wrong?

### 🔍 Most common causes (check in this order)

---

### 1️⃣ Using **bind mounts** instead of **named volumes**

```yaml
volumes:
  - ./data:/var/lib/app   # bind mount
```

* **Why**: If `./data` is deleted/changed, data is lost
* **Fix (preferred)**:

```yaml
volumes:
  - app-data:/var/lib/app

volumes:
  app-data:
```

---

### 2️⃣ Containers are recreated with `docker compose down -v`

```bash
docker compose down -v
```

* **Why**: `-v` deletes named volumes
* **Fix**: Use:

```bash
docker compose down
docker compose up -d
```

---

### 3️⃣ Volume defined but not actually used

```yaml
volumes:
  app-data:

services:
  app:
    image: my-app
```

* **Issue**: Volume declared but not mounted
* **Fix**:

```yaml
services:
  app:
    volumes:
      - app-data:/data
```

---

### 4️⃣ Mounting over application data directory

```yaml
volumes:
  - app-data:/var/lib/mysql
```

* **Why**: Volume hides pre-existing image data
* **Result**: App initializes fresh data each time
* **Fix**: Use correct data directory or init logic

---

### 5️⃣ Relative path bind mounts change location

```yaml
- ./data:/data
```

* **Why**: Path depends on where Compose is run from
* **Fix**: Use absolute paths or named volumes

---

### 6️⃣ Wrong service name / multiple projects

```bash
docker compose -p project1 up
docker compose -p project2 up
```

* **Why**: Each project gets its own volume
* **Fix**: Use consistent project name

---

### 7️⃣ Volume is recreated due to name change

```yaml
volumes:
  app_data:   # renamed from app-data
```

* **Why**: New volume = empty data
* **Fix**: Keep volume names stable

---

### 8️⃣ Permissions prevent writes (looks like “not persisted”)

```bash
docker exec -it <container> touch /data/test
```

* **Why**: App can’t write → data never saved
* **Fix**: Fix UID/GID or permissions on volume

---

### 9️⃣ Using `tmpfs` by mistake

```yaml
tmpfs:
  - /data
```

* **Why**: tmpfs is memory-backed → wiped on restart

---

### ✅ Most common root causes (interview-ready)

* Using `down -v`
* Bind mounts instead of named volumes
* Volume mounted to wrong path
* Project/volume name changes
* Permission issues

---

### 💡 In short (2–3 lines)

Data isn’t persisting because the **volume is being deleted, recreated, or never written to**. Use **named volumes**, avoid `docker compose down -v`, ensure correct mount paths, and verify the app can write to the volume.

---
## Q236: Container networking is slow compared to host networking. What would you investigate?

### 🔍 Investigate from lowest to highest overhead

---

### 1️⃣ Network mode (biggest factor)

```bash
docker inspect <container> | grep NetworkMode
```

* **bridge** → NAT + iptables (adds latency)
* **host** → no NAT (fastest)
* **overlay** → encapsulation (slowest)

👉 **Test**:

```bash
docker run --network host my-app
```

* If latency disappears → bridge/NAT overhead confirmed

---

### 2️⃣ DNS resolution latency

```bash
docker exec -it <container> time nslookup api.example.com
```

* **Why**: Docker DNS (`127.0.0.11`) + slow upstream DNS
* **Fix**: Custom DNS or daemon-level DNS

---

### 3️⃣ MTU mismatch (VERY common with VPNs)

```bash
docker exec -it <container> ping -M do -s 1472 target
```

* **Why**: Fragmentation → retransmits → latency
* **Fix**: Align Docker MTU with host/VPC MTU

---

### 4️⃣ iptables / conntrack saturation

```bash
cat /proc/sys/net/netfilter/nf_conntrack_count
cat /proc/sys/net/netfilter/nf_conntrack_max
```

* **Why**: NAT connection tracking overloaded
* **Seen in**: High-throughput services

---

### 5️⃣ Host network congestion

```bash
ip -s link
iftop
```

* **Why**: Packet drops, NIC queues full

---

### 6️⃣ CPU throttling affecting network stack

```bash
docker stats
```

* **Why**: CPU limits delay packet processing

---

### 7️⃣ Proxy / service mesh overhead

* Envoy sidecars
* Corporate proxies
* TLS termination inside container

---

### 8️⃣ Kernel & driver differences

```bash
uname -r
ethtool -k eth0
```

* **Why**: Offloading disabled on veth interfaces

---

### 9️⃣ Overlay networks (Swarm / Kubernetes)

* VXLAN encapsulation
* Cross-node traffic slower

---

### 🔟 Cloud infrastructure factors

* Cross-AZ traffic
* NAT Gateway bandwidth
* Security Group rules

---

### ✅ Common root causes (interview-ready)

* Bridge/NAT overhead
* DNS slowness
* MTU mismatch
* Conntrack saturation
* CPU throttling

---

### 💡 In short (2–3 lines)

Container networking is slower mainly due to **bridge/NAT overhead, DNS latency, or MTU mismatch**. Compare host vs container latency, check network mode, DNS, conntrack, and CPU limits to pinpoint the bottleneck.

----
## Q237: Cannot connect to Docker daemon on a **remote host**. What configuration is needed?

### 🔍 What’s required to access Docker remotely

Docker must be **explicitly exposed**, **secured**, and **reachable**. By default, it listens only on a local Unix socket.

---

### 1️⃣ Docker daemon must listen on a TCP socket

```bash
cat /etc/docker/daemon.json
```

Example (TCP + Unix socket):

```json
{
  "hosts": ["unix:///var/run/docker.sock", "tcp://0.0.0.0:2376"]
}
```

Restart Docker:

```bash
systemctl restart docker
```

---

### 2️⃣ Secure the daemon (TLS is REQUIRED in prod)

⚠️ **Never expose port 2375 without TLS**

Enable TLS:

```json
{
  "hosts": ["tcp://0.0.0.0:2376"],
  "tls": true,
  "tlsverify": true,
  "tlscacert": "/etc/docker/certs/ca.pem",
  "tlscert": "/etc/docker/certs/server-cert.pem",
  "tlskey": "/etc/docker/certs/server-key.pem"
}
```

---

### 3️⃣ Open firewall / security group

* **Port**: `2376` (TLS)
* **AWS SG / Azure NSG**: Allow from trusted IPs only

Verify:

```bash
ss -tulnp | grep 2376
```

---

### 4️⃣ Connect from client with correct env vars

```bash
export DOCKER_HOST=tcp://<remote-ip>:2376
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH=~/.docker/certs
```

Test:

```bash
docker info
```

---

### 5️⃣ SSH tunnel (recommended alternative)

No daemon exposure needed:

```bash
ssh -L 2376:/var/run/docker.sock user@remote-host
```

Then:

```bash
export DOCKER_HOST=tcp://localhost:2376
```

---

### 6️⃣ Common mistakes (interview favorites)

* Docker daemon only listening on `unix:///var/run/docker.sock`
* Port `2376` blocked by firewall/SG
* TLS cert mismatch or missing certs
* Using **2375 (insecure)** in production
* Wrong `DOCKER_HOST` value

---

### 7️⃣ Kubernetes / managed nodes note

* Direct Docker access often **disabled**
* Use `kubectl`, not remote Docker API

---

### 💡 In short (2–3 lines)

To connect to a remote Docker daemon, enable **TCP listening with TLS**, open port **2376**, and configure client **TLS certs + `DOCKER_HOST`**. For production, prefer an **SSH tunnel** over exposing the Docker API.

---
## Q238: Docker build fails with **“invalid reference format”**. What syntax error exists?

### 🔍 What this error means

Docker encountered an **invalid image reference (name/tag)** or a **malformed command syntax**.

---

### 1️⃣ Invalid image name or tag (MOST common)

```bash
docker build -t MyApp:Latest .
```

❌ **Wrong** (uppercase not allowed)

✅ **Correct**:

```bash
docker build -t myapp:latest .
```

**Rules**:

* Lowercase only
* No spaces
* Format: `name:tag`

---

### 2️⃣ Missing tag separator (`:`)

```bash
docker build -t myapp latest .
```

❌ Interpreted as invalid reference

✅:

```bash
docker build -t myapp:latest .
```

---

### 3️⃣ Trailing or leading colon

```bash
docker build -t myapp: .
```

❌ Invalid tag

---

### 4️⃣ Invalid characters in image name

```bash
docker build -t my$app:1.0 .
```

❌ `$`, spaces, special chars not allowed

Allowed:

* `a-z0-9`
* `. _ -`

---

### 5️⃣ Wrong registry/repo format

```bash
docker build -t 123456789012.dkr.ecr.amazonaws.com/myapp .
```

❌ Missing tag (sometimes causes confusion)

✅:

```bash
docker build -t 123456789012.dkr.ecr.amazonaws.com/myapp:latest .
```

---

### 6️⃣ Shell variable expansion issues

```bash
docker build -t myapp:$TAG .
```

* **Issue**: `$TAG` is empty
* **Fix**:

```bash
echo $TAG
```

---

### 7️⃣ Malformed `FROM` instruction in Dockerfile

```dockerfile
FROM node::18
```

❌ Double colon

✅:

```dockerfile
FROM node:18
```

---

### 8️⃣ Line breaks or hidden characters

* Copy-paste from docs
* Windows CRLF

Fix:

```bash
dos2unix Dockerfile
```

---

### ✅ Common syntax mistakes (interview-ready)

* Uppercase letters in image name
* Missing or extra `:`
* Invalid characters
* Empty variables in tags
* Broken `FROM` image reference

---

### 💡 In short (2–3 lines)

“Invalid reference format” means **your image name/tag or `FROM` reference is malformed**. Check for uppercase letters, missing/extra colons, invalid characters, or empty shell variables in tags.

---
## Q239: A container has **orphaned volumes** consuming disk space. How do you clean them up?

### 🔍 Step-by-step cleanup (safe → aggressive)

---

### 1️⃣ Identify unused volumes

```bash
docker volume ls
docker volume ls -f dangling=true
```

* **Dangling** = not attached to any container

---

### 2️⃣ Inspect a volume before deleting

```bash
docker volume inspect <volume>
```

* **Why**: Ensure no active container is using it
* **Interview tip**: Always inspect before delete in prod

---

### 3️⃣ Remove unused volumes (safe)

```bash
docker volume prune
```

* **What**: Deletes all dangling volumes
* **Why**: Frees disk without touching active data

---

### 4️⃣ Remove specific orphaned volumes

```bash
docker volume rm <volume1> <volume2>
```

---

### 5️⃣ Find volumes attached to stopped containers

```bash
docker ps -a --filter status=exited
```

* **Why**: Volumes persist even after containers exit

Remove container + volumes:

```bash
docker rm -v <container>
```

---

### 6️⃣ Full cleanup (CI / non-prod only)

```bash
docker system prune -a --volumes
```

⚠️ **Dangerous**: Removes **unused images, containers, networks, and volumes**

---

### 7️⃣ Docker Compose cleanup

```bash
docker compose down -v
```

* **Why**: Removes Compose-created volumes
* **Note**: Deletes persisted data

---

### 8️⃣ Monitor disk usage

```bash
docker system df
df -h /var/lib/docker
```

---

### ✅ Best practices (interview-ready)

* Use **named volumes** (easy tracking)
* Avoid `--rm` with persistent data
* Clean up CI agents regularly
* Label volumes for ownership

---

### 💡 In short (2–3 lines)

Orphaned volumes are cleaned using `docker volume prune` or manual removal after inspection. For CI/non-prod, `docker system prune --volumes` frees disk fast—use carefully in production.

---
## Q240: `ARG` values are not being substituted in Dockerfile. What’s the syntax issue?

### 🔍 Most common syntax mistakes (check in order)

---

### 1️⃣ `ARG` used **before** it’s declared (MOST common)

```dockerfile
FROM node:${NODE_VERSION}   # ❌ ARG not defined yet
ARG NODE_VERSION=18
```

✅ **Fix**:

```dockerfile
ARG NODE_VERSION=18
FROM node:${NODE_VERSION}
```

> **Rule**: `ARG` must be declared **before first use** (especially before `FROM`).

---

### 2️⃣ `ARG` scope misunderstood (multi-stage builds)

```dockerfile
ARG APP_ENV=prod
FROM alpine
RUN echo $APP_ENV   # ❌ empty
```

✅ **Fix** (redeclare in each stage):

```dockerfile
ARG APP_ENV=prod
FROM alpine
ARG APP_ENV
RUN echo $APP_ENV
```

---

### 3️⃣ Using `ARG` at runtime instead of build time

```dockerfile
RUN echo $MY_ARG
```

* **Issue**: `ARG` exists only at **build time**
* **Fix**: Promote to `ENV` if needed at runtime

```dockerfile
ARG MY_ARG
ENV MY_ARG=${MY_ARG}
```

---

### 4️⃣ Shell vs exec form confusion

```dockerfile
RUN ["echo", "$MY_ARG"]   # ❌ no shell expansion
```

✅ **Fix**:

```dockerfile
RUN echo "$MY_ARG"
```

or

```dockerfile
RUN ["sh", "-c", "echo $MY_ARG"]
```

---

### 5️⃣ `--build-arg` not passed

```bash
docker build -t app .
```

* **Issue**: Build arg expected but never provided

✅ **Fix**:

```bash
docker build --build-arg MY_ARG=value -t app .
```

---

### 6️⃣ Typo or case mismatch

```dockerfile
ARG app_env
RUN echo $APP_ENV   # ❌ different name
```

* **ARG names are case-sensitive**

---

### 7️⃣ Using `ENV` expecting it to override `ARG`

```dockerfile
ARG VERSION
ENV VERSION=1.0
```

* **Result**: `ENV` overwrites `ARG` value
* **Fix**: Set `ENV` from `ARG`, not hardcode

---

### ✅ Common root causes (interview-ready)

* `ARG` declared after use
* `ARG` not redeclared per stage
* Expecting `ARG` at runtime
* Exec-form prevents shell expansion
* Missing `--build-arg`

---

### 💡 In short (2–3 lines)

`ARG` substitution fails when it’s **used before declaration, scoped incorrectly in multi-stage builds, or confused with runtime `ENV`**. Declare `ARG` early, redeclare per stage, pass it via `--build-arg`, and use shell form for expansion.

---
## Q241: Docker Compose override file is not being applied. What would you check?

### 🧠 Overview

`docker-compose.override.yml` is automatically loaded **only when naming and location rules are followed**. If overrides don’t apply, it’s usually a **file naming, path, or command issue**.

---

### ✅ Checks to Perform (In Order)

#### 1️⃣ File name & location

* Must be named **exactly**:

  ```text
  docker-compose.override.yml
  ```
* Must be in the **same directory** as `docker-compose.yml`

📌 **Why**: Docker Compose auto-loads only this exact filename.

---

#### 2️⃣ Are you using `docker compose` vs `docker-compose`?

* Both support override files, but confirm version:

  ```bash
  docker compose version
  ```
* Compose V2 (`docker compose`) is preferred

📌 **Why**: Old Compose versions may behave inconsistently.

---

#### 3️⃣ Are you explicitly specifying `-f`?

If you run:

```bash
docker compose -f docker-compose.yml up
```

➡️ **override file is NOT auto-loaded**

✔️ Fix:

```bash
docker compose -f docker-compose.yml -f docker-compose.override.yml up
```

📌 **Why**: Using `-f` disables automatic override loading.

---

#### 4️⃣ Validate merged configuration

Always check the final config:

```bash
docker compose config
```

📌 **What it does**: Shows the **effective merged YAML**
📌 **Why**: Confirms whether overrides are actually applied

---

#### 5️⃣ YAML structure matches base file

* Service names must match **exactly**

```yaml
# override file
services:
  web:
    image: nginx:latest
```

❌ Wrong service name = ignored override

---

#### 6️⃣ Fields that REPLACE instead of MERGE

Some keys **replace**, not merge:

* `command`
* `entrypoint`
* `ports`
* `volumes`

📌 **Example**

```yaml
ports:
  - "8080:80"
```

➡️ replaces all existing ports

---

#### 7️⃣ Profiles blocking the service

Check if base service uses profiles:

```yaml
services:
  api:
    profiles: ["prod"]
```

Run with:

```bash
docker compose --profile prod up
```

📌 **Why**: Service won’t start → override looks ignored

---

#### 8️⃣ Environment variables not loading

* Check `.env` file presence
* Check shell exports:

```bash
echo $APP_ENV
```

📌 **Why**: Env vars affect image, ports, replicas, etc.

---

#### 9️⃣ Cached containers still running

Recreate containers:

```bash
docker compose down
docker compose up --build
```

📌 **Why**: Running containers won’t pick up config changes

---

### 🔍 Quick Debug Checklist

```bash
ls docker-compose*
docker compose config
docker compose down
docker compose up --build
```

---

### 💡 In short (Quick Recall)

* Override file name & path must be exact
* Using `-f` disables auto override loading
* Service names must match
* Some fields replace, not merge
* Always verify with `docker compose config`

---
## Q242: Container startup is taking much longer than expected. What would you profile?

### 🧠 Overview

Slow container startup is usually caused by **image size, runtime initialization, networking, or external dependencies**. Profile from **image → runtime → application → infrastructure** in that order.

---

### 🔍 What to Profile (Step-by-Step)

#### 1️⃣ Image size & layer efficiency

```bash
docker images
docker history my-image
```

* Check large base images, too many layers
* Look for heavy `RUN apt-get`, build tools in runtime image

📌 **Why**: Large images = slow pull + unpack

---

#### 2️⃣ Image pull time

```bash
time docker pull my-image
```

* Check registry latency (ECR/DockerHub)
* Verify image caching on node

📌 **Real-world**: Cold nodes in EKS cause slow pod startup

---

#### 3️⃣ ENTRYPOINT / CMD execution

```bash
docker inspect my-container | jq '.[0].Config.Entrypoint'
```

* Look for:

  * Sleep/wait loops
  * Shell scripts doing heavy work
  * Runtime installs (`pip install`, `npm install` ❌)

📌 **Why**: Blocking scripts delay container readiness

---

#### 4️⃣ Application initialization

* Enable app startup logs
* Measure time for:

  * Config loading
  * Dependency injection
  * Cache warm-up
  * DB connection pools

📌 **Example**

```bash
time java -jar app.jar
```

---

#### 5️⃣ External dependencies

* DB, Redis, Kafka, S3 calls during startup
* DNS resolution delays

```bash
dig mydb.internal
```

📌 **Best practice**: Lazy-init dependencies, not on startup

---

#### 6️⃣ Health checks blocking readiness

```bash
docker inspect | jq '.[0].State.Health'
```

* Aggressive `start_period`
* Slow health endpoint

📌 **K8s impact**: Pod stays `NotReady`

---

#### 7️⃣ Resource constraints

```bash
docker stats
kubectl describe pod <pod>
```

* CPU throttling
* Memory pressure → GC delays

📌 **Why**: Under-requested CPU slows JVM / Node startup

---

#### 8️⃣ Volume mounts & I/O

* Large bind mounts
* Network filesystems (EFS, NFS)

📌 **Real-world**: EFS mounts add seconds to startup in EKS

---

#### 9️⃣ Security & runtime overhead

* SELinux / AppArmor
* Image scanning hooks
* Init containers (K8s)

```bash
kubectl get events
```

---

### 🧪 Tools to Use

| Tool                   | What it shows        |
| ---------------------- | -------------------- |
| `docker history`       | Heavy layers         |
| `docker inspect`       | Entrypoint, health   |
| `docker stats`         | Resource bottlenecks |
| `kubectl describe pod` | Startup events       |
| App logs               | Init bottlenecks     |

---

### 💡 In short (Quick Recall)

* Check image size & pull time first
* Profile entrypoint and app init
* Watch external dependencies & DNS
* Verify health checks and resources
* Volumes and init containers often add delay

---
## Q243: A bind mount is not reflecting file changes in real-time. What caching issue exists?

### 🧠 Overview

The issue is **filesystem caching between host and container**, especially on **Docker Desktop (macOS/Windows)**. Bind mounts may use **cached/delegated/consistent** modes or VM-based sync layers that delay file updates.

---

### 🔍 What Caching Issue Exists

#### 1️⃣ Docker Desktop file sync caching (macOS/Windows)

* Docker runs inside a **VM**
* File changes go through:

  ```
  Host FS → gRPC FUSE / VirtioFS → VM → Container
  ```
* Caching causes **delayed or missed updates**

📌 **Common root cause** in local dev

---

#### 2️⃣ Mount consistency modes (macOS)

```yaml
volumes:
  - ./app:/app:cached
```

| Mode         | Behavior                         |
| ------------ | -------------------------------- |
| `consistent` | Immediate sync (slowest, safest) |
| `cached`     | Host wins, container may lag     |
| `delegated`  | Container wins, host may lag     |

📌 **Issue**: `cached` / `delegated` delay updates

---

#### 3️⃣ Inotify / file watcher limitations

* Node.js, Webpack, Python watchdog rely on `inotify`
* VM-based mounts **don’t propagate events correctly**

📌 **Symptom**: App doesn’t auto-reload

---

#### 4️⃣ Editor / OS-level caching

* Some editors write via temp files + rename
* Container watches original inode → no change detected

📌 **Seen with**: VS Code, IntelliJ

---

### ✅ How to Fix / Verify

#### Force strict consistency

```yaml
volumes:
  - ./app:/app:consistent
```

---

#### Use polling instead of inotify

```bash
CHOKIDAR_USEPOLLING=true
WATCHPACK_POLLING=true
```

📌 **Why**: Polling avoids FS event issues

---

#### Switch to named volumes (prod-safe)

```yaml
volumes:
  - app-data:/app
```

📌 **Why**: Avoids host↔VM sync completely

---

#### Enable VirtioFS (Docker Desktop)

* Settings → General → Enable **VirtioFS**
* Much faster + better sync

---

### 🧪 Quick Debug Commands

```bash
docker inspect <container> | jq '.[0].Mounts'
docker compose config
```

---

### 💡 In short (Quick Recall)

* Bind mounts use cached FS sync via VM
* `cached/delegated` delay updates
* Inotify doesn’t always propagate
* Use `consistent`, polling, or named volumes

----
## Q244: Docker prune removed more than intended. How do you recover?

### 🧠 Overview

**You usually can’t fully recover** data removed by `docker system prune`. Recovery depends on **what was pruned** and whether you have **backups, registries, or volumes outside Docker’s control**.

---

### 🔍 What to Check Immediately

#### 1️⃣ What command was run?

```bash
docker system prune
docker system prune -a
docker volume prune
```

| Command        | What it deletes                                      |
| -------------- | ---------------------------------------------------- |
| `prune`        | Stopped containers, unused networks, dangling images |
| `prune -a`     | **All unused images** (even tagged)                  |
| `volume prune` | **Unused volumes (data loss risk)**                  |

📌 **Key point**: Images can be re-pulled; volumes usually cannot.

---

### 🧪 Recovery Options (By Resource Type)

#### 🔹 Images

✔️ **Recoverable**

```bash
docker pull my-image:tag
```

* Pull again from Docker Hub / ECR / ACR
* Rebuild if Dockerfile exists

📌 **Why**: Images are immutable artifacts

---

#### 🔹 Containers

❌ **Not recoverable**

* Containers are runtime state
* Only logs may exist in external logging systems

---

#### 🔹 Volumes

⚠️ **Usually NOT recoverable**

Check if data still exists on disk:

```bash
ls /var/lib/docker/volumes/
```

📌 **Possible only if**:

* Volume wasn’t actually deleted
* Filesystem-level backup/snapshot exists (LVM, EBS snapshot)

---

#### 🔹 Bind mounts

✔️ **Safe**

* Data lives on host filesystem
* Docker prune does NOT touch host paths

📌 **Best practice** for critical data

---

### 🚑 Last-Resort Options (Low Success)

* Filesystem undelete tools (`extundelete`, `debugfs`)
* Restore from:

  * EBS snapshots
  * VM backups
  * Backup agents (Velero, Restic)

📌 **Reality**: Rarely works in production

---

### 🔒 Prevention (Interview Gold)

#### Dry-run before prune

```bash
docker system df
docker image ls
docker volume ls
```

---

#### Avoid pruning volumes blindly

```bash
docker system prune --volumes ❌
```

---

#### Label & protect resources

```bash
docker run --label keep=true
```

---

#### Use backups for state

* DB backups
* Snapshots
* External storage (S3, RDS)

---

### 💡 In short (Quick Recall)

* Images → re-pull or rebuild
* Containers → gone
* Volumes → usually permanent data loss
* Bind mounts → unaffected
* Prevention > recovery

---
## Q245: Container timezone is incorrect. How do you set it properly?

### 🧠 Overview

Containers default to **UTC**. You fix timezone issues by setting **`TZ`**, installing **timezone data**, or mounting the host timezone. Best practice depends on **image type** and **production needs**.

---

### ✅ Preferred Options (In Order)

#### 1️⃣ Set timezone via `TZ` environment variable (most common)

```dockerfile
ENV TZ=Asia/Kolkata
```

or in runtime:

```bash
docker run -e TZ=Asia/Kolkata my-image
```

📌 **Why**: Simple, portable, works for most apps
📌 **Note**: Requires `tzdata` installed

---

#### 2️⃣ Install `tzdata` in the image (required for Alpine/Debian)

**Alpine**

```dockerfile
RUN apk add --no-cache tzdata
```

**Debian/Ubuntu**

```dockerfile
RUN apt-get update && apt-get install -y tzdata
```

📌 **Why**: Without `tzdata`, `TZ` is ignored

---

#### 3️⃣ Explicitly link `/etc/localtime` (Linux images)

```dockerfile
RUN ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime \
    && echo "Asia/Kolkata" > /etc/timezone
```

📌 **Why**: Forces system-level timezone

---

#### 4️⃣ Mount host timezone (not recommended in prod)

```bash
docker run \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  my-image
```

📌 **Why**: Matches host time
⚠️ **Risk**: Breaks portability, bad for Kubernetes

---

### 🧪 Verify Inside Container

```bash
date
cat /etc/timezone
```

---

### ☸ Kubernetes Example

```yaml
env:
  - name: TZ
    value: Asia/Kolkata
```

---

### 🔒 Best Practices (Interview Points)

* **Keep containers in UTC**; convert at app/log layer
* Set timezone only if app truly requires local time
* Never rely on host timezone in Kubernetes

---

### 💡 In short (Quick Recall)

* Default = UTC
* Install `tzdata`
* Set `TZ` env var
* Avoid host mounts in prod
* Prefer UTC for distributed systems

---
## Q246: A container's IP address keeps changing. How do you assign a static IP?

### 🧠 Overview

Container IPs change because Docker uses **dynamic IP allocation**. You can assign a static IP **only on user-defined networks**. In production, **use DNS/service names instead of static IPs**.

---

### ✅ Correct Ways to Assign a Static IP

#### 1️⃣ Create a user-defined bridge network

```bash
docker network create \
  --subnet 172.20.0.0/16 \
  my-net
```

📌 **Why**: Default `bridge` does not support static IPs

---

#### 2️⃣ Run container with a fixed IP

```bash
docker run --net my-net --ip 172.20.0.10 nginx
```

📌 **What it does**: Assigns a fixed IP from the subnet
📌 **Note**: You must manage IP conflicts manually

---

#### 3️⃣ Docker Compose static IP

```yaml
networks:
  my-net:
    ipam:
      config:
        - subnet: 172.20.0.0/16

services:
  app:
    image: my-app
    networks:
      my-net:
        ipv4_address: 172.20.0.10
```

📌 **Why**: Declarative and repeatable

---

### 🚫 What NOT to Do

* ❌ Static IP on default `bridge`
* ❌ Rely on container IPs in Kubernetes
* ❌ Hardcode IPs across environments

---

### ☸ Kubernetes (Important Interview Note)

* **Static Pod IPs are NOT supported**
* Use:

  * **Services**
  * **DNS names**
  * **Headless Services** (stable DNS per Pod)

📌 **Example**

```yaml
serviceName: my-headless
```

---

### 🔒 Best Practices (Interview Gold)

* Use **container/service names** for communication
* Let Docker/K8s manage IPs
* Static IPs only for legacy or special networking needs

---

### 💡 In short (Quick Recall)

* Container IPs are dynamic by design
* Static IPs need user-defined networks
* Docker Compose supports `ipv4_address`
* In Kubernetes → use Services/DNS, not IPs

---
## Q247: Docker build cache is being invalidated unnecessarily. How do you optimize layer order?

### 🧠 Overview

Docker cache is **layer-based**. Any change in a layer **invalidates all layers after it**. Optimize by putting **least-changing steps first** and **most-changing steps last**.

---

### 🔑 Core Rule (Interview One-liner)

> **Order Dockerfile instructions from least frequently changing → most frequently changing.**

---

### ✅ Optimized Dockerfile Pattern

#### ❌ Bad (cache breaks often)

```dockerfile
COPY . .
RUN npm install
```

* Any code change breaks `npm install` cache

---

#### ✅ Good (cache-friendly)

```dockerfile
COPY package.json package-lock.json ./
RUN npm install
COPY . .
```

📌 **Why**: Dependency install runs only when dependency files change

---

### 🧱 Layer Optimization Checklist

#### 1️⃣ Base image first (rarely changes)

```dockerfile
FROM node:18-alpine
```

---

#### 2️⃣ System dependencies early

```dockerfile
RUN apk add --no-cache curl
```

📌 **Why**: OS packages change infrequently

---

#### 3️⃣ Dependency descriptors before source code

| Language | Files                     |
| -------- | ------------------------- |
| Node.js  | `package*.json`           |
| Python   | `requirements.txt`        |
| Java     | `pom.xml`, `build.gradle` |
| Go       | `go.mod`, `go.sum`        |

```dockerfile
COPY requirements.txt .
RUN pip install -r requirements.txt
```

---

#### 4️⃣ Application code last

```dockerfile
COPY . .
```

📌 **Why**: Code changes most often

---

### 🚀 Advanced Optimizations

#### Multi-stage builds

```dockerfile
FROM node:18 AS build
RUN npm ci
```

📌 **Why**: Keeps final image small + cacheable

---

#### Use `.dockerignore`

```text
.git
node_modules
tests
```

📌 **Why**: Prevents context changes → cache hits

---

#### Pin versions

```dockerfile
FROM python:3.11.6-slim
```

📌 **Why**: Floating tags break cache

---

#### Avoid changing ENV early

```dockerfile
ENV BUILD_TIME=$(date) ❌
```

📌 **Why**: Always invalidates cache

---

### 🧪 Debug Cache Behavior

```bash
docker build --progress=plain .
docker history my-image
```

---

### 🔒 CI/CD Best Practices

* Use `--cache-from` in CI
* Enable BuildKit

```bash
DOCKER_BUILDKIT=1 docker build .
```

---

### 💡 In short (Quick Recall)

* Cache breaks top-down
* Put stable steps first
* Copy dependency files before source
* Use `.dockerignore`
* Avoid dynamic values early

---
## Q248: Containers cannot access the internet. What network configuration is wrong?

### 🧠 Overview

Internet access fails when **NAT, DNS, routing, or proxy rules** are misconfigured. Start from **container → Docker network → host → firewall**.

---

### 🔍 What to Check (In Order)

#### 1️⃣ Container is attached to a NAT-enabled network

```bash
docker network inspect bridge
```

* Default `bridge` provides NAT
* ❌ `--network none` → no internet
* ❌ Misconfigured custom bridge (no gateway)

📌 **Fix**: Use default bridge or recreate custom network with IPAM

---

#### 2️⃣ IP forwarding & NAT on host (Linux)

```bash
sysctl net.ipv4.ip_forward
iptables -t nat -L -n
```

* `ip_forward` must be `1`
* `MASQUERADE` rule must exist

📌 **Common issue**: Hardened AMIs disable forwarding

---

#### 3️⃣ DNS resolution inside container

```bash
docker exec -it c1 cat /etc/resolv.conf
docker exec -it c1 nslookup google.com
```

* Wrong or unreachable DNS server
* Docker daemon DNS misconfigured

📌 **Fix**

```json
// /etc/docker/daemon.json
{ "dns": ["8.8.8.8", "1.1.1.1"] }
```

---

#### 4️⃣ Corporate proxy not passed to container

```bash
env | grep -i proxy
```

* Containers don’t inherit host proxy automatically

📌 **Fix**

```bash
docker run -e HTTP_PROXY -e HTTPS_PROXY my-image
```

---

#### 5️⃣ Firewall / security groups blocking egress

* Host firewall (`iptables`, `firewalld`)
* Cloud SG/NACL egress rules

📌 **AWS example**: SG must allow **0.0.0.0/0 outbound**

---

#### 6️⃣ Custom Docker network missing gateway

```bash
docker network inspect my-net | jq '.[0].IPAM'
```

* No `Gateway` → no outbound routing

📌 **Fix**

```bash
docker network create --subnet 172.30.0.0/16 my-net
```

---

#### 7️⃣ Kubernetes-specific (if applicable)

```bash
kubectl exec pod -- curl google.com
kubectl get networkpolicy
```

* NetworkPolicy denying egress
* CNI misconfiguration

📌 **Fix**: Allow egress in NetworkPolicy

---

### 🧪 Quick Debug Commands

```bash
docker exec -it c1 ping 8.8.8.8
docker exec -it c1 curl https://google.com
ip route
```

---

### 💡 In short (Quick Recall)

* Container not on NAT-enabled network
* Host IP forwarding / MASQUERADE missing
* DNS misconfigured
* Proxy vars not passed
* Firewall / SG blocking egress

----
## Q249: Docker registry authentication is failing. How do you troubleshoot credentials?

### 🧠 Overview

Registry auth failures usually come from **expired tokens, wrong auth method, bad credential helpers, or incorrect registry URLs**. Troubleshoot from **CLI → config → registry → IAM/permissions**.

---

### 🔍 Troubleshooting Checklist (Step-by-Step)

#### 1️⃣ Verify registry URL & auth method

```bash
docker login <registry>
```

| Registry   | Correct Login                  |               |
| ---------- | ------------------------------ | ------------- |
| Docker Hub | `docker login`                 |               |
| AWS ECR    | `aws ecr get-login-password    | docker login` |
| Azure ACR  | `az acr login --name myacr`    |               |
| GCR        | `gcloud auth configure-docker` |               |

📌 **Common mistake**: Logging into repo URL instead of registry hostname

---

#### 2️⃣ Check stored credentials

```bash
cat ~/.docker/config.json
```

Look for:

* `auths`
* `credsStore`
* `credHelpers`

📌 **Issue**: Broken helper = login always fails

---

#### 3️⃣ Clear bad credentials and re-login

```bash
docker logout <registry>
rm -rf ~/.docker/config.json
docker login <registry>
```

📌 **Why**: Removes corrupted or stale tokens

---

#### 4️⃣ Token expiration (very common)

* ECR tokens expire in **12 hours**

```bash
aws ecr get-login-password --region ap-south-1 \
| docker login --username AWS --password-stdin <acct>.dkr.ecr.ap-south-1.amazonaws.com
```

📌 **Fix**: Re-authenticate in CI before every push/pull

---

#### 5️⃣ Check IAM / RBAC permissions

* Required permissions:

  * `ecr:GetAuthorizationToken`
  * `ecr:BatchCheckLayerAvailability`
  * `ecr:PutImage`

📌 **Symptom**: `denied: User is not authorized`

---

#### 6️⃣ Corporate proxy / TLS inspection

```bash
docker info | grep -i proxy
```

* MITM proxy breaks TLS
* Missing CA cert inside Docker

📌 **Fix**

```bash
cp corp-ca.crt /etc/docker/certs.d/<registry>/ca.crt
systemctl restart docker
```

---

#### 7️⃣ Insecure registry config (HTTP)

```json
// /etc/docker/daemon.json
{
  "insecure-registries": ["my-registry.local:5000"]
}
```

📌 **Why**: HTTPS required by default

---

#### 8️⃣ CI/CD secrets masking issues

* Base64-encoded creds double-encoded
* Newlines in secrets

```bash
echo "$DOCKER_PASSWORD" | docker login --password-stdin
```

📌 **Common Jenkins/GitHub Actions issue**

---

### 🧪 Quick Debug Commands

```bash
docker login --debug
docker pull alpine
cat ~/.docker/config.json
```

---

### 💡 In short (Quick Recall)

* Check correct registry URL
* Clear cached creds
* Tokens (ECR) expire fast
* Verify IAM permissions
* Proxy / CA issues break TLS
* CI secrets often malformed

---
## Q250: A container exits with code **137**. What does this indicate and how do you fix it?

### 🧠 Overview

**Exit code 137 = SIGKILL (9)**.
Most commonly, the container was **killed by the OOM (Out Of Memory) killer** due to memory pressure or hard memory limits.

---

### 🔍 What It Indicates

| Code       | Meaning                                           |
| ---------- | ------------------------------------------------- |
| 137        | `128 + 9` → Killed with **SIGKILL**               |
| Root cause | **OOM kill**, forced stop, or node-level pressure |

📌 **99% of cases** in Docker/K8s = memory limit exceeded

---

### 🧪 How to Confirm

#### Docker

```bash
docker inspect <container> | jq '.[0].State.OOMKilled'
docker logs <container>
```

#### Kubernetes

```bash
kubectl describe pod <pod>
```

Look for:

```
Reason: OOMKilled
Exit Code: 137
```

---

### 🛠️ How to Fix (Step-by-Step)

#### 1️⃣ Increase memory limits

**Docker**

```bash
docker run -m 1g my-image
```

**Kubernetes**

```yaml
resources:
  requests:
    memory: "512Mi"
  limits:
    memory: "1Gi"
```

📌 **Why**: Prevents OOM killer from terminating the process

---

#### 2️⃣ Reduce application memory usage

* Memory leaks
* Large in-memory caches
* Unbounded queues

📌 **Example**

* JVM: set heap properly

```bash
-Xmx512m -Xms256m
```

---

#### 3️⃣ Avoid running without memory limits (K8s)

```yaml
resources:
  limits:
    memory: "1Gi"
```

📌 **Why**: Without limits, node OOM kills pods unpredictably

---

#### 4️⃣ Check node-level memory pressure

```bash
kubectl top nodes
kubectl top pods
```

📌 **Why**: Even correct limits fail on overcommitted nodes

---

#### 5️⃣ Ensure graceful shutdown handling

* Handle `SIGTERM`
* Avoid forced `SIGKILL`

📌 **Why**: SIGKILL gives no cleanup time

---

### 🚨 Less Common Causes

* Manual `docker kill -9`
* CI/CD timeout killing container
* Host reboot / crash
* Kernel panic / cgroup enforcement

---

### 💡 In short (Quick Recall)

* **137 = SIGKILL**
* Usually **OOMKilled**
* Increase memory limits
* Fix app memory usage
* Set proper JVM / runtime configs
* Monitor node memory pressure

---
## Q251: ENTRYPOINT is not executing the correct command. What syntax issue exists?

### 🧠 Overview

Most ENTRYPOINT issues are caused by **shell form vs exec form misuse**, **incorrect JSON syntax**, or **ENTRYPOINT + CMD misunderstanding**. Docker treats these forms **very differently**.

---

### 🔑 Primary Syntax Issue (Most Common)

> Using **shell form** instead of **exec (JSON) form**, causing the command to be run via `/bin/sh -c` and breaking argument passing & signal handling.

---

### ❌ Wrong (Shell form)

```dockerfile
ENTRYPOINT java -jar app.jar
```

* Runs as: `/bin/sh -c "java -jar app.jar"`
* CMD args may be ignored
* Signals (SIGTERM) not forwarded

---

### ✅ Correct (Exec / JSON form)

```dockerfile
ENTRYPOINT ["java", "-jar", "app.jar"]
```

📌 **Why**: Proper PID 1, correct argument handling, graceful shutdown

---

### 🔍 Other Common ENTRYPOINT Syntax Issues

#### 1️⃣ ENTRYPOINT + CMD misunderstanding

```dockerfile
ENTRYPOINT ["python"]
CMD ["app.py"]
```

✔️ Final command:

```bash
python app.py
```

❌ If CMD is string:

```dockerfile
CMD "app.py"   # WRONG
```

---

#### 2️⃣ JSON array syntax errors

```dockerfile
ENTRYPOINT ["java" "-jar" "app.jar"] ❌
```

✔️ Must be comma-separated:

```dockerfile
ENTRYPOINT ["java", "-jar", "app.jar"]
```

---

#### 3️⃣ Overriding ENTRYPOINT incorrectly

```bash
docker run my-image ls
```

* This overrides **CMD**, not ENTRYPOINT

✔️ Correct override:

```bash
docker run --entrypoint ls my-image
```

---

#### 4️⃣ Using variables without shell

```dockerfile
ENTRYPOINT ["java", "-jar", "$APP_JAR"] ❌
```

✔️ Either:

```dockerfile
ENTRYPOINT ["sh", "-c", "java -jar $APP_JAR"]
```

or hardcode path

📌 **Why**: Exec form does NOT expand variables

---

#### 5️⃣ Missing executable permissions

```bash
chmod +x entrypoint.sh
```

📌 **Symptom**: `exec format error` or silent failure

---

### 🧪 Debug Commands

```bash
docker inspect <image> | jq '.[0].Config.Entrypoint'
docker run --entrypoint sh my-image
```

---

### 🔒 Best Practices (Interview Gold)

* Prefer **exec form**
* Use CMD for defaults, ENTRYPOINT for fixed executable
* Avoid shell unless variable expansion is required
* Always test with `docker inspect`

---

### 💡 In short (Quick Recall)

* Shell vs exec form causes most issues
* Exec form ensures correct command & signals
* CMD appends to ENTRYPOINT
* Variables don’t expand in exec form
* Use `--entrypoint` to override

----
## Q252: Docker Compose is using the wrong `.env` file. How do you specify the correct one?

### 🧠 Overview

Docker Compose **auto-loads only one `.env` file** from the project directory. If the wrong values are used, you must **explicitly specify the env file** or override variables via CLI.

---

### 🔑 Correct Ways to Specify the `.env` File

#### 1️⃣ Use `--env-file` (Best & Explicit)

```bash
docker compose --env-file .env.prod up
```

📌 **Why**: Overrides default `.env` lookup
📌 **Works in**: Compose v2 (`docker compose`)

---

#### 2️⃣ Define `env_file` per service (Compose YAML)

```yaml
services:
  app:
    env_file:
      - .env.prod
```

📌 **Why**: Service-scoped env files
📌 **Note**: Does NOT affect variable substitution in `docker-compose.yml`

---

#### 3️⃣ Set environment variables in shell (Highest priority)

```bash
export DB_HOST=prod-db
docker compose up
```

📌 **Why**: Shell vars override `.env`

---

### ⚠️ Common Pitfalls (Very Important)

#### `.env` auto-loading rules

* Only `.env` (exact name) is auto-loaded
* Must be in **project root**
* `env_file` ≠ `.env` substitution

📌 **Example gotcha**

```yaml
image: myapp:${TAG}   # uses .env or shell, NOT env_file
```

---

### 🔢 Variable Precedence (High → Low)

1. Shell environment variables
2. `--env-file`
3. `.env` file
4. `env_file` (container runtime only)

---

### 🧪 Verify Effective Values

```bash
docker compose config
docker compose exec app env | grep DB_
```

---

### 🔒 Best Practices (Interview Gold)

* Use `--env-file` in CI/CD
* Name env files clearly (`.env.dev`, `.env.prod`)
* Never rely on implicit `.env` in production
* Don’t commit sensitive `.env` files

---

### 💡 In short (Quick Recall)

* Compose auto-loads only `.env`
* Use `--env-file` to override
* `env_file` is runtime-only
* Shell vars always win
* Verify with `docker compose config`

----
## Q253: Container resource limits are being ignored. What runtime issue exists?

### 🧠 Overview

When limits appear ignored, the usual cause is **Docker running without proper cgroup enforcement** or **limits applied at the wrong layer** (Docker vs Kubernetes). The runtime may be using **cgroup v1/v2 incorrectly** or limits are **not actually set**.

---

### 🔍 Root Runtime Issues to Check

#### 1️⃣ Limits not set on the container (most common)

```bash
docker inspect <container> | jq '.[0].HostConfig.Memory'
docker inspect <container> | jq '.[0].HostConfig.NanoCpus'
```

📌 **Why**: No limits → container can use all host resources

---

#### 2️⃣ Docker running without cgroups enabled

```bash
docker info | grep -i cgroup
```

Expected:

```
Cgroup Driver: cgroupfs | systemd
Cgroup Version: 1 or 2
```

📌 **Issue**: Docker-in-Docker, rootless Docker, or misconfigured OS

---

#### 3️⃣ Running on macOS / Windows (Docker Desktop)

* Limits apply **inside the VM**, not the host
* VM itself has higher resource limits

📌 **Symptom**: Container exceeds expected limits

---

#### 4️⃣ Cgroup v2 misconfiguration (common on newer Linux)

```bash
mount | grep cgroup
```

📌 **Issue**:

* Old Docker versions
* systemd mismatch

📌 **Fix**: Upgrade Docker or align cgroup driver

---

#### 5️⃣ Kubernetes limits vs requests misunderstanding

```yaml
resources:
  requests:
    cpu: "500m"
  limits:
    cpu: "1"
```

📌 **Important**:

* CPU limits → throttling (not hard stop)
* Memory limits → OOM kill

---

#### 6️⃣ Rootless Docker limitations

* CPU & memory limits partially enforced
* Depends on kernel version

📌 **Interview tip**: Rootless ≠ full isolation

---

#### 7️⃣ Overcommit at node level (K8s)

```bash
kubectl describe node
```

📌 **Why**: Node pressure masks container-level limits

---

### 🧪 Debug Commands

```bash
docker stats
docker inspect <container>
kubectl describe pod
```

---

### 🔒 Best Practices (Interview Gold)

* Always verify limits via `inspect`
* Match cgroup driver with systemd
* Don’t trust Docker Desktop for perf tests
* Set both requests & limits in K8s

---

### 💡 In short (Quick Recall)

* Limits not actually set
* Cgroups not enforced
* Docker Desktop uses VM limits
* CPU ≠ memory behavior
* Rootless Docker has constraints

---
## Q254: A scratch-based image fails with **“exec format error”**. What’s wrong?

### 🧠 Overview

`exec format error` means the kernel **cannot execute the binary**. In scratch images this almost always happens due to **architecture mismatch** or **missing/incorrect binary format**.

---

### 🔍 Root Causes (Most → Least Common)

#### 1️⃣ Binary architecture mismatch (MOST COMMON)

* Built binary for **amd64**, running on **arm64** (or vice-versa)

```bash
file app
uname -m
```

📌 **Fix**

```bash
GOOS=linux GOARCH=amd64 go build -o app
# or
docker buildx build --platform linux/amd64 .
```

---

#### 2️⃣ Binary is dynamically linked (scratch has no libc)

```bash
ldd app
```

* `not a dynamic executable` ✅ (good)
* Uses `glibc` / `musl` ❌ (won’t work in scratch)

📌 **Fix (static build)**

```bash
CGO_ENABLED=0 go build -o app
```

---

#### 3️⃣ ENTRYPOINT / CMD syntax wrong

```dockerfile
ENTRYPOINT app   ❌
```

✔️ Correct:

```dockerfile
ENTRYPOINT ["/app"]
```

📌 **Why**: Scratch has no shell to interpret commands

---

#### 4️⃣ Missing executable permission

```bash
chmod +x app
```

📌 **Symptom**: Kernel cannot execute the file

---

#### 5️⃣ Wrong binary format (script or shebang)

* Shell scripts won’t work (`/bin/sh` doesn’t exist)

📌 **Fix**: Use a compiled binary only

---

### ✅ Correct Minimal Scratch Example

```dockerfile
FROM scratch
COPY app /app
ENTRYPOINT ["/app"]
```

---

### 🧪 Debug Tip

Temporarily test with:

```dockerfile
FROM busybox
```

If it works there → your binary is not scratch-compatible.

---

### 💡 In short (Quick Recall)

* Scratch needs **static, correct-arch binaries**
* No shell, no libc
* Arch mismatch = exec format error
* Use exec-form ENTRYPOINT
* `CGO_ENABLED=0` for Go binaries

---
## Q255: Docker build context is too large causing slow builds. How do you reduce it?

### 🧠 Overview

Docker sends the **entire build context** to the daemon before building. Large contexts slow builds and break cache. The fix is to **exclude files, narrow the context, and restructure the Dockerfile**.

---

### 🔑 Primary Fixes (Most Important First)

#### 1️⃣ Use `.dockerignore` aggressively (BIGGEST WIN)

```dockerignore
.git
node_modules
target
dist
logs
*.log
tests
.env
```

📌 **Why**: Prevents unnecessary files from being sent to Docker

---

#### 2️⃣ Reduce the build context path

❌ Bad:

```bash
docker build .
```

✔️ Better:

```bash
docker build ./app
```

📌 **Why**: Only sends what the Dockerfile actually needs

---

#### 3️⃣ Copy only required files (avoid `COPY . .`)

❌ Bad:

```dockerfile
COPY . .
```

✔️ Good:

```dockerfile
COPY package*.json ./
COPY src/ ./src/
```

📌 **Why**: Context changes invalidate cache

---

### 🚀 Advanced Optimizations

#### 4️⃣ Multi-stage builds

```dockerfile
FROM node:18 AS build
RUN npm ci
```

📌 **Why**: Build tools stay out of final image

---

#### 5️⃣ Enable BuildKit

```bash
DOCKER_BUILDKIT=1 docker build .
```

📌 **Why**: Parallelism, smarter cache handling

---

#### 6️⃣ Use remote or Git contexts

```bash
docker build https://github.com/org/repo.git#main
```

📌 **Why**: Docker fetches only tracked files

---

#### 7️⃣ Prune unnecessary artifacts

* Remove:

  * `.git`
  * test data
  * local caches
* Especially in monorepos

---

### 🧪 Debug Context Size

```bash
docker build --progress=plain .
```

Look for:

```
Sending build context to Docker daemon 1.2GB
```

---

### 🔒 Best Practices (Interview Gold)

* Always maintain `.dockerignore`
* Avoid `COPY . .` in large repos
* Separate build and runtime contexts
* Use CI caching + BuildKit

---

### 💡 In short (Quick Recall)

* Build context is sent upfront
* `.dockerignore` is critical
* Narrow the context path
* Copy only what’s needed
* Enable BuildKit

---
## Q256: Container cannot write to stdout/stderr. What process issue exists?

### 🧠 Overview

This usually means the **main process isn’t running as PID 1 correctly** or **stdout/stderr are redirected/closed**. Docker logging only works when the app writes to **FD 1 (stdout) / FD 2 (stderr)** of the container’s main process.

---

### 🔍 Common Process Issues (Most → Least Common)

#### 1️⃣ ENTRYPOINT runs via shell and swallows output

```dockerfile
ENTRYPOINT sh -c "myapp > /var/log/app.log"
```

* Output redirected to a file
* Nothing goes to Docker logs

✔️ Fix (exec form, no redirection):

```dockerfile
ENTRYPOINT ["myapp"]
```

---

#### 2️⃣ App daemonizes / forks to background

* App detaches from terminal
* Parent exits → child loses stdout/stderr

📌 **Symptom**: Container runs but logs are empty

✔️ Fix:

* Run app in **foreground**
* Disable daemon mode (e.g., `--no-daemon`, `-f`)

---

#### 3️⃣ PID 1 is a shell script that doesn’t `exec`

```sh
#!/bin/sh
myapp
```

* Shell stays PID 1
* Signals & FDs not forwarded properly

✔️ Fix:

```sh
exec myapp
```

📌 **Why**: `exec` replaces shell with the app, preserving stdout/stderr

---

#### 4️⃣ Logging framework writes to file instead of console

* App configured to log to `/var/log/*`

📌 **Fix examples**

* Java (Logback): use `ConsoleAppender`
* Python: `logging.StreamHandler(sys.stdout)`
* Nginx:

  ```nginx
  access_log /dev/stdout;
  error_log  /dev/stderr;
  ```

---

#### 5️⃣ Non-root user lacks permission on stdout/stderr (rare)

* Custom entrypoint closes FDs
* TTY disabled incorrectly

✔️ Fix:

* Don’t close FDs
* Avoid custom FD manipulation

---

### 🧪 Debug Commands

```bash
docker logs <container>
docker inspect <container> | jq '.[0].Config.Entrypoint'
ps -ef
```

---

### 🔒 Best Practices (Interview Gold)

* Use **exec-form ENTRYPOINT**
* Run apps in **foreground**
* Never redirect logs to files in containers
* Let Docker/K8s handle log collection

---

### 💡 In short (Quick Recall)

* Logs must go to stdout/stderr (FD 1/2)
* Shell entrypoints without `exec` break logging
* Daemonized apps lose output
* File-based logging hides logs
* Foreground + exec form fixes most issues

----
## Q257: Docker stats shows **0% CPU usage** for an active container. Why?

### 🧠 Overview

`docker stats` shows **instantaneous CPU usage**. Seeing `0%` usually means the process is **idle at that moment**, **CPU-throttled**, or **running in a way Docker can’t sample properly**.

---

### 🔍 Common Reasons (Most → Least Likely)

#### 1️⃣ Application is mostly idle (MOST COMMON)

* Waiting on I/O, sleep, or external calls
* Short CPU bursts between samples

```bash
docker exec <c> ps -o pid,cmd,%cpu
```

📌 **Why**: `docker stats` samples over time; idle windows show `0%`

---

#### 2️⃣ CPU limits / throttling applied

```bash
docker inspect <c> | jq '.[0].HostConfig.NanoCpus'
```

* Very low CPU limit (e.g., `0.1 CPU`)
* Throttling → near-zero visible usage

📌 **K8s note**: CPU limits throttle, not kill

---

#### 3️⃣ Container uses multiple threads briefly

* Spikes happen too fast to catch

✔️ Use continuous view:

```bash
docker stats --no-stream=false
```

---

#### 4️⃣ Process runs in background / wrong PID

* Main PID is idle
* Work done by short-lived child processes

📌 **Fix**: Ensure main process does the work

---

#### 5️⃣ cgroup / runtime reporting issue

```bash
docker info | grep -i cgroup
```

* Rootless Docker
* cgroup v2 + older Docker
* Docker-in-Docker

📌 **Symptom**: CPU shows `0%` but host shows usage

---

#### 6️⃣ Docker Desktop (macOS/Windows)

* Stats reflect **VM-level sampling**
* Small workloads may show 0%

📌 **Important**: Not accurate for performance testing

---

### 🧪 How to Verify Real CPU Usage

```bash
top
htop
pidstat -p <pid>
```

Kubernetes:

```bash
kubectl top pod
```

---

### 🔒 Best Practices (Interview Gold)

* Don’t rely on `docker stats` for micro-bursts
* Use app-level metrics (Prometheus)
* Avoid ultra-low CPU limits
* Test performance on real Linux hosts

---

### 💡 In short (Quick Recall)

* `docker stats` is sampled, not continuous
* Idle or I/O-bound apps show 0%
* CPU limits throttle usage
* cgroup/runtime issues skew stats
* Docker Desktop stats are approximate

----
## Q258: A container’s `/etc/hosts` file is not being updated with linked containers. What’s wrong?

### 🧠 Overview

Docker **no longer updates `/etc/hosts` using links** in modern setups. **`--link` is deprecated**. On **user-defined networks**, Docker uses **embedded DNS**, not `/etc/hosts`.

---

### 🔍 What’s Actually Wrong

#### 1️⃣ You’re relying on **deprecated `--link`**

```bash
docker run --link db:db app   ❌
```

* Works only on legacy default bridge
* Not supported on user-defined networks
* `/etc/hosts` won’t update as expected

📌 **Root cause**: Links are deprecated and ignored in modern Docker networking

---

#### 2️⃣ You’re on a **user-defined bridge network**

```bash
docker network create my-net
```

* Docker uses **DNS-based service discovery**
* Containers resolve names via DNS, **not `/etc/hosts`**

📌 **Expected behavior**:

```bash
ping db   # works
cat /etc/hosts  # no db entry
```

---

#### 3️⃣ Containers started at different times

* `/etc/hosts` is written **only at container start**
* It is **not dynamically updated**

📌 **Why**: Docker does not hot-update `/etc/hosts`

---

### ✅ Correct Way (Modern Docker)

#### Use service/container names via DNS

```bash
docker run --network my-net --name db mysql
docker run --network my-net app
```

Inside `app`:

```bash
ping db   # resolves via Docker DNS
```

📌 **Why**: Built-in DNS replaces `/etc/hosts`

---

### ⚠️ What NOT to Do

* ❌ Expect `/etc/hosts` to auto-update
* ❌ Use `--link` in production
* ❌ Hardcode container IPs

---

### 🧪 Debug Commands

```bash
docker network inspect my-net
docker exec app nslookup db
cat /etc/hosts
```

---

### 🔒 Best Practices (Interview Gold)

* Use **user-defined networks**
* Rely on **DNS**, not `/etc/hosts`
* Treat container names as service endpoints
* Same concept applies in **Kubernetes (Services/DNS)**

---

### 💡 In short (Quick Recall)

* `--link` is deprecated
* `/etc/hosts` is static at container start
* Docker uses DNS on user-defined networks
* Service names replace host entries
* Same model as Kubernetes DNS

---

## Q259: BuildKit secrets are being exposed in image layers. How do you fix this?

### 🧠 Overview

Secrets leak when they’re passed via **`ARG`/`ENV`**, copied into the filesystem, or used outside **BuildKit secret mounts**. The fix is to **use `--mount=type=secret` correctly and keep secrets out of final layers**.

---

### ❌ What’s Wrong (Common Mistakes)

* Using `ARG` / `ENV` for secrets → ends up in image history
* Writing secrets to files during `RUN`
* Using secrets in the **final stage**
* Building without BuildKit enabled

---

### ✅ Correct Fix (Step-by-Step)

#### 1️⃣ Enable BuildKit (mandatory)

```bash
DOCKER_BUILDKIT=1 docker build .
```

---

#### 2️⃣ Use BuildKit secret mounts (NOT ARG/ENV)

```dockerfile
# syntax=docker/dockerfile:1.6
FROM alpine

RUN --mount=type=secret,id=npm_token \
    npm config set //registry.npmjs.org/:_authToken=$(cat /run/secrets/npm_token)
```

Build command:

```bash
docker build --secret id=npm_token,src=.npm_token .
```

📌 **Why**: Secrets are mounted at build-time only and never committed to layers

---

#### 3️⃣ Never persist secrets to disk

❌ Bad:

```dockerfile
RUN echo "$TOKEN" > token.txt
```

✔️ Good:

```dockerfile
RUN --mount=type=secret,id=token \
    some-command --token "$(cat /run/secrets/token)"
```

📌 **Rule**: Use secrets **only in-memory during the RUN step**

---

#### 4️⃣ Use multi-stage builds (VERY IMPORTANT)

```dockerfile
FROM builder AS build
RUN --mount=type=secret,id=token do-secure-thing

FROM scratch
COPY --from=build /app /app
```

📌 **Why**: Secrets stay in the builder stage only

---

#### 5️⃣ Verify secrets are not in image history

```bash
docker history my-image
docker inspect my-image
```

📌 **Expected**: No secret values visible

---

### 🔒 Best Practices (Interview Gold)

* ❌ Never use `ARG` / `ENV` for secrets
* ✅ Always use `--mount=type=secret`
* ✅ Multi-stage builds to isolate secrets
* ✅ Enable BuildKit explicitly in CI
* ✅ Scan image history before pushing

---

### 💡 In short (Quick Recall)

* Secrets leaked → wrong mechanism
* `ARG/ENV` = insecure
* Use BuildKit secret mounts
* Don’t write secrets to files
* Multi-stage builds keep images clean

---
## Q260: Docker Compose service discovery is not working between services. What configuration is missing?

### 🧠 Overview

Compose service discovery works **only when services share the same user-defined network**. If name resolution fails, the missing piece is almost always **a common network attachment** (or it’s being overridden).

---

### 🔍 What’s Missing / Wrong (Most → Least Common)

#### 1️⃣ Services are **not on the same network** (MOST COMMON)

```yaml
services:
  app:
    networks: [app-net]
  db:
    networks: [db-net]   # ❌ different network
```

✔️ Fix:

```yaml
networks:
  app-net:

services:
  app:
    networks: [app-net]
  db:
    networks: [app-net]
```

📌 **Why**: Docker DNS only resolves names within the same network.

---

#### 2️⃣ Custom network not defined / attached

If you reference a network but don’t define it:

```yaml
services:
  app:
    networks: [my-net]   # ❌ missing definition
```

✔️ Fix:

```yaml
networks:
  my-net:
```

---

#### 3️⃣ Using `container_name` breaks scaling & expectations

```yaml
container_name: my-db
```

📌 **Issue**: Service DNS name is the **service name**, not `container_name`.
✔️ Use `db` (service name) to connect, or remove `container_name`.

---

#### 4️⃣ Expecting `ports` / `expose` to enable discovery (they don’t)

* `ports`: host ↔ container only
* `expose`: documentation hint

📌 **Fix**: Use service name over the internal port:

```text
db:5432
```

---

#### 5️⃣ Using different Compose projects

* Different project names → different networks

📌 **Fix**:

```bash
docker compose -p myproj up
```

or ensure both services are in the **same compose file/project**.

---

#### 6️⃣ External network not attached to all services

```yaml
networks:
  shared:
    external: true
```

📌 **Fix**: Attach **every service** to `shared`.

---

#### 7️⃣ Profiles prevent a service from starting

```yaml
profiles: ["prod"]
```

📌 **Fix**:

```bash
docker compose --profile prod up
```

---

### 🧪 Quick Debug

```bash
docker compose ps
docker network inspect <project>_default
docker exec app nslookup db
```

---

### 🔒 Best Practices (Interview Gold)

* Rely on **service names**, not IPs
* Use one user-defined network per app
* Avoid `container_name` unless necessary
* Don’t use `depends_on` for networking (it’s not required)

---

### 💡 In short (Quick Recall)

* Missing **shared network**
* DNS works by **service name**
* `ports/expose` don’t enable discovery
* Same project = same network
* Profiles/external networks can block attachment

---
## Q261: A container built on one architecture won’t run on another. How do you handle multi-arch?

### 🧠 Overview

The failure is due to an **architecture mismatch** (e.g., `amd64` image on `arm64`). The fix is to **build and publish multi-arch images** using **Buildx** and **manifest lists**, or pull the correct platform explicitly.

---

### ✅ Correct Ways to Handle Multi-Arch

#### 1️⃣ Build multi-arch images with Buildx (BEST PRACTICE)

```bash
docker buildx create --use
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t myorg/myapp:1.0 \
  --push .
```

📌 **What it does**: Builds per-arch images and publishes a **manifest list**
📌 **Result**: Docker auto-pulls the correct image for the host

---

#### 2️⃣ Use `--platform` at run/pull time (local workaround)

```bash
docker run --platform linux/amd64 myorg/myapp:1.0
```

📌 **Why**: Forces emulation (QEMU) if needed
⚠️ **Note**: Slower; not ideal for prod

---

#### 3️⃣ Ensure binaries are built for each arch

**Go**

```bash
GOOS=linux GOARCH=arm64 go build -o app
```

**Node/Java**

* Use base images that support multi-arch (`alpine`, `distroless`, `ubi`)

📌 **Why**: Single-arch binaries break on other CPUs

---

#### 4️⃣ Avoid `latest` + floating base images

```dockerfile
FROM node:18-alpine   # multi-arch
```

📌 **Why**: Official images ship per-arch variants

---

### 🧪 Verify Architecture

```bash
docker image inspect myorg/myapp:1.0 | jq '.[0].Architecture'
uname -m
```

---

### ☸ Kubernetes Notes (Interview Gold)

* Nodes are arch-specific
* Scheduler pulls correct image from manifest
* Mixed-arch clusters **require multi-arch images**

---

### 🔒 Best Practices

* Always publish multi-arch images for public repos
* Use Buildx in CI/CD
* Test on both `amd64` and `arm64`
* Avoid emulation in production

---

### 💡 In short (Quick Recall)

* Problem = arch mismatch
* Fix = Buildx + multi-arch manifests
* `--platform` is a workaround
* Official images are multi-arch
* Required for EKS/AKS mixed nodes

---
## Q262: Docker **overlay2** storage driver is consuming excessive space. How do you troubleshoot?

### 🧠 Overview

`overlay2` grows due to **unused images/layers, writable container layers, build cache, and logs**. Troubleshoot from **what’s consuming space → why it’s retained → how to reclaim safely**.

---

### 🔍 Step-by-Step Troubleshooting

#### 1️⃣ Identify what’s actually using space

```bash
docker system df
docker system df -v
```

📌 **Why**: Breaks usage into images, containers, volumes, build cache

---

#### 2️⃣ Check `/var/lib/docker/overlay2` growth (Linux)

```bash
du -sh /var/lib/docker/*
du -sh /var/lib/docker/overlay2/*
```

📌 **Why**: Confirms overlay2 is the culprit vs volumes/logs

---

#### 3️⃣ Look for stopped containers holding layers

```bash
docker ps -a
```

📌 **Why**: Each stopped container keeps its writable layer

✔️ Cleanup:

```bash
docker container prune
```

---

#### 4️⃣ Remove unused images & dangling layers

```bash
docker image prune
docker image prune -a   # ⚠️ removes all unused images
```

📌 **Why**: Old tags and CI builds accumulate fast

---

#### 5️⃣ Clear BuildKit / build cache (VERY COMMON)

```bash
docker builder prune
docker builder prune -a
```

📌 **Why**: Multi-stage + frequent builds leave cache behind

---

#### 6️⃣ Check container logs (hidden disk hog)

```bash
ls -lh /var/lib/docker/containers/*/*.log
```

📌 **Why**: JSON logs can grow endlessly

✔️ Fix (log rotation):

```json
// /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

```bash
systemctl restart docker
```

---

#### 7️⃣ Writable layer abuse (anti-pattern)

* Apps writing to container FS instead of volumes
* Temp files, caches, uploads inside container

📌 **Fix**:

* Use **volumes** or external storage (S3, EFS)
* Keep containers **immutable**

---

#### 8️⃣ CI/CD causing image explosion

* Every pipeline builds new images
* No retention policy

📌 **Fix**:

* Prune on schedule
* Tag discipline
* Registry lifecycle policies (ECR/ACR)

---

### 🧪 Quick Safe Cleanup (Production-Friendly)

```bash
docker container prune
docker image prune
docker builder prune
```

⚠️ Avoid `docker system prune -a --volumes` blindly in prod.

---

### 🔒 Best Practices (Interview Gold)

* Enable **log rotation**
* Use **BuildKit** and prune cache regularly
* Don’t write data to container FS
* Monitor `/var/lib/docker`
* Use registry lifecycle rules

---

### 💡 In short (Quick Recall)

* `overlay2` grows from images, cache, logs, writable layers
* Use `docker system df -v`
* Prune containers, images, builder cache
* Rotate logs
* Containers should be stateless

---
## Q263: Container time is out of sync with host. How do you synchronize it?

### 🧠 Overview

Containers **do not manage time themselves**. They use the **host kernel clock**. If time is out of sync, the issue is **host time/NTP**, **VM clock drift**, or **Docker Desktop virtualization**—not the container.

---

### 🔍 What to Check & Fix (In Order)

#### 1️⃣ Verify host time & NTP (MOST IMPORTANT)

```bash
timedatectl
timedatectl status
```

* NTP must be **enabled and synced**

✔️ Fix:

```bash
sudo timedatectl set-ntp true
```

📌 **Why**: Containers inherit host kernel time

---

#### 2️⃣ Check time inside container

```bash
docker exec <container> date
```

📌 **If host time is wrong → container time will be wrong**

---

#### 3️⃣ Docker Desktop (macOS / Windows)

* Containers run inside a **VM**
* VM clock can drift after sleep/resume

✔️ Fix:

* Restart Docker Desktop
* Restart the VM / system

📌 **Common dev-machine issue**

---

#### 4️⃣ Kubernetes nodes out of sync

```bash
kubectl get nodes
ssh <node> date
```

✔️ Fix:

* Ensure NTP/chrony running on **all nodes**
* Use cloud time sync (AWS Time Sync Service)

---

#### 5️⃣ Avoid setting time inside containers (ANTI-PATTERN)

❌ Don’t do:

```bash
date -s "..."
```

📌 **Why**: Containers lack privilege; time changes won’t persist

---

#### 6️⃣ Timezone ≠ Time sync (common confusion)

If logs look wrong but time is correct → timezone issue.

✔️ Fix timezone separately:

```bash
-e TZ=UTC
```

---

### 🧪 Quick Validation

```bash
date
docker exec <c> date
```

Both should match (timezone aside).

---

### 🔒 Best Practices (Interview Gold)

* Keep **containers in UTC**
* Sync time at **host/node level**
* Never manage time inside containers
* Monitor node clock drift in prod

---

### 💡 In short (Quick Recall)

* Containers use **host kernel time**
* Fix **NTP on host**, not container
* Docker Desktop = VM clock drift
* K8s → all nodes must be time-synced
* Timezone ≠ clock sync

---
## Q264: Docker API version mismatch between client and server. How do you resolve this?

### 🧠 Overview

This happens when the **Docker CLI (client)** and **Docker Engine (server/daemon)** support different API versions. The fix is to **align versions** or **pin a compatible API version**.

---

### 🔍 Diagnose the Mismatch

#### Check client & server versions

```bash
docker version
```

Look for:

* **Client API version**
* **Server API version**

📌 **Error example**

```
client is newer than server (client API version: 1.43, server API version: 1.41)
```

---

### 🛠️ Ways to Fix (Best → Temporary)

#### 1️⃣ Upgrade Docker Engine (BEST FIX)

```bash
docker --version
sudo apt-get install docker-ce docker-ce-cli
```

📌 **Why**: Newer client features require newer daemon APIs

---

#### 2️⃣ Downgrade Docker CLI (if server can’t be upgraded)

* Common in CI agents or old servers

📌 **Why**: Client must be ≤ server API

---

#### 3️⃣ Pin API version via environment variable (WORKAROUND)

```bash
export DOCKER_API_VERSION=1.41
```

📌 **Why**: Forces client to use a compatible API
⚠️ **Note**: Newer CLI features may not work

---

#### 4️⃣ CI/CD containers using Docker socket (VERY COMMON)

```bash
-v /var/run/docker.sock:/var/run/docker.sock
```

📌 **Issue**:

* Host Docker is old
* Build container uses newer Docker CLI

✔️ Fix:

* Match CLI image to host version

```bash
docker:20.10
```

---

#### 5️⃣ Docker Desktop vs Remote Engine

* Local CLI talking to remote daemon via `DOCKER_HOST`

📌 **Fix**:

```bash
docker context ls
docker context use default
```

---

### 🧪 Quick Validation

```bash
docker version
echo $DOCKER_API_VERSION
```

---

### 🔒 Best Practices (Interview Gold)

* Keep Docker CLI & Engine in sync
* Don’t mix very old daemons with new CLIs
* Pin Docker versions in CI images
* Avoid relying on `DOCKER_API_VERSION` long-term

---

### 💡 In short (Quick Recall)

* Client & server API versions must be compatible
* Upgrade daemon if possible
* Downgrade CLI if needed
* `DOCKER_API_VERSION` is a workaround
* Common in CI with docker.sock mounts

---

## Q265: A container has orphaned processes after the main process exits. How do you handle **PID 1**?

### 🧠 Overview

In containers, **PID 1 has special responsibilities** (signal handling + child reaping). Orphaned processes happen when PID 1 **doesn’t reap zombies or forward signals**.

---

### 🔍 What’s Going Wrong

* PID 1 is a **shell script** that doesn’t `exec`
* App **forks child processes** and exits
* No **init system** to reap zombies
* SIGTERM not forwarded → forced SIGKILL

---

### ✅ Correct Ways to Handle PID 1

#### 1️⃣ Use `exec` in entrypoint scripts (MOST IMPORTANT)

```sh
#!/bin/sh
exec myapp
```

📌 **Why**: Replaces shell with app → app becomes PID 1

---

#### 2️⃣ Use an init process (`tini`) (BEST PRACTICE)

```dockerfile
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["myapp"]
```

or runtime:

```bash
docker run --init my-image
```

📌 **Why**: Proper signal handling + zombie reaping

---

#### 3️⃣ Avoid daemonizing inside containers

* Don’t use `-d`, `--daemon`
* Run in foreground

📌 **Why**: Daemons detach and leave children behind

---

#### 4️⃣ Handle signals properly in the app

* Trap `SIGTERM`, `SIGINT`
* Graceful shutdown

📌 **Example (bash)**

```sh
trap "cleanup; exit" SIGTERM SIGINT
```

---

#### 5️⃣ Kubernetes-specific fix

```yaml
spec:
  containers:
    - name: app
      command: ["/sbin/tini","--","myapp"]
```

📌 **Why**: Prevents zombie accumulation in pods

---

### 🧪 Debug Commands

```bash
ps -ef
docker inspect <c> | jq '.[0].Config.Entrypoint'
```

---

### 🔒 Best Practices (Interview Gold)

* PID 1 must reap zombies
* Always use exec-form ENTRYPOINT
* Prefer `tini` or `--init`
* One process per container

---

### 💡 In short (Quick Recall)

* PID 1 is special in containers
* Shell scripts without `exec` cause zombies
* Use `tini` or `docker --init`
* Run apps in foreground
* Handle SIGTERM properly

----
## Q266: Docker build is not respecting `.dockerignore`. What would you verify?

### 🧠 Overview

`.dockerignore` is applied **only to the build context sent to the daemon**. If files are still included, it’s usually a **context path, file location, syntax, or tooling issue**.

---

### 🔍 What to Verify (In Order)

#### 1️⃣ `.dockerignore` location (MOST COMMON)

* Must be in the **root of the build context**

```bash
docker build <context>
```

📌 If you run `docker build ./app`, `.dockerignore` must be in `./app/`.

---

#### 2️⃣ Correct build context is used

```bash
docker build .
docker build ./subdir   # different context
```

📌 **Why**: `.dockerignore` outside the context is ignored.

---

#### 3️⃣ Syntax & patterns are correct

```dockerignore
node_modules/
*.log
dist/**
```

* No leading `/`
* Paths are **relative to context**
* Globs must match actual paths

📌 **Common mistake**: `./node_modules` ❌

---

#### 4️⃣ Files are copied explicitly later

```dockerfile
COPY . .
COPY --from=builder / /app
```

📌 `.dockerignore` only filters the **initial context**, not files copied from other stages or external sources.

---

#### 5️⃣ `.dockerignore` is not itself ignored

```dockerignore
.dockerignore ❌
```

📌 If ignored, Docker won’t read it.

---

#### 6️⃣ BuildKit vs classic builder behavior

```bash
DOCKER_BUILDKIT=1 docker build .
```

📌 Ensure you’re not mixing old Docker versions or remote builders with different contexts.

---

#### 7️⃣ Case sensitivity & OS differences

* Linux is case-sensitive
* macOS/Windows may hide mismatches

📌 `Node_Modules/` ≠ `node_modules/`

---

#### 8️⃣ CI/CD checkout paths

* Repo checked out into subfolder
* Build context differs from local

📌 Verify:

```bash
pwd
ls
docker build .
```

---

### 🧪 How to Confirm What’s Sent

```bash
docker build --progress=plain .
```

Look for:

```
Sending build context to Docker daemon  1.2GB
```

📌 If size is large → `.dockerignore` not applied correctly.

---

### 🔒 Best Practices (Interview Gold)

* Always pair `.dockerignore` with `COPY`-specific paths
* Avoid `COPY . .` in large repos
* Keep Dockerfile + `.dockerignore` at context root
* Validate context size in CI

---

### 💡 In short (Quick Recall)

* `.dockerignore` applies to **build context only**
* Must live at **context root**
* Patterns are relative (no `./`)
* Explicit COPY can still bring files
* Verify with `--progress=plain`

----
## Q267: Container cannot resolve **external DNS** but can resolve **container names**. What’s wrong?

### 🧠 Overview

This means **Docker’s internal DNS is working**, but **upstream DNS or outbound networking is broken**. Service discovery works; internet name resolution does not.

---

### 🔍 What’s Wrong (Most → Least Common)

#### 1️⃣ Upstream DNS server is unreachable (MOST COMMON)

```bash
docker exec app cat /etc/resolv.conf
docker exec app nslookup google.com
```

* `/etc/resolv.conf` points to Docker DNS (e.g., `127.0.0.11`)
* Docker DNS can’t reach host/upstream resolvers

📌 **Root cause**: Host DNS misconfigured or blocked

---

#### 2️⃣ Host firewall / network blocks UDP/TCP 53

* Outbound DNS blocked by:

  * `iptables` / `firewalld`
  * Corporate firewall
  * Cloud SG/NACL

📌 **Symptom**: Container → names fail; container-to-container works

---

#### 3️⃣ Docker daemon DNS config is wrong

```bash
cat /etc/docker/daemon.json
```

📌 **Fix**

```json
{
  "dns": ["8.8.8.8", "1.1.1.1"]
}
```

```bash
systemctl restart docker
```

---

#### 4️⃣ No outbound NAT / gateway on the network

```bash
docker network inspect my-net
```

* Custom bridge missing gateway
* `--network none` attached accidentally

📌 **Fix**: Use default bridge or recreate network with IPAM

---

#### 5️⃣ Corporate proxy not configured

* Internal names resolve
* External domains require proxy

📌 **Fix**

```bash
docker run -e HTTP_PROXY -e HTTPS_PROXY app
```

---

#### 6️⃣ Kubernetes NetworkPolicy (if applicable)

```bash
kubectl get networkpolicy
```

📌 **Issue**: Egress denied → DNS blocked

---

### 🧪 Quick Debug Flow

```bash
nslookup db           # works (Docker DNS)
nslookup google.com  # fails
ping 8.8.8.8         # check raw connectivity
```

---

### 🔒 Best Practices (Interview Gold)

* Docker DNS (`127.0.0.11`) ≠ internet DNS
* Ensure host DNS & outbound rules are correct
* Explicitly set DNS in `daemon.json` for prod
* In K8s, always allow DNS egress

---

### 💡 In short (Quick Recall)

* Internal DNS works → Docker network OK
* External DNS fails → upstream DNS / egress issue
* Check host DNS, firewall, NAT
* Fix via daemon DNS or outbound rules

---

## Q268: A **tmpfs** mount is not providing the expected performance. What would you check?

### 🧠 Overview

`tmpfs` is memory-backed. If it’s slow, the problem is usually **size limits, memory pressure, swapping, NUMA, or I/O patterns**—not the filesystem itself.

---

### 🔍 What to Check (In Order)

#### 1️⃣ tmpfs size & mount options (MOST COMMON)

```bash
mount | grep tmpfs
```

* Default size may be **too small**
* Hitting the limit causes stalls/fallback behavior

✔️ Fix:

```bash
docker run --tmpfs /data:rw,size=1g my-image
```

---

#### 2️⃣ Container memory limits / cgroup pressure

```bash
docker inspect <c> | jq '.[0].HostConfig.Memory'
docker stats
```

* tmpfs counts against **container memory**
* Near limits → reclaim/thrashing → slow ops

✔️ Fix: Increase memory limit or tmpfs size accordingly.

---

#### 3️⃣ Swapping enabled on host (big perf killer)

```bash
swapon --show
cat /proc/sys/vm/swappiness
```

* tmpfs pages can be **swapped out**

✔️ Fix:

```bash
sysctl vm.swappiness=1
```

or disable swap for nodes running containers.

---

#### 4️⃣ Page cache vs tmpfs confusion

* tmpfs ≠ page cache
* Apps doing heavy `fsync()` or sync writes negate benefits

📌 **Check**: App write patterns (small sync writes hurt).

---

#### 5️⃣ NUMA / CPU pinning effects (advanced)

* Memory allocated on remote NUMA node

✔️ Check:

```bash
numactl --hardware
```

📌 **Fix**: Align CPU/memory or avoid strict pinning.

---

#### 6️⃣ tmpfs used for large files (anti-pattern)

* tmpfs is best for **small, hot data**
* Large datasets → memory pressure

📌 **Fix**: Use volumes + page cache, not tmpfs.

---

#### 7️⃣ Docker Desktop / VM overhead (macOS/Windows)

* tmpfs runs **inside the VM**
* VM memory pressure reduces performance

📌 **Fix**: Increase Docker Desktop VM memory.

---

### 🧪 Quick Validation

```bash
df -h /data
free -h
vmstat 1
```

---

### 🔒 Best Practices (Interview Gold)

* Size tmpfs explicitly
* Ensure enough container memory
* Avoid swap
* Use tmpfs for small, latency-sensitive files
* Don’t fsync aggressively

---

### 💡 In short (Quick Recall)

* tmpfs speed drops with memory pressure
* Size limits matter
* Swap kills tmpfs performance
* Large writes ≠ good use case
* VM limits affect Docker Desktop

---
## Q269: Docker `system df` shows large **Build Cache** usage. How do you clean it safely?

### 🧠 Overview

Build cache grows from **BuildKit layers** created during `docker build`. You clean it using **builder prune**, starting conservatively and only escalating if needed.

---

### ✅ Safe Cleanup (Recommended Order)

#### 1️⃣ Check detailed cache usage

```bash
docker system df -v
```

📌 **Why**: Confirms cache size vs images/containers

---

#### 2️⃣ Remove unused build cache (SAFE)

```bash
docker builder prune
```

* Removes **dangling / unused** cache only
* Keeps cache needed by recent builds

📌 **Best first step**

---

#### 3️⃣ Remove all build cache (AGGRESSIVE)

```bash
docker builder prune -a
```

⚠️ **Impact**: Next builds will be slower
✔️ Use in CI agents or disk pressure scenarios

---

#### 4️⃣ Target cache by age (BEST PRACTICE)

```bash
docker builder prune --filter until=24h
```

📌 **Why**: Keeps hot cache, removes stale layers

---

### 🔒 Production Safety Tips

* Avoid `docker system prune -a --volumes`
* Clean **builder cache only**, not images/volumes
* Run during low-traffic windows

---

### 🧪 Verification

```bash
docker system df
```

---

### 🔁 Automate Safely (CI / Cron)

```bash
docker builder prune --filter until=168h -f
```

---

### 💡 In short (Quick Recall)

* Build cache ≠ images
* Use `docker builder prune`
* Start without `-a`
* Use time-based filters
* Don’t touch volumes blindly

----
## Q270: Container labels are not being applied despite being defined in the Dockerfile. How do you debug this?

### 🧠 Overview

Dockerfile `LABEL`s apply to the **image**, but containers may **override, hide, or never inherit them** due to build, run, or orchestration overrides. Debug from **image → container → orchestration layer**.

---

### 🔍 Debug Checklist (Step-by-Step)

#### 1️⃣ Verify labels exist on the **image** (MOST IMPORTANT)

```bash
docker inspect my-image | jq '.[0].Config.Labels'
```

📌 **If missing** → image wasn’t rebuilt or Dockerfile not used.

✔️ Fix:

```bash
docker build --no-cache -t my-image .
```

---

#### 2️⃣ Confirm correct Dockerfile is used

```bash
docker build -f Dockerfile.prod .
```

📌 **Common mistake**: Editing one Dockerfile, building another.

---

#### 3️⃣ Check for label overrides at runtime

```bash
docker run --label env=prod my-image
```

📌 **Note**:

* Runtime labels **add/override**
* They don’t remove image labels unless duplicated keys exist

---

#### 4️⃣ Docker Compose overrides image labels

```yaml
services:
  app:
    labels:
      env: prod
```

📌 **Behavior**:

* Compose **merges labels**
* Same key → Compose wins

---

#### 5️⃣ Kubernetes ignores Dockerfile labels

```yaml
metadata:
  labels:
    app: my-app
```

📌 **Important**:

* K8s uses **Pod labels**, not image labels
* Image labels are **not propagated**

---

#### 6️⃣ CI/CD is using a cached image

```bash
docker images | grep my-image
```

📌 **Fix**:

* Bump tag
* Disable cache in CI

```bash
docker build --no-cache
```

---

#### 7️⃣ Label syntax error in Dockerfile

```dockerfile
LABEL version=1.0 \
      maintainer="team@example.com"
```

📌 **Common issue**: Invalid quoting or line continuation

---

### 🧪 Verify on Running Container

```bash
docker inspect <container> | jq '.[0].Config.Labels'
```

---

### 🔒 Best Practices (Interview Gold)

* Use labels for **metadata**, not runtime behavior
* Standardize keys (`org.opencontainers.image.*`)
* Don’t rely on image labels in Kubernetes
* Always verify with `docker inspect`

---

### 💡 In short (Quick Recall)

* Labels live on **images**
* Rebuild image to apply Dockerfile labels
* Compose can override labels
* K8s ignores image labels
* Cache/tag issues are common
