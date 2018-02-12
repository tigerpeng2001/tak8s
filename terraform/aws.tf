module "data" {
  source = "./data"
}

provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    # terraform.backend: configuration cannot contain interpolations
    #bucket         = "terraform-states-${module.data.account-id}-${module.data.region}"
    #region         = "${module.data.region}"
    #key            = "${var.project}/terraform.tfstate"
    bucket = "terraform-states-630527842429-us-east-1"

    region = "us-east-1"
    key    = "tak8s/terraform.tfstate"

    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
