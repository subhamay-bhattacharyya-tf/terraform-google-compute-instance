module "compute_instance" {
  source = "../../.."

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  compute_instance_config = {
    base_name    = var.base_name
    machine_type = "n1-standard-2"
    zone         = "us-central1-a"
  }
}
