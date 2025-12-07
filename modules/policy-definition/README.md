# Policy Definition Module

This module creates an Azure Policy Definition.

## Usage

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

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the policy definition | `string` | n/a | yes |
| description | The description of the policy definition | `string` | n/a | yes |
| policy_rule | The policy rule JSON | `string` | n/a | yes |
| display_name | The display name of the policy definition (defaults to name if not specified) | `string` | `null` | no |
| mode | The policy mode (All, Indexed, etc.) | `string` | `"All"` | no |
| metadata | The metadata for the policy definition | `string` | `null` | no |
| parameters | Parameters for the policy definition | `string` | `null` | no |
| management_group_id | The management group ID where the policy definition will be created (optional) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the policy definition |
| name | The name of the policy definition |
| display_name | The display name of the policy definition |
