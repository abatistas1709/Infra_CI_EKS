terraform {
  backend "s3" {
    bucket = "terraform-state-abatistas1709"
    key    = "Prod/terraform.tfstate"
    region = "us-east-2"
  }
}