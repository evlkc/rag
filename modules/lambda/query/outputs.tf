output "query_lambda_arn" {
  value = aws_lambda_function.query_handler.arn
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.query_api.api_endpoint
}
