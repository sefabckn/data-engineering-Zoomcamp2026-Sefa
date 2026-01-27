
variable "credentials" {
  description = "my credentials"
  default     = "C:/Users/afesb/Desktop/data-engineering-Zoomcamp2026-Sefa/terraform/keys/my-cred.json"
}


variable "project" {
  description = "Project"
  default     = "taxi-rides-ny-485508"
}

variable "region" {
  default = "europe-central2"
}

variable "location" {
  description = "The location information if GCS server"
  default     = "EU"
}

variable "gcs_bucket_name" {
  description = "Bucket Storage Class"
  default     = "taxi-rides-ny-485508-terra-bucket"
}

variable "bq_dataset_name" {
  default     = "demo_dataset"
  description = "My bigquery dataset name "
}


variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}



