terraform {
  required_version = ">=1.0.0"

  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate25210"
    container_name       = "tf-modules-azure-storage-account-basic"
    key                  = "terraform.tfstate"
  }

  required_providers {
    # Uncomment required providers and delete unneeded
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

