provider "google" {
  project = "workshop-k8s-xxxxxx"
}

locals {
  region = "europe-west1"
}

resource google_compute_network "my_net" {
  auto_create_subnetworks = false
  name = "vpc1"
}

resource "google_compute_firewall" "allow_icmp" {
  name    = "${google_compute_network.my_net.name}-allow-icmp"
  network = "${google_compute_network.my_net.name}"

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "${google_compute_network.my_net.name}-allow-ssh"
  network = "${google_compute_network.my_net.name}"

  allow {
    protocol = "tcp"
    ports    = [22]
  }
}
resource google_compute_subnetwork "my_subnet" {
  name = "subnet1"
  network = "${google_compute_network.my_net.name}"
  ip_cidr_range = "10.42.0.0/17"
  region = "${local.region}"

  secondary_ip_range {
    ip_cidr_range = "10.42.128.0/18"
    range_name = "pods"
  }
  secondary_ip_range {
    ip_cidr_range = "10.42.192.0/18"
    range_name = "svcs"
  }
}

