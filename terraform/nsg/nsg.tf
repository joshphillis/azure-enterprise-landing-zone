resource "azurerm_network_security_group" "default" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "default" {
  subnet_id                 = var.default_subnet_id
  network_security_group_id = azurerm_network_security_group.default.id
}

output "nsg_id" {
  value = azurerm_network_security_group.default.id
}
