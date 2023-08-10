module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = ["ap-south-1a", "ap-south-1b"]
#   private_subnets = element(var.private_subnet_cidr, count.index)
#   public_subnets  = element(var.public_subnet_cidr, count.index)
  private_subnets = var.private_subnet_cidr
  public_subnets  = var.public_subnet_cidr

  enable_nat_gateway = true

  tags = var.tags
}