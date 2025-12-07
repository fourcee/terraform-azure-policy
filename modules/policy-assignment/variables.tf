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
  description = "The type of identity to use for the policy assignment (SystemAssigned, UserAssigned, or None)"
  type        = string
  default     = null
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
}

variable "not_scopes" {
  description = "List of scopes to exclude from the policy assignment"
  type        = list(string)
  default     = []
}
