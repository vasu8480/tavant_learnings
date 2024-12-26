cd /home/ec2-user/
df -kh
lsblk
ll
mkdir /elk
mnt="$(lsblk |  sed -n '5 p' | awk '{print $1}')"
echo $mnt
mkfs.ext4 /dev/nvme1n1
mkdir -p /elk
mount /dev/nvme1n1 /elk
vi /etc/fstab
df -kh
unmount /elk
umount /elk
mount -a
df -kh
history
yum install wget
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.1-x86_64.rpm.sha512
ls -ltr
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.1-x86_64.rpm
sudo rpm --install elasticsearch-7.16.1-x86_64.rpm
shasum -a 512 -c elasticsearch-7.16.1-x86_64.rpm.sha512
shasum -a 512 -c elasticsearch-7.16.1-x86_64.rpm.sha512
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service
sudo systemctl status elasticsearch.service
cp /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml_bkp
cd /etc/elasticsearch/
df -kh
ll /elk
chown -R elasticsearch:elasticsearch /elk
ll /elk
vi /etc/elasticsearch/elasticsearch.yml
vi /etc/elasticsearch/jvm.options
cp  /etc/elasticsearch/jvm.options /etc/elasticsearch/jvm.options_bkp
vi /etc/elasticsearch/jvm.options
vi /etc/elasticsearch/jvm.options
sudo systemctl daemon-reload
systemctl start elasticsearch -l
systemctl status elasticsearch -l
systemctl stop elasticsearch -l
java --version
yum install java-1.8.0-openjdk
sudo yum install logstash
vi /etc/yum.repos.d/logstash.repo
 sudo yum install logstash
systemctl enable logstash && systemctl start logstash
 systemctl status logstash
cd /etc/logstash/conf.d/
vi filebeat.conf
vi output.conf
 systemctl status logstash
ls -ltr
chmod 777 *
ls -ltr
vi /etc/yum.repos.d/kibana.repo
yum install kibana -y
cp /etc/kibana/kibana.yml /etc/kibana/kibana.yml_blp
cp /etc/kibana/kibana.yml
vi /etc/kibana/kibana.yml
chmod -R 755 /etc/elasticsearch
systemctl daemon-reload
 systemctl start kibana
 systemctl start elasticsearch
 systemctl start logstash
 systemctl status logstash
 systemctl status logstash -l
 systemctl status elasticsearch
 systemctl status elasticsearch -l
 systemctl status kibana -l
df -kh
ll /elk
 systemctl status kibana -l
 systemctl status elasticsearch -l
 systemctl status logstash -l
 systemctl status logstash -l
 systemctl status logstash -l
 systemctl status elasticsearch -l
cat /var/log/elasticsearch/elasticsearch.log
cat /var/log/logstash/logstash-
cat /var/log/logstash/logstash
ll/var/log/logstash/logstash
ll /var/log/logstash/logstash
ll /var/log/logstash/
ll /var/log/logstash/logstash-plain.log
cat /var/log/logstash/logstash-plain.log
ll /var/log/logstash/
cat /var/log/logstash/logstash-deprecation.log
systemctl stop elasticsearch
systemctl stop logstash
systemctl stop kibana
systemctl sta
systemctl stop elasticsearch
systemctl start kibana
systemctl start elasticsearch
systemctl start logstash
systemctl status logstash
systemctl status logstash -l
systemctl status elasticsearch
systemctl status kibana
systemctl status kibana -l
cat /etc/kibana/kibana.yml
java --version
java -version
tail -f /var/log/kibana/kibana.log
systemctl stop kibana
. Automatically enabling Chromium sandbox."}
{"type":"log","@timestamp":"2024-08-08T09:47:29+00:00","tags":["error","elasticsearch-service"],"pid":16150,"message":"Unable to retrieve version information from Elasticsearch nodes. connect ECONNREFUSED 127.0.0.1:9200"}
{"type":"log","@timestamp":"2024-08-08T09:47:49+00:00","tags":["error","elasticsearch-service"],"pid":16150,"message":"This version of Kibana (v7.17.23) is incompatible with the following Elasticsearch nodes in your cluster: v7.16.1 @ 10.216.218.50:9200 (10.216.218.50)"}
. Automatically enabling hromium sandbox."}
{"type":"log","@timestamp":"2024-08-08T09:47:29+00:00","tags":["error","elasticsearch-service"],"pid":16150,"message":"Unable to retrieve version information from Elasticsearch nodes. connect ECONNREFUSED 127.0.0.1:9200"}
{"type":"log","@timestamp":"2024-08-08T09:47:49+00:00","tags":["error","elasticsearch-service"],"pid":16150,"message":"This version of Kibana (v7.17.23) is incompatible with the following Elasticsearch nodes in your cluster: v7.16.1 @ 10.216.218.50:9200 (10.216.218.50)"}
[root@ip-10-216-218-50 bin]#yum remove kibana
yum remove kibana
yum install kibana-7.16.1
cat /etc/kibana/kibana.yml
vi /etc/kibana/kibana.yml
systemctl restart kibana
systemctl start kibana
systemctl status kibana
systemctl status kibana -l
tail -f /var/log/kibana/kibana.log
tail -f /var/log/elasticsearch/elasticsearch.log
tail -f /var/log/logstash/logstash-plain.log
systemctl status node_exporter
systemctl status node_exporter
df -kh
cd /home/ec2-user/
ls -ltr
systemctl status node_exporter -l
curl http://10.216.218.50:9100/metrics
df -h
history
systemctl status kibana
ps -ef | grep kibana
ps -eaf |grep elastic
ps -eaf |grep kibana
df -hT
history |grep elastic
systemctl status elasticsearch
systemctl status logstash
systemctl sop elasticsearch
systemctl stop elasticsearch
systemctl status logstas
systemctl status elasticsearch
systemctl start elasticsearch
systemctl status elasticsearch
top -c
systemctl stop kibana
systemctl stop logstash
systemctl stop elasticsearch
systemctl status elasticsearch
systemctl status kibana
systemctl status logstash
systemctl start elasticsearch
systemctl start logstash
systemctl status elasticsearch
systemctl status kibana
systemctl status logstash
systemctl start kibana
systemctl status kibana
cd /var/log/kibana/
ll
tail -f kibana.log
tail -f kibana.log
cd ../elasticsearch/
ll
tail -f elasticsearch.log
cd ../logstash/
ll
tail -f logstash-plain.log
history
sudo systemctl status elasticsearch.service
sudo nano /etc/elasticsearch/elasticsearch.yml
lsblk
ll
echo "$(lsblk |  sed -n '5 p' | awk '{print $1}')"
lsblk
df -kh