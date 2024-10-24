output "server_groups" {
  value       = local.server_groups
  description = "Zscaler server group map(name->id)"
}

output "segment_groups" {
  value       = local.segment_groups
  description = "Zscaler segment group map(name->id)"
}

output "application_segments" {
  value       = local.application_segment
  description = "Zscaler applications segment map(name->id)"
}

output "client_forwarding_policy_id" {
  value       = local.client_forwarding_policy_id
  description = "Get the policy set for the specific policy type"
}

output "idps" {
  value       = local.idps
  description = "Zscaler configured idPs(name->id)"
}

output "scim_groups" {
  value       = local.scim_groups
  description = "Zscaler SCIM Groups(name->id)"
}

output "scim_attributes" {
  value       = local.scim_attributes
  description = "Zscaler SCIM Attributes(name->id)"
}

output "certificate" {
  value       = local.certificates
  description = "Zscaler certificates(name->id)"
}

output "app_connector_groups" {
  value       = local.app_connector_groups
  description = "Zscaler app connector groups(name->id)"
}

output "servers" {
  value       = local.servers
  description = "Zscaler servers(name->id)"
}
