#!/bin/bash
set -e

echo "🧹 Cleaning up .terraform, __pycache__, old ZIPs..."

# Remove local Terraform state, cache, and Python artifacts
find . -name ".terraform" -type d -exec rm -rf {} +
find . -name "__pycache__" -type d -exec rm -rf {} +
find . -name "*.zip" -type f -exec rm -f {} +
find . -name "*.egg-info" -type d -exec rm -rf {} +

echo "📦 Rebuilding Lambda ZIPs with dependencies..."

for dir in embedder query; do
  cd modules/lambda/$dir || exit 1

  echo "🔁 Packaging $dir Lambda..."
  python3 -m pip install opensearch-py requests_aws4auth -t . > /dev/null

  zip_name="${dir}_lambda_with_deps.zip"
  zip -r "$zip_name" . > /dev/null

  echo "✅ $zip_name built."
  cd - > /dev/null
done

echo "🗃️ Zipping project (excluding .terraform, state files, and build junk)..."

zip -r terraform-rag-template-secure-govcloud.zip . \
  -x "*.terraform/*" \
     "*.terraform" \
     "*__pycache__/*" \
     "*.tfstate*" \
     "*.DS_Store" \
     "*.egg-info/*" \
     "*.log"

echo "🎉 Final ZIP ready: terraform-rag-template-secure-govcloud.zip"
