module "simple" {
  source = "../../"

  name                  = "softcatbasictest"
  create_resource_group = true
  resource_group_name   = "storage-account-test-basic"
  location              = "westeurope"
  random_suffix         = false

  network_rules = {
    default_action = "Allow"
    bypass         = ["AzureServices"]
    subnet_ids     = []
    ip_rules       = []
  }


  containers_list = [
    { name = "softcat-container-1-test-basic", access_type = "private" },
    { name = "softcat-container-2-test-basic", access_type = "private" }
  ]

  tags = {
    environment = "test"
    engineer    = "ci/cd"
  }

}
