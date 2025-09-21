variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Location name"
  type        = string
}

variable "virtual_machine_scale_set_name" {
  description = "VMSS name"
  type        = string

}

variable "admin_username" {
  description = "Admin username for the VMSS"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VMSS"
  type        = string
  sensitive   = true
}

variable "subnet_id" { 
    type = string 
}

variable "backend_pool_id" { 
    type = string 
}

variable "common_tags" {
  type = map(string)
  }
