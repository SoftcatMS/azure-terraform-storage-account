module "simple" {
  source              = "../../"
  name                = "softcatbasictest"
  random_suffix       = false
  resource_group_name = "storage-account-test-basic"
  location            = "westeurope"

  containers = [
    {
      name        = "softcat-container-test-basic"
      access_type = "private"
    },
  ]
}
