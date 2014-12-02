#!/bin/bash
sudo apt-get update -y
sudo apt-get install postgresql -y

echo "host all all 0.0.0.0/0 md5" | sudo tee -a /etc/postgresql/9.1/main/pg_hba.conf 
sudo service postgresql restart

for i in $(seq 1 5);
do
	export database"$i"="werckerdb"$i
	export user"$i"="postgres"$i
	sudo -u postgres psql -c "CREATE USER postgres"$i" WITH PASSWORD 'wercker';"
	sudo -u postgres psql -c "CREATE DATABASE werckerdb"$i";"
	sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE werckerdb"$i" TO postgres"$i";"
done
