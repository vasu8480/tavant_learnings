
cd /home/ec2-user
yum update -y
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
curl -LO https://user-data-ecs-velox.s3-us-west-1.amazonaws.com/security.sh
chmod 755 security.sh
sudo sh security.sh
curl -LO https://user-data-ecs-velox.s3-us-west-1.amazonaws.com/cisscanfix.sh
chmod 755 cisscanfix.sh
sudo sh cisscanfix.sh


sudo mkdir crowdstrike
cd crowdstrike
sudo curl -LO https://user-data-ecs-velox.s3.us-west-1.amazonaws.com/crowdstrike_install/falcon-sensor-7.20.0-17306.amzn2023.x86_64.rpm
sudo yum install falcon-sensor-7.20.0-17306.amzn2023.x86_64.rpm -y
sudo /opt/CrowdStrike/falconctl -s --cid=07993F0C4C924ABD81DBAEC79BE1C562-BC --tags="BAYVIEW,CDP-UAT,clamav"
systemctl enable falcon-sensor
systemctl start falcon-sensor
systemctl status falcon-sensor


sudo yum -y install clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd
sudo setsebool -P antivirus_can_scan_system 1
sudo setsebool -P clamd_use_jit 1
sudo getsebool -a | grep antivirus
sudo sed -i -e "s/^Example/#Example/" /etc/clamd.d/scan.conf
sudo sed -i -e "s/^Example/#Example/" /etc/freshclam.conf

cp  /etc/clamd.d/scan.conf /etc/clamd.d/scan.conf_bkp
cat /etc/clamd.d/scan.conf
vi /etc/clamd.d/scan.conf
sudo systemctl enable clamd@scan
sudo systemctl start clamd@scan

sudo systemctl status clamd@scan
sudo systemctl restart clamd@scan


