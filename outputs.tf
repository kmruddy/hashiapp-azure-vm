output "credentials" {
  value = {
    username = var.admin_username
    password = var.admin_password
  }
  sensitive = true
}

output "vmname" {
  value = azurerm_virtual_machine.happ_vm.name
}

output "tfver" {
  value = var.tfver
}
