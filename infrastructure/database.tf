resource "aws_dynamodb_table" "carplates-frankfurt" {
  provider = "aws.frankfurt"
  "attribute" {
    name = "platenumber"
    type = "S"
  }
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  hash_key = "platenumber"
  name = "carPlates"
  billing_mode = "PAY_PER_REQUEST"
  tags {
    "project" = "car plates api"
  }
}

resource "aws_dynamodb_table" "carplates-dublin" {
  provider = "aws.dublin"
  "attribute" {
    name = "platenumber"
    type = "S"
  }
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  hash_key = "platenumber"
  name = "carPlates"
  billing_mode = "PAY_PER_REQUEST"
  tags {
    "project" = "car plates api"
  }
}

resource "aws_dynamodb_global_table" "GlobalTable" {
  depends_on = ["aws_dynamodb_table.carplates-dublin", "aws_dynamodb_table.carplates-frankfurt"]
  provider = "aws.frankfurt"

  name  = "carPlates"

  replica {
    region_name = "eu-central-1"
  }

  replica {
    region_name = "eu-west-1"
  }
}