module "compute_instance" {
  source = "../../.."

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  compute_instance_config = {
    base_name = var.base_name
    metadata = {
      startup-script = "#!/bin/bash\napt-get update -y\napt-get install -y nginx\nsystemctl enable nginx\nsystemctl start nginx"
    }
    tags = ["http-server"]
  }
}
