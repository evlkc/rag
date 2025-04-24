variable "lambda_role_arn" {
  description = "IAM role ARN for Lambda execution"
  type        = string
}

variable "opensearch_host" {
  description = "OpenSearch endpoint host"
  type        = string
}

variable "opensearch_secret_id" {
  description = "Secret Manager ID for OpenSearch credentials"
  type        = string
}

variable "s3_bucket_id" {
  description = "ID of the S3 bucket that triggers the embedder Lambda"
  type        = string
}
