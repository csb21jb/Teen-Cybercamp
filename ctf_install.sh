#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use: sudo ./ctf_setup.sh"
  exit 1
fi

########################### 
# INSTALLING REQUIRED SOFTWARE 
########################### 
echo 
echo "==================================" 
echo "Installing required software..." 
echo "==================================" 
echo

export DEBIAN_FRONTEND=noninteractive

# Set the language and timezone
echo 'locales locales/default_environment_locale select en_US.UTF-8' | debconf-set-selections
echo 'locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8' | debconf-set-selections
echo 'tzdata tzdata/Areas select America' | debconf-set-selections
echo 'tzdata tzdata/Zones/America select New_York' | debconf-set-selections


# Update system and install required software
apt update && apt upgrade -y
apt install -y vsftpd openssl exiftool coreutils ssh whois ftp sudo file nikto net-tools apache2

#########################
# CONFIGURING FTP SERVER AND FILES
#########################

echo 
echo "==================================" 
echo "Configuring FTP server..." 
echo "==================================" 
echo

# Enable and start FTP service
echo "Configuring and starting FTP server..."
service vsftpd start
update-rc.d vsftpd defaults

# Configure vsftpd to allow FTP user access
echo "anonymous_enable=YES
local_enable=YES
write_enable=YES
chroot_local_user=YES
anon_root=/home/ftpuser/ftp
allow_writeable_chroot=YES" >> /etc/vsftpd.conf
service vsftpd restart

# Uncomment if using systemctl
#systemctl enable vsftpd
#systemctl start vsftpd

###########################
# CONFIGURING USERS
########################### 

echo 
echo "==================================" 
echo "Configuring USERS..." 
echo "==================================" 
echo

# Function to generate DES-encrypted passwords
generate_des_password() {
  local plain_text_password=$1
  mkpasswd -m des "$plain_text_password"
}

# Create users
echo "Creating CTF users with DES-encrypted passwords..."


###########################
# CONFIGURING SALLY'S HOME FOLDER
###########################

echo
echo "=================================="
echo "Setting up Sally's home folder..."
echo "=================================="
echo

#Sally
if ! id -u sally &>/dev/null; then
  DES_PASSWORD_SALLY=$(generate_des_password "Sally1234!")
  useradd -m -s /bin/bash -p "$DES_PASSWORD_SALLY" sally
  echo "User 'sally' created."
else
  echo "User 'sally' already exists. Skipping creation."
fi


SALLY_HOME="/home/sally"

# Create directories
mkdir -p "$SALLY_HOME/Documents"
mkdir -p "$SALLY_HOME/Downloads"
mkdir -p "$SALLY_HOME/Pictures"
mkdir -p "$SALLY_HOME/Projects"

# Generate 15 random files in each folder
generate_random_files() {
  local target_dir=$1
  for i in {1..15}; do
    case $((RANDOM % 5)) in
      0) touch "$target_dir/classified$i.txt" ;;
      1) touch "$target_dir/secret_file$i.docx" ;;
      2) touch "$target_dir/test_script$i.sh" ;;
      3) touch "$target_dir/confidential_financial_report$i.pdf" ;;
      4) touch "$dictator/employee_information$i.csv" ;;
    esac
  done
}

# Generate files in each folder
generate_random_files "$SALLY_HOME/Documents"
generate_random_files "$SALLY_HOME/Downloads"
generate_random_files "$SALLY_HOME/Pictures"
generate_random_files "$SALLY_HOME/Projects"

# Download the picture to Pictures folder and rename it
echo "Downloading private image for Sally..."
wget -q -O "$SALLY_HOME/Pictures/private.jpg" https://github.com/csb21jb/Teen-Cybercamp/raw/refs/heads/main/private

# Set ownership and permissions
chown -R sally:sally "$SALLY_HOME"
chmod -R 700 "$SALLY_HOME"

echo "Sally's home folder setup completed."


###########################
# CONFIGURING BOB'S HOME FOLDER
###########################

echo
echo "=================================="
echo "Setting up Bob's home folder..."
echo "=================================="
echo

# Bob
if ! id -u bob &>/dev/null; then
  DES_PASSWORD_BOB=$(generate_des_password "SecureBob!2025")
  useradd -m -s /bin/bash -p "$DES_PASSWORD_BOB" bob
  echo "User 'bob' created."
else
  echo "User 'bob' already exists. Skipping creation."
fi


BOB_HOME="/home/bob"

# Create directories
mkdir -p "$BOB_HOME/Documents"
mkdir -p "$BOB_HOME/Downloads"
mkdir -p "$BOB_HOME/Pictures"
mkdir -p "$BOB_HOME/Projects"

# Generate 15 random files in each folder
generate_random_files() {
  local target_dir=$1
  for i in {1..15}; do
    case $((RANDOM % 5)) in
      0) touch "$target_dir/classified$i.txt" ;;
      1) touch "$target_dir/secret_file$i.docx" ;;
      2) touch "$target_dir/test_script$i.sh" ;;
      3) touch "$target_dir/confidential_financial_report$i.pdf" ;;
      4) touch "$target_dir/employee_information$i.csv" ;;
    esac
  done
}

# Generate files in each folder
generate_random_files "$BOB_HOME/Documents"
generate_random_files "$BOB_HOME/Downloads"
generate_random_files "$BOB_HOME/Pictures"
generate_random_files "$BOB_HOME/Projects"



# Set ownership and permissions
chown -R bob:bob "$BOB_HOME"
chmod -R 700 "$BOB_HOME"

###########################
# BOB'S ENCRYPTED EMAIL SETUP
###########################

echo
echo "=================================="
echo "Setting up encrypted email for Bob..."
echo "=================================="
echo

BOB_HOME="/home/bob"
DOCUMENTS_DIR="$BOB_HOME/Documents"
ENCRYPTED_FILE="$DOCUMENTS_DIR/admin_email.enc"
TEMP_EMAIL_FILE="/tmp/admin_email.txt"

# Ensure Bob's Documents folder exists
mkdir -p "$DOCUMENTS_DIR"

# Create the email file with the private key in the body
cat > "$TEMP_EMAIL_FILE" <<EOF
From: Sally Johnson <sally.johnson@example.com>
To: Bob Thomas <bob.thomas@example.com>
Subject: Admin Access Details

Hi Bob,

As discussed in our recent meeting, you’ll need access to the admin account to help address some of the security issues we’ve been experiencing. Below are the details you need to log in.

Also note, that if you need to use the admin account for anything, the password is: "ADM!Nissecure2025".


Lastly, as an extra step of precaution, I need you to create a script that must be ran as sudo to log into the root account. This is the last layer of defense, so don't mess this up. It should contain secrets that only we know and keep it out of plain sight - nobody looks at logs anyway LOL…

{ADMIN_DECRYPT_9Y7W}

v/r,  
Sally Johnson  
IT Admin  
EOF

# Encrypt the email file with OpenSSL
openssl enc -aes-256-cbc -salt -in "$TEMP_EMAIL_FILE" -out "$ENCRYPTED_FILE" -k 'SecureBob!2025'

# Clean up the temporary email file
rm -f "$TEMP_EMAIL_FILE"

# Set permissions and ownership for the encrypted file
chown bob:bob "$ENCRYPTED_FILE"
chmod 600 "$ENCRYPTED_FILE"


echo "Bob's home folder and encrypted email is completed."


###########################
# ADMIN USER CREATION
###########################

echo
echo "=================================="
echo "Creating admin user..."
echo "=================================="
echo

# Admin
if ! id -u admin &>/dev/null; then
  DES_PASSWORD_ADMIN=$(generate_des_password "ADM!Nissecure2025")
  useradd -m -s /bin/bash -G sudo -p "$DES_PASSWORD_ADMIN" admin
  echo "User 'admin' created."
else
  echo "User 'admin' already exists. Skipping creation."
fi




echo
echo "=================================="
echo "Creating SSH keys for admin user..."
echo "=================================="
echo

# Define admin's home directory
ADMIN_HOME="/home/admin"

# Create the hidden note file
cat > "$ADMIN_HOME/.admin_note.txt" <<EOF
To all Team Members,

We are excited to announce that we are currently testing a new beta version of our workorder website. The test site is available at: http://203.28.50.143:8091

Please note that this is still a work in progress, and some features may be buggy. We appreciate your patience as we continue improving the platform.

Feel free to provide feedback directly to the admin team.

Thank you,
Admin
EOF

# Set ownership and permissions for the hidden file
chown admin:admin "$ADMIN_HOME/.admin_note.txt"
chmod 600 "$ADMIN_HOME/.admin_note.txt"

echo "Hidden admin note created at $ADMIN_HOME/.admin_note.txt"



# FTP User
if ! id -u ftpuser &>/dev/null; then
  DES_PASSWORD_FTP=$(generate_des_password "FTPuser123!")
  useradd -m -s /bin/false -p "$DES_PASSWORD_FTP" ftpuser
  mkdir -p /home/ftpuser/ftp
  chown nobody:nogroup /home/ftpuser/ftp
  chmod 750 /home/ftpuser/ftp
  echo "User 'ftpuser' created."
else
  echo "User 'ftpuser' already exists. Skipping creation."
fi

# Superadmin (Bonus Challenge)
if ! id -u superadmin &>/dev/null; then
  DES_PASSWORD_SUPERADMIN=$(generate_des_password "SuperSecurePassword!")
  useradd -m -s /bin/bash -p "$DES_PASSWORD_SUPERADMIN" superadmin
  echo "User 'superadmin' created."
else
  echo "User 'superadmin' already exists. Skipping creation."
fi

echo "User creation with DES-encrypted passwords completed."


###########################
# CONFIGURING SSH SERVER
########################### 

echo 
echo "==================================" 
echo "Configuring SSH server..." 
echo "==================================" 
echo

# Install and configure SSH server
echo "Installing and configuring SSH server..."
apt install -y openssh-server

# Enable password and key-based authentication
sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config

# Start the SSH service
service ssh start

# Ensure SSH starts on boot
update-rc.d ssh defaults

echo "SSH server configured and running."


############CREATE FTP FILE #######################

# Create and encode the personal_info.txt file for FTP
echo "TmFtZTogU2FsbHkgSm9obnNvbgpBZGRyZXNzOiAxMjM0IEVsbSBTdHJlZXQsIE1OLCBVU0EKRW1haWw6IHNhbGx5LmpvaG5zb25AYXdkLmNvbQpQaG9uZTogKDU1NSkgODY3LTUzMDkKQmlydGhkYXk6IE1hcmNoIDE1LCAxOTg1CgpFbXBsb3ltZW50IERldGFpbHM6Ci0gUG9zaXRpb246IElUIEFkbWluaXN0cmF0b3IKLSBEZXBhcnRtZW50OiBDeWJlcnNlY3VyaXR5IE9wZXJhdGlvbnMKKipJbXBvcnRhbnQgTm90ZXMqKgotIFBlcnNvbmFsIFBhc3N3b3JkOiBVMkZzYkhreE1qTTBJUT09Cgp7RlRQX0RPQ1NfN0c1TX0=" > /home/ftpuser/ftp/personal_info.txt

# Set permissions for the file
chmod 644 /home/ftpuser/ftp/personal_info.txt
chown ftpuser:nogroup /home/ftpuser/ftp/personal_info.txt
chmod 755 /home/ftpuser/ftp

echo "FTP personal_info.txt file created and encoded in Base64."


################


###########################
# APACHE WEB SERVER SETUP
###########################

echo
echo "=================================="
echo "Setting up Apache web server..."
echo "=================================="
echo

# Enable and start Apache
service apache2 start

# Set up the website directory
WEB_DIR="/var/www/html"
mkdir -p "$WEB_DIR"

# Create login.html
cat > "$WEB_DIR/login.html" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>CyberTronics Inc. - Employee Login</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: Arial, sans-serif;
      background: #f4f4f4;
    }

    header {
      background: #003366;
      color: #fff;
      padding: 20px 0;
      text-align: center;
    }

    header h1 {
      margin: 0;
      font-size: 28px;
      letter-spacing: 1px;
    }

    .login-container {
      max-width: 400px;
      margin: 50px auto 0 auto;
      padding: 20px;
      background: #fff;
      border: 1px solid #ddd;
      border-radius: 5px;
    }

    .login-container h2 {
      margin-top: 0;
      margin-bottom: 20px;
      text-align: center;
      color: #333;
    }

    .login-field {
      margin-bottom: 15px;
    }

    .login-field label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
      color: #333;
    }

    .login-field input[type="text"],
    .login-field input[type="password"] {
      width: 100%;
      padding: 10px;
      box-sizing: border-box;
      font-size: 16px;
      border: 1px solid #ddd;
      border-radius: 3px;
    }

    button {
      width: 100%;
      padding: 10px;
      border: none;
      border-radius: 3px;
      font-size: 16px;
      color: #fff;
      background: #003366;
      cursor: pointer;
      transition: background 0.3s ease;
    }

    button:hover {
      background: #002244;
    }

    .message {
      margin-top: 20px;
      font-weight: bold;
      text-align: center;
    }

    .error {
      color: #b20000;
    }

    .success {
      color: #007700;
    }

    footer {
      text-align: center;
      margin-top: 40px;
      padding: 10px;
      color: #666;
    }
  </style>
</head>
<body>
  <header>
    <h1>CyberTronics Inc.</h1>
  </header>
  
  <div class="login-container">
    <h2>Employee Login</h2>
    <div class="login-field">
      <label for="username">Username</label>
      <input type="text" id="username" placeholder="Enter your username" />
    </div>
    <div class="login-field">
      <label for="password">Password</label>
      <input type="password" id="password" placeholder="Enter your password" />
    </div>
    <button id="loginBtn">Login</button>
    <div id="message" class="message"></div>
  </div>
  
  <footer>
    &copy; 2025 CyberTronics Inc. All rights reserved.
  </footer>
  
  <script>
    document.getElementById("loginBtn").addEventListener("click", function () {
      const username = document.getElementById("username").value.trim();
      const password = document.getElementById("password").value.trim();
      const messageDiv = document.getElementById("message");

      // Check for SQL injection patterns in the password field
      const isSqliPayload = [
        "' OR '1'='1",
        '" OR "1"="1',
        "OR 1=1",
        "UNION SELECT",
        "';--",
        "admin'--",
        "' OR 1=1 --",
      ].some((pattern) => username.toLowerCase().includes(pattern.toLowerCase()));

      if (isSqliPayload) {
        // Redirect to workorder.html if the SQLi payload is detected
        window.location.href = "workorder.html";
      } else {
        // Display error message for invalid login
        messageDiv.textContent = "Invalid login credentials.";
        messageDiv.className = "message error";
      }
    });
  </script>
</body>
</html>
EOF


  



# Create workorder.html
cat > "$WEB_DIR/workorder.html" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>CyberTronics Inc. - Administrator Work Orders</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: Arial, sans-serif;
      background: #f4f4f4;
    }

    header {
      background: #003366;
      color: #fff;
      padding: 20px 0;
      text-align: center;
    }

    header h1 {
      margin: 0;
      font-size: 28px;
      letter-spacing: 1px;
    }

    .container {
      max-width: 900px;
      margin: 40px auto;
      padding: 20px;
      background: #fff;
      border: 1px solid #ddd;
      border-radius: 5px;
    }

    h2 {
      margin-top: 0;
      text-align: center;
      color: #333;
    }

    p.notice {
      background: #ffffcc;
      border: 1px solid #ddd;
      padding: 10px;
      border-radius: 3px;
      margin-bottom: 20px;
      text-align: center;
      font-style: italic;
      color: #555;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
    }

    th, td {
      border: 1px solid #ddd;
      padding: 12px;
      text-align: left;
      vertical-align: top;
    }

    th {
      background: #f1f1f1;
      font-weight: bold;
    }

    .high {
      color: #b20000;
      font-weight: bold;
    }

    .critical {
      background: #ffbbbb;
      color: #b20000;
      font-weight: bold;
    }

    .footer-text {
      text-align: center;
      margin-top: 20px;
      color: #666;
    }
  </style>
</head>
<body>
  <header>
    <h1>CyberTronics Inc.</h1>
  </header>

  <div class="container">
    <h2>Administrator Work Orders</h2>
    
    <!-- Notice or welcome message -->
    <p class="notice">
       {SQL_inJection_9U6T}
    </p>

    <table>
      <thead>
        <tr>
          <th>Ticket ID</th>
          <th>Date</th>
          <th>Requester</th>
          <th>Issue</th>
          <th>Priority</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <!-- Original 12 entries -->
        <tr>
          <td>CT-1001</td>
          <td>01/02/2025</td>
          <td>J. Smith</td>
          <td>Password reset needed for HR system</td>
          <td>Medium</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1002</td>
          <td>01/03/2025</td>
          <td>M. Brown</td>
          <td>Cannot connect to the office Wi-Fi network</td>
          <td>Medium</td>
          <td>In Progress</td>
        </tr>
        <tr>
          <td>CT-1003</td>
          <td>01/05/2025</td>
          <td>T. Johnson</td>
          <td>Printer jam on 3rd floor, hallway printer</td>
          <td>Low</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1004</td>
          <td>01/06/2025</td>
          <td>S. Thompson</td>
          <td>PC won’t boot, might be hardware failure</td>
          <td class="high">High</td>
          <td>In Progress</td>
        </tr>
        <tr>
          <td>CT-1005</td>
          <td>01/07/2025</td>
          <td>D. Walters</td>
          <td>Office phone does not ring for incoming calls</td>
          <td>Medium</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1006</td>
          <td>01/08/2025</td>
          <td>K. Mills</td>
          <td>Found a strange file in /var/logs asking for a password, looks suspicious</td>
          <td class="critical">Critical</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1007</td>
          <td>01/09/2025</td>
          <td>G. Lopez</td>
          <td>Office phone stuck in do-not-disturb mode</td>
          <td>Low</td>
          <td>Closed</td>
        </tr>
        <tr>
          <td>CT-1008</td>
          <td>01/10/2025</td>
          <td>E. Rodriguez</td>
          <td>Several desktop icons disappeared</td>
          <td class="critical">Critical</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1009</td>
          <td>01/11/2025</td>
          <td>O. Wayne</td>
          <td>Outlook emails appear corrupted or blank</td>
          <td class="high">High</td>
          <td>In Progress</td>
        </tr>
        <tr>
          <td>CT-1010</td>
          <td>01/12/2025</td>
          <td>L. Davis</td>
          <td>Extremely slow connection on the remote VPN</td>
          <td>Medium</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1011</td>
          <td>01/13/2025</td>
          <td>H. Li</td>
          <td>Software license expired (cannot launch application)</td>
          <td class="high">High</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1012</td>
          <td>01/14/2025</td>
          <td>P. Parker</td>
          <td>Screen flickers randomly, suspect video driver</td>
          <td>Medium</td>
          <td>Open</td>
        </tr>
        
        <!-- 35 additional entries -->
        <tr>
          <td>CT-1013</td>
          <td>01/15/2025</td>
          <td>R. Summers</td>
          <td>Collaboration software unresponsive during video calls</td>
          <td>High</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1014</td>
          <td>01/16/2025</td>
          <td>S. Evans</td>
          <td>Outdated antivirus, needs renewal</td>
          <td class="critical">Critical</td>
          <td>In Progress</td>
        </tr>
        <tr>
          <td>CT-1015</td>
          <td>01/17/2025</td>
          <td>K. Marsh</td>
          <td>Keyboard keys sticking, hardware replacement needed</td>
          <td>Low</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1016</td>
          <td>01/18/2025</td>
          <td>C. Diaz</td>
          <td>Shared drive permissions not working as expected</td>
          <td>High</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1017</td>
          <td>01/19/2025</td>
          <td>B. Allen</td>
          <td>Second monitor not detected on docking station</td>
          <td>Medium</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1018</td>
          <td>01/20/2025</td>
          <td>A. Walker</td>
          <td>VPN client crashes unexpectedly</td>
          <td class="high">High</td>
          <td>In Progress</td>
        </tr>
        <tr>
          <td>CT-1019</td>
          <td>01/21/2025</td>
          <td>F. Patel</td>
          <td>Microsoft Teams not launching</td>
          <td>Medium</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1020</td>
          <td>01/22/2025</td>
          <td>D. King</td>
          <td>Application error: “Missing DLL file” message</td>
          <td class="critical">Critical</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1021</td>
          <td>01/23/2025</td>
          <td>V. Kim</td>
          <td>Intranet site showing 404 errors for certain pages</td>
          <td>Medium</td>
          <td>Closed</td>
        </tr>
        <tr>
          <td>CT-1022</td>
          <td>01/24/2025</td>
          <td>L. Nguyen</td>
          <td>Touchscreen on conference room display unresponsive</td>
          <td class="high">High</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1023</td>
          <td>01/25/2025</td>
          <td>M. Carter</td>
          <td>Java update required for finance application</td>
          <td>Low</td>
          <td>In Progress</td>
        </tr>
        <tr>
          <td>CT-1024</td>
          <td>01/26/2025</td>
          <td>J. Wilson</td>
          <td>Phone app voicemail notifications missing</td>
          <td>Low</td>
          <td>Closed</td>
        </tr>
        <tr>
          <td>CT-1025</td>
          <td>01/27/2025</td>
          <td>A. Barnes</td>
          <td>Random system freeze, suspect memory issue</td>
          <td class="high">High</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1026</td>
          <td>01/28/2025</td>
          <td>G. White</td>
          <td>Receives “disk full” error but plenty of free space</td>
          <td>Medium</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1027</td>
          <td>01/29/2025</td>
          <td>N. Brooks</td>
          <td>Slow login times on domain accounts</td>
          <td>Medium</td>
          <td>In Progress</td>
        </tr>
        <tr>
          <td>CT-1028</td>
          <td>01/30/2025</td>
          <td>W. Ray</td>
          <td>Cannot print in color on Marketing printer</td>
          <td>Low</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1029</td>
          <td>01/31/2025</td>
          <td>H. Martin</td>
          <td>Excel macros disabled, project spreadsheets not working</td>
          <td class="critical">Critical</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1030</td>
          <td>02/01/2025</td>
          <td>F. Stone</td>
          <td>Access request for new CRM portal</td>
          <td>Low</td>
          <td>Closed</td>
        </tr>
        <tr>
          <td>CT-1031</td>
          <td>02/02/2025</td>
          <td>L. Green</td>
          <td>Zoom client update fails with unknown error</td>
          <td>Medium</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1032</td>
          <td>02/03/2025</td>
          <td>P. Diaz</td>
          <td>Headset not recognized by computer</td>
          <td>Low</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1033</td>
          <td>02/04/2025</td>
          <td>R. Hall</td>
          <td>Mobile device management enrollment issue</td>
          <td>High</td>
          <td>In Progress</td>
        </tr>
        <tr>
          <td>CT-1034</td>
          <td>02/05/2025</td>
          <td>T. Bell</td>
          <td>Timeclock kiosk freezing during login</td>
          <td>Medium</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1035</td>
          <td>02/06/2025</td>
          <td>C. Beck</td>
          <td>Security software false positives, blocking legitimate apps</td>
          <td class="Critical">Critical</td>
          <td>In Progress</td>
        </tr>
        <tr>
          <td>CT-1036</td>
          <td>02/07/2025</td>
          <td>U. Morris</td>
          <td>Remote desktop lagging during peak hours</td>
          <td>Medium</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1037</td>
          <td>02/08/2025</td>
          <td>A. Patel</td>
          <td>Cannot sync documents to cloud storage</td>
          <td>Low</td>
          <td>Closed</td>
        </tr>
        <tr>
          <td>CT-1038</td>
          <td>02/09/2025</td>
          <td>J. Black</td>
          <td>System clock keeps resetting to incorrect time</td>
          <td>Medium</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1039</td>
          <td>02/10/2025</td>
          <td>M. Clark</td>
          <td>PowerPoint slides missing embedded videos</td>
          <td>Low</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1040</td>
          <td>02/11/2025</td>
          <td>Q. Reed</td>
          <td>Unable to open PDF attachments in Outlook</td>
          <td>Medium</td>
          <td>In Progress</td>
        </tr>
        <tr>
          <td>CT-1041</td>
          <td>02/12/2025</td>
          <td>K. Brooks</td>
          <td>HR compliance tool license not recognized</td>
          <td>High</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1042</td>
          <td>02/13/2025</td>
          <td>C. Adams</td>
          <td>Weird pop-up messages about “script debugging”</td>
          <td>Low</td>
          <td>In Progress</td>
        </tr>
        <tr>
          <td>CT-1043</td>
          <td>02/14/2025</td>
          <td>T. Morgan</td>
          <td>Wireless mouse lagging, tried changing batteries</td>
          <td>Low</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1044</td>
          <td>02/15/2025</td>
          <td>D. Rice</td>
          <td>Data import script failing due to “permissions error”</td>
          <td class="high">High</td>
          <td>In Progress</td>
        </tr>
        <tr>
          <td>CT-1045</td>
          <td>02/16/2025</td>
          <td>N. Oliver</td>
          <td>Email rules not applying; messages not filtered</td>
          <td>Medium</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1046</td>
          <td>02/17/2025</td>
          <td>M. Garcia</td>
          <td>Company portal auto-logout issue after only 5 minutes</td>
          <td>High</td>
          <td>Open</td>
        </tr>
        <tr>
          <td>CT-1047</td>
          <td>02/18/2025</td>
          <td>E. Gordon</td>
          <td>Screen share feature broken in conference rooms</td>
          <td>Medium</td>
          <td>Open</td>
        </tr>
      </tbody>
    </table>

    <p class="footer-text">
      &copy; 2025 CyberTronics Inc. All rights reserved.
    </p>
  </div>
</body>
</html>
EOF

# Set permissions
chown -R root:www-data "$WEB_DIR"
chmod -R 750 "$WEB_DIR"

echo "Apache web server setup completed. Visit http://<your-server-ip>/login.html to access the login page."










###########################
# Create Restricted Log Script
###########################
echo
echo "=================================="
echo "Creating restricted script in /var/log..."
echo "=================================="
echo

# Define the script location and name
LOG_SCRIPT="/var/log/log.sh"

# Create the log.sh script
cat > "$LOG_SCRIPT" <<'EOF'
#!/bin/bash

echo "LOL, you'll never get in...fool."

# Ensure the script is running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run with root privileges. Use: sudo ./log.sh"
  exit 1
fi

# Prompt for Bob's password
echo -n "Enter Bob's password: "
read -s password
echo

# Validate Bob's password
if [ "$password" != "SecureBob!2025" ]; then
  echo "Incorrect password. Script terminated."
  exit 1
fi

# Define questions and answers
declare -a questions=(
  "What is the default port for SSH?"
  "What command and flags list all and human-readable files in a directory?"
  "Which tool can extract metadata from an image?"
  "What encryption algorithm uses a single key for encryption and decryption?"
  "What command changes file permissions in Linux?"
  "What flag do you use to decode base64 strings on Linux?"
  "What port did the vulnerable software 'VSFTPD 2.3.4' expose that allowed RCE?"
  "What does '-d' mean in the openssl enc command?"
  "What Linux command outputs the content of a file?"
  "What is admin password from Sally’s email?"
  "What type of injection was used on the Juice Shop and the CyberTech websites to gain initial access (lowercase)?"
)

declare -a answers=(
  "22"
  "ls -ah"
  "exiftool"
  "AES"
  "chmod"
  "--decode"
  "6200"
  "decrypt"
  "cat"
  "ADM!Nissecure2025"
  "sql"
)

# Loop through questions
for i in "${!questions[@]}"; do
  echo "${questions[$i]}"
  echo -n "Answer: "
  read user_answer

  if [ "$user_answer" != "${answers[$i]}" ]; then
    echo "Incorrect answer. Script terminated."
    exit 1
  fi
done

# Escalate to root
echo "All questions answered correctly! Escalating privileges to root..."
sudo su
EOF

# Set ownership and permissions for the script 
chown root:root "$LOG_SCRIPT" # Ownership: root user and root group 
chmod 711 "$LOG_SCRIPT" # execute-only for non-root users)

echo "Restricted script created at $LOG_SCRIPT"

###########################
# Root Flag Creation
###########################

echo
echo "=================================="
echo "Creating final flag in /root..."
echo "=================================="
echo

# Define the file path
ROOT_FLAG="/root/flag.txt"

# Create the flag file with the motivational message
cat > "$ROOT_FLAG" <<EOF
Congratulations on reaching the root flag!

This Capture the Flag exercise has tested not only your technical skills but also your persistence and problem-solving abilities. Cybersecurity is not just a job—it’s a commitment to continuous learning and adapting to a world of evolving threats.

The work you’ve done here replicates real-world penetration tests and security contracts. Remember, success in this field is built on hard work, ethical principles, and a relentless drive to protect systems and people.

Keep pushing forward, keep learning, and remember: the strongest defense is a curious and determined mind.

{ROOT_FLAG_1X7Z}
EOF

# Set ownership and permissions for the flag
chown root:root "$ROOT_FLAG"
chmod 400 "$ROOT_FLAG"  # Read-only for root

echo "Final flag created at $ROOT_FLAG"


