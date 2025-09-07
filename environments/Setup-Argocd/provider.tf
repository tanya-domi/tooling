provider "aws" {
  region = "eu-north-1"
}

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31"
    }
  }

  backend "s3" {
    bucket = "berlin32-dev-46"
    key    = "Dev/runner/terraform.tfstate"
    region = "eu-north-1"
  }
}


