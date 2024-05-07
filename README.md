# Terraform AWS Lambda Go Packer

Utility Terraform module that builds a Go binary and zips it up for use in an AWS Lambda function.

> [!IMPORTANT]
> This module assumes that you're using the `provided.al2023` or `provided.al2` runtimes. These runtimes require that the Go binary is named `bootstrap`, therefore this module produces a zip archive with the binary named `bootstrap`.

## Features

- Builds a Go binary and produces a zip archive.
    - With the ability to install dependencies.
- Calculates a hash of the source code, so that changes to the source code trigger a redeployment.

## Dependencies

- [Go](https://golang.org/doc/install)
- [jq](https://stedolan.github.io/jq/download/)

## Usage

```hcl
provider "aws" {
  region = "us-west-2"
}

module "example_app_archive" {
  source  = "bschaatsbergen/lambda-go-packer/aws"
  version = "0.1.1-rc1"
  source_path = "${path.module}/example-app"
  output_path = "${path.module}/example-app/example-app.zip"
}

resource "aws_iam_role" "example_app" {
  name = "example-app"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "example_app" {
  function_name    = "example-app"
  role             = aws_iam_role.example_app.arn
  runtime          = "provided.al2023"
  handler          = "bootstrap" // Runtime: `provided.al2023` requires the handler to be `bootstrap`
  filename         = module.example_app_archive.output_path
  source_code_hash = module.example_app_archive.source_code_hash
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_external"></a> [external](#provider\_external) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [archive_file.zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [external_external.build](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architecture"></a> [architecture](#input\_architecture) | CPU architecture to compile for. | `string` | `"amd64"` | no |
| <a name="input_install_dependencies"></a> [install\_dependencies](#input\_install\_dependencies) | Whether to install dependencies. | `bool` | `true` | no |
| <a name="input_output_path"></a> [output\_path](#input\_output\_path) | Path to output archive. | `string` | n/a | yes |
| <a name="input_source_path"></a> [source\_path](#input\_source\_path) | Path to source code. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output_path"></a> [output\_path](#output\_output\_path) | Path to the output archive. |
| <a name="output_source_code_hash"></a> [source\_code\_hash](#output\_source\_code\_hash) | Base64-encoded SHA256 hash of the source code. |
<!-- END_TF_DOCS -->