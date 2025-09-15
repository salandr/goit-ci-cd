# variable "ecr_name" {}

# variable "scan_on_push" {
#   default = true
# }

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, production)"
  type        = string
}