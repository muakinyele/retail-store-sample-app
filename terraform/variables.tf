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


variable "account_id" {
  type = string
}

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}