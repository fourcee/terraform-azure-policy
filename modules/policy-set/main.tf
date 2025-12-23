resource "azurerm_management_group_policy_set_definition" "this" {
  name                = var.name
  policy_type         = var.policy_type
  display_name        = var.display_name != null ? var.display_name : var.name
  description         = var.description
  management_group_id = var.management_group_id

  metadata   = var.metadata
  parameters = var.parameters

  # Use advanced_policy_references if provided, otherwise create simple references from policy_definition_ids
  dynamic "policy_definition_reference" {
    for_each = var.advanced_policy_references != null ? var.advanced_policy_references : [
      for id in var.policy_definition_ids : {
        policy_definition_id = id
        parameter_values     = null
        reference_id         = null
      }
    ]

    content {
      policy_definition_id = policy_definition_reference.value.policy_definition_id
      parameter_values     = policy_definition_reference.value.parameter_values
      reference_id         = policy_definition_reference.value.reference_id
    }
  }
}
