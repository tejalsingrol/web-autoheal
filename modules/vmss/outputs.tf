output "vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.ah_vmss_scale.id
}

output "vmss_name" {
  value = var.virtual_machine_scale_set_name
}

