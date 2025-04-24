
import json
import boto3
import os
from opensearchpy import OpenSearch

# Initialize clients
secretsmanager = boto3.client("secretsmanager", region_name="us-gov-west-1")
bedrock = boto3.client("bedrock-runtime", region_name="us-gov-west-1")

# Retrieve OpenSearch credentials from Secrets Manager
def get_opensearch_credentials(secret_name="opensearch-credentials"):
    secret_response = secretsmanager.get_secret_value(SecretId=secret_name)
    secret_data = json.loads(secret_response["SecretString"])
    return secret_data["username"], secret_data["password"]

# Initialize OpenSearch connection using secrets
username, password = get_opensearch_credentials()

opensearch = OpenSearch(
    hosts=[{"host": os.environ["OPENSEARCH_HOST"], "port": 443}],
    http_auth=(username, password),
    use_ssl=True
)

def embed_query(query_text):
    response = bedrock.invoke_model(
        modelId="amazon.titan-embed-text-v1",
        contentType="application/json",
        body=json.dumps({ "inputText": query_text })
    )
    return json.loads(response["body"].read())["embedding"]

def generate_answer(context, query):
    prompt = (
        "You are a helpful assistant. Use the following context to answer the question.\n\n"
        f"Context:\n{context}\n\n"
        f"Question: {query}\nAnswer:"
    )

    response = bedrock.invoke_model(
        modelId="anthropic.claude-v2",
        contentType="application/json",
        accept="application/json",
        body=json.dumps({
            "prompt": prompt,
            "max_tokens_to_sample": 500,
            "temperature": 0.5
        })
    )
    result = json.loads(response["body"].read())
    return result.get("completion", "").strip()

def lambda_handler(event, context):
    query = event["queryStringParameters"]["q"]
    query_vector = embed_query(query)

    search_response = opensearch.search(
        index="govcloud-secure-rag",
        body={
            "size": 3,
            "query": {
                "knn": {
                    "embedding": {
                        "vector": query_vector,
                        "k": 3
                    }
                }
            }
        }
    )

    context_texts = "\n".join([hit["_source"]["text"] for hit in search_response["hits"]["hits"]])
    answer = generate_answer(context_texts, query)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "question": query,
            "answer": answer
        })
    }
