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

resource "azurerm_subnet_network_security_group_association" "workloads" {
  subnet_id                 = azurerm_subnet.workloads.id
  network_security_group_id = azurerm_network_security_group.workloads.id
}
