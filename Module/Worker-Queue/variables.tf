variable "project" {
    type = string
}

variable "region" {
    type = string
    default = "europe-west1"
}

variable "zone" {
    type = string
    default = "europe-west1-b"
}

variable "queue_address" {
    type = string
    description = "The address of the Valohai queue. You can get this from your Valohai contact"
}

variable "vpc" {
    type = string
}
