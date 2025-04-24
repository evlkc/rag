
resource "aws_lambda_function" "query_handler" {
  function_name = "aap-govcloud-rag-query"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  filename         = "${path.module}/query_lambda_with_deps.zip"
  source_code_hash = filebase64sha256("${path.module}/query_lambda_with_deps.zip")
  role = var.lambda_role_arn
  environment {
    variables = {
      OPENSEARCH_HOST      = var.opensearch_host
      OPENSEARCH_SECRET_ID = var.opensearch_secret_id
    }
  }
}

resource "aws_apigatewayv2_api" "query_api" {
  name          = "govcloud-rag-api"
  protocol_type = "HTTP"
}

