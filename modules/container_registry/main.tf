locals {
  resource_group_name = "tcw-${var.environment}-rg"
}

resource "azurerm_container_registry" "acr" {
  name                     = "tcw${var.environment}acrnetbiz"
  resource_group_name      = local.resource_group_name
  location                 = var.location
  sku                      = var.sku  
  admin_enabled            = var.admin_enabled
  tags                     = var.tags

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.acr_identity.id
    ]
  }

  dynamic "georeplications" {
    for_each = var.georeplication_locations

    content {
      location = georeplications.value
      tags     = var.tags
    }
  }

  lifecycle {
      ignore_changes = [
          tags
      ]
  }
}

resource "azurerm_user_assigned_identity" "acr_identity" {
  resource_group_name = local.resource_group_name
  location            = var.location
  tags                = var.tags

  name = "tcw${var.environment}acrIdentity"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "settings" {
  name                       = "tcw-${var.environment}-main-acr-ds"
  target_resource_id         = azurerm_container_registry.acr.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "ContainerRegistryRepositoryEvents"
    enabled  = true

    # retention_policy {
    #   enabled = true
    #   days    = var.log_analytics_retention_days
    # }
  }

  log {
    category = "ContainerRegistryLoginEvents"
    enabled  = true

    # retention_policy {
    #   enabled = true
    #   days    = var.log_analytics_retention_days
    # }
  }

  metric {
    category = "AllMetrics"

    # retention_policy {
    #   enabled = true
    #   days    = var.log_analytics_retention_days
    # }
  }
}