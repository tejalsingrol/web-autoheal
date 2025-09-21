variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Location name"
  type        = string
}

variable "network_security_group" {
  description = "Network security group"
  type        = string
}
variable "subnet_id" { 
  type = string 
  }

variable "common_tags" {
  type = map(string)

  }