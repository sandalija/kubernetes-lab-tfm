terraform {
  backend "s3" {}
}

provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      Project = "kubernetes-lab-tfm"
    }
  }
}