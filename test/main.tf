provider "aws" {
  region = "us-west-2"
}

module "example_app_archive" {
  source      = "../"
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
