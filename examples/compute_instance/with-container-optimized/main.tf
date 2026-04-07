module "compute_instance" {
  source = "../../.."

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  compute_instance_config = {
    base_name = var.base_name
    boot_disk = {
      image = "cos-cloud/cos-stable"
    }
    metadata = {
      "user-data" = "#cloud-config\nruncmd:\n  - docker pull nginx\n  - docker run -d -p 80:80 nginx"
    }
  }
}
