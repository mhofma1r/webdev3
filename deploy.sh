#!/usr/bin/env bash

# Function to deploy a service based on the provided .env file
deploy_service() {
    local env_file=$1

    # Load the environment file
    source "$env_file"

    # Check that necessary variables are set
    if [ -z "$DEPLOY_TARGET_IP" ] || [ -z "$DEPLOY_PATH" ] || [ -z "$DEPLOY_USER" ] || [ -z "$DEPLOY_GROUP" ]; then
        echo "Error: DEPLOY_TARGET_IP, DEPLOY_PATH, DEPLOY_USER, and DEPLOY_GROUP must be set in $env_file!"
        return 1
    fi

    # Prompt for the sudo password (you could prompt once outside the loop if you prefer)
    read -sp "Enter sudo password for $DEPLOY_USER on $DEPLOY_TARGET_IP: " SUDO_PASS
    echo

    echo "Deploying service to $DEPLOY_TARGET_IP:$DEPLOY_PATH..."

    # Rsync the application code to the server, excluding specified directories
    rsync -avz --delete --exclude='.*' --exclude='vendor' --exclude='cache' "../php/" "$DEPLOY_TARGET_IP:$DEPLOY_PATH"

    # Set user and group permissions on the target server
    ssh "$DEPLOY_TARGET_IP" "echo $SUDO_PASS | sudo -S chown -R $DEPLOY_USER:$DEPLOY_GROUP $DEPLOY_PATH"

    # SSH into the server and run composer install in the deployed path
    ssh "$DEPLOY_TARGET_IP" "cd $DEPLOY_PATH && sudo -u www-data composer install --no-dev --optimize-autoloader"

    echo "Deployment to $DEPLOY_TARGET_IP:$DEPLOY_PATH completed for environment file $env_file."
}

# Find all .env files matching the pattern .env*
for env_file in ./.env*; do
    if [ -f "$env_file" ]; then
        deploy_service "$env_file"
    else
        echo "No .env files found matching pattern .env*"
        exit 1
    fi
done

echo "All deployments completed."
