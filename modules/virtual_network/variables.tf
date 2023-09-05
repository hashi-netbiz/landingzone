variable environment {
  description = "(Required) Specifies the name of the deployment environment"
  type = string
}

variable "location" {
  description = "Location in which to deploy the network"
  type        = string
}

# variable "vnet_name" {
#   description = "VNET name"
#   type        = string
# }

# variable "frontend_subnet_name" {
#   description = "Frontend Subnet name"
#   type        = string
# }

# variable "backend_subnet_name" {
#   description = "Backend Subnet name"
#   type        = string
# }

# variable "api_subnet_name" {
#   description = "API Subnet name"
#   type        = string
# }

# variable "system_subnet_name" {
#   description = "System Subnet name"
#   type        = string
# }
# variable "user_subnet_name" {
#   description = "User Subnet name"
#   type        = string
# }

variable "address_space" {
  description = "VNET address space"
  type        = list(string)
}

variable "frontend_subnet_range" {
  description = "Frontend Subnets configuration"
    type        = list(string)
}

variable "backend_subnet_range" {
  description = "Backend Subnets configuration"
    type        = list(string)
}

variable "api_subnet_range" {
  description = "API Subnets configuration"
    type        = list(string)
}
variable "bastion_subnet_range" {
  description = "DevOps Subnets configuration"
    type        = list(string)
}
variable "firewall_subnet_range" {
  description = "DevOps Subnets configuration"
    type        = list(string)
}
variable "system_subnet_range" {
  description = "DevOps Subnets configuration"
    type        = list(string)
}
variable "user_subnet_range" {
  description = "DevOps Subnets configuration"
    type        = list(string)
}
variable "tags" {
  description = "(Optional) Specifies the tags of the storage account"
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "Specifies the log analytics workspace id"
  type        = string
}

variable "log_analytics_retention_days" {
  description = "Specifies the number of days of the retention policy"
  type        = number
  default     = 7
}