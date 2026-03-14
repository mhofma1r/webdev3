#!/usr/bin/env bash
set -e

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

# Prompt for the sudo password
read -sp "Enter sudo password for $DEPLOY_USER on $DEPLOY_TARGET_IP: " SUDO_PASS

echo "$DEPLOY_USER"
echo "$DEPLOY_PATH"

# Rsync php application code
rsync -avz --delete \
    --exclude='.*' \
    --exclude='node_modules' \
    --exclude='vendor' \
    --exclude='storage' \
    --exclude='cache' \
    ../php/ \
    "$DEPLOY_USER@$DEPLOY_TARGET_IP:$DEPLOY_PATH"

# Optional: ownership fix
ssh "$DEPLOY_USER@$DEPLOY_TARGET_IP" \
    "echo '$SUDO_PASS' | sudo -S chown -R $DEPLOY_USER:$DEPLOY_GROUP $DEPLOY_PATH"
