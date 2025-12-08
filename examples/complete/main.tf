terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Example 1: Create a policy definition that requires a specific tag
module "require_environment_tag" {
  source = "../../modules/policy-definition"

  name        = "require-environment-tag"
  description = "Requires all resources to have an Environment tag"
  policy_rule = jsonencode({
    if = {
      field  = "tags['Environment']"
      exists = "false"
    }
    then = {
      effect = "deny"
    }
  })
}

# Example 2: Create another policy definition that audits virtual machines
module "audit_vm_sizes" {
  source = "../../modules/policy-definition"

  name        = "audit-vm-sizes"
  description = "Audits virtual machines that don't use approved sizes"
  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Compute/virtualMachines"
        },
        {
          not = {
            field = "Microsoft.Compute/virtualMachines/sku.name"
            in = [
              "Standard_B2s",
              "Standard_D2s_v3",
              "Standard_D4s_v3"
            ]
          }
        }
      ]
    }
    then = {
      effect = "audit"
    }
  })
}

# Example 3: Create a policy set that groups the policies together
module "governance_initiative" {
  source = "../../modules/policy-set"

  name        = "governance-initiative"
  description = "Governance policies for the organization"
  policy_definition_ids = [
    module.require_environment_tag.id,
    module.audit_vm_sizes.id
  ]
}

# Example 4: Assign the policy set to management groups
module "mg_assignment" {
  source = "../../modules/policy-assignment"

  name        = "governance-mg-assignment"
  description = "Governance policy assignment for management groups"
  policy_id   = module.governance_initiative.id

  management_group_ids = [
    "/providers/Microsoft.Management/managementGroups/production",
    "/providers/Microsoft.Management/managementGroups/development"
  ]
}

# Example 5: Assign a single policy to subscriptions
module "sub_assignment" {
  source = "../../modules/policy-assignment"

  name        = "tag-requirement-sub-assignment"
  description = "Tag requirement policy for specific subscriptions"
  policy_id   = module.require_environment_tag.id

  subscription_ids = [
    "00000000-0000-0000-0000-000000000001",
    "00000000-0000-0000-0000-000000000002"
  ]
}

# Example 6: Assign with enforcement disabled (audit mode)
module "audit_assignment" {
  source = "../../modules/policy-assignment"

  name             = "governance-audit-assignment"
  description      = "Governance policy in audit mode"
  policy_id        = module.governance_initiative.id
  enforcement_mode = "DoNotEnforce"

  subscription_ids = [
    "00000000-0000-0000-0000-000000000003"
  ]
}

# Example 7: Assign with policy exemptions
module "assignment_with_exemptions" {
  source = "../../modules/policy-assignment"

  name        = "governance-with-exemptions"
  description = "Governance policy with exemptions for specific scopes"
  policy_id   = module.governance_initiative.id

  subscription_ids = [
    "00000000-0000-0000-0000-000000000004"
  ]

  # Create exemptions for specific scopes
  exemptions = [
    {
      scope              = "/subscriptions/00000000-0000-0000-0000-000000000005"
      name               = "dev-subscription-waiver"
      exemption_category = "Waiver"
      display_name       = "Development Subscription Waiver"
      description        = "Temporary waiver for development subscription during testing phase"
      expires_on         = "2025-12-31T23:59:59Z"
    },
    {
      scope              = "/subscriptions/00000000-0000-0000-0000-000000000004/resourceGroups/sandbox-rg"
      name               = "sandbox-rg-exemption"
      exemption_category = "Mitigated"
      display_name       = "Sandbox Resource Group Exemption"
      description        = "Risk mitigated through isolated network configuration"
    }
  ]
}
