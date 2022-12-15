#!/bin/bash
sudo apt update
sudo apt install apache2 -y
sudo apt install php php-mysql php-cgi php-cli php-gd -y
sudo apt install nfs-common -y
sudo mkdir -p /var/wwww/html
sudo mount nfs.pierreds.studio:/mnt/nfs_share /var/www/html
sudo rm -rf /var/www/html/index.html
sudo touch /etc/rc.local
sudo echo "#!/bin/bash -e" >> /etc/rc.local
sudo echo "sudo mount nfs.pierreds.studio:/mnt/nfs_share /var/www/html" >> /etc/rc.local
sudo echo "exit 0" >> /etc/rc.local
chown root:root /etc/rc.local
chmod 700 /etc/rc.local