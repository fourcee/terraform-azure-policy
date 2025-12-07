# Policy Assignment Module

This module assigns an Azure Policy Definition or Policy Set Definition to one or more Management Groups or Subscriptions.

## Usage

### Assign to Management Groups

```hcl
module "policy_assignment" {
  source = "./modules/policy-assignment"

  name       = "my-policy-assignment"
  policy_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/policyDefinitions/my-policy"
  
  management_group_ids = [
    "/providers/Microsoft.Management/managementGroups/mg1",
    "/providers/Microsoft.Management/managementGroups/mg2"
  ]
}
```

### Assign to Subscriptions

```hcl
module "policy_assignment" {
  source = "./modules/policy-assignment"

  name       = "my-policy-assignment"
  policy_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/policyDefinitions/my-policy"
  
  subscription_ids = [
    "00000000-0000-0000-0000-000000000001",
    "00000000-0000-0000-0000-000000000002"
  ]
}
```

### Assign to Both

```hcl
module "policy_assignment" {
  source = "./modules/policy-assignment"

  name       = "my-policy-assignment"
  policy_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/policyDefinitions/my-policy"
  
  management_group_ids = [
    "/providers/Microsoft.Management/managementGroups/mg1"
  ]
  
  subscription_ids = [
    "00000000-0000-0000-0000-000000000001"
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| policy_id | The ID of the policy definition or policy set definition to assign | `string` | n/a | yes |
| name | The name of the policy assignment | `string` | n/a | yes |
| display_name | The display name of the policy assignment (defaults to name if not specified) | `string` | `null` | no |
| description | The description of the policy assignment | `string` | `null` | no |
| management_group_ids | List of management group IDs to assign the policy to | `list(string)` | `[]` | no |
| subscription_ids | List of subscription IDs to assign the policy to | `list(string)` | `[]` | no |
| location | The location for the policy assignment (required if using managed identity) | `string` | `null` | no |
| identity_type | The type of identity to use for the policy assignment (SystemAssigned, UserAssigned, or None) | `string` | `null` | no |
| parameters | Parameters for the policy assignment | `string` | `null` | no |
| metadata | The metadata for the policy assignment | `string` | `null` | no |
| enforcement_mode | The enforcement mode for the policy assignment (Default or DoNotEnforce) | `string` | `"Default"` | no |
| not_scopes | List of scopes to exclude from the policy assignment | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| management_group_assignment_ids | Map of management group IDs to their policy assignment IDs |
| subscription_assignment_ids | Map of subscription IDs to their policy assignment IDs |
| all_assignment_ids | List of all policy assignment IDs |
