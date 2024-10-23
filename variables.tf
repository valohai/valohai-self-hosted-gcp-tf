variable "gcp_access_token_path" {
    description = "File path for Google Cloud Platform access token"
    type        = string
}

variable "project_id" {
  description = "Google Cloud Platform Project Id"
  type        = string
}

variable "gcp_region" {
    description = "Google Cloud Platform region for Valohai resources"
    type        = string
}

variable "gcp_zone" {
    description = "Google Cloud Platform zone for Valohai resources"
    type        = string
}

variable "gcp_bucket_name" {
  description = "Unique name for GCP bucket that will be used as the default output storage for Valohai"
}