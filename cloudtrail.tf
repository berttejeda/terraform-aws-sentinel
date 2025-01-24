# KMS key cloudtrail ueses to encrypt logs.
resource "aws_kms_key" "sentinel_logs" {
  description              = "Kms key to entrypt cloudtrail logs."
  customer_master_key_spec = "SYMMETRIC_DEFAULT"

  policy = templatefile("${path.module}/iam_policies/allow-kms-cloudtrail.tpl.json", {
    account_id = var.account_id
    trail_name = var.trail_name
    aws_region = var.aws_region
  })
}

resource "aws_kms_alias" "sentinel_logs" {
  name          = "alias/sentinel-logs-key"
  target_key_id = aws_kms_key.sentinel_logs.id
}

# Trail to collect all managements events.
resource "aws_cloudtrail" "sentinel" {
  name                          = var.trail_name
  s3_bucket_name                = aws_s3_bucket.sentinel_logs.id # Bucket where cloud trail logs are stored and consumed by sentinel.
  include_global_service_events = true
  kms_key_id                    = aws_kms_key.sentinel_logs.arn
  is_organization_trail         = var.is_organization_trail
  is_multi_region_trail         = var.is_multi_region_trail
  enable_logging                = true
  enable_log_file_validation    = true
  cloud_watch_logs_role_arn     = aws_iam_role.s3_cloudtrail_cloudwatch_role.arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.s3_cloudwatch.arn}:*"
  event_selector {
    read_write_type                  = "All"
    include_management_events        = true
    exclude_management_event_sources = ["kms.amazonaws.com", ]
  }

  depends_on = [
    aws_s3_bucket_policy.sentinel_logs,
    aws_kms_key.sentinel_logs
  ]
}

#Create a log_group in cloudwatch for storing logs generated by cloudtrail Trail.
resource "aws_cloudwatch_log_group" "s3_cloudwatch" {
  name              = format("%s-%s-S3", aws_s3_bucket.sentinel_logs.id, data.aws_caller_identity.current.account_id)
  kms_key_id        = aws_kms_key.sentinel_logs.arn
  retention_in_days = var.log_retention_in_days
  tags = merge(
    { "Name" = format("%s-%s-S3", aws_s3_bucket.sentinel_logs.id, data.aws_caller_identity.current.account_id) },
    local.tags,
  )
}

# Create an IAM role to be attached with cloudtrail trail
resource "aws_iam_role" "s3_cloudtrail_cloudwatch_role" {
  name               = format("%s-cloudtrail-cloudwatch-S3", var.log_group_name)
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_assume_role.json
  tags = merge(
    { "Name" = format("%s-cloudtrail-cloudwatch-S3", aws_s3_bucket.sentinel_logs.id) },
    local.tags,
  )
}

#  AWS IAM policy document that allows AWS CloudTrail to assume roles for accessing AWS services.
data "aws_iam_policy_document" "cloudtrail_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

#  AWS IAM policy defining permissions for AWS CloudTrail to interact with CloudWatch Logs for S3 logging.
resource "aws_iam_policy" "s3_cloudtrail_cloudwatch_policy" {
  name   = format("%s-cloudtrail-cloudwatch-S3", var.log_group_name)
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailCreateLogStream2014110",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream"
      ],
      "Resource": [
        "arn:aws:logs:${data.aws_region.region.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_s3_bucket.sentinel_logs.id}-${data.aws_caller_identity.current.account_id}-S3:log-stream:*"
      ]
    },
    {
      "Sid": "AWSCloudTrailPutLogEvents20141101",
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:${data.aws_region.region.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_s3_bucket.sentinel_logs.id}-${data.aws_caller_identity.current.account_id}-S3:log-stream:*"
      ]
    }
  ]
}
EOF
  tags = merge(
    { "Name" = format("%s-cloudtrail-cloudwatch-S3", aws_s3_bucket.sentinel_logs.id) },
    local.tags,
  )
}

#Attach the IAM policy to the IAM role created above.
resource "aws_iam_role_policy_attachment" "s3_cloudtrail_policy_attachment" {
  role       = aws_iam_role.s3_cloudtrail_cloudwatch_role.name
  policy_arn = aws_iam_policy.s3_cloudtrail_cloudwatch_policy.arn
}