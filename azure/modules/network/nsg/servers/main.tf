resource "azurerm_network_security_group" "servers" {
  name                = "nsg-${var.workload}-spoke-servers"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "servers" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.servers.id
}

### Inbound ###
resource "azurerm_network_security_rule" "allow_ssh_inbound" {
  name                        = "AllowSshRemoteInbound"
  description                 = "Allow inbound SSH traffic from allowed public IPs to the servers"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = var.allowed_admin_public_ips
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.servers.name
}

resource "azurerm_network_security_rule" "allow_web_inbound_from_remote" {
  name                        = "AllowWebRemoteInbound"
  description                 = "Allow inbound web traffic from remote network to the servers"
  priority                    = 500
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefixes     = var.vpn_remote_egress_address_prefixes
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.servers.name
}

resource "azurerm_network_security_rule" "allow_icmp_inbound_from_remote" {
  name                        = "AllowIcmpRemoteInbound"
  description                 = "Allow inbound ICMP traffic from remote network to the servers"
  priority                    = 505
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefixes     = var.vpn_remote_egress_address_prefixes
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.servers.name
}

### Outbound ###
resource "azurerm_network_security_rule" "allow_web_outbound_to_remote" {
  name                         = "AllowWebRemoteOutbound"
  description                  = "Allow outbound web traffic from the servers to remote network"
  priority                     = 510
  direction                    = "Outbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_ranges      = ["80", "443"]
  source_address_prefix        = "VirtualNetwork"
  destination_address_prefixes = var.vpn_remote_ingress_address_prefixes
  resource_group_name          = var.resource_group_name
  network_security_group_name  = azurerm_network_security_group.servers.name
}

resource "azurerm_network_security_rule" "allow_icmp_outbound_to_remote" {
  name                         = "AllowIcmpRemoteOutbound"
  description                  = "Allow outbound ICMP traffic from the servers to remote network"
  priority                     = 515
  direction                    = "Outbound"
  access                       = "Allow"
  protocol                     = "Icmp"
  source_port_range            = "*"
  destination_port_range       = "*"
  source_address_prefix        = "VirtualNetwork"
  destination_address_prefixes = var.vpn_remote_ingress_address_prefixes
  resource_group_name          = var.resource_group_name
  network_security_group_name  = azurerm_network_security_group.servers.name
}
