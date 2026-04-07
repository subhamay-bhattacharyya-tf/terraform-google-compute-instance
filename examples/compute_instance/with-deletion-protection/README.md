# With Deletion Protection

Provisions a Compute Instance with `deletion_protection = true` to prevent
accidental `terraform destroy`. Set to `false` and re-apply before destroying.

## Usage

```bash
terraform init -backend=false
terraform validate
```
