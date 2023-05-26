resource "azurerm_private_link_service" "pls" {
  name                = "provider-pls"
  resource_group_name = azurerm_resource_group.provider.name
  location            = azurerm_resource_group.provider.location

  auto_approval_subscription_ids              = [data.azurerm_client_config.current.subscription_id]
  visibility_subscription_ids                 = [data.azurerm_client_config.current.subscription_id]
  load_balancer_frontend_ip_configuration_ids = [azurerm_lb.pls.frontend_ip_configuration.0.id]

  nat_ip_configuration {
    name                       = "primary"
    private_ip_address         = "10.5.1.17"
    private_ip_address_version = "IPv4"
    subnet_id                  = azurerm_subnet.service.id
    primary                    = true
  }

  nat_ip_configuration {
    name                       = "secondary"
    private_ip_address         = "10.5.1.18"
    private_ip_address_version = "IPv4"
    subnet_id                  = azurerm_subnet.service.id
    primary                    = false
  }
}
