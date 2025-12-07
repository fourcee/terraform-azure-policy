# Policy Assignment Example

This example demonstrates how to assign an Azure Policy to subscriptions.

## Usage

Update the `policy_id` and `subscription_ids` with your values, then:

```bash
terraform init
terraform plan
terraform apply
```

## Outputs

- `assignment_ids` - List of all created policy assignment IDs

## Notes

- For management group assignments, use `management_group_ids` instead of `subscription_ids`
- You can assign to both management groups and subscriptions in the same module call
- Use `enforcement_mode = "DoNotEnforce"` for audit-only mode
