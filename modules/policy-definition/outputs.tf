output "id" {
  description = "The ID of the policy definition"
  value       = azurerm_policy_definition.this.id
}

output "name" {
  description = "The name of the policy definition"
  value       = azurerm_policy_definition.this.name
}

output "display_name" {
  description = "The display name of the policy definition"
  value       = azurerm_policy_definition.this.display_name
}
