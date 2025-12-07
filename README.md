# terraform-azure-policy

Azure Policy Terraform Modules for managing Azure Policy Definitions, Policy Sets (Initiatives), and Policy Assignments.

## Modules

This repository contains three Terraform modules for managing Azure Policies:

### 1. policy-definition

Creates an Azure Policy Definition.

**Usage:**
```hcl
module "policy_definition" {
  source = "./modules/policy-definition"

  name        = "my-policy-definition"
  description = "This policy enforces specific requirements"
  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Compute/virtualMachines"
        }
      ]
    }
    then = {
      effect = "audit"
    }
  })
}
```

[See full documentation](./modules/policy-definition/README.md)

### 2. policy-set

Creates an Azure Policy Set Definition (Initiative) that groups multiple policy definitions together.

**Usage:**
```hcl
module "policy_set" {
  source = "./modules/policy-set"

  name        = "my-policy-set"
  description = "This policy set groups multiple policies together"
  policy_definition_ids = [
    module.policy_definition.id,
    "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/policyDefinitions/another-policy"
  ]
}
```

[See full documentation](./modules/policy-set/README.md)

### 3. policy-assignment

Assigns an Azure Policy Definition or Policy Set Definition to one or more Management Groups or Subscriptions.

**Usage:**
```hcl
module "policy_assignment" {
  source = "./modules/policy-assignment"

  name       = "my-policy-assignment"
  policy_id  = module.policy_set.id
  
  management_group_ids = [
    "/providers/Microsoft.Management/managementGroups/my-mg"
  ]
  
  subscription_ids = [
    "00000000-0000-0000-0000-000000000001",
    "00000000-0000-0000-0000-000000000002"
  ]
}
```

[See full documentation](./modules/policy-assignment/README.md)

## Complete Example

Here's a complete example that creates a policy definition, groups it into a policy set, and assigns it:

```hcl
# Create a policy definition
module "require_tag_policy" {
  source = "./modules/policy-definition"

  name        = "require-tag-on-resources"
  description = "Requires a specific tag on all resources"
  policy_rule = jsonencode({
    if = {
      field = "tags['Environment']"
      exists = "false"
    }
    then = {
      effect = "deny"
    }
  })
}

# Create a policy set with multiple policies
module "governance_policy_set" {
  source = "./modules/policy-set"

  name        = "governance-policies"
  description = "Set of governance policies for the organization"
  policy_definition_ids = [
    module.require_tag_policy.id
  ]
}

# Assign the policy set to management groups and subscriptions
module "governance_assignment" {
  source = "./modules/policy-assignment"

  name       = "governance-policy-assignment"
  policy_id  = module.governance_policy_set.id
  
  management_group_ids = [
    "/providers/Microsoft.Management/managementGroups/production"
  ]
}
```

## Requirements

- Terraform >= 1.0
- Azure Provider >= 3.0

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
