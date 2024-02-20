#!/bin/bash

# Step 1: Navigate to the directory where the webapp-main.zip is located
echo "Step 1: Navigating to the /tmp directory"
cd /tmp

# Step 2: Unzip the webapp-main.zip file into /opt
echo "Step 2: Unzipping webapp-main.zip to /opt/webapp-main directory"
sudo unzip webapp-main.zip -d /opt/webapp-main

# # Step 3: Navigate to the unzipped directory
# echo "Step 3: Navigating to the webapp-main directory"
# cd /opt/webapp-main/webapp-main

# Step 4: Create or overwrite the .env file
# echo "Step 4: Creating or overwriting the .env file"
# sudo echo "DB_NAME=cloud_assignment_db" >> .env
# sudo echo "DB_USER=root" >> .env
# sudo echo "DB_PASSWORD=@Nup_surekha_2499" >> .env
# sudo echo "DB_HOST=localhost" >> .env

# # Step 4: Create or overwrite the .env file
# echo "Step 4: Creating or overwriting the .env file"
# echo "DB_NAME=cloud_assignment_db" | sudo tee -a .env
# echo "DB_USER=root" | sudo tee -a .env
# echo "DB_PASSWORD=root" | sudo tee -a .env
# echo "DB_HOST=localhost" | sudo tee -a .env

# Step 5: Display the contents of the .env file using cat
# echo "Step 5: Displaying the contents of the .env file"
# cat .env

# # # Step 6: Install dependencies using npm
# echo "Step 6: Installing dependencies using npm"
# sudo npm install

# # Step 7: Start the application using npm
# echo "Step 7: Starting the application using npm"
# sudo npm test
