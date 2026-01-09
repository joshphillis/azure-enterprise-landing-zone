variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Azure region for the Enterprise Landing Zone resources."
  type        = string
  default     = "eastus"
}

variable "hub_vnet_address_space" {
  description = "Address space for the hub virtual network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "hub_firewall_subnet_prefix" {
  description = "Address prefix for AzureFirewallSubnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "hub_firewall_mgmt_subnet_prefix" {
  description = "Address prefix for AzureFirewallManagementSubnet."
  type        = string
  default     = "10.0.3.0/24"
}

# -------------------------------------------------------------------
# NEW VARIABLES FOR BASTION, NSG, AND UDR
# -------------------------------------------------------------------

variable "bastion_name" {
  description = "Name of the Azure Bastion host."
  type        = string
  default     = "bastion-hub"
}

variable "bastion_sku" {
  description = "SKU for Azure Bastion (Basic or Standard)."
  type        = string
  default     = "Basic"
}

variable "bastion_subnet_name" {
  description = "Subnet name for Azure Bastion (must be AzureBastionSubnet)."
  type        = string
  default     = "AzureBastionSubnet"
}

variable "nsg_name" {
  description = "Name of the Network Security Group applied to the default subnet."
  type        = string
  default     = "nsg-hub-default"
}

variable "route_table_name" {
  description = "Name of the route table for forced tunneling through the firewall."
  type        = string
  default     = "rt-hub-default"
}
