output "instance_name" {
  description = "The name of the Compute Instance."
  value       = module.compute_instance.instance_name
}

output "self_link" {
  description = "The URI of the Compute Instance."
  value       = module.compute_instance.self_link
}

output "instance_ip" {
  description = "The internal IP address of the Compute Instance."
  value       = module.compute_instance.instance_ip
}
