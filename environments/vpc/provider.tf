# Terraform Provider Block
provider "aws" {
  region = "eu-north-1"
}

# Terraform Settings Block
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31"
    }
  }

  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "berlin32-dev-5"
    key    = "Dev/vpc/terraform.tfstate"
    region = "eu-north-1"
  }
}