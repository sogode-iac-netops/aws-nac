locals {
  # Read env.json as produced by prereqs
  env_data = jsondecode(file("${path.cwd}/env.json"))

  # get ipam info
  ipam_base = local.env_data.ipam_base
  ipam_token = local.env_data.ipam_token
  supernets = local.env_data.supernets
}

data "http" "cidr" {
    url = "${local.ipam_base}subnets/${local.supernets.0.id}/first_subnet/24"
    request_headers = {
      token = "${local.ipam_token}"
    }
    insecure = true
}

output "supernet" {
    value = "${data.http.cidr}"
}