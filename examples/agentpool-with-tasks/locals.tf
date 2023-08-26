locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "route_table", "user_assigned_identity", "private_endpoint"]
}

locals {
  # aliased subscription private dns zones
  private_dns_zones = {
    subscription  = "55536141-531c-4231-835a-024d32efd345"
    resourcegroup = "rg-network-shared-001"
  }
}
