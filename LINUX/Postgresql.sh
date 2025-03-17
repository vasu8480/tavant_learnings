sudo yum install -y gcc make readline-devel zlib-devel

wget https://ftp.postgresql.org/pub/source/v15.0/postgresql-15.0.tar.gz
tar -xvf postgresql-15.0.tar.gz
cd postgresql-15.0

./configure
make
sudo make install

psql --version
sudo systemctl status postgresql