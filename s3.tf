# S3 bucket
resource "aws_s3_bucket" "sentinel_logs" {
  bucket = var.sentinel_bucket_prefix
  force_destroy = true
  lifecycle {
    # prevent_destroy = true
  }
}


## Set the bucket ACL private.
resource "aws_s3_bucket_acl" "sentinel_logs" {
  bucket = aws_s3_bucket.sentinel_logs.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.private_storage]
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "private_storage" {
  bucket = aws_s3_bucket.sentinel_logs.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

## Block public access.
resource "aws_s3_bucket_public_access_block" "sentinel_logs" {
  bucket                  = aws_s3_bucket.sentinel_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

## S3 policy which allow cloud trail to write logs.
resource "aws_s3_bucket_policy" "sentinel_logs" {
  bucket = aws_s3_bucket.sentinel_logs.id
  policy = templatefile("${path.module}/iam_policies/allow-s3-cloudtrail.tpl.json", {
    account_id      = var.account_id
    organization_id = var.organization_id
    bucket_name     = aws_s3_bucket.sentinel_logs.id
  })
}

## s3 lifecycle rule to delete old files.
resource "aws_s3_bucket_lifecycle_configuration" "sentinel" {
  bucket = aws_s3_bucket.sentinel_logs.bucket

  rule {
    expiration {
      days = var.expiration_days
    }
    id = "clean"

    noncurrent_version_expiration {
      noncurrent_days = 1
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }

    status = "Enabled"
  }
}

## s3 notification to SQS to notify new logs have been stored.
resource "aws_s3_bucket_notification" "sentinel" {
  bucket = aws_s3_bucket.sentinel_logs.id

  queue {
    queue_arn = aws_sqs_queue.sentinel.arn
    events    = ["s3:ObjectCreated:*"]
  }
}