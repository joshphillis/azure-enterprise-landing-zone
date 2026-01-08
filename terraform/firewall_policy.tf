resource "azurerm_firewall_policy" "hub" {
  name                = "az-fw-hub"
  resource_group_name = azurerm_resource_group.enterprise.name
  location            = azurerm_resource_group.enterprise.location

  sku = "Standard"
}

resource "azurerm_firewall_policy_rule_collection_group" "hub_app_rules" {
  name               = "rcg-app-rules"
  firewall_policy_id = azurerm_firewall_policy.hub.id
  priority           = 100

  application_rule_collection {
    name     = "allow-outbound-web"
    priority = 100
    action   = "Allow"

    rule {
      name = "allow-http-https"

      source_addresses = [
        "10.0.0.0/8"
      ]

      destination_fqdns = [
        "www.microsoft.com",
        "learn.microsoft.com"
      ]

      protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }
    }
  }

  network_rule_collection {
    name     = "allow-dns"
    priority = 200
    action   = "Allow"

    rule {
      name = "dns-outbound"
      source_addresses      = ["10.0.0.0/8"]
      destination_ports     = ["53"]
      destination_addresses = ["*"]
      protocols             = ["UDP"]
    }
  }
}

# NOTE:
# This is an example scaffold. Adjust or remove rules to match your actual policy.
# If your existing policy is more complex, document it in README and selectively
# migrate rules over time rather than trying to mirror it 1:1 on day one.

