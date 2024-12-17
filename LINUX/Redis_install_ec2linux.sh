#Redis-Installation Steps : in 2023 AMI
 
sudo dnf update -y
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y gcc make wget tar
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
sudo make install
sudo mkdir /etc/redis
sudo cp redis.conf /etc/redis/
sudo sysctl vm.overcommit_memory=1
sudo sed -i 's/protected-mode yes/protected-mode no/g' /etc/redis/redis.conf
sudo sed -i 's/bind 127.0.0.1/#bind 127.0.0.1/g' /etc/redis/redis.conf
#sudo sed -i 's/# protected-mode no/protected-mode no/g' /etc/redis-sentinel.conf


echo '
[Unit]
Description=Redis In-Memory Data Store
After=network.target
[Service]
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli shutdown
Restart=always
User=root
Group=root
[Install]
WantedBy=multi-user.target
' > /etc/systemd/system/redis.service
sudo systemctl daemon-reload
sudo systemctl enable redis
sudo systemctl start redis
sudo systemctl status redis





Redis-keys backup and restore :

Backup: 
#!/bin/bash
# Define Redis connection details
REDIS_HOST="10.217.18.221"   # Change to your Redis host if not localhost
REDIS_PORT="6379"        # Change to your Redis port if different
OUTPUT_FILE="redis_data.txt"
# Check if redis-cli is installed
if ! command -v redis-cli &>/dev/null; then
  echo "redis-cli is not installed. Please install it and try again."
  exit 1
fi
# Start the export
echo "Fetching keys and values from Redis..."
# Get all keys
KEYS=$(redis-cli -h $REDIS_HOST -p $REDIS_PORT KEYS "*")
# Check if keys exist
if [[ -z "$KEYS" ]]; then
  echo "No keys found in Redis."
  exit 0
fi
# Write keys and values to the output file
echo "Saving data to $OUTPUT_FILE..."
> $OUTPUT_FILE  # Clear file if it exists
for key in $KEYS; do
  value=$(redis-cli -h $REDIS_HOST -p $REDIS_PORT GET "$key")
  echo "$key: $value" >> $OUTPUT_FILE
done
echo "Data successfully saved to $OUTPUT_FILE."
 


10.217.18.147

s3://bayview-correspondent-nondel-prod-ecs-docs/redis_data.txt .



Restore: 
 
#!/bin/bash
# Define Redis connection details
REDIS_HOST="10.217.18.147"   # Change to your Redis host if not localhost
REDIS_PORT="6379"        # Change to your Redis port if different
INPUT_FILE="redis_data.txt"
# Check if the input file exists
if [[ ! -f $INPUT_FILE ]]; then
  echo "File $INPUT_FILE not found. Please provide the correct file."
  exit 1
fi
# Start the restoration
echo "Restoring data from $INPUT_FILE to Redis..."
while IFS= read -r line; do
  key=$(echo "$line" | cut -d '=' -f 1)
  value=$(echo "$line" | cut -d '=' -f 2-)
  redis-cli -h $REDIS_HOST -p $REDIS_PORT SET "$key" "$value"
done < "$INPUT_FILE"
echo "Data successfully restored to Redis."