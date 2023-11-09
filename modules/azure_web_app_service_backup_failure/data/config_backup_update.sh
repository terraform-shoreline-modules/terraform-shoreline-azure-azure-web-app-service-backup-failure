#!/bin/bash


# Set the resource group and web app name
resource_group=${RESOURCE_GROUP_NAME}
webapp_name=${WEB_APP_NAME}

# Define the backup settings
backup_name=${BACKUP_NAME}
container_url=${CONTAINER_URL}
frequency=${BACKUP_FREQUENCY}
retention=${BACKUP_RETENTION}

# Configure the backup for the web app
az webapp config backup update \
    --resource-group $resource_group \
    --webapp-name $webapp_name \
    --container-url $container_url \
    --backup-name $backup_name \
    --frequency $frequency \
    --retention $retention