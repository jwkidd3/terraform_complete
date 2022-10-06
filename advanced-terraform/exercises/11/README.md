# Exercise 11: Testing & Terratest (30m)
Testing is a very important part of the deployment workflow. It's alwasy a good idea to test your code to avoid problems in production, but doing this with infrastructure it's not common. Or at least it wasn't until IaC came into the scene. Terraform is working on running tests natively, but as you can imagine, there are many providers and each provider is very different. It's difficult to provide a framework that works for everyone, but HashiCorp is working on that. What I'm trying to say is that everything that you learn today for testing, might change in the future, so stay tuned to what HashiCorp does and what the community projects that we'll see today too.

So, let's get started with a very simple test using the Terraform CLI.

## Terraform Test
We'll start by using the `terraform test` feature, but for this, you need to start by creating the proper directory structure.

Let's start by creating a folder for this exercise, and then within that folder, create the `tests` folder. For every group of tests that you create (Terraform files with the `test_` prefix, like `tests_default.tf`), you'll create a subdirectory, like a `default` directory where you'll place all your default tests (or smoke tests). In othe words, your directory structure should look like this:

```
├── 101
│   ├── tests
│   │   └── default
│   │       ├── tests_default.tf
│   main.tf
```

In the root `main.tf` file, use the following code:

```
variable "api_url" {
  description = "A URL that you would like to test"
  type = string
}

output "api_url" {
  value = var.api_url
}
```

Then, for the `tests/default/tests_default.tf` use the following code:

```
terraform {
  required_providers {
      test = {
          source = "terraform.io/builtin/test"
      }

      http = {
          source = "hashicorp/http"
      }
  }
}

variable "api_url" {
  type = string
  default = "http://msn.com"
}

module "main" {
    source = "../.."
    api_url = var.api_url    
}

locals {
  api_url_parts = regex(
    "^(?:(?P<scheme>[^:/?#]+):)?(?://(?P<authority>[^/?#]*))?",
    module.main.api_url,
  )
}

resource "test_assertions" "api_url" {
  
  component = "api_url" // which thing is being tested

  // if got == want ? success : failure
  equal "scheme" {
    description = "default scheme is https"
    got         = local.api_url_parts.scheme
    want        = "https"
  }

  // if port number comes in the URL
  check "port_number" {
    description = "default port number is 8080"
    condition   = can(regex(":8080$", local.api_url_parts.authority))
  }
}

// query that URL and get the response from that request
data "http" "api_response" {
  // at least these "tests" need to be true
  depends_on = [
    test_assertions.api_url,
  ]

  // stores the result in this variable
  url = module.main.api_url
}

// test that a valid JSON has returned
resource "test_assertions" "api_response" {
  component = "api_response"

  check "valid_json" {
    description = "base URL responds with valid JSON"
    condition   = can(jsondecode(data.http.api_response.body)) // executes successfully or not?
  }
}
```

Go to the root directory of the project, and run:

```
terraform test
```

You should see some tests failing, try your best to fix them and continue with the next assignment.

## Terratest in AWS
Let's give it a try to the Terratest tool. To use Terratest beyond the `Hello World!` examples you need to have experience in developing applications in Go. In this exercise, we're simply going to run some examples and see how Terratest works and what's capable of doing. However, you do need to be able to install and configure Go in your workstation, otherwise you won't be able to complete this lab.

Start by configuring Go, there's a really nice [guide you can follow at the Microsoft docs site](https://docs.microsoft.com/en-us/learn/modules/go-get-started/2-install-go). **DO NOT PROCEED UNTIL YOU HAVE GO RUNNING IN YOUR WORKSTATION**

Let's create the files and directories to run the basic example of using Terratest with AWS. Remember, you need to continue using any credentials mechanism you've been using for the other labs. Terratest will simply run Terraform commands for you in an automated way. So, create a folder structure (and the files too, empty for now) like the one bellow:

```
├── 200
│   ├── hello-terratest
│   │   └── main.tf
│   ├── tests
│   │   └── tf_hello_world_test.go
```

The difference here is that you don't necessarily need to follow a standard convention in the folders, but you do need to follow a naming convention for the *.go files, they need to have the `_test` suffix so that the Go CLI recognize these files as tests to run.

For the `hello-terratest/main.tf` we'll keep it very simple now, use this code:

```
output "hello_world" {
  value = "Hello, World!"
}
```

For the `tests/tf_hello_world_test.go` use the following code:

```
package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformHelloWorldExample(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: "../hello-terratest",
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables and check they have the expected values.
	output := terraform.Output(t, terraformOptions, "hello_world")
	assert.Equal(t, "Hello, World!", output)
}
```

Notice how in the `TerraformDir` parameter we're indicating that the Terraform code we want to test is located at the parent folder.

Make sure you're in the tests folder, and run the following commands to install all the dependencies needed:

```
go mod init helloterratest
go get github.com/gruntwork-io/terratest/modules/terraform
go get github.com/gruntwork-io/terratest/modules/aws@v0.36.3
go get github.com/stretchr/testify/assert@v1.4.0
```

Now you should be able to run the following command in the tests folder:

```
go test -v
```

If everything works, you should see in the output how Terratest is running Terraform commands on your behalf and testing the code.

## Terratest for S3
Let's practice a little bit more by testing a project that uses AWS S3.

Create a similar directory (and files) structure like before:

```
├── s3
│   ├── module
│   │   └── main.tf
│   ├── tests
│   │   └── tf_module_test.go
```

For the `s3/module/main.tf` file, use the following code:

```
provider "aws" {
  region = var.region
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = [local.aws_account_id]
      type        = "AWS"
    }
    actions   = ["*"]
    resources = ["${aws_s3_bucket.test_bucket.arn}/*"]
  }

  statement {
    effect = "Deny"
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    actions   = ["*"]
    resources = ["${aws_s3_bucket.test_bucket.arn}/*"]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false",
      ]
    }
  }
}

resource "aws_s3_bucket" "test_bucket_logs" {
  bucket = "${local.aws_account_id}-${var.tag_bucket_name}-logs"
  acl    = "log-delivery-write"

  tags = {
    Name        = "${local.aws_account_id}-${var.tag_bucket_name}-logs"
    Environment = var.tag_bucket_environment
  }

  force_destroy = true
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "${local.aws_account_id}-${var.tag_bucket_name}"
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.test_bucket_logs.id
    target_prefix = "TFStateLogs/"
  }

  tags = {
    Name        = var.tag_bucket_name
    Environment = var.tag_bucket_environment
  }
}

resource "aws_s3_bucket_policy" "bucket_access_policy" {
  count  = var.with_policy ? 1 : 0
  bucket = aws_s3_bucket.test_bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

data "aws_caller_identity" "current" { }

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}

variable "region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "with_policy" {
  description = "If set to `true`, the bucket will be created with a bucket policy."
  type        = bool
  default     = false
}

variable "tag_bucket_name" {
  description = "The Name tag to set for the S3 Bucket."
  type        = string
  default     = "Test Bucket"
}

variable "tag_bucket_environment" {
  description = "The Environment tag to set for the S3 Bucket."
  type        = string
  default     = "Test"
}

output "bucket_id" {
  value = aws_s3_bucket.test_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.test_bucket.arn
}

output "logging_target_bucket" {
  value = tolist(aws_s3_bucket.test_bucket.logging)[0].target_bucket
}

output "logging_target_prefix" {
  value = tolist(aws_s3_bucket.test_bucket.logging)[0].target_prefix
}
```

For the `tests/tf_module_test.go` use the following code:

```
package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// An example of how to test the Terraform module in examples/terraform-aws-s3-example using Terratest.
func TestTerraformAwsS3Example(t *testing.T) {
	t.Parallel()

	// Give this S3 Bucket a unique ID for a name tag so we can distinguish it from any other Buckets provisioned
	// in your AWS account
	expectedName := fmt.Sprintf("terratest-aws-s3-example-%s", strings.ToLower(random.UniqueId()))

	// Give this S3 Bucket an environment to operate as a part of for the purposes of resource tagging
	expectedEnvironment := "Automated Testing"

	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)

	// Construct the terraform options with default retryable errors to handle the most common retryable errors in
	// terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../module",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"tag_bucket_name":        expectedName,
			"tag_bucket_environment": expectedEnvironment,
			"with_policy":            "true",
			"region":                 awsRegion,
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	bucketID := terraform.Output(t, terraformOptions, "bucket_id")

	// Verify that our Bucket has versioning enabled
	actualStatus := aws.GetS3BucketVersioning(t, awsRegion, bucketID)
	expectedStatus := "Enabled"
	assert.Equal(t, expectedStatus, actualStatus)

	// Verify that our Bucket has a policy attached
	aws.AssertS3BucketPolicyExists(t, awsRegion, bucketID)

	// Verify that our bucket has server access logging TargetBucket set to what's expected
	loggingTargetBucket := aws.GetS3BucketLoggingTarget(t, awsRegion, bucketID)
	expectedLogsTargetBucket := fmt.Sprintf("%s-logs", bucketID)
	loggingObjectTargetPrefix := aws.GetS3BucketLoggingTargetPrefix(t, awsRegion, bucketID)
	expectedLogsTargetPrefix := "TFStateLogs/"

	assert.Equal(t, expectedLogsTargetBucket, loggingTargetBucket)
	assert.Equal(t, expectedLogsTargetPrefix, loggingObjectTargetPrefix)
}
```

Make sure you're in the tests folder, and run the following commands:

```
go mod init helloterratest
go get github.com/gruntwork-io/terratest/modules/terraform
go get github.com/gruntwork-io/terratest/modules/aws@v0.36.3
go get github.com/stretchr/testify/assert@v1.4.0
```

Then, run the test command in Go:

```
go test -v
```

Give it a look to the console output and read the Go code to understand what's happening.

Let your instructor know when you're done.