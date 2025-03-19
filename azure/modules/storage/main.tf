resource "azurerm_storage_account" "default" {
  name                       = "sttshootvpn82394"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  account_kind               = "StorageV2"
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"
  access_tier                = "Hot"

  # Networking
  public_network_access_enabled = true
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "data_contributor" {
  scope                = azurerm_storage_account.default.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "data_owner" {
  scope                = azurerm_storage_account.default.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_storage_container" "tshoot" {
  name                  = "vgw-tshoot"
  storage_account_id    = azurerm_storage_account.default.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "vnet_flow_log" {
  name                  = "vnet-flow-logs"
  storage_account_id    = azurerm_storage_account.default.id
  container_access_type = "private"
}
