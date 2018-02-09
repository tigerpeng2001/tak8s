provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
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
  bucket = "sandbox-tfstate-bucket"
  acl    = "private"

  tags {
    Name        = "tfstate bucket"
    Environment = "Sandbox"
  }
}

terraform {
  backend "s3" {
    bucket         = "sandbox-terraform-tfstate"
    region         = "us-east-1"
    key            = "tak8s/terraform.tfstate"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
