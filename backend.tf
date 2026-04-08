terraform {
  backend "gcs" {
    prefix  = "banking.tfstate"
  }
}
