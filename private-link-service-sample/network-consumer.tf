resource "azurerm_virtual_network" "consumer" {
  name                = "vnet-consumer"
  resource_group_name = azurerm_resource_group.consumer.name
  location            = azurerm_resource_group.consumer.location
  address_space       = ["10.50.0.0/16"]
}

resource "azurerm_subnet" "consumer_endpoints" {
  name                                          = "endpoints"
  resource_group_name                           = azurerm_resource_group.consumer.name
  virtual_network_name                          = azurerm_virtual_network.consumer.name
  address_prefixes                              = ["10.50.1.0/24"]
}

resource "azurerm_subnet" "consumer_servers" {
  name                                          = "servers"
  resource_group_name                           = azurerm_resource_group.consumer.name
  virtual_network_name                          = azurerm_virtual_network.consumer.name
  address_prefixes                              = ["10.50.2.0/24"]
}

resource "azurerm_private_endpoint" "pe" {
  name                 = "pe-service"
  resource_group_name  = azurerm_resource_group.consumer.name
  location             = azurerm_resource_group.consumer.location
  subnet_id            = azurerm_subnet.consumer_endpoints.id

#  private_dns_zone_group {
#    name                 = "private-dns-zone-group"
#    private_dns_zone_ids = [azurerm_private_dns_zone.ple_dns_zone.id]
#  }

  private_service_connection {
    name                           = "pe-service"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_private_link_service.pls.id
  }
}