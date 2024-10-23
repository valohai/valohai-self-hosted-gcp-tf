resource "google_secret_manager_secret" "redis_password" {
  secret_id = "valohai_redis_password"
  replication {
    auto {}
  }
}
resource "random_password" "password" {
  length           = 32
  special          = false
}


resource "google_secret_manager_secret_version" "valohai_redis_password" {
  secret = google_secret_manager_secret.redis_password.id
  secret_data = random_password.password.result
}

resource "google_compute_address" "valohai_ip_queue" {
  name = "valohai-ip-queue"
}


// Valohai Queue Instance
resource "google_compute_instance" "valohai_queue" {
 name         = "valohai-queue"
 machine_type = "e2-medium"
 zone         = var.zone
 tags         = ["valohai-queue"]

 boot_disk {
   initialize_params {
     image = "ubuntu-os-cloud/ubuntu-2004-lts"
     size = 16
     type = "pd-ssd"
   }
 }

// Make sure flask is installed on all new instances for later steps
 metadata_startup_script = "curl https://raw.githubusercontent.com/valohai/worker-queue/main/host/setup.sh | sudo QUEUE_ADDRESS=${var.queue_address} REDIS_PASSWORD=${random_password.password.result} bash"

 network_interface {
   network = var.vpc

    access_config {
      nat_ip = google_compute_address.valohai_ip_queue.address
    }
 }
}
