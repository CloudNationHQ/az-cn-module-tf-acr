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

module "network" {
  source = "github.com/cloudnationhq/az-cn-module-tf-vnet"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    cidr          = ["10.25.0.0/16"]
    subnets = {
      demo  = { cidr = ["10.25.1.0/24"] }
      plink = { cidr = ["10.25.2.0/24"] }
    }
  }
}

module "acr" {
  source = "../../"

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
