variable "project_id" {
  description = "The GCP Project ID"
  type        = string
  default = "testingterraform2"
}

variable "region" {
  description = "The region for the bucket"
  type        = string
  default     = "us-east4"
}

variable "bucket_name" {
  description = "The name of the bucket (must be globally unique)"
  type        = string
  default = "thisisalongcrazyname9"
}

variable "storage_class" {
  description = "The Storage Class of the new bucket"
  type        = string
  default     = "STANDARD"
}