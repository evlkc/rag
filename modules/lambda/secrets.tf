
resource "aws_secretsmanager_secret" "opensearch_creds" {
  name = "opensearch-credentials"
  description = "Credentials for OpenSearch access from Lambda"
}

resource "aws_secretsmanager_secret_version" "opensearch_creds_version" {
  secret_id     = aws_secretsmanager_secret.opensearch_creds.id
  secret_string = jsonencode({
    username = "admin",
    password = "YourSecurePassword123!"
  })
}
