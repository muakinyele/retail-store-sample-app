terraform {
  backend "s3" {
    bucket         = "innovate-mart"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "innovatemart-terraform-locks"
    encrypt        = true
  }
}



# terraform {
#   backend "s3" {
#     bucket       = "innovate-mart"
#     key          = "terraform/state.tfstate"
#     region       = "us-east-1"
#     use_lockfile = true
#   }
# }