import json
import os
from datetime import datetime, timezone


def lambda_handler(event, context):
    bucket_name = os.environ.get("BUCKET_NAME", "unknown")

    print("bedrock-asset-processor invoked")
    print(json.dumps(event))

    processed = []
    for record in event.get("Records", []):
        s3 = record.get("s3", {})
        processed.append({
            "bucket": s3.get("bucket", {}).get("name", bucket_name),
            "key": s3.get("object", {}).get("key"),
            "eventTime": record.get("eventTime"),
        })

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "Asset event processed successfully",
            "bucket": bucket_name,
            "processed": processed,
            "processedAt": datetime.now(timezone.utc).isoformat()
        })
    }
