terraform {
  backend "s3" {
    bucket         = "your-tf-backend-bucket-name"
    key            = "terraform/state"
    region         = "eu-west-1"      # ✅ Keep the backend region
    dynamodb_table = "your-dynamodb-lock-table"
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