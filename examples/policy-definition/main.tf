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

# Simple example: Create a policy definition that requires tags
module "require_tags" {
  source = "../../modules/policy-definition"

  name        = "require-cost-center-tag"
  description = "Requires all resources to have a CostCenter tag"
  policy_rule = jsonencode({
    if = {
      field  = "tags['CostCenter']"
      exists = "false"
    }
    then = {
      effect = "deny"
    }
  })
}

output "policy_id" {
  value = module.require_tags.id
}
