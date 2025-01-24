locals {
  tags = {
    Terraform  = "true"
  }
}

data "aws_region" "region" {}
data "aws_caller_identity" "current" {}

# SQS queue
resource "aws_sqs_queue" "sentinel" {
  name = var.queue_name

  sqs_managed_sse_enabled = true

  policy = templatefile("${path.module}/iam_policies/allow-sqs-s3.tpl.json",
    {
      queue_name = var.queue_name
      bucket_arn = aws_s3_bucket.sentinel_logs.arn
  })
}
