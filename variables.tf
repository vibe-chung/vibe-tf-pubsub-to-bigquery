variable "project_id" {
  description = "The GCP project ID"
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

variable "bigquery_table" {
  description = "The name of the BigQuery table"
  type        = string
}