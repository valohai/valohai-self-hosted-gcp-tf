resource "google_compute_instance" "roi_instance" {
  name         = "valohai-roi"
  machine_type = "e2-medium"    # TODO which machine type?
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.roi_image
      size = 16
      type = "pd-ssd"
    }
    
  }

  network_interface {
    network = var.roi_network
  }

}
