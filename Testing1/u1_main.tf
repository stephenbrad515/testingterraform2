provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name                    = "ubuntu-vpc"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "ssh_rule" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "ubuntu_vm" {
  name         = "ubuntu-server"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.ubuntu_image
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {}
  }

  # Reference the external shell script
  metadata_startup_script = file("${path.module}/install_gcsfuse.sh")
/*
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
  }
  */
}

