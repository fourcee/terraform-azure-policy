# Complete Example

This example demonstrates how to use all three Azure Policy modules together to create a complete policy governance solution.

## What This Example Does

1. **Creates two policy definitions:**
   - `require-environment-tag`: Denies resources without an Environment tag
   - `audit-vm-sizes`: Audits virtual machines not using approved sizes

2. **Creates a policy set (initiative):**
   - Groups both policy definitions into a governance initiative

3. **Creates multiple policy assignments:**
   - Assigns the policy set to management groups
   - Assigns individual policies to subscriptions
   - Demonstrates audit mode with enforcement disabled

## Usage

1. Update the management group IDs and subscription IDs in `main.tf` to match your Azure environment.

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the planned changes:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

## Prerequisites

- Azure CLI authenticated with sufficient permissions
- Terraform >= 1.0 installed
- Permissions to create and assign policies in Azure

## Customization

You can customize this example by:
- Modifying the policy rules in the policy definitions
- Adding more policies to the initiative
- Changing the assignment scopes
- Adjusting enforcement modes
- Adding metadata and parameters

## Clean Up

To remove all resources:
```bash
terraform destroy
```

## Notes

- Policy assignments may take a few minutes to become effective
- Some policies require a compliance scan to show results
- Management group IDs should be in the format: `/providers/Microsoft.Management/managementGroups/{name}`
- Subscription IDs should be just the GUID, not the full path
