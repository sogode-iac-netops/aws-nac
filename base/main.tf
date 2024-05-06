locals {
  # Read env.json as produced by prereqs
  env_data = jsondecode(file("${path.cwd}/env.json"))

  # Read aws_blueprint.json as output by setup
  blueprint = jsondecode((file("${path.cwd}/aws_blueprint.json")))

  region0 = local.blueprint.regions[0].name
  region1 = local.blueprint.regions[1].name
}

resource "aws_vpc" "base0" {
  provider = aws.region0

#  cidr_block = local.blueprint.vpcs[region].cidr
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = local.blueprint.vpcs[local.region0].description
  }

}

resource "aws_vpc" "base1" {
  provider = aws.us-west-2

  #cidr_block = local.blueprint.vpcs[region].cidr
  cidr_block = "10.0.0.0/24"

}