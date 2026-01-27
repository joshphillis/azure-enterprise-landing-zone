output "route_table_id" {
  description = "ID of the route table created for UDR"
  value       = azurerm_route_table.default.id
}