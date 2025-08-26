variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "sa-east-1"
}

variable "app_version" {
  description = "The application version to deploy"
  type        = string
  default     = "latest"
}

variable "domain_name" {
  description = "The base domain name for the application"
  type        = string
  default     = "zapapro.example.com"
}

variable "api_base_url" {
  description = "Base URL for the API"
  type        = string
  default     = "https://api.zapapro.example.com"
}

# Database variables
variable "database_username" {
  description = "Database administrator username"
  type        = string
  default     = "zapapro"
}

variable "database_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "database_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "database_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

# Redis variables
variable "redis_node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "redis_nodes" {
  description = "Number of cache nodes"
  type        = number
  default     = 1
}

# ECS variables
variable "ecs_task_cpu" {
  description = "CPU units for ECS task (1024 units = 1 vCPU)"
  type        = number
  default     = 256
}

variable "ecs_task_memory" {
  description = "Memory for ECS task (MiB)"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 1
}

# Auto Scaling variables
variable "enable_auto_scaling" {
  description = "Enable auto scaling for ECS service"
  type        = bool
  default     = false
}

variable "min_capacity" {
  description = "Minimum number of tasks to run"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of tasks to run"
  type        = number
  default     = 3
}

# Secrets variables
variable "jwt_secret" {
  description = "Secret key for JWT token generation"
  type        = string
  sensitive   = true
}

variable "mercado_pago_access_token" {
  description = "MercadoPago access token"
  type        = string
  sensitive   = true
  default     = ""
}

variable "whatsapp_token" {
  description = "WhatsApp API token"
  type        = string
  sensitive   = true
  default     = ""
}

# Monitoring variables
variable "enable_enhanced_monitoring" {
  description = "Enable enhanced monitoring for RDS"
  type        = bool
  default     = false
}

variable "alarm_email" {
  description = "Email address for CloudWatch alarms"
  type        = string
  default     = ""
}

# Tags
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
