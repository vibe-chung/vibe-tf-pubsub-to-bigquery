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
  schema_settings {
    schema = google_pubsub_schema.event_schema.id
    encoding = "JSON"
  }
}

resource "google_pubsub_schema" "event_schema" {
  name     = "oyster-event-schema-v2"
  project  = var.project_id
  type     = "AVRO"
  definition = <<EOF
{
  "type": "record",
  "name": "Journey",
  "namespace": "com.example.transport",
  "fields": [
    {
      "name": "date",
      "type": "string",
      "doc": "The date of the journey (required)."
    },
    {
      "name": "start_time",
      "type": "string",
      "doc": "The start time of the journey (required)."
    },
    {
      "name": "end_time",
      "type": "string",
      "doc": "The end time of the journey (required)."
    },
    {
      "name": "journey_action",
      "type": "string",
      "doc": "A description of the action taken (required)."
    },
    {
      "name": "charge",
      "type": "string",
      "doc": "The charge amount (required). Mapped to 'double'."
    },
    {
      "name": "credit",
      "type": "string",
      "doc": "The credit amount (required). Mapped to 'double'."
    },
    {
      "name": "balance",
      "type": "string",
      "doc": "The resulting balance (required). Mapped to 'double'."
    },
    {
      "name": "note",
      "type": "string",
      "doc": "Any additional note for the journey (required)."
    }
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
  table_id   = var.bigquery_table
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  project    = var.project_id

  schema = <<EOF
[
  {
    "name": "date",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "The date of the journey."
  },
  {
    "name": "start_time",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "The start time of the journey."
  },
  {
    "name": "end_time",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "The end time of the journey."
  },
  {
    "name": "journey_action",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "A description of the action taken."
  },
  {
    "name": "charge",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": "The charge amount. NUMERIC is preferred over FLOAT64 for financial data."
  },
  {
    "name": "credit",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": "The credit amount. NUMERIC is preferred over FLOAT64 for financial data."
  },
  {
    "name": "balance",
    "type": "NUMERIC",
    "mode": "NULLABLE",
    "description": "The resulting balance. NUMERIC is preferred over FLOAT64 for financial data."
  },
  {
    "name": "note",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "Any additional note for the journey."
  },
  {
    "name": "message_id",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "The unique ID of the Pub/Sub message."
  },
  {
    "name": "publish_time",
    "type": "TIMESTAMP",
    "mode": "NULLABLE",
    "description": "The time the message was published to Pub/Sub."
  },
  {
    "name": "attributes",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "A JSON string of any custom Pub/Sub message attributes."
  },
  {
    "name": "subscription_name",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "The name of the Pub/Sub subscription that delivered the message."
  }
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
  topic   = google_pubsub_topic.topic.id
  project = var.project_id

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

