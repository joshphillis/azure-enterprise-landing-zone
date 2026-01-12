resource "azurerm_firewall_policy" "hub" {
  name                = "${var.firewall_name}-policy"
  resource_group_name = azurerm_resource_group.enterprise.name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "hub" {
  name               = "default-rules"
  firewall_policy_id = azurerm_firewall_policy.hub.id
  priority           = 100

  network_rule_collection {
    name     = "allow-internal"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "allow-vnet"
      source_addresses      = [var.hub_vnet_cidr]
      destination_addresses = [var.hub_vnet_cidr]
      destination_ports     = ["*"]
      protocols             = ["Any"]
    }
  }
}
