resource "azurerm_network_interface" "srv01" {
  name                = "provider-server-001-nic-001"
  location            = azurerm_resource_group.provider.location
  resource_group_name = azurerm_resource_group.provider.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.service.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "srv01" {
  network_interface_id    = azurerm_network_interface.srv01.id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.pls.id
}

resource "azurerm_linux_virtual_machine" "srv01" {
  name                            = "provider-server-001"
  location                        = azurerm_resource_group.provider.location
  resource_group_name             = azurerm_resource_group.provider.name
  network_interface_ids           = [azurerm_network_interface.srv01.id]
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
    name                 = "provider-server-001-osdisk-001"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  boot_diagnostics {
  }
}
