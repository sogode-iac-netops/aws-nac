locals {
  # Read env.json as produced by prereqs
  env_data = jsondecode(file("${path.cwd}/env.json"))

  # get ipam info
  ipam_base = local.env_data.ipam_base
  ipam_token = local.env_data.ipam_token
  supernets = local.env_data.supernets
}

module "basis" {
  source = "./basis"
  cidr = var.basis_cidr
  name = 

}