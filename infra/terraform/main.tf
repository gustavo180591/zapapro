terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    # This will be configured when setting up the remote backend
    # bucket = "zapapro-terraform-state"
    # key    = "terraform.tfstate"
    # region = "sa-east-1"
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Environment = var.environment
      Project     = "ZapaPro"
      ManagedBy   = "Terraform"
    }
  }
}

# Remote state for shared resources (VPC, RDS, etc.)
data "terraform_remote_state" "shared" {
  backend = "s3"
  
  config = {
    bucket = "zapapro-terraform-state-${var.environment}"
    key    = "shared/terraform.tfstate"
    region = var.aws_region
  }
}

# ECS Cluster and Services
module "ecs" {
  source = "./modules/ecs"
  
  environment = var.environment
  aws_region = var.aws_region
  
  vpc_id             = data.terraform_remote_state.shared.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.shared.outputs.private_subnet_ids
  public_subnet_ids  = data.terraform_remote_state.shared.outputs.public_subnet_ids
  
  # ECR repositories
  ecr_repositories = ["zapapro-backend", "zapapro-frontend"]
  
  # Container configurations
  backend_container_config = {
    name  = "backend"
    image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/zapapro-backend:${var.app_version}"
    port  = 3001
    cpu   = 256
    memory = 512
    environment = [
      { name = "NODE_ENV", value = var.environment },
      { name = "PORT", value = "3001" },
    ]
    secrets = [
      { name = "DATABASE_URL", valueFrom = "${aws_ssm_parameter.database_url.arn}" },
      { name = "JWT_SECRET", valueFrom = "${aws_ssm_parameter.jwt_secret.arn}" },
    ]
  }
  
  frontend_container_config = {
    name  = "frontend"
    image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/zapapro-frontend:${var.app_version}"
    port  = 3000
    cpu   = 256
    memory = 512
    environment = [
      { name = "NODE_ENV", value = var.environment },
      { name = "PORT", value = "3000" },
      { name = "VITE_API_BASE_URL", value = var.api_base_url },
    ]
  }
}

# RDS Database
module "database" {
  source = "./modules/rds"
  
  environment = var.environment
  aws_region = var.aws_region
  
  vpc_id             = data.terraform_remote_state.shared.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.shared.outputs.private_subnet_ids
  
  db_name     = "zapapro"
  db_username = "zapapro"
  db_password = var.database_password
  
  # Enable RDS Proxy for better connection handling
  enable_proxy = true
}

# Redis Cache
module "redis" {
  source = "./modules/redis"
  
  environment = var.environment
  aws_region = var.aws_region
  
  vpc_id             = data.terraform_remote_state.shared.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.shared.outputs.private_subnet_ids
  
  node_type      = var.redis_node_type
  num_cache_nodes = var.redis_nodes
}

# S3 Bucket for assets
module "storage" {
  source = "./modules/s3"
  
  environment = var.environment
  bucket_name = "zapapro-assets-${var.environment}"
  
  # Enable CloudFront distribution
  enable_cloudfront = true
  aliases           = [var.domain_name]
  
  # CORS configuration
  cors_rules = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["GET", "HEAD", "PUT", "POST", "DELETE"]
      allowed_origins = ["https://${var.domain_name}"]
      expose_headers  = ["ETag"]
      max_age_seconds = 3000
    }
  ]
}

# SQS Queue for background jobs
resource "aws_sqs_queue" "events" {
  name                      = "zapapro-events-${var.environment}.fifo"
  fifo_queue                = true
  content_based_deduplication = true
  delay_seconds             = 0
  max_message_size          = 262144  # 256KB
  message_retention_seconds = 345600  # 4 days
  receive_wait_time_seconds = 20
  
  tags = {
    Name        = "zapapro-events-${var.environment}"
    Environment = var.environment
  }
}

# Outputs
output "backend_url" {
  description = "URL of the backend service"
  value       = "https://api.${var.domain_name}"
}

output "frontend_url" {
  description = "URL of the frontend application"
  value       = "https://${var.domain_name}"
}

data "aws_caller_identity" "current" {}

# SSM Parameters for secrets
resource "aws_ssm_parameter" "database_url" {
  name        = "/${var.environment}/zapapro/database/url"
  description = "Database connection URL"
  type        = "SecureString"
  value       = "postgresql://${var.database_username}:${var.database_password}@${module.database.db_instance_endpoint}/${module.database.db_name}"
  
  tags = {
    Name        = "zapapro-database-url"
    Environment = var.environment
  }
}

resource "aws_ssm_parameter" "jwt_secret" {
  name        = "/${var.environment}/zapapro/auth/jwt_secret"
  description = "JWT secret key"
  type        = "SecureString"
  value       = var.jwt_secret
  
  tags = {
    Name        = "zapapro-jwt-secret"
    Environment = var.environment
  }
}
