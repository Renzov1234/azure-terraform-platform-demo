output "function_app_name" {
  value = azurerm_linux_function_app.fn.name
}

output "resource_group_name" {
  value = data.azurerm_resource_group.rg.name
}

output "location" {
  value = data.azurerm_resource_group.rg.location
}
