# Module - Pub/Sub Subscription
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)[![GCP](https://img.shields.io/badge/provider-GCP-green)](https://registry.terraform.io/providers/hashicorp/google/latest)

Module developed to standardize the creation of Pub/Sub Subscription.

## Compatibility Matrix

| Module Version | Terraform Version | Google Version     |
|----------------|-------------------| ------------------ |
| v1.0.0         | v1.13.0           | 6.49.2             |

## Release Notes

| Module Version | Note | 
|----------------|------|
| v1.0.0 | Initial Version |

## Specifying a version

To avoid that your code get the latest module version, you can define the `?ref=***` in the URL to point to a specific version.
Note: The `?ref=***` refers a tag on the git module repo.

## Use case bucket
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

## Use case Big Query
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
    ttl = "" #  If it is set but ttl is "", the resource never expires.
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

## Input variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the subscription | `string` | n/a | `Yes` |
| topic | A reference to a Topic resource, of the form projects/{project}/topics/{{name}} (as in the id property of a google_pubsub_topic), or just a topic name if the topic is in the same project as the subscription | `string` | n/a | `Yes` |
| labels | Labels with user-defined metadata | `map(string)` | n/a | No |
| bigquery_config | If delivery to BigQuery is used with this subscription, this field is used to configure it. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription) | `object({})` | n/a | No |
| cloud_storage_config | If delivery to Cloud Storage is used with this subscription, this field is used to configure it. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription) | `object({})` | n/a | No |
| push_config | If push delivery is used with this subscription, this field is used to configure it. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription) | `object({})` | n/a | No |
| ack_deadline_seconds | This value is the maximum time after a subscriber receives a message before the subscriber should acknowledge the message | `string` | n/a | No |
| message_retention_duration | How long to retain unacknowledged messages in the subscription's backlog, from the moment a message is published | `string` | n/a | No |
| retain_acked_messages | Indicates whether to retain acknowledged messages | `bool` | n/a | No |
| expiration_policy | A policy that specifies the conditions for this subscription's expiration. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription) | `object({})` | n/a | No |
| filter | The subscription only delivers the messages that match the filter | `string` | n/a | No |
| dead_letter_policy | A policy that specifies the conditions for dead lettering messages in this subscription. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription) | `object({})` | n/a | No |
| retry_policy | A policy that specifies how Pub/Sub retries message delivery for this subscription. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription) | `object({})` | n/a | No |
| enable_message_ordering | If true, messages published with the same orderingKey in PubsubMessage will be delivered to the subscribers in the order in which they are received by the Pub/Sub system. Otherwise, they may be delivered in any order | `bool` | n/a | No |
| enable_exactly_once_delivery | If true, Pub/Sub provides the following guarantees for the delivery of a message with a given value of messageId on this Subscriptions | `bool` | n/a | No |
| message_transforms | Transforms to be applied to messages published to the topic. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription) | `object({})` | n/a | No |
| project | The ID of the project in which the resource belongs. If it is not provided, the provider project is used | `string` | n/a | No |
| members | list of azure AD groups that will use the resource | `list(string)` | n/a | No |

# Object variables for blocks

Please check the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription)

## Output variables

| Name | Description |
|------|-------------|
| id | pub/sub subscription id|

## Documentation
Pub/Sub Topic: <br>
[https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/pubsub_subscription)