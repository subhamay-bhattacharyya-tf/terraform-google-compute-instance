# ============================================================================
# Compute Instance Module - Variables
# ============================================================================

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["devl", "test", "prod"], var.environment)
    error_message = "environment must be one of: devl, test, prod."
  }
}

variable "project_code" {
  description = "Short identifier used in resource naming."
  type        = string

  validation {
    condition     = length(var.project_code) > 0
    error_message = "project_code must not be empty."
  }
}

variable "region" {
  description = "GCP region for the provider."
  type        = string
  default     = "us-central1"
}

variable "compute_instance_config" {
  description = "Configuration object for the Google Compute Instance."
  type = object({
    base_name    = string
    machine_type = optional(string, "e2-micro")
    zone         = optional(string, "us-central1-a")
    boot_disk = optional(object({
      image = optional(string, "debian-cloud/debian-11")
      size  = optional(number, 10)
      type  = optional(string, "pd-standard")
    }), {})
    network_interface = optional(object({
      network          = optional(string, "default")
      subnetwork       = optional(string, null)
      assign_public_ip = optional(bool, false)
    }), {})
    labels                    = optional(map(string), {})
    metadata                  = optional(map(string), {})
    tags                      = optional(list(string), [])
    deletion_protection       = optional(bool, false)
    allow_stopping_for_update = optional(bool, true)
  })

  validation {
    condition     = length(var.compute_instance_config.base_name) >= 1 && length(var.compute_instance_config.base_name) <= 30
    error_message = "base_name must be between 1 and 30 characters."
  }

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.compute_instance_config.base_name))
    error_message = "base_name must start with a letter, contain only lowercase letters, digits, or hyphens, and not end with a hyphen."
  }

  validation {
    condition     = contains(["pd-standard", "pd-balanced", "pd-ssd"], var.compute_instance_config.boot_disk.type)
    error_message = "boot_disk.type must be one of: pd-standard, pd-balanced, pd-ssd."
  }
}
