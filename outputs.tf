output "embedder_lambda_arn" {
  value = module.embedder.embedder_lambda_arn
}

output "query_lambda_arn" {
  value = module.query.query_lambda_arn
}

output "api_endpoint" {
  value = module.query.api_endpoint
}
