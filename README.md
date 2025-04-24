# Project Directory Structure

```plaintext
terraform-rag-template-secure-govcloud/
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── README.md
└── modules/
    ├── s3/
    ├── opensearch/
    └── lambda/
        ├── iam.tf
        ├── variables.tf
        ├── secrets.tf
        ├── apigateway.tf
        ├── outputs.tf
        ├── embedder/
        │   ├── lambda_function.py
        │   ├── embedder_lambda_with_deps.zip
        │   └── main.tf
        └── query/
            ├── lambda_function.py
            ├── query_with_deps.zip
            └── main.tf
```
