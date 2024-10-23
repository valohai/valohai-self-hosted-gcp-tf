module "gce-lb-http" {
  source  = "terraform-google-modules/lb-http/google"
  name    = var.network_prefix
  project = var.project
  target_tags = [
    "${var.network_prefix}-group1",
    module.cloud-nat-group1.router_name,
    "${var.network_prefix}-group2",
    module.cloud-nat-group2.router_name
  ]
  firewall_networks = [google_compute_network.default.name] # TODO needed? -> we do it, can add to README to change it

  backends = {
    default = {

      protocol    = "HTTP"
      port        = 80
      port_name   = "http"
      timeout_sec = 10
      enable_cdn  = false

      health_check = {
        request_path = "/"
        port         = 80
      }

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      groups = [
        {
          group = module.mig1.instance_group
        },
        {
          group = module.mig2.instance_group
        },
      ]

      iap_config = {
        enable = false
      }
    }
  }
}