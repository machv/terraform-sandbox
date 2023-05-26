resource "azurerm_resource_group" "provider" {
  name     = "rg-pls-provider"
  location = "westeurope"
}

resource "azurerm_resource_group" "consumer" {
  name     = "rg-pls-consumer"
  location = "westeurope"
}

resource "random_password" "password" {
  length = 22
  lower = true
  min_lower = 4
  upper = true
  min_upper = 4
  numeric = true
  min_numeric = 4
  special = true
  min_special = 4
  override_special = "*?!#+=-_"
}
