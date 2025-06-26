# Update Filebeat config: replace old Logstash IP with the new one
sudo sed -i 's/10\.216\.198\.91/10.216.198.23/' /etc/filebeat/filebeat.yml

# Restart Filebeat service to apply the changes
sudo systemctl restart filebeat

# Confirm the updated Logstash host IP
grep 'hosts:' /etc/filebeat/filebeat.yml
