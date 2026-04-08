variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "project_number" {
  description = "The GCP project number"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-west1"
}

variable "pubsub_topic" {
  description = "The name of the Pub/Sub topic"
  type        = string
}

variable "bigquery_dataset" {
  description = "The name of the BigQuery dataset"
  type        = string
}

variable "keys" {
  description = "A list of keys for the resources"
  type        = list(string)
  default     = []
}
