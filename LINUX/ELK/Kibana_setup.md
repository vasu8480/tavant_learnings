# Elasticsearch Installation Guide

## Prerequisites
The server IP for the ELK (Elasticsearch, Logstash, Kibana) installation is `10.210.85.44`.
1. **Modify the Configuration to Use the New IP**  
   Update the `filebeat.yml` file to include the new IP address ` `.  

   ```bash
   cat /etc/filebeat/filebeat.yml
   vi /etc/filebeat/filebeat.yml
   systemctl restart filebeat
   systemctl status filebeat
   ```

## Download and Install Elasticsearch

1. Creating logs disk for Logstash
   ```bash
   # Create a directory for mounting
   mkdir -p /elk

   # Identify the disk to format and mount
   mnt=$(lsblk | sed -n '5p' | awk '{print $1}')
   echo "Mounting disk: $mnt"

   # Format the disk with ext4
   mkfs.ext4 /dev/nvme1n1

   # Mount the disk to the /elk directory
   mount /dev/nvme1n1 /elk

   # Add the mount to /etc/fstab for persistence
   echo "/dev/nvme1n1 /elk ext4 defaults,nofail 0 2" >> /etc/fstab

   # Verify the mount
   df -kh

   # Test remounting
   umount /elk
   mount -a
   df -kh
   ```

2. Download the SHA512 checksum file for Elasticsearch:
   ```bash
   yum install wget

   wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.1-x86_64.rpm.sha512

   ls -ltr

   wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.1-x86_64.rpm

   sudo rpm --install elasticsearch-7.16.1-x86_64.rpm
   shasum -a 512 -c elasticsearch-7.16.1-x86_64.rpm.sha512
   ```

## Configure Elasticsearch

1. Navigate to the Elasticsearch configuration directory:
   ```bash
   cd /etc/elasticsearch/
   ll /elk
   chown -R elasticsearch:elasticsearch /elk
   ll /elk
   ```
2. Backup existing configuration files:
   ```bash
   cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml_bkp
   cp /etc/elasticsearch/jvm.options /etc/elasticsearch/jvm.options_bkp
   ```
3. Edit `elasticsearch.yml`:
   ```bash
   vi /etc/elasticsearch/elasticsearch.yml
   ```
   Update the following settings:
   ```yaml
   path.data: /elk
   path.logs: /var/log/elasticsearch
   network.host: ["localhost", "10.210.85.44"]
   discovery.type: single-node
   ```
4. Edit `jvm.options` to update memory settings. Uncomment and set what every is there in the uncomments :
   ```bash
   -Xms4g
   -Xmx4g
   ```
5. Reload systemd:
   ```bash
   sudo systemctl daemon-reload
   systemctl start elasticsearch
   systemctl start elasticsearch -l
   ```

6. View Logs:
   ```bash
   cat /var/log/elasticsearch/elasticsearch.log
   ```
   
# Setting Up Java and Logstash
1. Step 1: Verify Java Installation :
   ```bash
   java --version
   yum install java-1.8.0-openjdk
   ```
## Configure Logstash

1. Edit the repository file for Logstash:

   ```bash
   sudo yum install logstash
   
   vi /etc/yum.repos.d/logstash.repo
   ```

   Add the following content to the file:

   ```bash
   [logstash-7.x]
   name=Elastic repository for 7.x packages
   baseurl=https://artifacts.elastic.co/packages/7.x/yum
   gpgcheck=1
   gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
   enabled=1
   autorefresh=1
   type=rpm-md
   ```

2. Enable and Start Logstash Service

   ```bash
   systemctl enable logstash && systemctl start logstash
   systemctl status logstash
   ```

3. Navigate to the configuration directory:

   ```bash
   cd /etc/logstash/conf.d/
   ```

   a. Create `filebeat.conf`

      ```bash
      vi filebeat.conf
      ```

      Add the following content:

      ```bash
      input {
      beats {
         port => 5044
         }
      }

      filter {
            if [type] == "ms_log" {
            grok { match => { "message" => [ "(?m)%{TIMESTAMP_ISO8601:timestamp}[\s]{1,}%{LOGLEVEL:severity}[\s]{0,}\[%{DATA:application},%{DATA:traceid},%{DATA:spanid},%{DATA:debug}\][\s]{0,}%{DATA:pid}[\s]{0,}---[\s]{0,}\[%{DATA:thread}][\s]{0,}[\s]{0,}%{DATA:class}[\s]{1,}:%{GREEDYDATA:msmsg}" ] } }
            date {
                     match => [ "timestamp" , "yyyy-MM-dd HH:mm:ss.SSS" ]
                  }
            }
            if [type] == "iis_log" {
            grok { match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} %{IPV4:server_ip} %{WORD:method} %{URIPATH:request} %{DATA:other} %{INT:port} - %{IPV4:remote_ip} %{DATA:referrer} - %{INT:response_code} %{INT:sub_status} %{INT:win32_status} %{INT:request_time}" }                }
            date {
                     match => [ "timestamp" , "yyyy-MM-dd HH:mm:ss.SSSS" ]
                     remove_field => [ "timestamp" ]
                  }
            }
            if [type] == "wrapper_log" {
                     grok {
                              match => { "message" => "(?m)%{TIMESTAMP_ISO8601:timestamp}[\s]{1,}-[\s]{1,}%{DATA:TraceID}[\s]{0,}-[\s]{1,}%{GREEDYDATA:wrapper_msg}" }
                     }
                     date {
                              match => [ "timestamp" , "yyyy-MM-dd HH:mm:ss.SSSS" ]
                              remove_field => [ "timestamp" ]
                           }
            }
            if [type] == "w_exception_log" {
                     grok {
                           match => { "message" => "(?m)%{TIMESTAMP_ISO8601:timestamp}[\s]{1,}-[\s]{1,}%{DATA:TraceID}[\s]{1,}-[\s]{1,}%{DATA:ErrorCode}[\s]{1,}-[\s]{1,}%{GREEDYDATA:w_exception_msg}" }
                     }
                     date {
                              match => [ "timestamp" , "yyyy-MM-dd HH:mm:ss.SSSS" ]
                              remove_field => [ "timestamp" ]
                           }
            }
      }
      ```

      b. Create `output.conf`

      ```bash
      vi output.conf
      ```

      Add the following content:

      ```bash
      output {
      elasticsearch {
         hosts => [ "10.216.218.50:9200" ]
         sniffing => false
      }
      stdout { codec => rubydebug }
      }
      ```

      ### Alternative: Direct Configuration in `filebeat.conf`

      Instead of using `output.conf`, you can define the output directly in `filebeat.conf`:

      ```bash
      input {
      beats {
         port => 5044
      }
      }

      filter {
         grok {
            match => { "message" => "(?m)%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:severity} \[%{DATA:application},%{DATA:traceid},%{DATA:spanid},%{DATA:debug}] %{DATA:pid} --- *\[%{DATA:thread}] %{DATA:class} %{GREEDYDATA:message}" }
         }
         date {
         match => [ "timestamp" , "yyyy-MM-dd HH:mm:ss.SSS" ]
      }
      }

      output {
      elasticsearch {
         hosts => [ "10.210.85.44:9200" ]
         sniffing => false
      }
      }
      ```

4. Manage Logstash Service:
   ```bash
   ls -ltr
   chmod 777 *
   ls -ltr
   systemctl status logstash
   tail -f /var/log/logstash/logstash-plain.log
   cat /var/log/logstash/logstash-plain.log
   ```

# Kibana Installation Guide

1. Install Kibana Run the following command to install Kibana version 7.16.1:
   ```bash
   yum install kibana-7.16.1
   ```

2. Configure Kibana:
   -```bash
   cp /etc/kibana/kibana.yml /etc/kibana/kibana.yml_blp
   vi /etc/kibana/kibana.yml
      - server.host: "0.0.0.0"
   ```
   ```bash
   vi /etc/yum.repos.d/kibana.repo
   ```

   Update the repository details as follows:
   ```bash
   [kibana-7.x]
   name=Kibana repository for 7.x packages
   baseurl=https://artifacts.elastic.co/packages/7.x/yum
   gpgcheck=1
   gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
   enabled=1
   autorefresh=1
   type=rpm-md
   ```

3. Start and Manage Kibana Service
   ```bash
   systemctl daemon-reload
   systemctl start kibana
   systemctl status kibana
   systemctl status kibana -l
   ```

4. Verify Related Services:
   ```bash
   systemctl status elasticsearch
   systemctl status logstash
   systemctl status kibana
   ```
