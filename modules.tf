module "zscaler_inventory" {
  source            = "./inventory/"
  zpa_client_id     = urlencode(var.zpa_client_id)
  zpa_client_secret = urlencode(var.zpa_client_secret)
  zpa_customer_id   = var.zpa_customer_id
  zpa_idp_name      = var.zpa_idp_name
}
