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

module "acr" {
  source = "../../"

  workload    = var.workload
  environment = var.environment

  registry = {
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    sku           = "Premium"

    replications = {
      sea  = { location = "southeastasia" }
      eus  = { location = "eastus" }
      eus2 = { location = "eastus2", regional_endpoint_enabled = true }
    }
  }
  depends_on = [module.rg]
}
