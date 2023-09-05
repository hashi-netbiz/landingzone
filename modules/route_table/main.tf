data "azurerm_client_config" "current" {
}

locals {
  resource_group_name = "tcw-${var.environment}-rg"
}

resource "azurerm_route_table" "rt" {
  name                = "tcw-${var.environment}"
  location            = var.location
  resource_group_name = local.resource_group_name
  tags                = var.tags

  route {
    name                   = "kubenetfw_fw_r"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }

  lifecycle {
    ignore_changes = [
      tags,
      route
    ]
  }
}

# resource "azurerm_subnet_route_table_association" "subnet_association" {
#   for_each = var.subnets_to_associate

#   subnet_id      = "/subscriptions/${each.value.subscription_id}/resourceGroups/${each.value.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${each.value.virtual_network_name}/subnets/${each.key}"
#   route_table_id = azurerm_route_table.rt.id
# }

resource "azurerm_subnet_route_table_association" "subnet_association" {
  for_each = toset(var.subnets_to_associate)

  subnet_id      = "/subscriptions/${var.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.virtual_network_name}/subnets/tcw-${var.environment}-${each.value}-sn"
  route_table_id = azurerm_route_table.rt.id
}

  # subnets_to_associate = {
  #   (var.system_subnet_name) = {
  #     subscription_id      = data.azurerm_client_config.current.subscription_id
  #     resource_group_name  = azurerm_resource_group.rg.name
  #     virtual_network_name = module.network.name
  #   }
  #   (var.user_subnet_name) = {
  #     subscription_id      = data.azurerm_client_config.current.subscription_id
  #     resource_group_name  = azurerm_resource_group.rg.name
  #     virtual_network_name = module.network.name
  #   }