resource "aws_s3_bucket" "claims_bucket" {
  bucket = "${var.project_name}-${var.environment}-claims-${substr(data.aws_caller_identity.current.account_id, 0, 6)}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
    }
  }

  lifecycle_rule {
    id      = "cleanup"
    enabled = true
    expiration {
      days = 7
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-claims"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.claims_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
