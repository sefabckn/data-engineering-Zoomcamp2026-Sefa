
variable "credentials" {
  description = "my credentials"
  default     = "./keys/my-cred.json"
}


variable "project" {
  description = "Project"
  default     = "taxi-rides-ny-485508"
}

variable "region" {
  default = "us-central1"
}

variable "location" {
  description = "The location information if GCS server"
  default     = "US"
}

variable "gcs_bucket_name" {
  description = "Bucket Storage Class"
  default     = "taxi-rides-ny-485508-terra-bucket"
}

variable "bq_dataset_name" {
  default     = "zoomcamp"
  description = "My bigquery dataset name "
}


variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}



