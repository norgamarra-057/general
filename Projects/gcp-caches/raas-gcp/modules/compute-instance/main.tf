resource "google_compute_instance" "raas" {
  name         = var.vm_name
  machine_type = var.machine_type
  project      = var.gcp_project_id
  deletion_protection = false
  zone = var.zone

  tags = ["gcp", "redis-cli"]

    boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11-bullseye-v20231212"
    }
  }

    network_interface {
    subnetwork         = local.subnetwork
    subnetwork_project = var.vpc_project_id
    }

    metadata_startup_script = file("${path.module}/../compute-instance/init.sh.tpl")
}