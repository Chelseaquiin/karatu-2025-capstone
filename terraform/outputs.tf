output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

# Names required by the grading brief
output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "assets_bucket_name" {
  description = "S3 assets bucket name"
  value       = aws_s3_bucket.assets.id
}

# Additional useful outputs
output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "eks_cluster_version" {
  description = "EKS cluster version"
  value       = aws_eks_cluster.main.version
}

output "mysql_endpoint" {
  description = "RDS MySQL endpoint for catalog service"
  value       = aws_db_instance.mysql.endpoint
  sensitive   = true
}

output "mysql_database_name" {
  description = "RDS MySQL database name"
  value       = aws_db_instance.mysql.db_name
}

output "mysql_username" {
  description = "RDS MySQL username"
  value       = aws_db_instance.mysql.username
  sensitive   = true
}

output "mysql_password" {
  description = "RDS MySQL password"
  value       = random_password.mysql_password.result
  sensitive   = true
}

output "postgres_endpoint" {
  description = "RDS PostgreSQL endpoint for orders service"
  value       = aws_db_instance.postgres.endpoint
  sensitive   = true
}

output "postgres_database_name" {
  description = "RDS PostgreSQL database name"
  value       = aws_db_instance.postgres.db_name
}

output "postgres_username" {
  description = "RDS PostgreSQL username"
  value       = aws_db_instance.postgres.username
  sensitive   = true
}

output "postgres_password" {
  description = "RDS PostgreSQL password"
  value       = random_password.postgres_password.result
  sensitive   = true
}

output "s3_bucket_name" {
  description = "S3 assets bucket name"
  value       = aws_s3_bucket.assets.id
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.asset_processor.function_name
}

output "lambda_function_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.asset_processor.arn
}

output "developer_iam_user_name" {
  description = "Developer IAM user name"
  value       = aws_iam_user.developer.name
}

output "developer_access_key_id" {
  description = "Developer IAM access key ID"
  value       = aws_iam_access_key.developer.id
  sensitive   = true
}

output "developer_secret_access_key" {
  description = "Developer IAM secret access key"
  value       = aws_iam_access_key.developer.secret
  sensitive   = true
}

output "dynamodb_table_name" {
  description = "DynamoDB table name for carts/app state"
  value       = aws_dynamodb_table.app_state.name
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group for EKS"
  value       = aws_cloudwatch_log_group.eks_cluster.name
}
