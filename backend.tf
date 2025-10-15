terraform {
  backend "gcs" {
    prefix  = "oyster.tfstate"
  }
}
