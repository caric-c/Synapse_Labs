variable "bucket_name" {
  description = "dev"
  type        = string
}

variable "environment" {
  description = "dev"
  type        = string
}

variable "tags" {
  description = "environment tag"
  type        = map(string)
}