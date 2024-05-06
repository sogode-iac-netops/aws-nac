variable "cidr_block" {
  type = string
  description = "CIDR block for the VPC"
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type = string
  description = "Name tag value for the VPC"
  default = "Base VPC"
}

variable "subnet_config" {
  type = map(object({
    cidr    = string
    description = string
    availability_zone = string
    ipam_id = string
    scope = string
  }))
  description = "Map of subnets"
}