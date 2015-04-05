#!/bin/sh

# Move ruTorrent into /config and Symbolic Link for nginx (if needed)
if [ -f /config/rutorrent/index.html ]; then
	echo "ruTorrent already in /config"
else
	echo "Moving ruTorrent into /config"
	mv /var/www/rutorrent /config/rutorrent
fi

# Does the user want the edge version?
	/bin/bash /edge.sh
	wait
	rm -R /var/www/rutorrent 
	ln -s /config/rutorrent /var/www/rutorrent
	
	# Set up BASIC Auth and SSL
	/bin/bash /ssl.sh

# Check if config exists. If not, copy in the sample config
if [ -f /config/.rtorrent.rc ]; then
	echo "Using existing config file."
else
	echo "Creating config from template."
	cp  /rtorrent.rc /config/.rtorrent.rc
fi

# Continue Docker Start
chown -R htpc:users /config
chmod -R 777 /config

chown -R htpc:www-data /config/rutorrent

chown -R htpc:users /download
chmod -R 777 /download

mkdir /config/.rtorrentsession
chown htpc:www-data /config/.rtorrentsession
chmod 777 /config/.rtorrentsession

set -ex

service nginx start
service php5-fpm start

cd ~htpc
exec gosu htpc /rutorrent.sh

