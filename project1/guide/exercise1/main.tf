provider "azurerm" {
    subscription_id = "2fd588c2-ba77-4dde-b8d0-d9093b711a6c"
  features {}
}

variable "resource_group_name" {
    type = string
    description = "The name of the resource group"
}
variable "location" {
  type = string
  description = "The Azure region to build resources in"
  default = "West Europe"
}
variable "virtual_network_name" {
  type = string
}
variable "virtual_network_cidr" {
  type = string
}
variable "subnet_name" {
  type = string
}
variable "subnet_cidr" {
  type = string
}

variable "virtual_machine" {
  type = map(string)
}
variable "tags" {
  type = map(string)
}


resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags = var.tags
}

resource "azurerm_virtual_network" "this" {
  name                = var.virtual_network_name
  address_space       = [var.virtual_network_cidr]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_network_interface" "this" {
  name                = "${var.virtual_machine.name}-nic"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "random_password" "this" {
  length           = 16
  special          = true
}

resource "azurerm_windows_virtual_machine" "this" {
  name                = var.virtual_machine.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = var.virtual_machine.size
  admin_username      = "adminuser"
  admin_password      = random_password.this.result
  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.virtual_machine.publisher
    offer     = var.virtual_machine.offer
    sku       = var.virtual_machine.sku
    version   = var.virtual_machine.version
  }
}