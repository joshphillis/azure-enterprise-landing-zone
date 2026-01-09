resource "azurerm_subnet" "bastion" {
  name                 = var.bastion_subnet_name
  resource_group_name  = azurerm_resource_group.enterprise.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.3.0/27"]
}

resource "azurerm_public_ip" "bastion" {
  name                = "${var.bastion_name}-pip"
  resource_group_name = azurerm_resource_group.enterprise.name
  location            = azurerm_resource_group.enterprise.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  resource_group_name = azurerm_resource_group.enterprise.name
  location            = azurerm_resource_group.enterprise.location

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}
