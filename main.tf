resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
}

#-------------------------------
# Local Declarations
#-------------------------------
locals {
  account_tier             = (var.account_kind == "FileStorage" ? "Premium" : split("_", var.skuname)[0])
  account_replication_type = (local.account_tier == "Premium" ? "LRS" : split("_", var.skuname)[1])
  resource_group_name      = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location                 = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  suffix                   = var.random_suffix ? "${random_string.unique.result}" : ""
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "false"
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", var.resource_group_name) }, var.tags, )
}

#---------------------------------------------------------
# Storage Account Creation or selection 
#----------------------------------------------------------
resource "azurerm_storage_account" "storeacc" {
  #checkov:skip=CKV_AZURE_35:Ensure default network access rule for Storage Accounts is set to deny
  #checkov:skip=CKV_AZURE_43:Ensure Storage Accounts adhere to the naming rules
  #checkov:skip=CKV_AZURE_59:Ensure that Storage accounts disallow public access
  #checkov:skip=CKV2_AZURE_1:Ensure storage for critical data are encrypted with Customer Managed Key
  #checkov:skip=CKV2_AZURE_18:Ensure that Storage Accounts use customer-managed key for encryption
  name                      = format("%s%s", lower(replace(var.name, "/[[:^alnum:]]/", "")), local.suffix)
  resource_group_name       = local.resource_group_name
  location                  = local.location
  account_kind              = var.account_kind
  account_tier              = local.account_tier
  account_replication_type  = local.account_replication_type
  enable_https_traffic_only = true
  min_tls_version           = var.min_tls_version
  allow_blob_public_access  = var.enable_advanced_threat_protection == true ? true : false
  tags                      = var.tags

  identity {
    type         = var.identity_ids != null ? "SystemAssigned, UserAssigned" : "SystemAssigned"
    identity_ids = var.identity_ids
  }

  queue_properties {
    dynamic "logging" {
      for_each = var.logging
      content {
        delete                = logging.value.delete
        read                  = logging.value.read
        write                 = logging.value.write
        version               = logging.value.version
        retention_policy_days = logging.value.retention_policy_days
      }
    }
    dynamic "hour_metrics" {
      for_each = var.hour_metrics
      content {
        enabled               = hour_metrics.value.enabled
        include_apis          = hour_metrics.value.include_apis
        version               = hour_metrics.value.version
        retention_policy_days = hour_metrics.value.retention_policy_days
      }
    }
    dynamic "minute_metrics" {
      for_each = var.minute_metrics
      content {
        enabled               = minute_metrics.value.enabled
        include_apis          = minute_metrics.value.include_apis
        version               = minute_metrics.value.version
        retention_policy_days = minute_metrics.value.retention_policy_days
      }
    }
  }


  blob_properties {
    delete_retention_policy {
      days = var.blob_soft_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.container_soft_delete_retention_days
    }
    versioning_enabled       = var.enable_versioning
    last_access_time_enabled = var.last_access_time_enabled
    change_feed_enabled      = var.change_feed_enabled
  }

  dynamic "network_rules" {
    for_each = var.network_rules != null ? ["true"] : []
    content {
      default_action             = var.network_rules.default_action
      bypass                     = var.network_rules.bypass
      ip_rules                   = var.network_rules.ip_rules
      virtual_network_subnet_ids = var.network_rules.subnet_ids
    }
  }
}

#--------------------------------------
# Storage Advanced Threat Protection 
#--------------------------------------
resource "azurerm_advanced_threat_protection" "atp" {
  target_resource_id = azurerm_storage_account.storeacc.id
  enabled            = var.enable_advanced_threat_protection
}

#-------------------------------
# Storage Container Creation
#-------------------------------
resource "azurerm_storage_container" "container" {
  #checkov:skip=CKV_AZURE_34:Ensure that 'Public access level' is set to Private for blob containers
  count                 = length(var.containers_list)
  name                  = var.containers_list[count.index].name
  storage_account_name  = azurerm_storage_account.storeacc.name
  container_access_type = var.containers_list[count.index].access_type
}

#-------------------------------
# Storage Fileshare Creation
#-------------------------------
resource "azurerm_storage_share" "fileshare" {
  count                = length(var.file_shares)
  name                 = var.file_shares[count.index].name
  storage_account_name = azurerm_storage_account.storeacc.name
  quota                = var.file_shares[count.index].quota
}

#-------------------------------
# Storage Tables Creation
#-------------------------------
resource "azurerm_storage_table" "tables" {
  #checkov:skip=CKV2_AZURE_20:Ensure Storage logging is enabled for Table service for read requests
  count                = length(var.tables)
  name                 = var.tables[count.index]
  storage_account_name = azurerm_storage_account.storeacc.name
}

#-------------------------------
# Storage Queue Creation
#-------------------------------
resource "azurerm_storage_queue" "queues" {
  count                = length(var.queues)
  name                 = var.queues[count.index]
  storage_account_name = azurerm_storage_account.storeacc.name
}

#-------------------------------
# Storage Lifecycle Management
#-------------------------------
resource "azurerm_storage_management_policy" "lcpolicy" {
  count              = length(var.lifecycles) == 0 ? 0 : 1
  storage_account_id = azurerm_storage_account.storeacc.id

  dynamic "rule" {
    for_each = var.lifecycles
    iterator = rule
    content {
      name    = "rule${rule.key}"
      enabled = true
      filters {
        prefix_match = rule.value.prefix_match
        blob_types   = ["blockBlob"]
      }
      actions {
        base_blob {
          tier_to_cool_after_days_since_modification_greater_than    = rule.value.tier_to_cool_after_days
          tier_to_archive_after_days_since_modification_greater_than = rule.value.tier_to_archive_after_days
          delete_after_days_since_modification_greater_than          = rule.value.delete_after_days
        }
        snapshot {
          delete_after_days_since_creation_greater_than = rule.value.snapshot_delete_after_days
        }
      }
    }
  }
}
