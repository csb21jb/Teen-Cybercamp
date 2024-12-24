#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install git
## Install Docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce
sudo docker run hello-world ## Ensure docker runs
docker run -d -p 3000:3000 bkimminich/juice-shop
docker run --rm -d -p 8080:80 vulnerables/web-dvwa


