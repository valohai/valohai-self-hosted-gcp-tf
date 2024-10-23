output "valohai_db_instance" {
  value = google_sql_database_instance.postgres_instance
}

output "valohai_db_user" {
    value = google_sql_user.roi_user
}

output "instance_connection_name" {
  value = google_sql_database_instance.postgres_instance.connection_name
}

