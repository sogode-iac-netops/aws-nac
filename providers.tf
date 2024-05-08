terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>5.0.0"
    }
  }
}

provider "aws" {
    region = "eu-west-1"
    alias = "ew1"
    default_tags {
        tags = {
            Project = "AWS Network as Code by Peet van de Sande"
        }
    }
}

provider "aws" {
    region = "us-east-2"
    alias = "ue2"
    default_tags {
        tags = {
            Project = "AWS Network as Code by Peet van de Sande"
        }
    }
}