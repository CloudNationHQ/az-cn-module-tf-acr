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
}

module "acr" {
  source = "../../"

  workload    = var.workload
  environment = var.environment

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
}
