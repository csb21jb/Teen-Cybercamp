![pic](https://github.com/user-attachments/assets/4dd1fc85-1f9e-457d-aa64-b19ca1c84fb5)

# Cyber Bootcamp Deployment Guide

Welcome to the **Cyber Bootcamp** deployment guide! This project provides a robust environment for teaching cybersecurity concepts and running Capture The Flag (CTF) challenges in a virtualized environment. Below is a step-by-step guide to set up your Cyber Bootcamp server, including all necessary prerequisites and configurations.

This Cyber Range provides an immersive and dynamic environment featuring Juice Shop for practicing web vulnerabilities like SQL Injection and XSS, Metasploitable with a multitude of exploitable services, and custom Capture the Flag (CTF) challenges simulating real-world scenarios. This range empowers participants with hands-on experience using tools like Metasploit, Burp Suite, and Wireshark, allowing them to practice offensive and defensive security techniques in a realistic, isolated playground tailored for cybersecurity learning.

## **Prerequisites**

### **1. Choose Your Cloud Platform**
Select a cloud provider of your choice. Some common options include:
- **DigitalOcean**
- **Microsoft Azure**
- **AWS (Amazon Web Services)**
- **Google Cloud Platform**

### **2. Provision a Debian Instance**
- Recommended resources for production:
  - **50 GB Storage**
  - **4 vCPU**
  - **16 GB RAM**
- Testing Purposes:
  - **2 GB RAM** (suitable for small-scale testing, but performance will degrade with 50+ users on same machine).
  - **25 GB Storage**
  - **1 vCPU**

### **3. Set Machine Name**
- Name your machine **`Cyber Bootcamp`** during the setup process.

### **4. Open Required Ports**
To enable communication and access for CTF challenges and lesson environments, open the following ports in your cloud provider's firewall:
- **8080**: Used for web-based services.
- **8180**: Reserved for application access.
- **3000**: Reserved for lesson machines or dashboards.
- **8091**: For monitoring or additional tools.
- **4000-4999**: Wide range for peer-to-peer activities (e.g., `netcat` exercises).


## **Installation Steps**

### **1. Update and Install Basic Tools**
Log in as the root user on your new Debian machine and run the following command:
```bash
apt update && apt upgrade -y && apt install wget -y
```

### **2. Run the Cyber Bootcamp Installation Script**
Use `wget` to download and execute the installation script:
```bash
wget -qO- https://raw.githubusercontent.com/csb21jb/Teen-Cybercamp/refs/heads/main/master_install.sh | bash
```

### **3. OpenSSH Server Configuration During Installation**
- During the script execution, you may encounter a prompt for the **OpenSSH Server** configuration.
- When asked **"What do you want to do with the existing configuration?"**, select:
  - **Keep the local version installed** by ensuring it is highlighted and pressing `Tab` to select **OK**.
- This allows the script to make additional updates to the SSH configuration later.


## **Post-Installation**

### **1. Check Docker Containers**
If there are any issues with the Docker containers, you can manually manage them using the following commands:
1. Navigate to the directory where you ran the installation script:
  
2. Run the following commands to restart Docker containers (This removes the container so anything you save will be deleted):
   ```bash
   docker compose down && docker compose up -d
   ```
3. Run to Start the container
   ```bash
   docker compose up -d
   ```
4. Run to Stop the container
   ```bash
   docker compose down
   ```
   
### **2. Verify Services**
Ensure all services and containers are running:
```bash
docker ps
```
IP addesses for the machines:
- Juicebox (172.18.0.2) - Web vulnerability cyber range
- Metasploitable2 (172.18.0.3) - Cyber range with multiple vulnerabilities
- Capture The Flag (172.18.0.4) - CTF that focuses on common system admin mistakes. 

## **Customization**

### **1. Script Customization**
The installation script is designed to be flexible:
- Modify the yaml script to deploy additional Docker containers or services.
- Adjust configurations for your specific classroom or CTF needs.

### **2. Scaling**
- For classrooms with more than 50 students, ensure at least **16 GB RAM** to prevent performance degradation.
- If running on lower specs (e.g., 2 GB RAM), performance will be limited to small-scale testing.


## **Support**
If you encounter issues or need further assistance, check the following:
- Docker container logs:
  ```bash
  docker logs <container_id>
  ```
- The `docker-compose.yaml` file located in the `/root` directory for configuration errors.

Feel free to contribute to the project or reach out to the community for additional support.


## **Future Enhancements**
The current setup is designed for flexibility and scalability. Future updates will include:
- Enhanced SSH configuration for secure and efficient management.
- Additional lesson modules and CTF challenges preconfigured in the environment.


Deploy your **Cyber Bootcamp** today and create an engaging and hands-on cybersecurity learning environment! 🚀
