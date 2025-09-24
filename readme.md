# Module - Pub/Sub Subscription
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)[![GCP](https://img.shields.io/badge/provider-GCP-green)](https://registry.terraform.io/providers/hashicorp/google/latest)

This module standardizes the creation of Pub/Sub subscriptions using Terraform.

## Compatibility Matrix

| Module Version | Terraform Version | Google Provider Version |
|----------------|------------------|------------------------|
| v1.0.0         | v1.13.0          | 6.49.2                 |
| v1.1.0         | v1.13.0          | 7.4.0                  |

## Release Notes

| Module Version | Note                                                    |
|----------------|--------------------------------------------------------|
| v1.0.0         | Initial version                                        |
| v1.1.0         | Updated provider to 7.4.0 and Terraform to 1.13.3      |

## Specifying a Version

To avoid automatically using the latest module version, specify the `?ref=***` in the source URL to pin a version (where `***` is a git tag).  
Note: The `?ref=***` refers to a tag in the git module repository.

## Example: Cloud Storage Delivery

```hcl
module "pbs-name-subscription" {    
  source = "git::https://github.com/danilomnds/terraform-gcp-pubsub-subscription?ref=v1.0.0"
  project = "project_id"
  name = "pbs-name-subscription"
  topic = "pbs-name"
  cloud_storage_config = {
    bucket = "bucket-name"
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
  source = "git::https://github.com/danilomnds/terraform-gcp-pubsub-subscription?ref=v1.0.0"
  project = "project_id"
  name = "pbs-name-subscription"
  topic = "pbs-name"
  bigquery_config = {
    table = "table-name"
    use_topic_schema    = true
    drop_unknown_fields = true
    write_metadata      = true
  }
  # 7 days
  message_retention_duration = "604800s"
  retain_acked_messages      = false
  ack_deadline_seconds = 10
  expiration_policy = {
    ttl = "" # If set but ttl is "", the resource never expires.
  }
  enable_message_ordering    = false
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

| Name                      | Description                                                                                                                                                                                                 | Type           | Default | Required |
|---------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|---------|:--------:|
| name                      | Name of the subscription.                                                                                                                                            | `string`       | n/a     | Yes      |
| topic                     | Reference to a Topic resource, either as `projects/{project}/topics/{name}` or just the topic name if in the same project.                                           | `string`       | n/a     | Yes      |
| labels                    | Labels with user-defined metadata.                                                                                                                                   | `map(string)`  | n/a     | No       |
| bigquery_config           | Configuration for delivery to BigQuery. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription).               | `object({})`   | n/a     | No       |
| cloud_storage_config      | Configuration for delivery to Cloud Storage. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription).          | `object({})`   | n/a     | No       |
| push_config               | Configuration for push delivery. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription).                      | `object({})`   | n/a     | No       |
| ack_deadline_seconds      | Maximum time after a subscriber receives a message before it should acknowledge the message.                                                                         | `string`       | n/a     | No       |
| message_retention_duration| How long to retain unacknowledged messages in the subscription's backlog, from the moment a message is published.                                                    | `string`       | n/a     | No       |
| retain_acked_messages     | Indicates whether to retain acknowledged messages.                                                                                                                   | `bool`         | n/a     | No       |
| expiration_policy         | Policy specifying the conditions for this subscription's expiration. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription). | `object({})`   | n/a     | No       |
| filter                    | Only deliver messages that match this filter.                                                                                                                        | `string`       | n/a     | No       |
| dead_letter_policy        | Policy specifying the conditions for dead lettering messages. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription). | `object({})`   | n/a     | No       |
| retry_policy              | Policy specifying how Pub/Sub retries message delivery. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription). | `object({})`   | n/a     | No       |
| enable_message_ordering   | If true, messages with the same ordering key will be delivered in order.                                                                                             | `bool`         | n/a     | No       |
| enable_exactly_once_delivery | If true, Pub/Sub provides exactly-once delivery guarantees for messages with a given messageId.                                                                   | `bool`         | n/a     | No       |
| message_transforms        | Transforms to be applied to messages published to the topic. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription). | `object({})`   | n/a     | No       |
| project                   | The ID of the project in which the resource belongs. If not provided, the provider project is used.                                                                  | `string`       | n/a     | No       |
| members                   | List of Azure AD groups that will use the resource.                                                                                                                  | `list(string)` | n/a     | No       |

## Object Variables for Blocks

See the [official documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription) for details on object variable structures.

## Output Variables

| Name | Description                  |
|------|------------------------------|
| id   | Pub/Sub subscription ID      |

## Documentation

Pub/Sub Subscription:  
[https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription)