Perfect! Let’s go step by step, keeping it **concise, clear, and interview-ready**. I’ll split it into your sections.

---

## **1️⃣ Basics & Fundamentals**

**1. What is Docker and how does it differ from a virtual machine?**

* **Docker:** Containerization platform that packages apps with dependencies; lightweight, shares host OS kernel.
* **Virtual Machine (VM):** Full OS per instance; heavier, requires hypervisor.

| Feature     | Docker Container      | Virtual Machine    |
| ----------- | --------------------- | ------------------ |
| OS          | Shares host OS kernel | Each VM has own OS |
| Size        | Lightweight (\~MBs)   | Heavy (\~GBs)      |
| Boot Time   | Seconds               | Minutes            |
| Performance | Near-native           | Slight overhead    |

---

**2. Difference between container images and containers**

* **Image:** Read-only template (like a snapshot).
* **Container:** Running instance of an image with isolated filesystem and processes.

---

**3. Key components of Docker architecture**

* **Docker Daemon (`dockerd`):** Runs in background, builds images, runs containers.
* **Docker CLI (`docker`):** User interface to communicate with daemon.
* **Registry:** Repository for images (e.g., Docker Hub, private registry).

---

**4. Dockerfile & its use**

* **Dockerfile:** Text file with instructions to build an image (`FROM`, `RUN`, `COPY`, etc.).
* **Why:** Automates reproducible builds.

---

**5. Difference between `docker pull` and `docker run`**

| Command       | Purpose                                      |
| ------------- | -------------------------------------------- |
| `docker pull` | Downloads image from registry                |
| `docker run`  | Creates and starts a container from an image |

---

**6. Docker isolation of processes & filesystem**

* Uses **namespaces** (PID, network, mount, UTS) → process isolation.
* Uses **cgroups** → resource limits (CPU, memory).
* Each container has its **own filesystem** (overlayfs).

---

**7. Layered images concept**

* Images are built in **layers**; each Dockerfile instruction creates a layer.
* Layers are **cached**, reused to speed up builds.

---

## **2️⃣ Docker Images & Containers**

**1. Difference between Docker image & container**

* Already covered: Image = template, Container = running instance.

---

**2. How to create Docker image from Dockerfile**

```bash
docker build -t myimage:1.0 .
```

* `-t` → tag name
* `.` → context (current folder)

---

**3. Difference between `docker build` & `docker commit`**

| Command         | Purpose                                 |
| --------------- | --------------------------------------- |
| `docker build`  | Build image from Dockerfile             |
| `docker commit` | Save a running container as a new image |

---

**4. Difference between `docker run -it` and `docker run -d`**

| Option | Behavior                                 |
| ------ | ---------------------------------------- |
| `-it`  | Interactive + terminal (attach to shell) |
| `-d`   | Detached mode (runs in background)       |

---

**5. Inspect running container or image**

```bash
docker ps                 # running containers
docker ps -a              # all containers
docker inspect <container> # detailed JSON info
docker image inspect <image>
```

---

**6. Dangling image & removal**

* **Dangling image:** Untagged intermediate images (`<none>`).
* **Remove:**

```bash
docker image prune
```

---

**7. Docker cache image layers during build**

* Each layer is cached based on **instruction & context**.
* Unchanged layers are reused → faster builds.

---

## **3️⃣ Dockerfile Specific**

**1. CMD vs ENTRYPOINT**

| Feature     | CMD                                  | ENTRYPOINT             |
| ----------- | ------------------------------------ | ---------------------- |
| Purpose     | Default args for container           | Fixed command to run   |
| Overridable | Yes                                  | Harder to override     |
| Example     | `CMD ["nginx", "-g", "daemon off;"]` | `ENTRYPOINT ["nginx"]` |

---

**2. Combine CMD & ENTRYPOINT**

* CMD provides **default arguments** to ENTRYPOINT.

```dockerfile
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
```

* Result: `nginx -g 'daemon off;'`

---

**3. RUN vs CMD vs ENTRYPOINT vs ENV vs ARG**

| Instruction | Purpose                                           |
| ----------- | ------------------------------------------------- |
| RUN         | Executes commands at **build time**               |
| CMD         | Default command for **container start**           |
| ENTRYPOINT  | Main command that **cannot be easily overridden** |
| ENV         | Sets **environment variables** (runtime)          |
| ARG         | Build-time variable (not persisted in container)  |

---

**4. WORKDIR & COPY**

* **WORKDIR:** Sets working directory for following instructions.
* **COPY:** Copies files/folders from build context to image.

```dockerfile
WORKDIR /app
COPY . .
```

---

**5. EXPOSE vs `-p`**

| EXPOSE        | `-p host:container`              |
| ------------- | -------------------------------- |
| Declares port | Maps container port to host port |
| Documentation | Active runtime mapping           |

---

**6. Build-time ARG vs ENV**

* **ARG:** Only during build (`docker build --build-arg`).
* **ENV:** Persists in container, available at runtime.

---

**7. Optimize Dockerfile for smaller image**

* Use **multi-stage builds**
* Minimize layers, remove unnecessary packages, use smaller base images (`alpine`)

---

**8. Multi-stage builds & benefits**

```dockerfile
# Build stage
FROM golang:1.20 AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp

# Final stage
FROM alpine:latest
COPY --from=builder /app/myapp /myapp
CMD ["/myapp"]
```

* **Benefits:** Smaller final image, only production artifacts copied, reduces attack surface.

---

Got it! Let’s go section by section—**concise, practical, interview-ready with commands/examples**.

---

## **4️⃣ Docker Commands**

**1. `docker ps -a` vs `docker ps`**

| Command        | Output                             |
| -------------- | ---------------------------------- |
| `docker ps`    | Running containers only            |
| `docker ps -a` | All containers (running + stopped) |

---

**2. `docker logs`, `docker exec`, `docker attach`**

| Command                    | Purpose                              | Notes                                    |
| -------------------------- | ------------------------------------ | ---------------------------------------- |
| `docker logs <c>`          | Show container stdout/stderr logs    | Read-only, non-interactive               |
| `docker exec -it <c> bash` | Run command inside running container | Interactive shell, can start new process |
| `docker attach <c>`        | Attach to main process of container  | Interacts with main PID, no new shell    |

---

**3. `docker stop` vs `docker kill` vs `docker rm`**

| Command       | Action                                             |
| ------------- | -------------------------------------------------- |
| `docker stop` | Graceful stop (sends SIGTERM, waits, then SIGKILL) |
| `docker kill` | Force stop (immediate SIGKILL)                     |
| `docker rm`   | Remove container (must be stopped first)           |

---

**4. Copy files to/from container**

```bash
docker cp hostfile.txt <container>:/path/in/container
docker cp <container>:/path/in/container/file.txt ./hostdir/
```

---

**5. `docker network ls` vs `docker network inspect`**

| Command                            | Purpose                                 |
| ---------------------------------- | --------------------------------------- |
| `docker network ls`                | List all networks                       |
| `docker network inspect <network>` | Detailed info (containers, IPs, driver) |

---

**6. Prune unused resources**

```bash
docker system prune -a --volumes
# Removes unused containers, networks, images, volumes
```

---

## **5️⃣ Docker Networking**

**1. Docker networks & default types**

* Networks allow container communication and isolation.
* Default types:

  * **bridge** → default isolated network
  * **host** → shares host network
  * **overlay** → multi-host networks (Swarm/Kubernetes)

---

**2. Container-to-container communication**

* Containers on same network can communicate via **container name** or IP.

```bash
docker network create mynet
docker run --name c1 --network mynet nginx
docker run --name c2 --network mynet busybox ping c1
```

---

**3. Port mapping vs published ports**

| Concept        | Example      | Notes                                    |
| -------------- | ------------ | ---------------------------------------- |
| Published port | `-p 8080:80` | Maps container port 80 → host 8080       |
| Internal port  | EXPOSE 80    | Declares container port, no host mapping |

---

**4. Bridge network vs Host network**

| Feature   | Bridge                  | Host                                   |
| --------- | ----------------------- | -------------------------------------- |
| Isolation | Yes, separate namespace | No, uses host net                      |
| Use case  | Multi-container apps    | Performance-critical, single container |

---

**5. Connect container to multiple networks**

```bash
docker network connect net1 mycontainer
docker network connect net2 mycontainer
```

---

**6. Docker overlay network (Swarm)**

* Enables multi-host container communication.
* Requires **Docker Swarm mode**.
* Useful for **services** in a cluster.

---

## **6️⃣ Docker Volumes & Storage**

**1. Volumes vs Bind mounts vs tmpfs**

| Type       | Description                           | Use Case                    |
| ---------- | ------------------------------------- | --------------------------- |
| Volume     | Managed by Docker, persistent storage | DB data, app data           |
| Bind mount | Maps host directory to container      | Development, config sharing |
| tmpfs      | In-memory storage, ephemeral          | Sensitive data, cache       |

---

**2. Backup & restore container data**

```bash
# Backup volume
docker run --rm -v myvol:/data -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz -C /data .
# Restore volume
docker run --rm -v myvol:/data -v $(pwd):/backup alpine tar xzf /backup/backup.tar.gz -C /data
```

---

**3. Persistent storage for containers**

* Use **Docker volumes** or external storage (NFS, cloud volume).
* Declared via `-v myvol:/data` or `--mount`.

---

**4. Share data between containers**

```bash
docker run -d --name db -v sharedvol:/data postgres
docker run -it --name app --volumes-from db ubuntu
```

---

**5. Inspect & remove unused volumes**

```bash
docker volume ls            # list volumes
docker volume inspect myvol # details
docker volume prune         # remove unused volumes
```

---

If you want, I can **make a single “Docker Quick-Reference Table”** with commands, Dockerfile instructions, networking, volumes—all in one page for interview prep.

Do you want me to do that next?

---

Perfect! Let’s finish the Docker section with **Docker Compose, Swarm, Security, and Advanced/Troubleshooting**—concise, commands/examples, interview-ready.

---

## **7️⃣ Docker Compose**

**1. What is Docker Compose?**

* Tool to **define & run multi-container apps** using `docker-compose.yml`.
* Simplifies orchestration: networks, volumes, and service dependencies.

**2. Defining services, networks, volumes**

```yaml
version: '3.8'
services:
  web:
    image: nginx
    ports:
      - "8080:80"
    volumes:
      - webdata:/usr/share/nginx/html
    networks:
      - frontend

networks:
  frontend:

volumes:
  webdata:
```

**3. `depends_on` vs healthchecks**

| Feature      | Behavior                                            |
| ------------ | --------------------------------------------------- |
| depends\_on  | Ensures container starts after dependencies start   |
| healthchecks | Waits for container to be **healthy** before action |

**4. Scale services**

```bash
docker-compose up --scale web=3 -d
```

**5. Override files (`docker-compose.override.yml`)**

* Auto-applied to **extend or override base config** (useful for dev vs prod).

---

## **8️⃣ Docker Swarm / Orchestration**

**1. Swarm vs Kubernetes**

| Feature        | Docker Swarm            | Kubernetes                      |
| -------------- | ----------------------- | ------------------------------- |
| Complexity     | Simpler, easy setup     | Complex, full-featured          |
| Scalability    | Moderate                | High                            |
| Deployment     | `docker service create` | `kubectl apply`                 |
| Load Balancing | Built-in                | Built-in + Ingress/Service      |
| Ecosystem      | Docker-only             | Cloud-native, many integrations |

**2. Initialize Swarm & deploy services**

```bash
docker swarm init
docker service create --name web --replicas 3 -p 8080:80 nginx
```

**3. Services vs Containers in Swarm**

* **Service:** Defines desired state (replicas, image).
* **Container:** Actual running instance of a service (task).

**4. Rolling updates**

```bash
docker service update --image nginx:1.21 web
```

* Swarm updates containers **one by one** to minimize downtime.

**5. Replicated vs Global services**

| Type       | Behavior                              |
| ---------- | ------------------------------------- |
| Replicated | Fixed number of replicas across nodes |
| Global     | Runs **one instance per node**        |

**6. Service discovery & load balancing**

* Swarm DNS resolves service names → container IPs.
* Built-in **round-robin load balancing** across replicas.

---

## **9️⃣ Security & Best Practices**

**1. Managing secrets**

```bash
echo "mysecret" | docker secret create db_password -
docker service create --name db --secret db_password postgres
```

**2. Root vs Non-root containers**

* **Root:** Full privileges → higher risk
* **Non-root:** Safer, recommended for production

**3. Minimize attack surface**

* Use minimal base images (`alpine`)
* Remove unnecessary packages
* Use **non-root users**

**4. `USER` in Dockerfile vs root**

* `USER` → runs container commands as specified user
* Root → default, can access host resources (risky)

**5. Scan images for vulnerabilities**

```bash
docker scan myimage:latest
# or use tools like Trivy, Clair
```

---

## **🔟 Advanced / Troubleshooting**

**1. Debug a non-starting container**

```bash
docker logs <container>
docker run -it --entrypoint /bin/sh <image>
```

**2. Runtime vs build-time**

* **Build-time:** Instructions executed during `docker build` (RUN, ARG)
* **Runtime:** Commands executed when container runs (CMD, ENTRYPOINT, ENV)

**3. Docker signal handling**

* `SIGTERM` → graceful shutdown (default `docker stop`)
* `SIGKILL` → force kill (`docker kill`)

**4. Multi-stage builds for secure images**

* Only copy **required artifacts** to final image → no build tools → smaller & safer.

**5. Restart policies**

| Policy          | Behavior                                    |
| --------------- | ------------------------------------------- |
| no              | Default, don’t restart                      |
| on-failure\[:N] | Restart container on failure, up to N times |
| always          | Always restart container                    |
| unless-stopped  | Always restart unless manually stopped      |

**6. `docker attach` vs `docker exec`**

* `attach` → attach to main process stdout/stderr
* `exec` → run **new command/process** inside container

**7. Monitor container resource usage**

```bash
docker stats <container>
# Shows CPU, memory, network, IO
```

**8. Connect Docker containers to AWS VPC or cloud network**

* Use **AWS VPC CNI plugin** (for ECS)
* Use **macvlan network driver** to attach container to host/ cloud subnet

---

