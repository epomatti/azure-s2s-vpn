resource "azurerm_virtual_network" "default" {
  name                = "vnet-${var.workload}-gateway"
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

### Network Security Groups ###
# resource "azurerm_network_security_group" "gateway" {
#   name                = "nsg-${var.workload}-gateway"
#   location            = var.location
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_network_security_rule" "allow_all" {
#   name                        = "AllowAll"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.gateway.name
# }

# resource "azurerm_subnet_network_security_group_association" "workloads" {
#   subnet_id                 = azurerm_subnet.gateway.id
#   network_security_group_id = azurerm_network_security_group.gateway.id
# }
