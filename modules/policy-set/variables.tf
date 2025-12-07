variable "name" {
  description = "The name of the policy set definition"
  type        = string
}

variable "description" {
  description = "The description of the policy set definition"
  type        = string
}

variable "policy_definition_ids" {
  description = "List of policy definition IDs to include in the policy set"
  type        = list(string)
}

variable "display_name" {
  description = "The display name of the policy set definition (defaults to name if not specified)"
  type        = string
  default     = null
}

variable "policy_type" {
  description = "The policy set type (Custom, BuiltIn, etc.)"
  type        = string
  default     = "Custom"
}

variable "metadata" {
  description = "The metadata for the policy set definition"
  type        = string
  default     = null
}

variable "parameters" {
  description = "Parameters for the policy set definition"
  type        = string
  default     = null
}

variable "management_group_id" {
  description = "The management group ID where the policy set definition will be created (optional)"
  type        = string
  default     = null
}

variable "advanced_policy_references" {
  description = "Optional list of policy definition references with parameters. If provided, this takes precedence over policy_definition_ids"
  type = list(object({
    policy_definition_id = string
    parameter_values     = optional(string)
    reference_id         = optional(string)
  }))
  default = null
}
