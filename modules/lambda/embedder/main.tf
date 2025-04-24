
resource "aws_lambda_function" "embedder" {
  function_name = "aap-govcloud-rag-embedder"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  filename         = "${path.module}/embedder_lambda_with_deps.zip"
  source_code_hash = filebase64sha256("${path.module}/embedder_lambda_with_deps.zip")
  role = var.lambda_role_arn
  environment {
    variables = {
      OPENSEARCH_HOST      = var.opensearch_host
      OPENSEARCH_SECRET_ID = var.opensearch_secret_id
    }
  }
}
