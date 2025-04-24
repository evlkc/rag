

variable "s3_bucket_prefix" {
  description = "Prefix for the S3 bucket name"
  type        = string
}

variable "opensearch_domain_name" {
  description = "OpenSearch domain name"
  type        = string
}

variable "opensearch_master_user" {
  description = "OpenSearch master user"
  type        = string
}

variable "opensearch_master_pass" {
  description = "OpenSearch master password"
  type        = string
}

# Root level variables
variable "opensearch_host" {
  description = "OpenSearch hostname"
  type        = string
}

variable "opensearch_secret_id" {
  description = "Secrets Manager ID for OpenSearch credentials"
  type        = string
}
