variable "vpc_id" {
  type        = string
  description = "ID of the VPC to enable internet access on"
  default     = ""
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet_id's to associate with the internet gateway"
  default     = []
}
