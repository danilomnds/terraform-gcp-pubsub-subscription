variable "name" {
  type = string
}

variable "topic" {
  type = string 
}

variable "labels" {
  type    = map(string)
  default = null
}

variable "bigquery_config" {
  type = object({
    table = string
    use_topic_schema = optional(bool)
    use_table_schema = optional(bool)
    write_metadata = optional(bool)
    drop_unknown_fields = optional(bool)
    service_account_email = optional(string)
  })
  default = null
}

variable "cloud_storage_config" {
  type = object({
    bucket = string
    filename_prefix = optional(string)
    filename_suffix = optional(string)
    filename_datetime_format = optional(string)
    max_duration = optional(string)
    max_bytes = optional(string)
    max_messages = optional(number)
    state = optional(string)
    avro_config = optional(object({
      write_metadata = optional(bool)
      use_topic_schema = optional(bool)
    }))
    service_account_email = optional(string)
  })
  default = null
}

variable "push_config" {
  type = object({
    oidc_token = optional(object({
      service_account_email = string
      audience = optional(string)      
    }))
    push_endpoint = string
    attributes = optional(string)
    no_wrapper = optional(object({
      write_metadata = string
    }))
  })
  default = null
}

variable "ack_deadline_seconds" {
  type = string
  default = null  
}

variable "message_retention_duration" {
  type = string
  default = null  
}

variable "retain_acked_messages" {
  type = bool
  default = null  
}

variable "expiration_policy" {
  type = object({
    ttl = string
  })
  default = null
}

variable "filter" {
  type = string
  default = null  
}

variable "dead_letter_policy" {
  type = object({
    dead_letter_topic = optional(string)
    max_delivery_attempts = optional(number)
  })
  default = null
}

variable "retry_policy" {
  type = object({
    minimum_backoff = optional(string)
    maximum_backoff = optional(string)
  })
  default = null
}

variable "enable_message_ordering" {
  type = bool
  default = null  
}

variable "enable_exactly_once_delivery" {
  type = bool
  default = true  
}

variable "message_transforms" {
  type = object({
    javascript_udf = optional(object({
      function_name = string
      code = string
    }))
    disabled = optional(bool)
  })
  default = null
}

variable "project" {
  type    = string
  default = null
}

variable "members" {
  type    = list(string)
  default = []
}