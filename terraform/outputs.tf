output "resource_group_name" {
  description = "Name of the Enterprise Landing Zone resource group."
  value       = azurerm_resource_group.enterprise.name
}

output "hub_vnet_id" {
  description = "ID of the hub virtual network."
  value       = azurerm_virtual_network.hub.id
}

output "firewall_id" {
  description = "ID of the Azure Firewall in the hub."
  value       = azurerm_firewall.hub.id
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace used for firewall diagnostics."
  value       = azurerm_log_analytics_workspace.hub.id
}