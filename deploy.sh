#!/usr/bin/env bash

# Prompt for the sudo password
read -sp "Enter sudo password for $DEPLOY_USER on $DEPLOY_TARGET_IP: " SUDO_PASS

# Load variables from .env file
if [ -f "./.env" ]; then
    source ./.env
else
    echo "Error: .env file not found!"
    exit 1
fi

# Check that necessary variables are set
if [ -z "$DEPLOY_TARGET_IP" ] || [ -z "$DEPLOY_PATH" ] || [ -z "$DEPLOY_USER" ] || [ -z "$DEPLOY_GROUP" ]; then
    echo "Error: DEPLOY_TARGET_IP, DEPLOY_PATH, DEPLOY_USER, and DEPLOY_GROUP must be set in .env file!"
    exit 1
fi

# Rsync the application code in php/ to the server, excluding dotfiles
rsync -avz --delete --exclude='.*' ../php/ "$DEPLOY_TARGET_IP:$DEPLOY_PATH"

# Set user and group permissions on the target server
ssh "$DEPLOY_TARGET_IP" "echo $SUDO_PASS | sudo -S chown -R $DEPLOY_USER:$DEPLOY_GROUP $DEPLOY_PATH"

echo "Deployment to $DEPLOY_TARGET_IP:$DEPLOY_PATH completed with user $DEPLOY_USER and group $DEPLOY_GROUP."
