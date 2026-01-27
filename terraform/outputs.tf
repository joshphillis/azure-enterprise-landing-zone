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

output "aks_subnet_id" {
  description = "Subnet ID for the AKS node pool"
  value       = azurerm_subnet.aks_subnet.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway used for outbound traffic"
  value       = azurerm_nat_gateway.enterprise_nat.id
}

output "nat_gateway_public_ip" {
  description = "Public IP address associated with the NAT Gateway"
  value       = azurerm_public_ip.nat_pip.ip_address
}