resource "azurerm_route_table" "default" {
  name                = var.route_table_name
  location            = azurerm_resource_group.enterprise.location
  resource_group_name = azurerm_resource_group.enterprise.name
}

resource "azurerm_route" "default_to_firewall" {
  name                   = "DefaultToFirewall"
  resource_group_name    = azurerm_resource_group.enterprise.name
  route_table_name       = azurerm_route_table.default.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "default" {
  subnet_id      = azurerm_subnet.default.id
  route_table_id = azurerm_route_table.default.id
}
