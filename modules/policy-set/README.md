# Policy Set Module

This module creates an Azure Policy Set Definition (Initiative).

## Usage

```hcl
module "policy_set" {
  source = "./modules/policy-set"

  name        = "my-policy-set"
  description = "This policy set groups multiple policies together"
  policy_definition_ids = [
    "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/policyDefinitions/policy1",
    "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/policyDefinitions/policy2"
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
| name | The name of the policy set definition | `string` | n/a | yes |
| description | The description of the policy set definition | `string` | n/a | yes |
| policy_definition_ids | List of policy definition IDs to include in the policy set | `list(string)` | n/a | yes |
| display_name | The display name of the policy set definition (defaults to name if not specified) | `string` | `null` | no |
| policy_type | The policy set type (Custom, BuiltIn, etc.) | `string` | `"Custom"` | no |
| metadata | The metadata for the policy set definition | `string` | `null` | no |
| parameters | Parameters for the policy set definition | `string` | `null` | no |
| management_group_id | The management group ID where the policy set definition will be created (optional) | `string` | `null` | no |
| advanced_policy_references | Optional list of policy definition references with parameters. If provided, this takes precedence over policy_definition_ids | `list(object)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the policy set definition |
| name | The name of the policy set definition |
| display_name | The display name of the policy set definition |
