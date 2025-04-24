
resource "aws_s3_bucket" "documents" {
  bucket = "govcloud-rag-docs-${random_id.suffix.hex}"
  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

