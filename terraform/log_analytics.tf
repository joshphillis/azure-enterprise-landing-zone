<<<<<<< HEAD
resource "azurerm_log_analytics_workspace" "hub" {
  name                = "law-hub"
  location            = azurerm_resource_group.enterprise.location
  resource_group_name = azurerm_resource_group.enterprise.name

  sku               = "PerGB2018"
  retention_in_days = 30
=======
resource "azurerm_log_analytics_workspace" "hub" {
  name                = "law-hub"
  location            = azurerm_resource_group.enterprise.location
  resource_group_name = azurerm_resource_group.enterprise.name

  sku               = "PerGB2018"
  retention_in_days = 30
>>>>>>> e63dbbb (Restore full Terraform configuration and trigger CI/CD)
}