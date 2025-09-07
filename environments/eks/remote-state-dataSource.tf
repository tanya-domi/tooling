# Terraform Remote State Datasource - Remote Backend AWS S3
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "berlin32-dev-46"
    key    = "Dev/vpc/terraform.tfstate"
    region = "eu-north-1"
  }
}


