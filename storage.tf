variable "storage_account_name" {
    type=string
    default="diegoteststore"
}
 
variable "resource_group_name" {
    type=string
    default="diego_test_grp"
}
 
provider "azurerm"{
version = "=2.0"
subscription_id = "ed869e72-a62e-4a1c-8133-92f57db9f18b"
tenant_id       = "e5baf64e-2346-4edc-bbfe-bc3c3294a842"
features {}
}
 
resource "azurerm_resource_group" "grp" {
  name     = var.resource_group_name
  location = "North Europe"
}
 
resource "azurerm_storage_account" "store" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.grp.name
  location                 = azurerm_resource_group.grp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
