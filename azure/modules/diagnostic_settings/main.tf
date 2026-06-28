resource "azurerm_monitor_diagnostic_setting" "virtual_network_gateway" {
  name                       = "VirtualNetworkGateway"
  target_resource_id         = var.vgw_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "GatewayDiagnosticLog"
  }

  enabled_log {
    category = "TunnelDiagnosticLog"
  }

  enabled_log {
    category = "RouteDiagnosticLog"
  }

  enabled_log {
    category = "IKEDiagnosticLog"
  }

  enabled_log {
    category = "P2SDiagnosticLog"
  }
}
