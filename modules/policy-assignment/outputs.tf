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

output "management_group_exemption_ids" {
  description = "Map of management group exemption keys to their exemption IDs"
  value = {
    for k, v in azurerm_management_group_policy_exemption.this : k => v.id
  }
}

output "subscription_exemption_ids" {
  description = "Map of subscription exemption keys to their exemption IDs"
  value = {
    for k, v in azurerm_subscription_policy_exemption.this : k => v.id
  }
}

output "resource_group_exemption_ids" {
  description = "Map of resource group exemption keys to their exemption IDs"
  value = {
    for k, v in azurerm_resource_group_policy_exemption.this : k => v.id
  }
}

output "all_exemption_ids" {
  description = "List of all policy exemption IDs"
  value = concat(
    [for v in azurerm_management_group_policy_exemption.this : v.id],
    [for v in azurerm_subscription_policy_exemption.this : v.id],
    [for v in azurerm_resource_group_policy_exemption.this : v.id]
  )
}
