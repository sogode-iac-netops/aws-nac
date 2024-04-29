terraform {
  required_providers {
    "aws" {
        source = ""
        version = ""
    }
    http = {
        source = "hashicorp/http"
        version = "~>3.4.2"
    }
  }
}

provider "aws" {
    region = var.region
}

provider "http" {}