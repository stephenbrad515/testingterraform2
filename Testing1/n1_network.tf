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