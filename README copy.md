# azure-terraform-storage-account

Deploys a Storage Account in Azure with set of container

Based of original module: https://github.com/avinor/terraform-azurerm-storage-account

It supports creating:

- Storage Account
- Container


## Usage Examples
Review the examples folder: [examples](./examples)


## Deployment
Perform the following commands on the root folder:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure


< use terraform-docs to create Inputs and Outpus documentation  [terraform-docs](https://github.com/terraform-docs/terraform-docs)

`terraform-docs markdown .`


## Requirements
### Installed Software
The following dependencies must be installed on the development system:

- [Terraform](https://www.terraform.io/downloads.html) 

Azure  
- [Terraform Provider for Azure](https://github.com/hashicorp/terraform-provider-azurerm)
- CLI Tool [az](https://docs.microsoft.com/en-us/cli/azure/)

AWS  
- [Terraform Provider for AWS](https://github.com/hashicorp/terraform-provider-aws)
- CLI Tool [aws-cli](https://aws.amazon.com/cli/)

GCP  
- [Terraform Provider for GCP](https://github.com/hashicorp/terraform-provider-google)
- [Terraform Provider for GCP Beta](https://github.com/terraform-providers/terraform-provider-google-beta)
- CLI Tool [gcloud](https://cloud.google.com/sdk/gcloud/)


## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.



## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.
