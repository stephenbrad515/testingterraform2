resource "google_storage_bucket" "static_site" {
  name          = var.bucket_name
  location      = var.region
  storage_class = var.storage_class
  project       = var.project_id

  # Force destroy allows terraform to delete the bucket even if it has files in it
  force_destroy = true

  # Prevents accidental deletion of older versions of files
  versioning {
    enabled = true
  }

  # Automatically move files to Nearline storage after 30 days to save money
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
}



output "bucket_url" {
  value       = google_storage_bucket.static_site.url
  description = "The URI of the created bucket"
}