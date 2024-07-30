/**
 * ## Usage
 *
 * Creates an AWS Athena workgroup that encrypts results server-side.
 *
 * ```hcl
 * module "athena_workgroup" {
 *   source = "dod-iac/athena-workgroup/aws"
 *
 *   name = format("app-%s-%s", var.application, var.environment)
 *   output_location = format("s3://%s/", var.bucket_name)
 *   tags  = {
 *     Application = var.application
 *     Environment = var.environment
 *     Automation  = "Terraform"
 *   }
 * }
 * ```
 *
 * Creates an AWS Athena workgroup that encrypts results server-side using a KMS key.
 *
 * ```hcl
 * module "s3_kms_key" {
 *   source = "dod-iac/s3-kms-key/aws"
 *
 *   name = format("alias/app-%s-s3-%s", var.application, var.environment)
 *   description = format("A KMS key used to encrypt objects at rest in S3 for %s:%s.", var.application, var.environment)
 *   principals = ["*"]
 *   tags = {
 *     Application = var.application
 *     Environment = var.environment
 *     Automation  = "Terraform"
 *   }
 * }
 *
 * module "athena_workgroup" {
 *   source = "dod-iac/athena-workgroup/aws"
 *
 *   encryption_option = "SSE_KMS"
 *   kms_key_arn = module.s3_kms_key.aws_kms_key_arn
 *   name = format("app-%s-%s", var.application, var.environment)
 *   output_location = format("s3://%s/", var.bucket_name)
 *   tags  = {
 *     Application = var.application
 *     Environment = var.environment
 *     Automation  = "Terraform"
 *   }
 * }
 * ```
 *
 * ## Terraform Version
 *
 * Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.
 *
 * Terraform 0.11 and 0.12 are not supported.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 */

data "aws_caller_identity" "current" {}

data "aws_iam_account_alias" "current" {}

data "aws_region" "current" {}

data "aws_partition" "current" {}

resource "aws_athena_workgroup" "main" {

  name        = var.name
  description = length(var.description) > 0 ? var.description : format("The workgroup for %s.", var.name)
  state       = var.enabled ? "ENABLED" : "DISABLED"

  configuration {
    bytes_scanned_cutoff_per_query     = var.bytes_scanned_cutoff_per_query > 0 ? var.bytes_scanned_cutoff_per_query : null
    enforce_workgroup_configuration    = var.enforce_workgroup_configuration
    publish_cloudwatch_metrics_enabled = var.publish_cloudwatch_metrics_enabled
    execution_role                     = var.execution_role

    result_configuration {
      output_location = var.output_location

      encryption_configuration {
        encryption_option = var.encryption_option
        kms_key_arn       = length(var.kms_key_arn) > 0 ? var.kms_key_arn : null
      }
    }
  }

  tags = var.tags
}
