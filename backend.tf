terraform {
  backend "gcs" {
    prefix  = "ratemy.tfstate"
  }
}
