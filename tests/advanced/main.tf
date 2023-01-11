module "advanced" {
  source = "../../"

  name                  = "softcatadvancedtest"
  create_resource_group = true
  resource_group_name   = "storage-account-test-advanced"
  location              = "westeurope"
  random_suffix         = false

  containers_list = [
    { name = "softcat-container-1-test-advanced", access_type = "private" },
    { name = "softcat-container-2-test-advanced", access_type = "blob" },
    { name = "softcat-container-3-test-advanced", access_type = "container" }

  ]

  enable_advanced_threat_protection = true

  network_rules = {
    default_action = "Allow"
    bypass         = ["AzureServices"]
    subnet_ids     = []
    ip_rules       = []
  }


  # SMB file share with quota (GB) to create
  file_shares = [
    { name = "smbfileshare1", quota = 50 },
    { name = "smbfileshare2", quota = 50 }
  ]

  # Storage tables
  tables = ["table1", "table2", "table3"]

  # Storage queues
  queues = ["queue1", "queue2"]

  # Lifecycle management for storage account.
  # Must specify the value to each argument and default is `0` 
  lifecycles = [
    {
      prefix_match               = ["mystore250/folder_path"]
      tier_to_cool_after_days    = 0
      tier_to_archive_after_days = 50
      delete_after_days          = 100
      snapshot_delete_after_days = 30
    },
    {
      prefix_match               = ["blobstore251/another_path"]
      tier_to_cool_after_days    = 0
      tier_to_archive_after_days = 30
      delete_after_days          = 75
      snapshot_delete_after_days = 30
    }
  ]

  tags = {
    environment = "test"
    engineer    = "ci/cd"
  }
}
