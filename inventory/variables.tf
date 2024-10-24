variable "zpa_client_id" {
  type        = string
  description = "Zscaler Private Access API Client ID"
  sensitive   = true
}

variable "zpa_client_secret" {
  type        = string
  description = "Zscaler Private Access API Client Secret"
  sensitive   = true
}

variable "zpa_customer_id" {
  type        = string
  description = "Zscaler Private Access Customer ID"
  sensitive   = true
}

variable "apa_base_url" {
  default     = "https://config.private.zscaler.com"
  type        = string
  description = "Zscaler Private Access API Base URL"
}

variable "zpa_idp_name" {
  type        = string
  description = "Zscaler Private Access IDP Name"
}
