# Policy Set Example

This example demonstrates how to create an Azure Policy Set (Initiative) that groups multiple policy definitions together.

## Usage

Update the `policy_definition_ids` list with the IDs of your existing policy definitions, then:

```bash
terraform init
terraform plan
terraform apply
```

## Outputs

- `policy_set_id` - The ID of the created policy set definition
