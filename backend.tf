terraform {
  backend "gcs" {
    prefix  = "vibe-tf-pubsub-to-bigquery.tfstate"
  }
}
