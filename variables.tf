variable "name" {
  description = "Name of storage account, if it contains illegal characters (,-_ etc) those will be truncated."
}

variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
}

variable "location" {
  description = "Azure location where resources should be deployed."
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium. Changing this forces a new resource to be created."
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
  default     = "ZRS"
}

variable "access_tier" {
  description = "Defines the access tier for BlobStorage and StorageV2 accounts. Valid options are Hot and Cool."
  default     = "Hot"
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account. Possible values are TLS1_0, TLS1_1, and TLS1_2."
  default     = "TLS1_2"
}

variable "soft_delete_retention" {
  description = "Number of retention days for soft delete. If set to null it will disable soft delete all together."
  type        = number
  default     = 31
}

variable "cors_rule" {
  description = "CORS rules for storage account."
  type = list(object({
    allowed_origins    = list(string)
    allowed_methods    = list(string)
    allowed_headers    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
  default = []
}

variable "random_suffix" {
  description = "Boolean flag which controls if random string appened to name."
  type        = bool
  default     = false
}

variable "enable_advanced_threat_protection" {
  description = "Boolean flag which controls if advanced threat protection is enabled."
  type        = bool
  default     = false
}

variable "network_rules" {
  description = "Network rules restricting access to the storage account."
  type = object({
    ip_rules   = list(string)
    subnet_ids = list(string)
    bypass     = list(string)
  })
  default = {
    ip_rules   = []
    subnet_ids = []
    bypass     = ["AzureServices"]
  }
}

variable "containers" {
  description = "List of containers to create and their access levels."
  type = list(object({
    name        = string
    access_type = string
  }))
  default = []
}

variable "events" {
  description = "List of event subscriptions. See documentation for format description."
  type        = list(any)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}

variable "lifecycles" {
  description = "List of lifecycle delete"
  type = list(object({
    prefix_match      = set(string)
    delete_after_days = number
  }))
  default = []
}

variable "diagnostics" {
  description = "Diagnostic settings for those resources that support it. See README.md for details on configuration."
  type = object({
    destination   = string
    eventhub_name = string
    logs          = list(string)
    metrics       = list(string)
  })
  default = null
}

variable "logging" {
  description = "Logging config for queue properties."
  type = list(object({
    delete                = bool
    read                  = bool
    write                 = bool
    version               = string
    retention_policy_days = number
  }))
  default = [{
    delete                = true
    read                  = true
    write                 = true
    version               = "1.0"
    retention_policy_days = 10
  }]
}

variable "hour_metrics" {
  description = "Hour Metrics for queue properties."
  type = list(object({
    enabled               = bool
    include_apis          = bool
    version               = string
    retention_policy_days = number
  }))
  default = [{
    enabled               = true
    include_apis          = true
    version               = "1.0"
    retention_policy_days = 10
  }]
}

variable "minute_metrics" {
  description = "Minute Metrics for queue properties."
  type = list(object({
    enabled               = bool
    include_apis          = bool
    version               = string
    retention_policy_days = number
  }))
  default = [{
    enabled               = true
    include_apis          = true
    version               = "1.0"
    retention_policy_days = 10
  }]
}
