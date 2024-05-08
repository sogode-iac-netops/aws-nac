variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "Name tag value for the VPC"
  default     = "Spoke VPC"
}

variable "subnets" {
  type = map(object({
    cidr              = string
    description       = string
    availability_zone = string
    ipam_id           = string
    scope             = string
  }))
  description = "Map of subnets"
}

variable "tgw_id" {
  type        = string
  description = "Transit Gateway ID to connect to"
  default     = ""
}

variable "tgw_rt_id" {
  type        = string
  description = "Transit Gateway route table to propagate route to"
  default     = ""
}

variable "app_name" {
  type        = string
  description = "Application name for the spoke"
  default     = ""
}
