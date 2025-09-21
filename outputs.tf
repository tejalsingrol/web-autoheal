output "public_ip" {
  value = azurerm_public_ip.ah_public_ip.ip_address
}

output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = var.resource_group_name
}

output "resource_group_location" {
  description = "Location of the Resource Group"
  value       = var.location
}

output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.ah_vnet.id
}

output "vnet_name" {
  description = "The name of the Virtual Network"
  value       = azurerm_virtual_network.ah_vnet.name
}

output "subnet_id" {
  description = "The ID of the Subnet"
  value       = azurerm_subnet.ah_subnet.id
}

output "subnet_name" {
  description = "The name of the Subnet"
  value       = azurerm_subnet.ah_subnet.name
}

output "nsg_id" {
  description = "The ID of the Network Security Group"
  value       = azurerm_network_security_group.ah_nsg.id
}

output "nsg_name" {
  description = "The name of the NSG"
  value       = azurerm_network_security_group.ah_nsg.name
}

output "lb_id" {
  description = "The ID of the Load Balancer"
  value       = azurerm_lb.ah_lb.id
}

output "lb_name" {
  description = "The name of the Load Balancer"
  value       = azurerm_lb.ah_lb.name
}

output "lb_public_ip" {
  description = "The Public IP of the Load Balancer"
  value       = azurerm_public_ip.ah_public_ip.id
}

output "vmss_id" {
  description = "The ID of the VM Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.ah_vmss_scale.id
}

output "vmss_name" {
  description = "The name of the VM Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.ah_vmss_scale.name
}

output "vmss_instance_count" {
  description = "Number of instances in the VM Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.ah_vmss_scale.instances
}