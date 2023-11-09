
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Azure Web App Service Backup Failure

This incident type refers to the failure of backing up data in Azure Web App Service. It could be caused by various reasons such as incorrect configuration, insufficient storage, or network issues, which results in the inability to create a backup of the web app service. The failure of backup could lead to data loss, which may affect the availability and recovery of the web app service.

### Parameters

```shell
export RESOURCE_GROUP_NAME="PLACEHOLDER"
export WEB_APP_NAME="PLACEHOLDER"
export BACKUP_NAME="PLACEHOLDER"
export CONTAINER_URL="PLACEHOLDER"
export BACKUP_FREQUENCY="PLACEHOLDER"
export BACKUP_RETENTION="PLACEHOLDER"
```

## Debug

### Check if the web app is running

```shell
az webapp show --resource-group $RESOURCE_GROUP --name $WEB_APP_NAME --query state
```

### Check the status of the last backup

```shell
az webapp config backup list --resource-group $RESOURCE_GROUP --webapp-name $WEB_APP_NAME --query [0].status
```

### Check the backup schedule

```shell
az webapp config backup show --resource-group $RESOURCE_GROUP --webapp-name $WEB_APP_NAME --backup-name $BACKUP_NAME --query backupSchedule
```

### Check the backup storage account configurations

```shell
az webapp config backup show --resource-group $RESOURCE_GROUP --webapp-name $WEB_APP_NAME --backup-name $BACKUP_NAME --query storageAccountUrl
```

### Check the Azure Web App Service logs to identify the root cause of the backup failure. This may include checking for any error messages or warnings in the logs.

```shell
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
```
## Repair

### Configure a new backup schedule for the webapp

```shell
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
   
```