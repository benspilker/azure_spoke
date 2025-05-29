provider "azurerm" {
  subscription_id = var.hub_vnet_details.spoke_subscription_id
  features {}
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = var.hub_vnet_details.hub_subscription_id
  features {}
}