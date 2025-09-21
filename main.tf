resource "azurerm_resource_group" "ah_rg" {
  name     = var.resource_group_name
  location = var.location
  tags = var.common_tags
}

module "network" {
  source              = "./modules/network"
  location            = var.location
  resource_group_name = azurerm_resource_group.ah_rg.name
  virtual_network_name = var.virtual_network_name
  subnet_name         = var.subnet_name
  subnet_prefix       = var.subnet_prefix
  common_tags         = var.common_tags
}

module "nsg" {
  source              = "./modules/nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  network_security_group            = var.network_security_group
  subnet_id           = module.network.subnet_id
  common_tags         = var.common_tags
}

module "lb" {
  source              = "./modules/lb"
  resource_group_name = var.resource_group_name
  location            = var.location
  public_ip_name      = var.public_ip_name
  loadbalancer_name             = var.loadbalancer_name
  common_tags                = var.common_tags
}

module "vmss" {
  source                        = "./modules/vmss"
  resource_group_name           = azurerm_resource_group.ah_rg.name
  location                      = var.location
  virtual_machine_scale_set_name = var.virtual_machine_scale_set_name
  admin_username                = var.admin_username
  admin_password                = var.admin_password
  subnet_id                     = module.network.subnet_id
  backend_pool_id               = module.lb.backend_pool_id
  common_tags = var.common_tags
}
