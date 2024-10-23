resource "google_sql_database_instance" "postgres_instance" {
  name = "valohai-postgres"
  database_version = "POSTGRES_13" # TODO what version? - whatever
  region = var.region

  settings {
    tier = "db-f1-micro" # TODO which instance should this be? -> chose from AWS
    disk_autoresize = true # ?
    availability_type = "REGIONAL" # TODO needed? enables high-availability -> mark it in the readme
    
    backup_configuration {
      enabled = true
    }

    ip_configuration {
      ipv4_enabled      = true
      ssl_mode          = "ENCRYPTED_ONLY" # TODO this ok?
      private_network   = var.roi_network  # TODO private & authorized?

      authorized_networks {
        name = var.roi_network
        value = var.roi_network_cidr
      }
    }
  }
}

# TODO store it in secrets manager
resource "random_password" "db_password" {
  length = 32
  special = false
}

resource "google_sql_database" "postgres_db" {
  name = "valohai-database"
  instance = google_sql_database_instance.postgres_instance.name
}

resource "google_sql_user" "roi_user" {
  name = "roi_user"
  instance = google_sql_database_instance.postgres_instance.name
  password = random_password.db_password.result
}
