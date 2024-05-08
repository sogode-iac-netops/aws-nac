variable "vpc_id" {
  type        = string
  description = "ID of the local base VPC"
  default     = ""
}

variable "aws_region" {
  type        = string
  description = "Current AWS Region"
  default     = ""
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet_id's to associate with the transit gateway"
  default     = []
}

variable "base_cidr" {
  type        = string
  description = "CIDR of the local base VPC"
  default     = ""
}

variable "base_rt_id" {
  type        = string
  description = "Local base VPC's route table ID"
  default     = ""
}
