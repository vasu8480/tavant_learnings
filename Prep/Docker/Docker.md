# Docker

Below is your **README-style technical documentation** for **Q1–Q20 (Docker Basics)**.

---

## Q1: What is Docker and what problems does it solve?

🧠 **Overview**
Docker is a containerization platform that packages applications and dependencies into portable, lightweight units called *containers*. It solves problems like environment drift, dependency conflicts, and manual configuration inconsistencies across dev/stage/prod.

⚙️ **Purpose / How it works**

* Uses container runtimes (containerd) + Linux namespaces/cgroups.
* Ensures reproducible builds and consistent deployments across environments.

🧩 **Example**

```bash
docker build -t myapp:v1 .
docker run -p 8080:8080 myapp:v1
```

✅ **Best Practices**

* Keep images small (multi-stage builds).
* Pin versions (`FROM node:18-alpine`).

💡 **In short:** Docker provides consistent, reproducible environments, reducing “works on my machine” issues.

---

## Q2: What is the difference between a container and a virtual machine?

🧠 **Overview**
VMs virtualize hardware; containers virtualize the OS. Containers are faster, smaller, and ideal for microservices.

📋 **Comparison Table**

| Feature   | Containers           | Virtual Machines |
| --------- | -------------------- | ---------------- |
| Boots     | Seconds              | Minutes          |
| Size      | MBs                  | GBs              |
| Isolation | Process-level        | Full OS          |
| Use case  | Microservices, CI/CD | Heavy workloads  |

💡 **In short:** Containers share the host OS; VMs require full OS virtualization.

---

## Q3: What is a Docker image?

🧠 **Overview**
A Docker image is a read-only template that defines the filesystem and configuration required to run a container.

🧩 **Example**

```bash
docker pull nginx:latest
docker images
```

💡 **In short:** An image = blueprint for containers.

---

## Q4: What is a Docker container?

🧠 **Overview**
A container is a running instance of an image — isolated, lightweight, and portable.

🧩 **Example**

```bash
docker run -d --name web nginx
```

💡 **In short:** Container = runtime; Image = template.

---

## Q5: What is the difference between an image and a container?

📋 **Comparison**

| Aspect     | Image     | Container              |
| ---------- | --------- | ---------------------- |
| State      | Static    | Dynamic                |
| Type       | Template  | Runtime instance       |
| Mutability | Immutable | Can write (layered FS) |

💡 **In short:** Image = immutable blueprint; Container = actual execution environment.

---

## Q6: What is a Dockerfile?

🧠 **Overview**
A Dockerfile is the build script defining instructions to create an image.

🧩 **Example**

```Dockerfile
FROM python:3.10
COPY app.py /app/
CMD ["python", "/app/app.py"]
```

💡 **In short:** A Dockerfile automates image creation.

---

## Q7: What is the purpose of the FROM instruction in a Dockerfile?

🧠 **Overview**
Defines the **base image** from which your image inherits.

🧩 **Example**

```Dockerfile
FROM node:18-alpine
```

💡 **In short:** It sets the starting point for the build.

---

## Q8: What does the RUN instruction do in a Dockerfile?

🧠 **Overview**
Executes commands **during the image build** (e.g., installing packages).

🧩 **Example**

```Dockerfile
RUN apk add --no-cache curl
```

💡 **In short:** RUN modifies the image’s filesystem at build time.

---

## Q9: What is the difference between CMD and ENTRYPOINT?

📋 **Comparison**

| Feature      | CMD                   | ENTRYPOINT                |
| ------------ | --------------------- | ------------------------- |
| Purpose      | Default command       | Mandatory entry process   |
| Overridable? | Yes, via `docker run` | Partially / args appended |
| Typical use  | Run scripts           | Start main app            |

🧩 **Example**

```Dockerfile
ENTRYPOINT ["python"]
CMD ["app.py"]
```

💡 **In short:** ENTRYPOINT = executable; CMD = default arguments.

---

## Q10: What is the COPY instruction used for?

🧠 **Overview**
Used to copy local files/directories into the container filesystem.

🧩 **Example**

```Dockerfile
COPY requirements.txt /app/
```

---

## Q11: What is the difference between COPY and ADD?

📋 **Comparison**

| Feature          | COPY | ADD              |
| ---------------- | ---- | ---------------- |
| Basic copy       | Yes  | Yes              |
| Remote URLs      | ❌ No | ✅ Yes            |
| Auto-extract tar | ❌ No | ✅ Yes            |
| Recommended?     | Yes  | Only when needed |

💡 **In short:** Use COPY for consistency; ADD only for tar extraction or URLs.

---

## Q12: What is the WORKDIR instruction?

🧠 **Overview**
Sets the working directory for subsequent Dockerfile instructions.

🧩 **Example**

```Dockerfile
WORKDIR /app
```

💡 **In short:** It avoids using `cd` in Dockerfile.

---

## Q13: What does the EXPOSE instruction do?

🧠 **Overview**
Documents which ports the container listens on (for tools like Compose).

🧩 **Example**

```Dockerfile
EXPOSE 8080
```

⚠️ Note: **Does not actually publish the port**.

💡 **In short:** Metadata only; publish using `-p`.

---

## Q14: What is the ENV instruction used for?

🧠 **Overview**
Sets environment variables inside the image/container.

🧩 **Example**

```Dockerfile
ENV APP_ENV=production
```

---

## Q15: What is Docker Hub?

🧠 **Overview**
Docker Hub is a public registry hosting container images (official & custom).

🧩 **Example**

* Images like `nginx`, `redis`, `ubuntu` come from Docker Hub.

---

## Q16: How do you pull an image from Docker Hub?

🧩 **Command**

```bash
docker pull nginx:latest
```

---

## Q17: How do you run a Docker container?

🧩 **Command**

```bash
docker run -d -p 80:80 --name web nginx
```

---

## Q18: What does docker ps command do?

🧠 **Overview**
Shows running containers.

🧩 **Command**

```bash
docker ps
```

---

## Q19: What is the difference between docker ps and docker ps -a?

📋 **Comparison**

| Command        | Shows                              |
| -------------- | ---------------------------------- |
| `docker ps`    | Running containers                 |
| `docker ps -a` | All containers (stopped + running) |

---

## Q20: How do you stop a running container?

🧩 **Command**

```bash
docker stop <container_id>
```

Example:

```bash
docker stop web
```

---

Below is your **README-style DevOps documentation** for **Q21–Q40 (Docker Basics Continued)**.

---

## Q21: How do you remove a container?

🧩 **Command**

```bash
docker rm <container_id>
```

Force remove (running containers):

```bash
docker rm -f <container_id>
```

💡 **In short:** `docker rm` deletes stopped containers; use `-f` to force.

---

## Q22: How do you remove a Docker image?

🧩 **Command**

```bash
docker rmi <image_id>
```

Remove unused images:

```bash
docker image prune -a
```

💡 **In short:** `docker rmi` removes images; prune clears unused layers.

---

## Q23: What is the docker build command used for?

🧠 **Overview**
Builds a Docker image from a Dockerfile and directory context.

🧩 **Example**

```bash
docker build -t myapp:v1 .
```

💡 **In short:** Converts a Dockerfile → Docker image.

---

## Q24: What is a Docker tag?

🧠 **Overview**
A tag is a label assigned to an image version (e.g., `latest`, `v1.0.1`).

💡 **In short:** Tags differentiate versions of the same image.

---

## Q25: How do you tag a Docker image?

🧩 **Command**

```bash
docker tag SOURCE_IMAGE TARGET_IMAGE
```

Example:

```bash
docker tag myapp:latest myrepo/myapp:v1
```

---

## Q26: What is the docker exec command used for?

🧠 **Overview**
Allows running commands **inside a running container** (debugging, inspections).

🧩 **Example**

```bash
docker exec -it web bash
```

💡 **In short:** Exec = interactive shell or command inside a container.

---

## Q27: How do you view logs from a Docker container?

🧩 **Command**

```bash
docker logs <container_id>
```

Follow logs:

```bash
docker logs -f web
```

---

## Q28: What is port mapping in Docker?

🧠 **Overview**
It exposes a container's internal port to the host so apps inside containers are accessible externally.

📌 Example scenario: Exposing a Node.js app on port 8080.

💡 **In short:** Maps container port → host port.

---

## Q29: How do you map container ports to host ports?

🧩 **Command**

```bash
docker run -p <host_port>:<container_port> image
```

Example:

```bash
docker run -p 8080:3000 myapp
```

---

## Q30: What is a Docker volume?

🧠 **Overview**
Volumes provide persistent storage independent of container lifecycle.

💡 **In short:** Data stored in volumes survives container deletion.

---

## Q31: Why would you use Docker volumes?

⚙️ Use Cases

* Persistent DB data (MySQL, PostgreSQL).
* Avoid losing logs/configs when containers restart.
* Share data between containers safely.
* Better performance & isolation vs bind mounts.

---

## Q32: What is the difference between volumes and bind mounts?

📋 **Comparison Table**

| Feature     | Volumes            | Bind Mounts                 |
| ----------- | ------------------ | --------------------------- |
| Location    | Managed by Docker  | Direct host path            |
| Security    | Safer, isolated    | Depends on host permissions |
| Portability | High               | Low                         |
| Use case    | DB data, prod apps | Local development           |

💡 **In short:** Volumes = Docker-managed storage; Bind mounts = host path mapping.

---

## Q33: How do you create a Docker volume?

🧩 **Command**

```bash
docker volume create myvol
```

Using volume in a container:

```bash
docker run -v myvol:/data nginx
```

---

## Q34: What is Docker Compose?

🧠 **Overview**
A tool for defining and running multi-container applications using a YAML file (`docker-compose.yml`).

⚙️ Helps with:

* Running microservices locally
* Defining networks, volumes, services
* Simplifying multi-container orchestration

---

## Q35: What is the purpose of a docker-compose.yml file?

🧠 **Overview**
Defines services, networks, volumes, environment variables, and build/run configuration for multi-container applications.

🧩 **Example**

```yaml
services:
  web:
    image: nginx
    ports:
      - "80:80"
```

💡 **In short:** Infrastructure-as-code for local Docker environments.

---

## Q36: How do you start services defined in docker-compose.yml?

🧩 **Command**

```bash
docker-compose up
```

Detached mode:

```bash
docker-compose up -d
```

---

## Q37: What is the difference between docker-compose up and docker-compose start?

📋 **Comparison Table**

| Command                | Action                                             |
| ---------------------- | -------------------------------------------------- |
| `docker-compose up`    | Creates containers, builds images, starts services |
| `docker-compose start` | Starts already created containers only             |

💡 **In short:** `up` = create + start; `start` = start existing only.

---

## Q38: How do you scale services in Docker Compose?

🧩 **Command**

```bash
docker-compose up --scale web=3 -d
```

💡 **In short:** Use `--scale <service>=<count>`.

---

## Q39: What is a Docker network?

🧠 **Overview**
A Docker network enables communication between containers or between containers and external systems.

Types include bridge, host, overlay, MACVLAN.

💡 **In short:** Networking layer that lets containers talk to each other.

---

## Q40: What are the default Docker network types?

📋 **Types**

| Network    | Description                                     |
| ---------- | ----------------------------------------------- |
| **bridge** | Default for standalone containers; provides NAT |
| **host**   | Shares host network namespace                   |
| **none**   | Completely disables networking                  |

Example:

```bash
docker network ls
```

---

# Intermediate

Below is your **README-style DevOps documentation** for **Q41–Q63 (Intermediate Docker)**.

---

## Q41: What is the Docker daemon?

🧠 **Overview**
The Docker daemon (`dockerd`) is the background service that manages containers, images, networks, and volumes. It executes all Docker commands sent by the client.

⚙️ **Purpose**

* Build and run containers
* Manage images & networks
* Handle API requests

💡 **In short:** `dockerd` = the engine that performs all Docker operations.

---

## Q42: What is the Docker client?

🧠 **Overview**
The Docker client is the CLI (`docker`) that users interact with. It sends API requests to the Docker daemon.

🧩 **Example**

```bash
docker run nginx
```

💡 **In short:** Client = UI; Daemon = backend.

---

## Q43: How does the Docker client communicate with the daemon?

🧠 **Overview**
Communication happens over a **REST API**, via:

* Unix socket (`/var/run/docker.sock`) — default
* TCP socket (remote daemon)

💡 **In short:** Client ↔ Daemon via REST API over sockets.

---

## Q44: What is the Docker registry?

🧠 **Overview**
A Docker registry is a storage system that hosts Docker images (public or private).

Examples: Docker Hub, ECR, GCR, private registry.

💡 **In short:** Registry = image repository service.

---

## Q45: What is the difference between Docker Hub and a private registry?

📋 **Comparison**

| Feature    | Docker Hub        | Private Registry             |
| ---------- | ----------------- | ---------------------------- |
| Visibility | Public by default | Fully controlled             |
| Security   | Shared infra      | Enterprise-grade isolation   |
| Cost       | Free/premium      | Self-hosted or cloud-managed |
| Use case   | Open images       | Internal apps, compliance    |

💡 **In short:** Hub = public; private registry = self-controlled + secure.

---

## Q46: How do you set up a private Docker registry?

🧩 **Command**

```bash
docker run -d -p 5000:5000 --name registry registry:2
```

Push example:

```bash
docker tag myapp localhost:5000/myapp
docker push localhost:5000/myapp
```

---

## Q47: What is Docker Content Trust?

🧠 **Overview**
Docker Content Trust (DCT) ensures image integrity and authenticity using digital signatures.

💡 **In short:** Prevents running unverified/tampered images.

---

## Q48: How do you sign and verify Docker images?

🧩 **Enable DCT**

```bash
export DOCKER_CONTENT_TRUST=1
```

🧩 **Sign an image**

```bash
docker trust sign myrepo/myimage:latest
```

🧩 **Verify**

```bash
docker trust inspect --pretty myrepo/myimage:latest
```

---

## Q49: What are Docker image layers?

🧠 **Overview**
Layers are stacked filesystem changes created from each Dockerfile instruction. They allow caching, deduplication, and efficient distribution.

💡 **In short:** Each instruction = a new readonly layer.

---

## Q50: How does layer caching work in Docker?

🧠 **Overview**
Docker reuses previously built layers if:

* The instruction hasn’t changed
* The content hasn’t changed

⚙️ Improves build speed & reduces storage.

---

## Q51: What is the difference between ADD and COPY for layer optimization?

📋 **Comparison**

| Feature         | COPY   | ADD                                     |
| --------------- | ------ | --------------------------------------- |
| Predictability  | High   | Lower (auto-extract tar)                |
| Cache stability | Better | Worse (tar extraction changes checksum) |

💡 **In short:** COPY is more cache-friendly.

---

## Q52: How do you optimize Dockerfile layer caching?

✅ **Best Practices**

* Order instructions from least → most frequently changing
* Use multi-stage builds
* Combine RUN commands
* Use `.dockerignore`
* Pin dependencies

🧩 **Example**

```Dockerfile
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
```

---

## Q53: What is a multi-stage build in Docker?

🧠 **Overview**
A technique where multiple `FROM` instructions are used to create separate build and runtime stages.

🧩 **Example**

```Dockerfile
FROM golang:1.21 AS builder
RUN go build -o app .

FROM alpine
COPY --from=builder /app /app
CMD ["/app"]
```

💡 **In short:** Build heavy → copy minimal artifacts.

---

## Q54: Why would you use multi-stage builds?

⚙️ **Benefits**

* Smaller final images
* Remove build tools (gcc, go, npm)
* Secure & optimized production images

---

## Q55: How do multi-stage builds reduce image size?

🧠 **Overview**
Only the final stage is included in the final image, dropping all build layers and dependencies.

💡 **In short:** Final image contains only runtime binaries — no build artifacts.

---

## Q56: What is the .dockerignore file?

🧠 **Overview**
A file specifying paths to exclude from the Docker build context (like `.gitignore`).

🧩 **Example**

```
node_modules
.git
logs/
*.tmp
```

---

## Q57: How does .dockerignore improve build performance?

⚙️ **Benefits**

* Reduces context size
* Improves caching
* Avoids sending unnecessary files to the daemon

💡 **In short:** Smaller context → faster builds.

---

## Q58: What is the ARG instruction in Dockerfile?

🧠 **Overview**
Defines variables available **at build time** only.

🧩 **Example**

```Dockerfile
ARG APP_VERSION=1.0
RUN echo $APP_VERSION
```

---

## Q59: What is the difference between ARG and ENV?

📋 **Comparison**

| Feature               | ARG                     | ENV             |
| --------------------- | ----------------------- | --------------- |
| Scope                 | Build time only         | Build + runtime |
| Visible in container? | No                      | Yes             |
| Default usage         | Build secrets, versions | App configs     |

💡 **In short:** ARG = build-time; ENV = runtime.

---

## Q60: How do you pass build-time variables to Docker build?

🧩 **Command**

```bash
docker build --build-arg APP_VERSION=2.0 .
```

---

## Q61: What are Docker build contexts?

🧠 **Overview**
The **build context** is the directory sent to the daemon during `docker build`.
Dockerfile instructions like `COPY` work **inside this context only**.

💡 **In short:** Context = files available to the Docker build.

---

## Q62: What is the difference between ENTRYPOINT and CMD?

📋 **Comparison Table**

| Feature      | ENTRYPOINT                  | CMD               |
| ------------ | --------------------------- | ----------------- |
| Purpose      | Main executable             | Default arguments |
| Overridable? | Harder (only args replaced) | Fully overridable |
| Ideal use    | Long-running processes      | Optional defaults |

🧩 **Example**

```Dockerfile
ENTRYPOINT ["python"]
CMD ["app.py"]
```

---

## Q63: How do you override CMD at runtime?

🧩 **Command**

```bash
docker run myimage echo "Hello"
```

🧩 **Dockerfile**

```Dockerfile
CMD ["app.py"]
```

Runtime override:

```
docker run app_image python server.py
```

💡 **In short:** Anything you append to `docker run` replaces CMD.

---

Below is your **README-style technical documentation** for **Q64–Q87 (Advanced Docker Networking, Storage & Health Checks)**.

---

## Q64: How do you override ENTRYPOINT at runtime?

🧩 **Command**

```bash
docker run --entrypoint <new_command> myimage
```

Example:

```bash
docker run --entrypoint bash myimage
```

💡 **In short:** Use `--entrypoint` to replace ENTRYPOINT at runtime.

---

## Q65: What is the SHELL instruction in Dockerfile?

🧠 **Overview**
Defines the default shell used for `RUN` commands in Windows or Linux images.

🧩 **Example**

```Dockerfile
SHELL ["/bin/bash", "-c"]
```

💡 **In short:** Customizes the shell interpreter for subsequent commands.

---

## Q66: What are Docker bridge networks?

🧠 **Overview**
The default local network mode for containers. Bridge networks provide NAT-based networking allowing containers to communicate internally while being isolated from the host.

🧩 **Example**

```bash
docker network create mybridge
```

---

## Q67: What are Docker host networks?

🧠 **Overview**
The container **shares the host network namespace** — no NAT, no isolation.

⚠️ Use carefully; high-performance networking, less isolation.

🧩 **Example**

```bash
docker run --network host nginx
```

---

## Q68: What are Docker overlay networks?

🧠 **Overview**
Overlay networks enable communication between containers across **multiple Docker hosts**, used mainly in Docker Swarm or multi-host setups.

💡 **In short:** Cluster-wide virtual network.

---

## Q69: When would you use overlay networks?

⚙️ **Use cases**

* Multi-host container communication
* Docker Swarm services
* Distributed microservices
* Clustered databases

💡 **In short:** Use when containers need cross-node communication.

---

## Q70: What is the none network in Docker?

🧠 **Overview**
A network mode that **disables all networking** for a container.

🧩 **Example**

```bash
docker run --network none alpine
```

💡 **In short:** Isolated containers with no network access.

---

## Q71: How do containers communicate on the same network?

🧠 **Overview**
They communicate using Docker-internal DNS. Containers can reach each other by **service name or container name**.

🧩 **Example**

```bash
curl http://app2:8080
```

---

## Q72: How do you connect a container to multiple networks?

🧩 **Command**

```bash
docker network connect <network> <container>
```

Example:

```bash
docker network connect backend web
```

---

## Q73: What is Docker DNS and how does it work?

🧠 **Overview**
Docker provides an internal DNS resolver for containers on user-defined networks. It automatically registers container names as DNS entries.

⚙️ **How it works**

* Each service/container gets a DNS entry
* DNS is managed via Docker's embedded DNS server
* Works only on user-defined networks

💡 **In short:** Docker DNS provides service discovery inside networks.

---

## Q74: How do you create a custom Docker network?

🧩 **Command**

```bash
docker network create mynet
```

Specify driver:

```bash
docker network create --driver bridge mybridge
```

---

## Q75: What are named volumes vs anonymous volumes?

📋 **Comparison**

| Type                 | Behavior                                  | Use Case           |
| -------------------- | ----------------------------------------- | ------------------ |
| **Named volume**     | Explicitly created and referenced by name | Persistent storage |
| **Anonymous volume** | Auto-created without a name               | Temporary data     |

💡 **In short:** Named = managed; anonymous = auto-created for convenience.

---

## Q76: How do you mount a volume to a container?

🧩 **Command**

```bash
docker run -v myvol:/data nginx
```

---

## Q77: What is the difference between -v and --mount flags?

📋 **Comparison**

| Feature     | `-v`         | `--mount`                       |
| ----------- | ------------ | ------------------------------- |
| Syntax      | Short, older | Long, more explicit             |
| Options     | Limited      | Rich (type, src, dst, readonly) |
| Recommended | ❌ Legacy     | ✅ Modern                        |

🧩 **Example**

```bash
docker run --mount type=volume,src=myvol,dst=/data nginx
```

---

## Q78: How do you share volumes between containers?

🧩 **Command**

```bash
docker run -v sharedvol:/data container1
docker run -v sharedvol:/data container2
```

💡 **In short:** Use the same volume name in multiple containers.

---

## Q79: What are tmpfs mounts in Docker?

🧠 **Overview**
A tmpfs mount stores data **in memory**, not on disk. Used for sensitive or volatile data.

🧩 **Example**

```bash
docker run --tmpfs /run tmpfs_size=64m alpine
```

---

## Q80: When would you use tmpfs mounts?

⚙️ **Use cases**

* Sensitive data (certs, secrets)
* High-performance temporary files
* Avoid disk writes (ephemeral workloads)

💡 **In short:** Use tmpfs for memory-only ephemeral data.

---

## Q81: What is Docker's storage driver?

🧠 **Overview**
Storage drivers handle how Docker manages layered filesystems for images and containers.

Examples: `overlay2`, `aufs`, `devicemapper`.

💡 **In short:** The storage driver determines how container filesystems are created and stored.

---

## Q82: What storage drivers are available (overlay2, aufs, devicemapper)?

📋 **Comparison**

| Driver           | Description             | Notes                         |
| ---------------- | ----------------------- | ----------------------------- |
| **overlay2**     | Modern union filesystem | Default on most Linux distros |
| **aufs**         | Older union FS          | Deprecated on many systems    |
| **devicemapper** | Block-level driver      | Used in older RHEL/CentOS     |

💡 **In short:** overlay2 = preferred and fastest.

---

## Q83: How do you check which storage driver Docker is using?

🧩 **Command**

```bash
docker info | grep Storage
```

Example output:

```
Storage Driver: overlay2
```

---

## Q84: What is container filesystem and how is it different from volumes?

📋 **Comparison**

| Feature     | Container FS                | Volume                     |
| ----------- | --------------------------- | -------------------------- |
| Persistence | Lost when container removed | Persistent                 |
| Performance | Slower                      | Faster                     |
| Sharing     | Not sharable                | Sharable across containers |

💡 **In short:** Container layers are temporary; volumes are persistent.

---

## Q85: What are health checks in Docker?

🧠 **Overview**
Health checks monitor if a container is functioning correctly. Docker updates status to: `healthy`, `unhealthy`, or `starting`.

💡 **In short:** Built-in container health monitoring.

---

## Q86: How do you define a HEALTHCHECK in Dockerfile?

🧩 **Example**

```Dockerfile
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8080/health || exit 1
```

---

## Q87: What is the purpose of the --health-cmd flag?

🧠 **Overview**
`--health-cmd` defines the command Docker will run periodically to determine if the container is healthy.

🧩 **Example**

```bash
docker run --health-cmd="curl -f http://localhost/health || exit 1" myapp
```

💡 **In short:** It sets the actual health-check command.

---

Below is your **README-style DevOps documentation** for **Q88–Q120 (Advanced Docker Runtime, Compose, Storage & Cleanup)**.

---

## Q88: How do you view container health status?

🧩 **Command**

```bash
docker ps --format "table {{.Names}}\t{{.Status}}"
```

Or detailed:

```bash
docker inspect --format='{{json .State.Health}}' <container>
```

💡 **In short:** Health shows as *healthy / unhealthy / starting*.

---

## Q89: What are Docker restart policies?

🧠 **Overview**
Restart policies control how Docker reacts when a container exits.

🧩 **Example**

```bash
docker run --restart=always myapp
```

---

## Q90: What is the difference between no, on-failure, always, and unless-stopped?

📋 **Comparison Table**

| Policy             | Behavior                                  |
| ------------------ | ----------------------------------------- |
| **no**             | Default; never restart                    |
| **on-failure**     | Restart only if exit code ≠ 0             |
| **always**         | Always restart, even after daemon restart |
| **unless-stopped** | Restart always unless manually stopped    |

---

## Q91: How do you set resource limits for containers?

🧩 **Command**

```bash
docker run --memory="512m" --cpus="1.5" myapp
```

---

## Q92: What is the --memory flag used for?

🧠 **Overview**
Sets maximum memory available to the container.

🧩 **Example**

```bash
docker run --memory=1g nginx
```

---

## Q93: What is the --cpus flag?

🧠 **Overview**
Limits number of CPU cores the container can use.

🧩 **Example**

```bash
docker run --cpus=0.5 nginx
```

---

## Q94: How do you limit container CPU usage?

🧩 **Command**

```bash
docker run --cpus=".75" myapp
```

Or via CFS shares:

```bash
docker run --cpu-shares=512 myapp
```

---

## Q95: What is Docker stats command?

🧠 **Overview**
Shows **live** resource usage (CPU, memory, I/O, network).

🧩 **Command**

```bash
docker stats
```

---

## Q96: How do you monitor container resource usage in real-time?

🧩 **Command**

```bash
docker stats <container>
```

💡 **In short:** Real-time equivalent of `top` for containers.

---

## Q97: What are container labels and how are they used?

🧠 **Overview**
Labels are metadata for organizing, filtering, and integrating with tooling.

🧩 **Example**

```bash
docker run --label env=prod --label team=devops nginx
```

💡 **Use cases:** Monitoring, CI/CD rules, cleanup scripts.

---

## Q98: How do you filter containers by labels?

🧩 **Command**

```bash
docker ps --filter "label=env=prod"
```

---

## Q99: What is docker inspect command used for?

🧠 **Overview**
Displays detailed JSON metadata for containers, images, networks, etc.

🧩 **Example**

```bash
docker inspect web
```

---

## Q100: How do you extract specific information using docker inspect?

🧩 **Command**

```bash
docker inspect -f '{{.NetworkSettings.IPAddress}}' web
```

Another example:

```bash
docker inspect -f '{{json .Config.Env}}' web
```

---

## Q101: What is Docker Compose depends_on directive?

🧠 **Overview**
Specifies service dependency ordering (start order only).

🧩 **Example**

```yaml
depends_on:
  - db
```

---

## Q102: What are the limitations of depends_on?

⚠️ **Limitations**

* Does **not** wait for service readiness
* Only ensures start *attempt* order
* Does not check health checks unless using version 3.9+ with health-based conditions

---

## Q103: How do you ensure service startup order in Docker Compose?

🧩 **Use health checks**

```yaml
depends_on:
  db:
    condition: service_healthy
```

💡 **In short:** Use health checks + depends_on.

---

## Q104: What are Docker Compose profiles?

🧠 **Overview**
Profiles enable selective activation of services.

🧩 **Example**

```yaml
profiles: ["debug"]
```

Run:

```bash
docker compose --profile debug up
```

---

## Q105: How do you use environment variables in docker-compose.yml?

🧩 **Example**

```yaml
environment:
  - APP_ENV=${APP_ENV}
```

Or:

```yaml
env_file: .env
```

---

## Q106: What is the .env file in Docker Compose?

🧠 **Overview**
A file holding environment variables automatically loaded by Docker Compose.

🧩 **Example**

```
APP_ENV=production
DB_USER=admin
```

---

## Q107: How do you override docker-compose.yml settings?

🧩 **Command**

```bash
docker compose -f docker-compose.yml -f override.yml up
```

---

## Q108: What is docker-compose.override.yml?

🧠 **Overview**
A default override file that Docker Compose loads automatically to extend/modify configurations.

💡 **Use case:** Dev overrides for ports, volumes, environment.

---

## Q109: How do you specify multiple compose files?

🧩 **Command**

```bash
docker compose -f base.yml -f prod.yml up
```

---

## Q110: What are Docker Compose networks?

🧠 **Overview**
Networks defined within Compose for container communication and isolation.

🧩 **Example**

```yaml
networks:
  backend:
    driver: bridge
```

---

## Q111: How do you define custom networks in docker-compose.yml?

🧩 **Example**

```yaml
services:
  app:
    networks:
      - backend

networks:
  backend:
    driver: bridge
```

---

## Q112: What is the difference between docker commit and docker build?

📋 **Comparison Table**

| Feature       | docker commit           | docker build           |
| ------------- | ----------------------- | ---------------------- |
| Method        | Capture container state | Declarative Dockerfile |
| Reproducible  | ❌ No                    | ✅ Yes                  |
| Best practice | ❌ Avoid                 | ✅ Use                  |

---

## Q113: Why is docker commit generally discouraged?

⚠️ **Reasons**

* Non-repeatable
* Hidden changes
* No version control
* Violates IaC principles

💡 **In short:** Always prefer Dockerfile-based builds.

---

## Q114: How do you export and import Docker images?

🧩 **Export**

```bash
docker save myimage:latest -o myimage.tar
```

🧩 **Import**

```bash
docker load -i myimage.tar
```

---

## Q115: What is the difference between docker save and docker export?

📋 **Comparison**

| Command           | Exports                   | Use Case                    |
| ----------------- | ------------------------- | --------------------------- |
| **docker save**   | Image + layers            | Move images between hosts   |
| **docker export** | Container filesystem only | Flattened filesystem backup |

---

## Q116: How do you load a Docker image from a tar file?

🧩 **Command**

```bash
docker load -i image.tar
```

---

## Q117: What is Docker prune and what does it clean?

🧠 **Overview**
Prunes unused Docker objects.

🧩 **Clean everything**

```bash
docker system prune
```

🧩 **Clean deeply**

```bash
docker system prune -a
```

---

## Q118: How do you remove all stopped containers?

🧩 **Command**

```bash
docker container prune
```

---

## Q119: How do you remove unused images?

🧩 **Command**

```bash
docker image prune -a
```

---

## Q120: How do you clean up unused volumes?

🧩 **Command**

```bash
docker volume prune
```

---

# Advanced

Below is your **README-style technical documentation** for **Q121–Q135 (Advanced Docker Security, Isolation & Hardening)**.

---

## Q121: How does Docker implement container isolation?

🧠 **Overview**
Docker isolation is achieved through **Linux kernel features**:

* **Namespaces** → isolate processes, networking, file systems
* **cgroups** → limit resource usage
* **Seccomp/AppArmor/SELinux** → syscall filtering & MAC
* **Capabilities** → granular privilege control

💡 **In short:** Containers share the host kernel but remain isolated using namespaces + cgroups + security policies.

---

## Q122: What are Linux namespaces and how does Docker use them?

🧠 **Overview**
Namespaces isolate system resources per container. Each container gets its own namespace instance.

⚙️ **Docker uses namespaces to isolate:**

* Processes (PID)
* Networks (NET)
* Mount points (MNT)
* Hostnames (UTS)
* Interprocess communication (IPC)
* Users / groups (USER)

💡 **In short:** Namespaces give each container its own view of the system.

---

## Q123: What namespace types does Docker use (PID, NET, IPC, MNT, UTS)?

📋 **Namespace Breakdown**

| Namespace | Purpose                                   |
| --------- | ----------------------------------------- |
| **PID**   | Isolates process tree                     |
| **NET**   | Provides container-level networking stack |
| **IPC**   | Shared memory isolation                   |
| **MNT**   | Filesystem mount separation               |
| **UTS**   | Hostname / domain name isolation          |
| **USER**  | UID/GID mappings                          |

💡 **In short:** Each namespace isolates one OS subsystem.

---

## Q124: What are cgroups and how does Docker use them for resource management?

🧠 **Overview**
Control Groups (cgroups) limit and track system resources for containers.

⚙️ **Docker uses cgroups to control:**

* CPU
* Memory
* Disk I/O
* PIDs

🧩 **Example**

```bash
docker run --memory=512m --cpus=1 myapp
```

💡 **In short:** cgroups enforce resource boundaries to prevent noisy-neighbor issues.

---

## Q125: How does Docker implement security with seccomp?

🧠 **Overview**
Seccomp (secure computing mode) filters Linux syscalls. Docker applies a **default seccomp profile** blocking ~40 dangerous syscalls (e.g., `ptrace`, `kexec_load`).

🧩 **Custom profile**

```bash
docker run --security-opt seccomp=custom.json myapp
```

💡 **In short:** Seccomp prevents containers from executing unsafe system calls.

---

## Q126: What is AppArmor and how does it integrate with Docker?

🧠 **Overview**
AppArmor is a Mandatory Access Control (MAC) system. Docker applies **AppArmor profiles** to restrict filesystem access and behavior.

🧩 **Run with custom profile**

```bash
docker run --security-opt apparmor=myprofile nginx
```

💡 **In short:** AppArmor enforces per-container security policies.

---

## Q127: What are Docker capabilities and how do they enhance security?

🧠 **Overview**
Capabilities break root privileges into smaller units (e.g., `NET_ADMIN`, `SYS_ADMIN`). Docker drops many capabilities by default.

🧩 **List capabilities**

```bash
docker run --cap-drop ALL myapp
```

💡 **In short:** Capabilities provide fine-grained privilege control.

---

## Q128: How do you run containers with minimal capabilities?

🧩 **Command**

```bash
docker run --cap-drop ALL --cap-add NET_BIND_SERVICE myapp
```

💡 **In short:** Drop everything and selectively add back what's required.

---

## Q129: What is the --privileged flag and why is it dangerous?

🧠 **Overview**
`--privileged` gives container full device and kernel access → effectively root on the host.

⚠️ **Risks**

* Escape vulnerabilities
* Full control of host devices
* Host filesystem modification

💡 **In short:** Avoid unless absolutely required.

---

## Q130: What are the security implications of running containers as root?

⚠️ **Risks**

* Escalation to host root
* Malicious code can modify host filesystem
* Kernel attack surface increases
* Breaks tenant isolation

💡 **In short:** Root inside container is dangerous; prefer non-root users.

---

## Q131: How do you implement rootless Docker?

🧠 **Overview**
Rootless Docker allows Docker to run without root privileges using user namespaces.

🧩 **Commands (Linux)**

```bash
dockerd-rootless-setuptool.sh install
export PATH=/usr/bin:$PATH
systemctl --user start docker
```

💡 **In short:** Docker runs as an unprivileged user, reducing host attack surface.

---

## Q132: What is Docker user namespaces remapping?

🧠 **Overview**
User namespace remapping maps container root (UID 0) to a **non-root UID on the host**.

💡 **In short:** Even if container thinks it is root, host sees it as an unprivileged user.

---

## Q133: How do you configure user namespace remapping?

🧩 **Steps**

1️⃣ Edit Docker daemon config:

```json
{
  "userns-remap": "default"
}
```

2️⃣ Restart Docker:

```bash
systemctl restart docker
```

3️⃣ Verify:

```bash
docker info | grep userns
```

---

## Q134: What strategies would you use for container image security?

🛡️ **Best Practices**

* Use minimal base images (distroless, alpine)
* Scan images (Trivy, Clair, Snyk)
* Sign images (Docker trust, Notary)
* Pin image digests
* Remove unused tools (curl, bash)
* Apply multi-stage builds
* Enable seccomp/AppArmor profiles
* Drop capabilities

💡 **In short:** Reduce attack surface + verify integrity + enforce policies.

---

## Q135: How do you implement image scanning in CI/CD?

🧩 **Example (Trivy in CI)**
GitLab:

```yaml
scan:
  image: aquasec/trivy
  script:
    - trivy image myapp:latest
```

GitHub Actions:

```yaml
- uses: aquasecurity/trivy-action@v0.11.2
  with:
    image-ref: myapp:latest
```

Jenkins:

```bash
trivy image myapp:latest --exit-code 1
```

💡 **In short:** Integrate scanners in pipelines and fail builds on vulnerabilities.

---

Below is your **README-style technical documentation** for **Q136–Q151 (Docker Security, Secrets, BuildKit, BuildX, Manifests)**.

---

## Q136: What tools would you use for vulnerability scanning (Trivy, Clair, Anchore)?

🧠 **Overview**
Image scanners detect CVEs in OS packages & app dependencies.

📋 **Comparison Table**

| Tool              | Strengths                                                    |
| ----------------- | ------------------------------------------------------------ |
| **Trivy**         | Fast, simple CLI, supports FS, SBOM, registry scanning       |
| **Clair**         | API-based, used in registries (Harbor), enterprise workflows |
| **Anchore/Grype** | Policy enforcement, CI integration, SBOM support             |

🧩 **Usage**

```bash
trivy image myapp:latest
grype myapp:latest
```

💡 **In short:** Trivy for CI simplicity, Clair for registry integration, Anchore for compliance.

---

## Q137: How do you implement least privilege for container processes?

🛡️ **Strategies**

* Run as non-root:

```Dockerfile
USER 1000:1000
```

* Drop unneeded capabilities:

```bash
docker run --cap-drop ALL --cap-add NET_BIND_SERVICE myapp
```

* Use seccomp/AppArmor profiles
* Use read-only root filesystem
* Limit resources via cgroups

💡 **In short:** Remove root access and reduce privilege scope.

---

## Q138: What is read-only root filesystem and how do you implement it?

🧠 **Overview**
A mode where container root filesystem becomes **immutable** → prevents tampering, malware persistence.

🧩 **Command**

```bash
docker run --read-only myapp
```

Docker Compose:

```yaml
read_only: true
```

---

## Q139: How do you handle writable directories with read-only filesystem?

🧩 **Approaches**

* Use **tmpfs** for ephemeral writes:

```bash
docker run --read-only --tmpfs /tmp myapp
```

* Use mounted volumes for persistent writes:

```bash
docker run --read-only -v data:/var/lib/app myapp
```

💡 **In short:** Add tmpfs or volumes for writable paths.

---

## Q140: What strategies would you use for secrets management in Docker?

🛡️ **Best Practices**

* Never bake secrets into images
* Avoid passing secrets via env vars
* Use Docker Swarm secrets
* Use read-only volumes for secrets
* Integrate with external secret stores (Vault, AWS Secrets Manager, SSM)
* Use BuildKit secrets during builds

💡 **In short:** Keep secrets out of images, env, and logs.

---

## Q141: What are Docker secrets in Swarm mode?

🧠 **Overview**
Swarm secrets are encrypted blobs stored in Raft logs and exposed to containers as in-memory files.

🧩 **Example**

```bash
echo "mypassword" | docker secret create db_pass -
```

Services:

```yaml
secrets:
  - db_pass
```

💡 **In short:** Secure, encrypted secrets management for Swarm services.

---

## Q142: How do you pass secrets to standalone Docker containers?

⚙️ **Options**

* Mounted files:

```bash
docker run -v /secure/secret.txt:/run/secret.txt myapp
```

* Docker CLI stdin pass-through (not secure long term)
* BuildKit secrets during builds
* External secret management (Vault/SSM/ASM)

💡 **In short:** No built-in secrets for plain Docker → use file mounts or external secret stores.

---

## Q143: What are the security risks of using environment variables for secrets?

⚠️ **Risks**

* Visible in `docker inspect`
* Logged in CI/CD systems
* Inherited by child processes
* May leak via core dumps
* Exposed via `/proc/<pid>/environ`

💡 **In short:** Env vars are convenient but insecure for secrets.

---

## Q144: How would you integrate external secret management (Vault, AWS Secrets Manager)?

🧩 **Vault Example**

```bash
vault kv get secret/dbpassword
docker run -e DB_PASS=$(vault kv get -field=password secret/db) app
```

🧩 **AWS Secrets Manager**

```bash
aws secretsmanager get-secret-value --secret-id db-pass
```

CI/CD:

* Fetch at runtime
* Inject as files or ephemeral variables
* Ensure secrets never enter images

💡 **In short:** Retrieve secrets at runtime, not build time.

---

## Q145: What is Docker Buildkit and what advantages does it offer?

🧠 **Overview**
BuildKit is a next-gen image builder with:

* Faster parallel builds
* Better caching
* Secret mounts
* SSH forwarding
* Smaller images

💡 **In short:** BuildKit = faster, secure, efficient builds.

---

## Q146: How do you enable BuildKit?

🧩 **Environment variable**

```bash
export DOCKER_BUILDKIT=1
```

🧩 **Daemon config**

```json
{ "features": { "buildkit": true } }
```

---

## Q147: What are BuildKit cache mounts?

🧠 **Overview**
Cache mounts allow reusing build artifacts between builds.

🧩 **Example**

```Dockerfile
RUN --mount=type=cache,target=/root/.cache/go-build go build .
```

💡 **In short:** Cache mounts drastically speed up builds.

---

## Q148: How do BuildKit secrets differ from multi-stage builds for secrets?

📋 **Comparison**

| Feature       | BuildKit secrets                        | Multi-stage builds                    |
| ------------- | --------------------------------------- | ------------------------------------- |
| Exposure risk | None (mounted in memory, not in layers) | Risky (possibility of leak in layers) |
| Usage         | Build time                              | Build time only                       |
| Clean removal | Auto-removed                            | Manual cleanup needed                 |
| Security      | High                                    | Medium                                |

🧩 **BuildKit secret example**

```Dockerfile
RUN --mount=type=secret,id=mysecret cat /run/secrets/mysecret
```

💡 **In short:** BuildKit secrets are safer and never persist in the final image.

---

## Q149: What is Docker BuildX?

🧠 **Overview**
BuildX extends BuildKit with:

* Multi-platform builds
* Cross-compilation
* Advanced cache drivers
* Distributed builds

💡 **In short:** BuildX is a modern builder frontend for advanced build workflows.

---

## Q150: How do you build multi-platform images with BuildX?

🧩 **Example**

```bash
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 -t myapp:latest --push .
```

💡 **In short:** BuildX + `--platform` builds multi-arch images.

---

## Q151: What are Docker manifest lists?

🧠 **Overview**
A manifest list groups multiple architecture-specific images under a single tag (e.g., `ubuntu:latest` supports ARM and x86).

🧩 **Example**

```bash
docker manifest inspect ubuntu:latest
```

💡 **In short:** Multi-arch image index → same tag, different architectures.

---

Below is your **README-style DevOps documentation** for **Q152–Q169 (Expert Docker Images, Optimization, Promotion, Logging)**.

---

## Q152: How do you create and push multi-architecture images?

🧠 **Overview**
Use **Docker BuildX** + `--platform` to build images for ARM64, AMD64, etc., then push a manifest list.

🧩 **Example**

```bash
docker buildx create --use
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t myrepo/myapp:1.0 \
  --push .
```

💡 **In short:** BuildX builds + pushes multi-arch images under one tag.

---

## Q153: What strategies would you use for optimizing Docker image size?

🛠️ **Methods**

* Use small base images (distroless, alpine)
* Multi-stage builds
* Minimize layers (combine RUN commands)
* Remove build tools in final stage
* Copy only what’s required (`COPY --chown`, target paths)
* Use `.dockerignore` effectively
* Avoid package managers in final image

🧩 **Example**

```Dockerfile
RUN apk add --no-cache curl && rm -rf /var/cache/apk/*
```

---

## Q154: How do you analyze image layers to identify bloat?

🧩 **Tools**

* `docker history <image>` → shows layer size
* `dive <image>` → interactive layer analysis

🧩 **Command**

```bash
docker history myapp:latest
```

---

## Q155: What tools would you use for image analysis (dive, docker history)?

📋 **Comparison**

| Tool               | Purpose                     | Strength               |
| ------------------ | --------------------------- | ---------------------- |
| **dive**           | Layer-by-layer analysis     | Highlight wasted space |
| **docker history** | Show layer commands & sizes | Quick CLI check        |
| **trivy sbom**     | Dependency inventory        | Security + composition |

💡 **In short:** Use *dive* to visually inspect bloat.

---

## Q156: How do you implement distroless images?

🧠 **Overview**
Distroless images contain **only your app + runtime libraries**, no shell or package manager.

🧩 **Example (multi-stage)**

```Dockerfile
FROM golang:1.21 AS builder
RUN go build -o app .

FROM gcr.io/distroless/base
COPY --from=builder /app /app
CMD ["/app"]
```

💡 **In short:** Build in one stage → copy binary into distroless base.

---

## Q157: What are the benefits and challenges of distroless images?

📋 **Comparison**

| Benefit                | Challenge                     |
| ---------------------- | ----------------------------- |
| Minimal attack surface | No shell → debugging harder   |
| Smaller images         | Requires proper health checks |
| Stronger security      | Must embed everything needed  |
| No package manager     | Harder for troubleshooting    |

💡 **In short:** Great for production, harder for debugging.

---

## Q158: How would you implement scratch-based images?

🧠 **Overview**
`scratch` is an empty base image → only works for static binaries.

🧩 **Example**

```Dockerfile
FROM golang:1.21 AS builder
RUN CGO_ENABLED=0 go build -a -ldflags='-s -w' -o app .

FROM scratch
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
```

💡 **In short:** Use scratch for fully static binaries.

---

## Q159: When would you use Alpine vs Ubuntu vs Distroless base images?

📋 **Comparison**

| Base           | Use Case                | Pros            | Cons             |
| -------------- | ----------------------- | --------------- | ---------------- |
| **Alpine**     | Small apps, simple deps | Tiny, fast      | musl libc issues |
| **Ubuntu**     | Complex deps, debugging | Full ecosystem  | Large size       |
| **Distroless** | Production workloads    | Secure, minimal | Debug complexity |

💡 **In short:** Alpine = small, Ubuntu = flexible, Distroless = secure.

---

## Q160: What strategies would you use for Docker layer caching in CI/CD?

🛠️ **Strategies**

* Pin base images
* Cache dependency install layers
* Separate frequently changing layers (`COPY . .`)
* Use BuildKit cache mounts
* Use remote registries to store cache

🧩 **Example**

```Dockerfile
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
```

---

## Q161: How do you implement remote caching for Docker builds?

🧩 **BuildX example using registry cache**

```bash
docker buildx build \
  --cache-to=type=registry,ref=myrepo/cache:latest \
  --cache-from=type=registry,ref=myrepo/cache:latest \
  -t myapp:latest .
```

💡 **In short:** Push cache to a registry → reuse it across CI runs.

---

## Q162: What is Docker registry caching and how does it work?

🧠 **Overview**
Registry caching mirrors images locally so pulls are faster and reduce rate limits.

💡 **Flow**

1. Pull image → cached in local proxy registry
2. Next requests use cached copy

Used in Artifactory, Nexus, Harbor.

---

## Q163: How would you implement a pull-through cache for Docker Hub?

🧩 **Example (Harbor or Nexus)**
Configure a **proxy registry** pointing to Docker Hub.

Harbor:

```yaml
registry:
  type: docker-hub-proxy
```

Docker daemon:

```json
{
  "registry-mirrors": ["http://my-proxy:5000"]
}
```

💡 **In short:** Proxy registry → cache → avoid Hub rate limits.

---

## Q164: What strategies would you use for Docker image promotion across environments?

🛠️ **Promotion Strategies**

* Tag-based promotion (`dev → stage → prod`)
* Immutable digests (`sha256:<digest>`)
* Separate ECR repos per environment
* CI/CD pipeline-controlled promotion (GitOps style)

---

## Q165: How do you implement immutable tags vs mutable tags strategy?

📋 **Comparison**

| Strategy                          | Usage                                          |
| --------------------------------- | ---------------------------------------------- |
| **Immutable tags** (digest-based) | `image@sha256:abcd` — cannot change            |
| **Mutable tags**                  | `latest`, `prod`, `stable` — overwrite allowed |

🧩 **Best approach**

```bash
docker pull myapp@sha256:<digest>
```

💡 **In short:** Use digests for deployments, tags for humans.

---

## Q166: What is the latest tag anti-pattern and why should you avoid it?

⚠️ **Problems**

* Non-reproducible deployments
* Hard to roll back
* CI/CD pipelines become unpredictable
* Environments drift

💡 **In short:** Never deploy `latest` — always use versioned tags or digests.

---

## Q167: How would you implement semantic versioning for Docker images?

🧩 **Tag pattern**

```
v1.2.3
v1.2
v1
```

CI/CD example:

```bash
docker build -t myapp:$VERSION -t myapp:$MAJOR.$MINOR -t myapp:$MAJOR .
docker push myapp:$VERSION
```

💡 **In short:** Tag hierarchical versions for compatibility guarantees.

---

## Q168: What strategies would you use for Docker logging at scale?

🛠️ **Strategies**

* Use centralized logging (ELK, Loki, CloudWatch, Datadog)
* Use JSON logging driver for structured logs
* Rotate logs using `max-size` and `max-file`
* Avoid writing logs to container filesystem
* Route logs via Fluentd / Logstash sidecars

---

## Q169: What are Docker logging drivers?

🧠 **Overview**
Logging drivers control how container logs are collected and stored.

📋 **Common drivers**

| Driver        | Purpose                 |
| ------------- | ----------------------- |
| **json-file** | Default local logs      |
| **syslog**    | Send to syslog server   |
| **fluentd**   | Centralized logging     |
| **awslogs**   | Send logs to CloudWatch |
| **gelf**      | Graylog / Logstash      |
| **none**      | Disable logging         |

🧩 **Example**

```bash
docker run --log-driver=syslog myapp
```

---
Below is your **README-style DevOps documentation** for **Q170–Q184 (Advanced Logging, Monitoring, Metrics, Distributed Tracing & Docker Swarm)**.

---

## Q170: How do you configure json-file, syslog, journald, and other log drivers?

🧠 **Overview**
Docker log drivers are configured per-container or globally in `/etc/docker/daemon.json`.

🧩 **Per-container example**

```bash
docker run --log-driver=syslog myapp
```

🧩 **Global daemon config**

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

🧩 **Journald**

```json
{ "log-driver": "journald" }
```

💡 **In short:** Configure via `--log-driver` or daemon.json.

---

## Q171: What is the difference between local and centralized logging?

📋 **Comparison Table**

| Type                    | Description                                              | Pros                 | Cons                          |
| ----------------------- | -------------------------------------------------------- | -------------------- | ----------------------------- |
| **Local logging**       | Logs stored on host (json-file, journald)                | Simple               | Hard to aggregate, disk usage |
| **Centralized logging** | Logs shipped to external systems (ELK, Loki, CloudWatch) | Scalable, searchable | Requires infra                |

💡 **In short:** Local = simple; centralized = scalable.

---

## Q172: How would you implement log rotation for Docker containers?

🧩 **Daemon config**

```json
{
  "log-opts": {
    "max-size": "10m",
    "max-file": "5"
  }
}
```

🧩 **Per-container**

```bash
docker run --log-opt max-size=10m --log-opt max-file=5 myapp
```

💡 **In short:** Use `log-opts` with json-file driver.

---

## Q173: What strategies would you use for container monitoring?

🛠️ **Monitoring Stack**

* **cAdvisor** → container metrics
* **Prometheus** → scraping + alerting
* **Grafana** → dashboards
* **Node Exporter** → host metrics
* **ELK / Loki** → logs
* **Jaeger / Zipkin** → tracing

💡 **In short:** Use Prometheus + cAdvisor + Grafana for container-level monitoring.

---

## Q174: How do you expose container metrics for Prometheus?

🧠 **Overview**
Application must expose **/metrics** endpoint in Prometheus format.

🧩 **Dockerfile**

```Dockerfile
EXPOSE 9090
```

🧩 **Prometheus scrape config**

```yaml
scrape_configs:
  - job_name: app
    static_configs:
      - targets: ["app:9090"]
```

Alternatively, run **cAdvisor**:

```bash
docker run -p 8080:8080 gcr.io/cadvisor/cadvisor
```

---

## Q175: What is cAdvisor and how does it integrate with Docker?

🧠 **Overview**
cAdvisor (Container Advisor) collects real-time container metrics: CPU, memory, I/O, network.

🧩 **Example**

```bash
docker run -d -p 8080:8080 \
  --volume=/:/rootfs:ro \
  --volume=/var/run/docker.sock:/var/run/docker.sock:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  gcr.io/cadvisor/cadvisor
```

💡 **In short:** Prometheus scrapes cAdvisor → Grafana visualizes metrics.

---

## Q176: How would you implement distributed tracing for containerized applications?

🛠️ **Approach**

* Use tracing libraries (OpenTelemetry SDK)
* Deploy backend collector (Jaeger, Zipkin, Tempo)
* Instrument apps for spans & trace propagation
* Expose tracing endpoints via sidecars or exporters

🧩 **Jaeger example**

```yaml
docker run -d -p 16686:16686 jaegertracing/all-in-one
```

💡 **In short:** Use OpenTelemetry + Jaeger/Zipkin.

---

## Q177: What is Docker Swarm mode?

🧠 **Overview**
Swarm mode is Docker’s built-in container orchestration engine providing clustering, scheduling, load balancing and service management.

💡 **In short:** Native Docker orchestration.

---

## Q178: What are the components of Docker Swarm (manager, worker nodes)?

📋 **Components**

| Component   | Role                                      |
| ----------- | ----------------------------------------- |
| **Manager** | Orchestration, scheduling, Raft consensus |
| **Worker**  | Runs tasks/containers                     |
| **Tasks**   | Container instances managed by Swarm      |

---

## Q179: How does Swarm differ from Kubernetes?

📋 **Comparison Table**

| Feature        | Swarm                 | Kubernetes             |
| -------------- | --------------------- | ---------------------- |
| Installation   | Simple                | Complex                |
| Learning curve | Low                   | High                   |
| Features       | Basic orchestration   | Full ecosystem         |
| Scaling        | Good                  | Best                   |
| Networking     | Built-in              | CNI plugins            |
| Use case       | Small–medium clusters | Large-scale enterprise |

💡 **In short:** Swarm = simplicity; Kubernetes = full power.

---

## Q180: When would you use Swarm over Kubernetes?

🧠 **Use Cases**

* Small teams needing simple orchestration
* Edge or IoT deployments
* Local HA clusters
* Fast onboarding & minimal overhead

💡 **In short:** Ideal when simplicity > advanced orchestration features.

---

## Q181: What are Docker services in Swarm?

🧠 **Overview**
A service is the Swarm abstraction that defines:

* Image
* Replicas
* Network
* Volumes
* Constraints

🧩 **Example**

```bash
docker service create --name web --replicas 3 nginx
```

💡 **In short:** Services manage replicated tasks.

---

## Q182: How do you deploy a stack in Docker Swarm?

🧩 **Command**

```bash
docker stack deploy -c stack.yml mystack
```

Stack example:

```yaml
services:
  web:
    image: nginx
    deploy:
      replicas: 3
```

---

## Q183: What is the difference between replicated and global services?

📋 **Comparison**

| Type           | Behavior                      |
| -------------- | ----------------------------- |
| **Replicated** | Run *N* replicas across nodes |
| **Global**     | Run *one task on each node*   |

🧩 **Examples**

```bash
docker service create --mode replicated --replicas 3 web
docker service create --mode global node-exporter
```

---

## Q184: How does Swarm handle load balancing?

🧠 **Overview**
Swarm uses:

* **Routing Mesh** → exposes service on every node
* **VIP-based load balancing** → internal virtual IP
* **Ingress load balancing** → L4 load distribution

🧩 **Example**

```bash
curl http://<any-node>:80
```

💡 **In short:** Swarm automatically balances traffic across replicas using routing mesh + VIPs.

---

---

## Q185: What is the routing mesh in Docker Swarm?

🧠 **Overview**
Routing Mesh is Swarm’s built-in ingress layer that exposes a service port on **every node**, then routes incoming connections to available service tasks (replicas) across the cluster.

⚙️ **How it works**

* Each service gets a Virtual IP (VIP).
* Every node listens on the published port and forwards traffic into the swarm (ingress).
* Traffic is distributed via internal load-balancing (VIP) to tasks.

🧩 **Commands / Example**

```bash
docker service create --name web --publish published=80,target=80 nginx
# Now curl any node's port 80 -> routed to service replicas
```

✅ **Best Practices**

* Use service constraints/placement for locality-sensitive apps.
* Combine with external LB for advanced routing (TLS, sticky sessions).

💡 **In short:** Routing Mesh exposes services on all nodes and routes traffic to running tasks.

---

## Q186: How do you implement rolling updates in Swarm?

🧠 **Overview**
Swarm supports declarative rolling updates via the service `update_config` or `docker service update` flags — it updates tasks incrementally with configurable parallelism, delay, and failure action.

⚙️ **How it works**

* Define `parallelism`, `delay`, `order`, and `failure_action`.
* Swarm stops/creates tasks according to those settings.

🧩 **Examples**
Compose `deploy`:

```yaml
deploy:
  update_config:
    parallelism: 1
    delay: 10s
    failure_action: rollback
    order: start-first
```

CLI:

```bash
docker service update --image myapp:2.0 --update-parallelism 1 --update-delay 10s web
```

📋 **Key options**

| Option           | Meaning                         |
| ---------------- | ------------------------------- |
| `parallelism`    | Number of tasks updated at once |
| `delay`          | Wait between batches            |
| `order`          | `start-first` vs `stop-first`   |
| `failure_action` | `rollback` or `continue`        |

✅ **Best Practices**

* Use health checks + `failure_action: rollback`.
* Use `start-first` for zero-downtime where possible.

💡 **In short:** Configure `update_config` to control rolling updates safely.

---

## Q187: What strategies would you use for zero-downtime deployments?

🧠 **Overview**
Zero-downtime requires overlapping old/new versions, health checks, load-balancing, and careful state handling.

⚙️ **Strategies**

* Rolling updates with `start-first` (create new tasks before killing old).
* Health checks & readiness probes to only route to healthy tasks.
* Blue/green or canary deployments with traffic shifting at LB level.
* Session affinity avoidance (or sticky sessions with replication).
* Use connection draining on old instances.

🧩 **Example (canary pattern)**

* Deploy 1 replica of new version, monitor metrics/traces, increase traffic or replicas gradually.

✅ **Best Practices**

* Prefer stateless services; externalize session/store.
* Use automated rollback on failures.
* Monitor latency/error rates during rollout.

💡 **In short:** Combine rolling updates, health checks, and LB traffic control to avoid downtime.

---

## Q188: How do you handle stateful applications in Docker?

🧠 **Overview**
Stateful apps require persistent storage, careful scaling, and consistent identity (stable hostnames/volumes).

⚙️ **Approaches**

* Use persistent volumes (hostPath, NFS, block storage, CSI-backed volumes).
* Use StatefulSets (Kubernetes) or dedicated placement constraints in Swarm.
* Use clustered DBs with proper quorum (Postgres replication, Cassandra, MySQL primary/replica).
* Ensure backup/restore and data migration strategies.

🧩 **Example (Docker + volume)**

```bash
docker service create --name pg \
  --mount type=volume,source=pgdata,target=/var/lib/postgresql/data \
  --constraint 'node.role==worker' postgres:15
```

✅ **Best Practices**

* Avoid scaling DBs horizontally without a clustering solution.
* Use dedicated nodes/storage classes for stateful workloads.
* Test failover and backup restores regularly.

💡 **In short:** Give stateful apps persistent, reliable storage and treat them differently from stateless services.

---

## Q189: What are the challenges of running databases in containers?

🧠 **Overview**
Containers add flexibility but bring operational challenges for stateful DBs.

⚠️ **Challenges**

* **Persistence & durability:** Ensuring reliable storage and I/O performance.
* **Networking stability:** IP/hostname changes can break clustering.
* **Storage consistency:** Filesystem drivers, snapshotting and backups complexity.
* **Resource contention:** Noisy neighbors & I/O throttling.
* **Recovery & scaling:** Complex to scale vertically/horizontally; requires replication.
* **Monitoring & backups:** Need consistent backup strategies and testing.
* **Operational complexity:** Upgrades, maintenance windows, and data migrations are riskier.

✅ **Mitigations**

* Use cloud-managed DBs where possible (RDS, Cloud SQL).
* Use block/replicated storage, QoS, and dedicated nodes.
* Test failover, backup/restore, and restore RPO/RTO.

💡 **In short:** Containers are great for apps, but DBs need careful storage, networking, and operational practices.

---

## Q190: What strategies would you use for persistent storage in containers?

🧠 **Overview**
Persistent storage must be durable, performant, and suitable for the application’s access patterns.

⚙️ **Strategies**

* **Cloud block storage** (EBS, Persistent Disks) for single-writer DBs.
* **Network file systems** (NFS, EFS) for shared access where consistent POSIX semantics are OK.
* **Distributed file/block storage** (Ceph, Gluster, Portworx) for HA and multi-writer scenarios.
* **CSI drivers** in orchestrators for dynamic provisioning.
* **StatefulSet/volumeClaimTemplates** (Kubernetes) for per-pod volumes.

🧩 **Example (K8s PVC)**

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
spec:
  accessModes: ["ReadWriteOnce"]
  storageClassName: gp2
  resources:
    requests:
      storage: 50Gi
```

✅ **Best Practices**

* Choose storage based on IOPS/latency needs.
* Use replication and snapshots for backups.
* Avoid hostPath for production (node affinity issues).

💡 **In short:** Match storage type (block, file, distributed) to app requirements and use orchestrator primitives for provisioning.

---

## Q191: How would you implement backup strategies for containerized databases?

🧠 **Overview**
Backups must be consistent, automated, tested, and stored off-cluster.

⚙️ **Strategies**

* Logical backups (pg_dump, mysqldump) for portability.
* Physical backups / snapshots (LVM, EBS snapshots) for speed and consistency.
* Use volume snapshots with quiesce where supported.
* Offload backups to remote object storage (S3) and version them.
* Scheduled backups + retention policies + periodic restores (DR drills).
* Point-in-time recovery (WAL shipping, binlog replication) for low RPO.

🧩 **Example (Postgres WAL + basebackup)**

* `pg_basebackup` for full backups + ship WAL segments to S3.

✅ **Best Practices**

* Automate backup verification by restoring to test clusters.
* Encrypt backups and restrict access.
* Monitor backup success/failure alerts.

💡 **In short:** Combine snapshots and logical backups, store off-site, and regularly test restores.

---

## Q192: What is Docker's plugin system?

🧠 **Overview**
Docker plugins extend Docker functionality (volumes, networks, logging, authorization) with pluggable components that integrate into Docker’s API.

⚙️ **How it works**
Plugins run as containers and communicate with Docker via a defined plugin API.

🧩 **List plugins**

```bash
docker plugin ls
docker plugin install rexray/ebs:latest
```

✅ **Best Practices**

* Vet plugins for security & maintenance.
* Use trusted vendors (Portworx, Rex-Ray) or in-cluster CSI drivers for Kubernetes.

💡 **In short:** Plugins provide modular extensions for storage, network, and more.

---

## Q193: What types of plugins does Docker support (volume, network, authorization)?

📋 **Types**

* **Volume plugins** — custom storage backends (Rex-Ray, Portworx).
* **Network plugins** — alternate network drivers (Weave, Cilium via libnetwork/CNI in other orchestrators).
* **Logging plugins** — forward logs (fluentd, splunk).
* **Authorization plugins** — policy enforcement for API calls.
* **Metrics / monitoring plugins** — expose telemetry.

💡 **In short:** Plugins cover storage, networking, logging, and access control.

---

## Q194: How do you install and manage Docker plugins?

🧩 **Install**

```bash
docker plugin install <plugin-name> --grant-all-permissions
```

**Enable / disable / remove**

```bash
docker plugin enable <plugin>
docker plugin disable <plugin>
docker plugin remove <plugin>
```

**List**

```bash
docker plugin ls
```

⚠️ **Security note:** Only install trusted plugins and use least privileges.

---

## Q195: What are third-party volume plugins (Rex-Ray, Portworx)?

🧠 **Overview**
Third-party plugins connect Docker to enterprise storage backends and provide features like replication, snapshots, encryption, and multi-host volumes.

📋 **Examples**

* **Rex-Ray** — integrations with cloud block storage (EBS, Cinder).
* **Portworx** — distributed storage with HA, replication, encryption, snapshots.
* **StorageOS**, **OpenEBS** — container-native storage solutions.

💡 **In short:** Use these for production-grade persistent volumes across nodes.

---

## Q196: How would you implement high availability for Docker infrastructure?

🧠 **Overview**
HA requires redundancy at control plane, worker nodes, storage, and networking.

⚙️ **Approach**

* Run multiple manager nodes (Swarm) or control plane nodes (K8s) across AZs.
* Use HA registries (replicated Harbor/Artifactory) and proxy caches.
* Use resilient, replicated storage (Ceph, cloud block storage with replication).
* Use monitoring, automated failover, and health checks.
* Automate node replacement (immutable infra + terraform/auto-scaling).
* Backup cluster state (etcd/raft logs) regularly.

✅ **Best Practices**

* Distribute control plane across failure domains.
* Monitor quorum and failover behavior.
* Test restore and failure scenarios.

💡 **In short:** Redundancy + replication + tested failover = HA.

---

## Q197: What strategies would you use for Docker registry high availability?

🧠 **Overview**
Registry HA ensures image availability and reduces risk of downtime.

⚙️ **Strategies**

* Deploy a highly-available registry (Harbor / Nexus / Artifactory) in clustered mode.
* Use backend storage that is highly available (S3, GCS, or replicated block storage).
* Front with a load balancer across registry instances.
* Configure registry replication across regions (push-mirroring).
* Implement pull-through cache nodes close to CI/CD runners.
* Enable authentication, rate-limiting and monitoring.

🧩 **Example (Harbor)**

* Configure Harbor with HA chart (K8s) and object storage backend.

✅ **In short:** Use clustered registry + HA storage + LB + cross-region replication.

---

## Q198: How do you implement disaster recovery for Docker environments?

🧠 **Overview**
DR covers control plane, images, data, and configuration.

⚙️ **Key components**

* Backup orchestrator state (etcd, swarm raft).
* Backup persistent volumes (snapshots, offsite storage).
* Replicate registries and critical images to remote region.
* Keep IaC (Terraform, CloudFormation) and manifests in version control.
* Document and automate restore processes; run DR drills.
* Store secrets externally and back them up securely.

✅ **Best Practices**

* Maintain recovery runbooks with RTO/RPO targets.
* Automate failover with IaC & orchestration.
* Regularly test restores.

💡 **In short:** Backup state + images + data + IaC, test restores frequently.

---

## Q199: What are the considerations for Docker in production at scale?

🧠 **Overview**
Scaling Docker in production requires attention to orchestration, security, storage, networking, and operational processes.

⚙️ **Considerations**

* Use orchestration (Kubernetes/ECS/Swarm) for scheduling and scaling.
* Centralized logging, monitoring, and tracing.
* Robust CI/CD with image promotion and immutable artifacts.
* Registry performance, caching, and access control.
* Storage performance (IOPS) and volume management.
* Network policies, service meshes for traffic control and observability.
* Security posture: image scanning, runtime protection, secrets management.
* Capacity planning, autoscaling, and cost management.
* Compliance, auditing, and RBAC.

✅ **Best Practices**

* Standardize images & base OS.
* Automate infrastructure and deployments.
* Implement SLOs, alerts, and runbooks.

💡 **In short:** Production at scale requires automation, orchestration, observability, and hardened processes.

---

## Q200: How would you implement container orchestration beyond Docker Compose?

🧠 **Overview**
For production-grade orchestration you move to specialized orchestrators that provide scheduling, scaling, service discovery, and storage integration.

⚙️ **Options**

* **Kubernetes** — industry standard: pods, StatefulSets, CSI, Helm, operators.
* **Amazon ECS / EKS / Fargate** — managed container services (AWS).
* **Nomad** — HashiCorp scheduler (simpler than K8s).
* **Docker Swarm** — simpler clusters for smaller workloads.

🧩 **Example: Move from Compose to Kubernetes**

* Convert `docker-compose.yml` → K8s manifests (Kompose/Helm).
* Replace `volumes` with PVCs, `depends_on` with readiness probes.
* Use Deployments, Services, Ingress, and ConfigMaps/Secrets.

✅ **Best Practices**

* Use GitOps (ArgoCD/Flux) for declarative deployments.
* Adopt service mesh (Istio/Linkerd) only if needed.
* Use managed control planes to reduce operational burden.

💡 **In short:** Use Kubernetes or a managed orchestration service for production-scale container orchestration — Compose is great for local/dev only.

---

# Troubleshooting / Scenarios

Below is your **README-style DevOps troubleshooting documentation** for **Q201–Q211 (Docker Troubleshooting & Scenarios)**.

---

## Q201: A container exits immediately after starting. How do you troubleshoot?

🧠 **Overview**
Containers exit when the **main process (PID 1)** ends. Often caused by missing commands, misconfigured ENTRYPOINT/CMD, or errors during startup.

🧩 **Troubleshooting Steps**

```bash
docker logs <container>
docker inspect <container> --format='{{.State.ExitCode}}'
docker run -it --entrypoint bash <image>
```

📋 **Common causes**

* Wrong CMD/ENTRYPOINT
* Script runs and exits
* App crashes due to missing config/env vars
* Binary missing execute permissions

💡 **In short:** Check logs → exec into image → verify entrypoint & config.

---

## Q202: Docker build is failing with "No space left on device". What would you check?

🧩 **Checklist**

* Disk usage:

```bash
df -h
```

* Docker storage directory (`/var/lib/docker`):

```bash
du -sh /var/lib/docker/*
```

* Remove unused artifacts:

```bash
docker system prune -a
docker builder prune
```

* Check inode exhaustion:

```bash
df -i
```

💡 **In short:** Disk full under `/var/lib/docker` or inode exhaustion.

---

## Q203: A container cannot connect to another container on the same network. How do you debug?

🧩 **Steps**
1️⃣ Check if containers share a user-defined network:

```bash
docker network inspect <network>
```

2️⃣ Test DNS resolution:

```bash
docker exec app ping api
```

3️⃣ Test port reachability:

```bash
docker exec app curl http://api:8080
```

4️⃣ Validate service is listening inside container:

```bash
docker exec api netstat -tulpn
```

📋 **Common causes**

* Wrong network driver
* Service not binding to `0.0.0.0`
* Firewall rules
* Wrong port exposed/published

💡 **In short:** Check network, DNS, ports, and service bind addresses.

---

## Q204: Docker daemon fails to start. What logs would you examine?

🧩 **Daemon logs**

```bash
journalctl -u docker -xe
```

or:

```bash
/var/log/docker.log
```

🧩 **System health**

```bash
systemctl status docker
```

📋 **Common issues**

* Corrupted `/var/lib/docker`
* Incompatible storage driver
* Misconfigured `daemon.json`
* Kernel issues (cgroups, overlayfs)

💡 **In short:** Check daemon logs + storage driver + config errors.

---

## Q205: A container is running but not responding to requests. How do you investigate?

🧩 **Checks**
1️⃣ **Application logs**

```bash
docker logs <container>
```

2️⃣ **Internal port listening**

```bash
docker exec <container> netstat -tulpn
```

3️⃣ **Network mode**

```bash
docker inspect <container> | jq .[0].HostConfig.NetworkMode
```

4️⃣ **Ensure app binds to 0.0.0.0**
Many frameworks bind to localhost by default.

5️⃣ **Host-level firewall**

```bash
sudo iptables -L
```

6️⃣ **Health checks failure**

```bash
docker inspect --format='{{json .State.Health}}' <container>
```

💡 **In short:** Verify logs → port binding → health → firewall → networking.

---

## Q206: Docker build is extremely slow. What would you optimize?

🛠️ **Optimizations**

* Reduce build context (use `.dockerignore`)
* Use BuildKit
* Enable remote cache:

```bash
docker buildx build --cache-to=type=registry …
```

* Order layers to maximize caching
* Avoid large package installs
* Use small base images
* Ensure local disk isn’t slow or full

🧩 **Check build context size**

```bash
du -sh .
```

💡 **In short:** Optimize caching + context + base images + disk I/O.

---

## Q207: Image layers are not being cached during build. Why?

📋 **Common causes**

* Changed layer content (COPY order wrong)
* Base image changed (`latest` tag issue)
* Build context modified unintentionally
* `.dockerignore` missing entries → invalidates cache
* Using `ADD` with remote URLs → content changes frequently
* Not using BuildKit (legacy builder limited)

🧩 **Fix layering**

```Dockerfile
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
```

💡 **In short:** Cache breaks when layer content or order changes.

---

## Q208: A container is using excessive memory. How do you identify the cause?

🧩 **Troubleshooting Steps**
1️⃣ **Container stats**

```bash
docker stats <container>
```

2️⃣ **Inspect memory limits**

```bash
docker inspect <container> | jq .[].HostConfig.Memory
```

3️⃣ **Check logs for OOM kills**

```bash
dmesg | grep -i oom
```

4️⃣ **Profile application (heap, GC, leaks)**

* Node: `clinic`, Chrome DevTools
* Java: `jmap`, JFR
* Python: `tracemalloc`, `memray`

5️⃣ **Look for runaway processes**

```bash
docker exec <container> top
```

💡 **In short:** Use `docker stats`, inspect OOM, profile the app.

---

## Q209: Port mapping is not working and the application is not accessible. What would you check?

🧩 **Checklist**
1️⃣ Correct port publish?

```bash
docker run -p 8080:80 myapp
```

2️⃣ App binding?

* Must bind to `0.0.0.0`, not `127.0.0.1`.

3️⃣ Check container port:

```bash
docker exec <c> netstat -tulpn
```

4️⃣ Host firewall:

```bash
sudo ufw status
```

5️⃣ Conflicting processes on host port:

```bash
sudo lsof -i :8080
```

6️⃣ Wrong network mode (`host` mode bypasses `-p`).

💡 **In short:** Check binding, mapping, firewall, and port conflicts.

---

## Q210: Docker pull is failing with "TLS handshake timeout". How do you resolve this?

🧩 **Fixes**

* Check DNS:

```bash
dig registry-1.docker.io
```

* Increase timeout:

```bash
export DOCKER_CLIENT_TIMEOUT=300
export COMPOSE_HTTP_TIMEOUT=300
```

* Use registry mirrors:

```json
{ "registry-mirrors": ["https://mirror.gcr.io"] }
```

* Check firewall/SSL inspection devices
* Validate proxy settings:

```bash
env | grep -i proxy
```

💡 **In short:** Fix DNS/network latency or use a registry mirror.

---

## Q211: A volume mount is not working and files are not visible in the container. What's wrong?

📋 **Common causes**

* Wrong mount path or directory doesn’t exist
* Bind mount overwriting image-internal directory
* SELinux/AppArmor blocking mount
* Using relative paths incorrectly
* User permissions mismatch
* Trying to mount on a location owned by root

🧩 **Debug**

```bash
docker inspect <container> | jq .[].Mounts
```

🧩 **Fix (bind mount)**

```bash
docker run -v $(pwd)/data:/app/data myapp
```

🧩 **Fix (permission)**

```bash
sudo chown -R 1000:1000 ./data
```

💡 **In short:** Most issues come from incorrect paths, permissions, or mount ordering.

---
Below is your **README-style troubleshooting documentation** for **Q212–Q221 (Advanced Docker Scenarios)**.

---

## Q212: Docker Compose up fails with "network not found". How do you fix this?

🧠 **Overview**
Compose expects networks defined in `docker-compose.yml` or previously created. Missing or orphaned networks cause this error.

🧩 **Fix Steps**
1️⃣ Ensure network is defined:

```yaml
networks:
  backend:
```

2️⃣ Recreate missing network:

```bash
docker network create backend
```

3️⃣ Remove orphaned networks:

```bash
docker network prune
```

4️⃣ Ensure Compose project name matches:

```bash
docker compose -p myproj up
```

📋 **Common causes**

* Typo in network name
* Old Compose project referencing stale networks
* Manually deleted networks

💡 **In short:** Define or recreate the network; ensure names match.

---

## Q213: Containers cannot resolve DNS names. What would you investigate?

🧩 **Checklist**
1️⃣ Check Docker DNS:

```bash
docker exec app cat /etc/resolv.conf
```

2️⃣ Verify internal DNS works:

```bash
docker exec app ping api
```

3️⃣ Check host DNS:

```bash
cat /etc/resolv.conf
```

4️⃣ Inspect network:

```bash
docker network inspect <network>
```

5️⃣ If using corporate proxy: DNS interception/firewall issues.

📋 **Common causes**

* Network not user-defined (bridge default has limited DNS)
* Host DNS misconfigured
* CNI failures (in orchestrators)

💡 **In short:** Inspect `/etc/resolv.conf`, check network, test container-level DNS.

---

## Q214: A container is in "Created" state but won't start. How do you debug?

🧩 **Debug Steps**

```bash
docker container start <id>
docker logs <id>
docker inspect <id>
```

Check:

* ENTRYPOINT/CMD errors
* Missing files or permissions
* Port conflicts
* Read-only FS issues
* Required env vars missing

🧩 Run with shell:

```bash
docker run -it --entrypoint sh <image>
```

💡 **In short:** Logs + inspect + shell into container image.

---

## Q215: Docker ps shows different container IDs than what you expected. Why?

📋 **Reasons**

* Containers recreated by Compose (project-prefixed names)
* Old container removed and a new one created with new ID
* Using `docker ps` vs `docker ps -a` (stopped vs running)
* Multiple compose projects with the same service name
* Container ID *prefixes* are shown, not full IDs

🧩 Check with:

```bash
docker ps -a --no-trunc
```

💡 **In short:** Containers are recreated often, IDs change; `ps` shows only shortened IDs.

---

## Q216: Container logs are not appearing with docker logs command. What could be wrong?

📋 **Possible causes**

* Using a **non-logging driver** (e.g., `--log-driver=none`)
* Logging driver set to syslog/fluentd; logs not local
* App writes logs to files instead of STDOUT/STDERR
* TTY mode suppressing logs (`-t` used incorrectly)
* Container exited too early and logs rotated out

🧩 Check driver:

```bash
docker inspect <c> --format '{{.HostConfig.LogConfig.Type}}'
```

💡 **In short:** Docker logs only show STDOUT when using json-file driver.

---

## Q217: A health check is failing but the application seems to work. How do you debug?

🧩 **Steps**
1️⃣ Inspect health state:

```bash
docker inspect <c> --format '{{json .State.Health}}'
```

2️⃣ Run the same command manually:

```bash
docker exec <c> sh -c "<HEALTHCHECK_CMD>"
```

3️⃣ Check:

* Wrong port
* App takes longer to start → adjust `start-period`
* Missing dependencies
* Command exits with wrong exit code
* Container DNS failures inside health check

🧩 Example fix:

```Dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s \
  CMD curl -f http://localhost:8080/health || exit 1
```

💡 **In short:** Manually run the health check inside the container.

---

## Q218: Docker build fails with "unable to prepare context". What's the issue?

📋 **Common causes**

* Path to Dockerfile or context incorrect
* Missing permissions on build directory
* Special characters or symlinks causing issues
* Running build outside correct directory

🧩 Fix

```bash
docker build -t app .
docker build -f Dockerfile .
```

Check `.dockerignore` — it may accidentally exclude Dockerfile.

💡 **In short:** Fix the build context path or permissions.

---

## Q219: A multi-stage build is not reducing image size as expected. What would you check?

📋 **Checklist**

* Ensure you’re using the **final stage**:

```bash
docker build -t app --target final .
```

* Check if large files sneak in via COPY:

```Dockerfile
COPY . .   # BAD — use selective copy
```

* Check base images: alpine/distroless instead of ubuntu
* Use `dive` to analyze remaining layers
* Confirm build artifacts not accidentally copied:

```Dockerfile
COPY --from=builder /app/bin .
```

💡 **In short:** Validate COPY paths and base image choice.

---

## Q220: Environment variables are not being passed to the container. How do you fix this?

🧩 **Check 1: ENV vs ARG**
ARG works only at build time — won’t appear at runtime.

🧩 **Fix examples**

Pass via CLI:

```bash
docker run -e APP_ENV=prod myapp
```

Compose:

```yaml
environment:
  APP_ENV: prod
```

Using `.env`:

```
APP_ENV=prod
```

🧩 Check inside container:

```bash
docker exec <c> env
```

💡 **In short:** Use `ENV` or `-e`, not `ARG`, for runtime variables.

---

## Q221: A container keeps restarting in a loop. What would you investigate?

📋 **Investigations**

* **Health check failures**:

```bash
docker inspect <c> --format '{{json .State.Health}}'
```

* **Application crash** (check logs):

```bash
docker logs <c>
```

* **Restart policy** (auto-restart always):

```bash
docker inspect <c> | jq .[].HostConfig.RestartPolicy
```

* **Resource limits** causing OOM:

```bash
dmesg | grep -i oom
```

* **Configuration errors** (missing env vars, DB unreachable)

🧩 Disable restart loop temporarily:

```bash
docker update --restart=no <c>
```

💡 **In short:** Crashes, health-check failures, or bad config cause restart loops.

---

Below is your **README-style troubleshooting documentation** for **Q222–Q239 (Advanced Docker Troubleshooting)**.

---

## Q222: Docker daemon is consuming high CPU. What could be causing this?

🧠 **Overview**
High `dockerd` CPU can come from heavy image pulls, many concurrent container events, logging driver overhead, frequent container restarts, or corrupted storage metadata.

⚙️ **What to check**

* High event churn (start/stop loops).
* Large number of image pulls or pushes.
* Logging driver throughput (fluentd/syslog).
* Storage driver issues (overlay metadata churn).
* Many containers performing I/O heavy ops that cause daemon bookkeeping.

🧩 **Commands**

```bash
# daemon logs
journalctl -u docker -n 200 --no-pager
# check active events and restarts
docker ps -a --filter "status=restarting"
# check I/O and CPU per process
top -p $(pgrep dockerd)
iotop -o
```

✅ **Best Practices / Fixes**

* Reduce container churn and fix restart loops.
* Temporarily switch to `json-file` for debugging to rule out logging-driver load.
* Inspect and repair `/var/lib/docker` (careful).
* Restart dockerd after maintenance window.
* Upgrade Docker to latest stable release.

💡 **In short:** Investigate event churn, logging, storage driver; fix offending containers or upgrade/repair daemon.

---

## Q223: Cannot remove a container: "device or resource busy". How do you resolve this?

🧠 **Overview**
The error indicates mountpoints or processes still using container resources (bind mounts, volumes, or open file descriptors).

⚙️ **Steps**

1. Stop container:

```bash
docker stop <id>
```

2. Check mounts:

```bash
mount | grep <container_id_or_mountpoint>
```

3. List processes using mount:

```bash
lsof +f -- /path/to/mount
# or
fuser -m /path/to/mount
```

4. Kill offending processes and retry:

```bash
kill -9 <pid>
docker rm <id>
```

5. If systemd-managed mounts (like systemd-nspawn), unmount:

```bash
umount /path/to/mount
```

🧩 **Commands**

```bash
# show container mounts
docker inspect -f '{{json .Mounts}}' <id> | jq
# show processes using docker's graph dir
lsof +D /var/lib/docker
```

✅ **Best Practices**

* Avoid leaving shells/processes attached to volumes.
* Use `docker container prune` cautiously.
* Reboot as last resort if stale kernel handles persist.

💡 **In short:** Find and stop processes using the mount, unmount, then remove container.

---

## Q224: Docker network inspect shows no containers attached despite containers running. Why?

🧠 **Overview**
This often happens when containers are on a different network/project (Compose project name), using host network mode, or the network has been recreated so IDs changed.

⚙️ **What to check**

* Network driver and scope.
* Container's `NetworkSettings`.
* Compose project name mismatch or recreated networks.

🧩 **Commands**

```bash
# inspect network
docker network inspect <network>
# inspect container network info
docker inspect -f '{{json .NetworkSettings}}' <container> | jq
# check if container uses host network
docker inspect -f '{{.HostConfig.NetworkMode}}' <container>
```

✅ **Best Practices / Fixes**

* Ensure containers and network belong to same Compose project (`-p`).
* If using `--network host`, network inspect will not show attachment.
* Recreate network and attach container:

```bash
docker network connect <network> <container>
```

💡 **In short:** Container might be on a different network mode/project — verify container `NetworkSettings` and reconnect if needed.

---

## Q225: Container file permissions are incorrect causing application failures. How do you fix this?

🧠 **Overview**
Permission mismatches occur when host UID/GID differ from container expectations, or files copied in image have wrong ownership.

⚙️ **Fix approaches**

* Set ownership at build time (`--chown`) or runtime (`chown` on host).
* Run container as specific user with `-u UID:GID`.

🧩 **Examples**

```Dockerfile
COPY --chown=1000:1000 app/ /app
USER 1000
```

```bash
# runtime mount fix
sudo chown -R 1000:1000 ./host-dir
docker run -v $(pwd)/host-dir:/data -u 1000:1000 myapp
```

✅ **Best Practices**

* Prefer non-root user in image.
* Use `--chown` in `COPY`/`ADD`.
* For bind mounts, match host ownership or use entrypoint scripts to `chown` on startup (careful with performance).

💡 **In short:** Align UID/GID between host and container; use `--chown` or change ownership before running.

---

## Q226: Docker build fails with "COPY failed: stat". What path issue exists?

🧠 **Overview**
`COPY` `stat` errors usually mean the source path is missing in the build **context** or excluded by `.dockerignore`.

⚙️ **What to check**

* Are you running `docker build` from correct context directory?
* Is the source path spelled correctly and present?
* Is `.dockerignore` excluding the file?

🧩 **Examples**

```bash
# correct usage: run from project root where file exists
docker build -t app .
# or explicitly set context and Dockerfile
docker build -f ./docker/Dockerfile -t app ./context-dir
```

✅ **Best Practices**

* Keep Dockerfile and context paths explicit.
* Check `.dockerignore` contents.
* Use relative paths inside `COPY` that exist in the context.

💡 **In short:** The file to copy isn't in the build context or is ignored; verify paths and `.dockerignore`.

---

## Q227: A container cannot write to a mounted volume. What permission issue exists?

🧠 **Overview**
Write failures are usually due to host filesystem ownership/permissions, SELinux/AppArmor labels, or mount options like `ro`.

⚙️ **Checks & fixes**

* Verify mount is writable:

```bash
docker inspect -f '{{json .Mounts}}' <container> | jq
# check host fs perms
ls -ld /host/path
# try touch as container user
docker exec -it <c> sh -c 'touch /mount/path/test || echo FAIL'
```

* Fix ownership:

```bash
sudo chown -R 1000:1000 /host/path
```

* For SELinux-enabled hosts, add `:z` or `:Z`:

```bash
docker run -v /host/dir:/container/dir:z myapp
```

* Ensure mount not read-only:

```bash
docker run -v /host/dir:/container/dir:rw ...
```

✅ **Best Practices**

* Create directories on host with correct owner before mounting.
* Use named volumes to avoid host permission surprises.
* Handle SELinux/AppArmor labeling when needed.

💡 **In short:** Adjust host ownership, SELinux labels, or mount mode to allow writes.

---

## Q228: Docker Compose depends_on is not enforcing startup order. How do you handle this?

🧠 **Overview**
`depends_on` only controls start order, not readiness. Services may start but not be ready to accept connections.

⚙️ **Solutions**

* Use healthchecks and `condition: service_healthy` (Compose v3.9+).
* Add init/wait-for scripts (e.g., `wait-for`, `dockerize`) in consumer service.
* Implement retries/backoff in the application.

🧩 **Example (compose)**

```yaml
services:
  db:
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "postgres"]
      interval: 10s
      retries: 5

  app:
    depends_on:
      db:
        condition: service_healthy
```

✅ **Best Practices**

* Prefer application-level retries and readiness probes.
* Use orchestration (Kubernetes) for robust dependency management when at scale.

💡 **In short:** Use health checks + `condition: service_healthy` or implement wait-for logic; `depends_on` alone is insufficient.

---

## Q229: Containers are using the wrong DNS servers. How do you configure custom DNS?

🧠 **Overview**
Docker containers inherit DNS from Docker daemon or host; you can override via daemon config, container flags, or Compose.

⚙️ **Configuration options**

* Per-container:

```bash
docker run --dns 10.0.0.2 --dns-search example.com myapp
```

* Global daemon `/etc/docker/daemon.json`:

```json
{ "dns": ["10.0.0.2", "8.8.8.8"] }
```

* Compose:

```yaml
services:
  app:
    dns:
      - 10.0.0.2
```

✅ **Best Practices**

* Avoid injecting corporate DNS that causes split-horizon issues unless necessary.
* For orchestrators, configure cluster DNS (CoreDNS) appropriately.

💡 **In short:** Use `--dns` per run or set daemon `dns` to enforce custom resolvers.

---

## Q230: A containerized application is experiencing network latency. What would you investigate?

🧠 **Overview**
Network latency can come from host network stack, overlay networks, MTU mismatches, DNS resolution delays, or load balancer misconfiguration.

⚙️ **Checklist**

* Measure latency host ↔ container vs container ↔ container:

```bash
# inside container
ping -c 10 <peer>
# from host to container IP
ping -c 10 <container_ip>
```

* Check MTU and fragmentation:

```bash
ip link show
ip addr show docker0
```

* Inspect overlay/vxlan MTU (often 1450) and adjust.
* Check DNS latency `/etc/resolv.conf` and use local caching.
* Look at network namespaces and iptables rules causing NAT overhead.
* Check load balancer or ingress causing extra hops.

🧩 **Tools**
`ping`, `traceroute`, `ss`, `tcpdump`, `wireshark` (pcap), `iftop`.

✅ **Best Practices**

* Use host networking for low-latency services when safe.
* Tune MTU consistently across hosts.
* Use service mesh only when benefits outweigh added latency.

💡 **In short:** Measure latencies at different hops, check MTU/NAT, DNS, and overlay overhead.

---

## Q231: Docker build is not using BuildKit despite being enabled. What configuration is wrong?

🧠 **Overview**
BuildKit may be disabled in environment, daemon features, or you're invoking legacy build command without enabling BuildKit.

⚙️ **What to check**

* Environment variable: `DOCKER_BUILDKIT=1` set for the shell/CI job.
* Daemon `features.buildkit` enabled in `/etc/docker/daemon.json`.
* Using `docker buildx` vs `docker build` — some CI runners prefer `buildx`.
* Older Docker CLI/daemon versions without BuildKit support.

🧩 **Commands**

```bash
# enable per process
DOCKER_BUILDKIT=1 docker build -t myapp .
# check daemon
cat /etc/docker/daemon.json
```

✅ **Best Practices**

* Prefer `docker buildx build` in CI for consistent BuildKit behavior.
* Ensure both client & server Docker versions support BuildKit.

💡 **In short:** Verify `DOCKER_BUILDKIT=1`, daemon features, and use `buildx` if needed.

---

## Q232: Image push to registry is failing with "denied: access forbidden". What would you check?

🧠 **Overview**
This indicates auth/permissions issues: wrong credentials, lack of push rights, or repository policy preventing push.

⚙️ **Checklist**

* Logged in to registry:

```bash
docker login myregistry.example.com
```

* Correct namespace/repo name (some registries require org prefix).
* User has push permission to repository.
* Registry enforces signed images or policy blocking pushes.
* Check token expiry for CI credentials.

🧩 **Commands**

```bash
docker pull myregistry.example.com/myrepo/myimage:tag
docker push myregistry.example.com/myrepo/myimage:tag
# inspect response for 403 details
```

✅ **Best Practices**

* Use automation principal with least-privilege push rights.
* Rotate credentials and use service accounts / tokens.
* For ECR/GCR/ACR, ensure CLI auth (aws ecr get-login-password, gcloud auth configure-docker).

💡 **In short:** Re-authenticate, verify repo name and permissions, check registry policies.

---

## Q233: Docker exec is failing with "container not running". Why might a container show as running but reject exec?

🧠 **Overview**
Possible race conditions, PID namespace weirdness, or container using `--init` or paused state. Sometimes `docker ps` shows restarting containers while transiently appearing "running" in UI.

⚙️ **What to check**

* Actual state:

```bash
docker inspect -f '{{.State.Status}} {{.State.Running}} {{.State.Restarting}}' <id>
```

* If container is `paused`:

```bash
docker container ls --filter "status=paused"
docker unpause <id>
```

* If the container just exited quickly after `ps` snapshot, `exec` will fail.
* Check if container uses a custom runtime that disallows exec.

🧩 **Commands**

```bash
docker inspect <id> | jq .State
```

✅ **Best Practices**

* Use `docker logs` to see crash reason.
* Avoid relying on `ps` during state transitions; script with retries.

💡 **In short:** Container may be paused, restarting, or exited between checks — inspect `.State` and logs.

---

## Q234: A container is showing "unhealthy" status. How do you debug the health check?

🧠 **Overview**
Unhealthy means the configured healthcheck command returned non-zero repeatedly or timed out.

⚙️ **Steps**

1. Inspect health detail:

```bash
docker inspect --format='{{json .State.Health}}' <id> | jq
```

2. Run the health command manually inside the container:

```bash
docker exec -it <id> sh -c "<HEALTHCHECK_CMD>"
```

3. Check timing: adjust `start-period`, `interval`, `timeout`, `retries`.
4. Verify service endpoint (port binding, host/localhost).
5. Look at application logs for errors during health probes.

🧩 **Example**

```Dockerfile
HEALTHCHECK --start-period=30s --interval=10s --timeout=3s CMD curl -f http://localhost:8080/health || exit 1
```

✅ **Best Practices**

* Keep healthchecks lightweight and deterministic.
* Use `start-period` for slow-starting apps.
* Ensure healthcheck uses correct network interface (0.0.0.0 vs localhost).

💡 **In short:** Inspect health state, run check manually, and tune timings.

---

## Q235: Docker Compose volumes are not persisting data between restarts. What's wrong?

🧠 **Overview**
Causes: using anonymous volumes that get removed, mounting ephemeral tmpfs, or recreating containers with `docker-compose down -v` which removes volumes.

⚙️ **What to check**

* Are you using named volumes?

```yaml
volumes:
  dbdata:
services:
  db:
    volumes:
      - dbdata:/var/lib/postgresql/data
```

* Did you run `docker-compose down -v`? That deletes volumes.
* Are you using `tmpfs` mounts? Those are ephemeral.

🧩 **Commands**

```bash
docker volume ls
docker volume inspect <vol>
```

✅ **Best Practices**

* Use named volumes or host paths for persistence.
* Avoid `down -v` in production.
* Backup volumes to external storage (tar/S3).

💡 **In short:** Use named volumes and avoid commands that remove volumes; `tmpfs` and `down -v` cause data loss.

---

## Q236: Container networking is slow compared to host networking. What would you investigate?

🧠 **Overview**
Overlay networks, NAT, iptables rules, MTU mismatches, and network namespace overhead can slow container networking.

⚙️ **Checklist**

* Compare latency & throughput host vs container.
* Check if using overlay/VXLAN; measure extra encapsulation overhead.
* Inspect iptables rules and conntrack table saturation:

```bash
sudo conntrack -L | wc -l
sudo sysctl net.netfilter.nf_conntrack_max
```

* Verify MTU across hosts and path MTU causing fragmentation.
* Check CPU saturation causing packet processing delays.

🧩 **Tools**
`iperf3`, `tc`, `tcpdump` (compare inside/outside container).

✅ **Best Practices**

* Use host networking for latency-sensitive services.
* Tune conntrack table and netfilter settings.
* Ensure consistent MTU and avoid double encapsulation.

💡 **In short:** Overlay/NAT and conntrack/MTU issues commonly explain slower container networking.

---

## Q237: Cannot connect to Docker daemon on remote host. What configuration is needed?

🧠 **Overview**
Remote access requires `dockerd` listening on TCP, proper TLS config, and firewall rules.

⚙️ **Steps**

1. Configure daemon to listen (securely) in `/etc/docker/daemon.json`:

```json
{
  "hosts": ["unix:///var/run/docker.sock", "tcp://0.0.0.0:2376"]
}
```

2. Use TLS certificates for authentication (recommended) or configure SSH tunnel.
3. Open port 2376 (or chosen port) in firewall/security groups.
4. From client:

```bash
export DOCKER_HOST=tcp://host:2376
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH=~/.docker/certs
docker info
```

✅ **Best Practices**

* Never expose Docker API without TLS + mutual auth.
* Use SSH `docker -H ssh://user@host` as a secure alternative.
* Use Bastion/Jumphost for admin access.

💡 **In short:** Enable TCP socket with TLS or use SSH; open firewall and provide proper certs.

---

## Q238: Docker build fails with "invalid reference format". What syntax error exists?

🧠 **Overview**
This indicates an incorrect image name/tag format (bad characters, missing tag when required, using uppercase in some contexts, or spaces).

⚙️ **Common mistakes**

* Using spaces in image name or tag:

```bash
docker build -t "myapp: latest" .   # invalid
```

* Missing repo/name part when pushing to registry requiring namespace.
* Using uppercase letters / illegal chars in tag.

🧩 **Valid examples**

```bash
docker build -t myrepo/myapp:1.2.3 .
docker tag myapp myrepo/myapp:1.2.3
```

✅ **Best Practices**

* Use lowercase, `[a-z0-9._-]` for repo and tag parts.
* Avoid spaces and special characters.

💡 **In short:** Fix the image name/tag syntax — no spaces, use allowed characters and valid `name:tag` format.

---

## Q239: A container has orphaned volumes consuming disk space. How do you clean them up?

🧠 **Overview**
Orphaned volumes (unused) linger and consume space; Docker provides commands to prune them safely.

⚙️ **Commands**

* List dangling volumes:

```bash
docker volume ls -f dangling=true
```

* Inspect to confirm:

```bash
docker volume inspect <vol>
```

* Remove all unused volumes interactively:

```bash
docker volume prune
```

* Remove specific volume:

```bash
docker volume rm <vol_name>
```

🧩 **Automated cleanup**

```bash
# careful: will remove unused images, containers, networks, volumes
docker system prune --volumes
```

✅ **Best Practices**

* Periodically audit volumes before pruning.
* Keep backups of important volumes before deletion.
* Use naming conventions for volumes to identify purpose.

💡 **In short:** Use `docker volume prune` or `docker volume rm` after verification to reclaim disk space.

---

Below is your **README-style troubleshooting documentation** for **Q240–Q254 (Advanced Docker Troubleshooting & Scenarios)**.

---

## Q240: ARG values are not being substituted in Dockerfile. What's the syntax issue?

🧠 **Overview**
`ARG` must be **declared before** being used, and cannot be referenced before its definition. Also, `ARG` is only available at **build time**, not runtime.

🧩 **Correct syntax**

```Dockerfile
ARG VERSION=1.0
FROM alpine:${VERSION}
```

🧩 **Common mistakes**

* Using `ARG` before declaring it:

```Dockerfile
FROM alpine:${VERSION}   # VERSION not declared yet
ARG VERSION
```

* Expecting ARG to work at runtime (use `ENV` instead).

💡 **In short:** Declare ARG before use; ARG is build-time only.

---

## Q241: Docker Compose override file is not being applied. What would you check?

🧠 **Overview**
Compose merges `docker-compose.override.yml` automatically *only if filenames match* and project name matches.

📋 **Checklist**

* Ensure file name is exactly `docker-compose.override.yml`.
* Check project directory is correct (`docker compose` uses working directory).
* Using Compose V2? It supports auto-merge; older Compose may require explicit `-f`.

🧩 **Explicit usage**

```bash
docker compose -f docker-compose.yml -f custom.override.yml up
```

💡 **In short:** Check filename, working directory, and merge order.

---

## Q242: Container startup is taking much longer than expected. What would you profile?

🧠 **Overview**
Slow startup can be due to image size, slow mounts, app initialization, healthcheck gates, DNS latency, or dependency waits.

🧩 **Profile the following:**

* Image pull time (`docker pull` speed).
* Startup script steps (`ENTRYPOINT` debugging).
* Application boot logs.
* Wait-for scripts & DB connectivity.
* DNS resolution slowdown.
* Volume mount latency (NFS/EFS).
* Health check `start-period`.

🧩 **Debug**

```bash
docker run -it --entrypoint bash myapp
time ./start.sh
```

💡 **In short:** Measure pull time, entrypoint execution, dependencies, and DNS/mount latency.

---

## Q243: A bind mount is not reflecting file changes in real-time. What caching issue exists?

🧠 **Overview**
On macOS/Windows Docker Desktop, bind mounts use file sync layers where changes may be cached due to FUSE/virtualization.

📋 **Fixes**

* Use `cached`, `delegated`, or `consistent` options to tune behavior:

```bash
docker run -v $(pwd):/app:delegated app
```

* Use **Mutagen**, **docker-sync**, or WSL2 for better file sync.
* Avoid mounting large directories on Desktop environments.

💡 **In short:** Desktop bind mounts use slow, cached file sync → use delegated/cached or alternative sync tools.

---

## Q244: Docker prune removed more than intended. How do you recover?

⚠️ **Overview**
Prune permanently deletes unused images, containers, networks, and optionally volumes. Recovery is limited.

🧩 **Attempt recovery**

* Check if data was stored on persistent volumes not deleted:

```bash
docker volume ls
```

* Restore images from registry using tags/digests:

```bash
docker pull <image>
```

* If volumes lost → restore from backups or snapshots (EBS, snapshots, NFS backups).

📋 **Recovery limits**

* Deleted volumes cannot be recovered unless backed up.
* Deleted local-only images must be rebuilt.

💡 **In short:** Recover from backups or remote registry; prune is destructive with no native restore.

---

## Q245: Container timezone is incorrect. How do you set it properly?

🧩 **Methods**
1️⃣ Set timezone inside container via environment variable (if image supports it):

```bash
docker run -e TZ=Asia/Kolkata myapp
```

2️⃣ Mount host timezone:

```bash
docker run -v /etc/localtime:/etc/localtime:ro myapp
```

3️⃣ Install tzdata (Debian/Ubuntu-based):

```Dockerfile
RUN apt-get update && apt-get install -y tzdata
ENV TZ=Asia/Kolkata
```

💡 **In short:** Set `TZ`, mount `/etc/localtime`, or install tzdata depending on image.

---

## Q246: A container's IP address keeps changing. How do you assign a static IP?

🧠 **Overview**
Static IPs require a **user-defined bridge network** with a defined subnet.

🧩 **Example**

```bash
docker network create --subnet=172.20.0.0/16 mynet
docker run --net=mynet --ip=172.20.0.10 myapp
```

⚠️ Static IPs only work on custom bridge networks, not default bridge or overlay networks.

💡 **In short:** Create custom network → assign `--ip`.

---

## Q247: Docker build cache is being invalidated unnecessarily. How do you optimize layer order?

🧠 **Overview**
Layers must be ordered from **least frequently changing → most frequently changing**.

🧩 **Good layering**

```Dockerfile
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
RUN python setup.py install
```

🧩 **Bad layering**

```Dockerfile
COPY . .
RUN pip install -r requirements.txt
```

📋 **Tips**

* COPY only necessary files early.
* Use `.dockerignore` to reduce context churn.
* Pin base images.

💡 **In short:** Put dependency steps first and app code later.

---

## Q248: Containers cannot access the internet. What network configuration is wrong?

🧠 **Checklist**

* Check host forwarding/NAT:

```bash
iptables -t nat -L -n
```

* Check Docker's bridge network is up:

```bash
ip addr show docker0
```

* Check DNS:

```bash
docker run busybox nslookup google.com
```

* Corporate proxies may block outbound connections.
* IP forwarding disabled:

```bash
sysctl net.ipv4.ip_forward
```

🧩 **Fix**

```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

💡 **In short:** NAT/DNS/IP-forwarding misconfiguration commonly causes no-internet issues.

---

## Q249: Docker registry authentication is failing. How do you troubleshoot credentials?

🧠 **Checklist**
1️⃣ Validate login:

```bash
docker login <registry>
```

2️⃣ Check credential store:

```bash
cat ~/.docker/config.json
```

3️⃣ For ECR:

```bash
aws ecr get-login-password | docker login ...
```

4️⃣ For GCR:

```bash
gcloud auth configure-docker
```

5️⃣ For ACR:

```bash
az acr login -n <registry>
```

📋 **Common causes**

* Expired tokens
* Wrong repo name or namespace
* Configured credential helper interfering
* TLS inspection breaking auth requests

💡 **In short:** Re-auth, verify config.json, check registry-specific login.

---

## Q250: A container exits with code 137. What does this indicate and how do you fix it?

🧠 **Overview**
Exit code **137 = SIGKILL**, often due to **OOM kill** (Out-of-memory).

🧩 **Confirm**

```bash
dmesg | grep -i kill
docker inspect <c> | jq .[].State
```

🧩 **Fixes**

* Increase memory:

```bash
docker run --memory=1g myapp
```

* Optimize app memory usage.
* Add swap (non-production usually).
* Tune GC settings (Java, Node).
* Fix memory leaks.

💡 **In short:** Code 137 means OOM killed → increase memory or fix leak.

---

## Q251: ENTRYPOINT is not executing the correct command. What syntax issue exists?

🧠 **Overview**
ENTRYPOINT must be in **exec form** or scripts must have proper shebang and execute permissions.

📋 **Common mistakes**

* Shell form doing unexpected parsing:

```Dockerfile
ENTRYPOINT python app.py   # BAD
```

* Exec form correct:

```Dockerfile
ENTRYPOINT ["python", "app.py"]
```

* Missing shebang in entrypoint script:

```bash
#!/bin/sh
```

* Script not executable:

```bash
chmod +x entrypoint.sh
```

💡 **In short:** Use exec form or fix script permissions.

---

## Q252: Docker Compose is using the wrong .env file. How do you specify the correct one?

🧠 **Overview**
Compose automatically loads `.env` from the project directory. To override, specify `--env-file`.

🧩 **Correct usage**

```bash
docker compose --env-file ./config/prod.env up
```

🧩 **Check**

* Working directory
* Filename must be `.env` for auto-discovery

💡 **In short:** Use `--env-file` explicitly to override default.

---

## Q253: Container resource limits are being ignored. What runtime issue exists?

🧠 **Overview**
Ignored limits occur when using **cgroup v1/v2 mismatches**, rootless Docker without proper cgroup support, or host kernel lacking resource isolation.

📋 **Checklist**

* Check cgroup mode:

```bash
docker info | grep -i cgroup
```

* Rootless Docker cannot enforce all CPU/memory limits.
* Docker Desktop uses virtualization → limits apply differently.
* Systemd must delegate cgroup controllers.

🧩 **Fix (systemd delegation)**

```ini
[Service]
Delegate=cpu cpuset memory
```

💡 **In short:** Ensure cgroups are supported and configured; rootless Docker has limit restrictions.

---

## Q254: A scratch-based image fails with "exec format error". What's wrong?

🧠 **Overview**
This means the binary is not compatible with the container architecture or not statically compiled.

📋 **Causes**

* Running an ARM binary on an x86 host or vice versa.
* Binary not compiled as **static** → missing dynamic libraries.
* Using wrong cross-compiled target.

🧩 **Correct Go example**

```bash
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app
```

🧩 **Resulting Dockerfile**

```Dockerfile
FROM scratch
COPY app /app
ENTRYPOINT ["/app"]
```

💡 **In short:** Ensure binary is static and built for correct architecture.

---

Below is your **README-style troubleshooting documentation** for **Q255–Q270 (Advanced Docker Troubleshooting)**.

---

## Q255: Docker build context is too large causing slow builds. How do you reduce it?

🧠 **Overview**
Large build contexts slow upload time to the Docker daemon/BuildKit and invalidate cache unnecessarily.

🧩 **Fix Strategies**

* Use `.dockerignore` to exclude unnecessary files:

```
.git/
node_modules/
tests/
*.log
```

* Build from a smaller subdirectory:

```bash
docker build -f docker/Dockerfile ./app
```

* Avoid copying entire project:

```Dockerfile
COPY src/ /app/src/      # GOOD
COPY . /app              # BAD
```

📋 **Check context size**

```bash
docker build --progress=plain . | head
du -sh .
```

💡 **In short:** Shrink context via `.dockerignore` and selective COPY.

---

## Q256: Container cannot write to stdout/stderr. What process issue exists?

🧠 **Overview**
STDOUT/STDERR must remain open. Issues occur when ENTRYPOINT scripts redirect output, background processes detach, or PID 1 closes standard streams.

📋 **Common causes**

* App daemonizes itself (`nohup`, `--daemon`).
* ENTRYPOINT script redirects output: `command > /dev/null`.
* Process uses `exec` incorrectly.
* TTY allocation issues (`-t` misuse in non-interactive containers).

🧩 **Debug**

```bash
docker logs <container> --follow
docker exec -it <container> ps -ef
```

🧩 **Fix**

* Use `exec` in entrypoint:

```bash
exec python app.py
```

* Disable daemon mode:

```
gunicorn --daemon off
```

💡 **In short:** The main process must run in foreground and keep stdout/stderr open.

---

## Q257: Docker stats shows 0% CPU usage for an active container. Why?

🧠 **Causes**

* Process running inside container is **sleeping** or I/O bound, not CPU bound.
* Container using **host PID namespace** → stats may not attribute usage correctly.
* Running under **cgroup v2** with older Docker → inaccurate CPU metrics.
* Process running outside the container (spawned incorrectly).

🧩 **Debug**

```bash
docker top <id>
pid=$(docker inspect -f '{{.State.Pid}}' <id>)
ps -p $pid -o %cpu
```

💡 **In short:** Stats may not show CPU if process idle, using host PID, or due to cgroup accounting issues.

---

## Q258: A container's /etc/hosts file is not being updated with linked containers. What's wrong?

🧠 **Overview**
`--link` is deprecated. Modern networking uses **DNS-based service discovery** on user-defined networks.

📋 **Fix**

* Use a user-defined bridge network:

```bash
docker network create backend
docker run --net backend --name api api-image
docker run --net backend --name app app-image
```

* Then containers resolve each other via DNS:

```
api → app
app → api
```

💡 **In short:** /etc/hosts is static; use Docker DNS on user networks.

---

## Q259: BuildKit secrets are being exposed in image layers. How do you fix this?

🧠 **Overview**
Secrets leak when copied into layers instead of using BuildKit secret mounts.

🧩 **Correct usage**

```Dockerfile
# DO NOT: COPY secret into image
# DO: use BuildKit secret mount
RUN --mount=type=secret,id=mysecret \
    cat /run/secrets/mysecret > /tmp/output
```

🧩 **Build command**

```bash
docker buildx build --secret id=mysecret,src=./secret.txt .
```

📋 **Verify no secret in layers**

```bash
dive <image>
docker history <image>
```

💡 **In short:** Use `--mount=type=secret` so secrets stay out of image layers.

---

## Q260: Docker Compose service discovery is not working between services. What configuration is missing?

🧠 **Overview**
Service discovery works only on **user-defined networks**, not the default network unless Compose creates one.

🧩 **Fix**

```yaml
services:
  api:
    networks: [backend]

  app:
    networks: [backend]

networks:
  backend:
```

📋 **Service discovery rules**

* Services resolve by name *only within shared networks*.
* Must not use `network_mode: host` if you want DNS-based discovery.

💡 **In short:** Services must share a user-defined network.

---

## Q261: A container built on one architecture won't run on another. How do you handle multi-arch?

🧠 **Overview**
Image architecture must match host CPU (amd64, arm64). Build multi-arch images with BuildX.

🧩 **Build multi-arch**

```bash
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 \
  -t myrepo/myapp:latest --push .
```

🧩 **Inspect**

```bash
docker manifest inspect myrepo/myapp:latest
```

💡 **In short:** Build with BuildX for cross-platform compatibility.

---

## Q262: Docker overlay2 storage driver is consuming excessive space. How do you troubleshoot?

🧠 **Overview**
Overlay2 stores layer diffs; bloat occurs from container writes, dangling layers, build cache, and unused images.

🧩 **Troubleshooting**

```bash
du -sh /var/lib/docker/overlay2
docker system df
docker system prune
docker builder prune
```

📋 **Also check**

* Long-lived containers writing frequently.
* Huge writable layers (logs, caches).
* Remove unused volumes if needed:

```bash
docker volume prune
```

💡 **In short:** Inspect overlay2 directory, prune unused images/layers, reduce container writes.

---

## Q263: Container time is out of sync with host. How do you synchronize it?

🧠 **Overview**
Containers use the host kernel clock; desync occurs if host isn't synced or virtualization layer introduces drift.

🧩 **Fix**

* Sync host clock (NTP/chrony):

```bash
timedatectl status
sudo systemctl restart chrony
```

* Restart containers after host sync.
* In Docker Desktop, ensure VM time sync is enabled.

💡 **In short:** Fix the host clock; containers inherit host time.

---

## Q264: Docker API version mismatch between client and server. How do you resolve this?

🧠 **Overview**
Occurs when Docker CLI and daemon differ in supported API versions.

🧩 **Check versions**

```bash
docker version
```

🧩 **Fix options**

* Upgrade Docker client or server.
* Set compatibility environment variable:

```bash
export DOCKER_API_VERSION=1.41
```

* Ensure same Docker version on all nodes in CI.

💡 **In short:** Align CLI/server versions or set `DOCKER_API_VERSION`.

---

## Q265: A container has orphaned processes after main process exits. How do you handle PID 1?

🧠 **Overview**
PID 1 in containers doesn't reap zombies unless implemented. Use an init process.

🧩 **Fix**

```bash
docker run --init myapp
```

Or embed tini in image:

```Dockerfile
ENTRYPOINT ["/usr/bin/tini", "--", "myapp"]
```

📋 **Symptoms**

* Zombie processes
* defunct PIDs visible inside container

💡 **In short:** Use `--init` or tini to ensure PID 1 reaps children.

---

## Q266: Docker build is not respecting .dockerignore. What would you verify?

🧠 **Checklist**

* File name is `.dockerignore` (not `.dockerignore.txt`).
* File is in the build **context directory**, not next to Dockerfile if contexts differ.
* Patterns are correct (glob syntax):

```
node_modules/
*.log
```

* Confirm build context path:

```bash
docker build -f docker/Dockerfile ./context
```

💡 **In short:** Ensure `.dockerignore` exists in context dir and patterns match.

---

## Q267: Container cannot resolve external DNS but can resolve container names. What's wrong?

🧠 **Overview**
Internal DNS works (Docker DNS), but upstream DNS (Google, company DNS) failing means `/etc/resolv.conf` or host DNS is misconfigured.

🧩 **Debug**

```bash
docker exec app cat /etc/resolv.conf
nslookup google.com
```

Check host’s `/etc/resolv.conf`, DNS servers reachable, firewall blocking outbound 53/UDP.

🧩 **Fix**

```json
{
  "dns": ["8.8.8.8", "1.1.1.1"]
}
```

Reload Docker.

💡 **In short:** Configure daemon DNS to valid resolvers.

---

## Q268: A tmpfs mount is not providing the expected performance. What would you check?

🧠 **Overview**
tmpfs should be RAM-backed, but limits or misconfiguration can degrade performance.

📋 **Investigate**

* tmpfs size:

```bash
docker inspect <c> | jq .[].HostConfig.Tmpfs
```

* System memory pressure (swap usage).
* NUMA node imbalance.
* If using Docker Desktop → tmpfs inside VM, not real RAM.
* I/O benchmark inside container:

```bash
dd if=/dev/zero of=/tmp/test bs=4k count=100000
```

💡 **In short:** Check tmpfs size, host memory pressure, and virtualization overhead.

---

## Q269: Docker system df shows large "Build Cache" usage. How do you clean it safely?

🧠 **Overview**
BuildKit caches layers, mounts, and intermediate results.

🧩 **Inspect**

```bash
docker system df --verbose
```

🧩 **Clean**

```bash
docker builder prune
docker builder prune --all  # removes all cache, use cautiously
```

🧩 **Selective prune by buildx builder**

```bash
docker buildx prune
docker buildx prune --all
```

💡 **In short:** Use `docker builder prune` to safely clean cached layers.

---

## Q270: Container labels are not being applied despite being defined in Dockerfile. How do you debug this?

🧠 **Checklist**

* Labels overridden by `docker run --label` or Compose labels.
* Using older image tag (not rebuilt).
* Labels defined after `FROM` but not in final stage of multi-stage build.
* Inspecting wrong image.

🧩 **Check**

```bash
docker inspect <image> | jq .[0].Config.Labels
```

🧩 **Correct labeling in multi-stage**

```Dockerfile
FROM base AS final
LABEL version="1.0"
```

💡 **In short:** Ensure labels are in the **final stage**, image rebuilt, and not overridden by runtime config.
