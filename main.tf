resource "google_pubsub_subscription" "subscription" {
  name            = var.name
  topic           = var.topic
  labels          = var.labels
  tags            = var.tags
  deletion_policy = var.deletion_policy
  dynamic "bigquery_config" {
    for_each = var.bigquery_config != null ? [var.bigquery_config] : []
    content {
      table                 = bigquery_config.value.table
      use_topic_schema      = lookup(bigquery_config.value, "use_topic_schema", null)
      use_table_schema      = lookup(bigquery_config.value, "use_table_schema", null)
      write_metadata        = lookup(bigquery_config.value, "write_metadata", null)
      drop_unknown_fields   = lookup(bigquery_config.value, "drop_unknown_fields", null)
      service_account_email = lookup(bigquery_config.value, "service_account_email", null)
    }
  }
  dynamic "cloud_storage_config" {
    for_each = var.cloud_storage_config != null ? [var.cloud_storage_config] : []
    content {
      bucket                   = cloud_storage_config.value.bucket
      filename_prefix          = lookup(cloud_storage_config.value, "filename_prefix", null)
      filename_suffix          = lookup(cloud_storage_config.value, "filename_suffix", null)
      filename_datetime_format = lookup(cloud_storage_config.value, "filename_datetime_format", null)
      max_duration             = lookup(cloud_storage_config.value, "max_duration", null)
      max_bytes                = lookup(cloud_storage_config.value, "max_bytes", null)
      max_messages             = lookup(cloud_storage_config.value, "max_messages", null)
      dynamic "avro_config" {
        for_each = cloud_storage_config.value.avro_config != null ? [cloud_storage_config.value.avro_config] : []
        content {
          write_metadata   = avro_config.value.write_metadata
          use_topic_schema = avro_config.value.use_topic_schema
        }
      }
      dynamic "text_config" {
        for_each = lookup(cloud_storage_config.value, "text_config", null) != null ? [cloud_storage_config.value.text_config] : []
        content {}
      }
      service_account_email = lookup(cloud_storage_config.value, "service_account_email", null)
    }
  }
  dynamic "push_config" {
    for_each = var.push_config != null ? [var.push_config] : []
    content {
      dynamic "oidc_token" {
        for_each = push_config.value.oidc_token != null ? [push_config.value.oidc_token] : []
        content {
          service_account_email = oidc_token.value.service_account_email
          audience              = lookup(oidc_token.value, "audience", null)
        }
      }
      push_endpoint = push_config.value.push_endpoint
      attributes    = lookup(push_config.value, "attributes", null)
      dynamic "no_wrapper" {
        for_each = push_config.value.no_wrapper != null ? [push_config.value.no_wrapper] : []
        content {
          write_metadata = no_wrapper.value.write_metadata
        }
      }
    }
  }
  ack_deadline_seconds       = var.ack_deadline_seconds
  message_retention_duration = var.message_retention_duration
  retain_acked_messages      = var.retain_acked_messages
  dynamic "expiration_policy" {
    for_each = var.expiration_policy != null ? [var.expiration_policy] : []
    content {
      ttl = expiration_policy.value.ttl
    }
  }
  filter = var.filter
  dynamic "dead_letter_policy" {
    for_each = var.dead_letter_policy != null ? [var.dead_letter_policy] : []
    content {
      dead_letter_topic     = lookup(dead_letter_policy.value, "dead_letter_topic", null)
      max_delivery_attempts = lookup(dead_letter_policy.value, "max_delivery_attempts", null)
    }
  }
  dynamic "retry_policy" {
    for_each = var.retry_policy != null ? [var.retry_policy] : []
    content {
      minimum_backoff = lookup(retry_policy.value, "minimum_backoff", null)
      maximum_backoff = lookup(retry_policy.value, "maximum_backoff", null)
    }
  }
  enable_message_ordering      = var.enable_message_ordering
  enable_exactly_once_delivery = var.enable_exactly_once_delivery
  dynamic "message_transforms" {
    for_each = var.message_transforms != null ? [var.message_transforms] : []
    content {
      dynamic "ai_inference" {
        for_each = lookup(message_transforms.value, "ai_inference", null) != null ? [message_transforms.value.ai_inference] : []
        content {
          endpoint              = ai_inference.value.endpoint
          service_account_email = lookup(ai_inference.value, "service_account_email", null)

          dynamic "unstructured_inference" {
            for_each = lookup(ai_inference.value, "unstructured_inference", null) != null ? [ai_inference.value.unstructured_inference] : []
            content {
              parameters = lookup(unstructured_inference.value, "parameters", null)
            }
          }
        }
      }
      dynamic "javascript_udf" {
        for_each = message_transforms.value.javascript_udf != null ? [message_transforms.value.javascript_udf] : []
        content {
          function_name = javascript_udf.value.function_name
          code          = javascript_udf.value.code
        }
      }
      disabled = lookup(message_transforms.value, "disabled", true)
    }
  }
  project = var.project
  lifecycle {
    ignore_changes = []
  }
}

resource "google_pubsub_subscription_iam_member" "topicviewer" {
  depends_on   = [google_pubsub_subscription.subscription]
  for_each     = { for member in var.members : member => member }
  subscription = google_pubsub_subscription.subscription.name
  project      = var.project
  role         = "roles/editor"
  member       = each.value
}