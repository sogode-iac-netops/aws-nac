provider "aws" {
    alias = "region0"
    region = local.blueprint.regions[0].name
    default_tags {
        tags = {
            Project = "AWS Network as Code by Peet van de Sande"
        }
    }
}

provider "aws" {
    alias = "region1"
    region = local.blueprint.regions[1].name
    default_tags {
        tags = {
            Project = "AWS Network as Code by Peet van de Sande"
        }
    }
}
