# monitoring/variables.tf

variable "aws_region" {
  description = "The AWS region to deploy the resources."
  type        = string
  default     = "us-east-1"  # Change as needed
}

variable "environment" {
  description = "The environment for the resources (e.g., dev, prod)."
  type        = string
  default     = "dev"
}

variable "s3_error_rate_threshold" {
  description = "The threshold for S3 4xx/5xx error rate to trigger an alert."
  type        = number
  default     = 5.0  # 5% error rate
} 

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to monitor."
  type        = string
  default     = "your-s3-bucket-name"  # replace with your S3 bucket name 
}

variable "s3_zero_request_threshold" {
  description = "The threshold for S3 total requests to trigger an alert when it drops to zero."
  type        = number
  default     = 0  # 0 requests
}

variable "rds_cpu_threshold" {
  description = "The threshold for RDS CPU utilization to trigger an alert."
  type        = number
  default     = 80  # 80% CPU utilization
}

variable "rds_instance_id" {
  description = "The RDS instance identifier to monitor."
  type        = string
  default     = "your-rds-instance-id"  # replace with your RDS instance ID
} 

variable "rds_free_storage_threshold" {
  description = "The threshold for RDS free storage space to trigger an alert."
  type        = number
  default     = 20  # 20% free storage space
}

variable "rds_connection_threshold" {
  description = "The threshold for RDS database connections to trigger an alert."
  type        = number
  default     = 90  # 90% of max connections
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic to send alerts to."
  type        = string
  default     = "your-sns-topic-arn"  # replace with your SNS topic ARN
}