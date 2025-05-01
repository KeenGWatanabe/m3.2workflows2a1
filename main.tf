provider "aws" {
  region = "us-east-1"
}


terraform {
  required_version = ">= 1.3.0" # Added to satisfy terraform_required_version rule
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Added to satisfy terraform_required_providers rule
    }
  }

  backend "s3" {
    bucket = "ce9g4.tfstate-backend.com"
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-state-locks"
  }
}

data "aws_caller_identity" "current" {}

locals {
  name_prefix = "${split("/", data.aws_caller_identity.current.arn)[1]}" # Removed deprecated interpolation
  account_id  = "${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket" "s3_tf" {
  bucket = "${local.name_prefix}-s3-tf-bkt-${local.account_id}" # This is acceptable string concatenation
  
}