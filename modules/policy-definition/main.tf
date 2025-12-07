resource "azurerm_policy_definition" "this" {
  name                = var.name
  policy_type         = "Custom"
  mode                = var.mode
  display_name        = var.display_name != null ? var.display_name : var.name
  description         = var.description
  management_group_id = var.management_group_id

  metadata    = var.metadata
  parameters  = var.parameters
  policy_rule = var.policy_rule
}
