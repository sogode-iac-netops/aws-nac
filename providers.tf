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
    terracurl = {
      source = "devops-rob/terracurl"
      version = "1.2.1"
    }
    phpipam = {
      source = "DockStudios/phpipam"
      version = "1.6.0"
    }
  }
}

provider "aws" {
    default_tags {
      tags = {
        Project = "AWS Network as Code by Peet van de Sande"
      }
    }
}

provider "http" {}

provider "terracurl" {}

provider "phpipam" {
  app_id = "tfprov"
  endpoint = "https://localhost/api"
  username = "admin"
  password = "Foobar4-"
  insecure = true
  verify_connection = false
}