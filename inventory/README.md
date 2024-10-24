<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >1.5    |
| <a name="requirement_http"></a> [http](#requirement\_http) | >3.4.5  |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_http"></a> [http](#provider\_http) | >3.4.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [http_http.zscaler_client_forwarding_policy_id](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.zscaler_get_app_connector_groups](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.zscaler_get_application_segment_total_pages](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.zscaler_get_applications_segment](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.zscaler_get_certificates](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.zscaler_get_certificates_total_pages](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.zscaler_get_scim_groups](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.zscaler_get_scim_groups_total_pages](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.zscaler_get_segment_groups](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.zscaler_get_segment_groups_total_pages](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.zscaler_get_server_groups](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.zscaler_get_server_groups_total_pages](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.zscaler_get_servers](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.zscaler_get_servers_total_pages](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.zscaler_idps](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.zscaler_scim_attributes](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.zscaler_sing_in](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apa_base_url"></a> [apa\_base\_url](#input\_apa\_base\_url) | Zscaler Private Access API Base URL | `string` | `"https://config.private.zscaler.com"` | no |
| <a name="input_zpa_client_id"></a> [zpa\_client\_id](#input\_zpa\_client\_id) | Zscaler Private Access API Client ID | `string` | n/a | yes |
| <a name="input_zpa_client_secret"></a> [zpa\_client\_secret](#input\_zpa\_client\_secret) | Zscaler Private Access API Client Secret | `string` | n/a | yes |
| <a name="input_zpa_customer_id"></a> [zpa\_customer\_id](#input\_zpa\_customer\_id) | Zscaler Private Access Customer ID | `string` | n/a | yes |
| <a name="input_zpa_idp_name"></a> [zpa\_idp\_name](#input\_zpa\_idp\_name) | Zscaler Private Access IDP Name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_connector_groups"></a> [app\_connector\_groups](#output\_app\_connector\_groups) | Zscaler app connector groups(name->id) |
| <a name="output_application_segments"></a> [application\_segments](#output\_application\_segments) | Zscaler applications segment map(name->id) |
| <a name="output_certificate"></a> [certificate](#output\_certificate) | Zscaler certificates(name->id) |
| <a name="output_client_forwarding_policy_id"></a> [client\_forwarding\_policy\_id](#output\_client\_forwarding\_policy\_id) | Get the policy set for the specific policy type |
| <a name="output_idps"></a> [idps](#output\_idps) | Zscaler configured idPs(name->id) |
| <a name="output_scim_attributes"></a> [scim\_attributes](#output\_scim\_attributes) | Zscaler SCIM Attributes(name->id) |
| <a name="output_scim_groups"></a> [scim\_groups](#output\_scim\_groups) | Zscaler SCIM Groups(name->id) |
| <a name="output_segment_groups"></a> [segment\_groups](#output\_segment\_groups) | Zscaler segment group map(name->id) |
| <a name="output_server_groups"></a> [server\_groups](#output\_server\_groups) | Zscaler server group map(name->id) |
| <a name="output_servers"></a> [servers](#output\_servers) | Zscaler servers(name->id) |
<!-- END_TF_DOCS -->