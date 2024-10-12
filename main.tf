provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  public_subnet_cidr = "10.0.1.0/24"
}

module "iam" {
  source = "./modules/iam"
}

module "eks" {
  depends_on = [module.vpc]
  source = "./modules/ekscl"
  
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn = module.iam.node_role_arn
  
}
