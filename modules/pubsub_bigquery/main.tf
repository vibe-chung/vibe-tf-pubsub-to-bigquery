resource "google_pubsub_schema" "event_schema" {
  name     = "${var.key}-v1"
  project  = var.project_id
  type     = "AVRO"
  definition = var.avro_schema
}

resource "google_pubsub_topic" "topic" {
  name    = "${var.key}-topic"
  project = var.project_id
  schema_settings {
    schema = google_pubsub_schema.event_schema.id
    encoding = "JSON"
  }
  depends_on = [google_pubsub_schema.event_schema]
}

resource "google_bigquery_table" "table" {
  table_id   = var.key
  dataset_id = var.bigquery_dataset
  project    = var.project_id

  schema = var.bq_schema

  deletion_protection = false
}

resource "google_bigquery_table_iam_member" "pubsub_default_writer" {
  project    = var.project_id
  dataset_id = var.bigquery_dataset
  table_id   = google_bigquery_table.table.table_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:service-${var.project_number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_bigquery_table_iam_member" "pubsub_default_metadata_viewer" {
  project    = var.project_id
  dataset_id = var.bigquery_dataset
  table_id   = google_bigquery_table.table.table_id
  role       = "roles/bigquery.metadataViewer"
  member     = "serviceAccount:service-${var.project_number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_pubsub_subscription" "subscription" {
  name    = "${var.key}-subscription"
  topic   = google_pubsub_topic.topic.id
  project = var.project_id

  expiration_policy {
    ttl = "7776000s" # 90 days
  }

  depends_on = [
    google_pubsub_schema.event_schema,
    google_pubsub_topic.topic,
    google_bigquery_table_iam_member.pubsub_default_writer,
    google_bigquery_table_iam_member.pubsub_default_metadata_viewer
  ]

  bigquery_config {
    table               = "${var.project_id}:${var.bigquery_dataset}.${google_bigquery_table.table.table_id}"
    use_topic_schema    = true
    write_metadata      = true
    drop_unknown_fields = true
  }

  ack_deadline_seconds = 60
}
