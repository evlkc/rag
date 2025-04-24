variable "lambda_role_arn" {
  description = "IAM role ARN for Lambda execution"
  type        = string
}

variable "opensearch_host" {
  description = "OpenSearch endpoint"
  type        = string
}

variable "opensearch_secret_id" {
  description = "Secret Manager ID for OpenSearch credentials"
  type        = string
}
