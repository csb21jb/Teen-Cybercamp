#!/bin/bash

#################################################### Ensure the script is being run as root ############
if [[ $EUID -ne 0 ]]; then
   echo "\e[1;31mThis script must be run as root!\e[0m" 
   exit 1
fi

echo -e "\e[33mStarting system setup...\e[0m"
sleep 2  # Wait for 2 seconds

echo -e "\n\n\n\n"  # Add two blank lines for spacing
###################################################### Update and upgrade the system ####################
echo -e "\e[33mUpdating system packages...\e[0m"
apt update && apt upgrade -y
sleep 2  # Wait for 2 seconds

echo -e "\n\n\n\n"  # Add two blank lines for spacing
###################################################### Set the language and timezone #####################
echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections
echo 'locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8' | debconf-set-selections
echo 'tzdata tzdata/Areas select America' | debconf-set-selections
echo 'tzdata tzdata/Zones/America select New_York' | debconf-set-selections
sleep 2  # Wait for 2 seconds

echo -e "\n\n\n\n"  # Add two blank lines for spacing

####################################################### Install necessary tools ##########################
echo -e "\e[33mInstalling required tools...\e[0m"
for tool in python3 curl sudo openssl git nmap wget net-tools openssh-server build-essential vim apt-transport-https ca-certificates software-properties-common systemd gnupg lsb-release nano debconf-utils; do apt install -y "$tool" && sleep 1; done

sleep 2  # Wait for 2 seconds

echo -e "\n\n\n\n"  # Add two blank lines for spacing

######################################################## Setup Docker ######################################
echo -e "\n\n\n\n"  # Add two blank lines for spacing
echo -e "\e[33mSetting up Docker...\e[0m"
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Ensure Docker service is running
systemctl enable docker
systemctl start docker
sleep 2  # Wait for 2 seconds

echo -e "\n\n\n\n"  # Add two blank lines for spacing

#################################### Create student usernames and passwords ##############################

echo -e "\e[33mCreating student user accounts...\e[0m"
accounts=(
# Configure the "testuser" account
    "student000:UvEZBZFujl"
    "student001:W0A3wuEc54"
    "student002:CFM43WIF8W"
    "student003:e1j3hBqX5k"
    "student004:O5vrhwWl8z"
    "student005:UWAaD8lIRB"
    "student006:EDiHeYuIA2"
    "student007:IITXgxMdIa"
    "student008:ASzntVm917"
    "student009:55rfLm4EYB"
    "student010:gxO9HhAHlH"
    "student011:8neospclxW"
    "student012:2geY9gfUoN"
    "student013:SeVCP6emWk"
    "student014:4k6nMpEK2r"
    "student015:EvcuBx2Don"
    "student016:5bz1FtXLAh"
    "student017:nPbK1Ud810"
    "student018:NJ06CIbDe2"
    "student019:7CYsjgrUlZ"
    "student020:Y1zm7Lj7SO"
    "student021:aTgwLakHsh"
    "student022:Zp4OYmPGTi"
    "student023:ODe1BiLDG3"
    "student024:yhOp8Do6Ha"
    "student025:gs8uYWEBFM"
    "student026:9pHGg6osmW"
    "student027:AYVoEc1MJu"
    "student028:9Wvf0FCbNJ"
    "student029:nIXWgd8ENx"
    "student030:xc0KYBW52X"
    "student031:P42CK1IR6c"
    "student032:PCwe4mRNZK"
    "student033:SAEkS7dK1T"
    "student034:8cy32CVLQh"
    "student035:UQkG4XkN7R"
    "student036:iKKdMYg7pz"
    "student037:mYER3q8DRm"
    "student038:HW6zi8lV59"
    "student039:2B9cSaZ2x2"
    "student040:H9BcPvtq1g"
    "student041:bXXRyBscIL"
    "student042:iTLOjLMX10"
    "student043:pomWhleon7"
    "student044:BcnoiTwsFo"
    "student045:zPyN1CUY9f"
    "student046:IjAy9bBKCS"
    "student047:9qa2vJIsSm"
    "student048:J4QidX1NY0"
    "student049:ZlZU1Fjydg"
    "student050:9lisDAhH6W"
    "student051:yRH7MXMttE"
    "student052:Y2MQwmevsd"
    "student053:xEg3W705br"
    "student054:4fP6UnpJr2"
    "student055:Mq3tSXuSuk"
    "student056:8EdRZSZzRl"
    "student057:Un3q4RqCjq"
    "student058:SM9FXdJmPi"
    "student059:04SCcqKpFU"
    "student060:HqXiNzLJFS"
    "student061:wxUP6b7Yxo"
    "student062:anIWEIfe7e"
    "student063:TfRhsxvyH6"
    "student064:AjCszEifG2"
    "student065:yu7kLCJpod"
    "student066:Wq1NNmQ8JK"
    "student067:qEu7BmM9eT"
    "student068:GYVCD7FmxY"
    "student069:AGCroRGuP1"
    "student070:teUHe48PqH"
    "student071:SkqWKL8w3V"
    "student072:qcQazC9nkE"
    "student073:vUXsbUGhQF"
    "student074:jm0vmJ6WUa"
    "student075:xY7155InQg"
    "student076:fVcvEtVxOo"
    "student077:dKzmE0p9Dc"
    "student078:cjaG3ixLD6"
    "student079:Hbaw1ePgmB"
    "student080:iWzlLB5gdM"
    "student081:rKPO1lrT5W"
    "student082:0EpF1N4UXt"
    "student083:0mPrGt5OVO"
    "student084:S6RM6I2kiL"
    "student085:mqy640mEAz"
    "student086:d1HjwNNdOv"
    "student087:Yp2x8ZP9ZX"
    "student088:BuakBomsST"
    "student089:wZEaa3Ya6e"
    "student090:Q8w7yREnGV"
    "student091:63Gsc3QGVI"
    "student092:4COUHArFar"
    "student093:n5GNXIGRZB"
    "student094:DXsNBi9j4N"
    "student095:0HonbCDOQ5"
    "student096:zVo6MvNGKb"
    "student097:wSTNl6PHMk"
    "student098:eOmFjFk6gx"
    "student099:KiXdpja8g3"
    "student100:UTJvN76qwK"
    "student101:fS7zeu8Pnx"
    "student102:oKqql10vA9"
    "student103:JXFhMh7ocL"
    "student104:S6aBGHkMUs"
    "student105:ASfo52FMbi"
    "student106:apYlIEnqbF"
    "student107:cobqZ30b6w"
    "student108:DJDusT80DQ"
    "student109:VJl9LgyVNQ"
    "student110:VN15QKFnGU"
    "student111:Xh6aMMxYoH"
    "student112:CRavagoS6x"
    "student113:CncvxCPxrk"
    "student114:emQOnJm14p"
    "student115:Qob1QxpXDM"
    "student116:cnnhIZhdX5"
    "student117:87rbAiwmOe"
    "student118:bcTTH5A6VG"
    "student119:r0PfB0duwf"
    "student120:iJWsxqeL2c"
    "student121:UmLTvmQGEG"
    "student122:0wPjs4uPPh"
    "student123:iJH2Q1ilbd"
    "student124:H0PXos6aOF"
    "student125:19jSYu9KHF"
    # Add more usernames/passwords as needed...

)

# Loop through the accounts and create users
for account in "${accounts[@]}"; do
    username=$(echo "$account" | cut -d: -f1)  # Extract the username
    password=$(echo "$account" | cut -d: -f2)  # Extract the password

    # Create the user and set the password
    useradd -m -s /bin/bash "$username"
    echo "$username:$password" | chpasswd

    echo -e "\e[32mUser $username created successfully!\e[0m"
done

echo -e "\e[33mAll student user accounts have been created.\e[0m"
#######################################################################################################
sleep 2  # Wait for 2 seconds


echo -e "\n\n\n\n"  # Add two blank lines for spacing
############################## Deploy the pdf-parser.py tool to /usr/local/bin #########################
echo -e "\e[33mDownloading and placing pdf-parser.py in /usr/local/bin...\e[0m"
wget -O /usr/local/bin/pdf-parser.py https://raw.githubusercontent.com/csb21jb/Teen-Cybercamp/refs/heads/main/pdf-parser.py
chmod +x /usr/local/bin/pdf-parser.py
# Append the PATH modification to /etc/profile
echo 'export PATH="/usr/local/bin:$PATH"' | sudo tee -a /etc/profile
source /etc/profile
echo -e "\e[33mUpdated PATH: $PATH\e[0m"
sleep 2  # Wait for 2 seconds

###############################################################################################
echo -e "\n\n\n\n"  # Add two blank lines for spacing
# Simulate log entries in auth.log for testing purposes
echo -e "\e[33mCreating simulated SSH attack log entries...\e[0m"
echo -e "\n\n\n\n"  # Add two blank lines for spacing

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
chmod 755 /var/log/auth.log
echo -e "\e[33mSimulated log entries added to /var/log/auth.log.\e[0m"

################################### Final cleanup and checks ###################################
echo -e "\e[33mCleaning up...\e[0m"
apt autoremove -y && apt autoclean
sleep 2  # Wait for 2 seconds

################################### Setup docker containers from Git Hub ########################
echo -e "\n\n\n\n"  # Add two blank lines for spacing

# Ensure the script is being run from /root
if [[ $(pwd) != "/root" ]]; then
    echo -e "\e[33mSwitching to /root directory...\e[0m"
    cd /root || {
        echo -e "\e[31mFailed to switch to /root directory. Exiting...\e[0m"
        exit 1
    }
else
    echo -e "\e[33mAlready in /root directory.\e[0m"
fi

# Download the docker-compose.yaml file
echo -e "\e[33mDownloading the docker-compose.yaml file...\e[0m"
curl -fsSL -o docker-compose.yaml https://raw.githubusercontent.com/csb21jb/Teen-Cybercamp/refs/heads/main/docker-compose.yaml || {
    echo -e "\e[31mFailed to download docker-compose.yaml. Exiting...\e[0m"
    exit 1
}

# Run the docker-compose.yaml file using Docker Compose
echo -e "\e[33mStarting containers with docker-compose up -d...\e[0m"
docker compose up -d || {
    echo -e "\e[31mFailed to run docker-compose.yaml. Exiting...\e[0m"
    exit 1
}

echo -e "\e[32mContainers are up and running in detached mode!\e[0m"
sleep 2  # Wait for 2 seconds

echo -e "\n\n\n\n"  # Add two blank lines for spacing

##############################################

###################################### Adjust SSH ##########################
# Add antiquated formats for metasploitable
echo "Host 172.18.0.3" >> /etc/ssh/ssh_config
echo -e "\tHostKeyAlgorithms +ssh-rsa" >> /etc/ssh/ssh_config
echo -e "\tPubkeyAcceptedAlgorithms +ssh-rsa" >> /etc/ssh/ssh_config
echo "Configuration updated successfully in /etc/ssh/ssh_config."

# Add pass
# Backup the existing SSHD configuration file
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Add or modify the required settings in sshd_config
echo "Updating /etc/ssh/sshd_config..."
sed -i '/^PermitRootLogin /c\PermitRootLogin yes' /etc/ssh/sshd_config
sed -i '/^PubkeyAuthentication /c\PubkeyAuthentication yes' /etc/ssh/sshd_config
sed -i '/^PasswordAuthentication /c\PasswordAuthentication yes' /etc/ssh/sshd_config
sed -i '/^KbdInteractiveAuthentication /c\KbdInteractiveAuthentication yes' /etc/ssh/sshd_config
sed -i '/^UsePAM /c\UsePAM yes' /etc/ssh/sshd_config

# Ensure the settings are added if they don't already exist
grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config || echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
grep -q "^PubkeyAuthentication yes" /etc/ssh/sshd_config || echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
grep -q "^PasswordAuthentication yes" /etc/ssh/sshd_config || echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
grep -q "^KbdInteractiveAuthentication yes" /etc/ssh/sshd_config || echo "KbdInteractiveAuthentication yes" >> /etc/ssh/sshd_config
grep -q "^UsePAM yes" /etc/ssh/sshd_config || echo "UsePAM yes" >> /etc/ssh/sshd_config

# Reload the SSH service to apply changes
echo "Reloading SSH service..."
systemctl restart ssh

echo "Configuration updated successfully. SSH server is now set up to allow password-based login."

##########################################################################################################

echo -e "\e[33mSystem setup complete. Tools and users have been created.\e[0m"
exit 0
