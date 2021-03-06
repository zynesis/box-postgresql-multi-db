#!/bin/bash
sudo apt-get update -y
sudo apt-get install postgresql -y

sudo sed -i 's/postgres\s*peer/postgres trust/g' /etc/postgresql/**/main/pg_hba.conf
echo "host all all 0.0.0.0/0 md5" | sudo tee -a /etc/postgresql/**/main/pg_hba.conf 

# Non-durable settings
# based on http://www.postgresql.org/docs/current/static/non-durability.html
echo "listen_addresses='*'" | sudo tee -a  /etc/postgresql/**/main/postgresql.conf
echo "fsync = off" | sudo tee -a  /etc/postgresql/**/main/postgresql.conf
echo "synchronous_commit = off" | sudo tee -a  /etc/postgresql/**/main/postgresql.conf
echo "full_page_writes = off" | sudo tee -a  /etc/postgresql/**/main/postgresql.conf
echo "checkpoint_segments = 30" | sudo tee -a  /etc/postgresql/**/main/postgresql.conf
echo "checkpoint_timeout = 1h" | sudo tee -a  /etc/postgresql/**/main/postgresql.conf

# Use RAM disk
sudo service postgresql stop
sudo mkdir /tmp/ramdisk;
sudo mount -t tmpfs -o size=128M tmpfs /tmp/ramdisk/;
sudo mv /var/lib/postgresql /tmp/ramdisk/postgresql;
sudo ln -s /tmp/ramdisk/postgresql /var/lib/postgresql;
sudo chmod -R 700 /var/lib/postgresql;
sudo chown -R postgres:postgres /var/lib/postgresql;
sudo service postgresql start;

for i in $(seq 1 5);
do
	export database"$i"="werckerdb"$i
	export user"$i"="postgres"$i
	psql -Upostgres -c "CREATE USER postgres"$i" WITH PASSWORD 'wercker';"
	psql -Upostgres -c "CREATE DATABASE werckerdb"$i";"
	psql -Upostgres -c "GRANT ALL PRIVILEGES ON DATABASE werckerdb"$i" TO postgres"$i";"
done
