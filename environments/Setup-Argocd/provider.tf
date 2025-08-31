provider "aws" {
  region = "eu-north-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "berlin32-dev-27"
    key    = "Dev/runner/terraform.tfstate"
    region = "eu-north-1"
}
}