# Example: Create policy assignments with exemptions
module "policy_assignment_with_exemptions" {
  source = "../../modules/policy-assignment"

  name        = "require-tags-with-exemptions"
  description = "Assign tag requirement policy to subscriptions with exemptions"
  
  # This would be the ID of an existing policy definition or policy set
  policy_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"

  # Assign to specific subscriptions
  subscription_ids = [
    "00000000-0000-0000-0000-000000000001",
    "00000000-0000-0000-0000-000000000002"
  ]

  # Create exemptions for specific scopes
  exemptions = [
    # Management group exemption
    {
      scope              = "/providers/Microsoft.Management/managementGroups/exempt-mg"
      name               = "mg-waiver-example"
      exemption_category = "Waiver"
      display_name       = "Management Group Waiver"
      description        = "Temporary waiver for pilot management group during migration"
      expires_on         = "2025-12-31T23:59:59Z"
    },
    # Subscription exemption
    {
      scope              = "/subscriptions/00000000-0000-0000-0000-000000000003"
      name               = "sub-mitigated-example"
      exemption_category = "Mitigated"
      display_name       = "Subscription Exemption - Alternative Controls"
      description        = "Risk mitigated through alternative tagging mechanism"
    },
    # Resource group exemption
    {
      scope              = "/subscriptions/00000000-0000-0000-0000-000000000001/resourceGroups/legacy-rg"
      name               = "rg-legacy-waiver"
      exemption_category = "Waiver"
      display_name       = "Legacy Resource Group Exemption"
      description        = "Exemption for legacy resource group during decommissioning"
      expires_on         = "2026-06-30T23:59:59Z"
    }
  ]
}

# Output all exemption IDs
output "exemption_ids" {
  value = module.policy_assignment_with_exemptions.all_exemption_ids
}

# Output exemptions by type
output "management_group_exemptions" {
  value = module.policy_assignment_with_exemptions.management_group_exemption_ids
}

output "subscription_exemptions" {
  value = module.policy_assignment_with_exemptions.subscription_exemption_ids
}

output "resource_group_exemptions" {
  value = module.policy_assignment_with_exemptions.resource_group_exemption_ids
}
