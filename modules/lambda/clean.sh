#!/bin/bash
for dir in embedder query; do
  cd $dir || continue
  find . -type d -name '__pycache__' -exec rm -rf {} +
  find . -type d -name '*.dist-info' -exec rm -rf {} +
  find . -type f ! -name 'lambda_function.py' ! -name '*.tf' ! -name '*.zip' -delete
  cd ..
done
