# ============================================================================
# Compute Instance Module - Outputs
# ============================================================================

output "instance_id" {
  description = "The unique identifier of the Compute Instance."
  value       = google_compute_instance.this.instance_id
}

output "instance_name" {
  description = "The name of the Compute Instance."
  value       = google_compute_instance.this.name
}

output "self_link" {
  description = "The URI of the Compute Instance."
  value       = google_compute_instance.this.self_link
}

output "instance_ip" {
  description = "The internal IP address of the Compute Instance."
  value       = google_compute_instance.this.network_interface[0].network_ip
}
