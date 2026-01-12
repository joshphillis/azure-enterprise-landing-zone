resource "azurerm_public_ip" "firewall" {
  name                = "${var.firewall_name}-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.enterprise.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}
