module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0" # ✅ Compatible with AWS provider v5.x

  cluster_name    = "innovatemart-eks"
  cluster_version = "1.30"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      max_size       = 4
      min_size       = 1
    }
  }

  tags = {
    Environment = "dev"
    Project     = "InnovateMart"
  }
}

# --------------------------------------------------
# VPC Module
# --------------------------------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = "innovatemart-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "innovatemart-vpc"
    Environment = "dev"
    Project     = "Project-Bedrock"
  }
}
