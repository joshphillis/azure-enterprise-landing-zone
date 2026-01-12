output "resource_group_name" {
  description = "Name of the enterprise resource group"
  value       = azurerm_resource_group.enterprise.name
}

output "location" {
  description = "Region of the enterprise landing zone"
  value       = var.location
}

output "hub_default_subnet_id" {
  description = "ID of the default hub subnet used by workloads"
  value       = azurerm_subnet.default.id
}

output "firewall_private_ip" {
  description = "Private IP address of the hub firewall"
  value       = azurerm_firewall.hub.ip_configuration[0].private_ip_address
}
