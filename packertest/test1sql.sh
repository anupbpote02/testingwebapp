#!/bin/bash

# This script installs and configures MySQL on CentOS 8

# Define MySQL credentials
# MYSQL_USER="root"
# MYSQL_PASSWORD="root"
# MYSQL_DATABASE="cloud_assignment_db"

MYSQL_USER="${MYSQL_USER}"
MYSQL_PASSWORD="${MYSQL_PASSWORD}"
MYSQL_DATABASE="${MYSQL_DATABASE}"

# Install MySQL Server
echo "Installing MySQL Server..."
sudo dnf install mysql-server -y

# Start MySQL service
echo "Starting MySQL service..."
sudo systemctl start mysqld.service

# Check MySQL service status
echo "Checking MySQL service status..."
sudo systemctl status mysqld

# Enable MySQL service on system startup
echo "Enabling MySQL service on system startup..."
sudo systemctl enable mysqld

# Enable MySQL service on system startup
echo "Enabling MySQL service on system startup..."
sudo systemctl enable mysqld

echo "Setting password for MySQL root user..."
sudo mysqladmin -u root password "$MYSQL_PASSWORD"

# # Secure MySQL installation
# echo "Securing MySQL installation..."
# sudo mysql_secure_installation

# # Check MySQL version using mysqladmin
# echo "Checking MySQL version using mysqladmin..."
# mysqladmin -u root -p version

# Connect to MySQL and create database, user, and grant privileges
echo "Connecting to MySQL and creating database, user, and granting privileges..."
sudo mysql -u root -p"$MYSQL_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
sudo mysql -u root -p"$MYSQL_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';"
sudo mysql -u root -p"$MYSQL_PASSWORD" -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'localhost';"
sudo mysql -u root -p"$MYSQL_PASSWORD" -e "FLUSH PRIVILEGES;"