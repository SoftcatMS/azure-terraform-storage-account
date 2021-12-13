terraform {
  required_version = ">=1.0.0"

  backend "azurerm" {
    resource_group_name  = "Terraform-Storage-accountRG"
    storage_account_name = "softcattfmodulestate"
    container_name       = "tf-modules-azure-storage-account-basic"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}


# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
