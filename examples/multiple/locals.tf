locals {
  registries = {
    acr1 = {
      name          = join("", [module.naming.container_registry.name, "001"])
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
      sku           = "Premium"
    },
    acr2 = {
      name          = join("", [module.naming.container_registry.name, "002"])
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name
      sku           = "Premium"

      replications = {
        sea = { location = "southeastasia" }
        eus = { location = "eastus" }
      }
    }
  }
}
