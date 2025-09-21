resource "azurerm_linux_virtual_machine_scale_set" "ah_vmss_scale" {
  name                = var.virtual_machine_scale_set_name
  resource_group_name = var.resource_group_name
  location            = var.location
  instances           = 2
  sku                 = "Standard_B1s"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  tags = var.common_tags

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-minimal-jammy"
    sku       = "minimal-22_04-lts"
    version   = "latest"
  }

  upgrade_mode = "Automatic"

  network_interface {
    name    = "ah_network_interface"
    primary = true


    ip_configuration {
      name                                   = "autohealing_private_ip"
      subnet_id                              = var.subnet_id
      primary                                = true
      load_balancer_backend_address_pool_ids = [var.backend_pool_id]
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  custom_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl enable nginx
              systemctl start nginx
            EOF
  )
}