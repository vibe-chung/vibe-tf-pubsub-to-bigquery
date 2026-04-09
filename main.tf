# Example: define schemas for each key
locals {
  avro_schemas = {
    for k in var.keys :
    k => <<EOF
{
  "type": "record",
  "name": "${k}-v1",
  "namespace": "org.github.vibechung.banking",
  "fields": [
    { "name": "amount_gbp", "type": "string", "doc": "The transaction amount in GBP." },
    { "name": "balance_gbp", "type": "string", "doc": "The account balance in GBP after the transaction." },
    { "name": "counter_party", "type": "string", "doc": "The counter party of the transaction." },
    { "name": "date", "type": "string", "doc": "The date of the transaction (YYYY-MM-DD)." },
    { "name": "filename", "type": "string", "doc": "The filename of the statement." },
    { "name": "notes", "type": "string", "doc": "Any notes for the transaction." },
    { "name": "reference", "type": "string", "doc": "The reference for the transaction." },
    { "name": "spending_category", "type": "string", "doc": "The spending category." },
    { "name": "type", "type": "string", "doc": "The type of transaction." },
    { "name": "index", "type": "string", "doc": "The index of the record as a string." }
  ]
}
EOF
  }
  bq_schemas = {
    for k in var.keys :
    k => <<EOF
[
  { "name": "amount_gbp", "type": "NUMERIC", "mode": "NULLABLE", "description": "The transaction amount in GBP." },
  { "name": "balance_gbp", "type": "NUMERIC", "mode": "NULLABLE", "description": "The account balance in GBP after the transaction." },
  { "name": "counter_party", "type": "STRING", "mode": "NULLABLE", "description": "The counter party of the transaction." },
  { "name": "date", "type": "STRING", "mode": "NULLABLE", "description": "The date of the transaction (YYYY-MM-DD)." },
  { "name": "filename", "type": "STRING", "mode": "NULLABLE", "description": "The filename of the statement." },
  { "name": "notes", "type": "STRING", "mode": "NULLABLE", "description": "Any notes for the transaction." },
  { "name": "reference", "type": "STRING", "mode": "NULLABLE", "description": "The reference for the transaction." },
  { "name": "spending_category", "type": "STRING", "mode": "NULLABLE", "description": "The spending category." },
  { "name": "type", "type": "STRING", "mode": "NULLABLE", "description": "The type of transaction." },
  { "name": "index", "type": "STRING", "mode": "NULLABLE", "description": "The index of the record as a string." },
  { "name": "message_id", "type": "STRING", "mode": "NULLABLE", "description": "The unique ID of the Pub/Sub message." },
  { "name": "publish_time", "type": "TIMESTAMP", "mode": "NULLABLE", "description": "The time the message was published to Pub/Sub." },
  { "name": "attributes", "type": "STRING", "mode": "NULLABLE", "description": "A JSON string of any custom Pub/Sub message attributes." },
  { "name": "subscription_name", "type": "STRING", "mode": "NULLABLE", "description": "The name of the Pub/Sub subscription that delivered the message." }
]
EOF
  }
}
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "pubsub" {
  project            = var.project_id
  service            = "pubsub.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "bigquery" {
  project            = var.project_id
  service            = "bigquery.googleapis.com"
  disable_on_destroy = false
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                 = var.bigquery_dataset
  project                    = var.project_id
  location                   = var.region
  delete_contents_on_destroy = true

  depends_on = [google_project_service.bigquery]
}

# Module for each key
module "pubsub_bigquery" {
  source           = "./modules/pubsub_bigquery"
  for_each         = toset(var.keys)
  project_id       = var.project_id
  project_number   = var.project_number
  bigquery_dataset = google_bigquery_dataset.dataset.dataset_id
  key              = each.value
  avro_schema      = local.avro_schemas[each.value]
  bq_schema        = local.bq_schemas[each.value]
}

