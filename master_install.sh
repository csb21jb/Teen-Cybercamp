#!/bin/bash

# Ensure the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "\e[1;31mThis script must be run as root!\e[0m" 
   exit 1
fi

echo -e "\e[33mStarting system setup...\e[0m"
sleep 2  # Wait for 2 seconds

echo -e "\n\n\n\n"  # Add two blank lines for spacing
# Update and upgrade the system
echo -e "\e[33mUpdating system packages...\e[0m"
apt update && apt upgrade -y
sleep 2  # Wait for 2 seconds

echo -e "\n\n\n\n"  # Add two blank lines for spacing
# Set the language and timezone
echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections
echo 'locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8' | debconf-set-selections
echo 'tzdata tzdata/Areas select America' | debconf-set-selections
echo 'tzdata tzdata/Zones/America select New_York' | debconf-set-selections
sleep 2  # Wait for 2 seconds

echo -e "\n\n\n\n"  # Add two blank lines for spacing

# Install necessary tools
echo -e "\e[33mInstalling required tools...\e[0m"
apt install -y curl sudo
# Loop to add seconds between tool installations
for tool in python3 openssl git nmap wget net-tools build-essential vim apt-transport-https ca-certificates software-properties-common systemd gnupg lsb-release; do apt install -y "$tool" && sleep 2; done
#apt install -y python3 openssl git nmap wget net-tools build-essential vim apt-transport-https ca-certificates software-properties-common systemd gnupg lsb-release nano
#sleep 2  # Wait for 2 seconds

#echo -e "\n\n\n\n"  # Add two blank lines for spacing
# Setup Docker
echo -e "\e[33mSetting up Docker...\e[0m"
apt install -y ca-certificates 
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sleep 2  # Wait for 2 seconds

echo -e "\n\n\n\n"  # Add two blank lines for spacing

# Configure the "testuser" account
echo -e "\e[33mCreating user accounts...\e[0m"
useradd -m -s /bin/bash testuser
echo "testuser:testpass123$" | chpasswd
       ####put the other accounts here
echo -e "\e[33mUser accounts are setup\e[0m"
sleep 2  # Wait for 2 seconds

echo -e "\n\n\n\n"  # Add two blank lines for spacing
# Deploy the pdf-parser.py tool to /usr/local/bin
echo -e "\e[33mDownloading and placing pdf-parser.py in /usr/local/bin...\e[0m"
wget -O /usr/local/bin/pdf-parser.py https://raw.githubusercontent.com/csb21jb/Teen-Cybercamp/refs/heads/main/pdf-parser.py
chmod +x /usr/local/bin/pdf-parser.py
sleep 2  # Wait for 2 seconds

echo -e "\n\n\n\n"  # Add two blank lines for spacing
# Simulate log entries in auth.log for testing purposes
echo -e "\e[33mCreating simulated SSH attack log entries...\e[0m"
cat <<EOL >> /var/log/auth.log
Dec 29 07:01:10 server sshd[23456]: Invalid user admin from 89.208.198.12
Dec 29 07:01:12 server sshd[23456]: Failed password for invalid user admin from 89.208.198.12 port 44562 ssh2
Dec 29 07:02:00 server sshd[24567]: Invalid user test from 192.0.2.12
Dec 29 07:02:02 server sshd[24567]: Failed password for invalid user test from 192.0.2.12 port 39843 ssh2
Dec 29 07:03:50 server sshd[25568]: Invalid user root from 89.208.198.12
Dec 29 07:03:52 server sshd[25568]: Failed password for invalid user root from 89.208.198.12 port 55822 ssh2
Dec 29 07:05:14 server sshd[26789]: Failed password for root from 89.208.198.12 port 51234 ssh2
Dec 29 07:06:22 server sshd[27890]: Invalid user guest from 192.0.2.12
Dec 29 07:06:24 server sshd[27890]: Failed password for invalid user guest from 192.0.2.12 port 47893 ssh2
Dec 29 07:10:05 server sshd[29001]: Invalid user admin from 89.208.198.12
Dec 29 07:10:07 server sshd[29001]: Failed password for invalid user admin from 89.208.198.12 port 60112 ssh2
Dec 29 07:15:10 server sshd[30012]: Failed password for root from 89.208.198.12 port 42345 ssh2
Dec 29 07:20:15 server sshd[31023]: Invalid user student from 192.168.0.15
Dec 29 07:20:17 server sshd[31023]: Failed password for invalid user student from 192.168.0.15 port 32241 ssh2
Dec 29 07:25:30 server sshd[32134]: Failed password for root from 192.168.0.15 port 45521 ssh2
Dec 29 07:30:25 server sshd[33145]: Failed password for root from 89.208.198.12 port 32145 ssh2
Dec 29 07:35:50 server sshd[34556]: Invalid user admin from 192.0.2.25
Dec 29 07:35:52 server sshd[34556]: Failed password for invalid user admin from 192.0.2.25 port 59832 ssh2
Dec 29 07:36:40 server sshd[34567]: Invalid user guest from 192.0.2.25
Dec 29 07:36:42 server sshd[34567]: Failed password for invalid user guest from 192.0.2.25 port 49832 ssh2
Dec 29 07:38:10 server sshd[35678]: Invalid user admin from 203.0.113.20
Dec 29 07:38:12 server sshd[35678]: Failed password for invalid user admin from 203.0.113.20 port 65123 ssh2
Dec 29 07:38:15 server sshd[35678]: Failed password for root from 203.0.113.20 port 43122 ssh2
Dec 29 07:40:45 server sshd[36789]: Failed password for root from 203.0.113.20 port 51432 ssh2
Dec 29 07:45:55 server sshd[37890]: Invalid user student from 192.0.2.33
Dec 29 07:45:57 server sshd[37890]: Failed password for invalid user student from 192.0.2.33 port 44121 ssh2
Dec 29 07:50:10 server sshd[38901]: Failed password for root from 203.0.113.20 port 61321 ssh2
Dec 29 07:55:15 server sshd[40012]: Invalid user admin from 89.208.198.12
Dec 29 07:55:17 server sshd[40012]: Failed password for invalid user admin from 89.208.198.12 port 65112 ssh2
Dec 29 08:00:30 server sshd[41123]: Invalid user guest from 192.0.2.25
Dec 29 08:00:32 server sshd[41123]: Failed password for invalid user guest from 192.0.2.25 port 49123 ssh2
Dec 29 08:05:50 server sshd[42234]: Failed password for root from 203.0.113.20 port 56123 ssh2
Dec 29 08:10:25 server sshd[43345]: Invalid user admin from 192.0.2.33
Dec 29 08:10:27 server sshd[43345]: Failed password for invalid user admin from 192.0.2.33 port 49921 ssh2
Dec 29 08:15:40 server sshd[44556]: Failed password for root from 203.0.113.20 port 61512 ssh2
Dec 29 08:20:10 server sshd[45667]: Invalid user test from 203.0.113.25
Dec 29 08:20:12 server sshd[45667]: Failed password for invalid user test from 203.0.113.25 port 60145 ssh2
Dec 29 08:25:55 server sshd[46778]: Failed password for root from 203.0.113.25 port 61234 ssh2
Dec 29 08:30:15 server sshd[47889]: Invalid user guest from 192.0.2.33
Dec 29 08:30:17 server sshd[47889]: Failed password for invalid user guest from 192.0.2.33 port 53124 ssh2
Dec 29 08:35:20 server sshd[48900]: Failed password for root from 203.0.113.25 port 62134 ssh2
Dec 29 08:40:30 server sshd[50001]: Invalid user hacker from 203.0.113.50
Dec 29 08:40:32 server sshd[50001]: Failed password for invalid user hacker from 203.0.113.50 port 49312 ssh2
Dec 29 08:45:25 server sshd[51112]: Failed password for root from 192.0.2.50 port 49231 ssh2
Dec 29 08:50:30 server sshd[52223]: Invalid user admin from 203.0.113.60
Dec 29 08:50:32 server sshd[52223]: Failed password for invalid user admin from 203.0.113.60 port 50231 ssh2
Dec 29 08:55:25 server sshd[53334]: Invalid user guest from 192.0.2.40
Dec 29 08:55:27 server sshd[53334]: Failed password for invalid user guest from 192.0.2.40 port 51234 ssh2
Dec 29 09:00:20 server sshd[54445]: Failed password for root from 203.0.113.70 port 52134 ssh2
Dec 29 09:05:10 server sshd[55556]: Invalid user test from 192.0.2.30
Dec 29 09:05:12 server sshd[55556]: Failed password for invalid user test from 192.0.2.30 port 53123 ssh2
Dec 29 09:10:30 server sshd[56667]: Failed password for root from 203.0.113.80 port 49123 ssh2
Dec 29 09:15:40 server sshd[57778]: Invalid user admin from 192.0.2.20
Dec 29 09:15:42 server sshd[57778]: Failed password for invalid user admin from 192.0.2.20 port 51123 ssh2
Dec 29 09:20:50 server sshd[58889]: Failed password for root from 203.0.113.90 port 53134 ssh2
Dec 29 09:25:15 server sshd[60000]: Invalid user hacker from 192.0.2.10
Dec 29 09:25:17 server sshd[60000]: Failed password for invalid user hacker from 192.0.2.10 port 54123 ssh2
Dec 29 09:30:30 server sshd[61111]: Invalid user admin from 203.0.113.100
Dec 29 09:30:32 server sshd[61111]: Failed password for invalid user admin from 203.0.113.100 port 55234 ssh2
Dec 29 09:35:20 server sshd[62222]: Failed password for root from 203.0.113.110 port 57231 ssh2
Dec 29 09:40:25 server sshd[63333]: Invalid user guest from 192.0.2.70
Dec 29 09:40:27 server sshd[63333]: Failed password for invalid user guest from 192.0.2.70 port 58123 ssh2
Dec 29 09:45:15 server sshd[64444]: Failed password for root from 203.0.113.120 port 56234 ssh2
Dec 29 09:50:05 server sshd[65555]: Invalid user test from 192.0.2.60
Dec 29 09:50:07 server sshd[65555]: Failed password for invalid user test from 192.0.2.60 port 59123 ssh2
Dec 29 09:55:45 server sshd[66666]: Failed password for root from 203.0.113.130 port 51234 ssh2
Dec 29 10:00:25 server sshd[67777]: Invalid user admin from 192.0.2.50
Dec 29 10:00:27 server sshd[67777]: Failed password for invalid user admin from 192.0.2.50 port 50234 ssh2
Dec 29 10:05:15 server sshd[68888]: Failed password for root from 203.0.113.140 port 59123 ssh2
Dec 29 10:10:10 server sshd[70000]: Invalid user guest from 192.0.2.90
Dec 29 10:10:12 server sshd[70000]: Failed password for invalid user guest from 192.0.2.90 port 53123 ssh2
Dec 29 10:15:20 server sshd[71111]: Failed password for root from 89.208.198.120 port 55231 ssh2
Dec 29 10:20:30 server sshd[72222]: Invalid user hacker from 192.0.2.80
Dec 29 10:20:32 server sshd[72222]: Failed password for invalid user hacker from 192.0.2.80 port 50123 ssh2
Dec 29 10:25:15 server sshd[73333]: Invalid user admin from 203.0.113.160
Dec 29 10:25:17 server sshd[73333]: Failed password for invalid user admin from 203.0.113.160 port 56134 ssh2
Dec 29 10:30:25 server sshd[74444]: Failed password for root from 203.0.113.170 port 51123 ssh2
Dec 29 10:35:30 server sshd[75555]: Invalid user test from 192.0.2.100
Dec 29 10:35:32 server sshd[75555]: Failed password for invalid user test from 192.0.2.100 port 50112 ssh2
Dec 29 10:40:20 server sshd[76666]: Failed password for root from 203.0.113.180 port 50123 ssh2
Dec 29 10:45:10 server sshd[77777]: Invalid user guest from 192.0.2.110
Dec 29 10:45:12 server sshd[77777]: Failed password for invalid user guest from 192.0.2.110 port 53123 ssh2
Dec 29 10:50:30 server sshd[78888]: Failed password for root from 203.0.113.190 port 53112 ssh2
Dec 29 10:55:15 server sshd[80000]: Invalid user admin from 192.0.2.120
Dec 29 10:55:17 server sshd[80000]: Failed password for invalid user admin from 192.0.2.120 port 54123 ssh2”
EOL
echo -e "\e[33mSimulated log entries added to /var/log/auth.log.\e[0m"

# Final cleanup and checks
echo -e "\e[33mCleaning up...\e[0m"
apt autoremove -y && apt autoclean
sleep 2  # Wait for 2 seconds

echo -e "\n\n\n\n"  # Add two blank lines for spacing
echo -e "\e[33mSystem setup complete. Tools and users have been created.\e[0m"
exit 0
