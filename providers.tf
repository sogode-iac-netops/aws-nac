terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>5.0.0"
    }
    http = {
        source = "hashicorp/http"
        version = "~>3.4.2"
    }
  }
}

provider "aws" {
    region = local.blueprint.region_name
    default_tags {
        tags = {
            Project = "AWS Network as Code by Peet van de Sande"
        }
    }
}

provider "http" {}