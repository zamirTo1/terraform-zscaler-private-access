variables {
  global_zpa_client_id     = ""
  global_zpa_client_secret = ""
  global_zpa_customer_id   = ""
  global_zpa_idp_name      = ""
}

provider "zpa" {
  zpa_client_id     = var.global_zpa_client_id
  zpa_client_secret = var.global_zpa_client_secret
  zpa_customer_id   = var.global_zpa_customer_id
}

run "failed-validation-tests" {
  command = plan
  variables {
    environment       = "zpa-testground"
    zpa_client_id     = var.global_zpa_client_id
    zpa_client_secret = var.global_zpa_client_secret
    zpa_customer_id   = var.global_zpa_customer_id
    zpa_idp_name      = var.global_zpa_idp_name
    zpa_server_groups = [
      {
        name = "zpa-server-group-1"
        app_connector_group_names = [
          "zpa-app-connector-group-1",
          "zpa-app-connector-group-2"
        ]
        dynamic_discovery = false
        server_names = [
          "zpa-server-group-1",
          "zpa-server-group-2"
        ]
      }
    ]
    zpa_application_segment_settings = [
      {
        tcp_keep_alive     = 2
        health_reporting   = "DISABLED"
        bypass_type        = "ENABLED"
        icmp_access_type   = "ENABLED"
        name               = "zpa-application-segment-settings-1"
        domain_names       = ["example.com", "example.org"]
        tcp_port_range     = ["3-1"]
        udp_port_range     = ["1", "2", "3", "2-4"]
        segment_group_name = "zpa-segment-group-1"
        server_groups = [
          "zpa-server-group-1"
        ]
      },
      {
        name               = "zpa-application-segment-settings-2"
        domain_names       = ["example.com", "example.org"]
        segment_group_name = "zpa-segment-group-2"
        server_groups = [
          "zpa-server-group-2"
        ]
        tcp_port_range = ["443"]
        clientless_apps = [
          {
            application_protocol = "HXXP"
            name                 = "zpa-clientless-app-1"
            domain               = ["example.com"]
            certificate_name     = ["example.com"]
          }
        ]
      }
    ]
  }
  expect_failures = [var.zpa_server_groups, var.zpa_application_segment_settings]
}

run "server-groups" {
  command = apply
  variables {
    zpa_client_id     = var.global_zpa_client_id
    zpa_client_secret = var.global_zpa_client_secret
    zpa_customer_id   = var.global_zpa_customer_id
    zpa_idp_name      = var.global_zpa_idp_name
    zpa_server_groups = [
      {
        name = "zpa-1"
        app_connector_group_names = [
          "app-connector-1"
        ]
      },
      {
        name = "zpa-2"
        app_connector_group_names = [
          "app-connector-1"
        ]
        dynamic_discovery = false
        server_names = [
          "server-1"
        ]
      }
    ]
  }
  assert {
    condition     = zpa_server_group.server_group[0].enabled == true
    error_message = "The server group is not enabled by default"
  }
  assert {
    condition     = zpa_server_group.server_group[1].dynamic_discovery == false && length(zpa_server_group.server_group[1].servers) > 0
    error_message = "server_name is required when dynamic_discovery is false"
  }
}

run "segment-groups" {
  command = plan
  variables {
    zpa_client_id     = var.global_zpa_client_id
    zpa_client_secret = var.global_zpa_client_secret
    zpa_customer_id   = var.global_zpa_customer_id
    zpa_idp_name      = var.global_zpa_idp_name
    zpa_segment_groups = {
      "zpa-app-seg-1" = {}
    }
  }
  assert {
    condition     = zpa_segment_group.segment_group["zpa-app-seg-1"].description == "zpa-app-seg-1-segment-group|Managed by Terraform"
    error_message = "The application segment description is incorrect"
  }
  assert {
    condition     = zpa_segment_group.segment_group["zpa-app-seg-1"].enabled == true
    error_message = "The application segment is not enabled by default"
  }
}

run "application-segments" {
  variables {
    zpa_client_id     = var.global_zpa_client_id
    zpa_client_secret = var.global_zpa_client_secret
    zpa_customer_id   = var.global_zpa_customer_id
    zpa_idp_name      = var.global_zpa_idp_name
    zpa_application_segment_settings = [
      {
        name               = "app-seg-1"
        domain_names       = ["internal.example.com", "internal-2.org"]
        segment_group_name = "segment-group-1"
        server_groups      = ["server-group-1"]
      },
      {
        name               = "app-seg-2"
        domain_names       = ["internal-3.example.com"]
        segment_group_name = "segment-group-2"
        server_groups      = ["server-group-1"]
        tcp_port_range     = ["123", "456-467"]
      }
    ]
  }
  assert {
    condition     = zpa_application_segment.application_segment[0].description == "app-seg-1-application-segment|Managed by Terraform"
    error_message = "The application segment description is incorrect"
  }
  assert {
    condition = zpa_application_segment.application_segment[0].tcp_port_range == toset([
      {
        from = "443"
        to   = "443"
      },
    ])
    error_message = "The default tcp_port_range is not 443"
  }
  assert {
    condition = zpa_application_segment.application_segment[1].tcp_port_range == toset([
      {
        from = "123"
        to   = "123"
      },
      {
        from = "456"
        to   = "467"
      },
    ])
    error_message = "The tcp_port_range is incorrect when using a range of ports"
  }
}

run "client-forwarding-policy" {
  variables {
    zpa_client_id     = var.global_zpa_client_id
    zpa_client_secret = var.global_zpa_client_secret
    zpa_customer_id   = var.global_zpa_customer_id
    zpa_idp_name      = var.global_zpa_idp_name
    zpa_client_forwarding_policy_settings = {
      test = {
        action = "BYPASS"
        conditions = {
          apps  = ["app-seg-1"]
          users = ["user-1@mydomain.com"]
        }
      }
      test2 = {
        action = "BYPASS"
        conditions = {
          apps  = ["*app-seg*"]
          users = ["user-2@mydomain.com"]
        }
      }
    }
    zpa_client_forwarding_policy_order = ["test2", "test"]
  }
  assert {
    condition     = zpa_policy_forwarding_rule.client_forwarding_policy_rule["test"].description == "test-client-forwarding-rule|Managed by Terraform"
    error_message = "The client forwarding policy description is incorrect"
  }
  assert {
    condition     = zpa_policy_access_rule_reorder.client_forwarding_policy_rule_reorder[0].rules == toset([{ id = zpa_policy_forwarding_rule.client_forwarding_policy_rule["test2"].id, order = "1" }, { id = zpa_policy_forwarding_rule.client_forwarding_policy_rule["test"].id, order = "2" }])
    error_message = "The client forwarding policy order is incorrect"
  }
}
