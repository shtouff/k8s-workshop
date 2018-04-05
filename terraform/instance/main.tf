provider "google" {
  project = "workshop-k8s-xxxxxx"
}

locals {
  region = "europe-west1"
  zone = "${local.region}-b"
}

data google_compute_network "my_vpc" {
  name = "vpc1"
}

data google_compute_subnetwork "my_subnet" {
  name = "subnet1"
  region = "${local.region}"
}

resource google_compute_instance "my_instance" {
  name = "i-mylogin"

  machine_type = "n1-standard-1"
  zone         = "${local.zone}"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = "${data.google_compute_subnetwork.my_subnet.name}"

    # needed to have public access
    access_config {
    }
  }
}

output ssh {
  value = <<EOF
Connect to ${google_compute_instance.my_instance.name} using:
gcloud compute ssh ${google_compute_instance.my_instance.name}
EOF
}
