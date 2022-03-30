# module "simple" {
#   source              = "../../"
#   name                = "softcatbasictest"
#   random_suffix       = false
#   resource_group_name = "storage-account-test-basic"
#   location            = "westeurope"

#   containers = [
#     {
#       name        = "softcat-container-test-basic"
#       access_type = "private"
#     }
#   ]
# }

# resource "azurerm_resource_group" "example" {
#   name     = "storage-account-test-basic"
#   location = "westeurope"
# }


# resource "azurerm_storage_account" "example" {
#   name                     = "softcatbasictest"
#   resource_group_name      = azurerm_resource_group.example.name
#   location                 = azurerm_resource_group.example.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   tags = {
#     environment = "test"
#   }
#   depends_on = [
#     azurerm_resource_group.example
#   ]
# }


# resource "azurerm_storage_container" "example" {
#   name                  = "softcat-container-test-basic"
#   storage_account_name  = azurerm_storage_account.example.name
#   container_access_type = "private"

#   depends_on = [
#     azurerm_storage_account.example
#   ]
# }
