resource "shoreline_notebook" "azure_web_app_service_backup_failure" {
  name       = "azure_web_app_service_backup_failure"
  data       = file("${path.module}/data/azure_web_app_service_backup_failure.json")
  depends_on = [shoreline_action.invoke_backup_status_script,shoreline_action.invoke_config_backup_update]
}

resource "shoreline_file" "backup_status_script" {
  name             = "backup_status_script"
  input_file       = "${path.module}/data/backup_status_script.sh"
  md5              = filemd5("${path.module}/data/backup_status_script.sh")
  description      = "Check the Azure Web App Service logs to identify the root cause of the backup failure. This may include checking for any error messages or warnings in the logs."
  destination_path = "/tmp/backup_status_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "config_backup_update" {
  name             = "config_backup_update"
  input_file       = "${path.module}/data/config_backup_update.sh"
  md5              = filemd5("${path.module}/data/config_backup_update.sh")
  description      = "Configure a new backup schedule for the webapp"
  destination_path = "/tmp/config_backup_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_backup_status_script" {
  name        = "invoke_backup_status_script"
  description = "Check the Azure Web App Service logs to identify the root cause of the backup failure. This may include checking for any error messages or warnings in the logs."
  command     = "`chmod +x /tmp/backup_status_script.sh && /tmp/backup_status_script.sh`"
  params      = ["WEB_APP_NAME","RESOURCE_GROUP_NAME"]
  file_deps   = ["backup_status_script"]
  enabled     = true
  depends_on  = [shoreline_file.backup_status_script]
}

resource "shoreline_action" "invoke_config_backup_update" {
  name        = "invoke_config_backup_update"
  description = "Configure a new backup schedule for the webapp"
  command     = "`chmod +x /tmp/config_backup_update.sh && /tmp/config_backup_update.sh`"
  params      = ["BACKUP_FREQUENCY","WEB_APP_NAME","RESOURCE_GROUP_NAME","BACKUP_RETENTION","BACKUP_NAME","CONTAINER_URL"]
  file_deps   = ["config_backup_update"]
  enabled     = true
  depends_on  = [shoreline_file.config_backup_update]
}

