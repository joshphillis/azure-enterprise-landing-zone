resource "azurerm_resource_group" "enterprise" {
  name     = "EnterpriseLandingZone"
  location = var.location
}

resource "azurerm_virtual_network" "hub" {
  name                = "hub-vnet"
  location            = azurerm_resource_group.enterprise.location
  resource_group_name = azurerm_resource_group.enterprise.name
  address_space       = [var.hub_vnet_address_space]
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.enterprise.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "hub_default" {
  name                 = "hub-default"
  resource_group_name  = azurerm_resource_group.enterprise.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "hub_firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.enterprise.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_firewall_subnet_prefix]
}

resource "azurerm_subnet" "hub_firewall_mgmt" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = azurerm_resource_group.enterprise.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_firewall_mgmt_subnet_prefix]
}

resource "azurerm_resource_group" "enterprise" {
  name     = "EnterpriseLandingZone"
  location = var.location
}

resource "azurerm_virtual_network" "hub" {
  name                = "hub-vnet"
  location            = azurerm_resource_group.enterprise.location
  resource_group_name = azurerm_resource_group.enterprise.name
  address_space       = [var.hub_vnet_address_space]
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.enterprise.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "hub_default" {
  name                 = "hub-default"
  resource_group_name  = azurerm_resource_group.enterprise.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "hub_firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.enterprise.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_firewall_subnet_prefix]
}

resource "azurerm_subnet" "hub_firewall_mgmt" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = azurerm_resource_group.enterprise.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_firewall_mgmt_subnet_prefix]
}
