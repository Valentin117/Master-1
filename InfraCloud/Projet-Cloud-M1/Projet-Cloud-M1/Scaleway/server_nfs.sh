#!/bin/bash
sudo apt update
sudo apt install nfs-kernel-server -y
sudo apt install unzip -y
sudo mkdir -p /mnt/nfs_share
wget https://wordpress.org/latest.zip
unzip latest.zip
sudo cp -r wordpress/* /mnt/nfs_share/
sudo chmod 777 /mnt/nfs_share/
sudo echo "/mnt/nfs_share wp1.pierreds.studio(rw,sync,no_subtree_check)" >> /etc/exports
sudo echo "/mnt/nfs_share wp2.pierreds.studio(rw,sync,no_subtree_check)" >> /etc/exports
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
#sudo ufw allow from 51.158.175.56 to any port nfs
#sudo ufw allow from 4.233.219.69 to any port nfs
sudo iptables -A INPUT -p tcp -s wp1.pierreds.studio --dport 2049 -j ACCEPT
sudo iptables -A INPUT -p udp -s wp1.pierreds.studio --dport 2049 -j ACCEPT
sudo iptables -A INPUT -p tcp -s wp1.pierreds.studio --dport 111 -j ACCEPT
sudo iptables -A INPUT -p udp -s wp1.pierreds.studio --dport 111 -j ACCEPT
sudo iptables -A INPUT -p tcp -s wp2.pierreds.studio --dport 2049 -j ACCEPT
sudo iptables -A INPUT -p udp -s wp2.pierreds.studio --dport 2049 -j ACCEPT
sudo iptables -A INPUT -p tcp -s wp2.pierreds.studio --dport 111 -j ACCEPT
sudo iptables -A INPUT -p udp -s wp2.pierreds.studio --dport 111 -j ACCEPT
sudo ufw allow 22
sudo ufw enable
sudo chown -R www-data:www-data /mnt/nfs_share/