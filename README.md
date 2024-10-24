# Zscaler Private Access (ZPA) Module for Private infrastructure, Applications and Policies.

---
This Terraform module allows users to support ZPA Cloud resources, applications and policies to dynamically manage the infrastructure changes.
Using this Terraform module, security and devops teams can join forces and reduce effort, manual changes on both sides of the infra, enable self service automation and policy automation based on application scale.

This Terraform module is tested with ZPA Terraform provider version 3.33.7.

Note: **Use this module with caution**, as it can create, update and delete ZPA applications and policies! **_Keep your API keys secure and do not use them cleartext in your Terraform configuration._**

## Feature

---
This module supports the following:
- Create, update and delete Application Segments.
- Create, update and delete Browser Access Application Segments.
- Create, update and delete Policy Access Rules.
- Create, update and delete Client Forwarding Policy Rules.
- Create, update and delete Segment Groups.
- Create, update and delete Server Groups.
- Reorder Policy Access Rules.
- Reorder Client Forwarding Policy Rules.
- Inventory of ZPA resources.

## Motivation

---
Link here


## Requirements

---
| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >1.5   |
| <a name="requirement_zpa"></a> [zpa](#requirement\_zpa) | >3.33.7 |

## Providers

---
| Name | Version |
|------|---------|
| <a name="provider_zpa"></a> [zpa](#provider\_zpa) | >3.33.7 |

## Modules

---
| Name | Source | Version |
|------|--------|---------|
| <a name="module_zscaler_inventory"></a> [zscaler\_inventory](#module\_zscaler\_inventory) | ./inventory/ | n/a |

## Resources

---
| Name | Type |
|------|------|
| [zpa_application_segment.application_segment](https://registry.terraform.io/providers/zscaler/zpa/latest/docs/resources/application_segment) | resource |
| [zpa_application_segment_browser_access.browser_access_application_segment](https://registry.terraform.io/providers/zscaler/zpa/latest/docs/resources/application_segment_browser_access) | resource |
| [zpa_policy_access_rule.access_policy_rule](https://registry.terraform.io/providers/zscaler/zpa/latest/docs/resources/policy_access_rule) | resource |
| [zpa_policy_access_rule_reorder.access_policy_rule_reorder](https://registry.terraform.io/providers/zscaler/zpa/latest/docs/resources/policy_access_rule_reorder) | resource |
| [zpa_policy_access_rule_reorder.client_forwarding_policy_rule_reorder](https://registry.terraform.io/providers/zscaler/zpa/latest/docs/resources/policy_access_rule_reorder) | resource |
| [zpa_policy_forwarding_rule.client_forwarding_policy_rule](https://registry.terraform.io/providers/zscaler/zpa/latest/docs/resources/policy_forwarding_rule) | resource |
| [zpa_segment_group.segment_group](https://registry.terraform.io/providers/zscaler/zpa/latest/docs/resources/segment_group) | resource |
| [zpa_server_group.server_group](https://registry.terraform.io/providers/zscaler/zpa/latest/docs/resources/server_group) | resource |

## Inputs

---
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_zpa_application_segment_settings"></a> [zpa\_application\_segment\_settings](#input\_zpa\_application\_segment\_settings) | Zscaler Private Access browser access application segment settings | <pre>list(<br>    object({<br>      name                          = string<br>      description                   = optional(string)<br>      enabled                       = optional(bool, true)<br>      tcp_keep_alive                = optional(number, 0)<br>      ip_anchored                   = optional(bool, false)<br>      health_reporting              = optional(string, "ON_ACCESS")<br>      bypass_type                   = optional(string, "NEVER")<br>      is_cname_enabled              = optional(bool, true)<br>      icmp_access_type              = optional(string, "PING")<br>      tcp_port_range                = optional(list(string), ["443"])<br>      udp_port_range                = optional(list(string), [])<br>      domain_names                  = list(string)<br>      double_encrypt                = optional(bool, false)<br>      select_connector_close_to_app = optional(bool, false)<br>      segment_group_name            = string<br>      server_groups                 = list(string)<br>      clientless_apps = optional(list(object({<br>        name                 = string<br>        application_protocol = optional(string, "HTTPS")<br>        application_port     = optional(string, "443")<br>        certificate_name     = string<br>        trust_untrusted_cert = optional(bool, false)<br>        enabled              = optional(bool, true)<br>        domain               = string<br>        allow_options        = optional(bool, false)<br>      })), [])<br>    })<br>  )</pre> | `[]` | no |
| <a name="input_zpa_client_forwarding_policy_order"></a> [zpa\_client\_forwarding\_policy\_order](#input\_zpa\_client\_forwarding\_policy\_order) | Zscaler Private Access client forwarding policy order | `list(string)` | `[]` | no |
| <a name="input_zpa_client_forwarding_policy_settings"></a> [zpa\_client\_forwarding\_policy\_settings](#input\_zpa\_client\_forwarding\_policy\_settings) | Zscaler Private Access client forwarding policy | <pre>map(<br>    object({<br>      description                 = optional(string)<br>      action                      = string<br>      client_forwarding_policy_id = optional(string)<br>      conditions = object({<br>        apps           = optional(list(string))<br>        segment_groups = optional(list(string))<br>        groups         = optional(list(string))<br>        users          = optional(list(string))<br>      })<br>    })<br>  )</pre> | `{}` | no |
| <a name="input_zpa_client_id"></a> [zpa\_client\_id](#input\_zpa\_client\_id) | Zscaler Private Access client ID | `string` | n/a | yes |
| <a name="input_zpa_client_secret"></a> [zpa\_client\_secret](#input\_zpa\_client\_secret) | Zscaler Private Access client secret | `string` | n/a | yes |
| <a name="input_zpa_customer_id"></a> [zpa\_customer\_id](#input\_zpa\_customer\_id) | Zscaler Private Access customer ID | `string` | n/a | yes |
| <a name="input_zpa_idp_name"></a> [zpa\_idp\_name](#input\_zpa\_idp\_name) | Zscaler Private Access Identity Provider name | `string` | n/a | yes |
| <a name="input_zpa_policy_access_rule_order"></a> [zpa\_policy\_access\_rule\_order](#input\_zpa\_policy\_access\_rule\_order) | Zscaler Private Access policy access rule order | `list(string)` | `[]` | no |
| <a name="input_zpa_policy_access_rules"></a> [zpa\_policy\_access\_rules](#input\_zpa\_policy\_access\_rules) | Zscaler Private Access browser access policy access rules | <pre>map(<br>    object({<br>      description          = optional(string)<br>      action               = optional(string, "ALLOW")<br>      operator             = optional(string, "AND")<br>      applications         = optional(list(string))<br>      application_segments = optional(list(string))<br>    })<br>  )</pre> | `{}` | no |
| <a name="input_zpa_segment_groups"></a> [zpa\_segment\_groups](#input\_zpa\_segment\_groups) | Zscaler Private Access segment groups | <pre>map(object({<br>    description = optional(string)<br>    enabled     = optional(bool, true)<br>  }))</pre> | `{}` | no |
| <a name="input_zpa_server_groups"></a> [zpa\_server\_groups](#input\_zpa\_server\_groups) | Zscaler Private Access browser access server groups | <pre>list(<br>    object({<br>      name                      = string<br>      app_connector_group_names = list(string)<br>      description               = optional(string)<br>      enabled                   = optional(bool, true)<br>      dynamic_discovery         = optional(bool, true)<br>      server_names              = optional(list(string), [])<br>    })<br>  )</pre> | `[]` | no |

## Usage

---
### Segment Groups
```
zpa_segment_groups = {
    "segment-group-1" = {
        description = "Segment Group 1"
        enabled     = true
    }
    "segment-group-2" = {
        description = "Segment Group 2"
        enabled     = true
    }  
}
```

### Application Segments
```
zpa_application_segment_settings = [
  {
    name               = "app-seg-1"
    domain_names       = ["internal.example.com"]
    segment_group_name = "segment-group-1"
    server_groups      = ["server-group-1"]
    clientless_apps    = [
      {
        name                 = "internal.example.com"
        application_protocol = "HTTPS"
        application_port     = "443"
        certificate_name     = "internal.example.com"
        domain               = "internal.example.com"
      }
    ]
  },
  {
    name               = "app-seg-2"
    domain_names       = ["internal-3.example.com"]
    segment_group_name = "segment-group-2"
    server_groups      = ["server-group-1"]
    tcp_port_range     = ["123", "456-467"]
  }
]
```

### Policy Access Rules
```
zpa_policy_access_rules = {
  "backend_team" = {
    description          = "backend team"
    action               = "ALLOW"
    applications         = ["app-seg-1"]
  }
  "security_team" = {
    description          = "Rule 2"
    action               = "ALLOW"
    applications         = ["app-seg-*"]
  }
}
zpa_policy_access_rule_order = ["backend_team", "security_team"]
```

### Client Forwarding Policy
```
zpa_client_forwarding_policy_settings = {
  backend_team_user_bypass = {
    action = "BYPASS"
    conditions = {
      apps  = ["app-seg-1"]
      users = ["backend-user-1@mydomain.com"]
    }
  }
  backend_team_intercept = {
    action = "INTERCEPT"
    conditions = {
      apps  = ["*app-seg*"]
      groups = ["backend-team"]
    }
  }
}
zpa_client_forwarding_policy_order = ["backend_team_user_bypass", "backend_team_intercept"]
```

## Future Developments

---

There are plans to expand its capabilities to cover other ZPA resources in the future. Stay tuned for updates!

## Contributing

---

Contributions are welcome! Please feel free to submit a Pull Request.

## License

---

This project is licensed under the MIT License. See the [LICENCE](LICENSE) file for details.

