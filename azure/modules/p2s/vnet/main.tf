resource "azurerm_virtual_network" "default" {
  name                = "vnet-${var.workload}-p2s"
  address_space       = ["${var.vnet_cidr_prefix}.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["${var.vnet_cidr_prefix}.10.0/27"]
}

### Network Security Groups ###
resource "azurerm_network_security_group" "default" {
  name                = "nsg-${var.workload}-p2s"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "rdp" {
  name                        = "allow-rdp"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefixes     = var.allowed_public_ips
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
}

resource "azurerm_network_security_rule" "allow_web_to_azure" {
  name                        = "AllowWebAzureOutbound"
  priority                    = 500
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "10.90.0.0/16"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
}

resource "azurerm_network_security_rule" "allow_web_to_remote" {
  name                        = "AllowWebRemoteOutbound"
  priority                    = 501
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "172.16.0.0/16"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
}

resource "azurerm_network_security_rule" "inbound_icmp_to_azure" {
  name                        = "AllowIcmpRemoteOutbound"
  priority                    = 510
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "10.90.0.0/16"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
}

resource "azurerm_network_security_rule" "inbound_icmp_to_remote" {
  name                        = "AllowIcmpRemoteOutbound"
  priority                    = 510
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "172.16.0.0/16"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.default.name
}

resource "azurerm_subnet_network_security_group_association" "default" {
  subnet_id                 = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.default.id
}
