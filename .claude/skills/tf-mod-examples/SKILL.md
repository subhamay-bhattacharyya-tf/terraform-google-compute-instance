---
name: tf-mod-examples
description: >
  Generates Terraform module example configurations covering all meaningful
  combinations of input variables. Use this skill when the user asks to
  generate examples, scaffold example directories, create tfvars combinations,
  or produce a complete examples/ folder for a Terraform module. Trigger when
  the user says "generate all examples", "scaffold examples", "create example
  combinations", or "fill in the examples directory". Also trigger when the
  user shares a variables.tf and asks for example usage across all options.
---

# Terraform Module Examples — Generator Skill

This skill generates a complete `examples/` directory tree for a Terraform
module by reading `variables.tf` and producing one standalone example per
meaningful feature combination.

---

## How to Use This Skill

1. Read `variables.tf` (and `versions.tf` if present) from the current module root.
2. Identify every optional field and enumerate its allowed values from `validation` blocks or type annotations.
3. Derive the example matrix using the rules below.
4. Write each example as a self-contained directory under `examples/` with its own `main.tf`, `variables.tf`, `terraform.tfvars`, and `README.md`.

---

## Step 1 — Enumerate Axes

For each optional field in the root `compute_instance_config` object (or equivalent), record:

| Axis | Values |
|---|---|
| `machine_type` | `e2-micro`, `e2-small`, `e2-medium`, `n1-standard-1`, `n1-standard-2`, `n2-standard-2` |
| `zone` | `us-central1-a`, `us-central1-b`, `us-east1-b`, `us-west1-a` |
| `boot_disk.image` | `debian-cloud/debian-11`, `debian-cloud/debian-12`, `ubuntu-os-cloud/ubuntu-2204-lts`, `cos-cloud/cos-stable` |
| `boot_disk.type` | `pd-standard`, `pd-ssd`, `pd-balanced` |
| `boot_disk.size` | `10`, `20`, `50`, `100` |
| `network_interface.assign_public_ip` | `true`, `false` |
| `tags` | absent, present (firewall targeting) |
| `labels` | absent, present |
| `metadata` | absent, present (startup-script, ssh-keys) |
| `deletion_protection` | `true`, `false` |

---

## Step 2 — Example Matrix

Do **not** generate the full cartesian product. Instead produce these named
examples, each exercising a distinct capability or realistic deployment pattern:

| Directory | Purpose | Key axes exercised |
|---|---|---|
| `basic/` | Minimal required fields only | defaults everywhere, `e2-micro`, `pd-standard` |
| `with-ssd/` | SSD boot disk for performance | `boot_disk.type=pd-ssd`, `boot_disk.size=50` |
| `with-public-ip/` | Instance with external access | `network_interface.assign_public_ip=true` |
| `with-custom-image/` | Ubuntu LTS image | `boot_disk.image=ubuntu-os-cloud/ubuntu-2204-lts` |
| `with-container-optimized/` | Container-Optimized OS | `boot_disk.image=cos-cloud/cos-stable` |
| `with-n1-standard/` | General-purpose N1 machine | `machine_type=n1-standard-2` |
| `with-n2-standard/` | Newer N2 machine type | `machine_type=n2-standard-2` |
| `with-tags/` | Network tags for firewall rules | `tags` list with `http-server`, `https-server` |
| `with-labels/` | Resource labelling | `labels` map with env/team/cost-centre |
| `with-metadata/` | Startup script via metadata | `metadata` with `startup-script` key |
| `with-deletion-protection/` | Prevent accidental deletion | `deletion_protection=true` |
| `complete/` | All features on | ssd, public-ip, n2-standard, tags, labels, metadata, deletion-protection |

---

## Step 3 — File Structure per Example

Each example directory must contain exactly these four files:

```
examples/<name>/
├── main.tf            # module call block only — no provider block
├── variables.tf       # re-declare only the variables consumed in main.tf
├── terraform.tfvars   # concrete values for every variable in variables.tf
└── README.md          # one-paragraph description + usage snippet
```

### `main.tf` template

```hcl
module "<name>" {
  source = "../../"

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  compute_instance_config = {
    base_name    = var.base_name
    # ... only include fields relevant to this example
  }
}
```

### `variables.tf` template

```hcl
variable "environment"  { type = string }
variable "project_code" { type = string }
variable "region"       { type = string  default = "us-central1" }
variable "base_name"    { type = string }
```

### `terraform.tfvars` template

```hcl
environment  = "devl"
project_code = "demo"
region       = "us-central1"
base_name    = "<example-slug>"
```

### `README.md` template

```markdown
# <Example Title>

One sentence describing what this example demonstrates.

## Usage

\`\`\`bash
terraform init -backend=false
terraform validate
\`\`\`
```

---

## Step 4 — Validation Rules

After writing all files:

1. Run `terraform fmt -recursive examples/` to format all generated files.
2. Run `terraform init -backend=false && terraform validate` inside each example directory and report any errors.
3. Fix any errors before returning.

---

## Step 5 — Output Summary

After all files are written and validated, print a table:

| Example | Files written | Validated |
|---|---|---|
| `basic/` | 4 | ✓ |
| ... | ... | ... |
