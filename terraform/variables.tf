variable "aws_region" {
  type    = string
  default = "us-east-1"
}


variable "cluster_name" {
  type    = string
  default = "project-bedrock-eks"
}


variable "node_group_desired_capacity" {
  type    = number
  default = 2
}


variable "pgp_key" {
  description = "Optional PGP key to encrypt access key secret output. Provide in the form of a PGP key ID or full key."
  type        = string
  default     = ""
}


# variable "account_id" {
#   type = string
# }

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "cluster_endpoint_public_access" {
  description = "Enable public access to the EKS cluster endpoint"
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Enable private access to the EKS cluster endpoint"
  type        = bool
  default     = true
}

variable "account_id" {
  description = "AWS Account ID used for resource naming and IAM roles"
  type        = string
}