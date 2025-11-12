# Jenkins
## Q: What is Jenkins?

### 🧠 Overview

**Jenkins** is an open-source **automation server** used to implement **CI/CD (Continuous Integration / Continuous Delivery)** pipelines. It automates building, testing, and deploying code across environments — enabling faster, consistent, and repeatable software delivery.

---

### ⚙️ Key Features

| 🔧 Feature                | 💡 Description                                                                                                           |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| **CI/CD Pipelines**       | Automate build → test → deploy workflows.                                                                                |
| **Plugins Ecosystem**     | 1,800+ plugins integrate with tools like Git, Docker, Kubernetes, AWS, Slack, etc.                                       |
| **Declarative Pipelines** | Define build workflows as code using `Jenkinsfile`.                                                                      |
| **Distributed Builds**    | Use master-agent architecture to scale builds across nodes.                                                              |
| **Integrations**          | Works with SCMs (GitHub, GitLab, Bitbucket), artifact repos (Nexus, Artifactory), and cloud platforms (AWS, Azure, GCP). |
| **Extensibility**         | Supports Groovy scripting and REST APIs for custom automation.                                                           |

---

### ⚙️ Example: Basic Declarative `Jenkinsfile`

```groovy
pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/org/app.git'
      }
    }

    stage('Build') {
      steps {
        sh 'mvn clean package'
      }
    }

    stage('Test') {
      steps {
        sh 'mvn test'
      }
    }

    stage('Dockerize') {
      steps {
        sh '''
        docker build -t myapp:latest .
        docker push myregistry/myapp:latest
        '''
      }
    }

    stage('Deploy') {
      steps {
        sh './scripts/deploy.sh'
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
    }
    success {
      echo '✅ Deployment successful!'
    }
    failure {
      echo '❌ Build failed!'
    }
  }
}
```

---

### ⚙️ Typical Workflow

1. Developer pushes code → triggers Jenkins job (via Webhook or PollSCM).
2. Jenkins **checks out** code → **builds** it → **runs tests**.
3. If successful, Jenkins **packages** artifacts → **deploys** to test/staging/prod environments.
4. CI pipeline reports status (e.g., Slack, email, dashboard).

---

### 📋 Jenkins Architecture

| Component               | Role                                                                           |
| ----------------------- | ------------------------------------------------------------------------------ |
| **Controller (Master)** | Manages jobs, plugins, and orchestration.                                      |
| **Agent (Node)**        | Executes build steps on remote machines.                                       |
| **Executor**            | A slot on an agent that runs one build at a time.                              |
| **Pipeline**            | Declarative (simple YAML-like) or Scripted (Groovy-based) flow of CI/CD steps. |
| **Plugin System**       | Adds integrations (SCM, Docker, K8s, AWS, etc.).                               |

---

### ✅ Best Practices

* 🧩 Use **Pipeline-as-Code** (`Jenkinsfile`) for versioned, repeatable builds.
* 🔒 Secure Jenkins with RBAC, credentials binding, and restricted plugin usage.
* 🧰 Use **shared libraries** for reusable pipeline logic.
* 🧹 Clean up workspaces regularly and use ephemeral build agents (Docker/Kubernetes).
* 📦 Store secrets using Jenkins credentials manager (not in scripts).
* 📈 Monitor builds using Blue Ocean UI or Prometheus metrics.
* 🚀 Integrate Jenkins with GitHub Actions or AWS CodePipeline for hybrid CI/CD.

---

### 💡 In short

**Jenkins = CI/CD automation engine** — it builds, tests, and deploys your code automatically through pipelines.
Think of it as your DevOps robot that takes code from commit → deployment 🚀.

---
---

## Q: How Does Jenkins Work?

### 🧠 Overview

**Jenkins** automates the entire software delivery process — from **code commit → build → test → deploy** — through **pipelines**. It continuously monitors your source code, triggers builds on changes, runs tests, packages artifacts, and deploys them across environments.

---

### ⚙️ High-Level Flow

```text
Developer Pushes Code → SCM Trigger → Jenkins Build → Test → Package → Deploy → Notify
```

Jenkins acts as a **controller** that coordinates jobs, while **agents** (build nodes) execute the actual tasks.

---

### ⚙️ Step-by-Step Breakdown

#### 1️⃣ Source Code Integration (SCM Trigger)

* Jenkins connects to **GitHub**, **GitLab**, **Bitbucket**, etc.
* Builds are triggered by:

  * Webhooks (preferred for real-time triggers)
  * Polling (`Poll SCM`)
  * Manual runs or API triggers

```bash
# Example webhook trigger
https://jenkins.mycompany.com/github-webhook/
```

---

#### 2️⃣ Pipeline Execution (Build/Test/Deploy)

* Jenkins reads your `Jenkinsfile` (Pipeline-as-Code).
* Stages execute sequentially or in parallel.

```groovy
pipeline {
  agent any
  stages {
    stage('Build') {
      steps { sh 'mvn clean package' }
    }
    stage('Test') {
      steps { sh 'mvn test' }
    }
    stage('Deploy') {
      steps { sh './deploy.sh' }
    }
  }
}
```

---

#### 3️⃣ Build Agents (Execution Layer)

* The **Jenkins controller** assigns jobs to **build agents**.
* Agents can be:

  * Static (dedicated VMs)
  * Ephemeral (Docker, Kubernetes pods, EC2)
* Agents execute commands, then send results back to the controller.

```bash
# Example: Launch agent using JNLP
java -jar agent.jar -jnlpUrl http://jenkins:8080/computer/agent1/slave-agent.jnlp
```

---

#### 4️⃣ Artifact Handling

* Jenkins packages and archives build outputs (JARs, Docker images, Helm charts, etc.).
* Pushes artifacts to repositories like:

  * **Nexus**, **JFrog Artifactory**, **ECR**, **DockerHub**, or **S3**.

```groovy
archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
```

---

#### 5️⃣ Deployment (Continuous Delivery)

* Uses deployment scripts, Helm charts, Terraform, or Ansible to deploy apps.
* Can deploy to:

  * **Kubernetes**
  * **EC2/VMs**
  * **Lambda**
  * **ECS/Fargate**
  * **On-prem servers**

Example:

```bash
kubectl apply -f k8s/deployment.yaml
```

---

#### 6️⃣ Notifications & Reporting

* Sends build/test/deploy results to Slack, Teams, or Email.
* Uses plugins for dashboards (Blue Ocean, Build Monitor).

```groovy
post {
  success { slackSend channel: '#devops', message: "✅ Build #${BUILD_NUMBER} succeeded!" }
  failure { slackSend channel: '#devops', message: "❌ Build #${BUILD_NUMBER} failed!" }
}
```

---

### 📋 Jenkins Architecture Summary

| Component               | Description                                              |
| ----------------------- | -------------------------------------------------------- |
| **Controller (Master)** | Orchestrates pipelines, schedules jobs, monitors agents. |
| **Agent (Node)**        | Executes build steps (build, test, deploy).              |
| **Executor**            | A single build slot on an agent.                         |
| **Job/Pipeline**        | Definition of what Jenkins should run.                   |
| **Workspace**           | Directory on agent for build execution.                  |
| **Plugins**             | Extend Jenkins (SCM, Docker, K8s, Slack, etc.).          |
| **Credentials Store**   | Securely stores API keys, SSH keys, and secrets.         |

---

### ⚙️ Example: CI/CD Flow in Practice

1. Developer pushes code → GitHub webhook triggers Jenkins.
2. Jenkins fetches code → spins up a Docker/K8s agent.
3. Pipeline builds → tests → packages → uploads artifact → deploys to dev/stage/prod.
4. Post-deploy, Jenkins notifies Slack/Teams → archives reports and logs.
5. Build metadata, logs, and artifacts stored in Jenkins UI and artifact repo.

---

### ✅ Best Practices

* 🧩 **Use Pipeline-as-Code**: version control your `Jenkinsfile`.
* 🧱 **Run builds on ephemeral agents** (Docker/Kubernetes) for clean, reproducible builds.
* 🔒 **Secure Jenkins**:

  * Restrict admin access,
  * Use RBAC and API tokens,
  * Store secrets via Jenkins credentials plugin.
* 🚦 **Require approvals** for prod deploys (`input` step).
* 🧪 **Parallelize testing** to speed up pipelines.
* 🧹 **Auto-clean workspaces** to avoid disk bloat.
* 🔍 **Monitor** Jenkins health via Prometheus/Grafana.

---

### 💡 In short

**Jenkins = CI/CD automation engine.**
It detects code changes → runs build/test/deploy pipelines → notifies results — all orchestrated by the controller and executed by agents.
Think: **“Git push → Jenkins handles everything else.”** 🚀

---
---

## Q: What’s the Difference Between Freestyle and Pipeline Jobs in Jenkins?

### 🧠 Overview

Jenkins supports two major job types for automation — **Freestyle** and **Pipeline**.
Both execute CI/CD tasks, but **Pipelines (Jenkinsfile-based)** offer version control, flexibility, and scalability for modern DevOps workflows, while **Freestyle** jobs are simpler but limited and GUI-dependent.

---

### ⚙️ Comparison Table

| Feature / Aspect         | 🧩 **Freestyle Job**                          | ⚙️ **Pipeline Job**                                      |
| ------------------------ | --------------------------------------------- | -------------------------------------------------------- |
| **Definition**           | Configured via Jenkins UI (click-based setup) | Defined as code in a `Jenkinsfile` (text-based)          |
| **Storage**              | Stored on Jenkins master (XML config)         | Stored in SCM (Git, etc.) as code                        |
| **Complexity**           | Suitable for simple, single-step builds       | Handles complex CI/CD workflows with multiple stages     |
| **Scripted Logic**       | Limited — uses post-build steps               | Full scripting (Groovy DSL) for logic, loops, conditions |
| **Version Control**      | ❌ No (manual config)                          | ✅ Yes (pipeline-as-code in repo)                         |
| **Portability**          | Hard to replicate (manual recreation)         | Easy to replicate, share, review via Git                 |
| **Parallel Execution**   | ❌ Not supported                               | ✅ Supported with `parallel {}` stages                    |
| **Resume after Restart** | ❌ No                                          | ✅ Yes (resumable pipelines)                              |
| **Integration**          | GUI plugins                                   | Native integration with SCM, Docker, Kubernetes, etc.    |
| **Error Handling**       | Minimal                                       | Advanced (`try/catch`, post conditions)                  |
| **Best suited for**      | Small projects, quick automation tasks        | Production-grade CI/CD, complex workflows                |

---

### ⚙️ Example: Freestyle Job

Configured via **GUI → New Item → Freestyle Project**

* Add SCM → Build Step → Execute Shell → Post-build action.
  Example build step:

```bash
# Simple Freestyle build step
mvn clean package
scp target/app.jar user@server:/opt/app/
```

Limitations:

* No version control.
* Difficult to maintain across teams.
* Manual reconfiguration if Jenkins restarts or job copied.

---

### ⚙️ Example: Pipeline Job (`Jenkinsfile`)

```groovy
pipeline {
  agent any

  stages {
    stage('Build') {
      steps { sh 'mvn clean package' }
    }

    stage('Test') {
      steps { sh 'mvn test' }
    }

    stage('Deploy') {
      steps { sh './scripts/deploy.sh' }
    }
  }

  post {
    success { echo "✅ Deployment successful!" }
    failure { echo "❌ Build failed!" }
  }
}
```

**Advantages:**

* Source-controlled (`Jenkinsfile` in repo).
* Easy to review and maintain.
* Supports shared libraries, parallel builds, and dynamic agents.

---

### ✅ Best Practices

* 🚀 For **modern DevOps**, always use **Pipeline-as-Code (Declarative Pipelines)**.
* 🧱 Use **Freestyle** only for:

  * Quick, one-time automation jobs.
  * Simple monitoring or utility scripts.
* 🧩 Migrate legacy Freestyle jobs using the **Pipeline Syntax Generator** (Jenkins → Pipeline Syntax).
* 🧰 Use **Shared Libraries** for common build logic across teams.
* 🔒 Use credentials binding for secrets in both types.

---

### 💡 In short

| Freestyle              | Pipeline                     |
| ---------------------- | ---------------------------- |
| GUI-configured         | Code-defined (`Jenkinsfile`) |
| Simple & manual        | Complex & automated          |
| Not version-controlled | Version-controlled           |
| Good for small jobs    | Ideal for CI/CD automation   |

👉 **Freestyle = Quick setup.**
👉 **Pipeline = Scalable, maintainable, DevOps-ready.** ✅

---
---

## Q: What Language is a Jenkinsfile Written In?

### 🧠 Overview

A **Jenkinsfile** is written in **Groovy DSL (Domain-Specific Language)** — a powerful, human-readable scripting syntax built on top of the **Groovy** programming language.
It defines how Jenkins should **build, test, and deploy** code — serving as the backbone of Jenkins **Pipeline-as-Code**.

---

### ⚙️ Jenkinsfile Language: Groovy DSL

| Aspect            | Description                                                                                                 |
| ----------------- | ----------------------------------------------------------------------------------------------------------- |
| **Base Language** | [Groovy](https://groovy-lang.org/) (JVM-based scripting language)                                           |
| **Purpose**       | Define CI/CD pipelines in code form                                                                         |
| **Syntax Type**   | Domain-Specific Language (DSL) created by Jenkins                                                           |
| **Modes**         | 🔹 **Declarative Pipeline** (simple, structured)<br>🔹 **Scripted Pipeline** (flexible, Groovy-based logic) |

---

### ⚙️ 1️⃣ Declarative Pipeline Example (recommended)

Declarative syntax is **structured and readable**, ideal for CI/CD pipelines.

```groovy
pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/org/app.git'
      }
    }

    stage('Build') {
      steps {
        sh 'mvn clean package'
      }
    }

    stage('Test') {
      steps {
        sh 'mvn test'
      }
    }

    stage('Deploy') {
      steps {
        sh './scripts/deploy.sh'
      }
    }
  }

  post {
    success {
      echo "✅ Deployment succeeded"
    }
    failure {
      echo "❌ Build failed"
    }
  }
}
```

🧩 **Declarative syntax** enforces structure — Jenkins automatically understands `pipeline`, `stages`, and `steps`.

---

### ⚙️ 2️⃣ Scripted Pipeline Example (advanced Groovy scripting)

Scripted syntax uses **pure Groovy**, giving full control and flexibility.

```groovy
node('docker-agent') {
  stage('Checkout') {
    checkout scm
  }

  stage('Build') {
    sh 'mvn clean package'
  }

  stage('Deploy') {
    try {
      sh './deploy.sh'
      echo "✅ Deployment completed"
    } catch (err) {
      echo "❌ Deployment failed: ${err}"
      currentBuild.result = 'FAILURE'
    }
  }
}
```

🔹 Use this when you need conditionals, loops, or custom Groovy logic.
🔹 Works best for complex dynamic pipelines.

---

### 📋 Comparison: Declarative vs Scripted Syntax

| Feature        | **Declarative Pipeline**         | **Scripted Pipeline**              |
| -------------- | -------------------------------- | ---------------------------------- |
| Syntax         | Structured, YAML-like            | Free-form Groovy script            |
| Readability    | ✅ Easy for beginners             | ⚠️ Requires Groovy knowledge       |
| Error handling | Built-in (`post`, `when`, etc.)  | Manual (`try/catch`)               |
| Flexibility    | Limited (structured)             | Full Groovy power                  |
| Best for       | CI/CD teams and shared pipelines | Complex logic or dynamic workflows |

---

### ✅ Best Practices

* 🧩 Use **Declarative Pipelines** for most CI/CD use cases.
* 🧰 Use **Scripted Pipelines** only when custom Groovy logic is essential.
* 📦 Store your Jenkinsfile in the **root of your Git repo** for version control.
* 🧾 Use **shared libraries** for reusable Groovy functions across Jenkinsfiles.
* 🔒 Keep secrets in Jenkins credentials store — never hardcode inside Groovy scripts.
* 🧪 Validate Jenkinsfile syntax before committing:

  ```bash
  # Using Jenkins CLI
  java -jar jenkins-cli.jar -s http://jenkins:8080 declarative-linter < Jenkinsfile
  ```

---

### 💡 In short

A **Jenkinsfile** is written in **Groovy-based Jenkins DSL**, supporting:

* **Declarative Pipelines** (clean, structured, recommended)
* **Scripted Pipelines** (flexible, Groovy-powered)

👉 **Think:** *YAML-style readability with Groovy scripting power — that’s Jenkinsfile.* ⚙️

---
---

## Q: Common Jenkins Pipeline Stages

### 🧠 Overview

A **Jenkins pipeline** is a sequence of **stages** that define the CI/CD flow — from fetching code to deploying and verifying in production.
Each stage groups related steps (build, test, deploy, etc.) and can run sequentially or in parallel.

---

### ⚙️ Typical Jenkins Pipeline Stages

| 🏗️ **Stage**                         | 💡 **Purpose**                                         | 🔧 **Example Steps / Tools**                   |
| ------------------------------------- | ------------------------------------------------------ | ---------------------------------------------- |
| **1️⃣ Checkout / SCM**                | Fetch source code from Git or other SCM                | `git`, `checkout scm`                          |
| **2️⃣ Setup / Init**                  | Set environment vars, tools, credentials               | `withEnv`, `withCredentials`, `load env`       |
| **3️⃣ Build / Compile**               | Compile code, build artifacts (JAR, WAR, Docker image) | `mvn package`, `npm run build`, `docker build` |
| **4️⃣ Unit Test**                     | Run automated unit tests                               | `pytest`, `mvn test`, `npm test`               |
| **5️⃣ Static Analysis / Linting**     | Check code quality & security                          | `sonarqube`, `eslint`, `flake8`, `bandit`      |
| **6️⃣ Artifact Packaging**            | Package build output                                   | `tar`, `zip`, or archive via Jenkins           |
| **7️⃣ Push to Artifact Repo**         | Store build artifacts (for reuse/deploy)               | Nexus, JFrog, ECR, S3                          |
| **8️⃣ Deploy to Dev/Staging**         | Deploy to lower env for validation                     | `kubectl apply`, `helm upgrade`, Terraform     |
| **9️⃣ Integration / Smoke Tests**     | Validate deployed build health                         | Postman, Selenium, Robot Framework             |
| **🔟 Approval / Manual Gate**         | Require human approval before prod deploy              | `input` step in Jenkins                        |
| **11️⃣ Deploy to Production**         | Automated or manual production rollout                 | `ansible-playbook`, `helm`, AWS CLI            |
| **12️⃣ Post-Deployment Verification** | Check metrics/logs after deployment                    | API checks, health probes                      |
| **13️⃣ Notify / Cleanup**             | Notify stakeholders & clean up workspace               | Slack, Email, `cleanWs()`                      |

---

### ⚙️ Example: Declarative Jenkinsfile with Common Stages

```groovy
pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/org/myapp.git'
      }
    }

    stage('Build') {
      steps {
        sh 'mvn clean package -DskipTests'
      }
    }

    stage('Test') {
      steps {
        sh 'mvn test'
      }
    }

    stage('Static Analysis') {
      steps {
        sh 'sonar-scanner -Dsonar.projectKey=myapp'
      }
    }

    stage('Docker Build & Push') {
      steps {
        sh '''
        docker build -t myapp:${BUILD_NUMBER} .
        docker tag myapp:${BUILD_NUMBER} 123456789.dkr.ecr.us-east-1.amazonaws.com/myapp:${BUILD_NUMBER}
        docker push 123456789.dkr.ecr.us-east-1.amazonaws.com/myapp:${BUILD_NUMBER}
        '''
      }
    }

    stage('Deploy to Staging') {
      steps {
        sh 'kubectl apply -f k8s/staging-deployment.yaml'
      }
    }

    stage('Integration Tests') {
      steps {
        sh './scripts/run-smoke-tests.sh'
      }
    }

    stage('Approval') {
      steps {
        input message: 'Approve deployment to production?', ok: 'Deploy'
      }
    }

    stage('Deploy to Production') {
      steps {
        sh 'kubectl apply -f k8s/prod-deployment.yaml'
      }
    }
  }

  post {
    success {
      slackSend channel: '#deployments', message: "✅ Build #${BUILD_NUMBER} succeeded and deployed."
    }
    failure {
      slackSend channel: '#deployments', message: "❌ Build #${BUILD_NUMBER} failed."
    }
    always {
      cleanWs()
    }
  }
}
```

---

### ⚙️ Optional / Advanced Stages (for mature CI/CD setups)

| Stage                              | Purpose                                                          |
| ---------------------------------- | ---------------------------------------------------------------- |
| **Security Scan**                  | Use tools like `Trivy`, `Snyk`, `Aqua` for image/code scanning   |
| **Infra Provisioning**             | Create infrastructure dynamically via Terraform or AWS CDK       |
| **Blue-Green / Canary Deployment** | Deploy new version alongside old for safe rollout                |
| **Rollback / Recovery**            | Rollback deployment automatically on failure                     |
| **Observability**                  | Collect logs & metrics via ELK, Prometheus, Grafana integrations |
| **Performance Testing**            | Run load tests (JMeter, k6) before prod promotion                |

---

### ✅ Best Practices

* 🔁 Keep pipelines **modular** (use stages for logical steps).
* 🧩 Use **parallel stages** for test matrices (e.g., multiple environments or test types).
* 🔒 Store credentials using Jenkins’ **Credentials Manager**, not in scripts.
* 🧱 Use **environment blocks** to define reusable variables.
* 🚀 Separate **build**, **test**, and **deploy** — don’t mix logic.
* 🧰 Archive and fingerprint artifacts for traceability.
* 📊 Always include **notifications** and **post steps** (for reporting/cleanup).
* 🧪 Test your Jenkinsfile syntax:

  ```bash
  java -jar jenkins-cli.jar -s http://jenkins:8080 declarative-linter < Jenkinsfile
  ```

---

### 💡 In short

Common Jenkins pipeline stages follow this flow:

> **Checkout → Build → Test → Package → Deploy → Verify → Notify**

Each stage ensures automation, consistency, and traceability across your CI/CD pipeline. ✅

---
---

## Q: How to trigger Jenkins jobs automatically

### 🧠 Overview

Automatically triggering Jenkins jobs is usually done via **SCM webhooks** (push/PR events), but you can also use **scheduled polling**, **remote API calls**, **upstream job triggers**, or pipeline `triggers {}` blocks. Webhooks are preferred for speed and efficiency; API triggers are useful for custom automation.

---

### ⚙️ Examples / Commands

#### 1) GitHub webhook → Jenkins (recommended)

* In GitHub repo: **Settings → Webhooks → Add webhook**

  * Payload URL: `https://jenkins.example.com/github-webhook/`
  * Content type: `application/json`
  * Secret: set a secret and configure Jenkins GitHub plugin to validate it
  * Events: `Push`, `Pull request`, or `Let me select events`

No CLI required — quick UI setup. Use GitHub App (recommended) for org-scale installs.

---

#### 2) Jenkinsfile triggers (Declarative)

```groovy
pipeline {
  agent any
  triggers {
    // poll SCM every 5 minutes (less preferred)
    pollSCM('H/5 * * * *')

    // run nightly at 2:30 AM
    cron('30 2 * * *')

    // trigger on GitHub push (requires GitHub webhook + plugin)
    githubPush()
  }
  stages { /* ... */ }
}
```

---

#### 3) Multibranch / Organization pipeline (auto PR & branch builds)

* Create **Multibranch Pipeline** job pointing at repo/organization.
* Enable **Scan repository triggers** or rely on webhook to index and build branches/PRs automatically.

---

#### 4) Generic Webhook / GitLab / Bitbucket

* Use **Generic Webhook Trigger Plugin** for custom payloads or GitLab plugin for GitLab webhooks.
* Configure plugin to parse payload fields and set parameters.

Example `generic` plugin usage: set `token` and parse JSON keys to parameters in job config.

---

#### 5) Remote API trigger (curl) — token + crumb (secure)

```bash
# Get crumb (CSRF protection)
CRUMB=$(curl -s -u "jenkins_user:APITOKEN" "https://jenkins.example.com/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")

# Trigger job (no params)
curl -X POST -u "jenkins_user:APITOKEN" -H "$CRUMB" "https://jenkins.example.com/job/my-job/build?token=MY_TRIGGER_TOKEN"

# Trigger job with parameters
curl -X POST -u "jenkins_user:APITOKEN" -H "$CRUMB" "https://jenkins.example.com/job/my-job/buildWithParameters?token=MY_TRIGGER_TOKEN&BRANCH=main"
```

> Use Jenkins credentials & API tokens — **never** embed plain tokens in repo.

---

#### 6) GitLab webhook example

* GitLab repo → Settings → Webhooks → URL: `https://jenkins.example.com/gitlab-webhook/`
* Select push / merge request events and set secret token.

---

#### 7) Upstream / Downstream job triggers

* In Job A post-build: “Build other projects” → set downstream job names (or use `build job:` step in a pipeline).
* In Pipeline:

```groovy
stage('Trigger downstream') {
  steps {
    build job: 'downstream-job', parameters: [string(name:'REV', value:env.GIT_COMMIT)]
  }
}
```

---

### 📋 Trigger Methods Quick Reference

| Trigger Type             | When to use                        | Pros                            | Cons                                     |
| ------------------------ | ---------------------------------- | ------------------------------- | ---------------------------------------- |
| **SCM Webhook**          | On push/PR events                  | Fast, event-driven, low load    | Requires webhook reachability & security |
| **Multibranch Pipeline** | Auto-build branches/PRs            | Auto-detects branches/PRs       | Needs indexing + webhook integration     |
| **Remote API / curl**    | Custom automation / external tools | Flexible, scriptable            | Requires tokens + crumb handling         |
| **Poll SCM**             | When webhooks impossible           | Simple to configure             | Inefficient, delayed                     |
| **Cron / Scheduled**     | Nightly jobs, periodic tasks       | Predictable                     | Not event-driven                         |
| **Upstream job trigger** | Chained pipelines                  | Good for workflow orchestration | Tight coupling between jobs              |

---

### ✅ Best Practices

* ⚡ **Prefer webhooks** (GitHub App / GitLab plugin) over polling.
* 🔐 Secure webhooks with **secrets** and validate in Jenkins plugins.
* 🔑 Use **Jenkins API tokens** and **crumb** headers for remote triggers.
* 🧪 Test webhook delivery (GitHub/GitLab shows delivery logs).
* 🧱 Use **Multibranch Pipelines** for PR/branch auto-builds (enable `Scan by webhook`).
* ♻️ Use **idempotent** jobs and make builds reproducible (containerized agents).
* 🧾 Log and alert on webhook failures — add retries on the sender side.
* 🧰 For large orgs, prefer **GitHub App** vs single webhooks (better auth & scaling).
* 🔒 Limit permissions of the Jenkins service account (least privilege).
* 📣 Use notifications (Slack/Teams) on failed triggers to surface CI issues early.

---

### 💡 In short

Use **SCM webhooks + Multibranch Pipelines** for fast, reliable automatic builds; fall back to **remote API** for custom automation and **cron/poll** only when webhooks aren’t possible. Secure triggers with secrets, API tokens, and CSRF crumbs. ✅

---
---

## Q: What is a Jenkins Agent?

### 🧠 Overview

A **Jenkins agent** (formerly called *slave*) is a **remote machine or container** that executes Jenkins build jobs.
The **Jenkins controller** (master) coordinates pipelines, while agents perform the actual work — like building, testing, packaging, or deploying code.

---

### ⚙️ Jenkins Architecture at a Glance

```text
Developer Push → Jenkins Controller → Assigns Job → Jenkins Agent Executes → Reports Results
```

| Component               | Description                                                                       |
| ----------------------- | --------------------------------------------------------------------------------- |
| **Controller (Master)** | Manages pipelines, schedules builds, monitors agents.                             |
| **Agent (Node)**        | Executes the build steps (e.g., `mvn test`, `docker build`).                      |
| **Executor**            | A single build slot on an agent; each agent can run multiple builds concurrently. |

---

### ⚙️ Types of Jenkins Agents

| Type                    | Description                                                      | Typical Use                      |
| ----------------------- | ---------------------------------------------------------------- | -------------------------------- |
| **Static (Permanent)**  | Always online, manually configured (e.g., VM, bare metal).       | Dedicated build servers.         |
| **Ephemeral (Dynamic)** | Created on demand (via Docker, Kubernetes, EC2, etc.)            | Scalable CI/CD environments.     |
| **Inbound (JNLP)**      | Agent connects to controller via JNLP protocol.                  | For firewalled or remote agents. |
| **SSH Agent**           | Controller connects via SSH to start builds.                     | On internal infrastructure.      |
| **Cloud Agent**         | Spun up dynamically by Jenkins plugins (Kubernetes, EC2, Azure). | Cloud-native build workloads.    |

---

### ⚙️ Example: Agent Definition in Jenkinsfile

#### 🧩 Declarative Pipeline

```groovy
pipeline {
  agent {
    label 'docker'      // Run on any agent labeled 'docker'
  }

  stages {
    stage('Build') {
      steps {
        sh 'mvn clean package'
      }
    }
  }
}
```

#### 🧱 Ephemeral Docker Agent

```groovy
pipeline {
  agent {
    docker {
      image 'maven:3.9.6-eclipse-temurin-17'
      args '-v /root/.m2:/root/.m2'
    }
  }
  stages {
    stage('Build') {
      steps {
        sh 'mvn package'
      }
    }
  }
}
```

#### ⚙️ Kubernetes Agent (via Jenkins Kubernetes Plugin)

```groovy
pipeline {
  agent {
    kubernetes {
      yaml """
      apiVersion: v1
      kind: Pod
      spec:
        containers:
        - name: build
          image: maven:3.9.6-eclipse-temurin-17
          command:
          - cat
          tty: true
      """
    }
  }
  stages {
    stage('Build') {
      steps {
        container('build') {
          sh 'mvn clean test'
        }
      }
    }
  }
}
```

---

### ⚙️ How Agents Connect to Controller

| Connection Type    | Description                                                          | Command Example                                                                                   |
| ------------------ | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| **JNLP (Inbound)** | Agent connects *to* Jenkins via JNLP (firewall-friendly).            | `java -jar agent.jar -jnlpUrl http://jenkins:8080/computer/node/slave-agent.jnlp -secret <token>` |
| **SSH**            | Jenkins connects *to* agent over SSH.                                | Configure credentials in Jenkins → Manage Nodes → SSH launch.                                     |
| **Cloud API**      | Jenkins plugin launches agents dynamically via API (K8s, EC2, etc.). | Plugin-managed (auto-scaling).                                                                    |

---

### 📋 Example: Agent Configuration Fields

| Field               | Example            | Purpose                             |
| ------------------- | ------------------ | ----------------------------------- |
| **Name**            | `docker-node`      | Identifier for the agent.           |
| **Labels**          | `docker linux`     | Used in `agent { label 'docker' }`. |
| **Executors**       | `2`                | Number of concurrent jobs allowed.  |
| **Remote root dir** | `/var/lib/jenkins` | Workspace for Jenkins jobs.         |
| **Launch method**   | SSH / JNLP / Cloud | How controller connects.            |

---

### ✅ Best Practices

* 🧩 **Use labels** to route builds (e.g., `agent { label 'maven' }`).
* ⚙️ **Use ephemeral agents** (Docker/Kubernetes) for clean, reproducible builds.
* 🔒 **Isolate builds** — each agent should have limited access (principle of least privilege).
* 🧰 **Use SSH keys or JNLP tokens**, never plain passwords.
* 🚀 **Monitor agent health** (connectivity, disk space, CPU usage).
* 🧱 **Scale dynamically** — use Kubernetes or EC2 agents to save cost.
* 🧾 **Pin sensitive jobs** (like release builds) to trusted agents only.
* 🧹 **Auto-clean workspaces** after builds:

  ```groovy
  post { always { cleanWs() } }
  ```

---

### ⚙️ Jenkins Master-Agent Lifecycle

```text
1. Controller schedules job → selects agent (by label or availability)
2. Agent initializes workspace → fetches source → runs build steps
3. Build results sent back to controller (logs, artifacts, status)
4. Agent cleaned up (if ephemeral) or ready for next build
```

---

### 💡 In short

A **Jenkins agent** is a worker machine (VM, container, or pod) that executes your build, test, and deploy steps.
The **controller orchestrates**, but **agents do the heavy lifting**.

👉 Think: **Controller = Brain 🧠 | Agent = Muscle 💪**

---
---

## Q: How Do You Install Jenkins Plugins?

### 🧠 Overview

**Jenkins plugins** extend Jenkins functionality — integrating with tools like Git, Docker, Kubernetes, AWS, SonarQube, Slack, etc.
You can install them via the **Web UI**, **CLI**, or **Automation (CLI/Groovy/Plugin Manager CLI)** — both manually or in code (Infrastructure-as-Code).

---

### ⚙️ 1️⃣ Install Plugins via Jenkins Web UI (most common)

#### 🔹 Step-by-step:

1. Go to: **Manage Jenkins → Plugins → Available plugins**
2. Search for the plugin name (e.g., *“GitHub Integration”*, *“Pipeline: AWS Steps”*)
3. Select and click:

   * ✅ *Install without restart*
   * 🔄 *Download now and install after restart*
4. Once installed, verify under **Installed Plugins** tab.

#### 📍 Example:

> To install the *Docker Pipeline* and *Blue Ocean* plugins:

```
Manage Jenkins → Plugins → Available → Search “Docker Pipeline” → Install
```

---

### ⚙️ 2️⃣ Install Plugins via Jenkins CLI

#### 🔹 Syntax:

```bash
java -jar jenkins-cli.jar -s http://jenkins.example.com/ install-plugin <plugin-name>
```

#### 🧩 Example:

```bash
java -jar jenkins-cli.jar -s http://jenkins:8080/ -auth admin:token \
  install-plugin git workflow-aggregator docker-workflow
```

Then restart Jenkins:

```bash
java -jar jenkins-cli.jar -s http://jenkins:8080/ safe-restart
```

✅ **Tip:** Use `-deploy` flag to install immediately without manual restart.

---

### ⚙️ 3️⃣ Install Plugins via Script Console (Groovy)

You can install plugins programmatically using the Jenkins **Script Console**:
`Manage Jenkins → Script Console`

```groovy
def plugins = ['git', 'workflow-aggregator', 'docker-workflow', 'blueocean']
def instance = Jenkins.getInstance()

def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()

plugins.each {
  if (!pm.getPlugin(it)) {
    println("Installing plugin: ${it}")
    def plugin = uc.getPlugin(it)
    plugin.deploy()
  }
}
instance.save()
```

💡 Useful for bootstrapping Jenkins in IaC setups (Terraform, Ansible, etc.).

---

### ⚙️ 4️⃣ Install Plugins via Plugin Installation Manager CLI (recommended for CI/CD & Docker)

Jenkins official **Plugin Installation Manager** tool automates plugin installation in containers or automation pipelines.

#### 🔹 Example: Dockerfile method

```dockerfile
FROM jenkins/jenkins:lts
USER root
RUN jenkins-plugin-cli --plugins \
  "git:latest workflow-aggregator:latest docker-workflow:latest blueocean:latest"
```

#### 🔹 Example: Plugin list file

Create a file `plugins.txt`:

```
git:latest
workflow-aggregator:latest
docker-workflow:latest
blueocean:latest
```

Then install in Docker build:

```dockerfile
RUN jenkins-plugin-cli --plugin-file plugins.txt
```

✅ **Perfect for reproducible Jenkins installations** in Kubernetes, Docker, or Terraform.

---

### ⚙️ 5️⃣ Manual Plugin Installation (offline)

When Jenkins has no internet access:

1. Download `.hpi` or `.jpi` files from [plugins.jenkins.io](https://plugins.jenkins.io).
2. Upload via **Manage Jenkins → Plugins → Advanced → Upload Plugin**.
3. Click **Upload** → then **Restart Jenkins**.

Or manually copy to plugin directory:

```bash
cp git.hpi /var/lib/jenkins/plugins/
systemctl restart jenkins
```

---

### 📋 Useful Plugin Management Commands

| Command                                             | Description                    |
| --------------------------------------------------- | ------------------------------ |
| `jenkins-plugin-cli --list`                         | List installed plugins         |
| `jenkins-plugin-cli --plugins <list>`               | Install given plugins          |
| `jenkins-plugin-cli --plugin-file plugins.txt`      | Bulk install plugins from file |
| `jenkins-plugin-cli --available-updates`            | Check for updates              |
| `java -jar jenkins-cli.jar list-plugins`            | List all plugins via CLI       |
| `java -jar jenkins-cli.jar install-plugin <name>`   | Install single plugin          |
| `java -jar jenkins-cli.jar uninstall-plugin <name>` | Uninstall plugin               |

---

### ✅ Best Practices

* 🧩 Keep Jenkins plugins **minimal** — install only what’s needed.
* 🔁 **Regularly update** plugins (`Manage Jenkins → Plugins → Updates`).
* 🧱 Use `jenkins-plugin-cli` or `plugins.txt` for **Infrastructure-as-Code** installs.
* 🧪 Always test new plugin updates in a **staging Jenkins** before production.
* 🔒 Check plugin sources — only install **signed & verified** plugins.
* ⚙️ Restart Jenkins gracefully (`safe-restart`) after multiple plugin updates.
* 📦 For air-gapped setups, maintain a **local plugin mirror**.

---

### 💡 In short

You can install Jenkins plugins via:

* **Web UI** (easy),
* **CLI / Groovy Script** (automated), or
* **`jenkins-plugin-cli`** (best for Docker/IaC).

👉 Use `jenkins-plugin-cli` for reproducible builds and automate plugin management across environments. ✅

---
---

## Q: What’s the Use of `JENKINS_HOME`?

### 🧠 Overview

`JENKINS_HOME` is the **heart of Jenkins** — it’s the **root directory** where Jenkins stores all its configuration, jobs, build data, plugins, and user content.
In short, it’s the **entire Jenkins state** — backing it up equals backing up your Jenkins server.

---

### ⚙️ Default Location

| Environment                 | Default Path                         |
| --------------------------- | ------------------------------------ |
| **Linux (package install)** | `/var/lib/jenkins`                   |
| **Windows**                 | `C:\Program Files\Jenkins`           |
| **Docker**                  | `/var/jenkins_home` (mounted volume) |

You can override it via:

```bash
export JENKINS_HOME=/data/jenkins_home
```

Or set in service config:

```bash
JENKINS_HOME=/opt/jenkins_home
```

---

### ⚙️ Directory Structure

| 📁 **Path**                    | 💡 **Description**                                            |
| ------------------------------ | ------------------------------------------------------------- |
| `config.xml`                   | Global Jenkins configuration file.                            |
| `jobs/`                        | Each subdirectory = one Jenkins job (stores builds, configs). |
| `nodes/`                       | Agent (node) definitions and metadata.                        |
| `users/`                       | Jenkins user configurations.                                  |
| `plugins/`                     | Installed plugin `.jpi` or `.hpi` files.                      |
| `secrets/`                     | Master encryption keys, API tokens, credentials metadata.     |
| `workspace/`                   | Temporary directories for build execution.                    |
| `fingerprints/`                | Metadata for artifact tracking.                               |
| `logs/`                        | Jenkins system and job logs.                                  |
| `updates/`                     | Plugin update cache.                                          |
| `queue.xml`, `credentials.xml` | Active build queue and credentials data.                      |

Example:

```bash
$ ls /var/lib/jenkins
config.xml  jobs/  nodes/  plugins/  secrets/  workspace/  users/
```

---

### ⚙️ Typical Use Cases

#### 🧩 1️⃣ Backup and Restore

To migrate Jenkins or recover from failure:

```bash
# Backup everything
tar -czf jenkins_backup_$(date +%F).tar.gz $JENKINS_HOME

# Restore
tar -xzf jenkins_backup_2025-11-10.tar.gz -C /var/lib/jenkins
chown -R jenkins:jenkins /var/lib/jenkins
systemctl restart jenkins
```

✅ Always stop Jenkins before restoring to avoid data corruption:

```bash
systemctl stop jenkins
```

---

#### 🧱 2️⃣ Docker-based Jenkins Example

Mount `JENKINS_HOME` as a persistent volume:

```bash
docker run -d \
  -p 8080:8080 -p 50000:50000 \
  -v /data/jenkins_home:/var/jenkins_home \
  --name jenkins \
  jenkins/jenkins:lts
```

This ensures all job configs, plugins, and credentials survive container restarts.

---

#### ⚙️ 3️⃣ Change Location (custom Jenkins home)

To move Jenkins home directory:

```bash
# Stop Jenkins
systemctl stop jenkins

# Move old directory
mv /var/lib/jenkins /data/jenkins_home

# Update environment variable in /etc/default/jenkins
JENKINS_HOME=/data/jenkins_home

# Restart service
systemctl start jenkins
```

Verify:

```bash
echo $JENKINS_HOME
# Output: /data/jenkins_home
```

---

### ⚙️ 4️⃣ Use in Jenkins Scripts / Pipelines

You can reference it inside Jenkins pipelines if needed:

```groovy
echo "Jenkins home directory: ${env.JENKINS_HOME}"
```

---

### ⚙️ 5️⃣ Use for Disaster Recovery (DR)

* Take daily backups of `$JENKINS_HOME`
* Replicate to a remote storage (e.g., S3, NFS, EBS snapshot)
* Use infrastructure-as-code for plugin reinstallation, then restore `$JENKINS_HOME` to rebuild your instance.

---

### 📋 Summary Table

| Category           | Description                                                        |
| ------------------ | ------------------------------------------------------------------ |
| **What it stores** | Configs, jobs, plugins, credentials, logs                          |
| **Default path**   | `/var/lib/jenkins` (Linux) / `/var/jenkins_home` (Docker)          |
| **Critical for**   | Backups, migrations, DR recovery                                   |
| **Modifiable?**    | Yes, via env var or service config                                 |
| **Do not store**   | Temporary files or large artifacts directly (use Nexus/S3 instead) |

---

### ✅ Best Practices

* 💾 **Backup `$JENKINS_HOME` regularly** (daily or before upgrades).
* 🧩 **Mount persistent storage** when using Docker.
* 🔒 **Secure permissions** (`chmod 700`, owned by `jenkins` user).
* 🧱 **Avoid storing artifacts** here — use artifact repositories.
* ⚙️ **Version-control Jenkins configuration** using tools like:

  * **Jenkins Configuration as Code (JCasC)**
  * **Job DSL plugin**
  * **plugin.txt + Dockerfile** for reproducible setups.
* 🚦 **Monitor disk usage** — large workspaces can fill up fast.

---

### 💡 In short

`JENKINS_HOME` is Jenkins’ **brain and memory** 🧠 — it holds every job, plugin, config, and credential.
Backup it → you’ve backed up Jenkins.
Lose it → you lose everything.

👉 Always treat `$JENKINS_HOME` as **critical infrastructure data**. ✅

---
---

## Q: How Do You Secure Jenkins?

### 🧠 Overview

Securing Jenkins means protecting the **controller**, **agents**, **credentials**, and **pipelines** from unauthorized access, leaks, or tampering.
You achieve this by enabling authentication, enforcing RBAC, securing secrets, restricting builds, and hardening the OS/network where Jenkins runs.

---

### ⚙️ 1️⃣ Enable Authentication

#### 🔹 Configure Security Realm

Go to **Manage Jenkins → Configure Global Security** → Enable:

* ✅ **“Enable Security”**
* Choose one:

  * **Jenkins’ own user database** (local accounts)
  * **LDAP / Active Directory** (enterprise)
  * **GitHub OAuth / SSO** (preferred for teams)
  * **SAML / OIDC** (SSO)

#### 🔹 Disable Anonymous Access

Set **“Allow anonymous read access”** → ❌ *unchecked*

---

### ⚙️ 2️⃣ Implement Role-Based Access Control (RBAC)

Install and configure the **Role-Based Authorization Strategy plugin**:

```bash
Manage Jenkins → Configure Global Security → Authorization → Role-Based Strategy
```

Then create roles:

| Role        | Permissions      | Scope          |
| ----------- | ---------------- | -------------- |
| `admin`     | Full control     | Global         |
| `developer` | Build/view jobs  | Folder/Project |
| `viewer`    | Read-only access | Folder/Project |

Use:

```bash
Manage Jenkins → Manage and Assign Roles → Assign Roles
```

✅ Apply the **principle of least privilege** — no global admin for normal users.

---

### ⚙️ 3️⃣ Secure Credentials and Secrets

* Use **Jenkins Credentials Manager** → never hardcode passwords, tokens, or AWS keys.
* Access credentials securely inside pipelines:

  ```groovy
  withCredentials([string(credentialsId: 'aws-secret', variable: 'AWS_SECRET')]) {
      sh 'aws s3 ls --secret $AWS_SECRET'
  }
  ```
* Store:

  * API keys → as “Secret Text”
  * SSH keys → as “SSH Username with Private Key”
  * Cloud tokens → via credential binding plugins
* Integrate with external secret managers (Vault, AWS Secrets Manager, Azure Key Vault):

  * Plugins: `HashiCorp Vault Plugin`, `AWS Credentials Plugin`.

---

### ⚙️ 4️⃣ Secure Jenkins Agents

* Use **JNLP or SSH agents** with restricted users (non-root).
* Prefer **ephemeral agents** via Kubernetes or Docker.
* Restrict agent file access (no access to `$JENKINS_HOME`).
* Enable **agent-to-controller security**:

  ```
  Manage Jenkins → Configure Global Security → Enable Agent → Controller Access Control
  ```
* Disable `java -jar agent.jar` without auth tokens.

---

### ⚙️ 5️⃣ HTTPS / Reverse Proxy Security

* Use HTTPS with a valid certificate (let’s encrypt or internal CA):

  ```bash
  java -jar jenkins.war --httpsPort=8443 --httpsCertificate=/etc/ssl/certs/jenkins.crt --httpsPrivateKey=/etc/ssl/private/jenkins.key
  ```
* Or put Jenkins behind an **Nginx/Apache reverse proxy**:

  ```nginx
  server {
      listen 443 ssl;
      server_name jenkins.example.com;

      ssl_certificate /etc/ssl/certs/jenkins.crt;
      ssl_certificate_key /etc/ssl/private/jenkins.key;

      location / {
          proxy_pass http://localhost:8080;
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-Proto https;
      }
  }
  ```

---

### ⚙️ 6️⃣ Hardening Jenkins Configuration

| Setting                        | Recommended                 |
| ------------------------------ | --------------------------- |
| **CSRF Protection**            | ✅ Enabled                   |
| **Agent → Controller access**  | ✅ Restricted                |
| **Script Console Access**      | 🔒 Admins only              |
| **Remoting CLI**               | Disable if unused           |
| **Prevent Cross-Site Framing** | ✅ Enabled                   |
| **Markup Formatter**           | Safe HTML / Plain text      |
| **Restrict user signups**      | Disabled                    |
| **Audit Trail plugin**         | Enabled to log user actions |

---

### ⚙️ 7️⃣ Plugin & Update Security

* ⚙️ Install only **trusted plugins** from [plugins.jenkins.io](https://plugins.jenkins.io).
* 🔄 Regularly update Jenkins core and plugins:

  ```
  Manage Jenkins → Plugins → Updates
  ```
* 🧰 Use plugin version pinning for reproducible builds (`jenkins-plugin-cli --plugin-file plugins.txt`).
* 🧩 Remove unused or deprecated plugins periodically.

---

### ⚙️ 8️⃣ Backup and Disaster Recovery

* Backup `$JENKINS_HOME` daily or before upgrades:

  ```bash
  tar -czf /backup/jenkins_$(date +%F).tar.gz $JENKINS_HOME
  ```
* Use external artifact storage for large builds (S3, Nexus).
* Store plugin/version manifest (`jenkins-plugin-cli --list`) for rebuilds.

---

### ⚙️ 9️⃣ Secure Pipelines (Pipeline-as-Code)

* Never echo secrets in logs (`echo $AWS_SECRET` ❌).
* Use credentials binding and `withCredentials` blocks.
* Validate pull requests before executing (use `Multibranch Pipeline → Build Trust` options).
* Limit shell execution privileges for untrusted contributors.
* Use **Sandboxed Groovy** for Scripted pipelines.

Example:

```groovy
pipeline {
  agent any
  options { disableConcurrentBuilds() }
  environment {
    ENV = 'staging'
  }
  stages {
    stage('Deploy') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'deploy-key', keyFileVariable: 'KEY')]) {
          sh 'scp -i $KEY app.jar ec2-user@server:/opt/app/'
        }
      }
    }
  }
}
```

---

### ⚙️ 10️⃣ Monitoring and Auditing

* Enable **Audit Trail plugin** for tracking admin/user actions.
* Integrate **Prometheus plugin** for build/health metrics.
* Send Jenkins logs to ELK or CloudWatch for centralized logging.
* Enable **Build History** and **Job Configuration History plugin** for change tracking.

---

### 📋 Summary Table

| Security Area  | Action                                     |
| -------------- | ------------------------------------------ |
| Authentication | Use LDAP, SSO, or OAuth                    |
| Authorization  | Enable RBAC (Role-Based Strategy)          |
| Network        | HTTPS, reverse proxy, firewall rules       |
| Agents         | Restricted, ephemeral, non-root            |
| Secrets        | Use Credentials Store or Vault integration |
| Plugins        | Install only trusted, updated plugins      |
| Pipelines      | Use credentials binding, sanitize input    |
| Backups        | Automate $JENKINS_HOME backups             |
| Monitoring     | Use Audit Trail, Prometheus, and ELK       |
| OS Hardening   | Run Jenkins as non-root; apply patches     |

---

### ✅ Best Practices

* 🔒 Enforce **RBAC + SSO**.
* 🧩 Keep Jenkins **minimal** — fewer plugins = smaller attack surface.
* 🔐 Store secrets in Jenkins **Credentials Manager** or **Vault**, not in SCM.
* 🚫 Disable anonymous access & unused endpoints (CLI, script console).
* 🧱 Run Jenkins under a **non-root user** and isolate network access.
* ⚙️ Regularly **patch and upgrade** Jenkins and dependencies.
* 🧾 Audit frequently — treat Jenkins as part of your production infrastructure.

---

### 💡 In short

To secure Jenkins:

> **Enable authentication → Restrict permissions → Protect credentials → Harden network → Audit continuously.**

**In summary:**
**Jenkins security = RBAC + HTTPS + Secrets Management + Controlled Agents + Monitoring.** ✅

---
---

## Q: What’s the Difference Between Declarative and Scripted Pipelines in Jenkins?

### 🧠 Overview

Jenkins supports two ways to define **Pipeline-as-Code** — **Declarative** and **Scripted**.
Both use **Groovy DSL**, but they differ in **syntax**, **structure**, and **use cases**.
Declarative pipelines are **simpler and more structured**, while Scripted pipelines are **flexible and fully Groovy-driven**.

---

### ⚙️ Quick Comparison Table

| Feature                | 🧩 **Declarative Pipeline**                 | ⚙️ **Scripted Pipeline**                        |
| ---------------------- | ------------------------------------------- | ----------------------------------------------- |
| **Syntax Style**       | Structured, block-based DSL (`pipeline {}`) | Pure Groovy script (`node {}`)                  |
| **Complexity**         | Simple, human-readable                      | Advanced, fully programmable                    |
| **Error Handling**     | Built-in (`post`, `options`, `when`)        | Manual (`try/catch`, Groovy logic)              |
| **Flow Control**       | Predefined structure (stages, steps)        | Full control (loops, conditions, dynamic logic) |
| **Validation**         | Jenkins validates syntax before running     | Groovy runtime — errors only on execution       |
| **Parallel Execution** | Native `parallel {}` support                | Manual via `parallel()` function                |
| **Restart/Resume**     | Fully supported                             | Supported but more manual                       |
| **Best for**           | Standard CI/CD pipelines                    | Dynamic or conditional build logic              |
| **Example Block**      | `pipeline { stages { ... } }`               | `node { stage('...') { ... } }`                 |

---

### ⚙️ 1️⃣ Declarative Pipeline Example (Recommended)

```groovy
pipeline {
  agent any

  environment {
    APP_ENV = 'staging'
  }

  options {
    timeout(time: 30, unit: 'MINUTES')
    disableConcurrentBuilds()
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/org/app.git'
      }
    }

    stage('Build') {
      steps {
        sh 'mvn clean package'
      }
    }

    stage('Test') {
      steps {
        sh 'mvn test'
      }
    }

    stage('Deploy') {
      when {
        branch 'main'
      }
      steps {
        sh './scripts/deploy.sh'
      }
    }
  }

  post {
    success {
      echo '✅ Build and deployment succeeded!'
    }
    failure {
      echo '❌ Pipeline failed.'
    }
  }
}
```

**✅ Advantages:**

* Clean, easy-to-read structure.
* Validated by Jenkins before execution.
* Includes `post`, `environment`, `options`, and `when` directives.
* Great for team collaboration and version control.

---

### ⚙️ 2️⃣ Scripted Pipeline Example (Advanced Groovy)

```groovy
node {
  try {
    stage('Checkout') {
      checkout scm
    }

    stage('Build') {
      sh 'mvn clean package'
    }

    stage('Test') {
      sh 'mvn test'
    }

    stage('Conditional Deploy') {
      if (env.BRANCH_NAME == 'main') {
        sh './scripts/deploy.sh'
      } else {
        echo "Skipping deploy on branch ${env.BRANCH_NAME}"
      }
    }
  } catch (err) {
    echo "❌ Error: ${err}"
    currentBuild.result = 'FAILURE'
  } finally {
    echo "🔁 Cleanup done."
  }
}
```

**✅ Advantages:**

* Full Groovy flexibility — can use variables, loops, functions, and logic.
* Ideal for complex pipelines with dynamic behavior or API calls.
* More control for legacy or customized workflows.

---

### ⚙️ When to Use Which?

| Use Case                                   | Recommended Type  |
| ------------------------------------------ | ----------------- |
| Standard CI/CD (Build → Test → Deploy)     | ✅ **Declarative** |
| Jenkinsfile stored in Git repo             | ✅ **Declarative** |
| Team-managed, readable pipelines           | ✅ **Declarative** |
| Dynamic pipeline logic, loops, API calls   | ⚙️ **Scripted**   |
| Heavy use of Groovy scripts or custom DSLs | ⚙️ **Scripted**   |
| Legacy Jenkins environments                | ⚙️ **Scripted**   |

---

### ⚙️ Mixing Both (Hybrid Pipelines)

You can use **Scripted steps inside a Declarative pipeline** using the `script` block:

```groovy
pipeline {
  agent any
  stages {
    stage('Dynamic Steps') {
      steps {
        script {
          for (i in 1..3) {
            echo "Running test iteration #${i}"
          }
        }
      }
    }
  }
}
```

✅ Best of both worlds — clean structure + Groovy flexibility.

---

### ✅ Best Practices

* 🧩 Use **Declarative** syntax for 95% of use cases — it’s portable, readable, and CI/CD-friendly.
* 🧰 Use **Scripted** when logic needs custom Groovy code (loops, conditions, APIs).
* 🧾 Store your Jenkinsfiles in the repo root (Pipeline-as-Code).
* 🔒 Keep secrets in Jenkins Credentials Store (not hardcoded).
* 🚦 Use `post` in Declarative for cleanup and notification blocks.
* 🧪 Validate Declarative syntax:

  ```bash
  java -jar jenkins-cli.jar -s http://jenkins:8080 declarative-linter < Jenkinsfile
  ```

---

### 💡 In short

| Declarative                   | Scripted                          |
| ----------------------------- | --------------------------------- |
| Simple, structured, validated | Complex, flexible, Groovy-powered |
| Best for CI/CD pipelines      | Best for custom/dynamic logic     |
| YAML-like DSL                 | Pure Groovy syntax                |

👉 **Declarative** = pipeline-as-code for teams ✅
👉 **Scripted** = full control for advanced automation ⚙️

---
---

## Q: How to parameterize Jenkins jobs?

### 🧠 Overview

Parameters let you **pass inputs into a Jenkins job** (branch name, feature flag, version, credentials, etc.), making pipelines reusable and interactive. You can declare typed parameters in Freestyle jobs or in a `Jenkinsfile` (`parameters { ... }`) for Pipeline-as-Code.

---

### ⚙️ Examples / Commands

#### 1) Declarative `Jenkinsfile` — common parameter types

```groovy
pipeline {
  agent any

  parameters {
    string(name: 'BRANCH', defaultValue: 'main', description: 'Branch to build')
    booleanParam(name: 'RUN_SMOKE', defaultValue: true, description: 'Run smoke tests?')
    choice(name: 'ENV', choices: ['dev','staging','prod'], description: 'Target env')
    credentials(name: 'DEPLOY_KEY', description: 'SSH key for deployment')
    password(name: 'DB_PASS', defaultValue: '', description: 'DB password (masked)')
  }

  stages {
    stage('Info') {
      steps {
        echo "Branch: ${params.BRANCH}"
        echo "Run smoke: ${params.RUN_SMOKE}"
        echo "Env: ${params.ENV}"
      }
    }

    stage('Use credential') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: params.DEPLOY_KEY, keyFileVariable: 'KEY')]) {
          sh 'echo "Using key file $KEY"'
        }
      }
    }
  }
}
```

#### 2) Scripted pipeline usage

```groovy
node {
  // access params map as global variable in Multibranch or if job has parameters
  echo "Tag: ${params.TAG ?: 'none'}"

  if (params.DEPLOY == true) {
    sh "./deploy.sh ${params.ENV}"
  }
}
```

#### 3) Freestyle job (UI)

* Create job → check **This project is parameterized** → Add Parameter (String, Choice, Boolean, Credentials, etc.).
* Use `${BRANCH}` in build steps (shell, batch).

#### 4) Trigger job with parameters via `curl` (Remote API)

```bash
# get crumb (CSRF)
CRUMB=$(curl -s -u "user:APITOKEN" "https://jenkins.example.com/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")

# trigger param build
curl -X POST -u "user:APITOKEN" -H "$CRUMB" \
  "https://jenkins.example.com/job/my-job/buildWithParameters" \
  --data-urlencode "BRANCH=feature/123" \
  --data-urlencode "ENV=staging"
```

#### 5) Trigger with `gh` / Jenkins CLI (example)

```bash
# Jenkins CLI param build
java -jar jenkins-cli.jar -s https://jenkins.example.com -auth user:token build my-job -p BRANCH=dev -p ENV=staging
```

#### 6) Parameterized downstream / pipeline-to-pipeline

```groovy
// trigger another job with parameters
build job: 'downstream-job', parameters: [
  string(name: 'REV', value: env.GIT_COMMIT),
  booleanParam(name: 'RUN_TESTS', value: true)
]
```

---

### 📋 Parameter Types & Notes

| Type                      | Syntax (Declarative)                            | Use-case / Notes                                       |
| ------------------------- | ----------------------------------------------- | ------------------------------------------------------ |
| `string`                  | `string(name:'BRANCH', defaultValue:'main')`    | Free-text input (branch, version)                      |
| `booleanParam`            | `booleanParam(name:'SKIP', defaultValue:false)` | Toggles (run tests?)                                   |
| `choice`                  | `choice(name:'ENV', choices:['dev','staging'])` | Limited options                                        |
| `credentials`             | `credentials(name:'AWS_CREDS')`                 | Secure: returns credentials id — use `withCredentials` |
| `password`                | `password(name:'DB_PASS')`                      | Masked in UI/logs                                      |
| `runTimeChoice` (plugins) | various plugin-provided types                   | Dynamic choices, scripts                               |
| `file`                    | `fileParam` (Freestyle)                         | Upload a file to the build workspace                   |

> 🔒 **Credentials and password** params store only a reference; use Jenkins **Credentials Store** — do not hardcode secrets.

---

### ✅ Best Practices

* 🧩 **Parameterize only what changes**: branch, env, version — keep pipelines deterministic.
* 🔒 Use **Credentials** parameter for secrets; bind with `withCredentials`.
* 🧪 Validate parameters early (sanity checks) and fail fast:

  ```groovy
  if (!params.BRANCH.matches('^[a-zA-Z0-9_\\-/.]+$')) { error "Bad branch name" }
  ```
* 📦 Prefer **choice** over free text when values are known (reduces typos).
* 🧾 Document parameters in README / job description.
* 🧰 For security, restrict who can run parameterized jobs that accept credentials (use RBAC).
* ♻️ Avoid exposing secret values in console logs — mask with `maskPasswords` plugin if needed.
* 🔁 Use parameter defaults for CI automation; override only for ad-hoc runs.
* 🧹 Keep parameter list minimal to reduce complexity and accidental misuse.

---

### 💡 Troubleshooting Tips

* If `params` is empty in Multibranch: ensure Jenkinsfile is in root and job is configured to accept parameters (Multibranch reads `parameters` block).
* Credential `credentials()` in Declarative creates a UI field but **returns a string id** — must use `withCredentials` to access secret values.
* To expose parameter in environment:

  ```groovy
  environment { TARGET = "${params.ENV}" }
  ```
* For dynamic choices, use **Active Choices Plugin** or generate a file in an upstream job.

---

### 💡 In short

Declare parameters in `Jenkinsfile` with `parameters { ... }` (string, choice, boolean, credentials), access via `params.<NAME>`, and trigger builds with parameters using the UI, `curl` (`buildWithParameters`), or Jenkins CLI. Use credentials securely via Jenkins Credentials and validate inputs early. ✅

---
---

## Q: How to archive and share build artifacts?

### 🧠 Overview

Archive build outputs (JARs, Docker images, binaries) reliably and publish them to an **artifact store** (Nexus/Artifactory/S3/GCR/ECR/GitHub Releases) so CI/CD, QA, and deploy pipelines can consume immutable, versioned artifacts.

---

### ⚙️ Common Approaches & Examples

#### 1) Jenkins — archive artifacts (store in Jenkins UI)

```groovy
pipeline {
  agent any
  stages {
    stage('Build') { steps { sh 'mvn -DskipTests package' } }
    stage('Archive') {
      steps {
        archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
      }
    }
  }
}
```

* `archiveArtifacts` stores files in Jenkins master (good for small/short-term artifacts).
* Use `fingerprint: true` for traceability.

---

#### 2) Push to artifact repository (recommended for production)

##### JFrog Artifactory (jfrog CLI)

```bash
# configure once
jfrog rt config --interactive=false --url=https://artifactory.mycompany.com --user=ci-bot --apikey=$JFROG_APIKEY

# upload with properties (build info)
jfrog rt upload "build/libs/*.jar" my-repo/myapp/${BUILD_NUMBER}/ --props "env=staging;build=${BUILD_NUMBER}"
# download
jfrog rt download "my-repo/myapp/${BUILD_NUMBER}/*.jar" .
```

##### Nexus (raw) — curl example

```bash
# upload artifact to raw repo
curl -u user:pass --upload-file target/app.jar "https://nexus.mycompany.com/repository/raw-repo/myapp/${BUILD_NUMBER}/app.jar"
```

##### S3 (object storage) — AWS CLI

```bash
# upload artifact
aws s3 cp target/app.tar.gz s3://my-artifacts/myapp/${BUILD_NUMBER}/app.tar.gz --acl private

# make presigned URL for sharing (valid 1 hour)
aws s3 presign s3://my-artifacts/myapp/${BUILD_NUMBER}/app.tar.gz --expires-in 3600
```

---

#### 3) Containers — push images to registry (ECR/GCR/DockerHub)

```bash
# Build & push to ECR (example)
docker build -t 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:${BUILD_NUMBER} .
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:${BUILD_NUMBER}
```

* Tag with immutable version or digest. Use `:v1.2.3` and/or `@sha256:<digest>` for reproducibility.

---

#### 4) GitHub Releases (for binaries / installers)

```bash
# Create release and upload (GitHub CLI)
gh release create v1.2.3 build/myapp.tar.gz --title "v1.2.3" --notes "Release notes"
```

---

### 📋 What to store with artifacts (metadata & provenance)

| Item                           | Why                                  |
| ------------------------------ | ------------------------------------ |
| Version & build number         | Unique identification                |
| Commit SHA                     | Link artifact → source code          |
| Build info (CI job, timestamp) | Traceability                         |
| Checksums (SHA256)             | Integrity verification               |
| Signed artifacts (GPG)         | Authenticity                         |
| Properties/tags                | Environment, channel (canary/stable) |

Example: generate checksum and sign

```bash
sha256sum app.jar > app.jar.sha256
gpg --armor --detach-sign app.jar
```

---

### ✅ Best Practices (production-ready)

* 🧾 **Use an artifact repository** (Artifactory/Nexus/S3) for long-term storage and access control.
* 🔐 **Secure storage & access**: IAM roles, API keys, least privilege, signed URLs for temporary sharing.
* 🔁 **Immutable, versioned artifacts** — never overwrite a published artifact; use new version or promotion model.
* 🔍 **Publish metadata**: commit SHA, build number, CI job URL, environment tags.
* ✔️ **Store checksums and signatures** to verify integrity and authenticity.
* 🧪 **Promote artifacts** (dev → staging → prod) by copying or retagging rather than rebuilding.
* 🧰 **Automate uploads in CI** after successful tests; keep artifact publication separate from deploy jobs (promote instead).
* ♻️ **Retention & cleanup**: set lifecycle policies (e.g., S3 lifecycle, repo retention) to control storage costs.
* 📦 **Use content-addressable identifiers** (digest) for container images to avoid ambiguity.
* 📜 **Record provenance** in your release notes and in build metadata stored in the artifact repo.

---

### ⚙️ Quick CI examples

#### GitHub Actions — upload artifact & create release

```yaml
name: CI
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: mvn -DskipTests package
      - uses: actions/upload-artifact@v4
        with:
          name: myapp-${{ github.run_number }}
          path: target/*.jar

  release:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: softprops/action-gh-release@v1
        with:
          files: target/*.jar
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

#### Jenkins — push to S3 and produce presigned URL

```groovy
stage('Publish') {
  steps {
    sh '''
      aws s3 cp target/app.tar.gz s3://my-artifacts/myapp/${BUILD_NUMBER}/app.tar.gz
      aws s3 presign s3://my-artifacts/myapp/${BUILD_NUMBER}/app.tar.gz --expires-in 3600 > presigned.url
    '''
    archiveArtifacts artifacts: 'presigned.url', fingerprint: true
  }
}
```

---

### 📋 Quick Commands Reference

| Action                | Command                                                  |
| --------------------- | -------------------------------------------------------- |
| Archive in Jenkins    | `archiveArtifacts artifacts: 'target/*.jar'`             |
| Upload to Artifactory | `jfrog rt upload "build/libs/*.jar" repo/path/`          |
| Upload to Nexus (raw) | `curl --upload-file file.jar https://nexus/...`          |
| Upload to S3          | `aws s3 cp file s3://bucket/path/`                       |
| Presign S3 URL        | `aws s3 presign s3://bucket/path/file --expires-in 3600` |
| Push Docker image     | `docker push repo/image:tag`                             |
| GitHub Release upload | `gh release create vX.Y.Z file`                          |
| Generate checksum     | `sha256sum file > file.sha256`                           |

---

### 💡 In short

Archive artifacts in a **versioned artifact repository** (Artifactory/Nexus/S3/ECR) with **metadata, checksums, and signatures**, publish from CI, and share via secure URLs or registry tags — immutable and traceable for reliable deployments. ✅

---
---

## Q: How to handle build failures or retries

### 🧠 Overview

When builds fail you should **detect cause, retry safely (bounded), isolate flaky tests**, and **notify/stabilize** — prefer deterministic fixes over blind retries. Automate retries for transient failures (network, infra) but gate them with limits, backoff, and escalation.

---

### ⚙️ Common Strategies & Workflow

1. 🔍 **Classify failure** — transient (network/infra), flaky test, real code/regression, environment/config.
2. 🔁 **Auto-retry transient failures** with limited retries + backoff.
3. 🧪 **Isolate flaky tests**: quarantine, rerun failing tests only, mark flaky tests for stability work.
4. 📦 **Preserve logs & artifacts** for post-mortem.
5. 📣 **Notify owners** with context (commit, job URL, failure reason).
6. 🛠️ **Fix root cause** (code, infra, tests), then remove retries/quarantine.
7. 🔁 **Escalate** if repeated failures (open ticket, block merges).

---

### ⚙️ Examples / Commands

#### Jenkins — Declarative pipeline `retry` + `timestamps` + backoff (simple)

```groovy
pipeline {
  agent any
  options { timestamps() }
  stages {
    stage('Build with retries') {
      steps {
        // retry 3 times on transient failures
        retry(3) {
          sh './gradlew assemble --no-daemon'
        }
      }
    }
  }
  post {
    failure {
      archiveArtifacts artifacts: 'build/reports/**/*.log', allowEmptyArchive: true
      mail to: 'dev-team@example.com', subject: "Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "${env.BUILD_URL}"
    }
  }
}
```

#### Jenkins — Exponential backoff retry (script block)

```groovy
def maxRetries = 3
def delay = 5
def attempt = 0
pipeline {
  agent any
  stages {
    stage('Build w/ backoff') {
      steps {
        script {
          while (attempt < maxRetries) {
            attempt++
            try {
              sh './scripts/build.sh'
              break
            } catch (err) {
              if (attempt == maxRetries) { error "Build failed after ${attempt} attempts" }
              sleep time: delay, unit: 'SECONDS'
              delay *= 2 // exponential backoff
            }
          }
        }
      }
    }
  }
}
```

#### Jenkins — Retry only failing tests (JUnit examples)

* Run failing test cases only (JUnit/TestNG) using test runner features to rerun failures:

```bash
# Maven Surefire: rerun failing tests up to 2 times
mvn -Dtest=... -Dsurefire.rerunFailingTestsCount=2 test
```

Or use `flaky-test-handler` plugins to rerun failed tests and mark flakes.

#### GitHub Actions — `retry` pattern via `actions/toolkit` or custom step

```yaml
# simple loop to retry a command 3 times
- name: Run build with retries
  run: |
    n=0
    until [ $n -ge 3 ]
    do
      ./ci/build.sh && break
      n=$((n+1))
      sleep $((2**n))
    done
    if [ $n -eq 3 ]; then exit 1; fi
```

#### GitLab CI — retry keyword (job-level)

```yaml
job:
  script: ./build.sh
  retry:
    max: 2        # retry up to 2 times
    when:
      - runner_system_failure
      - stuck_or_timeout_failure
```

---

### 📋 What to retry (and what not to)

|                              Retry Target |         Retry?         | Notes                                  |
| ----------------------------------------: | :--------------------: | -------------------------------------- |
|      Network timeouts (artifact download) |            ✅           | Retries helpful; use backoff           |
|                   Container pull failures |            ✅           | Transient registry/connection issues   |
| Infrastructure spin-up (ephemeral agents) |            ✅           | Retry if agent unavailable             |
|                          Flaky unit tests | ⚠️ Use targeted reruns | Quarantine and fix flakiness long-term |
|      Compilation errors / test assertions |            ❌           | Don’t auto-retry — fix code            |
| Failing security checks / static analysis |            ❌           | Don’t retry — address issues           |

---

### ✅ Best Practices (practical, production-ready)

* 🎯 **Limit retries** (e.g., 2–3) and use **exponential backoff** to avoid thundering herd.
* 🧾 **Record attempt metadata** (attempt number, timestamps) in build logs and status.
* 🧰 **Rerun only failing tests** rather than whole suite (faster & cheaper).
* 🧪 **Quarantine flaky tests**: mark as flaky, exclude from blocking pipelines, create bug/owner ticket.
* 📦 **Persist logs & artifacts** on each attempt for triage. Use `archiveArtifacts` / uploads.
* 🔍 **Attach root-cause context**: commit SHA, pipeline step logs, agent/node details, environment variables.
* 🔔 **Notify appropriately** (Slack/email with job link, failing tests, and owner) — avoid noisy alerts.
* 🔒 **Fail fast in gating pipelines** (don’t mask real failures with retries).
* 📈 **Monitor failure trends** (flaky tests, infra failures) and set SLOs for build success rates.
* 🧪 **Use canary PR job** runs for risky changes; require green runs before merging.
* ♻️ **Automate rerun via CI job** (e.g., "Rerun failing build" button or API) with audit trail.

---

### 💡 Debugging checklist when failures persist

* Check agent/node: disk, memory, CPU, Docker daemon, network.
* Reproduce failing step locally (same container image).
* Compare environment variables and dependency versions between attempts.
* Inspect cached artifacts or dependency mirrors (corrupted caches).
* Run only failing test(s) with verbose logs to find race conditions or ordering issues.
* If intermittent, add timing/logging to capture race windows.

---

### 💡 In short

Auto-retry **transient** failures (2–3 attempts, with backoff) and preserve logs; **don’t** blindly retry assertion failures — isolate flaky tests, quarantine & fix them, and notify owners with full context. ✅

---
---

## Q: How to integrate Jenkins with GitHub or GitLab

### 🧠 Overview

Connect Jenkins to your Git host so pushes/PRs automatically trigger builds. Use **webhooks + Branch Source plugins (Multibranch/Org Folder)** for event-driven CI; prefer **GitHub App** (or GitLab App) for secure, scalable installs. Store tokens in Jenkins **Credentials** and use `Jenkinsfile` (Pipeline-as-Code) for reproducible builds.

---

### ⚙️ Quick architecture (common patterns)

* **Single-repo Jenkins Job** ← webhook → `job/buildWithParameters`
* **Multibranch Pipeline / Org Folder** ← GitHub/GitLab Branch Source plugin + webhook → auto-scan & build branches/PRs
* **GitHub App** or **PAT** ↔ Jenkins Credentials for authenticated API operations (PR statuses, checks).

---

### ⚙️ Examples / Commands

#### 1) GitHub — recommended: GitHub App + Multibranch Pipeline

1. Install **GitHub Branch Source** and **GitHub App** plugins in Jenkins.
2. In GitHub: install **Jenkins GitHub App** (Organization → Apps → Install) and grant repo access.
3. In Jenkins: **Manage Jenkins → Configure System → GitHub** → add GitHub App integration (App ID + private key) or create Credentials (GitHub App or PAT).
4. Create **Multibranch Pipeline** job pointing at the repo (Jenkinsfile must be in repo root).
5. Configure webhook: GitHub App handles webhooks automatically for you.

   * If using PAT/manual webhook: set Payload URL to `https://jenkins.example.com/github-webhook/` and secret.

`Jenkinsfile` (example, Declarative):

```groovy
pipeline {
  agent any
  triggers { githubPush() }   // requires GitHub plugin/webhook
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Build')    { steps { sh 'mvn -DskipTests package' } }
    stage('Test')     { steps { sh 'mvn test' } }
  }
  post { always { junit 'target/surefire-reports/*.xml' } }
}
```

#### 2) GitHub — manual webhook (curl example)

```bash
# create webhook via gh CLI (example)
gh api repos/:owner/:repo/hooks -f config='{"url":"https://jenkins.example.com/github-webhook/","content_type":"json","secret":"<WEBHOOK_SECRET>"}' -f events='["push","pull_request"]'
```

Or in UI: Settings → Webhooks → Add webhook → Payload URL `https://jenkins.example.com/github-webhook/`.

#### 3) GitLab — Branch Source plugin / webhook

1. Install **GitLab Plugin** or **GitLab Branch Source** in Jenkins.
2. In GitLab: create a project access token (or use Group integration).
3. In Jenkins: add GitLab credentials (token) and create a **Multibranch Pipeline** (GitLab branch source).
4. Configure webhook in GitLab: **Settings → Webhooks** → URL `https://jenkins.example.com/project/<job-name>` or use Branch Source plugin endpoint if configured. Select `Push events` and `Merge request events`.

Curl example to create GitLab webhook:

```bash
curl --request POST --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  --data "url=https://jenkins.example.com/gitlab-webhook/&push_events=true&merge_requests_events=true" \
  "https://gitlab.com/api/v4/projects/<project_id>/hooks"
```

#### 4) Simple Remote-trigger (legacy) — use token + crumb

```bash
# Trigger job with token (job needs "Trigger builds remotely" enabled)
CRUMB=$(curl -s -u "jenkins_user:APITOKEN" "https://jenkins.example.com/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")
curl -X POST -u "jenkins_user:APITOKEN" -H "$CRUMB" "https://jenkins.example.com/job/my-job/build?token=MY_TRIGGER_TOKEN"
```

---

### 📋 Feature / Endpoint Mapping

| Need                     | GitHub                                        | GitLab                                                            |
| ------------------------ | --------------------------------------------- | ----------------------------------------------------------------- |
| Webhook URL (default)    | `https://jenkins.example.com/github-webhook/` | `https://jenkins.example.com/gitlab-webhook/` or `/project/<job>` |
| Best auth                | GitHub App (recommended) / PAT                | Project Access Token / GitLab App                                 |
| Branch Source plugin     | GitHub Branch Source                          | GitLab Branch Source                                              |
| Multibranch support      | ✅                                             | ✅                                                                 |
| PR checks/status updates | ✅ (via App/PAT)                               | ✅ (via token)                                                     |

---

### ✅ Best Practices

* 🔐 **Prefer GitHub App / GitLab App** over PATs for scalability & least privilege.
* 🔑 Store tokens/keys in **Jenkins Credentials** (use `withCredentials` in pipeline) — never in `Jenkinsfile`.
* ⚡ Use **webhooks**, not polling (`Poll SCM`), for faster, efficient triggers.
* 🧩 Use **Multibranch Pipelines / Organization folders** so new branches/PRs auto-detect Jenkinsfile.
* 🔒 Secure webhooks with **secrets** and validate on Jenkins; restrict incoming traffic via firewall/IP allowlist.
* 🧪 Test webhook delivery from Git host (GitHub/GitLab show delivery logs).
* 📣 Configure Jenkins to report **status checks** and PR comments via the API (so CI status appears in PR).
* ♻️ Use **ephemeral agents** (Kubernetes/Docker) for clean, reproducible builds invoked by webhooks.
* 🧾 Limit webhook events to necessary ones (push, pull_request/merge_request) to reduce noise.
* 🧭 Document the integration and recovery steps (reinstall app, rotate token) in repo `CONTRIBUTING.md`.

---

### 🔧 Troubleshooting checklist

* Is webhook delivery successful? (Git host delivery logs)
* Does Jenkins have the correct credential/app installed? (App private key / token valid)
* Is the Multibranch job configured to scan / build PRs? (Scan credentials & branch source)
* Are webhooks reaching Jenkins (reverse proxy, TLS, firewall)?
* Check Jenkins logs: `Manage Jenkins → System Log` and job build logs for webhook payload handling errors.

---

### 💡 In short

Use **webhooks + Branch Source plugins** (Multibranch/Org Folder) and authenticate with **GitHub/GitLab App** or tokens stored in Jenkins Credentials. Configure a `Jenkinsfile` in repos, prefer the App for security, and rely on webhooks (not polling) for fast, reliable CI triggers. ✅

---

---

## Q: How to Pass Environment Variables in Jenkins

### 🧠 Overview

In Jenkins, **environment variables** let you share configuration (e.g., build version, credentials, API keys, paths) across stages or jobs.
You can define them **globally**, **per job**, or **within the pipeline (`Jenkinsfile`)**, and use them in **shell commands**, **build steps**, or **pipeline scripts**.

---

### ⚙️ 1️⃣ Types of Environment Variables in Jenkins

| Scope                                     | Where Defined                          | Example                                      |
| ----------------------------------------- | -------------------------------------- | -------------------------------------------- |
| **Global**                                | Manage Jenkins → Configure System      | `PATH`, `JAVA_HOME`, `MAVEN_OPTS`            |
| **Node-specific**                         | On agent node config                   | `NODE_LABEL`, `WORKSPACE`, `EXECUTOR_NUMBER` |
| **Job-level (Freestyle)**                 | Job → Configure → Build Environment    | `APP_ENV=staging`                            |
| **Pipeline-level (Declarative/Scripted)** | Inside Jenkinsfile                     | `environment { ... }`                        |
| **Runtime / Dynamic**                     | From shell, parameters, or `withEnv()` | `export BUILD_ID=$BUILD_NUMBER`              |

---

### ⚙️ 2️⃣ Declarative Pipeline Example

```groovy
pipeline {
  agent any

  environment {
    APP_ENV = 'staging'
    VERSION = "1.0.${BUILD_NUMBER}"
    PATH = "$PATH:/usr/local/bin"
    AWS_REGION = credentials('aws-region') // credential-based variable
  }

  stages {
    stage('Build') {
      steps {
        sh 'echo "Building version $VERSION for $APP_ENV in region $AWS_REGION"'
      }
    }

    stage('Deploy') {
      steps {
        sh './deploy.sh $APP_ENV'
      }
    }
  }

  post {
    always {
      echo "Cleaning up build #${BUILD_NUMBER}"
    }
  }
}
```

✅ **Notes:**

* `environment {}` block defines variables for all stages.
* Variables are available in both **Groovy** and **shell** contexts.
* Can reference built-ins like `BUILD_NUMBER`, `JOB_NAME`, `WORKSPACE`.

---

### ⚙️ 3️⃣ Scripted Pipeline Example

```groovy
node {
  withEnv(["APP_ENV=dev", "VERSION=2.1.${env.BUILD_NUMBER}"]) {
    stage('Build') {
      sh 'echo "Building version $VERSION for $APP_ENV"'
    }
    stage('Deploy') {
      sh './deploy.sh $APP_ENV'
    }
  }
}
```

`withEnv` sets environment variables **temporarily** within its scope.

---

### ⚙️ 4️⃣ Inject Environment Variables (Freestyle Job)

1. Go to **Configure Job → Build Environment**
2. Check ✅ *Inject environment variables*
3. Provide:

   ```
   APP_ENV=prod
   VERSION=1.0.${BUILD_NUMBER}
   ```
4. Use `$APP_ENV` in your shell commands or build steps.

Or use the **EnvInject Plugin** to load variables from a `.env` or properties file:

```
KEY1=value1
KEY2=value2
```

---

### ⚙️ 5️⃣ Pass Variables Between Stages

```groovy
pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        script {
          env.IMAGE_TAG = "v${BUILD_NUMBER}"
          echo "Built image tag: ${env.IMAGE_TAG}"
        }
      }
    }
    stage('Deploy') {
      steps {
        sh 'echo "Deploying image tag ${IMAGE_TAG}"'
      }
    }
  }
}
```

🧩 `env.<VAR>` makes the variable available across all subsequent stages.

---

### ⚙️ 6️⃣ From Credentials (Secure Variables)

Store secrets in Jenkins → **Manage Credentials** → then use:

```groovy
pipeline {
  agent any
  environment {
    AWS_KEY = credentials('aws-access-key')
  }
  stages {
    stage('Deploy') {
      steps {
        sh 'aws configure set aws_access_key_id $AWS_KEY'
      }
    }
  }
}
```

Or for complex credentials:

```groovy
withCredentials([usernamePassword(credentialsId: 'db-creds', usernameVariable: 'DB_USER', passwordVariable: 'DB_PASS')]) {
  sh 'psql -U $DB_USER -p $DB_PASS mydb'
}
```

---

### ⚙️ 7️⃣ From Build Parameters

```groovy
parameters {
  string(name: 'DEPLOY_ENV', defaultValue: 'staging')
}
stages {
  stage('Deploy') {
    steps {
      sh 'echo "Deploying to ${params.DEPLOY_ENV}"'
    }
  }
}
```

📦 Jenkins automatically exposes parameters as environment variables (`$DEPLOY_ENV`).

---

### ⚙️ 8️⃣ Load Environment File (.env)

If your repo contains `.env`, load dynamically:

```groovy
sh 'export $(grep -v "^#" .env | xargs)'
```

Or use **EnvFile Plugin**:

```groovy
environment {
  DOTENV = readProperties file: '.env'
}
```

---

### ⚙️ 9️⃣ Print All Environment Variables (Debug)

```groovy
pipeline {
  agent any
  stages {
    stage('Debug Env') {
      steps {
        sh 'printenv | sort'
      }
    }
  }
}
```

🧾 Useful for debugging variable visibility & scope.

---

### 📋 Common Built-in Environment Variables

| Variable       | Example                            | Description             |
| -------------- | ---------------------------------- | ----------------------- |
| `BUILD_NUMBER` | `105`                              | Current build number    |
| `JOB_NAME`     | `myapp-build`                      | Jenkins job name        |
| `WORKSPACE`    | `/var/lib/jenkins/workspace/myapp` | Build workspace path    |
| `BUILD_ID`     | `2025-11-11_12-32-45`              | Unique build timestamp  |
| `GIT_COMMIT`   | `c3d4e8a`                          | Git commit hash         |
| `GIT_BRANCH`   | `origin/main`                      | Source branch           |
| `NODE_NAME`    | `agent-1`                          | Agent executing the job |
| `JENKINS_URL`  | `https://jenkins.example.com/`     | Base Jenkins URL        |

---

### ✅ Best Practices

* 🧩 Use `environment {}` block for clarity and version control.
* 🔒 Store **secrets** in Jenkins Credentials, not plaintext vars.
* 🧾 Reference parameters via `params.<NAME>` instead of reassigning.
* ⚙️ Use `withEnv()` for short-lived overrides.
* 🧰 Inject build metadata (`BUILD_NUMBER`, `GIT_COMMIT`) into Docker tags or version files.
* 🔍 Log variables safely — mask sensitive ones (install *Mask Passwords Plugin*).
* 🧪 Prefer `.env` files for consistency across local + CI.

---

### 💡 In short

You can pass env vars:

> **Globally**, **per job**, or **inside Jenkinsfile** using
> `environment {}`, `withEnv()`, or **credentials binding**.

✅ Use `environment {}` for config, `withCredentials` for secrets, and `$params` for build inputs.
**Never hardcode secrets — store them in Jenkins Credentials.**

---
---

## Q: How to use credentials securely?

### 🧠 Overview

Store secrets outside source code, grant least privilege, inject secrets at runtime via the platform’s secret store, and rotate/audit regularly. Use ephemeral credentials where possible and never print secrets in logs.

---

### ⚙️ Examples / Commands

#### 1) **Jenkins — Credentials + `withCredentials`**

```groovy
pipeline {
  agent any
  environment { // non-secret envs
    APP_ENV = 'staging'
  }
  stages {
    stage('Deploy') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'svc-user-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh '''
            echo "Logging in (do not print secrets)"
            curl -u $USER:$PASS https://api.example.com/deploy -X POST
          '''
        }
      }
    }
  }
}
```

* Use `credentialsId` referencing the Jenkins Credentials Store.
* Avoid `echo $PASS` — do not leak.

#### 2) **GitHub Actions — Secrets (repo/org)**

```yaml
name: CI
on: push
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Use secret
        run: ./deploy.sh
        env:
          API_KEY: ${{ secrets.PROD_API_KEY }}
```

* Secrets stored in repo/org settings and injected only into runner env.
* Use environment protection rules for production secrets.

#### 3) **GitLab CI — Protected Variables**

```yaml
deploy:
  stage: deploy
  only:
    - main
  script:
    - aws s3 cp file s3://mybucket/
  variables:
    AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID   # set in GitLab CI Settings -> Variables (protected, masked)
```

* Mark variables **protected** and **masked**.

#### 4) **Kubernetes — Secrets (mount or env)**

```bash
kubectl create secret generic db-creds \
  --from-literal=username=dbuser --from-literal=password='s3cr3t' -n prod

# In Deployment (envFrom)
envFrom:
- secretRef:
    name: db-creds
```

* Prefer mounting as files in containers or use CSI secrets driver / external secret operator to sync from Vault/Secrets Manager.

#### 5) **AWS — IAM roles & Secrets Manager (recommended)**

```bash
# Create secret (once)
aws secretsmanager create-secret --name prod/db-pass --secret-string 'mypassword'

# EC2/ECS/EKS use IAM role - no long-lived keys in code
# Retrieve in app:
aws secretsmanager get-secret-value --secret-id prod/db-pass --query SecretString --output text
```

* Use instance/Task/IAM roles or IRSA (EKS) instead of embedding AWS keys.

#### 6) **HashiCorp Vault — dynamic creds example**

```bash
# Example: request DB creds (Vault issues short-lived creds)
vault read database/creds/readonly
# Returns username/password with TTL; rotate automatically by Vault.
```

* Vault can generate dynamic DB users, AWS STS creds, etc.

#### 7) **Terraform — avoid secrets in state**

```hcl
provider "aws" {
  region = var.region
}

# Use remote state encryption and workspace isolation; don't write secrets as plain outputs.
```

* Use `sops`, `vault` provider, or Terraform Cloud workspace variables with sensitive = true.

---

### 📋 Quick Comparison Table

|       Platform | Secret Store                | Best Pattern                                |
| -------------: | :-------------------------- | :------------------------------------------ |
|        Jenkins | Credentials Manager         | `withCredentials` + scoped IDs              |
| GitHub Actions | Repo/Org secrets            | Repo secrets + environment protection       |
|      GitLab CI | CI/CD Variables             | Protected + masked variables                |
|     Kubernetes | Secrets / External Secrets  | CSI driver / ExternalSecret from Vault/SM   |
|            AWS | Secrets Manager / IAM Roles | IAM roles (no keys) + Secrets Manager       |
|          Vault | Dynamic secrets             | Short-lived, auditable creds                |
|      Local dev | env files + sops            | Encrypted files (`sops`) + local env loader |

---

### ✅ Best Practices (practical & production-ready)

* 🔐 **Never commit secrets** to Git. Use pre-commit hooks and secret scanners (`gitleaks`, `detect-secrets`).
* 🧩 **Centralize secrets** in a secret manager (Vault, AWS Secrets Manager, GCP Secret Manager) — prefer dynamic, short-lived credentials.
* 🎯 **Least privilege**: grant minimal scopes and use IAM roles/service accounts, not long-lived keys.
* 🔁 **Rotate regularly** and on suspected compromise (automate rotation).
* 🕵️ **Audit & monitor** access to secrets (CloudTrail, Vault audit logs). Alert on anomalous reads.
* 🔒 **Encrypt at rest and in transit**: use TLS; ensure secret stores encrypt data at rest.
* 🧰 **Use platform-native bindings**: `withCredentials`, `env`, CSI driver, Secret Store CSI, etc. — prefer injection at runtime.
* 🚫 **Avoid printing secrets in logs**; mask secrets in CI output (masking plugins/features).
* 🧾 **Mark secrets as sensitive** in tools (Terraform `sensitive = true`) and do not output them.
* 🧪 **Test access controls** periodically and include secret usage in CI security scans.
* 📦 **For local development**, use developer-specific short-lived credentials or `sops`-encrypted `.env` files and never share them.
* 🔁 **Use automated rotation + deployment** to reduce blast radius (CI processes pick up new secrets from store).
* 🧯 **Have incident playbook**: revoke/rotate, search for exposure, notify stakeholders, and re-deploy.

---

### 💡 In short

**Don’t store secrets in code**. Use a secret manager (Vault/Secrets Manager), inject secrets at runtime via platform-specific bindings (Jenkins `withCredentials`, GitHub `secrets.*`, K8s CSI, IAM roles), apply least privilege, enable auditing, and rotate frequently. ✅

---
---

## Q: What’s a Shared Library in Jenkins?

### 🧠 Overview

A **Shared Library** in Jenkins is a **centralized, reusable codebase** that stores **common pipeline logic** (functions, steps, vars, and configurations) used across multiple `Jenkinsfile`s.
It enables **DRY (Don’t Repeat Yourself)** principles — keeping pipelines consistent, maintainable, and version-controlled.

---

### ⚙️ Why Use Shared Libraries?

| 🧩 Problem                                     | ✅ Solution via Shared Library                                  |
| ---------------------------------------------- | -------------------------------------------------------------- |
| Repeating same pipeline code in multiple repos | Define once, reuse everywhere                                  |
| Hard to maintain logic changes                 | Update library → instantly used in all jobs                    |
| Inconsistent standards                         | Centralize build/test/deploy standards                         |
| Managing secrets or utilities                  | Implement reusable helpers (e.g., notify Slack, deploy Docker) |

---

### ⚙️ Shared Library Structure

Example: **Git repo layout** (e.g., `jenkins-shared-lib`)

```
(jenkins-shared-lib)/
├── vars/
│   ├── buildApp.groovy         # simple reusable steps
│   ├── deployApp.groovy
│   └── notifySlack.groovy
├── src/org/company/ci/
│   ├── Utils.groovy            # classes, helper methods
│   └── DockerHelper.groovy
├── resources/
│   └── templates/notify.json   # static files (JSON, YAML)
├── Jenkinsfile (optional)
└── README.md
```

* **`vars/`** → global pipeline steps (auto-loaded as functions).
* **`src/`** → namespaced Groovy classes for advanced logic.
* **`resources/`** → templates/configs accessible via `libraryResource()`.
* **`Jenkinsfile`** → optional (for testing library builds).

---

### ⚙️ 1️⃣ Define Library in Jenkins UI

**Steps:**

1. Go to **Manage Jenkins → Configure System → Global Pipeline Libraries**
2. Add entry:

   * **Name:** `shared-lib`
   * **Default Version:** `main` (branch/tag)
   * **Retrieval method:** Modern SCM → Git
   * **Repository URL:** `https://github.com/org/jenkins-shared-lib.git`
   * **Credentials:** (if private repo)

Now any pipeline can load it using:

```groovy
@Library('shared-lib') _
```

---

### ⚙️ 2️⃣ Use Library in a Jenkinsfile

```groovy
@Library('shared-lib') _

pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        buildApp('myservice', '1.0.${BUILD_NUMBER}')
      }
    }
    stage('Deploy') {
      steps {
        deployApp(env: 'staging')
      }
    }
  }
  post {
    always {
      notifySlack "Build #${BUILD_NUMBER} finished with status: ${currentBuild.currentResult}"
    }
  }
}
```

✅ The functions `buildApp`, `deployApp`, and `notifySlack` come from the shared library’s `vars/` directory.

---

### ⚙️ 3️⃣ Example of a Shared Library Function (`vars/buildApp.groovy`)

```groovy
def call(String service, String version) {
  echo "🔨 Building ${service} version ${version}"
  sh """
    docker build -t myregistry/${service}:${version} .
    docker push myregistry/${service}:${version}
  """
}
```

You can now call `buildApp('myservice', '1.2.3')` directly in any Jenkinsfile.

---

### ⚙️ 4️⃣ Example of a Class in `src/org/company/ci/Utils.groovy`

```groovy
package org.company.ci

class Utils implements Serializable {
  def steps
  Utils(steps) { this.steps = steps }

  def dockerLogin() {
    steps.sh "aws ecr get-login-password | docker login --username AWS --password-stdin 1234567890.dkr.ecr.us-east-1.amazonaws.com"
  }
}
```

Usage in Jenkinsfile:

```groovy
@Library('shared-lib') _
def utils = new org.company.ci.Utils(this)
pipeline {
  agent any
  stages {
    stage('Login') {
      steps {
        script {
          utils.dockerLogin()
        }
      }
    }
  }
}
```

---

### ⚙️ 5️⃣ Load Library Dynamically (optional)

If you need to use a non-default branch:

```groovy
library identifier: 'shared-lib@feature/new-build', retriever: modernSCM([
  $class: 'GitSCMSource',
  remote: 'https://github.com/org/jenkins-shared-lib.git'
])
```

---

### 📋 Common Use Cases

| Use Case                 | Example Function                      |
| ------------------------ | ------------------------------------- |
| 🧱 Build Standardization | `buildApp()` → Docker/Maven/npm build |
| 🚀 Deployment Steps      | `deployToK8s()` → helm/kubectl deploy |
| 🔔 Notifications         | `notifySlack()`, `notifyTeams()`      |
| 🔍 Testing Utility       | `runTests()` with junit reports       |
| 🔐 Security Scans        | `runTrivyScan()`, `checkVulns()`      |
| 📦 Artifact Management   | `pushToNexus()`, `uploadToS3()`       |
| 🧰 Misc                  | `getGitCommit()`, `loadEnvConfig()`   |

---

### ✅ Best Practices

* 🧩 **Keep shared library small & modular** — organize by function (build, deploy, notify).
* 🧾 **Version control** the library in Git; tag stable releases (e.g., `v1.0.0`).
* 🔐 **Never store secrets** — pass via Jenkins Credentials or parameters.
* 🧰 **Use unit tests** (`jenkins-pipeline-unit` or `PipelineUnit`) for library Groovy functions.
* 🔄 **Use Semantic Versioning** (tag stable APIs; allow multiple versions in Jenkins).
* 📜 **Document** all functions in `README.md`.
* 🚦 **Avoid environment assumptions** — make steps portable (use Docker/K8s agents).
* 🧪 **Lint and test library Groovy syntax** before merging.
* 🧱 **Share across teams** to enforce standardized CI/CD pipelines.

---

### 💡 In short

A **Jenkins Shared Library** is a **versioned Groovy codebase** that stores reusable pipeline steps, functions, and classes shared across Jenkinsfiles.
It helps enforce CI/CD best practices, standardize pipelines, and eliminate code duplication.

👉 Think of it as **“Your team’s internal Jenkins plugin — written in Groovy.”** ✅

---
---

## Q: How to Run Parallel Stages in Jenkinsfile

### 🧠 Overview

Parallel stages let Jenkins **run multiple tasks simultaneously** — reducing build time and improving pipeline efficiency.
Commonly used for running **tests on different environments**, **platforms**, or **microservices** in parallel.

---

### ⚙️ 1️⃣ Declarative Pipeline (Recommended)

Simplest way — use `parallel` inside a `stage`.

```groovy
pipeline {
  agent any

  stages {
    stage('Parallel Tests') {
      parallel {
        stage('Unit Tests') {
          steps {
            echo "🧪 Running unit tests"
            sh 'mvn test -Dtype=unit'
          }
        }
        stage('Integration Tests') {
          steps {
            echo "🔗 Running integration tests"
            sh 'mvn verify -Dtype=integration'
          }
        }
        stage('Lint') {
          steps {
            echo "🧹 Running lint checks"
            sh 'npm run lint'
          }
        }
      }
    }

    stage('Deploy') {
      steps {
        echo "🚀 Deploying after all tests passed"
        sh './deploy.sh'
      }
    }
  }
}
```

✅ **Notes:**

* Each `stage` inside `parallel {}` runs **simultaneously** on available executors.
* If one branch fails, Jenkins **aborts other branches** (unless configured otherwise).
* All parallel stages must complete successfully before moving to the next sequential stage.

---

### ⚙️ 2️⃣ Scripted Pipeline — dynamic parallelization

Gives full control with Groovy maps and loops.

```groovy
node {
  stage('Dynamic Parallel Builds') {
    def tasks = [:]

    for (env in ['dev', 'staging', 'prod']) {
      tasks["Build-${env}"] = {
        echo "🚀 Deploying to ${env}"
        sh "./scripts/deploy.sh ${env}"
      }
    }

    parallel tasks
  }

  stage('Notify') {
    echo "✅ All parallel jobs completed successfully"
  }
}
```

✅ **Advantages:**

* Dynamically generate parallel branches (useful for test matrices).
* Good for large multi-environment or microservice builds.

---

### ⚙️ 3️⃣ Parallel Stages with Agent Isolation

Each branch can use its own agent, container, or label.

```groovy
pipeline {
  agent none
  stages {
    stage('Test Matrix') {
      parallel {
        stage('Python 3.9') {
          agent { docker { image 'python:3.9' } }
          steps { sh 'pytest tests/' }
        }
        stage('Python 3.11') {
          agent { docker { image 'python:3.11' } }
          steps { sh 'pytest tests/' }
        }
      }
    }
  }
}
```

✅ Great for build/test **matrix pipelines** — language, OS, or container variations.

---

### ⚙️ 4️⃣ Fail-Fast and Conditional Parallel Execution

#### 🔹 Fail Fast (abort all if one fails)

```groovy
stage('Parallel Builds') {
  failFast true
  parallel {
    stage('API Tests') { steps { sh './run-api-tests.sh' } }
    stage('UI Tests')  { steps { sh './run-ui-tests.sh' } }
  }
}
```

#### 🔹 Run conditionally

```groovy
stage('Parallel Deploy') {
  when { branch 'main' }
  parallel {
    stage('EU Deploy') { steps { sh './deploy-eu.sh' } }
    stage('US Deploy') { steps { sh './deploy-us.sh' } }
  }
}
```

---

### ⚙️ 5️⃣ Nested Parallelism (Advanced)

You can even nest parallel branches inside others.

```groovy
pipeline {
  agent any
  stages {
    stage('Parallel Matrix') {
      parallel {
        stage('Build') {
          steps { sh 'mvn package' }
        }
        stage('Tests') {
          parallel {
            stage('Unit') { steps { sh 'mvn test -Dtype=unit' } }
            stage('Integration') { steps { sh 'mvn test -Dtype=integration' } }
          }
        }
      }
    }
  }
}
```

🧩 Jenkins visualizes nested parallel branches nicely in Blue Ocean UI.

---

### ⚙️ 6️⃣ Handling Post-Actions for Each Parallel Branch

Each branch can have its own `post` block:

```groovy
stage('Parallel') {
  parallel {
    stage('Build A') {
      steps { sh './build-a.sh' }
      post {
        success { echo 'Build A passed ✅' }
        failure { echo 'Build A failed ❌' }
      }
    }
    stage('Build B') {
      steps { sh './build-b.sh' }
    }
  }
}
```

---

### 📋 When to Use Parallel Stages

| Scenario                  | Example                                             |
| ------------------------- | --------------------------------------------------- |
| 🧪 Run test suites faster | Unit, Integration, Functional tests                 |
| 🚀 Deploy multi-region    | `deploy-us`, `deploy-eu`, `deploy-apac`             |
| 🧱 Build multi-platform   | `linux`, `windows`, `macos`                         |
| 🧩 Build microservices    | Parallel Docker builds for `service-A`, `service-B` |
| 🧰 Matrix jobs            | Different Java/Python versions or OS                |

---

### ✅ Best Practices

* ⚙️ **Limit concurrency** — parallel stages consume one executor each.
* 💾 **Use dedicated agents** for resource-heavy tasks (e.g., `agent { label 'gpu' }`).
* 🧩 **Fail fast** when a branch fails (use `failFast true`).
* 🧾 **Aggregate reports** after parallel stages (e.g., JUnit merges).
* 🔐 **Avoid shared mutable state** (no writing to same workspace concurrently).
* 🧱 **Use `stash` / `unstash`** to share build outputs between branches.
* 🧰 **Monitor executor load** — scale Jenkins agents if many parallel jobs.
* 🧩 **Combine with matrix** for true CI test parallelism.

---

### 💡 In short

To run parallel stages:

> Use `parallel {}` in **Declarative Pipelines** or a map with `parallel()` in **Scripted Pipelines**.

✅ Each branch runs independently and simultaneously on available agents — ideal for speeding up testing, builds, and deployments.

👉 **Parallel = Faster + Scalable + Efficient CI/CD.** ⚡

---
---

## Q: How do you handle build dependencies between jobs?

### 🧠 Overview

Handle job dependencies by **orchestrating builds explicitly** (Pipeline `build` step), **passing/consuming artifacts**, or using Jenkins plugins (Parameterized Trigger, Copy Artifact, Build Pipeline). Prefer **Pipeline-as-Code** orchestration and artifact repositories for reproducible, auditable flows.

---

### ⚙️ Patterns & Examples

#### A) Orchestrate with a single Pipeline (recommended)

Keep orchestration in one `Jenkinsfile` — call independent jobs or run stages in order/parallel.

```groovy
// Declarative: trigger downstream job and wait (propagate failure)
pipeline {
  agent any
  stages {
    stage('Build Service A') {
      steps { sh './build-service-a.sh' }
    }
    stage('Publish Artifact A') {
      steps {
        // push to artifact repo (example)
        sh 'jfrog rt upload "dist/service-a/*.jar" libs/service-a/${BUILD_NUMBER}/'
      }
    }
    stage('Trigger Integration Tests') {
      steps {
        script {
          // call another job and wait for result
          def result = build job: 'integration-tests', parameters: [string(name:'ARTIFACT_VERSION', value: "${BUILD_NUMBER}")], wait: true
          echo "Integration build result: ${result.getResult()}"
        }
      }
    }
  }
}
```

#### B) Downstream job trigger (job-to-job)

Freestyle or Pipeline can trigger downstream jobs. Use `wait: true/false` and `propagate:false` to control blocking and failure propagation.

```groovy
// Scripted example: non-blocking trigger
build job: 'deploy-to-staging', parameters: [string(name:'VERSION', value:env.BUILD_NUMBER)], wait: false
```

#### C) Share artifacts (archive + copyArtifacts or Artifact repo)

* **Short-term / internal**: `archiveArtifacts` + `copyArtifacts` plugin

```groovy
// Producer
archiveArtifacts artifacts: 'target/*.jar', fingerprint: true

// Consumer job (Freestyle or Pipeline)
step([$class: 'CopyArtifact', projectName: 'producer-job', selector: [$class: 'SpecificBuildSelector', buildNumber: '123']])
```

* **Recommended**: push to **artifact repo** (Artifactory/Nexus/S3) and pull by downstream jobs:

```bash
jfrog rt upload "target/*.jar" libs/myapp/${BUILD_NUMBER}/
# downstream: jfrog rt download libs/myapp/${BUILD_NUMBER}/*.jar
```

#### D) Passing metadata (version, commit SHA)

Use parameters and fingerprints to tie artifacts to source:

```groovy
// Producer sets param or writes file with VERSION and GIT_COMMIT
sh "echo VERSION=${BUILD_NUMBER} > build/meta.properties"
archiveArtifacts 'build/meta.properties'

// Consumer reads it
def meta = readProperties file: 'meta.properties'
echo "Consuming version ${meta.VERSION} commit ${meta.GIT_COMMIT}"
```

#### E) Dependency graph plugins (visual)

* **Build Pipeline Plugin**, **Delivery Pipeline Plugin** or Blue Ocean to visualize flows. Useful for teams with many chained jobs.

#### F) Locks & Resource Coordination

Use `lock` step to avoid race conditions when multiple jobs need same resource (DB, deploy slot).

```groovy
pipeline {
  agent any
  stages {
    stage('Deploy') {
      steps {
        lock(resource: 'prod-deploy-slot') {
          sh './deploy-prod.sh'
        }
      }
    }
  }
}
```

---

### 📋 Decision Table (When to use what)

| Need                             | Recommended                              |
| -------------------------------- | ---------------------------------------- |
| Simple sequencing of tasks       | Single Pipeline (`stages`)               |
| Trigger independent job and wait | `build job: 'name', wait: true`          |
| Fire-and-forget                  | `build ... wait: false`                  |
| Share small outputs between jobs | `archiveArtifacts` + `copyArtifacts`     |
| Production-grade artifacts       | Artifact repo (Artifactory / Nexus / S3) |
| Prevent resource contention      | `lock` step / Lockable Resources plugin  |
| Visualize complex chains         | Build Pipeline / Blue Ocean              |

---

### ✅ Best Practices (practical & production-ready)

* 🔁 **Prefer one orchestrator pipeline** over chaining many freestyle jobs — easier to reason about and fewer race conditions.
* 📦 **Publish versioned artifacts** to an artifact repository; downstream jobs should fetch by version/digest.
* 🔐 **Pass minimal metadata** (version, commit SHA) as parameters; avoid passing secrets.
* 🧩 **Use `wait` + `propagate`** to control whether downstream failures should fail the upstream orchestrator.

  ```groovy
  // do not fail parent if downstream fails
  build job: 'non-critical-job', wait: true, propagate: false
  ```
* 🔒 **Use locks** to serialize access to shared resources (databases, deploy slots).
* 🧾 **Fingerprint** important artifacts to trace provenance (`archiveArtifacts fingerprint: true`).
* 🧰 **Keep artifact promotion separate from deploy**: build → publish → promote → deploy.
* 📣 **Notify owners** on failure with context: job name, build number, artifact version, logs URL.
* ♻️ **Avoid workspace sharing** between jobs; use stash/unstash only within same pipeline run.
* 🧪 **Test orchestrations in staging** and simulate failures to verify retry/propagation behavior.
* 🧾 **Document** expected inputs/outputs of each job (params, artifact paths).

---

### 🔧 Quick Troubleshooting Tips

* Downstream job not receiving artifact → confirm artifact published path and permissions.
* Orchestrator hangs on `build` → check `wait` flag, agent availability, or blocked executors.
* Race conditions → add `lock` or serialize builds.
* Lost provenance → add `archiveArtifacts fingerprint: true` and record commit SHA in metadata.

---

### 💡 In short

**Orchestrate with a Pipeline**, publish versioned artifacts to an artifact repo, pass minimal metadata (version/sha) as parameters, and use `build`/`wait`/`propagate`, `copyArtifacts`, and `lock` for coordination — keep orchestration declarative, reproducible, and auditable. ✅

---
---

## Q: How do you integrate Jenkins with Docker?

### 🧠 Overview

Integrating Jenkins with Docker lets you **build, test, and push container images** and/or run builds on **Docker-based agents**. Common patterns: run Jenkins *in* Docker, use Docker *on* Jenkins agents, or use Kubernetes to spawn ephemeral Docker-capable agents. Use `docker` pipeline steps (docker-workflow plugin) or containerized agents for reproducible CI.

---

### ⚙️ Typical integration patterns

| Pattern                                        |                                When to use | Notes                                                   |
| ---------------------------------------------- | -----------------------------------------: | ------------------------------------------------------- |
| **Jenkins in Docker**                          |          Simple installs, dev/test Jenkins | Mount persistent volume for `JENKINS_HOME`              |
| **Docker on Jenkins agent (bind socket)**      |                  Build images fast on host | Easy but exposes host via `docker.sock` (security risk) |
| **Docker-in-Docker (dind)**                    |         Isolated image builds in container | Needs privileged containers; consider alternatives      |
| **Remote Docker over TLS**                     |                Secure remote daemon access | Avoid `docker.sock` on master                           |
| **Kubernetes agents (pod with docker/kaniko)** |                    Scale, ephemeral builds | Use Kaniko/BuildKit for secure non-privileged builds    |
| **Build with Kaniko/BuildKit**                 | Build images without privileged containers | Recommended for Kubernetes CI runners                   |

---

### ⚙️ Examples / Commands

#### 1) Run Jenkins (master) in Docker (persistent home)

```bash
docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v /data/jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts
```

#### 2) Install required Jenkins plugins (recommended)

* `docker-workflow` (docker pipeline steps)
* `pipeline` / `workflow-aggregator`
* `kubernetes` (if using K8s agents)
* `credentials` / `plain-credentials` / cloud plugins (ECR/GCR)

Use `jenkins-plugin-cli` in Dockerfile:

```dockerfile
FROM jenkins/jenkins:lts
RUN jenkins-plugin-cli --plugins docker-workflow workflow-aggregator kubernetes credentials-binding
```

#### 3) Simple Declarative Jenkinsfile — build image + push

```groovy
pipeline {
  agent any
  environment {
    REGISTRY = '123456789.dkr.ecr.us-east-1.amazonaws.com'
    IMAGE    = "${REGISTRY}/myapp:${BUILD_NUMBER}"
  }
  stages {
    stage('Checkout') { steps { checkout scm } }

    stage('Build image') {
      steps {
        script {
          // uses docker CLI on agent
          def img = docker.build("${IMAGE}")
        }
      }
    }

    stage('Push image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'ecr-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh '''
            echo "$PASS" | docker login -u "$USER" --password-stdin 123456789.dkr.ecr.us-east-1.amazonaws.com
            docker push ${IMAGE}
          '''
        }
      }
    }
  }
}
```

#### 4) Declarative pipeline using `agent { docker { image ... } }` (run steps inside a container)

```groovy
pipeline {
  agent {
    docker { image 'maven:3.8-openjdk-17' args '-v /root/.m2:/root/.m2' }
  }
  stages {
    stage('Build') {
      steps { sh 'mvn -B -DskipTests package' }
    }
  }
}
```

#### 5) Scripted example with `docker.withRegistry()` and `docker.build()`:

```groovy
node {
  checkout scm
  def img = docker.build("myorg/myapp:${env.BUILD_NUMBER}")
  docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-creds') {
    img.push()
  }
}
```

#### 6) Use Kaniko on Kubernetes (no privileged)

Kubernetes pod runs kaniko to build & push:

```yaml
# manifest snippet for a Kaniko pod (example)
containers:
- name: kaniko
  image: gcr.io/kaniko-project/executor:latest
  args: ["--context=git://github.com/org/repo.git#refs/heads/main", "--destination=gcr.io/myproj/myapp:tag"]
  env:
    - name: GOOGLE_APPLICATION_CREDENTIALS
      value: /secret/sa-key.json
  volumeMounts:
    - name: gcr-key
      mountPath: /secret
volumes:
- name: gcr-key
  secret:
    secretName: gcr-key-secret
```

#### 7) Running docker builds on Jenkins agent (bind docker socket — simple but risky)

```bash
docker run -d --name jenkins-agent \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /home/jenkins/.docker:/home/jenkins/.docker \
  jenkins/agent:latest
```

> ⚠️ This exposes host root-equivalent privileges to the container. Prefer remote TLS or Kaniko.

---

### 🔐 Security & Operational Notes

* **Avoid mounting `/var/run/docker.sock` on the Jenkins controller.** It grants root-equivalent access. If you must, limit to dedicated build agents.
* **Prefer ephemeral agents** (Kubernetes pods, Docker containers) so builds run isolated and are cleaned up.
* **Use remote Docker over TLS** if you need host daemon access without binding socket: configure TLS certs and point `DOCKER_HOST=tcp://docker-host:2376`.
* **Use Kaniko / BuildKit / img / buildx** for non-privileged, secure builds — especially on K8s.
* **Store registry credentials in Jenkins Credentials Store** and use `withCredentials` or `docker.withRegistry()` — never hard-code secrets.
* **Scan images** before pushing (`trivy`, `clair`, `anchore`) in your pipeline stage.
* **Tag images immutably** (use BUILD_NUMBER, commit SHA) and push by digest for reproducible deployments.

---

### ✅ Best Practices (practical)

* ✅ **Pipeline-as-code**: put all Docker build/push logic in `Jenkinsfile`.
* ✅ **Use ephemeral agents** (K8s or Docker) with labels to schedule Docker-capable nodes.
* ✅ **Push artifacts to registry** (ECR/GCR/Artifactory) rather than keeping images only on Jenkins agents.
* ✅ **Use least-privilege credentials** for registries and rotate them regularly.
* ✅ **Scan and sign images** before deployment. Use SBOMs for supply-chain auditing.
* ✅ **Cache layers & use multi-stage builds** to reduce build time and image size.
* ✅ **Avoid docker.sock on master** — limit to controlled build agents or use remote TLS.
* ✅ **Use BuildKit or buildx** for advanced caching and multi-platform builds.
* ✅ **Monitor agent resource usage**; scale nodes/agents to meet parallel build demand.

---

### 💡 In short

Integrate Jenkins & Docker by either:

* Running build steps with Docker CLI on agents (`docker.build`, `docker.push`),
* Running stages inside container agents (`agent { docker { image ... } }`), or
* Using Kubernetes + Kaniko/BuildKit for secure, scalable builds.
  **Keep secrets in Jenkins Credentials, prefer ephemeral agents, avoid exposing `docker.sock` on the controller, and scan/push images to a registry.** ✅

---
---

## Q: How do you integrate Jenkins with Kubernetes?

### 🧠 Overview

Integrating Jenkins with Kubernetes lets you **run Jenkins itself on K8s** and/or **spawn ephemeral build agents (pods)** on-demand. This provides scalable, isolated, reproducible CI/CD runners and simplifies resource management for builds, tests, and container image creation.

---

### ⚙️ Integration Patterns (pick one or combine)

| Pattern                           | Description                                                                    | When to use                                       |
| --------------------------------- | ------------------------------------------------------------------------------ | ------------------------------------------------- |
| **Jenkins on Kubernetes**         | Run Jenkins controller as a Deployment/StatefulSet with PVC for `JENKINS_HOME` | Kubernetes-native Jenkins deployment (HA options) |
| **Kubernetes agents (preferred)** | Use **Kubernetes Plugin** to create ephemeral pods per build (pod templates)   | Scale agents automatically, isolate builds        |
| **Kaniko/BuildKit on K8s**        | Build container images inside pods without privileged Docker daemon            | Secure image builds in cluster                    |
| **Remote Docker/daemon-in-dind**  | Use dind pods (less secure)                                                    | Legacy flows only, avoid if possible              |

---

### ⚙️ Quick setup steps (helm + plugin + service account)

#### 1) Install Jenkins with Helm (stable approach)

```bash
# add repo
helm repo add jenkins https://charts.jenkins.io
helm repo update

# install (example values: persistent storage, ingress)
helm install jenkins jenkins/jenkins \
  --namespace jenkins --create-namespace \
  --set controller.serviceType=ClusterIP \
  --set persistence.size=50Gi \
  --set controller.ingress.enabled=true \
  --set controller.ingress.hostName=jenkins.example.com
```

#### 2) Create Kubernetes service account & RBAC for Jenkins controller to spawn pods

```bash
kubectl create namespace jenkins

# service account
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jenkins
  namespace: jenkins
EOF

# minimal RBAC for pod creation (adjust to least privilege)
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: jenkins-pod-creator
rules:
- apiGroups: [""]
  resources: ["pods","pods/exec","services","endpoints","persistentvolumeclaims"]
  verbs: ["get","list","watch","create","delete","patch","update"]
- apiGroups: ["apps"]
  resources: ["deployments","replicasets"]
  verbs: ["get","list","watch"]
- apiGroups: ["batch"]
  resources: ["jobs","cronjobs"]
  verbs: ["create","get","list","watch","delete"]
EOF

kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: jenkins-pod-creator-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: jenkins-pod-creator
subjects:
- kind: ServiceAccount
  name: jenkins
  namespace: jenkins
EOF
```

#### 3) Configure the Kubernetes Plugin in Jenkins

* Install **Kubernetes**, **Kubernetes Credentials Binding**, **Kubernetes CLI**, and **Pipeline** plugins.
* In **Manage Jenkins → Configure System → Cloud → Kubernetes**:

  * Kubernetes URL: (leave blank for in-cluster)
  * Kubernetes Namespace: `jenkins`
  * Credentials: create a **Kubernetes service account token** (or use in-cluster service account)
  * Pod Retention / YAML Templates: add pod templates or leave dynamic

---

### ⚙️ Example: PodTemplate YAML (for Jenkins Kubernetes Plugin)

You can store this YAML inside the plugin UI or use declarative Jenkinsfile `podTemplate` blocks.

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins: slave
spec:
  containers:
  - name: jnlp
    image: jenkins/inbound-agent:latest
    args: ['$(JENKINS_SECRET)', '$(JENKINS_NAME)']
  - name: docker
    image: docker:24.0-dind
    securityContext:
      privileged: true            # avoid if possible; prefer Kaniko
    volumeMounts:
    - name: dockersock
      mountPath: /var/run/docker.sock
  - name: kaniko
    image: gcr.io/kaniko-project/executor:latest
    volumeMounts:
    - name: kaniko-secret
      mountPath: /secret
  volumes:
  - name: dockersock
    hostPath:
      path: /var/run/docker.sock
  - name: kaniko-secret
    secret:
      secretName: registry-creds
```

> ⚠️ `privileged` / docker.sock are security risks — prefer **Kaniko/BuildKit** or remote TLS Docker.

---

### ⚙️ Jenkinsfile examples

#### A) Declarative — run steps inside containers (Kubernetes agent with inline YAML)

```groovy
pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: maven
    image: maven:3.8.6-openjdk-17
    command:
    - cat
    tty: true
  - name: docker
    image: docker:24.0
    command:
    - cat
    tty: true
"""
    }
  }

  stages {
    stage('Checkout') {
      steps {
        container('maven') { checkout scm }
      }
    }

    stage('Build') {
      steps {
        container('maven') { sh 'mvn -B -DskipTests package' }
      }
    }

    stage('Build Image (kaniko recommended)') {
      steps {
        // Use kaniko container or a separate job to build & push images
        container('docker') {
          sh 'docker build -t myrepo/myapp:${BUILD_NUMBER} .'
          // docker push ... (requires credential management)
        }
      }
    }
  }
}
```

#### B) Scripted — dynamic parallel agents

```groovy
node('master') {
  def envs = ['dev','staging','prod']
  def tasks = [:]
  for (e in envs) {
    def envName = e
    tasks["deploy-${envName}"] = {
      podTemplate(label: "deploy-${envName}", containers: [
        containerTemplate(name: 'kubectl', image: 'bitnami/kubectl:latest', command: 'cat', ttyEnabled: true)
      ]) {
        node("deploy-${envName}") {
          container('kubectl') { sh "kubectl apply -f k8s/${envName}-deployment.yaml" }
        }
      }
    }
  }
  parallel tasks
}
```

---

### 🔐 Security & Best Practices ✅

* **Least privilege RBAC**: scope Jenkins SA to only needed resources.
* **Prefer Kaniko / BuildKit / img** for image builds — no privileged containers.
* **Use Kubernetes Secrets / Secret Store CSI** to mount registry credentials; do not put secrets in Jenkinsfile.
* **Ephemeral agents**: configure short pod retention (e.g., `Never` or `OnFailure`) to avoid stale pods.
* **Use podResourceLimits** to avoid noisy neighbors (CPU/memory requests & limits).
* **Network policies**: restrict agent pod egress to only required registries/APIs.
* **PodSecurityContext / PSAs**: enforce Pod Security Admission (non-root, no privileged) for cluster safety.
* **Monitor & autoscale**: use Cluster Autoscaler or Jenkins agent autoscaling to handle spikes.

---

### 📋 CI/CD + K8s operational tips

* **Separate build & deploy**: build images in dedicated pipeline, push to registry, then deploy by referencing image tag/digest.
* **Artifact provenance**: tag images with `git commit SHA` + `BUILD_NUMBER` and store metadata in artifact repo.
* **Use `stash/unstash` only within same pipeline**; for cross-job artifacts, publish to S3/Artifactory.
* **Use readiness/liveness probes** for Jenkins controller and agent health.
* **Back up `JENKINS_HOME`** (PVC snapshots) and track installed plugins (`plugins.txt`) for restore.
* **Use Helm** for reproducible Jenkins installs; store Helm values in Git (helmfile/Terraform).

---

### ✅ Troubleshooting checklist

* Pod not launching: check Jenkins logs + Kubernetes events (`kubectl -n jenkins get events`).
* Agent connects then disconnects: check JNLP image version, network egress, and service account token expiry.
* Image-pull errors: verify imagePullSecrets and registry access.
* Builds hang: ensure sufficient executors and that pod templates specify resources.

---

### 💡 In short

Run Jenkins on Kubernetes and use the **Kubernetes Plugin** to spawn ephemeral agent pods (preferred). Use **Kaniko/BuildKit** for secure image builds, apply least-privilege RBAC, store secrets in Kubernetes Secrets or external secret managers, and manage Jenkins with **Helm** for reproducible installs. ✅

---

---

## Q: How do you manage Jenkins configuration as code?

### 🧠 Overview

Manage Jenkins configuration as code by storing controller config, jobs, plugins, and bootstrap scripts in source control and applying them automatically — typically using **Jenkins Configuration as Code (JCasC)** + **plugin manager**, **Job DSL / seed jobs**, **Docker/Helm images**, and **credential/secret integrations**. This makes Jenkins reproducible, auditable, and versioned.

---

### ⚙️ Core Components & Flow

* **JCasC (`jenkins.yaml`)** → declarative Jenkins system configuration (security, clouds, credentials, tool installations, views).
* **Plugins list (`plugins.txt`)** → reproducible plugin installation via `jenkins-plugin-cli`.
* **Job DSL or pipeline-as-code** → create jobs programmatically or store `Jenkinsfile` per repo (multibranch).
* **Groovy init scripts** (`init.groovy.d`) → one-time bootstrap logic.
* **Image / Helm chart** → package controller + JCasC + plugins into immutable artifact for deployment.
* **Secrets** → stored in external stores (Vault, K8s Secrets, Credentials Provider) and referenced, not committed.
* **CI/CD** → validate configs (lint, dry-run), run tests, and deploy via GitOps.

---

### ⚙️ Examples / Commands

#### 1) Minimal `jenkins.yaml` (JCasC)

```yaml
jenkins:
  systemMessage: "Jenkins (CICD) - managed via JCasC"
  numExecutors: 2

securityRealm:
  local:
    allowsSignup: false
    users:
      - id: "admin"
        password: "${ADMIN_PASSWORD}"   # injected at runtime (secret)

authorizationStrategy:
  loggedInUsersCanDoAnything:
    allowAnonymousRead: false

unclassified:
  location:
    adminAddress: "devops@example.com"
```

Place this file and tell JCasC where to load it (see Docker/Helm examples).

---

#### 2) `plugins.txt` for plugin manager

```
workflow-aggregator:2.6
kubernetes:1.37.6
configuration-as-code:1.55
credentials-binding:1.27
job-dsl:1.77
```

Install during image build or bootstrap:

```dockerfile
FROM jenkins/jenkins:lts
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
COPY casc_configs/jenkins.yaml /var/jenkins_home/casc_configs/jenkins.yaml
ENV CASC_JENKINS_CONFIG=/var/jenkins_home/casc_configs/jenkins.yaml
```

---

#### 3) Helm values snippet (Jenkins chart) to enable JCasC

```yaml
controller:
  JCasC:
    configScripts:
      jenkins.yaml: |
        jenkins:
          systemMessage: "Jenkins via JCasC (Helm)"
  installPlugins:
    - kubernetes:1.37.6
    - configuration-as-code:1.55
  additionalInitContainers: []
  javaOpts: "-Djenkins.install.runSetupWizard=false"
```

Install:

```bash
helm repo add jenkins https://charts.jenkins.io
helm upgrade --install jenkins jenkins/jenkins -f values.yaml --namespace jenkins --create-namespace
```

---

#### 4) Job DSL seed job (create jobs programmatically)

```groovy
// seedJob.groovy
job('my-repo-build') {
  description('Generated by Job DSL')
  scm {
    git('git@github.com:org/my-repo.git', 'main')
  }
  steps {
    shell('mvn -B -DskipTests package')
  }
}
```

Seed run (run via Job DSL plugin): upload DSL script, run seed job — jobs are generated and stored as config.xml (or manage via Job DSL plugin source control).

---

#### 5) Groovy init script (one-time bootstrap)

```groovy
// init.groovy.d/create-admin.groovy
import jenkins.model.*
def instance = Jenkins.getInstance()
if (instance.getSecurityRealm() == null) {
  println "Configuring default security..."
  // create admin user or other bootstrap tasks
}
```

Place in `/var/jenkins_home/init.groovy.d/` (image or mount).

---

#### 6) Credential handling (reference, not commit)

* Use JCasC to *define placeholders* and inject secrets via environment / secret mounts.
* Vault / K8s External Secrets + Credentials Provider plugin for dynamic injection.
  Example: in JCasC reference `${VAULT_DB_PASS}` via environment variable mapped at runtime.

---

### 📋 Validation & CI (recommended)

* **Lint JCasC** using Jenkins' declarative linter or `casc-cli` (community tools).
* **Test job DSL** with `Job DSL Unit` or `jenkins-pipeline-unit`.
* **Dry-run / smoke deploy** in ephemeral cluster/namespace before production upgrade.
* Example pipeline step to validate plugin list + JCasC:

```bash
# plugin check
jenkins-plugin-cli --help
# test JCasC by starting a container with CASC_JENKINS_CONFIG pointing to your file and ensure no errors in logs
docker run --rm -e CASC_JENKINS_CONFIG=/config/jenkins.yaml -v $(pwd)/casc:/config jenkins/jenkins:lts
```

---

### ✅ Best Practices

* 🔒 **Keep secrets out of Git** — inject at runtime via Vault / K8s Secrets / CI variables.
* 📦 **Build immutable Jenkins artifacts** (Docker images or Helm values) including `plugins.txt` and `jenkins.yaml`.
* 📚 **Version everything**: `jenkins.yaml`, `plugins.txt`, Job DSL scripts, and init scripts — tag releases.
* 🔁 **Prefer Multibranch Pipelines + Jenkinsfile** for repo jobs; minimize generated jobs where possible.
* 🧪 **Validate in CI**: lint JCasC, unit-test DSL, smoke deploy to staging cluster.
* 🔁 **Use GitOps**: treat changes as PRs, review, and let CI/CD roll out configuration changes.
* 🧾 **Pin plugin versions** in `plugins.txt` to avoid surprising breaks.
* 🧰 **Keep bootstrap idempotent** — init scripts should be safe to run multiple times.
* 🧩 **Document recovery** steps: how to rebuild Jenkins from repo + how to restore `JENKINS_HOME` backups.
* ♻️ **Automate backups** of `JENKINS_HOME` (or its essential components) and store plugin manifests separately.
* 🔐 **Limit permissions** for credentials created by config-as-code; prefer dynamic short-lived credentials.

---

### 📋 Quick Reference Table

| Area          | Tool / File                             | Purpose                          |
| ------------- | --------------------------------------- | -------------------------------- |
| System config | JCasC (`jenkins.yaml`)                  | Declarative controller config    |
| Plugins       | `plugins.txt` + `jenkins-plugin-cli`    | Reproducible plugin install      |
| Jobs          | Multibranch Jenkinsfile / Job DSL       | Job definitions as code          |
| Bootstrap     | `init.groovy.d`                         | One-time scripted initialization |
| Image deploy  | Dockerfile / Helm values                | Immutable controller deployment  |
| Secrets       | Vault / K8s Secret / Credentials plugin | Secure secret injection          |
| Validation    | lint/unit tests                         | CI checks before apply           |

---

### 💡 In short

Manage Jenkins as code by combining **JCasC** for controller configuration, **plugins.txt** for plugins, **Job DSL / Jenkinsfile** for jobs, and **immutable images/Helm** for deployment. Keep secrets out of Git, validate config in CI, pin plugin versions, and deploy changes via GitOps for reproducible, auditable Jenkins instances. ✅

---

---

## Q: How do you handle pipeline approvals or manual steps?

### 🧠 Overview

Use **Jenkins `input` steps** (Declarative or Scripted) for manual gates, restrict approvers via `submitter`, add `timeout` to avoid indefinite hangs, and combine with notifications, RBAC, and audit logs. Prefer automated gates (PR approvals, policy checks) over manual steps where possible.

---

### ⚙️ Examples / Commands

#### 1) Declarative pipeline — manual approval for production deploy

```groovy
pipeline {
  agent any
  stages {
    stage('Build') { steps { sh 'make build' } }
    stage('Tests') { steps { sh 'make test' } }
    stage('Approve Deploy to Prod') {
      steps {
        timeout(time: 2, unit: 'HOURS') {
          input message: "Approve deploy to production?", ok: "Deploy",
                submitter: "alice,bob,devops-leads", 
                submitterParameter: 'APPROVER'
        }
      }
    }
    stage('Deploy to Prod') { steps { sh './deploy-prod.sh' } }
  }
  post { always { echo "Approved by: ${params.APPROVER ?: env.APPROVER ?: 'n/a'}" } }
}
```

* `submitter` limits who can click “Deploy”.
* `timeout` prevents pipeline from blocking forever.
* `submitterParameter` captures approver identity for audit.

---

#### 2) Scripted pipeline — manual step with input result processing

```groovy
node {
  stage('Build') { sh 'make build' }
  stage('Tests') { sh 'make test' }

  stage('Approval') {
    timeout(time:30, unit:'MINUTES') {
      def user = input id: 'Proceed', message: 'Approve to promote?', parameters: [
        string(name: 'REASON', defaultValue: 'Verified', description: 'Reason for approval')
      ], submitter: 'team-lead'
      echo "Approved by ${user}"
    }
  }

  stage('Deploy') { sh './deploy.sh' }
}
```

---

#### 3) Approvals with metadata & parameters (approve + choose version)

```groovy
input message: 'Approve production deploy?',
      parameters: [choice(name:'VERSION', choices: "1.0.1\n1.0.2\n1.0.3", description:'Select version')],
      submitter: 'release-managers',
      ok: 'Promote'
```

---

#### 4) Automate notification to approvers (Slack + input)

```groovy
post {
  unstable { slackSend channel:'#oncall', message:"Build #${BUILD_NUMBER} needs approval: ${env.BUILD_URL}" }
}
```

* Notify approvers so they can act quickly; Blue Ocean shows interactive approve button.

---

### 📋 Alternatives & Integrations

|                                 Pattern | When to use                                                          |
| --------------------------------------: | -------------------------------------------------------------------- |
|                  `input` step (Jenkins) | Simple manual approvals inside pipeline                              |
| PR / Git host approvals (GitHub/GitLab) | Use branch protection & required reviewers — keep pipeline automated |
|     External approval (ServiceNow/ITSM) | Enterprise change control workflows (use REST API)                   |
|             `Lockable Resources` plugin | Gate shared resource usage (DB, deploy slot)                         |
|   `Pipeline: Multibranch + Code Owners` | Auto-assign approvers and require code-owner review before merge     |
|                        Approval via API | Programmatic approval (replay or approve via Jenkins API with auth)  |

---

### ✅ Best Practices

* 🔒 **Restrict approvers** using `submitter` to a small list or group.
* ⏱️ **Always use `timeout`** to avoid blocked executors.
* 🧾 **Record approver + reason** (`submitterParameter`) for audit and postmortems.
* 🔁 **Prefer pull-request approvals** or automated checks (security, policies) for most gates — manual only when required.
* 🔐 **Enforce RBAC** so only authorized users can approve (use Role-Based Authorization Strategy).
* 🔔 **Notify approvers** (Slack/email) with job URL and context to speed decisions.
* ♻️ **Make approvals idempotent** and safe to re-run (so repeated approvals don’t cause inconsistent state).
* 🧹 **Fail/rollback on timeout or rejection**; document recovery steps.
* 🧰 **Integrate with ITSM** for formal change-control if your org requires audit/approval workflows.
* 📦 **Keep manual steps near deploy boundary** — do tests/packaging automatically before the manual gate.

---

### 💡 In short

Use Jenkins `input` (with `submitter`, `submitterParameter`, and `timeout`) for manual approvals inside pipelines; prefer automated PR/quality gates where possible, notify approvers, and always audit who approved and why. ✅

---

---

## Q: How to trigger a Jenkins pipeline from another pipeline?

### 🧠 Overview

You can invoke one Jenkins pipeline from another via the **`build` step** (native), **REST API**, **webhooks**, or **shared libraries**. Choose between **synchronous** (wait + get result) and **asynchronous** (fire-and-forget) invocation, pass parameters and artifact metadata, and prefer artifact registries over copying workspaces.

---

### ⚙️ Methods & Examples

#### 1) Native Pipeline call — **`build` step** (recommended)

* **Synchronous** (wait & fail parent on child failure):

```groovy
// Declarative (inside steps → script{})
pipeline {
  agent any
  stages {
    stage('Trigger downstream and wait') {
      steps {
        script {
          def result = build job: 'downstream-job',
                             parameters: [string(name:'VERSION', value: '1.2.3')],
                             wait: true,      // wait for completion
                             propagate: true  // fail if child failed
          echo "Downstream result: ${result.getResult()}"
        }
      }
    }
  }
}
```

* **Asynchronous** (fire & forget):

```groovy
script {
  build job: 'downstream-job',
        parameters: [string(name:'VERSION', value: "${env.BUILD_NUMBER}")],
        wait: false  // do not block
}
```

* **Synchronous but don’t fail parent if child fails**:

```groovy
script {
  def b = build job: 'downstream-job', wait: true, propagate: false
  echo "Downstream status: ${b.getResult()}"
}
```

---

#### 2) Declarative example with `build` in a `script` block

```groovy
pipeline {
  agent any
  stages {
    stage('Orchestrate') {
      steps {
        script {
          build job: "integration-tests",
                parameters: [
                  string(name: 'ARTIFACT_TAG', value: "myapp:${env.BUILD_NUMBER}")
                ],
                wait: true
        }
      }
    }
  }
}
```

---

#### 3) Trigger via Jenkins REST API (useful for external pipelines or cross-installation)

* **Get crumb** (CSRF):

```bash
CRUMB=$(curl -s -u "jenkins_user:APITOKEN" "https://jenkins.example.com/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")
```

* **Trigger build with parameters**:

```bash
curl -X POST -u "jenkins_user:APITOKEN" -H "$CRUMB" \
  "https://jenkins.example.com/job/downstream-job/buildWithParameters" \
  --data-urlencode "VERSION=1.2.3"
```

> 🔐 Store `APITOKEN` in Jenkins Credentials and use credential-binding in calling pipeline.

---

#### 4) Trigger multibranch / organization pipelines

* For **multibranch** jobs, trigger the branch job name:
  `job: 'org-repo/feature-branch'` or use the full job path:

```groovy
build job: 'org-repo/PR-123', parameters: [...], wait: true
```

* Or trigger via Git push to that branch (webhook-driven).

---

#### 5) Trigger using shared library helper (DRY)

```groovy
// vars/triggerJob.groovy (shared lib)
def call(String jobName, Map params = [:], boolean wait = true) {
  def ps = params.collect{ k,v -> string(name:k, value:v) }
  build job: jobName, parameters: ps, wait: wait
}
```

```groovy
@Library('ci-lib') _
pipeline { ... 
  steps { script { triggerJob('downstream-job', [VERSION:'1.2.3']) } }
}
```

---

#### 6) Trigger and pass artifacts / provenance (recommended pattern)

1. **Producer**: publish artifact to artifact repo (Artifactory/S3/ECR) and record metadata (commit SHA, version).
2. **Orchestrator**: trigger downstream with parameters containing artifact location:

```groovy
build job: 'deploy-job',
      parameters: [string(name:'ARTIFACT_URL', value: 's3://my-bucket/app/1.2.3/app.jar')]
```

3. **Consumer**: downloads artifact in its own job.

---

### 📋 Comparison Table

| Method                           |       Wait/block      |    Failure behaviour    | Use-case                                         |
| -------------------------------- | :-------------------: | :---------------------: | ------------------------------------------------ |
| `build` step                     | Yes/No (configurable) |   propagate true/false  | Best inside Jenkins for orchestration            |
| REST API (`buildWithParameters`) |  No (caller controls) | Caller sees HTTP result | Trigger across installations or from external CI |
| Webhook / Git push               |           No          |  Depends on job config  | Trigger branch builds via SCM events             |
| Shared library                   |  Yes/No (wraps above) |  Same as wrapped method | Reuse logic + RBAC + audit                       |

---

### ✅ Best Practices

* 🔁 **Prefer one orchestrator** pipeline where possible to avoid complex cross-job coupling.
* 📦 **Pass artifact references (URLs/digests)**, not workspace files. Use an artifact repository for handoff.
* 🔒 **Use credentials** (Credentials Store) when calling REST API — don’t hardcode tokens.
* ⚖️ **Control failure semantics**: use `propagate:false` when you want non-blocking downstreams.
* ⏱️ **Limit concurrency & queue depth** to avoid executor starvation when triggering many jobs.
* 🧾 **Record provenance** (commit SHA, artifact URL) as parameters for traceability.
* 🧪 **Test in staging** before production: validate parameter schemas and timeout behavior.
* 📣 **Notify** stakeholders with child job URL and result on failure/success.
* ♻️ **Use shared library** wrappers to standardize how jobs are triggered (backoff, retries, logging).

---

### ⚙️ Troubleshooting tips

* `build` fails with permissions → check caller has `Job/Build` permission on target job.
* Multi-branch name mismatch → use exact job path or trigger by branch (e.g., `org/repo/branch`).
* REST triggers 403 → missing or invalid crumb / API token.
* Long blocking waits → use `wait: false` or increase timeout and monitor executor usage.

---

### 💡 In short

Use Jenkins’ native `build` step to call another pipeline (synchronous or async) and pass parameters + artifact URLs; use REST API when calling across systems. Prefer passing artifact references, control failure propagation with `propagate`, secure tokens via Credentials, and centralize trigger logic in a shared library for consistency. ✅

---
---

## Q: How to monitor Jenkins health and jobs?

### 🧠 Overview

Monitor Jenkins by tracking **controller health (CPU, memory, queue, executors)**, **job/build status**, and **agent availability** using built-in monitoring, metrics plugins, logs, and external observability tools (Prometheus, Grafana, ELK).
Goal → detect failures early, analyze trends, and ensure CI/CD reliability.

---

### ⚙️ Key Monitoring Areas

| Category                       | What to Watch                               | Tools / Metrics                             |
| ------------------------------ | ------------------------------------------- | ------------------------------------------- |
| 🧱 **Controller Health**       | CPU, heap, GC, disk, response time          | Prometheus, Metrics plugin, JVM logs        |
| ⚙️ **Build Queue & Executors** | Queued builds, executor saturation          | Jenkins `/computer` API, Prometheus metrics |
| 🧩 **Agents**                  | Agent online/offline state, disconnections  | Node Monitor plugin, Alerts                 |
| 🧰 **Jobs / Pipelines**        | Success/failure rate, duration trends       | Prometheus, Build History Analyzer          |
| 📦 **Plugins & Updates**       | Plugin errors, outdated versions            | Plugin Manager, Update Center               |
| 🔐 **Security**                | Failed logins, admin changes, CSRF warnings | Audit Trail, Log Parser, Security logs      |
| 📡 **Integrations**            | SCM polling delays, webhook failures        | SCM Event Logs, Webhook delivery dashboards |

---

### ⚙️ 1️⃣ Built-in Jenkins Views

#### 🔹 **Dashboard View Plugin**

Create custom dashboards showing:

* Build trends, test trends
* Failed builds last 24h
* Agent status, queue length

> 📍 *Manage Jenkins → Manage Plugins → Dashboard View → New View → “Dashboard”.*

#### 🔹 **Manage Jenkins → System Information / System Log**

* JVM info, environment variables, thread dumps
* Use `/systemInfo` and `/threadDump` endpoints for automation.

#### 🔹 **Job Trend Graphs**

Each job shows historical success/failure, duration, and test result trends.

---

### ⚙️ 2️⃣ Jenkins Monitoring Plugins

| Plugin                                | Purpose                                          |
| ------------------------------------- | ------------------------------------------------ |
| **Metrics Plugin**                    | Exposes JVM + build metrics (JMX or Prometheus)  |
| **Prometheus Plugin**                 | Native Prometheus metrics endpoint `/prometheus` |
| **Monitoring Plugin (PerfDashboard)** | UI graphs for memory, GC, threads                |
| **Build Monitor View**                | Visual, color-coded view of job status           |
| **Audit Trail Plugin**                | Track config and credential changes              |
| **Health Advisor by CloudBees**       | Auto health checks + recommendations             |
| **Log Parser Plugin**                 | Define log rules → highlight issues in builds    |
| **Test Result Analyzer**              | Historical test trends                           |

---

### ⚙️ 3️⃣ Prometheus + Grafana Integration (recommended)

**Install plugin:**

> `Prometheus metrics plugin`

**Access endpoint:**

```
https://jenkins.example.com/prometheus
```

**Key exported metrics:**

| Metric                             | Meaning                    |
| ---------------------------------- | -------------------------- |
| `jenkins_builds_last_build_result` | 0=SUCCESS, 1=FAILURE, etc. |
| `jenkins_queue_size_value`         | Current queue length       |
| `jenkins_nodes_offline_value`      | Offline agents count       |
| `jenkins_executor_count_value`     | Active executors           |
| `jenkins_job_duration_seconds`     | Build duration histogram   |

**Example Prometheus alert rules:**

```yaml
- alert: JenkinsControllerHighCPU
  expr: process_cpu_usage > 0.8
  for: 5m
  labels: { severity: warning }
  annotations:
    summary: "Jenkins CPU usage high"

- alert: JenkinsQueueBlocked
  expr: jenkins_queue_size_value > 20
  for: 10m
  labels: { severity: critical }
```

**Grafana Dashboards:**
Use official dashboards:
👉 [Grafana.com Dashboard ID 9964 or 13364](https://grafana.com/grafana/dashboards/)

---

### ⚙️ 4️⃣ Log Management — ELK / Loki / CloudWatch

#### 🔹 Filebeat/Fluentd → ELK Stack

* Collect Jenkins logs (`/var/log/jenkins/jenkins.log`, build logs under `jobs/`)
* Send to Elasticsearch for analysis.
* Example Filebeat config:

  ```yaml
  filebeat.inputs:
  - type: log
    paths:
      - /var/log/jenkins/jenkins.log
      - /var/lib/jenkins/jobs/*/builds/*/log
    fields:
      service: jenkins
  ```

#### 🔹 AWS / GCP Cloud Logging

Send logs to CloudWatch Logs / Stackdriver using sidecar container or plugin.

#### 🔹 Loki / Promtail (lightweight)

Use Promtail → Loki → Grafana for centralized log search.

---

### ⚙️ 5️⃣ Alerts & Notifications

#### 🔹 Slack / Teams

Use `slackSend` or `office365ConnectorSend` in pipelines:

```groovy
post {
  failure {
    slackSend channel: '#ci-alerts', message: "❌ Build #${BUILD_NUMBER} failed: ${env.JOB_NAME} (${env.BUILD_URL})"
  }
}
```

#### 🔹 Email-ext Plugin

Set up “Failed after X consecutive builds” triggers with formatted summaries.

#### 🔹 Prometheus → Alertmanager → PagerDuty / Opsgenie

Automate CI/CD health alerts into existing NOC tools.

---

### ⚙️ 6️⃣ API & CLI Monitoring

| Command / Endpoint               | Description                           |
| -------------------------------- | ------------------------------------- |
| `/computer/api/json`             | Agent state, executors, offline nodes |
| `/queue/api/json`                | Queued builds info                    |
| `/metrics` or `/prometheus`      | Detailed metrics                      |
| `/job/<name>/lastBuild/api/json` | Build metadata                        |
| `jenkins-cli list-jobs`          | CLI listing                           |
| `jenkins-cli list-builds <job>`  | Build history                         |
| `jenkins-cli who-am-i`           | Auth test                             |

Example health probe (for Kubernetes liveness/readiness):

```bash
curl -sf http://jenkins:8080/login || exit 1
```

---

### ✅ Best Practices (production-grade monitoring)

* 📊 **Use Prometheus + Grafana** as the main metrics and dashboard stack.
* 🧠 **Set alerts for queue growth**, slow builds, high memory, and offline agents.
* 🧾 **Enable audit trail** for config and credential changes.
* 🔐 **Monitor plugin updates & vulnerabilities** monthly.
* 🧩 **Separate logs** (controller vs. build logs) — centralize via ELK or Loki.
* 🧰 **Integrate build results into Slack / Teams** for fast triage.
* 🚦 **Use readiness/liveness probes** in K8s to auto-recover crashed controllers.
* 🧱 **Collect metrics at job granularity** — average duration, success rate, flakiness.
* 🔁 **Regularly back up `JENKINS_HOME`** and test restore procedures.
* 🧪 **Track resource usage per build** (CPU/mem) using node exporter or cAdvisor.

---

### 💡 In short

Monitor Jenkins via **Prometheus plugin + Grafana dashboards** for metrics, **ELK/Loki** for logs, and **Slack/email alerts** for job failures.
Watch controller load, queue, agent health, and build success trends — automate recovery and alerting for a reliable CI/CD environment. ✅

---

---

## Q: How to handle artifacts across builds?

### 🧠 Overview

Treat artifacts as **immutable, versioned, and authoritative build outputs** — store them in an artifact repository (Artifactory/Nexus/ECR/S3), record provenance (commit SHA, build number), and promote (not overwrite) between stages. Use checksums, signatures, and lifecycle policies to keep builds reproducible and storage manageable.

---

### ⚙️ Key concepts

* **Publish, don’t copy** — CI uploads artifacts to a repo; downstream jobs download by version/digest. ✅
* **Immutability & versioning** — use version numbers or digest (`@sha256`) to reference artifacts. 🔒
* **Provenance** — record `GIT_COMMIT`, `BUILD_NUMBER`, job URL, and checksums with the artifact. 🧾
* **Promotion** — move/copy artifact between repos (dev → staging → prod) instead of rebuilding. ♻️
* **Retention & GC** — set lifecycle/retention to reclaim storage; keep releases longer than snapshots. 🗄️

---

### ⚙️ Examples / Commands

#### Publish / download with JFrog CLI (recommended for binary repos)

```bash
# configure once
jfrog rt config --interactive=false --url=https://artifactory.company.com --user=ci-bot --apikey=$JFROG_APIKEY

# publish artifact
JFROG_REPO=libs-release-local
jfrog rt upload "build/libs/*.jar" ${JFROG_REPO}/myapp/${BUILD_NUMBER}/ --props "git.sha=${GIT_COMMIT};build=${BUILD_NUMBER}"

# download artifact in downstream job
jfrog rt download "${JFROG_REPO}/myapp/${BUILD_NUMBER}/app.jar" ./artifacts/
```

#### S3 as artifact store (object storage)

```bash
# upload
aws s3 cp dist/app.tar.gz s3://ci-artifacts/myapp/${BUILD_NUMBER}/app.tar.gz --acl private

# pre-signed URL for temporary sharing (60 min)
aws s3 presign s3://ci-artifacts/myapp/${BUILD_NUMBER}/app.tar.gz --expires-in 3600
```

#### Docker images — tag with commit + push to registry (ECR example)

```bash
IMAGE="123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:${GIT_COMMIT}"
docker build -t ${IMAGE} .
aws ecr get-login-password | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com
docker push ${IMAGE}
# use image by digest for immutability
DIGEST=$(aws ecr batch-get-image --repository-name myapp --image-ids imageTag=${GIT_COMMIT} --query 'images[0].imageId.imageDigest' --output text)
IMAGE_BY_DIGEST="${IMAGE%:*}@${DIGEST}"
```

#### Jenkins — archive + push to repo

```groovy
// Jenkinsfile snippet
stage('Publish') {
  steps {
    sh 'mvn -DskipTests package'
    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
    sh '''
      jfrog rt upload "target/*.jar" libs-release-local/myapp/${BUILD_NUMBER}/ --props "git.sha=${GIT_COMMIT};build=${BUILD_NUMBER}"
    '''
  }
}
```

#### GitHub Actions — upload artifact & pass to next job

```yaml
# upload
- uses: actions/upload-artifact@v4
  with:
    name: myapp-${{ github.run_number }}
    path: build/app.tar.gz

# download in another job
- uses: actions/download-artifact@v4
  with:
    name: myapp-${{ github.run_number }}
```

---

### 📋 Comparison table: artifact backends

|                     Store | Use-case                        | Pros                                      | Cons                                          |
| ------------------------: | ------------------------------- | ----------------------------------------- | --------------------------------------------- |
|   **Artifactory / Nexus** | Maven/nuget/docker/multi-format | Rich metadata, promotion, repo management | Requires infra & license (optional)           |
|              **S3 / GCS** | Generic object storage          | Cheap, scalable, lifecycle rules          | No native promotion workflows                 |
| **ECR / DockerHub / GCR** | Container images                | Native digest support, registry features  | Image retention costs                         |
|       **GitHub Releases** | Release binaries                | Easy for OSS releases                     | Not ideal for internal heavy artifacts        |
| **Local Jenkins archive** | Short-term storage              | Convenience for small artifacts           | Not scalable / not recommended for production |

---

### ✅ Best practices (practical checklist)

* 🔖 **Tag artifacts with Git commit + build number** (e.g., `myapp:sha-<commit>`).
* 🔗 **Store provenance metadata** (commit SHA, build URL, pipeline name) as artifact properties or sidecar `metadata.json`.
* 🔐 **Use immutable references** (registry digest) for deployments to avoid "works on my machine" drift.
* ♻️ **Promote artifacts** between repos (dev → staging → prod) rather than rebuilding. Use repo-native promotion APIs.
* 🔎 **Publish checksums & SBOMs** (SHA256, SPDX/CycloneDX) and sign artifacts when needed.
* 🔁 **Automate artifact cleanup** with retention policies (snapshots shorter than releases).
* 🔒 **Control access** via IAM/repo ACLs and audit reads/writes.
* 🧾 **Archive logs & metadata** alongside artifacts for reproducibility and debugging.
* 🧪 **Use artifact repos in CI**: upstream test/verify pulls the exact artifact used in deploy.
* 📦 **Avoid storing large build outputs in Git** — use LFS or external stores.
* 📈 **Monitor storage & access patterns** to tune lifecycle rules and cost.

---

### 🔧 Promotion & immutability example (Artifactory)

```bash
# create a promotion from 'libs-dev-local' to 'libs-staging-local'
jfrog rt repo-promotion --source-repo=libs-dev-local --target-repo=libs-staging-local \
  --build-name=myapp --build-number=${BUILD_NUMBER} --comment="Promote to staging"
```

---

### 💡 Troubleshooting tips

* Downstream can't find artifact → verify path, permissions, and metadata (build number, commit).
* Artifacts mismatch → use checksums/digest to confirm identity.
* Storage costs high → add lifecycle to move old snapshots to cheaper tier or delete.
* Reproducibility failing → ensure build inputs (deps + commit) recorded in metadata, use lockfiles.

---

### 💡 In short

**Publish artifacts to a dedicated repository**, version them with commit+build identifiers, record provenance and checksums, promote artifacts through environments (don’t overwrite), and enforce retention & access controls. This yields reproducible, auditable, and efficient CI/CD pipelines. ✅

---
---

## Q: How do you back up Jenkins?

### 🧠 Overview

Backing up Jenkins means preserving its **configuration, job data, plugins, and build history** — ensuring you can recover quickly from data loss or corruption.
Focus on **`$JENKINS_HOME`**, **plugins**, **credentials**, and **job configs**. Use **scheduled backups** or **persistent volumes** (in Docker/K8s), and test restoration regularly.

---

### ⚙️ Key Directories & Files to Back Up

| Path                       | Purpose                                                   |
| -------------------------- | --------------------------------------------------------- |
| `$JENKINS_HOME/config.xml` | Global Jenkins configuration                              |
| `$JENKINS_HOME/jobs/`      | Job/pipeline configurations and history                   |
| `$JENKINS_HOME/users/`     | User account data                                         |
| `$JENKINS_HOME/plugins/`   | Installed plugin binaries                                 |
| `$JENKINS_HOME/secrets/`   | Credentials (🔒 critical)                                 |
| `$JENKINS_HOME/nodes/`     | Agent configurations                                      |
| `$JENKINS_HOME/updates/`   | Plugin update center data                                 |
| `$JENKINS_HOME/workspace/` | Optional; temporary build directories (can skip for size) |

> 📍 **Default path:** `/var/lib/jenkins` on Linux, or `/var/jenkins_home` in Docker.

---

### ⚙️ 1️⃣ Manual Backup (Simple & Effective)

#### Linux Example

```bash
# stop Jenkins to avoid inconsistent state
sudo systemctl stop jenkins

# backup entire JENKINS_HOME
sudo tar -czvf jenkins-backup-$(date +%F).tar.gz /var/lib/jenkins/

# restart Jenkins
sudo systemctl start jenkins
```

> ✅ Quick and reliable for small setups.
> ❌ Not ideal for active pipelines (requires downtime).

---

### ⚙️ 2️⃣ Hot Backup (No Downtime)

Use the **ThinBackup plugin** or **Backup plugin** for online backups without stopping Jenkins.

#### ThinBackup Plugin Example

1. Install **ThinBackup Plugin** (`Manage Jenkins → Manage Plugins`).
2. Configure:

   * Backup directory: `/mnt/backups/jenkins/`
   * Schedule: `H 2 * * *` (nightly at random minute in 2 AM hour)
   * Include build records, next build numbers, job configs.
3. Enable compression and cleanup old backups automatically.

Backup config file:
`Manage Jenkins → ThinBackup → Settings`

Restore:

> Copy contents from backup to `$JENKINS_HOME` → restart Jenkins.

---

### ⚙️ 3️⃣ Jenkins-in-Docker Backup

If Jenkins runs as a Docker container:

```bash
# Backup persistent volume
docker run --rm --volumes-from jenkins \
  -v $(pwd):/backup ubuntu tar -czf /backup/jenkins-backup.tar.gz /var/jenkins_home
```

To restore:

```bash
docker run --rm -v jenkins_home:/var/jenkins_home -v $(pwd):/backup ubuntu tar -xzf /backup/jenkins-backup.tar.gz -C /
```

✅ **Best Practice:** Mount `/var/jenkins_home` to a persistent volume (EBS, NFS, etc.), then back up that volume snapshot (e.g., AWS EBS snapshot).

---

### ⚙️ 4️⃣ Kubernetes + Persistent Volume Backup

When Jenkins is deployed via **Helm** on K8s:

```bash
# get PVC name
kubectl get pvc -n jenkins

# snapshot via CSI driver (AWS/GCP/Azure)
kubectl apply -f - <<EOF
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: jenkins-home-snapshot-$(date +%Y%m%d)
  namespace: jenkins
spec:
  volumeSnapshotClassName: csi-aws-vsc
  source:
    persistentVolumeClaimName: jenkins
EOF
```

> 💾 Store snapshots in S3 / GCS / Blob Storage via managed snapshot lifecycle policies.

To restore → create new PVC from snapshot:

```bash
kubectl apply -f jenkins-restore.yaml
```

---

### ⚙️ 5️⃣ Cloud Backups (S3/GCS/Azure Blob)

Schedule compressed backups to cloud storage:

```bash
tar -czf /tmp/jenkins-backup-$(date +%F).tar.gz /var/lib/jenkins
aws s3 cp /tmp/jenkins-backup-$(date +%F).tar.gz s3://ci-backups/jenkins/
```

Add to `cron`:

```bash
0 2 * * * /usr/local/bin/jenkins-backup.sh
```

> ✅ Combine with lifecycle policy: retain last 7 daily + 4 weekly + 12 monthly backups.

---

### ⚙️ 6️⃣ Configuration-as-Code (JCasC) — Infrastructure Recovery

If using **Jenkins Configuration as Code (JCasC)**:

* Back up or version-control `jenkins.yaml`, `plugins.txt`, and any Groovy init scripts.
* Rebuild Jenkins quickly from scratch:

  ```bash
  docker build -t myorg/jenkins:latest .
  docker run -d -p 8080:8080 \
    -e CASC_JENKINS_CONFIG=/config/jenkins.yaml \
    -v /path/to/configs:/config myorg/jenkins:latest
  ```

✅ Combine with artifact repositories (for job artifacts) → fully reproducible CI setup.

---

### ⚙️ 7️⃣ Disaster Recovery (Full Restore Steps)

1. Stop Jenkins service or controller pod.
2. Replace `$JENKINS_HOME` contents with backup.
3. Verify permissions (`chown -R jenkins:jenkins /var/lib/jenkins`).
4. Restart Jenkins (`systemctl start jenkins` or `kubectl rollout restart`).
5. Validate:

   * Users, jobs, and credentials exist.
   * Last build history and artifacts accessible.
   * Plugins load correctly.

---

### 📋 Backup Frequency Strategy

| Data Type                         | Frequency                 | Method                   |
| --------------------------------- | ------------------------- | ------------------------ |
| Job configs / credentials         | Daily                     | ThinBackup / tarball     |
| Plugin list / JCasC / Helm values | On change                 | Git (Config-as-Code)     |
| Build history / logs              | Weekly                    | S3 / snapshots           |
| Artifact repository               | Separate retention policy | Repo-native lifecycle    |
| EBS / PV snapshots                | Nightly + before upgrades | Cloud snapshot scheduler |

---

### ✅ Best Practices

* 🔒 **Encrypt backups** — especially `$JENKINS_HOME/secrets/` and credentials.xml.
* 🧩 **Version control configuration** (JCasC, Helm values, plugins.txt).
* 🔁 **Automate backup rotation** and prune old archives.
* 🧪 **Test restore** periodically on staging Jenkins.
* 💾 **Back up before upgrades** (Jenkins or plugin updates).
* 🧰 **Separate backups**: Jenkins config ≠ artifacts/logs (use dedicated artifact repos).
* 🚦 **Use cloud snapshots for fast rollback** if running on AWS/GCP/Azure.
* 🧾 **Store backup metadata** (timestamp, Jenkins version, plugin manifest).
* 📢 **Alert on failed backups** (Slack/email notification from cron or CI job).

---

### 💡 In short

To back up Jenkins safely:

> Back up **`$JENKINS_HOME`**, **plugins**, and **secrets** regularly via ThinBackup or snapshots,
> version-control **JCasC configs**, and **test restore procedures** often.
> Use **cloud snapshots** or **object storage (S3/GCS)** for scalable, automated, encrypted backup retention. ✅

---
---

## Q: What is Blue Ocean?

### 🧠 Overview

**Blue Ocean** is a **modern Jenkins UI** designed to visualize pipelines more clearly, simplify pipeline creation, and improve the developer experience.
It provides a clean, responsive interface for **pipeline visualization, branch management, and build insights** — especially for Jenkins **Declarative Pipelines**.

---

### ⚙️ Key Features

| 🧩 Feature                   | 🔍 Description                                                                    |
| ---------------------------- | --------------------------------------------------------------------------------- |
| **Visual Pipeline Editor**   | Drag-and-drop UI for building and editing Jenkins pipelines.                      |
| **Pipeline Visualization**   | Graphical view of each stage, parallel step, and their results (success/failure). |
| **Real-Time Status Updates** | Live progress of running builds (no manual refresh).                              |
| **Branch & PR Integration**  | Auto-detects Git branches and pull requests (via Multibranch Pipelines).          |
| **Quick Logs & Artifacts**   | Inline access to logs, test results, and artifacts per stage.                     |
| **Simplified Navigation**    | Focused on Pipelines, not Freestyle jobs.                                         |
| **Error Visualization**      | Highlights failing steps with detailed error logs and causes.                     |
| **Responsive Web UI**        | Built with ReactJS; works well across devices.                                    |

---

### ⚙️ How to Install Blue Ocean

#### Option 1️⃣ — Plugin Installation (Jenkins UI)

1. Go to **Manage Jenkins → Manage Plugins → Available**.
2. Search for **Blue Ocean** and install all related plugins (bundle).

   ```
   blueocean
   blueocean-pipeline-editor
   blueocean-dashboard
   blueocean-git-pipeline
   ```
3. Restart Jenkins.
4. Access it at:
   👉 `http://<jenkins-url>/blue`

#### Option 2️⃣ — CLI

```bash
jenkins-plugin-cli --plugins blueocean:1.27.5
```

---

### ⚙️ Example — Viewing a Pipeline

After installing Blue Ocean:

* Go to `http://jenkins.example.com/blue/organizations/jenkins/`
* You’ll see:

  * **Pipeline list** (all branches/jobs)
  * **Visual pipeline graph**
  * Each **stage** with timing, logs, and artifact links
  * Quick link to rerun failed stages

---

### ⚙️ Blue Ocean vs Classic Jenkins UI

| Feature           | **Blue Ocean**                        | **Classic UI**           |
| ----------------- | ------------------------------------- | ------------------------ |
| UI design         | Modern (React-based)                  | Legacy HTML              |
| Focus             | Pipelines (Declarative & Multibranch) | Freestyle, all jobs      |
| Visualization     | Graphical stage view                  | Console log & text-based |
| Build interaction | Inline logs, stage restarts           | Full log reloads         |
| Ease of use       | Beginner-friendly                     | DevOps/admin-oriented    |
| Maintenance       | No longer actively developed (stable) | Fully supported, updated |

> 💡 **Note:** Blue Ocean is stable but **no longer under active development** (since ~2023).
> Jenkins team focuses on **Pipeline Graph View (new plugin)** as the future alternative.

---

### ⚙️ Useful URLs

| Purpose         | URL                                                                              |
| --------------- | -------------------------------------------------------------------------------- |
| Blue Ocean home | `/blue`                                                                          |
| Pipeline view   | `/blue/organizations/jenkins/<job-name>/detail/<branch>`                         |
| Run detail      | `/blue/organizations/jenkins/<job-name>/detail/<branch>/<build-number>/pipeline` |

---

### ✅ Best Practices

* 🚀 Use **Declarative Pipelines** for best visualization support.
* 🧩 Keep stages meaningful — Blue Ocean highlights each stage clearly.
* 🔍 Use **`post` blocks** to show cleanup/failure states distinctly.
* ⚙️ Integrate with **Multibranch Pipelines** for full Git visibility.
* 💾 Bookmark `/blue` view for quick CI/CD overviews.
* 🧰 If you need modern UI + maintenance, consider **Pipeline Graph View plugin** or **Jenkins Evergreen UI**.

---

### 💡 In short

**Blue Ocean** = Jenkins’ **modern UI** for pipelines — with visual stages, intuitive navigation, and branch awareness.
It simplifies understanding, debugging, and managing pipelines — especially for Declarative and Multibranch workflows. ✅

👉 Access it at `/blue` for a cleaner CI/CD experience.

---

---

## Q: How do you scale Jenkins for large workloads?

### 🧠 Overview

Scaling Jenkins means ensuring it can handle **hundreds of builds, concurrent jobs, and large teams** without bottlenecks.
You achieve this by **distributing workloads to agents**, **optimizing controller resources**, **containerizing builds**, and **automating scaling (Kubernetes/Cloud)**.

Goal → make Jenkins **elastic, fast, fault-tolerant, and maintainable**.

---

### ⚙️ 1️⃣ Jenkins Architecture for Scale

| Component               | Role                                      | Scaling Strategy                                                   |
| ----------------------- | ----------------------------------------- | ------------------------------------------------------------------ |
| **Controller (Master)** | Schedules jobs, manages configs & plugins | Run as HA setup (active-passive), offload builds to agents         |
| **Agents (Slaves)**     | Execute builds                            | Use autoscaling (K8s, EC2, Docker Cloud)                           |
| **Storage**             | Holds configs, logs, artifacts            | Use persistent volumes / S3 / NFS / Artifactory                    |
| **Queue / Executors**   | Dispatch jobs                             | Increase executor count or add dynamic agents                      |
| **Database / State**    | Credentials, pipeline data                | Offload heavy state/logging to external systems (e.g. Elastic, S3) |

> 📦 Keep the **controller lightweight** — *no builds on master.*

---

### ⚙️ 2️⃣ Horizontal Scaling — Add Dynamic Agents

#### A) **Kubernetes Plugin (Recommended for Modern Jenkins)**

Use the **Kubernetes plugin** to spawn ephemeral pods as build agents:

```yaml
controller:
  JCasC:
    configScripts:
      kubernetes: |
        jenkins:
          clouds:
            - kubernetes:
                name: "k8s"
                namespace: "jenkins"
                jenkinsUrl: "http://jenkins:8080"
                templates:
                  - name: "maven-agent"
                    label: "maven"
                    containers:
                      - name: "maven"
                        image: "maven:3.9.6-eclipse-temurin-17"
                        ttyEnabled: true
                        command: "cat"
```

✅ **Benefits:**

* Infinite parallelism (pod-per-build).
* Automatic cleanup.
* Resource limits per job.
* Fully containerized, reproducible builds.

---

#### B) **Cloud-based Autoscaling**

* **EC2 Fleet / Azure VM agents / Google Compute Engine plugin**

  ```groovy
  cloud:
    EC2Fleet:
      min: 2
      max: 20
      idleMinutesBeforeTerminate: 10
  ```

✅ Jenkins dynamically provisions instances for queued jobs, then shuts down idle agents.

---

#### C) **Docker Cloud Plugin**

Spin up **Docker containers as agents**:

```groovy
agent {
  docker {
    image 'node:20'
    args '-v /tmp:/tmp'
  }
}
```

* Lightweight, fast startup.
* Isolates dependencies per build.
* Great for on-prem clusters.

---

### ⚙️ 3️⃣ Controller Optimization

| Category             | Optimization                                                  |
| -------------------- | ------------------------------------------------------------- |
| **Executors**        | Set **0 executors** on the controller (use agents only).      |
| **Memory**           | Increase heap (`JAVA_OPTS=-Xmx4G -Xms4G`), tune GC.           |
| **Disk**             | Use SSD for Jenkins home + logs, and archive old builds.      |
| **Plugins**          | Remove unused plugins; keep versions consistent.              |
| **Database**         | Externalize metrics and logs (Prometheus/ELK).                |
| **Caching**          | Use shared caches for Maven/Gradle/npm to avoid re-downloads. |
| **Split large jobs** | Modularize pipelines (build → test → deploy).                 |

---

### ⚙️ 4️⃣ Job-Level Parallelism

Use **parallel stages** in pipelines to fully utilize agents:

```groovy
stage('Test Matrix') {
  parallel {
    stage('Unit') { steps { sh 'pytest tests/unit' } }
    stage('Integration') { steps { sh 'pytest tests/integration' } }
    stage('E2E') { steps { sh 'pytest tests/e2e' } }
  }
}
```

✅ Greatly reduces total build time for large test suites.

---

### ⚙️ 5️⃣ Data Offloading & Storage Management

* 🧱 **Artifacts** → push to Artifactory/Nexus/S3 (not Jenkins workspace).
* 📦 **Logs** → ship via Fluentd/Filebeat → ELK/Loki.
* 🧩 **Test results** → archive as JUnit reports, not raw logs.
* 🧹 **Cleanup** → use the *Discard Old Builds* setting:

  ```groovy
  options {
    buildDiscarder(logRotator(numToKeepStr: '20', artifactNumToKeepStr: '5'))
  }
  ```

---

### ⚙️ 6️⃣ Monitoring & Auto-healing

#### Metrics via **Prometheus Plugin**

```bash
http://jenkins.example.com/prometheus
```

Track:

* Build queue length
* Node utilization
* Executor count
* Job success/failure rate

#### Auto-Healing:

* Kubernetes → PodEviction + restart on failure.
* AWS → EC2 instance refresh / ASG policies.
* Jenkins Health Advisor Plugin → auto-detect controller issues.

---

### ⚙️ 7️⃣ Scaling Pipelines with Shared Libraries

Use **Shared Libraries** for reusable CI logic:

```groovy
@Library('shared-lib') _
pipeline {
  stages {
    stage('Build') { steps { buildApp() } }
    stage('Deploy') { steps { deployTo('staging') } }
  }
}
```

✅ Keeps pipelines light and standardized across teams.

---

### ⚙️ 8️⃣ High Availability (HA) Approaches

| HA Method                                         | Description                                                        |
| ------------------------------------------------- | ------------------------------------------------------------------ |
| **Controller failover (Active/Passive)**          | Use shared storage (EFS/NFS) and backup controller to failover.    |
| **Distributed controllers (controller per team)** | Use Jenkins Operations Center (CloudBees) or multiple instances.   |
| **Kubernetes + StatefulSet**                      | Jenkins persists data on PVC; cluster restarts pods automatically. |
| **GitOps Rebuild**                                | Recreate Jenkins from JCasC + Helm chart + S3 backup in minutes.   |

---

### ⚙️ 9️⃣ Pipeline Queue Optimization

* Configure:

  ```groovy
  queueItemAuthenticator {
    strategy("triggeringUsersAuthorizationStrategy")
  }
  ```
* Use **parallel job throttling** (`Throttle Concurrent Builds Plugin`) to prevent overload:

  ```groovy
  properties([
    throttleJobProperty(
      maxConcurrentPerNode: 2,
      maxConcurrentTotal: 5
    )
  ])
  ```
* Stagger heavy jobs via cron or build triggers.

---

### ✅ Best Practices Summary

| Area           | Best Practice                                                    |
| -------------- | ---------------------------------------------------------------- |
| **Controller** | No executors, lightweight, high heap (≥4GB).                     |
| **Agents**     | Auto-scaled via K8s/Docker/EC2 plugins.                          |
| **Builds**     | Parallelize, modularize, offload heavy tasks.                    |
| **Storage**    | Artifacts → repo; logs → ELK; metrics → Prometheus.              |
| **Config**     | Manage via JCasC + Helm; automate recovery.                      |
| **Monitoring** | Prometheus + Grafana dashboards for metrics.                     |
| **Security**   | Use credentials store + RBAC + least-privilege service accounts. |

---

### 💡 In short

To scale Jenkins:

> **Distribute builds** across dynamic agents (Kubernetes/Docker/EC2),
> **keep controller lightweight**, **offload logs/artifacts**,
> **monitor with Prometheus**, and manage config via **JCasC + GitOps**.

✅ Result → elastic, stable, and enterprise-ready CI/CD platform for large workloads.

---

# Scenario Questions

---

## 🧠 Q: Build passes locally but fails in Jenkins — how to debug & fix?

**Summary:** Builds that succeed locally but fail in Jenkins are usually caused by *environment differences* (JDK, tools, OS/filesystem, network, credentials, resources, caches, or agent configuration). Reproduce the Jenkins environment locally, collect environment/runtime info from the failing agent, and iteratively fix by standardizing the CI environment (containerized agents, pinned tool versions, and artifact repos).

---

## ✅ Overview

* Jenkins runs on **agents** that may differ from your dev machine.
* Differences to check: tool versions, PATH, env vars, credentials, network access, filesystem, permissions, resources, and cached dependencies.
* Fix pattern: **observe → reproduce → standardize** (make CI identical to local dev).

---

## ⚙️ Quick triage checklist (do these in order)

1. 🔍 **Get failure logs** from Jenkins (console + stacktrace).
2. 🧾 **Dump Jenkins env** (`env`) and compare with local (`env`/`printenv`).
3. 🧪 **Run same commands locally inside the same agent image** (or shell into agent).
4. 🔁 **Clear caches** (Maven/Gradle/npm) and retry in Jenkins.
5. 🧰 **Pin tool versions** (JDK, Maven, Node) or use container agents.
6. 🔐 **Check credentials & network** (artifact repo access, private registries).
7. 🧯 **Check disk/permissions/UID/GID** and workspace ownership.
8. ♻️ **Make pipeline reproducible** (use Docker/k8s agents, `Jenkinsfile`, shared libs).

---

## 🧩 Common causes & fixes (table)

| Cause                                     |                                           Symptom | Quick fix                                                          |
| ----------------------------------------- | ------------------------------------------------: | ------------------------------------------------------------------ |
| Tool/version mismatch (JDK, Maven, Node)  |  Different stacktrace, class/file incompatibility | Pin versions; install same tool on agent or use Docker agent image |
| Missing env vars/credentials              |               Auth/network errors, missing tokens | Use `withCredentials` or set env in pipeline/jcasc                 |
| Network access blocked                    |                     Timeout fetching dependencies | Check proxy, firewall, registry credentials                        |
| Filesystem differences (case sensitivity) | Fails on imports/file not found on Linux vs macOS | Normalize file names; test on same FS                              |
| Insufficient resources (CPU/memory/disk)  |                OOM, timeouts, build tool failures | Increase agent resources or use bigger agent                       |
| Different working dir/permissions         |          Permission denied, unable to write files | Fix ownership, run agent as same uid or change workspace path      |
| Caches / corrupt caches                   |                     Strange dependency resolution | Clean caches (mvn -U, npm ci, gradle --refresh-dependencies)       |
| Docker daemon / registry auth             |                         Image build/push failures | Use Kaniko/BuildKit or ensure docker creds available on agent      |
| Locale / line endings                     |                       Tests expecting CRLF/locale | Set locale / normalize line endings in CI                          |
| Parallelism / race conditions             |                 Flaky tests pass locally serially | Isolate tests, add retries, fix concurrency issues                 |
| Different JVM args / memory               |                     GC or test timing differences | Match MAVEN_OPTS/JAVA_TOOL_OPTIONS in Jenkins                      |

---

## 🔧 Practical commands & Jenkins snippets

### 1) Dump environment & system info in the failing Jenkins job

```groovy
pipeline {
  agent any
  stages {
    stage('Debug Info') {
      steps {
        sh '''
          echo "---- ENV ----"
          env
          echo "---- Java version ----"
          java -XshowSettings:all -version || true
          echo "---- Maven version ----"
          mvn -v || true
          echo "---- Disk usage ----"
          df -h .
          echo "---- Workdir ls ----"
          ls -la .
        '''
      }
    }
  }
}
```

### 2) Reproduce agent locally using Docker (run same image as agent)

```bash
# If agent uses image myorg/ci-agent:latest
docker run -it --rm \
  -v $(pwd):/workspace -w /workspace \
  myorg/ci-agent:latest /bin/bash
# then run the failing build command exactly inside container
```

### 3) Force fresh dependency resolution / clean caches

```bash
# Maven
mvn clean -U package

# Gradle
./gradlew clean build --refresh-dependencies

# npm
rm -rf node_modules package-lock.json
npm ci
```

### 4) SSH / Exec to agent (if available)

```bash
# If agent is reachable by SSH
ssh jenkins-agent 'bash -lc "cd /home/jenkins/workspace/myjob && ./build.sh"'
```

### 5) Show effective JVM/MAVEN options in CI

```groovy
sh 'echo "JAVA_OPTS=$JAVA_OPTS"; echo "MAVEN_OPTS=$MAVEN_OPTS"'
```

---

## 🛠️ Repro & hardening patterns (make CI identical to local)

### Use a Docker agent (Declarative)

```groovy
pipeline {
  agent {
    docker { image 'maven:3.9.6-eclipse-temurin-17' args '-v $HOME/.m2:/root/.m2' }
  }
  stages {
    stage('Build') { steps { sh 'mvn -B -DskipTests package' } }
  }
}
```

### Or use Kubernetes pod template (K8s plugin)

```groovy
pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: maven
    image: maven:3.9.6-eclipse-temurin-17
    command:
    - cat
    tty: true
"""
    }
  }
  stages { stage('Build'){ steps { container('maven'){ sh 'mvn -B package' } } } }
}
```

### Pin versions via tool installers / tool blocks

```groovy
tools {
  jdk 'openjdk-17'
  maven 'Maven_3_9'
}
```

---

## 🧪 Debug checklist — what to collect & compare

* ✅ Jenkins console output (full stacktrace)
* ✅ `env` / `printenv` from Jenkins agent vs local `env`
* ✅ `java -version`, `mvn -v`, `node -v`, `docker --version` on agent vs local
* ✅ Disk free: `df -h` and inode usage: `df -i`
* ✅ Permissions: `ls -la` on workspace, ownership (uid/gid)
* ✅ Network: `curl -v` to artifact registry or external endpoints from agent
* ✅ Agent logs (system logs, jenkins-agent logs)
* ✅ Any proxy settings (`http_proxy`, `HTTPS_PROXY`)
* ✅ Test flakiness: re-run build with `rerun` or locally multiple times

---

## 🧾 Examples: Common fixes for specific failure types

### A) Authentication/401 to artifact repo

* Ensure credentials are stored in Jenkins Credentials and used via `withCredentials` or docker login step.

```groovy
withCredentials([usernamePassword(credentialsId: 'artifactory-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
  sh 'curl -u $USER:$PASS https://artifactory.mycompany.com/...'
}
```

### B) OutOfMemory / Heap errors in build

* Increase agent JVM memory or adjust `MAVEN_OPTS`:

```groovy
environment { MAVEN_OPTS = '-Xmx2g -XX:ReservedCodeCacheSize=256m' }
```

### C) Docker build fails on agent (no docker daemon)

* Use Kaniko or BuildKit inside Kubernetes, or ensure the agent has access to Docker daemon (prefer remote TLS, not `docker.sock` on master).

---

## ✅ Best practices to avoid "works-on-my-machine" issues

* 📦 **Containerize CI**: use the same Docker image for dev & CI.
* 🧷 **Pin versions** of JDK, build tools, and dependencies.
* 🔁 **Automate environment setup** (devcontainers, docker-compose for dev).
* 🔐 **Manage credentials** via Jenkins Credentials and secret managers.
* ♻️ **Use reproducible builds** (lockfiles, locked dependencies).
* 🧹 **Clean workspace and caches** in CI when debugging.
* 📈 **Monitor agent resources** and queue lengths.
* 🧾 **Log metadata** (GIT_COMMIT, BUILD_NUMBER, agent label) in build outputs.
* 🧪 **Run flaky tests in isolation** and add retries only for transient failures.

---

## 💡 In short

When a build passes locally but fails in Jenkins: **compare environments**, **reproduce the Jenkins environment locally** (use the same Docker/K8s agent), **collect logs/env/tool versions**, and **standardize CI** by pinning versions or using containerized agents. Fix the root cause (env, network, creds, resources, filesystem) — not just the symptoms. ✅

---
---

## 🧠 Summary

Deploying to multiple environments (dev / staging / prod) means **promoting immutable artifacts** through controlled stages, using repeatable automation (CI/CD), environment-specific configs, secure secrets, and clear approval/gating. Choose a pattern (promotion, GitOps, or separate pipelines) that enforces traceability, rollbackability, and least privilege.

---

## Q: Need to deploy to multiple environments

### ✅ Overview

* Treat environments as promotion stages, not separate snowflakes.
* Build **once** → produce immutable artifact (image, artifact repo path) → **promote** that artifact across environments.
* Use **environment-specific config** (Helm values, k8s overlays, Terraform workspaces, or secrets manager) — not code branching.
* Automate with pipelines (Jenkins/GitHub Actions/GitLab CI) or GitOps tools (ArgoCD/Flux) and enforce approvals for sensitive environments.
* Maintain provenance: commit SHA, build number, artifact digest, and test results for each promotion.

---

### ⚙️ Deployment Strategies (comparison)

|                        Strategy | How it works                                                                     | Pros                                            | Cons                                       |
| ------------------------------: | -------------------------------------------------------------------------------- | ----------------------------------------------- | ------------------------------------------ |
|          **Pipeline Promotion** | CI builds artifact, pipeline has sequential deploy stages (dev→staging→prod)     | Simple, single source of truth, easier to audit | Requires pipeline to manage infra access   |
|        **GitOps (ArgoCD/Flux)** | Push env-specific manifests to env git repos/branches; GitOps reconciler applies | Declarative, auditable, easy rollback via git   | Needs GitOps infra; extra repo management  |
|          **Artifact Promotion** | Build store artifact in repo; promote (copy/tag) between repos                   | Immutable artifacts, clean traceability         | Needs artifact repo & promotion mechanism  |
|  **Separate pipelines per env** | Independent jobs for each env, triggered by promotion                            | Clear separation of permissions                 | More duplication & overhead                |
| **Feature flags / Dark Launch** | Deploy to prod but gate features                                                 | Safe live testing, minimizes env drift          | Requires flag management & instrumentation |

---

### ⚙️ Practical Patterns & Rules

* 🔁 **Build Once**: use digest/tag (e.g., `myapp@sha256:<digest>`).
* 🧾 **Provenance**: store `GIT_COMMIT`, `BUILD_NUMBER`, artifact digest as metadata.
* 🔒 **Least privilege**: only CI/GitOps robot has deploy privileges; humans approve via PR or pipeline `input`.
* ✅ **Smoke tests** after each deploy; require green before promoting.
* ⏱️ **Use timeboxed manual approvals** for production with audit trail.
* ↩️ **Automated rollback** on health-check failure (K8s `kubectl rollout undo` or Helm rollback).
* 📦 **Config separation**: use Helm values files, Kustomize overlays, or env-specific Terraform variables.
* ♻️ **Immutable infra change**: infra changes go through CI and are applied via Terraform/CDK with state isolation (workspaces).

---

## ⚙️ Examples & Commands

### 1) Jenkinsfile — build once, promote through envs, manual prod approval

```groovy
pipeline {
  agent any
  parameters {
    string(name:'IMAGE_TAG', defaultValue:'', description:'(optional) override image tag')
  }
  environment {
    ARTIFACT = credentials('artifact-repo-token')
  }
  stages {
    stage('Build') {
      steps {
        sh 'docker build -t myrepo/myapp:${BUILD_NUMBER} .'
        sh 'docker push myrepo/myapp:${BUILD_NUMBER}'
        script { env.IMAGE = params.IMAGE_TAG ?: "${BUILD_NUMBER}" }
      }
    }

    stage('Deploy → Dev') {
      steps {
        sh "helm upgrade --install myapp-dev charts/myapp -f charts/values-dev.yaml --set image.tag=${IMAGE}"
        sh './scripts/smoke-check.sh dev'
      }
    }

    stage('Deploy → Staging') {
      when { expression { return currentBuild.currentResult == null } }
      steps {
        sh "helm upgrade --install myapp-staging charts/myapp -f charts/values-staging.yaml --set image.tag=${IMAGE}"
        sh './scripts/smoke-check.sh staging'
      }
    }

    stage('Approve Prod') {
      steps {
        timeout(time:2, unit:'HOURS') {
          input message: "Approve promotion to production?", submitter: "release-managers"
        }
      }
    }

    stage('Deploy → Prod') {
      steps {
        sh "helm upgrade --install myapp-prod charts/myapp -f charts/values-prod.yaml --set image.tag=${IMAGE}"
        sh './scripts/smoke-check.sh prod'
      }
    }
  }

  post {
    failure { mail to: 'devops@example.com', subject: "Deploy failed: ${env.JOB_NAME} ${env.BUILD_NUMBER}", body: "${env.BUILD_URL}" }
  }
}
```

---

### 2) GitOps (ArgoCD) — env repos + promotion by PR

* Repo structure:

```
infra/
  apps/
    myapp/
      base/         # kustomize base
      overlays/
        dev/
        staging/
        prod/
```

* To deploy to staging: update `overlays/staging/kustomization.yaml` or create PR to `staging` branch. ArgoCD reconciles the cluster automatically.

**Promote flow**

1. CI builds image `myrepo/myapp:sha-<gitsha>` and creates PR to `overlays/staging` replacing image tag.
2. After CI smoke tests, merge PR → ArgoCD deploys.
3. For prod, create PR to `overlays/prod` with same image tag and require approvals.

---

### 3) kubectl / kubeconfig contexts — deploy to multiple clusters

```bash
# contexts: dev, staging, prod
kubectl config use-context dev
kubectl apply -f k8s/manifests/

kubectl config use-context staging
kubectl apply -f k8s/manifests/

kubectl config use-context prod
kubectl apply -f k8s/manifests/
```

Use `kubectl --context=<ctx>` in pipelines to avoid switching global config.

---

### 4) Terraform workspaces for infra per-environment

```bash
# init once
terraform init

# dev
terraform workspace select dev || terraform workspace new dev
terraform plan -var-file="env/dev.tfvars"
terraform apply -var-file="env/dev.tfvars"

# prod (with manual approval)
terraform workspace select prod || terraform workspace new prod
terraform plan -var-file="env/prod.tfvars"
# require approval step in pipeline
terraform apply -var-file="env/prod.tfvars"
```

---

### 5) GitHub Actions — environment protection + deploy job example

```yaml
on:
  push:
    tags: ['v*']

jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      image: ${{ steps.build.outputs.image }}
    steps:
      - uses: actions/checkout@v4
      - name: Build image
        id: build
        run: |
          IMAGE=myrepo/myapp:${GITHUB_SHA}
          docker build -t $IMAGE .
          docker push $IMAGE
          echo "::set-output name=image::$IMAGE"

  deploy-staging:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to staging
        run: |
          IMAGE=${{ needs.build.outputs.image }}
          kubectl --context=staging set image deployment/myapp myapp=$IMAGE
          ./scripts/smoke-check.sh staging

  deploy-prod:
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://myapp.example.com
    steps:
      - name: Deploy to prod
        run: |
          IMAGE=${{ needs.build.outputs.image }}
          kubectl --context=prod set image deployment/myapp myapp=$IMAGE
```

> Protect `production` environment in GitHub with required reviewers to enforce manual approval.

---

## 📋 Environment configuration patterns

|                  Pattern | File / Tool                           | Example                                       |                     |
| -----------------------: | ------------------------------------- | --------------------------------------------- | ------------------- |
| Env-specific Helm values | `values-dev.yaml`, `values-prod.yaml` | `helm upgrade --values values-prod.yaml`      |                     |
|       Kustomize overlays | `overlays/dev/`, `overlays/prod/`     | `kustomize build overlays/prod                | kubectl apply -f -` |
|                  Secrets | Vault / Secrets Manager / K8s Secrets | `vault kv get secret/prod/db`                 |                     |
|          Feature toggles | LaunchDarkly / Flags                  | Enable flags per environment without redeploy |                     |
|               Infra vars | Terraform tfvars                      | `terraform apply -var-file=prod.tfvars`       |                     |

---

## ✅ Best Practices (practical checklist)

* 🔁 **Build once, deploy many** — use immutable artifact digests.
* 🧾 **Record metadata** (artifact digest, git sha, pipeline run URL) with each env promotion.
* 🔒 **Use GitOps or CI with strict RBAC** for production deploys; require approvals.
* 🧪 **Automate smoke & integration tests** after each deploy before promotion.
* ♻️ **Promote, don’t rebuild**: copy/tag artifact in registry or update manifest to the same digest.
* ↩️ **Support safe rollbacks** via Helm/ArgoCD/`kubectl rollout undo` with health checks.
* 🔐 **Protect secrets** with a secrets manager and inject at runtime — do not store in repo.
* 🧩 **Separate infra & app changes**: test infra changes in non-prod first.
* 📈 **Monitor & alert** after each promotion (deploy success, latency, error rates).
* 🧾 **Auditable approvals**: store approver identity, timestamp, and reason.
* 📦 **Use blue/green or canary** for production risk reduction on large deployments.

---

## 💡 In short

1. **Produce immutable artifact once**.
2. **Automate promotion** from dev → staging → prod (pipeline or GitOps).
3. **Use environment-specific config & secrets** injected at runtime.
4. **Require approvals & smoke tests** before production.
5. **Monitor and enable fast rollback**. ✅

If you want, I can generate a ready-to-run **Jenkinsfile + Helm values structure** or a **GitOps PR template** tailored to your stack (Kubernetes/EC2/ECS + Helm/Kustomize/Terraform). Which stack should I target?

---

---

## Q: Jenkins builds trigger twice

### 🧠 Overview

If Jenkins runs the same job twice for a single SCM event, it’s almost always **duplicate triggers** — e.g., *two webhooks*, *webhook + Poll SCM*, *GitHub App + webhook*, or overlapping job configs (multibranch vs single-branch). Find the duplicate source, remove or consolidate that trigger, and prefer a single event-driven mechanism (webhook via BranchSource/GitHub App).

---

### ⚙️ Common Causes & Quick Fixes

| Cause                                                            |                                        Symptom | Fix                                                                               |
| ---------------------------------------------------------------- | ---------------------------------------------: | --------------------------------------------------------------------------------- |
| Two webhooks configured (repo & org, or manual + app)            |     Two deliveries in webhook logs; two builds | Remove duplicate webhook; prefer GitHub App or single webhook                     |
| Webhook **and** `Poll SCM` enabled                               |  Immediate build + poll triggers shortly after | Disable `Poll SCM` for job or multibranch; use webhooks only                      |
| Multibranch Pipeline **and** a separate job for same branch      |     Both job and multibranch build same commit | Remove single-branch job or use only multibranch job                              |
| GitHub App *and* legacy webhook installed                        |                          Two deliveries/events | Use GitHub App for org; remove legacy webhook(s)                                  |
| Job configured with `githubPush()` trigger + webhook also firing |                          Two pipeline triggers | Remove `githubPush()` from Jenkinsfile if webhook handled by Jenkins job config   |
| Tag push + branch push or PR + push events                       |  Two different events (push + create tag / PR) | Limit webhook events to only needed ones                                          |
| Generic Webhook plugin + BranchSource both reacting              |                             Duplicate handling | Configure only one plugin to handle the payload; use BranchSource for multibranch |
| Hook retries interpreted as new events                           | Multiple identical deliveries but with retries | Check webhook response codes; ensure Jenkins returns 200 quickly to avoid retries |

---

### 🔍 How to diagnose (step-by-step)

1. **Check webhook delivery logs at the Git host**

   * GitHub:

     ```bash
     gh api repos/:owner/:repo/hooks --jq '.[] | {id: .id, config: .config.url}'
     # or open repo → Settings → Webhooks → Delivery history (inspect payloads & timestamps)
     ```
   * GitLab:

     ```bash
     curl --header "PRIVATE-TOKEN: $TOKEN" "https://gitlab.com/api/v4/projects/<id>/hooks"
     ```
   * Look for *two* deliveries for a single push and note their `X-GitHub-Event` and timestamps.

2. **Check Jenkins access logs & system log for webhook endpoints**

   * Tail Jenkins `jenkins.log` / web server logs and grep for webhook endpoints:

     ```bash
     sudo journalctl -u jenkins -f
     grep -i "github-webhook" /var/log/jenkins/jenkins.log || true
     ```
   * Search for lines like `Triggering ...` or `Received payload` and timestamps.

3. **Inspect job configuration**

   * For Freestyle: check **Build Triggers** → uncheck *Poll SCM* if using webhooks.
   * For Pipeline `Jenkinsfile`: search for `triggers { pollSCM(...) }` or `triggers { githubPush() }`.
   * For Multibranch: check **Scan Repository Triggers** and whether webhooks are enabled.

4. **Check BranchSource / Multibranch settings**

   * Multibranch jobs often get events from GitHub Branch Source plugin; verify you don't also have a repository-level job doing the same build.

5. **Reproduce and observe**

   * Push a test commit and watch webhook deliveries and Jenkins logs — match timestamps to which component accepted the event.

---

### ⚙️ Example fixes & snippets

#### A) Disable Poll SCM in a job (Freestyle / Pipeline job)

```text
Job → Configure → Build Triggers → Uncheck "Poll SCM"
```

#### B) Remove `githubPush()` from Jenkinsfile (if webhook already used)

```groovy
// remove or comment out this block if webhook used externally
// triggers { githubPush() }
```

#### C) Use GitHub App (recommended) and delete legacy webhook

* Install GitHub App at organization level and remove repo-level webhook from Settings → Webhooks.
* In Jenkins, use **GitHub Branch Source** with App credentials.

#### D) Lock Branch Source so only it consumes webhooks

In multibranch job configure: **Property strategy → suppress automatic SCM triggering**? (UI varies). Alternatively ensure only Branch Source plugin registered the webhook.

---

### 📋 Useful commands / checks

* List webhooks (GitHub CLI):

```bash
gh api repos/:owner/:repo/hooks --jq '.[] | {id: .id, url: .config.url, events: .events}'
```

* Test webhook delivery (GitHub UI has a "Redeliver" and delivery log).

* See recent builds and cause in Jenkins (Web UI or REST):

```bash
# Get last build cause
curl -s "https://jenkins.example.com/job/my-job/lastBuild/api/json" | jq '.actions[] | select(.causes) | .causes[]'
```

* Grep Jenkins log for webhook hits:

```bash
grep -i "github-webhook" /var/log/jenkins/jenkins.log || true
```

---

### ✅ Best Practices (prevent recurrence)

* ⚡ **Prefer webhooks** (GitHub App / GitLab integration) — disable polling.
* 🎯 **One trigger source per event type**: either webhook or poll, not both.
* 🧭 **Use Multibranch Pipelines** for branch/PR builds; avoid duplicate single-branch jobs for same repo.
* 🔐 **Keep webhooks & apps consistent**: org-level GitHub App is preferable for many repos.
* 🧾 **Audit webhook deliveries** after changes — Git host shows delivery history.
* 🧰 **Centralize trigger logic**: avoid both job-level triggers and Jenkinsfile triggers that do the same thing.
* 🕵️ Log the build cause in pipeline for easy tracing:

  ```groovy
  echo "Build cause: ${currentBuild.getBuildCauses()}"
  ```
* ♻️ **If using Generic Webhook plugins**, filter payloads so only intended jobs respond.

---

### 💡 In short

When Jenkins builds run twice, **you almost always have two triggers firing**. Check Git host webhook logs and Jenkins job configs (Poll SCM, Jenkinsfile triggers, multibranch/branch-source settings). Remove the duplicate (disable Poll SCM or delete extra webhook, use GitHub App + BranchSource) and prefer a single event-driven flow. ✅

---

---

## Q: Secret exposed in logs

### 🧠 Summary

If a secret (API key, password, token) appears in logs — **rotate the secret immediately**, then remove or redact it from logs/history, notify stakeholders, and harden pipelines to prevent recurrence. Treat it as an incident: short-term mitigation (rotation) → removal/cleanup → prevention.

---

## Overview

Exposed secrets are high-priority incidents. Logs (CI console output, application logs, build artifacts, repo history, cloud storage) are often cached/backed-up — you must **rotate credentials first**, then attempt to purge exposures. Some places (third-party caches, forks, CI provider logs) may retain copies you cannot fully erase — rotation + audit is mandatory.

---

## ⚙️ Step-by-step action plan (do this now — in order)

### 1) **Rotate / revoke the secret immediately** (first, non-negotiable) ✅

* Revoke the exposed token/API key and create a new one.
* If it’s cloud cred (AWS/GCP/Azure), rotate IAM keys and remove old keys.

```bash
# Example: revoke AWS access key (use AWS CLI)
aws iam update-access-key --user-name ci-bot --access-key-id <OLD_KEY_ID> --status Inactive
aws iam delete-access-key --user-name ci-bot --access-key-id <OLD_KEY_ID>
# then create and distribute new key securely
aws iam create-access-key --user-name ci-bot
```

* For API services: use provider console to revoke the token and issue a new one.

> 🛑 Do **not** attempt log removal before rotation — leak may already be exploited.

---

### 2) **Identify all places the secret appears** 🔎

* Search repo, commit history, CI logs, artifact repos, S3 buckets, issue trackers, Slack screenshots.

```bash
# search in current repo
git grep -n 'partial-secret-or-pattern' || true

# search full history (fast)
git log --all -S 'partial-secret-or-pattern' --pretty=format:'%h %an %ad %s' --date=short

# search workspace + archived logs
grep -R --line-number 'partial-secret-or-pattern' /var/lib/jenkins || true
```

* Check CI provider build logs (Jenkins `/var/lib/jenkins/jobs/.../builds/*/log`), GitHub Actions artifacts, runners' workspaces, Artifact/Nexus repos, S3.

---

### 3) **Purge or redact logs where you control them** 🧹

**A. Jenkins (controller with access to `$JENKINS_HOME`)**

1. Stop Jenkins (to avoid data corruption):

```bash
sudo systemctl stop jenkins
```

2. Find and edit/delete offending build logs:

```bash
# locate occurrences
grep -R --line-number 'THE_SECRET' /var/lib/jenkins || true

# example path: /var/lib/jenkins/jobs/<job>/builds/<n>/log
# remove or redact the file
sed -i 's/THE_SECRET/REDACTED_SECRET/g' /var/lib/jenkins/jobs/<job>/builds/<n>/log
# or delete the build (also removes metadata):
rm -rf /var/lib/jenkins/jobs/<job>/builds/<n>
```

3. Start Jenkins:

```bash
sudo systemctl start jenkins
```

> ⚠️ Deleting builds loses history — document which builds were removed and why.

**B. GitHub Actions / GitLab / other CI**

* Delete or redact workflow run logs/artifacts via provider UI or API. Many providers allow deleting artifacts and logs; follow their docs. If not possible, rotate and contact provider support.

**C. Cloud storage / object stores**

* If exposed in S3/GCS: delete objects and invalidate CDN caches; rotate credentials and audit access logs.

---

### 4) **Remove secret from Git history** (if it was committed)

> Important: rewriting history is disruptive. Communicate and coordinate with your team before force-pushing.

**Preferred: `git filter-repo` (fast & maintained)**
(Install: `pip install git-filter-repo`)

```bash
# Remove a secret string from entire history
git clone --mirror git@github.com:org/repo.git
cd repo.git
git filter-repo --invert-paths --path-glob 'path/to/file/with/secret'          # if file only
# or replace literal secret across history
git filter-repo --replace-text <(echo 'THE_SECRET==[REDACTED]')
# push cleaned mirror (force)
git push --force --all
git push --force --tags
```

**Alternative: BFG Repo-Cleaner (simple)**

```bash
# mirror clone
git clone --mirror git@github.com:org/repo.git
java -jar bfg.jar --replace-text passwords.txt repo.git
# passwords.txt contains lines like:
# THE_SECRET==[REDACTED]
cd repo.git
git reflog expire --expire=now --all && git gc --prune=now --aggressive
git push --force
```

After rewrite:

* Ask all collaborators to **re-clone** (or carefully `fetch` + reset). Provide exact recovery steps.

---

### 5) **Invalidate caches / rotate tokens for external services** 🔁

* Invalidate old tokens in Docker registries, artifact repos, cloud providers, and any services that may have cached the secret.
* Rotate any credentials that could have been derived from the leaked one (service accounts, downstream tokens).

---

### 6) **Notify & escalate** 📣

* Notify your security team and the service owner immediately (email/Slack + incident ticket).
* Log actions taken: rotation timestamp, tokens revoked, logs removed, PRs/issues updated.
* If the secret belonged to a customer or production system, follow incident response playbook and compliance reporting.

---

### 7) **Prevent recurrence (hardening)** 🔒

| Area             | Action                                                                                         |
| ---------------- | ---------------------------------------------------------------------------------------------- |
| Dev workflow     | Add `pre-commit` secret scanner (e.g., `gitleaks`, `pre-commit` hooks)                         |
| CI logs          | Mask secrets (Jenkins Mask Passwords / Credentials Binding)                                    |
| Secrets handling | Move secrets to a secret manager (Vault, AWS Secrets Manager)                                  |
| Commits          | Use `.gitignore` and avoid committing credentials; use environment variables/credentials store |
| Pipeline design  | Use credentials bindings (`withCredentials`) and avoid `echo`ing secrets                       |
| Access control   | Rotate credentials regularly and enforce least privilege                                       |
| Education        | Teach devs how to rotate and not to paste secrets in PRs, issues, or chat                      |

Examples:

```bash
# Add simple pre-commit using gitleaks
pip install gitleaks
gitleaks detect --source=. --report=gitleaks-report.json
```

Jenkins: enable masking & credentials usage

```groovy
withCredentials([string(credentialsId: 'api-key-id', variable: 'API_KEY')]) {
  sh 'curl -H "Authorization: Bearer $API_KEY" https://api.example.com/health'
}
```

And **do not** `echo $API_KEY`.

---

## 📋 Quick troubleshooting & checks

* Check access logs for suspicious usage between exposure time and rotation time (AWS CloudTrail, provider audit logs).
* Rotate any derived or related secrets even if not directly exposed.
* Preserve evidence for post-incident analysis (copy logs to secure location) before deleting, if required by policy.

---

## ✅ Best Practices (summary)

* 🔁 **Rotate first**, then attempt deletion.
* 🔍 **Search everywhere** (repo, CI logs, artifacts, cloud buckets, issue trackers).
* 🧹 **Purge/redact logs you control**, delete offending builds/artifacts.
* 🔄 **Rewrite Git history only when necessary** and coordinate with team.
* 🔐 **Move secrets to a proper secret manager** and use runtime injection.
* 🛡️ **Mask secrets in CI**, enable pre-commit scanning, and educate team.

---

### 💡 In short

1. **Rotate/revoke the secret now.**
2. **Locate all exposures** (repo, CI logs, artifacts, storage).
3. **Purge or redact logs you control** (Jenkins build logs, artifacts).
4. **Rewrite Git history** if secret was committed (use `git-filter-repo`/BFG) and force-push — coordinate with your team.
5. **Audit access**, notify security, and harden pipelines (masking, secret manager, pre-commit scanners). ✅

If you want, I can generate the exact commands tailored to your environment (Jenkins paths, Git host, and cloud provider) — tell me which CI, repo host, and cloud you use and I’ll produce a safe runbook.

---
---

## 🧠 Summary

If your pipeline is slow, diagnose *where* time is spent, then apply targeted fixes: parallelize work, cache dependencies/containers, use ephemeral containerized agents with cached volumes or remote caches, reduce unnecessary work (shallow/sparse checkout, selective tests), and scale agents. Below is a practical checklist + ready-to-drop Jenkinsfile/snippets.

---

## Q: Pipeline taking too long

### Overview

Long pipelines come from environment/setup overhead, network/registry latency, large checkouts, heavy or sequential tests, cold agent starts, lack of caching, inefficient Docker builds, or resource-constrained agents. Fix by **measuring**, **caching**, **parallelizing**, **offloading**, and **scaling** — in that order.

---

## 🔎 Diagnose first (quick commands & checks)

* Add timestamps & print stage durations:

```groovy
pipeline { options { timestamps() } stages { stage('X'){ steps { sh 'date; time ./run-step.sh' } } } }
```

* Check Jenkins UI: **Pipeline Stage View** or Blue Ocean for per-stage times.
* Inspect agent startup time (pod/VM spinup).
* Measure checkout time:

```bash
time git clone --depth=1 git@github.com:org/repo.git
```

* Check docker image pull/build times:

```bash
time docker pull myregistry/mybase:latest
time docker build -t myapp:local .
```

---

## ⚙️ Practical fixes & examples

### 1) Shallow & sparse checkout (avoid full repo)

```groovy
checkout([
  $class: 'GitSCM', branches: [[name: 'main']],
  userRemoteConfigs: [[url: 'git@github.com:org/repo.git']],
  extensions: [
    [$class: 'CloneOption', depth: 1, noTags: true, reference: '', shallow: true],
    [$class: 'SparseCheckoutPaths', sparseCheckoutPaths:[ [path:'serviceA/'], [path:'libs/common/'] ]]
  ]
])
```

### 2) Cache dependency directories (Maven, npm) on agent

* Use persistent volume or host-mounted cache for `~/.m2` or `~/.npm`.

```groovy
pipeline {
  agent { label 'docker-builder' }
  stages {
    stage('Build') {
      steps {
        sh '''
          mkdir -p $HOME/.m2
          docker run --rm -v $HOME/.m2:/root/.m2 -v $PWD:/src -w /src maven:3.9-jdk-17 mvn -B -DskipTests package
        '''
      }
    }
  }
}
```

* Kubernetes pod: mount a PVC to `/root/.m2`.

### 3) Docker image build caching (use buildx / cache-from / Kaniko cache)

**BuildKit (buildx)**

```bash
docker buildx build --cache-from=type=registry,ref=myrepo/cache:latest \
  --cache-to=type=registry,ref=myrepo/cache:latest,mode=max \
  -t myrepo/myapp:${IMAGE_TAG} .
```

**Kaniko (K8s)**

```yaml
args: ["--cache=true","--cache-ttl=24h","--destination=gcr.io/myproj/myapp:${TAG}"]
```

### 4) Parallelize tests & steps

```groovy
stage('Test Matrix') {
  parallel {
    stage('Unit') { steps { sh 'pytest tests/unit -k "not slow"' } }
    stage('Integration') { steps { sh 'pytest tests/integration' } }
    stage('E2E') { steps { sh './run-e2e.sh' } }
  }
}
```

* Split test suite into shards or use test runner parallelization (`pytest -n`, `maven-surefire-parallel`, Gradle parallel).

### 5) Avoid rebuilding unchanged artifacts (incremental build & artifact reuse)

* Publish artifact on build and *promote* to next stages rather than rebuild:

```groovy
// publish
sh 'jfrog rt upload "target/*.jar" libs/myapp/${BUILD_NUMBER}/'
// downstream consume by version
sh 'jfrog rt download libs/myapp/${BUILD_NUMBER}/*.jar'
```

### 6) Use ephemeral, warmed-up agents or warm pool

* Keep a small pool of warm agents or pre-pulled images to reduce startup time. In Kubernetes, use a node pool with a daemon that pre-pulls images.

### 7) Stash/Unstash wisely (avoid expensive transfer)

* Use `stash` only when necessary. For large artifacts, publish to artifact repo instead of stashing across agents.

```groovy
stash includes: 'build/libs/*.jar', name: 'artifact'
unstash 'artifact'
```

### 8) Reduce I/O / workspace churn

* Clean only necessary paths, reuse caches, set `cleanWs` judiciously.
* Use `agent { docker { args '-v /cache:/cache' } }` to mount caches.

### 9) Limit pipeline blocking and set timeouts

```groovy
options { timeout(time: 60, unit: 'MINUTES') }
```

---

## 📋 Suggested Jenkinsfile (combined optimizations)

```groovy
pipeline {
  agent {
    kubernetes {
      label 'ci-builder'
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: maven
    image: maven:3.9.6-openjdk-17
    volumeMounts:
      - name: m2-cache
        mountPath: /root/.m2
  volumes:
  - name: m2-cache
    persistentVolumeClaim:
      claimName: jenkins-m2-cache
"""
    }
  }

  options { timestamps(); timeout(time:45, unit:'MINUTES') }

  stages {
    stage('Checkout') {
      steps {
        checkout([
          $class: 'GitSCM', branches: [[name: 'main']],
          userRemoteConfigs: [[url: 'git@github.com:org/repo.git']],
          extensions: [[$class: 'CloneOption', depth: 1, shallow: true]]
        ])
      }
    }

    stage('Build & Cache Docker') {
      parallel {
        stage('Build Artifact') {
          steps {
            sh 'mvn -B -DskipTests package'
            sh 'jfrog rt upload "target/*.jar" libs/myapp/${BUILD_NUMBER}/'
          }
        }
        stage('Build Image (buildx cache)') {
          steps {
            sh '''
              docker buildx build --cache-from=type=registry,ref=myrepo/cache:latest \
                --cache-to=type=registry,ref=myrepo/cache:latest,mode=max \
                -t myrepo/myapp:${BUILD_NUMBER} .
              docker push myrepo/myapp:${BUILD_NUMBER}
            '''
          }
        }
      }
    }

    stage('Tests (sharded)') {
      parallel {
        stage('Tests A') { steps { sh 'pytest tests/partA -n 4' } }
        stage('Tests B') { steps { sh 'pytest tests/partB -n 4' } }
      }
    }
  }

  post { always { archiveArtifacts artifacts: 'target/*.jar', fingerprint: true } }
}
```

---

## 📈 Metrics to monitor (what to watch)

* Stage-level durations (avg / p95)
* Agent startup time (cold vs warm)
* Docker image pull + build time
* Checkout time (git clone/wksp)
* Test time per shard & flakiness rate
* Queue time vs execution time (is the bottleneck agents or build steps?)

---

## ✅ Best Practices (practical checklist)

* 🔍 **Measure first** — don’t guess which stage is slow.
* 🧩 **Cache dependencies and Docker layers** (persistent mounts, buildx, Kaniko).
* ⚡ **Parallelize tests & steps**; shard large test suites.
* 📦 **Build once, promote artifact** — avoid rebuilding for each env.
* 🐳 **Use containerized agents** with pinned images for reproducibility.
* 🚀 **Warm agent pool** to cut cold-start time; use autoscale for burst.
* 🔒 **Avoid docker.sock on master**; run builds on dedicated agents.
* 🧹 **Avoid unnecessary workspace cleanup and full checkouts**.
* 🧪 **Fix flaky tests** — they waste retries and time.
* 📊 **Monitor & alert** on p95 durations and queue growth.

---

## 💡 In short

1. **Measure** stage-by-stage.
2. **Cache** dependencies & Docker layers, **shallow/sparse** checkout.
3. **Parallelize** tests and independent stages.
4. **Use containerized, warmed agents** + scale horizontally.
5. **Publish and promote artifacts** instead of rebuilding. ✅

If you want, I can:

* Analyze an example `Jenkinsfile` you use and produce a tuned version, or
* Generate Kubernetes PV/Helm snippets to mount persistent caches (`~/.m2`, npm cache, Docker build cache). Which would you like?

---
---

## Q: Blue/Green deployment with Jenkins

### 🧠 Summary

Blue/Green deployment keeps two identical environments (**blue** = current, **green** = new**) and switches traffic to the green env only after health checks pass — minimizing downtime and making rollback trivial. Jenkins orchestrates build → push → deploy-to-green → verify → switch traffic → cleanup.

---

### ⚙️ Overview

* **Blue** = live environment currently receiving traffic.
* **Green** = new environment where you deploy the new version.
* **Switch** = route traffic from blue → green (load balancer, DNS, service mesh).
* **Rollback** = switch back to blue if green is unhealthy.
* Jenkins automates the whole flow and records provenance (artifact, commit, build number).

---

### 🔁 High-level flow

1. Build artifact & container image. 🧩
2. Push image to registry (ECR/Artifactory/GCR). 📦
3. Deploy image to **green** environment (K8s namespace / new ASG / new target group). ⚙️
4. Run smoke/integration/health checks against green. ✅
5. Switch traffic (LB, DNS, service mesh) from blue → green. 🔀
6. Monitor; if OK, optionally terminate old blue resources; if not, rollback by switching back. ↩️

---

### 📋 When to use Blue/Green

* Need zero-downtime deploys.
* Want instant rollback.
* Can afford duplicate infra for a short period.
* Best for state-light services or when session affinity and DB migrations are handled.

---

### ⚙️ Patterns & Options

| Pattern                           | Traffic switch                                                  | Where to deploy                         |
| --------------------------------- | --------------------------------------------------------------- | --------------------------------------- |
| **Kubernetes (two namespaces)**   | Update Service to point to green Deployment (or switch labels)  | `namespace-blue`, `namespace-green`     |
| **Kubernetes (single namespace)** | Swap service selector labels (`app: blue` → `app: green`)       | single namespace                        |
| **Load Balancer (AWS ALB / NLB)** | Register green targets to target-group and update listener rule | Separate target groups                  |
| **DNS switch**                    | Change DNS A/CNAME to green                                     | Use low TTL or weighted DNS             |
| **Service Mesh**                  | Change routing rules (Istio/Envoy)                              | Use weighted routing for gradual switch |

---

### ⚙️ Jenkins Pipeline — Example (Declarative)

> This pipeline builds, pushes image, deploys to green namespace, runs checks, switches service, and handles rollback.

```groovy
pipeline {
  agent any
  environment {
    IMAGE = "123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:${GIT_COMMIT}"
    GREEN_NS = "myapp-green"
    BLUE_NS  = "myapp-blue"
  }
  stages {
    stage('Build & Push') {
      steps {
        sh 'docker build -t $IMAGE .'
        sh 'aws ecr get-login-password | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com'
        sh 'docker push $IMAGE'
      }
    }

    stage('Deploy to Green') {
      steps {
        sh 'kubectl apply -n $GREEN_NS -f k8s/deployment.yaml --record'
        sh "kubectl set image deployment/myapp -n $GREEN_NS myapp-container=$IMAGE"
      }
    }

    stage('Smoke Tests') {
      steps {
        // run tests against green ingress or service
        sh '''
          GREEN_URL=$(kubectl get svc myapp -n $GREEN_NS -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
          ./scripts/smoke-test.sh "https://$GREEN_URL" || exit 1
        '''
      }
    }

    stage('Switch Traffic') {
      steps {
        script {
          // Atomic operation: switch k8s Service selector from blue -> green
          sh '''
            kubectl patch svc myapp -n default -p '{"spec":{"selector":{"app":"myapp-green"}}}'
          '''
        }
      }
    }

    stage('Post-switch Health') {
      steps {
        sh './scripts/smoke-test.sh "https://myapp.example.com"'
      }
    }
  }

  post {
    failure {
      // rollback: point traffic back to blue
      sh 'kubectl patch svc myapp -n default -p \'{"spec":{"selector":{"app":"myapp-blue"}}}\' || true'
      mail to: 'oncall@example.com', subject: "Deploy failed: ${env.BUILD_URL}", body: "Rolled back to blue"
    }
    success {
      // optional: cleanup blue infra or schedule termination
      sh 'echo "Deployment to green successful; consider cleanup of blue."'
    }
  }
}
```

---

### 🧩 Kubernetes-specific implementations

#### A) Two namespaces + Service switch (recommended small teams)

* Deploy green to `myapp-green` namespace.
* Service in `default` selects by label `env: active` that you toggle (or patch selector).
* Health checks: readiness probes + external smoke tests.

```bash
# switch service selector
kubectl patch svc myapp -n default -p '{"spec":{"selector":{"app":"myapp","env":"green"}}}'
```

#### B) Single namespace label swap

* Blue deployment: label `version=blue`; green deployment: `version=green`.
* Service selector switches `version=green`. Atomic and fast.

```bash
kubectl label deployment myapp-blue version=blue --overwrite
kubectl label deployment myapp-green version=green --overwrite
kubectl patch svc myapp -p '{"spec":{"selector":{"version":"green"}}}'
```

#### C) Use Ingress/ALB with target groups (AWS)

* Create two target groups: `tg-blue`, `tg-green`.
* Register targets for green; when healthy, update ALB listener rule to point to `tg-green`.

AWS CLI example to switch ALB target group in a listener rule:

```bash
aws elbv2 modify-listener --listener-arn arn:... --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:...:targetgroup/tg-green/...
```

---

### 🔒 Health checks & verification (must-haves)

* Service readiness probes on pods.
* External smoke tests: basic API calls, auth, DB connectivity.
* Load / latency checks for a short window (p95, errors).
* Circuit-break: automatic rollback if error rate > threshold within X minutes.

Example health-check script (simple):

```bash
# scripts/smoke-test.sh <url>
set -e
URL=$1
curl -f --max-time 10 "$URL/health" | grep '"status":"ok"' || exit 1
```

---

### ✅ Rollback strategy

* **Immediate rollback**: re-point traffic to blue (patch service or ALB). Fast and predictable.
* **Automated rollback**: Jenkins can run monitoring checks after switch and auto-rollback if thresholds exceeded.
* **Retain blue** for a retention window (e.g., 30 mins–24 hrs) before destroying. Never delete blue until green is proven.

---

### 🧾 Artifact & provenance

* Tag images with `git-sha` + `build-number` and store metadata in artifact repo.
* Record the **which build** and **who approved** the switch in Jenkins build notes.
* Keep `blue` and `green` manifest versions in Git for traceability.

---

### ⚙️ Blue/Green with Helm (value override example)

```bash
# deploy green release
helm upgrade --install myapp-green ./charts/myapp \
  --namespace myapp-green \
  --set image.tag=${IMAGE_TAG} \
  --wait --timeout 5m

# switch service (example service in default namespace uses externalName or selector)
kubectl patch svc myapp -n default -p '{"spec":{"selector":{"release":"myapp-green"}}}'
```

---

### 🧰 Metrics & monitoring to observe after switch

* Error rate (5m / 1m).
* Latency (p95 / p99).
* Request throughput.
* Pod CPU/memory and restarts.
* Logs for exceptions.
* Alerting integration to rollback on anomalies.

---

### ✅ Best Practices & Pitfalls

* ✅ **Build once, deploy many** — don't rebuild for each environment.
* ✅ **Immutable artifacts** — use image digests for production deployments.
* ✅ **Automate health checks** and gating before the traffic switch.
* ✅ **Use low TTL DNS** if using DNS switch; prefer LB or mesh for faster, atomic change.
* ✅ **Avoid DB schema breaking changes** — use backward-compatible migrations (expand-contract).
* ✅ **Keep load balancer/session affinity in mind** (sticky sessions complicate BG). Consider session store externalization.
* ⚠️ **Don't delete blue immediately** — keep for recovery window.
* ⚠️ **Watch for stateful services** — blue/green is easiest for stateless microservices.
* ⚠️ **Network or DNS caching** may delay actual switch — prefer LB or mesh for atomicity.

---

### 📋 Quick cheat-sheet commands

| Action                     | Example                                                                                                       |
| -------------------------- | ------------------------------------------------------------------------------------------------------------- |
| Deploy green via kubectl   | `kubectl apply -n myapp-green -f k8s/`                                                                        |
| Patch k8s Service selector | `kubectl patch svc myapp -p '{"spec":{"selector":{"env":"green"}}}'`                                          |
| Update ALB listener (AWS)  | `aws elbv2 modify-listener --listener-arn <arn> --default-actions Type=forward,TargetGroupArn=<tg-green-arn>` |
| Run smoke test             | `./scripts/smoke-test.sh https://myapp-green.example.com`                                                     |
| Rollback (k8s)             | patch service selector back to blue or rollback helm release `helm rollback ...`                              |

---

### 💡 In short

Blue/Green = deploy new version to a duplicate environment (green) → run health checks → atomically switch traffic to green → monitor → optionally tear down blue.
Use Jenkins to **orchestrate build → deploy → verify → switch → rollback**, prefer LB/mesh-based switches for atomicity, keep blue around for quick rollback, and automate verification to avoid human error. ✅

---
---

## Q: Common Integrations — quick reference

### 🧠 Summary

Common CI/CD integrations (Git host, cloud, container runtime, orchestration, chatops, infra tools) are essential glue for Jenkins pipelines. Below is a compact, practical README-style cheat sheet with commands and snippets you can drop into `Jenkinsfile` or pipeline steps.

---

### ⚙️ Overview

* Use **webhooks** from GitHub/GitLab to trigger pipelines (`checkout scm`).
* Use **cloud CLIs** or provider plugins (AWS Credentials) to authenticate and run actions.
* Use **container agents** to make builds reproducible (`agent { docker { ... } }`).
* Use **Kubernetes plugin** for ephemeral agents and scalable runners.
* Send notifications to Slack/Teams using `slackSend` or connectors.
* Run Terraform from agents with proper state and credential handling.

---

### ✅ Integration Table

| Integration            | Example / Key Command                                        |
| ---------------------- | ------------------------------------------------------------ |
| **GitHub / GitLab**    | Webhook → `checkout scm`                                     |
| **AWS (ECR, EC2, S3)** | `aws` CLI on agent or use AWS Credentials plugin             |
| **Docker**             | `agent { docker { image 'python:3.9' } }`                    |
| **Kubernetes**         | Kubernetes plugin → dynamic agents (pod templates)           |
| **Slack / Teams**      | Notification plugin → `slackSend` / `office365ConnectorSend` |
| **Terraform**          | `sh 'terraform plan && terraform apply -auto-approve'`       |

---

### ⚙️ Example snippets (copy-paste)

#### GitHub / GitLab — Declarative checkout

```groovy
pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        checkout scm   // used in Multibranch / repo Jenkinsfile
      }
    }
  }
}
```

#### AWS — login & push to ECR (in pipeline step)

```groovy
withCredentials([usernamePassword(credentialsId: 'aws-creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
  sh '''
    aws configure set region us-east-1
    aws ecr get-login-password | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com
    docker build -t myapp:${BUILD_NUMBER} .
    docker tag myapp:${BUILD_NUMBER} 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:${BUILD_NUMBER}
    docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/myapp:${BUILD_NUMBER}
  '''
}
```

#### Docker agent — run build inside container

```groovy
pipeline {
  agent {
    docker { image 'python:3.9' }
  }
  stages {
    stage('Test') {
      steps {
        sh 'python -m pytest -q'
      }
    }
  }
}
```

#### Kubernetes dynamic agent — inline podTemplate

```groovy
pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: build
    image: maven:3.9-openjdk-17
    command: ['cat']
    tty: true
"""
    }
  }
  stages { stage('Build'){ steps { container('build'){ sh 'mvn -B package' } } } }
}
```

#### Slack notification

```groovy
post {
  success { slackSend channel: '#ci', message: "✅ ${env.JOB_NAME} #${env.BUILD_NUMBER} succeeded" }
  failure { slackSend channel: '#ci', message: "❌ ${env.JOB_NAME} #${env.BUILD_NUMBER} failed — ${env.BUILD_URL}" }
}
```

#### Terraform (safe pattern)

```groovy
stage('Terraform') {
  steps {
    withCredentials([usernamePassword(credentialsId: 'terraform-aws', usernameVariable: 'AWS_KEY', passwordVariable: 'AWS_SECRET')]) {
      dir('infra') {
        sh '''
          terraform init -input=false
          terraform plan -out=tfplan -input=false -var="image_tag=${IMAGE_TAG}"
          terraform apply -input=false -auto-approve tfplan
        '''
      }
    }
  }
}
```

---

### ✅ Best Practices

* 🔐 Store credentials in Jenkins **Credentials Store**; use `withCredentials`.
* ⚡ Prefer **webhooks** over polling (GitHub App/GitLab integration).
* 🐳 Use **containerized agents** (Docker/K8s) to ensure reproducible builds.
* 🔁 **Build once, deploy many**: push artifacts/images to registry then promote.
* ♻️ Use **Kubernetes plugin** for auto-scaling ephemeral agents; avoid docker.sock exposure on controller.
* 🧾 Keep notification messages concise and include build URL + commit SHA.
* 🧰 Run Terraform under a dedicated service account; store remote state securely (S3 + DynamoDB or Terraform Cloud).

---

### 💡 In short

Use the right connector for each integration: webhooks for Git, provider plugins or CLIs for cloud, Docker/K8s agents for consistent environments, Slack/Teams plugins for notifications, and proper credential management + artifact promotion for reliability. ✅

---
