# Container registry

This terraform module automates the creation of container registry resources on the azure cloud platform, enabling easier deployment and management of container images.

## Goals

The main objective is to create a more logic data structure, achieved by combining and grouping related resources together in a complex object.

The structure of the module promotes reusability. It's intended to be a repeatable component, simplifying the process of building diverse workloads and platform accelerators consistently.

A primary goal is to utilize keys and values in the object that correspond to the REST API's structure. This enables us to carry out iterations, increasing its practical value as time goes on.

A last key goal is to separate logic from configuration in the module, thereby enhancing its scalability, ease of customization, and manageability.

## Features

- data replication is possible across different geolocations
- detailed access control is ensured through the use of scope maps
- data protection is enhanced by encryption for data at rest
- utilization of terratest for robust validation.
- supports enhanced scalability and isolation through dedicated agent pools
- flexibility to deploy multiple tasks using agent pools
- private endpoint support using either centralized or decentralized private DNS zones

The below examples shows the usage when consuming the module:

## Usage: simple

```hcl
module "acr" {
  source = "github.com/cloudnationhq/az-cn-module-tf-acr"

  registry = {
    name          = module.naming.container_registry.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    sku           = "Premium"
  }
}
```

## Usage: replications

```hcl
module "acr" {
  source = "github.com/cloudnationhq/az-cn-module-tf-acr"

  registry = {
    name          = module.naming.container_registry.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    sku           = "Premium"

    replications = {
      sea  = { location = "southeastasia" }
      eus  = { location = "eastus" }
      eus2 = { location = "eastus2", regional_endpoint_enabled = true }
    }
  }
}
```

## Usage: encryption

```hcl
module "acr" {
  source = "github.com/cloudnationhq/az-cn-module-tf-acr"

  registry = {
    name          = module.naming.container_registry.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    sku           = "Premium"

    encryption = {
      enable                = true
      kv_key_id             = module.kv.kv_keys.exkdp.id
      role_assignment_scope = module.kv.vault.id
    }
  }
}
```

## Usage scope maps

```hcl
module "acr" {
  source = "github.com/cloudnationhq/az-cn-module-tf-acr"

  registry = {
    name          = module.naming.container_registry.name_unique
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
}
````

## Usage: agent pool tasks

```hcl
module "acr" {
  source = "github.com/cloudnationhq/az-cn-module-tf-acr"

  naming = local.naming

  registry = {
    name          = module.naming.container_registry.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    sku           = "Premium"

    private_endpoint = {
      vnet                     = module.network.vnet.id
      subnet                   = module.network.subnets.plink.id
      subscription             = local.centralized_dns_zone.subscription
      resourcegroup            = local.centralized_dns_zone.resourcegroup
      use_centralized_dns_zone = true
    }

    agentpools = {
      demo = {
        instances = 2
        subnet    = module.network.subnets.demo.id
        tasks = {
          demo1 = {
            access_token    = var.pat
            repository_url  = "https://github.com/cloudnationhq/az-cn-module-tf-acr.git"
            context_path    = "https://github.com/cloudnationhq/az-cn-module-tf-acr#main"
            dockerfile_path = ".azdo/Dockerfile"
            image_names     = ["azdoagent:latest"]
            source_events   = ["commit"]
          }
        }
      }
    }
  }
}
```

## Usage: private endpoint

```hcl
module "acr" {
  source = "github.com/cloudnationhq/az-cn-module-tf-acr"

  naming = local.naming

  registry = {
    name          = module.naming.container_registry.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    sku           = "Premium"

    private_endpoint = {
      vnet                     = module.network.vnet.id
      subnet                   = module.network.subnets.plink.id
      use_centralized_dns_zone = false
    }
  }
}
```

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
| [azurerm_container_registry_agent_pool](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry_agent_pool) | resource |
| [azurerm_container_registry_task](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry_task) | resource |
| [azurerm_private_dns_zone_virtual_network_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `registry` | describes container registry related configuration | object | yes |
| `naming` | contains the naming convention	| string | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `acr` | contains all container registry config |

## Testing

The github repository utilizes a Makefile to conduct tests to evaluate and validate different configurations of the module. These tests are designed to enhance its stability and reliability.

Before initiating the tests, please ensure that both go and terraform are properly installed on your system.

The [Makefile](Makefile) incorporates three distinct test variations. The first one, a local deployment test, is designed for local deployments and allows the overriding of workload and environment values. It includes additional checks and can be initiated using the command ```make test_local```.

The second variation is an extended test. This test performs additional validations and serves as the default test for the module within the github workflow.

The third variation allows for specific deployment tests. By providing a unique test name in the github workflow, it overrides the default extended test, executing the specific deployment test instead.

Each of these tests contributes to the robustness and resilience of the module. They ensure the module performs consistently and accurately under different scenarios and configurations.

## Notes

For agent pool tasks, a personal access token with the repo scope is required

The configuration is aligned with enterprise-scale principles, favoring centralized private dns zones in combination with private endpoints. Nonetheless, decentralization remains an option.

Naming convention of resources have been established to support the right abbreviations, regular expressions using a dedicated module. It supports multiple prefixes and suffixes as well to make it more flexible.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/az-cn-module-tf-acr/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/az-cn-module-tf-acr/blob/main/LICENSE) for full details.

## Reference

- [Documentation](https://learn.microsoft.com/en-us/azure/container-registry/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/containerregistry/)
- [Rest Api Specs](https://github.com/Azure/azure-rest-api-specs/tree/main/specification/containerregistry)
