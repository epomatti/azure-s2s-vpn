output "ingress_nat_rules" {
  value = [azurerm_virtual_network_gateway_nat_rule.ingress_snat.id]
}

output "egress_nat_rules" {
  value = [azurerm_virtual_network_gateway_nat_rule.egress_snat.id]
}
