#!/bin/bash

RESOURCE_GROUP=${RESOURCE_GROUP_NAME}
WEB_APP_NAME=${WEB_APP_NAME}


# Get the backup status
backup_status=$(az webapp config backup list --resource-group $RESOURCE_GROUP --webapp-name $WEB_APP_NAME --query "[0].status" --output tsv)

# Check if the status is "Failed" and display the log
if [ "$backup_status" == "Failed" ]; then
    backup_log=$(az webapp config backup list --resource-group $RESOURCE_GROUP --webapp-name $WEB_APP_NAME --query "[0].log" --output tsv)
    echo "Backup status: $backup_status"
    echo "Backup log: $backup_log"
else
    echo "Backup status: $backup_status"
fi