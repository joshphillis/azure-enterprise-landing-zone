resource "azurerm_network_security_group" "default" {
  name                = var.nsg_name
  location            = azurerm_resource_group.enterprise.location
  resource_group_name = azurerm_resource_group.enterprise.name
}

resource "azurerm_network_security_rule" "allow_bastion" {
  name                        = "AllowBastion"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureBastion"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.default.name
  resource_group_name         = azurerm_resource_group.enterprise.name
}

resource "azurerm_subnet_network_security_group_association" "default" {
  subnet_id                 = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.default.id
}
