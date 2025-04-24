
import json
import boto3
import os
from opensearchpy import OpenSearch, RequestsHttpConnection
from requests_aws4auth import AWS4Auth

region = "us-gov-west-1"
bedrock = boto3.client("bedrock-runtime", region_name=region)
s3 = boto3.client("s3")
textract = boto3.client("textract")
secretsmanager = boto3.client("secretsmanager")

# Load OpenSearch credentials from Secrets Manager
secret_id = os.environ["OPENSEARCH_SECRET_ID"]
secret_value = secretsmanager.get_secret_value(SecretId=secret_id)
creds = json.loads(secret_value["SecretString"])
opensearch_user = creds["username"]
opensearch_pass = creds["password"]

# Initialize OpenSearch connection
opensearch = OpenSearch(
    hosts=[{"host": os.environ["OPENSEARCH_HOST"], "port": 443}],
    http_auth=(opensearch_user, opensearch_pass),
    use_ssl=True,
    verify_certs=True,
    connection_class=RequestsHttpConnection
)

def embed_text(text):
    response = bedrock.invoke_model(
        modelId="amazon.titan-embed-text-v1",
        contentType="application/json",
        body=json.dumps({ "inputText": text })
    )
    return json.loads(response["body"].read())["embedding"]

def lambda_handler(event, context):
    try:
        record = event["Records"][0]
        bucket = record["s3"]["bucket"]["name"]
        key = record["s3"]["object"]["key"]

        s3_obj = s3.get_object(Bucket=bucket, Key=key)
        document_bytes = s3_obj["Body"].read()

        # Run Textract
        response = textract.detect_document_text(Document={'Bytes': document_bytes})
        text = " ".join([b["Text"] for b in response["Blocks"] if b["BlockType"] == "LINE"])

        # Chunk and embed
        chunks = [text[i:i+300] for i in range(0, len(text), 300)]
        for i, chunk in enumerate(chunks):
            vector = embed_text(chunk)
            doc = {
                "chunk_id": i,
                "text": chunk,
                "embedding": vector
            }
            opensearch.index(index="govcloud-rag", body=doc)

        return {
            "statusCode": 200,
            "body": json.dumps({"status": "indexed", "chunks": len(chunks)})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
