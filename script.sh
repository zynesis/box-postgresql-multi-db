#!/bin/bash
sudo apt-get update -y
sudo apt-get install postgresql -y

sudo sed -i 's/postgres\s*peer/postgres trust/g' /etc/postgresql/9.1/main/pg_hba.conf
echo "host all all 0.0.0.0/0 md5" | sudo tee -a /etc/postgresql/9.1/main/pg_hba.conf 
echo "listen_addresses='*'" | sudo tee -a  /etc/postgresql/9.1/main/postgresql.conf
echo "fsync = off" | sudo tee -a  /etc/postgresql/9.1/main/postgresql.conf
echo "synchronous_commit = off" | sudo tee -a  /etc/postgresql/9.1/main/postgresql.conf
echo "full_page_writes = off" | sudo tee -a  /etc/postgresql/9.1/main/postgresql.conf
echo "checkpoint_segments = 30" | sudo tee -a  /etc/postgresql/9.1/main/postgresql.conf
echo "checkpoint_timeout = 1h" | sudo tee -a  /etc/postgresql/9.1/main/postgresql.conf
sudo service postgresql restart

for i in $(seq 1 5);
do
	export database"$i"="werckerdb"$i
	export user"$i"="postgres"$i
	psql -Upostgres -c "CREATE USER postgres"$i" WITH PASSWORD 'wercker';"
	psql -Upostgres -c "CREATE DATABASE werckerdb"$i";"
	psql -Upostgres -c "GRANT ALL PRIVILEGES ON DATABASE werckerdb"$i" TO postgres"$i";"
done
