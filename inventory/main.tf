locals {
  server_groups_total_pages       = jsondecode(data.http.zscaler_get_server_groups_total_pages.response_body).totalPages
  server_groups_pages             = [for page in data.http.zscaler_get_server_groups : jsondecode(page.response_body).list]
  server_groups                   = { for server_group in flatten(local.server_groups_pages) : server_group.name => server_group.id }
  segment_groups_total_pages      = jsondecode(data.http.zscaler_get_segment_groups_total_pages.response_body).totalPages
  segment_groups_pages            = [for page in data.http.zscaler_get_segment_groups : jsondecode(page.response_body).list]
  segment_groups                  = { for segment_group in flatten(local.segment_groups_pages) : segment_group.name => segment_group.id }
  application_segment_total_pages = jsondecode(data.http.zscaler_get_application_segment_total_pages.response_body).totalPages
  application_segment_pages       = [for page in data.http.zscaler_get_applications_segment : jsondecode(page.response_body).list]
  application_segment             = { for app in flatten(local.application_segment_pages) : app.name => app.id }
  client_forwarding_policy_id     = jsondecode(data.http.zscaler_client_forwarding_policy_id.response_body).id
  idps                            = { for idp in jsondecode(data.http.zscaler_idps.response_body).list[*] : idp.name => idp.id }
  scim_groups_total_pages         = jsondecode(data.http.zscaler_get_scim_groups_total_pages.response_body).totalPages
  scim_groups_pages               = [for page in data.http.zscaler_get_scim_groups : jsondecode(page.response_body).list]
  scim_groups                     = { for server_group in flatten(local.scim_groups_pages) : server_group.name => server_group.id }
  scim_attributes                 = { for scim_attribute in jsondecode(data.http.zscaler_scim_attributes.response_body).list[*] : scim_attribute.name => scim_attribute.id }
  certificates_total_pages        = jsondecode(data.http.zscaler_get_certificates_total_pages.response_body).totalPages
  certificates_pages              = [for page in data.http.zscaler_get_certificates : jsondecode(page.response_body).list]
  certificates                    = { for server_group in flatten(local.certificates_pages) : server_group.name => server_group.id }
  app_connector_groups            = { for app_connector_group in jsondecode(data.http.zscaler_get_app_connector_groups.response_body).list[*] : app_connector_group.name => app_connector_group.id }
  servers_total_pages             = jsondecode(data.http.zscaler_get_servers_total_pages.response_body).totalPages
  servers_pages                   = [for page in data.http.zscaler_get_servers : jsondecode(page.response_body).list]
  servers                         = { for server in flatten(local.servers_pages) : server.name => server.id }
}
