provider "azurerm" {
  features {}
}

  sku_name  = "AZFW_VNet"
  sku_tier  = "Standard"

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = "/subscriptions/8d3e1cd2-8996-4289-91db-4960cbdf5066/resourceGroups/EnterpriseLandingZone/providers/Microsoft.Network/virtualNetworks/hub-vnet/subnets/AzureFirewallSubnet"
    public_ip_address_id = "/subscriptions/8d3e1cd2-8996-4289-91db-4960cbdf5066/resourceGroups/EnterpriseLandingZone/providers/Microsoft.Network/publicIPAddresses/fw-pip"
  }

}
