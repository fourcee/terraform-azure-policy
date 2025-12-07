output "policy_definition_ids" {
  description = "The IDs of the created policy definitions"
  value = {
    require_environment_tag = module.require_environment_tag.id
    audit_vm_sizes          = module.audit_vm_sizes.id
  }
}

output "policy_set_id" {
  description = "The ID of the policy set definition"
  value       = module.governance_initiative.id
}

output "management_group_assignments" {
  description = "Management group policy assignment IDs"
  value       = module.mg_assignment.management_group_assignment_ids
}

output "subscription_assignments" {
  description = "Subscription policy assignment IDs"
  value = {
    tag_requirement = module.sub_assignment.subscription_assignment_ids
    audit_mode      = module.audit_assignment.subscription_assignment_ids
  }
}
