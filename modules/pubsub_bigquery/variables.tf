variable "avro_schema" {
  description = "The AVRO schema definition as a string."
  type        = string
}

variable "bq_schema" {
  description = "The BigQuery table schema definition as a string."
  type        = string
}
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "project_number" {
  description = "The GCP project number"
  type        = string
}

variable "bigquery_dataset" {
  description = "The name of the BigQuery dataset"
  type        = string
}

variable "key" {
  description = "The key for this resource set"
  type        = string
}

variable "schema_name" {
  description = "The name of the Pub/Sub schema"
  type        = string
}
