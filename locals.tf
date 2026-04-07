# ============================================================================
# Compute Instance Module - Locals
# ============================================================================

locals {
  instance_name = "${var.project_code}-${var.compute_instance_config.base_name}-${var.compute_instance_config.zone}-${var.environment}"
}
