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
    #access_config {}
  }

  # Reference the external shell script
  metadata_startup_script = file("${path.module}/install_gcsfuse.sh")

metadata = {
  block-project-ssh-keys = true
}

  service_account {
      # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
      email  = "42488166641-compute@developer.gserviceaccount.com"
      scopes = ["cloud-platform"]
  }
}

//  #Outputs VM name and IP on terminal when done creating
//  output "instance_name" {
//      value = google_compute_instance.ubuntu_vm.name
//  }
//
//  output "public_ip" {
//      value = google_compute_instance.ubuntu_vm.network_interface[0].access_config[0].nat_ip
//  }
//
//  output "private_ip" {
//      value = google_compute_instance.ubuntu_vm.network_interface.0.network_ip
//}