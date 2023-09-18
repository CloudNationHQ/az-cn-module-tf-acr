provider "azurerm" {
  features {}
}

module "naming" {
  source = "github.com/cloudnationhq/az-cn-module-tf-naming"

  suffix = ["demo", "dev"]
}

module "rg" {
  source = "github.com/cloudnationhq/az-cn-module-tf-rg"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

module "kv" {
  source = "github.com/cloudnationhq/az-cn-module-tf-kv"

  naming = local.naming

  vault = {
    name          = module.naming.key_vault.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    keys = {
      demo = {
        key_type = "RSA"
        key_size = 2048

        key_opts = [
          "decrypt", "encrypt",
          "sign", "unwrapKey",
          "verify", "wrapKey"
        ]
      }
    }
  }
}

module "registry" {
  source = "../../"

  naming = local.naming

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

    encryption = {
      enable                = true
      kv_key_id             = module.kv.kv_keys.demo.id
      role_assignment_scope = module.kv.vault.id
    }

    replications = {
      sea = { location = "southeastasia" }
      eus = { location = "eastus" }
    }
  }
}
