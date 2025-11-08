Here’s a **concise, interview-ready Jenkins guide**, covering basics, pipelines, plugins, and shared libraries:

---

## **1️⃣ Jenkins Basics**

**1. What is Jenkins & why used**

* Jenkins = Open-source automation server for **CI/CD**
* Automates **build, test, deploy** tasks on code changes

**2. Jenkins vs GitLab CI, Travis, CircleCI**

| Feature         | Jenkins                       | GitLab CI / Travis / CircleCI   |
| --------------- | ----------------------------- | ------------------------------- |
| Hosting         | Self-hosted                   | Cloud/SaaS or self-hosted       |
| Extensibility   | Highly pluggable              | Limited (templates & pipelines) |
| Pipeline syntax | Groovy (Scripted/Declarative) | YAML-based                      |
| Customization   | Very high                     | Moderate                        |

**3. Jenkins Master vs Agent (Slave)**

| Component | Role                                        |
| --------- | ------------------------------------------- |
| Master    | Controls pipeline execution, UI, scheduling |
| Agent     | Executes build jobs assigned by master      |

**4. Jenkins jobs & types**

| Type         | Description                                 |
| ------------ | ------------------------------------------- |
| Freestyle    | Basic, step-by-step configuration           |
| Pipeline     | Code-defined jobs (Scripted or Declarative) |
| Multi-branch | Auto-detect branches & run pipelines        |

**5. Jenkins build lifecycle**

1. Job triggered (SCM commit, manual, schedule)
2. Master assigns job to agent
3. Stages executed (build → test → deploy)
4. Post actions run (notifications, cleanup)

**6. Jenkins node vs agent**

* **Node:** Any machine configured to run jobs (includes master)
* **Agent:** Node specifically used for executing jobs

---

## **2️⃣ Jenkins Pipelines**

**1. What is a Jenkins pipeline**

* Groovy-based definition of **build, test, deploy steps** as code
* Stored in `Jenkinsfile` in SCM

**2. Declarative vs Scripted pipelines**

| Feature     | Declarative               | Scripted                |
| ----------- | ------------------------- | ----------------------- |
| Syntax      | Structured, `pipeline {}` | Free-form Groovy script |
| Ease        | Easier to read            | More flexible           |
| Recommended | For most projects         | Complex logic/loops     |

**3. Stages, steps, post actions**

```groovy
pipeline {
    agent any
    stages {
        stage('Build') { steps { sh 'mvn clean install' } }
        stage('Test')  { steps { sh 'mvn test' } }
    }
    post { always { echo 'Pipeline finished' } }
}
```

**4. Agent any, none, label**

| Directive             | Behavior                              |
| --------------------- | ------------------------------------- |
| agent any             | Run on any available agent            |
| agent none            | No global agent; define per stage     |
| agent { label 'xyz' } | Run on specific node with label 'xyz' |

**5. Different stages on different agents**

```groovy
stage('Build') { agent { label 'linux' } steps { ... } }
stage('Test')  { agent { label 'windows' } steps { ... } }
```

**6. Pass environment variables between stages**

* Use `environment` block or `withEnv`

```groovy
environment { VERSION = '1.0' }
steps { echo "Version: $VERSION" }
```

**7. Parallel stages & matrix builds**

```groovy
parallel {
    stage('Test Java') { steps { sh 'java -version' } }
    stage('Test Node') { steps { sh 'node -v' } }
}
```

* Matrix builds: run **combinations of variables**

**8. `when` directive**

* Conditionally run stage:

```groovy
stage('Deploy') {
  when { branch 'main' }
  steps { sh './deploy.sh' }
}
```

**9. Trigger pipeline manually vs automatically**

* **Manual:** `Build with Parameters` or `input` step
* **Automatic:** SCM webhook, cron (`triggers { cron('H */4 * * *') }`)

---

## **3️⃣ Jenkins Plugins & Libraries**

**1. Essential Jenkins plugins**

* Git plugin (SCM)
* Pipeline / Declarative Pipeline
* Blue Ocean (visualization)
* Slack Notification
* SonarQube Scanner
* Credentials Binding

**2. Shared library**

* Reusable pipeline functions, steps across projects

```groovy
@Library('my-shared-lib') _
pipeline {
    stages { stage('Build') { steps { myBuildFunction() } } }
}
```

**3. Version-control shared libraries**

* Store in **Git repository**, manage via branches/tags
* Reference in Jenkins via **Global Pipeline Libraries**

**4. Git plugin to clone repositories**

```groovy
checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: 'git@github.com:user/repo.git']]])
```

**5. Blue Ocean plugin**

* Modern **visual UI for pipelines**, easier debugging & stage visualization

**6. Integrate Jenkins with SonarQube**

```groovy
stage('Code Analysis') {
  steps {
    withSonarQubeEnv('SonarQube') {
      sh 'mvn sonar:sonar'
    }
  }
}
```

**7. Notifications to Slack / Teams**

```groovy
post {
  success { slackSend(channel: '#dev', message: 'Build Success!') }
  failure { slackSend(channel: '#dev', message: 'Build Failed!') }
}
```

**8. Reusability via pipeline libraries**

* Move **common steps/functions** to shared library → reuse across multiple projects

---

Here’s a **concise, interview-ready guide** covering **Jenkins & EC2 integration** and advanced pipeline concepts:

---

## **Jenkins & EC2 Integration**

**1. Configure Jenkins agent on EC2**

* Launch EC2 instance, install **JDK & Jenkins agent (slave) prerequisites**
* Connect via **SSH** or **JNLP**:

```bash
java -jar agent.jar -jnlpUrl http://<JENKINS_URL>/computer/<AGENT_NAME>/jenkins-agent.jnlp -secret <SECRET>
```

**2. Permanent vs ephemeral EC2 agents**

| Type      | Description                                               |
| --------- | --------------------------------------------------------- |
| Permanent | Always running, manually managed                          |
| Ephemeral | Spin up on-demand for pipeline jobs, terminated after use |

**3. Dynamic scaling**

* Use **Amazon EC2 plugin** in Jenkins
* Configure **AMI, instance type, labels, and max/min agents**
* Jenkins automatically provisions agents for queued jobs

**4. Pass AWS credentials securely**

* Use **Jenkins Credentials plugin**
* Access via environment variables or `withAWS` wrapper:

```groovy
withAWS(region:'us-east-1', credentials:'aws-credentials-id') {
    sh 'aws s3 cp myfile s3://bucket/'
}
```

**5. Integrate with AWS services**

* **CodeDeploy:** `aws deploy push` + deployment commands
* **ECS:** `aws ecs update-service` or via CloudFormation
* **S3:** `aws s3 cp` or `sync` in pipeline steps

**6. Clean up EC2 agents**

* Ephemeral agents terminated automatically
* For permanent agents: configure **Idle termination** or **cleanup scripts**

---

## **Jenkins Advanced Pipeline Concepts**

**1. Build failures & notifications**

```groovy
post {
  success { slackSend(channel:'#dev', message:'Build Success') }
  failure { slackSend(channel:'#dev', message:'Build Failed') }
}
```

**2. Rollback or retry strategies**

```groovy
options {
  retry(3)  // retry failed stage 3 times
}
```

* Rollback: use separate stage to revert deployments

**3. `stash` & `unstash`**

* Pass files between stages on **different agents**:

```groovy
stash name: 'build', includes: 'target/*.jar'
unstash 'build'
```

**4. `input` step for manual approval**

```groovy
stage('Deploy Prod') {
  input { message 'Approve deployment?' }
  steps { sh './deploy.sh' }
}
```

**5. Handling secrets in pipelines**

* Use **Jenkins credentials plugin**
* Inject via `withCredentials`:

```groovy
withCredentials([usernamePassword(credentialsId:'cred-id', usernameVariable:'USER', passwordVariable:'PASS')]) {
    sh 'echo $USER $PASS'
}
```

**6. CI/CD for multiple branches & environments**

```groovy
when { branch 'main' }
environment { ENV = 'production' }
```

* Use **multibranch pipelines** to auto-detect branches

**7. Declarative pipeline conditional execution**

```groovy
stage('Deploy') {
  when { expression { params.DEPLOY == true } }
}
```

**8. Jenkins & Docker integration**

* Use **docker agent**:

```groovy
agent { docker { image 'maven:3.8.6-jdk11' } }
steps { sh 'mvn clean install' }
```

* Build/push images, deploy containers via pipeline

**9. Multibranch pipeline vs standard pipeline**

| Type                 | Description                                             |
| -------------------- | ------------------------------------------------------- |
| Standard pipeline    | Single Jenkinsfile, single branch                       |
| Multibranch pipeline | Auto-detect branches, runs separate pipeline per branch |

**10. Handle artifacts**

```groovy
archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
```

* Enables sharing or storing artifacts for later stages

**11. Monitor performance & manage disk space**

* Jenkins **monitoring plugins** (Metrics, Monitoring)
* Clean workspace regularly:

```groovy
post { always { cleanWs() } }
```

* Monitor **logs, jobs, plugins, and disk usage**

---

Perfect set of **Jenkins Node/Agent and Job/Build configuration questions**. Let’s break them down in a way you can **answer confidently in interviews**:

---

# **1️⃣ Node / Agent / Master Configuration**

**Q1. Difference between Jenkins Master and Agent (Slave)?**

* **Master (Controller):**

  * Handles **UI, scheduling, job orchestration, plugin management, and security**.
  * Doesn’t usually run heavy build workloads.
* **Agent (Slave / Node):**

  * Executes jobs delegated by the master.
  * Can be **Linux/Windows/Cloud-based**.
  * Provides scalability and workload isolation.

---

**Q2. Configure a permanent agent in Jenkins**

1. Go to **Manage Jenkins → Nodes & Clouds → New Node**
2. Enter node name, select **Permanent Agent**
3. Configure:

   * **Remote root directory** (workspace location on agent machine)
   * **Launch method** (SSH or JNLP)
   * **Labels** (e.g., `maven`, `docker`)
   * **Usage** (restrict or general-purpose)
4. Start agent service (via SSH or by running `agent.jar`).

---

**Q3. Configure an ephemeral (cloud-based) agent like EC2**

* Install **Amazon EC2 plugin** (or Kubernetes plugin for k8s).
* Configure cloud → specify **AMI, instance type, region, keypair**.
* Jenkins provisions agents **dynamically on-demand**, destroys them after job completion.
* This is how you **scale Jenkins horizontally without idle nodes**.

---

**Q4. “Launch method” options for Jenkins agents**

* **SSH**: Master connects to agent via SSH and starts agent process.
* **JNLP (Java Web Start)**: Agent connects back to master (useful when master cannot initiate connection).
* **Windows Service**: Runs as a Windows service on the node.
* **Inbound TCP**: Agents connect via TCP port, often for firewalled setups.

---

**Q5. Remote root directory in node configuration**

* Path on the agent machine where Jenkins will store:

  * **workspace, artifacts, build cache, logs**
* Example: `/home/jenkins/agent`

---

**Q6. Labeling agents & usage in pipelines**

* Labels are **tags/identifiers** assigned to agents.
* Used in pipelines:

```groovy
pipeline {
  agent { label 'docker' }
}
```

* Example: `linux`, `windows`, `maven`, `gpu`.

---

**Q7. Restrict job to specific agents**

* In job config → **Restrict where this project can be run**
* Enter **label expression** (`maven && linux`)

---

**Q8. “Usage” option in node configuration**

* **Use this node as much as possible**: Default, Jenkins uses agent for any job.
* **Only build jobs with label**: Jenkins uses node **only if explicitly requested with label**.

---

# **2️⃣ Job / Build Configuration**

**Q1. Freestyle vs Pipeline jobs**

| Feature     | Freestyle      | Pipeline (Declarative/Scripted)        |
| ----------- | -------------- | -------------------------------------- |
| Setup       | UI-driven      | Code (Jenkinsfile, version-controlled) |
| Flexibility | Limited        | High (parallelism, conditionals)       |
| Scalability | Hard to manage | Standard for CI/CD automation          |
| Reusability | Poor           | Strong (shared libraries, templates)   |

---

**Q2. SCM options in Jenkins job config**

* Git (GitHub, GitLab, Bitbucket)
* Subversion (SVN)
* CVS
* Mercurial
* Perforce
* Filesystem

---

**Q3. Configure GitHub/GitLab webhook triggers**

* Generate **Jenkins webhook URL**:

  * `http://<jenkins_url>/github-webhook/`
* In GitHub/GitLab repo → Settings → Webhooks → Add webhook
* Select events (push, PR/MR).
* Requires **GitHub plugin or GitLab plugin** in Jenkins.

---

**Q4. Build Triggers options**

* **Poll SCM**: Jenkins checks repo at schedule (`H/5 * * * *`)
* **Build periodically**: Cron-style time-based jobs (e.g., nightly builds)
* **Trigger builds remotely**: Build via API token or URL (`?token=XYZ`)
* **GitHub hook trigger / GitLab trigger**: Trigger on push/MR events

---

**Q5. Build Environment options**

* **Delete workspace before build** – ensures clean build
* **Use secret text/credentials** – inject credentials securely
* **Prepare environment variables** – define env vars before build
* **Timestamps** – add timestamps to console logs

---

**Q6. Discard old builds vs Keep all builds**

* **Discard old builds**: Save space by keeping only X builds or artifacts
* **Keep all builds**: Useful for audit/compliance, but increases disk usage

---

**Q7. Concurrent builds**

* Enable “Execute concurrent builds if necessary”
* Useful for **parallel PR testing**
* Must ensure **no shared resource conflicts**

---

**Q8. Pass parameters to a job**

* Enable **This project is parameterized**
* Types:

  * String, Choice, Boolean
  * Credentials
  * File
  * Password
* Example in Pipeline:

```groovy
parameters {
  string(name: 'VERSION', defaultValue: '1.0.0')
  choice(name: 'ENV', choices: ['dev', 'staging', 'prod'])
}
```

---

Perfect batch of interview Qs, Vasu 🔥
I’ll break them down by section (Post-build, Pipeline options, Plugins/Advanced) with **short, straight-shooting answers, examples, and key differences** 👇

---

## 3️⃣ Post-build Actions

**Q: Archive artifacts vs Publish JUnit test result report**

* `archiveArtifacts`: Stores build outputs (e.g., `.jar`, `.log`, `.xml`) in Jenkins for later download.
* `publishJUnit`: Specifically parses JUnit XML test results → generates trends, failure counts, test reports.
  👉 *Use archive for binaries, publishJUnit for test analytics.*

---

**Q: Configure email notifications**

* Install **Email Extension Plugin**.
* Configure SMTP (Manage Jenkins → Configure System).
* In job → *Post-build Actions → Editable Email Notification*.
* Example:

  ```groovy
  emailext(
    to: "team@company.com",
    subject: "Build #${BUILD_NUMBER} - ${BUILD_STATUS}",
    body: "Check logs at ${BUILD_URL}"
  )
  ```

---

**Q: Slack/Teams notifications setup**

* Install Slack or MS Teams plugin.
* Add Webhook URL (Slack App → Incoming Webhook / Teams Connector).
* Use post-build action or pipeline snippet:

  ```groovy
  slackSend channel: '#devops', message: "Build #${BUILD_NUMBER} ${currentBuild.result}"
  ```

---

**Q: Build other projects vs Trigger parameterized build**

* *Build other projects*: Fire-and-forget → triggers next job with no parameters.
* *Trigger parameterized build*: Pass variables/params to downstream job.
  👉 *Use parameterized for controlled pipelines.*

---

**Q: Conditional steps for post-build actions**

* Use **Flexible Publish Plugin** or `when` directive in pipeline.
* Example:

  ```groovy
  post {
    success { slackSend message: "Build Passed ✅" }
    failure { slackSend message: "Build Failed ❌" }
  }
  ```

---

## 4️⃣ Pipeline-specific Options

**Q: Define agent, stages, steps**

```groovy
pipeline {
  agent any
  stages {
    stage('Build') {
      steps { sh 'mvn clean install' }
    }
  }
}
```

---

**Q: options {} block usage**
Controls pipeline behavior. Examples:

```groovy
options {
  timeout(time: 30, unit: 'MINUTES')
  buildDiscarder(logRotator(numToKeepStr: '10'))
  disableConcurrentBuilds()
}
```

---

**Q: triggers {} block**
Automates pipeline runs:

```groovy
triggers {
  cron('H 4 * * 1-5')  // daily at 4AM
  pollSCM('H/5 * * * *') // every 5 mins
}
```

---

**Q: environment {} block & precedence**

* `environment { VAR="value" }` → global or stage-level.
* Precedence: Stage env > Pipeline env > Node env > System env.

---

**Q: post {} block usage**

```groovy
post {
  success { echo "Job succeeded" }
  failure { echo "Job failed" }
  always { cleanWs() }
}
```

---

**Q: stash/unstash vs archiveArtifacts**

* `stash/unstash`: Moves files between **pipeline stages** (kept in master memory).
* `archiveArtifacts`: Stores artifacts after build completion for later retrieval/download.

---

## 5️⃣ Jenkins Plugins & Advanced Options

**Q: Essential plugins**

* **SCM**: Git, GitHub, GitLab, Bitbucket.
* **Build/Test**: Maven, Gradle, JUnit, Jacoco.
* **Deploy**: SSH, Docker, Kubernetes, AWS.
* **Pipeline**: Pipeline, Blue Ocean, Shared Libraries.
* **Utility**: Credentials, Email-ext, Slack.

---

**Q: Configure credentials & secrets**

* Manage Jenkins → Credentials → Add.
* Access in pipeline:

  ```groovy
  withCredentials([usernamePassword(credentialsId: 'git-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
    sh 'git clone https://$USER:$PASS@repo'
  }
  ```

---

**Q: Global vs Job-specific credentials**

* Global: Available to all jobs.
* Job-specific (domain-bound): Scoped to certain jobs, folders, or agents.
  👉 *Use job-specific for principle of least privilege.*

---

**Q: Shared libraries for reusability**

* Configure in Jenkins → Global Pipeline Libraries → Git repo.
* Use in Jenkinsfile:

  ```groovy
  @Library('my-shared-lib') _
  myCustomStep()
  ```

---

**Q: Integrate Jenkins with Docker/K8s/EC2 agents**

* Docker: `agent { docker { image 'maven:3.9' } }`
* Kubernetes: Install **Kubernetes Plugin**, configure pod templates.
* EC2: Jenkins EC2 plugin → auto-provision agents.

---

**Q: OIDC or AWS credentials in pipeline**

* Use **AWS Credentials Plugin** or AWS OIDC role.
* Example:

  ```groovy
  withAWS(role: 'arn:aws:iam::123:role/JenkinsRole', region: 'us-east-1') {
    sh 'aws s3 ls'
  }
  ```

---

**Q: Build Timeout, Retry, Throttle plugins**

* Timeout:

  ```groovy
  options { timeout(time: 15, unit: 'MINUTES') }
  ```
* Retry:

  ```groovy
  retry(3) { sh 'flaky-command' }
  ```
* Throttle: Limit concurrent builds by category (plugin).

---

Perfect, Vasu 👍 — here’s the **Maintenance / Troubleshooting** section, straight-shooting, interview-ready, with practical examples:

---

### **6️⃣ Jenkins Maintenance / Troubleshooting**

**Q: How do you manage disk usage on Jenkins nodes?**

* Clean up old builds: `Build Discarder` or `logRotator`.
* Delete unused workspaces: `ws-cleanup` plugin.
* Archive artifacts to S3/Nexus, not on local disk.
* Script option:

  ```bash
  find /var/lib/jenkins/workspace -type d -mtime +7 -exec rm -rf {} \;
  ```

---

**Q: How do you troubleshoot agent connectivity issues?**

* Check **Jenkins master logs** (`jenkins.log`) and agent logs.
* Verify **Jenkins URL** in agent config matches master.
* Network/firewall → check `telnet master_ip 50000`.
* Java mismatch → ensure same Java version on master & agent.
* Try restarting agent service:

  ```bash
  sudo systemctl restart jenkins-agent
  ```

---

**Q: How do you update Jenkins plugins safely?**

* Always backup `JENKINS_HOME`.
* Use **Plugin Manager** → check for dependency warnings.
* Prefer updating on a **test/staging Jenkins** before prod.
* Automate with CLI:

  ```bash
  jenkins-cli -s http://localhost:8080/ install-plugin git -deploy
  ```
* Restart Jenkins in maintenance window.

---

**Q: How do you migrate Jenkins jobs between servers?**

* Copy `JENKINS_HOME/jobs` and `config.xml`.
* Or use **Job Import Plugin** / **Jenkins Job Builder (JJB)**.
* For pipelines, just migrate the `Jenkinsfile` (SCM-based).
* If using credentials → re-add them manually or export via `credentials.xml`.

---

**Q: How do you monitor Jenkins master and agents performance?**

* Use **Monitoring plugin** or integrate with **Prometheus + Grafana**.
* Check JVM heap, thread count, and CPU usage.
* Log rotation + disk monitoring.
* Alerts on agent disconnects or queue backlog.
* Example Prometheus scrape endpoint: `http://jenkins:8080/prometheus`.

---
