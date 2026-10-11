variable "sesv2_configuration_sets" {
  description = <<EOT
Map of sesv2_configuration_sets, attributes below
Required:
    - configuration_set_name
Optional:
    - region
    - tags
    - tags_all
    - delivery_options (block):
        - max_delivery_seconds (optional)
        - sending_pool_name (optional)
        - tls_policy (optional)
    - reputation_options (block):
        - reputation_metrics_enabled (optional)
    - sending_options (block):
        - sending_enabled (optional)
    - suppression_options (block):
        - suppressed_reasons (optional)
    - tracking_options (block):
        - custom_redirect_domain (required)
        - https_policy (optional)
    - vdm_options (block):
        - dashboard_options (optional, block):
            - engagement_metrics (optional)
        - guardian_options (optional, block):
            - optimized_shared_delivery (optional)
EOT

  type = map(object({
    configuration_set_name = string
    region                 = optional(string)
    tags                   = optional(map(string))
    tags_all               = optional(map(string))
    delivery_options = optional(object({
      max_delivery_seconds = optional(number)
      sending_pool_name    = optional(string)
      tls_policy           = optional(string)
    }))
    reputation_options = optional(object({
      reputation_metrics_enabled = optional(bool)
    }))
    sending_options = optional(object({
      sending_enabled = optional(bool)
    }))
    suppression_options = optional(object({
      suppressed_reasons = optional(list(string))
    }))
    tracking_options = optional(object({
      custom_redirect_domain = string
      https_policy           = optional(string)
    }))
    vdm_options = optional(object({
      dashboard_options = optional(object({
        engagement_metrics = optional(string)
      }))
      guardian_options = optional(object({
        optimized_shared_delivery = optional(string)
      }))
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.sesv2_configuration_sets : (
        length(v.configuration_set_name) >= 1 && length(v.configuration_set_name) <= 64
      )
    ])
    error_message = "must be between 1 and 64 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.sesv2_configuration_sets : (
        v.delivery_options == null || (v.delivery_options.max_delivery_seconds == null || (v.delivery_options.max_delivery_seconds >= 300 && v.delivery_options.max_delivery_seconds <= 50400))
      )
    ])
    error_message = "must be between 300 and 50400"
  }
  # Note: 5 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

