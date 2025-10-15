
# Pub/Sub to BigQuery Terraform Project

This project provisions GCP infrastructure to stream messages from Pub/Sub to BigQuery using Terraform.

## Features
- Creates a Pub/Sub topic with an AVRO schema:
	```json
	{
		"type": "record",
		"name": "EventMessage",
		"fields": [
			{"name": "event_time", "type": "string"},
			{"name": "duration", "type": "int"}
		]
	}
	```
- Sets up a BigQuery dataset and table with required columns for Pub/Sub integration.
- Configures IAM permissions for Pub/Sub and BigQuery service accounts.

## Usage
1. Edit `terraform.tfvars` with your project details.

2. Create a backend configuration file (e.g., `my.tfbackend`) with your bucket:
	```hcl
	bucket = "your-terraform-state-bucket"
	```

3. Initialise Terraform with the backend config file:
	```sh
	terraform init -backend-config=my.tfbackend
	terraform apply
	```

## Publishing Example
To publish a message to the topic (using gcloud):

```sh
gcloud pubsub topics publish example-topic \
	--message='{"event_time": "2025-10-12T10:06:00.000Z", "duration": 123}' \
	--project=your-gcp-project-id
```

## Notes
- The Pub/Sub topic enforces the AVRO schema above.
- BigQuery table columns must match required metadata for Pub/Sub integration.
