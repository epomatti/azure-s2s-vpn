resource "azurerm_network_watcher_flow_log" "vnet_flow_logs" {
  network_watcher_name = var.network_watcher_name
  resource_group_name  = var.network_watcher_resource_group_name
  name                 = "vnet-${var.name}-flow-logs"

  target_resource_id = var.vnet_id
  storage_account_id = var.storage_account_id
  enabled            = true

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = var.log_analytics_workspace_id
    workspace_region      = var.location
    workspace_resource_id = var.log_analytics_workspace_resource_id
    interval_in_minutes   = 10
  }
}
