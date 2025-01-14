provider "aws" {
  region = "sa-east-1"
}
terraform {

  backend "s3" {
    bucket  = "6soat-tfstate"
    key     = "terraform-s3/uploadedvideobucket/terraform.tfstate"
    region  = "sa-east-1"
    encrypt = true
  }
}