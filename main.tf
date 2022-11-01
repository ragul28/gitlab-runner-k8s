module "aws-vpc" {
  source                    = "./modules/vpc"
  project                   = var.project
  main_vpc_cidr_block       = var.main_vpc_cidr_block
  az_set                    = var.az_set
  public_subnets            = var.public_subnets
  private_subnets           = var.private_subnets
  enable_natgw              = var.enable_natgw
}


module "aws-eks" {
  source             = "./modules/eks"
  project            = var.project
  eks_vpc_id         = module.aws-vpc.vpc_id
  eks_subnet_ids     = module.aws-vpc.pvt_subnet_ids
  eks_endpoint_sg_id = module.aws-vpc.eks_endpoint_sg_id
  eks_instance_types = var.eks_instance_types
  node_count         = var.node_count
  eks_version        = var.eks_version
}

module "aws-s3" {
  source      = "./modules/s3"
  project     = var.project
  environment = var.environment
}