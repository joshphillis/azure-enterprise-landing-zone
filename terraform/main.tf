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
}

module "nsg" {
  source = "./nsg"
}

module "udr" {
  source = "./udr"
}
