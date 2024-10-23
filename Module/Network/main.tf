data "google_compute_network" "valohai_vpc" {
  name = var.vpc_name
}

resource "google_compute_firewall" "valohai_fr_queue_redis" {
  project     = var.project
  name        = "valohai-fr-queue-redis"
  network     = data.google_compute_network.valohai_vpc.name
  description = "Allows connection to the queue from Valohai services and valohai workers from this project"

  allow {
    protocol  = "tcp"
    ports     = ["63790"]
  }

  source_ranges = ["34.248.245.191/32", "63.34.156.112/32"] # TODO saw it in hybrid example -> app.valohai.com, scalie:prod -> fill out with created resources
  source_tags = ["valohai-worker"]
  target_tags = ["valohai-queue"]
}

resource "google_compute_firewall" "valohai_fr_queue_http" {
  project     = var.project
  name        = "valohai-fr-queue-http"
  network     = data.google_compute_network.valohai_vpc.name
  description = "Allows connections on port 80 for the letsencrypt HTTP challenge"

  allow {
    protocol  = "tcp"
    ports     = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["valohai-queue"]
}
