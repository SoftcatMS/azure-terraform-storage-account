module "simple" {
  source              = "git@github.com:SoftcatMS/azure-terraform-storage-account"
  name                = "softcatbasicexample"
  random_suffix       = false
  resource_group_name = "storage-account-example-basic"
  location            = "westeurope"

  containers = [
    {
      name        = "softcat-container-example-basic"
      access_type = "private"
    },
  ]
}
