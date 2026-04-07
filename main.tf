# ============================================================================
# Compute Instance Module - Main
# Creates and manages a Google Compute Instance.
# ============================================================================

resource "google_compute_instance" "this" {
  name         = local.instance_name
  machine_type = var.compute_instance_config.machine_type
  zone         = var.compute_instance_config.zone

  tags   = var.compute_instance_config.tags
  labels = var.compute_instance_config.labels

  deletion_protection       = var.compute_instance_config.deletion_protection
  allow_stopping_for_update = var.compute_instance_config.allow_stopping_for_update

  boot_disk {
    initialize_params {
      image = var.compute_instance_config.boot_disk.image
      size  = var.compute_instance_config.boot_disk.size
      type  = var.compute_instance_config.boot_disk.type
    }
  }

  network_interface {
    network    = var.compute_instance_config.network_interface.network
    subnetwork = var.compute_instance_config.network_interface.subnetwork

    # Public IP — only assigned when assign_public_ip is true
    dynamic "access_config" {
      for_each = var.compute_instance_config.network_interface.assign_public_ip ? [1] : []
      content {}
    }
  }

  # Metadata (startup-script, ssh-keys, etc.) — only when non-empty
  metadata = length(var.compute_instance_config.metadata) > 0 ? var.compute_instance_config.metadata : null
}
