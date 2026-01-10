provider "azurerm" {
  features {}

  use_cli          = false
  subscription_id  = var.subscription_id
  tenant_id        = var.tenant_id
  client_id        = var.client_id
  client_secret    = var.client_secret
}

# ---------------------------------------------------------
# NEW MODULES: Bastion, NSG, UDR
# ---------------------------------------------------------

module "bastion" {
  source = "./bastion"

  resource_group_name     = azurerm_resource_group.enterprise.name
  location                = azurerm_resource_group.enterprise.location
  virtual_network_name    = azurerm_virtual_network.hub.name
  bastion_name            = var.bastion_name
  bastion_subnet_name     = var.bastion_subnet_name
  bastion_subnet_prefix   = var.bastion_subnet_prefix
}

module "nsg" {
  source = "./nsg"

  resource_group_name = azurerm_resource_group.enterprise.name
  location            = azurerm_resource_group.enterprise.location
  default_subnet_id   = azurerm_subnet.default.id
  nsg_name            = var.nsg_name
}

module "udr" {
  source = "./udr"

  resource_group_name = azurerm_resource_group.enterprise.name
  location            = azurerm_resource_group.enterprise.location
  default_subnet_id   = azurerm_subnet.default.id
  firewall_private_ip = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  route_table_name    = var.route_table_name
}
