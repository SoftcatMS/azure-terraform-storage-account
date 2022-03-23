module "simple" {
  source              = "github.com/SoftcatMS/terraform-azure-storage-account"
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
