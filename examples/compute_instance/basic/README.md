# Basic Compute Instance

Minimal example that provisions a `google_compute_instance` using all default
values: `e2-micro` machine type, Debian 11 boot disk on `pd-standard`, no
public IP, and the `default` VPC network.

## Usage

```bash
terraform init -backend=false
terraform validate
```
