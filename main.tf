terraform {
  backend "s3" {
    encrypt                 = true
    key                     = "networking/terraform.tfstate"
    bucket                  = "dc11-dot-van-le-networking"
    profile                 = "default"
    region                  = "us-east-1"
    dynamodb_table = "terraform-state-dynamodb-table-lock"
  }
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
}

resource "aws_s3_bucket" "terraform_state_s3_bucket" {
  bucket = "dc11-dot-van-le-networking"
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "Terraform bucket state s3"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_s3_versioning" {
  bucket = aws_s3_bucket.terraform_state_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_s3_encrytion" {
  bucket = aws_s3_bucket.terraform_state_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform-state-dynamodb-table" {
  name         = "terraform-state-dynamodb-table-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "Terraform state dynamodb table lock"
  }
}