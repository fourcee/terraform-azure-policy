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

# Simple example: Create a policy set from existing policy definitions
module "security_policies" {
  source = "../../modules/policy-set"

  name        = "security-baseline"
  description = "Security baseline policies for the organization"
  
  # These would be IDs of existing policy definitions
  policy_definition_ids = [
    "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c", # Allowed locations
    "/providers/Microsoft.Authorization/policyDefinitions/0473574d-2d43-4217-aefe-941fcdf7e684"  # Storage account encryption
  ]
}

output "policy_set_id" {
  value = module.security_policies.id
}
