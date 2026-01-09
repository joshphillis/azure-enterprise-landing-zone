# ---------------------------------------------------------
# Subnet for Bastion
# ---------------------------------------------------------
resource "azurerm_subnet" "bastion" {
  name                 = var.bastion_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.bastion_subnet_prefix]
}

# ---------------------------------------------------------
# Public IP for Bastion
# ---------------------------------------------------------
resource "azurerm_public_ip" "bastion" {
  name                = "${var.bastion_name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# ---------------------------------------------------------
# Bastion Host
# ---------------------------------------------------------
resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}

# ---------------------------------------------------------
# Outputs
# ---------------------------------------------------------
output "bastion_id" {
  value = azurerm_bastion_host.bastion.id
}
