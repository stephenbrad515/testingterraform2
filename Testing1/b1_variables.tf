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