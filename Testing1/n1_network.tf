# 1. Create the VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "ubuntu-vpc"
  auto_create_subnetworks = true
}

# 2. Create a Private Subnet
resource "google_compute_subnetwork" "private_subnet" {
  name          = "private-subnet"
  ip_cidr_range = "10.2.1.0/24"
  region        = "us-east4"
  network       = google_compute_network.vpc_network.id
}

# 3. Create a Cloud Router
# The NAT gateway needs a router to manage the control plane.
resource "google_compute_router" "router" {
  name    = "nat-router"
  region  = google_compute_subnetwork.private_subnet.region
  network = google_compute_network.vpc_network.id
}

# 4. Create the Cloud NAT Gateway
resource "google_compute_router_nat" "nat_gateway" {
  name                               = "main-nat-gateway"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
# 5. Create firewall rules
resource "google_compute_firewall" "ssh_rule" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
