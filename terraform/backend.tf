# terraform {
#   required_providers {
#     random = {
#       source  = "hashicorp/random"
#       version = "~> 3.5"
#     }
#   }
# }

# resource "random_pet" "this" {
#   length = 2
# }

# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "${var.cluster_name}-terraform-state-${random_pet.this.id}"

#   tags = {
#     Name = "${var.cluster_name}-Terraform-State"
#   }
# }

# resource "aws_s3_bucket_versioning" "terraform_state" {
#   bucket = aws_s3_bucket.terraform_state.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
#   bucket = aws_s3_bucket.terraform_state.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }

# resource "aws_s3_bucket_public_access_block" "terraform_state" {
#   bucket                  = aws_s3_bucket.terraform_state.id
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "${var.cluster_name}-terraform-locks"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name = "${var.cluster_name}-Terraform-Locks"
#   }
# }

# We will uncomment it after the S3 bucket and DynamoDB table are created

# terraform {
#   backend "s3" {
#     # Replace this with the name of your bucket
#     bucket         = aws_s3_bucket.terraform_state.id
#     key            = "eks/terraform.tfstate"
#     region         = var.region
#     # Replace this with the name of your DynamoDB table
#     dynamodb_table = aws_dynamodb_table.terraform_locks.name
#     encrypt        = true
#   }
# }
