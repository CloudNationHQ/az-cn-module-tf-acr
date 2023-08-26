locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "route_table", "private_endpoint"]
}

locals {
  # aliased subscription private dns zones
  centralized_dns_zone = {
    subscription  = "00000000-0000-0000-0000-000000000000"
    resourcegroup = "rg-network-shared-001"
  }
}
