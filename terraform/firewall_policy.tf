###############################################
# FIREWALL POLICY
###############################################
resource "azurerm_firewall_policy" "hub" {
  name                = "${var.firewall_name}-policy"
  resource_group_name = azurerm_resource_group.enterprise.name
  location            = var.location
  tags                = var.tags
}

###############################################
# DEFAULT RULE COLLECTION GROUP (INTERNAL TRAFFIC)
###############################################
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

###############################################
# AKS EGRESS RULE COLLECTION GROUP
###############################################
resource "azurerm_firewall_policy_rule_collection_group" "aks_egress" {
  name               = "aks-egress-rcg"
  firewall_policy_id = azurerm_firewall_policy.hub.id
  priority           = 200

  application_rule_collection {
    name     = "aks-egress"
    priority = 200
    action   = "Allow"

    rule {
      name = "aks-bootstrap"
      source_addresses = ["10.0.10.0/24"]

      protocols {
        type = "Https"
        port = 443
      }

      destination_fqdns = [
        "*.azmk8s.io",
        "*.hcp.eastus.azmk8s.io"
      ]
    }

    rule {
      name = "linux-packages"
      source_addresses = ["10.0.10.0/24"]

      protocols {
        type = "Https"
        port = 443
      }

      destination_fqdns = [
        "packages.microsoft.com",
        "*.ubuntu.com",
        "archive.ubuntu.com",
        "security.ubuntu.com"
      ]
    }

    rule {
      name = "container-registries"
      source_addresses = ["10.0.10.0/24"]

      protocols {
        type = "Https"
        port = 443
      }

      destination_fqdns = [
        "*.azurecr.io",
        "mcr.microsoft.com"
      ]
    }

    rule {
      name = "identity"
      source_addresses = ["10.0.10.0/24"]

      protocols {
        type = "Https"
        port = 443
      }

      destination_fqdns = [
        "login.microsoftonline.com",
        "management.azure.com"
      ]
    }
  }
}