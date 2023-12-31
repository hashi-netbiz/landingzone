locals {
  resource_group_name = "tcw-${var.environment}-rg"
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${var.name}-pe"
  location            = var.location
  resource_group_name = local.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "tcw-${var.environment}-${var.name}-conn"
    private_connection_resource_id = var.private_connection_resource_id
    is_manual_connection           = var.is_manual_connection
    subresource_names              = try([var.subresource_name], null)
    request_message                = try(var.request_message, null)
  }
  
  private_dns_zone_group {
    name                 = var.private_dns_zone_group_name
    private_dns_zone_ids = var.private_dns_zone_group_ids
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}