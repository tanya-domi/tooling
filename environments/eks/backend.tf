terraform {
  backend "s3" {
    bucket = "berlin32-dev-45"
    key    = "Dev/eks/terraform.tfstate"
    region = "eu-north-1"
  }
}