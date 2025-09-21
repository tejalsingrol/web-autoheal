resource "azurerm_virtual_network" "ah_vnet" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  resource_group_name = var.resource_group_name
  location            = var.location
  tags = var.common_tags

}

resource "azurerm_subnet" "ah_subnet" {
  name                 = var.subnet_name
  address_prefixes     = var.subnet_prefix
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ah_vnet.name

}
