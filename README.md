# Container registry

This terraform module automates the creation of container registry resources on the azure cloud platform, enabling easier deployment and management of container images.

The below features are made available:

- encryption at rest
- replication support
- fine grained access control using scope maps
- terratest is used to validate different integrations

The below examples shows the usage when consuming the module:

## Usage: simple

```hcl
module "acr" {
  source = "github.com/cloudnationhq/az-cn-module-tf-acr"

  workload       = var.workload
  environment    = var.environment

  registry = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    sku           = "Premium"
  }
  depends_on = [module.rg]
}
```

## Usage: replications

```hcl
module "acr" {
  source = "github.com/cloudnationhq/az-cn-module-tf-acr"

  workload       = var.workload
  environment    = var.environment

  registry = {
    location            = module.rg.groups.demo.location
    resourcegroup       = module.rg.groups.demo.name
    sku                 = "Premium"

    replications = {
      sea  = { location = "southeastasia" }
      eus  = { location = "eastus" }
      eus2 = { location = "eastus2", regional_endpoint_enabled = true }
    }
  }
  depends_on = [module.rg]
}
```

## Usage: encryption

```hcl
module "acr" {
  source = "github.com/cloudnationhq/az-cn-module-tf-acr"

  workload       = var.workload
  environment    = var.environment

  registry = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    sku           = "Premium"

    encryption = {
      enable                = true
      kv_key_id             = module.kv.kv_keys.exkdp.id
      role_assignment_scope = module.kv.vault.id
    }
  }
  depends_on = [module.rg]
}
```

## Usage scope maps

```hcl
module "acr" {
  source = "github.com/cloudnationhq/az-cn-module-tf-acr"

  workload       = var.workload
  environment    = var.environment

  registry = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    vault         = module.kv.vault.id
    sku           = "Premium"

    scope_maps = {
      prod = {
        token_expiry = "2024-03-22T17:57:36+08:00"
        actions = [
          "repositories/repo1/content/read",
          "repositories/repo1/content/write"
        ]
      }
    }
  }
  depends_on = [module.rg, module.kv]
}
````

## Resources

| Name | Type |
| :-- | :-- |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_container_registry_scope_map](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry_scope_map) | resource |
| [azurerm_container_registry_token](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry_token) | resource |
| [azurerm_container_registry_token_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry_token_password) | resource |
| [azurerm_key_vault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `registry` | describes container registry related configuration | object | yes |
| `workload` | contains the workload name used, for naming convention	| string | yes |
| `environment` | contains shortname of the environment used for naming convention	| string | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `acr` | contains all container registry config |

## Testing

This GitHub repository features a [Makefile](./Makefile) tailored for testing various configurations. Each test target corresponds to different example use cases provided within the repository.

Before running these tests, ensure that both Go and Terraform are installed on your system. To execute a specific test, use the following command ```make <test-target>```

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/az-cn-module-tf-acr/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/az-cn-module-tf-acr/blob/main/LICENSE) for full details.

## Reference

- [Documentation](https://learn.microsoft.com/en-us/azure/container-registry/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/containerregistry/)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/main/specification/containerregistry)

