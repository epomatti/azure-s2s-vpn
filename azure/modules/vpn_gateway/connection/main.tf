resource "azurerm_virtual_network_gateway_connection" "default" {
  name                           = "vcn-${var.workload}"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  local_azure_ip_address_enabled = false
  dpd_timeout_seconds            = 45

  type                = "IPsec"
  connection_protocol = "IKEv2"
  bgp_enabled         = var.bgp_enabled

  virtual_network_gateway_id = var.virtual_network_gateway_id
  local_network_gateway_id   = var.local_network_gateway_id

  shared_key = var.shared_key

  ingress_nat_rule_ids = var.ingress_nat_rule_ids
  egress_nat_rule_ids  = var.egress_nat_rule_ids

  ipsec_policy {
    dh_group         = "DHGroup14"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA256"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA256"
    pfs_group        = "PFS2048"
    sa_datasize      = 0
    sa_lifetime      = 27000
  }

  tags = {}
}
