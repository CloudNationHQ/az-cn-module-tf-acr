locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "route_table", "user_assigned_identity", "private_endpoint"]
}

locals {
  # aliased subscription private dns zones
  centralized_dns_zone = {
    subscription  = "6b6b6146-591c-4251-855a-024df2efde45"
    resourcegroup = "rg-network-shared-001"
  }
}
