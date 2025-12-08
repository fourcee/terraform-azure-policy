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

  # Categorize exemptions by scope type
  exemptions_by_type = {
    for idx, exemption in var.exemptions : "${exemption.name}-${idx}" => merge(exemption, {
      scope_type = (
        startswith(exemption.scope, "/providers/Microsoft.Management/managementGroups/") ? "management_group" :
        startswith(exemption.scope, "/subscriptions/") && length(split("/", exemption.scope)) == 3 ? "subscription" :
        startswith(exemption.scope, "/subscriptions/") && contains(split("/", exemption.scope), "resourceGroups") ? "resource_group" :
        "unknown"
      )
      # Extract subscription ID from resource group or subscription scope
      extracted_subscription_id = (
        startswith(exemption.scope, "/subscriptions/") ? 
        split("/", exemption.scope)[2] : null
      )
    })
  }

  # Get all assignment IDs for dependency references
  all_assignment_ids = concat(
    [for v in azurerm_management_group_policy_assignment.this : v.id],
    [for v in azurerm_subscription_policy_assignment.this : v.id]
  )
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
  subscription_id      = replace(each.value.scope, "/subscriptions/", "")
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

# Management Group Policy Exemptions
resource "azurerm_management_group_policy_exemption" "this" {
  for_each = {
    for k, v in local.exemptions_by_type : k => v if v.scope_type == "management_group"
  }

  name                = each.value.name
  management_group_id = each.value.scope
  policy_assignment_id = (
    each.value.policy_assignment_id != null ? each.value.policy_assignment_id :
    length(local.all_assignment_ids) > 0 ? local.all_assignment_ids[0] : null
  )
  exemption_category              = each.value.exemption_category
  display_name                    = each.value.display_name
  description                     = each.value.description
  expires_on                      = each.value.expires_on
  policy_definition_reference_ids = each.value.policy_definition_reference_ids
  metadata                        = each.value.metadata

  depends_on = [
    azurerm_management_group_policy_assignment.this,
    azurerm_subscription_policy_assignment.this
  ]
}

# Subscription Policy Exemptions
resource "azurerm_subscription_policy_exemption" "this" {
  for_each = {
    for k, v in local.exemptions_by_type : k => v if v.scope_type == "subscription"
  }

  name            = each.value.name
  subscription_id = each.value.scope
  policy_assignment_id = (
    each.value.policy_assignment_id != null ? each.value.policy_assignment_id :
    each.value.extracted_subscription_id != null && contains(keys(azurerm_subscription_policy_assignment.this), each.value.extracted_subscription_id) ?
    azurerm_subscription_policy_assignment.this[each.value.extracted_subscription_id].id :
    length(local.all_assignment_ids) > 0 ? local.all_assignment_ids[0] : null
  )
  exemption_category              = each.value.exemption_category
  display_name                    = each.value.display_name
  description                     = each.value.description
  expires_on                      = each.value.expires_on
  policy_definition_reference_ids = each.value.policy_definition_reference_ids
  metadata                        = each.value.metadata

  depends_on = [
    azurerm_management_group_policy_assignment.this,
    azurerm_subscription_policy_assignment.this
  ]
}

# Resource Group Policy Exemptions
resource "azurerm_resource_group_policy_exemption" "this" {
  for_each = {
    for k, v in local.exemptions_by_type : k => v if v.scope_type == "resource_group"
  }

  name              = each.value.name
  resource_group_id = each.value.scope
  policy_assignment_id = (
    each.value.policy_assignment_id != null ? each.value.policy_assignment_id :
    each.value.extracted_subscription_id != null && contains(keys(azurerm_subscription_policy_assignment.this), each.value.extracted_subscription_id) ?
    azurerm_subscription_policy_assignment.this[each.value.extracted_subscription_id].id :
    length(local.all_assignment_ids) > 0 ? local.all_assignment_ids[0] : null
  )
  exemption_category              = each.value.exemption_category
  display_name                    = each.value.display_name
  description                     = each.value.description
  expires_on                      = each.value.expires_on
  policy_definition_reference_ids = each.value.policy_definition_reference_ids
  metadata                        = each.value.metadata

  depends_on = [
    azurerm_management_group_policy_assignment.this,
    azurerm_subscription_policy_assignment.this
  ]
}
