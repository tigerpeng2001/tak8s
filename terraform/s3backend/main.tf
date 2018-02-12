provider "aws" {}

module "data" {
  source = "../data"
}

resource "aws_dynamodb_table" "dynamodb-terraform-lock" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "Terraform Lock Table"
  }
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "terraform-states-${module.data.account_id}-${module.data.region}"
  acl    = "private"

  tags {
    Name        = "tfstate bucket"
    Environment = "Sandbox"
  }
}
