terraform {
  backend "s3" {
    bucket = "berlin32-dev-46"
    key    = "Dev/eks/terraform.tfstate"
    region = "eu-north-1"
  }
}