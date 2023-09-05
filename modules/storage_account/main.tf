locals {
  resource_group_name = "tcw-${var.environment}-rg"
}

# Generate randon name for the storage account
resource "random_string" "storage_account_suffix" {
  length  = 8
  special = false
  lower   = true
  upper   = false
  numeric  = false
}

resource "azurerm_storage_account" "storage_account" {
  name                ="tcw${var.environment}${random_string.storage_account_suffix.result}"
  resource_group_name = local.resource_group_name

  location                 = var.location
  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  is_hns_enabled           = var.is_hns_enabled
  tags                     = var.tags

  network_rules {
    default_action             = (length(var.ip_rules) + length(var.virtual_network_subnet_ids)) > 0 ? "Deny" : var.default_action
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
        tags
    ]
  }
}