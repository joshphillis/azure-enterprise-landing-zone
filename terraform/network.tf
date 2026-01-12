resource "azurerm_subnet" "firewall" {
  name                 = var.firewall_subnet_name
  resource_group_name  = azurerm_resource_group.enterprise.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.firewall_subnet_cidr]
}
