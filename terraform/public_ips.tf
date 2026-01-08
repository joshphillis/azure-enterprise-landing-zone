resource "azurerm_public_ip" "azfw_pip" {
  name                = "azfw-pip"
  location            = azurerm_resource_group.enterprise.location
  resource_group_name = azurerm_resource_group.enterprise.name

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_public_ip" "azfw_mgmt_pip" {
  name                = "azfw-mgmt-pip"
  location            = azurerm_resource_group.enterprise.location
  resource_group_name = azurerm_resource_group.enterprise.name

  allocation_method = "Static"
  sku               = "Standard"
}