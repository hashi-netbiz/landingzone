variable environment {
  description = "(Required) Specifies the name of the deployment environment"
  type = string
}

# variable "resource_group_name" {
#   description = "Resource group where RouteTable will be deployed"
#   type        = string
# }

variable "location" {
  description = "Location where RouteTable will be deployed"
  type        = string
}

# variable "route_table_name" {
#   description = "RouteTable name"
#   type        = string
# }

# variable "route_name" {
#   description = "AKS route name"
#   type        = string
# }

variable "firewall_private_ip" {
  description = "Firewall private IP"
  type        = string
}

# variable "subnets_to_associate" {
#   description = "(Optional) Specifies the subscription id, resource group name, and name of the subnets to associate"
#   type        = map(any)
#   default     = {}
# }

variable "subnets_to_associate" {
  description = "name of the subnets to associate"
  type        = list(string)
  default     = []
}

variable "subscription_id" {
  description = "project subscription_id"
  type        = string
}

variable "virtual_network_name" {
  description = "project virtual_network_name"
  type        = string
}

variable "tags" {
  description = "(Optional) Specifies the tags of the storage account"
  default     = {}
}
