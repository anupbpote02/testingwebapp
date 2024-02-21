#!/bin/bash

# Step 0: Create the csye6225 group
echo "Step 0: Creating group csye6225"
sudo groupadd csye6225

# Display the status of group creation
echo "||Status of group creation||:"
sudo getent group csye6225

# Step 1: Create local user csye6225 with primary group csye6225 and nologin shell
echo "Step 1: Creating local user csye6225 with nologin shell"
sudo useradd -m -s /usr/sbin/nologin -g csye6225 csye6225

# Display the status of user creation
echo "||Status of user creation||:"
sudo getent passwd csye6225

# Step 2: Navigate to the application directory
echo "Step 2: Navigating to the application directory"
cd /opt/webapp-main/

# Step 3: Install application dependencies
echo "Step 3: Installing application dependencies"
sudo npm install

# Step 4: Setting ownership for application artifacts, configuration.
echo "Step 4: Setting ownership for application artifacts"
sudo chown -R csye6225:csye6225 /opt/webapp-main



# Contents of the csye6225.service file
CSYE_SERVICE_CONTENT="[Unit]
Description=CSYE 6225 App
ConditionPathExists=/opt/webapp-main
After=network.target

[Service]
Environment=DB_NAME=cloud_assignment_db
Environment=DB_USER=root
Environment=DB_PASSWORD=root
Environment=DB_HOST=localhost
Type=simple
User=csye6225
Group=csye6225
WorkingDirectory=/opt/webapp-main
ExecStart=/usr/bin/node /opt/webapp-main/check.js
Restart=always
RestartSec=3
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=csye6225

[Install]
WantedBy=multi-user.target"

# Create the csye6225.service file in /tmp/
echo "Creating the csye6225.service file in /tmp/"
echo "$CSYE_SERVICE_CONTENT" | sudo tee /tmp/csye6225.service

# Move the file to /etc/systemd/system/
echo "Moving the csye6225.service file to /etc/systemd/system/"
sudo mv /tmp/csye6225.service /etc/systemd/system/

# # Step 5: Copy systemd service file to /etc/systemd/system
# echo "Step 5: Copying systemd service file to /etc/systemd/system"
# sudo cp /tmp/csye6225.service /etc/systemd/system/csye6225.service

# Step 6: Reload systemd daemon
echo "Step 6: Reloading systemd daemon"
sudo systemctl daemon-reload

# Step 7: Enable the service to start on instance launch
echo "Step 7: Enabling the service to start on instance launch"
sudo systemctl enable csye6225

# Step 8: Start the service
echo "Step 8: Starting the service"
sudo systemctl start csye6225

# Display the status of systemd service
echo "||Status of systemd service||:"
sudo systemctl status csye6225