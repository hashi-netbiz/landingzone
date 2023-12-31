locals {
  resource_group_name = "tcw-${var.environment}-rg"
  aks_cluster_name = "tcw-${var.environment}-aks"
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = local.resource_group_name
  location            = var.location
  tags                = var.tags

  name = "tcw-${var.environment}-aks-id"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                      = local.aks_cluster_name
  location                  = var.location
  resource_group_name       = local.resource_group_name
  kubernetes_version        = var.kubernetes_version
  dns_prefix                = local.aks_cluster_name
  automatic_channel_upgrade = var.automatic_channel_upgrade
  sku_tier                  = var.sku_tier

  default_node_pool {
    name                   = var.default_node_pool_name
    vm_size                = var.default_node_pool_vm_size
    vnet_subnet_id         = var.vnet_subnet_id
    node_labels            = var.default_node_pool_node_labels
    node_taints            = var.default_node_pool_node_taints
    enable_auto_scaling    = var.default_node_pool_enable_auto_scaling
    enable_host_encryption = var.default_node_pool_enable_host_encryption
    enable_node_public_ip  = var.default_node_pool_enable_node_public_ip
    max_pods               = var.default_node_pool_max_pods
    max_count              = var.default_node_pool_max_count
    min_count              = var.default_node_pool_min_count
    node_count             = var.default_node_pool_node_count
    os_disk_type           = var.default_node_pool_os_disk_type
    tags                   = var.tags
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
        key_data = var.ssh_public_key
    }
  }

  identity {
    type = "SystemAssigned"
  }
  network_profile {
    docker_bridge_cidr = var.network_docker_bridge_cidr
    dns_service_ip     = var.network_dns_service_ip
    network_plugin     = var.network_plugin
    outbound_type      = var.outbound_type
    service_cidr       = var.network_service_cidr
  }
  lifecycle {
    ignore_changes = [
      kubernetes_version,
      tags
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "settings" {
  name                       = "tcw-${var.environment}-main-aks-ds"
  target_resource_id         = azurerm_kubernetes_cluster.aks_cluster.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "kube-apiserver"
    enabled  = true

    # retention_policy {
    #   enabled = true  
    #   days    = var.log_analytics_retention_days
    # }
  }

  log {
    category = "kube-audit"
    enabled  = true

    # retention_policy {
    #   enabled = true
    #   days    = var.log_analytics_retention_days
    # }
  }

  log {
    category = "kube-audit-admin"
    enabled  = true

    # retention_policy {
    #   enabled = true
    #   days    = var.log_analytics_retention_days
    # }
  }

  log {
    category = "kube-controller-manager"
    enabled  = true

    # retention_policy {
    #   enabled = true
    #   days    = var.log_analytics_retention_days
    # }
  }

  log {
    category = "kube-scheduler"
    enabled  = true

    # retention_policy {
    #   enabled = true
    #   days    = var.log_analytics_retention_days
    # }
  }

  log {
    category = "cluster-autoscaler"
    enabled  = true

    # retention_policy {
    #   enabled = true
    #   days    = var.log_analytics_retention_days
    # }
  }

  log {
    category = "guard"
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