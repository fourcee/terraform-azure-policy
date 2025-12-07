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

# Simple example: Assign an existing policy to subscriptions
module "policy_assignment" {
  source = "../../modules/policy-assignment"

  name        = "require-tags-assignment"
  description = "Assign tag requirement policy to subscriptions"
  
  # This would be the ID of an existing policy definition or policy set
  policy_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"

  # Assign to specific subscriptions
  subscription_ids = [
    "00000000-0000-0000-0000-000000000001"
  ]
}

output "assignment_ids" {
  value = module.policy_assignment.all_assignment_ids
}
