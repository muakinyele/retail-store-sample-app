# --------------------------------------------------
# Outputs
# --------------------------------------------------
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnets"
  value       = module.vpc.private_subnets
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

# Optional: Only include if aws_iam_access_key exists
output "dev_user_access_key_id" {
  description = "Access key for developer IAM user"
  value       = aws_iam_access_key.dev_readonly_key.id
  sensitive   = true
}

output "dev_user_secret" {
  description = "Secret for developer IAM user"
  value       = aws_iam_access_key.dev_readonly_key.secret
  sensitive   = true
}
