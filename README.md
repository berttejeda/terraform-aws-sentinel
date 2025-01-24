# Microsoft Azure Sentinel AWS Integration

Terraform workspace which creates all resources to connect integrate your AWS account with Microsoft Azure Sentinel.

It creates all resources required for the Microsoft Sentinel AWS Connector.

Feel free to acquaint yourself with the Microsoft Sentinel Documentation
  - Connect Microsoft Sentinel to Amazon Web Services to ingest AWS service log data | Microsoft Learn
    https://learn.microsoft.com/en-us/azure/sentinel/connect-aws?tabs=s3#add-the-aws-role-and-queue-information-to-the-s3-data-connector
  - 

Lastly, this workspace is mostly code copied from:

pagopa/terraform-aws-sentinel: Terraform module to send logs to Azure Sentinel
https://github.com/pagopa/terraform-aws-sentinel

# Exampla usage

```shell
# Make sure you populate your AWS credentials beforehand
git clone https://github.com/berttejeda/terraform-aws-sentinel
cd terraform-aws-sentinel
terraform init
terraform plan
terraform apply
```

<!-- BEGIN_TF_DOCS -->
# Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0   |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

# Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.84.0 |

# Modules

No modules.

# Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.sentinel](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_log_group.s3_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.s3_cloudtrail_cloudwatch_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sentinel_allow_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sentinel_allow_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.s3_cloudtrail_cloudwatch_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.sentinel](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.s3_cloudtrail_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.sentinel](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.sentinel_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.sentinel_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.sentinel_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.sentinel_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.sentinel](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_notification.sentinel](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_ownership_controls.private_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.sentinel_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.sentinel_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_sqs_queue.sentinel](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.sentinel](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.cloudtrail_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sentinel_role_trust_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

# Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS account id | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | `"eu-south-1"` | no |
| <a name="input_expiration_days"></a> [expiration\_days](#input\_expiration\_days) | The lifetime, in days, of the objects that are subject to the rule. | `number` | `7` | no |
| <a name="input_is_multi_region_trail"></a> [is\_multi\_region\_trail](#input\_is\_multi\_region\_trail) | Whether the trail is created in the current region or in all regions. | `bool` | `false` | no |
| <a name="input_is_organization_trail"></a> [is\_organization\_trail](#input\_is\_organization\_trail) | Whether the trail is an AWS Organizations trail. Organization trails log events for the master account and all member accounts. Can only be created in the organization master account. | `bool` | `false` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | Cloudwatch Log Group Name | `string` | n/a | yes |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | The lifetime, in days, of the cloudwatch log objects that are subject to the rule. | `number` | `14` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | AWS organization id: when you integrate Sentinel to the whole organization. is\_organization\_trail should be true. | `string` | `null` | no |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | SQS queue sentinel gets notification for new logs to read. | `string` | n/a | yes |
| <a name="input_sentinel_bucket_prefix"></a> [sentinel\_bucket\_prefix](#input\_sentinel\_bucket\_prefix) | Naming Prefix for bucket where cloud trail logs are stored and consumed by sentinel. | `string` | n/a | yes |
| <a name="input_sentinel_servcie_account_id"></a> [sentinel\_servcie\_account\_id](#input\_sentinel\_servcie\_account\_id) | Microsoft Sentinel's service account ID for AWS. | `string` | `"197857026523"` | no |
| <a name="input_sentinel_workspace_id"></a> [sentinel\_workspace\_id](#input\_sentinel\_workspace\_id) | Sentinel workspece id | `string` | `null` | no |
| <a name="input_trail_name"></a> [trail\_name](#input\_trail\_name) | Trail name with events to send to azure sentinel. | `string` | n/a | yes |

# Outputs

| Name | Description |
|------|-------------|
| <a name="output_sentinel_queue_url"></a> [sentinel\_queue\_url](#output\_sentinel\_queue\_url) | n/a |
| <a name="output_sentinel_role_arn"></a> [sentinel\_role\_arn](#output\_sentinel\_role\_arn) | n/a |
<!-- END_TF_DOCS -->

# Appendix

## Enable Health and Monitoring

As per: Turn on auditing and health monitoring in Microsoft Sentinel | Microsoft Learn
https://learn.microsoft.com/en-us/azure/sentinel/enable-monitoring?tabs=azure-portal

1. Goto https://portal.azure.com/#home
2. Search for "Microsoft Sentinel"
3. Click your the workspace containing the desired instance of Sentinel
4. From the left-hand navigation menu, click "Settings"
5. From the Settings view, click the "Settings" tab
6. Under the "Audit and health monitoring" section, click the "Enable" button
7. From the left-hand navigation menu, click "Logs"
8. Close the Queries hub modal popup
9. Wait 30 minutes
9. In the query field, enter in the query `SentinelHealth | take 20`
10. If the results are empty, try waiting an additional 30 minutes to an hour

### Overview Page

![Alt text](assets/images/microsoft_sentinel_overview.png?raw=true "Micrososft Sentinel Overview")

### Sample Query

You can pull up pre-made queries. Simply search for "AWS" in this case, and click the query you want to use.

![Alt text](assets/images/microsoft_sentinel_query.png?raw=true "Micrososft Sentinel Overview")

## Uninstall Microsoft Azure

1. Goto https://portal.azure.com/#home
2. Search for "Microsoft Sentinel"
3. Click your the workspace containing the desired instance of Sentinel
4. From the left-hand navigation menu, click "Settings"
5. From the Settings view, click the "Settings" tab
6. Under the "Remove Microsoft Sentinel" section, click the "Remove Microsoft Sentinel from your workspace" button

## Troubleshooting the Azure AWS Connector

Troubleshoot AWS S3 connector issues - Microsoft Sentinel | Microsoft Learn
https://learn.microsoft.com/en-us/azure/sentinel/aws-s3-troubleshoot