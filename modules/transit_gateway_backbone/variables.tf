variable "destinations" {
  type = map(object({
    attachment_id   = string
    dst_cidr_block  = string
    route_table_id  = string
  }))
  description = "Map of destinations"
}
