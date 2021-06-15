variable "subscription_id" {
  description = "The subscription ID of the Azure resources to be used."
}

variable "client_id" {
  description = "The client ID of the Azure user to be used."
}

variable "client_secret" {
  description = "The client secret or password of the Azure user to be used."
}

variable "tenant_id" {
  description = "The tenant ID of the Azure resources to be used."
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_A0"
}

variable "image_publisher" {
  description = "Name of the publisher of the image (az vm image list)"
  default     = "Canonical"
}

variable "image_offer" {
  description = "Name of the offer (az vm image list)"
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "Image SKU to apply (az vm image list)"
  default     = "16.04-LTS"
}

variable "image_version" {
  description = "Version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "admin_username" {
  description = "Administrator user name for linux and mysql"
  default     = "hashicorp"
}

variable "admin_password" {
  description = "Administrator password for linux and mysql"
  default     = "Password123!"
}

variable "tfver" {
  description = "Terraform version in use."
}
