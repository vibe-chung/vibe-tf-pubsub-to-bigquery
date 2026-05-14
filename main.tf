locals {
  starling = {
    name        = "starling"
    avro_schema = <<EOF
{
  "type": "record",
  "name": "starling",
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
    { "name": "index", "type": "int", "doc": "The index of the record." }
  ]
}
EOF
    bq_schema   = <<EOF
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
  { "name": "index", "type": "INTEGER", "mode": "NULLABLE", "description": "The index of the record." },
  { "name": "message_id", "type": "STRING", "mode": "NULLABLE", "description": "The unique ID of the Pub/Sub message." },
  { "name": "publish_time", "type": "TIMESTAMP", "mode": "NULLABLE", "description": "The time the message was published to Pub/Sub." },
  { "name": "attributes", "type": "STRING", "mode": "NULLABLE", "description": "A JSON string of any custom Pub/Sub message attributes." },
  { "name": "subscription_name", "type": "STRING", "mode": "NULLABLE", "description": "The name of the Pub/Sub subscription that delivered the message." }
]
EOF
  }
  amex = {
    name        = "amex"
    avro_schema = <<EOF
{
  "type": "record",
  "name": "amex",
  "namespace": "org.github.vibechung.banking",
  "fields": [
    { "name": "address", "type": "string", "doc": "The address of the merchant or transaction." },
    { "name": "amount", "type": "string", "doc": "The transaction amount as a string." },
    { "name": "appears_on_your_statement_as", "type": "string", "doc": "How the transaction appears on your statement." },
    { "name": "category", "type": "string", "doc": "The transaction category." },
    { "name": "country", "type": "string", "doc": "The country of the transaction." },
    { "name": "date", "type": "string", "doc": "The date of the transaction (YYYY-MM-DD)." },
    { "name": "description", "type": "string", "doc": "The transaction description." },
    { "name": "extended_details", "type": "string", "doc": "Any extended details for the transaction." },
    { "name": "filename", "type": "string", "doc": "The filename of the statement." },
    { "name": "index", "type": "int", "doc": "The index of the record." },
    { "name": "postcode", "type": "string", "doc": "The postcode of the merchant or transaction." },
    { "name": "reference", "type": "string", "doc": "The reference for the transaction." },
    { "name": "town_city", "type": "string", "doc": "The town or city of the merchant or transaction." }
  ]
}
EOF
    bq_schema   = <<EOF
[
  { "name": "address", "type": "STRING", "mode": "NULLABLE", "description": "The address of the merchant or transaction." },
  { "name": "amount", "type": "NUMERIC", "mode": "NULLABLE", "description": "The transaction amount." },
  { "name": "appears_on_your_statement_as", "type": "STRING", "mode": "NULLABLE", "description": "How the transaction appears on your statement." },
  { "name": "category", "type": "STRING", "mode": "NULLABLE", "description": "The transaction category." },
  { "name": "country", "type": "STRING", "mode": "NULLABLE", "description": "The country of the transaction." },
  { "name": "date", "type": "STRING", "mode": "NULLABLE", "description": "The date of the transaction (YYYY-MM-DD)." },
  { "name": "description", "type": "STRING", "mode": "NULLABLE", "description": "The transaction description." },
  { "name": "extended_details", "type": "STRING", "mode": "NULLABLE", "description": "Any extended details for the transaction." },
  { "name": "filename", "type": "STRING", "mode": "NULLABLE", "description": "The filename of the statement." },
  { "name": "index", "type": "INTEGER", "mode": "NULLABLE", "description": "The index of the record." },
  { "name": "postcode", "type": "STRING", "mode": "NULLABLE", "description": "The postcode of the merchant or transaction." },
  { "name": "reference", "type": "STRING", "mode": "NULLABLE", "description": "The reference for the transaction." },
  { "name": "town_city", "type": "STRING", "mode": "NULLABLE", "description": "The town or city of the merchant or transaction." },
  { "name": "message_id", "type": "STRING", "mode": "NULLABLE", "description": "The unique ID of the Pub/Sub message." },
  { "name": "publish_time", "type": "TIMESTAMP", "mode": "NULLABLE", "description": "The time the message was published to Pub/Sub." },
  { "name": "attributes", "type": "STRING", "mode": "NULLABLE", "description": "A JSON string of any custom Pub/Sub message attributes." },
  { "name": "subscription_name", "type": "STRING", "mode": "NULLABLE", "description": "The name of the Pub/Sub subscription that delivered the message." }
]
EOF
  }
  monzo = {
    name        = "monzo"
    avro_schema = <<EOF
{
  "type": "record",
  "name": "monzo",
  "namespace": "org.github.vibechung.banking",
  "fields": [
    { "name": "address", "type": "string", "doc": "The address related to the transaction." },
    { "name": "amount", "type": "string", "doc": "The transaction amount as a string." },
    { "name": "category", "type": "string", "doc": "The transaction category." },
    { "name": "category_split", "type": "string", "doc": "The category split if any." },
    { "name": "currency", "type": "string", "doc": "The transaction currency." },
    { "name": "date", "type": "string", "doc": "The date of the transaction (YYYY-MM-DD)." },
    { "name": "description", "type": "string", "doc": "The transaction description." },
    { "name": "emoji", "type": "string", "doc": "Emoji associated with the transaction." },
    { "name": "filename", "type": "string", "doc": "The filename of the statement." },
    { "name": "index", "type": "int", "doc": "The index of the record." },
    { "name": "local_amount", "type": "string", "doc": "The local amount as a string." },
    { "name": "local_currency", "type": "string", "doc": "The local currency." },
    { "name": "money_in", "type": "string", "doc": "Money in as a string." },
    { "name": "money_out", "type": "string", "doc": "Money out as a string." },
    { "name": "name", "type": "string", "doc": "Name associated with the transaction." },
    { "name": "notes_and_tags", "type": "string", "doc": "Notes and tags for the transaction." },
    { "name": "receipt", "type": "string", "doc": "Receipt information." },
    { "name": "stmt_type", "type": "string", "doc": "Statement type." },
    { "name": "time", "type": "string", "doc": "The time of the transaction (HH:MM:SS)." },
    { "name": "transaction_id", "type": "string", "doc": "The transaction ID." },
    { "name": "type", "type": "string", "doc": "The type of transaction." }
  ]
}
EOF
    bq_schema   = <<EOF
[
  { "name": "address", "type": "STRING", "mode": "NULLABLE", "description": "The address related to the transaction." },
  { "name": "amount", "type": "NUMERIC", "mode": "NULLABLE", "description": "The transaction amount." },
  { "name": "category", "type": "STRING", "mode": "NULLABLE", "description": "The transaction category." },
  { "name": "category_split", "type": "STRING", "mode": "NULLABLE", "description": "The category split if any." },
  { "name": "currency", "type": "STRING", "mode": "NULLABLE", "description": "The transaction currency." },
  { "name": "date", "type": "STRING", "mode": "NULLABLE", "description": "The date of the transaction (YYYY-MM-DD)." },
  { "name": "description", "type": "STRING", "mode": "NULLABLE", "description": "The transaction description." },
  { "name": "emoji", "type": "STRING", "mode": "NULLABLE", "description": "Emoji associated with the transaction." },
  { "name": "filename", "type": "STRING", "mode": "NULLABLE", "description": "The filename of the statement." },
  { "name": "index", "type": "INTEGER", "mode": "NULLABLE", "description": "The index of the record." },
  { "name": "local_amount", "type": "NUMERIC", "mode": "NULLABLE", "description": "The local amount." },
  { "name": "local_currency", "type": "STRING", "mode": "NULLABLE", "description": "The local currency." },
  { "name": "money_in", "type": "NUMERIC", "mode": "NULLABLE", "description": "Money in." },
  { "name": "money_out", "type": "NUMERIC", "mode": "NULLABLE", "description": "Money out." },
  { "name": "name", "type": "STRING", "mode": "NULLABLE", "description": "Name associated with the transaction." },
  { "name": "notes_and_tags", "type": "STRING", "mode": "NULLABLE", "description": "Notes and tags for the transaction." },
  { "name": "receipt", "type": "STRING", "mode": "NULLABLE", "description": "Receipt information." },
  { "name": "stmt_type", "type": "STRING", "mode": "NULLABLE", "description": "Statement type." },
  { "name": "time", "type": "STRING", "mode": "NULLABLE", "description": "The time of the transaction (HH:MM:SS)." },
  { "name": "transaction_id", "type": "STRING", "mode": "NULLABLE", "description": "The transaction ID." },
  { "name": "type", "type": "STRING", "mode": "NULLABLE", "description": "The type of transaction." },
  { "name": "message_id", "type": "STRING", "mode": "NULLABLE", "description": "The unique ID of the Pub/Sub message." },
  { "name": "publish_time", "type": "TIMESTAMP", "mode": "NULLABLE", "description": "The time the message was published to Pub/Sub." },
  { "name": "attributes", "type": "STRING", "mode": "NULLABLE", "description": "A JSON string of any custom Pub/Sub message attributes." },
  { "name": "subscription_name", "type": "STRING", "mode": "NULLABLE", "description": "The name of the Pub/Sub subscription that delivered the message." }
]
EOF
  }
  monzo_flex = {
    name        = "monzo-flex"
    avro_schema = <<EOF
{
  "type": "record",
  "name": "monzo_flex",
  "namespace": "org.github.vibechung.banking",
  "fields": [
    { "name": "address", "type": "string", "doc": "The address related to the transaction." },
    { "name": "amount", "type": "string", "doc": "The transaction amount as a string." },
    { "name": "category", "type": "string", "doc": "The transaction category." },
    { "name": "category_split", "type": "string", "doc": "The category split if any." },
    { "name": "currency", "type": "string", "doc": "The transaction currency." },
    { "name": "date", "type": "string", "doc": "The date of the transaction (YYYY-MM-DD)." },
    { "name": "description", "type": "string", "doc": "The transaction description." },
    { "name": "emoji", "type": "string", "doc": "Emoji associated with the transaction." },
    { "name": "filename", "type": "string", "doc": "The filename of the statement." },
    { "name": "index", "type": "int", "doc": "The index of the record." },
    { "name": "local_amount", "type": "string", "doc": "The local amount as a string." },
    { "name": "local_currency", "type": "string", "doc": "The local currency." },
    { "name": "money_in", "type": "string", "doc": "Money in as a string." },
    { "name": "money_out", "type": "string", "doc": "Money out as a string." },
    { "name": "name", "type": "string", "doc": "Name associated with the transaction." },
    { "name": "notes_and_tags", "type": "string", "doc": "Notes and tags for the transaction." },
    { "name": "receipt", "type": "string", "doc": "Receipt information." },
    { "name": "stmt_type", "type": "string", "doc": "Statement type." },
    { "name": "time", "type": "string", "doc": "The time of the transaction (HH:MM:SS)." },
    { "name": "transaction_id", "type": "string", "doc": "The transaction ID." },
    { "name": "type", "type": "string", "doc": "The type of transaction." }
  ]
}
EOF
    bq_schema   = <<EOF
[
  { "name": "address", "type": "STRING", "mode": "NULLABLE", "description": "The address related to the transaction." },
  { "name": "amount", "type": "NUMERIC", "mode": "NULLABLE", "description": "The transaction amount." },
  { "name": "category", "type": "STRING", "mode": "NULLABLE", "description": "The transaction category." },
  { "name": "category_split", "type": "STRING", "mode": "NULLABLE", "description": "The category split if any." },
  { "name": "currency", "type": "STRING", "mode": "NULLABLE", "description": "The transaction currency." },
  { "name": "date", "type": "STRING", "mode": "NULLABLE", "description": "The date of the transaction (YYYY-MM-DD)." },
  { "name": "description", "type": "STRING", "mode": "NULLABLE", "description": "The transaction description." },
  { "name": "emoji", "type": "STRING", "mode": "NULLABLE", "description": "Emoji associated with the transaction." },
  { "name": "filename", "type": "STRING", "mode": "NULLABLE", "description": "The filename of the statement." },
  { "name": "index", "type": "INTEGER", "mode": "NULLABLE", "description": "The index of the record." },
  { "name": "local_amount", "type": "NUMERIC", "mode": "NULLABLE", "description": "The local amount." },
  { "name": "local_currency", "type": "STRING", "mode": "NULLABLE", "description": "The local currency." },
  { "name": "money_in", "type": "NUMERIC", "mode": "NULLABLE", "description": "Money in." },
  { "name": "money_out", "type": "NUMERIC", "mode": "NULLABLE", "description": "Money out." },
  { "name": "name", "type": "STRING", "mode": "NULLABLE", "description": "Name associated with the transaction." },
  { "name": "notes_and_tags", "type": "STRING", "mode": "NULLABLE", "description": "Notes and tags for the transaction." },
  { "name": "receipt", "type": "STRING", "mode": "NULLABLE", "description": "Receipt information." },
  { "name": "stmt_type", "type": "STRING", "mode": "NULLABLE", "description": "Statement type." },
  { "name": "time", "type": "STRING", "mode": "NULLABLE", "description": "The time of the transaction (HH:MM:SS)." },
  { "name": "transaction_id", "type": "STRING", "mode": "NULLABLE", "description": "The transaction ID." },
  { "name": "type", "type": "STRING", "mode": "NULLABLE", "description": "The type of transaction." },
  { "name": "message_id", "type": "STRING", "mode": "NULLABLE", "description": "The unique ID of the Pub/Sub message." },
  { "name": "publish_time", "type": "TIMESTAMP", "mode": "NULLABLE", "description": "The time the message was published to Pub/Sub." },
  { "name": "attributes", "type": "STRING", "mode": "NULLABLE", "description": "A JSON string of any custom Pub/Sub message attributes." },
  { "name": "subscription_name", "type": "STRING", "mode": "NULLABLE", "description": "The name of the Pub/Sub subscription that delivered the message." }
]
EOF
  }
  santander = {
    name        = "santander"
    avro_schema = <<EOF
{
  "type": "record",
  "name": "santander",
  "namespace": "org.github.vibechung.banking",
  "fields": [
    { "name": "balance", "type": "string", "doc": "The account balance as a string." },
    { "name": "date", "type": "string", "doc": "The date of the transaction (YYYY-MM-DD)." },
    { "name": "description", "type": "string", "doc": "The transaction description." },
    { "name": "filename", "type": "string", "doc": "The filename of the statement." },
    { "name": "index", "type": "int", "doc": "The index of the record." },
    { "name": "money_in", "type": "string", "doc": "Money in as a string." },
    { "name": "money_out", "type": "string", "doc": "Money out as a string." }
  ]
}
EOF
    bq_schema   = <<EOF
[
  { "name": "balance", "type": "NUMERIC", "mode": "NULLABLE", "description": "The account balance." },
  { "name": "date", "type": "STRING", "mode": "NULLABLE", "description": "The date of the transaction (YYYY-MM-DD)." },
  { "name": "description", "type": "STRING", "mode": "NULLABLE", "description": "The transaction description." },
  { "name": "filename", "type": "STRING", "mode": "NULLABLE", "description": "The filename of the statement." },
  { "name": "index", "type": "INTEGER", "mode": "NULLABLE", "description": "The index of the record." },
  { "name": "money_in", "type": "NUMERIC", "mode": "NULLABLE", "description": "Money in." },
  { "name": "money_out", "type": "NUMERIC", "mode": "NULLABLE", "description": "Money out." },
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

module "pubsub_bigquery_starling" {
  source           = "./modules/pubsub_bigquery"
  project_id       = var.project_id
  project_number   = var.project_number
  bigquery_dataset = google_bigquery_dataset.dataset.dataset_id
  key              = local.starling.name
  schema_name      = "${local.starling.name}-v4"
  avro_schema      = local.starling.avro_schema
  bq_schema        = local.starling.bq_schema
}

module "pubsub_bigquery_amex" {
  source           = "./modules/pubsub_bigquery"
  project_id       = var.project_id
  project_number   = var.project_number
  bigquery_dataset = google_bigquery_dataset.dataset.dataset_id
  key              = local.amex.name
  schema_name      = "${local.amex.name}-v1"
  avro_schema      = local.amex.avro_schema
  bq_schema        = local.amex.bq_schema
}

module "pubsub_bigquery_monzo" {
  source           = "./modules/pubsub_bigquery"
  project_id       = var.project_id
  project_number   = var.project_number
  bigquery_dataset = google_bigquery_dataset.dataset.dataset_id
  key              = local.monzo.name
  schema_name      = "${local.monzo.name}-v1"
  avro_schema      = local.monzo.avro_schema
  bq_schema        = local.monzo.bq_schema
}

module "pubsub_bigquery_monzo_flex" {
  source           = "./modules/pubsub_bigquery"
  project_id       = var.project_id
  project_number   = var.project_number
  bigquery_dataset = google_bigquery_dataset.dataset.dataset_id
  key              = local.monzo_flex.name
  schema_name      = "${local.monzo_flex.name}-v1"
  avro_schema      = local.monzo_flex.avro_schema
  bq_schema        = local.monzo_flex.bq_schema
}

module "pubsub_bigquery_santander" {
  source           = "./modules/pubsub_bigquery"
  project_id       = var.project_id
  project_number   = var.project_number
  bigquery_dataset = google_bigquery_dataset.dataset.dataset_id
  key              = local.santander.name
  schema_name      = "${local.santander.name}-v1"
  avro_schema      = local.santander.avro_schema
  bq_schema        = local.santander.bq_schema
}
