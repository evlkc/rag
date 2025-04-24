
terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = "us-gov-west-1"
}

module "s3" {
  source = "./modules/s3"
  s3_bucket_prefix = var.s3_bucket_prefix
}

module "opensearch" {
  source = "./modules/opensearch"
  opensearch_domain_name = var.opensearch_domain_name
  opensearch_master_user = var.opensearch_master_user
  opensearch_master_pass = var.opensearch_master_pass
}

module "lambda" {
  source = "./modules/lambda"
  s3_bucket_id = module.s3.bucket_id
  opensearch_domain_name = var.opensearch_domain_name
  opensearch_host = var.opensearch_host
  opensearch_secret_id = var.opensearch_secret_id
}

module "embedder" {
  source              = "./modules/lambda/embedder"
  lambda_role_arn     = module.lambda.lambda_exec_arn
  opensearch_host     = var.opensearch_host
  opensearch_secret_id = var.opensearch_secret_id
  s3_bucket_id        = module.s3.bucket_id
}

module "query" {
  source              = "./modules/lambda/query"
  lambda_role_arn     = module.lambda.lambda_exec_arn
  opensearch_host     = var.opensearch_host
  opensearch_secret_id = var.opensearch_secret_id
}
