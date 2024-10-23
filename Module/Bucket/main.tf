data "google_project" "project" {
    project_id = var.project_id
}

resource "google_storage_bucket" "valohai_data" {
  project = data.google_project.project.id
  name          = "valohai-data-${data.google_project.project.number}"
  location      = var.region
  storage_class = "STANDARD"

  uniform_bucket_level_access = true

  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "OPTIONS"]
    response_header = ["Content-Type", "x-ms-*"]
    max_age_seconds = 3600
  }
    cors {
    origin          = [var.domain] # TODO how to get origin for self hosted?
    method          = ["POST", "PUT"]
    response_header = ["Content-Type", "x-ms-*"]
    max_age_seconds = 3600
  }
}


# How it works in AWS
# customer creates certificate (SSL) -> outside the template
# created certificate passed as a variable in .tf
# ssl passed to ROI

# same for domain
