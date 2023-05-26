locals {
  service_port = 11112
}

resource "azurerm_virtual_network" "provider" {
  name                = "vnet-provider"
  resource_group_name = azurerm_resource_group.provider.name
  location            = azurerm_resource_group.provider.location
  address_space       = ["10.5.0.0/16"]
}

resource "azurerm_subnet" "service" {
  name                                          = "service"
  resource_group_name                           = azurerm_resource_group.provider.name
  virtual_network_name                          = azurerm_virtual_network.provider.name
  address_prefixes                              = ["10.5.1.0/24"]
  private_link_service_network_policies_enabled = false
}

resource "azurerm_lb" "pls" {
  name                = "lb-provider"
  sku                 = "Standard"
  location            = azurerm_resource_group.provider.location
  resource_group_name = azurerm_resource_group.provider.name

  frontend_ip_configuration {
    name                          = "frontend-001"
    subnet_id                     = azurerm_subnet.service.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "pls" {
  name            = "app-backend"
  loadbalancer_id = azurerm_lb.pls.id
}

resource "azurerm_lb_probe" "app_probe" {
  name            = "tcp-probe"
  protocol        = "Tcp"
  port            = local.service_port
  loadbalancer_id = azurerm_lb.pls.id
}

resource "azurerm_lb_rule" "app_lb_rule_app1" {
  name                           = "app1-rule"
  protocol                       = "Udp"
  frontend_port                  = local.service_port
  backend_port                   = local.service_port
  frontend_ip_configuration_name = azurerm_lb.pls.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.pls.id]
  probe_id                       = azurerm_lb_probe.app_probe.id
  loadbalancer_id                = azurerm_lb.pls.id
}

resource "azurerm_public_ip" "nat001" {
  name                = "provider-nat-gateway-pip-001"
  location            = azurerm_resource_group.provider.location
  resource_group_name = azurerm_resource_group.provider.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "provider_nat" {
  name                    = "provider_nat-gateway"
  location                = azurerm_resource_group.provider.location
  resource_group_name     = azurerm_resource_group.provider.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

resource "azurerm_nat_gateway_public_ip_association" "ip001" {
  nat_gateway_id       = azurerm_nat_gateway.provider_nat.id
  public_ip_address_id = azurerm_public_ip.nat001.id
}

resource "azurerm_subnet_nat_gateway_association" "nat_service" {
  subnet_id      = azurerm_subnet.service.id
  nat_gateway_id = azurerm_nat_gateway.provider_nat.id
}
