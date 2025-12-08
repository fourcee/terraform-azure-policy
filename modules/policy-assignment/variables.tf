variable "policy_id" {
  description = "The ID of the policy definition or policy set definition to assign"
  type        = string
}

variable "name" {
  description = "The name of the policy assignment"
  type        = string
}

variable "display_name" {
  description = "The display name of the policy assignment (defaults to name if not specified)"
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the policy assignment"
  type        = string
  default     = null
}

variable "management_group_ids" {
  description = "List of management group IDs to assign the policy to"
  type        = list(string)
  default     = []
}

variable "subscription_ids" {
  description = "List of subscription IDs to assign the policy to"
  type        = list(string)
  default     = []
}

variable "location" {
  description = "The location for the policy assignment (required if using managed identity)"
  type        = string
  default     = null
}

variable "identity_type" {
  description = "The type of identity to use for the policy assignment (SystemAssigned or UserAssigned)"
  type        = string
  default     = null

  validation {
    condition     = var.identity_type == null || contains(["SystemAssigned", "UserAssigned"], var.identity_type)
    error_message = "identity_type must be either 'SystemAssigned' or 'UserAssigned'."
  }
}

variable "parameters" {
  description = "Parameters for the policy assignment"
  type        = string
  default     = null
}

variable "metadata" {
  description = "The metadata for the policy assignment"
  type        = string
  default     = null
}

variable "enforcement_mode" {
  description = "The enforcement mode for the policy assignment (Default or DoNotEnforce)"
  type        = string
  default     = "Default"

  validation {
    condition     = contains(["Default", "DoNotEnforce"], var.enforcement_mode)
    error_message = "enforcement_mode must be either 'Default' or 'DoNotEnforce'."
  }
}

variable "not_scopes" {
  description = "List of scopes to exclude from the policy assignment"
  type        = list(string)
  default     = []
}

variable "exemptions" {
  description = <<-EOT
    List of policy exemptions to create. Each exemption must specify:
    - scope: The scope ID (management group, subscription, or resource group)
    - name: A unique name for the exemption
    - exemption_category: Either 'Waiver' or 'Mitigated'
    - policy_assignment_id: (Optional) The policy assignment ID to exempt from. If not specified, uses the first assignment created by this module
    - display_name: (Optional) Display name for the exemption
    - description: (Optional) Description for the exemption
    - expires_on: (Optional) Expiration date in RFC3339 format
    - policy_definition_reference_ids: (Optional) List of policy definition reference IDs to exempt (for policy sets)
    - metadata: (Optional) JSON string of metadata
  EOT
  type = list(object({
    scope                           = string
    name                            = string
    exemption_category              = string
    policy_assignment_id            = optional(string)
    display_name                    = optional(string)
    description                     = optional(string)
    expires_on                      = optional(string)
    policy_definition_reference_ids = optional(list(string))
    metadata                        = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for e in var.exemptions : contains(["Waiver", "Mitigated"], e.exemption_category)
    ])
    error_message = "exemption_category must be either 'Waiver' or 'Mitigated'."
  }
}
