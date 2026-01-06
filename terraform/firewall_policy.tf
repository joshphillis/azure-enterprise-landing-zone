resource "azurerm_firewall_policy" "hub" {
  name                = "az-fw-hub"
  resource_group_name = azurerm_resource_group.enterprise.name
  location            = azurerm_resource_group.enterprise.location

  sku      = "Standard"
  priority = 100
}

# TODO: Example rule collection group scaffold
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

      protocol {
        port = 80
        type = "Http"
      }

      protocol {
        port = 443
        type = "Https"
      }

      destination_fqdns = [
        "www.microsoft.com",
        "learn.microsoft.com"
      ]
    }
  }
}

# NOTE:
# This is an example scaffold. Adjust or remove rules to match your actual policy.
# If your existing policy is more complex, document it in README and selectively
# migrate rules over time rather than trying to mirror it 1:1 on day one.