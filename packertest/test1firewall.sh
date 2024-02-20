#!/bin/bash

# This script sets up the firewall


# Step 1: Setting Up a Basic Firewall
echo "step3: ******Setting up a basic firewall******"
sudo dnf install firewalld -y
sudo systemctl start firewalld
sudo systemctl enable firewalld
# systemctl status firewalld
sudo firewall-cmd --permanent --list-all
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --zone=public --add-port=3000/tcp --permanent
sudo firewall-cmd --reload
sudo firewall-cmd --permanent --list-all
sudo firewall-cmd --reload