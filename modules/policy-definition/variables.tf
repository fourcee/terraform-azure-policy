variable "name" {
  description = "The name of the policy definition"
  type        = string
}

variable "description" {
  description = "The description of the policy definition"
  type        = string
}

variable "policy_rule" {
  description = "The policy rule JSON"
  type        = string
}

variable "display_name" {
  description = "The display name of the policy definition (defaults to name if not specified)"
  type        = string
  default     = null
}

variable "mode" {
  description = "The policy mode (All, Indexed, etc.)"
  type        = string
  default     = "All"
}

variable "metadata" {
  description = "The metadata for the policy definition"
  type        = string
  default     = null
}

variable "parameters" {
  description = "Parameters for the policy definition"
  type        = string
  default     = null
}

variable "management_group_id" {
  description = "The management group ID where the policy definition will be created (optional)"
  type        = string
  default     = null
}
