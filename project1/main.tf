# This is where the bulk of your Terraform code will live
locals {
  tags = merge({new-tag = "stuff"}, var.tags)
}

data "azurerm_resource_group" "this" {
  name = "cal-1504-b63"
}

data "azurerm_virtual_network" "this" {
  name                = "ca-lab-vnet"
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_subnet" "this" {
  name                 = "snet-tfworkshop-kev"
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = data.azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/28"]
}

resource "azurerm_network_interface" "this" {
  name                = "my-nic"
  location            = data.azurerm_virtual_network.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "count" {
  count = 3
  name                = "my-nic${count.index}"
  location            = data.azurerm_virtual_network.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "each" {
  for_each = var.vms
  name                = "${each.value.name}-nic"
  location            = data.azurerm_virtual_network.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "random_password" "this" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_windows_virtual_machine" "this" {
  name                = "vmw-kev"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  size                = var.vm_size
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
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  tags = local.tags
}

resource "azurerm_windows_virtual_machine" "count" {
  count = 3
  name                = "vmw-kev${count.index}"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  size                = var.vm_size
  admin_username      = "adminuser"
  admin_password      = random_password.this.result
  network_interface_ids = [
    azurerm_network_interface.count[count.index].id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  tags = local.tags
}





resource "azurerm_windows_virtual_machine" "each" {
  for_each = var.vms
  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  size                = each.value.size
  admin_username      = "adminuser"
  admin_password      = random_password.this.result
  network_interface_ids = [
    azurerm_network_interface.each[each.key].id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  tags = local.tags
}