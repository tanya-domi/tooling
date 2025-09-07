# Terraform Remote State Datasource - Remote Backend AWS S3
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "berlin32-dev-46"
    key    = "Dev/eks/terraform.tfstate"
    region = var.aws_region
  }
}

