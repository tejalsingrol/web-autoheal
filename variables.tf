variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "autohealing_rg"
}

variable "location" {
  description = "Location name"
  type        = string
  default     = "australiaeast"
}

variable "virtual_network_name" {
  description = "Virtual network name"
  type        = string
  default     = "autohealing_vnet"
}

variable "network_security_group" {
  description = "Network security group"
  type        = string
  default     = "autohealing_nsg"
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default     = "autohealing_subnet"
}

variable "subnet_prefix" {
  description = "Subnet address prefix"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}


variable "public_ip_name" {
  description = "Public IP name"
  type        = string
  default     = "autohealing_pip_lb"
}

variable "loadbalancer_name" {
  description = "Loadbalancer name"
  type        = string
  default     = "autohealing_lb"
}

variable "health_probe_name" {
  description = "Health probe name"
  type        = string
  default     = "ah_health_probe"
}

variable "virtual_machine_scale_set_name" {
  description = "VMSS name"
  type        = string
  default     = "linux-autohealing-vmss"

}

variable "admin_username" {
  description = "Admin username for the VMSS"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for the VMSS"
  type        = string
  sensitive   = true
}

variable "common_tags" {
  type = map(string)
  default = {
    Environment = "Dev"
    Project     = "Web Autoheal"
  }
}