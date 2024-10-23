data "google_project" "project" {}
resource "google_service_account" "valohai_sa_master" {
  account_id   = "valohai-sa-master"
  display_name = "valohai-sa-master"
  description = "Used by Valohai to manage VM resources in the project"
}

resource "google_service_account_key" "valohai_master_key" {
  service_account_id = google_service_account.valohai_sa_master.name
}

resource "google_project_iam_custom_role" "valohai_master_role" {
  role_id     = "valohaiMaster"
  title       = "Valohai Master"
  description = "Used to manage Valohai related resources"

  permissions = [
    "compute.disks.create",
    "compute.disks.delete",
    "compute.disks.setLabels",
    "compute.instances.create",
    "compute.instances.delete",
    "compute.instances.list",
    "compute.instances.setLabels",
    "compute.instances.setMetadata",
    "compute.instances.setServiceAccount",
    "compute.instances.setTags",
    "compute.subnetworks.use",
    "compute.subnetworks.useExternalIp"
  ]
}

resource "google_project_iam_member" "valohai_sa_master_binding" {
  project = var.project
  role   = google_project_iam_custom_role.valohai_master_role.id

  member  = "serviceAccount:${google_service_account.valohai_sa_master.email}"
  condition {
    title       = "Only Valohai managed resources"
    description = "Compute create, set and delete permissions on Valohai owned resources"
    expression  = "resource.name.extract('instances/{name}').startsWith('valohai') || resource.name.extract('disks/{name}').startsWith('valohai') || resource.name.extract('subnetworks/{name}').startsWith('valohai')"
  }
}


resource "google_project_iam_member" "valohai_secret_binding" {
  project = var.project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.valohai_sa_master.email}"
  condition {
    title       = "Only Valohai secrets"
    description = "Access to Valohai redis password and the SA key"
    expression  = "resource.name.startsWith('projects/${data.google_project.project.number}/secrets/valohai_redis_password') || resource.name.startsWith('projects/${data.google_project.project.number}/secrets/valohai_master_sa')"
  }
}

resource "google_storage_bucket_iam_member" "valohai_data" {
  bucket = "valohai-data-${data.google_project.project.number}"
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.valohai_sa_master.email}"
}

resource "google_project_iam_member" "valohai_compute_viewer" {
  project = var.project
  role   = "roles/compute.viewer"
  member  = "serviceAccount:${google_service_account.valohai_sa_master.email}"
}

resource "google_project_iam_member" "valohai_sa_user" {
  project = var.project
  role   = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.valohai_sa_master.email}"
}

resource "google_secret_manager_secret" "valohai_master_sa" {
  secret_id = "valohai_master_sa"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "valohai_master_sa_version" {
  secret = google_secret_manager_secret.valohai_master_sa.id
  secret_data = google_service_account_key.valohai_master_key.private_key
}


resource "google_service_account_iam_binding" "valohai-imperssonate-master" {
  service_account_id = google_service_account.valohai_sa_master.name
  role               = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:${var.valohai_email}"
  ]
}
