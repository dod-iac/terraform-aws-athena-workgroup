## Usage

Creates an AWS Athena workgroup that encrypts results server-side.

```hcl
module "athena_workgroup" {
  source = "dod-iac/athena-workgroup/aws"

  name = format("app-%s-%s", var.application, var.environment)
  output_location = format("s3://%s/", var.bucket_name)
  tags  = {
    Application = var.application
    Environment = var.environment
    Automation  = "Terraform"
  }
}
```

Creates an AWS Athena workgroup that encrypts results server-side using a KMS key.

```hcl
module "s3_kms_key" {
  source = "dod-iac/s3-kms-key/aws"

  name = format("alias/app-%s-s3-%s", var.application, var.environment)
  description = format("A KMS key used to encrypt objects at rest in S3 for %s:%s.", var.application, var.environment)
  principals = ["*"]
  tags = {
    Application = var.application
    Environment = var.environment
    Automation  = "Terraform"
  }
}

module "athena_workgroup" {
  source = "dod-iac/athena-workgroup/aws"

  encryption_option = "SSE_KMS"
  kms_key_arn = module.s3_kms_key.aws_kms_key_arn
  name = format("app-%s-%s", var.application, var.environment)
  output_location = format("s3://%s/", var.bucket_name)
  tags  = {
    Application = var.application
    Environment = var.environment
    Automation  = "Terraform"
  }
}
```

## Terraform Version

Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.

Terraform 0.11 and 0.12 are not supported.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | >= 2.55.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.55.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_athena_workgroup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_workgroup) |
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_iam_account_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_account_alias) |
| [aws_partition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bytes\_scanned\_cutoff\_per\_query | Integer for the upper data usage limit (cutoff) for the amount of bytes a single query in a workgroup is allowed to scan. Must be at least 10485760. | `number` | `-1` | no |
| description | The description of the workgroup.  Defaults to "The workgroup for [NAME]." | `string` | `""` | no |
| enabled | Whether the workgroup is enabled. | `bool` | `true` | no |
| encryption\_option | Indicates type of encryption used, either SSE\_S3, SSE\_KMS, or CSE\_KMS. | `string` | `"SSE_S3"` | no |
| enforce\_workgroup\_configuration | Boolean whether the settings for the workgroup override client-side settings. | `bool` | `true` | no |
| execution_role | The arn of the role to run as for the workgroup. | `string` | `null` | no |
| kms\_key\_arn | For SSE\_KMS and CSE\_KMS, this is the KMS key Amazon Resource Name (ARN). | `string` | `""` | no |
| name | The name of the AWS IAM policy. | `string` | n/a | yes |
| output\_location | The location in Amazon S3 where your query results are stored, such as s3://path/to/query/bucket/. | `string` | n/a | yes |
| publish\_cloudwatch\_metrics\_enabled | Boolean whether Amazon CloudWatch metrics are enabled for the workgroup. | `bool` | `true` | no |
| tags | Tags applied to the workgroup. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The Amazon Resource Name (ARN) of the workgroup. |
| id | The id of the workgroup. |
