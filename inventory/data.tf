# Data block to sign in to the Zscaler API and obtain an access token.
data "http" "zscaler_sing_in" {
  url          = "${var.apa_base_url}/signin"
  method       = "POST"
  request_body = "client_id=${var.zpa_client_id}&client_secret=${var.zpa_client_secret}"
  request_headers = {
    Content-Type = "application/x-www-form-urlencoded"
  }
}

# Get the number of pages of interation
data "http" "zscaler_get_server_groups_total_pages" {
  url = "${var.apa_base_url}/mgmtconfig/v1/admin/customers/${var.zpa_customer_id}/serverGroup?page=1&pagesize=500"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.zscaler_sing_in.response_body).access_token}"
  }
}

# Iterate X times and get all server groups
data "http" "zscaler_get_server_groups" {
  count = local.server_groups_total_pages
  url   = "${var.apa_base_url}/mgmtconfig/v1/admin/customers/${var.zpa_customer_id}/serverGroup?page=${count.index + 1}&pagesize=500"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.zscaler_sing_in.response_body).access_token}"
  }
}

# Get the number of pages of interation
data "http" "zscaler_get_segment_groups_total_pages" {
  url = "${var.apa_base_url}/mgmtconfig/v1/admin/customers/${var.zpa_customer_id}/segmentGroup?page=1&pagesize=500"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.zscaler_sing_in.response_body).access_token}"
  }
}

# Iterate X times and get all segment groups
data "http" "zscaler_get_segment_groups" {
  count = local.segment_groups_total_pages
  url   = "${var.apa_base_url}/mgmtconfig/v1/admin/customers/${var.zpa_customer_id}/segmentGroup?page=${count.index + 1}&pagesize=500"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.zscaler_sing_in.response_body).access_token}"
  }
}

# Get the number of pages of interation
data "http" "zscaler_get_application_segment_total_pages" {
  url = "${var.apa_base_url}/mgmtconfig/v1/admin/customers/${var.zpa_customer_id}/application?page=1&pagesize=500"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.zscaler_sing_in.response_body).access_token}"
  }
}

# Iterate X times and get all application segment
data "http" "zscaler_get_applications_segment" {
  count = local.application_segment_total_pages
  url   = "${var.apa_base_url}/mgmtconfig/v1/admin/customers/${var.zpa_customer_id}/application?page=${count.index + 1}&pagesize=500"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.zscaler_sing_in.response_body).access_token}"
  }
}

# Data block to fetch Zscaler Client forwarding policy ID (Global ID)
data "http" "zscaler_client_forwarding_policy_id" {
  url = "${var.apa_base_url}/mgmtconfig/v1/admin/customers/${var.zpa_customer_id}/policySet/policyType/CLIENT_FORWARDING_POLICY"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.zscaler_sing_in.response_body).access_token}"
  }
}

# Data block to fetch Zscaler idPs
data "http" "zscaler_idps" {
  url = "${var.apa_base_url}/mgmtconfig/v2/admin/customers/${var.zpa_customer_id}/idp?page=1&pagesize=500"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.zscaler_sing_in.response_body).access_token}"
  }
}

# Get the number of pages of interation
data "http" "zscaler_get_scim_groups_total_pages" {
  url = "${var.apa_base_url}/userconfig/v1/customers/${var.zpa_customer_id}/scimgroup/idpId/${local.idps[var.zpa_idp_name]}?page=1&pagesize=500"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.zscaler_sing_in.response_body).access_token}"
  }
}

# Iterate X times and get all scim groups
data "http" "zscaler_get_scim_groups" {
  count = local.scim_groups_total_pages
  url   = "${var.apa_base_url}/userconfig/v1/customers/${var.zpa_customer_id}/scimgroup/idpId/${local.idps[var.zpa_idp_name]}?page=${count.index + 1}&pagesize=500"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.zscaler_sing_in.response_body).access_token}"
  }
}

# Data block to fetch Zscaler SCIM Attributes.
data "http" "zscaler_scim_attributes" {
  url = "${var.apa_base_url}/mgmtconfig/v1/admin/customers/${var.zpa_customer_id}/idp/${local.idps[var.zpa_idp_name]}/scimattribute?page=1&pagesize=500"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.zscaler_sing_in.response_body).access_token}"
  }
}

# Get the number of pages of interation
data "http" "zscaler_get_certificates_total_pages" {
  url = "${var.apa_base_url}/mgmtconfig/v2/admin/customers/${var.zpa_customer_id}/clientlessCertificate/issued?page=1&pagesize=500"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.zscaler_sing_in.response_body).access_token}"
  }
}

# Iterate X times and get all certificates
data "http" "zscaler_get_certificates" {
  count = local.certificates_total_pages
  url   = "${var.apa_base_url}/mgmtconfig/v2/admin/customers/${var.zpa_customer_id}/clientlessCertificate/issued?page=${count.index + 1}&pagesize=500"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.zscaler_sing_in.response_body).access_token}"
  }
}

# Get Zscaler App connector groups
data "http" "zscaler_get_app_connector_groups" {
  url = "${var.apa_base_url}/mgmtconfig/v1/admin/customers/${var.zpa_customer_id}/appConnectorGroup?page=1&pagesize=500"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.zscaler_sing_in.response_body).access_token}"
  }
}

# Get the number of pages of interation
data "http" "zscaler_get_servers_total_pages" {
  url = "${var.apa_base_url}/mgmtconfig/v1/admin/customers/${var.zpa_customer_id}/server?page=1&pagesize=500"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.zscaler_sing_in.response_body).access_token}"
  }
}

# Iterate X times and get all servers
data "http" "zscaler_get_servers" {
  count = local.servers_total_pages
  url   = "${var.apa_base_url}/mgmtconfig/v1/admin/customers/${var.zpa_customer_id}/server?page=${count.index + 1}&pagesize=500"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${jsondecode(data.http.zscaler_sing_in.response_body).access_token}"
  }
}
