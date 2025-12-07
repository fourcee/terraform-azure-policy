output "management_group_assignment_ids" {
  description = "Map of management group IDs to their policy assignment IDs"
  value = {
    for k, v in azurerm_management_group_policy_assignment.this : k => v.id
  }
}

output "subscription_assignment_ids" {
  description = "Map of subscription IDs to their policy assignment IDs"
  value = {
    for k, v in azurerm_subscription_policy_assignment.this : k => v.id
  }
}

output "all_assignment_ids" {
  description = "List of all policy assignment IDs"
  value = concat(
    [for v in azurerm_management_group_policy_assignment.this : v.id],
    [for v in azurerm_subscription_policy_assignment.this : v.id]
  )
}
