resource "azurerm_private_dns_zone" "aws" {
  name                = "aws.vpn"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_a_record" "aws_server" {
  name                = "server"
  zone_name           = azurerm_private_dns_zone.aws.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [var.aws_server_private_ip]
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke" {
  name                  = "spoke"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.aws.name
  virtual_network_id    = var.spoke_vnet_id
}
