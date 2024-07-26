variable "sns_topic_policy_actions" {
    description = "This policy defines who can access your topic. A list of event categories for a SourceType that you want to subscribe to."
    type    = list(string)
    default = ["SNS:Subscribe", "SNS:SetTopicAttributes", "SNS:RemovePermission", "SNS:Receive", "SNS:Publish", "SNS:ListSubscriptionsByTopic", "SNS:GetTopicAttributes", "SNS:DeleteTopic", "SNS:AddPermission"]
}

variable "db_event_subs_name" {
    description = "The name of the DB event subscription."
}

variable "db_event_subs_source_type" {
    description = "Source type of resource this subscription will consume events from. Valid options are db-instance, db-security-group, db-parameter-group, db-snapshot, db-cluster or db-cluster-snapshot. If not set, all sources will be subscribed to."
    default = null
}

variable "db_event_subs_event_categories" {
    description = "A list of event categories for a SourceType that you want to subscribe to. Valid values are availability, backup, configuration change, creation, deletion, failover, failure, low storage, maintenance, notification, read replica, recovery, restoration, security."
    type    = list(string)
    default = []
}

variable "db_event_subs_event_enabled" {
    description = "Boolean flag to enable/disable the subscription."
    default = true
}

variable "db_event_subs_source_ids" {
    description = "List of identifiers of the event sources for which events will be returned. If not specified, then all sources are included in the response."
    type    = list(string)
    default = []
}

variable "sns_topic_subs_protocol" {
    description = "Protocol to use - valid values are: sqs, sms, lambda, firehose and application. Protocols email, email-json, http and https are also valid but partially supported."
    default = ""
}

variable "sns_topic_subs_endpoint_email" {
    description = "Endpoint EMAIL to send data to."
    default = ""
}
variable "sns_topic_subs_create_endpoint_email" {
    description = "Boolean indicating whether EMAIL endpoint is created or not"
    default = false
}

variable "sns_topic_subs_endpoint_email_json" {
    description = "Endpoint EMAIL-JSON to send data to."
    default = ""
}
variable "sns_topic_subs_create_endpoint_email_json" {
    description = "Boolean indicating whether EMAIL-JSON endpoint is created or not"
    default = false
}

variable "sns_topic_subs_endpoint_sms" {
    description = "Endpoint SMS to send data to."
    default     = ""
}

variable "sns_topic_subs_create_endpoint_sms" {
    description = "Boolean indicating whether SMS endpoint is created or not"
    default     = false
}

variable "sns_topic_name" {
    description = "The type of source that will be generating the events."
    default = ""
}

variable "sns_topic_fifo_topic" {
    description = "Boolean indicating whether or not to create a FIFO (first-in-first-out) topic"
    default = false
}

variable "delivery_policy_minimum_delay" {
    description = "The minimum delay for a retry in seconds (maximum delay: 1 - default: 20)"
    default = 20
}

variable "delivery_policy_maximum_delay" {
    description = "The minimum delay for a retry in seconds (minimum delay: 3,600 - default: 20)"
    default = 20
}

variable "delivery_policy_number_retries" {
    description = "The total number of retries, including immediate, pre-backoff, backoff, and post-backoff retries (0 or greater - default: 3)"
    default = 3
}

variable "delivery_policy_number_max_delay_retries" {
    description = "The number of retries in the post-backoff phase, with the maximum delay between them (0 or greater - default: 0)"
    default = 0
}

variable "delivery_policy_number_no_delay_retries" {
    description = "The number of retries to be done immediately, with no delay between them (0 or greater - default: 0)"
    default = 0
}

variable "delivery_policy_number_min_delay_retries" {
    description = "The number of retries in the pre-backoff phase, with the specified minimum delay between them (0 or greater - default: 0)"
    default = 0
}

variable "delivery_policy_backoff_function" {
    description = "The model for backoff between retries: arithmetic, exponential, geometric, linear (default: linear)"
    default = "linear"
}

variable "delivery_policy_disable_subscription_overrides" {
    default = false
}

variable "delivery_policy_maximum_receives_per_second" {
    description = "The maximum number of deliveries per second, per subscription (1 or greater - default: No throttling)"
    default = 1
}
