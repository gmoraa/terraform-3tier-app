# Provider & Keys
provider "aws" {
    region = "us-east-1"
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}


terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.6.0"
    }
  }
  #AWS S3 Bucket Configuration & DynamoDB
  backend "s3" {
    bucket = "giancarlo-statefile-terraform"
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-lock"
	workspace_key_prefix = "tf-state"
  }
}