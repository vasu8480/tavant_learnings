# Jenkins

## Q1: What is Jenkins and what is it used for?

🧠 **Overview**
Jenkins is an open-source automation server used to build, test, package, and deploy applications. It enables CI/CD by orchestrating pipelines that automate the entire lifecycle—from code commit to production rollout.

⚙️ **Purpose / How it works**

* Executes automated jobs or pipelines using agents.
* Integrates with Git, Docker, Kubernetes, AWS, Terraform, etc.
* Triggered by events (Git push), schedules (cron), or manual inputs.

🧩 **Example**

```bash
http://<jenkins-url>:8080
```

💡 **In short**
Jenkins → automation server for CI/CD pipelines.

---

## Q2: What is CI/CD and how does Jenkins enable it?

🧠 **Overview**
CI/CD automates code integration, testing, packaging, and deployment. Jenkins acts as the orchestrator executing each stage through pipelines.

⚙️ **Purpose / How it works**

* **CI** → Auto-build & test on commit.
* **CD** → Auto-deploy to dev/stage/prod.
* Jenkins pipelines define these steps in code (Jenkinsfile).

🧩 **Jenkinsfile snippet**

```groovy
pipeline {
  stages {
    stage('Build') { steps { sh 'mvn clean package' } }
    stage('Deploy') { steps { sh './deploy.sh' } }
  }
}
```

💡 **In short**
CI/CD = automation; Jenkins = engine executing each step.

---

## Q3: What is the difference between Continuous Integration and Continuous Deployment?

📋 **Comparison Table**

| Concept             | What it Does                         | Goal                       | Example                |
| ------------------- | ------------------------------------ | -------------------------- | ---------------------- |
| **CI**              | Integrate code frequently; run tests | Catch issues early         | Auto-build on git push |
| **CD (Deployment)** | Automatically deploy to production   | Ship features continuously | Auto-release to EKS    |

💡 **In short**
CI → integrate & test.
CD → deploy automatically.

---

## Q4: What is a Jenkins job?

🧠 **Overview**
A Jenkins job is a configured task that Jenkins executes—build code, run tests, deploy artifacts, run scripts, etc.

⚙️ **Purpose**
Defines automation logic: scripts, triggers, environment, agents.

🧩 **Example**
Freestyle job running a shell:

```bash
echo "Build started"
```

💡 **In short**
Job = unit of work executed by Jenkins.

---

## Q5: What is the difference between a freestyle project and a pipeline in Jenkins?

📋 **Comparison Table**

| Feature     | Freestyle Project | Pipeline                 |
| ----------- | ----------------- | ------------------------ |
| Definition  | GUI-based         | Code-based (Jenkinsfile) |
| Complexity  | Simple tasks      | Complex CI/CD workflows  |
| Versioning  | Not versioned     | Stored in Git            |
| Scalability | Limited           | Highly scalable          |

💡 **In short**
Freestyle = simple GUI jobs; Pipeline = code-driven automation.

---

## Q6: What is a Jenkins agent?

🧠 **Overview**
Agents (formerly slaves) are worker nodes that run builds and pipelines.

⚙️ **Purpose**
Offload work from the master; run builds on isolated compute: EC2, Kubernetes pods, Docker.

🧩 **Pipeline usage**

```groovy
agent { label 'linux' }
```

💡 **In short**
Agents execute the actual jobs.

---

## Q7: What is the Jenkins master node?

🧠 **Overview**
The master (controller) orchestrates all Jenkins operations—job scheduling, plugin mgmt, UI, and delegating work to agents.

⚙️ **Responsibilities**

* Coordinate builds
* Manage configuration
* Handle API/UI
* Assign tasks to agents

💡 **In short**
Master = brain; agents = workers.

---

## Q8: What is a Jenkins workspace?

🧠 **Overview**
A workspace is a directory on an agent where Jenkins checks out code and runs build steps.

⚙️ **Contains**

* Source code
* Build artifacts
* Temporary files

🧩 **Location example**

```
/var/lib/jenkins/workspace/<job-name>
```

💡 **In short**
Workspace = job’s execution folder.

---

## Q9: What is a build in Jenkins?

🧠 **Overview**
A build is an execution instance of a Jenkins job or pipeline.

⚙️ **Details**

* Each build has logs, artifacts, timestamps.
* Builds are sequentially numbered: #1, #2, etc.

💡 **In short**
Build = run of a job.

---

## Q10: What are Jenkins plugins?

🧠 **Overview**
Plugins extend Jenkins with integrations (Git, Docker, AWS, Kubernetes) and UI/functionality enhancements.

⚙️ Examples

* Git plugin
* Pipeline plugin
* Kubernetes plugin
* Credentials plugin

💡 **In short**
Plugins add integrations & features.

---

## Q11: How do you install plugins in Jenkins?

🧠 **Overview**
Plugins are installed via the Jenkins UI or by uploading `.hpi`/`.jpi` files.

🧩 **UI Path**
**Manage Jenkins → Manage Plugins → Available → Install**

🧩 **CLI install**

```bash
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin git
```

💡 **In short**
Install via UI or CLI; restart if required.

---

## Q12: What is the Jenkins home directory?

🧠 **Overview**
`JENKINS_HOME` holds all Jenkins configuration and job/state data.

🧩 **Typical path**

```
/var/lib/jenkins
```

💡 **In short**
JENKINS_HOME = core config + jobs + plugins.

---

## Q13: What files are stored in JENKINS_HOME?

📋 **Contents Table**

| Component        | Location / File       |
| ---------------- | --------------------- |
| Jobs             | `jobs/<job-name>/`    |
| Pipeline scripts | `jobs/<job>/workflow` |
| Plugins          | `plugins/*.jpi`       |
| Credentials      | `credentials.xml`     |
| Global config    | `config.xml`          |
| Build history    | `jobs/<job>/builds/`  |

💡 **In short**
Everything Jenkins needs lives in JENKINS_HOME.

---

## Q14: What is a build trigger in Jenkins?

🧠 **Overview**
A build trigger automatically starts a job based on an event or schedule.

⚙️ **Purpose**

* Automate build execution
* Remove need for manual start

💡 **In short**
Trigger = automatic job starter.

---

## Q15: What are the common build triggers available in Jenkins?

📋 **List**

| Trigger Type         | Example                   |
| -------------------- | ------------------------- |
| SCM Polling          | `* * * * *`               |
| Webhook              | GitHub/GitLab push events |
| Cron schedule        | Nightly builds            |
| Manual               | "Build Now" button        |
| Upstream job trigger | Chain pipelines           |

💡 **In short**
Triggers detect events & kick off builds.

---

## Q16: What is SCM polling in Jenkins?

🧠 **Overview**
SCM polling checks Git/SVN for changes at a defined schedule and triggers a build if differences exist.

⚙️ **How it works**

* Jenkins runs a "git ls-remote" or fetch.
* Compares last commit hash with current.
* Triggers build only on change.

🧩 **Example cron**

```
H/2 * * * *
```

💡 **In short**
SCM polling = Jenkins periodically checks Git for new commits.

---

## Q17: What is a webhook and how does it trigger Jenkins builds?

🧠 **Overview**
A webhook is an HTTP callback sent by a source system (GitHub, GitLab, Bitbucket) to Jenkins whenever an event occurs—usually a code push or merge. It triggers Jenkins instantly without waiting for polling.

⚙️ **How it works**

* Git provider sends a POST request to Jenkins endpoint:
  `http://<jenkins-url>/github-webhook/`
* Jenkins validates the event and triggers configured jobs.

🧩 **GitHub example**
**Settings → Webhooks → Add Webhook → Payload URL**

```
http://jenkins.example.com/github-webhook/
```

💡 **In short**
Webhook = push → Jenkins notified instantly → build triggered.

---

## Q18: What is the difference between polling and webhooks?

📋 **Comparison Table**

| Feature       | Polling                         | Webhooks                    |
| ------------- | ------------------------------- | --------------------------- |
| Mechanism     | Jenkins checks Git periodically | Git pushes event to Jenkins |
| Trigger delay | Depends on schedule             | Real-time                   |
| Load          | Higher (frequent checks)        | Low (event-driven)          |
| Best use      | Legacy SCMs                     | Modern Git platforms        |

💡 **In short**
Polling pulls → slow & heavy.
Webhooks push → fast & efficient.

---

## Q19: What is a Jenkins build parameter?

🧠 **Overview**
Build parameters allow users to pass dynamic inputs to jobs or pipelines—environment values, choices, file paths, toggles.

⚙️ **Purpose**

* Customize deploys (env=dev/prod)
* Control pipeline behavior (feature toggles)

🧩 **Example**

```groovy
parameters {
  string(name: 'ENV', defaultValue: 'dev')
}
```

💡 **In short**
Parameters = runtime inputs to builds.

---

## Q20: What types of build parameters are available in Jenkins?

📋 **Common Parameter Types**

| Parameter Type | Example Use           |
| -------------- | --------------------- |
| String         | Environment name      |
| Choice         | Select cluster/region |
| Boolean        | Toggle tests on/off   |
| File           | Upload config         |
| Credentials    | AWS/SSH creds         |
| Password       | Hidden secrets        |

🧩 Example:

```groovy
parameters {
  choice(name: 'REGION', choices: ['us-east-1', 'ap-south-1'])
}
```

💡 **In short**
Jenkins supports multiple input types for flexible job execution.

---

## Q21: What is a post-build action?

🧠 **Overview**
Post-build actions are tasks Jenkins performs after the main job completes—publish artifacts, notify teams, archive logs, run other jobs.

🧩 **Examples**

* Archive artifacts
* Email notifications
* Trigger downstream jobs
* Publish JUnit results

💡 **In short**
Post-build actions extend job execution after the build finishes.

---

## Q22: What is the Jenkins Blue Ocean interface?

🧠 **Overview**
Blue Ocean is a modern UI layer for Jenkins offering visual pipeline graphs, improved UX, and simplified troubleshooting.

⚙️ **Features**

* Visual pipeline stages
* Better error navigation
* Branch & PR awareness (multibranch pipelines)

💡 **In short**
Blue Ocean = modern, visual UI for Jenkins pipelines.

---

## Q23: What is the difference between declarative and scripted pipelines?

📋 **Comparison Table**

| Feature        | Declarative Pipeline    | Scripted Pipeline |
| -------------- | ----------------------- | ----------------- |
| Syntax         | Structured, opinionated | Groovy-based      |
| Complexity     | Easier                  | More flexible     |
| Error handling | Built-in                | Custom            |
| Use Case       | Standard CI/CD          | Complex logic     |

🧩 Snippets
**Declarative**

```groovy
pipeline { agent any; stages { stage('Build'){ steps{ sh 'make' } } } }
```

**Scripted**

```groovy
node { stage('Build'){ sh 'make' } }
```

💡 **In short**
Declarative = simple & structured; Scripted = powerful & flexible.

---

## Q24: What is a Jenkinsfile?

🧠 **Overview**
A Jenkinsfile is a text file defining a Jenkins pipeline as code—build, test, deploy steps.

⚙️ **Purpose**

* Version control CI/CD
* Enable reproducible, reviewable pipelines
* Required for multibranch pipelines

💡 **In short**
Jenkinsfile = pipeline as code.

---

## Q25: Where should you store the Jenkinsfile?

🧠 **Overview**
Store Jenkinsfile in the root of the application's Git repository.

⚙️ **Why**

* Versioned with code
* Changes tracked through PRs
* Auto-detected by multibranch pipelines

💡 **In short**
Always store Jenkinsfile in Git.

---

## Q26: What is the purpose of the pipeline syntax generator?

🧠 **Overview**
It generates valid pipeline snippets for steps, agents, environment, and stages—helpful for learning and reducing syntax errors.

🧩 **Path**
**Jenkins UI → Pipeline Syntax**

💡 **In short**
Syntax generator = assistant for writing pipeline code.

---

## Q27: What is Jenkins credentials plugin?

🧠 **Overview**
It manages secure storage and usage of secrets—passwords, SSH keys, AWS keys, tokens.

⚙️ **Features**

* Encryption at rest
* Scoped credentials (system/folder/job)
* API for pipelines

💡 **In short**
Credentials plugin stores secrets securely.

---

## Q28: How do you store secrets in Jenkins?

🧠 **Overview**
Secrets are stored using the Credentials plugin with proper scopes and types.

🧩 **Pipeline access example**

```groovy
withCredentials([string(credentialsId: 'aws-token', variable: 'TOKEN')]) {
  sh 'aws s3 ls --token $TOKEN'
}
```

💡 **In short**
Store secrets under *Manage Credentials* and access via pipeline blocks.

---

## Q29: What is the Jenkins CLI?

🧠 **Overview**
A command-line interface to control Jenkins remotely—manage jobs, builds, plugins.

🧩 **Examples**

```bash
java -jar jenkins-cli.jar -s http://jenkins:8080 list-jobs
java -jar jenkins-cli.jar -s http://jenkins:8080 build my-job
```

💡 **In short**
CLI = remote automation interface for Jenkins.

---

## Q30: How do you backup Jenkins?

🧠 **Overview**
Backup the `JENKINS_HOME` directory or use plugins like ThinBackup.

🧩 **Example**

```bash
tar -czvf jenkins-backup.tgz /var/lib/jenkins
```

💡 **In short**
Backup = archive JENKINS_HOME.

---

## Q31: What needs to be backed up in Jenkins?

📋 **Components to Backup**

| Component         | Why                     |
| ----------------- | ----------------------- |
| `jobs/`           | Pipelines & job configs |
| `config.xml`      | Global configuration    |
| `plugins/`        | Plugin state            |
| `credentials.xml` | Encrypted secrets       |
| `users/`          | Jenkins user accounts   |
| `nodes/`          | Agent configurations    |

💡 **In short**
Backup everything inside JENKINS_HOME.

---

## Q32: What is a Jenkins view?

🧠 **Overview**
A view is a dashboard grouping related jobs for visibility and organization.

⚙️ **Examples**

* Team-specific view
* Service-specific view
* Environment-specific view (dev/stage/prod)

💡 **In short**
View = filtered dashboard for organizing jobs.

---

## Q33: What is the difference between list view and pipeline view?

📋 **Comparison Table**

| View Type         | Purpose                         | Example                       |
| ----------------- | ------------------------------- | ----------------------------- |
| **List View**     | Shows jobs in table format      | Job names, status             |
| **Pipeline View** | Visual graph of pipeline stages | Multistage pipeline execution |

💡 **In short**
List = job summary; Pipeline = visual pipeline execution graph.

---

## Q34: What is Jenkins shared library?

🧠 **Overview**
A shared library stores reusable pipeline code (functions, vars, classes) that teams can include across pipelines.

⚙️ **Use cases**

* Reuse deploy logic
* Standardize CI/CD patterns
* Centralize pipeline utilities

🧩 **Usage**

```groovy
@Library('my-shared-lib') _
deployApp()
```

💡 **In short**
Shared library = reusable pipeline codebase.

---

## Q35: What is the purpose of the Jenkinsfile agent directive?

🧠 **Overview**
The `agent` directive defines where the pipeline stages will run—any node, label, Docker container, or Kubernetes pod.

🧩 **Examples**

```groovy
agent any
agent { label 'linux' }
agent { docker { image 'maven:3.8' } }
```

💡 **In short**
Agent = execution environment selector.

---

## Q36: What is the stages section in a declarative pipeline?

🧠 **Overview**
`stages` groups the sequence of steps into logical units like Build, Test, Deploy.

🧩 **Example**

```groovy
stages {
  stage('Build') { steps { sh 'make' } }
  stage('Deploy') { steps { sh './deploy.sh' } }
}
```

💡 **In short**
Stages = pipeline workflow sections.

---

## Q37: What is the steps section in Jenkins pipeline?

🧠 **Overview**
`steps` define the actual actions executed inside a stage—shell commands, checkout, Docker commands.

🧩 **Example**

```groovy
steps {
  sh 'npm install'
}
```

💡 **In short**
Steps = executable actions.

---

## Q38: What are environment variables in Jenkins?

🧠 **Overview**
Environment variables store key/value data available to the pipeline—branch name, build number, credentials, and user-defined variables.

🧩 **Example**

```groovy
environment {
  ENV = "dev"
}
```

💡 **In short**
Env vars = dynamic configuration values.

---

## Q39: How do you access environment variables in a pipeline?

🧠 **Overview**
Access them using `$VAR`, `${VAR}`, or `env.VAR`.

🧩 **Examples**

```groovy
sh 'echo $BUILD_NUMBER'
echo env.ENV
```

💡 **In short**
Access via shell `$VAR` or Groovy `env.VAR`.

---

## Q40: What is the difference between node and agent in Jenkins?

📋 **Comparison Table**

| Term      | Meaning                                                         | Used In            |
| --------- | --------------------------------------------------------------- | ------------------ |
| **node**  | Scripted pipeline block representing an executor                | Scripted syntax    |
| **agent** | Declarative pipeline directive specifying execution environment | Declarative syntax |

🧠 **Explanation**

* `node` manually allocates executors and workspace.
* `agent` is simpler and declarative (`any`, `label`, `docker`, `kubernetes`).

🧩 Examples
**Declarative**

```groovy
agent any
```

**Scripted**

```groovy
node('linux') { ... }
```

💡 **In short**
Agent = declarative abstraction; Node = scripted executor control.

---

## Q41: How do you configure master-agent communication in Jenkins?

🧠 **Overview**
Master-agent communication lets Jenkins delegate jobs to distributed worker nodes. Configuration depends on the agent type (SSH or JNLP).

⚙️ **How it works**

* Master authenticates with agent.
* Creates a communication channel to send tasks, env vars, and receive logs.
* Uses encrypted tunnels when configured.

🧩 **Common setup methods**

* SSH: master → agent
* JNLP: agent → master (pull mode)

💡 **In short**
Configure via SSH or JNLP to allow remote nodes to run Jenkins jobs.

---

## Q42: What protocols can be used for agent communication (JNLP, SSH)?

📋 **Comparison Table**

| Protocol | Direction      | Use Case                      | Notes                           |
| -------- | -------------- | ----------------------------- | ------------------------------- |
| **SSH**  | Master → Agent | Secure Linux agents           | Preferred in most environments  |
| **JNLP** | Agent → Master | Cloud, behind-firewall agents | Uses Java Web Start / agent.jar |

💡 **In short**
SSH = push mode.
JNLP = pull mode.

---

## Q43: How do you add a new agent to Jenkins?

🧠 **Overview**
Agents are added via **Manage Jenkins → Manage Nodes → New Node**.

🧩 **Steps**

1. Create new node → name → Permanent Agent.
2. Configure workspace path, labels, executors.
3. Choose launch method (SSH or JNLP).
4. Save → Jenkins connects to agent.

🧩 **SSH agent example**

```bash
sudo useradd jenkins
sudo mkdir /home/jenkins/agent
```

💡 **In short**
Create a node, define labels, choose protocol, connect.

---

## Q44: What are agent labels and how are they used?

🧠 **Overview**
Labels categorize agents by capability—OS, tools, region, environment.

⚙️ **Purpose**

* Route jobs to appropriate agents
* Manage infra capacity

🧩 **Example**

```groovy
agent { label 'docker-node' }
```

💡 **In short**
Labels let Jenkins target specific agents.

---

## Q45: How do you restrict jobs to run on specific agents?

🧠 **Overview**
Use agent labels in the pipeline or restrict settings in freestyle jobs.

🧩 **Declarative Pipeline**

```groovy
agent { label 'linux' }
```

🧩 **Freestyle Job**
**Restrict where this project can run → Label Expression: `linux`**

💡 **In short**
Assign a label → target the job to that label.

---

## Q46: What is the difference between permanent and cloud agents?

📋 **Comparison Table**

| Type                | Description                          | Best Use                        |
| ------------------- | ------------------------------------ | ------------------------------- |
| **Permanent Agent** | Static server always available       | On-prem, long-running workloads |
| **Cloud Agent**     | Ephemeral, auto-provisioned in cloud | Kubernetes, EC2, scalable CI/CD |

💡 **In short**
Permanent = static. Cloud = on-demand.

---

## Q47: How does Jenkins integrate with Docker for agents?

🧠 **Overview**
Jenkins uses Docker as an agent runtime, creating isolated build containers on demand.

⚙️ **Methods**

* Docker Pipeline plugin
* Docker Agent directive
* Docker Cloud plugin (connects to Docker hosts)

🧩 **Example**

```groovy
agent { docker { image 'maven:3.8' } }
```

💡 **In short**
Docker provides clean, reproducible build environments.

---

## Q48: What is the Docker Pipeline plugin?

🧠 **Overview**
It enables Jenkins to run build steps inside Docker images and manage containers programmatically.

🧩 **Capabilities**

* Run builds in Docker
* Build/push Docker images
* Use Docker volumes/networks

🧩 Example

```groovy
docker.image('node:18').inside {
  sh 'npm test'
}
```

💡 **In short**
Docker Pipeline plugin = Docker-native pipelines.

---

## Q49: How do you run builds inside Docker containers?

🧠 **Overview**
Use the Docker agent in declarative pipelines or `inside{}` in scripted pipelines.

🧩 **Declarative**

```groovy
agent { docker { image 'python:3.10' } }
```

🧩 **Scripted**

```groovy
docker.image('alpine').inside { sh 'echo Hello' }
```

💡 **In short**
Specify a Docker image → Jenkins runs all steps inside it.

---

## Q50: What is the Kubernetes plugin for Jenkins?

🧠 **Overview**
The Kubernetes plugin provisions ephemeral Jenkins agents as Kubernetes pods.

⚙️ **Features**

* Auto-scale agents
* Pod templates with containers
* Seamless integration with Jenkinsfile

💡 **In short**
Kubernetes plugin = dynamic pod-based Jenkins agents.

---

## Q51: How do you configure Jenkins to use Kubernetes pods as agents?

🧠 **Overview**
Install the Kubernetes plugin and configure a Kubernetes Cloud.

🧩 **Steps**

1. Add cloud: **Manage Jenkins → Cloud → Kubernetes**
2. Enter API server URL & credentials
3. Define default namespace
4. Create pod templates with containers
5. Use `agent { kubernetes { ... } }` in pipelines

🧩 **Pipeline example**

```groovy
agent {
  kubernetes {
    yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: maven
    image: maven:3.8
"""
  }
}
```

💡 **In short**
Configure Kubernetes cloud → define pod template → reference in pipeline.

---

## Q52: What are the advantages of using ephemeral agents?

📋 **Benefits**

| Advantage         | Why It Matters           |
| ----------------- | ------------------------ |
| Clean environment | No leftover artifacts    |
| Scalability       | Auto-provision on demand |
| Cost efficient    | Pay only when used       |
| Security          | Isolation per job        |

💡 **In short**
Ephemeral = clean, scalable, cost-efficient agents.

---

## Q53: How do you define agent templates in Kubernetes?

🧠 **Overview**
Pod templates define what containers, tools, and resources an agent pod will have.

🧩 **Example YAML**

```yaml
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: build
      image: maven:3.8
      command: ["cat"]
      tty: true
```

🧩 **Pipeline reference**

```groovy
agent { kubernetes { yamlFile 'pod.yaml' } }
```

💡 **In short**
Define pod spec → Jenkins provisions pods based on it.

---

## Q54: What is Jenkins Configuration as Code (JCasC)?

🧠 **Overview**
JCasC configures Jenkins using YAML instead of clicking in the UI.

⚙️ **Purpose**

* Fully automate Jenkins setup
* Version control configuration
* Immutable Jenkins environments

💡 **In short**
JCasC = Jenkins configured by YAML.

---

## Q55: How do you configure Jenkins using YAML with JCasC?

🧠 **Overview**
Provide a YAML file to Jenkins at startup via the JCasC plugin.

🧩 **Example `jenkins.yaml`**

```yaml
jenkins:
  systemMessage: "Configured via JCasC"
unclassified:
  location:
    url: "http://jenkins.local"
```

🧩 **Environment variable**

```
CASC_JENKINS_CONFIG=/config/jenkins.yaml
```

💡 **In short**
Place YAML → point JCasC to it → Jenkins auto-configures at startup.

---

## Q56: What are the benefits of using JCasC?

📋 **Benefits**

| Benefit                    | Why                            |
| -------------------------- | ------------------------------ |
| Version-controlled config  | Track & rollback changes       |
| Automated provisioning     | Create Jenkins reliably        |
| Eliminates manual UI setup | Consistent across environments |
| Enables GitOps             | Git-driven Jenkins management  |

💡 **In short**
JCasC = reliable, repeatable, Git-driven Jenkins configuration.

---

## Q57: How do you manage Jenkins plugins with JCasC?

🧠 **Overview**
Plugins are listed in a YAML file or a plugin manifest, and Jenkins installs them automatically.

🧩 **Example**
`plugins.yaml`

```yaml
plugins:
  - id: git
  - id: workflow-aggregator
  - id: kubernetes
```

💡 **In short**
Declare plugins in YAML → Jenkins installs them on startup.

---

## Q58: What is the purpose of the when directive in declarative pipelines?

🧠 **Overview**
`when` adds conditional logic—controls if a stage should run.

🧩 **Example**

```groovy
stage('Deploy') {
  when { branch 'main' }
  steps { sh './deploy.sh' }
}
```

💡 **In short**
`when` = conditional stage execution.

---

## Q59: How do you implement conditional execution in pipelines?

🧠 **Overview**
Use `when` (declarative) or Groovy `if` blocks (scripted).

🧩 **Declarative**

```groovy
when {
  expression { return env.ENV == 'prod' }
}
```

🧩 **Scripted**

```groovy
if (env.BRANCH_NAME == 'main') {
  sh './deploy.sh'
}
```

💡 **In short**
Use `when` in declarative pipelines; use `if` in scripted pipelines.

---

## Q60: What is the input step in Jenkins pipeline?

🧠 **Overview**
`input` pauses the pipeline and waits for human approval or user-provided values.

🧩 **Example**

```groovy
stage('Approval') {
  steps {
    input message: "Approve deployment?"
  }
}
```

⚙️ **Use cases**

* Manual deployment approvals
* Human validation before destructive actions

💡 **In short**
`input` = manual pause + approval.

---

## Q61: How do you implement approval gates in pipelines?

🧠 **Overview**
Use the `input` step or external approval systems via plugins.

🧩 **Declarative Example**

```groovy
stage('Deploy Approval') {
  steps {
    script {
      input(id: 'DeployGate', message: 'Deploy to prod?')
    }
  }
}
```

🧩 **With role-based access**

```groovy
input message: 'Approve?', submitter: 'ops-team'
```

💡 **In short**
Approval gates = `input` + restricted submitter.

---

## Q62: What is the parallel directive in Jenkins pipelines?

🧠 **Overview**
`parallel` lets multiple branches run simultaneously within a stage.

🧩 **Example**

```groovy
stage('Tests') {
  parallel {
    unit { steps { sh 'pytest' } }
    integration { steps { sh './run-integration.sh' } }
  }
}
```

💡 **In short**
`parallel` = concurrent execution of branches.

---

## Q63: How do you execute multiple stages concurrently?

🧠 **Overview**
Use the `parallel` directive. Each branch is its own mini-stage.

🧩 **Example**

```groovy
stage('Parallel Builds') {
  parallel {
    buildA { steps { sh './build-a.sh' } }
    buildB { steps { sh './build-b.sh' } }
  }
}
```

💡 **In short**
Wrap multiple branches inside a `parallel` block.

---

## Q64: What are pipeline options in declarative pipelines?

🧠 **Overview**
`options` define pipeline-wide behaviors like timeouts, retry, timestamps, concurrency, or log limits.

🧩 **Example**

```groovy
options {
  timeout(time: 20, unit: 'MINUTES')
  buildDiscarder(logRotator(numToKeepStr: '10'))
}
```

💡 **In short**
`options` = global pipeline settings.

---

## Q65: What is the timeout option and when would you use it?

🧠 **Overview**
`timeout` stops a stage or pipeline if it runs too long—protects against hung jobs.

🧩 **Example**

```groovy
timeout(time: 10, unit: 'MINUTES') {
  sh './deploy.sh'
}
```

⚙️ **Use cases**

* Stuck deployments
* Long-running tests
* External system delays

💡 **In short**
`timeout` prevents pipelines from hanging indefinitely.

---

## Q66: How do you implement retry logic in Jenkins pipelines?

🧠 **Overview**
Use `retry` to re-run a block on failure.

🧩 **Example**

```groovy
retry(3) {
  sh 'curl http://unstable-endpoint'
}
```

⚙️ **Use cases**

* Flaky network requests
* Temporary infra failures

💡 **In short**
`retry(n)` re-runs failing steps automatically.

---

## Q67: What is the post section in declarative pipelines?

🧠 **Overview**
`post` defines actions that run after a stage or pipeline completes.

🧩 **Example**

```groovy
post {
  always { echo 'Cleanup' }
  success { echo 'Success!' }
  failure { echo 'Failed!' }
}
```

💡 **In short**
`post` = cleanup + notifications after pipeline execution.

---

## Q68: What post conditions are available (always, success, failure, unstable)?

📋 **Post Condition Table**

| Condition    | Runs When                                |
| ------------ | ---------------------------------------- |
| **always**   | Every build outcome                      |
| **success**  | Status = SUCCESS                         |
| **failure**  | Status = FAILURE                         |
| **unstable** | Tests failed or warnings                 |
| **aborted**  | Manually stopped pipeline                |
| **changed**  | Build status changed from previous build |

💡 **In short**
Post blocks handle notifications, cleanup, and finalization.

---

## Q69: How do you send notifications from Jenkins pipelines?

🧠 **Overview**
Use email, Slack, Teams, or custom webhooks in `post` blocks.

🧩 **Email Example**

```groovy
post {
  failure {
    mail to: 'team@example.com',
         subject: "Build Failed",
         body: "Check Jenkins for details."
  }
}
```

🧩 **Slack Example**

```groovy
slackSend channel: '#ci-alerts', message: "Build failed: ${env.BUILD_URL}"
```

💡 **In short**
Use post conditions + notification plugins.

---

## Q70: What is the Email Extension plugin?

🧠 **Overview**
A powerful plugin for email notifications with templates, attachments, triggers, and customizable content.

🧩 **Example**

```groovy
emailext subject: "Job ${JOB_NAME} Failed",
         body: "Build URL: ${BUILD_URL}",
         to: "ops@example.com"
```

💡 **In short**
Enhanced, flexible email notifications.

---

## Q71: How do you integrate Jenkins with Slack?

🧠 **Overview**
Use the Slack Notification plugin and configure a Slack App webhook.

🧩 **Pipeline Example**

```groovy
slackSend channel: '#alerts', message: "Build #${BUILD_NUMBER}: ${currentBuild.currentResult}"
```

🧩 **Setup**

1. Install Slack plugin
2. Add Slack workspace + token
3. Use `slackSend` in pipelines

💡 **In short**
Slack plugin + pipeline steps = CI/CD notifications in Slack.

---

## Q72: How do you send build status to GitHub/GitLab?

🧠 **Overview**
Use SCM status APIs exposed via Jenkins plugins.

🧩 **GitHub Example**

```groovy
step([$class: 'GitHubCommitStatusSetter',
      state: 'SUCCESS',
      description: 'Build passed',
      context: 'ci/jenkins'])
```

🧩 **GitLab Example**

```groovy
gitlabBuilds(builds: ["test"]) {
  sh 'pytest'
}
```

💡 **In short**
Use GitHub/GitLab integration plugins to update commit status.

---

## Q73: What is multibranch pipeline in Jenkins?

🧠 **Overview**
A multibranch pipeline automatically discovers SCM branches and creates pipelines for each branch based on its Jenkinsfile.

⚙️ **Capabilities**

* Automatic branch creation/deletion
* Independent pipelines per branch
* PR builds supported

💡 **In short**
Multibranch pipeline = Jenkinsfile-driven CI for all branches.

---

## Q74: How does multibranch pipeline discover branches?

🧠 **Overview**
It scans the repository using branch sources (GitHub, GitLab, Bitbucket) and creates jobs for branches with a Jenkinsfile.

⚙️ **Mechanism**

* API calls to SCM
* Branch matching rules
* Jenkinsfile detection

💡 **In short**
SCM scan → detect branches → create pipelines automatically.

---

## Q75: What is branch indexing in multibranch pipelines?

🧠 **Overview**
Branch indexing is the scanning process Jenkins performs to discover new branches, delete removed ones, and update pipeline configuration.

🧩 **Triggers**

* SCM webhook
* Scheduled scan
* Manual "Scan Now"

💡 **In short**
Branch indexing keeps multibranch pipelines in sync with Git.

---

## Q76: How do you configure different behavior for different branches?

🧠 **Overview**
Use the `when` directive, branch conditions, or separate Jenkinsfiles (if needed).

🧩 **Example**

```groovy
stage('Deploy') {
  when { branch 'main' }
  steps { sh './deploy-prod.sh' }
}
```

🧩 **Multiple branch rules**

```groovy
when {
  anyOf {
    branch 'dev'
    branch 'staging'
  }
}
```

💡 **In short**
Use `when` + branch conditions to customize behavior.

---

## Q77: What is the difference between multibranch pipeline and organization folder?

📋 **Comparison Table**

| Feature    | Multibranch Pipeline    | Organization Folder             |
| ---------- | ----------------------- | ------------------------------- |
| Scope      | One repo                | Entire GitHub/GitLab org        |
| Discovers  | Branches & PRs          | Repositories + branches         |
| Use Case   | CI/CD for a single repo | Large teams with many repos     |
| Automation | Jenkinsfile per branch  | Auto-creates jobs for each repo |

💡 **In short**
Multibranch = 1 repo, multiple branches.
Org Folder = scans entire organization.

---

## Q78: How do you scan GitHub organizations for repositories?

🧠 **Overview**
Use **Organization Folder** + GitHub Branch Source plugin.

🧩 **Steps**

1. New Item → *GitHub Organization*.
2. Add GitHub credentials.
3. Configure repository discovery rules.
4. Jenkins scans the org → creates multibranch pipelines.

💡 **In short**
Create GitHub Organization → Jenkins auto-discovers repos.

---

## Q79: What is the Blue Ocean pipeline editor?

🧠 **Overview**
A visual pipeline builder/editor that simplifies creating Jenkinsfiles without writing Groovy manually.

⚙️ **Features**

* Drag-and-drop pipeline stages
* Visual Jenkinsfile generator
* Real-time validation

💡 **In short**
Blue Ocean editor = GUI for building pipelines.

---

## Q80: How do you visualize pipeline execution in Jenkins?

🧠 **Overview**
Use the classic **Stage View**, **Blue Ocean UI**, or **Pipeline Graph View**.

🧩 **Typical View**

* Stage-wise execution timeline
* Parallel execution visualization
* Error highlighting

💡 **In short**
Jenkins shows visual graphs of stage execution via Blue Ocean or Stage View.

---

## Q81: What is Jenkins shared library and why use it?

🧠 **Overview**
A shared library centralizes reusable pipeline logic (functions, utilities, templates).

⚙️ **Benefits**

* DRY pipelines
* Standardized CI/CD logic
* Easy updates across teams

💡 **In short**
Shared library = reusable pipeline codebase for all Jenkinsfiles.

---

## Q82: How do you create a shared library?

🧠 **Overview**
Create a Git repository with a predefined structure.

🧩 **Repo Structure**

```
(root)
 ├── vars/
 ├── src/
 └── resources/
```

🧩 **Jenkins Setup**

* Manage Jenkins → Configure System → Global Pipeline Libraries
* Add library name + Git URL

💡 **In short**
Create library repo → add vars/src → register in Jenkins.

---

## Q83: What is the structure of a shared library (vars, src, resources)?

📋 **Folder Structure**

| Folder       | Purpose                                |
| ------------ | -------------------------------------- |
| `vars/`      | Global pipeline steps (Groovy scripts) |
| `src/`       | Classes & packages (groovy/java)       |
| `resources/` | Templates, YAML, JSON files            |

🧩 **Example**

```
vars/buildApp.groovy
src/com/company/utils/Logger.groovy
resources/templates/deploy.yaml
```

💡 **In short**
vars = steps; src = classes; resources = templates.

---

## Q84: How do you load a shared library in a Jenkinsfile?

🧠 **Overview**
Use `@Library` or `library` step.

🧩 **Example**

```groovy
@Library('my-shared-lib') _
buildApp()
```

💡 **In short**
Reference the library → call its functions.

---

## Q85: What is the difference between @Library and library step?

📋 **Comparison Table**

| Feature | @Library               | library step           |
| ------- | ---------------------- | ---------------------- |
| Syntax  | Annotation             | Function               |
| Scope   | Whole Jenkinsfile      | Within pipeline script |
| Use     | Declarative & Scripted | Scripted pipelines     |

🧩 **Example**

```groovy
@Library('common') _
library 'common'
```

💡 **In short**
`@Library` loads at top; `library()` loads dynamically.

---

## Q86: How do you version shared libraries?

🧠 **Overview**
Use Git branches, tags, or commit hashes.

🧩 **Example**

```groovy
@Library('my-lib@v1.2.0') _
```

⚙️ Supported formats

* `@main`
* `@feature/xyz`
* `@abcdef1234` (commit)

💡 **In short**
Specify library version using Git refs.

---

## Q87: What are global variables in shared libraries?

🧠 **Overview**
Global vars are Groovy scripts in `vars/` acting as callable pipeline steps.

🧩 **Example**
`vars/deployApp.groovy`

```groovy
def call() {
  sh './deploy.sh'
}
```

🧩 Usage

```groovy
deployApp()
```

💡 **In short**
Global vars = reusable pipeline functions.

---

## Q88: How do you create reusable pipeline steps?

🧠 **Overview**
Define them in `vars/` folder or write Groovy functions/classes inside shared libraries.

🧩 **Example**
`vars/testSuite.groovy`

```groovy
def call(String type) {
  sh "run-tests --type ${type}"
}
```

Usage:

```groovy
testSuite('integration')
```

💡 **In short**
Define a global var → call it like a function.

---

## Q89: What is the credentials binding plugin?

🧠 **Overview**
It injects credentials into environment variables or Groovy variables securely.

⚙️ **Supported bindings**

* Username/password
* Secret text
* SSH keys
* AWS credentials

💡 **In short**
Credentials Binding plugin safely injects secrets into pipelines.

---

## Q90: How do you use credentials in pipelines securely?

🧠 **Overview**
Use `withCredentials` to scope secret usage.

🧩 **Example**

```groovy
withCredentials([string(credentialsId: 'aws-token', variable: 'TOKEN')]) {
  sh 'aws s3 ls --token $TOKEN'
}
```

💡 **In short**
Use `withCredentials` block + minimal scope.

---

## Q91: What credential types does Jenkins support?

📋 **Common Types**

| Type                | Example              |
| ------------------- | -------------------- |
| Username + Password | Docker registry, Git |
| Secret Text         | API tokens           |
| SSH Private Key     | Git access           |
| AWS Credentials     | Access/secret key    |
| Certificates        | SSL keystore         |

💡 **In short**
Jenkins supports all major authentication secret types.

---

## Q92: How do you inject credentials as environment variables?

🧠 **Overview**
Using `withCredentials` + environment mapping.

🧩 **Example**

```groovy
withCredentials([usernamePassword(credentialsId: 'docker-creds',
                                  usernameVariable: 'USER',
                                  passwordVariable: 'PASS')]) {
  sh 'docker login -u $USER -p $PASS'
}
```

💡 **In short**
Map credentials → env vars → use inside block.

---

## Q93: What is the withCredentials step?

🧠 **Overview**
A wrapper step that temporarily exposes secrets for the enclosed block.

🧩 **Example**

```groovy
withCredentials([sshUserPrivateKey(credentialsId: 'git-key', keyFileVariable: 'SSH_KEY')]) {
  sh 'git clone git@github.com:repo.git'
}
```

💡 **In short**
`withCredentials` safely injects secrets for a limited scope.

---

## Q94: How do you mask sensitive data in console output?

🧠 **Overview**
Jenkins automatically masks values injected via `withCredentials`.
Additional masking can be done via the **Mask Passwords Plugin**.

🧩 **Example**

```groovy
withCredentials([string(credentialsId: 'token', variable: 'TOKEN')]) {
  sh 'curl -H "Auth: $TOKEN" https://api'
}
```

💡 **In short**
Use credentials binding → Jenkins masks secrets automatically.

---

## Q95: What is the Git plugin and how does it work?

🧠 **Overview**
The Git plugin handles repository cloning, polling, branch discovery, and commit tracking.

⚙️ **Features**

* Checkout using SSH/HTTP
* SCM Polling
* Multibranch discovery

💡 **In short**
Git plugin = SCM integration for Jenkins.

---

## Q96: How do you checkout code in Jenkins pipelines?

🧠 **Overview**
Use the `checkout` step or the simpler `git` step.

🧩 **Option 1: checkout**

```groovy
checkout scm
```

🧩 **Option 2: git step**

```groovy
git branch: 'main',
    url: 'git@github.com:org/repo.git'
```

🧩 **Option 3: with credentials**

```groovy
withCredentials([sshUserPrivateKey(credentialsId: 'git-key',
                                   keyFileVariable: 'SSH_KEY')]) {
  git url: 'git@github.com:org/repo.git'
}
```

💡 **In short**
Checkout using `git` or `checkout scm` depending on pipeline context.

---
## Q97: What is the `checkout scm` step?

🧠 **Overview**
`checkout scm` checks out the exact repository and revision Jenkins used to trigger the build—ideal for multibranch pipelines.

⚙️ **Purpose**

* Auto-detects Git URL, branch, credentials.
* Works seamlessly with webhooks.

🧩 **Example**

```groovy
stage('Clone') {
  steps {
    checkout scm
  }
}
```

💡 **In short**
`checkout scm` = clone the source that triggered the pipeline.

---

## Q98: How do you checkout multiple repositories?

🧠 **Overview**
Use multiple `git` or `checkout` steps with different directories.

🧩 **Example**

```groovy
dir('app') {
  git url: 'git@github.com:org/app.git'
}
dir('infra') {
  git url: 'git@github.com:org/infra.git'
}
```

🧩 **With `checkout`**

```groovy
checkout([$class: 'GitSCM', 
          userRemoteConfigs: [[url: 'git@github.com:org/repo2.git']],
          branches: [[name: 'main']],
          extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'repo2']]])
```

💡 **In short**
Use `dir()` blocks with separate Git checkouts.

---

## Q99: How do you handle Git credentials in Jenkins?

🧠 **Overview**
Use Jenkins Credentials + Git plugin + `withCredentials`.

🧩 **Example**

```groovy
withCredentials([sshUserPrivateKey(credentialsId: 'git-key', keyFileVariable: 'SSH_KEY')]) {
  git url: 'git@github.com:org/repo.git'
}
```

💡 **In short**
Store credentials → bind → use in Git steps.

---

## Q100: What is sparse checkout and when would you use it?

🧠 **Overview**
Sparse checkout fetches only specific directories/files instead of the entire repository.

⚙️ **Use cases**

* Monorepos
* Large codebases
* Reduces checkout time

🧩 **Pipeline Example (Scripted)**

```groovy
sh '''
git init
git remote add origin git@github.com:org/big-repo.git
git config core.sparseCheckout true
echo "serviceA/" >> .git/info/sparse-checkout
git pull origin main
'''
```

💡 **In short**
Sparse checkout = partial cloning of repos.

---

## Q101: How do you integrate Jenkins with artifact repositories?

🧠 **Overview**
Integrate via plugins (Artifactory, Nexus) or direct CLI/API calls.

🧩 **Pipeline Example**

```groovy
sh "curl -u $USER:$PASS -T artifact.jar http://nexus/repository/maven-releases/"
```

💡 **In short**
Use plugins or REST APIs to upload/download artifacts.

---

## Q102: What is the Artifactory plugin?

🧠 **Overview**
A plugin that integrates Jenkins with JFrog Artifactory for storing, promoting, scanning, and retrieving build artifacts.

⚙️ **Features**

* Publish/resolve artifacts
* Build info tracking
* AQL queries
* Security scanning (Xray)

💡 **In short**
Artifactory plugin = deep CI/CD integration with Artifactory.

---

## Q103: How do you publish artifacts to Nexus from Jenkins?

🧠 **Overview**
Use Maven deploy plugin, Nexus REST API, or Jenkins Nexus plugin.

🧩 **Maven Example**

```groovy
sh 'mvn deploy -DskipTests'
```

🧩 **REST Example**

```groovy
withCredentials([usernamePassword(credentialsId:'nexus-creds', usernameVariable:'USR', passwordVariable:'PWD')]) {
  sh 'curl -u $USR:$PWD --upload-file target/app.jar http://nexus/repository/releases/app.jar'
}
```

💡 **In short**
Use Maven or REST APIs to upload artifacts to Nexus.

---

## Q104: What is the Archive Artifacts post-build action?

🧠 **Overview**
Archives build outputs inside Jenkins so they are downloadable from the build page.

🧩 **Example**

```groovy
archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
```

💡 **In short**
Archive artifacts = store build output within Jenkins.

---

## Q105: How do you implement versioning for build artifacts?

🧠 **Overview**
Use build variables, Git commit hashes, timestamps, or semantic versioning.

🧩 **Example**

```groovy
sh "cp target/app.jar target/app-${BUILD_NUMBER}.jar"
```

🧩 **Using Git hash**

```groovy
def version = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
```

💡 **In short**
Append build numbers or Git metadata to artifact names.

---

## Q106: What is the Pipeline Maven Integration plugin?

🧠 **Overview**
This plugin automatically detects Maven builds and provides test reports, code coverage, and build insights.

⚙️ **Features**

* Auto JUnit report publishing
* Dependency graph
* Shared libraries for Maven steps

💡 **In short**
Maven Integration plugin = smart Maven automation + reporting.

---

## Q107: How do you build and test Java applications in Jenkins?

🧠 **Overview**
Use Maven or Gradle inside pipeline steps.

🧩 **Maven Example**

```groovy
stage('Build') { steps { sh 'mvn clean package' } }
stage('Test') { steps { sh 'mvn test' } }
```

🧩 **Gradle Example**

```groovy
sh './gradlew test'
```

💡 **In short**
Run Maven/Gradle commands within stages.

---

## Q108: What is the difference between `mvn` and `sh 'mvn'` in pipelines?

📋 **Comparison Table**

| Usage      | Meaning                         |                                   |
| ---------- | ------------------------------- | --------------------------------- |
| `mvn`      | Jenkins Maven Plugin invocation | Automatic tool management         |
| `sh 'mvn'` | Raw shell command               | Requires Maven installed on agent |

🧠 **Tip**
`mvn` uses configured Maven tools from Jenkins global settings.

💡 **In short**
`mvn` = Jenkins-managed; `sh 'mvn'` = local Maven install.

---

## Q109: How do you publish test results in Jenkins?

🧠 **Overview**
Use the JUnit plugin or test result publishers.

🧩 **Example**

```groovy
junit 'target/surefire-reports/*.xml'
```

💡 **In short**
Use `junit` step to publish reports and view trends.

---

## Q110: What is the JUnit plugin?

🧠 **Overview**
A plugin that processes JUnit XML reports and displays results in Jenkins UI.

⚙️ Features

* Test trends
* Failure analysis
* Flaky test handling

💡 **In short**
JUnit plugin = test reporting engine.

---

## Q111: How do you display test trends over time?

🧠 **Overview**
JUnit plugin automatically aggregates results across builds.

🧩 **Usage**

```groovy
junit 'reports/*.xml'
```

⚙️ **Visualization**

* Trends graph
* Failure count
* Test duration charts

💡 **In short**
Publish JUnit reports → Jenkins shows trend graphs.

---

## Q112: What is code coverage and how do you report it in Jenkins?

🧠 **Overview**
Code coverage measures how much of the source code is executed by tests.

⚙️ **Tools**

* JaCoCo
* Cobertura
* Coverage API plugin

🧩 **Example**

```groovy
jacoco execPattern: 'target/jacoco.exec'
```

💡 **In short**
Use coverage plugins to analyze and visualize test coverage.

---

## Q113: What is the JaCoCo plugin?

🧠 **Overview**
Collects and visualizes Java code coverage metrics.

⚙️ **Provides**

* Coverage reports
* Threshold-based quality gates
* Trend charts

💡 **In short**
JaCoCo plugin = coverage reporting for Java apps.

---

## Q114: How do you implement quality gates based on test coverage?

🧠 **Overview**
Use JaCoCo thresholds or SonarQube quality gates.

🧩 **JaCoCo Example**

```groovy
jacoco(changeBuildStatus: true,
       minimumInstructionCoverage: '80')
```

🧩 **SonarQube Example**

```groovy
waitForQualityGate abortPipeline: true
```

💡 **In short**
Set coverage thresholds → fail pipeline if not met.

---

## Q115: What is SonarQube and how does it integrate with Jenkins?

🧠 **Overview**
SonarQube is a platform for code quality & security analysis.

⚙️ **Integration workflow**

1. Run scanner from Jenkins
2. Upload analysis to SonarQube
3. Apply quality gates
4. Fail/approve build

💡 **In short**
SonarQube checks code quality & security in CI pipelines.

---

## Q116: How do you perform static code analysis in pipelines?

🧠 **Overview**
Use SonarQube Scanner or language-specific tools.

🧩 **Example**

```groovy
withSonarQubeEnv('sonar-server') {
  sh 'sonar-scanner'
}
```

💡 **In short**
Run code scanning tools during pipeline execution.

---

## Q117: What is the SonarQube Scanner plugin?

🧠 **Overview**
Provides SonarScanner installation, environment setup, and pipeline steps.

🧩 **Usage**

```groovy
withSonarQubeEnv('sonar-server') {
  sh 'mvn sonar:sonar'
}
```

💡 **In short**
Plugin simplifies running SonarQube analysis in pipelines.

---

## Q118: How do you fail builds based on quality gate results?

🧠 **Overview**
Use `waitForQualityGate` after scanner step.

🧩 **Example**

```groovy
timeout(time: 5, unit: 'MINUTES') {
  def qg = waitForQualityGate()
  if (qg.status != 'OK') {
    error "Pipeline failed due to quality gate."
  }
}
```

💡 **In short**
Wait for gate result → fail pipeline if not met.

---

## Q119: What is the Role-based Authorization Strategy plugin?

🧠 **Overview**
Provides fine-grained RBAC for Jenkins—assign permissions to roles and map users/groups to roles.

⚙️ **Capabilities**

* Folder-level roles
* Project-level roles
* Global roles
* Restrict views & jobs

💡 **In short**
RBAC plugin = enterprise-grade access control.

---

## Q120: How do you implement fine-grained access control in Jenkins?

🧠 **Overview**
Enable RBAC plugin → define roles → assign permissions → map users/groups.

🧩 **Steps**

1. Install Role-based Authorization plugin
2. Manage Jenkins → Configure Global Security
3. Create roles (admin, dev, viewer)
4. Assign permissions (read, build, configure)
5. Map users or LDAP groups

💡 **In short**
Define roles → assign permissions → enforce granular access.

---

# Advanced

## Q121: How would you design a highly available Jenkins architecture?

🧠 **Overview**
Design HA Jenkins by separating the **controller (stateless where possible)** from stateful data, using **ephemeral agents**, and making `JENKINS_HOME` durable and backed by replicated storage.

⚙️ **How it works**

* Run controller behind a load balancer for UI/API.
* Keep controller immutable/config-as-code (JCasC).
* Use ephemeral agents (K8s pods/EC2 auto-scale) for builds.
* Persist `JENKINS_HOME` to highly-available storage (NFS/SMB/EFS/Rook-Ceph or object-store-backed solutions) plus backups.

🧩 **Example components**

```text
ALB -> Jenkins Controller (stateless pods; 1 active) 
Jenkins Controller -> Agents (K8s pod templates)
JENKINS_HOME -> EFS/Rook-Ceph/Rsync backup -> Object store snapshots
```

✅ **Best practices**

* Use JCasC + plugin list for reproducible controllers.
* Keep jobs & credentials in `JENKINS_HOME` but replicate/backup frequently.
* Prefer ephemeral agent model (Kubernetes) to scale.
* Use read-only replicas for metrics/logs and one writable primary controller or implement failover scripts with consistent storage.

💡 **In short**
Make controller reproducible and lightweight, persist state on HA storage, use ephemeral agents, and automate recovery with backups + IaC.

---

## Q122: What strategies would you use for Jenkins disaster recovery?

🧠 **Overview**
DR = fast restore of Jenkins control plane + agents + artifacts. Focus on consistent backups, tested restores, and automation.

⚙️ **How it works**

* Regular backups of `JENKINS_HOME` (configs, plugins, credentials).
* Backup external dependencies (artifact repos, SCM hooks, container registries).
* Keep controller configuration in Git (JCasC) and plugin manifest.
* Automate redeploy: IaC (Terraform/Helm) to spin up a new controller and restore `JENKINS_HOME` snapshot.

🧩 **Example restore flow**

```text
1. Provision new Jenkins controller via Terraform/Helm.
2. Point CASC to Git config; install plugins from manifest.
3. Restore JENKINS_HOME (or import jobs via Job DSL).
4. Recreate agent pools (K8s/EC2) and verify pipelines.
```

✅ **Best practices**

* Daily incremental backups + weekly full snapshots.
* Store backups off-site (S3 with versioning + lifecycle).
* Periodically test restores in a staging environment.
* Export credentials/keys and store in secure vault (AWS KMS/HashiCorp Vault) and document rotation.

💡 **In short**
Automate backups of state, store IaC/config in Git, and have tested scripted restores.

---

## Q123: How do you implement Jenkins master redundancy?

🧠 **Overview**
True active-active controller clustering isn’t native; common patterns are **active-passive failover** or stateless controllers combined with externalizing state and using leader-election (custom).

⚙️ **How it works**

* Active-passive: warm standby controller with same `JENKINS_HOME` mounted; use virtual IP / LB swap on failover.
* Stateless controllers: store configs in JCasC and persistent state in HA storage; spin up a new controller via orchestration (K8s Deployment/Helm) when primary fails.

🧩 **Options**

```text
Option A: Active-passive + shared storage (NFS/EFS) + failover script
Option B: Pet controller immutable -> recreate from JCasC + plugin list (preferred in cloud/K8s)
```

✅ **Best practices**

* Prefer recreate-from-config pattern (immutable infra) over filesystem-level failover.
* Use externalized credentials store (Vault) and restore secrets programmatically.
* Ensure plugin compatibility and version pinning.

💡 **In short**
Avoid fragile filesystem failover; prefer immutable controllers recreated from versioned config and HA backing for state.

---

## Q124: What is the difference between active-passive and active-active HA?

🧠 **Overview**
Two classic HA models: active-passive has one writer and a standby; active-active runs multiple active instances serving traffic concurrently.

📋 **Comparison**

| Aspect            | Active-Passive           | Active-Active                                         |
| ----------------- | ------------------------ | ----------------------------------------------------- |
| Writers           | Single writable instance | Multiple concurrent writers                           |
| Complexity        | Simpler                  | Complex (consistency conflicts)                       |
| Data coordination | Failover required        | Requires distributed locking/consensus                |
| Use case          | Jenkins controllers      | Stateless services or specially-designed cluster apps |

✅ **Best practices**

* Use active-passive for stateful apps where single-writer semantics are required.
* Use active-active only with services designed for distributed consistency.

💡 **In short**
Active-passive = one active, one standby; active-active = multiple actives—complex for stateful Jenkins.

---

## Q125: How would you scale Jenkins for hundreds of builds per day?

🧠 **Overview**
Scale horizontally using ephemeral agents, parallelize pipelines, optimize controller workload, and separate responsibilities.

⚙️ **How it works**

* Use K8s plugin to spawn many pod agents on-demand.
* Use different agent pools (labels) for heavy/fast jobs.
* Cache dependencies/artifacts (shared caches, local registries).
* Offload long-running tasks to external runners (e.g., Tekton, GitHub Actions) if appropriate.

🧩 **Example scaling plan**

```text
- Controller: 2-3 replicas for UI/API (stateless), use readiness/liveness in K8s.
- Agents: auto-scale node pools (spot + on-demand capacity).
- Caching: container registry + artifact proxy (Nexus/Artifactory).
```

✅ **Best practices**

* Use node/label partitioning and capacity autoscaling.
* Reduce controller CPU/IO by delegating heavy work to agents.
* Avoid large monolithic jobs; break into microstages.
* Monitor queue times and scale agent pool dynamically.

💡 **In short**
Scale via ephemeral agents, autoscale node pools, cache artifacts, and minimize controller load.

---

## Q126: What strategies would you use to optimize build queue times?

🧠 **Overview**
Reduce queue times by increasing agent availability, optimizing job resource needs, and prioritizing critical builds.

⚙️ **Strategies**

* Autoscale agents based on queue length or pending builds.
* Use lightweight agent images and cached layers.
* Parallelize test stages and split long jobs.
* Throttle low-priority jobs and reserve capacity for high-priority ones.

🧩 **Commands / Tools**

```bash
# Example: scale node pool via AWS CLI when queue > N (simplified)
aws autoscaling set-desired-capacity --auto-scaling-group-name jenkins-workers --desired-capacity 10
```

✅ **Best practices**

* Observe queue metrics (Prometheus + Grafana).
* Pre-warm ephemeral agents (keep small pool warm).
* Prioritize via labels/Throttle Concurrent Builds or custom queue managers.

💡 **In short**
Autoscale agents, split long jobs, pre-warm capacity, and prioritize critical pipelines.

---

## Q127: How do you implement build prioritization in Jenkins?

🧠 **Overview**
Prioritize by reserving dedicated agent pools, using priority plugins, or custom scheduling via labels and queue-management.

⚙️ **Approaches**

* Use **Priority Sorter Plugin** to assign numeric priorities.
* Create dedicated high-priority agent labels and restrict critical jobs to them.
* Implement queue consumers that scale agents for high-priority queues.

🧩 **Example Jenkinsfile label use**

```groovy
agent { label 'high-priority' }
```

✅ **Best practices**

* Combine Priority Sorter + reserved capacity to ensure SLAs.
* Avoid starvation of low-priority jobs—implement fair-share quotas.

💡 **In short**
Use priority plugins and reserved agent pools to guarantee capacity for important builds.

---

## Q128: What is the Throttle Concurrent Builds plugin?

🧠 **Overview**
A plugin that limits how many concurrent builds of a job or category can run, preventing resource contention.

⚙️ **How it works**

* Define throttles per job or category.
* Aggregate limits across nodes/labels.

🧩 **Example config**

```text
Throttle: maxConcurrentPerNode=1, maxConcurrentTotal=3, category=integration-tests
```

✅ **Best practices**

* Throttle resource-heavy jobs (DB migrations, long integration tests).
* Use categories to group related jobs.

💡 **In short**
Throttle plugin prevents overload by limiting concurrent runs per job or category.

---

## Q129: How do you prevent resource starvation in large Jenkins environments?

🧠 **Overview**
Prevent starvation with quotas, throttling, reserved pools, and fair scheduling.

⚙️ **Tactics**

* Reserve nodes for system/critical jobs.
* Use priority and throttle plugins.
* Implement fair-share scheduling in queue management.
* Monitor and alert on scheduler saturation.

🧩 **Example: reserved label**

```groovy
agent { label 'reserved-critical' }
```

✅ **Best practices**

* Enforce team quotas and folder-level limits.
* Use autoscaling with safeguards (min capacity) to avoid zero-capacity events.

💡 **In short**
Reserve capacity, throttle heavy jobs, enforce quotas, and autoscale intelligently.

---

## Q130: How would you implement multi-tenancy in Jenkins?

🧠 **Overview**
Multi-tenancy = isolate teams/projects while sharing infrastructure. Use Folders, RBAC, isolated agents, and resource quotas.

⚙️ **How it works**

* Create folders per team with folder-level credentials and permissions.
* Use agent pools per tenant (labels, node selectors).
* Use resource quotas at cluster level for agent nodes (K8s namespaces).

🧩 **Example**

```text
Folder: /team-a
  - Pipeline jobs
  - Credentials scoped to folder
  - Agent label: team-a-node
```

✅ **Best practices**

* Use Role-based Authorization Strategy and Folder-based permissions.
* Maintain shared libraries with governance.
* Monitor tenant usage and apply quotas.

💡 **In short**
Combine folders + RBAC + dedicated agent pools + quotas to isolate tenants.

---

## Q131: What strategies would you use to isolate teams and projects?

🧠 **Overview**
Isolation via namespace/agent labels, folder-level credentials, and separate pipelines & resource pools.

⚙️ **Techniques**

* Folder per team with scoped credentials.
* Dedicated Kubernetes namespaces and node pools.
* Separate Jenkins clouds or controllers for extremely strict tenancy.

🧩 **Terraform/K8s hint**

```hcl
# Create node pool for team A
resource "aws_eks_node_group" "team_a" { ... node_labels = { team = "team-a" } ... }
```

✅ **Best practices**

* Prefer logical isolation first (folders + RBAC), escalate to separate controllers if needed.
* Enforce network policies and resource limits at cluster level.

💡 **In short**
Use folders + RBAC + agent namespaces/pools to give teams isolated environments.

---

## Q132: How do you implement folder-based organization at scale?

🧠 **Overview**
Use Folders plugin programmatically (Job DSL/JCasC) and naming conventions to manage many projects.

⚙️ **How it works**

* Define folder templates in code (JCasC or Job DSL).
* Automate folder creation with GitOps flows for new projects.
* Apply folder-level credentials, permissions, and shared libraries.

🧩 **JCasC fragment example**

```yaml
unclassified:
  folderCredentials:
    - folderName: "team-a"
      credentials:
        - id: "team-a-creds"
```

✅ **Best practices**

* Enforce naming conventions and lifecycle policies.
* Use automation for onboarding/offboarding folders and permissions.

💡 **In short**
Automate folder creation and policy application via JCasC/Job DSL for scale.

---

## Q133: What is the Folders plugin and how does it improve organization?

🧠 **Overview**
Folders plugin allows grouping jobs into folder hierarchies, each with its own config, permissions, and view.

⚙️ **Benefits**

* Scoped credentials & permissions
* Cleaner UI & better discoverability
* Easier auditing and governance

🧩 **Use case**

```
/org
  /team-a
    /service-1
      - pipelines
```

✅ **Best practices**

* Combine with Role-based Authorization Strategy for folder-level RBAC.
* Use folder properties for shared environment variables.

💡 **In short**
Folders bring structure, scoped configs, and access control to Jenkins.

---

## Q134: How would you implement a Jenkins pipeline library governance model?

🧠 **Overview**
Governance enforces review, versioning, testing, and controlled promotion of shared library changes.

⚙️ **Key elements**

* Use Git workflows (PRs, code review).
* Enforce semantic versioning and release tags.
* CI for library (unit tests, static analysis).
* Approval process for promoting versions to “stable” channel.

🧩 **Example policy**

```text
- Dev branch for changes
- PR -> CI -> approval -> tag vX.Y.Z
- Promote to library registry (my-lib@stable)
```

✅ **Best practices**

* Protect main/stable branches.
* Maintain changelog and breaking-change notices.
* Use automated tests (pipeline-unit + integration tests) before release.

💡 **In short**
Treat shared libraries like production code: PRs, CI, versioning, and gated releases.

---

## Q135: What strategies would you use for shared library versioning at scale?

🧠 **Overview**
Use Git tags/branches and a clear release policy: semver + release channels (stable, beta).

⚙️ **Approaches**

* Tag releases (v1.2.0) and reference `@v1.2.0` in Jenkinsfiles.
* Maintain long-lived `stable` branch for critical consumers.
* Provide changelogs and migration guides.

🧩 **Example usage**

```groovy
@Library('common-lib@v1.2.0') _
```

✅ **Best practices**

* Avoid bleeding-edge `@main` for production pipelines.
* Automate changelog generation and deprecation warnings.

💡 **In short**
Version libraries via Git tags and require consumers to opt into upgrades.

---

## Q136: How do you enforce coding standards in Jenkins pipelines?

🧠 **Overview**
Enforce standards via linting, pre-commit hooks, CI checks, and centralized templates.

⚙️ **Practices**

* Use pipeline linters (Pipeline Linter Plugin / `jenkinsfile-runner` checks).
* Enforce linting as part of library CI and PR checks.
* Use shared library helpers and templates for common patterns.

🧩 **CI check example**

```bash
# lint Jenkinsfile with a linter (example)
jenkinsfile-linter ./Jenkinsfile
```

✅ **Best practices**

* Gate merges with CI that includes pipeline linting.
* Document best-practice snippets in shared libs.

💡 **In short**
Automate linting & code reviews; provide shared templates to standardize pipelines.

---

## Q137: What is pipeline linting and how do you implement it?

🧠 **Overview**
Pipeline linting checks Jenkinsfile syntax and policy violations before execution.

⚙️ **How it works**

* Use Jenkins Pipeline Linter or `jenkinsfile-runner` in CI.
* Run static analyzers (custom rules) against Jenkinsfiles and shared libs.

🧩 **Example GitHub Action**

```yaml
- name: Lint Jenkinsfile
  run: docker run --rm -v $PWD:/work jenkins/jnlp-agent jenkinsfile-linter /work/Jenkinsfile
```

✅ **Best practices**

* Fail PRs on lint errors.
* Keep linter rules in repo and update centrally.

💡 **In short**
Lint Jenkinsfiles in PR CI to catch syntax/policy issues early.

---

## Q138: How would you implement pipeline templates for consistency?

🧠 **Overview**
Provide standard pipeline templates via shared libraries or Job DSL, and enforce usage with onboarding docs and CI checks.

⚙️ **Implementation**

* Put templates in shared library `vars/` or `resources/`.
* Provide a `create-pipeline` Job DSL or generator to bootstrap projects.

🧩 **Jenkinsfile using template**

```groovy
@Library('org-templates') _
templatePipeline {
  serviceName = 'orders'
}
```

✅ **Best practices**

* Keep templates minimal and configurable.
* Version templates and provide migration guidelines.

💡 **In short**
Ship templates via shared libs and enforce through CI and documentation.

---

## Q139: What strategies would you use for managing pipeline complexity?

🧠 **Overview**
Keep pipelines simple by splitting responsibilities, reusing libraries, and testing pipelines.

⚙️ **Approaches**

* Break large pipelines into smaller jobs/stages or downstream pipelines.
* Move repeated logic into shared library functions.
* Use parameters and feature flags for configurable behavior.

🧩 **Example**

```groovy
// main pipeline delegates tasks
buildApp()
runTests()
triggerDeployment()
```

✅ **Best practices**

* Prefer composition over monolithic Jenkinsfiles.
* Limit pipeline size and keep each stage focused.

💡 **In short**
Modularize pipelines, use shared libs, and avoid monoliths.

---

## Q140: How do you implement pipeline testing and validation?

🧠 **Overview**
Test Jenkinsfiles and shared library code with unit tests, integration tests, and dry-run linting before production use.

⚙️ **Tools & Methods**

* **Pipeline Unit Testing Framework (spock + JenkinsPipelineUnit)** for unit tests.
* `jenkinsfile-runner` for integration/dry-run.
* CI gating: lint → unit tests → integration tests → publish library.

🧩 **Example unit test (pseudo)**

```groovy
def script = loadScript('vars/deployApp.groovy')
assert script.call() == expectedResult
```

✅ **Best practices**

* Run tests on PRs.
* Mock external systems in unit tests.
* Keep tests fast and deterministic.

💡 **In short**
Use pipeline-unit + integration runners and gate changes with CI.

---

## Q141: What is the Pipeline Unit Testing Framework?

🧠 **Overview**
Framework (e.g., JenkinsPipelineUnit) that allows unit testing of Jenkins shared library Groovy code by mocking pipeline steps and validating logic.

⚙️ **How it works**

* Load Groovy scripts in test harness.
* Mock `sh`, `checkout`, `env` to simulate pipeline behavior.
* Assert invoked steps and returned values.

🧩 **Example (Spock)**

```groovy
def script = loadScript('vars/buildApp.groovy')
script.call()
assert helper.called('sh', 'mvn clean package')
```

✅ **Best practices**

* Unit test library functions, not Jenkins core.
* Keep mocks minimal and assert critical behaviors.

💡 **In short**
Pipeline unit testing framework lets you test shared library logic locally in unit tests.

---

## Q142: How do you test shared library code?

🧠 **Overview**
Test shared libraries with unit tests (JenkinsPipelineUnit), integration tests (jenkinsfile-runner), and acceptance tests in a staging Jenkins.

⚙️ **Steps**

1. Unit test `vars/` and `src/` with JenkinsPipelineUnit.
2. Run integration smoke tests via `jenkinsfile-runner` or ephemeral Jenkins.
3. Validate behavior in staging controller before promoting.

🧩 **Example workflow**

```text
PR -> CI: lint -> unit tests -> run jenkinsfile-runner -> if OK: merge & tag
```

✅ **Best practices**

* Keep tests fast and isolated.
* Automate tests in CI and require passing status for merges.
* Use test fixtures for common scenarios.

💡 **In short**
Combine unit + integration + staging tests to validate shared libraries before production use.

----
## Q143: How would you implement canary deployments with Jenkins?

🧠 **Overview**
Canary deployments release a new version to a small subset of users before full rollout. Jenkins orchestrates canary rollout steps, metrics checks, and progressive traffic shifting.

⚙️ **How it works**

* Build + push image → deploy canary → route a small % of traffic → validate → increment rollout → full deployment.
* Use Kubernetes service mesh (Istio/Linkerd) or ALB weighted routing.

🧩 **Example (Istio Canary)**

```groovy
stage('Canary Deploy') {
  steps {
    sh 'kubectl apply -f istio/canary-v1.yaml'
    sh 'kubectl apply -f istio/canary-v2.yaml'
  }
}
stage('Shift Traffic') {
  steps {
    sh 'kubectl apply -f istio/route-5-percent.yaml'
  }
}
```

💡 **In short**
Deploy a canary version → shift small traffic → validate → roll forward or rollback.

---

## Q144: What strategies would you use for blue-green deployments?

🧠 **Overview**
Blue-green uses two identical environments; Blue (live) & Green (new). After validation, traffic switches instantly.

⚙️ **Strategies**

* Deploy new version to Green.
* Run smoke tests + health checks.
* Switch route/ingress/ALB target group.
* Rollback = switch back to Blue.

🧩 **Pipeline Example**

```groovy
stage('Switch Traffic') {
  sh 'aws elbv2 modify-listener --default-actions TargetGroupArn=green'
}
```

💡 **In short**
Blue stays live, Green receives deployment; switching is instant and safe.

---

## Q145: How do you implement progressive delivery in Jenkins pipelines?

🧠 **Overview**
Progressive delivery gradually exposes new releases with observability-driven approvals.

⚙️ **How it works**

* Canary rollout
* Automated metric analysis (Prometheus/NewRelic)
* Incremental traffic shifting
* Automated rollback on SLO violations

🧩 **Example**

```groovy
stage('Analyze Metrics') {
  steps {
    script {
      def errorRate = sh(returnStdout: true, script: "curl prometheus/api/...").trim()
      if (errorRate > 1.0) error("Abort rollout")
    }
  }
}
```

💡 **In short**
Incremental rollout + automated metric checks.

---

## Q146: What is feature flag integration in CI/CD pipelines?

🧠 **Overview**
Feature flags decouple deploy from release. Jenkins deploys code, while feature flags toggle features on/off dynamically.

⚙️ **Pipeline Role**

* Manage feature states (enable/disable via APIs).
* Validate feature toggles per environment.

🧩 **Example**

```groovy
sh 'curl -X POST https://launchdarkly/api/enableFlag'
```

💡 **In short**
Feature flags allow controlled rollout without redeployments.

---

## Q147: How would you implement GitOps workflows with Jenkins?

🧠 **Overview**
GitOps = Git as source of truth for infra/app manifests. Jenkins updates Git, ArgoCD/Flux syncs clusters automatically.

⚙️ **Pipeline**

* Build, test, scan → update manifest repo → create PR → merge → ArgoCD sync.

🧩 **Example**

```groovy
sh "sed -i 's/tag:.*/tag: ${BUILD_NUMBER}/' k8s/deployment.yaml"
sh "git commit -am 'Update image tag'"
sh "git push origin main"
```

💡 **In short**
Jenkins only commits changes; GitOps tools deploy them.

---

## Q148: How does Jenkins integrate with ArgoCD or Flux?

🧠 **Overview**
Jenkins triggers GitOps updates; ArgoCD/Flux handle deployments.

⚙️ **Integration patterns**

* Jenkins updates Git → ArgoCD auto-sync
* Jenkins triggers ArgoCD sync via REST API
* Jenkins validates ArgoCD health after deploy

🧩 **ArgoCD API Example**

```groovy
sh "curl -X POST argocd/api/applications/myapp/sync"
```

💡 **In short**
Jenkins builds → Git updated → ArgoCD/Flux deploys.

---

## Q149: What strategies would you use for multi-cloud deployments?

🧠 **Overview**
Use cloud-agnostic tooling, abstracted pipelines, and environment-specific deployment templates.

⚙️ **Strategies**

* Terraform for infra provisioning.
* Multi-provider Helm charts for K8s.
* Isolated agent pools per cloud.
* Federated CI/CD secrets (Vault/AWS KMS/GCP KMS).
* Separate manifest repos per cloud.

🧩 **Example**

```groovy
stage('Deploy AWS')  { sh 'helm upgrade --set cloud=aws chart/' }
stage('Deploy GCP')  { sh 'helm upgrade --set cloud=gcp chart/' }
```

💡 **In short**
Use IaC + templated pipelines to deploy consistently across clouds.

---

## Q150: How do you implement cross-cloud pipeline orchestration?

🧠 **Overview**
Orchestrate multi-cloud workflows by using Jenkins agents in each cloud, with templates and per-cloud deployment stages.

⚙️ **Pipeline Structure**

* Stage 1: Build once
* Stage 2: Deploy to AWS
* Stage 3: Deploy to GCP
* Stage 4: Deploy to Azure
* Rollback stages for each cloud

🧩 **Example**

```groovy
stage('AWS Deploy')  { agent { label 'aws' }  steps { sh './deploy-aws.sh' } }
stage('GCP Deploy')  { agent { label 'gcp' }  steps { sh './deploy-gcp.sh' } }
```

💡 **In short**
Use multi-label agents + cloud-specific deploy stages.

---

## Q151: How would you integrate Jenkins with service mesh deployments?

🧠 **Overview**
Service meshes (Istio/Linkerd) require configuration deployments for traffic rules, mTLS, retries, and rollouts.

⚙️ **Pipeline**

* Deploy Kubernetes workloads
* Apply mesh policies (DestinationRules, VirtualServices)
* Adjust traffic weights for canary/progressive rollout
* Validate metrics from mesh dashboards

🧩 **Example**

```groovy
sh 'kubectl apply -f istio/virtualservice-canary.yaml'
```

💡 **In short**
Jenkins applies mesh configs + traffic rules to support advanced deployment patterns.

---

## Q152: What strategies would you use for microservices deployment orchestration?

🧠 **Overview**
Coordinate deployments of multiple independent services with dependency rules.

⚙️ **Strategies**

* Use per-service pipelines + shared library orchestration.
* Use event-driven CI (webhooks or Kafka triggers).
* Coordinate version matrices (service A→B dependencies).
* Canary or staged deploy per service.

🧩 **Example: orchestrator pipeline**

```groovy
parallel {
  serviceA { buildAndDeploy('serviceA') }
  serviceB { buildAndDeploy('serviceB') }
}
```

💡 **In short**
Use orchestrator pipelines + per-service autonomy + dependency rules.

---

## Q153: How do you implement dependency management for microservices pipelines?

🧠 **Overview**
Handle inter-service dependencies by tagging, versioning, and triggering dependent pipelines.

⚙️ **Approaches**

* Maintain dependency graph in metadata repo.
* Use shared library for dependency resolution.
* Auto-trigger downstream service pipelines when dependency updates.

🧩 **Example**

```groovy
build job: 'service-b', parameters: [string(name:'VERSION', value: newVersion)]
```

💡 **In short**
Track dependencies centrally + auto-trigger required pipelines.

---

## Q154: What is build promotion and how do you implement it?

🧠 **Overview**
Build promotion is moving validated artifacts from lower environments (dev) to higher ones (stage/prod) without rebuilding.

⚙️ **How it works**

* Build once
* Store artifact (Nexus/Artifactory/S3)
* Tag/promote the artifact
* Deploy to next environment

🧩 **Example**

```groovy
sh "curl -X POST artifactory/api/promote --data '{\"targetRepo\": \"prod\"}'"
```

💡 **In short**
Promote = re-use trusted build across environments.

---

## Q155: How do you track artifacts through multiple environments?

🧠 **Overview**
Use metadata tagging, build info, and artifact repository tracking features.

⚙️ **Mechanisms**

* Artifactory build-info
* Nexus metadata tags
* Jenkins build parameters (BUILD_ID, GIT_SHA)
* GitOps manifest updates referencing pinned tag

🧩 **Example**

```yaml
image: repo/app:1.3.7-build45-gitabc123
```

💡 **In short**
Track builds using version tags + metadata + repository history.

---

## Q156: What strategies would you use for environment promotion gates?

🧠 **Overview**
Use automated + manual approval logic based on tests, scans, metrics, and compliance.

⚙️ **Gate Types**

* Test gates (unit/integration/e2e)
* Security gates (SAST, DAST, dependency scans)
* Quality gates (SonarQube)
* Compliance gates (policies, signatures)
* Manual approval for prod

🧩 **Example**

```groovy
input message: "Promote to production?", submitter: "release-managers"
```

💡 **In short**
Use automated checks + approval gates before promotion.

---

## Q157: How would you implement compliance checks in pipelines?

🧠 **Overview**
Automate compliance validation (security, policy, approvals) during build and deploy cycles.

⚙️ **Techniques**

* Code scanning (SonarQube, Checkov, Trivy).
* IaC scanning (Terraform compliance).
* Docker image scanning (Aqua, Trivy).
* Policy-as-code (OPA, Kyverno).
* SBOM generation (CycloneDX).

🧩 **Example**

```groovy
sh 'checkov -d terraform/'
sh 'trivy image myapp:${BUILD_NUMBER}'
```

💡 **In short**
Automate security & policy checks inside CI to enforce compliance before deployments.

---
## Q158: What is policy as code for CI/CD and how do you enforce it?

🧠 **Overview**
Policy-as-code means expressing security, compliance, and deployment rules as machine-readable code (Rego/OPA, Kyverno, Terraform Sentinel) so pipelines can automatically *validate* and *enforce* policies during CI/CD.

⚙️ **How it works**

* Policies live in VCS, versioned and reviewed.
* Pipelines call a policy engine (OPA, Kyverno, Conftest) to evaluate artifacts/manifests/IaC before allow-listing deploys.
* Fail fast: pipeline stops on policy violations; optionally provide automated remediation PRs.

🧩 **Example (Conftest/OPA step in Jenkinsfile)**

```groovy
stage('Policy Check') {
  steps {
    sh 'conftest test k8s/deployment.yaml --policy policy/'
    // or OPA evaluate JSON: opa eval -i payload.json -d policy.rego "data.my.policy.allow"
  }
}
```

✅ **Best practices**

* Keep policies small, testable, and versioned.
* Run policies at multiple gates: pre-merge (PR checks), pre-deploy (pipeline), and admission (K8s).
* Provide clear violation messages and automated remediation PRs where possible.

💡 **In short**
Policy-as-code automates governance: version policies, run them in CI, block non-compliant artifacts.

---

## Q159: How do you integrate OPA (Open Policy Agent) with Jenkins?

🧠 **Overview**
Integrate OPA by invoking OPA/Conftest in pipeline stages to evaluate JSON/YAML artifacts using Rego policies; or run OPA as a service (HTTP) and call its REST API from Jenkins.

⚙️ **Patterns**

* **Local CLI**: run `opa eval` or `conftest` in a pipeline step.
* **Remote OPA**: host OPA as a microservice and call `POST /v1/data/...` with payload.
* **Admission**: combine with K8s admission controller for runtime enforcement.

🧩 **Jenkinsfile (CLI)**

```groovy
stage('Policy') {
  steps {
    sh '''
      opa eval -i artifact.json -d policies.rego "data.myapp.policy.allow" > result.json
      cat result.json
    '''
  }
}
```

🧩 **Jenkinsfile (remote OPA)**

```groovy
sh """
curl -s -X POST http://opa:8181/v1/data/myapp/policy -d @artifact.json | jq .
"""
```

✅ **Best practices**

* Run OPA checks in PR CI to provide fast developer feedback.
* Use the same Rego policy set in CI and K8s admission to avoid drift.
* Fail pipelines with useful recommendations, not just "blocked" messages.

💡 **In short**
Call OPA locally or remotely from Jenkins to evaluate policies and block non-compliant artifacts.

---

## Q160: What strategies would you use for audit logging in Jenkins?

🧠 **Overview**
Audit logging captures who did what and when (user actions, job runs, config changes). Use built-in logging + plugins + external centralized logging to ensure tamper-evident, searchable audit trails.

⚙️ **How it works**

* Enable and export Jenkins system logs and audit plugins.
* Forward logs to centralized systems (ELK/EFK, Splunk, Cloud Logging).
* Store build metadata (build number, userId, git SHA) with artifacts.

🧩 **Components & commands**

* Install **Audit Trail Plugin** or **Audit2** (captures UI/API changes).
* Forward logs: configure `rsyslog` or Filebeat to ship `/var/log/jenkins/jenkins.log` or `JENKINS_HOME` logs to ELK.

```yaml
# Filebeat example (snippet)
filebeat.inputs:
- type: log
  paths:
    - /var/lib/jenkins/logs/*.log
```

* Record build provenance: include `GIT_COMMIT`, `BUILD_USER`, `BUILD_URL` in artifact metadata.

✅ **Best practices**

* Centralize logs with retention & immutability (WORM or S3 with Object Lock where required).
* Correlate audit logs with CI events, artifact provenance, and deployment records.
* Ensure RBAC restricts who can delete logs/backups and enable alerting on suspicious config changes.

💡 **In short**
Use audit plugins + log shipping to a centralized immutable store to get searchable, tamper-evident Jenkins audit trails.

---

## Q161: How do you ensure pipeline execution traceability?

🧠 **Overview**
Traceability links code → build → artifact → environment → deployment and who/what triggered each step. Store metadata and expose it alongside artifacts.

⚙️ **How it works**

* Capture metadata (git SHA, branch, PR ID, build number, user, pipeline run id).
* Publish build-info to artifact repository (Artifactory/Nexus) and to metadata stores.
* Generate SBOMs and store them with artifacts.
* Log and tag deployments (GitOps commit, helm release metadata).

🧩 **Practical steps**

```groovy
env.GIT_SHA = sh(script:'git rev-parse --short HEAD', returnStdout:true).trim()
sh "jfrog rt build-add-info ${env.BUILD_NUMBER} --props git.sha=${env.GIT_SHA}"
archiveArtifacts artifacts: 'sbom.json'
```

✅ **Best practices**

* Persist build-info in artifact repo (with promotion history).
* Expose a dashboard (Grafana or custom UI) that traces a release from commit → artifact → environment.
* Use immutable tags (image:repo:gitSHA) for deployments, never `latest` in production.

💡 **In short**
Record and persist metadata at each stage and store it with artifacts for end-to-end traceability.

---

## Q162: How would you implement security scanning in Jenkins pipelines?

🧠 **Overview**
Embed automated security checks (SAST, SCA, DAST, container scans) as pipeline stages with gating to fail builds that violate thresholds.

⚙️ **How it works**

* Add dedicated pipeline stages for SAST (static code), SCA (dependency), container image scanning, and DAST (runtime).
* Fail or mark builds unstable based on policy thresholds; produce actionable reports.

🧩 **Example pipeline stages**

```groovy
stage('SCA') { steps { sh 'snyk test --severity-threshold=high' } }
stage('SAST') { steps { sh 'mvn -DskipTests org.sonarsource.scanner.cli:sonar-maven-plugin:sonar' } }
stage('Image Scan') { steps { sh 'trivy image --exit-code 1 myapp:${GIT_SHA}' } }
stage('DAST') { steps { sh 'zap-baseline.py -t http://staging.example.com' } }
```

✅ **Best practices**

* Run lightweight scans in PRs; heavier/full scans in nightly or pre-prod pipelines.
* Automate remediation tickets for high-critical findings.
* Secure scanner credentials; run scanners in isolated agents.

💡 **In short**
Integrate SAST/SCA/DAST/image scanning into pipeline stages and gate promotions on acceptable risk thresholds.

---

## Q163: What stages would include security checks (SAST, DAST, SCA)?

🧠 **Overview**
Place security checks at multiple pipeline phases: pre-merge, pre-merge full scan, post-build, and pre-deploy.

⚙️ **Typical mapping**

* **PR / Pre-merge**: lightweight SAST (linters), SCA (fast dependency checks).
* **CI Build / Post-build**: full SAST, SCA with policy fail, SBOM generation.
* **Pre-deploy / Staging**: DAST, interactive scans, runtime checks.
* **Nightly**: Deep scans and dependency graph analysis.

🧩 **Jenkinsfile skeleton**

```groovy
stages {
  stage('PR-Lint & SCA') {}
  stage('Build & Unit Tests') {}
  stage('SAST Full') {}
  stage('Container Scan') {}
  stage('Deploy to Staging') {}
  stage('DAST & Runtime Checks') {}
}
```

✅ **Best practices**

* Optimize speed: run quick checks in PRs; expensive scans later.
* Correlate findings across stages to avoid duplicate triage.

💡 **In short**
Use layered security checks: quick in PRs, thorough in CI and pre-prod.

---

## Q164: How do you integrate vulnerability scanning tools with Jenkins?

🧠 **Overview**
Use CLI invocations, official Jenkins plugins, or APIs to run scanners and consume their results in pipeline stages.

⚙️ **Common tools & integration patterns**

* **Snyk / WhiteSource / Dependabot**: CLI or plugins, fail build if high severity.
* **Trivy / Clair / Anchore**: run image scans via CLI in pipeline.
* **OWASP ZAP**: run DAST against deployed staging environment; parse reports with JUnit publisher.

🧩 **Example (Trivy step)**

```groovy
stage('Image Scan') {
  steps {
    sh "trivy image --format json --output trivy.json myrepo/myapp:${GIT_SHA} || true"
    junit 'trivy.json' // after converting to junit or use report archiver
  }
}
```

✅ **Best practices**

* Fail builds on policy-defined severities only; otherwise surface issues as warnings.
* Store scanner reports and correlate them with build metadata for triage.

💡 **In short**
Call scanner CLIs or plugins inside pipeline stages, produce machine-readable reports, and gate promotions.

---

## Q165: What strategies would you use for container image scanning?

🧠 **Overview**
Shift-left scanning: scan base images in builder pipelines, scan built images before push, and scan registry images periodically.

⚙️ **How it works**

* Scan base image at build time (prevent vulnerable base).
* Scan final image and fail/pause pushing to registry if policy violated.
* Enforce registry-side policies (Harbor/Quay/Artifactory) to block pushes.

🧩 **Pipeline snippet**

```groovy
stage('Build Image') { steps { sh 'docker build -t myapp:${GIT_SHA} .' } }
stage('Scan Image')  { steps { sh 'trivy image --exit-code 1 myapp:${GIT_SHA}' } }
stage('Push')        { steps { sh 'docker push myapp:${GIT_SHA}' } }
```

✅ **Best practices**

* Use minimal, hardened base images and image provenance.
* Cache scan results for identical image layers to save time.
* Enforce registry-level admission controls and automate vulnerability ticket creation.

💡 **In short**
Scan both base and final images in CI, block registry pushes on policy violations, and enforce registry policies.

---

## Q166: How do you implement secrets scanning in pipelines?

🧠 **Overview**
Detect secrets in code or artifacts using tools (git-secrets, truffleHog, detect-secrets) on PRs and pre-commit hooks.

⚙️ **How it works**

* Run secret scanner in PR pipelines; fail on matches.
* Use pre-commit hooks to block secrets locally.
* Audit historic commits for leaked secrets and rotate if found.

🧩 **Example (detect-secrets)**

```groovy
stage('Secrets Scan') {
  steps {
    sh 'detect-secrets scan > .secrets.baseline || true'
    sh 'detect-secrets audit .secrets.baseline' // fail if new secrets found
  }
}
```

✅ **Best practices**

* Block commits with credentials; if leaked rotate immediately.
* Combine automated scanning with human review for false positives.
* Ensure scanners are updated with latest regex/patterns.

💡 **In short**
Run secrets scanners in PR/CI and pre-commit; rotate any discovered credentials immediately.

---

## Q167: How would you prevent credential leakage in Jenkins?

🧠 **Overview**
Prevent leakage by using the Credentials store, `withCredentials` scoping, masking, minimal permissions, and external secret stores.

⚙️ **Tactics**

* Never commit secrets to Git; store them in Jenkins Credentials or external vault.
* Use `withCredentials` so secrets exist only during a step.
* Ensure console masking plugins are enabled and sanitize logs.
* Use ephemeral tokens and short-lived credentials (STS, Vault leases).
* Restrict job config view/edit via RBAC.

🧩 **Jenkinsfile pattern**

```groovy
withCredentials([string(credentialsId: 'API_TOKEN', variable: 'TOKEN')]) {
  sh 'curl -H "Authorization: Bearer $TOKEN" https://api.example.com'
}
```

✅ **Best practices**

* Prefer external secret managers (Vault, AWS Secrets Manager) with dynamic credentials.
* Use least-privilege credentials and rotate automatically.
* Block archive/artifact uploads that may contain secrets.

💡 **In short**
Use credential stores, scoped injection, masking, and dynamic secrets to avoid leaking credentials.

---

## Q168: What is the Credentials Masking plugin?

🧠 **Overview**
The Credentials Masking (Mask Passwords) plugin masks sensitive values in console output so secrets don’t appear in logs.

⚙️ **How it works**

* The plugin detects bound credentials and replaces occurrences in logs with `****`.
* Works with `withCredentials` and many credential types.

🧩 **Notes**

* Combine masking with `withCredentials` for best coverage.
* Not foolproof — avoid printing secrets into files or artifacts.

✅ **Best practices**

* Install and enforce plugin usage across controllers.
* Avoid string concatenation that exposes secrets in logs.

💡 **In short**
Credentials Masking hides secrets in console output to reduce risk of accidental exposure.

---

## Q169: How do you integrate external secret management (Vault, AWS Secrets Manager)?

🧠 **Overview**
Integrate Jenkins with external secret stores so pipelines fetch secrets at runtime instead of storing them in Jenkins.

⚙️ **Patterns**

* Use Jenkins plugins (HashiCorp Vault Plugin, AWS Secrets Manager Credentials Provider).
* Use Kubernetes CSI or Vault Agent Injector when running agents on K8s.
* Use short-lived credentials via dynamic secrets (Vault `lease`) or STS for AWS.

🧩 **Vault plugin example (Jenkinsfile)**

```groovy
withVault([vaultSecrets: [[path: 'secret/data/myapp', secretValues: [[envVar: 'DB_PASS', vaultKey: 'password']]]]]) {
  sh 'psql -c "select 1" -h db -U user -w $DB_PASS'
}
```

🧩 **AWS Secrets Manager (credentials provider)**

* Configure IAM role for Jenkins agent.
* Use credentialsId pointing to AWS secret in `withCredentials`.

✅ **Best practices**

* Prefer dynamic, short-lived credentials.
* Limit Jenkins’ direct storage of secrets; prefer ephemeral retrieval.
* Audit access to secret stores and rotate keys.

💡 **In short**
Use Vault or AWS Secrets Manager plugins/agents to fetch secrets dynamically and avoid storing secrets in Jenkins.

---

## Q170: What strategies would you use for dynamic credential injection?

🧠 **Overview**
Dynamic credential injection issues short-lived credentials at runtime (Vault leases, AWS STS, GCP IAM tokens) that expire and reduce long-term secret risk.

⚙️ **How it works**

* Jenkins agent authenticates to Vault or cloud IAM using an instance role or Kubernetes service account.
* Secrets are fetched when needed and not persisted.
* Use Vault Agent or CSI driver for K8s agents to mount secrets as files or env vars.

🧩 **Examples**

* **Vault**: Use AppRole or K8s auth, request DB creds `vault read database/creds/my-role` returning TTL-based credentials.
* **AWS**: Assume role via STS, get temporary credentials and use them in `aws` CLI.

✅ **Best practices**

* Use least privileges and short TTLs.
* Rotate/renew credentials automatically.
* Audit secret issuance and consumption.

💡 **In short**
Issue ephemeral credentials at runtime via Vault/ST S to minimize exposure and automatic rotation.

---

## Q171: How would you implement Jenkins on Kubernetes?

🧠 **Overview**
Run Jenkins controllers and agents on Kubernetes for scalability, ephemeral agents, and operational simplicity. Use Helm, JCasC, and persistent storage for `JENKINS_HOME`.

⚙️ **Core components**

* Jenkins controller (Deployment or StatefulSet) with persistent `JENKINS_HOME` (PVC backed by EBS/EFS/CEPH).
* Kubernetes plugin for pod agents (ephemeral build pods).
* Ingress/LoadBalancer for external access.
* JCasC + plugin manager for reproducible controller config.

🧩 **Quick Helm + JCasC example**

```bash
helm repo add jenkins https://charts.jenkins.io
helm install jenkins jenkins/jenkins \
  --set controller.adminUser=admin \
  --set controller.jenkinsUrl=https://jenkins.example.com \
  --set controller.JCasC.configScripts.myconfig='jenkins:\n  systemMessage: "CICD"\n'
```

**Pod template (pipeline snippet)**

```groovy
agent {
  kubernetes {
    yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: jnlp
    image: jenkins/inbound-agent:4.3-4
  - name: maven
    image: maven:3.8-jdk11
"""
  }
}
```

✅ **Best practices**

* Keep controller small and stateless where possible; store config as code (JCasC).
* Use PVC on HA storage for `JENKINS_HOME` or prefer recreate-from-Git model (store config, plugins, jobs in Git & artifact repo) to avoid single-point-of-failure.
* Use Pod SecurityPolicies / PSP alternatives, NetworkPolicies, and RBAC.
* Provide metrics (Prometheus) and centralized logs (Fluentd/Filebeat).
* Harden with TLS, auth (OIDC/LDAP), and limit plugin set; pin plugin versions.

💡 **In short**
Deploy Jenkins via Helm on Kubernetes, use JCasC for config, ephemeral pod agents for builds, and persist state with durable storage or prefer rebuildable controllers from Git.

---
## Q172: What are the challenges of running Jenkins in Kubernetes?

🧠 **Overview**
Running Jenkins on Kubernetes gives elasticity and ephemeral agents but introduces new operational challenges around stateful controller persistence, plugin compatibility, security, and scaling patterns.

⚙️ **Key challenges**

* **Statefulness:** `JENKINS_HOME` must be durable; PVs, backups, and consistency matter.
* **Controller HA:** Jenkins controller is not natively clustered — failover is complex.
* **Plugin lifecycle:** Plugins may need restarts and can break across controller upgrades.
* **Resource contention:** Builds (especially container-in-container) can consume cluster resources.
* **Security & RBAC:** Pod security, service accounts, and network policies must be hardened.
* **Startup time / cold starts:** Spinning up agents or controller pods can delay builds.
* **Observability & debugging:** Need logs/metrics for ephemeral pods and controller state.

✅ **Best practices**

* Externalize state (S3/EFS) or use reproducible config (JCasC + plugin manifest).
* Prefer ephemeral agents (K8s pods) and keep controller minimal.
* Pin plugin versions; run upgrades in staging first.
* Use resource quotas, PodDisruptionBudgets, and NodePools for agent scaling.

💡 **In short**
K8s gives scale — but you must solve persistence, HA, plugin/versioning, security, and resource management.

---

## Q173: How do you implement a StatefulSet for Jenkins master?

🧠 **Overview**
Use a StatefulSet when you need stable network IDs and stable persistent volumes for a Jenkins controller (single-replica typical).

⚙️ **How it works**

* Create StatefulSet with a PVC for `JENKINS_HOME`.
* Use Headless Service for stable DNS.
* Prefer single replica or active-passive pattern; StatefulSet helps with stable storage attachment.

🧩 **Minimal YAML (snippet)**

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata: { name: jenkins }
spec:
  serviceName: jenkins-headless
  replicas: 1
  selector: { matchLabels: { app: jenkins } }
  template:
    metadata: { labels: { app: jenkins } }
    spec:
      containers:
      - name: controller
        image: jenkins/jenkins:lts
        volumeMounts: [{ name: jenkins-home, mountPath: /var/jenkins_home }]
  volumeClaimTemplates:
  - metadata: { name: jenkins-home }
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources: { requests: { storage: 50Gi } }
```

✅ **Best practices**

* Use storage class with snapshots and fast IOPS.
* Use `replicas: 1` for single writable controller; use backups and IaC for recovery.
* Add PodDisruptionBudget and readiness/liveness probes.

💡 **In short**
StatefulSet + PVC gives stable storage for `JENKINS_HOME`; still plan backups and restore strategy.

---

## Q174: What storage solutions would you use for Jenkins in Kubernetes?

🧠 **Overview**
Choose storage that provides durability, snapshots, and acceptable performance for `JENKINS_HOME` and build caches.

⚙️ **Common options**

* **Cloud block storage**: EBS (AWS), Persistent Disk (GCP), Managed disks (Azure) — high IOPS, RWO.
* **Shared file systems**: EFS (AWS), Filestore (GCP), Azure Files — better for multi-pod read access (use carefully).
* **Distributed storage**: Rook/Ceph, GlusterFS — good for on-prem HA.
* **Object store (S3)**: Not a direct substitute for `JENKINS_HOME`, but good for artifacts/backups and build-cache layers.

📋 **Selection guide**

| Need                             | Use                            |
| -------------------------------- | ------------------------------ |
| Single-controller durable home   | Cloud block (fast) + snapshots |
| Multiple readers / backup access | Managed NFS/EFS (with locking) |
| On-prem HA                       | Rook/Ceph or enterprise NFS    |
| Artifacts & backups              | S3-compatible object storage   |

✅ **Best practices**

* Avoid storing ephemeral large artifacts in `JENKINS_HOME`; push to Artifactory/Nexus/S3.
* Use storage classes with snapshot/backup support and test restores regularly.
* If using shared FS, ensure file-locking and performance are acceptable.

💡 **In short**
Use fast block storage for controller PV + object storage for artifacts/backups; choose shared FS only when needed and tested.

---

## Q175: How do you implement Jenkins autoscaling in Kubernetes?

🧠 **Overview**
Autoscaling usually targets **agents**, not the controller. Use K8s autoscaling for agent nodes and let the Kubernetes plugin spawn ephemeral pod agents.

⚙️ **Key components**

* **Kubernetes plugin**: creates ephemeral agent pods per build.
* **Cluster autoscaler**: scales node groups (managed node pools) when pods are pending.
* **HPA/Vertical Pod Autoscaler**: not used directly for agents but useful for other workloads.
* **Pre-warm pools**: keep minimal warm agents to avoid cold-start latency.

🧩 **Flow**

1. Jenkins schedules agent pod → pending due to no nodes → Cluster Autoscaler adds nodes.
2. Node becomes ready → agent pod runs → build executes.
3. After idle timeout, nodes scale down.

✅ **Best practices**

* Use pod/namespace resource quotas and limits to avoid OOMs.
* Set reasonable agent idle TTL in plugin to free resources.
* Pre-warm with a small node pool to reduce queue latency.
* Use taints/tolerations or separate node pools (spot + on-demand) for cost optimization.

💡 **In short**
Autoscale agents via Kubernetes plugin + cluster autoscaler; scale nodes, not the controller.

---

## Q176: What is the Jenkins Kubernetes Operator?

🧠 **Overview**
A Kubernetes Operator encapsulates best practices to deploy/manage Jenkins controllers and related resources (JCasC, plugins, backups) using CRDs and controllers.

⚙️ **Capabilities**

* Declarative Jenkins controller lifecycle (create/upgrade).
* Manage JCasC, plugin installation, and backup/restore hooks.
* Automate safe restarts and configuration rollouts.

🧩 **Typical CRD usage**

```yaml
apiVersion: jenkins.io/v1alpha2
kind: Jenkins
metadata: { name: jenkins }
spec:
  master:
    image: jenkins/jenkins:lts
    persistence: { enabled: true, size: "50Gi" }
```

✅ **Best practices**

* Use operator for reproducible Jenkins controllers and automated lifecycle tasks.
* Combine with GitOps for CR manifests and JCasC for in-controller config.

💡 **In short**
Operator = Kubernetes-native automation for Jenkins lifecycle and config management.

---

## Q177: How does the operator differ from traditional Jenkins deployments?

📋 **Comparison Table**

| Aspect        | Traditional (Helm/Manifests)  | Operator                                            |
| ------------- | ----------------------------- | --------------------------------------------------- |
| Management    | Manual Helm/manifest upgrades | Controller reconciles desired state                 |
| Automation    | Scripts + CI pipelines        | Declarative CRs + operator reconciliation loop      |
| Lifecycle     | Human-driven                  | Operator handles backups, plugin installs, restarts |
| Extensibility | External tooling required     | Operator can embed best-practices & hooks           |

⚙️ **Key difference**
Operators continuously reconcile Jenkins CR to desired state; Helm releases are one-shot apply/upgrade.

💡 **In short**
Operator automates runtime management; Helm/manifest is declarative but needs external automation for lifecycle tasks.

---

## Q178: What strategies would you use for Jenkins configuration management?

🧠 **Overview**
Treat Jenkins config as code: JCasC for system config, Job DSL / Pipeline as code for jobs, and a plugin manifest for plugins.

⚙️ **How it works**

* Store JCasC YAML, plugin list, and shared library code in Git.
* Use CI to validate config (lint, unit tests) and promote to environments.
* Apply config via JCasC or Operator CRs at controller startup or runtime.

🧩 **Example artifacts**

```
- jenkins-casc/
  - jenkins.yaml
  - plugins.txt
  - credentials-seed.groovy
- shared-libs/
  - mylib/
```

✅ **Best practices**

* Keep secrets out of Git — reference external secret stores.
* Automate config validation and safe rollouts.
* Pin plugin versions and test upgrades in staging.

💡 **In short**
Use JCasC + Job DSL + Git + CI to manage Jenkins config as code.

---

## Q179: How do you implement Infrastructure as Code for Jenkins?

🧠 **Overview**
Provision Jenkins infrastructure (cluster, PVs, load balancers) with IaC tools like Terraform, and manage Helm releases or Operator CRs as part of pipelines.

⚙️ **Typical flow**

* Terraform creates k8s cluster, node pools, PV storage, and RBAC.
* Helm or Operator deploys Jenkins controller configured by IaC-driven values.
* CI/CD pipelines manage changes via pull requests and automated apply.

🧩 **Terraform snippet (conceptual)**

```hcl
module "eks" { source = "terraform-aws-modules/eks/aws" ... }
resource "kubernetes_namespace" "jenkins" { metadata { name = "jenkins" } }
```

✅ **Best practices**

* Keep infra modules small and reusable.
* Use remote state and CI gating for Terraform apply.
* Store Helm values and JCasC manifests in Git for reproducible deploys.

💡 **In short**
Provision K8s + storage + networking via Terraform; deploy Jenkins via Helm/Operator from IaC.

---

## Q180: What tools would you use for Jenkins provisioning (Terraform, Ansible)?

🧠 **Overview**
Use a mix of IaC and config management: Terraform for cloud infra, Helm + K8s Operator for app deployment, and Ansible for OS-level config if managing VMs.

⚙️ **Roles**

* **Terraform**: cloud infra (VPC, EKS/AKS/GKE, PVs, LB).
* **Helm**: deploy Jenkins chart and values.
* **Jenkins Operator**: manage controller CRs in-cluster.
* **Ansible**: configure provisioned VMs or install agents on VMs.
* **Packer**: bake base images for agents (optional).

🧩 **Example combo**

* Terraform -> create cluster & nodegroups → Helm chart install Jenkins → JCasC applied via ConfigMap → Ansible configure external agent VMs.

✅ **Best practices**

* Keep roles separated (infra vs app config).
* Use CI pipelines to run Terraform plan/apply with approvals for prod.

💡 **In short**
Terraform + Helm/Operator are primary; Ansible used for VM-based setups and complex OS configuration.

---

## Q181: How would you implement Jenkins plugin management at scale?

🧠 **Overview**
Automate plugin installation and versioning using a plugin manifest, Plugin Installation Manager Tool (PIM), JCasC plugin management, and CI-driven validation.

⚙️ **How it works**

* Maintain `plugins.txt` or `plugins.yaml` in Git with plugin IDs and versions.
* Use PIM to build controller image or install plugins at startup.
* Run integration tests after plugin changes in a staging controller before promoting.

🧩 **Example `plugins.txt`**

```
git:4.11.0
kubernetes:1.30.0
configuration-as-code:1.55
```

**Install**

```bash
java -jar pluginManager.jar install <plugins.txt>
```

✅ **Best practices**

* Pin plugin versions and test compatibility matrix.
* Automate plugin upgrade PRs and rollback if tests fail.
* Bake plugins into a base image for faster startup and reproducibility.

💡 **In short**
Use a manifest + Plugin Installation Manager + CI tests to manage plugins declaratively and safely.

---

## Q182: What strategies would you use for plugin version control?

🧠 **Overview**
Treat plugins like dependencies: pin versions, track in Git, test upgrades in staging, and use automated PRs for updates.

⚙️ **Strategies**

* Keep a `plugins.txt` in Git with explicit versions.
* Use dependabot-like tooling or custom job to check plugin updates and create PRs.
* Run smoke & integration tests in a staging Jenkins before promoting plugin upgrades.

🧩 **Promotion flow**

```
plugins.txt update -> CI deploys to staging -> run regression tests -> if OK merge to prod manifest -> deploy
```

✅ **Best practices**

* Record plugin compatibility notes and rollback steps.
* Avoid automatic auto-upgrades in production without tests.

💡 **In short**
Pin plugin versions in Git, automate update PRs, and validate in staging.

---

## Q183: How do you test plugin updates before production rollout?

🧠 **Overview**
Validate plugin upgrades in isolated staging controllers: run functional and integration tests including common pipelines and custom shared-library flows.

⚙️ **Testing steps**

1. Create ephemeral staging controller (Helm/Operator) using updated plugin manifest.
2. Run smoke tests (UI/API), seed jobs, and run representative pipelines.
3. Execute plugin upgrade scenarios and restarts.
4. Run performance/load tests if needed.

🧩 **Automation hint**

* Use CI jobs to spin up ephemeral Jenkins via Helm + JCasC, run Job DSL seed jobs, execute test suites, and destroy the environment.

✅ **Best practices**

* Maintain a suite of core pipeline tests that reflect production usage.
* Test plugin rollbacks and data migration safety.

💡 **In short**
Automate ephemeral staging controllers that install plugin updates and run representative test suites before production.

---

## Q184: What is the Plugin Installation Manager tool?

🧠 **Overview**
A CLI tool provided by Jenkins to install plugins programmatically (download, resolve transitive dependencies) or to build plugin bundles for images.

⚙️ **Capabilities**

* Install list of plugins from manifest (`plugins.txt` / `plugins.yaml`).
* Resolve dependency versions and fetch `.hpi` files.
* Useful for building immutable controller images with plugins preinstalled.

🧩 **Example**

```bash
java -jar plugin-manager.jar --plugin-file plugins.txt --war /usr/share/jenkins/jenkins.war --plugin-download-directory plugins/
```

✅ **Best practices**

* Use PIM in CI to create reproducible controller images.
* Store plugin manifests in Git and tie image builds to manifest commits.

💡 **In short**
PIM automates plugin downloads & bundling for reproducible Jenkins controller images.

---

## Q185: How would you implement zero-downtime Jenkins upgrades?

🧠 **Overview**
Zero-downtime upgrades are hard because Jenkins controller holds state. Strategies focus on minimizing downtime via blue-green/rolling controller replacements, immutable images, state externalization, and graceful handover.

⚙️ **Approaches**

1. **Immutable controller + recreate-from-config** (preferred): create new controller from JCasC & plugin manifest, switch traffic to new controller, decommission old.
2. **Blue-green with shared storage**: deploy new controller pointing to replicated `JENKINS_HOME` and switch LB after health checks (risky due to file-locks).
3. **Operator-driven rollout**: Operator can orchestrate safe restarts and backup/restore.
4. **Minimize impact**: drain agents, disable new builds during upgrade window, and use rolling restarts for minimal downtime.

🧩 **Example flow (immutable)**

```text
1. Build new controller image (JCasC + plugin manifest).
2. Deploy new controller in parallel (staging/blue) and seed jobs from Git.
3. Validate health & pipelines (smoke runs).
4. Update ingress/LB to point to new controller.
5. Shutdown old controller after final sync.
```

✅ **Best practices**

* Keep config in JCasC and plugin list in Git so new controllers recreate state reliably.
* Test upgrade in staging; perform canary upgrade on low-traffic controllers.
* Backup `JENKINS_HOME` and credentials before changes.
* Notify teams and schedule maintenance windows for major migrations.

💡 **In short**
Prefer immutable controller replacement from versioned config and plugin manifests; avoid filesystem-level live failover—test the process and automate it.

---
## Q186: What strategies would you use for Jenkins version migration?

🧠 **Overview**
Migrate Jenkins versions safely with staged rollouts, automated testing, plugin compatibility checks, and repeatable IaC-driven provisioning.

⚙️ **How it works**

* Validate plugin compatibility matrix for target Jenkins version.
* Create immutable controller images with pinned plugins.
* Use ephemeral staging controllers to smoke-test upgrades.
* Promote only after tests pass; keep rollback artifacts.

🧩 **Steps / Commands**

```bash
# Example: build controller image with Plugin Installation Manager
java -jar plugin-manager.jar --plugin-file plugins.txt --outputDir plugins/
docker build -t my-jenkins:2.X.Y .
# Deploy to staging via Helm
helm upgrade --install jenkins ./chart -f values-staging.yaml
```

✅ **Best practices**

* Pin plugin versions in `plugins.txt`.
* Run full regression suite (seed jobs + typical pipelines) in staging.
* Backup `JENKINS_HOME` and credentials before upgrade.
* Automate upgrade via CI (image build → deploy → tests → promote).
* Keep rollback plan (previous image + plugin manifest).

💡 **In short**
Test plugin compatibility, run upgrades in staging using immutable images, automate tests, backup, then promote.

---

## Q187: How do you test Jenkins upgrades in non-production environments?

🧠 **Overview**
Use ephemeral test controllers that mirror production (plugins, JCasC, sample jobs) and run automated validation suites.

⚙️ **How it works**

* Spin up a staging Jenkins from the same JCasC + plugin manifest.
* Seed representative jobs (Job DSL / seed jobs).
* Execute a smoke + regression suite covering UI/API, pipeline runs, plugin behavior, and shared libraries.

🧩 **Example workflow**

```text
CI pipeline:
1. Build new controller image (pinned plugins)
2. Deploy ephemeral Jenkins (helm + jcasC)
3. Seed jobs (Job DSL)
4. Run test pipelines (functional + performance)
5. Collect logs/metrics, then destroy env
```

✅ **Best practices**

* Automate full test sequence in CI for every plugin+core change.
* Use real workloads or representative synthetic jobs.
* Validate backup/restore and plugin upgrade/downgrade flows.

💡 **In short**
Automate ephemeral staging tests that reproduce production config and run end-to-end validation before production rollout.

---

## Q188: What is the Jenkins LTS (Long Term Support) release strategy?

🧠 **Overview**
Jenkins LTS is a stable core release stream that bundles tested plugin combinations and receives security/bug fixes—recommended for production where stability matters.

⚙️ **How it works**

* LTS releases are published periodically (monthly/quarterly cadence historically) and backport critical fixes.
* Users on LTS get fewer API/behavior changes than weekly releases.

🧩 **How to use**

* Prefer LTS for production controllers; test weekly releases in staging if you need new features.

✅ **Best practices**

* Track LTS announcements; test upgrades in staging before production.
* Pin controller image to a specific LTS version and plan upgrade windows.

💡 **In short**
LTS = stability-first Jenkins release stream—use for production to minimize surprises.

---

## Q189: How would you implement performance monitoring for Jenkins?

🧠 **Overview**
Monitor controller and agents with metrics, logs, and traces to detect CPU/IO saturation, queue bottlenecks, and plugin-induced slowness.

⚙️ **How it works**

* Export JVM, queue, executor, and plugin metrics to a monitoring backend (Prometheus + Grafana).
* Ship controller & agent logs to centralized logging (ELK/EFK).
* Add synthetic pipeline run checks and alerting.

🧩 **Metrics exporters / stack**

* Prometheus JMX exporter (Jenkins metrics plugin)
* Grafana dashboards for queue length, executors, GC, thread count
* Filebeat -> ELK for logs

✅ **Best practices**

* Monitor build queue length, executor utilization, JVM GC pause times, disk IOPS and latency on `JENKINS_HOME`.
* Alert on long queue times, frequent GC, or excessively long build durations.
* Correlate logs with slow builds to identify plugin problems.

💡 **In short**
Export Jenkins JVM and scheduler metrics, centralize logs, create dashboards and alerts for queue/executor/JVM health.

---

## Q190: What metrics would you track for Jenkins health?

🧠 **Overview**
Key metrics give early warning of load, failures, and resource problems.

📋 **Essential Metrics**

* `build_queue_length` / pending builds
* `executors_total` / `executors_busy` / utilization (%)
* `build_duration_seconds` (median / p95)
* `builds_failed_rate` / `success_rate`
* JVM: `heap_used_bytes`, `gc_pause_seconds`, thread count
* Disk: `jenkins_home` free space, IOPS, latency
* Plugin: plugin restart counts, plugin load errors
* Agent: pod startup time, agent failure rate
* API/UI latency and error rates

✅ **Best practices**

* Track p50/p95 build durations and queue times.
* Alert when queue length or GC pause exceeds thresholds.

💡 **In short**
Monitor queue/executor usage, build outcomes/durations, JVM health, disk health, and agent reliability.

---

## Q191: How do you identify and resolve performance bottlenecks?

🧠 **Overview**
Diagnose using metrics + logs, replicate slow scenarios in staging, then apply targeted fixes (tune JVM, offload work, scale agents).

⚙️ **Troubleshooting steps**

1. Correlate alerts: queue growth → agent shortage; high GC → JVM tuning.
2. Inspect slow builds: check logs, artifacts, and plugins invoked.
3. Run profiler / heap dump for JVM memory issues.
4. Isolate problematic plugins by disabling/upgrading in staging.
5. Offload heavy tasks to agents or external systems.

🧩 **Commands / tools**

```bash
# JVM heapdump (example)
jcmd <pid> GC.heap_dump /tmp/heapdump.hprof
# Analyze with VisualVM or Eclipse MAT
```

✅ **Best practices**

* Keep controller CPU/IO light by delegating builds to agents.
* Use ephemeral agents and autoscaling to meet spike demand.
* Limit heavy operations on controller (large file archiving, heavy artifact retention).

💡 **In short**
Use metrics + logs → reproduce in staging → tune JVM/scale agents or remove offending plugins.

---

## Q192: What is the Metrics plugin and what does it track?

🧠 **Overview**
The Metrics plugin (or Jenkins Metrics/Prometheus exporters) exposes internal Jenkins metrics (builds, queues, JVM) for scraping by Prometheus.

⚙️ **Typical tracked items**

* Build counts and durations
* Queue length and executor status
* JVM memory, threads, GC metrics
* HTTP request latencies (UI/API)
* Plugin-specific metrics (if instrumented)

🧩 **Integration**

* Use Prometheus exporter plugin or JMX exporter to expose metrics at `/metrics`.

✅ **Best practices**

* Combine with Grafana dashboards; tag metrics with job names, nodes, and labels for drill-down.

💡 **In short**
Metrics plugin exports Jenkins runtime metrics (scheduler, JVM, build lifecycle) for monitoring systems.

---

## Q193: How do you integrate Jenkins metrics with monitoring systems?

🧠 **Overview**
Expose metrics via Prometheus exporters and ship logs/alerts to a centralized stack (Prometheus+Grafana, ELK, Datadog).

⚙️ **How it works**

* Install Prometheus exporter plugin or JMX exporter on Jenkins.
* Configure Prometheus scrape job for Jenkins `/metrics` endpoint.
* Build Grafana dashboards and alerts for key metrics.
* Forward logs via Filebeat/Fluentd to ELK/Cloud logging.

🧩 **Prometheus scrape example**

```yaml
scrape_configs:
  - job_name: 'jenkins'
    static_configs:
      - targets: ['jenkins.example.com:8080']
```

✅ **Best practices**

* Use service discovery in K8s for scraping.
* Create runbooks for common alerts (queue growth, heap OOM).

💡 **In short**
Expose metrics via exporter, scrape with Prometheus, visualize in Grafana, and centralize logs for correlation.

---

## Q194: What strategies would you use for build artifact caching?

🧠 **Overview**
Cache build outputs and dependency layers to reduce network I/O and rebuild times.

⚙️ **How it works**

* Use artifact repositories (Nexus/Artifactory/S3) for jars/images.
* Use dependency caches (Maven/Gradle caches) persisted across builds.
* Use Docker layer caching and registry proxying for images.

🧩 **Example: cache Maven repo on agent**

```groovy
cache(path: '~/.m2', key: "${env.GIT_COMMIT}-m2") {
  sh 'mvn -T 1C -DskipTests package'
}
```

✅ **Best practices**

* Persist caches on fast storage (local SSD or shared cache volumes).
* In Kubernetes, use PVCs or cache sidecar patterns.
* Use immutable artifact names (with git SHA) and clean old caches periodically.

💡 **In short**
Persist dependency caches and use artifact repos + Docker layer caching to accelerate builds.

---

## Q195: How do you implement distributed caching for dependencies?

🧠 **Overview**
Provide a shared cache layer accessible by all agents (remote cache/proxy) to avoid redundant downloads.

⚙️ **Options**

* Repository manager as proxy (Artifactory/Nexus) for Maven/NPM/Pip.
* Remote build cache (Bazel/Gradle Enterprise) or HTTP cache.
* Shared network cache (NFS/EFS) or object-store backed cache with local SSD layer.

🧩 **Example: Nexus as proxy**

* Configure Maven `settings.xml` to point to Nexus as mirror so dependencies are cached centrally.

✅ **Best practices**

* Use local per-node cache + central proxy to minimize latency.
* Ensure cache invalidation/retention policies.
* Secure cache endpoints and monitor hit ratio.

💡 **In short**
Use repository proxies and remote build caches plus local node caches to distribute dependency artifacts efficiently.

---

## Q196: What is the difference between workspace caching and dependency caching?

🧠 **Overview**
Workspace caching keeps build-specific files (checked-out source, intermediate artifacts) between runs; dependency caching stores external libraries/layers shared across builds.

📋 **Comparison Table**

| Aspect         | Workspace Caching                                          | Dependency Caching                                                |
| -------------- | ---------------------------------------------------------- | ----------------------------------------------------------------- |
| Contents       | Source tree, build outputs, intermediate artifacts         | External libs (Maven/NPM), Docker layers                          |
| Scope          | Per-job or per-branch workspace                            | Shared across jobs/agents                                         |
| Purpose        | Speed incremental builds, avoid full checkout              | Avoid downloading dependencies repeatedly                         |
| Implementation | Persist workspace PVC, stash/unstash, incremental checkout | Repo proxy (Nexus), local ~/.m2, Docker layer cache, remote cache |
| Risk           | Can carry stale build artifacts                            | Needs invalidation strategy for new versions                      |

✅ **Best practices**

* Use dependency caching centrally (proxy) and keep workspace caches selective (avoid persisting large temp files).
* Use clean strategies for critical builds to avoid stale state.

💡 **In short**
Workspace cache = per-job state; dependency cache = shared external libraries — both speed builds but have different scopes and invalidation needs.

---

## Q197: How would you optimize Docker layer caching in Jenkins?

🧠 **Overview**
Maximize layer reuse by ordering Dockerfile instructions for cache-friendliness, using buildkit, and reusing base images and layer caches.

⚙️ **How it works**

* Put frequently changing instructions (source copy) at the bottom.
* Install dependencies before copying app code when possible.
* Use multi-stage builds to keep image small.
* Use a shared Docker cache (registry or cache-from) and BuildKit `--cache-from`/`--cache-to`.

🧩 **Dockerfile tips**

```dockerfile
# cache-friendly
FROM node:18
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build
```

🧩 **Build command**

```bash
# use cache-from registry
docker build --cache-from myrepo/myapp:cache --tag myrepo/myapp:${GIT_SHA} .
# or with buildkit
DOCKER_BUILDKIT=1 docker build --cache-from=type=registry,ref=myrepo/cache:latest ...
```

✅ **Best practices**

* Push intermediate cache images to registry to be `--cache-from` by other agents.
* Use dedicated cache builder or remote cache (buildx) for distributed agents.
* Keep base images minimal and versioned.

💡 **In short**
Order Dockerfile for max cache reuse, use BuildKit/remote cache, and push cache images to reuse across agents.

---

## Q198: What strategies would you use for reducing build times?

🧠 **Overview**
Reduce build time with parallelism, caching, incremental builds, lightweight agents, and moving expensive checks off hot paths.

⚙️ **Strategies**

* Parallelize tests and split large suites.
* Use dependency & Docker layer caches.
* Use prebuilt artifacts for reproducible steps.
* Run fast checks in PRs; run heavy scans in scheduled pipelines.
* Use incremental compilation/build tools (Gradle/Maven incremental, Bazel).

🧩 **Examples**

```groovy
parallel {
  unit { sh 'pytest -m unit' }
  integration { sh 'pytest -m integration' }
}
```

✅ **Best practices**

* Profile pipeline to find longest stages, then optimize.
* Pre-warm agents and use local SSDs.
* Avoid unnecessary checkout of large monorepo parts (sparse checkout).

💡 **In short**
Use caching, parallelism, incremental builds, and split heavy tasks out of the critical path.

---

## Q199: How do you implement incremental builds effectively?

🧠 **Overview**
Incremental builds recompile/retest only changed parts using build tools that support incremental mode and by preserving workspace/cache state between builds.

⚙️ **How it works**

* Use build tools with incremental support (Gradle, Maven with incremental plugins, Bazel).
* Persist caches and partial outputs between builds.
* Use change detection to run only affected modules/tests.

🧩 **Example (Gradle)**

```groovy
# Gradle uses .gradle caches and incremental compilation by default
./gradlew assemble --no-daemon
```

🧩 **Monorepo pattern**

* Compute changed modules: `git diff --name-only $BASE..HEAD` and run builds only for those modules.

✅ **Best practices**

* Maintain clean cache invalidation rules.
* Use targeted test selection for changed modules.
* Combine with CI matrix jobs to parallelize module builds.

💡 **In short**
Use incremental-capable build tools + preserved caches and change-based execution to avoid full rebuilds.

---

## Q200: What is build fingerprinting and how does it optimize pipelines?

🧠 **Overview**
Build fingerprinting uniquely identifies artifacts (by checksum) and records provenance in Jenkins so you can track where an artifact was produced/used and avoid redundant work.

⚙️ **How it works**

* Jenkins fingerprinting stores checksums (MD5/SHA) of artifacts and maps them to builds.
* It enables traceability, reuse (promote same artifact), and detection of duplicate artifacts across builds.

🧩 **Example**

```groovy
// Archive & fingerprint
archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
// Later you can query fingerprint info via Jenkins API to find origins
```

✅ **Benefits / Best practices**

* Prevents rebuilding identical artifacts unnecessarily; you can promote the same fingerprint across environments.
* Enables auditability: trace artifact → build → git SHA → deploys.
* Combine fingerprinting with artifact repository metadata for robust provenance.

💡 **In short**
Fingerprinting gives immutable IDs to artifacts for provenance, reuse, and avoiding duplicate rebuilds — improving traceability and efficiency.

---

# Troubleshooting / Scenarios

## Q201: Jenkins builds are stuck in queue and not starting

🧠 **Overview**
Builds remain queued when Jenkins lacks available executors, agents are misconfigured, or system throttling plugins block execution.

⚙️ **What to Investigate**

* Executors: **Manage Jenkins → Nodes → # of executors**
* Labels mismatch between pipeline and agent
* Pending shutdown (`Prepare for shutdown`)
* Plugins like **Throttle Concurrent Builds**, **Lockable Resources**
* Check node offline/agent logs

🧩 **Quick Checks**

```groovy
agent { label 'linux-node' } // ensure node exists + online
```

📋 **Possible causes**

| Issue          | Check                  |
| -------------- | ---------------------- |
| No executors   | Node config            |
| Label mismatch | Pipeline vs node label |
| Throttling     | Plugin settings        |
| Node offline   | Agent logs             |
| Queue blocked  | Jenkins safe-restart   |

✅ **Best Practices**

* Keep executors minimal per node
* Use labels intentionally
* Monitor node health via Prometheus/Grafana

💡 **In short**: Check executors, node labels, offline nodes, throttling plugins, and pending shutdown.

---

## Q202: An agent went offline and builds are failing — troubleshooting steps

🧠 **Overview**
Agents go offline due to network issues, JVM crashes, misconfigured credentials, or resource exhaustion.

⚙️ **What to Check**

* Agent log: **Manage Nodes → Agent → Log**
* Network connectivity: `ping`, `telnet <master>:50000`
* Java version mismatch
* Disk/CPU exhaustion
* SSH key or JNLP secret expired
* Firewall/NAT issues

🧩 **Commands**

```bash
journalctl -u jenkins-agent.service --no-pager
netstat -ntlp | grep 50000
```

✅ **Best Practices**

* Run agents with systemd + auto-restart
* Monitor via CloudWatch/Prometheus
* Use ephemeral agents (K8s, ECS)

💡 **In short**: Check logs, connectivity, Java versions, credentials, and resource limits.

---

## Q203: Jenkins master is running out of disk space — immediate actions

🧠 **Overview**
Low disk leads to UI failures, job failures, and corrupted workspaces.

⚙️ **Immediate Actions**

* Clean **/var/lib/jenkins/workspace/**
* Remove old builds: **“Discard Old Builds”**
* Clear logs: `/var/log/jenkins/*.log`
* Remove unused plugins
* Rotate audit/log archives
* Grow volume (LVM/EBS) as permanent fix

🧩 **Commands**

```bash
du -sh /var/lib/jenkins/* | sort -h
rm -rf /var/lib/jenkins/workspace/<job>/builds/*
```

💡 **In short**: Clean workspaces, rotate logs, delete old builds, and scale the disk.

---

## Q204: Pipeline failing with **workspace cleanup** errors

🧠 **Overview**
Occurs when Jenkins cannot delete workspace folders due to file locks, permissions, or lingering processes.

⚙️ **How to Resolve**

* Kill leftover processes holding files
* Fix permissions: `chown -R jenkins:jenkins /workspace`
* Disable aggressive workspace cleanups on Windows
* Remove locked `.git` directories manually
* Ensure no parallel builds using same workspace

🧩 **Commands**

```bash
lsof +D /var/lib/jenkins/workspace/job1
```

💡 **In short**: Check file locks, permissions, `.git` folder issues, and parallel builds.

---

## Q205: Builds failing with **"checkout SCM"** errors

🧠 **Overview**
SCM checkout fails due to Git connectivity, credentials, branch mismatch, or corrupted workspace.

⚙️ **What to Check**

* Repo URL correctness
* Credentials scope + validity
* Branch exists
* Shallow clone issues
* Workspace cleanup + re-clone
* Git plugin version

🧩 **Commands**

```bash
git ls-remote <repo-url>
rm -rf /var/lib/jenkins/workspace/<job>/.git
```

💡 **In short**: Validate credentials, repo URL, branch, and clean corrupted workspace.

---

## Q206: Jenkins cannot connect to Git repository — investigate authentication issues

🧠 **Overview**
Authentication issues arise from wrong credentials, token expiry, or missing Git host keys.

⚙️ **Checklist**

* SSH key loaded into Jenkins Credentials
* Known_hosts entry exists
* PAT/Token validity
* OAuth scopes for GitHub/GitLab
* Firewall blocking SSH/HTTPS
* Proxy issues

📋 **Table**

| Repo Type  | Common Auth Failures           |
| ---------- | ------------------------------ |
| SSH Git    | Wrong key, missing known_hosts |
| HTTPS      | Expired token, MFA enforced    |
| GitHub App | Expired installation token     |

🧩 **Commands**

```bash
ssh -T git@github.com
curl -I https://gitlab.com
```

💡 **In short**: Validate SSH keys, tokens, scopes, and network/firewall connectivity.

---

## Q207: A pipeline step is hanging indefinitely — debugging steps

🧠 **Overview**
Hangs usually indicate stuck processes, network waits, locks, or missing Jenkins `timeout()` wrapper.

⚙️ **Debug Steps**

* Add `timeout()` to isolates issue
* Check agent CPU/IO load
* Enable **pipeline debug logging**
* Kill orphaned processes
* Check container runtime issues (Docker build hanging)
* Use `set -x` for shell debugging

🧩 **Jenkinsfile**

```groovy
timeout(time: 5, unit: 'MINUTES') {
    sh 'docker build .'
}
```

💡 **In short**: Add timeouts, inspect agent resource usage, and debug shell/Docker commands.

---

## Q208: Jenkins consuming excessive memory — what to investigate

🧠 **Overview**
High memory usage comes from too many plugins, large builds, heavy pipelines, or misconfigured JVM.

⚙️ **Investigate**

* Heap size using `java -XshowSettings:vm`
* Plugin bloat (freestyle → pipeline migration)
* Large workspace retention
* Old build logs
* Infinite loops in shared libraries
* GC issues

🧩 **Example JVM options**

```
-Xms2g -Xmx4g -XX:+UseG1GC
```

💡 **In short**: Check heap size, plugins, build retention, and JVM GC behavior.

---

## Q209: Build logs not appearing in console output — what's wrong?

🧠 **Overview**
Caused by buffering, pipeline misuse, agent logs redirecting incorrectly, or plugins breaking console streaming.

⚙️ **Check**

* Misuse of `sh(returnStdout: true)` (output captured instead of streamed)
* Kubernetes agents missing TTY
* Logging plugins interfering
* Worker filesystem full
* Check `Manage Jenkins → System Log`

🧩 **Fix**

```groovy
sh(script: "echo hello", returnStdout: false)
```

💡 **In short**: Fix stdout capture, check agent logging, TTY configs, and plugin issues.

---

## Q210: Shared library cannot be loaded — what to check

🧠 **Overview**
Shared libraries fail when repo is inaccessible, branch doesn't exist, or library structure is invalid.

⚙️ **Checklist**

* Repo URL + credentials
* `vars/` or `src/` structure correct
* Version/branch/tag exists
* Library @version in Jenkinsfile is valid
* SCM API rate-limiting issues
* Library caching corruption

🧩 **Example**

```groovy
@Library('my-shared-lib@main') _
```

💡 **In short**: Verify repo access, folder structure, and correct version reference.

---

## Q211: Pipeline fails with **"No such DSL method"** — how to resolve it

🧠 **Overview**
Occurs when pipeline syntax uses unsupported steps, missing plugins, or outdated plugin versions.

⚙️ **Fix**

* Install required plugins (e.g., Kubernetes plugin for `kubernetesPodTemplate`)
* Update pipeline + shared library versions
* Confirm syntax with **Snippet Generator**
* Clear library cache

🧩 **Example**

```groovy
// wrong
dockerNode { ... }

// correct
docker.withRegistry('https://registry.local') { ... }
```

💡 **In short**: Install needed plugins and ensure your DSL syntax matches pipeline capabilities.

---

## Q212: Jenkins UI extremely slow — performance checks

🧠 **Overview**
Slow UI typically results from huge build history, plugin overload, low RAM, or large job configurations.

⚙️ **Investigate**

* Heap usage + GC
* Build history cleanup
* Too many installed plugins
* Slow storage (NFS latency)
* Reverse proxy misconfig
* High CPU load on master

🧩 **Commands**

```bash
iostat -xm 1
top -o %MEM
```

💡 **In short**: Reduce plugin count, clean builds, increase JVM memory, and fix slow storage.

---

## Q213: Agents are connecting but builds still fail to start — why?

🧠 **Overview**
Agents appear online, but builds cannot start due to executor limits, label mismatches, or throttling constraints.

⚙️ **Check**

* Executors = 0 on agent
* Labels not matching pipeline
* Node in “temporarily offline” maintenance mode
* Queue stuck on a resource lock
* Agent connected but not accepting tasks (JNLP mismatches)

📋 **Table**

| Problem            | Indicator             | Fix                         |
| ------------------ | --------------------- | --------------------------- |
| Executors = 0      | Agent online but idle | Set executors > 1           |
| Label mismatch     | Job waiting for label | Update Jenkinsfile          |
| Lockable resources | Queue waits           | Release/stabilize resources |
| Node maintenance   | Red icon              | Bring node online           |

💡 **In short**: Check executors, labels, locks, and maintenance state.

---

## Q214: A multibranch pipeline is not discovering new branches. What would you check?

🧠 **Overview**
Multibranch jobs fail to discover branches when SCM settings, scan triggers, or credentials are wrong — or when branch indexing is blocked by plugins or performance limits.

⚙️ **What to check**

* Branch indexing status and last scan time (`Scan Repository Log`).
* Credentials used by the multibranch job (scope/permission).
* Webhook delivery vs. periodic scan (which is configured).
* Branch filtering rules (discover branches strategy, `Jenkinsfile` path).
* Branch name patterns / PR strategy (e.g., only `origin/*`).
* Git provider API rate limiting or permissions (app/token scopes).

🧩 **Commands / Examples**

```bash
# Check job logs on master
tail -n 200 /var/log/jenkins/jenkins.log | grep "BranchIndexing"

# Force a scan from CLI (script console)
Jenkins.instance.getItemByFullName('org/repo').getSCMs().each{ it.scheduleBuild2(0) }
```

**Jenkinsfile (ensure present in branch root)**

```groovy
pipeline {
  agent any
  stages { stage('build'){ steps { sh 'echo hi' } } }
}
```

📋 **Checklist table**

| Area            | What to inspect                                  |
| --------------- | ------------------------------------------------ |
| Credentials     | Token scopes, SSH key, credentials ID in job     |
| Indexing        | Last scanned time, errors in Scan Repository Log |
| Branch filters  | Regex or strategy hiding branches                |
| Webhooks        | Webhook delivery logs at git host                |
| Provider limits | API rate limits, repo access level               |

✅ **Best Practices**

* Use GitHub/GitLab App or PAT with minimal required scopes.
* Enable webhooks for immediate indexing and reduce scan frequency.
* Configure clear include/exclude branch filters.
* Keep `Jenkinsfile` path consistent across branches.

💡 **In short**: Check branch scan logs, credentials, branch filters, and webhook delivery — then force a rescan or fix token permissions.

---

## Q215: Webhook triggers are not working. How do you troubleshoot?

🧠 **Overview**
Webhook failures usually stem from delivery errors, network/firewall, wrong URL, authentication, or CSRF/security settings in Jenkins.

⚙️ **Debug steps**

* Inspect webhook delivery logs on Git host (status codes, response body).
* Validate Jenkins endpoint: `https://jenkins.example.com/github-webhook/` or `…/git/notifyCommit`.
* Test inbound connectivity from Git host to Jenkins (`curl` from remote environment).
* Check reverse proxy (Nginx/ALB) forwarding, SSL termination, and headers.
* Verify Jenkins CSRF protection and webhook token (if using GitHub App/Secret).
* Ensure correct webhook event types selected (push, PR, tag).

🧩 **Commands / Examples**

```bash
# From a machine with same network path as git provider
curl -v -X POST "https://jenkins.example.com/github-webhook/" -H "Content-Type: application/json" --data '{"zen":"Test"}'

# Check GitHub delivery (GitHub UI) -> Recent Deliveries -> Response
```

📋 **Common failure table**

| Symptom      | Likely cause                     | Action                           |
| ------------ | -------------------------------- | -------------------------------- |
| 4xx response | Bad webhook URL / auth           | Fix URL, secret, or token        |
| 5xx response | Jenkins error or proxy misconfig | Check Jenkins logs, proxy config |
| No attempt   | Network blocked by firewall      | Open port / use webhook relay    |
| Wrong events | Event not selected               | Enable push/PR events            |

✅ **Best Practices**

* Use Git provider app (better than PAT) and verify webhook secret.
* Enable HTTPS and health-check endpoints.
* Configure firewall rules to allow provider IPs or use a relay.
* Monitor webhook deliveries and set alerts on failures.

💡 **In short**: Check delivery status on git host, test connectivity to the webhook URL, inspect reverse-proxy and CSRF settings, and confirm event/secret configuration.

---

## Q216: SCM polling is causing performance issues. What's the solution?

🧠 **Overview**
Polling frequently causes excessive API/gateway load and master CPU; replace polling with webhooks or reduce poll frequency and scope.

⚙️ **Solutions**

* Prefer webhooks (push/PR) over polling.
* Reduce polling frequency or restrict to specific branches.
* Use lightweight discovery (shallow clone / single-branch).
* Limit number of multibranch jobs scanning concurrently (throttle).
* Offload scanning to secondary indexing nodes (if using plugins).

🧩 **Config snippets**

```groovy
// Jenkinsfile: avoid long legacy polling blocks; use SCM trigger via webhook instead
triggers { pollSCM('@daily') } // if absolutely needed reduce frequency
```

📋 **Comparison table**

| Option                   | Pros                | Cons                          |
| ------------------------ | ------------------- | ----------------------------- |
| Webhooks                 | Immediate, low load | Requires inbound connectivity |
| Polling (low frequency)  | Simple              | Delayed, still load           |
| Polling (high frequency) | Near real-time      | Heavy load, rate limits       |

✅ **Best Practices**

* Use webhooks + secure token.
* Combine webhooks with occasional full scans (nightly).
* Use provider-side filtering (only push/PR events).
* Monitor API rate usage and set backoff.

💡 **In short**: Replace polling with webhooks; if polling remains, drastically reduce frequency and scope.

---

## Q217: Credentials are not being found in pipeline. What would you verify?

🧠 **Overview**
Credentials missing in pipeline are usually due to wrong credentials ID, scope (system vs. folder), plugin support, or sandbox restrictions.

⚙️ **What to verify**

* Correct `credentialsId` used in `withCredentials` or `credentials()` call.
* Credential scope: **Global/System**, **Folder**, or **Item** and pipeline location.
* Appropriate credential type (SSH, secret text, username/password).
* Permissions: job/role-based access control may hide creds.
* Credentials binding plugin installed and up-to-date.
* If using Declarative: use `credentials(...)` syntax correctly.

🧩 **Examples**

```groovy
// Declarative
environment {
  GIT_TOKEN = credentials('git-pat-id')
}

// Scripted
withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
  sh 'curl -u $USER:$PASS ...'
}
```

📋 **Checklist**

| Item          | How to check                                    |
| ------------- | ----------------------------------------------- |
| credentialsId | Manage Jenkins → Credentials → find ID          |
| Scope         | Ensure folder/global scope matches job location |
| RBAC          | Check Role Strategy / Credentials visibility    |
| Plugin        | Credentials Binding plugin installed            |

✅ **Best Practices**

* Store minimal-scope credentials and reference by stable ID.
* Use folder-scoped credentials for repo-specific secrets.
* Avoid hardcoding secrets in Jenkinsfiles; use IDs.
* Use credential rotation and audit logs.

💡 **In short**: Confirm the credentials ID and scope, check RBAC/visibility, and ensure the correct binding API is used.

---

## Q218: A pipeline fails with permission denied errors on agent. How do you fix this?

🧠 **Overview**
Permission denied errors on agents often come from filesystem ownership, missing group membership, SELinux/AppArmor restrictions, or container user mismatches.

⚙️ **Troubleshooting / Fixes**

* Check file ownership and permissions (`ls -l`).
* Ensure agent runs as `jenkins` (or intended user).
* For Docker agents, verify container `USER` and volume mount permissions.
* For SSH agents, ensure remote user has proper home/SSH permissions.
* Check SELinux contexts (`getenforce`, `ls -Z`) and AppArmor profiles.
* Verify `umask` and sticky bits for shared workspaces.

🧩 **Commands**

```bash
# On agent
ls -la /home/jenkins/workspace/job1
chown -R jenkins:jenkins /home/jenkins/workspace/job1
# Docker: run container with matching UID
docker run -u 1000:1000 -v /host/ws:/home/jenkins/ws ...
```

📋 **Common scenarios**

| Scenario                                            | Fix                                        |
| --------------------------------------------------- | ------------------------------------------ |
| Mounted workspace owned by root                     | chown or mount with correct UID/GID        |
| Docker container running as root but host disallows | Run container as matching UID              |
| SELinux blocked write                               | Adjust context or set boolean / restorecon |
| Missing execute bit                                 | chmod +x the script                        |

✅ **Best Practices**

* Use consistent UID/GID across host and containers.
* Use non-root agents or explicit user mapping in containers.
* Use `initContainers` (K8s) to set permissions on volumes.
* Audit permissions and automate remediation in startup scripts.

💡 **In short**: Fix ownership/UID mismatches, adjust container user settings or SELinux/AppArmor, and ensure agent user has proper permissions.

---

## Q219: Docker builds are failing with "Cannot connect to Docker daemon" error. What's wrong?

🧠 **Overview**
This happens when the agent/container lacks access to Docker daemon (socket), Docker is stopped, or permissions to `/var/run/docker.sock` are incorrect.

⚙️ **What to check**

* Is Docker daemon running on agent (`systemctl status docker`)?
* Is `/var/run/docker.sock` mounted into agent container (if using DinD or docker-outside-of-docker)?
* Does the Jenkins user have permission to access the Docker socket?
* If using Docker-in-Docker (DinD), are privileged mode & correct network set?
* For Kubernetes agents, check if `docker` binary exists and if `docker.sock` mount is allowed.

🧩 **Commands / Examples**

```bash
# On agent
sudo systemctl status docker
sudo docker info

# Example: run agent with docker socket
docker run -v /var/run/docker.sock:/var/run/docker.sock jenkins/agent
# Or use Docker BuildKit + docker CLI in Kubernetes: use kaniko or buildkit instead of socket mount
```

📋 **Alternatives table**

| Approach                | When to use                           |
| ----------------------- | ------------------------------------- |
| Mount host docker.sock  | Simpler, but security risk            |
| DinD (privileged)       | Isolated builds, more complex         |
| Kaniko/BuildKit/Buildah | Recommended for K8s (no socket mount) |

✅ **Best Practices**

* Prefer non-socket solutions on Kubernetes (kaniko/buildkit).
* If socket is necessary, restrict which containers can mount it and audit.
* Ensure Jenkins user is in `docker` group or use `sudo` wrapper carefully.

💡 **In short**: Ensure Docker daemon is running, socket access/mounts are present and permitted, or switch to secure build tools (kaniko) in K8s.

---

## Q220: Kubernetes plugin cannot spawn pods. What would you investigate?

🧠 **Overview**
The Kubernetes plugin fails to create pods when kubeconfig/credentials are wrong, cluster RBAC denies creation, imagePull issues exist, or resource quotas prevent scheduling.

⚙️ **Investigate**

* Jenkins credentials/kubeconfig validity and cluster endpoint reachability.
* Role/ClusterRole bindings for Jenkins service account (create pods, secrets).
* Node selectors, taints/tolerations, and insufficient resources/quota.
* PodTemplate YAML correctness (image, command, volume mounts).
* Image pull secrets and private registry access.
* Check Kubernetes API server logs and Jenkins system log for errors.

🧩 **Commands**

```bash
# From Jenkins master container/pod
kubectl --kubeconfig=/path/to/kubeconfig get nodes
kubectl auth can-i create pods --as=system:serviceaccount:ci:jenkins
kubectl describe quota
```

📋 **Failure signals**

| Error message                     | Likely cause            |
| --------------------------------- | ----------------------- |
| `Forbidden`                       | RBAC missing            |
| `ImagePullBackOff`                | Registry auth           |
| `Insufficient cpu/memory`         | Node resources / quota  |
| `no matches for kind PodTemplate` | Wrong plugin/CRD config |

✅ **Best Practices**

* Use a dedicated Jenkins service account with minimal RBAC allowing pod creation.
* Test kubeconfig from Jenkins host.
* Use node selectors and tolerations that match available nodes.
* Provide imagePullSecrets for private registries.

💡 **In short**: Validate kubeconfig/credentials and RBAC, check cluster capacity and pod template for image/secret issues.

---

## Q221: Jenkins backup restoration failed. What recovery steps would you take?

🧠 **Overview**
Failed restorations can corrupt job state; recovery requires careful rollback, integrity checks, and recreating missing configs from backups or VCS.

⚙️ **Recovery steps**

1. **Stop Jenkins** to avoid writes.
2. **Take a snapshot** of current state (even broken) for forensics.
3. Validate backup integrity (tar/zip checksum).
4. Restore `JENKINS_HOME` incrementally: `config.xml`, `credentials.xml`, `jobs/`, `secrets/`.
5. Run `jenkins-cli safe-restart` after restore.
6. Recreate missing pieces from source control (pipeline Jenkinsfiles, seed jobs).
7. If credentials/secrets fail, restore them cautiously and rotate secrets once recovered.
8. If full restore impossible, spin up a fresh Jenkins and import jobs via Job DSL or folder export.

🧩 **Commands**

```bash
# Stop Jenkins
sudo systemctl stop jenkins
# Extract selective files
tar -xzf jenkins-backup.tgz etc/config.xml jobs/credentials.xml -C /var/lib/jenkins
chown -R jenkins:jenkins /var/lib/jenkins
sudo systemctl start jenkins
```

📋 **Restore priority**

1. `config.xml`, `jenkins.model.JenkinsLocationConfiguration.xml`
2. `credentials.xml` (restore carefully)
3. `jobs/` and `users/`
4. `plugins/` (install matching versions)
5. `secrets/` and `nodes/`

✅ **Best Practices**

* Keep plugins and Jenkins core version pinned; restore plugins before job configs when possible.
* Store job configs and shared libraries in Git to avoid full JENKINS_HOME reliance.
* Automate backup + periodic test restores.
* Rotate credentials after recovery.

💡 **In short**: Stop Jenkins, snapshot current state, restore critical XMLs first (config, credentials, jobs), ensure plugin parity, and rotate secrets after recovery.

---

## Q222: Plugins are conflicting and causing Jenkins instability. How do you resolve this?

🧠 **Overview**
Plugin conflicts often arise from incompatible versions, transitive dependency mismatches, or deprecated APIs.

⚙️ **Resolution steps**

* Check **Manage Plugins → Installed** for recent updates and known incompatibilities.
* Review `jenkins.log` for stack traces referencing plugin names.
* Roll back problematic plugins to known-good versions.
* Boot Jenkins with `--debug` or start in safe mode (`?safe=true`) to disable plugins.
* Use Plugin Manager CLI to list and install specific versions.
* Test plugin upgrades in a staging environment before production.

🧩 **CLI examples**

```bash
# Safe mode: start Jenkins with --argumentsRealm.passwd.admin=admin --httpPort=8080?safe=true
# Using jenkins-plugin-cli to install a specific version
jenkins-plugin-cli --plugins kubernetes:1.40.0 workflow-aggregator:2.6
```

📋 **Decision table**

| Step      | Tool                  | Why                     |
| --------- | --------------------- | ----------------------- |
| Identify  | Logs + plugin manager | Find offending plugin   |
| Isolate   | Safe mode             | Start without plugins   |
| Roll back | plugin-cli            | Restore stable versions |
| Test      | Staging Jenkins       | Avoid repeat issues     |

✅ **Best Practices**

* Pin plugin versions in automation (ansible/terraform).
* Maintain a staging Jenkins to test plugin upgrades and core upgrades.
* Keep changelogs and a rollback playbook for plugin management.
* Limit number of plugins to minimal required.

💡 **In short**: Use safe mode to isolate, identify offending plugins from logs, roll back versions, and test upgrades in staging.

---

## Q223: A plugin update broke existing pipelines. How do you roll back?

🧠 **Overview**
Rolling back returns the plugin to a previous version, ensuring API compatibility for pipelines.

⚙️ **Rollback steps**

1. Identify the plugin and version that caused the break (from logs).
2. Download the previous `.hpi`/`.jpi` from plugin repository.
3. Stop Jenkins, replace the plugin file in `${JENKINS_HOME}/plugins/`, remove the corresponding `*.jpi.pinned` if present.
4. Delete `${JENKINS_HOME}/plugins/<plugin>/` folder to clear cached classes if needed.
5. Start Jenkins and confirm functionality.
6. Pin the plugin version to avoid auto-upgrade.

🧩 **Commands**

```bash
# Example: rollback plugin
wget https://updates.jenkins.io/download/plugins/git/4.10.0/git.hpi -O /var/lib/jenkins/plugins/git.jpi
chown jenkins:jenkins /var/lib/jenkins/plugins/git.jpi
rm -rf /var/lib/jenkins/plugins/git/ /var/lib/jenkins/plugins/git.jpi.pinned
systemctl restart jenkins
```

📋 **Precautions**

| Action                     | Why                                              |
| -------------------------- | ------------------------------------------------ |
| Backup plugins dir         | Quick restore if rollback fails                  |
| Verify plugin dependencies | Some plugins require specific versions of others |
| Test on staging            | Prevent production breakage                      |

✅ **Best Practices**

* Pin plugin versions in CI automation and disable automatic updates.
* Maintain archive of approved plugin versions.
* Test plugin upgrades in a clone before production.

💡 **In short**: Stop Jenkins, replace plugin with the known-good `.hpi`, clear caches if necessary, restart, and pin the version.

---

## Q224: Email notifications are not being sent. What SMTP configuration would you check?

🧠 **Overview**
Email failures generally result from wrong SMTP host/port, auth failures, TLS issues, or blocked outbound network.

⚙️ **What to verify**

* SMTP host, port, and whether TLS/SSL is required (`Manage Jenkins → Configure System → E-mail Notification` / `Extended E-mail Notification`).
* Credentials used for SMTP authentication are correct and scoped properly.
* Sender email address is valid and allowed by SMTP server (some servers block arbitrary `From`).
* Network connectivity from Jenkins to SMTP (`telnet smtp.example.com 587`).
* Check Jenkins logs for SMTP errors (auth failed, send failed).
* If using third-party providers (SES, Gmail), ensure app passwords, IAM/SMTP credentials, or less-secure-app settings are configured.

🧩 **Commands / Examples**

```bash
# Test SMTP connectivity
telnet smtp.gmail.com 587
# Or use openssl for TLS
openssl s_client -starttls smtp -crlf -connect smtp.gmail.com:587
```

**Jenkins config snippet (script console test)**

```groovy
import javax.mail.*
def props = System.getProperties()
props.setProperty("mail.smtp.host","smtp.example.com")
props.setProperty("mail.smtp.port","587")
println "Can connect? " + (/* custom SMTP test logic */ true)
```

📋 **Common error table**

| Symptom                   | Likely cause                 | Action                           |
| ------------------------- | ---------------------------- | -------------------------------- |
| Authentication failed     | Wrong creds or 2FA           | Use app password / correct creds |
| Connection timed out      | Firewall blocking            | Open outbound port               |
| STARTTLS error            | TLS mismatch                 | Match TLS/SSL setting            |
| Bounce with SPF/DKIM fail | Sender domain not authorized | Fix SPF/DKIM records             |

✅ **Best Practices**

* Use dedicated SMTP credentials and rotate them.
* Configure SPF/DKIM/DMARC for sender domain to avoid bounces.
* Monitor email delivery (logs or provider dashboard).
* Use provider-specific plugins if available (AWS SES plugin).

💡 **In short**: Verify SMTP host/port/TLS, credentials and network connectivity, and check logs for auth/TLS errors — ensure sender domain is authorized.

----
## Q225: Slack integration is failing silently. How do you debug this?

🧠 **Overview**
Silent Slack failures usually mean messages are being dropped (bad webhook/token), rate-limited, or failing TLS/network but errors aren’t surfaced in Jenkins.

⚙️ **What to check**

* Delivery: webhook URL or Slack App token validity.
* Response: check Jenkins system log for 2xx/4xx/5xx responses.
* Rate limits: Slack may return 429 — check headers.
* Message format: blocked by app scopes (chat:write).
* Network: proxy, firewall, or TLS trust issues.
* Plugin config: correct credential ID and channel name.
* Silent failures: plugin swallowing exceptions — enable debug logging.

🧩 **Examples / Commands**

```bash
# test webhook from Jenkins master host
curl -X POST -H 'Content-type: application/json' --data '{"text":"test"}' https://hooks.slack.com/services/XXX/YYY/ZZZ
# check Jenkins logs
tail -n 200 /var/log/jenkins/jenkins.log | grep -i slack
```

Jenkinsfile snippet (Slack plugin)

```groovy
slackSend(channel: '#ci', color: 'good', message: "Build ${env.BUILD_URL}")
```

📋 **Troubleshoot table**

| Symptom            | Check                                           |
| ------------------ | ----------------------------------------------- |
| No message, 200 OK | Payload rejected by app (check channel, format) |
| 4xx                | Bad webhook/token/scopes                        |
| 5xx or timeout     | Network/proxy to Slack                          |
| No log entries     | Plugin not called or logging level low          |

✅ **Best Practices**

* Use Slack Apps (OAuth) with narrow scopes (chat:write).
* Add retry logic or webhook queueing.
* Enable plugin debug logging during investigation.
* Monitor Slack API usage and backoff on 429.

💡 **In short**: Validate webhook/token & scopes, test curl from Jenkins host, inspect logs for HTTP responses and enable plugin debug logging.

---

## Q226: Artifacts are not being archived. What post-build configuration is wrong?

🧠 **Overview**
Artifacts fail to archive when paths/globs are wrong, workspace cleaned before archiving, or archive step absent/mis-scoped.

⚙️ **What to check**

* Archive step presence and correct glob (e.g., `**/target/*.jar`).
* Stage ordering: archive must run **after** build produces artifacts.
* Workspace cleanup (post-step) may delete artifacts before archiving.
* File permissions preventing Jenkins from reading files.
* Pipeline vs freestyle: Declarative `archiveArtifacts` vs Post-build `Archive the artifacts`.

🧩 **Examples**
Declarative:

```groovy
stage('Package') { steps { sh 'mvn package -DskipTests' } }
stage('Archive') { steps { archiveArtifacts artifacts: 'target/*.jar', fingerprint: true } }
```

Freestyle: Configure → Post-build Actions → Archive the artifacts → `target/*.jar`

📋 **Common misconfigs**

| Mistake                | Symptom            | Fix                                     |
| ---------------------- | ------------------ | --------------------------------------- |
| Wrong glob             | No files archived  | Use `ls -R` to verify path, update glob |
| CleanUp before archive | Nothing to archive | Move cleanup to post-archive            |
| Running on wrong node  | Path missing       | Ensure archive runs on same workspace   |

✅ **Best Practices**

* Use `fingerprint: true` for traceability.
* Archive only necessary files to save storage.
* In multi-node pipelines, use `stash/unstash` before archive or ensure artifact is on master when archiving.

💡 **In short**: Verify archive step and glob, ensure artifacts exist at that stage, avoid premature cleanup, and confirm node/workspace consistency.

---

## Q227: Test results are not being displayed. What plugin issues would you check?

🧠 **Overview**
JUnit/TestNG/xUnit results don’t show when reporter plugin missing, incompatible plugin versions, wrong result path, or XML malformed.

⚙️ **What to check**

* Test report publisher installed (JUnit, xUnit).
* Correct result glob (`**/target/surefire-reports/*.xml`).
* Test XML validity (malformed or empty).
* Plugin version compatibility with Jenkins core.
* Pipeline uses `junit` step (Declarative) vs freestyle post-build action.
* Agent produced reports on a different node than the aggregator step.

🧩 **Examples**
Declarative:

```groovy
post {
  always {
    junit '**/target/surefire-reports/*.xml'
  }
}
```

Validate XML:

```bash
xmllint --noout target/surefire-reports/TEST-*.xml
```

📋 **Plugin/issue table**

| Issue               | Check                                |
| ------------------- | ------------------------------------ |
| Missing plugin      | Manage Plugins → Installed           |
| Wrong path          | `ls -R` in workspace                 |
| Corrupt XML         | xmllint                              |
| Incompatible plugin | Jenkins/system logs for class errors |

✅ **Best Practices**

* Fail fast on parsing errors by checking logs.
* Publish test reports from same node where they are generated (use `stash/unstash` if needed).
* Keep testing plugins updated in staging before production.

💡 **In short**: Ensure test publisher plugin installed, verify XMLs exist & are valid, check glob/path and node where reports are stored.

---

## Q228: SonarQube analysis is failing in pipeline. How do you troubleshoot?

🧠 **Overview**
Failures stem from Sonar server connectivity, authentication tokens, incorrect scanner properties, or incompatible scanner version.

⚙️ **What to check**

* Server URL and token validity (SonarQube authentication).
* `sonar.projectKey` and `sonar.sources` paths.
* Scanner version compatibility with SonarQube server.
* Network/proxy issues and certificate trust.
* Analysis fails due to missing `sonar.login` or permission to create/update project.
* Quality gate blocking pipeline (if configured to fail on gate).

🧩 **Examples**
Maven:

```bash
mvn sonar:sonar -Dsonar.host.url=https://sonar.example.com -Dsonar.login=${SONAR_TOKEN}
```

Standalone scanner (pipeline):

```groovy
withCredentials([string(credentialsId:'sonar-token', variable:'SONAR_TOKEN')]) {
  sh "sonar-scanner -Dsonar.login=$SONAR_TOKEN -Dsonar.projectKey=my-app"
}
```

📋 **Troubleshoot table**

| Symptom             | Likely cause           | Action                                         |
| ------------------- | ---------------------- | ---------------------------------------------- |
| Auth failed         | Invalid token or perms | Regenerate token, grant execute/analysis perms |
| Cannot reach server | Network/SSL            | Test curl, add CA                              |
| Analysis errors     | Wrong paths            | Verify `sonar.sources`                         |
| Quality gate fail   | Rules violations       | Inspect Sonar dashboard & logs                 |

✅ **Best Practices**

* Store tokens in Jenkins Credentials and rotate regularly.
* Pin scanner versions and test upgrades.
* Use `waitForQualityGate` (with timeout) in pipeline to make gate behavior explicit.
* Emit verbose scanner logs for troubleshooting (`-X`).

💡 **In short**: Validate Sonar URL/token/permissions, verify scanner config and paths, confirm network/SSL, and review Sonar server logs and quality gate output.

---

## Q229: Maven builds cannot download dependencies. What repository configuration is wrong?

🧠 **Overview**
Dependency download fails due to wrong repository URL, credentials for private repos, proxy settings, or blocked DNS/network.

⚙️ **What to verify**

* `settings.xml` mirrors/repositories config and credentials (server id).
* Nexus/Artifactory credentials and repository URL.
* Corporate proxy in `settings.xml` (proxy host/port/username).
* SSL certificate trust when repo uses self-signed cert.
* `~/.m2/settings-security.xml` for encrypted passwords if used.
* Repository `release/snapshot` policy versus dependency type.

🧩 **Examples**
`settings.xml` server entry:

```xml
<servers>
  <server>
    <id>internal-nexus</id>
    <username>deploy</username>
    <password>${env.NEXUS_PASS}</password>
  </server>
</servers>
```

Test curl from agent:

```bash
curl -I https://nexus.example.com/repository/maven-public/
```

📋 **Common misconfigs**

| Problem       | Symptom                   | Fix                                            |
| ------------- | ------------------------- | ---------------------------------------------- |
| Wrong repo id | Maven can't find artifact | Align `pom.xml` repo id with `settings.xml`    |
| Missing creds | 401 from repo             | Add server creds in `settings.xml`             |
| Proxy missing | Timeouts                  | Add proxy section in `settings.xml`            |
| SSL fail      | SSL errors                | Add CA or disable strict SSL (not recommended) |

✅ **Best Practices**

* Keep `settings.xml` in CI credentials and inject securely.
* Use repository manager (Nexus/Artifactory) as single source of truth.
* Cache external deps in internal repo to avoid external outages.

💡 **In short**: Check `settings.xml` for correct repo IDs/credentials/proxy, verify network and SSL, and ensure repository policies match dependency types.

---

## Q230: Docker image push to registry is failing. What credentials/permissions would you verify?

🧠 **Overview**
Push failures usually come from invalid login, insufficient permissions (push not allowed), or wrong image name/namespace.

⚙️ **What to verify**

* Registry login success (`docker login`) and correct credentials (username/token).
* Repository namespace exists and user has `push` permission.
* Image tag format matches registry rules (e.g., `registry.example.com/org/repo:tag`).
* Registry ACLs, org-level restrictions, or required 2FA/app passwords.
* Rate limits or quota reached on registry.

🧩 **Commands**

```bash
docker login registry.example.com -u $DOCKER_USER -p $DOCKER_PASS
docker push registry.example.com/org/repo:1.0.0
# Check registry API
curl -u $DOCKER_USER:$DOCKER_PASS https://registry.example.com/v2/_catalog
```

📋 **Permission checklist**

| Area      | What to confirm                             |
| --------- | ------------------------------------------- |
| Auth      | Credentials valid, no 2FA blocking          |
| Repo ACL  | User/team has push right                    |
| Namespace | Image pushed to correct org/project         |
| Quota     | Registry storage or rate limit not exceeded |

✅ **Best Practices**

* Use short-lived tokens for CI and store in creds.
* Tag images with immutable tags (SHA) and use automated cleanup policies.
* Use deploy keys or robot accounts with minimal scopes for CI pushes.

💡 **In short**: Validate `docker login`, ensure push permissions for the target repo/namespace, check image name format and registry quotas.

---

## Q231: Parallel stages are causing resource contention. How do you optimize?

🧠 **Overview**
Parallel stages maximize throughput but can overcommit CPU, memory, disk, or network — degrade host/node performance.

⚙️ **Mitigations**

* Limit parallelism (maxParallel) or split heavy tasks serially.
* Use resource reservations: set CPU/memory limits on containers or Kubernetes pod templates.
* Use `throttleConcurrentBuilds` or `lockable-resources` to control concurrency for shared resources.
* Stagger heavy stages with `parallel` + `failFast: false` and controlled delays.
* Scale agent pool horizontally for true parallelism.

🧩 **Examples**
Declarative with `parallel` limits:

```groovy
parallel firstBranch: { steps { ... } },
         secondBranch: { steps { ... } },
         failFast: false
```

Kubernetes podTemplate resource example:

```yaml
resources:
  limits:
    memory: "2Gi"
    cpu: "1000m"
```

📋 **Options table**

| Technique               | Use when                          |
| ----------------------- | --------------------------------- |
| Limit parallelism       | Node resources constrained        |
| Resource limits on pods | K8s environment                   |
| Lockable resources      | Single hardware or test DB shared |
| Increase agent pool     | Need throughput, budget allows    |

✅ **Best Practices**

* Profile stages to know resource needs.
* Use autoscaling agents (K8s/ECS) to match demand.
* Prefer isolation (containers/pods) with strict limits and requests.

💡 **In short**: Limit or throttle parallelism, set resource requests/limits for agents, use locks for shared resources, or scale agent capacity.

---

## Q232: A pipeline is consuming all available agents. What throttling would you implement?

🧠 **Overview**
Unbounded parallel builds or misconfigured job concurrency can exhaust agent capacity; implement throttling and concurrency controls.

⚙️ **Throttling controls**

* `Throttle Concurrent Builds` plugin or `throttle` step to limit job-level concurrency.
* `lockable-resources` plugin to gate access to pools of agents/resources.
* Declarative `options { disableConcurrentBuilds() }` to prevent concurrent runs.
* Use `parallel` stage limits or `maxConcurrentBuildsPerNode` (agent config).
* Implement queue priorities and spot/lightweight job classification.

🧩 **Examples**
Declarative:

```groovy
options { disableConcurrentBuilds() }
```

Lockable resources:

```groovy
lock(resource: 'heavy-agent', quantity: 1) { stage('heavy') { ... } }
```

📋 **Controls table**

| Control                 | Scope     | When to use                        |
| ----------------------- | --------- | ---------------------------------- |
| disableConcurrentBuilds | Job       | Prevent multiple runs of same job  |
| Throttle plugin         | Job/group | Limit total concurrent across jobs |
| Lockable resources      | Resource  | Coordinate access to shared infra  |
| Node executors          | Node      | Limit per-node concurrency         |

✅ **Best Practices**

* Assign executor counts per node conservatively.
* Classify jobs (fast vs heavy) and route heavy jobs to dedicated agents.
* Use autoscaling agents to absorb spikes rather than static capacity.

💡 **In short**: Use `disableConcurrentBuilds`, Throttle or Lockable plugins, and tune node executors or autoscaling to prevent agent exhaustion.

---

## Q233: Build parameters are not being passed correctly. What syntax issues exist?

🧠 **Overview**
Parameter binding fails due to wrong parameter names, types, scoping, or incorrect access (`params` vs environment).

⚙️ **What to check**

* Parameter name exact match (case-sensitive) used in `params.MY_PARAM`.
* Parameter type (booleanParam, choice, string) and default values.
* For Declarative pipelines, parameters must be declared at top-level `pipeline { parameters { ... } }`.
* Passing parameters to downstream job requires `build job: 'job2', parameters: [...]`.
* Environment interpolation vs `params`: `env.MY_PARAM` vs `params.MY_PARAM` differences.

🧩 **Examples**
Declare:

```groovy
pipeline {
  parameters {
    string(name: 'VERSION', defaultValue: '1.0')
  }
  stages { ... }
}
```

Pass to downstream:

```groovy
build job: 'deploy', parameters: [string(name: 'VERSION', value: params.VERSION)]
```

📋 **Common syntax mistakes**

| Mistake                       | Symptom                 | Fix                                   |
| ----------------------------- | ----------------------- | ------------------------------------- |
| Using `$VERSION` in Groovy    | Null or not substituted | Use `params.VERSION` or `env.VERSION` |
| Declaring params inside stage | Not recognized          | Move to top-level pipeline parameters |
| Mismatched name               | Value empty             | Use exact parameter name              |

✅ **Best Practices**

* Use `params.<NAME>` in pipeline code for clarity.
* Validate parameters early with `echo`/`println`.
* Document parameter names and types in job README.

💡 **In short**: Ensure parameter declared at top-level, use exact name with `params.NAME`, and pass parameters explicitly to downstream jobs.

---

## Q234: Environment variables are not available in pipeline steps. How do you fix this?

🧠 **Overview**
Env vars missing due to wrong scope (stage vs environment), using `sh` with `returnStdout`, or not exporting variables in shell steps.

⚙️ **What to check**

* Declarative `environment` block placement (pipeline-level vs stage-level).
* Using `withEnv([...])` for temporary envs in scripted pipelines.
* Shell step uses `sh 'VAR=val command'` vs exporting `export VAR=val`.
* Jenkinsfile variable vs environment variable: `def X` is Groovy variable not `env.X`.
* Credentials-bound variables: ensure `withCredentials` scope encloses the step.

🧩 **Examples**
Pipeline-level env:

```groovy
pipeline {
  environment {
    APP_ENV = 'prod'
  }
  stages {
    stage('Show') { steps { sh 'echo $APP_ENV' } }
  }
}
```

withEnv:

```groovy
withEnv(["PATH+EXTRA=/opt/bin"]) { sh 'echo $PATH' }
```

📋 **Scope table**

| Variable defined as | Accessible as                        |
| ------------------- | ------------------------------------ |
| `environment`       | `$VAR` in shell, `env.VAR` in Groovy |
| `def var = 'x'`     | Groovy-only, not in shell            |
| `withCredentials`   | Available only inside block          |

✅ **Best Practices**

* Use `environment` for persistent pipeline envs.
* Use `env.VAR` when referencing in Groovy.
* Avoid relying on node shell profiles; set envs explicitly in pipeline.

💡 **In short**: Ensure variables are declared in correct `environment`/`withEnv` scope, use `env.VAR` in Groovy, and export variables inside shell steps when needed.

---

## Q235: A when condition is not working as expected. What logic error exists?

🧠 **Overview**
`when` conditions fail due to type mismatches, wrong environment variable references, or Groovy truthiness pitfalls.

⚙️ **Common mistakes**

* Using shell-style `$VAR` instead of `env.VAR` in Groovy `when`.
* Comparing strings without `.equals()` in scripted closures.
* Relying on `params` when parameter not declared (null).
* `when { branch 'master' }` vs `when { expression { return env.BRANCH_NAME == 'master' } }` mismatch.
* `changed` conditions require SCM polling or webhook context.

🧩 **Examples**
Correct branch check:

```groovy
when {
  expression { env.BRANCH_NAME == 'main' }
}
```

Parameter check:

```groovy
when {
  expression { return params.DEPLOY == 'true' }
}
```

📋 **Pitfall table**

| Symptom                | Likely error                                        |
| ---------------------- | --------------------------------------------------- |
| Condition always false | Using `$VAR` or wrong casing                        |
| Condition always true  | Using Groovy truth on non-empty string unexpectedly |
| Not evaluated          | `when` outside stage scope or mis-specified         |

✅ **Best Practices**

* Use explicit `expression` blocks for complex logic.
* Log values inside `when` during debugging: `println "branch=${env.BRANCH_NAME}"`.
* Prefer strict comparisons (`==` in Groovy for strings is ok but explicit `.equals()` clarifies intent).

💡 **In short**: Check variable references and types in `when`, use `expression` for Groovy checks, and print values to debug logic.

---

## Q236: Post-build actions are not executing. What pipeline structure is wrong?

🧠 **Overview**
Post-build actions won’t run if placed outside `post {}` in Declarative pipelines, or if pipeline aborted before reaching post, or using `return` prematurely in scripted pipelines.

⚙️ **What to check**

* Declarative pipeline: `post { always { ... } }` exists under `pipeline {}` not inside `stage`.
* `post` steps execute on the node — if the node is lost, post may not run.
* Using `catchError`/`return` may bypass expected post logic.
* `post` condition mismatch (e.g., `success` vs `always`).
* For freestyle, post-build plugin misconfigured or disabled.

🧩 **Examples**
Correct Declarative:

```groovy
pipeline {
  stages { ... }
  post {
    always { archiveArtifacts artifacts: 'target/*.jar' }
    failure { mail ... }
  }
}
```

📋 **Failure modes**

| Symptom                   | Cause                              |
| ------------------------- | ---------------------------------- |
| No post actions on abort  | Agent lost before `post` runs      |
| Only some post blocks run | Wrong status condition used        |
| Post not defined          | Missing `post {}` at pipeline root |

✅ **Best Practices**

* Use `post { always {}}` for cleanup to ensure execution.
* Keep post actions lightweight; avoid remote-dependent long-running tasks.
* For node loss resilience, use external cleanup jobs or ephemeral storage.

💡 **In short**: Ensure `post {}` is at pipeline top-level with correct conditions, avoid returning/aborting before post, and keep post actions resilient to node loss.

---

## Q237: Jenkins is rejecting CSRF tokens. What security configuration is wrong?

🧠 **Overview**
CSRF (crumb) rejections mean the requesting client didn’t send the Jenkins crumb or the reverse-proxy removed required headers.

⚙️ **What to check**

* CSRF protection enabled (`Manage Jenkins → Configure Global Security`) — ensure clients send crumb using `Jenkins-Crumb` header.
* For webhooks/automation: use `/crumbIssuer/api/json` to obtain crumb and include it in requests.
* Reverse proxy (Nginx/ALB) may strip headers or change `X-Forwarded-*` causing mismatch — ensure correct proxy config.
* API token usage: use basic auth with token and crumb for POST requests.
* CSRF exempt endpoints: some plugins provide token-less endpoints; verify security implications.

🧩 **Commands / Examples**
Get crumb:

```bash
curl -u admin:APITOKEN 'https://jenkins.example.com/crumbIssuer/api/json'
# Example response: {"crumbRequestField":"Jenkins-Crumb","crumb":"abcd-1234"}
# Use:
curl -u admin:APITOKEN -H "Jenkins-Crumb: abcd-1234" -X POST https://jenkins.example.com/job/foo/build
```

📋 **Proxy checklist**

| Proxy issue              | Fix                                            |
| ------------------------ | ---------------------------------------------- |
| Strips headers           | Preserve `Jenkins-Crumb` and auth headers      |
| TLS offload changes host | Set `X-Forwarded-Proto`/`Host` correctly       |
| Session affinity lost    | Enable sticky sessions if needed for auth flow |

✅ **Best Practices**

* Use API tokens for automation and include crumb for state-changing requests.
* Configure reverse proxy to forward necessary headers and not modify POST bodies.
* For webhook sources that can’t send crumbs, use authentication tokens or plugin endpoints designed for webhook triggers.

💡 **In short**: Ensure clients obtain and send Jenkins crumb for POST actions, and verify reverse proxy preserves headers and auth information — use API tokens plus crumb for automation.

----
## Q238: Anonymous users can view jobs. How do you fix authorization?

🧠 **Overview**
Anonymous access usually means Jenkins global security is not configured or authorization strategy allows “read” for `anonymous`. Fix by enabling security and using a stricter authorization strategy (Matrix/RBAC).

⚙️ **How it works / What to change**

* Enable **Security**: `Manage Jenkins → Configure Global Security`.
* Use an authorization strategy: **Matrix-based Security** or **Role-Based Strategy** (plugin).
* Remove `Anonymous` permissions (uncheck `Overall Read`, `Job Read`, etc.).
* Ensure at least one admin user/group retains full rights; add login method (LDAP/SAML/GitHub OAuth) if needed.
* Restart or re-login to check effect.

🧩 **Commands / Examples**

```groovy
// Script Console: remove anonymous overall read (admin only)
def strategy = Jenkins.instance.getAuthorizationStrategy()
if(strategy instanceof hudson.security.GlobalMatrixAuthorizationStrategy) {
  strategy.remove(hudson.model.Hudson.READ, "anonymous")
  Jenkins.instance.save()
}
```

📋 **Checklist**

| Step                     | Why                       |
| ------------------------ | ------------------------- |
| Enable security          | Prevents anonymous access |
| Choose Matrix/Role-based | Fine-grained control      |
| Remove anonymous perms   | Stops job/list visibility |
| Test with non-admin user | Verify least privilege    |

✅ **Best Practices**

* Use Role-Based Authorization plugin for org/folder-level roles.
* Keep admin accounts in a secure central identity provider (LDAP/SSO).
* Audit permissions regularly and use groups, not individual users.
* Lock down `Overall → Read`, `Job → Discover` for anonymous.

💡 **In short**: Turn on global security, remove anonymous permissions, and apply Matrix or Role-Based authorization with least privilege.

---

## Q239: Role-based access control is not working. What permission configuration is wrong?

🧠 **Overview**
RBAC failures usually come from incorrect scope (global vs folder), missing role assignment, or plugin misconfiguration (roles not mapped to correct groups).

⚙️ **What to verify**

* Role definitions (permissions included) exist and include required permissions.
* Role assignments map correct **user/group** to the **right scope** (global, folder, job).
* Role Strategy plugin is enabled and loaded in same Jenkins instance.
* Group names exactly match identity provider groups (case-sensitive).
* Check inheritance — folder roles may not auto-apply to nested items without `Apply to children` set.

🧩 **Examples / Checks**

```bash
# Inspect Role Strategy config XML for mistakes
cat $JENKINS_HOME/role-strategy.xml
# Use script console to list roles
import com.michelin.cio.hudson.plugins.rolestrategy.RoleMap
def rs = jenkins.model.Jenkins.instance.getAuthorizationStrategy()
println rs.getRoleMaps()
```

📋 **Common misconfigs**

| Symptom                                 | Cause                                                     |
| --------------------------------------- | --------------------------------------------------------- |
| User lacks expected rights              | Role not assigned or wrong group name                     |
| Role applies globally but not to folder | Role assigned to wrong scope                              |
| Changes don't persist                   | Plugin config XML malformed / permission to write missing |

✅ **Best Practices**

* Use exact group names from the identity provider; prefer group sync.
* Test role assignment with a non-admin test user account.
* Keep role definitions small and composable (read, build, configure).
* Keep RBAC config in versioned Job/Config-as-Code where possible.

💡 **In short**: Check role scope and exact user/group mappings, ensure Role Strategy plugin is configured properly and test with representative users.

---

## Q240: LDAP authentication is failing. What connection parameters would you verify?

🧠 **Overview**
LDAP failure usually stems from incorrect server URL, bind DN/password, base DN, user search/filter, TLS/port, or network reachability.

⚙️ **What to verify**

* LDAP server URL (ldap://host:389 or ldaps://host:636).
* Bind DN and password (if using bind authentication).
* User search base (e.g., `ou=Users,dc=example,dc=com`) and user search filter (`uid={0}` or `sAMAccountName={0}`).
* Manager DN permissions to search user/groups.
* TLS/SSL certificate trust for ldaps (import CA to JVM keystore or use STARTTLS).
* Network connectivity: ports open, DNS resolves Jenkins → LDAP.

🧩 **Commands / Examples**

```bash
# Test LDAP bind and search using ldapsearch (OpenLDAP tools)
ldapsearch -x -H ldap://ldap.example.com -D "cn=binduser,dc=example,dc=com" -w 'password' -b "ou=Users,dc=example,dc=com" "(uid=vasu)"
# For LDAPS
ldapsearch -H ldaps://ldap.example.com:636 ...
```

📋 **Checklist**

| Parameter          | Typical mistake                        |
| ------------------ | -------------------------------------- |
| Server URL         | Wrong protocol/port                    |
| Bind DN / password | Expired or wrong credentials           |
| Base DN            | Incorrect base prevents user discovery |
| User filter        | Wrong attribute for AD vs OpenLDAP     |
| SSL cert           | Untrusted CA in JVM keystore           |

✅ **Best Practices**

* Use a service account for binds, keep credentials in Jenkins credentials store.
* Prefer TLS and import CA cert to Java keystore used by Jenkins.
* Test search filters with `ldapsearch` before applying in Jenkins.
* Enable verbose LDAP logs in Jenkins for debugging.

💡 **In short**: Validate LDAP URL/port, bind DN/password, base DN and user filter, confirm TLS trust and network reachability.

---

## Q241: Jenkins cannot start after upgrade. What compatibility issues exist?

🧠 **Overview**
Post-upgrade start failures usually result from plugin incompatibilities, Java version mismatch, or changed Jenkins core APIs.

⚙️ **What to check**

* Jenkins log (`$JENKINS_HOME/logs` or system journal) for stack traces naming plugins.
* Java runtime compatibility: new Jenkins requires a minimum Java version (check release notes).
* Plugins need upgrade/downgrade to compatible versions — plugin dependency conflicts often prevent startup.
* `plugins/` dir contains old `.jpi/.hpi` versions causing classloading errors.
* File permissions or SELinux contexts changed during upgrade.

🧩 **Recovery steps**

```bash
# Start in safe mode to skip plugin loading (if web UI unavailable)
java -jar jenkins.war --httpPort=8080 --argumentsRealm.passwd.admin=admin --argumentsRealm.roles.admin=admin -Djenkins.install.runSetupWizard=false
# Or restore previous plugin set
cp /backup/plugins/* $JENKINS_HOME/plugins/
chown -R jenkins:jenkins $JENKINS_HOME
```

📋 **Common failure causes**

| Symptom                                            | Cause                                    |
| -------------------------------------------------- | ---------------------------------------- |
| No HTTP response, stacktrace about class not found | Plugin compiled against old/new core API |
| JVM errors on start                                | Unsupported Java version                 |
| Repeated plugin failed messages                    | Plugin dependency mismatch               |

✅ **Best Practices**

* Always test upgrades in a staging clone of JENKINS_HOME + same plugins before production.
* Keep a plugin inventory and archived plugin versions for rollback.
* Upgrade core and plugins in small steps, not giant jumps.
* Backup `JENKINS_HOME` (config + plugins) and plugin list before upgrade.

💡 **In short**: Inspect logs for plugin or Java incompatibilities, restore compatible plugin set or Java runtime, and test upgrades in staging next time.

---

## Q242: A job configuration was accidentally deleted. How do you recover it?

🧠 **Overview**
Jobs are stored as `<JENKINS_HOME>/jobs/<jobname>/config.xml`. Recovery options: restore from backup, filesystem snapshots, SCM (if job in code), or job config history plugin.

⚙️ **Recovery methods**

1. **Job Config History** plugin: restore from its UI.
2. **Filesystem backup / snapshot**: restore `jobs/<job>/config.xml` and `jobs/<job>/builds/` as needed.
3. **Config as Code / Job DSL**: regenerate job from repo.
4. Recreate manually if no backups exist.

🧩 **Commands / Steps**

```bash
# If you have a tar backup
tar -xzf jenkins-backup.tgz var/lib/jenkins/jobs/my-job/config.xml -C /
chown jenkins:jenkins /var/lib/jenkins/jobs/my-job/config.xml
# Reload configuration from disk
curl -X POST -u admin:APITOKEN https://jenkins.example.com/reload
```

📋 **Priority restore sequence**

| Priority | Source                                     |
| -------- | ------------------------------------------ |
| 1        | Job Config History plugin                  |
| 2        | File system backup / snapshot              |
| 3        | Git (JCasC, Job DSL)                       |
| 4        | Manual recreation with knowledge from team |

✅ **Best Practices**

* Store job definitions in SCM (Jenkins Configuration as Code or Job DSL).
* Enable Job Config History plugin for easy rollbacks.
* Automate periodic backups and test restores.
* Limit direct config editing through UI; use code-driven pipelines.

💡 **In short**: Restore `config.xml` from Job Config History or filesystem backup, reload Jenkins, and adopt JCasC/Job-DSL to avoid future manual deletes.

---

## Q243: Build history is corrupted. What files would you examine?

🧠 **Overview**
Build history per job lives under `JENKINS_HOME/jobs/<job>/builds/`; corruption often involves malformed `build.xml`, missing `nextBuildNumber` or damaged `jobs/<job>/builds` symlinks.

⚙️ **Files to inspect**

* `jobs/<job>/builds/` — subdirectories named by build number.
* Each build directory: `build.xml`, `log` (console.log), `changelog.xml`.
* `jobs/<job>/nextBuildNumber` — ensures numbering continuity.
* `jobs/<job>/config.xml` — may reference build-related settings.
* Global `builds` or `queue` files in `$JENKINS_HOME` if plugins maintain history.

🧩 **Repair steps**

```bash
# List corrupted build dirs
find $JENKINS_HOME/jobs/my-job/builds -maxdepth 1 -type d -print
# Validate build.xml parse
xmllint --noout $JENKINS_HOME/jobs/my-job/builds/123/build.xml
# Fix nextBuildNumber
echo 200 > $JENKINS_HOME/jobs/my-job/nextBuildNumber
chown -R jenkins:jenkins $JENKINS_HOME/jobs/my-job
```

📋 **Corruption causes**

| Cause                         | Symptom                                    |
| ----------------------------- | ------------------------------------------ |
| Interrupted write (disk full) | Missing or truncated build.xml             |
| Manual deletion               | Gaps in build numbers, missing directories |
| Filesystem issues             | IO errors in system logs                   |

✅ **Best Practices**

* Use atomic backups and snapshot-capable storage (EBS snapshots).
* Avoid manual touches to `builds/` directories; use Jenkins UI/CLI.
* Monitor disk space and set alerts to avoid truncation.
* Keep `nextBuildNumber` consistent with highest build folder.

💡 **In short**: Inspect `jobs/<job>/builds/*/build.xml`, `nextBuildNumber`, and logs; repair XMLs or restore from backup and ensure filesystem health.

---

## Q244: Jenkins is creating too many log files. How do you configure log rotation?

🧠 **Overview**
Jenkins writes logs (system logs, access logs, plugin logs) to disk. Rotate logs to prevent disk saturation via system logrotate or Jenkins' internal rotation settings.

⚙️ **What to configure**

* Use OS-level `logrotate` for `/var/log/jenkins/jenkins.log` (or container stdout).
* Configure Jenkins `logging.properties` to reduce verbosity for noisy loggers.
* For plugins writing their own logs, configure plugin-specific log levels.
* Enable log compression and retention in `logrotate` config.

🧩 **Example: logrotate config**

```
/var/log/jenkins/jenkins.log {
  daily
  rotate 14
  compress
  missingok
  notifempty
  copytruncate
}
```

Groovy to reduce noisy logger:

```groovy
import java.util.logging.Logger, Level
Logger.getLogger("org.jenkinsci").setLevel(Level.WARNING)
```

📋 **Options table**

| Option             | Where to set                                  |
| ------------------ | --------------------------------------------- |
| Retention/rotation | OS `logrotate`                                |
| Verbosity          | Jenkins logging config / script console       |
| Plugin logs        | Plugin-specific settings or system properties |

✅ **Best Practices**

* Run Jenkins in containers and use stdout/stderr with centralized logging (ELK/CloudWatch) and retention policies.
* Keep logrotate in place for file-based logs and avoid `copytruncate` if possible (use proper file handles).
* Reduce debug logging in production; enable only when troubleshooting.

💡 **In short**: Use OS `logrotate` + adjust Jenkins/plugin log levels to limit log growth; centralize logs for long-term retention.

---

## Q245: The build queue is growing uncontrollably. What's causing this?

🧠 **Overview**
A growing queue indicates insufficient executors, blocked resources, many jobs triggered (cron/webhook storms), or deadlocked builds preventing dequeue.

⚙️ **What to investigate**

* Executors availability: total executors < demand.
* Many long-running builds or hung jobs consuming executors.
* Locks/`lockable-resources` blocking queued jobs.
* Upstream/downstream job cascade or a CI loop (job triggers itself).
* Node connectivity issues: agents offline but still counted in queue.
* Throttle plugin misconfiguration causing queuing.

🧩 **Diagnostic commands**

```groovy
// Script console: show queue details
import jenkins.model.*
Jenkins.instance.queue.items.each { println it.task.name + " - " + it.why }
```

📋 **Causes table**

| Symptom                        | Likely cause                         |
| ------------------------------ | ------------------------------------ |
| Queue has many of same job     | Parameterized/cron/webhook loop      |
| Queue items show `why` blocked | Lock/label/No Executors              |
| Executors idle but jobs stuck  | Label mismatch or agent incompatible |

✅ **Remediations**

* Increase executors or scale agent pool (K8s autoscaler).
* Identify and kill hung builds, add `timeout()` to pipelines.
* Fix label/label mismatch so jobs can run on available nodes.
* Throttle upstream triggers and fix cascade loops.

💡 **In short**: Check queue reasons, scale or free up executors, fix blocking locks or trigger loops, and add pipeline timeouts.

---

## Q246: A pipeline is in a deadlock state. How do you break it?

🧠 **Overview**
Deadlocks happen when stages wait on locks/resources held by other runs or mutual waiting between jobs. Break by releasing locks, killing stuck builds, or forcing resource release.

⚙️ **How to resolve**

* Identify lock holders via `lockable-resources` UI or queue `why` messages.
* Terminate or abort the job holding the lock if safe.
* Use script console to forcibly release locks.
* For deadlocks between jobs, reorder or redesign locking strategy (reduce lock granularity).

🧩 **Commands / Examples**

```groovy
// List lockable resources (script console)
import org.jenkins.plugins.lockableresources.*;
LockableResourcesManager.get().getResources().each { println it.name + " heldBy: " + it.owner }
# Force release (example)
LockableResourcesManager.get().forceUnlock("resource-name")
```

📋 **Prevention patterns**

| Pattern                 | Benefit                    |
| ----------------------- | -------------------------- |
| Use smaller locks       | Less contention            |
| Retry/backoff           | Avoid permanent deadlock   |
| Time-limited locks      | Ensure eventual release    |
| Separate resource pools | Reduce cross-job conflicts |

✅ **Best Practices**

* Use `lock(resource: 'X', inversePrecedence: true)` and timeouts.
* Avoid circular locking; document resource dependencies.
* Add observability to locks and include lock owner info in job logs.
* Use separate resource pools for long-running vs short jobs.

💡 **In short**: Identify lock holders, release or abort them, force unlock via script console if necessary, and redesign locking to avoid circular waits.

---

## Q247: Groovy sandbox is blocking legitimate pipeline code. How do you approve scripts?

🧠 **Overview**
The Groovy sandbox prevents unsafe methods from running. Admins can approve specific signatures in **In-process Script Approval** or refactor code to approved steps.

⚙️ **How to approve**

* Navigate: `Manage Jenkins → In-process Script Approval`.
* Review pending signatures (method calls/constructors) and **Approve** those that are safe.
* For frequent operations, create a trusted shared library (@Library non-sandboxed) and expose safe API methods.
* Avoid approving arbitrary unsafe signatures without code review.

🧩 **Examples / Commands**

```groovy
// Common pattern: move unsafe code to shared library (vars/myHelper.groovy)
def call() {
  // trusted code executed outside sandbox when shared library is trusted
}
```

📋 **Approval options**

| Option                            | When to use                       |
| --------------------------------- | --------------------------------- |
| Approve signature                 | One-off safe method               |
| Use trusted shared library        | Reusable privileged logic         |
| Disable sandbox (not recommended) | Temporary debugging in secure env |

✅ **Best Practices**

* Approve only reviewed signatures; prefer shared libraries for privileged actions.
* Log approvals and periodically review them.
* Keep less-privileged pipelines within the sandbox; reduce surface area.

💡 **In short**: Approve required signatures via In-process Script Approval or move logic into a trusted shared library to avoid repeated approvals.

---

## Q248: Pipeline replay is not working. What Jenkins version issue exists?

🧠 **Overview**
Pipeline Replay depends on the **Pipeline: Groovy** plugin and certain Jenkins core/plugin version compatibility. Breakage often follows core/plugin upgrades where Replay UI or script storage API changed.

⚙️ **What to check**

* `workflow-cps` / `pipeline-model-definition` plugin versions vs Jenkins core — check compatibility matrix.
* Replay requires job definition to be stored as Pipeline script in job config (Replay doesn’t work for multibranch jobs without proper SCM integration).
* Ensure `Replay` is enabled and user has `Job/Replay` permission.
* Review Jenkins logs for `replay` related stack traces after attempting replay.

🧩 **Troubleshooting steps**

```bash
# Check plugin versions
ls $JENKINS_HOME/plugins | grep workflow
# Look for errors in logs when replaying
tail -n 200 /var/log/jenkins/jenkins.log | grep -i replay
```

📋 **Compatibility notes**

| Symptom                                  | Likely cause                                                                                                |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| Replay button missing                    | Plugin not installed or not enabled for job type                                                            |
| Replay fails at runtime                  | Plugin/core incompatibility or sandbox issues                                                               |
| Replay works locally but not multibranch | Multibranch jobs pull Jenkinsfile from SCM; Replay requires script in job config or specific plugin support |

✅ **Best Practices**

* Keep pipeline-related plugins (workflow-cps, pipeline-model) in sync and test upgrades in staging.
* For multibranch pipelines prefer PR-based changes or use branch indexing to test changes instead of replay.
* Ensure appropriate permissions for users to replay.

💡 **In short**: Check pipeline plugin/core compatibility and install/enable required pipeline plugins; replay may be limited for multibranch jobs or require specific plugin versions.

---

## Q249: Blue Ocean interface cannot load pipeline. What compatibility issue exists?

🧠 **Overview**
Blue Ocean relies on specific pipeline plugin APIs and REST endpoints. Incompatibilities between Blue Ocean and pipeline/core plugins or missing plugins often break the UI.

⚙️ **What to check**

* Blue Ocean plugin version vs Jenkins core and pipeline plugin versions (compatibility).
* Required Blue Ocean sub-plugins installed (`blueocean-core-js`, `blueocean-pipeline-api-impl`, etc.).
* CORS/proxy misconfiguration blocking Blue Ocean REST calls.
* Pipeline face uses `multibranch` or `workflow` features that Blue Ocean doesn't support (older versions).
* Browser console and Jenkins logs for REST API 4xx/5xx errors.

🧩 **Troubleshooting steps**

```bash
# Check installed Blue Ocean components
ls $JENKINS_HOME/plugins | grep blueocean
# Inspect browser console and network tab for failing REST calls when loading pipeline
```

📋 **Failure indicators**

| Symptom                         | Cause                                                  |
| ------------------------------- | ------------------------------------------------------ |
| UI shows spinner forever        | REST API endpoints 500 due to plugin mismatch          |
| Specific pipelines don't appear | Job type not supported by Blue Ocean version           |
| 404 on /blue/rest               | Blue Ocean not installed or endpoint disabled by proxy |

✅ **Best Practices**

* Upgrade Blue Ocean and pipeline plugins together; test in staging.
* Use classic UI to confirm pipeline health while troubleshooting Blue Ocean.
* Keep Blue Ocean minimal; avoid heavy custom plugins that break APIs.

💡 **In short**: Ensure Blue Ocean and pipeline plugins are compatible and installed; check REST API errors and proxy/CORS issues in browser/network logs.

---

## Q250: Jenkins Configuration as Code is not applying changes. How do you troubleshoot?

🧠 **Overview**
JCasC not applying can be due to wrong YAML path, syntax errors, Jenkins not loading the config provider, or plugins/features not present to map YAML keys.

⚙️ **What to verify**

* YAML validity: check syntax and schema errors (use `jenkins-jcasc` validator or `kubectl`/`yamllint` locally).
* JCasC plugin loaded and configured (`Configuration as Code` in Manage Jenkins).
* Correct source: file path, environment variable (`CASC_JENKINS_CONFIG`) or ConfigMap (K8s) points to YAML.
* Plugins required by YAML entries are installed — missing plugin = mapping failure for those sections.
* Check the JCasC logs (`Manage Jenkins → Configuration as Code → View Configuration` and `Reload YAML` feedback) and `jenkins.log` for exceptions.

🧩 **Commands / Examples**

```bash
# In container: check that file is mounted and readable
cat /var/jenkins_home/casc_configs/jenkins.yaml
# Validate via script console (if plugin available)
Jenkins.getInstance().getExtensionList(io.jenkins.plugins.casc.ConfigurationAsCode.class)[0].configure(new java.io.File('/var/jenkins_home/jenkins.yaml').toURI().toURL())
```

📋 **Troubleshooting table**

| Symptom             | Likely cause          | Action                                  |
| ------------------- | --------------------- | --------------------------------------- |
| YAML load errors    | Syntax or unknown key | Validate YAML, install required plugin  |
| Changes not present | Wrong file or env var | Verify `CASC_JENKINS_CONFIG` and mounts |
| Partial apply       | Some plugins missing  | Install missing plugins and reload      |

✅ **Best Practices**

* Keep JCasC YAML under version control and use CI to validate.
* Install required plugins before applying declarative YAML sections.
* Use `reload` and check `Manage Jenkins → Configuration as Code → View Configuration` for errors.
* For K8s, use ConfigMaps and mount them read-only into the controller pod.

💡 **In short**: Validate YAML and mapping errors, ensure JCasC plugin sees the correct file, and install any missing plugins referenced by the YAML — then reload and inspect JCasC logs.

---
## Q251: A Docker container used as agent cannot access workspace. What volume mounting is wrong?

🧠 **Overview**
Docker agents require proper host → container volume mounts for the Jenkins workspace. If the workspace path isn’t mounted or mapped correctly, the agent can't read/write files.

⚙️ **What to check**

* The workspace directory (`/var/lib/jenkins/workspace/<job>`) is not mounted into the container.
* Wrong mount path: Jenkins expects the workspace at `/home/jenkins/agent` or `/workspace` (depends on image).
* UID/GID mismatch inside container causing permission denied.
* Using ephemeral Docker agents without correct `-v "$WORKSPACE:$WORKSPACE"`.

🧩 **Examples**
Standard inbound-agent setup:

```bash
docker run \
  -v /var/lib/jenkins/workspace:/home/jenkins/agent \
  jenkins/inbound-agent:alpine
```

Declarative pipeline with Docker agent:

```groovy
agent {
  docker {
    image 'maven:3.8-jdk-11'
    args '-v $WORKSPACE:$WORKSPACE'
  }
}
```

📋 **Checklist**

| Issue             | Fix                                            |
| ----------------- | ---------------------------------------------- |
| Wrong mount path  | Map host workspace to container workspace path |
| No mount provided | Add `-v` argument                              |
| Permission issues | Match UID/GID or chown workspace               |

✅ **Best Practices**

* Use consistent workspace path across nodes/containers.
* Run container with matching UID for Jenkins user.
* Prefer ephemeral Docker agents with workspace mounting via Jenkins plugin.

💡 **In short**: Ensure correct host→container volume mapping for the workspace and match user permissions inside the container.

---

## Q252: Kubernetes agent pods are being evicted. What resource limits need adjustment?

🧠 **Overview**
Evictions occur when pods exceed node memory/cpu, hit node pressure thresholds, or violate QoS class requirements.

⚙️ **What to adjust**

* Increase `resources.requests` and `resources.limits` in podTemplate.
* Ensure node has enough allocatable memory/CPU.
* Avoid overcommitting memory (OOMKill → eviction).
* Configure storage type properly (avoid using ephemeral storage heavily).
* Use `requests == limits` to set Guaranteed QoS for critical agents.

🧩 **Example podTemplate**

```yaml
containers:
  - name: jnlp
    image: jenkins/inbound-agent
    resources:
      requests:
        cpu: "200m"
        memory: "512Mi"
      limits:
        cpu: "500m"
        memory: "1Gi"
```

📋 **Eviction causes**

| Cause                      | Fix                                               |
| -------------------------- | ------------------------------------------------- |
| Node memory pressure       | Increase node size / limit agent memory           |
| Pod using more than limit  | Raise limits                                      |
| Ephemeral storage pressure | Add storage request or reduce workspace footprint |
| Too many pods on node      | Adjust cluster autoscaler / taints                |

✅ **Best Practices**

* Pin realistic memory/cpu per pipeline.
* Use node groups for build-heavy workloads.
* Avoid using large Docker-in-Docker builds directly inside lightweight K8s agents.

💡 **In short**: Increase pod requests/limits appropriately and ensure nodes have sufficient resources; avoid excessive ephemeral storage use.

---

## Q253: Network connectivity between master and agent is unstable. How do you diagnose?

🧠 **Overview**
Unstable communication stems from firewall issues, reverse-proxy, DNS flapping, TCP resets, or problematic JNLP/WebSocket transport.

⚙️ **Diagnosis steps**

* Check Jenkins master → agent logs: `Manage Nodes → <agent> → Log`.
* Test network: `ping`, `traceroute`, `telnet <master>:50000` for JNLP.
* Verify firewall/security group rules (master ↔ agent).
* Inspect DNS resolution consistency and TTL settings.
* For Kubernetes agents: check pod restarts, node network conditions.
* If using WebSockets, confirm reverse proxy supports upgrade headers.

🧩 **Commands**

```bash
ping -c 5 agent.host
nc -vz jenkins-master 50000
journalctl -u jenkins-agent --no-pager
```

📋 **Common causes**

| Symptom               | Likely issue                                |
| --------------------- | ------------------------------------------- |
| Frequent reconnects   | JNLP heartbeat lost (firewall idle timeout) |
| Random disconnects    | DNS resolution changes or NAT timeout       |
| Only long builds fail | Proxy dropping long-running connections     |

✅ **Best Practices**

* Prefer WebSocket agents if using HTTP reverse-proxies.
* Increase TCP keepalive intervals.
* Use stable DNS or static host entries.
* Ensure firewall idle timeout > 30 minutes.

💡 **In short**: Perform connectivity tests, check agent/master logs, verify firewall and DNS stability, and adjust JNLP/WebSocket transport settings.

---

## Q254: A pipeline is using deprecated syntax. How do you migrate it?

🧠 **Overview**
Deprecated syntax (e.g., old `node` usage, old Docker workflow, deprecated steps) should be migrated to Declarative or updated Scripted syntax that aligns with plugin versions.

⚙️ **How to migrate**

* Check Jenkins logs for deprecation warnings.
* Migrate old directives like:

  * `dockerNode { ... }` → `docker { ... }` syntax
  * Old `stage name:` syntax → Declarative `stage('name')`.
  * Replace old environment binding with `environment { VAR = 'value' }`.
* Replace removed steps (e.g., `batScript`) with supported alternatives.
* Use Snippet Generator to confirm current syntax.

🧩 **Example migration**
Old:

```groovy
stage 'Build'
node {
  sh 'make build'
}
```

New:

```groovy
pipeline {
  stages {
    stage('Build') {
      steps { sh 'make build' }
    }
  }
}
```

📋 **Migration checks**

| Issue                 | Fix                              |
| --------------------- | -------------------------------- |
| Deprecated steps      | Replace with modern equivalents  |
| Missing plugins       | Install updated workflow plugins |
| Script sandbox issues | Approve or refactor              |

✅ **Best Practices**

* Prefer Declarative pipeline for readability and linting.
* Use shared libraries for complex scripted logic.
* Keep plugins/core updated after testing.

💡 **In short**: Identify deprecated steps, replace with modern Declarative/Scripted syntax, validate with Snippet Generator, and test after migration.

---

## Q255: Git LFS files are not being checked out properly. What plugin configuration is needed?

🧠 **Overview**
Git LFS requires the Git LFS client installed on agents and Jenkins Git plugin configured to enable LFS pull.

⚙️ **What to configure**

* Install `git-lfs` on all Jenkins agents.
* In Jenkins Git plugin, enable **"Checkout LFS files"** option.
* Ensure agent user has permission to store LFS cache files.
* Validate LFS endpoints reachable and authenticated.
* For HTTPS, ensure correct tokens/credentials for LFS layer.

🧩 **Commands**

```bash
git lfs install
git lfs fetch
git lfs pull
```

Pipeline:

```groovy
checkout([$class: 'GitSCM', extensions: [[$class: 'GitLFSPull']], ... ])
```

📋 **Troubleshoot table**

| Issue                 | Symptom            | Fix                      |
| --------------------- | ------------------ | ------------------------ |
| LFS client missing    | LFS pointers only  | Install git-lfs          |
| Plugin not configured | No LFS checkout    | Enable GitLFSPull        |
| Wrong creds           | 403 on LFS objects | Update credentials/token |

✅ **Best Practices**

* Bake git-lfs into agent images (Docker, K8s).
* Cache LFS objects to speed up builds.
* Use HTTPS tokens with LFS scopes enabled.

💡 **In short**: Install git-lfs on agents and enable GitLFSPull extension in SCM config; ensure proper authentication for LFS objects.

---

## Q256: Timestamps are missing from console output. What plugin is not enabled?

🧠 **Overview**
Missing timestamps typically mean the **Timestamper Plugin** is not enabled or not configured in the pipeline.

⚙️ **How to enable**

* Install **Timestamper Plugin** (`timestamp` step).
* Use Declarative: `options { timestamps() }`.
* Freestyle: enable the post-build option “Add timestamps to the Console Output.”

🧩 **Example**

```groovy
pipeline {
  options { timestamps() }
  stages { ... }
}
```

📋 **Causes**

| Issue                   | Fix                 |
| ----------------------- | ------------------- |
| Plugin not installed    | Install Timestamper |
| Not enabled in pipeline | Add `timestamps()`  |

✅ **Best Practices**

* Enable timestamps globally in Jenkins UI for easier debugging.
* Auto-enable timestamps for all pipelines via shared library wrapper.

💡 **In short**: Install Timestamper plugin and enable via `options { timestamps() }`.

---

## Q257: A parameterized build is not showing the parameter input. What trigger configuration is wrong?

🧠 **Overview**
Parameterized jobs must have parameters defined before they can appear on the build screen. Triggers don’t create parameters—pipeline config does.

⚙️ **What to verify**

* Ensure `parameters { ... }` block exists in Declarative pipeline.
* For Freestyle, “This build is parameterized” must be checked.
* If using `buildWithParameters` API, ensure parameters are declared first.
* For multibranch, parameters must live in Jenkinsfile, not in the UI.

🧩 **Declarative**

```groovy
pipeline {
  parameters {
    choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select env')
  }
}
```

📋 **Common mistakes**

| Symptom                           | Cause                                |
| --------------------------------- | ------------------------------------ |
| No parameter form displayed       | Parameters missing in job definition |
| API call fails                    | Called before parameters declared    |
| Multibranch ignores UI parameters | Jenkinsfile declares none            |

✅ **Best Practices**

* Always declare parameters in the Jenkinsfile for multibranch pipelines.
* Validate with `echo params.ENV` early in pipeline.

💡 **In short**: Define parameters explicitly in Jenkinsfile/UI; triggers alone don’t create parameters.

---

## Q258: Cron syntax for scheduled builds is not working. What's the correct format?

🧠 **Overview**
Jenkins uses a slightly extended cron format with 5 fields, supporting H() hashing. Problems arise from wrong number of fields or misuse of special characters.

⚙️ **Correct format**

```
MINUTE HOUR DOM MONTH DOW
```

Examples:

```groovy
triggers {
  cron('H/15 * * * *')   // every 15 min
  cron('H 2 * * 1-5')    // hashed minute, 2 AM weekdays
}
```

📋 **Common mistakes**

| Mistake            | Fix                                 |
| ------------------ | ----------------------------------- |
| Using 6-field cron | Remove seconds field                |
| Missing quotes     | Always wrap cron in quotes          |
| Wrong DOW format   | Use 0–7 (0 or 7 = Sunday)           |
| Misusing H()       | Use `H`, `H(0–59)`, or `H/interval` |

💡 Hashing rules: `H` spreads load evenly across jobs.

✅ **Best Practices**

* Prefer H() forms for large Jenkins clusters to avoid cron storms.
* Validate schedule by reviewing job “Next build” time.

💡 **In short**: Use 5-field cron with H() syntax; wrap in quotes and avoid seconds fields.

---

## Q259: Downstream jobs are not being triggered. What build trigger configuration is missing?

🧠 **Overview**
Downstream jobs require explicit trigger configuration: either in UI or pipeline (`build` step). Missing triggers or wrong permissions cause failures.

⚙️ **Things to verify**

* Upstream job enables **"Build other projects"** (Freestyle) or pipeline uses `build job:` step.
* Downstream job name correct (case-sensitive).
* Security: user/role triggering job has `Job/Build` permission on downstream.
* If using parameterized triggers, ensure parameters are passed correctly.
* For multibranch: ensure downstream job lives in visible folder for upstream job.

🧩 **Pipeline example**

```groovy
stage('Trigger') {
  steps {
    build job: 'deploy-service', parameters: [
      string(name: 'APP_VERSION', value: env.VERSION)
    ]
  }
}
```

📋 **Troubleshoot table**

| Symptom                   | Cause                                         |
| ------------------------- | --------------------------------------------- |
| No trigger                | Missing step / config                         |
| 403 error                 | Lacking permissions                           |
| Trigger runs wrong branch | Must specify branch explicitly in multibranch |

✅ **Best Practices**

* Use explicit Jenkinsfile triggers instead of UI for clarity.
* Implement dependency graphs via pipeline rather than chained freestyle jobs.

💡 **In short**: Add explicit `build` step or configure upstream/downstream trigger and ensure downstream build permission is granted.

---

## Q260: A pipeline is trying to use features from a newer Jenkins version. How do you handle this?

🧠 **Overview**
When Jenkinsfile uses syntax/features only available in newer plugins/core, older Jenkins fails validation. Fix by upgrading Jenkins or adjusting pipeline to backward-compatible syntax.

⚙️ **How to resolve**

* Identify which plugin/feature is missing (error message names step/method).
* Check plugin version compatibility matrix; upgrade required plugin/core in staging first.
* Replace new features with older equivalents if upgrade not possible.
* Ensure shared libraries also match version expectations.

🧩 **Examples**
Error:

```
No such DSL method 'options { parallelsAlwaysFailFast() }'
```

Fix:

* Upgrade `pipeline-model-definition` plugin **OR** remove/replace that directive.

📋 **Upgrade options**

| Path                           | When                                                |
| ------------------------------ | --------------------------------------------------- |
| Upgrade Jenkins core + plugins | Long-term fix                                       |
| Use older Jenkinsfile syntax   | Quick workaround                                    |
| Branch-based compatibility     | Maintain separate Jenkinsfile for older controllers |

✅ **Best Practices**

* Maintain plugin/core version pinning.
* Upgrade controller regularly but via staging environment.
* Use `jenkins-plugin-cli` to manage consistent versions.

💡 **In short**: Identify unsupported feature, upgrade Jenkins/plugins or adapt pipeline syntax to match installed versions.

---
## Q251: A Docker container used as agent cannot access workspace. What volume mounting is wrong?

🧠 **Overview**
Docker agents require proper host → container volume mounts for the Jenkins workspace. If the workspace path isn’t mounted or mapped correctly, the agent can't read/write files.

⚙️ **What to check**

* The workspace directory (`/var/lib/jenkins/workspace/<job>`) is not mounted into the container.
* Wrong mount path: Jenkins expects the workspace at `/home/jenkins/agent` or `/workspace` (depends on image).
* UID/GID mismatch inside container causing permission denied.
* Using ephemeral Docker agents without correct `-v "$WORKSPACE:$WORKSPACE"`.

🧩 **Examples**
Standard inbound-agent setup:

```bash
docker run \
  -v /var/lib/jenkins/workspace:/home/jenkins/agent \
  jenkins/inbound-agent:alpine
```

Declarative pipeline with Docker agent:

```groovy
agent {
  docker {
    image 'maven:3.8-jdk-11'
    args '-v $WORKSPACE:$WORKSPACE'
  }
}
```

📋 **Checklist**

| Issue             | Fix                                            |
| ----------------- | ---------------------------------------------- |
| Wrong mount path  | Map host workspace to container workspace path |
| No mount provided | Add `-v` argument                              |
| Permission issues | Match UID/GID or chown workspace               |

✅ **Best Practices**

* Use consistent workspace path across nodes/containers.
* Run container with matching UID for Jenkins user.
* Prefer ephemeral Docker agents with workspace mounting via Jenkins plugin.

💡 **In short**: Ensure correct host→container volume mapping for the workspace and match user permissions inside the container.

---

## Q252: Kubernetes agent pods are being evicted. What resource limits need adjustment?

🧠 **Overview**
Evictions occur when pods exceed node memory/cpu, hit node pressure thresholds, or violate QoS class requirements.

⚙️ **What to adjust**

* Increase `resources.requests` and `resources.limits` in podTemplate.
* Ensure node has enough allocatable memory/CPU.
* Avoid overcommitting memory (OOMKill → eviction).
* Configure storage type properly (avoid using ephemeral storage heavily).
* Use `requests == limits` to set Guaranteed QoS for critical agents.

🧩 **Example podTemplate**

```yaml
containers:
  - name: jnlp
    image: jenkins/inbound-agent
    resources:
      requests:
        cpu: "200m"
        memory: "512Mi"
      limits:
        cpu: "500m"
        memory: "1Gi"
```

📋 **Eviction causes**

| Cause                      | Fix                                               |
| -------------------------- | ------------------------------------------------- |
| Node memory pressure       | Increase node size / limit agent memory           |
| Pod using more than limit  | Raise limits                                      |
| Ephemeral storage pressure | Add storage request or reduce workspace footprint |
| Too many pods on node      | Adjust cluster autoscaler / taints                |

✅ **Best Practices**

* Pin realistic memory/cpu per pipeline.
* Use node groups for build-heavy workloads.
* Avoid using large Docker-in-Docker builds directly inside lightweight K8s agents.

💡 **In short**: Increase pod requests/limits appropriately and ensure nodes have sufficient resources; avoid excessive ephemeral storage use.

---

## Q253: Network connectivity between master and agent is unstable. How do you diagnose?

🧠 **Overview**
Unstable communication stems from firewall issues, reverse-proxy, DNS flapping, TCP resets, or problematic JNLP/WebSocket transport.

⚙️ **Diagnosis steps**

* Check Jenkins master → agent logs: `Manage Nodes → <agent> → Log`.
* Test network: `ping`, `traceroute`, `telnet <master>:50000` for JNLP.
* Verify firewall/security group rules (master ↔ agent).
* Inspect DNS resolution consistency and TTL settings.
* For Kubernetes agents: check pod restarts, node network conditions.
* If using WebSockets, confirm reverse proxy supports upgrade headers.

🧩 **Commands**

```bash
ping -c 5 agent.host
nc -vz jenkins-master 50000
journalctl -u jenkins-agent --no-pager
```

📋 **Common causes**

| Symptom               | Likely issue                                |
| --------------------- | ------------------------------------------- |
| Frequent reconnects   | JNLP heartbeat lost (firewall idle timeout) |
| Random disconnects    | DNS resolution changes or NAT timeout       |
| Only long builds fail | Proxy dropping long-running connections     |

✅ **Best Practices**

* Prefer WebSocket agents if using HTTP reverse-proxies.
* Increase TCP keepalive intervals.
* Use stable DNS or static host entries.
* Ensure firewall idle timeout > 30 minutes.

💡 **In short**: Perform connectivity tests, check agent/master logs, verify firewall and DNS stability, and adjust JNLP/WebSocket transport settings.

---

## Q254: A pipeline is using deprecated syntax. How do you migrate it?

🧠 **Overview**
Deprecated syntax (e.g., old `node` usage, old Docker workflow, deprecated steps) should be migrated to Declarative or updated Scripted syntax that aligns with plugin versions.

⚙️ **How to migrate**

* Check Jenkins logs for deprecation warnings.
* Migrate old directives like:

  * `dockerNode { ... }` → `docker { ... }` syntax
  * Old `stage name:` syntax → Declarative `stage('name')`.
  * Replace old environment binding with `environment { VAR = 'value' }`.
* Replace removed steps (e.g., `batScript`) with supported alternatives.
* Use Snippet Generator to confirm current syntax.

🧩 **Example migration**
Old:

```groovy
stage 'Build'
node {
  sh 'make build'
}
```

New:

```groovy
pipeline {
  stages {
    stage('Build') {
      steps { sh 'make build' }
    }
  }
}
```

📋 **Migration checks**

| Issue                 | Fix                              |
| --------------------- | -------------------------------- |
| Deprecated steps      | Replace with modern equivalents  |
| Missing plugins       | Install updated workflow plugins |
| Script sandbox issues | Approve or refactor              |

✅ **Best Practices**

* Prefer Declarative pipeline for readability and linting.
* Use shared libraries for complex scripted logic.
* Keep plugins/core updated after testing.

💡 **In short**: Identify deprecated steps, replace with modern Declarative/Scripted syntax, validate with Snippet Generator, and test after migration.

---

## Q255: Git LFS files are not being checked out properly. What plugin configuration is needed?

🧠 **Overview**
Git LFS requires the Git LFS client installed on agents and Jenkins Git plugin configured to enable LFS pull.

⚙️ **What to configure**

* Install `git-lfs` on all Jenkins agents.
* In Jenkins Git plugin, enable **"Checkout LFS files"** option.
* Ensure agent user has permission to store LFS cache files.
* Validate LFS endpoints reachable and authenticated.
* For HTTPS, ensure correct tokens/credentials for LFS layer.

🧩 **Commands**

```bash
git lfs install
git lfs fetch
git lfs pull
```

Pipeline:

```groovy
checkout([$class: 'GitSCM', extensions: [[$class: 'GitLFSPull']], ... ])
```

📋 **Troubleshoot table**

| Issue                 | Symptom            | Fix                      |
| --------------------- | ------------------ | ------------------------ |
| LFS client missing    | LFS pointers only  | Install git-lfs          |
| Plugin not configured | No LFS checkout    | Enable GitLFSPull        |
| Wrong creds           | 403 on LFS objects | Update credentials/token |

✅ **Best Practices**

* Bake git-lfs into agent images (Docker, K8s).
* Cache LFS objects to speed up builds.
* Use HTTPS tokens with LFS scopes enabled.

💡 **In short**: Install git-lfs on agents and enable GitLFSPull extension in SCM config; ensure proper authentication for LFS objects.

---

## Q256: Timestamps are missing from console output. What plugin is not enabled?

🧠 **Overview**
Missing timestamps typically mean the **Timestamper Plugin** is not enabled or not configured in the pipeline.

⚙️ **How to enable**

* Install **Timestamper Plugin** (`timestamp` step).
* Use Declarative: `options { timestamps() }`.
* Freestyle: enable the post-build option “Add timestamps to the Console Output.”

🧩 **Example**

```groovy
pipeline {
  options { timestamps() }
  stages { ... }
}
```

📋 **Causes**

| Issue                   | Fix                 |
| ----------------------- | ------------------- |
| Plugin not installed    | Install Timestamper |
| Not enabled in pipeline | Add `timestamps()`  |

✅ **Best Practices**

* Enable timestamps globally in Jenkins UI for easier debugging.
* Auto-enable timestamps for all pipelines via shared library wrapper.

💡 **In short**: Install Timestamper plugin and enable via `options { timestamps() }`.

---

## Q257: A parameterized build is not showing the parameter input. What trigger configuration is wrong?

🧠 **Overview**
Parameterized jobs must have parameters defined before they can appear on the build screen. Triggers don’t create parameters—pipeline config does.

⚙️ **What to verify**

* Ensure `parameters { ... }` block exists in Declarative pipeline.
* For Freestyle, “This build is parameterized” must be checked.
* If using `buildWithParameters` API, ensure parameters are declared first.
* For multibranch, parameters must live in Jenkinsfile, not in the UI.

🧩 **Declarative**

```groovy
pipeline {
  parameters {
    choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select env')
  }
}
```

📋 **Common mistakes**

| Symptom                           | Cause                                |
| --------------------------------- | ------------------------------------ |
| No parameter form displayed       | Parameters missing in job definition |
| API call fails                    | Called before parameters declared    |
| Multibranch ignores UI parameters | Jenkinsfile declares none            |

✅ **Best Practices**

* Always declare parameters in the Jenkinsfile for multibranch pipelines.
* Validate with `echo params.ENV` early in pipeline.

💡 **In short**: Define parameters explicitly in Jenkinsfile/UI; triggers alone don’t create parameters.

---

## Q258: Cron syntax for scheduled builds is not working. What's the correct format?

🧠 **Overview**
Jenkins uses a slightly extended cron format with 5 fields, supporting H() hashing. Problems arise from wrong number of fields or misuse of special characters.

⚙️ **Correct format**

```
MINUTE HOUR DOM MONTH DOW
```

Examples:

```groovy
triggers {
  cron('H/15 * * * *')   // every 15 min
  cron('H 2 * * 1-5')    // hashed minute, 2 AM weekdays
}
```

📋 **Common mistakes**

| Mistake            | Fix                                 |
| ------------------ | ----------------------------------- |
| Using 6-field cron | Remove seconds field                |
| Missing quotes     | Always wrap cron in quotes          |
| Wrong DOW format   | Use 0–7 (0 or 7 = Sunday)           |
| Misusing H()       | Use `H`, `H(0–59)`, or `H/interval` |

💡 Hashing rules: `H` spreads load evenly across jobs.

✅ **Best Practices**

* Prefer H() forms for large Jenkins clusters to avoid cron storms.
* Validate schedule by reviewing job “Next build” time.

💡 **In short**: Use 5-field cron with H() syntax; wrap in quotes and avoid seconds fields.

---

## Q259: Downstream jobs are not being triggered. What build trigger configuration is missing?

🧠 **Overview**
Downstream jobs require explicit trigger configuration: either in UI or pipeline (`build` step). Missing triggers or wrong permissions cause failures.

⚙️ **Things to verify**

* Upstream job enables **"Build other projects"** (Freestyle) or pipeline uses `build job:` step.
* Downstream job name correct (case-sensitive).
* Security: user/role triggering job has `Job/Build` permission on downstream.
* If using parameterized triggers, ensure parameters are passed correctly.
* For multibranch: ensure downstream job lives in visible folder for upstream job.

🧩 **Pipeline example**

```groovy
stage('Trigger') {
  steps {
    build job: 'deploy-service', parameters: [
      string(name: 'APP_VERSION', value: env.VERSION)
    ]
  }
}
```

📋 **Troubleshoot table**

| Symptom                   | Cause                                         |
| ------------------------- | --------------------------------------------- |
| No trigger                | Missing step / config                         |
| 403 error                 | Lacking permissions                           |
| Trigger runs wrong branch | Must specify branch explicitly in multibranch |

✅ **Best Practices**

* Use explicit Jenkinsfile triggers instead of UI for clarity.
* Implement dependency graphs via pipeline rather than chained freestyle jobs.

💡 **In short**: Add explicit `build` step or configure upstream/downstream trigger and ensure downstream build permission is granted.

---

## Q260: A pipeline is trying to use features from a newer Jenkins version. How do you handle this?

🧠 **Overview**
When Jenkinsfile uses syntax/features only available in newer plugins/core, older Jenkins fails validation. Fix by upgrading Jenkins or adjusting pipeline to backward-compatible syntax.

⚙️ **How to resolve**

* Identify which plugin/feature is missing (error message names step/method).
* Check plugin version compatibility matrix; upgrade required plugin/core in staging first.
* Replace new features with older equivalents if upgrade not possible.
* Ensure shared libraries also match version expectations.

🧩 **Examples**
Error:

```
No such DSL method 'options { parallelsAlwaysFailFast() }'
```

Fix:

* Upgrade `pipeline-model-definition` plugin **OR** remove/replace that directive.

📋 **Upgrade options**

| Path                           | When                                                |
| ------------------------------ | --------------------------------------------------- |
| Upgrade Jenkins core + plugins | Long-term fix                                       |
| Use older Jenkinsfile syntax   | Quick workaround                                    |
| Branch-based compatibility     | Maintain separate Jenkinsfile for older controllers |

✅ **Best Practices**

* Maintain plugin/core version pinning.
* Upgrade controller regularly but via staging environment.
* Use `jenkins-plugin-cli` to manage consistent versions.

💡 **In short**: Identify unsupported feature, upgrade Jenkins/plugins or adapt pipeline syntax to match installed versions.
