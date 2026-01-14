# 50 Top Python Scripting Questions & Answers for SRE/DevOps Interviews

## **System Monitoring & Health Checks**

### 1. Monitor CPU, Memory, and Disk Usage
```python
import psutil

def system_monitor():
    cpu = psutil.cpu_percent(interval=1)
    memory = psutil.virtual_memory().percent
    disk = psutil.disk_usage('/').percent
    
    print(f"CPU Usage: {cpu}%")
    print(f"Memory Usage: {memory}%")
    print(f"Disk Usage: {disk}%")
    
    # Alert if thresholds exceeded
    if cpu > 80 or memory > 80 or disk > 80:
        print("⚠️ Alert: Resource usage critical!")
    
system_monitor()
```

### 2. Check Service Status and Restart if Down
```python
import subprocess

def check_and_restart_service(service_name):
    try:
        result = subprocess.run(['systemctl', 'is-active', service_name], 
                              capture_output=True, text=True)
        
        if result.stdout.strip() != 'active':
            print(f"{service_name} is down. Restarting...")
            subprocess.run(['sudo', 'systemctl', 'restart', service_name])
            print(f"{service_name} restarted successfully")
        else:
            print(f"{service_name} is running")
    except Exception as e:
        print(f"Error: {e}")

check_and_restart_service('nginx')
```

### 3. Monitor Disk Space and Send Alerts
```python
import psutil
import smtplib
from email.mime.text import MIMEText

def monitor_disk_space(threshold=80):
    partitions = psutil.disk_partitions()
    
    for partition in partitions:
        usage = psutil.disk_usage(partition.mountpoint)
        percent = usage.percent
        
        if percent > threshold:
            alert_message = f"Disk {partition.mountpoint} is {percent}% full!"
            print(alert_message)
            # send_email_alert(alert_message)  # Uncomment to send email
        else:
            print(f"Disk {partition.mountpoint}: {percent}% used")

monitor_disk_space()
```

### 4. Check Network Connectivity
```python
import socket

def check_host_connectivity(host, port):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(5)
        result = sock.connect_ex((host, port))
        sock.close()
        
        if result == 0:
            print(f"✓ {host}:{port} is reachable")
            return True
        else:
            print(f"✗ {host}:{port} is not reachable")
            return False
    except Exception as e:
        print(f"Error checking {host}:{port} - {e}")
        return False

# Check multiple services
hosts = [
    ('google.com', 80),
    ('localhost', 8080),
    ('database.example.com', 5432)
]

for host, port in hosts:
    check_host_connectivity(host, port)
```

### 5. Monitor Process and Restart if Not Running
```python
import psutil
import subprocess

def monitor_process(process_name, restart_command):
    running = False
    
    for proc in psutil.process_iter(['name']):
        if process_name in proc.info['name']:
            running = True
            print(f"✓ {process_name} is running (PID: {proc.pid})")
            break
    
    if not running:
        print(f"✗ {process_name} not found. Restarting...")
        subprocess.run(restart_command, shell=True)

monitor_process('nginx', 'sudo systemctl restart nginx')
```

## **Log Analysis & Processing**

### 6. Parse and Analyze Log Files
```python
import re
from collections import Counter

def analyze_logs(log_file):
    error_pattern = r'ERROR|CRITICAL|FATAL'
    errors = []
    
    with open(log_file, 'r') as f:
        for line in f:
            if re.search(error_pattern, line, re.IGNORECASE):
                errors.append(line.strip())
    
    # Count error frequency
    error_counts = Counter(errors)
    
    print(f"Total errors found: {len(errors)}")
    print("\nTop 5 most frequent errors:")
    for error, count in error_counts.most_common(5):
        print(f"{count}x: {error[:100]}...")

analyze_logs('/var/log/application.log')
```

### 7. Real-time Log Monitoring (Tail -f equivalent)
```python
import time

def tail_log(file_path, interval=1):
    with open(file_path, 'r') as f:
        # Move to end of file
        f.seek(0, 2)
        
        while True:
            line = f.readline()
            if line:
                print(line.strip())
            else:
                time.sleep(interval)

tail_log('/var/log/syslog')
```

### 8. Extract and Count HTTP Status Codes from Access Logs
```python
import re
from collections import Counter

def analyze_access_log(log_file):
    status_pattern = r'\s(\d{3})\s'
    status_codes = []
    
    with open(log_file, 'r') as f:
        for line in f:
            match = re.search(status_pattern, line)
            if match:
                status_codes.append(match.group(1))
    
    # Count status codes
    status_counts = Counter(status_codes)
    
    print("HTTP Status Code Distribution:")
    for code, count in sorted(status_counts.items()):
        print(f"{code}: {count} requests")
    
    # Calculate error rate
    total = len(status_codes)
    errors = sum(count for code, count in status_counts.items() 
                 if code.startswith('4') or code.startswith('5'))
    error_rate = (errors / total * 100) if total > 0 else 0
    
    print(f"\nError Rate: {error_rate:.2f}%")

analyze_access_log('/var/log/nginx/access.log')
```

### 9. Filter Logs by Time Range
```python
from datetime import datetime

def filter_logs_by_time(log_file, start_time, end_time):
    # Assuming log format: 2025-01-14 10:30:45 - Message
    filtered_logs = []
    
    with open(log_file, 'r') as f:
        for line in f:
            try:
                timestamp_str = line[:19]  # Extract timestamp
                log_time = datetime.strptime(timestamp_str, '%Y-%m-%d %H:%M:%S')
                
                if start_time <= log_time <= end_time:
                    filtered_logs.append(line.strip())
            except ValueError:
                continue
    
    return filtered_logs

start = datetime(2025, 1, 14, 10, 0, 0)
end = datetime(2025, 1, 14, 12, 0, 0)
logs = filter_logs_by_time('app.log', start, end)
print(f"Found {len(logs)} logs in time range")
```

### 10. Aggregate and Summarize Log Errors
```python
import re
from collections import defaultdict

def summarize_errors(log_file):
    error_summary = defaultdict(list)
    
    with open(log_file, 'r') as f:
        for line in f:
            if 'ERROR' in line or 'EXCEPTION' in line:
                # Extract error type
                match = re.search(r'([\w.]+Exception|[\w.]+Error)', line)
                if match:
                    error_type = match.group(1)
                    error_summary[error_type].append(line.strip())
    
    print("Error Summary:")
    for error_type, occurrences in error_summary.items():
        print(f"\n{error_type}: {len(occurrences)} occurrences")
        print(f"  First occurrence: {occurrences[0][:100]}...")

summarize_errors('application.log')
```

## **File Operations & Management**

### 11. Search for Files Recursively
```python
import os

def find_files(directory, pattern):
    matches = []
    
    for root, dirs, files in os.walk(directory):
        for file in files:
            if pattern in file:
                full_path = os.path.join(root, file)
                matches.append(full_path)
    
    return matches

# Find all Python files
python_files = find_files('/home/user/projects', '.py')
print(f"Found {len(python_files)} Python files")
for file in python_files[:10]:  # Show first 10
    print(file)
```

### 12. Backup Files with Timestamp
```python
import shutil
from datetime import datetime
import os

def backup_file(source_file, backup_dir):
    if not os.path.exists(backup_dir):
        os.makedirs(backup_dir)
    
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    filename = os.path.basename(source_file)
    backup_name = f"{filename}.{timestamp}.bak"
    backup_path = os.path.join(backup_dir, backup_name)
    
    shutil.copy2(source_file, backup_path)
    print(f"Backup created: {backup_path}")
    return backup_path

backup_file('/etc/nginx/nginx.conf', '/backup/nginx')
```

### 13. Clean Up Old Log Files
```python
import os
import time

def cleanup_old_files(directory, days_old=30):
    now = time.time()
    cutoff = now - (days_old * 86400)  # Convert days to seconds
    
    deleted_files = []
    
    for root, dirs, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            if os.path.getmtime(file_path) < cutoff:
                os.remove(file_path)
                deleted_files.append(file_path)
                print(f"Deleted: {file_path}")
    
    print(f"\nTotal files deleted: {len(deleted_files)}")

cleanup_old_files('/var/log/old_logs', days_old=30)
```

### 14. Compare Two Configuration Files
```python
import difflib

def compare_files(file1, file2):
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        lines1 = f1.readlines()
        lines2 = f2.readlines()
    
    diff = difflib.unified_diff(lines1, lines2, 
                                fromfile=file1, tofile=file2, lineterm='')
    
    differences = list(diff)
    
    if differences:
        print(f"Differences found between {file1} and {file2}:")
        for line in differences:
            print(line)
    else:
        print("Files are identical")

compare_files('/etc/nginx/nginx.conf', '/etc/nginx/nginx.conf.backup')
```

### 15. Archive and Compress Logs
```python
import tarfile
import os
from datetime import datetime

def archive_logs(log_dir, archive_dir):
    if not os.path.exists(archive_dir):
        os.makedirs(archive_dir)
    
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    archive_name = f"logs_{timestamp}.tar.gz"
    archive_path = os.path.join(archive_dir, archive_name)
    
    with tarfile.open(archive_path, 'w:gz') as tar:
        tar.add(log_dir, arcname=os.path.basename(log_dir))
    
    print(f"Archive created: {archive_path}")
    size_mb = os.path.getsize(archive_path) / (1024 * 1024)
    print(f"Archive size: {size_mb:.2f} MB")

archive_logs('/var/log/application', '/backup/archives')
```

## **API & HTTP Operations**

### 16. Health Check Multiple APIs
```python
import requests
from datetime import datetime

def check_api_health(endpoints):
    results = []
    
    for endpoint in endpoints:
        try:
            start_time = datetime.now()
            response = requests.get(endpoint, timeout=5)
            response_time = (datetime.now() - start_time).total_seconds()
            
            status = "✓ UP" if response.status_code == 200 else "✗ DOWN"
            results.append({
                'endpoint': endpoint,
                'status': status,
                'status_code': response.status_code,
                'response_time': response_time
            })
        except requests.exceptions.RequestException as e:
            results.append({
                'endpoint': endpoint,
                'status': '✗ DOWN',
                'error': str(e)
            })
    
    for result in results:
        print(f"{result['status']} - {result['endpoint']}")
        if 'response_time' in result:
            print(f"  Response time: {result['response_time']:.2f}s")
        if 'error' in result:
            print(f"  Error: {result['error']}")

apis = [
    'https://api.github.com',
    'https://jsonplaceholder.typicode.com/posts',
    'http://localhost:8080/health'
]

check_api_health(apis)
```

### 17. API Request with Retry Logic
```python
import requests
import time

def api_request_with_retry(url, max_retries=3, backoff=2):
    for attempt in range(max_retries):
        try:
            response = requests.get(url, timeout=10)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"Attempt {attempt + 1} failed: {e}")
            if attempt < max_retries - 1:
                wait_time = backoff ** attempt
                print(f"Retrying in {wait_time} seconds...")
                time.sleep(wait_time)
            else:
                print("Max retries reached. Giving up.")
                raise

data = api_request_with_retry('https://api.github.com/users/github')
print(f"Successfully retrieved data: {data.get('login')}")
```

### 18. POST Data to API
```python
import requests
import json

def send_metrics_to_api(api_url, metrics_data):
    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_API_TOKEN'
    }
    
    try:
        response = requests.post(api_url, 
                               json=metrics_data, 
                               headers=headers,
                               timeout=10)
        response.raise_for_status()
        
        print(f"✓ Metrics sent successfully")
        print(f"Response: {response.json()}")
    except requests.exceptions.RequestException as e:
        print(f"✗ Failed to send metrics: {e}")

metrics = {
    'cpu_usage': 75.5,
    'memory_usage': 82.3,
    'timestamp': '2025-01-14T10:30:00Z'
}

send_metrics_to_api('https://monitoring.example.com/api/metrics', metrics)
```

### 19. Scrape and Parse HTML Data
```python
import requests
from bs4 import BeautifulSoup

def scrape_status_page(url):
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Example: Extract service statuses
        services = soup.find_all('div', class_='service-status')
        
        for service in services:
            name = service.find('span', class_='name').text
            status = service.find('span', class_='status').text
            print(f"{name}: {status}")
    except Exception as e:
        print(f"Error scraping page: {e}")

scrape_status_page('https://status.example.com')
```

### 20. Webhook Receiver
```python
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/webhook', methods=['POST'])
def webhook():
    data = request.json
    
    # Process webhook data
    event_type = data.get('event')
    print(f"Received webhook: {event_type}")
    print(f"Data: {data}")
    
    # Perform actions based on event
    if event_type == 'deployment':
        # Trigger deployment script
        print("Triggering deployment...")
    elif event_type == 'alert':
        # Send notification
        print("Sending alert notification...")
    
    return jsonify({'status': 'success'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

## **Docker Operations**

### 21. List and Manage Docker Containers
```python
import docker

def manage_containers():
    client = docker.from_env()
    
    # List all containers
    containers = client.containers.list(all=True)
    
    print("Docker Containers:")
    for container in containers:
        print(f"\nName: {container.name}")
        print(f"Status: {container.status}")
        print(f"Image: {container.image.tags}")
        
        # Restart stopped containers
        if container.status == 'exited':
            print(f"Restarting {container.name}...")
            container.start()

manage_containers()
```

### 22. Build and Push Docker Image
```python
import docker

def build_and_push_image(dockerfile_path, image_name, tag='latest'):
    client = docker.from_env()
    
    # Build image
    print(f"Building image {image_name}:{tag}...")
    image, logs = client.images.build(
        path=dockerfile_path,
        tag=f"{image_name}:{tag}",
        rm=True
    )
    
    for log in logs:
        if 'stream' in log:
            print(log['stream'].strip())
    
    # Push to registry
    print(f"Pushing image to registry...")
    for line in client.images.push(image_name, tag=tag, stream=True, decode=True):
        if 'status' in line:
            print(line['status'])

build_and_push_image('.', 'myapp/api', 'v1.0')
```

### 23. Monitor Docker Container Stats
```python
import docker
import time

def monitor_container_stats(container_name, duration=60):
    client = docker.from_env()
    
    try:
        container = client.containers.get(container_name)
        
        print(f"Monitoring {container_name} for {duration} seconds...")
        start_time = time.time()
        
        for stats in container.stats(stream=True):
            # Calculate CPU percentage
            cpu_delta = stats['cpu_stats']['cpu_usage']['total_usage'] - \
                       stats['precpu_stats']['cpu_usage']['total_usage']
            system_delta = stats['cpu_stats']['system_cpu_usage'] - \
                          stats['precpu_stats']['system_cpu_usage']
            cpu_percent = (cpu_delta / system_delta) * 100.0
            
            # Memory usage
            memory_usage = stats['memory_stats']['usage'] / (1024 * 1024)  # MB
            memory_limit = stats['memory_stats']['limit'] / (1024 * 1024)  # MB
            
            print(f"CPU: {cpu_percent:.2f}% | Memory: {memory_usage:.2f}/{memory_limit:.2f} MB")
            
            if time.time() - start_time > duration:
                break
            
            time.sleep(2)
    except docker.errors.NotFound:
        print(f"Container {container_name} not found")

monitor_container_stats('my-app-container', duration=30)
```

### 24. Clean Up Unused Docker Resources
```python
import docker

def cleanup_docker():
    client = docker.from_env()
    
    # Remove stopped containers
    print("Removing stopped containers...")
    pruned_containers = client.containers.prune()
    print(f"Removed {len(pruned_containers['ContainersDeleted'] or [])} containers")
    
    # Remove unused images
    print("\nRemoving unused images...")
    pruned_images = client.images.prune()
    print(f"Freed up {pruned_images['SpaceReclaimed'] / (1024**3):.2f} GB")
    
    # Remove unused volumes
    print("\nRemoving unused volumes...")
    pruned_volumes = client.volumes.prune()
    print(f"Removed {len(pruned_volumes['VolumesDeleted'] or [])} volumes")
    
    # Remove unused networks
    print("\nRemoving unused networks...")
    pruned_networks = client.networks.prune()
    print(f"Removed {len(pruned_networks['NetworksDeleted'] or [])} networks")

cleanup_docker()
```

### 25. Run Container with Environment Variables
```python
import docker

def run_container_with_env(image_name, env_vars, ports=None):
    client = docker.from_env()
    
    # Run container
    container = client.containers.run(
        image_name,
        environment=env_vars,
        ports=ports,
        detach=True,
        name=f"{image_name.split('/')[-1]}-instance"
    )
    
    print(f"Container started: {container.name}")
    print(f"Container ID: {container.short_id}")
    
    # Check container logs
    time.sleep(2)
    logs = container.logs().decode('utf-8')
    print(f"Container logs:\n{logs}")

env = {
    'DATABASE_URL': 'postgresql://localhost:5432/mydb',
    'API_KEY': 'secret-key-123',
    'DEBUG': 'false'
}

ports = {'8080/tcp': 8080}

run_container_with_env('nginx:alpine', env, ports)
```

## **Kubernetes Operations**

### 26. List Pods in Namespace
```python
from kubernetes import client, config

def list_pods(namespace='default'):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    
    print(f"Pods in namespace '{namespace}':")
    pods = v1.list_namespaced_pod(namespace)
    
    for pod in pods.items:
        print(f"\nName: {pod.metadata.name}")
        print(f"Status: {pod.status.phase}")
        print(f"Node: {pod.spec.node_name}")
        print(f"IP: {pod.status.pod_ip}")

list_pods('default')
```

### 27. Scale Deployment
```python
from kubernetes import client, config

def scale_deployment(deployment_name, namespace, replicas):
    config.load_kube_config()
    apps_v1 = client.AppsV1Api()
    
    # Get current deployment
    deployment = apps_v1.read_namespaced_deployment(deployment_name, namespace)
    
    # Update replicas
    deployment.spec.replicas = replicas
    
    # Patch deployment
    apps_v1.patch_namespaced_deployment(deployment_name, namespace, deployment)
    
    print(f"Scaled {deployment_name} to {replicas} replicas")

scale_deployment('my-app', 'default', 5)
```

### 28. Check Pod Logs
```python
from kubernetes import client, config

def get_pod_logs(pod_name, namespace='default', tail_lines=100):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    
    try:
        logs = v1.read_namespaced_pod_log(
            name=pod_name,
            namespace=namespace,
            tail_lines=tail_lines
        )
        
        print(f"Logs for pod '{pod_name}':")
        print(logs)
        return logs
    except client.exceptions.ApiException as e:
        print(f"Error retrieving logs: {e}")

get_pod_logs('my-app-pod-12345', 'default')
```

### 29. Create ConfigMap
```python
from kubernetes import client, config

def create_configmap(name, namespace, data):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    
    configmap = client.V1ConfigMap(
        api_version='v1',
        kind='ConfigMap',
        metadata=client.V1ObjectMeta(name=name),
        data=data
    )
    
    try:
        v1.create_namespaced_config_map(namespace, configmap)
        print(f"ConfigMap '{name}' created successfully")
    except client.exceptions.ApiException as e:
        if e.status == 409:
            print(f"ConfigMap '{name}' already exists")
        else:
            print(f"Error creating ConfigMap: {e}")

config_data = {
    'database.url': 'postgresql://db:5432/mydb',
    'app.environment': 'production',
    'log.level': 'info'
}

create_configmap('app-config', 'default', config_data)
```

### 30. Rolling Restart Deployment
```python
from kubernetes import client, config
from datetime import datetime

def rolling_restart(deployment_name, namespace='default'):
    config.load_kube_config()
    apps_v1 = client.AppsV1Api()
    
    # Get deployment
    deployment = apps_v1.read_namespaced_deployment(deployment_name, namespace)
    
    # Update annotation to trigger restart
    if deployment.spec.template.metadata.annotations is None:
        deployment.spec.template.metadata.annotations = {}
    
    deployment.spec.template.metadata.annotations['kubectl.kubernetes.io/restartedAt'] = \
        datetime.now().isoformat()
    
    # Patch deployment
    apps_v1.patch_namespaced_deployment(deployment_name, namespace, deployment)
    
    print(f"Rolling restart initiated for {deployment_name}")

rolling_restart('my-app-deployment', 'default')
```

## **AWS Automation with Boto3**

### 31. List EC2 Instances
```python
import boto3

def list_ec2_instances(region='us-east-1'):
    ec2 = boto3.client('ec2', region_name=region)
    
    response = ec2.describe_instances()
    
    print(f"EC2 Instances in {region}:")
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            instance_type = instance['InstanceType']
            state = instance['State']['Name']
            
            # Get name tag
            name = 'N/A'
            if 'Tags' in instance:
                for tag in instance['Tags']:
                    if tag['Key'] == 'Name':
                        name = tag['Value']
            
            print(f"\nName: {name}")
            print(f"ID: {instance_id}")
            print(f"Type: {instance_type}")
            print(f"State: {state}")

list_ec2_instances()
```

### 32. Start/Stop EC2 Instances
```python
import boto3

def manage_ec2_instance(instance_id, action, region='us-east-1'):
    ec2 = boto3.client('ec2', region_name=region)
    
    if action == 'start':
        ec2.start_instances(InstanceIds=[instance_id])
        print(f"Starting instance {instance_id}")
    elif action == 'stop':
        ec2.stop_instances(InstanceIds=[instance_id])
        print(f"Stopping instance {instance_id}")
    elif action == 'terminate':
        ec2.terminate_instances(InstanceIds=[instance_id])
        print(f"Terminating instance {instance_id}")
    else:
        print(f"Invalid action: {action}")

manage_ec2_instance('i-1234567890abcdef0', 'stop')
```

### 33. Backup to S3
```python
import boto3
import os

def backup_to_s3(file_path, bucket_name, s3_key=None):
    s3 = boto3.client('s3')
    
    if s3_key is None:
        s3_key = os.path.basename(file_path)
    
    try:
        s3.upload_file(file_path, bucket_name, s3_key)
        print(f"✓ Uploaded {file_path} to s3://{bucket_name}/{s3_key}")
    except Exception as e:
        print(f"✗ Error uploading to S3: {e}")

backup_to_s3('/var/log/app.log', 'my-backup-bucket', 'logs/app.log')
```

### 34. List and Clean Old S3 Objects
```python
import boto3
from datetime import datetime, timedelta

def cleanup_old_s3_objects(bucket_name, days_old=30):
    s3 = boto3.client('s3')
    
    cutoff_date = datetime.now() - timedelta(days=days_old)
    
    response = s3.list_objects_v2(Bucket=bucket_name)
    
    if 'Contents' not in response:
        print(f"No objects in bucket {bucket_name}")
        return
    
    deleted_count = 0
    
    for obj in response['Contents']:
        if obj['LastModified'].replace(tzinfo=None) < cutoff_date:
            s3.delete_object(Bucket=bucket_name, Key=obj['Key'])
            print(f"Deleted: {obj['Key']}")
            deleted_count += 1
    
    print(f"\nTotal objects deleted: {deleted_count}")

cleanup_old_s3_objects('my-backup-bucket', days_old=90)
```

### 35. Monitor CloudWatch Metrics
```python
import boto3
from datetime import datetime, timedelta

def get_cloudwatch_metrics(instance_id, metric_name='CPUUtilization'):
    cloudwatch = boto3.client('cloudwatch')
    
    end_time = datetime.utcnow()
    start_time = end_time - timedelta(hours=1)
    
    response = cloudwatch.get_metric_statistics(
        Namespace='AWS/EC2',
        MetricName=metric_name,
        Dimensions=[{'Name': 'InstanceId', 'Value': instance_id}],
        StartTime=start_time,
        EndTime=end_time,
        Period=300,  # 5 minutes
        Statistics=['Average']
    )

# 50 Top Python Scripting Questions & Answers for SRE/DevOps Interviews

## **System Monitoring & Health Checks**

### 1. Monitor CPU, Memory, and Disk Usage
```python
import psutil

def system_monitor():
    cpu = psutil.cpu_percent(interval=1)
    memory = psutil.virtual_memory().percent
    disk = psutil.disk_usage('/').percent
    
    print(f"CPU Usage: {cpu}%")
    print(f"Memory Usage: {memory}%")
    print(f"Disk Usage: {disk}%")
    
    # Alert if thresholds exceeded
    if cpu > 80 or memory > 80 or disk > 80:
        print("⚠️ Alert: Resource usage critical!")
    
system_monitor()
```

### 2. Check Service Status and Restart if Down
```python
import subprocess

def check_and_restart_service(service_name):
    try:
        result = subprocess.run(['systemctl', 'is-active', service_name], 
                              capture_output=True, text=True)
        
        if result.stdout.strip() != 'active':
            print(f"{service_name} is down. Restarting...")
            subprocess.run(['sudo', 'systemctl', 'restart', service_name])
            print(f"{service_name} restarted successfully")
        else:
            print(f"{service_name} is running")
    except Exception as e:
        print(f"Error: {e}")

check_and_restart_service('nginx')
```

### 3. Monitor Disk Space and Send Alerts
```python
import psutil
import smtplib
from email.mime.text import MIMEText

def monitor_disk_space(threshold=80):
    partitions = psutil.disk_partitions()
    
    for partition in partitions:
        usage = psutil.disk_usage(partition.mountpoint)
        percent = usage.percent
        
        if percent > threshold:
            alert_message = f"Disk {partition.mountpoint} is {percent}% full!"
            print(alert_message)
            # send_email_alert(alert_message)  # Uncomment to send email
        else:
            print(f"Disk {partition.mountpoint}: {percent}% used")

monitor_disk_space()
```

### 4. Check Network Connectivity
```python
import socket

def check_host_connectivity(host, port):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(5)
        result = sock.connect_ex((host, port))
        sock.close()
        
        if result == 0:
            print(f"✓ {host}:{port} is reachable")
            return True
        else:
            print(f"✗ {host}:{port} is not reachable")
            return False
    except Exception as e:
        print(f"Error checking {host}:{port} - {e}")
        return False

# Check multiple services
hosts = [
    ('google.com', 80),
    ('localhost', 8080),
    ('database.example.com', 5432)
]

for host, port in hosts:
    check_host_connectivity(host, port)
```

### 5. Monitor Process and Restart if Not Running
```python
import psutil
import subprocess

def monitor_process(process_name, restart_command):
    running = False
    
    for proc in psutil.process_iter(['name']):
        if process_name in proc.info['name']:
            running = True
            print(f"✓ {process_name} is running (PID: {proc.pid})")
            break
    
    if not running:
        print(f"✗ {process_name} not found. Restarting...")
        subprocess.run(restart_command, shell=True)

monitor_process('nginx', 'sudo systemctl restart nginx')
```

## **Log Analysis & Processing**

### 6. Parse and Analyze Log Files
```python
import re
from collections import Counter

def analyze_logs(log_file):
    error_pattern = r'ERROR|CRITICAL|FATAL'
    errors = []
    
    with open(log_file, 'r') as f:
        for line in f:
            if re.search(error_pattern, line, re.IGNORECASE):
                errors.append(line.strip())
    
    # Count error frequency
    error_counts = Counter(errors)
    
    print(f"Total errors found: {len(errors)}")
    print("\nTop 5 most frequent errors:")
    for error, count in error_counts.most_common(5):
        print(f"{count}x: {error[:100]}...")

analyze_logs('/var/log/application.log')
```

### 7. Real-time Log Monitoring (Tail -f equivalent)
```python
import time

def tail_log(file_path, interval=1):
    with open(file_path, 'r') as f:
        # Move to end of file
        f.seek(0, 2)
        
        while True:
            line = f.readline()
            if line:
                print(line.strip())
            else:
                time.sleep(interval)

tail_log('/var/log/syslog')
```

### 8. Extract and Count HTTP Status Codes from Access Logs
```python
import re
from collections import Counter

def analyze_access_log(log_file):
    status_pattern = r'\s(\d{3})\s'
    status_codes = []
    
    with open(log_file, 'r') as f:
        for line in f:
            match = re.search(status_pattern, line)
            if match:
                status_codes.append(match.group(1))
    
    # Count status codes
    status_counts = Counter(status_codes)
    
    print("HTTP Status Code Distribution:")
    for code, count in sorted(status_counts.items()):
        print(f"{code}: {count} requests")
    
    # Calculate error rate
    total = len(status_codes)
    errors = sum(count for code, count in status_counts.items() 
                 if code.startswith('4') or code.startswith('5'))
    error_rate = (errors / total * 100) if total > 0 else 0
    
    print(f"\nError Rate: {error_rate:.2f}%")

analyze_access_log('/var/log/nginx/access.log')
```

### 9. Filter Logs by Time Range
```python
from datetime import datetime

def filter_logs_by_time(log_file, start_time, end_time):
    # Assuming log format: 2025-01-14 10:30:45 - Message
    filtered_logs = []
    
    with open(log_file, 'r') as f:
        for line in f:
            try:
                timestamp_str = line[:19]  # Extract timestamp
                log_time = datetime.strptime(timestamp_str, '%Y-%m-%d %H:%M:%S')
                
                if start_time <= log_time <= end_time:
                    filtered_logs.append(line.strip())
            except ValueError:
                continue
    
    return filtered_logs

start = datetime(2025, 1, 14, 10, 0, 0)
end = datetime(2025, 1, 14, 12, 0, 0)
logs = filter_logs_by_time('app.log', start, end)
print(f"Found {len(logs)} logs in time range")
```

### 10. Aggregate and Summarize Log Errors
```python
import re
from collections import defaultdict

def summarize_errors(log_file):
    error_summary = defaultdict(list)
    
    with open(log_file, 'r') as f:
        for line in f:
            if 'ERROR' in line or 'EXCEPTION' in line:
                # Extract error type
                match = re.search(r'([\w.]+Exception|[\w.]+Error)', line)
                if match:
                    error_type = match.group(1)
                    error_summary[error_type].append(line.strip())
    
    print("Error Summary:")
    for error_type, occurrences in error_summary.items():
        print(f"\n{error_type}: {len(occurrences)} occurrences")
        print(f"  First occurrence: {occurrences[0][:100]}...")

summarize_errors('application.log')
```

## **File Operations & Management**

### 11. Search for Files Recursively
```python
import os

def find_files(directory, pattern):
    matches = []
    
    for root, dirs, files in os.walk(directory):
        for file in files:
            if pattern in file:
                full_path = os.path.join(root, file)
                matches.append(full_path)
    
    return matches

# Find all Python files
python_files = find_files('/home/user/projects', '.py')
print(f"Found {len(python_files)} Python files")
for file in python_files[:10]:  # Show first 10
    print(file)
```

### 12. Backup Files with Timestamp
```python
import shutil
from datetime import datetime
import os

def backup_file(source_file, backup_dir):
    if not os.path.exists(backup_dir):
        os.makedirs(backup_dir)
    
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    filename = os.path.basename(source_file)
    backup_name = f"{filename}.{timestamp}.bak"
    backup_path = os.path.join(backup_dir, backup_name)
    
    shutil.copy2(source_file, backup_path)
    print(f"Backup created: {backup_path}")
    return backup_path

backup_file('/etc/nginx/nginx.conf', '/backup/nginx')
```

### 13. Clean Up Old Log Files
```python
import os
import time

def cleanup_old_files(directory, days_old=30):
    now = time.time()
    cutoff = now - (days_old * 86400)  # Convert days to seconds
    
    deleted_files = []
    
    for root, dirs, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            if os.path.getmtime(file_path) < cutoff:
                os.remove(file_path)
                deleted_files.append(file_path)
                print(f"Deleted: {file_path}")
    
    print(f"\nTotal files deleted: {len(deleted_files)}")

cleanup_old_files('/var/log/old_logs', days_old=30)
```

### 14. Compare Two Configuration Files
```python
import difflib

def compare_files(file1, file2):
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        lines1 = f1.readlines()
        lines2 = f2.readlines()
    
    diff = difflib.unified_diff(lines1, lines2, 
                                fromfile=file1, tofile=file2, lineterm='')
    
    differences = list(diff)
    
    if differences:
        print(f"Differences found between {file1} and {file2}:")
        for line in differences:
            print(line)
    else:
        print("Files are identical")

compare_files('/etc/nginx/nginx.conf', '/etc/nginx/nginx.conf.backup')
```

### 15. Archive and Compress Logs
```python
import tarfile
import os
from datetime import datetime

def archive_logs(log_dir, archive_dir):
    if not os.path.exists(archive_dir):
        os.makedirs(archive_dir)
    
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    archive_name = f"logs_{timestamp}.tar.gz"
    archive_path = os.path.join(archive_dir, archive_name)
    
    with tarfile.open(archive_path, 'w:gz') as tar:
        tar.add(log_dir, arcname=os.path.basename(log_dir))
    
    print(f"Archive created: {archive_path}")
    size_mb = os.path.getsize(archive_path) / (1024 * 1024)
    print(f"Archive size: {size_mb:.2f} MB")

archive_logs('/var/log/application', '/backup/archives')
```

## **API & HTTP Operations**

### 16. Health Check Multiple APIs
```python
import requests
from datetime import datetime

def check_api_health(endpoints):
    results = []
    
    for endpoint in endpoints:
        try:
            start_time = datetime.now()
            response = requests.get(endpoint, timeout=5)
            response_time = (datetime.now() - start_time).total_seconds()
            
            status = "✓ UP" if response.status_code == 200 else "✗ DOWN"
            results.append({
                'endpoint': endpoint,
                'status': status,
                'status_code': response.status_code,
                'response_time': response_time
            })
        except requests.exceptions.RequestException as e:
            results.append({
                'endpoint': endpoint,
                'status': '✗ DOWN',
                'error': str(e)
            })
    
    for result in results:
        print(f"{result['status']} - {result['endpoint']}")
        if 'response_time' in result:
            print(f"  Response time: {result['response_time']:.2f}s")
        if 'error' in result:
            print(f"  Error: {result['error']}")

apis = [
    'https://api.github.com',
    'https://jsonplaceholder.typicode.com/posts',
    'http://localhost:8080/health'
]

check_api_health(apis)
```

### 17. API Request with Retry Logic
```python
import requests
import time

def api_request_with_retry(url, max_retries=3, backoff=2):
    for attempt in range(max_retries):
        try:
            response = requests.get(url, timeout=10)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"Attempt {attempt + 1} failed: {e}")
            if attempt < max_retries - 1:
                wait_time = backoff ** attempt
                print(f"Retrying in {wait_time} seconds...")
                time.sleep(wait_time)
            else:
                print("Max retries reached. Giving up.")
                raise

data = api_request_with_retry('https://api.github.com/users/github')
print(f"Successfully retrieved data: {data.get('login')}")
```

### 18. POST Data to API
```python
import requests
import json

def send_metrics_to_api(api_url, metrics_data):
    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_API_TOKEN'
    }
    
    try:
        response = requests.post(api_url, 
                               json=metrics_data, 
                               headers=headers,
                               timeout=10)
        response.raise_for_status()
        
        print(f"✓ Metrics sent successfully")
        print(f"Response: {response.json()}")
    except requests.exceptions.RequestException as e:
        print(f"✗ Failed to send metrics: {e}")

metrics = {
    'cpu_usage': 75.5,
    'memory_usage': 82.3,
    'timestamp': '2025-01-14T10:30:00Z'
}

send_metrics_to_api('https://monitoring.example.com/api/metrics', metrics)
```

### 19. Scrape and Parse HTML Data
```python
import requests
from bs4 import BeautifulSoup

def scrape_status_page(url):
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Example: Extract service statuses
        services = soup.find_all('div', class_='service-status')
        
        for service in services:
            name = service.find('span', class_='name').text
            status = service.find('span', class_='status').text
            print(f"{name}: {status}")
    except Exception as e:
        print(f"Error scraping page: {e}")

scrape_status_page('https://status.example.com')
```

### 20. Webhook Receiver
```python
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/webhook', methods=['POST'])
def webhook():
    data = request.json
    
    # Process webhook data
    event_type = data.get('event')
    print(f"Received webhook: {event_type}")
    print(f"Data: {data}")
    
    # Perform actions based on event
    if event_type == 'deployment':
        # Trigger deployment script
        print("Triggering deployment...")
    elif event_type == 'alert':
        # Send notification
        print("Sending alert notification...")
    
    return jsonify({'status': 'success'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

## **Docker Operations**

### 21. List and Manage Docker Containers
```python
import docker

def manage_containers():
    client = docker.from_env()
    
    # List all containers
    containers = client.containers.list(all=True)
    
    print("Docker Containers:")
    for container in containers:
        print(f"\nName: {container.name}")
        print(f"Status: {container.status}")
        print(f"Image: {container.image.tags}")
        
        # Restart stopped containers
        if container.status == 'exited':
            print(f"Restarting {container.name}...")
            container.start()

manage_containers()
```

### 22. Build and Push Docker Image
```python
import docker

def build_and_push_image(dockerfile_path, image_name, tag='latest'):
    client = docker.from_env()
    
    # Build image
    print(f"Building image {image_name}:{tag}...")
    image, logs = client.images.build(
        path=dockerfile_path,
        tag=f"{image_name}:{tag}",
        rm=True
    )
    
    for log in logs:
        if 'stream' in log:
            print(log['stream'].strip())
    
    # Push to registry
    print(f"Pushing image to registry...")
    for line in client.images.push(image_name, tag=tag, stream=True, decode=True):
        if 'status' in line:
            print(line['status'])

build_and_push_image('.', 'myapp/api', 'v1.0')
```

### 23. Monitor Docker Container Stats
```python
import docker
import time

def monitor_container_stats(container_name, duration=60):
    client = docker.from_env()
    
    try:
        container = client.containers.get(container_name)
        
        print(f"Monitoring {container_name} for {duration} seconds...")
        start_time = time.time()
        
        for stats in container.stats(stream=True):
            # Calculate CPU percentage
            cpu_delta = stats['cpu_stats']['cpu_usage']['total_usage'] - \
                       stats['precpu_stats']['cpu_usage']['total_usage']
            system_delta = stats['cpu_stats']['system_cpu_usage'] - \
                          stats['precpu_stats']['system_cpu_usage']
            cpu_percent = (cpu_delta / system_delta) * 100.0
            
            # Memory usage
            memory_usage = stats['memory_stats']['usage'] / (1024 * 1024)  # MB
            memory_limit = stats['memory_stats']['limit'] / (1024 * 1024)  # MB
            
            print(f"CPU: {cpu_percent:.2f}% | Memory: {memory_usage:.2f}/{memory_limit:.2f} MB")
            
            if time.time() - start_time > duration:
                break
            
            time.sleep(2)
    except docker.errors.NotFound:
        print(f"Container {container_name} not found")

monitor_container_stats('my-app-container', duration=30)
```

### 24. Clean Up Unused Docker Resources
```python
import docker

def cleanup_docker():
    client = docker.from_env()
    
    # Remove stopped containers
    print("Removing stopped containers...")
    pruned_containers = client.containers.prune()
    print(f"Removed {len(pruned_containers['ContainersDeleted'] or [])} containers")
    
    # Remove unused images
    print("\nRemoving unused images...")
    pruned_images = client.images.prune()
    print(f"Freed up {pruned_images['SpaceReclaimed'] / (1024**3):.2f} GB")
    
    # Remove unused volumes
    print("\nRemoving unused volumes...")
    pruned_volumes = client.volumes.prune()
    print(f"Removed {len(pruned_volumes['VolumesDeleted'] or [])} volumes")
    
    # Remove unused networks
    print("\nRemoving unused networks...")
    pruned_networks = client.networks.prune()
    print(f"Removed {len(pruned_networks['NetworksDeleted'] or [])} networks")

cleanup_docker()
```

### 25. Run Container with Environment Variables
```python
import docker

def run_container_with_env(image_name, env_vars, ports=None):
    client = docker.from_env()
    
    # Run container
    container = client.containers.run(
        image_name,
        environment=env_vars,
        ports=ports,
        detach=True,
        name=f"{image_name.split('/')[-1]}-instance"
    )
    
    print(f"Container started: {container.name}")
    print(f"Container ID: {container.short_id}")
    
    # Check container logs
    time.sleep(2)
    logs = container.logs().decode('utf-8')
    print(f"Container logs:\n{logs}")

env = {
    'DATABASE_URL': 'postgresql://localhost:5432/mydb',
    'API_KEY': 'secret-key-123',
    'DEBUG': 'false'
}

ports = {'8080/tcp': 8080}

run_container_with_env('nginx:alpine', env, ports)
```

## **Kubernetes Operations**

### 26. List Pods in Namespace
```python
from kubernetes import client, config

def list_pods(namespace='default'):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    
    print(f"Pods in namespace '{namespace}':")
    pods = v1.list_namespaced_pod(namespace)
    
    for pod in pods.items:
        print(f"\nName: {pod.metadata.name}")
        print(f"Status: {pod.status.phase}")
        print(f"Node: {pod.spec.node_name}")
        print(f"IP: {pod.status.pod_ip}")

list_pods('default')
```

### 27. Scale Deployment
```python
from kubernetes import client, config

def scale_deployment(deployment_name, namespace, replicas):
    config.load_kube_config()
    apps_v1 = client.AppsV1Api()
    
    # Get current deployment
    deployment = apps_v1.read_namespaced_deployment(deployment_name, namespace)
    
    # Update replicas
    deployment.spec.replicas = replicas
    
    # Patch deployment
    apps_v1.patch_namespaced_deployment(deployment_name, namespace, deployment)
    
    print(f"Scaled {deployment_name} to {replicas} replicas")

scale_deployment('my-app', 'default', 5)
```

### 28. Check Pod Logs
```python
from kubernetes import client, config

def get_pod_logs(pod_name, namespace='default', tail_lines=100):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    
    try:
        logs = v1.read_namespaced_pod_log(
            name=pod_name,
            namespace=namespace,
            tail_lines=tail_lines
        )
        
        print(f"Logs for pod '{pod_name}':")
        print(logs)
        return logs
    except client.exceptions.ApiException as e:
        print(f"Error retrieving logs: {e}")

get_pod_logs('my-app-pod-12345', 'default')
```

### 29. Create ConfigMap
```python
from kubernetes import client, config

def create_configmap(name, namespace, data):
    config.load_kube_config()
    v1 = client.CoreV1Api()
    
    configmap = client.V1ConfigMap(
        api_version='v1',
        kind='ConfigMap',
        metadata=client.V1ObjectMeta(name=name),
        data=data
    )
    
    try:
        v1.create_namespaced_config_map(namespace, configmap)
        print(f"ConfigMap '{name}' created successfully")
    except client.exceptions.ApiException as e:
        if e.status == 409:
            print(f"ConfigMap '{name}' already exists")
        else:
            print(f"Error creating ConfigMap: {e}")

config_data = {
    'database.url': 'postgresql://db:5432/mydb',
    'app.environment': 'production',
    'log.level': 'info'
}

create_configmap('app-config', 'default', config_data)
```

### 30. Rolling Restart Deployment
```python
from kubernetes import client, config
from datetime import datetime

def rolling_restart(deployment_name, namespace='default'):
    config.load_kube_config()
    apps_v1 = client.AppsV1Api()
    
    # Get deployment
    deployment = apps_v1.read_namespaced_deployment(deployment_name, namespace)
    
    # Update annotation to trigger restart
    if deployment.spec.template.metadata.annotations is None:
        deployment.spec.template.metadata.annotations = {}
    
    deployment.spec.template.metadata.annotations['kubectl.kubernetes.io/restartedAt'] = \
        datetime.now().isoformat()
    
    # Patch deployment
    apps_v1.patch_namespaced_deployment(deployment_name, namespace, deployment)
    
    print(f"Rolling restart initiated for {deployment_name}")

rolling_restart('my-app-deployment', 'default')
```

## **AWS Automation with Boto3**

### 31. List EC2 Instances
```python
import boto3

def list_ec2_instances(region='us-east-1'):
    ec2 = boto3.client('ec2', region_name=region)
    
    response = ec2.describe_instances()
    
    print(f"EC2 Instances in {region}:")
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            instance_type = instance['InstanceType']
            state = instance['State']['Name']
            
            # Get name tag
            name = 'N/A'
            if 'Tags' in instance:
                for tag in instance['Tags']:
                    if tag['Key'] == 'Name':
                        name = tag['Value']
            
            print(f"\nName: {name}")
            print(f"ID: {instance_id}")
            print(f"Type: {instance_type}")
            print(f"State: {state}")

list_ec2_instances()
```

### 32. Start/Stop EC2 Instances
```python
import boto3

def manage_ec2_instance(instance_id, action, region='us-east-1'):
    ec2 = boto3.client('ec2', region_name=region)
    
    if action == 'start':
        ec2.start_instances(InstanceIds=[instance_id])
        print(f"Starting instance {instance_id}")
    elif action == 'stop':
        ec2.stop_instances(InstanceIds=[instance_id])
        print(f"Stopping instance {instance_id}")
    elif action == 'terminate':
        ec2.terminate_instances(InstanceIds=[instance_id])
        print(f"Terminating instance {instance_id}")
    else:
        print(f"Invalid action: {action}")

manage_ec2_instance('i-1234567890abcdef0', 'stop')
```

### 33. Backup to S3
```python
import boto3
import os

def backup_to_s3(file_path, bucket_name, s3_key=None):
    s3 = boto3.client('s3')
    
    if s3_key is None:
        s3_key = os.path.basename(file_path)
    
    try:
        s3.upload_file(file_path, bucket_name, s3_key)
        print(f"✓ Uploaded {file_path} to s3://{bucket_name}/{s3_key}")
    except Exception as e:
        print(f"✗ Error uploading to S3: {e}")

backup_to_s3('/var/log/app.log', 'my-backup-bucket', 'logs/app.log')
```

### 34. List and Clean Old S3 Objects
```python
import boto3
from datetime import datetime, timedelta

def cleanup_old_s3_objects(bucket_name, days_old=30):
    s3 = boto3.client('s3')
    
    cutoff_date = datetime.now() - timedelta(days=days_old)
    
    response = s3.list_objects_v2(Bucket=bucket_name)
    
    if 'Contents' not in response:
        print(f"No objects in bucket {bucket_name}")
        return
    
    deleted_count = 0
    
    for obj in response['Contents']:
        if obj['LastModified'].replace(tzinfo=None) < cutoff_date:
            s3.delete_object(Bucket=bucket_name, Key=obj['Key'])
            print(f"Deleted: {obj['Key']}")
            deleted_count += 1
    
    print(f"\nTotal objects deleted: {deleted_count}")

cleanup_old_s3_objects('my-backup-bucket', days_old=90)
```

### 35. Monitor CloudWatch Metrics
```python
import boto3
from datetime import datetime, timedelta

def get_cloudwatch_metrics(instance_id, metric_name='CPUUtilization'):
    cloudwatch = boto3.client('cloudwatch')
    
    end_time = datetime.utcnow()
    start_time = end_time - timedelta(hours=1)
    
    response = cloudwatch.get_metric_statistics(
        Namespace='AWS/EC2',
        MetricName=metric_name,
        Dimensions=[{'Name': 'InstanceId', 'Value': instance_id}],
        StartTime=start_time,
        EndTime=end_time,
        Period=300,  # 5 minutes
        Statistics=['Average']
    )
    
    print(f"{metric_name} for {instance_id}:")
    for datapoint in sorted(response['Datapoints'], key=lambda x: x['Timestamp']):
        timestamp = datapoint['Timestamp'].strftime('%Y-%m-%d %H:%M')
        value = datapoint['Average']
        print(f"{timestamp}: {value:.2f}%")

get_cloudwatch_metrics('i-1234567890abcdef0')
```

## **Database Operations**

### 36. Database Backup Script
```python
import subprocess
from datetime import datetime
import os

def backup_database(db_type, db_name, backup_dir='/backup/databases'):
    if not os.path.exists(backup_dir):
        os.makedirs(backup_dir)
    
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    backup_file = f"{backup_dir}/{db_name}_{timestamp}.sql"
    
    if db_type == 'mysql':
        cmd = f"mysqldump -u root -p {db_name} > {backup_file}"
    elif db_type == 'postgresql':
        cmd = f"pg_dump {db_name} > {backup_file}"
    else:
        print(f"Unsupported database type: {db_type}")
        return
    
    try:
        subprocess.run(cmd, shell=True, check=True)
        print(f"✓ Database backup created: {backup_file}")
        
        # Compress backup
        subprocess.run(f"gzip {backup_file}", shell=True, check=True)
        print(f"✓ Backup compressed: {backup_file}.gz")
    except subprocess.CalledProcessError as e:
        print(f"✗ Backup failed: {e}")

backup_database('postgresql', 'myapp_production')
```

### 37. Check Database Connection Pool
```python
import psycopg2
from psycopg2 import pool

def check_db_connections(db_config):
    try:
        # Create connection pool
        connection_pool = psycopg2.pool.SimpleConnectionPool(
            1, 20,
            user=db_config['user'],
            password=db_config['password'],
            host=db_config['host'],
            port=db_config['port'],
            database=db_config['database']
        )
        
        # Get connection
        conn = connection_pool.getconn()
        cursor = conn.cursor()
        
        # Check active connections
        cursor.execute("""
            SELECT count(*) FROM pg_stat_activity 
            WHERE state = 'active'
        """)
        
        active_connections = cursor.fetchone()[0]
        print(f"Active database connections: {active_connections}")
        
        # Return connection to pool
        connection_pool.putconn(conn)
        connection_pool.closeall()
        
        return active_connections
    except Exception as e:
        print(f"Error checking connections: {e}")

db_config = {
    'user': 'admin',
    'password': 'password',
    'host': 'localhost',
    'port': '5432',
    'database': 'mydb'
}

check_db_connections(db_config)
```

### 38. Execute SQL Query and Export Results
```python
import psycopg2
import csv

def export_query_to_csv(db_config, query, output_file):
    try:
        conn = psycopg2.connect(
            user=db_config['user'],
            password=db_config['password'],
            host=db_config['host'],
            database=db_config['database']
        )
        
        cursor = conn.cursor()
        cursor.execute(query)
        
        # Fetch results
        rows = cursor.fetchall()
        column_names = [desc[0] for desc in cursor.description]
        
        # Write to CSV
        with open(output_file, 'w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(column_names)
            writer.writerows(rows)
        
        print(f"✓ Exported {len(rows)} rows to {output_file}")
        
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"✗ Error exporting data: {e}")

db_config = {'user': 'admin', 'password': 'pass', 'host': 'localhost', 'database': 'mydb'}
query = "SELECT * FROM users WHERE created_at > NOW() - INTERVAL '7 days'"
export_query_to_csv(db_config, query, 'recent_users.csv')
```

### 39. Monitor Database Size and Growth
```python
import psycopg2

def monitor_database_size(db_config):
    try:
        conn = psycopg2.connect(**db_config)
        cursor = conn.cursor()
        
        # Get database size
        cursor.execute("""
            SELECT pg_database.datname, 
                   pg_size_pretty(pg_database_size(pg_database.datname)) AS size
            FROM pg_database
            ORDER BY pg_database_size(pg_database.datname) DESC;
        """)
        
        print("Database Sizes:")
        for db_name, size in cursor.fetchall():
            print(f"{db_name}: {size}")
        
        # Get table sizes
        cursor.execute("""
            SELECT schemaname, tablename,
                   pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
            FROM pg_tables
            WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
            ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC
            LIMIT 10;
        """)
        
        print("\nTop 10 Largest Tables:")
        for schema, table, size in cursor.fetchall():
            print(f"{schema}.{table}: {size}")
        
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

db_config = {'user': 'admin', 'password': 'pass', 'host': 'localhost', 'database': 'mydb'}
monitor_database_size(db_config)
```

### 40. Vacuum and Analyze Database
```python
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

def vacuum_database(db_config, database_name):
    try:
        conn = psycopg2.connect(**db_config)
        conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        cursor = conn.cursor()
        
        print(f"Running VACUUM ANALYZE on {database_name}...")
        cursor.execute("VACUUM ANALYZE;")
        print("✓ VACUUM ANALYZE completed")
        
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"✗ Error: {e}")

db_config = {'user': 'admin', 'password': 'pass', 'host': 'localhost', 'database': 'mydb'}
vacuum_database(db_config, 'mydb')
```

## **Automation & Scheduling**

### 41. Simple Task Scheduler
```python
import schedule
import time

def job_backup():
    print("Running backup job...")
    # Add backup logic here

def job_cleanup():
    print("Running cleanup job...")
    # Add cleanup logic here

def job_health_check():
    print("Running health check...")
    # Add health check logic here

# Schedule jobs
schedule.every().day.at("02:00").do(job_backup)
schedule.every().hour.do(job_health_check)
schedule.every().sunday.at("03:00").do(job_cleanup)

print("Scheduler started. Press Ctrl+C to exit.")

while True:
    schedule.run_pending()
    time.sleep(60)
```

### 42. Parallel Task Execution
```python
from concurrent.futures import ThreadPoolExecutor, as_completed
import requests

def check_url(url):
    try:
        response = requests.get(url, timeout=5)
        return {
            'url': url,
            'status': response.status_code,
            'time': response.elapsed.total_seconds()
        }
    except Exception as e:
        return {'url': url, 'error': str(e)}

def parallel_health_check(urls, max_workers=10):
    results = []
    
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        future_to_url = {executor.submit(check_url, url): url for url in urls}
        
        for future in as_completed(future_to_url):
            result = future.result()
            results.append(result)
            
            if 'error' in result:
                print(f"✗ {result['url']}: {result['error']}")
            else:
                print(f"✓ {result['url']}: {result['status']} ({result['time']:.2f}s)")
    
    return results

urls = [
    'https://google.com',
    'https://github.com',
    'https://stackoverflow.com',
    'https://reddit.com'
]

parallel_health_check(urls)
```

### 43. Retry Decorator
```python
import time
from functools import wraps

def retry(max_attempts=3, delay=1, backoff=2):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            attempts = 0
            current_delay = delay
            
            while attempts < max_attempts:
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    attempts += 1
                    if attempts >= max_attempts:
                        print(f"Max retries reached. Last error: {e}")
                        raise
                    
                    print(f"Attempt {attempts} failed: {e}. Retrying in {current_delay}s...")
                    time.sleep(current_delay)
                    current_delay *= backoff
        
        return wrapper
    return decorator

@retry(max_attempts=3, delay=2, backoff=2)
def unreliable_api_call():
    import random
    if random.random() < 0.7:
        raise Exception("API call failed")
    return "Success!"

result = unreliable_api_call()
print(result)
```

### 44. Rate Limiter
```python
import time
from functools import wraps

class RateLimiter:
    def __init__(self, max_calls, period):
        self.max_calls = max_calls
        self.period = period
        self.calls = []
    
    def __call__(self, func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            now = time.time()
            
            # Remove old calls outside the time window
            self.calls = [call for call in self.calls if call > now - self.period]
            
            if len(self.calls) >= self.max_calls:
                sleep_time = self.period - (now - self.calls[0])
                print(f"Rate limit reached. Sleeping for {sleep_time:.2f}s")
                time.sleep(sleep_time)
                self.calls = []
            
            self.calls.append(time.time())
            return func(*args, **kwargs)
        
        return wrapper

@RateLimiter(max_calls=5, period=10)  # Max 5 calls per 10 seconds
def api_call(endpoint):
    print(f"Calling API: {endpoint}")
    return f"Response from {endpoint}"

# Test rate limiter
for i in range(10):
    api_call(f"/endpoint/{i}")
```

### 45. Process Pool for CPU-Intensive Tasks
```python
from multiprocessing import Pool
import time

def cpu_intensive_task(n):
    """Simulate CPU-intensive work"""
    result = sum(i * i for i in range(n))
    return result

def parallel_processing(tasks, num_processes=4):
    start_time = time.time()
    
    with Pool(processes=num_processes) as pool:
        results = pool.map(cpu_intensive_task, tasks)
    
    end_time = time.time()
    
    print(f"Processed {len(tasks)} tasks in {end_time - start_time:.2f}s")
    return results

tasks = [1000000, 2000000, 3000000, 4000000, 5000000]
results = parallel_processing(tasks)
print(f"Results: {results}")
```

## **Security & Secrets Management**

### 46. Environment Variable Management
```python
import os
from dotenv import load_dotenv

def load_secrets():
    # Load from .env file
    load_dotenv()
    
    config = {
        'database_url': os.getenv('DATABASE_URL'),
        'api_key': os.getenv('API_KEY'),
        'secret_key': os.getenv('SECRET_KEY'),
        'debug': os.getenv('DEBUG', 'False').lower() == 'true'
    }
    
    # Validate required secrets
    required_secrets = ['database_url', 'api_key']
    missing = [key for key in required_secrets if not config.get(key)]
    
    if missing:
        raise ValueError(f"Missing required secrets: {', '.join(missing)}")
    
    return config

try:
    config = load_secrets()
    print("✓ Secrets loaded successfully")
except ValueError as e:
    print(f"✗ Error: {e}")
```

### 47. Password Hashing and Verification
```python
import hashlib
import secrets

def hash_password(password):
    # Generate salt
    salt = secrets.token_hex(16)
    
    # Hash password with salt
    pwd_hash = hashlib.pbkdf2_hmac('sha256', 
                                   password.encode('utf-8'), 
                                   salt.encode('utf-8'), 
                                   100000)
    
    return f"{salt}${pwd_hash.hex()}"

def verify_password(stored_password, provided_password):
    salt, pwd_hash = stored_password.split(')
    
    # Hash provided password with same salt
    new_hash = hashlib.pbkdf2_hmac('sha256',
                                   provided_password.encode('utf-8'),
                                   salt.encode('utf-8'),
                                   100000)
    
    return new_hash.hex() == pwd_hash

# Example usage
password = "MySecurePassword123!"
hashed = hash_password(password)
print(f"Hashed: {hashed}")

is_valid = verify_password(hashed, password)
print(f"Password valid: {is_valid}")
```

### 48. API Token Generator
```python
import secrets
import string
from datetime import datetime, timedelta

def generate_api_token(length=32):
    alphabet = string.ascii_letters + string.digits
    token = ''.join(secrets.choice(alphabet) for _ in range(length))
    return token

def generate_token_with_expiry(hours=24):
    token = generate_api_token()
    expiry = datetime.now() + timedelta(hours=hours)
    
    return {
        'token': token,
        'expires_at': expiry.isoformat(),
        'created_at': datetime.now().isoformat()
    }

token_data = generate_token_with_expiry(hours=48)
print(f"Token: {token_data['token']}")
print(f"Expires: {token_data['expires_at']}")
```

### 49. SSL Certificate Expiry Check
```python
import ssl
import socket
from datetime import datetime

def check_ssl_expiry(hostname, port=443):
    context = ssl.create_default_context()
    
    try:
        with socket.create_connection((hostname, port), timeout=10) as sock:
            with context.wrap_socket(sock, server_hostname=hostname) as ssock:
                cert = ssock.getpeercert()
                
                # Parse expiry date
                expiry_date = datetime.strptime(cert['notAfter'], '%b %d %H:%M:%S %Y %Z')
                days_remaining = (expiry_date - datetime.now()).days
                
                print(f"Certificate for {hostname}:")
                print(f"  Issuer: {cert['issuer']}")
                print(f"  Expires: {expiry_date.strftime('%Y-%m-%d')}")
                print(f"  Days remaining: {days_remaining}")
                
                if days_remaining < 30:
                    print(f"  ⚠️ WARNING: Certificate expires in {days_remaining} days!")
                
                return days_remaining
    except Exception as e:
        print(f"Error checking {hostname}: {e}")
        return None

check_ssl_expiry('google.com')
check_ssl_expiry('github.com')
```

### 50. Secrets Rotation Script
```python
import boto3
import json
from datetime import datetime

def rotate_secret(secret_name, new_value):
    """Rotate AWS Secrets Manager secret"""
    client = boto3.client('secretsmanager')
    
    try:
        # Update secret
        response = client.update_secret(
            SecretId=secret_name,
            SecretString=json.dumps(new_value)
        )
        
        print(f"✓ Secret {secret_name} rotated successfully")
        print(f"  Version: {response['VersionId']}")
        print(f"  Updated: {datetime.now().isoformat()}")
        
        # Tag with rotation timestamp
        client.tag_resource(
            SecretId=secret_name,
            Tags=[
                {'Key': 'LastRotated', 'Value': datetime.now().isoformat()}
            ]
        )
    except Exception as e:
        print(f"✗ Error rotating secret: {e}")

new_credentials = {
    'username': 'admin',
    'password': generate_api_token(32),
    'rotated_at': datetime.now().isoformat()
}

rotate_secret('prod/database/credentials', new_credentials)
```

---

## **Bonus: Complete Monitoring Script**

Here's a comprehensive monitoring script that combines multiple concepts:

```python
#!/usr/bin/env python3
import psutil
import requests
import subprocess
import smtplib
from email.mime.text import MIMEText
from datetime import datetime
import json

class SystemMonitor:
    def __init__(self, alert_email='admin@example.com'):
        self.alert_email = alert_email
        self.alerts = []
    
    def check_cpu(self, threshold=80):
        cpu_percent = psutil.cpu_percent(interval=1)
        if cpu_percent > threshold:
            self.alerts.append(f"CPU usage high: {cpu_percent}%")
        return cpu_percent
    
    def check_memory(self, threshold=80):
        memory = psutil.virtual_memory()
        if memory.percent > threshold:
            self.alerts.append(f"Memory usage high: {memory.percent}%")
        return memory.percent
    
    def check_disk(self, threshold=80):
        disk = psutil.disk_usage('/')
        if disk.percent > threshold:
            self.alerts.append(f"Disk usage high: {disk.percent}%")
        return disk.percent
    
    def check_services(self, services):
        for service in services:
            try:
                result = subprocess.run(
                    ['systemctl', 'is-active', service],
                    capture_output=True, text=True
                )
                if result.stdout.strip() != 'active':
                    self.alerts.append(f"Service {service} is down")
            except Exception as e:
                self.alerts.append(f"Error checking {service}: {e}")
    
    def check_endpoints(self, endpoints):
        for endpoint in endpoints:
            try:
                response = requests.get(endpoint, timeout=5)
                if response.status_code != 200:
                    self.alerts.append(f"Endpoint {endpoint} returned {response.status_code}")
            except Exception as e:
                self.alerts.append(f"Endpoint {endpoint} unreachable: {e}")
    
    def send_alerts(self):
        if not self.alerts:
            print("✓ All checks passed")
            return
        
        print(f"⚠️ {len(self.alerts)} alerts detected:")
        for alert in self.alerts:
            print(f"  - {alert}")
        
        # Send email (configure SMTP settings)
        # self.send_email_alert()
    
    def run_all_checks(self):
        print(f"\n=== System Monitor Report - {datetime.now()} ===\n")
        
        cpu = self.check_cpu()
        memory = self.check_memory()
        disk = self.check_disk()
        
        print(f"CPU: {cpu}%")
        print(f"Memory: {memory}%")
        print(f"Disk: {disk}%")
        
        services = ['nginx', 'postgresql']
        self.check_services(services)
        
        endpoints = ['http://localhost:8080/health']
        self.check_endpoints(endpoints)
        
        self.send_alerts()

if __name__ == '__main__':
    monitor = SystemMonitor()
    monitor.run_all_checks()
```

---

These 50 Python scripting examples cover the most commonly asked topics in SRE/DevOps interviews, including system monitoring, log analysis, file operations, API interactions, Docker/Kubernetes automation, AWS operations, database management, security, and more!