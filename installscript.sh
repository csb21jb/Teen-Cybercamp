#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please use sudo or log in as root."
    exit 1
fi

apt update -y
apt upgrade -y
apt install git
apt install nmap
apt install pip
## Install Docker
apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install docker-ce
docker run hello-world ## Ensure docker runs

## update SSH to accept antiquated security
echo "Host 172.18.0.3" >> /etc/ssh/ssh_config
echo -e "\tHostKeyAlgorithms +ssh-rsa" >> /etc/ssh/ssh_config
echo -e "\tPubkeyAcceptedAlgorithms +ssh-rsa" >> /etc/ssh/ssh_config
echo "Configuration updated successfully in /etc/ssh/ssh_config."

# Install the pdf-parser to /usr/local/bin
cd /usr/local/bin && wget https://raw.githubusercontent.com/csb21jb/Teen-Cybercamp/refs/heads/main/pdf-parser.py

# Append the PATH modification to /etc/profile
echo 'export PATH="/usr/local/bin:$PATH"' | sudo tee -a /etc/profile
source /etc/profile
echo "Updated PATH: $PATH"

#Install Metasploit-Framework
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall

