variable "s3_bucket_id" {
  description = "ID of the S3 bucket to trigger Lambda from"
  type        = string
}

variable "opensearch_domain_name" {
  description = "Name of the OpenSearch domain"
  type        = string
}

variable "opensearch_host" {
  description = "The OpenSearch domain hostname"
  type        = string
}

variable "opensearch_secret_id" {
  description = "Name of the secret in Secrets Manager containing OpenSearch credentials"
  type        = string
}
