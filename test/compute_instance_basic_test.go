package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestComputeInstanceBasic(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/compute_instance/basic",
		Vars: map[string]interface{}{
			"environment":  "devl",
			"project_code": "test",
			"region":       "us-central1",
			"base_name":    "ci-basic",
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	instanceName := terraform.Output(t, terraformOptions, "instance_name")
	assert.NotEmpty(t, instanceName)

	selfLink := terraform.Output(t, terraformOptions, "self_link")
	assert.Contains(t, selfLink, "compute/v1/projects")

	instanceIP := terraform.Output(t, terraformOptions, "instance_ip")
	assert.NotEmpty(t, instanceIP)
}
