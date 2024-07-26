resource "aws_cloudwatch_dashboard" "gds-pci" {
  dashboard_name = "gds-pci-${var.aws_region}"

  dashboard_body = <<EOF
{
    "widgets": [
        {
            "type": "explorer",
            "x": 0,
            "y": 0,
            "width": 24,
            "height": 15,
            "properties": {
                "metrics": [
                    {
                        "metricName": "CPUUtilization",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    },
                    {
                        "metricName": "DatabaseConnections",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Sum"
                    },
                    {
                        "metricName": "FreeStorageSpace",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    },
                    {
                        "metricName": "FreeableMemory",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    },
                    {
                        "metricName": "ReadLatency",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    },
                    {
                        "metricName": "ReadThroughput",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    },
                    {
                        "metricName": "ReadIOPS",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    },
                    {
                        "metricName": "WriteLatency",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    },
                    {
                        "metricName": "WriteThroughput",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    },
                    {
                        "metricName": "WriteIOPS",
                        "resourceType": "AWS::RDS::DBInstance",
                        "stat": "Average"
                    }
                ],
                "labels": [
                    {
                        "key": "Service"
                    }
                ],
                "widgetOptions": {
                    "legend": {
                        "position": "bottom"
                    },
                    "view": "timeSeries",
                    "stacked": false,
                    "rowsPerPage": 50,
                    "widgetsPerRow": 2
                },
                "period": 300,
                "splitBy": "",
                "region": "${var.aws_region}"
            }
        }
    ]
}
EOF
}

resource "aws_sns_topic" "gds_pci_alarm" {
  name = "gds-pci-alarm"
  tags = {
    Service = "daas_mysql"
    Owner   = "gds@groupon.com"
  }
}

resource "aws_cloudwatch_metric_alarm" "CPUUtilization" {
    alarm_name                = "gds-pci-cpu-utilization ${var.alarm_subject_suffix}"
    comparison_operator       = "GreaterThanOrEqualToThreshold"
    evaluation_periods        = "1"
    metric_name               = "CPUUtilization"
    namespace                 = "AWS/RDS"
    period                    = "300"
    statistic                 = "Average"
    threshold                 = var.thresholds["cpu_utilization"]
    alarm_description         = "high cpu utilization"
    insufficient_data_actions = [aws_sns_topic.gds_pci_alarm.arn]
    alarm_actions     = [aws_sns_topic.gds_pci_alarm.arn]
}

resource "aws_cloudwatch_metric_alarm" "DatabaseConnections" {
    alarm_name                = "gds-pci-db-connections ${var.alarm_subject_suffix}"
    comparison_operator       = "GreaterThanOrEqualToThreshold"
    evaluation_periods        = "1"
    metric_name               = "DatabaseConnections"
    namespace                 = "AWS/RDS"
    period                    = "300"
    statistic                 = "Average"
    threshold                 = var.thresholds["db_connections"]
    alarm_description         = "high number of db connections"
    insufficient_data_actions = [aws_sns_topic.gds_pci_alarm.arn]
    alarm_actions     = [aws_sns_topic.gds_pci_alarm.arn]
}
