terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.47.0"
    }
    archive = {
      source = "hashicorp/archive"
      version = "2.4.2"
    }
    http = {
      source = "hashicorp/http"
      version = "3.4.2"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.1"
    }
  }
}
