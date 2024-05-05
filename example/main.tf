provider "aws" {
  region = "us-west-2"
}

module "archive" {
  source      = "../"
  source_path = "${path.module}/my-app"
  output_path = "${path.module}/my-app/my-app.zip"
}

resource "aws_iam_role" "example" {
  name = "example"

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

resource "aws_lambda_function" "example" {
  function_name    = "example"
  role             = aws_iam_role.example.arn
  runtime          = "provided.al2023"
  handler          = "bootstrap" // Runtime: `provided.al2023` requires the handler to be `bootstrap`
  filename         = module.archive.output_path
  source_code_hash = module.archive.source_code_hash
}
