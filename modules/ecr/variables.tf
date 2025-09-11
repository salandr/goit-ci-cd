variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, production)"
  type        = string
}


variable "scan_on_push" {
  description = "Чи увімкнути автоматичне сканування образів при пуші"
  type        = bool
  default     = true
}