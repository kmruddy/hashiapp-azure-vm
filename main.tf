terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "1.44.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

data "terraform_remote_state" "haarg" {
  backend = "remote"

  config = {
    organization = "TPMM-Org"
    workspaces = {
      name = "hashiapp-azure-resourcegroup"
    }
  }
}

data "azurerm_resource_group" "demo_rg" {
  name = data.terraform_remote_state.haarg.outputs.rg_name
}

data "azurerm_network_interface" "happ_nic" {
  name                = "${data.terraform_remote_state.haarg.outputs.prefix}-happ-nic"
  resource_group_name = data.azurerm_resource_group.myresourcegroup.name
}

data "azurerm_public_ip" "happ_pip" {
  name                = "${data.terraform_remote_state.haarg.outputs.prefix}-ip"
  resource_group_name = data.azurerm_resource_group.myresourcegroup.name
}

resource "azurerm_virtual_machine" "happ_vm" {
  name                = "${data.terraform_remote_state.haarg.outputs.prefix}-demo-app"
  location            = data.azurerm_resource_group.myresourcegroup.location
  resource_group_name = data.azurerm_resource_group.myresourcegroup.name
  vm_size             = var.vm_size

  network_interface_ids         = [data.azurerm_network_interface.happ_nic.id]
  delete_os_disk_on_termination = "true"

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  storage_os_disk {
    name              = "${data.terraform_remote_state.haarg.outputs.prefix}-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = data.terraform_remote_state.haarg.outputs.prefix
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "null_resource" "configure_happ" {
  depends_on = [
    azurerm_virtual_machine.happ_vm,
  ]

  triggers = {
    build_number = timestamp()
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt -y update",
      "sudo apt -y install apache2",
    ]

    connection {
      type     = "ssh"
      user     = var.admin_username
      password = var.admin_password
      host     = data.azurerm_public_ip.happ_pip.fqdn
    }
  }
}
