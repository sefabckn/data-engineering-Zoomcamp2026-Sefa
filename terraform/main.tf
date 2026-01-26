terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "7.16.0"
    }
  }
}

provider "google" {
  project     = "taxi-rides-ny-485508"
  region      = "europe-central2"
}

resource "google_storage_bucket" "demo-bucket" {
  name          = "taxi-rides-ny-485508-terra-bucket"
  location      = "EU"
  force_destroy = true
  uniform_bucket_level_access = true
  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}