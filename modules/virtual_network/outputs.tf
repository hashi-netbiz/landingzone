output name {
  description = "Specifies the name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output vnet_id {
  description = "Specifies the resource id of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "frontend_subnet" {
  value = azurerm_subnet.frontend.id
  description = "Id of the frontend subnet"
}

output "backend_subnet" {
  value = azurerm_subnet.backend.id
  description = "Id of the backend subnet"
}
output "api_subnet" {
  value = azurerm_subnet.api.id
  description = "Id of the api subnet"
}
output "bastion_subnet" {
  value = azurerm_subnet.bastion.id
  description = "Id of the devops subnet"
}
output "firewall_subnet" {
  value = azurerm_subnet.firewall.id
  description = "Id of the devops subnet"
}
output "user_subnet" {
  value = azurerm_subnet.user.id
  description = "Id of the api subnet"
}
output "system_subnet" {
  value = azurerm_subnet.system.id
  description = "Id of the devops subnet"
}
