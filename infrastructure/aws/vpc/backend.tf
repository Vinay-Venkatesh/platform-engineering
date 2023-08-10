terraform {
  backend "s3" {
    bucket = "core-platform-infra"
    key    = "core-infra.tfstate"
    region = "ap-south-1"
    encrypt = true
  }
}