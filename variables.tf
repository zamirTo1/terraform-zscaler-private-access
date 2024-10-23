variable "zpa_server_groups" {
  type = list(
    object({
      name                      = string
      app_connector_group_names = list(string)
      description               = optional(string)
      enabled                   = optional(bool, true)
      dynamic_discovery         = optional(bool, true)
      server_names              = optional(list(string), [])
    })
  )
  description = "Zscaler Private Access browser access server groups"
  validation {
    condition = alltrue([
      for dynamic_discovery_off_server_group in [
        for server_group in var.zpa_server_groups : server_group if server_group.dynamic_discovery == false
      ] : (length(dynamic_discovery_off_server_group.server_names) > 0 ? true : false)]
    )
    error_message = "Invalid input - servers - required when dynamic_discovery is disabled."
  }
  default = []
}

variable "zpa_segment_groups" {
  type = map(object({
    description = optional(string)
    enabled     = optional(bool, true)
  }))
  description = "Zscaler Private Access segment groups"
  default     = {}
}

variable "zpa_application_segment_settings" {
  type = list(
    object({
      name                          = string
      description                   = optional(string)
      enabled                       = optional(bool, true)
      tcp_keep_alive                = optional(number, 0)
      ip_anchored                   = optional(bool, false)
      health_reporting              = optional(string, "ON_ACCESS")
      bypass_type                   = optional(string, "NEVER")
      is_cname_enabled              = optional(bool, true)
      icmp_access_type              = optional(string, "PING")
      tcp_port_range                = optional(list(string), ["443"])
      udp_port_range                = optional(list(string), [])
      domain_names                  = list(string)
      double_encrypt                = optional(bool, false)
      select_connector_close_to_app = optional(bool, false)
      segment_group_name            = string
      server_groups                 = list(string)
      clientless_apps = optional(list(object({
        name                 = string
        application_protocol = optional(string, "HTTPS")
        application_port     = optional(string, "443")
        certificate_name     = string
        trust_untrusted_cert = optional(bool, false)
        enabled              = optional(bool, true)
        domain               = string
        allow_options        = optional(bool, false)
      })), [])
    })
  )
  description = "Zscaler Private Access browser access application segment settings"
  validation {
    condition = alltrue([
      for app_segment_settings in var.zpa_application_segment_settings : true if(app_segment_settings.tcp_keep_alive == 0 || app_segment_settings.tcp_keep_alive == 1)
    ])
    error_message = "Invalid input - tcp_keep_alive - accepted values: 0 or 1."
  }
  validation {
    condition = alltrue([
      for app_segment_settings in var.zpa_application_segment_settings : contains(["NONE", "ON_ACCESS", "CONTINUOUS"], app_segment_settings.health_reporting)
    ])
    error_message = "Invalid input - health_reporting - accepted values: [\"NONE\", \"ON_ACCESS\", \"CONTINUOUS\"]."
  }
  validation {
    condition = alltrue([
      for app_segment_settings in var.zpa_application_segment_settings : contains(["ALWAYS", "NEVER", "ON_NET"], app_segment_settings.bypass_type)
    ])
    error_message = "Invalid input - bypass_type - accepted values: [\"ALWAYS\", \"NEVER\", \"ON_NET\"]."
  }
  validation {
    condition = alltrue([
      for app_segment_settings in var.zpa_application_segment_settings : contains(["PING_TRACEROUTING", "PING", "NONE"], app_segment_settings.icmp_access_type)
    ])
    error_message = "Invalid input - icmp_access_type - accepted values: [\"PING_TRACEROUTING\", \"PING\", \"NONE\"]."
  }
  validation {
    condition     = alltrue([for clientless_app in flatten([for app_segment_settings in var.zpa_application_segment_settings : (try(app_segment_settings.clientless_apps != []) ? app_segment_settings.clientless_apps : null)]) : (contains(["HTTP", "HTTPS"], clientless_app.application_protocol) ? true : false)])
    error_message = "Invalid protocol - clientless_apps.protocol - accepted values: [\"HTTP\", \"HTTPS\"]."
  }
  validation {
    condition     = alltrue(flatten([for tcp_range in var.zpa_application_segment_settings.*.tcp_port_range : [for port in tcp_range : (strcontains(port, "-") ? tonumber(split("-", port)[0]) < tonumber(split("-", port)[1]) : true)]]))
    error_message = "Invalid input - tcp_port_range - accepted values: [\"<port>\", \"<start_port>-<end_port>\"] where start_port > start_port."
  }
  validation {
    condition = alltrue(flatten([for tcp_range in var.zpa_application_segment_settings.*.tcp_port_range : [length(flatten([for item in tcp_range : [
      for i in range(
        length(regexall("-", item)) > 0 ? tonumber(split("-", item)[0]) : tonumber(item),
        length(regexall("-", item)) > 0 ? tonumber(split("-", item)[1]) + 1 : tonumber(item) + 1
      ) : i
      ]])) == length(distinct(flatten([for item in tcp_range : [
        for i in range(
          length(regexall("-", item)) > 0 ? tonumber(split("-", item)[0]) : tonumber(item),
          length(regexall("-", item)) > 0 ? tonumber(split("-", item)[1]) + 1 : tonumber(item) + 1
        ) : i
    ]])))]]))
    error_message = "Invalid input - tcp_port_range - tcp range with duplicate ports."
  }
  validation {
    condition     = alltrue(flatten([for udp_range in var.zpa_application_segment_settings.*.tcp_port_range : [for port in udp_range : (strcontains(port, "-") ? tonumber(split("-", port)[0]) < tonumber(split("-", port)[1]) : true)]]))
    error_message = "Invalid input - udp_port_range - accepted values: [\"<port>\", \"<start_port>-<end_port>\"] where start_port > start_port."
  }
  validation {
    condition = alltrue(flatten([for udp_range in var.zpa_application_segment_settings.*.tcp_port_range : [length(flatten([for item in udp_range : [
      for i in range(
        length(regexall("-", item)) > 0 ? tonumber(split("-", item)[0]) : tonumber(item),
        length(regexall("-", item)) > 0 ? tonumber(split("-", item)[1]) + 1 : tonumber(item) + 1
      ) : i
      ]])) == length(distinct(flatten([for item in udp_range : [
        for i in range(
          length(regexall("-", item)) > 0 ? tonumber(split("-", item)[0]) : tonumber(item),
          length(regexall("-", item)) > 0 ? tonumber(split("-", item)[1]) + 1 : tonumber(item) + 1
        ) : i
    ]])))]]))
    error_message = "Invalid input - udp_port_range - udp range with duplicate ports."
  }
  default = []
}

variable "zpa_policy_access_rules" {
  type = map(
    object({
      description          = optional(string)
      action               = optional(string, "ALLOW")
      operator             = optional(string, "AND")
      applications         = optional(list(string))
      application_segments = optional(list(string))
    })
  )
  description = "Zscaler Private Access browser access policy access rules"
  validation {
    condition = alltrue([
      for access_rule in var.zpa_policy_access_rules : contains(["ALLOW", "DENY"], access_rule.action)
    ])
    error_message = "Invalid input - action - accepted values: [\"ALLOW\", \"DENY\"]."
  }
  validation {
    condition = alltrue([
      for access_rule in var.zpa_policy_access_rules : contains(["AND", "OR"], access_rule.operator)
    ])
    error_message = "Invalid input - operator - accepted values: [\"AND\", \"OR\"]."
  }
  default = {}
}

variable "zpa_policy_access_rule_order" {
  type        = list(string)
  description = "Zscaler Private Access policy access rule order"
  default     = []
}

variable "zpa_client_forwarding_policy_settings" {
  type = map(
    object({
      description                 = optional(string)
      action                      = string
      client_forwarding_policy_id = optional(string)
      conditions = object({
        apps           = optional(list(string))
        segment_groups = optional(list(string))
        groups         = optional(list(string))
        users          = optional(list(string))
      })
    })
  )
  validation {
    condition = alltrue([
      for client_forwarding_policy_settings in var.zpa_client_forwarding_policy_settings : contains(["BYPASS", "INTERCEPT", "INTERCEPT_ACCESSIBLE"], client_forwarding_policy_settings.action)
    ])
    error_message = "Invalid input, one of values: [\"BYPASS\", \"INTERCEPT\", \"INTERCEPT_ACCESSIBLE\"]."
  }
  description = "Zscaler Private Access client forwarding policy"
  default     = {}
}

variable "zpa_client_forwarding_policy_order" {
  type        = list(string)
  description = "Zscaler Private Access client forwarding policy order"
  default     = []
}

variable "zpa_idp_name" {
  type        = string
  description = "Zscaler Private Access Identity Provider name"
}

variable "zpa_customer_id" {
  type        = string
  description = "Zscaler Private Access customer ID"
}

variable "zpa_client_secret" {
  type        = string
  description = "Zscaler Private Access client secret"
}

variable "zpa_client_id" {
  type        = string
  description = "Zscaler Private Access client ID"
}
