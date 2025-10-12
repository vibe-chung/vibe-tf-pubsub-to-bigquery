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

resource "google_service_account" "pubsub_to_bigquery" {
  account_id   = "pubsub-to-bigquery"
  display_name = "Service Account for Pub/Sub to BigQuery publishing"
}

resource "google_pubsub_topic" "topic" {
  name    = var.pubsub_topic
  project = var.project_id
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                 = var.bigquery_dataset
  project                    = var.project_id
  location                   = var.region
  delete_contents_on_destroy = true
}

resource "google_bigquery_table" "table" {
  table_id   = var.bigquery_table
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  project    = var.project_id

  schema = [
    {
      name = "message"
      type = "STRING"
    },
    {
      name = "attributes"
      type = "STRING"
    },
    {
      name = "event_time"
      type = "TIMESTAMP"
    }
    ,
    {
      name = "_metadata_message_id"
      type = "STRING"
    },
    {
      name = "_metadata_publish_time"
      type = "TIMESTAMP"
    },
    {
      name = "_metadata_subscription_name"
      type = "STRING"
    }
  ]
}

resource "google_pubsub_subscription" "subscription" {
  name    = "${var.pubsub_topic}-subscription"
  topic   = google_pubsub_topic.topic.name
  project = var.project_id

  bigquery_config {
    table               = google_bigquery_table.table.id
    use_topic_schema    = true
    write_metadata      = true
    drop_unknown_fields = true
  }

  ack_deadline_seconds = 60
}