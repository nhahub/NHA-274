# Terraform State Migration & Cleanup

## Migrating Local State to S3

### 1. Create S3 and DynamoDB resources with local state

Comment out the backend block in your `terraform` configuration:
```hcl
# terraform {
#   backend "s3" { ... }
# }
```

Create the resources:
```hcl
resource "aws_dynamodb_table" "terraform_locks" {
  # ...table config...
}

resource "aws_s3_bucket" "terraform_state" {
  # ...bucket config...
}
```

### 2. Uncomment backend block and configure

```hcl
terraform {
  backend "s3" {
    bucket         = aws_s3_bucket.terraform_state.id
    key            = "eks/terraform.tfstate"
    region         = var.region
    dynamodb_table = aws_dynamodb_table.terraform_locks.name
    encrypt        = true
  }
}
```

### 3. Migrate state

```sh
terraform init -migrate-state
```

---

## Destroy S3/DynamoDB and Migrate State Back to Local

### 1. Migrate state from S3 to local

```sh
terraform init -migrate-state -backend=false
```

### 2. Comment out backend block

```hcl
# terraform {
#   backend "s3" {
#     bucket         = aws_s3_bucket.terraform_state.id
#     key            = "eks/terraform.tfstate"
#     region         = var.region
#     dynamodb_table = aws_dynamodb_table.terraform_locks.name
#     encrypt        = true
#   }
# }
```

### 3. Reinitialize with local backend

```sh
terraform init
```

### 4. Destroy all resources (including S3 and DynamoDB)

```sh
terraform destroy
```
