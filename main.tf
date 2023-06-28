# generate random id
resource "random_string" "random" {
  length    = 3
  min_lower = 3
  special   = false
  numeric   = false
  upper     = false
}

# user managed identity
resource "azurerm_user_assigned_identity" "mi" {
  for_each = try(var.registry.encryption.enable, false) == true ? { "mi" : true } : {}

  name                = "mi-encr-${var.workload}-${var.environment}"
  resource_group_name = var.registry.resourcegroup
  location            = var.registry.location
}

# role assignment
resource "azurerm_role_assignment" "rol" {
  for_each = try(var.registry.encryption.enable, false) == true ? { "mi" : true } : {}

  scope                = var.registry.encryption.role_assignment_scope
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azurerm_user_assigned_identity.mi[each.key].principal_id
}

# container registry
resource "azurerm_container_registry" "acr" {
  name                = "acr${var.workload}${var.environment}${random_string.random.result}"
  resource_group_name = var.registry.resourcegroup
  location            = var.registry.location

  sku                        = try(var.registry.sku, "Standard")
  admin_enabled              = try(var.registry.enable.admin, false)
  quarantine_policy_enabled  = try(var.registry.enable.quarantine_policy, false)
  network_rule_bypass_option = try(var.registry.network_rule_bypass, "AzureServices")

  anonymous_pull_enabled = (
    var.registry.sku == "Standard" ||
    var.registry.sku == "Premium" ?
    try(var.registry.enable.anonymous_pull, false)
    : false
  )

  data_endpoint_enabled = (
    var.registry == "Premium" ?
    try(var.registry.enable.data_endpoint, false)
    : false
  )

  export_policy_enabled = (
    var.registry.sku == "Premium" &&
    try(var.registry.enable.public_network_access, true) == false ?
    try(var.registry.enable.export_policy, true)
    : true
  )

  public_network_access_enabled = (
    try(var.registry.enable.public_network_access, false)
  )

  dynamic "trust_policy" {
    for_each = var.registry.sku == "Premium" && try(var.registry.enable.trust_policy, false) == true ? [1] : []

    content {
      enabled = var.registry.enable.trust_policy
    }
  }

  dynamic "retention_policy" {
    for_each = var.registry.sku == "Premium" && try(var.registry.enable.retention_policy, false) == true ? [1] : []

    content {
      enabled = var.registry.enable.retention_policy
      days    = try(var.registry.retention_in_days, 90)
    }
  }

  identity {
    type = try(var.registry.encryption.enable, false) == true ? "UserAssigned" : "SystemAssigned"

    identity_ids = try([azurerm_user_assigned_identity.mi["mi"].id], [])
  }

  dynamic "georeplications" {
    for_each = {
      for repl in local.replications : repl.repl_key => repl
      if var.registry.sku == "Premium"
    }

    content {
      location                  = georeplications.value.location
      zone_redundancy_enabled   = georeplications.value.zone_redundancy_enabled
      regional_endpoint_enabled = georeplications.value.regional_endpoint_enable
    }
  }

  #can only be enabled at creation time
  dynamic "encryption" { w w w
    for_each = try(var.registry.encryption.enable, false) == true ? [1] : []

    content {
      enabled            = try(encryption.enable, true)
      key_vault_key_id   = var.registry.encryption.kv_key_id
      identity_client_id = azurerm_user_assigned_identity.mi["mi"].client_id
    }
  }

  depends_on = [
    azurerm_role_assignment.rol
  ]
}

# fine grained access control used for non human identities
# scope maps
resource "azurerm_container_registry_scope_map" "scope" {
  for_each = {
    for v in local.scope_maps : v.maps_key => v
  }

  name                    = each.value.name
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = var.registry.resourcegroup
  actions                 = each.value.actions
}

# tokens
resource "azurerm_container_registry_token" "token" {
  for_each = {
    for v in local.scope_maps : v.maps_key => v
  }

  name                    = each.value.token_name
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = var.registry.resourcegroup
  scope_map_id            = azurerm_container_registry_scope_map.scope[each.key].id
}

# token passwords
resource "azurerm_container_registry_token_password" "password" {
  for_each = {
    for v in local.scope_maps : v.maps_key => v
  }

  container_registry_token_id = azurerm_container_registry_token.token[each.key].id

  password1 {
    expiry = each.value.token_expiry
  }

  password2 {
    expiry = each.value.token_expiry
  }
}

# secrets
resource "azurerm_key_vault_secret" "secret1" {
  for_each = {
    for v in local.scope_maps : v.maps_key => v
  }

  name         = "${each.value.secret_name}-1"
  value        = azurerm_container_registry_token_password.password[each.key].password1[0].value
  key_vault_id = each.value.key_vault_id
}

resource "azurerm_key_vault_secret" "secret2" {
  for_each = {
    for v in local.scope_maps : v.maps_key => v
  }

  name         = "${each.value.secret_name}-2"
  value        = azurerm_container_registry_token_password.password[each.key].password2[0].value
  key_vault_id = each.value.key_vault_id
}