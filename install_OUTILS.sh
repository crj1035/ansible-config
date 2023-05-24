#!/bin/bash

# Installation de la machine OUTILS

# sources.list
cp sources.list /etc/apt/sources.list

# Update
apt-get update

# Ansible
apt-get install  python3 python3-pip -y
apt-get install ansible -y
echo "export PATH=\"$PATH:/home/user/.local/bin\"" >> ~/.bashrc

# Docker
apt-get install wget
mkdir /tmp/docker
cd /tmp/docker
wget https://download.docker.com/linux/debian/dists/bullseye/pool/stable/amd64/docker-ce-cli_23.0.1-1~debian.11~bullseye_amd64.deb
dpkg -i ./*.deb

# Créé un utilisateur christophe
username="christophe"
password="osiris"
/usr/sbin/adduser --disabled-password --gecos "" "$username"
echo "$username:$password" | sudo chpasswd

# ajoute l'utilisateur au groupe sudo
cd /usr/sbin
./usermod -aG sudo christophe
#./visudo -f /etc/sudoers.d/christophe
#echo "$username ALL=(ALL:ALL) ALL" | sudo tee /etc/sudoers.d/christophe >/dev/null 2>&1
echo "$username ALL=(ALL:ALL) ALL" | sudo EDITOR="tee -a" visudo >/dev/null 2>&1

# Installation du paquet sshpass
apt-get install sshpass

# Créé les clés SSH pour christophe afin de se connecter à ansible
username="christophe"
ssh_dir="/home/$username/.ssh"
if [ ! -d "ssh_dir" ]; then
	mkdir "ssh_dir"
	chown $username:$username "ssh_dir"
	chmod 700 "ssh_dir"
fi
sudo -u $username ssh-keygen -t rsa -b 4096 -f "$ssh_dir/id_rsa" -q -N ""
echo "Clé publique RSA générée pour l'utilisateur $username :"
cat "$ssh_dir/id_rsa.pub"


  

 
