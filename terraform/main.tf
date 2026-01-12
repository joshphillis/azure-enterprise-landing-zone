#############################################
# Resource group and hub virtual network
#############################################

resource "azurerm_resource_group" "enterprise" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  address_space       = [var.hub_vnet_cidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.enterprise.name
  tags                = var.tags
}

resource "azurerm_subnet" "default" {
  name                 = var.default_subnet_name
  resource_group_name  = azurerm_resource_group.enterprise.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.default_subnet_cidr]
}

#############################################
# Modules: Bastion, NSG, UDR
#############################################

module "bastion" {
  source = "./bastion"

  resource_group_name   = azurerm_resource_group.enterprise.name
  location              = azurerm_resource_group.enterprise.location
  virtual_network_name  = azurerm_virtual_network.hub.name
  bastion_name          = var.bastion_name
  bastion_subnet_name   = var.bastion_subnet_name
  bastion_subnet_prefix = var.bastion_subnet_cidr
  tags                  = var.tags
}

module "nsg" {
  source = "./nsg"

  resource_group_name = azurerm_resource_group.enterprise.name
  location            = azurerm_resource_group.enterprise.location
  default_subnet_id   = azurerm_subnet.default.id
  nsg_name            = var.nsg_name
  tags                = var.tags
}

module "udr" {
  source = "./udr"

  resource_group_name = azurerm_resource_group.enterprise.name
  location            = azurerm_resource_group.enterprise.location
  default_subnet_id   = azurerm_subnet.default.id
  firewall_private_ip = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  route_table_name    = var.route_table_name
  tags                = var.tags
}
