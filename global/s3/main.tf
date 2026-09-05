
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_account_public_access_block" "access_public" {
  block_public_acls = true
  block_public_policy = true
}

resource "aws_s3_bucket" "example" {
    bucket = "terraform-up-and-running-maghsood"
    lifecycle {
      prevent_destroy = true
    }
}

resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.example.id
    versioning_configuration {
      status = "Enabled"
    }
  
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
    bucket = aws_s3_bucket.example.id

    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  
}

resource "aws_dynamodb_table" "dynamodb_table" {
    name = "terraform_up_and_running_lock_table"
    hash_key = "LockID"
    billing_mode   = "PAY_PER_REQUEST"
    
    attribute {
      name = "LockID"
      type = "S"
    }
    
  
}

