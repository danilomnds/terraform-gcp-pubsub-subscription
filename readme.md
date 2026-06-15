# Module - Pub/Sub Subscription
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)[![GCP](https://img.shields.io/badge/provider-GCP-green)](https://registry.terraform.io/providers/hashicorp/google/latest)

This module standardizes the creation of Pub/Sub subscriptions using Terraform.

## Compatibility Matrix

| Module Version | Terraform Version | Google Provider Version |
|----------------|------------------|------------------------|
| v1.0.0         | v1.13.0          | 6.49.2                 |
| v1.1.0         | v1.13.3          | 7.4.0                  |
| v1.2.0         | >= 1.15.5        | >= 7.35.0              |

## Release Notes

| Module Version | Note                                                                 |
|----------------|----------------------------------------------------------------------|
| v1.0.0         | Initial version                                                      |
| v1.1.0         | Updated provider to 7.4.0 and Terraform to 1.13.3                   |
| v1.2.0         | Added missing supported parameters and removed output-only input (`cloud_storage_config.state`) |

## Specifying a Version

To avoid automatically using the latest module version, specify the `?ref=***` in the source URL to pin a version (where `***` is a git tag).
Note: The `?ref=***` refers to a tag in the git module repository.

## Example: Cloud Storage Delivery

```hcl
module "pbs-name-subscription" {
  source  = "git::https://github.com/danilomnds/terraform-gcp-pubsub-subscription?ref=v1.2.0"
  project = "project_id"
  name    = "pbs-name-subscription"
  topic   = "pbs-name"

  cloud_storage_config = {
    bucket          = "bucket-name"
    filename_prefix = "folderprefix/"
    filename_suffix = ".extension"
    avro_config = {
      write_metadata = true
    }
  }

  labels = {
    system      = "system"
    environment = "fqa"
    provider    = "gcp"
    region      = "southamerica-east1"
  }
}

output "id" {
  value = module.pbs-name-subscription.id
}
```

## Example: BigQuery Delivery

```hcl
module "pbs-name-subscription" {
  source  = "git::https://github.com/danilomnds/terraform-gcp-pubsub-subscription?ref=v1.2.0"
  project = "project_id"
  name    = "pbs-name-subscription"
  topic   = "pbs-name"

  bigquery_config = {
    table               = "table-name"
    use_topic_schema    = true
    drop_unknown_fields = true
    write_metadata      = true
  }

  message_retention_duration = "604800s" # 7 days
  retain_acked_messages      = false
  ack_deadline_seconds       = 10
  expiration_policy = {
    ttl = "" # If set but ttl is "", the resource never expires.
  }
  enable_message_ordering = false

  labels = {
    system      = "system"
    environment = "fqa"
    provider    = "gcp"
    region      = "southamerica-east1"
  }
}

output "id" {
  value = module.pbs-name-subscription.id
}
```

## Input Variables

| Name                         | Description                                                                                                                                                                         | Type           | Default | Required |
|------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|---------|:--------:|
| name                         | Name of the subscription.                                                                                                                                                           | `string`       | n/a     | Yes      |
| topic                        | Reference to a Topic resource, either as `projects/{project}/topics/{name}` or just the topic name if in the same project.                                                       | `string`       | n/a     | Yes      |
| labels                       | Labels with user-defined metadata.                                                                                                                                                  | `map(string)`  | n/a     | No       |
| bigquery_config              | Configuration for delivery to BigQuery. See docs: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription                              | `object({})`   | n/a     | No       |
| cloud_storage_config         | Configuration for delivery to Cloud Storage. Note: `state` is output-only in the provider and is not a module input. See docs: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription | `object({})`   | n/a     | No       |
| push_config                  | Configuration for push delivery. See docs: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription                                     | `object({})`   | n/a     | No       |
| ack_deadline_seconds         | Maximum time after a subscriber receives a message before it should acknowledge the message.                                                                                       | `number`       | n/a     | No       |
| message_retention_duration   | How long to retain unacknowledged messages in the subscription backlog, from the moment a message is published.                                                                    | `string`       | n/a     | No       |
| retain_acked_messages        | Indicates whether to retain acknowledged messages.                                                                                                                                  | `bool`         | n/a     | No       |
| expiration_policy            | Policy specifying the conditions for this subscription's expiration. See docs: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription | `object({})`   | n/a     | No       |
| filter                       | Only deliver messages that match this filter.                                                                                                                                       | `string`       | n/a     | No       |
| dead_letter_policy           | Policy specifying the conditions for dead lettering messages. See docs: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription         | `object({})`   | n/a     | No       |
| retry_policy                 | Policy specifying how Pub/Sub retries message delivery. See docs: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription               | `object({})`   | n/a     | No       |
| enable_message_ordering      | If true, messages with the same ordering key are delivered in order.                                                                                                               | `bool`         | n/a     | No       |
| enable_exactly_once_delivery | If true, Pub/Sub provides exactly-once delivery guarantees for messages with a given messageId.                                                                                   | `bool`         | n/a     | No       |
| message_transforms           | Transforms applied to messages published to the topic. See docs: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription               | `object({})`   | n/a     | No       |
| tags                         | Resource Manager tags to bind to the subscription at create time.                                                                                                                  | `map(string)`  | n/a     | No       |
| deletion_policy              | Terraform deletion behavior: `DELETE`, `ABANDON`, or `PREVENT`.                                                                                                                    | `string`       | n/a     | No       |
| project                      | The project ID where the resource belongs. If not provided, the provider project is used.                                                                                         | `string`       | n/a     | No       |
| members                      | List of IAM members that should receive `roles/editor` on the subscription.                                                                                                        | `list(string)` | n/a     | No       |

## Object Variables for Blocks

The module supports the following object shapes:

```hcl
cloud_storage_config = {
  bucket                   = "bucket-name"
  filename_prefix          = "pre-"                 # optional
  filename_suffix          = "-suffix"              # optional
  filename_datetime_format = "YYYY-MM-DD/hh_mm_ssZ" # optional
  max_duration             = "300s"                 # optional
  max_bytes                = 1000                    # optional
  max_messages             = 1000                    # optional
  avro_config = {                                    # optional
    write_metadata   = true                          # optional
    use_topic_schema = true                          # optional
  }
  text_config = {}                                   # optional marker block
  service_account_email = "sa@project.iam.gserviceaccount.com" # optional
  # state is output-only in the provider and is not accepted as input
}

push_config = {
  push_endpoint = "https://example.com/push"
  oidc_token = {                                     # optional
    service_account_email = "sa@project.iam.gserviceaccount.com"
    audience              = "https://example.com"   # optional
  }
  attributes = {                                     # optional
    x-goog-version = "v1"
  }
  no_wrapper = {                                     # optional
    write_metadata = true
  }
}

message_transforms = {
  ai_inference = {                                   # optional
    endpoint = "projects/<project>/locations/<location>/publishers/google/models/<model>"
    service_account_email = "sa@project.iam.gserviceaccount.com" # optional
    unstructured_inference = {
      parameters = "{}"                             # optional
    }
  }
  javascript_udf = {                                 # optional
    function_name = "transform"
    code          = "function transform(message, metadata) { return message; }"
  }
  disabled = false                                   # optional
}
```

See the official documentation for full semantics and constraints:
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription

## Output Variables

| Name | Description             |
|------|-------------------------|
| id   | Pub/Sub subscription ID |

## Documentation

Pub/Sub Subscription:
https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription