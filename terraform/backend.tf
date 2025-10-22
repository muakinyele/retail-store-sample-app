terraform {
  backend "s3" {
    bucket       = "innovate-mart"
    key          = "terraform/state.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
