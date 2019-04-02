provider "aws" {
  version = "2.1"
  region = "eu-central-1"
}

module "api_gateway-dublin" {
  source = "modules/api_gateway"

  providers = {
    aws = "aws.dublin"
  }

  api_iam_role_arn =  "${aws_iam_role.APIRole.arn}"
  cognito_user_pool_arn = "${aws_cognito_user_pool.ApiUsers.arn}"
  region = "eu-west-1"
  stage = "${var.stage}"
  cloudwatch_arn = "${aws_iam_role.cloudwatch.arn}"
}

module "api_gateway-frankfurt" {
  source = "modules/api_gateway"

  providers = {
    aws = "aws.frankfurt"
  }

  api_iam_role_arn =  "${aws_iam_role.APIRole.arn}"
  cognito_user_pool_arn = "${aws_cognito_user_pool.ApiUsers.arn}"
  region = "eu-central-1"
  stage = "${var.stage}"
  cloudwatch_arn = "${aws_iam_role.cloudwatch.arn}"
}

terraform {
  backend "s3" {}
}
