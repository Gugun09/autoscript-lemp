#!/bin/bash
######################################################
#			      AUTO LEMP INSTALLATION                   # 
#				    Written by Gil Shwartz  			           #
#				   gilshwartzdjgs@gmail.com			             #
######################################################
clear
	echo "#######################################################"
if (( $EUID != 0 )); then
	echo
    echo "[!] This script requires root privileges in order"
	echo "    to be able to write to /var/www/html/"
	echo "    Please run as root."
    echo "#######################################################"
	echo
	exit
fi

echo "This will install Nginx, MySql and PHP7.3"
echo "Please make sure that the system is updated."
echo "apt-get update && apt-get upgrade"
echo "#######################################################"
echo
echo -n "Is the system fully updated? [Y/n]?  "
read -n1 update

if [[ "$update" = "Y" || "$update" = "y" ]]
then
echo
echo "Installing nginx..."
echo
echo

	sudo apt install nginx -y
	sudo systemctl start nginx
	sudo systemctl enable nginx
	sudo systemctl status nginx --no-pager
echo
echo "Version:"
	nginx -v
echo
echo "Writing permissions..."
	sudo chown www-data:www-data /usr/share/nginx/html -R
	sleep 2s

echo "DONE!"
	sleep 1s
echo
echo "Installing MySql Database Server..."
	sleep 1s
	sudo apt install mysql-server -y
	sudo systemctl status mysql --no-pager
	sudo systemctl enable mysql
	sleep 1s
	clear
echo "Installing MySql Security script..."
	sudo mysql_secure_installation
	sleep 2s
echo "Installing PHP7.3 Repository..."
	sleep 1s
	yes '' | sudo add-apt-repository ppa:ondrej/php
echo
echo "Updating system..."
	sleep 1s
	sudo apt-get update
echo "Installing PHP7.3..."
	sleep 1s
	sudo apt install php7.3-fpm php7.3-mysql -y
	sudo systemctl start php7.3-fpm
	sudo systemctl enable php7.3-fpm
	sudo systemctl status php7.3-fpm --no-pager
echo
echo "DONE!"
	sleep 2s
echo
echo "Creating NginX Server Block..."
	sleep 2s
echo "Testing nginx configuration..."
	sleep 2s
	sudo nginx -t
	
#Manipulating the default file:
echo "Updating config..."
sudo sed -i 's/index.html/index.html index.php/' /etc/nginx/sites-available/default
sudo sed -i 's/#location ~/location ~/' /etc/nginx/sites-available/default
sudo sed -i 's/#	include/	include/' /etc/nginx/sites-available/default
sudo sed -i 's/#	fastcgi_pass unix/	fastcgi_pass unix/' /etc/nginx/sites-available/default
sudo sed -i 's/php7.0-fpm.sock/php7.3-fpm.sock/' /etc/nginx/sites-available/default
sudo sed -i 's/#}/}/' /etc/nginx/sites-available/default
sudo sed -i 's/#	deny all/	deny all/' /etc/nginx/sites-available/default
sudo sed -e '$s/^/#/' -i /etc/nginx/sites-available/default
	sleep 1s
	sudo chown www-data:www-data /var/www/html/
echo "<?php" >> /var/www/html/info.php
echo "	phpinfo();" >> /var/www/html/info.php
echo "?>" >> /var/www/html/info.php
	sudo systemctl restart nginx
echo "DONE!"
echo "Installation Complete!"
echo "Browse to your <IP>/info.php"
echo "[!]Please note that this is the very basic installation."
echo "[!]Don't forget to logout!"
echo	
	
fi
