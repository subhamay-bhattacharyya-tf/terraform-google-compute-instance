module "compute_instance" {
  source = "../../.."

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  compute_instance_config = {
    base_name    = var.base_name
    machine_type = "n2-standard-2"
    zone         = "us-central1-a"
    boot_disk = {
      image = "debian-cloud/debian-11"
      size  = 50
      type  = "pd-ssd"
    }
    network_interface = {
      network          = "default"
      assign_public_ip = true
    }
    tags = ["http-server", "https-server"]
    labels = {
      env         = "devl"
      team        = "platform"
      cost-centre = "engineering"
    }
    metadata = {
      startup-script = "#!/bin/bash\napt-get update -y"
    }
    deletion_protection       = false
    allow_stopping_for_update = true
  }
}
