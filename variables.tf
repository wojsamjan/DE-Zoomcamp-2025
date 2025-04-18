variable "project" {
  description = "Project ID"
  default     = "<YOUR PROJECT ID>"
}

variable "region" {
  description = "Region"
  default     = "europe-west3"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  #Update the below to what you want your dataset to be called
  default = "dez2025_tf_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  #Update the below to a unique bucket name
  default = "<YOUR BUCKET NAME>"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}
