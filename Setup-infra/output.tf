output "runner-ip" {
  value = aws_instance.arctiq_instance.public_ip
}

data "terraform_remote_state" "arctiqvpc" {
  backend = "s3"
  config = {
    bucket = "berlin32-dev-31"
    key    = "vpc/terraform.tfstate"
    region = "eu-north-1"
  }
}