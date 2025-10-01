# monitoring/main.tf

provider "aws" {
  region = var.aws_region  # change to your desired region
}

# declare SNS topic for alerts

resource "aws_sns_topic" "alerts" {
  name = "production-alerts"
}


# S3 website mmonitoring
# requirement 1: if website 4xx/5xx error rate > 5% over 5 minutes, send alert

resource "aws_cloudwatch_metric_alarm" "s3_error_rate" {
  alarm_name          = "${var.environment}-S3-Error-high"
  comparison_operator = "GreaterThanThreshold" # error rate too high 
  evaluation_periods  = "1"
  threshold          = var.s3_error_rate_threshold  # 5% error rate

  metric_name        = "4xxErrorRate"
  namespace          = "AWS/S3"
  period             = 300 
  statistic          = "Average"
  
  dimensions = {
    BucketName = "var.s3-bucket-name"  # replace with your S3 bucket name
  }

  alarm_description  = "Trigger if 4xx/5xx error rate exceeds 5%."
  alarm_actions      = [aws_sns_topic.alerts.arn]

  tags = {
    Environment = var.environment
  }
} 


# S3 website mmonitoring
# requirement 2: if total request drop to 0 for 10 minutes, send alert

resource "aws_cloudwatch_metric_alarm" "s3_requests_zero" {
  alarm_name          = "${var.environment}-S3-Requests-Zero"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  threshold          = var.s3_zero_request_threshold  # 0 requests

  metric_name        = "NumberOfRequests"
  namespace          = "AWS/S3"
  period             = 600 
  statistic          = "Sum"


  dimensions = {
    BucketName = "var.s3-bucket-name"  # replace with your S3 bucket name
  }

  alarm_description  = "Trigger if total requests drop to 0 for 10 minutes."
  alarm_actions      = [aws_sns_topic.alerts.arn]

  tags = {
    Environment = var.environment
  }
}


# RDS database monitoring
# requirement 1: if CPU utilization > 80% over 5 minutes, send alert
  
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${var.environment}-rds-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold          = var.rds_cpu_threshold  # 80% CPU utilization


  metric_name        = "CPUUtilization"
  namespace          = "AWS/RDS"
  period             = 300
  statistic          = "Average"

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  } 

  alarm_description  = "Trigger if CPU Utilization exceeds 80%."
  alarm_actions      = [aws_sns_topic.alerts.arn]

  tags = {
    Environment = var.environment
  }
}

# RDS database monitoring
# requirement 2: if free storage space < 20%, send alert

resource "aws_cloudwatch_metric_alarm" "rds_free_storage_space" {
  alarm_name          = "${var.environment}-rds-storage-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  threshold          = var.rds_free_storage_threshold  # 20% free storage space

  metric_name        = "FreeStorageSpace"
  namespace          = "AWS/RDS"
  period             = 300
  statistic          = "Average"
 
  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }

  alarm_description  = "RDS free storage < ${var.rds_free_storage_threshold} bytes"
    alarm_actions      = [aws_sns_topic.alerts.arn]

  tags = {
    Environment = var.environment
  }
}

# RDS database monitoring
# requirement 3: if database connections > 90% of max connections, send alert

resource "aws_cloudwatch_metric_alarm" "rds_db_connections" {
  alarm_name          = "${var.environment}-RDS-DB-Connections-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = var.rds_connection_threshold  # 90% of max connections

  metric_name        = "DatabaseConnections"
  namespace          = "AWS/RDS"
  period             = 300
  statistic          = "Average"
 
  
  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }

  alarm_description  = "RDS connections > ${var.rds_connection_threshold}% of max."
  alarm_actions      = [aws_sns_topic.alerts.arn]

  tags = {
    Environment = var.environment
  }
}
