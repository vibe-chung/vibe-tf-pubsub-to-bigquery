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

resource "google_pubsub_topic" "topic" {
  name    = "${var.keys[0]}-topic"
  project = var.project_id
  schema_settings {
    schema = google_pubsub_schema.event_schema.id
    encoding = "JSON"
  }

  depends_on = [
    google_project_service.pubsub, 
    google_pubsub_schema.event_schema
  ]
}

resource "google_pubsub_schema" "event_schema" {
  name     = "${var.keys[0]}-v3"
  project  = var.project_id
  type     = "AVRO"
  definition = <<EOF
{
  "type": "record",
  "name": "${var.keys[0]}",
  "namespace": "org.github.vibechung.ratemy",
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

  depends_on = [google_project_service.pubsub]
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                 = var.bigquery_dataset
  project                    = var.project_id
  location                   = var.region
  delete_contents_on_destroy = true

  depends_on = [google_project_service.bigquery]
}

resource "google_bigquery_table" "table" {
  table_id   = var.keys[0]
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  project    = var.project_id

  schema = <<EOF
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
  { "name": "index", "type": "INT64", "mode": "NULLABLE", "description": "The index of the record as an integer." },
  { "name": "message_id", "type": "STRING", "mode": "NULLABLE", "description": "The unique ID of the Pub/Sub message." },
  { "name": "publish_time", "type": "TIMESTAMP", "mode": "NULLABLE", "description": "The time the message was published to Pub/Sub." },
  { "name": "attributes", "type": "STRING", "mode": "NULLABLE", "description": "A JSON string of any custom Pub/Sub message attributes." },
  { "name": "subscription_name", "type": "STRING", "mode": "NULLABLE", "description": "The name of the Pub/Sub subscription that delivered the message." }
]
EOF

  deletion_protection = false

  depends_on = [google_bigquery_dataset.dataset]
}

resource "google_bigquery_table_iam_member" "pubsub_default_writer" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = google_bigquery_table.table.table_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:service-${var.project_number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_bigquery_table_iam_member" "pubsub_default_metadata_viewer" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = google_bigquery_table.table.table_id
  role       = "roles/bigquery.metadataViewer"
  member     = "serviceAccount:service-${var.project_number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_pubsub_subscription" "subscription" {
  name    = "${var.keys[0]}-subscription"
  topic   = google_pubsub_topic.topic.id
  project = var.project_id

  expiration_policy {
    ttl = "7776000s" # 90 days
  }

  depends_on = [
    google_project_service.pubsub,
    google_project_service.bigquery,
    google_bigquery_table_iam_member.pubsub_default_writer,
    google_bigquery_table_iam_member.pubsub_default_metadata_viewer
  ]

  bigquery_config {
    table               = "${var.project_id}:${google_bigquery_dataset.dataset.dataset_id}.${google_bigquery_table.table.table_id}"
    use_topic_schema    = true
    write_metadata      = true
    drop_unknown_fields = true
  }

  ack_deadline_seconds = 60
}

