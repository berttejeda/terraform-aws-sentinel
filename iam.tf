locals {
  sentinel_policies = [
    "AmazonSQSReadOnlyAccess",
    "AmazonS3ReadOnlyAccess",
    "AWSCloudTrail_ReadOnlyAccess",
    aws_iam_policy.sentinel_allow_kms.name,
    aws_iam_policy.sentinel_allow_sqs.name,
  ]
}

resource "aws_iam_policy" "sentinel_allow_kms" {
  name        = "AllowSentinelKMS"
  description = "Policy to allow sentinel to encrypt and decrypt data with kms key"

  policy = templatefile(
    "${path.module}/iam_policies/allow-sentinel-kms.tpl.json",
    {
      account_id = var.account_id
    }
  )
}

resource "aws_iam_policy" "sentinel_allow_sqs" {
  name        = "AllowSentinelSQS"
  description = "Policy to allow sentinel to get and delete messages in SQS"

  policy = templatefile(
    "${path.module}/iam_policies/allow-sentinel-sqs.tpl.json",
    {
      sqs_queue_arn = aws_sqs_queue.sentinel.arn
    }
  )
}

// Allows Azure Sentinel to assume the role that this policy is attached to
data "aws_iam_policy_document" "sentinel_role_trust_policy" {
  statement {
    principals {
      type = "AWS"
      identifiers = [
        "${var.sentinel_servcie_account_id}",
      ]
    }

    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    condition {
      test     = "StringEquals"
      values   = ["${var.sentinel_workspace_id}"]
      variable = "sts:ExternalId"
    }

  }
}

resource "aws_iam_role" "sentinel" {
  name = "MicrosoftSentinelRole"

  assume_role_policy = data.aws_iam_policy_document.sentinel_role_trust_policy.json
}


data "aws_iam_policy" "sentinel" {
  count = length(local.sentinel_policies)
  name  = local.sentinel_policies[count.index]

  depends_on = [
    aws_iam_policy.sentinel_allow_kms,
    aws_iam_policy.sentinel_allow_sqs,
  ]
}

resource "aws_iam_role_policy_attachment" "sentinel" {
  count      = length(local.sentinel_policies)
  role       = aws_iam_role.sentinel.name
  policy_arn = data.aws_iam_policy.sentinel[count.index].arn
}