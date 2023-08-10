terraform {
  backend "s3" {
    bucket = "demo-platform-infra"
    key    = "eks-infra.tfstate"
    region = "ap-south-1"
    encrypt = true
  }
}