output "id" {
  description = "The ID of the policy set definition"
  value       = azurerm_management_group_policy_set_definition.this.id
}

output "name" {
  description = "The name of the policy set definition"
  value       = azurerm_management_group_policy_set_definition.this.name
}

output "display_name" {
  description = "The display name of the policy set definition"
  value       = azurerm_management_group_policy_set_definition.this.display_name
}
