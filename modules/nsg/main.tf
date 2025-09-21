
resource "azurerm_network_security_group" "ah_nsg" {
  name                = var.network_security_group
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.common_tags

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_subnet_network_security_group_association" "ah_nsg_subnet" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.ah_nsg.id
}