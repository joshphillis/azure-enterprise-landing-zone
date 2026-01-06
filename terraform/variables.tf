variable "location" {
  description = "Azure region for the Enterprise Landing Zone resources."
  type        = string
  default     = "eastus"
}

variable "hub_vnet_address_space" {
  description = "Address space for the hub virtual network."
  type        = string
  # TODO: Set to match your actual hub-vnet address space, e.g. "10.0.0.0/16"
  default = "10.0.0.0/16"
}

variable "hub_firewall_subnet_prefix" {
  description = "Address prefix for AzureFirewallSubnet."
  type        = string
  # TODO: Set to match your actual AzureFirewallSubnet prefix, e.g. "10.0.2.0/24"
  default = "10.0.2.0/24"
}

variable "hub_firewall_mgmt_subnet_prefix" {
  description = "Address prefix for AzureFirewallManagementSubnet."
  type        = string
  # TODO: Set to match your actual AzureFirewallManagementSubnet prefix, e.g. "10.0.3.0/24"
  default = "10.0.3.0/24"
}