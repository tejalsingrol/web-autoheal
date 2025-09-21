output "lb_public_ip" {
  value = azurerm_public_ip.ah_public_ip.ip_address
}

output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.ah_backend.id
}