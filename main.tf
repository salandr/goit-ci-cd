provider "aws" {
  region  = "eu-west-1"
  profile = "terraform_user"
}

module "s3_backend" {
  source = "./modules/s3-backend"                # Шлях до модуля
  bucket_name = "terraform-state-bucket-chertok-3"  # Ім'я S3-бакета
  table_name  = "terraform-locks"                # Ім'я DynamoDB
}


module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  vpc_name           = "lesson-5-vpc"
}

module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "lesson-5-ecr"
  scan_on_push = true
}