terraform {
  backend "s3" {
    bucket = "berlin32-dev-31"
    key    = "eks/terraform.tfstate"
    region = "eu-north-1"
  }
}