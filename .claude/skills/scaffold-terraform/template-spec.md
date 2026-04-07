# Terraform Template Specification

Generate these files in the `/` directory:

**main.tf:** _(delegate to `tf-mod-main` skill)_

- Google Compute Instance using the `google_compute_instance` resource
- Follow the GCP provider reference and core authoring patterns from the `tf-mod-main` skill

**locals.tf:**

A map type variable must be created from the input variable and the instance name must be in the following format:

```text
<project_code>-<base_name>-<zone>-<environment>
```

**variables.tf:** _(delegate to `tf-mod-vars` skill)_

Use the `tf-mod-vars` skill to author this file. Apply the GCP provider reference and validation patterns. The variable schema is:

| Variable | Type | Required | Notes |
| --- | --- | --- | --- |
| `environment` | `string` | Yes | One of: `devl`, `test`, `prod` |
| `project_code` | `string` | Yes | Short identifier for naming standardization |
| `region` | `string` | No | Default: `us-central1` |
| `compute_instance_config` | `object` | Yes | See attribute table below |

`compute_instance_config` attributes:

| Attribute | Type | Required | Default | Validation |
| --- | --- | --- | --- | --- |
| `base_name` | `string` | Yes | — | Alphanumeric or dashes, max length ≤ 30 |
| `machine_type` | `string` | No | `e2-micro` | Valid GCP machine type (e.g. `e2-micro`, `n1-standard-2`) |
| `zone` | `string` | No | `us-central1-a` | Valid GCP zone format `<region>-[a-f]` |
| `boot_disk` | `object` | No | `{}` | See boot_disk sub-attributes below |
| `network_interface` | `object` | No | `{}` | See network_interface sub-attributes below |
| `labels` | `map(string)` | No | `{}` | Lowercase keys and values |
| `metadata` | `map(string)` | No | `{}` | Instance metadata key/value pairs |
| `tags` | `list(string)` | No | `[]` | Network tags for firewall rules |
| `deletion_protection` | `bool` | No | `false` | Prevent accidental deletion |
| `allow_stopping_for_update` | `bool` | No | `true` | Allow instance stop for in-place updates |

`boot_disk` sub-attributes:

| Attribute | Type | Required | Default |
| --- | --- | --- | --- |
| `image` | `string` | No | `debian-cloud/debian-11` |
| `size` | `number` | No | `10` |
| `type` | `string` | No | `pd-standard` |

`network_interface` sub-attributes:

| Attribute | Type | Required | Default |
| --- | --- | --- | --- |
| `network` | `string` | No | `default` |
| `subnetwork` | `string` | No | `null` |
| `assign_public_ip` | `bool` | No | `false` |

**outputs.tf:**

- Outputs for all standard Google Compute Instance attributes:
  - `instance_id`
  - `instance_name`
  - `self_link`
  - `instance_ip`


**versions.tf:**

- Versions.tf should be in the following format

```hcl

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.23.0"
    }
  }
}

provider "google" {
  region = var.region
}
```

**examples/:** _(delegate to `tf-mod-examples` skill)_

Use the `tf-mod-examples` skill to scaffold the full example matrix. Each example must be a self-contained, independently validatable Terraform configuration under `examples/<name>/` with its own `main.tf`, `variables.tf`, `terraform.tfvars`, and `README.md`.

**test/:**

- `test/compute_instance_basic_test.go`: This Terratest tests the basic compute instance configuration.

**package.json:**

- `github/workflows/ci.yaml`: This is the CI Pipeline. Add all the tests in the terratest job.

Ensure the name is always the repository name.

**package-lock.json:**

Ensure the name is always the repository name.

**CONTRIBUTING.md:**

Ensure in the CONTRIBUTING.md, Reporting Issues must always links to the current repository.

**README.md:** _(delegate to `tf-mod-readme` skill)_

Use the `tf-mod-readme` skill to generate this file. The skill will:

- Auto-resolve the repository name from the current git root
- Check and create the gist badge file if missing
- Populate all badge URLs pointing to the current repository
- Produce terraform-docs-compatible inputs/outputs tables
- Follow markdownlint rules (MD060 table column style)
