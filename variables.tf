variable "account_id" {
  type        = string
  description = "AWS account id"
}

variable "organization_id" {
  type        = string
  description = "AWS organization id: when you integrate Sentinel to the whole organization. is_organization_trail should be true."
  default     = null
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "eu-south-1"
}

variable "sentinel_servcie_account_id" {
  type        = string
  description = "Microsoft Sentinel's service account ID for AWS."
  default     = "197857026523"
}

variable "sentinel_workspace_id" {
  type        = string
  description = "Sentinel workspece id"
  default     = null
}

variable "queue_name" {
  type        = string
  description = "SQS queue sentinel gets notification for new logs to read."
}

variable "sentinel_bucket_prefix" {
  type        = string
  description = "Naming Prefix for bucket where cloud trail logs are stored and consumed by sentinel."
}

variable "expiration_days" {
  type        = number
  description = "The lifetime, in days, of the objects that are subject to the rule."
  default     = 7
}

variable "log_retention_in_days" {
  type        = number
  description = "The lifetime, in days, of the cloudwatch log objects that are subject to the rule."
  default     = 14
}

variable "log_group_name" {
  type        = string
  description = "Cloudwatch Log Group Name"
}

variable "trail_name" {
  type        = string
  description = "Trail name with events to send to azure sentinel."
}

variable "is_organization_trail" {
  type        = bool
  description = "Whether the trail is an AWS Organizations trail. Organization trails log events for the master account and all member accounts. Can only be created in the organization master account."
  default     = false
}

variable "is_multi_region_trail" {
  type        = bool
  default     = false
  description = "Whether the trail is created in the current region or in all regions."
}