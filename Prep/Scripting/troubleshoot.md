# Real-World DevOps Scenario Questions Asked in MNC & Startup Interviews

## Q1: Your production website is down at 2 AM. Walk me through your complete incident response process from detection to resolution

---

### 🧠 Overview

A production outage at 2 AM is a **Severity-1 (P1)** incident.

The goal is not “fix perfectly” — it is:

1. **Restore service ASAP (MTTR focus)**
2. **Minimize business impact**
3. **Preserve evidence**
4. **Prevent recurrence**

In real-world DevOps (AWS + EKS + CI/CD), this typically involves:

* Monitoring alerts (CloudWatch, Prometheus, Datadog)
* Infra layer (ALB, EC2, EKS, RDS)
* Deployment layer (Helm, Docker, CI/CD)
* Application layer (logs, configs, secrets)

---

# 🔥 Phase 1: Detection & Alerting

### ⚙️ How it works

Production is monitored via:

* **Prometheus + Alertmanager**
* **AWS CloudWatch Alarms**
* **Route53 Health Checks**
* Synthetic checks (Pingdom, UptimeRobot)

Example alert:

```yaml
- alert: WebsiteDown
  expr: up{job="frontend"} == 0
  for: 2m
  labels:
    severity: critical
```

PagerDuty / OpsGenie triggers on-call.

---

# 🚨 Phase 2: Triage (First 5–10 Minutes)

### 🎯 Goal: Confirm impact & identify blast radius

### Step 1: Validate outage

```bash
curl -I https://prod.example.com
```

Check:

* 502? 503? 504?
* Timeout?
* DNS issue?

---

### Step 2: Check Infra Layer (AWS)

#### Check ALB

```bash
aws elbv2 describe-target-health --target-group-arn <tg-arn>
```

Look for:

* `unhealthy`
* 5xx spike

#### Check EC2 / EKS Nodes

```bash
kubectl get nodes
kubectl get pods -n prod
```

---

### Step 3: Check Application Health

```bash
kubectl logs deployment/frontend -n prod
```

Look for:

* CrashLoopBackOff
* OOMKilled
* DB connection errors

---

# 🛠 Phase 3: Containment & Immediate Recovery

### 🧩 Common Scenarios & Actions

| Problem        | Action             |
| -------------- | ------------------ |
| Bad deployment | Rollback           |
| Pods crashed   | Restart / Scale    |
| Node failure   | Replace node       |
| DB down        | Failover           |
| CPU spike      | Scale horizontally |
| Memory leak    | Restart pods       |

---

## 🔁 Example: Rollback via Kubernetes

```bash
kubectl rollout history deployment/frontend -n prod
kubectl rollout undo deployment/frontend -n prod
```

Helm rollback:

```bash
helm history frontend -n prod
helm rollback frontend 12 -n prod
```

---

## 📈 Example: Scale temporarily

```bash
kubectl scale deployment frontend --replicas=6 -n prod
```

---

## 🔄 Example: Restart Pods

```bash
kubectl rollout restart deployment/frontend -n prod
```

---

# 📢 Phase 4: Communication

### ✅ Always communicate

* Create Slack war room
* Update stakeholders every 15–30 min
* Log timeline

Example update:

```
02:08 AM – Identified failed deployment
02:12 AM – Rollback initiated
02:15 AM – Service restored
```

Never debug silently.

---

# 🧪 Phase 5: Root Cause Analysis (After Stabilization)

### 🔍 Investigate:

* What changed before failure?
* CI/CD deployment?
* Infra change?
* Config/Secret update?

Check:

```bash
kubectl describe pod <pod>
kubectl get events -n prod
```

CI/CD:

```bash
git log --oneline -5
```

---

# 📊 Phase 6: Postmortem (Within 24 Hours)

### Document:

* Timeline
* Root cause
* Detection gap?
* Preventive actions

Example action items:

* Add readiness probes
* Add canary deployment
* Add memory limits
* Add alert for error rate > 5%

---

# 🔒 Production-Grade Best Practices

### 1️⃣ Use Readiness & Liveness Probes

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 30
```

---

### 2️⃣ Enable Auto Scaling

```bash
kubectl autoscale deployment frontend \
  --cpu-percent=70 --min=3 --max=10
```

---

### 3️⃣ Use Blue/Green or Canary Deployments

Reduces blast radius.

---

### 4️⃣ Maintain Runbooks

Every service should have:

* Restart steps
* Rollback steps
* Health check commands
* Owner contacts

---

### 5️⃣ Track SLO & Error Budget

Alert on:

* Error rate > 5%
* Latency > threshold
* Pod restarts spike

---

# ⏱ Real Incident Timeline Example

| Time     | Action                    |
| -------- | ------------------------- |
| 02:00    | PagerDuty alert           |
| 02:02    | Confirm outage            |
| 02:05    | Found failing pods        |
| 02:08    | Identified bad deployment |
| 02:12    | Rolled back               |
| 02:15    | Traffic normal            |
| 02:40    | Root cause found          |
| Next day | Postmortem                |

---

# ⚠️ What NOT to Do

* ❌ Restart everything blindly
* ❌ Make multiple changes at once
* ❌ Debug in production without rollback plan
* ❌ Stay silent without communication

---

# 💡 In Short (Interview Quick Recall)

* Confirm impact
* Identify blast radius
* Restore service fast (rollback > debug)
* Communicate continuously
* Do RCA & prevent recurrence

👉 Incident response = **Stabilize → Investigate → Prevent**.

----
## Q2: A deployment went live and within 5 minutes, error rates spiked from 0.1% to 40%. What are your immediate actions?

---

### 🧠 Overview

This is a **classic bad deployment scenario**.

Error spike from **0.1% → 40% in 5 minutes** means:

* High customer impact
* Likely code/config regression
* Immediate rollback > deep debugging

In production DevOps (AWS + EKS + CI/CD), priority is:

> 🚨 **Stop the blast radius → Restore last stable state → Then investigate**

MTTR > ego.

---

# 🚨 Phase 1: Confirm & Assess (1–3 Minutes)

### ⚙️ Validate metrics

Check:

* Prometheus
* CloudWatch
* ALB 5xx
* Application logs

Example:

```bash
kubectl get pods -n prod
kubectl logs deployment/frontend -n prod --tail=50
```

Check:

* 500 errors?
* DB connection failures?
* OOMKilled?
* CrashLoopBackOff?

---

# 🔥 Phase 2: Immediate Containment (Rollback First)

### 🎯 Decision Rule

If spike started **right after deployment**, assume it’s the deployment.

Do NOT debug live unless rollback is impossible.

---

## 🔁 Option 1: Kubernetes Rollback

```bash
kubectl rollout history deployment/frontend -n prod
kubectl rollout undo deployment/frontend -n prod
```

---

## 🔁 Option 2: Helm Rollback

```bash
helm history frontend -n prod
helm rollback frontend <previous-revision> -n prod
```

---

## 🔁 Option 3: Blue/Green Switch

If using ALB weighted routing:

```bash
aws elbv2 modify-listener \
  --listener-arn <arn> \
  --default-actions Type=forward,TargetGroupArn=<old-tg>
```

Switch traffic back instantly.

---

# 📊 Phase 3: Verify Recovery

Monitor:

* Error rate drops?
* Latency normal?
* Pods stable?

```bash
kubectl get pods -n prod -w
```

Check metrics for 5–10 minutes.

Only declare resolved when:

* Error rate < 1%
* No restarts
* No 5xx spikes

---

# 🔎 Phase 4: Root Cause Investigation (After Stabilization)

Now safely analyze.

Check:

```bash
git log --oneline -5
```

Was it:

* Config change?
* Secret change?
* DB migration?
* Feature flag?
* Dependency upgrade?

---

## 🧩 Common Root Causes

| Issue                | What to Check    |
| -------------------- | ---------------- |
| Missing env variable | ConfigMap/Secret |
| DB schema mismatch   | Migration logs   |
| Increased CPU usage  | Resource limits  |
| External API failure | Timeout config   |
| Feature flag issue   | Toggle state     |

---

# 🛡 Phase 5: Prevent Future Blast

### ✅ Implement Canary Deployments

Example (Argo Rollouts):

```yaml
strategy:
  canary:
    steps:
      - setWeight: 20
      - pause: {duration: 2m}
```

Deploy to 20% first.

---

### ✅ Add Automatic Rollback

Prometheus alert:

```yaml
- alert: HighErrorRate
  expr: rate(http_requests_total{status=~"5.."}[2m]) > 0.05
```

Trigger pipeline rollback.

---

### ✅ Add Readiness Probes

Prevents broken pods from receiving traffic.

```yaml
readinessProbe:
  httpGet:
    path: /health
    port: 8080
```

---

# 📢 Communication During Incident

Post update:

```
02:10 AM – Error spike detected (40%)
02:12 AM – Rollback initiated
02:15 AM – Errors normalizing
02:20 AM – Service restored
```

Never debug silently.

---

# ⚠️ What NOT to Do

* ❌ Investigate deeply before rollback
* ❌ Push hotfix blindly
* ❌ Restart everything randomly
* ❌ Ignore metrics trend

---

# 📋 Decision Flow (Production Mindset)

| Scenario                       | Action                            |
| ------------------------------ | --------------------------------- |
| Error spike right after deploy | Rollback immediately              |
| Spike but no recent deploy     | Investigate infra                 |
| Only one pod failing           | Replace pod                       |
| DB errors                      | Check migration / connection pool |
| External API                   | Fallback / Circuit breaker        |

---

# 💡 In Short (Interview Quick Recall)

* Correlate spike with deployment
* Rollback immediately (fastest recovery)
* Verify metrics stabilize
* Do RCA after service restored
* Implement canary + auto rollback

👉 In production: **Rollback first. Debug later. Protect customers.**

----
## Q3: Your team pushed a bad release to production on a Friday evening. The rollback is also failing. What do you do?

---

### 🧠 Overview

This is a **worst-case production scenario**:

* Bad release deployed
* Rollback failing
* High business impact
* Friday evening (reduced staffing risk)

At this point, the priority shifts to:

> 🚨 **Service restoration by any safe means necessary**

You move from "standard rollback" to **disaster containment mode**.

---

# 🚨 Phase 1: Stabilize Immediately

### 🎯 First Question:

Is the system completely down or partially degraded?

Check:

```bash
kubectl get pods -n prod
kubectl get events -n prod
```

Check metrics:

* 5xx spike?
* Latency spike?
* DB saturation?

---

# 🔥 Phase 2: If Rollback Fails — Use Alternative Recovery Paths

---

## 🔁 Option 1: Force Deploy Last Known Good Image

Maybe Helm history is broken, but Docker image exists.

```bash
kubectl set image deployment/frontend \
  frontend=123456789.dkr.ecr.ap-south-1.amazonaws.com/app:v1.2.3 \
  -n prod
```

Direct image pinning bypasses Helm history issues.

---

## 🔁 Option 2: Scale Down New ReplicaSet Manually

```bash
kubectl get rs -n prod
kubectl scale rs frontend-abc123 --replicas=0 -n prod
kubectl scale rs frontend-oldxyz --replicas=3 -n prod
```

Manually shift traffic.

---

## 🔁 Option 3: Switch Traffic at Load Balancer Level

If Blue/Green setup exists:

```bash
aws elbv2 modify-listener \
  --listener-arn <arn> \
  --default-actions Type=forward,TargetGroupArn=<previous-tg>
```

Bypass Kubernetes entirely.

---

## 🔁 Option 4: Emergency Hotfix

If rollback impossible (e.g., DB migration broke backward compatibility):

* Patch config
* Disable feature flag
* Push minimal hotfix branch

Example feature flag disable:

```bash
kubectl edit configmap feature-flags -n prod
```

Restart pods:

```bash
kubectl rollout restart deployment/frontend -n prod
```

---

# 🧩 Common Reasons Rollback Fails

| Reason                    | Explanation                 | Action                |
| ------------------------- | --------------------------- | --------------------- |
| DB migration incompatible | Schema changed              | Forward-fix migration |
| Secrets changed           | Old pods fail auth          | Restore secret        |
| Helm state corrupted      | History lost                | Manual image deploy   |
| Dependency removed        | Old version not in registry | Re-push image         |
| Infra drift               | Terraform mismatch          | Manual infra patch    |

---

# 🛑 Phase 3: Protect Data First

If system unstable:

* Stop background jobs
* Disable writes
* Enable maintenance mode

Example:

```bash
kubectl scale deployment worker --replicas=0 -n prod
```

Protect DB from corruption.

---

# 📢 Phase 4: Incident Command Structure

Even Friday evening:

* Declare SEV-1
* Create war room
* Assign roles:

| Role               | Responsibility   |
| ------------------ | ---------------- |
| Incident Commander | Decision making  |
| Ops Lead           | Infra recovery   |
| App Lead           | Code fix         |
| Scribe             | Timeline logging |

No chaos debugging.

---

# 🔍 Phase 5: Identify Root Cause

Check:

```bash
kubectl describe pod <pod>
kubectl logs <pod>
```

Check:

```bash
git log --oneline -5
```

Was there:

* Breaking DB migration?
* Feature flag default change?
* Resource limit removal?
* Wrong image tag?

---

# 🛡 Phase 6: Post-Recovery Hardening

After service restored:

### ✅ Add these controls

1. **Canary deployment**
2. **Automatic rollback on error spike**
3. **Backward-compatible DB migrations**
4. **Immutable image tagging (no :latest)**
5. **Deployment freeze policy on Fridays**

---

# 🔒 Production-Grade Prevention Strategy

### 1️⃣ Safe DB Migration Pattern

* Step 1: Add new column
* Step 2: Deploy code using both
* Step 3: Remove old column later

Never break backward compatibility.

---

### 2️⃣ Feature Flags for Risky Changes

Deploy dark → enable gradually.

---

### 3️⃣ Progressive Delivery (Argo Rollouts)

```yaml
strategy:
  canary:
    steps:
      - setWeight: 10
      - pause: {duration: 5m}
```

---

### 4️⃣ Enforce Change Freeze Windows

Example:

* No major releases after 4 PM Friday
* Emergency fixes only

---

# ⚠️ What NOT to Do

* ❌ Keep retrying failed rollback blindly
* ❌ Deploy random commits
* ❌ Make multiple untracked changes
* ❌ Hide the issue

---

# 📋 Real Recovery Flow (Advanced Scenario)

| Step | Action               |
| ---- | -------------------- |
| 1    | Declare SEV-1        |
| 2    | Stop background jobs |
| 3    | Attempt rollback     |
| 4    | Rollback fails       |
| 5    | Force image redeploy |
| 6    | Traffic switch       |
| 7    | Validate metrics     |
| 8    | Stabilize            |
| 9    | RCA                  |
| 10   | Prevent recurrence   |

---

# 💡 In Short (Interview Quick Recall)

* Stabilize system first
* If rollback fails → manually redeploy last stable image
* Switch traffic if possible
* Protect database integrity
* After recovery → enforce safer release strategy

👉 When rollback fails, move from **automation → controlled manual recovery**.

---
## Q4: CPU usage on all production servers suddenly hits 100% simultaneously. How do you diagnose and resolve this?

---

### 🧠 Overview

When **all production servers hit 100% CPU simultaneously**, this is usually:

* Traffic spike (legitimate or DDoS)
* Infinite loop / bad deployment
* Thundering herd problem
* DB bottleneck causing retries
* External dependency slowdown
* Crypto miner / security breach

Because it's **simultaneous across servers**, suspect:

> 🌍 External trigger or shared dependency
> 🔁 Retry storm
> 🚨 Malicious traffic

Priority:

1. Protect availability
2. Identify source
3. Stop amplification
4. Stabilize

---

# 🚨 Phase 1: Immediate Triage (First 5 Minutes)

---

## 🔎 1️⃣ Confirm CPU Pattern

```bash
top
htop
```

Or in Kubernetes:

```bash
kubectl top pods -n prod
kubectl top nodes
```

Check:

* Which pods?
* System processes?
* All services or only one?

---

## 🔎 2️⃣ Check Traffic Spike

ALB metrics:

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/ApplicationELB \
  --metric-name RequestCount
```

Prometheus:

```promql
rate(http_requests_total[1m])
```

If traffic spiked → likely load or attack.

---

# 🔥 Phase 2: Identify Root Cause Pattern

---

## 🧩 Scenario A: Legitimate Traffic Spike

Check:

* Marketing campaign?
* Sale event?
* Cron job triggered globally?

Resolution:

```bash
kubectl scale deployment frontend --replicas=10 -n prod
```

Or enable HPA:

```bash
kubectl autoscale deployment frontend \
  --cpu-percent=70 --min=3 --max=20
```

---

## 🧩 Scenario B: Infinite Loop / Bad Deployment

If started after deployment:

```bash
kubectl rollout history deployment/app -n prod
kubectl rollout undo deployment/app -n prod
```

Check logs:

```bash
kubectl logs deployment/app -n prod
```

Look for:

* Tight retry loops
* Heavy computation
* Serialization issues

---

## 🧩 Scenario C: Retry Storm (Downstream Dependency)

If DB slow:

* App retries aggressively
* All servers spike

Check DB:

```bash
SELECT * FROM pg_stat_activity;
```

Fix:

* Add exponential backoff
* Add circuit breaker
* Temporarily scale DB

---

## 🧩 Scenario D: DDoS or Bot Attack

Check:

* Sudden IP spike
* Same endpoint hit repeatedly

Mitigation:

### Enable WAF rule

```bash
aws wafv2 update-web-acl ...
```

### Rate limiting at ALB / NGINX

Example NGINX:

```nginx
limit_req_zone $binary_remote_addr zone=mylimit:10m rate=10r/s;
```

---

## 🧩 Scenario E: Crypto Miner / Compromised Node

Check unusual processes:

```bash
ps aux --sort=-%cpu | head
```

If unknown binary:

* Isolate node
* Remove from load balancer
* Rotate credentials
* Rebuild node

---

# 🛠 Phase 3: Containment Strategy

| Problem Type  | Immediate Action            |
| ------------- | --------------------------- |
| Traffic spike | Scale horizontally          |
| Bad release   | Rollback                    |
| DB bottleneck | Scale DB / optimize queries |
| Retry storm   | Reduce replicas temporarily |
| DDoS          | Enable WAF / block IPs      |
| Malware       | Isolate node                |

---

# 📈 Phase 4: Stabilize System

After mitigation:

Monitor:

```bash
kubectl top pods -n prod -w
```

Watch:

* CPU normalizing?
* Error rates?
* Latency?
* Pod restarts?

---

# 🔒 Long-Term Preventive Controls

---

## ✅ 1️⃣ Horizontal Pod Autoscaler

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  minReplicas: 3
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

---

## ✅ 2️⃣ Resource Limits

```yaml
resources:
  requests:
    cpu: "200m"
  limits:
    cpu: "500m"
```

Prevents noisy neighbor issues.

---

## ✅ 3️⃣ Add Rate Limiting

Protect backend from abuse.

---

## ✅ 4️⃣ Add Circuit Breaker (Resilience)

Prevents retry storms.

---

## ✅ 5️⃣ Add Alerting Before 100%

Alert at 70–80%.

```promql
node_cpu_seconds_total > 0.8
```

---

# 📋 Diagnosis Flow (Interview Style)

| Step | Question                   |
| ---- | -------------------------- |
| 1    | Did traffic spike?         |
| 2    | Was there a deployment?    |
| 3    | Is DB or dependency slow?  |
| 4    | Is retry logic aggressive? |
| 5    | Any suspicious processes?  |

---

# ⚠️ What NOT to Do

* ❌ Immediately restart everything
* ❌ Scale without knowing cause
* ❌ Ignore retry storms
* ❌ Debug without protecting availability

---

# 💡 In Short (Interview Quick Recall)

* Check traffic → deployment → dependencies
* Scale temporarily if needed
* Rollback if deployment-related
* Mitigate DDoS if traffic abnormal
* Add autoscaling + rate limiting

👉 When CPU spikes everywhere, suspect **external trigger or shared dependency**, not random coincidence.

---
## Q5: A critical microservice is throwing 503 errors but all health checks are passing. How do you investigate?

---

### 🧠 Overview

A **503 (Service Unavailable)** with **healthy probes** usually means:

* The pod is alive, but **not able to serve real traffic**
* Upstream dependency failure
* Connection pool exhaustion
* Thread pool saturation
* Rate limiting / circuit breaker open
* Load balancer target issues

Key insight:

> Health check success ≠ application readiness under load

Goal:

1. Identify where 503 is generated (App vs LB)
2. Find resource or dependency bottleneck
3. Restore service safely

---

# 🔍 Phase 1: Identify Where 503 Is Generated

---

## 1️⃣ Check ALB / Ingress Metrics

CloudWatch:

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/ApplicationELB \
  --metric-name HTTPCode_Target_5XX_Count
```

If ALB returning 503 → target issue
If app returning 503 → application logic issue

---

## 2️⃣ Check Kubernetes Service & Endpoints

```bash
kubectl get svc -n prod
kubectl get endpoints <service> -n prod
```

If endpoints empty → readiness probe misconfiguration.

---

# 🔎 Phase 2: Inspect Pod-Level Behavior

---

## 1️⃣ Check Resource Usage

```bash
kubectl top pods -n prod
```

Look for:

* High CPU
* Memory close to limit
* OOMKilled

Even if health probe works, CPU starvation can cause 503.

---

## 2️⃣ Check Pod Logs

```bash
kubectl logs deployment/payment -n prod --tail=100
```

Common patterns:

* `Connection pool exhausted`
* `Timeout connecting to DB`
* `Upstream service unavailable`
* `Thread pool rejected execution`

---

# 🧩 Common Real-World Causes

| Cause                  | Why Health Check Passes     | Why 503 Happens                      |
| ---------------------- | --------------------------- | ------------------------------------ |
| DB pool exhaustion     | `/health` doesn't query DB  | Real requests need DB                |
| Dependency timeout     | Health endpoint lightweight | Business API depends on external API |
| Thread pool saturation | Health endpoint fast        | Worker threads busy                  |
| Rate limiter           | Health endpoint excluded    | Business APIs throttled              |
| Circuit breaker open   | Health check bypassed       | Real traffic blocked                 |

---

# 🔬 Phase 3: Validate Dependency Health

---

## 1️⃣ Check Database

```sql
SELECT * FROM pg_stat_activity;
```

Look for:

* Too many connections
* Long-running queries

If pool exhausted → increase pool or fix leak.

---

## 2️⃣ Check Downstream Service

```bash
curl http://dependency-service:8080/health
```

If dependency failing → cascading failure.

---

# 🔁 Phase 4: Check Load Balancer & Networking

---

## 1️⃣ Target Health

```bash
aws elbv2 describe-target-health --target-group-arn <tg-arn>
```

If:

* Intermittent unhealthy → network issue
* Security group issue
* NACL issue

---

## 2️⃣ Connection Limits

Check:

```bash
netstat -an | grep ESTABLISHED | wc -l
```

Too many open connections → socket exhaustion.

---

# 🛠 Phase 5: Immediate Mitigation

---

## Scenario A: Connection Pool Exhaustion

Temporary fix:

```bash
kubectl scale deployment payment --replicas=6 -n prod
```

Long-term:

* Add proper pool sizing
* Add connection timeout

---

## Scenario B: Dependency Timeout

Enable circuit breaker:

Example (Spring Boot config):

```yaml
resilience4j:
  circuitbreaker:
    instances:
      paymentService:
        failureRateThreshold: 50
```

---

## Scenario C: Thread Pool Saturation

Increase worker threads OR scale horizontally.

---

## Scenario D: Rate Limiting

Check NGINX / Envoy config:

```nginx
limit_req zone=mylimit burst=20;
```

Adjust if too aggressive.

---

# 🧪 Phase 6: Improve Health Checks

Often issue is poor readiness probe.

Bad:

```yaml
readinessProbe:
  httpGet:
    path: /health
```

Better:

```yaml
readinessProbe:
  httpGet:
    path: /ready
```

Where `/ready` checks:

* DB connectivity
* Redis
* Dependency ping

---

# 🔒 Production Best Practices

---

## ✅ Separate Liveness vs Readiness

* Liveness → container alive
* Readiness → safe to serve traffic

---

## ✅ Add Metrics for:

* Connection pool usage
* Thread pool usage
* Dependency latency
* 5xx rate

---

## ✅ Use Circuit Breakers

Prevent cascading failure.

---

## ✅ Add Autoscaling on RPS, not just CPU

CPU might be normal but threads blocked.

---

# 📋 Investigation Flow (Interview Style)

| Step | Question                    |
| ---- | --------------------------- |
| 1    | Is 503 from ALB or app?     |
| 2    | Are endpoints registered?   |
| 3    | Resource saturation?        |
| 4    | DB pool exhausted?          |
| 5    | Downstream dependency slow? |
| 6    | Rate limiting active?       |

---

# ⚠️ What NOT to Do

* ❌ Restart all pods blindly
* ❌ Increase replicas without checking DB limits
* ❌ Assume health check means healthy
* ❌ Ignore connection pool metrics

---

# 💡 In Short (Interview Quick Recall)

* Identify where 503 originates
* Check resource saturation
* Check DB pool / thread pool
* Validate downstream dependencies
* Improve readiness probes

👉 503 + healthy checks usually means **application is alive but overloaded or blocked internally**.

---
## Q6: Your CI/CD pipeline is taking 2 hours to complete. The business wants it under 15 minutes. How do you approach this?

---

### 🧠 Overview

A 2-hour pipeline is a **delivery bottleneck**.

In DevOps terms, this impacts:

* Lead time for changes
* Deployment frequency
* Developer productivity
* Incident recovery speed

Goal:

> ⚡ Reduce pipeline time without reducing quality

Approach this as a **performance optimization problem**:

1. Measure
2. Identify bottlenecks
3. Parallelize
4. Cache
5. Optimize build strategy

---

# 🔍 Phase 1: Measure & Break Down the Pipeline

---

## Step 1️⃣: Identify Stage Timings

In Jenkins:

```groovy
pipeline {
    stages {
        stage('Build') { ... }
        stage('Test') { ... }
        stage('Scan') { ... }
        stage('Deploy') { ... }
    }
}
```

Check:

* Build time?
* Unit test time?
* Docker build time?
* Security scan time?
* Infra provisioning?

Create a timing table:

| Stage         | Current Time |
| ------------- | ------------ |
| Checkout      | 5 min        |
| Build         | 30 min       |
| Unit Tests    | 40 min       |
| Docker Build  | 25 min       |
| Security Scan | 15 min       |
| Deploy        | 5 min        |

Now you know where to attack.

---

# 🚀 Phase 2: Quick Wins (High Impact)

---

## ✅ 1️⃣ Enable Parallel Execution

Instead of sequential:

```groovy
stage('Tests') {
    parallel {
        stage('Unit Tests') { ... }
        stage('Integration Tests') { ... }
    }
}
```

Massive time reduction if CPU available.

---

## ✅ 2️⃣ Enable Dependency Caching

### Example: Maven Cache (Jenkins)

```groovy
environment {
    MAVEN_OPTS = "-Dmaven.repo.local=.m2/repository"
}
```

Or GitHub Actions:

```yaml
- uses: actions/cache@v3
  with:
    path: ~/.m2
    key: maven-${{ hashFiles('**/pom.xml') }}
```

Removes repeated dependency downloads.

---

## ✅ 3️⃣ Optimize Docker Builds

Bad:

```dockerfile
COPY . .
RUN npm install
```

Better (layer caching):

```dockerfile
COPY package.json .
RUN npm install
COPY . .
```

Enable BuildKit:

```bash
DOCKER_BUILDKIT=1 docker build .
```

---

## ✅ 4️⃣ Use Pre-Built Base Images

Instead of building from scratch every time:

```dockerfile
FROM company/base-node:1.0
```

Pre-install dependencies once.

---

# 🧩 Phase 3: Advanced Optimizations

---

## 🔹 1️⃣ Split CI & CD Pipelines

Instead of full pipeline every commit:

* PR → Build + Unit Test (5–10 min)
* Merge to main → Integration + Scan
* Tag → Deploy

Reduces unnecessary heavy jobs.

---

## 🔹 2️⃣ Use Test Splitting

If 40 min test suite:

Split across multiple executors:

```bash
pytest --maxfail=1 --dist=loadscope -n 4
```

---

## 🔹 3️⃣ Skip Unchanged Components (Monorepo Optimization)

Only build affected services.

Example:

```bash
git diff --name-only origin/main...HEAD
```

Trigger selective builds.

---

## 🔹 4️⃣ Optimize Terraform Stage

Instead of:

```bash
terraform plan
terraform apply
```

Use:

* Targeted applies
* Remote state
* Avoid full refresh every run

---

## 🔹 5️⃣ Move Heavy Scans to Async Stage

Security scans (Trivy, SonarQube) can be:

* Async
* Nightly
* Non-blocking for non-prod branches

---

# 📊 Strategy Comparison

| Strategy                  | Impact | Effort | Priority |
| ------------------------- | ------ | ------ | -------- |
| Parallel stages           | High   | Low    | 🔥       |
| Dependency caching        | High   | Low    | 🔥       |
| Docker layer optimization | High   | Medium | 🔥       |
| Test splitting            | High   | Medium | High     |
| Selective builds          | High   | Medium | High     |
| Infra optimization        | Medium | Medium | Medium   |
| Async scans               | Medium | Low    | Medium   |

---

# ⚠️ What NOT to Do

* ❌ Remove tests for speed
* ❌ Skip security scans entirely
* ❌ Add more hardware blindly
* ❌ Optimize without measuring

---

# 🔒 Production-Grade Best Practices

---

## ✅ Use Ephemeral Runners

Avoid slow shared agents.

---

## ✅ Pre-Warm Build Agents

Have:

* Pre-installed Docker
* Pre-installed language runtimes
* Cached dependencies

---

## ✅ Define SLA per Pipeline Type

| Pipeline   | Target Time |
| ---------- | ----------- |
| PR Build   | <10 min     |
| Main Merge | <15 min     |
| Release    | <20 min     |

---

# 📈 Real-World Optimization Example

From 2 hours → 18 minutes:

* Parallel tests: -30 min
* Maven cache: -20 min
* Docker caching: -15 min
* Selective build: -25 min
* Async scan: -10 min

---

# 💡 In Short (Interview Quick Recall)

* Measure stage timings first
* Parallelize everything possible
* Enable caching aggressively
* Optimize Docker layers
* Run heavy scans async

👉 CI/CD optimization = **Measure → Parallelize → Cache → Reduce unnecessary work**.

---
## Q7: A developer committed secrets (API keys) to a public GitHub repository 30 minutes ago. What is your step-by-step response?

---

### 🧠 Overview

This is a **Security Incident (SEV-1)**.

If secrets were pushed to a **public GitHub repo**, assume:

> 🔓 The secret is already compromised
> 🤖 Bots scan GitHub continuously
> ⏱ 30 minutes is enough for exploitation

Priority:

1. **Revoke/rotate immediately**
2. **Contain access**
3. **Audit usage**
4. **Remove secret from Git history**
5. **Prevent recurrence**

---

# 🚨 Phase 1: Immediate Containment (First 5–10 Minutes)

---

## 1️⃣ Identify the Secret Type

Is it:

* AWS access key?
* Database password?
* Stripe key?
* GitHub PAT?
* Kubernetes token?

This determines impact.

---

## 2️⃣ Revoke or Rotate Immediately (Do NOT wait)

### 🔐 Example: AWS Access Key

Deactivate:

```bash
aws iam update-access-key \
  --access-key-id AKIAxxxx \
  --status Inactive \
  --user-name app-user
```

Then delete:

```bash
aws iam delete-access-key \
  --access-key-id AKIAxxxx \
  --user-name app-user
```

Create new key:

```bash
aws iam create-access-key --user-name app-user
```

Update secret store (SSM/Secrets Manager/K8s).

---

### 🔐 Example: Rotate Kubernetes Secret

```bash
kubectl create secret generic api-secret \
  --from-literal=API_KEY=new_value \
  -n prod --dry-run=client -o yaml | kubectl apply -f -
```

Restart deployment:

```bash
kubectl rollout restart deployment/app -n prod
```

---

# 🔎 Phase 2: Audit for Abuse

---

## 1️⃣ Check CloudTrail (AWS Example)

```bash
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=AccessKeyId,AttributeValue=AKIAxxxx
```

Look for:

* Suspicious IPs
* Resource creation
* IAM changes
* Crypto mining activity

---

## 2️⃣ Check Billing Spike

```bash
aws ce get-cost-and-usage ...
```

Unexpected EC2/GPU usage?

---

## 3️⃣ Check GitHub Access Logs

In GitHub → Settings → Security → Audit log

---

# 🧹 Phase 3: Remove Secret from Git History

⚠️ Simply deleting the file is NOT enough.

---

## Option 1️⃣: BFG Repo-Cleaner

```bash
bfg --delete-files secrets.txt
bfg --replace-text passwords.txt
```

---

## Option 2️⃣: git filter-repo (Preferred)

```bash
git filter-repo --path secrets.txt --invert-paths
```

Force push:

```bash
git push --force
```

⚠️ Notify team to re-clone repository.

---

# 🔒 Phase 4: Invalidate Exposure Publicly

If repo was public:

* Make repo private temporarily
* Enable GitHub Secret Scanning
* Enable Dependabot security alerts

---

# 🛡 Phase 5: Production Hardening

---

## ✅ 1️⃣ Enable Secret Scanning

GitHub → Settings → Code security → Secret scanning

---

## ✅ 2️⃣ Enforce Pre-Commit Hooks

Example using `git-secrets`:

```bash
git secrets --install
git secrets --register-aws
```

Prevents committing AWS keys.

---

## ✅ 3️⃣ Use Environment-Based Secrets Only

Never store in:

* `.env` in repo
* Config files
* Dockerfile

Use:

* AWS Secrets Manager
* SSM Parameter Store
* Vault
* Kubernetes Secrets

---

## ✅ 4️⃣ Use IAM Roles Instead of Access Keys

Instead of static keys:

```yaml
serviceAccountName: app-sa
```

Use IRSA (IAM Role for Service Accounts).

Removes need for AWS keys entirely.

---

# 📋 Incident Timeline Example

| Time     | Action                     |
| -------- | -------------------------- |
| 02:00    | Secret committed           |
| 02:05    | Discovered                 |
| 02:07    | Key revoked                |
| 02:10    | New key generated          |
| 02:15    | Deployed new secret        |
| 02:30    | CloudTrail audit completed |
| Next Day | Postmortem                 |

---

# 📝 Postmortem Questions

* Why was secret in local file?
* Why no pre-commit scanning?
* Why no GitHub secret scanning?
* Why not using IAM roles?

---

# ⚠️ What NOT to Do

* ❌ Just delete the file and move on
* ❌ Assume nobody saw it
* ❌ Delay key rotation
* ❌ Ignore audit logs

---

# 🔥 Real Risk Example

Public AWS keys can be used to:

* Launch crypto mining EC2
* Exfiltrate S3 data
* Delete infrastructure
* Create IAM backdoors

Minutes matter.

---

# 💡 In Short (Interview Quick Recall)

* Assume compromise immediately
* Revoke/rotate secret first
* Audit logs for abuse
* Remove secret from Git history
* Implement secret scanning & IAM roles

👉 With exposed secrets: **Rotate first. Investigate second. Prevent forever.**

---
## Q8: You need to deploy a hotfix to production immediately but your standard pipeline takes 45 minutes. What do you do?

---

### 🧠 Overview

This is a **high-urgency production change** scenario.

Constraints:

* Production impact active
* Standard CI/CD = 45 minutes
* Business needs immediate fix

Principle:

> 🚑 Speed up safely, don’t bypass controls blindly.

You use a **controlled emergency release path**, not random SSH + manual patching.

Goal:

1. Fix impact fast
2. Minimize risk
3. Maintain auditability

---

# 🚨 Phase 1: Assess Scope (2–3 Minutes)

Ask:

* Is it config-only?
* Feature flag toggle?
* Small code change?
* Infra issue?
* Can we mitigate without deploy?

If possible → avoid code deploy entirely.

---

# ⚡ Phase 2: Fastest Safe Mitigation Options

---

## 🧩 Option 1: Feature Flag Disable (Fastest)

If issue tied to new feature:

```bash
kubectl edit configmap feature-flags -n prod
```

Or update in Secrets Manager:

```bash
aws secretsmanager update-secret \
  --secret-id feature-flags \
  --secret-string '{"newFeature": false}'
```

Restart pods:

```bash
kubectl rollout restart deployment/app -n prod
```

⏱ Time: 3–5 minutes

---

## 🧩 Option 2: Scale or Traffic Control

If load-related:

```bash
kubectl scale deployment app --replicas=10 -n prod
```

Or reduce traffic via ALB weighting.

---

## 🧩 Option 3: Deploy Pre-Built Image (Bypass Full Pipeline)

If the fix is already built/tested (e.g., earlier commit):

```bash
kubectl set image deployment/app \
  app=123456.dkr.ecr.ap-south-1.amazonaws.com/app:stable-tag \
  -n prod
```

Avoids:

* Rebuilding
* Full CI
* Long scan cycle

⏱ Time: 2–5 minutes

---

## 🧩 Option 4: Emergency “Hotfix Pipeline”

Maintain a slim pipeline for emergencies:

```groovy
pipeline {
  stages {
    stage('Build') { ... }
    stage('Unit Test') { ... }
    stage('Deploy') { ... }
  }
}
```

Skip:

* Full regression tests
* Heavy security scans
* Non-prod deployments

Only for SEV-1.

---

# 🔥 Phase 3: Controlled Emergency Deployment

---

## 1️⃣ Create Hotfix Branch

```bash
git checkout -b hotfix/payment-timeout
```

Fix minimal code only.

---

## 2️⃣ Peer Review (Fast but mandatory)

At least 1 approval.

---

## 3️⃣ Build & Tag Clearly

```bash
docker build -t app:hotfix-20260214 .
docker push <ECR>/app:hotfix-20260214
```

---

## 4️⃣ Deploy Directly to Prod

```bash
kubectl set image deployment/app \
  app=<ECR>/app:hotfix-20260214 -n prod
```

---

## 5️⃣ Monitor Closely

```bash
kubectl rollout status deployment/app -n prod
kubectl top pods -n prod
```

Watch:

* Error rate
* CPU
* Latency
* Logs

---

# 🛡 Phase 4: After Stabilization

Once resolved:

1. Merge hotfix into main
2. Run full pipeline
3. Backfill tests if missing
4. Conduct postmortem

---

# 📋 Decision Matrix

| Scenario                | Fastest Safe Action |
| ----------------------- | ------------------- |
| Feature issue           | Disable flag        |
| Config error            | Update ConfigMap    |
| Previous version stable | Deploy old image    |
| Code fix needed         | Hotfix branch       |
| Infra issue             | Manual patch        |

---

# 🔒 Production Best Practices

---

## ✅ Maintain Pre-Built Stable Images

Always keep:

* `stable`
* `last-known-good`
* `previous-release`

---

## ✅ Keep Emergency Pipeline Ready

Document:

* How to deploy manually
* How to rollback
* Who approves

---

## ✅ Blue/Green for Instant Switch

If available:

```bash
aws elbv2 modify-listener ...
```

Switch traffic instantly.

---

## ✅ Protect Audit Trail

Even emergency deploy must have:

* Git commit
* Tagged image
* Change record
* Slack notification

---

# ⚠️ What NOT to Do

* ❌ SSH into server and edit files
* ❌ Skip code review entirely
* ❌ Disable monitoring
* ❌ Push untested large change

---

# 📈 Ideal Architecture to Support This

To meet <15 min hotfix target:

* Parallel CI
* Pre-cached runners
* Canary deploy
* Feature flags
* Slim emergency pipeline

---

# 💡 In Short (Interview Quick Recall)

* Mitigate first (feature flag/config)
* If deploy required → use minimal hotfix pipeline
* Deploy pre-built image when possible
* Monitor aggressively
* Backfill full validation later

👉 Emergency deploys should be **fast, minimal, controlled, and auditable** — never chaotic.

---
## Q9: Your deployment pipeline works perfectly in staging but consistently fails in production. How do you debug this?

---

### 🧠 Overview

When **staging succeeds but production fails**, the issue is almost always:

* Environment drift
* Config / secret mismatch
* IAM / permission difference
* Infra scale difference
* Data difference
* Networking restriction

Principle:

> If code is identical, the environment is not.

Goal:

1. Identify what differs
2. Compare infra + config
3. Reproduce prod-like conditions
4. Fix root cause, not symptom

---

# 🔍 Phase 1: Confirm It's Truly Identical Code

---

## 1️⃣ Verify Image Tag

```bash
kubectl get deployment app -n staging -o=jsonpath='{.spec.template.spec.containers[0].image}'
kubectl get deployment app -n prod -o=jsonpath='{.spec.template.spec.containers[0].image}'
```

If different tags → not same build.

---

## 2️⃣ Verify Git SHA

```bash
kubectl describe pod <pod> -n prod | grep image:
```

Confirm same commit deployed.

---

# 🔎 Phase 2: Compare Environment Differences

---

## 🔐 1️⃣ Compare Secrets

```bash
kubectl get secret app-secret -n staging -o yaml
kubectl get secret app-secret -n prod -o yaml
```

Common issues:

* Missing env variable
* Different DB endpoint
* Wrong API key
* Expired token

---

## ⚙️ 2️⃣ Compare ConfigMaps

```bash
kubectl get configmap app-config -n staging -o yaml
kubectl get configmap app-config -n prod -o yaml
```

Look for:

* Feature flags
* Timeout settings
* Memory configs
* Rate limits

---

## 🔒 3️⃣ Compare IAM Permissions (AWS Example)

Production often stricter.

```bash
aws iam simulate-principal-policy \
  --policy-source-arn arn:aws:iam::123456:role/prod-role \
  --action-names s3:PutObject
```

Common prod failures:

* AccessDenied
* Missing KMS decrypt
* Missing S3 permissions

---

# 🧩 Phase 3: Check Infrastructure Differences

---

## 🖥 1️⃣ Resource Limits

```bash
kubectl describe pod <pod> -n prod
```

Compare:

```yaml
resources:
  requests:
    cpu: 200m
  limits:
    cpu: 300m
```

Staging may have higher limits → prod throttling.

---

## 🌐 2️⃣ Networking Differences

Check:

* Security groups
* NACL
* VPC peering
* Private endpoints

Example:

```bash
kubectl exec -it <pod> -n prod -- curl db.internal:5432
```

Does prod have network restriction?

---

## 🗄 3️⃣ Database Differences

Production DB might:

* Have more data
* Slower queries
* Different schema

Run:

```sql
SELECT COUNT(*) FROM large_table;
```

Query plan differences?

---

# 🔬 Phase 4: Examine Production Logs

---

```bash
kubectl logs deployment/app -n prod --tail=200
```

Look for:

* Timeout
* AccessDenied
* Connection refused
* Resource exhaustion
* 503 from dependency

---

# 🔥 Phase 5: Reproduce in Staging

To validate hypothesis:

* Use prod config in staging
* Use prod-like dataset
* Apply prod resource limits

Simulate failure intentionally.

---

# 📊 Common Root Causes Table

| Category        | Example Issue              |
| --------------- | -------------------------- |
| Secrets         | Missing API key            |
| IAM             | AccessDenied               |
| Networking      | Security group block       |
| Resource limits | CPU throttling             |
| DB              | Slow query under real load |
| External API    | Prod firewall restriction  |
| TLS             | Certificate mismatch       |
| Feature flag    | Enabled only in prod       |

---

# 🛠 Phase 6: Add Debug Instrumentation

If unclear:

* Enable debug logs temporarily
* Add request tracing (Jaeger, X-Ray)
* Check Prometheus metrics

Example:

```promql
rate(http_requests_total{status=~"5.."}[5m])
```

---

# 🔒 Long-Term Prevention

---

## ✅ 1️⃣ Infrastructure as Code Only

Use same Terraform modules:

```hcl
module "app" {
  environment = var.env
}
```

Avoid manual prod changes.

---

## ✅ 2️⃣ Environment Parity

* Same Kubernetes version
* Same node types
* Same resource limits
* Same Helm chart

---

## ✅ 3️⃣ Automated Config Drift Detection

Use:

* Terraform plan in CI
* Drift detection tools

---

## ✅ 4️⃣ Production-Like Staging

* Similar data size
* Same IAM policies
* Same scaling settings

---

# 📋 Debug Flow (Interview Style)

| Step | Action                |
| ---- | --------------------- |
| 1    | Verify same image     |
| 2    | Compare secrets       |
| 3    | Compare config        |
| 4    | Check IAM permissions |
| 5    | Check networking      |
| 6    | Check resource limits |
| 7    | Analyze logs          |
| 8    | Reproduce in staging  |

---

# ⚠️ What NOT to Do

* ❌ Assume code issue immediately
* ❌ Change production randomly
* ❌ Debug without comparing environments
* ❌ Ignore IAM differences

---

# 💡 In Short (Interview Quick Recall)

* Same code? Then environment differs
* Compare secrets, IAM, config, networking
* Check resource limits & DB scale
* Reproduce prod conditions in staging

👉 When staging works and prod fails, it’s almost always **environment drift or stricter production controls**.

---
## Q10: You need to deploy to 500 servers simultaneously with zero downtime. How do you architect this?

---

### 🧠 Overview

Deploying to **500 servers with zero downtime** requires:

* No single point of failure
* Progressive traffic shifting
* Health-based rollout
* Automated rollback

Principle:

> Never update all 500 at once.
> Update in controlled waves behind a load balancer.

Architecture must support:

* Rolling updates or Blue/Green
* Health checks
* Auto scaling
* Observability
* Fast rollback

---

# 🏗 High-Level Architecture

```
Users
   ↓
Route53
   ↓
ALB / NLB
   ↓
Target Groups (Blue / Green)
   ↓
Auto Scaling Group (500 servers)
```

OR in Kubernetes:

```
Users → Ingress → Service → 500 Pods → Rolling Update Strategy
```

---

# 🔁 Strategy 1: Blue/Green Deployment (Safest)

---

## ⚙️ How It Works

* 500 servers running → Blue
* Deploy new version → Green (separate ASG)
* Validate Green
* Switch traffic instantly

---

## 🧩 AWS Example

Create new Auto Scaling Group:

```bash
aws autoscaling create-auto-scaling-group \
  --auto-scaling-group-name app-green \
  --launch-template LaunchTemplateId=lt-123
```

Attach to new target group.

Switch traffic:

```bash
aws elbv2 modify-listener \
  --listener-arn <arn> \
  --default-actions Type=forward,TargetGroupArn=<green-tg>
```

⏱ Downtime: 0 seconds
Rollback: Switch back to Blue

---

## 📊 Pros vs Cons

| Feature    | Blue/Green                      |
| ---------- | ------------------------------- |
| Downtime   | Zero                            |
| Risk       | Low                             |
| Infra Cost | High (double infra temporarily) |
| Rollback   | Instant                         |

---

# 🔁 Strategy 2: Rolling Update (Controlled Waves)

---

## ⚙️ Auto Scaling Rolling Update

Instead of 500 at once:

Update in batches of 10–20.

Example (ASG):

```json
"MaxBatchSize": 20,
"MinInstancesInService": 480
```

Ensures:

* 480 always running
* 20 updating at a time

---

## 🧩 Kubernetes Example

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 5%
    maxSurge: 5%
```

With 500 pods:

* 25 max unavailable
* 25 surge pods

Zero downtime maintained.

---

# 🔁 Strategy 3: Canary Deployment (Advanced)

Deploy to 5% first:

```yaml
strategy:
  canary:
    steps:
      - setWeight: 5
      - pause: {duration: 5m}
      - setWeight: 50
```

If metrics healthy → continue
If not → auto rollback

Best for high-risk changes.

---

# 🔍 Critical Zero-Downtime Requirements

---

## ✅ 1️⃣ Proper Health Checks

ALB:

```bash
--health-check-path /health
```

Kubernetes:

```yaml
readinessProbe:
  httpGet:
    path: /ready
```

Only healthy instances receive traffic.

---

## ✅ 2️⃣ Graceful Shutdown

Avoid dropping active requests.

Example:

```yaml
terminationGracePeriodSeconds: 30
```

App must handle SIGTERM properly.

---

## ✅ 3️⃣ Connection Draining

ALB deregistration delay:

```bash
--deregistration-delay 30
```

Allows in-flight requests to finish.

---

## ✅ 4️⃣ Stateless Application

All 500 servers must be:

* Stateless
* Shared DB
* Shared cache (Redis)
* No local session storage

---

## ✅ 5️⃣ Backward-Compatible Deployments

Database migrations must be:

* Expand first
* Deploy code
* Contract later

Never break running version.

---

# 🛠 CI/CD Architecture for 500 Nodes

---

## Jenkins Example

```groovy
stage('Deploy') {
    steps {
        sh './deploy.sh --strategy=rolling'
    }
}
```

Deploy script should:

* Wait for health
* Validate batch
* Continue next batch

---

# 📈 Monitoring During Deployment

Monitor in real time:

* 5xx error rate
* Latency
* CPU
* Memory
* Pod restarts

Example:

```promql
rate(http_requests_total{status=~"5.."}[1m])
```

Abort if spike.

---

# 📋 Strategy Comparison

| Strategy   | Risk   | Cost   | Rollback Speed | Recommended When  |
| ---------- | ------ | ------ | -------------- | ----------------- |
| Rolling    | Medium | Low    | Medium         | Normal releases   |
| Blue/Green | Low    | High   | Instant        | Critical systems  |
| Canary     | Lowest | Medium | Fast           | High-risk changes |

---

# ⚠️ What NOT to Do

* ❌ Deploy to all 500 simultaneously
* ❌ Disable health checks
* ❌ Skip readiness probes
* ❌ Ignore graceful shutdown
* ❌ Run incompatible DB migration

---

# 💡 In Short (Interview Quick Recall)

* Use Blue/Green or controlled Rolling updates
* Always deploy in batches
* Use health checks + connection draining
* Ensure stateless architecture
* Monitor metrics and auto rollback

👉 Zero downtime at scale = **traffic control + health validation + controlled rollout + instant rollback**.

---
## Q11: Your Kubernetes cluster has 200 pods stuck in "Pending" state during peak traffic. What caused this and how do you fix it?

---

### 🧠 Overview

`Pending` means:

> Scheduler cannot place pods on any node.

At peak traffic, this is usually a **capacity or scheduling problem**.

Common causes:

* Insufficient CPU/Memory
* Node group maxed out
* Resource requests too high
* Taints/Tolerations mismatch
* PVC not bound
* IP address exhaustion (VPC CNI)
* HPA scaling faster than Cluster Autoscaler

Goal:

1. Identify scheduling failure reason
2. Restore capacity immediately
3. Prevent recurrence

---

# 🔍 Phase 1: Identify Exact Scheduling Error

---

## 1️⃣ Describe One Pending Pod

```bash
kubectl describe pod <pod-name> -n prod
```

Look at:

```
Events:
0/10 nodes are available: 
10 Insufficient cpu
```

OR

```
node(s) had taint {dedicated: gpu}, that the pod didn't tolerate
```

OR

```
pod has unbound immediate PersistentVolumeClaims
```

This message tells you root cause directly.

---

# 🧩 Common Causes & Fixes

---

# 🔥 Scenario 1: Insufficient CPU/Memory (Most Common)

Message:

```
Insufficient cpu
Insufficient memory
```

### Immediate Fix

Scale node group:

```bash
aws autoscaling update-auto-scaling-group \
  --auto-scaling-group-name eks-prod-ng \
  --desired-capacity 20
```

If using Cluster Autoscaler:

```bash
kubectl get pods -n kube-system | grep cluster-autoscaler
```

Check logs:

```bash
kubectl logs deployment/cluster-autoscaler -n kube-system
```

---

### Long-Term Fix

* Increase node size
* Tune pod requests
* Enable cluster autoscaler

---

# 🔥 Scenario 2: Resource Requests Too High

Example:

```yaml
resources:
  requests:
    cpu: "4"
    memory: "8Gi"
```

Even if actual usage is low, scheduler blocks placement.

### Fix

Reduce request:

```yaml
requests:
  cpu: "500m"
```

Redeploy.

---

# 🔥 Scenario 3: Node Group Max Limit Reached

Check:

```bash
kubectl get nodes
```

If count stable during scale event → autoscaler max reached.

Fix:

Update ASG max size.

---

# 🔥 Scenario 4: Taints & Tolerations Mismatch

Check node taints:

```bash
kubectl describe node <node-name> | grep Taints
```

Pod spec must include:

```yaml
tolerations:
  - key: "dedicated"
    operator: "Equal"
    value: "app"
    effect: "NoSchedule"
```

---

# 🔥 Scenario 5: PVC / Storage Issue

Error:

```
pod has unbound immediate PersistentVolumeClaims
```

Check:

```bash
kubectl get pvc -n prod
```

Fix:

* StorageClass issue
* Volume quota exceeded
* EBS limit reached

---

# 🔥 Scenario 6: IP Address Exhaustion (EKS Specific)

In AWS EKS, pods require ENI IPs.

If exhausted:

```
failed to assign IP address to pod
```

Check:

```bash
kubectl logs aws-node -n kube-system
```

Fix:

Enable prefix delegation or increase instance size.

---

# 🚨 Immediate Recovery Playbook

| Cause             | Fastest Fix           |
| ----------------- | --------------------- |
| Insufficient CPU  | Scale node group      |
| Requests too high | Patch deployment      |
| ASG max reached   | Increase max capacity |
| PVC issue         | Fix storage class     |
| IP exhaustion     | Add larger nodes      |

---

# 📈 Phase 2: Validate After Fix

Watch:

```bash
kubectl get pods -n prod -w
```

Ensure:

* Pending → Running
* HPA stabilizes
* CPU normalizes

---

# 🔒 Long-Term Preventive Controls

---

## ✅ 1️⃣ Enable Cluster Autoscaler

Ensure:

```bash
--balance-similar-node-groups
--expander=least-waste
```

---

## ✅ 2️⃣ Use HPA Properly

```yaml
metrics:
- type: Resource
  resource:
    name: cpu
    target:
      averageUtilization: 70
```

---

## ✅ 3️⃣ Right-Size Resource Requests

Use Prometheus data to tune.

---

## ✅ 4️⃣ Add Capacity Buffer

Never run cluster at 100%.

Keep ~20% headroom.

---

## ✅ 5️⃣ Monitor Scheduling Failures

Prometheus alert:

```promql
kube_pod_status_phase{phase="Pending"} > 10
```

---

# 📋 Diagnosis Flow (Interview Style)

| Step | Action                    |
| ---- | ------------------------- |
| 1    | Describe pod              |
| 2    | Identify scheduling error |
| 3    | Check node capacity       |
| 4    | Check autoscaler          |
| 5    | Check resource requests   |
| 6    | Check IP/storage limits   |

---

# ⚠️ What NOT to Do

* ❌ Restart pods blindly
* ❌ Delete random nodes
* ❌ Increase replicas without node capacity
* ❌ Ignore autoscaler logs

---

# 💡 In Short (Interview Quick Recall)

* `Pending` = scheduler cannot place pod
* Check `kubectl describe pod` first
* Most common cause = insufficient resources
* Scale nodes or tune requests
* Maintain headroom + autoscaling

👉 200 Pending pods during peak traffic usually means **capacity planning failure or autoscaler misconfiguration**.

---
## Q12: A containerized application works locally but crashes in Kubernetes with OOMKilled errors. How do you resolve this?

---

### 🧠 Overview

`OOMKilled` in Kubernetes means:

> The container exceeded its **memory limit**, and the kernel terminated it.

Why it works locally:

* No strict memory limits
* Docker Desktop often has higher memory
* No cgroup enforcement like in K8s

Why it fails in K8s:

* `resources.limits.memory` enforced
* Production workload heavier
* Memory leak
* Incorrect JVM / runtime memory settings

Goal:

1. Confirm OOM root cause
2. Identify whether limit too low or leak
3. Fix resource configuration properly
4. Prevent recurrence

---

# 🔍 Phase 1: Confirm OOMKilled

---

## 1️⃣ Check Pod Status

```bash
kubectl get pods -n prod
```

Look for:

```
CrashLoopBackOff
OOMKilled
```

---

## 2️⃣ Describe Pod

```bash
kubectl describe pod <pod-name> -n prod
```

Look for:

```
Last State: Terminated
Reason: OOMKilled
```

---

# 🔎 Phase 2: Check Resource Configuration

---

## 1️⃣ Inspect Deployment YAML

```bash
kubectl get deployment app -n prod -o yaml
```

Check:

```yaml
resources:
  requests:
    memory: "256Mi"
  limits:
    memory: "256Mi"
```

If limit = 256Mi and app needs 600Mi → crash guaranteed.

---

# 🧩 Common Root Causes

| Cause                   | Why It Happens              |
| ----------------------- | --------------------------- |
| Memory limit too low    | Production load higher      |
| Memory leak             | Objects not released        |
| JVM not container-aware | Uses host memory assumption |
| Large dataset in prod   | Local test data small       |
| Cache misconfiguration  | No eviction policy          |
| Too many worker threads | High heap usage             |

---

# 🔥 Scenario 1: Limit Too Low (Most Common)

---

## Check Actual Usage

```bash
kubectl top pod <pod-name> -n prod
```

If usage near limit:

Increase limit:

```yaml
resources:
  requests:
    memory: "512Mi"
  limits:
    memory: "1Gi"
```

Apply:

```bash
kubectl apply -f deployment.yaml
```

---

# 🔥 Scenario 2: JVM Container Memory Issue (Java Apps)

Older JVMs ignore container limits.

Fix:

```bash
JAVA_TOOL_OPTIONS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"
```

Or explicitly:

```bash
-Xmx512m
```

Without this, JVM may try to use full node memory.

---

# 🔥 Scenario 3: Memory Leak

Symptoms:

* Memory usage gradually increases
* OOM after some time

Check metrics:

```promql
container_memory_usage_bytes
```

If steadily rising → leak.

Fix:

* Heap dump
* Profiling (VisualVM, JProfiler)
* Fix code

---

# 🔥 Scenario 4: High Traffic in Production

Local tests:

* 10 requests

Prod:

* 500 RPS

Fix:

* Scale horizontally:

```bash
kubectl scale deployment app --replicas=5 -n prod
```

* Add HPA:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  minReplicas: 2
  maxReplicas: 10
```

---

# 🔥 Scenario 5: Cache or Buffer Misconfiguration

Example: Redis cache fallback storing too much data.

Add limits or eviction:

```yaml
maxmemory-policy: allkeys-lru
```

---

# 🛠 Phase 3: Short-Term Mitigation

| Action                | When to Use             |
| --------------------- | ----------------------- |
| Increase memory limit | Immediate stabilization |
| Reduce concurrency    | High traffic issue      |
| Scale replicas        | Traffic-driven          |
| Restart pod           | Temporary relief        |

---

# 🔒 Long-Term Prevention

---

## ✅ 1️⃣ Proper Requests vs Limits

Best practice:

```yaml
requests:
  memory: "500Mi"
limits:
  memory: "1Gi"
```

Avoid setting equal values unless intentional.

---

## ✅ 2️⃣ Monitor Memory Trends

Prometheus alert:

```promql
container_memory_usage_bytes / container_spec_memory_limit_bytes > 0.9
```

Alert before OOM.

---

## ✅ 3️⃣ Load Testing Before Production

Simulate real traffic.

---

## ✅ 4️⃣ Right-Sized Node Types

Small nodes increase OOM risk cluster-wide.

---

## ✅ 5️⃣ Enable VPA (Vertical Pod Autoscaler)

Automatically adjust requests.

---

# 📋 Debug Flow (Interview Style)

| Step | Action                            |
| ---- | --------------------------------- |
| 1    | Confirm OOMKilled                 |
| 2    | Check memory limits               |
| 3    | Check actual memory usage         |
| 4    | Compare prod vs local load        |
| 5    | Check JVM settings                |
| 6    | Investigate memory leak if needed |

---

# ⚠️ What NOT to Do

* ❌ Just increase memory blindly forever
* ❌ Ignore memory growth trend
* ❌ Set unlimited memory
* ❌ Assume local behavior matches production

---

# 💡 In Short (Interview Quick Recall)

* OOMKilled = container exceeded memory limit
* Check limits vs actual usage
* Increase limit or fix memory leak
* Tune JVM/runtime for container awareness
* Monitor and autoscale properly

👉 Works locally but fails in K8s usually means **resource limits + real production load expose memory constraints**.

----
## Q13: Your Kubernetes cluster is running out of IP addresses in production. How do you solve this without downtime?

---

### 🧠 Overview

In production (especially **AWS EKS**), IP exhaustion usually means:

> Pods cannot get IPs → New pods stay `Pending` → Scaling fails

Root causes:

* Small VPC CIDR
* Subnet IP exhaustion
* ENI/IP limits per instance
* No prefix delegation enabled
* Too many small instance types

Critical fact:

> Each Pod consumes a VPC IP (AWS VPC CNI).

Goal:

1. Stop immediate impact
2. Expand IP capacity without downtime
3. Prevent future exhaustion

---

# 🔍 Phase 1: Confirm IP Exhaustion

---

## 1️⃣ Check Pending Pods

```bash
kubectl get pods -A | grep Pending
```

---

## 2️⃣ Check AWS CNI Logs

```bash
kubectl logs -n kube-system daemonset/aws-node
```

Look for:

```
failed to assign IP address to pod
Insufficient free IP addresses
```

---

## 3️⃣ Check Subnet Usage

```bash
aws ec2 describe-subnets --subnet-ids subnet-xxxx \
  --query 'Subnets[*].AvailableIpAddressCount'
```

If low (<10–20 IPs), you're exhausted.

---

# 🚨 Immediate Mitigation (No Downtime)

---

# 🔥 Option 1: Enable Prefix Delegation (Best Quick Fix)

Instead of 1 IP per ENI slot, prefix delegation allows multiple IPs per ENI.

Enable:

```bash
kubectl set env daemonset aws-node \
  -n kube-system ENABLE_PREFIX_DELEGATION=true
```

Restart:

```bash
kubectl rollout restart daemonset aws-node -n kube-system
```

✅ Increases IP capacity dramatically
✅ No cluster downtime

---

# 🔥 Option 2: Add New Subnets with Larger CIDR

If subnets too small:

1. Create larger subnet:

```bash
aws ec2 create-subnet \
  --vpc-id vpc-xxxx \
  --cidr-block 10.0.64.0/18
```

2. Add subnet to EKS node group.

3. Scale node group.

New nodes launch in new subnet automatically.

Zero downtime if rolling.

---

# 🔥 Option 3: Add Secondary CIDR Block to VPC

If entire VPC exhausted:

```bash
aws ec2 associate-vpc-cidr-block \
  --vpc-id vpc-xxxx \
  --cidr-block 100.64.0.0/16
```

Then create new subnets from new CIDR.

No downtime required.

---

# 🔥 Option 4: Use Larger Instance Types

Small instances:

* Fewer ENIs
* Fewer IPs

Check limits:

```bash
aws ec2 describe-instance-types \
  --instance-types t3.medium
```

Switch to:

* m5.large
* c5.large

Update node group → rolling update.

---

# 🔥 Option 5: Reduce IP Consumption

Short-term:

* Scale down non-critical workloads
* Reduce replicas temporarily

```bash
kubectl scale deployment batch-job --replicas=0
```

Buys time.

---

# 📊 IP Limits Example (AWS)

| Instance Type | Max Pods (Without Prefix Delegation) |
| ------------- | ------------------------------------ |
| t3.medium     | ~17                                  |
| m5.large      | ~29                                  |
| m5.xlarge     | ~58                                  |

With prefix delegation → significantly higher.

---

# 🔒 Long-Term Architecture Fixes

---

## ✅ 1️⃣ Design Large Enough VPC CIDR

Bad:

```
10.0.0.0/24
```

Better:

```
10.0.0.0/16
```

Plan for growth.

---

## ✅ 2️⃣ Always Enable Prefix Delegation in EKS

Best practice for production clusters.

---

## ✅ 3️⃣ Monitor Available IPs

CloudWatch alert:

```bash
AvailableIpAddressCount < 50
```

Alert before exhaustion.

---

## ✅ 4️⃣ Use Separate Node Groups

* System pods
* App workloads
* Batch jobs

Prevents IP starvation.

---

## ✅ 5️⃣ Consider Alternate CNI (Advanced)

Calico overlay:

* Pod IPs not tied to VPC

Tradeoff: More complexity.

---

# 📋 Zero-Downtime Resolution Strategy

| Step | Action                   |
| ---- | ------------------------ |
| 1    | Confirm IP exhaustion    |
| 2    | Enable prefix delegation |
| 3    | Add new subnet if needed |
| 4    | Scale node group         |
| 5    | Monitor pending pods     |

---

# ⚠️ What NOT to Do

* ❌ Recreate cluster
* ❌ Drain all nodes simultaneously
* ❌ Resize VPC incorrectly
* ❌ Ignore subnet sizing in planning

---

# 💡 In Short (Interview Quick Recall)

* EKS pods consume VPC IPs
* Check CNI logs for IP exhaustion
* Enable prefix delegation
* Add larger subnets or secondary CIDR
* Monitor IP availability proactively

👉 IP exhaustion in Kubernetes is a **network capacity planning issue**, not an application issue — fix by expanding IP pool without stopping traffic.

----
## Q14: A critical pod is being evicted every 10 minutes due to resource pressure. What is your resolution strategy?

---

### 🧠 Overview

If a pod is being **Evicted**, Kubernetes is protecting node stability.

Common eviction reasons:

* `MemoryPressure`
* `DiskPressure`
* `PIDPressure`
* Node ephemeral storage full

Important:

> Eviction ≠ Crash
> It’s the kubelet proactively removing pods to protect the node.

If it happens every 10 minutes → underlying node pressure is persistent.

Goal:

1. Identify pressure type
2. Stabilize node
3. Protect critical workload
4. Prevent recurrence

---

# 🔍 Phase 1: Identify Exact Eviction Reason

---

## 1️⃣ Describe the Pod

```bash
kubectl describe pod <pod-name> -n prod
```

Look for:

```
Status: Failed
Reason: Evicted
Message: The node had condition: MemoryPressure
```

---

## 2️⃣ Check Node Conditions

```bash
kubectl describe node <node-name>
```

Look for:

```
Conditions:
  MemoryPressure   True
  DiskPressure     True
```

---

# 🧩 Common Causes & Fixes

---

# 🔥 Scenario 1: MemoryPressure (Most Common)

Node memory is exhausted.

Check:

```bash
kubectl top nodes
```

If usage ~90–100% → pressure confirmed.

---

## Immediate Fix

### 1️⃣ Scale Node Group

```bash
aws autoscaling update-auto-scaling-group \
  --auto-scaling-group-name eks-prod-ng \
  --desired-capacity 15
```

---

### 2️⃣ Reduce Non-Critical Workloads

```bash
kubectl scale deployment batch-jobs --replicas=0
```

Protect critical service first.

---

## Long-Term Fix

* Increase node size
* Tune pod memory requests
* Enable HPA
* Add cluster autoscaler

---

# 🔥 Scenario 2: DiskPressure

Check:

```bash
df -h
```

Or inside node:

```bash
kubectl debug node/<node-name> -it --image=busybox
```

Common causes:

* Large logs
* Image buildup
* Ephemeral storage overflow

---

## Immediate Fix

Clean unused images:

```bash
docker system prune -af
```

Or configure kubelet:

```yaml
--image-gc-high-threshold=80
--image-gc-low-threshold=60
```

---

# 🔥 Scenario 3: Critical Pod Has Low Priority

If node under pressure, low-priority pods evicted first.

Check:

```bash
kubectl get priorityclass
```

Set higher priority:

```yaml
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: critical-priority
value: 100000
```

Apply to pod:

```yaml
priorityClassName: critical-priority
```

---

# 🔥 Scenario 4: Resource Requests Misconfigured

If critical pod has low request:

```yaml
requests:
  memory: "100Mi"
```

Scheduler underestimates.

Fix:

```yaml
requests:
  memory: "1Gi"
limits:
  memory: "2Gi"
```

---

# 🚨 Phase 2: Protect Critical Pod

---

## 1️⃣ Use PodDisruptionBudget (PDB)

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
spec:
  minAvailable: 1
```

Prevents voluntary eviction during drain.

---

## 2️⃣ Taint Dedicated Nodes

```bash
kubectl taint nodes node1 dedicated=critical:NoSchedule
```

Add toleration to pod:

```yaml
tolerations:
- key: "dedicated"
  operator: "Equal"
  value: "critical"
  effect: "NoSchedule"
```

---

# 📊 Diagnosis Matrix

| Eviction Type     | Immediate Action  | Long-Term Fix              |
| ----------------- | ----------------- | -------------------------- |
| MemoryPressure    | Scale nodes       | Right-size resources       |
| DiskPressure      | Clean images/logs | Larger disk / log rotation |
| PIDPressure       | Reduce processes  | Tune limits                |
| Ephemeral storage | Increase storage  | Set storage limits         |

---

# 🔒 Preventive Controls

---

## ✅ 1️⃣ Maintain Headroom

Never run cluster at 100%.

Target: 60–70% utilization.

---

## ✅ 2️⃣ Proper Resource Requests

Avoid zero requests.

---

## ✅ 3️⃣ Enable Cluster Autoscaler

Must scale before pressure occurs.

---

## ✅ 4️⃣ Add Alerts

Prometheus:

```promql
kube_node_status_condition{condition="MemoryPressure",status="true"} == 1
```

Alert before eviction wave.

---

## ✅ 5️⃣ Separate Critical & Batch Workloads

Use:

* Node groups
* Taints
* Priority classes

---

# 📋 Resolution Strategy (Interview Flow)

| Step | Action                                |
| ---- | ------------------------------------- |
| 1    | Identify eviction reason              |
| 2    | Check node conditions                 |
| 3    | Scale nodes immediately               |
| 4    | Protect critical pod (priority class) |
| 5    | Tune resource requests                |
| 6    | Implement autoscaling                 |

---

# ⚠️ What NOT to Do

* ❌ Just restart pod repeatedly
* ❌ Ignore node-level pressure
* ❌ Increase limits without increasing node capacity
* ❌ Run critical and batch workloads on same nodes

---

# 💡 In Short (Interview Quick Recall)

* Eviction = node resource protection
* Identify Memory/Disk/PID pressure
* Scale nodes immediately
* Use priority classes for critical pods
* Maintain cluster headroom

👉 Frequent eviction means **node capacity planning failure or workload misconfiguration**, not just a pod problem.

----
## Q15: Your team wants to migrate a monolithic application to microservices on Kubernetes. How do you plan and execute this?

---

### 🧠 Overview

Migrating from **Monolith → Microservices on Kubernetes** is not just a tech change — it's:

* Architecture redesign
* Deployment model change
* CI/CD transformation
* Data strategy evolution

Principle:

> Do not rewrite everything at once.
> Use **Strangler Pattern** and migrate incrementally.

Goal:

1. Reduce risk
2. Maintain business continuity
3. Improve scalability & release velocity

---

# 🏗 Phase 1: Assessment & Planning

---

## 🔍 1️⃣ Analyze the Monolith

Identify:

* Modules (Auth, Orders, Payments, Reporting)
* DB schema dependencies
* High-change areas
* High-traffic components

Questions:

* Which modules change most often?
* Which modules scale independently?
* Which modules are bottlenecks?

---

## 🔍 2️⃣ Identify Extraction Candidates

Good first microservices:

* Authentication
* Notifications
* Payments
* Reporting

Avoid extracting tightly coupled core logic first.

---

# 🧱 Phase 2: Containerize the Monolith (Step 0)

Before microservices:

* Dockerize monolith
* Deploy monolith to Kubernetes
* Establish CI/CD pipeline

Example Dockerfile:

```dockerfile
FROM openjdk:17
COPY target/app.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
```

Deploy to K8s:

```yaml
apiVersion: apps/v1
kind: Deployment
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
```

This gives:

* Zero-downtime deploys
* Autoscaling
* Observability

---

# 🔁 Phase 3: Strangler Pattern Execution

Architecture:

```
Users
  ↓
Ingress / API Gateway
  ↓
Monolith + New Microservices
```

Gradually redirect traffic.

---

## 🔹 Step 1: Add API Gateway

Use:

* NGINX Ingress
* Kong
* AWS API Gateway

Route:

```
/auth → auth-service
/orders → monolith
```

---

## 🔹 Step 2: Extract First Service

Example: Auth Service

1. Copy auth logic
2. Expose REST API
3. Monolith calls new service
4. Deploy independently

---

## 🔹 Step 3: Database Strategy

Avoid shared DB long-term.

Options:

| Strategy          | Risk          | Recommended     |
| ----------------- | ------------- | --------------- |
| Shared DB         | High coupling | Temporary only  |
| DB per service    | Best          | ✅               |
| Event-driven sync | Advanced      | Ideal long-term |

Start with shared DB, then gradually separate.

---

# 🚀 Phase 4: CI/CD Architecture Upgrade

---

## Old (Monolith)

* Single pipeline
* One deployment

## New (Microservices)

* Pipeline per service
* Independent deployment
* Independent versioning

Example GitHub Actions:

```yaml
on:
  push:
    paths:
      - "auth-service/**"
```

Only build changed service.

---

# 🧩 Phase 5: Introduce Service Mesh (Optional Advanced)

Use:

* Istio
* Linkerd

Benefits:

* Traffic splitting
* mTLS
* Observability
* Canary deploys

---

# 📊 Phase 6: Observability & Monitoring

Mandatory before scaling microservices:

* Prometheus
* Grafana
* Distributed tracing (Jaeger)
* Central logging (ELK)

Example tracing:

```
User → API Gateway → Auth → Order → Payment
```

Without tracing → debugging nightmare.

---

# 🔒 Phase 7: Production Hardening

---

## ✅ 1️⃣ Implement Circuit Breakers

Prevents cascading failure.

---

## ✅ 2️⃣ Add Resource Limits

```yaml
resources:
  requests:
    cpu: 200m
  limits:
    cpu: 500m
```

---

## ✅ 3️⃣ Add HPA

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
```

---

## ✅ 4️⃣ Secure with RBAC & Network Policies

```yaml
kind: NetworkPolicy
```

---

# 📋 Migration Roadmap (Realistic Timeline)

| Phase                 | Timeline     |
| --------------------- | ------------ |
| Containerize monolith | 2–4 weeks    |
| Deploy to K8s         | 2 weeks      |
| Extract 1st service   | 4–6 weeks    |
| Add API gateway       | Parallel     |
| Gradual extraction    | 6–12 months  |
| Full decomposition    | 12–18 months |

Never a 2-month project.

---

# ⚠️ Risks to Manage

* Distributed system complexity
* Data consistency issues
* Increased operational overhead
* Latency between services
* Dev team readiness

---

# 🔥 Anti-Patterns

* ❌ Big-bang rewrite
* ❌ Shared database forever
* ❌ No observability
* ❌ Too many tiny services
* ❌ Ignoring DevOps maturity

---

# 📈 Target Architecture (Final State)

```
Route53
   ↓
ALB / Ingress
   ↓
API Gateway
   ↓
Microservices (independent)
   ↓
DB per service
   ↓
Shared Observability Stack
```

---

# 💡 In Short (Interview Quick Recall)

* Containerize monolith first
* Use Strangler Pattern
* Extract services incrementally
* Separate databases gradually
* Build strong CI/CD & observability

👉 Monolith → Microservices is a **gradual, controlled architectural evolution**, not a rewrite project.

---
## Q16: Your AWS bill doubled unexpectedly this month. How do you identify the cause and prevent it from happening again?

---

### 🧠 Overview

If AWS bill suddenly doubled:

> Assume misconfiguration, scaling issue, or abuse — not randomness.

Most common causes:

* Auto-scaling misfire
* Orphaned resources
* Data transfer spike
* NAT Gateway costs
* EBS / snapshot growth
* RDS storage autoscaling
* Exposed credentials (crypto mining)

Goal:

1. Identify cost driver quickly
2. Stop bleeding immediately
3. Prevent recurrence with guardrails

---

# 🔍 Phase 1: Identify Where the Cost Increased

---

## 1️⃣ Use Cost Explorer

CLI:

```bash
aws ce get-cost-and-usage \
  --time-period Start=2026-02-01,End=2026-02-28 \
  --granularity DAILY \
  --metrics "UnblendedCost" \
  --group-by Type=DIMENSION,Key=SERVICE
```

Look for:

* EC2?
* RDS?
* Data Transfer?
* NAT Gateway?
* S3?
* EKS?

---

## 2️⃣ Compare Month-over-Month

Check:

* Daily trend
* Service breakdown
* Region breakdown

---

# 🧩 Common Cost Spike Scenarios

---

# 🔥 Scenario 1: EC2 / EKS Node Explosion

Check EC2:

```bash
aws ec2 describe-instances \
  --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name]'
```

Check Auto Scaling:

```bash
aws autoscaling describe-auto-scaling-groups
```

Possible causes:

* HPA misconfigured
* Infinite scaling loop
* Test environment left running
* Cluster Autoscaler max set too high

---

### Immediate Fix

Reduce capacity:

```bash
aws autoscaling update-auto-scaling-group \
  --auto-scaling-group-name prod-ng \
  --desired-capacity 5
```

---

# 🔥 Scenario 2: NAT Gateway Data Transfer

NAT Gateway can cost heavily.

Check:

* Data transfer out
* Cross-AZ traffic

Solution:

* Use VPC endpoints (S3, DynamoDB)
* Reduce cross-AZ calls
* Consolidate NAT

---

# 🔥 Scenario 3: Data Transfer Spike

Check:

```bash
aws ce get-cost-and-usage --group-by Type=DIMENSION,Key=USAGE_TYPE
```

Look for:

* DataTransfer-Out-Bytes
* Inter-AZ traffic

Common reason:

* Large S3 downloads
* Logs exported externally
* Misconfigured backup jobs

---

# 🔥 Scenario 4: RDS Storage / IOPS

Check:

```bash
aws rds describe-db-instances
```

Possible issues:

* Storage autoscaling triggered
* Provisioned IOPS too high
* Large snapshot accumulation

---

# 🔥 Scenario 5: S3 Growth

Check bucket size:

```bash
aws s3 ls s3://bucket-name --recursive --summarize
```

Common causes:

* Log retention not configured
* CI artifacts stored indefinitely
* Backup duplication

---

# 🔥 Scenario 6: Compromised Credentials (Critical)

If EC2 GPU instances launched unexpectedly:

Check CloudTrail:

```bash
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=RunInstances
```

Look for:

* Unknown IP
* Unusual regions

Immediate action:

* Rotate keys
* Disable compromised IAM user
* Terminate suspicious instances

---

# 📊 Cost Breakdown Table

| Service       | Common Cause                 |
| ------------- | ---------------------------- |
| EC2           | Scaling misconfig            |
| EKS           | Node group expansion         |
| NAT Gateway   | High data transfer           |
| RDS           | Storage/IOPS                 |
| S3            | No lifecycle policy          |
| Data Transfer | Cross-AZ or internet traffic |

---

# 🛠 Phase 2: Stop Immediate Cost Leak

| Problem           | Action                |
| ----------------- | --------------------- |
| Over-scaled nodes | Reduce ASG capacity   |
| Unused instances  | Terminate             |
| Large S3 bucket   | Enable lifecycle      |
| NAT cost          | Add VPC endpoints     |
| Idle RDS          | Resize                |
| Orphan EBS        | Delete unused volumes |

---

# 🔒 Phase 3: Prevent Recurrence

---

## ✅ 1️⃣ Enable AWS Budgets

```bash
aws budgets create-budget ...
```

Alert at:

* 80%
* 100%
* 120%

---

## ✅ 2️⃣ Enable Cost Anomaly Detection

AWS → Cost Anomaly Detection → Configure monitor

Detects sudden spikes automatically.

---

## ✅ 3️⃣ Tag Everything

Enforce tagging policy:

```json
{
  "CostCenter": "prod",
  "Environment": "production"
}
```

Allows cost allocation visibility.

---

## ✅ 4️⃣ Set ASG Scaling Limits

Never leave:

```json
"MaxSize": 1000
```

Use realistic limits.

---

## ✅ 5️⃣ Use Reserved Instances / Savings Plans

For stable workloads.

---

## ✅ 6️⃣ Implement Cleanup Automation

Lambda job:

* Delete unattached EBS
* Delete old snapshots
* Delete old AMIs

---

# 📋 Investigation Flow (Interview Style)

| Step | Action                                |
| ---- | ------------------------------------- |
| 1    | Check Cost Explorer                   |
| 2    | Identify top service increase         |
| 3    | Drill down by region & usage type     |
| 4    | Inspect scaling & resource count      |
| 5    | Check for credential abuse            |
| 6    | Implement budgets & anomaly detection |

---

# ⚠️ What NOT to Do

* ❌ Panic-delete resources blindly
* ❌ Ignore cross-AZ traffic
* ❌ Leave test environments running
* ❌ Avoid tagging

---

# 💡 In Short (Interview Quick Recall)

* Use Cost Explorer to find spike source
* Most common: EC2 scaling or data transfer
* Reduce capacity immediately
* Enable budgets + anomaly detection
* Enforce tagging and scaling limits

👉 Sudden AWS bill increase is almost always **auto-scaling misconfiguration, data transfer explosion, or credential misuse** — measure first, then fix systematically.

---
## Q17: You need to migrate a large on-premises database to AWS with less than 1 hour of downtime. How do you approach this?

---

### 🧠 Overview

Migrating a **large on-prem DB → AWS** with < 1 hour downtime requires:

> Continuous replication + short final cutover window.

You do NOT:

* Take full backup → restore → wait (too slow)
* Do big-bang migration

Correct approach:

1. Initial full load
2. Continuous Change Data Capture (CDC)
3. Short cutover freeze
4. DNS/app switch

Goal:

* Data consistency
* Minimal downtime
* Validated rollback plan

---

# 🏗 High-Level Migration Architecture

```
On-Prem DB
     ↓
AWS DMS (Replication Instance)
     ↓
AWS RDS / Aurora
```

Tools:

* AWS DMS (Database Migration Service)
* Native replication (MySQL/Postgres logical replication)
* Backup + restore (only for small DBs)

---

# 🚀 Phase 1: Pre-Migration Planning

---

## 🔍 1️⃣ Assess Database

Check:

* DB size
* Write rate (TPS)
* Large tables
* Stored procedures
* Extensions compatibility

---

## 🔍 2️⃣ Choose Target

Options:

| Option           | Use Case           |
| ---------------- | ------------------ |
| RDS              | Standard migration |
| Aurora           | High scalability   |
| EC2 self-managed | Complex custom DB  |
| RDS Multi-AZ     | HA requirement     |

---

## 🔍 3️⃣ Network Connectivity

Options:

* VPN
* Direct Connect (preferred for large DB)
* Secure replication tunnel

Ensure low-latency stable link.

---

# 🔄 Phase 2: Continuous Replication Setup

---

## 🔹 1️⃣ Create Target DB

Example (RDS):

```bash
aws rds create-db-instance \
  --db-instance-identifier prod-db \
  --engine postgres \
  --multi-az \
  --allocated-storage 500
```

---

## 🔹 2️⃣ Configure AWS DMS

Create replication instance:

```bash
aws dms create-replication-instance \
  --replication-instance-class dms.r5.large
```

---

## 🔹 3️⃣ Create Source & Target Endpoints

```bash
aws dms create-endpoint --endpoint-type source
aws dms create-endpoint --endpoint-type target
```

---

## 🔹 4️⃣ Enable CDC Mode

DMS Task:

* Full load + ongoing replication

This:

* Copies entire DB
* Then streams live changes

Downtime = 0 during sync phase.

---

# 📊 Phase 3: Monitor Replication Lag

Critical metric:

* `CDCLatencySource`
* `CDCLatencyTarget`

Ensure replication lag = near zero before cutover.

---

# 🔥 Phase 4: Cutover Strategy (<1 Hour Downtime)

---

## Step 1️⃣ Announce Maintenance Window

Switch application to:

* Read-only mode
* Or disable writes

---

## Step 2️⃣ Stop Application Writes

Prevent new transactions.

---

## Step 3️⃣ Wait for Replication Catch-Up

Check DMS lag = 0 seconds.

---

## Step 4️⃣ Final Validation

* Row counts
* Checksums
* Critical queries

---

## Step 5️⃣ Switch Application DB Endpoint

Update:

* RDS endpoint
* Kubernetes secret

```bash
kubectl create secret generic db-secret \
  --from-literal=DB_HOST=new-rds-endpoint
```

Restart pods:

```bash
kubectl rollout restart deployment/app -n prod
```

---

## Step 6️⃣ Monitor Closely

* Query performance
* Error rate
* Connection count

Downtime typically: 10–30 minutes.

---

# 🔄 Rollback Plan (Critical)

Keep:

* On-prem DB running
* Replication paused, not deleted

If failure:

* Re-point app back to on-prem
* Resume traffic

Always test rollback beforehand.

---

# 📦 Special Cases

---

## 🔹 Large Databases (TBs)

Use:

* Parallel load
* Table partition migration
* Pre-warm indexes

---

## 🔹 Zero Downtime Migration (Advanced)

Use:

* Dual-write pattern
* Or bidirectional replication temporarily

Complex but near-zero downtime.

---

# 🔒 Production Best Practices

---

## ✅ 1️⃣ Dry Run Migration in Staging

Simulate full process.

---

## ✅ 2️⃣ Validate Schema Compatibility

Check:

* Data types
* Collation
* Extensions

---

## ✅ 3️⃣ Tune RDS Parameters

Match on-prem settings:

* max_connections
* shared_buffers
* innodb_buffer_pool_size

---

## ✅ 4️⃣ Enable Multi-AZ in AWS

Avoid migrating into single point of failure.

---

## ✅ 5️⃣ Load Test Before Switching

Ensure AWS DB handles expected traffic.

---

# 📋 Migration Timeline Example

| Phase             | Duration     |
| ----------------- | ------------ |
| Initial full load | Hours / Days |
| CDC sync          | Continuous   |
| Final cutover     | 15–45 mins   |
| Monitoring        | 24–48 hours  |

---

# ⚠️ What NOT to Do

* ❌ Big-bang restore during downtime
* ❌ Skip replication lag monitoring
* ❌ Ignore rollback plan
* ❌ Migrate without load testing

---

# 💡 In Short (Interview Quick Recall)

* Use AWS DMS with CDC
* Sync continuously before cutover
* Freeze writes briefly
* Switch endpoint
* Keep rollback ready

👉 Large DB migration with <1 hour downtime = **replicate first, switch later**, never copy during downtime window.

----
## Q18: Your entire AWS us-east-1 region is experiencing an outage. How does your architecture handle this?

---

### 🧠 Overview

If an entire AWS region (e.g., **us-east-1**) is down:

> AZ redundancy is NOT enough.
> You need Multi-Region architecture.

This is a **Disaster Recovery (DR)** scenario.

Your design must already include:

* Cross-region infrastructure
* Cross-region data replication
* Automated failover
* Tested DR runbooks

Goal:

1. Maintain availability
2. Protect data
3. Fail over with minimal downtime

---

# 🏗 Production-Grade Multi-Region Architecture

```
                Route53 (Health Check + Failover)
                        ↓
         ┌─────────────────────────────┐
         │                             │
     us-east-1 (Primary)         us-west-2 (Secondary)
         │                             │
      ALB + EKS                      ALB + EKS
         │                             │
      RDS (Primary)            RDS Read Replica / Global DB
```

---

# 🔁 Strategy Options (DR Models)

---

# 🔹 1️⃣ Backup & Restore (Lowest Cost)

* Only backups stored cross-region
* Manual restore in secondary

⏱ RTO: Hours
📉 RPO: Minutes–Hours

Not suitable for critical systems.

---

# 🔹 2️⃣ Pilot Light

* Core infra running in secondary
* App scaled down

Failover = scale up + switch DNS.

⏱ RTO: 30–60 mins
📉 RPO: Low

---

# 🔹 3️⃣ Warm Standby (Recommended for Critical Systems)

* Full stack running in secondary
* Smaller capacity
* Near real-time DB replication

Failover = DNS switch.

⏱ RTO: 5–15 mins
📉 RPO: Seconds

---

# 🔹 4️⃣ Active-Active (Highest Availability)

* Both regions serving traffic
* Global load balancing

⏱ RTO: Near zero
📉 RPO: Near zero

More complex and expensive.

---

# 🚀 How Architecture Handles Region Outage

---

# 1️⃣ DNS Failover (Route53)

Health checks:

```bash
aws route53 create-health-check ...
```

Failover routing policy:

* Primary record → us-east-1
* Secondary record → us-west-2

If primary fails → traffic shifts automatically.

---

# 2️⃣ Kubernetes in Secondary Region

EKS cluster pre-provisioned via Terraform:

```hcl
module "eks_secondary" {
  region = "us-west-2"
}
```

Infra already exists.

---

# 3️⃣ Database Replication

Options:

### 🔹 RDS Cross-Region Read Replica

```bash
aws rds create-db-instance-read-replica \
  --source-db-instance-identifier prod-db
```

Promote on failover:

```bash
aws rds promote-read-replica
```

---

### 🔹 Aurora Global Database (Better)

* Multi-region replication
* Faster failover

---

### 🔹 DynamoDB Global Tables

Auto multi-region replication.

---

# 4️⃣ S3 Cross-Region Replication

```bash
aws s3api put-bucket-replication ...
```

Ensures object availability.

---

# 5️⃣ Container Images (ECR Replication)

Enable ECR cross-region replication.

Prevents image pull failure.

---

# 📋 Failover Execution Flow

| Step | Action                  |
| ---- | ----------------------- |
| 1    | Detect regional outage  |
| 2    | Promote DB replica      |
| 3    | Scale secondary cluster |
| 4    | Route53 shifts traffic  |
| 5    | Monitor stability       |
| 6    | Communicate status      |

---

# 🔄 After Primary Region Recovery

* Decide failback strategy
* Sync data
* Gradually shift traffic back

Never flip instantly without validation.

---

# 🔒 Production Best Practices

---

## ✅ 1️⃣ Infrastructure as Code in Both Regions

Terraform example:

```hcl
provider "aws" {
  alias  = "secondary"
  region = "us-west-2"
}
```

---

## ✅ 2️⃣ Automated DR Testing

Quarterly game-day exercises.

Simulate region failure.

---

## ✅ 3️⃣ Separate State Stores

Avoid single-region dependencies like:

* Single S3 backend
* Single Redis
* Single Kafka cluster

---

## ✅ 4️⃣ Global Monitoring

Use external monitoring (Datadog, NewRelic).

If monitoring is only in us-east-1 → blind during outage.

---

## ✅ 5️⃣ Define RTO & RPO Clearly

| System Type   | RTO      | RPO     |
| ------------- | -------- | ------- |
| Banking       | <5 min   | <1 min  |
| SaaS app      | <30 min  | <5 min  |
| Internal tool | <4 hours | <30 min |

Design based on business need.

---

# ⚠️ What NOT to Do

* ❌ Rely only on Multi-AZ
* ❌ Store Terraform state in single region
* ❌ Assume AWS never fails region-wide
* ❌ Skip DR testing

---

# 💡 In Short (Interview Quick Recall)

* Multi-AZ ≠ Multi-Region
* Use cross-region replication
* Route53 health-based failover
* Promote replica and shift traffic
* Regularly test DR

👉 Region outage resilience requires **pre-built multi-region architecture**, not last-minute recovery steps.

---
## Q19: A Terraform apply accidentally destroyed production infrastructure. What is your recovery process?

---

### 🧠 Overview

If `terraform apply` destroyed production infra:

> Treat it as SEV-1 incident.

Root causes usually:

* Wrong workspace
* Wrong backend
* `terraform destroy` misuse
* State file corruption
* Missing state lock
* Drift between state & actual infra

Goal:

1. Stop further damage
2. Restore infrastructure fast
3. Recover state safely
4. Prevent recurrence

---

# 🚨 Phase 1: Immediate Containment

---

## 1️⃣ Stop All Terraform Activity

Disable CI pipeline immediately.

Revoke access temporarily if needed.

---

## 2️⃣ Identify Scope of Damage

Check:

* What resources destroyed?
* Entire VPC? Only ASG?
* DB affected?

Use:

```bash
terraform state list
```

Check CloudTrail for deletions:

```bash
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=Delete*
```

---

# 🔥 Phase 2: Check If Data Is Lost

Critical priority:

* RDS
* S3
* EBS
* DynamoDB

---

## 1️⃣ RDS Recovery

If RDS deleted but backup enabled:

```bash
aws rds restore-db-instance-to-point-in-time \
  --source-db-instance-identifier prod-db \
  --target-db-instance-identifier prod-db-restore \
  --restore-time 2026-02-14T10:00:00Z
```

---

## 2️⃣ EBS Snapshot Recovery

```bash
aws ec2 create-volume \
  --snapshot-id snap-xxxx \
  --availability-zone us-east-1a
```

---

## 3️⃣ S3 Versioning Recovery

If versioning enabled:

```bash
aws s3api list-object-versions --bucket prod-bucket
```

Restore previous version.

---

# 🔄 Phase 3: Restore Infrastructure

---

# 🔹 Scenario 1: State File Still Intact

If state backend (S3) exists:

```bash
terraform plan
terraform apply
```

Terraform will recreate destroyed resources.

---

# 🔹 Scenario 2: State Corrupted or Missing

Restore state from S3 versioning:

```bash
aws s3api list-object-versions --bucket terraform-state-bucket
```

Download previous version.

Replace state:

```bash
terraform init
terraform state push terraform.tfstate
```

---

# 🔹 Scenario 3: Entire Infra Destroyed

Reapply from clean state:

```bash
terraform init
terraform apply
```

Requires:

* Modular design
* Proper variable files
* No manual infra

---

# 📋 Recovery Flow Example

| Step | Action                      |
| ---- | --------------------------- |
| 1    | Stop pipelines              |
| 2    | Assess destroyed resources  |
| 3    | Recover databases first     |
| 4    | Restore infra via Terraform |
| 5    | Validate connectivity       |
| 6    | Re-enable traffic           |

---

# 🔎 Phase 4: Restore Application Traffic

If using:

* ALB
* Route53

Ensure:

```bash
aws elbv2 describe-target-health
```

Pods healthy:

```bash
kubectl get pods -n prod
```

Gradually restore traffic.

---

# 🔒 Phase 5: Root Cause Analysis

Check:

* Was wrong workspace used?

```bash
terraform workspace show
```

* Was prod backend misconfigured?
* Was state locking disabled?
* Was CI variable incorrect?

---

# 🛡 Prevent Recurrence

---

## ✅ 1️⃣ Use Remote Backend with Locking

Example:

```hcl
backend "s3" {
  bucket         = "terraform-prod-state"
  key            = "prod/terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "terraform-locks"
}
```

Prevents concurrent applies.

---

## ✅ 2️⃣ Use Separate AWS Accounts for Prod

Never share prod and staging account.

---

## ✅ 3️⃣ Use `-auto-approve` Carefully

Remove from prod pipeline.

Require manual approval.

---

## ✅ 4️⃣ Add `prevent_destroy`

For critical resources:

```hcl
lifecycle {
  prevent_destroy = true
}
```

Protects DB, VPC, etc.

---

## ✅ 5️⃣ CI Guardrails

In pipeline:

* `terraform plan` output must be reviewed
* Block destroy unless explicitly approved

Example:

```bash
terraform plan -detailed-exitcode
```

Fail if destroy detected.

---

## ✅ 6️⃣ Enable S3 Versioning for State

Prevents permanent loss.

---

# ⚠️ What NOT to Do

* ❌ Panic-run more Terraform commands
* ❌ Modify state manually without backup
* ❌ Ignore database backup strategy
* ❌ Use same workspace for all environments

---

# 📊 Common Root Causes

| Cause               | Example                               |
| ------------------- | ------------------------------------- |
| Wrong workspace     | Running prod in dev                   |
| State misconfigured | Local state instead of S3             |
| Manual drift        | Terraform deletes unmanaged resources |
| CI variable error   | Wrong AWS credentials                 |
| No locking          | Parallel apply collision              |

---

# 💡 In Short (Interview Quick Recall)

* Stop further changes immediately
* Restore data first (RDS, S3, EBS)
* Reapply infra using state or restore state backup
* Add prevent_destroy + locking
* Enforce CI approval gates

👉 Terraform destroying prod is a **process failure**, not just technical — fix guardrails after recovery.

----
## Q20: You need to provision identical infrastructure across 50 AWS accounts automatically. How do you design this?

---

### 🧠 Overview

Provisioning identical infra across **50 AWS accounts** requires:

> Centralized governance + automated multi-account orchestration.

You do NOT:

* Manually run Terraform 50 times
* Share one IAM user across accounts
* Copy-paste configs

Correct approach:

1. Use **AWS Organizations**
2. Use **centralized IaC (Terraform)**
3. Use **cross-account IAM roles**
4. Use **automation pipeline**

Goal:

* Consistency
* Security
* Scalability
* Auditability

---

# 🏗 High-Level Architecture

```
AWS Organizations
        ↓
Management Account (CI/CD + Terraform)
        ↓ (AssumeRole)
Member Accounts (50)
        ↓
Provisioned Infrastructure
```

---

# 🚀 Step 1: AWS Organizations Setup

---

## Use AWS Organizations

Create:

* Organizational Units (OUs)
* Separate accounts per environment

Example:

```
Root
 ├── Prod OU
 ├── Dev OU
 ├── Sandbox OU
```

---

# 🔐 Step 2: Cross-Account Role Setup

Each member account has a role:

```json
{
  "RoleName": "TerraformExecutionRole",
  "AssumeRolePolicyDocument": {
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::<management-account-id>:root"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
}
```

Terraform assumes role dynamically.

---

# 🧱 Step 3: Terraform Multi-Account Design

---

## 🔹 Provider with Assume Role

```hcl
provider "aws" {
  alias  = "account1"
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::123456789012:role/TerraformExecutionRole"
  }
}
```

---

## 🔹 Dynamic Account Loop

```hcl
variable "accounts" {
  type = list(string)
}

provider "aws" {
  for_each = toset(var.accounts)

  alias  = each.key
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${each.key}:role/TerraformExecutionRole"
  }
}
```

---

# 🔄 Step 4: Use Terraform Modules

Reusable module:

```hcl
module "vpc" {
  source = "./modules/vpc"

  providers = {
    aws = aws.account1
  }

  cidr_block = "10.0.0.0/16"
}
```

Apply same module to all accounts.

---

# 🔥 Step 5: CI/CD Automation

Pipeline (Jenkins/GitHub Actions):

```groovy
stage('Terraform Apply') {
    steps {
        sh 'terraform init'
        sh 'terraform apply -auto-approve'
    }
}
```

Pipeline runs:

* For each account
* Or using dynamic providers

---

# 🛡 State Management Strategy

---

## Option 1️⃣: Separate State per Account (Recommended)

S3 backend key structure:

```hcl
key = "prod/account-123/terraform.tfstate"
```

Ensures isolation.

---

## Option 2️⃣: Terraform Cloud (Enterprise Scale)

Benefits:

* Centralized state
* RBAC
* Policy enforcement (Sentinel)

---

# 🔒 Governance & Control

---

## ✅ 1️⃣ Use SCPs (Service Control Policies)

Prevent:

* Root user misuse
* Unapproved regions
* Dangerous services

---

## ✅ 2️⃣ Enforce Tagging

Terraform:

```hcl
default_tags {
  tags = {
    Environment = "production"
  }
}
```

---

## ✅ 3️⃣ Central Logging

All accounts send:

* CloudTrail → Central S3
* GuardDuty → Security account

---

# 📊 Design Options Comparison

| Approach                 | Scale      | Control   | Complexity |
| ------------------------ | ---------- | --------- | ---------- |
| Manual Terraform         | Low        | Low       | Low        |
| Multi-provider Terraform | Medium     | High      | Medium     |
| Terraform Cloud          | High       | Very High | Medium     |
| AWS Control Tower        | Enterprise | High      | Medium     |

---

# 🏢 Enterprise-Grade Architecture (Best Practice)

Use:

* AWS Control Tower
* Terraform modules
* Central CI/CD
* Role assumption
* Separate state per account

---

# ⚠️ What NOT to Do

* ❌ Use same IAM user for all accounts
* ❌ Share same Terraform state
* ❌ Hardcode account IDs
* ❌ Allow manual drift

---

# 📋 Execution Flow

| Step | Action                            |
| ---- | --------------------------------- |
| 1    | Create accounts via Organizations |
| 2    | Create cross-account IAM role     |
| 3    | Setup Terraform remote backend    |
| 4    | Use reusable modules              |
| 5    | Automate via CI/CD                |
| 6    | Monitor and enforce policies      |

---

# 💡 In Short (Interview Quick Recall)

* Use AWS Organizations
* Assume cross-account roles
* Use reusable Terraform modules
* Separate state per account
* Automate via centralized pipeline

👉 Multi-account provisioning at scale = **Organizations + AssumeRole + Terraform modules + centralized automation**.

---
## Q21: A security audit found that 60% of your EC2 instances have publicly exposed ports. How do you remediate this at scale?

---

### 🧠 Overview

60% of EC2 instances exposing public ports = **critical security posture failure**.

This usually means:

* Security Groups allow `0.0.0.0/0`
* Instances have public IPs unnecessarily
* No centralized governance
* Drift from IaC
* Lack of guardrails (SCP, Config rules)

Goal:

1. Identify exposed ports quickly
2. Reduce exposure immediately
3. Enforce centralized network design
4. Prevent recurrence

This is not a “patch one server” problem — it’s a **governance + architecture problem**.

---

# 🚨 Phase 1: Identify All Publicly Exposed Instances

---

## 1️⃣ Find Security Groups with Open Ingress

```bash
aws ec2 describe-security-groups \
  --query "SecurityGroups[?IpPermissions[?IpRanges[?CidrIp=='0.0.0.0/0']]]"
```

Look for:

* Port 22 (SSH)
* Port 3389 (RDP)
* Port 80/443 (if not behind ALB)
* Custom app ports

---

## 2️⃣ Identify Instances with Public IP

```bash
aws ec2 describe-instances \
  --query "Reservations[*].Instances[?PublicIpAddress!=null].[InstanceId,PublicIpAddress]"
```

Combine both findings.

---

# 🔥 Phase 2: Immediate Risk Mitigation

---

# 🔹 Scenario A: SSH / RDP Open to World

Replace with SSM Session Manager.

---

### Step 1️⃣ Remove Public Ingress

```bash
aws ec2 revoke-security-group-ingress \
  --group-id sg-xxxx \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0
```

---

### Step 2️⃣ Use AWS SSM Instead of SSH

Attach IAM role:

```json
{
  "Effect": "Allow",
  "Action": [
    "ssm:StartSession"
  ],
  "Resource": "*"
}
```

Access:

```bash
aws ssm start-session --target i-xxxx
```

No public SSH needed.

---

# 🔹 Scenario B: Applications Directly Exposed

Proper architecture:

```
Internet → ALB → Private EC2
```

Steps:

1. Remove public IP from instances
2. Move instances to private subnets
3. Expose only ALB publicly

---

## Remove Public IP

```bash
aws ec2 modify-instance-attribute \
  --instance-id i-xxxx \
  --no-source-dest-check
```

(Or relaunch without public IP)

---

# 🔁 Phase 3: Fix at Scale (Automated)

---

# 🔹 1️⃣ Use AWS Config Rule

Enable managed rule:

```
INCOMING_SSH_DISABLED
```

Auto-detect and flag violations.

---

# 🔹 2️⃣ Use AWS Firewall Manager

Centralized SG policy enforcement across accounts.

---

# 🔹 3️⃣ Use SCP to Block Public Ports

Example SCP:

```json
{
  "Effect": "Deny",
  "Action": "ec2:AuthorizeSecurityGroupIngress",
  "Condition": {
    "IpAddress": {
      "ec2:SourceIp": "0.0.0.0/0"
    }
  }
}
```

Prevents future public exposure.

---

# 🔹 4️⃣ Terraform Guardrail

Add validation:

```hcl
variable "allowed_cidr" {
  validation {
    condition     = var.allowed_cidr != "0.0.0.0/0"
    error_message = "Public access is not allowed."
  }
}
```

---

# 🔹 5️⃣ Run Bulk Remediation Script

Example script:

```bash
for sg in $(aws ec2 describe-security-groups \
  --query "SecurityGroups[?IpPermissions[?IpRanges[?CidrIp=='0.0.0.0/0']]].GroupId" \
  --output text); do
  aws ec2 revoke-security-group-ingress --group-id $sg ...
done
```

Run in controlled manner (non-prod first).

---

# 🔒 Phase 4: Redesign Network Architecture

---

## Target Architecture

```
Public Subnet:
  - ALB
  - NAT Gateway

Private Subnet:
  - EC2
  - RDS
  - Internal services
```

Principles:

* No direct public IP on app servers
* Bastionless architecture (SSM)
* Only load balancers exposed

---

# 📊 Risk Categorization

| Port             | Risk Level | Action             |
| ---------------- | ---------- | ------------------ |
| 22               | Critical   | Remove immediately |
| 3389             | Critical   | Remove             |
| 80/443           | Medium     | Allow only via ALB |
| Custom App Ports | High       | Restrict CIDR      |

---

# 🛡 Preventive Controls

---

## ✅ 1️⃣ Enforce Private Subnets by Default

Disable auto-assign public IP.

---

## ✅ 2️⃣ Mandatory IaC

No manual console security group changes.

---

## ✅ 3️⃣ Continuous Security Scanning

Use:

* AWS Security Hub
* Prowler
* ScoutSuite

---

## ✅ 4️⃣ Network Segmentation

Use:

* Security Groups
* NACLs
* Network Policies (if EKS)

---

## ✅ 5️⃣ Zero Trust Model

No open inbound traffic unless required.

---

# ⚠️ What NOT to Do

* ❌ Remove rules blindly in production without traffic validation
* ❌ Break live services
* ❌ Assume port 80 is always safe
* ❌ Leave manual access paths

---

# 📋 Remediation Strategy Summary

| Step | Action                      |
| ---- | --------------------------- |
| 1    | Identify exposed SGs        |
| 2    | Remove SSH/RDP from public  |
| 3    | Replace with SSM            |
| 4    | Move EC2 to private subnets |
| 5    | Enforce SCP + Config rules  |
| 6    | Automate detection          |

---

# 💡 In Short (Interview Quick Recall)

* Identify SGs allowing `0.0.0.0/0`
* Remove public SSH/RDP
* Use SSM instead of SSH
* Move EC2 to private subnets
* Enforce SCP + Config guardrails

👉 60% exposure means **architecture and governance failure**, not just misconfiguration — fix at policy level, not instance level.

---
## Q22: GuardDuty detected unusual API calls being made from an IAM role at 3 AM. What is your incident response?

---

### 🧠 Overview

Unusual API activity from an IAM role at 3 AM = **possible credential compromise or abuse**.

Could be:

* Stolen temporary credentials
* SSRF attack (EC2 metadata abuse)
* CI/CD token leak
* Privilege escalation attempt
* Crypto mining setup

Principle:

> Contain first. Investigate second. Preserve evidence.

Goal:

1. Stop malicious activity immediately
2. Determine scope of compromise
3. Prevent lateral movement
4. Harden IAM posture

---

# 🚨 Phase 1: Immediate Containment (First 5–10 Minutes)

---

## 1️⃣ Identify the IAM Role

From GuardDuty finding:

* Role ARN
* Source IP
* API calls
* Region

---

## 2️⃣ Disable the Role Temporarily

Fastest safe containment:

### Option A: Detach Policies

```bash
aws iam detach-role-policy \
  --role-name suspicious-role \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
```

---

### Option B: Add Explicit Deny Policy

```json
{
  "Effect": "Deny",
  "Action": "*",
  "Resource": "*"
}
```

Attach immediately.

Stops active abuse without deleting role.

---

## 3️⃣ If EC2 Role → Isolate Instance

If role attached to EC2:

```bash
aws ec2 modify-instance-attribute \
  --instance-id i-xxxx \
  --groups sg-quarantine
```

Or:

* Remove from load balancer
* Restrict outbound traffic

---

# 🔍 Phase 2: Investigate the Activity

---

## 1️⃣ Check CloudTrail Logs

```bash
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=Username,AttributeValue=suspicious-role
```

Look for:

* `CreateUser`
* `AttachRolePolicy`
* `RunInstances`
* `PutBucketPolicy`
* `CreateAccessKey`

Red flags:

* IAM changes
* New admin users
* GPU instance launches

---

## 2️⃣ Check Source IP

Was it:

* Known corporate IP?
* Unknown external IP?
* Foreign country?

If unknown → high probability compromise.

---

## 3️⃣ Check for Resource Creation

```bash
aws ec2 describe-instances
aws iam list-users
aws iam list-access-keys
```

Look for:

* Backdoor accounts
* Suspicious instances
* Crypto mining patterns

---

# 🔥 Phase 3: Eradication

---

## 🔹 1️⃣ Rotate Credentials

If IAM user involved:

```bash
aws iam update-access-key --status Inactive
```

Delete and recreate.

If EC2 role abused:

* Recreate role
* Reattach minimal permissions

---

## 🔹 2️⃣ Remove Backdoors

Delete:

* Suspicious IAM users
* Unknown policies
* Malicious EC2 instances

---

## 🔹 3️⃣ Check for Persistence Mechanisms

Attackers often:

* Modify bucket policies
* Add IAM trust relationships
* Create new roles
* Modify CloudTrail

Verify:

```bash
aws iam list-roles
aws s3api get-bucket-policy
```

---

# 🛡 Phase 4: Root Cause Analysis

Possible attack vectors:

| Vector               | Example                       |
| -------------------- | ----------------------------- |
| SSRF                 | App exposed EC2 metadata      |
| Leaked token         | Code pushed to GitHub         |
| CI/CD breach         | Exposed GitHub Actions secret |
| Over-permissive role | `*:*` permissions             |
| No MFA               | IAM user login                |

---

# 🔒 Phase 5: Harden the Environment

---

## ✅ 1️⃣ Enable GuardDuty Organization-Wide

Cover all accounts.

---

## ✅ 2️⃣ Restrict IAM Role Permissions

Avoid:

```json
"Action": "*"
```

Use least privilege.

---

## ✅ 3️⃣ Enforce IMDSv2

Prevent metadata theft:

```bash
aws ec2 modify-instance-metadata-options \
  --http-tokens required
```

---

## ✅ 4️⃣ Enable SCP to Prevent Dangerous APIs

Example deny:

```json
{
  "Effect": "Deny",
  "Action": "iam:CreateUser",
  "Resource": "*"
}
```

---

## ✅ 5️⃣ Enable CloudTrail in All Regions

Ensure logging cannot be disabled.

---

## ✅ 6️⃣ Enable AWS Security Hub + Config

Central visibility.

---

# 📋 Incident Response Timeline

| Step | Action                     |
| ---- | -------------------------- |
| 1    | Disable role               |
| 2    | Isolate instance           |
| 3    | Review CloudTrail          |
| 4    | Remove malicious resources |
| 5    | Rotate credentials         |
| 6    | Harden IAM                 |
| 7    | Postmortem                 |

---

# ⚠️ What NOT to Do

* ❌ Immediately delete role without investigating
* ❌ Ignore possible lateral movement
* ❌ Skip credential rotation
* ❌ Disable logging accidentally

---

# 💡 In Short (Interview Quick Recall)

* Contain role immediately
* Investigate via CloudTrail
* Remove malicious resources
* Rotate credentials
* Harden IAM + enforce least privilege

👉 Unusual API activity at odd hours is almost always **credential compromise or abuse** — contain fast and audit thoroughly.

---
## Q23: Your company needs to achieve SOC2 compliance in 3 months. What DevSecOps processes do you implement?

---

### 🧠 Overview

SOC2 (Service Organization Control 2) focuses on:

* 🔐 Security
* 📦 Availability
* 🔎 Processing Integrity
* 🔒 Confidentiality
* 🧾 Privacy

For most SaaS companies, the primary focus is **Security + Availability**.

In 3 months, the goal is:

> Implement auditable controls + automate evidence collection.

This is not a documentation-only exercise — it's **process + automation + monitoring**.

---

# 🏗 Phase 1: Governance & Access Control (Weeks 1–3)

---

## 🔐 1️⃣ Enforce IAM Best Practices

### Implement:

* Least privilege IAM
* No root usage
* MFA mandatory
* Role-based access (no shared users)

Example IAM policy:

```json
{
  "Effect": "Allow",
  "Action": "s3:GetObject",
  "Resource": "arn:aws:s3:::prod-bucket/*"
}
```

---

## 🔹 2️⃣ SSO + Central Identity

Use:

* AWS IAM Identity Center
* Okta / Azure AD

Enforce:

* MFA
* Offboarding automation

---

## 🔹 3️⃣ Access Review Process

Quarterly review:

```bash
aws iam list-users
aws iam list-roles
```

Document approval evidence.

---

# 🛡 Phase 2: Infrastructure Security Controls (Weeks 2–6)

---

## 🔥 1️⃣ Infrastructure as Code Only

All infra must be Terraform.

Enable state locking:

```hcl
backend "s3" {
  bucket         = "tf-prod-state"
  dynamodb_table = "tf-lock"
}
```

---

## 🔥 2️⃣ Security Scanning in CI/CD

Add:

* SAST (SonarQube)
* SCA (Dependency-Check / Trivy)
* Container scanning
* Terraform scanning (tfsec, checkov)

Example pipeline step:

```bash
trivy image app:latest
```

Fail build on high severity.

---

## 🔥 3️⃣ Secrets Management

Replace:

* `.env` files
* Hardcoded secrets

Use:

* AWS Secrets Manager
* SSM Parameter Store

Never store secrets in Git.

---

# 🔎 Phase 3: Logging & Monitoring (Weeks 3–8)

---

## 🔹 1️⃣ Enable Organization-wide CloudTrail

All regions enabled.

Send logs to centralized S3.

---

## 🔹 2️⃣ Enable GuardDuty + Security Hub

Organization-level detection.

---

## 🔹 3️⃣ Centralized Logging

Use:

* ELK / OpenSearch
* CloudWatch Logs

Retention policy:

* 1 year minimum (based on policy)

---

## 🔹 4️⃣ Monitoring & Alerts

Prometheus / Datadog:

Alert on:

* High 5xx
* CPU spikes
* Unauthorized API calls

---

# 🔒 Phase 4: Application Security (Weeks 4–9)

---

## ✅ 1️⃣ Secure SDLC Process

Implement:

* PR reviews mandatory
* Code owner approvals
* No direct pushes to main

Example branch protection:

* Require 2 approvals
* Require passing CI

---

## ✅ 2️⃣ Dependency Management

Automate:

* Dependabot
* Snyk

---

## ✅ 3️⃣ Container Hardening

* Use minimal base images
* Run as non-root
* Add resource limits

```yaml
securityContext:
  runAsNonRoot: true
```

---

# 📦 Phase 5: Backup & Disaster Recovery

---

## 🔹 1️⃣ Automated Backups

* RDS automated backups
* S3 versioning enabled
* EBS snapshots scheduled

---

## 🔹 2️⃣ Disaster Recovery Plan

Document:

* RTO
* RPO
* Multi-region setup
* Failover process

Run DR test once before audit.

---

# 📋 Phase 6: Policies & Documentation

SOC2 requires documented controls:

* Access control policy
* Incident response policy
* Change management policy
* Backup policy
* Vendor risk policy

Create runbooks:

```
Incident Response Runbook
Terraform Deployment Runbook
Access Review SOP
```

Auditors check evidence, not theory.

---

# 🔁 Phase 7: Change Management Control

---

## CI/CD Enforcement

No manual production changes.

Pipeline:

```groovy
stage('Terraform Plan')
stage('Approval')
stage('Apply')
```

Require approval before production apply.

Log all changes.

---

# 📊 SOC2 Control Mapping (Technical)

| SOC2 Area         | DevSecOps Control               |
| ----------------- | ------------------------------- |
| Access Control    | IAM + MFA + SSO                 |
| Change Management | PR review + CI approval         |
| Monitoring        | CloudTrail + Alerts             |
| Data Protection   | Encryption at rest & in transit |
| Availability      | Multi-AZ + Backups              |
| Incident Response | Documented runbook              |

---

# 🔒 Critical Must-Haves for Audit

* MFA enforced
* Encryption enabled (RDS, S3)
* Backups verified
* Logging enabled
* No shared credentials
* Evidence of vulnerability scans
* Access review documentation

---

# 📆 3-Month Execution Timeline

| Month   | Focus                                   |
| ------- | --------------------------------------- |
| Month 1 | IAM + Logging + IaC enforcement         |
| Month 2 | CI/CD security + monitoring + backups   |
| Month 3 | Documentation + DR testing + audit prep |

---

# ⚠️ What NOT to Do

* ❌ Treat SOC2 as paperwork only
* ❌ Allow manual prod changes
* ❌ Skip logging centralization
* ❌ Ignore access review process
* ❌ Forget evidence collection

---

# 💡 In Short (Interview Quick Recall)

* Enforce IAM + MFA + SSO
* All infra via Terraform
* Add security scanning in CI/CD
* Enable CloudTrail + GuardDuty
* Document policies + collect evidence

👉 SOC2 readiness = **Security controls + automation + logging + documented processes**, not just compliance paperwork.

----
## Q24: A third-party dependency in your application has a critical CVE. You have 24 hours to patch 20 microservices. How do you handle this?

---

### 🧠 Overview

Critical CVE + 20 microservices + 24 hours = **coordinated security incident**.

Priorities:

1. Assess exploitability (is it reachable in your context?)
2. Prioritize internet-facing services
3. Patch fast but safely
4. Prove remediation to security team

This is not 20 manual fixes — it must be **automated and parallelized**.

---

# 🚨 Phase 1: Immediate Risk Assessment (Hour 0–2)

---

## 1️⃣ Understand the CVE

Identify:

* CVSS score
* Remote code execution?
* Requires authentication?
* Is it in runtime path or dev dependency?

---

## 2️⃣ Identify Affected Services

Run scan across repos:

Example (Trivy):

```bash
trivy fs .
```

Or container scan:

```bash
trivy image <image>
```

Generate list:

| Service | Version | Severity | Internet Facing? |
| ------- | ------- | -------- | ---------------- |

Prioritize public services first.

---

# 🔥 Phase 2: Containment Strategy (Hour 2–6)

---

## 🔹 Option A: Upgrade Dependency (Preferred)

Example (Maven):

```xml
<dependency>
  <version>2.3.4</version>
</dependency>
```

---

## 🔹 Option B: Override Transitive Dependency

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>...</groupId>
      <artifactId>...</artifactId>
      <version>patched-version</version>
    </dependency>
  </dependencies>
</dependencyManagement>
```

---

## 🔹 Option C: Base Image CVE (Container Issue)

If vulnerability in base image:

```dockerfile
FROM node:20-alpine
```

Upgrade:

```dockerfile
FROM node:20.10-alpine
```

Rebuild all images.

---

# ⚡ Phase 3: Automate the Patching (Hour 6–16)

---

## 🔁 1️⃣ Create Patch Branch Across Repos

Use script:

```bash
for repo in service1 service2 service3; do
  git checkout -b cve-patch
  # update dependency
  git commit -am "CVE-2026-XXXX patch"
  git push origin cve-patch
done
```

---

## 🔁 2️⃣ Trigger CI/CD in Parallel

Pipeline must:

* Run unit tests
* Build container
* Run vulnerability scan
* Deploy to staging

---

## 🔁 3️⃣ Parallel Deploy Strategy

Use:

* Canary deployment
* Rolling update

Example (K8s):

```yaml
strategy:
  rollingUpdate:
    maxUnavailable: 10%
    maxSurge: 10%
```

Deploy high-risk services first.

---

# 🔍 Phase 4: Validate Before Production

---

## 1️⃣ Confirm CVE No Longer Present

```bash
trivy image <new-image>
```

Ensure vulnerability gone.

---

## 2️⃣ Smoke Tests

Run:

* Health checks
* Core API flows
* Authentication

---

# 🚀 Phase 5: Production Deployment (Hour 16–22)

---

Deploy in waves:

| Priority | Service Type         |
| -------- | -------------------- |
| P1       | Internet-facing APIs |
| P2       | Internal services    |
| P3       | Batch jobs           |

Monitor:

```promql
rate(http_requests_total{status=~"5.."}[5m])
```

Abort if error spike.

---

# 🔒 Phase 6: Temporary Mitigation (If Patch Delayed)

If upgrade not possible:

* Disable vulnerable feature
* Add WAF rule
* Restrict access via firewall
* Add rate limiting

Example WAF block:

```bash
aws wafv2 update-web-acl ...
```

---

# 🛡 Phase 7: Post-Patch Hardening

---

## ✅ Enable Automated Dependency Updates

Use:

* Dependabot
* Renovate

---

## ✅ Enforce CI Failure on Critical CVEs

Example pipeline step:

```bash
trivy image --exit-code 1 --severity CRITICAL
```

---

## ✅ Maintain Central Dependency Versioning

If using Maven multi-module:

* Parent POM controls versions

Prevents 20 independent upgrades next time.

---

## ✅ Use Base Image Version Pinning

Avoid:

```dockerfile
FROM node:latest
```

Pin versions strictly.

---

# 📋 24-Hour Action Plan

| Time   | Action                   |
| ------ | ------------------------ |
| 0–2h   | Assess impact            |
| 2–6h   | Patch dependency         |
| 6–16h  | CI + staging validation  |
| 16–22h | Production rollout       |
| 22–24h | Verification & reporting |

---

# ⚠️ What NOT to Do

* ❌ Panic deploy without testing
* ❌ Ignore transitive dependencies
* ❌ Patch only some services
* ❌ Skip vulnerability re-scan

---

# 💡 In Short (Interview Quick Recall)

* Assess exploitability first
* Patch dependency centrally
* Automate parallel CI/CD
* Deploy in waves
* Enforce CVE scanning permanently

👉 Large-scale CVE remediation requires **automation + prioritization + controlled rollout**, not manual patching across services.

----
## Q25: Your Docker images have been running in production for 6 months with unpatched vulnerabilities. How do you fix this safely?

---

### 🧠 Overview

If production images are **6 months old**, assume:

* Base image CVEs accumulated
* OS packages outdated
* Language runtime vulnerable
* No automated rebuild policy

Goal:

> Rebuild safely, validate thoroughly, and prevent drift permanently.

This is a **controlled rebuild + phased rollout**, not `docker pull latest && deploy`.

---

# 🔍 Phase 1: Assess Risk & Scope

---

## 1️⃣ Scan Existing Images

Use Trivy:

```bash
trivy image <prod-image>
```

Focus on:

* CRITICAL
* HIGH

Categorize:

| Service | Critical CVEs | Internet-Facing? | Priority |
| ------- | ------------- | ---------------- | -------- |

Patch public-facing services first.

---

## 2️⃣ Identify Root Cause

Common reasons:

* `FROM ubuntu:20.04` not updated
* `apt-get update` missing
* No rebuild automation
* No image scanning gate

---

# 🔥 Phase 2: Rebuild Strategy (Safe Approach)

---

# 🔹 Step 1: Update Base Image

Bad:

```dockerfile
FROM node:18
```

Better:

```dockerfile
FROM node:18.19-alpine
```

Avoid `latest`.

---

# 🔹 Step 2: Rebuild With Clean Layer

If using OS packages:

```dockerfile
RUN apt-get update && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*
```

For Alpine:

```dockerfile
RUN apk update && apk upgrade
```

---

# 🔹 Step 3: Use Multi-Stage Builds

Reduce attack surface:

```dockerfile
FROM node:18-alpine AS builder
RUN npm install

FROM node:18-alpine
COPY --from=builder /app /app
```

Removes build tools from runtime.

---

# 🔁 Phase 3: Automated Bulk Rebuild

---

## Script to Rebuild All Services

```bash
for svc in service1 service2 service3; do
  docker build -t $svc:patched .
  docker push <ECR>/$svc:patched
done
```

Or trigger CI for all repos.

---

# 🔎 Phase 4: Validate Before Production

---

## 1️⃣ Re-Scan New Image

```bash
trivy image <patched-image>
```

Ensure critical CVEs removed.

---

## 2️⃣ Run Regression Tests

* Unit tests
* Integration tests
* Smoke tests

---

## 3️⃣ Deploy to Staging

```bash
kubectl set image deployment/app \
  app=<ECR>/app:patched -n staging
```

Monitor:

* CPU
* Memory
* Error rate

---

# 🚀 Phase 5: Controlled Production Rollout

---

## Rolling Update

```yaml
strategy:
  rollingUpdate:
    maxUnavailable: 10%
    maxSurge: 10%
```

Or canary deploy first.

Monitor:

```promql
rate(http_requests_total{status=~"5.."}[5m])
```

Rollback if error spike.

---

# 🔒 Phase 6: Prevent Future Drift

---

## ✅ 1️⃣ Implement Scheduled Image Rebuild

Even without code change:

* Weekly rebuild job
* Monthly forced rebuild

CI example:

```yaml
on:
  schedule:
    - cron: "0 3 * * 0"
```

---

## ✅ 2️⃣ Enforce CI Scan Gate

Fail build if:

```bash
trivy image --exit-code 1 --severity CRITICAL
```

---

## ✅ 3️⃣ Centralize Base Images

Maintain internal hardened base:

```dockerfile
FROM company/node-base:1.0
```

Patch base once → rebuild all apps.

---

## ✅ 4️⃣ Use Slim / Distroless Images

Example:

```dockerfile
FROM gcr.io/distroless/nodejs
```

Reduces vulnerability surface.

---

## ✅ 5️⃣ Enable ECR Scan on Push

```bash
aws ecr put-image-scanning-configuration \
  --scan-on-push
```

---

# 📊 Remediation Plan

| Phase | Action                   |
| ----- | ------------------------ |
| 1     | Scan existing images     |
| 2     | Update base images       |
| 3     | Rebuild & re-scan        |
| 4     | Deploy to staging        |
| 5     | Rollout to prod          |
| 6     | Implement rebuild policy |

---

# ⚠️ What NOT to Do

* ❌ Upgrade everything blindly without testing
* ❌ Deploy all services simultaneously
* ❌ Ignore transitive OS packages
* ❌ Continue using `latest`

---

# 💡 In Short (Interview Quick Recall)

* Scan images first
* Update base images
* Rebuild & re-scan
* Deploy via rolling update
* Automate recurring rebuilds

👉 Old Docker images are a **supply chain risk** — fix with controlled rebuild + CI scan gates + scheduled image refresh policy.

----
## Q26: Your monitoring system is generating 500 alerts per day and the team is experiencing alert fatigue. How do you fix this?

---

### 🧠 Overview

500 alerts/day = **monitoring system failure**, not system failure.

Alert fatigue causes:

* Ignored critical alerts
* Slower incident response
* Burnout
* Missed outages

Principle:

> Alert only on actionable signals.

Goal:

1. Reduce noise drastically
2. Prioritize true incidents
3. Improve signal-to-noise ratio
4. Maintain SLO-based alerting

---

# 🔍 Phase 1: Audit Existing Alerts

---

## 1️⃣ Categorize Alerts

Export alert data:

| Alert Type  | Count/Day | Action Taken? |
| ----------- | --------- | ------------- |
| CPU High    | 150       | No            |
| Pod Restart | 120       | Rare          |
| Disk Usage  | 80        | No            |
| 5xx Errors  | 50        | Yes           |

Identify:

* Which alerts triggered real action?
* Which alerts are ignored?

---

## 2️⃣ Identify Non-Actionable Alerts

Examples:

* CPU > 70% (normal)
* Pod restarted once
* Temporary spike alerts
* Duplicate alerts per pod

---

# 🔥 Phase 2: Implement SLO-Based Alerting

---

Instead of raw metrics, alert on **impact**.

Bad:

```promql
node_cpu_usage > 70%
```

Better:

```promql
rate(http_requests_total{status=~"5.."}[5m]) > 0.05
```

Alert on:

* Error rate
* Latency SLO breach
* Service unavailable

Not internal noise.

---

# 🔁 Phase 3: Add Alert Aggregation & Grouping

---

## Use Alertmanager Grouping

```yaml
group_by: ['alertname']
group_wait: 30s
group_interval: 5m
repeat_interval: 4h
```

Instead of 200 alerts:

* 1 aggregated alert

---

# 🔁 Phase 4: Add Threshold Stabilization

---

Avoid spike-based alerts.

Bad:

```promql
cpu_usage > 80%
```

Better:

```promql
avg_over_time(cpu_usage[10m]) > 85%
```

Add:

```
for: 10m
```

Only alert if sustained.

---

# 🔁 Phase 5: Use Multi-Level Severity

---

| Severity | When to Trigger           |
| -------- | ------------------------- |
| Critical | Service down / SLO breach |
| Warning  | Resource trending high    |
| Info     | Observability only        |

Only **Critical** pages on-call.

Warnings → Slack channel only.

---

# 🔁 Phase 6: Eliminate Duplicate Pod Alerts

Instead of per-pod:

Bad:

```promql
kube_pod_status_phase{phase="Failed"}
```

Better:

```promql
sum(kube_pod_status_phase{phase="Failed"}) > 5
```

Alert on cluster-level impact.

---

# 🔒 Phase 7: Implement Runbooks

Every alert must answer:

* What happened?
* Why?
* What action?

Example alert:

```
Service Error Rate > 5% for 10 mins
Runbook: https://wiki/runbooks/service-error
```

If no action defined → remove alert.

---

# 🔥 Phase 8: Introduce Alert Ownership

Each alert must have:

* Owner
* Review date
* Justification

Quarterly cleanup.

---

# 📊 Alert Optimization Strategy

| Problem               | Fix                            |
| --------------------- | ------------------------------ |
| Too many CPU alerts   | Alert on saturation, not usage |
| Frequent pod restarts | Alert only if > threshold      |
| Duplicate alerts      | Group by service               |
| Flapping alerts       | Add time window                |
| Infra noise           | Move to warning channel        |

---

# 🛡 Long-Term Monitoring Model

---

## Shift from Metric Alerts → SLO Alerts

Monitor:

* Availability
* Latency
* Error rate
* Saturation

Golden Signals model.

---

## Implement Error Budget Alerts

Alert only when burn rate high.

Example:

```promql
error_rate > 5% for 10m
```

---

## Use Synthetic Monitoring

Alert when:

* Real user experience impacted

Not when CPU is 75%.

---

# 📋 Cleanup Plan

| Week   | Action                       |
| ------ | ---------------------------- |
| Week 1 | Audit alerts                 |
| Week 2 | Remove non-actionable alerts |
| Week 3 | Implement grouping           |
| Week 4 | Introduce SLO alerts         |

Reduce 500/day → <20/day.

---

# ⚠️ What NOT to Do

* ❌ Disable all alerts
* ❌ Increase thresholds blindly
* ❌ Alert on every metric
* ❌ Page for warnings

---

# 💡 In Short (Interview Quick Recall)

* Audit which alerts are actionable
* Alert on SLO impact, not raw metrics
* Add grouping and stabilization
* Separate severity levels
* Assign alert ownership

👉 Monitoring should generate **actionable signals, not noise** — optimize for impact, not metrics.

----

## Q27: Users are reporting slow application performance but all your metrics show everything is green. How do you investigate?

---

### 🧠 Overview

If users say **“it’s slow”** but dashboards are green:

> Your monitoring is incomplete or measuring the wrong thing.

This usually means:

* You’re monitoring system metrics, not user experience
* Latency percentiles (p95/p99) not tracked
* Regional/CDN issue
* External dependency slowdown
* Frontend issue not backend
* Network path issue

Goal:

1. Validate user impact
2. Identify blind spots
3. Trace request end-to-end
4. Improve observability

---

# 🔍 Phase 1: Validate the Complaint

---

## 1️⃣ Reproduce from User Region

Use synthetic test:

```bash
curl -w "@curl-format.txt" -o /dev/null -s https://app.example.com
```

Or test from different region:

```bash
curl --resolve app.example.com:443:<ip>
```

Check:

* DNS time
* TLS handshake
* TTFB (Time to First Byte)

---

## 2️⃣ Check Latency Percentiles

Dashboards often show **average latency**, which hides tail issues.

Bad metric:

```promql
avg(request_duration_seconds)
```

Better:

```promql
histogram_quantile(0.95, rate(request_duration_seconds_bucket[5m]))
```

Check:

* p95
* p99

Slow users often hit p99.

---

# 🔎 Phase 2: Check External Dependencies

---

## 1️⃣ Database Query Latency

```sql
SELECT query, total_time FROM pg_stat_statements
ORDER BY total_time DESC LIMIT 10;
```

Check:

* Slow queries
* Lock contention

---

## 2️⃣ Third-Party APIs

Check outbound latency:

```promql
rate(http_client_request_duration_seconds_bucket[5m])
```

If dependency slow → your API slow.

---

# 🔎 Phase 3: Check Regional or CDN Issues

---

## 1️⃣ CDN Health

If using CloudFront:

Check:

* Cache hit ratio
* Origin latency

High origin calls → slower.

---

## 2️⃣ DNS Latency

Check:

```bash
dig app.example.com
```

High resolution time?

---

## 3️⃣ Specific Geography Impact

Users in India slow?
Users in EU fine?

Check multi-region latency.

---

# 🔬 Phase 4: Enable Distributed Tracing

If not already enabled, add:

* Jaeger
* AWS X-Ray
* Datadog APM

Trace flow:

```
User → CDN → ALB → Service A → Service B → DB
```

Find which hop slow.

---

# 🔥 Phase 5: Check Resource Saturation (Hidden)

Even if CPU looks normal:

* Thread pool saturation?
* Connection pool exhaustion?
* GC pauses?
* I/O wait?

---

## Example: Check I/O Wait

```bash
iostat -x 1
```

High disk wait = slow app.

---

## Example: JVM GC Pauses

Check logs for:

```
Full GC
```

---

# 🔁 Phase 6: Frontend Investigation

Sometimes backend is fine.

Check:

* Large JS bundle
* Slow client rendering
* API waterfall calls
* Browser console errors

Use Chrome DevTools → Network tab.

---

# 🔒 Phase 7: Improve Observability

---

## Add:

* Real User Monitoring (RUM)
* Synthetic monitoring
* Tail latency metrics
* Dependency latency metrics

---

## Golden Signals Model

Track:

* Latency
* Errors
* Traffic
* Saturation

Most teams track only CPU.

---

# 📊 Investigation Matrix

| Area       | What to Check         |
| ---------- | --------------------- |
| Backend    | p95/p99 latency       |
| DB         | Slow queries          |
| Network    | DNS/TLS latency       |
| CDN        | Cache miss            |
| Dependency | External API response |
| Infra      | I/O wait              |
| Frontend   | Bundle size           |

---

# ⚠️ Common Root Causes

* Monitoring only averages
* Hidden p99 latency
* Regional routing issue
* Slow third-party API
* Lock contention in DB
* Garbage collection pause
* CDN misconfiguration

---

# 📋 Debug Flow (Interview Style)

| Step | Action             |
| ---- | ------------------ |
| 1    | Reproduce issue    |
| 2    | Check p95/p99      |
| 3    | Check dependencies |
| 4    | Trace request path |
| 5    | Check DB locks     |
| 6    | Validate frontend  |

---

# ⚠️ What NOT to Do

* ❌ Assume users are wrong
* ❌ Trust only CPU metrics
* ❌ Look only at averages
* ❌ Ignore external dependencies

---

# 💡 In Short (Interview Quick Recall)

* Reproduce from user region
* Check p95/p99 latency
* Trace request end-to-end
* Validate DB and external APIs
* Improve observability

👉 If dashboards are green but users complain, you’re likely **monitoring infrastructure, not user experience**.

----
## Q28: You have no monitoring on a legacy application that just moved to your team. How do you implement observability from scratch?

---

### 🧠 Overview

No monitoring = **flying blind in production**.

Your goal is not to “add dashboards.”
Your goal is to implement **observability based on user impact**.

Follow this order:

> Logs → Metrics → Alerts → Tracing → SLOs

Focus on:

* Availability
* Latency
* Error rate
* Saturation

Golden Signals first, deep telemetry later.

---

# 🏗 Phase 1: Establish Basic Visibility (Week 1)

---

# 🔹 1️⃣ Centralized Logging

If on EC2:

Install CloudWatch Agent.

If on Kubernetes:

Deploy FluentBit or Fluentd.

Example (EKS FluentBit DaemonSet):

```bash
kubectl apply -f fluentbit.yaml
```

Logs → CloudWatch or OpenSearch.

Ensure:

* Application logs
* Access logs
* Error logs
* System logs

---

# 🔹 2️⃣ Basic Infrastructure Metrics

Enable:

* EC2 CPU
* Memory
* Disk
* Network

In Kubernetes:

```bash
kubectl top pods
kubectl top nodes
```

Install metrics-server if missing.

---

# 🚀 Phase 2: Application-Level Metrics (Week 2)

---

# 🔹 1️⃣ Expose /metrics Endpoint

Add Prometheus client.

Example (Spring Boot):

```yaml
management:
  endpoints:
    web:
      exposure:
        include: prometheus
```

---

# 🔹 2️⃣ Deploy Prometheus + Grafana

```bash
helm install prometheus prometheus-community/kube-prometheus-stack
```

Track:

* Request rate
* Error rate
* Latency histogram
* DB connections

---

# 📊 Implement Golden Signals

---

## 1️⃣ Latency

```promql
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
```

---

## 2️⃣ Error Rate

```promql
rate(http_requests_total{status=~"5.."}[5m])
```

---

## 3️⃣ Traffic

```promql
rate(http_requests_total[1m])
```

---

## 4️⃣ Saturation

```promql
container_cpu_usage_seconds_total
```

---

# 🚨 Phase 3: Implement Alerting

---

## Critical Alerts Only Initially

Example:

```yaml
- alert: HighErrorRate
  expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
  for: 10m
```

Page only on:

* Service unavailable
* Error rate > threshold
* DB down

Avoid CPU > 70% alerts.

---

# 🔎 Phase 4: Add Distributed Tracing (Week 3)

---

Install:

* Jaeger
* AWS X-Ray
* Datadog APM

Trace request path:

```
User → API → Service → DB
```

Helps identify bottlenecks.

---

# 🌍 Phase 5: Add Synthetic Monitoring

Use:

* Pingdom
* Datadog Synthetics
* UptimeRobot

Test:

* Login
* Critical APIs
* Checkout flow

Monitors real user experience.

---

# 📈 Phase 6: Define SLOs

---

Example SLO:

* 99.9% availability
* p95 latency < 500ms
* Error rate < 1%

Add burn-rate alerts:

```promql
(error_rate / error_budget) > threshold
```

---

# 🛡 Phase 7: Long-Term Enhancements

---

## ✅ Log Structuring

Switch to JSON logs.

---

## ✅ Correlation IDs

Add request ID header.

---

## ✅ Dashboards Per Service

Include:

* Latency
* Errors
* DB
* External APIs

---

## ✅ Runbooks Linked to Alerts

Each alert must include:

* Root cause steps
* Mitigation steps

---

# 📋 Implementation Timeline

| Week   | Focus                       |
| ------ | --------------------------- |
| Week 1 | Logs + Infra metrics        |
| Week 2 | App metrics + dashboards    |
| Week 3 | Alerting + tracing          |
| Week 4 | SLOs + synthetic monitoring |

---

# ⚠️ What NOT to Do

* ❌ Alert on every metric
* ❌ Only monitor CPU
* ❌ Skip application-level metrics
* ❌ Ignore log centralization

---

# 📊 Observability Stack Example

```
Application → Prometheus → Grafana
Logs → FluentBit → OpenSearch
Tracing → Jaeger
Alerts → Alertmanager → PagerDuty
Synthetic → External Monitor
```

---

# 💡 In Short (Interview Quick Recall)

* Start with logs + infra metrics
* Add app metrics (Golden Signals)
* Implement actionable alerts
* Add tracing for deep debugging
* Define SLOs

👉 Observability from scratch means building **visibility around user experience**, not just server health.

----
## Q29: Your Grafana dashboards show normal metrics but customers are reporting intermittent failures. What's missing in your observability?

---

### 🧠 Overview

If dashboards are green but customers see intermittent failures:

> You are monitoring averages and infrastructure — not user experience or tail behavior.

Most likely missing:

* p95/p99 latency visibility
* Error rate per endpoint
* Synthetic monitoring
* Distributed tracing
* Correlation IDs
* Dependency-level metrics
* SLO-based alerting

This is an **observability gap**, not necessarily a system outage.

---

# 🔍 What’s Likely Missing

---

# 🔹 1️⃣ Tail Latency (p95 / p99)

Most dashboards show:

```promql
avg(http_request_duration_seconds)
```

Average hides slow requests.

Instead use:

```promql
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))
```

Intermittent issues often affect only 1–5% of traffic → visible only in p99.

---

# 🔹 2️⃣ Per-Endpoint Error Rates

If monitoring:

```
total error rate
```

You may miss:

* One failing endpoint
* One failing region
* One specific customer segment

Better:

```promql
rate(http_requests_total{status=~"5.."}[5m]) by (path)
```

---

# 🔹 3️⃣ Synthetic Monitoring (User Perspective)

Dashboards show internal metrics.

Missing:

* Login success rate
* Checkout flow test
* External uptime check

Add:

* Datadog Synthetics
* Pingdom
* UptimeRobot

This validates real user experience.

---

# 🔹 4️⃣ Distributed Tracing

Without tracing, you can’t see:

```
User → API → Service A → Service B → DB → External API
```

Intermittent failure could be:

* One dependency timeout
* One microservice overloaded
* One retry storm

Add:

* Jaeger
* AWS X-Ray
* OpenTelemetry

---

# 🔹 5️⃣ Dependency Metrics

You may monitor:

* CPU
* Memory
* Overall latency

But not:

* DB query latency
* Connection pool exhaustion
* External API timeout rate

Example:

```promql
rate(http_client_request_duration_seconds_bucket[5m])
```

---

# 🔹 6️⃣ Error Budget Burn Rate

Instead of monitoring raw error count, track:

```promql
(error_rate / allowed_error_budget)
```

Intermittent bursts may not trigger basic threshold alerts.

---

# 🔹 7️⃣ Correlation IDs in Logs

Without request IDs:

* Impossible to trace failing request
* Logs disconnected

Add middleware:

```
X-Request-ID
```

Log it across services.

---

# 🔹 8️⃣ Regional or CDN Monitoring

Issue might be:

* Only India region slow
* CDN cache misses
* DNS resolution delay

Need geo-distributed monitoring.

---

# 🔹 9️⃣ Retry Storm Visibility

Retries can mask failures:

* First call fails
* Retry succeeds
* User experiences delay

Metrics look “successful.”

Track:

```promql
rate(retry_attempts_total[5m])
```

---

# 📊 Observability Gaps Table

| Missing Signal       | Why It Matters                  |
| -------------------- | ------------------------------- |
| p99 latency          | Detect tail issues              |
| Per-endpoint metrics | Detect localized failure        |
| Synthetic tests      | User experience validation      |
| Tracing              | Identify dependency bottlenecks |
| Dependency metrics   | Catch hidden bottlenecks        |
| Correlation IDs      | Cross-service debugging         |
| Retry metrics        | Detect masked failures          |

---

# 🔎 Investigation Flow

| Step | Action                      |
| ---- | --------------------------- |
| 1    | Check p95/p99               |
| 2    | Break down by endpoint      |
| 3    | Check dependency latency    |
| 4    | Run synthetic test          |
| 5    | Inspect trace for slow span |
| 6    | Review retry behavior       |

---

# ⚠️ Common Real Causes

* One DB replica slow
* External API intermittent 500s
* Thread pool saturation
* Connection pool exhaustion
* GC pause
* One Kubernetes node overloaded
* DNS resolution delay
* CDN misrouting

---

# 🔒 How to Fix Observability Properly

---

## ✅ Implement Golden Signals per Service

* Latency (p95/p99)
* Errors
* Traffic
* Saturation

---

## ✅ Add Distributed Tracing

Instrument with OpenTelemetry.

---

## ✅ Add Synthetic Monitoring

Monitor real user journeys.

---

## ✅ Implement SLO-Based Alerts

Alert when SLO breach likely.

---

## ✅ Add Dependency Dashboards

Every service must show:

* DB latency
* External API latency
* Cache hit ratio

---

# 💡 In Short (Interview Quick Recall)

* Averages hide intermittent failures
* Monitor p95/p99, not just avg
* Add synthetic monitoring
* Add distributed tracing
* Track dependency-level metrics

👉 If Grafana is green but customers complain, you’re likely missing **tail latency, dependency visibility, or user-experience monitoring**.

---
## Q30: You need to implement distributed tracing across 30 microservices with minimal code changes. How do you approach this?

---

### 🧠 Overview

Goal: **End-to-end tracing across 30 services** with minimal code changes.

Principle:

> Prefer auto-instrumentation + sidecars + service mesh over manual code changes.

Best approach today:

* **OpenTelemetry (OTel)** as standard
* Auto-instrumentation agents
* Central collector
* Backend: Jaeger / Tempo / Datadog / X-Ray

Avoid rewriting 30 codebases manually.

---

# 🏗 Target Architecture

```
Service Pods
   ↓ (OTel SDK / Auto Agent)
OpenTelemetry Collector (DaemonSet / Deployment)
   ↓
Tracing Backend (Jaeger / Tempo / X-Ray / Datadog)
   ↓
Grafana / UI
```

---

# 🚀 Step 1: Choose Standard (OpenTelemetry)

Use **OpenTelemetry** because:

* Vendor neutral
* Supports Java, Node, Python, Go
* Works with all major backends

---

# 🔁 Step 2: Use Auto-Instrumentation (Minimal Code Change)

---

# 🔹 Java Services

Use Java Agent:

Add to container startup:

```bash
-javaagent:/otel/opentelemetry-javaagent.jar
```

Environment variables:

```bash
OTEL_SERVICE_NAME=payment-service
OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector:4317
```

No code change required.

---

# 🔹 Node.js Services

Install:

```bash
npm install @opentelemetry/auto-instrumentations-node
```

Startup:

```bash
node -r @opentelemetry/auto-instrumentations-node/register app.js
```

Minimal change.

---

# 🔹 Python Services

```bash
pip install opentelemetry-distro
opentelemetry-instrument python app.py
```

---

# 🔁 Step 3: Deploy OpenTelemetry Collector in Kubernetes

---

Install via Helm:

```bash
helm install otel-collector open-telemetry/opentelemetry-collector
```

Example config:

```yaml
receivers:
  otlp:
    protocols:
      grpc:

exporters:
  jaeger:
    endpoint: jaeger:14250

service:
  pipelines:
    traces:
      receivers: [otlp]
      exporters: [jaeger]
```

Collector handles:

* Exporting
* Sampling
* Centralized config

---

# 🔁 Step 4: Add Context Propagation

Ensure HTTP headers propagate:

* `traceparent`
* `tracestate`

Most auto-instrumentation handles this automatically.

For custom calls, ensure:

```bash
Traceparent header forwarded
```

Without this → traces break across services.

---

# 🔁 Step 5: Choose Tracing Backend

---

## Option A: Jaeger (Self-hosted)

Install:

```bash
helm install jaeger jaegertracing/jaeger
```

Good for internal K8s clusters.

---

## Option B: Grafana Tempo

Integrates with Grafana.

---

## Option C: AWS X-Ray

If on AWS.

---

## Option D: Datadog / NewRelic

Managed APM.

---

# 🔥 Step 6: Sampling Strategy (Critical at Scale)

30 services → huge trace volume.

Use:

```yaml
sampling:
  probabilistic:
    sampling_percentage: 10
```

Or dynamic sampling for:

* Errors
* High latency

---

# 🔎 Step 7: Validate Trace Flow

Test flow:

```
User → API Gateway → Service A → Service B → DB
```

In UI, confirm:

* Full trace visible
* Span breakdown correct
* Latency per service visible

---

# 🛡 Best Practices

---

## ✅ Add Service Name Consistency

Set:

```bash
OTEL_SERVICE_NAME
```

Correct naming avoids chaos.

---

## ✅ Add Environment Tags

```
env=production
region=us-east-1
```

---

## ✅ Monitor Trace Errors

Add dashboard for:

* Error spans
* Long spans
* Dependency latency

---

## ✅ Secure Collector

Use mTLS between services and collector.

---

# 📊 Implementation Strategy

| Step | Action                      |
| ---- | --------------------------- |
| 1    | Deploy OTel Collector       |
| 2    | Enable auto-instrumentation |
| 3    | Configure backend           |
| 4    | Enable sampling             |
| 5    | Validate end-to-end traces  |
| 6    | Add dashboards              |

---

# ⚠️ What NOT to Do

* ❌ Manually instrument 30 services fully
* ❌ Enable 100% sampling in production
* ❌ Forget header propagation
* ❌ Skip performance impact testing

---

# 📋 Minimal-Code Rollout Plan

| Week   | Focus                       |
| ------ | --------------------------- |
| Week 1 | Collector + Backend         |
| Week 2 | Enable auto-instrumentation |
| Week 3 | Tune sampling               |
| Week 4 | Add dashboards              |

---

# 💡 In Short (Interview Quick Recall)

* Use OpenTelemetry
* Prefer auto-instrumentation agents
* Deploy central collector
* Use sampling to control cost
* Validate header propagation

👉 Distributed tracing at scale requires **standardization + automation + sampling control**, not manual code rewrites across 30 services.

---
## Q31: Your application needs to handle a 10x traffic spike during a product launch in 2 weeks. How do you prepare?

---

### 🧠 Overview

10x traffic spike in 2 weeks = **capacity + resilience + validation problem**.

Principle:

> Don’t guess capacity. Measure, test, and scale safely.

Focus areas:

* Load testing
* Horizontal scaling
* Database readiness
* Caching strategy
* Auto-scaling tuning
* Failure protection

Goal:

* No downtime
* Controlled degradation if needed
* Real-time observability

---

# 🚀 Phase 1: Baseline & Capacity Planning (Days 1–3)

---

## 1️⃣ Measure Current Metrics

Capture:

* Current RPS
* Peak RPS
* CPU usage
* Memory usage
* DB connections
* p95 latency

Example PromQL:

```promql
rate(http_requests_total[5m])
```

If current peak = 1,000 RPS → prepare for 10,000 RPS.

---

## 2️⃣ Identify Bottlenecks

Check:

* DB CPU
* Slow queries
* Cache hit ratio
* Thread pool size
* Connection pool size

---

# 🔥 Phase 2: Load Testing (Days 3–7)

---

Use:

* k6
* JMeter
* Locust

Example k6 test:

```javascript
import http from 'k6/http';
export default function () {
  http.get('https://app.example.com');
}
```

Run progressively:

* 2x
* 5x
* 10x

Identify:

* Breaking point
* Latency increase
* Resource saturation

---

# 🏗 Phase 3: Scale Architecture

---

# 🔹 1️⃣ Horizontal Pod Autoscaler (K8s)

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  minReplicas: 5
  maxReplicas: 50
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        averageUtilization: 60
```

Test autoscaling during load test.

---

# 🔹 2️⃣ Cluster Autoscaler

Ensure node groups can scale.

Check ASG max:

```bash
aws autoscaling describe-auto-scaling-groups
```

Increase max capacity before event.

---

# 🔹 3️⃣ Database Scaling

Options:

* Increase instance size
* Add read replicas
* Optimize queries
* Enable connection pooling

Example (RDS):

```bash
aws rds modify-db-instance --db-instance-class db.r6g.2xlarge
```

---

# 🔹 4️⃣ Add Caching Layer

Use Redis for:

* Session data
* Frequently read data
* API responses

Goal: reduce DB load.

---

# 🔹 5️⃣ Enable CDN

If static content heavy:

* Use CloudFront
* Cache aggressively

Reduce backend load.

---

# 🔥 Phase 4: Protect Against Failure

---

# 🔹 1️⃣ Rate Limiting

Prevent overload:

```nginx
limit_req zone=api burst=20 nodelay;
```

---

# 🔹 2️⃣ Circuit Breakers

Prevent cascading failures.

---

# 🔹 3️⃣ Graceful Degradation

If needed:

* Disable non-critical features
* Reduce analytics processing
* Queue background jobs

---

# 📊 Phase 5: Monitoring Upgrade

---

Add dashboards for:

* p95/p99 latency
* DB connections
* Cache hit ratio
* Error rate
* Pod scaling events

Alert example:

```promql
rate(http_requests_total{status=~"5.."}[5m]) > 0.05
```

---

# 🔄 Phase 6: Game Day Simulation

Simulate:

* 10x load
* One DB replica failure
* One node failure

Ensure system survives.

---

# 🔒 Pre-Launch Checklist

---

| Check                 | Status |
| --------------------- | ------ |
| HPA configured        | ✅      |
| ASG max increased     | ✅      |
| DB scaled             | ✅      |
| Load tested at 10x    | ✅      |
| CDN configured        | ✅      |
| Rate limiting enabled | ✅      |
| Monitoring updated    | ✅      |

---

# ⚠️ Common Failure Points

* DB becomes bottleneck
* Connection pool exhaustion
* Cache misconfiguration
* Autoscaler too slow
* Cold starts
* DNS rate limits

---

# 🛡 Emergency Plan

If traffic exceeds 10x:

* Enable queue
* Temporarily restrict access
* Increase read replicas
* Scale nodes manually

---

# 📋 2-Week Execution Plan

| Week   | Focus                                           |
| ------ | ----------------------------------------------- |
| Week 1 | Load test + scaling changes                     |
| Week 2 | Stress test + monitoring tuning + failover test |

---

# 💡 In Short (Interview Quick Recall)

* Measure baseline
* Load test at 10x
* Scale horizontally (pods + nodes)
* Optimize DB + add caching
* Add rate limiting + monitoring

👉 Handling 10x traffic spike requires **testing, horizontal scaling, caching, and failure protection**, not just adding more servers.

----
## Q32: Your database is becoming a bottleneck as traffic grows. You cannot change the application code. What infrastructure solutions do you implement?

---

### 🧠 Overview

If the **database is the bottleneck** and you **cannot change application code**, your only levers are:

* Vertical scaling
* Read scaling
* Connection management
* Caching (transparent)
* Storage/IO optimization
* Traffic shaping

Principle:

> Reduce DB pressure without modifying application logic.

Goal:

* Improve throughput
* Reduce latency
* Prevent connection exhaustion
* Maintain availability

---

# 🔍 Phase 1: Identify Bottleneck Type

Check:

* CPU saturation
* Memory pressure
* IOPS limits
* Connection limit reached
* Slow queries
* Lock contention

Example (Postgres):

```sql
SELECT count(*) FROM pg_stat_activity;
```

CloudWatch metrics:

* CPUUtilization
* ReadIOPS
* DatabaseConnections
* FreeableMemory

---

# 🔥 Scenario 1: CPU Bottleneck

---

## 🔹 Vertical Scaling (Fastest Fix)

Upgrade instance type:

```bash
aws rds modify-db-instance \
  --db-instance-identifier prod-db \
  --db-instance-class db.r6g.4xlarge \
  --apply-immediately
```

Pros:

* No code change
* Immediate impact

Cons:

* Expensive
* Limited scalability

---

# 🔥 Scenario 2: Read Bottleneck

If reads dominate.

---

## 🔹 Add Read Replicas

```bash
aws rds create-db-instance-read-replica \
  --db-instance-identifier prod-db-replica \
  --source-db-instance-identifier prod-db
```

Then route read traffic using:

* RDS Proxy (if supported)
* Load balancer at DB layer
* DNS-based read endpoint (Aurora)

If using Aurora:

Use reader endpoint automatically:

```
cluster.cluster-ro-xxxxx.rds.amazonaws.com
```

---

# 🔥 Scenario 3: Connection Exhaustion

Common in high-traffic systems.

---

## 🔹 Add RDS Proxy

```bash
aws rds create-db-proxy \
  --db-proxy-name prod-proxy
```

Benefits:

* Connection pooling
* Reduced DB load
* Faster connection reuse

No app code change if endpoint updated.

---

# 🔥 Scenario 4: IOPS / Storage Bottleneck

---

## 🔹 Increase Provisioned IOPS

```bash
aws rds modify-db-instance \
  --iops 10000
```

Or switch to:

* gp3
* io2

Improves disk latency significantly.

---

# 🔥 Scenario 5: Memory Pressure

---

## 🔹 Increase Buffer Cache

Upgrade to memory-optimized instance:

* r6g
* r5

More RAM = more cached data = fewer disk reads.

---

# 🔥 Scenario 6: Heavy Write Load

---

## 🔹 Partition Traffic

Infrastructure-level:

* Add queue (SQS / Kafka)
* Offload background writes
* Introduce write throttling

Without changing app logic directly.

---

# 🔥 Scenario 7: Hot Tables / Locking

If single table hot:

---

## 🔹 Use Read Replica for Analytics

Move reporting workloads off primary DB.

---

## 🔹 Enable Query Cache (if supported)

MySQL:

```sql
SET GLOBAL query_cache_size = ...
```

---

# 🔥 Scenario 8: Add Caching Layer (Transparent)

If app repeatedly queries same data.

---

## 🔹 Introduce Redis (If App Already Uses It)

Or enable DB-level caching.

---

# 🔥 Scenario 9: Multi-AZ and Failover

Ensure:

```bash
aws rds modify-db-instance --multi-az
```

Prevents downtime under load failure.

---

# 📊 Solution Comparison

| Bottleneck     | Solution                  | Code Change Required? |
| -------------- | ------------------------- | --------------------- |
| CPU            | Bigger instance           | ❌                     |
| Reads          | Read replicas             | ❌                     |
| Connections    | RDS Proxy                 | ❌                     |
| IOPS           | Provisioned IOPS          | ❌                     |
| Memory         | Memory-optimized instance | ❌                     |
| Analytics load | Dedicated replica         | ❌                     |

---

# 🔒 Long-Term Strategy

---

## ✅ 1️⃣ Enable Performance Insights

Identify top queries.

---

## ✅ 2️⃣ Monitor Connection Count

Alert before hitting max.

---

## ✅ 3️⃣ Implement Auto-Scaling (Aurora)

Aurora can auto-scale read replicas.

---

## ✅ 4️⃣ Plan Sharding (Future)

If traffic continues growing.

---

# ⚠️ What NOT to Do

* ❌ Restart DB frequently
* ❌ Increase max connections blindly
* ❌ Ignore slow query metrics
* ❌ Scale app without scaling DB

---

# 📋 Immediate Action Plan

| Step | Action                     |
| ---- | -------------------------- |
| 1    | Identify bottleneck metric |
| 2    | Add RDS Proxy              |
| 3    | Add read replica           |
| 4    | Increase instance size     |
| 5    | Optimize IOPS              |

---

# 💡 In Short (Interview Quick Recall)

* Identify bottleneck type
* Scale vertically first
* Add read replicas
* Use RDS Proxy for connection pooling
* Increase IOPS if storage-bound

👉 If you cannot change application code, solve DB bottlenecks with **scaling, replication, pooling, and storage optimization at infrastructure level**.

---
## Q33: Your auto-scaling is too slow and users experience degraded performance before new instances come online. How do you fix this?

---

### 🧠 Overview

If users feel degradation **before autoscaling reacts**, the issue is:

> Reactive scaling + slow instance startup + no buffer capacity.

Typical reasons:

* CPU-based scaling reacts too late
* Cooldown period too high
* Node boot time slow (3–5 minutes)
* Containers cold start
* No pre-warmed capacity
* Scaling on wrong metric

Goal:

1. Reduce reaction time
2. Pre-scale before spike
3. Maintain buffer capacity
4. Improve startup speed

---

# 🔍 Phase 1: Identify Bottleneck in Scaling Path

Scaling chain:

```
Traffic spike → Metric crosses threshold → HPA triggers →
Cluster Autoscaler triggers → Node boots →
Pod schedules → Container starts → Ready
```

Where is delay?

Check:

* HPA metrics delay?
* Node startup time?
* Image pull time?
* Readiness probe delay?

---

# 🔥 Phase 2: Improve Scaling Responsiveness

---

# 🔹 1️⃣ Scale on Better Metrics (Not CPU)

CPU is slow to reflect overload.

Better metrics:

* Requests per second
* Queue depth
* Latency
* Custom business metrics

Example HPA (RPS-based):

```yaml
metrics:
- type: Pods
  pods:
    metric:
      name: http_requests_per_second
    target:
      type: AverageValue
      averageValue: 100
```

RPS-based scaling reacts faster than CPU.

---

# 🔹 2️⃣ Reduce Cooldown & Stabilization Window

Check HPA behavior:

```yaml
behavior:
  scaleUp:
    stabilizationWindowSeconds: 0
    policies:
    - type: Percent
      value: 100
      periodSeconds: 15
```

Allow aggressive scale-up.

---

# 🔹 3️⃣ Maintain Buffer Capacity (Headroom Strategy)

Never run at 90–100% utilization.

Keep:

* 20–30% idle capacity

Example:

```yaml
minReplicas: 5
```

Even if average load needs only 3.

Prevents performance dip during scaling.

---

# 🔹 4️⃣ Pre-Warm Nodes

Increase ASG minimum capacity:

```bash
aws autoscaling update-auto-scaling-group \
  --min-size 10
```

Keep spare nodes ready.

---

# 🔹 5️⃣ Use Overprovisioning Pods (Advanced)

Deploy low-priority placeholder pods:

```yaml
priorityClassName: low-priority
```

When real workload spikes:

* Placeholder pods evicted instantly
* Real pods scheduled immediately

Prevents scheduling delay.

---

# 🔥 Phase 3: Reduce Instance Startup Time

---

# 🔹 1️⃣ Use Smaller AMIs

Avoid large startup scripts.

Pre-bake AMI with:

* Docker installed
* App image cached

Use Packer.

---

# 🔹 2️⃣ Use Warm Pools (EC2)

```bash
aws autoscaling put-warm-pool ...
```

Pre-initialized instances reduce startup time.

---

# 🔹 3️⃣ Optimize Container Startup

* Reduce image size
* Use distroless base
* Pre-pull images

K8s:

```bash
kubectl rollout restart daemonset pre-pull
```

---

# 🔥 Phase 4: Predictive Scaling

---

## 🔹 Scheduled Scaling

If launch at 9 AM:

```bash
aws autoscaling put-scheduled-update-group-action ...
```

Scale before event.

---

## 🔹 Predictive Scaling (AWS ASG)

Enable predictive scaling policy.

Uses historical patterns.

---

# 🔥 Phase 5: Protect System During Spike

---

# 🔹 1️⃣ Rate Limiting

Prevent overload:

```nginx
limit_req zone=api burst=50;
```

---

# 🔹 2️⃣ Queue Traffic

Introduce SQS/Kafka buffering.

Absorb traffic spike.

---

# 📊 Strategy Comparison

| Solution              | Impact | Speed                | Risk        |
| --------------------- | ------ | -------------------- | ----------- |
| RPS-based scaling     | High   | Fast                 | Low         |
| Increase min replicas | High   | Instant              | Medium cost |
| Warm pool             | Medium | Faster boot          | Low         |
| Overprovisioning      | High   | Immediate scheduling | Medium      |
| Predictive scaling    | High   | Preemptive           | Low         |

---

# 📋 Fix Strategy Summary

| Step | Action                     |
| ---- | -------------------------- |
| 1    | Scale on RPS, not CPU      |
| 2    | Reduce scale-up delay      |
| 3    | Maintain headroom          |
| 4    | Use warm pools             |
| 5    | Pre-scale for known events |

---

# ⚠️ What NOT to Do

* ❌ Increase thresholds blindly
* ❌ Scale only after CPU 90%
* ❌ Ignore cold start time
* ❌ Run cluster at 100% utilization

---

# 💡 In Short (Interview Quick Recall)

* Reactive CPU scaling is too slow
* Scale on traffic metrics
* Keep buffer capacity
* Use warm pools + faster startup
* Implement predictive scaling

👉 Fast scaling requires **proactive headroom + traffic-based scaling + reduced startup latency**, not just bigger instances.

----
## Q34: A single microservice is causing cascading failures across the entire system. How do you isolate and fix this?

---

### 🧠 Overview

Cascading failure means:

> One failing service overwhelms others → retries spike → thread pools saturate → entire system degrades.

Common causes:

* Dependency timeout
* Retry storm
* Unbounded connection pool
* Circuit breaker missing
* Synchronous blocking calls

Goal:

1. Stop propagation immediately
2. Isolate failing service
3. Protect healthy services
4. Fix root cause
5. Add resilience controls

---

# 🚨 Phase 1: Immediate Containment

---

## 1️⃣ Identify Failing Service

Check:

* Error rate by service
* Latency per service
* Dependency traces

Example:

```promql
rate(http_requests_total{status=~"5.."}[5m]) by (service)
```

Find spike source.

---

## 2️⃣ Disable or Isolate Service

If non-critical:

```bash
kubectl scale deployment failing-service --replicas=0
```

If critical:

* Route traffic away
* Switch to degraded mode

---

## 3️⃣ Reduce Retry Storm

Retries amplify failures.

If using Envoy / Istio:

Reduce retry policy.

Example:

```yaml
retries:
  attempts: 1
```

Avoid infinite retry loops.

---

# 🔥 Phase 2: Stop Resource Saturation

---

## 1️⃣ Increase Timeout Protection

Fail fast instead of hanging.

Example:

```yaml
timeout: 2s
```

Short timeouts prevent thread blocking.

---

## 2️⃣ Apply Rate Limiting

Protect upstream services.

NGINX:

```nginx
limit_req zone=api burst=20;
```

---

## 3️⃣ Enable Circuit Breaker

If using service mesh:

```yaml
outlierDetection:
  consecutive5xxErrors: 5
```

Trips breaker after repeated failures.

Prevents full collapse.

---

# 🔎 Phase 3: Root Cause Analysis

---

Check:

* DB dependency?
* External API slow?
* Memory leak?
* CPU spike?
* Recent deployment?

Trace request:

```
Service A → Service B (failing) → DB
```

Common root causes:

| Cause                 | Effect            |
| --------------------- | ----------------- |
| Slow DB query         | Request backlog   |
| Unbounded retries     | Thread exhaustion |
| Connection pool limit | Timeout           |
| Deadlock              | Blocking calls    |
| Misconfigured timeout | Long hang         |

---

# 🔧 Phase 4: Structural Fix

---

# 🔹 1️⃣ Add Circuit Breakers

Example (Resilience4j):

```yaml
failureRateThreshold: 50
waitDurationInOpenState: 10s
```

---

# 🔹 2️⃣ Add Bulkhead Isolation

Separate thread pools:

* Critical path threads
* Background job threads

Prevents total exhaustion.

---

# 🔹 3️⃣ Add Request Timeouts Everywhere

Never allow:

```
timeout = unlimited
```

---

# 🔹 4️⃣ Use Async Queues

Instead of synchronous dependency calls:

* Publish event
* Process async

Reduces tight coupling.

---

# 🔹 5️⃣ Add Fallback Responses

Example:

If recommendation service fails:

Return empty recommendation list.

Not 500 error.

---

# 🔒 Phase 5: Protect Entire System

---

## Implement Global Rate Limiting

Protect core APIs.

---

## Add Retry Budget

Limit total retries globally.

---

## Monitor Dependency Health

Alert on:

```promql
rate(dependency_errors_total[5m])
```

Before cascade starts.

---

# 📊 Isolation Strategy

| Action                     | Purpose               |
| -------------------------- | --------------------- |
| Scale down failing service | Stop spread           |
| Disable retries            | Prevent amplification |
| Enable circuit breaker     | Contain failure       |
| Rate limit                 | Protect core services |
| Add fallback               | Maintain availability |

---

# ⚠️ What NOT to Do

* ❌ Increase replicas blindly
* ❌ Increase retry count
* ❌ Restart entire cluster
* ❌ Ignore timeout configuration

---

# 📋 Incident Flow

| Step | Action                   |
| ---- | ------------------------ |
| 1    | Identify failing service |
| 2    | Isolate traffic          |
| 3    | Reduce retries           |
| 4    | Apply circuit breaker    |
| 5    | Fix root cause           |
| 6    | Add resilience patterns  |

---

# 💡 In Short (Interview Quick Recall)

* Identify failing service
* Stop retry amplification
* Apply circuit breaker + rate limiting
* Add timeouts + bulkheads
* Implement fallback mechanisms

👉 Cascading failures happen when **resilience patterns are missing** — isolate, contain, then harden the system permanently.

---
## Q35: Your team needs to reduce infrastructure costs by 40% without impacting performance or reliability. What strategies do you implement?

---

### 🧠 Overview

Reducing infra cost by **40% without hurting performance or reliability** is possible — but only if you:

> Optimize usage, eliminate waste, and improve efficiency before cutting capacity.

Principles:

* Measure before cutting
* Optimize architecture
* Right-size aggressively
* Use pricing models smartly
* Automate cleanup

Goal:

* Same SLO
* Lower bill
* No surprise outages

---

# 🔍 Phase 1: Cost Visibility & Waste Identification

---

## 1️⃣ Identify Top Cost Drivers

Use Cost Explorer:

```bash
aws ce get-cost-and-usage \
  --granularity MONTHLY \
  --metrics UnblendedCost \
  --group-by Type=DIMENSION,Key=SERVICE
```

Breakdown:

* EC2
* RDS
* EKS
* NAT Gateway
* Data transfer
* S3

Focus on top 3 services first.

---

# 🔥 Phase 2: Compute Optimization (Biggest Savings)

---

# 🔹 1️⃣ Rightsizing EC2 / EKS Nodes

Check utilization:

* CPU < 30%?
* Memory < 40%?

Switch instance types:

* m5 → m6g (Graviton)
* r5 → r6g

Graviton gives ~20–30% savings.

---

## 🔹 2️⃣ Use Spot Instances for Non-Critical Workloads

For:

* Batch jobs
* CI runners
* Dev environments

EKS node group example:

```bash
--capacity-type SPOT
```

Savings: up to 70%.

---

## 🔹 3️⃣ Consolidate Node Groups

Avoid many small underutilized nodes.

Use:

* Larger nodes
* Better bin-packing

---

## 🔹 4️⃣ Auto Shutdown Non-Prod

Lambda scheduler:

* Stop dev EC2 at 8 PM
* Start at 8 AM

Savings: ~50% in non-prod.

---

# 🔥 Phase 3: Database Cost Optimization

---

## 🔹 1️⃣ Right-size RDS

Check:

* CPU < 20%?
* Memory low usage?

Downsize instance.

---

## 🔹 2️⃣ Use Reserved Instances / Savings Plans

If workload stable:

* Commit 1–3 years
* Save 30–50%

---

## 🔹 3️⃣ Use Aurora Serverless (If Spiky)

Scale to zero in non-peak.

---

## 🔹 4️⃣ Reduce IOPS Overprovisioning

Check CloudWatch:

* Are you using all provisioned IOPS?

Switch to gp3 if possible.

---

# 🔥 Phase 4: Storage & Data Transfer

---

## 🔹 1️⃣ S3 Lifecycle Policies

```json
{
  "Transition": {
    "StorageClass": "GLACIER"
  }
}
```

Archive logs older than 30 days.

---

## 🔹 2️⃣ Delete Orphaned EBS Volumes

```bash
aws ec2 describe-volumes \
  --filters Name=status,Values=available
```

Delete unattached volumes.

---

## 🔹 3️⃣ Reduce NAT Gateway Cost

NAT is expensive.

Fix:

* Use VPC endpoints (S3, DynamoDB)
* Reduce cross-AZ traffic

---

## 🔹 4️⃣ Reduce Cross-AZ Traffic

Place services in same AZ where possible.

---

# 🔥 Phase 5: Container & Kubernetes Optimization

---

## 🔹 1️⃣ Tune Resource Requests

Over-requested CPU = waste.

Example:

```yaml
requests:
  cpu: "500m"
```

If actual usage 100m → reduce.

---

## 🔹 2️⃣ Enable Cluster Autoscaler

Scale nodes down when idle.

---

## 🔹 3️⃣ Use HPA Properly

Avoid running 10 replicas when 3 enough.

---

# 🔥 Phase 6: CI/CD & DevOps Savings

---

## 🔹 1️⃣ Use Ephemeral Runners

Avoid always-on CI servers.

---

## 🔹 2️⃣ Delete Old ECR Images

Retention policy:

* Keep last 10 versions.

---

# 📊 Savings Strategy Table

| Area              | Strategy               | Estimated Savings |
| ----------------- | ---------------------- | ----------------- |
| EC2               | Graviton + rightsizing | 20–30%            |
| Spot              | Non-prod workloads     | 50–70%            |
| RDS               | Resize + reserved      | 20–40%            |
| S3                | Lifecycle policies     | 10–20%            |
| NAT               | VPC endpoints          | 20–50%            |
| Non-prod shutdown | Scheduler              | 30–50%            |

Combine → 40% achievable.

---

# 🔒 Protect Performance While Cutting Costs

---

## Always:

* Load test after resizing
* Monitor p95 latency
* Check error rate
* Roll back if degradation

---

## Never:

* Cut capacity blindly
* Reduce HA (Multi-AZ)
* Remove backups
* Remove monitoring

---

# 📋 30-Day Cost Reduction Plan

| Week   | Action                     |
| ------ | -------------------------- |
| Week 1 | Identify waste             |
| Week 2 | Resize compute + DB        |
| Week 3 | Implement Spot + lifecycle |
| Week 4 | Purchase Savings Plans     |

---

# ⚠️ What NOT to Do

* ❌ Remove redundancy
* ❌ Disable Multi-AZ
* ❌ Ignore monitoring impact
* ❌ Overcommit Reserved Instances without analysis

---

# 💡 In Short (Interview Quick Recall)

* Measure top cost drivers first
* Right-size compute & DB
* Use Graviton + Spot
* Implement lifecycle + cleanup
* Add Savings Plans

👉 40% cost reduction is achievable by **rightsizing, eliminating waste, optimizing pricing models, and automating non-prod shutdown**, not by sacrificing reliability.

----
## Q36: Your development team is pushing 50 commits per day but releases only happen monthly. How do you implement continuous delivery?

---

### 🧠 Overview

50 commits/day + monthly releases = **process bottleneck, not engineering velocity issue**.

Problem usually caused by:

* Long-lived branches
* Manual testing
* Manual deployment approvals
* Risky big-bang releases
* No automated quality gates

Goal:

> Ship small, safe changes continuously with low risk.

Continuous Delivery =

* Every commit deployable
* Automated testing
* Automated pipelines
* Safe rollout strategy

---

# 🏗 Phase 1: Fix Source Control Strategy

---

## 🔹 1️⃣ Move to Trunk-Based Development

Avoid long-lived feature branches.

Flow:

```
feature → short PR → main → auto pipeline
```

Rules:

* Small PRs
* Merge daily
* No “release branch freeze”

---

## 🔹 2️⃣ Enforce PR Quality Gates

Require:

* 1–2 approvals
* CI passing
* No direct pushes to main

Example GitHub rule:

* Require status checks
* Require reviews

---

# 🚀 Phase 2: Build Automated CI Pipeline

---

Pipeline must run on every commit:

```groovy
stage('Build')
stage('Unit Test')
stage('Security Scan')
stage('Build Docker Image')
stage('Push to Registry')
```

Must complete in <15 mins.

Fail fast on:

* Test failure
* Security vulnerability
* Lint errors

---

# 🔁 Phase 3: Implement CD with Safe Deployment

---

# 🔹 1️⃣ Automatic Deployment to Staging

```yaml
on:
  push:
    branches: [main]
```

Deploy automatically to staging.

Run:

* Integration tests
* API tests
* Smoke tests

---

# 🔹 2️⃣ Use Feature Flags

Instead of monthly release:

* Merge incomplete features
* Hide behind flag

Example:

```yaml
FEATURE_NEW_CHECKOUT=true
```

Allows continuous deploy without user exposure.

---

# 🔹 3️⃣ Production Deployment Strategy

Use:

* Rolling updates
* Blue/Green
* Canary deployments

Example (Kubernetes rolling):

```yaml
strategy:
  rollingUpdate:
    maxUnavailable: 10%
    maxSurge: 10%
```

---

# 🔥 Phase 4: Reduce Release Risk

---

# 🔹 1️⃣ Deploy Small Changes Frequently

Instead of:

* 200 changes monthly

Do:

* 5–10 changes daily

Smaller blast radius.

---

# 🔹 2️⃣ Add Automated Regression Tests

Cover:

* Core APIs
* Auth
* Checkout
* Payment

---

# 🔹 3️⃣ Add Monitoring-Based Rollback

If:

```promql
rate(http_requests_total{status=~"5.."}[5m]) > 0.05
```

Auto rollback.

---

# 🔒 Phase 5: Approval Simplification

---

Instead of:

* Manual CAB approval monthly

Use:

* Automated pipeline gates
* Change log auto-generated
* Slack notification

Compliance can review logs, not block deployment.

---

# 📊 Deployment Maturity Model

| Stage          | Release Frequency |
| -------------- | ----------------- |
| Manual         | Monthly           |
| Semi-automated | Weekly            |
| CD             | Daily             |
| Advanced CD    | Multiple per day  |

Target: Daily at minimum.

---

# 📋 CD Implementation Roadmap (8 Weeks)

| Week | Focus                    |
| ---- | ------------------------ |
| 1–2  | Trunk-based dev          |
| 3–4  | Full CI automation       |
| 5–6  | Automated staging deploy |
| 7    | Feature flags            |
| 8    | Canary/Blue-Green prod   |

---

# 🛡 Risk Controls

---

## Always:

* Monitor p95 latency
* Track deployment frequency
* Track lead time
* Track MTTR

DORA metrics.

---

## Avoid:

* Big-bang releases
* Manual deployment steps
* Long code freezes
* Feature branches lasting weeks

---

# 📈 Benefits After CD

* Faster feedback
* Reduced risk per deploy
* Faster bug fixes
* Higher confidence

---

# 💡 In Short (Interview Quick Recall)

* Move to trunk-based development
* Automate CI fully
* Deploy automatically to staging
* Use feature flags
* Use rolling or canary deployments

👉 Continuous Delivery is about **small, safe, automated releases**, not just faster deployments.

---
## Q37: Two teams are breaking each other's deployments because they share the same pipeline. How do you solve this?

---

### 🧠 Overview

Shared pipeline + multiple teams = **coupling + blast radius problem**.

Symptoms:

* One team’s change breaks another team’s deploy
* Shared variables override each other
* Environment conflicts
* Unclear ownership
* Release coordination chaos

Root cause:

> Lack of isolation in CI/CD design.

Goal:

1. Isolate deployment paths
2. Enforce ownership boundaries
3. Reduce cross-team impact
4. Improve deployment reliability

---

# 🚨 Phase 1: Immediate Containment

---

## 1️⃣ Identify Coupling Points

Check:

* Shared deployment job?
* Shared Docker image?
* Shared Terraform state?
* Shared Helm values?
* Shared environment namespace?

Find what’s common.

---

# 🔥 Phase 2: Separate Pipelines Per Service

---

# 🔹 1️⃣ One Pipeline Per Service (Best Practice)

Instead of:

```
monorepo → single pipeline → deploy all services
```

Move to:

```
service-a → pipeline-a
service-b → pipeline-b
```

Trigger based on path:

```yaml
on:
  push:
    paths:
      - "service-a/**"
```

Each team owns its pipeline.

---

# 🔹 2️⃣ Use Separate Deployment Jobs

If monorepo must stay:

```groovy
stage('Deploy Service A') {
    when {
        changeset "service-a/**"
    }
}
```

Only deploy changed service.

---

# 🔒 Phase 3: Isolate Infrastructure

---

# 🔹 1️⃣ Separate Kubernetes Namespaces

Example:

```bash
kubectl create namespace team-a
kubectl create namespace team-b
```

Avoid shared namespace.

---

# 🔹 2️⃣ Separate Helm Releases

```bash
helm install team-a-app ./chart -n team-a
```

No shared release names.

---

# 🔹 3️⃣ Separate Terraform State

Bad:

```
terraform.tfstate (shared)
```

Better:

```
team-a/terraform.tfstate
team-b/terraform.tfstate
```

S3 backend example:

```hcl
key = "team-a/prod/terraform.tfstate"
```

Prevents cross-destroy incidents.

---

# 🔐 Phase 4: Access & Ownership Controls

---

## 🔹 1️⃣ Role-Based Access in CI

Team A:

* Can deploy service A
* Cannot deploy service B

Use:

* GitHub environments
* Jenkins folder-level permissions

---

## 🔹 2️⃣ Code Ownership

Define:

```
CODEOWNERS
```

Prevent cross-team accidental merges.

---

# 🔁 Phase 5: Improve Deployment Strategy

---

## 🔹 1️⃣ Independent Versioning

Each service versioned independently.

Avoid:

```
Release v1.0 includes all services
```

Instead:

```
Service A v1.3
Service B v2.7
```

---

## 🔹 2️⃣ Decouple Build from Deploy

Artifact once → deploy many times.

Pipeline structure:

```
Build → Store artifact → Deploy separately
```

Avoid rebuilding entire system for one change.

---

# 🔥 Phase 6: Implement Environment Promotion

Instead of direct prod deploy:

```
Dev → Staging → Prod
```

Each service promotes independently.

---

# 📊 Isolation Strategy Summary

| Problem              | Fix                      |
| -------------------- | ------------------------ |
| Shared pipeline      | Split per service        |
| Shared namespace     | Separate namespaces      |
| Shared state         | Separate Terraform state |
| Shared access        | RBAC                     |
| Shared release cycle | Independent versioning   |

---

# ⚠️ What NOT to Do

* ❌ Add more coordination meetings
* ❌ Add manual approvals as workaround
* ❌ Keep shared state file
* ❌ Allow cross-service deployments in same job

---

# 📋 Final Architecture

```
Team A
 ├── Repo A
 ├── Pipeline A
 ├── Namespace A
 └── State A

Team B
 ├── Repo B
 ├── Pipeline B
 ├── Namespace B
 └── State B
```

Isolation eliminates cross-breakage.

---

# 💡 In Short (Interview Quick Recall)

* Split pipelines per service
* Isolate namespaces & state files
* Enforce RBAC
* Version independently
* Decouple build and deploy

👉 Deployment conflicts happen due to **shared pipeline coupling** — fix with isolation, ownership boundaries, and independent delivery flows.

----
## Q38: A junior developer accidentally ran `terraform destroy` on the production environment. What processes do you put in place to prevent this?

---

### 🧠 Overview

If someone can run `terraform destroy` in production:

> This is not a human error — it’s a **process and guardrail failure**.

Prevention must happen at **multiple layers**:

* Access control
* CI/CD enforcement
* Terraform configuration
* Account isolation
* Policy enforcement

Goal:

1. Make destructive actions impossible by default
2. Require explicit, auditable approval
3. Enforce separation of duties

---

# 🚨 Phase 1: Immediate Containment

---

## 1️⃣ Remove Direct CLI Access to Prod

No one should run Terraform directly in production.

Enforce:

* Prod changes only via CI/CD
* No local `terraform apply` allowed

Use IAM:

```json
{
  "Effect": "Deny",
  "Action": [
    "ec2:TerminateInstances",
    "rds:DeleteDBInstance",
    "s3:DeleteBucket"
  ],
  "Resource": "*"
}
```

Applied to developer role.

---

# 🔐 Phase 2: Separate AWS Accounts

---

## 🔹 1️⃣ Dedicated Production Account

Never mix:

* Dev
* Staging
* Prod

Each in separate AWS account.

Use AWS Organizations + SCPs.

---

## 🔹 2️⃣ Restrict Prod Access

Only CI role can assume:

```
TerraformExecutionRole-Prod
```

Developers can:

* Run plan
* Not apply

---

# 🔒 Phase 3: Enforce Remote State + Locking

---

## 🔹 1️⃣ Mandatory S3 Backend

```hcl
backend "s3" {
  bucket         = "prod-terraform-state"
  key            = "prod/terraform.tfstate"
  dynamodb_table = "terraform-lock"
}
```

Prevents:

* Local state destroy
* Parallel execution

---

## 🔹 2️⃣ Enable S3 Versioning

Allows state recovery.

---

# 🛡 Phase 4: Terraform-Level Safeguards

---

# 🔹 1️⃣ Use `prevent_destroy`

Critical resources:

```hcl
resource "aws_db_instance" "prod" {
  lifecycle {
    prevent_destroy = true
  }
}
```

Destroy will fail.

---

# 🔹 2️⃣ Add `-destroy` Detection in CI

Pipeline step:

```bash
terraform plan -detailed-exitcode
```

If plan contains:

```
Destroy
```

Pipeline fails.

---

# 🔹 3️⃣ Require Manual Approval for Prod Apply

Jenkins example:

```groovy
input "Approve production deployment?"
```

Require senior engineer approval.

---

# 🔥 Phase 5: Policy Enforcement

---

# 🔹 1️⃣ Use AWS SCP to Block Destructive Actions

Example:

```json
{
  "Effect": "Deny",
  "Action": [
    "ec2:TerminateInstances",
    "rds:DeleteDBInstance"
  ],
  "Resource": "*"
}
```

Except from CI role.

---

# 🔹 2️⃣ Use Terraform Cloud / Enterprise

Enable:

* Sentinel policies
* Mandatory approval
* Policy-as-code

---

# 🔎 Phase 6: Environment Safety Checks

---

## 🔹 Add Explicit Confirmation for Destroy

Use:

```bash
terraform destroy -var-file=prod.tfvars
```

Require confirmation variable:

```hcl
variable "confirm_destroy" {
  type = bool
}
```

Fail if not explicitly true.

---

# 🔐 Phase 7: RBAC & Least Privilege

---

| Role            | Permissions   |
| --------------- | ------------- |
| Developer       | Plan only     |
| DevOps Engineer | Apply in dev  |
| CI Role         | Apply in prod |
| Security        | Audit only    |

No shared admin credentials.

---

# 🔄 Phase 8: Incident Simulation & Training

Run quarterly:

* “What if destroy happens?”
* Recovery drill
* State restore test

---

# 📊 Prevention Layers

| Layer       | Control                  |
| ----------- | ------------------------ |
| IAM         | Deny destructive actions |
| AWS Account | Separate prod            |
| Terraform   | prevent_destroy          |
| CI/CD       | Manual approval          |
| State       | Versioned backend        |
| Policy      | SCP + Sentinel           |

Defense in depth.

---

# ⚠️ What NOT to Do

* ❌ Blame junior developer
* ❌ Only rely on verbal process
* ❌ Allow direct prod CLI access
* ❌ Skip state locking

---

# 📋 Final Safe Architecture

```
Developer → PR → CI Plan →
Manual Approval →
CI Apply (Prod Role Only)
```

No human runs prod Terraform locally.

---

# 💡 In Short (Interview Quick Recall)

* Remove direct prod access
* Separate AWS accounts
* Use prevent_destroy
* Enforce CI approval gates
* Use SCP to block destructive APIs

👉 Accidental `terraform destroy` is a **governance failure**, solved by layered guardrails and strict environment isolation.

----
## Q39: Your on-call rotation is burning out the team because of too many overnight alerts. How do you improve this?

---

### 🧠 Overview

If on-call is burning out:

> The problem is not the team — it’s the alerting system and operational maturity.

Symptoms:

* Too many low-severity alerts
* Alerts without action
* Flapping alerts
* No SLO-based thresholds
* Poor escalation policies

Goal:

1. Reduce overnight noise
2. Alert only on user-impacting issues
3. Improve signal quality
4. Protect team health

Healthy on-call =
Low alert volume + high signal accuracy.

---

# 🚨 Phase 1: Audit Alerts

---

## 1️⃣ Export Alert Data (Last 30 Days)

Categorize:

| Alert | Count | Action Taken? | Should Page? |
| ----- | ----- | ------------- | ------------ |

Identify:

* Alerts ignored
* Alerts auto-resolved
* Alerts not actionable

If 80% alerts require no action → remove or downgrade.

---

# 🔥 Phase 2: Implement SLO-Based Paging

---

Instead of:

```promql
cpu_usage > 70%
```

Use:

```promql
rate(http_requests_total{status=~"5.."}[5m]) > 0.05
```

Only page when:

* Availability SLO breached
* Latency SLO breached
* Service down

Infrastructure noise → Slack only.

---

# 🔁 Phase 3: Add Alert Stabilization

---

Prevent flapping:

```yaml
for: 10m
```

Only alert if condition sustained.

Use:

```promql
avg_over_time(metric[10m])
```

Not instantaneous spikes.

---

# 🔁 Phase 4: Group & Deduplicate Alerts

---

Alertmanager config:

```yaml
group_by: ['alertname']
group_wait: 30s
repeat_interval: 4h
```

Instead of 100 alerts → 1 grouped alert.

---

# 🔒 Phase 5: Introduce Severity Levels

---

| Severity | Action                        |
| -------- | ----------------------------- |
| Critical | Page immediately              |
| High     | Slack + during business hours |
| Warning  | Dashboard only                |
| Info     | Log only                      |

Overnight paging only for Critical.

---

# 🔥 Phase 6: Add Error Budget Alerts

Instead of raw thresholds:

Alert on burn rate:

```promql
(error_rate / allowed_error_budget) > threshold
```

Prevents over-alerting on small blips.

---

# 🔁 Phase 7: Improve Runbooks

Each alert must include:

* Root cause checklist
* Immediate mitigation
* Escalation path

If alert has no clear action → remove it.

---

# 🔥 Phase 8: Implement Follow-the-Sun Rotation

If global team:

* Asia handles Asia hours
* US handles US hours

Reduces 3 AM pages.

---

# 🔥 Phase 9: Add Automation

---

## Auto-remediation

Example:

If pod crashes:

```bash
kubectl rollout restart deployment/app
```

Auto-heal instead of paging.

---

## Self-Healing Systems

* HPA
* Cluster autoscaler
* Restart policies

---

# 📊 Alert Optimization Impact

| Before           | After              |
| ---------------- | ------------------ |
| 200 alerts/night | <5 alerts/night    |
| CPU alerts       | SLO alerts         |
| Flapping         | Stabilized         |
| Manual triage    | Automated grouping |

---

# 🛡 Cultural Improvements

---

## Weekly Alert Review

Ask:

* Was this alert actionable?
* Did it require human intervention?
* Should it page next time?

---

## Track Alert Metrics

Measure:

* Alerts per engineer per week
* False positive rate
* Mean time to acknowledge

---

# ⚠️ What NOT to Do

* ❌ Disable all alerts
* ❌ Raise thresholds blindly
* ❌ Page for warnings
* ❌ Ignore burnout signals

---

# 📋 30-Day Burnout Fix Plan

| Week | Action                    |
| ---- | ------------------------- |
| 1    | Audit alerts              |
| 2    | Remove noise              |
| 3    | Implement SLO paging      |
| 4    | Add automation + grouping |

---

# 💡 In Short (Interview Quick Recall)

* Alert only on SLO breaches
* Remove non-actionable alerts
* Add stabilization & grouping
* Separate severity levels
* Automate self-healing

👉 On-call burnout is caused by **alert noise and poor signal quality** — fix monitoring, not people.

---
## Q40: A new regulation requires all infrastructure changes to be reviewed and approved within your company in 24 hours. How do you implement this?

---

### 🧠 Overview

New regulation =

> Every infrastructure change must be reviewed and approved within 24 hours.

This is a **governance + automation + auditability** problem.

The solution is **not** manual ticket approvals.
It must be:

* Automated
* Auditable
* Enforced by pipeline
* Traceable to a human approver

Goal:

1. No infra change without review
2. Approval within 24 hours
3. Full audit trail
4. No slowdown to delivery

---

# 🏗 Target Architecture

```
Terraform PR →
CI: terraform plan →
Plan output stored →
Mandatory approval →
CI: terraform apply →
Audit logs stored
```

All infra changes go through Git.

---

# 🔒 Phase 1: Enforce Infrastructure as Code Only

---

## 1️⃣ Block Manual Console Changes

Use IAM policy:

```json
{
  "Effect": "Deny",
  "Action": [
    "ec2:*",
    "rds:*",
    "s3:*"
  ],
  "Condition": {
    "StringNotEquals": {
      "aws:PrincipalArn": "arn:aws:iam::<account>:role/CI-Role"
    }
  }
}
```

Only CI role can modify infra.

---

# 🔁 Phase 2: Mandatory PR-Based Workflow

---

## 🔹 1️⃣ All Changes via Pull Request

No direct commits to `main`.

Enable:

* Branch protection
* Required reviewers
* Required status checks

---

## 🔹 2️⃣ Terraform Plan in CI

Example pipeline:

```bash
terraform init
terraform plan -out=tfplan
terraform show tfplan > plan.txt
```

Attach `plan.txt` to PR.

Reviewer sees exactly what will change.

---

# 🔥 Phase 3: Enforce 24-Hour Approval SLA

---

## 🔹 1️⃣ Require 2 Approvals

GitHub example:

* Require 2 reviewers
* Code owners enforced

---

## 🔹 2️⃣ Auto-Reminder for Pending PRs

GitHub Action:

* If PR > 12 hours → notify Slack
* If PR > 24 hours → escalate

---

## 🔹 3️⃣ Auto-Close Expired PRs (Optional)

If not approved within 24 hours → close.

Prevents stale infra plans.

---

# 🔐 Phase 4: Approval Gate Before Apply

---

## Example Jenkins:

```groovy
stage('Manual Approval') {
  input message: 'Approve Terraform Apply?'
}
```

Approval recorded in pipeline logs.

---

## Or GitHub Environments

Require:

* Environment approval before deploy

---

# 📜 Phase 5: Full Audit Trail

---

Ensure you log:

* PR author
* PR approver
* Plan output
* Apply logs
* Timestamp

Store:

* Plan artifact in S3
* Pipeline logs in centralized logging

Auditors must see:

| Change | Who Requested | Who Approved | When Applied |
| ------ | ------------- | ------------ | ------------ |

---

# 🔥 Phase 6: Policy-as-Code Enforcement

---

Use:

* Sentinel (Terraform Cloud)
* OPA (Open Policy Agent)
* Checkov in CI

Example rule:

* No public S3
* No open security groups

Fail pipeline before approval if policy violated.

---

# 🔄 Phase 7: Emergency Changes

---

Define separate process:

```
Emergency → Fast approval →
Post-review within 24h →
Document justification
```

Still auditable.

---

# 📊 Process Flow Summary

| Step         | Control          |
| ------------ | ---------------- |
| Dev change   | PR required      |
| Plan         | Auto-generated   |
| Review       | 2 approvals      |
| Approval SLA | 24-hour enforced |
| Apply        | CI only          |
| Logging      | Full audit trail |

---

# 🛡 Additional Safeguards

---

## ✅ Separate Prod Account

Prod infra changes require:

* Senior approval
* Restricted reviewers

---

## ✅ Change Classification

Label PR:

* Minor change
* Major change
* Destructive change

Major/destructive → additional approval.

---

## ✅ Automated Diff Summary

Generate readable plan summary for reviewers.

---

# ⚠️ What NOT to Do

* ❌ Manual email approvals
* ❌ Verbal approvals
* ❌ Direct console changes
* ❌ Shared admin credentials

---

# 📋 2-Week Implementation Plan

| Week | Action                         |
| ---- | ------------------------------ |
| 1    | Enforce PR + branch protection |
| 2    | Add CI plan + approval gate    |
| 3    | Add audit logging              |
| 4    | Add policy-as-code             |

---

# 💡 In Short (Interview Quick Recall)

* All infra via PR
* Terraform plan auto-generated
* Mandatory reviewer approval
* CI-only apply
* Full audit trail

👉 Regulatory compliance requires **automated review workflows, enforced approvals, and auditable pipelines**, not manual change management.

----
## Q41: You need to design a CI/CD pipeline for a company that has 200 developers, 50 microservices, and 5 environments. How do you approach this?

---

### 🧠 Overview

Scale = **people + services + environments**.

200 developers
50 microservices
5 environments (Dev, QA, Staging, UAT, Prod)

This is not just a pipeline problem — it’s:

* Standardization
* Isolation
* Automation
* Governance
* Observability

Principles:

* One pipeline template
* Service ownership isolation
* Environment promotion model
* Infrastructure as Code
* Strong guardrails

Goal:

* Fast feedback (<15 min CI)
* Safe deployments
* Independent service releases
* Clear environment promotion

---

# 🏗 High-Level Architecture

```
Git (Per Service Repo)
        ↓
Standard CI Template
        ↓
Artifact Registry (ECR/Nexus)
        ↓
Environment Promotion Pipeline
        ↓
Kubernetes (5 Environments)
```

---

# 🔒 Phase 1: Repository & Ownership Model

---

## 🔹 1️⃣ One Repo per Microservice

Avoid monolithic repo.

Structure:

```
service-a/
service-b/
...
```

Each team owns:

* Code
* CI config
* Deployment manifest

---

## 🔹 2️⃣ Centralized CI Template

Instead of 50 custom pipelines, use shared template.

Example (GitHub Actions):

```yaml
uses: org/ci-template/.github/workflows/build.yaml@v1
```

Standardizes:

* Build
* Test
* Scan
* Docker build
* Push to registry

---

# 🚀 Phase 2: CI Pipeline Design (Fast Feedback)

---

Pipeline Stages:

```text
1. Lint
2. Unit Test
3. Security Scan (SAST + SCA)
4. Build Docker Image
5. Push to Registry
6. Publish Artifact
```

Must complete in <15 minutes.

Fail fast.

---

# 🔁 Phase 3: Environment Promotion Strategy

---

Use **Promotion-Based CD**, not rebuild per environment.

Flow:

```
Dev → QA → Staging → UAT → Prod
```

Artifact built once.

Promoted, not rebuilt.

---

## 🔹 Immutable Artifact Pattern

Tag image:

```
service-a:1.3.5
```

Promote same image across environments.

---

# 🔥 Phase 4: Deployment Strategy

---

# 🔹 Kubernetes per Environment

Namespaces:

```
dev/
qa/
staging/
uat/
prod/
```

Or separate clusters for prod.

---

# 🔹 GitOps for Deployment (Recommended)

Use:

* ArgoCD
* Flux

Flow:

```
Merge to env branch →
Argo sync →
Deploy automatically
```

Provides:

* Audit trail
* Rollback
* Drift detection

---

# 🔐 Phase 5: Governance & Control

---

## 🔹 Branch Protection

* No direct push to main
* 2 reviewers required
* Passing CI required

---

## 🔹 Production Approval Gate

Before prod deploy:

* Manual approval
* Change log attached

---

## 🔹 Policy-as-Code

Check:

* No public S3
* No open security groups
* Resource limits enforced

---

# 🔥 Phase 6: Scaling CI Infrastructure

---

200 developers = high concurrency.

Use:

* Auto-scaling runners (Kubernetes-based runners)
* Spot instances for CI
* Ephemeral runners

Avoid static Jenkins masters overloaded.

---

# 📊 Phase 7: Deployment Strategies

---

## For Microservices:

* Rolling updates
* Canary releases
* Blue/Green (for critical services)

Example (K8s):

```yaml
strategy:
  rollingUpdate:
    maxUnavailable: 10%
    maxSurge: 20%
```

---

# 🔎 Phase 8: Observability Integration

---

Pipeline must publish:

* Build duration
* Deployment success rate
* Rollback rate

Track DORA metrics:

* Deployment frequency
* Lead time
* MTTR
* Change failure rate

---

# 📦 Phase 9: Secrets & Configuration

---

Use:

* AWS Secrets Manager
* SSM Parameter Store
* Vault

Never store secrets in pipeline.

---

# 📊 CI/CD Architecture Summary

| Layer      | Strategy                  |
| ---------- | ------------------------- |
| Code       | Repo per service          |
| CI         | Shared template           |
| Artifact   | Immutable versioned image |
| CD         | Promotion model           |
| Deploy     | GitOps                    |
| Governance | PR + approval gates       |
| Scaling    | Auto-scaling runners      |

---

# ⚠️ What NOT to Do

* ❌ One giant shared pipeline
* ❌ Rebuild per environment
* ❌ Manual deployments
* ❌ Shared state files
* ❌ No approval for prod

---

# 📋 Rollout Plan

| Month   | Focus                 |
| ------- | --------------------- |
| Month 1 | CI standardization    |
| Month 2 | Environment promotion |
| Month 3 | GitOps adoption       |
| Month 4 | Governance & metrics  |

---

# 💡 In Short (Interview Quick Recall)

* One pipeline template for all services
* Immutable artifact promotion
* GitOps-based deployments
* Separate environments
* Strong governance + auto-scaling CI

👉 At scale (200 devs, 50 services), CI/CD must be **standardized, isolated, automated, and governed**, not custom per team.

----
## Q42: Your company wants to move from a monolithic deployment to blue-green deployments for zero downtime. How do you implement this?

---

### 🧠 Overview

Blue-Green Deployment =

> Two identical production environments.
> One live (Blue), one idle (Green).
> Switch traffic instantly after validation.

Benefits:

* Zero downtime
* Instant rollback
* Safer releases

Works well for:

* Monolith apps
* Stateful APIs (with DB backward compatibility)
* Kubernetes-based workloads

Goal:

* Deploy without impacting users
* Validate before switching
* Roll back instantly if needed

---

# 🏗 High-Level Architecture

```
               Route53 / ALB
                    ↓
           ┌───────────────┐
           │               │
        Blue (v1)       Green (v2)
        Active          Standby
```

Traffic routed via:

* Load balancer target groups
* DNS switch
* Kubernetes Service selector

---

# 🚀 Phase 1: Prepare Infrastructure

---

## 🔹 1️⃣ Duplicate Environment

If on EC2:

* Two Auto Scaling Groups
* Two target groups

If on Kubernetes:

* Two Deployments
* Same Service

Example (K8s):

```yaml
app: my-app
version: blue
```

```yaml
app: my-app
version: green
```

---

# 🔹 2️⃣ Load Balancer Setup (AWS ALB)

Create:

* TargetGroup-Blue
* TargetGroup-Green

ALB routes to only one at a time.

Switch via:

```bash
aws elbv2 modify-listener \
  --listener-arn arn:xxx \
  --default-actions Type=forward,TargetGroupArn=green-target-group
```

Traffic switch is instant.

---

# 🔁 Phase 2: Database Compatibility

---

Critical for monolith.

Must ensure:

* Backward-compatible schema
* No destructive migrations during switch

Use:

* Expand → Migrate → Contract pattern

Never deploy breaking DB changes in same release.

---

# 🔁 Phase 3: CI/CD Pipeline Integration

---

Pipeline flow:

```text
1. Build
2. Test
3. Deploy to Green
4. Smoke Test Green
5. Switch traffic
6. Monitor
7. Keep Blue as rollback
```

Example pipeline snippet:

```groovy
stage('Deploy Green') {
  sh 'kubectl apply -f green.yaml'
}
```

---

# 🔎 Phase 4: Health Validation

---

Before switching traffic:

* Health checks pass
* Smoke tests pass
* p95 latency acceptable
* No 5xx spike

Example smoke test:

```bash
curl https://green.example.com/health
```

---

# 🔥 Phase 5: Traffic Switch

---

## Kubernetes Method

Change service selector:

```bash
kubectl patch service my-app \
  -p '{"spec":{"selector":{"version":"green"}}}'
```

Instant switch.

---

## ALB Method

Switch target group.

---

# 🔄 Phase 6: Monitoring After Switch

---

Monitor for:

* Error rate
* Latency
* CPU
* DB load

Example:

```promql
rate(http_requests_total{status=~"5.."}[5m])
```

If issue → revert traffic to Blue immediately.

Rollback is instant.

---

# 🔒 Phase 7: Cleanup

After confidence period:

* Terminate old Blue
* Rename Green → Blue
* Prepare next release

---

# 📊 Blue-Green vs Rolling

| Feature    | Blue-Green | Rolling   |
| ---------- | ---------- | --------- |
| Downtime   | Zero       | Near-zero |
| Rollback   | Instant    | Slower    |
| Infra Cost | Higher     | Lower     |
| Risk       | Lower      | Medium    |

---

# 🛡 Advanced Option: Combine with Canary

Instead of full switch:

* Route 10% to Green
* Validate
* Then 100%

Using:

* ALB weighted routing
* Istio traffic splitting

---

# ⚠️ What NOT to Do

* ❌ Switch without health validation
* ❌ Break DB compatibility
* ❌ Rebuild environment manually
* ❌ Delete old version immediately

---

# 📋 Implementation Plan

| Week   | Focus                       |
| ------ | --------------------------- |
| Week 1 | Duplicate infra + LB config |
| Week 2 | Update pipeline             |
| Week 3 | Test in staging             |
| Week 4 | First production blue-green |

---

# 💡 In Short (Interview Quick Recall)

* Maintain two identical environments
* Deploy to idle environment
* Validate health
* Switch traffic instantly
* Keep old version for rollback

👉 Blue-Green enables **true zero-downtime deployments with instant rollback**, especially useful for monolithic applications transitioning to safer release models.

----
## Q43: Design a disaster recovery strategy for a system with an RTO of 15 minutes and RPO of 5 minutes.

---

### 🧠 Overview

Requirements:

* **RTO (Recovery Time Objective): 15 minutes** → System must be fully operational within 15 minutes after failure.
* **RPO (Recovery Point Objective): 5 minutes** → Maximum acceptable data loss is 5 minutes.

This eliminates:

* Backup & restore only strategies
* Manual rebuild
* Single-region setups

You need:

> Warm standby or active-active multi-region architecture with near real-time replication.

Goal:

* Automated failover
* Continuous data replication
* Minimal manual intervention
* Regular DR testing

---

# 🏗 Recommended Architecture: Warm Standby Multi-Region

```
                 Route53 (Health Check + Failover)
                          ↓
          ┌──────────────────────────────┐
          │                              │
     Primary Region                  Secondary Region
     (Active)                        (Warm Standby)
          │                              │
       ALB + EKS                      ALB + EKS (scaled down)
          │                              │
     RDS Primary                   RDS Cross-Region Replica
          │                              │
     S3 + ECR (CRR)                S3 + ECR Replica
```

---

# 🔁 Data Layer Strategy (Critical for RPO 5 min)

---

## 🔹 Database

### Option A: Aurora Global Database (Best)

* Cross-region replication < 1 second
* Fast failover (<1 minute)

### Option B: RDS Cross-Region Read Replica

```bash
aws rds create-db-instance-read-replica \
  --source-db-instance-identifier prod-db
```

Promote during failover:

```bash
aws rds promote-read-replica
```

Replication lag must stay < 5 minutes.

---

## 🔹 Object Storage

Enable S3 Cross-Region Replication:

```bash
aws s3api put-bucket-replication ...
```

---

## 🔹 Container Images

Enable ECR cross-region replication.

---

# 🔁 Compute Layer Strategy

---

## 🔹 Kubernetes / EC2

Secondary region:

* Cluster pre-provisioned via Terraform
* Smaller instance size (warm standby)
* Scaled down replicas

Scale up during failover.

---

## 🔹 Infrastructure as Code

All infra defined in Terraform:

```hcl
provider "aws" {
  alias  = "secondary"
  region = "us-west-2"
}
```

Reproducible environments.

---

# 🔥 Failover Process (Must Meet 15 Min RTO)

---

## Step 1️⃣ Detect Outage

* Route53 health check fails
* Monitoring alert triggers

---

## Step 2️⃣ Promote Database

If using replica:

```bash
aws rds promote-read-replica
```

---

## Step 3️⃣ Scale Secondary Cluster

```bash
kubectl scale deployment app --replicas=10
```

Or increase ASG capacity:

```bash
aws autoscaling update-auto-scaling-group ...
```

---

## Step 4️⃣ DNS Failover

Route53 failover routing policy:

* Primary record
* Secondary record

Automatic switch within ~1–2 minutes.

---

## Step 5️⃣ Validate System

* Smoke tests
* Health endpoints
* Error rate check

Total time target: < 15 minutes.

---

# 🔒 Automation is Mandatory

Manual failover likely exceeds 15 minutes.

Use:

* Lambda for automated DB promotion
* Predefined runbook
* Infrastructure alarms trigger automation

---

# 📊 DR Strategy Comparison

| Strategy         | RTO        | RPO       | Meets Requirement? |
| ---------------- | ---------- | --------- | ------------------ |
| Backup & Restore | Hours      | Hours     | ❌                  |
| Pilot Light      | 30–60 mins | Low       | ❌                  |
| Warm Standby     | <15 mins   | <5 mins   | ✅                  |
| Active-Active    | Near-zero  | Near-zero | ✅                  |

Warm standby recommended for cost balance.

---

# 🔎 Monitoring Requirements

Monitor:

* Replication lag:

```promql
rds_replica_lag_seconds
```

* Health checks
* Application SLO

Alert if replication lag > 5 min.

---

# 🔄 Testing Strategy (Critical)

Quarterly DR test:

1. Simulate region failure
2. Promote secondary
3. Switch traffic
4. Validate system
5. Document results

Without testing → RTO target unreliable.

---

# 🛡 Additional Hardening

---

## ✅ Use Multi-AZ in Primary

Protect against AZ-level failure.

---

## ✅ Store Terraform State Cross-Region

Avoid single-region state dependency.

---

## ✅ Centralized Logging Across Regions

Ensure logs accessible during outage.

---

# 📋 Disaster Recovery Playbook

| Step | Action                  |
| ---- | ----------------------- |
| 1    | Detect outage           |
| 2    | Promote replica         |
| 3    | Scale secondary compute |
| 4    | Switch DNS              |
| 5    | Validate app            |
| 6    | Notify stakeholders     |

---

# ⚠️ What NOT to Do

* ❌ Rely only on Multi-AZ
* ❌ Assume manual failover is fast
* ❌ Skip replication monitoring
* ❌ Avoid DR testing

---

# 💡 In Short (Interview Quick Recall)

* Use warm standby multi-region
* Cross-region DB replication (<5 min lag)
* Automated DNS failover
* Pre-provisioned secondary cluster
* Regular DR testing

👉 RTO 15 min + RPO 5 min requires **multi-region replication + automated failover**, not backup-based recovery.

---
## Q44: Your startup is growing from 10 to 200 engineers in one year. How do you scale your DevOps practices and infrastructure?

---

### 🧠 Overview

Scaling from 10 → 200 engineers is not just infra scaling. It’s:

* Process scaling
* Platform standardization
* Governance automation
* Self-service enablement

If you don’t standardize early:

> You’ll get pipeline chaos, environment drift, security issues, and deployment conflicts.

Goal:

* Enable autonomy
* Maintain guardrails
* Standardize patterns
* Avoid bottlenecks

Principle:

> Build a **platform team** and treat infrastructure as a product.

---

# 🏗 Phase 1: Standardize Foundations (Months 1–3)

---

# 🔹 1️⃣ Infrastructure as Code Mandatory

All infra via Terraform.

Structure:

```
modules/
environments/
platform/
```

Enforce:

* No manual console changes
* Remote state + locking

---

# 🔹 2️⃣ Standard CI/CD Template

Create reusable template:

```yaml
uses: org/ci-template/.github/workflows/build.yaml@v1
```

All 50+ services inherit same build pattern.

Prevents pipeline sprawl.

---

# 🔹 3️⃣ Define Golden Path

Document:

* How to create a new service
* How to deploy
* How to monitor
* Security requirements

Make onboarding simple.

---

# 🚀 Phase 2: Build a Platform Engineering Model

---

## Create a Platform Team

Responsibilities:

* CI/CD platform
* Kubernetes clusters
* Observability
* Security guardrails
* Cost optimization

Product mindset:

* Internal developer platform (IDP)

---

# 🔥 Phase 3: Self-Service Infrastructure

---

# 🔹 1️⃣ Service Templates

New microservice template:

* Dockerfile
* CI config
* Helm chart
* Monitoring config

Developers bootstrap service in 10 minutes.

---

# 🔹 2️⃣ Environment Provisioning Automation

Create dev environment via:

```bash
make create-service
```

Or internal portal.

Avoid manual infra requests.

---

# 🔐 Phase 4: Governance at Scale

---

# 🔹 1️⃣ Multi-Account Strategy

Use AWS Organizations:

```
Dev
QA
Staging
Prod
Sandbox
```

Prevent cross-environment risk.

---

# 🔹 2️⃣ RBAC & Role Separation

Developers:

* Deploy to dev
* PR-based promotion to prod

Prod deploy requires approval.

---

# 🔹 3️⃣ Policy-as-Code

Enforce:

* No public S3
* No open security groups
* Resource limits mandatory

Fail CI if violated.

---

# 📦 Phase 5: Kubernetes Scaling

---

# 🔹 1️⃣ Namespace Per Team

```
team-a/
team-b/
```

Isolation prevents cross-impact.

---

# 🔹 2️⃣ Resource Quotas

```yaml
limits:
  cpu: "20"
  memory: "40Gi"
```

Avoid noisy neighbors.

---

# 🔹 3️⃣ Cluster Autoscaler

Auto-scale nodes for growing workload.

---

# 🔎 Phase 6: Observability Standardization

---

Every service must include:

* Structured logging
* Metrics endpoint
* Tracing instrumentation

Deploy:

* Prometheus
* Grafana
* OpenTelemetry

No service goes live without monitoring.

---

# 📊 Phase 7: Deployment & Release Maturity

---

Implement:

* Trunk-based development
* Feature flags
* Blue/Green or Canary
* Automated rollback

Track DORA metrics.

---

# 🔥 Phase 8: Cost & Efficiency Controls

---

## Implement:

* Rightsizing reviews
* Spot for non-prod
* Lifecycle policies
* Budget alerts

Growing team → growing waste risk.

---

# 📋 Growth Scaling Strategy

| Area         | Control                   |
| ------------ | ------------------------- |
| CI/CD        | Shared templates          |
| Infra        | IaC only                  |
| Environments | Multi-account             |
| Security     | Policy-as-code            |
| Deployments  | GitOps                    |
| Monitoring   | Mandatory instrumentation |
| Access       | RBAC                      |

---

# 🔄 Cultural Scaling

---

## 🔹 Documentation

Everything documented:

* Deployment guide
* Incident runbook
* Architecture patterns

---

## 🔹 Developer Enablement

* Internal workshops
* Platform documentation
* Slack support channel

---

# ⚠️ What NOT to Do

* ❌ Allow custom pipelines per team
* ❌ Allow console infra changes
* ❌ Delay governance until later
* ❌ Make DevOps a ticket-based bottleneck

---

# 📈 Target Model at 200 Engineers

```
Developers → Self-Service Platform →
Standard CI/CD →
GitOps →
Multi-Account Infra →
Central Observability →
Automated Guardrails
```

---

# 💡 In Short (Interview Quick Recall)

* Standardize everything early
* Build platform team
* Enforce IaC + CI templates
* Multi-account isolation
* Self-service with guardrails

👉 Scaling DevOps from 10 → 200 engineers requires **platform engineering, automation, and governance at scale**, not just more servers.

----
## Q45: You need to implement GitOps for a team that has never used it before. How do you plan and execute the migration?

---

### 🧠 Overview

GitOps =

> Git is the single source of truth for infrastructure and application state.
> The cluster reconciles itself automatically to match Git.

Benefits:

* Auditability
* Versioned deployments
* Rollback via Git revert
* No manual kubectl in prod
* Reduced configuration drift

Goal:

1. Remove manual deployments
2. Make Git authoritative
3. Automate reconciliation
4. Train the team gradually

Principle:

> Start small → Prove value → Standardize → Enforce.

---

# 🏗 Target Architecture

```
Developer → PR → Merge →
Git Repo (Manifests/Helm) →
ArgoCD / Flux →
Kubernetes Cluster →
Reconciliation Loop
```

---

# 🚀 Phase 1: Preparation (Week 1)

---

## 🔹 1️⃣ Choose GitOps Tool

Recommended:

* ArgoCD (most common)
* Flux (lightweight)

Install ArgoCD:

```bash
kubectl create namespace argocd
helm install argocd argo/argo-cd -n argocd
```

---

## 🔹 2️⃣ Separate App Code from Deployment Config

Structure:

```
app-repo/
config-repo/
```

Config repo contains:

* Helm values
* K8s manifests
* Environment configs

This keeps GitOps clean.

---

# 🔁 Phase 2: Pilot Migration (Week 2)

---

## 🔹 1️⃣ Select 1 Non-Critical Service

Do NOT migrate everything at once.

---

## 🔹 2️⃣ Move Deployment to GitOps

Example Argo Application:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
spec:
  source:
    repoURL: https://github.com/org/config-repo
    path: services/service-a
  destination:
    namespace: service-a
```

Apply once:

```bash
kubectl apply -f application.yaml
```

From now on:

* No manual kubectl
* No manual helm install

---

# 🔎 Phase 3: CI/CD Integration

---

Update pipeline:

Instead of:

```bash
kubectl apply -f deployment.yaml
```

Do:

```bash
git commit -am "Update image tag"
git push
```

ArgoCD detects change → deploys automatically.

---

# 🔥 Phase 4: Environment Structure

---

Use Git branches or directories:

```
config-repo/
 ├── dev/
 ├── qa/
 ├── staging/
 └── prod/
```

Each environment controlled by separate Argo Application.

---

# 🔐 Phase 5: Governance & Guardrails

---

## 🔹 1️⃣ Remove Manual Cluster Access

Developers:

* No direct prod kubectl
* Deploy via Git only

Enforce RBAC:

```bash
kubectl create role ...
```

---

## 🔹 2️⃣ Require PR Review for Prod Changes

Branch protection:

* 2 approvals required
* CI validation required

---

# 🔁 Phase 6: Drift Detection

---

Argo automatically detects:

* Manual changes
* Configuration drift

Set:

```yaml
syncPolicy:
  automated:
    prune: true
    selfHeal: true
```

Cluster reverts manual changes.

---

# 🔥 Phase 7: Rollout Strategy

---

## Gradual Migration

| Week   | Action                               |
| ------ | ------------------------------------ |
| Week 1 | Install Argo + training              |
| Week 2 | Migrate 1 service                    |
| Week 3 | Migrate 5 services                   |
| Week 4 | Migrate all services                 |
| Week 5 | Remove manual deployment permissions |

---

# 🔒 Phase 8: Observability Integration

---

Monitor:

* Sync status
* Deployment failures
* Drift events

Alert on:

```promql
argocd_app_health_status != "Healthy"
```

---

# 📊 GitOps vs Traditional CD

| Feature            | Traditional     | GitOps     |
| ------------------ | --------------- | ---------- |
| Deployment trigger | CI pipeline     | Git commit |
| Source of truth    | Pipeline config | Git repo   |
| Drift detection    | Manual          | Automatic  |
| Rollback           | Redeploy        | Git revert |

---

# ⚠️ Common Migration Mistakes

* ❌ Migrate everything at once
* ❌ Keep manual kubectl access
* ❌ Mix app code and infra code randomly
* ❌ Skip RBAC enforcement
* ❌ Ignore team training

---

# 🛡 Training & Adoption

---

Provide:

* GitOps workflow documentation
* Example PR templates
* Rollback guide
* “How to debug Argo” guide

Run internal demo session.

---

# 📋 Final GitOps Flow

```
Code change →
Image built →
Update config repo image tag →
PR approved →
Merge →
Argo sync →
Cluster updated
```

No manual apply.

---

# 💡 In Short (Interview Quick Recall)

* Install ArgoCD
* Separate config repo
* Deploy via Git commits
* Enforce RBAC
* Migrate gradually

👉 GitOps migration succeeds when you **start small, enforce Git as the source of truth, remove manual deploys, and educate the team**, not when you flip everything at once.

---
## Q46: Amazon-style: Describe a time when you identified a significant infrastructure problem before it became an incident. What signals did you notice and what did you do?

---

### 🧠 Overview (STAR Approach)

This is a behavioral + technical question.

They want to assess:

* Proactiveness
* Observability maturity
* Ownership
* Risk mitigation
* Preventative mindset

Structure your answer using **STAR**:

* **S**ituation
* **T**ask
* **A**ction
* **R**esult

Below is a production-grade example answer suitable for senior DevOps roles.

---

# 🟦 Example Answer (Production Scenario)

---

## 🟦 Situation

We were running a high-traffic Kubernetes-based microservices platform on AWS EKS.
Traffic was steadily increasing due to new feature adoption.

Although there were no active incidents, I noticed subtle signals in our observability dashboards.

---

## 🟦 Signals I Noticed

1️⃣ Increasing p95 latency (but averages were normal)

```promql
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
```

2️⃣ Gradual rise in DB connection usage (80% of max)

3️⃣ Node memory usage trending upward over 2 weeks

4️⃣ HPA frequently scaling up during peak hours

5️⃣ Replica lag occasionally hitting 3–4 minutes

None triggered alerts yet — but trend analysis showed risk.

---

## 🟦 Risk Identified

Projected traffic growth suggested:

* DB connection pool exhaustion
* Increased tail latency
* Potential cascading failures during peak traffic

Based on trend analysis, the system would likely fail within 2–3 weeks during high load.

---

## 🟦 Actions Taken

---

### 🔹 1️⃣ Capacity Planning Analysis

Exported 30-day metrics and calculated growth trend.

Identified DB as bottleneck.

---

### 🔹 2️⃣ Introduced RDS Proxy

Implemented connection pooling layer:

```bash
aws rds create-db-proxy --db-proxy-name prod-proxy
```

Reduced DB connections by ~40%.

---

### 🔹 3️⃣ Added Read Replica

Shifted read-heavy queries to replica.

Reduced primary DB CPU from 75% → 45%.

---

### 🔹 4️⃣ Tuned HPA to Scale on RPS Instead of CPU

Updated HPA:

```yaml
metrics:
- type: Pods
  pods:
    metric:
      name: http_requests_per_second
```

Improved responsiveness during spikes.

---

### 🔹 5️⃣ Increased Node Group Buffer Capacity

Raised min nodes by 20% to maintain headroom.

---

### 🔹 6️⃣ Added Early-Warning Alerts

Created proactive alerts for:

* DB connections >70%
* Replica lag >2 min
* p95 latency trending upward

---

## 🟦 Result

Two weeks later, traffic increased 2.5x due to a marketing campaign.

Outcome:

* No outage
* No latency degradation
* DB utilization stayed under 60%
* No on-call alerts

The preemptive changes prevented what would likely have been a production incident.

---

# 🧩 Why This Answer Works

It demonstrates:

* Proactive monitoring
* Trend analysis, not reactive firefighting
* Understanding of system bottlenecks
* Ownership without being asked
* Measurable impact

---

# 🔎 Alternative Example Signals You Could Mention

* Increasing retry rates
* Slow memory leak patterns
* Certificate expiring in 30 days
* Increasing pod eviction events
* S3 lifecycle cost growth trend
* NAT gateway traffic spike

---

# 🛡 Key Leadership Principles Demonstrated

* Ownership
* Dive Deep
* Bias for Action
* Insist on High Standards
* Earn Trust

---

# 💡 In Short (Interview Quick Recall)

* I noticed tail latency and DB connection trends rising
* Performed capacity analysis
* Added RDS Proxy + read replica
* Tuned autoscaling
* Prevented outage during traffic spike

👉 Strong answer shows **proactive detection, data-driven action, and measurable impact before failure occurred.**

----
## Q47: Google-style: You have a service with five nines (99.999%) availability requirement. Design the deployment and operational strategy to achieve this.

---

### 🧠 Overview

99.999% availability = **5 minutes 15 seconds downtime per year**.

That eliminates:

* Single region
* Manual failover
* Monthly maintenance windows
* Risky deployments

To achieve 5 nines, you need:

> Redundancy + automation + fault isolation + SRE discipline.

This is not just infra design — it’s **operational excellence**.

---

# 📊 What 99.999% Means

| Availability | Downtime per Year |
| ------------ | ----------------- |
| 99.9%        | 8h 45m            |
| 99.99%       | 52m               |
| **99.999%**  | **~5m**           |

Even small deployment mistakes break this target.

---

# 🏗 Architecture Strategy (Multi-Region Active-Active)

```
                Global Load Balancer
                       ↓
      ┌─────────────────────────────────┐
      │                                 │
 Region A (Active)                Region B (Active)
      │                                 │
   EKS Cluster                        EKS Cluster
      │                                 │
   DB Cluster (Global Replication)
```

---

# 🔒 1️⃣ Multi-Region Active-Active

* Traffic split across 2+ regions
* Automatic failover (Route53 / Global Accelerator)
* Health checks every 10–30 seconds

No warm standby. Both regions serve traffic.

---

# 🗄 2️⃣ Data Layer Strategy

---

## 🔹 Use Globally Replicated Database

Options:

* Aurora Global Database
* Spanner-style distributed DB
* DynamoDB Global Tables

Must provide:

* <1 min replication lag
* Fast failover

Avoid:

* Manual replica promotion

---

# ⚙️ 3️⃣ Deployment Strategy

---

## 🔹 Use Canary or Blue-Green (Never Rolling Directly)

Example:

```
Deploy to 1% traffic →
Monitor →
Increase to 10% →
Then 100%
```

Rollback automatically on:

```promql
rate(http_requests_total{status=~"5.."}[2m]) > threshold
```

---

## 🔹 One Region at a Time

Never deploy both regions simultaneously.

Deploy Region A → validate → then Region B.

Prevents global outage.

---

# 🔁 4️⃣ SLO & Error Budget Management

---

Define SLO:

* 99.999% availability

Track error budget:

```
Allowed downtime = ~5 mins/year
```

If error budget burns fast:

* Freeze risky deployments
* Increase reliability focus

---

# 🔥 5️⃣ Failure Isolation

---

## 🔹 Cell-Based Architecture

Instead of one giant cluster:

```
Cell 1
Cell 2
Cell 3
```

Each cell handles subset of traffic.

Failure impacts only 5–10% users.

---

## 🔹 Bulkheads & Circuit Breakers

Prevent cascading failure.

---

# 🚀 6️⃣ Autoscaling & Capacity Headroom

---

Never run near 100%.

Maintain:

* 30% spare capacity
* Pre-warmed nodes

Scaling must happen before saturation.

---

# 🛡 7️⃣ Deployment Safety Controls

---

## Mandatory:

* Feature flags
* Progressive rollouts
* Automatic rollback
* Chaos testing before production

---

# 🔎 8️⃣ Observability Requirements

---

Must monitor:

* p99 latency
* Error rate per region
* Replication lag
* Saturation
* Dependency health

Alert only on SLO breach.

---

# 🔄 9️⃣ Disaster Recovery Strategy

---

RTO: < 1 minute
RPO: near zero

Automated region failover.

Regular DR tests (quarterly).

---

# 🔐 10️⃣ Change Management Discipline

---

Rules:

* No Friday deploys
* No simultaneous infra + app change
* No manual console changes
* Everything via CI/CD

---

# 📊 Strategy Summary

| Area        | Requirement for 5 Nines    |
| ----------- | -------------------------- |
| Region      | Multi-region active-active |
| Database    | Global replication         |
| Deployments | Canary + region stagger    |
| Scaling     | Proactive headroom         |
| Isolation   | Cell-based                 |
| Monitoring  | SLO-based                  |
| Recovery    | Automated failover         |

---

# ⚠️ What Breaks 5 Nines

* Single region
* Manual failover
* DB replica lag
* Long GC pauses
* Retry storms
* Simultaneous multi-region deploy
* Human-in-the-loop recovery

---

# 📋 Operational Discipline Model

| Layer  | Protection         |
| ------ | ------------------ |
| Infra  | Multi-region       |
| App    | Circuit breakers   |
| Data   | Global replication |
| Deploy | Canary + rollback  |
| Ops    | SLO enforcement    |

---

# 💡 In Short (Interview Quick Recall)

* Active-active multi-region
* Globally replicated DB
* Canary deployments (one region at a time)
* SLO-driven operations
* Automated failover

👉 Five nines is achieved through **redundancy, automation, failure isolation, and strict deployment discipline**, not just more servers.

---
## Q48: Netflix-style: How would you implement chaos engineering in a production environment to improve system resilience without causing actual outages?

---

### 🧠 Overview

Chaos Engineering =

> Proactively injecting controlled failure into production to validate system resilience.

Key principle (Netflix-style):

* Small blast radius
* Controlled experiments
* Measurable hypothesis
* Abort if SLO impacted

Goal:

* Discover hidden weaknesses
* Validate auto-healing
* Strengthen fault tolerance
* Avoid real customer impact

---

# 🏗 Foundational Requirements (Before Chaos)

You must already have:

* Multi-AZ or multi-region architecture
* Auto-scaling
* Circuit breakers
* Health checks
* SLO monitoring
* Automatic rollback

Without these → chaos becomes outage.

---

# 🔬 Phase 1: Define Hypothesis (Scientific Approach)

Each experiment must answer:

> “If X fails, system should still maintain SLO.”

Example hypotheses:

* If one pod crashes, traffic reroutes within 10 seconds.
* If one node dies, HPA replaces pods automatically.
* If DB replica fails, read traffic shifts to primary.

Never run chaos without hypothesis.

---

# 🔥 Phase 2: Start Small (Low Blast Radius)

---

## 🔹 1️⃣ Inject Failure in One Pod Only

Example:

```bash
kubectl delete pod app-123
```

Expected:

* Pod recreated
* No SLO impact
* No alert triggered

---

## 🔹 2️⃣ Simulate CPU Spike

```bash
stress --cpu 4 --timeout 60
```

Check:

* HPA scaling response
* Latency impact

---

## 🔹 3️⃣ Simulate Network Latency

Using tc:

```bash
tc qdisc add dev eth0 root netem delay 200ms
```

Validate circuit breakers.

---

# 🛠 Tools for Chaos

---

| Tool        | Purpose                 |
| ----------- | ----------------------- |
| Chaos Mesh  | Kubernetes-native chaos |
| LitmusChaos | K8s experiments         |
| Gremlin     | Managed chaos platform  |
| AWS FIS     | AWS fault injection     |

Example AWS FIS experiment:

* Terminate 1 EC2 in ASG
* Validate replacement within SLA

---

# 🔁 Phase 3: Use Guardrails

---

## 🔹 1️⃣ Limit Scope

Target:

* Single namespace
* Single pod
* Single AZ

Never entire cluster.

---

## 🔹 2️⃣ SLO-Based Abort Condition

Before experiment:

Define:

```promql
rate(http_requests_total{status=~"5.."}[2m])
```

If error rate > threshold → auto-stop experiment.

---

## 🔹 3️⃣ Run During Low-Traffic Window

Prefer:

* Business hours with team online
* Not midnight

---

# 🔎 Phase 4: Automate Experiments

---

## Scheduled Chaos

Weekly small experiments.

Example:

* Kill 1 pod every Monday 11 AM

Build muscle memory.

---

# 🔥 Phase 5: Advanced Chaos (Gradual Maturity)

---

## 🔹 AZ Failure Simulation

Disable nodes in one AZ.

Validate:

* Traffic reroutes
* Cluster autoscaler reacts

---

## 🔹 Dependency Failure

Simulate DB timeout.

Validate:

* Circuit breaker
* Retry limits
* Fallback response

---

## 🔹 Regional Failure (Game Day)

Simulate Route53 failover.

Validate:

* RTO achieved
* No manual steps needed

---

# 📊 Chaos Maturity Model

| Level   | Experiment         |
| ------- | ------------------ |
| Level 1 | Pod kill           |
| Level 2 | Node failure       |
| Level 3 | AZ outage          |
| Level 4 | Dependency failure |
| Level 5 | Region failover    |

Gradual progression.

---

# 🔒 Cultural Implementation

---

## 🔹 Document Every Experiment

Include:

* Hypothesis
* Expected outcome
* Observed result
* Improvements needed

---

## 🔹 Run Post-Experiment Review

If weakness found:

* Add fix
* Add monitoring
* Add automation

Chaos is learning tool.

---

# ⚠️ What NOT to Do

* ❌ Random failures without hypothesis
* ❌ Full-cluster kill
* ❌ Run without monitoring
* ❌ Hide experiments from stakeholders

---

# 📋 Safe Chaos Framework

| Step | Action                           |
| ---- | -------------------------------- |
| 1    | Define hypothesis                |
| 2    | Limit blast radius               |
| 3    | Monitor SLO                      |
| 4    | Inject fault                     |
| 5    | Auto-abort if threshold breached |
| 6    | Document findings                |

---

# 🛡 Why Chaos Works

It validates:

* Autoscaling
* Failover automation
* Circuit breakers
* Recovery time
* Team readiness

Without chaos, resilience is assumed — not proven.

---

# 💡 In Short (Interview Quick Recall)

* Define hypothesis first
* Start small (pod-level)
* Use SLO-based aborts
* Automate experiments
* Gradually increase scope

👉 Chaos engineering improves resilience when done **controlled, measurable, and incremental**, not random and destructive.

---
## Q49: Meta-style: Your team owns a service processing 1 million requests per second. A code change needs to go live in 2 hours. Walk through your complete deployment strategy including risk mitigation.

---

### 🧠 Overview

1 million RPS = hyperscale system.

At this scale:

* 0.1% error = 1,000 failures/sec
* Small regression → massive impact
* Deployment mistakes can become global incidents

Principle:

> Progressive, isolated, observable rollout with automatic rollback.

Goals:

* Zero downtime
* Contained blast radius
* Fast detection
* Immediate rollback capability

---

# 🏗 Baseline Assumptions

Before deploying at this scale, the system must have:

* Multi-region active-active
* Canary deployment capability
* Feature flags
* Real-time SLO monitoring
* Automated rollback
* Error budget policy

Without these → high risk.

---

# 🚀 Phase 1: Pre-Deployment Validation (T - 2 Hours)

---

## 🔹 1️⃣ Full CI Validation

* Unit tests
* Integration tests
* Load test (simulate 1M RPS)
* Security scan
* Performance regression check

Critical check:

```promql
p99_latency_baseline
```

Compare with staging results.

---

## 🔹 2️⃣ Staging Load Test at Scale

Run production-like load:

```bash
k6 run --vus 10000 --duration 10m load-test.js
```

Validate:

* p99 latency
* Memory usage
* GC behavior
* Thread pool saturation

---

## 🔹 3️⃣ Verify Backward Compatibility

* DB migrations non-breaking
* API contract unchanged
* Feature flag off by default

---

# 🔥 Phase 2: Deployment Strategy (Progressive Rollout)

---

# 🔹 1️⃣ Deploy to Single Cell / Shard

If using cell-based architecture:

```
Cell 1 → 1% traffic
```

Never global first.

---

# 🔹 2️⃣ Canary Release (1%)

Route 1% traffic to new version.

Using:

* Istio traffic split
* ALB weighted routing
* Envoy

Example:

```yaml
weight: 1
```

Monitor for 5–10 minutes.

---

# 🔎 Phase 3: Real-Time Monitoring During Canary

---

Monitor:

* p99 latency
* Error rate
* CPU
* Memory
* Retry rate
* Dependency errors

Example:

```promql
rate(http_requests_total{status=~"5.."}[1m])
```

Abort threshold:

* Error rate increase > 0.05%
* p99 latency +10%

---

# 🔁 Phase 4: Gradual Traffic Increase

---

If stable:

```
1% → 5% → 10% → 25% → 50% → 100%
```

Each stage:

* 5–15 min observation
* Manual + automated review

Never jump directly to 100%.

---

# 🌍 Phase 5: Region-by-Region Rollout

---

Deploy in one region only.

If stable → deploy next region.

Never deploy all regions simultaneously.

---

# 🔐 Phase 6: Risk Mitigation Controls

---

## 🔹 Feature Flag Safety

Keep new logic behind flag.

If issue:

```
Toggle flag off instantly
```

No redeploy required.

---

## 🔹 Automated Rollback

If:

```promql
error_rate > threshold
```

Auto:

```bash
kubectl rollout undo deployment/service
```

Rollback must complete < 2 minutes.

---

## 🔹 Capacity Headroom

Ensure:

* 30% spare capacity
* No scaling events during deploy

Avoid autoscaler interference.

---

# 📊 Deployment Guardrails

| Guardrail       | Why                   |
| --------------- | --------------------- |
| Canary 1%       | Limit blast radius    |
| Cell isolation  | Contain failures      |
| Region stagger  | Prevent global outage |
| Feature flags   | Instant disable       |
| SLO-based abort | Fast detection        |
| Auto rollback   | Reduce MTTR           |

---

# 🔥 Phase 7: Post-Deployment Validation

---

After 100% rollout:

* Monitor for 30–60 minutes
* Check long-tail latency
* Check DB replication lag
* Check cache hit ratio

---

# ⚠️ Failure Scenario Handling

If canary shows regression:

* Stop traffic increase
* Rollback immediately
* Root cause analysis
* Hotfix behind flag

No prolonged partial rollout.

---

# 🛡 Why This Strategy Works at 1M RPS

Because:

* Failure impact scales exponentially
* Even small regressions are amplified
* Progressive rollout limits damage

---

# 📋 Deployment Timeline (2 Hours)

| Time   | Action                   |
| ------ | ------------------------ |
| T-120m | Final tests + validation |
| T-90m  | Deploy to 1 cell (1%)    |
| T-75m  | Increase to 5%           |
| T-60m  | Increase to 10%          |
| T-45m  | Increase to 25%          |
| T-30m  | Increase to 50%          |
| T-15m  | Full rollout region      |
| T-0    | Expand to other regions  |

Abort anytime if SLO breach.

---

# 💡 In Short (Interview Quick Recall)

* Validate thoroughly in staging
* Deploy to 1% canary
* Monitor p99 + error rate
* Increase traffic gradually
* Region-by-region rollout
* Automated rollback + feature flags

👉 At 1M RPS, safe deployment requires **progressive rollout, strict SLO monitoring, isolation, and instant rollback**, not confidence in the code alone.

---
## Q50: Microsoft-style: A customer is experiencing an issue that you cannot reproduce in any non-production environment. How do you safely debug this in production while minimizing customer impact?

---

### 🧠 Overview

Production-only bug =

* Scale-related
* Data-specific
* Region-specific
* Timing/race condition
* Configuration drift
* External dependency behavior

Constraint:

> You must debug in production without impacting customers.

Principles:

* Observe first, change last
* Isolate customer context
* Use controlled instrumentation
* Avoid broad experiments

Goal:

* Identify root cause
* Minimize blast radius
* Avoid downtime

---

# 🔎 Phase 1: Confirm and Scope the Problem

---

## 🔹 1️⃣ Identify Impact Scope

Questions:

* Single customer or many?
* Specific region?
* Specific API?
* Specific request pattern?

Use filtered logs:

```bash
grep customer_id=123 production.log
```

Or query:

```promql
rate(http_requests_total{customer="123",status=~"5.."}[5m])
```

Determine if isolated.

---

# 🔍 Phase 2: Increase Observability (Without Changing Behavior)

---

## 🔹 1️⃣ Enable Targeted Debug Logging

Do NOT enable global debug logging.

Instead:

* Enable log level for specific customer ID
* Enable log level for specific instance

Example:

```
if (customerId == "123") enableDebug();
```

---

## 🔹 2️⃣ Add Temporary Metrics

Expose custom metric:

```bash
error_condition_counter{customer="123"}
```

Track behavior in real-time.

---

## 🔹 3️⃣ Use Distributed Tracing

Capture trace for specific request:

```
X-Debug-Trace: true
```

Inspect span latency.

---

# 🔁 Phase 3: Safe Reproduction in Production

---

## 🔹 1️⃣ Replay Traffic in Isolated Instance

Spin up one debug replica:

```bash
kubectl scale deployment app --replicas=+1
```

Route only affected customer traffic using:

* Header-based routing
* Canary routing (1% traffic)

Using Istio:

```yaml
match:
  headers:
    customer:
      exact: "123"
```

---

## 🔹 2️⃣ Shadow Traffic (If Needed)

Duplicate production traffic to:

* Debug environment
* Isolated namespace

Without affecting live responses.

---

# 🔥 Phase 4: Hypothesis Testing (Controlled)

---

Instead of random changes:

Test hypothesis in isolated instance:

* Increase timeout
* Adjust config
* Disable feature flag

Only for targeted traffic.

---

# 🛡 Phase 5: Protect Customer Experience

---

## 🔹 Feature Flags

Wrap potential fix:

```
if (flag_enabled) new_logic();
```

Enable only for affected customer.

---

## 🔹 Circuit Breakers

If dependency suspected:

Fail fast instead of slow failure.

---

## 🔹 Rate Limiting

If issue tied to high request rate.

---

# 📊 Phase 6: Compare Production vs Non-Prod

Look for differences:

| Area         | Check                      |
| ------------ | -------------------------- |
| Data         | Large dataset? Edge cases? |
| Config       | Env vars different?        |
| Traffic      | Higher concurrency?        |
| Dependencies | Prod-only endpoints?       |
| Caching      | Cache invalidation issues? |

Often production has:

* Larger dataset
* Real concurrency
* Different timeout values

---

# 🔄 Phase 7: Safe Fix Rollout

---

Once root cause identified:

* Deploy fix to 1% traffic
* Monitor SLO
* Expand gradually

Rollback plan ready.

---

# 🔐 Guardrails During Debugging

---

| Control         | Purpose               |
| --------------- | --------------------- |
| Scoped logging  | Avoid overload        |
| Canary routing  | Isolate change        |
| Feature flag    | Instant rollback      |
| Monitoring      | Detect regression     |
| No global debug | Prevent system impact |

---

# ⚠️ What NOT to Do

* ❌ Enable debug logs globally
* ❌ Restart entire cluster
* ❌ Apply fix directly to 100% traffic
* ❌ Modify database manually without validation

---

# 📋 Production Debug Strategy Summary

| Step | Action                         |
| ---- | ------------------------------ |
| 1    | Scope issue                    |
| 2    | Add targeted logging           |
| 3    | Trace specific requests        |
| 4    | Route traffic to debug replica |
| 5    | Test hypothesis safely         |
| 6    | Roll out fix gradually         |

---

# 💡 In Short (Interview Quick Recall)

* Scope impact first
* Add targeted observability
* Route affected traffic to isolated replica
* Test via feature flags
* Roll out fix gradually

👉 Safe production debugging requires **isolation, controlled experimentation, and strict blast-radius management**, not risky live experimentation.
