#!/bin/bash

# Exit on error
set -e

# Define the command for downloading .bashrc
download_bashrc() {
    # Check if .bashrc already exists
    if [ -f ~/.bashrc ]; then
        # Prompt the user before overwriting
        read -p "~/.bashrc already exists. Overwrite it? [y/N] " yn
        case $yn in
            [Yy]* ) curl -LO https://ghalv.github.io/.bashrc; source ~/.bashrc;;
            * ) echo "Skipped downloading of .bashrc";;
        esac
    else
        # If not, just download and source it
        curl -LO https://ghalv.github.io/.bashrc
        source ~/.bashrc
    fi
}

# Run the commands
curl -LO larbs.xyz/emailwiz.sh
bash emailwiz.sh
useradd -m -G mail gunnar
useradd -m -G mail spam
echo "Set password for user gunnar"
passwd gunnar
echo "Set password for user spam"
passwd spam
download_bashrc
ufw allow 443
apt install nginx python3-certbot-nginx rsync git
cd /etc/nginx/sites-available
curl -LO https://ghalv.github.io/ghalv
ln -s /etc/nginx/sites-available/ghalv /etc/nginx/sites-enabled/ghalv
service nginx reload
mkdir /var/www/ghalv
git clone git@github.com:ghalv/ghalv.github.io /var/www/ghalv
certbot --nginx
