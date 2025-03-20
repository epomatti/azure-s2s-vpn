resource "azurerm_virtual_network" "default" {
  name                = "vnet-${var.workload}"
  address_space       = ["${var.vnet_cidr_prefix}.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["${var.vnet_cidr_prefix}.10.0/27"]
}

resource "azurerm_subnet" "workloads" {
  name                 = "workloads"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["${var.vnet_cidr_prefix}.20.0/24"]
}

### Network Security Groups ###
resource "azurerm_network_security_group" "workloads" {
  name                = "nsg-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = var.allowed_public_ips
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.workloads.name
}

resource "azurerm_network_security_rule" "inbound_web_from_remote" {
  name                        = "AllowWebRemoteInbound"
  priority                    = 500
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = "172.16.0.0/16"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.workloads.name
}

resource "azurerm_network_security_rule" "inbound_icmp_from_remote" {
  name                        = "AllowIcmpRemoteInbound"
  priority                    = 505
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "172.16.0.0/16"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.workloads.name
}

resource "azurerm_network_security_rule" "inbound_web_to_remote" {
  name                        = "AllowWebRemoteOutbound"
  priority                    = 510
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "172.16.0.0/16"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.workloads.name
}

resource "azurerm_network_security_rule" "inbound_icmp_to_remote" {
  name                        = "AllowIcmpRemoteOutbound"
  priority                    = 515
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "172.16.0.0/16"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.workloads.name
}

### P2S ###
resource "azurerm_network_security_rule" "inbound_web_p2s_azure" {
  name                        = "AllowP2SWebInbound"
  priority                    = 600
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = "10.200.0.0/16"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.workloads.name
}

resource "azurerm_network_security_rule" "inbound_icmp_p2s_azure" {
  name                        = "AllowP2SIcmpInbound"
  priority                    = 700
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Icmp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.200.0.0/16"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.workloads.name
}

resource "azurerm_subnet_network_security_group_association" "workloads" {
  subnet_id                 = azurerm_subnet.workloads.id
  network_security_group_id = azurerm_network_security_group.workloads.id
}
