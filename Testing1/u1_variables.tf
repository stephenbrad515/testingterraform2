variable "project_id" {
  description = "The GCP Project ID"
  type        = string
  default = "testingterraform2"
}

variable "region" {
  description = "The region to deploy resources in"
  type        = string
  default     = "us-east4"
}

variable "zone" {
  description = "The zone to deploy the VM in"
  type        = string
  default     = "us-east4-a"
}

variable "machine_type" {
  description = "The size of the VM"
  type        = string
  default     = "e2-medium"
}

variable "ubuntu_image" {
  description = "The OS image to use"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2204-lts"
}
/*
variable "ssh_user" {
  description = "The username for SSH access"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public SSH key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
*/