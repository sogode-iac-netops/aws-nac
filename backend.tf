terraform {
#  required_version = ">= 1.8.0"

  # Use remote backend for HCP Terraform (formerly Terraform Cloud)
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "b79f2c4e-652c-4465-8e61-b7a1c7b72de3"
    workspaces {
        name = "aws-nac" # Verify!
    }
  }
}