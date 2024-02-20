#!/bin/bash

# This script installs Node.js on CentOS 8

# Step 1: List available Node.js modules
echo "Step 1: Listing available Node.js modules"
sudo dnf module list nodejs

# Step 2: Enable Node.js module version 20
echo "Step 2: Enabling Node.js module version 20"
sudo dnf module enable nodejs:20 -y

# Step 3: Install Node.js
echo "Step 3: Installing Node.js"
sudo dnf install nodejs -y 

# Step 4: Display Node.js version
echo "Step 4: Displaying Node.js version"
sudo node --version

# Step 5: Display npm version
echo "Step 5: Displaying npm version"
sudo npm --version

# Step 6: Allowing incoming traffic on port 3000
echo "Step 6: Allowing incoming traffic on port 3000"
sudo firewall-cmd --zone=public --add-port=3000/tcp --permanent

# Step 7: Checking firewall configuration
echo "Step 7: Checking firewall configuration"
sudo firewall-cmd --permanent --list-all

# Step 8: Installing unzip
echo "Step 8: Installing unzip"
sudo dnf install unzip -y

# Step 9: Creating directory 'cloud_assignment'
echo "Step 9: Creating directory 'cloud_assignment'"
mkdir ~/cloud_assignment
