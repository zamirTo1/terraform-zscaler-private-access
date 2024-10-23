# ZPA Server Groups
resource "zpa_server_group" "server_group" {
  count             = length(var.zpa_server_groups)
  name              = var.zpa_server_groups[count.index].name
  description       = var.zpa_server_groups[count.index].description != "" ? var.zpa_server_groups[count.index].description : "${var.zpa_server_groups[count.index].name}-server-group|Managed by Terraform"
  enabled           = var.zpa_server_groups[count.index].enabled
  dynamic_discovery = var.zpa_server_groups[count.index].dynamic_discovery
  app_connector_groups {
    id = [for app_connector_group_name in var.zpa_server_groups[count.index].app_connector_group_names : module.zscaler_inventory.app_connector_groups[app_connector_group_name]]
  }
  servers {
    id = [for server_name in var.zpa_server_groups[count.index].server_names : module.zscaler_inventory.servers[server_name]]
  }
}

# ZPA Segment Groups
resource "zpa_segment_group" "segment_group" {
  for_each    = var.zpa_segment_groups
  name        = each.key
  description = each.value.description != null ? each.value.description : "${each.key}-segment-group|Managed by Terraform"
  enabled     = each.value.enabled
}

# Application segment
resource "zpa_application_segment" "application_segment" {
  for_each                      = { for idx, application_segment in var.zpa_application_segment_settings : idx => application_segment if length(application_segment.clientless_apps) == 0 }
  domain_names                  = each.value.domain_names
  name                          = each.value.name
  description                   = each.value.description != null ? each.value.description : "${each.value.name}-application-segment|Managed by Terraform"
  enabled                       = each.value.enabled
  tcp_keep_alive                = each.value.tcp_keep_alive
  ip_anchored                   = each.value.ip_anchored
  health_reporting              = each.value.health_reporting
  bypass_type                   = each.value.bypass_type
  is_cname_enabled              = each.value.is_cname_enabled
  icmp_access_type              = each.value.icmp_access_type
  double_encrypt                = each.value.double_encrypt
  select_connector_close_to_app = each.value.select_connector_close_to_app
  segment_group_id              = module.zscaler_inventory.segment_groups[each.value.segment_group_name]

  server_groups {
    id = [for server_group in each.value.server_groups : module.zscaler_inventory.server_groups[server_group]]
  }

  tcp_port_range = [
    for range in each.value.tcp_port_range : {
      from = strcontains(range, "-") ? split("-", range)[0] : range
      to   = strcontains(range, "-") ? split("-", range)[1] : range
    }
  ]

  udp_port_range = [
    for range in each.value.udp_port_range : {
      from = strcontains(range, "-") ? split("-", range)[0] : range
      to   = strcontains(range, "-") ? split("-", range)[1] : range
    }
  ]
}

# Browser access application segment
resource "zpa_application_segment_browser_access" "browser_access_application_segment" {
  for_each                      = { for idx, application_segment in var.zpa_application_segment_settings : idx => application_segment if length(application_segment.clientless_apps) > 0 }
  domain_names                  = each.value.domain_names
  name                          = each.value.name
  description                   = each.value.description != "" ? each.value.description : "${each.value.name}-browser-access-application-segment|Managed by Terraform"
  enabled                       = each.value.enabled
  tcp_keep_alive                = each.value.tcp_keep_alive
  ip_anchored                   = each.value.ip_anchored
  health_reporting              = each.value.health_reporting
  bypass_type                   = each.value.bypass_type
  is_cname_enabled              = each.value.is_cname_enabled
  icmp_access_type              = each.value.icmp_access_type
  double_encrypt                = each.value.double_encrypt
  select_connector_close_to_app = each.value.select_connector_close_to_app
  segment_group_id              = module.zscaler_inventory.segment_groups[each.value.segment_group_name]

  server_groups {
    id = [for server_group in each.value.server_groups : module.zscaler_inventory.server_groups[server_group]]
  }

  tcp_port_range = [
    for range in each.value.tcp_port_range : {
      from = strcontains(range, "-") ? split("-", range)[0] : range
      to   = strcontains(range, "-") ? split("-", range)[1] : range
    }
  ]

  udp_port_range = [
    for range in each.value.udp_port_range : {
      from = strcontains(range, "-") ? split("-", range)[0] : range
      to   = strcontains(range, "-") ? split("-", range)[1] : range
    }
  ]

  dynamic "clientless_apps" {
    for_each = each.value.clientless_apps
    content {
      name                 = clientless_apps.value.name
      application_protocol = clientless_apps.value.application_protocol
      application_port     = clientless_apps.value.application_port
      certificate_id       = module.zscaler_inventory.certificate[clientless_apps.value.certificate_name]
      trust_untrusted_cert = clientless_apps.value.trust_untrusted_cert
      enabled              = clientless_apps.value.enabled
      domain               = clientless_apps.value.domain
    }
  }
}

# ZPA Forwarding Policies
resource "zpa_policy_forwarding_rule" "client_forwarding_policy_rule" {
  depends_on    = [zpa_application_segment.application_segment, zpa_application_segment_browser_access.browser_access_application_segment]
  for_each      = var.zpa_client_forwarding_policy_settings
  name          = each.key
  description   = each.value.description != null ? each.value.description : "${each.key}-client-forwarding-rule|Managed by Terraform"
  action        = each.value.action
  operator      = "AND"
  policy_set_id = each.value.client_forwarding_policy_id

  # Apps and application segment block
  dynamic "conditions" {
    for_each = can(length(each.value.conditions.apps) > 0) || can(length(each.value.conditions.segment_groups) > 0) ? ["apply"] : []
    content {
      operator = "OR"
      dynamic "operands" {
        for_each = try(distinct(flatten([for value in each.value.conditions.apps :
          (try(regex("\\*[a-zA-Z0-9._-]+\\*", value), "") != "" ? flatten([for key in keys(module.zscaler_inventory.application_segments) : (strcontains(key, replace(value, "*", "")) ? [module.zscaler_inventory.application_segments[key]] : [])]) :
            (try(regex("[a-zA-Z0-9._-]+\\*", value), "") != "" ? flatten([for key in keys(module.zscaler_inventory.application_segments) : (startswith(key, replace(value, "*", "")) ? [module.zscaler_inventory.application_segments[key]] : [])]) :
              (try(regex("\\*[a-zA-Z0-9._-]+", value), "") != "" ? flatten([for key in keys(module.zscaler_inventory.application_segments) : (endswith(key, replace(value, "*", "")) ? [module.zscaler_inventory.application_segments[key]] : [])]) :
          (lookup(module.zscaler_inventory.application_segments, value, null) != null ? [module.zscaler_inventory.application_segments[value]] : []))))
        ])), [])
        content {
          rhs         = operands.value
          lhs         = "id"
          object_type = "APP"
        }
      }
      dynamic "operands" {
        for_each = can(length(each.value.conditions.segment_groups) > 0) ? [for app in each.value.conditions.segment_groups : module.zscaler_inventory.segment_groups[app]] : []
        content {
          rhs         = operands.value
          lhs         = "id"
          object_type = "APP_GROUP"
        }
      }
    }
  }
  # SCIM condition block
  dynamic "conditions" {
    for_each = can(length(each.value.conditions.groups) > 0) || can(length(each.value.conditions.users) > 0) ? ["apply"] : []
    content {
      operator = "OR"
      dynamic "operands" {
        for_each = can(length(each.value.conditions.groups) > 0) ? [for group in each.value.conditions.groups : module.zscaler_inventory.scim_groups[group]] : []
        content {
          rhs         = operands.value
          lhs         = module.zscaler_inventory.idps[var.zpa_idp_name]
          object_type = "SCIM_GROUP"
        }
      }
      dynamic "operands" {
        for_each = can(length(each.value.conditions.users) > 0) ? each.value.conditions.users : []
        content {
          rhs         = operands.value
          lhs         = module.zscaler_inventory.scim_attributes["userName"]
          object_type = "SCIM"
          idp_id      = module.zscaler_inventory.idps[var.zpa_idp_name]
        }
      }
    }
  }
}

# ZPA Policy Access Rules Reorder
resource "zpa_policy_access_rule_reorder" "client_forwarding_policy_rule_reorder" {
  count       = length(var.zpa_client_forwarding_policy_order) > 0 ? 1 : 0
  depends_on  = [zpa_policy_forwarding_rule.client_forwarding_policy_rule]
  policy_type = "CLIENT_FORWARDING_POLICY"

  dynamic "rules" {
    for_each = zipmap(range(length(var.zpa_client_forwarding_policy_order)), var.zpa_client_forwarding_policy_order)
    content {
      id    = zpa_policy_forwarding_rule.client_forwarding_policy_rule[rules.value].id
      order = rules.key + 1
    }
  }
}

# ZPA Access Policies
resource "zpa_policy_access_rule" "access_policy_rule" {
  for_each    = var.zpa_policy_access_rules
  name        = strcontains(each.key, "@") ? replace(each.key, "@", "-at-") : each.key
  description = each.value.description ? each.value.description : "${each.key}-access-policy|Managed by Terraform"
  action      = each.value.action
  operator    = each.value.operator

  dynamic "conditions" {
    for_each = each.value.applications != [] ? ["apply"] : each.value.application_segments != [] ? ["apply"] : []
    content {
      operator = "OR"
      dynamic "operands" {
        for_each = try(distinct(flatten([for value in each.value.applications :
          (try(regex("\\*[a-zA-Z0-9._-]+\\*", value), "") != "" ? flatten([for key in keys(module.zscaler_inventory.application_segments) : (strcontains(key, replace(value, "*", "")) ? [module.zscaler_inventory.application_segments[key]] : [])]) :
            (try(regex("[a-zA-Z0-9._-]+\\*", value), "") != "" ? flatten([for key in keys(module.zscaler_inventory.application_segments) : (startswith(key, replace(value, "*", "")) ? [module.zscaler_inventory.application_segments[key]] : [])]) :
              (try(regex("\\*[a-zA-Z0-9._-]+", value), "") != "" ? flatten([for key in keys(module.zscaler_inventory.application_segments) : (endswith(key, replace(value, "*", "")) ? [module.zscaler_inventory.application_segments[key]] : [])]) :
          (lookup(module.zscaler_inventory.application_segments, value, null) != null ? [module.zscaler_inventory.application_segments[value]] : []))))
        ])), [])
        content {
          object_type = "APP"
          lhs         = "id"
          rhs         = operands.value
        }
      }
      dynamic "operands" {
        for_each = try(each.value.application_segments, [])
        content {
          object_type = "APP_GROUP"
          lhs         = "id"
          name        = operands.value
          rhs         = module.zscaler_inventory.segment_groups[operands.value]
        }
      }
    }
  }
  dynamic "conditions" {
    for_each = each.key != "" ? [each.key] : []
    content {
      operator = "OR"
      operands {
        object_type = strcontains(each.key, "@") ? "SCIM" : "SCIM_GROUP"
        idp_id      = module.zscaler_inventory.idps[var.zpa_idp_name]
        name        = strcontains(each.key, "@") ? "userName" : null
        lhs         = strcontains(each.key, "@") ? module.zscaler_inventory.scim_attributes["userName"] : module.zscaler_inventory.idps[var.zpa_idp_name]
        rhs         = strcontains(each.key, "@") ? each.key : module.zscaler_inventory.scim_groups[each.key]
      }
    }
  }
}

# ZPA Policy Access Rules Reorder
resource "zpa_policy_access_rule_reorder" "access_policy_rule_reorder" {
  count       = length(var.zpa_policy_access_rule_order) > 0 ? 1 : 0
  depends_on  = [zpa_policy_access_rule.access_policy_rule]
  policy_type = "ACCESS_POLICY"

  dynamic "rules" {
    for_each = zipmap(range(length(var.zpa_policy_access_rule_order)), var.zpa_policy_access_rule_order)
    content {
      id    = zpa_policy_access_rule.access_policy_rule[rules.value].id
      order = rules.key + 1
    }
  }
}
