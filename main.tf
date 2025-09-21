resource "azurerm_resource_group" "ah_rg" {
  name     = var.resource_group_name
  location = var.location
  tags = var.common_tags
}

resource "azurerm_virtual_network" "ah_vnet" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.ah_rg.name
  location            = var.location
  tags = var.common_tags

}

resource "azurerm_network_security_group" "ah_nsg" {
  name                = var.network_security_group
  location            = var.location
  resource_group_name = azurerm_resource_group.ah_rg.name
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


resource "azurerm_subnet" "ah_subnet" {
  name                 = var.subnet_name
  address_prefixes     = var.subnet_prefix
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ah_vnet.name

}

resource "azurerm_subnet_network_security_group_association" "ah_nsg_subnet" {
  subnet_id                 = azurerm_subnet.ah_subnet.id
  network_security_group_id = azurerm_network_security_group.ah_nsg.id
}

resource "azurerm_public_ip" "ah_public_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.ah_rg.name
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
      subnet_id                              = azurerm_subnet.ah_subnet.id
      primary                                = true
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.ah_backend.id]
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = "azureuser"
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
resource "azurerm_monitor_autoscale_setting" "ah_vmss_scale" {
  name                = "ah_autoscale"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.ah_vmss_scale.id
  tags = var.common_tags

  profile {
    name = "default"

    capacity {
      minimum = "2"
      maximum = "3"
      default = "2"
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.ah_vmss_scale.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT1M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.ah_vmss_scale.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT1M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}