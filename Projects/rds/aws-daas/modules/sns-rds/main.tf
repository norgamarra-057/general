# Lookup for default security group
data "aws_security_group" "sgpr" {
  name             = "sgdaas"
}

# SNS policy along with delivery retries policy in JSON format (how Amazon SNS retries failed deliveries to HTTP/S endpoints)
resource "aws_sns_topic" "default" {
  name            = var.sns_topic_name
  delivery_policy = data.template_file.delivery_policy.rendered
}

data "template_file" "delivery_policy" {
  vars = {
    delivery_policy_minimum_delay                  = "${var.delivery_policy_minimum_delay}"
    delivery_policy_maximum_delay                  = "${var.delivery_policy_maximum_delay}"
    delivery_policy_number_retries                 = "${var.delivery_policy_number_retries}"
    delivery_policy_number_max_delay_retries       = "${var.delivery_policy_number_max_delay_retries}"
    delivery_policy_number_no_delay_retries        = "${var.delivery_policy_number_no_delay_retries}"
    delivery_policy_number_min_delay_retries       = "${var.delivery_policy_number_min_delay_retries}"
    delivery_policy_backoff_function               = "${var.delivery_policy_backoff_function}"
    delivery_policy_disable_subscription_overrides = "${var.delivery_policy_disable_subscription_overrides}"
    delivery_policy_maximum_receives_per_second    = "${var.delivery_policy_maximum_receives_per_second}"
  }
  template                         = "${file("delivery_policy.tpl.json")}"
}

# This policy defines who can access the topic. By default, only the topic owner can publish or subscribe to the topic.
resource "aws_sns_topic_policy" "default" {
  arn              = aws_sns_topic.default.arn
  policy           = data.aws_iam_policy_document.sns_topic_policy.json
}

# Access policy in JSON format. 
data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id        = "__default_policy_ID"
  statement {
    actions        = var.sns_topic_policy_actions 
    condition {
      test         = "StringEquals"
      variable     = "AWS:SourceOwner"
      values       = [ var.account_id ]
    }
    effect         = "Allow"
    principals {
      type         = "AWS"
      identifiers  = ["*"]
    }
    resources      = [ aws_sns_topic.default.arn ]
    sid            = "__default_statement_ID"
  }
}

# This subscription defines who will the policy send the notifications to.
resource "aws_sns_topic_subscription" "sms_topic_subscription" {
  count            = var.sns_topic_subs_create_endpoint_sms ? 1 : 0
  topic_arn        = aws_sns_topic.default.arn
  protocol         = "sms"
  endpoint         = var.sns_topic_subs_endpoint_sms
}

# This subscription defines who will the policy send the notifications to.
resource "aws_sns_topic_subscription" "email_topic_subscription" {
  count            = var.sns_topic_subs_create_endpoint_email ? 1 : 0
  topic_arn        = aws_sns_topic.default.arn
  protocol         = "email"
  endpoint         = var.sns_topic_subs_endpoint_email
}

# This subscription defines who will the policy send the notifications to.
resource "aws_sns_topic_subscription" "email_json_topic_subscription" {
  count            = var.sns_topic_subs_create_endpoint_email_json ? 1 : 0
  topic_arn        = aws_sns_topic.default.arn
  protocol         = "email-json"
  endpoint         = var.sns_topic_subs_endpoint_email_json
}

# This subscription defines who and what will be monitored and to which topic notifications  will be sent to.
resource "aws_db_event_subscription" "default" {
  name             = var.db_event_subs_name
  sns_topic        = aws_sns_topic.default.arn
  source_type      = var.db_event_subs_source_type
  source_ids       = var.db_event_subs_source_ids
  event_categories = var.db_event_subs_event_categories
  enabled          = var.db_event_subs_event_enabled
  tags             = {
                     environment : "${var.app_name}"
                     service_portal : join("",["https://services.groupondev.com/services/",var.tenantservice_tag])
                     jira: var.jira_tag
                     Service: var.service_tag
                     Owner: var.owner_tag
                     TenantTeam: var.tenantteam_tag
                     TenantService: var.tenantservice_tag
                     }
}
