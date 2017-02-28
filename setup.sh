#!/bin/bash
echo "Add PHP ppa ondrej/php"
sudo add-apt-repository ppa:ondrej/php

echo "Adding MongoDB Repo"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

echo "Updating the APT lists"
sudo apt-get update

echo "Installing dependencies"
sudo apt-get install git git-flow gitg apache2 php5.6 php5.6-mysql php5.6-curl php5.6-cli php5.6-common mysql-server curl ssh php5.6-intl terminator build-essential libssl-dev mongodb-org

echo "Installing NVM (Node Version Manager)"
curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

echo "Installing Node.JS LTS"
nvm install node --lts

echo "Installing PM2"
pm2 install -g pm2

echo "Configuring Mongo DB Service"
echo "[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/mongodb.service

echo "Starting MongoDB Service"
sudo systemctl start mongodb

echo "Enabling MongoDB Autostart on systen start"
sudo systemctl enable mongodb

echo "Downloading Microsoft Visual Studio Code"
wget -O /tmp/vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868

echo "Installing Microsoft Visual Studio Code"
sudo dpkg -i /tmp/vscode.deb

echo "Downloading Sublime Text 3 build 3126"
wget -O /tmp/st3.deb https://download.sublimetext.com/sublime-text_build-3126_amd64.deb

echo "Installing Sublime Text 3"
sudo dpkg -i /tmp/st3.deb

echo "Making sure that no dependencies are missing..."
sudo apt-get install -f

echo "Installing Composer Package Manager!"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

echo "Installing Vhost Manager"
git clone https://github.com/rubensfernandes/vhost-manager.git /tmp/vhost
sudo chmod +x /tmp/vhost/vhost
sudo /tmp/vhost/vhost -install

echo "Installing PHP-Cs"
curl -o- https://raw.githubusercontent.com/rubensfernandes/scripts-ubuntu/master/install-phpcs | sudo bash

echo "FIX /var/www permissions"
sudo groupadd www-pub
sudo usermod -a -G www-pub root
sudo usermod -a -G www-pub $USER
sudo usermod -a -G www-pub www-data
sudo chown -R $USER:www-pub /var/www
sudo chmod 2775 /var/www
sudo find /var/www -type d -exec chmod 2775 {} +
sudo find /var/www -type f -exec chmod 0664 {} +
echo "umask 0002" | sudo tee -a /etc/profile

echo "Clean unnecessary files"
rm /tmp/vscode.deb /tmp/st3.deb
rm -rf /tmp/vhost

echo "All Done... Please reboot for all changes to take efect..."