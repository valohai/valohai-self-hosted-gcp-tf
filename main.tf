terraform {
  required_version = ">=1.4.6"
  required_providers {
    gcp = {
        source = "hashicorp/google"
    }
  }
}

provider "gcp" {
  credentials = file(var.gcp_access_token_path)
  project     = var.project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
}



