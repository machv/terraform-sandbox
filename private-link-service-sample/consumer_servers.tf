resource "azurerm_network_interface" "client01" {
  name                = "consumer-client-001-nic-001"
  location            = azurerm_resource_group.consumer.location
  resource_group_name = azurerm_resource_group.consumer.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.consumer_servers.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "client01" {
  name                            = "consumer-client-001"
  location                        = azurerm_resource_group.consumer.location
  resource_group_name             = azurerm_resource_group.consumer.name
  network_interface_ids           = [azurerm_network_interface.client01.id]
  size                            = "Standard_B1s"
  admin_username                  = "azureadmin"
  admin_password                  = random_password.password.result
  disable_password_authentication = false

  source_image_reference {
    publisher = "debian"
    offer     = "debian-11"
    sku       = "11-gen2"
    version   = "latest"
  }

  os_disk {
    name                 = "consumer-client-001-osdisk-001"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  boot_diagnostics {
  }
}
