variable "basic_tags" {
    description = "Basic resource tags"
    type = map(string)
    default = {
        Project = "AWS Network as Code by Peet van de Sande"
    }
}

variable "region" {
	description = "AWS Region"
	type = string
}

variable "az1" {
    description = "Availability zone 1"
    type = string
    default = "us-east-1a"
}

variable "az2" {
    description = "Availability zone 2"
    type = string
    default = "us-east-1b"
}

variable "vpc_cidr" {
    description = "Supernet object"
    type = string
    default = "10.0.0.0/24"
}

variable vpc_autoassign_ipv6 {
    description = "Whether to auto assign IPv6 range"
    type = bool
    default = false
}

variable az1_private_subnet {
    description = "Subnet range for the private subnet in Availability Zone 1"
    type = string
    default = "10.0.0.0/26"
}

variable az2_private_subnet {
    description = "Subnet range for the private subnet in Availability Zone 2"
    type = string
    default = "10.0.0.64/26"
}

variable az1_public_subnet {
    description = "Subnet range for the public subnet in Availability Zone 1"
    type = string
    default = "10.0.0.128/26"
}

variable az2_public_subnet {
    description = "Subnet range for the public subnet in Availability Zone 2"
    type = string
    default = "10.0.0.192/26"
}