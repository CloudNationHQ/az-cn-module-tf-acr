locals {
  replications = flatten([
    for repl_key, repl in try(var.registry.replications, {}) : {

      repl_key                 = repl_key
      location                 = repl.location
      zone_redundancy_enabled  = try(repl.enable_zone_redundancy, null)
      regional_endpoint_enable = try(repl.regional_endpoint_enabled, null)
    }
  ])
}

locals {
  scope_maps = flatten([
    for maps_key, m in try(var.registry.scope_maps, {}) : {

      maps_key     = maps_key
      name         = "scope-${maps_key}"
      actions      = m.actions
      token_name   = "token-${maps_key}"
      token_expiry = try(m.token_expiry, null)
      secret_name  = "secret-${maps_key}"
      key_vault_id = try(var.registry.vault, null)
    }
  ])
}

locals {
  pools = {
    for pool_key, pool in var.registry.agentpools : pool_key => {
      name           = pool_key
      instance_count = try(pool.instances, 1)
      tier           = try(pool.tier, "S2")
      tasks          = try(pool.tasks, {})
    }
  }
}
