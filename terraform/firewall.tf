resource "azurerm_firewall" "hub" {
  name                = "az-fw-hub"
  location            = var.location
  resource_group_name = azurerm_resource_group.enterprise.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "azfw-pip"
    subnet_id            = azurerm_subnet.hub_firewall.id
    public_ip_address_id = azurerm_public_ip.azfw_pip.id
  }

  management_ip_configuration {
    name      = "mgmt-config"
    subnet_id = azurerm_subnet.hub_firewall_mgmt.id
  }
}

# NOTE:
# - Azure also created a management IP configuration and attached a firewall policy.
# - The current azurerm provider cannot model those fully without forcing replacement.
# - See README for guidance: do NOT blindly run `terraform apply` on this resource.
