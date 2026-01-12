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
  default     = "10.0.4.0/26"
}

#############################
# Remote state backend
#############################

variable "state_rg" {
  type        = string
  description = "Resource group for Terraform state storage account"
}

variable "state_sa" {
  type        = string
  description = "Storage account for Terraform state"
}

variable "state_container" {
  type        = string
  description = "Blob container for Terraform state"
}

variable "state_key" {
  type        = string
  description = "Blob name (key) for Terraform state file"
}

#############################
# Core landing zone settings
#############################

variable "rg_name" {
  type        = string
  description = "Name of the enterprise resource group"
}

variable "hub_vnet_name" {
  type        = string
  description = "Name of the hub virtual network"
}

variable "hub_vnet_cidr" {
  type        = string
  description = "Address space for the hub virtual network"
}

variable "default_subnet_name" {
  type        = string
  description = "Name of the default workload subnet"
}

variable "default_subnet_cidr" {
  type        = string
  description = "CIDR for the default workload subnet"
}

#############################
# Firewall
#############################

variable "firewall_name" {
  type        = string
  description = "Name of the Azure Firewall"
}

variable "firewall_subnet_name" {
  type        = string
  description = "Name of the AzureFirewallSubnet"
}

variable "firewall_subnet_cidr" {
  type        = string
  description = "CIDR for the AzureFirewallSubnet"
}

#############################
# Bastion
#############################

variable "bastion_name" {
  type        = string
  description = "Name of the Bastion host"
}

variable "bastion_subnet_name" {
  type        = string
  description = "Name of the AzureBastionSubnet"
}

variable "bastion_subnet_cidr" {
  type        = string
  description = "CIDR for the AzureBastionSubnet"
}

#############################
# NSG and UDR
#############################

variable "nsg_name" {
  type        = string
  description = "Name of the network security group for the default subnet"
}

variable "route_table_name" {
  type        = string
  description = "Name of the route table for the default subnet"
}

#############################
# Log Analytics
#############################

variable "log_analytics_name" {
  type        = string
  description = "Name of the Log Analytics workspace"
}

#############################
# Tags
#############################

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
}
