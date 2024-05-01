terraform {
  # S3 backend and DynamoDB lock are recommended, but local is used by default to save on S3 costs
  backend "local" {
    path = "terraform.tfstate"
  }
}