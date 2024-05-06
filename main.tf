locals {
  # Read env.json as produced by prereqs
#  env_data = jsondecode(file("${path.cwd}/env.json"))
  # Read aws_blueprint.json as output by setup
  blueprint = jsondecode((file("${path.cwd}/base_networks.json")))

}

module "base" {
  source = "./modules/base"

  cidr_block = local.blueprint.vpc_cidr
  vpc_name = local.blueprint.vpc_description
  subnet_config = {
    for idx, subnet in local.blueprint.subnets :
      "subnet${idx + 1}" => {
        cidr = subnet.cidr
        description = subnet.description
        availability_zone = subnet.availability_zone
        ipam_id = subnet.ipam_id
        scope = subnet.scope
      }
  }
}