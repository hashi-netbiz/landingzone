locals {
  resource_group_name = "tcw-${var.environment}-rg"
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  #name                = var.name
  name                = "tcw${var.environment}-pdz.azurecr.io"
  resource_group_name = local.resource_group_name
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  for_each = toset(var.virtual_networks_to_link)

  name                  = "tcw_${var.environment}_link_to_${lower(basename(each.key))}"
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = "/subscriptions/${var.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${each.value}"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
