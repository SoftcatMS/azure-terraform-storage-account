# resource "random_string" "random" {
#   length  = 4
#   special = false
#   upper   = false
# }

# locals {
#   hub_suffix = random_string.random.result
# }

# resource "azurerm_resource_group" "test_event_hub" {
#   name     = "test-event-hub"
#   location = "West Europe"
# }

# resource "azurerm_eventhub_namespace" "test_event_hub_ns" {
#   name                = lower(join("-", ["TestEventHubNamespace", (local.hub_suffix)]))
#   location            = azurerm_resource_group.test_event_hub.location
#   resource_group_name = azurerm_resource_group.test_event_hub.name
#   sku                 = "Standard"
#   capacity            = 1

#   tags = {
#     environment = "Production"
#   }
# }

# resource "azurerm_eventhub" "eventhub" {
#   name                = "TestEventHub"
#   namespace_name      = azurerm_eventhub_namespace.test_event_hub_ns.name
#   resource_group_name = azurerm_resource_group.test_event_hub.name
#   partition_count     = 2
#   message_retention   = 1
# }


# module "advanced" {
#   source              = "../../"
#   name                = "softcatadvtest"
#   random_suffix       = false
#   resource_group_name = "storage-account-test-advanced"
#   location            = "westeurope"

#   containers = [
#     {
#       name        = "softcat-container-test-advanced"
#       access_type = "private"
#     },
#   ]
#   lifecycles = [
#     {
#       prefix_match      = ["softcat-container-test-advanced/path1"]
#       delete_after_days = 2
#     },
#     {
#       prefix_match      = ["softcat-container-test-advanced/path2"]
#       delete_after_days = 5
#     }
#   ]
#   cors_rule = [
#     {
#       allowed_origins    = ["https://myhost.com"]
#       allowed_methods    = ["GET", "OPTIONS"]
#       allowed_headers    = ["*"]
#       exposed_headers    = ["*"]
#       max_age_in_seconds = 200
#     },
#   ]
#   events = [
#     {
#       name                 = "send-to-eventhub"
#       eventhub_id          = azurerm_eventhub.eventhub.id
#       service_bus_topic_id = null
#       included_event_types = ["Microsoft.Storage.BlobCreated", "Microsoft.Storage.BlobDeleted"]
#       filters = {
#         subject_begins_with = "test"
#       }
#     }
#   ]
# }
