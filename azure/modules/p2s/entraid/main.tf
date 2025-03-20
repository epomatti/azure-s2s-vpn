data "azuread_client_config" "current" {}

locals {
  client_object_id = data.azuread_client_config.current.object_id
}

resource "azuread_user" "desktop_user" {
  account_enabled     = true
  user_principal_name = "${var.p2s_entraid_desktop_user_name}@${var.p2s_entraid_tenant_domain}"
  display_name        = var.p2s_entraid_desktop_user_name
  mail_nickname       = var.p2s_entraid_desktop_user_name
  password            = var.p2s_entraid_desktop_user_password
  usage_location      = "BR"
}
