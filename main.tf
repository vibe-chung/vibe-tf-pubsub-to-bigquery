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
  name    = var.pubsub_topic
  project = var.project_id

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
  table_id   = var.bigquery_table
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  project    = var.project_id

  schema = <<EOF
[
  {"name": "message", "type": "STRING"},
  {"name": "attributes", "type": "STRING"},
  {"name": "event_time", "type": "TIMESTAMP"},
  {"name": "duration", "type": "INTEGER"},
  {"name": "message_id", "type": "STRING"},
  {"name": "publish_time", "type": "TIMESTAMP"},  
  {"name": "subscription_name", "type": "STRING"},
  {"name": "data", "type": "STRING"}
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
  name    = "${var.pubsub_topic}-subscription"
  topic   = google_pubsub_topic.topic.name
  project = var.project_id

  depends_on = [
    google_project_service.pubsub,
    google_project_service.bigquery,
    google_bigquery_table_iam_member.pubsub_default_writer,
    google_bigquery_table_iam_member.pubsub_default_metadata_viewer
  ]

  bigquery_config {
    table               = "${var.project_id}:${google_bigquery_dataset.dataset.dataset_id}.${google_bigquery_table.table.table_id}"
    use_topic_schema    = false
    write_metadata      = true
    drop_unknown_fields = true
  }

  ack_deadline_seconds = 60
}

