resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.enterprise.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.10.0/24"]
}

resource "azurerm_subnet_route_table_association" "aks" {
  subnet_id      = azurerm_subnet.aks_subnet.id
  route_table_id = module.udr.route_table_id
}

resource "azurerm_public_ip" "nat_pip" {
  name                = "nat-gateway-pip"
  resource_group_name = azurerm_resource_group.enterprise.name
  location            = azurerm_resource_group.enterprise.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "enterprise_nat" {
  name                = "enterprise-nat-gateway"
  resource_group_name = azurerm_resource_group.enterprise.name
  location            = azurerm_resource_group.enterprise.location
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_ip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.enterprise_nat.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}

resource "azurerm_subnet_nat_gateway_association" "aks_nat_assoc" {
  subnet_id      = azurerm_subnet.aks_subnet.id
  nat_gateway_id = azurerm_nat_gateway.enterprise_nat.id
}