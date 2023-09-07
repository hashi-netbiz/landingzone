locals {
  resource_group_name = "tcw-${var.environment}-rg"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "tcw-${var.environment}-main-vnet"
  address_space       = var.address_space
  location            = var.location
  resource_group_name = local.resource_group_name
  tags                = var.tags

  lifecycle {
    ignore_changes = [
        tags
    ]
  }
}

resource "azurerm_subnet" "frontend" {
  name                 = "tcw-${var.environment}-frontend-sn"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.frontend_subnet_range
}
resource "azurerm_subnet" "backend" {
  name                 = "tcw-${var.environment}-backend-sn"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.backend_subnet_range
}
resource "azurerm_subnet" "api" {
  name                 = "tcw-${var.environment}-api-sn"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.api_subnet_range
}
resource "azurerm_subnet" "bastion" {
  name                 = "tcw-${var.environment}-bastion-sn"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.bastion_subnet_range
}
resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.firewall_subnet_range
}
resource "azurerm_subnet" "system" {
  name                 = "tcw-${var.environment}-system-sn"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.system_subnet_range
}
resource "azurerm_subnet" "user" {
  name                 = "tcw-${var.environment}-user-sn"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.user_subnet_range
}

resource "azurerm_monitor_diagnostic_setting" "settings" {
  name                       = "tcw-${var.environment}-main-vnet-ds"
  target_resource_id         = azurerm_virtual_network.vnet.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "VMProtectionAlerts"
    enabled  = true

    retention_policy {
      enabled = true
      days    = var.log_analytics_retention_days
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = var.log_analytics_retention_days
    }
  }
}