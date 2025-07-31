# This is where provider, and remote state configuration live
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.96.0"
    }
  }
}
provider "azurerm" {
  # Configuration options
  subscription_id = "1180d7d2-bb0a-4c4a-8011-1a73b31a7318"
  features {}
}