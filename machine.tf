variable "storage_account_name" {
    type=string
    default="diegoteststore"
}
 
variable "network_name" {
    type=string
    default="DiegoTest_Net"
}
 
variable "vm_name" {
    type=string
    default="DiegoTest_vm"
}
 
provider "azurerm"{
version = "=2.0"
subscription_id = "ed869e72-a62e-4a1c-8133-92f57db9f18b"
tenant_id       = "e5baf64e-2346-4edc-bbfe-bc3c3294a842"
features {}
}
 
resource "azurerm_virtual_network" "staging" {
  name                = var.network_name
  address_space       = ["10.0.0.0/16"]
  location            = "North Europe"
  resource_group_name = "diego_test_grp"
}
 
resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = "diego_test_grp"
  virtual_network_name = azurerm_virtual_network.staging.name
  address_prefix     = "10.0.0.0/24"
}
 
resource "azurerm_network_interface" "interface" {
  name                = "default-interface"
  location            = "North Europe"
  resource_group_name = "diego_test_grp"
 
  ip_configuration {
    name                          = "interfaceconfiguration"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
  }
}
 
resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = "North Europe"
  resource_group_name   = "diego_test_grp"
  network_interface_ids = [azurerm_network_interface.interface.id]
  vm_size               = "Standard_DS1_v2"
 
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "DiegoTestvm"
    admin_username = "DiegoTest"
    admin_password = "AdminDiegoKC001"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }  
}