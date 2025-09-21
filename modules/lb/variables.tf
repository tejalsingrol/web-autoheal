variable "resource_group_name" {
  description = "Resource group name"
  type        = string

}

variable "location" {
  description = "Location name"
  type        = string
}

variable "public_ip_name" {
  description = "Public IP name"
  type        = string
}

variable "loadbalancer_name" {
  description = "Loadbalancer name"
  type        = string
}

variable "common_tags" {
  type = map(string)

}