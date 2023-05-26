terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.19.0"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.management,
      ]
    }
  }

  required_version = ">= 1.3.1" # for optional parameters
}

provider "azurerm" {
  subscription_id = "94efac27-35e1-4e27-87a2-e54d5e95ed34"

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

data "azurerm_client_config" "current" {
}
