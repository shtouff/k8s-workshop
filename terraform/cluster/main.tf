provider "google" {
  project = "workshop-k8s-xxxxxx"
}

locals {
  region = "europe-west1"
  zone = "${local.region}-b"
}

data google_compute_subnetwork "my_subnet" {
  region = "${local.region}"
  name = "subnet1"
}

resource "google_service_account" "my_cluster_sa" {
  account_id   = "k8s-mylogin"
  display_name = "Cluster account for mylogin"
}

resource "google_project_iam_member" "my_cluster_sa_editor_binding" {
  role   = "roles/editor"
  member = "serviceAccount:${google_service_account.my_cluster_sa.email}"
}

resource "google_container_cluster" "my_cluster" {
  name               = "k8s-mylogin"
  min_master_version = "1.9.4-gke.1"
  zone               = "${local.zone}"
  enable_legacy_abac = false
  logging_service    = "none"
  monitoring_service = "none"
  network            = "${data.google_compute_subnetwork.my_subnet.network}"
  subnetwork         = "${data.google_compute_subnetwork.my_subnet.name}"
  initial_node_count = 2

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "svcs"
  }

  node_config {
    machine_type    = "n1-standard-1"
    preemptible     = true
    service_account = "${google_service_account.my_cluster_sa.email}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

