
---

## **1️⃣ Basics & GitLab Fundamentals**

**1. GitLab vs GitHub**

| Feature            | GitLab                          | GitHub                                  |
| ------------------ | ------------------------------- | --------------------------------------- |
| CI/CD              | Built-in GitLab CI/CD           | Needs GitHub Actions or 3rd-party CI/CD |
| Repo visibility    | Public / Private / Internal     | Public / Private                        |
| Self-hosting       | GitLab CE/EE can be self-hosted | Mostly SaaS; Enterprise available       |
| DevOps integration | Full DevOps lifecycle           | Partial (GitHub Actions helps)          |

**2. GitLab CI/CD (simple terms)**

* Automates **build, test, deploy** processes on commit or merge.
* Pipelines = series of stages (build → test → deploy).

**3. GitLab project vs repository**

* **Project:** Container for repo, issues, CI/CD, wiki, etc.
* **Repository:** Git repo storing code only.

**4. Groups, subgroups, and projects**

* **Group:** Collection of projects (team-level)
* **Subgroup:** Nested group (organizational hierarchy)
* **Project:** Code + CI/CD + issues

**5. GitLab roles & permissions**

| Role       | Permissions                        |
| ---------- | ---------------------------------- |
| Guest      | Issues, comments                   |
| Reporter   | View & download code               |
| Developer  | Push, merge requests, CI/CD        |
| Maintainer | Admin project, settings, pipelines |
| Owner      | Full control of group/project      |

**6. Issue tracking & merge requests**

* **Issues:** Track tasks/bugs
* **Merge Requests (MRs):** Proposed code changes → code review → merge

---

## **2️⃣ GitLab CI/CD Pipelines**

**1. What is a pipeline?**

* A **sequence of stages** triggered by commit/MR that runs jobs automatically.

**2. Stages, jobs, runners**

| Term   | Description                                 |
| ------ | ------------------------------------------- |
| Stage  | Logical group of jobs (build, test, deploy) |
| Job    | Task inside a stage (script to execute)     |
| Runner | Agent that executes jobs                    |

**3. `script`, `before_script`, `after_script`**

```yaml
job:
  before_script: echo "Pre-job"
  script: echo "Main job"
  after_script: echo "Cleanup"
```

* `before_script` → run before main commands
* `script` → main commands
* `after_script` → always runs after job

**4. How GitLab determines which jobs to run**

* Based on **pipeline triggers**, **branch**, **rules**, **only/except**, and **changes**.

**5. Pipeline artifacts & use case**

* Artifacts = files **persisted between stages/jobs**
* Example: build binaries or test reports

```yaml
artifacts:
  paths:
    - target/*.jar
```

**6. CI/CD variables & scopes**

* Variables: reusable values for jobs (passwords, environment)
* Scopes: global, group, project, or protected variables

**7. `rules`, `only`, `except` differences**

| Keyword | Behavior                                                  |
| ------- | --------------------------------------------------------- |
| only    | Run job on specific branches/tags/events                  |
| except  | Exclude certain branches/tags/events                      |
| rules   | Advanced, flexible conditions (branch, changes, pipeline) |

**8. Trigger pipeline manually vs automatically**

* **Manual:** Web UI → “Run pipeline”, `when: manual`
* **Automatic:** Push/MR triggers pipeline via `.gitlab-ci.yml`

**9. Dynamic pipelines & `include` keyword**

* Dynamic pipelines = pipelines generated **on-the-fly** via rules or child pipelines
* `include:` → reuse external YAML files

```yaml
include:
  - local: '/ci-templates/build.yml'
```

---

## **3️⃣ GitLab Runners**

**1. What is a GitLab Runner?**

* Agent that executes jobs in a GitLab CI/CD pipeline

**2. Shared vs Specific runners**

| Type     | Description                                   |
| -------- | --------------------------------------------- |
| Shared   | Available for all projects on GitLab instance |
| Specific | Dedicated to a project/group                  |

**3. Register a runner**

```bash
gitlab-runner register \
  --url https://gitlab.com/ \
  --registration-token <TOKEN> \
  --executor shell \
  --description "My Runner"
```

**4. Executor types**

| Executor       | Description                   |
| -------------- | ----------------------------- |
| shell          | Runs jobs on host shell       |
| docker         | Runs jobs in Docker container |
| docker+machine | Spawns Docker VM dynamically  |
| Kubernetes     | Runs jobs on K8s cluster      |

**5. Scaling runners for high-concurrency**

* Add more **specific/shared runners**
* Use **docker+machine** executor for autoscaling

**6. Runner authentication & security**

* Uses **registration token**
* Jobs run in isolated executor (container/shell)
* Can set **protected runners** for sensitive branches

---

Perfect! Let’s cover these **GitLab advanced CI/CD, security, branching, and troubleshooting** questions in a concise, interview-ready format.

---

## **4️⃣ GitLab Jobs & Advanced CI/CD**

**1. Passing environment variables between jobs**

* Use **artifacts** or **CI/CD variables**:

```yaml
job1:
  script: echo "DATA=123" > envfile.txt
  artifacts:
    paths:
      - envfile.txt

job2:
  dependencies:
    - job1
  script:
    - source envfile.txt
    - echo $DATA
```

**2. `dependencies` vs `needs` vs `stages`**

| Concept      | Purpose                                                                    |
| ------------ | -------------------------------------------------------------------------- |
| stages       | Define order of execution                                                  |
| dependencies | Specify which previous jobs’ artifacts to use                              |
| needs        | Run jobs **out of order** while respecting dependencies (faster pipelines) |

**3. Caching in pipelines**

* Use **cache** to speed up builds (node\_modules, Maven repo, etc.)

```yaml
cache:
  paths:
    - node_modules/
```

**4. Artifacts vs Cache**

| Feature   | Artifacts                       | Cache                   |
| --------- | ------------------------------- | ----------------------- |
| Purpose   | Persist between **stages/jobs** | Speed up builds         |
| Retention | Configurable expiration         | Only for pipeline reuse |
| Examples  | Build outputs, reports          | Dependencies, modules   |

**5. Conditional job execution**

* Use **rules** or `only/except`:

```yaml
job:
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
      when: always
```

**6. Include files & templates**

```yaml
include:
  - local: 'ci-templates/build.yml'
  - remote: 'https://gitlab.com/group/project/raw/main/deploy.yml'
```

* Reuse YAML definitions across pipelines.

**7. Deploy to multiple environments**

```yaml
deploy_staging:
  stage: deploy
  environment: staging
deploy_prod:
  stage: deploy
  environment: production
```

* Use `environment` keyword to manage environment-specific variables.

**8. Parallel jobs & matrix pipelines**

```yaml
test:
  stage: test
  parallel: 3   # run 3 jobs simultaneously
matrix:
  variables:
    NODE_VERSION: [16,18]
```

* Speeds up CI/CD by running independent jobs concurrently.

---

## **5️⃣ GitLab Security & Compliance**

**1. Secure secrets**

* Use **CI/CD variables** with **masked** (hide in logs) and **protected** (available to protected branches only).

**2. Protected branches & tags**

* Only authorized users can **push, merge, or deploy** to these branches/tags.

**3. Masked & protected variables**

* **Masked:** hidden in logs
* **Protected:** only for **protected branches/tags**

**4. Approvals & manual jobs**

```yaml
manual_job:
  stage: deploy
  when: manual
```

* Requires human approval before running.

**5. Static code analysis / vulnerability scanning**

* Use **GitLab SAST, DAST, Dependency Scanning** built-in templates:

```yaml
include:
  - template: Security/SAST.gitlab-ci.yml
```

**6. Security dashboards**

* Shows **vulnerabilities, license compliance, dependency issues** in a central view.

---

## **6️⃣ GitLab Branching & Merge Requests**

**1. Merge request vs pull request**

* MR = GitLab terminology, PR = GitHub. Same concept: code review & merge.

**2. GitFlow vs trunk-based development**

* GitFlow: feature → develop → release → main
* Trunk-based: short-lived branches, frequent merges to main

**3. Fast-forward vs merge commit**

| Strategy     | Result                                    |
| ------------ | ----------------------------------------- |
| fast-forward | Moves branch pointer without merge commit |
| merge commit | Creates commit preserving branch history  |

**4. Enforce pipeline success before merge**

* Use **“Merge only if pipeline succeeds”** in project settings.

**5. Handle conflicts in MR**

* Rebase or merge target branch into feature branch locally, resolve conflicts, push.

**6. Trigger pipelines for MR to specific branch**

```yaml
rules:
  - if: '$CI_MERGE_REQUEST_TARGET_BRANCH_NAME == "main"'
```

---

## **7️⃣ GitLab Monitoring & Troubleshooting**

**1. Debug failing CI/CD jobs**

* Check **job logs**, rerun with `--verbose`, or run locally using `gitlab-runner exec`.

**2. View job logs & artifacts**

```bash
docker exec -it gitlab-runner bash  # access runner
# Or view artifacts via GitLab UI
```

**3. `gitlab-runner exec` command**

* Run jobs **locally** for testing without pushing to GitLab:

```bash
gitlab-runner exec docker <job-name>
```

**4. Monitor pipeline durations & performance**

* Use GitLab **Pipeline Analytics** for average stage/job duration, slow jobs.

**5. Troubleshoot Docker-based runners**

* Ensure proper **Docker socket mounting**
* Check **resource limits, container networking**
* Use `docker logs <container>` to debug runner containers

---

Here’s a concise, **interview-ready summary** for **GitLab integrations and advanced CI/CD features**:

---

## **GitLab Integrations & Advanced CI/CD**

**1. Integrate GitLab with AWS, Azure, or GCP**

* **Use CI/CD variables** to store credentials securely.
* **Deploy from pipelines** using CLI/SDK or Terraform/Ansible.
* **Example (AWS CLI deployment):**

```yaml
deploy:
  stage: deploy
  script:
    - aws s3 cp myapp.zip s3://my-bucket/
  only:
    - main
```

* For **Azure**, use `az` CLI; for **GCP**, use `gcloud` CLI.

---

**2. Deploy Docker images from GitLab pipelines**

* **Build and push image to registry (GitLab Container Registry or Docker Hub):**

```yaml
build_image:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker build -t registry.gitlab.com/mygroup/myapp:latest .
    - docker push registry.gitlab.com/mygroup/myapp:latest
```

* **Deploy container:** pull image in production environment using `docker run` or orchestration tools (K8s, Swarm).

---

**3. GitLab Auto DevOps**

* Provides **predefined CI/CD templates** to automatically:

  * Build, test, containerize, and deploy apps
  * Perform **SAST, DAST, dependency scanning**
  * Deploy to **Kubernetes** cluster automatically
* Enabled via **project settings → Auto DevOps**

---

**4. Cross-project pipelines**

* Trigger pipelines in another project:

```yaml
trigger_pipeline:
  stage: deploy
  trigger:
    project: group/other-project
    branch: main
```

* Useful for **multi-repo workflows** or shared libraries.

---

**5. Triggers and pipeline schedules**

* **Trigger pipelines:** start pipeline via **API** or another pipeline.

```bash
curl -X POST -F token=<token> -F ref=main https://gitlab.com/api/v4/projects/<id>/trigger/pipeline
```

* **Pipeline schedules:** automate recurring pipelines (cron jobs) in **project → CI/CD → Schedules**.

---

**6. Reusable CI/CD templates**

* Use `.gitlab-ci.yml` templates for **DRY pipelines**.

```yaml
include:
  - project: 'group/shared-pipeline'
    file: '/templates/build.yml'
```

* Centralized templates allow **cross-project reuse** of CI/CD logic.

---
