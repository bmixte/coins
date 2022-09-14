provider "aws" {
  region = var.region

  default_tags {
    tags = {
        generatedBy = "terraform"
        environment = "production"
    }
  }

}