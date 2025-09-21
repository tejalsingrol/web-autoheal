resource "azurerm_public_ip" "ah_public_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  tags = var.common_tags
}


resource "azurerm_lb" "ah_lb" {
  name                = var.loadbalancer_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags = var.common_tags
  frontend_ip_configuration {
    name                 = "ah_frontend_ip"
    public_ip_address_id = azurerm_public_ip.ah_public_ip.id
  }
}


resource "azurerm_lb_backend_address_pool" "ah_backend" {
  name            = "ah_backend_pool"
  loadbalancer_id = azurerm_lb.ah_lb.id
}


resource "azurerm_lb_probe" "ah_probe" {
  name                = "ah_health_probe"
  loadbalancer_id     = azurerm_lb.ah_lb.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}


resource "azurerm_lb_rule" "ah_lb_rule" {
  loadbalancer_id                = azurerm_lb.ah_lb.id
  name                           = "httpRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.ah_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ah_backend.id]
  probe_id                       = azurerm_lb_probe.ah_probe.id
}
