module "aws-vpc" {
  source              = "./modules/vpc"
  project             = var.project
  main_vpc_cidr_block = var.main_vpc_cidr_block
  az_set              = var.az_set
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  enable_natgw        = var.enable_natgw
}


module "aws-eks" {
  source             = "./modules/eks"
  project            = var.project
  eks_vpc_id         = module.aws-vpc.vpc_id
  eks_subnet_ids     = module.aws-vpc.pvt_subnet_ids
  eks_endpoint_sg_id = module.aws-vpc.eks_endpoint_sg_id
  eks_instance_types = var.eks_instance_types
  node_count         = var.node_count
  node_max_count     = var.node_max_count
  node_min_count     = var.node_min_count
  eks_version        = var.eks_version
}

module "aws-s3" {
  source  = "./modules/s3"
  project = var.project
}

module "helm" {
  depends_on              = [module.aws-eks.name]
  source                  = "./modules/helm"
  gitlab_url              = var.gitlab_url
  gitlab_reg_token_map    = var.gitlab_reg_token_map
  runner_concurrent_count = var.runner_concurrent_count
  runner_helm_version     = var.runner_helm_version
  aws_region              = var.aws_region
  s3_bucket_name          = module.aws-s3.s3_bucket_name
}