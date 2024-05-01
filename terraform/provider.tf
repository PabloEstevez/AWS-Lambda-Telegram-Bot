provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Name = var.name
    }
  }
}