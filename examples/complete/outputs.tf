output "registry" {
  value     = module.registry.acr
  sensitive = true
}

output "subscriptionId" {
  value = module.registry.subscriptionId
}
