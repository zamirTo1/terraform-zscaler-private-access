terraform {
  required_version = ">=1.5"
  required_providers {
    zpa = {
      source = "zscaler/zpa"
      version = ">=3.33.7"
    }
    http = {
      source = "hashicorp/http"
    }
  }
}

provider "zpa" {
  zpa_client_id     = var.zpa_client_id
  zpa_client_secret = var.zpa_client_secret
  zpa_customer_id   = var.zpa_customer_id
}
