output "sentinel_role_arn" {
  value = aws_iam_role.sentinel.arn
}

output "sentinel_queue_url" {
  value = aws_sqs_queue.sentinel.url
}