#!/bin/bash

# Exit on error and print each command that is executed
set -e
set -x

echo "Running email wizard..."
curl -LO larbs.xyz/emailwiz.sh
bash emailwiz.sh

echo "Adding mail users..."
useradd -m -G mail gunnar
useradd -m -G mail spam

echo "Setting passwords..."
echo "Set password for user gunnar"
passwd gunnar
echo "Set password for user spam"
passwd spam

echo "Getting .bashrc file..."
curl -Lo .bashrc https://ghalv.github.io/bashrc #; source ~/.bashrc

echo "Allowing UFW 443..."
ufw allow 443

echo "Installing necessary packages..."
apt-get install -y nginx rsync git

echo "Setting up nginx configuration..."
rm -f /etc/nginx/sites-enabled/default
(cd /etc/nginx/sites-available && curl -LO https://ghalv.github.io/ghalv)
ln -s /etc/nginx/sites-available/ghalv /etc/nginx/sites-enabled/ghalv
service nginx reload

echo "Setting up website..."
mkdir /var/www/ghalv
git clone https://github.com/ghalv/ghalv.github.io /var/www/ghalv
rm -rf /var/www/ghalv/.git

echo "Running certbot..."
certbot --nginx

echo "Add the certbot renew command to the cron jobs list"
(crontab -l 2>/dev/null; echo "0 0 1 * * certbot renew") | crontab -

echo "Set shell to bash"
chsh -s /bin/bash $USER

echo "Script has finished successfully! Now 1) source .bashrc, 2) disable pw login and 3) hide nginx version."
