terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

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
  vpc_name           = "lesson--8-9-vpc"
}

module "ecr" {
  source      = "./modules/ecr"
  repository_name = "lesson-8-9-ecr"
  # ecr_name    = "lesson-8-9-ecr"
  # scan_on_push = true
  environment     = "dev"
}


module "eks" {
  source          = "./modules/eks"          
  cluster_name    = "eks-cluster-hw8-9"            # Назва кластера
  subnet_ids      = module.vpc.public_subnets     # ID підмереж
  instance_type   = "t2.medium"                    # Тип інстансів
  desired_size    = 2                            # Бажана кількість нодів
  max_size        = 3                            # Максимальна кількість нодів
  min_size        = 1                             # Мінімальна кількість нодів
}


module "rds" {
  source = "./modules/rds"

  name                       = "myapp-db"
  use_aurora                 = true
  aurora_instance_count      = 2

  # --- Aurora-only ---
  engine_cluster             = "aurora-postgresql"
  engine_version_cluster     = "15.3"
  parameter_group_family_aurora = "aurora-postgresql15"
  

  # --- RDS-only ---
  engine                     = "postgres"
  engine_version             = "17.2"
  parameter_group_family_rds = "postgres17"

  # Common
  instance_class             = "db.t3.medium"
  allocated_storage          = 20
  db_name                    = "myapp"
  username                   = "postgres"
  password                   = "root"
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = true
  vpc_id                     = module.vpc.vpc_id
  multi_az                   = true
  backup_retention_period    = 7
  parameters = {
    max_connections              = "200"
    log_min_duration_statement   = "500"
  }

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
