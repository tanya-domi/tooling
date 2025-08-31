resource "aws_s3_bucket" "backend" {
  bucket = "berlin32-${lower(var.env)}-${random_integer.backend.result}"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}


resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.backend.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "random_integer" "backend" {
  min = 1
  max = 50
  keepers = {
    Environment = var.env
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.backend.id
  versioning_configuration {
    status = var.versioning
  }
}