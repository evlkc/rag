#!/bin/bash
set -e

LAMBDA_DIRS=("embedder" "query")

for dir in "${LAMBDA_DIRS[@]}"; do
  echo "🔧 Building Lambda: $dir"
  cd "modules/lambda/$dir" || exit 1

  rm -f *_with_deps.zip
  find . -type d -name '__pycache__' -exec rm -rf {} +
  find . -type d -name '*.dist-info' -exec rm -rf {} +
  find . -type d -name '*.egg-info' -exec rm -rf {} +
  find . -type f ! \( -name 'lambda_function.py' -o -name '*.tf' -o -name '*.zip' \) -delete

  python3 -m pip install opensearch-py requests_aws4auth -t .
  zip_name="${dir}_lambda_with_deps.zip"
  zip -r "$zip_name" . > /dev/null

  echo "✅ $zip_name created."
  cd - > /dev/null || exit 1
done

echo "🎉 All Lambda .zip files ready!"
