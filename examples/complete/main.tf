provider "azurerm" {
  features {}
}

module "rg" {
  source = "github.com/cloudnationhq/az-cn-module-tf-rg"

  environment = var.environment

  groups = {
    demo = {
      region = "westeurope"
    }
  }
}

module "kv" {
  source = "github.com/cloudnationhq/az-cn-module-tf-kv"

  workload    = var.workload
  environment = var.environment

  vault = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    keys = {
      exkdp = {
        key_type = "RSA"
        key_size = 2048
        key_opts = [
          "decrypt", "encrypt", "sign",
          "unwrapKey", "verify", "wrapKey"
        ]
      }
    }

    enable = {
      purge_protection = true
    }

    contacts = {
      demo = {
        email = "dummy@cloudnation.nl"
      }
    }
  }
  depends_on = [module.rg]
}

module "acr" {
  source = "../../"

  workload    = var.workload
  environment = var.environment

  registry = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.group.demo.name
    vault         = module.kv.vault.id
    sku           = "Premium"

    enable = {
      user_assigned_identity = false
    }

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
      kv_key_id             = module.kv.kv_keys.exkdp.id
      role_assignment_scope = module.kv.vault.id
    }

    replications = {
      sea = { location = "southeastasia" }
      eus = { location = "eastus" }
    }
  }
  depends_on = [module.rg]
}
