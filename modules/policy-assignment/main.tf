locals {
  # Create a map for management group assignments
  mg_assignments = {
    for mg_id in var.management_group_ids : mg_id => {
      scope = mg_id
      type  = "management_group"
    }
  }

  # Create a map for subscription assignments
  sub_assignments = {
    for sub_id in var.subscription_ids : sub_id => {
      scope = "/subscriptions/${sub_id}"
      type  = "subscription"
    }
  }

  # Combine both maps
  all_assignments = merge(local.mg_assignments, local.sub_assignments)
}

# Management Group Policy Assignments
resource "azurerm_management_group_policy_assignment" "this" {
  for_each = {
    for k, v in local.all_assignments : k => v if v.type == "management_group"
  }

  name                 = var.name
  management_group_id  = each.value.scope
  policy_definition_id = var.policy_id
  display_name         = var.display_name != null ? var.display_name : var.name
  description          = var.description
  location             = var.location
  parameters           = var.parameters
  metadata             = var.metadata
  enforce              = var.enforcement_mode == "Default" ? true : false
  not_scopes           = var.not_scopes

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type = var.identity_type
    }
  }
}

# Subscription Policy Assignments
resource "azurerm_subscription_policy_assignment" "this" {
  for_each = {
    for k, v in local.all_assignments : k => v if v.type == "subscription"
  }

  name                 = var.name
  subscription_id      = each.value.scope
  policy_definition_id = var.policy_id
  display_name         = var.display_name != null ? var.display_name : var.name
  description          = var.description
  location             = var.location
  parameters           = var.parameters
  metadata             = var.metadata
  enforce              = var.enforcement_mode == "Default" ? true : false
  not_scopes           = var.not_scopes

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type = var.identity_type
    }
  }
}
