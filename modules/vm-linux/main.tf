####################
# Provider section #
####################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.98.0"
    }
  }
}

provider "azurerm" {
  features {}
}

#####################
# Resources section #
#####################

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine
resource "azurerm_network_interface" "nic" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  size                            = var.size
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    name                 = "${var.name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  boot_diagnostics {
    storage_account_uri = var.storage_account_primary_blob_endpoint
  }
  #custom_data = filebase64(var.custom_data_path)
  custom_data = filebase64("${var.custom_data_path}")
  #custom_data = filebase64("../built-cloud-standard.sh")

   depends_on = [var.vmlinux_depends_on]
}
