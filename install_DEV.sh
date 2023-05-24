#!/bin/bash

# Installation de la machine DEV

# sources.list
cp sources.list /etc/apt/sources.list

# Update
apt-get update

# VSCode
apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
apt install apt-transport-https
apt update
apt install code # or code-insiders

# Git
apt-get install git -y

# Ansible
apt-get install  python3 python3-pip -y
apt-get install ansible -y
echo "export PATH=\"$PATH:/home/user/.local/bin\"" >> ~/.bashrc

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
chmod 400 "$ssh_dir/id_rsa.pub"

# Installation du paquet sshpass
apt-get install sshpass

# copie de la clé ssh sur la machine de PROD
echo "Copie de la clé publique de christophe (attention pas root qui est utilisateur en cours) sur la machine OUTILS"
su christophe
cd /home/christophe/.ssh
#read -s -p "Entrez le mot de passe SSH pour utilisateur username sur la machine distante OUTILS IP 172.16.0.89 : " motdepasse
#sshpass -p "$motdepasse" ssh-copy-id -i "$ssh_dir/id_rsa.pub" $username@172.16.0.89
echo $pwd
ssh-copy-id -i "/home/christophe/.ssh/id_rsa.pub" christophe@172.16.0.89
